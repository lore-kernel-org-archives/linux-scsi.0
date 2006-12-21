From: Steve Lord <lord@xfs.org>
Subject: oops in mptsas driver during device reset - 2.6.19-1
Date: Thu, 21 Dec 2006 12:03:37 -0600
Message-ID: <458ACC79.3050607@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.roc.ny.frontiernet.net ([66.133.182.164]:51724 "EHLO
	relay01.roc.ny.frontiernet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423005AbWLUSZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Dec 2006 13:25:24 -0500
Received: from [192.168.1.64] (74-37-216-243.dsl1.lkv.mn.frontiernet.net [74.37.216.243])
	by relay01.roc.ny.frontiernet.net (Postfix) with ESMTP id 077CB364144
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2006 18:03:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have some sick sas raid hardware which is timing out on a command, this
is causing an oops in the mptsas driver in 2.6.19.1 followed by a warning
about sleeping with irq's disabled.

Steve


[  681.547980] mptscsih: ioc0: attempting task abort! (sc=ffff81023ffcf380)
[  681.555009] sd 4:0:0:0:
[  686.278756] mptscsih: ioc0: task abort: FAILED (sc=ffff81023ffcf380)
[  686.285421] mptscsih: ioc0: attempting task abort! (sc=ffff81023f8fec80)
[  686.292393] sd 4:0:0:0:
[  691.017520] mptscsih: ioc0: task abort: FAILED (sc=ffff81023f8fec80)
[  691.024160] mptscsih: ioc0: attempting task abort! (sc=ffff81023f8fe680)
[  691.031124] sd 4:0:0:0:
[  695.756285] mptscsih: ioc0: task abort: FAILED (sc=ffff81023f8fe680)
[  695.762922] mptscsih: ioc0: attempting task abort! (sc=ffff81023ffcf080)
[  695.769912] sd 4:0:0:0:
[  700.491057] mptscsih: ioc0: task abort: FAILED (sc=ffff81023ffcf080)
[  700.497686] mptscsih: ioc0: attempting task abort! (sc=ffff81023f8fe200)
[  700.504623] sd 4:0:0:0:
[  705.225828] mptscsih: ioc0: task abort: FAILED (sc=ffff81023f8fe200)
[  705.232495] mptscsih: ioc0: attempting target reset! 
(sc=ffff81023ffcf380)
[  705.239690] sd 4:0:0:0:
[  706.128069] mptscsih: ioc0: target reset: SUCCESS (sc=ffff81023ffcf380)
[  707.297807] mptscsih: ioc0: attempting bus reset! (sc=ffff81023ffcf380)
[  707.304749] sd 4:0:0:0:
[  708.459573] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff81023ffcf380)
[  718.452062] Unable to handle kernel NULL pointer dereference at 
0000000000000000 RIP:
[  718.457812]  [<ffffffff8801c2f3>] :mptsas:mptsas_qcmd+0xe/0x2e
[  718.466488] PGD 237555067 PUD 237556067 PMD 235d33067 PTE 0
[  718.472335] Oops: 0000 [1] SMP
[  718.475622] CPU 0
[  718.477740] Modules linked in: ipv6 autofs4 i2c_i801 i2c_core e1000 
dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod aic79xx mptsas mptscsih 
mptbase ata_piix
[  718.492257] Pid: 442, comm: scsi_eh_4 Not tainted 2.6.19-1smp #1
[  718.498551] RIP: 0010:[<ffffffff8801c2f3>]  [<ffffffff8801c2f3>] 
:mptsas:mptsas_qcmd+0xe/0x2e
[  718.507496] RSP: 0018:ffff81023ee33d90  EFLAGS: 00010086
[  718.513058] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 
0000000000000000
[  718.520514] RDX: 0000000000000000 RSI: ffffffff811dfa03 RDI: 
ffff81023ffcf380
[  718.527970] RBP: ffff81023ffcf380 R08: 0000000000000000 R09: 
000000000000000a
[  718.535427] R10: ffff810237423c08 R11: ffff810237423c08 R12: 
ffff81023ee33dc0
[  718.542900] R13: ffff81023f9e1000 R14: ffff81023ffcf3dc R15: 
ffff81023ffcf440
[  718.550356] FS:  0000000000000000(0000) GS:ffffffff81440000(0000) 
knlGS:0000000000000000
[  718.558839] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  718.564844] CR2: 0000000000000000 CR3: 00000002379e7000 CR4: 
00000000000006e0
[  718.572307] Process scsi_eh_4 (pid: 442, threadinfo ffff81023ee32000, 
task ffff81023fad4080)
[  718.581148] Stack:  ffff81023ee33dc0 ffffffff811df7b7 
000009c400000000 0000000200080000
[  718.589556]  000800000ae30009 ffff8102345f6a00 0000000000000000 
dead4ead00000001
[  718.597322]  00000000ffffffff ffffffffffffffff ffff81023ee33de0 
ffff81023ee33de0
[  718.604866] Call Trace:
[  718.607622]  [<ffffffff811df7b7>] scsi_send_eh_cmnd+0x1d3/0x36f
[  718.613796]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.620186]  [<ffffffff811df9b4>] scsi_eh_tur+0x28/0x77
[  718.625635]  [<ffffffff811e0513>] scsi_error_handler+0x744/0xab6
[  718.631907]  [<ffffffff811dfdcf>] scsi_error_handler+0x0/0xab6
[  718.638004]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.644388]  [<ffffffff8103d2ee>] kthread+0xd1/0x103
[  718.649560]  [<ffffffff8100a4f8>] child_rip+0xa/0x12
[  718.654750]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.661108]  [<ffffffff8103d21d>] kthread+0x0/0x103
[  718.666202]  [<ffffffff8100a4ee>] child_rip+0x0/0x12
[  718.671383]
[  718.672948]
[  718.672948] Code: 48 8b 00 80 78 12 00 75 07 41 58 e9 37 89 ff ff c7 
87 70 01
[  718.682143] RIP  [<ffffffff8801c2f3>] :mptsas:mptsas_qcmd+0xe/0x2e
[  718.688648]  RSP <ffff81023ee33d90>
[  718.692298] CR2: 0000000000000000
[  718.695758]  <3>BUG: sleeping function called from invalid context at 
kernel/rwsem.c:20
[  718.704037] in_atomic():0, irqs_disabled():1
[  718.708436]
[  718.708437] Call Trace:
[  718.712504]  [<ffffffff8103fc3c>] down_read+0x15/0x21
[  718.717703]  [<ffffffff8103779e>] blocking_notifier_call_chain+0x13/0x36
[  718.724692]  [<ffffffff8102e6b3>] do_exit+0x22/0x89c
[  718.729805]  [<ffffffff811a6bee>] do_unblank_screen+0x27/0x134
[  718.735809]  [<ffffffff8101b7a0>] do_page_fault+0x725/0x7a1
[  718.741621]  [<ffffffff8103d40e>] autoremove_wake_function+0x9/0x2e
[  718.748123]  [<ffffffff81024234>] __wake_up_common+0x3e/0x68
[  718.754016]  [<ffffffff8102c399>] vprintk+0x2af/0x2ef
[  718.759240]  [<ffffffff812f060d>] error_exit+0x0/0x84
[  718.764482]  [<ffffffff811dfa03>] scsi_eh_done+0x0/0x4a
[  718.769947]  [<ffffffff8801c2f3>] :mptsas:mptsas_qcmd+0xe/0x2e
[  718.776011]  [<ffffffff811df7b7>] scsi_send_eh_cmnd+0x1d3/0x36f
[  718.782172]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.788475]  [<ffffffff811df9b4>] scsi_eh_tur+0x28/0x77
[  718.793934]  [<ffffffff811e0513>] scsi_error_handler+0x744/0xab6
[  718.800169]  [<ffffffff811dfdcf>] scsi_error_handler+0x0/0xab6
[  718.806223]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.812511]  [<ffffffff8103d2ee>] kthread+0xd1/0x103
[  718.817675]  [<ffffffff8100a4f8>] child_rip+0xa/0x12
[  718.822796]  [<ffffffff8103d069>] keventd_create_kthread+0x0/0x66
[  718.829148]  [<ffffffff8103d21d>] kthread+0x0/0x103
[  718.834189]  [<ffffffff8100a4ee>] child_rip+0x0/0x12
[  718.839299]
[  719.320266] mptsas: ioc0: attaching ssp device, channel 0, id 9, phy 7
[  719.353183] mptsas: ioc0: removing ssp device, channel 0, id 8, phy 1
[  719.363390] mptsas: ioc0: removing ssp device, channel 0, id 9, phy 4
[  721.436156] mptsas: ioc0: attaching ssp device, channel 0, id 8, phy 1
[  723.470835] mptsas: ioc0: attaching ssp device, channel 0, id 9, phy 4
[  723.502397] mptsas: ioc0: removing ssp device, channel 0, id 8, phy 1
[  723.510525] mptsas: ioc0: removing ssp device, channel 0, id 9, phy 4
[  725.580107] mptsas: ioc0: attaching ssp device, channel 0, id 8, phy 1
[  727.614773] mptsas: ioc0: attaching ssp device, channel 0, id 9, phy 4
[  727.663069] mptsas: ioc0: removing ssp device, channel 0, id 8, phy 0
[  727.670218] mptsas: ioc0: removing ssp device, channel 0, id 9, phy 4
[  729.742634] mptsas: ioc0: attaching ssp device, channel 0, id 8, phy 1
[  731.774665] mptsas: ioc0: attaching ssp device, channel 0, id 9, phy 4
[  731.823073] mptsas: ioc0: removing ssp device, channel 0, id 8, phy 0
[  731.831569] mptsas: ioc0: removing ssp device, channel 0, id 9, phy 4
[  733.906518] mptsas: ioc0: attaching ssp device, channel 0, id 8, phy 0
[  735.938553] mptsas: ioc0: attaching ssp device, channel 0, id 9, phy 4



