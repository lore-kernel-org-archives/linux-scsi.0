Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125ABC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 06:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB0E217A0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 06:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="R1bPRl7M";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="w15fdu6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgFRGTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 02:19:53 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:17869 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFRGTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 02:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592461192; x=1623997192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VlKXhSYA1s1tDa83srnmTwBb2V9bfNjbppQSl5vQTJU=;
  b=R1bPRl7MDW+oPuCrHS3aYKDWzwsYMKU5dMIWDl+04CP6OaqCHwkHYfWR
   PGdOvj2N4j9Qrcv4uPQlagO/rBG2RoIa2tgcgiWZ5WUv7kM9XIGnOYq2J
   lJInkegxzCB4woZxmxAKJrz5syV2FVv59KCCcK/g/1x9OQz2mFDPWH3xB
   CzVuECDQDktrPRRnwioNgktwv9ZMjwsLsDm5yciPDXz3YJq6G+l+aqSe6
   dUpLMp8R8mjJ68VNo1py7WKgGxaalbqsYqO0APcsxmOl8/WqXL5Ge/FLd
   v8nwe8Hp9yE1T1EMGcXW6bj/p3fxs28zZlG5XSC0UEBcP1JVcxexxgr8e
   A==;
IronPort-SDR: NFfaMzyW4OU7vpYoRo70XYq6xz6tlFUKtx8xp05LV6MM+eggyRbpyg5lXXxvBT1efloObP/mWq
 ksJK0ddCZritPzE+8chy2Gs9of0rFF/XCgCkqfMCCiNpAjx8xv02x8qjMqYwkRuLkAO4/SpXsa
 +iOJEK7YFphW6XtIhlpBjjAG67VPh1z8pdk03MqBEizn9H2cjh3p01UqZThfwDRgMxasIpBSpk
 vM9fCH8a4Am76swfIKmohZHNTXcqGdC+mUq1al0jM6Ousz5414uYhnKnYtYaiqwbluTgHvOuCw
 mVI=
X-IronPort-AV: E=Sophos;i="5.73,525,1583164800"; 
   d="scan'208";a="144613024"
