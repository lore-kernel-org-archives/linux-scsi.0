Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9453C47256
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 02:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF7021775
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 02:00:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tmCaMLGd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEBCAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 22:00:06 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:45275 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgEBCAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 22:00:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588384805; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Y7zHbm62D06FuknuUOyxfzY9RDfUfaFg2lavUE/GVKc=;
 b=tmCaMLGdcsdBVziotMaT2396UiQxPQIQSDUrBLFs24v61dnziJ+LPc8dWDV4lzSK295vDIE0
 +FDayAyRqG6d8g+6W39XChnYTUAsC1pvyoNxYBQZOc3YPCZniBV4hRQ8zWJK0g1joRLTK4Ou
 YYdhnX0CsDZtCaKQflCbUZ4tdLE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eacd40b.7f82d4197880-smtp-out-n05;
 Sat, 02 May 2020 01:59:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 05744C4478F; Sat,  2 May 2020 01:59:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06328C433D2;
        Sat,  2 May 2020 01:59:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 02 May 2020 09:59:37 +0800
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
In-Reply-To: <2356ab42-bbdd-d214-30f5-a533fe978dcb@acm.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
 <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
 <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
 <226048f7-6ad3-a625-c2ed-d9d13e096803@acm.org>
 <3bfa692ce706c5c198f565e674afb56f@codeaurora.org>
 <2356ab42-bbdd-d214-30f5-a533fe978dcb@acm.org>
Message-ID: <5196eb909699044771fe58905c543626@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-02 01:56, Bart Van Assche wrote:
> On 2020-04-30 22:12, Can Guo wrote:
>> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
>> index 3717eea..d18271d 100644
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -74,12 +74,15 @@ static int scsi_dev_type_resume(struct device 
>> *dev,
>>  {
>>         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : 
>> NULL;
>>         int err = 0;
>> +       bool was_rpm_suspended = false;
>> 
>>         err = cb(dev, pm);
>>         scsi_device_resume(to_scsi_device(dev));
>>         dev_dbg(dev, "scsi resume: %d\n", err);
>> 
>>         if (err == 0) {
>> +               was_rpm_suspended = pm_runtime_suspended(dev);
>> +
> 
> How about renaming this variable into "was_runtime_suspended"? How 
> about
> moving the declaration of that variable inside the if-statement?
> 

Sure, shall do, this patch was just a prototype which I made for 
testing.
If you are OK with this idea, I will send it as the next version.

>>                 pm_runtime_disable(dev);
>>                 err = pm_runtime_set_active(dev);
>>                 pm_runtime_enable(dev);
>> @@ -93,8 +96,10 @@ static int scsi_dev_type_resume(struct device *dev,
>>                  */
>>                 if (!err && scsi_is_sdev_device(dev)) {
>>                         struct scsi_device *sdev = 
>> to_scsi_device(dev);
>> -
>> -                       blk_set_runtime_active(sdev->request_queue);
>> +                       if (was_rpm_suspended)
>> +                              
>> blk_post_runtime_resume(sdev->request_queue, 0);
>> +                       else
>> +                              
>> blk_set_runtime_active(sdev->request_queue);
>>                 }
>>         }
> 
> Does other code always call both blk_pre_runtime_resume() and
> blk_post_runtime_resume() upon runtime resume? How about adding a
> blk_pre_runtime_resume() call before the blk_post_runtime_resume() 
> call?
> 
> Thanks,
> 
> Bart.

Yes, but adding a blk_pre_runtime_resume() here is meaningless, it only
sets the q->rpm_status to RPM_RESUMING, blk_post_runtime_resume() 
overrides
it to RPM_ACTIVE for sure. Besides, this place comes after the call of
pm_runtime_set_active(), meaning sdev is already runtime active, in 
contrast
with the real runtime resume routine, we can think it as the sdev's 
runtime
resume ops has returned 0, so we can just call 
blk_post_runtime_resume(err=0).

Thanks,

Can Guo.
