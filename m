Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF575C54FD0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9470420753
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LxG97cIH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zD+x2DHO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgDUMHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:07:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3526 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgDUMHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 08:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587470824; x=1619006824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h9g+vuKTNiUMhQGreK6wl2Ok5Bwb7EsTTQX4aZ0cjmw=;
  b=LxG97cIHDf2vUZqNTzfJPLX3MoQcxfyQso5ok/LxYQCxY6F4qYjntAmP
   1WXjtiCvwHYDdEcqs68Wxzn+gW79u6VGitRTL2I86iE4sQFAaSaoQuNsk
   s+nHOERzOC8GBAgR0kb7eADsqLU87i374RgRw4KTGy1QFK6fA/5vslJxS
   KhUKo7QNdvyV0+1mxAiEdpkAaCRCyCWmU1ui5PbI6bFQ20cp3YNt1/0fP
   R/LaKGQgGeF7K3SCkcTulsVeBa37JNw2vivtRr256uBvFntwr1NrU19B9
   rwSTTSj1cmtN1pJjIPXqoYIBhNaBs+Vtn2YTOZnhG6jZlM6+DteAt8RRW
   A==;
IronPort-SDR: Eqr87Oz8RXIMSbTZZq9Bczx0AXVw6873rTpuWZj8qGw/sMTwSi2H2NoI7kFVqyNiTCDrdGYjrp
 0f4YJodmvM9KX84Om7wvR4SL0rOiUrG0Z9WUTKCMSrSLnaYW+6AFKdY4JT30P48VMr0K+0G8Uh
 7dXv3H9nWwS4LqFs8rEofFCp+/zf5mCzQ7ozMPbDXPqgv/WROxhWNHMaijxvHf6xyzcPGbWrJO
 dijaxBrw0tuciCoeaxtCaZIIohp4yAfSd9WYNSL6iEEmNA95rrHylJ6i7DY1ru/YCKxqNmzNh5
 omw=
