Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4123EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 07:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1675E2078D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 07:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lljljUoU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tDEtfDdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFIHAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 03:00:43 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52563 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgFIHAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 03:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591686036; x=1623222036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E+CJgP62uQVMMG1kiy52vP/gdkf16Z2cQeivBp4C1dY=;
  b=lljljUoUMreiuKBE/91xuYNaLgVhRaXB15MMvfJlsYasc+PNX2iMwA5x
   Sk+yUJQcIV5gukeIILYruQYP5qxEWhi4ocPy967AcVWzeYrkzCAnPbrE7
   vAuBuwLej56m6IVcbdNb6cX1A3XF+cthUkC7WitktqJ7810+gfkMqQBOO
   nToQaO7EMkC11uJJZCjjWmH5sh01LmeLvlaJOSaQPHF5FtM21XKC1pT90
   na4coctBJ/B8gX5IzOC5yTTSFZgVLz0fsHQ2uAevk2XfACMQZ8JolDeCl
   xppwzTlvGifd1AbgvGyHVhinhsp4st3GpOelM0/hxxDfyKPgryxfWn2Xv
   g==;
IronPort-SDR: ybNRIChd7sQeGinx0mGspOfdwcAL+feXwdvjJlauQWLoWkBqaRV3S2R0kk6egRB+3E0mPllymU
 tf+v+/42Mg72nELaDY+Uqm2ktSkrz/CNywh3l28frFBaiNPdsgq2/o30l8JsaEMkToU4nrPiZJ
 0knA5XZEUMZUQ/vuIheHsDYxWS6lqu3KlsVmPQCzhQJDJTUN6fEDVdET+uRzRuvXHweqWOEN8/
 2QWoep9w8l1nIKFxmrMUsZbOOZsEeOJgGw2nty5ij3wdUyq8dDisndSx2gChBp07NSbMZeuaqY
 +Lk=
X-IronPort-AV: E=Sophos;i="5.73,490,1583164800"; 
   d="scan'208";a="248647955"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2020 15:00:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQOAn+kb+XkHDSsQU9RID0957nV/SDjkghzFlOOeOiiT13IxUi1VRB4C4Qxh7OU/f3Uc3nKdAyeMRZfiW+sORA7TDUmTvVGthVFcLmoZfy7fUYQsMeEDN8QGWeaNfsdhCUKcFeK/AeH/PKwQUKaaXeOYHtim4FycAKkEgFx3tIG16WIRuLer6/GN/aBRtC5QqEchO/x2k9WDhR4RKRgsNxeDXMqlZA4REp3iyoBvEkAXuSMpvCcKKzVxwU31zligEA1Ba2p2i/8qHmWYK3MB4iga8P2bmblvKqn3jVDX9REENi1gFdrcdrL28xbvkobA+MHj69pcWBvOuPZhtq3uRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+CJgP62uQVMMG1kiy52vP/gdkf16Z2cQeivBp4C1dY=;
 b=Z2qqu1OhrGpGhoeHw6sssIO5LcSoKkrlZhS2GCez6dvML9b3u/LuElnk0nc49Fbt/9cXvNA3/XgKd/SQ1YN+3/BnCuWCkDL6aeA016jmiZEnkxt5cUaUqGpyWr67JxE15gIGvVQmb/IhSIW7RA4X3DESDwgFXN8uIbCzVsO8OmLNNMrOOeCidHFUg19Lxkvxzm1c2JzhSLgporCKK4YnhXZHJ8GsCahvSacs7Ao+MesTKB3yiqK+RZYBruptq3ps+geUurotX/8ihwc5bDWUTffy94PmnJyaKFv42szxhRziSNdGkspCBqmiT43s4HbeGGUZAuqIo28epDFDfu16Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+CJgP62uQVMMG1kiy52vP/gdkf16Z2cQeivBp4C1dY=;
 b=tDEtfDdC/vRQuN9ogyr8B61BExlFLkxjWS1cmjpD1ipNJG54yayHdQQG2qUFp5OvzBtShLGokZr7vfopFbsJveE83i4RcQS8kNjhiOmLVzgWhW9OaY7jHNV9DpV8uXZy/NeYrAdvPXFAGcbfZ9etmZDoHOEkKmgvk0yNh7vuYPY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Tue, 9 Jun
 2020 07:00:32 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 07:00:32 +0000
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
Subject: RE: RE: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Topic: RE: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Index: AQHWOtdzuuOrqvV8XUaJuwxPo4VLXKjLfTtQgAP8xQCAAGXlgA==
Date:   Tue, 9 Jun 2020 07:00:32 +0000
Message-ID: <SN6PR04MB46402258DEFF46D6B9FBE2D9FC820@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB4640DC01229F2073C2BD3103FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
 <336371513.41591664282662.JavaMail.epsvc@epcpadp2>
