From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] target: Fix transport_cmd_finish_abort queue
 removal bug
Date: Sun, 09 Oct 2011 02:06:45 -0700
Message-ID: <1318151205.4978.137.camel@haakon2.linux-iscsi.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
	 <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
	 <20111009013326.GC32104@infradead.org>
	 <1318125812.4978.106.camel@haakon2.linux-iscsi.org>
	 <20111009022749.GB7948@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111009022749.GB7948@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-10-08 at 22:27 -0400, Christoph Hellwig wrote:
> On Sat, Oct 08, 2011 at 07:03:32PM -0700, Nicholas A. Bellinger wrote:
> > The reordering in transport_cmd_finish_abort() was not the issue here,
> > but the calling transport_remove_cmd_from_queue() when 'remove == 0'.
> >
> > This should not be a problem in transport_cmd_finish_abort_tmr() as we
> > always expect to release the tmr associated command.
> 
> I know, but I'd really not have subtily different calling conventions
> between the two.
> 
> Right now transport_cmd_finish_abort and transport_cmd_finish_abort_tmr
> only differ in:
> 
>  - transport_cmd_finish_abort calling transport_lun_remove_cmd
>  - transport_cmd_finish_abort having the remove flag to make the
>    transport_put_cmd (and with your patch the
>    transport_remove_cmd_from_queue) call optional.
> 
> I'd much rather add a conditional on the command beeing a TMR and merge
> the two into a single helper than having them diverge further.

Fair enough..  Merging the two with the following patch.

commit c2b6a8188ccece6ac225e8e8a72f91bcb7dc295a
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Oct 9 02:02:51 2011 -0700

    target: Merge transport_cmd_finish_abort_tmr into transport_cmd_finish_abort
    
    This patch merges transport_cmd_finish_abort_tmr() logic into a single
    transport_cmd_finish_abort() function by adding a cmd->se_tmr_req check
    around transport_lun_remove_cmd(), and updates the single caller within
    core_tmr_drain_tmr_list().
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Cc: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 527e96b..79e26a4 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -162,7 +162,7 @@ static void core_tmr_drain_tmr_list(
                        (preempt_and_abort_list) ? "Preempt" : "", tmr,
                        tmr->function, tmr->response, cmd->t_state);
                
-               transport_cmd_finish_abort_tmr(cmd);
+               transport_cmd_finish_abort(cmd, 1);
        }
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 73856dc..db41eb9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -595,7 +595,8 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-       transport_lun_remove_cmd(cmd);
+       if (!cmd->se_tmr_req)
+               transport_lun_remove_cmd(cmd);
 
        if (transport_cmd_check_stop_to_fabric(cmd))
                return;
@@ -605,16 +606,6 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
        }
 }
 
-void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
-{
-       transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
-
-       if (transport_cmd_check_stop_to_fabric(cmd))
-               return;
-
-       transport_put_cmd(cmd);
-}
-
 static void transport_add_cmd_to_queue(
        struct se_cmd *cmd,
        int t_state)
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 7f41fb2..065fb65 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -134,7 +134,6 @@ extern void transport_free_session(struct se_session *);
 extern void transport_deregister_session_configfs(struct se_session *);
 extern void transport_deregister_session(struct se_session *);
 extern void transport_cmd_finish_abort(struct se_cmd *, int);
-extern void transport_cmd_finish_abort_tmr(struct se_cmd *);
 extern void transport_complete_sync_cache(struct se_cmd *, int);
 extern void transport_complete_task(struct se_task *, int);
 extern void transport_add_task_to_execute_queue(struct se_task *,
