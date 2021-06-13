Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB7DC48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 14:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C10E61279
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 14:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhFMOpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 10:45:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51545 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhFMOpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Jun 2021 10:45:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623595401; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=dkkBohdmxX4AMm5TOqURPJf+1cAVzehkXSkKCYGxK/k=;
 b=Jco7lQxUJkJdbFtOshlnqkYiOI347o8duGY8EeQYxLrKqNrlfoP5E/Jh/GPbV9ZuJitGrz6e
 Cxw8x/T+vFKZvz7KlGZn4rHxZAhcRRh5tHbZIEyc6j3lkh/LDSEAFKV/QQAZdRGYszTM4Jiy
 7RiXPt8kuukTFi14wu0OOelsFeA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60c61971ed59bf69cc07e3da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 13 Jun 2021 14:42:57
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EFC9FC4338A; Sun, 13 Jun 2021 14:42:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F12AC433F1;
        Sun, 13 Jun 2021 14:42:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 13 Jun 2021 22:42:55 +0800
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
In-Reply-To: <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
Message-ID: <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-13 00:50, Bart Van Assche wrote:
> On 6/12/21 12:07 AM, Can Guo wrote:
>> Sigh... I also want my life and work to be easier...
> 
> How about reducing the number of states and state transitions in the 
> UFS
> driver? One source of complexity is that ufshcd_err_handler() is 
> scheduled
> independently of the SCSI error handler and hence may run concurrently
> with the SCSI error handler. Has the following already been considered?
> - Call ufshcd_err_handler() synchronously from ufshcd_abort() and
> ufshcd_eh_host_reset_handler() instead of asynchronously.

1. ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and 
flushes
it, so it is synchronous. ufshcd_eh_host_reset_handler() used to call
reset_and_restore() directly, which can run concurrently with UFS error 
handler,
so I fixed it last year [1].

2. ufshcd_abort() invokes ufshcd_err_handler() synchronously can have a
live lock issue, which is why I chose the asynchronous way (from the 
first
day I started to fix error handling). The live lock happens when abort 
happens
to a PM request, e.g., a SSU cmd sent from suspend/resume. Because UFS 
error
handler is synchronized with suspend/resume (by calling 
pm_runtime_get_sync()
and lock_system_sleep()), the sequence is like:
[1] ufshcd_wl_resume() sends SSU cmd
[2] ufshcd_abort() calls UFS error handler
[3] UFS error handler calls lock_system_sleep() and 
pm_runtime_get_sync()

In above sequence, either lock_system_sleep() or pm_runtime_get_sync() 
shall
be blocked - [3] is blocked by [1], [2] is blocked by [3], while [1] is 
blocked by [2].

For PM requests, I chose to abort them fast to unblock suspend/resume,
suspend/resume shall fail of course, but UFS error handler recovers
PM errors anyways.

> - Call scsi_schedule_eh() from ufshcd_uic_pwr_ctrl() and
> ufshcd_check_errors() instead of ufshcd_schedule_eh_work().

When ufshcd_uic_pwr_ctrl() and/or ufshcd_check_errors() report errors,
usually they are fatal errors, according to UFSHCI spec, SW should 
re-probe
UFS to recover.

However scsi_schedule_eh() does more than that - scsi_unjam_host() sends
request sense cmd and calls scsi_eh_ready_devs(), while 
scsi_eh_ready_devs()
sends test unit ready cmd and calls all the way down to 
scsi_eh_device/target/
bus/host_reset(). But we only need scsi_eh_host_reset() in this case. I 
know
you have concerns that scsi_schedule_eh() may run concurrently with UFS 
error
handler, but as I mentioned above in [1] - I've made 
ufshcd_eh_host_reset_handler()
synchronized with UFS error handler, hope that can ease your concern.

I am not saying your idea won't work, it is a good suggestion. I will 
try
it after these changes go in, because it would require extra effort and 
the
effort won't be minor - I need to consider how to remove/reduce the 
ufshcd
states along with the change and the error injection and stability test 
all
over again, which is a long way to go. As for now, at least current 
changes
works well as per my test and we really need these changes for 
Andriod12-5.10.

Thanks,

Can Guo.

> 
> These changes will guarantee that all commands have completed or timed
> out before ufshcd_err_handler() is called. I think that would allow to
> remove e.g. the following code from the error handler:
> 
> 	ufshcd_scsi_block_requests(hba);
> 	/* Drain ufshcd_queuecommand() */
> 	down_write(&hba->clk_scaling_lock);
> 	up_write(&hba->clk_scaling_lock);
> 
> Thanks,
> 
> Bart.
