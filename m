Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBE9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiACAxB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:53:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24506 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:53:00 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029l0ZJ028950;
        Mon, 3 Jan 2022 00:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oLNGuHMdI2AkHT0AOFxtdr63bMvuJElR2HIFu8Ir7eM=;
 b=moACgc6eo4lOzKCQwd50/kH7mBCCmSl6lm45e6s03ltHuBwiZVT/L1AARiTfKHl5BHFA
 f7G667LxxRNWA0DVpMUrgcbh35xcTpKvHWtEN7h4U38gV6UWILTRhTlyfVh0q8oCPDoM
 AUqYtX2guhZ8cGUn9uXVLtZGuhdK7QiuLLdVPcwfo47rNyRKGbXeziV7Q2oNb3K9HnPi
 MhjGoqPEW2q2GZW6VXbAvlXe4E+Zo3Rz7IzTQdFFVVmiBEQdmboONjrJRkkMy0EpAtCM
 aTRXtO+ewUZH0INZCt82p6HGeThX1RWQzFkc7vbrYTR3MekfjLhwGDEI1Iap8uLgAZE8 nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daeuahpgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:52:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030pvAq002619;
        Mon, 3 Jan 2022 00:52:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3dad0bfuxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:52:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqNPVm2jXdGY3284vXPscl2o3b7jifEpENdmijvek1dhtfCD1PXJEUSj9YavZ68+SRgMQXR3aSRFj1zSCxcawSrIgJcBTSsR+zrD/1hRgQEDqNLVDCfIBUDwxbJWkpD+hUUxiUHmsys0tDb/wntEBtL0+G+dIVGZYTeEzKShnDP29wDOTx4Ih7SJAP/LERfjFc193aZEDykNuqEsC6Yi5D+ZfiS5YjXbIK3/OWZNIme8Vl8dGUDL37a2L4nsRXBi6CB67EKW6N26Q7kutI9yeIg8bPQTEpquAxLWVkQw2GLEKyJGPsxJ5MVOzt1VfNTqnFHTxako/k5jelPA/PARBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLNGuHMdI2AkHT0AOFxtdr63bMvuJElR2HIFu8Ir7eM=;
 b=Fi7KJ7WicBtmzj1N8FHnyLzMyL40S4z9lCqKh0B240Y5f9iGUW/cNsRA57ZPxdD8PsOJOdZakpsc1gNhDSlN7e8ZSsQIW4Z9VVlymLGTTn5T0/HmEg4PMpDWndFaUvskrkH19DZWZmg73SygF0ZsYsDQDzO7McZI/39T11gIxivoHY8sCQFpWsBShrWLCHs1Jmuq42H1U2i2/tj4yeCk6Y/+eTVbhp+m0imbkF4e4FqMdv5nNJ9V5C7QgzFmV1dlwGNfTNuhsC8+x66MREGL8DdFAL+MEiUHsFjmaKLhIxSYvfHg9WjNuAQx2mcGg2HbPVuqlGNXEn4EU2cjwQPA0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLNGuHMdI2AkHT0AOFxtdr63bMvuJElR2HIFu8Ir7eM=;
 b=sqB752hufs9uCfDWTmgRYystVQpRXHPxmQ975082OPQt9cL3WMliKp1jbhsbXCSVaibGPBGCcLfS05AsNWbr3hCI66jfokfF8lNJ4277dv4Q4aoDRvl/fNm8Lo3RboFVIH2+7Tw4U2WzxCfYBqCVv/KFcPH3EAcPJGIEMnJQdUI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:52:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:52:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 15/16] qla2xxx: Suppress a kernel complaint in
 qla_create_qpair()
Thread-Topic: [PATCH 15/16] qla2xxx: Suppress a kernel complaint in
 qla_create_qpair()
