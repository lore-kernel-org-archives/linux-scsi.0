Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85805C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37DBF2151B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgLWEet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:34:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13291 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgLWEes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 23:34:48 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201223043406epoutp010086af2c0b25f59a4e213bed60805ac5~TPlmSrBzo3074630746epoutp01K
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 04:34:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201223043406epoutp010086af2c0b25f59a4e213bed60805ac5~TPlmSrBzo3074630746epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608698046;
        bh=onmeZQtUsXH3xomvvt71ioUwsdBv4Nlv/rzBr+enPfc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=kEt3d0pXdPw77ZI5/Rdi6ugBHC6t48A0unarqTdZW1ue9YpRoTLi6H/pPyID5KH0d
         OHm3a+zIYn2uRV08IK4Oc0nFnGCjTO3coc//MZkOL+CsjwIXRI+FYceBj5hdRQ1Kwq
         zdlxDaDRJknud7PPk3elH9Ix2gyovPLqfV0Jk2TU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201223043406epcas2p4bda8a8f8f94cadb7cb9c8c5e9f8fc9b0~TPlmE0l9i1270312703epcas2p44;
        Wed, 23 Dec 2020 04:34:06 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4D10hq59W6z4x9Q7; Wed, 23 Dec
        2020 04:34:03 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.F6.52511.AB8C2EF5; Wed, 23 Dec 2020 13:34:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201223043401epcas2p366d3851e134ed547922e6e7caaff1215~TPliD13su0878208782epcas2p33;
        Wed, 23 Dec 2020 04:34:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201223043401epsmtrp1b3fa977f2d5f71547bdae140af8da7c4~TPliDSCch0931209312epsmtrp1N;
        Wed, 23 Dec 2020 04:34:01 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-0f-5fe2c8baec6f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.B5.13470.9B8C2EF5; Wed, 23 Dec 2020 13:34:01 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201223043401epsmtip2ed58a7677ebb9a6ccd37b25f5052de75~TPlh5QO-90718607186epsmtip2H;
        Wed, 23 Dec 2020 04:34:01 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Ziqi Chen'" <ziqichen@codeaurora.org>,
        <linux-scsi@vger.kernel.org>
In-Reply-To: <1608644981-46267-1-git-send-email-ziqichen@codeaurora.org>
Subject: RE: [PATCH RFC v4 1/1] scsi: ufs: Fix ufs power down/on specs
 violation
