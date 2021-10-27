Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF01C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEFD661078
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhJ0AGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:06:54 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:50904
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhJ0AGx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZfkhxSn/ASSsWiNoGrPrXo5EaCjb8Yw0U8yyMFOsEYOCLJW8SgPMzh13wPGp4UOWgk1xqKIQAtmA7CDVhnW5VYxoOREIGPeVRPDSCCARUsMvwHKu3coqluM6J8VAYoDjzDPyhpOGFLzGqLHzH25xz0GHs9MxbwXg+70TYC3EEogbca28s3cIqzx2Y55UtE95zQULYwm2KbjJ1AbD4uqbEJiGtt3c29Rlj+Tk2Ad3ixoI1mxvO8VwODyhbqlX/cojqBD681digiV0rwAqwFbZrvTyup1YDoWZ6AfIbdgbu875EeudI5buITT7rGMKxojWS2hCGu6GSlnhCChy3RHKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEw0UNPi91BCxbPdSUDdZw0fOMxMZjBtuOJ6C+c1fis=;
 b=Tsi3kUhK7j8HR8vyhwYkMDvgzWypqJj7Ty5M+ksWdb3ocSjdKIgA46FufUnH5ROF9/cEBZQZKZ8FNfh3zRnAzfBR5UuA22/fjC8hzO8+/2ab0a1LspTDqLj0wE54+7cQZByFg/zHScfqbTxo/Fb0a9sk+k+DEPZx1AKE4W6SAv6YyDmPuha0GHHBJqgY3/TMqyekucrUj2e9lUQEw+B+cFH96IjevgOQ2C/gZHUg52YnZ57HWYZutoFJULMBJuJsw3Tebdhc1BlnxADmhQHjvpaRYhtYiCTWs2DiUKcWhiVwfuEgvSVLa1n3gMY+dRCLEnRNPgjF2f5k4XetpEO4Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEw0UNPi91BCxbPdSUDdZw0fOMxMZjBtuOJ6C+c1fis=;
 b=VY/65j+kwirXDn9SiSxO1Ip5ar2wyP+hmFW7HqZtMzNUf+OPd6CrdBBahaVM7r7K2I+FfaST1SOko4ftoJYEJBl/50o/GJU/NsBwnPqO/omnU/Ox7Flx5RqzQjoH7niXBEeRvMB2JYVsHOG7ihzh7HfXOB5wTS/4VVGgbN82mGT4Be5tBsvwkBQ0LWqN/Bht5EfwEBPhH/oukbjPFAjYPhItlK1btXyYFJ+cWQue/HEPfSA04mgqEGe71dc7HCng6JEQL0pT2gw8aWYUJKq7FauJuvV0f4Fhrt6aqK/qPJ1CSHgJKZ/czoK96i2PV//4aWD9jNPQNhG29SxxzkwDTw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:04:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:04:26 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 09/12] block: move blk_account_io_{start,done} to blk-mq.c
Thread-Topic: [PATCH 09/12] block: move blk_account_io_{start,done} to
 blk-mq.c
