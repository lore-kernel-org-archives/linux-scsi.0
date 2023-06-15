Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4619EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbjFOAe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbjFOAev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:34:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663D26A1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:34:50 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJemlM009926;
        Thu, 15 Jun 2023 00:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=F0Gr1BWbN1iGRirVkM7WSEToeSyF4RWIrl+QZ9sjT5A=;
 b=bBV3fOI2hC3s1zciX3JXx+sjdYaVCrwaE0533cnEN9y9l/Dxx7IK3GztPTSfdtzFrs7h
 oqxx8gr62Xz6bd12L2Q5DqfbNikV/s/AkLKfZCFmB8NVX7Y83V9BWixEnTqN9JJNN6Nh
 IAY+yubVAU9iDFGp+V4vkVsJ464gUoEQBd8zb5encL5PXsuJhiUiIGE8dwoSal9FCUj9
 CrnDheJgsF8mjT0cX2+THWa5Lm7fYQgCwyVpSlTZwjuopBQfseia+aDGgTb3ZjdcBT1K
 ykkJtY03b0ZKGtb16z4DJP4+VueLkyd5ImVWQgIDVZxKrgiAwQVh0lpyzsghBWiubsYE cQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3brxh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:34:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35EN4RNa016232;
        Thu, 15 Jun 2023 00:34:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm69nhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:34:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeHJ5fg9wERvNTPw0oHH5m4M+CcJFZ+185NPU5vgfskaYS6w2Kdg8Yr82yudsGqN01lYmaAqQ4S2fmYvfjRQe97GWIJFhY9ujTgIr2Z+7yrFTgyraPwAcq52Zh2pXwBEtk5w2AtF/MPVw0sJwZ6+yIIlefmpuqGrUdeU4lRWf6f/vHsTquhURRxSIJf/jAvP1q0jpHXTp9Y+6PA0WWAe56ia+oFBTqwiLWo01JgesQF5zirjdQNSpOrW5qDsPuvdl8VCEcFFawXFyByBEX9hRw5FE2ujnJytt4F0eje/kCs7ezsFr5z1EyimDmfBlLqNw2eDDjSi94Y9/B8iBqyDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0Gr1BWbN1iGRirVkM7WSEToeSyF4RWIrl+QZ9sjT5A=;
 b=NUY/XY72ugxSXFdTFJsj4/kcYpx1yA2HMiOCYRLvIpl+lBFXTnNZlpFn2JqtuJ1khaxgWUK/IHuRxHZ83t1TnvHrON6iJfZOYZpSkBw4I2OVc9QRG+u5D5bgnR6ZjPpwsEyrUHJ/U3rqyMLtvAT8Y1XedZnSwCDYqtqFncG4S9EzgizQD/mwzxbiY13vEXEnTP6zLJEujRqM5Wr6J8kAurceUBas7zXlga/dGJg5090SXoIoIIDaiJzKWTDH0QuasDNXEHSOr3b6KzLCe6NKzdiI5KzrCaePpwQVG3q2E06FixV+PAB+9xGaLhhhA6/tjoh6MuBFMaT6bbI5KvTDSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0Gr1BWbN1iGRirVkM7WSEToeSyF4RWIrl+QZ9sjT5A=;
 b=Yv/FvBme7cPuN3FFQOIdSOlYbkRo9Zid+KpWo3YfE0XNNWnyQIRqRSwSC4WXAjGGXkMTjHe2zMA8hYqnSlUvt31DLw9NxrhhW+KOZ891bwshzq2/c3oToQt9Ytmbdxnc8ZpRYOS9B70J4FIFiKSEENnQ/xE2IEXOudZf7fkJO4I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:34:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:34:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 1/8] qla2xxx: klocwork - Array index may go out of
 bound
Thread-Topic: [PATCH v2 1/8] qla2xxx: klocwork - Array index may go out of
 bound
