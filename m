From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/38] scsi: log request tag for scmd_printk()
Date: Mon, 29 Sep 2014 13:59:00 +0200
Message-ID: <1411991947-130166-32-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaI2L7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:17 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

The request tag provides a concise identification of a SCSI
command, so we should be printing that out for scmd_printk().

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_logging.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 8cdaddc..e07367e 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -18,13 +18,15 @@
 #define SCSI_LOG_BUFSIZE 512
 
 static void sdev_format_header(struct seq_buf *s, struct scsi_device *sdev,
-			       const char *disk_name)
+			       const char *disk_name, int tag)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
 	s->len = dev_printk_header(s->buffer, s->size, dev);
 	if (disk_name)
 		seq_buf_printf(s, "[%s] ", disk_name);
+	if (tag >= 0)
+		seq_buf_printf(s, "tag#%d ", tag);
 }
 
 static int sdev_seq_printk(const char *level, struct scsi_device *sdev,
@@ -49,7 +51,7 @@ int sdev_prefix_printk(const char *level, struct scsi_device *sdev,
 		return 0;
 
 	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
-	sdev_format_header(&s, sdev, name);
+	sdev_format_header(&s, sdev, name, -1);
 	va_start(args, fmt);
 	seq_buf_vprintf(&s, fmt, args);
 	va_end(args);
@@ -69,7 +71,8 @@ int scmd_printk(const char *level, struct scsi_cmnd *scmd,
 		return 0;
 
 	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
-	sdev_format_header(&s, scmd->device, disk ? disk->disk_name : NULL);
+	sdev_format_header(&s, scmd->device, disk ? disk->disk_name : NULL,
+			   scmd->request->tag);
 	va_start(args, fmt);
 	seq_buf_vprintf(&s, fmt, args);
 	va_end(args);
-- 
1.8.5.2

