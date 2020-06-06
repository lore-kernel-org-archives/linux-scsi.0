Return-Path: <SRS0=2jUW=7T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E595C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 12:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A932074B
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 12:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aMrllNfE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iQlX0VOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgFFMCj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Jun 2020 08:02:39 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33632 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgFFMCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jun 2020 08:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591444956; x=1622980956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P3xfV8tJsibFeAJgGtDDBqN0PrZa2g4z9daE9CmBrEM=;
  b=aMrllNfEo20/oCYf0j1LgWD5hNAdAv3n0e4nipzw0+xsxkC8bpiECrld
   HgSKMKP7lxAyzUSeOOa4RbjcBuv/BlRkyggGs6UdM04twa5eKjBfjE0BN
   St/HUc6axKqtEA9fdmEMbE+9wuCkFwWXR4euwbZXpF+sqUH6Zh9RJX4ul
   vUeaDYhD/DUlN6aNyyuu+fTAn8P2RrRYnAdy8AVlNbRJdxjr++E/w+gVg
   OXD8ZLcmjy3b/YprZCHl7E2kdBX9DFRI66ZSHilJVvUICOokCXmMc8uUW
   oYvOWJvJO9EgednDHi4Tlay6atSIEKdrHadxYH/jBjjsdKscHuLNhlmtd
   g==;
IronPort-SDR: uaNsZTROh9AJURXNuJfDQZNSuzCZ5+1ZjO2pX5P2FpmfhrBOSLjh8CLW4R4B8xa7jaQUKLA1b3
 7jfetgPE34HRwaoA49ATd8/peMuHxV1QjUmh/HjO8QnzSB0wT1Ce/lLOgy3MtZDwskIA7M2aJA
 3Swhub98Dquqpys2HxZtCK8Q+sxUYtisZJfiSkMMyfSLM9f2fMfMA56uSy9oHLDdiXFmYyOzGX
 cFKNNmbei2Vmcbm3fZb6gIkSMsaxOUQ5QAkSN+X1+MrQoK7CtUO3jAvWXReogDa7rJPciOinex
 Syc=
X-IronPort-AV: E=Sophos;i="5.73,480,1583164800"; 
   d="scan'208";a="139343087"
