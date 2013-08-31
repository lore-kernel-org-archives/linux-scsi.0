From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 3/6] scsi: ufs: add dme configuration primitives
Date: Sat, 31 Aug 2013 21:40:21 +0530
Message-ID: <1377965424-30991-4-git-send-email-santoshsy@gmail.com>
References: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47959 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3HaQL2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 12:11:28 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so3509211pad.18
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 09:11:27 -0700 (PDT)
In-Reply-To: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

Implements to support GET and SET operations of the DME.
These operations are used to configure the behavior of
the UNIPRO. Along with basic operation, {Peer/AttrSetType}
can be mixed.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 86d7286..03ff4da 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -285,6 +285,18 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_get_dme_attr_val - Get the value of attribute returned by UIC command
+ * @hba: Pointer to adapter instance
+ *
+ * This function gets UIC command argument3
+ * Returns 0 on success, non zero value on error
+ */
+static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
+{
+	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_3);
+}
+
+/**
  * ufshcd_get_req_rsp - returns the TR response transaction type
  * @ucd_rsp_ptr: pointer to response UPIU
  */
@@ -1440,6 +1452,80 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
+ * @hba: per adapter instance
+ * @attr_sel: uic command argument1
+ * @attr_set: attribute set type as uic command argument2
+ * @mib_val: setting value as uic command argument3
+ * @peer: indicate whether peer or local
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
+			u8 attr_set, u32 mib_val, u8 peer)
+{
+	struct uic_command uic_cmd = {0};
+	static const char *const action[] = {
+		"dme-set",
+		"dme-peer-set"
+	};
+	const char *set = action[!!peer];
+	int ret;
+
+	uic_cmd.command = peer ?
+		UIC_CMD_DME_PEER_SET : UIC_CMD_DME_SET;
+	uic_cmd.argument1 = attr_sel;
+	uic_cmd.argument2 = UIC_ARG_ATTR_TYPE(attr_set);
+	uic_cmd.argument3 = mib_val;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret)
+		dev_err(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
+			set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_set_attr);
+
+/**
+ * ufshcd_dme_get_attr - UIC command for DME_GET, DME_PEER_GET
+ * @hba: per adapter instance
+ * @attr_sel: uic command argument1
+ * @mib_val: the value of the attribute as returned by the UIC command
+ * @peer: indicate whether peer or local
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
+			u32 *mib_val, u8 peer)
+{
+	struct uic_command uic_cmd = {0};
+	static const char *const action[] = {
+		"dme-get",
+		"dme-peer-get"
+	};
+	const char *get = action[!!peer];
+	int ret;
+
+	uic_cmd.command = peer ?
+		UIC_CMD_DME_PEER_GET : UIC_CMD_DME_GET;
+	uic_cmd.argument1 = attr_sel;
+
+	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
+	if (ret) {
+		dev_err(hba->dev, "%s: attr-id 0x%x error code %d\n",
+			get, UIC_GET_ATTR_ID(attr_sel), ret);
+		goto out;
+	}
+
+	if (mib_val)
+		*mib_val = uic_cmd.argument3;
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
+
+/**
  * ufshcd_complete_dev_init() - checks device readiness
  * hba: per-adapter instance
  *
@@ -1912,6 +1998,8 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
 	if (hba->active_uic_cmd) {
 		hba->active_uic_cmd->argument2 |=
 			ufshcd_get_uic_cmd_result(hba);
+		hba->active_uic_cmd->argument3 =
+			ufshcd_get_dme_attr_val(hba);
 		complete(&hba->active_uic_cmd->done);
 	}
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8f5624e..ab1518d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -275,4 +275,55 @@ static inline void check_upiu_size(void)
 extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
 extern int ufshcd_runtime_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_idle(struct ufs_hba *hba);
+extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
+			       u8 attr_set, u32 mib_val, u8 peer);
+extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
+			       u32 *mib_val, u8 peer);
+
+/* UIC command interfaces for DME primitives */
+#define DME_LOCAL	0
+#define DME_PEER	1
+#define ATTR_SET_NOR	0	/* NORMAL */
+#define ATTR_SET_ST	1	/* STATIC */
+
+static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
+				 u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
+				   mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_st_set(struct ufs_hba *hba, u32 attr_sel,
+				    u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
+				   mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_peer_set(struct ufs_hba *hba, u32 attr_sel,
+				      u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_NOR,
+				   mib_val, DME_PEER);
+}
+
+static inline int ufshcd_dme_peer_st_set(struct ufs_hba *hba, u32 attr_sel,
+					 u32 mib_val)
+{
+	return ufshcd_dme_set_attr(hba, attr_sel, ATTR_SET_ST,
+				   mib_val, DME_PEER);
+}
+
+static inline int ufshcd_dme_get(struct ufs_hba *hba,
+				 u32 attr_sel, u32 *mib_val)
+{
+	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_LOCAL);
+}
+
+static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
+				      u32 attr_sel, u32 *mib_val)
+{
+	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
+}
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 739ae3a..1e1fe26 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -191,6 +191,12 @@ enum {
 #define CONFIG_RESULT_CODE_MASK		0xFF
 #define GENERIC_ERROR_CODE_MASK		0xFF
 
+#define UIC_ARG_MIB_SEL(attr, sel)	((((attr) & 0xFFFF) << 16) |\
+					 ((sel) & 0xFFFF))
+#define UIC_ARG_MIB(attr)		UIC_ARG_MIB_SEL(attr, 0)
+#define UIC_ARG_ATTR_TYPE(t)		(((t) & 0xFF) << 16)
+#define UIC_GET_ATTR_ID(v)		(((v) >> 16) & 0xFFFF)
+
 /* UIC Commands */
 enum {
 	UIC_CMD_DME_GET			= 0x01,
-- 
1.8.4

