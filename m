From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12195] "dd" make kernel panic
Date: Fri, 12 Dec 2008 13:28:29 -0600
Message-ID: <1229110109.3262.87.camel@localhost.localdomain>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
	 <20081212022704.5488C108042@picon.linux-foundation.org>
	 <20081212102205.GA16034@linux.vnet.ibm.com>
	 <1229094577.3262.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56773 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbYLLT2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 14:28:23 -0500
In-Reply-To: <1229094577.3262.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

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
@@ -653,8 +653,8 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
+	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 


