Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2D9C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 11:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0338E20709
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 11:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nbrPk6J+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wIafArLL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKNLG3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 06:06:29 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63514 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNLG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 06:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573729597; x=1605265597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XWjCv8HE3yY/SZ9SdPawWM5NkZdFCYo628WAjHiBr44=;
  b=nbrPk6J+BK0//N6G2mirnaOsEzukmlfQqsdIwx5iLtYdSZg76pDso/ug
   ru5iH8b9vR51zRtcPAQ8OrQ0sM4N/g7qPMzlJFuqNcC4wK+DfU67K+zbn
   NYVjAEzojHwutmlQnbUEugLMILWXhwdr4MlS7/Tpn1Jqra9f+ofTzPfCP
   iUSTu9CUQPK0ohD1MngGSiwBde2OP74jcQpTvsDtLNSnn0Uc05cjNm1S+
   1eTa1l6GwQ+c/gctox5UF5NtmynfUDYPOn/3uR1j4xGb+Y/pJgc1f5FIV
   KPu3ARqCZSgMhdU1bkyP9jVc3FHphJR2jONsjIRqoj7HKdYJOVI9KgZGx
   A==;
IronPort-SDR: Pe9gTAWXq2sCS2PVAz5CKKkfkojQKyVvXPzeiQE/e24ZlbeFgv5BroOnolE1M43LKCHZVDXjzQ
 O4Yu0uAiaxwdxS4fMX0i6vcglfT8IONePr2QS+TRxrDAFuPa24SuOljqa8XJp7ugptAUVi2qaX
 leF7ndf+3OCXLq6hZbW8UToiu3r6JepVBDT06osmdKM92kUO11dTUx0twnNyFgg9GD607zIZBJ
 YZ+iXCzZgmIZyBR1TEZgJv7IwKTYI8UfN0yqD1/+Bv8KTtKtt7FYtPcqKE95skwWYAiBz4INIW
 Bcc=
X-IronPort-AV: E=Sophos;i="5.68,304,1569254400"; 
   d="scan'208";a="224293072"
Received: from mail-sn1nam01lp2058.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.58])
  by ob1.hgst.iphmx.com with ESMTP; 14 Nov 2019 19:06:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ttby1qTU81HmDVj2+7qTnt9zQ9PbwNEUcfyIG4eO34ksnRr4tr8MSawxdda32vNoMfiFeJdw023cETvDtj6NC1AWjnz7izygI6w3FUsdDioDL3ztksx7AUX7hVjC56s2pjNwG+1aBKRYWHwbBNEAfgJhsq2uBe7ldybj/HCW7dtxEJsU4ulb5mJ5dfl9lF87bciqIZnc5zI+8rNRRd6z+Dd6R92TmB9gZ6DgGBKp/MMuD1Hh6ooKe2uLYk77GDEYOmrtgIR9uaPOmRYtoqzUSSPVhzdE9sthHpvMY60CneYIRbN+ae4HogxLf9+2AXJR5a3S0c5EW6ruOoHOXXHLRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWjCv8HE3yY/SZ9SdPawWM5NkZdFCYo628WAjHiBr44=;
 b=gLhGb1rODSwL60RQoSLuBNu+QcfsbM03+gnv9738wRomQDOPDmt166/2bxv1Oxu433SBqW2vFPOXqzF52l2sY1Lbj+FP5MMN8bcMfBfL2w/Au325aLCGT/HKI2PBT5/emuDnLG3+VJ3rj1ABsV3wcVGeBz2K+L2qd01qSCVVNKmr4pnVHXR0VB53vAMlWiTjqbeIJ5TCxWTVH9CPd1lR/BD1gRISzSXf+Izo1HgHXGOnQIR/Qr99azO8Hs/Mk3LwifPfuNX16HWwtzeIBHKRoXf9eYmtDur8Rcbx+Nf3sAUxMffAOlPXb2WYzrTBOy25gzta9UVh0rzoK28P1vRBBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWjCv8HE3yY/SZ9SdPawWM5NkZdFCYo628WAjHiBr44=;
 b=wIafArLLVD3iPYm3j5FmLk0Md0l/sBbyjGkswi5OKuOWLr7zpV6I1u6ry80dEOzngaC8SQBXcP+3TKvNuLbS54gRbQw4/CEPJqZWRh8Tq0yIPAu8vhXUshv40bA0gX1oCvSpip5qt8p2Mbw16WHbfxnrrrQHHWjd2OFCCam/zHs=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5902.namprd04.prod.outlook.com (20.179.21.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Thu, 14 Nov 2019 11:06:25 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Thu, 14 Nov 2019
 11:06:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 7/7] scsi: ufs: Fix error handing during hibern8 enter
