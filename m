Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC74C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 12:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLIMcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 07:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLIMcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 07:32:08 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B090163B8F;
        Fri,  9 Dec 2022 04:32:06 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 856CC3417B3;
        Fri,  9 Dec 2022 15:32:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=Safx1dGR+dNn1uzm5CK744YeonbXuqljihQpK5LGOt0=; b=
        hiXPF9Zwa1ndMDhKbzsh9kW8tgBXER1GcYNhlomQJDPFrQL1d/ZvpFf1TVfpIWeE
        ek3ubPMtvMsDlNSDztuu53sqPMSrwJVbi8zcz2x7ubWyIY2Uv+Uj6cXoWosAW9Yl
        oXMjYQQhqa/BlvLbXJoHGoP5yJ/mnlxTlfRvdBX9yYs=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 78B68341776;
        Fri,  9 Dec 2022 15:32:04 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Dec 2022
 15:32:04 +0300
Date:   Fri, 9 Dec 2022 15:32:02 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during
 conn close
Message-ID: <20221209123202.GD15327@yadro.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208031002.106700-6-michael.christie@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 09:10:00PM -0600, Mike Christie wrote:
> 
> This fixes 2 bugs added in:
> 
> commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
> race")
> 
> If we have multiple sessions to the same se_device we can hit a race where
> a LUN_RESET on one session cleans up the se_cmds from under another
> session which is being closed. This results in the closing session freeing
> its conn/session structs while they are still in use.
> 
> The bug is:
> 
> 1. Session1 has IO se_cmd1.
> 2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
> but then gets a LUN_RESET.
> 3. The LUN_RESET on session2 sees the se_cmds on session1 and during
> the drain stages marks them all with CMD_T_ABORTED.
> 4. session1 is now closed so iscsit_release_commands_from_conn only sees
> se_cmds with the CMD_T_ABORTED bit set and returns immediately even
> though we have outstanding commands.
> 5. session1's connection and session are freed.
> 6. The backend request for se_cmd1 completes and it accesses the freed
> connection/session.
> 
> If session1 was executing only IO se_cmds and TAS is set on the se_cmd,
> then we need to do a iscsit_free_cmd on those commands, so we wait on
> their completion from LIO core and the backend.
> 
> If session1 was waiting on tmr se_cmds or TAS is not set then we need to
> wait for those outstanding se_cmds to have their last put done so we
> know no user is still accessing them when we free the session/conn.
> 
> This fixes the TAS set case, by adding a check so if we hit it we now call
> iscsit_free_cmd. To handle the tmr se_cd and non TAS case, it hooks the
> iscsit layer into the cmd counter code, so we can wait for all outstanding
> commands before freeing the connection and possibly the session.
> 
> Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 13 +------------
>  drivers/target/iscsi/iscsi_target.c     | 13 ++++++++++++-
>  drivers/target/target_core_transport.c  |  6 ++++--
>  include/target/target_core_fabric.h     |  2 ++
>  4 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index b360a1527cd1..600059d8a3a7 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2501,17 +2501,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
>         }
>  }
> 
> -static void
> -isert_wait4cmds(struct iscsit_conn *conn)
> -{
> -       isert_info("iscsit_conn %p\n", conn);
> -
> -       if (conn->sess) {
> -               target_stop_session(conn->sess->se_sess);
> -               target_wait_for_sess_cmds(conn->sess->se_sess);
> -       }
> -}
> -
>  /**
>   * isert_put_unsol_pending_cmds() - Drop commands waiting for
>   *     unsolicitate dataout
> @@ -2559,7 +2548,7 @@ static void isert_wait_conn(struct iscsit_conn *conn)
> 
>         ib_drain_qp(isert_conn->qp);
>         isert_put_unsol_pending_cmds(conn);
> -       isert_wait4cmds(conn);
> +       target_wait_for_cmds(conn->cmd_cnt);
>         isert_wait4logout(isert_conn);
> 
>         queue_work(isert_release_wq, &isert_conn->release_work);
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 7a8ffdf33bee..1c3470e4b50c 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4221,7 +4221,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> 
>                 if (se_cmd->se_tfo != NULL) {
>                         spin_lock_irq(&se_cmd->t_state_lock);
> -                       if (se_cmd->transport_state & CMD_T_ABORTED) {
> +                       if (se_cmd->transport_state & CMD_T_ABORTED &&
> +                           !(se_cmd->transport_state & CMD_T_TAS)) {
>                                 /*
>                                  * LIO's abort path owns the cleanup for this,
>                                  * so put it back on the list and let

Could you please extract ths snippet (fix of the hanged commands with
TAS) to a separate patch? It looks good.

> @@ -4244,6 +4245,14 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>                 iscsit_free_cmd(cmd, true);
> 
>         }
> +
> +       /*
> +        * Wait on commands that were cleaned up via the aborted_task path.
> +        * LLDs that implement iscsit_wait_conn will already have waited for
> +        * commands.
> +        */
> +       if (!conn->conn_transport->iscsit_wait_conn)
> +               target_wait_for_cmds(conn->cmd_cnt);
>  }
> 
>  static void iscsit_stop_timers_for_cmds(
> @@ -4304,6 +4313,8 @@ int iscsit_close_connection(
>         iscsit_stop_nopin_response_timer(conn);
>         iscsit_stop_nopin_timer(conn);
> 
> +       target_stop_cmd_counter(conn->cmd_cnt);
> +
>         if (conn->conn_transport->iscsit_wait_conn)
>                 conn->conn_transport->iscsit_wait_conn(conn);

I strongly believe that waiting for commands complete before decreasing
the command refcounter is useless and leads to hangings.
There was a several tries to wait for the commands complete in the
session. But all of them were eventually reverted due to iSER [1].
[1] https://lore.kernel.org/all/CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com/

Let's try it one more time - move conn->conn_transport->iscsit_wait_conn(conn)
to the end of iscsit_release_commands_from_conn() to align iser with other
iscsi transports.

Probably, to have target_wait_for_cmds as a default .iscsit_wait_conn
implementation would be the best way.

> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 90e3b1aef1f1..8bbf0c834b74 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3174,13 +3174,14 @@ static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
>   * target_stop_cmd_counter - Stop new IO from being added to the counter.
>   * @cmd_cnt: counter to stop
>   */
> -static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
> +void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
>  {
>         pr_debug("Stopping command counter.\n");
>         if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
>                 percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
>                                             target_stop_cmd_counter_confirm);
>  }
> +EXPORT_SYMBOL_GPL(target_stop_cmd_counter);
> 
>  /**
>   * target_stop_session - Stop new IO from being queued on the session.
> @@ -3196,7 +3197,7 @@ EXPORT_SYMBOL(target_stop_session);
>   * target_wait_for_cmds - Wait for outstanding cmds.
>   * @cmd_cnt: counter to wait for active I/O for.
>   */
> -static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
> +void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
>  {
>         int ret;
> 
> @@ -3212,6 +3213,7 @@ static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
>         wait_for_completion(&cmd_cnt->stop_done);
>         pr_debug("Waiting for cmds done.\n");
>  }
> +EXPORT_SYMBOL_GPL(target_wait_for_cmds);
> 
>  /**
>   * target_wait_for_sess_cmds - Wait for outstanding commands
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 4cbfb532a431..b188b1e90e1e 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -133,6 +133,8 @@ struct se_session *target_setup_session(struct se_portal_group *,
>                                 struct se_session *, void *));
>  void target_remove_session(struct se_session *);
> 
> +void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt);
> +void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt);
>  struct target_cmd_counter *target_alloc_cmd_counter(void);
>  void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt);
> 
> --
> 2.25.1
> 
> 

