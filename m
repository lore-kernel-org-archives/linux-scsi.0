Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63865C64E75
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 10:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271112145D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 10:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgKZJ7x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:59:53 -0500
Received: from verein.lst.de ([213.95.11.211]:33730 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387493AbgKZJ7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 04:59:53 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9883168B02; Thu, 26 Nov 2020 10:59:48 +0100 (CET)
Date:   Thu, 26 Nov 2020 10:59:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 60/78] zram: remove the claim mechanism
Message-ID: <20201126095948.GA24035@lst.de>
References: <20201116145809.410558-1-hch@lst.de> <20201116145809.410558-61-hch@lst.de> <20201126011107.GA57352@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126011107.GA57352@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 25, 2020 at 05:11:07PM -0800, Minchan Kim wrote:
> With this patch, how deal with the race?
> 
> CPU 1                                     CPU 2
> 
> hot_remove_store
>   zram_remove
>     zram_busy
>       return -EBUSY
>                                          open /dev/zram0
>     del_gendisk
>     zram_reset and destroy

Yeah, it looks like zram does not really handle hot unplugging unlike
other drivers.  So I've dropped this one for now.
