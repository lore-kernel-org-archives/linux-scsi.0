Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB2AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 11:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD4E22255
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgLXLEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 06:04:10 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15437 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgLXLEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 06:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608807849; x=1640343849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3B+OZX7wGzJVNZexrVoqdq25HbUZdRkdb0uQarJ9qWQ=;
  b=jeVAKXu5eF6P3QHrfBpK0UuwJeraZ95ZcvZyKSwixnXRTZj5zgJLrwU1
   7P6fV7uLM5NW6t6DTrdvvZKGG3seX7GgE+o+eEgqM0L5MNfZC+dhPEi1e
   H3XOdOCbBacl3hqP3wo4yh2iE/zWqE4cXnd53qbl8/jCT7QtmGUZ+pX+h
   L8uMqxtS5Vctl5Yygn/RrDJKVTCSzgp8RIGdRG/UDGZZrJURcAoy+yXjm
   ZtuoASP6j4vTRN28QEgzhUQJkP+3AEssaXbyun3rhP445jkJUeh0h34Li
   1TaTQIldwhUVi0fmwgG//mXdXTiNVQ4sDCopUz/ieaenKBRE/D0IQdq7U
   A==;
IronPort-SDR: b2/nip0gIwvG6J6SSrbN29H0YywMfrNeOPFlJds2Qh9CF9yRWb56EMFdWGAZDhVsagrXCjYA1c
 RE42AQbOYWadrwBHtSQIXwldsRBzkZlYuCVA7jslTA+KGs5Zp1147o+FlSpf0sC0+Wd1HSXWkz
 hW/ctjcpLq8WqqLvS8fwcootyHYXvzp4GC7qY6wKFprgqm6KGTI2ghHW1dlm9goiXJKz9GwMT4
 eqAW/IKQYuvvuw1Rdb3BGeGbONYpuaIt7NNMef4XKCAXc5xp75UQUhL5GcOYGuL+nOTbgP1ubj
 0Ok=
