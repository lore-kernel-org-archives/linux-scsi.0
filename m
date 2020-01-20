Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA29C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E8722525
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="uMnCxr1T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATUnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 15:43:19 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:47822 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATUnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 15:43:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579552998; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=iOzImZJtvhbDuREZ0Gj4mOqNfSlQTYSZX6TMEEe9hBk=; b=uMnCxr1TSQ38/TuIyY7LtApWiomzTgjhbEQE4DMnWsPLD+dqfVu4epEGdGMzI/8i4qJex0GW
 cWr7pnn/nKYg416PIX1OZmuEUVtODtPm2sWjxS+4TetiBrNYxYJZ4rBpEantSSk97MuuWge6
 UjW7vpqPp5fb0m5Wjof7rihcNjM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2610df.7f0ae65c36f8-smtp-out-n01;
 Mon, 20 Jan 2020 20:43:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 682CFC447A2; Mon, 20 Jan 2020 20:43:11 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09266C433CB;
        Mon, 20 Jan 2020 20:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09266C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 6/8] scsi: ufs: Delete is_init_prefetch from struct
 ufs_hba
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200120130820.1737-1-huobean@gmail.com>
 <20200120130820.1737-7-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <34128bac-3811-16c1-ea6a-57c52cd70982@codeaurora.org>
Date:   Mon, 20 Jan 2020 12:43:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120130820.1737-7-huobean@gmail.com>
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
> Without variable is_init_prefetch, the current logic can guarantee
> ufshcd_init_icc_levels() will execute only once, delete it now.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 5 +----
>   drivers/scsi/ufs/ufshcd.h | 2 --
>   2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3d3289bb3cad..0c859f239d1c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6967,8 +6967,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>   {
>   	int ret;
>   
> -	if (!hba->is_init_prefetch)
> -		ufshcd_init_icc_levels(hba);
> +	ufshcd_init_icc_levels(hba);
>   
>   	/* Add required well known logical units to scsi mid layer */
>   	ret = ufshcd_scsi_add_wlus(hba);
> @@ -6994,8 +6993,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>   	scsi_scan_host(hba->host);
>   	pm_runtime_put_sync(hba->dev);
>   
> -	if (!hba->is_init_prefetch)
> -		hba->is_init_prefetch = true;
>   out:
>   	return ret;
>   }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 32b6714f25a5..5c65d9fdeb14 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -501,7 +501,6 @@ struct ufs_stats {
>    * @intr_mask: Interrupt Mask Bits
>    * @ee_ctrl_mask: Exception event control mask
>    * @is_powered: flag to check if HBA is powered
> - * @is_init_prefetch: flag to check if data was pre-fetched in initialization
>    * @init_prefetch_data: data pre-fetched during initialization
>    * @eh_work: Worker to handle UFS errors that require s/w attention
>    * @eeh_work: Worker to handle exception events
> @@ -652,7 +651,6 @@ struct ufs_hba {
>   	u32 intr_mask;
>   	u16 ee_ctrl_mask;
>   	bool is_powered;
> -	bool is_init_prefetch;
>   	struct ufs_init_prefetch init_prefetch_data;
>   
>   	/* Work Queues */
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
