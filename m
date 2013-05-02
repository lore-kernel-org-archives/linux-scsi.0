From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/3] ufs: Correct the expected data transfersize
Date: Thu,  2 May 2013 17:25:35 +0530
Message-ID: <1367495736-8927-3-git-send-email-santoshsy@gmail.com>
References: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52991 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab3EBL4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 07:56:34 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so314133pbc.16
        for <linux-scsi@vger.kernel.org>; Thu, 02 May 2013 04:56:34 -0700 (PDT)
In-Reply-To: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Yaraganavi <santoshsy@gmail.com>

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch corrects the expected data transfer size of the
command UPIU. The current implementation of cmd->transfersize
is wrong as it probably equal to sector size. With this
implementation the transfer size is updated correctly

Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 60fd40c..c32a478 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -478,7 +478,7 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
 		ucd_cmd_ptr->header.dword_2 = 0;
 
 		ucd_cmd_ptr->exp_data_transfer_len =
-			cpu_to_be32(lrbp->cmd->transfersize);
+			cpu_to_be32(lrbp->cmd->sdb.length);
 
 		memcpy(ucd_cmd_ptr->cdb,
 		       lrbp->cmd->cmnd,
-- 
1.8.1.2

