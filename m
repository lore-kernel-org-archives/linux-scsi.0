Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4D9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 16:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbiGSQPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 12:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiGSQOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 12:14:17 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233234C610;
        Tue, 19 Jul 2022 09:14:16 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B6D1A412CD;
        Tue, 19 Jul 2022 16:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1658247252; x=1660061653; bh=179YibTfhTaduOIWcJFryeuT3lKurRZvc6L
        tqA8h2bA=; b=Dr2RVgb3c8e4iiPBM/EUArUdTBjez3L2vSH9A9SqFdSDVD6Gtng
        os1FWJTxHwmvRMzryRwvxCy+vks3MPhzaZhpTrZyBrDWEfnK7kI4CzdATfko9Pe1
        VFBNgUpgB+i0MCLZeNTTJt7szwzZH63LzfDAiKGGfh/lZiLiSvuWd/m0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FhINlhgr7-QV; Tue, 19 Jul 2022 19:14:12 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BC8FB412C5;
        Tue, 19 Jul 2022 19:14:11 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 19 Jul 2022 19:14:11 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 19 Jul
 2022 19:14:04 +0300
Date:   Tue, 19 Jul 2022 19:14:03 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Nick Couchman <nick.e.couchman@gmail.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
Message-ID: <20220719161403.GA27979@yadro.com>
References: <20220713204212.7850-1-d.bogdanov@yadro.com>
 <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
 <20220718084534.GA12544@yadro.com>
 <9e1c0853-a5f9-cba0-2f51-05ac773f1fa3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9e1c0853-a5f9-cba0-2f51-05ac773f1fa3@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,
