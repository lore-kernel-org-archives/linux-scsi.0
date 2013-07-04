From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V2 4/4] scsi: ufs: Improve UFS fatal error handling
Date: Thu, 04 Jul 2013 13:14:25 +0530
Message-ID: <51D527D9.5070509@codeaurora.org>
References: <1372444531-24340-1-git-send-email-sthumma@codeaurora.org> <1372444531-24340-5-git-send-email-sthumma@codeaurora.org> <CALMYJDszHtT53BHDgepw5D2Sk_Zz+vWedY_Bucd4-FBCWcaYeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42193 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3GDHob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jul 2013 03:44:31 -0400
In-Reply-To: <CALMYJDszHtT53BHDgepw5D2Sk_Zz+vWedY_Bucd4-FBCWcaYeA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On 7/3/2013 10:22 PM, Santosh Y wrote:
>> +
>> +/**
>> + * ufshcd_fatal_err_handler - handle fatal errors
>> + * @work: pointer to work structure
>>    */
>>   static void ufshcd_fatal_err_handler(struct work_struct *work)
>>   {
>>          struct ufs_hba *hba;
>> +       unsigned long flags;
>> +       u32 err_xfer = 0;
>> +       u32 err_tm = 0;
>> +       int err;
>> +
>>          hba = container_of(work, struct ufs_hba, feh_workq);
>>
>> -       /* check if reset is already in progress */
>> -       if (hba->ufshcd_state != UFSHCD_STATE_RESET)
>> -               ufshcd_do_reset(hba);
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
>> +               /* complete processed requests and exit */
>> +               ufshcd_transfer_req_compl(hba);
>> +               ufshcd_tmc_handler(hba);
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +               return;
>
> I could not go through this patch yet, please check if it needs to
> wait here until the state is 'operational' or 'error'.
> The 'reset' state might be due to the device reset also.

As of now reset is scheduled only in two contexts -
1) Fatal error handling
2) SCSI error handling

If scsi error handling is in progress it changes the state to
UFSHCD_STATE_RESET. If fatal error interrupt is raised it checks
whether the state is operational or not before scheduling the work.
So in any case, there is no race between fatal error handler
and the scsi error handler and hence there is no need any wait here.

static void ufshcd_err_handler(struct ufs_hba *hba)
{
...

  fatal_eh:
-       hba->ufshcd_state = UFSHCD_STATE_ERROR;
-       schedule_work(&hba->feh_workq);
+       /* handle fatal errors only when link is functional */
+       if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
+               /* block commands from midlayer */
+               scsi_block_requests(hba->host);
+
+               /* block commands at driver layer until error is handled */
+               hba->ufshcd_state = UFSHCD_STATE_ERROR;
+               schedule_work(&hba->feh_workq);
+       }
  }


>
>> +       }
>> +
>> +       hba->ufshcd_state = UFSHCD_STATE_RESET;
>> +       ufshcd_error_autopsy_transfer_req(hba, &err_xfer);
>> +       ufshcd_error_autopsy_task_req(hba, &err_tm);
>> +
>
>

-- 
Regards,
Sujit
