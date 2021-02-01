Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E7C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC0E64DD8
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhBAHOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 02:14:12 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24438 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhBAHOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 02:14:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612163643; x=1643699643;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bNBm3P+BUxtEAcIDJyPUvwOn0lxsstCYX2dwfDClLm8=;
  b=eBjGiNf6XT/iL+JIYMMpGZRo3sCNh+3ZPIhPV6zxTB7IlIwpk37beQvN
   2xlPEwSUkaivDCcRF/E47kGKI1NMUveb4znjqIjvGmXFdVULSHiPjihYA
   1RwqHl4bZY1z7rmnkNL1a32v8pc0N3c8rW6BaXD2ZMvxWBLs0AUt1+b3P
   zTJoh++h2qtqrznVUWGpR78K4St7vSrw8IzGwAiAbUBFavxCVH1xm5ybQ
   BvD5VKwsBjXFgzwDBgASzYCZqRInao4cFEi6QwowEgaeqJpr2BhSmDFiO
   8elJVeHgGXrhrUJMNQCYAowmX4/9xqB51dU7nCdxWVc93HMVt/Rkf99BF
   Q==;
IronPort-SDR: TJkG17rg7IB+6nc3LXsrW8XelWkNac/fqsUEWhlP5gJB78oqPNg74/t96RvknHGepIe2DSAi61
 w/8Ofea/QeyOOoqlA/8+HZqXBWrTw1s2IdHAtkTuJ4SgwNJPNE/N0uY5UnKXlU7CXvvV0vBxPu
 baUXQN3uOtWRy05dS3iHVF51EAD7oaA59vQ5OlOPehxfTVSsetUBjbwiI/oVdRA4BD53bEVJke
 wqjJKLU87+TLXuPbKPwiICeW0/CWDE7Sn9hITbVxIg1bINmG9uYHkg/tpFHSq1uCZInsanIzXH
 jfc=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="163236784"
