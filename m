Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B421C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15F260EE8
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242122AbhHEP2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:28:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10860 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242120AbhHEP2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:28:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FCtvt023169;
        Thu, 5 Aug 2021 15:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nPSo6HSBWMZxJjX9r9f81/nWXHi2pnhvl2s9pLACMSE=;
 b=Z48oEL5tVLO1YdwoiXqSNEc6ZHxoz/dy/iOqnzSZWgCVaDEms1N/9XmZg2vqO1M8ktAT
 HtLmzTWp+r9Op65bjiHt8G2mxg66n3okfbGhRJOX5QyIITepu6rt9+kSDIq5XOG+CdH2
 5PZVsd8BpCUFJrTvWd4YRD4xWrsZhx4Bakx5KDdyxWCy0VUzlgiQep9ZBW4RmXhSr7O1
 sgAvMqS6KdDg9Mp4ozSc1TT/rn4ZjrkHMOsWtH8K9C8FkjGIvFbwHCaobPp0A1DTQIes
 G8D+G5UnYAvl3o5rrpEtMtS+1P4RxHGkMd4EtZ8d2WZ2g3cQ5ppvJ+gAm+aOFJKpwCDL Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nPSo6HSBWMZxJjX9r9f81/nWXHi2pnhvl2s9pLACMSE=;
 b=ck+LLRp/HDeQmulWjM94Amp8uV8v66xXQlv6n/lL44O++WYGRX1LlbXIILZaJaWPucuf
 rHWJF5OGpeDiP8UpE0TbImDHFHymPMgWPgDZ9He6H8jcmupHKSyJHy7718AiSmVoDWQs
 o+I+aZreOJ56qZP6S4EoYeoQrn5UaPD//EcwvxElBc9Si02PKZTQ29lz5EezYfX2p9vb
 n1BSvEkifKKEoqJ8yWG5zL0VIwUKn5aeCxq6j7ZNPUeo5gaaPG38v+QcJGDrDN6gFxfN
 uhb2re0qmfcKD39cXDtgjHk+2NGYOhierNO3SqVcYtuU8mxD0ZfFl3cAYNwgP9ybt0dv Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpmds4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:28:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FGDmh141713;
        Thu, 5 Aug 2021 15:28:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 3a78d8u7f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asMcd3RFWn3iu93iySy2rpIyCVSdRI7PblLvXqF3fvJfeXDFJBVnCNa6j19HSGpnoiI0Wnnum2yJ53ACUKtt5wE2cwEDX5uHx095/IXWrJqwM0xjGURU20x1C7pvpfYlPbeoj5/QTSc5ZqcDRoTj69IwDyPccbblRmKS+chiMlzBJF6DAOxgmIJAtQdcbt1b6sd0m8qYbwt/y3ilTojpUOkKDu0SQXhFO2XqkvXqumdzRv7suHyFzOn1xP/fmI1XXwW+a1Qs090yGgUTtWxZjB1MtVhuQyBJOA8MctIU28uwj2fe1eE7+KxSTEREVnR9e9MQDVTehvodDmeDvESXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPSo6HSBWMZxJjX9r9f81/nWXHi2pnhvl2s9pLACMSE=;
 b=T4aYUic7DcVnlGP7xpiyXyXAFuc0PAxp3myVmNbk9anuiB5uiiNB9lRnpVAXDhAIicSEouwJFkHgX9zCfYWZ+X7VwHEOVf8Tx5lgk8OAQZiq+/Bfjlo/IUl2lHkJCSjI3k9XMp2EwVfXkwvzDz7nkqKd4t7heIflf8DXbuk6VUTs5NQXrd3uz3o0xJl2Pu5NDXYunXtBJv9NCH6XtpA3mXu6yEIN9c+x6GlIsXooBfQh9p2gmrfHSqRdhbN+Xr8cgkyV+GsJTggEDTAvAVXKlk0BaoijzH1RCuza87TN4hGCjiJYmqcus83nYl+go04rzg4ASrPd+ym6oH1/Hz6+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPSo6HSBWMZxJjX9r9f81/nWXHi2pnhvl2s9pLACMSE=;
 b=tFkqePAsg6XOZORFVJYhiSKj1rjxo+rtEIXbM0QeamkyfFJY1mNYKnqlG7me4E0rZ3G+xy584a8exQoNszBaNVDYsfuKAR6mhvHyu/RVJTM999WmZGumhlVJe1yAN26+EobjwQYWfvqH6fV3HiniInjNLc/IfgQxO4ccfNjvbuI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Thu, 5 Aug
 2021 15:28:02 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:28:02 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 06/14] qla2xxx: fix debug print of 64G link speed
