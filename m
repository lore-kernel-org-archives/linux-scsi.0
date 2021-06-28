Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F47EC11F64
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 17:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3583661C4D
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 17:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhF1ReR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 13:34:17 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:46073 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhF1ReQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 13:34:16 -0400
Received: by mail-pg1-f172.google.com with SMTP id y17so3761946pgf.12;
        Mon, 28 Jun 2021 10:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/Ygcb6PuZTWJldevbJojqcbTHjtYoWaJ0JOU4ireDo=;
        b=TB/cF9P5C1FtV3nMxw8cMUaksrEYgorCAKqjW9AWz0n/Sw7u0LUwSAIg5BtqzUWkc/
         8QckR6bvM/+IZTPKLVhdq6l4r541661iR/mqCS260nqSrm6+sZwhLPQDksWz8UpzyWkd
         XXfowF3G58uLarKXbT94CAgMfrj/5gNdmzzkt9Vc5AQxOmuqBIx8tm8YfPkYYdqXoHhD
         4HlmkyFJtp8ebV7L+dp86AsiJmByqxz8IelvpRZPYTHZ/OMfhcKbTgk/mvUfWa+kI7AF
         xhjH1gbZQEHRMLPWwOF03sWJJRF6ywOKkREW1RG9Pj/JXTqBeZevKXgERBui/nmGf6kK
         lacg==
X-Gm-Message-State: AOAM530zvZm9+wXoXkePIRYZ/K2+IYHYvfLf4oj+lo2yD0VCFlHKtkhs
        4adeRSeJRXZhjW+YvGKOlSPGhIjllHY=
X-Google-Smtp-Source: ABdhPJwLDhSmFqLmLzZ8srDQFHJADiLRuIYJeRuvToQMhz3NoYZP7cQIWcZxbxPbPBdgMbaKnoqWkg==
X-Received: by 2002:a63:2cc4:: with SMTP id s187mr24098304pgs.233.1624901509737;
        Mon, 28 Jun 2021 10:31:49 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o1sm15214298pfk.152.2021.06.28.10.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 10:31:48 -0700 (PDT)
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
To:     Can Guo <cang@codeaurora.org>
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c7d9e12d-f966-44c6-27dc-4004143398aa@acm.org>
Date:   Mon, 28 Jun 2021 10:31:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ea968eb95ef03ef16a420e7483680b75@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/21 1:17 AM, Can Guo wrote:
> On 2021-06-25 01:11, Bart Van Assche wrote:
>> On 6/23/21 11:31 PM, Can Guo wrote:
>>> Using back host_sem in suspend_prepare()/resume_complete() won't have
>>> this problem of deadlock, right?
>>
>> Although that would solve the deadlock discussed in this email thread, it
>> wouldn't solve the issue of potential adverse interactions of the UFS
>> error handler and the SCSI error handler running concurrently.
> 
> I think I've explained it before, paste it here -
> 
> ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and flushes it,
> so SCSI error handler and UFS error handler can safely run together.

That code path is the exception. Do you agree that the following three
functions all invoke the ufshcd_err_handler() function asynchronously?
* ufshcd_uic_pwr_ctrl()
* ufshcd_check_errors()
* ufshcd_abort()

>> How about using the
>> standard approach for invoking the UFS error handler instead of using
>> a custom
>> mechanism, e.g. by using something like the (untested) patch below? This
>> approach guarantees that the UFS error handler is only activated after
>> all
>> pending SCSI commands have failed or timed out and also guarantees
>> that no new
>> SCSI commands will be queued while the UFS error handler is in
>> progress (see
>> also scsi_host_queue_ready()).
> 
> Per my understanding, SCSI error handling is scsi cmd based, meaning it
> only works when certain SCSI cmds failed [ ... ]
That is not completely correct. The SCSI error handler is activated if
either all pending commands have failed or if it is scheduled
explicitly. Please take a look at the host_eh_scheduled member variable,
how it is used and also at scsi_schedule_eh(). The scsi_schedule_eh()
function was introduced in 2006 and that the ATA code uses it since then
to activate the SCSI error handler even if no commands are pending. See
also the patch "SCSI: make scsi_implement_eh() generic API for SCSI
transports".

> However, most UFS (UIC) errors happens during gear scaling, clk gating
> and suspend/resume (due to power mode changes and/or hibern8
> enter/exit), during which there is NO scsi cmds in UFS driver at all
> (because these contexts start only when there is no ongoing data
> transactions).

Activating the SCSI error handler if no SCSI commands are in progress is
supported by scsi_schedule_eh().

> Thus, scsi_unjam_host() won't even call scsi_eh_ready_devs() because
> scsi_eh_get_sense() always returns TRUE in these cases (eh_work_q is
> empty).

Please take another look at the patch in my previous message. There is a
scsi_transport_template instance in that patch. The eh_strategy_handler
defined in a SCSI transport template is called *instead* of
scsi_unjam_host(). In other words, scsi_unjam_host() won't be called if
my patch would be applied to the UFS driver.

Please let me know if you need more information.

Bart.
