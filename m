Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032DAC18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C958420575
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="qB78c0TI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgCPGZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:25:39 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:25485 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729455AbgCPGZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Mar 2020 02:25:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584339938; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UyuhZmeVdghEkFGq1LyGqfP9NwpUlzrusHvbYNXKk6I=;
 b=qB78c0TI+WtNi/V79rtvbzGARUPMGxbGtKG0+Haf/9ix8qKWJt8I5CpT45LsRrFQWeXafcw6
 GqNWoy30C38MH/bsDYaxMIwuPNbN8slEUerEgKQvjs5qjgVQM9pELK+BgmmXODd6xgc/Lv3A
 RsHXIQMtVPNYTwqkt62zERchFBE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6f1bde.7f142f8219d0-smtp-out-n01;
 Mon, 16 Mar 2020 06:25:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E502CC43637; Mon, 16 Mar 2020 06:25:32 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83A43C433CB;
        Mon, 16 Mar 2020 06:25:31 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Mar 2020 14:25:31 +0800
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
Subject: Re: [PATCH v5 2/8] scsi: ufs: remove init_prefetch_data in struct
 ufs_hba
In-Reply-To: <20200316034218.11914-3-stanley.chu@mediatek.com>
References: <20200316034218.11914-1-stanley.chu@mediatek.com>
 <20200316034218.11914-3-stanley.chu@mediatek.com>
Message-ID: <51fde835f4f03fcca6e83ba6d3579f2e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-16 11:42, Stanley Chu wrote:
> Struct init_prefetch_data currently is used privately in
> ufshcd_init_icc_levels(), thus it can be removed from struct ufs_hba.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Hi Stanley,

Earlier, I have one similar patch for this, but it does more than this.
Please check the mail I just sent.

Thanks,
Can Guo.

> ---
>  drivers/scsi/ufs/ufshcd.c | 15 ++++++---------
>  drivers/scsi/ufs/ufshcd.h | 11 -----------
>  2 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 314e808b0d4e..b4988b9ee36c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6501,6 +6501,7 @@ static void ufshcd_init_icc_levels(struct ufs_hba 
> *hba)
>  {
>  	int ret;
>  	int buff_len = hba->desc_size.pwr_desc;
> +	u32 icc_level;
>  	u8 *desc_buf;
> 
>  	desc_buf = kmalloc(buff_len, GFP_KERNEL);
> @@ -6516,21 +6517,17 @@ static void ufshcd_init_icc_levels(struct 
> ufs_hba *hba)
>  		goto out;
>  	}
> 
> -	hba->init_prefetch_data.icc_level =
> -			ufshcd_find_max_sup_active_icc_level(hba,
> -			desc_buf, buff_len);
> -	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
> -			__func__, hba->init_prefetch_data.icc_level);
> +	icc_level =
> +		ufshcd_find_max_sup_active_icc_level(hba, desc_buf, buff_len);
> +	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",	__func__, icc_level);
> 
>  	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> -		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> -		&hba->init_prefetch_data.icc_level);
> +		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
> 
>  	if (ret)
>  		dev_err(hba->dev,
>  			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
> -			__func__, hba->init_prefetch_data.icc_level , ret);
> -
> +			__func__, icc_level, ret);
>  out:
>  	kfree(desc_buf);
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 5c10777154fc..5cf79d2319a6 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -402,15 +402,6 @@ struct ufs_clk_scaling {
>  	bool is_suspended;
>  };
> 
> -/**
> - * struct ufs_init_prefetch - contains data that is pre-fetched once 
> during
> - * initialization
> - * @icc_level: icc level which was read during initialization
> - */
> -struct ufs_init_prefetch {
> -	u32 icc_level;
> -};
> -
>  #define UFS_ERR_REG_HIST_LENGTH 8
>  /**
>   * struct ufs_err_reg_hist - keeps history of errors
> @@ -541,7 +532,6 @@ enum ufshcd_quirks {
>   * @intr_mask: Interrupt Mask Bits
>   * @ee_ctrl_mask: Exception event control mask
>   * @is_powered: flag to check if HBA is powered
> - * @init_prefetch_data: data pre-fetched during initialization
>   * @eh_work: Worker to handle UFS errors that require s/w attention
>   * @eeh_work: Worker to handle exception events
>   * @errors: HBA errors
> @@ -627,7 +617,6 @@ struct ufs_hba {
>  	u32 intr_mask;
>  	u16 ee_ctrl_mask;
>  	bool is_powered;
> -	struct ufs_init_prefetch init_prefetch_data;
> 
>  	/* Work Queues */
>  	struct work_struct eh_work;
