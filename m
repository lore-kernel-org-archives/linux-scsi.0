From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [EXT] [PATCH v3 2/3] scsi: ufs-qcom: Implement device_reset vops
Date: Tue, 11 Jun 2019 23:31:43 -0700
Message-ID: <20190612063143.GD22737@tuxbook-pro>
References: <20190608050450.12056-1-bjorn.andersson@linaro.org>
 <20190608050450.12056-3-bjorn.andersson@linaro.org>
 <BN7PR08MB56848AB3CC413CBEC211130EDBED0@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BN7PR08MB56848AB3CC413CBEC211130EDBED0@BN7PR08MB5684.namprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 11 Jun 09:08 PDT 2019, Bean Huo (beanhuo) wrote:

> Hi, Bjorn
> This HW reset is dedicated to QUALCOMM based platform case.
> how about adding a SW reset as to be default reset routine if platform doesn't support HW reset?
> 

Can you please advice how I perform such software reset?

Regards,
Bjorn

> >-----Original Message-----
> >From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> >On Behalf Of Bjorn Andersson
> >Sent: Saturday, June 8, 2019 7:05 AM
> >To: Rob Herring <robh+dt@kernel.org>; Mark Rutland
> ><mark.rutland@arm.com>; Alim Akhtar <alim.akhtar@samsung.com>; Avri
> >Altman <avri.altman@wdc.com>; Pedro Sousa
> ><pedrom.sousa@synopsys.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
> >Martin K. Petersen <martin.petersen@oracle.com>
> >Cc: Andy Gross <agross@kernel.org>; devicetree@vger.kernel.org; linux-
> >kernel@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-
> >scsi@vger.kernel.org
> >Subject: [EXT] [PATCH v3 2/3] scsi: ufs-qcom: Implement device_reset vops
> >
> >The UFS_RESET pin on Qualcomm SoCs are controlled by TLMM and exposed
> >through the GPIO framework. Acquire the device-reset GPIO and use this to
> >implement the device_reset vops, to allow resetting the attached memory.
> >
> >Based on downstream support implemented by Subhash Jadavani
> ><subhashj@codeaurora.org>.
> >
> >Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >---
> >
> >Changes since v2:
> >- Moved implementation to Qualcomm driver
> >
> > .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  2 ++
> > drivers/scsi/ufs/ufs-qcom.c                   | 32 +++++++++++++++++++
> > drivers/scsi/ufs/ufs-qcom.h                   |  4 +++
> > 3 files changed, 38 insertions(+)
> >
> >diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >index a74720486ee2..d562d8b4919c 100644
> >--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> >@@ -54,6 +54,8 @@ Optional properties:
> > 			  PHY reset from the UFS controller.
> > - resets            : reset node register
> > - reset-names       : describe reset node register, the "rst" corresponds to
> >reset the whole UFS IP.
> >+- device-reset-gpios	: A phandle and gpio specifier denoting the GPIO
> >connected
> >+			  to the RESET pin of the UFS memory device.
> >
> > Note: If above properties are not defined it can be assumed that the supply
> >regulators or clocks are always on.
> >diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c index
> >ea7219407309..efaf57ba618a 100644
> >--- a/drivers/scsi/ufs/ufs-qcom.c
> >+++ b/drivers/scsi/ufs/ufs-qcom.c
> >@@ -16,6 +16,7 @@
> > #include <linux/of.h>
> > #include <linux/platform_device.h>
> > #include <linux/phy/phy.h>
> >+#include <linux/gpio/consumer.h>
> > #include <linux/reset-controller.h>
> >
> > #include "ufshcd.h"
> >@@ -1141,6 +1142,15 @@ static int ufs_qcom_init(struct ufs_hba *hba)
> > 		goto out_variant_clear;
> > 	}
> >
> >+	host->device_reset = devm_gpiod_get_optional(dev, "device-reset",
> >+						     GPIOD_OUT_HIGH);
> >+	if (IS_ERR(host->device_reset)) {
> >+		err = PTR_ERR(host->device_reset);
> >+		if (err != -EPROBE_DEFER)
> >+			dev_err(dev, "failed to acquire reset gpio: %d\n", err);
> >+		goto out_variant_clear;
> >+	}
> >+
> > 	err = ufs_qcom_bus_register(host);
> > 	if (err)
> > 		goto out_variant_clear;
> >@@ -1546,6 +1556,27 @@ static void ufs_qcom_dump_dbg_regs(struct
> >ufs_hba *hba)
> > 	usleep_range(1000, 1100);
> > }
> >
> >+/**
> >+ * ufs_qcom_device_reset() - toggle the (optional) device reset line
> >+ * @hba: per-adapter instance
> >+ *
> >+ * Toggles the (optional) reset line to reset the attached device.
> >+ */
> >+static void ufs_qcom_device_reset(struct ufs_hba *hba) {
> >+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> >+
> >+	/*
> >+	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
> >+	 * be on the safe side.
> >+	 */
> >+	gpiod_set_value_cansleep(host->device_reset, 1);
> >+	usleep_range(10, 15);
> >+
> >+	gpiod_set_value_cansleep(host->device_reset, 0);
> >+	usleep_range(10, 15);
> >+}
> >+
> > /**
> >  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
> >  *
> >@@ -1566,6 +1597,7 @@ static struct ufs_hba_variant_ops
> >ufs_hba_qcom_vops = {
> > 	.suspend		= ufs_qcom_suspend,
> > 	.resume			= ufs_qcom_resume,
> > 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
> >+	.device_reset		= ufs_qcom_device_reset,
> > };
> >
> > /**
> >diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h index
> >68a880185752..b96ffb6804e4 100644
> >--- a/drivers/scsi/ufs/ufs-qcom.h
> >+++ b/drivers/scsi/ufs/ufs-qcom.h
> >@@ -204,6 +204,8 @@ struct ufs_qcom_testbus {
> > 	u8 select_minor;
> > };
> >
> >+struct gpio_desc;
> >+
> > struct ufs_qcom_host {
> > 	/*
> > 	 * Set this capability if host controller supports the QUniPro mode
> >@@ -241,6 +243,8 @@ struct ufs_qcom_host {
> > 	struct ufs_qcom_testbus testbus;
> >
> > 	struct reset_controller_dev rcdev;
> >+
> >+	struct gpio_desc *device_reset;
> > };
> >
> > static inline u32
> >--
> >2.18.0
> 
