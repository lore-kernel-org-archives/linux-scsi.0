From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/11]   qla2xxx: ISR fixes
Date: Wed, 8 Dec 2004 23:37:39 -0800
Message-ID: <20041209073739.GA22123@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:10728 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261479AbULIHhn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:37:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2240 04/12/08 15:44:22 andrew.vasquez@qlogic.com +1 -0
  Interrupt handler fixes:
  
     o Mark HBA offline in case the firmware cannot recover
       after and ISP system-error.
     o Correct issue where the loop-down-timer was not properly
       being cleared during a port-update event.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_isr.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-12-08 22:15:02 -08:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-12-08 22:15:02 -08:00
@@ -376,7 +376,14 @@
 			qla2100_fw_dump(ha, 1);
 		else
 	    		qla2300_fw_dump(ha, 1);
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+
+		if (mb[1] == 0) {
+			qla_printk(KERN_INFO, ha,
+			    "Unrecoverable Hardware Error: adapter marked "
+			    "OFFLINE!\n");
+			ha->flags.online = 0;
+		} else
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		break;
 
 	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
@@ -583,11 +590,13 @@
 		}
 
 		/*
-		 * If PORT UPDATE is global (received LIP_OCCURRED/LIP_RESET
+		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
 		 * it.  Otherwise ignore it and Wait for RSCN to come in.
 		 */
-		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
+		atomic_set(&ha->loop_down_timer, 0);
+		if (atomic_read(&ha->loop_state) != LOOP_DOWN &&
+		    atomic_read(&ha->loop_state) != LOOP_DEAD) {
 			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
 			    "ignored.\n", ha->host_no));
 			break;
@@ -604,7 +613,6 @@
 		 */
 		atomic_set(&ha->loop_state, LOOP_UP);
 
-		atomic_set(&ha->loop_down_timer, 0);
 		qla2x00_mark_all_devices_lost(ha);
 
 		ha->flags.rscn_queue_overflow = 1;
