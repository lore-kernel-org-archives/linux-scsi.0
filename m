From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
 [kworker/1:1:29]
Date: Thu, 31 Dec 2015 18:04:15 +0100
Message-ID: <20151231180415.00000bfc@localhost>
References: <20151217222737.00000ab6@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61803 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbLaREa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 12:04:30 -0500
In-Reply-To: <20151217222737.00000ab6@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Sebastian Herbszt <herbszt@gmx.de>

I wrote:
> I got the following lockup on openSUSEs 4.4.0-rc5-2.g1e923a3-default kernel
> while unloading the lpfc module:
> 
> [  444.088002] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:1:29]
> [  444.088002] Modules linked in: lpfc(-) qla2x00tgt(O) qla2xxx_scst(O) scst_vdisk(O) scsi_transport_fc libcrc32c scst(O) dlm configfs nfsd lockd grace nfs_acl auth_rpcgss sunrpc ed
> d snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device dm_mod iTCO_wdt snd_hda_codec_realtek snd_hda_codec_generic gpio_ich iTCO_vendor_support ppdev snd_hda_intel snd_hda_codec snd_hda
> _core snd_hwdep tg3 snd_pcm snd_timer libphy lpc_ich parport_pc ptp acpi_cpufreq snd pps_core fjes parport i2c_i801 ehci_pci tpm_tis tpm sr_mod cdrom soundcore floppy hwmon sg 8250_
> fintek pcspkr i915 drm_kms_helper uhci_hcd ehci_hcd drm fb_sys_fops sysimgblt sysfillrect syscopyarea i2c_algo_bit usbcore button video usb_common fan ata_generic ata_piix libata th
> ermal
> [  444.088002] CPU: 1 PID: 29 Comm: kworker/1:1 Tainted: G           O    4.4.0-rc5-2.g1e923a3-default #1
> [  444.088002] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
> [  444.088002] Workqueue: fc_wq_4 fc_rport_final_delete [scsi_transport_fc]
> [  444.088002] task: f6266ec0 ti: f6268000 task.ti: f6268000
> [  444.088002] EIP: 0060:[<c07e7044>] EFLAGS: 00000286 CPU: 1
> [  444.088002] EIP is at _raw_spin_unlock_irqrestore+0x14/0x20
> [  444.088002] EAX: 00000286 EBX: f20d3800 ECX: 00000002 EDX: 00000286
> [  444.088002] ESI: f50ba800 EDI: f2146848 EBP: f6269ec8 ESP: f6269ec8
> [  444.088002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  444.088002] CR0: 8005003b CR2: 08f96600 CR3: 363ae000 CR4: 000006d0
> [  444.088002] Stack:
> [  444.088002]  f6269eec c066b0f7 00000286 f2146848 f50ba808 f50ba800 f50ba800 f2146a90
> [  444.088002]  f2146848 f6269f08 f8f0a4ed f3141000 f2146800 f2146a90 f619fa00 00000040
> [  444.088002]  f6269f40 c026cb25 00000001 166c6392 00000061 f6757140 f6136340 00000004
> [  444.088002] Call Trace:
> [  444.088002]  [<c066b0f7>] scsi_remove_target+0x167/0x1c0
> [  444.088002]  [<f8f0a4ed>] fc_rport_final_delete+0x9d/0x1e0 [scsi_transport_fc]
> [  444.088002]  [<c026cb25>] process_one_work+0x155/0x3e0
> [  444.088002]  [<c026cde7>] worker_thread+0x37/0x490
> [  444.088002]  [<c027214b>] kthread+0x9b/0xb0
> [  444.088002]  [<c07e72c1>] ret_from_kernel_thread+0x21/0x40
> [  444.088002] DWARF2 unwinder stuck at ret_from_kernel_thread+0x21/0x40
> [  444.088002]
> [  444.088002] Leftover inexact backtrace:
> [  444.088002]  [<c02720b0>] ? kthread_park+0x50/0x50
> [  444.088002] Code: c8 e8 41 7f ab ff 89 d8 5b 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 3e 8d 74 26 00 0f ae f0 89 f6 c6 00 00 89 d0 50 9d <8d> 74 26 00 5d c3 8d b6 00 00 00 00 55 89 e5 3e 8d 74 26 00 0f
> [  444.088002] Kernel panic - not syncing: softlockup: hung tasks
> [  444.088002] CPU: 1 PID: 29 Comm: kworker/1:1 Tainted: G           O L  4.4.0-rc5-2.g1e923a3-default #1
> [  444.088002] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
> [  444.088002] Workqueue: fc_wq_4 fc_rport_final_delete [scsi_transport_fc]
> [  444.088002]  00000000 00000000 f6269da4 c0518e08 00000016 f6269dbc c034faa0 f6266ec0
> [  444.088002]  00000016 f6266ec0 00000000 f6269df0 c0303f54 c09a6589 00000001 00000016
> [  444.088002]  f62672ac 0000001d f6269e8c 00000000 00000187 f67506c0 f6750700 f6750a60
> [  444.088002] Call Trace:
> [  444.088002]  [<c0206092>] try_stack_unwind+0x132/0x140
> [  444.088002]  [<c02052a4>] dump_trace+0x54/0x200
> [  444.088002]  [<c02060e6>] show_trace_log_lvl+0x46/0x50
> [  444.088002]  [<c020551b>] show_stack_log_lvl+0xcb/0x110
> [  444.088002]  [<c0206176>] show_stack+0x26/0x50
> [  444.088002]  [<c0518e08>] dump_stack+0x41/0x59
> [  444.088002]  [<c034faa0>] panic+0x81/0x1b4
> [  444.088002]  [<c0303f54>] watchdog_timer_fn+0x1e4/0x1f0
> [  444.088002]  [<c02bf3a0>] __hrtimer_run_queues+0xc0/0x240
> [  444.088002]  [<c02bfc3a>] hrtimer_interrupt+0x8a/0x190
> [  444.088002]  [<c0239a32>] local_apic_timer_interrupt+0x32/0x60
> [  444.088002]  [<c07e8713>] smp_apic_timer_interrupt+0x33/0x50
> [  444.088002]  [<c07e7e34>] apic_timer_interrupt+0x34/0x40
> [  444.088002] DWARF2 unwinder stuck at apic_timer_interrupt+0x34/0x40
> [  444.088002]
> [  444.088002] Leftover inexact backtrace:
> [  444.088002]  [<c06300e0>] ? mipi_dsi_host_register+0x30/0x1d0
> [  444.088002]  [<c07e7044>] ? _raw_spin_unlock_irqrestore+0x14/0x20
> [  444.088002]  [<c066b0f7>] scsi_remove_target+0x167/0x1c0
> [  444.088002]  [<f8f0a4ed>] fc_rport_final_delete+0x9d/0x1e0 [scsi_transport_fc]
> [  444.088002]  [<c026cb25>] process_one_work+0x155/0x3e0
> [  444.088002]  [<c026cde7>] worker_thread+0x37/0x490
> [  444.088002]  [<c026cdb0>] ? process_one_work+0x3e0/0x3e0
> [  444.088002]  [<c027214b>] kthread+0x9b/0xb0
> [  444.088002]  [<c07e72c1>] ret_from_kernel_thread+0x21/0x40
> [  444.088002]  [<c02720b0>] ? kthread_park+0x50/0x50

I still get this on 4.4.0-rc7-1.g276c9f4-default. Since this did not
happen on 4.3 I checked the scsi changes and found the following commit:

scsi: restart list search after unlock in scsi_remove_target

Christoph, can it cause this issue?

Sebastian
