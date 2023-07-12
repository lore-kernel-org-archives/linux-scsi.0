Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1B0EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjGLNAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjGLNAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 09:00:23 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADE61982;
        Wed, 12 Jul 2023 06:00:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BBA8167373; Wed, 12 Jul 2023 15:00:17 +0200 (CEST)
Date:   Wed, 12 Jul 2023 15:00:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/8] blk-mq: add blk_mq_max_nr_hw_queues()
Message-ID: <20230712130017.GA12417@lst.de>
References: <20230712125455.1986455-1-ming.lei@redhat.com> <20230712125455.1986455-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712125455.1986455-2-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 08:54:48PM +0800, Ming Lei wrote:
> +/* Max nr_hw_queues for each hw queue type */
> +unsigned int blk_mq_max_nr_hw_queues(void)
> +{
> +	if (is_kdump_kernel())
> +		return 1;
> +	return nr_cpu_ids;

Again, these is_kdump_kernel hacks don't make any sense.   The amount
of maximum available CPU needs to come through a proper API, and we
need to use it, not add hacks like this.

The only thing that makes sense here is to find the last CPU
in cpu_possible_mask, and for kdump kernels to ensure that number
is 1 or whatever low value they want.

