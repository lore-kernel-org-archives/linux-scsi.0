Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45D6C388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 08:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B4B2071A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 08:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ie1VmUpl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j686fApg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgKCIzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 03:55:25 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:4504 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCIzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 03:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604393724; x=1635929724;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wHik0GBc1Sfdm4lcekXjkseXFDMrpMWUcWyWYjoaZBU=;
  b=Ie1VmUpl/FDv8zY/MoV8R7Xwc9ZkDLDEs1Oso1T0FAKAkTdM3X9DjryJ
   iPc07ZzooCVXPt+qH2jFBcey3fnCB1Is+nPfinbAbW2LKMCfU6mQV7EC8
   kNPc/WPtR8/6QAddotRTC1nJMZloYptkFbV0Baglzah1uYFfYLXR41GQS
   s5tgiKwk2rCPuPNK7d3gjkc2eIwhmpi1oyi5qtV33EjegaZzHpd7gM+aS
   zSNUpPAoUw+Ot4p2KPBpGQeh2ojo37Z7PP+7fJpFHWlsB2PMmPR0RkT2s
   8MXZ0rwNK1kFNFNdTkpOwYJCaVZe9+es56axLhqE59jxbPtUzFBBUfZwr
   w==;
IronPort-SDR: nsCJw7cW0Rc11q92Txl70Fvg7z7obho71vWNDq5wPCgwgpAbgnShEznHkYCgQXfmbVfLiHG3OT
 axwyeIge5seleuJsB5dAiZGUbzIGHQlXvWIDcz5c6MTNTJY0rpPgVrOTL6mWUTUi7NKvk8y8D8
 E6DA0+RgrniHzulgtGsAtNYtwbyugJK+LhUWNLlrMKvuI+hKmh1lQ+THOtL2RlLln8t+P32san
 1bZB2adAqChaH8qXNjfDY+s261lY4kE3M1RPUsgR1DjpyT4htxKOr2p52Vwc+KdsDARHWkaabY
 9Qo=
X-IronPort-AV: E=Sophos;i="5.77,447,1596470400"; 
   d="scan'208";a="151704976"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 03 Nov 2020 16:55:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIDvuPmu2b4OUW0EoXEIyyR/UjLipO3T+d1zH/OwfdQb4TrbnKhlcIEqqqI7mOCBtUv5IcwY8aLhV//j8qUFB3O++g8rUCvqpgH21VXWQm6leTV5iFjCF/RlLSKZYYv7r8rmWbcJ+76J+n+z6Vk6nhYcDNXrwW64r42AGovpGVkVBJwVBiKupc+KQCExijHos29OQ21FcMjgV85+eQYxb8ubE3wY+col9dDYIX8rMGgEMTmbaX1jXaZCVzBF5I/0K1nlImpaV8dYEUHCz6qXvQ8QH0dXCaw668YHsTx7n1WzD9Jxo0sXGtChV0x838zSXyc5D60ock9X+hY9yUhBBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHik0GBc1Sfdm4lcekXjkseXFDMrpMWUcWyWYjoaZBU=;
 b=c5LFplPn8D66sxVpauJsElh6Gg1nWpl4E8OkhjOyJTKianmgf5Z/yrwDPmS0z1xczP5+5uU8rmXHwG5QjFSo+3B6aS0ENJUwmVbwFbHHyPZnF657hQb4lhMZkdwQjIRM5Ab9ru9qUt6XDF0AFIUR0CJWqVLK0MGoW1ba+651B/t3tOy+j/RE7LSHPgrCSm+pF8mhs7L2/BJdlpxl3X7ThmmOqDpSwXVxBMr89i/RZ/ZImw9xtnd20R02VLGDkCVtjACkdCbiY5ZnD2Z1gjQmNtsNOcdnxtogdbKB475fS/EYYKKFplLUkSDPchLB5T6S6jdewdMUnjd5ToEfHENq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHik0GBc1Sfdm4lcekXjkseXFDMrpMWUcWyWYjoaZBU=;
 b=j686fApgfp5XDJo+vDaFjxf/VB65yxVS+NlgmchDdpVih/uv5Z5sQmFNwOmr/D3CGPplaNHiGJBc49RuzUQ6YwyTbjACuTrxTt2pB2ji11YmV7gkTS6Ru9fFcyW9+e2QvfWgnxGHLHsCVeYMQ8Pz74malSnua4AslJQhy5EGsCY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0970.namprd04.prod.outlook.com (2603:10b6:4:47::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.27; Tue, 3 Nov 2020 08:55:21 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a%9]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 08:55:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Subject: RE: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with correct
 type
