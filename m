From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [11/18] qla2xxx: Misc. fixes
Date: Mon, 21 Jun 2004 22:56:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055632.GA8462@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:14467 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266605AbUFVFws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:52:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1847 04/06/16 13:55:20 andrew.vasquez@apc.qlogic.com +2 -0
  Small fixes:
  
  o Remove incorrect and unused ISP2100 #define
    SS_RESIDUAL_LEN_VALID.
  
  o Fix problem where an incorrect status would be returned
    for qla2x00_configure_fabric() if the driver was unable to
    log into a fabric's SNS.
  
  o Check for the additional WAIT_FOR_AL_PA state in
    qla2x00_fw_ready() since switch vendors may push NOS/OLS
    primitives during a 'port disabled' state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h  |    3 +--
 drivers/scsi/qla2xxx/qla_init.c |    9 +++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:38:59 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:38:59 -07:00
@@ -1303,8 +1303,7 @@
 #define SS_RESIDUAL_UNDER		BIT_11
 #define SS_RESIDUAL_OVER		BIT_10
 #define SS_SENSE_LEN_VALID		BIT_9
-#define SS_RESIDUAL_LEN_VALID		BIT_8	/* ISP2100 only */
-#define SS_RESPONSE_INFO_LEN_VALID	BIT_8	/* ISP2200 and 23xx */
+#define SS_RESPONSE_INFO_LEN_VALID	BIT_8
 
 #define SS_RESERVE_CONFLICT		(BIT_4 | BIT_3)
 #define SS_BUSY_CONDITION		BIT_3
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:59 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:59 -07:00
@@ -941,7 +941,8 @@
 			rval = QLA_FUNCTION_FAILED;
 
 			if (atomic_read(&ha->loop_down_timer) &&
-			    fw_state >= FSTATE_LOSS_OF_SYNC) {
+			    (fw_state >= FSTATE_LOSS_OF_SYNC ||
+				fw_state == FSTATE_WAIT_AL_PA)) {
 				/* Loop down. Timeout on min_wait for states
 				 * other than Wait for Login. 
 				 */	
@@ -2339,11 +2340,11 @@
 		qla2x00_login_fabric(ha, SIMPLE_NAME_SERVER, 0xff, 0xff, 0xfc,
 		    mb, BIT_1 | BIT_0);
 		if (mb[0] != MBS_COMMAND_COMPLETE) {
-			qla_printk(KERN_INFO, ha,
+			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "Failed SNS login: loop_id=%x mb[0]=%x mb[1]=%x "
 			    "mb[2]=%x mb[6]=%x mb[7]=%x\n", SIMPLE_NAME_SERVER,
-			    mb[0], mb[1], mb[2], mb[6], mb[7]);
-			return (QLA_FUNCTION_FAILED);
+			    mb[0], mb[1], mb[2], mb[6], mb[7]));
+			return (QLA_SUCCESS);
 		}
 
 		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags)) {
