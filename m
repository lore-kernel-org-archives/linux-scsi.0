From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/1] scsi: ufs: Generalize UFS Interconnect Layer (UIC)
 command support
Date: Thu, 02 May 2013 17:03:22 +0530
Message-ID: <51824F02.9070103@codeaurora.org>
References: <1366736234-8964-1-git-send-email-sthumma@codeaurora.org> <CALMYJDtE=GnETSi7KfLCWWqow3Let3Q5aL70ei3MkJKH6FWzFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CALMYJDtE=GnETSi7KfLCWWqow3Let3Q5aL70ei3MkJKH6FWzFg@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/2/2013 12:49 PM, Santosh Y wrote:
>> -static inline void
>> -ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>> +static int ufshcd_send_uic_command(struct ufs_hba *hba,
>> +               struct uic_command *uic_cmnd, int retries)
>>   {
>> +       int err = 0;
>> +       unsigned long flags;
>> +
>> +       if (unlikely(mutex_trylock(&hba->uic_cmd_mutex))) {
>> +               mutex_unlock(&hba->uic_cmd_mutex);
>> +               dev_err(hba->dev, "%s: called without prepare command\n",
>> +                               __func__);
>> +               BUG();
>> +       }
>> +
>> +retry:
>> +       /* check if controller is ready to accept UIC commands */
>> +       if (!(readl(hba->mmio_base + REG_CONTROLLER_STATUS) &
>> +                               UIC_COMMAND_READY)) {
>> +               dev_err(hba->dev, "Controller not ready to accept UIC commands\n");
>> +               err = -EIO;
>> +               goto out;
>> +       }
>> +
>> +       init_completion(&uic_cmnd->completion);
>> +
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +
>> +       /* enable UIC related interrupts */
>> +       if (!(hba->int_enable_mask & UIC_COMMAND_COMPL)) {
>> +               hba->int_enable_mask |= UIC_COMMAND_COMPL;
>> +               ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
>> +       }
>> +
>
> No need to check if the interrupt is already enabled, it can be
> directly enabled.

That would be unnecessary device access (writel) every time we send a 
UIC command.

>
>
>>          /* Write Args */
>>          writel(uic_cmnd->argument1,
>>                (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
>> @@ -415,6 +491,45 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>>          /* Write UIC Cmd */
>>          writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
>>                 (hba->mmio_base + REG_UIC_COMMAND));
>> +
>> +       /* flush to make sure h/w sees the write */
>> +       readl(hba->mmio_base + REG_UIC_COMMAND);
>> +
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +
>
> mutex lock/unlock can be done in the send_uic_command, It will
> simplify the process for the caller.

  ufshcd_dme_get_attr()
  {
    1) ufshcd_prepare_uic_command_lck();
    2) ufshcd_send_uic_command();
    3) Read arg3 to know the value of Uni-pro attribute.
    4) ufshcd_unprepare_uic_command_unlck();
  }

Step 3 above is optional for some of the UIC commands but when it is 
required it should be done with mutex lock held as the 
hba->active_uic_cmd might be modified by some one else before value 
present hba->active_uic_cmd->argument3 is read.

But thinking more on this holding lock only in send_uic_command() is 
feasible.

>
>> +       err = wait_for_completion_timeout(
>> +                       &uic_cmnd->completion, UIC_COMMAND_TIMEOUT);
>> +       if (!err) {
>> +               err = -ETIMEDOUT;
>> +       } else if (uic_cmnd->argument2 & MASK_UIC_COMMAND_RESULT) {
>> +               /* something bad with h/w or arguments, try again */
>> +               if (--retries)
>> +                       goto retry;
>> +
>

-- 
Regards,
Sujit
