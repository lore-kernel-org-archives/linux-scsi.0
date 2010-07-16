From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/10] zfcp: Introduce experimental support for DIF/DIX
Date: Fri, 16 Jul 2010 15:37:42 +0200
Message-ID: <20100716134300.985875000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60697 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965624Ab0GPNnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:04 -0400
Content-Disposition: inline; filename=linux-2.6.34-zfcp-san0616.3-e2e.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Felix Beck <felix.beck@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Felix Beck <felix.beck@de.ibm.com>

Introduce support for DIF/DIX in zfcp: Report the capabilities for the
Scsi_host, map the protection data when issuing I/O requests and
handle the new error codes. Also add the fsf data_direction field to
the hba trace, it is useful information for debugging in that area.
This is an EXPERIMENTAL feature for now.

Signed-off-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |    3 +
 drivers/s390/scsi/zfcp_dbf.h  |    1 
 drivers/s390/scsi/zfcp_ext.h  |    2 
 drivers/s390/scsi/zfcp_fc.h   |    3 +
 drivers/s390/scsi/zfcp_fsf.c  |  109 +++++++++++++++++++++++++++++++++---------
 drivers/s390/scsi/zfcp_fsf.h  |   24 ++++++++-
 drivers/s390/scsi/zfcp_qdio.c |    4 -
 drivers/s390/scsi/zfcp_qdio.h |   16 ++++++
 drivers/s390/scsi/zfcp_scsi.c |   53 ++++++++++++++++++++
 drivers/scsi/Kconfig          |    4 +
 10 files changed, 189 insertions(+), 30 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -155,6 +155,8 @@ void _zfcp_dbf_hba_fsf_response(const ch
 		if (scsi_cmnd) {
 			response->u.fcp.cmnd = (unsigned long)scsi_cmnd;
 			response->u.fcp.serial = scsi_cmnd->serial_number;
+			response->u.fcp.data_dir =
+				qtcb->bottom.io.data_direction;
 		}
 		break;
 
@@ -326,6 +328,7 @@ static void zfcp_dbf_hba_view_response(c
 	case FSF_QTCB_FCP_CMND:
 		if (r->fsf_req_status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
 			break;
+		zfcp_dbf_out(p, "data_direction", "0x%04x", r->u.fcp.data_dir);
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
 		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
 		*p += sprintf(*p, "\n");
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -111,6 +111,7 @@ struct zfcp_dbf_hba_record_response {
 		struct {
 			u64 cmnd;
 			u64 serial;
+			u32 data_dir;
 		} fcp;
 		struct {
 			u64 wwpn;
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -164,6 +164,8 @@ extern void zfcp_scsi_schedule_rport_blo
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
 extern void zfcp_scsi_scan(struct zfcp_unit *);
 extern void zfcp_scsi_scan_work(struct work_struct *);
+extern void zfcp_scsi_set_prot(struct zfcp_adapter *);
+extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
 
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -220,6 +220,9 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd
 	memcpy(fcp->fc_cdb, scsi->cmnd, scsi->cmd_len);
 
 	fcp->fc_dl = scsi_bufflen(scsi);
+
+	if (scsi_get_prot_type(scsi) == SCSI_PROT_DIF_TYPE1)
+		fcp->fc_dl += fcp->fc_dl / scsi->device->sector_size * 8;
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -526,6 +526,8 @@ static int zfcp_fsf_exchange_config_eval
 		return -EIO;
 	}
 
+	zfcp_scsi_set_prot(adapter);
+
 	return 0;
 }
 
@@ -988,6 +990,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req, sg_req);
 	if (bytes <= 0)
 		return -EIO;
+	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
 	req->qtcb->bottom.support.req_buf_length = bytes;
 	zfcp_qdio_skip_to_last_sbale(&req->qdio_req);
 
@@ -996,6 +999,7 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	req->qtcb->bottom.support.resp_buf_length = bytes;
 	if (bytes <= 0)
 		return -EIO;
+	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
 
 	return 0;
 }
@@ -2038,9 +2042,13 @@ static void zfcp_fsf_req_trace(struct zf
 		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
 
 		switch (req->qtcb->bottom.io.data_direction) {
+		case FSF_DATADIR_DIF_READ_STRIP:
+		case FSF_DATADIR_DIF_READ_CONVERT:
 		case FSF_DATADIR_READ:
 			lat = &unit->latencies.read;
 			break;
+		case FSF_DATADIR_DIF_WRITE_INSERT:
+		case FSF_DATADIR_DIF_WRITE_CONVERT:
 		case FSF_DATADIR_WRITE:
 			lat = &unit->latencies.write;
 			break;
@@ -2081,6 +2089,21 @@ static void zfcp_fsf_send_fcp_command_ta
 		goto skip_fsfstatus;
 	}
 
+	switch (req->qtcb->header.fsf_status) {
+	case FSF_INCONSISTENT_PROT_DATA:
+	case FSF_INVALID_PROT_PARM:
+		set_host_byte(scpnt, DID_ERROR);
+		goto skip_fsfstatus;
+	case FSF_BLOCK_GUARD_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x1);
+		goto skip_fsfstatus;
+	case FSF_APP_TAG_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x2);
+		goto skip_fsfstatus;
+	case FSF_REF_TAG_CHECK_FAILURE:
+		zfcp_scsi_dif_sense_error(scpnt, 0x3);
+		goto skip_fsfstatus;
+	}
 	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
 	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
 
