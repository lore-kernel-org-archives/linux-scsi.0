Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F09C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 07:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A7E64E76
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 07:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBUHZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Feb 2021 02:25:13 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35256 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhBUHZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Feb 2021 02:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613892310; x=1645428310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=40dZNlwic/ewYOUCmV8gkza8Qvtnw1cjd7mVKLKtd4c=;
  b=dupy2JiXu5qebXL8ehFnxWyj3jdDpOr812pIvvRb/SGJbgqy203Fp9a1
   yDoK+x9UnxgJOZyXgn4EukIo2rfH7NESvG/dlPll2QX9gGRmR9LRzfLwU
   LO9QbGJL48dNjvGEymHaI14pE+dPeaMI2J6Csw+pjXp001kuV0NPua4lu
   7W3eRRi0WzpM/JrJOVfUpFlbFPctQBrJMg3InqlxgmonQEqPfZGOBSMOT
   QefX1mqFQSQbrx4P1u2vbuPJyuG4+n+hjw09CWLxb/nC6H9MBpryLu4Dj
   UZiI9x8tOkbQm1HIe4mP1aGkU7r1Jh0IszSCgtwP1qoU+hrxsX249SVP0
   w==;
IronPort-SDR: Del33bx13KRCvHzD+0FhayraLbI4d/i7bS3VSxILezOFMbBk3E2fE3AkIjQa4SplTD2YTd609y
 nTsaZtdYZvQ7HhNhyg9KxYyQqWxX4R5ibJZRcXoPNOmW80NbmGvO2+vltxPXyoX1lTlsNMj+rK
 5GZ2Ra2nZSyOgdQ1uMkSjdaCjlJr1rpwT9fKxcGeD0AWzTzMbv39gCgures3WqR7Cd2nIhOlPi
 g1eSGDhGs56brIBluNylVMrhbTdjVsCHaWNDYL5lKMSSAqpEqGDOodGWwxnlh9c45ZPteJd/ej
 Z1o=
X-IronPort-AV: E=Sophos;i="5.81,194,1610380800"; 
   d="scan'208";a="161603503"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 15:24:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nykIr0EZbjtH86g5kh42kVmux1m1d2q8yWGdbh4HDS6AtLQTdar/NTIaiL/g5YUZwUSa2wb5+7mlCOc85w53lZ4vk4RAuk19cXq4XrJ+mCrUj+cJfVeeaod4U6nnackZt9tkkAg/7Bu687E+YFTU/hVoLLmABYknBITXqpLWBut7SEO8b55eDcTDcLru4Ixz5EtyBJgzv1P05nTRDxnqwWmOzslrlTBLlrrqBJFNJjHJTSXxshAkMzTO+MRZgEuX6rOtJ0G8fEDrLpBNWeH1x9Z4GDq7J2T6FNLLq8O/Z3N/DQaT2q+e7OxAJ+F+0Yg1Wi3Pi2Rp6Aimwv9BgE91hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40dZNlwic/ewYOUCmV8gkza8Qvtnw1cjd7mVKLKtd4c=;
 b=iQ7dm6EidYy8PZmAYmi6Vl2L/hWOgQZkQosSNd7fMktNZSSBbKC6aC+85jegpqBj5F8mla2Jrf0Exbth4u4+3ptFzO4jmUGV24H0C3oGCBx7GeVHqbJ0MZyEAzSmu0WMZMdoIzRdIDQIqlO5WAKzilUeehYT2c/VdRPlllhEars7lzP6RKGGCb+qCHzEOGrrklkKG6NGr6NO5P7LnLujKWcJhsh7cZ2bKszYeiMPsUsNDmdD7syvpTEnvPOCU8/PRrWMPmUukKUL2N76vFi/Xjx5Ejgsq+HxrkOVKUfqyX4qXjcN0TDTTBTAL/+rjU0hXISgtqRcHHan0vSVkyrCpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40dZNlwic/ewYOUCmV8gkza8Qvtnw1cjd7mVKLKtd4c=;
 b=p3oIy0r5xsa7COHu/worLTs2z9DfpBlxwYz35NTY39hMO2BqR8QQ8vk8nMJ//xwl4nvn4AywoF+rWnGPf5uoGr7OeAuD6yu7Bm6gJ8EDGL87mJ8tUPjOjcyEqG4SZxXqg2UvB1fcEN6QSdf+22nXAMLzUrujOKsepJKVPBS6/p8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4025.namprd04.prod.outlook.com (2603:10b6:5:b0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Sun, 21 Feb 2021 07:24:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.032; Sun, 21 Feb 2021
 07:24:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v21 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v21 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHXBdWjVMgNltDfqkOmgWhiUXbEI6piOKFQ
