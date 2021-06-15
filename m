Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183D6C48BE5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 03:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA1161403
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 03:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFODT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 23:19:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:56231 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhFODT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 23:19:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623727074; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lk67JyGVJWRWuUprxS9r8ZGDY6Wkzac1/9zbAIRyKwg=;
 b=Zsvmvdqpd+J4yeLgCD4aiXBrleI1nwAsq3D1a8GD1j1BF8sZsJphTro6DCnblH+KlIJyFVLQ
 a5sSnjg/8ocDPhKAvuFqyOQgpYyN0CIOsGbWwbOB2de2KlO+VD1CP8/KgiocK4o6deeQ0GFW
 EW5DiBPjfB4JL4NpIFJ1XpI+SR4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60c81be151f29e6baeeff7c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 03:17:53
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8816CC433D3; Tue, 15 Jun 2021 03:17:52 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22709C433F1;
        Tue, 15 Jun 2021 03:17:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Jun 2021 11:17:40 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
In-Reply-To: <3fce15502c2742a4388817538eb4db97@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
 <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
 <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
 <3fce15502c2742a4388817538eb4db97@codeaurora.org>
Message-ID: <ef1b4408a5fd87b3b2c9cb0e891b892f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-15 10:36, Can Guo wrote:
> Hi Bart,
> 
> On 2021-06-15 02:49, Bart Van Assche wrote:
>> On 6/13/21 7:42 AM, Can Guo wrote:
>>> 2. ufshcd_abort() invokes ufshcd_err_handler() synchronously can have 
>>> a
>>> live lock issue, which is why I chose the asynchronous way (from the 
>>> first
>>> day I started to fix error handling). The live lock happens when 
>>> abort
>>> happens
>>> to a PM request, e.g., a SSU cmd sent from suspend/resume. Because 
>>> UFS
>>> error
>>> handler is synchronized with suspend/resume (by calling
>>> pm_runtime_get_sync()
>>> and lock_system_sleep()), the sequence is like:
>>> [1] ufshcd_wl_resume() sends SSU cmd
>>> [2] ufshcd_abort() calls UFS error handler
>>> [3] UFS error handler calls lock_system_sleep() and 
>>> pm_runtime_get_sync()
>>> 
>>> In above sequence, either lock_system_sleep() or 
>>> pm_runtime_get_sync()
>>> shall
>>> be blocked - [3] is blocked by [1], [2] is blocked by [3], while [1] 
>>> is
>>> blocked by [2].
>>> 
>>> For PM requests, I chose to abort them fast to unblock 
>>> suspend/resume,
>>> suspend/resume shall fail of course, but UFS error handler recovers
>>> PM errors anyways.
>> 
>> In the above sequence, does [2] perhaps refer to aborting the SSU
>> command submitted in step [1] (this is not clear to me)?
> 
> Yes, your understanding is right.
> 
>> If so, how about breaking the circular waiting cycle as follows:
>> - If it can happen that SSU succeeds after more than scsi_timeout
>>   seconds, define a custom timeout handler. From inside the timeout
>>   handler, schedule a link check and return BLK_EH_RESET_TIMER. If the
>>   link is no longer operational, run the error handler. If the link
>>   cannot be recovered by the error handler, fail all pending commands.
>>   This will prevent that ufshcd_abort() is called if a SSU command 
>> takes
>>   longer than expected. See also commit 0dd0dec1677e.
>> - Modify the UFS error handler such that it accepts a context 
>> argument.
>>   The context argument specifies whether or not the UFS error handler 
>> is
>>   called from inside a system suspend or system resume handler. If the
>>   UFS error handler is called from inside a system suspend or resume
>>   callback, skip the lock_system_sleep() and unlock_system_sleep()
>>   calls.
>> 
> 
> I am aware of commit 0dd0dec1677e, I gave my reviewed-by tag. Thank you
> for your suggestion and I believe it can resolve the cycle, because 
> actually
> I've considered the similar way (leverage hba->host->eh_noresume) last 
> year,
> but I didn't take this way due to below reasons:
> 
> 1. UFS error handler basically does one thing - reset and restore, 
> which
> stops hba [1], resets device [2] and re-probes the device [3]. Stopping 
> hba [1]
> shall complete any pending requests in the doorbell (with error or no 
> error).
> After [1], suspend/resume contexts, blocked by SSU cmd, shall be 
> unblocked
> right away to do whatever it needs to handle the SSU cmd failure 
> (completed
> in [1], so scsi_execute() returns an error), e.g., put link back to the 
> old
> state. call ufshcd_vops_suspend(), turn off irq/clocks/powers and 
> etc...
> However, reset and restore ([2] and [3]) is still running, and it can
> (most likely)
> be disturbed by suspend/resume. So passing a parameter or using
> hba->host->eh_noresume
> to skip lock_system_sleep() and unlock_system_sleep() can break the 
> cycle,
> but error handling may run concurrently with suspend/resume. Of course 
> we can
> modify suspend/resume to avoid it, but I was pursuing a minimal change
> to get this fixed.
> 

Add more - besides, SSU cmd is not the only PM request sent during 
suspend/resume,
last year (before your changes came in) it also sends request sense cmd 
without
checking the return value of it - so if request sense cmd abort happens, 
suspend/resume
still move forward, which can run concurrently with error handling. So I 
was pursuing
a way to make error handler less dependent on the bahaviours of these 
contexts.

Thanks,

Can Guo.

> 2. Whatever way we take to break the cycle, suspend/resume shall fail 
> and
> RPM framework shall save the error to dev.power.runtime_error, leaving
> the device in runtime suspended or active mode permanently. If it is 
> left
> runtime suspended, UFS driver won't accept cmd anymore, while if it is 
> left
> runtime active, powers of UFS device and host will be left ON, leading 
> to power
> penalty. So my main idea is to let suspend/resume contexts, blocked by 
> PM cmds,
> fail fast first and then error handler recover everything back to work.
> 
> Thanks,
> 
> Can Guo.
> 
>> Thanks,
>> 
>> Bart.
