Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F615175A94;
	Wed, 10 Jun 2026 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050961; cv=none; b=sp5kHfKaJroBSPW/eL+W23euTQ0NdnP88FlQHfMUBeDKBGa1UDSLZvzFQqaB0axBfGoQP6vAzZ893FpnhrPxGbZ/Un5zs7DqycMzgphMl/LQ8KSuG8TzVRuUjqYL6uBI+90MU1LXM8odBmeC1ijMmTGDwdypfxsGXj25PLXjprA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050961; c=relaxed/simple;
	bh=tIXDp05dhyBhu0RlkSmzygehZGRIgwcuPl10QzZ0UgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f43qgLWP6uHUDbByH2npoOwDbyyjaalOh1DVTwvjbRzCEXD4dYdAyjWH/LYajD7AJPgjV2XoQ7ebDjdsvxiUFvubKLnEMGZ3YkPaPSsuH9N4L43q6KPNEtbhZt3INU/Y1LJZ4u71Y8+jxZhxxfo2pVdjsf1EQMi/kjcYWVGYZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ2/7UCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ2/7UCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934E51F00893;
	Wed, 10 Jun 2026 00:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781050959;
	bh=xVOd9uc4/xs0pyXBthm4eWuCubVI/h28Y2eC4GoOQSY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BJ2/7UCGr6DtxWUX+WuOc6rpd3h0ZgMYaR1+02RgRbH2I1eZzgzYyUX3gfTxQnxar
	 E7siKQjpujEIBVx26fqx/Ndo3rEKIC4UWIOvofvcW27i8B9HW6+NOCxBTYQpNX2SVp
	 q+gOUrEEaM0YkW+4V6VhVTBABXM6VYlurnf38LYbn075dO1nq9Lxtm34xrhkGht4D0
	 kM9u1oUA8WVjnQfnf0+3XiRgGBKD1/nGebJvj0WR7TqxyMU6qqZwDjjRGJdI9QJ4lW
	 9+JVK8rxtD/CtIup383N+22fLfT/pw/aZC7nxJ0Bq3ZgQryT9dMFgb+XDf8NFHcQ+0
	 I2dKrctwBnqZA==
Message-ID: <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
Date: Wed, 10 Jun 2026 08:22:22 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260609164423.2829699-3-sautier.louis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/06/10 0:44, Louis Sautier wrote:
> Expose the IOC and board temperature sensors of LSI / Broadcom SAS
> HBAs through hwmon. Readings come from MPI IO Unit Page 7 via the
> accessor added in the preceding patch.
> 
> The same fields are exposed by Broadcom's userspace tooling
> through the /dev/mpt[23]ctl ioctl path (typically root-only):
> IOCTemperature and BoardTemperature in lsiutil; ROC and Controller
> in storcli. With this driver, sensors(1) shows them unprivileged:
> 
>   $ sensors mpt3sas-pci-0200
>   mpt3sas-pci-0200
>   Adapter: PCI adapter
>   IOC:          +42.0°C
> 
> Each channel is gated independently by its *TemperatureUnits field
> through is_visible(); cards that populate only one sensor expose
> only one input file, and cards that populate neither do not register
> an hwmon device.
> 
> Built into mpt3sas.ko under a new CONFIG_SCSI_MPT3SAS_HWMON Kconfig
> option.
> 
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>

[...]

> +config SCSI_MPT3SAS_HWMON
> +	bool "LSI MPT Fusion SAS hwmon support"
> +	depends on SCSI_MPT3SAS && HWMON
> +	depends on !(SCSI_MPT3SAS=y && HWMON=m)
> +	help
> +	Say Y here to expose the IOC and board temperature sensors of
> +	LSI / Broadcom SAS HBAs (such as the 9300, 9400, and 9500 series)
> +	through hwmon.

Why do you need this ?

> +
>  config SCSI_MPT2SAS
>  	tristate "Legacy MPT2SAS config option"
>  	default n
> diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
> index e76d994dbed3..9a2f3ce4158a 100644
> --- a/drivers/scsi/mpt3sas/Makefile
> +++ b/drivers/scsi/mpt3sas/Makefile
> @@ -9,3 +9,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
>  		mpt3sas_trigger_diag.o \
>  		mpt3sas_warpdrive.o \
>  		mpt3sas_debugfs.o \
> +
> +mpt3sas-$(CONFIG_SCSI_MPT3SAS_HWMON) += mpt3sas_hwmon.o

