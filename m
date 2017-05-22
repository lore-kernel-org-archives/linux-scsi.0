From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 02/25] qla2xxx: Remove redundant fc_host_port_name call
Date: Mon, 22 May 2017 17:18:58 +0000
Message-ID: <5653FF0F-C9E7-436B-BB94-DD82A7650553@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
 <20170519215344.2168-3-himanshu.madhani@cavium.com>
 <1495233450.2581.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:56316
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758616AbdEVRTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 13:19:01 -0400
In-Reply-To: <1495233450.2581.7.camel@sandisk.com>
Content-Language: en-US
Content-ID: <B8A7E3229E765043BB8B3D03663D7C67@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On May 19, 2017, at 3:37 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@cavium.com>
>>=20
>> Remove redundant fc_host_port_name calls to prevent
>> early access of scsi_host->shost_data buffer. This
>> prevent null pointer access.
>>=20
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>> ---
>> drivers/scsi/qla2xxx/qla_mbx.c | 9 ---------
>> 1 file changed, 9 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_m=
bx.c
>> index a113ab3592a7..12fea77e31c6 100644
>> --- a/drivers/scsi/qla2xxx/qla_mbx.c
>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
>> @@ -3676,15 +3676,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vh=
a,
>> 				qlt_update_host_map(vha, id);
>> 			}
>>=20
>> -			fc_host_port_name(vha->host) =3D
>> -			    wwn_to_u64(vha->port_name);
>> -
>> -			if (qla_ini_mode_enabled(vha))
>> -				ql_dbg(ql_dbg_mbx, vha, 0x1018,
>> -				    "FA-WWN portname %016llx (%x)\n",
>> -				    fc_host_port_name(vha->host),
>> -				    rptid_entry->vp_status);
>> -
>> 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
>> 			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
>> 		} else {
>=20
> Hello Himanshu,
>=20
> If the above host port name assignment is redundant, what is the host
> port name assignment it is redundant with?
>=20

> Which of the removed statements could trigger a NULL pointer access, and
> from what context? Is there perhaps a call trace available of the NULL
> pointer access?
>=20
> Thanks,
>=20
> Bart.

We see following NULL pointer access on a faster systems. So far its has be=
en only seen on
couple systems in our env.=20

[  498.637517] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000008
[  498.637572] IP: qla24xx_report_id_acquisition+0x22d/0x3a0 [qla2xxx]

GDB showed following lines were causing NULL pointer deference.=20

(gdb) l *qla24xx_report_id_acquisition+0x22d
0x2012d is in qla24xx_report_id_acquisition (drivers/scsi/qla2xxx/qla_mbx.c=
:3679).
3674                                                                       =
}
3675      =20
3676                                                                       =
qlt_update_host_map(vha, id);
3677                                                       }
3678      =20
3679                                                       fc_host_port_nam=
e(vha->host) =3D
3680                                                           wwn_to_u64(v=
ha->port_name);
3681      =20
3682                                                       if (qla_ini_mode=
_enabled(vha))
3683                                                                       =
ql_dbg(ql_dbg_mbx, vha, 0x1018,
(gdb)=20

Thanks,
- Himanshu
