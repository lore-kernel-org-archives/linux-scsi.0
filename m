Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880BBC2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61FB52077C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:07:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="CEDiPIQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391184AbgAXSHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 13:07:39 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:44151 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390947AbgAXSHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 13:07:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579889258; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=FsdPjpNmzNHjRlbx8RXh1YzktL6/JfX/33KXX8v4t8Y=; b=CEDiPIQ3sOppK0cjWGljCcVrfGC2T8H8iN0QXevL291sUt3ke76rrT9gUjt0uzhYVyWDoQOL
 maFMXZk9VqEzebEsSw/7mHqSig9jKKZGu8vF31w7vYllbFqFsO1CbsOJK1kwzpDbY9fpKbsW
 AWVc1pdkH4PXngYJDXqvSvmyMfc=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2b325d.7efdc3f4bb90-smtp-out-n01;
 Fri, 24 Jan 2020 18:07:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D62C1C4479C; Fri, 24 Jan 2020 18:07:24 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A00DC433A2;
        Fri, 24 Jan 2020 18:07:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A00DC433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 5/8] scsi: ufs: Fix ufshcd_hold() caused scheduling
 while atomic
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-6-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <4aaf60bc-b398-67a1-7ed5-e0571f30bc95@codeaurora.org>
Date:   Fri, 24 Jan 2020 10:07:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-6-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/2020 11:25 PM, Can Guo wrote:
> The async version of ufshcd_hold(async == true), which is only called
> in queuecommand path as for now, is expected to work in atomic context,
> thus it should not sleep or schedule out. When it runs into the condition
> that clocks are ON but link is still in hibern8 state, it should bail out
> without flushing the clock ungate work.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4dfd705..c316a07 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1542,6 +1542,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>   		 */
>   		if (ufshcd_can_hibern8_during_gating(hba) &&
>   		    ufshcd_is_link_hibern8(hba)) {
> +			if (async) {
> +				rc = -EAGAIN;
> +				hba->clk_gating.active_reqs--;
> +				break;
> +			}
>   			spin_unlock_irqrestore(hba->host->host_lock, flags);
>   			flush_work(&hba->clk_gating.ungate_work);
>   			spin_lock_irqsave(hba->host->host_lock, flags);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
