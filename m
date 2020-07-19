Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CD0C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 10:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCA2207DF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 10:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="J/vx/YG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgGSKMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 06:12:47 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:24565 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgGSKMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 06:12:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595153563; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GSlmzBDP0NSSu1I21ho+k3h25dDuJch+YzkY6FRc8v0=;
 b=J/vx/YG9gLc0kxLPDIloGiljj7LBI69DE6EQSM1mgfPtM57fQrTJFNUcXQ5BtJ3HegwUarls
 qHqJM/v9sDgGNBV/ZFZQ3m82tIyCBKdumgeal5zmDJpK0bWs+Eg33d9QChF10s2WZma4jHw/
 /PqEBIBRVay+t52xg8962895gl8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f141c9803c8596cdbc5730c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 19 Jul 2020 10:12:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B2DDAC43395; Sun, 19 Jul 2020 10:12:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15CABC433C9;
        Sun, 19 Jul 2020 10:12:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Jul 2020 18:12:35 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] scsi: ufs: Fix up and simplify error recovery
 mechanism
In-Reply-To: <SN6PR04MB4640B8E98CC82B05B696507BFC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1595045585-16402-1-git-send-email-cang@codeaurora.org>
 <1595045585-16402-5-git-send-email-cang@codeaurora.org>
 <SN6PR04MB4640B8E98CC82B05B696507BFC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
Message-ID: <89251b9385325e62e0cbc62e37955fe0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On 2020-07-19 16:41, Avri Altman wrote:
> Hi,
> 
>> 
>> Current UFS error recovery mechanism has two major problems, and 
>> neither
>> of
>> them is rare.
>> 
>> - Error recovery can be invoked from multiple paths, including hibern8
>>   enter/exit, some vendor vops, ufshcd_eh_host_reset_handler(), resume 
>> and
>>   eh_work scheduled from IRQ context. Ultimately, these paths are 
>> trying to
>>   invoke ufshcd_reset_and_restore(), in either sync or async manner. 
>> Since
>>   there is no proper protection or synchronization, concurrency of 
>> these
>>   paths most likely leads UFS device and host to bad states.
>> 
>> - Error recovery cannot work well or recover hba runtime PM errors if
>>   ufshcd_suspend/resume has failed due to UFS errors, e.g. SSU cmd 
>> error.
>>   When this happens, error handler may fail doing full reset and 
>> restore
>>   because error handler always assumes that powers, IRQs and clocks 
>> are
>>   ready after pm_runtime_get_sync returns, but actually they are not 
>> if
>>   ufshcd_reusme fails [1]. Besides, if ufschd_suspend/resume fails due 
>> to
>>   UFS error, runtime PM framework saves the error to 
>> power.runtime_error.
>>   After that, hba dev runtime suspend/resume would not be invoked 
>> anymore
>>   unless runtime_error is cleared [2].
>> 
>> To fix the concurrency problem, this change queues eh_work on a single
>> threaded workqueue and remove link recovery from hibern8 enter/exit 
>> path.
>> Meanwhile, flushing eh_work in eh_host_reset_handler instead of 
>> calling
>> ufshcd_reset_and_restore.
>> 
>> In case of ufshcd_suspend/resume fails due to UFS errors, for scenario 
>> [1],
>> error handler cannot assume anything of pm_runtime_get_sync, meaning
>> error
>> handler should explicitly turn ON powers, IRQs and clocks. To get the 
>> hba
>> runtime PM work again as regard for scenario [2], error handler can 
>> clear
>> the runtime_error by calling pm_runtime_set_active() if reset and 
>> restore
>> succeeds. Meanwhile, if pm_runtime_set_active() returns no error, 
>> which
>> means runtime_error is cleared, we also need to explicitly resume 
>> those
>> scsi devices under hba in case any of them has failed to be resumed 
>> due to
>> hba runtime resume error.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> May I suggest the following re-arrangement, to make this large patch
> more readable.
> I am not sure that indeed such division is feasible as you are
> attending several concurrencies in the same change.
> The idea is to solve stuff incrementally, so in your last patch
> everything falls into place.
> 
> 1. Introduce link broken state - Add here all changes concerning the
> new state: ufshcd_is_link_broken, ufshcd_set_link_broken, etc.  For
> now, In ufshcd_uic_pwr_ctrl just call schedule_work(&hba->eh_work).
> 
> 2. Introduce eh-scheduled states - Put here the relevant code of the
> new UFSHCD_STATE_EH_SCHEDULED_FATAL and
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL and introduce the new
> ufshcd_schedule_eh_work
> 
> 3. Do not print host states / stats while printing regs - put here the
> changes you made to ufshcd_print_host_regs and
> ufshcd_print_host_state.
> 
> 4. Changes in ufshcd_eh_in_progress /  ufshcd_set_eh_in_progress - can
> this re-arranged as an atomic patch?
> 
> 5. Changes you made to avoid concurrency between eh_work and link 
> recovery
> 
> 6. Changes you made to fix a racing problem between eh_work and
> ufshcd_suspend/resume
> 
> Thanks,
> Avri
> 

Thanks for the suggestions. You are really reading it thoroughly, thanks 
for
that again. It may look that I am trying to fix a lot (or as many as 
possible)
problems in one change, but actually I am just putting things/codes in 
their
right places during the development of this change. The main purpose of 
this
change is to make sure that eh_work is the only context running during 
error
recovery, the other code changes are just trying to guarantee it is 
happening
as expected, so I developed and tested this change as a whole. Anyways, 
I will
try to split them again to make them easier to read (I tried last time 
but
found it was hard to) and come back with next version.

Thanks,

Can Guo.

