Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE82C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 07:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38C42073E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 07:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Vga+cXFf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xjiVVBfB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgFQHIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 03:08:38 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55459 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgFQHIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 03:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592377716; x=1623913716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h23FZx+/16V7+S8slzI/m9JM+HZR6ANCdKpAcj+WB9A=;
  b=Vga+cXFfScv/WS/185Rci2O6Dle4X+ifTrGz+5Blzn8hg3SD5xdBG8ZC
   /IRtIa+cTSV0AKrgMuSmS2MNB0hbmBNQ9E9Lor57cDqkCpIyViYUuEGWT
   Ctfki1yDlGWJf1nZtmfY0VRrGA99m2P2QVG4FM0DxqC+fSypS9RiT0yIF
   kwEioPlPlGGi888dvUIcQVFuBqVMgfc953fvsd0m3MhckSeOJD4ZwC8Sk
   lyrBm2GMwKornrkkGijwaPNKQLDvfnDXiTcv1Yo5ASdASlKljP8z/6fAH
   SDObwzvqH2fAEC7djc/pAqXoR18FNGN0xg2nU3GHLV5fRslQWBabjeEnX
   g==;
IronPort-SDR: 4Z/PIsqnj9E2jmh39QSOcWWWui192qDDhElwNP5cJAlgGRsxpNbn762KFP7qIF3pZpjpRNM+d6
 4LUyWZGRbdR6ghLDTmc28GCzyXuzP/ZaVFTz+zXBnFvSFmV+hZFzkoKfBG/3WYIGait4rdVSYv
 eNU0jI4CfFPjmkSAvjE0y19WXvhWyPSppG/gZ3yNZs+3HX6M1w+CGXV8bnt0J25YXj9NvO4Rml
 xQYDJrwwShVOcuRgn3Hdu23ehIZIW50/xf+frf7lopT9CpJyBRZvUZgHVOlZPc9IJBGip9sDM8
 Vos=
