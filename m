From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [Resend PATCH 3/3] scsi: sd: remove unnecessary initialization in sd_probe()
Date: Tue, 15 Jan 2013 13:31:33 +0800
Message-ID: <1358227893-31772-3-git-send-email-yan@linux.vnet.ibm.com>
References: <1358227893-31772-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54752 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3AOFbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2013 00:31:46 -0500
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 15 Jan 2013 15:26:44 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id F07C62CE804D
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:38 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0F5K2e81311190
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:20:02 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0F5Vc1d002289
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:38 +1100
In-Reply-To: <1358227893-31772-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

We use kzalloc() to allocate scsi_disk, no need to reset ->openers.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9fd67be..4f4bc7e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2907,7 +2907,6 @@ static int sd_probe(struct device *dev)
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
-	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
-- 
1.7.9.5

