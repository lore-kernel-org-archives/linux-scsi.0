Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E72C4740A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 17:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C783D21479
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 17:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfIIRlw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 13:41:52 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:35733 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728768AbfIIRlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2019 13:41:52 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Mon,  9 Sep 2019 17:41:02 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 9 Sep 2019 17:40:56 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 9 Sep 2019 17:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIIORFyGBgKVbHyzH0Ep/mTP4tJvX9bIVtqOlf9Uar1c8+jiknMi7LdT5r5+OHe8KTJgvgrB+Y66kmAvHVvEPQDhsWdvXGt7ZEafQeKITx9Op2rCTpvD60YG5lZXOf74g9sVcvBmE2Oelt01hWieIYeerBSQZN0O4Tna/4RXy+ZfmMjj+c5ptcTyCatRanX+Q1I5Z2UUXOc16mJ/owW5qRLf1t/L3XfveLKnJWTrzuaxzjwOpiBCJnxdne585bzACDbSiXNFdpYvmAGXKWOTNRcSGDUFmdwvsxfPQcTcRc+XJbPX6zcBpVPAhzbRq0RmkvT/FBdsKt+tsOMn0VOlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCO9Pf/Dzc0SlFyujJDPARa1C/WhjnsiHiLBF33Rx6A=;
 b=IfZeiqq6HyZtmn3I9dZVD0hVOhV6ztE5zHW2o3xfxw5uFtujb/YsY6LKPytMivFRCpc+Xb5f106FQRPmRyuRbgoeONPO0A2XqSePSrycoMB58H4w11Z7+/1tivS1OjrsJqU+CT63jAh+oaa0HSR9uamUz0UGm6HCvMI8lIZ1/x3umehGD2AQSf5vnMxSernbdy3YcNuf4kFeQsfunSZJORywE5DgPQsHW7OjGjDl/SQmA1nQFDCC+xf4NLxd2FUW8ZfIexbumne/94hhIL18gS/IlvACWaSfUBwsL+N/+zBPdp4ujOQSDcJFbkJpNXuqdhbVuUUrdQzmdpQ0n8UEaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BN6PR18MB1172.namprd18.prod.outlook.com (10.172.207.147) by
 BN6PR18MB1459.namprd18.prod.outlook.com (10.172.209.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 17:40:54 +0000
Received: from BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::38ee:6fc9:943f:3ae]) by BN6PR18MB1172.namprd18.prod.outlook.com
 ([fe80::38ee:6fc9:943f:3ae%11]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 17:40:54 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Laurence Oberman <loberman@redhat.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or
 TASK_SET_FULL
Thread-Topic: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or
 TASK_SET_FULL
Thread-Index: AQHVZwcKCORwloRI/UGdKp64mjcNCacjnTkA
Date:   Mon, 9 Sep 2019 17:40:54 +0000
Message-ID: <4da54266-e340-976e-b3b1-9a7e551e86d2@suse.com>
References: <1568030756-17428-1-git-send-email-loberman@redhat.com>
In-Reply-To: <1568030756-17428-1-git-send-email-loberman@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6PR1001CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:4:b7::32) To BN6PR18MB1172.namprd18.prod.outlook.com
 (2603:10b6:404:eb::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de2c404-e8ad-41b5-815b-08d7354cdcf2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR18MB1459;
x-ms-traffictypediagnostic: BN6PR18MB1459:
x-microsoft-antispam-prvs: <BN6PR18MB145906CAE33F74C56FFBFE8CDAB70@BN6PR18MB1459.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(8676002)(31686004)(36756003)(102836004)(478600001)(11346002)(446003)(6512007)(31696002)(52116002)(2501003)(76176011)(5660300002)(2616005)(53936002)(229853002)(6486002)(110136005)(26005)(2201001)(6246003)(6436002)(99286004)(186003)(316002)(80792005)(14454004)(66946007)(66556008)(66446008)(64756008)(3846002)(6116002)(66476007)(2906002)(476003)(386003)(66066001)(86362001)(25786009)(8936002)(81166006)(81156014)(53546011)(6506007)(256004)(14444005)(486006)(305945005)(7736002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR18MB1459;H:BN6PR18MB1172.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sCammmUnrl/0NvJhFofsF+cpBoQDDZYsbI6DK62fy3B7+jbyMWtpEHCYhyQdex8751bsWk3cZbIjo6eMEuN6mC44r9/DAv/BSBexmRhMK2p5PK9PU9gBcPtpxTjmHHrLT+3g468JgkZ+Aj0k64928ZV6HoPHaY3+GhddBaNAJfwspKW93lAR9nwJY2LezaaHdHbofoDv4T9r4dEHlaRW5H3AVZe+jid0O8UG0gAJxASStm/k70zjHG6EqBkovzHsY4Ys9i8NvmZFfWyGPSqNZAD+aoDwd5gxg9/fnOiNsrhUDqeyWOnICTW0+IbW4I4CA3W9YW0r2Fksjb/UWFAbLBp9dATLYB6t2FazMvAXydKdFiMNZLYoTKMj6r1lyaipOlRPXzTti90GVBd1VoMhJeVSifOySfG5BzUREwVyFcU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A002513FD1067489FA5E2C0ACB383D8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de2c404-e8ad-41b5-815b-08d7354cdcf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 17:40:54.2009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +WbriRlYVP/Eg4ppr3gLaZR/MsXXORSkc2Hp3PstnP+IAHA8FRxsjCnakvTjkraJ/yibD02BSvBLGM4+B5pw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1459
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS85LzE5IDU6MDUgQU0sIExhdXJlbmNlIE9iZXJtYW4gd3JvdGU6DQo+IFRoZSBxbGEyeHh4
IGRyaXZlciBoYWQgdGhpcyBpc3N1ZSBhcyB3ZWxsIHdoZW4gdGhlIG5ld2VyIGFycmF5DQo+IGZp
cm13YXJlIHJldHVybmVkIHRoZSByZXRyeV9kZWxheV90aW1lciBpbiB0aGUgZmNwX3JzcC4NCj4g
VGhlIGJueDJmYyBpcyBub3QgaGFuZGxpbmcgdGhlIG1hc2tpbmcgb2YgdGhlIHNjb3BlIGJpdHMg
ZWl0aGVyDQo+IHNvIHRoZSByZXRyeV9kZWxheV90aW1lc3RhbXAgdmFsdWUgbGFuZHMgdXAgYmVp
bmcgYSBsYXJnZSB2YWx1ZQ0KPiBhZGRlZCB0byB0aGUgdGltZXIgdGltZXN0YW1wIGRlbGF5aW5n
IEkvTyBmb3IgdXAgdG8gMjcgTWludXRlcy4NCj4gVGhpcyBwYXRjaCBhZGRzIHNpbWlsYXIgY29k
ZSB0byBoYW5kbGUgdGhpcyB0byB0aGUNCj4gYm54MmZjIGRyaXZlciB0byBhdm9pZCB0aGUgaHVn
ZSBkZWxheS4NCj4gDQo+IFYyLiBJbmRlbnQgY29tbWVudHMgYXMgc3VnZ2VzdGVkDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBMYXVyZW5jZSBPYmVybWFuIDxsb2Jlcm1hbkByZWRoYXQuY29tPg0KPiAt
LS0NCj4gIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmMgfCAyMyArKysrKysrKysrKysr
KysrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaW8u
YyBiL2RyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmMNCj4gaW5kZXggOWU1MGU1Yi4uMzlm
NGFlYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaW8uYw0KPiAr
KysgYi9kcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19pby5jDQo+IEBAIC0xOTI4LDYgKzE5Mjgs
NyBAQCB2b2lkIGJueDJmY19wcm9jZXNzX3Njc2lfY21kX2NvbXBsKHN0cnVjdCBibngyZmNfY21k
ICppb19yZXEsDQo+ICAJc3RydWN0IGJueDJmY19ycG9ydCAqdGd0ID0gaW9fcmVxLT50Z3Q7DQo+
ICAJc3RydWN0IHNjc2lfY21uZCAqc2NfY21kOw0KPiAgCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3Q7
DQo+ICsJdTE2IHNjb3BlLCBxdWFsaWZpZXIgPSAwOw0KPiAgDQo+ICANCj4gIAkvKiBzY3NpX2Nt
ZF9jbXBsIGlzIGNhbGxlZCB3aXRoIHRndCBsb2NrIGhlbGQgKi8NCj4gQEAgLTE5OTcsMTIgKzE5
OTgsMjggQEAgdm9pZCBibngyZmNfcHJvY2Vzc19zY3NpX2NtZF9jb21wbChzdHJ1Y3QgYm54MmZj
X2NtZCAqaW9fcmVxLA0KPiAgDQo+ICAJCQlpZiAoaW9fcmVxLT5jZGJfc3RhdHVzID09IFNBTV9T
VEFUX1RBU0tfU0VUX0ZVTEwgfHwNCj4gIAkJCSAgICBpb19yZXEtPmNkYl9zdGF0dXMgPT0gU0FN
X1NUQVRfQlVTWSkgew0KPiArCQkJCS8qIE5ld2VyIGFycmF5IGZpcm13YXJlIHdpdGggQlVTWSBv
cg0KPiArCQkJCSAqIFRBU0tfU0VUX0ZVTEwgbWF5IHJldHVybiBhIHN0YXR1cyB0aGF0IG5lZWRz
DQo+ICsJCQkJICogdGhlIHNjb3BlIGJpdHMgbWFza2VkLg0KPiArCQkJCSAqIE9yIGEgaHVnZSBk
ZWxheSB0aW1lc3RhbXAgdXAgdG8gMjcgbWludXRlcw0KPiArCQkJCSAqIGNhbiByZXN1bHQuDQo+
ICsJCQkJKi8NCj4gKwkJCQlpZiAoZmNwX3JzcC0+cmV0cnlfZGVsYXlfdGltZXIpIHsNCj4gKwkJ
CQkJLyogVXBwZXIgMiBiaXRzICovDQo+ICsJCQkJCXNjb3BlID0gZmNwX3JzcC0+cmV0cnlfZGVs
YXlfdGltZXINCj4gKwkJCQkJCSYgMHhDMDAwOw0KPiArCQkJCQkvKiBMb3dlciAxNCBiaXRzICov
DQo+ICsJCQkJCXF1YWxpZmllciA9IGZjcF9yc3AtPnJldHJ5X2RlbGF5X3RpbWVyDQo+ICsJCQkJ
CQkmIDB4M0ZGRjsNCj4gKwkJCQl9DQo+ICsJCQkJaWYgKHNjb3BlID4gMCAmJiBxdWFsaWZpZXIg
PiAwICYmDQo+ICsJCQkJCXF1YWxpZmllciA8PSAweDNGRUYpIHsNCj4gIAkJCQkJLyogU2V0IHRo
ZSBqaWZmaWVzICsgDQo+IAkJCQkJcmV0cnlfZGVsYXlfdGltZXIgKiAxMDBtcw0KPiAgCQkJCSAg
IAlmb3IgdGhlIHJwb3J0L3RndCANCj4gCQkJCQkqLw0KPiAtCQkJCXRndC0+cmV0cnlfZGVsYXlf
dGltZXN0YW1wID0gamlmZmllcyArDQo+IC0JCQkJCWZjcF9yc3AtPnJldHJ5X2RlbGF5X3RpbWVy
ICogSFogLyAxMDsNCj4gKwkJCQkJdGd0LT5yZXRyeV9kZWxheV90aW1lc3RhbXAgPSBqaWZmaWVz
ICsNCj4gKwkJCQkJCShxdWFsaWZpZXIgKiBIWiAvIDEwKTsNCj4gKwkJCQl9DQo+ICAJCQl9DQo+
IC0NCj4gIAkJfQ0KPiAgCQlpZiAoaW9fcmVxLT5mY3BfcmVzaWQpDQo+ICAJCQlzY3NpX3NldF9y
ZXNpZChzY19jbWQsIGlvX3JlcS0+ZmNwX3Jlc2lkKTsNCj4gDQoNClJldmlld2VkLWJ5OiBMZWUg
RHVuY2FuIDxsZHVuY2FuQHN1c2UuY29tPg0K
