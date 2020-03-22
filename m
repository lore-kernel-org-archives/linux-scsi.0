Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582E2C54FD1
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 12:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CF02076F
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 12:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bnLF1eUM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E7pusR7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCVMYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 08:24:31 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62360 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgCVMYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 08:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584879869; x=1616415869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qPeh+EomQ1jAeFmvikx3IVTpnFq0fDWiBoWvIjoi1kQ=;
  b=bnLF1eUMabjPLuIMhlOACXSvnXZAhqrtfHSsMAvabhLAYglbbsnDDrwd
   FraOd4om5oVBsJORVrmX6Lp/9E9ZCS0h9uqdPdQyvCbovOEcr+O4OZHkE
   NCjGVoHMmMLnMXebfAuegPCICty8/lv5jHBbdZ+JK0QMrvf5aJLKr5miY
   d27ZSC4+nVMX//OlDMqNQKb2IAinC35KJC+X0hl9Vsp9FGJq5ahvocMSK
   8vAhjkxrA8cr/iNiwCiH+RD/dLIFn6LUjZRtqVr6RNNL4ChCI3gYGeXtb
   Pa1IUJ85d/rynRdRyQpx2Czs+jiOFjgBA3YtiIa54n7ViHXSeyiise1cl
   Q==;
IronPort-SDR: eM4khrbsvnhqVr2ciue7z+fgmeo2hqgPnIuoTQOg5tmV14n9XLM8AKh5wbekwswiD2ZV/LYlqa
 6OwjF8htXJ8nbleamVm+7KTA5HZnaKyyXFCtQYKs2URZO31Me3wzyuVwMH6j6GzbqBJVDGgEm2
 91l/f5mYWcL8asIov6gRfPeieE9ss9fucL7YPimuV/7uV79b7RbhnRaLd+Djwjlpyj6aVeuyId
 sRWx+bO27LrWDjajnMVjWyHOgRLgkD1X6lQrFYt9AWzCWRmu4zdM0DqyxNH9rTkPOcaC8gp43B
 +6E=
