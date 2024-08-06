Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D496C16BE0A;
	Tue,  6 Aug 2024 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933843; cv=none; b=nLhNpN6c1Hk5Xdexa3Dqy5jVaodXTmfNRfr0zOF6OohZXAxVOIQnY2n+/PDjW2xURzEwQAX5rwllj8qIbcrSgYTr8tdJduxMK2tq8C0vamIEe93HIpmJ12ICDOAAPgslG59WpuRzfBPy6MXx5dNG51/g40oRfdiHJNrWZu5tWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933843; c=relaxed/simple;
	bh=B0WQPw973C3LVxYk5S53XmcEe0PD9+2JgOcuWSoxE+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NQDpTbbn+IjJqPSJnjPBdQLmiBUyJl35Wl2Q+BiH3BYZVAdm49Q51+vY7mF2lJ8HD3Ak9rHxrtgX/CbpRvYnifytwAlbSGLCwo3/lAT+pGhnfxEPVjZz2A7l0ermDou3HNNDTZ5O7983ghNTgDnqAw36uN93G0FHr83iUFWBJvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5CGQqF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5CGQqF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA74FC32786;
	Tue,  6 Aug 2024 08:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722933843;
	bh=B0WQPw973C3LVxYk5S53XmcEe0PD9+2JgOcuWSoxE+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h5CGQqF8n+gyRKnX92AoR975/Pi+PSNvgw3kAi84Iak6hDF24gIwz9Yb1MdxmPIP2
	 ESsJlVZMSIGjb1c/yhJJ5RRov+fQtj2FQN97reAhf7PmN7u3wIW7JJNyZlpLAnBiZh
	 izRQF37DE31yTEJjfzQi10kNXXbbyL+UUQfEUCAVI43F/XQo7n7T/2vyo60Q31+shy
	 C6r81y9xdsNnVhvfsG7GZhEQ/DlkdRsZmf9KgVfS5GwWLesUBIV9MZ9cNS3hsTa3ch
	 gntcMVXQNcJ/CvLlKp8g3LhRrwW8xuIAUvxK23cLuIPKiYll78v5OHVRK+WL+yKRP0
	 pzPyWW2mM/3MQ==
Message-ID: <ea136482-16bc-4e67-8370-de72ee0c034e@kernel.org>
Date: Tue, 6 Aug 2024 10:43:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] scsi: ufs: rockchip: init support for UFS
To: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
 devicetree@vger.kernel.org
References: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
 <1722928800-137042-4-git-send-email-shawn.lin@rock-chips.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <1722928800-137042-4-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/08/2024 09:20, Shawn Lin wrote:
> RK3576 contains a UFS controller, add init support fot it.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> 
> ---



> +
> +static int ufs_rockchip_common_init(struct ufs_hba *hba)
> +{
> +	struct device *dev = hba->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct ufs_rockchip_host *host;
> +	int err = 0;
> +
> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	/* system control register for hci */
> +	host->ufs_sys_ctrl = devm_platform_ioremap_resource_byname(pdev, "hci_grf");
> +	if (IS_ERR(host->ufs_sys_ctrl)) {
> +		dev_err(dev, "cannot ioremap for hci system control register\n");
> +		return PTR_ERR(host->ufs_sys_ctrl);
> +	}
> +
> +	/* system control register for mphy */
> +	host->ufs_phy_ctrl = devm_platform_ioremap_resource_byname(pdev, "mphy_grf");
> +	if (IS_ERR(host->ufs_phy_ctrl)) {
> +		dev_err(dev, "cannot ioremap for mphy system control register\n");
> +		return PTR_ERR(host->ufs_phy_ctrl);
> +	}
> +
> +	/* mphy base register */
> +	host->mphy_base = devm_platform_ioremap_resource_byname(pdev, "mphy");
> +	if (IS_ERR(host->mphy_base)) {
> +		dev_err(dev, "cannot ioremap for mphy base register\n");
> +		return PTR_ERR(host->mphy_base);
> +	}
> +
> +	host->rst = devm_reset_control_array_get_exclusive(dev);
> +	if (IS_ERR(host->rst)) {
> +		dev_err(dev, "failed to get reset control\n");
> +		return PTR_ERR(host->rst);

return dev_err_probe, assuming this is a probe path?

> +	}
> +
> +	reset_control_assert(host->rst);
> +	udelay(1);
> +	reset_control_deassert(host->rst);
> +
> +	host->ref_out_clk = devm_clk_get(dev, "ref_out");
> +	if (IS_ERR(host->ref_out_clk)) {
> +		dev_err(dev, "ciu-drive not available\n");
> +		return PTR_ERR(host->ref_out_clk);

Ditto

> +	}
> +	err = clk_prepare_enable(host->ref_out_clk);
> +	if (err) {
> +		dev_err(dev, "failed to enable ref out clock %d\n", err);
> +		return err;
> +	}
> +
> +	host->rst_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);

