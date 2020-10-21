Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6639FC388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 01:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD9C223AB
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 01:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="YEgDmNvF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404546AbgJUBTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 21:19:01 -0400
Received: from z5.mailgun.us ([104.130.96.5]:56098 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393961AbgJUBTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 21:19:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603243140; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Q99/rOnCLxfHaES0uHhwhzsm5Qm580CmW3mR5keYfYY=;
 b=YEgDmNvFk2zHnPq5NsuJO+87l/UhD06n0y1MT/v94nODqYr4LoPVTRNtFuzmmeXP6H+AWuyy
 kDCRwnQIEH1Lk/0SRFsO/OpNJn4rfwj7+X4JuG5oMtGeNqFv0eIsC58igi9L0UEEgflAQa9w
 goYGCtuG+2a3JxSrMtQvZyZxLTc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f8f8c83319d4e9cb56160d2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Oct 2020 01:18:59
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81A20C433FE; Wed, 21 Oct 2020 01:18:59 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BCC4C433C9;
        Wed, 21 Oct 2020 01:18:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 21 Oct 2020 09:18:58 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <beanhuo.cn@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Serialize eh_work with system PM events
 and async scan
In-Reply-To: <e2976fe3f85c2625e42dbddbf61faed651caa5c0.camel@gmail.com>
References: <1600752747-31881-1-git-send-email-cang@codeaurora.org>
 <1600752747-31881-2-git-send-email-cang@codeaurora.org>
 <e2976fe3f85c2625e42dbddbf61faed651caa5c0.camel@gmail.com>
Message-ID: <877678c6b188fc6a85d4d9c6cb7b89c1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-20 22:19, Bean Huo wrote:
> On Mon, 2020-09-21 at 22:32 -0700, Can Guo wrote:
>> Serialize eh_work with system PM events and async scan to make sure
>> eh_work
>> does not run in parallel with them.
>> 
>> Change-Id: I33012c68e2ea443950313c59a4a46ad88cf3c82d
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 64 +++++++++++++++++++++++++++++------
>> ------------
>>  drivers/scsi/ufs/ufshcd.h |  1 +
>>  2 files changed, 41 insertions(+), 24 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 1d8134e..7e764e8 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5597,7 +5597,9 @@ static inline void
>> ufshcd_schedule_eh_work(struct ufs_hba *hba)
>>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>  {
>>  	pm_runtime_get_sync(hba->dev);
>> -	if (pm_runtime_suspended(hba->dev)) {
>> +	if (pm_runtime_status_suspended(hba->dev) || hba-
>> >is_sys_suspended) {
> 
> Hi Can
> 
> I curiously want to know how this can be produced in real system.
> 
> IMO, The system has been in system PM suspeded mode, how can trigger
> error handler? because the tasks have been freezed, the device
> interrupts disabled, before entering system PM suspended mode, the
> tasks in the queue should be completed, otherwises, there is bug in the
> whole flow.
> 
> 
> thanks,
> Bean

Hi Bean,

You might misunderstand here - the hba->is_sys_suspended check is
not for the case that system has entered suspend, but for the case a 
resume
failure happens. If system resume fails, hba->is_sys_suspended is set 
and
powers/clks/IRQs are OFF, so we need to prepare the environments for 
err_handler to run.
To reproduce this scenario, you can fake a hibern8 exit failure during 
system resume.

If the whole system has entered suspend, of course err_handler won't 
run.
I guess your real concern is that if UFS has entered system suspend (not 
the whole system),
but err_handling was somehow scheduled (most likely due to an non-fatal 
error).
This definitely is a problem and it is also why I make this change. With 
this change,
if UFS has entered system suspend, the eh_sem lock is held, err_handler 
won't even get
a chance to run, the err_handler will run only after UFS is resumed.

Thanks,

Can Guo.

