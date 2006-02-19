From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 6092] New:
	drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before
	set
Date: Sun, 19 Feb 2006 09:26:25 -0600
Message-ID: <1140362785.3103.14.camel@mulgrave.il.steeleye.com>
References: <200602180209.k1I29meW030162@fire-2.osdl.org>
	 <20060217211049.4368ff20.akpm@osdl.org>
	 <20060218221039.GA3912@linux-buechse.de>
	 <20060218141423.7d741859.akpm@osdl.org>
	 <20060218233151.GA1985@linux-buechse.de>
	 <1140359237.3103.9.camel@mulgrave.il.steeleye.com>
	 <20060219150804.GA16578@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24476 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750711AbWBSP0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 10:26:31 -0500
In-Reply-To: <20060219150804.GA16578@linux-buechse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?Q?J=FCrgen?= E. Fischer" <fischer@linux-buechse.de>
Cc: Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2006-02-19 at 16:08 +0100, J=C3=BCrgen E. Fischer wrote:
> > The driver still seems to have an awful lot of locking confusion be=
tween
> > the host lock and its own internal lock (stored in the host structu=
re).
> > I think there are several races and other nasties that could be cle=
aned
> > up simply by moving to using the host lock everywhere.
>=20
> done.
>=20
> patch:
> - drop private lock and use host_lock instead.
>=20
> Signed-off-by: Juergen E. Fischer <fischer@linux-buechse.de>
>=20
> --- aha152x.c	2006-02-19 15:54:24.315291253 +0100
> +++ linux-2.6/drivers/scsi/aha152x.c	2006-02-19 16:00:45.817015449 +0=
100
> @@ -465,9 +465,6 @@
>  	Scsi_Cmnd *done_SC;
>  		/* command that was completed */
> =20
> -	spinlock_t lock;
> -		/* host lock */
> -

Actually, unfortunately, it doesn't look to be quite as simple as
that ... there are places (in ahd542x_queue_internal) where both locks
are currently held.  Perhaps I should just put the complete fix of the
previous patch in for 2.6.16 and then the locking changes can be worked
on post 2.6.16 (as in two separate patches)

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
