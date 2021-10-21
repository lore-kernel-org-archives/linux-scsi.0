Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C28C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 04:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E88160FE8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 04:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJUE36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 00:29:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229452AbhJUE35 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 00:29:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KLUUPZ008628;
        Wed, 20 Oct 2021 21:27:39 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3btu389jhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 21:27:38 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19L4LwmJ011850;
        Wed, 20 Oct 2021 21:27:38 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 3btu389jhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 21:27:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH1W8djYFPMZrdntW5t6RV4DREogqW3Xii2QchyC7tTey9wpUzK5dZnZQMXARuHij9qjUIzMIncXb04c0LcKrz7wJJFpwgt7MYFcJll8mSfQe9RVEYumlmbxqD86rIzXA/veI2Vu1fnNgAOikral0ELziHoDMGpPqWdM8nLXmGrDIvN3MBo+pBxpqeLxlPi7nM+4IeJX+9ekmxU5ECEqBfUiN+4UIEYDgLNzy8O8afb0iGkmKEtO3tbyN5eOBs28fQJhmnY4u77DukZ0V5GxFba3epSaKTQjFGC7ofuJqsL1x+INxNHd10YeMO76xaT8390XmDPXKoD6BtYxQ5K33A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6z698OAcAk6uS76r1Va7eFcrgC3ISL2KW1oykeUW2fU=;
 b=Aw6dpwovYB1fQQN3h0djR4aqa9NmRsLWzwskY0F0SU5HYw0o0qDlQ1ni0K3iskazuGLOHg9BcPX5WMTFWhMG7pcm79a9KVFzZ3LE37m+Iqk80ZLdFGCjkYtFTFTeTP4qFyz28QDxVzJwdrXP+64xpKpTZ6+254AzC8wNoSMwk+5qPYCsidYmrjl6O/tGlK21+4x0YibUsnTyD1uZk86L070LsxxwrN4ubKIgg72RhADFG/CRRKti2tY2GE26lEpEjDztaP391DAi7yh/ZGB7Y5YORYIm/z8ZUAtCDbif+8xu4PHKOGryBu6Zqa42KcBALRobxxJwlVeVx+igQfFW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6z698OAcAk6uS76r1Va7eFcrgC3ISL2KW1oykeUW2fU=;
 b=hkMhe4edLaK475781+1t6+RHQXjuk55B3YtwRfY8PH4EbdHHtUYgIueWQJrBS012T2ctGt1eOWuN9RKdEOqY0ygLIWBI9i2EbS3WAzn9CtD+9r1EaSdga9ASq9wjBDzyM8rdRSFuTR8mPZuLoozLbQHF8KKtUelSJzwTgZB2094=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB2135.namprd18.prod.outlook.com (2603:10b6:4:b8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 21 Oct
 2021 04:27:36 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18%4]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 04:27:36 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Zheyu Ma <zheyuma97@gmail.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedf: Fix return values of the probe function
Thread-Topic: [EXT] [PATCH] scsi: qedf: Fix return values of the probe
 function
