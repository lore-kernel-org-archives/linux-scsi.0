From: Olaf Hering <olh@suse.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 24 Oct 2004 17:00:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024150051.GA21922@suse.de>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net> <20041024144236.GA21793@suse.de> <1098629588.10908.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:21146 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261509AbUJXPCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 11:02:52 -0400
Content-Disposition: inline
In-Reply-To: <1098629588.10908.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dan Hollis <goemon@anime.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

 On Sun, Oct 24, James Bottomley wrote:

> There's something else going on here.  The CD should hold a reference=
 to
> the device so is entitled to send it a command.  If the device isn't
> there (and the firewire driver doesn't reject it immediately) it shou=
ld
> go into error handling and eventually offline the device ... what do =
the
> kernel messages say is going on?


turn off cdrom:
ohci1394: fw-host0: IntEvent: 00030010
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=3D0x00008409
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8c56 received
ieee1394: Including SelfID 0x807f8c56
ohci1394: fw-host0: SelfID for this node is 0x807f8c56
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=3Dffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_i=
d: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing host reset for knodemgrd_0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=3D0 ... discarded
ieee1394: send packet local: ffc09940 ffc0ffff f0000400
ieee1394: received packet: ffc09940 ffc0ffff f0000400
ieee1394: send packet local: ffc09960 ffc00000 00000000 040462b0
ieee1394: received packet: ffc09960 ffc00000 00000000 040462b0
ieee1394: send packet local: ffc09d40 ffc0ffff f0000404
ieee1394: received packet: ffc09d40 ffc0ffff f0000404
ieee1394: send packet local: ffc09d60 ffc00000 00000000 31333934
ieee1394: received packet: ffc09d60 ffc00000 00000000 31333934
ieee1394: send packet local: ffc0a140 ffc0ffff f0000408
ieee1394: received packet: ffc0a140 ffc0ffff f0000408
ieee1394: send packet local: ffc0a160 ffc00000 00000000 e064a232
ieee1394: received packet: ffc0a160 ffc00000 00000000 e064a232
ieee1394: send packet local: ffc0a540 ffc0ffff f000040c
ieee1394: received packet: ffc0a540 ffc0ffff f000040c
ieee1394: send packet local: ffc0a560 ffc00000 00000000 00601d00
ieee1394: received packet: ffc0a560 ffc00000 00000000 00601d00
ieee1394: send packet local: ffc0a940 ffc0ffff f0000410
ieee1394: received packet: ffc0a940 ffc0ffff f0000410
ieee1394: send packet local: ffc0a960 ffc00000 00000000 000000dd
ieee1394: received packet: ffc0a960 ffc00000 00000000 000000dd
ieee1394: send packet local: ffc0ad50 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc0ad50 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc0ad70 ffc00000 00000000 04000000
ieee1394: received packet: ffc0ad70 ffc00000 00000000 04000000
ieee1394: Node changed: 0-02:1023 -> 0-00:1023
ieee1394: send packet 100: ffff1100 ffc0ffff f0000234 c000001f
ohci1394: fw-host0: Inserting packet for node 0-63:1023, tlabel=3D4, tc=
ode=3D0x0, speed=3D0
ohci1394: fw-host0: Starting transmit DMA ctx=3D0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=3D0x00008011
ohci1394: fw-host0: Packet sent to node 63 tcode=3D0x0 tLabel=3D0x04 ac=
k=3D0x11 spd=3D0 data=3D0x1F0000C0 ctx=3D0
ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[00010410100036e0]
ieee1394: Node suspended: ID:BUS[0-01:1023]  GUID[0001d200500601fb]
SysRq : Show State

                                               sibling
  task             PC      pid father child younger older
bash          S 0FE3BC9C     0     1      0     2               (NOTLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c001cf7c] do_wait+0x1f8/0xd7c
 [c00064d0] ret_from_syscall+0x0/0x4c
ksoftirqd/0   R running     0     2      1             3       (L-TLB)
events/0      S 00000000     0     3      1     4      26     2 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
khelper       S 00000000     0     4      3            13       (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
kblockd/0     R running     0    13      3            24     4 (L-TLB)
pdflush       S 00000000     0    24      3            25    13 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c003e9d0] pdflush+0xc0/0x1fc
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
pdflush       S 00000000     0    25      3            27    24 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c003e9d0] pdflush+0xc0/0x1fc
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
aio/0         S 00000000     0    27      3                  25 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
kswapd0       S 00000000     0    26      1           257     3 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c00454b4] kswapd+0x88/0xb8
 [c0009834] kernel_thread+0x44/0x60
rpciod        S 00000000     0   257      1           289    26 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c548749c] rpciod+0x1c8/0x2dc [sunrpc]
 [c0009834] kernel_thread+0x44/0x60
