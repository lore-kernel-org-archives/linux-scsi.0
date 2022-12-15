Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97437C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLORfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLORfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:35:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E6216590
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:35:41 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn0Hh029485;
        Thu, 15 Dec 2022 17:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LICrWczArzJfdj8w9UsmGGN40OEAd/KrbgBXYAjPUKo=;
 b=pJK9porMK18VsuzGTuIYP53rh0zUjFlCCPFctlcRoirdPaaxrJ8d0aclrgeUAfTB70v4
 s9wyNSckkT9nhTEwqiziCrIsEU39WRHEuqab784Wg+ceo6gofWgh5L9WTEo4xJjOscDi
 kZ4ChpX2l6N5dMvf18FSh01Su6CG3OfPHkRiwqAuwAfqyX0ErYSw3aACIVt/RsszVZO/
 RCBzVAP5Kvg6eLYQY/CAPrJj60yrfHfHMJrQO2N2V6qPn9rhD08CAVL3irZGe3ofmrEM
 x7sqtCzMr+xucOo5YySQeQxjUDTGTiOGAdDWLt0p9U8vUdUxIMzKfaxNrOjPrwZkHxDb ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu5t71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:35:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFHDj8a000427;
        Thu, 15 Dec 2022 17:35:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyes2acn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmgxPXDCnaw3TzTLvAYgpUJ3jxNOfl1heeV56Im1pQL7G/LaL3CU1EfbtBiyD9717xFBInwWDatEl/HRHhOeDsMlhYZ799l/Qv7HDdI8NNWhH0DplI89Y562xbH4H2vk/UQiW1oW2PWcqCdrTt5LDgslX+yo3gurSe2iDJS2ih6i607cEUkwkzAr47u76tmc2jzMU/MJ+XqA+n0nJwRN96BXPthwy36OqXqFwh1wQz55oghQQZQ7zvD8Wnxp05MisrBvY8kV8w2lAT0zweoEaP/Dt+4Ed4pMhBMVXchutJWjK9YEl2ybSl/Vb7TZzyLBIx2CpIcS0RT9VsKzsU+VuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LICrWczArzJfdj8w9UsmGGN40OEAd/KrbgBXYAjPUKo=;
 b=mc1aSkkBBWlsaqGvFt0DhPX8Q3QUwFquMsiznZp8AS581DDiFSdBiGm301iOat1BA1y7+c/XLsqy6TxCWlVFS7zN3ne13MaaeO7nEut0nrxsJdeCRRtmTgG4TxOKQxgRUTkJHOj1QgdAPQ9j1Mj/qa9u5ANl8ULiDiHawO/TPjTWTeriplssFOHNieTWA/2jFIsSM6F/dfn3xnLKmiZY3h3IZbHMlm2QUjm62EB7FNsKieJfAKjV5JiqrvhCVRB7lKyINWNYu6Ebc9ORNF22rC+rwfzOcWlVmJBiMZWsqen2fh8kqTaApfW2CXH2q1v67YB29yzrguPMfoDRJXHJFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LICrWczArzJfdj8w9UsmGGN40OEAd/KrbgBXYAjPUKo=;
 b=m1H3ormUuLlncOBRZNvsDdVKDBiv6RJ5KrsOkLtzRwKL0zL2p0ATQ0sS6Nae+Mpc1TONzNoLP5WQrVSH7FBQV+bw1McjQ6ftyTmd1sMvWG3oeyCKGpFknP9MH/5AnvR1Ldvsv0QHak6+qzrw3wLz+Fkjy2FverEPvWloN5ZTIK8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:35:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:35:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 04/10] qla2xxx: Fix exchange over subscription
