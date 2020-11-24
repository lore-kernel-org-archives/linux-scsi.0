Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E47C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FA720738
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="kGfelkQE";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="SCus26uU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgKXB2E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:28:04 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:2621 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgKXB2D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 20:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2502; q=dns/txt; s=iport;
  t=1606181282; x=1607390882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PvQuF+cfWG5NwHQa5N/iwoBxIzxtHBsCnd0ivgrZd2I=;
  b=kGfelkQEud1SMDxaxSQiLUWmdDFn25vAscw1/qqqt7Fz+gm2cIB0XSPk
   96BXUQ7ckq+dZyXKwLX0oKtb2Qf006Mqh6qDdwmcTvyZaH9hTDdbtIAHi
   wd6gYQy2w20mTwK8yxmupv+A/eCwO6kg/r9ss33N3+8a+rJ36r7SXc/GM
   A=;
X-IPAS-Result: =?us-ascii?q?A0BZBwApX7xffYkNJK1iHQEBAQEJARIBBQUBQIFPgVJRg?=
 =?us-ascii?q?VQvFxcKhDODSQONM5kqglMDVAsBAQENAQEtAgQBAYRKAheCFAIlOBMCAwEBA?=
 =?us-ascii?q?QMCAwEBAQEFAQEBAgEGBBQBAYY8DIVzAgEDEhEEDQwBATcBDwIBCBoCJgICA?=
 =?us-ascii?q?jAVEAIEAQ0FIoMEglYDLgGjXQKBPIhodn8zgwQBAQWFJhiCEAmBDiqCc4N2h?=
 =?us-ascii?q?lcbgUE/gTgMEIJPPoQ+F4MAM4IskzQ9pFkKgm6bHgMfogUtky+gYAIEAgQFA?=
 =?us-ascii?q?g4BAQWBayGBWXAVZQGCPlAXAg2OHwwXg06KWHQ3AgYBCQEBAwl8jDsBgRABA?=
 =?us-ascii?q?Q?=
IronPort-PHdr: =?us-ascii?q?9a23=3AFBz/4hFzTHevubaJ4BiGdZ1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e401QObVoTA4PUCgO3T4OjsWm0FtJCGtn1KMJlBTA?=
 =?us-ascii?q?QMhshemQs8SNWEBkv2IL+PDWQ6Ec1OWUUj8yS9Nk5YS83/fFbV5Ha16G1aFh?=
 =?us-ascii?q?D2LwEgIOPzF8bbhNi20Obn/ZrVbk1IiTOxbKk0Ig+xqFDat9Idhs1pLaNixw?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="635369895"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Nov 2020 01:28:01 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AO1S1dR008080
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 24 Nov 2020 01:28:01 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:28:01 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:28:00 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 20:28:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjZQ6Tr88P1Kh/fnWujwYZC+WkhIbX5tYiN4UX/i7M2zBRe2Q+ItZyZIh7YZpCtHQzGC/VzD5E3d/6W8gRS9XS4B0n8AjRGRvCMiRq2hxjteKi7lIGGcV2sL4FKPdkfk1CU9xn5/OWdPnNizXEvOxs7JSZsCmIFyaDVlLemnK+mY6x0JAPYzKBLrbgUgvMITE0KyjtibwlIynBpe9w+JOj/puyiGg5UWKVfj9F5Fi5V0yU+LAHVYaVdGUeADroVD5Ljtmdsl4S72wHoHkvK+EwYI/QqM7XZ5gK/4rjDQi3k9ZAQkQ9hud79Tiy4BkkXUsiBujXv/fXwnOFVN7+9CTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvQuF+cfWG5NwHQa5N/iwoBxIzxtHBsCnd0ivgrZd2I=;
 b=BzdegFJ/Z4OYp1ZDfsfJeZmhPtWZyGkZB1b2Ch/CLcfNFwTSkdrqpdG4FrYeE9nca1qjXfIMknxuDeQlCqwNL7AUyYR0KXrYAx+IYosG5b4eI1xGNIi+F7FX45QZ6LTLlIKVbz78KvzvYG+dM+kHI6Sn/OcKRRcpeXHOxp/VR8TaRLJssex6hXsiKG4vk4ygS9y9+RbilUwNsUVRl153cIDjst7rVyhu5Urb/w4XVf6sduaUhuR6SXRHbcqzZvlXJP3p02D+P4QQKk/VH91d9Id1jccPTaZYThicoS1FYC9EEm5FpqMLJ0c9YSE+5Y6aWn5ibHoJEo0Rdem/RUu5Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvQuF+cfWG5NwHQa5N/iwoBxIzxtHBsCnd0ivgrZd2I=;
 b=SCus26uUKrkrVq/1BDPVDsmBFfS8bU1eVAJpwT9W3GkcblQ6542BseGrqBitkcNIVcKQvl3NCgdwCLjWFDTiolawgQARTdmJ8T7fabVyz1IyY0qAnH2NSn3sRC9Vql+ZmjTd9zq08/JwWf+5k3hVXRN61iW992eFKSarACckwZQ=
