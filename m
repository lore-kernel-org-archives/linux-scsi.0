From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 2/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Mon,  2 Jul 2012 20:02:50 +0530
Message-ID: <1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds Platform glue driver for ufshcd.

Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig         |   11 ++
 drivers/scsi/ufs/Makefile        |    1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c |  212 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 265a8c8..8c06330 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -67,3 +67,14 @@ config SCSI_UFSHCD_PCI
 	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config SCSI_UFSHCD_PLATFORM
+	tristate "Platform based UFS Controller support"
+	depends on SCSI_UFSHCD
+	---help---
+	This selects the UFS host controller support. If you have a
+	   platform with UFS controller, say Y or M here.
+
+	   If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9eda0df..1e5bd48 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,3 +1,4 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
+obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
new file mode 100644
index 0000000..2a43d31
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -0,0 +1,212 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd-pltfm.c
+ * Copyright (C) 2011-2012 Samsung India Software Operations
+ *
+ * Santosh Yaraganavi <santosh.sy@samsung.com>
+ * Vinayak Holikatti <h.vinayak@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+#include "ufshcd.h"
+#include "ufshcd_common.h"
+#include <linux/platform_device.h>
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_suspend - suspend power management function
+ * @pdev: pointer to Platform device handle
+ * @mesg: power state
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pltfrm_suspend(struct platform_device *pdev,
+				 pm_message_t mesg)
+{
+	/*
+	 * TODO:
+	 * 1. Block SCSI requests from SCSI midlayer
+	 * 2. Change the internal driver state to non operational
+	 * 3. Set UTRLRSR and UTMRLRSR bits to zero
+	 * 4. Wait until outstanding commands are completed
+	 * 5. Set HCE to zero to send the UFS host controller to reset state
+	 */
+
+	return -ENOSYS;
+}
+
+/**
+ * ufshcd_resume - resume power management function
+ * @pdev: pointer to Platform device handle
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_pltfrm_resume(struct platform_device *pdev)
+{
+	/*
+	 * TODO:
+	 * 1. Set HCE to 1, to start the UFS host controller
+	 * initialization process
+	 * 2. Set UTRLRSR and UTMRLRSR bits to 1
+	 * 3. Change the internal driver state to operational
+	 * 4. Unblock SCSI requests from SCSI midlayer
+	 */
+
+	return -ENOSYS;
+}
+#endif
+
+/**
+ * ufshcd_pltfrm_probe - probe routine of the driver
+ * @pdev: pointer to Platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devinit
+ufshcd_pltfrm_probe(struct platform_device *pdev)
+{
+	struct ufs_hba *hba;
+	void __iomem *mmio_base;
+	struct resource *mem_res;
+	struct resource *irq_res;
+	resource_size_t mem_size;
+	int err;
+	struct device *dev = &pdev->dev;
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev,
+			"%s: Memory resource not available\n", __FILE__);
+		err = -ENODEV;
+		goto out_error;
+	}
+
+	mem_size = resource_size(mem_res);
+	if (!request_mem_region(mem_res->start, mem_size, "ufshcd")) {
+		dev_err(&pdev->dev,
+			"ufshcd: Cannot reserve the memory resource\n");
+		err = -EBUSY;
+		goto out_error;
+	}
+
+	mmio_base = ioremap_nocache(mem_res->start, mem_size);
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "memory map failed\n");
+		err = -ENOMEM;
+		goto out_release_regions;
+	}
+
+	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq_res) {
+		dev_err(&pdev->dev, "ufshcd: IRQ resource not available\n");
+		err = -ENODEV;
+		goto out_iounmap;
+	}
+
+	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
+	if (err) {
+		dev_err(&pdev->dev, "set dma mask failed\n");
+		goto out_iounmap;
+	}
+
+	err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
+	if (err) {
+		dev_err(&pdev->dev, "%s: Intialization failed\n",
+			__FILE__);
+		goto out_iounmap;
+	}
+
+	platform_set_drvdata(pdev, hba);
+
+	return 0;
+
+out_iounmap:
+	iounmap(mmio_base);
+out_release_regions:
+	release_mem_region(mem_res->start, mem_size);
+out_error:
+	return err;
+}
+
+/**
+ * ufshcd_pltfrm_remove - remove platform driver routine
+ * @pdev: pointer to platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int __devexit ufshcd_pltfrm_remove(struct platform_device *pdev)
+{
+	struct resource *mem_res;
+	struct resource *irq_res;
+	resource_size_t mem_size;
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	ufshcd_remove(hba);
+	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq_res)
+		dev_err(&pdev->dev, "ufshcd: IRQ resource not available\n");
+	free_irq(irq_res->start, hba);
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mem_size = resource_size(mem_res);
+	release_mem_region(mem_res->start, mem_size);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+
+
+static struct platform_driver ufshcd_pltfrm_driver = {
+	.probe	= ufshcd_pltfrm_probe,
+	.remove	= __devexit_p(ufshcd_pltfrm_remove),
+#ifdef CONFIG_PM
+	.suspend = ufshcd_pltfrm_suspend,
+	.resume = ufshcd_pltfrm_resume,
+#endif
+	.driver	= {
+		.name	= "ufshcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(ufshcd_pltfrm_driver);
+
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_DESCRIPTION("Platform based UFS host controller driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
1.7.5.4
