From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Tue, 14 Apr 2015 14:41:16 -0700
Message-ID: <CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	<1429046165.2209.54.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36673 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbDNVlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 17:41:19 -0400
Received: by wgsk9 with SMTP id k9so26745285wgs.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2015 14:41:16 -0700 (PDT)
In-Reply-To: <1429046165.2209.54.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Removing the sas expander and attaching the SATA drives directly works
just fine. I had to limp along with the drives direct attached for a
while, while debugging.

Here is the dump from: Linux version 3.15.1-031501-generic.  Just tested it.
[    8.455203] scsi4 : mvsas
[    8.663885] floppy0: no floppy controllers found
[    8.720580] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000254
[    8.728583] IP: [<ffffffffa006f5b0>] mvs_task_prep_ata+0x80/0x3a0 [mvsas]
[    8.735470] PGD 0
[    8.737586] Oops: 0000 [#1] SMP
[    8.740965] Modules linked in: uas hid_generic usbkbd usbmouse
usbhid hid e1000e mvsas ptp libsas pata_acpi pps_core
scsi_transport_sas
[    8.753918] CPU: 3 PID: 193 Comm: kworker/u16:8 Not tainted
3.15.1-031501-generic #201406161841
[    8.762677] Hardware name: Supermicro X8SIE/X8SIE, BIOS 1.2a       06/27/2012
[    8.769863] Workqueue: events_unbound async_run_entry_fn
[    8.775268] task: ffff88032a031930 ti: ffff88032a038000 task.ti:
ffff88032a038000
[    8.782814] RIP: 0010:[<ffffffffa006f5b0>]  [<ffffffffa006f5b0>]
mvs_task_prep_ata+0x80/0x3a0 [mvsas]
[    8.792146] RSP: 0018:ffff88032a03b7c8  EFLAGS: 00010097
[    8.797508] RAX: 0000000000000030 RBX: ffff88032a780000 RCX: 0000000000000000
[    8.804691] RDX: ffff88032a7838c0 RSI: ffff88032a7a5668 RDI: ffff88032a780000
[    8.811873] RBP: ffff88032a03b838 R08: 0000000000000002 R09: 0000000000001000
[    8.819056] R10: 0000000000040000 R11: ffff88032a7a5660 R12: ffff88032a60c280
[    8.826239] R13: ffff88032a03b898 R14: ffff88032a758080 R15: ffff88032b2c7000
[    8.833422] FS:  0000000000000000(0000) GS:ffff88033fcc0000(0000)
knlGS:0000000000000000
[    8.841575] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    8.847373] CR2: 0000000000000254 CR3: 0000000001c12000 CR4: 00000000000007e0
[    8.854556] Stack:
[    8.856617]  ffff88032a03b818 ffffffff00000002 ffff88032a03b7f8
0000000000000000
[    8.864277]  ffff88032a7838c0 0000000000000046 ffff88032a781e38
ffffffff811a435e
[    8.871936]  0000000000014500 ffff88032a60c280 ffff88032a7838c0
ffff88032a780000
[    8.879604] Call Trace:
[    8.882104]  [<ffffffff811a435e>] ? dma_pool_alloc+0xce/0x100
[    8.887897]  [<ffffffffa00704bb>] mvs_task_prep+0x58b/0x620 [mvsas]
[    8.894214]  [<ffffffffa00705b8>] mvs_task_exec.isra.14+0x68/0xf0 [mvsas]
[    8.901051]  [<ffffffffa0071159>] mvs_queue_command+0x39/0x40 [mvsas]
[    8.907542]  [<ffffffffa00568ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas]
[    8.914203]  [<ffffffffa0051e1f>] ? sas_ex_phy_discover+0xaf/0xe0 [libsas]
[    8.921127]  [<ffffffff8152520f>] ata_qc_issue+0x18f/0x2d0
[    8.926660]  [<ffffffff81525648>] ata_exec_internal_sg+0x2f8/0x5d0
[    8.932891]  [<ffffffff81525992>] ata_exec_internal+0x72/0xb0
[    8.938686]  [<ffffffff8152618a>] ata_do_dev_read_id+0x2a/0x30
[    8.944572]  [<ffffffffa00564b0>] ?
sas_ata_internal_abort+0x120/0x120 [libsas]
[    8.951945]  [<ffffffff815263d5>] ata_dev_read_id+0x245/0x460
[    8.957741]  [<ffffffff81532b1c>] ? ata_eh_reset+0x24c/0xe20
[    8.963452]  [<ffffffff81531a78>] ata_eh_revalidate_and_attach+0x198/0x3a0
[    8.970373]  [<ffffffff81533ee9>] ata_eh_recover+0x599/0x7e0
[    8.976084]  [<ffffffff815283e0>] ? sata_print_link_status+0xc0/0xc0
[    8.982488]  [<ffffffffa00564b0>] ?
sas_ata_internal_abort+0x120/0x120 [libsas]
[    8.989858]  [<ffffffff81528930>] ? sata_std_hardreset+0x50/0x50
[    8.995916]  [<ffffffffa00564b0>] ?
sas_ata_internal_abort+0x120/0x120 [libsas]
[    9.003289]  [<ffffffff81528930>] ? sata_std_hardreset+0x50/0x50
[    9.009347]  [<ffffffffa00564b0>] ?
sas_ata_internal_abort+0x120/0x120 [libsas]
[    9.016719]  [<ffffffff815348c2>] ata_do_eh+0x52/0xc0
[    9.021823]  [<ffffffff815283e0>] ? sata_print_link_status+0xc0/0xc0
[    9.028225]  [<ffffffff81534977>] ata_std_error_handler+0x47/0x80
[    9.034370]  [<ffffffff8152fa78>] ? ata_eh_handle_port_resume+0x38/0x160
[    9.041119]  [<ffffffff8153459b>] ata_scsi_port_error_handler+0x39b/0x5a0
[    9.047956]  [<ffffffffa00562c5>] async_sas_ata_eh+0x55/0x90 [libsas]
[    9.054444]  [<ffffffff8109770b>] async_run_entry_fn+0x3b/0x140
[    9.060415]  [<ffffffff8108935f>] process_one_work+0x17f/0x4c0
[    9.066298]  [<ffffffff8108a57b>] worker_thread+0x11b/0x3d0
[    9.071921]  [<ffffffff8108a460>] ? manage_workers.isra.21+0x190/0x190
[    9.078496]  [<ffffffff810913c9>] kthread+0xc9/0xe0
[    9.083427]  [<ffffffff81091300>] ? flush_kthread_worker+0xb0/0xb0
[    9.089657]  [<ffffffff817845bc>] ret_from_fork+0x7c/0xb0
[    9.095106]  [<ffffffff81091300>] ? flush_kthread_worker+0xb0/0xb0
[    9.101335] Code: 00 00 48 8b 0c c8 0f 84 a7 02 00 00 44 89 c0 41
b9 00 10 00 00 48 8d 34 80 48 8d 04 70 48 8d b4 c3 b8 55 02 00 8b 43
58 89 46 1c <8b> 89 54 02 00 00 44 89 c0 8b 7b 58 0d 00 00 00 70 4c 8b
53 48
[    9.123612] RIP  [<ffffffffa006f5b0>] mvs_task_prep_ata+0x80/0x3a0 [mvsas]
[    9.130587]  RSP <ffff88032a03b7c8>
[    9.134121] CR2: 0000000000000254
[    9.137484] ---[ end trace 626da177ae6396db ]---

