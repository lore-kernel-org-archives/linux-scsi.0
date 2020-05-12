Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E07C2D0F6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BE620714
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:11:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="X9yzDJ5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgELSLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 14:11:02 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:30901 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgELSLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 14:11:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589307061; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=OO3R9jYg4r1wAHoA8hhGY1+VCtV/dK//JXy3OK5Qw9E=; b=X9yzDJ5w+uANXT+L0o2HIQlXUvsmNWzlgT6jU82S+P7kKsBNoTKhd66cdZAwY7/rteL0gINH
 rDZ4TE3ZFIi7C6CJR70/e9MEUgg0tc/p6AmznY7L91o8aW6ZPuM0Pp+YL7Q3ejPkgOAKQOrq
 Aki8pSI2ojxQZbVTMdVDF0BwEpI=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebae6b4.7ffa4cc7b810-smtp-out-n02;
 Tue, 12 May 2020 18:11:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9100AC4478F; Tue, 12 May 2020 18:10:58 +0000 (UTC)
Received: from [192.168.8.150] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1684BC433F2;
        Tue, 12 May 2020 18:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1684BC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 4/4] scsi: ufs-mediatek: customize WriteBooster flush
 policy
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
 <20200509093716.21010-5-stanley.chu@mediatek.com>
 <635f91f6-3a27-ffdd-4021-67705d4063fc@codeaurora.org>
 <yq1v9l115us.fsf@oracle.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <7d5f53eb-f642-3c8b-edf6-d4693ecb49a4@codeaurora.org>
Date:   Tue, 12 May 2020 11:10:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <yq1v9l115us.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/2020 9:21 AM, Martin K. Petersen wrote:
> 
> Hi Asutosh!
> 
>> Patchset looks good to me.
>>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> When you want to approve an entire series, please respond to the cover
> letter email. Otherwise the kernel.org tooling will only record the tag
> for the individual patch you are responding to. In this case only patch
> 4 got tagged as reviewed in patchwork.
> 

Hi Martin
Sure - I'll keep this in mind.

Thanks,
Asutosh

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