On Mon, Jul 18, 2022 at 04:22:36PM -0500, Mike Christie wrote:
> 
> On 7/18/22 3:45 AM, Dmitry Bogdanov wrote:
> > Hi Mike,
> >
> > On Thu, Jul 14, 2022 at 11:44:25AM -0500, Mike Christie wrote:
> >>
> >> On 7/13/22 3:42 PM, Dmitry Bogdanov wrote:
> >>> Sometimes an initiator does not send data for WRITE commands and tries
> >>> to abort it. The abort hangs waiting for frontend driver completion.
> >>> iSCSI driver waits for for data and that timeout eventually initiates
> >>> connection reinstatment. The connection closing releases the commands in
> >>> the connection, but those aborted commands still did not handle the
> >>> abort and did not decrease a command ref counter. Because of that the
> >>> connection reinstatement hangs indefinitely and prevents re-login for
> >>> that initiator.
> >>>
> >>> This patch adds a handling in TCM of the abort for the WRITE_PENDING
> >>> commands at connection closing moment to make it possible to release
> >>> them.
> >>>
> >>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> >>> ---
> >>>  drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
> >>>  1 file changed, 10 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> >>> index e368f038ff5c..27eca5e72f52 100644
> >>> --- a/drivers/target/iscsi/iscsi_target.c
> >>> +++ b/drivers/target/iscsi/iscsi_target.c
> >>> @@ -26,6 +26,7 @@
> >>>  #include <target/target_core_base.h>
> >>>  #include <target/target_core_fabric.h>
> >>>
> >>> +#include <target/target_core_backend.h>
> >>>  #include <target/iscsi/iscsi_target_core.h>
> >>>  #include "iscsi_target_parameters.h"
> >>>  #include "iscsi_target_seq_pdu_list.h"
> >>> @@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> >>>
> >>>               if (se_cmd->se_tfo != NULL) {
> >>>                       spin_lock_irq(&se_cmd->t_state_lock);
> >>> -                     if (se_cmd->transport_state & CMD_T_ABORTED) {
> >>> +                     if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
> >>> +                         se_cmd->transport_state & CMD_T_ABORTED) {
> >>>                               /*
> >>>                                * LIO's abort path owns the cleanup for this,
> >>>                                * so put it back on the list and let
> >>> @@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> >>>               list_del_init(&cmd->i_conn_node);
> >>>
> >>>               iscsit_increment_maxcmdsn(cmd, sess);
> >>> -             iscsit_free_cmd(cmd, true);
> >>> -
> >>> +             if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
> >>> +                 cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> >>> +                     /* handle an abort in TCM */
> >>> +                     target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
> >>>
> >>
> >> Will we have an extra ref left on the se_cmd if TAS is used so the se_cmd
> >> does not get freed?
> >>
> >> For TAS, it looks like we would do:
> >>
> >> - target_handle_abort -> queue_status. This would not do anything because
> >> before calling iscsit_release_commands_from_conn we have killed the iscsi tx
> >> thread.
> >>
> >> - target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
> >> target_put_sess_cmd.
> >>
> >> iscsi creates the se_cmd with TARGET_SCF_ACK_KREF set so do we have one ref
> >> left?
> > Yes, you are right. TAS case is not covered by my patch. But that is
> > actually another bug (that iSCSI does not complete responses in case of
> > connection closed).
> 
> What do you mean this is a bug already? I mean is there a leak or spec violation?
> 
> Spec wise we don't need to send a response to the initiator when the connection
> is closed for a single connection session and ERL=0. We just can't because the
> connection is down. And the initiator knows it will not be getting a response
> because the connection is gone and cleans up on it's side.
Looks like it is a FC term :) "Completion" there is a confirmation that
a response has been received by a peer and a driver can free its
resources now. A failed completion due to network error (logout for
instance) is a completion too.
Under "iSCSI does not complete responses in case of connection closed"
I meant that iscsi_target does nothing if tcm_core queues a
response/status when iscsi connection is closed already. It does not
"complete" the queued response by decrementing kref by
target_put_sess_cmd like in normal case.

I reproduced that bug by simple test case:
1. Export scsi_debug (with 30s delay) device to Initiator on 2 paths
2. On initiator:
  # make the first IO do some initial IO traffic on the disk to make the
  # second dd to send just one READ_10 command.
  dd if=/dev/sda iflag=direct of=/dev/null bs=512 count=1
  # start 1 IO on the first path that will hang forever eventually
  dd if=/dev/sda iflag=direct of=/dev/null bs=512 count=1 &
  sleep 1
  # LUN_RESET on the second path, to make TAS feature send a response
  # for the command from the first path
  sg_reset -d /dev/sdb &
3. On target:
  # simulate local connection reinstatement (like on DataOut timeout)
  echo 0 > /sys/kernel/config/target/iscsi/iqn/tpg0/enable

In that scenario the connection will be already closed at the moment of
target_handle_abort => queue_status(), iscsi_target will not free that
cmd at the connection closing because that command is CMD_T_ABORTED and
tcm_core will endlessly wait for "completion" of the queued response.

That is that another bug that is not addressed in my patch because it is
really another bug.
My patch fixes only unableness of relogin (due to aborted WRITE_PENDING
commands) that was really catched by our customers. I believe that it
make sense to have it in 5.20.

For RecoveryLevel > 0, I even get a crash on cmd->conn dereference at
lio_queue_status() -> iscsit_add_cmd_to_response_queue().
So, that another bug "TAS when connection is closed" is a complex issue
and to be addressed separatelly.

> 
> If TRANSPORT_WRITE_PENDING is not set then we will drive the cleanup of commands
> internally and not leak memory right? Is there a bug in this path where we also leak
> memory? If that path is ok, can't we handle the TRANSPORT_WRITE_PENDING is set case
> in a similar way?
> 
> This was the patch I had proposed when we discussed this last time. It's completely
> untested, but just to show what I mean. I think it should probably check the t_state
> like how you did it instead of adding a transport_state bit. The idea is that the
> command is never going to get completed and we can't send a response because the
> connection is down. The iscsi layer knows all this and that it hasn't sent the cmd
> to LIO core for backend processing, so it forces the cleanup.
I saw somewhen that patch, but did not tested it. And it does not fixes
that crash too.
> 
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..d0e80a2b653b 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4088,7 +4088,8 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
> 
>                 if (se_cmd->se_tfo != NULL) {
>                         spin_lock_irq(&se_cmd->t_state_lock);
> -                       if (se_cmd->transport_state & CMD_T_ABORTED) {
> +                       if (se_cmd->transport_state & CMD_T_ABORTED &&
> +                           se_cmd->transport_state & CMD_T_SUBMITTED) {
>                                 /*
>                                  * LIO's abort path owns the cleanup for this,
>                                  * so put it back on the list and let
> @@ -4096,7 +4097,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>                                  */
>                                 list_move_tail(&cmd->i_conn_node,
>                                                &conn->conn_cmd_list);
> -                       } else {
> +                       } else if (!(se_cmd->transport_state & CMD_T_ABORTED)) {
>                                 se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>                         }
>                         spin_unlock_irq(&se_cmd->t_state_lock);
> @@ -4108,8 +4109,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>                 list_del_init(&cmd->i_conn_node);
> 
>                 iscsit_increment_maxcmdsn(cmd, sess);
> -               iscsit_free_cmd(cmd, true);
> 
> +               if (se_cmd->transport_state & CMD_T_ABORTED &&
> +                   !(se_cmd->transport_state & CMD_T_SUBMITTED))
> +                       iscsit_free_cmd(cmd, false, true);
> +               else
> +                       iscsit_free_cmd(cmd, true, false);
>         }
>  }
> 
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 6dd5810e2af1..931586595044 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -742,7 +742,7 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>                 conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
>  }
> 
> -void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
> +void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown, bool force_cleanup)
>  {
>         struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>         int rc;
> @@ -751,10 +751,14 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
> 
>         __iscsit_free_cmd(cmd, shutdown);
>         if (se_cmd) {
> -               rc = transport_generic_free_cmd(se_cmd, shutdown);
> +               rc = transport_generic_free_cmd(se_cmd,
> +                                       force_cleanup ? false : shutdown);
>                 if (!rc && shutdown && se_cmd->se_sess) {
>                         __iscsit_free_cmd(cmd, shutdown);
>                         target_put_sess_cmd(se_cmd);
> +               } else if (se_cmd->sess && force_cleanup) {
> +                       __iscsit_free_cmd(cmd, true);
> +                       target_put_sess_cmd(se_cmd);
>                 }
>         } else {
>                 iscsit_release_cmd(cmd);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 14c6f2bb1b01..eb233ea8db65 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1554,7 +1554,7 @@ int transport_handle_cdb_direct(
>          * this to be called for initial descriptor submission.
>          */
>         cmd->t_state = TRANSPORT_NEW_CMD;
> -       cmd->transport_state |= CMD_T_ACTIVE;
> +       cmd->transport_state |= (CMD_T_ACTIVE | CMD_T_SUBMITTED);
> 
>         /*
>          * transport_generic_new_cmd() is already handling QUEUE_FULL,
> @@ -2221,7 +2221,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>                 return;
> 
>         spin_lock_irq(&cmd->t_state_lock);
> -       cmd->t_state = TRANSPORT_PROCESSING;
> +       cmd->t_state = (TRANSPORT_PROCESSING | CMD_T_SUBMITTED);
>         cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
>         spin_unlock_irq(&cmd->t_state_lock);
> 
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index fb11c7693b25..b759ec810fa9 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -511,6 +511,7 @@ struct se_cmd {
>  #define CMD_T_COMPLETE         (1 << 2)
>  #define CMD_T_SENT             (1 << 4)
>  #define CMD_T_STOP             (1 << 5)
> +#define CMD_T_SUBMITTED                (1 << 6)
>  #define CMD_T_TAS              (1 << 10)
>  #define CMD_T_FABRIC_STOP      (1 << 11)
>         spinlock_t              t_state_lock;
> 
> 
> 
