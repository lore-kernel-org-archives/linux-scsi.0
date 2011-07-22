From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC PATCH 02/10] scsi bsg: add scsi bsg helper lib
Date: Sat, 23 Jul 2011 01:31:59 +0900
Message-ID: <20110723011924Q.fujita.tomonori@lab.ntt.co.jp>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
	<1311329100-2982-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38703 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab1GVQcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 12:32:11 -0400
In-Reply-To: <1311329100-2982-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Fri, 22 Jul 2011 05:04:52 -0500
michaelc@cs.wisc.edu wrote:

> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This moves the FC class bsg code to a scsi lib, so
> all drivers and classes do not have to duplicate common
> bits.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/Kconfig    |    6 +
>  drivers/scsi/Makefile   |    1 +
>  drivers/scsi/scsi_bsg.c |  374 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/Kbuild     |    1 +
>  include/scsi/scsi_bsg.h |   83 +++++++++++
>  5 files changed, 465 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/scsi_bsg.c
>  create mode 100644 include/scsi/scsi_bsg.h

Nice. Seems more llds need bsg support so I think that this is a good
idea.


> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4a1f029..327ec7e 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -47,6 +47,11 @@ config SCSI_TGT
>  	  If you want to use SCSI target mode drivers enable this option.
>  	  If you choose M, the module will be called scsi_tgt.
>  
> +config SCSI_BSG
> +	bool
> +	default	n
> +	select BLK_DEV_BSG
> +
>  config SCSI_NETLINK
>  	bool
>  	default	n
> @@ -294,6 +299,7 @@ config SCSI_FC_ATTRS
>  	tristate "FiberChannel Transport Attributes"
>  	depends on SCSI
>  	select SCSI_NETLINK
> +	select SCSI_BSG
>  	help
>  	  If you wish to export transport-specific information about
>  	  each attached FiberChannel device to sysfs, say Y.
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 7ad0b8a..0cdb572 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -162,6 +162,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
>  				   scsicam.o scsi_error.o scsi_lib.o
>  scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
>  scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
> +scsi_mod-$(CONFIG_SCSI_BSG)	+= scsi_bsg.o
>  scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
>  scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> new file mode 100644
> index 0000000..89b507e
> --- /dev/null
> +++ b/drivers/scsi/scsi_bsg.c
> @@ -0,0 +1,374 @@
> +/*
> + *  BSG helper library for scsi classes
> + *
> + *  Copyright (C) 2008   James Smart, Emulex Corporation
> + *  Copyright (C) 2010   Red Hat, Inc.  All rights reserved.
> + *  Copyright (C) 2010   Mike Christie
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/delay.h>
> +#include <scsi/scsi_bsg.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_transport.h>
> +
> +/**
> + * scsi_destroy_bsg_job - routine to teardown/delete a bsg job
> + * @job: scsi_bsg_job that is to be torn down
> + */
> +static void scsi_destroy_bsg_job(struct scsi_bsg_job *job)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	if (job->ref_cnt) {
> +		spin_unlock_irqrestore(&job->job_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&job->job_lock, flags);

Is this actually a reference counter? Doesn't look like how we use a
reference counter? If scsi_bsg_job needs it, it would be better to
just put kref in it?


> +	put_device(job->dev);	/* release reference for the request */
> +
> +	kfree(job->request_payload.sg_list);
> +	kfree(job->reply_payload.sg_list);
> +	kfree(job);
> +}
> +
> +/**
> + * scsi_bsg_job_done - completion routine for bsg requests
> + * @job: scsi_bsg_job that is complete
> + * @result: job reply result
> + * @reply_payload_rcv_len: length of payload recvd
> + */
> +void scsi_bsg_job_done(struct scsi_bsg_job *job, int result,
> +		       unsigned int reply_payload_rcv_len)
> +{
> +	struct request *req = job->req;
> +	struct request *rsp = req->next_rq;
> +	int err;
> +
> +	err = job->req->errors = result;
> +	if (err < 0)
> +		/* we're only returning the result field in the reply */
> +		job->req->sense_len = sizeof(u32);
> +	else
> +		job->req->sense_len = job->reply_len;
> +	/* we assume all request payload was transferred, residual == 0 */
> +	req->resid_len = 0;
> +
> +	if (rsp) {
> +		WARN_ON(reply_payload_rcv_len > rsp->resid_len);
> +
> +		/* set reply (bidi) residual */
> +		rsp->resid_len -= min(reply_payload_rcv_len, rsp->resid_len);
> +	}
> +	blk_complete_request(req);
> +}
> +EXPORT_SYMBOL_GPL(scsi_bsg_job_done);
> +
> +/**
> + * scsi_bsg_softirq_done - softirq done routine for destroying the bsg requests
> + * @rq: BSG request that holds the job to be destroyed
> + */
> +static void scsi_bsg_softirq_done(struct request *rq)
> +{
> +	struct scsi_bsg_job *job = rq->special;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	job->state_flags |= SCSI_RQST_STATE_DONE;
> +	job->ref_cnt--;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +
> +	blk_end_request_all(rq, rq->errors);
> +	scsi_destroy_bsg_job(job);
> +}
> +
> +/**
> + * scsi_bsg_job_timeout - handler for when a bsg request timesout
> + * @req: request that timed out
> + */
> +static enum blk_eh_timer_return scsi_bsg_job_timeout(struct request *req)
> +{
> +	struct scsi_bsg_job *job = req->special;
> +	struct Scsi_Host *shost = job->shost;
> +	unsigned long flags;
> +	int err = 0, done = 0;
> +
> +	spin_lock_irqsave(&job->job_lock, flags);
> +	if (job->state_flags & SCSI_RQST_STATE_DONE)
> +		done = 1;
> +	else
> +		job->ref_cnt++;
> +	spin_unlock_irqrestore(&job->job_lock, flags);
> +
> +	if (!done && shost->transportt->eh_bsg_job_timed_out) {
> +		/* call LLDD to abort the i/o as it has timed out */
> +		err = shost->transportt->eh_bsg_job_timed_out(job);
> +		if (err == -EAGAIN) {
> +			job->ref_cnt--;
> +			return BLK_EH_RESET_TIMER;
> +		} else if (err)
> +			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
> +				"abort failed with status %d\n", err);
> +	}
> +
> +	/* the blk_end_sync_io() doesn't check the error */
> +	if (done)
> +		return BLK_EH_NOT_HANDLED;
> +	else
> +		return BLK_EH_HANDLED;
> +}
> +
> +static int scsi_bsg_map_buffer(struct scsi_bsg_buffer *buf, struct request *req)
> +{

Might be simpler to use scsi_data_buffer instead of inventing
scsi_bsg_buffer. Not sure.

> +	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
> +
> +	BUG_ON(!req->nr_phys_segments);
> +
> +	buf->sg_list = kzalloc(sz, GFP_KERNEL);
> +	if (!buf->sg_list)
> +		return -ENOMEM;
> +	sg_init_table(buf->sg_list, req->nr_phys_segments);
> +	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
> +	buf->payload_len = blk_rq_bytes(req);
> +	return 0;
> +}
> +
> +/**
> + * scsi_bsg_create_job - create the scsi_bsg_job structure for the bsg request
> + * @shost: SCSI Host corresponding to the bsg object
> + * @dev: device that is being sent the bsg request
> + * @req: BSG request that needs a job structure
> + */
> +static int scsi_bsg_create_job(struct Scsi_Host *shost, struct device *dev,
> +			       struct request *req)
> +{
> +	struct request *rsp = req->next_rq;
> +	struct scsi_bsg_job *job;
> +	int ret;
> +
> +	BUG_ON(req->special);
> +
> +	job = kzalloc(sizeof(struct scsi_bsg_job) +
> +		      shost->transportt->bsg_job_size, GFP_KERNEL);
> +	if (!job)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Note: this is a bit silly.
> +	 * The request gets formatted as a SGIO v4 ioctl request, which
> +	 * then gets reformatted as a blk request, which then gets
> +	 * reformatted as a scsi bsg request. And on completion, we have

Yeah. We could modify bsg to support formatting SGIO to scsi bsg
request (killing the blk request formatting). But it means that bsg
can't use nice blk functions like blk_rq_map|unmap_user. I guess that
the code might be simpler with the intermediate blk request
formatting.


> +	 * to wrap return results such that SGIO v4 thinks it was a scsi
> +	 * status.  I hope this was all worth it.
> +	 */
> +
> +	req->special = job;
> +	job->shost = shost;
> +	job->req = req;
> +	if (shost->transportt->bsg_job_size)
> +		job->dd_data = (void *)&job[1];
> +	spin_lock_init(&job->job_lock);
> +	job->request = req->cmd;
> +	job->request_len = req->cmd_len;
> +	job->reply = req->sense;
> +	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
> +						 * allocated */
> +	if (req->bio) {
> +		ret = scsi_bsg_map_buffer(&job->request_payload, req);
> +		if (ret)
> +			goto failjob_rls_job;
> +	}
> +	if (rsp && rsp->bio) {
> +		ret = scsi_bsg_map_buffer(&job->reply_payload, rsp);
> +		if (ret)
> +			goto failjob_rls_rqst_payload;
> +	}
> +	job->job_done = scsi_bsg_job_done;
> +	job->dev = dev;
> +	/* take a reference for the request */
> +	get_device(job->dev);
> +	job->ref_cnt = 1;
> +	return 0;
> +
> +failjob_rls_rqst_payload:
> +	kfree(job->request_payload.sg_list);
> +failjob_rls_job:
> +	kfree(job);
> +	return -ENOMEM;
> +}
> +
> +/*
> + * scsi_bsg_goose_queue - restart queue in case it was stopped
> + * @dev: device that owns queue
> + * @q: request q to be restarted
> + */
> +void scsi_bsg_goose_queue(struct device *dev, struct request_queue *q)
> +{
> +	if (!q)
> +		return;
> +
> +	/*
> +	 * This get/put dance makes no sense
> +	 */
> +
> +	get_device(dev);
> +	blk_run_queue_async(q);
> +	put_device(dev);
> +}
> +EXPORT_SYMBOL_GPL(scsi_bsg_goose_queue);
> +
> +/**
> + * scsi_bsg_request_fn - generic handler for bsg requests
> + * @q: request queue to manage
> + *
> + * On error the create_bsg_job function should return a -Exyz error value
> + * that will be set to the req->errors.
> + */
> +static void scsi_bsg_request_fn(struct request_queue *q)
> +{
> +	struct device *dev = q->queuedata;
> +	struct Scsi_Host *shost = dev_to_shost(dev);
> +	struct request *req;
> +	struct scsi_bsg_job *job;
> +	int ret;
> +
> +	if (!shost)
> +		return;
> +
> +	if (!get_device(dev))
> +		return;
> +
> +	while (1) {
> +		req = blk_fetch_request(q);
> +		if (!req)
> +			break;
> +		spin_unlock_irq(q->queue_lock);
> +
> +		ret = scsi_bsg_create_job(shost, dev, req);
> +		if (ret) {
> +			req->errors = ret;
> +			blk_end_request_all(req, ret);
> +			spin_lock_irq(q->queue_lock);
> +			continue;
> +		}
> +
> +		job = req->special;
> +		/* the dispatch routines will unlock the queue_lock */
> +		ret = shost->transportt->queue_bsg_job(job);
> +		spin_lock_irq(q->queue_lock);
> +		if (ret)
> +			break;
> +	}
> +
> +	spin_unlock_irq(q->queue_lock);
> +	put_device(dev);
> +	spin_lock_irq(q->queue_lock);
> +}
> +
> +/**
> + * scsi_bsg_add - Create and add the bsg hooks so we can receive requests
> + * @dev: device to attach bsg device to
> + */
> +struct request_queue *scsi_bsg_add(struct device *dev, char *name)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(dev);
> +	struct request_queue *q;
> +
> +	if (!shost)
> +		return NULL;
> +
> +	q = __scsi_alloc_queue(shost, scsi_bsg_request_fn);
> +	if (!q) {
> +		printk(KERN_ERR "%s: bsg interface failed to "
> +				"initialize - no request queue\n",
> +				 dev->kobj.name);
> +		return NULL;
> +	}
> +	q->queuedata = dev;
> +
> +	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
> +	blk_queue_softirq_done(q, scsi_bsg_softirq_done);
> +	blk_queue_rq_timed_out(q, scsi_bsg_job_timeout);
> +	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
> +
> +	if (bsg_register_queue(q, dev, name, NULL)) {
> +		printk(KERN_ERR "%s: bsg interface failed to "
> +		       "initialize - register queue\n", dev->kobj.name);
> +		blk_cleanup_queue(q);
> +		return NULL;
> +	}
> +
> +	return q;
> +}
> +EXPORT_SYMBOL_GPL(scsi_bsg_add);
> +
> +/**
> + * scsi_bsg_remove - Deletes the bsg dev from the q
> + * @q:	the request_queue that is to be torn down.
> + *
> + * Notes:
> + *   Before unregistering the queue empty any requests that are blocked
> + */
> +void scsi_bsg_remove(struct request_queue *q)
> +{
> +	struct request *req; /* block request */
> +	int counts; /* totals for request_list count and starved */

This function looks hacky a bit (e.g. peeking at the queue internal
values such as count and starved). Can we do this in a different way
(less hacky way)?

> +	if (q) {
> +		/* Stop taking in new requests */
> +		spin_lock_irq(q->queue_lock);
> +		blk_stop_queue(q);
> +
> +		/* drain all requests in the queue */
> +		while (1) {
> +			/* need the lock to fetch a request
> +			 * this may fetch the same reqeust as the previous pass
> +			 */
> +			req = blk_fetch_request(q);
> +			/* save requests in use and starved */
> +			counts = q->rq.count[0] + q->rq.count[1] +
> +				 q->rq.starved[0] + q->rq.starved[1];
> +			spin_unlock_irq(q->queue_lock);
> +			/* any requests still outstanding? */
> +			if (counts == 0)
> +				break;
> +
> +			/* This may be the same req as the previous iteration,
> +			 * always send the blk_end_request_all after a prefetch.
> +			 * It is not okay to not end the request because the
> +			 * prefetch started the request.
> +			 */
> +			if (req) {
> +				/* return -ENXIO to indicate that this queue is
> +				 * going away
> +				 */
> +				req->errors = -ENXIO;
> +				blk_end_request_all(req, -ENXIO);
> +			}
> +
> +			msleep(200); /* allow bsg to possibly finish */

Hmm, what's it? Do we need to fix something about bsg?