Received: from DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) by
 DM6PR11MB4073.namprd11.prod.outlook.com (2603:10b6:5:19f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Tue, 24 Nov 2020 01:27:58 +0000
Received: from DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2]) by DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 01:27:58 +0000
From:   "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
CC:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fnic: set scsi_set_resid only for underflow
Thread-Topic: [PATCH] scsi: fnic: set scsi_set_resid only for underflow
Thread-Index: AQHWv6jfbHuAWQ1coEenfIE/GKk8manV/KWA
Date:   Tue, 24 Nov 2020 01:27:58 +0000
Message-ID: <72C36CF2-3675-42F0-A87D-7D9A179667EE@cisco.com>
References: <20201121015134.18872-1-kartilak@cisco.com>
In-Reply-To: <20201121015134.18872-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [98.35.85.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7887016-1b34-46dd-c317-08d890182d7b
x-ms-traffictypediagnostic: DM6PR11MB4073:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4073AC75545A52ABED7B5699D5FB0@DM6PR11MB4073.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OrNmiQY+NY9FzgYjhj3y4Jg5awTANw8hkH0Z2K1p19HXH4N292hCgbt8EBXx12thOlWGJJGrsOkPq+Hr5D2aE1XuLs+JhHc199Fk19OvxXdLW2xGLulKQRrCXzgWvX3X5LBygzBDQJRmDERk1T3r3QA8qbaKayH/Hww/tOE0wN/RpXCFEvk/eKTnGNZn+106sJHwWGvpfuJyr9tdFXz4R+qVJ7wTDhkdfm0F4Ncwc0QKdfJMRgD0hv+i8PV3g6Z027vruSbTl5lyBlXhf8GAqvA+/iDKUVR/8RhFSEUZCSRVGYTEibMuQ27PD3Djr3TSNSuVkKpLOXaAVeZOVTcPfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(66946007)(66446008)(66556008)(6506007)(64756008)(66476007)(76116006)(478600001)(36756003)(91956017)(86362001)(71200400001)(6486002)(186003)(26005)(2906002)(8936002)(8676002)(316002)(4326008)(5660300002)(6636002)(2616005)(110136005)(54906003)(33656002)(6512007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9SJo1OxT9atS2piTNzQnJ3Lc19ehfgIOf5kY/CcObXOtnbPpt4c8vj/KyuKohoKMHm10LMr3RKUkTwnPwm5zMftnFruuViBoyLDI6n7OpB9Es4VPqZgMCJd1Y0w3qaLKe3qpXcpY4i/NWRvFEf1n7TJGK8DLK+4HeHGEUY+9dJ17oCjKUZm6WMHi4nbZwrzmuxSfS4NwKwLUZBaOxZGGtBPgh/V2gLPD7kgmuEuTZ4uFUWeu7pgDZ2p4FOyEallHyMKXstg43+6AwN8rnGH2ssbd98w60DKDcVKDY4M4Y9UlGpSe3cjMmIPD9Ogb8Dnm28FJSyZNolmy0W28EmdXL1eTq4qMdWk8iprJi1XXsPFEbULhb3UlsP1olLrJTo56phAPpOlDCuMCoC942RDLn3Go/o/hV52BKAmjSLYbe5EK+qo4XTIP9RU5NQAivbzEzZOKKDOVXMvTYTUSf78DVpygld4ogLKpQaBi/8MC82mV72tyKjJKcYLgOZetiNlhkgoNhDrBPSLl7609U+iodLrn8+5b33zqCJhQCKvBfWKrM3GYdglZyZgP1SMLcl+mOgr6vpJwsbFqTXXbbGDZcd2anlSfdawpvvOSsoGrMR4dZLundb4FT0v+Q+axOdUOBA/+Z7xJfgkqGYl6sYqZCw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D354B7A28A43754397D3818A71E0B634@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7887016-1b34-46dd-c317-08d890182d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 01:27:58.9195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFxI2QDNgAYWzFQnG4ZyiUq9K3K1nf+yW/ARBM80wpbBtBkcRmJnGccfwYS4MFPatNmLW1gCcukMnqFN8O6F0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4073
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZC4NClJldmlld2VkLWJ5OiBBcnVscHJhYmh1IFBvbm51c2FteSA8YXJ1bHBvbm5A
Y2lzY28uY29tPg0KDQrvu79PbiAxMS8yMC8yMCwgNTo1MSBQTSwgIkthcmFuIFRpbGFrIEt1bWFy
IiA8a2FydGlsYWtAY2lzY28uY29tPiB3cm90ZToNCg0KICAgIEZpeCB0byBzZXQgc2NzaV9zZXRf
cmVzaWQoKSBvbmx5IGlmDQogICAgRkNQSU9fSUNNTkRfQ01QTF9SRVNJRF9VTkRFUiBpcyBzZXQu
DQoNCiAgICBTaWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxhayBLdW1hciA8a2FydGlsYWtAY2lzY28u
Y29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IFNhdGlzaCBLaGFyYXQgPHNhdGlzaGtoQGNpc2NvLmNv
bT4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oICAgICAgfCAyICstDQog
ICAgIGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5jIHwgNSArKystLQ0KICAgICAyIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KICAgIGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmggYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgN
CiAgICBpbmRleCA3YzVjOTExYjI2NzMuLmU0ZDM5OWY0MWEwYSAxMDA2NDQNCiAgICAtLS0gYS9k
cml2ZXJzL3Njc2kvZm5pYy9mbmljLmgNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmlj
LmgNCiAgICBAQCAtMzksNyArMzksNyBAQA0KDQogICAgICNkZWZpbmUgRFJWX05BTUUJCSJmbmlj
Ig0KICAgICAjZGVmaW5lIERSVl9ERVNDUklQVElPTgkJIkNpc2NvIEZDb0UgSEJBIERyaXZlciIN
CiAgICAtI2RlZmluZSBEUlZfVkVSU0lPTgkJIjEuNi4wLjUxIg0KICAgICsjZGVmaW5lIERSVl9W
RVJTSU9OCQkiMS42LjAuNTIiDQogICAgICNkZWZpbmUgUEZYCQkJRFJWX05BTUUgIjogIg0KICAg
ICAjZGVmaW5lIERGWCAgICAgICAgICAgICAgICAgICAgIERSVl9OQU1FICIlZDogIg0KDQogICAg
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5jIGIvZHJpdmVycy9zY3Np
L2ZuaWMvZm5pY19zY3NpLmMNCiAgICBpbmRleCAxNmU2NmY1YjgzM2EuLjUzMmMzYzdhZTM3MiAx
MDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KICAgICsrKyBi
L2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5jDQogICAgQEAgLTkyMSwxMCArOTIxLDExIEBA
IHN0YXRpYyB2b2lkIGZuaWNfZmNwaW9faWNtbmRfY21wbF9oYW5kbGVyKHN0cnVjdCBmbmljICpm
bmljLA0KICAgICAJY2FzZSBGQ1BJT19TVUNDRVNTOg0KICAgICAJCXNjLT5yZXN1bHQgPSAoRElE
X09LIDw8IDE2KSB8IGljbW5kX2NtcGwtPnNjc2lfc3RhdHVzOw0KICAgICAJCXhmZXJfbGVuID0g
c2NzaV9idWZmbGVuKHNjKTsNCiAgICAtCQlzY3NpX3NldF9yZXNpZChzYywgaWNtbmRfY21wbC0+
cmVzaWR1YWwpOw0KDQogICAgLQkJaWYgKGljbW5kX2NtcGwtPmZsYWdzICYgRkNQSU9fSUNNTkRf
Q01QTF9SRVNJRF9VTkRFUikNCiAgICArCQlpZiAoaWNtbmRfY21wbC0+ZmxhZ3MgJiBGQ1BJT19J
Q01ORF9DTVBMX1JFU0lEX1VOREVSKSB7DQogICAgIAkJCXhmZXJfbGVuIC09IGljbW5kX2NtcGwt
PnJlc2lkdWFsOw0KICAgICsJCQlzY3NpX3NldF9yZXNpZChzYywgaWNtbmRfY21wbC0+cmVzaWR1
YWwpOw0KICAgICsJCX0NCg0KICAgICAJCWlmIChpY21uZF9jbXBsLT5zY3NpX3N0YXR1cyA9PSBT
QU1fU1RBVF9DSEVDS19DT05ESVRJT04pDQogICAgIAkJCWF0b21pYzY0X2luYygmZm5pY19zdGF0
cy0+bWlzY19zdGF0cy5jaGVja19jb25kaXRpb24pOw0KICAgIC0tIA0KICAgIDIuMjkuMg0KDQoN
Cg==
