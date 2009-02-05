From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: RE: [Panic+FIX] Kernel Panic with Qlogic 2472 Card.
Date: Thu, 5 Feb 2009 07:00:30 -0800
Message-ID: <968C4C03B4940B48A4A8B1EA417CD6D82CDE01D24C@AVEXMB2.qlogic.org>
References: <46A00B48CC54E4468EF6911F877AC4CA01F906C6@blrx3m10.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:34283 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZBEPAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2009 10:00:39 -0500
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA01F906C6@blrx3m10.blr.amer.dell.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shyam_Iyer@Dell.com" <Shyam_Iyer@Dell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Andy_Tran@Dell.com" <Andy_Tran@Dell.com>, "RICHARD_GOLASKY@Dell.com" <RICHARD_GOLASKY@Dell.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Shyam_Iyer@Dell.com
> Sent: Thursday, February 05, 2009 6:43 AM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Andy_Tran@Dell.com;
> RICHARD_GOLASKY@Dell.com
> Subject: [Panic+FIX] Kernel Panic with Qlogic 2472 Card.
> 
> Kernel Panic is observed with a Qlogic 2472 Card is plugged into the
> system and the qla2xxx driver is loaded.
Thanks for the finding.

Acked-by: Seokmann Ju <Seokmann.ju@qlogic.com>

> 
> The attached patch fixes the issue.
> 
> Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
> 
> --- qla_devtbl.h.orig	2009-02-05 19:59:38.000000000 +0530
> +++ qla_devtbl.h	2009-02-05 19:58:25.000000000 +0530
> @@ -72,7 +72,7 @@
>  	"QLA2462",	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",
> /* 0x141 */
>  	"QLE2460",	"Sun PCI-Express to 2Gb FC, Single Channel",
> /* 0x142 */
>  	"QLE2462",	"Sun PCI-Express to 4Gb FC, Single Channel",
> /* 0x143 */
> -	"QEM2462"	"Server I/O Module 4Gb FC, Dual Channel",
> /* 0x144 */
> +	"QEM2462",	"Server I/O Module 4Gb FC, Dual Channel",
> /* 0x144 */
>  	"QLE2440",	"PCI-Express to 4Gb FC, Single Channel",
> /* 0x145 */
>  	"QLE2464",	"PCI-Express to 4Gb FC, Quad Channel",
> /* 0x146 */
>  	"QLA2440",	"PCI-X 2.0 to 4Gb FC, Single Channel",
> /* 0x147 */
> 
> 
> 
> 
> --------------Kernel-Panic-snip----------------------------------------
> -
> -
> 
> QLogic Fibre Channel HBA Driver: 8.02.01.02.11.0-k9
> vendor=8086 device=3410
> qla2xxx 0000:05:00.0: PCI INT A -> GSI 40 (level, low) -> IRQ 40
> qla2xxx 0000:05:00.0: Found an ISP2432, irq 40, iobase
> 0xffffc2001091c000 qla2xxx 0000:05:00.0: Configuring PCI space...
> qla2xxx 0000:05:00.0: setting latency timer to 64 qla2xxx 0000:05:00.0:
> Configure NVRAM parameters...
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> IP: [<ffffffff8036319a>] strncpy+0x5/0x1e PGD 7c564067 PUD 78d8c067 PMD
> 0
> Oops: 0000 [1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-
> 2:1.1/input/input4/event
> 4/dev
> CPU 1
> Modules linked in: qla2xxx(+) squashfs usb_storage scsi_transport_fc
> scsi_tgt parport_pc parport arc4 ecb crypto_blkcipher acpi_cpufreq fan
> loop nfs nfs_acl lockd sunrpc nls_iso8859_1 nls_cp437 ipv6 af_packet st
> sr_mod ide_disk ide_cd_mod ide_core cdrom usbhid hid ff_memless sg
> sd_mod crc_t10dif uhci_hcd mptsas mptscsih ehci_hcd mptbase
> scsi_transport_sas rtc_cmos rtc_core rtc_lib usbcore scsi_mod thermal
> bnx2 button processor thermal_sys hwmon edd
> Supported: Yes
> Pid: 4415, comm: insmod Not tainted 2.6.27.13-1-default #1
> RIP: 0010:[<ffffffff8036319a>] [<ffffffff8036319a>] strncpy+0x5/0x1e
> RSP: 0018:ffff88007b04fbc0 EFLAGS: 00010202
> RAX: 00000000000000b7 RBX: ffff88007b9641e0 RCX: ffff88007c1b2ad7
> RDX: 000000000000004f RSI: 0000000000000000 RDI: ffff88007c1b2ad7
> RBP: ffff88007c1b0620 R08: 0000000000000010 R09: 0000000100000000
> R10: 0000000000000046 R11: ffffffff803651c6 R12: ffff88007b074000
> R13: ffff88007b964000 R14: ffff88007c1b2ac6 R15: 0000000000000000
> FS: 00007f91a6c366f0(0000) GS:ffff88007dbeee40(0000)
> knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000007bd7c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process insmod (pid: 4415, threadinfo ffff88007b04e000, task
> ffff880078586180)
> Stack: ffffffffa02d82c4 0000000000002432 ffff88007d385000
> ffff88007c1b0620 ffff88007c1b0620 ffff88007c1b0000 ffff88007d385000
> 0000000000002432 ffffffffa02dcb1e 0000000000002432 ffffc2001091c000
> ffff88007c1b0620 Call Trace:
> [<ffffffffa02d82c4>] qla24xx_nvram_config+0x385/0x6c2 [qla2xxx]
> [<ffffffffa02dcb1e>] qla2x00_initialize_adapter+0x169/0x383 [qla2xxx]
> [<ffffffffa02f2040>] qla2x00_probe_one+0x6bc/0x9c6 [qla2xxx]
> [<ffffffff8037346f>] pci_device_probe+0xb8/0x105 [<ffffffff803e5a27>]
> really_probe+0xdd/0x1e5 [<ffffffff803e5c14>] __driver_attach+0x46/0x6d
> [<ffffffff803e51e1>] bus_for_each_dev+0x44/0x78 [<ffffffff803e4ac7>]
> bus_add_driver+0xef/0x235 [<ffffffff803e5dd8>]
> driver_register+0xa2/0x11f [<ffffffff803736fd>]
> __pci_register_driver+0x5d/0x90 [<ffffffffa0308126>]
> qla2x00_module_init+0x126/0x159 [qla2xxx] [<ffffffff80209041>]
> _stext+0x41/0x110 [<ffffffff80260abd>] sys_init_module+0xa0/0x1ba
> [<ffffffff8020bfbb>] system_call_fastpath+0x16/0x1b [<00007f91a679b76a>]
> 0x7f91a679b76a
> Code: ff c1 41 39 c0 75 05 45 85 c0 75 bf 41 29 c0 44 89 c0 c3 31 d2 8a
> 04 16 88 04 17 48 ff c2 84 c0 75 f3 48 89 f8 c3 48 89 f9 eb 10 <8a> 06
> 3c 01 88 01 48 83 de ff 48 ff c1 48 ff ca 48 85 d2 75 eb RIP
> [<ffffffff8036319a>] strncpy+0x5/0x1e RSP <ffff88007b04fbc0>
> CR2: 0000000000000000
> ---[ end trace 829d7d78dfafb785 ]---

