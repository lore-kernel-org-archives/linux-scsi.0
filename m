Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F656C4361A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C8D22D0B
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgLEIEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 03:04:21 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39017 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgLEIEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 03:04:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607155459; x=1638691459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9g04GAUiP1AYBz5oW9zZ7tXJNfz9Hx7DDbbPmKKZFDQ=;
  b=FTsf5UkQryAyFtd/STWaViAeHhKzbJMA2zn4evQStz54E/AAJWD6l8QA
   WO2csmWr9kUPY3/EyxkoOmPyhONl9TFNY6aN+Is7909zppj+5gUDZEbw1
   fKhw3/f6ppAB+i1NdNrZJGPcMEYIiJPgKHXvsyNaWPUhdthRJGC6QTifU
   wyrnJ0u09A2pHdtvJf64yJ0Dk5KFR1xj5QsSFJOVHXc+GFBfcQDPFr5MQ
   HaZHfZqTQrQIem4bXVJ1298csb5ic4n9VsnYqXJg/fjhvDMDY3ozyz9HP
   Hs4GZhBtNi31m2D5PcGyEI1LRFupWXpGDj7vpvQu5iXF6zUkw7zPs2fpj
   Q==;
IronPort-SDR: wHda7EZLOvb98ckR8KPP5TtWrs6QCzp4puA4o3VdgtvIZRMK7owkDKoTOT6+VCHM/kag0yiilT
 wQL3s1AnVj2V56PrL1kpZogQK+jQuauIFlXppOaiMyMGKlz91lbdIWFYYHjUTWsZH4Yj92enbA
 jvhBjt1hMqnQufTZRiDTtejbu85EpTJHLd72piDjJe8/hRWoCGC7zx9I31a/tmby7xhvkxedBU
 yMrjjKe9D6fwNjjBDDApJy4uLjsuk5b/m3FZIInxsMM48KfD5zCuGS7153g7rzIe5jPTGXzlNP
 BYs=
