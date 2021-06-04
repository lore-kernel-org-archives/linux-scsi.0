Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D02C4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67DA61404
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFDTnD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:43:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229854AbhFDTnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 15:43:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 154JaXXm021531;
        Fri, 4 Jun 2021 12:41:14 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 38yf24adwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 12:41:13 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 154JfDaZ028075;
        Fri, 4 Jun 2021 12:41:13 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 38yf24adwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 12:41:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvBlnf3yr7qK2uaWqopBSDoFqSHAQ3VMrgwMLeLpINY7qtPyDLi/g6FnJa5z01eIsqrCjZeFmG1yT5lHk4uBknuVCCpsOPqZXuEaHDJ9rqZCvfi7VGSXoViE5JVm35bL3d9VpFqlSM+hsYu+ZajcR/6+NrgXIuX03nn/y2nnmg6Lrdy4pKU2qg0Vd6RRcChqEnXFLwfOP/cyxZnpk+soIeC/g2LhobRrzUOKxWrTZSioCKf6H3j7X8NNlyAPxs9JFIlOeefIcb1Ut74VhYq+DNs4mUmQ3dpuGUy+B5VuR0Yl+gXU7iBfufAXilCh9fSsCyQo4Z4rsTTTksFJitdr2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1c81GLBAo6tU26Y2Yo2iVxwWuvo75gkPcKkuamvT4/E=;
 b=JziE3zbcGMkvnffdAFOszQJd+qfTez134ZuKvPgPtxwk7dYPvvDE/WHIbc0Hpm4lQW/bcxS6+q0mloA6N3CGv6ULGbWWVwuEaaQu2ut9TCN7B4esTC3zryfa8RXDA4kpDeMM6fAvAQ28nF+SpLF2hOWhQC3vSFvb0ov23vzv05+wG+s0OgBsQpn9UHAGBJ0zhtDr8eoSSnF3xMSGH6MIzp9FIy2jzhqDyitWKOrP8RpdAeXsIt/Uuqw/Sgf7m4wdCwHIGkWT3zUj0vsJ149QqLgWttr2api6voaFKQAPUC2E1l43LUfi4ewP8BxvjAWFBpPNDnbHMUgkMuHePHioxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1c81GLBAo6tU26Y2Yo2iVxwWuvo75gkPcKkuamvT4/E=;
 b=L2FtTJEEmHvbvGbGd+FcRBEm1FpqccVhbJdEo9bf0qtZVVZlW5k0pBDEmo/g/ngiJIQtdeCWVTC3Ae16i//kCLGgpOzB6yD4PrW4Watzw4gXgZo/tt4LQxY1QgesifiVAZY3xl29Jbq+2Y9L9QmVir8RNiaVvcNLUs+SETYjdrI=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by BYAPR18MB2853.namprd18.prod.outlook.com (2603:10b6:a03:10f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 19:41:10 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 19:41:10 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 03/10] qla2xxx: Add send, receive and accept for
 auth_els
Thread-Topic: [PATCH v2 03/10] qla2xxx: Add send, receive and accept for
 auth_els
Thread-Index: AQHXVeudjt12IMd3WUuwNfCAcSw3fqr/HJYAgAUi0BA=
Date:   Fri, 4 Jun 2021 19:41:09 +0000
Message-ID: <BY5PR18MB334547903D3F44E6057385FFD53B9@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-4-njavali@marvell.com>
 <b0904ae4-22a0-b7b8-2860-7725885135cf@suse.de>
