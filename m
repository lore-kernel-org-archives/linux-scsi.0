Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5D7C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A773217F4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Sr+UWl4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgABQi6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:38:58 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49373 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgABQi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 11:38:58 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Viswas.G@microchip.com designates 198.175.253.82 as permitted
  sender) identity=mailfrom; client-ip=198.175.253.82;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="Viswas.G@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Viswas.G@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: li+/X492dXpw2f7UgkjGkF3zz63DWpcbENt7svC0ZTRuXB6DJu9YaLll7UQHrHUuS0H2l++E/h
 W+IQpolATK4uvng3UmGL/Vwz9+ovdzfGF+Se4NFDdKyVW0iekW+cF5fkveULlEVPCSG2G7x5jM
 CUydnzayUF17TAJQdmtVK4W6k9B70b7f4ffCFSzKoxuStQrYmztsgRqnzFi34eCAgz89gWQDlP
 rj2U9CR3HnLGqy0/2Evlj/VldtgysEW2WSXiavUVC8GYMAuQ4boyYykLg2Q4p5eetiVvxW35F/
 KoM=
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="62031043"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jan 2020 09:38:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Jan 2020 09:38:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Jan 2020 09:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1miXIMZQ+ZULXV+dJHX/SWN1ZdNuMEiMXydgzV7LtsTGSj1vNDCKB0H6fZ++PbTHehojaEQA05E1z6hYd8eCtq9ifD+czq8QqBSpnfiLMJIGpVDUK91KUWOQK6sdjgIaGLGoKB9icVFi8j+tlONwIf5Fobukhs51BY0W16Tzo8BSvETsDa4QJ2s8cJqevlLDccNKel3RH0pSrXl1WBXBmCtct2c+E0QpoFxqZDp7QywVE7dxnV1IxtzOoU0HT/BuyZ0Bke6Mta5gxi3W6pBMNg7NLQvJql/zyhRyhmQ+gbwo62uaoKA0l6q7HpcKGt+On1lzFfxgELsICrQmqJRCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSjSWPUv5i8/uN9EcqiF2dqxTvBBE2thTkJWE+LByJM=;
 b=QyygzatTKUmZ7Hni6T7ypalAl2wnP4rXKWisWAk8h1hXzmxKr7BCejBXhRg32lgLGnlNfRtN78o+DlSxuurW+/SBPKUQHCCo+gxF75WGD4Ghqf95w9LEpg+avJy0gSJ9A+C+1Y9guK52NQoHRUZ3JM5rWGoqu6Vn29uWgvJaHyTpwf4CItLjpmEy8gma/Lwe3iIetiW7K6jkhXStWvKMZss/hNNW4X+wM0JprWAzAI7eUEjhVIuZdjug47BRp3AGxTzRiu7dZZA6uUKWQ7p6aPey+4+tOdaHMqCy3/LA/hlRieyUVuyHeTCpiy8udVRilRF312WyOsvt8kl9IsA8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSjSWPUv5i8/uN9EcqiF2dqxTvBBE2thTkJWE+LByJM=;
 b=Sr+UWl4c13d/AR1mDMIOmrakRQkw03dbML54PA8V63DmsaohRVFNABNXEClRr4EvWMfR8vcOCvHAdmulpbBgABmJNo9iZPXHNV/VNSmxgwExMfDKooz+ITMXEjFTviJabNlTbCy1woJwnwUthhgvoyBPAlmWNhNi4lzV3j93aKg=
Received: from BL0PR11MB2980.namprd11.prod.outlook.com (20.177.206.153) by
 BL0PR11MB3121.namprd11.prod.outlook.com (20.177.205.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Thu, 2 Jan 2020 16:38:55 +0000
Received: from BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89]) by BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89%5]) with mapi id 15.20.2602.010; Thu, 2 Jan 2020
 16:38:55 +0000
From:   <Viswas.G@microchip.com>
To:     <john.garry@huawei.com>, <jinpu.wang@cloud.ionos.com>,
        <Deepak.Ukey@microchip.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
Thread-Topic: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
Thread-Index: AQHVuhRe93hJCoUIGE+cn4qpB3OnCKfXVlyAgAAHEACAAEOUwA==
Date:   Thu, 2 Jan 2020 16:38:54 +0000
Message-ID: <BL0PR11MB29804B87E0768D41793E15A49D200@BL0PR11MB2980.namprd11.prod.outlook.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-7-deepak.ukey@microchip.com>
 <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
 <32f47ddd-72c5-7846-f0a7-cba3ad1e0c6b@huawei.com>
