From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Mon, 6 Dec 2004 10:12:41 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C734893@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28032 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261577AbULFRMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2004 12:12:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Your wanting a separate module mptfc.ko for fc pci ids, right? 
Which means current fc pci ids that are supported in mptscshi.ko, 
are now moved to new driver mptfc.ko. LSI Management told me NO 
to this solution.
  
Our concern is the impact to linux distributions installers and
end users that upgrade to these newer drivers.  
Example: Someone having older driver using boot device attached
to our controller.  Then they download a newer kernel from Kernel.org with
newer
drivers having mptfc.  They mkinitrd, or mk_initrd (without modifing
linuxrc),
reboot then what?  Can they see the boot partition?   

Can we change the time when LLDs register themselves to the 
transport layer?  Like from the probe routine.


Eric Moore

On Monday, December 06, 2004 8:18 AM, James Bottomley wrote:
> 
> On Fri, 2004-12-03 at 11:33, Moore, Eric Dean wrote:
> > Why does spi_attach_transport or fc_attach_transport have to be
> > done from the module_init routines?  Meaning there is an assumption
> > that spi and FC are separate drivers.  Why can't the 
> xxx_attach_transport be
> > done
> > later from the probe routines when we know which pci devices we are
> > attaching?
> 
> Can we take a step back from this and look at the actual 
> problem you're
> trying to solve with the fc class?
> 
> At the moment, its only real use is to display certain device
> parameters, which is a passive feature (although it now has 
> the capacity
> to control cable pull blocking, which will be an active facility).
> 
> Your requirement came from SGI, who cares about the parameters.  What
> I'm proposing is that you move the mptbase_pci_table out of mptbase.c
> and into *two* upper modules (you could even do it into 
> mptscsih.c and a
> new mptfc.c, which would depend on mptscsih).  Now you have the FC
> devices registered separately, you can put all of the fc transport
> display into mptfc.c.  This involves moving no code other than the
> actual PCI table.  Linux will automatically only modprobe mptfc if the
> user has a FC device PCI ID and everyone will be happy.
> 
> Why is this such a hard thing to do?
> 
> James
> 
> 
