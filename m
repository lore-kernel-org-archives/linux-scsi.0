From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: PATCH: 64 bit support for dpt_i2o driver
Date: Wed, 23 Apr 2008 23:29:16 +0200
Message-ID: <200804232329.22140.eike-kernel@sf-tec.de>
References: <20080418215937.GA15199@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1988683.Hghz9nrACq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:59109 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYDWVgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 17:36:09 -0400
In-Reply-To: <20080418215937.GA15199@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>

--nextPart1988683.Hghz9nrACq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Miquel van Smoorenburg wrote:
> I've been running supermicro hardware with the Adaptec 2005/2010/2015
> zero channel raid controllers for a long while. The dpt_i2o driver
> in the kernel doesn't support 64-bit mode, yet I wanted to run
> a 64-bit system. The i2o_block driver wasn't 64-bit capable either.
> Mark Salyzyn from Adaptec kindly provided me with a 64-bit version
> of the dpt_i2o driver, unfortunately it never made its way to
> the upstream kernel.
>
> In my experience, the dpt_i2o driver is rock-stable for the
> Adaptec ZCR hardware, while the i2o_block driver isn't.
> Because the dpt_i2o driver is still in the kernel and actively
> being used, I decided to merge the essential 64 bits parts
> of the alternative driver into the current kernel dpt_i2o driver.
>
> # --------- dpt_i2o-64bit-2.6.25.patch ----------------
>
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
>
> It contains the following changes:
>
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>   this is needed because we need to pass the proper device to
>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>   because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>   can create /dev/dptiX dynamically
>
> Obviously there are more cleanups that can be done to this code,
> but we need to start somewhere. Patch has been tested heavily on
> both 32 and 64 bit x86 platforms.

Is there any chance that you could split this into (at least) 2 patches, on=
e=20
for the 64 bit stuff and one for the driver model stuff? This patch is huge=
,=20
the review (and the chances for this getting merged) will be higher if it i=
s=20
in small pieces.

Greetings,

Eike

--nextPart1988683.Hghz9nrACq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBID6oyXKSJPmm5/E4RAtQGAJwOPHrQMK7oFSYnkZKYY6zttVLkuQCgmHlm
U3WdBxCAtp8Yt/KVKZqUgZk=
=xM7B
-----END PGP SIGNATURE-----

--nextPart1988683.Hghz9nrACq--