In-Reply-To: <b0904ae4-22a0-b7b8-2860-7725885135cf@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a16d3be2-034b-4fe2-a6da-08d92790b425
x-ms-traffictypediagnostic: BYAPR18MB2853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB28530EE6AD156545A8E58004D53B9@BYAPR18MB2853.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PDflkaWjjmxBjw/qxcsSC7wRYWuCl1Lf0hs2BExNYYaFFaxIW6Qw7TURG0jifiqtYsIGOc4pPFiVAHugdFyLwd2aIJia+8WuerqGmVZEWMgOwXnadnqHu+etaPEnisdti7aP9+J5683pHALcixW8iQD4a6jAfoSvWqjy4W0IgMm1t7wMa4GFQgwY104fguk7AWE6CXyc4XIX3veub06RSlaS3Y6hlCmyiD4sQ5kDUVMcc9+nw/vrggtgZH3CtR9S1EZQ/Z24xIyDzaFfs/L5v2zZTCEnFC8wfhTJ7JfHBluBylQCBSsJDHB8UsRTMFum07byz4Minyh8MiEbG/6Sz8nuphoBLa7IRbdjhCweRtArRFkq2ZupdQIcvkhoJ1R1lHPQJF2Isf9vVya5/XJUnVslLvJh4fWgIL4khtarbWL0oPagntwuAHw1OPJ3pmldoiwcbqlpT5Nds1At2wSsPLQy/oWn6oOb35DkcmU6QRUEP20PTsHwakqVlmPdJsRqb62m8bzm9MKVNDPHdTfRd914hGipmtKt/PmL6Bojtc0T1sGtfBBmuq1682A+DNNoRrQypdMZHKd4MAIf4M/vOqbY9kKallJevHYJdtyk3+s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39830400003)(346002)(376002)(136003)(86362001)(71200400001)(8936002)(122000001)(55016002)(26005)(76116006)(9686003)(38100700002)(7696005)(4326008)(8676002)(64756008)(66446008)(66946007)(83380400001)(66476007)(66556008)(33656002)(107886003)(110136005)(186003)(5660300002)(2906002)(54906003)(52536014)(316002)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M05yaHg4Y0RkTmFZc2hmK2ZzRUx2ZmRLb1ZydmVZNWtPWFlWWis1L2tDdFp4?=
 =?utf-8?B?MWtEdHRkZW5TbVJLOGhxQ2JPL00xb21EUHlsdzNTb1RMZ3dzQmdRclVRL1hF?=
 =?utf-8?B?ZGRramdwS3BaZ3J0VENQb0NySXlITTF1dU5Hd2UxNTJCcFFwN3YxY0FXaDFL?=
 =?utf-8?B?bkJuZzU0SVdkWVI4d2RYQkZEMjJDQnZQYWlpYkYyeUpaOGpmNElIK1piMTMx?=
 =?utf-8?B?QnRTTlpvL2locTYrNk5ndmZlZDllbmh4dXYvenJlK2NQYkhaTTQ5MEFRZUV1?=
 =?utf-8?B?VXA4dlVlNy9WTVZ6YzFESzdFZTFUTTBQRGVVMDlVVmhNc3dySWtpTUtadGps?=
 =?utf-8?B?QitlV1ljdGVJWjVMck83SC8vbEJRbDA4clNiZ1piTENwN0ZlOWJHZW05T1dk?=
 =?utf-8?B?V0xTalFXZGNyT2FRUGhYTEo1QTV2ZmVkVmxtZUdKWXNpU0hxY2hOanp1bE1k?=
 =?utf-8?B?Z0t2d2FiV0N1bWYxL3FGMUZRWHdqL1FFR3N3S3VLMVk0OXhKelAzbDJ4RmV0?=
 =?utf-8?B?ZHBuV0oxTnh6THF1RFJPTVZsVjEyUEZFZ2U1K251OTEySFJZTlRLZDZqM3Jk?=
 =?utf-8?B?Wm5DSEc3UVo4OUUyQ0FNdEJiTk1iQkdad1dYSDVmS3VSQ3FxOUJ0QTQrQTRD?=
 =?utf-8?B?cGJVRFk0Y25xZDBuRjViQVdJUG0yQnVDOGlPWFZzRTM2cUdpQXpwWm1neVpR?=
 =?utf-8?B?bTQ2dDJ6Ly94S1lOdHRoVmlXRE82VWJVTTZQMmJBZ0gwQit5TnJQaGVxMXBL?=
 =?utf-8?B?RkZ6N3FjVWtXZGlDVXl0Slc0cXB4NzdkNVNwQXRYUUlWOVVDbVp2M0pXMnNG?=
 =?utf-8?B?U0N0U0F1bHluL0xLYnZiVkZCQkFibVBWVG9HKzZoUkFvYU95OHdwYkJlY3I5?=
 =?utf-8?B?bVRmdzJaZUoxSTJxWFFma09TbG9ibzJJUG1naUNzSFVSdFV1K2hYTDh2SkxB?=
 =?utf-8?B?c3dLaE4yc0FRUCtTc1lmUHVjYjRXcTVpL3ZIMnZ0QUo5eXdmUWE1eE9BeFc2?=
 =?utf-8?B?bVBzcFNOREZwWUdpVzVRZlFRYnVpVmRjbmJKZFFOQ2lOTk9Na2pMV24vbUJj?=
 =?utf-8?B?ejhFOWMwbTFCdlZBRzk1bjd5ckd0dEdSbkFGR28vUW84ajRLRlNNaXZSSEZK?=
 =?utf-8?B?ZDQ5Q1BoSFhKcDYxa3B2UTlvZkhUOFEyWjF0YUphMjVPK3dtV2I2YWg3VGM5?=
 =?utf-8?B?ZlFYOE9wMDV4RVVOdFg1YURMSEtsM2NRWVRaTXk2WjZiTk4yT1ZoMjdVd1g2?=
 =?utf-8?B?d3lVeXd3RGZTZU4xN2toQzJlSTA5dDJwdElLTnozT2g2VW9qZ1ZsSFRyQ3NO?=
 =?utf-8?B?dVhKdHZEL1ljaFdkODV3MGo2WXFqQzNJWk15bnQxcjZ4R0RJTUtkMXBxeXk3?=
 =?utf-8?B?KzBnbHhCTU1Fb21xbGlRY3kzb2ZZZGN4Z1JoVWlvZG9TNTFYTEo4OG5hK3ZC?=
 =?utf-8?B?U0lQQXIxTDBIa3lvSExTeHViQXJBT2M2c1Zidlpvd2Q4NWtWQ0NFNjFqQzRZ?=
 =?utf-8?B?ekd1Y0RFZlcyTENzODZVK1F0Nkg2SXh4NEJtNnR3SXp6K1pFYXBRcFZyNVky?=
 =?utf-8?B?TGlyNGQwQ0NaVWR4Mm9QM2Vib2YyTzRNWXUrK3NmczZFTjVINHdGbUlhQzZt?=
 =?utf-8?B?RENZWE5lMXoydGl2RUdIVWdwYXBSRzVZb2E3dktnQlFvYjd6Q0FDUVREZDJm?=
 =?utf-8?B?dWpEdjZxc3J1T0JRWWpXVEhMUlBXazh0bDRvbUJBUVB3SFNURnNjTVBqemNT?=
 =?utf-8?Q?V+1JX1YHBJ3k4L8LdwiiDpNcfHpcbpX5FOBa34i?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16d3be2-034b-4fe2-a6da-08d92790b425
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 19:41:09.8237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3pJkt7AyzYzx1hNM3mZ0vFi5/yJao0aoJ5M1w4uKV/tQf8US8Dsaqh4gQkLaOB3AJmLV19/WAelvi2sTt3M1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2853
X-Proofpoint-ORIG-GUID: pVbMRJ-KC4xNl4Kv-neBrmsfrvdngV4D
X-Proofpoint-GUID: 9eE4kXDJc0jIU9W9djKPOu5gobC9ABuq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-04_12:2021-06-04,2021-06-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgaXQgc2hvdWxkbid0LCB3aHkgbm90IGFkZCBhIFdBUk5fT04oIWxpc3RfZW1wdHkoKSkgb3Ig
c29tZXRoaW5nIGhlcmU/DQoNCj4gKw0KPiArCWlmICghbm9kZSkgew0KPiArCQlxbF9kYmcocWxf
ZGJnX2VkaWYsIHZoYSwgMHgwOTEyMiwNCj4gKwkJICAgICIlcyBlcnJvciAtIG5vIHZhbGlkIG5v
ZGUgcGFzc2VkXG4iLCBfX2Z1bmNfXyk7DQo+ICsJCXJldHVybjsNCj4gKwl9DQpRVDogICBub3Rl
ZC4gIFdpbGwgZml4IGluIHYzLg0KDQo+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnZoYS0+
cHVyX2NpbmZvLnB1cl9sb2NrLCBmbGFncyk7DQo+ICsJCXFsYV9lbm9kZV9mcmVlKHZoYSwgbm9k
ZSk7DQo+ICsJCXNwaW5fbG9ja19pcnFzYXZlKCZ2aGEtPnB1cl9jaW5mby5wdXJfbG9jaywgZmxh
Z3MpOw0KDQpUaGUgd2hvbGUgcG9pbnQgb2YgJ2xpc3RfZm9yX2VhY2hfc2FmZSgpJyBpcyB0aGF0
IHlvdSBkb24ndCBuZWVkIHRvIHByb3RlY3QgYWdhaW5zdCBkZWxldGlvbiBvZiB0aGUgZW50cmll
cy4NCkhhdmluZyB0byBkcm9wIHRoZSBsb2NrIGhlcmUgd2lsbCAoc2xpZ2h0bHkpIGRlZmVhdCBp
dCdzIHB1cnBvc2UuDQpBbHNvIHRoZXJlJ3Mgbm90aGluZyBpbiBxbGFfZW5vZGVfZnJlZSgpIHdo
aWNoIHdvdWxkIHJlcXVpcmUgdGhlIGxvY2sgdG8gYmUgZHJvcHBlZC4NClNvIHBsZWFzZSBjb25z
aWRlciBlaXRoZXIgbm90IGRyb3BwaW5nIHRoZSBsb2NrIGhlcmUgb3IgKG1heWJlKSBtb3ZlIHRv
IGltcGxpY2l0IGxpc3QgdW5yb2xsaW5nIGxpa2UNCg0Kd2hpbGUgKG5vZGUgPSBsaXN0X2ZpcnN0
X2VudHJ5KCkpIHsNCiAgbGlzdF9kZWxfaW5pdCgpOw0KICAuLi4NCn0NCg0KPiArCWxpc3RfZm9y
X2VhY2hfc2FmZShwb3MsIHEsICZ2aGEtPnB1cl9jaW5mby5oZWFkKSB7DQo+ICsJCWxpc3Rfbm9k
ZSA9IGxpc3RfZW50cnkocG9zLCBzdHJ1Y3QgZW5vZGUsIGxpc3QpOw0KDQpsaXN0X2Zvcl9lYWNo
X2VudHJ5KCkNCg0KDQpRVDogIE5vdGVkLiBXZSdyZSBzdGlsbCBoYXJkZW4gdGhlIGNvZGUuICBX
aWxsIGNsZWFuIHRoaXMgdXAgYXMgcGFydCBvZiBuZXh0IHBoYXNlLg0KDQo+ICsNCj4gKwkJaWYg
KG5vZGVfcnRuKSB7DQoNCldoeSBpc24ndCB0aGUgcGFydCBvZiB0aGUgJ2Vsc2UnIGJyYW5jaCBh
Ym92ZT8NCg0KUVQ6IHdpbGwgZml4IGl0IGluIHYzLg0KDQo+ICsJLyoNCj4gKwkgKiBxbF9wcmlu
dF9ic2dfc2dsaXN0KHFsX2RiZ191c2VyLCB2aGEsIDB4NzAwOCwNCj4gKwkgKiAgICAgIlNHIGJz
Zy0+cmVxdWVzdCIsICZic2dfam9iLT5yZXF1ZXN0X3BheWxvYWQpOw0KPiArCSAqLw0KDQo/Pz8g
RGVidWcgY29kZT8NClBsZWFzZSBtb3ZlIHRvICdkZXZfZGJnJyBpZiB5b3UgbmVlZCBpdCwgb3Ro
ZXJ3aXNlIGRlbGV0ZSBpdC4NCg0KUVQ6IGFjayB0byB2YXJpb3VzIGRlYnVnIGNvZGUgY29tbWVu
dHMuICB3aWxsIGRlbGV0ZS4NCg0KDQo+ICsjZGVmaW5lCUxTVEFURV9PRkYJMQkvLyBub2RlIG5v
dCBvbiBsaXN0DQo+ICsjZGVmaW5lCUxTVEFURV9PTgkyCS8vIG5vZGUgb24gbGlzdA0KPiArI2Rl
ZmluZQlMU1RBVEVfREVTVAkzCS8vIG5vZGUgZGVzdG95ZWQNCg0KV2h5IGRvIHlvdSBuZWVkIHRo
aXM/DQpJZiB0aGUgbm9kZSBpcyBvbiBhIGxpc3QgaXQncyAnbGlzdF9oZWFkJyBzdHJ1Y3R1cmUg
c2hvdWxkIGJlIHBvaW50aW5nIHRvIGEgbGlzdCwgaWUgaXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRv
IGRvIGEgJ2xpc3RfZW1wdHkoKScgdG8gZ2V0IHRoaXMgaW5mb3JtYXRpb24sIG5vPw0KDQpRVDog
SSBtaXNzIHRoaXMgYXMgcGFydCBvZiBwcnVuaW5nLiANCi0tLS0tDQoNCj4gKwkvLyBubyBuZWVk
IGZvciBlbmRpYW5jZSBjb252ZXJzaW9uLg0KDQpObyBDKysgY29tbWVudHMsIHBsZWFzZS4NCg0K
UVQ6ICBhY2suIFdpbGwgZml4IGluIHYzLg0KDQoNClJlZ2FyZHMsDQpRdWlubiBUcmFuDQoNCg==
