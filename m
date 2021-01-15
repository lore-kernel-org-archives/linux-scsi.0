Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE0AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98926238EB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbhAOQ0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 11:26:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:40182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbhAOQ0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Jan 2021 11:26:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CF11FAC24;
        Fri, 15 Jan 2021 16:25:17 +0000 (UTC)
Subject: Re: [PATCH v13 44/45] sg: [RFC] add blk_poll support
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-45-dgilbert@interlog.com>
 <04cc77c8-eba6-16b9-8144-3e31d739ecf3@suse.de>
 <db8e485a-948c-a4b8-daa1-4412993fb991@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9c5e21c8-bcbf-cc28-2857-fd61278a66a5@suse.de>
Date:   Fri, 15 Jan 2021 17:25:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <db8e485a-948c-a4b8-daa1-4412993fb991@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/14/21 5:05 PM, Douglas Gilbert wrote:
> See inline replies ...
> 
> On 2021-01-14 2:35 a.m., Hannes Reinecke wrote:
>> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>>> The support is added via the new SGV4_FLAG_HIPRI command flag which
>>> causes REQ_HIPRI to be set on the request. Before waiting on an
>>> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
>>> and if so blk_poll() is called instead of the wait. In situations
>>> where only the file descriptor is known (e.g. sg_poll() and
>>> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
>>> the file descriptor that have SGV4_FLAG_HIPRI set, have sg_poll()
>>> called on them.
>>>
>>> Note that the implementation of blk_poll() calls mq_poll() in the
>>> LLD associated with the request. Then for any request found to be
>>> ready, blk_poll() invokes the scsi_done() callback. So this means
>>> if blk_poll() returns 1 then sg_rq_end_io() has already been
>>> called for the polled request.
>>>
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>> ---
>>>   drivers/scsi/sg.c      | 87 ++++++++++++++++++++++++++++++++++++++++--
>>>   include/uapi/scsi/sg.h |  1 +
>>>   2 files changed, 84 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>> index ad97f0756a9c..b396d3fb7bb7 100644
>>> --- a/drivers/scsi/sg.c
>>> +++ b/drivers/scsi/sg.c
>>> @@ -123,6 +123,7 @@ enum sg_rq_state {    /* N.B. sg_rq_state_arr 
>>> assumes SG_RS_AWAIT_RCV==2 */
>>>   #define SG_FFD_CMD_Q        1    /* clear: only 1 active req per fd */
>>>   #define SG_FFD_KEEP_ORPHAN    2    /* policy for this fd */
>>>   #define SG_FFD_MMAP_CALLED    3    /* mmap(2) system call made on 
>>> fd */
>>> +#define SG_FFD_HIPRI_SEEN    4    /* could have HIPRI requests 
>>> active */
>>>   #define SG_FFD_Q_AT_TAIL    5    /* set: queue reqs at tail of blk 
>>> q */
>>>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>>> @@ -301,6 +302,8 @@ static struct sg_device *sg_get_dev(int min_dev);
>>>   static void sg_device_destroy(struct kref *kref);
>>>   static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool 
>>> first,
>>>                        int db_len);
>>> +static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
>>> +static int sg_srp_blk_poll(struct sg_request *srp, int loop_count);
>>>   #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>>>   static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool 
>>> long_str);
>>>   #endif
>>> @@ -1033,6 +1036,8 @@ sg_execute_cmd(struct sg_fd *sfp, struct 
>>> sg_request *srp)
>>>           atomic_inc(&sfp->submitted);
>>>           set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
>>>       }
>>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI)
>>> +        srp->rq->cmd_flags |= REQ_HIPRI;
>>>       blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
>>>                     srp->rq, (int)at_head, sg_rq_end_io);
>>>   }
>>> @@ -1705,6 +1710,12 @@ sg_wait_event_srp(struct file *filp, struct 
>>> sg_fd *sfp, void __user *p,
>>>       if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>>>           goto skip_wait;        /* and skip _acquire() */
>>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI) {
>>> +        res = sg_srp_blk_poll(srp, -1);    /* spin till found */
>>> +        if (unlikely(res < 0))
>>> +            return res;
>>> +        goto skip_wait;
>>> +    }
>>>       SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
>>>       /* usually will be woken up by sg_rq_end_io() callback */
>>>       res = wait_event_interruptible(sfp->read_wait,
>>> @@ -2032,6 +2043,8 @@ sg_ioctl_common(struct file *filp, struct 
>>> sg_device *sdp, struct sg_fd *sfp,
>>>           SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
>>>           return put_user(val, ip);
>>>       case SG_GET_NUM_WAITING:
>>> +        if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>>> +            sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready 
>>> push */
>>>           val = atomic_read(&sfp->waiting);
>>>           if (val)
>>>               return put_user(val, ip);
>>> @@ -2241,6 +2254,59 @@ sg_compat_ioctl(struct file *filp, unsigned 
>>> int cmd_in, unsigned long arg)
>>>   }
>>>   #endif
>>> +static int
>>> +sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, 
>>> int loop_count)
>>> +{
>>> +    int k, n, num;
>>> +    blk_qc_t cookie = request_to_qc_t(srp->rq->mq_hctx, srp->rq);
>>> +
>>> +    num = (loop_count < 1) ? 1 : loop_count;
>>> +    for (k = 0; k < num; ++k) {
>>> +        n = blk_poll(q, cookie, loop_count < 0 /* spin if negative */);
>>> +        if (n != 0)
>>> +            return n;
>>> +    }
>>> +    return 0;
>>> +}
>>> +
>>> +/*
>>> + * Check all requests on this sfp that are both inflight and HIPRI. 
>>> That check involves calling
>>> + * blk_poll(spin<-false) loop_count times. If loop_count is 0 then 
>>> call blk_poll once.
>>> + * If loop_count is negative then call blk_poll(spin<-true)) once 
>>> for each request.
>>> + * Returns number found (could be 0) or a negated errno value.
>>> + */
>>> +static int
>>> +sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
>>> +{
>>> +    int res = 0;
>>> +    int n;
>>> +    unsigned long idx;
>>> +    struct sg_request *srp;
>>> +    struct scsi_device *sdev = sfp->parentdp->device;
>>> +    struct request_queue *q = sdev ? sdev->request_queue : NULL;
>>> +    struct xarray *xafp = &sfp->srp_arr;
>>> +
>>> +    if (!q)
>>> +        return -EINVAL;
>>> +    xa_for_each(xafp, idx, srp) {
>>> +        if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>>> +            continue;
>>> +        if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
>>> +            continue;
>>> +        n = sg_srp_q_blk_poll(srp, q, loop_count);
>>> +        if (unlikely(n < 0))
>>> +            return n;
>>> +        res += n;
>>> +    }
>>> +    return res;
>>> +}
>>> +
>>> +static inline int
>>> +sg_srp_blk_poll(struct sg_request *srp, int loop_count)
>>> +{
>>> +    return sg_srp_q_blk_poll(srp, 
>>> srp->parentfp->parentdp->device->request_queue, loop_count);
>>> +}
>>> +
>>>   /*
>>>    * Implements the poll(2) system call for this driver. Returns 
>>> various EPOLL*
>>>    * flags OR-ed together.
>>> @@ -2252,6 +2318,8 @@ sg_poll(struct file *filp, poll_table * wait)
>>>       __poll_t p_res = 0;
>>>       struct sg_fd *sfp = filp->private_data;
>>> +    if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>>> +        sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready to 
>>> push up */
>>>       num = atomic_read(&sfp->waiting);
>>>       if (num < 1) {
>>>           poll_wait(filp, &sfp->read_wait, wait);
>>> @@ -2564,7 +2632,8 @@ sg_rq_end_io(struct request *rq, blk_status_t 
>>> status)
>>>       if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
>>>           /* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
>>> -        wake_up_interruptible(&sfp->read_wait);
>>> +        if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
>>> +            wake_up_interruptible(&sfp->read_wait);
>>>           kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
>>>           kref_put(&sfp->f_ref, sg_remove_sfp);
>>>       } else {        /* clean up orphaned request that aren't being 
>>> kept */
>>> @@ -3007,6 +3076,10 @@ sg_start_req(struct sg_request *srp, struct 
>>> sg_comm_wr_t *cwrp, int dxfer_dir)
>>>       /* current sg_request protected by SG_RS_BUSY state */
>>>       scsi_rp = scsi_req(rq);
>>>       srp->rq = rq;
>>> +    if (rq_flags & SGV4_FLAG_HIPRI) {
>>> +        if (!test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>>> +            set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>>> +    }
>>
>> test_and_set_bit()?
> 
> I really would like to see the pseudo code for what test_and_set_bit()
> does. I don't want to set the bit if it is already set. IOW why have
> an atomic write operation and its associated baggage if it is
> already set.
> 
> If I follow your logic the conditional reduces to:
>     test_and_set_bit() { }
> which may further reduce to
>     set_bit();
> 

It would, but then we'd lose the advantage that test_and_set_bit() 
provides a memory barrier, which set_bit() doesn't.
If we can live with that, fine, set_bit() is it.
But I sincerely doubt we can measure the performance difference between 
test_and_set_bit() and a simple test_bit(); (on k7 it's two cpu cycles 
vs. one), but we have to do a branch, too, so it might devolve to the 
same amount of cycles.
In the end, I sincerely doubt it's worth it.

The more important point is:
Does it matter if the bit is already set?
If not I'd just go for the simple 'set_bit()'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
