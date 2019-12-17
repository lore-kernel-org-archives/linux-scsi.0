Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84393C2D0CD
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 23:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F4621582
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 23:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="pEKyMxys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfLQXZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 18:25:33 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:46521 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbfLQXZc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 18:25:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576625132; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=YJEwly1+ltZDuvrkRrwDOT3yLn4EXIUPFyMApEtgGuc=; b=pEKyMxysmfBKyQC9dZAmvgCV3lBjsLFBWUUl5hADHxfcsLWvPsT7hbGbpPR0ZE0svKnyMwCa
 ZKod/Kol6gplkYZ0XeW+SQcvGU8220RnPqCJvehC6T6LRd4tz8E73bdtH7wSrb/HR1+Sj6am
 VaLLEB0kbVKb305dgl1OjgFADr8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df963eb.7fefd4384a08-smtp-out-n02;
 Tue, 17 Dec 2019 23:25:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A9800C447A3; Tue, 17 Dec 2019 23:25:29 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 480D5C433CB;
        Tue, 17 Dec 2019 23:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 480D5C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/2] scsi: ufs: disable interrupt during clock-gating
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
References: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
 <1575721321-8071-3-git-send-email-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <a36d111e-ef7f-9f9b-6f6a-692a9980103a@codeaurora.org>
Date:   Tue, 17 Dec 2019 15:25:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1575721321-8071-3-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/2019 4:22 AM, Stanley Chu wrote:
> Similar to suspend, ufshcd interrupt can be disabled since
> there won't be any host controller transaction expected till
> clocks ungated.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f80bd4e811cb..5de105e82c32 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1490,6 +1490,8 @@ static void ufshcd_ungate_work(struct work_struct *work)
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	ufshcd_setup_clocks(hba, true);
>   
> +	ufshcd_enable_irq(hba);
> +
>   	/* Exit from hibern8 */
>   	if (ufshcd_can_hibern8_during_gating(hba)) {
>   		/* Prevent gating in this path */
> @@ -1636,6 +1638,8 @@ static void ufshcd_gate_work(struct work_struct *work)
>   		ufshcd_set_link_hibern8(hba);
>   	}
>   
> +	ufshcd_disable_irq(hba);
> +
>   	if (!ufshcd_is_link_active(hba))
>   		ufshcd_setup_clocks(hba, false);
>   	else
> 

Hi,
Does this save significant power? I see that gate/ungate of clocks 
happen far too frequently than suspend/resume.

Have you considered how much latency this would add to the 
gating/ungating path?

-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
