From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/22] zfcp: Update FCP protocol related code
Date: Tue, 24 Nov 2009 16:54:08 +0100
Message-ID: <20091124160137.738445000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39605 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406AbZKXQCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:02:18 -0500
Content-Disposition: inline; filename=711-zfcp-protocol-code.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use common data structures for FCP CMND, FCP RSP and related
definitions and remove zfcp private definitions. Split the FCP CMND
setup and FCP RSP evaluation code in seperate functions. Use inline
functions to not negatively impact the I/O path.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  |   35 +++++++------
 drivers/s390/scsi/zfcp_dbf.h  |    3 -
 drivers/s390/scsi/zfcp_def.h  |   57 ---------------------
 drivers/s390/scsi/zfcp_ext.h  |    1 
 drivers/s390/scsi/zfcp_fc.h   |  112 ++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c  |   97 ++++++------------------------------
 drivers/s390/scsi/zfcp_scsi.c |   20 +------
 7 files changed, 156 insertions(+), 169 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 15:42:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 15:42:54.000000000 +0100
@@ -870,8 +870,9 @@ void _zfcp_dbf_scsi(const char *tag, con
 	struct zfcp_dbf_scsi_record *rec = &dbf->scsi_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
 	unsigned long flags;
-	struct fcp_rsp_iu *fcp_rsp;
-	char *fcp_rsp_info = NULL, *fcp_sns_info = NULL;
+	struct fcp_resp_with_ext *fcp_rsp;
+	struct fcp_resp_rsp_info *fcp_rsp_info = NULL;
+	char *fcp_sns_info = NULL;
 	int offset = 0, buflen = 0;
 
 	spin_lock_irqsave(&dbf->scsi_lock, flags);
@@ -895,20 +896,22 @@ void _zfcp_dbf_scsi(const char *tag, con
 				rec->scsi_allowed = scsi_cmnd->allowed;
 			}
 			if (fsf_req != NULL) {
-				fcp_rsp = (struct fcp_rsp_iu *)
-				    &(fsf_req->qtcb->bottom.io.fcp_rsp);
-				fcp_rsp_info = (unsigned char *) &fcp_rsp[1];
-				fcp_sns_info =
-				    zfcp_get_fcp_sns_info_ptr(fcp_rsp);
-
-				rec->rsp_validity = fcp_rsp->validity.value;
-				rec->rsp_scsi_status = fcp_rsp->scsi_status;
-				rec->rsp_resid = fcp_rsp->fcp_resid;
-				if (fcp_rsp->validity.bits.fcp_rsp_len_valid)
-					rec->rsp_code = *(fcp_rsp_info + 3);
-				if (fcp_rsp->validity.bits.fcp_sns_len_valid) {
-					buflen = min((int)fcp_rsp->fcp_sns_len,
-						     ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO);
+				fcp_rsp = (struct fcp_resp_with_ext *)
+					&(fsf_req->qtcb->bottom.io.fcp_rsp);
+				fcp_rsp_info = (struct fcp_resp_rsp_info *)
+					&fcp_rsp[1];
+				fcp_sns_info = (char *) &fcp_rsp[1];
+				if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL)
+					fcp_sns_info += fcp_rsp->ext.fr_sns_len;
+
+				rec->rsp_validity = fcp_rsp->resp.fr_flags;
+				rec->rsp_scsi_status = fcp_rsp->resp.fr_status;
+				rec->rsp_resid = fcp_rsp->ext.fr_resid;
+				if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL)
+					rec->rsp_code = fcp_rsp_info->rsp_code;
+				if (fcp_rsp->resp.fr_flags & FCP_SNS_LEN_VAL) {
+					buflen = min(fcp_rsp->ext.fr_sns_len,
+					   (u32)ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO);
 					rec->sns_info_len = buflen;
 					memcpy(rec->sns_info, fcp_sns_info,
 					       min(buflen,
--- a/drivers/s390/scsi/zfcp_dbf.h	2009-11-24 15:42:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.h	2009-11-24 15:42:54.000000000 +0100
@@ -22,6 +22,7 @@
 #ifndef ZFCP_DBF_H
 #define ZFCP_DBF_H
 
+#include <scsi/fc/fc_fcp.h>
 #include "zfcp_ext.h"
 #include "zfcp_fsf.h"
 #include "zfcp_def.h"
@@ -343,7 +344,7 @@ static inline
 void zfcp_dbf_scsi_devreset(const char *tag, u8 flag, struct zfcp_unit *unit,
 			    struct scsi_cmnd *scsi_cmnd)
 {
-	zfcp_dbf_scsi(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
+	zfcp_dbf_scsi(flag == FCP_TMF_TGT_RESET ? "trst" : "lrst", tag, 1,
 			    unit->port->adapter->dbf, scsi_cmnd, NULL, 0);
 }
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 15:42:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 15:42:54.000000000 +0100
@@ -73,65 +73,8 @@
 
 /*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
 
-/* task attribute values in FCP-2 FCP_CMND IU */
-#define SIMPLE_Q	0
-#define HEAD_OF_Q	1
-#define ORDERED_Q	2
-#define ACA_Q		4
-#define UNTAGGED	5
-
-/* task management flags in FCP-2 FCP_CMND IU */
-#define FCP_CLEAR_ACA		0x40
-#define FCP_TARGET_RESET	0x20
-#define FCP_LOGICAL_UNIT_RESET	0x10
-#define FCP_CLEAR_TASK_SET	0x04
-#define FCP_ABORT_TASK_SET	0x02
-
-#define FCP_CDB_LENGTH		16
-
 #define ZFCP_DID_MASK           0x00FFFFFF
 
-/* FCP(-2) FCP_CMND IU */
-struct fcp_cmnd_iu {
-	u64 fcp_lun;	   /* FCP logical unit number */
-	u8  crn;	           /* command reference number */
-	u8  reserved0:5;	   /* reserved */
-	u8  task_attribute:3;	   /* task attribute */
-	u8  task_management_flags; /* task management flags */
-	u8  add_fcp_cdb_length:6;  /* additional FCP_CDB length */
-	u8  rddata:1;              /* read data */
-	u8  wddata:1;              /* write data */
-	u8  fcp_cdb[FCP_CDB_LENGTH];
-} __attribute__((packed));
-
-/* FCP(-2) FCP_RSP IU */
-struct fcp_rsp_iu {
-	u8  reserved0[10];
-	union {
-		struct {
-			u8 reserved1:3;
-			u8 fcp_conf_req:1;
-			u8 fcp_resid_under:1;
-			u8 fcp_resid_over:1;
-			u8 fcp_sns_len_valid:1;
-			u8 fcp_rsp_len_valid:1;
-		} bits;
-		u8 value;
-	} validity;
-	u8  scsi_status;
-	u32 fcp_resid;
-	u32 fcp_sns_len;
-	u32 fcp_rsp_len;
-} __attribute__((packed));
-
-
-#define RSP_CODE_GOOD		 0
-#define RSP_CODE_LENGTH_MISMATCH 1
-#define RSP_CODE_FIELD_INVALID	 2
-#define RSP_CODE_RO_MISMATCH	 3
-#define RSP_CODE_TASKMAN_UNSUPP	 4
-#define RSP_CODE_TASKMAN_FAILED	 5
-
 /* see fc-fs */
 #define LS_RSCN  0x61
 #define LS_LOGO  0x05
--- a/drivers/s390/scsi/zfcp_ext.h	2009-11-24 15:42:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-11-24 15:42:54.000000000 +0100
@@ -154,7 +154,6 @@ extern void zfcp_qdio_close(struct zfcp_
 extern struct zfcp_data zfcp_data;
 extern int zfcp_adapter_scsi_register(struct zfcp_adapter *);
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
-extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
 extern struct fc_function_template zfcp_transport_functions;
 extern void zfcp_scsi_rport_work(struct work_struct *);
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/s390/scsi/zfcp_fc.h	2009-11-24 15:42:54.000000000 +0100
@@ -0,0 +1,112 @@
+/*
+ * zfcp device driver
+ *
+ * Fibre Channel related definitions and inline functions for the zfcp
+ * device driver
+ *
+ * Copyright IBM Corporation 2009
+ */
+
+#ifndef ZFCP_FC_H
+#define ZFCP_FC_H
+
+#include <scsi/fc/fc_fcp.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
+
+/**
+ * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
+ * @fcp: fcp_cmnd to setup
+ * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
+ */
+static inline
+void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
+{
+	char tag[2];
+
+	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
+
+	if (scsi_populate_tag_msg(scsi, tag)) {
+		switch (tag[0]) {
+		case MSG_ORDERED_TAG:
+			fcp->fc_pri_ta |= FCP_PTA_ORDERED;
+			break;
+		case MSG_SIMPLE_TAG:
+			fcp->fc_pri_ta |= FCP_PTA_SIMPLE;
+			break;
+		};
+	} else
+		fcp->fc_pri_ta = FCP_PTA_SIMPLE;
+
+	if (scsi->sc_data_direction == DMA_FROM_DEVICE)
+		fcp->fc_flags |= FCP_CFL_RDDATA;
+	if (scsi->sc_data_direction == DMA_TO_DEVICE)
+		fcp->fc_flags |= FCP_CFL_WRDATA;
+
+	memcpy(fcp->fc_cdb, scsi->cmnd, scsi->cmd_len);
+
+	fcp->fc_dl = scsi_bufflen(scsi);
+}
+
+/**
+ * zfcp_fc_fcp_tm - setup FCP command as task management command
+ * @fcp: fcp_cmnd to setup
+ * @dev: scsi_device where to send the task management command
+ * @tm: task management flags to setup tm command
+ */
+static inline
+void zfcp_fc_fcp_tm(struct fcp_cmnd *fcp, struct scsi_device *dev, u8 tm_flags)
+{
+	int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
+	fcp->fc_tm_flags |= tm_flags;
+}
+
+/**
+ * zfcp_fc_evap_fcp_rsp - evaluate FCP RSP IU and update scsi_cmnd accordingly
+ * @fcp_rsp: FCP RSP IU to evaluate
+ * @scsi: SCSI command where to update status and sense buffer
+ */
+static inline
+void zfcp_fc_eval_fcp_rsp(struct fcp_resp_with_ext *fcp_rsp,
+			  struct scsi_cmnd *scsi)
+{
+	struct fcp_resp_rsp_info *rsp_info;
+	char *sense;
+	u32 sense_len, resid;
+	u8 rsp_flags;
+
+	set_msg_byte(scsi, COMMAND_COMPLETE);
+	scsi->result |= fcp_rsp->resp.fr_status;
+
+	rsp_flags = fcp_rsp->resp.fr_flags;
+
+	if (unlikely(rsp_flags & FCP_RSP_LEN_VAL)) {
+		rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
+		if (rsp_info->rsp_code == FCP_TMF_CMPL)
+			set_host_byte(scsi, DID_OK);
+		else {
+			set_host_byte(scsi, DID_ERROR);
+			return;
+		}
+	}
+
+	if (unlikely(rsp_flags & FCP_SNS_LEN_VAL)) {
+		sense = (char *) &fcp_rsp[1];
+		if (rsp_flags & FCP_RSP_LEN_VAL)
+			sense += fcp_rsp->ext.fr_sns_len;
+		sense_len = min(fcp_rsp->ext.fr_sns_len,
+				(u32) SCSI_SENSE_BUFFERSIZE);
+		memcpy(scsi->sense_buffer, sense, sense_len);
+	}
+
+	if (unlikely(rsp_flags & FCP_RESID_UNDER)) {
+		resid = fcp_rsp->ext.fr_resid;
+		scsi_set_resid(scsi, resid);
+		if (scsi_bufflen(scsi) - resid < scsi->underflow &&
+		     !(rsp_flags & FCP_SNS_LEN_VAL) &&
+		     fcp_rsp->resp.fr_status == SAM_STAT_GOOD)
+			set_host_byte(scsi, DID_ERROR);
+	}
+}
+
+#endif
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 15:42:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 15:42:54.000000000 +0100
@@ -11,6 +11,7 @@
 
 #include <linux/blktrace_api.h>
 #include "zfcp_ext.h"
+#include "zfcp_fc.h"
 #include "zfcp_dbf.h"
 
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
@@ -2159,10 +2160,7 @@ static void zfcp_fsf_req_trace(struct zf
 static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_cmnd *scpnt;
-	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
-	    &(req->qtcb->bottom.io.fcp_rsp);
-	u32 sns_len;
-	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
+	struct fcp_resp_with_ext *fcp_rsp;
 	unsigned long flags;
 
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
@@ -2183,37 +2181,11 @@ static void zfcp_fsf_send_fcp_command_ta
 		goto skip_fsfstatus;
 	}
 
-	set_msg_byte(scpnt, COMMAND_COMPLETE);
-
-	scpnt->result |= fcp_rsp_iu->scsi_status;
+	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
 
 	zfcp_fsf_req_trace(req, scpnt);
 
-	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
-		if (fcp_rsp_info[3] == RSP_CODE_GOOD)
-			set_host_byte(scpnt, DID_OK);
-		else {
-			set_host_byte(scpnt, DID_ERROR);
-			goto skip_fsfstatus;
-		}
-	}
-
-	if (unlikely(fcp_rsp_iu->validity.bits.fcp_sns_len_valid)) {
-		sns_len = FSF_FCP_RSP_SIZE - sizeof(struct fcp_rsp_iu) +
-			  fcp_rsp_iu->fcp_rsp_len;
-		sns_len = min(sns_len, (u32) SCSI_SENSE_BUFFERSIZE);
-		sns_len = min(sns_len, fcp_rsp_iu->fcp_sns_len);
-
-		memcpy(scpnt->sense_buffer,
-		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
-	}
-
-	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_under)) {
-		scsi_set_resid(scpnt, fcp_rsp_iu->fcp_resid);
-		if (scsi_bufflen(scpnt) - scsi_get_resid(scpnt) <
-		    scpnt->underflow)
-			set_host_byte(scpnt, DID_ERROR);
-	}
 skip_fsfstatus:
 	if (scpnt->result != 0)
 		zfcp_dbf_scsi_result("erro", 3, req->adapter->dbf, scpnt, req);
@@ -2235,11 +2207,13 @@ skip_fsfstatus:
 
 static void zfcp_fsf_send_fcp_ctm_handler(struct zfcp_fsf_req *req)
 {
-	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
-	    &(req->qtcb->bottom.io.fcp_rsp);
-	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
+	struct fcp_resp_with_ext *fcp_rsp;
+	struct fcp_resp_rsp_info *rsp_info;
+
+	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
 
-	if ((fcp_rsp_info[3] != RSP_CODE_GOOD) ||
+	if ((rsp_info->rsp_code != FCP_TMF_CMPL) ||
 	     (req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 }
@@ -2324,20 +2298,6 @@ skip_fsfstatus:
 	}
 }
 
-static void zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_cmd, u32 fcp_dl)
-{
-	u32 *fcp_dl_ptr;
-
-	/*
-	 * fcp_dl_addr = start address of fcp_cmnd structure +
-	 * size of fixed part + size of dynamically sized add_dcp_cdb field
-	 * SEE FCP-2 documentation
-	 */
-	fcp_dl_ptr = (u32 *) ((unsigned char *) &fcp_cmd[1] +
-			(fcp_cmd->add_fcp_cdb_length << 2));
-	*fcp_dl_ptr = fcp_dl;
-}
-
 /**
  * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
  * @unit: unit where command is sent to
@@ -2347,7 +2307,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 				   struct scsi_cmnd *scsi_cmnd)
 {
 	struct zfcp_fsf_req *req;
-	struct fcp_cmnd_iu *fcp_cmnd_iu;
+	struct fcp_cmnd *fcp_cmnd;
 	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
 	int real_bytes, retval = -EIO;
 	struct zfcp_adapter *adapter = unit->port->adapter;
@@ -2379,16 +2339,14 @@ int zfcp_fsf_send_fcp_command_task(struc
 	req->qtcb->header.lun_handle = unit->handle;
 	req->qtcb->header.port_handle = unit->port->handle;
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
+	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
 
 	scsi_cmnd->host_scribble = (unsigned char *) req->req_id;
 
-	fcp_cmnd_iu = (struct fcp_cmnd_iu *) &(req->qtcb->bottom.io.fcp_cmnd);
-	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
 	/*
 	 * set depending on data direction:
 	 *      data direction bits in SBALE (SB Type)
 	 *      data direction bits in QTCB
-	 *      data direction bits in FCP_CMND IU
 	 */
 	switch (scsi_cmnd->sc_data_direction) {
 	case DMA_NONE:
@@ -2396,32 +2354,17 @@ int zfcp_fsf_send_fcp_command_task(struc
 		break;
 	case DMA_FROM_DEVICE:
 		req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
-		fcp_cmnd_iu->rddata = 1;
 		break;
 	case DMA_TO_DEVICE:
 		req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
 		sbtype = SBAL_FLAGS0_TYPE_WRITE;
-		fcp_cmnd_iu->wddata = 1;
 		break;
 	case DMA_BIDIRECTIONAL:
 		goto failed_scsi_cmnd;
 	}
 
-	if (likely((scsi_cmnd->device->simple_tags) ||
-		   ((atomic_read(&unit->status) & ZFCP_STATUS_UNIT_READONLY) &&
-		    (atomic_read(&unit->status) & ZFCP_STATUS_UNIT_SHARED))))
-		fcp_cmnd_iu->task_attribute = SIMPLE_Q;
-	else
-		fcp_cmnd_iu->task_attribute = UNTAGGED;
-
-	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH))
-		fcp_cmnd_iu->add_fcp_cdb_length =
-			(scsi_cmnd->cmd_len - FCP_CDB_LENGTH) >> 2;
-
-	memcpy(fcp_cmnd_iu->fcp_cdb, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
-
-	req->qtcb->bottom.io.fcp_cmnd_length = sizeof(struct fcp_cmnd_iu) +
-		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(u32);
+	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
+	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
 	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->queue_req, sbtype,
 					     scsi_sglist(scsi_cmnd),
@@ -2439,8 +2382,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 		goto failed_scsi_cmnd;
 	}
 
-	zfcp_set_fcp_dl(fcp_cmnd_iu, real_bytes);
-
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
 		goto failed_scsi_cmnd;
@@ -2466,7 +2407,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
-	struct fcp_cmnd_iu *fcp_cmnd_iu;
+	struct fcp_cmnd *fcp_cmnd;
 	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
 
 	if (unlikely(!(atomic_read(&unit->status) &
@@ -2492,16 +2433,14 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->header.port_handle = unit->port->handle;
 	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.io.fcp_cmnd_length = 	sizeof(struct fcp_cmnd_iu) +
-						sizeof(u32);
+	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
 
 	sbale = zfcp_qdio_sbale_req(qdio, &req->queue_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	fcp_cmnd_iu = (struct fcp_cmnd_iu *) &req->qtcb->bottom.io.fcp_cmnd;
-	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
-	fcp_cmnd_iu->task_management_flags = tm_flags;
+	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
+	zfcp_fc_fcp_tm(fcp_cmnd, unit->device, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 15:42:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 15:42:54.000000000 +0100
@@ -9,6 +9,8 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/types.h>
+#include <scsi/fc/fc_fcp.h>
 #include <asm/atomic.h>
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
@@ -17,18 +19,6 @@ static unsigned int default_depth = 32;
 module_param_named(queue_depth, default_depth, uint, 0600);
 MODULE_PARM_DESC(queue_depth, "Default queue depth for new SCSI devices");
 
-/* Find start of Sense Information in FCP response unit*/
-char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
-{
-	char *fcp_sns_info_ptr;
-
-	fcp_sns_info_ptr = (unsigned char *) &fcp_rsp_iu[1];
-	if (fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)
-		fcp_sns_info_ptr += fcp_rsp_iu->fcp_rsp_len;
-
-	return fcp_sns_info_ptr;
-}
-
 static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
 					int reason)
 {
@@ -283,12 +273,12 @@ static int zfcp_task_mgmt_function(struc
 
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_LOGICAL_UNIT_RESET);
+	return zfcp_task_mgmt_function(scpnt, FCP_TMF_LUN_RESET);
 }
 
 static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_TARGET_RESET);
+	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
 }
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
@@ -325,7 +315,7 @@ int zfcp_adapter_scsi_register(struct zf
 	adapter->scsi_host->max_lun = 1;
 	adapter->scsi_host->max_channel = 0;
 	adapter->scsi_host->unique_id = dev_id.devno;
-	adapter->scsi_host->max_cmd_len = 255;
+	adapter->scsi_host->max_cmd_len = 16; /* in struct fcp_cmnd */
 	adapter->scsi_host->transportt = zfcp_data.scsi_transport_template;
 
 	adapter->scsi_host->hostdata[0] = (unsigned long) adapter;

