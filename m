Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE26C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75FE613CC
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhGII2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:28:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57930 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhGII2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:28:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 235E620274;
        Fri,  9 Jul 2021 08:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625819131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8K4H3iqSDD9YoSW7p9vhetIaRQmX4th7sJmNpjTLR9c=;
        b=fEmdLSOhPe7NKpluWjJFBjTodSTNn3A6oJQytry6iEejtgk12xRKLjiALvrKlVWqssg9Dn
        VGEDhmn4CdKR74eaYPMR5azEB4aQdE/kBvDM9Qcoom371hunUt6AYrtRsUvmteU1VHNCrU
        KtvVyAZTTXLnIcX80iT8Fa/5Cp0hvoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625819131;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8K4H3iqSDD9YoSW7p9vhetIaRQmX4th7sJmNpjTLR9c=;
        b=KZZl/U3IGR0oCdEhdH42sra8OgDricDFf2IEqoQhYNk1HE0nkMUM2ReWkOp20s+WZ+suUF
        MY5e0UEGVC9PPHBg==
Received: from localhost (unknown [10.163.25.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4C39BA3B9D;
        Fri,  9 Jul 2021 08:25:30 +0000 (UTC)
Date:   Fri, 9 Jul 2021 10:25:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V3 02/10] blk-mq: Introduce blk_mq_dev_map_queues
Message-ID: <20210709082530.eefzeucgqulr6spv@beryllium.lan>
References: <20210709081005.421340-1-ming.lei@redhat.com>
 <20210709081005.421340-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081005.421340-3-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 09, 2021 at 04:09:57PM +0800, Ming Lei wrote:
> +/**
> + * blk_mq_dev_map_queues - provide generic queue mapping
> + * @qmap:	CPU to hardware queue map.
> + * @dev_off:	Offset to use for the device
> + * @get_queue_affinity:	Callback to retrieve queue affinity
> + * @dev_data:	Device data passed to get_queue_affinity()
> + * @fallback:	If true, fallback to default blk-mq mapping in case of
> + * any failure

The docs have a different order compared to the function definition (dev_data).

> + *
> + * Generic function to setup each queue mapping in @qmap. It will query
> + * each queue's affinity via @get_queue_affinity and built queue mapping
> + * that maps a queue to the CPUs in the queue affinity.
> + *
> + * Driver has to set correct @dev_data, so that the driver callback
> + * of @get_queue_affinity can work correctly.
> + */
> +int blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap, void *dev_data,
> +		int dev_off, get_queue_affinty_fn *get_queue_affinity,
> +		bool fallback)

