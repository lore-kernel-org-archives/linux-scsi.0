From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_logging: return void for dev_printk() functions
Date: Wed,  4 Feb 2015 08:11:34 +0100
Message-ID: <1423033894-27646-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbbBDHLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2015 02:11:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>, linux-next@vger.kernel.org, Hannes Reinecke <hare@suse.de>

dev_printk() is now a void function, so the related functions
scmd_printk() and sdev_prefix_printk() should be made void, too.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_logging.c | 22 +++++++++-------------
 include/scsi/scsi_device.h  |  4 ++--
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index ecc5918..bd70339 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -93,20 +93,19 @@ static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
 	return off;
 }
 
-int sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
-		       const char *name, const char *fmt, ...)
+void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
+			const char *name, const char *fmt, ...)
 {
 	va_list args;
 	char *logbuf;
 	size_t off = 0, logbuf_len;
-	int ret;
 
 	if (!sdev)
-		return 0;
+		return;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
-		return 0;
+		return;
 
 	if (name)
 		off += scnprintf(logbuf + off, logbuf_len - off,
@@ -116,26 +115,24 @@ int sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
 		va_end(args);
 	}
-	ret = dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
+	dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
-	return ret;
 }
 EXPORT_SYMBOL(sdev_prefix_printk);
 
-int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
+void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 		const char *fmt, ...)
 {
 	va_list args;
 	char *logbuf;
 	size_t off = 0, logbuf_len;
-	int ret;
 
 	if (!scmd || !scmd->cmnd)
-		return 0;
+		return;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
-		return 0;
+		return;
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
 				 scmd->request->tag);
 	if (off < logbuf_len) {
@@ -143,9 +140,8 @@ int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
 		va_end(args);
 	}
-	ret = dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
+	dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
-	return ret;
 }
 EXPORT_SYMBOL(scmd_printk);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2e0281e..a4c9336 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -237,14 +237,14 @@ struct scsi_dh_data {
  * like scmd_printk, but the device name is passed in
  * as a string pointer
  */
-__printf(4, 5) int
+__printf(4, 5) void
 sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 		const char *, ...);
 
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
 
-__printf(3, 4) int
+__printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 
 #define scmd_dbg(scmd, fmt, a...)					   \
-- 
1.8.5.2

