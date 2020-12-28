Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040ABC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 06:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA462221E5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 06:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgL1GPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 01:15:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41874 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbgL1GPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Dec 2020 01:15:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BS5xr7c027896;
        Sun, 27 Dec 2020 22:14:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=QQsDTKWoCfByaAijARv/vKHzW0KI4M4473stGViBBlA=;
 b=SOC4k6p/aKPM/QZ5AnI1EJkrw94t7NoBvDksYVyKaC1lxFypfLpbR6pKMTswDkYi4M1T
 2BRgb9xX3Q4pocF5O6Ic54s7GDgUG6t6z0c1gKSeLzazmqdXvkcU/r2dFIRLY+AqUX35
 emHK+x37VfM/tsAX+RdlQfevvm/JyuZsBlCRqugNX2iBIo8N5ER3EFteO/D+jFlZ8aVy
 NhRaI7sa3ulsJQR7bDeYmF9Qbmj0ikr+iMV8GntGMFS21xvMUrHP46pY2c8ER7HP6+RA
 rXwq8ulb0ocPGhx6643qZVbDk4NHey3wji6N0uFJ66INc3JObjQnS0eFinZTaDF9vGXi vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35p5jtjbhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 27 Dec 2020 22:14:31 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Dec
 2020 22:14:29 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Dec
 2020 22:14:29 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.51) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 27 Dec 2020 22:14:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f05HmdixNBppSsvZbBrY8DMGtlbWIe3w8n3wLGDFH+rZMlhl1Hnzu9zgurX8T389ooOFa4QzlygAe9UXO+Va7IpLfat55G80zUCh/tuSZDjIqLZ7UtAM87v8cSLIsUQIhJLDffNG/KJXT22NPbbJcDA3iIGK0QuOQdJWYN8oKYA832FqBjCb0RmdWkktgzNZPQHO70Ioopi0epV80jdT5TpLHjxOeB4hOR9fw3h5djUdTyH+ByrXmx1Co0GFpn3crZoBCZjX4Hi6MqymtHWHsHv4/GvolRWD8Eu7u7GdfwwYiDIVrOeSSTiyKu7FreAa3vJdKt3y/cvuZQhAclapbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQsDTKWoCfByaAijARv/vKHzW0KI4M4473stGViBBlA=;
 b=ZqHKXHtkfuv2It5SLQ0rMXJsSHB+8BvzYmn+HwFHnSfoH1f+32460IJrBO++ALZgyPDTSl1Q5S/1z33zdrxLqVnBOZfo5drbB3VwExJGNG5JtHaokB/TZ2+YwwtifiiJNcuKnFWW4g2ztYNGOZWwwhbWBnP58PiEo7Ci1euxunXZb413/bXjlyn3hFvPMQtQrnHrgT7jSa5SChDOQMmE9vSu4jfZiztsoXj0gDUMOb+WnH0Jp6x3l55Fam4s4snopOG02XGFt/LCStGe/YXhZbqoCus2AtVjSLzBhsqPNSD4OEG1/T767ZHvvCcDTgIjiQNtiRoVZDYbCevS8mYlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQsDTKWoCfByaAijARv/vKHzW0KI4M4473stGViBBlA=;
 b=mOvioC1Nn63BbDpPsgMGSbbptAk+HmrwhHTAfzOh5IyLDiyUUz+cyV624BVcGr/adYy/skmvFPwG7BZbmAQVZe3kzJfYCdgxkOgR1GQ1ADXgcE3PP/Xcsln7Zjd9+7IHvRGJ/LI5EUMuAZG7e9xZBmlx7gTE2TARryDdLFiOn+A=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3250.namprd18.prod.outlook.com (2603:10b6:a03:1aa::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27; Mon, 28 Dec
 2020 06:14:25 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::7475:4e06:6e00:1553]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::7475:4e06:6e00:1553%4]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 06:14:25 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: qedi: add printf attribute to log function
