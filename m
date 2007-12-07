From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: everything in wait_for_completion, what is my system doing?
Date: Thu, 6 Dec 2007 17:09:11 -0800
Message-ID: <20071206170911.4060cd1c.akpm@linux-foundation.org>
References: <200712052144.54399.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbXLGBJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 20:09:23 -0500
In-Reply-To: <200712052144.54399.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org, bernd-schubert@gmx.de, linux-scsi@vger.kernel.org

On Wed, 5 Dec 2007 21:44:54 +0100
Bernd Schubert <bs@q-leap.de> wrote:

> after scsi-recovery a system here went into some kind lock-up, everything 
> seems to be in wait_for_completion(). Please see the attached 
> blocked_states.txt and all_states.txt files.
> This is 2.6.22.12, I can easily find out the line numbers if required.
> 
> Any help is highly appreciated.
> 
> 

Please cc linux-scsi on scsi-related reports.

> 
> 
> [blocked_states.txt  text/plain (20.5KB)]
> [generate break]
> [ 1818.566436] SysRq : Show Blocked State
> [ 1818.570260]
> [ 1818.570261]                                  free                        sibling
> [ 1818.579253]   task                 PC        stack   pid father child younger older
> [ 1818.586987] events/7      D 00000155dd642280     0    26      2 (L-TLB)
> [ 1818.593747]  ffff81012b529ac0 0000000000000046 0000000000000000 ffff810128280d18
> [ 1818.601321]  ffff8100ba2376f8 ffff81012b689630 ffff81012aff76b0 000000078023e215
> [ 1818.608870]  000000010003ca14 0000000000000000 ffff810001065400 0000000780430c13
> [ 1818.616222] Call Trace:
> [ 1818.618925]  [<ffffffff804ececb>] io_schedule+0x28/0x36
> [ 1818.624207]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
> [ 1818.630112]  [<ffffffff8036e5a1>] blk_get_request+0x36/0x6b
> [ 1818.635755]  [<ffffffff8042f5cb>] scsi_execute+0x51/0x129
> [ 1818.641240]  [<ffffffff880cc11b>] :scsi_transport_spi:spi_execute+0x87/0xf8
> [ 1818.648271]  [<ffffffff880cd5ae>] :scsi_transport_spi:spi_dv_device_echo_buffer+0x181/0x27d
> [ 1818.656739]  [<ffffffff880cd801>] :scsi_transport_spi:spi_dv_retrain+0x4e/0x240
> [ 1818.664139]  [<ffffffff880ce008>] :scsi_transport_spi:spi_dv_device+0x615/0x69c
> [ 1818.671542]  [<ffffffff880f16d1>] :mptspi:mptspi_dv_device+0xb3/0x14b
> [ 1818.678042]  [<ffffffff880f27d3>] :mptspi:mptspi_dv_renegotiate_work+0xcb/0xef
> [ 1818.685348]  [<ffffffff80245bb8>] run_workqueue+0x8e/0x120
> [ 1818.690905]  [<ffffffff80245d50>] worker_thread+0x106/0x117
> [ 1818.696540]  [<ffffffff80249672>] kthread+0x4b/0x82
> [ 1818.701474]  [<ffffffff8020ab28>] child_rip+0xa/0x12
> [ 1818.706495]
> [ 1818.708022] unionfs-fuse- D 000001a76ef63463     0  1119      1 (NOTLB)
> [ 1818.714764]  ffff810129765988 0000000000000082 0000000000000000 ffffffff80337e22
> [ 1818.722329]  ffff8101297658c8 ffff81012b652f20 ffff810129eec810 0000000600000000
> [ 1818.729895]  000000010005204e 0000000000000000 ffff81000105c400 0000000680337c3e
> [ 1818.737249] Call Trace:
> [ 1818.739953]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
> [ 1818.745673]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
> [ 1818.751664]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
> [ 1818.757300]  [<ffffffff80269b24>] balance_dirty_pages_ratelimited_nr+0x196/0x22f
> [ 1818.764781]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
> [ 1818.771641]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
> [ 1818.778852]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
> [ 1818.785101]  [<ffffffff8032eb94>] nfs_file_write+0x138/0x1b7
> [ 1818.790822]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
> [ 1818.796372]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
> [ 1818.801575]  [<ffffffff8028d5df>] sys_pwrite64+0x68/0x96
> [ 1818.806959]  [<ffffffff80209d0e>] system_call+0x7e/0x83
> [ 1818.812250]  [<00002b4eeec3ea73>]
>
> [snippage]
>

Possibly your device driver had conniptions and stopped generating
completion interrupts.

Which driver is in use?

I don't suppose it is repeatable.
