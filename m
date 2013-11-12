From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Mon, 11 Nov 2013 20:34:53 -0800
Message-ID: <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>
	 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>
	 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>
	 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
	 <1384219874.12281.42.camel@haakon3.risingtidesystems.com>
	 <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>
	 <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "Moussa Ba (moussaba)" <moussaba@micron.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-11-11 at 20:39 -0600, Michael Christie wrote:
> 
> > On Nov 11, 2013, at 8:32 PM, Michael Christie <michaelc@cs.wisc.edu> wrote:
> > 

<SNIP>

> >>>>> Mike, any idea as to how this might be happening on the initiator
> >>>>> side..?
> >> 
> >> <SNIP>
> >> 
> >> Mmmmm, just noticed a bit of very suspicious logic in open-iscsi.
> >> (CC'ing linux-scsi)
> >> 
> >> Namely, how drivers/scsi/libiscsi.c:iscsi_data_xmit() attempts to drain
> >> conn->cmdqueue and hence call iscsi_prep_scsi_cmd_pdu() + increment
> >> session->cmdsn, without ever checking to see if the CmdSN window may
> >> have already closed..
> >> 
> >> The only CmdSN window check that I see in the I/O dispatch codepath is
> >> in iscsi_queuecommand() -> iscsi_check_cmdsn_window_closed(), but once
> >> iscsi_conn_queue_work() is invoked and process context in
> >> iscsi_xmitworker() -> iscsi_data_xmit() starts to execute, there is
> >> AFAICT no further CmdSN window open checks to ensure the initiator does
> >> not overflow MaxCmdSN..
> >> 
> >> This would very much line up with the type of bug that is being
> >> reported.  Before trying to determine what a possible fix might look
> >> like, can you try the following libiscsi patch to see if your able to
> >> hit either of the BUG's below..?
> >> 
> >> Thanks,
> >> 
> >> --nab
> >> 
> >> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> >> index e399561..9106f63 100644
> >> --- a/drivers/scsi/libiscsi.c
> >> +++ b/drivers/scsi/libiscsi.c
> >> @@ -1483,6 +1483,12 @@ check_mgmt:
> >>                       fail_scsi_task(conn->task, DID_IMM_RETRY);
> >>                       continue;
> >>               }
> >> +
> >> +               if (iscsi_check_cmdsn_window_closed(conn)) {
> >> +                       printk("CmdSN window already closed in iscsi_data_xmit #1\n");
> >> +                       BUG();
> >> +               }
> >> +
> >>               rc = iscsi_prep_scsi_cmd_pdu(conn->task);
> >>               if (rc) {
> >>                       if (rc == -ENOMEM || rc == -EACCES) {
> >> @@ -1518,6 +1524,11 @@ check_mgmt:
> >>               if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
> >>                       break;
> >> 
> >> +               if (iscsi_check_cmdsn_window_closed(conn)) {
> >> +                       printk("CmdSN window already closed in iscsi_data_xmit #2\n");
> >> +                       BUG();
> >> +               }
> >> +
> >>               conn->task = task;
> >>               list_del_init(&conn->task->running);
> >>               conn->task->state = ISCSI_TASK_RUNNING;
> > 
> > If you hit a bug there then it is probably the target or if you are
> using the new libiscsi back/frwd lock patches it could be related to
> them. 

FYI, this is with v3.11 and RHEL 6.x open-iscsi code..

> We should not need to check above because we never queue more cmds
> from the scsi layer than the window will allow at the time. If the
> window is 10, the queued_cmdsn check should make sure we have only
> accepted 10 commands into the iscsi layer so we should not need to
> recheck above.
> > 
> > You should just enable libiscsi debug printk in
> iscsi_check_cmdsn_window so we can see the sn related values at the
> time of queuing. You should enable that printk whithout your patch.
> 
> Actually that will not help because we always have the queued cmdsn
> lower than the max in that path. I would do your patch but then also
> print the queued cmdsn, cmdsn and also the maxcmdsn in the check
> function.
> 
> 

Yes, notice the second test patch is doing the explicit check of
task->cmdsn vs. sess->max_cmdsn, instead of the one that checks
->queued_cmdsn vs. ->max_cmdsn in iscsi_check_cmdsn_window_closed().

Btw, I'm surmising the bug in question does not happen from the
iscsi_queuecommand() submission path, but rather from the
iscsi_update_cmdsn() -> __iscsi_update_cmdsn() completion path, where
iscsi_conn_queue_work() gets called when the CmdSN window was
previously closed, eg:

        if (max_cmdsn != session->max_cmdsn &&
            !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
                session->max_cmdsn = max_cmdsn;
                /*
                 * if the window closed with IO queued, then kick the
                 * xmit thread
                 */
                if (!list_empty(&session->leadconn->cmdqueue) ||
                    !list_empty(&session->leadconn->mgmtqueue))
                        iscsi_conn_queue_work(session->leadconn);
        }
}

Once iscsi_conn_queue_work() is invoked here to start process context
execution of iscsi_xmitworker() -> iscsi_data_xmit() code, AFAICT there
is no logic in place within iscsi_data_xmit() to honor the last received
MaxCmdSN.

Or to put it another way: what is preventing iscsi_data_xmit() from
completely draining both conn->cmdqueue + conn->requeue, even when the
CmdSN window has potentially been closed again..?

--nab
