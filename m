Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C20EC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 01:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5268C20836
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 01:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wuwyZFfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEABmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 21:42:39 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:63634 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgEABmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 21:42:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588297357; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6fsK5uLt2V2waTX9WKqrO/UQSke0sztBS7rUL0rzJxg=;
 b=wuwyZFfQNR4+LvZuxN2trt8NxlJ2aacuFlZVGIGsgPWp9uQo9Y93P3q+NZaGZ2gO0lNA0HuR
 x5iUo6r4C1IaCH3jANS70ifmT522b9nM/P3zWItbfo0328oV/V4X+tNPHUmujr7YH6wYrKlA
 wluhD83oLb23ujy8cyN8Em/eCM4=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eab7e7c.7f91e8fa5998-smtp-out-n04;
 Fri, 01 May 2020 01:42:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6420FC4478C; Fri,  1 May 2020 01:42:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3613AC433D2;
        Fri,  1 May 2020 01:42:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 01 May 2020 09:42:17 +0800
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
In-Reply-To: <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
 <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
Message-ID: <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-01 04:32, Bart Van Assche wrote:
> On 2020-04-29 22:40, Can Guo wrote:
>> On 2020-04-30 13:08, Bart Van Assche wrote:
>>> On 2020-04-29 21:10, Can Guo wrote:
>>>> During system resume, scsi_resume_device() decreases a request 
>>>> queue's
>>>> pm_only counter if the scsi device was quiesced before. But after 
>>>> that,
>>>> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only 
>>>> counter is
>>>> still held (non-zero). Current scsi resume hook only sets the RPM 
>>>> status
>>>> of the scsi device and its request queue to RPM_ACTIVE, but leaves 
>>>> the
>>>> pm_only counter unchanged. This may make the request queue's pm_only
>>>> counter remain non-zero after resume hook returns, hence those who 
>>>> are
>>>> waiting on the mq_freeze_wq would never be woken up. Fix this by 
>>>> calling
>>>> blk_post_runtime_resume() if pm_only is non-zero to balance the 
>>>> pm_only
>>>> counter which is held by the scsi device's RPM ops.
>>> 
>>> How was this issue discovered? How has this patch been tested?
>> 
>> As the issue was found after system resumes, so the issue was 
>> discovered
>> during system suspend/resume test, and it is very easy to be 
>> replicated.
>> After system resumes, if this issue hits some scsi devices, all bios 
>> sent
>> to their request queues are blocked, which may cause a system hang if 
>> the
>> scsi devices are vital to system functionality.
>> 
>> To make sure the patch work well, we have tested system suspend/resume
>> and made sure no system hang happen due to request queues got blocked
>> by imbalanced pm_only counter.
> 
> Thanks, that's very interesting information. My concern with this patch
> is that the power management code is not the only caller of
> blk_set_pm_only() / blk_clear_pm_only(). E.g. the SCSI SPI code also
> calls scsi_device_quiesce() and scsi_device_resume(). These last
> functions call blk_set_pm_only() and blk_clear_pm_only(). More calls of
> scsi_device_quiesce() and scsi_device_resume() might be added in the 
> future.
> 
> Has it been considered to test directly whether a SCSI device has been
> runtime suspended instead of relying on blk_queue_pm_only()? How about
> using pm_runtime_status_suspended() or adding a function in
> block/blk-pm.h that checks whether q->rpm_status == RPM_SUSPENDED?
> 
> Thanks,
> 
> Bart.

Hi Bart,

Slightly revised my previous mail.

Please let me address your concern.

First of all, it is allowed to call scsi_device_quiesce() multiple 
times,
but one sdev's request queue's pm_only counter can only be increased 
once
by scsi_device_quiesce(), because if a sdev has already been quiesced,
in scsi_device_quiesce(), scsi_device_set_state(sdev, SDEV_QUIESCE) 
would
return -ENIVAL (illegal state transform), then blk_clear_pm_only() shall
be called to decrease pm_only once, so no matter how many times
scsi_device_quiesce() is called, it can only increase pm_only once.

scsi_device_resume() is same, it calls blk_clear_pm_only only once and
only if the sdev was quiesced().

So, in a word, after scsi_device_resume() returns in 
scsi_dev_type_resume(),
if a sdev has block layer runtime PM enabled (sdev->request_queue->dev 
is not
NULL), its queue's pm_only counter should be 1 (if the sdev's runtime 
power
status is RPM_SUSPENDED) or 0 (if the sdev's runtime power status is 
RPM_ACTIVE).
If a sdev has block layer runtime PM disabled (sdev->request_queue->dev 
is NULL),
its queue's pm_only counter should be 0.

Has it been considered to test directly whether a SCSI device has been
runtime suspended instead of relying on blk_queue_pm_only()? How about
using pm_runtime_status_suspended() or adding a function in
block/blk-pm.h that checks whether q->rpm_status == RPM_SUSPENDED?

Yes, I used to make the patch like that way, and it also worked well, as
both ways are equal actually. I kinda like the current code because we
should be confident that after scsi_dev_type_resume() returns, pm_only
must be 0. Different reviewers may have different opinions, either way
works well anyways.

Thanks,

Can Guo.
