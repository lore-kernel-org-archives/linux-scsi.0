From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Mon, 6 Dec 2004 17:29:25 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C7F9D08@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39863 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261715AbULGA3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2004 19:29:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Monday, December 06, 2004 10:21 AM, James Bottomley wrote:
> 
> On Mon, 2004-12-06 at 11:12, Moore, Eric Dean wrote:
> > Our concern is the impact to linux distributions installers and
> > end users that upgrade to these newer drivers.  
> > Example: Someone having older driver using boot device attached
> > to our controller.  Then they download a newer kernel from 
> Kernel.org with
> > newer
> > drivers having mptfc.  They mkinitrd, or mk_initrd (without modifing
> > linuxrc),
> > reboot then what?  Can they see the boot partition?   
> 
> That's a concern only for people who boot from your fibre 
> adapters.  How
> many such users are there?

I'm checking into this, and let you know. I'm pretty certain
that there are people who have blade severs connected to a SAN using
our LSI FC controller, and then booting to devices in FC RAID storage 
array(from other vendors) populated out on the SAN.

> 
> > Can we change the time when LLDs register themselves to the 
> > transport layer?  Like from the probe routine.
> 
> Well, not really, unless you have a proposal to get around the
> fundamental problem Christoph already pointed out:  any 
> reference to the
> fc_ transport methods will automatically cause modprobe to load it
> regardless of whether it is used.
> 

Also, I forgot to mention other concerns in previous email.

(1) If mptfc depends on mptscsih, then what is going to be said
when we implement the domain validation using the spi transport layer?
When someone loads mptfc.ko, then we need mptscsih.ko and
scsi_transport_spi.ko
loaded, even though there is no U320 adapter present.  The same complaint
can
be said here.  In my current kernel, scsi_transport_spi.ko = 35KB,
scsi_transport_fc.ko = 27KB.

(2) Also, I think there is more involved than just 
moving mptbase_pci_table from mptbase.c to mptscsih.c.
mptbase_probe is enumerating the bus's when pci_module_init(_)
 is called.  Would mptscsih.c be calling pci_module_init instead?  
If so, will the current code for mptbase_probe still 
work as is, or will it need moving to mptscsih?  If its moved, 
then mptlan.ko and mptctl.ko would not be able to work as it does today?  
They currently depend only on mptbase.ko.

Eric

    