sh            R running     0   289      1           293   257 (NOTLB)
khpsbpkt      S 00000000     0   293      1           296   289 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c0176c34] __down_interruptible+0xcc/0x15c
 [c54cc364] hpsbpkt_thread+0xc8/0xe0 [ieee1394]
 [c0009834] kernel_thread+0x44/0x60
knodemgrd_0   D 00000000     0   296      1           321   293 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c01776e8] wait_for_completion+0x7c/0xec
 [c5d2fb94] scsi_wait_req+0x64/0xac [scsi_mod]
 [c54f5590] sr_do_ioctl+0x9c/0x26c [sr_mod]
 [c54f49cc] sr_packet+0x28/0x68 [sr_mod]
 [c5d11a34] cdrom_get_disc_info+0x60/0xc4 [cdrom]
 [c5d121e4] cdrom_mrw_exit+0x1c/0x104 [cdrom]
 [c5d10b6c] unregister_cdrom+0xd0/0x104 [cdrom]
 [c54f41a8] sr_kref_release+0x54/0x80 [sr_mod]
 [c00ad96c] kref_put+0x60/0x70
 [c54f4924] sr_remove+0x50/0xd0 [sr_mod]
 [c00eafcc] device_release_driver+0x84/0x88
 [c00eb1bc] bus_remove_device+0xc0/0x12c
 [c00e9620] device_del+0xa4/0x114
scsi_eh_1     S 00000000     0   321      1                 296 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c0177140] schedule+0x2b8/0x5e0
 [c0176c34] __down_interruptible+0xcc/0x15c
 [c5d2db80] scsi_error_handler+0x590/0xe68 [scsi_mod]
 [c0009834] kernel_thread+0x44/0x60



here is something with my debug stuff:

ohci1394: fw-host0: IntEvent: 00030010
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=3D0x00008409
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8c56 received
ieee1394: Including SelfID 0x807f8c56
ohci1394: fw-host0: SelfID for this node is 0x807f8c56
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=3Dffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_i=
d: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing host reset for knodemgrd_0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=3D0 ... discarded
ieee1394: send packet local: ffc05d40 ffc0ffff f0000400
ieee1394: received packet: ffc05d40 ffc0ffff f0000400
ieee1394: send packet local: ffc05d60 ffc00000 00000000 040462b0
ieee1394: received packet: ffc05d60 ffc00000 00000000 040462b0
ieee1394: send packet local: ffc06140 ffc0ffff f0000404
ieee1394: received packet: ffc06140 ffc0ffff f0000404
ieee1394: send packet local: ffc06160 ffc00000 00000000 31333934
ieee1394: received packet: ffc06160 ffc00000 00000000 31333934
ieee1394: send packet local: ffc06540 ffc0ffff f0000408
ieee1394: received packet: ffc06540 ffc0ffff f0000408
ieee1394: send packet local: ffc06560 ffc00000 00000000 e064a232
ieee1394: received packet: ffc06560 ffc00000 00000000 e064a232
ieee1394: send packet local: ffc06940 ffc0ffff f000040c
ieee1394: received packet: ffc06940 ffc0ffff f000040c
ieee1394: send packet local: ffc06960 ffc00000 00000000 00601d00
ieee1394: received packet: ffc06960 ffc00000 00000000 00601d00
ieee1394: send packet local: ffc06d40 ffc0ffff f0000410
ieee1394: received packet: ffc06d40 ffc0ffff f0000410
ieee1394: send packet local: ffc06d60 ffc00000 00000000 000000dd
ieee1394: received packet: ffc06d60 ffc00000 00000000 000000dd
ieee1394: send packet local: ffc07150 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc07150 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc07170 ffc00000 00000000 04000000
ieee1394: received packet: ffc07170 ffc00000 00000000 04000000
ieee1394: Node changed: 0-01:1023 -> 0-00:1023
ieee1394: send packet 100: ffff0d00 ffc0ffff f0000234 c000001f
ohci1394: fw-host0: Inserting packet for node 0-63:1023, tlabel=3D3, tc=
ode=3D0x0, speed=3D0
ohci1394: fw-host0: Starting transmit DMA ctx=3D0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=3D0x00008011
ohci1394: fw-host0: Packet sent to node 63 tcode=3D0x0 tLabel=3D0x03 ac=
k=3D0x11 spd=3D0 data=3D0x1F0000C0 ctx=3D0
nodemgr_node_probe(1354) knodemgrd_0(296) enter
nodemgr_probe_ne(1322) knodemgrd_0(296) enter
nodemgr_probe_ne(1344) knodemgrd_0(296) leave
nodemgr_probe_ne(1322) knodemgrd_0(296) enter
ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[0001d200500601fb]
nodemgr_suspend_ne(1253) knodemgrd_0(296) ud->ne c0fbd400(<NULL>) ne c0=
fbd400(<NULL>)
nodemgr_suspend_ne(1257) knodemgrd_0(296) suspend 00000000
device_release_driver(370) knodemgrd_0(296) enter
device_release_driver(372) knodemgrd_0(296) drv sbp2 hpsb_protocol_driv=
er c54ed5f8
device_release_driver(373) knodemgrd_0(296) sysfs_remove_link
device_release_driver(375) knodemgrd_0(296) list_del_init
device_release_driver(377) knodemgrd_0(296) device_detach_shutdown
device_detach_shutdown(25) knodemgrd_0(296) enter
device_release_driver(379) knodemgrd_0(296) remove
ieee1394: sbp2: sbp2_remove
sbp2_remove(634) knodemgrd_0(296) enter
sbp2_remove(639) knodemgrd_0(296) scsi_id c0207760
ieee1394: sbp2: sbp2_logout_device
ieee1394: sbp2: sbp2_remove_device
device_release_driver(370) knodemgrd_0(296) enter
device_release_driver(372) knodemgrd_0(296) drv sr c54f68d4
device_release_driver(373) knodemgrd_0(296) sysfs_remove_link
device_release_driver(375) knodemgrd_0(296) list_del_init
device_release_driver(377) knodemgrd_0(296) device_detach_shutdown
device_detach_shutdown(25) knodemgrd_0(296) enter
device_release_driver(379) knodemgrd_0(296) remove
sr_packet(896) knodemgrd_0(296)=20
SysRq : Show State

                                               sibling
  task             PC      pid father child younger older
