Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD63EC3A59E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 22:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D70B20674
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 22:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfIDWtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 18:49:43 -0400
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:60646 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728072AbfIDWtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 18:49:42 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2019 18:49:40 EDT
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.191) BY m9a0001g.houston.softwaregrp.com WITH ESMTP;
 Wed,  4 Sep 2019 22:48:55 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 4 Sep 2019 22:33:40 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 4 Sep 2019 22:33:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdn0J3q4YB8fuEfpwgqIRJg0iVRKn8ahPmdhqhZXj0Arlm3VebMNgClVClgZ97Uqfwdii6Z71d6d8TY7PiYLxnRd9M0jHyQjZ6ZE8TrCmEKefzdRiYN8khWK3zam+N0Z70P3oS+6krlDFxDDMkbP3lXDB4FcB/SkextywMOMd8AqD0WEaRgebREwlJE7NSi7GOUOgjAfhU/aJ2RQFyV/Y7BorDBIC8VSVJGo6Ho2v7C0K2+CZzqUdpOODzq2v3BmbZwB1jwTXoNjggNg9l9iUXoi9ogq7hpA8Ocv7HwWSc+KvEpXrDwrlH6ShYeFhWSOKIQCndwD8KGYkh8OpzYSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgR46ss7d/3vF10IQnba3L++Jm/mAQ/vvSW9RCHfAaI=;
 b=WLv7La+Yne+WbQeYE4rqARnTdFRW9baVliqj4Zigzkqg/97i7QgbVOBVMlKIca2kwrSGa9tDjYDD2EAoZjSUVWx8Eb00BID+MdqajvW3oU1NDRn6D4rzt0CdzoopZ2JzDnBnyH+yWKoAgi8+m3fQtjrMWFcu8AELR0V3VosKX7nl73uLasx9tS8plCDs6CmhJ6FCXarcbD3SaqOs5nhomd5IjlsOOmgGJQwCM/tHbCb97YGW84o8PKi4WOV1vt5VNR5IxhjJ2K4jbH191oktIVB5dqW+RtJDYhhbOG99PsW2qvirdXNbrASbnaf1AAtC28f3ImyOzohRLPazApXBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BN6PR18MB1172.namprd18.prod.outlook.com (10.172.207.147) by
 BN6PR18MB1507.namprd18.prod.outlook.com (10.175.191.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Wed, 4 Sep 2019 22:33:39 +0000
Received: from BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::4cf:874f:61a4:e220]) by BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::4cf:874f:61a4:e220%9]) with mapi id 15.20.2220.021; Wed, 4 Sep 2019
 22:33:39 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/6] qla2xxx: Fix message indicating vectors used by
 driver
Thread-Topic: [PATCH 1/6] qla2xxx: Fix message indicating vectors used by
 driver
Thread-Index: AQHVX4G2YFtD4ZKnpEecCgmHmblRtaccIooA
Date:   Wed, 4 Sep 2019 22:33:39 +0000
Message-ID: <2589c49d-fe93-de98-b141-e1ee3e98e46b@suse.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
 <20190830222402.23688-2-hmadhani@marvell.com>
