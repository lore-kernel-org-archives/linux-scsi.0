From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Fri, 13 Jul 2007 15:45:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
	<20070704132346.591348000@pademelon.sonytel.be>
	<1184331741.3402.13.camel@localhost.localdomain>
	<20070713130508.GQ5328@kernel.dk>
	<Pine.LNX.4.62.0707131518120.18802@pademelon.sonytel.be>
	<1184333670.3402.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-427551646-1184334107=:18802"
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <1184333670.3402.17.camel@localhost.localdomain>
Content-ID: <Pine.LNX.4.62.0707131543130.18802@pademelon.sonytel.be>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-427551646-1184334107=:18802
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-ID: <Pine.LNX.4.62.0707131543131.18802@pademelon.sonytel.be>
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2007, James Bottomley wrote:
> On Fri, 2007-07-13 at 15:25 +0200, Geert Uytterhoeven wrote:
> > kmap() just returns page_address() on ppc64, as there's no highmem.
> > kunmap() is a no-op.
>=20
> > So technically I could just use page_address() directly, but Christop=
h
> > wanted
> > me to keep the kmap()/kunmap() sequence because it's considered a goo=
d
> > practice.
>=20
> The point isn't what kmap and kunmap do ... it's the addresses they
> return.  By and large, a kernel virtual address for a page is different
> from the user virtual address.  If the cache is virtually indexed you
> get different cache lines for the same page ... and that sets you up
> with aliases you need to resolve.  parisc is the same ... our
> kmap/kunmap are nops as well, but our kernel virtual addresses are stil=
l
> different from the user virtual ones.

IC.

  - flush_kernel_dcache_page() is a no-op on ppc64
    (ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE is defined on parisc only).

  - For reference, drivers/scsi/ipr.c (another ppc64 driver) just uses a =
plain
    kmap/memcpy/kunmap sequence

So what should I do?

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---584337861-427551646-1184334107=:18802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
---584337861-427551646-1184334107=:18802--
