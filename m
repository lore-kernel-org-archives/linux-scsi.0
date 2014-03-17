From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: DMA-API mapping errors in vmw_pvscsi
Date: Mon, 17 Mar 2014 12:52:02 -0400
Message-ID: <CA+5PVA5CmTJSjaikwtTTLwp1dLwFkYpXVr56ASA4t5n8ESRmOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53650 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaCQQwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 12:52:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>

Hi All,

We've had a few reports[1][2] now on the vmw_pvscsi driver throwing
DMA-API mapping errors when the DMA_API_DEBUG option is enabled.  I've
included one from a recent 3.14-rc6 kernel below.  Looking at
vmw_pvscsi.c, I can see pvscsi_map_buffers is missing the calls to
pci_dma_mapping_error, which is what causes the warnings to be thrown.

However, I'm not familiar with this driver and I can't see what the
proper error path should be in this case.  pvscsi_map_buffers is a
void function and doesn't currently have the ability to return an
error to the caller.  Even if it did, I'm not sure what the proper
response to an error should be.  Thoughts?

josh

[    2.962772] ------------[ cut here ]------------
[    2.963764] WARNING: CPU: 1 PID: 6 at lib/dma-debug.c:1140
check_unmap+0x4ee/0x9e0()
[    2.965382] vmw_pvscsi 0000:03:00.0: DMA-API: device driver failed
to check map error[device address=0x0000000078520f80] [size=96 bytes]
[mapped as single]
[    2.968214] Modules linked in:
[    2.968897]  vmwgfx(+) ttm drm ata_generic vmw_pvscsi(+) i2c_core pata_acpi
[    2.970302] CPU: 1 PID: 6 Comm: kworker/u4:0 Not tainted
3.14.0-0.rc6.git4.1.fc21.x86_64 #1
[    2.972028] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 07/30/2013
[    2.974230] Workqueue: events_unbound async_run_entry_fn
[    2.975375]  0000000000000000 000000003e328dbc ffff88007fc03bf0
ffffffff817d19a8
[    2.977032]  ffff88007fc03c38 ffff88007fc03c28 ffffffff8109671d
ffff88007bf63540
[    2.978694]  ffff88007bc52e50 ffffffff82d74a90 0000000000000082
ffffffff81a2cce8
[    2.980352] Call Trace:
[    2.980882]  <IRQ>  [<ffffffff817d19a8>] dump_stack+0x4d/0x66
[    2.982147]  [<ffffffff8109671d>] warn_slowpath_common+0x7d/0xa0
[    2.983398]  [<ffffffff8109679c>] warn_slowpath_fmt+0x5c/0x80
[    2.984606]  [<ffffffff813f5bfe>] check_unmap+0x4ee/0x9e0
[    2.985731]  [<ffffffff813f6160>] debug_dma_unmap_page+0x70/0x90
[    2.986981]  [<ffffffffa00196e3>]
pvscsi_unmap_buffers.isra.12+0x123/0x200 [vmw_pvscsi]
[    2.988635]  [<ffffffffa00198c6>]
pvscsi_process_completion_ring+0x106/0x2f0 [vmw_pvscsi]
[    2.990325]  [<ffffffffa0019b64>] pvscsi_isr+0x34/0xa0 [vmw_pvscsi]
[    2.991631]  [<ffffffff8110e26e>] handle_irq_event_percpu+0x3e/0x370
[    2.992952]  [<ffffffff8110e5dd>] handle_irq_event+0x3d/0x60
[    2.994129]  [<ffffffff811112c7>] handle_edge_irq+0x77/0x130
[    2.995320]  [<ffffffff8101dd6f>] handle_irq+0xbf/0x150
[    2.996413]  [<ffffffff8109da62>] ? irq_enter+0x42/0x90
[    2.997514]  [<ffffffff817e7b0f>] do_IRQ+0x4f/0xf0
[    2.998521]  [<ffffffff817db8f2>] common_interrupt+0x72/0x72
[    2.999703]  <EOI>  [<ffffffff817dabab>] ?
_raw_spin_unlock_irqrestore+0x3b/0x70
[    3.001587]  [<ffffffffa001a7c0>] pvscsi_queue+0x130/0x840 [vmw_pvscsi]
[    3.002970]  [<ffffffff8151cbe0>] ?
ftrace_raw_event_scsi_dispatch_cmd_error+0x220/0x220
[    3.004681]  [<ffffffff8151d2f7>] scsi_dispatch_cmd+0xb7/0x4e0
[    3.006095]  [<ffffffff8152575c>] scsi_request_fn+0x33c/0x540
[    3.007299]  [<ffffffff81396003>] __blk_run_queue+0x33/0x40
[    3.008464]  [<ffffffff813a0799>] blk_execute_rq_nowait+0xa9/0x140
[    3.009751]  [<ffffffff813a0993>] blk_execute_rq+0x133/0x1e0
[    3.010954]  [<ffffffff81272639>] ? bio_phys_segments+0x19/0x20
[    3.012195]  [<ffffffff8139bbb2>] ? blk_rq_bio_prep+0x72/0xf0
[    3.013393]  [<ffffffff81524207>] scsi_execute+0xd7/0x160
[    3.014523]  [<ffffffff81525a4c>] scsi_execute_req_flags+0x8c/0x100
[    3.015833]  [<ffffffff81527f95>] scsi_probe_and_add_lun+0x235/0xc50
[    3.036404]  [<ffffffff8150943c>] ? __pm_runtime_resume+0x5c/0x90
[    3.037679]  [<ffffffff81528e70>] __scsi_scan_target+0x110/0x6d0
[    3.038936]  [<ffffffff817daba6>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[    3.040345]  [<ffffffff810f8b45>] ? trace_hardirqs_on_caller+0x105/0x1d0
[    3.041741]  [<ffffffff810f8c1d>] ? trace_hardirqs_on+0xd/0x10
[    3.042957]  [<ffffffff815295a6>] scsi_scan_channel.part.6+0x66/0x90
[    3.044288]  [<ffffffff81529769>] scsi_scan_host_selected+0xf9/0x1c0
[    3.045773]  [<ffffffff815298c1>] do_scsi_scan_host+0x91/0xa0
[    3.046977]  [<ffffffff81529a9c>] do_scan_async+0x1c/0x160
[    3.048125]  [<ffffffff810cc629>] async_run_entry_fn+0x39/0x120
[    3.049358]  [<ffffffff810bba30>] process_one_work+0x220/0x6f0
[    3.050572]  [<ffffffff810bb9c4>] ? process_one_work+0x1b4/0x6f0
[    3.051822]  [<ffffffff810bc01b>] worker_thread+0x11b/0x3a0
[    3.052987]  [<ffffffff810bbf00>] ? process_one_work+0x6f0/0x6f0
[    3.054239]  [<ffffffff810c43bf>] kthread+0xff/0x120
[    3.055285]  [<ffffffff810c42c0>] ? insert_kthread_work+0x80/0x80
[    3.056558]  [<ffffffff817e577c>] ret_from_fork+0x7c/0xb0
[    3.057686]  [<ffffffff810c42c0>] ? insert_kthread_work+0x80/0x80
[    3.058954] ---[ end trace df8f36ebf71b314f ]---
[    3.059922] Mapped at:
[    3.060431]  [<ffffffff813f4821>] debug_dma_map_page+0x91/0x140
[    3.061699]  [<ffffffffa001a911>] pvscsi_queue+0x281/0x840 [vmw_pvscsi]
[    3.063105]  [<ffffffff8151d2f7>] scsi_dispatch_cmd+0xb7/0x4e0
[    3.064351]  [<ffffffff8152575c>] scsi_request_fn+0x33c/0x540
[    3.065607]  [<ffffffff81396003>] __blk_run_queue+0x33/0x40


[1] https://bugzilla.redhat.com/show_bug.cgi?id=926917
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1077118
