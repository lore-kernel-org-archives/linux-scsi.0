Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1FEC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 10:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE21C20728
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 10:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VuEQIIjJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AOhZXv/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKOKMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:12:32 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27612 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfKOKMc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 05:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573812752; x=1605348752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tZDecpgw6kFZFv44Ocq24JybAtL/FlS+x6iDphld12g=;
  b=VuEQIIjJN5ZzOv2bjlHiApHAyXGeDwV29FY462auTwNuFtyz2y5RklUi
   1ouZ4ROwOwdj1RFQAZ6wrKMTWQbxzVraSj1Av9UQc80MGkkTmJdS1dkqZ
   5G6jqApac2jTJoOhlIkEKZAxl8GM2h1D4dhhSsoUJ+mvtMpBrjvi4JnLA
   f4fMJP47S3w6n9ZrptCJwvL3eB8EDhQybDaLoq2uqCrEVT3812k8XG7uf
   cIB65grTZ/1MVCkyGHLIFQvRsksmKiN4h9ZFypdA8jTjGCBFjwj6Ktu+x
   sA/pt59G8OtYRGsGm3S42CJ63VO4ZD+Z+v9Dz513qPskjkyoZEUIIIlo2
   g==;
IronPort-SDR: vCj58XQtbUN6xYkLEoxQkXu0Mfle/UTFX6zFVLofsGTmvYf+Nkl3RsMpNiCQi8vgDwpULvMjuA
 /MRQwKQ0zbrHw1Vegm5Kov20+M47HYsFBwxpNnUiyoyxpR5zrcPR6Y/8XxqbJDLldaDnApsz8g
 j3TDqtz5QreUSSjjVG+wUBMhepqaXH6LDR6OdCcDgsl8c86qm3WZRoZrHPFY4DNWf1S/jwnzan
 PyqA1XnRy3rNaCEYPPuVM+MqR1Zt9FWUeiqmD2ZXInvuF7M5CdxsxZj7gaatmcA3gpPouX9eFx
 hvI=
X-IronPort-AV: E=Sophos;i="5.68,308,1569254400"; 
   d="scan'208";a="123865788"
Received: from mail-co1nam04lp2059.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.59])
  by ob1.hgst.iphmx.com with ESMTP; 15 Nov 2019 18:12:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSkMEyetroNNjFkDL64NizzyZfgNiOk8e55gsE1CkpI36Id6bEWQqa2BoH18+GDxRX6vmAJLM9F3UxUVEd4sUhbngSTT0jMeX/AY41Sa+Z8n4DQHlO7FoZIPNK6pAjaM8PbLaFyPsSRGUn4p9Bc0qFShpTinCI6h2lVAvO1gV/5GTHDEjjjDBPxmcILfsY7V74sqE6fOshs7eJ3d0ig69duRs7axtyrT6J3Y/uBUU1mFUuCYYeBzjeZJrJv9Moxp7ZXF7VokNSxD3ek1ym3we0MXlOzTN++9pkxjH8aZLwUXxP+2M5KI6UYL20h6ctUtc8KwpQmfIWi9FB7SWqo9Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZDecpgw6kFZFv44Ocq24JybAtL/FlS+x6iDphld12g=;
 b=bVUCMZR/9UVU9KTZE9xXqObgszHNLaxeTPHnHeHJ1rvWwzDNoTVXfxKUbMY3VsFcieOBoJHLv8aX0NKnG0QvO460jZTfWFdtZhjQtPYgeCIcuXlUgwZHgcuRnv8eHjyQ0NYMffwleqw7i3HE3aUCWaQeboH0SXOIhWkoeMkOUUfz2a78ovtfcGeS/cQ+MG34f9roguRdeMM67lUPyvZxZ+VgZTj/2wMpE9ty4aC37+aAe+2IJ0hoC2IeGpjtYKJCggfLKo4KHhtDvBhu8i4PrVmtbc0KbATxnJdEzL5l9Tr8p1Ku6PX78mQ6KgeXsY/JnP8slDXFbW6FTpbQKBI5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZDecpgw6kFZFv44Ocq24JybAtL/FlS+x6iDphld12g=;
 b=AOhZXv/wfxMmDaYyO3x3u81xP0HA5E6FooYZp0c7Gno8ykOdHhtXZdV+WEYMswjf7AmifhM8Rn65b06iBUx9lB8e8k5W2rfKC2v22hb1wdOi6FF3IBaTJAGU93lqMki9cGnboTSKwxJB2kVRBqqSQ1h9p2HB4BAli3zEKo0RVq4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5648.namprd04.prod.outlook.com (20.179.23.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Fri, 15 Nov 2019 10:12:27 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 10:12:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 7/7] scsi: ufs: Fix error handing during hibern8 enter
Thread-Topic: [PATCH v5 7/7] scsi: ufs: Fix error handing during hibern8 enter
Thread-Index: AQHVm3tkSmLzEFzwAUeJ7EeuJddyr6eMAtpw
Date:   Fri, 15 Nov 2019 10:12:27 +0000
Message-ID: <MN2PR04MB6991880C763F5986A1D2F700FC700@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
 <1573798172-20534-8-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573798172-20534-8-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.90.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f780ee0-7d9f-4c1b-4868-08d769b45140
