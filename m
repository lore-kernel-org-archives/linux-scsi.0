Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4342AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136432073A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GOqoWN/c";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="k779snfi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgGMIKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:10:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:1589 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgGMIKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594627854; x=1626163854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B7JaBPI1B9XbmCVzE1KWA9S5o5cjQXSqvLUzq9k/nV4=;
  b=GOqoWN/c3V0oQHlMYDdHeGfutqkR9HMytfP/mjP52PpWWlBNKv7uNsY3
   ECN9+m/CQB42r748ohwiIgLgvDnm+m7gauy3L8LYTdkNMLPrnZt9YxcA7
   8PU7wPp0fuxONntl/WhNki5POBJTV1OYdcn6ZfFyhwcWmf1N/5YF4IeKx
   b8iofy97horZnptvV9OaqRhjIXg2kTcUk5P3+1hhk+OFs3oi0F6huPCt3
   U7sYaJ002MVOrl695x2vPxu/abjoDcZxIcJUhtpL3CdVWCb9SKuzE2g+F
   maIUeZwStyPfT5IlKk8+ddu//DhRnZfHF8WKsqaDhAm89WeORlXZDYgAz
   Q==;
IronPort-SDR: YvvMs75dh36GAug4kAYuD3G2goQonZYit0yfKI48x9cMY+eqNAsT2SM1faW+SYApLm2UqDSZ+a
 MPshRJ/BGT+xaLjiG3HDLfP/Up+s0ulQNcv33dhrXVK+fOeVqeDWZAHQPiKKU24y1sUhE7CZp1
 w02UuC8X22PbSsjAQ9xly2ISFmLSBCs1t8Tiz52MY89QTVFR4rmXKGf3BeS7S0XW8NsosqcL8V
 IRtWh8sGRnqq2Xu7/PU24y8zgreNWRSAQiRP6I8viGsnIsyWWO3rNLKrPlzIMO3pcFKfpFzcP9
 u4w=
