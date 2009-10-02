From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to
	be asynchronous
Date: Fri, 02 Oct 2009 15:36:25 -0700
Message-ID: <1254522985.747.3.camel@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	 <20090930020817.11455.52042.sendpatchset@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:50033 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZJBWgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 18:36:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n92MVwbm002082
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 16:31:58 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n92Ma4ee234852
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 16:36:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n92Ma3vL030825
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 16:36:04 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>


On Fri, 2009-10-02 at 16:04 -0600, Moger, Babu wrote:
> Chandra, I have one comment on this patch..=20
>=20
> >  static inline int scsi_dh_handler_exist(const char *name)
> > Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh.c
> > +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> > @@ -214,7 +214,7 @@ store_dh_state(struct device *dev, struc
> >  			 * Activate a device handler
> >  			 */
> >  			if (scsi_dh->activate)
> > -				err =3D scsi_dh->activate(sdev);
> > +				err =3D scsi_dh->activate(sdev, NULL, NULL);
>=20
>=20
> This might cause problems in handlers.  We don=E2=80=99t do NULL chec=
k in attach routine.

I assume you meant activate(), when you mention "attach" above.

At every place where the callback function is called, we first check
that the callback function is not NULL.

Can you point me if I missed some place.

Thanks

chandra

>=20
>=20
> >  			else
> >  				err =3D 0;
> >  		}


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
