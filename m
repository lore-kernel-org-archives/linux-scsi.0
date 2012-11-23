From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 2/3] scsi: sd: no need to set gendisk->minors in sd_probe_async()
Date: Fri, 23 Nov 2012 11:06:46 +0800
Message-ID: <1353640007-12834-2-git-send-email-yan@linux.vnet.ibm.com>
References: <1353640007-12834-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59981 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2KWDG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2012 22:06:56 -0500
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 23 Nov 2012 13:05:49 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAN36p4I40501304
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 14:06:51 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAN36p4p030187
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 14:06:51 +1100
In-Reply-To: <1353640007-12834-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

We already call alloc_disk() with SD_MINORS and ->minors will
be always set there.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4cc277d..e934ffc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2791,7 +2791,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
 
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
-- 
1.7.9.5

