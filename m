Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB7BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387337AbiBHWW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386277AbiBHT62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:58:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95208C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:58:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218JIk9L007539;
        Tue, 8 Feb 2022 19:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TO3E4m7OGX5Jl9Hi03D3k22FFllWqtB5kXruKB6PdY0=;
 b=YXZYdLUF2sUrVZo2DyQ0wqEWwpAepYk/c88UTkK6oXhCj3ONXpK9AAthEBRuGOtQ36dd
 WsfXjzVhCkI1yJGYFhV960iqjtnVj5lj+Fgc//JCtrfFy9V6Jfz/LAIOEqEiai8KE4QG
 1UUeiUENziv4qJz1i5Hs3YJe3B/beNu+otCtuhPz3GBw4RVqEoUQPW9AFR+uePJal4tK
 n33vc+pe/sP5aGFY2A79Gced4FoevA+SM4DFDVOw8pkJltAxvK10frhcxqvMBao7UWTR
 ut7VVVbj1gFXBuraKcVd1MlMmGq2Q3OjxzeHLXF1EVSXz40eKMtjWr7JaTXR4IZxsdC3 DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368tuu4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:58:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218Ju7jw154808;
        Tue, 8 Feb 2022 19:58:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 3e1f9fxujp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSoVTpBvjTkrcCaTsujeEycguJuSNYnaSxxTjTZYvunZsWyhJUyezG265AvlQnqM4Qv2c+BeYeoTipsOL3ctWoNIJ1X+f2SP+TZzfvEdyhMG9B1PEuRB7vZgC4y+XoYPcM4XLeBxqwfLxHNlXjt5MOqhXxUG6nfrXpfqQOb1eChIhXhnaVIExNMWYxaIhLgHK8jdInifZrt4mFTk0sI1BJG33pCsI3MZEyNxd/WUad4UGzYTcPvS4p7DT234dXFC3tODLvyNqT5xgwGfzAKtRuP1DdTCEaFNwXVA08g8tLRZ6w5itnatsO8VRcCO0dyuFi8Wd93VOLf1qLV35fchsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TO3E4m7OGX5Jl9Hi03D3k22FFllWqtB5kXruKB6PdY0=;
 b=XjZ2bJWRg1Wu1SQKEiRv7FCKTXLXHm0m05BOSjjjWaCRcCCGEadKXuxyhjVEYBsPUZqtlnxc0Y92JnfYg0remEDjNomXCL5dEIHxhdg+nStxGFWosFkJ/PA28VXl6NX3sx++QmqbgezvX9t3Dp9OQgkBn3Y5dMahpLYvsPMV00czoCHGRkTIvTDM2WdeZrJcJCsJ4dgjYfagcrl76t0ueii0zO9HNTLFK4zOkvmOOLfxriQLsyx+1UJ11ZkkJ0psuq7vdxnMo+qTgcSl4Q4gb5g4vfF1HUoBzgYBwEQ87Ma6EhvpacBftlFDK18VFARGwHXKQX7ZJUYZGXwhx/fIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TO3E4m7OGX5Jl9Hi03D3k22FFllWqtB5kXruKB6PdY0=;
 b=rGq5PaeGk70/4s6pyO5PJHW/Swr/rSorIoP0wG9S3sxoqe9g+igzupA19WCr2r++0hUBeyRgvCjtNStodKE/yNVbm07gkrI8afz8fqhm0SzWNCrrxMgSYae4ciTfBZbFXpjRySuN5PZUGqEdEvX5VAFbrv2c4wx3BItZVZ2Q23s=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB2677.namprd10.prod.outlook.com (2603:10b6:a02:b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 8 Feb
 2022 19:58:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:58:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 08/44] 53c700: Stop clearing SCSI pointer fields
