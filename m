From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 4/5] scsi: ufs: rework link start-up process
Date: Thu, 2 May 2013 13:28:54 +0530
Message-ID: <CALMYJDtdsCz9_jYG5nZDLDmf7ZcL7PUv8JZ=56A6+T2z__FX4g@mail.gmail.com>
References: <002101ce4105$b184dec0$148e9c40$%jun@samsung.com>
 <5178B97F.3060405@codeaurora.org> <000c01ce423c$e11a6f00$a34f4d00$%jun@samsung.com>
 <517DF613.3060702@codeaurora.org> <000901ce44c3$b42a5df0$1c7f19d0$%jun@samsung.com>
 <517E701D.4000403@codeaurora.org> <001601ce456c$ad1b8710$07529530$%jun@samsung.com>
 <517F8431.1080901@codeaurora.org> <002201ce46f4$1a1bff10$4e53fd30$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59662 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3EBH7Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 03:59:16 -0400
Received: by mail-bk0-f49.google.com with SMTP id e19so129973bku.36
        for <linux-scsi@vger.kernel.org>; Thu, 02 May 2013 00:59:14 -0700 (PDT)
In-Reply-To: <002201ce46f4$1a1bff10$4e53fd30$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Thu, May 2, 2013 at 10:45 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Tuesday, April 30, 2013, Sujit Reddy Thumma wrote:
>> On 4/30/2013 12:03 PM, Seungwon Jeon wrote:
>> > On Monday, April 29, 2013, Sujit Reddy Thumma wrote:
>> >> On 4/29/2013 3:54 PM, Seungwon Jeon wrote:
>> >>> On Monday, April 29, 2013, Sujit Reddy Thumma wrote:
>> >>>> On 4/26/2013 10:44 AM, Seungwon Jeon wrote:
>> >>>>> On Thursday, April 25, 2013 , Sujit Reddy Thumma wrote:
>> >>>>>> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
>> >>>>>>> Link start-up requires long time with multiphase handshakes
>> >>>>>>> between UFS host and device. This affects driver's probe time.
>> >>>>>>> This patch let link start-up run asynchronously.
>> >>>>>>> And completion time of uic command is defined to avoid a
>> >>>>>>> permanent wait.
>> >>>>>>
>> >>>>>> I have similar patch posted few days back "scsi: ufs: Generalize UFS
>> >>>>>> Interconnect Layer (UIC) command support" which does a bit more (mutex,
>> >>>>>> error handling) than what is done here. Can that be used/improved?
>> >>>>> I completed to check your patch to compare it now.
>> >>>>> Though it's just my thought, the patch I sent is more intuitive on the whole.
>> >>>>> Considering other dme operations which I have introduced, it looks like matched.
>> >>>>
>> >>>> There are lot of code duplications you might want to minimize building a
>> >>>> DME command.
>> >>>>
>> >>>>> Of course, you may disagree.
>> >>>>> But I think the part of mutex is needed. It's a good point.
>> >>>>> In case of error handling, I didn't catch nothing special.
>> >>>>> Rather, handling link lost case is not proper.
>> >>>>> When ufs host meets link lost status, it should start with dme_reset not retried dme_linkstartup.
>> >>>>
>> >>>> In section 7.2.1 (Host Controller Initialization) of JESD223A UFS HCI
>> >>>> v1.1  specification I find this -
>> >>>>
>> >>>> 6. Sent DME_LINKSTARTUP command to start the link startup procedure
>> >>>> 9. Check value of HCS.DP and make sure that there is a device attached
>> >>>> to the Link. If presence of a device is detected, go to step 10;
>> >>>> otherwise, resend the DME_LINKSTARTUP command after IS.ULLS has been set
>> >>>> to 1 (Go to step 6). IS.ULLS equal 1 indicates that the UFS Device is
>> >>>> ready for a link startup.
>> >>>>
>> >>>> Going by the spec. just retrying with DME_LINKSTARTUP is correct.
>> >>> Yes, as you quoted above, HCI standard mentions that.
>> >>> Also, the following is mentioned.
>> >>> UIC Link Lost Status (ULLS) corresponds to the UniPro DME_LINKLOST.ind
>> >>> I just referred unipro specification.
>> >>> When DME_LINKLOST.ind is generated, this affects the Link is put in the LinkLost state.
>> >>> Unipro spec says that DME User must apply a DME_RESET to redo the boot sequence.
>> >>> If there is misunderstood meaning and I have something to miss, we can discuss more.
>> >>> Please let me know.
>> >>
>> >> Yes, it looks like the two specs. are conflicting each other. I guess we
>> >> need to take this to Jedec for clarification. Meanwhile, to be on safe
>> >> side can we add a retry mechanism that does ufshcd_hba_enable() before
>> >> sending DME_LINKSTARTUP again? This way we can be sure that the
>> >> DME_RESET and DME_ENABLE is taken care by the host reset itself.
>> > Yes, If the latter case is applied, 'ufshcd_hba_enable' will be start entry for retry.
>> > Further, IS.ULLS could be handled through the interrupt instead of polling for retry mechanism?
>>
>> Agree, but the interrupt handling will be tailored for two things - 1)
>> bootup case where scsi_scan_host is not yet called. 2) the case where
>> link lost occurred after a long time after bootup where there is no need
>> to do scsi_scan_host again.
> Yes, it could be another patch.
>
>>
>> >
>> >>
>> >>>
>> >>>>
>> >>>> In addition, it doesn't say what happens if IS.ULLS never sets to 1.
>> >>>> Probably, the case which never happens.
>> >>>>
>> >>>>> And it would be good if link start-up procedure is done in separate process, not in driver probe.
>> >>>> True.

