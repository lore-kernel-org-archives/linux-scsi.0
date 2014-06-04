From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 4/7] mptfusion: zero kernel-space source of copy_to_user
Date: Wed, 4 Jun 2014 12:49:46 -0400
Message-ID: <1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:36324 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFDQuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:50:09 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

Fixes the following smatch warning:

  drivers/message/fusion/mptctl.c:1369 mptctl_getiocinfo() warn:
    possible info leak 'karg'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/message/fusion/mptctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index dcc8385..e6d8935 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1261,7 +1261,7 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	else
 		return -EFAULT;
 
-	karg = kmalloc(data_size, GFP_KERNEL);
+	karg = kzalloc(data_size, GFP_KERNEL);
 	if (karg == NULL) {
 		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
 				__FILE__, __LINE__);
-- 
1.7.10.4

