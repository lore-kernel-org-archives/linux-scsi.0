From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 12/24] aacraid: Retrieve Queue Depth from Adapter FW
Date: Mon, 30 Jan 2017 20:05:32 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6D30@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-13-RaghavaAditya.Renukunta@microsemi.com>
 <20170130103114.GI3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0054.outbound.protection.outlook.com ([104.47.36.54]:17218
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751909AbdA3UGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:06:35 -0500
In-Reply-To: <20170130103114.GI3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 2:31 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 12/24] aacraid: Retrieve Queue Depth from Adapter
> FW
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:41AM -0800, Raghava Aditya Renukunta wrote:
> > Retrieved queue depth from fw and saved it for future use.
> > Only applicable for HBA1000 drives.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
> > Changes in  V2:
> > None
> >
> > Changes in  V3:
> > None
> >
> >  drivers/scsi/aacraid/aachba.c  | 84
> ++++++++++++++++++++++++++++++++++++++++-
> >  drivers/scsi/aacraid/aacraid.h | 85
> +++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 167 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachb=
a.c
> > index e441a54..c34686f 100644
> > --- a/drivers/scsi/aacraid/aachba.c
> > +++ b/drivers/scsi/aacraid/aachba.c
> > @@ -1516,6 +1516,83 @@ static int aac_scsi_32_64(struct fib * fib, stru=
ct
> scsi_cmnd * cmd)
> >       return aac_scsi_32(fib, cmd);
> >  }
> >
> > +int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
> > +{
> > +     struct fib *fibptr;
> > +     int rcode =3D -1;
> > +     u16 fibsize, datasize;
> > +     struct aac_srb *srbcmd;
> > +     struct sgmap64 *sg64;
> > +     struct aac_ciss_identify_pd *identify_resp;
> > +     dma_addr_t addr;
> > +     u32 vbus, vid;
> > +     u16 temp;
> > +
> > +     fibptr =3D aac_fib_alloc(dev);
> > +     if (!fibptr)
> > +             return -ENOMEM;
> > +
> > +     temp =3D AAC_MAX_LUN + target;
> > +
> > +     fibsize =3D sizeof(struct aac_srb) -
> > +             sizeof(struct sgentry) + sizeof(struct sgentry64);
> > +     datasize =3D sizeof(struct aac_ciss_identify_pd);
> > +
> > +     identify_resp =3D (struct aac_ciss_identify_pd *)
> > +             pci_alloc_consistent(dev->pdev, datasize, &addr);
>=20
> Please don't cast void pointers.
I apologize, yes I will remove this.
>=20
> > +
> > +     if (identify_resp !=3D NULL) {
>=20
> if (!identify_resp)
>         goto free_fib_ptr;
>=20
> > +             vbus =3D (u32)le16_to_cpu(
> > +                     dev->supplement_adapter_info.VirtDeviceBus);
> > +             vid =3D (u32)le16_to_cpu(
> > +                     dev->supplement_adapter_info.VirtDeviceTarget);
> > +
> > +             aac_fib_init(fibptr);
> > +             srbcmd =3D (struct aac_srb *) fib_data(fibptr);
> > +
> > +             srbcmd->function =3D cpu_to_le32(SRBF_ExecuteScsi);
> > +             srbcmd->channel  =3D cpu_to_le32(vbus);
> > +             srbcmd->id       =3D cpu_to_le32(vid);
> > +             srbcmd->lun      =3D 0;
> > +             srbcmd->flags    =3D cpu_to_le32(SRB_DataIn);
> > +             srbcmd->timeout  =3D cpu_to_le32(10);
> > +             srbcmd->retry_limit =3D 0;
> > +             srbcmd->cdb_size =3D cpu_to_le32(12);
> > +             srbcmd->count =3D cpu_to_le32(datasize);
> > +
> > +             memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
> > +             srbcmd->cdb[0] =3D 0x26;
> > +             srbcmd->cdb[2] =3D (u8)(temp & 0x00FF);
> > +
> > +             srbcmd->cdb[6] =3D CISS_IDENTIFY_PHYSICAL_DEVICE;
> > +
> > +             sg64 =3D (struct sgmap64 *)&srbcmd->sg;
> > +             sg64->count =3D cpu_to_le32(1);
> > +             sg64->sg[0].addr[1] =3D cpu_to_le32((u32)(((addr) >> 16) =
>> 16));
> > +             sg64->sg[0].addr[0] =3D cpu_to_le32((u32)(addr & 0xffffff=
ff));
> > +             sg64->sg[0].count =3D cpu_to_le32(datasize);
> > +
> > +             rcode =3D aac_fib_send(ScsiPortCommand64,
> > +                     fibptr, fibsize, FsaNormal, 1, 1, NULL, NULL);
> > +
> > +             if (identify_resp->current_queue_depth_limit <=3D 0 ||
> > +                     identify_resp->current_queue_depth_limit > 32)
> > +                     dev->hba_map[bus][target].qd_limit =3D 32;
> > +             else
> > +                     dev->hba_map[bus][target].qd_limit =3D
> > +                             identify_resp->current_queue_depth_limit;
> > +
> > +             pci_free_consistent(dev->pdev, datasize,
> > +                                     (void *)identify_resp, addr);
> > +
> > +             aac_fib_complete(fibptr);
> > +     }
>=20
> free_fib_ptr:
Yes let me do that.

> > +
> > +     aac_fib_free(fibptr);
> > +
> > +     return rcode;
> > +}
> > +
> >  /**
> >   *   aac_update hba_map()-   update current hba map with data from FW
> >   *   @dev:   aac_dev structure
> > @@ -1565,6 +1642,9 @@ void aac_update_hba_map(struct aac_dev *dev,
> >               if (devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> >                       goto update_devtype;
> >
> > +             if (aac_issue_bmic_identify(dev, bus, target) < 0)
> > +                     dev->hba_map[bus][target].qd_limit =3D 32;
> > +
> >  update_devtype:
> >               dev->hba_map[bus][target].devtype =3D devtype;
> >       }
> > @@ -1711,8 +1791,10 @@ int aac_get_adapter_info(struct aac_dev* dev)
> >
> >       /* reset all previous mapped devices (i.e. for init. after IOP_RE=
SET) */
> >       for (bus =3D 0; bus < AAC_MAX_BUSES; bus++) {
> > -             for (target =3D 0; target < AAC_MAX_TARGETS; target++)
> > +             for (target =3D 0; target < AAC_MAX_TARGETS; target++) {
> >                       dev->hba_map[bus][target].devtype =3D 0;
> > +                     dev->hba_map[bus][target].qd_limit =3D 0;
> > +             }
> >       }
> >
> >       /*
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacr=
aid.h
> > index 05884e6..e541394 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -74,7 +74,7 @@ enum {
> >  #define AAC_NUM_IO_FIB               (1024 - AAC_NUM_MGT_FIB)
> >  #define AAC_NUM_FIB          (AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
> >
> > -#define AAC_MAX_LUN          (8)
> > +#define AAC_MAX_LUN          (256)
> >
> >  #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
> >  #define AAC_MAX_32BIT_SGBCOUNT       ((unsigned short)256)
> > @@ -89,6 +89,7 @@ enum {
> >
> >  #define CISS_REPORT_PHYSICAL_LUNS    0xc3
> >  #define WRITE_HOST_WELLNESS          0xa5
> > +#define CISS_IDENTIFY_PHYSICAL_DEVICE        0x15
> >  #define BMIC_IN                      0x26
> >  #define BMIC_OUT                     0x27
> >
> > @@ -110,6 +111,86 @@ struct aac_ciss_phys_luns_resp {
> >   */
> >  #define AAC_MAX_HRRQ         64
> >
> > +#pragma pack(1)
> > +
> > +struct aac_ciss_identify_pd {
>=20
> [...]
>=20
> > +};
> > +
> > +#pragma pack()
>=20
> I'd prefer '}; __packed' over #pragma pack(1) .. #pragma pack()

Yes, let me make that change.=20

Regards,
Raghava Aditya

> [...]
>=20
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
