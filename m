From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: Oops: NULL pointer dereference - RIP:
 isci_task_abort_task+0x30/0x3e0 [isci]
Date: Sat, 6 Jan 2018 21:08:11 +0100
Message-ID: <5cb9f5ae-8f30-8387-c76b-d99639d90cab@profihost.ag>
References: <20180106095117.67907-1-liwei213@huawei.com>
 <20180106095117.67907-5-liwei213@huawei.com> <aa608fb4gp.fsf_-_@switch.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:15056 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752908AbeAFUIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2018 15:08:15 -0500
In-Reply-To: <aa608fb4gp.fsf_-_@switch.ch>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Leinen <simon.leinen@switch.ch>, Yves-Alexis Perez <corsac@debian.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>


Am 06.01.2018 um 12:40 schrieb Simon Leinen:
> Yves-Alexis Perez wrote:
>> since kernel 4.11 (sorry it took so long to report) I have a box
>> failing to boot with a NULL pointer dereference (the box is stuck
>> there afterwards).
> 
> I get the same result on a Quanta server with several 4.13 and 4.14
> kernels (from the Ubuntu "mainline" and Xenial hwe-edge PPAs).
> 
> This (I guess) problem had been reported by Stefan Priebe under
> "isci regression in 4.11.0-rc2 by scsi: libsas: allow async aborts"
> on 8 November, 2017[1].  That report didn't elicit any response here.

Yes - also Cristoph Hellwig hasn't responded yet. So i reverted that
commit on my own as well.

Stefan

> 
>> The bug has also been reported to the Debian BTS ([2]) and a
>> suggestion to revert 90965761 has been made. I can confirm it fix the
>> boot issue.
> 
> The Debian people have implemented the suggestion to revert 90965761 as
> of their 4.14.12-1 kernel package[2].
> 
>> I don't have the complete stack trace at hand but there's an example
>> in the Debian bug.
> 
> Here's a stack trace from my server.  It was copied and pasted from a
> serial console (IPMI SOL), I hope it's complete.
> 
>   [    9.184043] BUG: unable to handle kernel NULL pointer dereference at           (null)
>   [    9.184055] IP: isci_task_abort_task+0x43/0x400 [isci]
>   [    9.184056] PGD 0
>   [    9.184056] P4D 0
>   [    9.184057]
>   [    9.184058] Oops: 0000 [#1] SMP
>   [    9.184060] Modules linked in: aesni_intel(+) aes_x86_64 crypto_simd glue_helper cryptd mei_me intel_cstate intel_rapl_perf mei shpchp lpc_ich ipmi_si(+) mac_hid kvm_intel kvm irqbypass ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ipmi_devintf ipmi_msghandler autofs4 btrfs xor raid6_pq ast ttm drm_kms_helper ixgbe igb syscopyarea isci sysfillrect i2c_algo_bit dca sysimgblt libsas fb_sys_fops ptp mdio drm scsi_transport_sas pps_core wmi
>   [    9.184084] CPU: 18 PID: 434 Comm: kworker/u48:1 Not tainted 4.13.0-21-generic #24~16.04.1-Ubuntu
>   [    9.184084] Hardware name: Quanta S210-X12RS V2/S210-X12RS V2, BIOS S2RQ4A08 08/12/2013
>   [    9.184090] Workqueue: scsi_tmf_0 scmd_eh_abort_handler
>   [    9.184091] task: ffff96507bb05d00 task.stack: ffffa2de87bb4000
>   [    9.184095] RIP: 0010:isci_task_abort_task+0x43/0x400 [isci]
>   [    9.184095] RSP: 0018:ffffa2de87bb7c88 EFLAGS: 00010246
>   [    9.184096] RAX: 0000000000000000 RBX: ffff9650782f11a8 RCX: 0000000000000000
>   [    9.184097] RDX: 0000000000000000 RSI: ffff9650782f11a8 RDI: 0000000000000000
>   [    9.184097] RBP: ffffa2de87bb7e28 R08: 0000000000000000 R09: 0000000000000001
>   [    9.184098] R10: 000000000000b8cb R11: 00000000000002f3 R12: ffff9650782f1148
>   [    9.184098] R13: ffff9650758cb800 R14: 0000000000000008 R15: 0000000000000000
>   [    9.184099] FS:  0000000000000000(0000) GS:ffff9660bf380000(0000) knlGS:0000000000000000
>   [    9.184100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [    9.184100] CR2: 0000000000000000 CR3: 000000004b009000 CR4: 00000000001406e0
>   [    9.184101] Call Trace:
>   [    9.184107]  ? cpumask_next_and+0x31/0x50
>   [    9.184110]  ? load_balance+0x1b5/0x9c0
>   [    9.184114]  ? sched_clock+0x9/0x10
>   [    9.184116]  ? sched_clock+0x9/0x10
>   [    9.184117]  ? sched_clock+0x9/0x10
>   [    9.184120]  ? sched_clock_cpu+0x11/0xb0
>   [    9.184121]  ? pick_next_task_fair+0x3c7/0x560
>   [    9.184123]  ? __switch_to+0x211/0x510
>   [    9.184125]  ? put_prev_entity+0x27/0x100
>   [    9.184129]  sas_eh_abort_handler+0x30/0x50 [libsas]
>   [    9.184131]  scmd_eh_abort_handler+0x74/0x230
>   [    9.184135]  process_one_work+0x156/0x410
>   [    9.184136]  worker_thread+0x4b/0x460
>   [    9.184138]  kthread+0x109/0x140
>   [    9.184139]  ? process_one_work+0x410/0x410
>   [    9.184140]  ? kthread_create_on_node+0x70/0x70
>   [    9.184143]  ret_from_fork+0x25/0x30
>   [    9.184144] Code: 08 48 81 ec 78 01 00 00 c7 85 78 fe ff ff 00 00 00 00 c7 85 80 fe ff ff 00 00 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 <48> 8b 07 48 8b 40 30 48 8b 80 90 02 00 00 4c 8b a0 28 01 00 00
>   [    9.184160] RIP: isci_task_abort_task+0x43/0x400 [isci] RSP: ffffa2de87bb7c88
>   [    9.184161] CR2: 0000000000000000
>   [    9.184162] ---[ end trace bf9920b58fca631f ]---
> 
>> The machine is a Dell Precision T5600 with the following SATA
>> controllers:
> 
>> 00:1f.2 SATA controller: Intel Corporation C600/X79 series chipset 6-Port SATA
>> AHCI Controller (rev 05)
>> 05:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset 4-Port 
>> SATA Storage Control Unit (rev 05)
> 
> Mine is a Quanta S210-X12RS server with only one SATA controller:
> 
> 08:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset 4-Port SATA Storage Control Unit (rev 05)
> 
> Connected to that SATA controller are two Samsung 850 EVO 250GB SSDs and
> one 3TB WD Red disk.
> 
>> If you need more information or need me to test something, please ask.
> 
> Likewise.
> 
> Best regards,
> 
