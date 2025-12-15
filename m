Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A902459FD;
	Mon, 15 Dec 2025 08:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765788952; cv=none; b=RX5SFw/MXFTbWCaDlT4Oh6ONtM9X+24LkIkam5HCfxNZM+2ty+URUmhZKwDXZZLSozPwhOv49R0sQ//KYK7dHNiWoIXQZCYe7HvDJRpx6ZOwi7SFaZI8GsJskv6DHBd0LKF7FpA5zEFj0scPEJqtXEvDqoRnwrMke39r8sLIMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765788952; c=relaxed/simple;
	bh=6bc0N81lkKTWpXRAEmEShQ78p7g+vGyAdvbMl9nmS8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq6eESHHldmKSaoRPKrBrPanVycb/dI+cKmm5Vr9Wo3mc4dznVzfHzdb1TcS+V0XbGojC/OOCD0QYxXHQdgScr85bubwnjlaYTM031nlQtGF54Ope+X7FeOTeJfVSQsKNlMI70O5WbS/93iLtWZyGbBRobbjq1griavYBjAdMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDfN/JAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDfN/JAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61D1C19421;
	Mon, 15 Dec 2025 08:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765788952;
	bh=6bc0N81lkKTWpXRAEmEShQ78p7g+vGyAdvbMl9nmS8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDfN/JAfcKs9GMAo3QIY633qAO+wvhCfAqMp2qcjcy4b0LvYEGKR3UGZbC7fj4pDe
	 cgCR3D1P8oyx82z0HDhoGFaBL5RvaZaEGtPBT2QvfD6Xvs4Hnk78qD39CV6BqoUfFs
	 7YDLaUEH10WnBHdQ6/OOXjXMP2m/gmQgf5R3f/JyHQnsBpLVRJvl4qVc/6xA7PTnIc
	 I9WxMyBD8I49vNg62+bKlLtre/GRAPZxNKDHbIo88SOtERWOiW17EnfognNOJRzV7R
	 +tCx4Z6mKmG3bH0myfJvd0Hk8wW8GLuSoJsv23mPOkWbUCEv16kEbuDbo9LArEVQcW
	 I1QkJ0OngF5GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wen Xiong <wenxiong@linux.ibm.com>,
	Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: ipr: Enable/disable IRQD_NO_BALANCING during reset
Date: Mon, 15 Dec 2025 03:55:27 -0500
Message-ID: <20251215085533.2931615-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215085533.2931615-1-sashal@kernel.org>
References: <20251215085533.2931615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Transfer-Encoding: 8bit

From: Wen Xiong <wenxiong@linux.ibm.com>

[ Upstream commit 6ac3484fb13b2fc7f31cfc7f56093e7d0ce646a5 ]

A dynamic remove/add storage adapter test hits EEH on PowerPC:

  EEH: [c00000000004f75c] __eeh_send_failure_event+0x7c/0x160
  EEH: [c000000000048444] eeh_dev_check_failure.part.0+0x254/0x650
  EEH: [c008000001650678] eeh_readl+0x60/0x90 [ipr]
  EEH: [c00800000166746c] ipr_cancel_op+0x2b8/0x524 [ipr]
  EEH: [c008000001656524] ipr_eh_abort+0x6c/0x130 [ipr]
  EEH: [c000000000ab0d20] scmd_eh_abort_handler+0x140/0x440
  EEH: [c00000000017e558] process_one_work+0x298/0x590
  EEH: [c00000000017eef8] worker_thread+0xa8/0x620
  EEH: [c00000000018be34] kthread+0x124/0x130
  EEH: [c00000000000cd64] ret_from_kernel_thread+0x5c/0x64

A PCIe bus trace reveals that a vector of MSI-X is cleared to 0 by
irqbalance daemon. If we disable irqbalance daemon, we won't see the
issue.

