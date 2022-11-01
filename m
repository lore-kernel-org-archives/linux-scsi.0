Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BFEC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 10:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiKAKPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 06:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKAKPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 06:15:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B1263A2;
        Tue,  1 Nov 2022 03:15:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B77FD68AA6; Tue,  1 Nov 2022 11:15:11 +0100 (CET)
Date:   Tue, 1 Nov 2022 11:15:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v3 12/19] block,nvme,scsi,dm: Add blk_status to pr_ops
 callouts
Message-ID: <20221101101511.GA13304@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com> <20221026231945.6609-13-michael.christie@oracle.com> <20221030082020.GC4774@lst.de> <a7e447b5-b26e-7aa0-ab6a-3463b8497d26@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7e447b5-b26e-7aa0-ab6a-3463b8497d26@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 30, 2022 at 06:05:35PM -0500, Mike Christie wrote:
> The problem I hit is that in the ioctl code I then have to do:
> 
> @@ -269,7 +270,14 @@ static int blkdev_pr_register(struct block_device *bdev,
>  
>  	if (reg.flags & ~PR_FL_IGNORE_KEY)
>  		return -EOPNOTSUPP;
> -	return ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
> +	ret = ops->pr_register(bdev, reg.old_key, reg.new_key, reg.flags);
> +	if (ret == -EBADE) {
> +		if (bdev_is_nvme(bdev))
> +			ret = NVME_SC_RESERVATION_CONFLICT;
> +		else if (bdev_is_scsi(bdev)
> +			ret = SAM_STAT_RESERVATION_CONFLICT;
> +	}
> +	return ret;

Eww.  We should have never leaked protocol specific values out to
userspace.  This is an original bug I introduceѕ, so all blame is on me.

I suspect the right way to fix is is to keep the numeric value of
SAM_STAT_RESERVATION_CONFLICT and give it a new constant exposed in
the uapi header, assuming that SCSI is the thing people actually
used the PR API for, and nvme was just an nice little add-on.

Now if an errno value or blk_status_t is returned from the method
should not matter for this fix, but in the long run I think the
blk_status_t would be cleaner than the int used for errno, and
that will also prevent us from returning accidental non-intended
values.

Btw, I also thing we should rename BLK_STS_NEXUS to
BLK_STS_RESERVATION_CONFLICT (assuming s390 is ok with that), as that
has much better documentary value.

> +	case BLK_STS_TRANSPORT:
> +		if (bdev_is_nvme(bdev))
> +			ret = NVME_SC_HOST_PATH_ERROR;
> +		else if (bdev_is_scsi(bdev)
> +			ret = DID_TRANSPORT_FAILFAST or DID_TRANSPORT_MARGINAL;
> +		break;

And we'll need an uapi value for this as well.

> +	case BLK_STS_NOTSUPP:

and maybe this unless we can just get away with the negative errno
value.
