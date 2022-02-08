Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD52C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386337AbiBHWXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386243AbiBHTty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:49:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB93BC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:49:53 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218IYI78011038;
        Tue, 8 Feb 2022 19:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=82DPXfoukAH3W/tm30bURtfQ14UVwph/6JvKkOyhz6Q=;
 b=IIp9nBCdbkHW0i4tVRO1q5+LyURRQ6DOu9chAXb1OcMOjLjFl6/KnC6ajZVc0Z61OW6n
 G0S5QI9luCY+zd0ftUgrMrBQA6akDSjFIW8tlyFaxfZ1dWCWDsEvC75xoVun75J5dba0
 ClpPlyppURj3uIZ5XASPDASBf587OXUCG5lI3RKbV6lfrNgdMgOn5OICpeLIQ7hN/K4U
 rXAD7MYp6RqwozyTXeulxvbhz+dxCtElefAd6dFR5HnsWXmFVSEOCD6OsyLWy+yf0R/l
 3IOmmNjmPnGwhpdH4zlX0Q8yANR19Dt5GLVjOCswKyvkpWlmTJs1fmvf4wvpsAdTvgSj OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdstff7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:49:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JjZIe195514;
        Tue, 8 Feb 2022 19:49:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3e1h26w48s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:49:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGpgyQZwDb0/bmLkfCJ+pPEmNX4lzAFHc127YGMHIMgDBBn6DyoKKZ7dMGHyIPHp1KYb3BfiIfQWMasX25jCPP0SJhTvMIGE++oExlr7wZSqfYqHA1zJpFrsxuUmOwSiTSTedSZBU/23TVcgp3kb24YxOpFJR1kWX+4UeLcBVdYVM3KFydgw0Q7K2606bYT5SdgYMXr3RJdQppr+tGOtw8I/lscr7nn8nqsZ0wqbb0LNitmtzmnXN3oXTdXAxMiITxmk7eQXF9YR7MPeC1HoIV03bQJ+Ew2rMCiCkR7F9tqGC2uALy+/yZq21CWopmY5Eg5sS8loGWklRPwWrqmzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82DPXfoukAH3W/tm30bURtfQ14UVwph/6JvKkOyhz6Q=;
 b=WIHc5QO8YLzOIKQzsfnb2tWNwXjDVtOX7yrFqnseC5jZ60BV7Mzn3+bGQYhgGEoJrO+Pl/tNh9aEKlCWAXKR017JDmyfuBqtL+X+gutbyJ39eW5t5OfY2uVNGeY90GY9ks2sfRUFnLxXDiLKyHnIeOyW/LzthrgI0c26IQXenLA0My2MlCzO/Qe/I75mxDMx66irCStPKEyLezNk/smNix6XpA9YuejZflvzLpMDLGouQDGjla1WnPGZ0J1UIoXjKypPaqhGoER3OHTTbguefxHCwbhtTx+AeL1HwDLVeytpIzrW6vEGWeWzMRKQiT998iRPjRnHwHq1wTHUZBTEUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82DPXfoukAH3W/tm30bURtfQ14UVwph/6JvKkOyhz6Q=;
 b=DsU+/ELHL8W/86OTN1TBWxaC2zmEPpdUGeqB5/uGz7C/L8HYaRa/2r9wXjDRsjRFd3SFZuEhTKetE2u5KthIIIlvqNK4CLv8AihoVi5aPqhC16+ELpdp2YvMbcAjDraR2DYlnCFu3hOxHSOwP9T4P1aNuXfE/TBhTkBSFE++Y+o=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3532.namprd10.prod.outlook.com (2603:10b6:5:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Tue, 8 Feb
 2022 19:49:40 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:49:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Thread-Topic: [PATCH v2 06/44] scsi: arm: Rename arm/scsi.h into
 arm/arm_scsi.h
Thread-Index: AQHYHRE02JDF14c8zUKAB03pGT6rL6yKD+GA
Date:   Tue, 8 Feb 2022 19:49:40 +0000
Message-ID: <5486CDEF-2E08-415D-909E-CDA54004F512@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-7-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fc6ea16-3bc9-4ecb-0ede-08d9eb3c2552
x-ms-traffictypediagnostic: DM6PR10MB3532:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3532EB0FB59A60DB25079C79E62D9@DM6PR10MB3532.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:212;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EAZHaBgYayRMZmT3fp0e2rHuY15QoboPoPznA5LeMNK/zMsWvM07Iax8IGmldVgiQED5T4mqu3EqujVg5sN0V+ubjvsXKVsbudKtBOcWznXLMcaG+0Elqhuyzg8pi3x1YQ+a4ApCNqToI71GN4WSE4/mn5h5HSh0ztsRWkk5KRCQtHANuXZXansv/P9oVuhaz8CL6NLEM8SdOCouESnbLW0pUpDgjDyfq8OR4HeaS2f0NgNoqfallZ6SB5b1RbucSAZWn9AQSSowEciArKPOBB7uQrJ1APOR0kLE0bMn96JbOdi3ZZKdfArLsCAGjFpft2tJT//Iy/D5MnLD/dLXA/u2ANNJk1yS3hcsfqCGyHHtLUxMTn8WGQzRtioXF8au09Kf0vDPzAmseK4H3oJgoVf9MHENSUx9NlkPLieZmPCFfBWZlN3WmYuyjjo77mba7sR5d+OpmXY3jo9r4yTPy7mOUUdkaAjT7Lu1L8RitJA3h9+cJQN53q8g8ZXHb2EobTwfgByl1VEVGUZL7y7hJlzwRIJ+ESjMQP+Wo3aDkkvi+i24IfF3SRNIe6OmABDYUsu3qOdgyTSp7AfxEJ5ktO2yfIZ5iwsiQSN75JpAuD5q/QZS9Jr6AbgyEpoYPOqsdbXWdAwRX9vXLnvO9PKBPU9iZY1BHrZ8cGCE4esDZpv2REDvSBbwmrPY5u+o+Cv2fu5ap1Bg02DlFGSmJ7jc0NYv5/IyD/bnB6hESs98gb7nvFF1HuHwkPVeCM9dM5qW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6486002)(508600001)(38100700002)(53546011)(6512007)(4326008)(8936002)(38070700005)(36756003)(6506007)(2906002)(83380400001)(8676002)(44832011)(26005)(5660300002)(86362001)(122000001)(66946007)(91956017)(2616005)(66556008)(71200400001)(33656002)(316002)(186003)(6916009)(66476007)(66446008)(64756008)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ozIUNElu7pM8nJgzceEsOGV5naezdlfmRzJmaaU5ITwgwqEWEG2bAqf8tGzM?=
 =?us-ascii?Q?0uQaRakzVtrYxMnNgR59h8fn2rtk3PBt0kdqqB/Pkk8rn5Zsjqlg3S/El4ru?=
 =?us-ascii?Q?JmJ+H+BIVRk1D1M+E6Vlq61rzAvvuNQEX+LlMTCerihUW+XdXFJYKqfEruP4?=
 =?us-ascii?Q?OGa6p5bnEc2C06qG4NNwy20nVaSaoeEZ+1R2HXL8z3k893MxP7KPQDkfraOL?=
 =?us-ascii?Q?7YpEpuaIEIEz+bMlMPSaV8El8tP+ytbtYVcuG3GQgNgJr3ZLUULbh7A7y748?=
 =?us-ascii?Q?UqB39f2h6kF0jKuL7lX78bAxXrhvkNTLM2DQf2RpxXgX/USyZ2ZyEONYlHsJ?=
 =?us-ascii?Q?XAU439VXAWSuzxOgfjiFIfvDq4CGeYvlecGLYTQGP26hl8hSI4UgnwmpUHpG?=
 =?us-ascii?Q?830svVWFpYzia6oQD5juCr0j8AmrOdxFUpAyAkE0Z3jjZxmuY+yuHnbabOqz?=
 =?us-ascii?Q?uQxHefeLoRKs4A6HWI2qVEsGPJVc/l4u/vJ7Sbzh8zt0ToumwXXYGeQDJC0S?=
 =?us-ascii?Q?dakEUC9aUk71LIJPm27Yer7AEyGeY+vxkPm6UDqj+PNAFhMLgXkMV5oDD2TL?=
 =?us-ascii?Q?exp8t7LPRF2tkVPe7LxMSe8LrLJ98YYn2KLCQYRuhLGdiKAjkbVgb2TScJGv?=
 =?us-ascii?Q?Sz8+9eDLtckkJWMMC75EqIUO+gNSWi3hs5vlezyBXJmZzRKadnQWYI3QKg5a?=
 =?us-ascii?Q?xgPLYgYw6WcTRbk54Z+N8pwysG1VucSEC7AH4Ve1AHKyDsCopICXLYSKH8cs?=
 =?us-ascii?Q?fJ8fIjZFAsCM/CAofbTdkZkdLlCrp6RvW5Ben8zkCTM56x3jERQY4HRbnOJW?=
 =?us-ascii?Q?iP7DjT9ANH/BR3EYK33NM84dyzVIVsObfL2gzDaa0bAbOBU+Zv+1/GPnmcGL?=
 =?us-ascii?Q?1ir+M/XfjdSWKVYCUFBMaGxFuJLXUB4NfRgWHn93vYDRXzkMfM7v2RgEPhZy?=
 =?us-ascii?Q?0uY9OifU5Fx+SnjBulugK8RgNTbSYH8ZtBXr4XFhyXXVGj0fOHzJH8leiIeo?=
 =?us-ascii?Q?pMzamSslhxoY2yBVizSTx1qdzcoBv9xmPcfpHQlHqkIchCU9thMYvNPTri4W?=
 =?us-ascii?Q?VvGwPlMmcjsUmNcc2Db6O07QNaflmdoF5z7jFhLSh5QDYLdwEvlRj1HBw+Xu?=
 =?us-ascii?Q?fC83a9MAbcF2zB0SGgP3J2mmA/bhS8kaeq9b7q0tA41JsuiXBNtrIk9l3WFD?=
 =?us-ascii?Q?cvRqeX/08Oxj98ikTp+SyseH2reyb7Iv/iHsKvpDO9iNLxckcKSTfX5EpCw+?=
 =?us-ascii?Q?dlwal4sYUviUdtvsLfXQIm92raQAnmH0PeKeQmUyqQ1jKIlKS3Om7GQQjq44?=
 =?us-ascii?Q?eucQy6VMnZ4pAbLX24j4hDaaijJPa3oCzBRMeCb4oF/mbQm8uyvbVCr3gaZu?=
 =?us-ascii?Q?xim1lNOYQuwXyXdiJFl7J6Nq6fDX/jXJo7ckfvPAQzuTcipBgAKkCfyHGuHS?=
 =?us-ascii?Q?U/y6Zw59tiCF6+zToeUD8OaS91ItkDBZhnMIGHc/JSclZ8/gaCKR50K7uG8o?=
 =?us-ascii?Q?CzQ2BUZ3tAL2pvm4hEfuOMzJiWxfftyu2H9tT4rpisQlUG3qLOje7S+bReB4?=
 =?us-ascii?Q?aPQFROKaOD5T4U7/d3otlkfSfUPdUiGzlI317HgZQpJLUCTH1FAG1sximHsi?=
 =?us-ascii?Q?PNVFdm55UGrvtOT0FnO+XnY/Pxl92n2ARcShlm2E5QWo0pabcDXhX9q3tiVn?=
 =?us-ascii?Q?CRrwEomi0sQzE0qDSS0q6rtffvY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3516FE15797C0745ACB60075B03223E9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc6ea16-3bc9-4ecb-0ede-08d9eb3c2552
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:49:40.5398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yo76PQzmJX0bD8FMuOxRFO9KMfgTKE+yHZuOfFic60njDzTkfcz067SuHUc5xQBR5SJ5OLBw4fPNn3O/dnefNqJpkfJRHJnjLRdtPXiUHeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3532
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080116
X-Proofpoint-GUID: Nl2TGOKv60UqJeXo-q3AKCBAufRdXYCR
X-Proofpoint-ORIG-GUID: Nl2TGOKv60UqJeXo-q3AKCBAufRdXYCR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> The new name makes the purpose of this header file more clear and also
> makes it easier to find this header file with grep.
>=20
> Cc: Russell King <linux@armlinux.org.uk>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/arm/acornscsi.c            | 2 +-
> drivers/scsi/arm/{scsi.h =3D> arm_scsi.h} | 4 +---
> drivers/scsi/arm/cumana_2.c             | 2 +-
> drivers/scsi/arm/eesox.c                | 2 +-
> drivers/scsi/arm/fas216.c               | 2 +-
> drivers/scsi/arm/powertec.c             | 2 +-
> 6 files changed, 6 insertions(+), 8 deletions(-)
> rename drivers/scsi/arm/{scsi.h =3D> arm_scsi.h} (97%)
>=20
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> index a8a72d822862..38aa9333631b 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -136,7 +136,7 @@
> #include <scsi/scsi_transport_spi.h>
> #include "acornscsi.h"
> #include "msgqueue.h"
> -#include "scsi.h"
> +#include "arm_scsi.h"
>=20
> #include <scsi/scsicam.h>
>=20
> diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/arm_scsi.h
> similarity index 97%
> rename from drivers/scsi/arm/scsi.h
> rename to drivers/scsi/arm/arm_scsi.h
> index 4d5ff7b4e864..3eb5c6aa93c9 100644
> --- a/drivers/scsi/arm/scsi.h
> +++ b/drivers/scsi/arm/arm_scsi.h
> @@ -1,10 +1,8 @@
> /* SPDX-License-Identifier: GPL-2.0-only */
> /*
> - *  linux/drivers/acorn/scsi/scsi.h
> - *
>  *  Copyright (C) 2002 Russell King
>  *
> - *  Commonly used scsi driver functions.
> + *  Commonly used functions by the ARM SCSI-II drivers.
>  */
>=20
> #include <linux/scatterlist.h>
> diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
> index 536d6646e40b..d15053f02472 100644
> --- a/drivers/scsi/arm/cumana_2.c
> +++ b/drivers/scsi/arm/cumana_2.c
> @@ -36,7 +36,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include "fas216.h"
> -#include "scsi.h"
> +#include "arm_scsi.h"
>=20
> #include <scsi/scsicam.h>
>=20
> diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
> index ab0f6422a6a9..6f374af9f45f 100644
> --- a/drivers/scsi/arm/eesox.c
> +++ b/drivers/scsi/arm/eesox.c
> @@ -42,7 +42,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include "fas216.h"
> -#include "scsi.h"
> +#include "arm_scsi.h"
>=20
> #include <scsi/scsicam.h>
>=20
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 0d6df5ebf934..a23e34c9f7de 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -55,7 +55,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include "fas216.h"
> -#include "scsi.h"
> +#include "arm_scsi.h"
>=20
> /* NOTE: SCSI2 Synchronous transfers *require* DMA according to
>  *  the data sheet.  This restriction is crazy, especially when
> diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
> index 797568b271e3..7586d2a03812 100644
> --- a/drivers/scsi/arm/powertec.c
> +++ b/drivers/scsi/arm/powertec.c
> @@ -27,7 +27,7 @@
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> #include "fas216.h"
> -#include "scsi.h"
> +#include "arm_scsi.h"
>=20
> #include <scsi/scsicam.h>
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