With debug enabled in ipr driver:

  [   44.103071] ipr: Entering __ipr_remove
  [   44.103083] ipr: Entering ipr_initiate_ioa_bringdown
  [   44.103091] ipr: Entering ipr_reset_shutdown_ioa
  [   44.103099] ipr: Leaving ipr_reset_shutdown_ioa
  [   44.103105] ipr: Leaving ipr_initiate_ioa_bringdown
  [   44.149918] ipr: Entering ipr_reset_ucode_download
  [   44.149935] ipr: Entering ipr_reset_alert
  [   44.150032] ipr: Entering ipr_reset_start_timer
  [   44.150038] ipr: Leaving ipr_reset_alert
  [   44.244343] scsi 1:2:3:0: alua: Detached
  [   44.254300] ipr: Entering ipr_reset_start_bist
  [   44.254320] ipr: Entering ipr_reset_start_timer
  [   44.254325] ipr: Leaving ipr_reset_start_bist
  [   44.364329] scsi 1:2:4:0: alua: Detached
  [   45.134341] scsi 1:2:5:0: alua: Detached
  [   45.860949] ipr: Entering ipr_reset_shutdown_ioa
  [   45.860962] ipr: Leaving ipr_reset_shutdown_ioa
  [   45.860966] ipr: Entering ipr_reset_alert
  [   45.861028] ipr: Entering ipr_reset_start_timer
  [   45.861035] ipr: Leaving ipr_reset_alert
  [   45.964302] ipr: Entering ipr_reset_start_bist
  [   45.964309] ipr: Entering ipr_reset_start_timer
  [   45.964313] ipr: Leaving ipr_reset_start_bist
  [   46.264301] ipr: Entering ipr_reset_bist_done
  [   46.264309] ipr: Leaving ipr_reset_bist_done

During adapter reset, ipr device driver blocks config space access but
can't block MMIO access for MSI-X entries.  There is very small window:
irqbalance daemon kicks in during adapter reset before ipr driver calls
pci_restore_state(pdev) to restore MSI-X table.

irqbalance daemon reads back all 0 for that MSI-X vector in
__pci_read_msi_msg().

irqbalance daemon:

  msi_domain_set_affinity()
  ->irq_chip_set_affinity_patent()
  ->xive_irq_set_affinity()
  ->irq_chip_compose_msi_msg()
    ->pseries_msi_compose_msg()
    ->__pci_read_msi_msg(): read all 0 since didn't call pci_restore_state
  ->irq_chip_write_msi_msg()
    -> pci_write_msg_msi(): write 0 to the msix vector entry

When ipr driver calls pci_restore_state(pdev) in
ipr_reset_restore_cfg_space(), the MSI-X vector entry has been cleared
by irqbalance daemon in pci_write_msg_msix().

  pci_restore_state()
  ->__pci_restore_msix_state()

Below is the MSI-X table for ipr adapter after irqbalance daemon kicked
in during adapter reset:

  Dump MSIx table: index=0 address_lo=c800 address_hi=10000000 msg_data=0
  Dump MSIx table: index=1 address_lo=c810 address_hi=10000000 msg_data=0
  Dump MSIx table: index=2 address_lo=c820 address_hi=10000000 msg_data=0
  Dump MSIx table: index=3 address_lo=c830 address_hi=10000000 msg_data=0
  Dump MSIx table: index=4 address_lo=c840 address_hi=10000000 msg_data=0
  Dump MSIx table: index=5 address_lo=c850 address_hi=10000000 msg_data=0
  Dump MSIx table: index=6 address_lo=c860 address_hi=10000000 msg_data=0
  Dump MSIx table: index=7 address_lo=c870 address_hi=10000000 msg_data=0
  Dump MSIx table: index=8 address_lo=0 address_hi=0 msg_data=0
  ---------> Hit EEH since msix vector of index=8 are 0
  Dump MSIx table: index=9 address_lo=c890 address_hi=10000000 msg_data=0
  Dump MSIx table: index=10 address_lo=c8a0 address_hi=10000000 msg_data=0
  Dump MSIx table: index=11 address_lo=c8b0 address_hi=10000000 msg_data=0
  Dump MSIx table: index=12 address_lo=c8c0 address_hi=10000000 msg_data=0
  Dump MSIx table: index=13 address_lo=c8d0 address_hi=10000000 msg_data=0
  Dump MSIx table: index=14 address_lo=c8e0 address_hi=10000000 msg_data=0
  Dump MSIx table: index=15 address_lo=c8f0 address_hi=10000000 msg_data=0

  [   46.264312] ipr: Entering ipr_reset_restore_cfg_space
  [   46.267439] ipr: Entering ipr_fail_all_ops
  [   46.267447] ipr: Leaving ipr_fail_all_ops
  [   46.267451] ipr: Leaving ipr_reset_restore_cfg_space
  [   46.267454] ipr: Entering ipr_ioa_bringdown_done
  [   46.267458] ipr: Leaving ipr_ioa_bringdown_done
  [   46.267467] ipr: Entering ipr_worker_thread
  [   46.267470] ipr: Leaving ipr_worker_thread

