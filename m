Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4DEC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DEF22525
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tnN7AwmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATUtT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 15:49:19 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:23165 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgATUtT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 15:49:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579553358; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=kcD4cIT6TO+GhmHS0MBwC7/uH5JRJvAdsZCjW78zRow=; b=tnN7AwmYaMylaH8bNS/osu3p/JmpqzBQCVb7Nj6PeWseDlACmpZEze4Jc3abkPxK/qMzbX09
 dpCMKovgXlbb9XsxVC6Z4qkJsVjmh7Vyb3yjN508oj/QqSNl1xgfTOvIHn+Ck/a16n2nb5PZ
 63f/mGP/oKy1U0sMQzZ/5rqebE4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e26124c.7f522c449378-smtp-out-n02;
 Mon, 20 Jan 2020 20:49:16 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8D3E3C4479F; Mon, 20 Jan 2020 20:49:15 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92D2AC43383;
        Mon, 20 Jan 2020 20:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 92D2AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/3] scsi: ufs: export some functions for vendor usage
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200117035108.19699-1-stanley.chu@mediatek.com>
 <20200117035108.19699-3-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <4dc0cb58-13f6-0678-dcf2-6b0394200157@codeaurora.org>
Date:   Mon, 20 Jan 2020 12:49:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117035108.19699-3-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 7:51 PM, Stanley Chu wrote:
> Export below functions for vendor usage,
> 
> int ufshcd_hba_enable(struct ufs_hba *hba);
> int ufshcd_make_hba_operational(struct ufs_hba *hba);
> int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

LGTM.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 11 +++++++----
>   drivers/scsi/ufs/ufshcd.h |  3 +++
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bea036ab189a..1168baf358ea 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -250,7 +250,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
>   static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>   				 bool skip_ref_clk);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> -static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>   static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>   static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>   static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
> @@ -3865,7 +3864,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> -static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
> +int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   {
>   	struct uic_command uic_cmd = {0};
>   	int ret;
> @@ -3891,6 +3890,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>   
>   	return ret;
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
>   
>   void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>   {
> @@ -4162,7 +4162,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
>    *
>    * Returns 0 on success, non-zero value on failure
>    */
> -static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> +int ufshcd_make_hba_operational(struct ufs_hba *hba)
>   {
>   	int err = 0;
>   	u32 reg;
> @@ -4208,6 +4208,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>   out:
>   	return err;
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
>   
>   /**
>    * ufshcd_hba_stop - Send controller to reset state
> @@ -4285,7 +4286,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>   	return 0;
>   }
>   
> -static int ufshcd_hba_enable(struct ufs_hba *hba)
> +int ufshcd_hba_enable(struct ufs_hba *hba)
>   {
>   	int ret;
>   
> @@ -4310,6 +4311,8 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>   
>   	return ret;
>   }
> +EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
> +
>   static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
>   {
>   	int tx_lanes, i, err = 0;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b1a1c65be8b1..fca372d98495 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -799,8 +799,11 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
>   
>   int ufshcd_alloc_host(struct device *, struct ufs_hba **);
>   void ufshcd_dealloc_host(struct ufs_hba *);
> +int ufshcd_hba_enable(struct ufs_hba *hba);
>   int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
> +int ufshcd_make_hba_operational(struct ufs_hba *hba);
>   void ufshcd_remove(struct ufs_hba *);
> +int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>   int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>   				u32 val, unsigned long interval_us,
>   				unsigned long timeout_ms, bool can_sleep);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
