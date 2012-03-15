From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Thu, 15 Mar 2012 15:54:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org>
References: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 15 Mar 2012, Williams, Dan J wrote:

> > Hmm... I was wondering why we needed a kernel global sync. =A0If th=
is is
> > just for probe work what about just doing something like the follow=
ing?
> > Keep the sync operation local to probe-work and not entangle with t=
he
> > resume-work? =A0I'll give this a shot when I get back to my test sy=
stem.
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index bd17cf8..ec69e35 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2629,6 +2629,8 @@ static void sd_probe_async(void *data, async_=
cookie_t cookie)
> > =A0 =A0 =A0 =A0put_device(&sdkp->dev);
> > =A0}
> >
> > +static LIST_HEAD(sd_probe_domain);

Take a look at fea6d607e154cf96ab22254ccb48addfd43d4cb5; it might be a
good idea to make this domain available to scsi_bus_prepare().  For
example, it could made into a SCSI-wide domain, defined in the SCSI
core and exported for use by sd.

> This works fine for me for resolving the deadlock, but I found I also
> needed the following to fix a spurious:
>=20
>    scsi 6:0:1:0: Illegal state transition deleted->running
>=20
> ...in the resume path.
>=20
> @@ -2348,10 +2349,11 @@ EXPORT_SYMBOL(scsi_device_quiesce);
>   *
>   *     Must be called with user context, may sleep.
>   */
> -void
> -scsi_device_resume(struct scsi_device *sdev)
> +void scsi_device_resume(struct scsi_device *sdev)
>  {
> -       if(scsi_device_set_state(sdev, SDEV_RUNNING))
> +       /* check if the device was deleted during suspend */
> +       if (sdev->sdev_state =3D=3D SDEV_DEL ||
> +           scsi_device_set_state(sdev, SDEV_RUNNING))
>                 return;
>         scsi_run_queue(sdev->request_queue);
>  }
>=20
> Unless someone can point out something I'm missing I'll go ahead and
> roll this into it's own patch and rebase/drop the hack out of the
> libsas resume code.

The device might be in some other state.  Perhaps it would be better to=
=20
do

	if (sdev->sdev_state !=3D SDEV_QUIESCE ||
			scsi_device_set_state(sdev, SDEV_RUNNING))

I'm not sure what guarantees this function is supposed to provide, but=20
the comment indicates that it's meant just to handle quiesced devices.

Alan Stern

