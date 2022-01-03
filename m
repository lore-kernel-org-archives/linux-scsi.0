Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35721C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiACAeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:34:25 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34950 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiACAeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:34:24 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029DRoo028072;
        Mon, 3 Jan 2022 00:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xEZCkNG7j79AuCLJOL0eM9TM4+0fWtUa5Ny+Ctn+MGw=;
 b=lhMcWFK1dGpjTHzP9YqXJ7NfAYLWqzwoKE5ddgzHg6t6bTd3bHPHv/otU/6sRxnksrhh
 TIQJKyj8qsndSCrcdUbjLWZlr+g9JOyiUp9A0mTE2df1r4mToEv6qtfOFSxhYaVZV1VF
 rSEVhvDjPp73RaEAoH3JyeQMCMgAZ+oHl4IoTrj4tbWYNhU9Nou+xZ6zMhzyY7rGuQJt
 9nFiCuFMCFjuH3aNOnvPLr0Gfrf/oczSaootUIAYHa3d5w4e9zXjfo4XmlJ4DSkzimLi
 hKyG6qWTQdOZ4Z+6vFZVdZj6ZkKbxOJMc/fvjMpJdxYfWTll9rHDu6Se0GV0rcpSAj2W Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadj1sqhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:34:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030PxBm142834;
        Mon, 3 Jan 2022 00:34:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3dad0bfn7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:34:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrwGKrOVDvs0T3LgaYzdzGEYsMhKV2tv2Gw4gS/iknBS+2NipHyRsK0JWKpgj6cpP9izP8SV0LKm+mLDpwHDPC7rjXYaiKUan2JOhiUNnIEARY0ti00dCRmDz6OzlCqCnvT8NbuRIFA5PxH5Ob9D8sgjvKJhAMAE6Qbz+mpdVgcRElBRHAxhZy1NtWkuwywmDWAfvx7wOZi3TKqPxGYsyrUaHmkK4jIYZ7013duW/0SrpTkjrQxP82Zmvmzhahyoqe+S57UavX4XPWh1V4ssngT5OzH7e3T55XrSkFOif6kAij+tzym9NwfBun1IMJDm0eVkbMluFt2FfAtBz3pL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEZCkNG7j79AuCLJOL0eM9TM4+0fWtUa5Ny+Ctn+MGw=;
 b=Jfj8bwoHewxd39ZmCTBQjSKfth3i8HAnle2qWRei6WexS7Fg9g7yaqRtjCya3aC7QB3t7UlqDFZW14fw6qo8Eccg3k2x1sOzvKAU7Jt07MTZYT+C+nUrAWlE9bvUg2RqeTHpchGYfsEtyMKQD3hBQgz16L+TuDkwhIfT/B6XTf4URl+9x42X9vHgJdB5r5DpU5OJJ9vKJFaeEPj8LFhx3M3HZZkO8xeO9VrFSgwFxtRWjMLZZSCGoWJ/IpNEG/J5VhkzYMrrtKp/sZ+ZaFT8/eWgcG/qi7x06QD9pza/IzwT4K8PisDjgLJzgHJmltNZnpWdyE1lW8rVCGf8DQlCTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEZCkNG7j79AuCLJOL0eM9TM4+0fWtUa5Ny+Ctn+MGw=;
 b=ujhvQkMa7nU4M73QJhkAi8n1AFCi14HITGMCqs5UI4HiES5WdQvm5rvfdnmLVIQeldTIFLHMd5ep2M5350t4blIQnVxWuj1BTsymuydaAHQl1sBEmmXrPaTv9mRD/iBmLwypnKkxPkTwAPwPoWfhMHjbFBD4cdi/qntEr1yPnEA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:34:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:34:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/16] qla2xxx: fix stuck session in gpdb
