From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Problem with 2.6 kernel and sym53c8xx driver
Date: Wed, 1 Mar 2006 06:20:55 -0700
Message-ID: <20060301132055.GA1598@parisc-linux.org>
References: <440481D2.6030107@iutc3.unicaen.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38368 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1030204AbWCANU5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 08:20:57 -0500
Content-Disposition: inline
In-Reply-To: <440481D2.6030107@iutc3.unicaen.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrien Corbi?re <corbiere@iutc3.unicaen.fr>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 28, 2006 at 06:01:06PM +0100, Adrien Corbi?re wrote:
> I have a server with a  "Symbios Logic 53c1010 66MHz Ultra3 SCSI" 
> adapter, and it works very well with 2.4.x kernel series (currently 
> 2.4.27). I've tried change to 2.6 kernel series, but I've never managed 
> to made this chip correctly recognized. Several test were made with 
> 2.6.5, 2.6.6, 2.6.8 (debian) and now 2.6.15.4.
> 
> I have a RAID 1To and a DAT 20/40Go on this server.
> 
> I've search on mailing lists, howtos, kernel docs. Since I've no idea of 
> what to do next, I'm writing to you.

OK.  I'm cc'ing the linux-scsi list for additional help.

> ------ With 2.6.15.4, when the module loads up, I always have this 
> message in an endless loop (what is written before is too fast for me to 
> write it on paper):
> target: 0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
> sym0: SCSI phase error fixup: CCB already dequeued
> sym0: SCSI BUS reset detected
> sym0: SCSI BUS has been reset

This either indicates a really serious problem in the driver, or that
the device is violating the scsi bus protocol in a nasty way.  I'll do
some debugging with you off-list to figure this out.

> The kernel finds the raid device as sda AND an "sdb" device that doesn't 
> exist.
> 
> ------ With 2.6.5, detection is nearly correct, but there is a problem 
> of size. The value of DMA adressing mode in kernel configuration doesn't 
> change anything.
> PCI: Found IRQ 9 for device 0000:01:03.0
> sym0: <1010-66> rev 0x1 at pci 0000:01:03.0 irq 9
> sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: handling phase mismatch from SCRIPTS.
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.1.18i
>  Vendor: BROWNIE   Model: 1600U3P           Rev: 0001
>  Type:   Direct-Access                      ANSI SCSI revision: 03
> sym0:1:0: tagged command queuing enabled, command queue depth 16.
> sym0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
> SCSI device sda: 2568192000 512-byte hdwr sectors (215403 MB)
> SCSI device sda: drive cache: write back
> sda: sda1 sda2
> Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
> scsi: host 0 channel 0 id 1 lun 0x00000200080c0400 has a LUN larger than 
> currently supported.
> scsi: host 0 channel 0 id 1 lun 0xff010000ffffffff has a LUN larger than 
> currently supported.
> scsi: host 0 channel 0 id 1 lun808529923 has a LUN larger than allowed 
> by the host adapter
> scsi: host 0 channel 0 id 1 lun3078 has a LUN larger than allowed by the 
> host adapter

This looks like a problem with the BROWNIE device,  as I've found a
similar problem here:
http://lists.suse.com/archive/suse-amd64/2004-Mar/0069.html

This is with an Adaptec card, so chances are it's the device at
fault, not the driver.  Looks to me like a bad implementation of
REPORT_LUN, so this patch should remove those annoying messages:

Index: ./drivers/scsi/scsi_devinfo.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_devinfo.c,v
retrieving revision 1.16
diff -u -p -r1.16 scsi_devinfo.c
--- ./drivers/scsi/scsi_devinfo.c	17 Jan 2006 14:51:49 -0000	1.16
+++ ./drivers/scsi/scsi_devinfo.c	1 Mar 2006 13:17:21 -0000
@@ -126,6 +126,7 @@ static struct {
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */

>  Vendor: COMPAQ    Model: SDT-10000         Rev: 1.14
>  Type:   Sequential-Access                  ANSI SCSI revision: 02
> st: Version 20040318, fixed bufsize 32768, s/g segs 256
> Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
> st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA 
> 1048575
> 
> ------ For kernel 2.4:
> PCI: Enabling device 01:03.0 (0000 -> 0003)
> PCI: Found IRQ 9 for device 01:03.0
> sym.1.3.0: setting PCI_COMMAND_MASTER PCI_COMMAND_PARITY...
> sym.1.3.0: setting PCI_COMMAND_INVALIDATE.
> sym0: <1010-66> rev 0x1 on pci bus 1 device 3 function 0 irq 9
> sym0: using 64 bit DMA addressing
> sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: handling phase mismatch from SCRIPTS.
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.1.17a
> blk: queue df83a894, I/O limit 1048575Mb (mask 0xffffffffff)
>  Vendor: BROWNIE   Model: 1600U3P           Rev: 0001
>  Type:   Direct-Access                      ANSI SCSI revision: 03
> blk: queue df83a994, I/O limit 1048575Mb (mask 0xffffffffff)
>  Vendor: COMPAQ    Model: SDT-10000         Rev: 1.14
>  Type:   Sequential-Access                  ANSI SCSI revision: 02
> blk: queue df83aa94, I/O limit 1048575Mb (mask 0xffffffffff)
> sym0:1:0: tagged command queuing enabled, command queue depth 16.
> Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
> sym0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
> SCSI device sda: 2568192000 512-byte hdwr sectors (1314914 MB)
> /dev/scsi/host0/bus0/target1/lun0: p1 p2
> 
> 
> Thanks in advance.
> A. Corbiere
> 
> -- 
> Adrien CORBIERE                            Tel: 02.31.52.55.26
> IUT de Caen - Campus III                   Fax: 02.31.52.55.22
> Rue Anton Tchekhov
> B.P. 53
> 14123 Ifs 
