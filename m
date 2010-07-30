From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device handlers
Date: Fri, 30 Jul 2010 16:56:28 -0700
Message-ID: <1280534189.17620.284.camel@chandra-lucid.beaverton.ibm.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC420@cosmail01.lsi.com>
	 <1280440444.17620.72.camel@chandra-lucid.beaverton.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>
	 <1280448276.17620.80.camel@chandra-lucid.beaverton.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF4D0663A2C@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44841 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab0G3XzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 19:55:06 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6UNfM4L013956
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2010 19:41:22 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6UNt5Sa2150562
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2010 19:55:05 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6UNt4vm017985
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jul 2010 20:55:04 -0300
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D0663A2C@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Shyam_Iyer@Dell.com" <Shyam_Iyer@Dell.com>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>


On Fri, 2010-07-30 at 12:12 -0600, Moger, Babu wrote:

> > >
> > >   Yes, We can do that.  Problem is I am hitting the issue with BU=
G_ON
> > >  in get_rdac_data which is there in the beginning of rdac_activat=
e.
> >=20
> > I do not understand the problem.
> >=20
> > If the BUG_ON on get_rdac_data() is being triggered, that means
> > sdev->scsi_dh_data is NULL, if that is the case, how can you access
> > sdev->scsi_dh_data->kref in scsi_dh_activate (in patch 2/6) ? Would=
n't
> > it trip a oops ?
>=20
> Test case is deleting both active and passive paths almost together d=
uring
>  the multipath testing.  Looks like DM picked up the active path fail=
ure=20
> first. Then failed the active path and started scheduling activate_pa=
th to=20
> failover to passive path. Passive path is also about to go down prett=
y soon.=20
> When the control was in scsi_dh_activate, Looks like scsi_dh_data was=
 still=20
> valid because I did not see panic here.  But scsi_dh_data became NULL=
 when=20
> control went to rdac_activate. That is when I hit the bug on.=20
>=20
> kernel BUG at /usr/src/packages/BUILD/lsi-scsi_dh_rdac-01.00/obj/defa=
ult/scsi_dh_rdac.c:232!
> RIP: 0010:  rdac_activate+0x257/0x387 [scsi_dh_rdac]
>=20
> My understanding is someone triggered scsi_dh->detach for passive pat=
h during
>  this small window.  Only way I could see problem go away is holding =
reference=20
> counts between these calls.  Did i miss anything here? See the code s=
nippet below..=20

So, basically, the new patch just reduces the window of race. IOW, if i=
t
just spins for few seconds (or preempted) just before calling the
kref_get() in the new patch, it will generate an oops as scsi_dh_data
would be NULL.

Looks like you have to create a lock to protect scsi_dh_data and then
call kref_get() with the protection of lock.

>=20
> int scsi_dh_activate(struct request_queue *q, activate_complete fn, v=
oid *data)
>  {
>          int err =3D 0;
>          unsigned long flags;
>          struct scsi_device *sdev;
>          struct scsi_device_handler *scsi_dh =3D NULL;
> =20
>          spin_lock_irqsave(q->queue_lock, flags);
>          sdev =3D q->queuedata;
>          if (sdev && sdev->scsi_dh_data)
>                  scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
>          if (!scsi_dh || !get_device(&sdev->sdev_gendev))
>                  err =3D SCSI_DH_NOSYS;
>          spin_unlock_irqrestore(q->queue_lock, flags);
> =20
>          if (err)
>                  return err;
> =20
>          if (scsi_dh->activate)
>                  err =3D scsi_dh->activate(sdev, fn, data);
>          put_device(&sdev->sdev_gendev);
>          return err;
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_activate);
> =20
>=20
> static int rdac_activate(struct scsi_device *sdev,
>                          activate_complete fn, void *data)
>  {
>          struct rdac_dh_data *h =3D get_rdac_data(sdev); *******  I h=
it BUG_ON here *********
>          int err =3D SCSI_DH_OK;
> =20
>          err =3D check_ownership(sdev, h);
>          if (err !=3D SCSI_DH_OK)
>                  goto done;
> =20
>          if (h->lun_state =3D=3D RDAC_LUN_UNOWNED) {
>                  err =3D queue_mode_select(sdev, fn, data);
>                  if (err =3D=3D SCSI_DH_OK)
>                          return 0;
>          }
>  done:
>          if (fn)
>                  fn(data, err);
>          return 0;
>  }
>=20
>=20
> >=20
> >=20
> > >   If I have to go this way, then I need to remove a call
> > get_rdac_data
> > >  and just validate pointers. Report error(SCSI_DH_IO) if pointer =
is
> > not valid.
> > >   Then hold the reference counts and continue if everything is
> > alright.
> > >   I will send the new patches as soon as I can.
> >=20
>=20
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