Thread-Topic: [PATCH 03/16] qla2xxx: fix stuck session in gpdb
Thread-Index: AQHX+JT93M3LvfNfV0iN69TO7bl0kqxQgiCA
Date:   Mon, 3 Jan 2022 00:34:19 +0000
Message-ID: <D629F6B4-081B-4FB3-9A6F-D167F16073EC@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-4-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5ba80b8-77b2-4ca4-1373-08d9ce50c7e6
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4537608E97215005A36A55C4E6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wV1MExlr7LnXIXZfHSqV2gi5v8Omeb+QhsS8hAuNLXxF/gLTR8R1RN1uaEIUePa95ojZOVZSol9lDaC4FTwVDHIvS890emhaLg26CSqyCN1OiEvNdoIQYrUYgqdB30pOmFNMFwcriGdCMrBm2whVJ8vvm0M2BXrIeA1r8A7WicKfcyDkD2IfQL1QMoTmXQeW6wHEmoBoQq6NTRzoZz9WcI0p67LkZGiL7IDkH0A5bS0ykBha2yQxKfZezSQPqY6ItO5ei/TsVO1Rp6lvHVyXI7iFg1PuCk0bGB8TvTlf4+G2SGwVcEoJH8gXS233xNoQLeUAfQdm3WlaPlgPdEukRHt2T08JBvQsCKmg7IAvO9YfoPQpf/dXiyt2lhUxujBfjMNLGaQ2xDXUVGurWcbdOz40GEl5VBIn8YJV/HBrxDKOrDOPf+guT6IjxKNZXuI4M8SH6efrhtjgFtFUp5eeOt5NtRIJSmw8qbRz+cEJxktGMvkWZQ6AP7YoCzVzg6aGujyifENBqmN2XCkpXTnggVOIjl13zlEuOjBmHqET6AEp3p688KDBfYeMa5EoXER+SF2+sc3A2b01LnnCZeHiw6r6oVblvgNbTy5xE9xIPSa3+SEdTe5+QSrKtfjS83hpQrqGN0fuwRdKf/oiWQWpq+1r4LTFZZGREHaqlMFU6hLPowFw58d6aJDafAnAALDBZ7bKGQouFcLCzU9GUEz56tkFYuO5B2k8dNZ2TR4DtgU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?heNwB3Zf+/ukqxAWL4yOaNRJx5tx+Epso8QfesRNUYqRaQivCsYVc4HbPZOe?=
 =?us-ascii?Q?VD0KGCKP4cGVY+xe6l1R1RJBUn/OBQnZjg4bZw3RuitIHChz76VOny3mFa/L?=
 =?us-ascii?Q?BqCfGWlqyUErGf3lhrUYmmbPasnxxGhVBQZKRBcIo/8F1df/IFKXI6oTVmch?=
 =?us-ascii?Q?+LNXVLaW/z7kLXht7KGJpj3ZmfuXUgOTQyIv6xmio1YnrhdMYVnQUsrRHxzQ?=
 =?us-ascii?Q?D5Yw5SYtrdv0P9J3gTTFoeNEBGudcytZAna3VVG/h5hOXkLclUuDjBpn+DFf?=
 =?us-ascii?Q?UspRrLtIuSRA+zgxv/kJrTduGoG9VvG9fOKNRX0mjx3uHhA1+KuUTf1HyzSV?=
 =?us-ascii?Q?W93EPwUyF/8m+Lqpq2gX9iOlRHzCWYqStUwAzfu6eNSH/sacL50xYkvqCsim?=
 =?us-ascii?Q?xHRXxEu8ALR1koggX0KjR8OKY4RtU3ypVwJUKRx+004+o4P2nni6Cq7WRQKy?=
 =?us-ascii?Q?tbkbKHdfyT72nip2G912csOWi4fGFa4h+L5JOcsQl9mVWkX6XCoahF5adyPt?=
 =?us-ascii?Q?Knf/NISA865+XFRyUZYAKbhQ8XXE30Hmp85OUEsz0AYi2WwBRTQ2GgYiZJbJ?=
 =?us-ascii?Q?RRL9gv61h3GJSiEjE5SnClhi9dhYTl/+8kNjrD8nDte6TAYYIbS6YR9WVE5P?=
 =?us-ascii?Q?xR9gwPHvfK8My6zj0Rb+HWK3avzgjotesc2gCBfiNu1oDckaQ0vMzjboKO2K?=
 =?us-ascii?Q?z9/FXc1t4+dcX4l9TaMwuyT/apLXR5qgmUlYVEZQMQ8L3fTJDEsLMAAHgWnp?=
 =?us-ascii?Q?s80ln91xTbcLwJJtpU+cVm4+voEhT7+StbFYMbo4nNcRgVZED74YoSKptwTi?=
 =?us-ascii?Q?Q9rVeBZfBPI45LGqFv5DMvKMaWoZGyjw0nA0/oVg39wrBrvVRPMjki5pxjGU?=
 =?us-ascii?Q?V3AihD+Rs1fUdTLQqEFGgKMSP0Iw+5y7C58r2lc351Cb/pKChwMAZeDVv3K3?=
 =?us-ascii?Q?cqc/lMSR6h+7vkG4pO4butA6kYWlp+KIJk6YxEwLSboQ2XH7p0UbEXo1l4WE?=
 =?us-ascii?Q?QVDKmsZP359f3g+NnVSdxQzRZiJDdLMDs95TFo6L2LW9zoqpTZhDL7KgXIvg?=
 =?us-ascii?Q?nGhB20ohtR/Eri+xT+wHdLzImFE989pHRCLAoM7nhcyoo2gSvp++Ji5X59u4?=
 =?us-ascii?Q?e1E3ETYKv6G+CfWKFHFOZw3H4/T0CWH6Y2SB+T2T8R2++0uUueotHvPerQ9E?=
 =?us-ascii?Q?47Sub5goysvECPS/cF27Qm9arAd9gapG5LbG8G1vWw1xoF2VMWvtl9zdpVZL?=
 =?us-ascii?Q?+aaPPMZHWKe+34IG9mHEReVCFhYKFngG4s9RlLXGn/aKv8ubl7y9ugvwJVPp?=
 =?us-ascii?Q?1oCVA0hFAjh0uSPhekAD6Q7b/wuWmnJ4WANFNGewGrQwUAEuDuZj12hi3DvS?=
 =?us-ascii?Q?3FFkiwVT9HPCsi1p65IADE2aHlz0BjTRdtpTPUFjgxVHpDyJXZWghFXPz0uh?=
 =?us-ascii?Q?/Kef8skxAo/OTdIuz/J8PGa1FNUSSDDEuHkiA8EEVFwxbT6oEdmBSTSZQ4hP?=
 =?us-ascii?Q?/T4XLGgTOeutX8E49y33gz5gWircUebhnfpeJWpAfK5EmMZrdhlV3ZSWRgeI?=
 =?us-ascii?Q?cTQUP30EKy+rDNZLJust+GXArm9U78Z1dK93Ax480lNyBO4YBr121vdYFYTv?=
 =?us-ascii?Q?83ihJOAQpHTOlJ904N0krnBr2FOj3QkT1PhAob8hXr5SigWVTwIMTqBX3gw1?=
 =?us-ascii?Q?zXlBK9hWELDnX0seEybOTjpJPTU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F801D1816D3EE47A3FF006679B9996E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ba80b8-77b2-4ca4-1373-08d9ce50c7e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:34:19.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSVCc2IqhUtAyG1v9rPkN67W0Tns0rsWIK69KsgW9c04UtroyZR8si4AZd2jacBKKtQFE86+2d/R1M2QYQaTendi2DkNxPhNZvlA/DMu+Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030002
X-Proofpoint-GUID: M98tf3l1sgvTpoatk-Nu3WwV_f41sg9A
X-Proofpoint-ORIG-GUID: M98tf3l1sgvTpoatk-Nu3WwV_f41sg9A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:06 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Fix stuck sessions in get port database. When a thread is in the process
> of re-establishing a session, a flag is set to prevent multiple threads /
> triggers from doing the same task. This flag was left on, where any attem=
pt to
> relogin was locked out. Clear this flag, if the attempt has failed.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 38c11b75f644..0b641a803f7c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1332,9 +1332,9 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, f=
c_port_t *fcport, u8 opt)
> 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
> 	    fcport->loop_id =3D=3D FC_NO_LOOP_ID) {
> 		ql_log(ql_log_warn, vha, 0xffff,
> -		    "%s: %8phC - not sending command.\n",
> -		    __func__, fcport->port_name);
> -		return rval;
> +		    "%s: %8phC online %d flags %x - not sending command.\n",
> +		    __func__, fcport->port_name, vha->flags.online, fcport->flags);
> +		goto done;
> 	}
>=20
> 	sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> --=20
> 2.23.1
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

