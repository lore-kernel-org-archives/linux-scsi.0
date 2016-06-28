From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Tue, 28 Jun 2016 09:53:59 +0200
Message-ID: <20160628075359.ypdmye7sl3y7knd4@c203.arch.suse.de>
References: <146611717567.26335.4769668449125772969.stgit@brunhilda>
 <146611729682.26335.17158396498682439988.stgit@brunhilda>
 <20160617095701.fv5wnorvisnbhcc6@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916380165@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbcF1HyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2016 03:54:02 -0400
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916380165@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jun 27, 2016 at 09:12:11PM +0000, Don Brace wrote:
[...]

> > > ---
> >=20
> > [...]
> >=20
> > > + */
> > > +
> > > +#if !defined(_SMARTPQI_H)
> > > +#define _SMARTPQI_H
> > > +
> > > +#pragma pack(1)
> >=20
> > I know GCC does understand #pragma pack() to be compatible with MSV=
C
> > but please
> > use the kernel's __packed convention on structs you want to have pa=
cked.
> >=20
>=20
> We prefer to leave this "as is" for these reasons:
>=20
> We do not use __packed on other Microsemi Linux drivers.
>=20
> There's not consistency in the usage of __packed. Just a quick survey=
 of the kernel source reveals at least four styles:
>=20

So your making a 5th version, c.f. https://xkcd.com/927/

Anyway, a IMHO more important question

> > > +static void pqi_complete_queued_requests(struct pqi_ctrl_info *c=
trl_info,
> > > +     struct pqi_scsi_dev_t *device_in_reset)
> > > +{
> > > +     unsigned int i;
> > > +     unsigned int path;
> > > +     struct pqi_queue_group *queue_group;
> > > +     unsigned long flags;
> > > +     struct pqi_io_request *io_request;
> > > +     struct pqi_io_request *next;
> > > +     struct scsi_cmnd *scmd;
> > > +     struct pqi_scsi_dev_t *device;
> > > +
> > > +     for (i =3D 0; i < ctrl_info->num_queue_groups; i++) {
> > > +             queue_group =3D &ctrl_info->queue_groups[i];
> > > +
> > > +             for (path =3D 0; path < 2; path++) {
> > > +                     spin_lock_irqsave(&queue_group->submit_lock=
[path],
> > > +                             flags);
> > > +
> > > +                     list_for_each_entry_safe(io_request, next,
> > > +                             &queue_group->request_list[path],
> > > +                             request_list_entry) {
> > > +                             scmd =3D io_request->scmd;
> > > +                             if (scmd) {
> > > +                                     device =3D scmd->device->ho=
stdata;
> > > +                                     if (device =3D=3D device_in=
_reset) {
> > > +                                             set_host_byte(scmd,=
 DID_RESET);
> > > +                                             pqi_scsi_done(scmd)=
;
> > > +                                             list_del(&io_reques=
t->
> > > +                                                     request_lis=
t_entry);
> > > +                                     }
> > > +                             }
> > > +                     }
> > > +
> > > +                     spin_unlock_irqrestore(&queue_group->submit=
_lock[path],
> > > +                             flags);
> > > +             }
> >=20
> > If you'd factor the inner for loop into an own small (inline) funct=
ion, it
> > could drastically improve readability here.
> >=20
> > something like
> >=20
> > static void pqi_complete_queue_group(struct pqi_queue_group *qg, st=
ruct
> >                                      pqi_device_t *device_in_reset)
> > {
> >         unsigned int path;
> >         unsigned long flags;
> >         struct qpi_scsi_dev_t *dev;
> >         struct pqi_io_request *ior, *next;
> >=20
> >         for (path =3D 0; path < 2; path++) {
> >                 spin_lock_irqsave(&qg->submit_lock[path], flags);
> >=20
> >                 list_for_each_entry_save(ior, next, &qg->request_li=
st[path],
> >                                          request_list_entry) {
> >                         scmd =3D ior->scmnd;
> >                         if (!scmd)
> >                                 continue;
> >=20
> >                         device =3D scmnd->device->hostdata;
> >                         if (dev =3D=3D device_in_reset) {
> >                                 set_host_byte(scmnd, DID_RESET);
> >                                 pqi_scsi_done(scmnd);
> >                                 list_del(&ior->request_list_entry);
> >                         }
> >                 }
> >                 spin_unlock_irqresetore(&qg->submit_lock[path], fla=
gs);
> >         }
> > }

Does this have to be under a spin_lock and then even the irqsave
variant? From my understanding scsi-mq/blk-mq is supposed to place the
queues per-cpu. So if you're now deactivating local IRQs here you're th=
rowing
all optimizations out of the window. Can't you have the request lists a=
nd
queues per-cpu so this code can run lockless?

Thanks,
	Johannes

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
