Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F37C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7D1204EC
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 11:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MVtmvFsG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jP5BhHxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgFJLn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 07:43:27 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:50294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgFJLn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 07:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591789407; x=1623325407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RwGIVo/SIFbxkIwmOhvkD7Ispx+EsW1REghSRzXFvuM=;
  b=MVtmvFsGWrwloDfbGfoX5pvhGYnD6qV7XiojfkIlHrEvlXkanOTUmHcu
   N2vHgSc01xJo3iX3We9riE0kqgJaBZ1pwHHcGeaBA1wyZjwy+P4dfDRAH
   wYfZtaPJV1owD9JbAwiL+5ZEZWDhkswDr5OmAVixrYYYG+Q5f3ktx3RYo
   wf8OSaeI5W38kFAKNhAED/GfewcmQUNZvG5LCx6P7zWQC6AKMLkUAQPuD
   7em0FPcxiNSm3PdbOiVZuX/nwwA89ndviKhI/s1h2yHmJteaD0KZwbltc
   0Xesq0R5Dq1MLA7q+nKDw+ojh0zSSHLLi2K/39oqKEVRqKWsWpd3GFmKS
   g==;
IronPort-SDR: Ul2WS3s9LlLnzfbTSiLutU9nr33B4lpNBO0IYeyG9QtzREVP3KXsxxzEduL7KWsmDB9R/XFn0M
 fDsVyOTn4SiAYP6blUotuCIFdAcaAV6OaZ8q5boAPQexIHsP+EThmzDBIE7i/Zr44CsVGp6Wnj
 voVZpiKrB/SXuF4q+Vg+IY4x5XjBTZbxui0xUSm5NcWrUXUmzXDw+YwPw0qfrZLoQTN30HqmxL
 KElBDjz/WvW4aqCo9hCw1XiRotuiR5zJFVa9bnUKAZ3pzJiYZXEISJEGNWwmoOnGqEnmTG8oTV
 bA8=
X-IronPort-AV: E=Sophos;i="5.73,495,1583164800"; 
   d="scan'208";a="242543504"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2020 19:43:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khq9RJhZI0ve3XPmAkTfAHSEAyFnBG/R964fXVS7HWct10pn9ZMDSDZ1n767uiMAEpn+t4FEpi1jQ0XmP6j/2NglB1SH0LFuzxNCIUP7f6eiEfako99StmnxGhm6fSxD8dMsz6MKqSIDwmuKmz2F6KTX+bYf5fl8zhji0q5GHjYR3RapKoMcdZM0vVexv89FR8ZohZMylq8O06gMWxB3nIbK/tx+kwRDhQhcFFbn3x/QtSyY4Vix+KibfSe1oAa5Wl6GvPnqbe13ILiavP4dNZWNMHyaSAawxrMLzgJZmlu8ZZbNQR06Nk++Ptv/47BLi5EeUIExvWjrfo0JviM4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwGIVo/SIFbxkIwmOhvkD7Ispx+EsW1REghSRzXFvuM=;
 b=OCnnoqMDT7Mn3eRNaDjCBBDXWt9umupbg1LIsoJS+moth1hvYEm3vcdiIJ4nNJVf8lsqq/LiHyzBBoi75iO6cpJAYSbheE6iHd5jUAkkEII6LG2FCgQPPrWpVFka1mrpcj2xdhGtEzt7s8rfzRRDmxNQOxz6D9bJ8YygI/rqxmhB2aPREkd0sg4i11/Bb0MnCwiGUgFFl489aVILuNutllEEsawEIaHORWbM+xisUzbgmUusJHdiKLcbj3S9jR6yVl1XXHDbXhwNd7xzMQLVf5rAY5sxRpW9OyjvDzAzlmf6ElwZtneWWmENuh3TGSmciqmP0ebzogVqspYlxRjt5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwGIVo/SIFbxkIwmOhvkD7Ispx+EsW1REghSRzXFvuM=;
 b=jP5BhHxZVnJxkyf4uzQoJylK3lasFTrvdUQcik3qBFTbLjn0rB1CunDLG2Y81Kj2GDISN8CfuwcASboJInNN5XKisfBX87oPgxyff21k1ctbzaRdU4ZK1alyu6ASu+m+SJyIe+HGYAFUE1PHnF9hfMFbUmYm1jS4m1J9+5Inu8k=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5293.namprd04.prod.outlook.com (2603:10b6:805:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Wed, 10 Jun
 2020 11:43:23 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.018; Wed, 10 Jun 2020
 11:43:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v2] scsi: ufs: Fix imprecise time in devfreq window
