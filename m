From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V3 3/4] scsi: ufs: Fix device and host reset methods
Date: Mon, 29 Jul 2013 15:15:58 +0530
Message-ID: <51F639D6.7070302@codeaurora.org>
References: <1373361378-30749-1-git-send-email-sthumma@codeaurora.org> <1373361378-30749-4-git-send-email-sthumma@codeaurora.org> <002101ce8487$dd3dcf70$97b96e50$%jun@samsung.com> <51E984E8.90405@codeaurora.org> <001801ce877e$768e7640$63ab62c0$%jun@samsung.com> <51EEA408.3040903@codeaurora.org> <001901ce8873$2f5d66f0$8e1834d0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <001901ce8873$2f5d66f0$8e1834d0$%jun@samsung.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/24/2013 7:09 PM, Seungwon Jeon wrote:
> On Wed, July 24, 2013, Sujit Reddy Thumma wrote:
>> On 7/23/2013 1:57 PM, Seungwon Jeon wrote:
>>> On Sat, July 20, 2013, Sujit Reddy Thumma wrote:
>>>> On 7/19/2013 7:27 PM, Seungwon Jeon wrote:
>>>>> On Tue, July 09, 2013, Sujit Reddy Thumma wrote:
>>>>>> As of now SCSI initiated error handling is broken because,
>>>>>> the reset APIs don't try to bring back the device initialized and
>>>>>> ready for further transfers.
>>>>>>
>>>>>> In case of timeouts, the scsi error handler takes care of handling aborts
>>>>>> and resets. Improve the error handling in such scenario by resetting the
>>>>>> device and host and re-initializing them in proper manner.
>>>>>>
>>>>>> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>>>>>> ---
>>>>>>     drivers/scsi/ufs/ufshcd.c |  467 +++++++++++++++++++++++++++++++++++++++------
>>>>>>     drivers/scsi/ufs/ufshcd.h |    2 +
>>>>>>     2 files changed, 411 insertions(+), 58 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>>>> index 51ce096..b4c9910 100644
>>>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>>>> @@ -69,9 +69,15 @@ enum {
>>>>>>
>>>>>>     /* UFSHCD states */
>>>>>>     enum {
>>>>>> -	UFSHCD_STATE_OPERATIONAL,
>>>>>>     	UFSHCD_STATE_RESET,
>>>>>>     	UFSHCD_STATE_ERROR,
>>>>>> +	UFSHCD_STATE_OPERATIONAL,
>>>>>> +};
>>>>>> +
>>>>>> +/* UFSHCD error handling flags */
>>>>>> +enum {
>>>>>> +	UFSHCD_EH_HOST_RESET_PENDING = (1 << 0),
>>>>>> +	UFSHCD_EH_DEVICE_RESET_PENDING = (1 << 1),
>>>>>>     };
>>>>>>
>>>>>>     /* Interrupt configuration options */
>>>>>> @@ -87,6 +93,22 @@ enum {
>>>>>>     	INT_AGGR_CONFIG,
>>>>>>     };
>>>>>>
>>>>>> +#define ufshcd_set_device_reset_pending(h) \
>>>>>> +	(h->eh_flags |= UFSHCD_EH_DEVICE_RESET_PENDING)
>>>>>> +#define ufshcd_set_host_reset_pending(h) \
>>>>>> +	(h->eh_flags |= UFSHCD_EH_HOST_RESET_PENDING)
>>>>>> +#define ufshcd_device_reset_pending(h) \
>>>>>> +	(h->eh_flags & UFSHCD_EH_DEVICE_RESET_PENDING)
>>>>>> +#define ufshcd_host_reset_pending(h) \
>>>>>> +	(h->eh_flags & UFSHCD_EH_HOST_RESET_PENDING)
>>>>>> +#define ufshcd_clear_device_reset_pending(h) \
>>>>>> +	(h->eh_flags &= ~UFSHCD_EH_DEVICE_RESET_PENDING)
>>>>>> +#define ufshcd_clear_host_reset_pending(h) \
>>>>>> +	(h->eh_flags &= ~UFSHCD_EH_HOST_RESET_PENDING)
>>>>>> +
>>>>>> +static void ufshcd_tmc_handler(struct ufs_hba *hba);
>>>>>> +static void ufshcd_async_scan(void *data, async_cookie_t cookie);
>>>>>> +
>>>>>>     /*
>>>>>>      * ufshcd_wait_for_register - wait for register value to change
>>>>>>      * @hba - per-adapter interface
>>>>>> @@ -851,9 +873,22 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>>>>>>
>>>>>>     	tag = cmd->request->tag;
>>>>>>
>>>>>> -	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
>>>>>> +	switch (hba->ufshcd_state) {
>>>>> Lock is no needed for ufshcd_state?
>>> Please check?
>>
>> Yes, it is needed. Thanks for catching this.
>>
>>>
>>>>>
>>>>>> +	case UFSHCD_STATE_OPERATIONAL:
>>>>>> +		break;
>>>>>> +	case UFSHCD_STATE_RESET:
>>>>>>     		err = SCSI_MLQUEUE_HOST_BUSY;
>>>>>>     		goto out;
>>>>>> +	case UFSHCD_STATE_ERROR:
>>>>>> +		set_host_byte(cmd, DID_ERROR);
>>>>>> +		cmd->scsi_done(cmd);
>>>>>> +		goto out;
>>>>>> +	default:
>>>>>> +		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
>>>>>> +				__func__, hba->ufshcd_state);
>>>>>> +		set_host_byte(cmd, DID_BAD_TARGET);
>>>>>> +		cmd->scsi_done(cmd);
>>>>>> +		goto out;
>>>>>>     	}
>>>>>>
>>>>>>     	/* acquire the tag to make sure device cmds don't use it */
>>>>>> @@ -1573,8 +1608,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>>>>>>     	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>>>>>>     		scsi_unblock_requests(hba->host);
>>>>>>
>>>>>> -	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>>>>>> -
>>>>>>     out:
>>>>>>     	return err;
>>>>>>     }
>>>>>> @@ -2273,6 +2306,106 @@ out:
>>>>>>     }
>>>>>>
>>>>>>     /**
>>>>>> + * ufshcd_utrl_is_rsr_enabled - check if run-stop register is enabled
>>>>>> + * @hba: per-adapter instance
>>>>>> + */
>>>>>> +static bool ufshcd_utrl_is_rsr_enabled(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	return ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_RUN_STOP) & 0x1;
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_utmrl_is_rsr_enabled - check if run-stop register is enabled
>>>>>> + * @hba: per-adapter instance
>>>>>> + */
>>>>>> +static bool ufshcd_utmrl_is_rsr_enabled(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	return ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_RUN_STOP) & 0x1;
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_complete_pending_tasks - complete outstanding tasks
>>>>>> + * @hba: per adapter instance
>>>>>> + *
>>>>>> + * Abort in-progress task management commands and wakeup
>>>>>> + * waiting threads.
>>>>>> + *
>>>>>> + * Returns non-zero error value when failed to clear all the commands.
>>>>>> + */
>>>>>> +static int ufshcd_complete_pending_tasks(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	u32 reg;
>>>>>> +	int err = 0;
>>>>>> +	unsigned long flags;
>>>>>> +
>>>>>> +	if (!hba->outstanding_tasks)
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	/* Clear UTMRL only when run-stop is enabled */
>>>>>> +	if (ufshcd_utmrl_is_rsr_enabled(hba))
>>>>>> +		ufshcd_writel(hba, ~hba->outstanding_tasks,
>>>>>> +				REG_UTP_TASK_REQ_LIST_CLEAR);
>>>>>> +
>>>>>> +	/* poll for max. 1 sec to clear door bell register by h/w */
>>>>>> +	reg = ufshcd_wait_for_register(hba,
>>>>>> +			REG_UTP_TASK_REQ_DOOR_BELL,
>>>>>> +			hba->outstanding_tasks, 0, 1000, 1000);
>>>>>> +	if (reg & hba->outstanding_tasks)
>>>>>> +		err = -ETIMEDOUT;
>>>>>> +
>>>>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>>>>>> +	/* complete commands that were cleared out */
>>>>>> +	ufshcd_tmc_handler(hba);
>>>>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>>>> +out:
>>>>>> +	if (err)
>>>>>> +		dev_err(hba->dev, "%s: failed, still pending = 0x%.8x\n",
>>>>>> +				__func__, reg);
>>>>>> +	return err;
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_complete_pending_reqs - complete outstanding requests
>>>>>> + * @hba: per adapter instance
>>>>>> + *
>>>>>> + * Abort in-progress transfer request commands and return them to SCSI.
>>>>>> + *
>>>>>> + * Returns non-zero error value when failed to clear all the commands.
>>>>>> + */
>>>>>> +static int ufshcd_complete_pending_reqs(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	u32 reg;
>>>>>> +	int err = 0;
>>>>>> +	unsigned long flags;
>>>>>> +
>>>>>> +	/* check if we completed all of them */
>>>>>> +	if (!hba->outstanding_reqs)
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	/* Clear UTRL only when run-stop is enabled */
>>>>>> +	if (ufshcd_utrl_is_rsr_enabled(hba))
>>>>>> +		ufshcd_writel(hba, ~hba->outstanding_reqs,
>>>>>> +				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>>>>>> +
>>>>>> +	/* poll for max. 1 sec to clear door bell register by h/w */
>>>>>> +	reg = ufshcd_wait_for_register(hba,
>>>>>> +			REG_UTP_TRANSFER_REQ_DOOR_BELL,
>>>>>> +			hba->outstanding_reqs, 0, 1000, 1000);
>>>>>> +	if (reg & hba->outstanding_reqs)
>>>>>> +		err = -ETIMEDOUT;
>>>>>> +
>>>>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>>>>>> +	/* complete commands that were cleared out */
>>>>>> +	ufshcd_transfer_req_compl(hba);
>>>>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>>>> +out:
>>>>>> +	if (err)
>>>>>> +		dev_err(hba->dev, "%s: failed, still pending = 0x%.8x\n",
>>>>>> +				__func__, reg);
>>>>>> +	return err;
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>>      * ufshcd_fatal_err_handler - handle fatal errors
>>>>>>      * @hba: per adapter instance
>>>>>>      */
>>>>>> @@ -2306,8 +2439,12 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
>>>>>>     	}
>>>>>>     	return;
>>>>>>     fatal_eh:
>>>>>> -	hba->ufshcd_state = UFSHCD_STATE_ERROR;
>>>>>> -	schedule_work(&hba->feh_workq);
>>>>>> +	/* handle fatal errors only when link is functional */
>>>>>> +	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
>>>>>> +		/* block commands at driver layer until error is handled */
>>>>>> +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
>>>>> Locking omitted for ufshcd_state?
>>>> This is called in interrupt context with spin_lock held.
>>> Right, I missed it.
>>>
>>>>
>>>>>
>>>>>> +		schedule_work(&hba->feh_workq);
>>>>>> +	}
>>>>>>     }
>>>>>>
>>>>>>     /**
>>>>>> @@ -2475,75 +2612,155 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int
>>>> task_id,
>>>>>>     }
>>>>>>
>>>>>>     /**
>>>>>> - * ufshcd_device_reset - reset device and abort all the pending commands
>>>>>> - * @cmd: SCSI command pointer
>>>>>> + * ufshcd_dme_end_point_reset - Notify device Unipro to perform reset
>>>>>> + * @hba: per adapter instance
>>>>>>      *
>>>>>> - * Returns SUCCESS/FAILED
>>>>>> + * UIC_CMD_DME_END_PT_RST resets the UFS device completely, the UFS flags,
>>>>>> + * attributes and descriptors are reset to default state. Callers are
>>>>>> + * expected to initialize the whole device again after this.
>>>>>> + *
>>>>>> + * Returns zero on success, non-zero on failure
>>>>>>      */
>>>>>> -static int ufshcd_device_reset(struct scsi_cmnd *cmd)
>>>>>> +static int ufshcd_dme_end_point_reset(struct ufs_hba *hba)
>>>>>>     {
>>>>>> -	struct Scsi_Host *host;
>>>>>> -	struct ufs_hba *hba;
>>>>>> -	unsigned int tag;
>>>>>> -	u32 pos;
>>>>>> -	int err;
>>>>>> -	u8 resp;
>>>>>> -	struct ufshcd_lrb *lrbp;
>>>>>> +	struct uic_command uic_cmd = {0};
>>>>>> +	int ret;
>>>>>>
>>>>>> -	host = cmd->device->host;
>>>>>> -	hba = shost_priv(host);
>>>>>> -	tag = cmd->request->tag;
>>>>>> +	uic_cmd.command = UIC_CMD_DME_END_PT_RST;
>>>>>>
>>>>>> -	lrbp = &hba->lrb[tag];
>>>>>> -	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
>>>>>> -			UFS_LOGICAL_RESET, &resp);
>>>>>> -	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
>>>>>> -		err = FAILED;
>>>>>> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>>>>>> +	if (ret)
>>>>>> +		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
>>>>>> +
>>>>>> +	return ret;
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_dme_reset - Local UniPro reset
>>>>>> + * @hba: per adapter instance
>>>>>> + *
>>>>>> + * Returns zero on success, non-zero on failure
>>>>>> + */
>>>>>> +static int ufshcd_dme_reset(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	struct uic_command uic_cmd = {0};
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	uic_cmd.command = UIC_CMD_DME_RESET;
>>>>>> +
>>>>>> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>>>>>> +	if (ret)
>>>>>> +		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
>>>>>> +
>>>>>> +	return ret;
>>>>>> +
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_dme_enable - Local UniPro DME Enable
>>>>>> + * @hba: per adapter instance
>>>>>> + *
>>>>>> + * Returns zero on success, non-zero on failure
>>>>>> + */
>>>>>> +static int ufshcd_dme_enable(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	struct uic_command uic_cmd = {0};
>>>>>> +	int ret;
>>>>>> +	uic_cmd.command = UIC_CMD_DME_ENABLE;
>>>>>> +
>>>>>> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>>>>>> +	if (ret)
>>>>>> +		dev_err(hba->dev, "%s: error code %d\n", __func__, ret);
>>>>>> +
>>>>>> +	return ret;
>>>>>> +
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * ufshcd_device_reset_and_restore - reset and restore device
>>>>>> + * @hba: per-adapter instance
>>>>>> + *
>>>>>> + * Note that the device reset issues DME_END_POINT_RESET which
>>>>>> + * may reset entire device and restore device attributes to
>>>>>> + * default state.
>>>>>> + *
>>>>>> + * Returns zero on success, non-zero on failure
>>>>>> + */
>>>>>> +static int ufshcd_device_reset_and_restore(struct ufs_hba *hba)
>>>>>> +{
>>>>>> +	int err = 0;
>>>>>> +	u32 reg;
>>>>>> +
>>>>>> +	err = ufshcd_dme_end_point_reset(hba);
>>>>>> +	if (err)
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	/* restore communication with the device */
>>>>>> +	err = ufshcd_dme_reset(hba);
>>>>>> +	if (err)
>>>>>>     		goto out;
>>>>>> -	} else {
>>>>>> -		err = SUCCESS;
>>>>>> -	}
>>>>>>
>>>>>> -	for (pos = 0; pos < hba->nutrs; pos++) {
>>>>>> -		if (test_bit(pos, &hba->outstanding_reqs) &&
>>>>>> -		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
>>>>>> +	err = ufshcd_dme_enable(hba);
>>>>>> +	if (err)
>>>>>> +		goto out;
>>>>>>
>>>>>> -			/* clear the respective UTRLCLR register bit */
>>>>>> -			ufshcd_utrl_clear(hba, pos);
>>>>>> +	err = ufshcd_dme_link_startup(hba);
>>>>> UFS_LOGICAL_RESET is no more used?
>>>>
>>>> Yes, I don't see any use for this as of now (given that we are using
>>>> dme_end_point_reset, refer to figure. 7.4 of UFS 1.1 spec). Also, the
>>>> UFS spec. error handling section doesn't mention anything about
>>>> LOGICAL_RESET. If you know a valid use case where we need to have LUN
>>>> reset, please let me know I will bring it back.
>>> As refered the scsi-mid layer and other host's implementation,
>>> eh_device_reset_handler(= ufshcd_eh_device_reset_handler) may
>>> have a role of LOGICAL_RESET for specific lun.
>>
>> I am still not convinced why we need LOGICAL_RESET. Just because other
>> SCSI host drivers have it do we really need it for UFS?
>>
>>> I found that ENDPOINT_RESET is recommended with IS.DFES in spec.
>>
>> Here in this case, a command hang (scsi timeout) is considered as Device
>> Fatal Error. If there are some LUN failures the response would still be
>> transferred but with Unit-Attention condition with sense data. However,
>> if the command itself hangs, there is something seriously wrong with the
>> device or the communication. So we first try to reset the device and
>> then the host. Unlike most of other SCSI HBAs, UFS is point-to-point
>> (host <--> device) link and if something goes wrong and caused a hang,
>> mostly would be a serious error and logical unit reset wouldn't help
>> much.
> As far as UFS follows the SAM-5 model, LOGICAL_RESET should be considered.
> LOGICAL_RESET would be handled in 'eh_device_reset_handler' as I see it.
> And it looks like actual device reset is close to 'eh_target_reset_handler'.

Okay. I will retain the LOGICAL_RESET then. It looks like for UFS there
is no point in doing device reset only without doing host resetSo I
will retain the flow with some fixups..
I haven't gone into the details but target_reset_handler is used by
SCSI target modules, so not sure if it appropriate for UFS.

> 
>>
>>
>>>
>>> Let me add some comments additionally.
>>> Both 'ufshcd_eh_device_reset_handler' and 'ufshcd_host_reset_and_restore' do almost same things.
>>> At a glance, it's confused about their role and It is mixed.
>>> 'ufshcd_reset_and_restore' is eventually called, which is actual part of reset functionality; Once
>> device reset is failed, then
>>> host reset is tried.
>>> Actually, that is being handled for each level of error recovery in scsi mid-layer. Please chekc
>> 'drivers/scsi/scsi_error.c'.
>>> [scsi_eh_ready_devs, scsi_abort_eh_cmnd]
>>> In this stage, each reset functionality could be separated obviously.
>>
>> Yes, in that case we are optimistically doing the host reset twice,
>> just a hope that it recovers before SCSI layer choke and mark the
>> device as OFFLINE. If you think that this shouldn't be the case and
>> have a valid reason for not doing so, I will return appropriate error
>> in the case device reset fails.
> The two are much the same actually.
> To simplify implementation in host driver, leaving it to scsi mid-layer would be better.
> Eventually, the controlling of callback function is from upper layer.

Okay.

> 
>>
>>>
>>>>
>>>>> ufshcd_device_reset_and_restore have a role of device reset.
>>>>> Both ufshcd_dme_reset and ufshcd_dme_enable are valid for local one, not for remote.
>>>>> Should we do those for host including link-startup here?
>>>>
>>>> Yes, it is needed. After DME_ENDPOINT_RESET the remote link goes into link down state.
>>> I want to know more related description. I didn't find it. Could you point that?
>>
>> Please refer to "Table 121 DME_SAP restrictions" of MIPI Uni-Pro spec.
>> The spec. doesn't mention about this explicitly but here is the logic
>> that is derived from the spec.
>> 1) The DME_LINKSTARTUP can be sent only when the link is in down state,
>> in all other states DME_LINKSTARTUP is ignored.
>> 2) So if we are sending DME_ENDPOINT_RESET then that must ensure that
>> remote link is in down state, and hence it can receive linkstartup and
>> establish the communication.
>>
>>>
>>>> To initialize the link, the host needs to send
>>>> DME_LINKSTARTUP, but according to Uni-Pro spec. the link-startup can
>>>> only be sent when the local uni-pro is in link-down state. So first
>>> If it's right you mentioned above, uni-pro state is already in link-down after DME_ENDPOINT_RESET.
>>> Then, DME_RESET isn't needed.
>>
>> You are getting confused here -
> Yeah, I'm mixed up with link-down of remote side you mentioned.
> There is no special saying about link state after receiving DME_ENDPOINT_RESET in spec.
> I just found the point that link startup is initiated.
> It means that link startup is triggered from remote device after DME_ENDPOINT_RESET.
> In that case, host will detect ULSS(UIC Link Startup Status) interrupt.
> After that, host shall start link startup procedure with DME_RESET.

Yes, either way it works.

> Of course, your approach could be acceptable.
> 
>>
>> - State1: before sending DME_ENDPOINT_RESET
>> 	Local Unipro (host) - Link-UP
>> 	Remote Unipro (device) - Link-Up
>>
>> - State2: after sending DME_ENDPOINT_RESET
>> 	Local Unipro (host) - Link-UP
>> 	Remote Unipro (device) - Link-Down
>>
>> - State3: After sending DME_RESET+DME_ENABLE
>> 	Local Unipro (host) - Link-Down
>> 	Remote Unipro (device) - Link-Down
>>
>> - State4: After sending DME_LINKSTARTUP
>> 	Local Unipro(host) - Link-up
>> 	Remote Unipro (device) - Link-up
>>
>> The local unipro ignores the DME_LINKSTARTUP if we send it before
>> DME_RESET.
>>
>>>
>>>> we need to get the local unipro from link-up to disabled to link-down
>>>> using the DME_RESET and DME_ENABLE commands and then issue
>>>> DME_LINKSTARTUP to re-initialize the link.
>>> 'ufshcd_hba_enable' can be used instead of both if these are really needed.
>>> This will do dme_reset and dme_enable.
>>>
>>
>> The only reason for this is that in some implementations the HCE reset
>> also resets UTP layer in addition to Uni-Pro layer. There is no need
>> of UTP layer reset for device reset. So explicit DME_RESET and
>> DME_ENABLE is used. For those implementations which don't do UTP layer
>> reset then the advantage is instead of wasting CPU cycles in polling for
>> HCE=1 we depend on UIC interrupts.
> HCE reset can involve the additional unipro configurations, depending
> host controller implementation.
> As considering that unipro stack is reset with DME_RESET,
> usage of individual DME_RESET might be inappropriate during link startup.

Hmm.. yes, HCI spec. mentions this so I can't disagree.


-- 
Regards,
Sujit
