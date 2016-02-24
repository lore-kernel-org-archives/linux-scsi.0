From: John David Anglin <dave.anglin@bell.net>
Subject: [BUG] "block: make generic_make_request handle arbitrarily sized bios" breaks boot on parisc-linux
Date: Tue, 23 Feb 2016 21:28:22 -0500
Message-ID: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-parisc List <linux-parisc@vger.kernel.org>, kent.overstreet@gmail.com
List-Id: linux-scsi@vger.kernel.org

The following block change breaks boot on parisc-linux:

commit 54efd50bfd873e2dbf784e0b21a8027ba4299a3e
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Thu Apr 23 22:37:18 2015 -0700

   block: make generic_make_request handle arbitrarily sized bios

   The way the block layer is currently written, it goes to great lengths
   to avoid having to split bios; upper layer code (such as bio_add_page())
   checks what the underlying device can handle and tries to always create
   bios that don't need to be split.

   But this approach becomes unwieldy and eventually breaks down with
   stacked devices and devices with dynamic limits, and it adds a lot of
   complexity. If the block layer could split bios as needed, we could
   eliminate a lot of complexity elsewhere - particularly in stacked
   drivers. Code that creates bios can then create whatever size bios are
   convenient, and more importantly stacked drivers don't have to deal with
   both their own bio size limitations and the limitations of the
   (potentially multiple) devices underneath them.  In the future this will
   let us delete merge_bvec_fn and a bunch of other code.

   We do this by adding calls to blk_queue_split() to the various
   make_request functions that need it - a few can already handle arbitrary
   size bios. Note that we add the call _after_ any call to
   blk_queue_bounce(); this means that blk_queue_split() and
   blk_recalc_rq_segments() don't need to be concerned with bouncing
   affecting segment merging.

   Some make_request_fn() callbacks were simple enough to audit and verify
   they don't need blk_queue_split() calls. The skipped ones are:

    * nfhd_make_request (arch/m68k/emu/nfblock.c)
    * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
    * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
    * brd_make_request (ramdisk - drivers/block/brd.c)
    * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
    * loop_make_request
    * null_queue_bio
    * bcache's make_request fns

   Some others are almost certainly safe to remove now, but will be left
   for future patches.

   Cc: Jens Axboe <axboe@kernel.dk>
   Cc: Christoph Hellwig <hch@infradead.org>
   Cc: Al Viro <viro@zeniv.linux.org.uk>
   Cc: Ming Lei <ming.lei@canonical.com>
   Cc: Neil Brown <neilb@suse.de>
   Cc: Alasdair Kergon <agk@redhat.com>
   Cc: Mike Snitzer <snitzer@redhat.com>
   Cc: dm-devel@redhat.com
   Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
   Cc: drbd-user@lists.linbit.com
   Cc: Jiri Kosina <jkosina@suse.cz>
   Cc: Geoff Levand <geoff@infradead.org>
   Cc: Jim Paris <jim@jtan.com>
   Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
   Cc: Minchan Kim <minchan@kernel.org>
   Cc: Nitin Gupta <ngupta@vflare.org>
   Cc: Oleg Drokin <oleg.drokin@intel.com>
   Cc: Andreas Dilger <andreas.dilger@intel.com>
   Acked-by: NeilBrown <neilb@suse.de> (for the 'md/md.c' bits)
   Acked-by: Mike Snitzer <snitzer@redhat.com>
   Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
   Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
   [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
   Signed-off-by: Dongsu Park <dpark@posteo.net>
   Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
   Signed-off-by: Jens Axboe <axboe@fb.com>

This thread on the linux-parisc has most of the discussion and analysis:
http://www.spinics.net/lists/linux-parisc/msg06710.html

Essentially, the SCSI layer underestimates the number of sg segments needed and we run off the end of the sg list and crash.
This happens because the protect bit is ignored.  As a result 4.3 and later kernels fail to boot.  This includes the current Debian
kernel for hppa.

Hopefully, the block group can help resolve this issue.  We can help with testing if needed.

Thanks,
Dave Anglin
--
John David Anglin	dave.anglin@bell.net



