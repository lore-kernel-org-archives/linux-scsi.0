Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B636AC3526C
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 22:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D6C22D02
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 22:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgLTWDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 17:03:24 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5550 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgLTWDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 17:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608501803; x=1640037803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NsP9KppwOP6Xw5BYDHKTLYODrOXpsDVxJ/C0AEMkesg=;
  b=dP5y1k2TupFlZRwvaHFnXxSRcIuMKM5gDG4TfegG66V9Yh7BzgPHjaxB
   jfB9OjXT6CVrQNNUXAY8nUyFxdtzGz/etmCL8W+KtB0BNa39Mam7PkOjX
   jmysp9x64rcLlwJbc55BH3w0Lk5OMwE37BI67q+2ndpOZqIHQDPuGEEQh
   AUFdPUEp0WlHumFHHtjKAxI5WMLPz5hEQOA98BUkuy+Osd0iXryryWoYz
   QwdTVfB5Ie4ixQ0vj90MURP2yJsWODR8zWXXL5S2VwSZJZYqMN0TZYX/4
   c5fDt7/maNtF4wXE/jQuwQCfMv28pUAspwEQyo/TPonb9n5w0NcwoRBYG
   g==;
IronPort-SDR: fCrvGApBrkxsTXtoSGptxDbljUwegJNbW3UkU0oHO2MYEV8ZYTmgLN20CZolgbc3YtBSguxBg+
 AsIrPqCUS7Rq71mR1+ycwBt0j06dMFyvTosv6vnNKLzqLMmEVb9DR0Fv0iw5KelPrsrGJoDsIe
 yxESbCS/5YvjbVGKk3l6miX+h0rzWqvQEOpdSlvDM/nwVZx0KFPMikBD/dbBr0ntdihrClmJnj
 aJJ+RVDiDw2La5KPOdK1qE6sxgoROiQ/VIhXXyoh6srW7NoCmYu71SYO3uVVMM76dZUOitDL4X
 ap4=
X-IronPort-AV: E=Sophos;i="5.78,435,1599494400"; 
   d="scan'208";a="155646190"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 21 Dec 2020 06:02:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd1agXO7xXeUfi4LWFBNHT0U0GTXZ3I8ZliZo31GfS4srpgqQhiNpZVeYZ0tT4DfSDyweHMCIl/Z1TaWl2DRKTB2T5Raaaa6QJUpPfZZ1Y30DFx6FFlP5laDBJJwBxkTOcuJnLuUgdz0XX7yh9qVouT1IjLsdvWOukSRjFmylJJbexw1dVb5dTTSBB4WJrbMcD9kDHfPZMlINmY4Ws+e1ar+aZQ+AhuEE7HKM0GZOmDRRqc0IACUfNcZcx1X+iy7JiZ0gQNLIZoFBB+cp3eNqrSlw9niG1o/Btv5DEO4254bvNZwssEOWpyzcET4TZv481LwzCD5EPTsvJKXkOzoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsSepHIzlQmO5vlGfgH+O9XU1q3cYDrF4tQvNcSJiNs=;
 b=ALyO15VnB2+T0Z4zuYPg5csD33UeaMdDAdKfunDMou5WkmK3NNDn1cA0O1tKdyNFS7sNhZt1pitkqM5kX2hEM8O5Hy+V8QjWxH2B2lMYcNU2Lm/1IhoQNksgDBxVyoagmosn0reuo5ME55oKUkYTORSrsOf3VOmFNAL4ieMLwiJvrKiRi/fS8CfC0vlIU/nXbkcZqEv/+tVJgifiD+Z95buSko5V+S77I/cKBPpA1tRDpAYXegFGHFiTYf86ExwzzssPLfnC6T13ZCWNRvHO1kAGfhefmBSMwdJyoSuHkZERcMlcri875J7ShcqYbVgqsshrmG9PahoGiCZSG1+E6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsSepHIzlQmO5vlGfgH+O9XU1q3cYDrF4tQvNcSJiNs=;
 b=Z+b5Xm2+wMOruJx3mKjAgONSVgbH0nrzz+ZSQ5ANuziaXJhAYZebFMG/syFObzermjQuKg6gMWJICoaF0kFeU2Hce/cSUu14tm4uTILt6lBZ00HH4cc5B+MoWNtDMraOELvBlyFsltVakrBQRQYCFWkD0Td6dNvYtPUO3/2R/Gg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.25; Sun, 20 Dec 2020 22:02:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.033; Sun, 20 Dec 2020
 22:02:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Topic: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Index: AQHW1O5Lq9Xt0bukCk2VnSNzzSWPAqoAjHbQ