Received: from mail-sn1nam02lp2050.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.50])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2020 20:02:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mc77QcJae9FZrQSU1SLrsldI+PsmnBPuTlhIVtG4sD6MvhsWDKFh5oYvnqljy0oDFNvMOTtoGDsNNMSPhMj5tvpIuhG4VFNvH1TuweHGBglx1PrU5VgX0j6q6nIMnaiOHB69nifovmHVe0/0tHsq72rFLjMwGI9x5OEjFAv6Nbk4YdPJGKOxx7vBrfqHNzWk06kvA1g0TEpoCN8pd0kf41ynVRRzapU7kC/0FGYDBdzgb5ERNIzk0A4i2eatd6eOVzKbTQyfpX1N/0lqUtZD/xrtxAgoPCqHwI9mHepcr506WNqzgBgOfoV+5KMBKg4Js2313ASvzACJSnUxPFy4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3xfV8tJsibFeAJgGtDDBqN0PrZa2g4z9daE9CmBrEM=;
 b=QJ2H8fJvj30IoICu20b2Pcg932bbMpZbwZ9wrsq8X4VdqWrCZVsusCRjfBgsz3LOge0qvCj/hE/q+fDY+iL8X6gUYLeOlZ7K6MotytXorzSrUWtkPyUkjQrmT9fkilE69HC7hO1f3wmD5httdTWw3HI6TCcmywmK6sCFAQWgWbkzJys+3lkGWPFDT7N4g9v7Za2z6NCAgJ/JlFeaT8x5jWGDeFABg6JNshywmWg+cK9B9EY1/eNhBjeCC6+QdLODlKaafqT5fV6AoR2MeFno9dSTYiefX6qjBh9GHQRZiXoLir0XpSFfgcFfT94yWXOqiEe5ahWB3yac0I7k0skq5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3xfV8tJsibFeAJgGtDDBqN0PrZa2g4z9daE9CmBrEM=;
 b=iQlX0VOdZWslbzkaF/ysCwNaFQp4nn0PnponKcmVJk9rpU832ZjEJ+gBkyCkkll4CTP1ZfrFpc+efpxkT2XCr042gtIdFvnLmmYcp9dqFjeNP43tyDYbSJhwdhD276dBZZiKc25/yqqK5sNlLRuPuoXefywbfZoGdF6Detq+9RY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5103.namprd04.prod.outlook.com (2603:10b6:805:93::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Sat, 6 Jun
 2020 12:02:33 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.019; Sat, 6 Jun 2020
 12:02:33 +0000
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
Subject: RE: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWOtdzuuOrqvV8XUaJuwxPo4VLXKjLfTtQ
Date:   Sat, 6 Jun 2020 12:02:32 +0000
Message-ID: <SN6PR04MB4640DC01229F2073C2BD3103FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30e98b0d-7f0f-4926-7f1f-08d80a117ee6
x-ms-traffictypediagnostic: SN6PR04MB5103:
x-microsoft-antispam-prvs: <SN6PR04MB5103A633148963DE1D3681F9FC870@SN6PR04MB5103.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04267075BD
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcvc77R7SXSSgZ1tSDtVpNl0Mm4eknN0pkW1bkwfVrlUt/mLoLAa/sVGrClY9nDHZ1pgtBNTP5UovNJRrIAjMLy3PhCXz7J8mRFgeU7l/25k6Kj26Ce1fBkPEeHAJEtGwey/QCmyb1R4sAOExnUlcgnFoc/IOhTOtn6mCrJ2Yu/CN7ne8Z3h4kat8HAXZRCLEDVoO6kM+G4c9anawpGsHUIbOHrer1J1S4Ptm8osL3yk8sn78492JjhEa/l5sQSEMMda1fDETD5pkIUyfE39t+e4uoSbWTwSy1Q6eWe/p4QzyUWrzy3174m+0hF6iywgRRDIfpw1DOFrIwWd5oT7hG0BJIbkg68kbIA+lbI3D8quWdf41PPFwZMgLlUy1GmYQVk9w5HwtsHOrcWF0Ru+VZQEtIcU0LrZJw+pNTk48CAfyk/WxR+/vvS7FW6wMRNbZVsu9eA2dUbPq+bPtEVZqTCc3jodEe9zjfaHe9lhflQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(66476007)(71200400001)(7416002)(76116006)(55016002)(52536014)(66556008)(66946007)(66446008)(4326008)(8936002)(86362001)(8676002)(316002)(478600001)(33656002)(6506007)(9686003)(110136005)(54906003)(64756008)(2906002)(7696005)(186003)(83380400001)(966005)(5660300002)(26005)(921003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vBpluyfj69/JLi+Dh7+CMuBFAUAjo/pFY8kNL2CwnjAJW9xsPn2/rFrhYNLvcVueJiLijep8kjRZ7cO9+m+wYdlwCmYKUA8f4qoOtztgNW0VZ0NAAJ/JPXkkiR2qT9LsmOO8H1sYIRyz1TilLom0ddOXVweRVmE/qD3IQaK+pgp97io5CS3s8IAC/5mQEGr7omczh3m3fPsbcEnqqSAXMbKiYWIL3IcePcwqH/T8UT9eX7/S+9vN3LlpGnl0WpCN0gzVOMHRMWn+85f+ZT5OjF4G8zxkxTa18PWvPnUpMs3bWTL8K5YVd4kUaoYyozq/dvuRH8AQd0IV8DQNELh3VZyP7En8AYPnkNeD91fjcMJxbpuUVqiYweT7GClav10f7ZqQfg4Eg2QiziYLxpPbBuPILgUTtRBFhf8ekLROjGXi51ePD6pZNjRnkHOGsGTkkccf88/Dl/TUCOBcd9o3d+89chs6ZtxdB3c1qu3n5QQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e98b0d-7f0f-4926-7f1f-08d80a117ee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2020 12:02:33.1402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //3PwhhwqnpN4pNYPZcBrpOqp+/7SkuSU2hSvHlikgwik4bWnAmTsJFXnbT3+eiOlcGfL66SAjX9Fn5kVwxzhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5103
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQo+IA0KPiBOQU5EIGZsYXNoIG1lbW9yeS1iYXNlZCBzdG9yYWdlIGRldmljZXMgdXNlIEZs
YXNoIFRyYW5zbGF0aW9uIExheWVyIChGVEwpDQo+IHRvIHRyYW5zbGF0ZSBsb2dpY2FsIGFkZHJl
c3NlcyBvZiBJL08gcmVxdWVzdHMgdG8gY29ycmVzcG9uZGluZyBmbGFzaA0KPiBtZW1vcnkgYWRk
cmVzc2VzLiBNb2JpbGUgc3RvcmFnZSBkZXZpY2VzIHR5cGljYWxseSBoYXZlIFJBTSB3aXRoDQo+
IGNvbnN0cmFpbmVkIHNpemUsIHRodXMgbGFjayBpbiBtZW1vcnkgdG8ga2VlcCB0aGUgd2hvbGUg
bWFwcGluZyB0YWJsZS4NCj4gVGhlcmVmb3JlLCBtYXBwaW5nIHRhYmxlcyBhcmUgcGFydGlhbGx5
IHJldHJpZXZlZCBmcm9tIE5BTkQgZmxhc2ggb24NCj4gZGVtYW5kLCBjYXVzaW5nIHJhbmRvbS1y
ZWFkIHBlcmZvcm1hbmNlIGRlZ3JhZGF0aW9uLg0KPiANCj4gVG8gaW1wcm92ZSByYW5kb20gcmVh
ZCBwZXJmb3JtYW5jZSwgd2UgcHJvcG9zZSBIUEIgKEhvc3QgUGVyZm9ybWFuY2UNCndlIHByb3Bv
c2UgIC0tPiBqZWRlYyBzcGVjIFhYWCBwcm9wb3NlcyDigKYNCmFuZCBoZXJlIHlvdSBhbHNvIGRp
c2Nsb3NlIHdoYXQgdmVyc2lvbiBvZiB0aGUgc3BlYyBhcmUgeW91IHN1cHBvcnRpbmcNCg0KPiBC
b29zdGVyKSB3aGljaCB1c2VzIGhvc3Qgc3lzdGVtIG1lbW9yeSBhcyBhIGNhY2hlIGZvciB0aGUg
RlRMIG1hcHBpbmcNCj4gdGFibGUuIEJ5IHVzaW5nIEhQQiwgRlRMIGRhdGEgY2FuIGJlIHJlYWQg
ZnJvbSBob3N0IG1lbW9yeSBmYXN0ZXIgdGhhbiBmcm9tDQo+IE5BTkQgZmxhc2ggbWVtb3J5Lg0K
PiANCj4gVGhlIGN1cnJlbnQgdmVyc2lvbiBvbmx5IHN1cHBvcnRzIHRoZSBEQ00gKGRldmljZSBj
b250cm9sIG1vZGUpLg0KPiBUaGlzIHBhdGNoIGNvbnNpc3RzIG9mIDQgcGFydHMgdG8gc3VwcG9y
dCBIUEIgZmVhdHVyZS4NCj4gDQo+IDEpIFVGUy1mZWF0dXJlIGxheWVyDQo+IDIpIEhQQiBwcm9i
ZSBhbmQgaW5pdGlhbGl6YXRpb24gcHJvY2Vzcw0KPiAzKSBSRUFEIC0+IEhQQiBSRUFEIHVzaW5n
IGNhY2hlZCBtYXAgaW5mb3JtYXRpb24NCj4gNCkgTDJQIChsb2dpY2FsIHRvIHBoeXNpY2FsKSBt
YXAgbWFuYWdlbWVudA0KPiANCj4gVGhlIFVGUy1mZWF0dXJlIGlzIGFuIGFkZGl0aW9uYWwgbGF5
ZXIgdG8gYXZvaWQgdGhlIHN0cnVjdHVyZSBpbiB3aGljaCB0aGUNCj4gVUZTLWNvcmUgZHJpdmVy
IGFuZCB0aGUgVUZTLWZlYXR1cmUgYXJlIGVudGFuZ2xlZCB3aXRoIGVhY2ggb3RoZXIgaW4gYQ0K
PiBzaW5nbGUgbW9kdWxlLg0KPiBCeSBhZGRpbmcgdGhlIGxheWVyLCBVRlMtZmVhdHVyZXMgY29t
cG9zZWQgb2YgdmFyaW91cyBjb21iaW5hdGlvbnMgY2FuIGJlDQo+IHN1cHBvcnRlZC4gQWxzbywg
ZXZlbiBpZiBhIG5ldyBmZWF0dXJlIGlzIGFkZGVkLCBtb2RpZmljYXRpb24gb2YgdGhlDQo+IFVG
Uy1jb3JlIGRyaXZlciBjYW4gYmUgbWluaW1pemVkLg0KTGlrZSBCYXJ0LCBJIGFtIG5vdCBzdXJl
IHRoYXQgdGhpcyBleHRyYSBtb2R1bGUgaXMgbmVlZGVkLg0KSXQgb25seSBtYWtlcyBzZW5zZSBp
ZiBpbmRlZWQgdGhlcmUgYXJlIHNvbWUgY29tbW9uIGNhbGxzIHRoYXQgY2FuIGJlIHNoYXJlZCBi
eSBzZXZlcmFsIGZlYXR1cmVzLg0KVGhlcmUgYXJlIHVwIHRvIG5vdyAxMCBleHRlbmRlZCBmZWF0
dXJlcyBkZWZpbmVkLCBidXQgbm9uZSBvZiB0aGVtIGNhbiBzaGFyZSBhIGNvbW1vbiBhcGkuDQpX
aGF0IG90aGVyIGZlYXR1cmVzIGNhbiBzaGFyZSB0aGlzIGFkZGl0aW9uYWwgbGF5ZXI/ICBBbmQg
aG93IHRob3NlIG9wcyBjYW4gYmUgcmV1c2VkPw0KSWYgeW91IGhhdmUgc29tZSBmdXR1cmUgaW1w
bGVtZW50YXRpb25zIGluIG1pbmQsIHlvdSBzaG91bGQgYWRkIHRoaXMgYXBpIG9uY2UgeW91J2xs
IGFkZCB0aG9zZS4NCg0KPiANCj4gSW4gdGhlIEhQQiBwcm9iZSBhbmQgaW5pdCBwcm9jZXNzLCB0
aGUgZGV2aWNlIGluZm9ybWF0aW9uIG9mIHRoZSBVRlMgaXMNCj4gcXVlcmllZC4gQWZ0ZXIgY2hl
Y2tpbmcgc3VwcG9ydGVkIGZlYXR1cmVzLCB0aGUgZGF0YSBzdHJ1Y3R1cmUgZm9yIHRoZSBIUEIN
Cj4gaXMgaW5pdGlhbGl6ZWQgYWNjb3JkaW5nIHRvIHRoZSBkZXZpY2UgaW5mb3JtYXRpb24uDQo+
IA0KPiBBIHJlYWQgSS9PIGluIHRoZSBhY3RpdmUgc3ViLXJlZ2lvbiB3aGVyZSB0aGUgbWFwIGlz
IGNhY2hlZCBpcyBjaGFuZ2VkIHRvDQo+IEhQQiBSRUFEIGJ5IHRoZSBIUEIgbW9kdWxlLg0KPiAN
Cj4gVGhlIEhQQiBtb2R1bGUgbWFuYWdlcyB0aGUgTDJQIG1hcCB1c2luZyBpbmZvcm1hdGlvbiBy
ZWNlaXZlZCBmcm9tIHRoZQ0KPiBkZXZpY2UuIEZvciBhY3RpdmUgc3ViLXJlZ2lvbiwgdGhlIEhQ
QiBtb2R1bGUgY2FjaGVzIHRocm91Z2ggdWZzaHBiX21hcA0KPiByZXF1ZXN0LiBGb3IgdGhlIGlu
LWFjdGl2ZSByZWdpb24sIHRoZSBIUEIgbW9kdWxlIGRpc2NhcmRzIHRoZSBMMlAgbWFwLg0KPiBX
aGVuIGEgd3JpdGUgSS9PIG9jY3VycyBpbiBhbiBhY3RpdmUgc3ViLXJlZ2lvbiBhcmVhLCBhc3Nv
Y2lhdGVkIGRpcnR5DQo+IGJpdG1hcCBjaGVja2VkIGFzIGRpcnR5IGZvciBwcmV2ZW50aW5nIHN0
YWxlIHJlYWQuDQo+IA0KPiBIUEIgaXMgc2hvd24gdG8gaGF2ZSBhIHBlcmZvcm1hbmNlIGltcHJv
dmVtZW50IG9mIDU4IC0gNjclIGZvciByYW5kb20NCj4gcmVhZA0KPiB3b3JrbG9hZC4gWzFdDQo+
IA0KPiBUaGlzIHNlcmllcyBwYXRjaGVzIGFyZSBiYXNlZCBvbiB0aGUgIjUuOC9zY3NpLXF1ZXVl
IiBicmFuY2guDQo+IA0KPiBbMV06DQo+IGh0dHBzOi8vd3d3LnVzZW5peC5vcmcvY29uZmVyZW5j
ZS9ob3RzdG9yYWdlMTcvcHJvZ3JhbS9wcmVzZW50YXRpb24vamVvDQo+IG5nDQpUaGlzIDIwMTcg
c3R1ZHksIGlzIGJlaW5nIGNpdGVkIGJ5IGV2ZXJ5b25lLCBidXQgZG9lcyBub3QgcmVhbGx5IGRl
c2NyaWJlcyBpdCdzIHRlc3Qgc2V0dXAgdG8gaXRzIGRldGFpbHMuDQpJdCAgZG9lcyBzYXkgaG93
ZXZlciB0aGF0IHRoZXkgdXNlZCBhIDE2TUIgc3VicmVnaW9ucyBvdmVyIGEgcmFuZ2Ugb2YgMUdC
LA0Kd2hpY2ggY2FuIGJlIGNvdmVyZWQgYnkgYSA2NCBhY3RpdmUgcmVnaW9ucywgRXZlbiBmb3Ig
YSBzaW5nbGUgc3VicmVnaW9uIHBlciByZWdpb24uDQpNZWFuaW5nIG5vIGV2aWN0aW9uIHNob3Vs
ZCB0YWtlIHBsYWNlLCB0aHVzIEhQQiBvdmVyaGVhZCBpcyBtaW5pbWl6ZWQuDQpEbyB3ZSBoYXZl
IGEgbW9yZSByZWNlbnQgcHVibGljIHN0dWRpZXMgdGhhdCBzdXBwb3J0cyB0aG9zZSBpbXByZXNz
aXZlIGZpZ3VyZXM/DQoNClRoYW5rcywNCkF2cmkNCg==
