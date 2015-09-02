From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v3 08/15] scsi: ufs: add retries to dme_peer get and set attribute
Date: Wed,  2 Sep 2015 13:13:08 +0300
Message-ID: <1441188795-4600-9-git-send-email-ygardi@codeaurora.org>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

The dme_peer get/set attribute commands are prone to errors, therefore
we add three retries for the UIC command sending.
Error code returned from ufshcd_send_uic_cmd() is checked, and unless
it was successful or the retries have finished, another command will be
sent.

Signed-off-by: Lee Susman <lsusman@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 217b5cf..8d5bdf0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -69,6 +69,9 @@
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
 
+/* maximum number of retries for a general UIC command  */
+#define UFS_UIC_COMMAND_RETRIES 3
+
 /* maximum number of link-startup retries */
 #define DME_LINKSTARTUP_RETRIES 3
 
@@ -2184,6 +2187,7 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	};
 	const char *set = action[!!peer];
 	int ret;
+	int retries = UFS_UIC_COMMAND_RETRIES;
 
 	uic_cmd.command = peer ?
 		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
@@ -2191,10 +2195,18 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	uic_cmd.argument2 = UIC_ARG_ATTR_TYPE(attr_set);
 	uic_cmd.argument3 = mib_val;
 
-	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-	if (ret)
-		dev_err(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
-			set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+	do {
+		/* for peer attributes we retry upon failure */
+		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+		if (ret)
+			dev_dbg(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
+				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+	} while (ret && peer && --retries);
+
+	if (!retries)
+		dev_err(hba->dev, "%s: attr-id 0x%x val 0x%x failed %d retries\n",
+				set, UIC_GET_ATTR_ID(attr_sel), mib_val,
+				retries);
 
 	return ret;
 }
@@ -2219,6 +2231,7 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	};
 	const char *get = action[!!peer];
 	int ret;
+	int retries = UFS_UIC_COMMAND_RETRIES;
 	struct ufs_pa_layer_attr orig_pwr_info;
 	struct ufs_pa_layer_attr temp_pwr_info;
 	bool pwr_mode_change = false;
@@ -2249,14 +2262,19 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
 	uic_cmd.argument1 = attr_sel;
 
-	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-	if (ret) {
-		dev_err(hba->dev, "%s: attr-id 0x%x error code %d\n",
-			get, UIC_GET_ATTR_ID(attr_sel), ret);
-		goto out;
-	}
+	do {
+		/* for peer attributes we retry upon failure */
+		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+		if (ret)
+			dev_dbg(hba->dev, "%s: attr-id 0x%x error code %d\n",
+				get, UIC_GET_ATTR_ID(attr_sel), ret);
+	} while (ret && peer && --retries);
+
+	if (!retries)
+		dev_err(hba->dev, "%s: attr-id 0x%x failed %d retries\n",
+				get, UIC_GET_ATTR_ID(attr_sel), retries);
 
-	if (mib_val)
+	if (mib_val && !ret)
 		*mib_val = uic_cmd.argument3;
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
