Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA35C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 18:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3548F2184D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 18:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="P8Qwb/7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgEHSMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 14:12:35 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:43411 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgEHSMe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 14:12:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588961554; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=wPiyQjSJF8vUdRxJrjwFgYJTIXhq+dC/nAsEoueYbiA=; b=P8Qwb/7mQf4LJMQpSpqJ+bkCnTzHpDT38Ijj4qb4VEcWYoofcmIW5PLRbe6HOpun7lyUZO5O
 Rcklyc4rjHOLGERpGPhbj9P36hvD7EEte+5LJFOiJ8t8IyxMZAymZ5vMx/bKA5qUlVZ0nMEU
 pQEPP96qF/GfbSoljLFlLEc4AeE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb5a10a.7fc7670df298-smtp-out-n03;
 Fri, 08 May 2020 18:12:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 18B03C4478C; Fri,  8 May 2020 18:12:26 +0000 (UTC)
Received: from [192.168.8.176] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B44CC433D2;
        Fri,  8 May 2020 18:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0B44CC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 3/5] scsi: ufs: customize flush threshold for
 WriteBooster
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200508171513.14665-1-stanley.chu@mediatek.com>
 <20200508171513.14665-4-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <4196ff98-093e-3708-d166-a7a7c6046c57@codeaurora.org>
Date:   Fri, 8 May 2020 11:12:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508171513.14665-4-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/2020 10:15 AM, Stanley Chu wrote:
> Allow flush threshold for WriteBooster to be customizable by
> vendors. To achieve this, make the value as a variable in struct
> ufs_hba first.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 6 ++++--
>   drivers/scsi/ufs/ufshcd.h | 1 +
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cdacbe6378a1..9a0ce6550c2f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5301,8 +5301,8 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
>   			 cur_buf);
>   		return false;
>   	}
> -	/* Let it continue to flush when >60% full */
> -	if (avail_buf < UFS_WB_40_PERCENT_BUF_REMAIN)
> +	/* Let it continue to flush when available buffer exceeds threshold */
> +	if (avail_buf < hba->vps->wb_flush_threshold)
>   		return true;
>   
>   	return false;
> @@ -6839,6 +6839,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>   		if (!d_lu_wb_buf_alloc)
>   			goto wb_disabled;
>   	}
> +
Is this newline needed?

>   	return;
>   
>   wb_disabled:
> @@ -7462,6 +7463,7 @@ static const struct attribute_group *ufshcd_driver_groups[] = {
>   
>   static struct ufs_hba_variant_params ufs_hba_vps = {
>   	.hba_enable_delay_us		= 1000,
> +	.wb_flush_threshold		= UFS_WB_40_PERCENT_BUF_REMAIN,
>   	.devfreq_profile.polling_ms	= 100,
>   	.devfreq_profile.target		= ufshcd_devfreq_target,
>   	.devfreq_profile.get_dev_status	= ufshcd_devfreq_get_dev_status,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index f7bdf52ba8b0..e3dfb48e669e 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -570,6 +570,7 @@ struct ufs_hba_variant_params {
>   	struct devfreq_dev_profile devfreq_profile;
>   	struct devfreq_simple_ondemand_data ondemand_data;
>   	u16 hba_enable_delay_us;
> +	u32 wb_flush_threshold;
>   };
>   
>   /**
> 

Patch[3] & [4] may be combined into a single patch perhaps?
Patch[4] just redoes what [3] did in a different way, so might as well 
just do what patch[4] does right away.


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
