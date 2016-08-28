From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] scsi: ufs: add missing declaration in ufshcd.h
Date: Sun, 28 Aug 2016 16:01:22 +0800
Message-ID: <1472371282-14691-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 1 warning about global functions without a declaration
in the scsi ufshcd driver when building with W=1:
drivers/scsi/ufs/ufshcd.c:1991:5: warning: no previous prototype for 'ufshcd_query_descriptor_retry' [-Wmissing-prototypes]

in fact, this function is implemented in ufshcd.c and exported
but need to be declared in header file.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/ufs/ufshcd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 430bef1..2f696ea 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -713,6 +713,9 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
 /* Expose Query-Request API */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
+int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+	enum query_opcode opcode, enum desc_idn idn, u8 index,
+	u8 selector, u8 *desc_buf, int *buf_len);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
-- 
2.7.4
