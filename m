Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D11C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 06:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26AEA20775
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 06:39:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WhXNzoOX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TDD1Bpc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgF3Gjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 02:39:31 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24214 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgF3Gjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 02:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593499171; x=1625035171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3P4UfINF8C9axARtb/GMUxN6zYO3EEmM0buk8vMYZVk=;
  b=WhXNzoOXb1NS5HZ1xrxwdH0AECn02K6hWivQVpnATUhoElXDMQKMZi+B
   gF1pZl3HJb2MT/35SkX0US7RsyiQnnji9zD5KkvEwF3/mdxnVQ4NHrTvZ
   epary66pEiRcsYHyn1szqBGtzum6AeaqOyz8oS3OrypHiYsYP0zUCsIdi
   Kzj7efWl7ghoYyPYmyJeF6G/douchyLUupiQr1m0zc8+LmGuWWqhAG6Jj
   odBXdO4YHdOAKnOkgv0L5FyPuebEVgClYdiJ3iiLOmuBGiwLMSovSosss
   op058VdJapMIeEPWBiWItCtotNEcu3qVhTu7FEHXkBiu3UTYu+WyLtKYe
   w==;
IronPort-SDR: 6mG4V4u4OuDL7WtpoxlGmnfip82XhEGLt+OuZ+zbsCcZnwADIdeh1BaXye3+LaIXw4BC9Hufhx
 8Rf8eJyUK2GvYxrvxPiZuT66hMAA7wdn++DCBC/03WiWrjprsbJRLZVLRkoNyqn2TWmoC1qVbM
 WLu3aNTclkxrI6y/w7Pn2vOZlp1/O9EnO0y96kdWu3W6FwrBOdyK7FDu6T+6tN6a77qiFVvxnp
 gNaF4VOo/4MSVSKR1iPvVADvXYCgozXIL5dBt7Kgr+gCf7+1UdbnoE1miQvvjbFqBPDE+Gifmu
 ti0=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="145572436"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 14:39:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKoxohRKXRDddJAqEKwR5ox01baEEdqtmiorihej/lTImkIWW9rLTBja0bkltyE7ySc0tveLlkXT8+7dCKJMaXJkNXBAX7vqQr/It/o720Z2epefKU511pkO6VnHYtRcHcqUKgj9U5OkTtBCb1nSklNxmWWvIx5uWMEqF0YVjgKlKX9U9ytMkBRpq1XB9nAa09WyHP0BUYzWTaScYtpyg3yc88KLrgNSthi1DdZgHYCB2ZUi8mIrxXi/maURMagB+pwDx2WITGAVWuOdEhKX1fiFVkWkwLgPmi/4dq5o0LjmhqrXR6UmFB8W3hsU+wE/CBoyyzY8XIl9sM/99OPVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P4UfINF8C9axARtb/GMUxN6zYO3EEmM0buk8vMYZVk=;
 b=Vs4sZO1pgJqnkjmrePM6bcO5fW14YsXqtyjTIZ5MBE7efvuGHDgvUqeZ77oDE+GDslbivnf+AqhAxUGvrYRVZaYQIzLlc1cBV8qMXVWJeu23gm3Jwyyzx4/HlF+LHF6VgoB079dEd3z0KdvKqWaNXNgDF4obIQygYKIvBxjt1B9Wfx3GZKhP9HDVWoOvkCFqtsXMUbJvGOgUc2Lb/BY5BQjXZs5vsBqSzFh0y+o/QpqLAh4fGO9RPa3R35ajkiC0bggIBpiMBjTnqI3rsw6Xh1bp+uJt1v0Rcoa2eWpZzRdnyyv/EGDBXItT50gwPk3fMlM6bkfvEQjBrAWU9MoOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P4UfINF8C9axARtb/GMUxN6zYO3EEmM0buk8vMYZVk=;
 b=TDD1Bpc/kxOYmntW+vKNaJmJulXw4cfR+dxISwAMwrPsHyzdrHmB4I1kvemilKTSGb8+u+IYtuEVxO0TsOKBcAZ0wDWlPw/Ve5K9vd96wzLGfw9ZghZwylCr2FWHJ30Ok2ZBcXYcfycsy4h2Jt7CeyD0GvZ9DYywEFslfdSyV9M=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3919.namprd04.prod.outlook.com (2603:10b6:805:4a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 06:39:27 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 06:39:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Bean Huo <huobean@gmail.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Topic: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Index: AQHWSQaiS38tkGk5ikmxTYEvPlxKOqjt/IuAgAEq2wCAAFZqgIAA5UQAgABZYwA=
Date:   Tue, 30 Jun 2020 06:39:27 +0000
Message-ID: <SN6PR04MB46409E7CE538F158387615A6FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
        <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
 <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
In-Reply-To: <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb64fa05-ecc2-412b-e4bd-08d81cc0561e
x-ms-traffictypediagnostic: SN6PR04MB3919:
x-microsoft-antispam-prvs: <SN6PR04MB3919BF482A6F7C08BADDC93BFC6F0@SN6PR04MB3919.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0bbHGw2RB10e7B5hZ5HQk1lG1KDbC0T+RC2vtP93KUcJNiaqZO7b+Hwb3osAdDP7/J34pbCWImLoIGg6JSRkKo8Sed3l5qiB3H0DFy5Bo7MNJ82v3UM4ocAQuGiaD/FVIxg1exn/Z96PZMw+cMxOvU6Tg4E0b+1rOf52EH808c8bu5AFJbCqVKzWYSJHvrFG3D15iV8YAx7gIwjrKA3DFVTB301uvUNHxhvvamMNfuS9texKyUYhiv/WIkcOrWWysFgDVBcofdCEqmwXLTTxEtmLH3CeftednhovZ105cqruvf+MXsNaeXgMKIEAycvuPlHCuGEjJt/5rFHw2D1DN4MgmfH0JdKLtebCc+m0JXY0qs2L4/443QIR4M8LDJ62PgUZiq1fPO1OjkGHdnLbhd03FZgK2Z2x+cD+fazpeMmFc+6b4w1LABms1h8Gb3WhboHo3r5rEvkCGTFsDvBCLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(66946007)(7416002)(8676002)(7696005)(64756008)(5660300002)(76116006)(26005)(66446008)(86362001)(71200400001)(52536014)(6506007)(8936002)(66476007)(186003)(66556008)(33656002)(110136005)(54906003)(4326008)(2906002)(316002)(83380400001)(966005)(9686003)(55016002)(478600001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 43qS2KoCm7nEIf1hpRh2wi83DMlfq9NYj8YUlCXp2Vo8ouQO7K6brxOzQs7LOp5ZRQF5/r/YkStrjLbccnzHd7qpmQxhBb6eVgdwvcxIy/dLQHLo6X98iu1sRy7li3VP730NJs1/ngHGMWAi0TlxS2Vg3EnftOSJhFz2mHPUuggQMep0i9z59HGFJW2jEWiKHAKqrteHYxI/mRs6potKF6GXWJZ0nX8iEhqkXXDSCXJ2smdyr6aaAzk9wCa7eBYQPZcM0qt3F/sjq3voyjUhq/o7jPPwK8l/k4JCOnIYaeh34IVe8R43giMxhGoFZYaSaSd3EA29+jSqpWe8qwWUU/qLD5tN9rdL51xo7500ogfB3JNJW/xsv2LP145T+FE6G18RNMVtOsq/5ClfXg6853EsBTzO1x4LDmbp6r2hkOIIrMEnGi8qZd4/L9yFM3+CNb3bL2lLnyfLjzuQWdFZ6jaJwCiZUhiGFIvPpXu17Tag72LnhUyUB9k3noAhpq8P
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb64fa05-ecc2-412b-e4bd-08d81cc0561e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 06:39:27.5409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5KOcoFykZpxN7tjxc8XF6fuifUuzvJ6bqQY9fYnODyZGSUh68zm3zEXvsQ2TvV2gz57Ypt90u6wq5b+WSBAwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3919
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQogDQo+IA0KPiBIaSBCZWFuLA0KPiA+IE9uIE1vbiwgMjAyMC0wNi0yOSBhdCAxNToxNSAr
MDkwMCwgRGFlanVuIFBhcmsgd3JvdGU6DQo+ID4gPiA+IFNlZW1zIHlvdSBpbnRlbnRpb25hbGx5
IGlnbm9yZWQgdG8gZ2l2ZSB5b3UgY29tbWVudHMgb24gbXkNCj4gPiA+ID4gc3VnZ2VzdGlvbi4N
Cj4gPiA+ID4gbGV0IG1lIHByb3ZpZGUgdGhlIHJlYXNvbi4NCj4gPiA+DQo+ID4gPiBTb3JyeSEg
SSByZXBsaWVkIHRvIHlvdXIgY29tbWVudCAoDQo+ID4gPiBodHRwczovL3Byb3RlY3QyLmZpcmVl
eWUuY29tL3VybD9rPWJlNTc1MDIxLWUzODU0NzI4LWJlNTZkYjZlLQ0KPiAwY2M0N2EzMWNkZjgt
DQo+IDZjN2QwZTFlNDI3NjJiOTImcT0xJnU9aHR0cHMlM0ElMkYlMkZsa21sLm9yZyUyRmxrbWwl
MkYyMDIwJTJGNiUNCj4gMkYxNSUyRjE0OTIpLA0KPiA+ID4gYnV0IHlvdSBkaWRuJ3QgcmVwbHkg
b24gdGhhdC4gSSB0aG91Z2h0IHlvdSBhZ3JlZWQgYmVjYXVzZSB5b3UgZGlkbid0DQo+ID4gPiBz
ZW5kDQo+ID4gPiBhbnkgbW9yZSBjb21tZW50cy4NCj4gPiA+DQo+ID4gPg0KPiA+ID4gPiBCZWZv
cmUgc3VibWl0dGluZyB5b3VyIG5leHQgdmVyc2lvbiBwYXRjaCwgcGxlYXNlIGNoZWNrIHlvdXIg
TDJQDQo+ID4gPiA+IG1hcHBpbmcgSFBCIHJlcWV1c3Qgc3VibWlzc2lvbiBsb2dpY2FsIGFsZ29y
aXRoZW0uIEkgaGF2ZSBkaWQNCj4gPiA+DQo+ID4gPiBXZSBhcmUgYWxzbyByZXZpZXdpbmcgdGhl
IGNvZGUgdGhhdCB5b3Ugc3VibWl0dGVkIGJlZm9yZS4NCj4gPiA+IEl0IHNlZW1zIHRvIGJlIGEg
cGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgYXMgaXQgc2VuZHMgYSBtYXAgcmVxdWVzdA0KPiA+ID4g
ZGlyZWN0bHkuDQo+ID4gPg0KPiA+ID4gPiBwZXJmb3JtYW5jZSBjb21wYXJpc29uIHRlc3Rpbmcg
b24gNEtCLCB0aGVyZSBhcmUgYWJvdXQgMTMlDQo+ID4gPiA+IHBlcmZvcm1hbmNlDQo+ID4gPiA+
IGRyb3AuIEFsc28gdGhlIGhpdCBjb3VudCBpcyBsb3dlci4gSSBkb24ndCBrbm93IGlmIHRoaXMg
aXMgcmVsYXRlZA0KPiA+ID4gPiB0bw0KPiA+ID4NCj4gPiA+IEl0IGlzIGludGVyZXN0aW5nIHRo
YXQgdGhlcmUgaXMgYWN0dWFsbHkgYSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudC4NCj4gPiA+IENv
dWxkIHlvdSBzaGFyZSB0aGUgdGVzdCBlbnZpcm9ubWVudCwgcGxlYXNlPyBIb3dldmVyLCBJIHRo
aW5rDQo+ID4gPiBzdGFiaWxpdHkgaXMNCj4gPiA+IGltcG9ydGFudCB0byBIUEIgZHJpdmVyLiBX
ZSBoYXZlIHRlc3RlZCBvdXIgbWV0aG9kIHdpdGggdGhlIHJlYWwNCj4gPiA+IHByb2R1Y3RzIGFu
ZA0KPiA+ID4gdGhlIEhQQiAxLjAgZHJpdmVyIGlzIGJhc2VkIG9uIHRoYXQuDQo+ID4NCj4gPiBJ
IGp1c3QgcnVuIGZpbyBiZW5jaG1hcmsgdG9vbCB3aXRoIC0tcnc9cmFuZHJlYWQsIC0tYnM9NGti
LCAtLQ0KPiA+IHNpemU9OEcvMTBHLzY0Ry8xMDBHLiBhbmQgc2VlIHdoYXQgcGVyZm9ybWFuY2Ug
ZGlmZiB3aXRoIHRoZSBkaXJlY3QNCj4gPiBzdWJtaXNzaW9uIGFwcHJvYWNoLg0KPiANCj4gVGhh
bmtzIQ0KPiANCj4gPiA+IEFmdGVyIHRoaXMgcGF0Y2gsIHlvdXIgYXBwcm9hY2ggY2FuIGJlIGRv
bmUgYXMgYW4gaW5jcmVtZW50YWwgcGF0Y2g/DQo+ID4gPiBJIHdvdWxkDQo+ID4gPiBsaWtlIHRv
IHRlc3QgdGhlIHBhdGNoIHRoYXQgeW91IHN1Ym1pdHRlZCBhbmQgdmVyaWZ5IGl0Lg0KPiA+ID4N
Cj4gPiA+ID4geW91ciBjdXJyZW50IHdvcmsgcXVldWUgc2NoZWR1bGluZywgc2luY2UgeW91IGRp
ZG4ndCBhZGQgdGhlIHRpbWVyDQo+ID4gPiA+IGZvcg0KPiA+ID4gPiBlYWNoIEhQQiByZXF1ZXN0
Lg0KPiA+ID4NCj4gPg0KPiA+IFRha2luZyBpbnRvIGNvbnNpZGVyYXRpb24gb2YgdGhlIEhQQiAy
LjAsIGNhbiB3ZSBzdWJtaXQgdGhlIEhQQiB3cml0ZQ0KPiA+IHJlcXVlc3QgdG8gdGhlIFNDU0kg
bGF5ZXI/IGlmIG5vdCwgaXQgd2lsbCBiZSBhIGRpcmVjdCBzdWJtaXNzaW9uIHdheS4NCj4gPiB3
aHkgbm90IGRpcmVjdGx5IHVzZSBkaXJlY3Qgd2F5PyBvciBtYXliZSB5b3UgaGF2ZSBhIG1vcmUg
YWR2aXNhYmxlDQo+ID4gYXBwcm9hY2ggdG8gd29yayBhcm91bmQgdGhpcy4gd291bGQgeW91IHBs
ZWFzZSBzaGFyZSB3aXRoIHVzLg0KPiA+IGFwcHJlY2lhdGUuDQo+IA0KPiBJIGFtIGNvbnNpZGVy
aW5nIGEgZGlyZWN0IHN1Ym1pc3Npb24gd2F5IGZvciB0aGUgbmV4dCB2ZXJzaW9uLg0KPiBXZSB3
aWxsIGltcGxlbWVudCB0aGUgd3JpdGUgYnVmZmVyIGNvbW1hbmQgb2YgSFBCIDIuMCwgYWZ0ZXIg
cGF0Y2hpbmcgSFBCDQo+IDEuMC4NCj4gDQo+IEFzIGZvciB0aGUgZGlyZWN0IHN1Ym1pc3Npb24g
b2YgSFBCIHJlbGVhdGVkIGNvbW1hbmQgaW5jbHVkaW5nIEhQQiB3cml0ZQ0KPiBidWZmZXIsIEkg
dGhpbmsgd2UnZCBiZXR0ZXIgZGlzY3VzcyB0aGUgcmlnaHQgYXBwcm9hY2ggaW4gZGVwdGggYmVm
b3JlDQo+IG1vdmluZyBvbiB0byB0aGUgbmV4dCBzdGVwLg0KSSB2b3RlIHRvIHN0YXkgd2l0aCB0
aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBiZWNhdXNlOg0KMSkgQmVhbiBpcyBwcm9iYWJseSBy
aWdodCBhYm91dCAyLjAsIGJ1dCBpdCdzIG91dCBvZiBzY29wZSBmb3Igbm93IC0gDQogICAgdGhl
cmUgaXMgYSBsb25nIHdheSB0byBnbyBiZWZvcmUgd2UnbGwgbmVlZCB0byB3b3JyeSBhYm91dCBp
dA0KMikgRm9yIG5vdywgd2Ugc2hvdWxkIGZvY3VzIG9uIHRoZSBmdW5jdGlvbmFsIGZsb3dzLiAN
CiAgICBQZXJmb3JtYW5jZSBpc3N1ZXMsIHNob3VsZCBzdWNoIGlzc3VlcyBpbmRlZWQgZXhpc3Rz
LCBjYW4gYmUgZGVhbHQgd2l0aCAgbGF0ZXIuICBBbmQsDQozKSBUaGUgY3VycmVudCBjb2RlIGJh
c2UgaXMgcnVubmluZyBpbiBwcm9kdWN0aW9uIGZvciBtb3JlIHRoYW4gMyB5ZWFycyBub3cuDQog
ICAgIEkgYW0gbm90IHNvIGVhZ2VyIHRvIGR1bXAgYSByb2J1c3QsIHdlbGwgZGVidWdnZWQgY29k
ZSB1bmxlc3MgaXQgYWJzb2x1dGVseSBuZWNlc3NhcnkuDQoNClRoYW5rcywNCkF2cmkNCg0KDQo=
