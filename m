Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF97C07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 05:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C49961A33
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 05:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhGHFxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 01:53:18 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28824 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhGHFxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 01:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625723436; x=1657259436;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V1rDt1iZSLL4EUHbiy4OaE9suXHc/rtkZor1ur2OvtY=;
  b=m0l8t4WTLTVLNoUXaghL6Rp5J9KBRfiBd4wOSbWGgyCb9PKxg8Y4RXp7
   rP85o3y8NQw+WH9hXKkNrHyrFvswgbil0HLf+kkdhxzKz5CmzAVmEro5T
   G0YCt4rBzHnhphCMUa0aPk9VIZhE42/vHHNOrKSEglMTAitdStA2LewxE
   ttm91ekf9VFQ/rq/aWYfAS50tgI8Ep/1iyAheNd85Od3LiszxHsZjakSm
   zA4waNWFwaSakIdHLBUE8jIsk0aqSd1PVYXPIhUsOZclxIpXNtK4LFTQC
   LV0nR9ENgc8wIRZBTvuaviwp2WA4r1wvVwRsbJO9zLsdFG5avqwTMowpB
   w==;
IronPort-SDR: dhfk4y0MXbqb7YhSG8+yp5Lfn3P1cbr3Erg3jvrrNqMvEe0g/DzoH5sgN2CABqS7bdqgOAr8IG
 Z+Ogtllhj4F7CGNZ/3ULEf3QamyFqYDk8GAOY05Kttl1VMdUj4NkcVu15CTKJDjYNtL6hhRUWd
 /sx5yvE/gSxv0cgOUYpvNbvHA3+p2/bi0H3Ipm0USsTNMtC+1/dqtm0mKi1DOdF8fIk1ClVCz2
 L5TQQU/6S/udrUSN5HCTUXD3whkIN0iqe6ZlHnhId0xmowJm9hhyGoLiBrDLdUGkp2luxoGlsW
 fuQ=
X-IronPort-AV: E=Sophos;i="5.84,222,1620662400"; 
   d="scan'208";a="173251784"
Received: from mail-mw2nam08lp2173.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.173])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2021 13:50:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPOle02ZAJyBZJdggEOVaf9yVzGU9ZQ5EaG6mfTELOy/R+mVzpKNy7kiugchiF0AVlI9URgPBgsE+ME6Tl8t26DtKAH5bgmOv1AFLFQoNe95nE5hO6eIiUzGSstOaJhJkcPEcTXFOZoclW57QpOz1zqMTQscR3SXDnKBQ7PU/rj9geVBF63L20MWUkfDJQXLSMFAWgFMV06O0tA2l1V5b3NUvX6F00c4zNkDbiHU0A2qjnig+lOk53w6aTbSv+pmTfHna2BGdMVzvkjLe+earYnnacM9dB42IR4Eq7CY8OE6Z2/Nulua2khqu3VVgBRUMyD5wHWeeo/oTW1v8baQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1rDt1iZSLL4EUHbiy4OaE9suXHc/rtkZor1ur2OvtY=;
 b=RQcZglH9Xp0saPuK7r+6RCPWfCPHdv8fgagamS21JHcDua8OSnO0rlfJDqR6A5vd9xVffb2ZhoTK6Joe88uwhfYejqlfSf59b1mPWPWsODrT+dUjclkU1lTPxjdkV+m0447hKsqLbdZWDqOawsur4qA4ZliPQZp17/lXHp/wZmSaiPyrKzadcprtn6M/G4euq10MnDohzdVPU5UCU+7arVurZxbRpjnsX9/9AC771qgjgmIhvx4weU1yZMODbRmXoz8jJBbb50K4bD50derzxpaKDI2xIO7FcBlIe4IXZS4aXnnkHwbZGt5c8tFue5dRwP5/wtgaM1BoxgKaT7sEQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1rDt1iZSLL4EUHbiy4OaE9suXHc/rtkZor1ur2OvtY=;
 b=KHTP7KjhEDiFeHdiMKuSc5u3wkxO6rWyZFZgs2eNvRUPtLLZK3rq1JEX4ix4IFZp2aAKn/2W9ODRQbrcQ0pd59AETF6hCN4lJSWvWOVXaGSq1haUDTv4d/C4DcEx2s7wxRFm0l8HM3j2xQspfHGyLSRtPAgzof8J0kNZMtInYro=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4490.namprd04.prod.outlook.com (2603:10b6:5:22::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.20; Thu, 8 Jul 2021 05:50:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 05:50:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 07/21] ufs: Only include power management code if
 necessary
Thread-Topic: [PATCH 07/21] ufs: Only include power management code if
 necessary
