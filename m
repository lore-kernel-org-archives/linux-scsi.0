From: Greg KH <greg@kroah.com>
Subject: Re: linux-next: NCR_700_detect warnings
Date: Tue, 10 Mar 2009 21:07:30 -0700
Message-ID: <20090311040730.GA29678@kroah.com>
References: <Pine.LNX.4.64.0903102139150.20676@anakin> <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Kroah-Hartman <gregkh@suse.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, David Brownell <dbrownell@users.sourceforge.net>, linux-next@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2009 at 09:59:09AM +0800, Ming Lei wrote:
> 2009/3/11 Geert Uytterhoeven <geert@linux-m68k.org>:
> > commit 76afea5b078d36ec080a75c29ff5a3fbc5774fee
> > Author: Ming Lei <tom.leiming@gmail.com>
> > Date: =A0 Fri Feb 6 23:40:12 2009 +0800
> >
> > =A0 =A0platform driver: fix incorrect use of 'platform_bus_type' wi=
th 'struct devic
> >
> > =A0 =A0This patch fixes the bug reported in
> > =A0 =A0 =A0 =A0http://bugzilla.kernel.org/show_bug.cgi?id=3D11681.
> >
> > =A0 =A0"Lots of device drivers register a 'struct device_driver' wi=
th
> > =A0 =A0the '.bus' member set to '&platform_bus_type'. This is wrong=
,
> > =A0 =A0since the platform_bus functions expect the 'struct device_d=
river'
> > =A0 =A0to be wrapped up in a 'struct platform_driver' which provide=
s
> > =A0 =A0some additional callbacks (like suspend_late, resume_early).
> > =A0 =A0The effect may be that platform_suspend_late() uses bogus da=
ta
> > =A0 =A0outside the device_driver struct as a pointer pointer to the
> > =A0 =A0device driver's suspend_late() function or other hard to
> > =A0 =A0reproduce failures."(Lothar Wassmann)
> >
> > =A0 =A0Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > =A0 =A0Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > =A0 =A0Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> > =A0 =A0Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > This introduced the following warnings on m68k, as `dev' is now a
> > `struct platform_device *' instead of a `struct device *':
> >
> > | drivers/scsi/a4000t.c:64: warning: passing argument 3 of 'NCR_700=
_detect' from incompatible pointer type
> > | drivers/scsi/mvme16x_scsi.c:67: warning: passing argument 3 of 'N=
CR_700_detect' from incompatible pointer type
> > | drivers/scsi/bvme6000_scsi.c:61: warning: passing argument 3 of '=
NCR_700_detect' from incompatible pointer type
> >
> > I think the below is missing (untested on real hardware)?
>=20
> Yes, you are correct. It is really missed.

Great, Geert, care to resend with a signed-off-by: so I can apply this?

thanks,

greg k-h