In-Reply-To: <32f47ddd-72c5-7846-f0a7-cba3ad1e0c6b@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.6.156.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05908928-173b-49bd-a1ac-08d78fa24207
x-ms-traffictypediagnostic: BL0PR11MB3121:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB3121AE463E589D0818A562C09D200@BL0PR11MB3121.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(376002)(346002)(39860400002)(199004)(189003)(13464003)(66946007)(55236004)(7416002)(7696005)(478600001)(110136005)(66476007)(8676002)(54906003)(81166006)(5660300002)(66446008)(64756008)(81156014)(66556008)(6636002)(6506007)(86362001)(76116006)(53546011)(33656002)(8936002)(2906002)(52536014)(186003)(71200400001)(55016002)(26005)(9686003)(316002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3121;H:BL0PR11MB2980.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5FyxJMj4mQG4kByc1LV/SiOzomeXFj7KnZMi0IgzdRtXvBfFMmV/Zt5F3Hmxx4qhxaORkNe7FcFNn0PFv0gnxfG2W94DQrI5d6KUKhr5l53wagtPjPUrqo6a3sZSVP9hxRPUwaXTF/av5krZH5BrcNX2P5K8Zrtkjs757ldwcdEE3fMsBR7oJbo0MfMZV7Jrjl8OhieLs0pIOBKrRj2EcpYukW/rb/T3aV9FligqqDA9YST2+USKCdcTxJYGB83BNmBcRrq6G/ANtQBM7HSFw2QqXeM57i8hXhRzX3KPn2wjV0qwRfNMimEY7TYIq+Ml+tQc1+/gjAvPw8Dz9IfCdz1EJ4FxRWP88KqfyT7UaJQ6/ZzmRw3Kd2g36MCniiH+gnhkoBRjGSTvP+LYTM0WibU30fMxpYBarPDo7C8UJKjQ/MHA0BBr7TQW9K2/eqEGblTkOWVjLAAOFIqoTw4i2ad6rO/BJK2s0whIpOU9hIvdAcZ4VkOOt8WgcepDS6+v
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05908928-173b-49bd-a1ac-08d78fa24207
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 16:38:54.9575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uzt7kMwM5C1rgv7+xii8bzZoA0OvjopwKDtK+DWSzN3zsKhPIEIJ4MTJ/nfV1TiFD2p0zcKQacPcctss2+Wp+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3121
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEpvaG4gR2FycnkuIFRoZSBpbnRlbnRpb24gaGVyZSBpcyB0byBnZXQgdGhlIHRvdGFs
IG51bWJlciBvZiBwaHlzIGZvciB0aGUgY29udHJvbGxlciB0aHJvdWdoIHN5c2ZzIGFuZCBpdCBp
cyB1c2VkIGJ5IHRoZSBtYW5hZ2VtZW50IHV0aWxpdHkgYXMgd2VsbC4gDQoNClJlZ2FyZHMsDQpW
aXN3YXMgRw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9obiBHYXJyeSA8
am9obi5nYXJyeUBodWF3ZWkuY29tPiANClNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDIsIDIwMjAg
NjowMyBQTQ0KVG86IEppbnB1IFdhbmcgPGppbnB1LndhbmdAY2xvdWQuaW9ub3MuY29tPjsgRGVl
cGFrIFVrZXkgLSBJMzExNzIgPERlZXBhay5Va2V5QG1pY3JvY2hpcC5jb20+DQpDYzogTGludXgg
U0NTSSBNYWlsaW5nbGlzdCA8bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc+OyBWYXNhbnRoYWxh
a3NobWkgVGhhcm1hcmFqYW4gLSBJMzA2NjQgPFZhc2FudGhhbGFrc2htaS5UaGFybWFyYWphbkBt
aWNyb2NoaXAuY29tPjsgVmlzd2FzIEcgLSBJMzA2NjcgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+
OyBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT47IE1hcnRpbiBLLiBQZXRl
cnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBkcGZAZ29vZ2xlLmNvbTsgeXV1emhl
bmdAZ29vZ2xlLmNvbTsgVmlrcmFtIEF1cmFka2FyIDxhdXJhZGthckBnb29nbGUuY29tPjsgdmlz
aGFraGF2Y0Bnb29nbGUuY29tOyBiamFzaG5hbmlAZ29vZ2xlLmNvbTsgUmFkaGEgUmFtYWNoYW5k
cmFuIDxyYWRoYUBnb29nbGUuY29tPjsgYWtzaGF0emVuQGdvb2dsZS5jb20NClN1YmplY3Q6IFJl
OiBbUEFUQ0ggMDYvMTJdIHBtODB4eCA6IHN5c2ZzIGF0dHJpYnV0ZSBmb3IgbnVtYmVyIG9mIHBo
eXMuDQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KDQpPbiAwMi8wMS8yMDIw
IDEyOjA3LCBKaW5wdSBXYW5nIHdyb3RlOg0KPiBPbiBUdWUsIERlYyAyNCwgMjAxOSBhdCA1OjQx
IEFNIERlZXBhayBVa2V5IDxtYWlsdG86ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6
DQo+Pg0KPj4gRnJvbTogVmlzd2FzIEcgPG1haWx0bzpWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0K
Pj4NCj4+IEFkZGVkIHN5c2ZzIGF0dHJpYnV0ZSB0byBzaG93IG51bWJlciBvZiBwaHlzLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IERlZXBhayBVa2V5IDxtYWlsdG86ZGVlcGFrLnVrZXlAbWljcm9j
aGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFZpc3dhcyBHIDxtYWlsdG86Vmlzd2FzLkdAbWlj
cm9jaGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFZpc2hha2hhIENoYW5uYXBhdHRhbiA8bWFp
bHRvOnZpc2hha2hhdmNAZ29vZ2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEJoYXZlc2ggSmFz
aG5hbmkgPG1haWx0bzpiamFzaG5hbmlAZ29vZ2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFJh
ZGhhIFJhbWFjaGFuZHJhbiA8bWFpbHRvOnJhZGhhQGdvb2dsZS5jb20+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBBa3NoYXQgSmFpbiA8bWFpbHRvOmFrc2hhdHplbkBnb29nbGUuY29tPg0KPj4gU2lnbmVk
LW9mZi1ieTogWXUgWmhlbmcgPG1haWx0bzp5dXV6aGVuZ0Bnb29nbGUuY29tPg0KPj4gLS0tDQo+
PiAgIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2N0bC5jIHwgMjAgKysrKysrKysrKysrKysr
KysrKysNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfY3RsLmMgDQo+PiBiL2RyaXZlcnMv
c2NzaS9wbTgwMDEvcG04MDAxX2N0bC5jDQo+PiBpbmRleCA2OTQ1OGIzMThhMjAuLjcwNGMwZGFh
NzkzNyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2N0bC5jDQo+
PiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9jdGwuYw0KPj4gQEAgLTg5LDYgKzg5
LDI1IEBAIHN0YXRpYyBzc2l6ZV90IGNvbnRyb2xsZXJfZmF0YWxfZXJyb3Jfc2hvdyhzdHJ1Y3Qg
ZGV2aWNlICpjZGV2LA0KPj4gICB9DQo+PiAgIHN0YXRpYyBERVZJQ0VfQVRUUl9STyhjb250cm9s
bGVyX2ZhdGFsX2Vycm9yKTsNCj4+DQo+PiArLyoqDQo+PiArICogcG04MDAxX2N0bF9udW1fcGh5
c19zaG93IC0gTnVtYmVyIG9mIHBoeXMNCj4+ICsgKiBAY2Rldjpwb2ludGVyIHRvIGVtYmVkZGVk
IGNsYXNzIGRldmljZQ0KPj4gKyAqIEBidWY6dGhlIGJ1ZmZlciByZXR1cm5lZA0KPj4gKyAqIEEg
c3lzZnMgJ3JlYWQtb25seScgc2hvc3QgYXR0cmlidXRlLg0KPj4gKyAqLw0KPj4gK3N0YXRpYyBz
c2l6ZV90IG51bV9waHlzX3Nob3coc3RydWN0IGRldmljZSAqY2RldiwNCj4+ICsgICAgICAgICAg
ICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQ0KPiBwbGVhc2Ug
dXNlIHBtODAwMV9jdGxfbnVtX3BoeXNfc2hvdyBhcyBmdW5jdGlvbiBuYW1lLCBzbyBpdCBmb2xs
b3dzIA0KPiBzYW1lIGNvbnZlcnNpb24gYXMgb3RoZXIgZnVuY3Rpb25zLg0KPiBCZXR0ZXIgYWxz
byByZW5hbWUgY29udHJvbGxlcl9mYXRhbF9lcnJvciB0b28uDQoNCklmIHlvdSBkb24ndCBtaW5k
IG1lIHNheWluZywgdGhpcyBpbmZvIGlzIGFscmVhZHkgYXZhaWxhYmxlIGluIHN5c2ZzIGZvciBh
bnkgbGlic2FzIG9yIGV2ZW4gU0FTIGhvc3QgKHVzaW5nIHNjc2lfdHJhbnNwb3J0X3Nhcy5jKSwg
bGlrZSB0aGlzOg0KDQpqb2huQHVidW50dTovc3lzL2NsYXNzL3Nhc19waHkkIGxzDQpwaHktMDow
ICAgICBwaHktMDowOjEyICBwaHktMDowOjE3ICBwaHktMDowOjIxICBwaHktMDowOjQgIHBoeS0w
OjA6OQ0KcGh5LTA6NQ0KcGh5LTA6MDowICAgcGh5LTA6MDoxMyAgcGh5LTA6MDoxOCAgcGh5LTA6
MDoyMiAgcGh5LTA6MDo1ICBwaHktMDoxDQpwaHktMDo2DQpwaHktMDowOjEgICBwaHktMDowOjE0
ICBwaHktMDowOjE5ICBwaHktMDowOjIzICBwaHktMDowOjYgIHBoeS0wOjINCnBoeS0wOjcNCnBo
eS0wOjA6MTAgIHBoeS0wOjA6MTUgIHBoeS0wOjA6MiAgIHBoeS0wOjA6MjQgIHBoeS0wOjA6NyAg
cGh5LTA6Mw0KcGh5LTA6MDoxMSAgcGh5LTA6MDoxNiAgcGh5LTA6MDoyMCAgcGh5LTA6MDozICAg
cGh5LTA6MDo4ICBwaHktMDo0DQoNCg0KQW55IHBoeS1YOlkgaXMgYSByb290IHBoeSwgYW5kIFgg
ZGVub3RlcyB0aGUgaG9zdCBpbmRleCBhbmQgWSBpcyB0aGUgcGh5IGluZGV4Lg0KDQo+DQo+IFRo
YW5rcw0KPj4gK3sNCj4+ICsgICAgICAgaW50IHJldDsNCj4+ICsgICAgICAgc3RydWN0IFNjc2lf
SG9zdCAqc2hvc3QgPSBjbGFzc190b19zaG9zdChjZGV2KTsNCj4+ICsgICAgICAgc3RydWN0IHNh
c19oYV9zdHJ1Y3QgKnNoYSA9IFNIT1NUX1RPX1NBU19IQShzaG9zdCk7DQo+PiArICAgICAgIHN0
cnVjdCBwbTgwMDFfaGJhX2luZm8gKnBtODAwMV9oYSA9IHNoYS0+bGxkZF9oYTsNCj4+ICsNCj4+
ICsgICAgICAgcmV0ID0gc3ByaW50ZihidWYsICIlZCIsIHBtODAwMV9oYS0+Y2hpcC0+bl9waHkp
Ow0KPj4gKyAgICAgICByZXR1cm4gcmV0Ow0KPj4gK30NCj4+ICtzdGF0aWMgREVWSUNFX0FUVFJf
Uk8obnVtX3BoeXMpOw0KPj4gKw0KPj4gICAvKioNCj4+ICAgICogcG04MDAxX2N0bF9md192ZXJz
aW9uX3Nob3cgLSBmaXJtd2FyZSB2ZXJzaW9uDQo+PiAgICAqIEBjZGV2OiBwb2ludGVyIHRvIGVt
YmVkZGVkIGNsYXNzIGRldmljZSBAQCAtODI1LDYgKzg0NCw3IEBAIA0KPj4gc3RhdGljIERFVklD
RV9BVFRSKHVwZGF0ZV9mdywgU19JUlVHT3xTX0lXVVNSfFNfSVdHUlAsDQo+PiAgIHN0cnVjdCBk
ZXZpY2VfYXR0cmlidXRlICpwbTgwMDFfaG9zdF9hdHRyc1tdID0gew0KPj4gICAgICAgICAgJmRl
dl9hdHRyX2ludGVyZmFjZV9yZXYsDQo+PiAgICAgICAgICAmZGV2X2F0dHJfY29udHJvbGxlcl9m
YXRhbF9lcnJvciwNCj4+ICsgICAgICAgJmRldl9hdHRyX251bV9waHlzLA0KPj4gICAgICAgICAg
JmRldl9hdHRyX2Z3X3ZlcnNpb24sDQo+PiAgICAgICAgICAmZGV2X2F0dHJfdXBkYXRlX2Z3LA0K
Pj4gICAgICAgICAgJmRldl9hdHRyX2FhcF9sb2csDQo+PiAtLQ0KPj4gMi4xNi4zDQo+Pg0KPiAu
DQo+DQoNCg==
