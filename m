Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4EDC33CB2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 09:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48022070E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 09:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="t2Gmfb1E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgA2JCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:02:43 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:43565 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2JCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2020 04:02:42 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 6CZEn7R64D4dmMNVtP4jvn5q2a7Kd5HR/xMGFGsH2sQkqxx8hIc0g1cQB7PPnVEUIDRiu8v6lb
 CaJCQjz7286zI5mbOzW7jBcNiWJmxy7TClQgy1Ro+Xouw06bapgQm9az0dozudk+7fEYzUxFzD
 LyuOuAoBMJShgYv1BdorH0E6Qo4laeWuunYA8VVmw5RMyCy95cLK3crUrVpCUM1/bSi+H4DoqV
 PmpfbExyeG71PHKffoQSWucQc2JKdYOklSI6tuU52j2Yd6rBk6DaZAPufr18asIa27dsui2gAn
 uj4=
X-IronPort-AV: E=Sophos;i="5.70,377,1574146800"; 
   d="scan'208";a="64078903"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jan 2020 02:02:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 29 Jan 2020 02:02:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 29 Jan 2020 02:02:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMc9mbDiN4qH68sfwAcr+w6L/dSplZqwlcMgwik1tWQJ+L+NpbxIaTkfdWJk4ZwGS62SQ/J4OaffgV+vI1UATXLnYnlZvipWqdmYJxuhxEVRjsmXQ4qYn5rTKb+tq7RnpXYQDK1LDePbMnMOyZHA9A0ZGeHE7NKqiVd6/Rx40rGI00yUwCUq8o9NU/P4iVg7OFUq0ehIgfEZbfA4/H09dTSd0yMloX9bgGho2bdbdAMmgqzMgwX/XK3bTiEkrjUPl4buWt25s9fYR3Pni80CyFapiwnxei9HPhs/VrpoQ+yGkKi38Q/royKlzYn4q3dApVUmZ5M9oNnu4es2JoQJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrTB7GJwKwjf8IKqDrf8YdY9Xylp1brc+BgLB0v27hA=;
 b=EWQf7T77CkteSABjdNU3oczrDQL9kXp4f7cmrjkb7xr9umKPEjUFp24ktts0+255f/wrBjR77ctqA5tyMh/8Cl6ggwn8SyVQ+YawEHq0lcEOuGEYFSxpB+93ujkDnEC8UJtoeuWa5Z9jTt8VfAqby97JafpzXDz0Cf9ag09+ltgXY0vGZFFVDAIHTJRvOxfmzdN4AaG+BLivLa1y3VaVXW9baQjiiFtPuiPGNPQU4B/Kv0L+SwZqAXr5HE5glyhboU+vhDwTmEM23gkRUhOYNV5r1WkmdnOd35lGBX52GWYuySDx9mE6C5sYuXEbZRVAQalfANvFpRtL2BRIqy5q1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrTB7GJwKwjf8IKqDrf8YdY9Xylp1brc+BgLB0v27hA=;
 b=t2Gmfb1EGhOODTKASrPJ42PqbmlYkJWCK8RY18jxROWHUBjhVFqAL0BdWdLbIo8n2WIXZ1gA5o2HmqsteeuPGY0E1hle/X5j1Q09Pukji4yOez4Ilmg3h5ssJlFU5JJL/8ZJ/DHgbvW9ty3c/nHuy30ceI8m8RdSIdPU1BfoD4A=
