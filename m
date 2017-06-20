From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 4/6] qla2xxx: Send FC4 type NVMe to the management server
Date: Tue, 20 Jun 2017 22:13:04 +0000
Message-ID: <032AF3DB-A17D-418E-A505-724D51CB7391@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-5-himanshu.madhani@cavium.com>
 <20170619100641.GB19417@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:25019
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752401AbdFTWNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jun 2017 18:13:08 -0400
In-Reply-To: <20170619100641.GB19417@linux-x5ow.site>
Content-Language: en-US
Content-ID: <0FC51DB3D3DEC949B04C06F38E2FC194@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>

Hi Johannes,=20

> On Jun 19, 2017, at 3:06 AM, Johannes Thumshirn <jthumshirn@suse.de> wrot=
e:
>=20
> On Fri, Jun 16, 2017 at 03:47:42PM -0700, Himanshu Madhani wrote:
>> From: Duane Grigsby <duane.grigsby@cavium.com>
>>=20
>> This patch adds switch command support for FC-4 type of FC-NVMe (0x28)
>> for resgistering HBA port to the management server. RFT_ID command is
>> used to register FC-4 type of 0x28 and RFF_ID is used to register
>> FC-4 features bits for FC-NVMe port.
>>=20
>> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
>> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
>> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>> ---
>=20
> [...]
>=20
>> +       ct_rsp =3D &fcport->ct_desc.ct_sns->p.rsp;
>> +       /*
>> +	* FC-GS-7, 5.2.3.12 FC-4 Features - format
>> +	* The format of the FC-4 Features object, as defined by the FC-4,
>> +	* Shall be an array of 4-bit values, one for each type code value
>> +	*/
>=20
> Indentation looks a bit odd here. Did you run checkpatch.pl on the series=
?
>=20

forgot to reply to this earlier. Yes. I ran checkpatch.pl on this series.

Somehow in the actual code this does not look like issue. (i.e. correct ind=
entation is seen)=20
i am not sure why in patch view its showing one space off.
=20
>> @@ -4634,6 +4637,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>> 				    &vha->dpc_flags))
>> 					break;
>> 			}
>> +			if (vha->flags.nvme_enabled) {
>> +				if (qla2x00_rff_id(vha, FC4_TYPE_NVME)) {
>=20
> 			if (vha->flags.nvme_enabled &&=20
> 			    qla2x00_rff_id(vha, FC4_TYPE_NVME))=20
> 			    ql_dbg(ql_dbg_disc, vha, 0x2049, ....)
>=20
>> +					ql_dbg(ql_dbg_disc, vha, 0x2049,
>> +					    "Register NVME FC Type Features failed.\n");
>> +				}
>> +			}
>=20
> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks,
- Himanshu