Thread-Index: AQHXbr3jMnxoa96Wj0aJd27JZ3PPTKs4nKmg
Date:   Thu, 8 Jul 2021 05:50:34 +0000
Message-ID: <DM6PR04MB6575A6513C3337765AFAD001FC199@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-8-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef29b3f2-b765-4bda-8240-08d941d44da1
x-ms-traffictypediagnostic: DM6PR04MB4490:
x-microsoft-antispam-prvs: <DM6PR04MB4490FE95BF7FA08980BA0275FC199@DM6PR04MB4490.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bi/GRg+6+aa4Qn8UKqd1D/wtch3AV9DcsTuCXQ/0USBybsCmCoxMsPwOXH6RimqgwUOjGHr6wNTMS8TPYQ+m6rwNevlHsZmerJo0LoaYKif0U5L3oJqZoP0s/iNncfFUxcFD5UTmWmEnvn9FijhD9hnJeqrTSWzLTqPv9DnDDPJyJMhr0fRyj2WD8YXPn7mRFP9hstr9tCNaO5MbzyK/xLqFClNCReJHavStdcDXb1hjqH6/3QISzcFrynfqc2O/DcY/j6R0nvSYmdteBC411rTBvOGXtjgmeuefBLzC0yLKp/Rl4G9lopp/zMj329BVi8V5e3UHM6176D2ZcCg49hgU5fjZF0BqgXtDrlFkiIexbejyN4rISS/4W7eX4F9l9x6GmAcKr0AqFrvVdMhEU6dpsCGo+hByfKKz2n0wHTTrM3/Li6Gz6K9SWh5carcwYs0Gvmoa/q9f8OyOGzVk7GOL9eCvLleFzosVMbe9YJkTtfyNFcYgJXpiW4s40aXU97bzoPaA5FTAKoZOBB4vcLuyweF+XoFs+hhHoxaqeYYsifTDDoI17EWH6qxSpFfa8eCmMxPIfEuocaT6LeCEEirSrpktX+PIy0KGp06nXxPHq3QeAMjDKgPKiRdk7e5dAv+gXk9OZQYkkhb02n6f0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(7696005)(54906003)(110136005)(26005)(478600001)(33656002)(2906002)(7416002)(5660300002)(4326008)(186003)(316002)(8676002)(71200400001)(122000001)(9686003)(76116006)(52536014)(8936002)(55016002)(86362001)(66556008)(66946007)(66476007)(64756008)(558084003)(66446008)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8auuPqmQg8hdeZtA+sxLX6VnsQNKJoluZ0pwVPrjXFKjpmRU+KJcFuRvwa7a?=
 =?us-ascii?Q?1/MrpvUV94hAJNsYeNTYS3cf7n6rx8PZivJtnA4xVLSj6VVbS3XIdZOau7dm?=
 =?us-ascii?Q?JIEWNZR/5UWQlulc08sTcKHcu+FRoydGn22mVQCKiOlsG4k1YEykGKA3u6Nn?=
 =?us-ascii?Q?zhdAuTtGJvJZl9cnkA4aursxIXkaDXz0RKg0ygiMCSCNaqV+g0SskkgL9gGG?=
 =?us-ascii?Q?CbgOPGQFvdLdfmWOYEIFqxizENyJbF5sJr+NiMenetiGKYUCvT3L6ubzbbbS?=
 =?us-ascii?Q?mwMaiNEhjMZ27gIE3GaMa6y7m6t//nkODfBYrCBsAIpp7OFeFuwA3y2b1NO2?=
 =?us-ascii?Q?iYM0KHTXuctva4pEm6vUOfbHnStpk3idWaiULPTIgugj94AzKuYbVsf2x87t?=
 =?us-ascii?Q?qv9+e6R88eAK9uF/rWX6HKn6kxIT4hPXnGTQjaSLpuHV5foLhZslBConEeVd?=
 =?us-ascii?Q?QYDcxQedgMeU64lSrA1L8zvI6X3Q67BRrmrMO8L2ujTYheBBfsRNVtiJkObV?=
 =?us-ascii?Q?Fvp+rSusGND7HBEAATtKFrTgUeN/HbgJRtoeCIPWWlGL61LiC4rOkSkMuFSF?=
 =?us-ascii?Q?/xnfz3qaRE3ky5Uq30bfmHhNdADBrjgt5s/AJiSo96RcC363A1msRcctQPni?=
 =?us-ascii?Q?4aFeTwwJWRt2//2jpjfvksdzDoDPqNXG5c98XkH+qax6lUaMKRR4Qy/JIrGU?=
 =?us-ascii?Q?oPAf73tpTFYVJicxA2E+iRCvvupyXmEyS8NTCwIwp19RFDipWZzE+7ICkUt4?=
 =?us-ascii?Q?UHSrvzxdxKf6U2tNtyLjg4WXdPaZylW3zGcsUStGqpmctICswD7LPNEBYSUI?=
 =?us-ascii?Q?bXEj2j8cj15qGy+d2cDzsxMWT49NHnFd87V6W8LqX72PybWpBDmUW14aKxP4?=
 =?us-ascii?Q?3zrtByMOK8UkrShkyFOW46vS42KHS0XnQQlqfcekl/3Zt2YB1EY8i3lnhA9T?=
 =?us-ascii?Q?XTJKi8S1WA9hfNk3Fofs3s4anoaaNb2QuL+EtCkv2va/ITYQGhHGKtjyCmVM?=
 =?us-ascii?Q?5350hbNswByo9mbd6IiUYX2CqRuBJBYPEWc98mRTSb29OsEP/6KdiZqoAfrI?=
 =?us-ascii?Q?gxJIASmvH7PXLiZFSy6f15EK5uiFNoU+MzU6KZ2bRMmkBocOREPbbMww6kYc?=
 =?us-ascii?Q?gXt0fDeYvV2O2rM1doEyhm7QenRrwkQBFKdvvgBuBTRySPL7FJU26dWqnNY2?=
 =?us-ascii?Q?QtXzb6zM8rahk6Vowkf9x7hbWzXHYGpp6uMMr1vLfdLaeRF0CHiWbh6wEFlx?=
 =?us-ascii?Q?e5UGIxPZTfTpjITDIucPKCdZw5Hq0WYo9DizVtUfK2mTuDXJgxT1pj+fewzk?=
 =?us-ascii?Q?qeA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef29b3f2-b765-4bda-8240-08d941d44da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 05:50:34.0500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHUTDozQh3M8F+YJIY9a+69yE6GlDJSPEVIDbYUdJq5yZbagDNAl7PaB1dPjvzzlSUY820ocpe7F/UJAQxbPYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4490
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> This patch slightly reduces the UFS driver size if built with power
> management support disabled.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
