From: vinholikatti@gmail.com
Subject: [PATCH V5 1/4] [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
Date: Thu, 27 Dec 2012 01:45:52 +0530
Message-ID: <50db5b09.644e420a.0ead.ffffbba7@mx.google.com>
References: <1356552955-18027-1-git-send-email-y>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2LZUQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2012 15:16:11 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so4939515pbc.5
        for <linux-scsi@vger.kernel.org>; Wed, 26 Dec 2012 12:16:10 -0800 (PST)
In-Reply-To: <1356552955-18027-1-git-send-email-y>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, Vinayak Holikatti <vinholikatti@gmail.com>

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch seggregates the PCI specific code in ufshcd.c to make it
ready for splitting into core ufs driver and PCI glue driver. Also
copyright header modification to remove extra warranty disclaim.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig  |   50 +++----
 drivers/scsi/ufs/ufs.h    |   42 ++----
 drivers/scsi/ufs/ufshcd.c |  339 +++++++++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshci.h |   42 ++----
 4 files changed, 255 insertions(+), 218 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8f27f9d..9c84569 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -2,45 +2,35 @@
 # Kernel configuration file for the UFS Host Controller
 #
 # This code is based on drivers/scsi/ufs/Kconfig
-# Copyright (C) 2011  Samsung Samsung India Software Operations
+# Copyright (C) 2011-2012 Samsung India Software Operations
+#
+# Authors:
+#	Santosh Yaraganavi <santosh.sy@samsung.com>
+#	Vinayak Holikatti <h.vinayak@samsung.com>
 #
-# Santosh Yaraganavi <santosh.sy@samsung.com>
-# Vinayak Holikatti <h.vinayak@samsung.com>
-
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License
 # as published by the Free Software Foundation; either version 2
 # of the License, or (at your option) any later version.
-
+# See the COPYING file in the top-level directory or visit
+# <http://www.gnu.org/licenses/gpl-2.0.html>
+#
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
-
-# NO WARRANTY
-# THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
-# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
-# LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
-# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
-# solely responsible for determining the appropriateness of using and
-# distributing the Program and assumes all risks associated with its
-# exercise of rights under this Agreement, including but not limited to
-# the risks and costs of program errors, damage to or loss of data,
-# programs or equipment, and unavailability or interruption of operations.
-
-# DISCLAIMER OF LIABILITY
-# NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
-# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-# DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
-# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
-# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-# USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
-# HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
-
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write to the Free Software
-# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-# USA.
+#
+# This program is provided "AS IS" and "WITH ALL FAULTS" and
+# without warranty of any kind. You are solely responsible for
+# determining the appropriateness of using and distributing
+# the program and assume all risks associated with your exercise
+# of rights with respect to the program, including but not limited
+# to infringement of third party rights, the risks and costs of
+# program errors, damage to or loss of data, programs or equipment,
+# and unavailability or interruption of operations. Under no
+# circumstances will the contributor of this Program be liable for
+# any damages of any kind arising from your use or distribution of
+# this program.
 
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage host controller driver"
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b207529..4b3d611 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -4,43 +4,33 @@
  * This code is based on drivers/scsi/ufs/ufs.h
  * Copyright (C) 2011-2012 Samsung India Software Operations
  *
- * Santosh Yaraganavi <santosh.sy@samsung.com>
- * Vinayak Holikatti <h.vinayak@samsung.com>
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
  * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * NO WARRANTY
- * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
- * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
- * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
- * solely responsible for determining the appropriateness of using and
- * distributing the Program and assumes all risks associated with its
- * exercise of rights under this Agreement, including but not limited to
- * the risks and costs of program errors, damage to or loss of data,
- * programs or equipment, and unavailability or interruption of operations.
-
- * DISCLAIMER OF LIABILITY
- * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
- * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
- * USA.
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
  */
 
 #ifndef _UFS_H
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 58f4ba6..86b5b49 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4,43 +4,33 @@
  * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2012 Samsung India Software Operations
  *
- * Santosh Yaraganavi <santosh.sy@samsung.com>
- * Vinayak Holikatti <h.vinayak@samsung.com>
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
  * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * NO WARRANTY
- * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
- * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
- * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
- * solely responsible for determining the appropriateness of using and
- * distributing the Program and assumes all risks associated with its
- * exercise of rights under this Agreement, including but not limited to
- * the risks and costs of program errors, damage to or loss of data,
- * programs or equipment, and unavailability or interruption of operations.
-
- * DISCLAIMER OF LIABILITY
- * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
- * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
- * USA.
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
  */
 
 #include <linux/module.h>
@@ -129,7 +119,7 @@ struct uic_command {
  * @utrdl_dma_addr: UTRDL DMA address
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
- * @pdev: PCI device handle
+ * @dev: device handle
  * @lrb: local reference block
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -159,7 +149,7 @@ struct ufs_hba {
 	dma_addr_t utmrdl_dma_addr;
 
 	struct Scsi_Host *host;
-	struct pci_dev *pdev;
+	struct device *dev;
 
 	struct ufshcd_lrb *lrb;
 
@@ -335,21 +325,21 @@ static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
 
 	if (hba->utmrdl_base_addr) {
 		utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-		dma_free_coherent(&hba->pdev->dev, utmrdl_size,
+		dma_free_coherent(hba->dev, utmrdl_size,
 				  hba->utmrdl_base_addr, hba->utmrdl_dma_addr);
 	}
 
 	if (hba->utrdl_base_addr) {
 		utrdl_size =
 		(sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, utrdl_size,
+		dma_free_coherent(hba->dev, utrdl_size,
 				  hba->utrdl_base_addr, hba->utrdl_dma_addr);
 	}
 
 	if (hba->ucdl_base_addr) {
 		ucdl_size =
 		(sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-		dma_free_coherent(&hba->pdev->dev, ucdl_size,
+		dma_free_coherent(hba->dev, ucdl_size,
 				  hba->ucdl_base_addr, hba->ucdl_dma_addr);
 	}
 }
@@ -724,7 +714,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
 						 ucdl_size,
 						 &hba->ucdl_dma_addr,
 						 GFP_KERNEL);
@@ -737,7 +727,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 */
 	if (!hba->ucdl_base_addr ||
 	    WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Command Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -747,13 +737,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTRD
 	 */
 	utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utrdl_base_addr = dma_alloc_coherent(hba->dev,
 						  utrdl_size,
 						  &hba->utrdl_dma_addr,
 						  GFP_KERNEL);
 	if (!hba->utrdl_base_addr ||
 	    WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Transfer Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -763,13 +753,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr = dma_alloc_coherent(&hba->pdev->dev,
+	hba->utmrdl_base_addr = dma_alloc_coherent(hba->dev,
 						   utmrdl_size,
 						   &hba->utmrdl_dma_addr,
 						   GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
 	    WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"Task Management Descriptor Memory allocation failed\n");
 		goto out;
 	}
@@ -777,7 +767,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	/* Allocate memory for local reference block */
 	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
 	if (!hba->lrb) {
-		dev_err(&hba->pdev->dev, "LRB Memory allocation failed\n");
+		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
@@ -867,7 +857,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	/* check if controller is ready to accept UIC commands */
 	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
 	    UIC_COMMAND_READY) == 0x0) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Controller not ready"
 			" to accept UIC commands\n");
 		return -EIO;
@@ -912,7 +902,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
 	if (!ufshcd_is_device_present(reg)) {
-		dev_err(&hba->pdev->dev, "cc: Device not present\n");
+		dev_err(hba->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -924,7 +914,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Host controller not ready to process requests");
 		err = -EIO;
 		goto out;
@@ -1005,7 +995,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		if (retry) {
 			retry--;
 		} else {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Controller enable failed\n");
 			return -EIO;
 		}
@@ -1084,7 +1074,7 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
 
 	/* start the initialization process */
 	if (ufshcd_initialize_hba(hba)) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Reset: Controller initialization failed\n");
 		return FAILED;
 	}
@@ -1167,7 +1157,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 			task_result = SUCCESS;
 	} else {
 		task_result = FAILED;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"trc: Invalid ocs = %x\n", ocs_value);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1281,7 +1271,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"Invalid response = %x\n", result);
 			break;
 		}
@@ -1310,7 +1300,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 		"OCS error from controller = %x\n", ocs);
 		break;
 	} /* end of switch */
@@ -1374,7 +1364,7 @@ static void ufshcd_uic_cc_handler (struct work_struct *work)
 	    !(ufshcd_get_uic_cmd_result(hba))) {
 
 		if (ufshcd_make_hba_operational(hba))
-			dev_err(&hba->pdev->dev,
+			dev_err(hba->dev,
 				"cc: hba not operational state\n");
 		return;
 	}
@@ -1509,7 +1499,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	free_slot = ufshcd_get_tm_free_slot(hba);
 	if (free_slot >= hba->nutmrs) {
 		spin_unlock_irqrestore(host->host_lock, flags);
-		dev_err(&hba->pdev->dev, "Task management queue full\n");
+		dev_err(hba->dev, "Task management queue full\n");
 		err = FAILED;
 		goto out;
 	}
@@ -1552,7 +1542,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 					 &hba->tm_condition) != 0),
 					 60 * HZ);
 	if (!err) {
-		dev_err(&hba->pdev->dev,
+		dev_err(hba->dev,
 			"Task management command timed-out\n");
 		err = FAILED;
 		goto out;
@@ -1688,23 +1678,22 @@ static struct scsi_host_template ufshcd_driver_template = {
 };
 
 /**
- * ufshcd_shutdown - main function to put the controller in reset state
+ * ufshcd_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
  */
-static void ufshcd_shutdown(struct pci_dev *pdev)
+static void ufshcd_pci_shutdown(struct pci_dev *pdev)
 {
 	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
 }
 
-#ifdef CONFIG_PM
 /**
  * ufshcd_suspend - suspend power management function
- * @pdev: pointer to PCI device handle
+ * @hba: per adapter instance
  * @state: power state
  *
  * Returns -ENOSYS
  */
-static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
+int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state)
 {
 	/*
 	 * TODO:
@@ -1717,14 +1706,15 @@ static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(ufshcd_suspend);
 
 /**
  * ufshcd_resume - resume power management function
- * @pdev: pointer to PCI device handle
+ * @hba: per adapter instance
  *
  * Returns -ENOSYS
  */
-static int ufshcd_resume(struct pci_dev *pdev)
+int ufshcd_resume(struct ufs_hba *hba)
 {
 	/*
 	 * TODO:
@@ -1737,6 +1727,43 @@ static int ufshcd_resume(struct pci_dev *pdev)
 
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(ufshcd_resume);
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_pci_suspend - suspend power management function
+ * @pdev: pointer to PCI device handle
+ * @state: power state
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_suspend
+	 * 2. Do bus specific power management
+	 */
+
+	return -ENOSYS;
+}
+
+/**
+ * ufshcd_pci_resume - resume power management function
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pci_resume(struct pci_dev *pdev)
+{
+	/*
+	 * TODO:
+	 * 1. Call ufshcd_resume.
+	 * 2. Do bus specific wake up
+	 */
+
+	return -ENOSYS;
+}
 #endif /* CONFIG_PM */
 
 /**
@@ -1748,27 +1775,38 @@ static void ufshcd_hba_free(struct ufs_hba *hba)
 {
 	iounmap(hba->mmio_base);
 	ufshcd_free_hba_memory(hba);
-	pci_release_regions(hba->pdev);
 }
 
 /**
- * ufshcd_remove - de-allocate PCI/SCSI host and host memory space
+ * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
- * @pdev - pointer to PCI handle
+ * @hba - per adapter instance
  */
-static void ufshcd_remove(struct pci_dev *pdev)
+void ufshcd_remove(struct ufs_hba *hba)
 {
-	struct ufs_hba *hba = pci_get_drvdata(pdev);
-
 	/* disable interrupts */
 	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
-	free_irq(pdev->irq, hba);
 
 	ufshcd_hba_stop(hba);
 	ufshcd_hba_free(hba);
 
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
+}
+EXPORT_SYMBOL_GPL(ufshcd_remove);
+
+/**
+ * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
+ *		data structure memory
+ * @pdev - pointer to PCI handle
+ */
+static void ufshcd_pci_remove(struct pci_dev *pdev)
+{
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	free_irq(pdev->irq, hba);
+	ufshcd_remove(hba);
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
@@ -1781,75 +1819,52 @@ static void ufshcd_remove(struct pci_dev *pdev)
  *
  * Returns 0 for success, non-zero for failure
  */
-static int ufshcd_set_dma_mask(struct ufs_hba *hba)
+static int ufshcd_set_dma_mask(struct pci_dev *pdev)
 {
 	int err;
-	u64 dma_mask;
-
-	/*
-	 * If controller supports 64 bit addressing mode, then set the DMA
-	 * mask to 64-bit, else set the DMA mask to 32-bit
-	 */
-	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
-		dma_mask = DMA_BIT_MASK(64);
-	else
-		dma_mask = DMA_BIT_MASK(32);
-
-	err = pci_set_dma_mask(hba->pdev, dma_mask);
-	if (err)
-		return err;
-
-	err = pci_set_consistent_dma_mask(hba->pdev, dma_mask);
 
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+		&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		return 0;
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	return err;
 }
 
 /**
- * ufshcd_probe - probe routine of the driver
- * @pdev: pointer to PCI device handle
- * @id: PCI device id
- *
+ * ufshcd_init - Driver initialization routine
+ * @dev: pointer to device handle
+ * @hba_handle: driver private handle
+ * @mmio_base: base register address
+ * @irq_line: Interrupt line of device
  * Returns 0 on success, non-zero value on failure
  */
-static int __devinit
-ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
+		 void __iomem *mmio_base, unsigned int irq_line)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
 	int err;
 
-	err = pci_enable_device(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
+	if (!dev && !mmio_base) {
+		dev_err(dev,
+		"Invalid memory reference for dev or mmio_base NULL\n");
+		err = -ENODEV;
 		goto out_error;
 	}
 
-	pci_set_master(pdev);
-
 	host = scsi_host_alloc(&ufshcd_driver_template,
 				sizeof(struct ufs_hba));
 	if (!host) {
-		dev_err(&pdev->dev, "scsi_host_alloc failed\n");
+		dev_err(dev, "scsi_host_alloc failed\n");
 		err = -ENOMEM;
-		goto out_disable;
+		goto out_error;
 	}
 	hba = shost_priv(host);
-
-	err = pci_request_regions(pdev, UFSHCD);
-	if (err < 0) {
-		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_host_put;
-	}
-
-	hba->mmio_base = pci_ioremap_bar(pdev, 0);
-	if (!hba->mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-
 	hba->host = host;
-	hba->pdev = pdev;
+	hba->dev = dev;
+	hba->mmio_base = mmio_base;
 
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
@@ -1857,17 +1872,11 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
-	err = ufshcd_set_dma_mask(hba);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
-	}
-
 	/* Allocate memory for host memory space */
 	err = ufshcd_memory_alloc(hba);
 	if (err) {
-		dev_err(&pdev->dev, "Memory allocation failed\n");
-		goto out_iounmap;
+		dev_err(hba->dev, "Memory allocation failed\n");
+		goto out_disable;
 	}
 
 	/* Configure LRB */
@@ -1889,46 +1898,104 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
 
 	/* IRQ registration */
-	err = request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = request_irq(irq_line, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
-		dev_err(&pdev->dev, "request irq failed\n");
+		dev_err(hba->dev, "request irq failed\n");
 		goto out_lrb_free;
 	}
 
 	/* Enable SCSI tag mapping */
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
-		dev_err(&pdev->dev, "init shared queue failed\n");
+		dev_err(hba->dev, "init shared queue failed\n");
 		goto out_free_irq;
 	}
 
-	pci_set_drvdata(pdev, hba);
-
-	err = scsi_add_host(host, &pdev->dev);
+	err = scsi_add_host(host, hba->dev);
 	if (err) {
-		dev_err(&pdev->dev, "scsi_add_host failed\n");
+		dev_err(hba->dev, "scsi_add_host failed\n");
 		goto out_free_irq;
 	}
 
 	/* Initialization routine */
 	err = ufshcd_initialize_hba(hba);
 	if (err) {
-		dev_err(&pdev->dev, "Initialization failed\n");
-		goto out_free_irq;
+		dev_err(hba->dev, "Initialization failed\n");
+		goto out_remove_scsi_host;
 	}
+	*hba_handle = hba;
 
 	return 0;
 
+out_remove_scsi_host:
+	scsi_remove_host(hba->host);
 out_free_irq:
-	free_irq(pdev->irq, hba);
+	free_irq(irq_line, hba);
 out_lrb_free:
 	ufshcd_free_hba_memory(hba);
+out_disable:
+	scsi_host_put(host);
+out_error:
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_init);
+
+/**
+ * ufshcd_pci_probe - probe routine of the driver
+ * @pdev: pointer to PCI device handle
+ * @id: PCI device id
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devinit
+ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		goto out_error;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_request_regions(pdev, UFSHCD);
+	if (err < 0) {
+		dev_err(&pdev->dev, "request regions failed\n");
+		goto out_disable;
+	}
+
+	mmio_base = pci_ioremap_bar(pdev, 0);
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "memory map failed\n");
+		err = -ENOMEM;
+		goto out_release_regions;
+	}
+
+	err = ufshcd_set_dma_mask(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "set dma mask failed\n");
+		goto out_iounmap;
+	}
+
+	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
+	if (err) {
+		dev_err(&pdev->dev, "%s:%d %sInitialization failed\n",
+				__FILE__, __LINE__, __func__);
+		goto out_iounmap;
+	}
+
+	pci_set_drvdata(pdev, hba);
+
+	return 0;
+
 out_iounmap:
-	iounmap(hba->mmio_base);
+	iounmap(mmio_base);
 out_release_regions:
 	pci_release_regions(pdev);
-out_host_put:
-	scsi_host_put(host);
 out_disable:
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
@@ -1946,19 +2013,19 @@ MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
 static struct pci_driver ufshcd_pci_driver = {
 	.name = UFSHCD,
 	.id_table = ufshcd_pci_tbl,
-	.probe = ufshcd_probe,
-	.remove = __devexit_p(ufshcd_remove),
-	.shutdown = ufshcd_shutdown,
+	.probe = ufshcd_pci_probe,
+	.remove = __devexit_p(ufshcd_pci_remove),
+	.shutdown = ufshcd_pci_shutdown,
 #ifdef CONFIG_PM
-	.suspend = ufshcd_suspend,
-	.resume = ufshcd_resume,
+	.suspend = ufshcd_pci_suspend,
+	.resume = ufshcd_pci_resume,
 #endif
 };
 
 module_pci_driver(ufshcd_pci_driver);
 
-MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
-	      "Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6e3510f..1cc1e00 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -4,43 +4,33 @@
  * This code is based on drivers/scsi/ufs/ufshci.h
  * Copyright (C) 2011-2012 Samsung India Software Operations
  *
- * Santosh Yaraganavi <santosh.sy@samsung.com>
- * Vinayak Holikatti <h.vinayak@samsung.com>
+ * Authors:
+ *	Santosh Yaraganavi <santosh.sy@samsung.com>
+ *	Vinayak Holikatti <h.vinayak@samsung.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
  * of the License, or (at your option) any later version.
+ * See the COPYING file in the top-level directory or visit
+ * <http://www.gnu.org/licenses/gpl-2.0.html>
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * NO WARRANTY
- * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
- * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
- * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
- * solely responsible for determining the appropriateness of using and
- * distributing the Program and assumes all risks associated with its
- * exercise of rights under this Agreement, including but not limited to
- * the risks and costs of program errors, damage to or loss of data,
- * programs or equipment, and unavailability or interruption of operations.
-
- * DISCLAIMER OF LIABILITY
- * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
- * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
- * USA.
+ * This program is provided "AS IS" and "WITH ALL FAULTS" and
+ * without warranty of any kind. You are solely responsible for
+ * determining the appropriateness of using and distributing
+ * the program and assume all risks associated with your exercise
+ * of rights with respect to the program, including but not limited
+ * to infringement of third party rights, the risks and costs of
+ * program errors, damage to or loss of data, programs or equipment,
+ * and unavailability or interruption of operations. Under no
+ * circumstances will the contributor of this Program be liable for
+ * any damages of any kind arising from your use or distribution of
+ * this program.
  */
 
 #ifndef _UFSHCI_H
-- 
1.7.5.4

