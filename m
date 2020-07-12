Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA21AC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 10:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35B920725
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 10:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hlSHTw0u";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KM7Rlj4Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgGLKFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 06:05:02 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:32851 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbgGLKFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 06:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594548300; x=1626084300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9Ntm64vEMrvKnZ7GIwx2zeVmZX0U46qOkaVDnBUJpF0=;
  b=hlSHTw0u9pS8xcBvroE3rWC7wvGl+BjsHZrPb+9qbkxFPYI3OXmWN1sK
   Uw9wfw58Hv7O2T+B+rnC6ecEjJWyvJOwNMsLmgS6vo2aHU12ID5usyi2h
   H/l8Y5OOnpn1DUmpySHTHLowfYeF6tkiUqrI7qMkVFLKVa7HvMXBeLn4W
   AFTvAgRWbNQ3NWCiOZ1o5aWj/4ggbq2BnY73xy0NjYED2CK3x4GOOAx8g
   5/VU2UayUWzIopBt21s+8jGOtXu+0wG5FMzKb6ucO/nqSGWXfW4eDSvmc
   qyhYhqUcBYtJkbi2crAjhjNrt0L7k0oL/yMxtW6PRzD0uohomNI4Atzyh
   w==;
IronPort-SDR: rHbBBZxtZl+VJ/Rs5JRBKii4Q1Oqu2pugHTsoDxxUhduIY3RbH9Cl9L32HF4xmQr8Oh9AIIsuQ
 Ro0D+oqyDQsVopc1FsH5YM7OjERcTLqOcIhyrqGY06Qm/VtTAkA1HY2X2LeQKJEKQYyE/DKA1E
 m+losNwpqoWrt/jdQr+Bi9cp1U6dI/qoHhJtHrEfpYLi5yoKvv4hQHlW36ppRQhjo8jSoIkhmm
 X1jKRZU+KoWvY0jNICiKG+1qhFayRqWIN0fuBvZ7MFfotLiqTpnWpyKl+S1AMskVqgOQ3jkoza
 Xtw=
