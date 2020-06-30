Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD31C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 12:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367612073E
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 12:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BqpmJ9Mw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ag2Zs8qU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbgF3MmV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 08:42:21 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:51756 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgF3MmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 08:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593520939; x=1625056939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KB9LwajWz+3hH1uGt5TzLC/6j8nCDqQP6vXPPclvPfY=;
  b=BqpmJ9MwW/p/+k6k+w8oSmIMnL2TM33RUUdSR3c+4YhE+HGLZz3sjbqB
   gCyxtaUwQHMLU5yobkCYHvVw++htMZ7NSJ48+eLSNdxDlBZP6TT/wlz/s
   QeJ9UjLiRI4vx0K0qkKZGib31UwKDx2SSXbXsg24w8fRsrbRtTWN5tbIX
   y9rMOFRJCpvJCLhBrF9b65pAVFLv0UhvR37tCARlvqONKk4qKxylvBSNo
   WFTu71a8YDafO5g0RYOQwQdiK8Y7eVXGqcD/et/vMNcfxMPkPPkzM0ZiA
   kvqXqEz3wtWtrVpMFHy4Fn8o6UrHqHXtMNOYo4blgSDZ86P5mURrjLGW/
   g==;
IronPort-SDR: UafUUWrJ+annlDH23dzZM+m1EEQG+L0kgUSgUt/OLL4v1ZFs4yl3mFlZcsKGul0dpluQkCpGY0
 8Mxrd72GevyDb7sk/nJj2y8TXjdCG2/xDQliyevmugrWGWSZYe1gp6EAQgcOjHaAA66/PETcgf
 MARzPMd2T8IcVMFq3C6frOF3zJVlAAxm2SfY7uMmXq0BZ0uKmSwHbsY8z6nzONeNxBClYW3v+1
 7SaX6UHBUxxqimMx1AEcAyle+32BolRWGU2DUK7ctW19PzEcVz5jN2l9F1GRm6G6VOJkKvlfj4
 eWQ=
