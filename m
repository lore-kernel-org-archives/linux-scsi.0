From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 3/3] scsi: sd: remove unnecessary initialization in sd_probe()
Date: Fri, 23 Nov 2012 11:06:47 +0800
Message-ID: <1353640007-12834-3-git-send-email-yan@linux.vnet.ibm.com>
References: <1353640007-12834-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58376 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2KWDG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2012 22:06:58 -0500
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 23 Nov 2012 13:03:19 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAN36qDr61865986
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 14:06:52 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAN36qjD030229
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 14:06:52 +1100
In-Reply-To: <1353640007-12834-1-git-send-email-yan@linux.vnet.ibm.com>
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
index e934ffc..d3b66a2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2897,7 +2897,6 @@ static int sd_probe(struct device *dev)
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
-	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
-- 
1.7.9.5