Thread-Topic: [PATCH 04/10] qla2xxx: Fix exchange over subscription
Thread-Index: AQHZD3enQ1UMwUt/j0yfcfiQ0RncH65vOFeA
Date:   Thu, 15 Dec 2022 17:35:35 +0000
Message-ID: <FC39788E-4A6B-4A66-965D-C03844A3E762@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-5-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|DM6PR10MB4137:EE_
x-ms-office365-filtering-correlation-id: 5a46531f-f55c-4d1f-2cf4-08dadec2c66c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfftCvKmSsMyI6xjO11dKIpUs3WuCe+XeboyWv8vrqU2uQuTosYnVLHaWuiZtUEQNmJE3kSM1Jg3CsrNfyXv1w0PcmSfgtq/MFDwD7bfNWPP0OxTwlUl8oXiyOqGL4/zUHylgR5qOshhTzbk0/vGs7oaR/VnWEc/6L23XldMi12YK2z5wWQqtKxKcmvXBnPj0lqGSEQSVk2Wnxy/dLIVBiYZR8U3lUYLjpekFxq3QOXpXnC+xnPFJUy/tiAwTlrOCbzLGHoU1uo0fvOe4u6fD0pGmPG1Aqxmucg2samAS2v+CPRishPqrVhlZbSBYZN/F675TaPniiiiuj199NYC4AhZ/iJzOWodR1zp2m7GEjO9FYK01IxKKouCC0Yx+ASjLVCF5zmikpF2vti0Qp+ISPDyV7yz+6P4oUCVJcbQbKoeBS8OhrfVf/yd9XTnaWyq0fgexm97P81W3L94PQB3/Fdaot9PH+ql6zP36hNrlfyPIpyeDLK37js3sJoM+Xgtw/ITsRtRpdeInJB4uw8CBo203bbqgJ7DLpryoW2azWW0z8pXtEPlo+I7xtZn8W7Luf73DUnjPXmHhs8gUVjW8tyX2XUOrLl+gbKIXf+qqgaHHbujvGv9CPgQAGvHso6k3iiR5V3Qu5gB3UaDkCiC5a/uR304xyZyfKJrmGBPFoTy4+dPycX3uXXukaeaFarHgkozaUZgxGs6SIqBhX/XvyAWkOt4uqS+USVLPuvsrT8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(8936002)(5660300002)(30864003)(44832011)(6916009)(54906003)(38100700002)(2616005)(316002)(33656002)(76116006)(86362001)(36756003)(8676002)(66446008)(66556008)(4326008)(66946007)(64756008)(66476007)(41300700001)(6506007)(38070700005)(478600001)(53546011)(6512007)(186003)(6486002)(122000001)(83380400001)(2906002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kJJ+vNeHKBn/qEgTj9WHhdwDlYA/6mIZ7GsROiHWijTpr1+7bPuTmU9+hIQC?=
 =?us-ascii?Q?RBhq8CQWCDCk+e4w2Z9ba67/WhIOSpZ2qANZC4rjo40oigikc42JQ9Ic+B2M?=
 =?us-ascii?Q?ckhiSFNTf66cpzDsp8BImpiNGrKdCtGBHt2hK2uZjhmlV/0Ujm85kBUVlF87?=
 =?us-ascii?Q?lLD5EkmuOlJgEzSdupFzkA1MgdPDqI9pIwRY1Fw1qGe4oPdYB95yJIWwqUgE?=
 =?us-ascii?Q?xjdo0GUmRHKBTBhEpWdqmOemxqRRCAbUYCpw0GbWmHTT/Qiwl43TDuAQX1Xr?=
 =?us-ascii?Q?C+/UwFXq2Q85iqIvBufn08LanmvTexIofxIWMxvOfxG6x0LZ+pcsjaMLtbzg?=
 =?us-ascii?Q?5BP6tnAO/FvzEQwsLR0jH8JfvMR0c4ySU8R6t/6R8t3b5kHyNpvFm5e33M4B?=
 =?us-ascii?Q?iwQujs78iRqueqEzF3+FIex4wDYENIfMt2Igt9Y2MxeEKzzmUnWXp+tyU98F?=
 =?us-ascii?Q?6aKG7O+LV9h4/3nR4MohjU05TTHq130VHVjdWrn4LB8KApXXfqrW0HohTJMx?=
 =?us-ascii?Q?yX7u9UIluRBiNnoRkFRY7mUUGzvzY1Xbd3OW8dvZOgaNKTN32Rty4g3654P2?=
 =?us-ascii?Q?Qdf18L3X9mB097uc1nWa2R//HRz6QnhygN+BT5R1vlcerSkPm9tDhhyGyNVg?=
 =?us-ascii?Q?xAKZyxSHjjclqZ8LVywyA8YFqbm/QeK5qhKrwfkR3o3u257Xdl82vt3iHBBS?=
 =?us-ascii?Q?kcO/dKRVHes5uth8zJhevSwDK3doSUaEruBM7H3Dp2nUb85cwLrIZ53Wws75?=
 =?us-ascii?Q?ybyrZUztZSaI9iCwxAQDSZIoOnhHS8CYEWf7ZJKz+WYJJ3ISk+5oln+dJxaW?=
 =?us-ascii?Q?J7vdbwSQy/jFwlUjZ6xJ5WcJ7aDFPh6hvzfsQgAnuARz8Q8WAbzSry3FGYSk?=
 =?us-ascii?Q?PSSfJmL9mAzK5CY7eMdwW+dcmfMCdHVxAiBpSjs1ISohx+zRTPZCq0kv7sXP?=
 =?us-ascii?Q?vALCtkGjjQyPI+JuOup3jK9eTiiHKVC36igw+IJxJ9CFwWKPByzBIw9pE5Fs?=
 =?us-ascii?Q?CO05aTb58bdHIJK7eSjUpHrCxqKx82GAPyEkG1gwlmm5Dp+QQ02bx0UEeK0V?=
 =?us-ascii?Q?UEdSr0UdwT6DpVc3G2ulfj7GB5r//yW6F49PT0Jc9clz1SET0msPhVIigcjD?=
 =?us-ascii?Q?7qbTjomXw5FG+I9s13GtPspfp4IxQn0LTnNB6NirPGWfMNloRrZbEvorb1DN?=
 =?us-ascii?Q?i5u5sTSA6MpP6MYWzYEXbEMQu5OT4IsqIpQY4j4xsT0gPjFPPk0ASjj03k61?=
 =?us-ascii?Q?pLY9CKwEv5CqiBYXetSFHakA9Zm1XTZOyOGmnd/aI5MmCCfLRBm2mcEfFIYj?=
 =?us-ascii?Q?s6hk05e2dt589AN/N/y8locrzuCfgZ55zBnHkOt2hl333EnhnulhPCKeWwtX?=
 =?us-ascii?Q?Ld7v6mfopL8dLY4lAr5Gh8r54iVCYbk9rg4eZb3I/zeo6w5/m2IMFATZwc9A?=
 =?us-ascii?Q?C5ljBGMTlAKp4gOLtFOsj8bjMJrBtOWv1GZkoUpuUn325bfFEVJRD9Q5Ez7R?=
 =?us-ascii?Q?Meo2FMgEhylMEDBN4RDe9Qu5XS4o3FOkZa3SaQZJJhX0uaANeAI6f8h591Ti?=
 =?us-ascii?Q?TNZTydYZTOoipS3rLFrffPRihFaZ7NyldPN9R7vcxqjVz49iaSr8WqT7Jvwv?=
 =?us-ascii?Q?/MerM92j2cAgFACINYTjywaVpdGp7QMB61uN5Uj+fRK4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4238D28C8DFF154B9BFBE608602A6BCE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a46531f-f55c-4d1f-2cf4-08dadec2c66c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:35:35.9721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: scNuN3UJP4Q7QotqrKevq3IHfR4gK3qtFvghBJ7g0WZVBW4518Q+8AGZLagr6P3CxG8zk5bNCgr/6ET/yW5x44yWjGy1xggNnJsjCyjLlCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150145
X-Proofpoint-ORIG-GUID: VA5qKgw5yUtt0JtzPCfUZlRmue6d7SL3
X-Proofpoint-GUID: VA5qKgw5yUtt0JtzPCfUZlRmue6d7SL3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> In large environment, user can experience command timeout and
> escalation of path recovery. Currently driver does not track
> the number of exchanges/commands sent to FW. If there are
> delay for commands at the head of the queue, then this will
> create back pressure for commands at the back of the queue.
>=20
> This patch would check for exchange availability before command submissio=
n.
>=20
> Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h    |  6 +++-
> drivers/scsi/qla2xxx/qla_edif.c   |  7 +++--
> drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++++
> drivers/scsi/qla2xxx/qla_inline.h | 52 +++++++++++++++++++++----------
> drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++-------
> drivers/scsi/qla2xxx/qla_isr.c    |  3 +-
> drivers/scsi/qla2xxx/qla_nvme.c   | 15 ++++++++-
> 7 files changed, 88 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index a26a373be9da..cd4eb11b0707 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -660,7 +660,7 @@ enum {
>=20
> struct iocb_resource {
> 	u8 res_type;
> -	u8 pad;
> +	u8  exch_cnt;
> 	u16 iocb_cnt;
> };
>=20
> @@ -3721,6 +3721,10 @@ struct qla_fw_resources {
> 	u16 iocbs_limit;
> 	u16 iocbs_qp_limit;
> 	u16 iocbs_used;
> +	u16 exch_total;
> +	u16 exch_limit;
> +	u16 exch_used;
> +	u16 pad;
> };
>=20
> #define QLA_IOCB_PCT_LIMIT 95
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 00ccc41cef14..d17ba6275b68 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2989,9 +2989,10 @@ qla28xx_start_scsi_edif(srb_t *sp)
> 	tot_dsds =3D nseg;
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
>=20
> -	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> 	sp->iores.iocb_cnt =3D req_cnt;
> -	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> @@ -3185,7 +3186,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
> 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
> 		sp->u.scmd.ct6_ctx =3D NULL;
> 	}
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 8d9ecabb1aac..fd27fb511479 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -128,12 +128,14 @@ static void qla24xx_abort_iocb_timeout(void *data)
> 		    sp->cmd_sp)) {
> 			qpair->req->outstanding_cmds[handle] =3D NULL;
> 			cmdsp_found =3D 1;
> +			qla_put_fw_resources(qpair, &sp->cmd_sp->iores);
> 		}
>=20
> 		/* removing the abort */
> 		if (qpair->req->outstanding_cmds[handle] =3D=3D sp) {
> 			qpair->req->outstanding_cmds[handle] =3D NULL;
> 			sp_found =3D 1;
> +			qla_put_fw_resources(qpair, &sp->iores);
> 			break;
> 		}
> 	}
> @@ -2000,6 +2002,7 @@ qla2x00_tmf_iocb_timeout(void *data)
> 		for (h =3D 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
> 			if (sp->qpair->req->outstanding_cmds[h] =3D=3D sp) {
> 				sp->qpair->req->outstanding_cmds[h] =3D NULL;
> +				qla_put_fw_resources(sp->qpair, &sp->iores);
> 				break;
> 			}
> 		}
> @@ -3943,6 +3946,12 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
> 	ha->base_qpair->fwres.iocbs_limit =3D limit;
> 	ha->base_qpair->fwres.iocbs_qp_limit =3D limit / num_qps;
> 	ha->base_qpair->fwres.iocbs_used =3D 0;
> +
> +	ha->base_qpair->fwres.exch_total =3D ha->orig_fw_xcb_count;
> +	ha->base_qpair->fwres.exch_limit =3D (ha->orig_fw_xcb_count *
> +					    QLA_IOCB_PCT_LIMIT) / 100;
> +	ha->base_qpair->fwres.exch_used  =3D 0;
> +
> 	for (i =3D 0; i < ha->max_qpairs; i++) {
> 		if (ha->queue_pair_map[i])  {
> 			ha->queue_pair_map[i]->fwres.iocbs_total =3D
> @@ -3951,6 +3960,10 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
> 			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =3D
> 				limit / num_qps;
> 			ha->queue_pair_map[i]->fwres.iocbs_used =3D 0;
> +			ha->queue_pair_map[i]->fwres.exch_total =3D ha->orig_fw_xcb_count;
> +			ha->queue_pair_map[i]->fwres.exch_limit =3D
> +				(ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
> +			ha->queue_pair_map[i]->fwres.exch_used =3D 0;
> 		}
> 	}
> }
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index 5185dc5daf80..2d5a275d8b00 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -380,13 +380,16 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
>=20
> enum {
> 	RESOURCE_NONE,
> -	RESOURCE_INI,
> +	RESOURCE_IOCB  =3D BIT_0,
> +	RESOURCE_EXCH =3D BIT_1,  /* exchange */
> +	RESOURCE_FORCE =3D BIT_2,
> };
>=20
> static inline int
> -qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
> +qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
> {
> 	u16 iocbs_used, i;
> +	u16 exch_used;
> 	struct qla_hw_data *ha =3D qp->vha->hw;
>=20
> 	if (!ql2xenforce_iocb_limit) {
> @@ -394,10 +397,7 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_reso=
urce *iores)
> 		return 0;
> 	}
>=20
> -	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < qp->fwres.iocbs_qp_limit=
) {
> -		qp->fwres.iocbs_used +=3D iores->iocb_cnt;
> -		return 0;
> -	} else {
> +	if ((iores->iocb_cnt + qp->fwres.iocbs_used) >=3D qp->fwres.iocbs_qp_li=
mit) {
> 		/* no need to acquire qpair lock. It's just rough calculation */
> 		iocbs_used =3D ha->base_qpair->fwres.iocbs_used;
> 		for (i =3D 0; i < ha->max_qpairs; i++) {
> @@ -405,30 +405,48 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_res=
ource *iores)
> 				iocbs_used +=3D ha->queue_pair_map[i]->fwres.iocbs_used;
> 		}
>=20
> -		if ((iores->iocb_cnt + iocbs_used) < qp->fwres.iocbs_limit) {
> -			qp->fwres.iocbs_used +=3D iores->iocb_cnt;
> -			return 0;
> -		} else {
> +		if ((iores->iocb_cnt + iocbs_used) >=3D qp->fwres.iocbs_limit) {
> +			iores->res_type =3D RESOURCE_NONE;
> +			return -ENOSPC;
> +		}
> +	}
> +
> +	if (iores->res_type & RESOURCE_EXCH) {
> +		exch_used =3D ha->base_qpair->fwres.exch_used;
> +		for (i =3D 0; i < ha->max_qpairs; i++) {
> +			if (ha->queue_pair_map[i])
> +				exch_used +=3D ha->queue_pair_map[i]->fwres.exch_used;
> +		}
> +
> +		if ((exch_used + iores->exch_cnt) >=3D qp->fwres.exch_limit) {
> 			iores->res_type =3D RESOURCE_NONE;
> 			return -ENOSPC;
> 		}
> 	}
> +	qp->fwres.iocbs_used +=3D iores->iocb_cnt;
> +	qp->fwres.exch_used +=3D iores->exch_cnt;
> +	return 0;
> }
>=20
> static inline void
> -qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
> +qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
> {
> -	switch (iores->res_type) {
> -	case RESOURCE_NONE:
> -		break;
> -	default:
> +	if (iores->res_type & RESOURCE_IOCB) {
> 		if (qp->fwres.iocbs_used >=3D iores->iocb_cnt) {
> 			qp->fwres.iocbs_used -=3D iores->iocb_cnt;
> 		} else {
> -			// should not happen
> +			/* should not happen */
> 			qp->fwres.iocbs_used =3D 0;
> 		}
> -		break;
> +	}
> +
> +	if (iores->res_type & RESOURCE_EXCH) {
> +		if (qp->fwres.exch_used >=3D iores->exch_cnt) {
> +			qp->fwres.exch_used -=3D iores->exch_cnt;
> +		} else {
> +			/* should not happen */
> +			qp->fwres.exch_used =3D 0;
> +		}
> 	}
> 	iores->res_type =3D RESOURCE_NONE;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 42ce4e1fe744..399ec8da2d73 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1589,9 +1589,10 @@ qla24xx_start_scsi(srb_t *sp)
> 	tot_dsds =3D nseg;
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
>=20
> -	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> 	sp->iores.iocb_cnt =3D req_cnt;
> -	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> @@ -1678,7 +1679,7 @@ qla24xx_start_scsi(srb_t *sp)
> 	if (tot_dsds)
> 		scsi_dma_unmap(cmd);
>=20
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> @@ -1793,9 +1794,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 	tot_prot_dsds =3D nseg;
> 	tot_dsds +=3D nseg;
>=20
> -	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> 	sp->iores.iocb_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> -	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> @@ -1883,7 +1885,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 	}
> 	/* Cleanup will be performed by the caller (queuecommand) */
>=20
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> @@ -1952,9 +1954,10 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	tot_dsds =3D nseg;
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
>=20
> -	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> 	sp->iores.iocb_cnt =3D req_cnt;
> -	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> @@ -2041,7 +2044,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	if (tot_dsds)
> 		scsi_dma_unmap(cmd);
>=20
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> @@ -2171,9 +2174,10 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 	tot_prot_dsds =3D nseg;
> 	tot_dsds +=3D nseg;
>=20
> -	sp->iores.res_type =3D RESOURCE_INI;
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> 	sp->iores.iocb_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> -	if (qla_get_iocbs(sp->qpair, &sp->iores))
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> @@ -2260,7 +2264,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 	}
> 	/* Cleanup will be performed by the caller (queuecommand) */
>=20
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> 	return QLA_FUNCTION_FAILED;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index e19fde304e5c..42d3d2de3d31 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3197,7 +3197,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct r=
sp_que *rsp, void *pkt)
> 		}
> 		return;
> 	}
> -	qla_put_iocbs(sp->qpair, &sp->iores);
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
>=20
> 	if (sp->cmd_type !=3D TYPE_SRB) {
> 		req->outstanding_cmds[handle] =3D NULL;
> @@ -3618,7 +3618,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rs=
p_que *rsp, sts_entry_t *pkt)
> 	default:
> 		sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
> 		if (sp) {
> -			qla_put_iocbs(sp->qpair, &sp->iores);
> 			sp->done(sp, res);
> 			return 0;
> 		}
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 8927ddc5e69c..c57e02a35521 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -428,13 +428,24 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 		goto queuing_error;
> 	}
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> +
> +	sp->iores.res_type =3D RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt =3D 1;
> +	sp->iores.iocb_cnt =3D req_cnt;
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores)) {
> +		rval =3D -EBUSY;
> +		goto queuing_error;
> +	}
> +
> 	if (req->cnt < (req_cnt + 2)) {
> 		if (IS_SHADOW_REG_CAPABLE(ha)) {
> 			cnt =3D *req->out_ptr;
> 		} else {
> 			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> -			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt)) {
> +				rval =3D -EBUSY;
> 				goto queuing_error;
> +			}
> 		}
>=20
> 		if (req->ring_index < cnt)
> @@ -583,6 +594,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 		qla24xx_process_response_queue(vha, rsp);
>=20
> queuing_error:
> +	if (rval)
> +		qla_put_fw_resources(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> 	return rval;
> --=20
> 2.19.0.rc0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

