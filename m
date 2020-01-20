Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CBBC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 04:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32BD20661
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 04:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EmYpfahO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgATEUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 23:20:45 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:57489 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgATEUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 23:20:44 -0500
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
IronPort-SDR: 6d+ogDtxdug9VXWTPGtBl0AfleRuluZY9o4o959myftae6PS5I0AnNmANLRuCuVDilC+GS6jvl
 8N/7nNCMTLEcTgORiTTA6J/KNNe9/f8Q7uUiwCTWQvxFQtMJzJDYv2EE5jXwpSkEj8v65n+eJt
 fuHQ69FqusJ1Gxe0IIkD7okigee67FjW/Ava9pyatuHzxY4LA+bvW5vR7GsfVuUS4Hruyx9026
 GcD5R7GQMMEz9yCYrwMb5t1d9vOKgWwq40uMEjXR3en35nwfhX8B7crBeejgtt9hoL9oBUyvr7
 SuI=
X-IronPort-AV: E=Sophos;i="5.70,340,1574146800"; 
   d="scan'208";a="61308324"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2020 21:20:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Jan 2020 21:20:43 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Jan 2020 21:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnvEz5WNCVnTloSc6ccc1eQ5sez6MW+nIQOu+GrBBWzEDE9pvOHOus7H1cgIEVZSc4/02un99TI9XqFDmpoppOim/FVqzCPAKscJ5tTcjHKPWPMwZagxVOSD6BGspI1uZZpZD2PQsUFPQnaTnnzdyQzVv/bO9+MzAPcTmTPU4M4sCDgsLOZeiAFo+XTFckh1+ubEOtVxcFsvM/nPomNaVpaBnNEUz+C/0thMYVYNHDU5XffMackZlpLERAlQPhA6ZaavubkIJ4CljLbrtW89UEABo6Io9PEcqCPglFtG3J2r9Era+WqAkwhc3jbaVDhKi1TGhMtmhRAW5tRdyd0dpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs9P+f2rKrlWJLkdMfjSJhNR52cYbwL99rSKlV8SwwA=;
 b=IbgOfI7pqSbdK7n2BKHRLd5dqo0RtabNeEDj5172Xo5ul36ljB7vZ47UurL1oZBncdrRDLnMbYabX+wKOE8kmK784s1VNkPihXgKgkg1qEhe5iJBx4XQapwlBt0x8yklAH6h9gW7kkc1VG5bg/1bHLC1LFGL56yehOBPcl7MuT91S/GQDohTrz7f3PZs39GAZz71rZ+PJfOQyv4hJjO6OXgUUbbcFEHF6xysa7Lyp0f8i4xmd9a/FbhF5lDS5uHx5BlUUPRYzrycQ3Y3BkAvSHpeH1/oPFrncNpgiQYtl5ISnFmtAyXx+/4cc3mNY4NxIo7SKpzCGxg5UCYVCtKXCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs9P+f2rKrlWJLkdMfjSJhNR52cYbwL99rSKlV8SwwA=;
 b=EmYpfahOjEN9anN3Ld1SwdgiYHdQUZisEKaf59wNqt/ndDOa7odhXYizyYda4ZxXmnYmOYO29cs0gX8iVALfTeWzi9WI2P/oPnf1P6rCHegx8+mPMd/e0uOXs+Cra+lA+2ejwQ+kN0S+tSgpVUG8Wu+TXxfart1+xO3yAdSrDsc=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4270.namprd11.prod.outlook.com (52.135.37.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Mon, 20 Jan 2020 04:20:41 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2644.023; Mon, 20 Jan 2020
 04:20:41 +0000
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
Thread-Index: AQHVzQVH8+SeyE09DkicTPOofBNVaqfu5UaAgAAb2xCAAAFWAIAD9TvA
Date:   Mon, 20 Jan 2020 04:20:41 +0000
Message-ID: <MN2PR11MB3550731E829140B5EC3F0E93EF320@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-2-deepak.ukey@microchip.com>
 <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
 <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnk-Vc-dgv8j-OeKG=jhu6bU8qTPvGm+t5aNuvn1mT2QQ@mail.gmail.com>
In-Reply-To: <CAMGffEnk-Vc-dgv8j-OeKG=jhu6bU8qTPvGm+t5aNuvn1mT2QQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08999dcd-d739-4ec6-2707-08d79d601ca3
x-ms-traffictypediagnostic: MN2PR11MB4270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4270E441D2DEFF5CD2C4CA23EF320@MN2PR11MB4270.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(39860400002)(376002)(366004)(189003)(199004)(66446008)(9686003)(26005)(7416002)(64756008)(76116006)(66556008)(66476007)(66946007)(186003)(5660300002)(86362001)(52536014)(71200400001)(33656002)(2906002)(54906003)(316002)(55016002)(6916009)(7696005)(4326008)(478600001)(53546011)(6506007)(81156014)(8936002)(81166006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4270;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bOFjoY3kVKC1dBFUuCjKojk4fZ+Qu56Ym1JJYmCa0VwEAsnk3N/9DqveFScsfNSf0ZCEddnLHCOAcTip262aVHJ1IAVsVIcMntIfbh05I5P2Ch+iynmhoGa6BIxhHUyWo3n5pDiw3GV2ONzhXrlVV7BFOivPiwOYyRdOrtWfiMqZf34pZABMZX5tiKLYZTb2NR0+vGJZzkebjSUpmMl3vR67XlVrz8u1naep+rtsdI/Usi9UNFzMQDBFO4VUCWpaZDi1NTkFJMPbrNXOCCpjdl0dR3oFAYN8mQahCNiSdXcuu2lDDFAd2QErB36e3vR6PSyQdrQeBuvmzwQdyLtGkfCFl4gr5dglfF55gydnYRfSStdpsIalAq5nPg/W38A4xJ6rc1btATcTwsDXiodv7GrDooF4U8Uh4N+FFej/xhVwxSyLKFwp1E5LQsws3Pqo
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08999dcd-d739-4ec6-2707-08d79d601ca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 04:20:41.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yKogOSs96w1FR6cMoF/OUn9JIM79mQbKiJhF3gOxsGDLZuvRpWUhX50Z5AYrVPLZyey/+uy1QXKUSdcZ0EGmhBL+fZKU2U4tVeAZGfnwoAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4270
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gRnJpLCBKYW4gMTcsIDIw
MjAgYXQgNDo1MCBQTSA8RGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+DQo+IE9u
IEZyaSwgSmFuIDE3LCAyMDIwIGF0IDg6MTAgQU0gRGVlcGFrIFVrZXkgPGRlZXBhay51a2V5QG1p
Y3JvY2hpcC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogUGV0ZXIgQ2hhbmcgPGRwZkBnb29n
bGUuY29tPg0KPiA+DQo+ID4gSW5jcmVhc2luZyB0aGUgcGVyLXJlcXVlc3Qgc2l6ZSBtYXhpbXVt
IChtYXhfc2VjdG9yc19rYikgcnVucyBpbnRvIA0KPiA+IHRoZSBwZXItZGV2aWNlIGRtYSBzY2F0
dGVyIGdhdGhlciBsaXN0IGxpbWl0IChtYXhfc2VnbWVudHMpIGZvciANCj4gPiB1c2VycyBvZiB0
aGUgaW8gdmVjdG9yIHN5c3RlbSBjYWxscyAoZWcsIHJlYWR2IGFuZCB3cml0ZXYpLiBUaGlzIGlz
IA0KPiA+IGJlY2F1c2UgdGhlIGtlcm5lbCBjb21iaW5lcyBpbyB2ZWN0b3JzIGludG8gZG1hIHNl
Z21lbnRzIHdoZW4gDQo+ID4gcG9zc2libGUsIGJ1dCBpdCBkb2Vzbid0IHdvcmsgZm9yIG91ciB1
c2VyIGJlY2F1c2UgdGhlIHZlY3RvcnMgaW4gDQo+ID4gdGhlIGJ1ZmZlciBjYWNoZSBnZXQgc2Ny
YW1ibGVkLg0KPiA+IFRoaXMgY2hhbmdlIGJ1bXBzIHRoZSBhZHZlcnRpc2VkIG1heCBzY2F0dGVy
IGdhdGhlciBsZW5ndGggdG8gNTI4IHRvIA0KPiA+IGNvdmVyIDJNIHcvIHg4NidzIDRrIHBhZ2Vz
IGFuZCBzb21lIGV4dHJhIGZvciB0aGUgdXNlciBjaGVja3N1bS4NCj4gPiBJdCB0cmltcyB0aGUg
c2l6ZSBvZiBzb21lIG9mIHRoZSB0YWJsZXMgd2UgZG9uJ3QgY2FyZSBhYm91dCBhbmQgDQo+ID4g
ZXhwb3NlcyBhbGwgb2YgdGhlIGNvbW1hbmQgc2xvdHMgdXBzdHJlYW0gdG8gdGhlIHNjc2kgbGF5
ZXINCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBldGVyIENoYW5nIDxkcGZAZ29vZ2xlLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXN3YXMgRyA8Vmlzd2FzLkdAbWljcm9jaGlwLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBSYWRoYSBSYW1hY2hhbmRyYW4gPHJhZGhhQGdvb2dsZS5jb20+
DQo+ID4gUmVwb3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9kZWZzLmggfCA1ICsrKy0tIA0K
PiA+IGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2luaXQuYyB8IDIgKy0NCj4gPiAgMiBmaWxl
cyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfZGVmcy5oDQo+ID4gYi9kcml2ZXJz
L3Njc2kvcG04MDAxL3BtODAwMV9kZWZzLmgNCj4gPiBpbmRleCA0OGUwNjI0ZWNjNjguLjFjN2Yx
NWZkNjljZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9kZWZz
LmgNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9kZWZzLmgNCj4gPiBAQCAt
NzUsNyArNzUsNyBAQCBlbnVtIHBvcnRfdHlwZSB7DQo+ID4gIH07DQo+ID4NCj4gPiAgLyogZHJp
dmVyIGNvbXBpbGUtdGltZSBjb25maWd1cmF0aW9uICovDQo+ID4gLSNkZWZpbmUgICAgICAgIFBN
ODAwMV9NQVhfQ0NCICAgICAgICAgICA1MTIgICAgLyogbWF4IGNjYnMgc3VwcG9ydGVkICovDQo+
ID4gKyNkZWZpbmUgICAgICAgIFBNODAwMV9NQVhfQ0NCICAgICAgICAgICAyNTYgICAgLyogbWF4
IGNjYnMgc3VwcG9ydGVkICovDQo+IEhpIERlZXBhY2ssDQo+DQo+IFdoeSBkbyB5b3UgcmVkdWNl
IFBNODAwMV9NQVhfQ0NCPw0KPiAtLS0gUE04MDAxIGRyaXZlciBoYXMgYSBtZW1vcnkgbGltaXQg
aW4gdGhlIG1hY2hpbmUuDQp3aGljaCBsaW1pdCwgZG8geW91IHNlZSBhbGxvY2F0aW9uIGZhaWx1
cmUgZnJvbSBrZXJuZWw/DQotLSBJIHRoaW5rIGl0IGRlcGVuZHMgb24gbWFjaGluZSdzIGNhcGFi
aWxpdHkuIEZvciBvdXIgbWFjaGluZXMsIFBNODAwMV9NQVhfQ0NCID0gNTEyIGNhdXNlZCBrZXJu
ZWwgaW5zdGFsbGF0aW9uIGZhaWx1cmUuIEkgc2F3IGl0IHdoZW4gSSB3YXMgZGVidWdnaW5nIG5j
cSBmZWF0dXJlDQpUaGFua3MNCg==
