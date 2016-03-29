From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
Date: Tue, 29 Mar 2016 09:20:27 +0200
Message-ID: <1708043.RtkulW4x5y@c203>
References: <1458813373-7477-1-git-send-email-jthumshirn@suse.de> <1458834164.17965.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbcC2HUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 03:20:34 -0400
In-Reply-To: <1458834164.17965.74.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

On Donnerstag, 24. M=E4rz 2016 11:42:44 CEST Ewan D. Milne wrote:
> On Thu, 2016-03-24 at 10:56 +0100, Johannes Thumshirn wrote:
> > The target state machine only knows 'STARGET_DEL', which is set onc=
e
> > scsi_target_destroy() is called.
> > However, by that time the structure is still part of the __stargets
> > list of the SCSI host, so any concurrent invocation will see this a=
s
> > a valid target, causing an access to freed memory.
> >=20
> > This patch adds an intermediate state 'STARGET_REMOVE', which is se=
t
> > as soon as the target is scheduled to be removed.
> > With this any concurrent invocation will be able to skip these
> > targets and avoid the above scenario.
> >=20
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Fixes: 90a88d6ef 'scsi: fix soft lockup in scsi_remove_target() on =
module
> > removal' Cc: stable@vger.kernel.org
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > ---
> >=20
> >  drivers/scsi/scsi_scan.c   | 1 +
> >  drivers/scsi/scsi_sysfs.c  | 2 ++
> >  include/scsi/scsi_device.h | 1 +
> >  3 files changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 6a82066..37459dfa 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -315,6 +315,7 @@ static void scsi_target_destroy(struct scsi_tar=
get
> > *starget)>=20
> >  	struct Scsi_Host *shost =3D dev_to_shost(dev->parent);
> >  	unsigned long flags;
> >=20
> > +	BUG_ON(starget->state !=3D STARGET_REMOVE);
> >=20
> >  	starget->state =3D STARGET_DEL;
> >  	transport_destroy_device(dev);
> >  	spin_lock_irqsave(shost->host_lock, flags);
> >=20
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 00bc721..0df82e8 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> >=20
> > @@ -1279,11 +1279,13 @@ restart:
> >  	spin_lock_irqsave(shost->host_lock, flags);
> >  	list_for_each_entry(starget, &shost->__targets, siblings) {
> >  =09
> >  		if (starget->state =3D=3D STARGET_DEL ||
> >=20
> > +		    starget->state =3D=3D STARGET_REMOVE ||
> >=20
> >  		    starget =3D=3D last_target)
> >  		=09
> >  			continue;
> >  	=09
> >  		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D dev) =
{
> >  	=09
> >  			kref_get(&starget->reap_ref);
> >  			last_target =3D starget;
> >=20
> > +			starget->state =3D STARGET_REMOVE;
> >=20
> >  			spin_unlock_irqrestore(shost->host_lock, flags);
> >  			__scsi_remove_target(starget);
> >  			scsi_target_reap(starget);
> >=20
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.=
h
> > index f63a167..2bffaa6 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -240,6 +240,7 @@ scmd_printk(const char *, const struct scsi_cmn=
d *,
> > const char *, ...);>=20
> >  enum scsi_target_state {
> > =20
> >  	STARGET_CREATED =3D 1,
> >  	STARGET_RUNNING,
> >=20
> > +	STARGET_REMOVE,
> >=20
> >  	STARGET_DEL,
> > =20
> >  };
>=20
> This looks fine.  Do we still need 90a88d6ef (scsi: fix soft lockup i=
n
> scsi_remove_target() on module removal) or can that be reverted now,
> since the STARGET_REMOVE state will allow the iteration to continue?
>=20
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

We've tested it on-top of 90a88d6ef, so I'm not quite sure.

Anyways, I've seen a mail from the 0-day bot regarding this patch, so I=
'll=20
have to check that one first.

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
