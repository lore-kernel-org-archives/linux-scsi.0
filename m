From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v2 4/4] scsi: ufs: inject errors to verify error handling
Date: Tue, 10 Feb 2015 15:58:55 +0200
Message-ID: <1423576735-26267-5-git-send-email-gbroner@codeaurora.org>
References: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>, Andi Kleen <ak@linux.intel.com>, Alexei Starovoitov <ast@plumgrid.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Al Viro <viro@zeniv.linux.org.uk>, Dan Streetman <ddstreet@ieee.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Use fault-injection framework to simulate error conditions
in the controller and verify error handling mechanisms
implemented in UFS host controller driver.

This is used only during development and hence
guarded by CONFIG_UFS_FAULT_INJECTION debug config option.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufs-debugfs.c | 140 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  12 +++-
 drivers/scsi/ufs/ufshcd.c      |   2 +
 drivers/scsi/ufs/ufshcd.h      |   5 ++
 lib/Kconfig.debug              |  14 +++++
 5 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index d1eb4f8..53dcb00 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <linux/random.h>
 #include "ufs-debugfs.h"
 #include "unipro.h"
 
@@ -41,6 +42,143 @@ struct desc_field_offset {
 	} while (0)
 #define DOORBELL_CLR_TOUT_US	(1000 * 1000) /* 1 sec */
 
+#ifdef CONFIG_UFS_FAULT_INJECTION
+
+#define INJECT_COMMAND_HANG (0x0)
+
+static DECLARE_FAULT_ATTR(fail_default_attr);
+static char *fail_request;
+module_param(fail_request, charp, 0);
+
+static bool inject_fatal_err_tr(struct ufs_hba *hba, u8 ocs_err)
+{
+	int tag;
+
+	tag = find_first_bit(&hba->outstanding_reqs, hba->nutrs);
+	if (tag == hba->nutrs)
+		return 0;
+
+	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	(&hba->lrb[tag])->utr_descriptor_ptr->header.dword_2 =
+							cpu_to_be32(ocs_err);
+
+	/* fatal error injected */
+	return 1;
+}
+
+static bool inject_fatal_err_tm(struct ufs_hba *hba, u8 ocs_err)
+{
+	int tag;
+
+	tag = find_first_bit(&hba->outstanding_tasks, hba->nutmrs);
+	if (tag == hba->nutmrs)
+		return 0;
+
+	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
+	(&hba->utmrdl_base_addr[tag])->header.dword_2 =
+						cpu_to_be32(ocs_err);
+
+	/* fatal error injected */
+	return 1;
+}
+
+static bool inject_cmd_hang_tr(struct ufs_hba *hba)
+{
+	int tag;
+
+	tag = find_first_bit(&hba->outstanding_reqs, hba->nutrs);
+	if (tag == hba->nutrs)
+		return 0;
+
+	__clear_bit(tag, &hba->outstanding_reqs);
+	hba->lrb[tag].cmd = NULL;
+	__clear_bit(tag, &hba->lrb_in_use);
+
+	/* command hang injected */
+	return 1;
+}
+
+static int inject_cmd_hang_tm(struct ufs_hba *hba)
+{
+	int tag;
+
+	tag = find_first_bit(&hba->outstanding_tasks, hba->nutmrs);
+	if (tag == hba->nutmrs)
+		return 0;
+
+	__clear_bit(tag, &hba->outstanding_tasks);
+	__clear_bit(tag, &hba->tm_slots_in_use);
+
+	/* command hang injected */
+	return 1;
+}
+
+void ufsdbg_fail_request(struct ufs_hba *hba, u32 *intr_status)
+{
+	u8 ocs_err;
+	static const u32 errors[] = {
+		CONTROLLER_FATAL_ERROR,
+		SYSTEM_BUS_FATAL_ERROR,
+		INJECT_COMMAND_HANG,
+	};
+
+	if (!should_fail(&hba->debugfs_files.fail_attr, 1))
+		goto out;
+
+	*intr_status = errors[prandom_u32() % ARRAY_SIZE(errors)];
+	dev_info(hba->dev, "%s: fault-inject error: 0x%x\n",
+			__func__, *intr_status);
+
+	switch (*intr_status) {
+	case CONTROLLER_FATAL_ERROR: /* fall through */
+		ocs_err = OCS_FATAL_ERROR;
+		goto set_ocs;
+	case SYSTEM_BUS_FATAL_ERROR:
+		ocs_err = OCS_INVALID_CMD_TABLE_ATTR;
+set_ocs:
+		if (!inject_fatal_err_tr(hba, ocs_err))
+			if (!inject_fatal_err_tm(hba, ocs_err))
+				*intr_status = 0;
+		break;
+	case INJECT_COMMAND_HANG:
+		if (!inject_cmd_hang_tr(hba))
+			inject_cmd_hang_tm(hba);
+		break;
+	default:
+		BUG();
+		/* some configurations ignore panics caused by BUG() */
+		break;
+	}
+out:
+	return;
+}
+
+static void ufsdbg_setup_fault_injection(struct ufs_hba *hba)
+{
+	hba->debugfs_files.fail_attr = fail_default_attr;
+
+	if (fail_request)
+		setup_fault_attr(&hba->debugfs_files.fail_attr, fail_request);
+
+	/* suppress dump stack everytime failure is injected */
+	hba->debugfs_files.fail_attr.verbose = 0;
+
+	if (IS_ERR(fault_create_debugfs_attr("inject_fault",
+					hba->debugfs_files.debugfs_root,
+					&hba->debugfs_files.fail_attr)))
+		dev_err(hba->dev, "%s: failed to create debugfs entry\n",
+				__func__);
+}
+#else
+void ufsdbg_fail_request(struct ufs_hba *hba, u32 *intr_status)
+{
+}
+
+static void ufsdbg_setup_fault_injection(struct ufs_hba *hba)
+{
+}
+#endif /* CONFIG_UFS_FAULT_INJECTION */
+
 #define BUFF_LINE_CAPACITY 16
 #define TAB_CHARS 8
 
