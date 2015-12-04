From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Fri, 04 Dec 2015 15:30:01 -0800
Message-ID: <1449271801.27077.25.camel@HansenPartnership.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576AbbLDXaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2015 18:30:04 -0500
In-Reply-To: <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>

On Wed, 2015-11-25 at 11:43 -0700, Vishal Verma wrote:
> Take the core badblocks implementation from md, and make it generally
> available. This follows the same style as kernel implementations of
> linked lists, rb-trees etc, where you can have a structure that can be
> embedded anywhere, and accessor functions to manipulate the data.
> 
> The only changes in this copy of the code are ones to generalize
> function/variable names from md-specific ones. Also add init and free
> functions.
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  block/Makefile            |   2 +-
>  block/badblocks.c         | 523 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/badblocks.h |  53 +++++
>  3 files changed, 577 insertions(+), 1 deletion(-)
>  create mode 100644 block/badblocks.c
>  create mode 100644 include/linux/badblocks.h
> 
> diff --git a/block/Makefile b/block/Makefile
> index 00ecc97..db5f622 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -8,7 +8,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-tag.o blk-sysfs.o \
>  			blk-iopoll.o blk-lib.o blk-mq.o blk-mq-tag.o \
>  			blk-mq-sysfs.o blk-mq-cpu.o blk-mq-cpumap.o ioctl.o \
>  			genhd.o scsi_ioctl.o partition-generic.o ioprio.o \
> -			partitions/
> +			badblocks.o partitions/
>  
>  obj-$(CONFIG_BOUNCE)	+= bounce.o
>  obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
> diff --git a/block/badblocks.c b/block/badblocks.c
> new file mode 100644
> index 0000000..6e07855
> --- /dev/null
> +++ b/block/badblocks.c
> @@ -0,0 +1,523 @@
> +/*
> + * Bad block management
> + *
> + * - Heavily based on MD badblocks code from Neil Brown
> + *
> + * Copyright (c) 2015, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/badblocks.h>
> +#include <linux/seqlock.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +
> +/*
> + * We can record which blocks on each device are 'bad' and so just
> + * fail those blocks, or that stripe, rather than the whole device.
> + * Entries in the bad-block table are 64bits wide.  This comprises:
> + * Length of bad-range, in sectors: 0-511 for lengths 1-512
> + * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
> + *  A 'shift' can be set so that larger blocks are tracked and
> + *  consequently larger devices can be covered.
> + * 'Acknowledged' flag - 1 bit. - the most significant bit.
> + *
> + * Locking of the bad-block table uses a seqlock so badblocks_check
> + * might need to retry if it is very unlucky.
> + * We will sometimes want to check for bad blocks in a bi_end_io function,
> + * so we use the write_seqlock_irq variant.
> + *
> + * When looking for a bad block we specify a range and want to
> + * know if any block in the range is bad.  So we binary-search
> + * to the last range that starts at-or-before the given endpoint,
> + * (or "before the sector after the target range")
> + * then see if it ends after the given start.
> + * We return
> + *  0 if there are no known bad blocks in the range
> + *  1 if there are known bad block which are all acknowledged
> + * -1 if there are bad blocks which have not yet been acknowledged in metadata.
> + * plus the start/length of the first bad section we overlap.
> + */

This comment should be docbook.

> +int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
> +			sector_t *first_bad, int *bad_sectors)
[...]
> +
> +/*
> + * Add a range of bad blocks to the table.
> + * This might extend the table, or might contract it
> + * if two adjacent ranges can be merged.
> + * We binary-search to find the 'insertion' point, then
> + * decide how best to handle it.
> + */

And this one, plus you don't document returns.  It looks like this
function returns 1 on success and zero on failure, which is really
counter-intuitive for the kernel: zero is usually returned on success
and negative error on failure.

> +int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +			int acknowledged)
[...]
> +
> +/*
> + * Remove a range of bad blocks from the table.
> + * This may involve extending the table if we spilt a region,
> + * but it must not fail.  So if the table becomes full, we just
> + * drop the remove request.
> + */

Docbook and document returns.  This time they're the kernel standard of
0 on success and negative error on failure making the convention for
badblocks_set even more counterintuitive.

> +int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +{
[...]
> +#define DO_DEBUG 1

Why have this at all if it's unconditionally defined and always set.

> +ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
> +			int unack)
[...]
> +int badblocks_init(struct badblocks *bb, int enable)
> +{
> +	bb->count = 0;
> +	if (enable)
> +		bb->shift = 0;
> +	else
> +		bb->shift = -1;
> +	bb->page = kmalloc(PAGE_SIZE, GFP_KERNEL);

Why not __get_free_page(GFP_KERNEL)?  The problem with kmalloc of an
exactly known page sized quantity is that the slab tracker for this
requires two contiguous pages for each page because of the overhead.

James


