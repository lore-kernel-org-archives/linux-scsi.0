Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72329C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3345E64DEC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhA1JVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:21:13 -0500
Received: from verein.lst.de ([213.95.11.211]:56588 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhA1JR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 04:17:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 51C6868AFE; Thu, 28 Jan 2021 10:17:10 +0100 (CET)
Date:   Thu, 28 Jan 2021 10:17:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH v4 2/8] nvme: cleanup zone information initialization
Message-ID: <20210128091710.GA1959@lst.de>
References: <20210128044733.503606-1-damien.lemoal@wdc.com> <20210128044733.503606-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044733.503606-3-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  int nvme_revalidate_zones(struct nvme_ns *ns)
>  {
> -	struct request_queue *q = ns->queue;
> -	int ret;
> -
> -	ret = blk_revalidate_disk_zones(ns->disk, NULL);
> -	if (!ret)
> -		blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
> -	return ret;
> +	return blk_revalidate_disk_zones(ns->disk, NULL);

We can just kill off nvme_revalidate_zones now and open code it in
the caller as the stub is no needed now that blk_queue_is_zoned always
return false for the !CONFIG_BLK_DEV_ZONED case.

Otherwise this look great, nice cleanup:

Reviewed-by: Christoph Hellwig <hch@lst.de>
