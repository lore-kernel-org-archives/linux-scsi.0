Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61437C0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220B02071C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KQmPVVAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgCPI5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:57:11 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:36208 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730152AbgCPI5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Mar 2020 04:57:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584349029; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ijq3uor9SMJb3ExZBsPo87hwudJNjl8YhdOh+sCNnWA=;
 b=KQmPVVAkFqnuXQR1/vIqhLmiYOQOlpWfxKG0/ErcyD+/PTo4hwZyiDa2wpB8e3LAzsDwFeH+
 XF5wCMxZu+ioXaF1O2BEqdDb31/wO9M6SFZvd1Rf71MpBi6XmH51I8AKAjoFPsQYRyIgcYoJ
 lP3Z5RNx5jFxx2Rve0MX1Y2JxbE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6f3f56.7fe344735f80-smtp-out-n04;
 Mon, 16 Mar 2020 08:56:54 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6E05EC4478F; Mon, 16 Mar 2020 08:56:52 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37B92C433CB;
        Mon, 16 Mar 2020 08:56:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Mar 2020 16:56:51 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.peter~sen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v6 3/7] scsi: ufs: introduce common delay function
In-Reply-To: <20200316085303.20350-4-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
 <20200316085303.20350-4-stanley.chu@mediatek.com>
Message-ID: <19f7e050d992c67e363d6d582393c5a0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-16 16:52, Stanley Chu wrote:
> Introduce common delay function to collect all delay requirements
> to simplify driver and take choices of udelay and usleep_range into
> consideration.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 27 ++++++++++++++++++---------
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 314e808b0d4e..9fea346f7d22 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -597,6 +597,18 @@ static void ufshcd_print_pwr_info(struct ufs_hba 
> *hba)
>  		 hba->pwr_info.hs_rate);
>  }
> 
> +void ufshcd_wait_us(unsigned long us, unsigned long tolerance, bool 
> can_sleep)
> +{
> +	if (!us)
> +		return;
> +
> +	if (us < 10 || !can_sleep)
> +		udelay(us);
> +	else
> +		usleep_range(us, us + tolerance);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_wait_us);
> +
>  /*
>   * ufshcd_wait_for_register - wait for register value to change
>   * @hba - per-adapter interface
> @@ -620,10 +632,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba,
> u32 reg, u32 mask,
>  	val = val & mask;
> 
>  	while ((ufshcd_readl(hba, reg) & mask) != val) {
> -		if (can_sleep)
> -			usleep_range(interval_us, interval_us + 50);
> -		else
> -			udelay(interval_us);
> +		ufshcd_wait_us(interval_us, 50, can_sleep);
>  		if (time_after(jiffies, timeout)) {
>  			if ((ufshcd_readl(hba, reg) & mask) != val)
>  				err = -ETIMEDOUT;
> @@ -3565,7 +3574,7 @@ static inline void
> ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
>  	}
> 
>  	/* allow sleep for extra 50us if needed */
> -	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
> +	ufshcd_wait_us(min_sleep_time_us, 50, true);
>  }
> 
>  /**
> @@ -4289,7 +4298,7 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
>  	 * instruction might be read back.
>  	 * This delay can be changed based on the controller.
>  	 */
> -	usleep_range(1000, 1100);
> +	ufshcd_wait_us(1000, 100, true);
> 
>  	/* wait for the host controller to complete initialization */
>  	retry = 10;
> @@ -4301,7 +4310,7 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
>  				"Controller enable failed\n");
>  			return -EIO;
>  		}
> -		usleep_range(5000, 5100);
> +		ufshcd_wait_us(5000, 100, true);
>  	}
> 
>  	/* enable UIC related interrupts */
> @@ -6224,7 +6233,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  			if (reg & (1 << tag)) {
>  				/* sleep for max. 200us to stabilize */
> -				usleep_range(100, 200);
> +				ufshcd_wait_us(100, 100, true);
>  				continue;
>  			}
>  			/* command completed already */
> @@ -7786,7 +7795,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba 
> *hba)
>  	 */
>  	if (!ufshcd_is_link_active(hba) &&
>  	    hba->dev_quirks & UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM)
> -		usleep_range(2000, 2100);
> +		ufshcd_wait_us(2000, 100, true);
> 
>  	/*
>  	 * If UFS device is either in UFS_Sleep turn off VCC rail to save 
> some
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 52425371082a..842f0223f5e5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -792,6 +792,7 @@ int ufshcd_init(struct ufs_hba * , void __iomem *
> , unsigned int);
>  int ufshcd_make_hba_operational(struct ufs_hba *hba);
>  void ufshcd_remove(struct ufs_hba *);
>  int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
> +void ufshcd_wait_us(unsigned long us, unsigned long tolerance, bool 
> can_sleep);
>  int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>  				u32 val, unsigned long interval_us,
>  				unsigned long timeout_ms, bool can_sleep);
