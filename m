Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908BEC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 08:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1520764E2E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 08:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBQIEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 03:04:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:56206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhBQIEe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Feb 2021 03:04:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613549027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wTJaNcYW6ckI377qF/eRkyD549h8I6PCZ9TFFr2g3cI=;
        b=Bc5OGLx+tC8bhBPH/W84SbbrwPYsB3dP3atTMskRLQI5bW1+uEi8wDP8kBBWnWGDSaXp6u
        mzawWU6TXgG33rlNm89qywL8I06Zr9QXLG8C0u7glyr95zwcJaCgyigVfncVudu1dG8rQm
        JYjpOBKhD8mtfV93xA01UXdt2XrA58M=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A72A8AF45;
        Wed, 17 Feb 2021 08:03:47 +0000 (UTC)
Date:   Wed, 17 Feb 2021 09:03:46 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 17-02-21 06:42:37, Johannes Thumshirn wrote:
> On 17/02/2021 00:33, Damien Le Moal wrote:
> > On 2021/02/17 4:42, Dan Carpenter wrote:
> >> Hello Johannes Thumshirn,
> >>
> >> The patch 5795eb443060: "scsi: sd_zbc: emulate ZONE_APPEND commands"
> >> from May 12, 2020, leads to the following static checker warning:
> >>
> >> 	drivers/scsi/sd_zbc.c:741 sd_zbc_revalidate_zones()
> >> 	error: kvmalloc() only makes sense with GFP_KERNEL
> >>
> >> drivers/scsi/sd_zbc.c
> >>    721          /*
> >>    722           * There is nothing to do for regular disks, including host-aware disks
> >>    723           * that have partitions.
> >>    724           */
> >>    725          if (!blk_queue_is_zoned(q))
> >>    726                  return 0;
> >>    727  
> >>    728          /*
> >>    729           * Make sure revalidate zones are serialized to ensure exclusive
> >>    730           * updates of the scsi disk data.
> >>    731           */
> >>    732          mutex_lock(&sdkp->rev_mutex);
> >>    733  
> >>    734          if (sdkp->zone_blocks == zone_blocks &&
> >>    735              sdkp->nr_zones == nr_zones &&
> >>    736              disk->queue->nr_zones == nr_zones)
> >>    737                  goto unlock;
> >>    738  
> >>    739          sdkp->zone_blocks = zone_blocks;
> >>    740          sdkp->nr_zones = nr_zones;
> >>    741          sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);
> >>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> We're passing GFP_NOIO here so it just defaults to kcalloc() and will
> >> not vmalloc() the memory.
> > 
> > Indeed... And the allocation can get a little too big for kmalloc().
> > 
> > Johannes, I think we need to move that allocation before the rev_mutex locking,
> > using a local var for the allocated address, and then using GFP_KERNEL should be
> > safe... But not entirely sure. Using kmalloc would be simpler but on large SMR
> > drives, that allocation will soon need to be 400K or so (i.e. 100,000 zones or
> > even more), too large for kmalloc to succeed reliably.
> > 
> 
> 
> No I don't think so. A mutex isn't a spinlock so we can sleep on the allocation.
> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zones() called
> a few line below also does the memalloc_noio_{save,restore}() dance.

You should be extending noio scope then if this allocation falls into
the same category. Ideally the scope should start at the recursion place
and end where the scope really ened.
> 
> Would a kmem_cache for these revalidations help us in any way?

I am not sure what you mean here.
-- 
Michal Hocko
SUSE Labs
