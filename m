From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Tue, 21 Feb 2006 13:16:39 -0600
Message-ID: <1140549399.3215.20.camel@mulgrave.il.steeleye.com>
References: <20060217023613.GA30583@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20701 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932344AbWBUTQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 14:16:57 -0500
In-Reply-To: <20060217023613.GA30583@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Robert <Robert_Tarte@adaptec.com>, Jeff Garzik <jgarzik@redhat.com>

On Thu, 2006-02-16 at 18:36 -0800, Mike Anderson wrote:
> This patch addresses the issue of the aic94xx driver not working on
> non-x86 or on systems where the card bios had been disabled.
> http://bugzilla.kernel.org/show_bug.cgi?id=6042
> 
> Rob Tarte, Jeff Ding, and I coordinated on the fix for the OCM issue.
> 
> The patch has been run on a Powermac G5, a PPC64, and IA64 based system.

Actually, it's still not quite working for me.  This is what I get from
2.6.16-rc4 with the Jeff Garzik SAS tree (which has this fix applied).
The soft lockup basically means it was hung in asd_read_ocm():

aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
GSI 49 (level, low) -> CPU 0 (0x0000) vector 62
ACPI: PCI Interrupt 0000:c0:01.0[A] -> GSI 49 (level, low) -> IRQ 62
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:c0:01.0
OCM is not initialized by BIOS,reinitialize it and ignore it, current IntrptStatusis 0x0
BUG: soft lockup detected on CPU#0!
Modules linked in: aic94xx af_packet ide_cd sas_class generic cmd64x ide_core snd_fm801 snd_ac97_codec snd_ac97_bus snd_pcm snd_page_alloc snd_tea575x_tuner videodev snd_opl3_lib snd_timer snd_hwdep snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore e1000 usbhid ohci_hcd usbcore ext3 jbd mbcache sr_mod cdrom st sd_mod sg mptspi mptscsih mptbase aic79xx aic7xxx sym53c8xx scsi_transport_spi scsi_mod

Pid: 3287, CPU 0, comm:             modprobe
psr : 00001010085a6010 ifs : 8000000000000611 ip  : [<a000000200dbf5c0>]    Not tainted
ip is at asd_read_ocm+0x120/0xb40 [aic94xx]
unat: 0000000000000000 pfs : 0000000000000611 rsc : 0000000000000003
rnat: 000000000000003e bsps: a0000001007c60e0 pr  : 00000000005a9659
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000200dbf560 b6  : a00000010003b6a0 b7  : a00000010026c960
f6  : 1003e0000001da0f9f2d1 f7  : 1003e0000000000000001
f8  : 1003e0000001da0f9ef4d f9  : 1003e0000000000000384
f10 : 10005fffffffff0000000 f11 : 1003e0000000000000080
r1  : a000000200dd5b90 r2  : 0000000000000a18 r3  : fffffffffffffeda
r8  : 000000000000005c r9  : 0000000000007fff r10 : c0000000e00c00a4
r11 : c0000000e00c0000 r12 : e00000407cbdfda0 r13 : e00000407cbd8000
r14 : e00000407cbdfdb0 r15 : 00000000000000a8 r16 : e0000040448083b0
r17 : 0000000000000007 r18 : c0000000ff5e0000 r19 : 0000000000000005
r20 : 0000000090000040 r21 : 0000000000000060 r22 : 0000000090000040
r23 : a000000100821be9 r24 : 0000000000000007 r25 : 0000000000000005
r26 : a0000001007c60e0 r27 : 00000010085a6010 r28 : a0000001007c60e0
r29 : 0000000000ffffff r30 : 0000000000000000 r31 : a0000001007bf098

Call Trace:
 [<a0000001000137c0>] show_stack+0x80/0xa0
                                sp=e00000407cbdf9f0 bsp=e00000407cbd9630
 [<a0000001000140e0>] show_regs+0x900/0x940
                                sp=e00000407cbdfbc0 bsp=e00000407cbd95d0
 [<a0000001000e90c0>] softlockup_tick+0x160/0x1a0
                                sp=e00000407cbdfbd0 bsp=e00000407cbd95a0
 [<a0000001000af050>] do_timer+0x570/0x9c0
                                sp=e00000407cbdfbd0 bsp=e00000407cbd9538
 [<a00000010003b620>] timer_interrupt+0x280/0x300
                                sp=e00000407cbdfbd0 bsp=e00000407cbd94e0
 [<a0000001000e95e0>] handle_IRQ_event+0xa0/0x140
                                sp=e00000407cbdfbd0 bsp=e00000407cbd94a0
 [<a0000001000e97c0>] __do_IRQ+0x140/0x3c0
                                sp=e00000407cbdfbd0 bsp=e00000407cbd9448
 [<a000000100010720>] ia64_handle_irq+0xa0/0x140
                                sp=e00000407cbdfbd0 bsp=e00000407cbd9410
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x280
                                sp=e00000407cbdfbd0 bsp=e00000407cbd9410
 [<a000000200dbf5c0>] asd_read_ocm+0x120/0xb40 [aic94xx]
                                sp=e00000407cbdfda0 bsp=e00000407cbd9380
 [<a000000200dbad70>] asd_init_hw+0x1a70/0x2800 [aic94xx]
                                sp=e00000407cbdfdb0 bsp=e00000407cbd92c8
 [<a000000200db5e70>] asd_pci_probe+0x870/0x1c40 [aic94xx]
                                sp=e00000407cbdfdd0 bsp=e00000407cbd9240
 [<a00000010026cb60>] pci_device_probe+0x200/0x2c0
                                sp=e00000407cbdfdf0 bsp=e00000407cbd9200
 [<a0000001003ae4a0>] driver_probe_device+0xe0/0x240
                                sp=e00000407cbdfdf0 bsp=e00000407cbd91c0
 [<a0000001003ae840>] __driver_attach+0xc0/0x160
                                sp=e00000407cbdfdf0 bsp=e00000407cbd9188
 [<a0000001003acb30>] bus_for_each_dev+0xb0/0x120
                                sp=e00000407cbdfdf0 bsp=e00000407cbd9150
 [<a0000001003ae140>] driver_attach+0x40/0x60
                                sp=e00000407cbdfe10 bsp=e00000407cbd9130
 [<a0000001003ad240>] bus_add_driver+0xc0/0x2e0
                                sp=e00000407cbdfe10 bsp=e00000407cbd90f8
 [<a0000001003af160>] driver_register+0x120/0x1e0
                                sp=e00000407cbdfe10 bsp=e00000407cbd90d8
 [<a00000010026bd30>] __pci_register_driver+0x110/0x180
                                sp=e00000407cbdfe20 bsp=e00000407cbd90a8
 [<a000000200b340f0>] aic94xx_init+0xf0/0x320 [aic94xx]
                                sp=e00000407cbdfe30 bsp=e00000407cbd9070
 [<a0000001000deb50>] sys_init_module+0x230/0x5a0
                                sp=e00000407cbdfe30 bsp=e00000407cbd8ff0
 [<a00000010000bb40>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000407cbdfe30 bsp=e00000407cbd8ff0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000407cbe0000 bsp=e00000407cbd8ff0

James


