Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE27CC64E90
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 10:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B5F221FF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 10:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgK3Kwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 05:52:47 -0500
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:59166 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728504AbgK3Kwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 05:52:46 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 529B912F8;
        Mon, 30 Nov 2020 10:52:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: heat91_4d04a91273a1
X-Filterd-Recvd-Size: 5632
Received: from joe-laptop.perches.com (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Mon, 30 Nov 2020 10:52:04 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Reduce object size of sdev_prefix_printk and scmd_printk calls
Date:   Mon, 30 Nov 2020 02:52:01 -0800
Message-Id: <4eb11d377c75bb057c9a12e310706360505ff586.1606733466.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid an extra char pointer per call for sdev_prefix_printk and scmd_printk
by integrating the KERN_LEVEL and format.

Preface the original function names with an underscore.

Create new macros that call the _ prefixed functions and coalesce the
KERN_<LEVEL> and format and split them inside the renamed functions.

Use printk_skip_level and a memcpy to a temporary inside these functions
to save the KERN_<LEVEL> for calls to dev_printk.

$ size drivers/scsi/built-in.a (defconfig x86-64)
        text       data     bss     dec
new:  262236      28965     782  291983
old:  263129      28965     782  292876

$ size drivers/scsi/built-in.a (allyesconfig x86-64)
         text      data     bss      dec
new: 14968308   2718234  165792 17852334
old: 14976884   2723130  165792 17865806

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/scsi_logging.c | 30 ++++++++++++++++++++++--------
 include/scsi/scsi_device.h  | 18 +++++++++++-------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 8ea44c6595ef..171c9183b0d4 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -50,12 +50,14 @@ static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
 	return off;
 }
 
-void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
-			const char *name, const char *fmt, ...)
+void _sdev_prefix_printk(const struct scsi_device *sdev, const char *prefix,
+			 const char *fmt, ...)
 {
 	va_list args;
 	char *logbuf;
 	size_t off = 0, logbuf_len;
+	char level[PRINTK_MAX_SINGLE_HEADER_LEN + 1] = "\0";
+	size_t size;
 
 	if (!sdev)
 		return;
@@ -64,9 +66,14 @@ void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 	if (!logbuf)
 		return;
 
-	if (name)
+	size = printk_skip_level(fmt) - fmt;
+	memcpy(level, fmt, size);
+	level[size] = '\0';
+	fmt += size;
+
+	if (prefix)
 		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "[%s] ", name);
+				 "[%s] ", prefix);
 	if (!WARN_ON(off >= logbuf_len)) {
 		va_start(args, fmt);
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -75,14 +82,15 @@ void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 	dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
 }
-EXPORT_SYMBOL(sdev_prefix_printk);
+EXPORT_SYMBOL(_sdev_prefix_printk);
 
-void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
-		const char *fmt, ...)
+void _scmd_printk(const struct scsi_cmnd *scmd, const char *fmt, ...)
 {
 	va_list args;
 	char *logbuf;
 	size_t off = 0, logbuf_len;
+	char level[PRINTK_MAX_SINGLE_HEADER_LEN + 1] = "\0";
+	size_t size;
 
 	if (!scmd || !scmd->cmnd)
 		return;
@@ -90,6 +98,12 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
 		return;
+
+	size = printk_skip_level(fmt) - fmt;
+	memcpy(level, fmt, size);
+	level[size] = '\0';
+	fmt += size;
+
 	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
 				 scmd->request->tag);
 	if (off < logbuf_len) {
@@ -100,7 +114,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
 }
-EXPORT_SYMBOL(scmd_printk);
+EXPORT_SYMBOL(_scmd_printk);
 
 static size_t scsi_format_opcode_name(char *buffer, size_t buf_len,
 				      const unsigned char *cdbp)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a5c9a3df6d6..002c723b65fa 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -252,19 +252,23 @@ struct scsi_device {
 
 /*
  * like scmd_printk, but the device name is passed in
- * as a string pointer
+ * as a string pointer in prefix
  */
-__printf(4, 5) void
-sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
-		const char *, ...);
+__printf(3, 4)
+void _sdev_prefix_printk(const struct scsi_device *sdev,
+			 const char *prefix, const char *fmt, ...);
+#define sdev_prefix_printk(level, sdev, prefix, fmt, ...)		\
+	_sdev_prefix_printk(sdev, prefix, level fmt, ##__VA_ARGS__)
 
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
 
-__printf(3, 4) void
-scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
+__printf(2, 3)
+void _scmd_printk(const struct scsi_cmnd *scmd, const char *fmt, ...);
+#define scmd_printk(level, scmd, fmt, ...)				\
+	_scmd_printk(scmd, level fmt, ##__VA_ARGS__)
 
-#define scmd_dbg(scmd, fmt, a...)					   \
+#define scmd_dbg(scmd, fmt, a...)					\
 	do {								   \
 		if ((scmd)->request->rq_disk)				   \
 			sdev_dbg((scmd)->device, "[%s] " fmt,		   \
-- 
2.26.0

