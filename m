Return-Path: <SRS0=D4W/=WL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55BFC32757
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 00:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867D5216F4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 00:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="DAL151Yd";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="sSulQA0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfHOAk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 20:40:28 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:32375 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbfHOAk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 20:40:27 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2019 20:40:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2206; q=dns/txt; s=iport;
  t=1565829627; x=1567039227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sl9cIkLwBOxShxMMfKwe9ivNs/CmuLsMGqJUc1r1RCM=;
  b=DAL151YdQJNsiFAAVRGDVbgb/bKUhFHNHPF/M07ZkCMol6KkCMryd1aI
   KIHkIO2DPNgmxPiAjvApzEYFxE8NN53a1Xfp2KJ4HwdaN4vtx163rn4tC
   AWW+OxL7VMWW5izhZccgyddqcyzh3ulW2bmx5J/wAwYMG0phxtBQsschX
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3ARAQHPRT7ZLSs6/Sqezf+DeMXYNpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESXBNfA8/wRje3QvuigQmEG7Zub+FE6OJ1XH1?=
 =?us-ascii?q?5g640NmhA4RsuMCEn1NvnvOi8zBthDUFZm13q6KkNSXs35Yg6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B7AABZp1Rd/4QNJK1mGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBZ4FFUAOBQiAECyoKhBSDRwOKdoJbfpZlglIDVAkBAQE?=
 =?us-ascii?q?MAQEtAgEBhD8CF4J2IzgTAgQBAQQBAQEEAQYEbYUnDIVKAQEBAQMSEQQNDAE?=
 =?us-ascii?q?BNwELBAIBCBEEAQEDAiYCAgIwFQgIAgQBDQUIGoRrAx0BAp9/AoE4iGBzfzO?=
 =?us-ascii?q?CegEBBYEGAYQBGIIUCYEMKItpF4F/gRFGghc1PoRGgwkygiaPFJw9CQKCHZR?=
 =?us-ascii?q?OgjCLRYpIjVeYAwIEAgQFAg4BAQWBZyGBWHAVgyeCQgwXg0+KHAE2coEpjFM?=
 =?us-ascii?q?BgSABAQ?=
X-IronPort-AV: E=Sophos;i="5.64,387,1559520000"; 
   d="scan'208";a="310622945"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Aug 2019 00:33:21 +0000
Received: from XCH-ALN-019.cisco.com (xch-aln-019.cisco.com [173.36.7.29])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id x7F0XLZl022286
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 15 Aug 2019 00:33:21 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-019.cisco.com
 (173.36.7.29) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 14 Aug
 2019 19:33:21 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 14 Aug
 2019 20:33:19 -0400
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 14 Aug 2019 19:33:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS04w9MmL3PpY7Stn4lYo1NyueKN5SSh9czihdOl8hG51pE6tJB3STdnQVrdALPNILZmJUrX28F+a43/qO3x8HX2t6adSEX4qz9yFQef7qNcaSujRDRyfRaHU/JKORx0oqztOvaz+b0dnw32aeML1yt3LgpX1MzOdyf7KK0hLo7QPPWIR18eS0XqTztFmW1vfaTI+1e4cgyOVrgk8VAqhabcMeYN8ELR+WXu/IHQo6ZR3ZPULDvirT5W6LncehFUgmv5GPG0NyxSEbc8qOu75p2fvuioFqm8jjnUh6q8buGLRVhPv8uUnrkbFEcpVGqj4Jf4HsEuNCYkWrdViWwfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl9cIkLwBOxShxMMfKwe9ivNs/CmuLsMGqJUc1r1RCM=;
 b=jJMk558rEHcFEEM82z6YpERKB+jXjcD0pi+vz9KiY57g4pYPOW3+mc/gG6Ol1e1g4o2BDrBGOn2nN7tt8cvrH7ebfZYpL+I4jjWUVtM4WByhNHOsYA6/WSdUUk/oEaAjn5EZ4t2E5wLwDUb4FLKMoPsKuCwaJGHbVZ5aplXPiWD3j2Mfe9ajmkShXApz9YokXmud9YvTZcUQ9HxNEWONBflH5eDMXz7cYx2VWRHHkINaizDJzcgICdhhVvpcGNbDF+RW7i+T+gHOU4r1aIGR50NirFot2xL92jSdH0CMEhPg8JsebFrMvuRILtRpAl/g+6efcWjZCdbudJMdQgwyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl9cIkLwBOxShxMMfKwe9ivNs/CmuLsMGqJUc1r1RCM=;
 b=sSulQA0nXcTgKaARvhUUNxDuHFe50vNE8KYmx89yncMWciBmCvQa/QBERaC1pzV3LdTl/Mm/BgxgOs24KZwCv8t38kqBPpa90/yOjIvgCIX/6SUi88c+VNnyup3j1wajvQZZxcsZTxHQfxaBqfnpPwMBDr4XQ/ZP5PZrgrGLXfs=
