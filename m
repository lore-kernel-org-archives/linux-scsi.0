From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Good afternoon to everyone. Question about PERC 4Di on Dell poweredge 1750
Date: Thu, 10 Jun 2004 22:01:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611030137.GA27434@lists.us.dell.com>
References: <40C8FEF9.5090106@citi.com.mx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:9111 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S263740AbUFKDBj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 23:01:39 -0400
Content-Disposition: inline
In-Reply-To: <40C8FEF9.5090106@citi.com.mx>
List-Id: linux-scsi@vger.kernel.org
To: David Ramirez Joya <dramirez@citi.com.mx>
Cc: linux-scsi@vger.kernel.org, mailman-owner@us.dell.com, Juan Antonio Garza Garza <jgarza@citi.com.mx>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 10, 2004 at 07:38:17PM -0500, David Ramirez Joya wrote:
> Dell Moderator: I Subscribed to the linux-scsi mailing list in order to=
=20
> send this message maybe it should be sent to another list _please_ help=
=20
> me and send it to the porper list if this is not the one.

linux-scsi is appropriate for general megaraid driver questions.  This is m=
ore
related to a particular hardware platform and OS combination, and as
such, linux-poweredge@dell.com (subscribe at http://lists.us.dell.com)
is probably more appropriate.  But I'll answer best as I can here.

> I have a Dell Poweredge 1750 with the PERC 4Di SCSI controller.

OK, and thanks for buying Dell. :-)
=20
> I HAVE to install redhat 7.3 on this platform.
> Now, for now I have no option but to install Redhat 7.3 o 7.2 on this=20
> server. This is because a software product requires the kernel version=20
> included in this distribution version.

Given that the OS vendor no longer officially supports these versions,
you may wish to have your vendor reconsider on those grounds.

> I have downloaded the DKMS megaraid2-2.10.1 driver. I have managed to=20
> compile it with the kernel version 2.4.18-3.

Cool.  Glad you were able to make DKMS work for you.

> So after I managed for the driver to compile, I mkdriverdisk with dkms,=
=20

Here's the interesting part.=20
a) Which kernels did you compile the driver for?  If you didn't
include the -BOOT variant (dkms -k 2.4.18-3BOOT) in the list you built
it for, then the driver disk won't work of course.  You'll want to
build it for the 2.4.18-3smp too I expect, then mkdriverdisk will put
all you built on the disk.

b) on what system (OS version, compiler) did you build this?  You must
use the same compiler, gcc 2.96 era from RHL7.3, to compile kernel
modules for 7.3.  You can't use gcc 3.x and have it work.

> created the driver disk and I tried to make the driver to work with=20
> "linux dd". The driver diskette was "incompatible with this version of=20
> RedHat". I found out that there was missing the "- rh73" at the end of=20
> the modinfo an disk-info line which state the driver name... With this=20
> modification I managed to make RedHat 7.3 to "accept" the driver disk.=20
> But the module is not accepted.
>=20
> I looked on the logs, the problem is RedHat knows that the Megaraid=20
> Driver needs a "Hardware SCSI" driver (I do not know how to call this)=20
> which is one of aacraid, aic7xxx then it looks for the megaraid2.o !!!=20
> driver on the BOOT Image of the redhat 7.3 Installation... Or so I=20
> think. (please correct me if I am wrong but I guess this is what happens=
=20
> on the boot sequence).

It should be looking for that on the floppy, which I expect you didn't
build it.

> If yes, please send me a clue on how to do it!!! Do I need to recompile=
=20
> the megaraid2 driver with special options? Do I have to recreate the=20
> accraid driver? aic7xxx driver??? A special patch not publicy=20
> disclosed??? :-S

No, megaraid2 is appropriate.  You're pretty close...  and I'm glad
you're using DKMS as it's intended to be used, exactly for backporting
newer drivers to older kernels.

On your build system, do a 'dkms install -m megaraid2 -v 2.10.1 -k
2.4.18-3BOOT' (you've got that kernel installed on your build system,=20
right?  Depmod will tell you if that fails, and then you can fix it up
before making the driver disk.

Good luck.
-Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAySCRIavu95Lw/AkRAlZdAJ9JhytF2NJZNJjReR5DQHJC54rkbQCgi1eM
THcT/2k+omXSeamNHDTqg4g=
=YE6i
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
