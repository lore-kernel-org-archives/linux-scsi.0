From: Andrew Morton <akpm@osdl.org>
Subject: ugliness with USB hot-unplug
Date: Mon, 15 Nov 2004 21:28:58 -0800
Message-ID: <20041115212858.29d3c73d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:61830 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261824AbUKPF3N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 00:29:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


So I made the mistake of forgetting to unmount the fat filesytem before
unplugging the USB cable from the digital camera.  I then tried to unmount
the old mountpoint.  khubd is sitting there chewing 100% CPU and I have a
reboot in my near future.

And this:

SCSI device sdd: 31680 512-byte hdwr sectors (16 MB)
sdd: test WP failed, assume Write Enabled
sdd: assuming drive cache: write through
 sdd: sdd1
Attached scsi removable disk sdd at scsi3, channel 0, id 0, lun 0
usb-storage: device scan complete
usb 4-2: USB disconnect, address 2
 target3:0:0: Illegal state transition <NULL>->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713
 [<c0106acd>] dump_stack+0x19/0x20
 [<c026644a>] scsi_device_set_state+0xe2/0xf4
 [<c026126f>] scsi_device_cancel+0x1f/0x100
 [<c02613ef>] scsi_device_cancel_cb+0x17/0x1c
 [<c021f68e>] device_for_each_child+0x42/0x68
 [<c0261422>] scsi_host_cancel+0x2e/0xac
 [<c02614b5>] scsi_remove_host+0x15/0x68
 [<f88639c3>] storage_disconnect+0x77/0x8a [usb_storage]
 [<c027a33c>] usb_unbind_interface+0x3c/0x78
 [<c02203ff>] device_release_driver+0x57/0x6c
 [<c0220625>] bus_remove_device+0x51/0x98
 [<c021f608>] device_del+0x5c/0x84
 [<c02806eb>] usb_disable_device+0x67/0xe8
 [<c027c427>] usb_disconnect+0xc7/0x140
 [<c027d0f5>] hub_port_connect_change+0x71/0x338
 [<c027d5cc>] hub_events+0x210/0x2f4
 [<c027d6eb>] hub_thread+0x3b/0xf4
 [<c010428d>] kernel_thread_helper+0x5/0xc
scsi3 (0:0): rejecting I/O to dead device
FAT: Directory bread(block 7) failed
scsi3 (0:0): rejecting I/O to dead device
FAT: Directory bread(block 8) failed


The kernel profile points the finger at scsi_device_cancel():

00000000c0140c9c free_hot_cold_page                          290   1.1694
00000000c0145e5c release_pages                               366   0.9242
00000000c0149bb0 zap_pte_range                               508   0.7888
00000000c014b4e8 do_anonymous_page                          1338   3.8895
00000000c0117f04 do_page_fault                              1363   0.9361
00000000c0261250 scsi_device_cancel                        30137 117.7227
00000000c0104034 default_idle                              39011 750.2115


Seems to me that this is cruel and unusual punishment for simply forgetting
to type umount.  Any chance of getting it fixed up?

Thanks.
