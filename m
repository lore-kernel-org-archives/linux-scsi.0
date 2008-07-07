From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG]  linux-next: Tree for March 25 kernel oops, when loading
 mpt fusion driver - regression
Date: Tue, 08 Jul 2008 01:47:13 +0530
Message-ID: <487279C9.2010802@linux.vnet.ibm.com>
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au> <47E9F0B0.4060006@linux.vnet.ibm.com>  <20080626203857.GB3815@redhat.com> <1215372215.4197.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44498 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755513AbYGGURk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 16:17:40 -0400
In-Reply-To: <1215372215.4197.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Teigland <teigland@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>

James Bottomley wrote:
> On Thu, 2008-06-26 at 15:38 -0500, David Teigland wrote:
>> On Wed, Mar 26, 2008 at 12:14:00PM +0530, Kamalesh Babulal wrote:
>>> Hi Stephen,
>>>
>>> Kernel bug is hit while booting up the next-20080325 kernel with MPT
>>> Fusion driver built in.This was reported previously for the
>>> next-20080320 kernel
>>> http://marc.info/?l=linux-next&m=120601013920868&w=2
>> Hi, did you ever get this fixed?  I've been having the same problem,
>> http://marc.info/?l=linux-scsi&m=121061780821823&w=4
>> still exists on 2.6.26-rc8 for me,
>>
>> Loading scsi_transport_spi.ko module
>> Loading mptscsih.ko module
>> Loading mptspi.ko module
>> Fusion MPT SPI Host driver 3.04.06
>> ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
>> mptbase: ioc0: Initiating bringup
>> ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
>> mptbase: ioc0: PCI-MSI enabled
> 
> I speculate that this might be related to the problem.  The fusion
> driver was recently flipped to default to MSI enable (previously it had
> disabled them).  Could you boot it with the fusion module parameter
> 
> mpt_msi_enable=0
> 
> if it actually boots that will be a good confirmation that MSI is to
> blame.
> 
>> mptbase: ioc0: Initiating recovery
> 
> This I suspect is because of a lost interrupt.
> 
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000948
> 
> And this one looks to be a second bug:  The MSI fault path is actually
> causing this oops.
> 
> James
> 
Hi James,

Kernel Bug is still reproducible with 2.6.26-rc9-git1 kernel, I tried booting with mpt_msi_enable=0
as boot paramenter, but the call trace remains the same

oading mptbase.ko module[    6.766853] Fusion MPT base driver 3.04.06

[    6.783482] Copyright (c) 1999-2007 LSI Corporation
Loading mptscsih.ko module
Loading mptspi.ko module
[    6.813157] Fusion MPT SPI Host driver 3.04.06
[    6.827369] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    6.850624] mptbase: ioc0: Initiating bringup
[    6.985601] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[    7.002711] mptbase: ioc0: PCI-MSI enabled
[   17.193038] mptbase: ioc0: Initiating recovery
[   17.206490] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   17.224489] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   22.243634] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[   39.507735] mptbase: ioc0: Recovered from IOC FAULT
[   39.595707] Clocksource tsc unstable (delta = 18747111256 ns)
[   39.624226] BUG: unable to handle kernel NULL pointer dereference at 00000528
[   39.650488] IP: [<f881ccc3>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[   39.676987] *pde = 00000000 
[   39.685169] Oops: 0000 [#1] SMP 
[   39.695127] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[   39.730967] 
[   39.730967] Pid: 17, comm: events/2 Not tainted (2.6.26-rc9-git1-autokern1 #1)
[   39.730967] EIP: 0060:[<f881ccc3>] EFLAGS: 00010282 CPU: 2
[   39.730967] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[   39.730967] EAX: f7a2c188 EBX: f7a2c18c ECX: f78a0500 EDX: 00000001
[   39.730967] ESI: f7866c70 EDI: 00000528 EBP: f78a1f78 ESP: f78a1f58
[   39.730967]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   39.730967] Process events/2 (pid: 17, ti=f78a1000 task=f78a0020 task.ti=f78a1000)
[   39.730967] Stack: 00000000 00000002 00000000 c043193d f78a1f90 f7a2c18c f7866c70 f7a2c188 
[   39.730967]        f78a1fac c0431978 00000000 00000002 c043193d f881ccb7 f8820308 c091289c 
[   39.730967]        f881d86c 00000002 f7866c70 c04321dd f7866c98 f78a1fd0 c0432291 00000000 
[   39.730967] Call Trace:
[   39.730967]  [<c043193d>] ? run_workqueue+0x80/0x186
[   39.730967]  [<c0431978>] ? run_workqueue+0xbb/0x186
[   39.730967]  [<c043193d>] ? run_workqueue+0x80/0x186
[   39.730967]  [<f881ccb7>] ? mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[   39.730967]  [<c04321dd>] ? worker_thread+0x0/0xbf
[   39.730967]  [<c0432291>] ? worker_thread+0xb4/0xbf
[   39.730967]  [<c04346f9>] ? autoremove_wake_function+0x0/0x33
[   39.730967]  [<c0434638>] ? kthread+0x3b/0x63
[   39.730967]  [<c04345fd>] ? kthread+0x0/0x63
[   39.730967]  [<c0404613>] ? kernel_thread_helper+0x7/0x10
[   39.730967]  =======================
[   39.730967] Code: ff 8b 87 8c 00 00 00 e8 bd 27 03 00 8b 87 8c 00 00 00 e8 74 f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 89 4c c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00  
[   40.184778] EIP: [<f881ccc3>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f78a1f58
[   40.649493] ---[ end trace 8850b96835b44d26 ]---
[   50.659034] mptbase: ioc0: Initiating recovery
[   50.672478] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   50.690478] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   55.709559] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[   72.976560] mptbase: ioc0: Recovered from IOC FAULT

0xcc3 is in mptspi_dv_renegotiate_work (drivers/message/fusion/mptspi.c:1228).
1223            struct _MPT_SCSI_HOST *hd = wqw->hd;
1224            struct scsi_device *sdev;
1225            struct scsi_target *starget;
1226            struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
1227            u32 nego;
1228            MPT_ADAPTER *ioc = hd->ioc;
1229
1230            kfree(wqw);
1231
1232            if (hd->spi_pending) {


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