bash          S 0FE3BC9C     0     1      0     2               (NOTLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c001cf7c] do_wait+0x1f8/0xd7c
 [c00064d0] ret_from_syscall+0x0/0x4c
ksoftirqd/0   R running     0     2      1             3       (L-TLB)
events/0      S 00000000     0     3      1     4      26     2 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
khelper       S 00000000     0     4      3            13       (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
kblockd/0     R running     0    13      3            24     4 (L-TLB)
pdflush       S 00000000     0    24      3            25    13 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c003e9d0] pdflush+0xc0/0x1fc
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
pdflush       S 00000000     0    25      3            27    24 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c003e9d0] pdflush+0xc0/0x1fc
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
aio/0         S 00000000     0    27      3                  25 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c002c288] worker_thread+0x224/0x228
 [c0031134] kthread+0xf0/0x12c
 [c0009834] kernel_thread+0x44/0x60
kswapd0       S 00000000     0    26      1           257     3 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c00454b4] kswapd+0x88/0xb8
 [c0009834] kernel_thread+0x44/0x60
rpciod        S 00000000     0   257      1           289    26 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c548749c] rpciod+0x1c8/0x2dc [sunrpc]
 [c0009834] kernel_thread+0x44/0x60
sh            R running     0   289      1           293   257 (NOTLB)
khpsbpkt      S 00000000     0   293      1           296   289 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c0176e60] __down_interruptible+0xcc/0x15c
 [c54cc364] hpsbpkt_thread+0xc8/0xe0 [ieee1394]
 [c0009834] kernel_thread+0x44/0x60
knodemgrd_0   D 00000000     0   296      1           307   293 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c0177914] wait_for_completion+0x7c/0xec
 [c5d2fb94] scsi_wait_req+0x64/0xac [scsi_mod]
 [c54f7598] sr_do_ioctl+0x70/0x240 [sr_mod]
 [c54f6a00] sr_packet+0x5c/0x9c [sr_mod]
 [c5d11a34] cdrom_get_disc_info+0x60/0xc4 [cdrom]
 [c5d121e4] cdrom_mrw_exit+0x1c/0x104 [cdrom]
 [c5d10b6c] unregister_cdrom+0xd0/0x104 [cdrom]
 [c54f61a8] sr_kref_release+0x54/0x80 [sr_mod]
 [c00ad96c] kref_put+0x60/0x70
 [c54f6924] sr_remove+0x50/0xd0 [sr_mod]
 [c00eb100] device_release_driver+0x1b8/0x1bc
 [c00eb2f0] bus_remove_device+0xc0/0x12c
 [c00e9620] device_del+0xa4/0x114
scsi_eh_0     S 00000000     0   307      1                 296 (L-TLB)
Call trace:
 [c000a228] __switch_to+0x48/0x70
 [c017736c] schedule+0x2b8/0x5e0
 [c0176e60] __down_interruptible+0xcc/0x15c
 [c5d2db80] scsi_error_handler+0x590/0xe68 [scsi_mod]
 [c0009834] kernel_thread+0x44/0x60
--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
