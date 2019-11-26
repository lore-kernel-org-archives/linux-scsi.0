Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDF3C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 16:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18802075C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 16:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfKZQyk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:54:40 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727756AbfKZQyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 11:54:40 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id D2809C0FF302D9BEF805;
        Tue, 26 Nov 2019 16:54:37 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 26 Nov 2019 16:54:37 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 26 Nov
 2019 16:54:37 +0000
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
Date:   Tue, 26 Nov 2019 16:54:36 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/11/2019 15:14, Jens Axboe wrote:
> On 11/26/19 2:14 AM, Hannes Reinecke wrote:
>> Instead of allocating the tag bitmap in place we should be using a
>> pointer. This is in preparation for shared host-wide bitmaps.
> 
> Not a huge fan of this, it's an extra indirection in the hot path
> of both submission and completion.

Hi Jens,

Thanks for having a look.

I checked the disassembly for blk_mq_get_tag() as a sample - which I 
assume is one hot path function which you care about - and the cost of 
the indirection is a load instruction instead of an add, denoted by ***, 
below:

Before:
static inline struct blk_mq_tags *blk_mq_tags_from_data(struct 
blk_mq_alloc_data *data)
{
	if (data->flags & BLK_MQ_REQ_INTERNAL)
		return data->hctx->sched_tags;
      6ac:	a9554c64 	ldp	x4, x19, [x3, #336]

	return data->hctx->tags;
      6b0:	f27e003f 	tst	x1, #0x4
      6b4:	f9003ba0 	str	x0, [x29, #112]
      6b8:	a9078ba2 	stp	x2, x2, [x29, #120]
      6bc:	9a841273 	csel	x19, x19, x4, ne  // ne = any
	if (data->flags & BLK_MQ_REQ_RESERVED) {
      6c0:	36081021 	tbz	w1, #1, 8c4 <blk_mq_get_tag+0x264>
		if (unlikely(!tags->nr_reserved_tags)) {
      6c4:	b9400660 	ldr	w0, [x19, #4]

      6d4:	f90027ba 	str	x26, [x29, #72]
		tag_offset = 0;
      6c8:	52800018 	mov	w24, #0x0                   	// #0
		bt = &tags->breserved_tags;
      6cc:	91014273 	add	x19, x19, #0x50 ***
		if (unlikely(!tags->nr_reserved_tags)) {
      6d0:	340012e0 	cbz	w0, 92c <blk_mq_get_tag+0x2cc>
	tag = __blk_mq_get_tag(data, bt);
      6d8:	aa1303e1 	mov	x1, x19
      6dc:	aa1403e0 	mov	x0, x20
      6e0:	97fffe92 	bl	128 <__blk_mq_get_tag>

After:
static inline struct blk_mq_tags *blk_mq_tags_from_data(struct 
blk_mq_alloc_data *data)
{
	if (data->flags & BLK_MQ_REQ_INTERNAL)
		return data->hctx->sched_tags;

      6b4:	a9550004 	ldp	x4, x0, [x0, #336]

	return data->hctx->tags;
      6ac:	f27e005f 	tst	x2, #0x4
      6b0:	f9003ba1 	str	x1, [x29, #112]
		return data->hctx->sched_tags;
      6b8:	a9078fa3 	stp	x3, x3, [x29, #120]
	return data->hctx->tags;
      6bc:	9a841000 	csel	x0, x0, x4, ne  // ne = any
	if (data->flags & BLK_MQ_REQ_RESERVED) {
      6c0:	36080fa2 	tbz	w2, #1, 8b4 <blk_mq_get_tag+0x254>
		if (unlikely(!tags->nr_reserved_tags)) {
      6c4:	b9400401 	ldr	w1, [x0, #4]
      6cc:	f90027ba 	str	x26, [x29, #72]
		tag_offset = 0;
      6d0:	52800017 	mov	w23, #0x0                   	// #0
		bt = tags->breserved_tags;

      6c8:	340012a1 	cbz	w1, 91c <blk_mq_get_tag+0x2bc>
      6d4:	f9400c14 	ldr	x20, [x0, #24] ***
	tag = __blk_mq_get_tag(data, bt);
      6d8:	aa1303e0 	mov	x0, x19
      6dc:	aa1403e1 	mov	x1, x20
      6e0:	97fffe92 	bl	128 <__blk_mq_get_tag>

This is arm64 dis.

I'm just saying this to provide some illustration of the potential 
performance impact of this change.

Thanks,
John

