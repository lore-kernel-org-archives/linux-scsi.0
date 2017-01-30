From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 13/24] aacraid: Added support to set QD of attached
 drives
Date: Mon, 30 Jan 2017 20:01:22 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6D1A@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-14-RaghavaAditya.Renukunta@microsemi.com>
 <20170130103951.GJ3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:44244
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754069AbdA3UQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:16:40 -0500
In-Reply-To: <20170130103951.GJ3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 2:40 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 13/24] aacraid: Added support to set QD of attache=
d
> drives
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:42AM -0800, Raghava Aditya Renukunta wrote:
> > Added support to set qd of drives in slave_configure.This only works fo=
r
> > HBA1000 attached drives.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > @@ -428,34 +441,41 @@ static int aac_slave_configure(struct scsi_device
> *sdev)
> >                */
> >               if (sdev->request_queue->rq_timeout < (45 * HZ))
> >                       blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
> > -             for (cid =3D 0; cid < aac->maximum_num_containers; ++cid)
> > -                     if (aac->fsa_dev[cid].valid)
> > -                             ++num_lsu;
> > -             __shost_for_each_device(dev, host) {
> > -                     if (dev->tagged_supported && (dev->type =3D=3D TY=
PE_DISK) &&
> > +             if (!is_native_device) {
> > +                     for (cid =3D 0; cid < aac->maximum_num_containers=
; ++cid)
> > +                             if (aac->fsa_dev[cid].valid)
> > +                                     ++num_lsu;
> > +                     __shost_for_each_device(dev, host) {
> > +                             if (dev->tagged_supported &&
> > +                                     (dev->type =3D=3D TYPE_DISK) &&
> >                                       (!aac->raid_scsi_mode ||
> > -                                             (sdev_channel(sdev) !=3D =
2)) &&
> > +                                     (sdev_channel(sdev) !=3D 2)) &&
> >                                       !dev->no_uld_attach) {
> > -                             if ((sdev_channel(dev) !=3D CONTAINER_CHA=
NNEL)
> > -                              || !aac->fsa_dev[sdev_id(dev)].valid)
> > -                                     ++num_lsu;
> > -                     } else
> > -                             ++num_one;
> > +                                     if ((sdev_channel(dev)
> > +                                             !=3D CONTAINER_CHANNEL)
> > +                                      || !aac->fsa_dev[sdev_id(dev)].v=
alid) {
> > +                                             ++num_lsu;
> > +                                     }
> > +                             } else {
> > +                                     ++num_one;
> > +                             }
> > +                     }
> > +                     if (num_lsu =3D=3D 0)
> > +                             ++num_lsu;
> > +                     depth =3D (host->can_queue - num_one) / num_lsu;
> > +                     if (depth > 256)
> > +                             depth =3D 256;
> > +                     else if (depth < 2)
> > +                             depth =3D 2;
> > +                     scsi_change_queue_depth(sdev, depth);
> > +             } else {
> > +                     scsi_change_queue_depth(sdev,
> > +                             aac->hba_map[chn][tid].qd_limit);
>=20
> At least in diff form, the above is quite hard to read. Can you make the =
code
> flow a bit more obvious? The extra level of indentation and thus newly
> introduced linebreaks didn't make it easier.

Yes let me rewrite the code to make it a bit more palatable.=20

>=20
> >               }
> > -             if (num_lsu =3D=3D 0)
> > -                     ++num_lsu;
> > -             depth =3D (host->can_queue - num_one) / num_lsu;
> > -             if (depth > 256)
> > -                     depth =3D 256;
> > -             else if (depth < 2)
> > -                     depth =3D 2;
> > -             scsi_change_queue_depth(sdev, depth);
> > -     } else {
> > -             scsi_change_queue_depth(sdev, 1);
> > -
> > -             sdev->tagged_supported =3D 1;
> >       }
>=20
>=20
> [...]
>=20
> Thanks,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