Yes, but the probe should be notified of the link-startup status.

>> >>>>
>> >>>>> If it's all right with you, I'd like to update lock mechanism for uic command.
>> >>>>> I can add your signed-off. Please let me know your opinion.

If you decide to combine the patches, then please do the lock/unlock
in send_uic_command.


>> >>>> I would like to get a third opinion as both the patches needs modifications.
>> >>>>
>> >>>> Some comments below:
>> >>>>
>> >>>>>>
>> >>>>>>>
>> >>>>>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> >>>>>>> ---
>> >>>>>>>      drivers/scsi/ufs/ufshcd.c |  114 +++++++++++++++++++++++++++++++++-----------
>> >>>>>>>      drivers/scsi/ufs/ufshcd.h |    6 ++-
>> >>>>>>>      2 files changed, 89 insertions(+), 31 deletions(-)
>> >>>>>>>
>> >>>>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> >>>>>>> index efe2256..76ff332 100644
>> >>>>>>> --- a/drivers/scsi/ufs/ufshcd.c
>> >>>>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>> >>>>>>> @@ -38,6 +38,7 @@
>> >>>>>>>      #define UFSHCD_ENABLE_INTRS      (UTP_TRANSFER_REQ_COMPL |\
>> >>>>>>>                                UTP_TASK_REQ_COMPL |\
>> >>>>>>>                                UFSHCD_ERROR_MASK)
>> >>>>>>> +#define UIC_CMD_TIMEOUT      100
>> >>>>>>>
>> >>>>>>>      enum {
>> >>>>>>>       UFSHCD_MAX_CHANNEL      = 0,
>> >>>>>>> @@ -357,13 +358,15 @@ static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> - * ufshcd_send_uic_command - Send UIC commands to unipro layers
>> >>>>>>> + * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
>> >>>>>>>       * @hba: per adapter instance
>> >>>>>>>       * @uic_command: UIC command
>> >>>>>>>       */
>> >>>>>>>      static inline void
>> >>>>>>> -ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>> >>>>>>> +ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>> >>>>>>>      {
>> >>>>>>> +     init_completion(&uic_cmnd->done);
>> >>>>>>> +
>> >>>>>>>       /* Write Args */
>> >>>>>>>       ufshcd_writel(hba, REG_UIC_COMMAND_ARG_1, uic_cmnd->argument1);
>> >>>>>>>       ufshcd_writel(hba, REG_UIC_COMMAND_ARG_2, uic_cmnd->argument2);
>> >>>>>>> @@ -375,6 +378,45 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> + * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
>> >>>>>>> + * @hba: per adapter instance
>> >>>>>>> + * @uic_command: UIC command
>> >>>>>>> + *
>> >>>>>>> + * Returns 0 only if success.
>> >>>>>>> + */
>> >>>>>>> +static int ufshcd_wait_for_uic_cmd(struct ufs_hba *hba)
>> >>>>>>> +{
>> >>>>>>> +     struct uic_command *uic_cmd = &hba->active_uic_cmd;
>> >>>>>>> +     int ret;
>> >>>>>>> +
>> >>>>>>> +     if (wait_for_completion_timeout(&uic_cmd->done,
>> >>>>>>> +                                     msecs_to_jiffies(UIC_CMD_TIMEOUT)))
>> >>>>>>> +             ret = ufshcd_get_uic_cmd_result(hba);
>> >>>>>>> +     else
>> >>>>>>> +             ret = -ETIMEDOUT;
>> >>>>>>> +
>> >>>>>>> +     return ret;
>> >>>>>>> +}
>> >>>>>>> +
>> >>>>>>> +/**
>> >>>>>>> + * ufshcd_ready_uic_cmd - Check if controller is ready
>> >>>>>>> + *                        to accept UIC commands
>> >>>>>>> + * @hba: per adapter instance
>> >>>>>>> + * Return true on success, else false
>> >>>>>>> + */
>> >>>>>>> +static inline bool ufshcd_ready_uic_cmd(struct ufs_hba *hba)
>> >>>>>>> +{
>> >>>>>>> +     if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY) {
>> >>>>>>> +             return true;
>> >>>>>>> +     } else {
>> >>>>>>> +             dev_err(hba->dev,
>> >>>>>>> +                             "Controller not ready"
>> >>>>>>> +                             " to accept UIC commands\n");
>> >>>>>>> +             return false;
>> >>>>>>> +     }
>> >>>>>>> +}
>> >>>>>>> +
>> >>>>>>> +/**
>> >>>>>>>       * ufshcd_map_sg - Map scatter-gather list to prdt
>> >>>>>>>       * @lrbp - pointer to local reference block
>> >>>>>>>       *
>> >>>>>>> @@ -735,15 +777,10 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>> >>>>>>>      {
>> >>>>>>>       struct uic_command *uic_cmd;
>> >>>>>>>       unsigned long flags;
>> >>>>>>> +     int ret;
>> >>>>>>>
>> >>>>>>> -     /* check if controller is ready to accept UIC commands */
>> >>>>>>> -     if (((ufshcd_readl(hba, REG_CONTROLLER_STATUS)) &
>> >>>>>>> -         UIC_COMMAND_READY) == 0x0) {
>> >>>>>>> -             dev_err(hba->dev,
>> >>>>>>> -                     "Controller not ready"
>> >>>>>>> -                     " to accept UIC commands\n");
>> >>>>>>> +     if (!ufshcd_ready_uic_cmd(hba))
>> >>>>>>>               return -EIO;
>> >>>>>>> -     }
>> >>>>>>>
>> >>>>>>>       spin_lock_irqsave(hba->host->host_lock, flags);
>> >>>>>>>
>> >>>>>>> @@ -754,13 +791,16 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>> >>>>>>>       uic_cmd->argument2 = 0;
>> >>>>>>>       uic_cmd->argument3 = 0;
>> >>>>>>>
>> >>>>>>> -     /* enable UIC related interrupts */
>> >>>>>>> -     ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>> >>>>>>> +     /* Dispatching UIC commands to controller */
>> >>>>>>> +     ufshcd_dispatch_uic_cmd(hba, uic_cmd);
>> >>>>>>>
>> >>>>>>> -     /* sending UIC commands to controller */
>> >>>>>>> -     ufshcd_send_uic_command(hba, uic_cmd);
>> >>>>>>>       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> >>>>>>> -     return 0;
>> >>>>>>> +
>> >>>>>>> +     ret = ufshcd_wait_for_uic_cmd(hba);
>> >>>>
>> >>>> Error code is incorrect. only -ETIMEDOUT is valid others are just DME
>> >>>> errors.
>> >>> Only success returns '0', other positive value from dme and -ETIMEDOUT mean failure.
>> >>> Error code can be reused purely, not being redefined.
>> >>> I am seeing that -EINVAL represents from 01h to 07h in your handling.
>> >>> It looks like error's detail is disappear. Exact return might be needed from DME.
>> >> okay.
>> >>
>> >>>
>> >>>>
>> >>>> Also, spec. clearly mentions a retry mechanism which means that there
>> >>>> could be some timing issues anticipated where the UIC layer cannot
>> >>>> respond properly.
>> >>> Sorry, I didn't catch your meaning fully. Where can I refer to it?
>> >>
>> >> I meant the same retry mechanism mentioned in the section 7.2.1 (Host
>> >> Controller Initialization) of JESD223A UFS HCI v1.1.
>> >>
>> >>>
>> >>>>
>> >>>>
>> >>>>>>> +     if (ret)
>> >>>>>>> +             dev_err(hba->dev, "link startup: error code %d returned\n", ret);
>> >>>>>>> +
>> >>>>>>> +     return ret;
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> @@ -898,6 +938,9 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
>> >>>>>>>       if (ufshcd_hba_enable(hba))
>> >>>>>>>               return -EIO;
>> >>>>>>>
>> >>>>>>> +     /* enable UIC related interrupts */
>> >>>>>>> +     ufshcd_enable_intr(hba, UIC_COMMAND_COMPL | UIC_ERROR);
>> >>>>
>> >>>> The recovery when UIC_ERROR happens is broken because of re-entrancy to
>> >>>> dme_link_startup from ufshcd_fatal_err_handler(). So better handle with
>> >>>> timeout than allowing controller to raise a UIC_ERROR until that is fixed?
>> >>> I also recognize error handling should be done further.
>> >>> Ok, I agree with you.
>> >>>
>> >>>>
>> >>>>>>> +
>> >>>>>>>       /* Configure UTRL and UTMRL base address registers */
>> >>>>>>>       ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_BASE_L,
>> >>>>>>>                     lower_32_bits(hba->utrdl_dma_addr));
>> >>>>>>> @@ -909,7 +952,9 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
>> >>>>>>>                     upper_32_bits(hba->utmrdl_dma_addr));
>> >>>>>>>
>> >>>>>>>       /* Initialize unipro link startup procedure */
>> >>>>>>> -     return ufshcd_dme_link_startup(hba);
>> >>>>>>> +     schedule_work(&hba->link_startup_wq);
>> >>>>>>> +
>> >>>>>>> +     return 0;
>> >>>>>>>      }

