From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [RFC] pci: Rework config space blocking services
Date: Wed, 07 Sep 2011 08:46:23 -0500
Message-ID: <4E6775AF.40606@linux.vnet.ibm.com>
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com> <4E5BDEAB.5000405@siemens.com> <20110829191858.GA9415@redhat.com> <4E608A51.70509@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <4E608A51.70509@siemens.com>
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Here is how I would prefer to rework ipr. 

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center



The PCI config space blocking API has changed to better
allow for multiple users. Update ipr to use the new API.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ipr.h |    1 
 2 files changed, 60 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_new_pci_block drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_new_pci_block	2011-09-06 16:52:47.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2011-09-07 08:34:54.000000000 -0500
@@ -7639,8 +7639,12 @@ static int ipr_reset_restore_cfg_space(s
  **/
 static int ipr_reset_bist_done(struct ipr_cmnd *ipr_cmd)
 {
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
 	ENTER;
-	pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+	if (ioa_cfg->ucfg_blocked)
+		pci_unblock_cfg_access(ioa_cfg->pdev);
+	ioa_cfg->ucfg_blocked = 0;
 	ipr_cmd->job_step = ipr_reset_restore_cfg_space;
 	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
@@ -7661,8 +7665,6 @@ static int ipr_reset_start_bist(struct i
 	int rc = PCIBIOS_SUCCESSFUL;
 
 	ENTER;
-	pci_block_user_cfg_access(ioa_cfg->pdev);
-
 	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
 		writel(IPR_UPROCI_SIS64_START_BIST,
 		       ioa_cfg->regs.set_uproc_interrupt_reg32);
@@ -7674,7 +7676,9 @@ static int ipr_reset_start_bist(struct i
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
 	} else {
-		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+		if (ioa_cfg->ucfg_blocked)
+			pci_unblock_cfg_access(ipr_cmd->ioa_cfg->pdev);
+		ioa_cfg->ucfg_blocked = 0;
 		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
 		rc = IPR_RC_JOB_CONTINUE;
 	}
@@ -7717,7 +7721,6 @@ static int ipr_reset_slot_reset(struct i
 	struct pci_dev *pdev = ioa_cfg->pdev;
 
 	ENTER;
-	pci_block_user_cfg_access(pdev);
 	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
 	ipr_cmd->job_step = ipr_reset_slot_reset_done;
 	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
@@ -7726,6 +7729,55 @@ static int ipr_reset_slot_reset(struct i
 }
 
 /**
+ * ipr_reset_block_config_access_wait - Wait for permission to block config access
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This attempts to block config access to the IOA.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_block_config_access_wait(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	int rc = IPR_RC_JOB_CONTINUE;
+
+	if (pci_block_cfg_access_in_atomic(ioa_cfg->pdev)) {
+		if (ipr_cmd->u.time_left) {
+			rc = IPR_RC_JOB_RETURN;
+			ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
+			ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
+		} else {
+			ipr_cmd->job_step = ioa_cfg->reset;
+			dev_err(&ioa_cfg->pdev->dev,
+				"Timed out waiting to block config access. Resetting anyway.\n");
+		}
+	} else {
+		ioa_cfg->ucfg_blocked = 1;
+		ipr_cmd->job_step = ioa_cfg->reset;
+	}
+
+	return rc;
+}
+
+/**
+ * ipr_reset_block_config_access - Block config access to the IOA
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This attempts to block config access to the IOA
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE
+ **/
+static int ipr_reset_block_config_access(struct ipr_cmnd *ipr_cmd)
+{
+	ipr_cmd->ioa_cfg->ucfg_blocked = 0;
+	ipr_cmd->job_step = ipr_reset_block_config_access_wait;
+	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
  * ipr_reset_allowed - Query whether or not IOA can be reset
  * @ioa_cfg:	ioa config struct
  *
@@ -7764,7 +7816,7 @@ static int ipr_reset_wait_to_start_bist(
 		ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
 		ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
 	} else {
-		ipr_cmd->job_step = ioa_cfg->reset;
+		ipr_cmd->job_step = ipr_reset_block_config_access;
 		rc = IPR_RC_JOB_CONTINUE;
 	}
 
@@ -7797,7 +7849,7 @@ static int ipr_reset_alert(struct ipr_cm
 		writel(IPR_UPROCI_RESET_ALERT, ioa_cfg->regs.set_uproc_interrupt_reg32);
 		ipr_cmd->job_step = ipr_reset_wait_to_start_bist;
 	} else {
-		ipr_cmd->job_step = ioa_cfg->reset;
+		ipr_cmd->job_step = ipr_reset_block_config_access;
 	}
 
 	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
diff -puN drivers/scsi/ipr.h~ipr_new_pci_block drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_new_pci_block	2011-09-07 07:29:20.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2011-09-07 08:10:29.000000000 -0500
@@ -1384,6 +1384,7 @@ struct ipr_ioa_cfg {
 	u8 needs_warm_reset:1;
 	u8 msi_received:1;
 	u8 sis64:1;
+	u8 ucfg_blocked:1;
 
 	u8 revid;
 
_
