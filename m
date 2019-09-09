Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027F2C4740A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 15:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8870218DE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 15:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfIIPBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 11:01:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:58644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbfIIPBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Sep 2019 11:01:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02748B673;
        Mon,  9 Sep 2019 15:01:42 +0000 (UTC)
Subject: Re: [PATCH v4 12/22] sg: sense buffer rework
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        bvanassche@acm.org, hch@infradead.org
References: <20190829022659.23130-1-dgilbert@interlog.com>
 <20190829022659.23130-13-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <7d6437e7-18ac-742f-0f99-e77e0a265509@suse.de>
Date:   Mon, 9 Sep 2019 17:01:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190829022659.23130-13-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/29/19 4:26 AM, Douglas Gilbert wrote:
> The biggest single item in the sg_request object is the sense
> buffer array which is SCSI_SENSE_BUFFERSIZE bytes long. That
> constant started out at 18 bytes 20 years ago and is 96 bytes
> now and might grow in the future. On the other hand the sense
> buffer is only used by a small number of SCSI commands: those
> that fail and those that want to return more information
> other than a SCSI status of GOOD.
> 
> Set up a small mempool called "sg_sense" that is only used as
> required and released back to the mempool as soon as practical.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sg.c | 86 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 2e476e74130b..ebb9d4f53177 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -72,6 +72,10 @@ static char *sg_version_date = "20190606";
>   */
>  #define SG_MAX_CDB_SIZE 252
>  
> +static struct kmem_cache *sg_sense_cache;
> +#define SG_MEMPOOL_MIN_NR 4
> +static mempool_t *sg_sense_pool;
> +
>  #define uptr64(val) ((void __user *)(uintptr_t)(val))
>  #define cuptr64(val) ((const void __user *)(uintptr_t)(val))
>  
> @@ -176,7 +180,6 @@ struct sg_request {	/* active SCSI command or inactive on free list (fl) */
>  	spinlock_t req_lck;
>  	struct sg_scatter_hold sgat_h;	/* hold buffer, perhaps scatter list */
>  	struct sg_slice_hdr3 s_hdr3;  /* subset of sg_io_hdr */
> -	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
>  	u32 duration;		/* cmd duration in milliseconds */
>  	u32 rq_flags;		/* hold user supplied flags */
>  	u32 rq_info;		/* info supplied by v3 and v4 interfaces */
> @@ -188,6 +191,7 @@ struct sg_request {	/* active SCSI command or inactive on free list (fl) */
>  	u8 cmd_opcode;		/* first byte of SCSI cdb */
>  	u64 start_ns;		/* starting point of command duration calc */
>  	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
> +	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
>  	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
>  	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
>  	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
> @@ -845,18 +849,21 @@ sg_copy_sense(struct sg_request *srp)
>  	    (driver_byte(srp->rq_result) & DRIVER_SENSE)) {
>  		int sb_len = min_t(int, SCSI_SENSE_BUFFERSIZE, srp->sense_len);
>  		int mx_sb_len;
> +		u8 *sbp = srp->sense_bp;
>  		void __user *up;
>  
> +		srp->sense_bp = NULL;
>  		up = (void __user *)srp->s_hdr3.sbp;
>  		mx_sb_len = srp->s_hdr3.mx_sb_len;
> -		if (up && mx_sb_len > 0) {
> +		if (up && mx_sb_len > 0 && sbp) {
>  			sb_len = min_t(int, sb_len, mx_sb_len);
>  			/* Additional sense length field */
> -			sb_len_wr = 8 + (int)srp->sense_b[7];
> +			sb_len_wr = 8 + (int)sbp[7];
>  			sb_len_wr = min_t(int, sb_len, sb_len_wr);
> -			if (copy_to_user(up, srp->sense_b, sb_len_wr))
> +			if (copy_to_user(up, sbp, sb_len_wr))
>  				sb_len_wr = -EFAULT;
>  		}
> +		mempool_free(sbp, sg_sense_pool);
>  	}
>  	return sb_len_wr;
>  }
> @@ -963,8 +970,14 @@ sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
>  	h2p->driver_status = driver_byte(rq_result);
>  	if ((CHECK_CONDITION & status_byte(rq_result)) ||
>  	    (DRIVER_SENSE & driver_byte(rq_result))) {
> -		memcpy(h2p->sense_buffer, srp->sense_b,
> -		       sizeof(h2p->sense_buffer));
> +		if (srp->sense_bp) {
> +			u8 *sbp = srp->sense_bp;
> +
> +			srp->sense_bp = NULL;
> +			memcpy(h2p->sense_buffer, sbp,
> +			       sizeof(h2p->sense_buffer));
> +			mempool_free(sbp, sg_sense_pool);
> +		}
>  	}
>  	switch (host_byte(rq_result)) {
>  	/*
> @@ -999,17 +1012,21 @@ sg_rd_v1v2(void __user *buf, int count, struct sg_fd *sfp,
>  
>  	/* Now copy the result back to the user buffer.  */
>  	if (count >= SZ_SG_HEADER) {
> -		if (copy_to_user(buf, h2p, SZ_SG_HEADER))
> -			return -EFAULT;
> +		if (copy_to_user(buf, h2p, SZ_SG_HEADER)) {
> +			res = -EFAULT;
> +			goto fini;
> +		}
>  		buf += SZ_SG_HEADER;
>  		if (count > h2p->reply_len)
>  			count = h2p->reply_len;
>  		if (count > SZ_SG_HEADER) {
> -			if (sg_rd_append(srp, buf, count - SZ_SG_HEADER))
> -				return -EFAULT;
> +			res = sg_rd_append(srp, buf, count - SZ_SG_HEADER);
> +			if (res)
> +				goto fini;
>  		}
>  	} else
>  		res = (h2p->result == 0) ? 0 : -EIO;
> +fini:
>  	atomic_set(&srp->rq_st, SG_RS_DONE_RD);
>  	sg_finish_scsi_blk_rq(srp);
>  	sg_deact_request(sfp, srp);
> @@ -1971,8 +1988,17 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>  	srp->duration = sg_calc_rq_dur(srp);
>  	if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) && slen > 0))
>  		sg_check_sense(sdp, srp, slen);
> -	if (slen > 0)
> -		memcpy(srp->sense_b, scsi_rp->sense, slen);
> +	if (slen > 0) {
> +		if (scsi_rp->sense) {
> +			srp->sense_bp = mempool_alloc(sg_sense_pool,
> +						      GFP_ATOMIC);
> +			if (srp->sense_bp)
> +				memcpy(srp->sense_bp, scsi_rp->sense, slen);
> +		} else {
> +			pr_warn("%s: scsi_request::sense==NULL\n", __func__);
> +			slen = 0;
> +		}
> +	}
>  	srp->sense_len = slen;
>  	if (unlikely(test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))) {
>  		spin_lock(&srp->req_lck);
That looks ... odd.
What happens if 'mempool_alloc()' fails?
Shouldn't we set 'slen' to '0' here, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
