Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE287C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiACAop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:44:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34182 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:44:44 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029BWex017339;
        Mon, 3 Jan 2022 00:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qt1sArt9WUDbIG7lzugU4pT0lMEL4KdHs1If79VGPbE=;
 b=UPzyE7svXLDrOkk4gzs5tkG41z5lIbQo9yu0/8FHbR8pRVaf1/BjJ6CLq+Nmgo+xMWcv
 3T3Gu/1hsQ9GtTyu/MbZcXy+IMfc2yon+iLByWHcr/0x4x5B+9W8tqmWprMDeZiSmCL6
 TJfSBcLxdHTSzOtcXM0RXNaNw5dkMk1gl1/eYuBfBqZZxADB/kP6AJw+i9/VqwBLqcFb
 4OW2N8dvREOfuWTXn7uhec09tY5O3lOnsKf35aRLvgquCB7EQGLhVu1oEeVXO6LZrM7v
 pd/x1eaJhcFtT7baOryefXzFZc8H48mMXPf/VCngQ1dVSmU0jEwiIpWnlEem0imwoaFY 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dafgu9p6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:44:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030f8KB172269;
        Mon, 3 Jan 2022 00:44:41 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by userp3020.oracle.com with ESMTP id 3dagdjuq67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:44:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFyuxVbwSyKlEHIIoKk90o5/IcVKb8pR3Ylz+2KVQaQwBPF3GnqUUyF7c05HzrH8YWw5ouK9iJtMZSYLwrOxlWO5YafA+/2DonyMMgIthD0I+j68N8LXDPsJ61qmaTQ4X1XcPmlbyHag+3Hf4ggx6jrFVme152aR+pDPB5/oOAccyf2Gi4JORZGzkFEOnwyKoshan78sZmUL2tt/cydJWw5JKzZmuBjXBpB1Vde52rHycYrwzSj2cz3seyoQ+gQtoiDjrZutsYntNTG1YCd1m3CGwLyLU7x0YcdoJHJLuv6uA1L1euFUMjxLKpSwvU4XWUyG0H08tzSI/yr6KQZj9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt1sArt9WUDbIG7lzugU4pT0lMEL4KdHs1If79VGPbE=;
 b=QYbTW1cymFFBA878pXHCDhw8FmsAcWsdRea1CFh2bFRXnf/DfqnGS4PjP6QGLiwdkAUJ6QYNvnk13JFTXMiruR5H3VL0nNCi+Di3xFKLl/CrmP0Q6tley1NTWtooW3nMsw4wS8+z3LGLKsmm39KAAE2iJaILiqKjnr5D132sEVaIhR51O0N7bgZQUcclJMfCkGTrnLB9YLe+YCmkuyUb40UZEwclLkP5LHTRkxpLE18NHBv7UJhw6N8lnkh/lt/DaDQCwtgKJTwq3mNciczbHA9R9zzB4CxVB6jqLURJx7Pg0x5HU5tgADVoQUcb1jSbpmfpwl+kqjMrRtxQC65ZWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt1sArt9WUDbIG7lzugU4pT0lMEL4KdHs1If79VGPbE=;
 b=uzSwI9JJNcsjxBeWnz78Y3B9TU54bNR/XyMByif3PoHIVNv0M2Z1SJN1+0BOIAfdIYSVTv6mVbZvSj+Po41ey7DwdmRqMLLF6KepYXh8fsQBbGVtr8ZzTrUzm45bTtDP3RfdEPH4daEneR1krVleXpowFhKOSxuQpIiwNRghXeM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2559.namprd10.prod.outlook.com (2603:10b6:805:44::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:44:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:44:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 09/16] qla2xxx: Add ql2xnvme_queues module param to
 configure number of NVME queues
Thread-Topic: [PATCH 09/16] qla2xxx: Add ql2xnvme_queues module param to
 configure number of NVME queues
