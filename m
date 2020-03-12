Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B2EC10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD57206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JoRMarXf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgCLRd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:33:58 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:50754 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgCLRd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:33:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584034437; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Yv5Z2WSkUNGiz0RnTA13WsE0rkZ/Ii3R3mKkEmh3yWY=; b=JoRMarXfiedqXYSadY6lEpX3T6RxKOJgeI5aWLDlXjHkZJYM42MAhwIuhtyZQnp3UzpcSQLm
 CKtZNwwFMcyDxfRi+xEqwanH0STyBpAOY1cJrYJe5Ovl5UlcCoMCDLXQxlObMyZsCC9dJhnZ
 2corSk7bpYdLSbBzOUDg4ozDzyg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6a727c.7fde6dfef8b8-smtp-out-n02;
 Thu, 12 Mar 2020 17:33:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6CB7BC43637; Thu, 12 Mar 2020 17:33:48 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68064C433D2;
        Thu, 12 Mar 2020 17:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68064C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 2/8] scsi: ufs: remove init_prefetch_data in struct
 ufs_hba
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200312110908.14895-1-stanley.chu@mediatek.com>
 <20200312110908.14895-3-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <2e958801-81f0-d650-cad3-ada0b04ac972@codeaurora.org>
Date:   Thu, 12 Mar 2020 10:33:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312110908.14895-3-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/12/2020 4:09 AM, Stanley Chu wrote:
> Struct init_prefetch_data currently is used privately in
> ufshcd_init_icc_levels(), thus it can be removed from struct ufs_hba.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>   drivers/scsi/ufs/ufshcd.c | 15 ++++++---------
>   drivers/scsi/ufs/ufshcd.h | 11 -----------
>   2 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 314e808b0d4e..b4988b9ee36c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6501,6 +6501,7 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>   {
>   	int ret;
>   	int buff_len = hba->desc_size.pwr_desc;
> +	u32 icc_level;
>   	u8 *desc_buf;
>   
>   	desc_buf = kmalloc(buff_len, GFP_KERNEL);
> @@ -6516,21 +6517,17 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
>   		goto out;
>   	}
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
>   	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> -		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> -		&hba->init_prefetch_data.icc_level);
> +		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
>   
>   	if (ret)
>   		dev_err(hba->dev,
>   			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
> -			__func__, hba->init_prefetch_data.icc_level , ret);
> -
> +			__func__, icc_level, ret);
>   out:
>   	kfree(desc_buf);
>   }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 5c10777154fc..5cf79d2319a6 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -402,15 +402,6 @@ struct ufs_clk_scaling {
>   	bool is_suspended;
>   };
>   
> -/**
> - * struct ufs_init_prefetch - contains data that is pre-fetched once during
> - * initialization
> - * @icc_level: icc level which was read during initialization
> - */
> -struct ufs_init_prefetch {
> -	u32 icc_level;
> -};
> -
>   #define UFS_ERR_REG_HIST_LENGTH 8
>   /**
>    * struct ufs_err_reg_hist - keeps history of errors
> @@ -541,7 +532,6 @@ enum ufshcd_quirks {
>    * @intr_mask: Interrupt Mask Bits
>    * @ee_ctrl_mask: Exception event control mask
>    * @is_powered: flag to check if HBA is powered
> - * @init_prefetch_data: data pre-fetched during initialization
>    * @eh_work: Worker to handle UFS errors that require s/w attention
>    * @eeh_work: Worker to handle exception events
>    * @errors: HBA errors
> @@ -627,7 +617,6 @@ struct ufs_hba {
>   	u32 intr_mask;
>   	u16 ee_ctrl_mask;
>   	bool is_powered;
> -	struct ufs_init_prefetch init_prefetch_data;
>   
>   	/* Work Queues */
>   	struct work_struct eh_work;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
