From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v4 05/15] scsi: ufs: increase fDeviceInit query response timeout
Date: Sun, 25 Oct 2015 16:56:14 +0200
Message-ID: <1445784984-16443-6-git-send-email-ygardi@codeaurora.org>
References: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

fDeviceInit query response time for some devices is too long that default
query request timeout of 100ms may not be enough. Experiments show that
fDeviceInit response sometimes takes 500ms so to be on safer side this
change sets the timeout to 600ms. Without this change, we might
unnecessarily have to retry fDeviceInit query requests multiple times and
each query request timeout prints one error message.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e0b8755..573a8cb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -58,6 +58,12 @@
 #define QUERY_REQ_RETRIES 10
 /* Query request timeout */
 #define QUERY_REQ_TIMEOUT 30 /* msec */
+/*
+ * Query request timeout for fDeviceInit flag
+ * fDeviceInit query response time for some devices is too large that default
+ * QUERY_REQ_TIMEOUT may not be enough for such devices.
+ */
+#define QUERY_FDEVICEINIT_REQ_TIMEOUT 600 /* msec */
 
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
@@ -1651,6 +1657,7 @@ static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
 	int err, index = 0, selector = 0;
+	int timeout = QUERY_REQ_TIMEOUT;
 
 	BUG_ON(!hba);
 
@@ -1683,7 +1690,10 @@ static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 		goto out_unlock;
 	}
 
-	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+	if (idn == QUERY_FLAG_IDN_FDEVICEINIT)
+		timeout = QUERY_FDEVICEINIT_REQ_TIMEOUT;
+
+	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, timeout);
 
 	if (err) {
 		dev_err(hba->dev,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
