Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792665283;
	b=UBu9q+Z6ySh25jaSzfEvTC/pSVD+MOby8xu3tn6hfrGTWExmVPHfwaf9KIo/6+HwBFcb
	 2HqtoRPFrHpKJDL1qvuFKXEOyZcArm2n12FeBbBbHD+KhtyK9CGfpV+VtjSErigj5miFd
	 Lh1P09oZb/Q3jN2GRF7v/bSt3tkZ/6yKl3pKjZ+jBmFrZkWqHTT2DdXb+v0Jre1OQlb6S
	 7kduwYKlcV4b2ASpN3qhhrZGShTT/+Q4AIHQ1saUYYBtFgRD4Tzz+LPzthaIRD6uSuj5o
	 U0J+nbtyz+G+m0QCvbAMIJ7B/MARYNfPdeFzDGXewqHlA1A+DFMt+vWv6fC9cQGbmbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792665283;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ky4AYevjIhJIniLQkZbr0Wxu21YEIJLRLZRfDE9Acdc=;
	b=ZUG1CDjT4Ow+VNesEbRCIteZJwYLkLTEtGlTYTjPAYl4i3boZgSwAkYy34ljV3JtPfjj
	 H3ig4c4SDohHVqUju4ZEax4fjkWNqf+bJnEMleNXijrrmfIuyaMMRG6nFQANLnAhIOirD
	 KlshBDgB/TJdK3pMKW5vaqYp5XBiv8h7jOxAoEuJwhubwWy5QC4xQ+My//yNLVAJOapLI
	 fEyVHX0Kvho14YgnAG0KMsonzrIV38HCl/RjPCXtrW1GE9MGvkkHer+ifu2BqQOPScg9G
	 FQ0zeE9CXiGFAHiFlvRcCw0VAiK0RIkx6VUAPqOfN5BAn6IVdwTXnzgFt5NLxAxTlCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j8goFgF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C538606A327;
	Thu, 22 Oct 2026 10:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j8goFgF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218D41F000D4;
	Thu, 22 Oct 2026 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792665281;
	bh=Ky4AYevjIhJIniLQkZbr0Wxu21YEIJLRLZRfDE9Acdc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j8goFgF335pJffIOcVSUoDk+tXU2FNuINnveBFNgo228sAUV1W3s4ggSUZGNZp5Wj
	 TptUdRazDXzyeEVeaJ8uUlsk/8hTE2T0FTuAP47mtIaa5Rmz8Ee+WJkyqnj2ZWwNX6
	 ZFxkMGKm3alAnlQ8HRugvAXL5lsQVMQblEZm9tzmQAao9kZ3ehemixv57qDlAww4Y2
	 4RGDaKXbmtuWNIrhyRogvmqCTepp/QEZkdqSuD1MZYWzbHvfN4cZg1bRsdt3pPULNr
	 jknixHE1Qe38eV6YBKFO5z0w1mc1doMCXlK91/O5djmNChaaduL5DNVczF9F3ZbtdC
	 1SaRqWIZ4l/KA==
Message-ID: <sashiko-outbox-181342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] soc: qcom: ice: Add runtime PM support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kuldeep Singh" <kuldeep.singh@oss.qualcomm.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "Ulf
 Hansson" <ulfh@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>, "Manivannan
 Sadhasivam" <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K. Petersen" <mkp@kernel.org>, "Eric Biggers" <ebiggers@google.com>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-3-f7a84086c651@oss.qualcomm.com>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-3-f7a84086c651@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 10:34:40 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] soc: qcom: ice: unclocked MMIO access in qcom_ice_enable() when !C=
ONFIG_PM
- [High] soc: qcom: ice: unbalanced runtime PM refcount in qcom_ice_enable()
- [High] soc: qcom: ice: clock and runtime PM leak on probe failure or unbi=
nd
- [High] soc: qcom: ice: broken pm_runtime return handling in qcom_ice_susp=
end()
- [High] soc: qcom: ice: skipped HWKM re-init and unclocked restore across =
system PM
--

