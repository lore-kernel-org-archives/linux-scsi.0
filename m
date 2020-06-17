Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB46C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 06:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C012071A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 06:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rhBqGoYq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ufsXArj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFQGzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 02:55:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:54465 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFQGzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 02:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592376923; x=1623912923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jXT7VJpmjxcprAz5ibWKfWO04NXazMEDAeH9gmP700g=;
  b=rhBqGoYqvWRof2st96v/RbAqKLIlYq3GTD527IWB5fSNMSQYyJ5WTgzY
   4eGIFbQazddTBiBeLeMO+3fbA8jHuvRLPmY/zX93RaXUbh/kArCEJVmhb
   QMuujGN67+BXp8gpzV0BfIpimE9YzsEIFLD5MNOlsKm5f6zhY0hxUmiZb
   S2xfCoo2dj9pMSIO9fmIKKxO7eaI5KuzcQrQcJKpCiF0VlB3iUFOYa/u/
   w1SB2xzZj6jyIr/QWEcg1TFD7tVFVsGw/h6vag7kNh+3qIbKeHoWWH1ot
   u27rfZZ1rTEM95GZ5brIcbEuWX8tWudl3sjj9r1wXxNsrdkSN4+CxXdfP
   Q==;
IronPort-SDR: vaHnAezPNtVSXamOgnhgHssGutkRfc4E3DxtXlwmsP7pnjxIefhCknO/h+Bsx0kK1/inaSCNvy
 e4lvZfMeY2wwP+rwHR6jh9DVJtneGUfAL07x4xIY5ihdHTvGm/8lvoGH7/oPZl9gikMScwjYEZ
 PxdnsOXXCx9QeSTYgGHfRoGurI92SxmP6YRWhC2RLftexlgVEx6GoDOC3Rg+l0i9iMyPLzSqRm
 hs1jzgcdIa1Vz2Xdu1JwEQqVEkGFL8UBEKz8xItZeXtKXE2Rm6FWcloqWE0xPP8ZoKh2FboZ79
 2UI=
