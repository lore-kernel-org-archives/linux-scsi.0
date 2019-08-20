Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726D8C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF28214DA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfHTR6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 13:58:55 -0400
Received: from m4a0041g.houston.softwaregrp.com ([15.124.2.87]:45983 "EHLO
        m4a0041g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728770AbfHTR6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Aug 2019 13:58:54 -0400
Received: FROM m4a0041g.houston.softwaregrp.com (15.120.17.146) BY m4a0041g.houston.softwaregrp.com WITH ESMTP;
 Tue, 20 Aug 2019 17:53:42 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 20 Aug 2019 17:57:09 +0000
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (15.124.72.11) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 20 Aug 2019 17:57:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbxbvYceo5ErsVrUnQnj+pGUnskMUuphRYZrSTrXm8YOi/MKBkN+vn86q1iweK8RRPvCb2E/q2677Ece5amMJy3BhgoFtoRg+pNfirftzweFyw4tZPtFqrjWbNKQ9RBlryFUaxiErdDP8HlQRR+15DQHMe5mM2XpLroe3bDOWRlS1aNjyLsa3cnxG1fvkiCk5LAp7tRmIxzPNA1nx0rZnL6GFvNOLZnZOJkrrCjv03S0NoHsDJvpLc3BLzQX0/u31EqOLCZF3hE1lkfwNEJ9awaY7RWHLdMSKJm9xUhoyhLnIY/JcnnFCNTVTFJr6OEv/mHm8ZeWYPy3UzQpv9wOxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgW/2xPXptv+bzj9IrvVKmDDhIXISHfUeGhYX1riZXc=;
 b=ZtPLUrzErqCqSg2xtHCCdE/E00Txu7TCGqLoG6Usj1Pwm96xoWgrez6G6Zjju4gsfSOE2u92SLGF0YoSyB/UxeINMoL3h1L0lWCyl+UyIwVJkJYn5ZyvfuRyCYmjx5x7Afc6NL5A1dg5RYlLdh57qpn405CFSsxpWYbbfZrPJ0IL3uiA0lADHiT7uIYNw4CpistQfCokGccuj/lzhI1m2SUw3ikUdEYLOubpy5mB11HuFcTVNghWpGV837BxnCpD1JnWbap8TfFXzfaldaaPRKd7B9KidoZemNPg3Z6YMmyYpPO61TTf/hAyiJZtlVtInzeiY9LA5nAiN1HvJ/h9Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BN6PR18MB1172.namprd18.prod.outlook.com (10.172.207.147) by
 BN6PR18MB0993.namprd18.prod.outlook.com (10.173.153.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 17:57:08 +0000
Received: from BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::4cf:874f:61a4:e220]) by BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::4cf:874f:61a4:e220%9]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 17:57:08 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix a recently introduced kernel warning
Thread-Topic: [PATCH] qla2xxx: Fix a recently introduced kernel warning
Thread-Index: AQHVVv2/XUNeaz/LU0Wp03TxMBLimacEU1gA
Date:   Tue, 20 Aug 2019 17:57:07 +0000
Message-ID: <181e7a81-d252-e871-3b6b-1f1749d0bf27@suse.com>
References: <20190820021836.16401-1-bvanassche@acm.org>
In-Reply-To: <20190820021836.16401-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6PR07CA0132.eurprd07.prod.outlook.com
 (2603:10a6:6:16::25) To BN6PR18MB1172.namprd18.prod.outlook.com
 (2603:10b6:404:eb::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87de95aa-be89-4166-246d-08d72597d140
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR18MB0993;
x-ms-traffictypediagnostic: BN6PR18MB0993:
x-microsoft-antispam-prvs: <BN6PR18MB09932E35C0D5EF5E9B6F3703DAAB0@BN6PR18MB0993.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(199004)(51234002)(189003)(76176011)(6506007)(386003)(80792005)(3846002)(6116002)(316002)(2906002)(71190400001)(71200400001)(256004)(14444005)(54906003)(110136005)(66066001)(31696002)(31686004)(86362001)(5660300002)(53546011)(4326008)(52116002)(7736002)(14454004)(36756003)(305945005)(186003)(26005)(6486002)(6512007)(6246003)(66446008)(64756008)(66476007)(66556008)(229853002)(66946007)(486006)(2616005)(476003)(11346002)(8676002)(25786009)(81166006)(81156014)(8936002)(99286004)(6436002)(53936002)(446003)(478600001)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR18MB0993;H:BN6PR18MB1172.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j694EOOtSa8uyV5lQndDLnCoDkgjclO0hiKoXpiXdQAi9j9T0q9hozxRIs3opX4gj+x7erFojQbJywMccibB2WfgyWarSSEu8jNNRxGeeYMt054AcamJRZYS1W1v/7e++3vIx2dYGBlH3hNNh/ge0vbWCXK1sVAWuvFFzG7TxBWd5hCCaHpgWsv+d8ayKmExMo15u0GWkOm+rZ1qYcnsd91MHYO6KvY8oUqcKk4KcTpGHSBB7cO9HfwO6Qwe6X4hVm7POC4VmfMLlouNChGbT3ZEN2SjPSzYfe+YogZPdv4xcPumN3N5BYPMrgsSh+gjurA1+6gAE5nN/XPD9ZWf9Pykckc8FlhiLdachmLl1OpRP/Aedgk1/SZXcgldDGPp4UAdWOLzSUdRPwOuLUoURUwB3Ed0YmmAWEfT2eCOU8A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B137F1F274710A499328C953C82BA9DA@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 87de95aa-be89-4166-246d-08d72597d140
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 17:57:07.8994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B70vpE/CtDHgtOUBdOiBKOHAj91i/vPeu+fIlNnl4v6sewr0vl9g8MDWA2BdDm6d4tA0ZkwR6yQ0B/6CaVUB7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB0993
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC8xOS8xOSA3OjE4IFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IEFjY29yZGluZyB0
byB0aGUgZmlybXdhcmUgZG9jdW1lbnRhdGlvbiBhIHN0YXR1cyB0eXBlIDAgSU9DQiBjYW4gYmUN
Cj4gZm9sbG93ZWQgYnkgb25lIG9yIG1vcmUgc3RhdHVzIGNvbnRpbnVhdGlvbiB0eXBlIDAgSU9D
QnMuIEhlbmNlIGRvIG5vdA0KPiBjb21wbGFpbiBpZiB0aGUgY29tcGxldGlvbiBmdW5jdGlvbiBp
cyBub3QgY2FsbGVkIGZyb20gaW5zaWRlIHRoZSBzdGF0dXMNCj4gdHlwZSAwIElPQ0IgaGFuZGxl
ci4NCj4gDQo+IFdBUk5JTkc6IENQVTogMTAgUElEOiA0MjUgYXQgZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2lzci5jOjI3ODQNCj4gcWxhMngwMF9zdGF0dXNfZW50cnkuaXNyYS43KzB4NDg0LzB4
MTdiMCBbcWxhMnh4eF0NCj4gQ1BVOiAxMCBQSUQ6IDQyNSBDb21tOiBrd29ya2VyLzEwOjEgVGFp
bnRlZDogRyAgICAgICAgICAgIEUgICAgIDUuMy4wLXJjNC1uZXh0LTIwMTkwODEzLWF1dG90ZXN0
LWF1dG90ZXN0ICMxDQo+IFdvcmtxdWV1ZTogcWxhMnh4eF93cSBxbGEyNXh4X2ZyZWVfcnNwX3F1
ZSBbcWxhMnh4eF0NCj4gQ2FsbCBUcmFjZToNCj4gIHFsYTJ4MDBfc3RhdHVzX2VudHJ5LmlzcmEu
NysweDE0ODQvMHgxN2IwIFtxbGEyeHh4XSAodW5yZWxpYWJsZSkNCj4gIHFsYTI0eHhfcHJvY2Vz
c19yZXNwb25zZV9xdWV1ZSsweDdkOC8weGJkMCBbcWxhMnh4eF0NCj4gIHFsYTI1eHhfZnJlZV9y
c3BfcXVlKzB4MWEwLzB4MjIwIFtxbGEyeHh4XQ0KPiAgcHJvY2Vzc19vbmVfd29yaysweDI1Yy8w
eDUyMA0KPiAgd29ya2VyX3RocmVhZCsweDhjLzB4NWUwDQo+ICBrdGhyZWFkKzB4MTU0LzB4MWEw
DQo+ICByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4NWMvMHg3Yw0KPiANCj4gQ2M6IEhpbWFuc2h1
IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KPiBDYzogQWJkdWwgSGFsZWVtIDxhYmRo
YWxlZUBsaW51eC52bmV0LmlibS5jb20+DQo+IFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IEFiZHVs
IEhhbGVlbSA8YWJkaGFsZWVAbGludXgudm5ldC5pYm0uY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBC
YXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaXNyLmMgfCAyIC0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4gaW5kZXggY2QzOWFjMThjNWZkLi5k
ODFiNWVjY2UyNGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3Iu
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4gQEAgLTI3ODAsOCAr
Mjc4MCw2IEBAIHFsYTJ4MDBfc3RhdHVzX2VudHJ5KHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBzdHJ1
Y3QgcnNwX3F1ZSAqcnNwLCB2b2lkICpwa3QpDQo+ICANCj4gIAlpZiAocnNwLT5zdGF0dXNfc3Ji
ID09IE5VTEwpDQo+ICAJCXNwLT5kb25lKHNwLCAgKiBkby1ub3QtcmVtb3ZlLXRoZS1maXJzdC1k
aWdpdC13aGVuLWF1dG8tY29tcGxldGluZy10aGUtdHBnLXRhZw0KIHJlcyk7DQo+IC0JZWxzZQ0K
PiAtCQlXQVJOX09OX09OQ0UodHJ1ZSk7DQo+ICB9DQo+ICANCj4gIC8qKg0KPiANCg0KUmV2aWV3
ZWQtYnk6IExlZSBEdW5jYW4gPGxkdW5jYW5Ac3VzZS5jb20+DQo=
