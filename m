From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 08/16] scsi: fc: implement kref backed reference
 counting
Date: Thu, 13 Oct 2016 16:40:32 +0200
Message-ID: <20161013144032.n36dbjzle3hzaja3@linux-x5ow.site>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <60854e8cdb8b2306d403973ff3759e3650e7d0de.1476276823.git.jthumshirn@suse.de>
 <de95cfc4-39df-1eb4-a868-c274cb139ede@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752113AbcJMOks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 10:40:48 -0400
Content-Disposition: inline
In-Reply-To: <de95cfc4-39df-1eb4-a868-c274cb139ede@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On Thu, Oct 13, 2016 at 01:42:06PM +0200, Hannes Reinecke wrote:
> On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> > Implement kref backed reference counting instead of rolling our own. This
> > elimnates the need of the following fields in 'struct fc_bsg_job':
> > * ref_cnt
> > * state_flags
> > * job_lock
> > bringing us close to unification of 'struct fc_bsg_job' and 'struct bsg_job'.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/scsi_transport_fc.c | 38 +++++++++-----------------------------
> >  include/scsi/scsi_transport_fc.h |  4 +---
> >  2 files changed, 10 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> > index 96b3a2e..b0e28af 100644
> > --- a/drivers/scsi/scsi_transport_fc.c
> > +++ b/drivers/scsi/scsi_transport_fc.c
> > @@ -3560,16 +3560,9 @@ fc_vport_sched_delete(struct work_struct *work)
> >   * @job:	fc_bsg_job that is to be torn down
> >   */
> >  static void
> > -fc_destroy_bsgjob(struct fc_bsg_job *job)
> > +fc_destroy_bsgjob(struct kref *kref)
> >  {
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&job->job_lock, flags);
> > -	if (job->ref_cnt) {
> > -		spin_unlock_irqrestore(&job->job_lock, flags);
> > -		return;
> > -	}
> > -	spin_unlock_irqrestore(&job->job_lock, flags);
> > +	struct fc_bsg_job *job = container_of(kref, struct fc_bsg_job, kref);
> >  
> >  	put_device(job->dev);	/* release reference for the request */
> >  
> > @@ -3620,15 +3613,9 @@ EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
> >  static void fc_bsg_softirq_done(struct request *rq)
> >  {
> >  	struct fc_bsg_job *job = rq->special;
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&job->job_lock, flags);
> > -	job->state_flags |= FC_RQST_STATE_DONE;
> > -	job->ref_cnt--;
> > -	spin_unlock_irqrestore(&job->job_lock, flags);
> >  
> >  	blk_end_request_all(rq, rq->errors);
> > -	fc_destroy_bsgjob(job);
> > +	kref_put(&job->kref, fc_destroy_bsgjob);
> >  }
> >  
> >  /**
> Hmm. blk_end_request_all() (potentially) triggers a recursion into all
> .end_io callbacks, which might end up doing god-knows-what.
> With some delays in doing so
> During that time we have no idea that bsg_softirq_done() is actually
> running, and we might clash with eg. timeouts or somesuch.
> 
> Maybe it's an idea to move blk_end_request_all into the kref destroy
> callback; that way we're guaranteed to call it only once and would avoid
> this situation.

This _could_ explain the panic with zfcp. Fixed that for v3.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
