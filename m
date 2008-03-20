From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [BUG] linux-next: Tree for March 20 kernel oops, when loading mpt
 fusion driver
Date: Thu, 20 Mar 2008 16:17:10 +0530
Message-ID: <47E240AE.1030601@linux.vnet.ibm.com>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55264 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYCTKrq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 06:47:46 -0400
In-Reply-To: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>

Hi Stephen,

Kernel bug is hit while booting up the next-20080320 kernel with MPT Fusion driver built in.

[   61.614030] BUG: unable to handle kernel NULL pointer dereference at 00000528
[   61.617012] IP: [<f881ccc9>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[   61.619012] *pde = 00000000 
[   61.621015] Oops: 0000 [#1] SMP 
[   61.622004] last sysfs file: /sys/block/ram15/dev
[   61.622004] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[   61.622004] 
[   61.622004] Pid: 18, comm: events/3 Not tainted (2.6.25-rc6-next-20080320-autotest #1)
[   61.622004] EIP: 0060:[<f881ccc9>] EFLAGS: 00010282 CPU: 3
[   61.622004] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[   61.622004] EAX: f7ae5c30 EBX: f7ae5c34 ECX: f78c510c EDX: 00000001
[   61.622004] ESI: f7867da0 EDI: 00000528 EBP: f78a3f78 ESP: f78a3f58
[   61.622004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   61.622004] Process events/3 (pid: 18, ti=f78a3000 task=f78c4a20 task.ti=f78a3000)
[   61.622004] Stack: 00000000 00000002 00000000 c0430b71 f78a3f90 f7ae5c34 f7867da0 f7ae5c30 
[   61.622004]        f78a3fac c0430bac 00000000 00000002 c0430b71 f881ccbd f8821588 c08ed870 
[   61.622004]        f881d870 00000003 f7867da0 c0431436 f7867dc8 f78a3fd0 c04314ea 00000000 
[   61.622004] Call Trace:
[   61.622004]  [<c0430b71>] ? run_workqueue+0x80/0x186
[   61.622004]  [<c0430bac>] ? run_workqueue+0xbb/0x186
[   61.622004]  [<c0430b71>] ? run_workqueue+0x80/0x186
[   61.622004]  [<f881ccbd>] ? mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[   61.622004]  [<c0431436>] ? worker_thread+0x0/0xbf
[   61.622004]  [<c04314ea>] ? worker_thread+0xb4/0xbf
[   61.622004]  [<c0433969>] ? autoremove_wake_function+0x0/0x33
[   61.622004]  [<c04338a7>] ? kthread+0x3b/0x64
[   61.622004]  [<c043386c>] ? kthread+0x0/0x64
[   61.622004]  [<c040468f>] ? kernel_thread_helper+0x7/0x10
[   61.622004]  =======================
[   61.622004] Code: ff 8b 87 8c 00 00 00 e8 b0 5c 03 00 8b 87 8c 00 00 00 e8 6e f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 b3 2a c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00 
[   61.622004] EIP: [<f881ccc9>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f78a3f58
[   61.622018] ---[ end trace 9ed01624c6eca9b7 ]---
[   49.418416] mptbase: ioc0: Initiating recovery
[   49.419412] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[   49.420412] mptbase: ioc0: WARNING -            FAULT code = 8112h
[   54.425032] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!
[   71.669211] mptbase: ioc0: Recovered from IOC FAULT
[   94.148187] BUG: unable to handle kernel NULL pointer dereference at 00000528
[   94.150190] IP: [<f881ccc9>] :mptspi:mptspi_dv_renegotiate_work+0xc/0xab
[   94.152191] *pde = 00000000 
[   94.154191] Oops: 0000 [#2] SMP 
[   94.155186] last sysfs file: /sys/block/ram15/dev
[   94.155186] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
[   94.155186] 
[   94.155186] Pid: 17, comm: events/2 Tainted: G      D  (2.6.25-rc6-next-20080320-autotest #1)
[   94.155186] EIP: 0060:[<f881ccc9>] EFLAGS: 00010282 CPU: 2
[   94.155186] EIP is at mptspi_dv_renegotiate_work+0xc/0xab [mptspi]
[   94.155186] EAX: f73231e0 EBX: f73231e4 ECX: 00000000 EDX: 00000000
[   94.155186] ESI: f7867e38 EDI: 00000528 EBP: f78a2f78 ESP: f78a2f58
[   94.155186]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   94.155186] Process events/2 (pid: 17, ti=f78a2000 task=f78c29a0 task.ti=f78a2000)
[   94.155186] Stack: 00000000 00000002 00000000 c0430b71 f78a2f90 f73231e4 f7867e38 f73231e0 
[   94.155186]        f78a2fac c0430bac 00000000 00000002 c0430b71 f881ccbd 5a5a5a5a 5a5a5a5a 
[   94.155186]        5a5a5a5a 5a5a5a5a f7867e38 c0431436 f7867e60 f78a2fd0 c04314ea 00000000 
[   94.155186] Call Trace:
[   94.155186]  [<c0430b71>] ? run_workqueue+0x80/0x186
[   94.155186]  [<c0430bac>] ? run_workqueue+0xbb/0x186
[   94.155186]  [<c0430b71>] ? run_workqueue+0x80/0x186
[   94.155186]  [<f881ccbd>] ? mptspi_dv_renegotiate_work+0x0/0xab [mptspi]
[   94.155186]  [<c0431436>] ? worker_thread+0x0/0xbf
[   94.155187]  [<c04314ea>] ? worker_thread+0xb4/0xbf
[   94.155187]  [<c0433969>] ? autoremove_wake_function+0x0/0x33
[   94.155187]  [<c04338a7>] ? kthread+0x3b/0x64
[   94.155187]  [<c043386c>] ? kthread+0x0/0x64
[   94.155187]  [<c040468f>] ? kernel_thread_helper+0x7/0x10
[   94.155187]  =======================
[   94.155187] Code: ff 8b 87 8c 00 00 00 e8 b0 5c 03 00 8b 87 8c 00 00 00 e8 6e f8 ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 8b 78 20 <8b> 17 89 55 e0 e8 b3 2a c5 c7 8b 55 e0 66 83 bf b2 02 00 00 00 
[   94.155187] EIP: [<f881ccc9>] mptspi_dv_renegotiate_work+0xc/0xab [mptspi] SS:ESP 0068:f78a2f58
[   94.155198] ---[ end trace 9ed01624c6eca9b7 ]---

The .config options related to fusion mpt driver

CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set


(gdb) p mptspi_dv_renegotiate_work
$1 = {void (struct work_struct *)} 0xcbd <mptspi_dv_renegotiate_work>
(gdb) p/x 0xcbd+0xc
$2 = 0xcc9
(gdb) l *0xcc9
0xcc9 is in mptspi_dv_renegotiate_work (drivers/message/fusion/mptspi.c:1228).
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