Received: from BYAPR11MB3511.namprd11.prod.outlook.com (20.177.226.94) by
 BYAPR11MB2725.namprd11.prod.outlook.com (52.135.227.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Thu, 15 Aug 2019 00:33:18 +0000
Received: from BYAPR11MB3511.namprd11.prod.outlook.com
 ([fe80::509e:4378:d915:242f]) by BYAPR11MB3511.namprd11.prod.outlook.com
 ([fe80::509e:4378:d915:242f%4]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 00:33:18 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Colin King <colin.king@canonical.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: remove redundant assignment of variable rc
Thread-Topic: [PATCH] scsi: fnic: remove redundant assignment of variable rc
Thread-Index: AQHVUdpqlbeDuk+xq0OvqNpJwpY4e6b7Xhyw
Date:   Thu, 15 Aug 2019 00:33:17 +0000
Message-ID: <BYAPR11MB35115365560883FECD6C88DCC3AC0@BYAPR11MB3511.namprd11.prod.outlook.com>
References: <20190813132349.8720-1-colin.king@canonical.com>
In-Reply-To: <20190813132349.8720-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kartilak@cisco.com; 
x-originating-ip: [128.107.241.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a28913d9-af51-48da-eb0e-08d721182b1f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR11MB2725;
x-ms-traffictypediagnostic: BYAPR11MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB27256B6B0210F3D6FB3CB700C3AC0@BYAPR11MB2725.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(199004)(189003)(13464003)(6436002)(2501003)(14454004)(316002)(6506007)(33656002)(52536014)(229853002)(476003)(186003)(102836004)(3846002)(76176011)(478600001)(53546011)(8936002)(7696005)(486006)(64756008)(6116002)(66066001)(86362001)(11346002)(26005)(446003)(55016002)(8676002)(9686003)(81166006)(256004)(7736002)(54906003)(66446008)(66476007)(66946007)(110136005)(76116006)(66556008)(71190400001)(5660300002)(2906002)(81156014)(53936002)(305945005)(25786009)(74316002)(99286004)(71200400001)(4326008)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2725;H:BYAPR11MB3511.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1IfmJhrfg/ZmHHZqQDCTzYPn2m9kJOia2IzOxIYXIQDnDT1/7Zf13T4XCS7gVNgSZlTMKnVWfRs7Sr3EoOCtUaqNqsQpPVDATyWnAwbydNRQbzxkdA1f8s5k6paR4P0ttsjR1M2NcrfZqqgE/qQkKk8miIl/BNbmJGUzi0nZV1aN4FhQZknwbz2mu/jdhca5t8Y01eRUKqX86nyPODBYm2M1WGMYVO/PC8aho4yy4r8Wxogc+FAgYkSUxkWckObqOTWkGN1C9BB+6nxe6FBpSFy6qfsfR9lueFZENnRpAXiLXPCGNlT4mD2xDMSQiYR21bh4+GOeLvG/Gl7uHNXnpo9u5eacj7wbwUeiabbLkxANVUKIy0TcToSdL9pjSVVvDTaeSrriZtm5Unb+knJjSLA6gjMf5MSN+24wm5RDTTs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a28913d9-af51-48da-eb0e-08d721182b1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 00:33:18.0279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gnqeOOS19Ah4tWVclCtKhV7vFxAmVW/jptvu4AmwgCeXow3uCKYO2KM3yNhcorj+Q73pwv3hBhHh2ay4aX26jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2725
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.29, xch-aln-019.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWNrZWQtYnk6ICAgS2FyYW4gVGlsYWsgS3VtYXIgICA8a2FydGlsYWtAY2lzY28uY29tPg0KDQot
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQ29saW4gS2luZyA8Y29saW4ua2luZ0Bj
YW5vbmljYWwuY29tPiANClNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxMywgMjAxOSA2OjI0IEFNDQpU
bzogU2F0aXNoIEtoYXJhdCAoc2F0aXNoa2gpIDxzYXRpc2hraEBjaXNjby5jb20+OyBTZXNpZGhh
ciBCYWRkZWxhIChzZWJhZGRlbCkgPHNlYmFkZGVsQGNpc2NvLmNvbT47IEthcmFuIFRpbGFrIEt1
bWFyIChrYXJ0aWxhaykgPGthcnRpbGFrQGNpc2NvLmNvbT47IEphbWVzIEUgLiBKIC4gQm90dG9t
bGV5IDxqZWpiQGxpbnV4LmlibS5jb20+OyBNYXJ0aW4gSyAuIFBldGVyc2VuIDxtYXJ0aW4ucGV0
ZXJzZW5Ab3JhY2xlLmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQpDYzoga2VybmVs
LWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K
U3ViamVjdDogW1BBVENIXSBzY3NpOiBmbmljOiByZW1vdmUgcmVkdW5kYW50IGFzc2lnbm1lbnQg
b2YgdmFyaWFibGUgcmMNCg0KRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25p
Y2FsLmNvbT4NCg0KVmFyaWFibGUgcmV0IGlzIGluaXRpYWxpemVkIHRvIGEgdmFsdWUgdGhhdCBp
cyBuZXZlciByZWFkIGFuZCBpdCBpcw0KcmUtYXNzaWduZWQgbGF0ZXIgYW5kIGltbWVkaWF0ZXRs
eSByZXR1cm5zLiBDbGVhbiB1cCB0aGUgY29kZSBieQ0KcmVtb3ZpbmcgcmMgYW5kIGp1c3QgcmV0
dXJuaW5nIDAuDQoNCkFkZHJlc3Nlcy1Db3Zlcml0eTogKCJVbnVzZWQgdmFsdWUiKQ0KU2lnbmVk
LW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCi0tLQ0K
IGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfZGVidWdmcy5jIHwgNCArLS0tDQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL2ZuaWMvZm5pY19kZWJ1Z2ZzLmMgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2RlYnVn
ZnMuYw0KaW5kZXggMjE5OTFjOTlkYjdjLi4xM2Y3ZDg4ZDZlNTcgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3Njc2kvZm5pYy9mbmljX2RlYnVnZnMuYw0KKysrIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5p
Y19kZWJ1Z2ZzLmMNCkBAIC01Miw3ICs1Miw2IEBAIHN0YXRpYyBzdHJ1Y3QgZmNfdHJhY2VfZmxh
Z190eXBlICpmY190cmNfZmxhZzsNCiAgKi8NCiBpbnQgZm5pY19kZWJ1Z2ZzX2luaXQodm9pZCkN
CiB7DQotCWludCByYyA9IC0xOw0KIAlmbmljX3RyYWNlX2RlYnVnZnNfcm9vdCA9IGRlYnVnZnNf
Y3JlYXRlX2RpcigiZm5pYyIsIE5VTEwpOw0KIA0KIAlmbmljX3N0YXRzX2RlYnVnZnNfcm9vdCA9
IGRlYnVnZnNfY3JlYXRlX2Rpcigic3RhdGlzdGljcyIsDQpAQCAtNzAsOCArNjksNyBAQCBpbnQg
Zm5pY19kZWJ1Z2ZzX2luaXQodm9pZCkNCiAJCWZjX3RyY19mbGFnLT5mY19jbGVhciA9IDQ7DQog
CX0NCiANCi0JcmMgPSAwOw0KLQlyZXR1cm4gcmM7DQorCXJldHVybiAwOw0KIH0NCiANCiAvKg0K
LS0gDQoyLjIwLjENCg0K
