Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51691CA9EC1
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 18:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 191BB20862
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 18:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbfJ1SFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:05:02 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:54592 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730690AbfJ1SFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Oct 2019 14:05:02 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Mon, 28 Oct 2019 18:04:16 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 28 Oct 2019 18:04:40 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 28 Oct 2019 18:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCZR9n+aOhp9unMfOGUg2MWK9zgl0cMkxbm+ohMkNRhnm5uYXfASCp+0yqhA+Omc60Yn6A8OawjbmgX62kkU5k0PHreWpcjRDml0QcaAqAuzZeYOJEttvgL3Lr36hpgWpztbLOOdhrJhpRCjmgo3qNGJdP5yMDxoumGABMZbgIn2KjrN6BEXkaN9V4/1HzOnck3QoH2uUQOob+bjmgr1eWJy4x4quqtlsQROFMiiFSI0+OEEtJr5u3wbs6jkq4RieAajETZC8iYItVDdkADSR+OxmmH74GXTJwHqUrz7zSg4Qg8OkXSMwFgGtYaVJ2z5hKvFtCFH5TIkBqUmOaV5/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBCqRrfB4l68Dsxfc+7eIS8wJi93wNvkXn6u6caCMKM=;
 b=Wf0PQe2H+UQCTdjDMZ/bv8dX/XltzfU0OA0/SNMNaianHf8N4KsyznASHJjdHrykRahW6gs1Zk039M3nWWy4d/yXSILnK8WfvW5/zNGWa7M5Lv4TyNs9fUM0uRbbuHK1yUsINSCZHGqqa7UZiIkhRB/bZM5SDr4S1Q8bFydY8xb6i0m51+s7Eph6qHeNWCdf+Y5BL1E+uE2ULNvjg7VSIB+S3mMKZiO3ZVdeGxp6K+LclasKSkbIfIC43jkzTxpT8O0182J+ejb4ZZzLJEogoL0wTE4l7k2HSD+5kgc16OaXowjO2Z4ZMMXz8yReNXnHojAFePX8UfEXJxgohG47Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2654.namprd18.prod.outlook.com (20.179.84.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 18:04:39 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::b499:7a76:fb32:b220]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::b499:7a76:fb32:b220%6]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 18:04:39 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     "wubo (T)" <wubo40@huawei.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Topic: [PATCH] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Index: AdWL2reJ1uh470cQT+idNsWy+95OAQB3236A
