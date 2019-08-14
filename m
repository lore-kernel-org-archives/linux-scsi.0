Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1F6C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 11:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9481F205F4
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 11:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfHNLaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 07:30:07 -0400
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:41983 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfHNLaG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 07:30:06 -0400
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Wed, 14 Aug 2019 11:29:49 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 14 Aug 2019 11:14:12 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 14 Aug 2019 11:14:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=el1pvw4xYMNGuYWzd2MVCMqISTSrT+ziGRsW14cU6BQ3EbXPFIaa/KuG8frEOvrJ+jLbN1/yvUhXmE4hINl6kGk8HkOLKqGT3c/Ig3EzHIqoi3bJCy6X+KAfh2TEWuS6zbx6huXBR8sGo2Jh8nBWuG+JTfI4cnGiZgpADI3Yv9vz/qiKkOLoWe3kvVkifM9C6+9KOIbGxurQGxyB2YWezP4fizgYTyzUamQmitTE4W8gJp3OkCOq3FXvDCWBXLQi7UPWRk1xhar13tn2SpP4xrvxWOAGhj4XP4A03vWnDm8iegqJCSRbL1k6nFZ8zOllmAHwW3DV7pP5CWIXfiSFBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ohKdRuqrKpoqpigAbLYNJc/pIhhpQxsG6ZDgisSaFY=;
 b=QoannoYXGq08Tyu1k8q5U/eMo5P2T5muv2yu6DWa6rcz2vg7DXW8xRyT9KTOjTrtdfc34NarXMFW9PKCL8x+r/LJPAwzpfoXC4pe03RUnoR0S4eTykVkdT9aRKOEsJwYqJ7FNf+jV2PZhboGuT4UNTc6shYVOyqgcHl1H0+ki2a1dcJoNbugxXMO+eOkTIj2dOajLnTdbICO/gwlIqm6wFWXevhxpKM06oRZpo+rHDOTQKi6/CrPsaNQhel/yVWqGZiJwdPeA/6TvjxfRtL43IqRjHRGGaNyF8hfNwyebsLrN98c/HhN/QVNYaPV/rMv8/h+S70Ktm6Vd7H0WquNIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3111.namprd18.prod.outlook.com (52.132.246.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Wed, 14 Aug 2019 11:14:10 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 11:14:10 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "hare@suse.de" <hare@suse.de>,
        "hmadhani@marvell.com" <hmadhani@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "joe.carnuccio@cavium.com" <joe.carnuccio@cavium.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "qutran@marvell.com" <qutran@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Topic: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Index: AQHVUhYKQMcVI/ohF0qhHmiduV8LJg==
Date:   Wed, 14 Aug 2019 11:14:09 +0000
Message-ID: <1e0d71830c1b37d8b60df58ea76b0d07e1b893eb.camel@suse.com>
References: <20190813203034.7354-1-martin.wilck@suse.com>
         <20190813203034.7354-3-martin.wilck@suse.com>
         <9d479501-27bd-7932-9517-4545231e6ae9@suse.de>
In-Reply-To: <9d479501-27bd-7932-9517-4545231e6ae9@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a903b9f-e054-47b3-f634-08d720a887f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3111;
x-ms-traffictypediagnostic: CH2PR18MB3111:
x-microsoft-antispam-prvs: <CH2PR18MB31118DF6554134385F46F986FCAD0@CH2PR18MB3111.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(189003)(199004)(86362001)(71200400001)(4326008)(110136005)(81156014)(118296001)(81166006)(256004)(71190400001)(36756003)(486006)(53936002)(66066001)(6512007)(186003)(26005)(3846002)(14444005)(229853002)(8936002)(7736002)(305945005)(2501003)(6116002)(2201001)(6246003)(25786009)(102836004)(5660300002)(53546011)(54906003)(6436002)(66946007)(478600001)(316002)(6506007)(6486002)(2906002)(91956017)(66556008)(64756008)(66446008)(66476007)(8676002)(76116006)(11346002)(14454004)(99286004)(2616005)(476003)(446003)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3111;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cqoQik6OYtMo+/SEs+eigm0rWlioFPoIQiYBVQM9pRnitr5x7dWZpu084KLkLAbt3bnFDC1fCRgPmMR3wyD5La+5vMam1mj5I2bDpSXUU5RoFGKlxKT6e8x3jf2CpSTRE6hjmcWFcM6nbVxlXm8ocrZFKiwgpaiBLD6PMORrfWgN5tRJai/oIAq91oTnEHAwCOkYKruAIfTqg/sFbQnToKPQC4s5E15JCpC8O53u3lYw9pPp9ZiNuEUDViVFHE3psXYYRPRvLndga3G5zkLJicHyQ1tIjidgp88vWLOnW+uOytvkGoYSqI8eBE/qfdbPCRcGq0mFon0xQF3zPaWi4CbNtzXFk7PKoPHp1GbnH87nncEqNr72pEpdkP5Pc/y4hzHWCSYv3tV9cRPFV0WcCxGWyNmSTYHL7DJY5D608Lc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <53A168254973E148BD89666320716035@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a903b9f-e054-47b3-f634-08d720a887f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 11:14:10.1328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7QJlLA3Z9YeabS7rWoC1QW85wwdsBYkkQ285y5Y9lCx00TnaAHDVXVaiiiqaUUj2C7frCs3Tq/EHwgKhgOEZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3111
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTE0IGF0IDA4OjI0ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDgvMTMvMTkgMTA6MzEgUE0sIE1hcnRpbiBXaWxjayB3cm90ZToNCj4gPiBGcm9tOiBN
YXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4NCj4gPiANCj4gPiBSZXNldCBoYS0+cmNlLCBo
YS0+ZWZ0IGFuZCB0aGUgcmVzcGVjdGl2ZSBkbWEgZmllbGRzIGlmDQo+ID4gdGhlIGJ1ZmZlcnMg
YXJlbid0IG1hcHBlZCBmb3Igc29tZSByZWFzb24uIEFsc28sIHRyZWF0DQo+ID4gYm90aCBmYWls
dXJlIGNhc2VzIChhbGxvY2F0aW9uIGFuZCBpbml0aWFsaXphdGlvbiBmYWlsdXJlKQ0KPiA+IGVx
dWFsbHkuIFRoZSBuZXh0IHBhdGNoIG1vZGlmaWVzIHRoZSBmYWlsdXJlIGJlaGF2aW9yDQo+ID4g
c2xpZ2h0bHkgYWdhaW4uDQo+ID4gDQo+ID4gRml4ZXM6IGFkMGEwYjAxZjA4OCAic2NzaTogcWxh
Mnh4eDogRml4IEZpcm13YXJlIGR1bXAgc2l6ZSBmb3INCj4gPiBFeHRlbmRlZA0KPiA+ICBsb2dp
biBhbmQgRXhjaGFuZ2UgT2ZmbG9hZCINCj4gPiBGaXhlczogYTI4ZDllNGVmOTk3ICJzY3NpOiBx
bGEyeHh4OiBBZGQgc3VwcG9ydCBmb3IgbXVsdGlwbGUgZndkdW1wDQo+ID4gIHRlbXBsYXRlcy9z
ZWdtZW50cyINCj4gPiBDYzogSm9lIENhcm51Y2NpbyA8am9lLmNhcm51Y2Npb0BjYXZpdW0uY29t
Pg0KPiA+IENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQo+ID4gQ2M6IEhpbWFu
c2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KPiA+IENjOiBCYXJ0IFZhbiBBc3Nj
aGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sg
PG13aWxja0BzdXNlLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2luaXQuYyB8IDEwICsrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlv
bnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lu
aXQuYw0KPiA+IGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiA+IGluZGV4IDZk
ZDY4YmUuLmNhOWMzZjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2luaXQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gPiBA
QCAtMzA2Myw2ICszMDYzLDggQEAgcWxhMngwMF9hbGxvY19vZmZsb2FkX21lbShzY3NpX3FsYV9o
b3N0X3QNCj4gPiAqdmhhKQ0KPiA+ICAJCQlxbF9sb2cocWxfbG9nX3dhcm4sIHZoYSwgMHgwMGJl
LA0KPiA+ICAJCQkgICAgIlVuYWJsZSB0byBhbGxvY2F0ZSAoJWQgS0IpIGZvciBGQ0UuXG4iLA0K
PiA+ICAJCQkgICAgRkNFX1NJWkUgLyAxMDI0KTsNCj4gPiArCQkJaGEtPmZjZV9kbWEgPSAwOw0K
PiA+ICsJCQloYS0+ZmNlID0gTlVMTDsNCj4gPiAgCQkJZ290byB0cnlfZWZ0Ow0KPiA+ICAJCX0N
Cj4gPiAgDQo+IEFjdHVhbGx5LCBJIHdvdWxkIHNldCB0aGlzIGVhcmxpZXIgaGVyZToNCj4gDQo+
IAkJaWYgKGhhLT5mY2UpDQo+IAkJCWRtYV9mcmVlX2NvaGVyZW50KCZoYS0+cGRldi0+ZGV2LA0K
PiAJCQkgICAgRkNFX1NJWkUsIGhhLT5mY2UsIGhhLT5mY2VfZG1hKTsNCj4gDQo+IHdoaWNoIGlz
IHRoZSBsb2dpY2FsIHBsYWNlIHRvIGNsZWFyICdoYS0+ZmNlJyBhbmQgJ2hhLT5mY2VfZG1hJyBJ
TU8uDQoNCkZpbmUgd2l0aCBtZS4NCg0KPiBBbHNvZSB0aGVyZSBpcyB0aGlzIGNhbGwgbGF0ZXIg
b246DQo+IA0KPiAJCXJ2YWwgPSBxbGEyeDAwX2VuYWJsZV9mY2VfdHJhY2UodmhhLCB0Y19kbWEs
DQo+IEZDRV9OVU1fQlVGRkVSUywNCj4gCQkgICAgaGEtPmZjZV9tYiwgJmhhLT5mY2VfYnVmcyk7
DQo+IAkJaWYgKHJ2YWwpIHsNCj4gCQkJcWxfbG9nKHFsX2xvZ193YXJuLCB2aGEsIDB4MDBiZiwN
Cj4gCQkJICAgICJVbmFibGUgdG8gaW5pdGlhbGl6ZSBGQ0UgKCVkKS5cbiIsIHJ2YWwpOw0KPiAJ
CQlkbWFfZnJlZV9jb2hlcmVudCgmaGEtPnBkZXYtPmRldiwgRkNFX1NJWkUsIHRjLA0KPiAJCQkg
ICAgdGNfZG1hKTsNCj4gCQkJaGEtPmZsYWdzLmZjZV9lbmFibGVkID0gMDsNCj4gCQkJZ290byB0
cnlfZWZ0Ow0KPiAJCX0NCj4gDQo+IHdoaWNoIGFsc28gbmVlZHMgdG8gYmUgcHJvdGVjdGVkLg0K
DQpSaWdodC4NCg0KPiA+IEBAIC0zMTExLDkgKzMxMTMsMTIgQEAgcWxhMngwMF9hbGxvY19vZmZs
b2FkX21lbShzY3NpX3FsYV9ob3N0X3QNCj4gPiAqdmhhKQ0KPiA+ICANCj4gPiAgCQloYS0+ZWZ0
X2RtYSA9IHRjX2RtYTsNCj4gPiAgCQloYS0+ZWZ0ID0gdGM7DQo+ID4gKwkJcmV0dXJuOw0KPiA+
ICAJfQ0KPiA+ICANCj4gPiAgZWZ0X2VycjoNCj4gPiArCWhhLT5lZnQgPSBOVUxMOw0KPiA+ICsJ
aGEtPmVmdF9kbWEgPSAwOw0KPiA+ICAJcmV0dXJuOw0KPiA+ICB9DQo+ID4gIA0KPiBJIHdvbmRl
ciB3aHkgdGhpcyBpcyBldmVuIHRoZXJlLg0KPiANCj4gUmlnaHQgYXQgdGhlIHN0YXJ0IHdlIGhh
dmU6DQo+IAlpZiAoaGEtPmVmdCkgew0KPiAJCXFsX2RiZyhxbF9kYmdfaW5pdCwgdmhhLCAweDAw
YmQsDQo+IAkJICAgICIlczogT2ZmbG9hZCBNZW0gaXMgYWxyZWFkeSBhbGxvY2F0ZWQuXG4iLA0K
PiAJCSAgICBfX2Z1bmNfXyk7DQo+IAkJcmV0dXJuOw0KPiAJfQ0KPiANCj4gSUUgdGhlIHNlY29u
ZCBoYWxmIG9mIHRoaXMgZnVuY3Rpb24gcmVhbGx5IHNob3VsZCBiZSB1bnJlYWNoYWJsZQ0KPiBj
b2RlLg0KDQpUaGlzIGNoZWNrIGlzIG9ubHkgaW4gcWxhMngwMF9hbGxvY19vZmZsb2FkX21lbSgp
LCBub3QgaW4NCnFsYTJ4MDBfYWxsb2NfZndfZHVtcCgpLCB3aGVyZSBFRlQgYWxsb2NhdGlvbiBp
cyBhdHRlbXB0ZWQgYWdhaW4gKGFuZCANCnFsYTJ4MDBfYWxsb2Nfb2ZmbG9hZF9tZW0oKSBpcyBj
YWxsZWQgZmlyc3QpLiBJdCBsb29rcyBsaWtlIGFuDQpvdmVyc2lnaHQsIGluZGVlZC4gSU1PIHRo
aXMgcGFydCBvZiB0aGUgY29kZSBuZWVkcyBjbGVhbnVwOyBmb3Igbm93DQpJIHRyaWVkIHRvIGtl
ZXAgdGhlIHBhdGNoZXMgc21hbGwuDQoNCj4gSGltYW5zaHU/DQo+IA0KDQpUaGFua3MsDQpNYXJ0
aW4NCg0K
