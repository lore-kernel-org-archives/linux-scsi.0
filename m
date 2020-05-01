Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380ECC47256
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 05:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1955521924
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 05:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mzzFIhaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgEAFMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 01:12:23 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:21378 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728159AbgEAFMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 01:12:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588309941; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Gb5UVWrknkO+6yt6LwWbrza8osaP6Xld9YYD0ScSLPA=;
 b=mzzFIhaKhODcgxdqY5Ozx4DMbupH+eueG5ea4sH/FRn7yuozY2Xf6VdiGWLPWJ257SNA32fX
 zcOJmae8NqNAhqDFffAYDUn0cYPJWdaHeMCMod2mkwADwm+UeLw1EYYnMbKMBHD97P79HnyJ
 0tJ9aMDkRRPwbfRZCEAH0nDnWlc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eabafb4.7f7e4515ad50-smtp-out-n03;
 Fri, 01 May 2020 05:12:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 80208C4478F; Fri,  1 May 2020 05:12:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78AAFC433CB;
        Fri,  1 May 2020 05:12:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 01 May 2020 13:12:17 +0800
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
In-Reply-To: <226048f7-6ad3-a625-c2ed-d9d13e096803@acm.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
 <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
 <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
 <226048f7-6ad3-a625-c2ed-d9d13e096803@acm.org>
Message-ID: <3bfa692ce706c5c198f565e674afb56f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-01 09:50, Bart Van Assche wrote:
> On 2020-04-30 18:42, Can Guo wrote:
>> On 2020-05-01 04:32, Bart Van Assche wrote:
>> > Has it been considered to test directly whether a SCSI device has been
>> > runtime suspended instead of relying on blk_queue_pm_only()? How about
>> > using pm_runtime_status_suspended() or adding a function in
>> > block/blk-pm.h that checks whether q->rpm_status == RPM_SUSPENDED?
>> 
>> Yes, I used to make the patch like that way, and it also worked well, 
>> as
>> both ways are equal actually. I kinda like the current code because we
>> should be confident that after scsi_dev_type_resume() returns, pm_only
>> must be 0. Different reviewers may have different opinions, either way
>> works well anyways.
> 
> Hi Can,
> 
> Please note that this is not a matter of personal preferences of a
> reviewer but a matter of correctness. blk_queue_pm_only() does not only
> return a value > 0 if a SCSI device has been runtime suspended but also
> returns true if scsi_device_quiesce() was called for another reason.
> Hence my request to test the "runtime suspended" status directly and 
> not
> to rely on blk_queue_pm_only().
> 
> Thanks,
> 
> Bart.

Hi Bart,

I agree we are pursuing correctness here, but as I said, I think both
way are equally correct. I also agree with you that the alternative way,
see [2], is much easier to be understood, we can take the alternative 
way
if you are OK with it.

[1] Currently, scsi_dev_type_resume() is the hooker for resume, thaw and
restore. Per my understanding, when scsi_dev_type_resume() is running,
it is not possible that scsi_device_quiesce() can be called to this 
sdev,
at least not possible in current code base. So it is OK to rely on
blk_queue_pm_only() in scsi_dev_type_resume().

[2] The alternative way which I have tested with is like below. I think
it is what you requested for if my understanding is right, please 
correct
me if I am wrong.

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea..d18271d 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -74,12 +74,15 @@ static int scsi_dev_type_resume(struct device *dev,
  {
         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : 
NULL;
         int err = 0;
+       bool was_rpm_suspended = false;

         err = cb(dev, pm);
         scsi_device_resume(to_scsi_device(dev));
         dev_dbg(dev, "scsi resume: %d\n", err);

         if (err == 0) {
+               was_rpm_suspended = pm_runtime_suspended(dev);
+
                 pm_runtime_disable(dev);
                 err = pm_runtime_set_active(dev);
                 pm_runtime_enable(dev);
@@ -93,8 +96,10 @@ static int scsi_dev_type_resume(struct device *dev,
                  */
                 if (!err && scsi_is_sdev_device(dev)) {
                         struct scsi_device *sdev = to_scsi_device(dev);
-
-                       blk_set_runtime_active(sdev->request_queue);
+                       if (was_rpm_suspended)
+                               
blk_post_runtime_resume(sdev->request_queue, 0);
+                       else
+                               
blk_set_runtime_active(sdev->request_queue);
                 }
         }

Thanks,

Can Guo
