From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 2/7] scsi_dh: Add 'dh_state' sysfs attribute
Date: Fri, 23 May 2008 13:23:58 +0200
Message-ID: <20080523112358.GE380@pentland.suse.de>
References: <20080520140530.936DC10B5DF@craiglockhart-ipmi.suse.de> <1211508500.21974.503.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:57622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYEWLYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 07:24:01 -0400
Content-Disposition: inline
In-Reply-To: <1211508500.21974.503.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Thu, May 22, 2008 at 07:08:20PM -0700, Chandra Seetharaman wrote:
>=20
> On Tue, 2008-05-20 at 16:05 +0200, Hannes Reinecke wrote:
> > Implement a 'dh_state' sdev attribute for dynamic device handler
> > manipulation. A read on the attribute will return the name of
> > the currently attached device handler or 'detached' if no handler
> > is attached.
> > The attribute allows the following strings to be written:
> > - The name of the device handler to be attached if the state is
> >   'detached'.
> > - 'activate' to trigger path activation if a device handler
> >   is attached.
> > - 'detach' to detach the currently attached device handler.
> >=20
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/scsi/device_handler/scsi_dh.c |  107 +++++++++++++++++++++=
+++++++++++-
> >  1 files changed, 105 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/d=
evice_handler/scsi_dh.c
> > index 0b5c457..b80fae7 100644
> > --- a/drivers/scsi/device_handler/scsi_dh.c
> > +++ b/drivers/scsi/device_handler/scsi_dh.c
> > @@ -79,6 +79,98 @@ static void scsi_dh_handler_detach(struct scsi_d=
evice *sdev)
> >  }
> >=20
> >  /*
> > + * Functions for sysfs attribute 'dh_state'
> > + */
> > +static ssize_t
> > +store_dh_state(struct device *dev, struct device_attribute *attr,
> > +	       const char *buf, size_t count)
> > +{
> > +	struct scsi_device *sdev =3D to_scsi_device(dev);
> > +	struct scsi_device_handler *scsi_dh;
> > +	int err =3D -EINVAL;
> > +
> > +	if (!sdev->scsi_dh_data) {
> > +		/*
> > +		 * Attach to a device handler
> > +		 */
> > +		if (!(scsi_dh =3D get_device_handler(buf)))
> > +			return err;
> > +		err =3D scsi_dh_handler_attach(sdev, scsi_dh);
> > +	} else {
> > +		if (!strncmp(buf, "detach", 6)) {
> > +			/*
> > +			 * Detach from a device handler
> > +			 */
> > +			scsi_dh_handler_detach(sdev);
> > +			err =3D 0;
> > +		} else if (!strncmp(buf, "activate", 8)) {
> > +			/*
> > +			 * Activate a device handler
> > +			 */
> > +			scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
> > +			if (scsi_dh->activate)
> > +				err =3D scsi_dh->activate(sdev);
> > +			else
> > +				err =3D 0;
>=20
> Sorry for the late comment. Why do we want to give the user to be abl=
e
> to activate a path ? (I am assuming user as we do not want to be call=
ing
> this from multipath tools).
>=20
This is quite a handy feature if you want to test failover manually (ie
if the commands are being sent correctly and the array reacts properly)=
=2E
And, of course, there might be scenarios where you'd want to trigger
a failover manually.

[ .. ]
> > @@ -114,14 +206,19 @@ static int scsi_dh_notifier(struct notifier_b=
lock *nb,
> >  		goto out;
> >=20
> >  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
> > +		int err;
> > +
> >  		err =3D scsi_dh_handler_attach(sdev, devinfo);
> > +		if (!err)
> > +			err =3D device_create_file(dev, &scsi_dh_state_attr);
>=20
> we don't want to detach when we fail creating the file ? I am ok with
> it, but just wanted to make sure that is what you intended.
>=20
The 'dh_state' attribute is just an add-on and not necessary for proper
functionality. So I thought we could just ignore this error.
But seeing that this indicates some general error condition it's probab=
ly
better to at least return this error.

> >  	} else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE) {
> >  		if (sdev->scsi_dh_data =3D=3D NULL)
> >  			goto out;
> > +		device_remove_file(dev, &scsi_dh_state_attr);
> >  		scsi_dh_handler_detach(sdev);
> >  	}
> >  out:
> > -	return err;
> > +	return 0;
>=20
> why are we not returning err ?
See above.=20

=46ixed in the scsi_dh branch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
