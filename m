From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/11] scsi_debug: Convert to host_lock less
Date: Wed, 17 Nov 2010 14:19:55 -0800
Message-ID: <1290032395-5062-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.248]:26338 "HELO
	nm29-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933707Ab0KQWUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 17:20:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_debug to run in host_lock less mode with interrupts
enabled, as we don't have a underly HW reason to use IRQ_DISABLE_SCSI_QCMD().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c499eb3..71cd1fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3538,7 +3538,7 @@ static void sdebug_remove_adapter(void)
 }
 
 static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+int scsi_debug_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *SCpnt)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3566,17 +3566,17 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 	if (target == SCpnt->device->host->hostt->this_id) {
 		printk(KERN_INFO "scsi_debug: initiator's id used as "
 		       "target!\n");
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 	}
 
 	if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
 	    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 	devip = devInfoReg(SCpnt->device);
 	if (NULL == devip)
-		return schedule_resp(SCpnt, NULL, done,
+		return schedule_resp(SCpnt, NULL, SCpnt->scsi_done,
 				     DID_NO_CONNECT << 16, 0);
 
 	if ((scsi_debug_every_nth != 0) &&
@@ -3610,8 +3610,8 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_OPCODE, 0);
 			errsts = check_condition_result;
-			return schedule_resp(SCpnt, devip, done, errsts,
-					     0);
+			return schedule_resp(SCpnt, devip, SCpnt->scsi_done,
+						errsts, 0);
 		}
 	}
 
@@ -3885,12 +3885,10 @@ xdwrite_read:
 		errsts = check_condition_result;
 		break;
 	}
-	return schedule_resp(SCpnt, devip, done, errsts,
+	return schedule_resp(SCpnt, devip, SCpnt->scsi_done, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
-
 static struct scsi_host_template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.proc_name =		sdebug_proc_name,
-- 
1.7.2.3

