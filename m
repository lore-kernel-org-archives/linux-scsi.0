From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Fri, 3 Dec 2004 10:33:17 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C73423E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:31167 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262400AbULCRdf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2004 12:33:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Why does spi_attach_transport or fc_attach_transport have to be
done from the module_init routines?  Meaning there is an assumption
that spi and FC are separate drivers.  Why can't the xxx_attach_transport be
done
later from the probe routines when we know which pci devices we are
attaching?

The problem is the mpt fusion drivers use the same host to firmware 
interface several bus types, e.g. U320 SCSI, 2gb and 4gb FC, and SAS
chipsets 
are using the same message passing protocol.  Bottom line, we are not going
to 
create separate drivers for SCSI, FC, and SAS, having redundant code through
out.
I'm sure other vendors having unified drivers for several bus types in the
kernel source
tree.  I would assume this will be the case for other vendors when SAS
starts getting added.

Also another problem. How about creating driver update disks?  It appears to
me this process is now
broken as driver linking xxx_attach_transport will not load the LLDs.
Now we will need to include scsi_transport_fc.ko and scsi_transport_spi.ko 
on the floppy, and hacking required so these transport ko's are loaded prior
to the LLDs.

Eric

On Wednesday, December 01, 2004 4:41 PM, Moore, Eric Dean wrote:
> On Wednesday, December 01, 2004 1:50 PM, James Bottomley wrote:
> > Nothing complex.  How about just a simple module wrapper for the PCI
> > attachment, so you have the FC devices in one, the SPI in 
> > another etc. 
> > Then you could attach and initialise the FC transport only 
> if the user
> > modprobes the FC driver.
> > 
> > I just don't see it being tenable to drag in the whole of the fc
> > transport class in a SCSI only configuration for fusion.
> > 
> 
> This sounds to me that your asking for a separate drivers for 
> SCSI, FC and SAS. Right?
> Meaning in addition to mptscsih.ko, we would have mptfc.ko, 
> mptsas.ko. Each
> having its unique module_init, module_exit, and probe routines.  
> If so, code will triple because now we will be replicating 
> same source across drivers 
> that handle scsi queued commands, interrupt handling, error 
> recovery, firmware
> asyn event handling, etc.  
> 
> Eric Moore
> 