Received: from mail-co1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.58])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 14:19:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZF+0FxpELXRTl1okd4DwlAihh2tPLlkwRSdZI6I5C64bXrT5sy0bEyInhSOCjcLzMHGAQVOH3unQ4eClBjHC03zd8rOVs5H7QqAoJ9ISYSBgPncUzrPcBH/9aryn/JwVQa12hOyIiEt7Yqfi017qL8Y3Fnr3L1Ak62mDtwtY+V6mbo/KuVUBKICpElNdDs/AqxL6JNRFSyI/quwiZHInn5/NExbbIPAV4U0pAVB4a3zkjtMfZ3YW95B4+NY9ExZSl4lIjpAzWosQOf7bU5FMtNJIArwxHfZcUP0bVcfTCt2NpESguKdBy0Xbgvf0kugC/+/aG5BX9yddJ5FJUqlww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlKXhSYA1s1tDa83srnmTwBb2V9bfNjbppQSl5vQTJU=;
 b=kCNgugk4ln+c/ZJxnkV4MMwIgxtSGkKfFUbKqybahh70i/OW8mNOJcwA3IG3t/NVaSZMWSJkynHrWzf3x7x6UFWvVnBBLg1nZOlFtsZSJVMMuH2S+1AwaRmjgRtBuNPQZSabpYGkMcWClBO4rNvNcN+Si89cgmjc4kciadeJdflvMZgW1oHgrG1cYCWUsRf791gCVkNO9yeAcmx54gmC0s++KylVWps0/xzpzw2qbltBk/94i7H83/fpUGtbxvRXTTbTc+D9gyGVV7JJwvSsyxpc/Q1vadattMeaYCbaCjuQ0Km2x9InBet4kR0e3B3TmzzKph1S/jkbwKHlDVS8Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlKXhSYA1s1tDa83srnmTwBb2V9bfNjbppQSl5vQTJU=;
 b=w15fdu6TrpOISSH6H6mrP7SJG8gLbr4DmBxVkcqS0VD6KG+wpRXnTrP4z4uJQH0S7OisbK8NU5CTjqN8rcygYd4dSlGbj+v/X47FxAIM+uDqCmKV5NibUhmJNkCm5vC+a/aQTh3qlx2z3ghcHoy4spbOfbuL0kZCkJg4YkN55UI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2270.namprd04.prod.outlook.com (2603:10b6:804:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 06:19:48 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 06:19:48 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Bean Huo <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWQvePZuXDGcRfX0mZaBS+6LSmD6jcdgAAgAAosQCAAIRmAIAAcEEAgABW4RA=
Date:   Thu, 18 Jun 2020 06:19:48 +0000
Message-ID: <SN6PR04MB464006DDD96B80D7FE7DFAB4FC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <3d5748ce4481c789000979f9831a5ae681cd9d34.camel@gmail.com>
        <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592395081831.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p3>
 <717176949.41592444702525.JavaMail.epsvc@epcpadp1>
In-Reply-To: <717176949.41592444702525.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1db39556-f858-4f4b-7150-08d8134f9a74
x-ms-traffictypediagnostic: SN2PR04MB2270:
x-microsoft-antispam-prvs: <SN2PR04MB2270688EACFF007CD453F985FC9B0@SN2PR04MB2270.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P1jC7rDk1aliVyd+Ug4w8hWwygZ7xpkNej3YKlDjVjyt8IHRcThsAlr87dVctGMYNpqyK90wqcF1lE0hYlyGiClyL3rRAfQLrKfx3xaApMvtnoekWDe1qi6nsuZMEerZ3GbU85MSFko4AJdN1UVLuS1x+aG5TWLLqCm2SOUo6gwWAE6UQ9bVNbezpBpuSwmkELei7C66YiTJdZBP7s64wVrNOjz22d8R/I3ECRzNs4RFnttQh7kPoU75SvMoyafyMFSCmaTJdD8l41V3FCQFheQoLhz3T77GMKRtx9Rn2kWSQ5HrIaUyj+uy3343hb79sHjOAnutHaMsaq8ddbnLL+Zc5aMbPwK3TAFNSAFRT/NE+Kktr72nIrqCo+3Owe9s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(76116006)(110136005)(86362001)(66476007)(66946007)(54906003)(71200400001)(4326008)(33656002)(316002)(8936002)(83380400001)(7696005)(5660300002)(2906002)(6506007)(52536014)(55016002)(7416002)(26005)(186003)(9686003)(478600001)(8676002)(66556008)(64756008)(66446008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CqB0ZK/it+hGEJ7QWW8rN0ei3dKpG240zPv9SaSjyGoWew/biucsqfRl81ZYmnz6whg3VVlJ8aaU5J9j7FMOXgFI3aLP41LSLSit0dNUXKW0P0gE/LoW+zsftnDWYhYlYdtkSZsELh3Fvd+YjebB5rikXsI+NlyqhuBdVXNjDt6AdQ+3UlHrJdQrhjBWqg5bc96AXxhpq/7XgRSakqHeAsIyxfRMTa9qnZN4BrDs+VRAak2JkMSzjWyBOdtIBtIkBrCWoWdjnp5D2BbQMhE4lAyWyUmwPupONUVzPiRC8kvHAodOqHHyIXv0LwbC6JwQpUeSFUbgLXlRE+A9sU8uiB4LlrxiNmSfqsn+CHc/um/Quaf5tSkH39LUoEF1s9eGwvDn30RfUO2DphoS61OFrWJXbK/isu9My36nkj5FNSvgXU5dXh7w36ZBFyRrOimvx7t54HUj/cCuNfBaV39yZj3eDPN0U2+36iWKWpxuS0XZo8VL7Z50RfJVY3dhXoEw
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db39556-f858-4f4b-7150-08d8134f9a74
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 06:19:48.6652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Z1zXhL1+Na/mx12SugDxKPRlJi6+HDLtDxDu9CEAhO1/lb6vfaSM7Q4JsdXgkw/LwGW1pzTZE8QivMNUW9gTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2270
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gPiA+ID4gaW1wbGVtZW50ZWQNCj4gPiA+ID4gPiBhcyBhIG1vZHVsZSBwYXJhbWV0
ZXIsIHNvIHRoYXQgaXQgY2FuIGJlIGNvbmZpZ3VyYWJsZSBieSB0aGUNCj4gPiA+ID4gPiB1c2Vy
Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVG8gZ3VyYW50ZWUgYSBtaW5pbXVtIG1lbW9yeSBwb29s
IHNpemUgb2YgNE1COg0KPiA+ID4gPiA+ICQgaW5zbW9kIHVmc2hwYi5rbyB1ZnNocGJfaG9zdF9t
YXBfa2J5dGVzPTQwOTYNCj4gPiA+ID4NCj4gPiA+ID4gWW91IGFyZSBnb2luZyB0aHJvdWdoIGEg
bG90IG9mIHRyb3VibGVzIHRvIG1ha2UgaXQgYSBsb2FkYWJsZQ0KPiA+ID4gPiBtb2R1bGUuDQo+
ID4gPiA+IFdoYXQgYXJlLCBpbiB5b3VyIG9waW5pb24sIHRoZSBwcm9zIGFuZCBjb25zIG9mIHRo
aXMgZGVzaWduDQo+ID4gPiA+IGRlY2lzaW9uPw0KPiA+ID4NCj4gPiA+IEluIG15IG9waW5pb24u
Li4NCj4gPiA+DQo+ID4gPiBwcm9zOg0KPiA+ID4gMS4gQSB1c2VyIGNhbiB1bmxvYWQgYW4gdW5u
ZWNlc3NhcnkgbW9kdWxlIHdoZW4gdGhlcmUgaXMgYW4NCj4gPiA+IGluc3VmZmljaWVudA0KPiA+
ID4gbWVtb3J5IHNpdHVhdGlvbiAoSFBCIGNhc2UpLg0KPiA+ID4gMi4gU2luY2UgZWFjaCBVRlMg
dmVuZG9yIGhhcyBhIGRpZmZlcmVudCB3YXkgb2YgaW1wbGVtZW50aW5nIFVGUw0KPiA+ID4gZmVh
dHVyZXMsDQo+ID4gPiBpdCBjYW4gYmUgc3VwcG9ydGVkIGFzIGEgc2VwYXJhdGUgbW9kdWxlLiBP
dGhlcndpc2UsIG1hbnkgcXVpcmtzIG11c3QNCj4gPiA+IGJlIGF0dGFjaGVkIHRvIG1vZHVsZSwg
d2hpY2ggaXMgbm90IGRlc2lyYWJsZSB3YXkuDQo+ID4gPiAzLiBJdCBpcyBwb3NzaWJsZSB0byBk
aXN0aW5ndWlzaCBwYXJ0cyB0aGF0IGFyZSBub3QgbmVjZXNzYXJ5IGZvcg0KPiA+ID4gZXNzZW50
aWFsDQo+ID4gPiB1ZnMgb3BlcmF0aW9uLg0KPiA+ID4gNC4gSXQgaXMgYWR2YW50YWdlb3VzIHRv
IGltcGxlbWVudCB0aGUgbGF0ZXN0IGZ1bmN0aW9ucyBhY2NvcmRpbmcgdG8NCj4gPiA+IHRoZQ0K
PiA+ID4gZGV2ZWxvcG1lbnQgc3BlZWQgb2YgVUZTLg0KPiA+ID4NCj4gPiA+IGNvbnM6DQo+ID4g
PiAxLiBJdCBpcyBkaWZmaWN1bHQgd29yayB0byBiZSBpbXBsZW1lbnRlZCBhcyBhIG1vZHVsZS4N
Cj4gPiA+IDIuIE1vZGlmeWluZyAidWZzZmVhdHVyZS5jIiBpcyByZXF1aXJlZCB0byBpbXBsZW1l
bnQgdGhlIGZlYXR1cmUgdGhhdA0KPiA+ID4gY2FuDQo+ID4gPiBub3Qgc3VwcG9ydGVkIGJ5IHRo
ZSBleHNpdGluZyAidWZzZl9vcGVyYXRpb24iLg0KPiA+ID4NCj4gPiA+IFRoYW5rcywNCj4gPiA+
IERhZWp1bg0KPiA+DQo+ID4gRGVhciBBdnJpLCBEYWVqdW4sIEJhcnQNCj4gPg0KPiA+IEl0IGlz
IHRydWUgdGhhdCBpdCBpcyB2ZXJ5IGRpZmZpY3VsdCB0byBtYWtlIGV2ZXJ5b25lIGhhcHB5Lg0K
PiA+IFdlIG5vdyBoYXZlIHRocmVlIEhQQiBkcml2ZXJzIGluIHRoZSBwYXRjaHdvcmssIGJ1dCBJ
IHN0aWxsIGRpZG4ndCBzZWUNCj4gPiBhIGZpbmFsIGFncmVlbWVudC4gUGxlYXNlIHRlbGwgbWUg
d2hpY2ggb25lIGRvIHlvdSB3YW50IHRvIGZvY3VzIG9uPw0KPiBUaGUgSFBCIGRyaXZlciBoYXMg
YmVlbiBncmVhdGx5IGltcHJvdmVkIGluIHRoZSBwcm9jZXNzIG9mIGJlaW5nIGFwcGxpZWQgdG8N
Cj4gbW9iaWxlIGRldmljZXMgc2luY2UgdGhlIHJlbGVhc2Ugb2YgdGhlIGZpcnN0IEhQQiB2ZXJz
aW9uIGluIG9wZW5NUERLLiBXZQ0KPiB3YW50IHRvIGNvbnRyaWJ1dGUgdG8gdGhlIGxpbnV4IG1h
aW5saW5lIHdpdGggdGhlIGtub3dsZWRnZSBvYnRhaW5lZA0KPiB0aHJvdWdoIHRoZSBleHBlcmll
bmNlLg0KPiBJIGZpbmQgaXQgZGlmZmljdWx0IHRvIG1ha2UgZXZlcnlvbmUgaGFwcHksIGJ1dCBJ
IHRoaW5rIGl0IGlzIHBvc3NpYmxlIHRoYXQNCj4gZXZlcnlvbmUgY2FuIGFjY2VwdCB0aGUgSFBC
IGRyaXZlciB0aHJvdWdoIHNldmVyYWwgcmV2aXNpb25zLg0KQWNrIG9uIHRoYXQuDQpGb3IgbWUs
IGl0IHdhcyB2ZXJ5IGNsZWFyIHRoYXQgQmFydCBwcmVmZXJzIHRoZSBTYW1zdW5nIGFwcHJvYWNo
LA0KSGVuY2UgSSB3aXRoZHJldyBmcm9tIG15IFJGQyBhbmQgc3dpdGNoIHRvIHN1cHBvcnQgRGFl
anVuJ3MuDQoNClRoYW5rcywNCkF2cmkNCg==