Thread-Topic: [PATCH 06/14] qla2xxx: fix debug print of 64G link speed
Thread-Index: AQHXiePi26aCiv2hnU6YSj8NF6vEcatlCSyA
Date:   Thu, 5 Aug 2021 15:28:01 +0000
Message-ID: <62810F9B-957E-4E76-B614-E4EBDE5BBF84@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-7-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fbd1ee4-6271-4d37-72e0-08d958259cfe
x-ms-traffictypediagnostic: SA2PR10MB4779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47793FF9C616B3EFF8C66229E6F29@SA2PR10MB4779.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:64;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myheyBOtSyWgT0q6DOM6C1GpaYJNefj5AWv1RH7O4NwIHzFh7kpA+dVOx9krdbo1lKDCXxuKEbybPEljaVM9A1r660p4XsY/w0pDq6Kw6fs3KdSMLEDQd1x++jec6yVx3Ej1S5vReabSH+P1Dhv12931RN23VHfyqsGy8VL8sy0K92LsQSk+XiD5H5ZTF4P0xBFDzO0r8cEn3hGyGV1ar0OdP27X1gSnzTGEFEkWX9Bc5hO3ouTzIWY0kaVlh/nQsPXoA1R1I6Ca66u99yl1oM8XnSyDLB42nX3kest8vkpAHRCPFDw00Q3mB7AofJBjwLkuH4ap3gVv+ie+gDpI6aBcvVyKDwTuLK+AqwGBxkcIKi8PcUgmv+fyJEobxyUDAieed/G9xebCBZr5M7gwUdxByJIwOihhiZNwdST7t9hLnQ3WenxH0aZycQi8pEl+I71AJc42ValHhlnaXBVOxr2Vq8l6jNVuaweLa+ubzEGKjBEwIeRIh+G+YeLfbXc0lAikdmdqrDBDw+kQENEPCqQSJGESu70dI8l8BzxvsbOw7XzSqV5v+ySknE4PM7ZaQo26GDekSMBUbHRA1mlA+uSYTlgHc8wuYmQOzY+D85vFtstYjCdSAoMWU8CYVxOucGK7U5oGnQCqBluxmua3dvwhE7O0HCwazUmXdM9zImtR0MEegOZuRwdVDLNmAI5b5nBUCNNm8oPLHzUsb3OWXMP0W2vpn6vFI6UYfnl0ZNDUee1YC5KEM/3XlUHspruS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(376002)(366004)(33656002)(66946007)(38100700002)(6512007)(122000001)(71200400001)(8676002)(86362001)(66476007)(66556008)(2616005)(8936002)(6486002)(2906002)(44832011)(64756008)(76116006)(54906003)(4326008)(38070700005)(316002)(66446008)(478600001)(26005)(36756003)(186003)(4744005)(6916009)(83380400001)(5660300002)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vOzvaWwUQVZ8LVIORG/2quIL08GS0TpcL4gkflBg2z4ve8A9jRdHGZmrdBpR?=
 =?us-ascii?Q?3kbcegUafD+DGJ9RoeRPouboVT0Mf5QHS0ayNjZYob1WhusZ4ltljIbtJ0HX?=
 =?us-ascii?Q?060Ciu5sozYEFxoFQI/Ej0MJA1DOjYOwXYQZkozk0o7nBI2LWDXIuy9SgkcL?=
 =?us-ascii?Q?70w44aHyWiEBxQ01wM7ghZ88cl3BddVgz6YupI1zLg+zVDSIuGVlzCiisH/x?=
 =?us-ascii?Q?I/1VnngdO/b5/jQ3mBaeeFWGkcdj5TqSkXDY++Pxfvr/PBMV2dkxj9r/RkAb?=
 =?us-ascii?Q?B0sD5eEaBOK4ZSkq5aoJ3PNtF2dYK0LvbpIRBYLL42K4XzjrbOqYMBfzxOPg?=
 =?us-ascii?Q?ZbeDWk81Ld+9Tw/GtQuKQNaLCHd8OFL1HMmx9tCjc9iHsSOmaw/+PWbnLsY3?=
 =?us-ascii?Q?v0zRVIMrIsKp6K8zCeXpiItXssUnykiNQyiI1Gg8T0AzGUNpZIchh1eymHJ8?=
 =?us-ascii?Q?YkKG3SecbNjtJwL5O7NXH+iGiMqdAWQwYTb/85dG0qiUXzucaeUyjpYLJ5Zg?=
 =?us-ascii?Q?oO31hLD9zr1QQaB5gqYgjFKa+yfvh31eHVTx6TcT+EInriW+AYDonlDkXgAY?=
 =?us-ascii?Q?eQzyNvDoDlthJz0w+jI8Hj1bTn7iqmfQJ7wM8W7ejOZmVtN7z4e08xeE1WNx?=
 =?us-ascii?Q?Uqj4oJWaHecXTh+NSdzEsZJWaWGSSpm9lSlZQmd8a0U6eEpGMHu8IVeGGU+H?=
 =?us-ascii?Q?OpB1HxPLPmGLPZrL/9SEYbYWspIIM+SAVhb+zZU0h1DAY7miOxsSax/DdYhd?=
 =?us-ascii?Q?LMcwhXI3+K74+WJfXFyD6XmRjCIBRalylBQkM4/q+s/mBde6tRnG75zDH633?=
 =?us-ascii?Q?2dpet/o3lgFAtEvWNIDGwi3yl4/UTE+t8/J8r4zQKxvgSRc/vw2G3J2Sbc4n?=
 =?us-ascii?Q?hLwB4jnkKwKG272DFAPZn4GszZHX5t7P/JUSZb9FPiQy9cwpcmcqv8tfYusV?=
 =?us-ascii?Q?wVH5wYmEm9N8CDeWTR1/noy5pd2MOgXlgS/xKgBTbK+BREibD+plMvS1oknF?=
 =?us-ascii?Q?AkcigUpxN98XQC366WlblQcUw/pA6pfyFKSiXNzpf8hXjWCFd+GjIopru1LG?=
 =?us-ascii?Q?OxXAnmshySfdDldZIUOqr6JAQWC2gZup6vnSc3t+P3a4uD/sR1Hcjp9DWhCK?=
 =?us-ascii?Q?39vwSgdUyNotpomzOEYIT0z+nFp5eqCrFWXrBq216wiw75R4fya03vSu3Y5Z?=
 =?us-ascii?Q?D1TbQ5fvLuuWrQTrhZCdIkHdhI5U6ZzbWiWM660nzCnSm5th+vhJ9ySIJ/4X?=
 =?us-ascii?Q?F55ThHlCzvcyO6FVNL/I0HklubNoEkG4ZbXPRDlKCwRiAIihXjfZuttv3OMN?=
 =?us-ascii?Q?HiryNdC8XMnfyKfO7/Un7Mmn?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C035A181A74AF2478CE5CC5191BA15F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbd1ee4-6271-4d37-72e0-08d958259cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:28:01.9222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02V2bfcCE90+n2ZkqRRMkIdw/FVj7I7SVp+BEFiJfRMQCbGSVxV9v8CrrbD+8kNmrbw1PTl4HIaQjeQ+CIb0gBYsHtvC5Wkuenvv2cyUhfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050093
X-Proofpoint-GUID: 8TUNCwBJvCexkPonUzIDV87Siy93g8vl
X-Proofpoint-ORIG-GUID: 8TUNCwBJvCexkPonUzIDV87Siy93g8vl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:19 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Fix debug print of 64G link speed.
>=20

Not really fix .. you are adding 64G speed link..=20

Please fix the commit message

> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 8d4d174419bb..93ab686c7a30 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -648,7 +648,7 @@ const char *
> qla2x00_get_link_speed_str(struct qla_hw_data *ha, uint16_t speed)
> {
> 	static const char *const link_speeds[] =3D {
> -		"1", "2", "?", "4", "8", "16", "32", "10"
> +		"1", "2", "?", "4", "8", "16", "32", "64", "10"
> 	};
> #define	QLA_LAST_SPEED (ARRAY_SIZE(link_speeds) - 1)
>=20
> --=20
> 2.19.0.rc0
>=20

once you fix commit message, you can add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

