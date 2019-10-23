Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B5CA9EB7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 07:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E12392084C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 07:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571814714;
	bh=KMNYWLnA63JkfYryd5Dc8Y3VDr9rJODaiVNj0U7jGI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LCRd+X0q7dU/7rqq1Bwz0Lxmo8cegjsTZD8TKsxrSVvYi2ZdPa9v38g31CiT+Sg2b
	 UWXhmQ54zq0iStPH8xfmt/7fdOUOpopGwv9KpF5wJ+BKI7+cH669VwH9yeRTi/J59M
	 Bg/uQbslhwY3FrnovVaYi/+KAaJjb4zcyZuTFhc4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbfJWHLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 03:11:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:51096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389090AbfJWHLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 03:11:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C515B3F8;
        Wed, 23 Oct 2019 07:11:48 +0000 (UTC)
Date:   Wed, 23 Oct 2019 09:11:46 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Mike Christie <mchristi@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        martin@urbackup.org, Damien.LeMoal@wdc.com
Subject: Re: [PATCH] Add prctl support for controlling PF_MEMALLOC V2
Message-ID: <20191023071146.GE754@dhcp22.suse.cz>
References: <20191021214137.8172-1-mchristi@redhat.com>
 <20191022112446.GA8213@dhcp22.suse.cz>
 <5DAF2AA0.5030500@redhat.com>
 <20191022163310.GS9379@dhcp22.suse.cz>
 <20191022204344.GB2044@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022204344.GB2044@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 23-10-19 07:43:44, Dave Chinner wrote:
> On Tue, Oct 22, 2019 at 06:33:10PM +0200, Michal Hocko wrote:

Thanks for more clarifiation regarding PF_LESS_THROTTLE.

[...]
> > PF_IO_FLUSHER would mean that the user
> > context is a part of the IO path and therefore there are certain reclaim
> > recursion restrictions.
> 
> If PF_IO_FLUSHER just maps to PF_LESS_THROTTLE|PF_MEMALLOC_NOIO,
> then I'm not sure we need a new definition. Maybe that's the ptrace
> flag name, but in the kernel we don't need a PF_IO_FLUSHER process
> flag...

Yes, the internal implementation would do something like that. I was
more interested in the user space visible API at this stage. Something
generic enough because exporting MEMALLOC flags is just a bad idea IMHO
(especially PF_MEMALLOC).

> > > >> This patch allows the userspace deamon to set the PF_MEMALLOC* flags
> > > >> with prctl during their initialization so later allocations cannot
> > > >> calling back into them.
> > > > 
> > > > TBH I am not really happy to export these to the userspace. They are
> > > > an internal implementation detail and the userspace shouldn't really
> > > 
> > > They care in these cases, because block/fs drivers must be able to make
> > > forward progress during writes. To meet this guarantee kernel block
> > > drivers use mempools and memalloc/GFP flags.
> > > 
> > > For these userspace components of the block/fs drivers they already do
> > > things normal daemons do not to meet that guarantee like mlock their
> > > memory, disable oom killer, and preallocate resources they have control
> > > over. They have no control over reclaim like the kernel drivers do so
> > > its easy for us to deadlock when memory gets low.
> > 
> > OK, fair enough. How much of a control do they really need though. Is a
> > single PF_IO_FLUSHER as explained above (essentially imply GPF_NOIO
> > context) sufficient?
> 
> I think some of these usrspace processes work at the filesystem
> level and so really only need GFP_NOFS allocation (fuse), while
> others work at the block device level (iscsi, nbd) so need GFP_NOIO
> allocation. So there's definitely an argument for providing both...

The main question is whether giving more APIs is really necessary. Is
there any real problem to give them only PF_IO_FLUSHER and let both
groups use this one? It will imply more reclaim restrictions for solely
FS based ones but is this a practical problem? If yes we can always add
PF_FS_$FOO later on.
-- 
Michal Hocko
SUSE Labs
