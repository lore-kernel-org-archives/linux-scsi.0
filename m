From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 01/17] smartpqi: change aio sg processing
Date: Mon, 29 Aug 2016 21:44:36 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916398CA4@avsrvexchmbx1.microsemi.net>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222985137.31214.834009335820995162.stgit@brunhilda>
 <20160829085427.jq6sakyherfhtqgh@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0049.outbound.protection.outlook.com ([104.47.36.49]:15008
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754874AbcH2Vol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 17:44:41 -0400
In-Reply-To: <20160829085427.jq6sakyherfhtqgh@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, August 29, 2016 3:54 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 01/17] smartpqi: change aio sg processing
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Aug 26, 2016 at 11:44:11AM -0500, Don Brace wrote:
> > From: Kevin Barnett <kevin.barnett@microsemi.com>
> >
> > Take advantage of controller improvements.
> >
> > Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> > Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> > Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> > Signed-off-by: Don Brace <don.brace@microsemi.com>
> > ---
> >  drivers/scsi/smartpqi/smartpqi_init.c |   68 +++++++++++++++++++------=
--
> ------
> >  1 file changed, 39 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> > index 906f1aa..418f636 100644
> > --- a/drivers/scsi/smartpqi/smartpqi_init.c
> > +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> > @@ -4263,48 +4263,58 @@ static int pqi_build_aio_sg_list(struct
> pqi_ctrl_info *ctrl_info,
> >       int i;
> >       u16 iu_length;
> >       int sg_count;
> > -     unsigned int num_sg_in_iu =3D 0;
> > +     bool chained;
> > +     unsigned int num_sg_in_iu;
> > +     unsigned int max_sg_per_iu;
> >       struct scatterlist *sg;
> >       struct pqi_sg_descriptor *sg_descriptor;
> >
> >       sg_count =3D scsi_dma_map(scmd);
> >       if (sg_count < 0)
> >               return sg_count;
> > +
> > +     iu_length =3D offsetof(struct pqi_aio_path_request, sg_descriptor=
s) -
> > +             PQI_REQUEST_HEADER_LENGTH;
> > +     num_sg_in_iu =3D 0;
> > +
> >       if (sg_count =3D=3D 0)
> >               goto out;
> >
> > -     if (sg_count <=3D ctrl_info->max_sg_per_iu) {
> > -             sg_descriptor =3D &request->sg_descriptors[0];
> > -             scsi_for_each_sg(scmd, sg, sg_count, i) {
> > -                     pqi_set_sg_descriptor(sg_descriptor, sg);
> > -                     sg_descriptor++;
> > -             }
> > -             put_unaligned_le32(CISS_SG_LAST,
> > -                     &request->sg_descriptors[sg_count - 1].flags);
> > -             num_sg_in_iu =3D sg_count;
> > -     } else {
> > -             sg_descriptor =3D &request->sg_descriptors[0];
> > -             put_unaligned_le64((u64)io_request-
> >sg_chain_buffer_dma_handle,
> > -                     &sg_descriptor->address);
> > -             put_unaligned_le32(sg_count * sizeof(*sg_descriptor),
> > -                     &sg_descriptor->length);
> > -             put_unaligned_le32(CISS_SG_CHAIN, &sg_descriptor->flags);
> > -
> > -             sg_descriptor =3D io_request->sg_chain_buffer;
> > -             scsi_for_each_sg(scmd, sg, sg_count, i) {
> > -                     pqi_set_sg_descriptor(sg_descriptor, sg);
> > -                     sg_descriptor++;
> > +     sg =3D scsi_sglist(scmd);
> > +     sg_descriptor =3D request->sg_descriptors;
> > +     max_sg_per_iu =3D ctrl_info->max_sg_per_iu - 1;
> > +     chained =3D false;
> > +     i =3D 0;
> > +
> > +     while (1) {
>=20
> Is there any compelling reason why you didn't use scsi_for_each_sg()
> here? I don't see a reason for the while (1) construct.
>=20
The PQI chaining makes using scsi_for_each_sg a little more difficult to
maintain. We would prefer to leave the code as is.

>=20
> > +             pqi_set_sg_descriptor(sg_descriptor, sg);
> > +             if (!chained)
> > +                     num_sg_in_iu++;
> > +             i++;
> > +             if (i =3D=3D sg_count)
> > +                     break;
> > +             sg_descriptor++;
> > +             if (i =3D=3D max_sg_per_iu) {
> > +                     put_unaligned_le64(
> > +                             (u64)io_request->sg_chain_buffer_dma_hand=
le,
> > +                             &sg_descriptor->address);
> > +                     put_unaligned_le32((sg_count - num_sg_in_iu)
> > +                             * sizeof(*sg_descriptor),
> > +                             &sg_descriptor->length);
> > +                     put_unaligned_le32(CISS_SG_CHAIN,
> > +                             &sg_descriptor->flags);
> > +                     chained =3D true;
> > +                     num_sg_in_iu++;
> > +                     sg_descriptor =3D io_request->sg_chain_buffer;
> >               }
> > -             put_unaligned_le32(CISS_SG_LAST,
> > -                     &io_request->sg_chain_buffer[sg_count - 1].flags)=
;
> > -             num_sg_in_iu =3D 1;
> > -             request->partial =3D 1;
> > +             sg =3D sg_next(sg);
> >       }
> >
> > -out:
> > -     iu_length =3D offsetof(struct pqi_aio_path_request, sg_descriptor=
s) -
> > -             PQI_REQUEST_HEADER_LENGTH;
> > +     put_unaligned_le32(CISS_SG_LAST, &sg_descriptor->flags);
> > +     request->partial =3D chained;
> >       iu_length +=3D num_sg_in_iu * sizeof(*sg_descriptor);
> > +
> > +out:
> >       put_unaligned_le16(iu_length, &request->header.iu_length);
> >       request->num_sg_descriptors =3D num_sg_in_iu;
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
