Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA654C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 10:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCOKtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCOKsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 06:48:41 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0951215CA4;
        Wed, 15 Mar 2023 03:47:58 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 07588341E51;
        Wed, 15 Mar 2023 13:47:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=dpPUvCCKpjFHvTw7M7qo9D/L9M92EOGjM3f2z1I8EgY=; b=
        miS0xXQKsp7xYOVgXdKq9deBVvo8SLra+70diDR0Gqh8bXeZkrBGUxZMGMj39K0W
        GCXO/rQIEzkfepJCcvDkmB6360q96Lm+0Bvau1NGW6SpugW7HXhB1u3NTWrsL9dW
        6TPN00DuRah94MTP4ORT42ZzieFIKUpVzZkGsaxVbPc=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id F0823341E40;
        Wed, 15 Mar 2023 13:47:56 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 15 Mar
 2023 13:47:56 +0300
Date:   Wed, 15 Mar 2023 13:47:57 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <mgurtovoy@nvidia.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 07/18] scsi: target: Treat CMD_T_FABRIC_STOP like
 CMD_T_STOP
Message-ID: <20230315104757.GA30859@yadro.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230309223312.94595-8-michael.christie@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 04:33:01PM -0600, Mike Christie wrote:
> 
> iscsit will set CMD_T_FABRIC_STOP on running commands when its transport
> connection is down and it can't send/recv IO (tx/rx threads are killed
> or the cleanup thread is run from the one thats up). It will then loop
> over running commands and wait for LIO core to complete them or clean
> them up if they were on an internal queue waiting to be sent or ackd.

The current usage of CMD_T_FABRIC_STOP and CMD_T_ABORTED is to
distinguish will command be aborted or finished at the connection release.
Technically that means who is in charge to decrease the command's kref.

The current usage of CMD_T_FABRIC_STOP and CMD_T_ABORTED is race free -
it checks and *changes* the state under a lock. They are mutually
exclusive.

> Currently, CMD_T_FABRIC_STOP only stops TMRs from operating on the
> command but for isert we need to prevent LIO core from calling into
> iscsit callouts when the connection is being brought down. If LIO core
> queues commands to iscsit and it ends up adding to an internal queue
> instead of passing back to the driver then we can end up hanging waiting
> on command completion that never occurs because it's stuck on the internal
> list (the tx thread is stopped at this time, so it will never loop over
> the response list and call into isert). We also want to sync up on a
> point where we no longer call into isert so it can cleanup it's structs.

If fabric driver knows that responses will not be completed by HW
then the fabric driver shall itself complete such responses.
Please do not shift this responsibility to LIO core.

> This has LIO core treat CMD_T_FABRIC_STOP like CMD_T_STOP during
> command execution and also fixes the locking around the
> target_cmd_interrupted calls so fabric modules can make sure cmds are
> never marked both CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP.

CMD_T_STOP is some ancient logic that is used to move responses from a failed
connection to a new one during recovery in ERL=2.
I believe that CMT_T_STOP logic was reused at connection release just
to reduce conn/session use-after-free cases at command release.

Thanks to this patchset all commands in the connection are waited for
the completion in iscsit_release_commands_from_conn(). Is there any
sense to use CMD_T_STOP mechanism there now? I believe it's time to
remove it and to become like other fabric drivers - just wait for commands
in async manner. For connection release CMT_T_STOP is definitely
superfluous and error prone now.

The long story short, at connection release with ERL=0 I propose to
completely avoid CMD_T_STOP logic instead of reusing CMD_T_STOP logic.

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_sbc.c       |  2 +-
>  drivers/target/target_core_transport.c | 27 +++++++++++++++-----------
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index c1cf37a1b4ce..ff1ae779543f 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -457,7 +457,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>                  * we don't have to perform the write operation.
>                  */
>                 WARN_ON(!(cmd->transport_state &
> -                       (CMD_T_ABORTED | CMD_T_STOP)));
> +                       (CMD_T_ABORTED | CMD_T_STOP | CMD_T_FABRIC_STOP)));
>                 goto out;
>         }
>         /*
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 86adff2a86ed..1c23079a5d7f 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -737,8 +737,8 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
>          * Determine if frontend context caller is requesting the stopping of
>          * this command for frontend exceptions.
>          */
> -       if (cmd->transport_state & CMD_T_STOP) {
> -               pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
> +       if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
> +               pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP for ITT: 0x%08llx\n",
>                         __func__, __LINE__, cmd->tag);

For example, this snippet forbids kref decrement for CMD_TFABRIC_STOP
commands although it is supposed to happen - that is a decrement from
Core meaning that Core is not needed in this command any more.
> 
>                 spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> @@ -889,7 +889,7 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
>                 INIT_WORK(&cmd->work, target_abort_work);
>                 queue_work(target_completion_wq, &cmd->work);
>                 return true;
> -       } else if (cmd->transport_state & CMD_T_STOP) {
> +       } else if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
>                 if (cmd->transport_complete_callback)
>                         cmd->transport_complete_callback(cmd, false, &post_ret);
>                 complete_all(&cmd->t_transport_stop_comp);
> @@ -907,13 +907,15 @@ void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
>         int success, cpu;
>         unsigned long flags;
> 
> -       if (target_cmd_interrupted(cmd))
> +       spin_lock_irqsave(&cmd->t_state_lock, flags);
> +       if (target_cmd_interrupted(cmd)) {
> +               spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>                 return;
> +       }
> 
>         cmd->scsi_status = scsi_status;
>         cmd->sense_reason = sense_reason;
> 
> -       spin_lock_irqsave(&cmd->t_state_lock, flags);
>         switch (cmd->scsi_status) {
>         case SAM_STAT_CHECK_CONDITION:
>                 if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
> @@ -2277,10 +2279,12 @@ void target_execute_cmd(struct se_cmd *cmd)
>          *
>          * If the received CDB has already been aborted stop processing it here.
>          */
> -       if (target_cmd_interrupted(cmd))
> +       spin_lock_irq(&cmd->t_state_lock);
> +       if (target_cmd_interrupted(cmd)) {
> +               spin_unlock_irq(&cmd->t_state_lock);
>                 return;
> +       }
> 
> -       spin_lock_irq(&cmd->t_state_lock);
>         cmd->t_state = TRANSPORT_PROCESSING;
>         cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
>         spin_unlock_irq(&cmd->t_state_lock);
> @@ -2847,9 +2851,9 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>          * Determine if frontend context caller is requesting the stopping of
>          * this command for frontend exceptions.
>          */
> -       if (cmd->transport_state & CMD_T_STOP &&
> +       if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP) &&
>             !cmd->se_tfo->write_pending_must_be_called) {
> -               pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
> +               pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOPfor ITT: 0x%08llx\n",
>                          __func__, __LINE__, cmd->tag);
> 
>                 spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> @@ -2880,11 +2884,12 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
>         bool stop;
> 
>         spin_lock_irqsave(&cmd->t_state_lock, flags);
> -       stop = (cmd->transport_state & (CMD_T_STOP | CMD_T_ABORTED));
> +       stop = (cmd->transport_state &
> +               (CMD_T_STOP | CMD_T_FABRIC_STOP | CMD_T_ABORTED));
>         spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> 
>         if (stop) {
> -               pr_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
> +               pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
>                         __func__, __LINE__, cmd->tag);
>                 complete_all(&cmd->t_transport_stop_comp);
>                 return;
> --
> 2.31.1
> 
> 

