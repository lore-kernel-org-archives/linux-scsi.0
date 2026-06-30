Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C51A680B;
	Tue, 30 Jun 2026 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782779325; cv=none; b=K2m0DkHk/dbQmVJp4kEJJYhbnscGuHxHM6jECEUJLvB6k7G0OLXLiU0ZnjL4t13h0EKnJnaOt1RNuQgcdWwiH5eoEv7m4SitVxmKxrvxe6b/2Gxft1HR1Cq6TuYM8rkym8EdEh9Bbrr1YQOyoxYyy/Fc0mRlSivJqrEpOBersD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782779325; c=relaxed/simple;
	bh=ZMg/mS8tkWw8h4PnD9M5rARbFeAX0C4TWCT6vE4FnkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tw4S5vAv1q2tiCEs4OPzTZLmrhGB8jHfAHlrut2EHaBqw1AecYpyS1YqyzqHoQWbgDt5pQoz2d+/mQ030isLFw9rhUrarGYBAJHwc+HG0FJMDI69NBIORN/7OMg2Cexodibnnpnj8AKZeP2Yx3an0WEMIwq23Cyc2A6+02L3SeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aj7Qxosz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aj7Qxosz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625331F000E9;
	Tue, 30 Jun 2026 00:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782779324;
	bh=G4c9d/ZeWqAo4q8XZC72a4jWehIL7JgJc+9LYV1tUVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aj7Qxoszw7X67y3Iim0NApX36vaFP7D/mgEw/mFa455xZ/SEX2E2q6ye7GHfAxsxm
	 BEWjA61zRVeRtru5Oannc9U3vGBImmA4E6rtG0Jfta+L18Ti/tKsNWGfu3OorUfNqo
	 H8/eDQEMFzx0RMMASIwjjxsKIVp2/dk+PXXKo1NEtUDz1bcM52O+3+vc5dIKrxhKq3
	 /L6QsjzQOXh1pAjCvqfTnHNLfZN0Osl/YvnLI2Q2aSN0Nm5F8rMgMg3IKGqiUboNyV
	 YkaBDrhSO6nGtxvUKT8KtF1qBcJ2yb+ztpfGAbLYZPn5x2qSv2PHW0HSCXBCVPqR89
	 Vcgq0NbvfTHnA==
Message-ID: <aeb83cdb-616e-49b8-a791-3748dae60133@kernel.org>
Date: Tue, 30 Jun 2026 09:28:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: mpt3sas: add hwmon support
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
References: <20260613023833.3163507-1-sautier.louis@gmail.com>
 <20260613023833.3163507-3-sautier.louis@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260613023833.3163507-3-sautier.louis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/13/26 11:38, Louis Sautier wrote:
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
> The hwmon code is gated directly on CONFIG_HWMON. IS_REACHABLE() is
> used rather than IS_ENABLED() so that SCSI_MPT3SAS=y with HWMON=m
> still builds; in that configuration, the sensors are not exposed
> (same pattern as i915 and xe).
> 
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>

Looks OK to me, modulo a couple of nits below.
With these addressed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
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

maybe move this below together with the h->ioc_present initialization ?
There seem to be no point for this line to be alone here.

> +
> +	r = mpt3sas_config_get_iounit_pg7(ioc, &mpi_reply, &page);
> +	if (r) {
> +		kfree(h);
> +		return r;
> +	}

You should test for the page being present first and then allocate h if it is.
That would be cleaner/simpler.

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


-- 
Damien Le Moal
Western Digital Research
