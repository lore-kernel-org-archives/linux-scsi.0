Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08B2C4740C
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 18:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A009D218AF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 18:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfIIShW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 14:37:22 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52524 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfIIShW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Sep 2019 14:37:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C94B12041CF;
        Mon,  9 Sep 2019 20:37:19 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 514A03276znE; Mon,  9 Sep 2019 20:37:17 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 8525C204155;
        Mon,  9 Sep 2019 20:37:16 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v4 12/22] sg: sense buffer rework
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        bvanassche@acm.org, hch@infradead.org
References: <20190829022659.23130-1-dgilbert@interlog.com>
 <20190829022659.23130-13-dgilbert@interlog.com>
 <7d6437e7-18ac-742f-0f99-e77e0a265509@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <26512bf0-6d6f-18fd-f287-248965ec0cc2@interlog.com>
Date:   Mon, 9 Sep 2019 14:37:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7d6437e7-18ac-742f-0f99-e77e0a265509@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-09 11:01 a.m., Hannes Reinecke wrote:
> On 8/29/19 4:26 AM, Douglas Gilbert wrote:
>> The biggest single item in the sg_request object is the sense
>> buffer array which is SCSI_SENSE_BUFFERSIZE bytes long. That
>> constant started out at 18 bytes 20 years ago and is 96 bytes
>> now and might grow in the future. On the other hand the sense
>> buffer is only used by a small number of SCSI commands: those
>> that fail and those that want to return more information
>> other than a SCSI status of GOOD.
>>
>> Set up a small mempool called "sg_sense" that is only used as
>> required and released back to the mempool as soon as practical.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 86 ++++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 73 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 2e476e74130b..ebb9d4f53177 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -72,6 +72,10 @@ static char *sg_version_date = "20190606";
>>    */
>>   #define SG_MAX_CDB_SIZE 252
>>   
>> +static struct kmem_cache *sg_sense_cache;
>> +#define SG_MEMPOOL_MIN_NR 4
>> +static mempool_t *sg_sense_pool;
>> +
>>   #define uptr64(val) ((void __user *)(uintptr_t)(val))
>>   #define cuptr64(val) ((const void __user *)(uintptr_t)(val))
>>   
>> @@ -176,7 +180,6 @@ struct sg_request {	/* active SCSI command or inactive on free list (fl) */
>>   	spinlock_t req_lck;
>>   	struct sg_scatter_hold sgat_h;	/* hold buffer, perhaps scatter list */
>>   	struct sg_slice_hdr3 s_hdr3;  /* subset of sg_io_hdr */
>> -	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
>>   	u32 duration;		/* cmd duration in milliseconds */
>>   	u32 rq_flags;		/* hold user supplied flags */
>>   	u32 rq_info;		/* info supplied by v3 and v4 interfaces */
>> @@ -188,6 +191,7 @@ struct sg_request {	/* active SCSI command or inactive on free list (fl) */
>>   	u8 cmd_opcode;		/* first byte of SCSI cdb */
>>   	u64 start_ns;		/* starting point of command duration calc */
>>   	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
>> +	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
>>   	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
>>   	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
>>   	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
>> @@ -845,18 +849,21 @@ sg_copy_sense(struct sg_request *srp)
>>   	    (driver_byte(srp->rq_result) & DRIVER_SENSE)) {
>>   		int sb_len = min_t(int, SCSI_SENSE_BUFFERSIZE, srp->sense_len);
>>   		int mx_sb_len;
>> +		u8 *sbp = srp->sense_bp;
>>   		void __user *up;
>>   
>> +		srp->sense_bp = NULL;
>>   		up = (void __user *)srp->s_hdr3.sbp;
>>   		mx_sb_len = srp->s_hdr3.mx_sb_len;
>> -		if (up && mx_sb_len > 0) {
>> +		if (up && mx_sb_len > 0 && sbp) {
>>   			sb_len = min_t(int, sb_len, mx_sb_len);
>>   			/* Additional sense length field */
>> -			sb_len_wr = 8 + (int)srp->sense_b[7];
>> +			sb_len_wr = 8 + (int)sbp[7];
>>   			sb_len_wr = min_t(int, sb_len, sb_len_wr);
>> -			if (copy_to_user(up, srp->sense_b, sb_len_wr))
>> +			if (copy_to_user(up, sbp, sb_len_wr))
>>   				sb_len_wr = -EFAULT;
>>   		}
>> +		mempool_free(sbp, sg_sense_pool);
>>   	}
>>   	return sb_len_wr;
>>   }
>> @@ -963,8 +970,14 @@ sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
>>   	h2p->driver_status = driver_byte(rq_result);
>>   	if ((CHECK_CONDITION & status_byte(rq_result)) ||
>>   	    (DRIVER_SENSE & driver_byte(rq_result))) {
>> -		memcpy(h2p->sense_buffer, srp->sense_b,
>> -		       sizeof(h2p->sense_buffer));
>> +		if (srp->sense_bp) {
>> +			u8 *sbp = srp->sense_bp;
>> +
>> +			srp->sense_bp = NULL;
>> +			memcpy(h2p->sense_buffer, sbp,
>> +			       sizeof(h2p->sense_buffer));
>> +			mempool_free(sbp, sg_sense_pool);
>> +		}
>>   	}
>>   	switch (host_byte(rq_result)) {
>>   	/*
>> @@ -999,17 +1012,21 @@ sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
>>   
>>   	/* Now copy the result back to the user buffer.  */
>>   	if (count >= SZ_SG_HEADER) {
>> -		if (copy_to_user(buf, h2p, SZ_SG_HEADER))
>> -			return -EFAULT;
>> +		if (copy_to_user(buf, h2p, SZ_SG_HEADER)) {
>> +			res = -EFAULT;
>> +			goto fini;
>> +		}
>>   		buf += SZ_SG_HEADER;
>>   		if (count > h2p->reply_len)
>>   			count = h2p->reply_len;
>>   		if (count > SZ_SG_HEADER) {
>> -			if (sg_rd_append(srp, buf, count - SZ_SG_HEADER))
>> -				return -EFAULT;
>> +			res = sg_rd_append(srp, buf, count - SZ_SG_HEADER);
>> +			if (res)
>> +				goto fini;
>>   		}
>>   	} else
>>   		res = (h2p->result == 0) ? 0 : -EIO;
>> +fini:
>>   	atomic_set(&srp->rq_st, SG_RS_DONE_RD);
>>   	sg_finish_scsi_blk_rq(srp);
>>   	sg_deact_request(sfp, srp);
>> @@ -1971,8 +1988,17 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>>   	srp->duration = sg_calc_rq_dur(srp);
>>   	if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) && slen > 0))
>>   		sg_check_sense(sdp, srp, slen);
>> -	if (slen > 0)
>> -		memcpy(srp->sense_b, scsi_rp->sense, slen);
>> +	if (slen > 0) {
>> +		if (scsi_rp->sense) {
>> +			srp->sense_bp = mempool_alloc(sg_sense_pool,
>> +						      GFP_ATOMIC);
>> +			if (srp->sense_bp)
>> +				memcpy(srp->sense_bp, scsi_rp->sense, slen);
>> +		} else {
>> +			pr_warn("%s: scsi_request::sense==NULL\n", __func__);
>> +			slen = 0;
>> +		}
>> +	}
>>   	srp->sense_len = slen;
>>   	if (unlikely(test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))) {
>>   		spin_lock(&srp->req_lck);
> That looks ... odd.
> What happens if 'mempool_alloc()' fails?
> Shouldn't we set 'slen' to '0' here, too?

Indeed. Fixed in v5 with a pr_warn() added, like the other failed branch.
Also make the pr_warn messages more precise.

Doug Gilbert


