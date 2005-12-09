From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: bug in scsi_setup_command_freelist:  kmem_cache_create: duplicate
 cache scsi_cmd_cache
Date: Fri, 09 Dec 2005 23:05:21 +0100
Message-ID: <4399FFA1.3050000@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39377 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932347AbVLIWGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 17:06:38 -0500
Received: from [192.168.0.41] ([83.221.230.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jB9M5UnP005629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Dec 2005 23:06:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I just saw the following under Linux 2.6.14.3. A web search turns up
more reports of this kind, usually with USB devices.

[sbp2 throws transport errors during inquiry]
Dec  9 22:09:56 shuttle kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
Dec  9 22:09:56 shuttle kernel: ieee1394: sbp2: scsi_add_device failed
[I unloaded and reloaded sbp2]
Dec  9 22:10:31 shuttle kernel: SCSI subsystem initialized
Dec  9 22:10:31 shuttle kernel: ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
Dec  9 22:10:31 shuttle kernel: ieee1394: sbp2: Try serialize_io=0 for better performance
Dec  9 22:10:31 shuttle kernel: kmem_cache_create: duplicate cache scsi_cmd_cache
Dec  9 22:10:31 shuttle kernel: ------------[ cut here ]------------
Dec  9 22:10:31 shuttle kernel: kernel BUG at mm/slab.c:1807!
Dec  9 22:10:31 shuttle kernel: invalid operand: 0000 [#1]
Dec  9 22:10:31 shuttle kernel: PREEMPT
Dec  9 22:10:31 shuttle kernel: Modules linked in: sbp2 scsi_mod nvidia nfsd exportfs lockd sunrpc snd_via82xx snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd lp af_packet eth1394 8139too mii ohci1394 ieee1394 loop via_agp agpgart uhci_hcd
Dec  9 22:10:31 shuttle kernel: CPU:    0
Dec  9 22:10:31 shuttle kernel: EIP:    0060:[kmem_cache_create+1028/1600]    Tainted: P      VLI
Dec  9 22:10:31 shuttle kernel: EIP:    0060:[<c01407d4>]    Tainted: P      VLI
Dec  9 22:10:31 shuttle kernel: EFLAGS: 00010202   (2.6.14.3)
Dec  9 22:10:31 shuttle kernel: EIP is at kmem_cache_create+0x404/0x640
Dec  9 22:10:31 shuttle kernel: eax: 00000035   ebx: c153170c   ecx: dd6ce000   edx: d331e000
Dec  9 22:10:31 shuttle kernel: esi: e0e70d63   edi: e0e70d63   ebp: c1531660   esp: d331fdc0
Dec  9 22:10:31 shuttle kernel: ds: 007b   es: 007b   ss: 0068
Dec  9 22:10:31 shuttle kernel: Process modprobe (pid: 6338, threadinfo=d331e000 task=d84b4a70)
Dec  9 22:10:31 shuttle kernel: Stack: c02b87dc e0e70d54 00000020 00002000 d331fde4 c153167c ffffffe0 c0000000
Dec  9 22:10:31 shuttle kernel:        00000020 00000080 c0abe030 c0340df0 00000089 00000000 e0e7fac0 c6b0ec00
Dec  9 22:10:31 shuttle kernel:        c6b0ec14 e0d4afa0 e0e633cc e0e70d54 00000160 00000000 00002000 00000000
Dec  9 22:10:31 shuttle kernel: Call Trace:
Dec  9 22:10:31 shuttle kernel:  [pg0+548459468/1070236672] scsi_setup_command_freelist+0x6c/0xf0 [scsi_mod]
Dec  9 22:10:31 shuttle kernel:  [<e0e633cc>] scsi_setup_command_freelist+0x6c/0xf0 [scsi_mod]
Dec  9 22:10:31 shuttle kernel:  [pg0+548465833/1070236672] scsi_host_alloc+0x1c9/0x320 [scsi_mod]
Dec  9 22:10:31 shuttle kernel:  [<e0e64ca9>] scsi_host_alloc+0x1c9/0x320 [scsi_mod]
Dec  9 22:10:31 shuttle kernel:  [pg0+547293131/1070236672] sbp2_alloc_device+0xeb/0x220 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [<e0d467cb>] sbp2_alloc_device+0xeb/0x220 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [sprintf+39/48] sprintf+0x27/0x30
Dec  9 22:10:31 shuttle kernel:  [<c01cf1e7>] sprintf+0x27/0x30
Dec  9 22:10:31 shuttle kernel:  [pg0+547292597/1070236672] sbp2_probe+0x25/0x60 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [<e0d465b5>] sbp2_probe+0x25/0x60 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [driver_probe_device+56/208] driver_probe_device+0x38/0xd0
Dec  9 22:10:31 shuttle kernel:  [<c01feea8>] driver_probe_device+0x38/0xd0
Dec  9 22:10:31 shuttle kernel:  [__driver_attach+0/80] __driver_attach+0x0/0x50
Dec  9 22:10:31 shuttle kernel:  [<c01fefc0>] __driver_attach+0x0/0x50
Dec  9 22:10:31 shuttle kernel:  [__driver_attach+65/80] __driver_attach+0x41/0x50
Dec  9 22:10:31 shuttle kernel:  [<c01ff001>] __driver_attach+0x41/0x50
Dec  9 22:10:31 shuttle kernel:  [bus_for_each_dev+93/128] bus_for_each_dev+0x5d/0x80
Dec  9 22:10:31 shuttle kernel:  [<c01fe3dd>] bus_for_each_dev+0x5d/0x80
Dec  9 22:10:31 shuttle kernel:  [driver_attach+38/48] driver_attach+0x26/0x30
Dec  9 22:10:31 shuttle kernel:  [<c01ff036>] driver_attach+0x26/0x30
Dec  9 22:10:31 shuttle kernel:  [__driver_attach+0/80] __driver_attach+0x0/0x50
Dec  9 22:10:31 shuttle kernel:  [<c01fefc0>] __driver_attach+0x0/0x50
Dec  9 22:10:31 shuttle kernel:  [bus_add_driver+131/240] bus_add_driver+0x83/0xf0
Dec  9 22:10:31 shuttle kernel:  [<c01fe933>] bus_add_driver+0x83/0xf0
Dec  9 22:10:31 shuttle kernel:  [driver_register+59/64] driver_register+0x3b/0x40
Dec  9 22:10:31 shuttle kernel:  [<c01ff4cb>] driver_register+0x3b/0x40
Dec  9 22:10:31 shuttle kernel:  [klist_devices_get+0/16] klist_devices_get+0x0/0x10
Dec  9 22:10:31 shuttle kernel:  [<c01ff470>] klist_devices_get+0x0/0x10
Dec  9 22:10:31 shuttle kernel:  [klist_devices_put+0/16] klist_devices_put+0x0/0x10
Dec  9 22:10:31 shuttle kernel:  [<c01ff480>] klist_devices_put+0x0/0x10
Dec  9 22:10:31 shuttle kernel:  [pg0+543739258/1070236672] hpsb_register_protocol+0x1a/0x50 [ieee1394]
Dec  9 22:10:31 shuttle kernel:  [<e09e2d7a>] hpsb_register_protocol+0x1a/0x50 [ieee1394]
Dec  9 22:10:31 shuttle kernel:  [pg0+547302000/1070236672] sbp2_module_init+0x30/0xb0 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [<e0d48a70>] sbp2_module_init+0x30/0xb0 [sbp2]
Dec  9 22:10:31 shuttle kernel:  [sys_init_module+310/512] sys_init_module+0x136/0x200
Dec  9 22:10:31 shuttle kernel:  [<c01338c6>] sys_init_module+0x136/0x200
Dec  9 22:10:31 shuttle kernel:  [sysenter_past_esp+84/117] sysenter_past_esp+0x54/0x75
Dec  9 22:10:31 shuttle kernel:  [<c0102ecb>] sysenter_past_esp+0x54/0x75
Dec  9 22:10:31 shuttle kernel: Code: 24 e8 f1 f4 ff ff e9 d5 fd ff ff 8b 4c 24 4c c7 04 24 dc 87 2b c0 89 4c 24 04 e8 58 65 fd ff ff 05 6c 89 34 c0 0f 8e 42 1c 00 00 <0f> 0b 0f 07 36 7f 2b c0 8b 1b e9 1d ff ff ff 8b 41 10 c7 04 24

I had a look at how pool->users is refcounted but did not find
any obvious mistake.
-- 
Stefan Richter
-=====-=-=-= ==-- -=--=
http://arcgraph.de/sr/
