Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEDDC6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 16:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjCOQOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 12:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjCOQOI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 12:14:08 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EBC4A1E6;
        Wed, 15 Mar 2023 09:13:18 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id AE891341CD9;
        Wed, 15 Mar 2023 19:13:01 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=5ES3jyOpHQLSJKmVZY
        EkFub6NqJ5IcNzh/Z0Mi2/d6U=; b=q+rL6DvFh5JEQdRlPh86r2kdaUSrPgeAn6
        fX2/fIfWdeZpsyF1V337S0UhMMaaMEzM3rZG6ZD9S0y1czE2iM2VYijOhoN3jUCA
        oo4TcJlYPNUISIZnb/O0L9PFfncP8+aqRgBud1wBvAV2YD6FhjgAbnZlVEFYFqWv
        BLNNt/mTA=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 9FCCB341BCE;
        Wed, 15 Mar 2023 19:13:01 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 15 Mar
 2023 19:13:01 +0300
Date:   Wed, 15 Mar 2023 19:13:01 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <mgurtovoy@nvidia.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Message-ID: <20230315161301.GE1031@yadro.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230309223312.94595-14-michael.christie@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 04:33:07PM -0600, Mike Christie wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
> up running commands when it hasn't. The bug was added in:
> 
> commit 51ec502a3266 ("target: Delete tmr from list before processing")
> 
> The problem occurs when:
> 
> 1. We have N IO cmds running in the target layer spread over 2 sessions.
> 2. The initiator sends a LUN_RESET for each session.
> 3. session1's LUN_RESET loops over all the running commands from both
> sessions and moves them to its local drain_task_list.
> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
> the commit above has it remove itself. session2 also does not see any
> commands since the other reset moved them off the state lists.
> 5. sessions2's LUN_RESET will then complete with a successful response.
> 6. sessions2's inititor believes the running commands on its session are
> now cleaned up due to the successful response and cleans up the running
> commands from its side. It then restarts them.
> 7. The commands do eventually complete on the backend and the target
> starts to return aborted task statuses for them. The initiator will
> either throw a invalid ITT error or might accidentally lookup a new task
> if the ITT has been reallocated already.
> 
> This fixes the bug by reverting the patch, and also serializes the
> execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
> because it turns out the commit accidentally fixed a bug where if there
> are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
> put the other one on their local drain list, then end up waiting on each
> other resulting in a deadlock.

If LUN_RESET is not in TMR list anymore there is no need to serialize
core_tmr_drain_tmr_list.

> 
> Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_device.c    | 15 ++++++--
>  drivers/target/target_core_tmr.c       | 15 ++++----
>  drivers/target/target_core_transport.c | 50 ++++++++++++++++++++++++--
>  include/target/target_core_base.h      |  5 ++-
>  4 files changed, 74 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index f6e58410ec3f..c9f75ed1566b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -179,7 +179,16 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
>         se_tmr->tmr_dev = rcu_dereference_raw(se_lun->lun_se_dev);
> 
>         spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
> -       list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
> +       switch (se_tmr->function) {
> +       case TMR_ABORT_TASK:
> +               list_add_tail(&se_tmr->tmr_list,
> +                             &se_tmr->tmr_dev->generic_tmr_list);
> +               break;
> +       case TMR_LUN_RESET:
> +               list_add_tail(&se_tmr->tmr_list,
> +                             &se_tmr->tmr_dev->lun_reset_tmr_list);
> +               break;
> +       }
>         spin_unlock_irqrestore(&se_tmr->tmr_dev->se_tmr_lock, flags);
> 
>         return 0;
> @@ -761,7 +770,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>         dev->hba_index = hba->hba_index;
> 
>         INIT_LIST_HEAD(&dev->dev_sep_list);
> -       INIT_LIST_HEAD(&dev->dev_tmr_list);
> +       INIT_LIST_HEAD(&dev->generic_tmr_list);
> +       INIT_LIST_HEAD(&dev->lun_reset_tmr_list);
>         INIT_LIST_HEAD(&dev->delayed_cmd_list);
>         INIT_LIST_HEAD(&dev->qf_cmd_list);
>         spin_lock_init(&dev->delayed_cmd_lock);
> @@ -782,6 +792,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>         spin_lock_init(&dev->t10_alua.lba_map_lock);
> 
>         INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
> +       mutex_init(&dev->lun_reset_mutex);
> 
>         dev->t10_wwn.t10_dev = dev;
>         /*
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 2b95b4550a63..88d2a7839876 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -184,13 +184,11 @@ static void core_tmr_drain_tmr_list(
>         unsigned long flags;
>         bool rc;
>         /*
> -        * Release all pending and outgoing TMRs aside from the received
> -        * LUN_RESET tmr..
> +        * Release all pending and outgoing TMRs except for LUN_RESETS.
>          */
>         spin_lock_irqsave(&dev->se_tmr_lock, flags);
> -       if (tmr)
> -               list_del_init(&tmr->tmr_list);
> -       list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
> +       list_for_each_entry_safe(tmr_p, tmr_pp, &dev->generic_tmr_list,
> +                                tmr_list) {
>                 cmd = tmr_p->task_cmd;
>                 if (!cmd) {
>                         pr_err("Unable to locate struct se_cmd for TMR\n");
> @@ -379,14 +377,19 @@ int core_tmr_lun_reset(
>                                 tmr_nacl->initiatorname);
>                 }
>         }
> +
> +       /* Serialize LUN RESET TMRs and preempt and aborts */
> +       mutex_lock(&dev->lun_reset_mutex);
> +
>         pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
>                 (preempt_and_abort_list) ? "Preempt" : "TMR",
>                 dev->transport->name, tas);
> -
>         core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
>         core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
>                                 preempt_and_abort_list);
> 
> +       mutex_unlock(&dev->lun_reset_mutex);
> +
>         /*
>          * Clear any legacy SPC-2 reservation when called during
>          * LOGICAL UNIT RESET
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 1c23079a5d7f..3c732b1b5389 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3574,6 +3574,7 @@ static void target_tmr_work(struct work_struct *work)
>         struct se_cmd *cmd = container_of(work, struct se_cmd, work);
>         struct se_device *dev = cmd->se_dev;
>         struct se_tmr_req *tmr = cmd->se_tmr_req;
> +       bool sched_reset = false;
>         int ret;
> 
>         if (cmd->transport_state & CMD_T_ABORTED)
> @@ -3596,6 +3597,22 @@ static void target_tmr_work(struct work_struct *work)
>                         target_dev_ua_allocate(dev, 0x29,
>                                                ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
>                 }
> +
> +               /*
> +                * If this is the last reset the device can be freed after we
> +                * run transport_cmd_check_stop_to_fabric. Figure out if there
> +                * are other resets that need to be scheduled while we know we
> +                * have a refcount on the device.
> +                */
> +               spin_lock_irq(&dev->se_tmr_lock);