x-ms-traffictypediagnostic: MN2PR04MB5648:
x-microsoft-antispam-prvs: <MN2PR04MB5648C3FC0E4EB44CBCDC10ABFC700@MN2PR04MB5648.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(7696005)(66556008)(64756008)(66446008)(66946007)(2201001)(2501003)(14454004)(66476007)(6246003)(86362001)(478600001)(52536014)(25786009)(81166006)(81156014)(8936002)(8676002)(5660300002)(33656002)(4326008)(7416002)(476003)(11346002)(316002)(486006)(76116006)(66066001)(6116002)(3846002)(2906002)(74316002)(446003)(305945005)(7736002)(6436002)(71200400001)(71190400001)(55016002)(14444005)(256004)(54906003)(76176011)(9686003)(6506007)(102836004)(110136005)(186003)(26005)(99286004)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5648;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8W3skA7wyMMseS/sEWWgePp06g40V/P/iBoMBG4qse8ZZLo3IVVqzE0fsqRajYzDB2v+e8JJDUIqxav9B88OVEKoeXvUtNt2YIZyMncYxQH4Otk5RpG/oJMLzhv8H3SxGXGQ88looB9BZ/EWXVJVfi6BH9yve0g0H88rK1YkdmvJBYOr9uHhGct62tbeP3+8ENiBFEOblQW9/svSNEgM3xW5Ct5BBjr613ekssLYM5UWE9QNBwhZEwYHygIghbOGPPAgnJ7P8MAt00sSY8W8prNtAgztap5+1aPldqZLJYHnBq9sALvN+pHjOGT1gLjkwnLdPjT5tQ2uhgBJVeQNQMylGx+H7ivupl6dMXN16NL5bL9WVHJA17D0SBpNnh6Rgy1DNfqyuo9wwcY/nQM9xaipNIU3YMS2iJviipcxKtllYi85FLr/EX91CMSqhnme
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f780ee0-7d9f-4c1b-4868-08d769b45140
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 10:12:27.2748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZKi/V3XKPW4jvLUzM812f1i6hZMHH4IpeIqitlkU0NhMFCKdYnxn9TELXgDrLUx9THds1q5tbGgv4iISScBvYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5648
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gRnJvbTogU3ViaGFzaCBKYWRhdmFuaSA8c3ViaGFzaGpAY29kZWF1cm9yYS5vcmc+
DQo+IA0KPiBEdXJpbmcgY2xvY2sgZ2F0aW5nICh1ZnNoY2RfZ2F0ZV93b3JrKCkpLCB3ZSBmaXJz
dCBwdXQgdGhlIGxpbmsgaGliZXJuOCBieQ0KPiBjYWxsaW5nIHVmc2hjZF91aWNfaGliZXJuOF9l
bnRlcigpIGFuZCBpZiB1ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoKSByZXR1cm5zDQo+IHN1Y2Nl
c3MgKDApIHRoZW4gd2UgZ2F0ZSBhbGwgdGhlIGNsb2Nrcy4NCj4gTm93IGxldOKAmXMgem9vbSBp
biB0byB3aGF0IHVmc2hjZF91aWNfaGliZXJuOF9lbnRlcigpIGRvZXMgaW50ZXJuYWxseToNCj4g
SXQgY2FsbHMgX191ZnNoY2RfdWljX2hpYmVybjhfZW50ZXIoKSBhbmQgaWYgZmFpbHVyZSBpcyBl
bmNvdW50ZXJlZCwgbGluayByZWNvdmVyeQ0KPiBzaGFsbCBwdXQgdGhlIGxpbmsgYmFjayB0byB0
aGUgaGlnaGVzdCBIUyBnZWFyIGFuZCByZXR1cm5zIHN1Y2Nlc3MgKDApIHRvDQo+IHVmc2hjZF91
aWNfaGliZXJuOF9lbnRlcigpIHdoaWNoIGlzIHRoZSBpc3N1ZSBhcyBsaW5rIGlzIHN0aWxsIGlu
IGFjdGl2ZSBzdGF0ZSBkdWUgdG8NCj4gcmVjb3ZlcnkhDQo+IE5vdyB1ZnNoY2RfdWljX2hpYmVy
bjhfZW50ZXIoKSByZXR1cm5zIHN1Y2Nlc3MgdG8gdWZzaGNkX2dhdGVfd29yaygpIGFuZA0KPiBo
ZW5jZSBpdCBnb2VzIGFoZWFkIHdpdGggZ2F0aW5nIHRoZSBVRlMgY2xvY2sgd2hpbGUgbGluayBp
cyBzdGlsbCBpbiBhY3RpdmUgc3RhdGUNCj4gaGVuY2UgSSBiZWxpZXZlIGNvbnRyb2xsZXIgd291
bGQgcmFpc2UgVUlDIGVycm9yIGludGVycnVwdHMuIEJ1dCB3aGVuIHdlIHNlcnZpY2UNCj4gdGhl
IGludGVycnVwdCwgY2xvY2tzIG1pZ2h0IGhhdmUgYWxyZWFkeSBiZWVuIGRpc2FibGVkIQ0KPiAN
Cj4gVGhpcyBjaGFuZ2UgZml4ZXMgZm9yIHRoaXMgYnkgcmV0dXJuaW5nIGZhaWx1cmUgZnJvbQ0K
PiBfX3Vmc2hjZF91aWNfaGliZXJuOF9lbnRlcigpIGlmIHJlY292ZXJ5IHN1Y2NlZWRzIGFzIGxp
bmsgaXMgc3RpbGwgbm90IGluIGhpYmVybjgsDQo+IHVwb24gcmVjZWl2aW5nIHRoZSBlcnJvciB1
ZnNoY2RfaGliZXJuOF9lbnRlcigpIHdvdWxkIGluaXRpYXRlIHJldHJ5IHRvIHB1dCB0aGUNCj4g
bGluayBzdGF0ZSBiYWNrIGludG8gaGliZXJuOC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFN1Ymhh
c2ggSmFkYXZhbmkgPHN1Ymhhc2hqQGNvZGVhdXJvcmEub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBD
YW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxh
dnJpLmFsdG1hbkB3ZGMuY29tPg0K
