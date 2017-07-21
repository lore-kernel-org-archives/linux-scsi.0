From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 5/7] qla2xxx: Simpify unregistration of FC-NVMe
 local/remote ports
Date: Fri, 21 Jul 2017 16:25:40 +0000
Message-ID: <6C9E765B-533C-487E-A8B1-D9151D6F52C5@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
 <20170719185151.8564-6-himanshu.madhani@cavium.com>
 <20170720070308.GF5240@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0045.outbound.protection.outlook.com ([104.47.32.45]:41408
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752098AbdGUQZq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 12:25:46 -0400
In-Reply-To: <20170720070308.GF5240@linux-x5ow.site>
Content-Language: en-US
Content-ID: <5437A936B996E24AA521963D9A1C8686@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Johannes,=20

> On Jul 20, 2017, at 12:03 AM, Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
>=20
> On Wed, Jul 19, 2017 at 11:51:49AM -0700, Himanshu Madhani wrote:
>> -static void qla_nvme_abort_all(fc_port_t *fcport)
>> -{
>> -	int que, cnt;
>> -	unsigned long flags;
>> -	srb_t *sp;
>> -	struct qla_hw_data *ha =3D fcport->vha->hw;
>> -	struct req_que *req;
>> -
>> -	spin_lock_irqsave(&ha->hardware_lock, flags);
>> -	for (que =3D 0; que < ha->max_req_queues; que++) {
>> -		req =3D ha->req_q_map[que];
>> -		if (!req)
>> -			continue;
>> -		if (!req->outstanding_cmds)
>> -			continue;
>> -		for (cnt =3D 1; cnt < req->num_outstanding_cmds; cnt++) {
>> -			sp =3D req->outstanding_cmds[cnt];
>> -			if ((sp) && ((sp->type =3D=3D SRB_NVME_CMD) ||
>> -			    (sp->type =3D=3D SRB_NVME_LS)) &&
>> -				(sp->fcport =3D=3D fcport)) {
>> -				atomic_inc(&sp->ref_count);
>> -				spin_unlock_irqrestore(&ha->hardware_lock,
>> -				    flags);
>> -				qla_nvme_abort(ha, sp);
>> -				spin_lock_irqsave(&ha->hardware_lock, flags);
>> -				req->outstanding_cmds[cnt] =3D NULL;
>> -				sp->done(sp, 1);
>> -			}
>> -		}
>> -	}
>> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>> -}
>> -
>> static void qla_nvme_unregister_remote_port(struct work_struct *work)
>> {
>> 	struct fc_port *fcport =3D container_of(work, struct fc_port,
>> @@ -719,12 +679,13 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
>> 		ql_log(ql_log_info, fcport->vha, 0x2114, "%s: fcport=3D%p\n",
>> 		    __func__, fcport);
>>=20
>> +		init_completion(&fcport->nvme_del_done);
>> 		nvme_fc_unregister_remoteport(fcport->nvme_remote_port);
>> 		qla_nvme_wait_on_rport_del(fcport);
>> -		qla_nvme_abort_all(fcport);
>=20
> What changed the need to abort all outstanding commands?
>=20

FC NVMe transport now handles _abort_ so we do not need to call qla_nvme_ab=
ort_all()

> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks,
- Himanshu
