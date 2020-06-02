Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2015C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 12:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B602053B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 12:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OR693B8p";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bjQ0qoq7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFBM0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:26:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20398 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbgFBM0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 08:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591100760; x=1622636760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=F838rpV7s9/tF2vVdnfVWKkA7xFexKsB/x/BwRoGF2Q=;
  b=OR693B8pukAMcecvahhxHedefnImb5BRsQHWalYJnve8BnMpx/aNI0Ug
   EX4Gzfu0B4tYel3XFVt/CGv6IsQPvOPesHv7cc65CVLJYQMNezdV9TkJA
   eQHcyMErUW7PBhIrE9SquD6IhsREtRYlKrqYvuuMPE0e8onAk1vqeNSP6
   XHFIAynmKmXlV4cCmkBrjOEt/ktI4oP+0PZXNtuP1DJLo0QPLeDxnrMmS
   ZBsNjlqZQzPLL+Y8SwFlItzILEIw57OuwBzZmS2/36fjUOZdNyYz48uqw
   gj9r57Yr/ReYiP3NBeT+fPuuamBCsV4lBJxaSzm9Gg2I8SUmogpUlfSi4
   g==;
IronPort-SDR: /EPFaHiQycbeUM1Mqm8Eeg1YEwckhErWXmAuLJclS11W5k/VZt0uyM6Jnew5+1mBBMEyVNb/5o
 CEqzKYqmpvz2bBEjFs/6C87as+jBtQ7qAFKVO0SdYh3GJnW45JcfMFJCWWnD3CdaeWChxCuYnh
 iLnm95a7EmdCSzBgQ2ff6E3lQHtEKUCTE8covOZP3qP9BXU0LQoWEdPMKbU9RrhPLAqIHDC15O
 e8MmkkR80W1CBxOf0Eg2xrz5TmxNK23kTzGgx7JCCgvKUu8+5WBUq9kIkg37KBK1TC74eTeJ3g
 qCg=