Hm? Test your DTS and bindings.

> +	if (IS_ERR(host->rst_gpio)) {
> +		dev_err(&pdev->dev, "invalid reset-gpios property in node\n");

Post your DTS so we can review it. Post also results of dtbs_check...

> +		err = PTR_ERR(host->rst_gpio);

dev_err_probe

> +		goto out;
> +	}
> +	udelay(20);
> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
> +
> +	host->clks[0].id = "core";
> +	host->clks[1].id = "pclk";
> +	host->clks[2].id = "pclk_mphy";
> +	err = devm_clk_bulk_get_optional(dev, UFS_MAX_CLKS, host->clks);
> +	if (err) {
> +		dev_err(dev, "failed to get clocks %d\n", err);
> +		goto out;
> +	}
> +
> +	err = clk_bulk_prepare_enable(UFS_MAX_CLKS, host->clks);
> +	if (err) {
> +		dev_err(dev, "failed to enable clocks %d\n", err);
> +		goto out;
> +	}
> +
> +	if (device_property_read_u32(dev, "ufs-phy-config-mode",

No, stop adding undocumented properties.

> +				     &host->phy_config_mode))
> +		host->phy_config_mode = 0;
> +
> +	pm_runtime_set_active(&pdev->dev);
> +
> +	host->hba = hba;
> +	ufs_rockchip_set_pm_lvl(hba);
> +
> +	ufshcd_set_variant(hba, host);
> +
> +	return 0;
> +out:
> +	clk_disable_unprepare(host->ref_out_clk);
> +	return err;
> +}
> +
> +static int ufs_rockchip_rk3576_init(struct ufs_hba *hba)
> +{
> +	int ret = 0;
> +	struct device *dev = hba->dev;
> +
> +	hba->quirks = UFSHCI_QUIRK_BROKEN_HCE | UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING;
> +
> +	/* Enable BKOPS when suspend */
> +	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
> +	/* Enable putting device into deep sleep */
> +	hba->caps |= UFSHCD_CAP_DEEPSLEEP;
> +	/* Enable devfreq of UFS */
> +	hba->caps |= UFSHCD_CAP_CLK_SCALING;
> +	/* Enable WriteBooster */
> +	hba->caps |= UFSHCD_CAP_WB_EN;
> +
> +	ret = ufs_rockchip_common_init(hba);
> +	if (ret) {
> +		dev_err(dev, "ufs common init fail\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ufs_rockchip_device_reset(struct ufs_hba *hba)
> +{
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	if (!host->rst_gpio)
> +		return -EOPNOTSUPP;
> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 0);
> +	udelay(20);
> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
> +	udelay(20);
> +
> +	return 0;
> +}
> +
> +static const struct ufs_hba_variant_ops ufs_hba_rk3576_vops = {
> +	.name = "rk3576",
> +	.init = ufs_rockchip_rk3576_init,
> +	.device_reset = ufs_rockchip_device_reset,
> +	.hce_enable_notify = ufs_rockchip_hce_enable_notify,
> +	.phy_initialization = ufs_rockchip_rk3576_phy_init,
> +};
> +
> +static const struct of_device_id ufs_rockchip_of_match[] = {
> +	{ .compatible = "rockchip,rk3576-ufs", .data = &ufs_hba_rk3576_vops},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ufs_rockchip_of_match);
> +
> +static int ufs_rockchip_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct device *dev = &pdev->dev;
> +	const struct ufs_hba_variant_ops *vops;
> +
> +	vops = device_get_match_data(dev);
> +	err = ufshcd_pltfrm_init(pdev, vops);
> +	if (err)
> +		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> +
> +	return err;
> +}
> +
> +static void ufs_rockchip_remove(struct platform_device *pdev)
> +{
> +	struct ufs_hba *hba = platform_get_drvdata(pdev);
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	pm_runtime_forbid(&pdev->dev);
> +	pm_runtime_get_noresume(&pdev->dev);
> +	ufshcd_remove(hba);
> +	ufshcd_dealloc_host(hba);
> +	clk_disable_unprepare(host->ref_out_clk);
> +}
> +
> +static int ufs_rockchip_restore_link(struct ufs_hba *hba, bool is_store)
> +{
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +	int err, retry = 3;
> +
> +	if (is_store) {
> +		host->ie = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> +		host->ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +		return 0;
> +	}
> +
> +	/* Enable controller */
> +	err = ufshcd_hba_enable(hba);
> +	if (err)
> +		return err;
> +
> +	/* Link startup and wait for DP */
> +	do {
> +		err = ufshcd_dme_link_startup(hba);
> +		if (!err && ufshcd_is_device_present(hba)) {
> +			dev_dbg_ratelimited(hba->dev, "rockchip link startup successfully.\n");
> +			break;
> +		}
> +	} while (retry--);
> +
> +	if (retry < 0) {
> +		dev_err(hba->dev, "rockchip link startup failed.\n");
> +		return -ENXIO;
> +	}
> +
> +	/* Restore negotiated power mode */
> +	err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
> +	if (err)
> +		dev_err(hba->dev, "Failed to restore power mode, err = %d\n", err);
> +
> +	/* Restore task and transfer list */
> +	ufshcd_writel(hba, 0xffffffff, REG_INTERRUPT_STATUS);
> +	ufshcd_make_hba_operational(hba);
> +
> +	/* Restore lost regs */
> +	ufshcd_writel(hba, host->ie, REG_INTERRUPT_ENABLE);
> +	ufshcd_writel(hba, host->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +	ufshcd_writel(hba, 0x1, REG_UTP_TRANSFER_REQ_LIST_RUN_STOP);
> +	ufshcd_writel(hba, 0x1, REG_UTP_TASK_REQ_LIST_RUN_STOP);
> +
> +	return err;
> +}
> +
> +static int ufs_rockchip_runtime_suspend(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	clk_disable_unprepare(host->ref_out_clk);
> +	return ufs_rockchip_restore_link(hba, true);
> +}
> +
> +static int ufs_rockchip_runtime_resume(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +	int err;
> +
> +	err = clk_prepare_enable(host->ref_out_clk);
> +	if (err) {
> +		dev_err(hba->dev, "failed to enable ref out clock %d\n", err);
> +		return err;
> +	}
> +
> +	reset_control_assert(host->rst);
> +	udelay(1);
> +	reset_control_deassert(host->rst);
> +
> +	return ufs_rockchip_restore_link(hba, false);
> +}
> +
> +static int ufs_rockchip_suspend(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	if (pm_runtime_suspended(hba->dev))
> +		return 0;
> +
> +	ufs_rockchip_restore_link(hba, true);
> +
> +	return 0;
> +}
> +
> +static int ufs_rockchip_resume(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	if (pm_runtime_suspended(hba->dev))
> +		return 0;
> +
> +	/* Reset device if possible */
> +	ufs_rockchip_device_reset(hba);
> +	ufs_rockchip_restore_link(hba, false);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
> +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> +	.prepare	 = ufshcd_suspend_prepare,
> +	.complete	 = ufshcd_resume_complete,
> +};
> +
> +static struct platform_driver ufs_rockchip_pltform = {
> +	.probe = ufs_rockchip_probe,
> +	.remove = ufs_rockchip_remove,
> +	.driver = {
> +		.name = "ufshcd-rockchip",
> +		.pm = &ufs_rockchip_pm_ops,
> +		.of_match_table = of_match_ptr(ufs_rockchip_of_match),

Drop of_match_ptr, you have here warnings.

Best regards,
Krzysztof

