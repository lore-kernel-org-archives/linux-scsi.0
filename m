From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix the scsi_logging_level fix
Date: Thu, 28 Aug 2003 12:24:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030828102458.GA3972@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:4044 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262288AbTH1KZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 06:25:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

We already had a prototype for it, it just was conditional on
CONFIG_SCSI_LOGGING..


--- 1.3/drivers/scsi/scsi_logging.h	Wed Aug 27 00:45:29 2003
+++ edited/drivers/scsi/scsi_logging.h	Thu Aug 28 10:49:51 2003
@@ -37,9 +37,9 @@
 #define SCSI_LOG_HLCOMPLETE_BITS          3
 #define SCSI_LOG_IOCTL_BITS               3
 
+extern unsigned int scsi_logging_level;
 
 #ifdef CONFIG_SCSI_LOGGING
-extern unsigned int scsi_logging_level;
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)		\
 {								\
         unsigned int mask = (1 << (BITS)) - 1;			\
@@ -75,7 +75,5 @@
         SCSI_CHECK_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL,CMD);
 #define SCSI_LOG_IOCTL(LEVEL,CMD)  \
         SCSI_CHECK_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL,CMD);
-
-extern unsigned int scsi_logging_level;
 
 #endif /* _SCSI_LOGGING_H */