In-Reply-To: <336371513.41591664282662.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e5a7048-1df1-4a96-2979-08d80c42cd65
x-ms-traffictypediagnostic: SN6PR04MB4640:
x-microsoft-antispam-prvs: <SN6PR04MB4640ED047613B3344BD2D7DFFC820@SN6PR04MB4640.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dqb2yfKkh3bq3JKKh9LlYcW4XZayhQdtOIfZ5YephDSA0wPQzpX9m9EnRcZzlroxSFobzUrZRMndfTaBB9Zron7oEcJ7aF3cZY7EoXnElKxvGZ76NnAJhNFf2lwLzupTrS0i315QG9wfPJUeNPZTntAftkcYhVrZsyICWoSQElq8E94HqePMOYXUHzVTx4qX4b2pwNvRp3so9DWXjVobWeEXekBD7voRyOT8HPR7BtSxBOoGXiqkwztB0ECbutCpn/3L4m/AW4975Nm4vfykVLhlELaV5oI6oA/Uskv6t7VHAOi5/RD+AMd4WL7qtI9MVvUhEH6sT5Kf1JWWab/hlUWbVR6zLtEEWJu/P58YEXCZD8Ap93mC4Y4rVGGj4K3q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(186003)(33656002)(8936002)(55016002)(86362001)(7696005)(66946007)(478600001)(9686003)(26005)(66446008)(6506007)(110136005)(316002)(83380400001)(4326008)(54906003)(7416002)(8676002)(52536014)(71200400001)(64756008)(5660300002)(66476007)(76116006)(2906002)(66556008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RS/tmmOKDNwRz+gU13THtF7aX8wSs1M0QEooQzzwj1DZlr507Xip/PXNm7l+tIi9G+y/Z/0qiScPKY4qr3El0gqI0zb5xPNrM0GEy3AGOLIoi+5dk6ux6Bh5B4fCpzgXGhtpZolFvTFhiVAgd7UQfnAYhKmLrb1P/Z+jIf6BdCe4Wr54tFNY15VOqX7uIsePel7iLAqHWIm/jh/tbA07ZwIVUMslP3O1oQk3PUdhEu9BiT1qqNq0q6Czg2DG75Z1588vTvA/uvG2/qSQegsFPsXZB+Z2HL/RDwWLpns5jbEHD2nSM71hPAZQafXTvNJo8ObABHVX6SDyG2gUol2+33pjrp4LDL8kmC9rgIFXxycrMSGVtLoF2bdS18m6x77U8pIRsjw/ZpVHXQXl80gs8E7uazSNduuEBmXHIkxRG1vk9HQcsSld1jvL9p4YziWbcWkHZLGg19TxCWmpJyFBYzn+wdlxSbGByFmUc2cchyc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5a7048-1df1-4a96-2979-08d80c42cd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 07:00:32.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IIGBr1zFa+JKAlZYb+nm4vWk0FVneW3c17uLoXQhq3x8fAt1MRAf3Sour8b8jnJDScS9WUd/GI5Vk+16vdrmSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gPiBMaWtlIEJhcnQsIEkgYW0gbm90IHN1cmUgdGhhdCB0aGlzIGV4dHJhIG1vZHVsZSBp
cyBuZWVkZWQuDQo+ID4gSXQgb25seSBtYWtlcyBzZW5zZSBpZiBpbmRlZWQgdGhlcmUgYXJlIHNv
bWUgY29tbW9uIGNhbGxzIHRoYXQgY2FuIGJlDQo+IHNoYXJlZCBieSBzZXZlcmFsIGZlYXR1cmVz
Lg0KPiA+IFRoZXJlIGFyZSB1cCB0byBub3cgMTAgZXh0ZW5kZWQgZmVhdHVyZXMgZGVmaW5lZCwg
YnV0IG5vbmUgb2YgdGhlbSBjYW4NCj4gc2hhcmUgYSBjb21tb24gYXBpLg0KPiA+IFdoYXQgb3Ro
ZXIgZmVhdHVyZXMgY2FuIHNoYXJlIHRoaXMgYWRkaXRpb25hbCBsYXllcj8gIEFuZCBob3cgdGhv
c2Ugb3BzDQo+IGNhbiBiZSByZXVzZWQ/DQo+ID4gSWYgeW91IGhhdmUgc29tZSBmdXR1cmUgaW1w
bGVtZW50YXRpb25zIGluIG1pbmQsIHlvdSBzaG91bGQgYWRkIHRoaXMgYXBpDQo+IG9uY2UgeW91
J2xsIGFkZCB0aG9zZS4NCj4gV2UgYWRkZWQgVUZTIGZlYXR1cmUgbGF5ZXIgd2l0aCBzZXZlcmFs
IGNhbGxiYWNrcyB0byBpbXBvcnRhbnQgcGFydHMgb2YgdGhlDQo+IFVGUyBjb250cm9sIGZsb3cu
DQo+IE90aGVyIGV4dGVuZGVkIGZlYXR1cmVzIGNhbiBhbHNvIGJlIGltcGxlbWVudGVkIHVzaW5n
IHRoZSBwcm9wb3NlZCBBUElzLg0KPiBGb3IgZXhhbXBsZSwgaW4gV0IsICJwcmVwX2ZuIiBjYW4g
YmUgdXNlZCB0byBndWFyYW50ZWUgdGhlIGxpZmV0aW1lIG9mIFVGUw0KPiBieSB1cGRhdGluZyB0
aGUgYW1vdW50IG9mIHdyaXRlIElPIHVzZWQgYXMgV0IuDQpUaGlzIGlzIGFuIGludGVyZXN0aW5n
IGlkZWEuDQoNCj4gQW5kIHJlc2V0L3Jlc2V0X2hvc3Qvc3VzcGVuZC9yZXN1bWUgY2FuIGJlIHVz
ZWQgdG8gbWFuYWdlIHRoZSBrZXJuZWwgdGFzaw0KPiBmb3IgY2hlY2tpbmcgbGlmZXRpbWUgb2Yg
VUZTLg0KQW5vdGhlciBpbnRlcmVzdGluZyBpZGVhLg0KDQpGYWlyIGVub3VnaC4gUGxlYXNlIHNo
YXJlIGluIHRoZSBjb21taXQgbG9nIG9mIHBhdGNoIDIvNSB5b3VyIHBsYW5zLA0KT3RoZXJ3aXNl
LCBqdXN0IGZvciBIUEIgLSBJdCBzZWVtcyBleGNlc3NpdmUuDQoNCg0K
