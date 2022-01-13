Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48032C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jan 2022 12:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiAMMwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jan 2022 07:52:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4694 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiAMMwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2022 07:52:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642078358; x=1673614358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ElfPD/n6zGS7S2fK4OxlAMEp8I434iR1/yfACKFfq8I=;
  b=MuFph9rySFLY0QVtCXPi48vY8Q5O0r+m+lJUpFwX1VWPhiHgTSLvzzUW
   QkXoimXL60YeifJ8nICorlKuxh9etSK4GPuZrh6IU5cXK5nyl8Hh1xI77
   nkWlNM//qoTxsMV1JXV97QdCv7gJtbzXAhopKIdJUkV5AYQ/zhB4GZLJx
   5+VC3UQA7kXaXhaOyvA2bV7SkiJq5DJyYdptUW1763VQuaSjy6XGyK4kf
   Y+16Gb+xFrp8nPAbC0jXMRxUE9bd0A9Cl/Es9PFVDgjhdcYEfuuPJ2hyi
   pewDxCoEL0Wj/bj3XffMT2GpkQHjwR/0jYyJ28RQMCr0VVHILWX4Lyll3
   Q==;
IronPort-SDR: vln0Econgvmr5sLiwHl5lNqlVCUq2Df84FUYM5iYh6SVoCAo/4yS0Haus7ufffez+A3IoOuI0a
 fv3aOsKezjmB056Dtuu+GGzRhagfNO1Pw7Q+Y/uD2+9OWowQpzUIi03uSEtWFqqRQAqNzRCJVI
 z0jx1cmm1cMfGbQ3X2q5hf415l01e/WPhuutYAN55b72FRTl6SNBum4MRoTdDHR7TtzwWeNVdu
 nI/Z5VVXWYjnR6S39x+bxPdaxZGDjYlukfbLVXRO5UHuCjJzBzWzwptn7joubErY+T6b3Ga91Y
 ggbE/N8S+1e9Hr0TkPKHCM3U
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="145314784"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2022 05:52:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 13 Jan 2022 05:52:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 13 Jan 2022 05:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lajAK/OtntR/8+XbNZDICp/epjM+J9s4Kw66ybUCSHOHYnA0/h/tktzneo38ZFXsfRLkJJNjyeyQv8H0C7GKV5GMjdRzgRQ/iNewNOFegfb1po9sIqkH1zNU2AEM85fPrXVc6jC9BopA2UY0hn9zzm7hayrvmgSDgv8L96QWy93TPoEWY1uNttfcQbmeCn+Xq63ykqaGXeih1RcCKGc1ijwH5X2lMcosiafX9ZxifAd9w6aeNAstLWxGwRm5xQlPdkxAhi6wizuifgy08ponZ2ciPmby0Nt2ZQOndGMpV34qulRLKGnbXZ0qTrq20K+bEY99kPieqZLlX2rxaDuWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElfPD/n6zGS7S2fK4OxlAMEp8I434iR1/yfACKFfq8I=;
 b=R8JCn5Z16eNDG+VpcHq+VvI6G2rrI/ibuBtjhykwncCwarh6xhxq4I32vm8X5wNqiZxA2jcpgFDT41vFFrxf7I1jVjPieUvj1v6BPp5nBOhevyRXd36UqDCHiYqX39xVNzzSFwXjfdeuvHXNiC2zgXh4Eso3GM6DM4um6KkyLIn2mUH+c9zsds44CsKHufrzg0l0YP2FtBJeDuqR0xj6RjcxhWfDfgpdXBLfgLQAWNHYOi12FyaGOULD/JRZPrQHBG9YgEnyxAhoyBKFPiskfge6KjFzuODyITltTgpzPhDPWNbTHDS6UGwODRyHW6RXM+2Tps1QgMILp/HUEw1XoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElfPD/n6zGS7S2fK4OxlAMEp8I434iR1/yfACKFfq8I=;
 b=IZEBMr6A0vMRwNxpEh9joI9LtI23JJXUR4BbIf391uuo/Pd77tBE1fXQWqkb4pMPPP6s86dSHWCqLFvfv8X6ywhOYjUQ1nMCn843W83s97o2K/FISuBRd1O1YNdXkaabf0GzhJ6sAZkSm2u5tNmbl3pJdWBbFP4gXQ1Og/ojrFw=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by PH0PR11MB5142.namprd11.prod.outlook.com (2603:10b6:510:39::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 12:52:32 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 12:52:31 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <john.garry@huawei.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
Subject: RE: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Topic: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17ggAVR6YCAAQpd0IAAE0SAgAMLX3A=
Date:   Thu, 13 Jan 2022 12:52:31 +0000
Message-ID: <PH0PR11MB5112E3E9787F20EDEB58D481EC539@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
 <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
 <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
In-Reply-To: <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 534706ba-605f-4cb5-6bef-08d9d6939051
x-ms-traffictypediagnostic: PH0PR11MB5142:EE_
x-microsoft-antispam-prvs: <PH0PR11MB51422E3561CB75F90DB7F861EC539@PH0PR11MB5142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NL5io8qHAHFPuqR6wdDjj5hFO8N7h3+mJxAHU1gYfN5vydL8r+bMCs1OkSpyP8aD/uQr4hhAWuBerwCqek6cvzFfhZKsA+nu8v6LTJE8Wkh3U+bdTuSeNnymw7rqScKRxJesd8RiAUjiBEOgoZK90zZ/c3F65GD9+um3OViG2VfYlRUn+z9AthN89tER2ls0IyUGaJzhHGFezMDv33OE2ONhQdLt70uZXkPkLdZQeuXWIJr0c4nditqoLMy/revuuR08FLJ2ROnvfgThZT2vbu2KV7upUNPtZw8o9fY3c0TnNmcTAzkk0u4EolE8JPJCAqN3jzxsyPuvpiDkXa9ICyz1Y+/cdA/ouC8hlK1Kki18WBZtVv6v3xYNdnGlgb/WNoFR/iNJ/yL7veiaQ3DY4HMeKJGa6Frh97kkU/1+T/ncIVzJWT+Nu3C1ztBLVUVGEvnrQ/wDcS0v0gVAXt2NJrps+Ow1sFW8Z8k9SJ7NIvVfnkyt+oVr/IopdBjjPz5wkBgo5Tttgw1EfrJyJq9tLK5307K/Iu6WY/c/EC079gQMBflUVkbps7vRH/ZonhaDHxLrfIegg7UgX6J4j2XwAgCWJOEZ1a9ypt4tFM5PiIfZh00RvTCLtSs/3OZIHmCOuUCLjZ98okbOvFqd7Wuu3HzsViFtMHoJ5H9Ti45nm+WGFXNd72tzTCVjyG51kC8Ad3zQ1X57bpU1ThTQIz4WiJ+2sTSLI+XUusNiTLx1RjIrw7+BiEvP7WIgZ6jflF33oKaex6h/5eYDxvt66Mb9fGT6+OZPTn3RJTfUhoAWso=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(110136005)(38100700002)(122000001)(54906003)(66476007)(66556008)(66946007)(66446008)(71200400001)(86362001)(83380400001)(5660300002)(38070700005)(2906002)(52536014)(316002)(55236004)(6506007)(33656002)(6636002)(45080400002)(9686003)(55016003)(4326008)(508600001)(107886003)(966005)(7696005)(64756008)(8936002)(186003)(26005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2F1UFhxZlZJSWErL09WYlY5SC9zRlI0eDQwdVd2Yi84Q2JxRHprN1hmdlNV?=
 =?utf-8?B?ZVFMVTV3ekdvdHc5VnR2N1NiNGFMbkRONG4wMzJjUWpFKzlxeGJTM05ITnND?=
 =?utf-8?B?b3JQQ0VhNnk3ZFVlcnpvWW1MOHpTR2VySjlicGRmTWVXME5meENVZFBpeEVm?=
 =?utf-8?B?NmNlZ1BVZ3lwdlFETVhzL3F3QTBvT0NoRkRrWnpPcWpRVldwaWpRaTVPY1hH?=
 =?utf-8?B?ZTYyS1A4N2ZZSWZ4bjZpUHllRmpLaE4rdUwwckUrTjZoVlNXdFZGWjRrQTRW?=
 =?utf-8?B?QTBzTTBDcURUenNCQzVnZ2FCZHlvN1RLdEpjZjUvNG1EVnJQWkhpRnQvMzNC?=
 =?utf-8?B?R3p2K1d3NmFpMkJxVHloN3VnUDZhUlgzQ0g3aUZkYmRDM1V3ZnZIeE1TWFE0?=
 =?utf-8?B?Q2c0Vjl2NHNqTVd6aWl6N2RLUDM5M3VsZXQxNGd4djA2cnNLWk9lakZrZElN?=
 =?utf-8?B?eFZXNCtVek5qM0twSDlmU0xXOWFZc1RET3h5Nmw4M2xOZm14T2F1cjBwa29i?=
 =?utf-8?B?VGlLUnBPbFpiNVpTZmg3emp0dTVJVGFyMUtBRGU4dHorRHdubWlOK0o0Mmtk?=
 =?utf-8?B?SE9oaUZ3a3EwN0dXR0pqYnpsckxKWkFMSWY0T240ZmYybDBZYS96UUo0VWRr?=
 =?utf-8?B?UC8zdFJxTEdJQjY0b2dVV3dUMk5wQlZsQ0VtN0VKMnZXVWFlOGMwQWJmenZs?=
 =?utf-8?B?dVlXTzJhdjE2SWZJRG5oTFJsamFhMTVkOUlpWGJid1ZVVTYzQ2o3MlYvT29V?=
 =?utf-8?B?b2p3VDJQbTc4UUp5Mmd4V1lseXlwOUt6V3pnWUNISENQSStsNzVQdm1NdmQ0?=
 =?utf-8?B?QlJMTTNNNEhKazBqdXE4aFA3cG1oSnh6SThobWhxYmcxdStRTm9SenkrdDVW?=
 =?utf-8?B?R0hFRWxld0JnNDF0empSSW9RVkl5ZTlSTUV0ZDJDeWZ5UDJHSjMrYWZDZzFq?=
 =?utf-8?B?cnNUVHNDTTIwbkxDanFNR3RaV3FtY2EwbnBJbVRIdWpTM2pnOEZxZi9WSjYy?=
 =?utf-8?B?bXJqZERZVDJYRDhPNzNZWFhyTHc2YjdydmVMMkJpUzB2SVVabUl2cEJvaGV5?=
 =?utf-8?B?SDRTK2k1VEYrbzBMNURCQUMvZ0Nkb09YaEpieU4yQ211cjVtMzdCSVFKSksw?=
 =?utf-8?B?c2JEcmtDN3d2S21sc1AwbmhiN3pOMHU5WmNoaVQ4d3k0QWNPR0dCYUVKQ2dB?=
 =?utf-8?B?TGxmZ0dVelo2UTh2Wk1BZ3laZFM5L2tiajZWK2ZEc1NkY210bHhMelJUR0U3?=
 =?utf-8?B?dVUwTFIyTkFTbkx4ejV1Y1lETXJ0bkJBRkNDakVXWWdBWFkvK3d0T29pYkp4?=
 =?utf-8?B?SGFHSXg2RTM5L0FaZ2pTMy9CVDF6NUxreUh5TXpxR1k0Tlc2cmFOZTNWc0hD?=
 =?utf-8?B?MVR2NlVPMGdWK0hZWk5ob21RVFZlWTBtWTB4V2VndjQxRkJKS25hOEc2NUhz?=
 =?utf-8?B?K2FJOG1RdEFuMTBmRHRSZW94NWptSXF6NXkyTlA0U0x1U0R5YXFLejhPdEk3?=
 =?utf-8?B?T3NlbUFaRHFQdHBLdFNDajFDTEI0czBzUVhVUCtzaVh3SlVtKzU2UTVCZEZU?=
 =?utf-8?B?b3pZK21YQzhFaURncDFhRzlHTzVoS2lpTm40cUVjS1pVUG1zSWhkWm11cmFv?=
 =?utf-8?B?NTI3RnBiRXFmVllxVEFNK1FRd1ZwakpkSmVWM3E0S1R4WVhqS2JCVGtJM3pq?=
 =?utf-8?B?QWJ4U0orU2tWM0oxVmVrWE1FeVJyZ0R0ZjNQcnd2d2tZWjUzWlZJcG5pa00y?=
 =?utf-8?B?bzVlQTJMWmh4ZGMwTDJLTGtoZlc4WFhzdThad0JISzQ4aUxqYkI5aVZ1WXhS?=
 =?utf-8?B?TGdqbHNIT3B0VWpodDBMMGRubUJTYVJrQXkxWGFmb2I5eDc3WG9hYXBzSWFF?=
 =?utf-8?B?T01BNm11ZFNJL013Smo2OXFsM0JLQ3puMzBGMTYrb0VKZ0J1VTBGSkd0ejFX?=
 =?utf-8?B?UjRqN2k1NEJmNGlLWTZLdkxSWEpCVjYxdEZXb3pMZUx3NUxFek5idXRQelBI?=
 =?utf-8?B?VUU4VGsra0I1QXpyM1RpeEY4Y1VMdUcydXNSRVE1c3I4VFAzbHJsOU9BWDVW?=
 =?utf-8?B?bWViNXArS3RlaWN0M21tR1djdTM2dEl3VDBqMVJLaXBob1ZEa2tTVGZhbUVp?=
 =?utf-8?B?N2RTUTk5S08weStGT1k3S252YWQ0YlY4S3B4VXdnWkM3Q01Fd0FvdEFYZVFL?=
 =?utf-8?B?M3RKYkwxK3FDMU1QOWFDTXY4dWk0R0V5VmIzNzFxbmg3emlCZm50Wk1TK0l0?=
 =?utf-8?B?NHE1ZWdOYjZCRXhxV3JEaVBoSExBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534706ba-605f-4cb5-6bef-08d9d6939051
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 12:52:31.8646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptjQbfkmTGS364CBRqwhLOVYPyvuufdF1Is2ZYAfUBV8EOhy5A+RYfDs+pTPqE8eOApxuHabwWogBjpaKxpGE5CDFM8VLaCwjUjvQEpXGvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5142
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCg0KPiBIaSBBamlzaCwNCj4gDQo+ID4+DQo+ID4+IEhhdmUgeW91IG1hZGUgYW55
IHByb2dyZXNzIG9uIHRoZSBoYW5nIHdoaWNoIEkgc2VlIG9uIG15IGFybTY0DQo+IHN5c3RlbT8N
Cj4gPiBOb3QgcGxhbm5lZCBmb3IgQVJNIHNlcnZlci4NCj4gPg0KPiA+PiBJIHRoaW5rIHRoYXQg
eW91IHNhaWQgdGhhdCB5b3UgY2FuIGFsc28gc2VlIGl0IG9uIGFuIGFybTY0IHN5c3RlbSAtDQo+
ID4+IHdvdWxkIHRoYXQgYmUgd2l0aCBhIHNpbWlsYXIgY2FyZCB0byBtaW5lPyBJIHRoaW5rIG1p
bmUgaXMgODAwOC85DQo+ID4gVGhhdCB3YXMgc2ltaWxhciBjYXJkIGkuZS4gODA3Ni4NCj4gPg0K
PiA+PiBJIGhhdmUgdGVzdGVkIHNvbWUgb2xkZXIga2VybmVscyBhbmQgdjQuMTEgc2VlbXMgbXVj
aCBiZXR0ZXIuDQo+ID4+DQo+ID4+IFRoYW5rcywNCj4gPj4gSm9obg0KPiA+IEp1c3QgdG8gZ2V0
IG1vcmUgY2xhcmlmaWNhdGlvbiwgaW4gdGhlIHNhbWUgdGhyZWFkIGZvbGxvd2luZyBpc3N1ZXMN
Cj4gPiB3ZXJlIG1lbnRpb25lZC4gUmlnaHQgbm93IEkgYW0gb24geDg2IHNlcnZlci4gRG9uJ3Qg
aGF2ZSA4MDA4LzgwMDkNCj4gPiBjb250cm9sbGVyIHdpdGggbWUgaGVyZS4NCj4gPiBJc3N1ZXM6
DQo+ID4gMS4gRHJpdmVyIGNyYXNoZXMgd2hlbiBJT01NVSBpcyBlbmFibGVkLiBQYXRjaCBhbHJl
YWR5IHN1Ym1pdHRlZC4NCj4gPiAgICAgLSBJc3N1ZSB3YXMgc2VlbiBvbiB4ODYgc2VydmVyIHRv
by4NCj4gPiAyLiBPYnNlcnZlZCB0cmlnZ2VyaW5nIG9mIHNjc2kgZXJyb3IgaGFuZGxlciBvbg0K
PiA+ICAgICBBUk0gc2VydmVyLg0KPiA+ICAgICAtIElzc3VlIG5vdCBvYnNlcnZlZCBvbiB4ODYg
c2VydmVyDQo+IA0KPiBZb3VyIHBvc2l0aW9uIG9uIHRoaXMgaXMgbm90IGNsZWFyIG9uIHRoaXMg
b25lLg0KPiANCj4gIEZyb20gYW4gZWFybGllciBtYWlsIFswXSBJIGdvdCB0aGUgaW1wcmVzc2lv
biB0aGF0IHlvdSB0ZXN0ZWQgb24gYW4gYXJtDQo+IHBsYXRmb3JtIOKAkyBkaWQgeW91Pw0KDQpZ
ZXMsIHdpdGggcmVzcGVjdCB0byBteSBwcmV2aW91cyBtYWlsIHVwZGF0ZSwgYXQgdGhhdCB0aW1l
IGdvdCB0aGUgY2hhbmNlIHRvDQpsb2FkIHRoZSBkcml2ZXIgb24gQVJNIHNlcnZlci9lbmNsb3N1
cmUgY29ubmVjdGVkIGluIG9uZSBvZiBvdXIgdGVzdGVyJ3MgDQphcm0gc2VydmVyIGFmdGVyIGF0
dGFjaGluZyB0aGUgY29udHJvbGxlciBjYXJkLg0KVGhlcmUgdGhpcyBlcnJvciBoYW5kbGluZyBp
c3N1ZSB3YXMgb2JzZXJ2ZWQuDQoNClRoZSBjYXJkL2RyaXZlciB3YXMgbmV2ZXIgdGVzdGVkIG9y
IHZhbGlkYXRlZCBvbiBBUk0gc2VydmVyIGJlZm9yZSwNCndhcyBjdXJpb3VzIHRvIHNlZSB0aGUg
YmVoYXZpb3IgZm9yIHRoZSBmaXJzdCB0aW1lLiBXaGVyZWFzIGRyaXZlcg0KbG9hZHMgc21vb3Ro
bHkgb24geDg2IHNlcnZlci4NCg0KQ3VycmVudGx5IGJ1c3kgd2l0aCBzb21lIG90aGVyIGlzc3Vl
cywgZGVidWdnaW5nIG9uIEFSTSBzZXJ2ZXIgaXMgbm90DQpwbGFubmVkIGZvciBub3cuDQoNCj4g
DQo+IEkganVzdCBkb24ndCBrbm93IGZvciBjZXJ0YWluIHRoYXQgdGhpcyBpcyBhIGNhcmQgaXNz
dWUgb3IgYW4gaXNzdWUgd2l0aCB0aGUNCj4gZHJpdmVyIGlzc3VlIG9yIGJvdGguIEkgaGF2ZSBh
IHN0cm9uZyBmZWVsaW5nIHRoYXQgaXQgaXMgYSBkcml2ZXIgaXNzdWUuIEFzIEkNCj4gbWVudGlv
bmVkLCB2NC4xMSBzZWVtcyB0byB3b3JrIG11Y2ggYmV0dGVyIHRoYW4gdjUuMTYgLSBvbg0KPiB2
NC4xMSBJIGNhbiBtb3VudCB0aGUgZmlsZXN5c3RlbSBhbmQgY29weSBmaWxlcywgd2hpY2ggaXMg
bm90IHBvc3NpYmxlIG9uIGENCj4gbmV3IGtlcm5lbC4NCj4gDQo+IElJUkMgSSBkaWQgdXNlIHRo
aXMgc2FtZSBjYXJkIG9uIGFuIHg4NiBwbGF0Zm9ybSBzb21lIHRpbWUgYW5kIGl0IHdvcmtlZCBv
aywNCj4gYnV0IEkgY2FuJ3QgYmUgY2VydGFpbi4gQW5kIGl0J3MgcmVhbGx5IHBhaW5mdWwgZm9y
IG1lIHRvIHN3YXAgdGhlIGNhcmQgdG8gYW4geDg2DQo+IG1hY2hpbmUgdG8gdGVzdC4NCj4gDQo+
ID4gMy4gbWF4Y3B1cz0xIG9uIGNvbW1hbmRsaW5lIGNyYXNoZXMgZHVyaW5nIGJvb3R1cC4NCj4g
PiAgICAgSXNzdWUgd2l0aCA4MDA4LzgwMDkgY29udHJvbGxlci4gUGF0Y2ggY3JlYXRlZC4NCj4g
PiAgICAgLSBJc3N1ZSBpbXBhY3RzIHg4NiB0b28gYmFzZWQgb24gdGhlIGNvZGUuDQo+ID4gNC4g
IkkgaGF2ZSBmb3VuZCBhbm90aGVyIGlzc3VlLiBUaGVyZSBpcyBhIHBvdGVudGlhbA0KPiA+ICAg
ICB1c2UtYWZ0ZXItZnJlZSBpbiBwbTgwMDFfdGFza19leGVjKCk6Iiwgd2hlcmUgd2UNCj4gPiAg
ICAgbW9kaWZ5IHRhc2sgc3RhdGUgcG9zdCB0YXNrIGRpc3BhdGNoIHRvIGhhcmR3YXJlDQo+ID4g
ICAgIC0gR2VuZXJpYyBjb2RlLiBJbXBhY3Qgb24gYWxsIHBsYXRmb3JtIHg4NiBhbmQgQVJNLg0K
PiA+DQo+ID4gTGV0IHVzIGtub3cgaWYgYW55IG90aGVyIGlzc3VlIG1pc3NlZCBvdXQgdG8gbWVu
dGlvbiBoZXJlIG9yIGlzc3Vlcw0KPiA+IHRoYXQgaW1wYWN0cyB4ODYgdG9vLg0KPiANCj4gWW91
ciBsaXN0IGxvb2tzIG9rLiBIb3dldmVyIEkgZGlkIGFsc28gbWVudGlvbiB0aGVzZSBsb2dzIHdo
aWNoIEkgc2F3IG9uIG15DQo+IGFybSBtYWNoaW5lOg0KPiANCj4gWyAgIDEyLjE2MDYzMV0gc2Fz
OiB0YXJnZXQgcHJvdG8gMHgwIGF0IDUwMGUwMDRhYWFhYWFhMWY6MHgxMCBub3QgaGFuZGxlZA0K
PiBbICAgMTIuMTY3MTgzXSBzYXM6IGV4IDUwMGUwMDRhYWFhYWFhMWYgcGh5MTYgZmFpbGVkIHRv
IGRpc2NvdmVyDQo+IA0KPiBUaGV5IGFyZSByZWQgZmxhZ3MsIGFuZCBtYXkgYmUgcmVsYXRlZCB0
byAyLCBhYm92ZS4NCj4gDQo+IFRoYW5rcywNCj4gSm9obg0KPiANCj4gWzBdDQo+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LQ0KPiBzY3NpL1BIMFBSMTFNQjUxMTIyRDc2RjQwRTE2NEMz
MUFGRUU1NEVDNzE5QFBIMFBSMTFNQjUxMTIubmFtDQo+IHByZDExLnByb2Qub3V0bG9vay5jb20v
DQoNClRoYW5rcywNCkFqaXNoDQo=
