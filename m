Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D0FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 17:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C524423B4B
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 17:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbhANRMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:12:34 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:58667 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhANRMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 12:12:33 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 7143F2EA3CC;
        Thu, 14 Jan 2021 12:11:52 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id GOneSSauA7jc; Thu, 14 Jan 2021 11:58:33 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 1C78A2EA030;
        Thu, 14 Jan 2021 12:11:51 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v13 43/45] sg: no_dxfer: move to/from kernel buffers
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-44-dgilbert@interlog.com>
 <c8f449c2-9a69-2fb7-a1fa-a309b4d8b768@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d15aa6a1-f889-8c5f-f80e-c680a42bb8c4@interlog.com>
Date:   Thu, 14 Jan 2021 12:11:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c8f449c2-9a69-2fb7-a1fa-a309b4d8b768@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-14 2:30 a.m., Hannes Reinecke wrote:
> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>> When the NO_DXFER flag is use on a command/request, the data-in
>> and data-out buffers (if present) should not be ignored. Add
>> sg_rq_map_kern() function to handle this. Uses a single bio with
>> multiple bvec_s usually each holding multiple pages, if necessary.
>> The driver default element size is 32 KiB so if PAGE_SIZE is 4096
>> then get_order()==3 .
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 59 insertions(+)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index a00f488ee5e2..ad97f0756a9c 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -2865,6 +2865,63 @@ exit_sg(void)
>>       idr_destroy(&sg_index_idr);
>>   }
>> +static struct bio *
>> +sg_mk_kern_bio(int bvec_cnt)
>> +{
>> +    struct bio *biop;
>> +
>> +    if (bvec_cnt > BIO_MAX_PAGES)
>> +        return NULL;
>> +    biop = bio_alloc(GFP_ATOMIC, bvec_cnt);
>> +    if (!biop)
>> +        return NULL;
>> +    biop->bi_end_io = bio_put;
> 
> Huh? That is the default action, is it not?
> So why specify it separately?

I'll check. That code snippet is copied from NVMe which has equivalent
code: moving storage data to/from _kernel_ buffers. Later in the driver
rewrite, bios are re-used, so if any earlier path puts a different
value in biop->bi_end_io, I'm screwed without that line. So I assumed
the NVMe code did it for a good reason.

>> +    return biop;
>> +}
>> +
>> +/*
>> + * Setup to move data between kernel buffers managed by this driver and a 
>> SCSI device. Note that
>> + * there is no corresponding 'unmap' call as is required by blk_rq_map_user() 
>> . Uses a single
>> + * bio with an expanded appended bvec if necessary.
>> + */
>> +static int
>> +sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct 
>> request *rqq, int rw_ind)
>> +{
>> +    struct sg_scatter_hold *schp = &srp->sgat_h;
>> +    struct bio *bio;
>> +    int k, ln;
>> +    int op_flags = 0;
>> +    int num_sgat = schp->num_sgat;
>> +    int dlen = schp->dlen;
>> +    int pg_sz = 1 << (PAGE_SHIFT + schp->page_order);
>> +    int num_segs = (1 << schp->page_order) * num_sgat;
>> +    int res = 0;
>> +
>> +    SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n", __func__, dlen, pg_sz);
>> +    if (num_sgat <= 0)
>> +        return 0;
>> +    if (rw_ind == WRITE)
>> +        op_flags = REQ_SYNC | REQ_IDLE;
>> +    bio = sg_mk_kern_bio(num_sgat - k);
>> +    if (!bio)
>> +        return -ENOMEM;
>> +    bio->bi_opf = req_op(rqq) | op_flags;
>> +
>> +    for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
>> +        ln = min_t(int, dlen, pg_sz);
>> +        if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
>> +            bio_put(bio);
>> +            return -EINVAL;
>> +        }
>> +    }
>> +    res = blk_rq_append_bio(rqq, &bio);
>> +    if (unlikely(res))
>> +        bio_put(bio);
>> +    else
>> +        rqq->nr_phys_segments = num_segs;
>> +    return res;
>> +}
>> +
>>   static inline void
>>   sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
>>           struct rq_map_data *mdp)
>> @@ -3028,6 +3085,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t 
>> *cwrp, int dxfer_dir)
>>           if (IS_ENABLED(CONFIG_SCSI_PROC_FS) && res)
>>               SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
>>                      __func__, res);
>> +    } else {    /* transfer data to/from kernel buffers */
>> +        res = sg_rq_map_kern(srp, q, rq, r0w);
>>       }
>>   fini:
>>       if (unlikely(res)) {        /* failure, free up resources */
>>
> Hmm. I must say I fail to see the rationale here.

See below.

> Why do you need to do the additional mapping?

I don't understand this question.

> And doens't the 'NO_DXFER' flag indicate that _no_ data should be transferred?

NO, it absolutely does not mean that! With indirect IO (i.e. the default) there
are two transfers, taking a READ operation is an example:
    1) transfer user data from the device (a LU) to the internal buffer allocated
       by the sg driver. LLD arranges that transfer.
    2) transfer that user data from the internal buffer to the user space as
       indicated by the call to ioctl(SG_IO) or its alternatives. This transfer
       is driven by the sg driver using copy_to_user().

The SG_FLAG_NO_DXFER flag skips step 2) _not_ 1) .

The SG_FLAG_NO_DXFER flag has been in the sg driver since 1998. Sometime between
2010 and now that functionality was quietly dropped. Tony Battersby for one
seemed quite peeved when I told him that functionality had been silently
dropped.

Why have the SG_FLAG_NO_DXFER flag?
   - originally to test read speed; no need to allocate and manage a user
     space buffer that isn't going to be used
   - force a RAID to properly check the validity of user data, especially
     if one doesn't trust the VERIFY command which can cheat and simply
     say: "Looks good, next"
   - on mirrored disks: full READ on primary, NO_DXFER READ on secondary;
     checks secondary mirror is in "good order" ***
   - implementation overlaps with mmap()-ed IO in which the "internal buffer"
     is visible to the user space
   - and the big one, for the sg driver rewrite: it is the basis of
     fast copy and compare: that READ internal buffer (a bio) is the perfect
     candidate for the internal buffer of the corresponding WRITE operation,
     both in space and time. In space: one bio for a bound READ and WRITE;
     in time: that WRITE cannot start until the READ completes.

And please RTFM, not just the code. Every time I present this driver I refer
to: https://doug-gilbert.github.io/sg_v40.html and/or the "danny' url. This
from table 2 on the flags field in the v3 and v4 interface:

SG_FLAG_NO_DXFER [0x10000]
SGV4_FLAG_NO_DXFER
With indirect IO, data is "bounced" through a kernel buffer as it passes from 
user space memory to the storage device (or vice versa). This flag instructs the 
driver not to do the portion of the copy between the kernel buffers and user 
memory. There are several cases where this is useful. It is used on WRITE side 
of request sharing because the data to be written is already sitting in that 
kernel buffer (placed there by the preceding READ). Another case is when data is 
mirrored on two disks, it only needs to be actually read back from one of the 
disks, but it may be a good idea to read it back from the other disk at the same 
time to see if a MEDIUM ERROR is reported (which would indicate the mirror is no 
longer safe). If the data is not going to be compared, then the second READ 
could use this flag.

Doug Gilbert


*** I have run the idea of returning a CRC value (T10 algo?) from a NO_DXFER
     READ which is produced from the returned user data. In the mirrored disk
     scenario it would be a way to not only check the secondary was in "good
     order" but that the CRC over the secondary data was the same as the CRC
     over the primary data which has been returned to the user space in full.
     Underwhelming response to date for that idea.
