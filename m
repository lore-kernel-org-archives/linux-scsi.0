From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: LSI SAS changes SCSI address and by-path on hot-swap
Date: Fri, 12 Mar 2010 09:32:37 -0600
Message-ID: <1268407958.2802.3.camel@mulgrave.site>
References: <4B8FE5F2.2040506@shiftmail.org>
	 <1267770172.8894.24.camel@mulgrave.site>
	 <627C309F4690914DAF54F22C0CD5F9001FCCFAD082@FRD01MAIL01.ads.invitrogen.net>
	 <4B918E42.6030009@shiftmail.org>
	 <627C309F4690914DAF54F22C0CD5F9001FCD0266B9@FRD01MAIL01.ads.invitrogen.net>
	 <4B9A5CE4.9070000@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0CLPco (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 10:32:44 -0500
In-Reply-To: <4B9A5CE4.9070000@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: "Moore, Michael" <Michael.Moore@lifetech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2010-03-12 at 16:25 +0100, Asdo wrote:
> Moore, Michael wrote:
> > Sorry for top posting, but Outlook just screws it all up.
> >
> > The cards I've used are a LSI Logic SAS 3800X (8 port External PCI-X card w/ 2 x SFF-8470 SAS connectors) and LSI SAS 3801E ( 8 Port External PCI-e card with 2 x SFF-8088 SAS connectors).  Each connector has 4 SAS links.
> > The SAS protocol is downwardly compatible with SATA, so you can run SATA drives right on a SAS cable.
> >
> > So, in my setup, I basically have 1 drive per SAS link.  No expanders, or anything fancy.  The issues I mentioned happens to the 4 drives on the same connector.  When the driver is detecting the new drive, it looks like it redetects all of the drives on the connector (or it at least reports one new drive and the other existing drives).  If you were in a directory from one of the mounted drives, you get IO Errors as it appears that the drive was removed, and then remounted, but in a way that was not clean.  
> >
> > This has happened with Default CentOS 5 kernels (2.6.18-*.el5), 2.6.26 vanilla, 2.6.30 vanilla, Fedora latest.
> > The issue appeared no matter what.
> >
> > The udev rules used the ENV{ID_PATH} option to tie to the sysfs value that indicated which PCI ID + SAS phy on the SAS HBA used by the drives to the device detected by the kernel, and then create a symlink from the /dev/sd<X> entry to /dev/slot<Y>, where Y is the label on the slot of the hot swap bays (a-h).   Here is an example of the rule:
> >
> > KERNEL=="sd*", ENV{ID_PATH}=="pci-0000:04:00.0-sas-phy0:1*", SYMLINK+="slota%n"
> >
> > I did this because the device ID number that the kernel reports increments every time a drive is swapped.  So, even though you are using the same SAS channel, you do not have a consistent drive numbering.  So I had to go down to the SAS phy to get something consistent.  The SiI-3124/libata setup had consistent device ID's (the ID was tied to the SATA channel, and I used the device ID to do the mapping.  Perhaps udev is the reason for the issues, but I tend to think it is the way the SAS/SCSI subsystem works as I have never seen the SATA/libata subsystem have this "rescan/remount" behavior.
> >   
> 
> This looks like a horrible bug for people having software RAID on the 
> disks (or maybe even hardware RAID)

Not really, most people want to identify the disk permanently, not the
slot, so that's what /dev/disk/by-id and /dev/disk/by-uuid is for.

> I seem not to have this bug on ubuntu kernel 2.6.24, I mean my situation 
> was similar with the mainboard-integrated LSISAS 1068E and it didn't 
> happen to me, but that doesn't mean much...
> 
> Also, LSI controllers are very much used by linuxers.
> Have you tried reporting it here and try to get it fixed?
> Or reporting it to the LSI tech support? They are pretty responsive even 
> if their web interface is a bit strange.
> 
> I'm thinking about buying a few of LSI HBA controllers for linux 
> software RAID use, probably external ones like the one you have. Maybe 
> attached to expanders. I'll keep my fingers crossed!

It's not just LSI that does this ... every SAS board will tend to
increment target numbers on add and remove because that's the way the
transport class does it.  In linux, you have to expect the /dev/sdX name
to be volatile and mount by id or uuid instead.  To mount by slot, you
can use the phy workaround for SAS/SATA, but you should really be using
an enclosure management service.

James


