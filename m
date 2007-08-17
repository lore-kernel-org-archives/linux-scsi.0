From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Improve error message when offlining a device
Date: Fri, 17 Aug 2007 11:02:10 -0600
Message-ID: <20070817170210.GA30019@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49521 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXHQRCM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2007 13:02:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The current code prints:

scsi 13:0:4:0: scsi: Device offlined - not ready after error recovery

which is repetitively redundant.  This patch changes that message to:

scsi 6:0:6:0: Device offlined - not ready after error recovery

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c8e351f..c05d020 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1137,9 +1137,8 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 	struct scsi_cmnd *scmd, *next;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-		sdev_printk(KERN_INFO, scmd->device,
-			    "scsi: Device offlined - not"
-			    " ready after error recovery\n");
+		sdev_printk(KERN_INFO, scmd->device, "Device offlined - "
+			    "not ready after error recovery\n");
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
