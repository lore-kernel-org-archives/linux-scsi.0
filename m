Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB8EC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A800B214AF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Kzc48mTY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgAQPuS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 10:50:18 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:2198 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAQPuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 10:50:17 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: KDIRmJHyH1X7eq4yHlV1lymoDWVTbdNxuCgZm9pfYVxM6h0M1v3yOE3mqpe/Z+wZ9s+ZR3a/WI
 zYJ6eb0XRFZ71aXkwDgD/XDDTL7RYjeZRMy2fOdZIiY6TAhBobmt+OnDKz9ps1RX/M3bQ0gFeg
 jRPuwJeee5yBbfg9XJcw4AtSLiZ0eAP/4FDIldcLr3pwjWgSac763ClEbVxn2EBGbnmlpFvQjW
 H+iQTQ4j1DNFmY+daerTZJD6+eSpiXg11K3i278Dne5ZHFAmwtli+Q2iCV7qBCqba0KF22Fmjt
 NT0=
X-IronPort-AV: E=Sophos;i="5.70,330,1574146800"; 
   d="scan'208";a="61148681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 08:50:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 17 Jan 2020 08:50:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 17 Jan 2020 08:50:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1P04BdbYtKGmRTeLClt/KW6U8wBRSF5/KmNLinLa6PxkrbPUyCATjoCqo4LalaXXtik74BR28wiVR32t4chqNmn9hMf4HLiAgOaaTeiFU7pijbRxasyKB+I5GydnqeqTZfHbQWET0FNOgKaWyMhSPzvowhdYRbpjmALrqINAVAqBppuuTRnqEhiI+wh56XTCXcSgzaL/APOGhrJjCriUNKTB60bzDHM7wsNqEOnY5sZwmIGNL1UJ6MnoOOKrrt0j19IuLdUPFAgl2d3NuvDbLv5JXEg2nIfKo8k5HJaD5yp5OFRp+kVpIAib/xR/xcTWYDoNyJOvYBwRVn9ws+10w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqGlmu5L2litf6hsk/FpdI2rO9IxuTczOX1jsPrtERc=;
 b=kDzLxPPJ7jkDecB1U5nxg+vS0cpNmIGrBeAPwgZY0ByoEJkTAfhShpiUXmMoEyho3kXMvoETrIxa2eXhjdx/v21m7aDgdW/6k1C8m5iRs42UCR4eIUjbe2w4X1szbzT/bg/XGZCbe1VfbB7WhPbQgRdsngX9nQ7dBWt8VeahzU+H4XZmcmsIFQjpOMSabIu9GSCQOu1FguQQkarZnzOu5tI47wX1wwQvqaUUq4lcKV8hUBPGi4xCshga5OhP8Df/eCbiFiU4j4pBPugC2/DsJO/7662iW4wlT3/vumjBROCNydsqpl+kseeF9wBakSCYG6QIaG/YrCMsM+4pXWfOOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqGlmu5L2litf6hsk/FpdI2rO9IxuTczOX1jsPrtERc=;
 b=Kzc48mTY+kIipdCS7Hv6aKpo6e9OuKUNUuVULAvmWNia/ChJEronOrXXXXQjuTYXki2PdueLA5Vvj7SA+fwM0foTqBX+Gw5b6yiCAks09HpIRkesrzp0tGiq4puH1U3xJebOpq/LbNYaCBKj4+2nTy905GVUshixRDBqEIj6aP8=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4190.namprd11.prod.outlook.com (20.179.151.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 17 Jan 2020 15:50:11 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2644.023; Fri, 17 Jan 2020
 15:50:11 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 01/13] pm80xx : Increase request sg length.
Thread-Topic: [PATCH V2 01/13] pm80xx : Increase request sg length.
Thread-Index: AQHVzQVH8+SeyE09DkicTPOofBNVaqfu5UaAgAAb2xA=
Date:   Fri, 17 Jan 2020 15:50:11 +0000
Message-ID: <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-2-deepak.ukey@microchip.com>
 <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
