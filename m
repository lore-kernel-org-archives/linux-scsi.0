From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Issue with qla2xxx_probe_one
Date: Tue, 29 Apr 2008 13:34:55 -0400
Message-ID: <48175C3F.3000002@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34328 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535AbYD2RfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 13:35:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

I /think/ that there is an issue with this routine /if/ the firmware
images are not loaded properly - on a 16-way ia64 box I am starting to
see this with an up-stream kernel (Jens Axboe's origin/io-cpu-affinity
branch). In any event, it looks to me that :

        if (qla2x00_initialize_adapter(ha)) {
                qla_printk(KERN_WARNING, ha,
                    "Failed to initialize adapter\n");

                DEBUG2(printk("scsi(%ld): Failed to initialize adapter - "
                    "Adapter flags %x.\n",
                    ha->host_no, ha->device_flags));

                ret = -ENODEV;
                goto probe_failed;
        }

skips around:

        ret = scsi_add_host(host, &pdev->dev);

which is needed to properly initialize the freelist (via:
scsi_setup_command_freelist).

When qla2xxx_probe_one ends up calling scsi_host_put in this error path
it eventually gets to scsi_destroy_command_freelist and we get the error
below.

There's a lot of code here to go through for me, but perhaps someone out
there has a quicker way of figuring out what is really wrong and/or
being able to provide a fix.

BTW: I have had the issue with firmware for a while, just never gotten
around to fixing it - typically just:

modprobe -r qla2xxx
modprobe qla2xxx

has gotten it to work in the past, but now with the NaT issue I can't
unload and reload the module.

Alan D. Brunelle
HP

=========================================================

qla2xxx 0000:2a:01.0: Found an ISP2312, irq 100, iobase 0xc0000f4010040000
qla2xxx 0000:2a:01.0: Configuring PCI space...
qla2xxx 0000:2a:01.0: Configure NVRAM parameters...
qla2xxx 0000:2a:01.0: Verifying loaded RISC code...
qla2xxx 0000:2a:01.0: Firmware image unavailable.
qla2xxx 0000:2a:01.0: Firmware images can be retrieved from:
ftp://ftp.qlogic.com/outgoing/linux/firmware/.
qla2xxx 0000:2a:01.0: Failed to initialize adapter
insmod[1828]: NaT consumption 17179869216 [1]
Modules linked in: qla2xxx(+) firmware_class ehci_hcd ohci_hcd uhci_hcd
usbcore

Pid: 1828, CPU 0, comm:               insmod
psr : 0000101008526010 ifs : 8000000000000206 ip  : [<a00000010054b1b0>]
   Not tainted (2.6.25io-cpu-affinity)
ip is at scsi_destroy_command_freelist+0x10/0xe0
unat: 0000000000000000 pfs : 0000000000000307 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005559
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010054c820 b6  : a000000100012bc0 b7  : a000000100009a60
f6  : 000000000000000000000 f7  : 1003e0000000000400000
f8  : 1003e0000000028000000 f9  : 1003e0000002d98c5cede
f10 : 1003e1fdee852b0000000 f11 : 1003e0000000000000007
r1  : a000000100c26610 r2  : e000076381418030 r3  : e000076381418150
r8  : 0000000000000000 r9  : a0000001009fb698 r10 : 00000000000001d0
r11 : a0000001009fb680 r12 : e000070384057d10 r13 : e000070384050000
r14 : 0000000000000000 r15 : e000070384050c10 r16 : a0000001009fb6a8
r17 : 0000000000000000 r18 : 0000000000000008 r19 : 0009804c8a70433f
r20 : e000070384057d10 r21 : a0000001009fb688 r22 : 0000000000000001
r23 : a0000001009fb690 r24 : 0000000000004000 r25 : 0000000000004000
r26 : a0000001009fb698 r27 : 0000000000000000 r28 : 0000000000006659
r29 : e000070384050c10 r30 : e000070384050c10 r31 : a0000001009fb698

Call Trace:
 [<a000000100012020>] show_stack+0x40/0xa0
                                sp=e000070384057760 bsp=e000070384051380
 [<a000000100012930>] show_regs+0x850/0x8a0
                                sp=e000070384057930 bsp=e000070384051328
 [<a000000100035a70>] die+0x1b0/0x2c0
                                sp=e000070384057930 bsp=e0000703840512e0
 [<a000000100035bd0>] die_if_kernel+0x50/0x80
                                sp=e000070384057930 bsp=e0000703840512b0
 [<a00000010071be20>] __kprobes_text_start+0x11a0/0x12c0
                                sp=e000070384057930 bsp=e000070384051258
 [<a00000010000a260>] ia64_leave_kernel+0x0/0x270
                                sp=e000070384057b40 bsp=e000070384051258
 [<a00000010054b1b0>] scsi_destroy_command_freelist+0x10/0xe0
                                sp=e000070384057d10 bsp=e000070384051228
 [<a00000010054c820>] scsi_host_dev_release+0x140/0x1e0
                                sp=e000070384057d10 bsp=e0000703840511f0
 [<a0000001004be5a0>] device_release+0xc0/0x160
                                sp=e000070384057d10 bsp=e0000703840511d0
 [<a0000001003e7c30>] kobject_release+0xd0/0x120
                                sp=e000070384057d10 bsp=e000070384051198
 [<a0000001003e9b50>] kref_put+0xb0/0xe0
                                sp=e000070384057d10 bsp=e000070384051170
 [<a0000001003e7950>] kobject_put+0x90/0xc0
                                sp=e000070384057d10 bsp=e000070384051150
 [<a0000001004be970>] put_device+0x30/0x60
                                sp=e000070384057d10 bsp=e000070384051130
 [<a00000010054c620>] scsi_host_put+0x20/0x40
                                sp=e000070384057d10 bsp=e000070384051110
 [<a000000207aa7ff0>] qla2x00_probe_one+0x2170/0x4110 [qla2xxx]
                                sp=e000070384057d10 bsp=e0000703840510a0
 [<a000000100408750>] pci_device_probe+0x170/0x240
                                sp=e000070384057d90 bsp=e000070384051058
 [<a0000001004c4dc0>] driver_probe_device+0x220/0x360
                                sp=e000070384057da0 bsp=e000070384051020
 [<a0000001004c4f80>] __driver_attach+0x80/0xe0
                                sp=e000070384057da0 bsp=e000070384050fe0
 [<a0000001004c3870>] bus_for_each_dev+0x90/0x100
                                sp=e000070384057da0 bsp=e000070384050fa8
 [<a0000001004c4960>] driver_attach+0x40/0x60
                                sp=e000070384057dc0 bsp=e000070384050f88
 [<a0000001004c4300>] bus_add_driver+0x160/0x4a0
                                sp=e000070384057dc0 bsp=e000070384050f40
 [<a0000001004c5580>] driver_register+0x140/0x2a0
                                sp=e000070384057dc0 bsp=e000070384050ef8
 [<a000000100408cf0>] __pci_register_driver+0xb0/0x140
                                sp=e000070384057dc0 bsp=e000070384050ec0
 [<a000000207968260>] qla2x00_module_init+0x260/0x400 [qla2xxx]
                                sp=e000070384057dd0 bsp=e000070384050e88
 [<a0000001000db000>] sys_init_module+0x35a0/0x38c0
                                sp=e000070384057dd0 bsp=e000070384050d08
 [<a00000010000a0c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000070384057e30 bsp=e000070384050d08
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000070384058000 bsp=e000070384050d08

