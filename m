From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v8 8/8] scsi: ufs-qcom: add QUniPro hardware support and
 power optimizations
Date: Tue, 27 Oct 2015 15:04:37 -0000
Message-ID: <833fddad325a96049838fa177392d5cc.squirrel@www.codeaurora.org>
References: <1445770250-28802-1-git-send-email-ygardi@codeaurora.org>
    <1445770250-28802-9-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445770250-28802-9-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> New revisions of UFS host controller supports the new UniPro
> hardware controller (referred as QUniPro). This patch adds
> the support to enable this new UniPro controller hardware.
>
> This change also adds power optimization for bus scaling feature,
> as well as support for HS-G3 power mode.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 640
> ++++++++++++++++++++++++++++++++------------
>  drivers/scsi/ufs/ufs-qcom.h |  31 ++-
>  drivers/scsi/ufs/ufshcd.c   |   8 +-
>  drivers/scsi/ufs/ufshcd.h   |  27 +-
>  4 files changed, 525 insertions(+), 181 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 1633808..4f38d00 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -44,11 +44,11 @@ enum {
>
>  static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
>
> -static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char
> *result);
> -static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
> -		const char *speed_mode);
>  static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
> +static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba
> *hba,
> +						       u32 clk_cycles);
> +
>  static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int len,
>  		char *prefix)
>  {
> @@ -177,6 +177,7 @@ static int ufs_qcom_init_lane_clks(struct
> ufs_qcom_host *host)
>
>  	err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
>  		&host->tx_l1_sync_clk);
> +
>  out:
>  	return err;
>  }
> @@ -209,7 +210,9 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>
>  	do {
>  		err = ufshcd_dme_get(hba,
> -			UIC_ARG_MIB(MPHY_TX_FSM_STATE), &tx_fsm_val);
> +				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				&tx_fsm_val);
>  		if (err || tx_fsm_val == TX_FSM_HIBERN8)
>  			break;
>
> @@ -223,7 +226,9 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>  	 */
>  	if (time_after(jiffies, timeout))
>  		err = ufshcd_dme_get(hba,
> -				UIC_ARG_MIB(MPHY_TX_FSM_STATE), &tx_fsm_val);
> +				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				&tx_fsm_val);
>
>  	if (err) {
>  		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> @@ -237,6 +242,15 @@ static int ufs_qcom_check_hibern8(struct ufs_hba
> *hba)
>  	return err;
>  }
>
> +static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
> +{
> +	ufshcd_rmwl(host->hba, QUNIPRO_SEL,
> +		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
> +		   REG_UFS_CFG1);
> +	/* make sure above configuration is applied before we return */
> +	mb();
> +}
> +
>  static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> @@ -251,9 +265,11 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba
> *hba)
>  	usleep_range(1000, 1100);
>
>  	ret = ufs_qcom_phy_calibrate_phy(phy, is_rate_B);
> +
>  	if (ret) {
> -		dev_err(hba->dev, "%s: ufs_qcom_phy_calibrate_phy() failed, ret =
> %d\n",
> -			__func__, ret);
> +		dev_err(hba->dev,
> +		"%s: ufs_qcom_phy_calibrate_phy()failed, ret = %d\n",
> +		__func__, ret);
>  		goto out;
>  	}
>
> @@ -274,9 +290,12 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba
> *hba)
>
>  	ret = ufs_qcom_phy_is_pcs_ready(phy);
>  	if (ret)
> -		dev_err(hba->dev, "%s: is_physical_coding_sublayer_ready() failed, ret
> = %d\n",
> +		dev_err(hba->dev,
> +			"%s: is_physical_coding_sublayer_ready() failed, ret = %d\n",
>  			__func__, ret);
>
> +	ufs_qcom_select_unipro_mode(host);
> +
>  out:
>  	return ret;
>  }
> @@ -299,7 +318,8 @@ static void ufs_qcom_enable_hw_clk_gating(struct
> ufs_hba *hba)
>  	mb();
>  }
>
> -static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba, bool status)
> +static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
> +				      enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	int err = 0;
> @@ -329,12 +349,12 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba
> *hba, bool status)
>  }
>
>  /**
> - * Returns non-zero for success (which rate of core_clk) and 0
> - * in case of a failure
> + * Returns zero for success and non-zero in case of a failure
>   */
> -static unsigned long
> -ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
> +static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
> +			       u32 hs, u32 rate, bool update_link_startup_timer)
>  {
> +	int ret = 0;
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	struct ufs_clk_info *clki;
>  	u32 core_clk_period_in_ns;
> @@ -352,11 +372,13 @@ ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
> u32 hs, u32 rate)
>  	static u32 hs_fr_table_rA[][2] = {
>  		{UFS_HS_G1, 0x1F},
>  		{UFS_HS_G2, 0x3e},
> +		{UFS_HS_G3, 0x7D},
>  	};
>
>  	static u32 hs_fr_table_rB[][2] = {
>  		{UFS_HS_G1, 0x24},
>  		{UFS_HS_G2, 0x49},
> +		{UFS_HS_G3, 0x92},
>  	};
>
>  	/*
> @@ -384,7 +406,17 @@ ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
> u32 hs, u32 rate)
>  		core_clk_rate = DEFAULT_CLK_RATE_HZ;
>
>  	core_clk_cycles_per_us = core_clk_rate / USEC_PER_SEC;
> -	ufshcd_writel(hba, core_clk_cycles_per_us, REG_UFS_SYS1CLK_1US);
> +	if (ufshcd_readl(hba, REG_UFS_SYS1CLK_1US) != core_clk_cycles_per_us) {
> +		ufshcd_writel(hba, core_clk_cycles_per_us, REG_UFS_SYS1CLK_1US);
> +		/*
> +		 * make sure above write gets applied before we return from
> +		 * this function.
> +		 */
> +		mb();
> +	}
> +
> +	if (ufs_qcom_cap_qunipro(host))
> +		goto out;
>
>  	core_clk_period_in_ns = NSEC_PER_SEC / core_clk_rate;
>  	core_clk_period_in_ns <<= OFFSET_CLK_NS_REG;
> @@ -434,35 +466,59 @@ ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
> u32 hs, u32 rate)
>  		goto out_error;
>  	}
>
> -	/* this register 2 fields shall be written at once */
> -	ufshcd_writel(hba, core_clk_period_in_ns | tx_clk_cycles_per_us,
> -						REG_UFS_TX_SYMBOL_CLK_NS_US);
> +	if (ufshcd_readl(hba, REG_UFS_TX_SYMBOL_CLK_NS_US) !=
> +	    (core_clk_period_in_ns | tx_clk_cycles_per_us)) {
> +		/* this register 2 fields shall be written at once */
> +		ufshcd_writel(hba, core_clk_period_in_ns | tx_clk_cycles_per_us,
> +			      REG_UFS_TX_SYMBOL_CLK_NS_US);
> +		/*
> +		 * make sure above write gets applied before we return from
> +		 * this function.
> +		 */
> +		mb();
> +	}
> +
> +	if (update_link_startup_timer) {
> +		ufshcd_writel(hba, ((core_clk_rate / MSEC_PER_SEC) * 100),
> +			      REG_UFS_PA_LINK_STARTUP_TIMER);
> +		/*
> +		 * make sure that this configuration is applied before
> +		 * we return
> +		 */
> +		mb();
> +	}
>  	goto out;
>
>  out_error:
> -	core_clk_rate = 0;
> +	ret = -EINVAL;
>  out:
> -	return core_clk_rate;
> +	return ret;
>  }
>
> -static int ufs_qcom_link_startup_notify(struct ufs_hba *hba, bool status)
> +static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
> +					enum ufs_notify_change_status status)
>  {
> -	unsigned long core_clk_rate = 0;
> -	u32 core_clk_cycles_per_100ms;
> +	int err = 0;
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>
>  	switch (status) {
>  	case PRE_CHANGE:
> -		core_clk_rate = ufs_qcom_cfg_timers(hba, UFS_PWM_G1,
> -						    SLOWAUTO_MODE, 0);
> -		if (!core_clk_rate) {
> +		if (ufs_qcom_cfg_timers(hba, UFS_PWM_G1, SLOWAUTO_MODE,
> +					0, true)) {
>  			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers() failed\n",
>  				__func__);
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto out;
>  		}
> -		core_clk_cycles_per_100ms =
> -			(core_clk_rate / MSEC_PER_SEC) * 100;
> -		ufshcd_writel(hba, core_clk_cycles_per_100ms,
> -					REG_UFS_PA_LINK_STARTUP_TIMER);
> +
> +		if (ufs_qcom_cap_qunipro(host))
> +			/*
> +			 * set unipro core clock cycles to 150 & clear clock
> +			 * divider
> +			 */
> +			err = ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(hba,
> +									  150);
> +
>  		break;
>  	case POST_CHANGE:
>  		ufs_qcom_link_startup_post_change(hba);
> @@ -471,7 +527,8 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba
> *hba, bool status)
>  		break;
>  	}
>
> -	return 0;
> +out:
> +	return err;
>  }
>
>  static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> @@ -498,8 +555,10 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  	 * If UniPro link is not active, PHY ref_clk, main PHY analog power
>  	 * rail and low noise analog power rail for PLL can be switched off.
>  	 */
> -	if (!ufs_qcom_is_link_active(hba))
> +	if (!ufs_qcom_is_link_active(hba)) {
> +		ufs_qcom_disable_lane_clks(host);
>  		phy_power_off(phy);
> +	}
>
>  out:
>  	return ret;
> @@ -518,6 +577,10 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  		goto out;
>  	}
>
> +	err = ufs_qcom_enable_lane_clks(host);
> +	if (err)
> +		goto out;
> +
>  	hba->is_sys_suspended = false;
>
>  out:
> @@ -622,6 +685,81 @@ static int ufs_qcom_get_pwr_dev_param(struct
> ufs_qcom_dev_params *qcom_param,
>  	return 0;
>  }
>
> +#ifdef CONFIG_MSM_BUS_SCALING
> +static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
> +		const char *speed_mode)
> +{
> +	struct device *dev = host->hba->dev;
> +	struct device_node *np = dev->of_node;
> +	int err;
> +	const char *key = "qcom,bus-vector-names";
> +
> +	if (!speed_mode) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (host->bus_vote.is_max_bw_needed && !!strcmp(speed_mode, "MIN"))
> +		err = of_property_match_string(np, key, "MAX");
> +	else
> +		err = of_property_match_string(np, key, speed_mode);
> +
> +out:
> +	if (err < 0)
> +		dev_err(dev, "%s: Invalid %s mode %d\n",
> +				__func__, speed_mode, err);
> +	return err;
> +}
> +
> +static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char
> *result)
> +{
> +	int gear = max_t(u32, p->gear_rx, p->gear_tx);
> +	int lanes = max_t(u32, p->lane_rx, p->lane_tx);
> +	int pwr;
> +
> +	/* default to PWM Gear 1, Lane 1 if power mode is not initialized */
> +	if (!gear)
> +		gear = 1;
> +
> +	if (!lanes)
> +		lanes = 1;
> +
> +	if (!p->pwr_rx && !p->pwr_tx) {
> +		pwr = SLOWAUTO_MODE;
> +		snprintf(result, BUS_VECTOR_NAME_LEN, "MIN");
> +	} else if (p->pwr_rx == FAST_MODE || p->pwr_rx == FASTAUTO_MODE ||
> +		 p->pwr_tx == FAST_MODE || p->pwr_tx == FASTAUTO_MODE) {
> +		pwr = FAST_MODE;
> +		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_R%s_G%d_L%d", "HS",
> +			 p->hs_rate == PA_HS_MODE_B ? "B" : "A", gear, lanes);
> +	} else {
> +		pwr = SLOW_MODE;
> +		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_G%d_L%d",
> +			 "PWM", gear, lanes);
> +	}
> +}
> +
> +static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
> +{
> +	int err = 0;
> +
> +	if (vote != host->bus_vote.curr_vote) {
> +		err = msm_bus_scale_client_update_request(
> +				host->bus_vote.client_handle, vote);
> +		if (err) {
> +			dev_err(host->hba->dev,
> +				"%s: msm_bus_scale_client_update_request() failed:
> bus_client_handle=0x%x, vote=%d, err=%d\n",
> +				__func__, host->bus_vote.client_handle,
> +				vote, err);
> +			goto out;
> +		}
> +
> +		host->bus_vote.curr_vote = vote;
> +	}
> +out:
> +	return err;
> +}
> +
>  static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
>  {
>  	int vote;
> @@ -643,8 +781,132 @@ static int ufs_qcom_update_bus_bw_vote(struct
> ufs_qcom_host *host)
>  	return err;
>  }
>
> +static ssize_t
> +show_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
> *attr,
> +			char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +
> +	return snprintf(buf, PAGE_SIZE, "%u\n",
> +			host->bus_vote.is_max_bw_needed);
> +}
> +
> +static ssize_t
> +store_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
> *attr,
> +		const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	uint32_t value;
> +
> +	if (!kstrtou32(buf, 0, &value)) {
> +		host->bus_vote.is_max_bw_needed = !!value;
> +		ufs_qcom_update_bus_bw_vote(host);
> +	}
> +
> +	return count;
> +}
> +
> +static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
> +{
> +	int err;
> +	struct msm_bus_scale_pdata *bus_pdata;
> +	struct device *dev = host->hba->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct device_node *np = dev->of_node;
> +
> +	bus_pdata = msm_bus_cl_get_pdata(pdev);
> +	if (!bus_pdata) {
> +		dev_err(dev, "%s: failed to get bus vectors\n", __func__);
> +		err = -ENODATA;
> +		goto out;
> +	}
> +
> +	err = of_property_count_strings(np, "qcom,bus-vector-names");
> +	if (err < 0 || err != bus_pdata->num_usecases) {
> +		dev_err(dev, "%s: qcom,bus-vector-names not specified correctly %d\n",
> +				__func__, err);
> +		goto out;
> +	}
> +
> +	host->bus_vote.client_handle = msm_bus_scale_register_client(bus_pdata);
> +	if (!host->bus_vote.client_handle) {
> +		dev_err(dev, "%s: msm_bus_scale_register_client failed\n",
> +				__func__);
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* cache the vote index for minimum and maximum bandwidth */
> +	host->bus_vote.min_bw_vote = ufs_qcom_get_bus_vote(host, "MIN");
> +	host->bus_vote.max_bw_vote = ufs_qcom_get_bus_vote(host, "MAX");
> +
> +	host->bus_vote.max_bus_bw.show = show_ufs_to_mem_max_bus_bw;
> +	host->bus_vote.max_bus_bw.store = store_ufs_to_mem_max_bus_bw;
> +	sysfs_attr_init(&host->bus_vote.max_bus_bw.attr);
> +	host->bus_vote.max_bus_bw.attr.name = "max_bus_bw";
> +	host->bus_vote.max_bus_bw.attr.mode = S_IRUGO | S_IWUSR;
> +	err = device_create_file(dev, &host->bus_vote.max_bus_bw);
> +out:
> +	return err;
> +}
> +#else /* CONFIG_MSM_BUS_SCALING */
> +static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
> +{
> +	return 0;
> +}
> +
> +static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
> +{
> +	return 0;
> +}
> +
> +static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_MSM_BUS_SCALING */
> +
> +static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool
> enable)
> +{
> +	if (host->dev_ref_clk_ctrl_mmio &&
> +	    (enable ^ host->is_dev_ref_clk_enabled)) {
> +		u32 temp = readl_relaxed(host->dev_ref_clk_ctrl_mmio);
> +
> +		if (enable)
> +			temp |= host->dev_ref_clk_en_mask;
> +		else
> +			temp &= ~host->dev_ref_clk_en_mask;
> +
> +		/*
> +		 * If we are here to disable this clock it might be immediately
> +		 * after entering into hibern8 in which case we need to make
> +		 * sure that device ref_clk is active at least 1us after the
> +		 * hibern8 enter.
> +		 */
> +		if (!enable)
> +			udelay(1);
> +
> +		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
> +
> +		/* ensure that ref_clk is enabled/disabled before we return */
> +		wmb();
> +
> +		/*
> +		 * If we call hibern8 exit after this, we need to make sure that
> +		 * device ref_clk is stable for at least 1us before the hibern8
> +		 * exit command.
> +		 */
> +		if (enable)
> +			udelay(1);
> +
> +		host->is_dev_ref_clk_enabled = enable;
> +	}
> +}
> +
>  static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
> -				bool status,
> +				enum ufs_notify_change_status status,
>  				struct ufs_pa_layer_attr *dev_max_params,
>  				struct ufs_pa_layer_attr *dev_req_params)
>  {
> @@ -677,6 +939,20 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba
> *hba,
>  		ufs_qcom_cap.desired_working_mode =
>  					UFS_QCOM_LIMIT_DESIRED_MODE;
>
> +		if (host->hw_ver.major == 0x1) {
> +			/*
> +			 * HS-G3 operations may not reliably work on legacy QCOM
> +			 * UFS host controller hardware even though capability
> +			 * exchange during link startup phase may end up
> +			 * negotiating maximum supported gear as G3.
> +			 * Hence downgrade the maximum supported gear to HS-G2.
> +			 */
> +			if (ufs_qcom_cap.hs_tx_gear > UFS_HS_G2)
> +				ufs_qcom_cap.hs_tx_gear = UFS_HS_G2;
> +			if (ufs_qcom_cap.hs_rx_gear > UFS_HS_G2)
> +				ufs_qcom_cap.hs_rx_gear = UFS_HS_G2;
> +		}
> +
>  		ret = ufs_qcom_get_pwr_dev_param(&ufs_qcom_cap,
>  						 dev_max_params,
>  						 dev_req_params);
> @@ -688,9 +964,9 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba
> *hba,
>
>  		break;
>  	case POST_CHANGE:
> -		if (!ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
> +		if (ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
>  					dev_req_params->pwr_rx,
> -					dev_req_params->hs_rate)) {
> +					dev_req_params->hs_rate, false)) {
>  			dev_err(hba->dev, "%s: ufs_qcom_cfg_timers() failed\n",
>  				__func__);
>  			/*
> @@ -752,10 +1028,11 @@ static void ufs_qcom_advertise_quirks(struct
> ufs_hba *hba)
>
>  		if (host->hw_ver.minor == 0x0001 && host->hw_ver.step == 0x0001)
>  			hba->quirks |= UFSHCD_QUIRK_BROKEN_INTR_AGGR;
> +
> +		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
>  	}
>
>  	if (host->hw_ver.major >= 0x2) {
> -		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
>
>  		if (!ufs_qcom_cap_qunipro(host))
> @@ -770,77 +1047,27 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>
> -	if (host->hw_ver.major >= 0x2)
> -		host->caps = UFS_QCOM_CAP_QUNIPRO;
> -}
> -
> -static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
> -		const char *speed_mode)
> -{
> -	struct device *dev = host->hba->dev;
> -	struct device_node *np = dev->of_node;
> -	int err;
> -	const char *key = "qcom,bus-vector-names";
> -
> -	if (!speed_mode) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (host->bus_vote.is_max_bw_needed && !!strcmp(speed_mode, "MIN"))
> -		err = of_property_match_string(np, key, "MAX");
> -	else
> -		err = of_property_match_string(np, key, speed_mode);
> -
> -out:
> -	if (err < 0)
> -		dev_err(dev, "%s: Invalid %s mode %d\n",
> -				__func__, speed_mode, err);
> -	return err;
> -}
> -
> -static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
> -{
> -	int err = 0;
> -
> -	if (vote != host->bus_vote.curr_vote)
> -		host->bus_vote.curr_vote = vote;
> -
> -	return err;
> -}
> -
> -static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char
> *result)
> -{
> -	int gear = max_t(u32, p->gear_rx, p->gear_tx);
> -	int lanes = max_t(u32, p->lane_rx, p->lane_tx);
> -	int pwr;
> -
> -	/* default to PWM Gear 1, Lane 1 if power mode is not initialized */
> -	if (!gear)
> -		gear = 1;
> -
> -	if (!lanes)
> -		lanes = 1;
> +	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
> +	hba->caps |= UFSHCD_CAP_CLK_SCALING;
> +	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>
> -	if (!p->pwr_rx && !p->pwr_tx) {
> -		pwr = SLOWAUTO_MODE;
> -		snprintf(result, BUS_VECTOR_NAME_LEN, "MIN");
> -	} else if (p->pwr_rx == FAST_MODE || p->pwr_rx == FASTAUTO_MODE ||
> -		 p->pwr_tx == FAST_MODE || p->pwr_tx == FASTAUTO_MODE) {
> -		pwr = FAST_MODE;
> -		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_R%s_G%d_L%d", "HS",
> -			 p->hs_rate == PA_HS_MODE_B ? "B" : "A", gear, lanes);
> -	} else {
> -		pwr = SLOW_MODE;
> -		snprintf(result, BUS_VECTOR_NAME_LEN, "%s_G%d_L%d",
> -			 "PWM", gear, lanes);
> +	if (host->hw_ver.major >= 0x2) {
> +		host->caps = UFS_QCOM_CAP_QUNIPRO |
> +			     UFS_QCOM_CAP_RETAIN_SEC_CFG_AFTER_PWR_COLLAPSE;
>  	}
>  }
>
> +/**
> + * ufs_qcom_setup_clocks - enables/disable clocks
> + * @hba: host controller instance
> + * @on: If true, enable clocks else disable them.
> + *
> + * Returns 0 on success, non-zero on failure.
> + */
>  static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	int err = 0;
> +	int err;
>  	int vote = 0;
>
>  	/*
> @@ -863,20 +1090,18 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
> *hba, bool on)
>  			ufs_qcom_phy_disable_iface_clk(host->generic_phy);
>  			goto out;
>  		}
> -		/* enable the device ref clock */
> -		ufs_qcom_phy_enable_dev_ref_clk(host->generic_phy);
>  		vote = host->bus_vote.saved_vote;
>  		if (vote == host->bus_vote.min_bw_vote)
>  			ufs_qcom_update_bus_bw_vote(host);
> +
>  	} else {
> +
>  		/* M-PHY RMMI interface clocks can be turned off */
>  		ufs_qcom_phy_disable_iface_clk(host->generic_phy);
> -		if (!ufs_qcom_is_link_active(hba)) {
> -			/* turn off UFS local PHY ref_clk */
> -			ufs_qcom_phy_disable_ref_clk(host->generic_phy);
> +		if (!ufs_qcom_is_link_active(hba))
>  			/* disable device ref_clk */
> -			ufs_qcom_phy_disable_dev_ref_clk(host->generic_phy);
> -		}
> +			ufs_qcom_dev_ref_clk_ctrl(host, false);
> +
>  		vote = host->bus_vote.min_bw_vote;
>  	}
>
> @@ -889,60 +1114,6 @@ out:
>  	return err;
>  }
>
> -static ssize_t
> -show_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
> *attr,
> -			char *buf)
> -{
> -	struct ufs_hba *hba = dev_get_drvdata(dev);
> -	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -
> -	return snprintf(buf, PAGE_SIZE, "%u\n",
> -			host->bus_vote.is_max_bw_needed);
> -}
> -
> -static ssize_t
> -store_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute
> *attr,
> -		const char *buf, size_t count)
> -{
> -	struct ufs_hba *hba = dev_get_drvdata(dev);
> -	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	uint32_t value;
> -
> -	if (!kstrtou32(buf, 0, &value)) {
> -		host->bus_vote.is_max_bw_needed = !!value;
> -		ufs_qcom_update_bus_bw_vote(host);
> -	}
> -
> -	return count;
> -}
> -
> -static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
> -{
> -	int err;
> -	struct device *dev = host->hba->dev;
> -	struct device_node *np = dev->of_node;
> -
> -	err = of_property_count_strings(np, "qcom,bus-vector-names");
> -	if (err < 0 ) {
> -		dev_err(dev, "%s: qcom,bus-vector-names not specified correctly %d\n",
> -				__func__, err);
> -		goto out;
> -	}
> -
> -	/* cache the vote index for minimum and maximum bandwidth */
> -	host->bus_vote.min_bw_vote = ufs_qcom_get_bus_vote(host, "MIN");
> -	host->bus_vote.max_bw_vote = ufs_qcom_get_bus_vote(host, "MAX");
> -
> -	host->bus_vote.max_bus_bw.show = show_ufs_to_mem_max_bus_bw;
> -	host->bus_vote.max_bus_bw.store = store_ufs_to_mem_max_bus_bw;
> -	sysfs_attr_init(&host->bus_vote.max_bus_bw.attr);
> -	host->bus_vote.max_bus_bw.attr.name = "max_bus_bw";
> -	host->bus_vote.max_bus_bw.attr.mode = S_IRUGO | S_IWUSR;
> -	err = device_create_file(dev, &host->bus_vote.max_bus_bw);
> -out:
> -	return err;
> -}
> -
>  #define	ANDROID_BOOT_DEV_MAX	30
>  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
>
> @@ -969,7 +1140,9 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  {
>  	int err;
>  	struct device *dev = hba->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct ufs_qcom_host *host;
> +	struct resource *res;
>
>  	if (strlen(android_boot_dev) && strcmp(android_boot_dev, dev_name(dev)))
>  		return -ENODEV;
> @@ -981,9 +1154,15 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		goto out;
>  	}
>
> +	/* Make a two way bind between the qcom host and the hba */
>  	host->hba = hba;
>  	ufshcd_set_variant(hba, host);
>
> +	/*
> +	 * voting/devoting device ref_clk source is time consuming hence
> +	 * skip devoting it during aggressive clock gating. This clock
> +	 * will still be gated off during runtime suspend.
> +	 */
>  	host->generic_phy = devm_phy_get(dev, "ufsphy");
>
>  	if (IS_ERR(host->generic_phy)) {
> @@ -999,6 +1178,30 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	ufs_qcom_get_controller_revision(hba, &host->hw_ver.major,
>  		&host->hw_ver.minor, &host->hw_ver.step);
>
> +	/*
> +	 * for newer controllers, device reference clock control bit has
> +	 * moved inside UFS controller register address space itself.
> +	 */
> +	if (host->hw_ver.major >= 0x02) {
> +		host->dev_ref_clk_ctrl_mmio = hba->mmio_base + REG_UFS_CFG1;
> +		host->dev_ref_clk_en_mask = BIT(26);
> +	} else {
> +		/* "dev_ref_clk_ctrl_mem" is optional resource */
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		if (res) {
> +			host->dev_ref_clk_ctrl_mmio =
> +					devm_ioremap_resource(dev, res);
> +			if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
> +				dev_warn(dev,
> +					"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
> +					__func__,
> +					PTR_ERR(host->dev_ref_clk_ctrl_mmio));
> +				host->dev_ref_clk_ctrl_mmio = NULL;
> +			}
> +			host->dev_ref_clk_en_mask = BIT(5);
> +		}
> +	}
> +
>  	/* update phy revision information before calling phy_init() */
>  	ufs_qcom_phy_save_controller_version(host->generic_phy,
>  		host->hw_ver.major, host->hw_ver.minor, host->hw_ver.step);
> @@ -1015,9 +1218,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	ufs_qcom_set_caps(hba);
>  	ufs_qcom_advertise_quirks(hba);
>
> -	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_CLK_SCALING;
> -	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
> -
>  	ufs_qcom_setup_clocks(hba, true);
>
>  	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
> @@ -1053,14 +1253,118 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
>  	phy_power_off(host->generic_phy);
>  }
>
> -static
> -void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
> +static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba
> *hba,
> +						       u32 clk_cycles)
> +{
> +	int err;
> +	u32 core_clk_ctrl_reg;
> +
> +	if (clk_cycles > DME_VS_CORE_CLK_CTRL_MAX_CORE_CLK_1US_CYCLES_MASK)
> +		return -EINVAL;
> +
> +	err = ufshcd_dme_get(hba,
> +			    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
> +			    &core_clk_ctrl_reg);
> +	if (err)
> +		goto out;
> +
> +	core_clk_ctrl_reg &= ~DME_VS_CORE_CLK_CTRL_MAX_CORE_CLK_1US_CYCLES_MASK;
> +	core_clk_ctrl_reg |= clk_cycles;
> +
> +	/* Clear CORE_CLK_DIV_EN */
> +	core_clk_ctrl_reg &= ~DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT;
> +
> +	err = ufshcd_dme_set(hba,
> +			    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
> +			    core_clk_ctrl_reg);
> +out:
> +	return err;
> +}
> +
> +static int ufs_qcom_clk_scale_up_pre_change(struct ufs_hba *hba)
> +{
> +	/* nothing to do as of now */
> +	return 0;
> +}
> +
> +static int ufs_qcom_clk_scale_up_post_change(struct ufs_hba *hba)
> +{
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +
> +	if (!ufs_qcom_cap_qunipro(host))
> +		return 0;
> +
> +	/* set unipro core clock cycles to 150 and clear clock divider */
> +	return ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(hba, 150);
> +}
> +
> +static int ufs_qcom_clk_scale_down_pre_change(struct ufs_hba *hba)
> +{
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	int err;
> +	u32 core_clk_ctrl_reg;
> +
> +	if (!ufs_qcom_cap_qunipro(host))
> +		return 0;
> +
> +	err = ufshcd_dme_get(hba,
> +			    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
> +			    &core_clk_ctrl_reg);
> +
> +	/* make sure CORE_CLK_DIV_EN is cleared */
> +	if (!err &&
> +	    (core_clk_ctrl_reg & DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT)) {
> +		core_clk_ctrl_reg &= ~DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT;
> +		err = ufshcd_dme_set(hba,
> +				    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
> +				    core_clk_ctrl_reg);
> +	}
> +
> +	return err;
> +}
> +
> +static int ufs_qcom_clk_scale_down_post_change(struct ufs_hba *hba)
> +{
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +
> +	if (!ufs_qcom_cap_qunipro(host))
> +		return 0;
> +
> +	/* set unipro core clock cycles to 75 and clear clock divider */
> +	return ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(hba, 75);
> +}
> +
> +static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
> +		bool scale_up, enum ufs_notify_change_status status)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	struct ufs_pa_layer_attr *dev_req_params = &host->dev_req_params;
> +	int err = 0;
>
> -	if (!dev_req_params)
> -		return;
> +	if (status == PRE_CHANGE) {
> +		if (scale_up)
> +			err = ufs_qcom_clk_scale_up_pre_change(hba);
> +		else
> +			err = ufs_qcom_clk_scale_down_pre_change(hba);
> +	} else {
> +		if (scale_up)
> +			err = ufs_qcom_clk_scale_up_post_change(hba);
> +		else
> +			err = ufs_qcom_clk_scale_down_post_change(hba);
> +
> +		if (err || !dev_req_params)
> +			goto out;
> +
> +		ufs_qcom_cfg_timers(hba,
> +				    dev_req_params->gear_rx,
> +				    dev_req_params->pwr_rx,
> +				    dev_req_params->hs_rate,
> +				    false);
> +		ufs_qcom_update_bus_bw_vote(host);
> +	}
> +
> +out:
> +	return err;
>  }
>
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 1b71a1b..36249b3 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -35,8 +35,8 @@
>
>  #define UFS_QCOM_LIMIT_NUM_LANES_RX	2
>  #define UFS_QCOM_LIMIT_NUM_LANES_TX	2
> -#define UFS_QCOM_LIMIT_HSGEAR_RX	UFS_HS_G2
> -#define UFS_QCOM_LIMIT_HSGEAR_TX	UFS_HS_G2
> +#define UFS_QCOM_LIMIT_HSGEAR_RX	UFS_HS_G3
> +#define UFS_QCOM_LIMIT_HSGEAR_TX	UFS_HS_G3
>  #define UFS_QCOM_LIMIT_PWMGEAR_RX	UFS_PWM_G4
>  #define UFS_QCOM_LIMIT_PWMGEAR_TX	UFS_PWM_G4
>  #define UFS_QCOM_LIMIT_RX_PWR_PWM	SLOW_MODE
> @@ -64,6 +64,11 @@ enum {
>  	UFS_TEST_BUS_CTRL_2			= 0xF4,
>  	UFS_UNIPRO_CFG				= 0xF8,
>
> +	/*
> +	 * QCOM UFS host controller vendor specific registers
> +	 * added in HW Version 3.0.0
> +	 */
> +	UFS_AH8_CFG				= 0xFC,
>  };
>
>  /* QCOM UFS host controller vendor specific debug registers */
> @@ -83,6 +88,11 @@ enum {
>  	UFS_UFS_DBG_RD_EDTL_RAM			= 0x1900,
>  };
>
> +#define UFS_CNTLR_2_x_x_VEN_REGS_OFFSET(x)	(0x000 + x)
> +#define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
> +
> +/* bit definitions for REG_UFS_CFG1 register */
> +#define QUNIPRO_SEL	UFS_BIT(0)
>  #define TEST_BUS_EN		BIT(18)
>  #define TEST_BUS_SEL		GENMASK(22, 19)
>
> @@ -131,6 +141,12 @@ enum ufs_qcom_phy_init_type {
>  	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_ICE_REGS_EN | \
>  	 UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
>
> +/* QUniPro Vendor specific attributes */
> +#define DME_VS_CORE_CLK_CTRL	0xD002
> +/* bit and mask definitions for DME_VS_CORE_CLK_CTRL attribute */
> +#define DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT		BIT(8)
> +#define DME_VS_CORE_CLK_CTRL_MAX_CORE_CLK_1US_CYCLES_MASK	0xFF
> +
>  static inline void
>  ufs_qcom_get_controller_revision(struct ufs_hba *hba,
>  				 u8 *major, u16 *minor, u16 *step)
> @@ -196,6 +212,12 @@ struct ufs_qcom_host {
>  	 * controller supports the QUniPro mode.
>  	 */
>  	#define UFS_QCOM_CAP_QUNIPRO	UFS_BIT(0)
> +
> +	/*
> +	 * Set this capability if host controller can retain the secure
> +	 * configuration even after UFS controller core power collapse.
> +	 */
> +	#define UFS_QCOM_CAP_RETAIN_SEC_CFG_AFTER_PWR_COLLAPSE	UFS_BIT(1)
>  	u32 caps;
>
>  	struct phy *generic_phy;
> @@ -208,7 +230,12 @@ struct ufs_qcom_host {
>  	struct clk *tx_l1_sync_clk;
>  	bool is_lane_clks_enabled;
>
> +	void __iomem *dev_ref_clk_ctrl_mmio;
> +	bool is_dev_ref_clk_enabled;
>  	struct ufs_hw_version hw_ver;
> +
> +	u32 dev_ref_clk_en_mask;
> +
>  	/* Bitmask for enabling debug prints */
>  	u32 dbg_print_en;
>  	struct ufs_qcom_testbus testbus;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 52f9dad..131c720 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5420,6 +5420,10 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>  	if (!head || list_empty(head))
>  		goto out;
>
> +	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
> +	if (ret)
> +		return ret;
> +
>  	list_for_each_entry(clki, head, list) {
>  		if (!IS_ERR_OR_NULL(clki->clk)) {
>  			if (scale_up && clki->max_freq) {
> @@ -5450,7 +5454,9 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>  		dev_dbg(hba->dev, "%s: clk: %s, rate: %lu\n", __func__,
>  				clki->name, clk_get_rate(clki->clk));
>  	}
> -	ufshcd_vops_clk_scale_notify(hba);
> +
> +	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
> +
>  out:
>  	return ret;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 471c667..2570d94 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -223,8 +223,10 @@ struct ufs_clk_info {
>  	bool enabled;
>  };
>
> -#define PRE_CHANGE      0
> -#define POST_CHANGE     1
> +enum ufs_notify_change_status {
> +	PRE_CHANGE,
> +	POST_CHANGE,
> +};
>
>  struct ufs_pa_layer_attr {
>  	u32 gear_rx;
> @@ -266,13 +268,17 @@ struct ufs_hba_variant_ops {
>  	int	(*init)(struct ufs_hba *);
>  	void    (*exit)(struct ufs_hba *);
>  	u32	(*get_ufs_hci_version)(struct ufs_hba *);
> -	void    (*clk_scale_notify)(struct ufs_hba *);
> -	int     (*setup_clocks)(struct ufs_hba *, bool);
> +	int	(*clk_scale_notify)(struct ufs_hba *, bool,
> +				    enum ufs_notify_change_status);
> +	int	(*setup_clocks)(struct ufs_hba *, bool);
>  	int     (*setup_regulators)(struct ufs_hba *, bool);
> -	int     (*hce_enable_notify)(struct ufs_hba *, bool);
> -	int     (*link_startup_notify)(struct ufs_hba *, bool);
> +	int	(*hce_enable_notify)(struct ufs_hba *,
> +				     enum ufs_notify_change_status);
> +	int	(*link_startup_notify)(struct ufs_hba *,
> +				       enum ufs_notify_change_status);
>  	int	(*pwr_change_notify)(struct ufs_hba *,
> -					bool, struct ufs_pa_layer_attr *,
> +					enum ufs_notify_change_status status,
> +					struct ufs_pa_layer_attr *,
>  					struct ufs_pa_layer_attr *);
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
> @@ -708,17 +714,18 @@ static inline u32
> ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
>  	return ufshcd_readl(hba, REG_UFS_VERSION);
>  }
>
> -static inline void ufshcd_vops_clk_scale_notify(struct ufs_hba *hba)
> +static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
> +			bool up, enum ufs_notify_change_status status)
>  {
>  	if (hba->vops && hba->vops->clk_scale_notify)
> -		return hba->vops->clk_scale_notify(hba);
> +		return hba->vops->clk_scale_notify(hba, up, status);
> +	return 0;
>  }
>
>  static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on)
>  {
>  	if (hba->vops && hba->vops->setup_clocks)
>  		return hba->vops->setup_clocks(hba, on);
> -
>  	return 0;
>  }
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
