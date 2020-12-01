Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8749DC64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2263820809
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nhbWs/PT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgLAChi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 21:37:38 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:63279 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgLAChg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 21:37:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606790232; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=LuLVx8v5T+nGwlZJeawR9A4EitazVOlcd9+XnWaPHcc=; b=nhbWs/PTHrMAbfG218dPQqOxfnKgkjH0/SNfPgO/E3pa0ScE0oNKs/I2M9Fu5Aj/lkKeXSb9
 d7VdZ8wA9u9Ts460fU8r3rfOIuvw3STZNj4DmH+FAcDYXb13r8DuBz0T5b88z4eXuriqzlJ9
 6uqR+lRIgsfMpf4sJFFVSSTErRE=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fc5ac3d07535c81ba45324a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 02:36:45
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F0EC4C43466; Tue,  1 Dec 2020 02:36:44 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 01281C433ED;
        Tue,  1 Dec 2020 02:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 01281C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v3 2/2] scsi: ufs-qcom: Keep core_clk_unipro ON while link
 is active
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1606356063-38380-1-git-send-email-cang@codeaurora.org>
 <1606356063-38380-3-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <7ec66c17-2bb7-a472-6ebb-3151ba51df84@codeaurora.org>
Date:   Mon, 30 Nov 2020 18:36:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1606356063-38380-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/2020 6:01 PM, Can Guo wrote:
> If we want to disable clocks to save power but still keep the link active,
> core_clk_unipro, as same as ref_clk, should not be the one being disabled.
> 
> Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufs-qcom.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index f9d6ef3..8a7fc62 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -977,6 +977,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>   	struct platform_device *pdev = to_platform_device(dev);
>   	struct ufs_qcom_host *host;
>   	struct resource *res;
> +	struct ufs_clk_info *clki;
>   
>   	if (strlen(android_boot_dev) && strcmp(android_boot_dev, dev_name(dev)))
>   		return -ENODEV;
> @@ -1075,6 +1076,11 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>   		}
>   	}
>   
> +	list_for_each_entry(clki, &hba->clk_list_head, list) {
> +		if (!strcmp(clki->name, "core_clk_unipro"))
> +			clki->keep_link_active = true;
> +	}
> +
>   	err = ufs_qcom_init_lane_clks(host);
>   	if (err)
>   		goto out_variant_clear;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
