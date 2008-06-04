From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch -v3 21/22] ipr: use memory_read_from_buffer
Date: Wed, 04 Jun 2008 20:56:54 +0900
Message-ID: <20080604115854.158492587@gmail.com>
References: <20080604115633.116832712@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:3588 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760490AbYFDMLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2008 08:11:18 -0400
Received: by py-out-1112.google.com with SMTP id p76so56277pyb.10
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2008 05:11:15 -0700 (PDT)
Content-Disposition: inline; filename=scsi-ipr-use-memory-read-from-buffer.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
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