Received: from BYAPR11MB3543.namprd11.prod.outlook.com (20.178.239.220) by
 BYAPR11MB3270.namprd11.prod.outlook.com (20.177.185.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Wed, 29 Jan 2020 09:02:39 +0000
Received: from BYAPR11MB3543.namprd11.prod.outlook.com
 ([fe80::39d7:833:1866:759f]) by BYAPR11MB3543.namprd11.prod.outlook.com
 ([fe80::39d7:833:1866:759f%6]) with mapi id 15.20.2665.026; Wed, 29 Jan 2020
 09:02:39 +0000
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
Thread-Index: AQHVzQVH8+SeyE09DkicTPOofBNVaqfu5UaAgAAb2xCAAAFWAIAD9TvAgABK1QCADijc4A==
Date:   Wed, 29 Jan 2020 09:02:38 +0000
Message-ID: <BYAPR11MB35436A58FD707DCBA021BD3CEF050@BYAPR11MB3543.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-2-deepak.ukey@microchip.com>
 <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
 <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnk-Vc-dgv8j-OeKG=jhu6bU8qTPvGm+t5aNuvn1mT2QQ@mail.gmail.com>
 <MN2PR11MB3550731E829140B5EC3F0E93EF320@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnF-ZUz95kYOqZU5kfmRY8oBZnfvi0=+G9PNA032+x_oA@mail.gmail.com>
In-Reply-To: <CAMGffEnF-ZUz95kYOqZU5kfmRY8oBZnfvi0=+G9PNA032+x_oA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e817cbd-9f9d-4acd-598c-08d7a499fdbf
x-ms-traffictypediagnostic: BYAPR11MB3270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB32700E89272B55A7A9CA2806EF050@BYAPR11MB3270.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(53546011)(186003)(6506007)(33656002)(52536014)(26005)(6916009)(54906003)(316002)(71200400001)(2906002)(7696005)(86362001)(8676002)(81166006)(8936002)(81156014)(7416002)(64756008)(55016002)(4326008)(76116006)(478600001)(5660300002)(66476007)(9686003)(66446008)(66946007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3270;H:BYAPR11MB3543.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zVp4df5+SQhvb2EylKeqkOpFNypDl/eRvKC5lXpv/5dJj/h8Xz/JM8HGYNQXNKPt4KxAt7bKoeZk9UXzmoE0zf21feJbF2YpEavxLWnx88TcQJAXSdSewZFRrdoVdcf+VtM8D7RERLWZUPHwY4gbBylaYIBbZYpu4D59hMS1edk0N/3iR49IrNdilO7byYKTZAOe8JFxkS7ITx4ESrSBXZ6gjhntT7tIC9EqunqC45yIm+Nf1ihO3A7M9v4cT1IXSb6bOMPTIVscZ+NmT8BTykpupcaLB5xc77DUU+HZ5/jJzPY/QWcfVjsQqi801zKZKhbXrRV1yvEnQKTAZNNJjRSIdcrb6e3CaVWpedr15S7D43sZd90fr/OLNtMExq1OXjbmoTg12djVjyP2AAZtwThGI2LzSOgpcH29mv4JuL3ssB9SfRG3mCHSna9f4Pa
x-ms-exchange-antispam-messagedata: xuToeVKjJkTaF3EWKDIHcdxHMsxvXgTlHczT0z7NloAuGUf9tvx1QFSFDMvtPyMMs1FIRu4IqkOChM/MqOxwGmmBlC0SuZZyPCnddU49Fmh+11s2X70UieRaCJBHUmjIDR2369QVyya0LjvDNUZ7fg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e817cbd-9f9d-4acd-598c-08d7a499fdbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 09:02:38.8652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wPG78GL+4s7G6LXsrNvasP6thFUIl3XYq3DNwJBr4qg3Dbao6nmr9G7fK9Yaf8fmDHRQlg2hAoM8vHaNfmIAfR5qNbq6z+NKSBrb36aQFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3270
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gTW9uLCBKYW4gMjAsIDIw
MjAgYXQgNToyMCBBTSA8RGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+DQo+DQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGtub3cgDQo+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gT24gRnJpLCBKYW4g
MTcsIDIwMjAgYXQgNDo1MCBQTSA8RGVlcGFrLlVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiBPbiBGcmksIEphbiAxNywgMjAyMCBhdCA4OjEwIEFNIERlZXBhayBVa2V5IDxkZWVw
YWsudWtleUBtaWNyb2NoaXAuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBGcm9tOiBQZXRlciBD
aGFuZyA8ZHBmQGdvb2dsZS5jb20+DQo+ID4gPg0KPiA+ID4gSW5jcmVhc2luZyB0aGUgcGVyLXJl
cXVlc3Qgc2l6ZSBtYXhpbXVtIChtYXhfc2VjdG9yc19rYikgcnVucyBpbnRvIA0KPiA+ID4gdGhl
IHBlci1kZXZpY2UgZG1hIHNjYXR0ZXIgZ2F0aGVyIGxpc3QgbGltaXQgKG1heF9zZWdtZW50cykg
Zm9yIA0KPiA+ID4gdXNlcnMgb2YgdGhlIGlvIHZlY3RvciBzeXN0ZW0gY2FsbHMgKGVnLCByZWFk
diBhbmQgd3JpdGV2KS4gVGhpcyANCj4gPiA+IGlzIGJlY2F1c2UgdGhlIGtlcm5lbCBjb21iaW5l
cyBpbyB2ZWN0b3JzIGludG8gZG1hIHNlZ21lbnRzIHdoZW4gDQo+ID4gPiBwb3NzaWJsZSwgYnV0
IGl0IGRvZXNuJ3Qgd29yayBmb3Igb3VyIHVzZXIgYmVjYXVzZSB0aGUgdmVjdG9ycyBpbiANCj4g
PiA+IHRoZSBidWZmZXIgY2FjaGUgZ2V0IHNjcmFtYmxlZC4NCj4gPiA+IFRoaXMgY2hhbmdlIGJ1
bXBzIHRoZSBhZHZlcnRpc2VkIG1heCBzY2F0dGVyIGdhdGhlciBsZW5ndGggdG8gNTI4IA0KPiA+
ID4gdG8gY292ZXIgMk0gdy8geDg2J3MgNGsgcGFnZXMgYW5kIHNvbWUgZXh0cmEgZm9yIHRoZSB1
c2VyIGNoZWNrc3VtLg0KPiA+ID4gSXQgdHJpbXMgdGhlIHNpemUgb2Ygc29tZSBvZiB0aGUgdGFi
bGVzIHdlIGRvbid0IGNhcmUgYWJvdXQgYW5kIA0KPiA+ID4gZXhwb3NlcyBhbGwgb2YgdGhlIGNv
bW1hbmQgc2xvdHMgdXBzdHJlYW0gdG8gdGhlIHNjc2kgbGF5ZXINCj4gPiA+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBQZXRlciBDaGFuZyA8ZHBmQGdvb2dsZS5jb20+DQo+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4NCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogUmFkaGEgUmFtYWNoYW5kcmFuIDxyYWRoYUBnb29nbGUuY29tPg0KPiA+ID4gUmVw
b3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiA+ID4gLS0tDQo+
ID4gPiAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfZGVmcy5oIHwgNSArKystLSANCj4gPiA+
IGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2luaXQuYyB8IDIgKy0NCj4gPiA+ICAyIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPiA+DQo+ID4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfZGVmcy5oDQo+ID4gPiBiL2Ry
aXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2RlZnMuaA0KPiA+ID4gaW5kZXggNDhlMDYyNGVjYzY4
Li4xYzdmMTVmZDY5Y2UgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG04MDAxL3Bt
ODAwMV9kZWZzLmgNCj4gPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2RlZnMu
aA0KPiA+ID4gQEAgLTc1LDcgKzc1LDcgQEAgZW51bSBwb3J0X3R5cGUgeyAgfTsNCj4gPiA+DQo+
ID4gPiAgLyogZHJpdmVyIGNvbXBpbGUtdGltZSBjb25maWd1cmF0aW9uICovDQo+ID4gPiAtI2Rl
ZmluZSAgICAgICAgUE04MDAxX01BWF9DQ0IgICAgICAgICAgIDUxMiAgICAvKiBtYXggY2NicyBz
dXBwb3J0ZWQgKi8NCj4gPiA+ICsjZGVmaW5lICAgICAgICBQTTgwMDFfTUFYX0NDQiAgICAgICAg
ICAgMjU2ICAgIC8qIG1heCBjY2JzIHN1cHBvcnRlZCAqLw0KPiA+IEhpIERlZXBhY2ssDQo+ID4N
Cj4gPiBXaHkgZG8geW91IHJlZHVjZSBQTTgwMDFfTUFYX0NDQj8NCj4gPiAtLS0gUE04MDAxIGRy
aXZlciBoYXMgYSBtZW1vcnkgbGltaXQgaW4gdGhlIG1hY2hpbmUuDQo+IHdoaWNoIGxpbWl0LCBk
byB5b3Ugc2VlIGFsbG9jYXRpb24gZmFpbHVyZSBmcm9tIGtlcm5lbD8NCj4gLS0gSSB0aGluayBp
dCBkZXBlbmRzIG9uIG1hY2hpbmUncyBjYXBhYmlsaXR5LiBGb3Igb3VyIG1hY2hpbmVzLCANCj4g
UE04MDAxX01BWF9DQ0IgPSA1MTIgY2F1c2VkIGtlcm5lbCBpbnN0YWxsYXRpb24gZmFpbHVyZS4g
SSBzYXcgaXQgd2hlbiANCj4gSSB3YXMgZGVidWdnaW5nIG5jcSBmZWF0dXJlIFRoYW5rcw0KT2ss
IHdvdWxkIGJlIGhlbHBmdWwgdG8gcHV0IHRoaXMgaW5mbyB0byBjb21taXQgbWVzc2FnZS4NCj4g
VGhhbmtzLiBJIHdpbGwgYWRkIHRoaXMgaW4gdmVyc2lvbiAzIG9mIHRoZSBwYXRjaGVzdC4NCg0K
VGhhbmtzDQo=