commit e58cd3bb281ecab50bf58fdb5388a26380d5ef70
Author: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

soc: qcom: ice: Add runtime PM support

This commit adds runtime PM support to the Qualcomm Inline Crypto Engine
(ICE) driver so that the core and iface clocks are gated when the device is
idle on platforms with a dedicated ICE devicetree node. For legacy bindings
where the ICE instance is created using the storage consumer device, manual
clock control is retained.

> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index e256595b9826f..f9939e2d037c7 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c

[ ... ]

> @@ -303,42 +305,99 @@ static void qcom_ice_hwkm_init(struct qcom_ice *ice)
> =20
>  int qcom_ice_enable(struct qcom_ice *ice)
>  {
> +	bool pm_acquired =3D false;
> +	int err;
> +
> +	if (ice->use_pm_runtime && pm_runtime_suspended(ice->dev)) {
> +		err =3D pm_runtime_resume_and_get(ice->dev);
> +		if (err) {
> +			dev_err(ice->dev, "runtime resume failed: %d\n", err);
> +			return err;
> +		}
> +		pm_acquired =3D true;
> +	}
> +
>  	qcom_ice_low_power_mode_enable(ice);
>  	qcom_ice_optimization_enable(ice);
>  	qcom_ice_hwkm_init(ice);
> -	return qcom_ice_wait_bist_status(ice);
> +
> +	err =3D qcom_ice_wait_bist_status(ice);
> +	if (err && pm_acquired) {
> +		dev_err(ice->dev, "BIST failed, ret: %d\n", err);
> +		pm_runtime_put_sync_suspend(ice->dev);
> +	}
> +
> +	return err;
>  }

[Severity: High]
In qcom_ice_enable() in drivers/soc/qcom/ice.c, pm_runtime_resume_and_get()
is gated on an unlocked check of pm_runtime_suspended(ice->dev):

include/linux/pm_runtime.h:pm_runtime_suspended() {
	return dev->power.runtime_status =3D=3D RPM_SUSPENDED
		&& !dev->power.disable_depth;
}

Because devm_pm_runtime_enable(&pdev->dev) is called in qcom_ice_probe()
before consumers attach, ice->dev may already be in RPM_ACTIVE (for example,
if userspace writes "on" to power/control via pm_runtime_forbid(), or after
an earlier consumer call to qcom_ice_enable()) or in RPM_SUSPENDING when
qcom_ice_enable() runs.

When pm_runtime_suspended(ice->dev) returns false:
- qcom_ice_enable() skips pm_runtime_resume_and_get(ice->dev) and does not
  acquire a runtime PM usage reference for the consumer.
- If ice->dev is concurrently in RPM_SUSPENDING, qcom_ice_enable() accesses
  registers in qcom_ice_low_power_mode_enable(),
  qcom_ice_optimization_enable(), qcom_ice_hwkm_init(), and
  qcom_ice_wait_bist_status() while qcom_ice_runtime_suspend() disables
  core_clk and iface_clk.
- If power/control is later set back to "auto" (pm_runtime_allow()),
  ice->dev can suspend and gate its clocks while the storage consumer is
  still active.
- When the consumer later calls qcom_ice_suspend() ->
  pm_runtime_put_sync_suspend(ice->dev), it decrements
  ice->dev->power.usage_count without a matching reference from
  qcom_ice_enable().

Additionally, when ice->dev is RPM_SUSPENDED on the initial call to
qcom_ice_enable(), pm_runtime_resume_and_get(ice->dev) invokes
qcom_ice_runtime_resume() -> qcom_ice_do_resume(), which runs
qcom_ice_hwkm_init() and qcom_ice_wait_bist_status() before
qcom_ice_low_power_mode_enable() and qcom_ice_optimization_enable(), and
then qcom_ice_enable() runs qcom_ice_hwkm_init() and
qcom_ice_wait_bist_status() a second time.

