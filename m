From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11529] aacraid - WARNING: at lib/scatterlist.c
Date: Wed, 10 Sep 2008 05:44:31 -0700 (PDT)
Message-ID: <20080910124431.05EF911D10B@picon.linux-foundation.org>
References: <bug-11529-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbYIJMpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 08:45:02 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8ACiVGD022001
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2008 05:44:32 -0700
In-Reply-To: <bug-11529-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11529





------- Comment #2 from winfried@tilanus.com  2008-09-10 05:44 -------
The patch didn't apply, but adding the lines by hand worked. It solved most of
the warnings, but I am still left with two warnings at boottime:

[    5.237554] ------------[ cut here ]------------
[    5.237554] WARNING: at lib/scatterlist.c:316 sg_copy_buffer+0x2e/0x14f()
[    5.237554] Modules linked in: usbhid(+) hid ff_memless sd_mod ohci1394(+)
ata_piix(+) pata_marvell(+) aacraid ieee1394 libata scsi_mod dock ehci_hcd
uhci_hcd usbcore e1000e thermal processor fan thermal_sys
[    5.237554] Pid: 1025, comm: modprobe Not tainted 2.6.26.5-pristine-patched
#1
[    5.237554]  [<c01237c0>] warn_on_slowpath+0x40/0x79
[    5.237554]  [<c0118bfb>] kmap_atomic_prot+0xc9/0xff
[    5.237554]  [<c0118c42>] kmap_atomic+0x11/0x14
[    5.237554]  [<c0118b17>] kunmap_atomic+0x4b/0x66
[    5.237554]  [<c0158acf>] file_read_actor+0x75/0xc5
[    5.237554]  [<c01275a6>] current_fs_time+0x13/0x15
[    5.237554]  [<c018bfa6>] mnt_drop_write+0x1a/0xb4
[    5.237554]  [<c015ad90>] generic_file_aio_read+0x492/0x512
[    5.237554]  [<c01e9462>] sg_copy_buffer+0x2e/0x14f
[    5.237554]  [<c01e959c>] sg_copy_from_buffer+0xb/0xe
[    5.237554]  [<f8bb036a>] get_container_serial_callback+0x87/0xc4 [aacraid]
[    5.237554]  [<f8bb5d32>] aac_intr_normal+0x166/0x1a2 [aacraid]
[    5.237554]  [<f8bb696f>] aac_rx_intr_message+0x25/0x55 [aacraid]
[    5.237554]  [<c01545a7>] handle_IRQ_event+0x23/0x51
[    5.237554]  [<c01553b2>] handle_fasteoi_irq+0x71/0xa4
[    5.237554]  [<c0105f8b>] do_IRQ+0x4d/0x66
[    5.237554]  [<c010434b>] common_interrupt+0x23/0x28
[    5.237554]  =======================
[    5.237554] ---[ end trace d08418442dbc698b ]---

And:

[   17.985377] ------------[ cut here ]------------
[   17.985377] WARNING: at lib/scatterlist.c:316 sg_copy_buffer+0x2e/0x14f()
[   17.985377] Modules linked in: jfs nls_base dm_mirror dm_log dm_snapshot
dm_mod usb_storage sg sr_mod cdrom ide_pci_generic ide_core ata_generic ahci
usbhid hid ff_memless sd_mod ohci1394 ata_piix pata_marvell aacraid ieee1394
libata scsi_mod dock ehci_hcd uhci_hcd usbcore e1000e thermal processor fan
thermal_sys
[   17.985377] Pid: 1770, comm: udevd Tainted: G        W
2.6.26.5-pristine-patched #1
[   17.985377]  [<c01237c0>] warn_on_slowpath+0x40/0x79
[   17.985383]  [<c01877d5>] dput+0x16/0xdb
[   17.985383]  [<c0115fa7>] do_page_fault+0x362/0x7e7
[   17.985383]  [<c011600e>] do_page_fault+0x3c9/0x7e7
[   17.985383]  [<c018c08e>] mntput_no_expire+0x18/0xf3
[   17.985383]  [<c018c08e>] mntput_no_expire+0x18/0xf3
[   17.985383]  [<c025517d>] sys_sendto+0xfc/0x127
[   17.985383]  [<c01e9462>] sg_copy_buffer+0x2e/0x14f
[   17.985383]  [<c01befd1>] security_sk_alloc+0xd/0xf
[   17.985383]  [<c0256e6c>] sk_prot_alloc+0x36/0x83
[   17.985383]  [<c01e959c>] sg_copy_from_buffer+0xb/0xe
[   17.985383]  [<f8bb036a>] get_container_serial_callback+0x87/0xc4 [aacraid]
[   17.985383]  [<f8bb5d32>] aac_intr_normal+0x166/0x1a2 [aacraid]
[   17.985383]  [<f8bb696f>] aac_rx_intr_message+0x25/0x55 [aacraid]
[   17.985383]  [<c01545a7>] handle_IRQ_event+0x23/0x51
[   17.985383]  [<c01553b2>] handle_fasteoi_irq+0x71/0xa4
[   17.985383]  [<c0105f8b>] do_IRQ+0x4d/0x66
[   17.985383]  [<c010434b>] common_interrupt+0x23/0x28
[   17.985383]  [<c02c0000>] __reacquire_kernel_lock+0x1e/0x3d
[   17.985383]  =======================
[   17.985383] ---[ end trace d08418442dbc698b ]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
