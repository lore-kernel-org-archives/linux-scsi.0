From: Carlos Morgado <chbm@cprm.net>
Subject: slab error in kmem_cache_destroy - rmmod qla1280 3.24.4
Date: Tue, 24 Aug 2004 12:22:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824112247.GA31252@cprm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avalon.cprm.net ([195.8.0.51]:11527 "EHLO avalon.cprm.net")
	by vger.kernel.org with ESMTP id S267495AbUHXLWu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 07:22:50 -0400
Received: from whisky.cprm.net (whisky.cprm.net [195.8.0.39])
	by avalon.cprm.net (8.9.3p3/8.9.3) with ESMTP id MAA04609
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2004 12:22:47 +0100 (WET DST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,
rmmod qla1280 yelded:

Aug 24 12:59:31 box kernel: slab error in kmem_cache_destroy(): cache csi_cmd_cache': Can't free all objects
Aug 24 12:59:31 box kernel:  [<c013761b>] kmem_cache_destroy+0x9b/0x120
Aug 24 12:59:31 box kernel:  [<c027c0cc>] scsi_destroy_command_freelist+0x6c/0xa0
Aug 24 12:59:31 box kernel:  [<c027cdb2>] scsi_host_dev_release+0x32/0x90
Aug 24 12:59:31 box kernel:  [<c0249f0b>] device_release+0x5b/0x60
Aug 24 12:59:31 box kernel:  [<d48d3c40>] qla1280_remove_one+0xb0/0xc0 [qla1280]
Aug 24 12:59:31 box kernel:  [<c0208618>] kobject_cleanup+0x98/0xa0
Aug 24 12:59:31 box kernel:  [<c020fdeb>] pci_device_remove+0x3b/0x40
Aug 24 12:59:31 box kernel:  [<c024b336>] device_release_driver+0x66/0x70
Aug 24 12:59:31 box kernel:  [<c024b36b>] driver_detach+0x2b/0x40
Aug 24 12:59:31 box kernel:  [<c024b8a1>] bus_remove_driver+0x71/0xb0
Aug 24 12:59:31 box kernel:  [<c024be0a>] driver_unregister+0x1a/0x50
Aug 24 12:59:31 box kernel:  [<c0210056>] pci_unregister_driver+0x16/0x30
Aug 24 12:59:31 box kernel:  [<d48d3c5f>] qla1280_exit+0xf/0x11 [qla1280]
Aug 24 12:59:31 box kernel:  [<c012bf39>] sys_delete_module+0x169/0x1d0
Aug 24 12:59:31 box kernel:  [<c0140313>] do_munmap+0x133/0x180
Aug 24 12:59:31 box kernel:  [<c0105bad>] sysenter_past_esp+0x52/0x71

modprobe qla1280 afterwards caused:

Aug 24 12:59:54 box kernel: qla1280: QLA1040 found on PCI bus 2, dev 12
Aug 24 12:59:54 box kernel: ACPI: PCI interrupt 0000:02:0c.0[A] -> GSI 9 (level, low) -> IRQ 9
Aug 24 12:59:54 box kernel: kmem_cache_create: duplicate cache scsi_cmd_cache
Aug 24 12:59:54 box kernel: ------------[ cut here ]------------
Aug 24 12:59:54 box kernel: kernel BUG at mm/slab.c:1382!
Aug 24 12:59:54 box kernel: invalid operand: 0000 [#1]
Aug 24 12:59:54 box kernel: Modules linked in: qla1280 ipv6 3c59x dm_mod thermal processor fan button battery ac rtc
Aug 24 12:59:54 box kernel: CPU:    0
Aug 24 12:59:54 box kernel: EIP:    0060:[<c0137298>]    Not tainted
Aug 24 12:59:54 box kernel: EFLAGS: 00010202   (2.6.8)
Aug 24 12:59:54 box kernel: EIP is at kmem_cache_create+0x3e8/0x580
Aug 24 12:59:54 box kernel: eax: 00000032   ebx: d3c151d0   ecx: c0460f58   edx: 07dc595d
Aug 24 12:59:54 box kernel: esi: c036dc03   edi: c036dc03   ebp: d3c150e0   esp: d2865e00
Aug 24 12:59:54 box kernel: ds: 007b   es: 007b   ss: 0068
Aug 24 12:59:54 box kernel: Process modprobe (pid: 8681, threadinfo=d2864000 task=c8d8c8c0)
Aug 24 12:59:54 box kernel: Stack: c035a0f4 c036dbf4 00000020 00002000 d2865e20 d3c1511c c0000000 ffffffe0
Aug 24 12:59:54 box kernel:        000000a0 d112f000 c03ddee0 d112f00c c03ddf08 c027bfd4 c036dbf4 00000160
Aug 24 12:59:54 box kernel:        00000020 00002000 00000000 00000000 00000b44 d112f000 d112fb44 d48ecf40
Aug 24 12:59:54 box kernel: Call Trace:
Aug 24 12:59:54 box kernel:  [<c027bfd4>] scsi_setup_command_freelist+0x84/0x110
Aug 24 12:59:54 box kernel:  [<c027cfb8>] scsi_host_alloc+0x1a8/0x2b0
Aug 24 12:59:54 box kernel:  [<c02bde6e>] pcibios_set_master+0x2e/0xb0
Aug 24 12:59:54 box kernel:  [<d48d3807>] qla1280_probe_one+0xa7/0x430 [qla1280]
Aug 24 12:59:54 box kernel:  [<c020fcf2>] pci_device_probe_static+0x52/0x70
Aug 24 12:59:54 box kernel:  [<c020fd4c>] __pci_device_probe+0x3c/0x50
Aug 24 12:59:54 box kernel:  [<c020fd8c>] pci_device_probe+0x2c/0x50
Aug 24 12:59:54 box kernel:  [<c024b15f>] bus_match+0x3f/0x70
Aug 24 12:59:54 box kernel:  [<c024b28c>] driver_attach+0x5c/0xa0
Aug 24 12:59:54 box kernel:  [<c024b806>] bus_add_driver+0xa6/0xd0
Aug 24 12:59:54 box kernel:  [<c024bddf>] driver_register+0x2f/0x40
Aug 24 12:59:54 box kernel:  [<c021000c>] pci_register_driver+0x5c/0x90
Aug 24 12:59:54 box kernel:  [<d48111f8>] qla1280_init+0x18/0x2e [qla1280]
Aug 24 12:59:54 box kernel:  [<c012e083>] sys_init_module+0x133/0x230
Aug 24 12:59:54 box kernel:  [<c0105bad>] sysenter_past_esp+0x52/0x71
Aug 24 12:59:54 box kernel: Code: 0f 0b 66 05 20 9a 35 c0 8b 0b e9 63 ff ff ff 8b 47 34 c7 04
 

This is on 2.6.8 patched with qla1280 3.24.4. The controller is
02:0c.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
02:0c.0 Class 0100: 1077:1020 (rev 05)
        Flags: bus master, medium devsel, latency 32, IRQ 9
        I/O ports at d400
        Memory at f3800000 (32-bit, non-prefetchable) [size=4K]



(ps: i'm not subscribed to linux-scsi)

-- 
Carlos Morgado <chbm@cprm.net> - Internet Engineering - Phone +351 214146594
GPG key: 0x75E451E2 FP: B98B 222B F276 18C0 266B  599D 93A1 A3FB 75E4 51E2
The views expressed above do not bind my employer.