IRQ balancing is not required during adapter reset.

Enable "IRQ_NO_BALANCING" flag before starting adapter reset and disable
it after calling pci_restore_state(). The irqbalance daemon is disabled
for this short period of time (~2s).

Co-developed-by: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Signed-off-by: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.ibm.com>
Link: https://patch.msgid.link/20251028142427.3969819-2-wenxiong@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The APIs are well-established with 124 callers for
`irq_set_status_flags` - this approach is standard practice in the
kernel.

---

## Summary

**Why this should be backported:**

1. **Fixes a real, serious bug**: EEH events on PowerPC are significant
   hardware errors that can cause system instability and require
   recovery
2. **Clear root cause and fix**: Race condition between irqbalance
   daemon and adapter reset is clearly identified and surgically fixed
3. **Small, self-contained change**: ~30 lines added to a single driver
   file
4. **Uses standard kernel APIs**: `irq_set_status_flags()` and
   `irq_clear_status_flags()` are used by 124+ other callers - well-
   tested mechanism
5. **Low regression risk**: Changes only affect the ipr driver during
   adapter reset, no impact on other subsystems
6. **Critical for affected users**: Systems running IBM Power with ipr
   storage adapters and irqbalance enabled will hit this during hot-plug
   operations
7. **No dependencies**: All required APIs have been in the kernel for
   many years

**Risk Assessment**: LOW
- The fix is narrowly scoped to the reset path
- Uses battle-tested IRQ infrastructure
- Only affects ipr driver users during specific operations

**Benefit**: HIGH for affected users - prevents EEH crashes during
adapter reset operations

This commit meets all stable kernel criteria: it fixes a real bug, is
obviously correct, is small and contained, and introduces no new
features. The mechanism used (temporarily disabling IRQ balancing during
critical operations) is a standard pattern used throughout the kernel.

**YES**

 drivers/scsi/ipr.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 44214884deaf5..d62bb7d0e4164 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -61,8 +61,8 @@
 #include <linux/hdreg.h>
 #include <linux/reboot.h>
 #include <linux/stringify.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/processor.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -7843,6 +7843,30 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 	return IPR_RC_JOB_RETURN;
 }
 
+/**
+ * ipr_set_affinity_nobalance
+ * @ioa_cfg:	ipr_ioa_cfg struct for an ipr device
+ * @flag:	bool
+ *	true: ensable "IRQ_NO_BALANCING" bit for msix interrupt
+ *	false: disable "IRQ_NO_BALANCING" bit for msix interrupt
+ * Description: This function will be called to disable/enable
+ *	"IRQ_NO_BALANCING" to avoid irqbalance daemon
+ *	kicking in during adapter reset.
+ **/
+static void ipr_set_affinity_nobalance(struct ipr_ioa_cfg *ioa_cfg, bool flag)
+{
+	int irq, i;
+
+	for (i = 0; i < ioa_cfg->nvectors; i++) {
+		irq = pci_irq_vector(ioa_cfg->pdev, i);
+
+		if (flag)
+			irq_set_status_flags(irq, IRQ_NO_BALANCING);
+		else
+			irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+	}
+}
+
 /**
  * ipr_reset_restore_cfg_space - Restore PCI config space.
  * @ipr_cmd:	ipr command struct
@@ -7867,6 +7891,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 		return IPR_RC_JOB_CONTINUE;
 	}
 
+	ipr_set_affinity_nobalance(ioa_cfg, false);
 	ipr_fail_all_ops(ioa_cfg);
 
 	if (ioa_cfg->sis64) {
@@ -7946,6 +7971,7 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 		rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
 
 	if (rc == PCIBIOS_SUCCESSFUL) {
+		ipr_set_affinity_nobalance(ioa_cfg, true);
 		ipr_cmd->job_step = ipr_reset_bist_done;
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
-- 
2.51.0

