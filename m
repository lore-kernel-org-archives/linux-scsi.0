From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH 1/2] cpqfc: fix for "Using too much stach" in 2.6 kernel
Date: Thu, 4 Aug 2005 19:11:38 +0200
Message-ID: <200508041911.46911@bilbo.math.uni-mannheim.de>
References: <4221C1B21C20854291E185D1243EA8F302623BCC@bgeexc04.asiapacific.cpqcorp.net> <200508041756.23611@bilbo.math.uni-mannheim.de> <20050804164259.GD22886@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1640321.ZKjtb9X6bI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:26316 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S261788AbVHDRL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 13:11:58 -0400
In-Reply-To: <20050804164259.GD22886@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>, linux-scsi@vger.kernel.org, axboe@suse.de

--nextPart1640321.ZKjtb9X6bI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dave Jones wrote:
>On Thu, Aug 04, 2005 at 05:56:14PM +0200, Rolf Eike Beer wrote:
> > Am Donnerstag, 4. August 2005 17:40 schrieb Dave Jones:
> > >On Thu, Aug 04, 2005 at 11:38:30AM +0200, Rolf Eike Beer wrote:
> > > > >+	  ulFibreFrame = kmalloc((2048/4), GFP_KERNEL);
> > > >
> > > > The size bug was already found by Dave Jones. This never should be
> > > > written this way (not your fault). The array should have been
> > > > [2048/sizeof(ULONG)].
> > >
> > >wasteful. We only ever use 2048 bytes of this array, so doubling
> > >its size on 64bit is pointless, unless you make changes later on
> > >in the driver. (Which I think don't make sense, as we just copy
> > >32 64byte chunks).
> >
> > No, this is how it should have been before. This way it would have been
> > clear where the magic 4 came from.
>
>It's pointless to fix this, without fixing also CpqTsGetSFQEntry()
>...

At least half of the file should be rewritten.

> > >we're trashing the last 48 bytes of every copy we make.
> > >Does this driver even work ?
> >
> > No, ulDestPtr ist ULONG* so we increase it by sizeof(ULONG)*16 which is
> > 64.
>
>Duh, yes.  That is broken on 64-bit however, where it will advance 128 bytes
>instead of 64 bytes.

ULONG is defined to __u32 in some of the cpq* headers.

Eike

--nextPart1640321.ZKjtb9X6bI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBC8kxSXKSJPmm5/E4RAvDxAKCDr0RL7r+kInJoZYvrw/+P+Av51gCfbmFP
Iozo+/e24VHZZyy7CHR/OcQ=
=NbXn
-----END PGP SIGNATURE-----

--nextPart1640321.ZKjtb9X6bI--
