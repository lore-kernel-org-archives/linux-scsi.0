Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA681C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiACAq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:46:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30488 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:46:56 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20298QCT012098;
        Mon, 3 Jan 2022 00:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4w2/ZWZnH9fVXmo4AXQPrj6yaezzVKTvdebEstwQDNY=;
 b=X0g7NcbyANNaey/hlAXCvcht+ECCK0DZwzIc3BmiphWK13vNvG+aGixqvau+XXvQCJuU
 VOp6HE/v9oGBko/rlGEJV4TMsIQ+/QMEsye+ky/judJ3KeDUUQADHHmGCHJnlsFIIaQv
 GV/qxk5/cwCsv84hqd4SbXOLOicM/hFIwM32bxFm7AY4syZq/hG3PQHklamlBbbXWSE6
 w5mz3kLi/LeyUkbWcjGuHtSDpYqFXNwBspuXKEEiUZ6biZB0WmtGcjNAyPqyjmPiUCl1
 gUvt5Aqn3hEf/zN4z6p7wJwkzsPwDMSgddJ9nBNVDAPj5R3HMmDnDgil6BCpQO9n9L2x eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadr89qjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:46:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030fldb118605;
        Mon, 3 Jan 2022 00:46:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 3dac2tujft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2I9nq8RAAQ/dHj0qoYnKXuKQaWVZ504EL7KTUFB4UkRBYuKQlMUr7XjcZHA79jywAACYIP/aayj/pvNc0CGC8PTwoUG4JgL7PGZ29Uv3PaVRp3dMjeFOezf1KmW7dgZwqolrEs/3/Tkst2RiZHsdtRuBfeLT915WDkfkfW3gIhZpUV5UzwKUq4jdYlwJB3sA2suouiX4Gp3flmpQdrM+ftwroVASAK5pRiBNIe4NvzfRRJ2ZgYB1zLeTJQpI+wrCdYe94+W5MpXOStKgv95OdaeqaiArR66p9YAbDW/Lrwc2gV3Jvbo+2IJOyNkGC4ZeFCZgKuCaeCeZovOem84Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4w2/ZWZnH9fVXmo4AXQPrj6yaezzVKTvdebEstwQDNY=;
 b=YCtuDYN4TEQGs6r6+mTX+sDV7XKCfdQV701vHWDN1SMWDwgGJ5E/hMzr1yfztmlqN7/uhcCdt5tAG2tVhoNQgMl2yp5K6Ob8r/mm980r3W8bEnpRXxSGo+ixtklEmvIM4jTUnYtNkMhW5YVrJ25xjO05pxpbLE2wTVc7GG6c5vnZOMo3SKU/lj29YF6+eYyERlMrTdeAgpKIQ+5Jb0bWtR6S9AKYf/irWpyWlQKvHZEaV5gTNDm0xfP1p5Bh8RUrhc9GpkKuSYbb+WOxSRwAp8KQ8ZQNjerYy/e4HWG+ec719RsW/Jp4FZHhzpTWn5yIy3ttU+2h+S/xirDgNm8jIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4w2/ZWZnH9fVXmo4AXQPrj6yaezzVKTvdebEstwQDNY=;
 b=hc0d4Eq30Kxm79LUxcmXsIrRP0Eherw5i9kojXseXK12GuYydrPqic5ADFLdcbPp4+3I8bV+9BxTIKrGRKtFp9+ATK0vtplSQQw4xbkyndD3yvkfXEbaAgcj6+JO87MkL2xK8P6Nk5D/dq0RFMRXofHEr1iJ7eer2ZZnGhaTTiU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:46:50 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:46:50 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 11/16] qla2xxx: fix warning for missing error code
