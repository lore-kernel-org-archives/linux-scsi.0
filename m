Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EF1C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E4E24650
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Zw03CRGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfLRXhf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:37:35 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:26665 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfLRXhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 18:37:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576712253; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=aOyF/9vjrq0zND57ZRP80ePOcz7ZOQqlqlcaCLPEKJg=; b=Zw03CRGi75UoNlS9hc45vK2pSM1l4OQryM+VA/E1VM9XazZluTIX8+bCy44R98ONyKfVNXLT
 A0LsVKkS4JtMxE4dZqjqwHnpj1QwoGe8dDEkFyA9psIdcoy3MXqK/sOMDo3lTntE72BnTs/9
 PqN61st7xHT05NE8dAcGRMGSp80=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfab839.7f34256a3f10-smtp-out-n02;
 Wed, 18 Dec 2019 23:37:29 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 726A6C447AA; Wed, 18 Dec 2019 23:37:29 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 016A9C4479C;
        Wed, 18 Dec 2019 23:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 016A9C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/2] scsi: ufs: disable interrupt during clock-gating
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
References: <1575721321-8071-1-git-send-email-stanley.chu@mediatek.com>
 <1575721321-8071-3-git-send-email-stanley.chu@mediatek.com>
 <a36d111e-ef7f-9f9b-6f6a-692a9980103a@codeaurora.org>
 <1576641171.13056.16.camel@mtkswgap22>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <7756630e-adf2-47e9-4815-ba2306a9dd16@codeaurora.org>
Date:   Wed, 18 Dec 2019 15:37:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1576641171.13056.16.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/2019 7:52 PM, Stanley Chu wrote:
> Hi Asutosh,
> 
> On Tue, 2019-12-17 at 15:25 -0800, Asutosh Das (asd) wrote:
>>>
>>
>> Hi,
>> Does this save significant power? I see that gate/ungate of clocks
>> happen far too frequently than suspend/resume.
>>
>> Have you considered how much latency this would add to the
>> gating/ungating path?
>>
>> -asd
>>
> 
> Yes, we have measured 200 times clk-gating/clk-ungating and latency data
> is showed as below,
> 
> For clk-gating with interrupt disabling toggled,
> 
> 	Average latency of each clk-gating: 55.117 us
> 	Average latency of irq-disabling during clk-gating: 4.2 us
> 
> For clk-ungating with interrupt enabling toggled,
> 	Average latency of each clk-ungating: 118.324 us
> 	Average latency of irq-enabling during clk-ungating: 2.9 us
> 
> The evaluation here is based on below Can's patch therefore the
> interrupt control (enable_irq/disable_irq) latency is much shorter than
> before (request_irq/free_irq).
> 
> scsi: ufs: Do not free irq in suspend
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/scsi/ufs/ufshcd.c?id=8709c1f68536e256668812788af5b2bb027f49c3
> 
> BTW, the main purpose of this patch is aimed to protect ufshcd register
> from accessing while host clocks are disabled to fix potential system
> hang issue. The possible scenario is mentioned in commit message of
> patch "scsi: ufs: disable irq before disabling clocks" in the same
> series.
> 
> Thanks
> Stanley
> 

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

Thanks for the data.
It'd be interesting to know more on the - misrouted interrupt recovery 
feature though.

-
Thanks
Asutosh

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
