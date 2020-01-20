Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DE8C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C7ED22525
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="SqlpaMSs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgATUlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 15:41:22 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:47822 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATUlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 15:41:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579552881; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=IYEikF8EGuCx8OwTVwuaWLgMWhiZl2nJ8jeeoNcZUDE=; b=SqlpaMSs2CaGLJJvJBtDI/CC7y0qeb+LxD0SY2CNJfyqGRfBvAQovzEMttTjx0vy0XV3d8TQ
 NL0+breZkn4flz4jr2z+ZUNcxmI4ybiew1Jy9VGRVELfiPVku4lx9SavszPCsDRHxvQqe5d4
 UABc+9j3N/FKkPRmUDPrImmusbU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e261066.7f4ec985cfb8-smtp-out-n02;
 Mon, 20 Jan 2020 20:41:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 544A1C447A6; Mon, 20 Jan 2020 20:41:08 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 744C7C433CB;
        Mon, 20 Jan 2020 20:41:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 744C7C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 5/8] scsi: ufs: Inline two functions into their callers
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200120130820.1737-1-huobean@gmail.com>
 <20200120130820.1737-6-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <44e68000-a5b3-b368-d76f-416d412e1a87@codeaurora.org>
Date:   Mon, 20 Jan 2020 12:41:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120130820.1737-6-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/20/2020 5:08 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Delete ufshcd_read_power_desc() and ufshcd_read_device_desc(), directly
> inline ufshcd_read_desc() into its callers.
> 
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---

LGTM.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
>   1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5dfe760f2786..3d3289bb3cad 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3146,17 +3146,6 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
>   	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
>   }
>   
> -static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
> -					 u8 *buf,
> -					 u32 size)
> -{
> -	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
> -}
> -
> -static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
> -{
> -	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
> -}
>   
>   /**
>    * struct uc_string_id - unicode string
> @@ -6493,7 +6482,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>   	if (!desc_buf)
>   		return;
>   
> -	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
> +	ret = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0,
> +			desc_buf, buff_len);
>   	if (ret) {
>   		dev_err(hba->dev,
>   			"%s: Failed reading power descriptor.len = %d ret = %d",
> @@ -6599,7 +6589,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   		goto out;
>   	}
>   
> -	err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
> +	err = ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, desc_buf,
> +			hba->desc_size.dev_desc);
>   	if (err) {
>   		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
>   			__func__, err);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