X-IronPort-AV: E=Sophos;i="5.73,521,1583164800"; 
   d="scan'208";a="249375658"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2020 15:08:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Exa+DfMQG4knA787yTdrqUF2yj2vx82yUfc8vb4cY8zK8q/qaX3tfPs6hGqoiCK7AGVpH9Hqm7x9dte1/1T3VLFEGVrwr3a09gkm/tbKM/dpernYNghhCaOcNwYsNRGt1r0p1zr1Iwevbn8APySzjmfMIrnEejbRcF66GUpQzQc3srHoGeK6D3HvNoFAVnfRZovgFOXvgkJF4X1IaHaenu+/jvuJmuUdiocJGXnUXHkuIZHtpj5PJRMM77OXPZPH2BS/4oUZLjL4JY3/k5zIGXJSTb2Kfj6bGo6AdHWvHB9vX4KiaJmXfoW+1YgL9lnxEhNsFT3vEWwWQKWsloMOSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h23FZx+/16V7+S8slzI/m9JM+HZR6ANCdKpAcj+WB9A=;
 b=KpE+5eE3UOassWfZ6HVkQOKyoiMTyaTMamVH/AVr+eS7Vs960KrlWVV1NchPhNPUUg11yefi/IXSKB3CfvVyFt0VOUe3ZQnn8BGHGAVuewR528/HKk92mMxeYYwvuSbTvaUgFU2GkfkW7wkQHNE3I572GfV/UKI8dRyMjHVIBQY/7x4tKOSHPRMz2KAqwVCCIpnDhVgYCkJXqsjQP8T/ky2O7/EZvdr9LJCieWF36JNOvBSno4twq+ERawYvWbNMX6taeHA3D+Wl8i4YotRfJjtQwO6fWdpdyK3IyqUDcdpQEiIBnpyd3ItaPht07A4609DguapWLn5a/cpSOmtYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h23FZx+/16V7+S8slzI/m9JM+HZR6ANCdKpAcj+WB9A=;
 b=xjiVVBfBt04DiJlPJLFelKQ3WMfi/XfqYSoOC8VbBQ2oCRXfuykS0RHcj0GUeAvLZAhIv52rNFxPxgh8twEFFPCxy/L8CeA1gIwzg04/X3/p0xFYwDRjIzTmZ1fnHvi/9f6gYDc7/pz84QAAeOFZfSga7SVq+KZUqTPjsLZkjLQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4719.namprd04.prod.outlook.com (2603:10b6:805:ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Wed, 17 Jun
 2020 07:08:33 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 07:08:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
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
Subject: RE: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Thread-Topic: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Thread-Index: AQHWQvR/8YSWnZ32kE23vYUZ7mTDy6jcZWcQ
Date:   Wed, 17 Jun 2020 07:08:33 +0000
Message-ID: <SN6PR04MB46402D067BE2BFE003170FB8FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p8>
 <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
In-Reply-To: <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f672f931-59ae-4c5f-64bf-08d8128d3f31
x-ms-traffictypediagnostic: SN6PR04MB4719:
x-microsoft-antispam-prvs: <SN6PR04MB47199DC513D4263ED0C5B245FC9A0@SN6PR04MB4719.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TdftJEQM+YkyoRHnTFciBEm79VxsJYrl7VK/Hcfbv5DPnViYefVvNpmYo48IP+YHGMJzz8s4qJ8ct+vCXVo5fDheSx52H6EFILkP3WexGEizH2lSbdbBbqCaclzS+TuDkH6yDyKeAQjJJ4W/iOQyaZ7xcSNwSNt0R6lVdlc4sI4EL83otUT6ddanhepBfwwJr5dzKq8jGjbQHJiLY8EEJbK7oaiSWC7bjLgDhetrhnkraehjz19VF21hQ+/e9mB97uXH6KGOu8pnHzb1qXpu+2H6y1EcdW3rtdYKa7P24EzaM8avt6MyMALYrjgkPfx34RsQBafdLRCvdfgoCNEOcJ7ZURHABP9YN57LHJkEfWu1Laepb8ZhE1KTiWg/oMVY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(5660300002)(64756008)(186003)(66476007)(8936002)(66946007)(76116006)(66446008)(316002)(71200400001)(2906002)(8676002)(110136005)(66556008)(54906003)(33656002)(26005)(4326008)(478600001)(52536014)(7696005)(7416002)(83380400001)(6506007)(55016002)(9686003)(86362001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: T/prS48r+0DsSwftrFa//dXabV0SEnjrJJ50dy8n4tU+v6SfsERxgBXRMwOKfhaUhqJ2q2yUcpfzZX2U0NoQonnKDYKLkmXbWckzsoyJYks6sl2mf4d6yVuyHPp4PNOJdJqtCHcuRidUyAn73cmUDqzErQzcveTWNOBV8gBehCWZrNklPDPsXG+32fOm1dLLI98SDBYz4/utecZtZSxlHX78q84dOm6/pqCVw8ngz3RC60dvcy6tRw+/od5yMPhB/0i6SMCXr2Ecb4gzODp0mdySF1f/NNXnBcwXQWdTSvAjKoE9gKw5XB1aKXsCfK2qug4SUxGkPdJifapRJat1oYk5p+ur4h4ZV1oWO9RmrvT854WW+Wg1nC0qQ21gUnyJu93cdzTN3x1Gijs6h2FUdCICu2WqVBY4QNPl44NcLJrs8KF+p+Cb38CYamZh486WSmKoFkLs91DP5kBvg2elU3vqwcrUMtNnVCHI/9uauBQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f672f931-59ae-4c5f-64bf-08d8128d3f31
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 07:08:33.1316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zx2y7hsnsMY1vWXyzrPWDWX0xEI7tIsWGU4oAYakHs53iFNW0pU0VB0/BjsBw2/LqV7n9RU26MX/b+Z11MWsuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4719
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gVGhpcyBwYXRjaCBpcyBhZGRpbmcgVUZTIGZlYXR1cmUgbGF5ZXIgdG8gVUZTIGNv
cmUgZHJpdmVyLg0KPiANCj4gVUZTIERyaXZlciBkYXRhIHN0cnVjdHVyZSAoc3RydWN0IHVmc19o
YmEpDQo+ICAgICAgICAg4pSCDQo+IOKUjC0tLS0tLS0tLS0tLS0t4pSQDQo+IOKUgiBVRlMgZmVh
dHVyZSAg4pSCIDwtLSBIUEIgbW9kdWxlDQo+IOKUgiAgICBsYXllciAgICAg4pSCIDwtLSBvdGhl
ciBleHRlbmRlZCBmZWF0dXJlIG1vZHVsZQ0KPiDilJQtLS0tLS0tLS0tLS0tLeKUmA0KPiBFYWNo
IGV4dGVuZGVkIFVGUy1GZWF0dXJlIG1vZHVsZSBoYXMgYSBidXMgb2YgdWZzLWV4dCBmZWF0dXJl
IHR5cGUuDQo+IFRoZSBVRlMgZmVhdHVyZSBsYXllciBtYW5hZ2VzIGNvbW1vbiBBUElzIHVzZWQg
YnkgZWFjaCBleHRlbmRlZCBmZWF0dXJlDQo+IG1vZHVsZS4gVGhlIEFQSXMgYXJlIHNldCBvZiBV
RlMgUXVlcnkgcmVxdWVzdHMgYW5kIFVGUyBWZW5kb3IgY29tbWFuZHMNCj4gcmVsYXRlZCB0byBl
YWNoIGV4dGVuZGVkIGZlYXR1cmUgbW9kdWxlLg0KPiANCj4gT3RoZXIgZXh0ZW5kZWQgZmVhdHVy
ZXMgY2FuIGFsc28gYmUgaW1wbGVtZW50ZWQgdXNpbmcgdGhlIHByb3Bvc2VkIEFQSXMuDQo+IEZv
ciBleGFtcGxlLCBpbiBXcml0ZSBCb29zdGVyLCAicHJlcF9mbiIgY2FuIGJlIHVzZWQgdG8gZ3Vh
cmFudGVlIHRoZQ0KPiBsaWZldGltZSBvZiBVRlMgYnkgdXBkYXRpbmcgdGhlIGFtb3VudCBvZiB3
cml0ZSBJTy4NCj4gQW5kIHJlc2V0L3Jlc2V0X2hvc3Qvc3VzcGVuZC9yZXN1bWUgY2FuIGJlIHVz
ZWQgdG8gbWFuYWdlIHRoZSBrZXJuZWwgdGFzaw0KPiBmb3IgY2hlY2tpbmcgbGlmZXRpbWUgb2Yg
VUZTLg0KPiANCj4gVGhlIGZvbGxvd2luZyA2IGNhbGxiYWNrIGZ1bmN0aW9ucyBoYXZlIGJlZW4g
YWRkZWQgdG8gInVmc2hjZC5jIi4NCj4gcHJlcF9mbjogY2FsbGVkIGFmdGVyIGNvbnN0cnVjdCB1
cGl1IHN0cnVjdHVyZQ0KPiByZXNldDogY2FsbGVkIGFmdGVyIHByb3ZpbmcgaGJhDQo+IHJlc2V0
X2hvc3Q6IGNhbGxlZCBiZWZvcmUgdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUNCj4gc3Vz
cGVuZDogY2FsbGVkIGJlZm9yZSB1ZnNoY2Rfc3VzcGVuZA0KPiByZXN1bWU6IGNhbGxlZCBhZnRl
ciB1ZnNoY2RfcmVzdW1lDQo+IHJzcF91cGl1OiBjYWxsZWQgaW4gdWZzaGNkX3RyYW5zZmVyX3Jz
cF9zdGF0dXMgd2l0aCBTQU1fU1RBVF9HT09EIHN0YXRlDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBE
YWVqdW4gUGFyayA8ZGFlanVuNy5wYXJrQHNhbXN1bmcuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS91ZnMvTWFrZWZpbGUgICAgIHwgICAyICstDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2Zl
YXR1cmUuYyB8IDE0OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2ZlYXR1cmUuaCB8ICA2OSArKysrKysrKysrKysrKysrDQo+ICBkcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICB8ICAxNyArKysrDQo+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5oICAgICB8ICAgMyArDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDIzOCBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zY3NpL3Vm
cy91ZnNmZWF0dXJlLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2ZlYXR1cmUuaA0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvTWFrZWZpbGUg
Yi9kcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlDQo+IGluZGV4IDk0YzZjNWQ3MzM0Yi4uZmUzYTky
YjA2Yzg3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlDQo+ICsrKyBi
L2RyaXZlcnMvc2NzaS91ZnMvTWFrZWZpbGUNCj4gQEAgLTUsNyArNSw3IEBAIG9iai0kKENPTkZJ
R19TQ1NJX1VGU19EV0NfVENfUExBVEZPUk0pICs9IHRjLWR3Yy0NCj4gZzIxMC1wbHRmcm0ubyB1
ZnNoY2QtZHdjLm8gdGMtZA0KPiAgb2JqLSQoQ09ORklHX1NDU0lfVUZTX0NETlNfUExBVEZPUk0p
ICs9IGNkbnMtcGx0ZnJtLm8NCj4gIG9iai0kKENPTkZJR19TQ1NJX1VGU19RQ09NKSArPSB1ZnMt
cWNvbS5vDQo+ICBvYmotJChDT05GSUdfU0NTSV9VRlNIQ0QpICs9IHVmc2hjZC1jb3JlLm8NCj4g
LXVmc2hjZC1jb3JlLXkgICAgICAgICAgICAgICAgICAgICAgICAgICs9IHVmc2hjZC5vIHVmcy1z
eXNmcy5vDQo+ICt1ZnNoY2QtY29yZS15ICAgICAgICAgICAgICAgICAgICAgICAgICArPSB1ZnNo
Y2QubyB1ZnMtc3lzZnMubyB1ZnNmZWF0dXJlLm8NCkhvdyBhYm91dCBtYWtpbmcgaXQNCj4gIHVm
c2hjZC1jb3JlLSQoQ09ORklHX1VGU19GRUFUVVJFUykgICAgICs9IHVmc2ZlYXR1cmUubw0KU28g
dGhhdCB5b3Ugd29uJ3QgY2hlY2sgbm9uZS1ocGIgZHJpdmVyIG9uIGV2ZXJ5IHJlc3BvbnNlIGV0
Yy4NCg0K