@@ -885,6 +1023,8 @@ void ufsdbg_add_debugfs(struct ufs_hba *hba)
 		goto err;
 	}
 
+	ufsdbg_setup_fault_injection(hba);
+
 	return;
 
 err:
diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/scsi/ufs/ufs-debugfs.h
index de7680a..06ff2e4 100644
--- a/drivers/scsi/ufs/ufs-debugfs.h
+++ b/drivers/scsi/ufs/ufs-debugfs.h
@@ -27,6 +27,16 @@
 void ufsdbg_add_debugfs(struct ufs_hba *hba);
 
 void ufsdbg_remove_debugfs(struct ufs_hba *hba);
+void ufsdbg_fail_request(struct ufs_hba *hba, u32 *intr_status);
+#else
+void ufsdbg_add_debugfs(struct ufs_hba *hba)
+{
+}
+void ufsdbg_remove_debugfs(struct ufs_hba *hba)
+{
+}
+void ufsdbg_fail_request(struct ufs_hba *hba, u32 *intr_status)
+{
+}
 #endif
-
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aed8bfd..1c79fb4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4009,6 +4009,8 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
  */
 static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
+	ufsdbg_fail_request(hba, &intr_status);
+
 	hba->errors = UFSHCD_ERROR_MASK & intr_status;
 	if (hba->errors)
 		ufshcd_check_errors(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d9eb2ca..b065295 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -64,6 +64,8 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 
+#include <linux/fault-inject.h>
+
 #include "ufs.h"
 #include "ufshci.h"
 
@@ -283,6 +285,9 @@ struct debugfs_files {
 	struct dentry *dme_peer_read;
 	u32 dme_local_attr_id;
 	u32 dme_peer_attr_id;
+#ifdef CONFIG_UFS_FAULT_INJECTION
+	struct fault_attr fail_attr;
+#endif
 };
 
 /* tag stats statistics types */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5f2ce61..3fc79e7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1432,6 +1432,20 @@ config FAIL_MMC_REQUEST
 	  and to test how the mmc host driver handles retries from
 	  the block device.
 
+config UFS_FAULT_INJECTION
+	bool "Fault-injection capability for UFS IO"
+	select DEBUG_FS
+	depends on FAULT_INJECTION && SCSI_UFSHCD
+	help
+	 Provide fault-injection capability for UFS IO.
+	 This will make the UFS host controller driver to randomly
+	 abort ongoing commands in the host controller, update OCS
+	 field according to the injected fatal error and can also
+	 forcefully hang the command indefinitely till upper layer
+	 timeout occurs. This is useful to test error handling in
+	 the UFS contoller driver and test how the driver handles
+	 the retries from block/SCSI mid layer.
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