Thread-Index: AQHX+JUJGhv8MT+taECNWgmwB2GcDqxQh1EA
Date:   Mon, 3 Jan 2022 00:52:55 +0000
Message-ID: <67818975-27AA-49D7-BD5C-4519660031D5@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-16-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-16-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7151b9a3-6f1a-40d4-5cef-08d9ce5360d8
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB5710CBD8E5A331654BBE19A5E6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9AzxTozzJicxTRMSaaCIR7neKbtjgdWRVKVVeAWAoA1oQ3Xb+eSWPuboMU+XIw7tJh/Q+BgV8v+UTdZZUJsYuXIzTmUiJBzbwkpq4d+26QvoaT00lTQ8vsXx2dr305ofLFlu0VQNfPVweTnFsAnXxVP5ZFmMVflYm0EyoReySLhwt5Ytr6YUBPhG3dqdvX/aT5EITl11U9o4s7nzx4x85xKZ2GUQR7RSMCwzRLE5rLoqd1aiNnboBbAO9PXqM7ztr7OBn0v35Fht4Nlwst4eFWubN9Dsh1t6QxBLB/tNBfzRQpDXJkhpiPtwAN0Xm26eyAHI1SIkpQA+uMTTHm9c/4+RHGb+rkkHtO+JF4cy8XKiSILl88qr/tMHS9T7LJfB9htZPbooFdgnJ9UkfEstvSFXm87Sl8kR+UDaIJIUijG3d52ltjTeYW4rqn0Aa9Ka7Ok0DWm1dfBSuaKuoHA/iWO7CTeuGpLcXdV/quwhc4NP5Q/D64IaU/NwWkrnrKL7o3XqbnI1K7pYsDk4g7LqXSWhQVerNC2YNVniQx1YCEcbn/4CTO4bap5iuxHEoY1alg6cj4cvt2BHV5Wtv9wloM2sPaxaTr24vtLQdR5SGarV/7UjDyaYF/cLbRhGwyO04TPYIHm4m0bVkFBRFP9FR6G7uQqvxMmt4V1tIwdqU4DT+82AxQ5bwoput8q2IpCIQ6wQRJZOgzdtc7zrC06gA63E/XrYNa4PrlLuSy7Q1t0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(44832011)(76116006)(6486002)(91956017)(66556008)(5660300002)(38100700002)(54906003)(508600001)(2906002)(8936002)(4326008)(186003)(66476007)(86362001)(2616005)(26005)(8676002)(64756008)(122000001)(71200400001)(33656002)(66946007)(66446008)(6916009)(6506007)(316002)(83380400001)(38070700005)(6512007)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j1mvyJZT712HRNtB8MXy1Vp7Gv3i99k8luW7vt7FurY6nHDQCbIh45zRMyn0?=
 =?us-ascii?Q?SGgWhucDxPdHV00mU17WcRskE+4t/QB7Tln08jBjwdm+0rzUrq5gJ0CUk1d6?=
 =?us-ascii?Q?F/Fs7F3XG5+7aDIwc1DFlDbgjmHzaaqATrhirSOiDowWgQYNgC7+2d9HEPn1?=
 =?us-ascii?Q?aejbNbpXe6SDQh4PmY7mNtvqz4YZ99T0VemLlC3elgHCFs/eiLOl9Nl+T1cz?=
 =?us-ascii?Q?5OUpQVCmNwieuxhbd5CKX0lWTDOCrggXc1XRJq0a7sVfEJrNat2ZK99BKS6o?=
 =?us-ascii?Q?WgAPG4TbY7J4DQJYcDDU446ja2ACqR4onldUV4xzaPUPi+MkdFxAkXqO3vcE?=
 =?us-ascii?Q?szknPmPgayHiSxocdMUQx6PozCY/HrKnp5J/hRZ16+rc+sOj83XMCH8OrYXu?=
 =?us-ascii?Q?HHLd80ZRYHdXNtQzpUQ75ti6MTLx34EF3EPhcFxaE4mVRZ3b9gwwz/gYyEq/?=
 =?us-ascii?Q?yL1orP5vhlpMgGjMr8SKU6U60nZDOBJoqWvho/PGn9T7/QeafRaoucrjLE9h?=
 =?us-ascii?Q?snRK4Bt2e7pgvaJHPpf2rfsVzf2f7NCx0eF5jTHygwOFKa+RXFhRMIyspXAQ?=
 =?us-ascii?Q?s84PjO9sH/aTJ3MeFgTZBwXliQjlc91T00DoXTll30nj8sZtMnWgXUNP61mD?=
 =?us-ascii?Q?PHpaX32EyY1ghn4UEfCn9EJG7LXK73q3zqeJg1y468/lgKgTW8QoEgRx4RJM?=
 =?us-ascii?Q?rCzQgcAJRLfHBkWSiAnUe+U9gEJQjBtiNlA45PmZSKJzaYWGLBqmFAX/a6fh?=
 =?us-ascii?Q?F+TAnhMNtPUhZ/mUblOYqADCPULsip8isOWOQjGOdwuGyFmUsMfhlStxGbHv?=
 =?us-ascii?Q?rOU2uz/0h2Ny5M29O8EOk+b4BSjDe/OwN+1T2XcEGUfyuWbUvXDMWM8cmWk7?=
 =?us-ascii?Q?818FKzp1ZPWd3p5BMJakCzmNggvUFP9jadPuL+UmpCk85rVPeje/Q9O0sbU5?=
 =?us-ascii?Q?7JUyvla8xeW0sYxMCmuAX2rQpCnluge0arpwU8F3mnZFdwbxehKM2sy8Wnwt?=
 =?us-ascii?Q?wCY3Y952wHPceAWKmw8W4cAf8okvyh+iyGvNCGu+0bIJI+gBTjjNGK6JAXQY?=
 =?us-ascii?Q?cxa/dNMzGXK26FaKofAytG4GoVVYbdn1qWq9xWv2jrvEfp8r6gfjDVNHPcqz?=
 =?us-ascii?Q?Vfr16njmHpbTB4FEFvXmPuJ9FAp1zULuSN7w6VKSw47UVIlflEzlKwZ1O6ow?=
 =?us-ascii?Q?bFkY5WLJQn7EQ9tRmjmwWx4/y/LTtvstuMB1xcXCQjTdGqVSfda37qUKew4/?=
 =?us-ascii?Q?BgxKiQfe2rSFmiOPXHA97AsqG6KvTQKiVm86cv0ZDqdJ2Wpsl7o/GfGbbbw6?=
 =?us-ascii?Q?/yU9je/KFob0oT3FXJ7LBk5/muC5ItpG9erZultbAgswaDVNXuH8mKzwWBpc?=
 =?us-ascii?Q?d59no/e5h5fG42HV1JaB9QbghCKP7UDlD1elXcguEmaEL2TTaH/ZFHF+Bnc7?=
 =?us-ascii?Q?7XwVKIpc8L1WGPqmI05S0Jcosv7FePMNOCbjTRYIzo0Q156rn+d3NIlPvaRi?=
 =?us-ascii?Q?sr2Sxw6zl6rVGMtsko7l+sQ6gQdaK7W6dG1a/SxfBQ4unc/vV35bsvUgIfiy?=
 =?us-ascii?Q?GXOjdKT0rs+ObtS9xiWXb69P+6eckYNe8farVciPhxshrlR99eRID/RSmb31?=
 =?us-ascii?Q?4TsJWTTxLhKPDc4kZVba1qD0hazldxzRX32G5+610n2wsGwveIJ2IM8ATQbH?=
 =?us-ascii?Q?w5q4nbXd4KtMDAmWqFt7fYlLpPk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A178C07F0346AF47B30C41089AB75AB0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7151b9a3-6f1a-40d4-5cef-08d9ce5360d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:52:55.1566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z7DBWtdBdJbBWGqWpp8Of0zS9W1UMNztpGaQJ6+e9lbe+DzedN9drOWhjTwCGBo5Zi463UFb2IwbCZquApe+kWVKMhthBg2/MfVi0yzz6Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030005
