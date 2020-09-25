Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48133C4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB0622211
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="f4xbdbWW";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ZAzDjda2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYGgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:36:33 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:18495 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgIYGgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601015792; x=1632551792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CVtQdUDyDSdKfY++4nCaXp+MEVgR1IOotMb1O6XxAc0=;
  b=f4xbdbWWRHw4LsBI+W1UsdMtdjOE0yO2tA/VJIcwIWsnnuD1aLvRTOhe
   tXiYf1HnpkHDvgvRwUUmW6e9mVpuQ9ZMGNk0gK4Vrr87slL1Hhy0WHqKb
   W1riwn2hPsQvoz76Lxf92lFriBad2Vv88uQ1HlDV05e1ZQGUoN1iBlLvz
   8xm8+3HczFcXV2x/CX536ZBYIKoG9Oi496kK1Wo7TUzvGLEOrvcjhKJuk
   ztcEN6TTjqMWBfTupxBDjWqr6HkWuslFWR4fqTdJ6tgVFrtoUP94BQKIr
   pSJ7BzUyDEA5tec+8ldJ4a0OoIS5rIs32vudWzKsoJu/bR91Yx75UUwpR
   Q==;
IronPort-SDR: MRQ/vgfCXitEVhLkED0lYWMl06rBXVapseYd0oUokyC1hSIPek63TdU+FUnn6jinS5Zurx1de1
 dlGbkXDHFjfdBAU2gimw++AIu87uuFmy1BJjgOZ9hxz+b5kcDGRp8e+hIg/kPcXhEbBFpZyZUy
 U/0i761x68ARGjPOdKk/wCI2mwgofkgnTMzvrwXK1nxk5XiiQP8TOOddE74wNO3Ax/XZ/NO0qV
 SN+jl7Y+P5uo0w3NiJ7tEs0rDrvU5ZP6au1mQ+NlewEN/LbyEDHLTlTA7P06bEL8v0Bl7O50l4
 C9U=
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="93148731"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Sep 2020 23:36:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 23:36:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 24 Sep 2020 23:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIZ38k6X4kcVucpI0xUZj2WNaCv5u1DMF/OjpUXdijLq/696iYwv3N9fxDrJmxZL2uL2vUQ6/Ya8NHXnyTk3SZoUQM1LK5fzW+ACQ17CyzWaocnHg7dDjAFvR4EUywxDyP6SoaFDl9oPPynEnHkSq1XaAhZlAA3bWs6PFqZeEP5d6e6zZTtpxFbXiz2EiBzO0zkLqRAD3dxPtWxeAc/KehrRh5Cc2CuIona2iPudWE8RF4re0vDPjz6+buvaYajv0Vy0DGqP2ZApx6OG8AxHfivMxgbOLCQAwnfwXGsH3Qys37SQeKnDNFVZU1Hzy1oyt0KRU2wiHCxNZ2VgVPrZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVtQdUDyDSdKfY++4nCaXp+MEVgR1IOotMb1O6XxAc0=;
 b=fB4uI5RhOyXlEBpjjg/W0cJkTGdSObf0nCJf99593QmGhXahByuQPx49+k6r0/0o+0xoA7fZvzrwBmQEesgtVPTD3iRoWjQ+itexhB8zLMBpl6wC5wqBMSJT4aFI0ssVontX0Y0+c1qcPWP63AEi5x73d+dXBP55IvHfAe7RcEx+BPDorhrvSCS/kr4DzQwHGeU3C+OAc/qvV2IOsApXj0jRp/aD4ypaihdv1HnUNjaDaLiN8WISHx9xZu9z0KIYSrPlEamhSYRTrbxYYT5HiJqqJJ1IZFyrK2i8x6KrFRKKbEgWMYmW8jY/Q6R9AJzx9jA3nHEwAyoWyG+Uw98mQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVtQdUDyDSdKfY++4nCaXp+MEVgR1IOotMb1O6XxAc0=;
 b=ZAzDjda2/ZYGCbh5VK8Mhiiszb9vS10Noa3s6CjFeoZEyIHC7qXYKtRLztfrACf2wPc+QawcTPHmRn2v6DkVmfe3XCiOm7jdZeB6Q0nbyD+aBB6qZBdGRjvaACGLC2ZGH1TqLXahxr8OZ8o3LLU3vY2NA9WiBkzrNFj4REtOgeA=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3486.namprd11.prod.outlook.com (2603:10b6:805:c5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 25 Sep
 2020 06:36:30 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::ecf3:84c8:5f1e:c734]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::ecf3:84c8:5f1e:c734%7]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 06:36:30 +0000
