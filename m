Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5EAC3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 18:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 672A12072D
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 18:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1Sz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 13:55:56 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51559 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1Sz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 13:55:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 202AB20418D;
        Fri, 28 Feb 2020 19:55:52 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ck45RC-oZqQV; Fri, 28 Feb 2020 19:55:43 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id EFEBE20416A;
        Fri, 28 Feb 2020 19:55:42 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v7 24/38] sg: xarray for reqs in fd
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-25-dgilbert@interlog.com>
 <ad33e788-2a13-d0f5-7b0c-4ac2863ee01c@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <57373dbf-6edf-f24b-b528-f5d3507b032f@interlog.com>
Date:   Fri, 28 Feb 2020 13:55:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ad33e788-2a13-d0f5-7b0c-4ac2863ee01c@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-28 4:00 a.m., Hannes Reinecke wrote:
> On 2/27/20 5:58 PM, Douglas Gilbert wrote:
>> Replace the linked list and the fix arrays of requests (max 16)
>> with an xarray. The xarray (srp_arr) has two marks: one for
>> INACTIVE state (i.e. available for re-use) requests; the other
>> is AWAIT state which is after the internal completion point of
>> a request and before the user space has fetched the response.
>>
>> Of the five states in sg_request::rq_st, two are marked. They are
>> SG_RS_INACTIVE and SG_RS_AWAIT_RCV. This allows the request xarray
>> (sg_fd::srp_arr) to be searched (with xa_for_each_mark) on two
>> embedded sub-lists. The SG_RS_INACTIVE sub-list replaces the free
>> list. The SG_RS_AWAIT_RCV sub-list contains requests that have
>> reached their internal completion point but have not been read/
>> received by the user space. Add support functions for this and
>> partially wire them up.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 325 +++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 238 insertions(+), 87 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index de4b35aabe40..ef3674b9a5dc 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -73,7 +73,7 @@ static char *sg_version_date = "20190606";
>>   #define SG_MAX_CDB_SIZE 252
>>   /* Following enum contains the states of sg_request::rq_st */
>> -enum sg_rq_state {
>> +enum sg_rq_state {    /* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
>>       SG_RS_INACTIVE = 0,    /* request not in use (e.g. on fl) */
>>       SG_RS_INFLIGHT,        /* active: cmd/req issued, no response yet */
>>       SG_RS_AWAIT_RCV,    /* have response from LLD, awaiting receive */
>> @@ -115,6 +115,11 @@ enum sg_rq_state {
>>   #define SG_FDEV_DETACHING    1    /* may be unexpected device removal */
>>   #define SG_FDEV_LOG_SENSE    2    /* set by ioctl(SG_SET_DEBUG) */
>> +/* xarray 'mark's allow sub-lists within main array/list. */
>> +#define SG_XA_RQ_FREE XA_MARK_0    /* xarray sets+clears */
>> +#define SG_XA_RQ_INACTIVE XA_MARK_1
>> +#define SG_XA_RQ_AWAIT XA_MARK_2
>> +
>>   int sg_big_buff = SG_DEF_RESERVED_SIZE;
>>   /*
>>    * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each
>> @@ -154,11 +159,11 @@ struct sg_device;        /* forward declarations */
>>   struct sg_fd;
>>   struct sg_request {    /* SG_MAX_QUEUE requests outstanding per file */
>> -    struct list_head entry;    /* list entry */
>>       struct sg_scatter_hold data;    /* hold buffer, perhaps scatter list */
>>       struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
>>       u8 sense_b[SCSI_SENSE_BUFFERSIZE];
>>       u32 duration;        /* cmd duration in milliseconds */
>> +    u32 rq_idx;        /* my index within parent's srp_arr */
>>       char res_used;        /* 1 -> using reserve buffer, 0 -> not ... */
>>       char orphan;        /* 1 -> drop on sight, 0 -> normal */
>>       u32 rq_result;        /* packed scsi request result from LLD */
>> @@ -177,24 +182,23 @@ struct sg_request {    /* SG_MAX_QUEUE requests 
>> outstanding per file */
>>   struct sg_fd {        /* holds the state of a file descriptor */
>>       struct sg_device *parentdp;    /* owning device */
>>       wait_queue_head_t read_wait;    /* queue read until command done */
>> -    spinlock_t rq_list_lock;    /* protect access to list in req_arr */
>>       struct mutex f_mutex;    /* protect against changes in this fd */
>>       int timeout;        /* defaults to SG_DEFAULT_TIMEOUT      */
>>       int timeout_user;    /* defaults to SG_DEFAULT_TIMEOUT_USER */
>>       u32 idx;        /* my index within parent's sfp_arr */
>> -    atomic_t submitted;    /* number inflight or awaiting read */
>> -    atomic_t waiting;    /* number of requests awaiting read */
>> +    atomic_t submitted;    /* number inflight or awaiting receive */
>> +    atomic_t waiting;    /* number of requests awaiting receive */
>> +    atomic_t req_cnt;    /* number of requests */
>>       int sgat_elem_sz;    /* initialized to scatter_elem_sz */
>>       struct sg_scatter_hold reserve;    /* buffer for this file descriptor */
>> -    struct list_head rq_list; /* head of request list */
>> -    struct fasync_struct *async_qp;    /* used by asynchronous notification */
>> -    struct sg_request req_arr[SG_MAX_QUEUE];/* use as singly-linked list */
>>       char force_packid;    /* 1 -> pack_id input to read(), 0 -> ignored */
>>       char cmd_q;        /* 1 -> allow command queuing, 0 -> don't */
>>       u8 next_cmd_len;    /* 0: automatic, >0: use on next write() */
>>       char keep_orphan;    /* 0 -> drop orphan (def), 1 -> keep for read() */
>>       char mmap_called;    /* 0 -> mmap() never called on this fd */
>>       char res_in_use;    /* 1 -> 'reserve' array in use */
>> +    struct fasync_struct *async_qp;    /* used by asynchronous notification */
>> +    struct xarray srp_arr;
>>       struct kref f_ref;
>>       struct execute_work ew_fd;  /* harvest all fd resources and lists */
>>   };
>> @@ -273,6 +277,7 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, 
>> bool long_str);
>>   #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>>   #define SG_LOG_BUFF_SZ 48
>> +#define SG_LOG_ACTIVE 1
>>   #define SG_LOG(depth, sfp, fmt, a...)                    \
>>       do {                                \
>> @@ -724,6 +729,119 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const 
>> char __user *buf,
>>       return count;
>>   }
>> +#if IS_ENABLED(SG_LOG_ACTIVE)
>> +static void
>> +sg_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
>> +         enum sg_rq_state want_st, enum sg_rq_state act_old_st,
>> +         const char *fromp)
>> +{
>> +    const char *eaw_rs = "expected_old,actual_old,wanted rq_st";
>> +
>> +    if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
>> +        SG_LOG(1, sfp, "%s: %s: %s: %s,%s,%s\n",
>> +               __func__, fromp, eaw_rs,
>> +               sg_rq_st_str(exp_old_st, false),
>> +               sg_rq_st_str(act_old_st, false),
>> +               sg_rq_st_str(want_st, false));
>> +    else
>> +        pr_info("sg: %s: %s: %s: %d,%d,%d\n", __func__, fromp, eaw_rs,
>> +            (int)exp_old_st, (int)act_old_st, (int)want_st);
>> +}
>> +#endif
>> +
>> +static void
>> +sg_rq_state_force(struct sg_request *srp, enum sg_rq_state new_st)
>> +{
>> +    bool prev, want;
>> +    struct xarray *xafp = &srp->parentfp->srp_arr;
>> +
>> +    atomic_set(&srp->rq_st, new_st);
>> +    want = (new_st == SG_RS_AWAIT_RCV);
>> +    prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
>> +    if (prev != want) {
>> +        if (want)
>> +            __xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
>> +        else
>> +            __xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
>> +    }
>> +    want = (new_st == SG_RS_INACTIVE);
>> +    prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
>> +    if (prev != want) {
>> +        if (want)
>> +            __xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
>> +        else
>> +            __xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
>> +    }
>> +}
>> +
>> +/* Following array indexed by enum sg_rq_state, 0 means no xa mark change */
>> +static int sg_rq_state_arr[] = {1, 0, 4, 0, 0};
>> +
>> +static void
>> +sg_rq_state_helper(struct sg_request *srp, enum sg_rq_state old_st,
>> +           enum sg_rq_state new_st)
>> +{
>> +    int indic = sg_rq_state_arr[(int)old_st] +
>> +            (sg_rq_state_arr[(int)new_st] << 1);
>> +    struct xarray *xafp = &srp->parentfp->srp_arr;
>> +
>> +    if (indic == 0)
>> +        return;
>> +    if (indic & 1)        /* from inactive state */
>> +        __xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
>> +    else if (indic & 2)    /* to inactive state */
>> +        __xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
>> +    if ((indic & (4 | 8)) == 0)
>> +        return;
>> +    if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
>> +        return;        /* skip AWAIT mark for sync invocations */
>> +    if (indic & 4)        /* from await state */
>> +        __xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
>> +    else if (indic & 8)    /* to await state */
>> +        __xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
>> +}
>> +
>> +/*
>> + * This function keeps the srp->rq_st state and associated marks on the
>> + * owning xarray's element in sync. If force is true then new_st is stored
>> + * in srp->rq_st and xarray marks are set accordingly (and old_st is
>> + * ignored); and 0 is returned.
>> + * If force is false, then atomic_cmpxchg() is called. If the actual
>> + * srp->rq_st is not old_st, then -EPROTOTYPE is returned. If the actual
>> + * srp->rq_st is old_st then it is replaced by new_st and the xarray marks
>> + * are setup accordingly and 0 is returned. This assumes srp_arr xarray
>> + * spinlock is held.
>> + */
>> +static int
>> +sg_rq_state_chg(struct sg_request *srp, enum sg_rq_state old_st,
>> +        enum sg_rq_state new_st, bool force, const char *fromp)
>> +{
>> +    unsigned long iflags;
>> +    enum sg_rq_state act_old_st;
>> +    struct xarray *xafp = &srp->parentfp->srp_arr;
>> +
>> +    if (force) {
>> +        xa_lock_irqsave(xafp, iflags);
>> +        sg_rq_state_force(srp, new_st);
>> +        xa_unlock_irqrestore(xafp, iflags);
>> +        return 0;
>> +    }
>> +    act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
>> +                              new_st);
>> +    if (act_old_st != old_st) {
>> +#if IS_ENABLED(SG_LOG_ACTIVE)
>> +        if (fromp)
>> +            sg_rq_state_fail(srp->parentfp, old_st, new_st,
>> +                     act_old_st, fromp);
>> +#endif
>> +        return -EPROTOTYPE;    /* only used for this error type */
>> +    }
>> +    xa_lock_irqsave(xafp, iflags);
>> +    sg_rq_state_helper(srp, old_st, new_st);
>> +    xa_unlock_irqrestore(xafp, iflags);
>> +    return 0;
>> +}
> 
>>   /*
>>    * All writes and submits converge on this function to launch the SCSI
>>    * command/request (via blk_execute_rq_nowait). Returns a pointer to a
> The locking here is ... peculiar.
> You first do an cmpxchg() (presumably to avoid locking), but then continue to 
> lock the 'xsfp' structure.
> Why not simply move the functionality of the cmpexchg() into the lock and make 
> it a simple 'if' clause?

The atomic_cmpxchg() is about breaking a race when two threads on the same
fd try and re-use the same inactive request on the xarray. One will succeed
on that cmpxchg and the other with fail. Then for some (but not all) state
transitions, the code needs to change the corresponding mark on the xarray.

Yes, I think that xa_lock_irqsave block is overkill, I'll remove it and
take the "__" off the clear and set mark calls in the helper. And I'll test
it for regressions as it is central to the functioning of this driver.

One advantage of using xarray is that it is very good about screaming if
it doesn't like the way its locks are being used. And the the sg driver
uses those xarray locks almost exclusively now.

>> @@ -760,17 +878,8 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t 
>> *cwrp)
>>           sg_deact_request(sfp, srp);
>>           return k;    /* probably out of space --> ENOMEM */
>>       }
>> -    if (SG_IS_DETACHING(sdp)) {
>> -        if (srp->bio) {
>> -            scsi_req_free_cmd(scsi_req(srp->rq));
>> -            blk_put_request(srp->rq);
>> -            srp->rq = NULL;
>> -        }
>> -
>> -        sg_finish_scsi_blk_rq(srp);
>> -        sg_deact_request(sfp, srp);
>> -        return -ENODEV;
>> -    }
>> +    if (SG_IS_DETACHING(sdp))
>> +        goto err_out;
>>       hp->duration = jiffies_to_msecs(jiffies);
>>       if (hp->interface_id != '\0' &&    /* v3 (or later) interface */
>> @@ -779,6 +888,10 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t 
>> *cwrp)
>>       else
>>           at_head = true;
>> +    if (!xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
>> +        SG_LOG(1, sfp, "%s: ahhh, request erased!!!\n", __func__);
>> +        goto err_out;
>> +    }
>>       if (!srp->sg_io_owned)
>>           atomic_inc(&sfp->submitted);
>>       srp->rq->timeout = cwrp->timeout;
>> @@ -786,6 +899,22 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t 
>> *cwrp)
>>       blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
>>                     srp->rq, at_head, sg_rq_end_io);
>>       return 0;
>> +err_out:
>> +    if (srp->bio) {
>> +        scsi_req_free_cmd(scsi_req(srp->rq));
>> +        blk_put_request(srp->rq);
>> +        srp->rq = NULL;
>> +    }
>> +    sg_finish_scsi_blk_rq(srp);
>> +    sg_deact_request(sfp, srp);
>> +    return -ENODEV;
>> +}
>> +
>> +static inline int
>> +sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
>> +          enum sg_rq_state new_st)
>> +{
>> +    return sg_rq_state_chg(srp, old_st, new_st, false, __func__);
>>   }
>>   /*
>> @@ -1158,12 +1287,9 @@ sg_fill_request_element(struct sg_fd *sfp, struct 
>> sg_request *srp,
>>   static int
>>   srp_done(struct sg_fd *sfp, struct sg_request *srp)
>>   {
>> -    unsigned long flags;
>>       int ret;
>> -    spin_lock_irqsave(&sfp->rq_list_lock, flags);
>>       ret = srp->done;
>> -    spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
>>       return ret;
>>   }
>> @@ -1190,15 +1316,12 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, 
>> struct sg_fd *sfp,
>>           (sfp->read_wait, (srp_done(sfp, srp) || SG_IS_DETACHING(sdp)));
>>       if (SG_IS_DETACHING(sdp))
>>           return -ENODEV;
>> -    spin_lock_irq(&sfp->rq_list_lock);
>>       if (srp->done) {
>>           srp->done = 2;
>> -        spin_unlock_irq(&sfp->rq_list_lock);
>>           res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
>>           return (res < 0) ? res : 0;
>>       }
>>       srp->orphan = 1;
>> -    spin_unlock_irq(&sfp->rq_list_lock);
>>       return res;
>>   }
>> @@ -1247,7 +1370,7 @@ static int
>>   sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
>>   {
>>       int result, val;
>> -    unsigned long iflags;
>> +    unsigned long idx;
>>       struct sg_request *srp;
>>       sg_req_info_t *rinfop;
>> @@ -1255,15 +1378,17 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
>>                GFP_KERNEL);
>>       if (!rinfop)
>>           return -ENOMEM;
>> -    spin_lock_irqsave(&sfp->rq_list_lock, iflags);
>>       val = 0;
>> -    list_for_each_entry(srp, &sfp->rq_list, entry) {
>> +    xa_for_each(&sfp->srp_arr, idx, srp) {
>> +        if (!srp)
>> +            continue;
>> +        if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_AWAIT))
>> +            continue;
>>           if (val >= SG_MAX_QUEUE)
>>               break;
>>           sg_fill_request_element(sfp, srp, rinfop + val);
>>           val++;
>>       }
>> -    spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>>   #ifdef CONFIG_COMPAT
>>       if (in_compat_syscall())
>>           result = put_compat_request_table(p, rinfop);
> 
> Are you sure about the locking here?
> The documentation to xarray states that you have to lock the xarray, too, so 
> what happened that you can drop all locks?

We are in the sg_ctl_req_tbl() function to output a list of request
states associated with a file descriptor on which an ioctl() has
been called. As long as this ioctl() [or any other system call on
that fd including close(2) itself] cannot race with the release()
function in this driver [sg_release()] on that fd, then IMO this
works.
The non-race" is important because the only time that the sg driver
actually removes sg_request objects from its xarray is as a result
of that sg_release(). Before that, only new entries can be added,
and what the xarray elements point at can change.

My reading of xa_for_each() macro in xarray.h is that it doesn't
need external locks. However if we send a READ followed by a WRITE
command to the same fd and logically the READ must finish before
the WRITE starts (e.g. copy data from one block to another on the
same disk), then both the RAD and WRITE may appear in the returned
request list as ACTIVE (or inflight). The same applies to the
debug output. This is because the state of the requests associated
with this fd may change between and during iterations.

Thanks for reviewing this
Doug Gilbert