Thread-Topic: [PATCH v1 1/6] scsi: ufs-mediatek: Assign arguments with correct
 type
Thread-Index: AQHWrerABC0BriD7CEyLHrMbpYegqqm2BS3AgAAH+wCAABQfQA==
Date:   Tue, 3 Nov 2020 08:55:20 +0000
Message-ID: <DM6PR04MB6575E34E36F90B72C4E89883FC110@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
         <20201029115750.24391-2-stanley.chu@mediatek.com>
         <DM6PR04MB6575F51915ED4E904ED82EC1FC110@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1604389184.13152.9.camel@mtkswgap22>
In-Reply-To: <1604389184.13152.9.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43eb1a6e-4411-4c24-74c0-08d87fd631ec
x-ms-traffictypediagnostic: DM5PR04MB0970:
x-microsoft-antispam-prvs: <DM5PR04MB09700F5EF09FD7E6EDABD510FC110@DM5PR04MB0970.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3S2o/dhmvoSzFyTFFVRX9/jxV93vq9irYTgUt6/dX0DreBpjac6dgL+gW/QprVp96Nxi2RZwOtLKVqq9IR9G3ARdTkhF2SsOBZCXd334OCW8jK+aWwwAZEt7YyqkWsCgADybpV8uuZPnI+a0mFNexSG7EwYK0dilMHfIgyH5RAsu6s1arDtcqPJYSkWCd5Z3JCOaX51IBbubpxVKkgcmwsKxajwy73shd6/psMPNzPDWUVElmn4oakh5AUL0fo3Gi3velBY6YrjQ5C3q1kTXPajb+wZH7wBW2BKDmYcxqSVXMGK+OSnR2ND/LsY9FIwv59eXEa7rjOanpTu17nz5zYq2aasjCxLOhptydoNcoeRZWTeSkPrGBnzJ8a9nXsyDUCSDV4hwB2IdBy0+jBn8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(186003)(71200400001)(8676002)(76116006)(26005)(966005)(6916009)(5660300002)(478600001)(64756008)(66476007)(6506007)(8936002)(66556008)(66946007)(66446008)(86362001)(4326008)(2906002)(83380400001)(9686003)(33656002)(55016002)(7696005)(52536014)(7416002)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: l2jqz5zKndwBj3ez7JChEX/9MlalbVUol5u1CP3RK6Rk+C1oK6QAkyhEFCB8nBV8ISiFhwj7u/VgWhJFQ3sz/LB3sQFXSwIMLF+yPcbPlU7rtfnf712UDhVoN2JlIX25VWzJemti2K0rznjmVmn6Wks8+9x83h2Y6XuyplOSXmsENguSF0LSOOmjEGbMVPJ5aL1t8gcEWq7Pdnq+ZuCvpppSDu2rIu9dI929DRYaOrmZ/7c2Mk5p7TV33qGh+sokqAWP9AeJsHbsHrla4DybllnKSBuA1RXKCW1wAZIH/ViczJbFSkDH1NYyMROYGWj4etpI+C5LyHYLYnLfocMZR3r8F/KCwxNM/5Z/lethfSFQGIg5rQoJfC69qT+YX/cbQh0V5MXbhoT9sbe5i2pHJBnOsk1B8Nvn33k0r/4ACh3pfmddUng7wlE2lF1v4rNY6gP/5++0GYyU/gNsVhq7vJ+Pu867SQrkRly6WwuwDrVyUgsQA1ocHKWXGAYl5CsTzKTDHsogpGmvpN4ZpzWmeTIbAZVRj3IQ/noNUzy06He0bgRTTy1JDOjY7YoYfRnMcwlpG1LRucEHcdcZp+hpa20scMiDMiiQIipcBawYl4SiqecCnPGSC1LjOJxCVPip2umx7TENp27o8mDqhc6m1Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43eb1a6e-4411-4c24-74c0-08d87fd631ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 08:55:20.9328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBw0xTkcGmtxtDxqAntcKvi+yWBNAAqUhDyBCQnc03KKVpIqcidndcnh2r7t8LNYgt3wO+8imFZ6XI3bYsT/Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0970
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+IE9uIFR1ZSwgMjAyMC0xMS0wMyBhdCAwNzoxMiArMDAwMCwg
QXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gSW4gdWZzX210a191bmlwcm9fc2V0X2xw
bSgpLCB1c2Ugc3BlY2lmaWMgdW5zaWduZWQgdmFsdWVzDQo+ID4gPiBhcyB0aGUgYXJndW1lbnQg
dG8gaW52b2tlIHVmc2hjZF9kbWVfc2V0KCkuDQo+ID4gPg0KPiA+ID4gSW4gdGhlIHNhbWUgdGlt
ZSwgY2hhbmdlIHRoZSBuYW1lIG9mIHVmc19tdGtfdW5pcHJvX3NldF9wbSgpDQo+ID4gPiB0byB1
ZnNfbXRrX3VuaXByb19zZXRfbHBtKCkgdG8gYWxpZ24gdGhlIG5hbWluZyBjb252ZW50aW9uDQo+
ID4gPiBpbiBNZWRpYVRlayBVRlMgZHJpdmVyLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+ID4gTG9va3MgbGlrZSB0
aGlzIHBhdGNoIGlzIGdpbGRpbmcgdGhlIGxpbHk/DQo+IA0KPiBUaGFua3MgZm9yIHRoZSByZXZp
ZXcuDQo+IA0KPiBQbGVhc2Ugc2VlIGV4cGxhbmF0aW9uIGJlbG93Lg0KPiANCj4gPg0KPiA+ID4g
LS0tDQo+ID4gPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYyB8IDEyICsrKysrKy0t
LS0tLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlh
dGVrLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiA+ID4gaW5kZXgg
OGRmNzNiYzJmOGNiLi4wMTk2YTg5MDU1YjUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmcy1tZWRpYXRlay5jDQo+ID4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1t
ZWRpYXRlay5jDQo+ID4gPiBAQCAtNjM5LDE0ICs2MzksMTQgQEAgc3RhdGljIGludCB1ZnNfbXRr
X3B3cl9jaGFuZ2Vfbm90aWZ5KHN0cnVjdA0KPiA+ID4gdWZzX2hiYSAqaGJhLA0KPiA+ID4gICAg
ICAgICByZXR1cm4gcmV0Ow0KPiA+ID4gIH0NCj4gPiA+DQo+ID4gPiAtc3RhdGljIGludCB1ZnNf
bXRrX3VuaXByb19zZXRfcG0oc3RydWN0IHVmc19oYmEgKmhiYSwgYm9vbCBscG0pDQo+ID4gPiAr
c3RhdGljIGludCB1ZnNfbXRrX3VuaXByb19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJv
b2wgbHBtKQ0KPiA+ID4gIHsNCj4gPiA+ICAgICAgICAgaW50IHJldDsNCj4gPiA+ICAgICAgICAg
c3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiA+
ID4NCj4gPiA+ICAgICAgICAgcmV0ID0gdWZzaGNkX2RtZV9zZXQoaGJhLA0KPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBVSUNfQVJHX01JQl9TRUwoVlNfVU5JUFJPUE9XRVJET1dO
Q09OVFJPTCwNCj4gMCksDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxwbSk7
DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxwbSA/IDEgOiAwKTsNCj4gPiBi
b29sIGlzIGltcGxpY2l0bHkgY29udmVydGVkIHRvIGludCBhbnl3YXk/DQo+IA0KPiBUaGlzIGNo
YW5nZSBpcyB0aGUgZWNobyBvZiB5b3VyIHN1Z2dlc3Rpb24gaW4NCj4gaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LQ0KPiBzY3NpL3BhdGNoLzIwMjAwOTA4MDY0NTA3
LjMwNzc0LTQtc3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tLw0KPiANCj4gQWN0dWFsbHkgSSB0aGlu
ayB5b3VyIHN1Z2dlc3Rpb24gaXMgY29uc3RydWN0aXZlIHRoYXQgdGhlIGFjY2VwdGVkDQo+IHZh
bHVlcyBvZiBWU19VTklQUk9QT1dFUkRPV05DT05UUk9MIGFyZSBiZXR0ZXIgY2xlYXJseSBkZWZp
bmVkIHNvIEkNCj4gdXNlDQo+IHRoZSBjYXN0aW5nIGhlcmUgaW4gdGhpcyBwYXRjaC4NCk15IHBy
ZXZpb3VzIGNvbW1lbnQgdGhhdCB5b3UgcmVmZXIgdG8gd2FzIGFnYWluc3QgdXNpbmcgYm9vbCBh
cyB3ZWxsLA0KQnV0IHRvIGxlYXZlIGl0IHUzMi4NCkFueXdheSwgSSBhbSBub3QgcmVsaWdpb3Vz
IGFib3V0IGl0Lg0KDQpMb29rcyBmaW5lLA0KQXZyaQ0K
