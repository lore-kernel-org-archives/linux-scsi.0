From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [BusLogic] DMA-API: device driver failed to check map error
Date: Tue, 10 Sep 2013 12:36:46 +0000
Message-ID: <1378816604.6973.53.camel@dabdike.int.hansenpartnership.com>
References: <201309101503.ECC18788.SOOVOJLFtQHMFF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201309101503.ECC18788.SOOVOJLFtQHMFF@I-love.SAKURA.ne.jp>
Content-Language: en-US
Content-ID: <54C6ECA8ED823F46A5C070162FBE5239@sw.swsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "khalid@gonehiking.org" <khalid@gonehiking.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add missing cc of linux-scsi

On Tue, 2013-09-10 at 15:03 +0900, Tetsuo Handa wrote:
> Hello.
> 
> I got below warning on current linux.git .
> 
> ----------
> [    2.612237] scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
> [    2.613067] scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
> [    2.630942] scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
> [    2.633063] scsi0:   Firmware Version: 5.07B, I/O Address: 0x10C0, IRQ Channel: 17/Level
> [    2.633125] scsi0:   PCI Bus: 0, Device: 16, Address: 0xD8800000, Host Adapter SCSI ID: 7
> [    2.633188] scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
> [    2.633250] scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
> [    2.635721] scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
> [    2.637054] scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
> [    2.637116] scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
> [    2.637179] scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
> [    2.639812] scsi0: *** BusLogic BT-958 Initialized Successfully ***
> [    4.635828] scsi0 : BusLogic BT-958
> [    4.641883] [sched_delayed] sched: RT throttling activated
> [    4.647510] ------------[ cut here ]------------
> [    4.647573] WARNING: CPU: 1 PID: 1 at lib/dma-debug.c:937 check_unmap+0x777/0x7f0()
> [    4.648851] pci 0000:00:10.0: DMA-API: device driver failed to check map error[device address=0x00000000349cddc0] [size=96 bytes] [mapped as single]
> [    4.649873] Modules linked in:
> [    4.649873] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-08716-g26b0332-dirty #8
> [    4.649873] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
> [    4.649873]  000003a9 00000000 f64b7de4 c11e8096 f64b7df0 c11e80dd c1210437 f64b7e1c
> [    4.649873]  c10421b9 c1519440 f64b7e4c 00000001 c1518220 000003a9 c1210437 f64b7e2c
> [    4.649873]  00000001 f64b7ea4 f64b7e38 c1042211 00000009 f64b7e2c c1519440 f64b7e4c
> [    4.649873] Call Trace:
> [    4.649873]  [<c11e8096>] __dump_stack+0x16/0x20
> [    4.649873]  [<c11e80dd>] dump_stack+0x3d/0x60
> [    4.649873]  [<c1210437>] ? check_unmap+0x777/0x7f0
> [    4.649873]  [<c10421b9>] warn_slowpath_common+0x79/0xa0
> [    4.649873]  [<c1210437>] ? check_unmap+0x777/0x7f0
> [    4.649873]  [<c1042211>] warn_slowpath_fmt+0x31/0x40
> [    4.649873]  [<c1210437>] check_unmap+0x777/0x7f0
> [    4.649873]  [<c1210e18>] debug_dma_unmap_page+0x78/0x90
> [    4.649873]  [<c1289703>] blogic_dealloc_ccb+0x83/0xb0
> [    4.649873]  [<c128a847>] blogic_process_ccbs+0x3c7/0x3f0
> [    4.649873]  [<c128a423>] ? blogic_scan_inbox+0x43/0xa0
> [    4.649873]  [<c128a8f1>] blogic_inthandler+0x81/0x150
> [    4.649873]  [<c10a9b4e>] ? handle_irq_event+0x2e/0x60
> [    4.649873]  [<c10a9a38>] handle_irq_event_percpu+0x38/0x120
> [    4.649873]  [<c10a9b4e>] ? handle_irq_event+0x2e/0x60
> [    4.649873]  [<c10a9b57>] handle_irq_event+0x37/0x60
> [    4.649873]  [<c10ac4d0>] ? handle_level_irq+0xb0/0xb0
> [    4.649873]  [<c10ac557>] handle_fasteoi_irq+0x87/0xc0
> [    4.649873]  <IRQ>  [<c1003fdc>] ? do_IRQ+0x3c/0xb0
> [    4.649873]  [<c10948ca>] ? mark_held_locks+0xca/0x100
> [    4.649873]  [<c13c9111>] ? common_interrupt+0x31/0x36
> [    4.649873]  [<c13c77e7>] ? _raw_spin_unlock_irqrestore+0x47/0x60
> [    4.649873]  [<c128b05e>] ? blogic_qcmd+0x3e/0x50
> [    4.649873]  [<c127c2f4>] ? scsi_dispatch_cmd+0x174/0x1f0
> [    4.649873]  [<c1094b2b>] ? trace_hardirqs_on+0xb/0x10
> [    4.649873]  [<c1282e54>] ? scsi_request_fn+0x314/0x3a0
> [    4.649873]  [<c11d364b>] ? __blk_run_queue+0x2b/0x40
> [    4.649873]  [<c11d9c42>] ? blk_execute_rq_nowait+0xa2/0xd0
> [    4.649873]  [<c11d9b70>] ? blk_rq_map_kern+0x130/0x130
> [    4.649873]  [<c11d9cfa>] ? blk_execute_rq+0x8a/0xf0
> [    4.649873]  [<c11d9b70>] ? blk_rq_map_kern+0x130/0x130
> [    4.649873]  [<c11d9f4e>] ? blk_recount_segments+0x1e/0x40
> [    4.649873]  [<c11d0000>] ? aes_encrypt+0xe40/0x1450
> [    4.649873]  [<c11d9b4f>] ? blk_rq_map_kern+0x10f/0x130
> [    4.649873]  [<c1281834>] ? scsi_execute+0xe4/0x150
> [    4.649873]  [<c128190e>] ? scsi_execute_req_flags+0x6e/0xa0
> [    4.649873]  [<c1284972>] ? scsi_probe_lun+0x112/0x300
> [    4.649873]  [<c128512d>] ? scsi_probe_and_add_lun+0x10d/0x2f0
> [    4.649873]  [<c1284358>] ? scsi_alloc_sdev+0x248/0x2b0
> [    4.649873]  [<c128514d>] ? scsi_probe_and_add_lun+0x12d/0x2f0
> [    4.649873]  [<c1259340>] ? anon_transport_class_unregister+0x30/0x30
> [    4.649873]  [<c12846c8>] ? scsi_alloc_target+0x1c8/0x220
> [    4.649873]  [<c1285b00>] ? __scsi_scan_target+0xa0/0xf0
> [    4.649873]  [<c1285c4a>] ? scsi_scan_channel+0x5a/0x90
> [    4.649873]  [<c1285d79>] ? scsi_scan_host_selected+0xf9/0x140
> [    4.649873]  [<c12860c9>] ? do_scsi_scan_host+0x69/0x80
> [    4.649873]  [<c1286130>] ? scsi_scan_host+0x30/0x50
> [    4.649873]  [<c15f6d1c>] ? blogic_init+0x32c/0x3b0
> [    4.649873]  [<c15f69f0>] ? blogic_inithoststruct+0x80/0x80
> [    4.649873]  [<c1000472>] ? do_one_initcall+0x32/0xd0
> [    4.649873]  [<c105fa60>] ? parse_one+0xc0/0xe0
> [    4.649873]  [<c105fc0a>] ? parse_args+0x7a/0x170
> [    4.649873]  [<c15cb410>] ? loglevel+0x30/0x30
> [    4.649873]  [<c15cbb6a>] ? do_initcall_level+0x7a/0x90
> [    4.649873]  [<c15cb410>] ? loglevel+0x30/0x30
> [    4.649873]  [<c15cbb98>] ? do_initcalls+0x18/0x20
> [    4.649873]  [<c15cbbc8>] ? do_basic_setup+0x28/0x30
> [    4.649873]  [<c15cbc7f>] ? kernel_init_freeable+0x5f/0xf0
> [    4.649873]  [<c13c173b>] ? kernel_init+0xb/0xe0
> [    4.649873]  [<c13c8c18>] ? ret_from_kernel_thread+0x1c/0x2c
> [    4.649873]  [<c13c1730>] ? rest_init+0x140/0x140
> [    4.649873] ---[ end trace d5c0cda419f9730c ]---
> [    4.649873] Mapped at:
> [    4.649873]  [<c1210c44>] debug_dma_map_page+0x64/0x140
> [    4.649873]  [<c128af55>] blogic_qcmd_lck+0x485/0x550
> [    4.649873]  [<c128b052>] blogic_qcmd+0x32/0x50
> [    4.649873]  [<c127c2f4>] scsi_dispatch_cmd+0x174/0x1f0
> [    4.649873]  [<c1282e54>] scsi_request_fn+0x314/0x3a0
> [    4.664545] scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
> [    4.692725] sd 0:0:0:0: [sda] 83886080 512-byte logical blocks: (42.9 GB/40.0 GiB)
> [    4.695383] sd 0:0:0:0: [sda] Write Protect is off
> [    4.697271] sd 0:0:0:0: Attached scsi generic sg0 type 0
> ----------
> 
> $ addr2line -e vmlinux c128b052
> drivers/scsi/BusLogic.c:3231 => blogic_qcmd_lck
> 
> $ addr2line -e vmlinux c128af55
> include/asm-generic/pci-dma-compat.h:31 => pci_map_single
> 
> The location seems to be pci_map_single() in blogic_qcmd_lck().
> 
>         memcpy(ccb->cdb, cdb, cdblen);
>         ccb->sense_datalen = SCSI_SENSE_BUFFERSIZE;
>         ccb->sensedata = pci_map_single(adapter->pci_device,
>                                 command->sense_buffer, ccb->sense_datalen,
>                                 PCI_DMA_FROMDEVICE);
>         ccb->command = command;
>         command->scsi_done = comp_cb;
> 
> Regards.
