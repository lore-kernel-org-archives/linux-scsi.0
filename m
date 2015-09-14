From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/6] Create ida helpers and use them
Date: Mon, 14 Sep 2015 13:11:21 +0200
Message-ID: <mqdpp1ldzmu.fsf@c203.arch.suse.de>
References: <cover.1441416571.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbINLLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2015 07:11:23 -0400
In-Reply-To: <cover.1441416571.git.lduncan@suse.com> (Lee Duncan's message of
	"Sun, 6 Sep 2015 10:59:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, hare@suse.com, JBottomley@Parallels.com

Lee Duncan <lduncan@suse.com> writes:

> As pointed out by Christoph Hellwig, many of the users
> of the ida index routines call them with the same calling
> pattern, so why not make some helper functions to help
> clean up and simplify the code a bit.
>
> After looking at all the uses of the ida routines, I
> noticed that most of clients of this API used the
> same sequence -- but not all of them. So I picked
> the most common and seemingly most correct sequence,
> and I made inline helper functions for that, creating:
>
>  - ida_get_index() -- get an 'ida' index, with proper
>    locking and retry
>   =20
>  - ida_put_index() -- release/return an index allocated
>    by ida_get_index(), with proper locking
>
> I converted the following drivers to use the new helper
> routines, because they matched the calling sequence
> used by the helper functions:
>
>   scsi/sd.c                     SCSI disk
>   base/soc.c                    sound?
>   block/mtip32xxx/mtip32xx.c    PCI block?
>   block/nvme-core.c             Intel SSD?
>   block/rsxx/core.c             IBM Flash?
>
> Obviously, only one of these is a SCSI driver, so
> I hope this is still the right place to post this.

I think drawing this to attention of a wider audience (i.e. add lkml to
Cc) would be a good idea.


Other than that, I'm OK with it.

>
> NOTE 1: the soc.c driver actually had normal locking
> around it's 'get' call, but it had no locking around
> it's 'put' (release) calls, so since the helper routines
> have locking, that means the soc.c driver now has
> locking when it releases an index.
>
> There were other drivers that used ida in a way
> that meant I could not easily modify them:
>
>   drivers/iommu/iommu.c:
>     - uses unlikely(...)
>     - uses a mutex instead of spinlock
>
>   drivers/misc/cb710/core.c:
>     - calls return from within the 'get' while loop
>     - uses spin_lock_irq*()
>
>   drivers/scsi/osd/osd_uld.c:
>     - uses no locking at all for indexes [See NOTE 2]
>
>   drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
>     - uses 'unlikely()' in 'get' while loop
>     - uses 'goto's out of 'get' while loop
>

Regarding the above, maybe Cc the maintainers of said drivers to the
cover letter, so they can comment on the IDA usage.


> NOTE 2: Not sure if this is a bug in the osd code, since
> I did not look at it very closely.
>
> The only client driver changes I was able to functionally
> test where the sd.c changes. I also tested the helper
> functions using the hosts.c module, where they worked
> fine, but those changes were later reverted in favor of
> using idr there instead. (See previous patch series.)
>
> Lee Duncan (6):
>   Add ida helper routines
>   SCSI: Update sd driver to use new ida helper functions.
>   Update soc driver to use new ida helper functions.
>   Update soc driver to use new ida helper functions.
>   Update nvme-core driver to use new ida helper functions.
>   Update rsxx core driver to use new ida helper functions.
>
>  drivers/base/soc.c                | 17 +++-------------
>  drivers/block/mtip32xx/mtip32xx.c | 22 ++++----------------
>  drivers/block/nvme-core.c         | 14 ++-----------
>  drivers/block/rsxx/core.c         | 16 ++-------------
>  drivers/scsi/sd.c                 | 18 +++--------------
>  include/linux/idr.h               | 42 +++++++++++++++++++++++++++++=
++++++++++
>  6 files changed, 56 insertions(+), 73 deletions(-)

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
