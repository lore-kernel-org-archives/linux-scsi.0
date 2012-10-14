From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v3 4/5] pm: use callbacks from dev_pm_ops for scsi devices
Date: Sun, 14 Oct 2012 10:15:45 +0200
Message-ID: <2277287.MQtXyUZY5h@vostro.rjw.lan>
References: <1350025178-2976-1-git-send-email-aaron.lu@intel.com> <1350025178-2976-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:45711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab2JNIMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2012 04:12:07 -0400
In-Reply-To: <1350025178-2976-5-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Friday 12 of October 2012 14:59:37 Aaron Lu wrote:
> Use of pm_message_t is deprecated and device driver is not supposed
> to use that. This patch tries to migrate the SCSI bus level pm callba=
cks
> to call device's pm callbacks defined in its driver's dev_pm_ops.

Well, as Yoda had said: =E2=80=9CDo or do not... there is no try.=E2=80=
=9D ;-)

The patch looks OK, though.

> This is achieved by finding out which device pm callback should be us=
ed
> in bus callback function, and then pass that callback function pointe=
r
> as a param to the scsi_bus_{suspend,resume}_common routine, which wil=
l
> further pass that callback to scsi_dev_type_{suspend,resume} after
> proper handling.
>=20
> The special case for freeze in scsi_bus_suspend_common is not necessa=
ry
> since there is no high level SCSI driver has implemented freeze, so n=
o
> need to runtime resume the device if it is in runtime suspended state
> for system freeze, just return like the system suspend/hibernate case=
=2E
>=20
> Since only sd has implemented drv->suspend/drv->resume, and I'll upda=
te
> sd driver to use the new callbacks in the following patch, there is n=
o
> need to fallback to call drv->suspend/drv->resume if dev_pm_ops is NU=
LL.
>=20
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/scsi/scsi_pm.c | 85 ++++++++++++++++++++++++++++++----------=
----------
>  1 file changed, 52 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 9923b26..6e70a16 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -16,16 +16,14 @@
> =20
>  #include "scsi_priv.h"
> =20
> -static int scsi_dev_type_suspend(struct device *dev, pm_message_t ms=
g)
> +static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struc=
t device *))
>  {
> -	struct device_driver *drv;
>  	int err;
> =20
>  	err =3D scsi_device_quiesce(to_scsi_device(dev));
>  	if (err =3D=3D 0) {
> -		drv =3D dev->driver;
> -		if (drv && drv->suspend) {
> -			err =3D drv->suspend(dev, msg);
> +		if (cb) {
> +			err =3D cb(dev);
>  			if (err)
>  				scsi_device_resume(to_scsi_device(dev));
>  		}
> @@ -34,14 +32,12 @@ static int scsi_dev_type_suspend(struct device *d=
ev, pm_message_t msg)
>  	return err;
>  }
> =20
> -static int scsi_dev_type_resume(struct device *dev)
> +static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct=
 device *))
