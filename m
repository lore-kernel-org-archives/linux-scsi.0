From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c:
 aha152x_resume(): variable used before set
Date: Sat, 18 Feb 2006 15:46:14 -0800
Message-ID: <20060218154614.1d017fdb.akpm@osdl.org>
References: <200602180209.k1I29meW030162@fire-2.osdl.org>
	<20060217211049.4368ff20.akpm@osdl.org>
	<20060218221039.GA3912@linux-buechse.de>
	<20060218141423.7d741859.akpm@osdl.org>
	<20060218233151.GA1985@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50361 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932341AbWBRXrq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 18:47:46 -0500
In-Reply-To: <20060218233151.GA1985@linux-buechse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?B?SvxyZ2Vu?= E. Fischer" <fischer@linux-buechse.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

J=FCrgen E. Fischer <fischer@linux-buechse.de> wrote:
>
> Hi Andrew,
>=20
> On Sat, Feb 18, 2006 at 14:14:23 -0800, Andrew Morton wrote:
> > >  Fix below.
> =20
> > Thanks.
> =20
> > Could we please have a more complete description of this change?  I=
t's
> > obviosly doing more than fixing a used-uninitialised bug..
>=20
> After fixing the problem in question, I discoved that the driver stil=
l
> didn't work with the pcmcia card I picked up.  run/is_complete was
> sometimes not called at all or called multiple times on one interrupt=
=2E
>=20
> I'm not really sure why (or why that worked before).  It's now ensure=
d
> that run() is only added to the task queue once per interrupt (by
> protecting 'service' with spinlocks).
>=20
> Additionally interrupt sharing didn't seem to work as the interrupt
> handler didn't check if a interrupt condition was at all pending.
>=20

So are you saying that with this patch, the driver works OK?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
