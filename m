From: vinholikatti@gmail.com
Subject: [PATCH V6 4/4] [SCSI] ufs: Correct the expected data transfersize
Date: Tue,  5 Feb 2013 22:17:37 +0530
Message-ID: <511137e6.0657420a.5b57.ffffa80b@mx.google.com>
References: <1360082857-3317-1-git-send-email-y>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1360082857-3317-1-git-send-email-y>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, saugata.das@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, vinholikatti@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch corrects the expected data transfer size of the
command UPIU. The current implementation of cmd->transfersize
is wrong as it probably equal to sector size. With this
implementation the transfer size is updated correctly

Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
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
