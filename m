From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
	block/for-2.6.31 tree
Date: Wed, 20 May 2009 14:37:20 +0000
Message-ID: <1242830240.2881.10.camel@localhost.localdomain>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>
	 <20090520111619.87f815b1.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41255 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbZETOhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 10:37:17 -0400
In-Reply-To: <20090520111619.87f815b1.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On Wed, 2009-05-20 at 11:16 +1000, Stephen Rothwell wrote:
> On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> >
> > 
> > This patch should be squashed into
> >     [SCSI] FC Pass Thru support
> > 
> > If it needs to compile after Tejun's block-layer revamps
> > (all of them)
> 
> Is there some reason that the FC passthrough support (and any followup
> patches) can't be pushed through the block tree.  It clearly currently
> doesn't depend on anything new in the scsi tree ...

That would preserve the logical sequence of patches, yes.  However, Jens
is a bit pressed for time, so I agreed to do this in SCSI.

Unfortuantely, I still need the block tree for-next to be rebased up to
the current linus head because of a couple of conflicts:

CONFLICT (content): Merge conflict in drivers/block/hd.c
CONFLICT (content): Merge conflict in drivers/block/mg_disk.c

The are both just rebase/rebase conflicts:  it looks like there are two
commit ids for 

commit 0191944282e84931f92915b5f06b348a92dac7e1
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Apr 28 12:38:33 2009 +0900

    hd: fix locking

commit 7090a0a97f55cbf47547a140fcc5a349f32c598c
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Apr 28 12:38:33 2009 +0900

    mg_disk: fix CONFIG_LBD=y warning
 
commit ac2ff946a53e7bd0ae98f4e5d1d6c1b1dced82e5
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Apr 28 12:38:32 2009 +0900

    mg_disk: fix locking

 
So they obviously moved into linus head but wasn't taken out of block
for-next.

James


