Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84C7C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 803286113A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhDHIuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:50:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:49184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHIuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Apr 2021 04:50:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63157B0EA;
        Thu,  8 Apr 2021 08:49:50 +0000 (UTC)
Subject: Re: [PATCH v17 44/45] sg: add blk_poll support
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20210408014531.248890-1-dgilbert@interlog.com>
 <20210408014531.248890-45-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <de77707e-a4dc-78f8-43a3-48c90f2eec5a@suse.de>
Date:   Thu, 8 Apr 2021 10:14:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210408014531.248890-45-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/8/21 3:45 AM, Douglas Gilbert wrote:
> The support is added via the new SGV4_FLAG_HIPRI command flag which
> causes REQ_HIPRI to be set on the request. Before waiting on an
> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
> and if so blk_poll() is called instead of the wait. In situations
> where only the file descriptor is known (e.g. sg_poll() and
> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
> the file descriptor that have SGV4_FLAG_HIPRI set, have blk_poll()
> called on them.
> 
> It is important to know blk_execute_rq_nowait() has finished before
> sending blk_poll() on that request. The SG_RS_INFLIGHT state is set
> just before blk_execute_rq_nowait() is called so a new bit setting
> SG_FRQ_ISSUED has been added that is set just after that calls
> returns.
> 
> Note that the implementation of blk_poll() calls mq_poll() in the
> LLD associated with the request. Then for any request found to be
> ready, blk_poll() invokes the scsi_done() callback. When blk_poll()
> returns > 0 , sg_rq_end_io() may have been called on the given
> request. If so the given request will be in await_rcv state.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 108 ++++++++++++++++++++++++++++++++++++++---
>   include/uapi/scsi/sg.h |   1 +
>   2 files changed, 103 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0982cb031be9..19aafd8e23f1 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -116,12 +116,14 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
>   #define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
>   #define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
>   #define SG_FRQ_COUNT_ACTIVE	9	/* sfp->submitted + waiting active */
> +#define SG_FRQ_ISSUED		10	/* blk_execute_rq_nowait() finished */
>   
>   /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
>   #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
>   #define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
>   #define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
> -#define SG_FFD_Q_AT_TAIL	3	/* set: queue reqs at tail of blk q */
> +#define SG_FFD_HIPRI_SEEN	3	/* could have HIPRI requests active */
> +#define SG_FFD_Q_AT_TAIL	4	/* set: queue reqs at tail of blk q */
>   
>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>   #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
> @@ -210,6 +212,7 @@ struct sg_request {	/* active SCSI command or inactive request */
>   	int sense_len;		/* actual sense buffer length (data-in) */
>   	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
>   	u8 cmd_opcode;		/* first byte of SCSI cdb */
> +	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */
>   	u64 start_ns;		/* starting point of command duration calc */
>   	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
>   	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
> @@ -299,6 +302,9 @@ static struct sg_device *sg_get_dev(int min_dev);
>   static void sg_device_destroy(struct kref *kref);
>   static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
>   					 int db_len);
> +static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
> +static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
> +			     int loop_count);
>   #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>   static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>   #endif
> @@ -1008,6 +1014,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>   {
>   	bool at_head, is_v4h, sync;
>   	struct sg_device *sdp = sfp->parentdp;
> +	struct request *rqq = READ_ONCE(srp->rqq);
>   
>   	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
>   	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
> @@ -1031,7 +1038,12 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>   		atomic_inc(&sfp->submitted);
>   		set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
>   	}
> -	blk_execute_rq_nowait(sdp->disk, READ_ONCE(srp->rqq), (int)at_head, sg_rq_end_io);
> +	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
> +		rqq->cmd_flags |= REQ_HIPRI;
> +		srp->cookie = request_to_qc_t(rqq->mq_hctx, rqq);
> +	}
> +	blk_execute_rq_nowait(sdp->disk, rqq, (int)at_head, sg_rq_end_io);
> +	set_bit(SG_FRQ_ISSUED, srp->frq_bm);
>   }
>   
>   /*
> @@ -1693,6 +1705,13 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
>   
>   	if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>   		goto skip_wait;		/* and skip _acquire() */
> +	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
> +		/* call blk_poll(), spinning till found */
> +		res = sg_srp_q_blk_poll(srp, sdp->device->request_queue, -1);
> +		if (res != -ENODATA && unlikely(res < 0))
> +			return res;
> +		goto skip_wait;
> +	}
>   	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
>   	/* usually will be woken up by sg_rq_end_io() callback */
>   	res = wait_event_interruptible(sfp->read_wait,
> @@ -2019,6 +2038,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
>   		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
>   		return put_user(val, ip);
>   	case SG_GET_NUM_WAITING:
> +		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
> +			sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
>   		val = atomic_read(&sfp->waiting);
>   		if (val)
>   			return put_user(val, ip);
> @@ -2228,6 +2249,69 @@ sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   }
>   #endif
>   
> +/*
> + * If the sg_request object is not inflight, return -ENODATA. This function
> + * returns 1 if the given object was in inflight state and is in await_rcv
> + * state after blk_poll() returns 1 or more. If blk_poll() fails, then that
> + * (negative) value is returned. Otherwise returns 0. Note that blk_poll()
> + * may complete unrelated requests that share the same q and cookie.
> + */
> +static int
> +sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int loop_count)
> +{
> +	int k, n, num;
> +
> +	num = (loop_count < 1) ? 1 : loop_count;
> +	for (k = 0; k < num; ++k) {
> +		if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
> +			return -ENODATA;
> +		n = blk_poll(q, srp->cookie, loop_count < 0 /* spin if negative */);
> +		if (n > 0)
> +			return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;

That _technically_ is a race condition;
the first atomic_read() call might return a different value than the 
second one.
And this arguably is a mis-use of atomic _counters_, as here they are 
just used to store fixed values, not counters per se.
Why not use 'READ/WRITE_ONCE' ?

> +		if (n < 0)
> +			return n;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Check all requests on this sfp that are both inflight and HIPRI. That check involves calling
> + * blk_poll(spin<-false) loop_count times. If loop_count is 0 then call blk_poll once.
> + * If loop_count is negative then call blk_poll(spin <- true)) once for each request.
> + * Returns number found (could be 0) or a negated errno value.
> + */
> +static int
> +sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
> +{
> +	int res = 0;
> +	int n;
> +	unsigned long idx, iflags;
> +	struct sg_request *srp;
> +	struct scsi_device *sdev = sfp->parentdp->device;
> +	struct request_queue *q = sdev ? sdev->request_queue : NULL;
> +	struct xarray *xafp = &sfp->srp_arr;
> +
> +	if (!q)
> +		return -EINVAL;
> +	xa_lock_irqsave(xafp, iflags);
> +	xa_for_each(xafp, idx, srp) {
> +		if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
> +		    atomic_read(&srp->rq_st) == SG_RS_INFLIGHT &&
> +		    test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
> +			xa_unlock_irqrestore(xafp, iflags);
> +			n = sg_srp_q_blk_poll(srp, q, loop_count);
> +			if (n == -ENODATA)
> +				n = 0;
> +			if (unlikely(n < 0))
> +				return n;
> +			xa_lock_irqsave(xafp, iflags);
> +			res += n;
> +		}
> +	}
> +	xa_unlock_irqrestore(xafp, iflags);
> +	return res;
> +}
> +
>   /*
>    * Implements the poll(2) system call for this driver. Returns various EPOLL*
>    * flags OR-ed together.
> @@ -2239,6 +2323,8 @@ sg_poll(struct file *filp, poll_table * wait)
>   	__poll_t p_res = 0;
>   	struct sg_fd *sfp = filp->private_data;
>   
> +	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
> +		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
>   	num = atomic_read(&sfp->waiting);
>   	if (num < 1) {
>   		poll_wait(filp, &sfp->read_wait, wait);
> @@ -2523,6 +2609,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>   		}
>   	}
>   	xa_lock_irqsave(&sfp->srp_arr, iflags);
> +	__set_bit(SG_FRQ_ISSUED, srp->frq_bm);
>   	sg_rq_chg_state_force_ulck(srp, rqq_state);
>   	WRITE_ONCE(srp->rqq, NULL);
>   	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
> @@ -2548,7 +2635,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>   
>   	if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
>   		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
> -		wake_up_interruptible(&sfp->read_wait);
> +		if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
> +			wake_up_interruptible(&sfp->read_wait);
>   		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
>   		kref_put(&sfp->f_ref, sg_remove_sfp);
>   	} else {        /* clean up orphaned request that aren't being kept */
> @@ -2991,6 +3079,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
>   	/* current sg_request protected by SG_RS_BUSY state */
>   	scsi_rp = scsi_req(rqq);
>   	WRITE_ONCE(srp->rqq, rqq);
> +	if (rq_flags & SGV4_FLAG_HIPRI)
> +		set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>   
>   	if (cwrp->cmd_len > BLK_MAX_CDB)
>   		scsi_rp->cmd = long_cmdp;	/* transfer ownership */
> @@ -3100,7 +3190,10 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
>   	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
>   	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
>   	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
> -		atomic_dec(&sfp->submitted);
> +		bool now_zero = atomic_dec_and_test(&sfp->submitted);
> +
> +		if (now_zero)
> +			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>   		atomic_dec(&sfp->waiting);
>   	}
>   

