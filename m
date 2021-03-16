Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDD0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 13:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5465D65053
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 13:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhCPNzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 09:55:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12893 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbhCPNzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 09:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615902901; x=1647438901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IgGea3qWpcX7OhtkQNYbRNE3kkuWA1JYNhwOSN7gylw=;
  b=ZckhCFpxJvIR/JacbmfmuK7iduFd2dfij/e7999NytKjPc77sqoXJ9Ma
   StTRjuykhFKp5yWtFOko0sEODwBb/VoLjaBeW06yjpIwLo3p0N6KN06np
   ji3YfVJnZnTMG5yBJBKxAmMm9HGX/wfb0BlnTBVSKWs+uasV/h7h5EN2P
   NAtu5BPLIBQtkqbYk5rvlEGuhFOFVxt5k5R5U70LGAEaK+qkydrLqwOHb
   faPNoTAyAUno0G4I/BQKzdhBdYeUx2jH7wfUpZGwVUYg3T2D/djoezubk
   5MNTSSjiDqjrpSyNi5pvsHkc76X4U+xU0N4BPcC4qjz+/2iRcVBjrOwxo
   w==;
IronPort-SDR: yc8wcgqBcp7o1ZayuRoXaeNuqGXjsXSWxxROyb4niJptcZGLKdMCnWPFY/aelqs3Ip4rVEl3W1
 WIX46QsFi1U51FeZHpxeRJN4hZM5IKBtsylpIjIKj0hdr0qP+zIZDWgqzWcFvW5r5ZBX44p9SV
 +7GSHJOFdfKAVNbxh549RN5yGk3U/1Mhm1H1VHb8lqJYnbX5QPRIcv8mwqKvnzMTrIABvgv2/5
 9RPuRbBU5lc2PsOjJTQonQ8jVZQNC/Uejce4RtuRVZRX0Qx2TKAecUIIX3HrRkYkAgJmWYFa37
 shs=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="162241079"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 21:54:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9DDQB05c8vlgec7SplKszFiAe/38kfHOxaLICrWjGVy60g488W8WTJFEGyplOgjYwEoG5vxUV4BTFO0RM1mjKn9HBd/Re4t+ggYgFgDE79/sDiMo4q99Yq77UW4LX5gf3GTyeAl6dCd0rG+MX8qZxsPsOo/5PA6vl+d8GH+4RUNF0xvI4hK4oJcNQkWSne7W9hKEt1rOT9jwb17mwEh2A5WsIqwenCSCSOLh8sYNYaf1S7JLIpmtT3etx3uttfg4ie6xL5kR+mJq8SBTktynwO0WL1G4w+3y7AY0OLcohpBCydW7WwLneR3DEaIuctFDI46YCT0EgJXKcSOEHyqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNBTelHgiiN1WHmELsgcmrAiaPjSWZ36Pr+uxq5Sv7g=;
 b=UBvZ0I1hOGJxis+D7l+0bCDjtA5Ds4cNucXxx4nEW4PGXvOjEVl51I1RQh7qvCqM83GV5FVD2Cjo2J+BYY9sHVvmeHZwcgSi+Bdr1pDypbn0XOVL4cKzp4a9tl7TVPuay6XKGxd7EKVmtCGsW8Ix7LY8I/cn179ZVh12tpxbsbJDzJdZidSfjfXH4hQm6dhKUDdZgQHyTv4RMrf6xh4okzK/STs9+ubyXxRI0Onr3H7ewenEBMY3XkcKNOWzMcCvM7DZxNKOBDDwhbn9xMP9Vir5dYPoebZld1OTZPv72yFa4GTGW/VHaMfoFnYHVEAmVCVdJpQtA4aVihf0iHXkdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNBTelHgiiN1WHmELsgcmrAiaPjSWZ36Pr+uxq5Sv7g=;
 b=pF2yq4PKyqwFeR2U+WaQ6jQvi7EUhXtPRbQB5L9g2fhpOCvglOUV4BnLaPOATewMTy97QJbfPCkLw5j6qyGBFfUDgoW/ynomZBTUpt1o84GLc6jNmTKvLl6SI72/klqsDD2TQD3d+gmHcSFjha6emDolSRGFvsTKK02QbaN7zlQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 13:54:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 13:54:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jian Dong <dj0227@163.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        dongjian <dongjian@yulong.com>, Yue Hu <huyue2@yulong.com>