X-IronPort-AV: E=Sophos;i="5.78,444,1599494400"; 
   d="scan'208";a="155990832"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 24 Dec 2020 19:03:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnJlnOrdV+MlMgj1sdHpLhl8/SaHFpwRdJU8VW04vQUShBH6p1hA4emnndKpGo7Z4WFxPIQevTobRureuUm4ESzlyi+vYxH902vaOpFmvW02eoTfHgVW+4n6yM31K+GjKAE6dA+SqbOt1hUDVu/1/hHLQxq4BaZ89sXhSOisrwUoAG6aD03zu9qFUxbP9Pk+59d0EJ90UvzaYtxSUl6LKbmytPT4vFprql6uMUV0C6cW9L22iIG+jUMrA70Pab4TJdVxW3srXavDxVbakjIklYEtgcT5MLWCwLY0+FvIuAhyNsKuxn/gRe5jUmavV2D6Z3oHpdwzdbG0bjbKvBx1mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B+OZX7wGzJVNZexrVoqdq25HbUZdRkdb0uQarJ9qWQ=;
 b=Y3odU1dZF4/D4wJF0gSvEwUa3qcpabnCARBriRwOq7k68ytWmfchVlgQRmiETlwMNXL6iVko5gwr7XU87CqiuuhXpL+enhms6V0fms8aoEcuoN5l484ADqSSiKsp2mLP01beyuhw1u/DvXza1wpoqPQWUP4etOtX8jGvdTkMG+ET0pPjW2EvONUivUL7M+ZqzB1cpdNiyzkuk6QMKOhl2JGWSF01FMZhpLLDgEhQpBLOUPARhZF2mMmy+VrIQioVvA117BNHg3SZ8Hm0L3o95o4M4RDakQINp6OV23cbOfeMRJbZfPrLvzhYv5V3GI8x/QQqU7dv/7qxOpM72Dd+Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B+OZX7wGzJVNZexrVoqdq25HbUZdRkdb0uQarJ9qWQ=;
 b=lQDtP9iNQEFE37kD3RYAmk2hybT31xjVvBjwN3IsLzKHjM1c3v/XtIvUmO4YaiZXC0IT6Zi37+rF13pBoN9ib1l+CqmVLNxEnfZFfHh0l4TKOM115khA+7+cjH2oeyaHkd2UFCxa0y0Z+ali6W9fG2bvrptSXScfGEuKzrlWS7o=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4489.namprd04.prod.outlook.com (2603:10b6:5:24::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.27; Thu, 24 Dec 2020 11:03:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3700.026; Thu, 24 Dec 2020
 11:03:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Subject: RE: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Thread-Topic: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Thread-Index: AQHW2DQ3JDYDYaEKR0iGb34jWf7AcqoC/HmAgAKKC2aAAFx2AIAAMsow
Date:   Thu, 24 Dec 2020 11:03:00 +0000
Message-ID: <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
 <1608796334.14045.21.camel@mtkswgap22>
In-Reply-To: <1608796334.14045.21.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f6a704c-c585-4449-b745-08d8a7fb7a80
x-ms-traffictypediagnostic: DM6PR04MB4489:
x-microsoft-antispam-prvs: <DM6PR04MB4489DBBBC101422B7A917ED3FCDD0@DM6PR04MB4489.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BnX8846aFj5chJVlyClJqbftJE5J8i8+d9XuFbzin6MkbwwZWIlNQvRN/Whdt00BBxPBPP3TU2Ce75DAxuTr8JP/V8KpUygbqZHqsfzavrmEy72j4zhpvc6j0J3oGNjTtipvgNfNKOdVWeOQSWKP9mj5utrAMwsf2nPL4AYKEeCKY4concT0qZ1MJTXCyCdbfufKpVKAsW4fL9OU8+qhpe5QQOOfMFYKJHT64WIK/n3mqLtTepYQ0NMHOmM2dG5eRj/cg+22K8ByRTO9XAbAcsfILEjENV8spj0t7Cmf/P4KjZ1LXr+UBx7O8yCbuBdclz7zFG5zEQIRIjnwAnh46Tdb6uNqm6I2lOIRgK5V191BLPDPVfI2Z7h36jyJqb4X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(76116006)(66446008)(66476007)(7696005)(86362001)(66556008)(66946007)(52536014)(4326008)(83380400001)(5660300002)(64756008)(33656002)(478600001)(8936002)(26005)(6506007)(71200400001)(8676002)(9686003)(110136005)(55016002)(2906002)(54906003)(186003)(7416002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b2NwbDJPMG1vclFBaE12K3BmZ09YS3pQRkMvSlNVZjhWTEd2cnJkaUlHVmxv?=
 =?utf-8?B?VnZXMGV4NFZNMkRWeHF0QnJhVGgxeUFhaFdSOGNJcGlFRDJURzdqMy9wQ1hl?=
 =?utf-8?B?NzhlSHBlbWdQQzFmZFY1akF2aEpUT3dHbDlSd2lQaURXUzl5azlpb0hCaXVq?=
 =?utf-8?B?cGNwR1VKUlJ0bG9EVkZpaTN4UzA1aW9ZT1k4NkZGckpvVytrTEhyei8ya215?=
 =?utf-8?B?VlNjMURVYTgwdzgzSXpMVU5URHE0TTJDRVRsZDdtOExiU3BWUCthTldUSU5k?=
 =?utf-8?B?UlJYUjFvNjZTMGpqdXB2OGtXUlhUdHVhcyt4MVl3TlFseTdCdHlFQ1FCbUh3?=
 =?utf-8?B?UDRIQUhhZkJjcjFNMG5yS1pyS1M3aWhIckJwNkFFcUNrcjZITFJDcnpSOERn?=
 =?utf-8?B?em1ScitXUVJINmZjcCs3ZVVYU0VVQUZUMHh0aE5uZ3FvVG44ekY5R3MxY3c5?=
 =?utf-8?B?aDZjVld2VWJ4RmQ3NnRJV0ZCakdUUEJ1Mkk5bWE5Vk14WlF4OWJlT0FXRDlX?=
 =?utf-8?B?Zjd4VFRSRDRtMHVWUlBqOW1DR1M1UGF4bDYwL2ZGa2V3VDBBSWE5NFBYTXY4?=
 =?utf-8?B?aVp5UTdQdDcrWVZkWVpIOEhWOWIxdjFnVHNyL3RQWUQ0QllMeFZEdkl1Z3Zv?=
 =?utf-8?B?b2U0QjBySVhwSHNHUndlN2FFYnZGc1NaYWdBTytVb3R4aVFnRUJXWnhGS1NU?=
 =?utf-8?B?L0M2cDdBQUFDQ0h4cXUrdlVHNCtYZytEQWhsbzBXOGF5T0NWaThCblNRb3I4?=
 =?utf-8?B?d0dtSnhVa0JwY1ZmL0ZaTk5NL3B2V2lCbG51NDJTemkramxINDFrWmlzcUJW?=
 =?utf-8?B?YUZLNFNvMVNDZEdhdXFuTUxMUnVIU2RZbjZ5dWhpenRETUpES0NEa1NyK3Rt?=
 =?utf-8?B?ZzFGUWF5RDArRWFGWTV3Q1NtcGdkM2hscmFwQjRjMmFCS3hieUtuemhpaWVa?=
 =?utf-8?B?NWYxUEswVEJadjhoWURGR1EvdWFiRW5DNVB5TzBXQmVWeUpDYlBza2lhb1Ax?=
 =?utf-8?B?QVArYmlpM0FLYmcrYTN3UVVxMzFlVVcyQWp5TCtyMm1QMHNKMHZEK0taOFBY?=
 =?utf-8?B?SkZhUENjU21ha1pGcXF5QjZxRjlHSVMyczB3blFabTB5TUlscFBwVGhCZ3Vj?=
 =?utf-8?B?MlpCcndHWkhnQUxHTExjNGh0d05UUWRFWHFzTUloRWI1a1l3SmdWNWtnNjlx?=
 =?utf-8?B?aUR6d016bjUyQ2dGWndzVUt2bzJjSzZCR0JyRWovRFpZUENBVy9ITlYzU2VT?=
 =?utf-8?B?UXJmWUI0ZUJacjY5TDF1U3NBN2hNSlNWTFZGMEp3RkUyZUlSdTcvTHpSR3Za?=
 =?utf-8?Q?vMzKjDwuxyTJ0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6a704c-c585-4449-b745-08d8a7fb7a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2020 11:03:00.4909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOCbUyWOF3sADGFqqfRg3dOfsPPmmEBwSuad5w7CBXgZ3/xApKkgtVKvUy87Y5DB+n4zeKnoTf84yrZz2dEH7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4489
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQpKdXN0IHRvIGNsYXJpZnkgdGhpbmdzOg0KDQo+ID4gRG8geW91IHNlZSBhbnkgc3Vic3Rh
bnRpYWwgYmVuZWZpdCBvZiBoYXZpbmcgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4NCj4gPiBk
aXNhYmxlZD8NCj4gDQo+IDEuIFRoZSBkZWZpbml0aW9uIG9mIGZXcml0ZUJvb3N0ZXJCdWZmZXJG
bHVzaEVuIGlzIHRoYXQgaG9zdCBhbGxvd3MNCj4gZGV2aWNlIHRvIGRvIGZsdXNoIGluIGFueXRp
bWUgYWZ0ZXIgZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4gaXMgc2V0IGFzDQo+IG9uLiBUaGlz
IGlzIG5vdCB3aGF0IHdlIHdhbnQuDQo+IA0KPiBKdXN0IExpa2UgQktPUCwgV2UgZG8gbm90IHdh
bnQgZmx1c2ggaGFwcGVuaW5nIGJleW9uZCBob3N0J3MgZXhwZWN0ZWQNCj4gdGltaW5nIHRoYXQg
ZGV2aWNlIHBlcmZvcm1hbmNlIG1heSBiZSAicmFuZG9tbHkiIGRyb3BwZWQuDQpFeHBsaWNpdCBm
bHVzaCB0YWtlcyBwbGFjZSBvbmx5IHdoZW4gdGhlIGRldmljZSBpcyBpZGxlOg0KaWYgZldyaXRl
Qm9vc3RlckJ1ZmZlckZsdXNoRW4gaXMgc2V0LCB0aGUgZGV2aWNlIGlzIGlkbGUsIGFuZCBiZWZv
cmUgaDggcmVjZWl2ZWQuDQpJZiBhIHJlcXVlc3QgYXJyaXZlcywgdGhlIGZsdXNoIG9wZXJhdGlv
biBzaG91bGQgYmUgaGFsdGVkLg0KU28gbm8gcGVyZm9ybWFuY2UgZGVncmFkYXRpb24gaXMgZXhw
ZWN0ZWQuIA0KDQo+IA0KPiAyLiBBbm90aGVyIHJlbGF0ZWQgY29uY2VybiBpcyB0aGF0IGN1cnJl
bnRseSBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbg0KPiBtYXkga2VlcCBvbiB3aGlsZSBkZXZp
Y2UgaXMgbm90IGluIEFjdGl2ZSBQb3dlciBNb2RlIGR1cmluZyBzdXNwZW5kDQo+IHBlcmlvZC4g
SSBhbSBub3Qgc3VyZSBpZiBzdWNoIGNvbmZpZ3VyYXRpb24gd291bGQgY29uZnVzZSB0aGUgZGV2
aWNlLg0KVGhlIHNwZWMgc2F5czogIiBXaGlsZSB0aGUgZmx1c2hpbmcgb3BlcmF0aW9uIGlzIGlu
IHByb2dyZXNzLCB0aGUgZGV2aWNlIGlzIGluIEFjdGl2ZSBwb3dlciBtb2RlIg0KDQo+IA0KPiBU
aGFua3MsDQo+IFN0YW5sZXkgQ2h1DQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IENhbiBHdW8u
DQo+ID4NCj4gPiA+DQo+ID4gPiBUaGFua3MsDQo+ID4gPg0KPiA+ID4gQ2FuIEd1by4NCj4gPiA+
DQo+ID4gPj4gVGhhbmtzLA0KPiA+ID4+IFN0YW5sZXkgQ2h1DQo+ID4gPj4+DQo+ID4gPj4+IENo
YW5nZSBMR1RNLg0KPiA+ID4+Pg0KPiA+ID4+PiBSZWdhcmRzLA0KPiA+ID4+Pg0KPiA+ID4+PiBD
YW4gR3VvLg0KDQo=
