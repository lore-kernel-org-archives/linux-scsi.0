Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B16C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 01:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D21219FA
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 01:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VAAUxtrZ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LRZnYRxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfKSBg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:36:28 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:53526
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfKSBg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 20:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574127387;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=gu0VjLFeEaynap/88TiNlWcXPPYqNHDR0ClbwmBdRGY=;
        b=VAAUxtrZIz+6M1F7k1+jk+qa1T4ZmM1W40ccZ9muxYtXhfR/85SlGZBBMFXRiASA
        yKOj+XCvq5Mwr4oVw0+w8/T9gT/Jua67g3c+ZXC2R3SKfaS+SNcf+0c5fkGuOIS1qe7
        /smkQXwesa8x/nAzOyiHSQOsfvtlrERGrcA0LFH0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574127387;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=gu0VjLFeEaynap/88TiNlWcXPPYqNHDR0ClbwmBdRGY=;
        b=LRZnYRxWv1tToV9a+xDGcOe1bjySH1viP7qAWDYUSjmk3Z2Xb55F43IC3AZqE2L3
        cf4jGGZzvko8j1KCcsjipHFE6sfGOAYOU8rO9DUXHFp/YU9uIltEupQFjnAlANBvGwf
        CDBJyIyVcA0tnXzkdi/Dj3xG2y/re4WZErMB9t6Q=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 Nov 2019 01:36:27 +0000
From:   cang@codeaurora.org
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     Can Guo <cang@qti.qualcomm.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, Mark Salyzyn <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: Complete pending requests in host reset
 and restore path
In-Reply-To: <CAGOxZ53Z6je9Omuh2k=wVJrGVKZDfsfx6=mUJ-8QiRk-2q3u0g@mail.gmail.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-5-git-send-email-cang@qti.qualcomm.com>
 <CAGOxZ53Z6je9Omuh2k=wVJrGVKZDfsfx6=mUJ-8QiRk-2q3u0g@mail.gmail.com>
Message-ID: <0101016e814dc1ec-bde59f85-9e2c-48f9-bae3-202b2a3d24bd-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.19-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-18 21:23, Alim Akhtar wrote:
> On Mon, Nov 18, 2019 at 9:22 AM Can Guo <cang@qti.qualcomm.com> wrote:
>> 
>> From: Can Guo <cang@codeaurora.org>
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
>> controller is stopped and silence the UPIU dump from them.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
> 
> Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> Please add all previous Ack/reviewed and tested-by tags so that we are
> aware what need to be done for this patch.
> Thanks
> 

Hi Alim,

Thanks for pointing out it. I updated the patch a little bit so I think 
the
prevoius tags are not valid any more.

Best Regards,
Can Guo.

>>  drivers/scsi/ufs/ufshcd.c | 24 ++++++++++--------------
>>  drivers/scsi/ufs/ufshcd.h |  2 ++
>>  2 files changed, 12 insertions(+), 14 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 5950a7c..b92a3f4 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -4845,7 +4845,7 @@ static void ufshcd_slave_destroy(struct 
>> scsi_device *sdev)
>>                 break;
>>         } /* end of switch */
>> 
>> -       if (host_byte(result) != DID_OK)
>> +       if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
>>                 ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
>>         return result;
>>  }
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
>> @@ -6333,9 +6333,15 @@ static int ufshcd_host_reset_and_restore(struct 
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
>> +       hba->silence_err_logs = true;
>> +       ufshcd_complete_requests(hba);
>> +       hba->silence_err_logs = false;
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>>         /* scale up clocks to max frequency before full 
>> reinitialization */
>> @@ -6369,7 +6375,6 @@ static int ufshcd_host_reset_and_restore(struct 
>> ufs_hba *hba)
>>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>>  {
>>         int err = 0;
>> -       unsigned long flags;
>>         int retries = MAX_HOST_RESET_RETRIES;
>> 
>>         do {
>> @@ -6379,15 +6384,6 @@ static int ufshcd_reset_and_restore(struct 
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
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index e0fe247..1e51034 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -513,6 +513,7 @@ struct ufs_stats {
>>   * @uic_error: UFS interconnect layer error status
>>   * @saved_err: sticky error mask
>>   * @saved_uic_err: sticky UIC error mask
>> + * @silence_err_logs: flag to silence error logs
>>   * @dev_cmd: ufs device management command information
>>   * @last_dme_cmd_tstamp: time stamp of the last completed DME command
>>   * @auto_bkops_enabled: to track whether bkops is enabled in device
>> @@ -670,6 +671,7 @@ struct ufs_hba {
>>         u32 saved_err;
>>         u32 saved_uic_err;
>>         struct ufs_stats ufs_stats;
>> +       bool silence_err_logs;
>> 
>>         /* Device management request data */
>>         struct ufs_dev_cmd dev_cmd;
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
