From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
	Scsi_Host->cmd_serial_number to atomic_t
Date: Fri, 24 Sep 2010 13:57:52 -0700
Message-ID: <1285361872.1849.249.camel@haakon2.linux-iscsi.org>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
	 <4C93BB8E.2080501@cisco.com> <4C9427B6.9050404@cs.wisc.edu>
	 <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
	 <1285278389.1849.199.camel@haakon2.linux-iscsi.org>
	 <4C9C4604.1020804@kernel.dk>  <20100924183305.GA15128@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36448 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754778Ab0IXVCL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 17:02:11 -0400
In-Reply-To: <20100924183305.GA15128@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>

On Fri, 2010-09-24 at 11:33 -0700, Mike Anderson wrote:
> Jens Axboe <axboe@kernel.dk> wrote:
> > On 2010-09-23 23:46, Nicholas A. Bellinger wrote:
> > > On Sat, 2010-09-18 at 12:58 -0700, Nicholas A. Bellinger wrote:
> > >> On Fri, 2010-09-17 at 21:45 -0500, Mike Christie wrote:

<SNIP>

> > > Greetings Mike and Co,
> > > 
> > > I was doing some followup on these items for a v3 series and started
> > > with a patch following mnc's recommendations for dropping the
> > > scsi_error.c codes depending upon struct scsi_cmnd->serial_number:
> > > 
> > > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > > index 1de30eb..f35c127 100644
> > > --- a/drivers/scsi/scsi_error.c
> > > +++ b/drivers/scsi/scsi_error.c
> > > @@ -644,11 +644,7 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> > >   */
> > >  static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> > >  {
> > > -       /*
> > > -        * scsi_done was called just after the command timed out and before
> > > -        * we had a chance to process it. (db)
> > > -        */
> > > -       if (scmd->serial_number == 0)
> > > +       if (test_bit(REQ_ATOM_COMPLETE, &scmd->request->atomic_flags))
> > >                 return SUCCESS;
> > >         return __scsi_try_to_abort_cmd(scmd);
> > >  }
> > > 
> > > and while building I noticed that the simple single enum
> > > REQ_ATOM_COMPLETE=0 is
> > 
> > > currently located in block/blk.h and along with blk_mark_rq_complete()
> > > and blk_clear_rq_complete() for setting this bit within struct
> > > request->atomic_flags.
> > > 
> > > jens, hch, tejun, and co, do you guys have a preference how this
> > > should be handled so that scsi_try_to_abort_cmd() can use proper
> > > atomic struct request bits here and we can get rid of this (racy..?)
> > > method of using struct scsi_cmnd->serial_number for anything wrt to
> > > per struct scsi_cmnd context timeout handling.
> > 
> > Just add a
> > 
> > static inline int blk_test_rq_complete(struct request *rq)
> > {
> >         return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
> > }
> > 
> > in block/blk.h
> > 
> > I need this too for some lockless completion patches I am playing with.
> 

Greetings Mike,

> In reviewing the current code paths wasn't the serial_number also used to
> avoid calling __scsi_try_to_abort_cmd for START_UNIT case also.

Not sure on this item, but checking on this now..

> 
> If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it would
> be correct for the scsi_decide_disposition cases but it would appear this
> would stop __scsi_try_to_abort_cmd from being called in the time out
> case as REQ_ATOM_COMPLETE is set prior to calling blk_rq_timed_out.

Hmmmmmmm..

> 
> 1.) Request timed out path to scsi_eh_scmd_add.
> 
> blk_rq_timed_out_timer
> 	...
> 	if (blk_mark_rq_complete(rq))
> 		continue;
> 	blk_rq_timed_out
> 		q->rq_timed_out_fn "scsi_times_out"
> 			scsi_times_out
> 				scsi_eh_scmd_add
> 
> 2.) Request completion path to scsi_eh_scmd_add based on
> scsi_decide_disposition disposition set to FAILED (actually
> scsi_eh_scmd_add called from the default case with the disposition of
> FAILED appearing to be the only disposition returned that would hit this
> case vs. the other three handled cases). This should not be a common path
> outside of handling allow_restart.
> 
> blk_complete_request
> 	...
> 	if (!blk_mark_rq_complete(req))
> 		__blk_complete_request
> 			...
> 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
> blk_done_softirq
> 	rq->q->softirq_done_fn "scsi_softirq_done"
> 		scsi_softirq_done
> 			scsi_eh_scmd_add
> 
> 3.) Call path to scsi_try_to_abort_cmd.
> scsi_error_handler
> 	scsi_unjam_host
> 		scsi_eh_abort_cmds
> 			scsi_try_to_abort_cmd
> Thanks,
> 

Ok, what I think is being said here is that the usage of
blk_test_rq_complete() in scsi_try_to_abort_cmd() completly breaks 
__scsi_try_to_abort_cmd from being called from within the struct request
timeout handler, right..?

Not being exquistiely fimilar with the scsi_error.c generic LLD logic w/
struct request timeouts code, I assume this means we need to revisit
scsi_unjam_host() once again to take into account the new
blk_test_rq_complete() calls from the normal fast path block softirq in
order to be able to handle the individual struct request timeout cases
for outstanding struct scsi_cmnd when they individual timer contexts
fire.

Perhaps we should be setting another bit in struct request->atomic_flags
to signal the REQ_BLKSOFTIRQ_COMPLETE to let scsi_unjam_host() know what
is going on..?

Thanks for your comments Mike!

--nab

