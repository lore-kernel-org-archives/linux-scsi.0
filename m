From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system
 suspend
Date: Fri, 25 Nov 2011 21:50:39 +0800
Message-ID: <1322229039.4246.8.camel@hp6530s>
References: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1111241906020.26861-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-11-25 at 08:17 +0800, Alan Stern wrote:
> On Thu, 24 Nov 2011, Tejun Heo wrote:
>=20
> > Hello,
> >=20
> > On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.=
edu> wrote:
> > > Therefore, when entering the SUSPEND or HIBERNATE stages of syste=
m
> > > sleep, we can skip the callback to the driver if the device is al=
ready
> > > in runtime suspend. =EF=BF=BDWhen entering the FREEZE stage, howe=
ver, we should
> > > first issue a runtime resume. =EF=BF=BDThe overhead of doing this=
 is
> > > negligible, because a suspended drive would be spun up during the=
 THAW
> > > stage of hibernation anyway.
> >=20
> > My brain is half fried at the moment so maybe you're saying the sam=
e
> > thing, but I hope this is something simple. Like...
> >=20
> >     /* for libata runtime suspend is equivalent to suspend */
> >     if (runtime suspended && target =3D=3D SUSPEND) {
> >         yeah! skip drive pm ops;
> >     } else {
> >         end runtime pm;
> >         ask EH to enter target PM state;
> >     }
>=20
> Almost.  More like this:
>=20
> 	/*
> 	 * sd is the only high-level SCSI driver to implement runtime=20
> 	 * PM, and sd treats runtime suspend, system suspend, and=20
> 	 * system hibernate identically (but not system freeze).
> 	 */
> 	if (runtime-suspended) {
> 		if (target =3D=3D SUSPEND || target =3D=3D HIBERNATE)
> 			return 0;	/* already suspended */
> 		/* wake up device so that FREEZE will succeed */
> 		pm_runtime_resume();
> 	}
> 	tell device driver to enter target PM state

Below is the updated patch with your suggested patch description and
comments.

Looks OK?

Subject: [PATCH] [SCSI] check runtime PM status in system PM

The only high-level SCSI driver that currently implements runtime PM is
sd, and sd treats runtime suspend exactly the same as the SUSPEND and
HIBERNATE stages of system sleep, but not the same as the FREEZE stage.

Therefore, when entering the SUSPEND or HIBERNATE stages of system
sleep, we can skip the callback to the driver if the device is already
in runtime suspend.  When entering the FREEZE stage, however, we should
first issue a runtime resume.  The overhead of doing this is
negligible, because a suspended drive would be spun up during the THAW
stage of hibernation anyway.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_pm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d329f8b..a633076 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -49,8 +49,22 @@ static int scsi_bus_suspend_common(struct device *de=
v, pm_message_t msg)
 {
 	int err =3D 0;
=20
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically (but not system freeze).
+		 */
+		if (pm_runtime_suspended(dev)) {
+			if (msg.event =3D=3D PM_EVENT_SUSPEND ||
+			    msg.event =3D=3D PM_EVENT_HIBERNATE)
+				return 0;	/* already suspended */
+
+			/* wake up device so that FREEZE will succeed */
+			pm_runtime_resume(dev);
+		}
 		err =3D scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }

---=20
Thanks,
Lin Ming

>=20
> libata does not contain the SCSI device driver; it contains the host
> driver.
>=20
> > I really don't think we need to optimize this further than this.
>=20
> The above has two lines (plus comments) of optimization.  Okay?
>=20
> Alan Stern
>=20


