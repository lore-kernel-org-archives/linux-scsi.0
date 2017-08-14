From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Mon, 14 Aug 2017 18:32:17 +0200
Message-ID: <20170814163217.GA18228@bblock-ThinkPad-W530>
References: <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093217.GL24539@lst.de>
 <20170810221038.GA918@bblock-ThinkPad-W530>
 <20170811083808.GA5497@lst.de>
 <20170811091415.GA8099@lst.de>
 <20170811134929.GA1249@bblock-ThinkPad-W530>
 <20170811143649.GA32381@lst.de>
 <20170811153203.GA31625@bblock-ThinkPad-W530>
 <20170811153553.GA6372@lst.de>
 <20170811160142.GB31625@bblock-ThinkPad-W530>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCLYZUM5WUFRBF5BY7GAKGQEAGN26MA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170811160142.GB31625@bblock-ThinkPad-W530>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hey Christoph,

I looked over the patch in detail, see below.

> From f5b03b82df0569c035022c1c2535696186907f1a Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Fri, 11 Aug 2017 11:03:29 +0200
> Subject: bsg-lib: allocate sense data for each request
>
> Since we split the scsi_request out of the request the driver is supposed
> to provide storage for the sense buffer.  The bsg-lib code failed to do s=
o,
> though and will crash anytime it is used.
>
> This patch moves bsg-lib to allocate and setup the bsg_job ahead of time,
> and allocate the sense data, which is used as reply buffer in bsg.
>
> Reported-by: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Fixes: 82ed4db499b8 ("block: split scsi_request out of struct request")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #4.11+
> ---
>  block/bsg-lib.c         | 51 +++++++++++++++++++++++++++----------------=
------
>  include/linux/blkdev.h  |  1 -
>  include/linux/bsg-lib.h |  2 ++
>  3 files changed, 30 insertions(+), 24 deletions(-)
>
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index c4513b23f57a..c07333c3b785 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -37,13 +37,11 @@ static void bsg_destroy_job(struct kref *kref)
>  	struct bsg_job *job =3D container_of(kref, struct bsg_job, kref);
>  	struct request *rq =3D job->req;
>
> -	blk_end_request_all(rq, BLK_STS_OK);
> -
>  	put_device(job->dev);	/* release reference for the request */
>
>  	kfree(job->request_payload.sg_list);
>  	kfree(job->reply_payload.sg_list);
> -	kfree(job);
> +	blk_end_request_all(rq, BLK_STS_OK);

What is the reason for moving that last line? Just wondering whether
that might change the behavior somehow, although it doesn't look like it
from the code.

