Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6A5C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6107520729
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="dHrci5lB";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="nD3yBg6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgKXBce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:32:34 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:45098 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgKXBcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 20:32:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2562; q=dns/txt; s=iport;
  t=1606181552; x=1607391152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=utls0k9+Vz36eeMYKxYx6faF1Yh8BAQrdGGUWXkWxSE=;
  b=dHrci5lB+UBLZcfQ9f1SMAzk6MvihyWuYoiMy5wuFH9bf+qe8Cgk+tkg
   NvgdWgM3K13F5D/d8RlQyW3CXOpb98CUhJPm4NTjB1T1hZnPW77+GFPZe
   Hkilsq5lTdNT8T10ffIWc2Pfoz9bApcJSG98UK8F4bp7xx9mBVoIBq2Q8
   g=;
X-IPAS-Result: =?us-ascii?q?A0BYBwB9YbxffZtdJa1iHQEBAQEJARIBBQUBQIFPgVJRg?=
 =?us-ascii?q?VQvFxcKhDODSQOmXYJTA1QLAQEBDQEBLQIEAQGESgIXghQCJTgTAgMBAQEDA?=
 =?us-ascii?q?gMBAQEBBQEBAQIBBgQUAQGGPAyFcwIBAxIRBA0MAQE3AQ8CAQgaAiYCAgIwF?=
 =?us-ascii?q?RACBAENBSKDBIJWAy4Bo1YCgTyIaHZ/M4MEAQEFhRsYghAJgQ4qgnODdoZXG?=
 =?us-ascii?q?4FBP4E4HIJPPoRVgwAzgiyTND2kWQqCbpseAx+iBS2TL6BgAgQCBAUCDgEBB?=
 =?us-ascii?q?YFrIYFZcBVlAYI+UBcCDY4fDBeDTopYdDcCBgEJAQEDCXyLCC2BBgGBEAEB?=
IronPort-PHdr: =?us-ascii?q?9a23=3AkdXH5BDhnJ25gK4wY3JTUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qw00A3CXJ7Q7LRPjO+F+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGE8flbFqUqXq3vnYeHx?=
 =?us-ascii?q?zlPl9zIeL4UofZk8Ww0bW0/JveKwVFjTawe/V8NhKz+A7QrcIRx4BlL/U8?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="620324020"
Received: from rcdn-core-4.cisco.com ([173.37.93.155])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Nov 2020 01:32:32 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AO1WVYR005667
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 24 Nov 2020 01:32:32 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:32:31 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:32:31 -0600
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 20:32:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVr8dk2yVgImIWEHQNImJFYeIS63tO0gVZJyZyYl6vr9zfg+SgBlF28IMyXJmiCiA+Q289owK2EzHUFdN2kMciiaN4g3HSzxfpxpgJggasqJAh3G2Bav8eDoAcKYbONQTRVW6SNj8nlMcwycW3ZMbx6Mhyud34vCmedHek6vzdyaw540Pf2Y5e31eER5OdATD8ObyjZ70NPPOylRFbeWgLeKXLdq/QMFe5FNZ9Eq59MC0RbeE3/GIyzRTd+MRe/4SRDkrhJ6KscBu8AmEQkZrUyms73XobtiWrIBKLsYnH6iLP8tNb4guN2rbtdo35nhjJYV1w7YrDt3RYCpYOjg1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utls0k9+Vz36eeMYKxYx6faF1Yh8BAQrdGGUWXkWxSE=;
 b=j1B2gVabuJvKLR+4hfr/m6so/KlDWGLoZNlafCkfUKie/D5JUy5RrcEb/ZWA7bwz7fmihOwnHeX4QnFvPkDVZeipslfmjTGc4v1l0r3g+UDtlzSskcQUpPNswVihOMk1W84DkyPCig5Cx17TRfzjG8eTMprL8VrfniIMaruDRm4eGVif8EdqLompUng2e0UMJehfT6s5MaWWCpxQVsdux9Ln0Asa4EzRejpzFw4dM83WZ9jsHWof62jUDHZiKd2JGzIuwuotMw/wjFguO+bryQZHVKLd/pRQrjagAkC9A7WISZ1ATQLzToFWPg0bI6vAU8HrAZVRnaRV6aPl2ezzrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utls0k9+Vz36eeMYKxYx6faF1Yh8BAQrdGGUWXkWxSE=;
 b=nD3yBg6lOQYLmzIi6j9RtU2YBH+43Xo0Xf7MyvoZ+RQcw4oG98mbrYJQsytFhyoYoN6H/qddgswjIJswEOitHOq5KVrxsnudUUZKgHQLFVsXYm7ZrMxK1/wpefpg0YPGwR/WDX0hLGrBftqQwfcUKaHYHPIhIGzi24ZVz142u2k=
