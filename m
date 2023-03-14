Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C562C7618B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCNRL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCNRL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:11:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B30099D75;
        Tue, 14 Mar 2023 10:11:23 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 30BD268AA6; Tue, 14 Mar 2023 18:11:20 +0100 (CET)
Date:   Tue, 14 Mar 2023 18:11:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Message-ID: <20230314171119.GB6780@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com> <20230224174502.321490-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224174502.321490-3-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2023 at 11:44:46AM -0600, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts or in dasd's
> case something similar. This renames BLK_STS_NEXUS so it better reflects
> this.

I like this rename a lot.

> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
> index a9c2a8d76c45..a2899d9690d4 100644
> --- a/drivers/s390/block/dasd.c
> +++ b/drivers/s390/block/dasd.c
> @@ -2723,7 +2723,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
>  	else if (status == 0) {
>  		switch (cqr->intrc) {
>  		case -EPERM:
> -			error = BLK_STS_NEXUS;
> +			error = BLK_STS_RESV_CONFLICT;
>  			break;

But is this really a reservation conflict?  Or should the DASD code
maybe use a different error code here?

