Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24868C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 21:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E0F61D9F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 21:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhF2VxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 17:53:16 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27271 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233660AbhF2VxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 17:53:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625003448; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=c9ZTy6wsSUIhfQiqgTgWllWy4l2AVYPvlTdBnb0OFe0=;
 b=bUrrmNz2ZDVHfkw7waVV5WC5z7Oc73UmpCDi5zBiRbTBH/tF1KQkzOopNHijhZNp+HKsaA9j
 O8Ja2sp4kwj5pc+qQngOvcMb4XzJRfp7IhK2ltVnDfYmM8x12aJi8FZLYx4xjx0mM06HB9uD
 JcdYK6C6vI6XbtL753uTOHPPEGc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60db95b82a2a9a97614b3589 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Jun 2021 21:50:48
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DED8AC43143; Tue, 29 Jun 2021 21:50:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4278C433F1;
        Tue, 29 Jun 2021 21:50:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Jun 2021 05:50:46 +0800
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
In-Reply-To: <ddf72aae-6a0a-06e3-daf8-84b922d7eb52@acm.org>
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
 <ddf72aae-6a0a-06e3-daf8-84b922d7eb52@acm.org>
Message-ID: <ecf749fc88220910563704ef41939d40@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-30 02:01, Bart Van Assche wrote:
> On 6/28/21 11:23 PM, Can Guo wrote:
>> On 2021-06-29 01:31, Bart Van Assche wrote:
>>> On 6/28/21 1:17 AM, Can Guo wrote:
>>>> On 2021-06-25 01:11, Bart Van Assche wrote:
>>>>> On 6/23/21 11:31 PM, Can Guo wrote:
>>>>>> Using back host_sem in suspend_prepare()/resume_complete()
>>>>>> won't have this problem of deadlock, right?
>>>>> 
>>>>> Although that would solve the deadlock discussed in this email
>>>>> thread, it wouldn't solve the issue of potential adverse
>>>>> interactions of the UFS error handler and the SCSI error
>>>>> handler running concurrently.
>>>> 
>>>> I think I've explained it before, paste it here -
>>>> 
>>>> ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and
>>>> flushes it, so SCSI error handler and UFS error handler can
>>>> safely run together.
>>> 
>>> That code path is the exception. Do you agree that the following
>>> three functions all invoke the ufshcd_err_handler() function
>>> asynchronously? * ufshcd_uic_pwr_ctrl() * ufshcd_check_errors() *
>>> ufshcd_abort()
>> 
>> I agree, but I don't see what's wrong with that. Any context can
>> invoke ufs error handler asynchronously and ufs error handler prepare
>> makes sure error handler can work safely, i.e., stopping PM
>> ops/gating/scaling in error handler prepare makes sure no one shall
>> call ufshcd_uic_pwr_ctrl() ever again. And ufshcd_check_errors() and
>> ufshcd_abort() are OK to run concurrently with UFS error handler.
> 
> The current UFS error handling approach requires the following code in
> ufshcd_queuecommand():
> 
> 		if (hba->pm_op_in_progress) {
> 			hba->force_reset = true;
> 			set_host_byte(cmd, DID_BAD_TARGET);
> 			cmd->scsi_done(cmd);
> 			goto out;
> 		}
> 
> Removing that code is not possible with the current error handling
> approach. My patch makes it possible to remove that code.
> 
>> Sorry that I missed the change of scsi_transport_template() in your
>> previous message. I can understand that you want to invoke UFS error
>> hander by invoking SCSI error handler, but I didn't go that far
>> because I saw you changed pm_runtime_get_sync() to
>> pm_runtime_get_noresume() in ufs error handler prepare. How can that
>> change make sure that the device is not suspending or resuming while
>> error handler is running?
> 
> UFS power state transitions happen by submitting a SCSI command to a
> WLUN. The SCSI error handler is only activated after all outstanding
> SCSI commands for a SCSI host have failed or completed. I think this
> guarantees for the UFS driver that eh_strategy_handler is not invoked
> while a command submitted to a WLUN is changing the power state of the
> UFS device. The following code from scsi_error.c only wakes up the 
> error
> handler if (shost->host_failed || shost->host_eh_scheduled) &&
> shost->host_failed == scsi_host_busy(shost):
> 
> 	if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0)
> 	    || shost->host_failed != scsi_host_busy(shost)) {
> 		schedule();
> 		continue;
> 	}
> 	/* Handle SCSI errors */
> 

It is not completely right - wl_suspend/resume() are much more twisted.

wl_suspend() may or may NOT send a SCSI cmd to WLUN, i.e., SSU cmd may
be skipped if spm/rpm_lvl is 0/1 and/or if bkops/wb is on-going (even 
when
rpm_lvl is not 0/1), while link can still be put to hibern8/off, then
power/clks can still be shutdown to save power.

wl_resume(), in case of rpm/spm_lvl == 5, does a full reset to UFS 
device,
without sending a SSU cmd to WLU to complete the power state transition.

So above checks (in scsi_error_handler()) cannot gaurantee that actual
power state transistions in UFS driver has ceased before start UFS error
handling.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