Date:   Wed, 23 Dec 2020 13:34:01 +0900
Message-ID: <00b801d6d8e4$d67986c0$836c9440$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKTL7RHejaVs/k8/ZIfCHNfOR3zuwIR+fImqHraMNA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmue6uE4/iDT4s4bXovr6DzWLpzefs
        Dkwel/t6mTw+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L
        10vOz7UyNDAwMgWqTMjJWPDnLGPBPK+Kvwt/MjcwzrXuYuTkkBAwkZj48T5TFyMXh5DADkaJ
        LR/eskA4nxglzr6ZzApSJSTwjVFiaos4TMe9H2tYIYr2Mkosu/OaEcJ5wShxc0c/O0gVm4C2
        xLSHu8G6RQQ8JXbO+cwIYnMKeEjMPzYTLC4sECRx68kUsHoWAVWJC/+XsYDYvAKWElsWt7FD
        2IISJ2c+AYszCxhJLFk9nwnClpfY/nYOM8RFChI/ny4DmskBtMtK4tw8qHIRidmdbcwgt0kI
        nGKXWH/sExNEvYvE0+nPWSFsYYlXx7ewQ9hSEi/726Dseol9UxtYIZp7GCWe7vvHCJEwlpj1
        rJ0RZJmEgLLEkVtQy/gkOg7/ZYcI80p0tAlBVCtL/Jo0GapTUmLmzTtQ4z0kWmZvZZzAqDgL
        yZezkHw5C8mXs5C8s4CRZRWjWGpBcW56arFRgQlybG9iBKc9LY8djLPfftA7xMjEwXiIUYKD
        WUmE10zqfrwQb0piZVVqUX58UWlOavEhRlNgwE9klhJNzgcm3rySeENTIzMzA0tTC1MzIwsl
        cd4igwfxQgLpiSWp2ampBalFMH1MHJxSDUyRniz6WZvcTh2WbFu6vtxkdq3oj3ny3Cbn3EJk
        mVbypsZf4/O7M+1zR5nzc0/HxGTlKW4rWGdJFqTIXD1kfVlq32bhw7wPD7ltif3x4+kCsQwV
        P3fjG3clWexmidTNFOpr8110hitvw72AJvVFh7bovHVL/BGjsFj72uxtvSH6F6/ZLH9Q49wo
        1v/kyUvL+MqjZ76/KzT7ryfR+3vWhuvPeUqE501a++bwjzXvpxVO+pJeGfuAOfWv1pTKEy9K
        AopUgye/d/iqrH/o7t70a54H39w3v1L+Qcp42/f9wtunfKj3qjyi/n9jcH3UqkVXv27ZY/lG
        fKXh5iCFPw9jY+b7qfu9nNsvlhfhuf+yjKGvEktxRqKhFnNRcSIAIV6pRQQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO7OE4/iDb5+1bLovr6DzWLpzefs
        Dkwel/t6mTw+b5ILYIrisklJzcksSy3St0vgyljw5yxjwTyvir8LfzI3MM617mLk5JAQMJG4
        92MNaxcjF4eQwG5GiXUHvrBDJCQlTux8zghhC0vcbzkCVfSMUeL/5E6wBJuAtsS0h7tZQWwR
        AW+J25PXs0EUzWSUmDNhNtgkTgEPifnHZoIVCQsESJxc8ZkNxGYRUJW48H8ZC4jNK2ApsWVx
        GzuELShxcuYTsDgz0HmNh7uhbHmJ7W/nMENcpCDx8+kyoJkcQIutJM7NgyoRkZjd2cY8gVFo
        FpJJs5BMmoVk0iwkLQsYWVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgSHuZbmDsbt
        qz7oHWJk4mA8xCjBwawkwmsmdT9eiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp
        2ampBalFMFkmDk6pBibXbex9vBO3vzbZ2ND9+gKXp55Qrdb8rHax79PUHsmJJseuTGg4f6Zr
        3ayjrrM0Fjz+8YFfT7N+R5H61s49l740717x7/e2mwHrLv7zndbPw7HWMky2YwHPxSC/6Ijk
        tsuNsvPl3kRtNDYp1G/Q+WOZd+hTn4i59AZbmfDmf2z8e+f+lL6dyHGNx3Zb7RRDsU9NhyPM
        J8yfr/va+W5KQ3LZzfbX8ySP/1T5zjx5If/RXaE2X2a9nzhtZbmTV/Dpq3y3HAs+dW279Ve2
        enflBsF3Obf6VPT3pjmdSbS/Nd34XB7rqyNX1xaJiSQUP/yxlm+mqHYNX6bg0p1XFGfmTL42
        M1JqvxtXE+fFq41x3+8osRRnJBpqMRcVJwIAKdx/LeICAAA=
X-CMS-MailID: 20201223043401epcas2p366d3851e134ed547922e6e7caaff1215
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222135020epcas2p1849e621559157e76a22b808e7a802400
References: <CGME20201222135020epcas2p1849e621559157e76a22b808e7a802400@epcas2p1.samsung.com>
        <1608644981-46267-1-git-send-email-ziqichen@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> As per specs, e.g, JESD220E chapter 7.2, while powering off/on the ufs
