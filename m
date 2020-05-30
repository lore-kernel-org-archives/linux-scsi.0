Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C889DC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 19:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893C8206F1
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 19:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HAlBYS4s";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EhN6ufiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgE3TnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 15:43:16 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44411 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3TnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 15:43:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590867796; x=1622403796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DVLMJ1778rJ0bZCPsqJIVAfRWR2F+4r2d+J9DOFx4P0=;
  b=HAlBYS4shCk5lFIOOiBJ0lCshnYohqX+mA1ABcvAXimn5K22Z+zg/3ow
   KFKNOZMDXP+ZJxzbiR8HnG/mLQ0nbhJqQlLs2+vxG/MKgWEMnpQqUdH/B
   anCuuYYX0O+b3+bXDrjoLW/M1N5DzxO1WbAaHENVLMefPljDoErAuFPeq
   hTyw+dAVAXWDXb/F9/qqIpMwxne4Mbk+t9fVO7AUUYFxu1zOW4QpF/kLJ
   AbXBo4pgOr6vZvzxXYXnqT+BsNMM5RX5yfGJhQ4zebKDkfJoRwH5wA5yR
   oaoyqJGskHs4sWYE7sLwBnWtRS7b34wBVSmRcd9/nM+q3wHwBmwVY1C+i
   A==;
IronPort-SDR: u4Jrnl/X9lLOVoB+aA6f6uX4ffErrZ+1k2k09TEXLrKL2q8I1tNHKT7o5gJWrf2qdw/GuIyEjn
 XSUrolO7WmEBkp/q++P7EDyTmAn+FvL60k9UBqQoBVRLmLUth3AayHBaNQuUYt3lXjuPYeq9Ov
 VeC9TJvAs1p1Ay4WDbD3R+QaigcVS0B2/AYGuRB7uQ5Hk7j1JcFseTapA6YzxqziUsEF03aMF4
 4iwGPrKG8LRGT9MqH3GvYtiyGrLPsKImDa+ipmwPwTJDOvldislAvocW46rA+pYvNAVIUrmoYA
 5zU=
