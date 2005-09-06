From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix SCSI_IOCTL_PROBE_HOST
Date: Tue, 6 Sep 2005 14:03:44 +0200
Message-ID: <20050906120344.GA20177@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19077 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964835AbVIFMDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 08:03:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This returns always false with new-style drivers right now.  Make it
return always true instead, as a host must be present if we are able
to call the ioctl (without a host attached there would be no device
node to call on..)


Index: scsi-misc-2.6/drivers/scsi/scsi_ioctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_ioctl.c	2005-09-06 14:11:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_ioctl.c	2005-09-06 14:16:18.000000000 +0200
@@ -30,20 +30,20 @@
 
 #define MAX_BUF PAGE_SIZE
 
-/*
- * If we are told to probe a host, we will return 0 if  the host is not
- * present, 1 if the host is present, and will return an identifying
- * string at *arg, if arg is non null, filling to the length stored at
- * (int *) arg
+/**
+ * ioctl_probe  --  return host identification
+ * @host:	host to identify
+ * @buffer:	userspace buffer for identification
+ *
+ * Return an identifying string at @buffer, if @buffer is non-NULL, filling
+ * to the length stored at * (int *) @buffer.
  */
-
 static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
 {
 	unsigned int len, slen;
 	const char *string;
-	int temp = host->hostt->present;
 
-	if (temp && buffer) {
+	if (buffer) {
 		if (get_user(len, (unsigned int __user *) buffer))
 			return -EFAULT;
 
@@ -59,7 +59,7 @@
 				return -EFAULT;
 		}
 	}
-	return temp;
+	return 1;
 }
 
 /*
