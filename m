Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25179C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 18:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A61961DD7
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 18:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhF2SEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 14:04:24 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:44027 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhF2SEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2021 14:04:24 -0400
Received: by mail-pj1-f54.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso2987105pjp.2;
        Tue, 29 Jun 2021 11:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2ZtiF+TtydPZL+N+/zutiqV/u+eDJHq4C/EhYfFVq8=;
        b=IAXNf9lyaagbuwU9crTfdtTDGg71NIFlnlF1bcElSo0yi4rn1BEb93Z8FLz+vl5NM/
         BMbF1UC9sXRfZm4c8pOIjl1QJBdQy3S1FO2XpYHKJI/M1PErJCn5Epnjp73+eW5zfYR+
         EHMvbzA+8+6XvAjo5B1bT7ZZetWTubDOs7XUOd8+eM4IcX7lmTKQNWs6hTzXxoBrXNdV
         Y6pjYu20aWluyP/d5kk31hCQemTX+BqWhS7GAUsD6W/veuVnVlllZ6f+W+qAYlIO1Ua8
         2zJaGJt//vHG8BvJ2d8NVpPbyhep0QcA4PPLDpBnOpHGtlRUV0GYJ+qN3nELQwvwcYEy
         XFqw==
X-Gm-Message-State: AOAM530pRBpb3kp14DRXhF6hZCoHuwuI07baRqLPdBlNU0zraYSVFphY
        Ex8y8yUhFJdlgfaKoBCgnklHIZmsi98=
X-Google-Smtp-Source: ABdhPJxomtCBTJUTgLpudc9opLFN1qPC17RPYtM9pZ/z4VOqJtvMI8ky9bFsIcfLEWZILc+YoQTaVA==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr35783455pjb.52.1624989715857;
        Tue, 29 Jun 2021 11:01:55 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 190sm19278911pgd.1.2021.06.29.11.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 11:01:55 -0700 (PDT)
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
 <c7d9e12d-f966-44c6-27dc-4004143398aa@acm.org>
 <60a5496863100976b74d8c376c9e9cb0@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ddf72aae-6a0a-06e3-daf8-84b922d7eb52@acm.org>
Date:   Tue, 29 Jun 2021 11:01:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60a5496863100976b74d8c376c9e9cb0@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/21 11:23 PM, Can Guo wrote:
> On 2021-06-29 01:31, Bart Van Assche wrote:
>> On 6/28/21 1:17 AM, Can Guo wrote:
>>> On 2021-06-25 01:11, Bart Van Assche wrote:
>>>> On 6/23/21 11:31 PM, Can Guo wrote:
>>>>> Using back host_sem in suspend_prepare()/resume_complete()
>>>>> won't have this problem of deadlock, right?
>>>> 
>>>> Although that would solve the deadlock discussed in this email 
>>>> thread, it wouldn't solve the issue of potential adverse
>>>> interactions of the UFS error handler and the SCSI error
>>>> handler running concurrently.
>>> 
>>> I think I've explained it before, paste it here -
>>> 
>>> ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and 
>>> flushes it, so SCSI error handler and UFS error handler can
>>> safely run together.
>> 
>> That code path is the exception. Do you agree that the following
>> three functions all invoke the ufshcd_err_handler() function
>> asynchronously? * ufshcd_uic_pwr_ctrl() * ufshcd_check_errors() *
>> ufshcd_abort()
> 
> I agree, but I don't see what's wrong with that. Any context can
> invoke ufs error handler asynchronously and ufs error handler prepare
> makes sure error handler can work safely, i.e., stopping PM
> ops/gating/scaling in error handler prepare makes sure no one shall
> call ufshcd_uic_pwr_ctrl() ever again. And ufshcd_check_errors() and
> ufshcd_abort() are OK to run concurrently with UFS error handler.

The current UFS error handling approach requires the following code in
ufshcd_queuecommand():

		if (hba->pm_op_in_progress) {
			hba->force_reset = true;
			set_host_byte(cmd, DID_BAD_TARGET);
			cmd->scsi_done(cmd);
			goto out;
		}

Removing that code is not possible with the current error handling
approach. My patch makes it possible to remove that code.

> Sorry that I missed the change of scsi_transport_template() in your 
> previous message. I can understand that you want to invoke UFS error
> hander by invoking SCSI error handler, but I didn't go that far
> because I saw you changed pm_runtime_get_sync() to
> pm_runtime_get_noresume() in ufs error handler prepare. How can that
> change make sure that the device is not suspending or resuming while
> error handler is running?

UFS power state transitions happen by submitting a SCSI command to a
WLUN. The SCSI error handler is only activated after all outstanding
SCSI commands for a SCSI host have failed or completed. I think this
guarantees for the UFS driver that eh_strategy_handler is not invoked
while a command submitted to a WLUN is changing the power state of the
UFS device. The following code from scsi_error.c only wakes up the error
handler if (shost->host_failed || shost->host_eh_scheduled) &&
shost->host_failed == scsi_host_busy(shost):

	if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0)
	    || shost->host_failed != scsi_host_busy(shost)) {
		schedule();
		continue;
	}
	/* Handle SCSI errors */

Thanks,

Bart.
