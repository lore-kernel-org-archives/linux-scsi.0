From: Andrew Morton <akpm@osdl.org>
Subject: Re: sym2 probs in bk-scsi tree
Date: Thu, 8 Apr 2004 13:35:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408133502.71f38ecf.akpm@osdl.org>
References: <20040407231820.66dd76cd.akpm@osdl.org>
	<20040408145700.GB18329@parcelfarce.linux.theplanet.co.uk>
	<1081443560.2165.329.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:51913 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262424AbUDHUfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 16:35:17 -0400
In-Reply-To: <1081443560.2165.329.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: willy@debian.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Thu, 2004-04-08 at 09:57, Matthew Wilcox wrote:
> > They certainly are scary.  What is device 15 on this scsi bus?  This
> > looks like domain validation being applied to a device that can't do it
> > to me.  Did I get that right, James?
> 
> OK, try the attached, it should predicate DV on what we already know
> from the inquiry data.
> 
> James
> 
> ===== drivers/scsi/scsi_transport_spi.c 1.9 vs edited =====
> --- 1.9/drivers/scsi/scsi_transport_spi.c	Thu Apr  8 08:39:09 2004
> +++ edited/drivers/scsi/scsi_transport_spi.c	Thu Apr  8 12:35:07 2004
> @@ -490,7 +490,7 @@
>  	}
>  
>  	/* test width */
> -	if (i->f->set_width) {
> +	if (i->f->set_width && sdev->wdtr) {
>  		i->f->set_width(sdev, 1);
>  
>  		if (!spi_dv_device_compare_inquiry(sreq, buffer,
> @@ -502,6 +502,10 @@
>  	}
>  
>  	if (!i->f->set_period)
> +		return;
> +
> +	/* device can't handle synchronous */
> +	if(!sdev->ppr && !sdev->sdtr)
>  		return;
>  
>  	/* now set up to the maximum */

Yup, that makes the pauses and scary messages go away, thanks.

fwiw, here's the scsi-related part of dmesg:

sym0: <1010-66> rev 0x1 at pci 0000:41:01.0 irq 103
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
DEV: registering device: ID = 'host0'
CLASS: registering class device: ID = 'host0'
class_hotplug - name = host0
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:8:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:8:0): Beginning Domain Validation
sym0:8: wide asynchronous.
sym0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:8:0): Ending Domain Validation
DEV: registering device: ID = '0:0:8:0'
bus scsi: add device 0:0:8:0
CLASS: registering class device: ID = '0:0:8:0'
class_hotplug - name = 0:0:8:0
CLASS: registering class device: ID = '0:0:8:0'
class_hotplug - name = 0:0:8:0
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:9:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:9:0): Beginning Domain Validation
sym0:9: wide asynchronous.
sym0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:9:0): Ending Domain Validation
DEV: registering device: ID = '0:0:9:0'
bus scsi: add device 0:0:9:0
CLASS: registering class device: ID = '0:0:9:0'
class_hotplug - name = 0:0:9:0
CLASS: registering class device: ID = '0:0:9:0'
class_hotplug - name = 0:0:9:0
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:10:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:10:0): Beginning Domain Validation
sym0:10: wide asynchronous.
sym0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:10:0): Ending Domain Validation
DEV: registering device: ID = '0:0:10:0'
bus scsi: add device 0:0:10:0
CLASS: registering class device: ID = '0:0:10:0'
class_hotplug - name = 0:0:10:0
CLASS: registering class device: ID = '0:0:10:0'
class_hotplug - name = 0:0:10:0
  Vendor: IBM       Model: IC35L036UCD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:11:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:11:0): Beginning Domain Validation
sym0:11: wide asynchronous.
sym0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:11:0): Ending Domain Validation
DEV: registering device: ID = '0:0:11:0'
bus scsi: add device 0:0:11:0
CLASS: registering class device: ID = '0:0:11:0'
class_hotplug - name = 0:0:11:0
CLASS: registering class device: ID = '0:0:11:0'
class_hotplug - name = 0:0:11:0
  Vendor: IBM       Model: HSBPD4E  PU3SCSI  Rev: 0013
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(0:0:15:0): Beginning Domain Validation
sym0:15:0:phase change 6-7 6@28050390 resid=4.
scsi(0:0:15:0): Ending Domain Validation
DEV: registering device: ID = '0:0:15:0'
bus scsi: add device 0:0:15:0
CLASS: registering class device: ID = '0:0:15:0'
class_hotplug - name = 0:0:15:0
CLASS: registering class device: ID = '0:0:15:0'
class_hotplug - name = 0:0:15:0
bound device '0000:41:01.0' to driver 'sym53c8xx'
PCI: Enabling device: (0000:41:01.1), cmd 143
sym1: <1010-66> rev 0x1 at pci 0000:41:01.1 irq 104
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.1.18j
DEV: registering device: ID = 'host1'
CLASS: registering class device: ID = 'host1'
class_hotplug - name = host1
bound device '0000:41:01.1' to driver 'sym53c8xx'
PCI: Enabling device: (0001:21:01.0), cmd 143
sym2: <875> rev 0x3 at pci 0001:21:01.0 irq 117
sym2: No NVRAM, ID 7, Fast-20, SE, parity checking
sym2: SCSI BUS has been reset.
scsi2 : sym-2.1.18j
DEV: registering device: ID = 'host2'
CLASS: registering class device: ID = 'host2'
...
device class 'scsi_tape': registering
bus scsi: add driver st
bus scsi: add driver sd
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 >
Attached scsi disk sda at scsi0, channel 0, id 8, lun 0
bound device '0:0:8:0' to driver 'sd'
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1 < sdb5 >
Attached scsi disk sdb at scsi0, channel 0, id 9, lun 0
bound device '0:0:9:0' to driver 'sd'
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1 < sdc5 >
Attached scsi disk sdc at scsi0, channel 0, id 10, lun 0
bound device '0:0:10:0' to driver 'sd'
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdd: drive cache: write through
 sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 >
Attached scsi disk sdd at scsi0, channel 0, id 11, lun 0
bound device '0:0:11:0' to driver 'sd'
bus scsi: add driver sr
device class 'scsi_generic': registering
CLASS: registering class device: ID = 'sg0'
class_hotplug - name = sg0
Attached scsi generic sg0 at scsi0, channel 0, id 8, lun 0,  type 0
CLASS: registering class device: ID = 'sg1'
class_hotplug - name = sg1
Attached scsi generic sg1 at scsi0, channel 0, id 9, lun 0,  type 0
CLASS: registering class device: ID = 'sg2'
class_hotplug - name = sg2
Attached scsi generic sg2 at scsi0, channel 0, id 10, lun 0,  type 0
CLASS: registering class device: ID = 'sg3'
class_hotplug - name = sg3
Attached scsi generic sg3 at scsi0, channel 0, id 11, lun 0,  type 0
CLASS: registering class device: ID = 'sg4'
class_hotplug - name = sg4
Attached scsi generic sg4 at scsi0, channel 0, id 15, lun 0,  type 13


