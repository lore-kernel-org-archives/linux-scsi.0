Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90942C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646DC2082F
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZQStoOyW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ifcuHMZB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgGELhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 07:37:18 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32525 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGELhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 07:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593949037; x=1625485037;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=2jP1lLNuBhWzQcG3L7T5yQi0cPtTkvQ/32rKKCvGuWc=;
  b=ZQStoOyWYt5SjVlDHGGCYeDYPVJl4BvXOVd41m2mLrDK9aZ4sLOgLVYT
   hwMk38fhNOz9N/eak8U2xURz8nsCRnKXxwAe05gTnsDU4SBb7E7L4wnuh
   gF92N7MT6yct3ru3FFaaYGvt9ldCZh8lN6tEPVkYahFmG1Ur8IOGB5fm6
   fsvg/0OAQq07Gs+LLDl9KavVdUOkvm2lodNYh5Q+EExW7RpL4qq/Hq7F3
   V1hStbd5meCf2Fo7f3zkqYppBsSiv8Jao2W3SDgiyDGqNJlCQ+ui4igIm
   zuzjIZwHxUK+gZy3QTygzffh1CN+c7TQizCqvaJYm22KdHlAzaDmjGf94
   A==;
IronPort-SDR: U+MwEodtgY+fuR2FDctAsa099jF4/zto/vXYWGMEHkLa/fPM9rGZY1Iki/rO4G009C2JWAU5mM
 QxaQly3l3r7/iXuhe/1ltk73tbZpRqP7RbbZE6xgdAiAw18DMDmWXyzIAHOD5XtT3q3Ybwm7ct
 BLVMAXc0gp0OYNWbywyDHeffg6/TdQ2sSvnCzY4CExcIYtfYkD38s+ui3uqcTTqG84HfTn1+Nv
 VbyKvvagEggQnerCOsFTfT25sYUZCDSWNGyK/xMos4G1XSPZC70r8ksS2E73u01gcWXUdL6wEj
 vVQ=
