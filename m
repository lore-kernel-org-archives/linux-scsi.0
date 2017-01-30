From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 16/24] aacraid: Add task management functionality
Date: Mon, 30 Jan 2017 19:59:15 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6CE9@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-17-RaghavaAditya.Renukunta@microsemi.com>
 <20170130111947.GL3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0081.outbound.protection.outlook.com ([104.47.42.81]:61568
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754193AbdA3T7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 14:59:17 -0500
In-Reply-To: <20170130111947.GL3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 3:20 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 16/24] aacraid: Add task management functionality
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:45AM -0800, Raghava Aditya Renukunta wrote:
> > Added support to send out task management commands.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
>=20
> [...]
>=20
> > @@ -3365,7 +3462,151 @@ static void aac_srb_callback(void *context,
> struct fib * fibptr)
> >
> >  /**
> >   *
> > - * aac_send_scb_fib
> > + * aac_hba_callback
> > + * @context: the context set in the fib - here it is scsi cmd
> > + * @fibptr: pointer to the fib
> > + *
> > + * Handles the completion of a native HBA scsi command
> > + *
> > + */
> > +void aac_hba_callback(void *context, struct fib *fibptr)
> > +{
> > +     struct aac_dev *dev;
> > +     struct scsi_cmnd *scsicmd;
> > +
> > +     scsicmd =3D (struct scsi_cmnd *) context;
> > +
> > +     if (!aac_valid_context(scsicmd, fibptr))
> > +             return;
> > +
> > +     WARN_ON(fibptr =3D=3D NULL);
> > +     dev =3D fibptr->dev;
> > +
> > +     if (!(fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF))
> > +             scsi_dma_unmap(scsicmd);
> > +
> > +     if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
> > +             /* fast response */
> > +             scsicmd->result =3D DID_OK << 16 | COMMAND_COMPLETE << 8;
> > +     } else {
> > +             struct aac_hba_resp *err =3D
> > +                     &((struct aac_native_hba *)fibptr->hw_fib_va)->re=
sp.err;
> > +
> > +             // BUG_ON(err->iu_type !=3D HBA_IU_TYPE_RESP);
>=20
> Please zap that C++ comment and see if you can tidy up the remaining code=
 a
> bit (e.g a new function for the else block, switch statement iterating ov=
er
> err->serivce_response, etc...)

Yes Johannes,
I have some ideas to rewrite this bit of code, let me go ahead and do it th=
en.


> > +             if (err->service_response =3D=3D
> HBA_RESP_SVCRES_TASK_COMPLETE) {
> > +                     scsicmd->result =3D err->status;
> > +                     /* set residual count */
> > +                     scsi_set_resid(scsicmd,
> > +                             le32_to_cpu(err->residual_count));
> > +
> > +                     switch (err->status) {
> > +                     case SAM_STAT_GOOD:
> > +                             scsicmd->result |=3D DID_OK << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     case SAM_STAT_CHECK_CONDITION:
> > +                     {
> > +                             int len;
> > +
> > +                             len =3D min_t(u8, err->sense_response_dat=
a_len,
> > +                                     SCSI_SENSE_BUFFERSIZE);
> > +                             if (len)
> > +                                     memcpy(scsicmd->sense_buffer,
> > +                                             err->sense_response_buf, =
len);
> > +                             scsicmd->result |=3D DID_OK << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     }
> > +                     case SAM_STAT_BUSY:
> > +                             scsicmd->result |=3D DID_BUS_BUSY << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     case SAM_STAT_TASK_ABORTED:
> > +                             scsicmd->result |=3D DID_ABORT << 16 |
> > +                                     ABORT << 8;
> > +                             break;
> > +                     case SAM_STAT_RESERVATION_CONFLICT:
> > +                     case SAM_STAT_TASK_SET_FULL:
> > +                     default:
> > +                             scsicmd->result |=3D DID_ERROR << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     }
> > +             } else if (err->service_response =3D=3D HBA_RESP_SVCRES_F=
AILURE) {
> > +                     switch (err->status) {
> > +                     case HBA_RESP_STAT_HBAMODE_DISABLED:
> > +                     {
> > +                             u32 bus, cid;
> > +
> > +                             bus =3D aac_logical_to_phys(
> > +                                             scmd_channel(scsicmd));
> > +                             cid =3D scmd_id(scsicmd);
> > +                             if (dev->hba_map[bus][cid].devtype =3D=3D
> > +                                     AAC_DEVTYPE_NATIVE_RAW) {
> > +                                     dev->hba_map[bus][cid].devtype =
=3D
> > +                                             AAC_DEVTYPE_ARC_RAW;
> > +                                     dev->hba_map[bus][cid].rmw_nexus =
=3D
> > +                                             0xffffffff;
> > +                             }
> > +                             scsicmd->result =3D DID_NO_CONNECT << 16 =
|
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     }
> > +                     case HBA_RESP_STAT_IO_ERROR:
> > +                     case HBA_RESP_STAT_NO_PATH_TO_DEVICE:
> > +                             scsicmd->result =3D DID_OK << 16 |
> > +                                     COMMAND_COMPLETE << 8 | SAM_STAT_=
BUSY;
> > +                             break;
> > +                     case HBA_RESP_STAT_IO_ABORTED:
> > +                             scsicmd->result =3D DID_ABORT << 16 |
> > +                                     ABORT << 8;
> > +                             break;
> > +                     case HBA_RESP_STAT_INVALID_DEVICE:
> > +                             scsicmd->result =3D DID_NO_CONNECT << 16 =
|
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     case HBA_RESP_STAT_UNDERRUN:
> > +                             /* UNDERRUN is OK */
> > +                             scsicmd->result =3D DID_OK << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     case HBA_RESP_STAT_OVERRUN:
> > +                     default:
> > +                             scsicmd->result =3D DID_ERROR << 16 |
> > +                                     COMMAND_COMPLETE << 8;
> > +                             break;
> > +                     }
> > +             } else if (err->service_response =3D=3D
> > +                     HBA_RESP_SVCRES_TMF_REJECTED) {
> > +                     scsicmd->result =3D
> > +                             DID_ERROR << 16 | MESSAGE_REJECT << 8;
> > +             } else if (err->service_response =3D=3D
> > +                     HBA_RESP_SVCRES_TMF_LUN_INVALID) {
> > +                     scsicmd->result =3D
> > +                             DID_NO_CONNECT << 16 | COMMAND_COMPLETE <=
< 8;
> > +             } else if ((err->service_response =3D=3D
> > +                     HBA_RESP_SVCRES_TMF_COMPLETE) ||
> > +                     (err->service_response =3D=3D
> > +                     HBA_RESP_SVCRES_TMF_SUCCEEDED)) {
> > +                     scsicmd->result =3D
> > +                             DID_OK << 16 | COMMAND_COMPLETE << 8;
> > +             } else {
> > +                     scsicmd->result =3D
> > +                             DID_ERROR << 16 | COMMAND_COMPLETE << 8;
> > +             }
> > +     }
> > +
> > +     aac_fib_complete(fibptr);
> > +
> > +     if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF)
> > +             scsicmd->SCp.sent_command =3D 1;
> > +     else
> > +             scsicmd->scsi_done(scsicmd);
> > +}
>=20
> [...]
>=20
> > @@ -3408,6 +3649,54 @@ static int aac_send_srb_fib(struct scsi_cmnd*
> scsicmd)
> >       return -1;
> >  }
> >
> > +/**
> > + *
> > + * aac_send_hba_fib
> > + * @scsicmd: the scsi command block
> > + *
> > + * This routine will form a FIB and fill in the aac_hba_cmd_req from t=
he
> > + * scsicmd passed in.
> > + */
> > +static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
> > +{
> > +     struct fib *cmd_fibcontext;
> > +     struct aac_dev *dev;
> > +     int status;
> > +
> > +     dev =3D (struct aac_dev *)scsicmd->device->host->hostdata;
>=20
> dev =3D shost_priv(scsicmd->device->host);

Yes,=20

> [...]
>=20
> > @@ -3660,6 +3949,73 @@ static int aac_convert_sgraw2(struct
> aac_raw_io2 *rio2, int pages, int nseg, int
> >       return 0;
> >  }
> >
> > +static long aac_build_sghba(struct scsi_cmnd *scsicmd,
> > +                     struct aac_hba_cmd_req *hbacmd,
> > +                     int sg_max,
> > +                     u64 sg_address)
> > +{
> > +     unsigned long byte_count =3D 0;
> > +     int nseg;
> > +
> > +     nseg =3D scsi_dma_map(scsicmd);
> > +     if (nseg < 0)
> > +             return nseg;
>=20
> if (nseg <=3D 0)
>         return nseg;

Yes
=20
> > +     if (nseg) {
> > +             struct scatterlist *sg;
> > +             int i;
> > +             u32 cur_size;
> > +             struct aac_hba_sgl *sge;
> > +
> > +             if (nseg > HBA_MAX_SG_EMBEDDED)
> > +                     sge =3D &hbacmd->sge[2];
> > +             else
> > +                     sge =3D &hbacmd->sge[0];
> > +
> > +             scsi_for_each_sg(scsicmd, sg, nseg, i) {
> > +                     int count =3D sg_dma_len(sg);
> > +                     u64 addr =3D sg_dma_address(sg);
> > +
> > +                     WARN_ON(i >=3D sg_max);
> > +                     sge->addr_hi =3D cpu_to_le32((u32)(addr>>32));
> > +                     sge->addr_lo =3D cpu_to_le32((u32)(addr & 0xfffff=
fff));
> > +                     cur_size =3D cpu_to_le32(count);
> > +                     sge->len =3D cur_size;
> > +                     sge->flags =3D 0;
> > +                     byte_count +=3D count;
> > +                     sge++;
> > +             }
> > +
> > +             sge--;
> > +             /* hba wants the size to be exact */
> > +             if (byte_count > scsi_bufflen(scsicmd)) {
> > +                     u32 temp =3D le32_to_cpu(sge->len) -
> > +                             (byte_count - scsi_bufflen(scsicmd));
> > +                     sge->len =3D cpu_to_le32(temp);
> > +                     byte_count =3D scsi_bufflen(scsicmd);
> > +             }
> > +
> > +             if (nseg <=3D HBA_MAX_SG_EMBEDDED) {
> > +                     hbacmd->emb_data_desc_count =3D cpu_to_le32(nseg)=
;
> > +                     sge->flags =3D cpu_to_le32(0x40000000);
> > +             } else {
> > +                     /* not embedded */
> > +                     hbacmd->sge[0].flags =3D cpu_to_le32(0x80000000);
> > +                     hbacmd->emb_data_desc_count =3D (u8)cpu_to_le32(1=
);
> > +                     hbacmd->sge[0].addr_hi =3D
> > +                             (u32)cpu_to_le32(sg_address >> 32);
> > +                     hbacmd->sge[0].addr_lo =3D
> > +                             cpu_to_le32((u32)(sg_address & 0xffffffff=
));
> > +             }
> > +
> > +             /* Check for command underflow */
> > +             if (scsicmd->underflow && (byte_count < scsicmd->underflo=
w)) {
> > +                     pr_warn("aacraid: cmd len %08lX cmd underflow %08=
X\n",
> > +                                     byte_count, scsicmd->underflow);
> > +             }
> > +     }
> > +     return byte_count;
> > +}
> > +
> >  #ifdef AAC_DETAILED_STATUS_INFO

Regards,
Raghava Aditya

> >  struct aac_srb_status_info {
> > --
> > 2.7.4
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
