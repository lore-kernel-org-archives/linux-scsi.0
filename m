From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 08/16] scsi: fc: implement kref backed reference
 counting
Date: Thu, 13 Oct 2016 13:42:06 +0200
Message-ID: <de95cfc4-39df-1eb4-a868-c274cb139ede@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <60854e8cdb8b2306d403973ff3759e3650e7d0de.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <60854e8cdb8b2306d403973ff3759e3650e7d0de.1476276823.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Implement kref backed reference counting instead of rolling our own. This
> elimnates the need of the following fields in 'struct fc_bsg_job':
> * ref_cnt
> * state_flags
> * job_lock
> bringing us close to unification of 'struct fc_bsg_job' and 'struct bsg_job'.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_transport_fc.c | 38 +++++++++-----------------------------
>  include/scsi/scsi_transport_fc.h |  4 +---
>  2 files changed, 10 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 96b3a2e..b0e28af 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3560,16 +3560,9 @@ fc_vport_sched_delete(struct work_struct *work)
>   * @job:	fc_bsg_job that is to be torn down
>   */
>  static void
> -fc_destroy_bsgjob(struct fc_bsg_job *job)
> +fc_destroy_bsgjob(struct kref *kref)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&job->job_lock, flags);
> -	if (job->ref_cnt) {
> -		spin_unlock_irqrestore(&job->job_lock, flags);
> -		return;
> -	}
> -	spin_unlock_irqrestore(&job->job_lock, flags);
> +	struct fc_bsg_job *job = container_of(kref, struct fc_bsg_job, kref);
>  
>  	put_device(job->dev);	/* release reference for the request */
>  
> @@ -3620,15 +3613,9 @@ EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
>  static void fc_bsg_softirq_done(struct request *rq)
>  {
>  	struct fc_bsg_job *job = rq->special;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&job->job_lock, flags);
> -	job->state_flags |= FC_RQST_STATE_DONE;
> -	job->ref_cnt--;
> -	spin_unlock_irqrestore(&job->job_lock, flags);
>  
>  	blk_end_request_all(rq, rq->errors);
> -	fc_destroy_bsgjob(job);
> +	kref_put(&job->kref, fc_destroy_bsgjob);
>  }
>  
>  /**
Hmm. blk_end_request_all() (potentially) triggers a recursion into all
.end_io callbacks, which might end up doing god-knows-what.
With some delays in doing so
During that time we have no idea that bsg_softirq_done() is actually
running, and we might clash with eg. timeouts or somesuch.

Maybe it's an idea to move blk_end_request_all into the kref destroy
callback; that way we're guaranteed to call it only once and would avoid
this situation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