Thread-Topic: [PATCH v4 7/7] scsi: ufs: Fix error handing during hibern8 enter
Thread-Index: AQHVme47ijnUgPv+FECOzh+ms1xXAKeKgHEg
Date:   Thu, 14 Nov 2019 11:06:25 +0000
Message-ID: <MN2PR04MB699130F410CDE9BFB5815CC0FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-8-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573627552-12615-8-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c82a1d5-ca44-44df-5cf4-08d768f2b0e1
x-ms-traffictypediagnostic: MN2PR04MB5902:
x-microsoft-antispam-prvs: <MN2PR04MB5902E4156A3E7BD4E7EF9D41FC710@MN2PR04MB5902.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(7696005)(11346002)(4326008)(71200400001)(86362001)(2201001)(71190400001)(14454004)(229853002)(76176011)(446003)(5660300002)(66066001)(99286004)(7416002)(478600001)(2906002)(25786009)(6246003)(6116002)(9686003)(66556008)(8936002)(64756008)(186003)(81156014)(54906003)(66476007)(66946007)(74316002)(2501003)(26005)(55016002)(3846002)(6436002)(256004)(110136005)(486006)(33656002)(7736002)(66446008)(6506007)(76116006)(102836004)(8676002)(476003)(305945005)(14444005)(52536014)(81166006)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5902;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UOCHo+uOJE2vlw5NJ79EqF8Y6uV+6eiok2E1zi9vJgfmHJ5ksXLA9qbamHKC74HOkLws2D5Be1eRL20HIvPdYuWOg9EIhBBmrwmA0bEdPYU54QP5jzB0ox+4c4LKp5eOiSh1LUlbCfC5Oi3crOuR8MUjo94bFnvHQhpKV4Y7p2l9RVIXlTeSoYxokj/gbnC7S+3w2ejeEmnOSeBX1KS7bvsb8pAbBSCkmW6G0wKLBi4khs3QV/g+6ICN2I168OpxHHvNkfaFGKViwaMu7zD5i8V6MvEJhyqcBXr7Mo3x7fSHOLJXFk72h/7Vwehk/muaHwMd/qjZNpznQn4WdmWRQeRFDOJZmmEDA0Cf3jmYiVmYid+UfxfjHi7jZM5SpaXtBx8+AcvPm3mjABzguTAY+D2OxZXONXbXJYM8OFtYrwqIlpN4CBmItvC/f/vtVeP0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c82a1d5-ca44-44df-5cf4-08d768f2b0e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 11:06:25.4441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EmHbjbDIGzEMhhvHmPrdQlEYGs3ZyZapgiw/lxai3htmIJ3EYiFZIbqBm9q13/BT+doCN9NgnrhQ+wI+bhOoxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5902
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IEZyb206IFN1Ymhhc2ggSmFkYXZhbmkgPHN1Ymhhc2hqQGNvZGVhdXJvcmEub3Jn
Pg0KPiANCj4gRHVyaW5nIGNsb2NrIGdhdGluZyAodWZzaGNkX2dhdGVfd29yaygpKSwgd2UgZmly
c3QgcHV0IHRoZSBsaW5rIGhpYmVybjggYnkNCj4gY2FsbGluZyB1ZnNoY2RfdWljX2hpYmVybjhf
ZW50ZXIoKSBhbmQgaWYgdWZzaGNkX3VpY19oaWJlcm44X2VudGVyKCkgcmV0dXJucw0KPiBzdWNj
ZXNzICgwKSB0aGVuIHdlIGdhdGUgYWxsIHRoZSBjbG9ja3MuDQo+IE5vdyBsZXTigJlzIHpvb20g
aW4gdG8gd2hhdCB1ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoKSBkb2VzIGludGVybmFsbHk6DQo+
IEl0IGNhbGxzIF9fdWZzaGNkX3VpY19oaWJlcm44X2VudGVyKCkgd2hpY2ggb24gZGV0ZWN0aW5n
IHRoZSBMSU5FUkVTRVQsDQo+IGluaXRpYXRlcyB0aGUgZnVsbCByZWNvdmVyeSBhbmQgcHV0cyB0
aGUgbGluayBiYWNrIHRvIGhpZ2hlc3QgSFMgZ2VhciBhbmQgcmV0dXJucw0KPiBzdWNjZXNzICgw
KSB0byB1ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoKSB3aGljaCBpcyB0aGUgaXNzdWUgYXMgbGlu
ayBpcyBzdGlsbCBpbg0KPiBhY3RpdmUgc3RhdGUgZHVlIHRvIHJlY292ZXJ5IQ0KPiBOb3cgdWZz
aGNkX3VpY19oaWJlcm44X2VudGVyKCkgcmV0dXJucyBzdWNjZXNzIHRvIHVmc2hjZF9nYXRlX3dv
cmsoKSBhbmQNCj4gaGVuY2UgaXQgZ29lcyBhaGVhZCB3aXRoIGdhdGluZyB0aGUgVUZTIGNsb2Nr
IHdoaWxlIGxpbmsgaXMgc3RpbGwgaW4gYWN0aXZlIHN0YXRlDQo+IGhlbmNlIEkgYmVsaWV2ZSBj
b250cm9sbGVyIHdvdWxkIHJhaXNlIFVJQyBlcnJvciBpbnRlcnJ1cHRzLiBCdXQgd2hlbiB3ZSBz
ZXJ2aWNlDQo+IHRoZSBpbnRlcnJ1cHQsIGNsb2NrcyBtaWdodCBoYXZlIGFscmVhZHkgYmVlbiBk
aXNhYmxlZCENCj4gDQo+IFRoaXMgY2hhbmdlIGZpeGVzIGZvciB0aGlzIGJ5IHJldHVybmluZyBm
YWlsdXJlIGZyb20NCj4gX191ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoKSBpZiByZWNvdmVyeSBz
dWNjZWVkcyBhcyBsaW5rIGlzIHN0aWxsIG5vdCBpbiBoaWJlcm44LA0KPiB1cG9uIHJlY2Vpdmlu
ZyB0aGUgZXJyb3IgdWZzaGNkX2hpYmVybjhfZW50ZXIoKSB3b3VsZCBpbml0aWF0ZSByZXRyeSB0
byBwdXQgdGhlDQo+IGxpbmsgc3RhdGUgYmFjayBpbnRvIGhpYmVybjguDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBTdWJoYXNoIEphZGF2YW5pIDxzdWJoYXNoakBjb2RlYXVyb3JhLm9yZz4NCj4gU2ln
bmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCj4gLS0tDQo+ICBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTkgKysrKysrKysrKysrKystLS0tLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMgaW5kZXgNCj4gN2E1YTkwNC4uOTM0YzI3YSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0z
ODkxLDE1ICszODkxLDI0IEBAIHN0YXRpYyBpbnQgX191ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIo
c3RydWN0DQo+IHVmc19oYmEgKmhiYSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBr
dGltZV90b191cyhrdGltZV9zdWIoa3RpbWVfZ2V0KCksIHN0YXJ0KSksIHJldCk7DQo+IA0KPiAg
ICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAgIGludCBlcnI7DQo+ICsNCj4gICAg
ICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogaGliZXJuOCBlbnRlciBmYWlsZWQu
IHJldCA9ICVkXG4iLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNfXywgcmV0KTsN
Cj4gDQo+ICAgICAgICAgICAgICAgICAvKg0KPiAtICAgICAgICAgICAgICAgICogSWYgbGluayBy
ZWNvdmVyeSBmYWlscyB0aGVuIHJldHVybiBlcnJvciBzbyB0aGF0IGNhbGxlcg0KPiAtICAgICAg
ICAgICAgICAgICogZG9uJ3QgcmV0cnkgdGhlIGhpYmVybjggZW50ZXIgYWdhaW4uDQo+ICsgICAg
ICAgICAgICAgICAgKiBJZiBsaW5rIHJlY292ZXJ5IGZhaWxzIHRoZW4gcmV0dXJuIGVycm9yIGNv
ZGUgKC1FTk9MSU5LKQ0KPiArICAgICAgICAgICAgICAgICogcmV0dXJuZWQgdWZzaGNkX2xpbmtf
cmVjb3ZlcnkoKS4NCj4gKyAgICAgICAgICAgICAgICAqIElmIGxpbmsgcmVjb3Zlcnkgc3VjY2Vl
ZHMgdGhlbiByZXR1cm4gLUVBR0FJTiB0byBhdHRlbXB0DQo+ICsgICAgICAgICAgICAgICAgKiBo
aWJlcm44IGVudGVyIHJldHJ5IGFnYWluLg0KWW91IG5vIGxvbmdlciByZXR1cm5pbmcgLUVOT0xJ
TkssIGFuZCBlaXRoZXIgd2F5IHJldHJ5aW5nLCByZWdhcmRsZXNzIG9mIHRoZSBlcnJvciBjb2Rl
Lg0KQmV0dGVyIGNoZWNrIHRoYXQgdGhlIGNvbW1pdCBsb2cgaXMgc3RpbGwgdGVsbGluZyB0aGUg
Y29ycmVjdCBzdG9yeSwgdGFraW5nIGludG8gY29uc2lkZXJhdGlvbiBhbGwgdGhvc2UgcmVjZW50
IGZpeGVzIGFuZCBhbGwuDQoNCj4gICAgICAgICAgICAgICAgICAqLw0KPiAtICAgICAgICAgICAg
ICAgaWYgKHVmc2hjZF9saW5rX3JlY292ZXJ5KGhiYSkpDQo+IC0gICAgICAgICAgICAgICAgICAg
ICAgIHJldCA9IC1FTk9MSU5LOw0KPiArICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX2xpbmtf
cmVjb3ZlcnkoaGJhKTsNCj4gKyAgICAgICAgICAgICAgIGlmIChlcnIpIHsNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgIiVzOiBsaW5rIHJlY292ZXJ5IGZhaWxl
ZCIsIF9fZnVuY19fKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gZXJyOw0KPiAr
ICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0g
LUVBR0FJTjsNCj4gKyAgICAgICAgICAgICAgIH0NCj4gICAgICAgICB9IGVsc2UNCj4gICAgICAg
ICAgICAgICAgIHVmc2hjZF92b3BzX2hpYmVybjhfbm90aWZ5KGhiYSwgVUlDX0NNRF9ETUVfSElC
RVJfRU5URVIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBQT1NUX0NIQU5HRSk7IEBAIC0zOTEzLDcgKzM5MjIsNyBAQA0K
PiBzdGF0aWMgaW50IHVmc2hjZF91aWNfaGliZXJuOF9lbnRlcihzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KPiANCj4gICAgICAgICBmb3IgKHJldHJpZXMgPSBVSUNfSElCRVJOOF9FTlRFUl9SRVRSSUVT
OyByZXRyaWVzID4gMDsgcmV0cmllcy0tKSB7DQo+ICAgICAgICAgICAgICAgICByZXQgPSBfX3Vm
c2hjZF91aWNfaGliZXJuOF9lbnRlcihoYmEpOw0KPiAtICAgICAgICAgICAgICAgaWYgKCFyZXQg
fHwgcmV0ID09IC1FTk9MSU5LKQ0KPiArICAgICAgICAgICAgICAgaWYgKCFyZXQpDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiAgICAgICAgIH0NCj4gIG91dDoNCj4gLS0N
Cj4gVGhlIFF1YWxjb21tIElubm92YXRpb24gQ2VudGVyLCBJbmMuIGlzIGEgbWVtYmVyIG9mIHRo
ZSBDb2RlIEF1cm9yYSBGb3J1bSwNCj4gYSBMaW51eCBGb3VuZGF0aW9uIENvbGxhYm9yYXRpdmUg
UHJvamVjdA0KDQo=
