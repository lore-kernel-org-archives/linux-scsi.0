From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Thu, 24 Nov 2011 19:17:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
References: <CAOS58YMCv0syM7ggzaJeQp6oQxdNAJ9Y5Yn+6Q_Tb7ZjcvPzng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YMCv0syM7ggzaJeQp6oQxdNAJ9Y5Yn+6Q_Tb7ZjcvPzng@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Nov 2011, Tejun Heo wrote:

> Hello,
>=20
> On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.ed=
u> wrote:
> > Therefore, when entering the SUSPEND or HIBERNATE stages of system
> > sleep, we can skip the callback to the driver if the device is alre=
ady
> > in runtime suspend. =A0When entering the FREEZE stage, however, we =
should
> > first issue a runtime resume. =A0The overhead of doing this is
> > negligible, because a suspended drive would be spun up during the T=
HAW
> > stage of hibernation anyway.
>=20
> My brain is half fried at the moment so maybe you're saying the same
> thing, but I hope this is something simple. Like...
>=20
>     /* for libata runtime suspend is equivalent to suspend */
>     if (runtime suspended && target =3D=3D SUSPEND) {
>         yeah! skip drive pm ops;
>     } else {
>         end runtime pm;
>         ask EH to enter target PM state;
>     }

Almost.  More like this:

	/*
	 * sd is the only high-level SCSI driver to implement runtime=20
	 * PM, and sd treats runtime suspend, system suspend, and=20
	 * system hibernate identically (but not system freeze).
	 */
	if (runtime-suspended) {
		if (target =3D=3D SUSPEND || target =3D=3D HIBERNATE)
			return 0;	/* already suspended */
		/* wake up device so that FREEZE will succeed */
		pm_runtime_resume();
	}
	tell device driver to enter target PM state

libata does not contain the SCSI device driver; it contains the host
driver.

> I really don't think we need to optimize this further than this.

The above has two lines (plus comments) of optimization.  Okay?

Alan Stern