Subject: RE: [PATCH][RESEND] scsi: ufs-mediatek: Correct operator & -> &&
Thread-Topic: [PATCH][RESEND] scsi: ufs-mediatek: Correct operator & -> &&
Thread-Index: AQHXGl5PUX4qgCCxxU6gAIHIgYrG26qGov8g
Date:   Tue, 16 Mar 2021 13:54:55 +0000
Message-ID: <DM6PR04MB6575A95D32F0F8A0A7CF2DAAFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1615896915-148864-1-git-send-email-dj0227@163.com>
In-Reply-To: <1615896915-148864-1-git-send-email-dj0227@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7b0fa49c-3611-4194-b9cc-08d8e88314ab
x-ms-traffictypediagnostic: DM6PR04MB6589:
x-microsoft-antispam-prvs: <DM6PR04MB6589848B337063BE71C73E60FC6B9@DM6PR04MB6589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E8bDEURlWf1oymBUvhl0U+vF8SLOSL9+GFxd1h2F5OJwtEtvpedm0aadwfsQMGnwtaZqaCm6QCLTASd0oyMcf2Cg0F1hC1p+Ir3cS1M8L7sI5xe1MbmayZbDA8a8okyjG56PuUs8GUN0Akelq7gG4yYsDdfDHtOkCe73mZT0iW1+U5dnJSIsYz02B8vBeQ0YqMJTFBuxsC819O7lv5zAeVoJE9hCp6ulrQTWo5olvquwjfOJIiFqe/AJX7mjvUWp+iKhYQGzliWFrTGdAt1Au9MoqDgYSc4NZcI/09X2Dwfol4bsTxEwszCjkbWnSGyfQo1ZS/L6eXSp0eMBe7obc1FqvHvB7oi8ji/VPZnvscn8ehdDPKNoMRAIpWfR/n0jhAHrOgYiCbrT7tAnxOJ0N0rScYAkozXPXfvL0nzHSW9K4REqHnOYBf8GhAbftkO47+IF+7MBNy+2+uzBgCibm7L5FAqlx7/22oCl7uHNYbmCs8xiUTCTRu/3Uez1uSVKvZV3fyMeEWQsSwHmW7k2I4hhIXaQMsxONXu5nl3PrGyEakgkqXiBmYTm8mGb+mKF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(396003)(366004)(346002)(6506007)(26005)(83380400001)(54906003)(66556008)(52536014)(66446008)(2906002)(76116006)(8936002)(7696005)(66476007)(71200400001)(8676002)(33656002)(478600001)(9686003)(110136005)(316002)(55016002)(186003)(4744005)(86362001)(5660300002)(66946007)(4326008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wkjfXehNf7K5Rr09jNjajcbX3UoA8dcK3yUY2OCxOKk+h9fqsh1TlWxbMx/I?=
 =?us-ascii?Q?RgweEjVixsSYRqxZEbZnojJZJ1Xi1SM/7e+0SfKA5st0nbLORgp9S1Pgk6eO?=
 =?us-ascii?Q?E3dMTRvZldxQJCBI1m43SBN+j7MMHdtZ0BK7O/nM6mRSsxYLsuh9hof8Huvf?=
 =?us-ascii?Q?w9k5ToLcLpaNLo8TEkFZ6fWdYqi5r/dFeBXermnHEqyiX8WA2vw/hMGSBfok?=
 =?us-ascii?Q?qtFNFEW8JislYeFtLeVvid28Z+aWix3VH3QXwNdGMa6ht+ru/D7Kh/uTS7fB?=
 =?us-ascii?Q?Riq7bDd6E6bdrWcBE7mn0qgYtguYYf8Lr40lEoOTyr412jOlwoM7EVas9Yep?=
 =?us-ascii?Q?N7Pg+qYfhhpYyODq5EhaQTr2pASFuu6FTLJDYGXFQtinI184kWSuJtBVGdeJ?=
 =?us-ascii?Q?2XQBgND5qbvccIA8rByzuU3kjRl7zsA16l9+wbw+jb6TMixPFeDOoQ0BW8Kf?=
 =?us-ascii?Q?7gdEar3TBGS1j7J13bdHPQhYZIr/ZT6fls5Rbjmo2bTAZHyjeq9rXq7dDW/C?=
 =?us-ascii?Q?/fSUmSGL8RTB+4lOlN6UHuDNGzehRXAd/xe+KadytSujsxAzG9DNmWvTS+C/?=
 =?us-ascii?Q?UZ9WCQ4eOKdl1S5ARQtL2O/xkxGS1OFD+r59Bjb9nALe6nj5a2qVuoKGZ9fl?=
 =?us-ascii?Q?3TJahMsU3ZuOQfBZt2KNM5AJA87n6E6PzeXlY2g99R4ZnlkOBvL1hVqGarX8?=
 =?us-ascii?Q?Mt+Ud+jCjyIowFw2A0mCZpjf5oUes8X7S0g+olvFK5V3Hlr/MXkXgWzF+v7I?=
 =?us-ascii?Q?bsl+9QrrMIqG52G3hIgz7e+c3qFZXNVfvA4qyqv55Lwgqz9Y4PvdDQok9xGI?=
 =?us-ascii?Q?Q+uwZcyeSjrpON8gIYXMHpk8KdSohSxPM8kTTh4sR2DtqvspL111FUTOXJ7V?=
 =?us-ascii?Q?Z2JcaCD783RJJpVNCV2FqH0iSRjd02O6/VCCUMg1DWFhKnJ/QhiZtl81lBxY?=
 =?us-ascii?Q?2yeLFJ4BOfPAZFliAnGn8PFwuPUYpUmkLCdOD+ns7jdY2cNY2aoi0DOXwNkv?=
 =?us-ascii?Q?/jtjABQka8XeBo4yscTajIAV6FHREiNgce2eKwWa7Wtw0+019zeLQlmVIbpM?=
 =?us-ascii?Q?8tTjw8xvYKBCl1cJbeDX5b5p/Bf3zDqXmIBIwhTeMgCdsUaxdaV2Fw9t5uae?=
 =?us-ascii?Q?r4AGv9QXN6mmHNrHiUxIg5cFtu/aDO/68/QEdQ89cevlFuYsUBK2t/fja+K5?=
 =?us-ascii?Q?jb1dh+2lYEXlAZv+cwsCgZIW4xhJa2WwUgNLYk1JsghBw1R4sQThYLC7MBai?=
 =?us-ascii?Q?52pDBvOxEncBfK+QZYVGn7Xe8DfSZCno/g+/P4xXqeZh1ySDRl/Nki+jcEte?=
 =?us-ascii?Q?xCAicptFoqp62HJ77RZUgHF9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0fa49c-3611-4194-b9cc-08d8e88314ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 13:54:55.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dw1LtxA07GYE6T+l3LKffS9xN6M3K/Sdu+8hlto+HmK/F6UVELFk4GmEWICcShis3l+85RIx+QyveX7NgcspZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: dongjian <dongjian@yulong.com>
>=20
> The "lpm" and "->enabled" are all bool type, it should be using
> operator && rather than bit operator.
>=20
> Fixes: 488edafb1120 (scsi: ufs-mediatek: Introduce low-power mode for dev=
ice
> power supply)
>=20
> Signed-off-by: dongjian <dongjian@yulong.com>
> Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


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
>=20

