Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF35C4320A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 03:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C1460F70
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 03:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhHGDcz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 23:32:55 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60812 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhHGDcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 23:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628307157; x=1659843157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rblmgxZSC/iW4zbwyzbPboCLnuwawmAk3fXJ0vmwsZc=;
  b=buoc43ipBtryZrmP0BJ/NOmFcsDYT8ZtbBCRBqFnvl8Bq64pVDoM1kdg
   XbvAv454581Ito+lEmaESbfBaxbkQMfDlgEGqu5a4lweQ8mFvozE5Z4UR
   MyfOTaoHsolYqz/1HIvRiVXprrUilxTwdLwQNnkA43nWT3+nWNH6kDNeT
   Q3NqX6JPFSnEPnbnazEzKEip6krFcZ2GBAexG6uwuUm+G6hOJXdRuWHUu
   ywASq80xx1KBeH8cHh6oi3rSRZm98xl0xqGRne/XYBeep98zFdpeG2RNY
   YH0vsJZEH3Kqbhy10IDCVbS9VwykufHpwMpA2BgDDGdb/WBv/He5uVBFO
   w==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181361768"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 11:32:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTIFcs7T4MCaoQEU+Y8j04NTdwYk0a+qun1QOC1HvvYjWUm4ZvEQnLyXNL6KamMpi0sFS+uZwL9j1EOowIKeURKe7xJx7/j06mk8ZWPnIssUPLGHG/2JXarfmeVJ2kgb5PkHCjCYP3DJngbOBj+eE4JB6nrzrDmJxlMnZcyCsp40yjnmw558ef9e6t1/Xne/ptIIcitxVZFX7HA19IMvN2zlDtxZAPGVfrpO0ABOeQf2xAhplYmbRF+6FZ2/PHrQkmmuNlVK9rBzKHkWIyLm1T8c3OkpgY8odNMAzsffcoL2OuY7tFHi9jmthLAjl6uEobgaaFR7x4t88pB9I2UpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rblmgxZSC/iW4zbwyzbPboCLnuwawmAk3fXJ0vmwsZc=;
 b=PNlfaZcH+nCJZx/ZmJcFsKUMo5rdFZ2RpC9y/sFKzefjXoBYNnrI/+gq16GkIw3HG8ZDCLcstUH3vkVIliafu5q/PO3fdwWDrg5j34io9CCvdQaJQkbqa/nDhIxpSOIauEL/TaBnSV0HRYi9FBWCiDq9V4hk86EimPKZxOAi5mxGPmhKt0lXx+FXRXlhc2UK0VVfmipopUBDIWbOrVk7pEaCuN/0F8vyo1vnWzOHt8Emg66KzeKNgCOTJ062dcPiuWCyByWGQI2PlmrqJL7JZ2YN1hU4iBq4O/a71MdGtvrsRQKQYuiC4NSqlZdhKHbOMinz4vZ92YChCz984WMapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rblmgxZSC/iW4zbwyzbPboCLnuwawmAk3fXJ0vmwsZc=;
 b=vDfs6+jNQHfr/kTmw5xDz1nkfv5ftCGmIkMTx9c4W03Q/4rtcv10zMNqI6kLxouiffzP2Ngi5lijax5THFJIK4CNJxhor778KRKJprDfB2uh2VO2aPj9ASzySe++aP7vcKE7d89NK2WGp7LUQj8IFU8QsgXVxj7mZCw2BB+ILpI=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6827.namprd04.prod.outlook.com (2603:10b6:5:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Sat, 7 Aug
 2021 03:32:34 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Sat, 7 Aug 2021
 03:32:34 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v2 2/9] libata: fix ata_host_start()
Thread-Topic: [PATCH v2 2/9] libata: fix ata_host_start()
Thread-Index: AQHXipay2b/b7gRyOUiJ8rOG9KiypKtmil2AgADaKoA=
Date:   Sat, 7 Aug 2021 03:32:33 +0000
Message-ID: <6041d740405be01dc4b1a1f31f723e2e9219aaf6.camel@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
         <20210806074252.398482-3-damien.lemoal@wdc.com>
         <1dca71ad49be897f9544d0de59204e42a5b56a50.camel@HansenPartnership.com>
