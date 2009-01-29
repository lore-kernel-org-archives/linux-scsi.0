From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: re: slab error in verify_redzone_free() badness...
Date: Thu, 29 Jan 2009 14:55:32 -0800
Message-ID: <20090129225532.GA37589@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:55768 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZA2Wze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 17:55:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

Matthew,

During some NPIV regression tests with .29-rc3, we are seeing some
slab-corruption during vport tear-down:

	# create vport off fc-host1
	$ echo "2001567890abcdab:2001ef12345678ab" > /sys/class/fc_host/host1/vport_create
	# delete vport
	$ echo "2001567890abcdab:2001ef12345678ab" > /sys/class/fc_host/host1/vport_delete

Here's the backtrace:

	[  263.337035] slab error in verify_redzone_free(): cache `size-2048': memory outside object was overwritten
	[  263.340213] Pid: 7623, comm: bash Tainted: G   M       2.6.28 #32
	[  263.340213] Call Trace:
	[  263.340213]  [<ffffffff8027afd7>] __slab_error+0x1c/0x25
	[  263.340213]  [<ffffffff8027b43b>] cache_free_debugcheck+0x165/0x210
	[  263.340213]  [<ffffffff8027b672>] kfree+0x6b/0xc3
	[  263.340213]  [<ffffffff803947bb>] device_release+0x1a/0x6a
	[  263.340213]  [<ffffffff8032db9c>] kobject_release+0x33/0x63
	[  263.340213]  [<ffffffff8032db69>] kobject_release+0x0/0x63
	[  263.340213]  [<ffffffff8032e98e>] kref_put+0x32/0x6c
	[  263.340213]  [<ffffffffa002b73b>] qla24xx_vport_delete+0xc7/0x14f [qla2xxx]
	[  263.340213]  [<ffffffffa000061c>] fc_vport_terminate+0x81/0x1bb [scsi_transport_fc]
	[  263.340213]  [<ffffffffa0002a67>] store_fc_host_vport_delete+0x111/0x121 [scsi_transport_fc]
	[  263.340213]  [<ffffffff802bebea>] sysfs_write_file+0xb3/0x114
	[  263.340213]  [<ffffffff802803a3>] vfs_write+0xac/0x147
	[  263.340213]  [<ffffffff80280921>] sys_write+0x45/0x73
	[  263.340213]  [<ffffffff8020b45b>] system_call_fastpath+0x16/0x1b
	[  263.340213] ffff88007ddaad98: redzone 1:0xd84156c5635688c0, redzone 2:0x0.

We've bisected the problem down to:

	commit 210272a28465a7a31bcd580d2f9529f924965aa5
	Author: Matthew Wilcox <matthew@wil.cx>
	Date:   Thu Oct 16 14:57:54 2008 -0600

	    driver core: Remove completion from struct klist_node

	    Removing the completion from klist_node reduces its size from 64 bytes
	    to 28 on x86-64.  To maintain the semantics of klist_remove(), we add
	    a single list of klist nodes which are pending deletion and scan them.

	    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
	    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

At first glance the changes look fairly straight-forward...  Reverting
the problem commit (currently off .29-rc3) appears to clean up the
slab-badness.

Thoughts?

--
av
