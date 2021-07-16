Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A45C12002
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 12:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D59613D3
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 12:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbhGPMmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 08:42:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:42181 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbhGPMme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 08:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626439180; x=1657975180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2vRd5Do2aeG4qUUPXtkQzwTYE7zY9l2oqn2e971c4V4=;
  b=Bc0BaBR1bF/9NnLevQl9aaTMpnusZoOPE3qWsu6+R6gRwpKXXC019EzU
   GjbYLMOU/hcPkgTxwQ+HC83J1JE2JAJ4IQMewW6lkJPxbGk+c71NQ3srE
   FCoInzaXBa1z8L6uZmhssrZnxG0Q1+YZZYnRMMWtvhDF1oPeIVEiYkQSS
   j5ys6acwF/ImvYpJIB6CJ8bHDDkes0fyzCdwyij230rbwYi1gqG+dGiai
   z6OITwKQKxhzFc2oDIoXcz0C8WFx9KI0i1lg55Mf509DuXFCc6PXV1D9Z
   Ja/bxBE7vAIhNiFCiDnnaJJ96I1cr0Qm2CaXCPsZ71xY9vK/uXGNmF48j
   g==;
X-IronPort-AV: E=Sophos;i="5.84,244,1620662400"; 
   d="scan'208";a="174003967"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2021 20:39:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbkBWT+TdMVhrS3zHFa7i3W2FX4L2yNfk3Gv6T34NkeA7HUVA9hpJoL0ADQyh2WNKOxfPHsv2OJqSLz9VE88bFIqUcarj3dgwXe6ltQDWvoKL/mTghW06s4Gl6XP5q+3wX3H/3K9HVlqClnfu2WzJff13JmlL6O5IT0J20QfRtYfgtFaTxKUBitF31dUsJACTxURWQsRfjn7can0oCKLRHAChrJ9eIBVDLi+PS8ZebDzN6SL8dtFIDZDxWVCLr4zladaw+RbJwn5SAZGpUMqR0UhBtd4lduqj9uchrDdqodc6b5NrAZLUd8u8B02FP7mgXCyvbPp7zfzI/oCvKnd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vRd5Do2aeG4qUUPXtkQzwTYE7zY9l2oqn2e971c4V4=;
 b=P6ePIEUl7FMyHKGxvTh6dey4wmUJbmHrSq1cOC2Fa2CsPM7WQ6WthebQkFcjU833Agjrno68d4eiTo310ZxXEDLp/c3cLUx7WyBFOrfu6tb34s6v1xq3VgB1TsYq/erNTzhDDVxXwJ4gIDkFIULoeFmUyPbx/FaE8V+zjLR43PWUb0403FA0c9b7EACdJKsuACANR1Wxmji2mhwViF/5OjxvM4j+ldLLVdl+D2gCjawG1hPr9bedlPXhI2o+zEGgibJK5nT53+X0SEwRc4b7egKa2SUKbYxEELWafO4dgyV5qxgUk/HgRS6GdnkY2nYpokBJyQIAMvmLyDwwsH/cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vRd5Do2aeG4qUUPXtkQzwTYE7zY9l2oqn2e971c4V4=;
 b=RFfsdjhKKwBuECqoKLWymXriEpkfL1GQsqyGfyZ3+8gJeuX0ojURPrk5UZPXXWU/XQtHQm2y5N+tV3j2u0p9BTT3/sBjyIN+CwWjd0AroWcaBpDcDitGqAC8pwOft7nhp3Tbh4OJy0bsuw5reY0kB7GfaCqPs/kAZr0UJeMGyyc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6137.namprd04.prod.outlook.com (2603:10b6:5:121::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.26; Fri, 16 Jul 2021 12:39:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 12:39:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Topic: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Index: AQHXdQDgAGtkX44t6kOse8My4O1WHqs9tRkwgANu7QCAAG8ZAIAEAIvg
Date:   Fri, 16 Jul 2021 12:39:37 +0000
Message-ID: <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
 <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
In-Reply-To: <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5c16b88-9424-4fc4-c8b5-08d94856c5c2
x-ms-traffictypediagnostic: DM6PR04MB6137:
x-microsoft-antispam-prvs: <DM6PR04MB6137624A80CE94E313C184A5FC119@DM6PR04MB6137.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SSzUFo4niCHicikM0O2UwisPaU4OjFcnv7VRwuOsaAqLAQEQT5Wdrk7sXymQMK3PzNFFfxsLC7rhymksyUG7z6FgPOIK9g+mgfjeTAE3wc19/D/vROpwIzUgKGVZ/fTLYV+MjYMRKGDsU/6GmmSuSD+QahoIQZY7OSeUqN1+c1eYco6pT+TnlmVO+4d6vDjI1lV8/RAs7GkV4cRLS6ctSmjOybpQfM+tGldNZSE2ekxlWyb2p+bpUHQVkooCFsUR7/dRY/5HkSf3ClMKZILA9+iM9R5drmiXfoydzpQbGGWy2pIEjOk0YVcC31BszU91MEGYt23n5UkdRf0QEFHVk6ztvsLm8x2xj/c2WsUPrPJkjUAJTH5mei/Swf85tSvmhEIG8rrDQRrM4ka0UO4EourWgWttWpFGSEAbdK8kMLOF4V1cPfghB5LZaMrHa5vmzvCFwhk5+Diwd1zov3U49lLWf6ueRDpqPA/LHYkHrNkVw32Oj87c0VsZ/KemnYddpRwZm6vjVSn/1nsqb/b7x89RU+y1rh1NYx3b/JsiOemNkRy/zApg6IDZ6I/sq5D6kP2PDHudY6XZ6GQK+dh/pJVPrAYD7acHrRN5652YXUeSDwa9anAAWUzlviw0bRpnuxzwSL8l/KXtc1j43Ww4LFcAmDMh9Fvcj+0hZxvOTGrGsclG+Di+/XVEL14kjBYPEt02Z2QG7kpWqF6iwX+C1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(7416002)(54906003)(110136005)(478600001)(5660300002)(8936002)(8676002)(4326008)(66556008)(64756008)(66476007)(316002)(86362001)(9686003)(66946007)(33656002)(55016002)(66446008)(76116006)(26005)(52536014)(6506007)(53546011)(7696005)(2906002)(71200400001)(186003)(122000001)(83380400001)(38100700002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0hyUFcrS3h5RTJIbnBXQ215SGdHZTJOSFRMdElId01JbGdQSFg1OWFvR2Mz?=
 =?utf-8?B?aEFZZ3VaNHZqdEdJR2tzWXRUek1sQitTbk4rTzJiekduREsrd0N4TjUzQnpr?=
 =?utf-8?B?V29sNzU0U2t4eXpQdHBNcDFlTGRLazJaT0ZLdHZQV3RGMFQxaE42ekt5Z2xG?=
 =?utf-8?B?MHd0Ynp4SXY1MUpJbGhFOTVpZm1ZTjcydkE0VER1c3FSTXFXZFFWOUdob1dh?=
 =?utf-8?B?OHFPZXl3ZWNaZ1AzZzJmY1gxbXpPd09JTE9xUkw0aGpJTEpwblBBWlVUZWtS?=
 =?utf-8?B?MnU5THdzenFsa2swTHVENm5GMWZSQlZZYnAwYWVWUlRIRlJWMXBaWVNBTDdK?=
 =?utf-8?B?a1NpTElYZVo5VlBrUGlNVEdlbzZ0VmVoN0FjOE1sZko1aTVGc3oxemUwZDBp?=
 =?utf-8?B?b3Q1UEczMy9MNHZUckYxMHFqWmNMZlpzM1NmN3k0SVZ3WC83TUZCTDdmUDk2?=
 =?utf-8?B?czVjMlAwTVovaWlMK3V3ZFkvZG9Ba3JDMW50cG16aitkVTdKUUo3T0FlWDE0?=
 =?utf-8?B?YmgvdDd6cTUwQlIzWkhqcld6OXZKdDd2d1RMWHZQeU1ZbnMyUDJIWG82alBL?=
 =?utf-8?B?S0xUOEU5emw3UHRvMW81a0lNekg5dE11UVlFdGlZT2xaM3I0L2J3UEhhYytu?=
 =?utf-8?B?TlhDdXk1MGg4dm93N1p5Z3AzZEhtcWtCMEc3RVQzRW9NZWhVRWhqR1NOSVJC?=
 =?utf-8?B?UHNDdGpCMlFhTkxHRG5pS2xoVFlIKzFqaFJHQXIzbmY2eXFscDFHQXJabi9F?=
 =?utf-8?B?QWNqVC8vYWxtY09OcUJ3d21xTkJDQ3ZXVjZMUmZIdFRFZmtEczdSWW82TUk4?=
 =?utf-8?B?U25rWmdUK1JCNHNXVFRyeDNHbU1yWDFRcWJ3RVNQb2wrNmdTVjk5bDhybE10?=
 =?utf-8?B?OTNoQUszNGdLR1hRc1RuRXFNQTRUdGU1NWFSR3pGakdURjlDNmtteXhsdG9q?=
 =?utf-8?B?RlNVUzdMUGlKdERCR1hMc2lKWVo1Z2ttVGUrODU2Tm9uc3Nucnc1QTUrNFFP?=
 =?utf-8?B?Nk1TeUo4V1FFa1FXS1NTWHh3VUZIcG5IOXlEQnJoelhLS29ieEJVbnFNcDhW?=
 =?utf-8?B?enNWUUxPKzBKQlhOZEtMb0Q3Y01xTEprT2E0VG43aWd2TzEwZ21LendWYWd6?=
 =?utf-8?B?RjVlemZpdlJHR0o2ZDZWNzRWUXVBMUx5cGZUVFJ3TEtKQzEvL0lDV2ExbWta?=
 =?utf-8?B?bHhrMDFuV2d0NmxzSXdJQWRsRDh1VGpoZ3dLNmNqRkw1bFRHVUNYdXByYnJJ?=
 =?utf-8?B?ZlhiYmtDOFpHSVc0Y1BPNS9KcGV6TUkzZnhPb0wrSS9FdmtRNzhtVGtBQXVw?=
 =?utf-8?B?VDdLSEl3Qml1aFNkcWRYUDZFd3RmTGk5ai9kVlVWL2toNWx4NktOZm9BZzZt?=
 =?utf-8?B?VWpRVW0vcFEyV3Z6TDJYaGZnODFCb3R0QzhFVDIvdjRBZVJIRjM3ZlV4WkNC?=
 =?utf-8?B?ZWJ3endEaFVMNUpvV01vRlRTYnFUbUtwbUxnbTRJZUtZL254UEZVOW5TUnd4?=
 =?utf-8?B?Y2hjWVprNHlhdkdLcGhqSFpzci9waGFoN2NJN2I0VTVhZkgxb3dpK0dVVG9D?=
 =?utf-8?B?NEVRcmxTVlRidEFrR1NoSEpQNDhaUmdxRkY4b0s4dEVSYlYxODJuKzlpN1U3?=
 =?utf-8?B?d2FXMmgzRzd1Z3dqUnc3N2Z6bk9ZZFFDQ3VhRmFYcFp2V1Fmakh1dHNhYk93?=
 =?utf-8?B?SzJKZmFsd0VSR2JabUlvTXZNRlZCM3ZlZGQrdUlhYVNzaGhXZGRsRnJYM0Mx?=
 =?utf-8?Q?lOnjSwgkYjWjKOx+/0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c16b88-9424-4fc4-c8b5-08d94856c5c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 12:39:37.1551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6am1vxMiKYZ7LbAU5TZcr+nNYbSrPFRYbrLpyUXoxqApzCtmdLUkkxTVlq04BlawLRLABHJ7dzHfRlhbXf6rWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiA3LzEzLzIxIDk6NDkgQU0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBPbiA3
LzExLzIxIDU6MjkgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+Pj4gVGhpcyBwYXRjaCBpcyBh
IHBlcmZvcm1hbmNlIGltcHJvdmVtZW50IGJlY2F1c2UgaXQgcmVkdWNlcyB0aGUNCj4gPj4+IG51
bWJlciBvZiBhdG9taWMgb3BlcmF0aW9ucyBpbiB0aGUgaG90IHBhdGggKHRlc3RfYW5kX2NsZWFy
X2JpdCgpKS4NCj4gPj4gQm90aCBDYW4gJiBTdGFubGV5IHJlcG9ydGVkIGEgcGVyZm9ybWFuY2Ug
aW1wcm92ZW1lbnQgb2YgUlIgd2l0aA0KPiA+PiAiT3B0aW1pemUgaG9zdCBsb2NrLi4iLg0KPiA+
PiBDYW4gdGhvc2Ugc2hvcnQgbnVtZXJpY2FsIHN0dWRpZXMgY2FuIGJlIHJlcGVhdGVkIHdpdGgg
dGhpcyBwYXRjaD8NCj4gPg0KPiA+IEkgd2lsbCBtZWFzdXJlIHRoZSBwZXJmb3JtYW5jZSBpbXBh
Y3Qgb2YgdGhpcyBwYXRjaCBmb3IgcnFfYWZmaW5pdHk9Mg0KPiA+IGFzIHNvb24gYXMgSSBoYXZl
IHRoZSB0aW1lLiBBcyB5b3UgbWF5IGtub3cgd2UgYXJlIGNsb3NlIHRvIGFuDQo+ID4gaW50ZXJu
YWwgZGVhZGxpbmUuDQo+IA0KPiAocmVwbHlpbmcgdG8gbXkgb3duIGVtYWlsKQ0KPiANCj4gSGkg
QXZyaSwNCj4gDQo+IFRoZSBwZXJmb3JtYW5jZSBJIG1lYXN1cmUgd2l0aCB0aGUgY3VycmVudCB1
cHN0cmVhbSBVRlMgZHJpdmVyIGlzIDYxLjAgSyBJT1BTLg0KPiBXaXRoIGEgdmFyaWFudCBvZiB0
aGlzIHBhdGNoIChvdXRzdGFuZGluZ19yZXFzIHByb3RlY3RlZCB3aXRoIGEgbmV3IHNwaW5sb2Nr
DQo+IGluc3RlYWQgb2YgdGhlIGhvc3QgbG9jayksIEkgc2VlIDYyLjAgSyBJT1BTLiBJbiBvdGhl
ciB3b3JkcywgdGhpcyBwYXRjaCByZWFsaXplcyBhDQo+IHNtYWxsIHBlcmZvcm1hbmNlIGltcHJv
dmVtZW50LiBUaGlzIGlzIHdoYXQgSSBoYWQgZXhwZWN0ZWQgc2luY2UgdGhpcyBwYXRjaA0KPiBy
ZWR1Y2VzIHRoZSBudW1iZXIgb2YgYXRvbWljIG9wZXJhdGlvbnMgaW52b2x2ZWQgaW4gdXBkYXRp
bmcNCj4gb3V0c3RhbmRpbmdfcmVxcy4NClRoYW5rIHlvdSBmb3IgdGFraW5nIHRoZSB0aW1lIGFu
ZCBydW5uaW5nIHRoaXMuDQpCdXQgZG9lcyB5b3VyIHBsYXRmb3JtIG1ha2UgdXNlIG9mIFJFR19V
VFBfVFJBTlNGRVJfUkVRX0xJU1RfQ09NUEw/DQpXaXRoIDYwayBJT1BTIEkgc3VzcGVjdCBpdCBk
b2Vzbid0LCBhbmQgdGhlIGNvbXBhcmlzb24gaXMgaXJyZWxldmFudC4NCg0KVGhhbmtzLA0KQXZy
aSANCg==
