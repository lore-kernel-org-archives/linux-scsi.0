Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F98CC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 16:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AF706102A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 16:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhDHQ3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 12:29:05 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:46414 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhDHQ3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 12:29:05 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 9ADD32EA28A;
        Thu,  8 Apr 2021 12:28:52 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id b31tS7JD7MFm; Thu,  8 Apr 2021 12:09:58 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 7B8E12EA1FC;
        Thu,  8 Apr 2021 12:28:51 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v17 44/45] sg: add blk_poll support
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20210408014531.248890-1-dgilbert@interlog.com>
 <20210408014531.248890-45-dgilbert@interlog.com>
 <de77707e-a4dc-78f8-43a3-48c90f2eec5a@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <0e12db0f-b15c-c788-3207-b204a052bd04@interlog.com>
Date:   Thu, 8 Apr 2021 12:28:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <de77707e-a4dc-78f8-43a3-48c90f2eec5a@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-08 4:14 a.m., Hannes Reinecke wrote:
> On 4/8/21 3:45 AM, Douglas Gilbert wrote:
>> The support is added via the new SGV4_FLAG_HIPRI command flag which
>> causes REQ_HIPRI to be set on the request. Before waiting on an
>> inflight request, it is checked to see if it has SGV4_FLAG_HIPRI,
>> and if so blk_poll() is called instead of the wait. In situations
>> where only the file descriptor is known (e.g. sg_poll() and
>> ioctl(SG_GET_NUM_WAITING)) all inflight requests associated with
>> the file descriptor that have SGV4_FLAG_HIPRI set, have blk_poll()
>> called on them.
>>
>> It is important to know blk_execute_rq_nowait() has finished before
>> sending blk_poll() on that request. The SG_RS_INFLIGHT state is set
>> just before blk_execute_rq_nowait() is called so a new bit setting
>> SG_FRQ_ISSUED has been added that is set just after that calls
>> returns.
>>
>> Note that the implementation of blk_poll() calls mq_poll() in the
>> LLD associated with the request. Then for any request found to be
>> ready, blk_poll() invokes the scsi_done() callback. When blk_poll()
>> returns > 0 , sg_rq_end_io() may have been called on the given
>> request. If so the given request will be in await_rcv state.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c      | 108 ++++++++++++++++++++++++++++++++++++++---
>>   include/uapi/scsi/sg.h |   1 +
>>   2 files changed, 103 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 0982cb031be9..19aafd8e23f1 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -116,12 +116,14 @@ enum sg_rq_state {    /* N.B. sg_rq_state_arr assumes 
>> SG_RS_AWAIT_RCV==2 */
>>   #define SG_FRQ_RECEIVING    7    /* guard against multiple receivers */
>>   #define SG_FRQ_FOR_MMAP        8    /* request needs PAGE_SIZE elements */
>>   #define SG_FRQ_COUNT_ACTIVE    9    /* sfp->submitted + waiting active */
>> +#define SG_FRQ_ISSUED        10    /* blk_execute_rq_nowait() finished */
>>   /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
>>   #define SG_FFD_FORCE_PACKID    0    /* receive only given pack_id/tag */
>>   #define SG_FFD_CMD_Q        1    /* clear: only 1 active req per fd */
>>   #define SG_FFD_KEEP_ORPHAN    2    /* policy for this fd */
>> -#define SG_FFD_Q_AT_TAIL    3    /* set: queue reqs at tail of blk q */
>> +#define SG_FFD_HIPRI_SEEN    3    /* could have HIPRI requests active */
>> +#define SG_FFD_Q_AT_TAIL    4    /* set: queue reqs at tail of blk q */
>>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>>   #define SG_FDEV_EXCLUDE        0    /* have fd open with O_EXCL */
>> @@ -210,6 +212,7 @@ struct sg_request {    /* active SCSI command or inactive 
>> request */
>>       int sense_len;        /* actual sense buffer length (data-in) */
>>       atomic_t rq_st;        /* request state, holds a enum sg_rq_state */
>>       u8 cmd_opcode;        /* first byte of SCSI cdb */
>> +    blk_qc_t cookie;    /* ids 1 or more queues for blk_poll() */
>>       u64 start_ns;        /* starting point of command duration calc */
>>       unsigned long frq_bm[1];    /* see SG_FRQ_* defines above */
>>       u8 *sense_bp;        /* mempool alloc-ed sense buffer, as needed */
>> @@ -299,6 +302,9 @@ static struct sg_device *sg_get_dev(int min_dev);
>>   static void sg_device_destroy(struct kref *kref);
>>   static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
>>                        int db_len);
>> +static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
>> +static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
>> +                 int loop_count);
>>   #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>>   static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>>   #endif
>> @@ -1008,6 +1014,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>>   {
>>       bool at_head, is_v4h, sync;
>>       struct sg_device *sdp = sfp->parentdp;
>> +    struct request *rqq = READ_ONCE(srp->rqq);
>>       is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
>>       sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
>> @@ -1031,7 +1038,12 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>>           atomic_inc(&sfp->submitted);
>>           set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
>>       }
>> -    blk_execute_rq_nowait(sdp->disk, READ_ONCE(srp->rqq), (int)at_head, 
>> sg_rq_end_io);
>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI) {
>> +        rqq->cmd_flags |= REQ_HIPRI;
>> +        srp->cookie = request_to_qc_t(rqq->mq_hctx, rqq);
>> +    }
>> +    blk_execute_rq_nowait(sdp->disk, rqq, (int)at_head, sg_rq_end_io);
>> +    set_bit(SG_FRQ_ISSUED, srp->frq_bm);
>>   }
>>   /*
>> @@ -1693,6 +1705,13 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, 
>> void __user *p,
>>       if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>>           goto skip_wait;        /* and skip _acquire() */
>> +    if (srp->rq_flags & SGV4_FLAG_HIPRI) {
>> +        /* call blk_poll(), spinning till found */
>> +        res = sg_srp_q_blk_poll(srp, sdp->device->request_queue, -1);
>> +        if (res != -ENODATA && unlikely(res < 0))
>> +            return res;
>> +        goto skip_wait;
>> +    }
>>       SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
>>       /* usually will be woken up by sg_rq_end_io() callback */
>>       res = wait_event_interruptible(sfp->read_wait,
>> @@ -2019,6 +2038,8 @@ sg_ioctl_common(struct file *filp, struct sg_device 
>> *sdp, struct sg_fd *sfp,
>>           SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
>>           return put_user(val, ip);
>>       case SG_GET_NUM_WAITING:
>> +        if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +            sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready */
>>           val = atomic_read(&sfp->waiting);
>>           if (val)
>>               return put_user(val, ip);
>> @@ -2228,6 +2249,69 @@ sg_compat_ioctl(struct file *filp, unsigned int cmd_in, 
>> unsigned long arg)
>>   }
>>   #endif
>> +/*
>> + * If the sg_request object is not inflight, return -ENODATA. This function
>> + * returns 1 if the given object was in inflight state and is in await_rcv
>> + * state after blk_poll() returns 1 or more. If blk_poll() fails, then that
>> + * (negative) value is returned. Otherwise returns 0. Note that blk_poll()
>> + * may complete unrelated requests that share the same q and cookie.
>> + */
>> +static int
>> +sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int 
>> loop_count)
>> +{
>> +    int k, n, num;
>> +
>> +    num = (loop_count < 1) ? 1 : loop_count;
>> +    for (k = 0; k < num; ++k) {
>> +        if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
>> +            return -ENODATA;
>> +        n = blk_poll(q, srp->cookie, loop_count < 0 /* spin if negative */);
>> +        if (n > 0)
>> +            return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;
> 
> That _technically_ is a race condition;
> the first atomic_read() call might return a different value than the second one.
> And this arguably is a mis-use of atomic _counters_, as here they are just used 
> to store fixed values, not counters per se.
> Why not use 'READ/WRITE_ONCE' ?

Here is what I found in testing:

         thread 1                     thread 2
         [want sr1p compl.]          [want sr2p compl.]
        ===============================================
         sr1p INFLIGHT                sr2p INFLIGHT
         blk_poll(cookie)
             -> 1 (sr2p -> AWAIT)
         sr1p not in AWAIT
             so return 0
                                      blk_poll(cookie)
                                        ->1 (sr1p -> AWAIT)
                                      sr2p is in AWAIT
                                         so return 1
          [called again]
          sr1p not INFLIGHT
             so returns -ENODATA

Assuming the caller in thread 1 was sg_wait_event_srp() then
an -ENODATA return is interpreted as found one (and a check is
done for the AWAIT state and if not -EPROTO is returned to the
user).

So both threads have found their requests have been completed
so all is well programmatically. But blk_poll(), which becomes
mq_poll() to the LLD, found completions other than what the sg
driver (or other ULD) was looking for since both requests were
on the same (hardware) queue.

Whenever blk_poll() returns > 0, I believe the question of a before
and after race is moot. That is because blk_poll() has done a lot
of work when it returns > 0 including the possibility of changing
the state of the current request (in the current thread). It has:
   - visited the LLD which has completed at least one outstanding
     request on given q/cookie
   - told the block layer it has completed 1 or more requests
   - the block layer completion code:
       - calls the scsi mid-level completion code
          - calls the scsi ULD completion code

 From my testing without that recently added line:
     return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;

then test code with a single thread won't fail, two threads will seldom
fail (by incorrectly believing its srp has completed just because
blk_poll() completed _something_ in the window it was looking in).
And the failure rate will increase with the number of threads
running.

>> +        if (n < 0)
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
>> + * If loop_count is negative then call blk_poll(spin <- true)) once for each 
>> request.
>> + * Returns number found (could be 0) or a negated errno value.
>> + */
>> +static int
>> +sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
>> +{
>> +    int res = 0;
>> +    int n;
>> +    unsigned long idx, iflags;
>> +    struct sg_request *srp;
>> +    struct scsi_device *sdev = sfp->parentdp->device;
>> +    struct request_queue *q = sdev ? sdev->request_queue : NULL;
>> +    struct xarray *xafp = &sfp->srp_arr;
>> +
>> +    if (!q)
>> +        return -EINVAL;
>> +    xa_lock_irqsave(xafp, iflags);
>> +    xa_for_each(xafp, idx, srp) {
>> +        if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
>> +            atomic_read(&srp->rq_st) == SG_RS_INFLIGHT &&
>> +            test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
>> +            xa_unlock_irqrestore(xafp, iflags);
>> +            n = sg_srp_q_blk_poll(srp, q, loop_count);
>> +            if (n == -ENODATA)
>> +                n = 0;
>> +            if (unlikely(n < 0))
>> +                return n;
>> +            xa_lock_irqsave(xafp, iflags);
>> +            res += n;
>> +        }
>> +    }
>> +    xa_unlock_irqrestore(xafp, iflags);
>> +    return res;
>> +}
>> +
>>   /*
>>    * Implements the poll(2) system call for this driver. Returns various EPOLL*
>>    * flags OR-ed together.
>> @@ -2239,6 +2323,8 @@ sg_poll(struct file *filp, poll_table * wait)
>>       __poll_t p_res = 0;
>>       struct sg_fd *sfp = filp->private_data;
>> +    if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
>> +        sg_sfp_blk_poll(sfp, 0);    /* LLD may have some ready to push up */
>>       num = atomic_read(&sfp->waiting);
>>       if (num < 1) {
>>           poll_wait(filp, &sfp->read_wait, wait);
>> @@ -2523,6 +2609,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>>           }
>>       }
>>       xa_lock_irqsave(&sfp->srp_arr, iflags);
>> +    __set_bit(SG_FRQ_ISSUED, srp->frq_bm);
>>       sg_rq_chg_state_force_ulck(srp, rqq_state);
>>       WRITE_ONCE(srp->rqq, NULL);
>>       if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
>> @@ -2548,7 +2635,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>>       if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
>>           /* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
>> -        wake_up_interruptible(&sfp->read_wait);
>> +        if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
>> +            wake_up_interruptible(&sfp->read_wait);
>>           kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
>>           kref_put(&sfp->f_ref, sg_remove_sfp);
>>       } else {        /* clean up orphaned request that aren't being kept */
>> @@ -2991,6 +3079,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t 
>> *cwrp, int dxfer_dir)
>>       /* current sg_request protected by SG_RS_BUSY state */
>>       scsi_rp = scsi_req(rqq);
>>       WRITE_ONCE(srp->rqq, rqq);
>> +    if (rq_flags & SGV4_FLAG_HIPRI)
>> +        set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>>       if (cwrp->cmd_len > BLK_MAX_CDB)
>>           scsi_rp->cmd = long_cmdp;    /* transfer ownership */
>> @@ -3100,7 +3190,10 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
>>       SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
>>              (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
>>       if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
>> -        atomic_dec(&sfp->submitted);
>> +        bool now_zero = atomic_dec_and_test(&sfp->submitted);
>> +
>> +        if (now_zero)
>> +            clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
>>           atomic_dec(&sfp->waiting);
>>       }
> 
> Why the 'now_zero' variable?
> I guess it can be dropped ...

Yes it can.

Doug Gilbert
