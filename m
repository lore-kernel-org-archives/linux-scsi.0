From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 17/25] qla2xxx: Cleanup debug messager IDs.
Date: Mon, 22 May 2017 17:36:33 +0000
Message-ID: <9249EEA3-3A17-45DD-878E-46C14935AC5B@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
 <20170519215344.2168-18-himanshu.madhani@cavium.com>
 <1495236189.2581.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0069.outbound.protection.outlook.com ([104.47.41.69]:64382
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758604AbdEVRgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 13:36:35 -0400
In-Reply-To: <1495236189.2581.15.camel@sandisk.com>
Content-Language: en-US
Content-ID: <39686DEAC7A9634FB847FB81B65A4D44@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On May 19, 2017, at 4:23 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_=
attr.c
>> index 7c8d6c54ab70..a7ac81b473a4 100644
>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>> @@ -44,7 +44,7 @@ qla2x00_sysfs_read_fw_dump(struct file *filp, struct k=
object *kobj,
>> 		    MCTP_DUMP_SIZE);
>> 	else if (ha->fw_dump_reading)
>> 		return memory_read_from_buffer(buf, count, &off, ha->fw_dump,
>> -					ha->fw_dump_len);
>> +		    ha->fw_dump_len);
>> 	else
>> 		return 0;
>> }
>> @@ -162,7 +162,7 @@ qla2x00_sysfs_read_nvram(struct file *filp, struct k=
object *kobj,
>> 		ha->isp_ops->read_optrom(vha, ha->nvram, ha->flt_region_nvram << 2,
>> 		    ha->nvram_size);
>> 	return memory_read_from_buffer(buf, count, &off, ha->nvram,
>> -					ha->nvram_size);
>> +	    ha->nvram_size);
>> }
>>=20
>> static ssize_t
>> @@ -406,8 +406,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, st=
ruct kobject *kobj,
>> 		    start =3D=3D (ha->flt_region_fw * 4))
>> 			valid =3D 1;
>> 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha)
>> -			|| IS_CNA_CAPABLE(ha) || IS_QLA2031(ha)
>> -			|| IS_QLA27XX(ha))
>> +		    || IS_CNA_CAPABLE(ha) || IS_QLA2031(ha)
>> +		    || IS_QLA27XX(ha))
>> 			valid =3D 1;
>> 		if (!valid) {
>> 			ql_log(ql_log_warn, vha, 0x7065,
> [ ... ]
>> @@ -1295,7 +1295,7 @@ qla24xx_84xx_fw_version_show(struct device *dev,
>>=20
>> 	if ((rval =3D=3D QLA_SUCCESS) && (status[0] =3D=3D 0))
>> 		return scnprintf(buf, PAGE_SIZE, "%u\n",
>> -			(uint32_t)ha->cs84xx->op_fw_version);
>> +		    (uint32_t)ha->cs84xx->op_fw_version);
>>=20
>> 	return scnprintf(buf, PAGE_SIZE, "\n");
>> }
>> @@ -1608,7 +1608,7 @@ static void
>> qla2x00_get_host_speed(struct Scsi_Host *shost)
>> {
>> 	struct qla_hw_data *ha =3D ((struct scsi_qla_host *)
>> -					(shost_priv(shost)))->hw;
>> +	    (shost_priv(shost)))->hw;
>> 	u32 speed =3D FC_PORTSPEED_UNKNOWN;
>>=20
>> 	if (IS_QLAFX00(ha)) {
>> @@ -1853,7 +1853,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>> 	    !ha->dpc_active) {
>> 		/* Must be in a 'READY' state for statistics retrieval. */
>> 		rval =3D qla2x00_get_link_status(base_vha, base_vha->loop_id,
>> -						stats, stats_dma);
>> +		    stats, stats_dma);
>> 	}
>>=20
>> 	if (rval !=3D QLA_SUCCESS)
>>=20
> [ ... ]
>> @@ -2147,7 +2147,7 @@ qla8044_serdes_op(struct bsg_job *bsg_job)
>> 	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
>> 	bsg_reply->result =3D DID_OK << 16;
>> 	bsg_job_done(bsg_job, bsg_reply->result,
>> -		       bsg_reply->reply_payload_rcv_len);
>> +	    bsg_reply->reply_payload_rcv_len);
>> 	return 0;
>> }
> [ ... ]
>> 			    "DMA allocation failed for %u\n",
>> -			     qla2x00_gid_list_size(ha));
>> +			    qla2x00_gid_list_size(ha));
>> 			return 0;
>> 		}
> [ ... ]
>> @@ -384,10 +384,10 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
>> 	}
>>=20
>> 	ha->tgt.dfs_tgt_sess =3D debugfs_create_file("tgt_sess",
>> -		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
>> +	    S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
>> =09
>=20
> Hello Himanshu and Quinn,
>=20
> This kind of whitespace changes makes the code harder to read and is not =
useful in
> any way. Please remove all whitespace changes from this patch.
>=20
> Thanks,
>=20
> Bart.

Sure. Will update patch.=20

Thanks,
- Himanshu
