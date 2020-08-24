Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1291EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0AA2067C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JaQIw1hM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MYFGQOV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgHXGt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 02:49:58 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20348 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHXGt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 02:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598251797; x=1629787797;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=OCaQ1L0rE8+lucgr4mxzt1OBRm5lESD/FQMPKgvaDwI=;
  b=JaQIw1hM5GvqmCFv+S0atmC3kczkGWNbexiQN7LMiKzUHTUFpyFWaktI
   ToF0Sah2jSvOxe8+kuxfnEPps5seVUMMtAlvzy26esk1uRyHa4MEBZTWy
   yCTgyN38s0JXdfUYirO+d9W5300oVPuevsUfoLTRIzCy2GNwWRNVVgCvF
   6PClRYAptNtx09KPXY+ZruF8tinrGZzKymagDFG8JmqROc6V+u2/QV69J
   tIrKD4PDkWAE8eHN3qart1PFWy0Eu+gmTIx/Xj5MH7KoNDwzyTViXUz5R
   49Z4CsMVhqWvh/pfx02I2XcgJ+LtuUVkQfrs0ArwozY5sfiABZH45GkpJ
   w==;
IronPort-SDR: zL8IGlc2hjlCa6b3I4EGsjmi02okL7NzBv/e4ehzZWI3wEE+mrBpd+eRA20qyU06oE1xwLKHWI
 LpUHy94lyieKE68k19Kggd3nzRCWZg5e0gBICihB1l+MuNUn71cHX6WmbhmSW7SOaDzbRCFVL/
 OV5KhmvSjWTqlN4f/MPlO49kEW9glI1+8uE7S230/y8TsCLnLLkdlsKuL8k2WAWv4vhaiv0TwM
 nZs05X0ypC4bwlOmcU0xfXTn7kDUAOawULTPmP2PVWAWs6i3CjtYxz+Lwqqf31s0D9VW5GlDoI
 VO8=