X-IronPort-AV: E=Sophos;i="5.78,395,1599494400"; 
   d="scan'208";a="158955383"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2020 16:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxSMqPcZl9LoxoUP+WGyQusHAybMrPAaGe/IIKkyzltFl6Nsh1YdLTzqqlLE0C6tXt9jgbOr7sTjDst7eEcFLGPZuNsnbPwHysYcVvl6/VYYoru3WKfrojFIJWr1bTBnM+xrnVQMTFrHvjbH86es5MmydVryTxMWTJmdCL2MXx9u0RCuuiZPi4lwDpQVYc12SKWUYoBuDrL54Xy28v1zGGgCawy7Tv46KtVhufLzUwF/9yx9PcKeazOXbxhGCNv532WzVX6uAzYisNrtFe3wGxJRJNNJufNs6tai1Bgok8NSMuGRvHkspFBkuuduJ+G6/9FTOyVfQOF4i3KBnznNVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsxd08JXBsBamEX85/oFGS3w1Wjbwxw01zr5Pwc8wtk=;
 b=nc7ab0J4H3M2VswXyNr2XAm4z0Y0fzX3EFomxxm7so5RUrImL42V7ChEtZY6HasfNYecAB699DxeAx2+aw5jGMlhX8glzPK1a+Kms7bf1LlVod5ahiouboW1k+rI9pbsDhhZNOC5OnkP7K81bWUMKGUjKG0RZ1sEVUR3CQgmFwCbNTS8FoUEx2vtjd+9/Bm2FfnNM8oeIsfcTLJVkmcRUtR032GjQMLU7/izI5nLGo3x13I4P0yZ8Tni5GuQ79uhjnxvrpR9GhzdeRaw20DjH65y00yxaXhfeNpqjRKQGUbcyCAc9TAWbK+y0Ld2e+PPte6JBrrG1djH62gd8ZtTdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsxd08JXBsBamEX85/oFGS3w1Wjbwxw01zr5Pwc8wtk=;
 b=Q6IBwuFxlOAVU7vy/GffQJqsTv8lSKJZFR2dqTFiPirAcW8nhrAueF2ON5N2WiFudyZFFt/D9P9NHjTAG0Y0wFne4oY8HgiuznNiY2T4nDCeCNjYEvDUney2p8ele7DXogj51T/PYShDTdxbBtkW1gLDgcC8oxIPHvri8S7EcSU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6667.namprd04.prod.outlook.com (2603:10b6:5:247::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Sat, 5 Dec 2020 08:03:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 08:03:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "huadian.liu@mediatek.com" <huadian.liu@mediatek.com>
Subject: RE: [PATCH v4 0/8] Refine error history and introduce event_notify
 vop
Thread-Topic: [PATCH v4 0/8] Refine error history and introduce event_notify
 vop
Thread-Index: AQHWyq/pOn7SLSBA3UysiLzNTb9IZ6noIz6g
Date:   Sat, 5 Dec 2020 08:03:10 +0000
Message-ID: <DM6PR04MB65758A2779FD814F52E137BAFCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201205023938.13848-1-stanley.chu@mediatek.com>
In-Reply-To: <20201205023938.13848-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28860163-703e-4505-cd8e-08d898f435cc
x-ms-traffictypediagnostic: DM6PR04MB6667:
x-microsoft-antispam-prvs: <DM6PR04MB66671BEF9013DFDB3DDD8D94FCF00@DM6PR04MB6667.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+wccSOUG+DSj+KUPyveg/aYEnlFovzH1g6r7KBV/r8+AT2R/EdqcV7kyeUTbLYnSYamt3sRz8u1ZoQp5YFwmcva5usVmTpcew6h0IuLes6pZzXVKehHeM5M8sWgUwsaypFcOyFT/ToNBn06ne6gWrSx7xBa0kgdl1Ha+cMkYg4f1OBzZ4moIJ9vK1nZXq0RhylDspjk++vhSeaLF3DcvZtAwGu3AGh/MqJffZv+WdVLn3PePvgTtO6TShlKVX5aS/w6eYmD0ouK1yxfVBYhl68UDpjIvUrsYo+6IE1JAuTtq7vmltpvTWTFn/EdZJE4y299SYTR5OdE67l8MjGR5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(2906002)(7696005)(86362001)(6506007)(76116006)(71200400001)(33656002)(83380400001)(9686003)(8676002)(7416002)(54906003)(186003)(26005)(52536014)(4326008)(66556008)(55016002)(66446008)(66476007)(316002)(8936002)(5660300002)(478600001)(110136005)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+oS/R5PCawJ55aUV86x+jaMFp+BXIQgghSkaGTjpdoRErlobe+lUGIzQToB1?=
 =?us-ascii?Q?WMn6whSiE6JHcCfyJXaAbICcZ2RelI/FR0JoLzU+GwDn4L6mTxA1WDJwsJNs?=
 =?us-ascii?Q?IlF6zvhfqK0sm6Texy/YnDYXywxcBm2LM62qR1IrXm+nO8s1mukJNLGDZRDU?=
 =?us-ascii?Q?rbt4ygjVdIVmK9CdmhMu1R8KM4I7zYiMmV2oYML4c6j7RrCuTap2uHJIgOHa?=
 =?us-ascii?Q?IIzYsh2bikG/cJW5jdYetPKxpTBIREud2KUTwqh7TpE8YG+H3SKPeXfQu3H6?=
 =?us-ascii?Q?cKTI+BUJC+9QB1KpcZLNRgXAGTk6YVT1Ty35TvaTK4C2+8nAqiqozfrc0Oxi?=
 =?us-ascii?Q?bZ011iS/a3WIBYnjinU/Sg0M/qNrhqBojeLgDct6IRToP3rTWmxG/x9UnmEc?=
 =?us-ascii?Q?icdE5gbyWgTbI9d6OmC1zfbezgn9kpaBQAyW16YARY5EnKCaj7LAVGz9xW5A?=
 =?us-ascii?Q?vhWRLdVkGQIzyPUY57EVN4a3iUBbSCdYHXsA+MynYbt0KotiavVP6fNkF0uL?=
 =?us-ascii?Q?WYZJb4Pr0PzMxtXeiDoT4v/HoEufY57rgkd2oZVGeDxjzHguvKb3mctSFSnq?=
 =?us-ascii?Q?uJrzLqvQKilAsdiWzN+BOMKAc5OYUMLLOY0UAey3+nM8PpPmJe3MxQ25WIOx?=
 =?us-ascii?Q?hrycBOWK+KL7B6hH1GWSFE7SlKYIrMEU4kkTwSWOjxuC+06P1S+fRV3PQU3k?=
 =?us-ascii?Q?aZRguT7rzKkeDkZIL8EPcPE2QwQxMpfpwky3P2XQLf2H7KYbVy1vZlEqoFdv?=
 =?us-ascii?Q?wNoXDleIxaT+OW3/SiooOXtoTFJ2REyA17QQ8zncP27+4jRE2p8K57gkhiP6?=
 =?us-ascii?Q?wmYjpGbGrFcdE/dQy6/ZB6ogMT5fWCItW+sKcudWsuzrvA98+kCRgY1sifcS?=
 =?us-ascii?Q?BKqegelvlGTgbXXDi5cGkGXdOO3BC24ikPxjKgvbs9OZ3013nFWARIKe5v56?=
 =?us-ascii?Q?MQC2/vrlRKVA+F/Xoi1e1CpBEwQfGmfYDeaxRh8Ribo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28860163-703e-4505-cd8e-08d898f435cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2020 08:03:11.3189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3xwCe9TUgtjgxDBb5va5WDU7YBxcTcP8kN8XqN+J4ofopp1Higy/xLPgievzORS/ZgEEgHuqouled/8bSxgHVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6667
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,
Will you split this series to 3 separate series:
Phy initialization cleanup, Error history, and event notification?
As those 3 aren't really connected?

Please maintain Can's reviewed-by tag for the error history patches,
And add mine for the phy initialization, so Martin can pick those.

Thanks,
Avri

>=20
> Hi,
> This series refines error history functions, do vop cleanups and introduc=
e a
> new event_notify vop to allow vendor to get notification of important
> events.
>=20
> Changes since v3:
>   - Fix build warning in patch [8/8]
>=20
> Changes since v2:
>   - Add patches for vop cleanups
>   - Introduce phy_initialization helper and replace direct invoking in uf=
s-cdns
> and ufs-dwc by the helper
>   - Introduce event_notify vop implemntation in ufs-mediatek
>=20
> Changes since v1:
>   - Change notify_event() to event_notify() to follow vop naming coventio=
n
>=20
> Stanley Chu (8):
>   scsi: ufs: Remove unused setup_regulators variant function
>   scsi: ufs: Introduce phy_initialization helper
>   scsi: ufs-cdns: Use phy_initialization helper
>   scsi: ufs-dwc: Use phy_initialization helper
>   scsi: ufs: Add error history for abort event in UFS Device W-LUN
>   scsi: ufs: Refine error history functions
>   scsi: ufs: Introduce event_notify variant function
>   scsi: ufs-mediatek: Introduce event_notify implementation
>=20
>  drivers/scsi/ufs/cdns-pltfrm.c        |   3 +-
>  drivers/scsi/ufs/ufs-mediatek-trace.h |  37 ++++++++
>  drivers/scsi/ufs/ufs-mediatek.c       |  12 +++
>  drivers/scsi/ufs/ufshcd-dwc.c         |  11 +--
>  drivers/scsi/ufs/ufshcd.c             | 132 ++++++++++++++------------
>  drivers/scsi/ufs/ufshcd.h             | 100 +++++++++----------
>  6 files changed, 175 insertions(+), 120 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-mediatek-trace.h
>=20
> --
> 2.18.0

