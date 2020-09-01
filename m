Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D0CC433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D87BD2073A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cHKZlvbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgIAAXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 20:23:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60521 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIAAXH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 20:23:07 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200901002303epoutp02f4c6a3ba52ccb85afa51c9efc95d1983~wgRJU_VB31761117611epoutp02G
        for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2020 00:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200901002303epoutp02f4c6a3ba52ccb85afa51c9efc95d1983~wgRJU_VB31761117611epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598919783;
        bh=Xok3Nc5LCZyof2XDbFEopewPALLd7WpbVK2fR8DHi7A=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=cHKZlvbnE7Yhmt6MJETeP7LFlzEpqKUiVBfn8eQKXmboUGdBtW2jl8eosFUySlv6P
         NNBtC+nn47YAB9ETJlrdjZznwk5XdrRJdsmcVHpQZ9rmHtg5TRKE49FcZcO9QnWErF
         /Wi9SuEp+4kSWDw1Wu8By+zHl9UBxJu1iykROizQ=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200901002302epcas1p2dbe898750695c35865068378905cad00~wgRI3fxbW0561905619epcas1p2c;
        Tue,  1 Sep 2020 00:23:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v9 3/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
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
In-Reply-To: <5587cf86-eeec-2c70-a47c-57149f00eb95@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1239183618.61598919782940.JavaMail.epsvc@epcpadp2>
Date:   Tue, 01 Sep 2020 09:21:10 +0900
X-CMS-MailID: 20200901002110epcms2p59e3e52812b12ab19f210bb5c1f7f7391
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200828070950epcms2p5470bd43374be18d184dd802da09e73c8
References: <5587cf86-eeec-2c70-a47c-57149f00eb95@acm.org>
        <963815509.21598598782155.JavaMail.epsvc@epcpadp2>
        <1210830415.21598601302480.JavaMail.epsvc@epcpadp1>
        <CGME20200828070950epcms2p5470bd43374be18d184dd802da09e73c8@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,
> > +static unsigned int ufshpb_host_map_kbytes = 1024;
> 
> A comment that explains where this value comes from would be welcome.

I will add a follows comment and change defalut value 1024 to 2048. 
"A cache size of 2MB can cache ppn in the 1GB range."

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
> 
> Why BLK_MQ_REQ_PREEMPT? Since this code is only executed while medium access
> commands are processed and since none of these commands have the PREEMPT flag
> set I think that the PREEMPT flag should be left out. Otherwise there probably
> will be weird interactions with runtime suspended devices.

OK, I will remove BLK_MQ_REQ_PREEMPT flag.

> Is it acceptable that the above blk_get_request() call blocks if a UFS device
> has been runtime suspended? If not, consider using the flag BLK_MQ_REQ_NOWAIT
> instead.

The map worker don't issue map requests when the UFS device is in 
runtime suspend. So, I think BLK_MQ_REQ_NOWAIT flags is not needed.

> > +	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
> > +	if (!bio) {
> > +		blk_put_request(req);
> > +		goto free_map_req;
> > +	}
> 
> If the blk_get_request() would be modified such that it doesn't wait, this
> call may have to be modified too (GFP_NOWAIT?).
>
> > +	if (rgn->rgn_state == HPB_RGN_INACTIVE) {
> > +		if (atomic_read(&lru_info->active_cnt)
> > +		    == lru_info->max_lru_active_cnt) {
> 
> When splitting a line, please put comparison operators at the end of the line
> instead of at the start, e.g. as follows:
> 
> 		if (atomic_read(&lru_info->active_cnt) ==
> 		    lru_info->max_lru_active_cnt) {

OK, I will change it.
 
> > +	pool_size = DIV_ROUND_UP(ufshpb_host_map_kbytes * 1024, PAGE_SIZE);
> 
> Please use PAGE_ALIGN() to align to the next page boundary.

OK, I will.

Thanks,
Daejun.
