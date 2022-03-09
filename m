Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D3EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbiCITMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiCITML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:12:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFC414236D
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:11:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229J5ps0020565;
        Wed, 9 Mar 2022 19:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=z85IlcG9Ieoc7RTN/+f2dddNJjqad/Er4G5wnuMJJRQ=;
 b=q+0+fOyRBGwhAYyrJuMNn8XBM04My7t5GH6tNj7KBWpKwcoJXLFQVYjAhRD+3r/bzkig
 xvQywjkRbwGJwhUEcuDbyDyEAa0AFoKHFvy8jGHX0r2ARIpbcSmyRxTSd8R0hBGjkzEU
 H2QkvefcI3j/zYq/S8+D3AZX0iUk+cwimR+K2WqAXHRlR8cQpMH4gcpMA65twkpWCID5
 NarHUbzc9P1K3dSp6lSJ24h6RDCJYG2W7eMbvsIeQLgE/xJQMhY/Uss/0SdMwYTc6JFz
 wCYVMZodUIIaK6UKIl7YjbAR7l9JxJ+gA9+nZ60Cp2HZ+m8v+jjOrrime7ZbsY/UXozf gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cjxvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:11:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J0UrI127393;
        Wed, 9 Mar 2022 19:11:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3ekvyw3mc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:11:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfE9+4nF8Z+ES5iwwpCrantrTxzIj5aaLZcCdlOfd9fvoXRQcqGRodoxROcoi0iHlSOxkYc9arEg5iVi6vn4sVt/z+w/87ZoONGSiyKhSJ+Xg5olfH1jqGgVEDWG4CpGWfUqV4Z7/HbYNmJKHbhWgZ87BhF4NDoW3njwsLSMmFNEW6RWMbHbxNehJUA7dYOBMkNdph1u3JHsVOxyWBibASLti1iBXzchsm+2QKj606jaZ+VPB3/lLAf8pvh6IIXMeojAPZRWzKYhwCBinNbHLUh8EMI3f7oZB2VEEu4Ezt7X2irwNC4oFeuu2949DNF43FoLc6r1k+xY0MjBN5GCfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z85IlcG9Ieoc7RTN/+f2dddNJjqad/Er4G5wnuMJJRQ=;
 b=RDDK0X2ytrRnXx669sGyPBehCwcoMKC3MsTjyeGwWMfyiRWz8tTYPBLuGbdX39tCabGL4F5kj3ravZUXb/hq22fmu/VzT34DDP4skWnYoYwXasLD6aYJRb29hAOzVpJiKSjQycI0sOIFTHjrBanbpKIk9LQQFYtySxlH5UEm0KaOoaA8qdAG0qoqQWsDfTJ7DYfcK8A4Bu5/FhQiKzbdAgCAw5jiCDjUmKIPUnsYJYH2jJEkJ0+Wg6Ew5q2p1w6nnfZ0/3jbbQfwFGEVnh98GTgaFkwKpjwnu4hRWu9fvCUEKWs4S+dafdvImDhhdCAmeeslVgXkEYPYnTsUGNEvvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z85IlcG9Ieoc7RTN/+f2dddNJjqad/Er4G5wnuMJJRQ=;
 b=v0s0I0j2GlQgRph2SXo0Q2esRmBklqLXD8G9SdU8K0mcJZ70HFK/LgU6fg0+CitIW/GFSDNzXCQS/Hh9ncPgmOv54eyGuzT7gfG2zFQQLL001z4tlHsm7MfAZjnQkOfF63LxTwVtvm4BWv+MRiBWTGwlpxa+adbRt+pzS+R02HI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.18; Wed, 9 Mar
 2022 19:11:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:11:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 11/13] qla2xxx: Use correct feature type field during
 rffid processing
Thread-Topic: [PATCH 11/13] qla2xxx: Use correct feature type field during
 rffid processing
