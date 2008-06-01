From: akinobu.mita@gmail.com
Subject: [patch -v2 22/23] ipr: use memory_read_from_buffer
Date: Mon, 02 Jun 2008 08:13:51 +0900
Message-ID: <20080601231648.183353549@gmail.com>
References: <20080601231329.223608711@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:3878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYFAX3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jun 2008 19:29:03 -0400
Received: by wa-out-1112.google.com with SMTP id j37so395042waf.23
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jun 2008 16:29:02 -0700 (PDT)
Content-Disposition: inline; filename=scsi-ipr-use-memory-read-from-buffer.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ipr.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/scsi/ipr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/ipr.c
+++ 2.6-git/drivers/scsi/ipr.c
@@ -2455,20 +2455,14 @@ static ssize_t ipr_read_trace(struct kob
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 	unsigned long lock_flags = 0;
-	int size = IPR_TRACE_SIZE;
-	char *src = (char *)ioa_cfg->trace;
-
-	if (off > size)
-		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
+	ssize_t ret;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	memcpy(buf, &src[off], count);
+	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
+				IPR_TRACE_SIZE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return count;
+
+	return ret;
 }
 
 static struct bin_attribute ipr_trace_attr = {

-- 