X-IronPort-AV: E=Sophos;i="5.75,297,1589212800"; 
   d="scan'208";a="244296776"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 20:42:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmU/T+I2PhNnpFAZ6TYOZOVU+Y75VAZhRkP6+Bd6iB/tvnPAJWMFLyCQ3o5THsMnBLYxafFWi4wjt66hixBLl/qyPvXHlj4y5xP1hHGT1hx4ivKg1XM0cvcUvmY2zb9dgmk+y4bJ/Ccf/gStvsyHlKw5CbgSUvVOCOvUxSbmKSlxQ2GoiwEi3xJVa7bTy9rPUNgI+8eqLpMIA3H+dvR8ZNKGFbnZCeSAgmGCxOFKIIG3mwFRiVjLUTUeciXa7opA/Oc6i6C7Cfpt2ha8AYXEraOKg+CCKipI8FBy5A5Lql5Z5xgEmI7/XrCg7lv5VLW0pLIFDXJtS4Ok0W+bvQ84oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KB9LwajWz+3hH1uGt5TzLC/6j8nCDqQP6vXPPclvPfY=;
 b=KvqPzn14piivC7/79wFcj4L29sLoUzsRpyJfoDBM+AH2AFQVVsjqfONrDFoJG20jCLZUm/LcD2Ud2c8cN6mMSHzAic+lz/VJSmSuuWx94nhb/TjUFzja+ryJF3LXWHgHdbU8aZVaqeK2UGFfSnF4i0B/ZSHIFSiVnixhLuxMtdbl4oerQ0lQ59tJebcZbeGsvyz7LU8zkYPN+uXXSllaCSKJjrkFttm9FGMh1cOxEbWP03UVD9f7CH1GG4WjM36zEXpM7HHGfhLG1K4rK4rGknKjiP5bBD3q3Xm+SUO9ODnAioWtoVWq3FTEl7lzH6StOJaO11tT4ig8VR+YfnUhKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KB9LwajWz+3hH1uGt5TzLC/6j8nCDqQP6vXPPclvPfY=;
 b=ag2Zs8qU4mUyDvWoTOvg36rymcZNCgGGWIGHg19aKwBmSgVVT45Eqfm3Qiy3zcPc0iNRID6VpWU7YDSmzA3iIzX365TZu9R+FxZuJiyyrPf0BzMGYjeXwwXTh2H/E7fSZmychEhjPrXsSnERpsgtB7HzWDi1h1WIzGws0znkrgc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4077.namprd04.prod.outlook.com (2603:10b6:805:47::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 12:42:13 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 12:42:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
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
Subject: RE: [PATCH v4 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v4 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWTebYpX5BfvKkoU2xgSP8E9mBaKjxGyDw
Date:   Tue, 30 Jun 2020 12:42:13 +0000
Message-ID: <SN6PR04MB4640BCE167B108B74D5042E5FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
        <963815509.21593413582881.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413402991.JavaMail.epsvc@epcpadp1>
        <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
        <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p2>
 <963815509.21593415684555.JavaMail.epsvc@epcpadp2>
In-Reply-To: <963815509.21593415684555.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c101fa71-8e62-4976-aa12-08d81cf303be
x-ms-traffictypediagnostic: SN6PR04MB4077:
x-microsoft-antispam-prvs: <SN6PR04MB4077A9B8399F7EBA9086D5B3FC6F0@SN6PR04MB4077.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4xy7pJ3UVVcd3xUrzswt3omXyMNmV5BbOxQOUdFjdm9H2wg+njNhK/ogmyALHvk7fb3/e25HfI7P/HBViONxHx5aDzfFOE+NcdqAANRcXaQJ68mI+Nmwmqj6Qv6FGWaZ/pawdJK9Xb4IMnOy5YuyYJ1FwgQK71j1YrKnpOErWqj5pdDwNlLlZ8cSF/qBB56O2oVwl6M0g65JCJaHCEt86alHN4kj2M/Yx8Se2XGIDXjs8bg4W1yVeRkTJJ94b0NbODhgbhAfgdFsxsBQRDqq9Ju+PWHPPbOHMtUPbatK+/wsywRn5S2mTHHxNPyDA7REz1tt9AOTpgHcJ9c/BjbdyOEiYC8u6MgrpxeEq4R5Ornmp4UCSAWJEfZ9dcgWkJ4i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(66946007)(9686003)(7696005)(4744005)(71200400001)(52536014)(83380400001)(8936002)(76116006)(86362001)(5660300002)(4326008)(66446008)(478600001)(55016002)(64756008)(66476007)(66556008)(33656002)(2906002)(110136005)(54906003)(316002)(6506007)(186003)(26005)(7416002)(8676002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ENa1Qohy0Dzos3YiMRvTrJd/bT7g51Pri071A1cluTa+aDMobPbGEHeCyR9NUhQ0YFxdTwZxaOYWVan5QLMyEQImFsd3YhUpcP5S1qCRRblu2WoYhqsTQlXY850H38JsH4RdnPIRd+HFhfQLkLhYza34/nReMob2C5rjavBbW3yleGXBV7kUnCGY1cC0Lqder74F+vt8Rd0UxWS/5Hc7y3KHfCPBDRQxsuMLqvWTHg+6+X7aTYXx/uE6f/SOJ/p+eoe5OOL6nb8MKNr2V+JrSVUWEggfo+nuAaAb3lTTTG8CIGRQEE6j2bGjXo1tNjy+EAUBwdNlzzg/3n5uy4AZeGm70nnJthTGkzc9IRtZzSZLEdLnvT9Nj3O7K9Yul3jLvQnCB6nrlliHa6myhqPa56+XUDJ+mTXWONfXdD+Bx8mKYMdG71xbmqX3RDLe0IsIGs4FoS7QtlP2JOidEPm/EEaG0CEkWPasdJe+gks3dNE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c101fa71-8e62-4976-aa12-08d81cf303be
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 12:42:13.6274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fWa9gdynk29vJOGWkyayEKW++2RzpYkvZF5UIuwb+9Qgup9ygJiLddYxPghOvh8LuYd++0370xqGWZBtVjosqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4077
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIGludCB1ZnNocGJfaXNzdWVfbWFwX3JlcShzdHJ1Y3QgdWZzaHBiX2x1ICpocGIs
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHVmc2hwYl9yZWdpb24g
KnJnbiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgdWZzaHBiX3N1
YnJlZ2lvbiAqc3JnbikNCj4gK3sNCg0KDQo+ICsNCj4gKyAgICAgICByZXQgPSB1ZnNocGJfbHVf
Z2V0KGhwYik7DQo+ICsgICAgICAgaWYgKHVubGlrZWx5KHJldCkpIHsNCj4gKyAgICAgICAgICAg
ICAgIGRldl9ub3RpY2UoJmhwYi0+aHBiX2x1X2RldiwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgIiVzOiB1ZnNocGJfbHVfZ2V0IGZhaWxlZDogJWQiLCBfX2Z1bmNfXywgcmV0KTsNCj4g
KyAgICAgICAgICAgICAgIGdvdG8gZnJlZV9tYXBfcmVxOw0KPiArICAgICAgIH0NCj4gKw0KPiAr
ICAgICAgIHJldCA9IHVmc2hwYl9leGVjdXRlX21hcF9yZXEoaHBiLCBtYXBfcmVxKTsNCj4gKyAg
ICAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgICAgICAgICBkZXZfbm90aWNlKCZocGItPmhwYl9s
dV9kZXYsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICIlczogaXNzdWUgbWFwX3JlcSBm
YWlsZWQ6ICVkLCByZWdpb24gJWQgLSAlZFxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19mdW5jX18sIHJldCwgc3Jnbi0+cmduX2lkeCwgc3Jnbi0+c3Jnbl9pZHgpOw0KPiArICAg
ICAgICAgICAgICAgdWZzaHBiX2x1X3B1dChocGIpOw0KPiArICAgICAgICAgICAgICAgZ290byBm
cmVlX21hcF9yZXE7DQo+ICsgICAgICAgfQ0KTWlzc2luZyBjbG9zaW5nIHVmc2hwYl9sdV9wdXQ/
DQoNCj4gKyAgICAgICByZXR1cm4gMDsNCg==
