Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93800C35242
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB1E2072C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KRmGVkri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390692AbgAXSEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 13:04:22 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:25509 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390331AbgAXSEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 13:04:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579889061; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=416kvB4U9ycPEsCjzKp6t1KyF47gVJDFFssMCwP38sU=; b=KRmGVkriFOXJuy+EHaiKbA8uWw9Yz6gtD5Qk6v87X/LB1leUHzWN8u03CmVD1UX9IIrRdxC9
 SnCoWa41suCJPD0k4paN0Bz7UkYFk8t7eBPhOvVFdeZiYjwQuDhyVT8zRHn3KtbmAr3S9IZe
 FSNV9OALp2MCbwQ+QSWh0R33qQQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2b319d.7f93eb3337a0-smtp-out-n03;
 Fri, 24 Jan 2020 18:04:13 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39907C4479C; Fri, 24 Jan 2020 18:04:12 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D98B8C43383;
        Fri, 24 Jan 2020 18:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D98B8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 7/8] scsi: ufs-qcom: Delay specific time before gate
 ref clk
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Andy Gross <agross@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-8-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <e95f2818-041f-2df9-e86c-f433e45fe2df@codeaurora.org>
Date:   Fri, 24 Jan 2020 10:04:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-8-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/2020 11:25 PM, Can Guo wrote:
> After enter hibern8, as UFS JEDEC ver 3.0 requires, a specific gating wait
> time is required before disable the device reference clock. If it is not
> specified, use the old delay.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufs-qcom.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 85d7c17..3b5b2d9 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -833,6 +833,8 @@ static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
>   
>   static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>   {
> +	unsigned long gating_wait;
> +
>   	if (host->dev_ref_clk_ctrl_mmio &&
>   	    (enable ^ host->is_dev_ref_clk_enabled)) {
>   		u32 temp = readl_relaxed(host->dev_ref_clk_ctrl_mmio);
> @@ -845,11 +847,16 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>   		/*
>   		 * If we are here to disable this clock it might be immediately
>   		 * after entering into hibern8 in which case we need to make
> -		 * sure that device ref_clk is active at least 1us after the
> +		 * sure that device ref_clk is active for specific time after
>   		 * hibern8 enter.
>   		 */
> -		if (!enable)
> -			udelay(1);
> +		if (!enable) {
> +			gating_wait = host->hba->dev_info.clk_gating_wait_us;
> +			if (!gating_wait)
> +				udelay(1);
> +			else
> +				usleep_range(gating_wait, gating_wait + 10);
> +		}
>   
>   		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
>   
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