Thread-Topic: [PATCH 11/16] qla2xxx: fix warning for missing error code
Thread-Index: AQHX+JUEEYnu4xOv40eTH1t5C3odBaxQhZ8A
Date:   Mon, 3 Jan 2022 00:46:50 +0000
Message-ID: <D95F4388-B3A4-4697-9185-241867ACF3DB@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-12-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7480f35-efe9-493d-3814-08d9ce5287a8
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB57100418D6619D1864BFB58EE6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KR/TV6bbBPlcWg9il1FZ19bIqDX+oxzVe3mmWzf30PuooSpgresvDKhzwp7cZMn5SjjI2HxuCsi2VXi/NIWNhYBWj64XQb2fChZTxLdh3693L++E2STF/SGSMsZF8ox3+Wnd96Zz9BoLD4VCQtV9imvfoCa7m0YBLpc9ybgATiw7gbxEtF3jYewuZKVl740JXrTv+n2hObq+F6w2pyrQxCQGcB+/cou58bYB+1QkfL5/MRjoWHbSqBAw+F1NmQBUj+ys1MsdYXTsFL35OSixC/kqk0A9aRwMYfzdBGcsRDDPr23u2SIfuQMc4yhZ0kwn3Jcr/AHrWjNemz1TePX78ubJKCOsEdOhHtOomVYQ50VYFOhvx82G+DxM3dKtGv/T/0sbay4Rcfhchs5o3CvAaEL51lvn3uUiPV1HggQEdYPAlHC33OFU4F3h8sd/Fr0i95bK3nKLsBBeqUvwSENYsb1PymOP502pTh3Fh2jzKRPxS66o3Amgs8hSfS5nnVqx3/Dlkpad+G/NXF+ZScxc3G99UKCQp3hgZ1o0nRZs/S7p9aPiqabZtGf2wYovyRPJtbFcsV/2CASYGdhDTeshaXNIV2pPSzZzIf5gnGoQ2UB3R0earQCWofgJYGO9n3RGvqTpfMu7vUTVWqh5TLfzrIJra5i74PkGEj1aPXQD0P2F7ROzoijs79ao4HtdFjPd6EWHPl2vDAyjY7DAT6CCwwIerzlPEPinnsi9hThqJQw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(71200400001)(122000001)(64756008)(186003)(66476007)(86362001)(8676002)(26005)(2616005)(38070700005)(6512007)(83380400001)(316002)(53546011)(6916009)(6506007)(66946007)(66446008)(76116006)(36756003)(44832011)(8936002)(4744005)(2906002)(4326008)(6486002)(508600001)(66556008)(5660300002)(91956017)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gv8/LIf0FOrfESaunRtw7XsLmk2KIe6en9/NvfUjPcxOGjSBIb3nTXX5n7Ly?=
 =?us-ascii?Q?Pwcbu1E+eHlXyIfgaGpd73RKeu7Qr4xhpMBOELnt3ndmro2zWUzpxhB9DfkW?=
 =?us-ascii?Q?DCzBMPk42R47QwMvoh1dPmbIQEisB/gkxyd8JUBXQYq9O9SRl/1jlQet9zkj?=
 =?us-ascii?Q?PJpuoNCcenH2EFj8HmfsCHOH1lsRY4Bsc8P7B/d6cj107JfrfiPE/g0m0FzX?=
 =?us-ascii?Q?+4lHRqBHW7O7ILkoTWXIsPqs59L715RCJH+GQObiOdogY2+QBolw+VcG5uC+?=
 =?us-ascii?Q?/sg6q4Ga+pCwqsDLVLE4YSwkTH0f2T3S2Frh60+09gRXTxsZWHcLe7WIZ6td?=
 =?us-ascii?Q?LOX5yMp1JdBzWwRXgfBlrb8XP9O0LDqcrcXojLigL/JAeFVhjdPACbuTues4?=
 =?us-ascii?Q?UPq2WfIp6sK5VzxNqBIIehbj306yu5uI2V9rOzEwhzRLx6ELM3aL4t/NFdue?=
 =?us-ascii?Q?0N8Knafq9LwTDS6pKKTFLe4AHR22Sv0NGdNuO3OexHogHAFqEWscw+llG3Lp?=
 =?us-ascii?Q?fUn0JV2JZBFbRe6Ubb+c3iKD3YFodQtqaOjcEJJEQ+whAEO/rH1XT6SL8FOR?=
 =?us-ascii?Q?TNK7uHKoI1SfZ730NjaeciYNXkA1P2BZLpeN7QnkpMiaXEtVvOEEiChLSU3r?=
 =?us-ascii?Q?0/eSkrZQLEcj59CIlpd5QvRdYQ1JObuqGa72ZTKi+QymeGXxpgCY9vSvkZmm?=
 =?us-ascii?Q?+QhEji9IMsMl/wsvhOYGYLK2RLVAYh0b1MtlpbdKkk1OhUHQ43WiMhjhOty2?=
 =?us-ascii?Q?zP3425BGUD8PIvUcdNhXnOSY8lTj02TN5Pok0w1Pfk4Yj1NroPKfEos/oXjt?=
 =?us-ascii?Q?i4X6Jae5D9rtXUYGZgvZ1z5kxC6m4tKfs35yVbAbifG30VDbvkiJ6cpO3jOz?=
 =?us-ascii?Q?KGkOcinqW2QGiBdw89o3smRK2CKI3oPT7lgsgxwjOiHIcSpEaZ6JDABhJgSh?=
 =?us-ascii?Q?4gcscz4DC+9PYHezkW0+WdU8tDPXgjOVgpldFT0+iFhzh1ACulonZCF2bstP?=
 =?us-ascii?Q?VSUOo+SrM1dyATjqb0DPwdzPibkOuW88iYZqO5tD2pnvkW1YG/mrIAzx0cuc?=
 =?us-ascii?Q?avnDwpDdlZcI8zfgJ/2LypEDBtJuTe2Qk2X9KHgCjsuXVjX6PxdbhMFNtP08?=
 =?us-ascii?Q?htA63dJ8F/Lm56coAOnIFfIWuL7pZ3O1kqmCKU5evIrfzQXBz94y5jOjDd2O?=
 =?us-ascii?Q?/98iry/VNqlPWIqNizZ+zywDYGIAtISDiC2DYFj9vsUiykZwHJR60tcGSuTN?=
 =?us-ascii?Q?QFIRP0NNPYEs18b8e4PYKTCUwfFikwfmcZKZ/LmyIYBB1Y40d4Kqs+MGT4j8?=
 =?us-ascii?Q?/4gfmNgKKtyGiFc4VZFB8K/EAiP3tO40X/5TEQIwOMh6EgLJWzrmt0qbenQ9?=
 =?us-ascii?Q?Mfo/PvbQixalVi7IOFg1NB565BlLf4ev5cy/ftLP8JIben2YelzYEVpEjIyP?=
 =?us-ascii?Q?y0I0ms3eexwlLnft+PGDDBSV4j4or6uP24ZMUB4UqZG3nsF1JUk75LKuivtN?=
 =?us-ascii?Q?NxOCpg/OJEVypyOQGULWxp5HUvzaAYZal5JVw7XMmscZJb1elaDnk0FFGPDo?=
 =?us-ascii?Q?Xfu8o52Z4GWWmmkQOBPKS7KebXX1q3mqq8VsEc3bYQ9TTQvWjOSFmEot/QbF?=
 =?us-ascii?Q?c3eDwB+Kts3lQGyUOj1KJMWfu680sK7JRIwRjR5S9ZX91evvTFe1Kvi7qbdu?=
 =?us-ascii?Q?3dDvU2uRYp9dLxxKigPOUP5JWYQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC5F5950D8C05D4F8042E0C20973DD1B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7480f35-efe9-493d-3814-08d9ce5287a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:46:50.7599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Tw/KytOVgAL8sD3UcV1T3bqKcvIuDzniKuL8ddDWGrpvUvywWK3SFO1HxwAdBlsSJP+liBYqYsD1kfoOe4FIYehXXydftGK5vnmQJYYBuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-ORIG-GUID: Sj8rv3Err_dhlShq7-6p0bgUVX-2wF0i
X-Proofpoint-GUID: Sj8rv3Err_dhlShq7-6p0bgUVX-2wF0i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> The smatch reports warning message,
> drivers/scsi/qla2xxx/qla_target.c:3324 qlt_xmit_response() warn: missing =
error
> code 'res'
>=20
> Cc: stable@vger.kernel.org
> Fixes: 4a8f71014b4d ("scsi: qla2xxx: Fix unmap of already freed sgl")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_target.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index b0990f2ee91c..feb054c688a3 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3318,6 +3318,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int =
xmit_type,
> 			"RESET-RSP online/active/old-count/new-count =3D %d/%d/%d/%d.\n",
> 			vha->flags.online, qla2x00_reset_active(vha),
> 			cmd->reset_count, qpair->chip_reset);
> +		res =3D 0;
> 		goto out_unmap_unlock;
> 	}
>=20
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

