From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 15/16] qla2xxx: Add internal loopback support for 81XX
Date: Mon, 17 May 2010 14:50:59 -0700
Message-ID: <C8170853.72C2%giridhar.malavali@qlogic.com>
References: <1274049038.14187.130.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:44166 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0EQVvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2010 17:51:01 -0400
In-Reply-To: <1274049038.14187.130.camel@mulgrave.site>
Content-Language: en
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, Sarang Radke <sarang.radke@qlogic.com>




On 5/16/10 3:30 PM, "James Bottomley" <James.Bottomley@suse.de> wrote:

> I'm getting this error from this patch:
>=20
>   CC [M]  drivers/scsi/qla2xxx/qla_bsg.o
> drivers/scsi/qla2xxx/qla_bsg.c: In function Oqla2x00_process_loopback=
=B9:
> drivers/scsi/qla2xxx/qla_bsg.c:584: warning: Orval=B9 may be used
> uninitialized in this function
>=20
> It looks like this hunk of code.
>=20
> On Tue, 2010-05-04 at 15:01 -0700, giridhar.malavali@qlogic.com wrote=
:
>>  static int
>>  qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
>>  {
>>       struct Scsi_Host *host =3D bsg_job->shost;
>>       scsi_qla_host_t *vha =3D shost_priv(host);
>>       struct qla_hw_data *ha =3D vha->hw;
>> -     int rval;
>> +     int rval, ret;
>>       uint8_t command_sent;
>>       char *type;
>>       struct msg_echo_lb elreq;
>>       uint16_t response[MAILBOX_REGISTER_COUNT];
>> +     uint16_t config[4], new_config[4];
>>       uint8_t *fw_sts_ptr;
>>       uint8_t *req_data =3D NULL;
>>       dma_addr_t req_data_dma;
>> @@ -568,7 +661,54 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg=
_job)
>>=20
>>       elreq.options =3D bsg_job->request->rqst_data.h_vendor.vendor_=
cmd[1];
>>=20
>> -     if (ha->current_topology !=3D ISP_CFG_F) {
>> +     if ((ha->current_topology =3D=3D ISP_CFG_F ||
>> +         (IS_QLA81XX(ha) &&
>> +         le32_to_cpu(*(uint32_t *)req_data) =3D=3D ELS_OPCODE_BYTE
>> +         && req_data_len =3D=3D MAX_ELS_FRAME_PAYLOAD)) &&
>> +             elreq.options =3D=3D EXTERNAL_LOOPBACK) {
>> +             type =3D "FC_BSG_HST_VENDOR_ECHO_DIAG";
>> +             DEBUG2(qla_printk(KERN_INFO, ha,
>> +                     "scsi(%ld) bsg rqst type: %s\n", vha->host_no,=
 type));
>> +             command_sent =3D INT_DEF_LB_ECHO_CMD;
>> +             rval =3D qla2x00_echo_test(vha, &elreq, response);
>> +
>> +     } else {
>> +             if (IS_QLA81XX(ha)) {
>> +                     memset(config, 0, sizeof(config));
>> +                     memset(new_config, 0, sizeof(new_config));
>> +                     ret =3D qla81xx_get_port_config(vha, config);
>> +                     if (ret !=3D QLA_SUCCESS) {
>> +                             DEBUG2(printk(KERN_ERR
>> +                                 "%s(%lu): Get port config failed\n=
",
>> +                                 __func__, vha->host_no));
>> +                             bsg_job->reply->reply_payload_rcv_len =
=3D 0;
>> +                             bsg_job->reply->result =3D (DID_ERROR =
<< 16);
>> +                             goto done_free_dma_req;
>=20
> Specifically, here and a few others below.  If ret indicates the comm=
and
> failed, shouldn't we be setting rval to pass the error upwards ... it=
's
> currently uninitialised, I think?
>=20
> James

Yes. I will correct this patch and send it again.

>=20
>> +                     }
>> +             }
>> +
>> +             if (elreq.options !=3D EXTERNAL_LOOPBACK && IS_QLA81XX=
(ha)) {
>> +                     DEBUG2(qla_printk(KERN_INFO, ha,
>> +                         "Internal: current port config =3D %x\n",
>> config[0]));
>> +                     ret =3D qla81xx_set_internal_loopback(vha, con=
fig,
>> +                         new_config);
>> +                     if (ret) {
>> +                             bsg_job->reply->reply_payload_rcv_len =
=3D 0;
>> +                             bsg_job->reply->result =3D (DID_ERROR =
<< 16);
>> +                             goto done_free_dma_req;
>> +                     }
>> +             } else {
>> +                     /* For external loopback to work
>> +                      * ensure internal loopback is disabled
>> +                      */
>> +                     ret =3D qla81xx_reset_internal_loopback(vha, c=
onfig, 1);
>> +                     if (ret) {
>> +                             bsg_job->reply->reply_payload_rcv_len =
=3D 0;
>> +                             bsg_job->reply->result =3D (DID_ERROR =
<< 16);
>> +                             goto done_free_dma_req;
>> +                     }
>> +             }
>> +
>>               type =3D "FC_BSG_HST_VENDOR_LOOPBACK";
>>               DEBUG2(qla_printk(KERN_INFO, ha,
>>                       "scsi(%ld) bsg rqst type: %s\n",
>> @@ -577,20 +717,34 @@ qla2x00_process_loopback(struct fc_bsg_job *bs=
g_job)
>>               command_sent =3D INT_DEF_LB_LOOPBACK_CMD;
>>               rval =3D qla2x00_loopback_test(vha, &elreq, response);
>>               if (IS_QLA81XX(ha)) {
>> +                     if (new_config[1]) {
>> +                             /* Revert back to original port config
>> +                              * Also clear internal loopback
>> +                              */
>> +                             qla81xx_reset_internal_loopback(vha,
>> +                                 new_config, 0);
>> +                     }
>> +
>>                       if (response[0] =3D=3D MBS_COMMAND_ERROR &&
>> -                             response[1] =3D=3D MBS_LB_RESET) {
>> +                                     response[1] =3D=3D MBS_LB_RESE=
T) {
>>                               DEBUG2(printk(KERN_ERR "%s(%ld): ABORT=
ing "
>> -                             "ISP\n", __func__, vha->host_no));
>> +                                     "ISP\n", __func__, vha->host_n=
o));
>>                               set_bit(ISP_ABORT_NEEDED, &vha->dpc_fl=
ags);
>>                               qla2xxx_wake_dpc(vha);
>> +                             qla2x00_wait_for_chip_reset(vha);
>> +                             /* Also reset the MPI */
>> +                             if (qla81xx_restart_mpi_firmware(vha) =
!=3D
>> +                                 QLA_SUCCESS) {
>> +                                     qla_printk(KERN_INFO, ha,
>> +                                         "MPI reset failed for host=
%ld.\n",
>> +                                         vha->host_no);
>> +                             }
>> +
>> +                             bsg_job->reply->reply_payload_rcv_len =
=3D 0;
>> +                             bsg_job->reply->result =3D (DID_ERROR =
<< 16);
>> +                             goto done_free_dma_req;
>>                       }
>>               }
>> -     } else {
>> -             type =3D "FC_BSG_HST_VENDOR_ECHO_DIAG";
>> -             DEBUG2(qla_printk(KERN_INFO, ha,
>> -                 "scsi(%ld) bsg rqst type: %s\n", vha->host_no, typ=
e));
>> -             command_sent =3D INT_DEF_LB_ECHO_CMD;
>> -             rval =3D qla2x00_echo_test(vha, &elreq, response);
>>       }
>>=20
>>       if (rval) {
>> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/q=
la_bsg.h
>> index 76ed92d..1f096da 100644
>> --- a/drivers/scsi/qla2xxx/qla_bsg.h
>> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
>> @@ -19,6 +19,13 @@
>>  #define INT_DEF_LB_LOOPBACK_CMD         0
>>  #define INT_DEF_LB_ECHO_CMD             1
>>=20
>> +/* Loopback related definations */
>> +#define EXTERNAL_LOOPBACK            0xF2
>> +#define ENABLE_INTERNAL_LOOPBACK     0x02
>> +#define INTERNAL_LOOPBACK_MASK               0x000E
>> +#define MAX_ELS_FRAME_PAYLOAD                252
>> +#define ELS_OPCODE_BYTE                      0x10
>> +
>>  /* BSG Vendor specific definations */
>>  #define A84_ISSUE_WRITE_TYPE_CMD        0
>>  #define A84_ISSUE_READ_TYPE_CMD         1
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/q=
la_def.h
>> index 8396109..4d8a7b9 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -713,6 +713,8 @@ typedef struct {
>>  #define MBC_SEND_RNFT_ELS            0x5e    /* Send RNFT ELS reque=
st */
>>  #define MBC_GET_LINK_PRIV_STATS              0x6d    /* Get link & =
private
>> data. */
>>  #define MBC_SET_VENDOR_ID            0x76    /* Set Vendor ID. */
>> +#define MBC_SET_PORT_CONFIG          0x122   /* Set port configurat=
ion */
>> +#define MBC_GET_PORT_CONFIG          0x123   /* Get port configurat=
ion */
>>=20
>>  /* Firmware return data sizes */
>>  #define FCAL_MAP_SIZE        128
>> @@ -2630,6 +2632,8 @@ struct qla_hw_data {
>>       struct mutex vport_lock;        /* Virtual port synchronizatio=
n */
>>       struct completion mbx_cmd_comp; /* Serialize mbx access */
>>       struct completion mbx_intr_comp;  /* Used for completion notif=
ication
>> */
>> +     struct completion dcbx_comp;    /* For set port config notific=
ation */
>> +     int notify_dcbx_comp;
>>=20
>>       /* Basic firmware related information. */
>>       uint16_t        fw_major_version;
>> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/q=
la_gbl.h
>> index 8217c3b..6ff36f1 100644
>> --- a/drivers/scsi/qla2xxx/qla_gbl.h
>> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
>> @@ -357,6 +357,11 @@ qla2x00_write_ram_word(scsi_qla_host_t *, uint3=
2_t,
>> uint32_t);
>>  extern int qla2x00_get_data_rate(scsi_qla_host_t *);
>>  extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16=
_t,
>>       uint16_t *);
>> +extern int
>> +qla81xx_get_port_config(scsi_qla_host_t *, uint16_t *);
>> +
>> +extern int
>> +qla81xx_set_port_config(scsi_qla_host_t *, uint16_t *);
>>=20
>>  /*
>>   * Global Function Prototypes in qla_isr.c source file.
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/q=
la_isr.c
>> index be3d8be..2fe0250 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -545,10 +545,13 @@ skip_rio:
>>               if (IS_QLA2100(ha))
>>                       break;
>>=20
>> -             if (IS_QLA8XXX_TYPE(ha))
>> +             if (IS_QLA8XXX_TYPE(ha)) {
>>                       DEBUG2(printk("scsi(%ld): DCBX Completed -- %0=
4x %04x "
>>                           "%04x\n", vha->host_no, mb[1], mb[2], mb[3=
]));
>> -             else
>> +                     if (ha->notify_dcbx_comp)
>> +                             complete(&ha->dcbx_comp);
>> +
>> +             } else
>>                       DEBUG2(printk("scsi(%ld): Asynchronous P2P MOD=
E "
>>                           "received.\n", vha->host_no));
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/q=
la_mbx.c
>> index f3650d0..f593afa 100644
>> --- a/drivers/scsi/qla2xxx/qla_mbx.c
>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
>> @@ -3950,6 +3950,72 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
>>  }
>>=20
>>  int
>> +qla81xx_get_port_config(scsi_qla_host_t *vha, uint16_t *mb)
>> +{
>> +     int rval;
>> +     mbx_cmd_t mc;
>> +     mbx_cmd_t *mcp =3D &mc;
>> +     struct qla_hw_data *ha =3D vha->hw;
>> +
>> +     DEBUG11(printk(KERN_INFO
>> +         "%s(%ld): entered.\n", __func__, vha->host_no));
>> +
>> +     if (!IS_QLA81XX(ha))
>> +             return QLA_FUNCTION_FAILED;
>> +     mcp->mb[0] =3D MBC_GET_PORT_CONFIG;
>> +     mcp->out_mb =3D MBX_0;
>> +     mcp->in_mb =3D MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
>> +     mcp->tov =3D MBX_TOV_SECONDS;
>> +     mcp->flags =3D 0;
>> +
>> +     rval =3D qla2x00_mailbox_command(vha, mcp);
>> +
>> +     if (rval !=3D QLA_SUCCESS) {
>> +             DEBUG2_3_11(printk(KERN_WARNING
>> +                 "%s(%ld): failed=3D%x (%x).\n", __func__,
>> +                 vha->host_no, rval, mcp->mb[0]));
>> +     } else {
>> +             /* Copy all bits to preserve original value */
>> +             memcpy(mb, &mcp->mb[1], sizeof(uint16_t) * 4);
>> +
>> +             DEBUG11(printk(KERN_INFO
>> +                 "%s(%ld): done.\n", __func__, vha->host_no));
>> +     }
>> +     return rval;
>> +}
>> +
>> +int
>> +qla81xx_set_port_config(scsi_qla_host_t *vha, uint16_t *mb)
>> +{
>> +     int rval;
>> +     mbx_cmd_t mc;
>> +     mbx_cmd_t *mcp =3D &mc;
>> +
>> +     DEBUG11(printk(KERN_INFO
>> +         "%s(%ld): entered.\n", __func__, vha->host_no));
>> +
>> +     mcp->mb[0] =3D MBC_SET_PORT_CONFIG;
>> +     /* Copy all bits to preserve original setting */
>> +     memcpy(&mcp->mb[1], mb, sizeof(uint16_t) * 4);
>> +     mcp->out_mb =3D MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
>> +     mcp->in_mb =3D MBX_0;
>> +     mcp->tov =3D MBX_TOV_SECONDS;
>> +     mcp->flags =3D 0;
>> +     rval =3D qla2x00_mailbox_command(vha, mcp);
>> +
>> +     if (rval !=3D QLA_SUCCESS) {
>> +             DEBUG2_3_11(printk(KERN_WARNING
>> +                 "%s(%ld): failed=3D%x (%x).\n", __func__,
>> +                 vha->host_no, rval, mcp->mb[0]));
>> +     } else
>> +             DEBUG11(printk(KERN_INFO
>> +                 "%s(%ld): done.\n", __func__, vha->host_no));
>> +
>> +     return rval;
>> +}
>> +
>> +
>> +int
>>  qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16=
_t
>> priority,
>>               uint16_t *mb)
>>  {
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/ql=
a_os.c
>> index be1a8fc..58e6102 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -2113,6 +2113,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const =
struct
>> pci_device_id *id)
>>       init_completion(&ha->mbx_cmd_comp);
>>       complete(&ha->mbx_cmd_comp);
>>       init_completion(&ha->mbx_intr_comp);
>> +     init_completion(&ha->dcbx_comp);
>>=20
>>       set_bit(0, (unsigned long *) ha->vp_idx_map);
>>=20
>> --
>> 1.6.2.rc1.30.gd43c
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