X-IronPort-AV: E=Sophos;i="5.75,314,1589212800"; 
   d="scan'208";a="141854923"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2020 19:37:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alF6FwHINLv0P5e0LIFquKx/tQorcyoGSIz7anuEwgGl0MHK7lAcOjQDYLTbHcPB5ggVxdm3qDRSIj+VUQUnMWhGvPExizu8UUbyyQBtQ5IBRZbabpEngh+pvzKMGNp5AhXXdR+6YZ8u10cyxEethjlWE0TEthi/vLb4jEFYL2HAbtcvBTIOucVvlhbH1gn9WlbqQLGDO1LSoQmsPPFb4VyBMYqGvinOTEcUfDgwdcOKj8v0oyM/coGuJ4s6BheTSM5AFBdj4ldk7AHsORgLmij1oMwAnPMM9cHIvo5l0pBWrki29pzfYoy/5YyQbAG2pWAnkGqnKJ4RioD8kpoK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jP1lLNuBhWzQcG3L7T5yQi0cPtTkvQ/32rKKCvGuWc=;
 b=NL+KraBqO5C7IGUpMeuJz0QMsZGMyI4Wxqz65jMhfNq9De9g0r/HKG3kb0skHfugnBIv7WlRb1DiratANXfZZ3Fj7CqXAa0wQbzJKLlQILoaoaTPLx8RIxYwj+qSk4O6BCRkG/dZWZbSo8oE9S/7bAEwE0K7+7Vcjvlj5i+dj6Ft3GxKm27uAun0Itg8IFXewIL65a5fXcRwaKGssa9lc/Quv4+xNa45WeEfs4/qWx8VvNOgtkGg+ofsQfCtt2dlA+VibcnZXtn6AIyzgcb8luChNZ3Urn+VUjB3UsCasZZXg0zdWX1DwyQEexamQft41xI3mlSRgBwcr9UrRS7WyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jP1lLNuBhWzQcG3L7T5yQi0cPtTkvQ/32rKKCvGuWc=;
 b=ifcuHMZBaAZ9+ItZv5cM2PZ41o6wCOoGPsB2pvfzw5hsYFiY6IrdNXPWsbP6ceNeifVOU9R8/D9LiUdcZu4Ifi4PozrfX+0uHVTaNu+WGiWeczIxdtNy135VMYJyaqBwYctieyZ5WRB6HHdwNLKYUSIFYECWkXAUAU1czOfjkiY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4896.namprd04.prod.outlook.com (2603:10b6:805:99::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Sun, 5 Jul
 2020 11:37:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 11:37:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of
 command completion
Thread-Topic: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of
 command completion
Thread-Index: AQHWUPxDJCBduk2Mx0eXRm65N2XWbqj43rJg
Date:   Sun, 5 Jul 2020 11:37:12 +0000
Message-ID: <SN6PR04MB464035D0414922EEE0545CA6FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d@epcas2p1.samsung.com>
 <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
In-Reply-To: <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d6f4997a-0d9c-4454-a355-08d820d7c288
x-ms-traffictypediagnostic: SN6PR04MB4896:
x-microsoft-antispam-prvs: <SN6PR04MB48964BD9B3C41CC899ECF21AFC680@SN6PR04MB4896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 045584D28C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zoq0ONjvXUi+j/RAaQ28utc9RHHlpDOTaWKKB6A6UeYqMnudi8x7QCjOxSFFGrUv3oy88P5sue29KXY5dqEDyyYJgPwgnt7SHmoKsxRafAH90KdHIHfOhdjKAMY06NtU747wug9IO8KLXHogohrBfM8EcBXbYX26YL7NAm554My0TQ2Wt72g48PShYuz2jH2s21uOim38MrWz4I77MzRFHyAh0FqhVLGcNdwqqmSHkw/PoT7hOJCRgsui2mTcOu2TY64YWJe5PJ+grfFSMo0Vjl9hVTr9lhc1da2G1qeKJtoXmm9FykXWhDuoNNX8Kf3z6XepEOoVgY7RGbQCM1Cp8ZtPGJOJToXFFRL7w+D4JhmSOugv13r7j+BhPm+uk/r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(66946007)(55016002)(33656002)(2906002)(76116006)(8936002)(9686003)(478600001)(7416002)(186003)(7696005)(8676002)(5660300002)(71200400001)(6506007)(26005)(52536014)(110136005)(66446008)(316002)(86362001)(66556008)(66476007)(64756008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CkB3QKQQqh+cF9rRTsfdmksq7Loht7bsJ7IWvojMwrpFBBqhDVp5KvHYXHHtWyrVVy9esql6NwEENzHRB3bLMs+nu+G54pjcXUV08cbCGBRIfv8B8ZtiSzchXi2zIR4fODUh3wm3FVOXvu7IHVYoefaQQwlf29m2Zsq6qcFDMJqH6ZQSIcDtcM4mH38vXJMbqUs9xsTuNfjyudCeX6qD9jnnTCxvIjkGKhesb1xw3mRJzUATB635wLiobIF0V9tq8AbuLaGLxcMrb/vDhRxo5LiDGxq7r80OSpOuJUpJrPPOn3ULND+VmEzGwVERWCV3QUE3oJVRAez7mIAurSvVZmF/qp3Yy2X7DSjtSkpjGrYWDbHlLYQ2d//y4pMMD/pbFZEQfRyO6VxobPvlAkEQLL83ZTLSrdO8lAWb+P5Mp2akyBQzddlPdeBFaYfzb1j/ZnBTrqPGUqQPqVSlXU+QQ2YV0Wo0joy0jGWzxd4i9yE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f4997a-0d9c-4454-a355-08d820d7c288
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2020 11:37:12.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gdYGj7EYRVdVP6gRXAKBFFk+7DHbYE3hfFSYvNcG429sce600d+6CGbg4nVSgUboJ6pc8TnhTB/6o+C7Z+xZSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4896
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IA0KPiBTb21lIFNvQyBzcGVjaWZpYyBtaWdodCBuZWVkIGNvbW1hbmQgaGlzdG9y
eSBmb3INCj4gdmFyaW91cyByZWFzb25zLCBzdWNoIGFzIHN0YWNraW5nIGNvbW1hbmQgY29udGV4
dHMNCj4gaW4gc3lzdGVtIG1lbW9yeSB0byBjaGVjayBmb3IgZGVidWdnaW5nIGluIHRoZSBmdXR1
cmUNCj4gb3Igc2NhbGluZyBzb21lIERWRlMga25vYnMgdG8gYm9vc3QgSU8gdGhyb3VnaHB1dC4N
Cj4gDQo+IFdoYXQgeW91IHdvdWxkIGRvIHdpdGggdGhlIGluZm9ybWF0aW9uIGNvdWxkIGJlDQo+
IHZhcmlhbnQgcGVyIFNvQyB2ZW5kb3IuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtp
bSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLmMgfCAyICsrDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgOCArKysrKysrKw0K
PiAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4g
aW5kZXggNTJhYmU4Mi4uMzMyNjIzNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC00ODgyLDYg
KzQ4ODIsNyBAQCBzdGF0aWMgdm9pZCBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoc3RydWN0
DQo+IHVmc19oYmEgKmhiYSwNCj4gICAgICAgICBmb3JfZWFjaF9zZXRfYml0KGluZGV4LCAmY29t
cGxldGVkX3JlcXMsIGhiYS0+bnV0cnMpIHsNCj4gICAgICAgICAgICAgICAgIGxyYnAgPSAmaGJh
LT5scmJbaW5kZXhdOw0KPiAgICAgICAgICAgICAgICAgY21kID0gbHJicC0+Y21kOw0KPiArICAg
ICAgICAgICAgICAgdWZzaGNkX3ZvcHNfY29tcGxfeGZlcl9yZXEoaGJhLCBpbmRleCwgKGNtZCkg
PyB0cnVlIDogZmFsc2UpOw0KPiAgICAgICAgICAgICAgICAgaWYgKGNtZCkgew0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICB1ZnNoY2RfYWRkX2NvbW1hbmRfdHJhY2UoaGJhLCBpbmRleCwgImNv
bXBsZXRlIik7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHJlc3VsdCA9IHVmc2hjZF90cmFu
c2Zlcl9yc3Bfc3RhdHVzKGhiYSwgbHJicCk7DQo+IEBAIC00ODkwLDYgKzQ4OTEsNyBAQCBzdGF0
aWMgdm9pZCBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoc3RydWN0DQo+IHVmc19oYmEgKmhi
YSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgLyogTWFyayBjb21wbGV0ZWQgY29tbWFuZCBh
cyBOVUxMIGluIExSQiAqLw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBscmJwLT5jbWQgPSBO
VUxMOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBscmJwLT5jb21wbF90aW1lX3N0YW1wID0g
a3RpbWVfZ2V0KCk7DQo+ICsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgLyogRG8gbm90IHRv
dWNoIGxyYnAgYWZ0ZXIgc2NzaSBkb25lICovDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGNt
ZC0+c2NzaV9kb25lKGNtZCk7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIF9fdWZzaGNkX3Jl
bGVhc2UoaGJhKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+IGluZGV4IGM3NzQwMTIuLjVjZjlmOTkgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KPiBAQCAtMzA3LDYgKzMwNyw3IEBAIHN0cnVjdCB1ZnNfaGJhX3Zhcmlh
bnRfb3BzIHsNCj4gICAgICAgICB2b2lkICAgICgqY29uZmlnX3NjYWxpbmdfcGFyYW0pKHN0cnVj
dCB1ZnNfaGJhICpoYmEsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzdHJ1Y3QgZGV2ZnJlcV9kZXZfcHJvZmlsZSAqcHJvZmlsZSwNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKmRhdGEpOw0KPiArICAgICAgIHZvaWQgICAg
KCpjb21wbF94ZmVyX3JlcSkoc3RydWN0IHVmc19oYmEgKmhiYSwgaW50IHRhZywgYm9vbCBpc19z
Y3NpKTsNCk1heWJlIGFkZCBpdCByaWdodCBhZnRlciBzZXR1cF94ZmVyX3JlcT8NCk1ha2VzIG1v
cmUgc2Vuc2UgYXMgaXQgaXMgaXRzIGNvdW50ZXJwYXJ0Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4g
IH07DQo=
