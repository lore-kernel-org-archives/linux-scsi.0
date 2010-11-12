From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/11] scsi_debug: Convert to host_lock less
Date: Thu, 11 Nov 2010 16:14:54 -0800
Message-ID: <1289520894-16650-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:29682 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757249Ab0KLAO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:14:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_debug to run in host_lock less mode with interrupts
enabled, as we don't have a underly HW reason to use IRQ_DISABLE_SCSI_QCMD().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi_debug.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c499eb3..2689f01 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3538,7 +3538,7 @@ static void sdebug_remove_adapter(void)
 }
 
 static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+int scsi_debug_queuecommand(struct scsi_cmnd *SCpnt, done_funct_t done)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3889,8 +3889,6 @@ xdwrite_read:
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
-
 static struct scsi_host_template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.proc_name =		sdebug_proc_name,
-- 
1.7.2.3

