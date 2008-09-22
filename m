From: akpm@linux-foundation.org
Subject: [patch 09/17] ipr: use memory_read_from_buffer()
Date: Mon, 22 Sep 2008 14:56:47 -0700
Message-ID: <200809222156.m8MLulrK032288@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbYIVWJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 18:09:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, akinobu.mita@gmail.com, brking@us.ibm.com

From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~ipr-use-memory_read_from_buffer
+++ a/drivers/scsi/ipr.c
@@ -2456,20 +2456,14 @@ static ssize_t ipr_read_trace(struct kob
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
_