X-IronPort-AV: E=Sophos;i="5.75,346,1589212800"; 
   d="scan'208";a="245327578"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2020 16:10:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JddUs+I+e6xR/B4sF7sqLYm+3sGxvYsE6aoAVsApUDcMTs35++ymM449+iRP/7QOBrRdvstV0PdxXJkFbHJ3qdkgPnjUlthhl2A2ESvgAbyKdcsusedF28EUOwTTrsnI13hVUbK6yJ7+GSn7jeeepgTBeSqzjtUbgbktMwQX6naswcobqI3sJcyFpC9cIn6Bm6HqG0fPTSdr5T+jZ5Ues2Og4rImXm4yYAjEkVFxakVy3AEa0xLqxJoHLzOzP22ge3e6OsoYi9nis/jYS4spg0t0T9vN89+JNTI6KDuvBMj+XP93fnUPttJJhMad+WoU68Lz6LjbD+mZdFp+PsAmTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7JaBPI1B9XbmCVzE1KWA9S5o5cjQXSqvLUzq9k/nV4=;
 b=FqPTc6+oinAYYeQ/NW38Q5sNKPgozBQUMi1bmIFZ02d7OAwln9VHyRY0iM3/K/Cymxhi5PawuLMw4ZOeljwucpcQGR/QRQUyL/20ZYWgbhW3jOUXQne+A1Mdrud+ydgmC2HtIz3lR5cGBMO0TRaXX2TrgwVnghoZRXe2ubboI7olV3Ss4ydO2J0gS9wRjJHOaj/KfL6sKVU4YYEmNNnleyt1vXhCllFtfyhYaqbI3PUr+9BT8TQj1Q6Em3YrJ7Mgd5oEX1tYoFVEsgF1b6XhjeiwQsaLWdyRuOjBvz0dA78AbaO8/Jdkt/ZZ8qHl17UwpdIBQXz9vRlIDzsEc9Msng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7JaBPI1B9XbmCVzE1KWA9S5o5cjQXSqvLUzq9k/nV4=;
 b=k779snfi1oihxRcp/qPVzHT4BmXCCwEOy+aI6ispdXNu4XbawkV0iaWmM2nHcl/kYvWj2Xu28BOPxk2GNip8onx6DPDZl9RyXMpB3Q7Wpu5LDzhrt9eL3KXhZ1phksVcpRrO0/jHghaknswV0g+uwetk56vEmXZGr5IeC5hVS6E=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4192.namprd04.prod.outlook.com (2603:10b6:805:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 08:10:30 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Mon, 13 Jul 2020
 08:10:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt
 notification
Thread-Topic: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Index: AQHWU5heDqJFApuOo0yQOIjuO+/O36kExbEAgAANaICAAF4EoA==
Date:   Mon, 13 Jul 2020 08:10:29 +0000
Message-ID: <SN6PR04MB46409838AE9D4BD63797E26DFC600@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <3d509c4b-d66d-2a4a-5fbd-a50a0610ad31@acm.org>
 <1594607245.22878.8.camel@mtkswgap22>
In-Reply-To: <1594607245.22878.8.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95629abf-70f6-4cc9-ffbd-08d827043535
x-ms-traffictypediagnostic: SN6PR04MB4192:
x-microsoft-antispam-prvs: <SN6PR04MB4192806E6CC9CEE808276E5CFC600@SN6PR04MB4192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0omG5BNzD4J6ItbByNGE2W9NATFsAwu/XwVt/+DuHIn/IddEZsvIX9S7Tllg23/ubKopJWjpDSQDhFUVYNlU3ObmNjPL6unmHceA6JA6xnxlq4EYUnLkpxyaQk5sQD58dBV1XIvlmQL6FjLrPjq0rKvjTRc/7LDfH9g/GnsOg2MW7Dn6Np0+TfKW6ftFd6HW38UPdztJ1JNTVS14GboqniD5XienTsWrUO4gMPGrXQ4VMrp9PFJtRw1s9zRLhstqAJNE8yGvXoq9DMpKRRENQA0A9o4Pos+UtbLAI7zuSd2+aIPludSzFnIEqNg1FCxqrhqQCWMwJOOLj4uw3MTAMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(316002)(110136005)(54906003)(86362001)(66946007)(83380400001)(66476007)(66556008)(64756008)(76116006)(66446008)(33656002)(5660300002)(7416002)(186003)(26005)(52536014)(8936002)(7696005)(15650500001)(4326008)(8676002)(478600001)(55016002)(9686003)(2906002)(53546011)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o7CQ2uDVRttVMd/nI2dzDK24L3fz7hfjsI0sDGt/JaBiiGbEinIoTtPzQM8byTMxQOYjfB18u/zFFzRrnarXb9CHwXuKxyOo6s64hOT+y+YKPwdOsZfHtbkK9ENJE+fPCWclF0xVj/8RVqyLVBrnuy1P47VACbU7YUdzJ0vTu8vn7sAD7Zdyp4Fjw6rNc5E40M9q3++nsWf9N8CPd+YB27EZgV4OmD+VDExEVMdvHHUk7N7BseLPwv6U7gThnYkDDE/FHUdoI2LtPbGcKgDdJDmxXurCc5M5GVtXyS2P+e3sZZ9VsujAnVop59AjijGFP/4rIHS/WOinLKKXtBEl6147gf7lyKJECbqCBGIlM+NUcsn4n1QV7jyH9rsh31HOt0IbSOY7ntoLbgCSOu8rrkPGc41pX2RoWFo2SOzLGoJXAjCixz2XCfQpx5tlBRIxUxHINceF9IzsSGTtZ4pL9G/epqTZcnBcgcqKlu+lS20=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95629abf-70f6-4cc9-ffbd-08d827043535
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 08:10:29.7809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DgRnkHwGOCdx+MwD13zn6QYcEnlprt7fNN5MvJqFvR/Qxa4WVLVh6jsaaVNtPPqYrAYLWltFxvepCBXvplbU4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQmFydCBhbmQgQXZyaSwNCj4gDQo+IE9uIFN1biwgMjAyMC0wNy0xMiBhdCAxODoz
OSAtMDcwMCwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IE9uIDIwMjAtMDctMDYgMDY6MjEs
IFN0YW5sZXkgQ2h1IHdyb3RlOg0KPiA+ID4gSWYgc29tZWhvdyBubyBpbnRlcnJ1cHQgbm90aWZp
Y2F0aW9uIGlzIHJhaXNlZCBmb3IgYSBjb21wbGV0ZWQgcmVxdWVzdA0KPiA+ID4gYW5kIGl0cyBk
b29yYmVsbCBiaXQgaXMgY2xlYXJlZCBieSBob3N0LCBVRlMgZHJpdmVyIG5lZWRzIHRvIGNsZWFu
dXANCj4gPiA+IGl0cyBvdXRzdGFuZGluZyBiaXQgaW4gdWZzaGNkX2Fib3J0KCkuDQo+ID4NCj4g
PiBIb3cgaXMgaXQgcG9zc2libGUgdGhhdCBubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIGlzIHJh
aXNlZCBmb3IgYSBjb21wbGV0ZWQNCj4gPiByZXF1ZXN0PyBJcyB0aGlzIHRoZSByZXN1bHQgb2Yg
YSBoYXJkd2FyZSBzaG9ydGNvbWluZyBvciByYXRoZXIgdGhlIHJlc3VsdA0KPiA+IG9mIGhvdyB0
aGUgVUZTIGRyaXZlciB3b3Jrcz8gSW4gdGhlIGxhdHRlciBjYXNlLCBpcyB0aGlzIHBhdGNoIHBl
cmhhcHMgYQ0KPiA+IHdvcmthcm91bmQ/IElmIHNvLCBoYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRv
IGZpeCB0aGUgcm9vdCBjYXVzZSBpbnN0ZWFkIG9mDQo+ID4gaW1wbGVtZW50aW5nIGEgd29ya2Fy
b3VuZD8NCj4gDQo+IEFjdHVhbGx5IHRoaXMgZmFpbCBpcyB0cmlnZ2VyZWQgYnkgImVycm9yIGlu
amVjdGlvbiIgdG8gcHJvZHVjZSBhDQo+IGNvbW1hbmQgdGltZW91dCBldmVudCBmb3IgY2hlY2tp
bmcgaWYgYW55dGhpbmcgY2FuIGJlIGltcHJvdmVkIG9yIGZpeGVkLg0KPiANCj4gSSBhZ3JlZSB0
aGF0ICJubyBpbnRlcnJ1cHQgbm90aWZpY2F0aW9uIiBtYXkgYmUgc29tZXRoaW5nIHdyb25nIGlu
DQo+IGhhcmR3YXJlIGFuZCB0aGUgcm9vdCBjYXVzZSBzaGFsbCBiZSBmaXhlZCBpbiB0aGUgaGln
aGVzdCBwcmlvcml0eS4NCj4gSG93ZXZlciBmcm9tIHRoaXMgaW5qZWN0aW9uLCB3ZSBmb3VuZCB1
ZnNoY2RfYWJvcnQoKSBpbmRlZWQgaGFzIGEgZGVmZWN0DQo+IGZsb3cgZm9yIGEgY29ybmVyIGNh
c2UsIHNvIHdlIGFyZSBsb29raW5nIGZvciB0aGUgc29sdXRpb24gdG8gZml4IHRoZQ0KPiAiaG9s
ZSIuDQo+IA0KPiBXaGF0IHdvdWxkIHlvdSB0aGluayBpZiBMaW51eCBkcml2ZXIgc2hhbGwgY29u
c2lkZXIgdGhpcyBjYXNlPyBJZiB0aGlzDQo+IGlzIG5vdCBuZWNlc3NhcnksIEkgd291bGQgZHJv
cCB0aGlzIHBhdGNoIDogKQ0KQXJ0aWZpY2lhbGx5IGluamVjdGluZyBlcnJvcnMgaXMgYSB2ZXJ5
IGNvbW1vbiB2YWxpZGF0aW9uIG1lY2hhbmlzbSwNClByb3ZpZGVkIHRoYXQgeW91IGFyZSBub3Qg
YnJlYWtpbmcgYW55dGhpbmcgb2YgdGhlIHVwcGVyLWxheWVycywNCldoaWNoIEkgZG9uJ3QgdGhp
bmsgeW91IGFyZSBkb2luZy4NCg0KQ2FuIHlvdSByZWZlciBwbGVhc2UgdG8gbXkgbGFzdCBjb21t
ZW50Pw0KDQo+IA0KPiBUaGFua3MgYSBsb3QsDQo+IFN0YW5sZXkgQ2h1DQo+IA0KPiA+DQo+ID4g
SW4gc2VjdGlvbiA3LjIuMyBvZiB0aGUgVUZTIHNwZWNpZmljYXRpb24gSSBmb3VuZCB0aGUgZm9s
bG93aW5nIGFib3V0IGhvdw0KPiA+IHRvIHByb2Nlc3MgcmVxdWVzdCBjb21wbGV0aW9uczogIlNv
ZnR3YXJlIGRldGVybWluZXMgaWYgbmV3IFRScyBoYXZlDQo+ID4gY29tcGxldGVkIHNpbmNlIHN0
ZXAgIzIsIGJ5IHJlcGVhdGluZyBvbmUgb2YgdGhlIHR3byBtZXRob2RzIGRlc2NyaWJlZCBpbg0K
PiA+IHN0ZXAgIzIuIElmIG5ldyBUUnMgaGF2ZSBjb21wbGV0ZWQsIHNvZnR3YXJlIHJlcGVhdHMg
dGhlIHNlcXVlbmNlIGZyb20NCj4gc3RlcA0KPiA+ICMzLiIgSXMgc3VjaCBhIGxvb3AgcGVyaGFw
cyBtaXNzaW5nIGZyb20gdGhlIExpbnV4IFVGUyBkcml2ZXI/DQpDb3VsZCBub3QgZmluZCB0aGF0
IGNpdGF0aW9uLg0KV2hhdCB2ZXJzaW9uIG9mIHRoZSBzcGVjIGFyZSB5b3UgdXNpbmc/DQoNClRo
YW5rcywNCkF2cmkNCj4gPg0KPiA+IFRoYW5rcywNCj4gPg0KPiA+IEJhcnQuDQoNCg==