>  {
> -	struct device_driver *drv;
>  	int err =3D 0;
> =20
> -	drv =3D dev->driver;
> -	if (drv && drv->resume)
> -		err =3D drv->resume(dev);
> +	if (cb)
> +		err =3D cb(dev);
>  	scsi_device_resume(to_scsi_device(dev));
>  	dev_dbg(dev, "scsi resume: %d\n", err);
>  	return err;
> @@ -49,35 +45,33 @@ static int scsi_dev_type_resume(struct device *de=
v)
> =20
>  #ifdef CONFIG_PM_SLEEP
> =20
> -static int scsi_bus_suspend_common(struct device *dev, pm_message_t =
msg)
> +static int
> +scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device =
*))
>  {
>  	int err =3D 0;
> =20
>  	if (scsi_is_sdev_device(dev)) {
>  		/*
> -		 * sd is the only high-level SCSI driver to implement runtime
> -		 * PM, and sd treats runtime suspend, system suspend, and
> -		 * system hibernate identically (but not system freeze).
> +		 * All the high-level SCSI drivers that implement runtime
> +		 * PM treat runtime suspend, system suspend, and system
> +		 * hibernate identically.
>  		 */
> -		if (pm_runtime_suspended(dev)) {
> -			if (msg.event =3D=3D PM_EVENT_SUSPEND ||
> -			    msg.event =3D=3D PM_EVENT_HIBERNATE)
> -				return 0;	/* already suspended */
> +		if (pm_runtime_suspended(dev))
> +			return 0;
> =20
> -			/* wake up device so that FREEZE will succeed */
> -			pm_runtime_resume(dev);
> -		}
> -		err =3D scsi_dev_type_suspend(dev, msg);
> +		err =3D scsi_dev_type_suspend(dev, cb);
>  	}
> +
>  	return err;
>  }
> =20
> -static int scsi_bus_resume_common(struct device *dev)
> +static int
> +scsi_bus_resume_common(struct device *dev, int (*cb)(struct device *=
))
>  {
>  	int err =3D 0;
> =20
>  	if (scsi_is_sdev_device(dev))
> -		err =3D scsi_dev_type_resume(dev);
> +		err =3D scsi_dev_type_resume(dev, cb);
> =20
>  	if (err =3D=3D 0) {
>  		pm_runtime_disable(dev);
> @@ -102,26 +96,49 @@ static int scsi_bus_prepare(struct device *dev)
> =20
>  static int scsi_bus_suspend(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
> +}
> +
> +static int scsi_bus_resume(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
>  }
> =20
>  static int scsi_bus_freeze(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_suspend_common(dev, pm ? pm->freeze : NULL);
> +}
> +
> +static int scsi_bus_thaw(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_resume_common(dev, pm ? pm->thaw : NULL);
>  }
> =20
>  static int scsi_bus_poweroff(struct device *dev)
>  {
> -	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_suspend_common(dev, pm ? pm->poweroff : NULL);
> +}
> +
> +static int scsi_bus_restore(struct device *dev)
> +{
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> +	return scsi_bus_resume_common(dev, pm ? pm->restore : NULL);
>  }
> =20
>  #else /* CONFIG_PM_SLEEP */
> =20
> -#define scsi_bus_resume_common		NULL
>  #define scsi_bus_prepare		NULL
>  #define scsi_bus_suspend		NULL
> +#define scsi_bus_resume			NULL
>  #define scsi_bus_freeze			NULL
> +#define scsi_bus_thaw			NULL
>  #define scsi_bus_poweroff		NULL
> +#define scsi_bus_restore		NULL
> =20
>  #endif /* CONFIG_PM_SLEEP */
> =20
> @@ -130,10 +147,11 @@ static int scsi_bus_poweroff(struct device *dev=
)
>  static int scsi_runtime_suspend(struct device *dev)
>  {
>  	int err =3D 0;
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> =20
>  	dev_dbg(dev, "scsi_runtime_suspend\n");
>  	if (scsi_is_sdev_device(dev)) {
> -		err =3D scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
> +		err =3D scsi_dev_type_suspend(dev, pm ? pm->runtime_suspend : NULL=
);
>  		if (err =3D=3D -EAGAIN)
>  			pm_schedule_suspend(dev, jiffies_to_msecs(
>  				round_jiffies_up_relative(HZ/10)));
> @@ -147,10 +165,11 @@ static int scsi_runtime_suspend(struct device *=
dev)
>  static int scsi_runtime_resume(struct device *dev)
>  {
>  	int err =3D 0;
> +	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NUL=
L;
> =20
>  	dev_dbg(dev, "scsi_runtime_resume\n");
>  	if (scsi_is_sdev_device(dev))
> -		err =3D scsi_dev_type_resume(dev);
> +		err =3D scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
> =20
>  	/* Insert hooks here for targets, hosts, and transport classes */
> =20
> @@ -229,11 +248,11 @@ void scsi_autopm_put_host(struct Scsi_Host *sho=
st)
>  const struct dev_pm_ops scsi_bus_pm_ops =3D {
>  	.prepare =3D		scsi_bus_prepare,
>  	.suspend =3D		scsi_bus_suspend,
> -	.resume =3D		scsi_bus_resume_common,
> +	.resume =3D		scsi_bus_resume,
>  	.freeze =3D		scsi_bus_freeze,
> -	.thaw =3D			scsi_bus_resume_common,
> +	.thaw =3D			scsi_bus_thaw,
>  	.poweroff =3D		scsi_bus_poweroff,
> -	.restore =3D		scsi_bus_resume_common,
> +	.restore =3D		scsi_bus_restore,
>  	.runtime_suspend =3D	scsi_runtime_suspend,
>  	.runtime_resume =3D	scsi_runtime_resume,
>  	.runtime_idle =3D		scsi_runtime_idle,
>=20
--=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