X-IronPort-AV: E=Sophos;i="5.73,454,1583164800"; 
   d="scan'208";a="241706818"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2020 03:43:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFt6Ssp0+8NvVi6PnpVvQ081hdb50XI+OpUTCH/hDG3HS/5tLJs/Oqz/veqQQOinQN4/53Z7RI0CVC/N7E3MDTKanv6OO11ic/mfBLHLHUVrab4CGDJ5GAvFUkd/t8FgFx5hzznfBv3WT7FiBm6AH4UJNlJv9rrmgCjuF7FoB3XkeR7sfWKvAkM+QCTszGSHvaWC8mftFXmlsvvj+ug6L7fp/MYeE9+x6Rg+pjfBVI2vgJ5PUnBLMzRPl+xCtytbsUWaH/PoaWAunFnOSKONiXiBRLpmrGs0d0FYH/YngWNQxhcKVe8k4HYVAOZnKWekrHEgtIibjWA2LrT6cCphHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVLMJ1778rJ0bZCPsqJIVAfRWR2F+4r2d+J9DOFx4P0=;
 b=lS8c6XrwXbNh93wUfm5/8OsXvGDHaehx8N2eYwKb5Bc52CFx4iFcCSjv1YUkgRGQQ4zzA/z2VQcveWHTCBKfzj0RPFVBvs7/kG9LoWfQ90sKOEwIzZJzem78eDp6nlwUb5gy5x3eDk9xKRqb2IGuKTWzJQvRh8LLRjDvKNLCedGpcBdykzdJGD4bWpUUBKjKpvFloFq8N3+Egc6EXAHIPGAq3AQKptLGA6qf9nlCIf9wzGTEeg5ePLvdjqiS45zFZglQ9JWcQt36SSW0f5TrKwD3m1mCy6QgceVzQYITb75DLnzohstW28JcGMFtGDvrn3eB8bhWIkwpdHnw4pVbwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVLMJ1778rJ0bZCPsqJIVAfRWR2F+4r2d+J9DOFx4P0=;
 b=EhN6ufiOmCMIoGJ7drO0XT0Bzs9tLPLRHlaAo4v4RBB3UeWR6UHzGS25rJT9711tgVwQBByPRS+bplUtJ/ahONi5bG5uGPF/7I3lHXlNA3U1UKydHMFfYVgHgkZmps5lTbTOYch4D2uauWdswnmSH/vBElw03yV8LPs3BfkKWeE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4301.namprd04.prod.outlook.com (2603:10b6:805:36::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 19:43:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 19:43:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit
 descriptor length
Thread-Topic: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit
 descriptor length
Thread-Index: AQHWNdgFtKmSldcTVEG4bGVs4/ouSqjALopAgADHZwCAABKYYA==
Date:   Sat, 30 May 2020 19:43:11 +0000
Message-ID: <SN6PR04MB4640C08D4799FEED297A49FAFC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529164054.27552-1-huobean@gmail.com>
         <20200529164054.27552-5-huobean@gmail.com>
         <SN6PR04MB46404D5B77121B367C17AEA2FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <07b197a84394a20cf175e37d1a442d52535856ae.camel@gmail.com>
In-Reply-To: <07b197a84394a20cf175e37d1a442d52535856ae.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d347e6cb-3500-445a-2584-08d804d1b013
x-ms-traffictypediagnostic: SN6PR04MB4301:
x-microsoft-antispam-prvs: <SN6PR04MB43016C3C05EE5FFE74AEFEF2FC8C0@SN6PR04MB4301.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UTRzoQ0ADZHaPVUHbyzdM+uvC/uxY8nAjAqOc1aZdA5E8tW07I6IK8eAZ1xBFLRkqHZidbR/6CLAySILu9EoIPgZFlroF83ONY+2oqkR4qsPQnTwZyT0aywhhJ8gdWt4bqc5vvodGEECvUqz/D7vWiUyA1FLEQEBdvFOBC/rmGtBdM5u62kZ6aD9eWFpam6K624svQozlQIuoi3WaGF1baImuURmSMmrx9q8nPX+jgBiAuHNw8ZjibPxkkL25c5OhG/ogTFAKjoXNjGq2fN4JclcEwRZnDNzY+4eopzB6E2NwZbRydyCb4m/HbJRaU3iYWZLNJNUI7jlwO5PGtlNRGQExPFSQdOFORlZPlbB3otLPRPCx37yHU9atYGhSaQu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(7416002)(66446008)(64756008)(86362001)(55016002)(76116006)(186003)(478600001)(52536014)(66476007)(66946007)(71200400001)(4326008)(7696005)(6506007)(8676002)(110136005)(66556008)(83380400001)(316002)(5660300002)(33656002)(26005)(8936002)(2906002)(54906003)(9686003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VQaoeIjwN3cKqJIG34opo2TOxKa5ma7byVnKWDANnYCs+SyRKrshb0ILJgs14eh2K20sdMkQ8wECeqZFBMAyvH9c+Ksp0OHihl0g8vedYXMsD2cPIGrWzNGpNrdX4bYPlnyuuShOuEFTpA3SGsyklElxvZEtr+h8ZT4z5qqybMPuUfQqJkpbZBDwV13co4pyu6KTZTvyHXbNmmKEozv80th4j61hym0uZ1vX0HaKHk1e9+x+Y9vkrx8qnqZkdpP7mm6DHrEm3UANNW6EUNaeH5auF2i1NsMSrQjPnEOcAps/7/hST4Bw4R2v6BWxnNctfNhT7aa57i9sxXVgnLNeYnCZ1ZBGQX7x9xrLZsnlkxlftCiIDRfursYv+SHvDTadf/AJFWA2UAyvTH1U27faJx4RWfFNrOHhGqp/HxDiBbeoNU3GpIgNtEUk9qzyqnfgle8quU0RJcQsgqlQAqtdGcZL6rD6SOeYRSEvgxOLddc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d347e6cb-3500-445a-2584-08d804d1b013
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 19:43:12.0506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NIxShMBY8swqf1U/gzWVxVHj8LY7x68jvMVIsMIjZqnOU5RlDTM7csxZdE43cPH/EebMmGx9DJKSOCK+hGhIOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4301
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBBdnJpLA0KPiANCj4gDQo+IE9uIFNhdCwgMjAyMC0wNS0zMCBhdCAwNjo1NiArMDAwMCwg
QXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4NCj4gPiA+DQo+ID4gPiBGcm9tOiBCZWFuIEh1byA8YmVh
bmh1b0BtaWNyb24uY29tPg0KPiA+ID4NCj4gPiA+IEZvciBVRlMgMy4xLCB0aGUgbm9ybWFsIHVu
aXQgZGVzY3JpcHRvciBpcyAxMCBieXRlcyBsYXJnZXINCj4gPiA+IHRoYW4gdGhlIFJQTUIgdW5p
dCwgaG93ZXZlciwgYm90aCBkZXNjcmlwdG9ycyBzaGFyZSB0aGUgc2FtZQ0KPiA+ID4gZGVzY19p
ZG4sIHRvIGNvdmVyIGJvdGggdW5pdCBkZXNjcmlwdG9ycyB3aXRoIG9uZSBsZW5ndGgsIHdlDQo+
ID4gPiBjaG9vc2UgdGhlIG5vcm1hbCB1bml0IGRlc2NyaXB0b3IgbGVuZ3RoIGJ5IGRlc2NfaW5k
ZXguDQo+ID4NCj4gPiBUaGlzIGlzIG5vdCB3aGF0IHlvdXIgY29kZSBpcyBkb2luZy4NCj4gPiBG
b3IgUlBNQiAtIGRlc2Mgc2l6ZSB3aWxsIG5vdCBiZSAweDJkIGJ1dCByZW1haW4gMjU2Lg0KPiAN
Cj4gc29ycnksIEknbSBhZnJhaWQgSSBkaWRuJ3QgcXVpdGUgZ2V0IHlvdXIgcG9pbnQgaGVyZS4N
Cj4gd291bGQgeW91IGdvIG92ZXIgaXQgYWdhaW4gaW4gZGV0YWlsIHBsZWFzZT8NCj4gDQo+IA0K
PiA+DQo+ID4gWW91ciBzdHJhdGVneSBpcyBzdGlsbCBjb3JyZWN0IElNTyAtIGlmIHlvdSBhc3Np
Z24gdGhlIGxhcmdlciBzaXplLA0KPiA+IFRoZSBkZXZpY2Ugd2lsbCBub3QgcmVwbHkgd2l0aCBl
cnJvciwgYnV0IHdpdGggdGhlIHByb3BlciBidWZmZXIuDQo+ID4NCj4gPiBZb3UgY2FuIGFsc28g
cmVseSB0aGF0IHJlYWRpbmcgdGhlIHJwbWIgdW5pdCBkZXNjcmlwdG9yIHdpbGwgbm90DQo+ID4g
aGFwcGVuIGJlZm9yZQ0KPiA+IFJlYWRpbmcgcmVndWxhciBsdW5zLCBiZWNhdXNlIHRoaXMgaXMg
aGFwcGVuaW5nIGluIHRoZSBmaXJzdA0KPiA+IHNsYXZlX2FsbG9jLg0KPiA+DQo+IA0KPiBPbiBt
eSBzaWRlLCBJIHNhdyB0aGUgV2VsbC1rbm93IExVIGRlc2NyaXB0b3IgaXMgcmVhZCBiZWZvcmUN
Cj4gcmVndWxhZXIvbm9ybWFsIExVIGRlc2NyaXRwdG9yLiBzZWUgdWZzaGNkX2FkZF9sdXMoKTsN
Cj4gDQo+IEkgZGlkIGZ1cnRoZXIgZGVidWcgdG8gdmVyaWZ5IG15IHBhdGNoLCBhbmQgdGhlIHVu
aXQgZGVzY3JpcHRvciByZWFkDQo+IHNlcXVlbmNlOg0KPiANCj4gMS4gcmVhZCBSUE1CIGRlc2Ny
aXB0b3I6IGRlc2NfaWQgMiwgZGVzY19pbmRleCAweGM0DQo+IDIuIHJlYWQgTFUgMCBkZXNjcmlw
dG9yOiBkZXNjX2lkIDIsIGRlc2NfaW5kZXggMA0KPiAzLiByZWFkIExVIDAgZGVzY3JpcHRvcjog
ZGVzY19pZCAyLCBkZXNjX2luZGV4IDENCj4gNC4gcmVhZCBMVSAwIGRlc2NyaXB0b3I6IGRlc2Nf
aWQgMiwgZGVzY19pbmRleCAyDQo+IDUuIHJlYWQgTFUgMCBkZXNjcmlwdG9yOiBkZXNjX2lkIDIs
IGRlc2NfaW5kZXggNA0KPiAuLi4uDQo+IA0KPiA+IEhlbmNlLCBJIHRoaW5rIHlvdSBjYW4gZHJv
cCB0aGUgZXh0cmEgaWYsIGFuZCBqdXN0IGFkZCB0aGUgY29tbWVudC4NCj4gPg0KPiANCj4gc28s
IHRoaXMgJ2lmJyBpcyBzdGlsbCBuZWVkZWQuIG90aGVyd2lzZSwgTFUgZGVzY3JpcHRvciBsZW5n
dGggd2lsbCBiZQ0KPiBpbml0aWFsaXplZCBhcyAweDIzKFJQTUIgZGVzY3JpcHRvciBsZW5ndGgp
Lg0KPiANCkFoaGEsIG9rLiAgSSBzZWUgeW91ciBwb2ludCBub3csDQpGYWlyIGVub3VnaC4NCg0K
UmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
