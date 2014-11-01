From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] fusion: move seq_mpt_print_ioc_summary under CONFIG_PROC_FS
Date: Sat,  1 Nov 2014 11:52:54 +0100
Message-ID: <1414839174-19401-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

replace seq_mpt_print_ioc_summary forward declaration under CONFIG_PROC_FS
by function declaration.

This fixes the following warning when CONFIG_PROC_FS is not set.

drivers/message/fusion/mptbase.c:6875:13: warning:
'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]
static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc,
struct seq_file *m, int showlan)

This patch also fixes some checkpatch warnings:
-lines over 80 characters
-(u8*) -> (u8 *)
-seq_puts instead of seq_printf for "(disabled)"
-blank line after declarations

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/message/fusion/mptbase.c | 67 ++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 187f836..6b60b2f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6628,7 +6628,40 @@ procmpt_destroy(void)
 /*
  *	Handles read request from /proc/mpt/summary or /proc/mpt/iocN/summary.
  */
-static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan);
+static void
+seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan)
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
+	if (showlan && (ioc->pfacts[0].ProtocolFlags &
+	    MPI_PORTFACTS_PROTOCOL_LAN)) {
+		u8 *a = (u8 *)&ioc->lan_cnfg_page1.HardwareAddressLow;
+
+		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
+			a[5], a[4], a[3], a[2], a[1], a[0]);
+	}
+
+	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
+
+	if (!ioc->active)
+		seq_puts(m, " (disabled)");
+
+	seq_putc(m, '\n');
+}
 
 static int mpt_summary_proc_show(struct seq_file *m, void *v)
 {
@@ -6872,38 +6905,6 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
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
1.9.3
