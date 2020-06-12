Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F82C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 03:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D51520792
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 03:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gdTBi4BO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgFLDzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 23:55:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18068 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgFLDzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 23:55:05 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200612035502epoutp0141a59d5da92fbc70adb426e58f8bca15~Xr6HYzyzH2170021700epoutp01G
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 03:55:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200612035502epoutp0141a59d5da92fbc70adb426e58f8bca15~Xr6HYzyzH2170021700epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591934103;
        bh=RQa8AFCM99yUGiDu4NxIgEUEIJgifsocm6dc35PWvOw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gdTBi4BO4hXGAT+3x94E/A5tEmwiMI2+ALwViXRWZ1vZDvV6xCPiEzt3ssNw1/zf1
         v4JnVUD2anfRVXg16902PPDpom7oZKwb32P8RlNJo48I9JVqEQ0D3hV/nvplKYiEV3
         IZ3zaG7NOzlqHapxruZu+DcZT81lfnQOeWrMaGqc=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200612035502epcas1p11585e2cec8f289714ecf22b3fa330541~Xr6G-_Jkz2660226602epcas1p1z;
        Fri, 12 Jun 2020 03:55:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <0389f9cf-fea8-9990-7699-0e4322728e4a@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21591934102518.JavaMail.epsvc@epcpadp1>
Date:   Fri, 12 Jun 2020 12:37:52 +0900
X-CMS-MailID: 20200612033752epcms2p5e3532bd586a435bab2148e5b251d8bab
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <0389f9cf-fea8-9990-7699-0e4322728e4a@acm.org>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
> > +					     struct ufshpb_subregion *srgn)
> > +{
> > +	struct ufshpb_req *map_req;
> > +	struct request *req;
> > +	struct bio *bio;
> > +
> > +	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
> > +	if (!map_req)
> > +		return NULL;
> > +
> > +	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
> > +			      REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
> > +	if (IS_ERR(req))
> > +		goto free_map_req;
> > +
> > +	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
> > +	if (!bio) {
> > +		blk_put_request(req);
> > +		goto free_map_req;
> > +	}
> > +
> > +	map_req->hpb = hpb;
> > +	map_req->req = req;
> > +	map_req->bio = bio;
> > +
> > +	map_req->rgn_idx = srgn->rgn_idx;
> > +	map_req->srgn_idx = srgn->srgn_idx;
> > +	map_req->mctx = srgn->mctx;
> > +	map_req->lun = hpb->lun;
> > +
> > +	return map_req;
> > +free_map_req:
> > +	kmem_cache_free(hpb->map_req_cache, map_req);
> > +	return NULL;
> > +}

> Will blk_get_request() fail if all tags have been allocated? Can that
> cause a deadlock or infinite loop?
If the worker fails to receive the tag, it stops and exits. The remained
lists are processed again at the next work. Therefore, no deadlock or
infinite loop occurs.

> > +static inline void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
> > +					   int srgn_idx, int srgn_mem_size)
> > +{
> > +	cdb[0] = UFSHPB_READ_BUFFER;
> > +	cdb[1] = UFSHPB_READ_BUFFER_ID;
> > +
> > +	put_unaligned_be32(srgn_mem_size, &cdb[5]);
> > +	/* cdb[5] = 0x00; */
> > +	put_unaligned_be16(rgn_idx, &cdb[2]);
> > +	put_unaligned_be16(srgn_idx, &cdb[4]);
> > +
> > +	cdb[9] = 0x00;
> > +}

> So the put_unaligned_be32(srgn_mem_size, &cdb[5]) comes first because
> the put_unaligned_be16(srgn_idx, &cdb[4]) overwrites byte cdb[5]? That
> is really ugly. Please use put_unaligned_be24() instead if that is what
> you meant and keep the put_*() calls in increasing cdb offset order.
OK, I will.

> > +static int ufshpb_map_req_add_bio_page(struct ufshpb_lu *hpb,
> > +				       struct request_queue *q, struct bio *bio,
> > +				       struct ufshpb_map_ctx *mctx)
> > +{
> > +	int i, ret = 0;
> > +
> > +	for (i = 0; i < hpb->pages_per_srgn; i++) {
> > +		ret = bio_add_pc_page(q, bio, mctx->m_page[i], PAGE_SIZE, 0);
> > +		if (ret != PAGE_SIZE) {
> > +			dev_notice(&hpb->hpb_lu_dev,
> > +				   "bio_add_pc_page fail %d\n", ret);
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
	
> Why bio_add_pc_page() instead of bio_add_page()?
Since this map request is created under the block layer and it is a
passthrough command, I think bio_add_pc_page is a more suitable API than
bio_add_page. If bio_add_page is used in scsi LLD, the checking codes that
examine the max segment size in the block layer is not performed.

> > +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
> > +				  struct ufshpb_req *map_req)
> > +{
> > +	struct request_queue *q;
> > +	struct request *req;
> > +	struct scsi_request *rq;
> > +	int ret = 0;
> > +
> > +	q = hpb->sdev_ufs_lu->request_queue;
> > +	ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
> > +					  map_req->mctx);
> > +	if (ret) {
> > +		dev_notice(&hpb->hpb_lu_dev,
> > +			   "map_req_add_bio_page fail %d - %d\n",
> > +			   map_req->rgn_idx, map_req->srgn_idx);
> > +		return ret;
> > +	}
> > +
> > +	req = map_req->req;
> > +
> > +	blk_rq_append_bio(req, &map_req->bio);
> > +	req->rq_flags |= RQF_QUIET;
> > +	req->timeout = MAP_REQ_TIMEOUT;
> > +	req->end_io_data = (void *)map_req;
> > +
> > +	rq = scsi_req(req);
> > +	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> > +				map_req->srgn_idx, hpb->srgn_mem_size);
> > +	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
> > +
> > +	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
> > +
> > +	atomic_inc(&hpb->stats.map_req_cnt);
> > +	return 0;
> > +}

> Why RQF_QUIET?
I refered scsi execute function. I will delete the needless flag.

> Why a custom timeout instead of the SCSI LUN timeout?
There was no suitable timeout value to use. I've included sd.h, so I'll
use sd_timeout.

> Can this function be made asynchronous such that it does not have to be
> executed on the context of a workqueue?
If this code doesn't work in your workq, map related task is handled in
interrupt context. Using workq, it avoids frequent active/inactive requests
to UFS devices by batched manner.

Thanks,

Daejun.


