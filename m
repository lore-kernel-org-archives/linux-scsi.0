Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5323C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B8D214AF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:59:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JFhE4Az/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMS7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:59:18 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:61639 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728633AbgAMS7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 13:59:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578941957; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rEVhNoA+SMCklIOXL2qRZ8K89XUanuaNJQR/wOG0Dcw=;
 b=JFhE4Az/DREJCkY51T/0CYxe1QMgLjzjFeeK5Ii5h9ayfV1MLqWUQjfQ2x1XwKafATwmPyYt
 UxixPr1bHLtkRfGpZEU4Md9bwYNjruoVGC2dJY5yFaRj15FFtxWeBiU7HuFbs9uz+7Cl33d7
 o7BioYIbIMDOqpvfBkNTPQq7FGw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1cbdf9.7f3cda1446c0-smtp-out-n02;
 Mon, 13 Jan 2020 18:59:05 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BE30AC447A1; Mon, 13 Jan 2020 18:59:04 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 758BBC433CB;
        Mon, 13 Jan 2020 18:59:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 10:59:03 -0800
From:   asutoshd@codeaurora.org
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 2/3] scsi: ufs: add device reset history for vendor
 implementations
In-Reply-To: <1578147968-30938-3-git-send-email-stanley.chu@mediatek.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
 <1578147968-30938-3-git-send-email-stanley.chu@mediatek.com>
Message-ID: <20ed97a2333ff27d5901c373579f710a@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-04 06:26, Stanley Chu wrote:
> Device reset history shall be also added for vendor's device
> reset variant operation implementation.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  drivers/scsi/ufs/ufshcd.h | 6 +++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bae43da00bb6..29e3d50aabfb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4346,13 +4346,14 @@ static inline int
> ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
>  	return ufshcd_disable_tx_lcc(hba, true);
>  }
> 
> -static void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
> -				   u32 reg)
> +void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
> +			    u32 reg)
>  {
>  	reg_hist->reg[reg_hist->pos] = reg;
>  	reg_hist->tstamp[reg_hist->pos] = ktime_get();
>  	reg_hist->pos = (reg_hist->pos + 1) % UFS_ERR_REG_HIST_LENGTH;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_update_reg_hist);
> 
>  /**
>   * ufshcd_link_startup - Initialize unipro link startup
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e05cafddc87b..de1be6a862b0 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -805,6 +805,8 @@ int ufshcd_wait_for_register(struct ufs_hba *hba,
> u32 reg, u32 mask,
>  				u32 val, unsigned long interval_us,
>  				unsigned long timeout_ms, bool can_sleep);
>  void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk 
> *refclk);
> +void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
> +			    u32 reg);
> 
>  static inline void check_upiu_size(void)
>  {
> @@ -1083,8 +1085,10 @@ static inline void
> ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
> 
>  static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
>  {
> -	if (hba->vops && hba->vops->device_reset)
> +	if (hba->vops && hba->vops->device_reset) {
>  		hba->vops->device_reset(hba);
> +		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
> +	}
>  }
> 
>  extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
