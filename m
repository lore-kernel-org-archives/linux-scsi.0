From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [Resend PATCH 2/3] scsi: sd: no need to set gendisk->minors in sd_probe_async()
Date: Tue, 15 Jan 2013 13:31:32 +0800
Message-ID: <1358227893-31772-2-git-send-email-yan@linux.vnet.ibm.com>
References: <1358227893-31772-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53348 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3AOFbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2013 00:31:45 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 15 Jan 2013 15:25:35 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 6D8BC2BB0050
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:38 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0F5JqHp262544
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:19:52 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0F5Vbjx002241
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:37 +1100
In-Reply-To: <1358227893-31772-1-git-send-email-yan@linux.vnet.ibm.com>
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
index 181cd87..9fd67be 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2801,7 +2801,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
 
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
-- 
1.7.9.5

