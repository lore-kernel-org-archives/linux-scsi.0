From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 15/24] aacraid: Include HBA direct interface
Date: Mon, 30 Jan 2017 20:00:31 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6D07@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-16-RaghavaAditya.Renukunta@microsemi.com>
 <20170130110209.GK3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:32160
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753074AbdA3UQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:16:40 -0500
In-Reply-To: <20170130110209.GK3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
> Sent: Monday, January 30, 2017 3:02 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 15/24] aacraid: Include HBA direct interface
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:44AM -0800, Raghava Aditya Renukunta wrote:
> > Added support to send direct pasthru srb commands from management
> utilty
> > to the  controller.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> Bonus points if you tidy up the following:

Let me try for those points then :).=20

>=20
> >       byte_count =3D 0;
> > -     if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
> > +     if (is_native_device) {
> > +             struct user_sgmap *usg32 =3D &user_srbcmd->sg;
> > +             struct user_sgmap64 *usg64 =3D
> > +                     (struct user_sgmap64 *)&user_srbcmd->sg;
> > +
> > +             for (i =3D 0; i < usg32->count; i++) {
> > +                     void *p;
> > +                     u64 addr;
> > +
> > +                     sg_count[i] =3D (actual_fibsize64 =3D=3D fibsize)=
 ?
> > +                             usg64->sg[i].count : usg32->sg[i].count;
> > +                     if (sg_count[i] >
> > +                             (dev->scsi_host_ptr->max_sectors << 9)) {
> > +                             pr_err("aacraid: upsg->sg[%d].count=3D%u>=
%u\n",
> > +                                     i, sg_count[i],
> > +                                     dev->scsi_host_ptr->max_sectors <=
< 9);
> > +                             rcode =3D -EINVAL;
> > +                             goto cleanup;
> > +                     }
> > +
> > +                     p =3D kmalloc(sg_count[i], GFP_KERNEL|__GFP_DMA);
> > +                     if (!p) {
> > +                             rcode =3D -ENOMEM;
> > +                             goto cleanup;
> > +                     }
> > +
> > +                     if (actual_fibsize64 =3D=3D fibsize) {
> > +                             addr =3D (u64)usg64->sg[i].addr[0];
> > +                             addr +=3D ((u64)usg64->sg[i].addr[1]) << =
32;
> > +                     } else {
> > +                             addr =3D (u64)usg32->sg[i].addr;
> > +                     }
> > +
> > +                     sg_user[i] =3D (void __user *)(uintptr_t)addr;
> > +                     sg_list[i] =3D p; // save so we can clean up late=
r
> > +                     sg_indx =3D i;
> > +
> > +                     if (flags & SRB_DataOut) {
> > +                             if (copy_from_user(p, sg_user[i],
> > +                                     sg_count[i])) {
> > +                                     rcode =3D -EFAULT;
> > +                                     goto cleanup;
> > +                             }
> > +                     }
> > +                     addr =3D pci_map_single(dev->pdev, p, sg_count[i]=
,
> > +                                             data_dir);
> > +                     hbacmd->sge[i].addr_hi =3D cpu_to_le32((u32)(addr=
>>32));
> > +                     hbacmd->sge[i].addr_lo =3D cpu_to_le32(
> > +                                             (u32)(addr & 0xffffffff))=
;
> > +                     hbacmd->sge[i].len =3D cpu_to_le32(sg_count[i]);
> > +                     hbacmd->sge[i].flags =3D 0;
> > +                     byte_count +=3D sg_count[i];
> > +             }
> > +
> > +             if (usg32->count > 0)   /* embedded sglist */
> > +                     hbacmd->sge[usg32->count-1].flags =3D
> > +                             cpu_to_le32(0x40000000);
> > +             hbacmd->data_length =3D cpu_to_le32(byte_count);
> > +
> > +             status =3D aac_hba_send(HBA_IU_TYPE_SCSI_CMD_REQ, srbfib,
> > +                                     NULL, NULL);
> > +
> > +     } else if (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64) {
> >               struct user_sgmap64* upsg =3D (struct
> user_sgmap64*)&user_srbcmd->sg;
> >               struct sgmap64* psg =3D (struct sgmap64*)&srbcmd->sg;
> >
> > @@ -606,7 +719,9 @@ static int aac_send_raw_srb(struct aac_dev* dev,
> void __user * arg)
>=20
> [...]
>=20
> Anyways,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
