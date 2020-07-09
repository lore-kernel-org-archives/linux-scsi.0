Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5F8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 08:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EE920672
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 08:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XV8jeGnr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="blu83ATa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgGIIkt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:40:49 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19051 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgGIIks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 04:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594284048; x=1625820048;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kFqJ+/pK6NWxelRNSzeOeIFlhDCXcPx4kz8UjNPMEXs=;
  b=XV8jeGnrZvHFNdjcHfkhL0Hm9ljaNE0FUCi9EgfNVHI7UzTR2KAR6Six
   L0gXuJ+rqr+/VFJ/t0Z7WXl80+hON8UZ+nC6Pli1ou3RG7VO7n4FqGA+8
   HCh1VmHOh+mCEGYZz5dsEHQYbOGpXDQwYBh60bSjtswLxXIabU+FgEs/B
   e02HaovWzBpwPsF0c7qxJc1lWjhNbheA0PTJ5IlOxl+TetrY/ZpXGC7DJ
   z1ONDiAOvCotZjGvNFi/BaJ7C3RPiYHTi4SRiBxDPpF1vSmWKsMB4Cm+k
   n5ZriU9eOifYa5Nk+Xni6C+g2SMpome9J25/nXRe+c2nV8aH9yBZ8gyuh
   A==;
IronPort-SDR: +RahRcUTqkUQAHb4v2h6u3IKnQI+5bEnc2kcYyZm4GfJAoOb/t+o8xmrXXeMh+zaQfawrOxwyV
 arLkEMYbE2xYCq1Vli/SFSfHP82HGpQuiaa4wLA76Q1H6K2aOEMmrUklSm9vezbjDM6dZi7NMv
 hwbna0xctJloJKjHg8dzqDaki/h0ix8H8zmIHkj2PIXxZqkHLI8cQPjxT5ecaeq4PWKSo9wrXe
 WAIG4Jb94vgryT6I+ZHlPBWu4WJ474yv/R5ICBVSlFaRIjRQx2yeng07ggo1Q2iIM0J7vXv3tY
 1h4=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="251245275"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 16:40:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXrCEme8HbH7WjFPSZzBPGuOKaRq2fsXJGZNHNuFrrti2aKI1XfMAXMAdrHvEooC+Fv5K39mAHaAr/uXEOEhdbkvZ5BNjJLiifneAL/5CM7fjQeqfd/bIkJscWxoxuDMqAYIggvvt1PRF1ZyRr8/xWXjw8NDwWugQ23FeHcAxk4GOHDyX2tVvGZhnk4CxUpfoUTvy0X6UV6BAJVNlnksM2DuiEnsLWJCx5hheEP9S/gpTS7mkhUWA2IZ7TrUcg6EGnagrsUgoGbWtRGaShLliGGPOJ7FT7TuhlxzW+Mf92uJilI3f5rESij2HFizUpEjNb+YcZCHUO7I/oljFGJ6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFqJ+/pK6NWxelRNSzeOeIFlhDCXcPx4kz8UjNPMEXs=;
 b=I6k3a5qTx0AIk5Nff7sT68GziKi6TBdhRus0eu3RBFDHVO9eQRKCc5Du9n/+jb5Zai39K3WHGo8R5XhtehzALDQrWdJAuAz50gB4A0WohCSY7t9L7ZyzFOJIsmldcqMWtz0jGl/5daS+96XKQlNSN5ydG0OeU3BjaCe0xD/X06MQpM6fv7qLjRvy8zolWq4ofRrrB8qPtHZeUIAN2gGI2ZkRyBQPlzbOAnJr3j/w2yruHVY4qq/dK8OJd3q3VdNhiN5zOpxsZs+2719RwTxgHFqBbGEtzxlpUBiCC+p4CVxfz/eusEUb8PgwpB0HScXn20VWcfndJfAYUrhRkf2Tyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFqJ+/pK6NWxelRNSzeOeIFlhDCXcPx4kz8UjNPMEXs=;
 b=blu83ATatHGfpCwr2Dd4o8ek/rsGEUIQg5XvLag4APwBX2ka4GHNhYm1s6S4rkcPpP2i6BuwZxWNuoOYuZQ05oHUfO6pgYM8ujP/XW6iRMrh3IVZU8aLQcFDUpVlTGt/uD5GNzXEUbKehR+FVtiDaj6zOo95EJpjZonCIyhhjYo=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4349.namprd04.prod.outlook.com (2603:10b6:805:34::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Thu, 9 Jul
 2020 08:40:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.031; Thu, 9 Jul 2020
 08:40:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWUMe/HeWQynTPF0eBDwBI4Q2f4aj+XPoAgABhPNCAACV1gIAAE63A
Date:   Thu, 9 Jul 2020 08:40:29 +0000
Message-ID: <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p4>
 <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
In-Reply-To: <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebd3edbc-39ff-41e1-f301-08d823e3bc5b
x-ms-traffictypediagnostic: SN6PR04MB4349:
x-microsoft-antispam-prvs: <SN6PR04MB434915EDBDB990BC0426D6F7FC640@SN6PR04MB4349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ozJdSFvB+YYEN9CluURvgJBsfhdy/Ikz2NWsjFk03svzwWOCIFWrkYiR8yjrIu33NFNR718tpckv0Ot7xxYQCgSZ8F5YMJfkKt3pq4i1YVDf23Yg5iRSoCGMZXp7d5I9DxQd7Hmyg9p2tLn026MAX86Nk/RhxWdOm09PMXyp8y2+jFZXWZyEHGRPaORmLZC5qUdNj1Xrp+QvQyHMwgK9Y66sfGsAvQ2HHkycc6TknjsFuAMpsqKiKxJQ8eRnJHvFcVXxkdgKINdWtZno/IKnQqwsnznCREVIR3dbrS5fvSjUKX+kIg6pBV5M7+FZ9ja/bvNetNTbZciKkvl1T6Y/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66946007)(9686003)(66446008)(66476007)(66556008)(76116006)(64756008)(54906003)(33656002)(110136005)(86362001)(6506007)(8936002)(8676002)(26005)(186003)(52536014)(71200400001)(7696005)(4326008)(4744005)(55016002)(7416002)(2906002)(5660300002)(316002)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: B3c+r+W2Ig/ReTlLUC3H8X8Mm5a05SHUu44YTGcGCi18VSdQQol9ZO2UYeRW0hkie2s3JLuB/qNKcZq3aEm4LvsXs8Zjoe7aqn684aDNmI/fnHjPk9wElzUYbtsQlAUoogGfK08sTw3yEMnJjDHRYSj5WU14mjm+9uWGP9FVBw8y6iyS1NpnClZ8d/IiCYGbws/LcirWPb4FPrdoRMnXY8R5qTGnE6bJV0taTwblHQZz4Isl2Dcov5PKqodElrm5Vi4BA1BlQEWpYxQ2H1Nd8m7vk8XpgRwlaiwUEckT1f55HCdx81k4tp5zxMe8NPer3GPLYxbLYuRW6qQmL1k4n4wnOLb2n4c/61QrwdkDTHEN3OWHUsFaDxUuDd45kLO4sVO1M0WtFGIZPCYVUlkjnJX0Cs0SaQtc4cTqtzgvIj24H11qAwK3waDh3NvRAab4sgLph7YINC9wBgQN1crHAoR4P28ymWvViQ13kClr1YA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd3edbc-39ff-41e1-f301-08d823e3bc5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 08:40:29.5427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ObN4YoYT9BJgenJ93TDZqcbqF5afRUoJ9CMCD6hVeQO60oqMrOQ4ESxcFzNwblllErwBrn+cxRl2WbjgXR5PuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4349
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiA+IEhlbGxvLA0KPiA+ID4NCj4gPiA+IEp1c3QgYSBnZW50bGUgcmVtaW5kZXIgdGhhdCBJ
J2QgbGlrZSBzb21lIGZlZWRiYWNrLg0KPiA+ID4gQW55IHN1Z2dlc3Rpb25zIGhlcmU/DQo+ID4g
SWYgbm8tb25lIG9iamVjdHMsIEkgdGhpbmsgeW91IGNhbiBzdWJtaXQgeW91ciBwYXRjaGVzIGZv
ciByZXZpZXcgYXMgbm9uLQ0KPiBSRkMuDQo+ID4NCj4gW1BBVENIIHY1IDAvNV0gc2NzaTogdWZz
OiBBZGQgSG9zdCBQZXJmb3JtYW5jZSBCb29zdGVyIFN1cHBvcnQNCj4gfn5+fn5+DQo+IEl0IGlz
IG5vbi1SRkMgdmVyc2lvbi4NCk9vcHMgLSBzb3JyeS4gIEkgd2FzIGluIFJGQyBzdGF0ZSBvZiBt
aW5kLg0KDQpCYXJ0IC0gaG93IGRvIHlvdSB3YW50IHRvIHByb2NlZWQ/DQoNClRoYW5rcywNCkF2
cmkNCg0KPiANCj4gVGhhbmtzLA0KPiBEYWVqdW4uDQo=