> device, RST_N signal and REF_CLK signal should be between VSS(Ground) and
> VCCQ/VCCQ2.
> 
> To flexibly control device reset line, refactor the function
> ufschd_vops_device_reset(sturct ufs_hba *hba) to ufshcd_
> vops_device_reset(sturct ufs_hba *hba, bool asserted). The new parameter
> "bool asserted" is used to separate device reset line pulling down from
> pulling up.
> 
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Ziqi Chen <ziqichen@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 32 ++++++++++++++++----------------
>  drivers/scsi/ufs/ufs-qcom.c     | 24 +++++++++++++++---------
>  drivers/scsi/ufs/ufshcd.c       | 36 +++++++++++++++++++++++++-----------
>  drivers/scsi/ufs/ufshcd.h       |  8 ++++----
>  4 files changed, 60 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-
> mediatek.c index 80618af..072f4db 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -841,27 +841,27 @@ static int ufs_mtk_link_startup_notify(struct
> ufs_hba *hba,
>  	return ret;
>  }
> 
> -static int ufs_mtk_device_reset(struct ufs_hba *hba)
> +static int ufs_mtk_device_reset(struct ufs_hba *hba, bool asserted)
>  {
>  	struct arm_smccc_res res;
> 
> -	ufs_mtk_device_reset_ctrl(0, res);
> +	if (asserted) {
> +		ufs_mtk_device_reset_ctrl(0, res);
> 
> -	/*
> -	 * The reset signal is active low. UFS devices shall detect
> -	 * more than or equal to 1us of positive or negative RST_n
> -	 * pulse width.
> -	 *
> -	 * To be on safe side, keep the reset low for at least 10us.
> -	 */
> -	usleep_range(10, 15);
> -
> -	ufs_mtk_device_reset_ctrl(1, res);
> -
> -	/* Some devices may need time to respond to rst_n */
> -	usleep_range(10000, 15000);
> +		/*
> +		 * The reset signal is active low. UFS devices shall detect
> +		 * more than or equal to 1us of positive or negative RST_n
> +		 * pulse width.
> +		 *
> +		 * To be on safe side, keep the reset low for at least 10us.
> +		 */
> +		usleep_range(10, 15);
> +	} else {
> +		ufs_mtk_device_reset_ctrl(1, res);
> 
> -	dev_info(hba->dev, "device reset done\n");
> +		/* Some devices may need time to respond to rst_n */
> +		usleep_range(10000, 15000);
> +	}
> 
>  	return 0;
>  }
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 2206b1e..fed10e5 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1406,10 +1406,11 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba
> *hba)
>  /**
>   * ufs_qcom_device_reset() - toggle the (optional) device reset line
>   * @hba: per-adapter instance
> + * @asserted: assert or deassert device reset line
>   *
>   * Toggles the (optional) reset line to reset the attached device.
>   */
> -static int ufs_qcom_device_reset(struct ufs_hba *hba)
> +static int ufs_qcom_device_reset(struct ufs_hba *hba, bool asserted)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> 
> @@ -1417,15 +1418,20 @@ static int ufs_qcom_device_reset(struct ufs_hba
> *hba)
>  	if (!host->device_reset)
>  		return -EOPNOTSUPP;
> 
> -	/*
> -	 * The UFS device shall detect reset pulses of 1us, sleep for 10us
> to
> -	 * be on the safe side.
> -	 */
> -	gpiod_set_value_cansleep(host->device_reset, 1);
> -	usleep_range(10, 15);
> +	if (asserted) {
> +		gpiod_set_value_cansleep(host->device_reset, 1);
> 
> -	gpiod_set_value_cansleep(host->device_reset, 0);
> -	usleep_range(10, 15);
> +		/*
> +		 * The UFS device shall detect reset pulses of 1us, sleep
for
> 10us to
> +		 * be on the safe side.
> +		 */
> +		usleep_range(10, 15);
> +	} else {
> +		gpiod_set_value_cansleep(host->device_reset, 0);
> +
> +		 /* Some devices may need time to respond to rst_n */
> +		usleep_range(10, 15);
> +	}
> 
>  	return 0;
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> e221add..f2daac2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -585,7 +585,13 @@ static void ufshcd_device_reset(struct ufs_hba *hba)
> {
>  	int err;
> 
> -	err = ufshcd_vops_device_reset(hba);
> +	err = ufshcd_vops_device_reset(hba, true);
> +	if (err) {
> +		dev_err(hba->dev, "asserting device reset failed: %d\n",
> err);
> +		return;
> +	}
> +
> +	err = ufshcd_vops_device_reset(hba, false);
> 
>  	if (!err) {
>  		ufshcd_set_ufs_dev_active(hba);
> @@ -593,7 +599,11 @@ static void ufshcd_device_reset(struct ufs_hba *hba)
>  			hba->wb_enabled = false;
>  			hba->wb_buf_flush_enabled = false;
>  		}
> +		dev_dbg(hba->dev, "device reset done\n");
> +	} else {
> +		dev_err(hba->dev, "deasserting device reset failed: %d\n",
> err);
>  	}
> +
>  	if (err != -EOPNOTSUPP)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);  } @@ -
> 8686,8 +8696,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  	if (ret)
>  		goto set_dev_active;
> 
> -	ufshcd_vreg_set_lpm(hba);
> -
>  disable_clks:
>  	/*
>  	 * Call vendor specific suspend callback. As these callbacks may
> access @@ -8703,6 +8711,9 @@ static int ufshcd_suspend(struct ufs_hba
*hba,
> enum ufs_pm_op pm_op)
>  	 */
>  	ufshcd_disable_irq(hba);
> 
> +	if (ufshcd_is_link_off(hba))
> +		ufshcd_vops_device_reset(hba, true);
> +
>  	ufshcd_setup_clocks(hba, false);
> 
>  	if (ufshcd_is_clkgating_allowed(hba)) { @@ -8711,6 +8722,8 @@
> static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  					hba->clk_gating.state);
>  	}
> 
> +	ufshcd_vreg_set_lpm(hba);
> +
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
>  	goto out;
> @@ -8778,18 +8791,19 @@ static int ufshcd_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  	old_link_state = hba->uic_link_state;
> 
>  	ufshcd_hba_vreg_set_hpm(hba);
> +
> +	ret = ufshcd_vreg_set_hpm(hba);
> +	if (ret)
> +		goto out;
> +
>  	/* Make sure clocks are enabled before accessing controller */
>  	ret = ufshcd_setup_clocks(hba, true);
>  	if (ret)
> -		goto out;
> +		goto disable_vreg;
> 
>  	/* enable the host irq as host controller would be active soon */
>  	ufshcd_enable_irq(hba);
> 
> -	ret = ufshcd_vreg_set_hpm(hba);
> -	if (ret)
> -		goto disable_irq_and_vops_clks;
> -
>  	/*
>  	 * Call vendor specific resume callback. As these callbacks may
> access
>  	 * vendor specific host controller register space call them when
> the @@ -8797,7 +8811,7 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	 */
>  	ret = ufshcd_vops_resume(hba, pm_op);
>  	if (ret)
> -		goto disable_vreg;
> +		goto disable_irq_and_vops_clks;
> 
>  	/* For DeepSleep, the only supported option is to have the link off
> */
>  	WARN_ON(ufshcd_is_ufs_dev_deepsleep(hba)
> && !ufshcd_is_link_off(hba)); @@ -8864,8 +8878,6 @@ static int
> ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	ufshcd_link_state_transition(hba, old_link_state, 0);
>  vendor_suspend:
>  	ufshcd_vops_suspend(hba, pm_op);
> -disable_vreg:
> -	ufshcd_vreg_set_lpm(hba);
>  disable_irq_and_vops_clks:
>  	ufshcd_disable_irq(hba);
>  	if (hba->clk_scaling.is_allowed)
> @@ -8876,6 +8888,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
>  	}
> +disable_vreg:
> +	ufshcd_vreg_set_lpm(hba);
>  out:
>  	hba->pm_op_in_progress = 0;
>  	if (ret)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 9bb5f0e..d5fbaba 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -319,7 +319,7 @@ struct ufs_pwr_mode_info {
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
>   * @phy_initialization: used to initialize phys
> - * @device_reset: called to issue a reset pulse on the UFS device
> + * @device_reset: called to assert or deassert device reset line
>   * @program_key: program or evict an inline encryption key
>   * @event_notify: called to notify important events
>   */
> @@ -350,7 +350,7 @@ struct ufs_hba_variant_ops {
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
>  	int	(*phy_initialization)(struct ufs_hba *);
> -	int	(*device_reset)(struct ufs_hba *hba);
> +	int	(*device_reset)(struct ufs_hba *hba, bool asserted);
>  	void	(*config_scaling_param)(struct ufs_hba *hba,
>  					struct devfreq_dev_profile *profile,
>  					void *data);
> @@ -1216,10 +1216,10 @@ static inline void
> ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>  		hba->vops->dbg_register_dump(hba);
>  }
> 
> -static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
> +static inline int ufshcd_vops_device_reset(struct ufs_hba *hba, bool
> +asserted)
>  {
>  	if (hba->vops && hba->vops->device_reset)
> -		return hba->vops->device_reset(hba);
> +		return hba->vops->device_reset(hba, asserted);
> 
>  	return -EOPNOTSUPP;
>  }
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project

Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

