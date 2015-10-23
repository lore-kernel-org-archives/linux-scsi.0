From: Punit Vara <punitvara@gmail.com>
Subject: [PATCH 2/2] scsi: remove useless casting value returned by kmalloc to structure
Date: Sat, 24 Oct 2015 01:33:53 +0530
Message-ID: <1445630633-14209-3-git-send-email-punitvara@gmail.com>
References: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:35183 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbJWUEX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2015 16:04:23 -0400
In-Reply-To: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>

This is the patch to the hpsa.c file that resolves following warning
reported by coccicheck:

WARNING: casting value returned by memory allocation function to
(BIG_IOCTL_Command_struct *) is useless.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8..8d971b3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6027,8 +6027,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = (BIG_IOCTL_Command_struct *)
-	    kmalloc(sizeof(*ioc), GFP_KERNEL);
+	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc) {
 		status = -ENOMEM;
 		goto cleanup1;
-- 
2.5.3

