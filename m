Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D524FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 10:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A198A64DA8
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 10:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhBQKGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 05:06:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:47906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhBQKG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Feb 2021 05:06:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613556340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sRU+aW2C9/BKnDVgLI9Q0+Te8coHSTEkdegVaxtQGrg=;
        b=F/qReT/mSLPs/NeDT5RgyKnL99OQxTYQDh1+G4ATBJEkKr3HkfFxux1jpNMUHgJyfVbZK7
        EdKk7bi/YZUlf9hgraTBUXKJLt/W4DAmVu3LHi/Vt6zVkoG2FWqS177uEPHCtc9qDgkM7E
        Nu8kJtxobVIdVgV6vIB+27ygUb40Veg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66D6FAFB5;
        Wed, 17 Feb 2021 10:05:40 +0000 (UTC)
Date:   Wed, 17 Feb 2021 11:05:37 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <YCzqcXH6DAPC4rcb@dhcp22.suse.cz>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <SN4PR0401MB3598D86F05613F41049038BB9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzjmfTxDmVtInbu@dhcp22.suse.cz>
 <SN4PR0401MB359849D173B08EB61A6CE9F19B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB359849D173B08EB61A6CE9F19B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 17-02-21 09:41:58, Johannes Thumshirn wrote:
> On 17/02/2021 10:36, Michal Hocko wrote:
> > On Wed 17-02-21 09:08:07, Johannes Thumshirn wrote:
> >> On 17/02/2021 09:03, Michal Hocko wrote:
> >>>> No I don't think so. A mutex isn't a spinlock so we can sleep on the allocation.
> >>>> We can't use GFP_KERNEL as we're about to do I/O. blk_revalidate_disk_zones() called
> >>>> a few line below also does the memalloc_noio_{save,restore}() dance.
> >>>
> >>> You should be extending noio scope then if this allocation falls into
> >>> the same category. Ideally the scope should start at the recursion place
> >>> and end where the scope really ened.
> >>
> >> That means all callers of blk_revalidate_disk_zones() should do 
> >> memalloc_noio_{save,restore}?
> > 
> > I am not really familiar with the IO area to answer this. The base idea
> > is to start the NOIO scope at the boundary which defines "unsafe to
> > re-enter or cannot deal with a new IO" from the reclaim path.
> > 
> >> If yes, can we somehow runtime assert that this is done, so we don't
> >> end up with bad surprises?
> > 
> > Could you elaborate?
> 
> I though of lifting the noio scope into the callers of 
> blk_revalidate_disk_zones() and then "check" in blk_revalidate_disk_zones()
> this has been done. But it looks like memalloc_noio_save() can handle nesting,
> so this is actually unneeded.

Yes, it can handle nesting. As to where to start the scope, this should
be at the boundary of "do not reenter IO path from the reclaim". This
can be a lock which is held for the allocation which will be needed for
an IO induced by the reclaim or any other resouce that will block from
the IO path. Is this more clear now?
-- 
Michal Hocko
SUSE Labs