With this approach, always success is returned to the probe
irrespective of link-startup result.
Also if the link-startup fails there is no mechanism to retry the
procedure. So it is better to combine it with Sujith's patch.

>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> @@ -1186,6 +1231,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> + * ufshcd_uic_cmd_compl - handle completion of uic command
>> >>>>>>> + * @hba: per adapter instance
>> >>>>>>> + */
>> >>>>>>> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>> >>>>>>> +{
>> >>>>>>> +     if (intr_status & UIC_COMMAND_COMPL)
>> >>>>
>> >>>> why this redundant check if it is already checked in ufshcd_sl_intr()?
>> >>> Yes, it's currently not needed.
>> >>> It will be used to identify several uic command. ([PATCH 5/5] scsi: ufs: add dme operations)
>> >>> Anyway, it's better to be removed here.
>> >>>
>> >>>>
>> >>>>>>> +             complete(&hba->active_uic_cmd.done);
>> >>>>>>> +}
>> >>>>>>> +
>> >>>>>>> +/**
>> >>>>>>>       * ufshcd_transfer_req_compl - handle SCSI and query command completion
>> >>>>>>>       * @hba: per adapter instance
>> >>>>>>>       */
>> >>>>>>> @@ -1225,25 +1280,26 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> - * ufshcd_uic_cc_handler - handle UIC command completion
>> >>>>>>> + * ufshcd_link_startup - link initialization
>> >>>>>>>       * @work: pointer to a work queue structure
>> >>>>>>> - *
>> >>>>>>> - * Returns 0 on success, non-zero value on failure
>> >>>>>>>       */
>> >>>>>>> -static void ufshcd_uic_cc_handler (struct work_struct *work)
>> >>>>>>> +static void ufshcd_link_startup(struct work_struct *work)
>> >>>>>>>      {
>> >>>>>>>       struct ufs_hba *hba;
>> >>>>>>> +     int ret;
>> >>>>>>>
>> >>>>>>> -     hba = container_of(work, struct ufs_hba, uic_workq);
>> >>>>>>> +     hba = container_of(work, struct ufs_hba, link_startup_wq);
>> >>>>>>>
>> >>>>>>> -     if ((hba->active_uic_cmd.command == UIC_CMD_DME_LINK_STARTUP) &&
>> >>>>>>> -         !(ufshcd_get_uic_cmd_result(hba))) {
>> >>>>>>> +     ret = ufshcd_dme_link_startup(hba);
>> >>>>>>> +     if (ret)
>> >>>>>>> +             goto out;
>> >>>>>>>
>> >>>>>>> -             if (ufshcd_make_hba_operational(hba))
>> >>>>>>> -                     dev_err(hba->dev,
>> >>>>>>> -                             "cc: hba not operational state\n");
>> >>>>>>> -             return;
>> >>>>>>> -     }
>> >>>>>>> +     ret = ufshcd_make_hba_operational(hba);
>> >>>>>>> +     if (ret)
>> >>>>>>> +             goto out;
>> >>>>>>> +     return;
>> >>>>>>> +out:
>> >>>>>>> +     dev_err(hba->dev, "link startup failed %d\n", ret);
>> >>>>>>>      }
>> >>>>>>>
>> >>>>>>>      /**
>> >>>>>>> @@ -1307,7 +1363,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>> >>>>>>>               ufshcd_err_handler(hba);
>> >>>>>>>
>> >>>>>>>       if (intr_status & UIC_COMMAND_COMPL)
>> >>>>>>> -             schedule_work(&hba->uic_workq);
>> >>>>>>> +             ufshcd_uic_cmd_compl(hba, intr_status);
>> >>>>>>>
>> >>>>>>>       if (intr_status & UTP_TASK_REQ_COMPL)
>> >>>>>>>               ufshcd_tmc_handler(hba);
>> >>>>>>> @@ -1694,7 +1750,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>> >>>>>>>       init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
>> >>>>>>>
>> >>>>>>>       /* Initialize work queues */
>> >>>>>>> -     INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
>> >>>>>>> +     INIT_WORK(&hba->link_startup_wq, ufshcd_link_startup);
>> >>>>
>> >>>> Can we use async function calls kernel/async.c instead of having work
>> >>>> queues as this is only used during boot up?
>> >>> As we know, both probe and resume are sensitive to execution time.
>> >>> I guess link startup procedure will also be activated in driver's resume.
>> >>> Do you have any specific reason for async function?
>> >>>
>> >>
>> >> I guess most UFS devices currently are embedded and have rootfs on them.
>> >> If we use schedule_work there is no synchronization mechanism to check
>> >> whether the device link startup is completed and device is available for
>> >> the userspace to mount the partitions. Having async mechanism in place,
>> >> the prepare_namespace() does wait for such async probes to be completed
>> >> before mounting the rootfs.
>> > I understand your meaning.
>> > If you are considering that, I think 'scsi_scan_host' has a role for that.
>> > 'scsi_scan_host' will be the conclusion and be done in async subsystem.
>> > 'scsi_scan_host' is actually called, after finishing link startup procedure.
>>
>> with this patch the scsi_scan_host() is called after the work is
>> scheduled. Which means that link_startup_wq might be scheduled after
>> prepare_namespace().
> AFAIK, the work is scheduled immediately. So I think we don't need to worry about that.
> I guess you want to gather all of initialization sequence into async mechanism including link startup.
> If your intention is for that reason, it's okay to use async_schedule.
> Then, we may reuse these in driver's resume.
> I should have answered quickly, but I have a day off yesterday.
> If you have any opinion, please let me know.
>
> Thanks,
> Seungwon Jeon
>>
>> >
>> >>
>> >> I agree that the resume is sensitive to execute time but during resume
>> >> you can't schedule link startup work because the fs/block/scsi layer
>> >> expects the device availability as soon as resume operation is
>> >> completed. So ufshcd_link_startup() should be called in the resume
>> >> context itself or implement a synchronization mechanism like blocking
>> >> scsi layer queuing requests until link startup is completed.
>> > 'scsi_block_requests' and  'scsi_unblock_requests' can be used during suspend/resume.
>> > After the link startup is finished and host is ready, 'scsi_unblock_requests' will be called.
>> >
>> > Thanks,
>> > Seungwon Jeon
>> >>
>> >> Would following implementation looks better?
>> >>
>> >>
>> >> ufshcd_async_probe()
>> >> {
>> >> ...
>> >>     ufshcd_link_startup(hba);
>> >> ...
>> >> }
>> >>
>> >> ufshcd_resume()
>> >> {
>> >> ...
>> >> ufshcd_link_startup(hba);
>> >> ...
>> >> }
>> >>
>> >> ufshcd_init()
>> >> {
>> >> ...
>> >> async_schedule(ufshcd_async_probe, hba);
>> >> ...
>> >> }
>> >>
>> >>
>> >> --
>>
>> --
>> Regards,
>> Sujit
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
~Santosh
