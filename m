From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 13/17] smartpqi: remove timeout for cache flush
 operations
Date: Mon, 29 Aug 2016 21:36:32 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916398C86@avsrvexchmbx1.microsemi.net>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222992420.31214.16768734205314588696.stgit@brunhilda>
 <20160829093941.uuuoamnrzwjei3fs@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0043.outbound.protection.outlook.com ([104.47.38.43]:47195
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756026AbcH2Vgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 17:36:38 -0400
In-Reply-To: <20160829093941.uuuoamnrzwjei3fs@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, August 29, 2016 4:40 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 13/17] smartpqi: remove timeout for cache flush
> operations
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Aug 26, 2016 at 11:45:24AM -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@microsemi.com>
> >
> > Some cache flush operations can take longer than the
> > timeout value. Best to not impose a time limit to
> > handle all cases.
> >
> > Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  drivers/scsi/smartpqi/smartpqi_init.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> > index 87eb603..e7d7e99 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -407,7 +407,6 @@ static int pqi_identify_physical_device(struct
> pqi_ctrl_info *ctrl_info,
> >  }
> >
> >  #define SA_CACHE_FLUSH_BUFFER_LENGTH 4
> > -#define PQI_FLUSH_CACHE_TIMEOUT              (30 * 1000)
> >
> >  static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info)
> >  {
> > @@ -434,7 +433,7 @@ static int pqi_flush_cache(struct pqi_ctrl_info
> *ctrl_info)
> >               goto out;
> >
> >       rc =3D pqi_submit_raid_request_synchronous(ctrl_info, &request.he=
ader,
> > -             0, NULL, PQI_FLUSH_CACHE_TIMEOUT);
> > +             0, NULL, NO_TIMEOUT);
> >
> >       pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
> >               pci_direction);
>=20
> IIRC I asked you to introduce this timeout, as you're calling
> pqi_flush_cache() from the driver's shutdown callback and I still
> doubt users like their shutdown's to hang indefinitely because cache
> flush isn't working. Just my $0.02.
>=20

The issue is that we do not know how long to wait. The cache module has got=
ten
quite large and some flush operations can take longer to complete than othe=
rs.
That is why we took the timeout value out.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