Thread-Topic: [PATCH v2] scsi: ufs: Fix imprecise time in devfreq window
Thread-Index: AQHWPnRZa+zdhsMCpEaxMSGGJmSl4qjRuhfw
Date:   Wed, 10 Jun 2020 11:43:23 +0000
Message-ID: <SN6PR04MB46404C13248B105082BFE8E3FC830@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200609154035.1950-1-stanley.chu@mediatek.com>
In-Reply-To: <20200609154035.1950-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d4d2ddb-6674-4e3c-015b-08d80d337b23
x-ms-traffictypediagnostic: SN6PR04MB5293:
x-microsoft-antispam-prvs: <SN6PR04MB5293441525BDAE7524F53AE2FC830@SN6PR04MB5293.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QTNZTWmeVcbCM/n6Avin+JN8sk5gYqgbJuGDGNl5o+2CazDF2xO+ScS4cUr7jfA7gqSj3Hrys+3vmvE0f4m9AcRGbnV5wSU28CmpsBR5MJ0ulfVv/kLk6c6oaV6+zql9yL1xgOF5PJEQw49R1FaBDbIu/J2bVw1+PhHrkg09AELr8FMVICWNRfIbcoAtlJPCdQw7nI6jM+2SGpUnjG1aMahOeYyg7oroBgwjHfliNtfk0+18DP7MMkTblpG6t8iJDqy+rLSxDoqZ8zofXg92SJP24P6BgUajF4OZi8Kr50jAKsZqHXQsIq9an7DleaMdh2DatbrRpzaht8Pj3SwOOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(8676002)(55016002)(2906002)(71200400001)(64756008)(76116006)(5660300002)(66476007)(52536014)(66556008)(54906003)(4326008)(26005)(6506007)(9686003)(558084003)(7696005)(186003)(66946007)(7416002)(33656002)(8936002)(316002)(478600001)(86362001)(110136005)(66446008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 93r3yewk0Bod+U+MnOSQW63SmGOgarJl68UYjeBlSJRm6iKNJ+wZf8an3S/fFM3dWLPZ30SM6iV0i74A4I3y9aWV1b9Xd15UQmajKlHUTZPynnGTgM+8o6n7W0tAE6BLfDNJTzbAUCY1wJNDJcUqcorD64ESod4t+MLYNHAp5EVQJVXb+YsXO2iZddYrNYOUqUerYnjUmLBOVzjr04ME4lvAE5mhvJbggCz0aMZKj34y2zhwPP6QscoHqO1NhxKBqpGeKD9sbvt2ig6MFxgDkgQtOgJn/fufuGeoVLLFJx1L/F1hZE/cAJhI/2Nb3D58RAody7SXHEIYEPZ7QWp1iwWoPA9uLzhyysVtVS2+bsSUkdUr7tF0DLLbGCfAVdulVNNILe1qwMC8rxQl3rvPbPMxccaCMT5KkzyyvMPpr2Vl/gySLFjTINytMJqT8p2qos52Bvo1DDaa99Qciao1EcQIrB9Dw9uv+niKg3cixI8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4d2ddb-6674-4e3c-015b-08d80d337b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 11:43:23.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5iUZv9LUNQp/S/XZQ3K3YQ1MD8clxzOhkquCxg/Pz7dIR7m7M/wkQU0jHIv5FNqkWGcAlp7FOhiOj3oG+aFTEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5293
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

>=20
>=20
> Promise precision of devfreq windows by
Promise -> guarantee / assure / verify that the?
Can you please also elaborate why the current window isn't accurate enough?
And add a fixes tag?
