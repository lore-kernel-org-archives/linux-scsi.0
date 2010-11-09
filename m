From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm/pscsi: Remove legacy struct scsi_device->sector_size workaround for TYPE_DISK
Date: Mon,  8 Nov 2010 21:41:34 -0800
Message-ID: <1289281294-20500-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:39188 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448Ab0KIFlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 00:41:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

At this point in late 2010 w/ v2.6.37-rc1, it has beem many years since
a broken ML / LLD was *not* properly setting struct scsi_device->sector_size for
TYPE_DISK.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fa2c975..6a31bed 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -204,35 +204,6 @@ static struct se_device *pscsi_add_device_to_list(
 	struct queue_limits *limits;
 
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
-	/*
-	 * Some pseudo SCSI HBAs do not fill in sector_size
-	 * correctly. (See ide-scsi.c)  So go ahead and setup sane
-	 * values.
-	 */
-	if (!sd->sector_size) {
-		switch (sd->type) {
-		case TYPE_DISK:
-			sd->sector_size = 512;
-			break;
-		case TYPE_ROM:
-			sd->sector_size = 2048;
-			break;
-		case TYPE_TAPE: /* The Tape may not be in the drive */
-			break;
-		case TYPE_MEDIUM_CHANGER: /* Control CDBs only */
-			break;
-		default:
-			printk(KERN_ERR "Unable to set sector_size for %d\n",
-					sd->type);
-			return NULL;
-		}
-
-		if (sd->sector_size) {
-			printk(KERN_ERR "Set broken SCSI Device"
-				" %d:%d:%d sector_size to %d\n", sd->channel,
-				sd->id, sd->lun, sd->sector_size);
-		}
-	}
 
 	if (!sd->queue_depth) {
 		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
-- 
1.5.6.5