From:   <Viswas.G@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>, <Viswas.G@microchip.com.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>
Subject: RE: [PATCH 0/4] pm80xx updates
Thread-Topic: [PATCH 0/4] pm80xx updates
Thread-Index: AQHWkwIBMX3DgDfLbUixUJOxa5CRLal439+AgAAFZxA=
Date:   Fri, 25 Sep 2020 06:36:30 +0000
Message-ID: <SN6PR11MB3488CDC89E8641FC744550719D360@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
 <CAMGffEmyy7-kKL35qY5Ei1BW=L8cXb2qegb8x9=1xgO2-PD7Vw@mail.gmail.com>
In-Reply-To: <CAMGffEmyy7-kKL35qY5Ei1BW=L8cXb2qegb8x9=1xgO2-PD7Vw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [43.229.88.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86ef007a-ab8f-4baf-6a43-08d8611d5686
x-ms-traffictypediagnostic: SN6PR11MB3486:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3486331EB9F6F4032B780D3E9D360@SN6PR11MB3486.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S8YnWf/kV6krFLAJhJ0gbN+HWe8yKM5WYXM6Lz6iI2GTG36hQ6juka+DALd5VAKKVjeLiWj7Gn+fwzmUhcVlIZNvoIQOH3DWYwV3MJjPROmH9TVtfdlwga2yCCz7IKjYDhM2y/9OgoA32ApBM1AS778y++hzNIGc2/JNBt0QgM0TBa302cplxbiUPk7+1Ok3tX4E67Qi3wYh/l8nmUJKQ7a6Ml6wD4n+4q5sddjQ4swP6ekY7k3eK2ngeTokKyxJo2VFcwEjC7mG5uQ8V22pjNlKvqW9LWZVef4hBu2dakBMeVXPRg8yYyzQ1CZtcFuA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(53546011)(54906003)(186003)(55236004)(7696005)(4326008)(2906002)(86362001)(55016002)(76116006)(110136005)(316002)(66476007)(9686003)(6506007)(8676002)(66946007)(66446008)(26005)(66556008)(52536014)(8936002)(71200400001)(64756008)(5660300002)(478600001)(83380400001)(15650500001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Y6ZqpSH7rPbDmJ9vy0DAThH+KhSh2BZoVk2CqX0ceowMmj8e3hG+pgMKWOQiX0eNk1wXSpaOQz7V2+aL4a9eUvWfSBYwtf789QgpJ4zO9490tcSyOxo4+JSVS/YcVIi5hIwB5SAPtOvd+wTJ+g3sQd/FHnH0LN8Q3Owaw/Sqy9AnrbrOJ3im6Sib+4zA6wG8CYIl/9mk1t26n2vsu7UIHqamrU+54AUq3eCnYw+N739MUSc8Vr43v16yOkIPVpJW5hUfqDKTUDvDosCNWBsMr5UJGi00bK6HT5lOpJYVw9IUu1gYtkdkF74oIah3wtWvZfSYWFmTAI9NM/cw06IZrdyAtSJ68s+cojBjj1lZ+UKhromD8ascPul0u1hlORRTITb3qUhTTnxW9xUMtpc2DmkgADu9A29FA/5jTY6CqMtjCjUcp2ZTgjl3nIYbM3yTYMngG1IXBruJc6Vsgw4+cwDWzammoIWoXJqTpEhDSq5buHHrTStymZvcMT24jTcoel5E4gmogRBx6/qvpJYtS5AgOT6d9gwTYv397dihzkiFR4u1Q32gVuL+afDRl7Mm4Iz1seDykHiuNlz71VQCt6Xr2g+DSp1WmdxtDCOfndwCOCMJxPDOG9L6AZYklHbGebhxYDdfYolnui4iq26P5w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ef007a-ab8f-4baf-6a43-08d8611d5686
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 06:36:30.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lR+hZPP+7gBJzlNkuRRYrABwyf9ABx7nN09OyUctDTNZc41kmTM26CGY5xGfxzYz6mJbZKeW7V8c9BWUJHWezw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3486
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SSBjb3VsZCBzZWUgYmVsb3cgcmVzdWx0cyBpbiBteSB0ZXN0IHNldHVwLg0KDQpmaW9fc3FyZF9i
czUxMl9xZC50eHQ6ICByZWFkOiBJT1BTPTEwMDBrLCBCVz00ODhNaUIvcyAoNTEyTUIvcykoMjgu
N0dpQi82MDEyM21zZWMpDQpmaW9fc3FyZF9iczY0a19xZC50eHQ6ICByZWFkOiBJT1BTPTM3LjBr
LCBCVz0yMzc3TWlCL3MgKDI0OTNNQi9zKSgxMzlHaUIvNjAwMDBtc2VjKQ0KZmlvX3Nxd19iczI1
NmtfcWQudHh0OiAgd3JpdGU6IElPUFM9NDMxMCwgQlc9MTEwMk1pQi9zICgxMTU2TUIvcykoNjYu
MkdpQi82MTUzMW1zZWMpOyAwIHpvbmUgcmVzZXRzDQpmaW9fc3F3X2JzNGtfcWQudHh0OiAgd3Jp
dGU6IElPUFM9MjE2aywgQlc9ODQ2TWlCL3MgKDg4OE1CL3MpKDQ3LjNHaUIvNTcxODltc2VjKTsg
MCB6b25lIHJlc2V0cw0KDQpXaXRoIHBhdGNoZXM6DQoNCmZpb19zcXJkX2JzNTEyX3FkLnR4dDog
IHJlYWQ6IElPUFM9MTUzOWssIEJXPTc1Mk1pQi9zICg3ODlNQi9zKSg0NC4yR2lCLzYwMTc0bXNl
YykgID0+ICs1My45JQ0KZmlvX3NxcmRfYnM2NGtfcWQudHh0OiAgcmVhZDogSU9QUz0zMC45aywg
Qlc9MTk0Nk1pQi9zICgyMDQxTUIvcykoMTE0R2lCLzYwMDAwbXNlYykNCmZpb19zcXdfYnMyNTZr
X3FkLnR4dDogIHdyaXRlOiBJT1BTPTQzMDksIEJXPTExMDJNaUIvcyAoMTE1NU1CL3MpKDY2LjNH
aUIvNjE2MDJtc2VjKTsgMCB6b25lIHJlc2V0cw0KZmlvX3Nxd19iczRrX3FkLnR4dDogIHdyaXRl
OiBJT1BTPTMwMGssIEJXPTExNzRNaUIvcyAoMTIzMU1CL3MpKDY4LjBHaUIvNTkzNTVtc2VjKTsg
MCB6b25lIHJlc2V0cyA9PiAgKzM4JQ0KDQpSZWdhcmRzLA0KVmlzd2FzIEcNCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaW5wdSBXYW5nIDxqaW5wdS53YW5nQGNsb3Vk
Lmlvbm9zLmNvbT4NCj4gU2VudDogRnJpZGF5LCBTZXB0ZW1iZXIgMjUsIDIwMjAgMTE6NDMgQU0N
Cj4gVG86IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tLmNvbT4NCj4gQ2M6IExpbnV4
IFNDU0kgTWFpbGluZ2xpc3QgPGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgVmFzYW50aGFs
YWtzaG1pDQo+IFRoYXJtYXJhamFuIC0gSTMwNjY0IDxWYXNhbnRoYWxha3NobWkuVGhhcm1hcmFq
YW5AbWljcm9jaGlwLmNvbT47DQo+IFZpc3dhcyBHIC0gSTMwNjY3IDxWaXN3YXMuR0BtaWNyb2No
aXAuY29tPjsgUnVrc2FyIERldmFkaSAtIEk1MjMyNw0KPiA8UnVrc2FyLmRldmFkaUBtaWNyb2No
aXAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvNF0gcG04MHh4IHVwZGF0ZXMNCj4gDQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGtub3cNCj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGkgVmlzd2FzLA0K
PiBPbiBGcmksIFNlcCAyNSwgMjAyMCBhdCA4OjA2IEFNIFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNy
b2NoaXAuY29tLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBWaXN3YXMgRyA8Vmlzd2Fz
LkdAbWljcm9jaGlwLmNvbT4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggc2V0IGluY2x1ZGVzIHNvbWUg
ZW5oYW5jZW1lbnRzIGluIHBtODB4eCBkcml2ZXIuDQo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoZXMu
IHRoZSBmaXJzdCBhbmQgM3JkIG9uZSwgc2VlbXMgdG8gYmUgcGVyZm9ybWFuY2UNCj4gaW1wcm92
ZW1lbnQsIGNhbiB5b3Ugc2hhcmUgeW91ciBwZXJmb3JtYW5jZSBudW1iZXI/DQo+IA0KPiANCj4g
Pg0KPiA+IFZpc3dhcyBHICg0KToNCj4gPiAgIHBtODB4eCA6IEluY3JlYXNlIG51bWJlciBvZiBz
dXBwb3J0ZWQgcXVldWVzLg0KPiA+ICAgcG04MHh4IDogUmVtb3ZlIERNQSBtZW1vcnkgYWxsb2Nh
dGlvbiBmb3IgY2NiIGFuZCBkZXZpY2Ugc3RydWN0dXJlcy4NCj4gPiAgIHBtODB4eCA6IEluY3Jl
YXNlIHRoZSBudW1iZXIgb2Ygb3V0c3RhbmRpbmcgSU8gc3VwcG9ydGVkIHRvIDEwMjQuDQo+ID4g
ICBwbTgweHggOiBEcml2ZXIgdmVyc2lvbiB1cGRhdGUNCj4gVGhhbmtzDQo+ID4NCj4gPiAgZHJp
dmVycy9zY3NpL3BtODAwMS9wbTgwMDFfY3RsLmMgIHwgICA2ICstDQo+ID4gIGRyaXZlcnMvc2Nz
aS9wbTgwMDEvcG04MDAxX2RlZnMuaCB8ICAyNyArKystLQ0KPiA+IGRyaXZlcnMvc2NzaS9wbTgw
MDEvcG04MDAxX2h3aS5jICB8ICAzOCArKystLS0tDQo+ID4gZHJpdmVycy9zY3NpL3BtODAwMS9w
bTgwMDFfaW5pdC5jIHwgMjIwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0NCj4gPiAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmggIHwgIDE1ICsrLQ0K
PiA+IGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jICB8IDEwOSArKysrKysrKysrLS0t
LS0tLS0tDQo+ID4gIDYgZmlsZXMgY2hhbmdlZCwgMjUzIGluc2VydGlvbnMoKyksIDE2MiBkZWxl
dGlvbnMoLSkNCj4gPg0KPiA+IC0tDQo+ID4gMi4xNi4zDQo+ID4NCg==
