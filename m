From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC] Remove SUGGEST flags
Date: Sun, 04 Jan 2009 03:14:11 -0500
Message-ID: <yq1iqov4hf0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:65176 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZADIOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 03:14:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


The SUGGEST_* flags in the SCSI command result have been out of fashion
for a while and we don't actually use them in the error handling.
Remove the remaining occurrences.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

 drivers/s390/scsi/zfcp_fsf.c    |    1 -
 drivers/scsi/constants.c        |   11 ++---------
 drivers/scsi/hptiop.c           |    3 +--
 drivers/scsi/ips.c              |    3 +--
 drivers/scsi/libfc/fc_fcp.c     |    6 +++---
 drivers/scsi/lpfc/lpfc_scsi.c   |    6 +++---
 drivers/scsi/st.c               |    6 +++---
 drivers/usb/storage/transport.c |    2 +-
 include/scsi/scsi.h             |   11 -----------
 9 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2147,7 +2147,6 @@ static void zfcp_fsf_send_fcp_command_ta
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
 		set_host_byte(scpnt, DID_SOFT_ERROR);
-		set_driver_byte(scpnt, SUGGEST_RETRY);
 		goto skip_fsfstatus;
 	}
 
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1373,21 +1373,14 @@ static const char * const driverbyte_tab
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
-static const char * const driversuggest_table[]={"SUGGEST_OK",
-"SUGGEST_RETRY", "SUGGEST_ABORT", "SUGGEST_REMAP", "SUGGEST_DIE",
-"SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
-#define NUM_SUGGEST_STRS ARRAY_SIZE(driversuggest_table)
-
 void scsi_show_result(int result)
 {
 	int hb = host_byte(result);
-	int db = (driver_byte(result) & DRIVER_MASK);
-	int su = ((driver_byte(result) & SUGGEST_MASK) >> 4);
+	int db = driver_byte(result);
 
-	printk("Result: hostbyte=%s driverbyte=%s,%s\n",
+	printk("Result: hostbyte=%s driverbyte=%s\n",
 	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
-	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"),
-	       (su < NUM_SUGGEST_STRS ? driversuggest_table[su] : "invalid"));
+	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"));
 }
 
 #else
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -580,8 +580,7 @@ static void hptiop_finish_scsi_req(struc
 		break;
 
 	default:
-		scp->result = ((DRIVER_INVALID|SUGGEST_ABORT)<<24) |
-					(DID_ABORT<<16);
+		scp->result = DRIVER_INVALID << 24 | DID_ABORT << 16;
 		break;
 	}
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1004,8 +1004,7 @@ static int __ips_eh_reset(struct scsi_cm
 	DEBUG_VAR(1, "(%s%d) Failing active commands", ips_name, ha->host_num);
 
 	while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
-		scb->scsi_cmd->result =
-		    (DID_RESET << 16) | (SUGGEST_RETRY << 24);
+		scb->scsi_cmd->result = DID_RESET << 16;
 		scb->scsi_cmd->scsi_done(scb->scsi_cmd);
 		ips_freescb(ha, scb);
 	}
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -260,7 +260,7 @@ static void fc_fcp_retry_cmd(struct fc_f
 	}
 
 	fsp->state &= ~FC_SRB_ABORT_PENDING;
-	fsp->io_status = SUGGEST_RETRY << 24;
+	fsp->io_status = 0;
 	fsp->status_code = FC_ERROR;
 	fc_fcp_complete_locked(fsp);
 }
@@ -860,7 +860,7 @@ static void fc_fcp_complete_locked(struc
 		    (!(fsp->scsi_comp_flags & FCP_RESID_UNDER) ||
 		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid)) {
 			fsp->status_code = FC_DATA_UNDRUN;
-			fsp->io_status = SUGGEST_RETRY << 24;
+			fsp->io_status = 0;
 		}
 	}
 
@@ -1268,7 +1268,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt
 	rp = rport->dd_data;
 	if (!fsp->seq_ptr || rp->rp_state != RPORT_ST_READY) {
 		fsp->status_code = FC_HRD_ERROR;
-		fsp->io_status = SUGGEST_RETRY << 24;
+		fsp->io_status = 0;
 		fc_fcp_complete_locked(fsp);
 		return;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1357,7 +1357,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x1);
-		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+		cmd->result = DRIVER_SENSE << 24
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 		phba->bg_guard_err_cnt++;
 		printk(KERN_ERR "BLKGRD: guard_tag error\n");
@@ -1368,7 +1368,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x3);
-		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+		cmd->result = DRIVER_SENSE << 24
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 
 		phba->bg_reftag_err_cnt++;
@@ -1380,7 +1380,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x2);
-		cmd->result = (DRIVER_SENSE|SUGGEST_DIE) << 24
+		cmd->result = DRIVER_SENSE << 24
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 
 		phba->bg_apptag_err_cnt++;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -376,9 +376,9 @@ static int st_chk_result(struct scsi_tap
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
 			printk(KERN_WARNING
-			       "%s: Error %x (sugg. bt 0x%x, driver bt 0x%x, host bt 0x%x).\n",
-			       name, result, suggestion(result),
-			       driver_byte(result) & DRIVER_MASK, host_byte(result));
+			       "%s: Error %x (driver bt 0x%x, host bt 0x%x).\n",
+			       name, result, driver_byte(result),
+			       host_byte(result));
 		else if (cmdstatp->have_sense &&
 			 scode != NO_SENSE &&
 			 scode != RECOVERED_ERROR &&
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -665,7 +665,7 @@ void usb_stor_invoke_transport(struct sc
 	/* Did we transfer less than the minimum amount required? */
 	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
-		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
+		srb->result = DID_ERROR << 16;
 
 	return;
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -402,16 +402,6 @@ static inline int scsi_is_wlun(unsigned 
 #define DRIVER_HARD         0x07
 #define DRIVER_SENSE	    0x08
 
-#define SUGGEST_RETRY       0x10
-#define SUGGEST_ABORT       0x20
-#define SUGGEST_REMAP       0x30
-#define SUGGEST_DIE         0x40
-#define SUGGEST_SENSE       0x80
-#define SUGGEST_IS_OK       0xff
-
-#define DRIVER_MASK         0x0f
-#define SUGGEST_MASK        0xf0
-
 /*
  * Internal return values.
  */
@@ -447,7 +437,6 @@ static inline int scsi_is_wlun(unsigned 
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
-#define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
 
 static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
 {

