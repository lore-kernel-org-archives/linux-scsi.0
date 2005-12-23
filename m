From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: More FC Transport Issues
Date: Fri, 23 Dec 2005 11:58:49 -0800
Message-ID: <20051223195849.GH1112@andrew-vasquezs-powerbook-g4-15.local>
References: <43AB36BC.8000003@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:5267 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1161015AbVLWT6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 14:58:55 -0500
Content-Disposition: inline
In-Reply-To: <43AB36BC.8000003@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@SGI.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@SGI.com>

On Thu, 22 Dec 2005, Michael Reed wrote:

> I then try rebooting the system again.  Discovery happens as expected
> at the time the driver initializes each card.  Then the system takes an
> OOPS.
> 
> It's possible the OOPS is related to the qla2xxx serialization issue I reported
> earlier.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113380446825841&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113458339109319&w=2
> 
> I tried a third time and got the same OOPS.  Repeatable.

It may be related, but, I'm trying to track down a very repepeatable
OOPS I'm getting during driver-unload time:

	Unable to handle kernel paging request at virtual address 6b6b6beb
	 printing eip:
	c01900c2
	*pde = 00000000
	Oops: 0002 [#1]
	SMP 
	Modules linked in: qla2xxx scsi_transport_fc
	CPU:    2
	EIP:    0060:[<c01900c2>]    Not tainted VLI
	EFLAGS: 00010282   (2.6.15-rc6) 
	EIP is at sysfs_hash_and_remove+0x31/0x11f
	eax: 00000000   ebx: 6b6b6b6b   ecx: 00000000   edx: ee6aac68
	esi: 6b6b6b6b   edi: f8839d44   ebp: f8839cc0   esp: c1af7e98
	ds: 007b   es: 007b   ss: 0068
	Process events/2 (pid: 16, threadinfo=c1af7000 task=c1aef030)
	Stack: c03998d2 00000063 eb6a0e2c eb6a0e24 f8839d44 f8839cc0 c025877b e640aac0 
	       ee000f5c ee000f5c 00000000 f8839cc0 f332e178 eb6a0e24 c025ab08 c025ab39 
	       eb6a0e24 c0370606 eb6a0e00 f332e178 c1af7f00 e5a872dc c025a722 f332e178 
	Call Trace:
	 [<c025877b>] class_device_del+0x138/0x163
	 [<c025ab08>] transport_remove_classdev+0x0/0x68
	 [<c025ab39>] transport_remove_classdev+0x31/0x68
	 [<c0370606>] klist_next+0x42/0x5c
	 [<c025a722>] attribute_container_device_trigger+0xcb/0xe2
	 [<c020524a>] kobject_put+0x1e/0x22
	 [<c025ab87>] transport_remove_device+0x17/0x1b
	 [<c025ab08>] transport_remove_classdev+0x0/0x68
	 [<c0294874>] scsi_target_reap_work+0xa4/0xbb
	 [<c012bcca>] worker_thread+0x1bf/0x24a
	 [<c02947d0>] scsi_target_reap_work+0x0/0xbb
	 [<c0117960>] default_wake_function+0x0/0x12
	 [<c0117960>] default_wake_function+0x0/0x12
	 [<c012bb0b>] worker_thread+0x0/0x24a
	 [<c0130021>] kthread+0xa3/0xcd
	 [<c012ff7e>] kthread+0x0/0xcd
	 [<c0101119>] kernel_thread_helper+0x5/0xb
	Code: 08 8b 44 24 1c 8b 58 18 8b 70 60 85 db 75 08 83 c4 08 5b 5e 5f 5d c3 c7 44 24 04 63 00 00 00 c7 04 24 d2 98 39 c0 e8 e7 93  
	 <6>ACPI: PCI interrupt for device 0000:03:01.0 disabled
	SysRq : Emergency Sync
	Emergency Sync complete

git bisect narrowed the bad commit as:

	http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=863a930a40eb7f2d18534c2c166b22582f5c6cfd

	commit 863a930a40eb7f2d18534c2c166b22582f5c6cfd
	tree d2f74a0351a09e184e124fd6ecf16e02ab768a0b
	parent 42e33148df38c60b99d984b76b302c64397ebe4c
	author James Bottomley <James.Bottomley@steeleye.com> 1134705703 -0800
	committer James Bottomley <jejb@mulgrave.(none)> 1134838088 -0600

	[SCSI] fix scsi_reap_target() device_del from atomic context

	scsi_reap_target() was desgined to be called from any context.
	However it must do a device_del() of the target device, which may only
	be called from user context.  Thus we have to reimplement
	scsi_reap_target() via a workqueue.

	Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

reverting the commit avoided the OOPS, still investigating...

--
av
