From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] target-pscsi: query tape blocksize using scsi_execute_req
Date: Thu, 25 Nov 2010 23:14:29 -0800
Message-ID: <1290755672-19819-2-git-send-email-nab@linux-iscsi.org>
References: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.49]:31699 "HELO
	nm16-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753138Ab0KZHO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 02:14:59 -0500
In-Reply-To: <1290755672-19819-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

Use the native Linux scsi execution support instead of the target passthrough
support to get the tape blocksize

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |   66 ++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b14fe35..773ff83 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -181,6 +181,33 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	return 1;
 }
 
+static void pscsi_tape_read_blocksize(struct se_device *dev,
+		struct scsi_device *sdev)
+{
+	unsigned char cdb[MAX_COMMAND_SIZE], *buf;
+
+	buf = kzalloc(12, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	memset(cdb, 0, MAX_COMMAND_SIZE);
+	cdb[0] = MODE_SENSE;
+	cdb[4] = 0x0c; /* 12 bytes */
+
+	if (!scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
+			HZ, 1, NULL))
+		goto out_free;
+
+	/*
+	 * If MODE_SENSE still returns zero, set the default value to 1024.
+	 */
+	sdev->sector_size = (buf[9] << 16) | (buf[10] << 8) | (buf[11]);
+	if (!sdev->sector_size)
+		sdev->sector_size = 1024;
+out_free:
+	kfree(buf);
+}
+
 /*	pscsi_add_device_to_list():
  *
  *
@@ -245,43 +272,8 @@ static struct se_device *pscsi_add_device_to_list(
 	/*
 	 * For TYPE_TAPE, attempt to determine blocksize with MODE_SENSE.
 	 */
-	if (sd->type == TYPE_TAPE) {
-		unsigned char *buf = NULL, cdb[MAX_COMMAND_SIZE];
-		struct se_cmd *cmd;
-		u32 blocksize;
-
-		memset(cdb, 0, MAX_COMMAND_SIZE);
-		cdb[0] = MODE_SENSE;
-		cdb[4] = 0x0c; /* 12 bytes */
-
-		cmd = transport_allocate_passthrough(&cdb[0],
-				DMA_FROM_DEVICE, 0, NULL, 0, 12, dev);
-		if (!(cmd)) {
-			printk(KERN_ERR "Unable to determine blocksize for"
-				" TYPE_TAPE\n");
-			goto out;
-		}
-
-		if (transport_generic_passthrough(cmd) < 0) {
-			printk(KERN_ERR "Unable to determine blocksize for"
-				" TYPE_TAPE\n");
-			goto out;
-		}
-
-		buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-		blocksize = (buf[9] << 16) | (buf[10] << 8) | (buf[11]);
-
-		/*
-		 * If MODE_SENSE still returns zero, set the default value
-		 * to 1024.
-		 */
-		sd->sector_size = blocksize;
-		if (!(sd->sector_size))
-			sd->sector_size = 1024;
-
-		transport_passthrough_release(cmd);
-	}
-out:
+	if (sd->type == TYPE_TAPE)
+		pscsi_tape_read_blocksize(dev, sd);
 	return dev;
 }
 
-- 
1.5.6.5

