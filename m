From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 23:42:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040903214252.GA32452@suse.de>
References: <200409021719.15267.bjorn.helgaas@hp.com> <200409030844.41174.bjorn.helgaas@hp.com> <20040903180942.GA28970@beaverton.ibm.com> <200409031413.49104.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:16050 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S269691AbUICVpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2004 17:45:55 -0400
Content-Disposition: inline
In-Reply-To: <200409031413.49104.bjorn.helgaas@hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 On Fri, Sep 03, Bjorn Helgaas wrote:

> On Friday 03 September 2004 12:09 pm, Patrick Mansfield wrote:
> > > Thanks, I knew there must be a cool way.  That doesn't help if yo=
u're
> > > trying to figure out the correct "root=3D" to boot your box, of c=
ourse...
> >=20
> > What exactly is the "root=3D" problem? You mean device names changi=
ng?
>=20
> Walk up to a box with a number of data disks already attached.  Plug
> in a new disk with a root filesystem on it.  Now try to boot the box,
> using the new root filesystem.  What do you specify?  It's difficult
> in general to figure it out. =20

In this case the filesystem UUID or a string returned by an external
udev helper like scsi_id will help. udev will create a /dev/foo and you=
r
initrd will mount that. We have predefined names (symlink to the kernel
device node) like /dev/disk/by-id/SIBM_ST336753LC_3HX1AJJX00007407HDF3p=
1
in initramfs.
You can use them, or specify your own in udev.rules. Since the disk
content will not change and there will (hopefully) not another one with
the same VPD, everything will work as expected.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