X-IronPort-AV: E=Sophos;i="5.76,347,1592841600"; 
   d="scan'208";a="145666772"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2020 14:49:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5AmtxY4do2DpwLAQhwquQDIbcVpszCiGrC6VbYdmyvpzEXWkc7nAUMnWcnIxVsKZbbQh3L2KNUcPj4fbBDaq2VnmIGE2OyWIpP0xfJZoIr7lP44R/sozt9TNEoRvhnOqIRJs+ko12brOGGxhifV8O3z0wXEeVcPIouMRWBbcNJAAY7O8ZZojnUhZ5q7XYPxV9hlLKoI8OsBClNo9wb+OCNRtafcT6fXyXukFAHW8IZtwLq0P7jTwegPda7XuiBYz0078QbJYWs7c90ePoVpQzOdQ69c04FuP7R20LBDx45KXzakK/N/ee8tsbwmjExncYiWfkYRE93O36s6TOLzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCaQ1L0rE8+lucgr4mxzt1OBRm5lESD/FQMPKgvaDwI=;
 b=mBe8nlYQKX5tLiv3ukQP0RL3fGeS7WpMbbDtn5ZbDTA63ZSId9mFs+bVDmrK+53/nQ7oryxpbJbHgVqJ56t+qUf3emVpv4m/yBJ1WlUZ1XkJe5UzMpn/skab1BbTUjpkho5FFFeHludsqvcSe9R+dL+Ur/IF2NfOnL2k6RVqULO78J2K9BhQhrCMLntFyfuZ7uGxzV9+ANapcoEsQT7X2jiY9T6Xztig/+KCVyikMaVlmn05IMs3FCXTmyRcHQgdLnQaHSONbfkqkD4RN3ly6F/HroX1geM5gOxyvAphBflSiw/KudReThsW9PW1//+OzXSvTiBLkI//AJJOygd8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCaQ1L0rE8+lucgr4mxzt1OBRm5lESD/FQMPKgvaDwI=;
 b=MYFGQOV1f4UeGlDAe2DdyOEhg7sY4zsXZGUN/Ny0up0+BAdDWOwB3GdQF87JeCknB9VMUZmEVlEVXzqibe5fNbodbFjRzd3VMkex8tlr8S5huCFiQy5bn0xuZvfccJepmtB0P1nH4G+mr6p0PmULXzlphBxjHd2Z4qnaEJPehcY=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6453.namprd04.prod.outlook.com (2603:10b6:a03:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Mon, 24 Aug
 2020 06:49:52 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 06:49:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [PATCH v2 1/2] ufs: introduce skipping manual flush for wb
Thread-Topic: [PATCH v2 1/2] ufs: introduce skipping manual flush for wb
Thread-Index: AQHWeb+ivATpbWQ0qECT5CjpyiHj9KlG0WXg
Date:   Mon, 24 Aug 2020 06:49:52 +0000
Message-ID: <BY5PR04MB6705FA7767394898B21A4745FC560@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <cover.1598236010.git.kwmad.kim@samsung.com>
        <CGME20200824023812epcas2p13703641720a1a031e4b0157b224e7ec3@epcas2p1.samsung.com>
 <62ef1c22df6e3fb3c7fa532523b2cf437cd4fcbc.1598236010.git.kwmad.kim@samsung.com>
In-Reply-To: <62ef1c22df6e3fb3c7fa532523b2cf437cd4fcbc.1598236010.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad04d226-5b50-4de9-97ac-08d847f9e781
x-ms-traffictypediagnostic: BY5PR04MB6453:
x-microsoft-antispam-prvs: <BY5PR04MB6453E10DA32525766FE91556FC560@BY5PR04MB6453.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sioI5xP8/pEyYKwhMz3zPsCcgMr+2Qk5b8iEAp08kZDbz0R+04AX7UzziTrYMl+oFpDuVaQhSjX7BafMZq3FL/slORtYnPjfkUGhgRoCy1uVNHHOqFVy7HtLg/OM4sIZ7koJVcrz5/bjOSowxCPwlTWlplNAaQU6gBCkUAcUOnBp3/eJBRcaF6CWx4vSdmtPA1X+B04D4cgU7gQdtjOqAoonGfY4e2tsjhzUTTYd+EdSqSVkvz1/6S5a2tVN08fX4Vc4ObV7Lu8u8E4Ji6a0L15xUyoyc21gWaviiKhrV8tAppnPh2HIkA4zEwDq6GwY5vz7zsg2W8BAxh+ur0hi1OI448HOr4Cb06VlEzUXA0a0ebaM2HeglXgNMjr1ZBUo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(7696005)(71200400001)(5660300002)(33656002)(7416002)(26005)(6506007)(8936002)(52536014)(186003)(8676002)(64756008)(66446008)(66556008)(66476007)(86362001)(55016002)(2906002)(478600001)(66946007)(9686003)(76116006)(110136005)(316002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UFSmSx/3UDhMgGdSa6VoxWxvRVSCvJ+2MRinOKNxk79vUqPGMkMx7x1vhoMOs2ZpcEDdfn5vLb5Q+mTKcc81RLsAYUvCorW8SGqYMGy/1sphx1nYyL7dNaKsggbFmnzNYCbEMovGNLyAN39H+RyvrZjRYHY0Pxv+yaVtG9tHaBbQm7blDNP7tWy2IKxraJRABY+iHAoESzDw00nXe9yZAkDf/qvIGyNDM5B9QCIFt8imyjWLSi8ByWPMNfd5v2g3Kgu9MDUPzLGA8B5Xl3hK6QIhLBWf8icTZzotbLtwnCuLJw4QEKLFPgAlsUrunzGKC4vcpWKaft5HzOVAXDL2VszIdH9MYggL2j3ftClSrwl2j8zDgslAo+0OSU+xssPUlQPt8rCaEdwmbsgdhnZbHkm5tKTGGowRMomRmCoAbpktqPeUGdW2ViP7ymN+O/VaCyCOcFGkI5JwM3elqLEpP0YVpw5XMWvIO1/ydv9q1nrZgCHXRyh1NEjIsJgTUkjAL/dkbx9Pri3/pW30/N8HlTByX4ijcUSqdKAGzfoFiL/vPSYjG4nkngYfVUo55AEao7DTXrIqrB1B6uPlqA6CW0N5YHR7jRayGFdQaMQSEcps8Rlnc297/u6i7dCr18I8PAeZvB/txZMw9dYtIO6NNQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad04d226-5b50-4de9-97ac-08d847f9e781
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 06:49:52.7402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Crth+q2ExkmepfLYv5vK8Lccb89+EWmE3PVCteWzo+FmY1Dp+jSD40Z9ZTnrlv7twnHJPVcQHdK+7X5Y9npQYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6453
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gV2UgaGF2ZSB0d28ga25vYnMgdG8gZmx1c2ggZm9yIHdyaXRlIGJvb3N0ZXIsIGku
ZS4NCj4gZldyaXRlQm9vc3RlckVuLCBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hFbi4NCmZXcml0
ZUJvb3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBhbmQgZldyaXRlQm9vc3RlckJ1ZmZl
ckZsdXNoRW4uDQoNCj4gSG93ZXZlciwgbWFueSBwcm9kdWN0IG1ha2VycyB1c2VzIG9ubHkgZldy
aXRlQm9vc3RlckJ1ZmZlckZsdXNoRW4sDQpVc2VzIG9ubHkgZldyaXRlQm9vc3RlckJ1ZmZlckZs
dXNoRHVyaW5nSGliZXJuYXRlDQoNCj4gYmVjYXVzZSB0aGlzIGNhbiByZXBvcnRlZGx5IGNvdmVy
IG1vc3Qgc2NlbmFyaW9zIGFuZA0KPiB0aGVyZSBoYXZlIGJlZW4gc29tZSByZXBvcnRzIHRoYXQg
Zmx1c2ggYnkgZldyaXRlQm9vc3RlckVuIGNvdWxkDQpmbHVzaCBieSBmV3JpdGVCb29zdGVyQnVm
ZmVyRmx1c2hFbiBjb3VsZA0KDQo+IGxlYWQgcmFpc2UgcG93ZXIgY29uc3VtcHRpb24gdGhhbmtz
IHRvIHVuZXhwZWN0ZWQgaW50ZXJuYWwNCj4gb3BlcmF0aW9ucy4gU28gd2UgbmVlZCBhIHdheSB0
byBlbmFibGUgb3IgZGlzYWJsZSBmV3JpdGVCb29zdGVyRW4uDQpvcGVyYXRpb25zLiBGb3IgdGhv
c2UgY2FzZSwgdGhpcyBxdWlyayB3aWxsIGFsbG93IHRvIGF2b2lkIG1hbnVhbCBmbHVzaC4NCg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4N
Cj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMyArKysNCj4gIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmggfCA1ICsrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IGVkMDMwNTEuLjdjNzlhOGYgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuYw0KPiBAQCAtNTI3Nyw2ICs1Mjc3LDkgQEAgc3RhdGljIGludCB1ZnNoY2Rf
d2JfdG9nZ2xlX2ZsdXNoX2R1cmluZ19oOChzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLCBib29sIHNl
dCkNCj4gDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQgdWZzaGNkX3diX3RvZ2dsZV9mbHVzaChzdHJ1
Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSkNCj4gIHsNCj4gKyAgICAgICBpZiAoaGJhLT5x
dWlya3MgJiBVRlNIQ0lfUVVJUktfU0tJUF9NQU5VQUxfV0JfRkxVU0hfQ1RSTCkNCj4gKyAgICAg
ICAgICAgICAgIHJldHVybjsNCj4gKw0KPiAgICAgICAgIGlmIChlbmFibGUpDQo+ICAgICAgICAg
ICAgICAgICB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2VuYWJsZShoYmEpOw0KPiAgICAgICAgIGVsc2UN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5oDQo+IGluZGV4IGU1MzUzZDYuLmNmYWZkNmUgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
aA0KPiBAQCAtNTExLDYgKzUxMSwxMSBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KPiAgICAgICAg
ICAqIE9DUyBGQVRBTCBFUlJPUiB3aXRoIGRldmljZSBlcnJvciB0aHJvdWdoIHNlbnNlIGRhdGEN
Cj4gICAgICAgICAgKi8NCj4gICAgICAgICBVRlNIQ0RfUVVJUktfQlJPS0VOX09DU19GQVRBTF9F
UlJPUiAgICAgICAgICAgICA9IDEgPDwgMTAsDQo+ICsNCj4gKyAgICAgICAvKg0KPiArICAgICAg
ICAqIFRoaXMgcXVpcmsgbmVlZHMgdG8gZGlzYWJsZSBtYW51YWwgZmx1c2ggZm9yIHdyaXRlIGJv
b3N0ZXINCj4gKyAgICAgICAgKi8NCj4gKyAgICAgICBVRlNIQ0lfUVVJUktfU0tJUF9NQU5VQUxf
V0JfRkxVU0hfQ1RSTCAgICAgICAgICA9IDEgPDwgMTEsDQo+ICB9Ow0KPiANCj4gIGVudW0gdWZz
aGNkX2NhcHMgew0KPiAtLQ0KPiAyLjcuNA0KDQo=
