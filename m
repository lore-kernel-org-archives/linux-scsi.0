From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 3/6] qla2xxx: Add FC-NVMe F/W initialization and transport
 registration
Date: Tue, 20 Jun 2017 04:31:02 +0000
Message-ID: <878789AD-4474-429E-A6BB-D2CBF8EB60C3@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-4-himanshu.madhani@cavium.com>
 <41e7e61c-b91c-b9f9-79df-0f196970d971@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:52448
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750925AbdFTEbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jun 2017 00:31:05 -0400
In-Reply-To: <41e7e61c-b91c-b9f9-79df-0f196970d971@broadcom.com>
Content-Language: en-US
Content-ID: <90753BD648577E4A9CF18BE507DF3429@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malaval@cavium.com" <giridhar.malaval@cavium.com>, "Trapp, Darren" <Darren.Trapp@cavium.com>


> On Jun 19, 2017, at 2:22 PM, James Smart <james.smart@broadcom.com> wrote=
:
>=20
> On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
>> From: Duane Grigsby <duane.grigsby@cavium.com>
>>=20
>> This code provides the interfaces to register remote and local ports
>> of FC4 type 0x28 with the FC-NVMe transport and transports the
>> requests (FC-NVMe FC link services and FC-NVMe commands IUs) to the
>> fabric. It also provides the support for allocating h/w queues and
>> aborting FC-NVMe FC requests.
>>=20
>> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
>> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
>> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>>=20
>> +#if (IS_ENABLED(CONFIG_NVME_FC))
>> +extern int nvme_fc_register_remoteport(struct nvme_fc_local_port *,
>> +    struct nvme_fc_port_info *, struct nvme_fc_remote_port **);
>> +extern int nvme_fc_register_localport(struct nvme_fc_port_info *,
>> +    struct nvme_fc_port_template *, struct device *,
>> +    struct nvme_fc_local_port **);
>> +extern int nvme_fc_unregister_localport(struct nvme_fc_local_port *);
>> +#endif
>=20
> There should be no need for these. They are in the include/linux/nvme-fc-=
driver.h header.
>=20

Agree. Will remove it=20

>=20
>> +static void qla_nvme_sp_ls_done(void *ptr, int res)
>> +{
>> +	srb_t *sp =3D ptr;
>> +	struct srb_iocb *nvme;
>> +	struct nvmefc_ls_req   *fd;
>> +	struct nvme_private *priv;
>> +
>> +	if (atomic_read(&sp->ref_count) =3D=3D 0) {
>> +		ql_log(ql_log_warn, sp->fcport->vha, 0x2123,
>> +		    "SP reference-count to ZERO on LS_done -- sp=3D%p.\n", sp);
>> +		return;
>> +	}
>> +
>> +	if (!atomic_dec_and_test(&sp->ref_count))
>> +		return;
>> +
>> +	if (res)
>> +		res =3D NVME_SC_FC_TRANSPORT_ERROR;
>=20
> LS request failures status should be -Exxx values, not nvme status codes =
(which don't apply to LS's).
> The api probably wasn't super clear on this.
>=20

Will fix up in v2.

>> +
>> +	nvme =3D &sp->u.iocb_cmd;
>> +	fd =3D nvme->u.nvme.desc;
>> +	priv =3D fd->private;
>> +	priv->comp_status =3D res;
>> +	schedule_work(&priv->ls_work);
>> +	/* work schedule doesn't need the sp */
>> +	qla2x00_rel_sp(sp);
>> +}
>> +
>> +static void qla_nvme_sp_done(void *ptr, int res)
>> +{
>> +	srb_t *sp =3D ptr;
>> +	struct srb_iocb *nvme;
>> +	struct nvmefc_fcp_req *fd;
>> +
>> +	nvme =3D &sp->u.iocb_cmd;
>> +	fd =3D nvme->u.nvme.desc;
>> +
>> +	if (!atomic_dec_and_test(&sp->ref_count))
>> +		return;
>> +
>> +	if (!(sp->fcport->nvme_flag & NVME_FLAG_REGISTERED))
>> +		goto rel;
>> +
>> +	if (unlikely((nvme->u.nvme.comp_status) || res))
>> +		fd->status =3D NVME_SC_FC_TRANSPORT_ABORTED;
>> +	else
>> +		fd->status =3D 0;
>=20
> FCP req failures status should be -Exxx values, not nvme status codes. Th=
is is clear in the api header.
>=20

Sure. Will fix this in v2.=20

> -- james
>=20
