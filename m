From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/7] scsi_dh: Implement common device table handling
Date: Fri, 23 May 2008 13:14:56 +0200
Message-ID: <20080523111456.GD380@pentland.suse.de>
References: <20080520140524.EDE3010B5DF@craiglockhart-ipmi.suse.de> <1211508493.21974.502.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYEWLO7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 07:14:59 -0400
Content-Disposition: inline
In-Reply-To: <1211508493.21974.502.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi Chandra,

On Thu, May 22, 2008 at 07:08:13PM -0700, Chandra Seetharaman wrote:
> Hi Hannes,
>=20
> One of my comments (regarding creating a cache of vendor-product-scsi=
_dh
> trio of already found device type). I will code it and send it.
>=20
> Looks good except for the minor comments as noted below.
>=20
> On Tue, 2008-05-20 at 16:05 +0200, Hannes Reinecke wrote:
>=20
> <snip>
>=20
> > +	spin_lock(&list_lock);
> > +	list_for_each_entry(tmp, &scsi_dh_list, list) {
> > +		for(i =3D 0; tmp->devlist[i].vendor; i++) {
> > +			if (!strncmp(sdev->vendor, tmp->devlist[i].vendor,
> > +				     strlen(tmp->devlist[i].vendor)) &&
> > +			    !strncmp(sdev->model, tmp->devlist[i].model,
> > +				     strlen(tmp->devlist[i].model))) {
> > +				devinfo =3D tmp;
> > +				break;
> > +			}
> > +		}
> > +		if (devinfo)
> > +			break;
> > +	}
> > +	spin_unlock(&list_lock);
>=20
> The above block of code can be made into a function (as there are mor=
e
> than one usage).
>=20
Ok, will do.

> > +
> > +	if (!devinfo)
> > +		goto out;
> > +
> > +	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
> > +		err =3D scsi_dh_handler_attach(sdev, devinfo);
> > +	} else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE) {
> > +		if (sdev->scsi_dh_data =3D=3D NULL)
> > +			goto out;
>=20
> Check above is done in scsi_dh_handler_detach. Do you think it is nee=
ded
> here ?
>=20
No, not really. Just forgot to take it out.

[ .. ]
> > +{
> > +	struct scsi_device_handler *scsi_dh =3D data;
> > +	struct scsi_device *sdev;
> > +
> > +	if (!scsi_is_sdev_device(dev))
> > +		return 0;
> > +
> > +	sdev =3D to_scsi_device(dev);
> > +
> > +	if (!sdev->scsi_dh_data || sdev->scsi_dh_data->scsi_dh !=3D scsi_=
dh)
> > +		return 0;
> > +
> > +	scsi_dh_handler_detach(sdev);
> >=20
> > -	scsi_dh->nb.notifier_call(&scsi_dh->nb, BUS_NOTIFY_ADD_DEVICE, de=
v);
> >  	return 0;
> >  }
> notifier_add above does get_device() and put_device(). We don't need =
it
> in notifier_remove ?
Oops. Yes, we do.

[ .. ]
> > -				     strlen(clariion_dev_list[i].model))) {
> > -				found =3D 1;
> > -				break;
> > -			}
> > -		}
> > -		if (!found)
> > -			goto out;
> > -
> > -		scsi_dh_data =3D kzalloc(sizeof(struct scsi_device_handler *)
> > -				+ sizeof(*h) , GFP_KERNEL);
> > -		if (!scsi_dh_data) {
> > -			sdev_printk(KERN_ERR, sdev, "Attach failed %s.\n",
> > -				    CLARIION_NAME);
> > -			goto out;
> > -		}
> > +	if (sdev->scsi_dh_data)
> > +		return -EBUSY;
>=20
> This check has already been done at scsi_dh level. Do we still need i=
t
> here ?
>=20
No, we don't.

> >=20
> > -		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
> > -			    CLARIION_NAME);
> > +static void clariion_bus_detach(struct scsi_device *sdev)
> > +{
> > +	struct scsi_dh_data *scsi_dh_data;
> > +	unsigned long flags;
> >=20
> > -		kfree(scsi_dh_data);
> > -		module_put(THIS_MODULE);
> > -	}
> > +	if (sdev->scsi_dh_data =3D=3D NULL ||
> > +	    sdev->scsi_dh_data->scsi_dh !=3D &clariion_dh)
> > +		return;
>=20
> first check is already done in scsi_dh level.
>=20
=46ixed.

[ .. ]
> > +static void hp_sw_bus_detach( struct scsi_device *sdev )
> > +{
> > +	struct scsi_dh_data *scsi_dh_data;
> > +	unsigned long flags;
> >=20
> > -		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> > -		scsi_dh_data =3D sdev->scsi_dh_data;
> > -		sdev->scsi_dh_data =3D NULL;
> > -		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> > -		module_put(THIS_MODULE);
> > +	if (sdev->scsi_dh_data =3D=3D NULL ||
> > +	    sdev->scsi_dh_data->scsi_dh !=3D &hp_sw_dh)
> > +		return;
> first check is already done in scsi_dh level.
>=20
=46ixed.

Seeing that this will become quite a lengthy process I've put up my scs=
i_dh
patchset at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-ml.git
branch: scsi_dh

We should be using this as a starting point and continue this discussio=
n
(and the patches) offline.

Once we've agreed on a status we should be sending the patchset to the
mailinglist. Otherwise we'll be clogging up bandwidth unnecessarily.

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
