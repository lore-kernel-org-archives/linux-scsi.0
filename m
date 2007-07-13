From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 16:19:54 +0200
Message-ID: <200707131619.54898.arnd@arndb.de>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be> <1184335333.3402.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:56544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbXGMOiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 10:38:17 -0400
In-Reply-To: <1184335333.3402.20.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

On Friday 13 July 2007, James Bottomley wrote:
>=20
> > IC.
> >=20
> > =A0 - flush_kernel_dcache_page() is a no-op on ppc64
> > =A0 =A0 (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc onl=
y).
> >=20
> > =A0 - For reference, drivers/scsi/ipr.c (another ppc64 driver) just=
 uses a plain
> > =A0 =A0 kmap/memcpy/kunmap sequence
> >=20
> > So what should I do?
>=20
> Ask someone who knows the architecture ... Anton, Paulus or Benh ... =
I'm
> fairly certain PPC is VIPT and will need some kind of alias
> resolution ... perhaps its associative enough not to let the aliases =
be
> a problem.

I'm pretty sure that no ppc64 machine needs alias resolution in the ker=
nel,
although some are VIPT. Last time we discussed this, Segher explained i=
t
to me, but I don't remember which way Cell does it. IIRC, it automatica=
lly
flushes cache lines that are accessed through aliases.

It's probably a good idea to have the flush_kernel_dcache_page() in the=
re
anyway, if only to serve as an example for people that copy it into
architecture-independent drivers, same as what we do for the
k{,un}map_atomic() that is also not required on ppc64.

	Arnd <><
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
