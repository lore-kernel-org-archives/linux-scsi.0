From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] add support for DWC UFS Host Controller
Date: Mon,  1 Feb 2016 12:47:05 +0000
Message-ID: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch includes:
- quirks in the ufs core driver to support Synopsys MPHY Test Chip config
- quirks in the ufs core driver to support DWC configuration sequence
- New Unipro attributes were added
- ufs core driver was tweaked to support UFS 2.0
- support for Synopsys PCI ID in the pci glue driver
- new platform glue driver for Synopsys devices

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  16 +
 drivers/scsi/ufs/Kconfig                          |  54 ++
 drivers/scsi/ufs/Makefile                         |   1 +
 drivers/scsi/ufs/ufs-dwc.c                        | 115 +++
 drivers/scsi/ufs/ufshcd-pci.c                     |   2 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                  |   2 +-
 drivers/scsi/ufs/ufshcd.c                         | 822 +++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h                         |  15 +
 drivers/scsi/ufs/ufshci.h                         |  29 +
 drivers/scsi/ufs/unipro.h                         |  39 +
 10 files changed, 1089 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c

diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
new file mode 100644
index 0000000..fa361f2
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
@@ -0,0 +1,16 @@
+* Universal Flash Storage (UFS) DesignWare Host Controller
+
+DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "snps,ufshcd"
+- reg               : <registers mapping>
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+
+Example:
+	dwc_ufshcd@0xD0000000 {
+		compatible = "snps,ufshcd";
+		reg = < 0xD0000000 0x10000 >;
+		interrupts = < 24 >;
+	};
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 5f45307..5da4b8f 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -83,3 +83,57 @@ config SCSI_UFS_QCOM
 
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_DWC_HOOKS
+	bool "DesignWare hooks to UFS controller"
+	depends on SCSI_UFSHCD
+	---help---
+	  This selects the DesignWare hooks for the UFS host controller.
+
+	  Select this if you have a DesignWare UFS controller.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_PLAT
+	tristate "DesignWare UFS controller platform glue driver"
+	depends on SCSI_UFS_DWC_HOOKS && SCSI_UFSHCD_PLATFORM
+	---help---
+	  This selects the DesignWare UFS host controller platform glue driver.
+
+	  Select this if you have a DesignWare UFS controller on Platform bus.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_MPHY_TC
+	bool "Support for the Synopsys MPHY Test Chip"
+	depends on SCSI_UFS_DWC_PLAT
+	---help---
+	  This selects the support for the Synopsys MPHY Test Chip.
+
+	  Select this if you have a Synopsys MPHY Test Chip.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_MPHY_TC_GEN2
+	bool "Support for the Synopsys MPHY Test Chip Gen2"
+	depends on SCSI_UFS_DWC_20BIT_RMMI || SCSI_UFS_DWC_40BIT_RMMI
+	---help---
+	  This selects the support for the Synopsys MPHY Test Chip Gen2.
+
+	  Select this if you have a Synopsys MPHY Test Chip Gen2.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_20BIT_RMMI
+	bool "20-bit RMMI MPHY"
+	depends on SCSI_UFS_DWC_MPHY_TC
+	---help---
+	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
+
+	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
+	  If unsure, say N.
+
+config SCSI_UFS_DWC_40BIT_RMMI
+	bool "40-bit RMMI MPHY"
+	depends on SCSI_UFS_DWC_MPHY_TC
+	---help---
+	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
+
+	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..c14b9e3 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,5 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_DWC_PLAT) += ufs-dwc.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufs-dwc.c b/drivers/scsi/ufs/ufs-dwc.c
new file mode 100644
index 0000000..e4d70b7
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-dwc.c
@@ -0,0 +1,115 @@
+/* ==========================================================================
+ * The Synopsys DWC UFS Software Driver and documentation (hereinafter
+ * "Software") is an unsupported proprietary work of Synopsys, Inc. unless
+ * otherwise expressly agreed to in writing between Synopsys and you.
+ *
+ * The Software IS NOT an item of Licensed Software or Licensed Product under
+ * any End User Software License Agreement or Agreement for Licensed Product
+ * with Synopsys or any supplement thereto.  Permission is hereby granted,
+ * free of charge, to any person obtaining a copy of this software annotated
+ * with this license and the Software, to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject
+ * to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THIS SOFTWARE IS BEING DISTRIBUTED BY SYNOPSYS SOLELY ON AN "AS IS" BASIS
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE HEREBY DISCLAIMED. IN NO EVENT SHALL SYNOPSYS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
+ * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ * ==========================================================================
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/delay.h>
+
+#include "ufshcd.h"
+#include "ufshcd-pltfrm.h"
+
+/**
+ * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
+ *
+ */
+static struct ufs_hba_variant_ops ufs_hba_dwc_vops = {
+	.name                   = "dwc",
+};
+
+/**
+ * ufs_dwc_probe()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int ufs_dwc_probe(struct platform_device *pdev)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+
+	/* Perform generic probe */
+	err = ufshcd_pltfrm_init(pdev, &ufs_hba_dwc_vops);
+	if (err)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * ufs_dwc_remove()
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int ufs_dwc_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+
+	return 0;
+}
+
+static const struct of_device_id ufs_dwc_match[] = {
+	{
+		.compatible = "snps,ufshcd"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ufs_dwc_match);
+
+static const struct dev_pm_ops ufs_dwc_pm_ops = {
+	.suspend	= ufshcd_pltfrm_suspend,
+	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver ufs_dwc_driver = {
+	.probe		= ufs_dwc_probe,
+	.remove		= ufs_dwc_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
+	.driver		= {
+		.name	= "ufshcd-dwc",
+		.pm	= &ufs_dwc_pm_ops,
+		.of_match_table	= of_match_ptr(ufs_dwc_match),
+	},
+};
+
+module_platform_driver(ufs_dwc_driver);
+
+MODULE_ALIAS("platform:ufshcd-dwc");
+MODULE_DESCRIPTION("DesignWare UFS Host platform glue driver");
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d15eaa4..0ee6c62 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -167,6 +167,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index d2a7b12..0522891 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -353,6 +353,6 @@ EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
-MODULE_DESCRIPTION("UFS host controller Pltform bus based glue driver");
+MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 85cd256..05d309d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1223,6 +1223,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			ret = -EINVAL;
 		}
 		break;
+	case UTP_CMD_TYPE_UFS_STORAGE:
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
 		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
@@ -1287,6 +1288,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
 	unsigned long flags;
+	u32 upiu_flags;
 	int tag;
 	int err = 0;
 
@@ -1343,10 +1345,23 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(hba, lrbp);
+	if (hba->ufs_version == UFSHCI_VERSION_20) {
+		if (likely(lrbp->cmd)) {
+			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+					lrbp->cmd->sc_data_direction);
+			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+		} else
+			err = -EINVAL;
+	} else
+		ufshcd_compose_upiu(hba, lrbp);
+
 	err = ufshcd_map_sg(lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
@@ -1371,7 +1386,11 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
-	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 
@@ -3187,7 +3206,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
-		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
+		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
+			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete)
 				complete(hba->dev_cmd.complete);
 		}