mpt3sas-$(CONFIG_HWMON) += mpt3sas_hwmon.o

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index c655742d0dde..63252f30343b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -1629,6 +1629,7 @@ struct MPT3SAS_ADAPTER {
>  	u8		is_aero_ioc;
>  	struct dentry	*debugfs_root;
>  	struct dentry	*ioc_dump;
> +	struct mpt3sas_hwmon *hwmon;

This should be conditionally defined with "#ifdef CONFIG_HWMON". Then you can
simply drop the config entry you added.

>  	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
>  	PUT_SMID_IO_FP_HIP put_smid_fast_path;
>  	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
> @@ -2049,6 +2050,22 @@ void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
>  void mpt3sas_init_debugfs(void);
>  void mpt3sas_exit_debugfs(void);
>  
> +#if IS_ENABLED(CONFIG_SCSI_MPT3SAS_HWMON)

#if IS_ENABLED(CONFIG_HWMON)

> +int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc);
> +void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc);
> +#else
> +static inline int
> +mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)

No line break after "int" please.

> +{
> +	return 0;
> +}
> +
> +static inline void

No line break after void please.

> +mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
> +{
> +}
> +#endif
> +
>  /**
>   * _scsih_is_pcie_scsi_device - determines if device is an pcie scsi device
>   * @device_info: bitfield providing information about the device.
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_hwmon.c b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
> new file mode 100644
> index 000000000000..26227a992f35
> --- /dev/null
> +++ b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
> @@ -0,0 +1,200 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hardware monitoring (hwmon) support for the LSI / Broadcom mpt3sas
> + * SAS HBA driver. Exposes the IOC and board temperature sensors by
> + * reading MPI IO Unit Page 7.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#include "mpt3sas_base.h"
> +
> +struct mpt3sas_hwmon {
> +	struct MPT3SAS_ADAPTER *ioc;
> +	struct device *hwmon_dev;
> +	bool ioc_present;
> +	bool board_present;
> +};
> +
> +/*
> + * Convert a (raw, units) reading to millidegrees Celsius.
> + * Returns -ENODATA when the sensor reports "not present" or
> + * unknown units. Temperature values are interpreted as signed
> + * two's-complement integers.
> + *
> + * The MPI2_IOUNITPAGE7_IOC_TEMP_* and MPI2_IOUNITPAGE7_BOARD_TEMP_*
> + * defines in mpi2_cnfg.h share the same values; the IOC ones are
> + * used for both channels.
> + */
> +static int

Remove the line break here please.

> +_hwmon_to_mdegc(s16 raw, u8 units, long *out)
> +{
> +	switch (units) {
> +	case MPI2_IOUNITPAGE7_IOC_TEMP_CELSIUS:
> +		*out = (long)raw * 1000;
> +		return 0;
> +	case MPI2_IOUNITPAGE7_IOC_TEMP_FAHRENHEIT:
> +		/* (F - 32) * 5 / 9, expressed in milli-units */
> +		*out = ((long)raw - 32) * 5000 / 9;
> +		return 0;
> +	default:
> +		return -ENODATA;
> +	}
> +}
> +
> +static umode_t

And here too.

> +_hwmon_is_visible(const void *drvdata, enum hwmon_sensor_types type,
> +		  u32 attr, int channel)
> +{
> +	const struct mpt3sas_hwmon *h = drvdata;
> +
> +	if (type != hwmon_temp)
> +		return 0;
> +	if (attr != hwmon_temp_input && attr != hwmon_temp_label)
> +		return 0;
> +	if (channel == 0 && h->ioc_present)
> +		return 0444;
> +	if (channel == 1 && h->board_present)
> +		return 0444;
> +	return 0;
> +}
> +
> +static int

Again... Not going to comment on the others.

