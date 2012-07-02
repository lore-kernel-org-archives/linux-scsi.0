From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 3/4] [SCSI] ufs: Add AMBA glue driver to ufshcd
Date: Mon,  2 Jul 2012 20:02:51 +0530
Message-ID: <1341239572-7408-4-git-send-email-vinholikatti@gmail.com>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds AMBA glue driver for ufshcd

Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
---
 drivers/scsi/ufs/Kconfig       |   10 ++
 drivers/scsi/ufs/Makefile      |    1 +
 drivers/scsi/ufs/ufshcd-amba.c |  180 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-amba.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8c06330..0ad4658 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -78,3 +78,13 @@ config SCSI_UFSHCD_PLATFORM
 	   If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config SCSI_UFSHCD_AMBA
+	tristate "AMBA bus based UFS Controller support"
+	depends on SCSI_UFSHCD && ARM_AMBA
+	---help---
+	This selects the ARM(R) AMBA(R) PrimeCell UFS Host Controller
+	Interface support.  If you have an ARM(R) platform with
+	UFS Host Controller, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 1e5bd48..a27330f 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
+obj-$(CONFIG_SCSI_UFSHCD_AMBA) += ufshcd-amba.o
diff --git a/drivers/scsi/ufs/ufshcd-amba.c b/drivers/scsi/ufs/ufshcd-amba.c
new file mode 100644
index 0000000..d4647e4
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-amba.c
@@ -0,0 +1,180 @@
+/*
+ * Universal Flash Storage Host controller driver
+ *
+ * This code is based on drivers/scsi/ufs/ufshcd-amba.c
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
+#include <linux/amba/bus.h>
+
+/**
+ * ufshcd_amba_probe - probe routine of the driver
+ * @dev: pointer to amba device handle
+ * @id: amba device id
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_amba_probe(struct amba_device *dev, const struct amba_id *id)
+{
+	void __iomem *mmio_base;
+	struct ufs_hba *hba;
+	int err;
+
+	err = amba_request_regions(dev, UFSHCD);
+	if (err < 0) {
+		dev_err(&dev->dev, "request regions failed\n");
+		goto out_error;
+	}
+
+	mmio_base = ioremap_nocache(dev->res.start, resource_size(&dev->res));
+	if (!mmio_base) {
+		pr_err("memory map failed\n");
+		err = -ENOMEM;
+		goto out_release_regions;
+	}
+
+	err = ufshcd_init(&dev->dev, &hba, mmio_base, dev->irq[0]);
+	if (err) {
+		dev_err(&dev->dev, "%s:%d-%s Initialization failed\n",
+				__FILE__, __LINE__, __func__);
+		goto out_iounmap;
+	}
+
+	amba_set_drvdata(dev, hba);
+
+	return 0;
+
+out_iounmap:
+	iounmap(mmio_base);
+out_release_regions:
+	amba_release_regions(dev);
+out_error:
+	return err;
+}
+
+static int ufshcd_amba_remove(struct amba_device *dev)
+{
+	struct ufs_hba *hba = amba_get_drvdata(dev);
+
+	ufshcd_remove(hba);
+	free_irq(dev->irq[0], hba);
+	amba_release_regions(dev);
+	amba_set_drvdata(dev, NULL);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/**
+ * ufshcd_amba_suspend - suspend power management function
+ * @dev: pointer to amba device handle
+ * @state: power state
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_amba_suspend(struct amba_device *dev, pm_message_t state)
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
+ * ufshcd_amba_resume - resume power management function
+ * @dev: pointer to amba device handle
+ *
+ * Returns -ENOSYS
+ */
+static int ufshcd_amba_resume(struct amba_device *dev)
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
+
+	return -ENOSYS;
+}
+#endif
+
+static struct amba_id ufshcd_amba_ids[] = {
+	{
+		/* Fake id for Primecell.*/
+		.id	= 0x00041FF0,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 },
+};
+
+MODULE_DEVICE_TABLE(amba, ufshcd_amba_ids);
+
+static struct amba_driver ufshcd_amba_driver = {
+	.drv = {
+		.name	= "ufshcd",
+	},
+	.id_table	= ufshcd_amba_ids,
+	.probe		= ufshcd_amba_probe,
+	.remove		= ufshcd_amba_remove,
+#ifdef CONFIG_PM
+	.suspend	= ufshcd_amba_suspend,
+	.resume		= ufshcd_amba_resume,
+#endif
+};
+
+module_amba_driver(ufshcd_amba_driver);
+
+MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
+MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
+MODULE_DESCRIPTION("AMBA based UFS host controller driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
1.7.5.4
