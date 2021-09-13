Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6102CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F2B60F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 14:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbhIMPAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:00:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55108 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346943AbhIMO6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 10:58:14 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESqOq024407;
        Mon, 13 Sep 2021 14:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f6RL8a8tukuzwUa+3WGH6W0xO7B8RYXO0O0G2sLhYOE=;
 b=oWrp8q8ftzlGY1n4Zw4qNre+N5H3Cx1536RunkEZWsPmJ5DrWr+Ujg/FmKvhQziII0LS
 ugWM2TCpUF3QKt8Vo2zaGnWF0qLm6TWu3jx0E68Gk/0UeruiEiZxY0F+t02i2e/g38qz
 ZUQ4IiYH+5HQSfLgKsTQCzAhGhoG0jJwNC2ADStdIv1ahfTx4CW9mOHG4zfjVjSRiC55
 cungu6SVtPmlhqhz7FyPvXi+xboevK434nT/JQ+P2MTBTYaK/8iaTKKrXavGg5qyGspW
 CbLch9jRsuwrwaF6Ae7cVsCexuMSYyqut3vK8RZG/WYCRI6iz+gCGCBtRXj+BQ2e2xCc dQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=f6RL8a8tukuzwUa+3WGH6W0xO7B8RYXO0O0G2sLhYOE=;
 b=fX19a7J8a6c6buJpZQVyxcdTX1TIh75sW1t+TG/rv+bNiYx+kwAiyEoVAFDF1drSHOAu
 0uDJnHw6/t2DCki+91KrvF389Cy4/6tBt0TT36StFzPFxU4w6EQV1r6pJwGFdSMczniz
 6haTWiBTjF13+DTjelYqBY0URvjl3CNtHA2tz30nYDeccO/KS4atMRl2VSdGvl+2LxWN
 dtg81OHHVi2wXyOugVMAmIIjZNNb/Kx7JMPDN0BcuBVdHBzR9tM6MsdHPVVECNL9AY1k
 2z0nq7jA6nDdP0wfptmanQWfEH97tz5JB+vABGpAgRrnwF5Tg564BFElkf7elEocqb6s 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1h45k27u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:56:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEuLP0010175;
        Mon, 13 Sep 2021 14:56:56 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3020.oracle.com with ESMTP id 3b0m94tthg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 14:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWXlyj6yzTQb0dGQl7Wpgs7wa82h2Wy+SoMHY1oX/8cF9JfKMcM0eFdK+rxyx5Z0OZEMBZQAEq7iulF5+hJ5z4LG3w4D3yx7WlNIxYOlHd4KZJ2MMBdeYl77UPGC+ZUG1H/s/e0xu/TFwNm07/rLZCHdhDtmxp1w+Vh/dJ5H/txtvyUPjgI8m6ZgKdFumG+WCEu+TVK1dMv2HiL2HFnwAJJaeiTiC632zVz4lVJea4xevK44jERJDBVJr6ZL92roYaaXKyShE+HL/UfPPqsK1wFW1XgO4j/dS7HoScKqRfYRVIHVeSr5Fart5lQzRfhmDCC9q0vrxGyle4oGEYvVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=f6RL8a8tukuzwUa+3WGH6W0xO7B8RYXO0O0G2sLhYOE=;
 b=JKGZYpqJqbH6SPZGZxoHyK1e5qnF9ssPskaAhN4CeoB0yylRMggBMvgKbxj0sBXUkb4z/ZNN6cuPODErd9OuaRIbD+0NniU+0sTX+2bSvRPENsCLs/nWISbPengLg+Zk5dk09tOHWPFjQxzx5JAlqjti+tmpuZbCEjJpbm6S3bvUuNqUc0cfHBiddQigkZGYEcFCCv9Zz7XUaNFcz2MArhbMT1Pbb01hJ8vp1jCkSVXiign3cpfLj17jrkPRQfm2nl9wKF5sIo0sPr6BOexv9KXdcyhyFdVLtG/xDKJrR3kFDjow78ZsKE/BDpzMuyBuNmS6yQ6r+yH/3ej/d6w8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6RL8a8tukuzwUa+3WGH6W0xO7B8RYXO0O0G2sLhYOE=;
 b=LC0en7mHlWv1SW5Uh+QpzQ9cCQHcAMa2dHg4pd/qcc/scf0/IIyor6b0/ICxBrh4Tw6f7O4a57HuT/YS7sZl9Vv6ypwYPJYnjQ8UtPffKYU7ctZYWafbuOfX8v2xg3PyhnIAshCiU2F+xCQhLKBYvLDg2Gngwp7VRE10cBtU/ZE=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4096.namprd10.prod.outlook.com (2603:10b6:208:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 14:56:54 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::f5e3:a62d:908c:e976%7]) with mapi id 15.20.4500.016; Mon, 13 Sep 2021
 14:56:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Li Feng <fengli@smartx.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "open list:SCSI TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: Remove unused argument of some functions