> +_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> +	    u32 attr, int channel, long *val)
> +{
> +	struct mpt3sas_hwmon *h = dev_get_drvdata(dev);
> +	Mpi2ConfigReply_t mpi_reply;
> +	Mpi2IOUnitPage7_t page;
> +	int r;
> +
> +	if (type != hwmon_temp || attr != hwmon_temp_input)
> +		return -EOPNOTSUPP;
> +
> +	r = mpt3sas_config_get_iounit_pg7(h->ioc, &mpi_reply, &page);
> +	if (r)
> +		return r;
> +
> +	if (channel == 0)
> +		return _hwmon_to_mdegc((s16)le16_to_cpu(page.IOCTemperature),
> +				       page.IOCTemperatureUnits, val);
> +	if (channel == 1)
> +		return _hwmon_to_mdegc((s16)le16_to_cpu(page.BoardTemperature),
> +				       page.BoardTemperatureUnits, val);
> +	return -EOPNOTSUPP;
> +}
> +
> +static const char * const mpt3sas_hwmon_temp_labels[] = {
> +	"IOC",
> +	"Board",
> +};
> +
> +static int
> +_hwmon_read_string(struct device *dev, enum hwmon_sensor_types type,
> +		   u32 attr, int channel, const char **str)
> +{
> +	if (type != hwmon_temp || attr != hwmon_temp_label)
> +		return -EOPNOTSUPP;
> +	*str = mpt3sas_hwmon_temp_labels[channel];
> +	return 0;
> +}
> +
> +static const struct hwmon_channel_info * const mpt3sas_hwmon_info[] = {
> +	HWMON_CHANNEL_INFO(temp,
> +			   HWMON_T_INPUT | HWMON_T_LABEL,
> +			   HWMON_T_INPUT | HWMON_T_LABEL),
> +	NULL,
> +};
> +
> +static const struct hwmon_ops mpt3sas_hwmon_ops = {
> +	.is_visible	= _hwmon_is_visible,
> +	.read		= _hwmon_read,
> +	.read_string	= _hwmon_read_string,
> +};
> +
> +static const struct hwmon_chip_info mpt3sas_hwmon_chip_info = {
> +	.ops	= &mpt3sas_hwmon_ops,
> +	.info	= mpt3sas_hwmon_info,
> +};
> +
> +/**
> + * mpt3sas_hwmon_register - register an hwmon device for the IOC
> + * @ioc: per adapter object
> + * Context: sleep.
> + *
> + * Succeeds without registering when no temperature sensors are present,
> + * so cards without thermal monitoring do not expose an empty hwmon node.
> + * Paired with mpt3sas_hwmon_unregister() from the driver's remove path.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +int
> +mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct device *parent = &ioc->pdev->dev;
> +	struct mpt3sas_hwmon *h;
> +	struct device *hwdev;
> +	Mpi2ConfigReply_t mpi_reply;
> +	Mpi2IOUnitPage7_t page;
> +	int r;
> +
> +	h = kzalloc_obj(*h);
> +	if (!h)
> +		return -ENOMEM;
> +
> +	h->ioc = ioc;
> +
> +	r = mpt3sas_config_get_iounit_pg7(ioc, &mpi_reply, &page);
> +	if (r) {
> +		kfree(h);
> +		return r;
> +	}
> +
> +	h->ioc_present = page.IOCTemperatureUnits != MPI2_IOUNITPAGE7_IOC_TEMP_NOT_PRESENT;
> +	h->board_present = page.BoardTemperatureUnits != MPI2_IOUNITPAGE7_BOARD_TEMP_NOT_PRESENT;
> +
> +	/*
> +	 * A page where both *TemperatureUnits are NOT_PRESENT covers
> +	 * two cases: cards that genuinely lack sensors, and firmware
> +	 * errors that left the page zero-filled (the accessor mirrors
> +	 * _config_request() behaviour). Either way: skip registration.
> +	 */
> +	if (!h->ioc_present && !h->board_present) {
> +		kfree(h);
> +		return 0;
> +	}
> +
> +	hwdev = hwmon_device_register_with_info(parent, "mpt3sas", h,
> +						&mpt3sas_hwmon_chip_info,
> +						NULL);
> +	if (IS_ERR(hwdev)) {
> +		kfree(h);
> +		return PTR_ERR(hwdev);
> +	}
> +
> +	h->hwmon_dev = hwdev;
> +	ioc->hwmon = h;
> +	return 0;
> +}
> +
> +/**
> + * mpt3sas_hwmon_unregister - tear down the hwmon device, if any
> + * @ioc: per adapter object
> + *
> + * Safe to call when registration was skipped (no sensors) or
> + * failed; in those cases ioc->hwmon is NULL and this is a no-op.
> + */
> +void
> +mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct mpt3sas_hwmon *h = ioc->hwmon;
> +
> +	if (!h)
> +		return;
> +	hwmon_device_unregister(h->hwmon_dev);
> +	kfree(h);
> +	ioc->hwmon = NULL;
> +}
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 12caffeed3a0..dea78688cc9b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -12562,6 +12562,7 @@ static void scsih_remove(struct pci_dev *pdev)
>  	/* release all the volumes */
>  	_scsih_ir_shutdown(ioc);
>  	mpt3sas_destroy_debugfs(ioc);
> +	mpt3sas_hwmon_unregister(ioc);
>  	sas_remove_host(shost);
>  	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
>  	    list) {
> @@ -13651,6 +13652,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	}
>  
>  	scsi_scan_host(shost);
> +
> +	if (mpt3sas_hwmon_register(ioc))
> +		ioc_warn(ioc,
> +			 "hwmon registration failed; temperatures not exposed\n");
> +
>  	mpt3sas_setup_debugfs(ioc);
>  	return 0;
>  out_add_shost_fail:


-- 
Damien Le Moal
Western Digital Research
