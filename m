From: Aaron Lu <aaron.lwe@gmail.com>
Subject: [PATCH v6 3/7] scsi: sr: block events checking when suspended for zpodd
Date: Tue,  4 Sep 2012 22:24:36 +0800
Message-ID: <1346768680-7287-4-git-send-email-aaron.lwe@gmail.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2IDOZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 10:25:37 -0400
In-Reply-To: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>, Aaron Lu <aaron.lwe@gmail.com>

From: Aaron Lu <aaron.lu@intel.com>

When ODD is runtime suspended and if it can be powered off(reflected by
the can_power_off flag), we will block events checking for it so that it
can stay in powered off state until resumed by:
1 user pressing the eject button or inserting a disc;
2 software opening the block device.
But not by events checking that normally occurs every 2 seconds.

Old versions of udisk will poll the ODD periodically, so it is advised
to inhibit the polling:
$ udisks --inhibit-polling /dev/sr0

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c | 10 ++++++++++
 drivers/scsi/sr.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 637f4ca..a5bb687 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -204,6 +204,11 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 	if (!suspend)
 		return -EBUSY;
 
+	if (cd->device->can_power_off) {
+		cd->disk_events_blocked = 1;
+		disk_block_events(cd->disk);
+	}
+
 	return 0;
 }
 
@@ -224,6 +229,11 @@ static int sr_resume(struct device *dev)
 			sr_tray_move(&cd->cdi, 1);
 	}
 
+	if (cd->disk_events_blocked) {
+		cd->disk_events_blocked = 0;
+		disk_unblock_events(cd->disk);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..9d9a76f 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -41,6 +41,7 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
+	unsigned disk_events_blocked:1; /* disk events is blocked */
 
 	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
-- 
1.7.11.3

