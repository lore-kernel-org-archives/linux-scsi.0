Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E756C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 04:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBE0610F7
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 04:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhFPEDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 00:03:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:54607 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhFPEDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 00:03:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623816099; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eHLURM/NKBWqQRnXZp3rlAUkp5uwKCsiJfPwOofHs34=;
 b=er2SxXBJwqqKXxMUYTRHxNA0OpJOOLKQOLblxBVINNKwDmWb65ZXVQHi86Mte4NEBINhwyOx
 E3CmRYGyKjP3Z4hSWMhw4qeHfrHWrNI7mVAURECoSy0t26gH//8a7dqpEWgwGOe7S7Dm+VDI
 ocBa5KmI1InKKirs6Wzy3SZs9Zo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60c9777bb6ccaab7538c23ec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 04:00:59
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4DCA2C4360C; Wed, 16 Jun 2021 04:00:59 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B400DC4338A;
        Wed, 16 Jun 2021 04:00:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Jun 2021 12:00:57 +0800
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
In-Reply-To: <fabc70f8-6bb8-4b62-3311-f6e0ce9eb2c3@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
 <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
 <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
 <3fce15502c2742a4388817538eb4db97@codeaurora.org>
 <fabc70f8-6bb8-4b62-3311-f6e0ce9eb2c3@acm.org>
Message-ID: <8aae95071b9ab3c0a3cab91d1ae138e1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-16 02:25, Bart Van Assche wrote:
> On 6/14/21 7:36 PM, Can Guo wrote:
>> I've considered the similar way (leverage hba->host->eh_noresume) last
>> year,
>> but I didn't take this way due to below reasons:
>> 
>> 1. UFS error handler basically does one thing - reset and restore, 
>> which
>> stops hba [1], resets device [2] and re-probes the device [3]. 
>> Stopping
>> hba [1]
>> shall complete any pending requests in the doorbell (with error or no
>> error).
>> After [1], suspend/resume contexts, blocked by SSU cmd, shall be 
>> unblocked
>> right away to do whatever it needs to handle the SSU cmd failure 
>> (completed
>> in [1], so scsi_execute() returns an error), e.g., put link back to 
>> the old
>> state. call ufshcd_vops_suspend(), turn off irq/clocks/powers and 
>> etc...
>> However, reset and restore ([2] and [3]) is still running, and it can
>> (most likely)
>> be disturbed by suspend/resume. So passing a parameter or using
>> hba->host->eh_noresume
>> to skip lock_system_sleep() and unlock_system_sleep() can break the 
>> cycle,
>> but error handling may run concurrently with suspend/resume. Of course
>> we can
>> modify suspend/resume to avoid it, but I was pursuing a minimal change
>> to get this fixed.
>> 
>> 2. Whatever way we take to break the cycle, suspend/resume shall fail 
>> and
>> RPM framework shall save the error to dev.power.runtime_error, leaving
>> the device in runtime suspended or active mode permanently. If it is 
>> left
>> runtime suspended, UFS driver won't accept cmd anymore, while if it is 
>> left
>> runtime active, powers of UFS device and host will be left ON, leading
>> to power
>> penalty. So my main idea is to let suspend/resume contexts, blocked by
>> PM cmds,
>> fail fast first and then error handler recover everything back to 
>> work.
> 
> Hi Can,
> 
> Has it been considered to make the UFS error handler fail pending
> commands with an error code that causes the SCSI core to resubmit the
> SCSI command, e.g. DID_IMM_RETRY or DID_TRANSPORT_DISRUPTED? I want to
> prevent that power management or suspend/resume callbacks fail if the
> error handler succeeds with recovering the UFS transport.
> 

Hi Bart,

Thanks for the suggestion, I thought about it but I didn't go that
far in this path because I believe letting a context fast fail is
better than retrying/blocking it (to me suspend/resume can fail
due to many reasons and task abort is just one of them). I appreciate
the idea, but I would like to stick to my way as of now because

1. Merely preventing task abort cannot prevent suspend/resume fail.
Task abort (to PM requests), in real cases, is just one of many kinds
of failure which can fail the suspend/resume callbacks. During
suspend/resume, if AH8 error and/or UIC errors happen, IRQ handler
may complete SSU cmd with errors and schedule the error handler (I've
seen such scenarios in real customer cases). My idea is to treat task
abort (to PM requests) as a failure (let scsi_execute() return with
whatever error) and let error handler recover everything just like
any other UFS errors which invoke error handler. In case this, again,
goes back to the topic that is why don't just do error recovery in
suspend/resume, let me paste my previous reply here -

"
Error handler has the same nature of user access - it is unpredictable, 
meaning it
can be invoked at any time (from IRQ handler), even when there is no 
ongoing
cmd/data transactions (like auto hibern8 failure and UIC errors, such as 
DME
error and some errors in data link layer) [1], unless you disable UFS 
IRQ.

The reasons why I choose not to do it that way are (althrough error 
handler
prepare has became much more simple after apply this change)

- I want to keep all the complexity within error handler, and re-direct 
all error
recovery needs to error handler. It can avoid calling 
ufshcd_reset_and_restore()
and/or flush_work(&hba->eh_work) here and there. The entire UFS 
suspend/resume is
already complex enough, I don't want to mess up with it.

- We do explicit recovery only when we see certain errors, e.g., H8 
enter func
returns an error during suspend, but as mentioned above [1], error 
handling can
be invoked already from IRQ handler (due to all kinds of UIC errors 
before H8 enter
func returns). So, we still need host_sem (in case of system 
suspend/resume) to
avoid concurrency.

- During system suspend/resume, error handling can be invoked (due to 
non-fatal
errors) but still UFS cmds return no error at all. Similar like above, 
we need
host_sem to avoid concurrency.
"

2. And say we want SCSI layer to resubmit PM requests to prevent
suspend/resume fail, we should keep retrying the PM requests (so
long as error handler can recover everything successfully), meaning
we should give them unlimited retries (which I think is a bad idea),
otherwise (if they have zero retries or limited retries), in extreme
conditions, what may happen is that error handler can recover everything
successfully every time, but all these retries (say 3) still time out,
which block the power management for too long (retries * 60 seconds) 
and,
most important, when the last retry times out, scsi layer will anyways
complete the PM request (even we return DID_IMM_RETRY), then we end up
same - suspend/resume shall run concurrently with error handler and we
couldn't recover saved PM errors.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
