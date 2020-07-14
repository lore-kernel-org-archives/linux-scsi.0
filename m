Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8E2C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 09:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA7021D7D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 09:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LshnPlZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGNJNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 05:13:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:38490 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgGNJNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 05:13:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594717998; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=OpGstJziG3b+lewJ4OJkEErFnXU4CBYWekCcjmKdfZw=;
 b=LshnPlZAzMp5FaSHCr3Eh+LHeFDZeVZ/wURHFdr0nREf4PewMrmUoJi/LxG2pEkubO/m4qJ/
 wgwUIka0XxqUpYODF8QVK7Z0LDpquBU2zUpnRBLivjVI3B/NjmvinvjYkL2ufJ690DDlbG1L
 1t9AL9HGeoOpYZIhNCNxOMXEAiU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f0d772e166c1c5494060808 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Jul 2020 09:13:18
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 452A4C433B1; Tue, 14 Jul 2020 09:13:17 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 270ABC433C8;
        Tue, 14 Jul 2020 09:13:16 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jul 2020 17:13:16 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: Fix up and simplify error recovery
 mechanism
In-Reply-To: <47e7a4ec9a0404bc6d01818fcdad90eb@codeaurora.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
 <1594693693-22466-5-git-send-email-cang@codeaurora.org>
 <fe00619c-f337-397f-9ccf-7babda095210@acm.org>
 <47e7a4ec9a0404bc6d01818fcdad90eb@codeaurora.org>
Message-ID: <5fb1e82c97a480e5330337a240a12633@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-07-14 12:26, Can Guo wrote:
> Hi Bart,
> 
> On 2020-07-14 11:52, Bart Van Assche wrote:
>> On 2020-07-13 19:28, Can Guo wrote:
>>> o Queue eh_work on a single threaded workqueue to avoid concurrency 
>>> between
>>>   eh_works.
>> 
>> Please use another approach (mutex?) to serialize error handling. 
>> There are
>> already way too workqueues in a running Linux system.
>> 

Yeah, mutex works, but in this change, we need to flush the eh_work. As 
per
test, in real cases, flush_work can trigger warnings if the work is 
queued on
system_wq. Please check func check_flush_dependency().

>>> o According to the UFSHCI JEDEC spec, hibern8 enter/exit error occurs 
>>> when
>>>   the link is broken. This actaully applies to any power mode change
>>>   operations. In this change, if a power mode change operation 
>>> (including
>>>   AH8 enter/exit) fails, mark the link state as UIC_LINK_BROKEN_STATE 
>>> and
>>>   schedule eh_work. eh_work needs to do full reset and restore to 
>>> recover
>>>   the link back to active. Before the link state is recovered to 
>>> active by
>>>   eh_work, any power mode change attempts just return -ENOLINK to 
>>> avoid
>>>   consecutive HW error.
>>> 
>>> o To avoid concurrency between eh_work and link recovery, remove link
>>>   recovery from hibern8 enter/exit func. If hibern8 enter/exit func 
>>> fails,
>>>   simply return error code and let eh_work run in parallel.
>>> 
>>> o Recover UFS hba runtime PM error in eh_work. If 
>>> ufschd_suspend/resume
>>>   fails due to UFS error, e.g. hibern8 enter/exit error and SSU cmd 
>>> error,
>>>   the runtime PM framework saves the error to 
>>> dev.power.runtime_error.
>>>   After that, hba runtime suspend/resume would not be invoked anymore 
>>> until
>>>   dev.power.runtime_error is cleared. The runtime PM error can be 
>>> recovered
>>>   in eh_work by calling pm_runtime_set_active() after reset and 
>>> restore
>>>   succeeds. Meanwhile, if pm_runtime_set_active() returns no error, 
>>> which
>>>   means dev.power.runtime_error is cleared, we also need to 
>>> explicitly
>>>   resume those scsi devices under hba in case any of them has failed 
>>> to be
>>>   resumed due to hba runtime resume error.
>>> 
>>> o Fix a racing problem between eh_work and ufshcd_suspend/resume. In 
>>> the
>>>   old code, it blocks scsi requests before schedules eh_work, but 
>>> when
>>>   eh_work calls pm_runtime_get_sync(), if ufshcd_suspend/resume is 
>>> sending
>>>   a scsi cmd, most likely the SSU cmd, pm_runtime_get_sync() will 
>>> never
>>>   return because scsi requests were blocked. To fix this racing 
>>> problem,
>>>   o Don't block scsi requests before schedule eh_work, but let 
>>> eh_work
>>>     block scsi requests when eh_work is ready to start error 
>>> recovery.
>>>   o Meanwhile, if eh_work is schueduled due to fatal error, don't 
>>> requeue
>>>     the scsi cmds sent from ufshcd_suspend/resume path, but simply 
>>> let the
>>>     scsi cmds fail. If the scsi cmds fail, hba runtime suspend/resume 
>>> fails
>>>     too, but it does hurt since eh_work recovers hba runtime PM 
>>> error.
>>> 
>>> o Move host/regs dump in ufshcd_check_errors() to eh_work because 
>>> heavy
>>>   dump in IRQ context can lead to stability issues. In addition, some 
>>> clean
>>>   up in ufshcd_print_host_regs() and ufshcd_print_host_state().
>> 
>> The above list is a long list. To me that is a sign that this patch 
>> needs to
>> be split into multiple patches.
>> 
>> Thanks,
>> 
>> Bart.
> 
> Sure, will split it into a few patches.
> 
> Thanks,
> 
> Can Guo.

I tried, but I find it hard to split it as it works as a whole, it is a 
refactor
change rather than a mixture of multiple fixes. I will try to refine the 
commit
msg in next version. So it goes just as it is now.

Thanks,

Can Guo.
