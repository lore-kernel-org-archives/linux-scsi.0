Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095BCC433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2F6619BA
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhCXQDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:03:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhCXQDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:03:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFs1qr135258;
        Wed, 24 Mar 2021 16:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9yuXAANrrufrr93ypneAIzSMJCd+jd4GsegRw/FQ/sk=;
 b=QtbUVXEikIvflFmm37n7NghGkTfkJ6bhL0Sn0+qc/BoBzKPW2P76xtbDUqzaZyibPcIL
 ZZ0zXkLl1t5YlPwie3+UI1XleLoXEYMICpN9AozJ+hHhbd/M5vSLywLUMXSfeR0OT29z
 Y0ZAKyyx2fc2h8jDxxl/eW56+kPPnMqL1tFHbBMq1a+/nu1iUjCRu8tmPKMVG1Vrucp+
 EZ1SqTLhPcYO/BjIHtPkyvtEjkSQtrzVk6N8QTsGY2BrmvbZWYsHzA4DNoZwxGh8WRJ7
 q5QyszJ55Qn56KZteY/b2UsNOCbhVQUDeuzYPNKAKJNbFXyjL7oUJly2qaBgkpJ1Ctrv Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn38ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:03:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFuTUN126000;
        Wed, 24 Mar 2021 16:03:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3020.oracle.com with ESMTP id 37dty0ruy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:03:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzA5t7ojsI/VEQUqnm15O/7VfTKQeV5KUCtzybEAkSNeWrUOTqR7mEOIH9uTkjbyFeXiHBQwOUEpMnC/3wh3pAUg1XFXo/ncRyw/4TYocpGeb40P7rkyS0vEeDtFuL+bw8zV4aLYQY0OYFNKEEtRS09mP+EkZ+4GGxzzd6i7Nad4fRbZ1NeXgO6b1+mEVbyifR0gySAJyBR9SJrTXLNCuxnD1wpgzaGjpObCwU5DNRjHlQ1jRaU8I/rjPIJA2TvQmi3VYltOS098m+bGfopHG8uWZ7ZRvOq0Z10/uG32nBP0st3NxcQF6yyLLGXLQkGg6nwzx4hD9SJA9tL3CxTB9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yuXAANrrufrr93ypneAIzSMJCd+jd4GsegRw/FQ/sk=;
 b=neyXY4gZD5Z0FNDrcDysHAVyqGHX3O9eCk2Sinzwy4Ol12EX9LNYx05g+zeaMUsfdUKRXYzp+0QeL3rbLLRLwMj40VhuZy4+skVlgnH0cYD+eSgfMm2QoCqdbuXklsZYOXaZVW36k0JGvLH9waoXQ6GVNHNrENjuypr5XVjay5kbKU+h4xMUy7Bnc6Zrc34xLBXCWzH1VqMcByaEquSYD7tn1J00N6ppd86nvwQw13DKFWfEO1VJ1AEQUMR4eYUwbO1p1GV0Dd1CVCrdko/nS5exxIdx7+J62krsB3k5gPFCtqlQ7ud9dGqvoPy8LVxXBF/0t1592O7mjjtWnGARDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yuXAANrrufrr93ypneAIzSMJCd+jd4GsegRw/FQ/sk=;
 b=ZSHhROUH1J+5wo1beHbvbEfVo+4AGYQ/Q1NAewEzZZi1XyY4MaIALHk2FygoWn3TXOormGr5d6A1j15lRZfuMJajTw6f3vgpRPOm5ZzvdbdyPjC/v2EPJPsJ4FIkP4paPkuRUKsZPzQq9RYCHM0nMDizqX5g8gkhC+ydPgYwnI4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:03:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 16:03:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 07/11] qla2xxx: fix RISC RESET completion polling