On Tue, Apr 14, 2015 at 2:16 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2015-04-14 at 14:03 -0700, Adam Talbot wrote:
>> To make a very long debugging story short, I think there is an issues/bug
>> with the mvsas driver. It works, with older kernels, and breaks on
>> newer kernels.
>>
>> My Debian Jessie system was running great on a 3.18 kernel.  Changed
>> cases to a newer supermicro case with a SAS expander backplane (SAS933EL).  That
>> was the only hardware change.  Now, when ever I boot, the system kernel panics.
>>
>> 3.2.65-1+deb7u2 works
>> 3.9.0 Gentoo CD works
>> 3.16+ all fail
>> Attached are 3 kernel panics on 3.16+ kernels.
>>
>> Motherboard is a Supermicro X8SIE, with a "Marvell Technology Group Ltd.
>> 88SE6440 SAS/SATA PCIe controller"
>>
>> Is this a known bug?
>
> Well, you're the only person that's reported it so far.
>
> I think based on the above is that your configuration is a single
> expander attached SATA device ... and if you move it to be non expander
> attached it works fine?
>
>> At this point I have two options:
>> Stick with the old kernel (yuck)
>> Buy a new card running a better supported chipset
>>
>> Any help would be greatly appreciated
>> Thanks
>
> You didn't specify: does 3.15 work?  At least the highest working kernel
> version would help me narrow down potential problems.
>
> James
>
>
