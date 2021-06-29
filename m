Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248AFC11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 06:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2D261DC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 06:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhF2G0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 02:26:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:37875 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231881AbhF2G0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 02:26:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624947815; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=DdkTwy/6c3OcCt3JVBX/JqCoATNZP8AJdxUEwDuVA+g=;
 b=iAUjFz2Cueg+n4d4Zdec7p7LQfJJL1VoJnvEzT8Cm+NbiDCMB9jZydrr4R0bzAJWdrkIJJTS
 80RtqudGUcW7+QUVigms4YLVqiOzRbYS/6Mm87TGrINj31jTRjsYzXES8ut+B3B0GTI+Ra5i
 dsZhe2khid0MVuz2oA2qVaZKQCk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60dabc61ad0600eedeeb2904 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Jun 2021 06:23:29
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 641A7C4360C; Tue, 29 Jun 2021 06:23:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21EE4C43460;
        Tue, 29 Jun 2021 06:23:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Jun 2021 14:23:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
In-Reply-To: <c7d9e12d-f966-44c6-27dc-4004143398aa@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-8-git-send-email-cang@codeaurora.org>
 <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
 <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
 <a87e5ca5-390f-8ca0-41bf-27cdc70e3316@intel.com>
 <1b351766a6e40d0df90b3adec964eb33@codeaurora.org>
 <a654d2ef-b333-1c56-42c6-3d69e9f44bd0@intel.com>
 <3970b015e444c1f1714c7e7bd4c44651@codeaurora.org>
 <7ba226fe-789c-bf20-076b-cc635530db42@acm.org>
 <ea968eb95ef03ef16a420e7483680b75@codeaurora.org>
 <c7d9e12d-f966-44c6-27dc-4004143398aa@acm.org>
Message-ID: <60a5496863100976b74d8c376c9e9cb0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-29 01:31, Bart Van Assche wrote:
> On 6/28/21 1:17 AM, Can Guo wrote:
>> On 2021-06-25 01:11, Bart Van Assche wrote:
>>> On 6/23/21 11:31 PM, Can Guo wrote:
>>>> Using back host_sem in suspend_prepare()/resume_complete() won't 
>>>> have
>>>> this problem of deadlock, right?
>>> 
>>> Although that would solve the deadlock discussed in this email 
>>> thread, it
>>> wouldn't solve the issue of potential adverse interactions of the UFS
>>> error handler and the SCSI error handler running concurrently.
>> 
>> I think I've explained it before, paste it here -
>> 
>> ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and 
>> flushes it,
>> so SCSI error handler and UFS error handler can safely run together.
> 
> That code path is the exception. Do you agree that the following three
> functions all invoke the ufshcd_err_handler() function asynchronously?
> * ufshcd_uic_pwr_ctrl()
> * ufshcd_check_errors()
> * ufshcd_abort()
> 

I agree, but I don't see what's wrong with that. Any context can invoke
ufs error handler asynchronously and ufs error handler prepare makes
sure error handler can work safely, i.e., stopping PM ops/gating/scaling
in error handler prepare makes sure no one shall call 
ufshcd_uic_pwr_ctrl()
ever again. And ufshcd_check_errors() and ufshcd_abort() are OK to run
concurrently with UFS error handler.

>>> How about using the
>>> standard approach for invoking the UFS error handler instead of using
>>> a custom
>>> mechanism, e.g. by using something like the (untested) patch below? 
>>> This
>>> approach guarantees that the UFS error handler is only activated 
>>> after
>>> all
>>> pending SCSI commands have failed or timed out and also guarantees
>>> that no new
>>> SCSI commands will be queued while the UFS error handler is in
>>> progress (see
>>> also scsi_host_queue_ready()).
>> 
>> Per my understanding, SCSI error handling is scsi cmd based, meaning 
>> it
>> only works when certain SCSI cmds failed [ ... ]
> That is not completely correct. The SCSI error handler is activated if
> either all pending commands have failed or if it is scheduled
> explicitly. Please take a look at the host_eh_scheduled member 
> variable,
> how it is used and also at scsi_schedule_eh(). The scsi_schedule_eh()
> function was introduced in 2006 and that the ATA code uses it since 
> then
> to activate the SCSI error handler even if no commands are pending. See
> also the patch "SCSI: make scsi_implement_eh() generic API for SCSI
> transports".
> 
>> However, most UFS (UIC) errors happens during gear scaling, clk gating
>> and suspend/resume (due to power mode changes and/or hibern8
>> enter/exit), during which there is NO scsi cmds in UFS driver at all
>> (because these contexts start only when there is no ongoing data
>> transactions).
> 
> Activating the SCSI error handler if no SCSI commands are in progress 
> is
> supported by scsi_schedule_eh().
> 
>> Thus, scsi_unjam_host() won't even call scsi_eh_ready_devs() because
>> scsi_eh_get_sense() always returns TRUE in these cases (eh_work_q is
>> empty).
> 
> Please take another look at the patch in my previous message. There is 
> a
> scsi_transport_template instance in that patch. The eh_strategy_handler
> defined in a SCSI transport template is called *instead* of
> scsi_unjam_host(). In other words, scsi_unjam_host() won't be called if
> my patch would be applied to the UFS driver.
> 
> Please let me know if you need more information.

Sorry that I missed the change of scsi_transport_template() in your 
previous
message. I can understand that you want to invoke UFS error hander by 
invoking
SCSI error handler, but I didn't go that far because I saw you changed
pm_runtime_get_sync() to pm_runtime_get_noresume() in ufs error handler 
prepare.
How can that change make sure that the device is not suspending or 
resuming
while error handler is running?

Thanks,

Can Guo.

> 
> Bart.
