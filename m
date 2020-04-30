Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3652BC8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1129020774
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="YUFBBmbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3Mib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:38:31 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:49925 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgD3Mib (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 08:38:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588250310; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=s9tiGzSDMy7NhyUbB2bWUK71xrktfp/JVsuI2n9mC8A=;
 b=YUFBBmbtYOMFIJu1U1zsvIRa9LZu2twdF4/kNJ2S5gly46hTcYetCKmhqBr4dk3Y5L5e66+I
 XhRQPom1J5uSQPz8yQ9fbFJwBqxflUHdPjoNere8yEZson1d6Hi1DoLb+kcSwrZ14iahSiKB
 4hdIrqJB7Im394f07SEeA/nBQzc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eaac6ba.7fdc60f4d570-smtp-out-n05;
 Thu, 30 Apr 2020 12:38:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB9F4C4478F; Thu, 30 Apr 2020 12:38:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBE81C433D2;
        Thu, 30 Apr 2020 12:38:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 20:38:17 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, stanley.chu@mediatek.com,
        alim.akhtar@samsung.com, beanhuo@micron.com,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
In-Reply-To: <BYAPR04MB462931F8DF1112CAF7F80CA4FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <BYAPR04MB462931F8DF1112CAF7F80CA4FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
Message-ID: <eb7520b6274474f4b8d803a76b85107a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On 2020-04-30 17:11, Avri Altman wrote:
>> 
>> On 2020-04-29 21:10, Can Guo wrote:
>> > During system resume, scsi_resume_device() decreases a request queue's
>> > pm_only counter if the scsi device was quiesced before. But after that,
>> > if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is
>> > still held (non-zero). Current scsi resume hook only sets the RPM status
>> > of the scsi device and its request queue to RPM_ACTIVE, but leaves the
>> > pm_only counter unchanged. This may make the request queue's pm_only
>> > counter remain non-zero after resume hook returns, hence those who are
>> > waiting on the mq_freeze_wq would never be woken up. Fix this by calling
>> > blk_post_runtime_resume() if pm_only is non-zero to balance the pm_only
>> > counter which is held by the scsi device's RPM ops.
>> 
>> How was this issue discovered? How has this patch been tested?
> 
> I think this insight was originally gained as part of commit 
> fb276f770118
> (scsi: ufs: Enable block layer runtime PM for well-known logical units)
> 
> But I will let Can reply on that.
> 
> Thanks,
> Avri
> 

Thanks for pointing to that commit, but this is a different story here.
SCSI devices, which have block layer runtime PM enabled, can hit this 
issue
during system resume. In the contratry, those which have block layer 
runtime
PM disabled are immune to this issue.

Thanks,

Can Guo.
>> 
>> Thanks,
>> 
>> Bart.