Thread-Index: AQHZmTSnxR5gi4uU/ES7+t3YwkReJ6+LD+YA
Date:   Thu, 15 Jun 2023 00:34:45 +0000
Message-ID: <4712D3D1-D144-41F9-B1FE-66400AB9FE96@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-2-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: ece4f40a-4385-4bd8-519c-08db6d38514f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wk9lr0BUfbHK+OYxI/6MsYJIgTF+m/0qDYzyQamR/TvvsbaBiVk3ivZwX8n/CzxGtBBGvbMCjDXeGrPDYejlPJB7fm95N5dIWFvFgQMTX4CJ6zWLAt5opU2yvgKnHsZBPP7q6TbyQErWg7XtaxFykCINAGZKXxSjhCB4QD7cnA3diKBpAdmgRb1xO9VxKUyq4zYbUC8VTKx2oOoLxxYMBXLRW31+AAiTtYtudGnZZjRydX0S2wATDvAeUfun/ScGBQHdWW3ceTBr5o1DrnG9+NJouk5spM9TQMBBfmp2Xa3VHkJMy2MOf0i0hP2Zdg+i1Ze+7T7McU7ULgq8vxQgyYWUjMCUH8TjgZqwfoX6W6iMuqRCfBiclJPiWNecZvrvKlO9zS2vPEJeNr4JqkB2s2sKp69cfumqkTb2Zxt7qyn0aZ8zR5N3rl994V/Lq384szvt7I5/8jG6kpbezXOhyIXR8C25fiVMG7V4sQ/dehZqaArCYBrK73BrGS5kBGMnhLu3h4EasS0HPn+aDQaBZjMeAekMNPLo/n2g1v5IVpjopIzjntJ1GY+Bqkdxs49jPZ1j1j/5FVfsdmkrDCo+S3iJ/5L3YkADYROaHHDrUFPGwLvem4dQfDZgq2yr44qB5QdAbjjZaHzdMgh1j/QXFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vrGP7q+9bejXuDF52FLvKdhhEhs43G4dIt1yJhqOVMgIPj5hX7zThy7pcDRF?=
 =?us-ascii?Q?LE0i7wzRQK85t3eILB0QOiPn9y8dFvErul4lt6M31DmxXBo6u2P0MKDvSEx3?=
 =?us-ascii?Q?Tbx+E9IAKnlD0LRtHnI3y5BHYaNFNErQCIrknWc05D8d19Z1eipZOSI56i4y?=
 =?us-ascii?Q?vjFo24415w3YDgSzuPRBDdfY/2u5sUEx8REeFieqjp9fkOOX/UkcrUlu292Y?=
 =?us-ascii?Q?NeROyAE9jBfxfcFcik8sGQzzr58rMq/NvySB6YM+iLlJCZQtjE32JkmZ8NLw?=
 =?us-ascii?Q?XoZDF9SzqkzavsflHPeIA3lQNojak1busAVKiOX5hVgFujZ4OOI42XOvfmA2?=
 =?us-ascii?Q?tBBxEqx43JpcMjFez80lC4V/1PJX5mFsVXiuXnKsL0nTGnSzJr9VRYAko/0y?=
 =?us-ascii?Q?9TIfU8J3+PXys2hGvPUS2hoNoP4DIpddm9HPvS/Ai8YtFRZ/XytRerIfRxgU?=
 =?us-ascii?Q?6IeKuv9a9rmYueQN/RoJycktIh1UkspRPR+JyYofFh0kJtjvNIOJjPCs7f9C?=
 =?us-ascii?Q?DHzWi4C0+lOPsSLvSvRkOsz1j6XPJD2DhUryi76TA60cUlJs+lS9qdAGzcwQ?=
 =?us-ascii?Q?4h4s0p9K+f9v8THaelI3ukXUh7fudBiG+Jotqu50BQFD8THkn1sryU1U2X53?=
 =?us-ascii?Q?3uzikEAFyegENrmDyBOq1zSKgJHnPw59pUnRB9dOyjS+2s6BNHaKO9U+h+kf?=
 =?us-ascii?Q?4/y72R2qWDLI+SWBehIvizco0A+d2wAPYCOr0OwrLQ4daQSBeN7olOf8JLyW?=
 =?us-ascii?Q?X2APapQmrCm+EgFlt1FRdetKQKrW1jumoDnzbX+e08ekLARyC6d9EZpOYHuP?=
 =?us-ascii?Q?htJEK4WLhC4dvkkXhEbzTmvmPpWV/D4QMb9DYzIjx65sqP9zzvfH+KRQv635?=
 =?us-ascii?Q?uQW5buawxDR+SVX37Pq2vX7BuzGNXxWZmDK5K5XF//yRWB6nYgo7fjvUzdC+?=
 =?us-ascii?Q?fBgaOKv7EoIc6G3rZPoMGB0oOJ2Ft9HSlAg2MYUyoKxmM2SYgkfYAwQp/aZP?=
 =?us-ascii?Q?XY/Bi/UMG1Ek2U/5S2fIONfob9X50t0JmnR8a8+mYJOXTK+aHA/zBiz9L3b4?=
 =?us-ascii?Q?dLmQT41iGlSBto0VxOwPAL9YyoAdTZLmg4Mobew6gVrrxSk83AzUqeh2r8Un?=
 =?us-ascii?Q?LY787/bcflZ+W/F1MKbwKuHp1GXnnGMcP/CbiruCJBN8i5l9bToYFvCsoSo/?=
 =?us-ascii?Q?ZKEIuM0iG+mE6/VVGyo2N4Of0GO+fv7vjuGv4bNXLYwkh0dZF9nHvz6cZs6T?=
 =?us-ascii?Q?ZKlk3FIFOBNoTt53RqVgjkxHOJKJh96ru0Y+6h1Jxy22r5CCGlgYdPsRG6+R?=
 =?us-ascii?Q?P/fWfUbjdniI2zzceupmHbALQq46z5Rqz9s/mfBXKJOblPUGuIBqREpeKyqI?=
 =?us-ascii?Q?CL5iplxrrp4sjQ/qj0i34C2tnItmpe927w3JcYV18j/oTHz2l9eyULkdvsLQ?=
 =?us-ascii?Q?mWZUq3L2CMyVpSmQp5RN8JxGQZ6wFtfu2mxVcVMxwGVm+jGO/qeBriQqfCKq?=
 =?us-ascii?Q?Bhwh70VoxY2pQfk0MA4tpeTcPHXuY0sKY+hIW9DKsGlxM13Z3eUfStzEXte8?=
 =?us-ascii?Q?CDB2tQTwTDWXDBTYqnrkAc4Py4vIb29iM2wC6z2sf5bMD3TTMyPS/+gAi5bA?=
 =?us-ascii?Q?DQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DEEDF2B3531644CA19AC31934EE3797@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WT4o6VuQ9Jb1eC0wc8euXFQekrPVoaf0t8MF4fDeCjzdTyqE22ZsDnuwNQ+lWsHZaLiDNSVD5Raq9+KitDUa3iudl9EHNmjVrgyPm+Qa7VEaAdUOMnNABsz+7vOFjWB3dpkg8RBMXuHN+Vm2V0wqY9QWqW38S7GJ7AYfwFAjZXyDW6PnBeyu8szBs4e4m0hIe0l34+qh51OTq5S+3LJjE3oBDLP/R965JemRayF4KgWgCwG82bX5t+phLohKVYpE/bPIXQ4sKc7P665YED2fIYA/aH6zv0J/j+VxMDmktsV8Qw40dBP7WoiIASucDKUfqJA0xbcXqKj6cZqgX5H9vVAMzn7eqt8/3zDxs/T/zi9p9+RngJUwDX8hzp6hbNaOkfoazm8V+2JcJSnVgm7f/2FtRikPWfqNAzzPq97RWI6BZccLAsLdm4M/JOv+f0Jt5mtEgwS6nMJ05L2Pn5o0Gd6H0PjD9/56fSDujF63y4RkFHZCau/ejiJpZdGSfBeQkB3EEpnMnSn5aduEC8LwiBt+vQ72RVv6pp364p1V0Uc0Ydvi3Ewm7NiHO2WWy9TkLZYwCuRJa51eE+TwiRE6aWkdkS+zIh+PpczyfDI1B3J3p0VCywa4FmR4sDoWNVDnuV2kGTwZdjZZxP+LgXVaOWQ496Qe827WIjdKYuYbHbaJmKo91DAWExK0Fm27O4GayJd+myplbiypJO66nhbc+7FSxxvPyGO4jbpQwDoH57Si/ELPIIqdZKhe3RhTIKcOiDPnbkNr8uObWGoMMmbypI0jRiZFxsNGza8eV9rXCsg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece4f40a-4385-4bd8-519c-08db6d38514f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:34:45.2397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9WvioHVCc5ZwdgQMQ3L9yfzq8H62O+D3GJxqZXfoXUQJAM/zBNYTfAyW2eo8cC0kGtxCi+YfuhaDf5wQ8nbFL28Yt+glrG4uRkqf6mP3Fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: JFMbXz4LS9BpAWEaP9yw7P7K5IXWwV6P
X-Proofpoint-GUID: JFMbXz4LS9BpAWEaP9yw7P7K5IXWwV6P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Klocwork reports array 'vha->host_str' of size 16
> may use index value(s) 16..19.
> Use snprintf instead of sprintf.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index bc89d3da8fd0..3bace9ea6288 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5088,7 +5088,8 @@ struct scsi_qla_host *qla2x00_create_host(const str=
uct scsi_host_template *sht,
> }
> INIT_DELAYED_WORK(&vha->scan.scan_work, qla_scan_work_fn);
>=20
> - sprintf(vha->host_str, "%s_%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
> + snprintf(vha->host_str, sizeof(vha->host_str), "%s_%lu",
> + QLA2XXX_DRIVER_NAME, vha->host_no);
> ql_dbg(ql_dbg_init, vha, 0x0041,
>    "Allocated the host=3D%p hw=3D%p vha=3D%p dev_name=3D%s",
>    vha->host, vha->hw, vha,
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

