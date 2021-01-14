Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31118C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A7B2389E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 07:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbhANHba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 02:31:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:41954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbhANHba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 02:31:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 11586ABD6;
        Thu, 14 Jan 2021 07:30:48 +0000 (UTC)
Subject: Re: [PATCH v13 43/45] sg: no_dxfer: move to/from kernel buffers
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-44-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c8f449c2-9a69-2fb7-a1fa-a309b4d8b768@suse.de>
Date:   Thu, 14 Jan 2021 08:30:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210113224526.861000-44-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/21 11:45 PM, Douglas Gilbert wrote:
> When the NO_DXFER flag is use on a command/request, the data-in
> and data-out buffers (if present) should not be ignored. Add
> sg_rq_map_kern() function to handle this. Uses a single bio with
> multiple bvec_s usually each holding multiple pages, if necessary.
> The driver default element size is 32 KiB so if PAGE_SIZE is 4096
> then get_order()==3 .
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index a00f488ee5e2..ad97f0756a9c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2865,6 +2865,63 @@ exit_sg(void)
>   	idr_destroy(&sg_index_idr);
>   }
>   
> +static struct bio *
> +sg_mk_kern_bio(int bvec_cnt)
> +{
> +	struct bio *biop;
> +
> +	if (bvec_cnt > BIO_MAX_PAGES)
> +		return NULL;
> +	biop = bio_alloc(GFP_ATOMIC, bvec_cnt);
> +	if (!biop)
> +		return NULL;
> +	biop->bi_end_io = bio_put;

Huh? That is the default action, is it not?
So why specify it separately?

> +	return biop;
> +}
> +
> +/*
> + * Setup to move data between kernel buffers managed by this driver and a SCSI device. Note that
> + * there is no corresponding 'unmap' call as is required by blk_rq_map_user() . Uses a single
> + * bio with an expanded appended bvec if necessary.
> + */
> +static int
> +sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *rqq, int rw_ind)
> +{
> +	struct sg_scatter_hold *schp = &srp->sgat_h;
> +	struct bio *bio;
> +	int k, ln;
> +	int op_flags = 0;
> +	int num_sgat = schp->num_sgat;
> +	int dlen = schp->dlen;
> +	int pg_sz = 1 << (PAGE_SHIFT + schp->page_order);
> +	int num_segs = (1 << schp->page_order) * num_sgat;
> +	int res = 0;
> +
> +	SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n", __func__, dlen, pg_sz);
> +	if (num_sgat <= 0)
> +		return 0;
> +	if (rw_ind == WRITE)
> +		op_flags = REQ_SYNC | REQ_IDLE;
> +	bio = sg_mk_kern_bio(num_sgat - k);
> +	if (!bio)
> +		return -ENOMEM;
> +	bio->bi_opf = req_op(rqq) | op_flags;
> +
> +	for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
> +		ln = min_t(int, dlen, pg_sz);
> +		if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
> +			bio_put(bio);
> +			return -EINVAL;
> +		}
> +	}
> +	res = blk_rq_append_bio(rqq, &bio);
> +	if (unlikely(res))
> +		bio_put(bio);
> +	else
> +		rqq->nr_phys_segments = num_segs;
> +	return res;
> +}
> +
>   static inline void
>   sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
>   		struct rq_map_data *mdp)
> @@ -3028,6 +3085,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
>   		if (IS_ENABLED(CONFIG_SCSI_PROC_FS) && res)
>   			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
>   			       __func__, res);
> +	} else {	/* transfer data to/from kernel buffers */
> +		res = sg_rq_map_kern(srp, q, rq, r0w);
>   	}
>   fini:
>   	if (unlikely(res)) {		/* failure, free up resources */
> 
Hmm. I must say I fail to see the rationale here.
Why do you need to do the additional mapping?
And doens't the 'NO_DXFER' flag indicate that _no_ data should be 
transferred?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
