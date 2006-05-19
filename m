From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: megaraid driver initialization failure
Date: Fri, 19 May 2006 17:08:24 -0400
Message-ID: <20060519210824.GA19835@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36532 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S964844AbWESVZm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 17:25:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4JLPZct026942
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 17:25:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4JLPZR5182450
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 15:25:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k4JLPZki001734
	for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 15:25:35 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Atul.Mukker@lsil.com, Sreenivas.Bagalkote@lsil.com, Manoj.Jose@lsil.com, Seokmann.Ju@lsil.com

Hi,

I am facing the megaraid driver initialization failure while second kernel
is booting after a crash (kdump). Backtrace is pasted below. I got a 
LSI MegaRAID SATA 150-6 RAID controller in my machine.

This problem is easily reproducible just by making sure that some disk
activity is going on while system crashes. When driver initializes in 
second kernel and it calls request_irq(), immediately it gets an 
interrupt and driver crashes in interrupt handling routine as driver
initialization is not complete yet and it does not expect the controller
to be active at this point of time. 

How to reset the megaraid controller? When I look at the megarad_mbox.c or
megaraid_sas.c, they basically get rid of any pending commands or wait
for firmware to finish outstanding commands.

I am looking at a soft reset kind of functionality where device comes to a
known state, interrupt is de-asserted, any message or mail box is flushed
etc. So that before I request for irq, I shall reset the device and then
go ahead with the rest of the initialization. Any help or pointers are
appreciated.

Thanks
Vivek


megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.7 (Release Date: Monnew deviI Interrupt 0000:03:0c.0[A] -> GSI1
Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP:
<ffffffff81208ba4>{megaraid_ack_sequence+101}
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.17-rc3-16M #5
RIP: 0010:[<ffffffff81208ba4>] <ffffffff81208ba4>{megaraid_ack_sequence+101}
RSP: 0018:ffffffff8148ce88  EFLAGS: 00010046
RAX: 0000000010001234 RBX: ffff81000495e000 RCX: 00000000000034e4
RDX: ffffc20000010000 RSI: 0000000000000246 RDI: ffff8100017f0028
RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000002
R10: ffffffff81146750 R11: ffffffff81146750 R12: 0000000000000000
R13: ffff8100017f0000 R14: 0000000000000296 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8151d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000001001000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff8100017da000, task ffff8100017d9450)
Stack: ffffffff8104e00e 000000018148ceb8 ffffffff8148ce98 ffffffff8148ce98
       0000000000000000 ffffffff813e1d40 ffffffff8100ba15 0000000000000003
       0000000000000022 000000000000000a
Call Trace: <IRQ> <ffffffff8104e00e>{__do_IRQ+213} <ffffffff8100ba15>{do_IRQ+62}       <ffffffff81208d50>{megaraid_isr+42} <ffffffff8104df08>{handle_IRQ_event+}       <ffffffff8104dfcc>{__do_IRQ+147} <ffffffff8100ba10>{do_IRQ+57}
       <ffffffff81009bfc>{ret_from_intr+0} <EOI> <ffffffff81147ccf>{vgacon_scro}       <ffffffff811390db>{number+184} <ffffffff8102fa3f>{release_console_sem+31}       <ffffffff8102fa7b>{release_console_sem+375} <ffffffff81139777>{vsnprintf}       <ffffffff8113999d>{sprintf+144} <ffffffff81016045>{do_flush_tlb_all+0}
       <ffffffff8101620e>{__smp_call_function+35} <ffffffff810162a1>{smp_call_f}       <ffffffff81016045>{do_flush_tlb_all+0} <ffffffff81034af2>{on_each_cpu+25}       <ffffffff8104eb9d>{register_irq_proc+83} <ffffffff8104e2cf>{setup_irq+20}       <ffffffff81208d26>{megaraid_isr+0} <ffffffff8104e4b4>{request_irq+132}
       <ffffffff8120a152>{megaraid_probe_one+680} <ffffffff81136902>{kobject_re}       <ffffffff811372f6>{kref_put+96} <ffffffff812f9b62>{klist_release+0}
       <ffffffff811372f6>{kref_put+96} <ffffffff811e7000>{spi_host_match+18}
       <ffffffff8119157f>{attribute_container_remove_device+86}
       <ffffffff811368e6>{kobject_cleanup+98} <ffffffff81136902>{kobject_releas}       <ffffffff811372f6>{kref_put+96} <ffffffff811e57f6>{__scsi_scan_target+13}       <ffffffff812fc234>{__reacquirfe_kernel_lock+5} <ffffffff812fabb3>{thread}       <ffffffff81027325>{__activate_task+86} <ffffffff81027c94>{try_to_wake_up}       <ffffffff812fb333>{wait_for_completion+151} <ffffffff8102912e>{default_w}       <ffffffff8102912e>{default_wake_function+0} <ffffffff8103def2>{call_user}       <ffffffff8102a1ae>{set_cpus_allowed+235} <ffffffff8114123c>{pci_device_p}       <ffffffff8118e87a>{driver_probe_device+84} <ffffffff8118e9ad>{__driver_a}       <ffffffff8118e943>{__driver_attach+0} <ffffffff8118ddc6>{bus_for_each_de}       <ffffffff8118e2cb>{bus_add_driver+116} <ffffffff81141025>{__pci_register}       <ffffffff8154d67d>{megaraid_init+102} <ffffffff8100718c>{init+327}
       <ffffffff8100a54e>{child_rip+8} <ffffffff8114c778>{acpi_ds_init_one_obje}       <ffffffff81007045>{init+0} <ffffffff8100a546>{child_rip+0}
                                                                                
Code: 41 0f b6 44 24 10 3c ff 0f 85 e1 00 00 00 0f ae e8 ff c5 81
RIP <ffffffff81208ba4>{megaraid_ack_sequence+101} RSP <ffffffff8148ce88>
CR2: 0000000000000010
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
