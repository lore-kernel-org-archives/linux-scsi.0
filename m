Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0F6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 16:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB3923B3E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 16:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhANQGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 11:06:23 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:58151 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhANQGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 11:06:22 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 1B1642EA3C3;
        Thu, 14 Jan 2021 11:05:54 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id TXYKy1CpKvkx; Thu, 14 Jan 2021 10:52:34 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A9AEA2EA312;
        Thu, 14 Jan 2021 11:05:52 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v13 44/45] sg: [RFC] add blk_poll support
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-45-dgilbert@interlog.com>
 <04cc77c8-eba6-16b9-8144-3e31d739ecf3@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <db8e485a-948c-a4b8-daa1-4412993fb991@interlog.com>
Date:   Thu, 14 Jan 2021 11:05:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <04cc77c8-eba6-16b9-8144-3e31d739ecf3@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

See inline replies ...

On 2021-01-14 2:35 a.m., Hannes Reinecke wrote:
> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>> The support is added via the new SGV4_FLAG_HIPRI command flag which
>> causes REQ_HIPRI to be set on the request. Before waiting on an
>> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
>> and if so blk_poll() is called instead of the wait. In situations
>> where only the file descriptor is known (e.g. sg_poll() and
>> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
>> the file descriptor that have SGV4_FLAG_HIPRI set, have sg_poll()
>> called on them.
>>
>> Note that the implementation of blk_poll() calls mq_poll() in the
>> LLD associated with the request. Then for any request found to be
>> ready, blk_poll() invokes the scsi_done() callback. So this means
>> if blk_poll() returns 1 then sg_rq_end_io() has already been
>> called for the polled request.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c      | 87 ++++++++++++++++++++++++++++++++++++++++--
>>   include/uapi/scsi/sg.h |  1 +
>>   2 files changed, 84 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index ad97f0756a9c..b396d3fb7bb7 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -123,6 +123,7 @@ enum sg_rq_state {    /* N.B. sg_rq_state_arr assumes 
>> SG_RS_AWAIT_RCV==2 */
>>   #define SG_FFD_CMD_Q        1    /* clear: only 1 active req per fd */
>>   #define SG_FFD_KEEP_ORPHAN    2    /* policy for this fd */
>>   #define SG_FFD_MMAP_CALLED    3    /* mmap(2) system call made on fd */
>> +#define SG_FFD_HIPRI_SEEN    4    /* could have HIPRI requests active */
>>   #define SG_FFD_Q_AT_TAIL    5    /* set: queue reqs at tail of blk q */
>>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>> @@ -301,6 +302,8 @@ static struct sg_device *sg_get_dev(int min_dev);
>>   static void sg_device_destroy(struct kref *kref);
>>   static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
>>                        int db_len);
>> +static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
>> +static int sg_srp_blk_poll(struct sg_request *srp, int loop_count);
>>   #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>>   static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>>   #endif
>> @@ -1033,6 +1036,8 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>>           atomic_inc(&sfp->submitted);
>>           set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
>>       }
>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI)
>> +        srp->rq->cmd_flags |= REQ_HIPRI;
>>       blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
>>                     srp->rq, (int)at_head, sg_rq_end_io);
>>   }
>> @@ -1705,6 +1710,12 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, 
>> void __user *p,
>>       if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>>           goto skip_wait;        /* and skip _acquire() */
>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI) {
>> +        res = sg_srp_blk_poll(srp, -1);    /* spin till found */
>> +        if (unlikely(res < 0))
>> +            return res;
>> +        goto skip_wait;
>> +    }
>>       SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
>>       /* usually will be woken up by sg_rq_end_io() callback */
>>       res = wait_event_interruptible(sfp->read_wait,
>> @@ -2032,6 +2043,8 @@ sg_ioctl_common(struct file *filp, struct sg_device 
>> *sdp, struct sg_fd *sfp,
>>           SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
>>           return put_user(val, ip);
>>       case SG_GET_NUM_WAITING:
>> +        if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +            sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready push */
>>           val = atomic_read(&sfp->waiting);
>>           if (val)
>>               return put_user(val, ip);
>> @@ -2241,6 +2254,59 @@ sg_compat_ioctl(struct file *filp, unsigned int cmd_in, 
>> unsigned long arg)
>>   }
>>   #endif
>> +static int
>> +sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int 
>> loop_count)
>> +{
>> +    int k, n, num;
>> +    blk_qc_t cookie = request_to_qc_t(srp->rq->mq_hctx, srp->rq);
>> +
>> +    num = (loop_count < 1) ? 1 : loop_count;
>> +    for (k = 0; k < num; ++k) {
>> +        n = blk_poll(q, cookie, loop_count < 0 /* spin if negative */);
>> +        if (n != 0)
>> +            return n;
>> +    }
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Check all requests on this sfp that are both inflight and HIPRI. That 
>> check involves calling
>> + * blk_poll(spin<-false) loop_count times. If loop_count is 0 then call 
>> blk_poll once.
>> + * If loop_count is negative then call blk_poll(spin<-true)) once for each 
>> request.
>> + * Returns number found (could be 0) or a negated errno value.
>> + */
>> +static int
>> +sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
>> +{
>> +    int res = 0;
>> +    int n;
>> +    unsigned long idx;
>> +    struct sg_request *srp;
>> +    struct scsi_device *sdev = sfp->parentdp->device;
>> +    struct request_queue *q = sdev ? sdev->request_queue : NULL;
>> +    struct xarray *xafp = &sfp->srp_arr;
>> +
>> +    if (!q)
>> +        return -EINVAL;
>> +    xa_for_each(xafp, idx, srp) {
>> +        if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>> +            continue;
>> +        if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
>> +            continue;
>> +        n = sg_srp_q_blk_poll(srp, q, loop_count);
>> +        if (unlikely(n < 0))
>> +            return n;
>> +        res += n;
>> +    }
>> +    return res;
>> +}
>> +
>> +static inline int
>> +sg_srp_blk_poll(struct sg_request *srp, int loop_count)
>> +{
>> +    return sg_srp_q_blk_poll(srp, 
>> srp->parentfp->parentdp->device->request_queue, loop_count);
>> +}
>> +
>>   /*
>>    * Implements the poll(2) system call for this driver. Returns various EPOLL*
>>    * flags OR-ed together.
>> @@ -2252,6 +2318,8 @@ sg_poll(struct file *filp, poll_table * wait)
>>       __poll_t p_res = 0;
>>       struct sg_fd *sfp = filp->private_data;
>> +    if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +        sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready to push up */
>>       num = atomic_read(&sfp->waiting);
>>       if (num < 1) {
>>           poll_wait(filp, &sfp->read_wait, wait);
>> @@ -2564,7 +2632,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>>       if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
>>           /* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
>> -        wake_up_interruptible(&sfp->read_wait);
>> +        if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
>> +            wake_up_interruptible(&sfp->read_wait);
>>           kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
>>           kref_put(&sfp->f_ref, sg_remove_sfp);
>>       } else {        /* clean up orphaned request that aren't being kept */
>> @@ -3007,6 +3076,10 @@ sg_start_req(struct sg_request *srp, struct 
>> sg_comm_wr_t *cwrp, int dxfer_dir)
>>       /* current sg_request protected by SG_RS_BUSY state */
>>       scsi_rp = scsi_req(rq);
>>       srp->rq = rq;
>> +    if (rq_flags & SGV4_FLAG_HIPRI) {
>> +        if (!test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +            set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>> +    }
> 
> test_and_set_bit()?

I really would like to see the pseudo code for what test_and_set_bit()
does. I don't want to set the bit if it is already set. IOW why have
an atomic write operation and its associated baggage if it is
already set.

If I follow your logic the conditional reduces to:
    test_and_set_bit() { }
which may further reduce to
    set_bit();

> 
>>       if (cwrp->cmd_len > BLK_MAX_CDB)
>>           scsi_rp->cmd = long_cmdp;
>> @@ -3120,7 +3193,10 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
>>       SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
>>              (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
>>       if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
>> -        atomic_dec(&sfp->submitted);
>> +        bool now_zero = !atomic_dec_and_test(&sfp->submitted);
>> +
>> +        if (now_zero && test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +            clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
> 
> test_and_clear_bit()?

See above.

>>           atomic_dec(&sfp->waiting);
>>       }
>> @@ -3321,6 +3397,8 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
>>       struct sg_request *srp = NULL;
>>       struct xarray *xafp = &sfp->srp_arr;
>> +    if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +        sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready to push up */
>>       if (num_waiting < 1) {
>>           num_waiting = atomic_read_acquire(&sfp->waiting);
>>           if (num_waiting < 1)
>> @@ -4127,8 +4205,9 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, char 
>> *obp, int len)
>>       else if (dur < U32_MAX)    /* in-flight or busy (so ongoing) */
>>           n += scnprintf(obp + n, len - n, " t_o/elap=%us/%ums",
>>                      to / 1000, dur);
>> -    n += scnprintf(obp + n, len - n, " sgat=%d op=0x%02x\n",
>> -               srp->sgat_h.num_sgat, srp->cmd_opcode);
>> +    cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
>> +    n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
>> +               srp->sgat_h.num_sgat, cp, srp->cmd_opcode);
>>       return n;
>>   }
>> diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
>> index cbade2870355..a0e11d87aa2e 100644
>> --- a/include/uapi/scsi/sg.h
>> +++ b/include/uapi/scsi/sg.h
>> @@ -110,6 +110,7 @@ typedef struct sg_io_hdr {
>>   #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
>>   #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
>>   #define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
>> +#define SGV4_FLAG_HIPRI 0x800 /* request will use blk_poll to complete */
>>   /* Output (potentially OR-ed together) in v3::info or v4::info field */
>>   #define SG_INFO_OK_MASK 0x1
>>
> Cheers,
> 
> Hannes