Thread-Topic: [PATCH] scsi: target: Remove unused argument of some functions
Thread-Index: AQHXqHm1T22SJlgZ4UujJ/ItcGPz8quiDjmA
Date:   Mon, 13 Sep 2021 14:56:54 +0000
Message-ID: <A621E579-9D72-4C26-9F40-BB132CCD5A90@oracle.com>
References: <20210913083045.3670648-1-fengli@smartx.com>
In-Reply-To: <20210913083045.3670648-1-fengli@smartx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: smartx.com; dkim=none (message not signed)
 header.d=none;smartx.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78b8a672-d91f-43d7-208e-08d976c6b9d5
x-ms-traffictypediagnostic: MN2PR10MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB40966E986135D40B9A47F622E6D99@MN2PR10MB4096.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtL45w2zIhWRZ726VDx2Qdl7T24Fz8W/WdlXBEBZb3k5eBd4HbeTT0f4N0ynhoUb9XcqJf/+Hg0G0/MUzdTGZHW0cAUj06QbD+4dZpCqwdnE4Rj1HtlpDLPsNDYUqz4FTJEEIIKsiC06hNQryV0zQ3pzSnXCSUxyjSuwdr6hh22J2jV+08LUiV4oc4tLxt1PXKWuaCnJnZJTplAycz/4e/EuJPChhtFIwJ5cGnzdeWaFtKVi9Dgb1gevmg2CVqi103Rs0OtDd26bUEgZVVtiy3hmO2KSYR6YQuCGa0+F/LwgPf5nPDIJCP+fect71dVUXNOvDRJx6JSwm8uGuDjQuCrUKf2nnH3Sm0bxcIgrrGVrbN8Vfdm+Tfj+eWw0k3MwGVehszxtEpO7EbftwmuezuClX1B2DAL7ztp9ay2gnZHdju3+jxIePvZ2vAgl6KvmClBk4LPD/tNRD5Ngq62ukq2hexGn5hse4Jd+tij4FAMsTE13+K1URiHz/2xTchMVdpeGLDXj/6WkxG+xpJ7npqIO7f/Mvl9hqKD7rwxn6JDv95Zjn9ptPkIcoLsJJ2LzelahTlXdJEXHw1H6gegt6zONst45ROk2X3+hIxBhW5yf+40lKhFFvM5FTB6AiT20m21XsoiXzXrS0222CabyeK0yg1j9fqv+WJprQBa0TPx+TO5/Yz904sCAaoGWFKrMqyEV8kzuErrFtowdxEtuLO/vVGJ30UD6oNuT53ma9B/5urN6sQsrzwRgXsmYz2ct
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(376002)(39860400002)(2906002)(4326008)(316002)(54906003)(86362001)(33656002)(36756003)(6512007)(6486002)(66446008)(64756008)(66946007)(76116006)(91956017)(66556008)(66476007)(44832011)(71200400001)(122000001)(38100700002)(38070700005)(2616005)(478600001)(8936002)(26005)(83380400001)(186003)(6506007)(8676002)(6916009)(53546011)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9pw6YTGPeDV1dMaihhpyaP8/JpOh7OLuoNZ9Pdq/2Nw73PuPjUiiNI9WAa/F?=
 =?us-ascii?Q?QfZfv5amtSG6JIYXa4EDB4c2Ha6CnkcWi7wek5eNgW7rY2iYH5wP4fCdWTJ1?=
 =?us-ascii?Q?yEoOlI+m4q5/cQ52ecg9PrUAa/tcWziqa6fYlUDTr1zBmhTRuTK0ORDxPuLd?=
 =?us-ascii?Q?HRGj5caLEhmKu9DSFoayuMs5qhPIjnGP2wsyzHMFjrZ2jWK8tMrTgth5QqBA?=
 =?us-ascii?Q?bWpgRT+yyIuIA/5siIUdcG6CgZuYJsSWaB+NbLahnGaoyxGH1NV4LF/JP5Ha?=
 =?us-ascii?Q?AAmw0POdOLE8j0wuq8MUUAEMWLs1Fawyo2QjP89BEqhAGvlw5swaq3jvkUfB?=
 =?us-ascii?Q?rzNWodDIWNGW4iTEKK7fxQhpwYGzCtl1ZimNlpQf+uiOJpLoGSa1//DXAXEQ?=
 =?us-ascii?Q?9yKBML/YEiD9HSdl8G7hwH2vlyPlDfSbi6+2uTkuU8TbT1k1j4D39hWaEK2x?=
 =?us-ascii?Q?diFRrO/Wv7gBBhXjRM028FWCgCOrgfMVtT5Qb5P4sb1DJfgpDQ13Zi8MFXZf?=
 =?us-ascii?Q?SmBOELr5qStD4PHjuaygfmtGH6IbF6X03OsIyX9o5aMjE88Ih9NNGKUIeI8j?=
 =?us-ascii?Q?6D48SRnapHLjO7h9+VV63cdw6LXTLvWsiBchYM/TEzBwFAg6+mAPiuSazSdv?=
 =?us-ascii?Q?oJWP8a/fB7xECJI3qshNY8Jx04LC8nJixVcVdSFqEwklQcvGuFvJCznftmoV?=
 =?us-ascii?Q?Upwttyl7uDeoTGAFPf2xavyhuVmRDNXGsAC+xDx9FEyLcYS6rJT1M7lyRAlV?=
 =?us-ascii?Q?MmO45ELZwZCSEF1oRnpBkqGRkoCBpv5pimgbUQzAeMeya4f6KBGu0Q5cFJzZ?=
 =?us-ascii?Q?zVe1QALgUuT5nQtbvjXTIfN40+MzIgHyCCC6pQNjRvEhc2v4rCbvKbiV6gva?=
 =?us-ascii?Q?nYoLJyVwYRNG977elw80lhAq6UO8tUW3nYyglBNJ/Y5QcVRHuYz9K2+Q1aCp?=
 =?us-ascii?Q?9lTUO4S+Cm9CBAc1mbO8bF86mzfGvS3hjITWDCkKUITnyN4pIwZyGnVzkzeT?=
 =?us-ascii?Q?49Ib/2+MRTicJhoQZ9R+LZ6Std7BuuVchtbaDTe3cPG/o5shFxa5SIp51/0k?=
 =?us-ascii?Q?UuyfIm07SjlcwG7VTNQtF2dg2dPf8B3nxnQ0Q5mT85yvTJB8MHJe9nprkcJD?=
 =?us-ascii?Q?OZ4AtYHVR/JQMRJZdxswFOOBuugSK2GfJS/fQ+X0BzL/fJ1J1GgkHrvugqnM?=
 =?us-ascii?Q?I95RaNMAmC/T5TwClQ1r1VyZuuyNw+tob3mox/PnfhGWr6BnyP5OQJ0jp477?=
 =?us-ascii?Q?aXw/ohC6TW8pwL+EeSWFKUvML/rd9HMKdW9qDrSTOua53Ktkyl90u1Nx1CdE?=
 =?us-ascii?Q?1YKR8z9fpjadHXSF+M1sU4rn8UxUr49iFHTcjianVG8kGw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1ABD278BE3566747AFC48D1964CF7AAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b8a672-d91f-43d7-208e-08d976c6b9d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 14:56:54.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fBtalyEdMPoUU/qC1PIX4hPvRG4R7m+JXhpsDz+2LaUfwbUy/whlE2nbMvKQ3qsY+xy4MFsEzhgeLki/DnPYHH+9hTt0Wy4LBpY1J85Btpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4096
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130099
X-Proofpoint-ORIG-GUID: i6gXFZsgwUaFxK5abRL90Vg6cUCmL57Q
X-Proofpoint-GUID: i6gXFZsgwUaFxK5abRL90Vg6cUCmL57Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 13, 2021, at 3:30 AM, Li Feng <fengli@smartx.com> wrote:
>=20
> The se_cmd is unused in these functions, just remove it.
> Signed-off-by: Li Feng <fengli@smartx.com>
> ---
> drivers/target/target_core_xcopy.c | 14 ++++++--------
> 1 file changed, 6 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_c=
ore_xcopy.c
> index d4fe7cb2bd00..6bb20aa9c5bc 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -295,8 +295,7 @@ static int target_xcopy_parse_target_descriptors(stru=
ct se_cmd *se_cmd,
> 	return -EINVAL;
> }
>=20
> -static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct x=
copy_op *xop,
> -					unsigned char *p)
> +static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned =
char *p)
> {
> 	unsigned char *desc =3D p;
> 	int dc =3D (desc[1] & 0x02);
> @@ -332,9 +331,9 @@ static int target_xcopy_parse_segdesc_02(struct se_cm=
d *se_cmd, struct xcopy_op
> 	return 0;
> }
>=20
> -static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
> -				struct xcopy_op *xop, unsigned char *p,
> -				unsigned int sdll, sense_reason_t *sense_ret)
> +static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
> +				unsigned char *p, unsigned int sdll,
> +				sense_reason_t *sense_ret)
> {
> 	unsigned char *desc =3D p;
> 	unsigned int start =3D 0;
> @@ -362,7 +361,7 @@ static int target_xcopy_parse_segment_descriptors(str=
uct se_cmd *se_cmd,
> 		 */
> 		switch (desc[0]) {
> 		case 0x02:
> -			rc =3D target_xcopy_parse_segdesc_02(se_cmd, xop, desc);
> +			rc =3D target_xcopy_parse_segdesc_02(xop, desc);
> 			if (rc < 0)
> 				goto out;
>=20
> @@ -840,8 +839,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct x=
copy_op *xop)
> 	 */
> 	seg_desc =3D &p[16] + tdll;
>=20
> -	rc =3D target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc,
> -						    sdll, &ret);
> +	rc =3D target_xcopy_parse_segment_descriptors(xop, seg_desc, sdll, &ret=
);
> 	if (rc <=3D 0)
> 		goto out;
>=20
> --=20
> 2.31.1
>=20

Looks fine.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