Why the 'now_zero' variable?
I guess it can be dropped ...

> @@ -3297,6 +3390,8 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
>   	struct sg_request *srp = NULL;
>   	struct xarray *xafp = &sfp->srp_arr;
>   
> +	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
> +		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
>   	if (num_waiting < 1) {
>   		num_waiting = atomic_read_acquire(&sfp->waiting);
>   		if (num_waiting < 1)
> @@ -4101,8 +4196,9 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
>   	else if (dur < U32_MAX)	/* in-flight or busy (so ongoing) */
>   		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%ums",
>   			       to / 1000, dur);
> -	n += scnprintf(obp + n, len - n, " sgat=%d op=0x%02x\n",
> -		       srp->sgat_h.num_sgat, srp->cmd_opcode);
> +	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
> +	n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
> +		       srp->sgat_h.num_sgat, cp, srp->cmd_opcode);
>   	return n;
>   }
>   
> diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
> index 6162a5d5995c..11b58b279241 100644
> --- a/include/uapi/scsi/sg.h
> +++ b/include/uapi/scsi/sg.h
> @@ -110,6 +110,7 @@ typedef struct sg_io_hdr {
>   #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
>   #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
>   #define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
> +#define SGV4_FLAG_HIPRI 0x800 /* request will use blk_poll to complete */
>   
>   /* Output (potentially OR-ed together) in v3::info or v4::info field */
>   #define SG_INFO_OK_MASK 0x1
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