>  }
>
>  void bsg_job_put(struct bsg_job *job)
> @@ -100,7 +98,7 @@ EXPORT_SYMBOL_GPL(bsg_job_done);
>   */
>  static void bsg_softirq_done(struct request *rq)
>  {
> -	struct bsg_job *job =3D rq->special;
> +	struct bsg_job *job =3D blk_mq_rq_to_pdu(rq);
>
>  	bsg_job_put(job);
>  }
> @@ -129,24 +127,11 @@ static int bsg_map_buffer(struct bsg_buffer *buf, s=
truct request *req)
>  static int bsg_create_job(struct device *dev, struct request *req)
>  {
>  	struct request *rsp =3D req->next_rq;
> -	struct request_queue *q =3D req->q;
> +	struct bsg_job *job =3D blk_mq_rq_to_pdu(req);
>  	struct scsi_request *rq =3D scsi_req(req);
> -	struct bsg_job *job;
>  	int ret;
>
> -	BUG_ON(req->special);
> -
> -	job =3D kzalloc(sizeof(struct bsg_job) + q->bsg_job_size, GFP_KERNEL);
> -	if (!job)
> -		return -ENOMEM;
> -
> -	req->special =3D job;
> -	job->req =3D req;
> -	if (q->bsg_job_size)
> -		job->dd_data =3D (void *)&job[1];
> -	job->request =3D rq->cmd;
>  	job->request_len =3D rq->cmd_len;
> -	job->reply =3D rq->sense;
>  	job->reply_len =3D SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
>  						 * allocated */
>  	if (req->bio) {
> @@ -187,7 +172,6 @@ static void bsg_request_fn(struct request_queue *q)
>  {
>  	struct device *dev =3D q->queuedata;
>  	struct request *req;
> -	struct bsg_job *job;
>  	int ret;
>
>  	if (!get_device(dev))
> @@ -207,8 +191,7 @@ static void bsg_request_fn(struct request_queue *q)
>  			continue;
>  		}
>
> -		job =3D req->special;
> -		ret =3D q->bsg_job_fn(job);
> +		ret =3D q->bsg_job_fn(blk_mq_rq_to_pdu(req));
>  		spin_lock_irq(q->queue_lock);
>  		if (ret)
>  			break;
> @@ -219,6 +202,27 @@ static void bsg_request_fn(struct request_queue *q)
>  	spin_lock_irq(q->queue_lock);
>  }
>
> +static int bsg_init_rq(struct request_queue *q, struct request *req, gfp=
_t gfp)
> +{
> +	struct bsg_job *job =3D blk_mq_rq_to_pdu(req);
> +
> +	memset(job, 0, sizeof(*job));
> +	job->req =3D req;
> +	job->request =3D job->sreq.cmd;

That doesn't work with bsg.c if the request submitted by the user is
bigger than BLK_MAX_CDB. There is code in blk_fill_sgv4_hdr_rq() that
will reassign the req->cmd point in that case to something else.

This is maybe wrong in the same vein as my Patch 1 is. If not for the
legacy code in bsg.c, setting this here, will miss changes to that
pointer between request-allocation and job-submission.

So maybe just move this to bsg_create_job().

> +	job->dd_data =3D job + 1;
> +	job->reply =3D job->sreq.sense =3D kzalloc(job->reply_len, gfp);

job->reply_len will be 0 here, won't it? You probably have to pull the
"job->reply_len =3D SCSI_SENSE_BUFFERSIZE" here from bsg_create_job().

> +	if (!job->reply)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void bsg_exit_rq(struct request_queue *q, struct request *req)
> +{
> +	struct bsg_job *job =3D blk_mq_rq_to_pdu(req);
> +
> +	kfree(job->reply);

Don't we need to free the reply-buffer as well?

Not sure how you wanna proceed. I can also sketch something up and
already test it on our cards, to prevent the ping-pong.


                                                    Beste Gr=C3=BC=C3=9Fe /=
 Best regards,
                                                      - Benjamin Block

> +}
> +
>  /**
>   * bsg_setup_queue - Create and add the bsg hooks so we can receive requ=
ests
>   * @dev: device to attach bsg device to
> @@ -235,7 +239,9 @@ struct request_queue *bsg_setup_queue(struct device *=
dev, char *name,
>  	q =3D blk_alloc_queue(GFP_KERNEL);
>  	if (!q)
>  		return ERR_PTR(-ENOMEM);
> -	q->cmd_size =3D sizeof(struct scsi_request);
> +	q->cmd_size =3D sizeof(struct bsg_job) + dd_job_size;
> +	q->init_rq_fn =3D bsg_init_rq;
> +	q->exit_rq_fn =3D bsg_exit_rq;
>  	q->request_fn =3D bsg_request_fn;
>
>  	ret =3D blk_init_allocated_queue(q);
> @@ -243,7 +249,6 @@ struct request_queue *bsg_setup_queue(struct device *=
dev, char *name,
>  		goto out_cleanup_queue;
>
>  	q->queuedata =3D dev;
> -	q->bsg_job_size =3D dd_job_size;
>  	q->bsg_job_fn =3D job_fn;
>  	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
>  	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f45f157b2910..6ae9aa6f93f0 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -568,7 +568,6 @@ struct request_queue {
>
>  #if defined(CONFIG_BLK_DEV_BSG)
>  	bsg_job_fn		*bsg_job_fn;
> -	int			bsg_job_size;
>  	struct bsg_class_device bsg_dev;
>  #endif
>
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index e34dde2da0ef..637a20cfb237 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -24,6 +24,7 @@
>  #define _BLK_BSG_
>
>  #include <linux/blkdev.h>
> +#include <scsi/scsi_request.h>
>
>  struct request;
>  struct device;
> @@ -37,6 +38,7 @@ struct bsg_buffer {
>  };
>
>  struct bsg_job {
> +	struct scsi_request sreq;
>  	struct device *dev;
>  	struct request *req;
>
> --
> 2.11.0
>

--
Linux on z Systems Development         /         IBM Systems & Technology G=
roup
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Gesch=C3=A4ftsf=C3=BChrung:=
 Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: AmtsG Stuttgart, H=
RB 243294

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
