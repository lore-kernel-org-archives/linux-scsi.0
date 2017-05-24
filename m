From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/31] Protect SCSI device state changes with a mutex
Date: Wed, 24 May 2017 15:10:37 +0000
Message-ID: <1495638636.2823.3.camel@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
         <20170524003420.5381-4-bart.vanassche@sandisk.com>
         <7d437d97-29ff-14f4-1564-5ba32f00948f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7d437d97-29ff-14f4-1564-5ba32f00948f@suse.de>
Content-Language: en-US
Content-ID: <55ADBD3C87120340A7C5CA062FF2900D@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-05-24 at 07:51 +0200, Hannes Reinecke wrote:
> On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> > Enable this mechanism for all scsi_target_*block() callers but not
> > for the scsi_internal_device_unblock() calls from the mpt3sas driver
> > because that driver can call scsi_internal_device_unblock() from
> > atomic context.
> >=20
> > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.com>
> > Cc: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/scsi_error.c         |  8 +++++++-
> >  drivers/scsi/scsi_lib.c           | 27 +++++++++++++++++++++------
> >  drivers/scsi/scsi_scan.c          | 16 +++++++++-------
> >  drivers/scsi/scsi_sysfs.c         | 24 +++++++++++++++++++-----
> >  drivers/scsi/scsi_transport_srp.c |  7 ++++---
> >  drivers/scsi/sd.c                 |  7 +++++--
> >  include/scsi/scsi_device.h        |  1 +
> >  7 files changed, 66 insertions(+), 24 deletions(-)
> >=20
>=20
> [ .. ]
> > diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_tran=
sport_srp.c
> > index 3c5d89852e9f..f617021c94f7 100644
> > --- a/drivers/scsi/scsi_transport_srp.c
> > +++ b/drivers/scsi/scsi_transport_srp.c
> > @@ -554,11 +554,12 @@ int srp_reconnect_rport(struct srp_rport *rport)
> >  		 * invoking scsi_target_unblock() won't change the state of
> >  		 * these devices into running so do that explicitly.
> >  		 */
> > -		spin_lock_irq(shost->host_lock);
> > -		__shost_for_each_device(sdev, shost)
> > +		shost_for_each_device(sdev, shost) {
> > +			mutex_lock(&sdev->state_mutex);
> >  			if (sdev->sdev_state =3D=3D SDEV_OFFLINE)
> >  				sdev->sdev_state =3D SDEV_RUNNING;
> > -		spin_unlock_irq(shost->host_lock);
> > +			mutex_unlock(&sdev->state_mutex);
> > +		}
> >  	} else if (rport->state =3D=3D SRP_RPORT_RUNNING) {
> >  		/*
> >  		 * srp_reconnect_rport() has been invoked with fast_io_fail
>=20
> Why do you drop the host lock here? I thought that the host lock is
> needed to protect shost_for_each_device()?

Hello Hannes,

The only purpose of holding the host lock was to protect the SCSI device li=
st
iteration by __shost_for_each_device(). shost_for_each_device() obtains tha=
t
lock itself. From <scsi/scsi_device.h>:

#define shost_for_each_device(sdev, shost) \
	for ((sdev) =3D __scsi_iterate_devices((shost), NULL); \
	=A0=A0=A0=A0=A0(sdev); \
	=A0=A0=A0=A0=A0(sdev) =3D __scsi_iterate_devices((shost), (sdev)))

>From drivers/scsi/scsi.c:

struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
					=A0=A0=A0struct scsi_device *prev)
{
	struct list_head *list =3D (prev ? &prev->siblings : &shost->__devices);
	struct scsi_device *next =3D NULL;
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);
	while (list->next !=3D &shost->__devices) {
		next =3D list_entry(list->next, struct scsi_device, siblings);
		/* skip devices that we can't get a reference to */
		if (!scsi_device_get(next))
			break;
		next =3D NULL;
		list =3D list->next;
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (prev)
		scsi_device_put(prev);
	return next;
}

Bart.=
