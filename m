From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
 reference to `request_firmware'
Date: Fri, 23 May 2008 14:48:49 -0700
Message-ID: <20080523144849.3773cac3.rdunlap@xenotime.net>
References: <200805161906.19321.toralf.foerster@gmx.de>
	<1211018673.3603.7.camel@localhost.localdomain>
	<20080517141749.GD3284@cs181133002.pp.htv.fi>
	<1211453544.3956.33.camel@localhost.localdomain>
	<20080523105412.cc13647d.rdunlap@xenotime.net>
	<1211565551.11477.26.camel@localhost.localdomain>
	<20080523110457.de353625.rdunlap@xenotime.net>
	<1211574780.11477.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:53876 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754808AbYEWVs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 17:48:57 -0400
Received: from midway.site ([72.90.125.186]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 14:48:49 -0700
In-Reply-To: <1211574780.11477.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 23 May 2008 15:33:00 -0500 James Bottomley wrote:

> On Fri, 2008-05-23 at 11:04 -0700, Randy Dunlap wrote:
> > On Fri, 23 May 2008 12:59:11 -0500 James Bottomley wrote:
> >=20
> > > On Fri, 2008-05-23 at 10:54 -0700, Randy Dunlap wrote:
> > > > On Thu, 22 May 2008 11:52:24 +0100 James Bottomley wrote:
> > > >=20
> > > > > On Sat, 2008-05-17 at 17:17 +0300, Adrian Bunk wrote:
> > > > > > On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley w=
rote:
> > > > > > > On Fri, 2008-05-16 at 19:06 +0200, Toralf F=F6rster wrote=
:
> > > > > > > > Hello,
> > > > > > > >=20
> > > > > > > > the build (.config attached) failed, make ends with :
> > > > > > > > ...
> > > > > > > >   UPD     include/linux/compile.h
> > > > > > > >   CC      init/version.o
> > > > > > > >   LD      init/built-in.o
> > > > > > > >   LD      vmlinux
> > > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > > (.text+0x33bab): undefined reference to `request_firmwa=
re'
> > > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > > (.text+0x33c3f): undefined reference to `release_firmwa=
re'
> > > > > > > > make: *** [vmlinux] Error 1
> > > > > > >=20
> > > > > > > There's a slight fault in the stub logic.  It fails for F=
W_LOADER=3Dm and
> > > > > > > the user =3Dy.
> > > > > > >=20
> > > > > > > This should fix it.
> > > > > >=20
> > > > > > An interesting question is whether we actually want to have=
 the stub at=20
> > > > > > all - the compile errors catched cases where someone forgot=
 to select=20
> > > > > > FW_LOADER at compile time instead of turning them into poss=
ible runtime=20
> > > > > > problems as will happen after your patch.
> > > > >=20
> > > > > Well, the original intent of the stubs was to have the loader=
 nop if it
> > > > > wasn't available.  There was simply one case forgotten (the f=
act that a
> > > > > modular loader isn't usable from built in components).
> > > > >=20
> > > > > > Are there any serious use cases where SCSI_SAS_LIBSAS is us=
ed in very=20
> > > > > > space limited environments and without any other drivers th=
at select=20
> > > > > > FW_LOADER in the kernel?
> > > > >=20
> > > > > Probably in the future, certainly on embedded OSs used for st=
orage
> > > > > devices.  Given the convergence of SAS/SATA chips, it's possi=
ble for
> > > > > other handhelds, but I'm not convinced of that.
> > > >=20
> > > > Has there been any resolution to this build issue?
> > > >=20
> > > > Do we know what we want?  then maybe a patch can be done...
> > >=20
> > > As long as the patch works, that's what I propose.
> >=20
> > Sorry, I am not understanding what you are saying.
> > Please explain.
>=20
> As long as the patch I previously posted on this thread
>=20
> http://marc.info/?l=3Dlinux-scsi&m=3D121101871800303
>=20
> Actually works.  This is the patch I propose to use to fix the issue.


Thanks for the pointer to the patch.  That does actually build cleanly
(but I would say that the patch is incorrect).

The case is (similar to that scsi_dh problem):
CONFIG_SCSI_SAS_LIBSAS=3Dy and CONFIG_FW_LOADER=3Dm, so libsas's
sas_request_addr() always returns -EINVAL as the value of
request_firmware().  Is that what we want/expect for these CONFIGs?


---
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