Can qcom_ice_enable() leave the runtime PM usage count unbalanced or race
with a concurrent runtime suspend when ice->dev is not in RPM_SUSPENDED?

>  EXPORT_SYMBOL_GPL(qcom_ice_enable);
> =20
> -int qcom_ice_resume(struct qcom_ice *ice)
> +static int qcom_ice_enable_clocks(struct qcom_ice *ice)
>  {
> -	struct device *dev =3D ice->dev;
>  	int err;
> =20
>  	err =3D clk_prepare_enable(ice->core_clk);
> -	if (err) {
> -		dev_err(dev, "Failed to enable core clock: %d\n", err);
> +	if (err)
>  		return err;
> -	}
> =20
>  	err =3D clk_prepare_enable(ice->iface_clk);
>  	if (err) {
> -		dev_err(dev, "Failed to enable iface clock: %d\n", err);
> +		clk_disable_unprepare(ice->core_clk);
>  		return err;
>  	}
> -	qcom_ice_hwkm_init(ice);
> -	return qcom_ice_wait_bist_status(ice);
> +
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(qcom_ice_resume);
> =20
> -int qcom_ice_suspend(struct qcom_ice *ice)
> +static void qcom_ice_disable_clocks(struct qcom_ice *ice)
>  {
>  	clk_disable_unprepare(ice->iface_clk);
>  	clk_disable_unprepare(ice->core_clk);
> +}
> +
> +static int qcom_ice_do_resume(struct qcom_ice *ice)
> +{
> +	int err =3D 0;
> +
> +	err =3D qcom_ice_enable_clocks(ice);
> +	if (err)
> +		return err;
> +
> +	qcom_ice_hwkm_init(ice);
> +
> +	err =3D qcom_ice_wait_bist_status(ice);
> +	if (err) {
> +		dev_err(ice->dev, "Bist failed, ret: %d\n", err);
> +		qcom_ice_disable_clocks(ice);
> +		ice->hwkm_init_complete =3D false;
> +	}
> +
> +	return err;
> +}
> +
> +int qcom_ice_resume(struct qcom_ice *ice)
> +{
> +	if (ice->use_pm_runtime)
> +		return pm_runtime_resume_and_get(ice->dev);
> +
> +	return qcom_ice_do_resume(ice);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_resume);
> +
> +static int qcom_ice_do_suspend(struct qcom_ice *ice)
> +{
>  	ice->hwkm_init_complete =3D false;
> +	qcom_ice_disable_clocks(ice);
> =20
>  	return 0;
>  }
> +
> +int qcom_ice_suspend(struct qcom_ice *ice)
> +{
> +	if (ice->use_pm_runtime)
> +		return pm_runtime_put_sync_suspend(ice->dev);
> +
> +	return qcom_ice_do_suspend(ice);
> +}
>  EXPORT_SYMBOL_GPL(qcom_ice_suspend);

[Severity: High]
In qcom_ice_suspend() in drivers/soc/qcom/ice.c, the return value of
pm_runtime_put_sync_suspend(ice->dev) is returned directly to the caller,
whereas previously qcom_ice_suspend() always returned 0.

pm_runtime_put_sync_suspend() calls __pm_runtime_suspend(ice->dev,
RPM_GET_PUT) in drivers/base/power/runtime.c, which decrements
dev->power.usage_count first and can return:
- 1 if the device was already in RPM_SUSPENDED,
- -EAGAIN if another caller concurrently incremented usage_count or a resume
  is pending,
- -EBUSY if child_count is non-zero or a PM domain governor rejects suspend,
- -EPERM if a 0 us PM QoS resume latency constraint is active.

In all of these cases, ice->dev->power.usage_count has already been
decremented, but both storage callers treat any non-zero return value as a
suspend failure:

1. In drivers/mmc/host/sdhci-msm.c, sdhci_msm_runtime_suspend() disables
   msm_host->bulk_clks before calling sdhci_msm_ice_suspend():

   drivers/mmc/host/sdhci-msm.c:sdhci_msm_runtime_suspend() {
       ...
       dev_pm_opp_set_rate(dev, 0);
       clk_bulk_disable_unprepare(ARRAY_SIZE(msm_host->bulk_clks),
                                  msm_host->bulk_clks);

       return sdhci_msm_ice_suspend(msm_host);
   }

   A non-zero return causes runtime suspend to fail (and a return value of 1
   sets dev->power.runtime_error =3D 1 in rpm_suspend()) with SDHCI clocks =
left
   disabled and ice->dev's usage_count already dropped.

2. In drivers/ufs/core/ufshcd.c, __ufshcd_wl_suspend() treats a non-zero
   return from ufshcd_vops_suspend() -> ufs_qcom_suspend() ->
   qcom_ice_suspend() as an error:

   drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
       ...
       ret =3D ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
       if (ret)
           goto set_link_active;
       ...
   }

   This aborts UFS suspend without calling qcom_ice_resume() to restore the
   dropped ICE usage_count reference, causing the next suspend to underflow
   ice->dev->power.usage_count. Similarly, ufshcd_wl_poweroff() calls
   __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) even when UFS is already
   runtime-suspended, calling qcom_ice_suspend() a second time.

