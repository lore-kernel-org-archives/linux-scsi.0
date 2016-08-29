From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 11/17] smartpqi: minor tweaks to update time support
Date: Mon, 29 Aug 2016 20:29:20 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916398BE9@avsrvexchmbx1.microsemi.net>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222991200.31214.16478440159265351246.stgit@brunhilda>
 <20160829093338.3juwfp6xcjzib26h@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0040.outbound.protection.outlook.com ([104.47.32.40]:28598
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753436AbcH2VCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 17:02:48 -0400
In-Reply-To: <20160829093338.3juwfp6xcjzib26h@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, August 29, 2016 4:34 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 11/17] smartpqi: minor tweaks to update time support
>=20
> EXTERNAL EMAIL
>=20
>=20


> >
> >  static inline void pqi_schedule_update_time_worker(
> > -                     struct pqi_ctrl_info *ctrl_info)
> > +     struct pqi_ctrl_info *ctrl_info)
> >  {
> > -     schedule_delayed_work(&ctrl_info->update_time_work, 120);
> > +     schedule_delayed_work(&ctrl_info->update_time_work, 0);
> >  }
>=20
> Why are you using schedule_delayed_work() if you have a timeout of 0?
> From __queue_delayed_work():
> 1513         /*
> 1514          * If @delay is 0, queue @dwork->work immediately.  This is =
for
> 1515          * both optimization and correctness.  The earliest @timer c=
an
> 1516          * expire is on the closest next tick and delayed_work users=
 depend
> 1517          * on that there's no such delay when @delay is 0.
> 1518          */
> 1519         if (!delay) {
> 1520                 __queue_work(cpu, wq, &dwork->work);
> 1521                 return;
> 1522         }
>=20
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

The reason is that we want it run immediately (or close to immediately).

The code could be restructured to avoid calling this function with a 0, but=
 it would result in more code and no benefit.

Kevin


