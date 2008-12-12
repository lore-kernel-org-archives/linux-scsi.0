From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Fri, 12 Dec 2008 11:28:52 -0800 (PST)
Message-ID: <20081212192852.2F535108047@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYLLT3b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 14:29:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBCJTAqF026003
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 11:29:11 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #9 from anonymous@kernel-bugs.osdl.org  2008-12-12 11:28 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Fri, 2008-12-12 at 09:09 -0600, James Bottomley wrote:
> On Fri, 2008-12-12 at 02:22 -0800, Mike Anderson wrote:
> > bugme-daemon@bugzilla.kernel.org <bugme-daemon@bugzilla.kernel.org> wrote:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12195
> > > 
> > > 
> > > 
> > > 
> > > 
> > > ------- Comment #6 from ming.m.lin@intel.com  2008-12-11 18:27 -------
> > > 2.6.28-rc8 also panic
> > 
> > The blk_mark_rq_complete check should prevent completions from occurring on
> > already timed out requests unless the interaction previous mentioned between
> > mpt_fault_reset_work and the scsi eh thread requeue alows the REQ_ATOM_COMPLETE
> > bit to get cleared prior to the scsi_done being called from
> > mptscsih_flush_running_cmds. This did not look obvious to hit.
> > 
> > mpt_fault_reset_work
> > 	mpt_HardResetHandler
> > 		mpt_signal_reset
> > 			mptsas_ioc_reset 
> > 				mptscsih_flush_running_cmds
> > 		mpt_do_ioc_recovery
> 
> Actually, this isn't quite true.  Particularly in the eh case.  It looks
> like the block timeout isn't stopped until blk_complete_request() which
> is pretty late.  If the timeout fires after scsi_done is called but
> before we complete the request, any timeout goes through the
> BLK_EH_HANDLED path to __blk_complete_request().  This routine
> unconditionally adds to the done routine without checking the mark, so
> there is a window where we can get double dones.

Actually, I take that back ... the patch to plug the unprep race was
send over the list but never applied because the timer changes seemed to
fix the problem.

So, we still have a small window where unprep can NULL out rq->special
while an asynchronous mpt reset is flushing the commands via scsi_done.

Could you see if it goes away (or at least lessens in frequency) with
this patch?

Thanks,

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 111f9e9..f2f51e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -653,8 +653,8 @@ static void scsi_requeue_command(struct request_queue *q,
struct scsi_cmnd *cmd)
        struct request *req = cmd->request;
        unsigned long flags;

-       scsi_unprep_request(req);
        spin_lock_irqsave(q->queue_lock, flags);
+       scsi_unprep_request(req);
        blk_requeue_request(q, req);
        spin_unlock_irqrestore(q->queue_lock, flags);



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
