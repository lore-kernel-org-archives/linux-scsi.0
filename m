From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/11] scsi: add new scsi-command flag for tagged commands
Date: Tue, 04 Nov 2014 09:38:05 +0100
Message-ID: <5458906D.4090708@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaKDIiI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:38:08 -0500
In-Reply-To: <1415087656-9491-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> Currently scsi piggy backs on the block layer to define the concept
> of a tagged command.  But we want to be able to have block-level host=
-wide
> tags assigned even for untagged commands like the initial INQUIRY, so=
 add
> a new SCSI-level flag for commands that are tagged at the scsi level,=
 so
> that even commands without that set can have tags assigned to them.  =
Note
> that this alredy is the case for the blk-mq code path, and this just =
lets
> the old path catch up with it.
>=20
> We also set this flag based upon sdev->simple_tags instead of the blo=
ck
> queue flag, so that it is entirely independent of the block layer tag=
ging,
> and thus always correct even if a driver doesn't use block level tagg=
ing
> yet.
>=20
> Also remove the old blk_rq_tagged; it was only used by SCSI drivers, =
and
> removing it forces them to look for the proper replacement.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/block/biodoc.txt     |  4 ----
>  block/blk-core.c                   |  4 ++--
>  drivers/scsi/53c700.c              |  6 +++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c |  2 +-
>  drivers/scsi/scsi_lib.c            | 13 +++++++++----
>  drivers/usb/storage/uas.c          |  2 +-
>  include/linux/blkdev.h             |  1 -
>  include/scsi/scsi_cmnd.h           |  4 ++++
>  include/scsi/scsi_tcq.h            |  6 ++----
>  9 files changed, 22 insertions(+), 20 deletions(-)
>=20
> diff --git a/Documentation/block/biodoc.txt b/Documentation/block/bio=
doc.txt
> index 2101e71..6b972b2 100644
> --- a/Documentation/block/biodoc.txt
> +++ b/Documentation/block/biodoc.txt
> @@ -827,10 +827,6 @@ but in the event of any barrier requests in the =
tag queue we need to ensure
>  that requests are restarted in the order they were queue. This may h=
appen
>  if the driver needs to use blk_queue_invalidate_tags().
> =20
> -Tagging also defines a new request flag, REQ_QUEUED. This is set whe=
never
> -a request is currently tagged. You should not use this flag directly=
,
> -blk_rq_tagged(rq) is the portable way to do so.
> -
>  3.3 I/O Submission
> =20
>  The routine submit_bio() is used to submit a single io. Higher level=
 i/o
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 0421b53..2e7424b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1266,7 +1266,7 @@ void blk_requeue_request(struct request_queue *=
q, struct request *rq)
>  	blk_clear_rq_complete(rq);
>  	trace_block_rq_requeue(q, rq);
> =20
> -	if (blk_rq_tagged(rq))
> +	if (rq->cmd_flags & REQ_QUEUED)
>  		blk_queue_end_tag(q, rq);
> =20
>  	BUG_ON(blk_queued_rq(rq));
> @@ -2554,7 +2554,7 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
>   */
>  void blk_finish_request(struct request *req, int error)
>  {
> -	if (blk_rq_tagged(req))
> +	if (req->cmd_flags & REQ_QUEUED)
>  		blk_queue_end_tag(req->q, req);
> =20
>  	BUG_ON(blk_queued_rq(req));
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 474cc6d..5143d32 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1767,7 +1767,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp,=
 void (*done)(struct scsi_cmnd *)
>  	 */
>  	if(NCR_700_get_depth(SCp->device) !=3D 0
>  	   && (!(hostdata->tag_negotiated & (1<<scmd_id(SCp)))
> -	       || !blk_rq_tagged(SCp->request))) {
> +	       || !(SCp->flags & SCMD_TAGGED))) {
>  		CDEBUG(KERN_ERR, SCp, "has non zero depth %d\n",
>  		       NCR_700_get_depth(SCp->device));
>  		return SCSI_MLQUEUE_DEVICE_BUSY;
> @@ -1795,7 +1795,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp,=
 void (*done)(struct scsi_cmnd *)
>  	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
>  	scsi_print_command(SCp);
>  #endif
> -	if(blk_rq_tagged(SCp->request)
> +	if ((SCp->flags & SCMD_TAGGED)
>  	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp))) =3D=3D 0
>  	   && NCR_700_get_tag_neg_state(SCp->device) =3D=3D NCR_700_START_T=
AG_NEGOTIATION) {
>  		scmd_printk(KERN_ERR, SCp, "Enabling Tag Command Queuing\n");
> @@ -1809,7 +1809,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp,=
 void (*done)(struct scsi_cmnd *)
>  	 *
>  	 * FIXME: This will royally screw up on multiple LUN devices
>  	 * */
> -	if(!blk_rq_tagged(SCp->request)
> +	if (!(SCp->flags & SCMD_TAGGED)
>  	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp)))) {
>  		scmd_printk(KERN_INFO, SCp, "Disabling Tag Command Queuing\n");
>  		hostdata->tag_negotiated &=3D ~(1<<scmd_id(SCp));
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xx=
x/aic7xxx_osm.c
> index d2c9bf3..63bae7c 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1447,7 +1447,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, st=
ruct ahc_linux_device *dev,
>  	 * we are storing a full busy target *lun*
>  	 * table in SCB space.
>  	 */
> -	if (!blk_rq_tagged(cmd->request)
> +	if (!(cmd->flags & SCMD_TAGGED)
>  	    && (ahc->features & AHC_SCB_BTT) =3D=3D 0) {
>  		int target_offset;
> =20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fc0a8a0..6b57fae 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1740,7 +1740,7 @@ static void scsi_request_fn(struct request_queu=
e *q)
>  		 * we add the dev to the starved list so it eventually gets
>  		 * a run when a tag is freed.
>  		 */
> -		if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
> +		if (blk_queue_tagged(q) && !(req->cmd_flags & REQ_QUEUED)) {
>  			spin_lock_irq(shost->host_lock);
>  			if (list_empty(&sdev->starved_entry))
>  				list_add_tail(&sdev->starved_entry,
> @@ -1754,6 +1754,11 @@ static void scsi_request_fn(struct request_que=
ue *q)
> =20
>  		if (!scsi_host_queue_ready(q, shost, sdev))
>  			goto host_not_ready;
> +=09
> +		if (sdev->simple_tags)
> +			cmd->flags |=3D SCMD_TAGGED;
> +		else
> +			cmd->flags &=3D ~SCMD_TAGGED;
> =20
>  		/*
>  		 * Finally, initialize any error handling parameters, and set up
> @@ -1908,10 +1913,10 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx=
 *hctx, struct request *req,
>  		blk_mq_start_request(req);
>  	}
> =20
> -	if (blk_queue_tagged(q))
> -		req->cmd_flags |=3D REQ_QUEUED;
> +	if (sdev->simple_tags)
> +		cmd->flags |=3D SCMD_TAGGED;
>  	else
> -		req->cmd_flags &=3D ~REQ_QUEUED;
> +		cmd->flags &=3D ~SCMD_TAGGED;
> =20
>  	scsi_init_cmd_errh(cmd);
>  	cmd->scsi_done =3D scsi_mq_done;
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 89b2434..b38bc13 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -181,7 +181,7 @@ static int uas_get_tag(struct scsi_cmnd *cmnd)
>  {
>  	int tag;
> =20
> -	if (blk_rq_tagged(cmnd->request))
> +	if (cmnd->flags & SCMD_TAGGED)
>  		tag =3D cmnd->request->tag + 2;
>  	else
>  		tag =3D 1;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index aac0f9e..6d76b8b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1136,7 +1136,6 @@ static inline bool blk_needs_flush_plug(struct =
task_struct *tsk)
>  /*
>   * tag stuff
>   */
> -#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
>  extern int blk_queue_start_tag(struct request_queue *, struct reques=
t *);
>  extern struct request *blk_queue_find_tag(struct request_queue *, in=
t);
>  extern void blk_queue_end_tag(struct request_queue *, struct request=
 *);
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 522a5f27..e119142 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -53,6 +53,9 @@ struct scsi_pointer {
>  	volatile int phase;
>  };
> =20
> +/* for scmd->flags */
> +#define SCMD_TAGGED		(1 << 0)
> +
>  struct scsi_cmnd {
>  	struct scsi_device *device;
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
> @@ -132,6 +135,7 @@ struct scsi_cmnd {
>  					 * to be at an address < 16Mb). */
> =20
>  	int result;		/* Status code from lower level driver */
> +	int flags;		/* Command flags */
> =20
>  	unsigned char tag;	/* SCSI-II queued command tag */
>  };
Hmm. Flags with just one value in it ...
bitfield, maybe?

> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index 3090fd0..8f16b94a 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -101,11 +101,9 @@ static inline void scsi_deactivate_tcq(struct sc=
si_device *sdev, int depth)
>   **/
>  static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char =
*msg)
>  {
> -        struct request *req =3D cmd->request;
> -
> -        if (blk_rq_tagged(req)) {
> +        if (cmd->flags & SCMD_TAGGED) {
>  		*msg++ =3D MSG_SIMPLE_TAG;
> -        	*msg++ =3D req->tag;
> +        	*msg++ =3D cmd->request->tag;
>          	return 2;
>  	}
> =20
>=20
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
