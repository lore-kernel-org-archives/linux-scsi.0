Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7A5C4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8755521929
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lenovonetapp.partner.onmschina.cn header.i=@lenovonetapp.partner.onmschina.cn header.b="gbx2f8Om"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbfISMym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 08:54:42 -0400
Received: from mail-bjbon0153.outbound.protection.partner.outlook.cn ([42.159.36.153]:50830
        "EHLO cn01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389361AbfISMym (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 08:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lenovonetapp.partner.onmschina.cn;
 s=selector1-lenovonetapp-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQyGL354vsWdn8qjAggm6smVu94Svtic0Y0rEOz8YcI=;
 b=gbx2f8Om1UMd2F7wflbnO8+Lq7ctuUl0ux8/rb0cYyK7S4WcVsAvAj2CiYJzkVsjgN1pWcf1CIpKE8SfHKJ5GQTYTjUoWYdrYt0IcAeyYTrYWYwEy1jE3tm8tFGj77F+ZPl+DVyqYmfcgZ4SK6Sl9GBT8GFlTNGAYPY2m+icwEE=
Received: from BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn (10.41.52.28) by
 BJXPR01MB120.CHNPR01.prod.partner.outlook.cn (10.41.51.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.24; Thu, 19 Sep 2019 12:54:36 +0000
Received: from BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn ([10.41.52.28])
 by BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn ([10.41.52.28]) with mapi id
 15.20.2263.028; Thu, 19 Sep 2019 12:54:36 +0000
From:   "Liu, Sunny" <ping.liu@lenovonetapp.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: RE: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Index: AQHVbtGFuMDJ5zGly0SY3b+3bKFWXacy8wGQ
Date:   Thu, 19 Sep 2019 12:54:36 +0000
Message-ID: <BJXPR01MB02962BBB166016D8B1FB28B4F4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
References: <20190919094547.67194-1-hare@suse.de>
 <BJXPR01MB02964BA1F5E67B7B6CB39EE7F4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
 <BYAPR04MB581634BD1F85CA9768AC780FE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <BJXPR01MB0296594F3E478B5BFD4DA2ABF4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
 <BYAPR04MB5816266B5EEBA1E800E73116E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB5816266B5EEBA1E800E73116E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ping.liu@lenovonetapp.com; 
x-originating-ip: [36.112.23.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9921eaa5-81a7-488d-580e-08d73d0086f6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(4600270)(4652040)(97021020)(8989299)(711020)(4605104)(1401327)(97022020)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(4601075);SRVR:BJXPR01MB120;
x-ms-traffictypediagnostic: BJXPR01MB120:
x-microsoft-antispam-prvs: <BJXPR01MB120B987EFF57E867C06C263F4890@BJXPR01MB120.CHNPR01.prod.partner.outlook.cn>
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(346002)(39850400004)(199004)(189003)(328002)(329002)(13464003)(5660300002)(54906003)(478600001)(6246003)(95416001)(8676002)(7696005)(86362001)(53546011)(229853002)(26005)(55016002)(9686003)(6116002)(102836004)(2906002)(305945005)(486006)(14454004)(446003)(76176011)(66066001)(63696004)(4326008)(186003)(76116006)(66556008)(33656002)(71190400001)(71200400001)(3846002)(66476007)(11346002)(110136005)(64756008)(66946007)(66446008)(476003)(81156014)(7736002)(316002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BJXPR01MB120;H:BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: lenovonetapp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t4LS8v1p+JV+gXz0UKuZfGbrfliQgeEDjKxDtKJvVDkqO/w9dZZXgG/ZMzM3cvgBCMkOWd/izydxo7AjdPOUko5Y+uk5uP6DfBn7jqtvYPeYHtBZ2Xi6lR7fp5xi7WTFTp0IPVRlr8iu1uOlimpVJnWRodlk21xU0ht6zJo4BVVGkRDekcnO+kqBsAI/7wskzsrj1mipJYa8mbO6p3fgDzdV3+zBgyhWb3IJWwbE4VjLQ1B3FGGKDyRK7c1u0fjtBT0XiKQ5jkdfe1wdQklsn8xDoqCT1AYbPZzPS3H3mppamg/R60PVaVRgffcKVL41HLZm13DoX1is6/WzL2P4hVeT4HYgwb8z0oYpsPcsHtzo6zHSX6A6zs+MtYLvpPosypOaBduORwKg5s+hqcZv39eFpt8l0rvYuN/7rjZ3dxk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: lenovonetapp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9921eaa5-81a7-488d-580e-08d73d0086f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 12:54:36.7931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 927e186b-5306-4888-8faf-367d5292e481
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +81N23AupJkpNzApfW8v7NDYsvyi5kDW7F/hzZWLB0PfYiq2565vwp+BA7UZYh1XFUIawJE9o+ujZKkzSL2OIvmfSltvgho4om/+eDPf3pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB120
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U2lyLA0KDQpUaGUgSEREIGlzIGhhcmR3YXJlIFJhaWQgNSB3aXRoIDUzMC04aSByYWlkIGNhcmQu
DQpJIHRyaWVkIDFtIHNlcSB3cml0ZSB3aXRoIG51bWpvYnM9MSwgdGhlIGRhdGEgc2ltaWxhciBh
cyBrZXJuZWwgMy4xMC4wLCB3aGF0ZXZlciBtcS1kZWFkbGluZSBvciBCRlEgZWxldmF0b3IuDQpJ
ZiB5b3UgbmVlZCBkZXRhaWwgdGVzdGluZyBkYXRhIHdpdGggbnVtam9icz0xLCBJIGNhbiBkbyBp
dC4gT3IgYW55IGluZm8geW91IG5lZWQsIHN1Y2ggYXMgdHdvIHByb2Nlc3Mgd2l0aCAxIHRocmVh
ZC4NCg0KVGhhbmsgeW91Lg0KDQpCZXN0UmVnYXJkcywNClN1bm55TGl1KMH1xrwpDQpMZW5vdm9O
ZXRBcHAgDQqxsb6pytC6o7Xtx/jO97Gxzfq2q8K3MTC6xdS6MrrFwqVMMy1FMS0wMQ0KTDMtRTEt
MDEsQnVpbGRpbmcgTm8uMiwgTGVub3ZvIEhRIFdlc3QgTm8uMTAgWGlCZWlXYW5nIEVhc3QgUmQu
LA0KSGFpZGlhbiBEaXN0cmljdCwgQmVpamluZyAxMDAwOTQsIFBSQw0KVGVsOiArODYgMTU5MTA2
MjIzNjgNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IGxpbnV4LWJsb2NrLW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtYmxvY2stb3duZXJAdmdlci5rZXJuZWwub3JnPiBP
biBCZWhhbGYgT2YgRGFtaWVuIExlIE1vYWwNClNlbnQ6IDIwMTnE6jnUwjE5yNUgMjA6NDUNClRv
OiBMaXUsIFN1bm55IDxwaW5nLmxpdUBsZW5vdm9uZXRhcHAuY29tPjsgSGFubmVzIFJlaW5lY2tl
IDxoYXJlQHN1c2UuZGU+OyBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+DQpDYzogbGludXgt
c2NzaUB2Z2VyLmtlcm5lbC5vcmc7IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20+OyBKYW1lcyBCb3R0b21sZXkgPGphbWVzLmJvdHRvbWxleUBoYW5zZW5wYXJ0
bmVyc2hpcC5jb20+OyBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT47IGxpbnV4LWJsb2Nr
QHZnZXIua2VybmVsLm9yZzsgSGFucyBIb2xtYmVyZyA8SGFucy5Ib2xtYmVyZ0B3ZGMuY29tPg0K
U3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggMC8yXSBibGstbXEgSS9PIHNjaGVkdWxpbmcgZml4ZXMN
Cg0KT24gMjAxOS8wOS8xOSAxMjo1OSwgTGl1LCBTdW5ueSB3cm90ZToNCj4gVGhhbmsgdmVyeSBt
dWNoIGZvciB5b3VyIHF1aWNrbHkgYWR2aWNlLg0KPiANCj4gVGhlIHByb2JsZW0gZHJpdmUgaXMg
c2F0YSBIREQgNzIwMHJwbSBpbiByYWlkIDUuDQoNClNvcnJ5LCBJIHJlYWQgIlNERCIgd2hlcmUg
eW91IGhhZCB3cml0dGVuICJIREQiIDopIElzIHRoaXMgYSBoYXJkd2FyZSBSQUlEID8gT3IgaXMg
dGhpcyB1c2luZyBkbS9tZCByYWlkID8NCg0KPiBJZiB1c2luZyBGaW8gbGliYWlvIGlvZGVwdGg9
MTI4IG51bWpvYj0yLCB0aGUgYmFkIHBlcmZvcm1hbmNlIHdpbGwgYmUgDQo+IGFzIGJlbG93IGlu
IHJlZC4gQnV0IHRoZXJlIGlzIG5vIHByb2JsZW0gd2l0aCBudW1qb2I9MS4gSW4gb3VyIA0KPiBz
b2x1dGlvbiwgKm11bHRpcGxlDQo+IHRocmVhZHMqIHNob3VsZCBiZSB1c2VkLg0KDQpZb3VyIGRh
dGEgZG9lcyBub3QgaGF2ZSB0aGUgbnVtam9icz0xIGNhc2UgZm9yIGtlcm5lbCA1LjIuOS4gWW91
IHNob3VsZCBydW4gdGhhdCBmb3IgY29tcGFyaXNvbiB3aXRoIHRoZSBudW1qb2JzPTIgY2FzZSBv
biB0aGUgc2FtZSBrZXJuZWwuDQoNCj4gRnJvbSB0aGUgdGVzdGluZyByZXN1bHQsIEJGUSBsb3ct
bGF0ZW5jeSBoYWQgZ29vZCBwZXJmb3JtYW5jZSwgYnV0IGl0IA0KPiBzdGlsbCBoYXMgcHJvYmxl
bSBpbiAxbSBzZXEgd3JpdGUuDQo+IA0KPiBUaGUgZGF0YSBpcyBjb21lIGZyb20gY2VudG9zIDcu
NiAoa2VybmVsIDMuMTAuMC05NzUpIGFuZCBrZXJuZWwgNS4yLjkgDQo+IHdpdGggQkZRIGFuZCBi
Y2FjaGUgZW5hYmxlZC4gTm8gYmNhY2hlIGNvbmZpZ3VyZS4NCj4gDQo+IElzIHRoZXJlIGFueSBw
YXJhbWV0ZXIgY2FuIHNvbHZlIHRoZSAxbSBhbmQgdXBwZXIgc2VxIHdyaXRlIHByb2JsZW0gDQo+
IHdpdGggbXVsdGlwbGUgdGhyZWFkcz8NCg0KTm90IHN1cmUgd2hhdCB0aGUgcHJvYmxlbSBpcyBo
ZXJlLiBZb3UgY291bGQgbG9vayBhdCBhIGJsa3RyYWNlIG9mIGVhY2ggY2FzZSB0byBzZWUgaWYg
dGhlcmUgaXMgYW55IG1ham9yIGRpZmZlcmVuY2UgaW4gdGhlIGNvbW1hbmQgcGF0dGVybnMgc2Vu
dCB0byB0aGUgZGlza3Mgb2YgeW91ciBhcnJheSwgaW4gcGFydGljdWxhciBjb21tYW5kIHNpemUu
DQoNCi0tDQpEYW1pZW4gTGUgTW9hbA0KV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoDQo=