Thread-Index: AQHX+JUByQUmSkhQaU++j1+Ckb3OG6xQhQCA
Date:   Mon, 3 Jan 2022 00:44:37 +0000
Message-ID: <AAC9E886-F1E2-4A1C-A37F-687D99A4FDC5@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-10-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bf12ce4-97cf-4dd7-3287-08d9ce523868
x-ms-traffictypediagnostic: SN6PR10MB2559:EE_
x-microsoft-antispam-prvs: <SN6PR10MB2559782419A8C240FAD82860E6499@SN6PR10MB2559.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:530;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oz3MOkXxrpFRGiiiyg+xbxdg2wVnQn22cezvl4RT2mrDf/BSnDw4YLFuNCCPtuA5rqakWW2imj+i6vhhg8F2YfaeKi10EXuPLsPBTQ8iDsykX5ZNw4wBLxQfH0ZZz5W/KkXDHhhL5OfN58D6sLFG3MIky1VkXh2XkqmgfQmZ2zRUdlTBGOspQp76I1qxmtvAR8cnInT3VN4uIpwbzoQXoy9veD/9iQ+xZtmZ4IKO4CMSUr5y+iQLORtXobepFVg9UzzQIlC2xxccAk+hMaz2an0GeaD4F0BOgOQCwGimsP2gvXg58RLxqfrLDOYgA5crBMqnKAWBAKvnPzXoqX6VEBCEObZQ2Px2Vt3CaJdBqu9y+WS2R+iX1DN7heA0G5o2YJ5zBeZqQEnpUIsgUk/0Mz6ROK66iTwXXIVBvsOWmzO1WNFYGzaEtl7FynIGbxjdXmYUXW7h5qsCfR0sFUHZlUh7Klndkqkn8AUOhZlR4fZn9uAZPciukSJX8BAq/XdohjM5VbrsTKqsmaxBE1OMzyr6ApDjL3faq/6NpH12Zq1P31mL5ASQeEeHw73Uh2Bb+7YuVSNdwQrJEaBpzjWGkQXP6QZUhmQF2MhxVRqqrxQ7NPjReu3cot93chCFJAQla5X4tlfwUs3PXKHAK7DdmdgXnqWxa89bt9CqBgmKy5jIJLS75G4Dpfv393yLH4ZYQ+Vz0rBdFl29CU8kKcW/2lfzGCtf4tiRq2xUpmS1FFs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(508600001)(2616005)(54906003)(44832011)(36756003)(186003)(26005)(53546011)(6506007)(2906002)(66446008)(64756008)(76116006)(122000001)(91956017)(38100700002)(66556008)(38070700005)(66476007)(66946007)(316002)(8936002)(6916009)(83380400001)(8676002)(86362001)(33656002)(71200400001)(6512007)(6486002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FivTvzlpAyqhydDDewaIenliaDxdVhWxhxwe/iLqXTuSL/YIE8iCCZBhIgyK?=
 =?us-ascii?Q?wdmwqJb21RqDbzFh2K9uYl1A16K5VqQjYofbBYsWqEwj7mmueMC1Z2p1He69?=
 =?us-ascii?Q?E2ox0TApDAvI5p1umY9tsTnq74gf/msHPp5mURwEgvzzRckoibGh+1IokM+S?=
 =?us-ascii?Q?IR4nwpytaB8mgqRWd+QFYVUSaFjyu+79acbxGfjXUu3LaqTOPYoAWLQ1kwst?=
 =?us-ascii?Q?bHLrlYQIGkHR2nem/Hq4E/CCVrciMWZJQ170cyOl9IwPB8AS5HwHgqt+pVR2?=
 =?us-ascii?Q?P7WdOI6AJzB9LyJWRxtvpH9iqW9Z64+58Eqw+uP+YtRmXf44xBX02jylnmtR?=
 =?us-ascii?Q?jGGabPkFl7x4/xB1Ge0idqDODC3iHuXP5FVO4ieflKvTp8k7MfR1CoxER/Hg?=
 =?us-ascii?Q?OmOXN/sRTbb8+Jyu1VPqf9d4AaQRefCVV8N5N4C5V8RYJ3nmDLQxkuqJqYE/?=
 =?us-ascii?Q?84cv0PPHDH4tpWi8bRI6KdCE5E/cCwdgFUhV39SOZ28ufFXf+vw2arBlGqiK?=
 =?us-ascii?Q?VZFkU5++dJi1Ohe9nDOxb81UMPaxytfsFv1NPdQK2u9C5MAV6KFMJwmO76yN?=
 =?us-ascii?Q?Y+oebjUqGMMBYgUT2f9WPmymMBLxmu+Bd9ZykUSlvqjBcbME5FSjH+Ap7e3A?=
 =?us-ascii?Q?x/ptBvUey3JErlYXDIrnHpu27WNT7Jk2Qv7icxM6XIN8aPNdfSx471Rqbh+a?=
 =?us-ascii?Q?jSca3HqgiU4qSWBvQi9I0liqVyguF1wCEOcStf3MUCID7szW0nwOdKm4vGNl?=
 =?us-ascii?Q?CrFOUwHpXzXgMOiYL92rPiYou0XPhq5/a7meGZbAQTjRVScm1PvLjNoXHEf0?=
 =?us-ascii?Q?od+PJh+TZXfCSN5p3/ta69Sh23xsJef6DnLxN9cIqBgvwO5Jb5eEaT12vgFC?=
 =?us-ascii?Q?+78Slzt+ArLuPMZKmiMjxBQD5MwxGNi1AeTTPF+zf1+9m38s/HRyadHZ2Q+X?=
 =?us-ascii?Q?3fSQAY52ivprI82mGX+u1DxRjVe+XqklY4eKDolitRLFCazEdIpMBBTJYZGM?=
 =?us-ascii?Q?V+PXVv03lJKioQTROjPNAKLGqH45dujwpEBACrBVw623G+8bsEtNPF3q9E1F?=
 =?us-ascii?Q?LbAbUAWP5KVT9spPjEWdu7GIN7tozolUsgvC/hPqo+6UhECmhx1u6VrISk9A?=
 =?us-ascii?Q?ejgPuv518zZM3F58ax+vSKpDssENEaYcFI8uiwmlvHZKCysiw42XPVGQ5O3e?=
 =?us-ascii?Q?h8xzrcN9g39gnq9/GIirRpdAI09tuaQWBLkFWN1v/5LOaNeUuxU97LTUgLhJ?=
 =?us-ascii?Q?DTjyPxZFg3vKxwiFHsYAhqXWZQcxRRcW5UBvf138iy/MRpPtG8oXpo7GQ+iM?=
 =?us-ascii?Q?r29VvBz1KjRTjkOGJDVoPf79t2nfdHZfuObUv/1O9wermweRFEZ5QocxoGyG?=
 =?us-ascii?Q?PpAceMMIVav9pR34nHVEQb5oW6SS7JXEYhF52QNIP6n9Xz4YprgQtrA23HZt?=
 =?us-ascii?Q?4yM3txxSJO+Y/Eu+cnXmIqGC/J+LOi9VIgYqRvJ4PeZ2lMFkpCOe2/Rgh9oS?=
 =?us-ascii?Q?bZkeS2JJ8pH4DNhLMkqtm+Lxxg5sGidA+sKW7XG3PVceF8YyOZOSJqOKqwkv?=
 =?us-ascii?Q?mY6PTj4DZ3qIkzai7TBw7zI2Ral1/2YAudwmzEnIDOrv57Yeh44KGCDQYk/z?=
 =?us-ascii?Q?3WgQgzzjS417RsTeOwHRcrS99ngg7UTT4tjN5siNyEyOfuSTzPMQTgWW8Jqw?=
 =?us-ascii?Q?Aud/BD134DncdIyZJ7d3mzv4JE4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AD4EEAA6283514DA1E45490013EFFE0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf12ce4-97cf-4dd7-3287-08d9ce523868
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:44:37.7378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q/uWaecaay7rZuyhQ2k+L3Ln349+j2gls/VAIeEMeaDwabk8mul+0/EpVtoaUstAYJ/BHcTXA4zA64skvX9mctmCc+mS6QlybKTEhJn35vI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2559
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-ORIG-GUID: 7eQkLQb1xGxgn1PgDdXqoF0UwxEpiKu9
X-Proofpoint-GUID: 7eQkLQb1xGxgn1PgDdXqoF0UwxEpiKu9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Shreyas Deodhar <sdeodhar@marvell.com>
>=20
> Add ql2xnvme_queues module parameter to configure number of NVME queues
>=20
> Usage:
> Number of NVMe Queues that can be configured.
> Final value will be min(ql2xnvme_queues, num_cpus, num_chip_queues),
> 1 - Minimum number of queues supported
> 128 - Maximum number of queues supported
> 8 - Default value
>=20
> Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
> drivers/scsi/qla2xxx/qla_nvme.c | 16 ++++++++++++++--
> drivers/scsi/qla2xxx/qla_nvme.h |  4 ++++
> drivers/scsi/qla2xxx/qla_os.c   |  8 ++++++++
> 4 files changed, 27 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 3f8b8bbabe6d..cedc347e3c33 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -192,6 +192,7 @@ extern int ql2xfulldump_on_mpifail;
> extern int ql2xsecenable;
> extern int ql2xenforce_iocb_limit;
> extern int ql2xabts_wait_nvme;
> +extern u32 ql2xnvme_queues;
>=20
> extern int qla2x00_loop_reset(scsi_qla_host_t *);
> extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index e22ec7cb65db..718c761ff5f8 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -710,7 +710,7 @@ static struct nvme_fc_port_template qla_nvme_fc_trans=
port =3D {
> 	.fcp_io		=3D qla_nvme_post_cmd,
> 	.fcp_abort	=3D qla_nvme_fcp_abort,
> 	.map_queues	=3D qla_nvme_map_queues,
> -	.max_hw_queues  =3D 8,
> +	.max_hw_queues  =3D DEF_NVME_HW_QUEUES,
> 	.max_sgl_segments =3D 1024,
> 	.max_dif_sgl_segments =3D 64,
> 	.dma_boundary =3D 0xFFFFFFFF,
> @@ -779,10 +779,22 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha=
)
>=20
> 	WARN_ON(vha->nvme_local_port);
>=20
> +	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_=
HW_QUEUES) {
> +		ql_log(ql_log_warn, vha, 0xfffd,
> +		    "ql2xnvme_queues=3D%d is out of range(MIN:%d - MAX:%d). Resetting =
ql2xnvme_queues to:%d\n",
> +		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, MAX_NVME_HW_QUEUES,
> +		    DEF_NVME_HW_QUEUES);
> +		ql2xnvme_queues =3D DEF_NVME_HW_QUEUES;
> +	}
> +
> 	qla_nvme_fc_transport.max_hw_queues =3D
> -	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
> +	    min((uint8_t)(ql2xnvme_queues),
> 		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
>=20
> +	ql_log(ql_log_info, vha, 0xfffb,
> +	    "Number of NVME queues used for this port: %d\n",
> +	    qla_nvme_fc_transport.max_hw_queues);
> +
> 	pinfo.node_name =3D wwn_to_u64(vha->node_name);
> 	pinfo.port_name =3D wwn_to_u64(vha->port_name);
> 	pinfo.port_role =3D FC_PORT_ROLE_NVME_INITIATOR;
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_n=
vme.h
> index f81f219c7c7d..d0e3c0e07baa 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.h
> +++ b/drivers/scsi/qla2xxx/qla_nvme.h
> @@ -13,6 +13,10 @@
> #include "qla_def.h"
> #include "qla_dsd.h"
>=20
> +#define MIN_NVME_HW_QUEUES 1
> +#define MAX_NVME_HW_QUEUES 128
> +#define DEF_NVME_HW_QUEUES 8
> +
> #define NVME_ATIO_CMD_OFF 32
> #define NVME_FIRST_PACKET_CMDLEN (64 - NVME_ATIO_CMD_OFF)
> #define Q2T_NVME_NUM_TAGS 2048
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index c4b4b4496399..7d5159306112 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -338,6 +338,14 @@ static void qla2x00_free_device(scsi_qla_host_t *);
> static int qla2xxx_map_queues(struct Scsi_Host *shost);
> static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
>=20
> +u32 ql2xnvme_queues =3D DEF_NVME_HW_QUEUES;
> +module_param(ql2xnvme_queues, uint, S_IRUGO);
> +MODULE_PARM_DESC(ql2xnvme_queues,
> +	"Number of NVMe Queues that can be configured.\n"
> +	"Final value will be min(ql2xnvme_queues, num_cpus,num_chip_queues)\n"
> +	"1 - Minimum number of queues supported\n"
> +	"128 - Maximum number of queues supported\n"
> +	"8 - Default value");
>=20
> static struct scsi_transport_template *qla2xxx_transport_template =3D NUL=
L;
> struct scsi_transport_template *qla2xxx_transport_vport_template =3D NULL=
;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

