From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/5] scsi_debug: remove temporary hack around sscanf for negative values
Date: Thu, 20 Mar 2008 11:09:15 +0900
Message-ID: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60304 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbYCTCKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 22:10:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

sscanf can handle negative values.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7a2a3ed..2a388d0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2681,21 +2681,10 @@ static ssize_t sdebug_add_host_show(struct device_driver * ddp, char * buf)
 static ssize_t sdebug_add_host_store(struct device_driver * ddp,
 				     const char * buf, size_t count)
 {
-        int delta_hosts;
-	char work[20];
+	int delta_hosts;
 
-        if (1 != sscanf(buf, "%10s", work))
+	if (sscanf(buf, "%d", &delta_hosts) != 1)
 		return -EINVAL;
-	{	/* temporary hack around sscanf() problem with -ve nums */
-		int neg = 0;
-
-		if ('-' == *work)
-			neg = 1;
-		if (1 != sscanf(work + neg, "%d", &delta_hosts))
-			return -EINVAL;
-		if (neg)
-			delta_hosts = -delta_hosts;
-	}
 	if (delta_hosts > 0) {
 		do {
 			sdebug_add_adapter();
@@ -2707,7 +2696,7 @@ static ssize_t sdebug_add_host_store(struct device_driver * ddp,
 	}
 	return count;
 }
-DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show, 
+DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show,
 	    sdebug_add_host_store);
 
 static ssize_t sdebug_vpd_use_hostno_show(struct device_driver * ddp,
-- 
1.5.3.7

