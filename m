From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/6] Create ida helpers and use them
Date: Sun,  6 Sep 2015 10:59:28 -0700
Message-ID: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbbIFR7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 13:59:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

As pointed out by Christoph Hellwig, many of the users
of the ida index routines call them with the same calling
pattern, so why not make some helper functions to help
clean up and simplify the code a bit.

After looking at all the uses of the ida routines, I
noticed that most of clients of this API used the
same sequence -- but not all of them. So I picked
the most common and seemingly most correct sequence,
and I made inline helper functions for that, creating:

 - ida_get_index() -- get an 'ida' index, with proper
   locking and retry
   
 - ida_put_index() -- release/return an index allocated
   by ida_get_index(), with proper locking

I converted the following drivers to use the new helper
routines, because they matched the calling sequence
used by the helper functions:

  scsi/sd.c                     SCSI disk
  base/soc.c                    sound?
  block/mtip32xxx/mtip32xx.c    PCI block?
  block/nvme-core.c             Intel SSD?
  block/rsxx/core.c             IBM Flash?

Obviously, only one of these is a SCSI driver, so
I hope this is still the right place to post this.

NOTE 1: the soc.c driver actually had normal locking
around it's 'get' call, but it had no locking around
it's 'put' (release) calls, so since the helper routines
have locking, that means the soc.c driver now has
locking when it releases an index.

There were other drivers that used ida in a way
that meant I could not easily modify them:

  drivers/iommu/iommu.c:
    - uses unlikely(...)
    - uses a mutex instead of spinlock

  drivers/misc/cb710/core.c:
    - calls return from within the 'get' while loop
    - uses spin_lock_irq*()

  drivers/scsi/osd/osd_uld.c:
    - uses no locking at all for indexes [See NOTE 2]

  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
    - uses 'unlikely()' in 'get' while loop
    - uses 'goto's out of 'get' while loop

NOTE 2: Not sure if this is a bug in the osd code, since
I did not look at it very closely.

The only client driver changes I was able to functionally
test where the sd.c changes. I also tested the helper
functions using the hosts.c module, where they worked
fine, but those changes were later reverted in favor of
using idr there instead. (See previous patch series.)

Lee Duncan (6):
  Add ida helper routines
  SCSI: Update sd driver to use new ida helper functions.
  Update soc driver to use new ida helper functions.
  Update soc driver to use new ida helper functions.
  Update nvme-core driver to use new ida helper functions.
  Update rsxx core driver to use new ida helper functions.

 drivers/base/soc.c                | 17 +++-------------
 drivers/block/mtip32xx/mtip32xx.c | 22 ++++----------------
 drivers/block/nvme-core.c         | 14 ++-----------
 drivers/block/rsxx/core.c         | 16 ++-------------
 drivers/scsi/sd.c                 | 18 +++--------------
 include/linux/idr.h               | 42 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 73 deletions(-)

-- 
2.1.4