@@ -2190,6 +2213,44 @@ skip_fsfstatus:
 	}
 }
 
+static int zfcp_fsf_set_data_dir(struct scsi_cmnd *scsi_cmnd, u32 *data_dir)
+{
+	switch (scsi_get_prot_op(scsi_cmnd)) {
+	case SCSI_PROT_NORMAL:
+		switch (scsi_cmnd->sc_data_direction) {
+		case DMA_NONE:
+			*data_dir = FSF_DATADIR_CMND;
+			break;
+		case DMA_FROM_DEVICE:
+			*data_dir = FSF_DATADIR_READ;
+			break;
+		case DMA_TO_DEVICE:
+			*data_dir = FSF_DATADIR_WRITE;
+			break;
+		case DMA_BIDIRECTIONAL:
+			return -EINVAL;
+		}
+		break;
+
+	case SCSI_PROT_READ_STRIP:
+		*data_dir = FSF_DATADIR_DIF_READ_STRIP;
+		break;
+	case SCSI_PROT_WRITE_INSERT:
+		*data_dir = FSF_DATADIR_DIF_WRITE_INSERT;
+		break;
+	case SCSI_PROT_READ_PASS:
+		*data_dir = FSF_DATADIR_DIF_READ_CONVERT;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		*data_dir = FSF_DATADIR_DIF_WRITE_CONVERT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
  * @unit: unit where command is sent to
@@ -2201,9 +2262,10 @@ int zfcp_fsf_send_fcp_command_task(struc
 	struct zfcp_fsf_req *req;
 	struct fcp_cmnd *fcp_cmnd;
 	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
-	int real_bytes, retval = -EIO;
+	int real_bytes, retval = -EIO, dix_bytes = 0;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
+	struct fsf_qtcb_bottom_io *io;
 
 	if (unlikely(!(atomic_read(&unit->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
@@ -2226,46 +2288,46 @@ int zfcp_fsf_send_fcp_command_task(struc
 		goto out;
 	}
 
+	scsi_cmnd->host_scribble = (unsigned char *) req->req_id;
+
+	io = &req->qtcb->bottom.io;
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	req->unit = unit;
 	req->data = scsi_cmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
 	req->qtcb->header.lun_handle = unit->handle;
 	req->qtcb->header.port_handle = unit->port->handle;
-	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
+	io->service_class = FSF_CLASS_3;
+	io->fcp_cmnd_length = FCP_CMND_LEN;
 
-	scsi_cmnd->host_scribble = (unsigned char *) req->req_id;
-
-	/*
-	 * set depending on data direction:
-	 *      data direction bits in SBALE (SB Type)
-	 *      data direction bits in QTCB
-	 */
-	switch (scsi_cmnd->sc_data_direction) {
-	case DMA_NONE:
-		req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
-		break;
-	case DMA_FROM_DEVICE:
-		req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
-		break;
-	case DMA_TO_DEVICE:
-		req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
-		break;
-	case DMA_BIDIRECTIONAL:
-		goto failed_scsi_cmnd;
+	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
+		io->data_block_length = scsi_cmnd->device->sector_size;
+		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
 	}
 
+	zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction);
+
 	get_device(&unit->dev);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
+	if (scsi_prot_sg_count(scsi_cmnd)) {
+		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
+				       scsi_prot_sg_count(scsi_cmnd));
+		dix_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
+						scsi_prot_sglist(scsi_cmnd));
+		io->prot_data_length = dix_bytes;
+	}
+
 	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
 					     scsi_sglist(scsi_cmnd));
-	if (unlikely(real_bytes < 0))
+
+	if (unlikely(real_bytes < 0) || unlikely(dix_bytes < 0))
 		goto failed_scsi_cmnd;
 
+	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
+
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
 		goto failed_scsi_cmnd;
@@ -2389,6 +2451,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		zfcp_fsf_req_free(req);
 		goto out;
 	}
+	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -80,11 +80,15 @@
 #define FSF_REQUEST_SIZE_TOO_LARGE		0x00000061
 #define FSF_RESPONSE_SIZE_TOO_LARGE		0x00000062
 #define FSF_SBAL_MISMATCH			0x00000063
+#define FSF_INCONSISTENT_PROT_DATA		0x00000070
+#define FSF_INVALID_PROT_PARM			0x00000071
+#define FSF_BLOCK_GUARD_CHECK_FAILURE		0x00000081
+#define FSF_APP_TAG_CHECK_FAILURE		0x00000082
+#define FSF_REF_TAG_CHECK_FAILURE		0x00000083
 #define FSF_ADAPTER_STATUS_AVAILABLE		0x000000AD
 #define FSF_UNKNOWN_COMMAND			0x000000E2
 #define FSF_UNKNOWN_OP_SUBTYPE                  0x000000E3
 #define FSF_INVALID_COMMAND_OPTION              0x000000E5
-/* #define FSF_ERROR                             0x000000FF  */
 
 #define FSF_PROT_STATUS_QUAL_SIZE		16
 #define FSF_STATUS_QUALIFIER_SIZE		16
@@ -147,6 +151,13 @@
 #define FSF_DATADIR_WRITE			0x00000001
 #define FSF_DATADIR_READ			0x00000002
 #define FSF_DATADIR_CMND			0x00000004
+#define FSF_DATADIR_DIF_WRITE_INSERT		0x00000009
+#define FSF_DATADIR_DIF_READ_STRIP		0x0000000a
+#define FSF_DATADIR_DIF_WRITE_CONVERT		0x0000000b
+#define FSF_DATADIR_DIF_READ_CONVERT		0X0000000c
+
+/* data protection control flags */
+#define FSF_APP_TAG_CHECK_ENABLE		0x10
 
 /* fc service class */
 #define FSF_CLASS_3				0x00000003
@@ -162,6 +173,8 @@
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS	0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
 #define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
+#define FSF_FEATURE_DIF_PROT_TYPE1		0x00010000
+#define FSF_FEATURE_DIX_PROT_TCPIP		0x00020000
 
 /* host connection features */
 #define FSF_FEATURE_NPIV_MODE			0x00000001
@@ -316,9 +329,14 @@ struct fsf_qtcb_header {
 struct fsf_qtcb_bottom_io {
 	u32 data_direction;
 	u32 service_class;
-	u8  res1[8];
+	u8  res1;
+	u8  data_prot_flags;
+	u16 app_tag_value;
+	u32 ref_tag_value;
 	u32 fcp_cmnd_length;
-	u8  res2[12];
+	u32 data_block_length;
+	u32 prot_data_length;
+	u8  res2[4];
 	u8  fcp_cmnd[FSF_FCP_CMND_SIZE];
 	u8  fcp_rsp[FSF_FCP_RSP_SIZE];
 	u8  res3[64];
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -193,10 +193,6 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 		bytes += sg->length;
 	}
 
-	/* assume that no other SBALEs are to follow in the same SBAL */
-	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
-
 	return bytes;
 }
 
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -215,4 +215,20 @@ void zfcp_qdio_sbal_limit(struct zfcp_qd
 				QDIO_MAX_BUFFERS_PER_Q;
 }
 
+/**
+ * zfcp_qdio_set_data_div - set data division count
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: The current zfcp_qdio_req
+ * @count: The data division count
+ */
+static inline
+void zfcp_qdio_set_data_div(struct zfcp_qdio *qdio,
+			    struct zfcp_qdio_req *q_req, u32 count)
+{
+	struct qdio_buffer_element *sbale;
+
+	sbale = &qdio->req_q[q_req->sbal_first]->element[0];
+	sbale->length = count;
+}
+
 #endif /* ZFCP_QDIO_H */
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <scsi/fc/fc_fcp.h>
+#include <scsi/scsi_eh.h>
 #include <asm/atomic.h>
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
@@ -22,6 +23,13 @@ static unsigned int default_depth = 32;
 module_param_named(queue_depth, default_depth, uint, 0600);
 MODULE_PARM_DESC(queue_depth, "Default queue depth for new SCSI devices");
 
+static bool enable_dif;
+
+#ifdef CONFIG_ZFCP_DIF
+module_param_named(dif, enable_dif, bool, 0600);
+MODULE_PARM_DESC(dif, "Enable DIF/DIX data integrity support");
+#endif
+
 static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
 					int reason)
 {
@@ -652,6 +660,51 @@ void zfcp_scsi_scan_work(struct work_str
 	put_device(&unit->dev);
 }
 
+/**
+ * zfcp_scsi_set_prot - Configure DIF/DIX support in scsi_host
+ * @adapter: The adapter where to configure DIF/DIX for the SCSI host
+ */
+void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
+{
+	unsigned int mask = 0;
+	unsigned int data_div;
+	struct Scsi_Host *shost = adapter->scsi_host;
+
+	data_div = atomic_read(&adapter->status) &
+		   ZFCP_STATUS_ADAPTER_DATA_DIV_ENABLED;
+
+	if (enable_dif &&
+	    adapter->adapter_features & FSF_FEATURE_DIF_PROT_TYPE1)
+		mask |= SHOST_DIF_TYPE1_PROTECTION;
+
+	if (enable_dif && data_div &&
+	    adapter->adapter_features & FSF_FEATURE_DIX_PROT_TCPIP) {
+		mask |= SHOST_DIX_TYPE1_PROTECTION;
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP);
+		shost->sg_tablesize = ZFCP_QDIO_MAX_SBALES_PER_REQ / 2;
+		shost->max_sectors = ZFCP_QDIO_MAX_SBALES_PER_REQ * 8 / 2;
+	}
+
+	scsi_host_set_prot(shost, mask);
+}
+
+/**
+ * zfcp_scsi_dif_sense_error - Report DIF/DIX error as driver sense error
+ * @scmd: The SCSI command to report the error for
+ * @ascq: The ASCQ to put in the sense buffer
+ *
+ * See the error handling in sd_done for the sense codes used here.
+ * Set DID_SOFT_ERROR to retry the request, if possible.
+ */
+void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
+{
+	scsi_build_sense_buffer(1, scmd->sense_buffer,
+				ILLEGAL_REQUEST, 0x10, ascq);
+	set_driver_byte(scmd, DRIVER_SENSE);
+	scmd->result |= SAM_STAT_CHECK_CONDITION;
+	set_host_byte(scmd, DID_SOFT_ERROR);
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1847,6 +1847,10 @@ config ZFCP
           called zfcp. If you want to compile it as a module, say M here
           and read <file:Documentation/kbuild/modules.txt>.
 
+config ZFCP_DIF
+	tristate "T10 DIF/DIX support for the zfcp driver (EXPERIMENTAL)"
+	depends on ZFCP && EXPERIMENTAL
+
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
 	depends on PCI && SCSI

