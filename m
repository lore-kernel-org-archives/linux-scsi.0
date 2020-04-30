Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB16C83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 05:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CB82082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 05:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mnX7Cg+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgD3Fkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:40:46 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:30562 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbgD3Fkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 01:40:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588225245; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/s8xOLocV/YTRQ/Nzq+NBZkj5U9IzFR+p0Ifn/H2Edo=;
 b=mnX7Cg+iQBgIFgzMQIScYwJvmGId1zr+BXVyPj09L0ibHfrPmnV+iFR2a8sMABCyRyvgxucJ
 NLTxDj/03hRTRELh629MkclZGeDLREC5Fe8uSxES5yyM6C8Jw3A5JCF/DPLslAUjJSx2xn6I
 Cnp+UHb01oN95nsFJ2du6i9ZMQ4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eaa64dc.7f707f237e30-smtp-out-n01;
 Thu, 30 Apr 2020 05:40:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24818C44791; Thu, 30 Apr 2020 05:40:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4EF4BC433CB;
        Thu, 30 Apr 2020 05:40:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 13:40:43 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        stanley.chu@mediatek.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, Avri.Altman@wdc.com,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
In-Reply-To: <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
Message-ID: <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-04-30 13:08, Bart Van Assche wrote:
> On 2020-04-29 21:10, Can Guo wrote:
>> During system resume, scsi_resume_device() decreases a request queue's
>> pm_only counter if the scsi device was quiesced before. But after 
>> that,
>> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter 
>> is
>> still held (non-zero). Current scsi resume hook only sets the RPM 
>> status
>> of the scsi device and its request queue to RPM_ACTIVE, but leaves the
>> pm_only counter unchanged. This may make the request queue's pm_only
>> counter remain non-zero after resume hook returns, hence those who are
>> waiting on the mq_freeze_wq would never be woken up. Fix this by 
>> calling
>> blk_post_runtime_resume() if pm_only is non-zero to balance the 
>> pm_only
>> counter which is held by the scsi device's RPM ops.
> 
> How was this issue discovered? How has this patch been tested?
> 
> Thanks,
> 
> Bart.

As the issue was found after system resumes, so the issue was discovered
during system suspend/resume test, and it is very easy to be replicated.
After system resumes, if this issue hits some scsi devices, all bios 
sent
to their request queues are blocked, which may cause a system hang if 
the
scsi devices are vital to system functionality.

To make sure the patch work well, we have tested system suspend/resume
and made sure no system hang happen due to request queues got blocked
by imbalanced pm_only counter.

Thanks,

Can Guo.
