From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 11:09:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040903180942.GA28970@beaverton.ibm.com>
References: <200409021719.15267.bjorn.helgaas@hp.com> <1094168177.2097.154.camel@mulgrave> <200409030844.41174.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:2265 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269722AbUICSKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2004 14:10:11 -0400
Content-Disposition: inline
In-Reply-To: <200409030844.41174.bjorn.helgaas@hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Sep 03, 2004 at 08:44:40AM -0600, Bjorn Helgaas wrote:
> On Thursday 02 September 2004 5:36 pm, James Bottomley wrote:
> > On Thu, 2004-09-02 at 19:19, Bjorn Helgaas wrote:
> > > Not being a real SCSI person, I'm sure there's some clever way I'=
m
> > > supposed to figure out which disk is /dev/sda. =A0But sometimes i=
t's
> > > not clear from the kernel boot messages, particularly for drivers
> > > that don't print the PCI address of the adapter.
> >=20
> > You do it like this:
> >=20
> > jejb@gsyprf11> ls -l /sys/block/sda/device
> > lrwxrwxrwx =A01 root root 0 Aug 22 10:57 /sys/block/sda/device ->
> > ../../devices/parisc0/parisc0:0/pci0000:00/0000:00:01.1/host1/1:0:1=
5:0/
>=20
> Thanks, I knew there must be a cool way.  That doesn't help if you're
> trying to figure out the correct "root=3D" to boot your box, of cours=
e...

What exactly is the "root=3D" problem? You mean device names changing?

Also lsscsi gives simple easy to read output.=20

http://www.torque.net/scsi/lsscsi.html

[elm3a211 patman]$ lsscsi
[0:0:0:0]    enclosu IBM      EXP700           9319  -      =20
[0:0:1:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sda
[0:0:2:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdb
[0:0:3:0]    enclosu IBM      EXP700           9319  -      =20
[0:0:4:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdc
[0:0:5:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdd

I[elm3a211 patman]$ lsscsi -g
[0:0:0:0]    enclosu IBM      EXP700           9319  -         /dev/sg0
[0:0:1:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sda  /dev/sg1
[0:0:2:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdb  /dev/sg2
[0:0:3:0]    enclosu IBM      EXP700           9319  -         /dev/sg3
[0:0:4:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdc  /dev/sg4
[0:0:5:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdd  /dev/sg5

I don't know if it works right with udev (i.e. I think it only prints
default kernel names, just those found under sysfs, so if you don't use=
r
default kernels names with udev it might not show the correct /dev name=
).

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
