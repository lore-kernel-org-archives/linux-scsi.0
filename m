From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Add user scatter gather I/O to SG_IO
Date: Sun, 12 Jun 2005 15:19:46 -0700
Message-ID: <1118614786.10120.2.camel@mina>
References: <1118447969.5031.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42132 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261243AbVFLWTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 18:19:54 -0400
In-Reply-To: <1118447969.5031.44.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-06-10 at 16:59, James Bottomley wrote:
> This should be the last in the series of patches implementing
> scsi_wait_req and scsi_do_req in the block layer.  It adds
> scatter/gather I/O from the user as a new feature of SG_IO.  It also
> exports the API for this which can now be used by the sg driver.
> 
> The patch is lightly tested, but appears to work fine.
> 
> James
> 



>  
> +void blk_execute_rq_nowait(request_queue_t *q, struct gendisk *bd_disk,
> +			   struct request *rq, int at_head,
> +			   void (*done)(struct request *))
> +{
> +	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
> +
> +	rq->rq_disk = bd_disk;
> +
> +
> +	rq->flags |= REQ_NOMERGE;
> +	rq->end_io = done;
> +	elv_add_request(q, rq, where, 1);
> +	generic_unplug_device(q);
> +}
> +


This is useful for device mapper hw_hanlders. Can we get it and
__blk_put_request exported? See below.

export blk_execute_rq_nowait and __blk_put_request so device mapper
hw_handlers can use them.


diff -aurp cogito/drivers/block/ll_rw_blk.c linux-block-cogito/drivers/block/ll_rw_blk.c
--- cogito/drivers/block/ll_rw_blk.c	2005-06-11 18:48:25.000000000 -0700
+++ linux-block-cogito/drivers/block/ll_rw_blk.c	2005-06-12 14:27:34.000000000 -0700
@@ -2301,6 +2301,8 @@ void blk_execute_rq_nowait(request_queue
 	generic_unplug_device(q);
 }
 
+EXPORT_SYMBOL(blk_execute_rq_nowait);
+
 /**
  * blk_execute_rq - insert a request into queue for execution
  * @q:		queue to insert the request in
@@ -2482,7 +2484,7 @@ void disk_round_stats(struct gendisk *di
 /*
  * queue lock must be held
  */
-static void __blk_put_request(request_queue_t *q, struct request *req)
+void __blk_put_request(request_queue_t *q, struct request *req)
 {
 	struct request_list *rl = req->rl;
 
@@ -2511,6 +2513,8 @@ static void __blk_put_request(request_qu
 	}
 }
 
+EXPORT_SYMBOL(__blk_put_request);
+
 void blk_put_request(struct request *req)
 {
 	/*
diff -aurp cogito/include/linux/blkdev.h linux-block-cogito/include/linux/blkdev.h
--- cogito/include/linux/blkdev.h	2005-06-11 18:51:32.000000000 -0700
+++ linux-block-cogito/include/linux/blkdev.h	2005-06-12 14:38:56.000000000 -0700
@@ -540,11 +540,15 @@ extern void blk_unregister_queue(struct 
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
+extern void __blk_put_request(request_queue_t *, struct request *);
 extern void blk_end_sync_rq(struct request *rq);
 extern void blk_attempt_remerge(request_queue_t *, struct request *);
 extern void __blk_attempt_remerge(request_queue_t *, struct request *);
 extern struct request *blk_get_request(request_queue_t *, int, int);
 extern void blk_insert_request(request_queue_t *, struct request *, int, void *);
+extern void blk_execute_rq_nowait(request_queue_t *q, struct gendisk *bd_disk,
+				  struct request *rq, int at_head,
+				  void (*done)(struct request *));
 extern void blk_requeue_request(request_queue_t *, struct request *);
 extern void blk_plug_device(request_queue_t *);
 extern int blk_remove_plug(request_queue_t *);


