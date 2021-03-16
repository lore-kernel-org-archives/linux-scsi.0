Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C208C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 11:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9B264FF4
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 11:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhCPLf6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 07:35:58 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:49340 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhCPLfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 07:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615894525; x=1647430525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ngNguuxp0I36gq/LFTHzMkHyb6iuZE4Bo4JY0Sf9GM=;
  b=jo4CtXor/39YVBLUIo7zmEIPzexMelajio5klzsMMffTaZvtAYkNwLGP
   cKJDyZwt6vVMdMHfI3oF9rytKJqV7kLe1EYuMfgjOkk3S+w7e9ejxvT3M
   DJiCTO+JNUTakbSyW8FKrGunhQZJ8W2r2dRUqnvOBEPpt5v8QNrsLzgCU
   RlUoC3oBoX28OUa5uvH779ugtVAfpaMfaQ+iHkJxKF5EXzfS8r/2oG0mH
   IAfBAWLUuxzC0YiaX6D4a6B9g0J9H7wgEZ5jwFR42Vkv8vzD8/PoQ7hTh
   S3mzzF4mmMbJDbK4Zi+16iu44G9rIghGvyOesnqjGKOegzW59AVpPWF90
   A==;
IronPort-SDR: 2a9ZYSEJ4cB7y1x0SklFJ6/RKByC/rDZeZysbe3JBa5EdP4FdUacuO5hwOlqPkT8eucvAYCjXL
 hnBWkGsOSuFcPGMKsWaPRC0mOXpWxYZgKoXwkY3jmXvnK3QIxdT27/bQsJH6B/B1dagtbzIAgt
 nvDjBiQkH4VVCxn+b7EXSubQpwy/pbMR7lj3dDfJ8nB5ca2H+leT+FmRUnclPkcqnIkH70WWB8
 ykzlmsFPYsjK3OLUgjlPATM1Gh2MlMehNE/tu6V+A/KIj+M2KJNDvoYGpGFg4SCBVyH7/9Ryvx
 4sQ=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="266640376"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 19:35:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHCM0FlxgMl/9R/UJy/EgUa6D24LyOHAI7N2eneg6MOYwM1PnZII62Sh5xnDEyujQULD+L5H89DdJvxh4K/CefnqZw0ZvaKhbuu313i0dU+EPBQMnSKYc6oItp9qcbPoV64JAaxtDiuxtBkG5bXGuvRNeG6h71k5j6XiJu6PG7Ci1CKm9BBJdCzVKOAesmcO0ccrPaqLJ+rhRfJZUP1N4c65nC6hgiFk2Tvhcpn38eI1/AFI3jP/vpr/cTAG4r5hMxWFTm0GshqH+bZm4aP+aXUiWI2B9EwHwjgxhs5DbXmOKq6iWofhqR0yh8FOBp8a6TF/GFoh+FnvjQ/DwhWR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBEuz7qbD9EFmXOzpdI/132yLjULdpkHKIet9QPsFns=;
 b=mqBGPLL9AaoPmGmoCTGNnQwID822DzwdBZy+Dx4QrGSrvSm1upIjcl7pr6UcZYGLvzo9dOeOIyDB3fJQ+BgnmuB1SMrvZn5+Ya7rIEdIYkHX0uXpGvUiOLDnMj/UlljKV9MsEW4Yt8pQ+vTmISgVTYwjZk/mYzclNH2CwiKxej3W+RaSFemywvWVMsr4DF3JoRc3SxKt2SEBpHuDcs2krg/oJ876lclYRFXxi8pdxI1wn+s2bt/OewG5OuMBCpEK2/q2jRK2+B4zab8VS3P1p90nR//CTqLYjWKt5oEXq6xdZRruOaZmARz9jde3wMlU+Kn1+K1ETUEjglSFPFaD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBEuz7qbD9EFmXOzpdI/132yLjULdpkHKIet9QPsFns=;
 b=RLhkYbKuOBw0Df23J2yURUI4HKvhckTox5oYD+k5lWwPfmYKV0hQzJo+a0sujJu0MzEbil5OGcuOzROUd4IwcMw77WmyHg3d2KCcQQnZgtjKL9DcEm6/CEskEN0wQIpz0KuNU5CuIXOxBU3p90NoST6JV5aQmGHRE+b0gjgLTYw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 11:35:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 11:35:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jian Dong <dj0227@163.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        dongjian <dongjian@yulong.com>