X-IronPort-AV: E=Sophos;i="5.75,343,1589212800"; 
   d="scan'208";a="251492453"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 18:04:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIZyO7DwR1vHwO8DHzBclBllg+GFnQmE3GkcDcHLh20Y6SsNzA8IY7k1Im6NJXEaelKGOFZyPwKlLecFBum6jyj7UmKSRskigXNwq9FyDsv5icsVr3WUzFQ80lrlWlIU7Ltf8w7ALDqrlRy37KFLKV8IU7oUaGzviJwUiyIogLwm3eZ3ueBxODdcQnjPTFnqHZDRWfjuaX1PBcJcj7Y+z1s5cHyctM54T+9+sijhYiPlzST614kk9pvxXUBV0p00m6YsQIsQ26o2lrv3dM8CRwZ8JVygYfLsgwhHjG9S4hN/jCs33w/IERjfKnqeHcYwqReDjMhhdS5Nj3AG9G7Fyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ntm64vEMrvKnZ7GIwx2zeVmZX0U46qOkaVDnBUJpF0=;
 b=RprVBDDWHVrMOkVYC5f8m2e72VpCf64Zg+3VqFP7xTJvGm5WjCYAfnrJZm2f+AfYa6ItjKtC0q1stkwrwQfRpN8KYS9ZIheCkltvhwXU7lRD90SzbfHjSeVFdk2TMgswI/kf4AQsyPFVS+TgHsOoCqfC3XigfCCEj8LBBhz48RGgoQRAFfqMpmpmQBAtzTmdcu9wHnmQeacQgIegpHyT129Oeq5Owg+WMTq5sXnHTbYQY3G8rX67ikw9z3/ztarv8VUbGHGMH7xULGdhKDD6RltTcSLIvgXGH3nRU84zJ97yh4NO8FpkbaqrTFSUGprfyHjeOBeR8/rJySKmV332yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ntm64vEMrvKnZ7GIwx2zeVmZX0U46qOkaVDnBUJpF0=;
 b=KM7Rlj4YZ3l4bROBw8PTdmEVrrz82nCwa4ztQkgln3AqExYuVHtzreQaXUnfs7n9aD19JeOB6VDoDYD+MtgcJRDeJGllqhzTpN5DiviToHSknWvdGDUch0ompMGy+ln1HlCQXVb7/abrOFX5bAavlZ3qvZ4WsQErEz5YUMXd3IY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4717.namprd04.prod.outlook.com (2603:10b6:805:a8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 10:04:55 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 10:04:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt
 notification
Thread-Topic: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Index: AQHWU5heDqJFApuOo0yQOIjuO+/O36j+4j7ggARNXQCAAJBVkA==
Date:   Sun, 12 Jul 2020 10:04:55 +0000
Message-ID: <SN6PR04MB4640F34CAA25B3CB58F94CABFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
         <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1594517160.10600.33.camel@mtkswgap22>
In-Reply-To: <1594517160.10600.33.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 124bccec-cde0-41a4-dfb6-08d8264b06f4
x-ms-traffictypediagnostic: SN6PR04MB4717:
x-microsoft-antispam-prvs: <SN6PR04MB4717D53668807766932832C7FC630@SN6PR04MB4717.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XZ8c0DBZBnsCpvapi5aKn7rPwA5yD3HuCLMMREkynrDw3VNZjmI6XebI3RzLqhFJmgZ15aDkfPQmUtTUC2rJhOEGK4F+aZThUkwijz2Ts06v81zZClREqlFwAWP7b9z6Qjd5WZGRRI25O+pXc+Bs5GxJT+IFQ0Regvz1BFbHkq2MXTs9JU221y1giRJhKc/H5Dv0LX6f9wD9NqMwYWdi+pxbxEqKzwQZYzfqoYbQeRWL+cs8uGs40M9qYGb02vEa/4PilqQMsL5Lqa30Zouey5syD3Y4j/+AALprQTuOzdC2ToAVyzq3ceSzoiAS8o1W9YPz2kz8R9ViLq6Xq9YKVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(9686003)(8676002)(55016002)(86362001)(52536014)(316002)(64756008)(76116006)(66946007)(26005)(66556008)(15650500001)(5660300002)(66446008)(66476007)(8936002)(7416002)(186003)(2906002)(33656002)(83380400001)(6916009)(478600001)(4326008)(71200400001)(6506007)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eS+XGAadc61nNakJodjuY1dhci+FRw51RdiIeBtfamvs9rgqT3Kl0zH1vt4zCQSeGc25RNHMpZ5YZ3XdGiqFfzt/C8IuVsmCIdqjKCaRUnklJhtUTfh0Ggs+wNCt9uRjDyAXLsRCizRZVM8j9b29o5C6AReTfNS4HTNeTjJ465eOLfiCE4T58G4D6EPlbZiNw95JPZMxbh3XQR7w0PAGAVLepqFZVBk3H16wzDYZWExaPhfWMDVkjWFMECF+YeG1VW9eQNyn2kavg1SX4wdndQnuXSdCS9axtFAYkRh/B/WJMcWEbY5bTFH18yssKop81KJHVrKkJjFTnypis6GQnL6mGqtOXg7w4wUFcpAbuWjVjaK0jd5kOqrvN3AGsJ0Bkr/1ffuWEHnHqdJgqdESceZvAbETGW/b39fwQjYhEB12VbxDvVJTKvPM4iKvQ7w3u8+SSkAvjyrWDgUU1liw7NLazD4uCxdrLUyiC3GM7ps=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124bccec-cde0-41a4-dfb6-08d8264b06f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2020 10:04:55.2130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y2jBa4PViyhRO2qUgV9IxSZ4Xkibqqxd1L8H06tu/vYwLr6yqhhy9LxbD75J7ZpMSzpv68grM4A9/RjnoHSsag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4717
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gDQo+IEhpIEF2cmksDQo+IA0KPiBPbiBUaHUsIDIwMjAtMDctMDkgYXQgMDg6MzEgKzAw
MDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ID4NCj4gPiA+IElmIHNvbWVob3cgbm8gaW50ZXJy
dXB0IG5vdGlmaWNhdGlvbiBpcyByYWlzZWQgZm9yIGEgY29tcGxldGVkIHJlcXVlc3QNCj4gPiA+
IGFuZCBpdHMgZG9vcmJlbGwgYml0IGlzIGNsZWFyZWQgYnkgaG9zdCwgVUZTIGRyaXZlciBuZWVk
cyB0byBjbGVhbnVwDQo+ID4gPiBpdHMgb3V0c3RhbmRpbmcgYml0IGluIHVmc2hjZF9hYm9ydCgp
Lg0KPiA+IFRoZW9yZXRpY2FsbHksIHRoaXMgY2FzZSBpcyBhbHJlYWR5IGFjY291bnRlZCBmb3Ig
LQ0KPiA+IFNlZSBsaW5lIDY0MDc6IGEgcHJvcGVyIGVycm9yIGlzIGlzc3VlZCBhbmQgZXZlbnR1
YWxseSBvdXRzdGFuZGluZyByZXEgaXMNCj4gY2xlYXJlZC4NCj4gPg0KPiA+IENhbiB5b3UgZ28g
b3ZlciB0aGUgc2NlbmFyaW8geW91IGFyZSBhdHRlbmRpbmcgbGluZSBieSBsaW5lLA0KPiA+IEFu
ZCBleHBsYWluIHdoeSB1ZnNoY2RfYWJvcnQgZG9lcyBub3QgYWNjb3VudCBmb3IgaXQ/DQo+IA0K
PiBTdXJlLg0KPiANCj4gSWYgYSByZXF1ZXN0IHVzaW5nIHRhZyBOIGlzIGNvbXBsZXRlZCBieSBV
RlMgZGV2aWNlIHdpdGhvdXQgaW50ZXJydXB0DQo+IG5vdGlmaWNhdGlvbiB0aWxsIHRpbWVvdXQg
aGFwcGVucywgdWZzaGNkX2Fib3J0KCkgd2lsbCBiZSBpbnZva2VkLg0KPiANCj4gU2luY2UgcmVx
dWVzdCBjb21wbGV0aW9uIGZsb3cgaXMgbm90IGV4ZWN1dGVkLCBjdXJyZW50IHN0YXR1cyBtYXkg
YmUNCj4gDQo+IC0gVGFnIE4gaW4gaGJhLT5vdXRzdGFuZGluZ19yZXFzIGlzIHNldA0KPiAtIFRh
ZyBOIGluIGRvb3JiZWxsIHJlZ2lzdGVyIGlzIG5vdCBzZXQNCj4gDQo+IEluIHRoaXMgY2FzZSwg
dWZzaGNkX2Fib3J0KCkgZmxvdyB3b3VsZCBiZQ0KPiANCj4gLSBUaGlzIGxvZyBpcyBwcmludGVk
OiAidWZzaGNkX2Fib3J0OiBjbWQgd2FzIGNvbXBsZXRlZCwgYnV0IHdpdGhvdXQgYQ0KPiBub3Rp
ZnlpbmcgaW50ciwgdGFnID0gTiINCj4gLSBUaGlzIGxvZyBpcyBwcmludGVkOiAidWZzaGNkX2Fi
b3J0OiBEZXZpY2UgYWJvcnQgdGFzayBhdCB0YWcgTiINCj4gLSBJZiBoYmEtPnJlcV9hYm9ydF9z
a2lwIGlzIHplcm8sIFFVRVJZX1RBU0sgY29tbWFuZCBpcyBzZW50DQo+IC0gRGV2aWNlIHJlc3Bv
bmRzICJVUElVX1RBU0tfTUFOQUdFTUVOVF9GVU5DX0NPTVBMIg0KPiAtIFRoaXMgbG9nIGlzIHBy
aW50ZWQ6ICJ1ZnNoY2RfYWJvcnQ6IGNtZCBhdCB0YWcgTiBub3QgcGVuZGluZyBpbiB0aGUNCj4g
ZGV2aWNlLiINCj4gLSBEb29yYmVsbCB0ZWxscyB0aGF0IHRhZyBOIGlzIG5vdCBzZXQsIHNvIHRo
ZSBkcml2ZXIgZ29lcyB0byBsYWJlbA0KPiAib3V0IiB3aXRoIHRoaXMgbG9nIHByaW50ZWQ6ICJ1
ZnNoY2RfYWJvcnQ6IGNtZCBhdCB0YWcgJWQgc3VjY2Vzc2Z1bGx5DQo+IGNsZWFyZWQgZnJvbSBE
Qi4iDQo+IC0gSW4gbGFiZWwgIm91dCIgc2VjdGlvbiwgbm8gY2xlYW51cCB3aWxsIGJlIG1hZGUs
IGFuZCB0aGVuIHVmc2hjZF9hYm9ydA0KPiBleGl0cw0KPiAtIFRoaXMgcmVxdWVzdCB3aWxsIGJl
IHJlLXF1ZXVlZCB0byByZXF1ZXN0IHF1ZXVlIGJ5IFNDU0kgdGltZW91dA0KPiBoYW5kbGVyDQo+
IA0KPiBOb3csIEluY29uc2lzdGVudCBzdGF0ZSBzaG93cy11cDogQSByZXF1ZXN0IGlzICJyZS1x
dWV1ZWQiIGJ1dCBpdHMNCj4gY29ycmVzcG9uZGluZyByZXNvdXJjZSBpbiBVRlMgbGF5ZXIgaXMg
bm90IGNsZWFyZWQsIGJlbG93IGZsb3cgd2lsbA0KPiB0cmlnZ2VyIGJhZCB0aGluZ3MsDQo+IA0K
PiAtIEEgbmV3IHJlcXVlc3Qgd2l0aCB0YWcgTSBpcyBmaW5pc2hlZA0KPiAtIEludGVycnVwdCBp
cyByYWlzZWQgYW5kIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSBmb3VuZCBib3RoIHRhZyBO
DQo+IGFuZCBNIGNhbiBwcm9jZXNzIHRoZSBjb21wbGV0aW9uIGZsb3cNCj4gLSBUaGUgcG9zdC1w
cm9jZXNzaW5nIGZsb3cgZm9yIHRhZyBOIHdpbGwgYmUgZXhlY3V0ZWQgd2hpbGUgaXRzIHJlcXVl
c3QNCj4gaXMgc3RpbGwgYWxpdmUNCj4gDQo+IEkgYW0gc29ycnkgdGhhdCBiZWxvdyBtZXNzYWdl
cyBhcmUgb25seSBmb3Igb2xkIGtlcm5lbCBpbiBub24tYmxrLW1xDQo+IGNhc2UuIEhvd2V2ZXIg
YWJvdmUgc2NlbmFyaW8gd2lsbCBhbHNvIHRyaWdnZXIgYmFkIHRoaW5nIGluIGJsay1tcSBjYXNl
Lg0KDQpPay4gIFRoYW5rcy4NCg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+IE90aGVyd2lzZSwgc3lz
dGVtIG1heSBjcmFzaCBieSBiZWxvdyBhYm5vcm1hbCBmbG93Og0KPiA+ID4NCj4gPiA+IEFmdGVy
IHRoaXMgcmVxdWVzdCBpcyByZXF1ZXVlZCBieSBTQ1NJIGxheWVyIHdpdGggaXRzDQo+ID4gPiBv
dXRzdGFuZGluZyBiaXQgc2V0LCB0aGUgbmV4dCBjb21wbGV0ZWQgcmVxdWVzdCB3aWxsIHRyaWdn
ZXINCj4gPiA+IHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSB0byBoYW5kbGUgYWxsICJjb21w
bGV0ZWQgb3V0c3RhbmRpbmcNCj4gPiA+IGJpdHMiLiBJbiB0aGlzIHRpbWUsIHRoZSAiYWJub3Jt
YWwgb3V0c3RhbmRpbmcgYml0IiB3aWxsIGJlIGRldGVjdGVkDQo+ID4gPiBhbmQgdGhlICJyZXF1
ZXVlZCByZXF1ZXN0IiB3aWxsIGJlIGNob3NlbiB0byBleGVjdXRlIHJlcXVlc3QNCj4gPiA+IHBv
c3QtcHJvY2Vzc2luZyBmbG93LiBUaGlzIGlzIHdyb25nIGFuZCBibGtfZmluaXNoX3JlcXVlc3Qo
KSB3aWxsDQo+ID4gPiBCVUdfT04gYmVjYXVzZSB0aGlzIHJlcXVlc3QgaXMgc3RpbGwgImFsaXZl
Ii4NCj4gPiA+DQo+ID4gPiBJdCBpcyB3b3J0aCBtZW50aW9uaW5nIHRoYXQgYmVmb3JlIHVmc2hj
ZF9hYm9ydCgpIGNsZWFucyB0aGUgdGltZWQtb3V0DQo+ID4gPiByZXF1ZXN0LCBkcml2ZXIgbmVl
ZCB0byBjaGVjayBhZ2FpbiBpZiB0aGlzIHJlcXVlc3QgaXMgcmVhbGx5IG5vdA0KPiA+ID4gaGFu
ZGxlZCBieSBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKSB5ZXQgYmVjYXVzZSBpdCBtYXkg
YmUNCj4gPiA+IHBvc3NpYmxlIHRoYXQgdGhlIGludGVycnVwdCBjb21lcyB2ZXJ5IGxhdGVseSBi
ZWZvcmUgdGhlIGNsZWFuaW5nLg0KPiA+IFdoYXQgZG8geW91IG1lYW4/IFdoeSBjaGVja2luZyB0
aGUgb3V0c3RhbmRpbmcgcmVxcyBpc24ndCBlbm91Z2g/DQo+ID4NCj4gPiA+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+ID4g
LS0tDQo+ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDkgKysrKysrKy0tDQo+ID4g
PiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+IGluZGV4IDg2MDNiMDcwNDVhNi4uZjIzZmIxNGRmOWY2
IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ID4gKysr
IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ID4gQEAgLTY0NjIsNyArNjQ2Miw3IEBA
IHN0YXRpYyBpbnQgdWZzaGNkX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgIC8qIGNvbW1hbmQgY29tcGxldGVkIGFscmVhZHkgKi8NCj4g
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogY21kIGF0
IHRhZyAlZCBzdWNjZXNzZnVsbHkgY2xlYXJlZA0KPiBmcm9tDQo+ID4gPiBEQi5cbiIsDQo+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCB0YWcpOw0KPiA+ID4g
LSAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIGNsZWFudXA7DQo+ID4gQnV0IHlvdSd2ZSBhcnJpdmVkIGhlcmUgb25seSBp
ZiAoISh0ZXN0X2JpdCh0YWcsICZoYmEtPm91dHN0YW5kaW5nX3JlcXMpKSkgLQ0KPiA+IFNlZSBs
aW5lIDY0MDAuDQo+ID4NCj4gPiA+ICAgICAgICAgICAgICAgICB9IGVsc2Ugew0KPiA+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwNCj4gPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIiVzOiBubyByZXNwb25zZSBmcm9tIGRldmljZS4gdGFnID0g
JWQsIGVyciAlZFxuIiwNCj4gPiA+IEBAIC02NDk2LDkgKzY0OTYsMTQgQEAgc3RhdGljIGludCB1
ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KPiA+ID4gICAgICAgICAgICAgICAg
IGdvdG8gb3V0Ow0KPiA+ID4gICAgICAgICB9DQo+ID4gPg0KPiA+ID4gK2NsZWFudXA6DQo+ID4g
PiArICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+
ID4gKyAgICAgICBpZiAoIXRlc3RfYml0KHRhZywgJmhiYS0+b3V0c3RhbmRpbmdfcmVxcykpIHsN
CklzIHRoaXMgbmVlZGVkPyAgaXQgd2FzIGFscmVhZHkgY2hlY2tlZCBpbiBsaW5lIDY0MzkuDQoN
ClRoYW5rcywNCkF2cmkNCg0KPiA+ID4gKyAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gPiArICAgICAgICAgICAgICAgZ290
byBvdXQ7DQo+ID4gPiArICAgICAgIH0NCj4gPiA+ICAgICAgICAgc2NzaV9kbWFfdW5tYXAoY21k
KTsNCj4gPiA+DQo+ID4gPiAtICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3RfbG9j
aywgZmxhZ3MpOw0KPiA+ID4gICAgICAgICB1ZnNoY2Rfb3V0c3RhbmRpbmdfcmVxX2NsZWFyKGhi
YSwgdGFnKTsNCj4gPiA+ICAgICAgICAgaGJhLT5scmJbdGFnXS5jbWQgPSBOVUxMOw0KPiA+ID4g
ICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0K
PiA+ID4gLS0NCj4gPiA+IDIuMTguMA0KDQo=
