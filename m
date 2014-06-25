From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 08/11] mptfusion: use memdup_user
Date: Wed, 25 Jun 2014 17:06:12 -0400
Message-ID: <1403730372-20246-1-git-send-email-joe.lawrence@stratus.com>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o147.mxlogic.net ([208.65.145.80]:34638 "EHLO
	p02c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaFYVGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 17:06:34 -0400
In-Reply-To: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>

Let memdup_user handle the kmalloc, copy_from_user and error checking
kfree code.

Spotted by the following smatch (false positive) warning:

  drivers/message/fusion/mptctl.c:1369 mptctl_getiocinfo() warn:
    possible info leak 'karg'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/message/fusion/mptctl.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 8a050e8..b0a892a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1261,19 +1261,11 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	else
 		return -EFAULT;
 
-	karg = kmalloc(data_size, GFP_KERNEL);
-	if (karg == NULL) {
-		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
-				__FILE__, __LINE__);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(karg, uarg, data_size)) {
-		printk(KERN_ERR MYNAM "%s@%d::mptctl_getiocinfo - "
-			"Unable to read in mpt_ioctl_iocinfo struct @ %p\n",
-				__FILE__, __LINE__, uarg);
-		kfree(karg);
-		return -EFAULT;
+	karg = memdup_user(uarg, data_size);
+	if (IS_ERR(karg)) {
+		printk(KERN_ERR MYNAM "%s@%d::mpt_ioctl_iocinfo() - memdup_user returned error [%ld]\n",
+				__FILE__, __LINE__, PTR_ERR(karg));
+		return PTR_ERR(karg);
 	}
 
 	if (((iocnum = mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
-- 
1.7.10.4