Date:   Sun, 20 Dec 2020 22:02:15 +0000
Message-ID: <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
In-Reply-To: <20201218033131.2624065-1-jaegeuk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c35baa68-0b7e-40c1-a6b0-08d8a532e955
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-microsoft-antispam-prvs: <DM6PR04MB41543FE6BD031E495FF7330DFCC10@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WW0UvhcUWjXeHsHjjhQOUGEftMcD9m/RUHjfQ0CwFusf+vlOq7yynfwHiNwSZfM5wVCoEovuTSyVAPAcA9qSh1m/b5o7SLT5LxXbAzbJ/Wa7jjCdeg0yOKT81OGc21cDSZCN8Fezs6VuQOWy65YfUj5ozZDEwMPT0dOft8XQhX6WWBI9E8xJ36/pWmsls+qYuTUhWpqvYY7MJPS4Yo6Vl2XVnshUYKDFpwSYR6hGbRkED7yBq43GQjP6YF1znaWbPp3VPcp4eJmnu+bACI9orpUqdfzN2L/0siVtmiRuJ/7zicalqToSpr9KO8cfWL2MP7aqAtqfUrFegmZWB1PyfTK3jnqQ9jSELcC79YlmUCCVDItn4gI//GRM/LhlbngYvlTNUFmGV7wQaXU+ZHxEDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(376002)(366004)(136003)(396003)(76116006)(2906002)(5660300002)(4326008)(55016002)(86362001)(83380400001)(71200400001)(4744005)(9686003)(6506007)(33656002)(478600001)(316002)(8936002)(8676002)(54906003)(186003)(26005)(110136005)(66556008)(66446008)(66476007)(66946007)(64756008)(52536014)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CEpd1nb4KsrxrgipDZJ6XW2NBstLDK88koookGvR5/Qeien+do8NUAsdoPP3?=
 =?us-ascii?Q?8pw69M/mwI/Pq3h/3O2uoTXuevGTpuDyba1Hsag5bSQ4okGotfSpsbFAD/4I?=
 =?us-ascii?Q?BMv41G/Lk6tFGeWXPDozJbw+HOYvK+v0WjYQZApBKKJNnBlYHrJ19a5co9tW?=
 =?us-ascii?Q?K8E1BHp/0/ZR7bt/xanbIH+oXkGGkE24LML+x3huW1QK08d0S7yndFM13j3t?=
 =?us-ascii?Q?g32QUbI1+zxoSwAr7/sdsyOb0dKeK2FRuyr7fhXSyjqJWwfSRulqCqh143nx?=
 =?us-ascii?Q?/4VtHqYLB/7kcNqaLgHhuYgpbvag7Xcg8lDJYo4U1vaSTlrw24BIqjv20ox8?=
 =?us-ascii?Q?J6ZNWOF/HOL0/m0hIO8BYP+nshKLXSROZOGotwIt2UxhfpJY2hlCgcqh7Rzs?=
 =?us-ascii?Q?c9FTwXrCnMFTi+XW+IJVXEAKo5Szsgi9wX9zEmQZmxr3Zhu5t4+HBi/XYVgd?=
 =?us-ascii?Q?KQb8AAKxdmiBkngmWSrQ0CM2xcX8pNCw3g5H7F3HFJNAKiGboiyio8VBmkry?=
 =?us-ascii?Q?jI9BSMdzKu/jArh3VDswe348gldimh10xw2N88sOnYJuRDcs/NlUSIiQDqIc?=
 =?us-ascii?Q?G3VkgmQdZpTbTdo9ZjD7bhQWXnwrlW3MSCxPGc+LYW39SsqGJSM3PPBnaLjL?=
 =?us-ascii?Q?R1Et28P6hjUjyt66W2r9WWTaLo1ADezx204EYHfAPzr1PxYw7CJgVODpSpj1?=
 =?us-ascii?Q?tcwGmGXsO7CiO5Spmetr5iaN+LvBy0e7VdoV7EjLfyFfxL2zMYJ5pu6Xm5jQ?=
 =?us-ascii?Q?ezbh/Y6GSBMaSER+NdYF8ZSJAE//FPdSt9wd0q9YRwMAZ0EI9Rs+jEbXvOM8?=
 =?us-ascii?Q?aG81LoMjliq9fRS1/HfSbHg7xK9ZpUyw/h4Rto0bMR91o/51x5JfrDHUsH3P?=
 =?us-ascii?Q?7CIswXXjv3FmWb2SPmwY+kcpVLEyGMgrHeqlJsC0L6Gujz/S+ZeTPI3cKs8+?=
 =?us-ascii?Q?i3x4Dn/xiPC75Y2wqYR/qg9WiQaqgev0DI0N0KElcQo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c35baa68-0b7e-40c1-a6b0-08d8a532e955
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2020 22:02:15.3701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zm+JquOuUB8DjEifZ1Y6lkn4GdecRhKbvsSQHW/lu7LkBre/9in6XnbZlUihXMLXZ5ycyPiihI7qrLyizEGYwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi J,
=20
>=20
> When gate_work/ungate_work gets an error during hibern8_enter or exit,
>  ufshcd_err_handler()
>    ufshcd_scsi_block_requests()
>    ufshcd_reset_and_restore()
>      ufshcd_clear_ua_wluns() -> stuck
>    ufshcd_scsi_unblock_requests()
>=20
> In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery
> flows
> such as suspend/resume, link_recovery, and error_handler.
Not sure that suspend/resume are UAC events?
=20
Also the 'fixes' tag is missing.

Thanks,
Avri