Date:   Mon, 28 Oct 2019 18:04:39 +0000
Message-ID: <92b221da-18a8-8b7b-0436-ca59088fd45b@suse.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DE9E71@DGGEML525-MBS.china.huawei.com>
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DE9E71@DGGEML525-MBS.china.huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0188.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::32) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3d2cc07-cfdb-43a6-1b20-08d75bd14d0e
x-ms-traffictypediagnostic: MN2PR18MB2654:
x-microsoft-antispam-prvs: <MN2PR18MB26548845768C58A7FA235B76DA660@MN2PR18MB2654.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(199004)(189003)(66946007)(66476007)(66556008)(66446008)(64756008)(8676002)(81156014)(81166006)(476003)(6512007)(11346002)(486006)(76176011)(52116002)(2616005)(99286004)(6246003)(2906002)(8936002)(446003)(186003)(102836004)(6486002)(229853002)(5660300002)(386003)(6506007)(53546011)(66066001)(6436002)(25786009)(14444005)(256004)(31696002)(478600001)(7736002)(71190400001)(31686004)(305945005)(2501003)(110136005)(316002)(54906003)(3846002)(71200400001)(6116002)(36756003)(4326008)(2201001)(14454004)(80792005)(86362001)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2654;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EOHwDFZqLwCVKBT7no7fuFqLe/Y/qz8ZV8iQvrTBdQmRfkNY92LAWrngfmUaLntZXxyxBuRplkkSi+SmpGJZ7enB1MltbYgYFIU0puXsqlD4aboe+PnFn1FtI6aUI4b+3ESUYOtbrgrV4NeYzSSQyyGxtF7IsO7EcZAmtvJtGf2b5sp1cRHYY4fuloAgQaDqeRcB9uXeJKt8FjbPHV9jJvD8IsWN99EmOzGAXLSN8+jDbyaA+aEJzr+JSmRGf/DPZ5UQ0i+n23zR+LAkoHVz5bbEnUUmOa9EBTq305Mbg0B/1Gv2eS/jgbG/PmRakyFRp8ic1hPccoWIteGNO0A762LOS0AcLtHn940Ei9VVHLq4Z+gP+8RzwmyPaRcf3255JQ10vmUNMKbhSyXqA9kQmMYFuW4sE0PKBIqKig0QhhVqpGI9QirGd25GzaRLhb/k
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A01683403433E34B9164BF4A357C6CF5@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d2cc07-cfdb-43a6-1b20-08d75bd14d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 18:04:39.6376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 989AR3NvcfrtIwZYVDk3052DEou2NX8A46SkLpETzUDGQ/VUrmfIXq0cvtfFlVqj5TUkXAdgkWiEZgB9HCI1KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2654
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjYvMTkgMTo1NSBBTSwgd3VibyAoVCkgd3JvdGU6DQo+IEZyb206IEJvIFd1IDx3dWJv
NDBAaHVhd2VpLmNvbT4NCj4gDQo+IEluIGlzY3NpX2lmX3J4IGZ1bmMsIGFmdGVyIHJlY2Vpdmlu
ZyBvbmUgcmVxdWVzdCB0aHJvdWdoIGlzY3NpX2lmX3JlY3ZfbXNnDQo+IGZ1bmMsaXNjc2lfaWZf
c2VuZF9yZXBseSB3aWxsIGJlIGNhbGxlZCB0byB0cnkgdG8gcmVwbHkgdGhlIHJlcXVlc3QgaW4g
DQo+IGRvLWxvb3AuIElmIHRoZSByZXR1cm4gb2YgaXNjc2lfaWZfc2VuZF9yZXBseSBmdW5jIGZh
aWxzIGFsbCB0aGUgdGltZSwgb25lDQo+IGRlYWRsb29wIHdpbGwgb2NjdXIuDQo+ICANCj4gRm9y
IGV4YW1wbGUsIGEgY2xpZW50IG9ubHkgc2VuZCBtc2cgd2l0aG91dCBjYWxsaW5nIHJlY3Ztc2cg
ZnVuYywgdGhlbiBpdA0KPiB3aWxsIHJlc3VsdCBpbiB0aGUgd2F0Y2hkb2cgc29mdCBsb2NrdXAu
IFRoZSBkZXRhaWxzIGFyZSBnaXZlbiBhcyBmb2xsb3dzLA0KPiANCj4gRGV0YWlscyBvZiB0aGUg
c3BlY2lhbCBjYXNlIHdoaWNoIGNhbiBjYXVzZSBkZWFkbG9vcDoNCj4gc29ja19mZCA9IHNvY2tl
dChBRl9ORVRMSU5LLCBTT0NLX1JBVywgTkVUTElOS19JU0NTSSk7IA0KPiAuLi4gDQo+IHJldHZh
bCA9IGJpbmQoc29ja19mZCwgKHN0cnVjdCBzb2NrIGFkZHIqKSAmIHNyY19hZGRyLCBzaXplb2Yg
KHNyY19hZGRyKTsgDQo+IC4uLiANCj4gd2hpbGUgKDEpIHsgDQo+IAlzdGF0ZV9zbWcgPSBzZW5k
bXNnKHNvY2tfZmQsICZtc2csIDApOyANCj4gfSANCj4gLy8gTm90ZTogcmVjdm1zZyAoc29ja19m
ZCwgJiBtc2csIDApIGlzIG5vdCBwcm9jZXNzZWQgaGVyZS4gDQo+IGNsb3NlKHNvY2tfZmQpOyAN
Cj4gDQo+IHdhdGNoZG9nOiBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzcgc3R1Y2sgZm9yIDIycyEg
W25ldGxpbmtfdGVzdDoyNTMzMDVdDQo+IFNhbXBsZSB0aW1lOiA0MDAwODk3NTI4IG5zKEhaOiAy
NTApDQo+IFNhbXBsZSBzdGF0OiANCj4gY3VycjogdXNlcjogNjc1NTAzNDgxNTYwLCBuaWNlOiAz
MjE3MjQwNTAsIHN5czogNDQ4Njg5NTA2NzUwLCBpZGxlOiA0NjU0MDU0MjQwNTMwLCBpb3dhaXQ6
IDQwODg1NTUwNzAwLCBpcnE6IDE0MTYxMTc0MDIwLCBzb2Z0aXJxOiA4MTA0MzI0MTQwLCBzdDog
MA0KPiBkZXRhOiB1c2VyOiAwLCBuaWNlOiAwLCBzeXM6IDM5OTgyMTAxMDAsIGlkbGU6IDAsIGlv
d2FpdDogMCwgaXJxOiAxNTQ3MTcwLCBzb2Z0aXJxOiAyNDI4NzAsIHN0OiAwDQo+IFNhbXBsZSBz
b2Z0aXJxOg0KPiAJVElNRVI6ICAgICAgICA5OTINCj4gCVNDSEVEOiAgICAgICAgICA4DQo+IFNh
bXBsZSBpcnFzdGF0Og0KPiAgaXJxICAgIDI6IGRlbHRhICAgICAgIDEwMDMsIGN1cnI6ICAgIDMx
MDM4MDIsIGFyY2hfdGltZXINCj4gQ1BVOiA3IFBJRDogMjUzMzA1IENvbW06IG5ldGxpbmtfdGVz
dCBLZHVtcDogbG9hZGVkIFRhaW50ZWQ6IEcgICAgICAgICAgIE9FICAgICANCj4gSGFyZHdhcmUg
bmFtZTogUUVNVSBLVk0gVmlydHVhbCBNYWNoaW5lLCBCSU9TIDAuMC4wIDAyLzA2LzIwMTUNCj4g
cHN0YXRlOiA0MDQwMDAwNSAoblpjdiBkYWlmICtQQU4gLVVBTykNCj4gcGMgOiBfX2FsbG9jX3Nr
YisweDEwNC8weDFiMA0KPiBsciA6IF9fYWxsb2Nfc2tiKzB4OWMvMHgxYjANCj4gc3AgOiBmZmZm
MDAwMDMzNjAzYTMwDQo+IHgyOTogZmZmZjAwMDAzMzYwM2EzMCB4Mjg6IDAwMDAwMDAwMDAwMDAy
ZGQgDQo+IHgyNzogZmZmZjgwMGIzNGNlZDgxMCB4MjY6IGZmZmY4MDBiYTc1NjlmMDAgDQo+IHgy
NTogMDAwMDAwMDBmZmZmZmZmZiB4MjQ6IDAwMDAwMDAwMDAwMDAwMDAgDQo+IHgyMzogZmZmZjgw
MGY3YzQzZjYwMCB4MjI6IDAwMDAwMDAwMDA0ODAwMjAgDQo+IHgyMTogZmZmZjAwMDAwOTFkOTAw
MCB4MjA6IGZmZmY4MDBiMzRlZmYyMDAgDQo+IHgxOTogZmZmZjgwMGJhNzU2OWYwMCB4MTg6IDAw
MDAwMDAwMDAwMDAwMDAgDQo+IHgxNzogMDAwMDAwMDAwMDAwMDAwMCB4MTY6IDAwMDAwMDAwMDAw
MDAwMDAgDQo+IHgxNTogMDAwMDAwMDAwMDAwMDAwMCB4MTQ6IDAwMDEwMDAxMDEwMDAxMDAgDQo+
IHgxMzogMDAwMDAwMDEwMTAxMDAwMCB4MTI6IDAxMDEwMDAwMDEwMTAxMDAgDQo+IHgxMTogMDAw
MTAxMDEwMTAxMDAwMSB4MTA6IDAwMDAwMDAwMDAwMDAyZGQgDQo+IHg5IDogZmZmZjAwMDAzMzYw
M2Q1OCB4OCA6IGZmZmY4MDBiMzRlZmY0MDAgDQo+IHg3IDogZmZmZjgwMGJhNzU2OTIwMCB4NiA6
IGZmZmY4MDBiMzRlZmY0MDAgDQo+IHg1IDogMDAwMDAwMDAwMDAwMDAwMCB4NCA6IDAwMDAwMDAw
ZmZmZmZmZmYgDQo+IHgzIDogMDAwMDAwMDAwMDAwMDAwMCB4MiA6IDAwMDAwMDAwMDAwMDAwMDEg
DQo+IHgxIDogZmZmZjgwMGIzNGVmZjJjMCB4MCA6IDAwMDAwMDAwMDAwMDAzMDAgDQo+IENhbGwg
dHJhY2U6DQo+IF9fYWxsb2Nfc2tiKzB4MTA0LzB4MWIwDQo+IGlzY3NpX2lmX3J4KzB4MTQ0LzB4
MTJiYyBbc2NzaV90cmFuc3BvcnRfaXNjc2ldDQo+IG5ldGxpbmtfdW5pY2FzdCsweDFlMC8weDI1
OA0KPiBuZXRsaW5rX3NlbmRtc2crMHgzMTAvMHgzNzgNCj4gc29ja19zZW5kbXNnKzB4NGMvMHg3
MA0KPiBzb2NrX3dyaXRlX2l0ZXIrMHg5MC8weGYwDQo+IF9fdmZzX3dyaXRlKzB4MTFjLzB4MTkw
DQo+IHZmc193cml0ZSsweGFjLzB4MWMwDQo+IGtzeXNfd3JpdGUrMHg2Yy8weGQ4DQo+IF9fYXJt
NjRfc3lzX3dyaXRlKzB4MjQvMHgzMA0KPiBlbDBfc3ZjX2NvbW1vbisweDc4LzB4MTMwDQo+IGVs
MF9zdmNfaGFuZGxlcisweDM4LzB4NzgNCj4gZWwwX3N2YysweDgvMHhjDQo+IA0KPiBIZXJlLCB3
ZSBhZGQgb25lIGxpbWl0IG9mIHJldHJ5IHRpbWVzIGluIGRvLWxvb3AgdG8gYXZvaWQgdGhlIGRl
YWRsb29wLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQm8gV3UgPHd1Ym80MEBodWF3ZWkuY29tPg0K
PiBSZXZpZXdlZC1ieTogWmhpcWlhbmcgTGl1IDxsaXV6aGlxaWFuZzI2QGh1YXdlaS5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2lzY3NpLmMgfCA2ICsrKysrKw0K
PiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jIGIvZHJpdmVycy9zY3NpL3Njc2lfdHJh
bnNwb3J0X2lzY3NpLmMNCj4gaW5kZXggNDE3Yjg2OGQ4NzM1Li5mMzc3YmZlZDZiMGMgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+ICsrKyBiL2Ry
aXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9pc2NzaS5jDQo+IEBAIC0yNCw2ICsyNCw4IEBADQo+
ICANCj4gICNkZWZpbmUgSVNDU0lfVFJBTlNQT1JUX1ZFUlNJT04gIjIuMC04NzAiDQo+ICANCj4g
KyNkZWZpbmUgSVNDU0lfU0VORF9NQVhfQUxMT1dFRCAgICAgMTANCj4gKw0KPiAgI2RlZmluZSBD
UkVBVEVfVFJBQ0VfUE9JTlRTDQo+ICAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL2lzY3NpLmg+DQo+
ICANCj4gQEAgLTM2ODIsNiArMzY4NCw3IEBAIGlzY3NpX2lmX3J4KHN0cnVjdCBza19idWZmICpz
a2IpDQo+ICAJCXN0cnVjdCBubG1zZ2hkcgkqbmxoOw0KPiAgCQlzdHJ1Y3QgaXNjc2lfdWV2ZW50
ICpldjsNCj4gIAkJdWludDMyX3QgZ3JvdXA7DQo+ICsJCWludCByZXRyaWVzID0gSVNDU0lfU0VO
RF9NQVhfQUxMT1dFRDsNCj4gIA0KPiAgCQlubGggPSBubG1zZ19oZHIoc2tiKTsNCj4gIAkJaWYg
KG5saC0+bmxtc2dfbGVuIDwgc2l6ZW9mKCpubGgpICsgc2l6ZW9mKCpldikgfHwNCj4gQEAgLTM3
MTAsOCArMzcxMywxMSBAQCBpc2NzaV9pZl9yeChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAgCQkJ
CWJyZWFrOw0KPiAgCQkJaWYgKGV2LT50eXBlID09IElTQ1NJX1VFVkVOVF9HRVRfQ0hBUCAmJiAh
ZXJyKQ0KPiAgCQkJCWJyZWFrOw0KPiArCQkJaWYgKHJldHJpZXMgPD0gMCkNCj4gKwkJCQlicmVh
azsNCj4gIAkJCWVyciA9IGlzY3NpX2lmX3NlbmRfcmVwbHkocG9ydGlkLCBubGgtPm5sbXNnX3R5
cGUsDQo+ICAJCQkJCQkgIGV2LCBzaXplb2YoKmV2KSk7DQo+ICsJCQlyZXRyaWVzLS07DQo+ICAJ
CX0gd2hpbGUgKGVyciA8IDAgJiYgZXJyICE9IC1FQ09OTlJFRlVTRUQgJiYgZXJyICE9IC1FU1JD
SCk7DQo+ICAJCXNrYl9wdWxsKHNrYiwgcmxlbik7DQo+ICAJfQ0KPiANCg0KWW91IGNvdWxkIGhh
dmUgdXNlZCAiaWYgKC0tcmV0cmllcyA8IDApIiAob3Igc29tZSB2YXJpYXRpb24gdGhlcmVvZikg
YnV0DQp0aGF0IG1heSBub3QgYmUgYXMgY2xlYXIsIGFuZCBjZXJ0YWlubHkgaXMgb25seSBhIG5p
dC4gU28gSSdtIGZpbmUgd2l0aA0KdGhhdC4NCg0KQnV0IEkgd291bGQgbGlrZSB0byBzZWUgc29t
ZSBzb3J0IG9mIGVycm9yIG9yIGV2ZW4gZGVidWcga2VybmVsIG1lc3NhZ2UNCmlmIHdlIHRpbWUg
b3V0IHdhaXRpbmcgdG8gcmVjZWl2ZSBhIHJlc3BvbnNlLiBPdGhlcndpc2UsIGhvdyB3aWxsIHNv
bWUNCmh1bWFuIGRpYWdub3NlIHRoaXMgcHJvYmxlbT8NCg0KLS0gDQpMZWUgRHVuY2FuDQo=
