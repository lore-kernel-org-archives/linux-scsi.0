Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F8EC63777
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 22:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2034920725
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 22:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="S1nqbvv5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgK3Wzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:55:52 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:38296 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbgK3Wzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 17:55:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606776925; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=zDbLka9uUrfbZFvpBNQIhZzv3iWnZaNysnzWiwAqdzY=; b=S1nqbvv5Ru+9gePjUnEq3Xw9MdLLi/sT+zpnBMpYxWdt1V7c7FvSuerQs6ymhM2UEWWUIUKF
 TwnJqc9teg8y8VMxclEW6CoLfC5/mhmQYM2mU3NM/ZigBr3PGqm/gXqhYqb2U+EA9yrhZXL2
 i8WdtKyn91n4ThnO4guC3Dz76Cw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fc5783f0f9adc18c7fdbb96 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 30 Nov 2020 22:54:55
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DFAB4C43465; Mon, 30 Nov 2020 22:54:54 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4516C433C6;
        Mon, 30 Nov 2020 22:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4516C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH 1/1] scsi: ufs: Remove scale down gear hard code
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ce5e6132-8284-c2c5-3eaa-78d400763534@codeaurora.org>
Date:   Mon, 30 Nov 2020 14:54:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/2020 5:58 PM, Can Guo wrote:
> Instead of making the scale down gear a hard code, make it a member of
> ufs_clk_scaling struct.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>   drivers/scsi/ufs/ufshcd.h |  2 ++
>   2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 44254c9..1789df3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1100,7 +1100,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>    */
>   static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>   {
> -	#define UFS_MIN_GEAR_TO_SCALE_DOWN	UFS_HS_G1
>   	int ret = 0;
>   	struct ufs_pa_layer_attr new_pwr_info;
>   
> @@ -1111,16 +1110,16 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>   		memcpy(&new_pwr_info, &hba->pwr_info,
>   		       sizeof(struct ufs_pa_layer_attr));
>   
> -		if (hba->pwr_info.gear_tx > UFS_MIN_GEAR_TO_SCALE_DOWN
> -		    || hba->pwr_info.gear_rx > UFS_MIN_GEAR_TO_SCALE_DOWN) {
> +		if (hba->pwr_info.gear_tx > hba->clk_scaling.min_gear ||
> +		    hba->pwr_info.gear_rx > hba->clk_scaling.min_gear) {
>   			/* save the current power mode */
>   			memcpy(&hba->clk_scaling.saved_pwr_info.info,
>   				&hba->pwr_info,
>   				sizeof(struct ufs_pa_layer_attr));
>   
>   			/* scale down gear */
> -			new_pwr_info.gear_tx = UFS_MIN_GEAR_TO_SCALE_DOWN;
> -			new_pwr_info.gear_rx = UFS_MIN_GEAR_TO_SCALE_DOWN;
> +			new_pwr_info.gear_tx = hba->clk_scaling.min_gear;
> +			new_pwr_info.gear_rx = hba->clk_scaling.min_gear;
>   		}
>   	}
>   
> @@ -1824,6 +1823,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
>   	if (!ufshcd_is_clkscaling_supported(hba))
>   		return;
>   
> +	if (!hba->clk_scaling.min_gear)
> +		hba->clk_scaling.min_gear = UFS_HS_G1;
> +
>   	INIT_WORK(&hba->clk_scaling.suspend_work,
>   		  ufshcd_clk_scaling_suspend_work);
>   	INIT_WORK(&hba->clk_scaling.resume_work,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6f0f2d4..bdab23e 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -385,6 +385,7 @@ struct ufs_saved_pwr_info {
>    * @workq: workqueue to schedule devfreq suspend/resume work
>    * @suspend_work: worker to suspend devfreq
>    * @resume_work: worker to resume devfreq
> + * @min_gear: lowest HS gear to scale down to
>    * @is_allowed: tracks if scaling is currently allowed or not
>    * @is_busy_started: tracks if busy period has started or not
>    * @is_suspended: tracks if devfreq is suspended or not
> @@ -399,6 +400,7 @@ struct ufs_clk_scaling {
>   	struct workqueue_struct *workq;
>   	struct work_struct suspend_work;
>   	struct work_struct resume_work;
> +	u32 min_gear;
>   	bool is_allowed;
>   	bool is_busy_started;
>   	bool is_suspended;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
