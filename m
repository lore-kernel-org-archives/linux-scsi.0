Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25530C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 08:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E00762487F
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 08:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ISPDpiUN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZBkKwqf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgFUIWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 04:22:06 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:7157 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgFUIWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 04:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592727724; x=1624263724;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=l48BhsoHchTytZ4XYU3j9d3hSXSaxsCMYv+IXjuXzCs=;
  b=ISPDpiUNOR/o5v6H2Df+R+ruGloevQ09ru72hhafb9EuODv6GmS6juB2
   d/ZOSHYRwvXt8syPs5ekkSc0h9XRKvnC5Tweg7D70qE/BkRfcMHMhoKE0
   mZC5RRpYlYycvEjsD/nBGkg2Fd4nRktsZneQNHUt5irWQL4K0iyeEd7Dh
   6QD3U+S2K4djM+cmW179XKIGCD9LimfaPkqGApm2ur8ZVaGfZe0WcvSYR
   oq0RF2f5WxIjCMnLFca1X3Rn1du1JXFf88GlKRZd2pgcmYjdxx8ej+q0o
   5by1Q3t2Hq9FA9CoGesNHaD6iricUPoNiPtmGozlPhxK/1+im9lJFFUqn
   w==;
IronPort-SDR: Q2Xs2okD6pIKD82zRS7VbJgPgAhfqo7HagmkjQD06fC0XGlB7WmYeH4jmmN451BqZGLRRjKkrl
 ctWXkjuTjTbaIcG0WuPnNQSH7dw6jnUZcUORoIiA3tfT1Nx15jlu+YtVuoU7NkqUj0l4F/DqZW
 Rnyc0/3QXo+8iIpBTJ63Y5gUFNlU+NX4Ti+tLrthOHEsIhxQYCccqJ8D7jrz3NSlGkeqorTWr8
 2zzPYmLiP9U5GiaJljTPUHpD4xUxFUtdcjNdI/fiOTepvNlEJgOoUzIkFlHNxVitanH14Kcj19
 nEs=
