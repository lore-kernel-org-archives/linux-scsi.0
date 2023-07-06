Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8F3EB64DC
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 12:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjGFMlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjGFMlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 08:41:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CAE171A;
        Thu,  6 Jul 2023 05:41:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6CF8468AFE; Thu,  6 Jul 2023 14:41:14 +0200 (CEST)
Date:   Thu, 6 Jul 2023 14:41:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/5] block: nullblk: Set zone limits before
 revalidating zones
Message-ID: <20230706124114.GC12545@lst.de>
References: <20230630083935.433334-1-dlemoal@kernel.org> <20230630083935.433334-4-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630083935.433334-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 30, 2023 at 05:39:33PM +0900, Damien Le Moal wrote:
> +	if (queue_is_mq(q))
> +		return blk_revalidate_disk_zones(nullb->disk, NULL);
> +
>  	return 0;

I'd write this as:

	if (!queue_is_mq(q)))
		return 0;
	return blk_revalidate_disk_zones(nullb->disk, NULL);

but that's just cosmetic.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