Received: from mail-bl2nam02lp2055.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.55])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 15:12:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPSeDRf+xrW56nMI9H+l3OE9oIERZDh6bGpQYECgGUz9OXamWFvYh40B6z/gTOrbNXk2AkjKifhxs/s3WxO81rn2feb7VAWSCBscsoHkCA+RpC6sv6x/DisdbMSanMiOeXwYSJ7ohisyRKe1mwrzi24AjD0/urxVYfQ70ZKHO/papgIs1IKevfi4eIXfyZGU3dh0Y08iWOjCTlg4kVOcggipitGdvO6HJ4o2qWy/i5XQfC8t/LlUyj4TrC7H5djswqQ+ELtJ9G20/09Pz2csHZgX01LeXvmXaDYV3KBPzK14YsXjPJOjCInuBrkPrOAFesggHkbuhiJcQCllevapFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNBm3P+BUxtEAcIDJyPUvwOn0lxsstCYX2dwfDClLm8=;
 b=U5yFKtPeX546eVdLq1nDmeL7y5V7uBG7sbiHBRrB25Ryx/lWjECeZsAYah+a0KIqQpk63eKdF7tMmR1D1BpcPfI0CO/VzEXyrCsTQULjPqe9OqazijcsR9JIMRBzRMkiAS2JmCSKLGbE3ZMt092Ssk0fDadNa5Chyr+aMV834O6SjSk/nAS9uiGL6YqgHYGT0Y/Hz0dN+yODSww1gRMvpOIY4mUxZcgChpnpEtp2pj2ToTOlKvDdB6Guc83sUhYRQeJR9yGi/t27qvWxfreQz6mhrsJ0CboH2J/0AnrebTLgHl3w+4qTMPh/GsV1+wAn7LevGzlO1T3f+NeLdmGBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNBm3P+BUxtEAcIDJyPUvwOn0lxsstCYX2dwfDClLm8=;
 b=pIDrp4pPBPWYUc0WUNVjhxsiSKsRrDrYN+HkTGTwv33QQm8tQm43SGDC1IFa/JsZc+h2a4AKADl/5ZlG4UthakqyQCVX0fzL0cAQ6FFF+r0Yj91fuk/oDJbkl/O3SmjH2ihH69HVzy/dOT1qHQZpXHfxw3kj9eQKh2j2QAAxtd0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3656.namprd04.prod.outlook.com (2603:10b6:4:7a::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Mon, 1 Feb 2021 07:12:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 07:12:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW9L7x4iaxfLLWbU2VlJGMVSiCUapCsZUAgAA24sA=
Date:   Mon, 1 Feb 2021 07:12:53 +0000
Message-ID: <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
In-Reply-To: <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c700cc2f-e762-409f-318c-08d8c680caba
x-ms-traffictypediagnostic: DM5PR0401MB3656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0401MB3656AFF73825A0CECF847754FCB69@DM5PR0401MB3656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y56ywNvuUczSxv/lDK7cQA7syi4pB+ODvgFYXX44yrOPpOTuMVOvGzXa9f2KwgJoAIruPcK1qn042XX9Exyidsylfeyfmw7BbiEOmdy4Sq06x0toOQd9c65shgKSq2gCyA1BdQP1nvD+ok77CKaiOzGt6zr49S0rfTTWguCzXjoRkB0rrESRMLz38iGSIwOHMK8ncvsNOapRqNl6cE0jN3d87Lm2pZPzoztWD9pJohWiKr5XWlJc+4+egJ8p4muGbbYDoo1nz6C2XSXDzy2eYzpBEfEoEUAU8lS7h6XOrqRomWH7Ori0v0tLvtx85h7546Z5RPRWE/1sX7pE/M9ICMyeILyx6mUePxBpb9mU0Id5WG9+GRzU4vrgAMmQkTUOxbRuhRzsGCU8lbO4qLWmnS1Kg56XcvtQh9bZHR33rT5ICMV7R9FswcOz6dum9x+aELb3v/SFnIFQMKqOnYbnSse5upzgOPormNMwfJgebGWPbn/Vldst/A6UsKASZSMkO11QGIx0B/41y5zpngHIxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(71200400001)(8676002)(8936002)(7696005)(66446008)(478600001)(66556008)(66476007)(83380400001)(55016002)(64756008)(186003)(26005)(33656002)(66946007)(6506007)(86362001)(9686003)(4326008)(316002)(52536014)(110136005)(54906003)(76116006)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bHFvZnZJSmlVcFlVMllyNlEzdHdVYUJDdGpRZVhMN2VPT09ieDRqUm01N053?=
 =?utf-8?B?TXBEdFJPeFFLOEh2MWo4OVpEVmZjWms1eXMvN1JKQU11VUJYQ2I5SjNTQTZz?=
 =?utf-8?B?UEo1T1RYRWFmUlZURjMyaXphUnY5VFpuL3YrVGxIOG16MUFPZWdySW00UWwr?=
 =?utf-8?B?MzNWejdkVDNESFJXcUpLNHpmYVBKOWM0b0lJZmJQMWdsd2pscTFkbFM5L3JX?=
 =?utf-8?B?RDB1ckdKZVdRbWRxKzNPWGF4Y1FzZWpabnJHdnU0UFVXSWlxTWdBUEtnQzRh?=
 =?utf-8?B?YUxFRXZoTXpWT0RDODdxRHZlY1dqS1ovbS9DSDhDQXVjTXVleld6ZktFeXc3?=
 =?utf-8?B?NTZ0OXpLMzhYZ3V1Njg3bFFLYUdIYU9NRCtBWTNsd3NFaGJyUlE1Z3dlbzl5?=
 =?utf-8?B?eW1tem5aZnc5Vms5RXA3UlIwOVFCZENaYURFZDZPS0kvYVV5VG1tSVRvZ0xH?=
 =?utf-8?B?Wjl3bC85bnRJYVBrQlA1aGhpOXUxdHlWcWpFMnRkYmNQd3Fibks2cEdwTFNp?=
 =?utf-8?B?QUEzU3F1dkpTRzRJckM3MVpvS21LWFYySW5GTXM5OUxGSUhTcDkzUDhjSEtQ?=
 =?utf-8?B?c3RyMjJnR3RFUS9QTEh5OThwVys2cTk3ZnFBNTRjQStsKzRqNHl5S1BrRk9h?=
 =?utf-8?B?UzEzWTY5QW9FYW5iNWxTZDBTV3kvYTA1VVJHZW9KTE55NHB2UzNHS3RieUxz?=
 =?utf-8?B?N2dCdXJ4THR5ZUVzN3JtMHUrbXhnWExxN3NCWHdXY0dYbHF6VkpRWExyeXhO?=
 =?utf-8?B?dm4wTUdESUlkUEdSMm5VS0xWTGQ4Q1pDZ2tNWVhrSitqdmVIZnJPTUo0eTcw?=
 =?utf-8?B?M0t5TnRvSnJidzB6RDd5My9JNEVTZ3Nvcyt1WDZtZHJLSWhPUkZzVzR0OVFT?=
 =?utf-8?B?R2h3UG5LVGFoalM4T1BYNThva0tTR2FQTGFIcy8yUC8vUU9NZjJsYUxwbGQy?=
 =?utf-8?B?ZUJJVG1DSlhVYXFWeW9HRWoyb2hmdFViQUI1VnJUeThBMzk1WXpXSGVGMkly?=
 =?utf-8?B?U2VGSjFyTnJWZkNaVlA3ZzdhbWRuYkNpT1h2Q3hrL2Q0ekF2VXJHL2p6OHR4?=
 =?utf-8?B?MkY1UkxqK3hZbE1mbE85S0lmWnBKSGtNUTJuVVJib2NRdTlUaXBET3JwaVh5?=
 =?utf-8?B?TUViSGVWRnE4V0JVckxRWEtxMEsyKzRXdmpTQUNSemxkTTdYbllnSXgxakhQ?=
 =?utf-8?B?aFBKVzBBWHNQOVhJQkltaklXazVNS2ViUWQvbTkreWp6cXFkdEJqYVVMWW84?=
 =?utf-8?B?bDU2bWZ0VFFYN256d3NOekNWdGR4UTNvYlNrUGg4YXZUZEhmdDhjeU1YWUtt?=
 =?utf-8?B?U1hyZXMwL1ZraUFFMnY0ZTNLQW5jZFFYNlJYOHlBbEJNczRqYlJiWXRlY2xU?=
 =?utf-8?B?WXk3R2l6djRtbmQ5OUw0aTZXOVdSV3hjZXZoT2JZaWVySml2bzhzOFNKbVpN?=
 =?utf-8?Q?JzRHw9fd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c700cc2f-e762-409f-318c-08d8c680caba
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 07:12:53.0964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ztclkDQArxQvJx0cNAqXsqiFwHJZ8MVZUJt1FhBLffPOwsg/X7EUUtTsfcpnPSzhcid7Nz22onEH8p46zwjgKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3656
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICsjZGVmaW5lIFdPUktfUEVORElORyAwDQo+ID4gKyNkZWZpbmUgQUNUSVZBVElPTl9USFJT
SExEIDQgLyogNCBJT3MgKi8NCj4gUmF0aGVyIHRoYW4gZml4aW5nIGl0IHdpdGggbWFjcm8sIGhv
dyBhYm91dCB1c2luZyBzeXNmcyBhbmQgbWFrZSBpdA0KPiBjb25maWd1cmFibGU/DQpZZXMuDQpJ
IHdpbGwgYWRkIGEgcGF0Y2ggbWFraW5nIGFsbCB0aGUgbG9naWMgY29uZmlndXJhYmxlLg0KQXMg
YWxsIHRob3NlIGFyZSBocGItcmVsYXRlZCBwYXJhbWV0ZXJzLCBJIHRoaW5rIG1vZHVsZSBwYXJh
bWV0ZXJzIGFyZSBtb3JlIGFkZXF1YXRlLg0KDQoNCj4gDQo+ID4gQEAgLTMwNiwxMiArMzI1LDM5
IEBAIHZvaWQgdWZzaHBiX3ByZXAoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0DQo+IHVmc2hj
ZF9scmIgKmxyYnApDQo+ID4gICAgICAgICAgICAgICB1ZnNocGJfc2V0X3Bwbl9kaXJ0eShocGIs
IHJnbl9pZHgsIHNyZ25faWR4LCBzcmduX29mZnNldCwNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdHJhbnNmZXJfbGVuKTsNCj4gPiAgICAgICAgICAgICAgIHNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJmhwYi0+cmduX3N0YXRlX2xvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4gKyAg
ICAgICAgICAgICBpZiAodWZzaHBiX21vZGUgPT0gSFBCX0hPU1RfQ09OVFJPTCkNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgYXRvbWljNjRfc2V0KCZyZ24tPnJlYWRzLCAwKTsNCj4gPiArDQo+
ID4gICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgfQ0KPiA+DQo+ID4gKyAgICAgaWYg
KHVmc2hwYl9tb2RlID09IEhQQl9IT1NUX0NPTlRST0wpDQo+ID4gKyAgICAgICAgICAgICByZWFk
cyA9IGF0b21pYzY0X2luY19yZXR1cm4oJnJnbi0+cmVhZHMpOw0KPiA+ICsNCj4gPiAgICAgICBp
ZiAoIXVmc2hwYl9pc19zdXBwb3J0X2NodW5rKHRyYW5zZmVyX2xlbikpDQo+ID4gICAgICAgICAg
ICAgICByZXR1cm47IDwtICp0aGlzKg0KPiA+DQo+ID4gKyAgICAgaWYgKHVmc2hwYl9tb2RlID09
IEhQQl9IT1NUX0NPTlRST0wpIHsNCj4gPiArICAgICAgICAgICAgIC8qDQo+ID4gKyAgICAgICAg
ICAgICAgKiBpbiBob3N0IGNvbnRyb2wgbW9kZSwgcmVhZHMgYXJlIHRoZSBtYWluIHNvdXJjZSBm
b3INCj4gPiArICAgICAgICAgICAgICAqIGFjdGl2YXRpb24gdHJpYWxzLg0KPiA+ICsgICAgICAg
ICAgICAgICovDQo+ID4gKyAgICAgICAgICAgICBpZiAocmVhZHMgPT0gQUNUSVZBVElPTl9USFJT
SExEKSB7DQo+IElmIHRoZSBjaHVuayBzaXplIGlzIG5vdCBzdXBwb3J0ZWQsIHdlIGNhbiBub3Qg
YWN0aXZlIHRoaXMgcmVnaW9uDQo+IHBlcm1hbmVudGx5LiBJdCBtYXkgYmUgcmV0dXJuZWQgYmVm
b3JlIGdldCB0aGlzIHN0YXRlbWVudC4NClllcy4NCkkgYWxyZWFkeSBub3RpY2VkIHRoYXQgcmVw
bHlpbmcgdG8gR3JlZy4NCkZpeGVkIHRoYXQgd2hlbiBJIGRyb3BwZWQgdGhlIHVzZSBvZiBhdG9t
aWMgdmFyaWFibGVzLg0KIA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNocGIuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmgNCj4gPiBpbmRleCA4YTM0YjBmNDI3
NTQuLmIwZTc4NzI4YWYzOCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hw
Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaA0KPiA+IEBAIC0xMTUsNiAr
MTE1LDkgQEAgc3RydWN0IHVmc2hwYl9yZWdpb24gew0KPiA+ICAgICAgIC8qIGJlbG93IGluZm9y
bWF0aW9uIGlzIHVzZWQgYnkgbHJ1ICovDQo+ID4gICAgICAgc3RydWN0IGxpc3RfaGVhZCBsaXN0
X2xydV9yZ247DQo+ID4gICAgICAgdW5zaWduZWQgbG9uZyByZ25fZmxhZ3M7DQo+ID4gKw0KPiA+
ICsgICAgIC8qIHJlZ2lvbiByZWFkcyAtIGZvciBob3N0IG1vZGUgKi8NCj4gPiArICAgICBhdG9t
aWM2NF90IHJlYWRzOw0KPiBJIHRoaW5rIDMyIGJpdHMgYXJlIHN1aXRhYmxlLCBiZWNhdXNlIGl0
IGlzIG5vcm1hbGl6ZWQgYnkgd29ya2VyIG9uIGV2ZXJ5DQo+IHNwZWNpZmljIHRpbWUuDQpEb25l
Lg0K