X-IronPort-AV: E=Sophos;i="5.72,292,1580745600"; 
   d="scan'208";a="241619276"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2020 20:24:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0vxFLsBSZxipsRHOCWWGDFl/FIqfyzhH4LPgeZT8luiu3JvgxU0c1aWW+4KvLtgzpeuTpl22jE7R8Q77CpiYuP/Raw93DZUk2ABbb3otN6rZCm9Ur9mB0CUPiTj3scpOnPssTplpmybOTqzyJ0594W0tL6HZupQVbVeueEwYHW5kDpaVPcgOFHEM+JXgZXp0UVaqAvXIDUE77eRWyyhQ3nUr/7HX7uo6UiKTdbOlrCX33KJIA3foFRi59VWj5X2j1z170Xme2K9TjpMaLOIHZzAG2hEKK2Ux5AlLjzwHM5jLHjvGDB4OR45pOdpiIuDIJDPJldB7TACdRqAFrCNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPeh+EomQ1jAeFmvikx3IVTpnFq0fDWiBoWvIjoi1kQ=;
 b=gsXNvupGAvJMXWM92IxYQwX5q/GV/x7qidr6ckVEWifFGS2mspI/hl1hiB+H0dgKxrWFyvuYCJU85I2HyvYks8FsJN3QsVk4DBClChsb++0WyJksKYr4BLrJmeLlOtf1/qbGjZLB2ODo7d+NqnnOKVVENvxLSuRnncc7j+VKUggsag2ygvozeSG9p3tUolhtC8vrJblIEofk8W2vVdfVSvtM6l28lImHNAU7cXysu7oyuCw9jfeVvQrOCGFNdwDe6pr3DBapp0yPo4r5hfYZ+R+2+LVA/qbM3aIZt47PgXgbxQEo8k8bFOySP/GxUBiF1l5YUGta/p0jFW08AcpUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPeh+EomQ1jAeFmvikx3IVTpnFq0fDWiBoWvIjoi1kQ=;
 b=E7pusR7bVniz89qlOXGnXkagD2iytDmgjFxi7rVy+aPu3biwKq7Md4FeVRVm7G3uRIouNMv6gMz243XwhXqNCrbGw9JSJsFTj5+eA+fmecXNGV+dx9Cqhf5dTpMUubL0HQL4q20Og06DDLXTFpbmJj1hoHcfRWgSXlsPIh+oINE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5214.namprd04.prod.outlook.com (2603:10b6:805:101::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Sun, 22 Mar
 2020 12:24:17 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2835.021; Sun, 22 Mar 2020
 12:24:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Thread-Topic: [PATCH v3 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Thread-Index: AQHV/gAk1EIQPTlmQUi6WMBdNdzlKKhUeXGA
Date:   Sun, 22 Mar 2020 12:24:17 +0000
Message-ID: <SN6PR04MB46404847C78F62BA2D5CD2A0FCF30@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
        <CGME20200319150710epcas5p11411da0ec2d56b403b80a206ce38a92b@epcas5p1.samsung.com>
 <20200319150031.11024-5-alim.akhtar@samsung.com>
In-Reply-To: <20200319150031.11024-5-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd868fd6-63ec-4e43-7b85-08d7ce5bf0ee
x-ms-traffictypediagnostic: SN6PR04MB5214:
x-microsoft-antispam-prvs: <SN6PR04MB5214B65934D2354D10D00BDAFCF30@SN6PR04MB5214.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0350D7A55D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(199004)(5660300002)(8936002)(66946007)(81156014)(81166006)(33656002)(8676002)(110136005)(7416002)(54906003)(6506007)(55016002)(316002)(7696005)(4326008)(9686003)(86362001)(52536014)(186003)(76116006)(26005)(66476007)(64756008)(66446008)(66556008)(478600001)(2906002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB5214;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCJXqT73ZCjNVgV23xV+am8wZpq5i1q8enFnVnBni790WnfY4fZktuCDAYfosMim/9yoclEtXrx4gbKvk0BglivYwKmJTr8ooATwBvmABFBYwVrXO8j6XCmb6KgWogXBstArKsi9fAuyJXXmzLqMoxK01w5yO9rT50zPDp1EbGTk2TeBcq1+ynsXPCvd+KztcqVq+NhT/B90jKqWJipG2Pd9asL1EUCRjg1GvkSpPrNT+3JdiX1BfVCAti2CprCcmbOqiT2JvUtFZeSJmnd5nxrCGj9SIfXM5zWGKRgHhV/4TtU7I/sK2OwI0wsjRLF3Lptsl7i+mCouoKVe+RWXtHfPwAhyRNXlg6rsOGDDTj4oRIWGHJVNG1ticmR04BuCC4nbwDTafHmPHRyPbnuAMA5TSd/HJWBZeIXtCgO/4FrFRHsrFk1ONi3tVMk7x9Xd
x-ms-exchange-antispam-messagedata: oVyVTZALeJiRidMcqrxw30IF7E1tzLwVZ37szKvwGk27aBhJGmItqAoV+j9VkXz4mPI28nKZE2kbME9rKnlenw1Cg0eUeLE9BldVc5wOtkgbVRIbuDXPLA8qWmEaAVMmZ9SR5qCLdMCI3/Qf91cv9g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd868fd6-63ec-4e43-7b85-08d7ce5bf0ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2020 12:24:17.4803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ws2oOcwe5WjIyR0SCHNHJboW0dlHuW5IhXENb/zC8fBx61eZK4zP/VBjI6e9w17A7k8a9UQSJ7cwHMlizq6Ueg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5214
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIGludCBleHlub3M3X3Vmc19wcmVfbGluayhzdHJ1Y3QgZXh5bm9zX3VmcyAqdWZz
KQ0KPiArew0KPiArICAgICAgIHN0cnVjdCB1ZnNfaGJhICpoYmEgPSB1ZnMtPmhiYTsNCj4gKyAg
ICAgICB1MzIgdmFsID0gdWZzLT5kcnZfZGF0YS0+dWljX2F0dHItPnBhX2RiZ19vcHRpb25fc3Vp
dGU7DQpDYW4gcGFfZGJnX29wdGlvbl9zdWl0ZSBiZSByZXBsYWNlZCBieSBhIG1hY3JvPw0KDQo+
ICsgICAgICAgZXh5bm9zX3Vmc19kaXNhYmxlX292X3RtKGhiYSk7DQo+ICsNCj4gKyAgICAgICB1
ZnNoY2RfZG1lX3NldChoYmEsIFVJQ19BUkdfTUlCKFBBX0RCR19PUFRJT05fU1VJVEVfRFlOKSwN
Cj4gMHhmKTsNCj4gKyAgICAgICB1ZnNoY2RfZG1lX3NldChoYmEsIFVJQ19BUkdfTUlCKFBBX0RC
R19PUFRJT05fU1VJVEVfRFlOKSwNCj4gMHhmKTsNCkEgdHlwbz8gU2V0IFBBX0RCR19PUFRJT05f
U1VJVEVfRFlOIHR3aWNlPyANCg0KPiArI2RlZmluZSBQV1JfTU9ERV9TVFJfTEVOICAgICAgIDY0
DQo+ICtzdGF0aWMgaW50IGV4eW5vc191ZnNfcG9zdF9wd3JfbW9kZShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB1ZnNfcGFfbGF5
ZXJfYXR0ciAqcHdyX21heCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1
Y3QgdWZzX3BhX2xheWVyX2F0dHIgKnB3cl9yZXEpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IGV4
eW5vc191ZnMgKnVmcyA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiArICAgICAgIHN0cnVj
dCBwaHkgKmdlbmVyaWNfcGh5ID0gdWZzLT5waHk7DQo+ICsgICAgICAgc3RydWN0IHVpY19wd3Jf
bW9kZSAqcHdyID0gJnVmcy0+cHdyX2FjdDsNCj4gKyAgICAgICBjaGFyIHB3cl9zdHJbUFdSX01P
REVfU1RSX0xFTl0gPSAiIjsNClVuLW5lZWRlZCBjb21wbGljYXRpb24gSU1PIC0gYWxsIHRob3Nl
IHNucHJpbnRmIHRoYXQgaXMuIA0KDQo+ICsNCj4gK3N0YXRpYyB2b2lkIGV4eW5vc191ZnNfZml0
X2FnZ3JfdGltZW91dChzdHJ1Y3QgZXh5bm9zX3VmcyAqdWZzKQ0KPiArew0KPiArICAgICAgIGNv
bnN0IHU4IGNudHJfZGl2ID0gNDA7DQpDYW4gYmUgcmVwbGFjZWQgYnkgYSBtYWNybz8NCg0KPiAr
c3RydWN0IGV4eW5vc191ZnNfZHJ2X2RhdGEgZXh5bm9zX3Vmc19kcnZzID0gew0KPiArDQo+ICsg
ICAgICAgLmNvbXBhdGlibGUgICAgICAgICAgICAgPSAic2Ftc3VuZyxleHlub3M3LXVmcyIsDQo+
ICsgICAgICAgLnVpY19hdHRyICAgICAgICAgICAgICAgPSAmZXh5bm9zN191aWNfYXR0ciwNCj4g
KyAgICAgICAucXVpcmtzICAgICAgICAgICAgICAgICA9IFVGU0hDRF9RVUlSS19QUkRUX0JZVEVf
R1JBTiB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBVRlNIQ0lfUVVJUktf
QlJPS0VOX1JFUV9MSVNUX0NMUiB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBVRlNIQ0lfUVVJUktfQlJPS0VOX0hDRSB8DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBVRlNIQ0lfUVVJUktfU0tJUF9SRVNFVF9JTlRSX0FHR1IsDQo+ICsgICAgICAgLm9w
dHMgICAgICAgICAgICAgICAgICAgPSBFWFlOT1NfVUZTX09QVF9IQVNfQVBCX0NMS19DVFJMIHwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVYWU5PU19VRlNfT1BUX0JST0tF
Tl9BVVRPX0NMS19DVFJMIHwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVY
WU5PU19VRlNfT1BUX0JST0tFTl9SWF9TRUxfSURYLA0KSW4gd2hhdCB3YXkgb3B0cyBhcmUgZGlm
ZmVyZW50IGZyb20gcXVpcmtzPw0KDQoNClRoYW5rcywNCkF2cmkNCg==
