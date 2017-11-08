From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/4] qla2xxx_nvmet: Add files for FC-NVMe Target support
Date: Wed, 8 Nov 2017 17:35:04 +0000
Message-ID: <08505C4B-8371-4B8D-82F3-0268912EE3EB@cavium.com>
References: <20171106195530.17408-1-himanshu.madhani@cavium.com>
 <20171106195530.17408-2-himanshu.madhani@cavium.com>
 <e24db463-4b2c-611a-ddef-e217fa23962a@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0073.outbound.protection.outlook.com ([104.47.41.73]:61216
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750818AbdKHRfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 12:35:07 -0500
In-Reply-To: <e24db463-4b2c-611a-ddef-e217fa23962a@broadcom.com>
Content-Language: en-US
Content-ID: <56E768218F423949A246AAEA7539AAE7@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,=20

> On Nov 7, 2017, at 9:05 AM, James Smart <james.smart@broadcom.com> wrote:
>=20
> On 11/6/2017 11:55 AM, Himanshu Madhani wrote:
>> From: Anil Gurumurthy <anil.gurumurthy@cavium.com>
>>=20
>> +static struct nvmet_fc_target_template qla_nvmet_fc_transport =3D {
>> +	.targetport_delete	=3D qla_nvmet_targetport_delete,
>> +	.xmt_ls_rsp		=3D qla_nvmet_ls_rsp,
>> +	.fcp_op			=3D qla_nvmet_fcp_op,
>> +	.fcp_abort		=3D qla_nvmet_fcp_abort,
>> +	.fcp_req_release	=3D qla_nvmet_fcp_req_release,
>> +	.max_hw_queues		=3D 8,
>> +	.max_sgl_segments	=3D 128,
>> +	.max_dif_sgl_segments	=3D 64,
>> +	.dma_boundary		=3D 0xFFFFFFFF,
>> +	.target_features	=3D NVMET_FCTGTFEAT_READDATA_RSP |
>> +					NVMET_FCTGTFEAT_CMD_IN_ISR |
>> +					NVMET_FCTGTFEAT_OPDONE_IN_ISR,
>> +	.target_priv_sz	=3D sizeof(struct nvme_private),
>> +};
>> +#endif
>>=20
>=20
> Do you really need the xxx_IN_ISR features ?  e.g. are you calling the nv=
met_fc cmd receive and op done calls in ISR context or something that can't=
/shouldn't continue into the nvmet layers ?
>=20
> I was looking to remove those flags and the work_q items behind it as I b=
elieved the qla2xxx driver called everything in a deferred callback.
>=20

Agree we do nvme_fc* callbacks in deferred context, but without the xxx_IN_=
ISR flag during NVMe Target template registration, we were running into cra=
sh due to recursive spin_lock held as part of CTIO response in our driver.


> -- james
>=20
>=20

Thanks,
- Himanshu
