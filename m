From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/aacraid/commctrl.c: replace kmalloc/copy_from_user by memdup_user
Date: Fri, 30 May 2014 18:37:43 +0200
Message-ID: <1401467863-7188-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:2321 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbaE3Qht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2014 12:37:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "James E.J. Bottomley" <JBottomley@parallels.com>

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/aacraid/commctrl.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index fbcd48d..3d5d6a6 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -517,16 +517,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
-	if (!user_srbcmd) {
-		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
-		rcode = -ENOMEM;
-		goto cleanup;
-	}
-	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
+	user_srbcmd = memdup_user(user_srb, fibsize);
+	if (IS_ERR(user_srbcmd)) {
 		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
-		rcode = -EFAULT;
-		goto cleanup;
+		return PTR_ERR(user_srbcmd);
 	}
 
 	user_reply = arg+fibsize;
-- 
1.8.4.5

