From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Tue, 4 Jun 2019 08:13:38 +0000
Message-ID: <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-3-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604072001.9288-3-bjorn.andersson@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Bjorn

>Acquire the device-reset GPIO and toggle this to reset the UFS device duri=
ng
>initialization and host reset.
>
>+/**
>+ ufshcd_device_reset() - toggle the (optional) device reset line
>+ * @hba: per-adapter instance
>+ *
>+ * Toggles the (optional) reset line to reset the attached device.
>+ */
>+static void ufshcd_device_reset(struct ufs_hba *hba) {
>+	/*
>+	 * The USB device shall detect reset pulses of 1us, sleep for 10us to
>+	 * be on the safe side.
>+	 */
>+	gpiod_set_value_cansleep(hba->device_reset, 1);
>+	usleep_range(10, 15);
>+
>+	gpiod_set_value_cansleep(hba->device_reset, 0);
>+	usleep_range(10, 15);
>+}
>+
> /**
>  * ufshcd_host_reset_and_restore - reset and restore host controller
>  * @hba: per-adapter instance
>@@ -6159,6 +6179,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba
>*hba)
> 	int retries =3D MAX_HOST_RESET_RETRIES;
>
> 	do {
>+		/* Reset the attached device */
>+		ufshcd_device_reset(hba);
>+

what's problem you met, and you should reset UFS device here? could you giv=
e more info?

It is true that we don't reset UFS device in case of device fatal error. Ac=
cording to UFS host spec,
Host should be device reset except that in addition to resetting UIC. But a=
s so far,
We didn't experience any problems result from this missing reset.

We have three UFS device reset ways.  Comparing to this hardware reset,=20
I prefer to use DME_ENDPOINTRESET.req software reset.


> 		err =3D ufshcd_host_reset_and_restore(hba);
> 	} while (err && --retries);
>
>@@ -7355,6 +7378,18 @@ static void ufshcd_variant_hba_exit(struct ufs_hba
>*hba)
> 	ufshcd_vops_exit(hba);
> }
>
>+static int ufshcd_init_device_reset(struct ufs_hba *hba) {
>+	hba->device_reset =3D devm_gpiod_get_optional(hba->dev, "device-
>reset",
>+						    GPIOD_OUT_HIGH);
>+	if (IS_ERR(hba->device_reset)) {
>+		dev_err(hba->dev, "failed to acquire reset gpio: %ld\n",
>+			PTR_ERR(hba->device_reset));
>+	}
>+
>+	return PTR_ERR_OR_ZERO(hba->device_reset);
>+}
>+
> static int ufshcd_hba_init(struct ufs_hba *hba)  {
> 	int err;
>@@ -7394,9 +7429,15 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
> 	if (err)
> 		goto out_disable_vreg;
>
>+	err =3D ufshcd_init_device_reset(hba);
>+	if (err)
>+		goto out_disable_variant;
>+
> 	hba->is_powered =3D true;
> 	goto out;
>
>+out_disable_variant:
>+	ufshcd_vops_setup_regulators(hba, false);
> out_disable_vreg:
> 	ufshcd_setup_vreg(hba, false);
> out_disable_clks:
>@@ -8290,6 +8331,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
>*mmio_base, unsigned int irq)
> 		goto exit_gating;
> 	}
>
>+	/* Reset the attached device */
>+	ufshcd_device_reset(hba);
>+
> 	/* Host controller enable */
> 	err =3D ufshcd_hba_enable(hba);
> 	if (err) {
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
>ecfa898b9ccc..d8be67742168 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>@@ -72,6 +72,8 @@
> #define UFSHCD "ufshcd"
> #define UFSHCD_DRIVER_VERSION "0.2"
>
>+struct gpio_desc;
>+
> struct ufs_hba;
>
> enum dev_cmd_type {
>@@ -706,6 +708,8 @@ struct ufs_hba {
>
> 	struct device		bsg_dev;
> 	struct request_queue	*bsg_queue;
>+
>+	struct gpio_desc *device_reset;
> };
>
> /* Returns true if clocks can be gated. Otherwise false */
>--
>2.18.0