X-IronPort-AV: E=Sophos;i="5.73,521,1583164800"; 
   d="scan'208";a="249374727"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2020 14:55:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3wtWpFDoqTlRBacwdHFeIid9Rdduoyqsj4nZ4iiVCS/2vIB1SnpasR0g9F0JnVvTsYyGwC6UXNOny2FsPEABdi3i5e/8OP+ee6qhb5IUWTAt2EdIhH03aMtEzy6PKHQtsxQuQrTiNRiAxT3aoiYNojImQXV83zYX7uzVdKFsB07KxSTLNlP3IeNf0TMHZ8Z2baOmZw3EgE88E19ns50+XALcycU+7x3HrQhqq6itM5CwVGnJNLbvzl3o5FE18pZGdBw5Ddq7c/fXY5o7bq2lHLKhYn+KOgpu3MmP4L0ndOsmmlLkPmp/ST4eM3EA8pcK60ILKmCAZ2pWcmUxscTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXT7VJpmjxcprAz5ibWKfWO04NXazMEDAeH9gmP700g=;
 b=of0VsYbPZbNE7lEMrOgAwytKQmnHxsm68P696pDIOStWkez2ZtRtWEPvtbdwo62umGtFebqheDJjZl5OZ3+ZOU+sea2Q8jhtDGot8OHbV4iXup17SPim15IaKKIVWxMNyMZf9CXlRdXM0DTkzfoFnDsfTXjymM2/qoXMQ0zKugQSh05VLPIGUQ577Q5fXSZD7E9UOfXH5iOC3zTPWfd4pmupb3gIYqAhWRB3WAI9dDk7y2o336esbuCP5z4So0qPQpJHGHR+UUNLfJw10bx0hNWj4VoXKJzUEGB5POWPvl+d5rAZVq/WiA50JR7bMFXcQnjsCisCI4AWsPCM/krR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXT7VJpmjxcprAz5ibWKfWO04NXazMEDAeH9gmP700g=;
 b=ufsXArj9pJclbkvmvTGwxySRbaP83A8LNqcpnQX/vOY9LcVO3ERESyIWngE/8Gxh7QCbkZJhzyVEYidRSzk+Tz/yfFDRCNIUOjcyzb0IsdRUgNsDEh2k5z8pddA8MDDCIIsYI6ZWYhOm6cWkA0NyjnbSqDjL88stj0yhwKDEo2g=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4349.namprd04.prod.outlook.com (2603:10b6:805:34::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Wed, 17 Jun
 2020 06:55:19 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 06:55:19 +0000
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
Subject: RE: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Thread-Topic: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
Thread-Index: AQHWQvR/8YSWnZ32kE23vYUZ7mTDy6jZpn0AgADLvwCAAe1sMA==
Date:   Wed, 17 Jun 2020 06:55:19 +0000
Message-ID: <SN6PR04MB4640EE125CF504AF9362B23FFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p6>
 <1210830415.21592275802431.JavaMail.epsvc@epcpadp1>
In-Reply-To: <1210830415.21592275802431.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: faa515a3-67c6-4146-6ef1-08d8128b65d8
x-ms-traffictypediagnostic: SN6PR04MB4349:
x-microsoft-antispam-prvs: <SN6PR04MB4349E5F8314A151FE039BC56FC9A0@SN6PR04MB4349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtwszzKF4MkOkmCByCEoLbLvLSNtsQJUiOo9FTpTWSpYJ9v97bF9b+YrogkjcZSsMfWE+UNUJECBBex9Nd12CXLql7Qug4mG/NW1zGocyywn32Etz5E6DtNk9aP8K+fPdL6iGh/xPTdYM8tUXXAz8Zb6+EmnQie1eFuX44wP5XpQKC5w7wqfo21+4gqfn6kZ4ORvWn8Xg+I6IyB3hifhgta8pETh/IvLscvFtP/IJ7Q87w1lukWZy440/Pwu41kVOfeUsrpLOYrocflCLS+w4yETZomKZcASdt3xAg/LoVnpwhKHDwFM3GTRnLKNhcvNbcPVmZe2IE43gMoYdAZpYOnMEn6EfNArfITUmEgCUbDBlIvhm6Js1JGz0yMq0B6y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(86362001)(54906003)(4744005)(52536014)(33656002)(316002)(6506007)(478600001)(7696005)(110136005)(5660300002)(26005)(8676002)(71200400001)(186003)(2906002)(66556008)(8936002)(64756008)(4326008)(66946007)(76116006)(9686003)(55016002)(66446008)(66476007)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bsjsx2KMxzlHBakmWWJDVIv1xjXeKZAXuzV5FlAqFwlFLDxGjZVUzWMEzgongj5FvGjHwbqGhGS1oRdAiNwjyhp1JG4NhOOh2cvGjCBIxUSuOu6VG1EbLaUpQ6uhQpmG6Zobv3EfCB6pf6xpDJY+0DU4c1R2ix/o28FcZizgpRRRh2gt9NN3lPL6+jPoUuAba4rMrXIvcUb55aPjuALKihOpIYFMGyO1ogUToqueZ5dyGBSofa1eTvDFBKmKqsRM9VvHrHxtBTDo2bzVr3zesPlTUx4UtsrK2+UpjAW6R6syRmoYirI3HjpjXM+29HfnrcNnJk5WIfti+AHwyrfzbsFwetADpHDSKdMriy8cOnJVbrn7qNUIYB6s0p2PWhiRsrjBtA/ACORfyg5kPl9/7CFQM7h/6PfJSObYT6PBqSvdf2vHsemgvEZo6P9aiJQnb5oVpBSzoO6LjCGdFPbZxQm5ymtyOsGINIE5JPUFUtE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa515a3-67c6-4146-6ef1-08d8128b65d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 06:55:19.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EY/nMgQ1zew3zSY6lO71g1Zv+IYwfuhP1wyJXbkywT53VASet7DN+cQZyYkFxV5f2YIZyVTnwvmz0f0+RzD6cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4349
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGksIEJlYW4NCj4gPg0KPiA+IE9uIE1vbiwgMjAyMC0wNi0xNSBhdCAxNjoyMyArMDkw
MCwgRGFlanVuIFBhcmsgd3JvdGU6DQo+ID4gPiArdm9pZCB1ZnNmX3NjYW5fZmVhdHVyZXMoc3Ry
dWN0IHVmc19oYmEgKmhiYSkNCj4gPiA+ICt7DQo+ID4gPiArICAgICAgIGludCByZXQ7DQo+ID4g
PiArDQo+ID4gPiArICAgICAgIGluaXRfd2FpdHF1ZXVlX2hlYWQoJmhiYS0+dWZzZi5zZGV2X3dh
aXQpOw0KPiA+ID4gKyAgICAgICBhdG9taWNfc2V0KCZoYmEtPnVmc2Yuc2xhdmVfY29uZl9jbnQs
IDApOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICBpZiAoaGJhLT5kZXZfaW5mby53c3BlY3ZlcnNp
b24gPj0gSFBCX1NVUFBPUlRFRF9WRVJTSU9OICYmDQo+ID4gPiArICAgICAgICAgICAoaGJhLT5k
ZXZfaW5mby5iX3Vmc19mZWF0dXJlX3N1cCAmIFVGU19ERVZfSFBCX1NVUFBPUlQpKQ0KPiA+DQo+
ID4gSG93IGFib3V0IHJlbW92aW5nIHRoaXMgY2hlY2sgIihoYmEtPmRldl9pbmZvLndzcGVjdmVy
c2lvbiA+PQ0KPiA+IEhQQl9TVVBQT1JURURfVkVSU0lPTiIgc2luY2UgdWZzIHdpdGggbG93ZXIg
dmVyc2lvbiB0aGFuIHYzLjEgY2FuIGFkZA0KPiA+IEhQQiBmZWF0dXJlIGJ5IEZGVSwNCj4gPiBp
ZiAoaGJhLT5kZXZfaW5mby5iX3Vmc19mZWF0dXJlX3N1cCAgJlVGU19GRUFUVVJFX1NVUFBPUlRf
SFBCX0JJVCkgaXMNCj4gPiBlbm91Z2guDQo+IE9LLCBjaGFuZ2luZyBpdCBzZWVtcyBubyBwcm9i
bGVtLiBCdXQgSSB3YW50IHRvIGtub3cgd2hhdCBvdGhlciBwZW9wbGUNCj4gdGhpbmsNCj4gYWJv
dXQgdGhpcyB2ZXJzaW9uIGNoZWNraW5nIGNvZGUuDQpIUEIxLjAgaXNuJ3QgcGFydCBvZiB1ZnMz
LjEsIGJ1dCBwdWJsaXNoZWQgb25seSBsYXRlci4NCkFsbG93aW5nIGVhcmxpZXIgdmVyc2lvbnMg
d2lsbCByZXF1aXJlZCB0byBxdWlyayB0aGUgZGVzY3JpcHRvciBzaXplcy4NCkkgc2VlIEJlYW4n
cyBwb2ludCBoZXJlLCBidXQgSSB2b3RlIGZvciBhZGRpbmcgaXQgaW4gYSBzaW5nbGUgcXVpcmss
IHdoZW4gdGhlIHRpbWUgY29tZXMuIA0KDQpUaGFua3MsDQpBdnJpDQo=