tmr->tmr_list is removed from the list in the very end of se_cmd lifecycle
so any number of LUN_RESETs can be in lun_reset_tmr_list. And all of them 
can be finished but not yet removed from the list. 
 
You may delete lun_reset here with nulling tmr->tmr_dev:
+			list_del_init(&cmd->se_tmr_req->tmr_list);
+			cmd->se_tmr_req->tmr_dev = NULL;

Then the check below will be just 
+			if (!list_empty(dev->lun_reset_tmr_list))

> +               if (list_first_entry(&dev->lun_reset_tmr_list,
> +                                    struct se_tmr_req, tmr_list) !=
> +                   list_last_entry(&dev->lun_reset_tmr_list,
> +                                   struct se_tmr_req, tmr_list))
> +                       sched_reset = true;
> +               else
> +                       dev->dev_flags &= ~DF_RESETTING_LUN;
> +               spin_unlock_irq(&dev->se_tmr_lock);
>                 break;
>         case TMR_TARGET_WARM_RESET:
>                 tmr->response = TMR_FUNCTION_REJECTED;
> @@ -3617,15 +3634,26 @@ static void target_tmr_work(struct work_struct *work)
> 
>         transport_lun_remove_cmd(cmd);
>         transport_cmd_check_stop_to_fabric(cmd);
> +
> +       if (!sched_reset)
> +               return;
> +
> +       spin_lock_irq(&dev->se_tmr_lock);
> +       tmr = list_first_entry(&dev->lun_reset_tmr_list, struct se_tmr_req,
> +                              tmr_list);

And this list_first_entry will return the next LUN_RESET as you
expected.

> +       spin_unlock_irq(&dev->se_tmr_lock);
> +
> +       INIT_WORK(&tmr->task_cmd->work, target_tmr_work);
> +       schedule_work(&tmr->task_cmd->work);
>         return;
> 
>  aborted:
>         target_handle_abort(cmd);
>  }
> 
> -int transport_generic_handle_tmr(
> -       struct se_cmd *cmd)
> +int transport_generic_handle_tmr(struct se_cmd *cmd)
>  {
> +       struct se_device *dev = cmd->se_dev;
>         unsigned long flags;
>         bool aborted = false;
> 
> @@ -3646,8 +3674,26 @@ int transport_generic_handle_tmr(
>                 return 0;
>         }
> 
> +       spin_lock_irqsave(&dev->se_tmr_lock, flags);
> +       if (cmd->se_tmr_req->function == TMR_LUN_RESET) {
> +               /*
> +                * We only allow one reset to execute at a time to prevent
> +                * one reset waiting on another, and to make sure one reset
> +                * does not claim all the cmds causing the other reset to
> +                * return early.
> +                */
> +               if (dev->dev_flags & DF_RESETTING_LUN) {
> +                       spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> +                       goto done;
> +               }
> +
> +               dev->dev_flags |= DF_RESETTING_LUN;

Not good choise of flag variable. It is used at configuration time and
not under a lock. Configfs file dev/alias can be changed in any time
and could race with LUN_RESET.

> +       }
> +       spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> +
>         INIT_WORK(&cmd->work, target_tmr_work);
>         schedule_work(&cmd->work);
> +done:
>         return 0;
>  }
>  EXPORT_SYMBOL(transport_generic_handle_tmr);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index bd299790e99c..0a5b51f8e5e8 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -804,6 +804,7 @@ struct se_device {
>  #define DF_USING_UDEV_PATH                     0x00000008
>  #define DF_USING_ALIAS                         0x00000010
>  #define DF_READ_ONLY                           0x00000020
> +#define DF_RESETTING_LUN                       0x00000040
>         u8                      transport_flags;
>         /* Physical device queue depth */
>         u32                     queue_depth;
> @@ -840,7 +841,8 @@ struct se_device {
>         /* Used for SPC-3 Persistent Reservations */
>         struct t10_pr_registration *dev_pr_res_holder;
>         struct list_head        dev_sep_list;
> -       struct list_head        dev_tmr_list;
> +       struct list_head        generic_tmr_list;
> +       struct list_head        lun_reset_tmr_list;
>         struct work_struct      qf_work_queue;
>         struct work_struct      delayed_cmd_work;
>         struct list_head        delayed_cmd_list;
> @@ -872,6 +874,7 @@ struct se_device {
>         struct rcu_head         rcu_head;
>         int                     queue_cnt;
>         struct se_device_queue  *queues;
> +       struct mutex            lun_reset_mutex;
>  };
> 
>  struct target_opcode_descriptor {
> --
> 2.31.1
> 
> 

