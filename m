From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH V6 Resend 4/4] [SCSI] ufs: Correct the expected data transfersize
Date: Mon, 25 Feb 2013 21:44:35 +0530
Message-ID: <1361808875-2803-5-git-send-email-vinholikatti@gmail.com>
References: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:55256 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab3BYQPu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 11:15:50 -0500
In-Reply-To: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, linux-samsung-soc@vger.kernel.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, merez@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>

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
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4

