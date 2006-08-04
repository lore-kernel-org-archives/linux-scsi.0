From: maximilian attems <maks@sternwelten.at>
Subject: Re: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 4 Aug 2006 20:21:03 +0200
Message-ID: <20060804182102.GD19325@nancy>
References: <200607281800.59516.joshua@rubixlinux.org> <200607301140.25691.joshua@rubixlinux.org> <20060730200559.GO10814@baikonur.stro.at> <200607301433.02983.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:37309 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S932613AbWHDSVe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Aug 2006 14:21:34 -0400
Content-Disposition: inline
In-Reply-To: <200607301433.02983.joshua@rubixlinux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Rubin <joshua@rubixlinux.org>
Cc: 380272@bugs.debian.org, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

hello joshua,

thanks for your followups,
had time again to look at your bug report.

the trouble is quite shown in the troublesome dmesg and
in the working cat /proc/modules.

On Sun, 30 Jul 2006, Joshua Rubin wrote:

> I just tried installing etch with the beta2 installer. This system loaded the 
> floppy module before the cpqarray module, yet could not find the arrays 
> either. Still, the sarge system upgraded to etch works fine with the floppy 
> module loaded in the initramfs.

adding the floppy seems to kick sym53c8xx at loading later:

> ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 19 (level, low) -> IRQ 177
> sym53c8xx 0000:00:01.0: device not supported
> ACPI: PCI interrupt for device 0000:00:01.0 disabled
> Compaq SMART2 Driver (v 2.6.0)
> cpqarray: Device 0x10 has been found at bus 0 dev 1 func 0
> ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 19 (level, low) -> IRQ 177
> cpqarray: Finding drives on ida0<4>cpqarray ida0: idaSendPciCmd Timeout out,

see sym53c8xx disables your interrupt for cpqarray.
try my theory and use instead of floppy:
echo cpqarray > /etc/initramfs-tools/modules
regenerate initramfs with update-initramfs -u.
plese post the resulting dmesg.

adding linux-scsi and Matthew Wilcox to cc.


best regards

-- 
maks
