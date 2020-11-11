Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274C8C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 18:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB1D2072C
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 18:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="I0GdUxy2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgKKSJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 13:09:04 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:29647 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgKKSJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 13:09:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605118143; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=L/7UfRWhvf87d6KJzTiNV4kTZAtKUk11tsijaAnZsFg=; b=I0GdUxy2Oq73SgpRL1ZCh2uwujb7T0ZqU2YDpJ9BFQdSu5P5bNoPY552XfXktGnwHka0+JlL
 6658elKsQA0vfaXHYd1jdDNuVozSCPDGOem3BcjYsKEGnaedbnyqECY26RXsGQrj/SMy1nNh
 9XD1HYSDlXV251lJVuL+8Iej5KM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fac207c0d87d63775a26c7f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 11 Nov 2020 17:33:48
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 38205C43385; Wed, 11 Nov 2020 17:33:47 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4491EC433C6;
        Wed, 11 Nov 2020 17:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4491EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 1/2] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
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
        open list <linux-kernel@vger.kernel.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
 <1604384682-15837-2-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ddefc6a0-6a70-692b-b9bc-d3a290273f72@codeaurora.org>
Date:   Wed, 11 Nov 2020 09:33:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1604384682-15837-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/2020 10:24 PM, Can Guo wrote:
> The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
> decreased back in ufshcd_ungate_work() in a paired way. However, if
> specific ufshcd_hold/release sequences are met, it is possible that
> scsi_block_reqs_cnt is increased twice but only one ungate work is
> queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() and
> ufshcd_ungate_work() in a paired way, increase it only if queue_work()
> returns true.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 847f355..efa7d86 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1634,12 +1634,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>   		 */
>   		/* fallthrough */
>   	case CLKS_OFF:
> -		ufshcd_scsi_block_requests(hba);
>   		hba->clk_gating.state = REQ_CLKS_ON;
>   		trace_ufshcd_clk_gating(dev_name(hba->dev),
>   					hba->clk_gating.state);
> -		queue_work(hba->clk_gating.clk_gating_workq,
> -			   &hba->clk_gating.ungate_work);
> +		if (queue_work(hba->clk_gating.clk_gating_workq,
> +			       &hba->clk_gating.ungate_work))
> +			ufshcd_scsi_block_requests(hba);
>   		/*
>   		 * fall through to check if we should wait for this
>   		 * work to be done or not.
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
