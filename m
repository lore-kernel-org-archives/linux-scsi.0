Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC285C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 18:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB8B60D07
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 18:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbhIXTBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:01:31 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:63476 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343938AbhIXTB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 15:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632509997; x=1664045997;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T8UyphQK+eUkRdBAnM5jyQXN7dro6Pxs16xeQaN9bJg=;
  b=VNhAXkLAicqR4h4wnzTF2+uw4HljnFI1dxyhpd+cJUbZwUWYAq59hlBp
   oPK8fcUXOwERb5LIKXun6OubS5k2Y4xue6wx8PxCRegfSVbito/Et6/Xf
   krbuXsdRaacEr7bct4ot03u+m2N55v7xa+FEwLklOOGSLEEC0IF1w7qQ2
   PnWxmTZFBh6mj2X3kNjtOA6NvIbLICXWAoiKdvPwklt3xJT2SgRRvnJtN
   Kpa+cP6NzYk7LxRPHg0kTg47tMLFIzLHpAkQ1VYo53rJwPrbpQg2Hv+OQ
   FFW7ZCx8MRmz3bpcdAoSixZpKaH7bGElTUNBkywXjCYQ/YmIavDOeDcpy
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,320,1624291200"; 
   d="scan'208";a="181513305"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 25 Sep 2021 02:59:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY0iTSAjhmvOsDIZIjG/ekw6GrniJNWcvAbSG+nayf9vFyw2nMAt2tEeg32e+PGGd5bGnGE1CZISQKB8IcpCBFhh9w5k3eT8bn/LUemfkXmc5Vs9hBnBq0+hL39E9lgabkarqFfwo86LxFR2sQRELtGOkkNeCRCInghpCu83wi4y7xriYWd+lM4EOTKkAO6Y58VCZlrPh4wj+EmIrNbOQ/nRSmTtSq/MURJL6U1riopkH0ye5WrnYk4J0ZlsY3toTYfF5wfWiXiDq+SlpBNvJaPKswAGEGDxJ5f+pHF6L3pwp6mfRJUX2m2RX8gitCo9hpQJGU6X5/XtPRRtQEzJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=T8UyphQK+eUkRdBAnM5jyQXN7dro6Pxs16xeQaN9bJg=;
 b=GXf+zIkcKl/JO+PhO4889nP3yWysHaKVEox+mG45Hd4MEA5IBSQwJZXu6mFZff+/zksmP2MoKz26wnLVTe3f8kEpFhSE3rDJS0Xh9aSSJYp/64wfxl9kyVXF4pe40QzJMTdbcLsAy4s3IWT/bESk+AcdUvWHzXRoAt04/ePhZ4Z6463YKcz/XuxH1Qc4EB67XNZpiXgZliB0m0dobIIg02bLMBN2NE7PfVshps5kGaoQpj51CtTNmb5zvP/yl9o6h12wbWz75TKMRPYxQFUzL8b4O3K8R3vqyYo9E0MDh7XGZKAtC+wsiPG1YsP6b2vjWESCB41e8za1IQT4H+7fWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8UyphQK+eUkRdBAnM5jyQXN7dro6Pxs16xeQaN9bJg=;
 b=RMGzrX85qiEsw5tjKwmALDMWxXvWviRyNxr+tcZElP5mXmbe97viH0qwxUFBNk9eDR5ukIoK/FNZ71YGMaiqxmCnJFAMqyrkxe0Q5kef73NhIKxaTnry50KH/mNiCyJ4NA+gqNsvehwG1FAT6H7E+RR0TKanLR6WFVr1ezblseU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4554.namprd04.prod.outlook.com (2603:10b6:5:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Fri, 24 Sep 2021 18:59:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 18:59:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jdelvare@suse.com" <jdelvare@suse.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
Thread-Topic: [PATCH] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
Thread-Index: AQHXsWPPaj1OrFsc0E2S9tBmub3++KuzaoWAgAAfDKA=
Date:   Fri, 24 Sep 2021 18:59:53 +0000
Message-ID: <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210924164530.1754128-1-anders.roxell@linaro.org>
 <c3bdc145-70e7-b504-0437-f451a3e1c5a8@infradead.org>
In-Reply-To: <c3bdc145-70e7-b504-0437-f451a3e1c5a8@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7920bcaf-1856-48a8-c8b7-08d97f8d7e63
x-ms-traffictypediagnostic: DM6PR04MB4554:
x-microsoft-antispam-prvs: <DM6PR04MB45541453FEB199C25E666477FCA49@DM6PR04MB4554.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/Fr6gj/us2JP6SDSVLVEAa2NRvOuFCKCrCN6HuU1uropU1uZI99K9avyzE11zdiR3mdxbcjfb4yqMkL5xF5oJFLVpg/A1UzsGI0Deewh6IWyW+Io2NX/kcR1ISUTc7I8Q1N5ow38MbK/VaWUhvxxPqHY4pxAJiuhop0o3hwzMGIPQgU7HXGU3bne8INoD/z8G24SK/D8B4QrkHrBdibVS+MOuLGdbulEDl5vOd2unpO4510+ULznKnPTK/cEzNqauuZfeRefAmHe68+JQzBxEwIYgZZ+zUJZRQYRWhkL1Z4FXC7jMvoqrTc6Hvz118zy8qxE7PplMFqyGx9RR/h68QVH+jdXGjASBSV5FEGlj+6YeYbBVympkamPIVDxCRUi7Sd25DmZ0jhYG8EKP5m1KWVr8mkwnqwgSDx3+iaB1jlCgG2MvAlvyKjs5ewA51OeFndex2V+7rc4uP2iBNCXGbESy+GzhxuZ2tO73d5zzPO7/aQLPjPENnDfn0LYgZv2CfvU1+F0kHzLpaCaKeRTd9kbaY1nNDVY3Uibk8zZPqxEzw9EEWlONcJUDWxKYDHpVySvgUp/Etc518AmDl3pBOCSSzJO5ngF4YLcKRX2MGa6pef1FOW+axwrimRP3Nzb3rplh6Bx6lRmbWk3i97s6qgZY4sYvZZei5T+MN8snELsxaQoVaaGjDkf6ZmO7uRCS6YhO+nobms/iukk+TQmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(316002)(8936002)(54906003)(66556008)(55016002)(38070700005)(66946007)(52536014)(2906002)(5660300002)(7696005)(26005)(66446008)(71200400001)(508600001)(64756008)(186003)(66476007)(33656002)(9686003)(110136005)(83380400001)(86362001)(6506007)(76116006)(38100700002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0orUDlycVFVVzdiSFYyV0ZUcjRIdHBhQkVqRkNpNXZkbjVWY1NaQ050NnpQ?=
 =?utf-8?B?VXFnNExPUDdSUEYza1JZd3R4Rzg5V3RVOGJvL0lWSWF0QjlxeTdLL0tLNnZn?=
 =?utf-8?B?QVhNWEJXVEJqK1ZsaVBIc1BxQ05QZDZuTjdiSWZ1L0ZJNlJvMThRSi9ZUHFX?=
 =?utf-8?B?NEZtanlWNWFHa1lSVmpkNElKTldJaVFyVkxuTmNGelpLT3J4T2dYbk1CSTM0?=
 =?utf-8?B?b3FoRml5U1ByRmV5VVYrNDViKzAwZ2FRUXlIQlVJbUg5SzhLMmlWOGxRT3VC?=
 =?utf-8?B?YVNVUUc5cHlUY2RNdlp1VTFCVTJNR1BmM3RhVmxHUk5sVGFTcjFySjhOZlkx?=
 =?utf-8?B?NDROSlBINytzK0crdXl5aE85VGcvSGpTYmdTNklRbUJXYVFGZXVVZXhDUitP?=
 =?utf-8?B?YTU2VGtuUCs2WnJXdmlMcTB2MjBjVFZhRERtam9haUNHa2YwbzBla1BsbWps?=
 =?utf-8?B?amEzdHFidnNTUVFaQnpPb0x2MnBKeVF1Y2pTQUdqbE9ZUWRTc2UySHB6Uzln?=
 =?utf-8?B?Zit4ZXZqdVkwRGhnT285V1NSM3ZwT28remRmUEdPTXpqOFAxOUtWUWl1RndZ?=
 =?utf-8?B?MTh3Y2lqdVNKQ29iTDdUYUF2TUJZRENNb3lKc0hmRDI1MXpsRFYwZVpiNXpk?=
 =?utf-8?B?L3pzRmNqSHZmL1FPTnN4dHREY29oZVNSZW1xKzI1eSsrL2JwQzBQTEFUR21Y?=
 =?utf-8?B?cDFxekRjaUEza0VvTVJIQlpTOVMrd2F0bjFQWUErQVFOZG16dUlGSm1BaDhE?=
 =?utf-8?B?Z0p0N053ZzdFUE9jbTMvTVQ1UTB4Q0JxKytBbHViTlp6MUkxQXRhLzZ0MzVV?=
 =?utf-8?B?NjU3RDQ4cHN2c3hQZW1OYThtVTUvVXNsNEVOTlJtdlQxL3E0R1g0a1gxUEtJ?=
 =?utf-8?B?bUVCZEF0bk1TaHlsSUNQanM2ZkhjcXVyWTRqeFBOYUdjNUQrbmFMWmdFV2VF?=
 =?utf-8?B?eWdVaXNlY1BZN1BoK1IzZThyTjJqQWw0d1ZBSEp0YzF4ZnlhTW1QVmdTZktC?=
 =?utf-8?B?WEwzZWFRcWZCMFBQSE13eUUyRG5MTjU0RUFFTXFwTVA3TDVzUnRCSGtndWJz?=
 =?utf-8?B?TjZSaUk0eE1FZTU1R1JnYW5IN0d5OXNxUVlSY3RtTDRuUkphWXhnNU5ma2Ur?=
 =?utf-8?B?VTNJQndDK2JBbVFSbllYTHc2M1hERmhuWVB0NWJNZWN2TzZieVg5cHRiY0U3?=
 =?utf-8?B?b3dzK0NtUEpOUzNkdWo1UzVQaFdOUi96ZkdxRjNUZS9MN0c5aXZmS2s5Ylkx?=
 =?utf-8?B?SWdLK2ZxYS84U2JnSXdyT0NsRnhURENhdGFoYmdrUVZyaUFVQlpOL1F0azdq?=
 =?utf-8?B?dUN2VS9WUVRIZ2ErYkloQ3RydjVUTnl0aEt2QWZFcXhpRFVJcmkrTm4rc2Ra?=
 =?utf-8?B?VTBqNEpjRmVBdlVzQnFEYlhYUjVGcWpzejhMR0V4YjNjOUVJT2ZPODRIR2xH?=
 =?utf-8?B?QXpVaklBY2pFd0xLWmhuTGgrL05XV1dJaXY5Y1BoTXJ0N2xsRkNnODR1YmFs?=
 =?utf-8?B?emhmbytLbytvQml5OXNkQ01tTDdkTmNoYUdTcisyL3NOb2R1cmZIb3EzZEZZ?=
 =?utf-8?B?elRGU1ZINDVqUU9NRzUxUWZ2dEtjNnJtaDVuY0RNUXlzaG94TDVTVE9rdkJi?=
 =?utf-8?B?cWRRS0JTYm1JdjJmU0I2R2FwR3ZsTmxNamQzU3FEU2ZuR1NIYmdMSW1KdUpT?=
 =?utf-8?B?aVp5SU0xYk5rTkZHQlg4Tno1TXFya0EvYVcxc3RMcm8wUFhTNk1mRmlPSkNz?=
 =?utf-8?Q?UfH0eVIdAwBEsUWRvvW/ryUb11oxeAcoDk5XCZr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7920bcaf-1856-48a8-c8b7-08d97f8d7e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 18:59:53.6304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hdVpvEbw9oIDB0DiPy4BIvs6JjpGvX7BNh5iz9EjcGamoRTTTPu768pKIoyQwe20JDdGLEcRSHXo098iXRBRwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4554
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IFNpbmNlIGZyYWdtZW50ICdTQ1NJX1VGU19IV01PTicgY2FuJ3QgYmUgYnVpbGQgYXMgYSBt
b2R1bGUsDQo+ID4gJ1NDU0lfVUZTX0hXTU9OJyBoYXMgdG8gZGVwZW5kIG9uICdIV01PTj15Jy4N
Cj4gPg0KPiA+IEZpeGVzOiBlODhlMmQzMjIwMGEgKCJzY3NpOiB1ZnM6IGNvcmU6IFByb2JlIGZv
ciB0ZW1wZXJhdHVyZQ0KPiA+IG5vdGlmaWNhdGlvbiBzdXBwb3J0IikNCj4gPiBTaWduZWQtb2Zm
LWJ5OiBBbmRlcnMgUm94ZWxsIDxhbmRlcnMucm94ZWxsQGxpbmFyby5vcmc+DQo+ID4gLS0tDQo+
ID4gICBkcml2ZXJzL3Njc2kvdWZzL0tjb25maWcgfCAyICstDQo+ID4gICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvdWZzL0tjb25maWcgYi9kcml2ZXJzL3Njc2kvdWZzL0tjb25maWcgaW5kZXgN
Cj4gPiA1NjVlOGFhNjMxOWQuLjMwYzZlZGI1M2JlOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L3Njc2kvdWZzL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL0tjb25maWcNCj4g
PiBAQCAtMjAyLDcgKzIwMiw3IEBAIGNvbmZpZyBTQ1NJX1VGU19GQVVMVF9JTkpFQ1RJT04NCj4g
Pg0KPiA+ICAgY29uZmlnIFNDU0lfVUZTX0hXTU9ODQo+ID4gICAgICAgYm9vbCAiVUZTICBUZW1w
ZXJhdHVyZSBOb3RpZmljYXRpb24iDQo+ID4gLSAgICAgZGVwZW5kcyBvbiBTQ1NJX1VGU0hDRCAm
JiBIV01PTg0KPiA+ICsgICAgIGRlcGVuZHMgb24gU0NTSV9VRlNIQ0QgJiYgSFdNT049eQ0KPiA+
ICAgICAgIGhlbHANCj4gPiAgICAgICAgIFRoaXMgcHJvdmlkZXMgc3VwcG9ydCBmb3IgVUZTIGhh
cmR3YXJlIG1vbml0b3JpbmcuIElmIGVuYWJsZWQsDQo+ID4gICAgICAgICBhIGhhcmR3YXJlIG1v
bml0b3JpbmcgZGV2aWNlIHdpbGwgYmUgY3JlYXRlZCBmb3IgdGhlIFVGUyBkZXZpY2UuDQo+ID4N
Cj4gDQo+IEFsc28tUmVwb3J0ZWQtYnk6IFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZyYWRlYWQu
b3JnPg0KPiBBY2tlZC1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+ICMg
YnVpbGQtdGVzdGVkDQpBY2tlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQoNClRoYW5rcyBmb3IgZml4aW5nIHRoaXMuDQpBdnJpDQoNCj4gDQo+IFRoYW5rcy4NCj4gDQo+
IC0tDQo+IH5SYW5keQ0K
