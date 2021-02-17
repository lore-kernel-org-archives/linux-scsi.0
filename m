Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CF1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A64264D9A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhBQJhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:37:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:56424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhBQJhN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Feb 2021 04:37:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613554586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=poxJexEPxlZQBc32Pjp3fLiYsv3X3X8Nl4QWJnL1of8=;
        b=Ka0aPkfUNyDdFvipsioXkfDBoZsOX/byCQudItucWBB9xWL/FkCS4rLTbU/eldts8gUuR4
        YbLjwhd4X7cVSWaNqa8YlEXq/V+9qrl6aXir4sLtoGxcG6zWAwf0JjXgUwOAEc6eOXBdFR
        /+G5syx5zum9pzbKwXYMkhtT7fl+jKE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 55224B133;
        Wed, 17 Feb 2021 09:36:26 +0000 (UTC)
Date:   Wed, 17 Feb 2021 10:36:25 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <YCzjmfTxDmVtInbu@dhcp22.suse.cz>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <SN4PR0401MB3598D86F05613F41049038BB9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598D86F05613F41049038BB9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 17-02-21 09:08:07, Johannes Thumshirn wrote:
> On 17/02/2021 09:03, Michal Hocko wrote:
> >> No I don't think so. A mutex isn't a spinlock so we can sleep on the allocation.
> >> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zones() called
> >> a few line below also does the memalloc_noio_{save,restore}() dance.
> > 
> > You should be extending noio scope then if this allocation falls into
> > the same category. Ideally the scope should start at the recursion place
> > and end where the scope really ened.
> 
> That means all callers of blk_revalidate_disk_zones() should do 
> memalloc_noio_{save,restore}?

I am not really familiar with the IO area to answer this. The base idea
is to start the NOIO scope at the boundary which defines "unsafe to
re-enter or cannot deal with a new IO" from the reclaim path.

> If yes, can we somehow runtime assert that this is done, so we don't
> end up with bad surprises?

Could you elaborate?
 
> >> Would a kmem_cache for these revalidations help us in any way?
> > 
> > I am not sure what you mean here.
> > 
> 
> Using a kmem_cache for the allocations passed into blk_revalidate_disk_zones().
> I've looked into kmem_cache_alloc() and I couldn't find anything that speaks 
> against it, but I'm not too familiar with the code.

kmem_cache_alloc is only an extension to allow to allocate from a
specific cache. I do not really see how it is going to help with larger
allocation and my current understanding is that kvmalloc is used because
the requested allocation size can be large.

-- 
Michal Hocko
SUSE Labs
