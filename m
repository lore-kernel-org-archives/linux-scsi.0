From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 8/8] scsi: hpsa: use blk_mq to solve irq affinity issue
Date: Tue, 6 Feb 2018 17:51:41 +0800
Message-ID: <20180206095135.GA15518@ming.t460p>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-9-ming.lei@redhat.com>
 <38210970-dfa3-9bac-124c-92065b10f4b3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38210970-dfa3-9bac-124c-92065b10f4b3@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 06, 2018 at 09:39:26AM +0100, Hannes Reinecke wrote:
> On 02/05/2018 04:20 PM, Ming Lei wrote:
> > This patch uses .force_blk_mq to drive HPSA via SCSI_MQ, meantime maps
> > each reply queue to blk_mq's hw queue, then .queuecommand can always
> > choose the hw queue as the reply queue. And if no any online CPU is
> > mapped to one hw queue, request can't be submitted to this hw queue
> > at all, finally the irq affinity issue is solved.
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Arun Easi <arun.easi@cavium.com>
> > Cc: Omar Sandoval <osandov@fb.com>,
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> > Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> > Cc: Christoph Hellwig <hch@lst.de>,
> > Cc: Don Brace <don.brace@microsemi.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Peter Rivera <peter.rivera@broadcom.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/hpsa.c | 51 ++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 34 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 443eabf63a9f..e517a4c74a28 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -51,6 +51,7 @@
> >  #include <linux/jiffies.h>
> >  #include <linux/percpu-defs.h>
> >  #include <linux/percpu.h>
> > +#include <linux/blk-mq-pci.h>
> >  #include <asm/unaligned.h>
> >  #include <asm/div64.h>
> >  #include "hpsa_cmd.h"
> > @@ -956,6 +957,13 @@ static struct device_attribute *hpsa_shost_attrs[] = {
> >  #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
> >  				 HPSA_MAX_CONCURRENT_PASSTHRUS)
> >  
> > +static int hpsa_map_queues(struct Scsi_Host *shost)
> > +{
> > +        struct ctlr_info *h = shost_to_hba(shost);
> > +
> > +        return blk_mq_pci_map_queues(&shost->tag_set, h->pdev);
> > +}
> > +
> >  static struct scsi_host_template hpsa_driver_template = {
> >  	.module			= THIS_MODULE,
> >  	.name			= HPSA,
> > @@ -974,10 +982,13 @@ static struct scsi_host_template hpsa_driver_template = {
> >  #ifdef CONFIG_COMPAT
> >  	.compat_ioctl		= hpsa_compat_ioctl,
> >  #endif
> > +	.map_queues = hpsa_map_queues,
> >  	.sdev_attrs = hpsa_sdev_attrs,
> >  	.shost_attrs = hpsa_shost_attrs,
> >  	.max_sectors = 1024,
> >  	.no_write_same = 1,
> > +	.force_blk_mq = 1,
> > +	.host_tagset = 1,
> >  };
> >  
> >  static inline u32 next_command(struct ctlr_info *h, u8 q)
> > @@ -1045,11 +1056,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c,
> >  		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
> >  		if (unlikely(!h->msix_vectors))
> >  			return;
> > -		if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
> > -			c->Header.ReplyQueue =
> > -				raw_smp_processor_id() % h->nreply_queues;
> > -		else
> > -			c->Header.ReplyQueue = reply_queue % h->nreply_queues;
> > +		c->Header.ReplyQueue = reply_queue;
> >  	}
> >  }
> >  
> > @@ -1063,10 +1070,7 @@ static void set_ioaccel1_performant_mode(struct ctlr_info *h,
> >  	 * Tell the controller to post the reply to the queue for this
> >  	 * processor.  This seems to give the best I/O throughput.
> >  	 */
> > -	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
> > -		cp->ReplyQueue = smp_processor_id() % h->nreply_queues;
> > -	else
> > -		cp->ReplyQueue = reply_queue % h->nreply_queues;
> > +	cp->ReplyQueue = reply_queue;
> >  	/*
> >  	 * Set the bits in the address sent down to include:
> >  	 *  - performant mode bit (bit 0)
> > @@ -1087,10 +1091,7 @@ static void set_ioaccel2_tmf_performant_mode(struct ctlr_info *h,
> >  	/* Tell the controller to post the reply to the queue for this
> >  	 * processor.  This seems to give the best I/O throughput.
> >  	 */
> > -	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
> > -		cp->reply_queue = smp_processor_id() % h->nreply_queues;
> > -	else
> > -		cp->reply_queue = reply_queue % h->nreply_queues;
> > +	cp->reply_queue = reply_queue;
> >  	/* Set the bits in the address sent down to include:
> >  	 *  - performant mode bit not used in ioaccel mode 2
> >  	 *  - pull count (bits 0-3)
> > @@ -1109,10 +1110,7 @@ static void set_ioaccel2_performant_mode(struct ctlr_info *h,
> >  	 * Tell the controller to post the reply to the queue for this
> >  	 * processor.  This seems to give the best I/O throughput.
> >  	 */
> > -	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
> > -		cp->reply_queue = smp_processor_id() % h->nreply_queues;
> > -	else
> > -		cp->reply_queue = reply_queue % h->nreply_queues;
> > +	cp->reply_queue = reply_queue;
> >  	/*
> >  	 * Set the bits in the address sent down to include:
> >  	 *  - performant mode bit not used in ioaccel mode 2
> > @@ -1152,11 +1150,27 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
> >  		h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
> >  }
> >  
> > +static unsigned get_reply_queue(struct ctlr_info *h, struct CommandList *c)
> > +{
> > +	struct scsi_cmnd *cmd = c->scsi_cmd;
> > +	int *map;
> > +
> > +	if (cmd && cmd->request) {
> > +		u32 tag = blk_mq_unique_tag(cmd->request);
> > +		return blk_mq_unique_tag_to_hwq(tag);
> > +	}
> > +
> > +	map = h->scsi_host->tag_set.mq_map;
> > +	return map[raw_smp_processor_id()];
> > +}
> > +
> >  static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
> >  	struct CommandList *c, int reply_queue)
> >  {
> >  	dial_down_lockup_detection_during_fw_flash(h, c);
> >  	atomic_inc(&h->commands_outstanding);
> > +
> > +	reply_queue = get_reply_queue(h, c);
> >  	switch (c->cmd_type) {
> >  	case CMD_IOACCEL1:
> >  		set_ioaccel1_performant_mode(h, c, reply_queue);
> > @@ -5781,6 +5795,9 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
> >  {
> >  	int rv;
> >  
> > +	/* map reply queue to blk_mq hw queue */
> > +	h->scsi_host->nr_hw_queues = h->msix_vectors;
> > +
> >  	rv = scsi_add_host(h->scsi_host, &h->pdev->dev);
> >  	if (rv) {
> >  		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
> > 
> I really wonder why we need to call 'raw_smp_processor' here; typically
> the queue should be encoded in the tag, so it would be better to call
> blk_mq_unique_tag()/blk_mq_unique_tag_to_hwq() here to get the hardware
> queue.

HPSA may send internal command(no any request attached) to HBA directly,
that is why raw_smp_processor() is used here. As you saw in patch 7, command
can be submitted to HBA even before adding scsi host...

I admit it is ugly, but that should be something we can survive, at least blk-mq
provides one simply approach to get the correct(or default) hw/reply queue for
submission req. 

Thanks,
Ming
