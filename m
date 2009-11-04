From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 16:51:12 +0100
Message-ID: <4AF1A2F0.7060201@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:35497 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZKDPvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 10:51:09 -0500
In-Reply-To: <4AF17AD3.6060909@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

John Hughes wrote:
> Like Lars T=E4uber last year I have a Promise Vtrak J610S "just a bun=
ch=20
> of disks" cabinet, and like him I find that the ses enclosure service=
s=20
> don't seem to be working right.

> Also the "fault" and "locate" files seem to do nothing, writing to=20
> them doesn't make any lights flash.
Well the "locate" light does work, you just have to first write zero,=20
then one.

I.E.

echo 0 > locate
echo 1 > locate

starts the light flashing.

Attempts to change the "status" fail:

# echo "unconfigured" > status
[  626.389093] general protection fault: 0000 [#1] SMP=20
[  626.389243] last sysfs file: /sys/class/enclosure/0:0:32:0/0/status
[  626.389310] CPU 0=20
[  626.389412] Modules linked in: ipv6 dm_round_robin dm_multipath loop=
 snd_pcsp snd_pcm snd_timer snd soundcore snd_page_alloc psmouse serio_=
raw shpchp pci_hotplug button processor dcdbas joydev evdev ext3 jbd mb=
cache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid10 raid456=
 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 multipath lin=
ear md_mod usbhid hid sg sr_mod cdrom ide_pci_generic ide_core ata_gene=
ric sd_mod ses enclosure ata_piix libata mptsas mptscsih ehci_hcd mptba=
se uhci_hcd scsi_transport_sas megaraid_sas scsi_mod bnx2 thermal fan t=
hermal_sys [last unloaded: scsi_wait_scan]
[  626.392419] Pid: 5685, comm: bash Not tainted 2.6.31 #1 PowerEdge R7=
10
[  626.392487] RIP: 0010:[<ffffffffa00ff563>]  [<ffffffffa00ff563>] set=
_component_status+0x31/0xa5 [enclosure]
[  626.392621] RSP: 0018:ffff88063bdf9e78  EFLAGS: 00010286
[  626.392687] RAX: 0000000000000000 RBX: 000000000000000c RCX: fffffff=
fffffffff
[  626.392755] RDX: 0000000000000009 RSI: 000a7325000a6425 RDI: 000a732=
5000a6425
[  626.392824] RBP: ffffffffa00ff980 R08: ffff88063c4cc263 R09: ffff880=
63fc0b600
[  626.392893] R10: 00000000002e85af R11: ffffffffa00ff532 R12: 0000000=
000000008
[  626.392962] R13: ffff88063b80d000 R14: ffff88063c461980 R15: ffff880=
63c461818
[  626.393031] FS:  00007f6f2de856e0(0000) GS:ffffc90000000000(0000) kn=
lGS:0000000000000000
[  626.393115] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.393182] CR2: 0000000000d19588 CR3: 000000063682b000 CR4: 0000000=
0000006f0
[  626.393251] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  626.393319] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  626.393388] Process bash (pid: 5685, threadinfo ffff88063bdf8000, ta=
sk ffff88063bd34480)
[  626.393472] Stack:
[  626.393531]  0000000000000000 ffff88063c8a29c0 000000000000000d 0000=
00000000000d
[  626.393726] <0> ffff88063d4b19c0 ffff88063c4cc190 00000000ffffffed f=
fff88063c461990
[  626.394018] <0> ffffffff81413600 ffffffff81121414 0000000000000202 f=
fff88063bdf9f50
[  626.394365] Call Trace:
[  626.394430]  [<ffffffff81121414>] ? sysfs_write_file+0xd0/0x107
[  626.394501]  [<ffffffff810d387f>] ? vfs_write+0xad/0x169
[  626.394567]  [<ffffffff810d39f7>] ? sys_write+0x45/0x6e
[  626.394635]  [<ffffffff8100ba02>] ? system_call_fastpath+0x16/0x1b
[  626.394701] Code: fe 41 55 49 89 d5 41 54 45 31 e4 55 48 c7 c5 40 f9=
 0f a0 53 48 83 ec 18 48 89 4c 24 10 4c 8b 3f eb 35 48 89 f7 31 c0 48 8=
3 c9 ff <f2> ae 4c 89 ef 48 89 cb 48 f7 d3 48 8d 53 ff e8 c2 fa 06 e1 8=
5=20
[  626.397521] RIP  [<ffffffffa00ff563>] set_component_status+0x31/0xa5=
 [enclosure]
[  626.397648]  RSP <ffff88063bdf9e78>
[  626.397760] ---[ end trace a4c1b502958318fc ]---


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