X-Proofpoint-GUID: 3BEb4GM6V3FDTwD3F5AFdbcwOpeTtEG-
X-Proofpoint-ORIG-GUID: 3BEb4GM6V3FDTwD3F5AFdbcwOpeTtEG-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> [   12.323788] BUG: using smp_processor_id() in preemptible [00000000] co=
de: systemd-udevd/1020
> [   12.332297] caller is qla2xxx_create_qpair+0x32a/0x5d0 [qla2xxx]
> [   12.338417] CPU: 7 PID: 1020 Comm: systemd-udevd Tainted: G          I=
      --------- ---  5.14.0-29.el9.x86_64 #1
> [   12.348827] Hardware name: Dell Inc. PowerEdge R610/0F0XJ6, BIOS 6.6.0=
 05/22/2018
> [   12.356356] Call Trace:
> [   12.358821]  dump_stack_lvl+0x34/0x44
> [   12.362514]  check_preemption_disabled+0xd9/0xe0
> [   12.367164]  qla2xxx_create_qpair+0x32a/0x5d0 [qla2xxx]
> [   12.372481]  qla2x00_probe_one+0xa3a/0x1b80 [qla2xxx]
> [   12.377617]  ? _raw_spin_lock_irqsave+0x19/0x40
> [   12.384284]  local_pci_probe+0x42/0x80
> [   12.390162]  ? pci_match_device+0xd7/0x110
> [   12.396366]  pci_device_probe+0xfd/0x1b0
> [   12.402372]  really_probe+0x1e7/0x3e0
> [   12.408114]  __driver_probe_device+0xfe/0x180
> [   12.414544]  driver_probe_device+0x1e/0x90
> [   12.420685]  __driver_attach+0xc0/0x1c0
> [   12.426536]  ? __device_attach_driver+0xe0/0xe0
> [   12.433061]  ? __device_attach_driver+0xe0/0xe0
> [   12.439538]  bus_for_each_dev+0x78/0xc0
> [   12.445294]  bus_add_driver+0x12b/0x1e0
> [   12.451021]  driver_register+0x8f/0xe0
> [   12.456631]  ? 0xffffffffc07bc000
> [   12.461773]  qla2x00_module_init+0x1be/0x229 [qla2xxx]
> [   12.468776]  do_one_initcall+0x44/0x200
> [   12.474401]  ? load_module+0xad3/0xba0
> [   12.479908]  ? kmem_cache_alloc_trace+0x45/0x410
> [   12.486268]  do_init_module+0x5c/0x280
> [   12.491730]  __do_sys_init_module+0x12e/0x1b0
> [   12.497785]  do_syscall_64+0x3b/0x90
> [   12.503029]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   12.509764] RIP: 0033:0x7f554f73ab2e
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 87382477ff85..7e2b629e885f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9412,7 +9412,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_=
qla_host *vha, int qos,
> 		qpair->rsp->req =3D qpair->req;
> 		qpair->rsp->qpair =3D qpair;
> 		/* init qpair to this cpu. Will adjust at run time. */
> -		qla_cpu_update(qpair, smp_processor_id());
> +		qla_cpu_update(qpair, raw_smp_processor_id());
>=20
> 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
> 			if (ha->fw_attributes & BIT_4)
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