Subject: RE: [PATCH] scsi: ufs-mediatek: Correct operator & -> &&
Thread-Topic: [PATCH] scsi: ufs-mediatek: Correct operator & -> &&
Thread-Index: AQHXFw9yH/XuXxLo6USxAuW9i86AjaqGgmiw
Date:   Tue, 16 Mar 2021 11:35:19 +0000
Message-ID: <DM6PR04MB657585BA3126AB8ACF97A745FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1615533260-175467-1-git-send-email-dj0227@163.com>
In-Reply-To: <1615533260-175467-1-git-send-email-dj0227@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 111fc5a9-c4b1-4605-ca81-08d8e86f9439
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-microsoft-antispam-prvs: <DM5PR04MB02660D8FE7F3D658A2E7705FFC6B9@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UqJ8f6clxzycepQs0t1hX7qewct1H5OsRvRm6LbEm6h5WvlfTnvwW/1UW2PwgPNpVzuI/RgT6H+5Pf4xf8F2lG0hqxSInEO3/F2l3F/TBR//j9pn/gOpvvIXRk7gp5wvhYh7MDPbv0kejaTNcSl2JZ781Blh+/yppVAPaXMZrlELTdr7/gzbXroOS8BPhgtzsnds6SBXoGaug96aOKYUr4TB0YKAbCGkh1703VzK7/0VM12m/rmfZSDZDarsPhzZCTWemU47EoA8O95tLNhF3tXgoi13ZTDvJeAJ3Wl+hKcZu+nEEvjrwJE1W5oXdyEYG9hPKxeUsxjI2RVARbJEeWoZ9vL32scd88Zh8BQu13XOvXtRzUp2bOloRz2FmTw9zsIC/KBJHD9kHQsPlyg3AptNzdF1xjBmCNPLqhP05kCb6ZCWd9IhlCHCD5bqEhGZwbYL3wHpkGvwbheazuT6Qd5ItvaL/DIgQixwDZ7HoPUgrS3WqZS2G4vKCILcPs+scEAHjEbh9rZHOaNMLguezWL4p9CGx76ayAWYKVdmMmkif6wfGnBB41zx+1A0HzjV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66556008)(71200400001)(4326008)(5660300002)(76116006)(7696005)(66446008)(66946007)(9686003)(66476007)(83380400001)(55016002)(64756008)(52536014)(110136005)(54906003)(33656002)(86362001)(186003)(8676002)(4744005)(26005)(8936002)(498600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7rtUFGtsBXQ0JZSku3aZd5QwhPOVqIKuk1/HbQI/LEcU/MZF38GLodVE5Rm3?=
 =?us-ascii?Q?+cFFCG71RI2d+szLEPPXFgQSU3hYhnSYnk+bcDMTRTUMMOjl42NZG1USyN1z?=
 =?us-ascii?Q?EdtSoAdFjqn2aR0Jn4TtRNEzPuY9KaUISe//L2niYU30QUnH94mPAA1bsKfh?=
 =?us-ascii?Q?CmEVyNI6DgrPBtJbBSBa/9A+MY+UpH2SM0WfzfybMMDuW2KTK4wz/67RYcVo?=
 =?us-ascii?Q?feLTI0jeHGv444DSUXuvPSSdEzxDirS6o56V992MoOSbG2Q3i9a+TWwnkuNj?=
 =?us-ascii?Q?wsReoAy2fcjpjlJGXFzZ+7j/b0tzv4HUGBwDAIj3M49LewIpUX8sMEmzU58d?=
 =?us-ascii?Q?Nx4AIufaV68TKuE3sufPxALOg/bm/AUgv1fJRcP0W31ikaePARo/dMRmc8s0?=
 =?us-ascii?Q?n+CNfASAVYv1p/dJJyvSfFyKz9rMvCTxPo/zhD6mpM8fi70jyOr86CaeG3EN?=
 =?us-ascii?Q?5Mhydc8mH7xACuV1cx914e+4pms9IaLJPxPjyX2ok9FdGtzgenYbjpOzpLTn?=
 =?us-ascii?Q?+BZk0WLhaYPJ4cUzEYKW9RiNRY0Yo6cRvYavtiN8p2KcY0/N6GvIN3hPYRPg?=
 =?us-ascii?Q?xT79DdDSExR29sXl/PybvNJ02uodGNL+8Q3wvt0VBlGcxeW4ou1v0tb535e+?=
 =?us-ascii?Q?+0B3PxZkQEhv2CbWXiC4LSxcNWJaklN+vahSeh7FvAx+iPyFAcsu+DDSb1rp?=
 =?us-ascii?Q?2zWeJcxPXyTHuL/SdhPK/JN4Ga+semISej9oo6lz9XuRcEMdSb8GjxxhHCCi?=
 =?us-ascii?Q?rGdwb15b2KGHBE3oob4Js9zD6eYPdupwOw04tJz+nvMrNwdHEhsP72zBWQ/6?=
 =?us-ascii?Q?IskIZbi8yspC+DsYxO7G6RKD426v1pUZWurbqB14Z9UJoe2L0iBMqLyWRz3X?=
 =?us-ascii?Q?wvyzwJBCdY99yWJNiwn0RZae+a8luW4emzgVsFLYG0nbHZxc0xeM8UwiCCGD?=
 =?us-ascii?Q?ON3kqSNSIpoAqLz/pseVqR2YpIkxz6dI9n2tYb0+uYMuALOnfucOHxk/ZERU?=
 =?us-ascii?Q?exIQg7dIM43EaqRMQp5bk28zNvPsDukyDnXJgEO0KvZWq5N/wEDHWyj5893U?=
 =?us-ascii?Q?7UNFV6Vt9MY1arXBk9+wkRkMRCjVmEsSDez5NJtz8dhcuVlBJIfKewoSSbuq?=
 =?us-ascii?Q?afYXzoW+a4vrmgauQOJNz2EDYx6up/C2DWlwmfuvtx95DcctyEXfi+4Kb2Fp?=
 =?us-ascii?Q?ayhDX7ideZssk6nF9X4tDKjIy7Ib2ZPOIIttLcPgoNlHbbRyWt4E4MyqPWzS?=
 =?us-ascii?Q?i7YOlJZY4o+9iOjvy3pAw2o2r5tErS+0xjDCX/D8I8f8kn/dXeypCmBKd6+T?=
 =?us-ascii?Q?+/6t/6iANeWJa9lGCcAy1b6s?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111fc5a9-c4b1-4605-ca81-08d8e86f9439
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 11:35:19.8236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8v0nlIcLfLDCVsVQ4oo4SBSsDrzT/sPxUGs1Pvg5A9RV5R0IwTT7EUKMw636VgtvF+x4eKwZw0cPQNmmqYEEMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: dongjian <dongjian@yulong.com>
>=20
> The "lpm" and "->enabled" are all bool type, it should be using
> operator && rather than bit operator.
Maybe fixes tag as well:
Fixes: 488edafb1120 (scsi: ufs-mediatek: Introduce low-power mode for devic=
e power supply)

Thanks,
Avri

>=20
> Signed-off-by: dongjian <dongjian@yulong.com>
> Signed-off-by: Yue Hu <huyue2@yulong.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index c55202b..a981f26 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -911,7 +911,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba
> *hba, bool lpm)
>         if (!hba->vreg_info.vccq2 || !hba->vreg_info.vcc)
>                 return;
>=20
> -       if (lpm & !hba->vreg_info.vcc->enabled)
> +       if (lpm && !hba->vreg_info.vcc->enabled)
>                 regulator_set_mode(hba->vreg_info.vccq2->reg,
>                                    REGULATOR_MODE_IDLE);
>         else if (!lpm)
> --
> 1.9.1