In-Reply-To: <1dca71ad49be897f9544d0de59204e42a5b56a50.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33cc89a-a9a5-4d4a-c965-08d95953febd
x-ms-traffictypediagnostic: DM6PR04MB6827:
x-microsoft-antispam-prvs: <DM6PR04MB682799E326D392E984393570E7F49@DM6PR04MB6827.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3cnTAG7fNyc0h17uLFcN3QQtaYsY+YLN8hfvcIH5lXpx+W0Vha5eh+8WBC6vgFFV16OjU8Vq6AzKJPTjCdHzGqEBGDl36+N/sgguyj/aeS4411vz9sxRQkiBoLg/5uGl+sC5W0P4iOA63AVEJPb1417M/H6PpC7rwfST6kljUcUTNWTuixKTEsZT1YvLRd6CNLMdypLX/vctixpOL3hewF1bytIIGQ/uxMtW3fq75nhwQFYzJNxUqJNj3shCpQpGPtl7S9o6kF5sHkz8IrmZTCD4nrNdMQMGtssYE9XWwDnyVkaqkL3HzSpctzVpOcOtV2457gchTRLLPtPfgiCIHfHt2SbmCYCCYcRV/JzfTUqkUt8HNPW9kls1kNc9MkwmsBQ1sPWDf2TqBUvrfeT7K67kzWa7g/kx5S0joEi4kbuMErfZ8ZoR3vdhlX3fybpHe90wj3vp2bjz7+fwv3q8CBQmKfkfJ1uAR5FtLzo4IxyUpU4T+SKJhTAmLnp06YFXITxAOg1kvmjpaBXCXWcxupK9Nm/uf1rLVt/RtKzHwwYy4J6jz2WNo2l78g7EdbaGrioNME5BCAocWHhSm3WTmvm+aUZ+0iKyJAIUOYC0JppxpLgPQ23ILfc8+lL63oFqSYgI4kxzfX4ZDQtZ0NRySxwTo/4REbiKRJJOL6weyMV/zJ/I5ZAuvxkY9+tUBj3Rk8NpcqO41pqYjNgvibOqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(110136005)(6486002)(508600001)(6512007)(38100700002)(8936002)(6506007)(316002)(186003)(2616005)(71200400001)(86362001)(122000001)(38070700005)(66946007)(54906003)(76116006)(4326008)(64756008)(36756003)(66446008)(66556008)(66476007)(91956017)(5660300002)(8676002)(2906002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXBhdVdwSlByd3hMcnQ0OUJKdFVpTUl6MFZqUFBYRjJtSER2bExDN1N5Z05C?=
 =?utf-8?B?NmFlRTc4QThCVnBOTzlsSWszdlM1ejdIZFVxN25ZYU5WeS8rS0RHdXB5WHdT?=
 =?utf-8?B?ZFY5WDRocHRLRmhRaWpGdWdqb0huVWh2aFhGS3NhSHFWUXRLTlI4ZjRyRVFj?=
 =?utf-8?B?cjhvQ0ZkelluOEsvVjVpRGxQaFJTeHo2a1J2UURYZjdIZnJaKzczYWV5cGJm?=
 =?utf-8?B?OGhLQzRBMUZZWkJHbGdNL25KY0JLVStwdGg2aXJXc1cxMGVrZUlhbmJYV0Ez?=
 =?utf-8?B?cWhTRHkwRUNBL3gvTkNSUmI4SVUxdUVDdkdyc20xNDVGODB2T0JiTWVMR2NR?=
 =?utf-8?B?dkZwWXJFVSttS1B4UE9IdnArZ25FSE1aa1BHNTVzWG9MQmk4RFNHV1RHL2t3?=
 =?utf-8?B?US9NREczQ1QzL1RLNUZoaWRyREloeXh3SU5VV2x5allrSDlNTEk3NG5TaldT?=
 =?utf-8?B?TW0raUpRYUhQcEl1eitCREFaVWpoV3hPbzArR2VNZmZSeE1BVWp3bTNZYUFN?=
 =?utf-8?B?NFZqQUNUSUJhQW5mcS8rbzRNRlFvQ0RSc045dkZTNEtSMDNrSFJNbzRMQld2?=
 =?utf-8?B?a0ZaS0xweVpySlp0eGJDYy9qYmE1YnRVVURRS240UXJrT3lYTzVDZUZoUzRv?=
 =?utf-8?B?SE1TYUV1OFRJWWViRURaaWRObC9ONzB6WHZvMzNiT1FwUGV3NndNaDludnN3?=
 =?utf-8?B?dXlEWk9IRHdHS1drRHdTYzRSR3VPak03Vk9wL0tFMjJhWlRFNlpoN3o2SjRl?=
 =?utf-8?B?OFJIT2YxZEx5MmNkOExDY3F4UHFJZUE1R0hOMnJtSk1DYmZKcGF0ZkxCL0VE?=
 =?utf-8?B?WVpPaVdBbWRLRXVVSW5oRWV3OGhxWHByTEFZb3R1VHBlTUE1N2lJeDZ1TUto?=
 =?utf-8?B?YVpCTEdCTyt1Z0M2dUJOV3hZVUIyR1gvalB3UlR1ZUEzamt1TW00ZnUvck1s?=
 =?utf-8?B?bW5zVVRFT2VhcEtkZlN6YzZuYXJ4SkVlemlYSUtSU1p6T3E5ZUx0L3V3S2Nz?=
 =?utf-8?B?SEZiVDArVlVrekg2RU9SYUUvL2dpQVYrbTg3K2JQYWgwcFZ6VXp2ay9BNTBj?=
 =?utf-8?B?Wi9hbGlEclFJM2RsRXRDNlRBSTZNRjZRcWFrU2ZQUnFVVTY4Rm9JUWhCUHFD?=
 =?utf-8?B?SmRFbDBGb3JjUnRuRCtEaWRSa0xnME1qTkF2bng3c05sTVZReWJ0aDd6cXBV?=
 =?utf-8?B?SWNLOVJMR0RncTJPV0Rqb24zQWNteWE0RXZldnRGRFErd2kySk13TWNOVCtT?=
 =?utf-8?B?M21iT2tBQUNkWVZYNDZUOGJDSHNvd2VnL3BSWlYxWUwraTZPT2VBdHY2N0Nu?=
 =?utf-8?B?UXVzaG8wWmxldDhhMWhXeFpKZ0huMUZxT0wrb0pScXlMVytpZU9UeXJCa0wr?=
 =?utf-8?B?cWlCQ2FBYUM2dDF1ejF2SXZTeisxazllL3R2TjE3M3VZNEwxQnZHU24vVDli?=
 =?utf-8?B?VCtXakVrUjkrZzNJU2tqRXJRNlJXcjdYMWtrbkZDdXRZWnV2VTRxRUNLS1l6?=
 =?utf-8?B?c01TeERmb1Vrb2N2MDJnQTZzMzZFNlM2LzIzSVRVcDlWcUlOTFZwQU1HRE9V?=
 =?utf-8?B?Z3ZjZC8xN2N3am93OEduZEJyNForMlZueHlNeVlhUzZhN1I5NHY4NEltM081?=
 =?utf-8?B?N1dYQXNlYUFxaFM5LzAvMXZnakRTQktBWWp2VjJ6Ukx4MDZyY3J5aUlXajRn?=
 =?utf-8?B?N0JaMUdPRm1iNmdNU1lJTVAxNDRFb28rSzZPVXFNdFh2TXNieHRZZUEzTGdX?=
 =?utf-8?B?ZTRFUGEzM1JRQlR2RVFXdzc4RldqaUFsTktMcGJrZGFMaFhSd1owME1iUXdH?=
 =?utf-8?B?ZVlyYjB2aU5pY1JhYng0UT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4398806302EB4C48A7DA1EB38AD73BC9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33cc89a-a9a5-4d4a-c965-08d95953febd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2021 03:32:33.9658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iAo4Ky+i5uWgTPmsUCicD+e7S7efIgptg0LWuSNNF0h+gsYVorED1kuwc65EekcXN/izZgyz1kpns/TaX5hwvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6827
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIxLTA4LTA2IGF0IDA3OjMxIC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIEZyaSwgMjAyMS0wOC0wNiBhdCAxNjo0MiArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3Jv
dGU6DQo+ID4gVGhlIGxvb3Agb24gZW50cnkgb2YgYXRhX2hvc3Rfc3RhcnQoKSBtYXkgbm90IGlu
aXRpYWxpemUgaG9zdC0+b3BzIHRvDQo+ID4gYSBub24gTlVMTCB2YWx1ZS4gVGhlIHRlc3Qgb24g
dGhlIGhvc3Rfc3RvcCBmaWVsZCBvZiBob3N0LT5vcHMgbXVzdA0KPiA+IHRoZW4gYmUgcHJlY2Vk
ZWQgYnkgYSBjaGVjayB0aGF0IGhvc3QtPm9wcyBpcyBub3QgTlVMTC4NCj4gPiANCj4gPiBSZXBv
cnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4NCj4gPiAtLS0NCj4g
PiAgZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQo+ID4g
aW5kZXggZWE4YjkxMjk3ZjEyLi5mZTQ5MTk3Y2FmOTkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9hdGEvbGliYXRhLWNvcmUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMN
Cj4gPiBAQCAtNTU3Myw3ICs1NTczLDcgQEAgaW50IGF0YV9ob3N0X3N0YXJ0KHN0cnVjdCBhdGFf
aG9zdCAqaG9zdCkNCj4gPiAgCQkJaGF2ZV9zdG9wID0gMTsNCj4gPiAgCX0NCj4gPiAgDQo+ID4g
LQlpZiAoaG9zdC0+b3BzLT5ob3N0X3N0b3ApDQo+ID4gKwlpZiAoaG9zdC0+b3BzICYmIGhvc3Qt
Pm9wcy0+aG9zdF9zdG9wKQ0KPiANCj4gc2luY2UgaGF2ZV9zdG9wIHdhcyBhbHJlYWR5IHNldCBi
eSB0aGUgcG9ydCBvcHMsIHN1cmVseSB0aGlzIGVudGlyZSBpZg0KPiBpcyByZWR1bmRhbnQ/DQoN
CkhhdmluZyBhbm90aGVyIGxvb2sgYXQgdGhpcywgSSBkbyBub3QgdGhpbmsgc28uDQpUaGUgbG9v
cCBwcmVjZWRpbmcgdGhlIGlmIGlzOg0KDQoJZm9yIChpID0gMDsgaSA8IGhvc3QtPm5fcG9ydHM7
IGkrKykgew0KCQlzdHJ1Y3QgYXRhX3BvcnQgKmFwID0gaG9zdC0+cG9ydHNbaV07DQoNCgkJYXRh
X2ZpbmFsaXplX3BvcnRfb3BzKGFwLT5vcHMpOw0KDQoJCWlmICghaG9zdC0+b3BzICYmICFhdGFf
cG9ydF9pc19kdW1teShhcCkpDQoJCQlob3N0LT5vcHMgPSBhcC0+b3BzOw0KDQoJCWlmIChhcC0+
b3BzLT5wb3J0X3N0b3ApDQoJCQloYXZlX3N0b3AgPSAxOw0KCX0NCg0KU28gaGF2ZV9zdG9wIGlz
IHNldCBiYXNlZCBvbiB0aGUgcG9ydF9zdG9wIG9wZXJhdGlvbiBvZiB0aGUgcG9ydC4gVGhlICJp
ZiINCnRlc3RzIHRoZSBob3N0IG9wZXJhdGlvbiBob3N0X3N0b3AsIHNvIG5vdCB0aGUgc2FtZSB0
aGluZy4NCg0KVGhlIGtlcm5lbCBib3Qgd2FybmluZ3MgSSBnb3QgY29tcGxhaW4gYWJvdXQgdGhl
IGZhY3QgdGhhdCB0aGUgaG9zdCBvcHMgbWF5IG5vdA0KYmUgc2V0IGJ5IHRoZSBsb29wIGFuZCBj
YW4gYmUgbnVsbCBpZiB0aGUgaG9zdCBvcHMgYXJlIG5vdCBhbHJlYWR5IHNldCBhbmQgYWxsDQpw
b3J0cyBhcmUgZHVtbXkgb25lcy4gSW4gcHJhY3RpY2UsIEkgZG8gbm90IHRoaW5rIHRoYXQgY2Fu
IGhhcHBlbi4gVGhlIHBhdGNoDQpkb2VzIG5vdCBjaGFuZ2UgYW55dGhpbmcgYW5kIHdpbGwgb25s
eSBzaWxlbmNlIHN0YXRpYyBjaGVja2Vycy4NCg0KPiANCj4gSmFtZXMNCj4gDQo+IA0KDQotLSAN
CkRhbWllbiBMZSBNb2FsDQpXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gNCg0K