>> ---
>>  drivers/scsi/ufs/ufs-sysfs.c |   1 +
>>  drivers/scsi/ufs/ufshcd.c    | 454 
>> ++++++++++++++++++++++++++-----------------
>>  drivers/scsi/ufs/ufshcd.h    |  15 ++
>>  3 files changed, 290 insertions(+), 180 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
>> b/drivers/scsi/ufs/ufs-sysfs.c
>> index 2d71d23..02d379f00 100644
>> --- a/drivers/scsi/ufs/ufs-sysfs.c
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -16,6 +16,7 @@ static const char *ufschd_uic_link_state_to_string(
>>         case UIC_LINK_OFF_STATE:        return "OFF";
>>         case UIC_LINK_ACTIVE_STATE:     return "ACTIVE";
>>         case UIC_LINK_HIBERN8_STATE:    return "HIBERN8";
>> +       case UIC_LINK_BROKEN_STATE:     return "BROKEN";
>>         default:                        return "UNKNOWN";
>>         }
>>  }
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 4a34f2a..cb32430 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -15,6 +15,8 @@
>>  #include <linux/of.h>
>>  #include <linux/bitfield.h>
>>  #include <linux/blk-pm.h>
>> +#include <linux/blkdev.h>
>> +#include <scsi/scsi_device.h>
>>  #include "ufshcd.h"
>>  #include "ufs_quirks.h"
>>  #include "unipro.h"
>> @@ -125,7 +127,8 @@ enum {
>>         UFSHCD_STATE_RESET,
>>         UFSHCD_STATE_ERROR,
>>         UFSHCD_STATE_OPERATIONAL,
>> -       UFSHCD_STATE_EH_SCHEDULED,
>> +       UFSHCD_STATE_EH_SCHEDULED_FATAL,
>> +       UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
>>  };
>> 
>>  /* UFSHCD error handling flags */
>> @@ -228,6 +231,11 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, 
>> bool
>> scale_up);
>>  static irqreturn_t ufshcd_intr(int irq, void *__hba);
>>  static int ufshcd_change_power_mode(struct ufs_hba *hba,
>>                              struct ufs_pa_layer_attr *pwr_mode);
>> +static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
>> +static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
>> +static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
>> +static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>> +                                        struct ufs_vreg *vreg);
>>  static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
>>  static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
>>  static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
>> @@ -411,15 +419,6 @@ static void ufshcd_print_err_hist(struct ufs_hba
>> *hba,
>>  static void ufshcd_print_host_regs(struct ufs_hba *hba)
>>  {
>>         ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: 
>> ");
>> -       dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities 
>> =
>> 0x%x\n",
>> -               hba->ufs_version, hba->capabilities);
>> -       dev_err(hba->dev,
>> -               "hba->outstanding_reqs = 0x%x, hba->outstanding_tasks 
>> = 0x%x\n",
>> -               (u32)hba->outstanding_reqs, 
>> (u32)hba->outstanding_tasks);
>> -       dev_err(hba->dev,
>> -               "last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt 
>> = %d\n",
>> -               ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
>> -               hba->ufs_stats.hibern8_exit_cnt);
>> 
>>         ufshcd_print_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
>>         ufshcd_print_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
>> @@ -438,8 +437,6 @@ static void ufshcd_print_host_regs(struct ufs_hba
>> *hba)
>>         ufshcd_print_err_hist(hba, &hba->ufs_stats.host_reset, 
>> "host_reset");
>>         ufshcd_print_err_hist(hba, &hba->ufs_stats.task_abort, 
>> "task_abort");
>> 
>> -       ufshcd_print_clk_freqs(hba);
>> -
>>         ufshcd_vops_dbg_register_dump(hba);
>>  }
>> 
>> @@ -499,6 +496,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba,
>> unsigned long bitmap)
>> 
>>  static void ufshcd_print_host_state(struct ufs_hba *hba)
>>  {
>> +       struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
>> +
>>         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>>         dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
>>                 hba->outstanding_reqs, hba->outstanding_tasks);
>> @@ -511,12 +510,24 @@ static void ufshcd_print_host_state(struct 
>> ufs_hba
>> *hba)
>>         dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>>                 hba->auto_bkops_enabled, 
>> hba->host->host_self_blocked);
>>         dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
>> +       dev_err(hba->dev,
>> +               "last_hibern8_exit_tstamp at %lld us, 
>> hibern8_exit_cnt=%d\n",
>> +               ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
>> +               hba->ufs_stats.hibern8_exit_cnt);
>> +       dev_err(hba->dev, "last intr at %lld us, last intr 
>> status=0x%x\n",
>> +               ktime_to_us(hba->ufs_stats.last_intr_ts),
>> +               hba->ufs_stats.last_intr_status);
>>         dev_err(hba->dev, "error handling flags=0x%x, req. abort 
>> count=%d\n",
>>                 hba->eh_flags, hba->req_abort_count);
>> -       dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
>> -               hba->capabilities, hba->caps);
>> +       dev_err(hba->dev, "hba->ufs_version=0x%x, Host 
>> capabilities=0x%x,
>> caps=0x%x\n",
>> +               hba->ufs_version, hba->capabilities, hba->caps);
>>         dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", 
>> hba->quirks,
>>                 hba->dev_quirks);
>> +       if (sdev_ufs)
>> +               dev_err(hba->dev, "UFS dev info: %.8s %.16s rev 
>> %.4s\n",
>> +                       sdev_ufs->vendor, sdev_ufs->model, 
>> sdev_ufs->rev);
>> +
>> +       ufshcd_print_clk_freqs(hba);
>>  }
>> 
>>  /**
>> @@ -1568,11 +1579,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
>> async)
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>>         hba->clk_gating.active_reqs++;
>> 
>> -       if (ufshcd_eh_in_progress(hba)) {
>> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -               return 0;
>> -       }
>> -
>>  start:
>>         switch (hba->clk_gating.state) {
>>         case CLKS_ON:
>> @@ -1647,6 +1653,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hold);
>> 
>>  static void ufshcd_gate_work(struct work_struct *work)
>>  {
>> +       int ret;
>>         struct ufs_hba *hba = container_of(work, struct ufs_hba,
>>                         clk_gating.gate_work.work);
>>         unsigned long flags;
>> @@ -1676,8 +1683,11 @@ static void ufshcd_gate_work(struct work_struct
>> *work)
>> 
>>         /* put the link into hibern8 mode before turning off clocks */
>>         if (ufshcd_can_hibern8_during_gating(hba)) {
>> -               if (ufshcd_uic_hibern8_enter(hba)) {
>> +               ret = ufshcd_uic_hibern8_enter(hba);
>> +               if (ret) {
>>                         hba->clk_gating.state = CLKS_ON;
>> +                       dev_err(hba->dev, "%s: hibern8 enter failed 
>> %d\n",
>> +                                       __func__, ret);
>>                         trace_ufshcd_clk_gating(dev_name(hba->dev),
>>                                                 
>> hba->clk_gating.state);
>>                         goto out;
>> @@ -1722,11 +1732,10 @@ static void __ufshcd_release(struct ufs_hba 
>> *hba)
>> 
>>         hba->clk_gating.active_reqs--;
>> 
>> -       if (hba->clk_gating.active_reqs || 
>> hba->clk_gating.is_suspended
>> -               || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
>> -               || ufshcd_any_tag_in_use(hba) || 
>> hba->outstanding_tasks
>> -               || hba->active_uic_cmd || hba->uic_async_done
>> -               || ufshcd_eh_in_progress(hba))
>> +       if (hba->clk_gating.active_reqs || 
>> hba->clk_gating.is_suspended ||
>> +           hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
>> +           ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
>> +           hba->active_uic_cmd || hba->uic_async_done)
>>                 return;
>> 
>>         hba->clk_gating.state = REQ_CLKS_OFF;
>> @@ -2505,34 +2514,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
>> *host, struct scsi_cmnd *cmd)
>>         if (!down_read_trylock(&hba->clk_scaling_lock))
>>                 return SCSI_MLQUEUE_HOST_BUSY;
>> 
>> -       spin_lock_irqsave(hba->host->host_lock, flags);
>> -       switch (hba->ufshcd_state) {
>> -       case UFSHCD_STATE_OPERATIONAL:
>> -               break;
>> -       case UFSHCD_STATE_EH_SCHEDULED:
>> -       case UFSHCD_STATE_RESET:
>> -               err = SCSI_MLQUEUE_HOST_BUSY;
>> -               goto out_unlock;
>> -       case UFSHCD_STATE_ERROR:
>> -               set_host_byte(cmd, DID_ERROR);
>> -               cmd->scsi_done(cmd);
>> -               goto out_unlock;
>> -       default:
>> -               dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
>> -                               __func__, hba->ufshcd_state);
>> -               set_host_byte(cmd, DID_BAD_TARGET);
>> -               cmd->scsi_done(cmd);
>> -               goto out_unlock;
>> -       }
>> -
>> -       /* if error handling is in progress, don't issue commands */
>> -       if (ufshcd_eh_in_progress(hba)) {
>> -               set_host_byte(cmd, DID_ERROR);
>> -               cmd->scsi_done(cmd);
>> -               goto out_unlock;
>> -       }
>> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -
>>         hba->req_abort_count = 0;
>> 
>>         err = ufshcd_hold(hba, true);
>> @@ -2568,12 +2549,51 @@ static int ufshcd_queuecommand(struct 
>> Scsi_Host
>> *host, struct scsi_cmnd *cmd)
>>         /* Make sure descriptors are ready before ringing the doorbell 
>> */
>>         wmb();
>> 
>> -       /* issue command to the controller */
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> +       switch (hba->ufshcd_state) {
>> +       case UFSHCD_STATE_OPERATIONAL:
>> +       case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
>> +               break;
>> +       case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>> +               /*
>> +                * If we are here, eh_work is either scheduled or 
>> running.
>> +                * Before eh_work sets ufshcd_state to STATE_RESET, it 
>> flushes
>> +                * runtime PM ops by calling pm_runtime_get_sync(). If 
>> a scsi
>> +                * cmd, e.g. the SSU cmd, is sent by PM ops, it can 
>> never be
>> +                * finished if we let SCSI layer keep retrying it, 
>> which gets
>> +                * eh_work stuck forever. Neither can we let it pass, 
>> because
>> +                * ufs now is not in good status, so the SSU cmd may 
>> eventually
>> +                * time out, blocking eh_work for too long. So just 
>> let it fail.
>> +                */
>> +               if (hba->pm_op_in_progress) {
>> +                       hba->force_reset = true;
>> +                       set_host_byte(cmd, DID_BAD_TARGET);
>> +                       goto out_compl_cmd;
>> +               }
>> +       case UFSHCD_STATE_RESET:
>> +               err = SCSI_MLQUEUE_HOST_BUSY;
>> +               goto out_compl_cmd;
>> +       case UFSHCD_STATE_ERROR:
>> +               set_host_byte(cmd, DID_ERROR);
>> +               goto out_compl_cmd;
>> +       default:
>> +               dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
>> +                               __func__, hba->ufshcd_state);
>> +               set_host_byte(cmd, DID_BAD_TARGET);
>> +               goto out_compl_cmd;
>> +       }
>>         ufshcd_vops_setup_xfer_req(hba, tag, true);
>>         ufshcd_send_command(hba, tag);
>> -out_unlock:
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +       goto out;
>> +
>> +out_compl_cmd:
>> +       scsi_dma_unmap(lrbp->cmd);
>> +       lrbp->cmd = NULL;
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +       ufshcd_release(hba);
>> +       if (!err)
>> +               cmd->scsi_done(cmd);
>>  out:
>>         up_read(&hba->clk_scaling_lock);
>>         return err;
>> @@ -3746,6 +3766,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
>> *hba,
>> struct uic_command *cmd)
>>         ufshcd_add_delay_before_dme_cmd(hba);
>> 
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (ufshcd_is_link_broken(hba)) {
>> +               ret = -ENOLINK;
>> +               goto out_unlock;
>> +       }
>>         hba->uic_async_done = &uic_async_done;
>>         if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) &
>> UIC_COMMAND_COMPL) {
>>                 ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
>> @@ -3793,6 +3817,12 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
>> *hba,
>> struct uic_command *cmd)
>>         hba->uic_async_done = NULL;
>>         if (reenable_intr)
>>                 ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>> +       if (ret) {
>> +               ufshcd_set_link_broken(hba);
>> +               ufshcd_schedule_eh_work(hba);
>> +       }
>> +
>> +out_unlock:
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>         mutex_unlock(&hba->uic_cmd_mutex);
>> 
>> @@ -3862,7 +3892,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_link_recovery);
>> 
>> -static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>> +static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>>  {
>>         int ret;
>>         struct uic_command uic_cmd = {0};
>> @@ -3875,45 +3905,16 @@ static int __ufshcd_uic_hibern8_enter(struct
>> ufs_hba *hba)
>>         trace_ufshcd_profile_hibern8(dev_name(hba->dev), "enter",
>>                              ktime_to_us(ktime_sub(ktime_get(), 
>> start)), ret);
>> 
>> -       if (ret) {
>> -               int err;
>> -
>> +       if (ret)
>>                 dev_err(hba->dev, "%s: hibern8 enter failed. ret = 
>> %d\n",
>>                         __func__, ret);
>> -
>> -               /*
>> -                * If link recovery fails then return error code 
>> returned from
>> -                * ufshcd_link_recovery().
>> -                * If link recovery succeeds then return -EAGAIN to 
>> attempt
>> -                * hibern8 enter retry again.
>> -                */
>> -               err = ufshcd_link_recovery(hba);
>> -               if (err) {
>> -                       dev_err(hba->dev, "%s: link recovery failed", 
>> __func__);
>> -                       ret = err;
>> -               } else {
>> -                       ret = -EAGAIN;
>> -               }
>> -       } else
>> +       else
>>                 ufshcd_vops_hibern8_notify(hba, 
>> UIC_CMD_DME_HIBER_ENTER,
>>                                                                 
>> POST_CHANGE);
>> 
>>         return ret;
>>  }
>> 
>> -static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>> -{
>> -       int ret = 0, retries;
>> -
>> -       for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; 
>> retries--) {
>> -               ret = __ufshcd_uic_hibern8_enter(hba);
>> -               if (!ret)
>> -                       goto out;
>> -       }
>> -out:
>> -       return ret;
>> -}
>> -
>>  int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>>  {
>>         struct uic_command uic_cmd = {0};
>> @@ -3930,7 +3931,6 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>>         if (ret) {
>>                 dev_err(hba->dev, "%s: hibern8 exit failed. ret = 
>> %d\n",
>>                         __func__, ret);
>> -               ret = ufshcd_link_recovery(hba);
>>         } else {
>>                 ufshcd_vops_hibern8_notify(hba, 
>> UIC_CMD_DME_HIBER_EXIT,
>>                                                                 
>> POST_CHANGE);
>> @@ -5554,6 +5554,28 @@ static bool ufshcd_quirk_dl_nac_errors(struct
>> ufs_hba *hba)
>>         return err_handling;
>>  }
>> 
>> +/* host lock must be held before calling this func */
>> +static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
>> +{
>> +       return ((hba->saved_err & INT_FATAL_ERRORS) ||
>> +               ((hba->saved_err & UIC_ERROR) &&
>> +                (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR)));
>> +}
>> +
>> +/* host lock must be held before calling this func */
>> +static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
>> +{
>> +       /* handle fatal errors only when link is not in error state */
>> +       if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
>> +               if (hba->force_reset || ufshcd_is_link_broken(hba) ||
>> +                   ufshcd_is_saved_err_fatal(hba))
>> +                       hba->ufshcd_state = 
>> UFSHCD_STATE_EH_SCHEDULED_FATAL;
>> +               else
>> +                       hba->ufshcd_state =
>> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
>> +               queue_work(hba->eh_wq, &hba->eh_work);
>> +       }
>> +}
>> +
>>  /**
>>   * ufshcd_err_handler - handle UFS errors that require s/w attention
>>   * @work: pointer to work structure
>> @@ -5564,21 +5586,47 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>         unsigned long flags;
>>         u32 err_xfer = 0;
>>         u32 err_tm = 0;
>> -       int err = 0;
>> +       int reset_err = -1;
>>         int tag;
>>         bool needs_reset = false;
>> 
>>         hba = container_of(work, struct ufs_hba, eh_work);
>> 
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (hba->ufshcd_state == UFSHCD_STATE_ERROR ||
>> +           (!(hba->saved_err || hba->saved_uic_err || 
>> hba->force_reset) &&
>> +            !ufshcd_is_link_broken(hba))) {
>> +               if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>> +                       hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +               return;
>> +       }
>> +       ufshcd_set_eh_in_progress(hba);
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>>         pm_runtime_get_sync(hba->dev);
>> +       /*
>> +        * Don't assume anything of pm_runtime_get_sync(), if resume 
>> fails,
>> +        * irq and clocks can be OFF, and powers can be OFF or in LPM.
>> +        */
>> +       ufshcd_setup_vreg(hba, true);
>> +       ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
>> +       ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
>> +       ufshcd_setup_hba_vreg(hba, true);
>> +       ufshcd_enable_irq(hba);
>> +
>>         ufshcd_hold(hba, false);
>> +       if (!ufshcd_is_clkgating_allowed(hba))
>> +               ufshcd_setup_clocks(hba, true);
>> 
>> -       spin_lock_irqsave(hba->host->host_lock, flags);
>> -       if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>> -               goto out;
>> +       if (ufshcd_is_clkscaling_supported(hba)) {
>> +               cancel_work_sync(&hba->clk_scaling.suspend_work);
>> +               cancel_work_sync(&hba->clk_scaling.resume_work);
>> +               ufshcd_suspend_clkscaling(hba);
>> +       }
>> 
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       ufshcd_scsi_block_requests(hba);
>>         hba->ufshcd_state = UFSHCD_STATE_RESET;
>> -       ufshcd_set_eh_in_progress(hba);
>> 
>>         /* Complete requests that have door-bell cleared by h/w */
>>         ufshcd_complete_requests(hba);
>> @@ -5590,17 +5638,29 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>                 /* release the lock as ufshcd_quirk_dl_nac_errors() 
>> may sleep */
>>                 ret = ufshcd_quirk_dl_nac_errors(hba);
>>                 spin_lock_irqsave(hba->host->host_lock, flags);
>> -               if (!ret)
>> +               if (!ret && !hba->force_reset && 
>> ufshcd_is_link_active(hba))
>>                         goto skip_err_handling;
>>         }
>> -       if ((hba->saved_err & INT_FATAL_ERRORS) ||
>> -           (hba->saved_err & UFSHCD_UIC_HIBERN8_MASK) ||
>> +
>> +       if (hba->force_reset || ufshcd_is_link_broken(hba) ||
>> +           ufshcd_is_saved_err_fatal(hba) ||
>>             ((hba->saved_err & UIC_ERROR) &&
>> -           (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
>> -                                  UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
>> -                                  UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>> +            (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
>> +                                   UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>>                 needs_reset = true;
>> 
>> +       if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
>> +                             UFSHCD_UIC_HIBERN8_MASK)) {
>> +               dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 
>> 0x%x\n",
>> +                               __func__, hba->saved_err, 
>> hba->saved_uic_err);
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +               ufshcd_print_host_state(hba);
>> +               ufshcd_print_pwr_info(hba);
>> +               ufshcd_print_host_regs(hba);
>> +               ufshcd_print_tmrs(hba, hba->outstanding_tasks);
>> +               spin_lock_irqsave(hba->host->host_lock, flags);
>> +       }
>> +
>>         /*
>>          * if host reset is required then skip clearing the pending
>>          * transfers forcefully because they will get cleared during
>> @@ -5652,38 +5712,67 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>                         __ufshcd_transfer_req_compl(hba,
>>                                                     (1UL << 
>> (hba->nutrs - 1)));
>> 
>> +               hba->force_reset = false;
>>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -               err = ufshcd_reset_and_restore(hba);
>> +               reset_err = ufshcd_reset_and_restore(hba);
>>                 spin_lock_irqsave(hba->host->host_lock, flags);
>> -               if (err) {
>> +               if (reset_err)
>>                         dev_err(hba->dev, "%s: reset and restore 
>> failed\n",
>>                                         __func__);
>> -                       hba->ufshcd_state = UFSHCD_STATE_ERROR;
>> -               }
>> -               /*
>> -                * Inform scsi mid-layer that we did reset and allow 
>> to handle
>> -                * Unit Attention properly.
>> -                */
>> -               scsi_report_bus_reset(hba->host, 0);
>> -               hba->saved_err = 0;
>> -               hba->saved_uic_err = 0;
>>         }
>> 
>>  skip_err_handling:
>>         if (!needs_reset) {
>> -               hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> +               if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>> +                       hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>>                 if (hba->saved_err || hba->saved_uic_err)
>>                         dev_err_ratelimited(hba->dev, "%s: exit: 
>> saved_err 0x%x
>> saved_uic_err 0x%x",
>>                             __func__, hba->saved_err, 
>> hba->saved_uic_err);
>>         }
>> 
>> -       ufshcd_clear_eh_in_progress(hba);
>> +#ifdef CONFIG_PM
>> +       if (!reset_err) {
>> +               struct Scsi_Host *shost = hba->host;
>> +               struct scsi_device *sdev;
>> +               struct request_queue *q;
>> +               int ret;
>> 
>> -out:
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +               /*
>> +                * Set RPM status of hba device to RPM_ACTIVE,
>> +                * this also clears its runtime error.
>> +                */
>> +               ret = pm_runtime_set_active(hba->dev);
>> +               /*
>> +                * If hba device had runtime error, explicitly resume
>> +                * its scsi devices so that block layer can wake up
>> +                * those waiting in blk_queue_enter().
>> +                */
>> +               if (!ret) {
>> +                       list_for_each_entry(sdev, &shost->__devices, 
>> siblings) {
>> +                               q = sdev->request_queue;
>> +                               if (q->dev && (q->rpm_status == 
>> RPM_SUSPENDED ||
>> +                                              q->rpm_status == 
>> RPM_SUSPENDING))
>> +                                       pm_request_resume(q->dev);
>> +                       }
>> +               }
>> +               spin_lock_irqsave(hba->host->host_lock, flags);
>> +       }
>> +
>> +       /* If clk_gating is held by pm ops, release it */
>> +       if (pm_runtime_active(hba->dev) && hba->clk_gating.held_by_pm) 
>> {
>> +               hba->clk_gating.held_by_pm = false;
>> +               __ufshcd_release(hba);
>> +       }
>> +#endif
>> +
>> +       ufshcd_clear_eh_in_progress(hba);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>         ufshcd_scsi_unblock_requests(hba);
>>         ufshcd_release(hba);
>> -       pm_runtime_put_sync(hba->dev);
>> +       if (ufshcd_is_clkscaling_supported(hba))
>> +               ufshcd_resume_clkscaling(hba);
>> +       pm_runtime_put_noidle(hba->dev);
>>  }
>> 
>>  /**
>> @@ -5813,6 +5902,7 @@ static irqreturn_t ufshcd_check_errors(struct
>> ufs_hba *hba)
>>                         hba->errors, ufshcd_get_upmcrs(hba));
>>                 
>> ufshcd_update_reg_hist(&hba->ufs_stats.auto_hibern8_err,
>>                                        hba->errors);
>> +               ufshcd_set_link_broken(hba);
>>                 queue_eh_work = true;
>>         }
>> 
>> @@ -5823,31 +5913,7 @@ static irqreturn_t ufshcd_check_errors(struct
>> ufs_hba *hba)
>>                  */
>>                 hba->saved_err |= hba->errors;
>>                 hba->saved_uic_err |= hba->uic_error;
>> -
>> -               /* handle fatal errors only when link is functional */
>> -               if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
>> -                       /* block commands from scsi mid-layer */
>> -                       ufshcd_scsi_block_requests(hba);
>> -
>> -                       hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
>> -
>> -                       /* dump controller state before resetting */
>> -                       if (hba->saved_err & (INT_FATAL_ERRORS | 
>> UIC_ERROR)) {
>> -                               bool pr_prdt = !!(hba->saved_err &
>> -                                               
>> SYSTEM_BUS_FATAL_ERROR);
>> -
>> -                               dev_err(hba->dev, "%s: saved_err 0x%x 
>> saved_uic_err
>> 0x%x\n",
>> -                                       __func__, hba->saved_err,
>> -                                       hba->saved_uic_err);
>> -
>> -                               ufshcd_print_host_regs(hba);
>> -                               ufshcd_print_pwr_info(hba);
>> -                               ufshcd_print_tmrs(hba, 
>> hba->outstanding_tasks);
>> -                               ufshcd_print_trs(hba, 
>> hba->outstanding_reqs,
>> -                                                       pr_prdt);
>> -                       }
>> -                       schedule_work(&hba->eh_work);
>> -               }
>> +               ufshcd_schedule_eh_work(hba);
>>                 retval |= IRQ_HANDLED;
>>         }
>>         /*
>> @@ -5951,6 +6017,8 @@ static irqreturn_t ufshcd_intr(int irq, void 
>> *__hba)
>> 
>>         spin_lock(hba->host->host_lock);
>>         intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>> +       hba->ufs_stats.last_intr_status = intr_status;
>> +       hba->ufs_stats.last_intr_ts = ktime_get();
>> 
>>         /*
>>          * There could be max of hba->nutrs reqs in flight and in 
>> worst case
>> @@ -6589,9 +6657,6 @@ static int ufshcd_host_reset_and_restore(struct
>> ufs_hba *hba)
>> 
>>         /* Establish the link again and restore the device */
>>         err = ufshcd_probe_hba(hba, false);
>> -
>> -       if (!err && (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL))
>> -               err = -EIO;
>>  out:
>>         if (err)
>>                 dev_err(hba->dev, "%s: Host init failed %d\n", 
>> __func__, err);
>> @@ -6610,9 +6675,23 @@ static int ufshcd_host_reset_and_restore(struct
>> ufs_hba *hba)
>>   */
>>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>>  {
>> +       u32 saved_err;
>> +       u32 saved_uic_err;
>>         int err = 0;
>> +       unsigned long flags;
>>         int retries = MAX_HOST_RESET_RETRIES;
>> 
>> +       /*
>> +        * This is a fresh start, cache and clear saved error first,
>> +        * in case new error generated during reset and restore.
>> +        */
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       saved_err = hba->saved_err;
>> +       saved_uic_err = hba->saved_uic_err;
>> +       hba->saved_err = 0;
>> +       hba->saved_uic_err = 0;
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +
>>         do {
>>                 /* Reset the attached device */
>>                 ufshcd_vops_device_reset(hba);
>> @@ -6620,6 +6699,18 @@ static int ufshcd_reset_and_restore(struct 
>> ufs_hba
>> *hba)
>>                 err = ufshcd_host_reset_and_restore(hba);
>>         } while (err && --retries);
>> 
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       /*
>> +        * Inform scsi mid-layer that we did reset and allow to handle
>> +        * Unit Attention properly.
>> +        */
>> +       scsi_report_bus_reset(hba->host, 0);
>> +       if (err) {
>> +               hba->saved_err |= saved_err;
>> +               hba->saved_uic_err |= saved_uic_err;
>> +       }
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +
>>         return err;
>>  }
>> 
>> @@ -6631,48 +6722,25 @@ static int ufshcd_reset_and_restore(struct
>> ufs_hba *hba)
>>   */
>>  static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>>  {
>> -       int err;
>> +       int err = SUCCESS;
>>         unsigned long flags;
>>         struct ufs_hba *hba;
>> 
>>         hba = shost_priv(cmd->device->host);
>> 
>> -       ufshcd_hold(hba, false);
>> -       /*
>> -        * Check if there is any race with fatal error handling.
>> -        * If so, wait for it to complete. Even though fatal error
>> -        * handling does reset and restore in some cases, don't assume
>> -        * anything out of it. We are just avoiding race here.
>> -        */
>> -       do {
>> -               spin_lock_irqsave(hba->host->host_lock, flags);
>> -               if (!(work_pending(&hba->eh_work) ||
>> -                           hba->ufshcd_state == UFSHCD_STATE_RESET ||
>> -                           hba->ufshcd_state == 
>> UFSHCD_STATE_EH_SCHEDULED))
>> -                       break;
>> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -               dev_dbg(hba->dev, "%s: reset in progress\n", 
>> __func__);
>> -               flush_work(&hba->eh_work);
>> -       } while (1);
>> -
>> -       hba->ufshcd_state = UFSHCD_STATE_RESET;
>> -       ufshcd_set_eh_in_progress(hba);
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       hba->force_reset = true;
>> +       ufshcd_schedule_eh_work(hba);
>> +       dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>> -       err = ufshcd_reset_and_restore(hba);
>> +       flush_work(&hba->eh_work);
>> 
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> -       if (!err) {
>> -               err = SUCCESS;
>> -               hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> -       } else {
>> +       if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
>>                 err = FAILED;
>> -               hba->ufshcd_state = UFSHCD_STATE_ERROR;
>> -       }
>> -       ufshcd_clear_eh_in_progress(hba);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>> -       ufshcd_release(hba);
>>         return err;
>>  }
>> 
>> @@ -7393,6 +7461,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>>  static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
>>  {
>>         int ret;
>> +       unsigned long flags;
>>         ktime_t start = ktime_get();
>> 
>>         ret = ufshcd_link_startup(hba);
>> @@ -7457,14 +7526,17 @@ static int ufshcd_probe_hba(struct ufs_hba 
>> *hba,
>> bool async)
>>          */
>>         ufshcd_set_active_icc_lvl(hba);
>> 
>> -       /* set the state as operational after switching to desired 
>> gear */
>> -       hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> -
>>         ufshcd_wb_config(hba);
>>         /* Enable Auto-Hibernate if configured */
>>         ufshcd_auto_hibern8_enable(hba);
>> 
>>  out:
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (ret)
>> +               hba->ufshcd_state = UFSHCD_STATE_ERROR;
>> +       else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>> +               hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>>         trace_ufshcd_init(dev_name(hba->dev), ret,
>>                 ktime_to_us(ktime_sub(ktime_get(), start)),
>> @@ -8071,10 +8143,13 @@ static int ufshcd_link_state_transition(struct
>> ufs_hba *hba,
>> 
>>         if (req_link_state == UIC_LINK_HIBERN8_STATE) {
>>                 ret = ufshcd_uic_hibern8_enter(hba);
>> -               if (!ret)
>> +               if (!ret) {
>>                         ufshcd_set_link_hibern8(hba);
>> -               else
>> +               } else {
>> +                       dev_err(hba->dev, "%s: hibern8 enter failed 
>> %d\n",
>> +                                       __func__, ret);
>>                         goto out;
>> +               }
>>         }
>>         /*
>>          * If autobkops is enabled, link can't be turned off because
>> @@ -8090,8 +8165,11 @@ static int ufshcd_link_state_transition(struct
>> ufs_hba *hba,
>>                  * unipro. But putting the link in hibern8 is much 
>> faster.
>>                  */
>>                 ret = ufshcd_uic_hibern8_enter(hba);
>> -               if (ret)
>> +               if (ret) {
>> +                       dev_err(hba->dev, "%s: hibern8 enter failed 
>> %d\n",
>> +                                       __func__, ret);
>>                         goto out;
>> +               }
>>                 /*
>>                  * Change controller state to "reset state" which
>>                  * should also put the link in off/reset state
>> @@ -8226,6 +8304,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
>> enum ufs_pm_op pm_op)
>>          * just gate the clocks.
>>          */
>>         ufshcd_hold(hba, false);
>> +       hba->clk_gating.held_by_pm = true;
>>         hba->clk_gating.is_suspended = true;
>> 
>>         if (hba->clk_scaling.is_allowed) {
>> @@ -8345,6 +8424,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
>> enum ufs_pm_op pm_op)
>>         hba->clk_gating.is_suspended = false;
>>         hba->dev_info.b_rpm_dev_flush_capable = false;
>>         ufshcd_release(hba);
>> +       hba->clk_gating.held_by_pm = false;
>>  out:
>>         if (hba->dev_info.b_rpm_dev_flush_capable) {
>>                 
>> schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
>> @@ -8400,10 +8480,13 @@ static int ufshcd_resume(struct ufs_hba *hba,
>> enum ufs_pm_op pm_op)
>> 
>>         if (ufshcd_is_link_hibern8(hba)) {
>>                 ret = ufshcd_uic_hibern8_exit(hba);
>> -               if (!ret)
>> +               if (!ret) {
>>                         ufshcd_set_link_active(hba);
>> -               else
>> +               } else {
>> +                       dev_err(hba->dev, "%s: hibern8 exit failed 
>> %d\n",
>> +                                       __func__, ret);
>>                         goto vendor_suspend;
>> +               }
>>         } else if (ufshcd_is_link_off(hba)) {
>>                 /*
>>                  * A full initialization of the host and the device is
>> @@ -8448,6 +8531,7 @@ static int ufshcd_resume(struct ufs_hba *hba, 
>> enum
>> ufs_pm_op pm_op)
>> 
>>         /* Schedule clock gating in case of no access to UFS device 
>> yet */
>>         ufshcd_release(hba);
>> +       hba->clk_gating.held_by_pm = false;
>> 
>>         goto out;
>> 
>> @@ -8777,6 +8861,7 @@ int ufshcd_init(struct ufs_hba *hba, void 
>> __iomem
>> *mmio_base, unsigned int irq)
>>         int err;
>>         struct Scsi_Host *host = hba->host;
>>         struct device *dev = hba->dev;
>> +       char eh_wq_name[sizeof("ufs_eh_wq_00")];
>> 
>>         if (!mmio_base) {
>>                 dev_err(hba->dev,
>> @@ -8838,6 +8923,15 @@ int ufshcd_init(struct ufs_hba *hba, void 
>> __iomem
>> *mmio_base, unsigned int irq)
>>         hba->max_pwr_info.is_valid = false;
>> 
>>         /* Initialize work queues */
>> +       snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
>> +                hba->host->host_no);
>> +       hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
>> +       if (!hba->eh_wq) {
>> +               dev_err(hba->dev, "%s: failed to create eh 
>> workqueue\n",
>> +                               __func__);
>> +               err = -ENOMEM;
>> +               goto out_disable;
>> +       }
>>         INIT_WORK(&hba->eh_work, ufshcd_err_handler);
>>         INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 656c069..585e58b 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -90,6 +90,7 @@ enum uic_link_state {
>>         UIC_LINK_OFF_STATE      = 0, /* Link powered down or disabled 
>> */
>>         UIC_LINK_ACTIVE_STATE   = 1, /* Link is in Fast/Slow/Sleep 
>> state */
>>         UIC_LINK_HIBERN8_STATE  = 2, /* Link is in Hibernate state */
>> +       UIC_LINK_BROKEN_STATE   = 3, /* Link is in broken state */
>>  };
>> 
>>  #define ufshcd_is_link_off(hba) ((hba)->uic_link_state ==
>> UIC_LINK_OFF_STATE)
>> @@ -97,11 +98,15 @@ enum uic_link_state {
>>                                     UIC_LINK_ACTIVE_STATE)
>>  #define ufshcd_is_link_hibern8(hba) ((hba)->uic_link_state == \
>>                                     UIC_LINK_HIBERN8_STATE)
>> +#define ufshcd_is_link_broken(hba) ((hba)->uic_link_state == \
>> +                                  UIC_LINK_BROKEN_STATE)
>>  #define ufshcd_set_link_off(hba) ((hba)->uic_link_state =
>> UIC_LINK_OFF_STATE)
>>  #define ufshcd_set_link_active(hba) ((hba)->uic_link_state = \
>>                                     UIC_LINK_ACTIVE_STATE)
>>  #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
>>                                     UIC_LINK_HIBERN8_STATE)
>> +#define ufshcd_set_link_broken(hba) ((hba)->uic_link_state = \
>> +                                   UIC_LINK_BROKEN_STATE)
>> 
>>  #define ufshcd_set_ufs_dev_active(h) \
>>         ((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
>> @@ -349,6 +354,7 @@ struct ufs_clk_gating {
>>         struct device_attribute delay_attr;
>>         struct device_attribute enable_attr;
>>         bool is_enabled;
>> +       bool held_by_pm;
>>         int active_reqs;
>>         struct workqueue_struct *clk_gating_workq;
>>  };
>> @@ -406,6 +412,8 @@ struct ufs_err_reg_hist {
>> 
>>  /**
>>   * struct ufs_stats - keeps usage/err statistics
>> + * @last_intr_status: record the last interrupt status.
>> + * @last_intr_ts: record the last interrupt timestamp.
>>   * @hibern8_exit_cnt: Counter to keep track of number of exits,
>>   *             reset this after link-startup.
>>   * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
>> @@ -425,6 +433,9 @@ struct ufs_err_reg_hist {
>>   * @tsk_abort: tracks task abort events
>>   */
>>  struct ufs_stats {
>> +       u32 last_intr_status;
>> +       ktime_t last_intr_ts;
>> +
>>         u32 hibern8_exit_cnt;
>>         ktime_t last_hibern8_exit_tstamp;
>> 
>> @@ -608,12 +619,14 @@ struct ufs_hba_variant_params {
>>   * @intr_mask: Interrupt Mask Bits
>>   * @ee_ctrl_mask: Exception event control mask
>>   * @is_powered: flag to check if HBA is powered
>> + * @eh_wq: Workqueue that eh_work works on
>>   * @eh_work: Worker to handle UFS errors that require s/w attention
>>   * @eeh_work: Worker to handle exception events
>>   * @errors: HBA errors
>>   * @uic_error: UFS interconnect layer error status
>>   * @saved_err: sticky error mask
>>   * @saved_uic_err: sticky UIC error mask
>> + * @force_reset: flag to force eh_work perform a full reset
>>   * @silence_err_logs: flag to silence error logs
>>   * @dev_cmd: ufs device management command information
>>   * @last_dme_cmd_tstamp: time stamp of the last completed DME command
>> @@ -702,6 +715,7 @@ struct ufs_hba {
>>         bool is_powered;
>> 
>>         /* Work Queues */
>> +       struct workqueue_struct *eh_wq;
>>         struct work_struct eh_work;
>>         struct work_struct eeh_work;
>> 
>> @@ -711,6 +725,7 @@ struct ufs_hba {
>>         u32 saved_err;
>>         u32 saved_uic_err;
>>         struct ufs_stats ufs_stats;
>> +       bool force_reset;
>>         bool silence_err_logs;
>> 
>>         /* Device management request data */
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux
>> Foundation Collaborative Project.