In-Reply-To: <20190830222402.23688-2-hmadhani@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB8PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:10:110::35) To BN6PR18MB1172.namprd18.prod.outlook.com
 (2603:10b6:404:eb::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 466b673e-6b02-4e01-ad7b-08d73187eeb3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR18MB1507;
x-ms-traffictypediagnostic: BN6PR18MB1507:
x-microsoft-antispam-prvs: <BN6PR18MB1507869219E9051CE88CE269DAB80@BN6PR18MB1507.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(189003)(199004)(52116002)(71200400001)(71190400001)(7736002)(26005)(53546011)(8676002)(6506007)(14444005)(256004)(386003)(14454004)(31696002)(81156014)(2201001)(31686004)(486006)(110136005)(76176011)(81166006)(446003)(6512007)(305945005)(102836004)(66066001)(2616005)(36756003)(229853002)(2906002)(6486002)(11346002)(186003)(476003)(86362001)(316002)(53936002)(80792005)(66946007)(8936002)(66476007)(2501003)(5660300002)(3846002)(64756008)(66446008)(66556008)(4326008)(99286004)(15650500001)(6246003)(6436002)(478600001)(25786009)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR18MB1507;H:BN6PR18MB1172.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +UpxBVkltclB7gIF9mvDJ1y5lO+QuyXXOgveoQEyZY+pOFifcbaKMCX+YWmM98+k48Ipm8Y7KJq2L5hCsKndBjMUakuT3w0zaWLcH93XXNbhLIZCuVKCawxz3WaM3YDe/Zi10MPkeftFW7Vzs53aqtSFtBK8mOzoZgWHCz6bS/FSpws85ZJvL3LS+l49a5f5cKBf+SA9AmL5pTtH/vu9hD+AwanarlIr5wXMu1uvX0TVogkwB6AoJmoiPYh/nRN4vG4lHS+8X7n0uKGIIk8qKI28voPbTbwiH1ZLc98kFPoCgTBn2NxL+vFwWFJCbK+HMTWLQzOLsjY0/so4RKybRjfNjiQH6pJMtQ4o8Qb/cbvp9cQs3If5Kv5RpuMAtvwiVy0sHz0HKxEDr2dsk/rjkYUBW31QyjazlWuZ3VjwWuc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <648CE31CED21464FAE03370A7A2B8F1D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 466b673e-6b02-4e01-ad7b-08d73187eeb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 22:33:39.3392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+HNPQJq2emLcqOIWxx+u0Y6YTVHBul4d3+Jkz2ZuRgDf/KdWX0oBJgmsK/ZIMNOP8ZV1SE1KJTR9zYo+TUB9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1507
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC8zMC8xOSAzOjIzIFBNLCBIaW1hbnNodSBNYWRoYW5pIHdyb3RlOg0KPiBUaGlzIHBhdGNo
IHVwZGF0ZXMgbG9nIG1lc3NhZ2Ugd2hpY2ggaW5kaWNhdGVzIG51bWJlcg0KPiBvZiB2ZWN0b3Jz
IHVzZWQgYnkgZHJpdmVyIGluc3RlYWQgb2YgZGlzcGxheWluZyBmYWlsdXJlDQo+IHRvIGdldCBt
YXhpbXVtIHJlcXVlc3RlZCB2ZWN0b3JzLiBEcml2ZXIgd2lsbCBhbHdheXMNCj4gcmVxdWVzdCBt
YXhpbXVtIHZlY3RvcnMgZHVyaW5nIGluaXRpYWxpemF0aW9uLiBJbiB0aGUNCj4gZXZlbnQgZHJp
dmVyIGlzIG5vdCBhYmxlIHRvIGdldCBtYXhpbXVtIHJlcXVlc3RlZCB2ZWN0b3JzLA0KPiBpdCB3
aWxsIGFkanVzdCB0aGUgYWxsb2NhdGVkIHZlY3RvcnMuIFRoaXMgaXMgbm9ybWFsIGFuZA0KPiBk
b2VzIG5vdCBpbXBseSBmYWlsdXJlIGluIGRyaXZlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhp
bWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pc3IuYyB8IDYgKystLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pc3IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0K
PiBpbmRleCBkODFiNWVjY2UyNGIuLjRjMjY2MzBjMWMzZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9pc3IuYw0KPiBAQCAtMzQ2NiwxMCArMzQ2Niw4IEBAIHFsYTI0eHhfZW5hYmxlX21zaXgoc3Ry
dWN0IHFsYV9od19kYXRhICpoYSwgc3RydWN0IHJzcF9xdWUgKnJzcCkNCj4gIAkJICAgIGhhLT5t
c2l4X2NvdW50LCByZXQpOw0KPiAgCQlnb3RvIG1zaXhfb3V0Ow0KPiAgCX0gZWxzZSBpZiAocmV0
IDwgaGEtPm1zaXhfY291bnQpIHsNCj4gLQkJcWxfbG9nKHFsX2xvZ193YXJuLCB2aGEsIDB4MDBj
NiwNCj4gLQkJICAgICJNU0ktWDogRmFpbGVkIHRvIGVuYWJsZSBzdXBwb3J0ICINCj4gLQkJICAg
ICAid2l0aCAlZCB2ZWN0b3JzLCB1c2luZyAlZCB2ZWN0b3JzLlxuIiwNCj4gLQkJICAgIGhhLT5t
c2l4X2NvdW50LCByZXQpOw0KPiArCQlxbF9sb2cocWxfbG9nX2luZm8sIHZoYSwgMHgwMGM2LA0K
PiArCQkgICAgIk1TSS1YOiBVc2luZyAlZCB2ZWN0b3JzXG4iLCByZXQpOw0KPiAgCQloYS0+bXNp
eF9jb3VudCA9IHJldDsNCj4gIAkJLyogUmVjYWxjdWxhdGUgcXVldWUgdmFsdWVzICovDQo+ICAJ
CWlmIChoYS0+bXFpb2Jhc2UgJiYgKHFsMnhtcXN1cHBvcnQgfHwgcWwyeG52bWVlbmFibGUpKSB7
DQo+IA0KDQpSZXZpZXdlZC1ieTogTGVlIER1bmNhbiA8bGR1bmNhbkBzdXNlLmNvbT4NCg==