@@ -5521,6 +5541,790 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
 
+#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
+/**
+ * ufshcd_dwc_program_clk_div()
+ * This function programs the clk divider value. This value is needed to
+ * provide 1 microsecond tick to unipro layer.
+ * @hba: Private Structure pointer
+ * @divider_val: clock divider value to be programmed
+ *
+ */
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+{
+	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
+}
+
+/**
+ * ufshcd_dwc_link_is_up()
+ * Check if link is up
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+{
+	int dme_result = 0;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+
+	if (dme_result == UFSHCD_LINK_IS_UP) {
+		ufshcd_set_link_active(hba);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * ufshcd_dwc_connection_setup()
+ * This function configures both the local side (host) and the peer side
+ * (device) unipro attributes to establish the connection to application/
+ * cport.
+ * This function is not required if the hardware is properly configured to
+ * have this connection setup on reset. But invoking this function does no
+ * harm and should be fine even working with any ufs device.
+ *
+ * @hba: pointer to drivers private data
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Local side Configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
+	if (ret)
+		goto out;
+
+
+	/* Peer side Configuration */
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_20bit_rmmi_lane0()
+ * This function configures Synopsys MPHY 20-bit RMMI Lane 0
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* TX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN0_TX), 0x01);
+	if (ret)
+		goto out;
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
+	/* TX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN0_TX), 0x19);
+	if (ret)
+		goto out;
+
+	/* RX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN0_RX), 0x19);
+	if (ret)
+		goto out;
+#else
+	/* TX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN0_TX), 0x1b);
+	if (ret)
+		goto out;
+
+	/* RX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN0_RX), 0x1b);
+	if (ret)
+		goto out;
+#endif
+
+	/* TX 20-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN0_TX), 0x12);
+	if (ret)
+		goto out;
+
+	/* TX dither configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+	if (ret)
+		goto out;
+
+	/* RX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* RX 20-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN0_RX), 2);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
+
+	/* Common block Direct Control 10 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL10), 0x04);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 19 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL19), 0x02);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN0_RX), 0x03);
+	if (ret)
+		goto out;
+
+	/* CFGRXOVR8 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN0_RX), 0x16);
+	if (ret)
+		goto out;
+
+	/* RXDIRECTCTRL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN0_RX), 0x42);
+
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG3 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN0_RX), 0xa4);
+
+	if (ret)
+		goto out;
+
+	/* RXCALCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* CFGOVR4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN0_RX), 0x28);
+	if (ret)
+		goto out;
+
+	/* RXSQCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN0_RX), 0x1E);
+	if (ret)
+		goto out;
+
+	/* CFGOVR6 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN0_RX), 0x2f);
+	if (ret)
+		goto out;
+
+	/* CBPRGPLL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGPLL2), 0x00);
+#endif
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_20bit_rmmi_lane1()
+ * This function configures Synopsys MPHY 20-bit RMMI Lane 1
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
+{
+	int connected_rx_lanes = 0;
+	int connected_tx_lanes = 0;
+	int ret = 0;
+
+	/* Get the available lane count */
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			&connected_rx_lanes);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			&connected_tx_lanes);
+
+	if (connected_tx_lanes == 2) {
+
+		/* TX Reference Clock 26MHz */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN1_TX), 0x0d);
+		if (ret)
+			goto out;
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
+		/* TX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN1_TX), 0x19);
+		if (ret)
+			goto out;
+#else
+		/* TX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN1_TX), 0x1b);
+		if (ret)
+			goto out;
+#endif
+		/* TX 20-bit RMMI Interface */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN1_TX), 0x12);
+		if (ret)
+			goto out;
+
+		/* TX dither configuration */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+		if (ret)
+			goto out;
+	}
+
+	if (connected_rx_lanes == 2) {
+
+		/* RX Reference Clock 26MHz */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
+		/* RX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN1_RX), 0x19);
+		if (ret)
+			goto out;
+#else
+		/* RX Configuration Clock Frequency Val; Divider setting */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN1_RX), 0x1b);
+		if (ret)
+			goto out;
+#endif
+		/* RX 20-bit RMMI Interface */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN1_RX), 2);
+		if (ret)
+			goto out;
+
+		/* RX Squelch Detector output is routed to RX hibern8 exit
+		 * signal
+		 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN1_RX), 0x80);
+		if (ret)
+			goto out;
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2
+		/* ENARXDIRECTCFG4 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN1_RX), 0x03);
+		if (ret)
+			goto out;
+
+		/* CFGRXOVR8 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN1_RX), 0x16);
+		if (ret)
+			goto out;
+
+		/* RXDIRECTCTRL2 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN1_RX), 0x42);
+		if (ret)
+			goto out;
+
+		/* ENARXDIRECTCFG3 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN1_RX), 0xa4);
+		if (ret)
+			goto out;
+
+		/* RXCALCTRL */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+		/* ENARXDIRECTCFG2 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN1_RX), 0x01);
+		if (ret)
+			goto out;
+
+		/* CFGOVR4 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN1_RX), 0x28);
+		if (ret)
+			goto out;
+
+		/* RXSQCTRL */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN1_RX), 0x1E);
+		if (ret)
+			goto out;
+
+		/* CFGOVR6 */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN1_RX), 0x2f);
+		if (ret)
+			goto out;
+#endif
+	}
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_20bit_rmmi()
+ * This function configures Synopsys MPHY specific atributes (20-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_20bit_rmmi(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Common block Tx Global Hibernate Exit */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00);
+	if (ret)
+		goto out;
+
+	/* Common block Reference Clock Mode 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(REFCLKMODE), 0x01);
+	if (ret)
+		goto out;
+
+	/* Common block DCO Target Frequency MAX PWM G1:9Mpbs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CDIRECTCTRL6), 0xc0);
+	if (ret)
+		goto out;
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/20 = 350KHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDIVFACTOR), 0x44);
+	if (ret)
+		goto out;
+
+	/* Common Block DC0 Ctrl 5*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDCOCTRL5), 0x64);
+	if (ret)
+		goto out;
+
+	/* Common Block Program Tunning*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGTUNING), 0x09);
+	if (ret)
+		goto out;
+
+	/* Common Block Real Time Observe Select - for debugging */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(RTOBSERVESELECT), 0x00);
+	if (ret)
+		goto out;
+
+	/* Lane 0 configuration*/
+	ret = ufshcd_dwc_setup_20bit_rmmi_lane0(hba);
+	if (ret)
+		goto out;
+
+	/* Lane 1 configuration*/
+	ret = ufshcd_dwc_setup_20bit_rmmi_lane1(hba);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_40bit_rmmi()
+ * This function configures Synopsys MPHY specific atributes (40-bit RMMI)
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success or non-zero value on failure
+ */
+int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Common block Tx Global Hibernate Exit */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00);
+	if (ret)
+		goto out;
+
+	/* Common block Reference Clock Mode 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(REFCLKMODE), 0x01);
+	if (ret)
+		goto out;
+
+	/* Common block DCO Target Frequency MAX PWM G1:7Mpbs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CDIRECTCTRL6), 0x80);
+	if (ret)
+		goto out;
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/40 = 175KHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDIVFACTOR), 0x08);
+	if (ret)
+		goto out;
+
+	/* Common Block DC0 Ctrl 5*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBDCOCTRL5), 0x64);
+	if (ret)
+		goto out;
+
+	/* Common Block Program Tunning*/
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGTUNING), 0x09);
+	if (ret)
+		goto out;
+
+	/* Common Block Real Time Observe Select - for debugging */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(RTOBSERVESELECT), 0x00);
+	if (ret)
+		goto out;
+
+	/* Lane 0 configuration*/
+
+	/* TX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
+							SELIND_LN0_TX), 0x01);
+	if (ret)
+		goto out;
+
+	/* TX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL,
+							SELIND_LN0_TX), 0x19);
+	if (ret)
+		goto out;
+
+	/* TX 40-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGEXTRATTR,
+							SELIND_LN0_TX), 0x14);
+	if (ret)
+		goto out;
+
+	/* TX dither configuration */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(DITHERCTRL2,
+							SELIND_LN0_TX), 0xd6);
+	if (ret)
+		goto out;
+
+	/* RX Reference Clock 26MHz */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_REFCLKFREQ,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* RX Configuration Clock Frequency Val; Divider setting */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL,
+							SELIND_LN0_RX), 0x19);
+	if (ret)
+		goto out;
+
+	/* RX 40-bit RMMI Interface */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGWIDEINLN,
+							SELIND_LN0_RX), 4);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 10 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL10), 0x04);
+	if (ret)
+		goto out;
+
+	/* Common block Direct Control 19 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(DIRECTCTRL19), 0x02);
+	if (ret)
+		goto out;
+
+	/* RX Squelch Detector output is routed to RX hibern8 exit signal */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXCDR8,
+							SELIND_LN0_RX), 0x80);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG4,
+							SELIND_LN0_RX), 0x03);
+	if (ret)
+		goto out;
+
+	/* CFGRXOVR8 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR8,
+							SELIND_LN0_RX), 0x16);
+	if (ret)
+		goto out;
+
+	/* RXDIRECTCTRL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXDIRECTCTRL2,
+							SELIND_LN0_RX), 0x42);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG3 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG3,
+							SELIND_LN0_RX), 0xa4);
+	if (ret)
+		goto out;
+
+	/* RXCALCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXCALCTRL,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* ENARXDIRECTCFG2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(ENARXDIRECTCFG2,
+							SELIND_LN0_RX), 0x01);
+	if (ret)
+		goto out;
+
+	/* CFGOVR4 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR4,
+							SELIND_LN0_RX), 0x28);
+	if (ret)
+		goto out;
+
+	/* RXSQCTRL */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RXSQCTRL,
+							SELIND_LN0_RX), 0x1E);
+	if (ret)
+		goto out;
+
+	/* CFGOVR6 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CFGRXOVR6,
+							SELIND_LN0_RX), 0x2f);
+	if (ret)
+		goto out;
+
+	/* CBPRGPLL2 */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBPRGPLL2), 0x00);
+	if (ret)
+		goto out;
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_setup_mphy()
+ * This function configures Local (host) Synopsys MPHY specific attributes
+ *
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int ufshcd_dwc_setup_mphy(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
+	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
+	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "40-bit RMMI configuration failed");
+		goto out;
+	}
+#else
+#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
+	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
+	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
+	if (ret) {
+		dev_err(hba->dev, "20-bit RMMI configuration failed");
+		goto out;
+	}
+#endif
+#endif
+	/* To write Shadow register bank to effective configuration block */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 0x01);
+	if (ret)
+		goto out;
+
+	/* To configure Debug OMC */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), 0x01);
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_dwc_host_init()
+ * UFS Host DWC specific initialization
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_host_configuration(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	/* Program Clock Divider Value */
+	ufshcd_dwc_program_clk_div(hba, UFSHCD_CLK_DIV_125);
+
+#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC
+	ret = ufshcd_dwc_setup_mphy(hba);
+	if (ret) {
+		dev_err(hba->dev, "MPHY configuration failed (%d)", ret);
+		goto out;
+	}
+#endif
+	ret = ufshcd_dme_link_startup(hba);
+	if (ret) {
+		dev_err(hba->dev, "Link Startup command failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_dwc_link_is_up(hba);
+	if (ret) {
+		dev_err(hba->dev, "Link is not up");
+		goto out;
+	}
+
+	ret = ufshcd_dwc_connection_setup(hba);
+	if (ret) {
+		dev_err(hba->dev, "Connection setup failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_make_hba_operational(hba);
+	if (ret) {
+		dev_err(hba->dev, "HBA kick start failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_verify_dev_init(hba);
+	if (ret) {
+		dev_err(hba->dev, "Device init failed (%d)", ret);
+		goto out;
+	}
+
+	ret = ufshcd_complete_dev_init(hba);
+	if (ret) {
+		dev_err(hba->dev, "Device final init failed (%d)", ret);
+		goto out;
+	}
+
+	ufshcd_set_ufs_dev_active(hba);
+	hba->wlun_dev_clr_ua = false;
+
+	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
+		scsi_unblock_requests(hba->host);
+
+	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+
+	scsi_scan_host(hba->host);
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ufshcd_dwc_host_configuration);
+#endif
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -5645,8 +6449,16 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_poweroff(hba);
 
+#ifndef CONFIG_SCSI_UFS_DWC_HOOKS
 	async_schedule(ufshcd_async_scan, hba);
-
+#else
+	/* Synopsys DWC Core + MPHY Test Chip needs a specific init routine */
+	err = ufshcd_dwc_host_configuration(hba);
+	if (err)
+		dev_err(dev, "DWC host configuration failed\n");
+	else
+		dev_info(dev, "DWC host configuration successful\n");
+#endif
 	return 0;
 
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2570d94..0e1c3d4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -554,6 +554,10 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
+/* DWC Core accepts both IRQ types but does not have this info in HW */
+#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
+	return true;
+#endif
 	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
 	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
 		return true;
@@ -587,6 +591,17 @@ int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
+#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
+void ufshcd_dwc_program_clk_div(struct ufs_hba *, u32);
+int ufshcd_dwc_link_is_up(struct ufs_hba *);
+int ufshcd_dwc_connection_setup(struct ufs_hba *);
+int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *);
+int ufshcd_dwc_setup_20bit_rmmi_lane1(struct ufs_hba *);
+int ufshcd_dwc_setup_20bit_rmmi(struct ufs_hba *);
+int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *);
+int ufshcd_dwc_setup_mphy(struct ufs_hba *);
+int ufshcd_dwc_host_configuration(struct ufs_hba *);
+#endif
 
 /**
  * ufshcd_hba_stop - Send controller to reset state
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0ae0967..9bf67fb 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -72,8 +72,28 @@ enum {
 	REG_UIC_COMMAND_ARG_1			= 0x94,
 	REG_UIC_COMMAND_ARG_2			= 0x98,
 	REG_UIC_COMMAND_ARG_3			= 0x9C,
+
+/* DWC UFS HC specific Registers */
+#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
+	DWC_UFS_REG_HCLKDIV			= 0xFC,
+#endif
 };
 
+#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
+/* Link Status*/
+enum {
+	UFSHCD_LINK_IS_DOWN			= 1,
+	UFSHCD_LINK_IS_UP			= 2,
+};
+
+/* Clock Divider Values: Hex equivalent of frequency in MHz */
+enum {
+	UFSHCD_CLK_DIV_62_5			= 0x3e,
+	UFSHCD_CLK_DIV_125			= 0x7d,
+	UFSHCD_CLK_DIV_200			= 0xc8,
+};
+#endif
+
 /* Controller capability masks */
 enum {
 	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
@@ -207,6 +227,14 @@ enum {
 #define CONFIG_RESULT_CODE_MASK		0xFF
 #define GENERIC_ERROR_CODE_MASK		0xFF
 
+/* Selector Index */
+enum selector_index {
+	SELIND_LN0_TX		= 0x00,
+	SELIND_LN1_TX		= 0x01,
+	SELIND_LN0_RX		= 0x04,
+	SELIND_LN1_RX		= 0x05,
+};
+
 /* GenSelectorIndex calculation macros for M-PHY attributes */
 #define UIC_ARG_MPHY_TX_GEN_SEL_INDEX(lane) (lane)
 
@@ -273,6 +301,7 @@ enum {
 	UTP_CMD_TYPE_SCSI		= 0x0,
 	UTP_CMD_TYPE_UFS		= 0x1,
 	UTP_CMD_TYPE_DEV_MANAGE		= 0x2,
+	UTP_CMD_TYPE_UFS_STORAGE	= 0x11,
 };
 
 enum {
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 816a8a4..da16254 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -35,6 +35,10 @@
 #define TX_LCC_SEQUENCER			0x0032
 #define TX_MIN_ACTIVATETIME			0x0033
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+#define TX_REFCLKFREQ				0x00EB
+#define TX_CFGCLKFREQVAL			0x00EC
+#define	CFGEXTRATTR				0x00F0
+#define DITHERCTRL2				0x00F1
 
 /*
  * M-RX Configuration Attributes
@@ -48,8 +52,38 @@
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
 #define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_REFCLKFREQ				0x00EB
+#define	RX_CFGCLKFREQVAL			0x00EC
+#define CFGWIDEINLN				0x00F0
+#define CFGRXCDR8				0x00BA
+#define ENARXDIRECTCFG4				0x00F2
+#define CFGRXOVR8				0x00BD
+#define RXDIRECTCTRL2				0x00C7
+#define ENARXDIRECTCFG3				0x00F3
+#define RXCALCTRL				0x00B4
+#define ENARXDIRECTCFG2				0x00F4
+#define CFGRXOVR4				0x00E9
+#define RXSQCTRL				0x00B5
+#define CFGRXOVR6				0x00BF
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+
+/*
+ * Common Block Attributes
+ */
+#define TX_GLOBALHIBERNATE			UNIPRO_CB_OFFSET(0x002B)
+#define REFCLKMODE				UNIPRO_CB_OFFSET(0x00BF)
+#define DIRECTCTRL19				UNIPRO_CB_OFFSET(0x00CD)
+#define DIRECTCTRL10				UNIPRO_CB_OFFSET(0x00E6)
+#define CDIRECTCTRL6				UNIPRO_CB_OFFSET(0x00EA)
+#define RTOBSERVESELECT				UNIPRO_CB_OFFSET(0x00F0)
+#define CBDIVFACTOR				UNIPRO_CB_OFFSET(0x00F1)
+#define CBDCOCTRL5				UNIPRO_CB_OFFSET(0x00F3)
+#define CBPRGPLL2				UNIPRO_CB_OFFSET(0x00F8)
+#define CBPRGTUNING				UNIPRO_CB_OFFSET(0x00FB)
+
+#define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
+
 /*
  * PHY Adpater attributes
  */
@@ -110,6 +144,11 @@
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
 
+/*Other attributes*/
+#define VS_MPHYCFGUPDT		0xD085
+#define VS_DEBUGOMC		0xD09E
+#define VS_POWERSTATE		0xD083
+
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
-- 
1.8.1.5