Thread-Topic: [PATCH 07/11] qla2xxx: fix RISC RESET completion polling
Thread-Index: AQHXH5+ZTBgxpW9oQ0i1Go3I53vMhqqTTxgA
Date:   Wed, 24 Mar 2021 16:03:04 +0000
Message-ID: <EDD6D8F4-42BD-4BEA-8AA7-23760815616E@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-8-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47013f5f-a07e-4e85-e9cf-08d8eede4f0b
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47327641B94DB0C7B746670FE6639@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKBgTsfExg7dJmsGWPZ6enVX10vVHAEcpZ08bMZSTOJKRU/u2ceWvS+h6mWcBLLGnP+wFzwzYRO/ZXkSfy2knxKzlKRLkOg71t+8kzl6TuNxBmFiDjHv1/VPNDEwV82vJBBU/hOI7BDwPpg2BFw87VfIF6SWeL8J2kbyFAwFVOSWyxCxxUHTDsQd+x+R1J40goEm689XIZeT6FEuQb+1tXSpQk8VqXVmNglMu+l2F4Z/orReI/K3pIQkuJh6/SqK1nM2yqzBxQqVoB1YugTyaw6XbAjUkI4kjhKpfAX6orFGPNFdCajbvJRcXGHyCzkAf5EsgVuj55vqF2Hu6JGyrZVZYPVdFSKM5HokC3llfOJIG4STui55x6ZiOOLsidh49kWJnbc3q/eys9CeliOa/50D9CxglRKiwkE+2is4Kny1py39eFVMMtAlfroR93ifjG84Xzb3WFoTNzUKbxrwzc1k3uWjOyrerGNJF8dm0H3GyWMCzqvxrI0M5RuVLFWqTDTQevl48Fp5Xx0si2FbXq7635/QA47XOn7jpvqMstoSQmILi+V0JNZn+epi0rktmWQcZyNuReFJO+Sgs75gpTbkPlDyiF3SohhcNEDjelzdfZPJhPT6hYiKKCKd794NfhpvM2wuYmPvQplKAdH/2LzWGuKoprVh3Uq5JHJ2vEXVd0apIw2GsfbFx4GwDI0P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(76116006)(2906002)(36756003)(44832011)(6916009)(316002)(8676002)(33656002)(38100700001)(66446008)(64756008)(2616005)(6506007)(54906003)(186003)(26005)(66476007)(53546011)(66946007)(66556008)(6512007)(71200400001)(86362001)(4326008)(8936002)(6486002)(5660300002)(83380400001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5FDZbrpFPRbHUuPohjEW091F0mBe81bxrELMZXQNzwEESdfxyyhS/PFjeaPJ?=
 =?us-ascii?Q?wYm+kphKblM4NPrJcXpYA4NWy9+tVmNT9VCTRf3qIBZUb1Md3SEGUINKSfBL?=
 =?us-ascii?Q?XFV+XGUE+DtKPxy1cBCne/HtEJ2LPQ8zFwfmSnwkCUiBa93KgwWZTDCcr/Vl?=
 =?us-ascii?Q?msG9BkuxNGkaQRYM75YiG4ItfaadmRMVrp6lMfdGRewb6KGoEQ1tHd3EG6iS?=
 =?us-ascii?Q?/eAGw1WETrM8LkgQ1z3lwq8SBB5D6YPdZTXw+acFsxMm2kLgntg6QSYvIxuq?=
 =?us-ascii?Q?QK4AwtetAlIyRdgy8W+DNDjtzW9arQoL0Z6DWcS8f+lzL9oPkhhfThRWLoyR?=
 =?us-ascii?Q?NoDeowxCoI0hELvlhWpG/4402N9ImH+Xsmzb5O7Lz5HcKmvkUyhy8/XY/byP?=
 =?us-ascii?Q?7veSbyKTUQ4Cx2lp6k/gWqtDb9AFbWpDYl0IYp3aJMlQ9x/On25wBGMr3zmZ?=
 =?us-ascii?Q?eOGGI1iN9WAE5V/KTbSCch07zBFuKYwsEype5OP/QEaQaknfrR2Ryi0XABga?=
 =?us-ascii?Q?4xMOvF/VHsDRTK2gjuEvFfWqptzTNM3pW/j46mVXr+QGtNHhCL3yFXoi64Ea?=
 =?us-ascii?Q?8THC+0fw8jCZKjwy/CuL92iKv+VfVo8nTA8CXYKu6J8vINf4/cZldznFCSML?=
 =?us-ascii?Q?pXrsiuAbA1QAm1NAARwqZBbriQ7R5X1FoFTxqNgor+azmHtTv+Jrwz0xqTlt?=
 =?us-ascii?Q?nFmz6TtxSkTPxs093Z345lrvnFg/747huYQBHBBIYISixOLqoKeTuemvgEQA?=
 =?us-ascii?Q?KODva7ZlHu3q5I1RtqIufe1KW0dIH7Pd4qq3rHx8tbQA2eISWF6TcORtG+HP?=
 =?us-ascii?Q?Mbl6xeEa9RHsIHXUNBtyv0CIeW7Ckhrc24h5E45gWwIYnV0/2SfBnf+w3e9+?=
 =?us-ascii?Q?SJIND4eEc6l2jaQodA0hcoOFrbg956MuYL+GDTx37oCQmg8b+3DV8VgKG2Y7?=
 =?us-ascii?Q?7I+FFr+WHnP+vCI4RkAOpBRyZrzgYyIgV3Cd+XPIcoV5+q/DMIXfpitKzZ0D?=
 =?us-ascii?Q?8CJ8bLolSOrd4x1KA8DqhZHiFw9pNip31LMHZSZd3BJKcy35mm3az0vpJFQV?=
 =?us-ascii?Q?k6dSQfAlOzjvX3q/fBaYPzBxcHgBxO1KfkrcFFWL6hExhaki8FRCYpIfxVb9?=
 =?us-ascii?Q?b9lbFKJlJktG8Mr3Wlg/d/uANI+N3vWUQeYo37hmThK8HD8QkP1yHZAxYYlH?=
 =?us-ascii?Q?rbnwD/fgVVCjcRADytf5D3PDH+2V478Co4D6nDfcHnyYLMXifSaQzOJ56RJW?=
 =?us-ascii?Q?IZ/mUBkxM3A4Vs/+7Mm7SPJpeQv89aHE638av+oMJ7Wtf8DUa3wcnpzYnW6c?=
 =?us-ascii?Q?jcdkhs2Zbcs/mTauH68hhZNS?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <605D337BBE997F48BA7FA20F1995173B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47013f5f-a07e-4e85-e9cf-08d8eede4f0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:03:04.8496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUnDr/yjIkRKkvNC1k5g32u5C5d6Ae4gj23dIPnlrT/RJyZBysAyuhgjWMzXK1yrpsmeeHT558q6yOi+cy247JX860FgAGZyAwRe8s4VP+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> After risc reset, the poll time for risc reset completion is
> too short. Fix the completion polling time.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 65 ++++++++++++++++++++++++++++++---
> 1 file changed, 59 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index f6dc8166e7ba..19681d3c5b7a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2767,6 +2767,49 @@ qla81xx_reset_mpi(scsi_qla_host_t *vha)
> 	return qla81xx_write_mpi_register(vha, mb);
> }
>=20
> +static int
> +qla_chk_risc_recovery(scsi_qla_host_t *vha)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
> +	__le16 __iomem *mbptr =3D &reg->mailbox0;
> +	int i;
> +	u16 mb[32];
> +	int rc =3D QLA_SUCCESS;
> +
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +		return rc;
> +
> +	/* this check is only valid after RISC reset */
> +	mb[0] =3D rd_reg_word(mbptr);
> +	mbptr++;
> +	if (mb[0] =3D=3D 0xf) {
> +		rc =3D QLA_FUNCTION_FAILED;
> +
> +		for (i =3D 1; i < 32; i++) {
> +			mb[i] =3D rd_reg_word(mbptr);
> +			mbptr++;
> +		}
> +
> +		ql_log(ql_log_warn, vha, 0x1015,
> +		       "RISC reset failed. mb[0-7] %04xh %04xh %04xh %04xh %04xh %04xh=
 %04xh %04xh\n",
> +		       mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6], mb[7]);
> +		ql_log(ql_log_warn, vha, 0x1015,
> +		       "RISC reset failed. mb[8-15] %04xh %04xh %04xh %04xh %04xh %04x=
h %04xh %04xh\n",
> +		       mb[8], mb[9], mb[10], mb[11], mb[12], mb[13], mb[14],
> +		       mb[15]);
> +		ql_log(ql_log_warn, vha, 0x1015,
> +		       "RISC reset failed. mb[16-23] %04xh %04xh %04xh %04xh %04xh %04=
xh %04xh %04xh\n",
> +		       mb[16], mb[17], mb[18], mb[19], mb[20], mb[21], mb[22],
> +		       mb[23]);
> +		ql_log(ql_log_warn, vha, 0x1015,
> +		       "RISC reset failed. mb[24-31] %04xh %04xh %04xh %04xh %04xh %04=
xh %04xh %04xh\n",
> +		       mb[24], mb[25], mb[26], mb[27], mb[28], mb[29], mb[30],
> +		       mb[31]);
> +	}
> +	return rc;
> +}
> +
> /**
>  * qla24xx_reset_risc() - Perform full reset of ISP24xx RISC.
>  * @vha: HA context
> @@ -2783,6 +2826,7 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
> 	uint16_t wd;
> 	static int abts_cnt; /* ISP abort retry counts */
> 	int rval =3D QLA_SUCCESS;
> +	int print =3D 1;
>=20
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
>=20
> @@ -2871,17 +2915,26 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
> 	rd_reg_dword(&reg->hccr);
>=20
> 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_RESET);
> +	mdelay(10);
> 	rd_reg_dword(&reg->hccr);
>=20
> -	rd_reg_word(&reg->mailbox0);
> -	for (cnt =3D 60; rd_reg_word(&reg->mailbox0) !=3D 0 &&
> -	    rval =3D=3D QLA_SUCCESS; cnt--) {
> +	wd =3D rd_reg_word(&reg->mailbox0);
> +	for (cnt =3D 300; wd !=3D 0 && rval =3D=3D QLA_SUCCESS; cnt--) {
> 		barrier();
> -		if (cnt)
> -			udelay(5);
> -		else
> +		if (cnt) {
> +			mdelay(1);
> +			if (print && qla_chk_risc_recovery(vha))
> +				print =3D 0;
> +
> +			wd =3D rd_reg_word(&reg->mailbox0);
> +		} else {
> 			rval =3D QLA_FUNCTION_TIMEOUT;
> +
> +			ql_log(ql_log_warn, vha, 0x015e,
> +			       "RISC reset timeout\n");
> +		}
> 	}
> +
> 	if (rval =3D=3D QLA_SUCCESS)
> 		set_bit(RISC_RDY_AFT_RESET, &ha->fw_dump_cap_flags);
>=20
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

