From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 07/43] qla2xxx: Add ability to track IOCB resource for FW
Date: Wed, 20 Dec 2017 20:57:41 +0000
Message-ID: <C7390E63-B4CA-45C0-9CEE-D3CBE4350313@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-8-himanshu.madhani@cavium.com>
 <1513788671.2603.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0053.outbound.protection.outlook.com ([104.47.34.53]:28128
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756202AbdLTU6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 15:58:25 -0500
In-Reply-To: <1513788671.2603.26.camel@wdc.com>
Content-Language: en-US
Content-ID: <7C6EF2D2F3F6AA42BFBDBE5B79511B8D@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Dec 20, 2017, at 10:51 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:=20
>> +#define QLA_ENA_FW_RES_TRACKING(_ha) { \
>> +	int i; \
>> +	_ha->base_qpair->fw_res_tracking =3D 1; \
>> +	for (i =3D 0; i < _ha->max_qpairs; i++) { \
>> +		if (_ha->queue_pair_map[i]) \
>> +		_ha->queue_pair_map[i]->fw_res_tracking =3D 1; \
>> +	} \
>> +}
>> +
>> +#define QLA_DIS_FW_RES_TRACKING(_ha) { \
>> +	int i; \
>> +	_ha->base_qpair->fw_res_tracking =3D 0; \
>> +	for (i =3D 0; i < _ha->max_qpairs; i++) { \
>> +		if (_ha->queue_pair_map[i]) \
>> +		_ha->queue_pair_map[i]->fw_res_tracking =3D 0; \
>> +	} \
>> +}
>=20
> Has this patch been verified with checkpatch? Did checkpatch suggest to s=
urround
> these macros with do / while (0)?
>=20

Checkpatch did not suggest to use do/while loop.=20

I did however saw indentation warning which i did not change since it looke=
d like false positive
=20
WARNING: suspect code indent for conditional statements (16, 16)
#133: FILE: drivers/scsi/qla2xxx/qla_def.h:4460:
+               if (_ha->queue_pair_map[i]) \
+               _ha->queue_pair_map[i]->fw_res_tracking =3D 1; \

WARNING: suspect code indent for conditional statements (16, 16)
#142: FILE: drivers/scsi/qla2xxx/qla_def.h:4469:
+               if (_ha->queue_pair_map[i]) \
+               _ha->queue_pair_map[i]->fw_res_tracking =3D 0; \


>> int
>> qla2x00_dfs_setup(scsi_qla_host_t *vha)
>> @@ -504,6 +776,33 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
>> 			    "Unable to create debugFS naqp node.\n");
>> 			goto out;
>> 		}
>> +
>> +		if (ql2xtrackfwres) {
>> +			ha->tgt.dfs_ini_iocbs =3D
>> +				debugfs_create_file("reserve_ini_iocbs",
>> +				0400, ha->dfs_dir, vha, &dfs_ini_iocbs_ops);
>> +			if (!ha->tgt.dfs_ini_iocbs) {
>> +				ql_log(ql_log_warn, vha, 0xd011,
>> +				    "Unable to create debugFS reserve_ini_iocbs node.\n");
>> +				goto out;
>> +			}
>=20
> The patch description shows how to control the new attributes through sys=
fs
> but this code adds new debugfs attributes. Sorry but that really confuses=
 me.
>=20
>> +int ql2xtrackfwres;
>> +module_param(ql2xtrackfwres, int, 0444);
>> +MODULE_PARM_DESC(ql2xtrackfwres,
>> +		 "Track FW resource.  0(default): disabled");
>=20
> Why is this a module parameter instead of e.g. a sysfs attribute? Module
> parameters are annoying if the qla2xxx driver is not built as a module.
>=20

Looks like sysfs example is used instead of DebugFS in the commit message

>> @@ -6412,6 +6433,9 @@ qlt_enable_vha(struct scsi_qla_host *vha)
>> 		qla24xx_disable_vp(vha);
>> 		qla24xx_enable_vp(vha);
>> 	} else {
>> +		if (ql2xtrackfwres && (IS_QLA83XX(ha) || IS_QLA27XX(ha)))
>> +			QLA_ENA_FW_RES_TRACKING(ha);
>=20
> Why is there a dependency on the adapter type in the above code?
>=20

We do not want to support this feature on 8G and older adapters.=20

> Thanks,
>=20
> Bart.

Thanks,
- Himanshu