In-Reply-To: <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.111.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e083a993-9daf-4d91-4e35-08d79b64efbb
x-ms-traffictypediagnostic: MN2PR11MB4190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB419078A9D0912EA6089139DFEF310@MN2PR11MB4190.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(346002)(136003)(396003)(189003)(199004)(8936002)(26005)(478600001)(81166006)(8676002)(186003)(5660300002)(7696005)(76116006)(66556008)(66446008)(66946007)(64756008)(66476007)(86362001)(4326008)(54906003)(52536014)(7416002)(316002)(9686003)(55236004)(55016002)(33656002)(71200400001)(2906002)(81156014)(6506007)(53546011)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4190;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wUXEiJpmfhUPPIwAPevNjy4bpZj4alfihJyyk5pWbwlbq9snSQ47wQD4LYMEo0usRsLo4Yzz0bVDLnP+XEpSZL1mcEyxkOowCzxuTG/AJ3PB3JiNFoUjY4NipuZ8j86OKZ24D4RbYq0pemG57zR9/T8E2d0gw12etSBhX3RE0uuMqXE4f35pHUaBSlaAy7YVYGmc6315tFXLwEiJfgA/xDUzxH9KiN7q/GlKCncgkcojYzWG1bVKBjcEjQfdG8aIMAxpXum4EEbAaTvxJDEuLFqqfHTnoT16YP3JEOBBRhuvaWL7xyErI2nIfWG/2oVooxwc3QTtFekHa1c+Y+wK5epqmyotgjGcdJj7KnfF+sMNedUzea+Uyq6oxSxP+m8XUxeCJdOWimmBZ26nbvAJ6ZmqC4r/MXK7x/NQKxYR+QUNCWjeABCIjuFcVCbfY1Dz
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e083a993-9daf-4d91-4e35-08d79b64efbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 15:50:11.4950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FAYVxssxyIYX2b8oFr5d2S8xk6LPFjmvrQMxClpPV9+2ELAyyTNR/weq6mgtHI2Q4CuG4J8tMBpAaVR05FKe4QYx42KaMbzxn8ObHZadD0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4190
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCBKYW4gMTcsIDIwMjAgYXQgODoxMCBBTSBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlA
bWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+DQo+IEZyb206IFBldGVyIENoYW5nIDxkcGZAZ29vZ2xl
LmNvbT4NCj4NCj4gSW5jcmVhc2luZyB0aGUgcGVyLXJlcXVlc3Qgc2l6ZSBtYXhpbXVtIChtYXhf
c2VjdG9yc19rYikgcnVucyBpbnRvIHRoZSANCj4gcGVyLWRldmljZSBkbWEgc2NhdHRlciBnYXRo
ZXIgbGlzdCBsaW1pdCAobWF4X3NlZ21lbnRzKSBmb3IgdXNlcnMgb2YgDQo+IHRoZSBpbyB2ZWN0
b3Igc3lzdGVtIGNhbGxzIChlZywgcmVhZHYgYW5kIHdyaXRldikuIFRoaXMgaXMgYmVjYXVzZSB0
aGUgDQo+IGtlcm5lbCBjb21iaW5lcyBpbyB2ZWN0b3JzIGludG8gZG1hIHNlZ21lbnRzIHdoZW4g
cG9zc2libGUsIGJ1dCBpdCANCj4gZG9lc24ndCB3b3JrIGZvciBvdXIgdXNlciBiZWNhdXNlIHRo
ZSB2ZWN0b3JzIGluIHRoZSBidWZmZXIgY2FjaGUgZ2V0IA0KPiBzY3JhbWJsZWQuDQo+IFRoaXMg
Y2hhbmdlIGJ1bXBzIHRoZSBhZHZlcnRpc2VkIG1heCBzY2F0dGVyIGdhdGhlciBsZW5ndGggdG8g
NTI4IHRvIA0KPiBjb3ZlciAyTSB3LyB4ODYncyA0ayBwYWdlcyBhbmQgc29tZSBleHRyYSBmb3Ig
dGhlIHVzZXIgY2hlY2tzdW0uDQo+IEl0IHRyaW1zIHRoZSBzaXplIG9mIHNvbWUgb2YgdGhlIHRh
YmxlcyB3ZSBkb24ndCBjYXJlIGFib3V0IGFuZCANCj4gZXhwb3NlcyBhbGwgb2YgdGhlIGNvbW1h
bmQgc2xvdHMgdXBzdHJlYW0gdG8gdGhlIHNjc2kgbGF5ZXINCj4NCj4gU2lnbmVkLW9mZi1ieTog
UGV0ZXIgQ2hhbmcgPGRwZkBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEZWVwYWsgVWtl
eSA8ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogVmlzd2FzIEcg
PFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJhZGhhIFJhbWFjaGFu
ZHJhbiA8cmFkaGFAZ29vZ2xlLmNvbT4NCj4gUmVwb3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90
IDxsa3BAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2Rl
ZnMuaCB8IDUgKysrLS0gIA0KPiBkcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9pbml0LmMgfCAy
ICstDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkN
Cj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2RlZnMuaCANCj4g
Yi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9kZWZzLmgNCj4gaW5kZXggNDhlMDYyNGVjYzY4
Li4xYzdmMTVmZDY5Y2UgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAx
X2RlZnMuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9kZWZzLmgNCj4gQEAg
LTc1LDcgKzc1LDcgQEAgZW51bSBwb3J0X3R5cGUgew0KPiAgfTsNCj4NCj4gIC8qIGRyaXZlciBj
b21waWxlLXRpbWUgY29uZmlndXJhdGlvbiAqLw0KPiAtI2RlZmluZSAgICAgICAgUE04MDAxX01B
WF9DQ0IgICAgICAgICAgIDUxMiAgICAvKiBtYXggY2NicyBzdXBwb3J0ZWQgKi8NCj4gKyNkZWZp
bmUgICAgICAgIFBNODAwMV9NQVhfQ0NCICAgICAgICAgICAyNTYgICAgLyogbWF4IGNjYnMgc3Vw
cG9ydGVkICovDQpIaSBEZWVwYWNrLA0KDQpXaHkgZG8geW91IHJlZHVjZSBQTTgwMDFfTUFYX0ND
Qj8NCi0tLSBQTTgwMDEgZHJpdmVyIGhhcyBhIG1lbW9yeSBsaW1pdCBpbiB0aGUgbWFjaGluZS4g
SWYgd2UgaW5jcmVhc2UgdGhlIHNnIGxlbmd0aCwgd2UgbmVlZCB0byB0cmFkZS1vZmYgaXQgYnkg
ZGVjcmVhc2luZyBQTTgwMDFfTUFYX0NDQi4gUE04MDAxX01BWF9DQ0IgPSAyNTYgZG9lcyBub3Qg
aGF2ZSBhbnkgaW5mbHVlbmNlIG9uIG5vcm1hbCB1c2UuDQoNClRoZSBwYXRjaCBpdHNlbGYgbG9v
a3MgZmluZS4NCg==
