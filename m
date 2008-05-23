From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Date: Fri, 23 May 2008 15:33:00 -0500
Message-ID: <1211574780.11477.44.camel@localhost.localdomain>
References: <200805161906.19321.toralf.foerster@gmx.de>
	 <1211018673.3603.7.camel@localhost.localdomain>
	 <20080517141749.GD3284@cs181133002.pp.htv.fi>
	 <1211453544.3956.33.camel@localhost.localdomain>
	 <20080523105412.cc13647d.rdunlap@xenotime.net>
	 <1211565551.11477.26.camel@localhost.localdomain>
	 <20080523110457.de353625.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40968 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbYEWUdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 16:33:04 -0400
In-Reply-To: <20080523110457.de353625.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Adrian Bunk <bunk@kernel.org>, Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2008-05-23 at 11:04 -0700, Randy Dunlap wrote:
> On Fri, 23 May 2008 12:59:11 -0500 James Bottomley wrote:
>=20
> > On Fri, 2008-05-23 at 10:54 -0700, Randy Dunlap wrote:
> > > On Thu, 22 May 2008 11:52:24 +0100 James Bottomley wrote:
> > >=20
> > > > On Sat, 2008-05-17 at 17:17 +0300, Adrian Bunk wrote:
> > > > > On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley wro=
te:
> > > > > > On Fri, 2008-05-16 at 19:06 +0200, Toralf F=C3=B6rster wrot=
e:
> > > > > > > Hello,
> > > > > > >=20
> > > > > > > the build (.config attached) failed, make ends with :
> > > > > > > ...
> > > > > > >   UPD     include/linux/compile.h
> > > > > > >   CC      init/version.o
> > > > > > >   LD      init/built-in.o
> > > > > > >   LD      vmlinux
> > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > (.text+0x33bab): undefined reference to `request_firmware=
'
> > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > (.text+0x33c3f): undefined reference to `release_firmware=
'
> > > > > > > make: *** [vmlinux] Error 1
> > > > > >=20
> > > > > > There's a slight fault in the stub logic.  It fails for FW_=
LOADER=3Dm and
> > > > > > the user =3Dy.
> > > > > >=20
> > > > > > This should fix it.
> > > > >=20
> > > > > An interesting question is whether we actually want to have t=
he stub at=20
> > > > > all - the compile errors catched cases where someone forgot t=
o select=20
> > > > > FW_LOADER at compile time instead of turning them into possib=
le runtime=20
> > > > > problems as will happen after your patch.
> > > >=20
> > > > Well, the original intent of the stubs was to have the loader n=
op if it
> > > > wasn't available.  There was simply one case forgotten (the fac=
t that a
> > > > modular loader isn't usable from built in components).
> > > >=20
> > > > > Are there any serious use cases where SCSI_SAS_LIBSAS is used=
 in very=20
> > > > > space limited environments and without any other drivers that=
 select=20
> > > > > FW_LOADER in the kernel?
> > > >=20
> > > > Probably in the future, certainly on embedded OSs used for stor=
age
> > > > devices.  Given the convergence of SAS/SATA chips, it's possibl=
e for
> > > > other handhelds, but I'm not convinced of that.
> > >=20
> > > Has there been any resolution to this build issue?
> > >=20
> > > Do we know what we want?  then maybe a patch can be done...
> >=20
> > As long as the patch works, that's what I propose.
>=20
> Sorry, I am not understanding what you are saying.
> Please explain.

As long as the patch I previously posted on this thread

http://marc.info/?l=3Dlinux-scsi&m=3D121101871800303

Actually works.  This is the patch I propose to use to fix the issue.

James



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
