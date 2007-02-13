From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 7994] New: sleeping function called from invalid context
 at mm/slab.c:3034
Date: Mon, 12 Feb 2007 20:06:20 -0800
Message-ID: <20070212200620.7320b3be.akpm@linux-foundation.org>
References: <200702130307.l1D378vc003798@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXBMEHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Feb 2007 23:07:03 -0500
In-Reply-To: <200702130307.l1D378vc003798@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, adrakoa@es.gnu.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Mon, 12 Feb 2007 19:07:08 -0800 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7994
> 
>            Summary: sleeping function called from invalid context at
>                     mm/slab.c:3034
>     Kernel Version: 2.6.20
>             Status: NEW
>           Severity: low
>              Owner: akpm@osdl.org
>          Submitter: adrakoa@es.gnu.org
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.19
> Distribution: Debian Sid
> Linux version 2.6.20 (root@kundalini) (gcc version 4.1.2 20061115 (prerelease)
> (Debian 4.1.1-21)) 
> 
> it happens two times at the startup. The machines works without sensible
> consequences.
> Javi.
> 
> Feb 12 15:54:43 kundalini vmunix: ACPI: (supports S0 S1 S3 S4 S5)
> Feb 12 15:54:43 kundalini vmunix: Freeing unused kernel memory: 212k freed
> Feb 12 15:54:43 kundalini vmunix: Time: tsc clocksource has been installed.
> Feb 12 15:54:43 kundalini vmunix: Time: acpi_pm clocksource has been installed.
> Feb 12 15:54:43 kundalini vmunix: BUG: sleeping function called from invalid
> context at mm/slab.c:3034
> Feb 12 15:54:43 kundalini vmunix: in_atomic():1, irqs_disabled():1
> Feb 12 15:54:43 kundalini vmunix:  [<c0152760>] kmem_cache_zalloc+0x1b/0x73
> Feb 12 15:54:43 kundalini vmunix:  [<c02e9aee>] resp_inquiry+0x2f/0x85e
> Feb 12 15:54:43 kundalini vmunix:  [<c02ea791>] scsi_debug_queuecommand+0x2ec/0x1036
> Feb 12 15:54:43 kundalini vmunix:  [<c02d2f81>] scsi_done+0x0/0x16
> Feb 12 15:54:43 kundalini vmunix:  [<c01523da>] cache_alloc_refill+0x174/0x468
> Feb 12 15:54:43 kundalini vmunix:  [<c02d77fe>] scsi_init_io+0x61/0xcb
> Feb 12 15:54:43 kundalini vmunix:  [<c02d794e>] scsi_prep_fn+0xe6/0x222
> Feb 12 15:54:43 kundalini vmunix:  [<c0121c42>] lock_timer_base+0x1d/0x4d
> Feb 12 15:54:43 kundalini vmunix:  [<c0121d63>] __mod_timer+0x95/0xb0
> Feb 12 15:54:43 kundalini vmunix:  [<c02d3732>] scsi_dispatch_cmd+0x1be/0x24d
> Feb 12 15:54:43 kundalini vmunix:  [<c02d875e>] scsi_request_fn+0x298/0x373
> Feb 12 15:54:43 kundalini vmunix:  [<c023b6d6>] blk_remove_plug+0x4e/0x5a
> Feb 12 15:54:43 kundalini vmunix:  [<c023905b>] elv_insert+0x67/0x143
> Feb 12 15:54:43 kundalini vmunix:  [<c023b775>] blk_execute_rq_nowait+0x74/0xa6
> Feb 12 15:54:43 kundalini vmunix:  [<c023b820>] blk_execute_rq+0x79/0x93
> Feb 12 15:54:43 kundalini vmunix:  [<c023ad65>] blk_end_sync_rq+0x0/0x23
> Feb 12 15:54:43 kundalini vmunix:  [<c0175950>] bio_phys_segments+0xe/0x14
> Feb 12 15:54:43 kundalini vmunix:  [<c0239f36>] blk_rq_bio_prep+0x28/0x85
> Feb 12 15:54:43 kundalini vmunix:  [<c023af59>] blk_rq_map_user+0x113/0x1c1
> Feb 12 15:54:43 kundalini vmunix:  [<c023e71f>] sg_io+0x256/0x355
> Feb 12 15:54:43 kundalini vmunix:  [<c0149241>] find_mergeable_anon_vma+0x5e/0xb1
> Feb 12 15:54:43 kundalini vmunix:  [<c023ec6a>] scsi_cmd_ioctl+0x1af/0x369
> Feb 12 15:54:43 kundalini vmunix:  [<c01158c4>] do_page_fault+0x0/0x53c
> Feb 12 15:54:43 kundalini vmunix:  [<c0164d07>] __d_lookup+0x120/0x13d
> Feb 12 15:54:43 kundalini vmunix:  [<c015c06d>] do_lookup+0x4f/0x140
> Feb 12 15:54:43 kundalini vmunix:  [<c02e05fc>] sd_ioctl+0x94/0xb9
> Feb 12 15:54:43 kundalini vmunix:  [<c024393d>] _atomic_dec_and_lock+0x25/0x40
> Feb 12 15:54:43 kundalini vmunix:  [<c023d126>] blkdev_driver_ioctl+0x4e/0x5e
> Feb 12 15:54:43 kundalini vmunix:  [<c023d787>] blkdev_ioctl+0x651/0x69e
> Feb 12 15:54:43 kundalini vmunix:  [<c0244191>] kobject_get+0xf/0x13
> Feb 12 15:54:43 kundalini vmunix:  [<c0244191>] kobject_get+0xf/0x13
> Feb 12 15:54:43 kundalini vmunix:  [<c02c4c7e>] class_device_get+0xe/0x14
> Feb 12 15:54:43 kundalini vmunix:  [<c02e03d1>] sd_open+0x6d/0x117
> Feb 12 15:54:43 kundalini vmunix:  [<c0166e08>] iget5_locked+0xe4/0x193
> Feb 12 15:54:43 kundalini vmunix:  [<c0176844>] do_open+0x1d3/0x252
> Feb 12 15:54:43 kundalini vmunix:  [<c0176669>] bdget+0x100/0x108
> Feb 12 15:54:43 kundalini vmunix:  [<c0176a6d>] blkdev_open+0x0/0x4d
> Feb 12 15:54:43 kundalini vmunix:  [<c0176a92>] blkdev_open+0x25/0x4d
> Feb 12 15:54:43 kundalini vmunix:  [<c0154391>] __dentry_open+0x123/0x1b7
> Feb 12 15:54:43 kundalini vmunix:  [<c015449f>] nameidata_to_filp+0x24/0x33
> Feb 12 15:54:43 kundalini vmunix:  [<c01544e5>] do_filp_open+0x37/0x3e
> Feb 12 15:54:43 kundalini vmunix:  [<c0176111>] block_ioctl+0x18/0x1b
> Feb 12 15:54:43 kundalini vmunix:  [<c01760f9>] block_ioctl+0x0/0x1b
> Feb 12 15:54:43 kundalini vmunix:  [<c016025f>] do_ioctl+0x1f/0x63
> Feb 12 15:54:43 kundalini vmunix:  [<c01604ed>] vfs_ioctl+0x24a/0x25d
> Feb 12 15:54:43 kundalini vmunix:  [<c016054c>] sys_ioctl+0x4c/0x64
> Feb 12 15:54:43 kundalini vmunix:  [<c0102dc0>] syscall_call+0x7/0xb
> Feb 12 15:54:43 kundalini vmunix:  [<c03b0000>] ieee80211_xmit+0x672/0xabd

This is fixed in mainline and I expect that the fix is also lined up for
2.6.20.1. (?)