X-IronPort-AV: E=Sophos;i="5.75,262,1589212800"; 
   d="scan'208";a="140531335"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2020 16:22:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7j4R4VhqvYD2MvAHi9pGMQ8oiOT0M3fk/w1+b4cZTuTOxagLw0U5E7khzyAu9VygY3RNyzn7cpqIsRyzi3OLTt+V3G74bco24TqvA1ID9n02LYXssrDFb5nsCf6eloeBSwt2RIvuw0RgYb7sVImWUETSF07owiX7gof2OVow/bafPej9W5oTxvqZAw54X6DHbjskaB/a7n/BvXe0/BFooWpxRZwFSYhcYnvhgY8lU86DDhdOyMiZXf+xm9HbhendhbMZWx80wtID0FKv2XDk/Yk0beFb2TzimbuKA6ZmwYygDvLYdeSz63qWqGX32XDZQuISoS2vvrGiMpTpW2rWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l48BhsoHchTytZ4XYU3j9d3hSXSaxsCMYv+IXjuXzCs=;
 b=R09zb0Bu3PG6+WXPIyvgS32hHy3SycoA2GlomXb0LwhUvRnC+d6HQ/Q4Q5mr+L8L7cMub7+LpdfvpmZWNIQRov/CrpckLOvBickvee79pP1Ez1IK0Hn5e7QZHMLcG89B9MICGNqV914iSZUtHGM23z5OTlhaRc21ZIJi+dxmSMQJiTk/2SFBwekklgBpw/GuSL2EcnQCwo9dHFfkAQakWHHXRzq4/i0M0sE04fyIF+KgS6o+7VVqhIp53Nzj8xx4s1hyQVADd7GT/C8G+MxgEXVrn5gExnllqe71MH8dyEzu6j6IpH5GZmxLINDv/iM1AQEnbV5ShUxrt+mT9R3DdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l48BhsoHchTytZ4XYU3j9d3hSXSaxsCMYv+IXjuXzCs=;
 b=ZBkKwqf9x0Y3syAH52ApYBEljvnS08R6CY7nlWKrNfxKrm4Li+T0ZD3cOqEN/AW4VlBjz0sLL/r9Mrp7p+FvhX+8oNSFQpwlf3l6hq92hhYiPRUyAdwJ9AXwj9QVK8t5Ln6ZvU4PYpa24+6k+z644IfpWSlEmb+BqLX10LiYHs0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3997.namprd04.prod.outlook.com (2603:10b6:805:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sun, 21 Jun
 2020 08:22:02 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.026; Sun, 21 Jun 2020
 08:22:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Subject: RE: [RFC PATCH v1 0/2] support various values per device
Thread-Topic: [RFC PATCH v1 0/2] support various values per device
Thread-Index: AQHWRtXq+CfxGP1QuUORwGChNx14wqjiutYQ
Date:   Sun, 21 Jun 2020 08:22:02 +0000
Message-ID: <SN6PR04MB46402E9A01DE395EAAE223D3FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200620073912epcas2p469d0082af35ff54a8e84793feed2ab6d@epcas2p4.samsung.com>
 <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b215d91-eefb-44c4-917d-08d815bc2cc5
x-ms-traffictypediagnostic: SN6PR04MB3997:
x-microsoft-antispam-prvs: <SN6PR04MB3997F6CC61EC815E05301A56FC960@SN6PR04MB3997.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04410E544A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byaWTC0Vha6+trY2feRoA1gGaM1aFY8/dH1grRgivFt1p/eT5wEW79TEM8dE5W9UCQMSW8jd1SQX0CqvF3XjgIqVz3SMqYdA6A+Gb6frq+B6ZHUApR4i21VTzpNZ3c/aZ227ZF8MPO5zzolpq8nItA89KtB1lCTcGdL43t/eb+j0ZvZSLBOlkNTLvxYD+a7rjLPCIfcT+vEgDWJ92BrGIoujqEsGBDwR+G9AYSN/CH0eo6HEaKIH2HPoDGrLFDM9kbkBNIMxL97YOzVn5je/yXgNyYFpFF72WICXFW/MD4srhD1eh7Xl122mUpO/HmSEy0EQizTyTWH1Wt1PEejtHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39850400004)(136003)(376002)(346002)(66556008)(64756008)(5660300002)(71200400001)(110136005)(76116006)(186003)(8936002)(66446008)(2906002)(8676002)(9686003)(55016002)(66946007)(478600001)(52536014)(4744005)(66476007)(316002)(7696005)(6506007)(26005)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: toRFLGYVxW+u9n29MbfQsZg0obMPDoAVub7rMpPjRogqJejsUAV8fXPWeT7IXomwmX6ZuQee5m1+8AAvyM1dh15O1GT7H5EBfnQA3cRnnLEYzIdFHLVkrIF2pVph+eZ6eG59UoufQ1CYZ/spCgyZ5xdZFzsDu1ckQKdRkZoRB4Is4GMt/v1UKXrV66AExWYNWLAsJdYAqqYdy6wwDVLxAdd899bM8cc+r3sUl3VD0XEM2EbOIHjpyQ+hQ9lH6TxmnFVHijjeE8CVntV9AGv8Au609t+mVAj4BEyTy4vdplR5Zqc3KlZTGERiGGCwnJQRBGG5NBqmLAd91u+4MDyXBcwCuBtf3O2M2+6XCbgBoxgPq5XA/My+M+jtyVm1HGztsU/Qq4g/RrkutCjEhYDqY7hs+lEppv8xsIs0HjjpuLe1SIvAl0W+St+mNQd4aHo/vKqKj0/tb6SFrWbHfr9qH/GNdgLnWY6/9MZdM5Ezlo4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b215d91-eefb-44c4-917d-08d815bc2cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2020 08:22:02.0986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBLBBE5Cn6iHSVPAQDFV7h0lAhmSm8aZKtGIdVSC6iMyNzH1XDR84gg52jJZGp2DIUEInYJffiPlOw8D9UbHKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3997
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gUmVzcGVjdGl2ZSBVRlMgZGV2aWNlcyBoYXZlIHRoZWlyIG93biBjaGFyYWN0ZXJp
c3RpY3MgYW5kDQo+IG1hbnkgb2YgdGhlbSBjb3VsZCBiZSBhIGZvcm0gb2YgbnVtYmVycywgc3Vj
aCBhcyB0aW1lb3V0DQo+IGFuZCBhIG51bWJlciBvZiByZXRpcmVzLiBUaGlzIGludHJvZHVjZXMg
dGhlIHdheSB0byBzZXQNCj4gdGhvc2UgdGhpbmdzIHBlciBzcGVjaWZpYyBkZXZpY2UgdmVuZG9y
IG9yIHNwZWNpZmljIGRldmljZS4NCj4gDQo+IEkgd3JvdGUgdGhpcyBsaWtlIHRoZSBzdHlsZSBv
ZiB1ZnNfZml4dXBzIHN0dWZmcy4NCkxvb2tzIGxpa2UgeW91ciBwcmVwYXJpbmcgdGhlIGdyb3Vu
ZCBvZiBtYWtpbmcgcXVpcmtzIGEgY29tbW9uIHByYWN0aWNlLi4uDQpBbnl3YXksIHdlIGFscmVh
ZHkgaGF2ZSB0aGF0IG9wdGlvbiBwZXIgcGxhdGZvcm0vdmVuZG9yIC0gDQp3aGF0IGlzIHRoYXQg
eW91IGFyZSBtaXNzaW5nPw0KDQpBbmQgYXMgZmFyIGFzIGZEZXZpY2VJbml0ICAtIHRoZSBzcGVj
IHNheXM6DQoiVGhlIGhvc3QgcG9sbHMgdGhlIGZEZXZpY2VJbml0IGZsYWcgdG8gY2hlY2sgdGhl
IGNvbXBsZXRpb24gb2YgdGhlIHByb2Nlc3MuIg0KWW91ciBjaGFuZ2VzIGFyZSBhbGlnbiB3aXRo
IHRoYXQgZGVmaW5pdGlvbiwgc28gSSBhbSBub3Qgc3VyZSB0aGF0IGV2ZW4gYSBuZXcgcXVpcmsg
aXMgbmVlZGVkPw0KDQpUaGFua3MsDQpBdnJpDQo=
