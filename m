From: brking@us.ibm.com
Subject: [PATCH 20/26] ipr: Support new device queueing model
Date: Tue, 01 Nov 2005 17:02:22 -0600
Message-ID: <200511012302.jA1N2NQ2001475@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55256 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751416AbVKAXCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:25 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2O5c018276
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:24 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2O5c105536
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:24 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2OWS001513
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


New ipr adapters support a new device queueing model in the
adapter firmware. The queueing model is the NACA queueing model,
but it does not mean use of NACA is required. The new model removes
some of the adapter firmware queue state that made handling QERR=0
almost impossible. The queueing model on older adapters included the
concept of a queue frozen state, which would freeze the response
queue in the adapter when a check condition occurred, requiring a
a primitive to resume the queue. The new queueing model removes this
complexity.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   59 ++++++++++++++++++++++++++++-------
 linux-2.6-bjking1/drivers/scsi/ipr.h |   18 ++++++++++
 2 files changed, 66 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_queueing_model drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_queueing_model	2005-11-01 16:08:13.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:13.000000000 -0600
@@ -302,6 +302,10 @@ struct ipr_config_table_entry {
 #define IPR_SUBTYPE_GENERIC_SCSI	1
 #define IPR_SUBTYPE_VOLUME_SET		2
 
+#define IPR_QUEUEING_MODEL(res)	((((res)->cfgte.flags) & 0x70) >> 4)
+#define IPR_QUEUE_FROZEN_MODEL	0
+#define IPR_QUEUE_NACA_MODEL		1
+
 	struct ipr_res_addr res_addr;
 	__be32 res_handle;
 	__be32 reserved4[2];
@@ -1295,6 +1299,20 @@ static inline int ipr_is_gscsi(struct ip
 }
 
 /**
+ * ipr_is_naca_model - Determine if a resource is using NACA queueing model
+ * @res:	resource entry struct
+ *
+ * Return value:
+ * 	1 if NACA queueing model / 0 if not NACA queueing model
+ **/
+static inline int ipr_is_naca_model(struct ipr_resource_entry *res)
+{
+	if (ipr_is_gscsi(res) && IPR_QUEUEING_MODEL(res) == IPR_QUEUE_NACA_MODEL)
+		return 1;
+	return 0;
+}
+
+/**
  * ipr_is_device - Determine if resource address is that of a device
  * @res_addr:	resource address struct
  *
diff -puN drivers/scsi/ipr.c~ipr_queueing_model drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_queueing_model	2005-11-01 16:08:13.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:13.000000000 -0600
@@ -814,7 +814,7 @@ static void ipr_send_hcam(struct ipr_ioa
  **/
 static void ipr_init_res_entry(struct ipr_resource_entry *res)
 {
-	res->needs_sync_complete = 1;
+	res->needs_sync_complete = 0;
 	res->in_erp = 0;
 	res->add_to_ml = 0;
 	res->del_from_ml = 0;
@@ -3251,7 +3251,8 @@ static int ipr_slave_alloc(struct scsi_d
 			res->add_to_ml = 0;
 			res->in_erp = 0;
 			sdev->hostdata = res;
-			res->needs_sync_complete = 1;
+			if (!ipr_is_naca_model(res))
+				res->needs_sync_complete = 1;
 			rc = 0;
 			break;
 		}
@@ -3515,7 +3516,8 @@ static int ipr_cancel_op(struct scsi_cmn
 	}
 
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-	res->needs_sync_complete = 1;
+	if (!ipr_is_naca_model(res))
+		res->needs_sync_complete = 1;
 
 	LEAVE;
 	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
@@ -3819,7 +3821,8 @@ static void ipr_erp_done(struct ipr_cmnd
 	}
 
 	if (res) {
-		res->needs_sync_complete = 1;
+		if (!ipr_is_naca_model(res))
+			res->needs_sync_complete = 1;
 		res->in_erp = 0;
 	}
 	ipr_unmap_sglist(ioa_cfg, ipr_cmd);
@@ -4089,6 +4092,30 @@ static void ipr_gen_sense(struct ipr_cmn
 }
 
 /**
+ * ipr_get_autosense - Copy autosense data to sense buffer
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function copies the autosense buffer to the buffer
+ * in the scsi_cmd, if there is autosense available.
+ *
+ * Return value:
+ *	1 if autosense was available / 0 if not
+ **/
+static int ipr_get_autosense(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
+
+	if ((be32_to_cpu(ioasa->ioasc_specific) &
+	     (IPR_ADDITIONAL_STATUS_FMT | IPR_AUTOSENSE_VALID)) == 0)
+		return 0;
+
+	memcpy(ipr_cmd->scsi_cmd->sense_buffer, ioasa->auto_sense.data,
+	       min_t(u16, be16_to_cpu(ioasa->auto_sense.auto_sense_len),
+		   SCSI_SENSE_BUFFERSIZE));
+	return 1;
+}
+
+/**
  * ipr_erp_start - Process an error response for a SCSI op
  * @ioa_cfg:	ioa config struct
  * @ipr_cmd:	ipr command struct
@@ -4118,7 +4145,10 @@ static void ipr_erp_start(struct ipr_ioa
 
 	switch (ioasc & IPR_IOASC_IOASC_MASK) {
 	case IPR_IOASC_ABORTED_CMD_TERM_BY_HOST:
-		scsi_cmd->result |= (DID_IMM_RETRY << 16);
+		if (ipr_is_naca_model(res))
+			scsi_cmd->result |= (DID_ABORT << 16);
+		else
+			scsi_cmd->result |= (DID_IMM_RETRY << 16);
 		break;
 	case IPR_IOASC_IR_RESOURCE_HANDLE:
 	case IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA:
@@ -4126,7 +4156,8 @@ static void ipr_erp_start(struct ipr_ioa
 		break;
 	case IPR_IOASC_HW_SEL_TIMEOUT:
 		scsi_cmd->result |= (DID_NO_CONNECT << 16);
-		res->needs_sync_complete = 1;
+		if (!ipr_is_naca_model(res))
+			res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_SYNC_REQUIRED:
 		if (!res->in_erp)
@@ -4146,21 +4177,27 @@ static void ipr_erp_start(struct ipr_ioa
 		if (!res->resetting_device)
 			scsi_report_bus_reset(ioa_cfg->host, scsi_cmd->device->channel);
 		scsi_cmd->result |= (DID_ERROR << 16);
-		res->needs_sync_complete = 1;
+		if (!ipr_is_naca_model(res))
+			res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_HW_DEV_BUS_STATUS:
 		scsi_cmd->result |= IPR_IOASC_SENSE_STATUS(ioasc);
 		if (IPR_IOASC_SENSE_STATUS(ioasc) == SAM_STAT_CHECK_CONDITION) {
-			ipr_erp_cancel_all(ipr_cmd);
-			return;
+			if (!ipr_get_autosense(ipr_cmd)) {
+				if (!ipr_is_naca_model(res)) {
+					ipr_erp_cancel_all(ipr_cmd);
+					return;
+				}
+			}
 		}
-		res->needs_sync_complete = 1;
+		if (!ipr_is_naca_model(res))
+			res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
 		break;
 	default:
 		scsi_cmd->result |= (DID_ERROR << 16);
-		if (!ipr_is_vset_device(res))
+		if (!ipr_is_vset_device(res) && !ipr_is_naca_model(res))
 			res->needs_sync_complete = 1;
 		break;
 	}
_