Date:   Sun, 21 Feb 2021 07:24:02 +0000
Message-ID: <DM6PR04MB6575834A026CD5194E7A2EFAFC829@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p2>
 <20210218090824epcms2p2d7edc0c79f0503033c1baf0ebd5e1a23@epcms2p2>
In-Reply-To: <20210218090824epcms2p2d7edc0c79f0503033c1baf0ebd5e1a23@epcms2p2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc0f3303-30fd-485d-1bb6-08d8d639a9e7
x-ms-traffictypediagnostic: DM6PR04MB4025:
x-microsoft-antispam-prvs: <DM6PR04MB4025580629558F612958127AFC829@DM6PR04MB4025.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C33WYdF+m4tGfXZdUn13Q8TJZry+oJMsQ3HawWNXqkwR0rDNsW7CwsMnN2MmlzHzky72De3DUWL/Ixs0daWNE6BelRNtOVRHEoQ2vI/ZGehpMCV8L2xO4QDJhnWrhIwLu69RqJNdAMZ7movlTO6zytwYVPRCDZrAsHmywdl3c7zefZqww0uk3Q56fuwFkoTiAraWrOZ/j4KwhmaD78MNlIorV7negLcIGBvSY6dQ2kJaWQGQhCC0ZAFQ3ma6ybspW/ia5kBnXydBejiZsYn6hfxjN03rjr0IpYwnomEcQ1lwJ6oe3qd0niUcETr8ACbn1HL+/Ma7tAb5AOUVQGqPY9jkzga0KN6up7UzLaSqmj1Bx35RmXRiHfxgRZ9OdZUcsNXZgUg4l+wiwZ588NH41yBL/Jo6+r2gojVu55OdevfbMsRfyR7CGgmuUUArf/BdMZ8YXX0ZwjA3fgZdeaIlSlLqbzyth+wlcEMsH+5I0UFhq2zvhBxgUpooPYcGmleb7lfU0L4cGzJwU0r9uM/DG+xdAuUN2654SMbrSma1ewDTmxzL41HDWpbXVRc1tF6A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(54906003)(4326008)(110136005)(8676002)(316002)(9686003)(64756008)(5660300002)(4744005)(7696005)(52536014)(6506007)(7416002)(921005)(55016002)(186003)(66446008)(71200400001)(26005)(66946007)(66556008)(33656002)(76116006)(66476007)(478600001)(86362001)(2906002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bDlScEpkOGxzZVRKMUg3UHk3NGQvbkVwUDdtalF4cC9iRlpiOHZHTDFwTW1G?=
 =?utf-8?B?V2RaU0Z0RkV5c0NFcVpHSDdCK1R6SzlONWszN1JGRFVjTVlmUCtEY0NEV1BF?=
 =?utf-8?B?MjdveGtieER1NTRQRVhhQ2JpUGJPRXhmVGpNMEMyejNPYm1ET3hLdW5LV1RV?=
 =?utf-8?B?d005VDNsZm5YOWsvOWk0R3FEVHZOT2EySUJRSnJ5RW1ZRWl1ZWNKczBTRFRx?=
 =?utf-8?B?WmJuRzJId2xJMnczUEM3blcvZTYxYzBhVStCZFk0aEdubGF5NHNJOWNWcnRm?=
 =?utf-8?B?SmFlQ3JkdUZJVkJxUlVybXgxUU1MbU1MNktydDRPQlBSSitMQmo5MUpDcjdp?=
 =?utf-8?B?MWo1QjBVQ1lLcjRQdFVURFZEY1ptKzROa2hQRVNubjl6cWZwb1RRZlloZ0VH?=
 =?utf-8?B?cnNKOVlHOXBVeWVOTlhVUk03dkgxci91dE5oNUdvSTBHZ3hmSXRINjFPRW1X?=
 =?utf-8?B?L1BqeEZ0Rk9DaWhPNFBOQXlJb3BMN04yUzZUdTRGTjlaZWFuTmZaQm8yb2Zj?=
 =?utf-8?B?Y3gzaDVuY0kxWlkzTDhpdzN0emk3L3RLejFHZ3hGWFhBVXY1NC9yYVArV3Nx?=
 =?utf-8?B?c0c2VXhIYVBOK3E5VEZaUjZrMGR3ZGRnclFMMkh2ZUFaOE44R3I3VzAxRWI5?=
 =?utf-8?B?dFFkSXk3NnNHc3FzQlFsbXdsUjg5OTRTWGVSR2RsY0tBYzNFYXprZ1pYQ2JN?=
 =?utf-8?B?YnVOSGFKbityaDJuRmR1VC9GbUN0Sm1zVVhIOFdKWlNxVGFaMTRsdlNhZVVK?=
 =?utf-8?B?dytBV1VQSDczTDh6SXI4QkIvKzYxVmhsNXB3eXVLOUlhakkzU0hvaU9YTEN4?=
 =?utf-8?B?aUREZnA5dzJaNTZneGJyQkZCblprWW5kY3l3YWpOZDlYdlc4Sy9wTVc0cW1C?=
 =?utf-8?B?ZnFHTHczUWNnMnFLcmJWZ1Y5eUlib29qMUNENHNObWFnbFlRMEtPOUFkNEYv?=
 =?utf-8?B?Qk0yZUFEL1drRlg2YUZiSXRtYUQxSXBHQVZrTVFLdlFxYUZwSjZJOVdIQzBh?=
 =?utf-8?B?N3N2bEVoRFU0cmlWNHN2UHNzejBIOS8wZ0xlU1VMWmMweElESUY2dHVOQmY4?=
 =?utf-8?B?b3pGQ1I2bTZlZ0dZZ0QySEdzRUlFdDNucVUzVGlFbmcrcG9YNVJUOElDaWZM?=
 =?utf-8?B?TVJLd2d5eVFmNmxTWlJteUV5KzdDZUQxS2FtNjJPL0xkbFhieVFuSjdRcXA0?=
 =?utf-8?B?QXZ3Vmt0UWZBVkdVeDV6Z2Mrb085d3crL0dBZFRxYnJqTDBpcWZpRUhQU0xs?=
 =?utf-8?B?Y0ZJRXJyMExQRmNyQVRUK3dWK0sxbzNWSFhWTW1JaFdTQTFFbnVZc0lOc0VK?=
 =?utf-8?B?ZFloUnF5SEhZN1FmVlgxY09zM0hWbVVjUlRJVytqbmJkZU9zY21yYUNiR3NR?=
 =?utf-8?B?TlJFVjdmNEU3eElSREk0MWY4b2ZtUzRyRkdndFhucDRNS0NuQWxmQ2p4T2JL?=
 =?utf-8?B?ZWFGLzNCelU4eU56emRRb3VrTjZTU2h0akZvV3BtZVA0ajJEL21ZQUpkUS9L?=
 =?utf-8?B?Q25QVUlaKzBpYVAvS3ZtTmtZR0dSWEN4S2VVU0NqdmpkRDBPNEtRU2JoYlNG?=
 =?utf-8?B?REM2Vk5tZ0ZYWHVSS0NLcmVrUEhOV3lyR3FhSFppaUVEVkE4YWJMRXUrQ0xP?=
 =?utf-8?B?QmhEUG1HRkhTQlBLRW5XRDh5VjNFWThVSEQrbHo2SHppQkdxRG1GcENnV2Rw?=
 =?utf-8?B?dXdZanJKb1ZyVkxpaXZDUWFFZW1CUko1aG9EdjI2OE9reXFhV21USFpMY3BN?=
 =?utf-8?Q?0BgvdYyrQppplF3vUY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0f3303-30fd-485d-1bb6-08d8d639a9e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2021 07:24:02.3626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gtUlfoxdjLa4dIi0UHsqTJfhVjj6V2J1Bp37+jaVvCdSEb68LBNDiy7UrFby9IUchUFPwTzZP8J9pddtPk65ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIHU2NCB1ZnNocGJfZ2V0X3BwbihzdHJ1Y3QgdWZzaHBiX2x1ICpocGIsDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHVmc2hwYl9tYXBfY3R4ICptY3R4LCBpbnQg
cG9zLCBpbnQgKmVycm9yKQ0KPiArew0KPiArICAgICAgIHU2NCAqcHBuX3RhYmxlOw0KPiArICAg
ICAgIHN0cnVjdCBwYWdlICpwYWdlOw0KPiArICAgICAgIGludCBpbmRleCwgb2Zmc2V0Ow0KPiAr
DQo+ICsgICAgICAgaW5kZXggPSBwb3MgLyAoUEFHRV9TSVpFIC8gSFBCX0VOVFJZX1NJWkUpOw0K
PiArICAgICAgIG9mZnNldCA9IHBvcyAlIChQQUdFX1NJWkUgLyBIUEJfRU5UUllfU0laRSk7DQo+
ICsNCj4gKyAgICAgICBwYWdlID0gbWN0eC0+bV9wYWdlW2luZGV4XTsNCj4gKyAgICAgICBpZiAo
dW5saWtlbHkoIXBhZ2UpKSB7DQo+ICsgICAgICAgICAgICAgICAqZXJyb3IgPSAtRU5PTUVNOw0K
PiArICAgICAgICAgICAgICAgZGV2X2VycigmaHBiLT5zZGV2X3Vmc19sdS0+c2Rldl9kZXYsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICJlcnJvci4gY2Fubm90IGZpbmQgcGFnZSBpbiBtY3R4
XG4iKTsNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiArICAgICAgIH0NCj4gKw0KPiAr
ICAgICAgIHBwbl90YWJsZSA9IHBhZ2VfYWRkcmVzcyhwYWdlKTsNCj4gKyAgICAgICBpZiAodW5s
aWtlbHkoIXBwbl90YWJsZSkpIHsNCj4gKyAgICAgICAgICAgICAgICplcnJvciA9IC1FTk9NRU07
DQo+ICsgICAgICAgICAgICAgICBkZXZfZXJyKCZocGItPnNkZXZfdWZzX2x1LT5zZGV2X2RldiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgImVycm9yLiBjYW5ub3QgZ2V0IHBwbl90YWJsZVxu
Iik7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gKyAgICAgICB9DQo+ICsNCj4gKyAg
ICAgICByZXR1cm4gcHBuX3RhYmxlW29mZnNldF07DQpIb3cgYWJvdXQgbWVtY3B5IGhlcmUgYXMg
d2VsbD8NClRoaXMgd2F5IGl0IGlzIGNsZWFyIHRoYXQgdGhlIGhvc3QgaXMgbm90IG1hbmlwdWxh
dGluZyB0aGUgcGh5c2ljYWwgYWRkcmVzc2VzIGluIGFueSB3YXksDQpBbmQgeW91IHdvbid0IG5l
ZWQgdG8gaW52ZW50IHRoZSBuZXcgdWZzaHBiX2ZpbGxfcHBuX2Zyb21fcGFnZS4NCg0KVGhhbmtz
LA0KQXZyaQ0KDQo+ICt9DQo+ICsNCg==
