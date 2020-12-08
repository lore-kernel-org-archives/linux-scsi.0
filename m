Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296DAC3527A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 09:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E93A123A82
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 09:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgLHJGe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 04:06:34 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2924 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgLHJGd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 04:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607418666; x=1638954666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DGoDfxacZsNzTIGcCSLfOZGl5o2sJXiQcCzkorq1LVw=;
  b=ep3vfe6csLkhdurJSvhNlrNWPIDIzifSR2xDv2nC1hyIS4xC2MGqDlYl
   Wwhbbclf2nLHYaKoGO0HrkMafzeBYpaUOrweP9ii/CJrWZ9UfijqNPO4u
   G1zqQpuxOfTT1jxa3xG5r8zxCGNm0h2PEt3D9a0HWJYlyOgPUobsjL7uZ
   oBeoMg3MFi3tVtYIxa4SImY8SZN0IV4vI7owdQ7470Jb4n2v5PeSZIZFG
   g4PINnTDTy349puKdVeBelsYsej9ccAG5W1ciZ7UnND+pH9oEhS7sYjFH
   oRoc7iaG10RIT3Uywu/NHSAy494WQECTZ9Qy7Mm4YALQl4Zm78jfYiH4H
   w==;
IronPort-SDR: TCOdiy8ILfBICdCTnBtRKxlbnzzUjYSX5xtV9E8eJ/9iV3GCgWYCjEKl6RsjjDY5UBDDolGhEC
 /BJVH3j1mmeEJ5CeinSVwR6Tp4SGenLfzfRFsXs/FEcYpU2wPgzzxI2pfunJD3JT6CJ4ZutoQW
 hd0mhEUEBifh3yG1PlG32E3RCQ7LioDuUEjim6AZH5iUTbjji4QAfSxuEQKsUeRtmEAXrqxb8v
 pTg55poCHkda74lE7IN7fGuywYRCSNtaCRkcU+em6YyTuY3ggm97m132GyISPXzT9bv9kKLIu1
 Y3w=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="258389492"