Will returning the raw result of pm_runtime_put_sync_suspend() from
qcom_ice_suspend() cause suspend regressions in sdhci-msm and ufs-qcom?

> @@ -560,10 +619,11 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> =20
> -static struct qcom_ice *qcom_ice_create(struct device *dev,
> -					void __iomem *base)
> +static struct qcom_ice *qcom_ice_create(struct device *dev, void __iomem=
 *base,
> +					bool use_pm_runtime)
>  {
>  	struct qcom_ice *engine;
> +	int err;
> =20
>  	if (!qcom_scm_is_available())
>  		return ERR_PTR(-EPROBE_DEFER);
> @@ -579,36 +639,54 @@ static struct qcom_ice *qcom_ice_create(struct devi=
ce *dev,
> =20
>  	engine->dev =3D dev;
>  	engine->base =3D base;
> +	engine->use_pm_runtime =3D use_pm_runtime;
> =20
>  	/*
>  	 * Legacy DT binding uses different clk names for each consumer,
>  	 * so lets try those first. If none of those are a match, it means
>  	 * the we only have one clock and it is part of the dedicated DT node.
> -	 * Also, enable the clock before we check what HW version the driver
> -	 * supports.
>  	 */
> -	engine->core_clk =3D devm_clk_get_optional_enabled(dev, "ice_core_clk");
> +	engine->core_clk =3D devm_clk_get_optional(dev, "ice_core_clk");
>  	if (!engine->core_clk)
> -		engine->core_clk =3D devm_clk_get_optional_enabled(dev, "ice");
> +		engine->core_clk =3D devm_clk_get_optional(dev, "ice");
>  	if (!engine->core_clk)
> -		engine->core_clk =3D devm_clk_get_optional_enabled(dev, "core");
> +		engine->core_clk =3D devm_clk_get_optional(dev, "core");
>  	if (!engine->core_clk)
> -		engine->core_clk =3D devm_clk_get_enabled(dev, NULL);
> +		engine->core_clk =3D devm_clk_get(dev, NULL);
>  	if (IS_ERR(engine->core_clk))
>  		return ERR_CAST(engine->core_clk);
> =20
> -	engine->iface_clk =3D devm_clk_get_optional_enabled(dev, "iface");
> +	engine->iface_clk =3D devm_clk_get_optional(dev, "iface");
>  	if (IS_ERR(engine->iface_clk))
>  		return ERR_CAST(engine->iface_clk);
> =20
> -	if (!qcom_ice_check_supported(engine))
> +	err =3D qcom_ice_enable_clocks(engine);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	if (!qcom_ice_check_supported(engine)) {
> +		qcom_ice_disable_clocks(engine);
>  		return ERR_PTR(-EOPNOTSUPP);
> +	}

[Severity: High]
Previously, qcom_ice_create() in drivers/soc/qcom/ice.c used
devm_clk_get_optional_enabled() and devm_clk_get_enabled(), which registered
clk_disable_unprepare() with devres for teardown. Replacing them with
devm_clk_get_optional() and devm_clk_get() followed by
qcom_ice_enable_clocks(engine) leaves no devres action to disable or
unprepare engine->core_clk and engine->iface_clk:

1. For the legacy DT binding (use_pm_runtime =3D=3D false), of_qcom_ice_get=
() ->
   qcom_ice_create(&pdev->dev, base, false) leaves core_clk and iface_clk
   prepared and enabled, and qcom_ice_put() does not disable them:

   drivers/soc/qcom/ice.c:qcom_ice_put() {
       struct platform_device *pdev =3D to_platform_device(ice->dev);

       if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
           platform_device_put(pdev);
   }

   If the consumer fails probe after devm_of_qcom_ice_get() or is unbound
   (where ufshcd_remove() and sdhci_msm_remove() resume the host before
   teardown without calling qcom_ice_suspend()), devm_clk_release() calls
   clk_put() while core_clk and iface_clk remain prepared and enabled.

2. For the dedicated DT binding (use_pm_runtime =3D=3D true), qcom_ice_enab=
le()
   acquires a runtime PM reference on ice->dev via
   pm_runtime_resume_and_get(ice->dev) and enables core_clk and iface_clk.
   If a subsequent step in consumer probe fails (or in ufs-qcom if the
   second qcom_ice_enable() call in ufs_qcom_hce_enable_notify() fails BIST
   when pm_acquired is false) or the consumer is unbound, neither
   qcom_ice_put() nor the consumer remove callbacks release the runtime PM
   reference on ice->dev. Moreover, if the qcom-ice driver itself is unbound
   while active in qcom_ice_remove(), devm_pm_runtime_enable() only calls
   pm_runtime_disable() without running qcom_ice_runtime_suspend().

Does this leak the prepared/enabled core_clk and iface_clk clocks and the
ice->dev runtime PM reference on probe failure or driver unbind?

> +
> +	if (use_pm_runtime)
> +		qcom_ice_disable_clocks(engine);

[Severity: High]
CONFIG_QCOM_INLINE_CRYPTO_ENGINE does not depend on CONFIG_PM, and
qcom_ice_driver uses pm_ptr(&qcom_ice_pm_ops) so it can be built with
CONFIG_PM=3Dn.

In qcom_ice_probe() -> qcom_ice_create(&pdev->dev, base, true),
use_pm_runtime is unconditionally set to true and qcom_ice_disable_clocks()
disables engine->core_clk and engine->iface_clk before returning.

When CONFIG_PM=3Dn:
- pm_runtime_set_suspended() and devm_pm_runtime_enable() in
  qcom_ice_probe() are no-op stubs.
- In qcom_ice_enable(), pm_runtime_suspended(ice->dev) is a stub that always
  returns false, so qcom_ice_enable() never resumes the device or enables
  clocks before calling qcom_ice_low_power_mode_enable(),
  qcom_ice_optimization_enable(), qcom_ice_hwkm_init(), and
  qcom_ice_wait_bist_status(), performing MMIO reads and writes to ICE
  registers while core_clk and iface_clk are disabled.
- In qcom_ice_resume(), pm_runtime_resume_and_get(ice->dev) returns 0
  without invoking qcom_ice_runtime_resume(), leaving clocks disabled and
  skipping qcom_ice_do_resume().
- In qcom_ice_suspend(), pm_runtime_put_sync_suspend(ice->dev) calls the
  __pm_runtime_suspend() stub, which returns -ENOSYS.

What happens when a storage consumer calls qcom_ice_enable(),
qcom_ice_resume(), or qcom_ice_suspend() on a kernel built with CONFIG_PM=
=3Dn?

[ ... ]

> @@ -775,12 +862,18 @@ static const struct of_device_id qcom_ice_of_match_=
table[] =3D {
>  };
>  MODULE_DEVICE_TABLE(of, qcom_ice_of_match_table);
> =20
> +static const struct dev_pm_ops qcom_ice_pm_ops =3D {
> +	RUNTIME_PM_OPS(qcom_ice_runtime_suspend, qcom_ice_runtime_resume, NULL)
> +	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
> +};

[Severity: High]
With SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
in qcom_ice_pm_ops and qcom_ice_resume() delegating to
pm_runtime_resume_and_get(ice->dev), two system PM state mismatches can
occur when ice->use_pm_runtime is true:

1. During dpm_prepare(), device_prepare() calls
   pm_runtime_get_noresume(ice->dev), raising ice->dev->power.usage_count
   from 1 to 2 while the storage consumer is active. When the consumer
   suspends in dpm_suspend() and calls qcom_ice_suspend() ->
   pm_runtime_put_sync_suspend(ice->dev), __pm_runtime_suspend() drops
   usage_count from 2 to 1 and returns 0 without calling
   qcom_ice_runtime_suspend(), leaving ice->dev in RPM_ACTIVE.

   If system suspend aborts before pm_runtime_force_suspend(ice->dev) runs
   (or if userspace sets ice->dev's power/control to "on"), ice->dev remains
   in RPM_ACTIVE. When dpm_resume() runs ufshcd_wl_resume() ->
   ufs_qcom_resume() in drivers/ufs/host/ufs-qcom.c, UFS controller v5.0.0
   issues a synchronous hardware reset to ICE (UFS_ICE_SYNC_RST_SW in
   UFS_MEM_ICE_CFG) and then calls qcom_ice_resume(host->ice) ->
   pm_runtime_resume_and_get(ice->dev). Because ice->dev is still
   RPM_ACTIVE, pm_runtime_resume_and_get() returns 0 without running
   qcom_ice_do_resume(), skipping qcom_ice_hwkm_init() and
   qcom_ice_wait_bist_status() after the hardware reset.

2. During hibernation freeze/poweroff, after sdhci_msm_runtime_suspend()
   calls qcom_ice_suspend() -> pm_runtime_put_sync_suspend(ice->dev),
   ice->dev->power.usage_count is 1 (only the device_prepare() reference).
   When pm_runtime_force_suspend(ice->dev) runs,
   pm_runtime_need_not_resume(ice->dev) is true (usage_count <=3D 1), so it
   calls qcom_ice_do_suspend() (setting ice->hwkm_init_complete =3D false a=
nd
   disabling clocks) and sets needs_force_resume =3D false.

   During hibernation restore, pm_runtime_force_resume(ice->dev) leaves
   ice->dev in RPM_SUSPENDED, and sdhci_msm_restore() in
   drivers/mmc/host/sdhci-msm.c then calls sdhci_msm_ice_restore() ->
   blk_crypto_reprogram_all_keys() -> qcom_ice_program_key() while ice->dev
   is still suspended with clocks disabled and ice->hwkm_init_complete set
   to false.

Could system suspend recovery and hibernation restore leave ICE uninitializ=
ed
or unclocked when qcom_ice_resume() and qcom_ice_pm_ops rely on runtime PM
status transitions?

> +
>  static struct platform_driver qcom_ice_driver =3D {
>  	.probe	=3D qcom_ice_probe,
>  	.remove	=3D qcom_ice_remove,
>  	.driver =3D {
>  		.name =3D "qcom-ice",
>  		.of_match_table =3D qcom_ice_of_match_table,
> +		.pm =3D pm_ptr(&qcom_ice_pm_ops),
>  	},
>  };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-qcom_ice_p=
m_enable-v1-0-f7a84086c651@oss.qualcomm.com?part=3D3