X-IronPort-AV: E=Sophos;i="5.72,410,1580745600"; 
   d="scan'208";a="244503062"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 21 Apr 2020 20:07:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmmG+9OlhYVHUKLUj7nH2uDwxBMruMaRiVPZpp28eHl/nPlke2Ljd4zdMCyyAQ8JPh8ZsD5xnCKPjI9OfIjlgz9Cbt+u7JDLj/Ywcn1/x5aXYL4fd9ZUO+7t2QdnDdDf899OuWOD5rUG9jC8gmUh0Hf7FCX4ra1cUfD6W8oAdamVjPaz9ONBSHmzH4Ws8e8dthwBANOGGGZGwsv74jgfzLFNVwyUJBnN6ysKTJtrdjnJNsU+TTJgsy+0rEaFJocTis8oltxxpndwMwMaUIHb86X0+GUx9uEOnV7H3S6j4Skn6n44I/GRbAlewrEa8h9dEsfaIttDRFyns+zIMNCicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9g+vuKTNiUMhQGreK6wl2Ok5Bwb7EsTTQX4aZ0cjmw=;
 b=HpgB+13W3yDid2jW7t/1AHwnw0uSz9TTNVzE1JGscuiYO7+w8wp/sFMseFyoJOqjXIGsxRgNuGX7q2isQVLLRr5HcX5SVonJnlsWRZxf4AtJuVR/Beu8ysvxfAaddFcEpnKyclwVy4q05BZ/f+XH9LxetxxAWzTdEQ/WknrS0PyYwz6vEaMX2+erXPOVGZjOQxRXe1yguEG1KcDmplEU31v9PQSnU2dpQBAZVH/nwliYJHdxw+JA0/VsXTsxofpH+WFY7ZCe0fpb0QEV1Tv5BVKAGQwH9OJZJrdQDxzFgljSPiUFtDz28GOj4IKvUm7QWDH/EeygXrD1YE3VfXg2AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9g+vuKTNiUMhQGreK6wl2Ok5Bwb7EsTTQX4aZ0cjmw=;
 b=zD+x2DHOQmJui5iB2rNbEUDX2mpl3rWZja19eZ79nl9T+HSme0z6u73nAM8Zz2E+jUIC7L22K7p2/oSG4OH2X6wg0iKvpdNII/vYXtmuJW7gF62hq0U6hXjEo1lEymSu+gC55gVEJVDkBSUHICFRXmVX7CDsbS/6ZhTPKZ1APo8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4656.namprd04.prod.outlook.com (2603:10b6:805:aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Tue, 21 Apr
 2020 12:07:02 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 12:07:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Topic: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Thread-Index: AQHWFOOBFbSRs7BAOkOiLBrzlbkq96iBrgCAgAGLl4CAAEQsIA==
Date:   Tue, 21 Apr 2020 12:07:01 +0000
Message-ID: <SN6PR04MB464022365ECC9F5565030147FCD50@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
        <20200417175944.47189-6-alim.akhtar@samsung.com>
        <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
 <062001d617b1$af5f0aa0$0e1d1fe0$@samsung.com>
In-Reply-To: <062001d617b1$af5f0aa0$0e1d1fe0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44829a46-bee8-40f4-21ef-08d7e5ec8013
x-ms-traffictypediagnostic: SN6PR04MB4656:
x-microsoft-antispam-prvs: <SN6PR04MB465636FE958A247ABA2A5CDEFCD50@SN6PR04MB4656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(71200400001)(8936002)(76116006)(66446008)(66946007)(66556008)(64756008)(7416002)(66476007)(52536014)(186003)(54906003)(81156014)(4326008)(8676002)(5660300002)(110136005)(53546011)(498600001)(55016002)(9686003)(6506007)(33656002)(2906002)(26005)(86362001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M5pdj1AB6Rxtfi4WFK1Gvcg34+syg+AxwJqolaj8uUG9FC/AKwVrfft2dYTZBu6UDb5nkTVEzZhVMF1gJkmuVIvBtNSlLQHqyhmWnpurxrWSSLoV3WDG6AqOEB2jotQEezx3M3VXqAMExIOBWasNpb+uyZ+ia7v5G3T3k9p/j7EA9myJz0jRDATJyRfglTFKQyMJtL+VR3O5ZX6N/VAOXgNauAgA/Lm0h/XfFGgpkMFpl2XY53J03kPes7NhAEIN5cjQ/63Eck73MbgHScG+nOzUaAUU7wyu8WBbZDiFUwKCprSMaQ2nAjkszts2z+ftqCbBQdk4kV9Plc1UNznlZkySYAUdk00pTB+4UPbv5USIaz7FI/0J+JjA3ky5GzfKkFmGDTiE67nlTGS3EhPaCiwZom/ex2+Mnd1/wg86V0qvnZZrAYpC5icAJZwRgcl7
x-ms-exchange-antispam-messagedata: 3LU5iUlMZx0m38T/WfVHguTFbMwdX2CtxP8xeHd5oPPss/VMv66ssHukgY4l9LPrUh4cR6M1i0z9nomraQP1QoCNKf+4/tSABiNZiKJaXgQ98kvO/gyVt8QQsgNTbIfOqJjsWhqiW9PyJ3oQRb6mDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44829a46-bee8-40f4-21ef-08d7e5ec8013
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 12:07:01.5467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfQrIQu/L3ifsgHkroHiUQtSRJ/jecuv9l1T7RmpevXExTT7WLZs8aZCd6oAz+1Ac4V9YWf/pIQ80ORByNSKdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4656
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IEF2cmkgQWx0bWFu
IDxBdnJpLkFsdG1hbkB3ZGMuY29tPg0KPiA+IFNlbnQ6IE1vbmRheSwgQXByaWwgMjAsIDIwMjAg
NTo1NiBQTQ0KPiA+IFRvOiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+OyBy
b2JoQGtlcm5lbC5vcmcNCj4gPiBDYzogZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LXNjc2lAdmdlci5rZXJuZWwub3JnOw0KPiA+IGtyemtAa2VybmVsLm9yZzsgbWFydGluLnBldGVy
c2VuQG9yYWNsZS5jb207DQo+IGt3bWFkLmtpbUBzYW1zdW5nLmNvbTsNCj4gPiBzdGFubGV5LmNo
dUBtZWRpYXRlay5jb207IGNhbmdAY29kZWF1cm9yYS5vcmc7IGxpbnV4LXNhbXN1bmctDQo+ID4g
c29jQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
OyBsaW51eC0NCj4gPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUkU6IFtQ
QVRDSCB2NiAwNS8xMF0gc2NzaTogdWZzOiBhZGQgcXVpcmsgdG8gZml4IGFibm9ybWFsIG9jcw0K
PiA+IGZhdGFsIGVycm9yDQo+ID4NCj4gPiA+DQo+ID4gPiBGcm9tOiBLaXdvb25nIEtpbSA8a3dt
YWQua2ltQHNhbXN1bmcuY29tPg0KPiA+ID4NCj4gPiA+IFNvbWUgYXJjaGl0ZWN0dXJlcyBkZXRl
cm1pbmVzIGlmIGZhdGFsIGVycm9yIGZvciBPQ1Mgb2NjdXJycyB0byBjaGVjaw0KPiA+ID4gc3Rh
dHVzIGluIHJlc3BvbnNlIHVwaXUuIFRoaXMgcGF0Y2gNCj4gPiBUeXBvIC0gb2NjdXJzDQo+ID4N
Cj4gPiA+IGlzIHRvIHByZXZlbnQgZnJvbSByZXBvcnRpbmcgY29tbWFuZCByZXN1bHRzIHdpdGgg
dGhhdC4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2lt
QHNhbXN1bmcuY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWto
dGFyQHNhbXN1bmcuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDYgKysrKysrDQo+ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDYgKysr
KysrDQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQo+ID4gPg0KPiA+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5jDQo+ID4gPiBpbmRleCBiMzJmY2VkY2RjYjkuLjhjMDdjYWZmMGE1YyAxMDA2
NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+ICsrKyBiL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gPiA+IEBAIC00Nzk0LDYgKzQ3OTQsMTIgQEAgdWZz
aGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoc3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4gPiA+IHN0
cnVjdCB1ZnNoY2RfbHJiICpscmJwKQ0KPiA+ID4gICAgICAgICAvKiBvdmVyYWxsIGNvbW1hbmQg
c3RhdHVzIG9mIHV0cmQgKi8NCj4gPiA+ICAgICAgICAgb2NzID0gdWZzaGNkX2dldF90cl9vY3Mo
bHJicCk7DQo+ID4gPg0KPiA+ID4gKyAgICAgICBpZiAoaGJhLT5xdWlya3MgJiBVRlNIQ0RfUVVJ
UktfQlJPS0VOX09DU19GQVRBTF9FUlJPUikgew0KPiA+ID4gKyAgICAgICAgICAgICAgIGlmIChi
ZTMyX3RvX2NwdShscmJwLT51Y2RfcnNwX3B0ci0+aGVhZGVyLmR3b3JkXzEpICYNCj4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNQVNLX1JTUF9VUElVX1JFU1VM
VCkNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG9jcyA9IE9DU19TVUNDRVNTOw0KPiA+
ID4gKyAgICAgICB9DQo+ID4gPiArDQo+ID4gTm90IHN1cmUgdGhhdCBJIGZvbGxvdyB3aGF0IHRo
aXMgcXVpcmsgaXMgYWxsIGFib3V0Lg0KPiA+IFlvdXIgY29kZSBvdmVycmlkZXMgb2NzIGJ5IG9w
ZW4gY29kaW5nIHVmc2hjZF9nZXRfcnNwX3VwaXVfcmVzdWx0Lg0KPiA+DQo+ID4gTm9ybWFsbHkg
T0NTIGlzIGluIHV0cCB0cmFuc2ZlciByZXEgZGVzY3JpcHRvciwgZHdvcmQgMiwgYml0cyAwLi43
Lg0KPiA+IE15IHVuZGVyc3RhbmRpbmcgZnJvbSB5b3VyIGRlc2NyaXB0aW9uLCBpcyB0aGF0IHNv
bWUgZmF0YWwgZXJyb3IgbWlnaHQNCj4gPiBvY2N1ciwgQnV0IHRoZSBob3N0IGNvbnRyb2xsZXIg
ZG9lcyBub3QgcmVwb3J0IGl0LCBhbmQgaXQgc3RpbGwgbmVlZHMgdG8NCj4gPiBiZSBjaGVja2Vk
IGluIHRoZSByZXNwb25zZSB1cGl1Lg0KPiA+IEV2aWRlbnRseSB5b3UgYXJlIG5vdCBkb2luZyBz
by4NCj4gPiBQbGVhc2UgZWxhYm9yYXRlIHlvdXIgZGVzY3JpcHRpb24uDQo+ID4NCj4gPiBQLlMu
DQo+ID4gVGhlIG9jcyBpcyBiZWluZyBldmFsdWF0ZWQgaW4gZGV2aWNlIG1hbmFnZW1lbnQgY29t
bWFuZHMgYXMgd2VsbCwgSXNuJ3QNCj4gPiB0aGlzIHNvbWV0aGluZyB5b3UgbmVlZCB0byBhdHRl
bmQ/DQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gQXZyaQ0KPiA+DQo+ID4gPiAgICAgICAgIHN3aXRj
aCAob2NzKSB7DQo+ID4gPiAgICAgICAgIGNhc2UgT0NTX1NVQ0NFU1M6DQo+ID4gPiAgICAgICAg
ICAgICAgICAgcmVzdWx0ID0gdWZzaGNkX2dldF9yZXFfcnNwKGxyYnAtPnVjZF9yc3BfcHRyKTsN
Cj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuaA0KPiA+ID4gaW5kZXggYTliOWFjZTlmYzcyLi5lMWQwOWMyYzQzMDIg
MTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4gPiArKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+ID4gPiBAQCAtNTQxLDYgKzU0MSwxMiBAQCBl
bnVtIHVmc2hjZF9xdWlya3Mgew0KPiA+ID4gICAgICAgICAgKiByZXNvbHV0aW9uIG9mIHRoZSB2
YWx1ZXMgb2YgUFJEVE8gYW5kIFBSRFRMIGluIFVUUkQgYXMgYnl0ZS4NCj4gPiA+ICAgICAgICAg
ICovDQo+ID4gPiAgICAgICAgIFVGU0hDRF9RVUlSS19QUkRUX0JZVEVfR1JBTiAgICAgICAgICAg
ICAgICAgICAgID0gMSA8PCA5LA0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICAvKg0KPiA+ID4gKyAg
ICAgICAgKiBUaGlzIHF1aXJrIG5lZWRzIHRvIGJlIGVuYWJsZWQgaWYgdGhlIGhvc3QgY29udHJv
bGxlciByZXBvcnRzDQo+ID4gPiArICAgICAgICAqIE9DUyBGQVRBTCBFUlJPUiB3aXRoIGRldmlj
ZSBlcnJvciB0aHJvdWdoIHNlbnNlIGRhdGENCj4gPiA+ICsgICAgICAgICovDQo+ID4gPiArICAg
ICAgIFVGU0hDRF9RVUlSS19CUk9LRU5fT0NTX0ZBVEFMX0VSUk9SICAgICAgICAgICAgID0gMSA8
PCAxMCwNCj4gPiA+ICB9Ow0KPiA+ID4NCj4gPiA+ICBlbnVtIHVmc2hjZF9jYXBzIHsNCj4gPiA+
IC0tDQo+ID4gPiAyLjE3LjENCj4gQXZyaQ0KPiANCj4gQXMgc3BlY2lmaWVkIGluIHRoZSBzcGVj
LCBPQ1MgaXNuJ3Qgc3VwcG9zZWQgdG8gcmVmZXIgdG8gdGhlIGNvbnRlbnRzIG9mDQo+IFJFU1BP
TlNFIFVQSVUuDQo+IEJ1dCwgRXh5bm9zIGhvc3QgYmVoYXZlcyBsaWtlIHRoYXQgaW4gc29tZSBj
YXNlcywgZS5nLiBhIHZhbHVlIG9mICdzdGF0ZScgaW4gaXMNCj4gaXNuJ3QgR09PRCgwMGgpLg0K
T0suDQpJIHN0aWxsIHRoaW5rIHRoYXQgeW91IG1pZ2h0IGNvbnNpZGVyIHJld29yZGluZyB5b3Vy
IGNvbW1pdCwgZXhwbGFpbmluZyB0aGlzIHF1aXJrIGJldHRlci4NClNwZWNpZmljYWxseSB5b3Ug
bWlnaHQgbm90IHdhbnQgdG8gc2F5ICJpZiBmYXRhbC4uLiIgYmVjYXVzZSBmYXRhbCBjb2RlICgw
eDcpIGlzIGp1c3Qgb25lIGVycm9yIGNvZGUgb3V0IG9mIG1hbnkuDQpBbHNvIHlvdSBtaWdodCB3
YW50IHRvIHVzZSB1ZnNoY2RfZ2V0X3JzcF91cGl1X3Jlc3VsdCgpIGluIHRoZSBxdWlyayBib2R5
IGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcgaXQuDQoNCj4gDQo+IEZvciBRVUVSWSBSRVNQT05TRSwg
aXRzIG9mZnNldCwgaS5lLiAiIGR3b3JkXzEiIGlzIHJlc2VydmVkLCBzbyBjdXJyZW50bHkgbm8N
Cj4gaW1wYWN0LCBJIHRoaW5rLg0KPiBCdXQgaWYgeW91IGZlZWwgYW5vdGhlciBjb25kaXRpb24g
aXMgbmVjZXNzYXJ5IHRvIGlkZW50aWZ5IGlmIHRoaXMgcmVxdWVzdCBpcw0KPiBRVUVSWSBSRVFF
VVNUIG9yIG5vdCwgd2UgY2FuIGFkZCBtb3JlLg0KTm8gbmVlZCwgYXMgbG9uZyBhcyB5b3UgYXJl
IG9rIHdpdGggd2hhdGV2ZXIgdWZzaGNkX2dldF90cl9vY3MoKSByZXR1cm5zIGluIHVmc2hjZF93
YWl0X2Zvcl9kZXZfY21kKCkuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzDQoNCg==
