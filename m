From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Sat, 08 Jan 2005 16:33:27 -0500
Message-ID: <1105220008.3982.9.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C7F9D08@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40416 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262243AbVAIDze (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jan 2005 22:55:34 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C7F9D08@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-12-06 at 17:29 -0700, Moore, Eric Dean wrote:
> Monday, December 06, 2004 10:21 AM, James Bottomley wrote:
> > On Mon, 2004-12-06 at 11:12, Moore, Eric Dean wrote:
> > > Our concern is the impact to linux distributions installers and
> > > end users that upgrade to these newer drivers.  
> > > Example: Someone having older driver using boot device attached
> > > to our controller.  Then they download a newer kernel from 
> > Kernel.org with
> > > newer
> > > drivers having mptfc.  They mkinitrd, or mk_initrd (without modifing
> > > linuxrc),
> > > reboot then what?  Can they see the boot partition?   
> > 
> > That's a concern only for people who boot from your fibre 
> > adapters.  How
> > many such users are there?
> 
> I'm checking into this, and let you know. I'm pretty certain
> that there are people who have blade severs connected to a SAN using
> our LSI FC controller, and then booting to devices in FC RAID storage 
> array(from other vendors) populated out on the SAN.

Well, I talked to the people in charge of the Vendor Kernel's at Red Hat
and SuSE.  They have agreed make the installer changes needed to help
people upgrading from the current monolithic fusion driver to a more
modular one.  (Sorry for the delay, it took a while to get everyone's
buy in for this).

> Also, I forgot to mention other concerns in previous email.
> 
> (1) If mptfc depends on mptscsih, then what is going to be said
> when we implement the domain validation using the spi transport layer?
> When someone loads mptfc.ko, then we need mptscsih.ko and
> scsi_transport_spi.ko
> loaded, even though there is no U320 adapter present.  The same complaint
> can
> be said here.  In my current kernel, scsi_transport_spi.ko = 35KB,
> scsi_transport_fc.ko = 27KB.

Actually, I think I'd like this to be a clean modularisation, so the SPI
functions go in one piece, the FC functions in another and the SAS
functions in yet a third.  Then everything could depend on the core
fusion engine for the interface with firmware.  That would allow:

- the transport classes to attach correctly,
- the transport dependent functions (which currently litter the driver
as if (spi) else if(fc) to be contained individually
- and the PCI ID's which will drive the installer and upgrade processes
to be stored in the transport dependent pieces.

> (2) Also, I think there is more involved than just 
> moving mptbase_pci_table from mptbase.c to mptscsih.c.
> mptbase_probe is enumerating the bus's when pci_module_init(_)
>  is called.  Would mptscsih.c be calling pci_module_init instead?  
> If so, will the current code for mptbase_probe still 
> work as is, or will it need moving to mptscsih?  If its moved, 
> then mptlan.ko and mptctl.ko would not be able to work as it does today?  
> They currently depend only on mptbase.ko.

Well, I think the true way it should happen is to make mptbase house
only the functions necessary to implement the fusion firmware API
(although generic functions could be part of it as well).  Then a true
fusion driver would have an mpt transport module, the base module and
optionally the mptlan module.  If I read mptctl right, it only
implements the RAID ioctl features, so it could likewise be optional.

James