Thread-Index: AQHYMsWB7HaYJ+E6BE66ajP7cc50tqy3bU8A
Date:   Wed, 9 Mar 2022 19:11:06 +0000
Message-ID: <C23CC41F-58AD-4D6A-8038-565E736E470F@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-12-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55d29c8b-6b92-4971-b0ac-08da02009007
x-ms-traffictypediagnostic: PH0PR10MB4615:EE_
x-microsoft-antispam-prvs: <PH0PR10MB461555BDF4D30710D09F21DAE60A9@PH0PR10MB4615.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lLGCllx4n+DzMLid8XhPgtJUny9zETfwnF+y9LhjXRpy7AmBqgX9B3kazuuGOrFPqw7Jk0fi1a/gtcft5a3cdX37yCelLoZzkhIdy3u3Joxuyaa/IGU5wi2dD4u7v6TrxwIIQfFsrAglavjZozD505axxqq2iLfBbyf19oHuIxqKaIbvzoIyrOP89QjcpNqczGDEeKD/qLLJD4w8ly2OqeJ7inZLXIdKavHD74RirHaOvJK8m/M0p2HHvWaXFuKCl8KMCUpDNXpKOyQ1M/nHdnDaaAkinu4zeBpZxyfeh/F+YUBhltj4KWC0iPEblWcThQbslTKlJb6Bco5FsdghFXPLeSWVpMiKSJiuPIsCDC4mBMuYZ6deoObl6FUGI/FGBuSp1UuUkqoliBbooqlOznkbFSuiawhOghmiyT8ZGlLFZKYEfTrM2hpQHlK6iWnes0s9254eB1lgBlicCCLR9T/P5es4oji28zkJeCdArlE10sLJRGwXxUUG5+dR0q0AshTsqCLR3RdlaVWBq3M72ip4ITQPcWk8b1HWU44XAATjPKPSY3u93y8gB31WtYqlKwyVEgxNCNil/jOdLF0rKiKUiz+iWgWj+hJdX0X2V3HrOW8o38A02aAcR2V2rg+xeJYApTX17UD4RyIpR89g0mdQKXHsOi2QvF3+tw9U6/Es3j+A4VBxJyJoBHt4IvuT0F+enxrooFSyAQ85aTULwPwKtq4XVbsrCbLSaEr1b54lbR7Kdq1o8MdHdaOicHwJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(6506007)(4326008)(44832011)(6486002)(2906002)(36756003)(83380400001)(33656002)(38100700002)(6512007)(8936002)(53546011)(54906003)(122000001)(316002)(6916009)(66946007)(64756008)(66476007)(5660300002)(66446008)(66556008)(8676002)(508600001)(76116006)(38070700005)(71200400001)(86362001)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HT2NeTztnjoo2LhXB+gRp+ZtVlQ1AinL9KBTIrkuGM5iSlZYK3bYk4RmWd2i?=
 =?us-ascii?Q?L9ej09Y4ufAzCd8oVMT1b81h4NJ6RaaLfNaF3qD0tg1Y2pb1CEvBabBCM8Wz?=
 =?us-ascii?Q?JBVS3fRE3dpEF0o1xu9afzO/UOdGwW3rGOC+aif8tL7VCTG5GBQsoSUDpKGy?=
 =?us-ascii?Q?LO52o+DPsOnWjGp2vndKJ+I/7c4TCZpU7XhtKOnH42dAXzOxCm9Pa3KO60Lp?=
 =?us-ascii?Q?3Qd4BUpIQDmufGalx7skkJdN4M3blbG4fnwU2IqUFjjk6q1e1AZNWB7kEG+b?=
 =?us-ascii?Q?RY/FuinYy1HezjsRbo3w/CEz8bR/+sHK4KafWSVX/qJ4I6Wfk36oaPelEXy3?=
 =?us-ascii?Q?utS07FpfQELky2sg0x6XFV1Sp1zC/kvBZ7JE2eTFjfZlw3ecnLH4PQf8igWL?=
 =?us-ascii?Q?RjFrclBkqEd+FoVtBnLG4K4CTVvvXduurBEhhYC5zudAbgvjy9VVzq2iAzgZ?=
 =?us-ascii?Q?j2FJ1uUstBbk5GiXV1yTQPS19Z9iEAWSaua8e0wijNg+s+5TN/xsdPQQDUTQ?=
 =?us-ascii?Q?uSYmIVRsXFaRaHCs39fcNE/vejA7yF+4I0Ea9iIZTLFR8v6UsPu67IYCwHsG?=
 =?us-ascii?Q?jjrJKbpskTFLFJnWckHM+LxNqxHd32dx+aip+ZEDAbWQzKXAqCdiwC4sCnVN?=
 =?us-ascii?Q?2b+sRcEvPm5Pvcy11+ZAPQv9FsVUE6TlmYr2nAzbdRU60k2PK+SUCzLx11os?=
 =?us-ascii?Q?Mr1ATUqzqHKxzHkeDOtTkyk1jZ2JPoYvC6w39cYVJJCglfrEKFPVHvHmVHAn?=
 =?us-ascii?Q?t6yxMzgPxRytzRFIdSFMRmBSUex2zxzdRrMhGVZF45xpIReSSHW4hfP5Ck1G?=
 =?us-ascii?Q?+/BPnt9uwrsTVsDZScsufCemxIHDqFYIUVAnv1OkMH51Mb6nkb3YEm81HI8o?=
 =?us-ascii?Q?BPOClYkh/9arlED5E5m2QU+mtjF4976858l/wZgaZFv9RoclsIgE5FLIsgee?=
 =?us-ascii?Q?bsw2wTQAUrpWAtgXK+GoqH7Ez/aHff86gMZdeNYC+L/RuUWpzzfJ/FIf3kOr?=
 =?us-ascii?Q?7IqwEnMvFcCXWx+Nc9L112YJ6OPqzD/NWY3ytFl82RbgHvdLghrq5iPml0Nh?=
 =?us-ascii?Q?bzdZkEV1FhoU9PJu9Aubqm/CWkb6yPa7kvuY7JEiyryHZqWzUbPf3oNsWIRk?=
 =?us-ascii?Q?FHSuGrc+VeE9kwXG9KDtqXq95v4rMkao76eQbT1f/BB6alzc5jYSQstTOZ2Q?=
 =?us-ascii?Q?5HnBqAPWRqDptq1jJuMjAYOsAi3fg8Gh9+kGX0MQR9PF2+qMjZeCHd5J7oAw?=
 =?us-ascii?Q?7G+QU64eZgHQJv3LXAZRk30nJeQuyQ20urAEVqS/T8/xChnDWIndMLu3roKG?=
 =?us-ascii?Q?JD/ndys5KxdtV4xrWjaxUpZ50vqwTmYvPytWL/RxVDT96ocghVG+FaYRH9ya?=
 =?us-ascii?Q?40xsPluUcCjFAw/ayNkpTaAlc3NL9/X0Q0v6d7ntk7i86aAHiLU/hp6BAFab?=
 =?us-ascii?Q?jK/6Y2C/K0NTA5XSQORPvNe18AkpTwfpKo9HlFTrRtiVwfEYiqq7hVxuV+41?=
 =?us-ascii?Q?ML/dyt2pYuyZG52mdBcke4tCYW/Q/cQrEXvHuUe39gnF+gdIxwb8Eu+USbQo?=
 =?us-ascii?Q?duRN7utto3OXfeDT4laTmVuKCccuiqlt/6eRTwbYa1EOe4z2WMQ5AaRnjy/M?=
 =?us-ascii?Q?3nVP2TYLoEoBw0cc9o7+goY/ooEcmxpFHK/dD9VivyJ/kn8Kay16AfSrT5e6?=
 =?us-ascii?Q?+EWV7iF0kIkGjsQp9yGbVue317E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5AC03320A151314E9E8AA9D5EBE15ABB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d29c8b-6b92-4971-b0ac-08da02009007
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:11:06.5243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9tWyBO6XXUHN3qZ7FroJoCNpaLt6QdmqlxS+OZVXVVcAC50jils+LpRRc4OKkA/RpvRHJn6DeUbwdqwxoYLxtia2XKbwkB++r621bvnA+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090103
X-Proofpoint-ORIG-GUID: 67K14nYGNxWTcIGwjnKXxXxGSXbY4Ziv
X-Proofpoint-GUID: 67K14nYGNxWTcIGwjnKXxXxGSXbY4Ziv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Manish Rangankar <mrangankar@marvell.com>
>=20
> During SNS Register FC-4 Features (RFF_ID) for initiator driver was
> sending incorrect type field for nvme supported device. Use correct
> feature type field.
>=20
> Cc: stable@vger.kernel.org

Fixes tags perhaps missing?=20

> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index a812f4a45232..6b67bd561810 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -676,8 +676,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8 type)
> 		return (QLA_SUCCESS);
> 	}
>=20
> -	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha),
> -	    FC4_TYPE_FCP_SCSI);
> +	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha), type);
> }
>=20
> static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
> @@ -729,7 +728,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port=
_id_t *d_id,
> 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
> 	ct_req->req.rff_id.port_id =3D port_id_to_be_id(*d_id);
> 	ct_req->req.rff_id.fc4_feature =3D fc4feature;
> -	ct_req->req.rff_id.fc4_type =3D fc4type;		/* SCSI - FCP */
> +	ct_req->req.rff_id.fc4_type =3D fc4type;		/* SCSI-FCP or FC-NVMe */
>=20
> 	sp->u.iocb_cmd.u.ctarg.req_size =3D RFF_ID_REQ_SIZE;
> 	sp->u.iocb_cmd.u.ctarg.rsp_size =3D RFF_ID_RSP_SIZE;
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