Received: from DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) by
 DM5PR11MB1306.namprd11.prod.outlook.com (2603:10b6:3:b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.25; Tue, 24 Nov 2020 01:32:30 +0000
Received: from DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2]) by DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 01:32:30 +0000
From:   "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
CC:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fnic: Validate io_req before others
Thread-Topic: [PATCH] scsi: fnic: Validate io_req before others
Thread-Index: AQHWv67Efts6P6eCL0GQEVWfwcNlIKnV/d6A
Date:   Tue, 24 Nov 2020 01:32:30 +0000
Message-ID: <0C569CCE-A202-4C01-B112-92080126BA87@cisco.com>
References: <20201121023337.19295-1-kartilak@cisco.com>
In-Reply-To: <20201121023337.19295-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [98.35.85.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00ed4b73-36ab-4558-5dbd-08d89018cf69
x-ms-traffictypediagnostic: DM5PR11MB1306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1306D74272C0F9CDA9293031D5FB0@DM5PR11MB1306.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FTh668iZP6H6GtzfQ69sC8bcazgMgdA2XSE9RBkTTDlOLmmQH18TQ4eWz25D9LJT0yyuF3BgoirZX62kguZBaA5uyab1gj0TSJgPUUEMJl8YuAnrrVu7IusN1vpgJpvomTKTuOF62DNGs/TvC6wOUqRc60dwhwPe+UpEX3ESakxxr3sjZwd6ZEQDAPkAUChTnNqLoGqw5G0Pzoz4UyiZ8uZY0aAgjqw56HrxDS5SBMzPUgzAXwlRD3tS/Kn0F5pIjuFTmx2VjhY19C5dYI5cFMdDt7GBWw3t5SY1iMDGWwOq74u9QXvXCjlm2K8CcFt6FG8SldaVAXsZO2gT0hb7Rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(186003)(6512007)(66446008)(83380400001)(2906002)(64756008)(8676002)(2616005)(6636002)(478600001)(26005)(110136005)(66556008)(66946007)(76116006)(66476007)(91956017)(316002)(54906003)(36756003)(6486002)(8936002)(6506007)(71200400001)(5660300002)(4326008)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: k2MP/hzSW4QMgS+PYATspDoNdlS+oEuSBz2xy3VH+nxIYJp6Eh1FqLVPtr2Tqabqyye4pA5EPvjFM02gqCGjAxXpE8Ff5H3tltEQRY1CRx7YmpmB41d5zLyjnbFButja0Yi3UINOxKgahAcu/bstUxEwWztyeXXLcmsnhnlZNOKVlTRf+/KbxV8Pzaimr46B7qKL55jvNSYtn/DWDytFSywvyfWwnAB9FE8Bcqxv+0wi3wsjxyyfaaiO61HY+hrR8/Px0VMx8+XboJkyPC6PmImKoUlVS+Q99cjQG+DG1YdHrwC3olC+M0Cwu0NEd2dG/nRdPorjwrsXDj3GC0tmso8Or3RkrGs98TvFdo822KpF+RtVCO4Z9s7rB4M1R12xm2Qo26CXTfoi7sSZOGI7Pvm4DojyieLMiJHw4ysTU9sLkPepuMrXx7XXHTnZkWKlFWT50qAO2XRsR+Fkg3lbXe2zY0sGaMBQiLEZ2eH2YdkqCZcODn98LF0NbkJPXOQLCXYL/KIFN+6y0ePQ69m0sRpNdq62ncUwYx54ty1X9gUxyWaHeCDre1TbQM0RzWmHfzq9R6H8xc0m1VAcwzNW8A6a/IpYLFOGnuf7VglwIav2uQJ4l926XmvtGJH3xbdfwGTD+Pwi497EWpkDSW1oFA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D87AF9AF190CC340B3D902DD15F2EF85@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ed4b73-36ab-4558-5dbd-08d89018cf69
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 01:32:30.5339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HR9f66nkd68pyPY2Imjh6GzWGQDn27Cf19aFKKC3KXJwuFnaf/zN6H7sq4FFoy4uH4i5i9qf23/rrmGFW71H+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1306
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-4.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZC4NClJldmlld2VkLWJ5OiBBcnVscHJhYmh1IFBvbm51c2FteSA8YXJ1bHBvbm5A
Y2lzY28uY29tPg0KDQrvu79PbiAxMS8yMC8yMCwgNjozMyBQTSwgIkthcmFuIFRpbGFrIEt1bWFy
IiA8a2FydGlsYWtAY2lzY28uY29tPiB3cm90ZToNCg0KICAgIFdlIG5lZWQgdG8gY2hlY2sgZm9y
IGEgdmFsaWQgaW9fcmVxIGJlZm9yZQ0KICAgIHdlIGNoZWNrIG90aGVyIGRhdGEuIEFsc28sIHJl
bW92aW5nDQogICAgcmVkdW5kYW50IGNoZWNrcy4NCg0KICAgIFNpZ25lZC1vZmYtYnk6IEthcmFu
IFRpbGFrIEt1bWFyIDxrYXJ0aWxha0BjaXNjby5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogU2F0
aXNoIEtoYXJhdCA8c2F0aXNoa2hAY2lzY28uY29tPg0KICAgIC0tLQ0KICAgICBkcml2ZXJzL3Nj
c2kvZm5pYy9mbmljLmggICAgICB8IDIgKy0NCiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19z
Y3NpLmMgfCA5ICsrKystLS0tLQ0KICAgICAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkNCg0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9m
bmljLmggYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgNCiAgICBpbmRleCBlNGQzOTlmNDFhMGEu
LjY5ZjM3M2I1MzEzMiAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgN
CiAgICArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgNCiAgICBAQCAtMzksNyArMzksNyBA
QA0KDQogICAgICNkZWZpbmUgRFJWX05BTUUJCSJmbmljIg0KICAgICAjZGVmaW5lIERSVl9ERVND
UklQVElPTgkJIkNpc2NvIEZDb0UgSEJBIERyaXZlciINCiAgICAtI2RlZmluZSBEUlZfVkVSU0lP
TgkJIjEuNi4wLjUyIg0KICAgICsjZGVmaW5lIERSVl9WRVJTSU9OCQkiMS42LjAuNTMiDQogICAg
ICNkZWZpbmUgUEZYCQkJRFJWX05BTUUgIjogIg0KICAgICAjZGVmaW5lIERGWCAgICAgICAgICAg
ICAgICAgICAgIERSVl9OQU1FICIlZDogIg0KDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9mbmljL2ZuaWNfc2NzaS5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmMNCiAgICBp
bmRleCA1MzJjM2M3YWUzNzIuLjM2NzQ0OTY4Mzc4ZiAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJz
L3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNf
c2NzaS5jDQogICAgQEAgLTE3MzUsMTUgKzE3MzUsMTQgQEAgdm9pZCBmbmljX3Rlcm1pbmF0ZV9y
cG9ydF9pbyhzdHJ1Y3QgZmNfcnBvcnQgKnJwb3J0KQ0KICAgICAJCQljb250aW51ZTsNCiAgICAg
CQl9DQoNCiAgICAtCQljbWRfcnBvcnQgPSBzdGFyZ2V0X3RvX3Jwb3J0KHNjc2lfdGFyZ2V0KHNj
LT5kZXZpY2UpKTsNCiAgICAtCQlpZiAocnBvcnQgIT0gY21kX3Jwb3J0KSB7DQogICAgKwkJaW9f
cmVxID0gKHN0cnVjdCBmbmljX2lvX3JlcSAqKUNNRF9TUChzYyk7DQogICAgKwkJaWYgKCFpb19y
ZXEpIHsNCiAgICAgCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpb19sb2NrLCBmbGFncyk7DQog
ICAgIAkJCWNvbnRpbnVlOw0KICAgICAJCX0NCg0KICAgIC0JCWlvX3JlcSA9IChzdHJ1Y3QgZm5p
Y19pb19yZXEgKilDTURfU1Aoc2MpOw0KICAgIC0NCiAgICAtCQlpZiAoIWlvX3JlcSB8fCBycG9y
dCAhPSBjbWRfcnBvcnQpIHsNCiAgICArCQljbWRfcnBvcnQgPSBzdGFyZ2V0X3RvX3Jwb3J0KHNj
c2lfdGFyZ2V0KHNjLT5kZXZpY2UpKTsNCiAgICArCQlpZiAocnBvcnQgIT0gY21kX3Jwb3J0KSB7
DQogICAgIAkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaW9fbG9jaywgZmxhZ3MpOw0KICAgICAJ
CQljb250aW51ZTsNCiAgICAgCQl9DQogICAgLS0gDQogICAgMi4yOS4yDQoNCg0K
