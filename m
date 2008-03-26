From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [BUG]  linux-next: Tree for March 25 kernel oops, when loading mpt
 fusion driver - regression
Date: Wed, 26 Mar 2008 12:14:00 +0530
Message-ID: <47E9F0B0.4060006@linux.vnet.ibm.com>
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:58109 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYCZGoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2008 02:44:12 -0400
In-Reply-To: <20080325175224.3ee62b09.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>

Hi Stephen,

Kernel bug is hit while booting up the next-20080325 kernel with MPT Fusion driver built in.This was reported previously
for the next-20080320 kernel http://marc.info/?l=linux-next&m=120601013920868&w=2

Loading mptscsih.ko module
Loading mptspi.ko module
[    6.591066] Fusion MPT SPI Host driver 3.04.06
[    6.592181] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    6.593991] mptbase: ioc0: Initiating bringup
[    6.718342] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[    6.722484] mptbase: ioc0: PCI-MSI enabled
[   16.902699] mptbase: ioc0: Initiating recovery
[   16.903618] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   16.904618] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   21.909082] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[   39.152711] mptbase: ioc0: Recovered from IOC FAULT
[   61.630538] BUG: unable to handle kernel NULL pointer dereference at 00000528
[   61.632545] IP: [<f881ccc9>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[   61.634545] *pde = 00000000 
[   61.636219] Oops: 0000 [#1] SMP 
[   61.636537] last sysfs file: /sys/block/ram15/dev
[   61.636537] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[   61.636537] 
[   61.636537] Pid: 17, comm: events/2 Not tainted (2.6.25-rc6-next-20080325-autotest #1)
[   61.636537] EIP: 0060:[<f881ccc9>] EFLAGS: 00010282 CPU: 2
[   61.636537] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[   61.636537] EAX: f79e5868 EBX: f79e586c ECX: f78c308c EDX: 00000001
[   61.636537] ESI: f7867e38 EDI: 00000528 EBP: f78a2f78 ESP: f78a2f58
[   61.636537]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   61.636537] Process events/2 (pid: 17, ti=f78a2000 task=f78c29a0 task.ti=f78a2000)
[   61.636537] Stack: 00000000 00000002 00000000 c0430b45 f78a2f90 f79e586c f7867e38 f79e5868 
[   61.636537]        f78a2fac c0430b80 00000000 00000002 c0430b45 f881ccbd f8821588 c08ee870 
[   61.636537]        f881d870 00000002 f7867e38 c043140a f7867e60 f78a2fd0 c04314be 00000000 
[   61.636537] Call Trace:
[   61.636537]  [<c0430b45>] run_workqueue+0x80/0x186
[   61.636537]  [<c0430b80>] run_workqueue+0xbb/0x186
[   61.636537]  [<c0430b45>] run_workqueue+0x80/0x186
[   61.636537]  [<f881ccbd>] mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[   61.636537]  [<c043140a>] worker_thread+0x0/0xbf
[   61.636537]  [<c04314be>] worker_thread+0xb4/0xbf
[   61.636537]  [<c043393d>] autoremove_wake_function+0x0/0x33
[   61.636537]  [<c043387b>] kthread+0x3b/0x64
[   61.636537]  [<c0433840>] kthread+0x0/0x64
[   61.636537]  [<c040468f>] kernel_thread_helper+0x7/0x10
[   61.636537]  =======================
[   61.636537] Code: ff 8b 87 8c 00 00 00 e8 b0 6c 03 00 8b 87 8c 00 00 00 e8 6e f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 87 2a c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00 
[   61.636537] EIP: [<f881ccc9>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f78a2f58
[   61.636550] ---[ end trace c0dc9c06e06bc602 ]---
[   47.107291] mptbase: ioc0: Initiating recovery
[   47.108284] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   47.109284] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   52.122242] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[   69.374395] mptbase: ioc0: Recovered from IOC FAULT
[   69.448422] Clocksource tsc unstable (delta = 18746181568 ns)
[   91.888899] BUG: unable to handle kernel NULL pointer dereference at 00000528
[   91.890902] IP: [<f881ccc9>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[   91.892902] *pde = 00000000 
[   91.894904] Oops: 0000 [#2] SMP 
[   91.895898] last sysfs file: /sys/block/ram15/dev
[   91.895898] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[   91.895898] 
[   91.895898] Pid: 15, comm: events/0 Tainted: G      D  (2.6.25-rc6-next-20080325-autotest #1)
[   91.895898] EIP: 0060:[<f881ccc9>] EFLAGS: 00010282 CPU: 0
[   91.895898] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[   91.895898] EAX: f7a427b8 EBX: f7a427bc ECX: 00000000 EDX: 00000000
[   91.895898] ESI: f7867f68 EDI: 00000528 EBP: f7877f78 ESP: f7877f58
[   91.895898]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   91.895898] Process events/0 (pid: 15, ti=f7877000 task=f789e8a0 task.ti=f7877000)
[   91.895898] Stack: 00000000 00000002 00000000 c0430b45 f7877f90 f7a427bc f7867f68 f7a427b8 
[   91.895898]        f7877fac c0430b80 00000000 00000002 c0430b45 f881ccbd 5a5a5a5a 5a5a5a5a 
[   91.895898]        5a5a5a5a 5a5a5a5a f7867f68 c043140a f7867f90 f7877fd0 c04314be 00000000 
[   91.895898] Call Trace:
[   91.895898]  [<c0430b45>] run_workqueue+0x80/0x186
[   91.895898]  [<c0430b80>] run_workqueue+0xbb/0x186
[   91.895898]  [<c0430b45>] run_workqueue+0x80/0x186
[   91.895898]  [<f881ccbd>] mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[   91.895898]  [<c043140a>] worker_thread+0x0/0xbf
[   91.895898]  [<c04314be>] worker_thread+0xb4/0xbf
[   91.895898]  [<c043393d>] autoremove_wake_function+0x0/0x33
[   91.895898]  [<c043387b>] kthread+0x3b/0x64
[   91.895898]  [<c0433840>] kthread+0x0/0x64
[   91.895898]  [<c040468f>] kernel_thread_helper+0x7/0x10
[   91.895898]  =======================
[   91.895898] Code: ff 8b 87 8c 00 00 00 e8 b0 6c 03 00 8b 87 8c 00 00 00 e8 6e f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 87 2a c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00 
[   91.895898] EIP: [<f881ccc9>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f7877f58
[   91.895903] ---[ end trace c0dc9c06e06bc602 ]---
[   82.434031] mptbase: ioc0: Initiating recovery
[   82.435028] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   82.436028] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   87.440153] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[  104.682001] mptbase: ioc0: Recovered from IOC FAULT
[  127.157135] BUG: unable to handle kernel NULL pointer dereference at 00000528
[  127.159138] IP: [<f881ccc9>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[  127.161139] *pde = 00000000 
[  127.163139] Oops: 0000 [#3] SMP 
[  127.164134] last sysfs file: /sys/block/ram15/dev
[  127.164134] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[  127.164134] 
[  127.164134] Pid: 16, comm: events/1 Tainted: G      D  (2.6.25-rc6-next-20080325-autotest #1)
[  127.164134] EIP: 0060:[<f881ccc9>] EFLAGS: 00010282 CPU: 1
[  127.164134] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[  127.164134] EAX: f7a42fa0 EBX: f7a42fa4 ECX: 00000000 EDX: 00000000
[  127.164134] ESI: f7867ed0 EDI: 00000528 EBP: f78a1f78 ESP: f78a1f58
[  127.164134]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  127.164134] Process events/1 (pid: 16, ti=f78a1000 task=f78c0920 task.ti=f78a1000)
[  127.164134] Stack: 00000000 00000002 00000000 c0430b45 f78a1f90 f7a42fa4 f7867ed0 f7a42fa0 
[  127.164134]        f78a1fac c0430b80 00000000 00000002 c0430b45 f881ccbd 5a5a5a5a 5a5a5a5a 
[  127.164134]        5a5a5a5a 5a5a5a5a f7867ed0 c043140a f7867ef8 f78a1fd0 c04314be 00000000 
[  127.164134] Call Trace:
[  127.164134]  [<c0430b45>] run_workqueue+0x80/0x186
[  127.164134]  [<c0430b80>] run_workqueue+0xbb/0x186
[  127.164134]  [<c0430b45>] run_workqueue+0x80/0x186
[  127.164134]  [<f881ccbd>] mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[  127.164134]  [<c043140a>] worker_thread+0x0/0xbf
[  127.164134]  [<c04314be>] worker_thread+0xb4/0xbf
[  127.164134]  [<c043393d>] autoremove_wake_function+0x0/0x33
[  127.164134]  [<c043387b>] kthread+0x3b/0x64
[  127.164134]  [<c0433840>] kthread+0x0/0x64
[  127.164134]  [<c040468f>] kernel_thread_helper+0x7/0x10
[  127.164134]  =======================
[  127.164134] Code: ff 8b 87 8c 00 00 00 e8 b0 6c 03 00 8b 87 8c 00 00 00 e8 6e f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 87 2a c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00 
[  127.164134] EIP: [<f881ccc9>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f78a1f58
[  127.164147] ---[ end trace c0dc9c06e06bc602 ]---
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
