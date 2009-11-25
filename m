From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
Date: Wed, 25 Nov 2009 10:26:56 +0100
Message-ID: <20091125092656.GA14459@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259098696.4549.643.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758400AbZKYJ1C@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1259098696.4549.643.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2009 at 03:38:16PM -0600, James Bottomley wrote:
> On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-K=F6nig wrote:
> > The function atp870u_remove is used only wrapped by __devexit_p so =
define
> > it using __devexit.
>=20
> But there's really no point to this.  HOTPLUG is always defined on SC=
SI
> systems that have these drivers, which means that _devinit/exit are
> nops.  That makes the change purely cosmetic and not worth churning t=
wo
> dozen drivers for.
>=20
> Even for the EMBEDDED cases that should care about this, the maintain=
ers
> have indicated that the memory savings simply aren't worth the hassle=
 of
> tracking the sectional updates.
I think there are people that care.  Anyhow, then the best thing you ca=
n
do is something like

	find drivers/scsi -type f -print0 | xargs perl -p -i -e 's/\b__(dev)?e=
xit(_p)?\b//'

Then my scripts will drop the scsi related patches.

Best regards
Uwe

--=20
Pengutronix e.K.                              | Uwe Kleine-K=F6nig     =
       |
Industrial Linux Solutions                    | http://www.pengutronix.=
de/  |