Thread-Index: AQHXxb9uuNMPn5nJGkKEM22Ji9UpcKvc3CLQ
Date:   Thu, 21 Oct 2021 04:27:36 +0000
Message-ID: <DM6PR18MB3034F4D2FF41DA6D60674E27D2BF9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <1634740388-27238-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1634740388-27238-1-git-send-email-zheyuma97@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bc427b5-9c7a-40f0-fa11-08d9944b1c21
x-ms-traffictypediagnostic: DM5PR18MB2135:
x-microsoft-antispam-prvs: <DM5PR18MB21350EBA2B23B92A565E393AD2BF9@DM5PR18MB2135.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeA+7+CEcI8EvLW0K55YPcSRZ/FU2ISqUfmM14d8YTdF0+S3N7Yz+7NGcqd2FTTi2yJZmffL7z7UjaTOCJWTJiog5DfQCz0m53zbviS0b/SWLghAomyI9QOso8nOCbTBoMZs2Qwr3ywrMOyL0fczt/OozcnTdRQubRgU4h4iRVRk3CQu4acWv4azRhOJ0HQ++eaU9+Hy4gTjc5KmQcCeS2heD326E9hhYAtbdIrgxLst6QvT6fmn9rJnP4sUXmbzWTgepM/Y1nmJeWkOH11aXnULgUcfftOkqlQFZtuMBuloOxhWx2pECbhmYZlvjPvie3NLvfhMYdw9cP84SnYXJljRDrIcUpj1UasfoeBo57ZR647uSeU4pVnHAHGlEOzOZ1enTMRypG2UOU2wMVAnLpQbfJCjjoZvwHSDTv1yOafWA/eTl3gkQs+KrGp58tIIIlJXWDK1cAUEl+0OQzKO9Ec5U2puvDbcfYpL1716rfahDIhbtAfwFU0rhRQkYsVITCNtzcxSr7kOf6fGmhh92BZmCEZUUfrY59K1x949ts5j7i+oRafYsUx2XskOog2FiT5e/GRte9IGRiizLmo/SZ+7Cw68IImwCfwDa2L97S3dM2W09680J/ynB2ouKPThkA7GOLPB76YuP0TGrY/lQpo92ymNyS73Cag0MvOUqZhTQVoK3c10PO3TCf5NrLC3ySxwZsPjD14lDxkYyCvN2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(186003)(66476007)(66946007)(9686003)(5660300002)(66446008)(38070700005)(6636002)(8676002)(2906002)(52536014)(55016002)(508600001)(86362001)(66556008)(76116006)(64756008)(7696005)(122000001)(38100700002)(316002)(8936002)(33656002)(54906003)(110136005)(53546011)(6506007)(4326008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T1g208ttCz2hSOae9d0n2d+t4x36lHqnFh+H7zU99Z9MKuZ1AvLLzcD/9z6W?=
 =?us-ascii?Q?UlStWs0tw/zFKSkHrsGNwW395sFXgSyyemmggjTWG6M/n+VgLDc/WDqHox12?=
 =?us-ascii?Q?Y/83VblC4eGYfMYAO0r5WvrqoLKLBaaV4qOhxZWbiV+6mSEyoxQPW/+5T4dI?=
 =?us-ascii?Q?wU8W9JYJcvvW/CyUVNXBFybGTzRY0iNPWAFtxVVgiQ6oDl9y2u7KQx0LPTMI?=
 =?us-ascii?Q?5i9UweAxSaCA2UQr5Vi7Xp1u0CUbCgWulNqMaYSMaIFigq3H4dbs8ON1KPRv?=
 =?us-ascii?Q?zGkYm4tcL7hFRLYOa9ddMvJqMYHZUbxrpTJhBQh7ykuzNNVT0zEJfUOxf9kg?=
 =?us-ascii?Q?+DyMfFaJoxZfqMEsY1/XDNenQtetVE2HZ7W+BL40t4YI5QEKJe267osGeANH?=
 =?us-ascii?Q?yN2CBpTw4ZMvOCtMo0maOI62hGFXp17VIhkd449eMHuJO+7cVU2rby4j5cH3?=
 =?us-ascii?Q?AkiIUpT/Yp9qsenJglsCTu2hKa/VFmzqhLS0nXTp594xxRTjDAaGuY5B8BUu?=
 =?us-ascii?Q?8BfXbzGYh/i99daTH7iNv1C/Ufe5Kf1PaH+YK+u2h8VaUN0qQkQNiNNgMOXU?=
 =?us-ascii?Q?nX4bw4QWa2m7iWx82YrxXrpJZcvxY8snG7mYXDyf9461FWCUZqoJNIciTEEW?=
 =?us-ascii?Q?NTxQRtfY/2E3sjiVX04Mvhknc54jSb04Jc8Kq0Jabjauh//DGU5f5TjjBG69?=
 =?us-ascii?Q?rD7/tAhsxBdY29HJwIxm95jk8CqYvYsmoVDp+RfioOb3KKST9L9ICLZhJoW4?=
 =?us-ascii?Q?SA7CjW/ieMc8wLblDCtOkXhGITv03H/Ay4bKk+pqYk7pGKWl1VIpFxD66U1e?=
 =?us-ascii?Q?KJ6ezPzWV9m/poG3LfVZ6qCdFijRSKezd6jXa3Ox7izuSBcM+XPOrSzWmF+k?=
 =?us-ascii?Q?vrI5pLuOqnMIusNAlNjtcjJ1Zh+wkQmX8b3AkyQZ2I/hvcC4enfqfvVoWuoG?=
 =?us-ascii?Q?NI5CJkoPEnNZrGKeMjyZqKc6qgOqIGh4hkOTPTvCIeR5DWm9YXAdxK36UTHN?=
 =?us-ascii?Q?4a79MXXNPcsHWOrDxiks5ic51dXkqi68tWHkbFojdJfT2qRGtSC5tv3/ncG3?=
 =?us-ascii?Q?/QZ/A7JIvdxo3ucwCMYQVXRy1uGGrbjfEttHexLHgEgQxH+sPZabhFxc1ztb?=
 =?us-ascii?Q?nfvUb2muiAC+dPOHMMkKmcr292qHONxQwGcY7uhJ+m5OzXH7smXulCej16Cj?=
 =?us-ascii?Q?jm5UV5mcy5t2XwRDafeEWzKSWBTyVhiHK2UEKal7omK5Pv5o3DYsxZr76snB?=
 =?us-ascii?Q?XKI9LdrwXKPXqNU0G1BxwWD22R3Burm520jL/LPdijDCbgiEeqvr5faBR/Z+?=
 =?us-ascii?Q?TL9lt5rIwkSjVNRQcQ7NUKxu0OmGjB4R5C5HuWCPZ/MqJW2JHbG5qL6YKB2U?=
 =?us-ascii?Q?vI+XBkC0VbYPa3n1xjNBMid4pFzU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc427b5-9c7a-40f0-fa11-08d9944b1c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 04:27:36.3963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skashyap@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2135
X-Proofpoint-ORIG-GUID: cnqadCe0JVBzc68zw-Q42oGrYotIa6N8
X-Proofpoint-GUID: 9NelQdZ98YTI_1mFFSQoS4gNJ17EcmDQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_01,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Zheyu,
Thanks for the patch.

> -----Original Message-----
> From: Zheyu Ma <zheyuma97@gmail.com>
> Sent: Wednesday, October 20, 2021 8:03 PM
> To: jejb@linux.ibm.com; martin.petersen@oracle.com; Saurav Kashyap
> <skashyap@marvell.com>; Javed Hasan <jhasan@marvell.com>; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Zheyu Ma
> <zheyuma97@gmail.com>
> Subject: [EXT] [PATCH] scsi: qedf: Fix return values of the probe functio=
n
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> qedf_set_fcoe_pf_param() propagates the return value to the probe
> function __qedf_probe() and then hits local_pci_probe().
>=20
> During the process of driver probing, the probe function should return < =
0
> for failure, otherwise, the kernel will treat value > 0 as success.
>=20
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index 42d0d941dba5..52f2a52bea2c 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -3161,14 +3161,14 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx
> *qedf)
>=20
>  	if (!qedf->p_cpuq) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "dma_alloc_coherent failed.\n");
> -		return 1;
> +		return -ENOMEM;
>  	}
>=20
>  	rval =3D qedf_alloc_global_queues(qedf);
>  	if (rval) {
>  		QEDF_ERR(&(qedf->dbg_ctx), "Global queue allocation "
>  			  "failed.\n");
> -		return 1;
> +		return rval;
>  	}
>=20
>  	/* Calculate SQ PBL size in the same manner as in qedf_sq_alloc() */
> --
> 2.17.6

Acked-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav
