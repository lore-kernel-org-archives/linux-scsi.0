Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABB0C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B43B23F5C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394087AbgLKRGT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394278AbgLKRF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Dec 2020 12:05:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607706242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7UY2I3GoBLSPd0Ton2Uhm7zhxW0pOwaS+4enBrxYLY=;
        b=NYnYmm6pmtEOi0Kpf1bwisd00v1XQX5XDi8bCJfhm7836MZvCKKguUuXvrG0OJVJWSP9hX
        EqK7StfGMVU0p3TCI81TerKLcAJe3ldJIA/vitzs4ZkYURUzd2Zl6StHI+hyieECNQw7vP
        K/+ySA+xg4M85i3QPPGbQ6PPnXx6+aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-y-RRIHHHPgqy5o9pGaoSLA-1; Fri, 11 Dec 2020 12:03:58 -0500
X-MC-Unique: y-RRIHHHPgqy5o9pGaoSLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC031934102;
        Fri, 11 Dec 2020 17:03:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77E0F60BD9;
        Fri, 11 Dec 2020 17:03:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 0BBH3t1k028577;
        Fri, 11 Dec 2020 12:03:55 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 0BBH3q7E028573;
        Fri, 11 Dec 2020 12:03:52 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 11 Dec 2020 12:03:52 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
cc:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC PATCH v3 1/2] block: add simple copy support
In-Reply-To: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Message-ID: <alpine.LRH.2.02.2012111200490.27753@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201211135139.49232-1-selvakuma.s1@samsung.com> <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com> <20201211135139.49232-2-selvakuma.s1@samsung.com>
 <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Fri, 11 Dec 2020, Johannes Thumshirn wrote:

> On 11/12/2020 15:57, SelvaKumar S wrote:
> [...] 
> > +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> > +		gfp_t gfp_mask)
> > +{
> > +	struct request_queue *q = bdev_get_queue(bdev);
> > +	struct bio *bio;
> > +	void *buf = NULL;
> > +	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> > +
> > +	nr_srcs = payload->copy_range;
> > +	max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
> > +	cur_dest = payload->dest;
> > +	buf = kvmalloc(max_range_len, GFP_ATOMIC);
> 
> Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvmalloc()
> which has the potential to grow quite big.

You are right, this is confusing.

There's this piece of code at the top of kvmalloc_node:
        if ((flags & GFP_KERNEL) != GFP_KERNEL)
                return kmalloc_node(size, flags, node);

So, when you use GFP_ATOMIC flag, it will always fall back to kmalloc.

Mikulas