Thread-Topic: [PATCH v2 08/44] 53c700: Stop clearing SCSI pointer fields
Thread-Index: AQHYHREot4pWXbQ/c0maq+0GqllRZayKEk2A
Date:   Tue, 8 Feb 2022 19:58:20 +0000
Message-ID: <639D1BF7-D14C-4DCD-A342-218108CB377B@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-9-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffbaf4fc-3f90-42ab-46e1-08d9eb3d5b2b
x-ms-traffictypediagnostic: BYAPR10MB2677:EE_
x-microsoft-antispam-prvs: <BYAPR10MB2677CD668A1C886C154A3FD5E62D9@BYAPR10MB2677.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j6L39AnE5/H7DdwoOlPGlt8gr3NsNcJU+899QmXbXdQWUxqqlVoGdBdRmtQbMlRhYb3WZ32kULZMf3+/a9rFt6kE/f4r2/b+0m35Zhz/8VDX306HS6E8wvWY22G0n93XXPalJS3JUeeR5YPs+/uu5kQjXB//DgpIomvpBCjZnyBYxNsmcTWdIDKhLzkbmYOpuudD52Sn6VyrlcshGsAw7THG0Im07jy25AviHqs+wRVJugS88AxC/GB4cKyRvSu/BRUIg9xN7VS8A+YcXGhNr3dHDxef/k2Lpx1Ybdz4B4bV/NIdUFrIrNuDcc0dMBHH9ji69bugNekMilkrMcEJkxCsdpo8fYMLBXVslWM6+iPNdv2hxV6jXZ/3QEQktY6oiBS1YYN0SG8r43MFIyz3Bqba1ViwsdLxpLl+iiVLMzUPxZM60M1RBGiDEiHJCatWUi3NtDnPZoYkIxM/3oPI0ITyFQMXVGdKiqOs3nIjrculxC0j37I3vBGGnqc04RgIYxcwl2bbdyGilDqRUMDuLO5EWQBf7b63t8QTEciUgxUFQUBWSQXCEYSap61s6K4N/HWWodM1AP1IUdE7JMMLoi0yltUsLgQ7RszzAP0Godz5lIc5z9xrQQn4JUejHDv1Yd6kWLxa4oHfAYo1Usn0pSmyXjyrRs63KHqHyY3ckbMe1gQ0NSN5Rq2RbhBQGdOqo62R7jAaKDGtNme2tzYEb0jIHvap/7HIi+ReZi9vrESWDNMUVc8LA+LWc5LNoIun
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2616005)(86362001)(44832011)(2906002)(6506007)(6512007)(53546011)(71200400001)(122000001)(508600001)(33656002)(38100700002)(83380400001)(186003)(26005)(38070700005)(64756008)(5660300002)(8676002)(4326008)(8936002)(91956017)(6916009)(66946007)(66446008)(316002)(76116006)(66476007)(66556008)(54906003)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+B3BZaNg6r5OnwoRW5AJfQXGxraW81EbnFoaFdGJoqvzKiq6BVqTmulFr+xz?=
 =?us-ascii?Q?AtVk9rqiTJRM5V11pU7cZkkagZxU6Z8qgeK/4oVfZBzU5LibqZVB2rvgvz58?=
 =?us-ascii?Q?ylh2yarJ187LoSx6EqKYGHwaliYW/mA7GXRpQ2/e+JgWIXlJsTAatxVttnZc?=
 =?us-ascii?Q?AjeBwfSyo0qwIGQ+Eh7fS5LhKmm/TyNhlMf2wfZ0crRsvlgiMHDJSwCjojSA?=
 =?us-ascii?Q?cmPSXsLRZuujoB4/PRXDpAz+yVBWsHihHRf+z4Qf+bUR1Xk2mPdvS0ATz2Ov?=
 =?us-ascii?Q?vev0ZLlPlDYDl/rotqnEijw0U+y8Q4GK4lnBOQ8GjOSVqkkV20CtgHwLYvgZ?=
 =?us-ascii?Q?/RpGnRcGWpQrvclpshp/dyOX7sIV2qboPOkVhdgaP2xAWrRHQaG2SDXydTRJ?=
 =?us-ascii?Q?yfTP4iKCf4osIHxdoS5Qd4rGpMcNErAW+L+hSa/rIFIqvo//RJrTwPKRFzXl?=
 =?us-ascii?Q?5V6QU+sHh5/HWSU+ea18SJW08vmaYkV7SeHD8gA+b+OurJ8t8vSJ92u21U4Q?=
 =?us-ascii?Q?CX9RqpfwZPQQKC/MX0++q6nJz95dTqMvCYLieWgB1mlHnBwFVHJ33ZqEAQ6O?=
 =?us-ascii?Q?lgJ00IglyoYEk9mORpJzFGRPEPnpFUQ9GAGpkd5kgbYtsJTj2P+p/AQDkfGK?=
 =?us-ascii?Q?QGz919dDAn9T55T/6ih5zE+nAV8J8uTSt6WW9sNi+WGACMDourje1GDcEfxB?=
 =?us-ascii?Q?bdeGd7mmA5EkuX7a5JLC/bMogGqmfMi8iLOdCKUAnNznKPLinEe70RMUFZi5?=
 =?us-ascii?Q?b7Cx1KKNDUB2fWg2fCoAvdfv6qbb1SBhJYqWh9jgBKiAeG07M4EtrL7K+oMv?=
 =?us-ascii?Q?sZ+vFt7inw+P/4OFf4JD+gISDILg3m0bAk2nXKvYZndYqzlwKMWBbCZvM+2b?=
 =?us-ascii?Q?AGb4BsLDKVxK7PuIy6NbCirzDw6g61VG3dACPEzkT9/KPupHTQezxIWqfq+x?=
 =?us-ascii?Q?zGQ3zowv/9AmM3zwIKSK6SXWgGSLCh/DFsY57d66CkaSIppoWZIUoiHc7eUm?=
 =?us-ascii?Q?GfLF0zsGVp2MQgOpmNOmv8otytSEjcc9reY88e6NawniAhj7bTpHsfm7V6vP?=
 =?us-ascii?Q?x+PP2qRCZ8JNoOIVwKqv10E+TueldpRNVCLwYV0TIen8hN58JYjwTkwq3VfU?=
 =?us-ascii?Q?sB44y4sx2TaKr3EG+3epvgdaKO1TZBYcLuyFW1+/tcVsMeKFsEfC8JviXAX8?=
 =?us-ascii?Q?dgt4RnwqQGrXcUiQXRl3uTc5pjPDT9zpgDifwGh35AQYDdnhRQfVitBl5TII?=
 =?us-ascii?Q?BKyuFobfqWCbQdCKFmGUWbjOk47WmaVz2TSIwLJfGGeNOPdwQ7oU+26pxmxd?=
 =?us-ascii?Q?vkiHw9fO8xtuCK37oEm+ACqrvQ/Sni3auzgMwikprVn/M5ALXDhk8T12pmFs?=
 =?us-ascii?Q?8g31rIsa6zV/q+yFU+geOETFyEaQ35akWkvYHMN28KiBHSUT2e3ZtkzRW+XB?=
 =?us-ascii?Q?fue+G3LrN0lItg7QRit2t19+UUX+dHBKCgC5zPpFsEaNNil+84bppfEbqi/7?=
 =?us-ascii?Q?MPRY68c5T9ks/qObuhDsflMexS2NSZXe7QMaoxG692tzzC60UYJh9tp8K+Ns?=
 =?us-ascii?Q?LdwkR/fT/7BwnuS2/Sxlov/S0fDeDlP1g0pFmgkvexqNyd9yx2Rb0XnV4x5R?=
 =?us-ascii?Q?k4Rcit2AF+lgaJa9mDYZ9++z/QEk08rup/qMT9k8wfV9Vd55BHBhYjWGiCFf?=
 =?us-ascii?Q?/M87hZ7lUbiAHbao5+KLRoXR7io=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FF58612B19E2141A2F81C686FDB6BAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffbaf4fc-3f90-42ab-46e1-08d9eb3d5b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:58:20.3481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzn5jonlhTY/lpsZph9jsi4ePL9e4Ci/BGBryQr1D3PbgGWtdwL0yVr4kEYtuQVTK562DpdkyztjfELxBWQHBW3fCKJiArCedfULk/Piwao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080117