Received: from mail-sn1nam02lp2055.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.55])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 17:09:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpghsL5F+fsB1XDHtPi3g44sRrmsI41CI2dqb3Kyek/iNePrMaf3dMTTufzfFIYRCprYHao6s2OipWWP8NcHacO86uKwCD3PRkE4HL9Fr862o2gd7rfudO62QAO8cbJCSuiz5wazckI6URveHZb8kuqN51f+yynujjhUqUuYTMiiYKgiPYj/BLhxfaq4729kHz8kk24uY3N8sujl0f59cqopgqhsmrI/AD2TF3c+2ICN6WweVfPZSAIuzU3clonlJ0qyZws8XCOuLenduiI7cilt8rOyXxHW4G2vIePiG6TSK8O3qXgttm6Sm8Ia5KdGTjnNy1euKvxlqi7wISk3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGoDfxacZsNzTIGcCSLfOZGl5o2sJXiQcCzkorq1LVw=;
 b=GFLc7CN7uZnDxhzUEheX2RbcaZKB8Uy/JyxMwpz4zCzRB5dHSWkvSoy4XJhl4ifqXbK8scNeAz6j8LlTxJXCsU1Dqurtr+WyC8SfK6wAdjJuRjS+el1uJIFt8WwT75xoenRqGYgSY+tOh2qcsxHRhuZqW7to3bXqce5ADloIwMUtIWQXIxo1MxLcQ3ktl2i+8TdTIsXQIQKck49uJLO+AhZBHJ7Sy/1GfHmWiMlPWniwbIX+juhSySfMOUWydfWTQXRJsk1PnON5JNVWju2g/P2HFiv5SleQQ1grNbWqHoT5Rz8bplszOyVRwdca3a6/bS9SL+VWvxw3kvEtcC3rVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGoDfxacZsNzTIGcCSLfOZGl5o2sJXiQcCzkorq1LVw=;
 b=QfmmXpxefi8Bmcp4xGYefTHev33RQ4BqVl751TpC/VBeklOlYBHoitESyQsF65JIR594TbL1G/hypzcb5C7wo4g6XKdRibK7QGiYU6RvvLMtP4XKyjRUKXWcpZp2Fj2I9561ku2DQQLSLDXg1fBjgLqRNbkuoLNEH1zHEmDNcUQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7003.namprd04.prod.outlook.com (2603:10b6:5:1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.20; Tue, 8 Dec 2020 09:05:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 09:05:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWy7iCBBJB+/QbNEOT3LqFCSOQUanrRfZggAA34wCAAWjXgA==
Date:   Tue, 8 Dec 2020 09:05:20 +0000
Message-ID: <DM6PR04MB657584B4590496FA6BF11725FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-3-huobean@gmail.com>
         <DM6PR04MB6575AED736BE44CA8D4B8998FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <2ef12e328ecdc411e7d145a331d7c8ce668bf2be.camel@gmail.com>
In-Reply-To: <2ef12e328ecdc411e7d145a331d7c8ce668bf2be.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0d73ed4-e2a0-4aed-a93c-08d89b5863c6
x-ms-traffictypediagnostic: DM6PR04MB7003:
x-microsoft-antispam-prvs: <DM6PR04MB70033DB08D545F9C89ED456AFCCD0@DM6PR04MB7003.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rOBoLyojfxY2BCwqpdjazB2t79C7YAZai/rJF+TpsE8x6uv2NfYSRgRF8zaj3VTxwX8q8deVeGUiO36Er4PFuGDBafDMKQeN/U72MCqQQh6oaAQKKHtcl1jl0zg4VzIrE+HTsN9sIcAmcuSq4veEpjzUf/u+DJkMr+L5X0DF7VorZleOK1+HRpchBf3HbYT/xITXo41U8OxWeYePWHdi+uKwmPu7sK+D9RaMUxeP8dJLXrdmAHbJh+/gtIV92AR4G+o54dH7jWCv+2OqfDPTJrem3ruEBLLmymr3mLxIOXvMPR228mrGnWQA8a5c+xhGi++wESiN0ozDBkmm/RzJXpTJj7ycVVdqTFQnHtZhZnPPzwuTgGKcGZQD3l4Dyp6HklhA2zyoxeWOmEWgRx2tZRO1dQdcneF4ApPBmRxceiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(5660300002)(83380400001)(478600001)(71200400001)(6506007)(54906003)(8676002)(86362001)(66556008)(66946007)(55016002)(64756008)(9686003)(66446008)(66476007)(110136005)(7416002)(7696005)(33656002)(4326008)(8936002)(76116006)(2906002)(26005)(186003)(921005)(316002)(52536014)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z1RsYmoyVDhENFhDNnB4UnFCUUNDalhYemROTW1HbmFlQmFGYlMvSHF3TXdq?=
 =?utf-8?B?ZTZYci9HOXBSU3ZFM2RSM3dHUm02TGtlVHBsNFhkajI3WTN1UG5vZmlBNGJX?=
 =?utf-8?B?QU5oUjk0R2lyeDVXOElqTG1MNllUYklycGhiaWd4RThYWHJsM2N4czA5Sk0y?=
 =?utf-8?B?SGpJYWo4YS92cTdvQU9meUxha28xSjIwdHNhVkREbC9OaXlYSmxKSFRxQW9i?=
 =?utf-8?B?NFlnNXFMNGlheWZHTytnY2FmZEZvLzRTSUxQeWovOTQyeTZwUTdxTU9Zd0Zy?=
 =?utf-8?B?QUVLYlNaSHBpTXl5ZWN4VG1ERG1MVEpVVGI0UXpjT3AyS3l5VmJDUkdyaGRK?=
 =?utf-8?B?REpKa0hxNEgvaG9lN3lDQ0dxaGFkMTJxT0NJckpSWU5ORHkvQnR0YVM5OU9J?=
 =?utf-8?B?eWFEN0E2enB4blJaU1A3Nm9vMUVFRDFvSkRFQ0tZQUl3VTlTS0ZnTVlRYVNs?=
 =?utf-8?B?dEpHY2NVKytUTXpJNXY0QnBIcmFWQVRJNnJKbThMVzZBTWZkVjlYdTJkbkRN?=
 =?utf-8?B?OUlRRUp0TE43WjE0RzlRcXRJOFMyeHpBWFhaL29UWjRabFNlMkY5cjN0M1h1?=
 =?utf-8?B?WUVuSmQwYUZ2OXdWbDltS1Z4TVljVUduVEltK05USnBkdHYzQ21jMHNIdm9T?=
 =?utf-8?B?NmVVdi9qdWJZQnpCS2JDVWRLajJObVFDZURSWmFEN2RlT0Z1Zm5sK25OTE9P?=
 =?utf-8?B?alBzVGlyYmZWc1U3bmdKTjZyNGV6TmxvbmpFN3lqMVhRMm01WE1NTlVkVWRu?=
 =?utf-8?B?b3ZjODZETnFaQWZ0amhINTlTUG1zVFVRNUNKcHNsL3hWMmN4Z0U0QmNPUlps?=
 =?utf-8?B?enhselVqc21HSlV6YnQ2aGpNTU9Wbk5tbVVGU2RIOU82cjViT1dzd1NiMnMz?=
 =?utf-8?B?ZmUvNlkrS29kZWNCNU1SNjdGb09VeThtNEVzZWpib0xmOEZyU25aQTZJcUts?=
 =?utf-8?B?OGp1aFFITnJ0YUtxSkJPN1E1TzdEbG9HdVVuRXh5VE9CNXllYlN4ZDN0bTNU?=
 =?utf-8?B?OFN2SDJwL2Z5ZDQ4MkpEUXMvMEkvZStvSWJ4WlU3V2s1RGZONXhKUXp6eEo5?=
 =?utf-8?B?cFJmL05aU1BnbW4wOGxOYkkybEwyT1ovdUx3RitqekV1ZTNDWDJ0Q0dXTktS?=
 =?utf-8?B?cy9CS1JmaVNjeEk1b0NzejRMNHYvY0NRKzVWRGZpRlhxSmxOR3NpK2h5ZGNi?=
 =?utf-8?B?eUhCcVI5Ti83eFR1MGVqbEJ2dzRncFdYbkl5aGFHeGtrcVk4Q1FBZlExbklm?=
 =?utf-8?B?MnhEVS8vZFRHREwyWUZqL0wrSHgwVzhHZ2hOTTRyWVA4OGJDTnc0Nm5mOTdS?=
 =?utf-8?Q?K5XpGtPiG2H1E=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d73ed4-e2a0-4aed-a93c-08d89b5863c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 09:05:20.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtqDK+6iYM3CXKXpqx8HDJHWG1AoCj3jyAKTtjDT2Ds6stwOgWl8a5GiSDt5l2GPchbEm8tQkJTgWvE+ILBUqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiBNb24sIDIwMjAtMTItMDcgYXQgMDg6MDIgKzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBKRURFQyBVRlMgMy4xIFNwZWMsIElmDQo+ID4gPiBmV3Jp
dGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJlcm5hdGUNCj4gPiA+IGlzIHNldCB0byBvbmUs
IHRoZSBkZXZpY2UgZmx1c2hlcyB0aGUgV3JpdGVCb29zdGVyIEJ1ZmZlciBkYXRhDQo+ID4gPiBh
dXRvbWF0aWNhbGx5DQo+ID4gPiB3aGVuZXZlciB0aGUgbGluayBlbnRlcnMgdGhlIGhpYmVybmF0
ZSAoSElCRVJOOCkgc3RhdGUuIFdoaWxlIHRoZQ0KPiA+ID4gZmx1c2hpbmcNCj4gPiA+IG9wZXJh
dGlvbiBpcyBpbiBwcm9ncmVzcywgdGhlIGRldmljZSBzaG91bGQgYmUga2VwdCBpbiBBY3RpdmUg
cG93ZXINCj4gPiA+IG1vZGUuDQo+ID4gPiBDdXJyZW50bHksIHdlIHNldCB0aGlzIGZsYWcgZHVy
aW5nIHRoZSBVRlNIQ0QgcHJvYmUgc3RhZ2UsIGJ1dCB3ZQ0KPiA+ID4gZGlkbid0IGRlYWwNCj4g
PiA+IHdpdGggaXRzIHByb2dyYW1taW5nIGZhaWx1cmUuIEV2ZW4gdGhpcyBmYWlsdXJlIGlzIGxl
c3MgbGlrZWx5IHRvDQo+ID4gPiBvY2N1ciwgYnV0DQo+ID4gPiBzdGlsbCBpdCBpcyBwb3NzaWJs
ZS4NCj4gPiA+IFRoaXMgcGF0Y2ggaXMgdG8gYWRkIGNoZWNrdXAgb2YNCj4gPiA+IGZXcml0ZUJv
b3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZQ0KPiA+ID4gc2V0dGluZywNCj4gPiA+IGtl
ZXAgdGhlIGRldmljZSBhcyAiYWN0aXZlIHBvd2VyIG1vZGUiIG9ubHkgd2hlbiB0aGlzIGZsYWcg
YmUNCj4gPiA+IHN1Y2Nlc3NmdWxseQ0KPiA+ID4gc2V0DQo+ID4gPiB0byAxLg0KPiA+ID4NCj4g
PiA+IEZpeGVzOiA1MWRkOTA1YmQyZjYgKCJzY3NpOiB1ZnM6IEZpeCBXcml0ZUJvb3N0ZXIgZmx1
c2ggZHVyaW5nDQo+ID4gPiBydW50aW1lDQo+ID4gPiBzdXNwZW5kIikNCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4NCj4gPiBZb3UndmUgYWRk
ZWQgdGhlIGZpeGVzIHRhZywNCj4gDQo+IHllcyxpdCBpcyBhIGJ1Zy4NCj4gDQo+ID4gIGJ1dCBt
eSBwcmV2aW91cyBjb21tZW50IGlzIHN0aWxsIHVuYW5zd2VyZWQ6DQo+ID4geW91IGFyZSBhZGRp
bmcgcHJvdGVjdGlvbiB0byBhIHNpbmdsZSBkZXZpY2UgbWFuYWdlbWVudCBjb21tYW5kLg0KPiA+
IFdoeSB0aGlzIGNvbW1hbmQgaW4gcGFydGljdWxhcj8NCj4gPiBXaGF0IG1ha2VzIGl0IHNvIHNw
ZWNpYWwgdGhhdCBpdCBuZWVkcyB0aGlzIGV4dHJhIGNhcmU/DQo+ID4NCj4gDQo+IHNlZSB0aGUg
U3BlYzoNCj4gIg0KPiBJZiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJlcm5hdGUg
aXMgc2V0IHRvIG9uZSwgdGhlIGRldmljZQ0KPiBmbHVzaGVzIHRoZSBXcml0ZUJvb3N0ZXIgQnVm
ZmVyIGRhdGEgYXV0b21hdGljYWxseSB3aGVuZXZlciB0aGUgbGluaw0KPiBlbnRlcnMgdGhlIGhp
YmVybmF0ZSAoSElCRVJOOCkgc3RhdGUuDQo+IA0KPiBUaGUgZGV2aWNlIHNoYWxsIHN0b3AgdGhl
IGZsdXNoaW5nIG9wZXJhdGlvbiBpZg0KPiBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdI
aWJlcm5hdGUgYXJlIHNldCB0byB6ZXJvLg0KPiAuLi4uDQo+IA0KPiAiDQo+IElmIGZXcml0ZUJv
b3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSA9PTAsIGRldmljZSB3aWxsIG5vdCBmbHVz
aA0KPiBXQiwgZXZlbiBpZiB5b3Uga2VlcCBkZXZpY2UgYXMgImFjdGl2ZSBtb2RlIiBhbmQgTElO
SyBpbiBoaWJlcm5hdGUNCj4gc3RhdGUuDQpPSywgc28gd2hhdCB5b3UgYXJlIGFjdHVhbGx5IHNh
eWluZywgaXMgdGhhdCBzaW5jZSB3ZSBhcmUgb25seSB0b2dnbGluZyB0aGlzIGZsYWcgb25jZSBw
ZXINCmxpbmsgc3RhcnR1cCAvIHJlY292ZXJ5LCBpbiBjYXNlIG9mIGEgZmFpbHVyZSwgaG93ZXZl
ciByYXJlIC0gdGhlIGhvc3QgbWF5IGJlIHN0aWxsIGtlZXAgdmNjIG9uDQpmb3Igbm90aGluZywg
YXMgdGhlIGRldmljZSB3aWxsIGRvIG5vdGhpbmcgaW4gdGhhdCBleHRyYSB3YWtlIHRpbWUuICBS
aWdodD8NCg0KQnV0IGV2ZXJ5IHRpbWUgdWZzaGNkX3diX25lZWRfZmx1c2goKSBpcyBjYWxsZWQg
d2UgYXJlIHJlYWRpbmcgc29tZSBvdGhlciBmbGFncy9hdHRyaWJ1dGVzPw0KV2hhdCBhYm91dCB0
aGVtPyBXaHkgbm90IHByb3RlY3RpbmcgdGhlbSBhcyB3ZWxsPw0KDQpTb3JyeSAtIHRoZSB3aG9s
ZSBpZGVhIGRvZXNuJ3QgbWFrZSBhbnkgc2Vuc2UgdG8gbWUuDQoNClRoYW5rcywNCkF2cmkNCj4g
DQo+IEJlYW4NCj4gVGhhbmtzLA0KPiANCg0K
