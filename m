Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74DCC43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 06:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B0520672
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 06:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TCzo7MWa";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="C2c0bbRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfKSGHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:07:23 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:36094
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729019AbfKSFdS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574141597;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=GlyMthblqvRAyrh2xUaWmB3J3VHTjlXdZAiCcUK1bB4=;
        b=TCzo7MWa4Ax9241dDj7mXxvzz/PgbPuj9vbgUYKLhTZJgxsubI6CllewOovet3wy
        UtRofOJJXe4PUU73Dna1kne51OtvoBjCJ+W4/ebBMH7OIbJ1zfqW7IZDEWUJOrFhHBm
        jew+0yPxa6HbOenGiq5D+rzDJcWb22f92HIQMJmw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574141597;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=GlyMthblqvRAyrh2xUaWmB3J3VHTjlXdZAiCcUK1bB4=;
        b=C2c0bbRsBaqoxt2jHlnG8+I77BmX9TGiWbn51EBGsGcym/k7gtXtFWZu23h61ZVQ
        mfQlMRpRe+f92NfL1JmWw7FG5m0Ym8OeoN3oqH6jtlOa0/MnPYM/LLZRYF3L5j0v6iO
        x8Kpx/6frYm68ciuAvsCtFUCdLxp9od6uQuazWJI=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 19 Nov 2019 05:33:17 +0000
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
In-Reply-To: <5659ab82-a087-4cfb-088e-e25d7f5515a3@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
 <5659ab82-a087-4cfb-088e-e25d7f5515a3@acm.org>
Message-ID: <0101016e822695e0-499a071e-b625-425c-ac3e-74cf807e3100-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.19-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-19 02:13, Bart Van Assche wrote:
> On 11/14/19 10:01 PM, Can Guo wrote:
>> On 2019-11-15 00:11, Bart Van Assche wrote:
>>> On 11/13/19 8:03 AM, Bean Huo (beanhuo) wrote:
>>>> I think, you are asking for comment from Can.  As for me, attached 
>>>> patch is better.
>>>> Removing ufshcd_wait_for_doorbell_clr(), instead of reading doorbell 
>>>> register, Now
>>>> using block layer blk_mq_{un,}freeze_queue(), looks good. I tested 
>>>> your V5 patches,
>>>> didn't find problem yet.
>>>> 
>>>> Since my available platform doesn't support dynamic clk scaling, I 
>>>> think, now seems only
>>>> Qcom UFS controllers support this feature. So we need Can Guo to 
>>>> finally confirm it.
>>> 
>>> Do you agree with this patch series if patch 4 is replaced by the
>>> patch attached to my previous e-mail? The entire (revised) series is
>>> available at https://github.com/bvanassche/linux/tree/ufs-for-next.
>> 
>> After ufshcd_clock_scaling_prepare() returns(no error), all request 
>> queues are frozen. If failure
>> happens(say power mode change command fails) after this point and 
>> error handler kicks off,
>> we need to send dev commands(in ufshcd_probe_hba()) to bring UFS back 
>> to functionality.
>> However, as the hba->cmd_queue is frozen, dev commands cannot be sent, 
>> the error handler shall fail.
> 
> Hi Can,
> 
> My understanding of the current UFS driver code is that
> ufshcd_clock_scaling_prepare() waits for ongoing commands to finish
> but not for SCSI error handling to finish. Would you agree with
> changing that behavior such that ufshcd_clock_scaling_prepare()
> returns an error
> code if SCSI error handling is in progress? Do you agree that once
> that change has been made that it is fine to invoke
> blk_freeze_queue_start() for all three types of block layer request
> queues (SCSI commands, device management commands and TMFs)? Do you
> agree that this would fix the issue that it is possible today to
> submit TMFs from user space using through the BSG queue while clock
> scaling is in progress?
> 
> Thanks,
> 
> Bart.

Hi Bart,

Your understanding is correct.

> Would you agree with changing that behavior such that 
> ufshcd_clock_scaling_prepare()
> returns an error code if SCSI error handling is in progress?

I believe we already have the check of ufshcd_eh_in_progress() in
ufshcd_devfreq_target() before call ufshcd_devfreq_scale().

> Do you agree that once that change has been made that it is fine to 
> invoke
> blk_freeze_queue_start() for all three types of block layer request
> queues (SCSI commands, device management commands and TMFs)?

I agree. As err handling work always runs in ASYNC way in current code 
base, it is fine to freeze all the queues.
If there is err handling work, scheduled during scaling, would 
eventually be unblocked when hba->cmd_queue
is unfrozen after scaling returns or fails.

Sorry for making you confused. My previous comment is based on that if 
we need to do hibern8
enter/exit in vendor ops (see 
https://lore.kernel.org/patchwork/patch/1143579/), and if hibern8
enter/exit fails during scaling, we need to call ufshcd_link_recovery() 
to recovery everything in SYNC way.
And as hba->cmd_queue is frozen, ufshcd_link_recovery() would hang when 
it needs to send device
manangement commands. In this case, we need to make sure hba->cmd_queue 
is NOT frozen.
So it seems contraditory.

FYI, even with the patch 
https://lore.kernel.org/patchwork/patch/1143579/, current
implementation also has this problem. And we have another change to 
address it by
making change to ufshcd_exec_dev_cmd() like below.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c2a2ff2..81a000e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4068,6 +4068,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
*hba,
         int tag;
         struct completion wait;
         unsigned long flags;
+       bool has_read_lock = false;

@@ -4075,8 +4076,10 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
*hba,

+       if (!ufshcd_eh_in_progress(hba)) {
                 down_read(&hba->lock);
+               has_read_lock = true;
+       }

         /*
          * Get free slot, sleep if slots are unavailable.
@@ -4110,7 +4113,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
*hba,
  out_put_tag:
         ufshcd_put_dev_cmd_tag(hba, tag);
         wake_up(&hba->dev_cmd.tag_wq);
+       if (has_read_lock)
                 up_read(&hba->lock);
         return err;
  }


Aside the functionality, we need to take this change carefully as it may 
relate with performance.
With the old implementation, when devfreq decides to scale up, we can 
make sure that all requests
sent to UFS device after this point will go through the highest UFS 
Gear. Scaling up will happen
right after doorbell is cleared, not even need to wait till the requests 
are freed from block layer.
And 1 sec is long enough to clean out the doorbell by HW.

In the new implementation of ufshcd_clock_scaling_prepare(), after 
blk_freeze_queue_start(), we call
blk_mq_freeze_queue_wait_timeout() to wait for 1 sec. In addition to 
those requests which have already
been queued to HW doorbell, more requests will be dispatched within 1 
sec, through the lowest Gear.
My first impression is that it might be a bit lazy and I am not sure how 
much it may affect the benchmarks.

And if the request queues are heavily loaded(many bios are waiting for a 
free tag to become a request),
is 1 sec long enough to freeze all these request queues? If no, 
performance would be affected if scaling up
fails frequently.
As per my understanding, the request queue will become frozen only after 
all the existing requests and
bios(which are already waiting for a free tag on the queue) to be 
completed and freed from block layer.
Please correct me if I am wrong.

While, in the old implementatoin, when devfreq decides to scale up, 
scaling can always
happen for majority chances, execept for those unexpected HW issues.

Best Regards,
Can Guo
