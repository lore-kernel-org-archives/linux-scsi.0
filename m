From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Wed, 9 Feb 2005 15:03:50 -0800
Message-ID: <20050209230350.GA10297@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C1FD1D9@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:41852 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261963AbVBIXDa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 18:03:30 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C1FD1D9@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Wed, 09 Feb 2005, James.Smart@Emulex.Com wrote:

> > seems like sdev->shost is bogus when fc_remote_port_block() is
> > called...
> 
> We haven't seen this in our testing....
> 

Actually it's not the sdev->host that's bogus -- it appears the sdev
is referenced after it's been freed -- a reference still present in
the shost->__devices list.  Here's the scenario:

* 1 lun connected to HBA1 -- sdev created for the lun via rport:

	*** sdev=d76196e8 host=d36f0000 state=2 gdev=d761987c

* mid-layer performs linear scan of non-existent ID's (via
scsi_sysfs_target_initialize():

	*** adding sdev=dd2bc738 sdev->siblings=dd2bc740, __dev=d36f0000 id=1 emp=0
	...
	*** adding sdev=dd2bc738 sdev->siblings=dd2bc740, __dev=d36f0000 id=509 emp=0
	*** adding sdev=dd2bc738 sdev->siblings=dd2bc740, __dev=d36f0000 id=510 emp=0
	*** adding sdev=dd2bc738 sdev->siblings=dd2bc740, __dev=d36f0000 id=511 emp=0

* remove lun from the fabric (port-side cable pull).

* driver recognizes loss via RSCN, issues fc_remote_port_block(),
  starget_for_each_device() -> shost_for_each_device() ->
  __scsi_iterate_devices() where scsi_device_get() is called for
  reference.

  1st sdev valid (ok):

	*** ctr=0 sdev=d76196e8 host=d36f0000 state=2 gdev=d761987c id=0
	*** sdev=d76196e8 host=d36f0000 state=2 gdev=d761987c

  2nd sdev invalid -- note old sdev (dd2bc738) from previous linear
  scan:

	*** ctr=0 sdev=dd2bc738 host=6b6b6b6b state=1802201963 gdev=dd2bc8cc id=1802201963
	*** sdev=dd2bc738 host=6b6b6b6b state=1802201963 gdev=dd2bc8cc

  [BLAH]

	Unable to handle kernel paging request at virtual address 6b6b6be7
	 printing eip:
	c028ef06
	*pde = 00000000
	Oops: 0000 [#1]
	SMP
	Modules linked in: qla2322 qla2xxx
	CPU:    0
	EIP:    0060:[<c028ef06>]    Not tainted VLI
	EFLAGS: 00010086   (2.6.11-rport)
	EIP is at scsi_device_get+0x56/0xa0
	eax: 6b6b6b6b   ebx: dd2bc738   ecx: c035f844   edx: fffffffa
	esi: dd2bc8cc   edi: d36f0000   ebp: 00000001   esp: df693dd4
	ds: 007b   es: 007b   ss: 0068
	Process qla2322_1_dpc (pid: 11316, threadinfo=df692000 task=d9fa8530)
	Stack: c0341fcc dd2bc738 6b6b6b6b 6b6b6b6b dd2bc8cc dd2bc738 d76196f0 c028f011
	       c0341ff4 00000000 dd2bc738 6b6b6b6b 6b6b6b6b dd2bc8cc 6b6b6b6b 00000282
	       d76196e8 d76196e8 ddd7e790 d36f0000 c029af50 c028f0bd 00000000 dbe8512c
	Cale Trace:
	 [<c028f011>] __scsi_iterate_devices+0x71/0xb0
	 [<c029af50>] fc_device_block+0x0/0x10
	 [<c028f0bd>] starget_for_each_device+0x6d/0x80
	 [<c029afff>] fc_remote_port_block+0x3f/0x70
	 [<e08633d3>] qla2x00_mark_device_lost+0x53/0xe0 [qla2xxx]

signature very consistent.


Another quirk when run with no storage connected to HBAs and the
driver is loaded, then unloaded -- is a consistent BUG() hit in
_raw_spin_lock() via scsi_forget_host():

	kernel BUG at include/asm/spinlock.h:149!
	invalid operand: 0000 [#1]
	SMP
	Modules linked in: qla2322 qla2xxx
	CPU:    1
	EIP:    0060:[<c030b373>]    Not tainted VLI
	EFLAGS: 00010096   (2.6.11-rport)
	EIP is at _spin_lock_irqsave+0x53/0x60
	eax: 0000000e   ebx: 00000282   ecx: c035f80c   edx: 00000082
	esi: 6b6b6bab   edi: d86f1ecc   ebp: d348d530   esp: d86f1ea4
	ds: 007b   es: 007b   ss: 0068
	Process rmmod (pid: 11209, threadinfo=d86f0000 task=d348d530)
	Stack: c031e548 c030960c 6b6b6ba3 6b6b6bab c030960c 00000000 d348d530 c0117610
	       00000000 00000000 0000006b d3920000 6b6b6b6b da0c3b74 d3920000 6b6b6b6b
	       d86f0000 c03097d3 d392002c 0000006b c0297656 6b6b6b63 d3920000 6b6b6b63
	Call Trace:
	 [<c030960c>] __down+0x3c/0xe0
	 [<c030960c>] __down+0x3c/0xe0
	 [<c0117610>] default_wake_function+0x0/0x10
	 [<c03097d3>] __down_failed+0x7/0xc
	 [<c0297656>] .text.lock.scsi_sysfs+0x8/0x22
	 [<c0296061>] scsi_forget_host+0x31/0x60
	 [<c028f3e1>] scsi_remove_host+0x11/0x60
	 [<e08629df>] qla2x00_remove_one+0x1f/0x40 [qla2xxx]
	 [<c01f9108>] pci_device_remove+0x28/0x30
	 [<c024cc04>] device_release_driver+0x74/0x80
	 [<c024cc28>] driver_detach+0x18/0x30
	 [<c024d13c>] bus_remove_driver+0x5c/0xa0
	 [<c024d6c8>] driver_unregister+0x8/0x30
	 [<c01f933b>] pci_unregister_driver+0xb/0x20
	 [<c013279e>] sys_delete_module+0x16e/0x190
	 [<c014b61a>] unmap_vma_list+0x1a/0x30
	 [<c014b9c5>] do_munmap+0x115/0x160
	 [<c014ba5a>] sys_munmap+0x4a/0x70
	 [<c010308d>] sysenter_past_esp+0x52/0x75
	Code: 90 80 3e 00 7e f9 fa eb e8 89 d8 8b 74 24 0c 8b 5c 24 08 83 c4 10 c3 c7 04 24 48 e5 31 c0 8b 44

host variable seems to be hosed.  Perhaps I'm doing something wrong
during shutdown -- just the standard scsi_remove_host(), I also tried
to add the fc_remove_host() call (as per directed in comments) but
same results occured...

Andrew Vasquez
