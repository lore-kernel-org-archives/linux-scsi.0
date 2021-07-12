Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9B2C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526FF61433
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbhGLHiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 03:38:04 -0400
Received: from verein.lst.de ([213.95.11.211]:51508 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344947AbhGLHf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 03:35:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5AB4F67373; Mon, 12 Jul 2021 09:32:34 +0200 (CEST)
Date:   Mon, 12 Jul 2021 09:32:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V3 02/10] blk-mq: Introduce blk_mq_dev_map_queues
Message-ID: <20210712073233.GB12347@lst.de>
References: <20210709081005.421340-1-ming.lei@redhat.com> <20210709081005.421340-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081005.421340-3-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +	/*
> +	 * fallback to default mapping if driver doesn't provide
> +	 * get_queue_affinity callback
> +	 */
> +	if (!get_queue_affinity) {
> +		fallback = true;
> +		goto fallback;
> +	}
> +
> +	for (queue = 0; queue < qmap->nr_queues; queue++) {
> +		mask = get_queue_affinity(dev_data, dev_off, queue);
> +		if (!mask)
> +			goto fallback;
> +
> +		for_each_cpu(cpu, mask)
> +			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> +	}
> +
> +	return 0;
> +
> +fallback:
> +	if (!fallback) {
> +		WARN_ON_ONCE(qmap->nr_queues > 1);
> +		blk_mq_clear_mq_map(qmap);
> +		return 0;
> +	}
> +	return blk_mq_map_queues(qmap);

Please remove the NULL get_affinity case and let the callers handle
the fallback.  Also I think it makes sense to leave the !mask fallback
case to the callers as well to simplify the calling conventions.
