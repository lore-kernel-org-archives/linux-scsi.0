From: Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH] [SCSI] mptfusion: fix compilation warning
Date: Wed, 14 Aug 2013 23:15:29 +0100
Message-ID: <1376518529-11411-1-git-send-email-luis.henriques@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, support@lsi.com, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Function seq_mpt_print_ioc_summary is invoked only from functions that
depend on CONFIG_PROC_FS.  This commit makes this function also depend
on this configuration.  Also removes function forward declaration.

It fixes the following warning:

drivers/message/fusion/mptbase.c:6884:13: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/message/fusion/mptbase.c | 65 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 767ff4d..5cbe611 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6637,7 +6637,38 @@ procmpt_destroy(void)
 /*
  *	Handles read request from /proc/mpt/summary or /proc/mpt/iocN/summary.
  */
-static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan);
+
+static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan)
+{
+	char expVer[32];
+
+	mpt_get_fw_exp_ver(expVer, ioc);
+
+	/*
+	 *  Shorter summary of attached ioc's...
+	 */
+	seq_printf(m, "%s: %s, %s%08xh%s, Ports=%d, MaxQ=%d",
+			ioc->name,
+			ioc->prod_name,
+			MPT_FW_REV_MAGIC_ID_STRING,	/* "FwRev=" or somesuch */
+			ioc->facts.FWVersion.Word,
+			expVer,
+			ioc->facts.NumberOfPorts,
+			ioc->req_depth);
+
+	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
+		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
+		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
+			a[5], a[4], a[3], a[2], a[1], a[0]);
+	}
+
+	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
+
+	if (!ioc->active)
+		seq_printf(m, " (disabled)");
+
+	seq_putc(m, '\n');
+}
 
 static int mpt_summary_proc_show(struct seq_file *m, void *v)
 {
@@ -6881,38 +6912,6 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
 	*size = y;
 }
 
-static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan)
-{
-	char expVer[32];
-
-	mpt_get_fw_exp_ver(expVer, ioc);
-
-	/*
-	 *  Shorter summary of attached ioc's...
-	 */
-	seq_printf(m, "%s: %s, %s%08xh%s, Ports=%d, MaxQ=%d",
-			ioc->name,
-			ioc->prod_name,
-			MPT_FW_REV_MAGIC_ID_STRING,	/* "FwRev=" or somesuch */
-			ioc->facts.FWVersion.Word,
-			expVer,
-			ioc->facts.NumberOfPorts,
-			ioc->req_depth);
-
-	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
-		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
-			a[5], a[4], a[3], a[2], a[1], a[0]);
-	}
-
-	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
-
-	if (!ioc->active)
-		seq_printf(m, " (disabled)");
-
-	seq_putc(m, '\n');
-}
-
 /**
  *	mpt_set_taskmgmt_in_progress_flag - set flags associated with task management
  *	@ioc: Pointer to MPT_ADAPTER structure
-- 
1.8.3.2