Thread-Index: AQHXyW7CGQyjE4EXKUmNf0dX9gc9Aavl+YsA
Date:   Wed, 27 Oct 2021 00:04:26 +0000
Message-ID: <4b45ff4f-4514-fd25-5f7c-aa99ddeb505a@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-10-hch@lst.de>
In-Reply-To: <20211025070517.1548584-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c62758b0-b53d-4d10-79b4-08d998dd5746
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB0016BE093CD42311CC36FF65A3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:357;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hg3OJOjupti4CQFefz5kmlmIiwLMyuYmPnPh4jGVvHQIg6Awp5H/HBYhbdhUMN2AhrCtLCLFWHkWrh+EG8sZPvuQvh69yfER6X3PD8kXIzCKyNDGRx9Q6uUiK/crHuiWZkS8bpAMIlUWgFz/xs+qU3sUfkyFKFSnLg5JBhqpwgK2TtWPSb28wUSn4nSO3GV/RWkrRvr5+IgbdYWgDEO0TtXllcDqXaFjYizfxZVdd6haQsEdzpOJ3WVTkiXrf0VvilX//x+R0TTN3yNqabtzhN6yhia3+PSm+MF3lKod20osua9C5FLab4PzAAhVjEw8VW2tolY+LZtNXeP7bHBc/p57nuTxQ01Ym9AE9/stBskSwd+TxjsLokZuNm10BHLBXe9pTb2EkPkKZGB+wB8Mpn3h5yK+fMD3Gq8Xa8sz49FiDMHqGKOXolK/MKyucfL53ygIXZZEhhRX62VYClThJGwXW6wu6m8zvmjwFmkTCm7p3QmOUuM3HlsTguShMZKqP1LbVkKo8dJAIHWNsocouqNO+OSTN+xrgTh7s/EqqgFf7DwGPW/jLE2mV4Fb7jGZ7XwHNw8h04h9al0R6T7ojE70LjTQWV9RPqCxZlvXXO4W8YRIa0HQgMTaDI19oXPasKOqtL7PfcxkRrQjAaxd77J67OjauTtu5W+x2gWfi+JNeph+nHqnWYh/A9hQe1voFiIiLi2Lsas8nXWt5+9vMVc2nGF43nnjwiYF9nqxsv9ZWIsSjho7nCaD294lpXUiKvoAIstUnTyRk+ib5eDoEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(31696002)(66946007)(66556008)(508600001)(8936002)(83380400001)(6512007)(110136005)(6486002)(36756003)(38070700005)(558084003)(86362001)(64756008)(8676002)(53546011)(6506007)(2616005)(76116006)(54906003)(2906002)(31686004)(71200400001)(66476007)(186003)(38100700002)(122000001)(5660300002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTBFZHBtWHYxZVFkOWY3aVJaV3RlS0lmYUsxZ1IvUFFmNjYvSnQvMlNDL29T?=
 =?utf-8?B?MkdhdnZKRzREZWtWUlI4NWtaZzJiZDZrSnhRdGRJOS9vdWZOaEFzei80anI1?=
 =?utf-8?B?ZVhoMWd4Y2V4bmg5Q1FWdytWUXQ3RllwNVhpQTUvVWZSWGZvTkRUZGo5T0dZ?=
 =?utf-8?B?VDR2TVNJTmxndVNEcnZ4a0lMZW14OWtHSmdEd3lVY29wQUNnb2tubEdJZnBK?=
 =?utf-8?B?TU1EUWRYZ3RzY3FxWExzdXJjSFE3UEFWMFRpekJlc0dkb0syZTJYZ2p1M0Vi?=
 =?utf-8?B?OXlSdHVrQWlXVTFQZ0xkQ2w1RXEwT1NwL3d1S0lhYWtjcGhUNndLdFd3SlNj?=
 =?utf-8?B?djJmSmNPTktvZW9QcEZONDFVcUxrWkx3ZGkwNFozKzR1ZEJUZGEvNkRPNGl1?=
 =?utf-8?B?TlR1ZTZHZUJSZ3FTYUQrOW1pQjAyamk1a09NNzNUZnl1NW8zeUFGSE1nQ3FN?=
 =?utf-8?B?SlAybWc2T2VHamdJTFpOSTVyOHJPazlYVW1HWFhRZVM5cmdFMUtBL0tabFhp?=
 =?utf-8?B?dHNzdmNkbFRoK2Y3OGpZNGFRMXErRk5BMHoxV0hMTFh1SUt1MDlTL1JpNkhC?=
 =?utf-8?B?K0dpM2FZa1p2NDNaRmtGYTRJblNMVkE0cGNlYUFmVSsraWlpYitzYncvTXpt?=
 =?utf-8?B?OE1UMnhVV2FJQyswY2E2QkZXM3RwTDNTSGdTT05LUXBXRVpvSXg2VktWY3Nx?=
 =?utf-8?B?K3BRVTZCNzYwcU9HbmhtQXJ1V3hwRGU5dEZQb1JXUzA4S1g1b0dZV0RuNG5k?=
 =?utf-8?B?STlYS3VYSUJNdHNOb0NNb2pWc0JQUW5PY3c4MHZsZDJBcTJRekw1aHR0UGpy?=
 =?utf-8?B?bjVnbEVuMXdsemgwR0VIWlBvdmhTOWY0eC9MMS9IdE5UVmV3SlhKVHNlNUND?=
 =?utf-8?B?MW9LMks0dXpDVnZhYThudW13Qy9UUEhNd0t1SDdLSklPNGN6dG1tUWU1Vm5K?=
 =?utf-8?B?TGtYZDladEV1dTRsaEd4MG11OWJoZ0g5RU90V05nd3NDNTlHMzBYbkJuWVA2?=
 =?utf-8?B?bnRmbE5hRFJZYTlMNUJCRVZWcEVmd3p4OU9tWmYySFhNZlBGWjZsL0o5WlQr?=
 =?utf-8?B?SHF6SEZPV2FoeGpsZnpxQmZzZWgwOGJSOWVHYXIvMUZJSktyTzYxOW5VUk1m?=
 =?utf-8?B?SUhFcE9OSnRmejhBa29tUmFLMG1hcGJsRjQxZFNacnhqbzJ1ZVhoNmptWTg0?=
 =?utf-8?B?SUw4emRVQStWek9sRktYZlVoQkpxZ2ZCNVhaZDJ5NE9QSWlLL0NDM0U0MkFR?=
 =?utf-8?B?SWNuVTN0TDVWaG9GS3ZDNG41bEJ3d3h2Zyt1ZjVDSGQvOUJRaWk5Wk9JRVVT?=
 =?utf-8?B?UXBWUjV1aGxvcjU5UC9JY2k0NXB4Z3I1ZUtqN3FzK0JFTUd3OTdVYkZiMXFp?=
 =?utf-8?B?STIzcWl2VlZBSDRGd0lCTDU4Yko5WEVWTFNkY1gzMlo2UzZoSW9nQS9ENCtk?=
 =?utf-8?B?L1VKVmFwcFdNdWgzNXZOSExpcHVvZmw2TFREZzJpbHhZRTBXNkdFYmNzN0p4?=
 =?utf-8?B?VTZHY254RHBlZGYvUEhyWDNSZmJJV3phZmxlYnptNXNUODJqN2FUSlpBZi8z?=
 =?utf-8?B?dFFFUmFqN3N5VGw4bHhKdVVHajZHcmVzanV4TmdxcGxpTmp4TzB5TGtaaU9k?=
 =?utf-8?B?QU9jQkVZYnJDUnRKaFJycVhQRnh0WkEwaXlSeEtMNG5keXFwd2RRdHVsNkNy?=
 =?utf-8?B?NGhTMHRBcy8xNm1xQy9jUEJRbGQ2NmNtbEZMMVczZFMyanMxbERCQ25KODNz?=
 =?utf-8?B?T1pWZG1YQzN2ZkpLVnJYa2p3WjFhL0NwS3QzYURXTzBwOUtVZlN3SVJHZlZR?=
 =?utf-8?B?dFcxblM4V2orbXNSU0lnU1ZaNmtNVFJIcUQ5RFlGQmpPc2hYL2Q2N0RjZDZn?=
 =?utf-8?B?T05VNHVaeVpQQzZCd01qczFrVmcwWVlQNWtSSUM0K1BHQmNmWmloZ2VCNlJR?=
 =?utf-8?B?NDhpbDJtL0VUcVlmL0xrbzVRL1NEWjVmQXU4SzZLTElVQ1ZaUzROZkhuQ0lR?=
 =?utf-8?B?NThROEhNOFBzbE0zb1BDYUYxK0pkSDhSREw2dmNNWkNhbURDMC9EcmZCbTJV?=
 =?utf-8?B?VUw2WmVnblBrQVluYmtFSmJpOHd6aElXSkF1K3dtYnZXWFlHRzFMcWprZjFN?=
 =?utf-8?B?ZFovYVErYVBHdEVYYWJRREhEWG5IMkpFVGQ0OVN2dEgrZWJ2amFOc0cxWVlS?=
 =?utf-8?Q?GJFO/Jb/t19nbvyKsb8oocvw0eXj0dIfBxLAlDspeoy/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A53758D8C99C6E46A320BD6DE3A5EA82@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c62758b0-b53d-4d10-79b4-08d998dd5746
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:04:26.4599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: delZYd1LKYbAi6bGRl2KNIAkLwsqrE+i7GUoX8iMkVUIG7N00z5S5wVkpXG2P2iSEled8CMyTxkYNrTUeXTbwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGVzZSBh
cmUgb25seSB1c2VkIGZvciByZXF1ZXN0IGJhc2VkIEkvTywgc28gbW92ZSB0aGVtIHdoZXJlIHRo
ZXkgYXJlDQo+IHVzZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4gLS0tDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQo=
