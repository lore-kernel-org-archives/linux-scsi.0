Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AB3C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213D12196E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DM1iTS34";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UE9aPwJv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKMDBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:01:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfKMDBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 22:01:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0AFCE60EE5; Wed, 13 Nov 2019 03:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573614109;
        bh=BipDRM2O/OZqpn2UIsa5kp5hdDb04ZWLuxjfRN7HIrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DM1iTS34AU1idWXs6MkhxblaNFJcv+9ciBNUrdkmZK8rkwSsjtQr/B/eF3td01z57
         kCex6YcqHipWehXmzIAR49Af3pEE8FFBKQAqh5VBviND1aODTT7ubGkTu50J9tWbPO
         9xHdils+h91bQ6N33GXTbUfbtcH3a+zbWlny6Yqw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D5BDE6088D;
        Wed, 13 Nov 2019 03:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573614105;
        bh=BipDRM2O/OZqpn2UIsa5kp5hdDb04ZWLuxjfRN7HIrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UE9aPwJvuWpw5VgcMxLLS5DMrfL03LnojckUNnNY2q1wGpSb98hElH+NK15rLf8lX
         wPUxZm+xVo1XI/SvxigioSyQEEI2I7F+cs7BXGpBGAV+/1iz1IPNzNwEqmcahhyHN2
         3Uewx2AzOMhwB3tGgXTW7H+nN6azxAyxjupgGKnk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Nov 2019 11:01:44 +0800
From:   cang@codeaurora.org
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 5/5] scsi: ufs: Complete pending requests in host reset
 and restore path
In-Reply-To: <CAGOxZ502wp17UFEk67Qno9DQ0dFPfwMRTLNTCvOXibQDhOw4SA@mail.gmail.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-6-git-send-email-cang@codeaurora.org>
 <CAGOxZ502wp17UFEk67Qno9DQ0dFPfwMRTLNTCvOXibQDhOw4SA@mail.gmail.com>
Message-ID: <ceffae90eaaa1e042b816bf707e01835@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-13 10:24, Alim Akhtar wrote:
> Hi Can,
> 
> On Fri, Nov 8, 2019 at 1:50 PM Can Guo <cang@codeaurora.org> wrote:
>> 
>> In UFS host reset and restore path, before probe, we stop and start 
>> the
>> host controller once. After host controller is stopped, the pending
>> requests, if any, are cleared from the doorbell, but no completion IRQ
>> would be raised due to the hba is stopped.
>> These pending requests shall be completed along with the first NOP_OUT
>> command(as it is the first command which can raise a transfer 
>> completion
>> IRQ) sent during probe.
>> Since the OCSs of these pending requests are not SUCCESS(because they 
>> are
>> not yet literally finished), their UPIUs shall be dumped. When there 
>> are
>> multiple pending requests, the UPIU dump can be overwhelming and may 
>> lead
>> to stability issues because it is in atomic context.
>> Therefore, before probe, complete these pending requests right after 
>> host
>> controller is stopped.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
> Looks good, I hope this is tested on your platform.
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> 

Hi Alim,

Thanks for the review. We've tested it out on our platforms.

Best regards,
Can Guo.

>>  drivers/scsi/ufs/ufshcd.c | 20 +++++++-------------
>>  1 file changed, 7 insertions(+), 13 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 5950a7c..4df4136 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5404,8 +5404,8 @@ static void ufshcd_err_handler(struct 
>> work_struct *work)
>> 
>>         /*
>>          * if host reset is required then skip clearing the pending
>> -        * transfers forcefully because they will automatically get
>> -        * cleared after link startup.
>> +        * transfers forcefully because they will get cleared during
>> +        * host reset and restore
>>          */
>>         if (needs_reset)
>>                 goto skip_pending_xfer_clear;
>> @@ -6333,9 +6333,13 @@ static int ufshcd_host_reset_and_restore(struct 
>> ufs_hba *hba)
>>         int err;
>>         unsigned long flags;
>> 
>> -       /* Reset the host controller */
>> +       /*
>> +        * Stop the host controller and complete the requests
>> +        * cleared by h/w
>> +        */
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>>         ufshcd_hba_stop(hba, false);
>> +       ufshcd_complete_requests(hba);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>>         /* scale up clocks to max frequency before full 
>> reinitialization */
>> @@ -6369,7 +6373,6 @@ static int ufshcd_host_reset_and_restore(struct 
>> ufs_hba *hba)
>>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>>  {
>>         int err = 0;
>> -       unsigned long flags;
>>         int retries = MAX_HOST_RESET_RETRIES;
>> 
>>         do {
>> @@ -6379,15 +6382,6 @@ static int ufshcd_reset_and_restore(struct 
>> ufs_hba *hba)
>>                 err = ufshcd_host_reset_and_restore(hba);
>>         } while (err && --retries);
>> 
>> -       /*
>> -        * After reset the door-bell might be cleared, complete
>> -        * outstanding requests in s/w here.
>> -        */
>> -       spin_lock_irqsave(hba->host->host_lock, flags);
>> -       ufshcd_transfer_req_compl(hba);
>> -       ufshcd_tmc_handler(hba);
>> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -
>>         return err;
>>  }
>> 
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