X-IronPort-AV: E=Sophos;i="5.73,464,1583164800"; 
   d="scan'208,223";a="139344975"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2020 20:25:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Haq37J4idBKAW+Zpbm6l9QuJDog00cRLRnuL8P07JJa7euKf0BO8vRGiDErkNRgyI3IOmgMTuZ/zp0l3W4hpRuPo/Z6NKTDNUFifu2K943BMNh8c58Vun25WFphB6qjIC1Afv5vekaWjfUNZMB58+ZQT23MBuMkPphPoRuWhkkrm67CALjL0iEKajvbjv/VCloqSgBU+Xv5mT/ilCRoXG4GvguOR6vYZ1QQbWkH3YP6gbrg3AKcZ6UXxXjxMleRcc9wj/H4xC5miqtnF+PL5twVlSBS8ig3BlndUO1FJQo8XRkEcG6yl2mxHjtWKzZ/LSouH9HOB6cB6bwRm0ayUUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JykLYAYwZ/UNJLGiAAzTLBEI2246Lk/Wc81wwEJ5x+U=;
 b=HrLqExHw9OiTb2evy8LuXOsHTZytAwQxI3J1mIJpG9fq6fGJ8dbjRC6x5Ncr88X6KBseVialfbYNBlvNfcRV+Jzz2rGhq5uPGCD0s0f/6694YaZMwr6zsAAY109TuoC9ax3HsFKkXMSqGlaOGgP7flxtahV5dsoY3QE8g/l50XfsBGvmWUl+qyOJE/sO9DbL34jDqOC5Oin4eKmOoF7zgtwsYRrOCmaE0lWaw5q2nqIgd9WYQnhdQPvuOYrveaKMQQEqh2bjRTfVkM+HDIv7vE8avWag1VQoqRIjx1mTVaGqxWXYuJKTZXb8CZeppWDCCLr9BusiNcu7a/8g+Wa3bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JykLYAYwZ/UNJLGiAAzTLBEI2246Lk/Wc81wwEJ5x+U=;
 b=bjQ0qoq7PkuMn/xd8ZuA2FiuZv2U6p3Zfrss14Eo5yN8BGL4W5+N6DCFET17LlPPy14ksxVKjm7aGmgBft++uiHNBFem0mt4OQQwbtZZFC2rVIqqt56UJSiny+o1bp8sB3btXoNuqc3/xBvOsfMAehyGG9/PB7WkovTL/SP+Z8w=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5038.namprd04.prod.outlook.com (2603:10b6:805:9e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Tue, 2 Jun
 2020 12:25:56 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 12:25:56 +0000
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
Subject: RE: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer while
 memcpy
Thread-Topic: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer
 while memcpy
Thread-Index: AQHWN11kesoGcNEhCkK5z/BoKlc8lajDQ7UQgAHxgoCAAA2lsA==
Date:   Tue, 2 Jun 2020 12:25:55 +0000
Message-ID: <SN6PR04MB464036A74AA935BEE35280CEFC8B0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200531150831.9946-1-huobean@gmail.com>
         <20200531150831.9946-4-huobean@gmail.com>
         <SN6PR04MB4640741E1DC89A927F8A60A5FC8A0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <43a81bce2159ccd290e5dfe4a69199f56c379ef7.camel@gmail.com>
In-Reply-To: <43a81bce2159ccd290e5dfe4a69199f56c379ef7.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 549f197c-cbf9-4c3f-a2a9-08d806f01961
x-ms-traffictypediagnostic: SN6PR04MB5038:
x-microsoft-antispam-prvs: <SN6PR04MB50389547687A597C52A4FEFEFC8B0@SN6PR04MB5038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b134gDXslSdJd/PNwqIB6rbL1hgMQewkvHLcl7YlW7Yf9+pLlGj/ePlJx4vdQJYdhkzS7IvTFsM7U45/Eup1qBYJJeK8zgR8/OF5S4Ozp5qxpQrYdRGHY9C8nl8FvDa0KRKF2wBgImEXRYgQaxdeosbhYBqwtAe9hONFNJAilmE9Z+KWoTU+s1Jk+Xr/SmuObplRNtn/iB78vlFXn+dcqlrgYYvgz0ON+f5Mpd5H0tx8XY1RoXuzQPTLCxJaEZa3emhoPyjLAby2OTxwWj2Qb8kd2TL+akagsAXBjgnMVaXCEB7FfC9ryZBUCfKlyvsjX4TYGwhZ9noBQDPzPAEsAPvlzO1EjjKZgfUi5q9aPqwfq2yFD1X+/76VEOQ1U2Yq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(26005)(54906003)(4326008)(83380400001)(86362001)(71200400001)(7416002)(186003)(53546011)(7696005)(6506007)(33656002)(5660300002)(64756008)(66556008)(66446008)(66616009)(76116006)(110136005)(66946007)(2906002)(9686003)(52536014)(8936002)(8676002)(498600001)(99936003)(66476007)(55016002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: W2hPkE2KKgEnJmQolufts1Q/E5T+voto3WOylnOxZAKW+gnY56zxL2KyMCjw3jScYOTm4bWjzuysD9NbqTjo8ilkw42THS5izFgfcAn9BoInBH6Xd3513rz7KT2ImHoRxYOgd+9ZoOZSFKPon2/yuZeYIV5MZ+nO+Jz+8twsthRG/8UGIQHO+R2A9qJ54aTRYGZee/STLx1luMn6+6scCtdO19z8mt8iR1eRszreyExzs8xY7B2NbBWHn30ZpJCrparT4V/l0czGHiOxVcCQ4mCJQ1PkGrq0Jn1yPwZSBKoPlfCBUH5hmnKNs7g2z9AdvIQzonagEGA3W60zWvw1WnL0H/x7vdxSwO5APsFDBVpFFFL46Dh7CIM1NSgkQE6yns6W+kkAONs5n35XXpzfqwHLjlQQpyZYZdPrSOplbWEvbhzFSteIgVodF3oENELfeYGpX4JPwOGTHpk1TWGzrmO71V6Cl5ADEK8MStGX6rI=
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_SN6PR04MB464036A74AA935BEE35280CEFC8B0SN6PR04MB4640namp_"
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549f197c-cbf9-4c3f-a2a9-08d806f01961
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 12:25:55.9472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lh2Z5euy6WVGJpmmeN05q2HeMstEE61JEgsRQ/thYwJVYyjN7EsiMDxbqbtS2srEfvC3e/JP7xG3VpUhgRJrkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--_002_SN6PR04MB464036A74AA935BEE35280CEFC8B0SN6PR04MB4640namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SG93IGFib3V0IHNvbWV0aGluZyBsaWtlIHRoZSB1bnRlc3RlZCBhdHRhY2hlZD8NCg0KVGhhbmtz
LA0KQXZyaQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJlYW4gSHVv
IDxodW9iZWFuQGdtYWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgSnVuZSAyLCAyMDIwIDI6MzYg
UE0NCj4gVG86IEF2cmkgQWx0bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPjsgYWxpbS5ha2h0YXJA
c2Ftc3VuZy5jb207DQo+IGFzdXRvc2hkQGNvZGVhdXJvcmEub3JnOyBqZWpiQGxpbnV4LmlibS5j
b207DQo+IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBzdGFubGV5LmNodUBtZWRpYXRlay5j
b207DQo+IGJlYW5odW9AbWljcm9uLmNvbTsgYnZhbmFzc2NoZUBhY20ub3JnOyB0b21hcy53aW5r
bGVyQGludGVsLmNvbTsNCj4gY2FuZ0Bjb2RlYXVyb3JhLm9yZw0KPiBDYzogbGludXgtc2NzaUB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2NCAzLzVdIHNjc2k6IHVmczogZml4IHBvdGVudGlhbCBhY2Nlc3MgTlVMTCBw
b2ludGVyIHdoaWxlDQo+IG1lbWNweQ0KPiANCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5h
dGVkIGZyb20gb3V0c2lkZSBvZiBXZXN0ZXJuIERpZ2l0YWwuIERvIG5vdCBjbGljaw0KPiBvbiBs
aW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXIg
YW5kIGtub3cgdGhhdA0KPiB0aGUgY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IGhpIEF2cmkN
Cj4gdGhhbmtzIHJldmlldy4NCj4gDQo+IA0KPiBPbiBNb24sIDIwMjAtMDYtMDEgYXQgMDY6MjUg
KzAwMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gPiBJZiBwYXJhbV9v
ZmZzZXQgaXMgbm90IDAsIHRoZSBtZW1jcHkgbGVuZ3RoIHNob3VsZG4ndCBiZSB0aGUNCj4gPiA+
IHRydWUgZGVzY3JpcHRvciBsZW5ndGguDQo+ID4gPg0KPiA+ID4gRml4ZXM6IGE0YjBlOGE0ZTky
YiAoInNjc2k6IHVmczogRmFjdG9yIG91dA0KPiA+ID4gdWZzaGNkX3JlYWRfZGVzY19wYXJhbSIp
DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiA+
ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDIgKy0NCj4gPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+DQo+ID4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCj4gPiA+IGluZGV4IGY3ZThiZmVmZTNkNC4uYmM1MmEwZTg5Y2QzIDEwMDY0
NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ID4gKysrIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ID4gQEAgLTMyMTEsNyArMzIxMSw3IEBAIGludCB1
ZnNoY2RfcmVhZF9kZXNjX3BhcmFtKHN0cnVjdCB1ZnNfaGJhDQo+ID4gPiAqaGJhLA0KPiA+ID4N
Cj4gPiA+ICAgICAgICAgLyogQ2hlY2sgd2hlcmhlciB3ZSB3aWxsIG5vdCBjb3B5IG1vcmUgZGF0
YSwgdGhhbiBhdmFpbGFibGUNCj4gPiA+ICovDQo+ID4gPiAgICAgICAgIGlmIChpc19rbWFsbG9j
ICYmIHBhcmFtX3NpemUgPiBidWZmX2xlbikNCj4gPiA+IC0gICAgICAgICAgICAgICBwYXJhbV9z
aXplID0gYnVmZl9sZW47DQo+ID4gPiArICAgICAgICAgICAgICAgcGFyYW1fc2l6ZSA9IGJ1ZmZf
bGVuIC0gcGFyYW1fb2Zmc2V0Ow0KPiA+DQo+ID4gQnV0IElzX2ttYWxsb2MgaXMgdHJ1ZSBpZiAo
cGFyYW1fb2Zmc2V0ICE9IDAgfHwgcGFyYW1fc2l6ZSA8DQo+ID4gYnVmZl9sZW4pDQo+ID4gU28g
IGlmIChpc19rbWFsbG9jICYmIHBhcmFtX3NpemUgPiBidWZmX2xlbikgaW1wbGllcyB0aGF0DQo+
ID4gcGFyYW1fb2Zmc2V0IGlzIDAsDQo+ID4gT3IgZGlkIEkgZ2V0IGl0IHdyb25nPw0KPiANCj4g
SWYgcGFyYW1fb2Zmc2V0IGlzIDAsIFRoaXMgd2lsbG4ndCBnZXQgYW55IHdyb25nLCBhZnRlciB0
aGlzIHBhdGNoLCBpdA0KPiBpcyB0aGUgc2FtZSBzaW5jZSBvZmZzZXQgaXMgMC4gQXMgbWVudGlv
bmVkIGluIHRoZSBjb21taXQgbWVzc2FnZSwgdGhpcw0KPiBwYXRjaCBpcyBvbmx5IGZvciB0aGUg
Y2FzZSBvZiBwYXJhbV9vZmZzZXQgaXMgbm90IDAuDQo+IA0KPiA+DQo+ID4gU3RpbGwsIEkgdGhp
bmsgdGhhdCB0aGVyZSBpcyBhIHByb2JsZW0gaGVyZSBiZWNhdXNlIG5vd2hlcmUgd2UgYXJlDQo+
ID4gY2hlY2tpbmcgdGhhdA0KPiA+IHBhcmFtX29mZnNldCArIHBhcmFtX3NpemUgPCBidWZmX2xl
biwgd2hpY2ggbm93IGNhbiBoYXBwZW4gYmVjYXVzZSBvZg0KPiA+IHVmcy1ic2cuDQo+ID4gTWF5
YmUgeW91IGNhbiBhZGQgaXQgYW5kIGdldCByaWQgb2YgdGhhdCBpc19rbWFsbG9jIHdoaWNoIGlz
IGFuDQo+ID4gYXdrd2FyZCB3YXkgdG8gdGVzdCBmb3IgdmFsaWQgdmFsdWVzPw0KPiANCj4gbGV0
IG1lIGV4cGxhaW4gZnVydGhlcjoNCj4gd2UgaGF2ZSB0aGVzZSBjb25kaXRpbm9zOg0KPiANCj4g
MSkgcGFyYW1fb2Zmc2V0ID09IDAsIHBhcmFtX3NpemUgPj0gYnVmZl9sZW47Ly9ubyBwcm9ibGVt
LA0KPiB1ZnNoY2RfcXVlcnlfZGVzY3JpcHRvcl9yZXRyeSgpIHdpbGwgcmVhZCBkZXNjcmlwb3Ig
d2l0aCB0cnVlDQo+IGRlc2NyaXB0b3IgbGVuZ3RoLCBhbmQgbm8gbWVtY3B5KCkgY2FsbGVkLg0K
PiANCj4gDQo+IDIpIHBhcmFtX29mZnNldCA9PSAwLCBwYXJhbV9zaXplIDwgYnVmZl9sZW47Ly8g
bm8gcHJvYmxlbSwNCj4gdWZzaGNkX3F1ZXJ5X2Rlc2NyaXB0b3JfcmV0cnkoKSB3aWxsIHJlYWQg
ZGVzY3JpcG9yIHdpdGggdHJ1ZQ0KPiBkZXNjcmlwdG9yIGxlbmd0aCBidWZmX2xlbiwgYW5kIG1l
bWNweSgpIHdpdGggcGFyYW1fc2l6ZSBsZW5ndGguDQo+IA0KPiANCj4gMykgcGFyYW1fb2Zmc2V0
ICE9IDAsIHBhcmFtX29mZnNldCArIHBhcmFtX3NpemUgPD0gYnVmZl9sZW47Ly8gbm8NCj4gcHJv
YmxlbSwgdWZzaGNkX3F1ZXJ5X2Rlc2NyaXB0b3JfcmV0cnkoKSB3aWxsIHJlYWQgZGVzY3JpcG9y
IHdpdGggdHJ1ZQ0KPiBkZXNjcmlwdG9yIGxlbmd0aCwgYW5kIG1lbWNweSgpIHdpdGggcGFyYW1f
c2l6ZSBsZW5ndGguDQo+IA0KPiANCj4gNCkgcGFyYW1fb2Zmc2V0ICE9IDAsIHBhcmFtX29mZnNl
dCArIHBhcmFtX3NpemUgPiBidWZmX2xlbjsvLyBOVUxMDQo+IHBvaW50ZXIgcmVmZXJlbmNlIHBy
b2JsZW0sIHNpbmNlIHVmc2hjZF9xdWVyeV9kZXNjcmlwdG9yX3JldHJ5KCkgd2lsbA0KPiByZWFk
IGRlc2NyaXBvciB3aXRoIHRydWUgZGVzY3JpcHRvciBsZW5ndGgsIGFuZCBtZW1jcHkoKSB3aXRo
IGJ1ZmZfbGVuDQo+IGxlbmd0aC4gY29ycmVjdCBtZW1jcHkgbGVuZ3RoIHNob3VsZCBiZSAoYnVm
Zl9sZW4gLSBwYXJhbV9vZmZzZXQpDQo+IA0KPiBwYXJhbV9vZmZzZXQgKyBwYXJhbV9zaXplIDwg
YnVmZl9sZW4gZG9lc24ndCBuZWVkIHRvIGFkZCwgYW5kDQo+IGlzX2ttYWxsb2MgaXMgdmVyeSBo
YXJkIHRvIGJlIHJlbW92ZWQgYmFzZWQgb24gY3VycmVudCBmbG93Lg0KPiANCj4gc28sIHRoZSBj
b3JyZWN0IGZpeHVwIHBhdGNoIHNob3VsYmUgYmUgbGlrZSB0aGlzOg0KPiANCj4gDQo+IC1pZiAo
aXNfa21hbGxvYyAmJiBwYXJhbV9zaXplID4gYnVmZl9sZW4pDQo+IC0gICAgICAgcGFyYW1fc2l6
ZSA9IGJ1ZmZfbGVuDQo+ICtpZiAoaXNfa21hbGxvYyAmJiAocGFyYW1fc2l6ZSArIHBhcmFtX29m
ZnNldCkgPiBidWZmX2xlbikNCj4gKyAgICAgICBwYXJhbV9zaXplID0gYnVmZl9sZW4gLSBwYXJh
bV9vZmZzZXQ7DQo+IA0KPiANCj4gaG93IGRvIHlvdSB0aGluayBhYm91dCBpdD8gaWYgbm8gcHJv
YmxlbSwgSSB3aWxsIHVwZGF0ZSBpdCBpbiBuZXh0DQo+IHZlcnNpb24gcGF0Y2guDQo+IA0KPiB0
aGFua3MsDQo+IA0KPiBCZWFuDQoNCg==

--_002_SN6PR04MB464036A74AA935BEE35280CEFC8B0SN6PR04MB4640namp_
Content-Type: application/octet-stream;
	name="0001-scsi-ufshcd-Simplify-ufshcd_read_desc_param.patch"
Content-Description: 0001-scsi-ufshcd-Simplify-ufshcd_read_desc_param.patch
Content-Disposition: attachment;
	filename="0001-scsi-ufshcd-Simplify-ufshcd_read_desc_param.patch"; size=2782;
	creation-date="Tue, 02 Jun 2020 12:25:29 GMT";
	modification-date="Tue, 02 Jun 2020 12:24:33 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjY2IyMTQ3NDE3MWEyZmZjNjdiN2EyMjk1MzgyODhmZDM5ODkxMTgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4KRGF0
ZTogVHVlLCAyIEp1biAyMDIwIDE1OjE0OjU2ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gc2NzaTog
dWZzaGNkOiBTaW1wbGlmeSB1ZnNoY2RfcmVhZF9kZXNjX3BhcmFtCgpBbHdheXMgdXNlIGEgbG9j
YWxseSBhbGxvY2F0ZWQgYnVmZmVyLCBhbmQgdmVyaWZ5IHRoYXQgdGhlIHJlcXVlc3RlZApwYXJh
bWV0ZXJzIGFyZSBpbmRlZWQgdmFsaWQuCgpGaXhlczogYTRiMGU4YTRlOTJiICgic2NzaTogdWZz
OiBGYWN0b3Igb3V0IHVmc2hjZF9yZWFkX2Rlc2NfcGFyYW0iKQpTaWduZWQtb2ZmLWJ5OiBBdnJp
IEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4KU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJl
YW5odW9AbWljcm9uLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMjkgKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDIwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jCmluZGV4IGFmMTRlNTIuLmYwMzZjNTkgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMKKysrIGIvZHJpdmVycy9zY3NpL3Vm
cy91ZnNoY2QuYwpAQCAtMzE1Miw2ICszMTUyLDggQEAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfbWFw
X2Rlc2NfaWRfdG9fbGVuZ3RoKTsKICAqIEBwYXJhbV9zaXplOiBzaXplb2YocGFyYW1fcmVhZF9i
dWYpCiAgKgogICogUmV0dXJuIDAgaW4gY2FzZSBvZiBzdWNjZXNzLCBub24temVybyBvdGhlcndp
c2UKKyAqIFRoZSBjYWxsZXIgbXVzdCBlbnN1cmUgdGhhdCBwYXJhbV9yZWFkX2J1ZiBwb2ludHMg
dG8gYXQgbGVhc3QgcGFyYW1fc2l6ZQorICogYXZhaWxhYmxlIGJ5dGVzLgogICovCiBpbnQgdWZz
aGNkX3JlYWRfZGVzY19wYXJhbShzdHJ1Y3QgdWZzX2hiYSAqaGJhLAogCQkJICAgZW51bSBkZXNj
X2lkbiBkZXNjX2lkLApAQCAtMzE2Myw3ICszMTY1LDYgQEAgaW50IHVmc2hjZF9yZWFkX2Rlc2Nf
cGFyYW0oc3RydWN0IHVmc19oYmEgKmhiYSwKIAlpbnQgcmV0OwogCXU4ICpkZXNjX2J1ZjsKIAlp
bnQgYnVmZl9sZW47Ci0JYm9vbCBpc19rbWFsbG9jID0gdHJ1ZTsKIAogCS8qIFNhZmV0eSBjaGVj
ayAqLwogCWlmIChkZXNjX2lkID49IFFVRVJZX0RFU0NfSUROX01BWCB8fCAhcGFyYW1fc2l6ZSkK
QEAgLTMxNzUsMjYgKzMxNzYsMTkgQEAgaW50IHVmc2hjZF9yZWFkX2Rlc2NfcGFyYW0oc3RydWN0
IHVmc19oYmEgKmhiYSwKIAlyZXQgPSB1ZnNoY2RfbWFwX2Rlc2NfaWRfdG9fbGVuZ3RoKGhiYSwg
ZGVzY19pZCwgJmJ1ZmZfbGVuKTsKIAogCS8qIFNhbml0eSBjaGVja3MgKi8KLQlpZiAocmV0IHx8
ICFidWZmX2xlbikgeworCWlmIChyZXQgfHwgKHBhcmFtX29mZnNldCArIHBhcmFtX3NpemUgPj0g
YnVmZl9sZW4pKSB7CiAJCWRldl9lcnIoaGJhLT5kZXYsICIlczogRmFpbGVkIHRvIGdldCBmdWxs
IGRlc2NyaXB0b3IgbGVuZ3RoIiwKIAkJCV9fZnVuY19fKTsKIAkJcmV0dXJuIHJldDsKIAl9CiAK
LQkvKiBDaGVjayB3aGV0aGVyIHdlIG5lZWQgdGVtcCBtZW1vcnkgKi8KLQlpZiAocGFyYW1fb2Zm
c2V0ICE9IDAgfHwgcGFyYW1fc2l6ZSA8IGJ1ZmZfbGVuKSB7Ci0JCWRlc2NfYnVmID0ga21hbGxv
YyhidWZmX2xlbiwgR0ZQX0tFUk5FTCk7Ci0JCWlmICghZGVzY19idWYpCi0JCQlyZXR1cm4gLUVO
T01FTTsKLQl9IGVsc2UgewotCQlkZXNjX2J1ZiA9IHBhcmFtX3JlYWRfYnVmOwotCQlpc19rbWFs
bG9jID0gZmFsc2U7Ci0JfQorCWRlc2NfYnVmID0ga21hbGxvYyhidWZmX2xlbiwgR0ZQX0tFUk5F
TCk7CisJaWYgKCFkZXNjX2J1ZikKKwkJcmV0dXJuIC1FTk9NRU07CiAKIAkvKiBSZXF1ZXN0IGZv
ciBmdWxsIGRlc2NyaXB0b3IgKi8KIAlyZXQgPSB1ZnNoY2RfcXVlcnlfZGVzY3JpcHRvcl9yZXRy
eShoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1JFQURfREVTQywKLQkJCQkJZGVzY19pZCwgZGVzY19p
bmRleCwgMCwKLQkJCQkJZGVzY19idWYsICZidWZmX2xlbik7CisJCQlkZXNjX2lkLCBkZXNjX2lu
ZGV4LCAwLCBkZXNjX2J1ZiwgJmJ1ZmZfbGVuKTsKIAogCWlmIChyZXQpIHsKIAkJZGV2X2Vyciho
YmEtPmRldiwgIiVzOiBGYWlsZWQgcmVhZGluZyBkZXNjcmlwdG9yLiBkZXNjX2lkICVkLCBkZXNj
X2luZGV4ICVkLCBwYXJhbV9vZmZzZXQgJWQsIHJldCAlZCIsCkBAIC0zMjEwLDE1ICszMjA0LDEw
IEBAIGludCB1ZnNoY2RfcmVhZF9kZXNjX3BhcmFtKHN0cnVjdCB1ZnNfaGJhICpoYmEsCiAJCWdv
dG8gb3V0OwogCX0KIAotCS8qIENoZWNrIHdoZXJoZXIgd2Ugd2lsbCBub3QgY29weSBtb3JlIGRh
dGEsIHRoYW4gYXZhaWxhYmxlICovCi0JaWYgKGlzX2ttYWxsb2MgJiYgcGFyYW1fc2l6ZSA+IGJ1
ZmZfbGVuKQotCQlwYXJhbV9zaXplID0gYnVmZl9sZW47CisJbWVtY3B5KHBhcmFtX3JlYWRfYnVm
LCAmZGVzY19idWZbcGFyYW1fb2Zmc2V0XSwgcGFyYW1fc2l6ZSk7CiAKLQlpZiAoaXNfa21hbGxv
YykKLQkJbWVtY3B5KHBhcmFtX3JlYWRfYnVmLCAmZGVzY19idWZbcGFyYW1fb2Zmc2V0XSwgcGFy
YW1fc2l6ZSk7CiBvdXQ6Ci0JaWYgKGlzX2ttYWxsb2MpCi0JCWtmcmVlKGRlc2NfYnVmKTsKKwlr
ZnJlZShkZXNjX2J1Zik7CiAJcmV0dXJuIHJldDsKIH0KIAotLSAKMi43LjQKCg==

--_002_SN6PR04MB464036A74AA935BEE35280CEFC8B0SN6PR04MB4640namp_--
