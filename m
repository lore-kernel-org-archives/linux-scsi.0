From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 02/13] block: Use accessor functions for queue limits
Date: Sun, 31 May 2009 17:51:37 +0200
Message-ID: <200905311751.37898.bzolnier@gmail.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56224 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZEaP4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2009 11:56:11 -0400
In-Reply-To: <1242362435-11953-3-git-send-email-martin.petersen@oracle.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org


Hi Martin,

On Friday 15 May 2009 06:40:24 Martin K. Petersen wrote:
> From: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Convert all external users of queue limits to using wrapper functions
> instead of poking the request queue variables directly.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c

[...]

> @@ -914,13 +914,13 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
>  	 * restrictions.
>  	 */
>  	blk_queue_max_sectors(q, t->limits.max_sectors);
> -	q->max_phys_segments = t->limits.max_phys_segments;
> -	q->max_hw_segments = t->limits.max_hw_segments;
> -	q->logical_block_size = t->limits.logical_block_size;
> -	q->max_segment_size = t->limits.max_segment_size;
> -	q->max_hw_sectors = t->limits.max_hw_sectors;
> -	q->seg_boundary_mask = t->limits.seg_boundary_mask;
> -	q->bounce_pfn = t->limits.bounce_pfn;
> +	blk_queue_max_phys_segments(q, t->limits.max_phys_segments);
> +	blk_queue_max_hw_segments(q, t->limits.max_hw_segments);
> +	blk_queue_logical_block_size(q, t->limits.logical_block_size);
> +	blk_queue_max_segment_size(q, t->limits.max_segment_size);
> +	blk_queue_max_hw_sectors(q, t->limits.max_hw_sectors);
> +	blk_queue_segment_boundary(q, t->limits.seg_boundary_mask);
> +	blk_queue_bounce_limit(q, t->limits.bounce_pfn);

This chunk triggers a following warning on one of my systems:

BUG: sleeping function called from invalid context at mm/page_alloc.c:1482
in_atomic(): 1, irqs_disabled(): 0, pid: 3584, name: cryptsetup
2 locks held by cryptsetup/3584:
 #0:  (&md->suspend_lock){+.+.+.}, at: [<c0307810>] dm_swap_table+0x21/0x132
 #1:  (&md->map_lock){+++++.}, at: [<c03078ef>] dm_swap_table+0x100/0x132
Pid: 3584, comm: cryptsetup Not tainted 2.6.30-rc7-next-20090529-06589-g7701864-dirty #8
Call Trace:
 [<c0145d06>] ? __debug_show_held_locks+0x1e/0x20
 [<c012182a>] __might_sleep+0xfb/0x102
 [<c0161bac>] __alloc_pages_internal+0x62/0x388
 [<c015ea59>] mempool_alloc_pages+0x1b/0x21
 [<c0175997>] mempool_alloc_pages_isa+0xb/0x10
 [<c015ee59>] mempool_create_node+0x92/0xcc
 [<c015ea34>] ? mempool_free_pages+0x0/0xa
 [<c017598c>] ? mempool_alloc_pages_isa+0x0/0x10
 [<c015eea0>] mempool_create+0xd/0x11
 [<c017596c>] init_emergency_isa_pool+0x22/0x42
 [<c0221e26>] blk_queue_bounce_limit+0x2c/0x41
 [<c0309813>] dm_table_set_restrictions+0x76/0x9b
 [<c0307906>] dm_swap_table+0x117/0x132
 [<c030be21>] dev_suspend+0xef/0x15a
 [<c030c66d>] dm_ctl_ioctl+0x18e/0x1cd
 [<c030bd32>] ? dev_suspend+0x0/0x15a
 [<c030c4df>] ? dm_ctl_ioctl+0x0/0x1cd
 [<c018a433>] vfs_ioctl+0x22/0x69
 [<c018a8fd>] do_vfs_ioctl+0x483/0x4bd
 [<c01921da>] ? mntput_no_expire+0x19/0xb4
 [<c0180b0a>] ? __fput+0x185/0x18d
 [<c01029fb>] ? sysenter_exit+0xf/0x18
 [<c018a963>] sys_ioctl+0x2c/0x45
 [<c01029c8>] sysenter_do_call+0x12/0x36