X-Proofpoint-ORIG-GUID: JVVdqCSd4fFmZoFlt2u1vWt5JyHe8FNr
X-Proofpoint-GUID: JVVdqCSd4fFmZoFlt2u1vWt5JyHe8FNr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> None of the 53c700 drivers uses the SCSI pointer. Hence remove the code
> from 53c700.c that clears two SCSI pointer fields. The 53c700 drivers are=
:
>=20
> $ git grep -nHE 'include.*53c700'
> drivers/scsi/53c700.c:132:#include "53c700.h"
> drivers/scsi/53c700.c:153:#include "53c700_d.h"
> drivers/scsi/a4000t.c:22:#include "53c700.h"
> drivers/scsi/bvme6000_scsi.c:23:#include "53c700.h"
> drivers/scsi/lasi700.c:43:#include "53c700.h"
> drivers/scsi/mvme16x_scsi.c:23:#include "53c700.h"
> drivers/scsi/sim710.c:29:#include "53c700.h"
> drivers/scsi/sni_53c710.c:38:#include "53c700.h"
> drivers/scsi/zorro7xx.c:25:#include "53c700.h"
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/53c700.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index ad4972c0fc53..e1e4f9d10887 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1791,8 +1791,6 @@ static int NCR_700_queuecommand_lck(struct scsi_cmn=
d *SCp)
> 	slot->cmnd =3D SCp;
>=20
> 	SCp->host_scribble =3D (unsigned char *)slot;
> -	SCp->SCp.ptr =3D NULL;
> -	SCp->SCp.buffer =3D NULL;
>=20
> #ifdef NCR_700_DEBUG
> 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

