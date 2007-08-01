From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: regression: panic from qlogic driver in qla2x00_read_nvram_data
Date: Wed, 01 Aug 2007 12:52:16 -0700
Message-ID: <46B0E470.1040403@qlogic.com>
References: <1185997129.9592.39.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:58749 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762683AbXHATu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 15:50:26 -0400
In-Reply-To: <1185997129.9592.39.camel@deimos.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Chapman <doug.chapman@hp.com>
Cc: linux-scsi@vger.kernel.org

Doug Chapman wrote:
> I am seeing a panic on the latest git trees on my ia64 servers with
> qlogic cards installed.  The latest this was known to work OK was
> v2.6.23-rc1.  I am currently working on a git bisect to narrow down what
> introduced this but due to other unrelated problems that is not going
> smoothly.  Let me know if there is other info I can provide that would
> be helpful.
> 
> Here is what I do know:
This issue has been addressed, as below.
http://marc.info/?l=linux-scsi&m=118581884800073&w=2

Thank you,
Seokmann
> 
> Hardware info:
> I am seeing this on multiple HP ia64 servers (don't know if this is ia64
> specific since that is all I have).  Here is what I see as the card is
> seen on a good boot (I don't get this far on the current kernels):
> 
> qla2xxx 0000:80:02.0: Found an ISP2312, irq 68, iobase 0xc0000000c0041000
> qla2xxx 0000:80:02.0: Configuring PCI space...
> qla2xxx 0000:80:02.0: Configure NVRAM parameters...
> qla2xxx 0000:80:02.0: Verifying loaded RISC code...
> qla2xxx 0000:80:02.0: Allocated (412 KB) for firmware dump...
> scsi2 : qla2xxx
> qla2xxx 0000:80:02.0:
>  QLogic Fibre Channel HBA Driver: 8.02.00-k2
>   QLogic HP A6826-60001 -
>   ISP2312: PCI-X (66 MHz) @ 0000:80:02.0 hdma+, host#=2, fw=3.03.20 IPX
> 
> 
> 
> Appears the panic happens at drivers/scsi/qla2xxx/qla_sup.c:668
> 
> 663
> 664             /* Word reads to NVRAM via registers. */
> 665             wptr = (uint16_t *)buf;
> 666             qla2x00_lock_nvram_access(ha);
> 667             for (i = 0; i < bytes >> 1; i++, naddr++)
> 668                     wptr[i] = cpu_to_le16(qla2x00_get_nvram_word(ha,
> 669                         naddr));
> 670             qla2x00_unlock_nvram_access(ha);
> 671
> 672             return buf;
> 
> 
> Here is the full stack trace (note, this is from loading the module, not
> from a static build but appears to be the same).
> 
> 
> Unable to handle kernel NULL pointer dereference (address 0000000000000000)
> 
> ip is at qla2x00_read_nvram_data+0x61/0xe0 [qla2xxx]
> 
> Call Trace:
>  [<a000000100015260>] show_stack+0x40/0xa0
>                                 sp=e0000040f34a7770 bsp=e0000040f34a14b0
>  [<a000000100015b60>] show_regs+0x840/0x880
>                                 sp=e0000040f34a7940 bsp=e0000040f34a1458
>  [<a000000100038d20>] die+0x1a0/0x280
>                                 sp=e0000040f34a7940 bsp=e0000040f34a1410
>  [<a00000010066c570>] ia64_do_page_fault+0x8f0/0xa20
>                                 sp=e0000040f34a7940 bsp=e0000040f34a13b0
>  [<a00000010000ba00>] ia64_leave_kernel+0x0/0x270
>                                 sp=e0000040f34a79d0 bsp=e0000040f34a13b0
>  [<a00000021b7778a0>] qla2x00_read_nvram_data+0x60/0xe0 [qla2xxx]
>                                 sp=e0000040f34a7ba0 bsp=e0000040f34a1358
>  [<a00000021b74b310>] qla2x00_nvram_config+0x190/0x14e0 [qla2xxx]
>                                 sp=e0000040f34a7ba0 bsp=e0000040f34a12f8
>  [<a00000021b748070>] qla2x00_initialize_adapter+0x350/0x5a0 [qla2xxx]
>                                 sp=e0000040f34a7ba0 bsp=e0000040f34a12c0
>  [<a00000021b73d3c0>] qla2x00_probe_one+0x1620/0x1e60 [qla2xxx]
>                                 sp=e0000040f34a7bc0 bsp=e0000040f34a1228
>  [<a00000010030fd20>] pci_device_probe+0x260/0x3a0
>                                 sp=e0000040f34a7d10 bsp=e0000040f34a11d8
>  [<a000000100424e90>] driver_probe_device+0x250/0x380
>                                 sp=e0000040f34a7de0 bsp=e0000040f34a1198
>  [<a0000001004252a0>] __driver_attach+0x100/0x1a0
>                                 sp=e0000040f34a7de0 bsp=e0000040f34a1168
>  [<a000000100423260>] bus_for_each_dev+0x80/0x100
>                                 sp=e0000040f34a7de0 bsp=e0000040f34a1130
>  [<a000000100424a60>] driver_attach+0x40/0x60
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a1110
>  [<a000000100423a50>] bus_add_driver+0xf0/0x3c0
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a10d0
>  [<a000000100425800>] driver_register+0x140/0x160
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a10b0
>  [<a0000001003101f0>] __pci_register_driver+0xd0/0x160
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a1078
>  [<a00000021b304260>] qla2x00_module_init+0x260/0x400 [qla2xxx]
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a1040
>  [<a0000001000e5f90>] sys_init_module+0x2db0/0x3160
>                                 sp=e0000040f34a7e00 bsp=e0000040f34a0ec0
>  [<a00000010000b860>] ia64_ret_from_syscall+0x0/0x20
>                                 sp=e0000040f34a7e30 bsp=e0000040f34a0ec0
>  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
>                                 sp=e0000040f34a8000 bsp=e0000040f34a0ec0
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

