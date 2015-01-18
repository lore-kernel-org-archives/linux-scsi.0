From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] scsi: annotate sdev_prefix_printk and scmd_printk as printf-like
Date: Sun, 18 Jan 2015 16:11:29 +0100
Message-ID: <1421593891-19984-2-git-send-email-hch@lst.de>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbARPM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:12:28 -0500
In-Reply-To: <1421593891-19984-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_device.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d1aad4d..2e0281e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -237,14 +237,15 @@ struct scsi_dh_data {
  * like scmd_printk, but the device name is passed in
  * as a string pointer
  */
-extern int sdev_prefix_printk(const char *, const struct scsi_device *,
-			      const char *, const char *, ...);
+__printf(4, 5) int
+sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
+		const char *, ...);
 
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
 
-extern int scmd_printk(const char *, const struct scsi_cmnd *,
-		       const char *, ...);
+__printf(3, 4) int
+scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 
 #define scmd_dbg(scmd, fmt, a...)					   \
 	do {								   \
-- 
1.9.1