Thread-Topic: [PATCH] scsi: qedi: add printf attribute to log function
Thread-Index: AQHW17X2wSuSr7TtZE6Xoo+9t4tRHqoMEcDw
Date:   Mon, 28 Dec 2020 06:14:24 +0000
Message-ID: <BYAPR18MB29986769E1F17A8AACAE038AD8D91@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20201221162335.3756353-1-trix@redhat.com>
In-Reply-To: <20201221162335.3756353-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.74.174.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 874f4612-1603-48d1-5c6e-08d8aaf7d33d
x-ms-traffictypediagnostic: BY5PR18MB3250:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB325064AABD16A1AD13376004D8D91@BY5PR18MB3250.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FD7OSClFOLU0dGnYhCkOxLYEDs2zE0IcM2M1rTPsrrrNP44bhAndNTmFxaPKz6HA3Y51RcTatpuTWzLrK+gmI4y4vcXf3bH9VkxY15hBbnkkPiyyAfIUp/j3cV6kHWo1p2/VH3hB+Pcv6lMf1vxjlNfw5lh+g24uyhm3A384r8iDAGvifPDJPgc16ZoTQYGxIO/YqOerprd/6pVoxKhnadNabYLxmoi2WPzh3CwxTTbOoOL9hMcadWMYx0ag7n/zXgKTVuW49uANI8wRy47VsiIRK+NflBCuaz7J4G+cTIXU3MgbKByQhuLsoeQxVUVatd/bnuYEfwNpbm0SEJ5+eR2NUrlv5FqmkCnuyV3pgL8fG1Y9sOxCUGAdZ9bNfML+ZEuN183g0R3aYJhE5SMNDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39850400004)(54906003)(478600001)(66446008)(66476007)(66946007)(2906002)(71200400001)(53546011)(6506007)(110136005)(64756008)(83380400001)(55016002)(9686003)(5660300002)(33656002)(8676002)(76116006)(186003)(52536014)(8936002)(26005)(4326008)(55236004)(316002)(86362001)(7696005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5wWu1OWVaa6+cjhoWze/e+9h1PhU8pmj/BaH9vu+OMhsDQG9wcJ0qe48gAzZ?=
 =?us-ascii?Q?k0m5Z1ILJRZICMVS3/IV3EhXyRJmkogEGK+BrtEFW9nr5TeL11UuDM7MVI7/?=
 =?us-ascii?Q?XlejnY7OUtoxOAEzmbFSbKcGJrMxyi4473bP69gpEoD+/PrMdLYCmxDZRW4X?=
 =?us-ascii?Q?1zlKS8X+kuSBtNoGyaRmplSd82GLSjUcWc7xpbIA16u5F0kEs7lsli00DX2x?=
 =?us-ascii?Q?RGAaQ8GwQrt+qt6uM3aZfLzUzCz078ifGHLW/zcPHZ6Yz3DAvGn0KKLXEReA?=
 =?us-ascii?Q?miaynPedG9m2VDVXakGNXQQbFOrzeN2v78wJh29iARp0GL4x4CZKTrXSQ5OW?=
 =?us-ascii?Q?YAaRkpDKDdrm2OlmrDHeRzNq9QkryLWKS590MVjSVzcDVuc122wFN5RxL4Wo?=
 =?us-ascii?Q?FS+qjYmr2BjtP+CyFq4ps8p7QMJ9/CL6l5Yb2BPgAazXbXfaLKhVR3BTJv8i?=
 =?us-ascii?Q?XH96jbHJc+Tos68CGHswjDAU1u9EQ6dEkg80P65alOMd2Q8UNdyqtfkGU12E?=
 =?us-ascii?Q?WV1xRy6O8AYmOVRXxXCY+AVul7X7N7DDTRH0gwCkHYrk3oFE8Zopn5zllCcx?=
 =?us-ascii?Q?iuqo6pZEhViq7aEmigOKBYZnr79ACJgl+7qL0aKGv7QAQEHa1lYKHjJh9kH7?=
 =?us-ascii?Q?/WYD+/D2APYvvEK9f6Mbk8iRhshFfBSv0bjlnMYyvdr1rRR14sC9JC6haGDy?=
 =?us-ascii?Q?Yk67L/UFSKb0flq0nXndyWOoaoLEBHGN2+nmEcVWVih3tS28gIIVMZzPn3Fv?=
 =?us-ascii?Q?618iZpBViRy2BhJ/OAl9lrmDwy5nbJNT2YpRp2NyB7dktfF2eAQidxWpHDek?=
 =?us-ascii?Q?TEclorbaPbtcJzTT58aMzo7k8pDPX0B5T8ZvkI2E2+BXohATYaQIxI672AoR?=
 =?us-ascii?Q?AWRdqiQveBVwHQS8ed0aLmMz8QQQUWiZXzPbcN6RAjhPAlGv3zztUxJ0iFCN?=
 =?us-ascii?Q?P7VYZXpK4fFxcJVzDE5YPHTBqIIdT8fhCfYvmjhB3zw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874f4612-1603-48d1-5c6e-08d8aaf7d33d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2020 06:14:24.9014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWmbVkIltXJToZD6Xt3csKqNwRxssOW6eMJCKvXvLZ58AGJSTTE1hfvKIxSVEFoR5mbLkIi+67y88lLJqf0RcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3250
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-28_04:2020-12-24,2020-12-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: trix@redhat.com <trix@redhat.com>
> Sent: Monday, December 21, 2020 9:54 PM
> To: Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Tom Rix <trix@redhat.com>
> Subject: [PATCH] scsi: qedi: add printf attribute to log function
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Attributing the function allows the compiler to more thoroughly check the
> use of the function with -Wformat and similar flags.
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/scsi/qedi/qedi_dbg.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
> index 37d084086fd4..b2c9b0a2db6a 100644
> --- a/drivers/scsi/qedi/qedi_dbg.h
> +++ b/drivers/scsi/qedi/qedi_dbg.h
> @@ -78,13 +78,16 @@ struct qedi_dbg_ctx {
>  #define QEDI_INFO(pdev, level, fmt, ...)	\
>  		qedi_dbg_info(pdev, __func__, __LINE__, level, fmt,	\
>  			      ## __VA_ARGS__)
> -
> +__printf(4, 5)
>  void qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>  		  const char *fmt, ...);
> +__printf(4, 5)
>  void qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line=
,
>  		   const char *fmt, ...);
> +__printf(4, 5)
>  void qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32
> line,
>  		     const char *fmt, ...);
> +__printf(5, 6)
>  void qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line=
,
>  		   u32 info, const char *fmt, ...);
>=20

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
