Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1FEC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 00:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB26B2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 00:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="JoYyYa97";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="hjwzRdPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgFPA1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 20:27:00 -0400
Received: from alln-iport-7.cisco.com ([173.37.142.94]:16032 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgFPA06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 20:26:58 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2020 20:26:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4180; q=dns/txt; s=iport;
  t=1592267218; x=1593476818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lwkaH1Ib5wR+lNsvF9XBmeK1nWMVfi/I3o1uNUo5lMg=;
  b=JoYyYa97KRGMSWzh7YOXywhLUin+f4oVpqJA5D/6bfL3GxwYSVSfBiUX
   4yXKM3flujQIrl8Fgnp5u77jj5eLNS0Mm5qAE1kOzGaREok+acDo6jW+z
   612HWNk2oh7TI5z9fV7CNOZL/fPImbLVPVD7Lex6xHWgXpO784//dqRhi
   Y=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ajr+MuRLYBHTgqz1UR9mcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeGvKs/j1LTW4jfrfVehLmev6PhXDkG5pCM+DAHfYdXXh?=
 =?us-ascii?q?AIwcMRg0Q7AcGDBEG6SZyibyEzEMlYElMw+Xa9PBtWFdz4almUpWe9vnYeHx?=
 =?us-ascii?q?zlPl9zIeL4UofZk8Ww0bW0/JveKwVFjTawe/V8NhKz+A7QrcIRx4BlL/U8?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BaAADQDuhe/49dJa1mHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgTYHAQELAYFRUQdvWC8sCoQag0YDhFiIQJh3gS6BJANVCwE?=
 =?us-ascii?q?BAQwBAR8OAgQBAYREAheCGAIkNAkOAgMBAQsBAQUBAQECAQYEbYVbDIVzAgE?=
 =?us-ascii?q?DEhERDAEBNwEPAgEIGgImAgICMBUQAgQBDQUigwQBgksDLgEOqlMCgTmIYXa?=
 =?us-ascii?q?BMoMBAQEFhT0Ygg4DBoEOKgGCY4lmGoFBP4EQAScMEIJNPoJcAoFfF4J9M4I?=
 =?us-ascii?q?tjwkKgxCJPphgCoJZiDyQXwMdnmctkGqKCpQjAgQCBAUCDgEBBYFTOYFWcBV?=
 =?us-ascii?q?lAYI+UBcCDY4eDBcUgzqKHQE4dDcCBgEHAQEDCXyPBQGBEAEB?=
X-IronPort-AV: E=Sophos;i="5.73,516,1583193600"; 
   d="scan'208";a="497043222"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 Jun 2020 00:19:51 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 05G0JpTR021067
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 16 Jun 2020 00:19:51 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Jun
 2020 19:19:51 -0500
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Jun
 2020 20:19:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 15 Jun 2020 20:19:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNQNglJECLLMJljcN8KdAgdbcpiY83ZhiuD0/aWvPs6NWjizUyYwipwZRV392tIpicQ51z1dyc43Z+g8vTxK8PIfP4cJBNu09lWUcwHuW4U9j5Uq0ub8is3IXxGQX4HuY/mmTlZKWMAaukIxWpNYtDoQlrA81YNrT1Mb4ZZcDOdFCKjkKCwA5If7+qxyXkpg+FStWUWW1X5JBhYHm7XW4X4hqnHCsh+7NdiS4sunXlq0BNkqos7XLU2mamtU9kwgYpGQuNcW6dLhOy9QEz+Sdhxw03UhFsN/ZKQ5m+2OYNs6SptKL/Y0yF6SiY+9Y21qD+M3s4YAQUJn1W8zG+/z0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwkaH1Ib5wR+lNsvF9XBmeK1nWMVfi/I3o1uNUo5lMg=;
 b=WU0IzfYJ7Saeb91Fcsi9EuzbshP4t51hkVZav4uNbO/Q7yzKgco6WLC2P8Fo7514wvRXYk+KZNttRxtYFKTbDY6MHF4lSzpWflWAQOKXawbKoAUoxjt9sWHCGb0vU3heHArlinLwIrVY1BApMtQsWfzUzUmBr9wLAgwMfv15aFLy8GhIgD9lGUS/kltvVZT3k/KhgeE9qbUQyXSgTf2I3o1eZGHHWszdzCE4okJE0FrZHcYOJPZBGKL9Y54RKKnTYtDKO3rVvuJbCuKdkF2GXHvnkczkXo9Q7fHWMZsbLhbD+Nf1zyFClch7gPUCCYya+DLuV13h8/8wd1zU/UzJ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwkaH1Ib5wR+lNsvF9XBmeK1nWMVfi/I3o1uNUo5lMg=;
 b=hjwzRdPYkx5vmqIXxnWuKCdFX2PvbGVVlNk7nj/ghvWHWKGXlhCTaAXbmwYvwnsBAwYOykbiPyhqVhKC911n4maUv4Q7IvvaJsfSS3xqRR9JDOp1/Y1ztzaX5FAMXrnZwGypMat4NvIRCtWfNhoKSp3TXmv5ApIg8OAFArDJNiQ=
Received: from BYAPR11MB2997.namprd11.prod.outlook.com (2603:10b6:a03:8b::30)
 by BY5PR11MB4481.namprd11.prod.outlook.com (2603:10b6:a03:1bf::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Tue, 16 Jun
 2020 00:19:49 +0000
Received: from BYAPR11MB2997.namprd11.prod.outlook.com
 ([fe80::cdbc:b8c0:b63d:5916]) by BYAPR11MB2997.namprd11.prod.outlook.com
 ([fe80::cdbc:b8c0:b63d:5916%7]) with mapi id 15.20.3088.028; Tue, 16 Jun 2020
 00:19:49 +0000
From:   "Satish Kharat (satishkh)" <satishkh@cisco.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] scsi: fnic: Replace vmalloc() + memset() with
 vzalloc() and use array_size()
Thread-Topic: [PATCH][next] scsi: fnic: Replace vmalloc() + memset() with
 vzalloc() and use array_size()
Thread-Index: AQHWQ2dF7kZeFIzI+0We7qxSnOM95qjZ64eA
Date:   Tue, 16 Jun 2020 00:19:49 +0000
Message-ID: <873653F8-8FBB-4A9B-9380-B476674ECADE@cisco.com>
References: <20200615225428.GA14959@embeddedor>
In-Reply-To: <20200615225428.GA14959@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.10.14.200307
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [24.7.47.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04423b26-5965-4722-1af0-08d8118afb5d
x-ms-traffictypediagnostic: BY5PR11MB4481:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4481092AC60933DCFB4C09E1D79D0@BY5PR11MB4481.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4ACNpeVynkdtMiFQhpAHV/afLvLA5JWS5zTwIAfKX9h1DmOb523DsKV/q/jM+yw1GtCWHU4g5ZbdWOZN3awSeKM2YbGublI6OYmI8et7B3xEGMwCPCwjePwWzCT0qb8FcRCBtvmglZF5LjwUlwKWKKDbX5yh4MFq7wKX0uX8PfZqnF5m2LF77Dz82dq+jfY5fSRWRMG9CEepiFDFX/9Tv2HdaifHUVrVfAk4+mHisZQoJ3RSUrTx4Y5tSoweih0mXpzzNKGVgWd6l9Zn+z+2kPOL98VvNCDh9FeBgO5FzptM9UVIsbpER/4K5sYU9hXYJoM+lp/QU2QFv3eqcXYA8Ef6xdkoyMQOpkH3lWOmsKIImpHnLHuM+xEdM1ljqj/oHijoB/jpGg4bxU59bgmnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(478600001)(186003)(5660300002)(2906002)(6506007)(966005)(53546011)(26005)(86362001)(4326008)(6486002)(316002)(71200400001)(6512007)(110136005)(33656002)(66946007)(64756008)(66476007)(66556008)(8936002)(66446008)(83380400001)(36756003)(54906003)(76116006)(8676002)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 28Cv854kFqaLoUnfbqORb6OLB+qCJxHyHPZ0XYPU6s1QvQoGzWp7Lm54cQICLn1XwVt+861Qu1iAVkHTktpWMYH0qQkfvHCZVCPru9/szDxxcGcqxnuou8VSylZNFpNCeqplRZbvF0FNTaKKs489WaJGwgBy/PuxKbHbsrUuH8XcwT/dGJpgxzJOoUQZN0zsy+Ew+IAP22UpsY1D2XKfzIGe8SNfohmmGWJEgyb0DCMmMsSoagN8pTmONSimSXZvTV8U+y54By5FH73mREGf1gaO6NbZHd8jINeX/QvWrObDy1KE0d4jKyaPABlt4f86sM5rzTDz/JnfJdYJ0GP9fLMT0js5t/M+qvEEqciYqDEoBQ0jFWk0OnV/HkqMwZPks5TOd50rs3+LngSq+smcWreipsAHqhrLz3Yn5xYqmmHpScYtyZFfZbFdJVXtJhwE0JA+uyVciljKLZL5kClHLJmHjC0iiwfmI/e3pCGE8Pc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A33597A2C150E6439AB31FC9F2C04AB1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 04423b26-5965-4722-1af0-08d8118afb5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 00:19:49.1987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 865hhBvgQ8XP5iCugB6dH2OFcAUr+i6MVPbYdhjy2SHhMZSw1BEFDC2QRpmgtG9iOCo5NQmf+rbEma5yZt8Y6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4481
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmV2aWV3ZWQtYnk6IFNhdGlzaCBLaGFyYXQgPHNhdGlzaGtoQGNpc2NvLmNvbT4NCu+7vw0KDQpP
biA2LzE1LzIwLCAzOjQ5IFBNLCAiR3VzdGF2byBBLiBSLiBTaWx2YSIgPGd1c3Rhdm9hcnNAa2Vy
bmVsLm9yZz4gd3JvdGU6DQoNCiAgICBVc2UgdnphbGxvYygpIGluc3RlYWQgb2YgdGhlIHZtYWxs
b2MoKSBhbmQgbWVtc2V0LiBBbHNvLCB1c2UgYXJyYXlfc2l6ZSgpDQogICAgaW5zdGVhZCBvZiB0
aGUgb3Blbi1jb2RlZCB2ZXJzaW9uLg0KICAgIA0KICAgIFRoaXMgaXNzdWUgd2FzIGZvdW5kIHdp
dGggdGhlIGhlbHAgb2YgQ29jY2luZWxsZSBhbmQsIGF1ZGl0ZWQgYW5kIGZpeGVkDQogICAgbWFu
dWFsbHkuDQogICAgDQogICAgQWRkcmVzc2VzLUtTUFAtSUQ6IGh0dHBzOi8vZ2l0aHViLmNvbS9L
U1BQL2xpbnV4L2lzc3Vlcy84Mw0KICAgIFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2ls
dmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL2Zu
aWMvZm5pY190cmFjZS5jIHwgMTYgKysrKy0tLS0tLS0tLS0tLQ0KICAgICAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY190cmFjZS5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5p
Y190cmFjZS5jDQogICAgaW5kZXggOWQ1MmQ4MzE2MWVkLi5iZTI2NmQxNjExYmIgMTAwNjQ0DQog
ICAgLS0tIGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY190cmFjZS5jDQogICAgKysrIGIvZHJpdmVy
cy9zY3NpL2ZuaWMvZm5pY190cmFjZS5jDQogICAgQEAgLTQ4OCw3ICs0ODgsNyBAQCBpbnQgZm5p
Y190cmFjZV9idWZfaW5pdCh2b2lkKQ0KICAgICAJfQ0KICAgICANCiAgICAgCWZuaWNfdHJhY2Vf
ZW50cmllcy5wYWdlX29mZnNldCA9DQogICAgLQkJdm1hbGxvYyhhcnJheV9zaXplKGZuaWNfbWF4
X3RyYWNlX2VudHJpZXMsDQogICAgKwkJdnphbGxvYyhhcnJheV9zaXplKGZuaWNfbWF4X3RyYWNl
X2VudHJpZXMsDQogICAgIAkJCQkgICBzaXplb2YodW5zaWduZWQgbG9uZykpKTsNCiAgICAgCWlm
ICghZm5pY190cmFjZV9lbnRyaWVzLnBhZ2Vfb2Zmc2V0KSB7DQogICAgIAkJcHJpbnRrKEtFUk5f
RVJSIFBGWCAiRmFpbGVkIHRvIGFsbG9jYXRlIG1lbW9yeSBmb3IiDQogICAgQEAgLTUwMCw4ICs1
MDAsNiBAQCBpbnQgZm5pY190cmFjZV9idWZfaW5pdCh2b2lkKQ0KICAgICAJCWVyciA9IC1FTk9N
RU07DQogICAgIAkJZ290byBlcnJfZm5pY190cmFjZV9idWZfaW5pdDsNCiAgICAgCX0NCiAgICAt
CW1lbXNldCgodm9pZCAqKWZuaWNfdHJhY2VfZW50cmllcy5wYWdlX29mZnNldCwgMCwNCiAgICAt
CQkgIChmbmljX21heF90cmFjZV9lbnRyaWVzICogc2l6ZW9mKHVuc2lnbmVkIGxvbmcpKSk7DQog
ICAgIAlmbmljX3RyYWNlX2VudHJpZXMud3JfaWR4ID0gZm5pY190cmFjZV9lbnRyaWVzLnJkX2lk
eCA9IDA7DQogICAgIAlmbmljX2J1Zl9oZWFkID0gZm5pY190cmFjZV9idWZfcDsNCiAgICAgDQog
ICAgQEAgLTU1OSwxMCArNTU3LDEwIEBAIGludCBmbmljX2ZjX3RyYWNlX2luaXQodm9pZCkNCiAg
ICAgCWludCBlcnIgPSAwOw0KICAgICAJaW50IGk7DQogICAgIA0KICAgIC0JZmNfdHJhY2VfbWF4
X2VudHJpZXMgPSAoZm5pY19mY190cmFjZV9tYXhfcGFnZXMgKiBQQUdFX1NJWkUpLw0KICAgICsJ
ZmNfdHJhY2VfbWF4X2VudHJpZXMgPSBhcnJheV9zaXplKGZuaWNfZmNfdHJhY2VfbWF4X3BhZ2Vz
LCBQQUdFX1NJWkUpLw0KICAgICAJCQkJRkNfVFJDX1NJWkVfQllURVM7DQogICAgIAlmbmljX2Zj
X2N0bHJfdHJhY2VfYnVmX3AgPQ0KICAgIC0JCSh1bnNpZ25lZCBsb25nKXZtYWxsb2MoYXJyYXlf
c2l6ZShQQUdFX1NJWkUsDQogICAgKwkJKHVuc2lnbmVkIGxvbmcpdnphbGxvYyhhcnJheV9zaXpl
KFBBR0VfU0laRSwNCiAgICAgCQkJCQkJICBmbmljX2ZjX3RyYWNlX21heF9wYWdlcykpOw0KICAg
ICAJaWYgKCFmbmljX2ZjX2N0bHJfdHJhY2VfYnVmX3ApIHsNCiAgICAgCQlwcl9lcnIoImZuaWM6
IEZhaWxlZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yICINCiAgICBAQCAtNTcxLDEyICs1NjksOSBA
QCBpbnQgZm5pY19mY190cmFjZV9pbml0KHZvaWQpDQogICAgIAkJZ290byBlcnJfZm5pY19mY19j
dGxyX3RyYWNlX2J1Zl9pbml0Ow0KICAgICAJfQ0KICAgICANCiAgICAtCW1lbXNldCgodm9pZCAq
KWZuaWNfZmNfY3Rscl90cmFjZV9idWZfcCwgMCwNCiAgICAtCQkJZm5pY19mY190cmFjZV9tYXhf
cGFnZXMgKiBQQUdFX1NJWkUpOw0KICAgIC0NCiAgICAgCS8qIEFsbG9jYXRlIG1lbW9yeSBmb3Ig
cGFnZSBvZmZzZXQgKi8NCiAgICAgCWZjX3RyYWNlX2VudHJpZXMucGFnZV9vZmZzZXQgPQ0KICAg
IC0JCXZtYWxsb2MoYXJyYXlfc2l6ZShmY190cmFjZV9tYXhfZW50cmllcywNCiAgICArCQl2emFs
bG9jKGFycmF5X3NpemUoZmNfdHJhY2VfbWF4X2VudHJpZXMsDQogICAgIAkJCQkgICBzaXplb2Yo
dW5zaWduZWQgbG9uZykpKTsNCiAgICAgCWlmICghZmNfdHJhY2VfZW50cmllcy5wYWdlX29mZnNl
dCkgew0KICAgICAJCXByX2VycigiZm5pYzpGYWlsZWQgdG8gYWxsb2NhdGUgbWVtb3J5IGZvciBw
YWdlX29mZnNldFxuIik7DQogICAgQEAgLTU4OCw5ICs1ODMsNiBAQCBpbnQgZm5pY19mY190cmFj
ZV9pbml0KHZvaWQpDQogICAgIAkJZXJyID0gLUVOT01FTTsNCiAgICAgCQlnb3RvIGVycl9mbmlj
X2ZjX2N0bHJfdHJhY2VfYnVmX2luaXQ7DQogICAgIAl9DQogICAgLQltZW1zZXQoKHZvaWQgKilm
Y190cmFjZV9lbnRyaWVzLnBhZ2Vfb2Zmc2V0LCAwLA0KICAgIC0JICAgICAgIChmY190cmFjZV9t
YXhfZW50cmllcyAqIHNpemVvZih1bnNpZ25lZCBsb25nKSkpOw0KICAgIC0NCiAgICAgCWZjX3Ry
YWNlX2VudHJpZXMucmRfaWR4ID0gZmNfdHJhY2VfZW50cmllcy53cl9pZHggPSAwOw0KICAgICAJ
ZmNfdHJhY2VfYnVmX2hlYWQgPSBmbmljX2ZjX2N0bHJfdHJhY2VfYnVmX3A7DQogICAgIA0KICAg
IC0tIA0KICAgIDIuMjcuMA0KICAgIA0KICAgIA0KDQo=
