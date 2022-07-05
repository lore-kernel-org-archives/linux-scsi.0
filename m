Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164B3C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiGEGXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGEGXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:23:23 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25921F0;
        Mon,  4 Jul 2022 23:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzAGmHrh/Ndd63GtGEVefDYeRmyeQb1FfgRy4fH7uofzld1g80eS8UK6457jvkVKhKaA75DdUQ48Zk/+whAi6u/JKccJAvwO8trTZe9yIUlkQemZaXK909iDeU0j17C2WlRymcWCIsbs1jxWCDfmPp3Zo5WEm60Ls6l7xXCyeWxtXZrMBwx+qOGyRpjfuMmag8h2tEoj/J/iJfoUjqd64P8XLjOZ3S1zUh4hCrCalL3+hSQUuGj1PPpw1eUjVjhEDh1h/JL/AStCWYQQ3uAfltyYfaL49jd9cBbBPX1dAFp77z54ciWvhFLKGWNyJ4objYY+Evz5OwnUR5idJntrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cx8pBjvCSNd4wvLo6WfM2GiRjkpHC68r8UtX1jf/bw=;
 b=P/Roc7mUl8Gb7Touw8uPCBG4RiaoLrUu5oyNRjXSIT3VzSldq4YebW7mj7ka7CfEWRKmjqcphsgcbTPxUWlg/2A3b8kHCx0IT2+VWaJ1moMV002GLzo/i3T4X+hB0UZm4J4aJDPiCLAAUB9pOInHeKfwBQY8EcOmzM9mDfz9K1/m0O1HifNSOZkWQWTZZHWQtbZbAew/xoyZJQod8ahvkQSHERs70RQw9wxOOdlzy7yKfroPdRHQIPEGX8vTv4b+btxrPRdqZzm6CNNHwqdVkoezwCHKkJQg1rolM+95hlXtqfVO1sqhTSmfOu3Ho6Uq4duTWxwD6RXewU1LHAjxoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cx8pBjvCSNd4wvLo6WfM2GiRjkpHC68r8UtX1jf/bw=;
 b=g7t0FjW0yJDZv7xfxT1Ip2ZWKOSd9kmKqmkiAI/+d9BKoJtKSjROR4kf0vON8Syrim8zKf3S9M94PzawN+Ay7qmLjkNRjXdEi2Bwws7cXS755kE4cGhrSthKcWwVzjqJGWAl+BzshQXNg0obl3fXraZS3NyET/2a+oTXD5ekJGDFEIuGDxmJr8WRPoNaWy0TfHKF8aNzRi6lmfuuZ6r3x9/ZP5pb0RUAaGagPkqF7GRHLIOU5foR7WRwLrG7KUDkw6u51eRRg/NgwUiKdj92mNZaube5ax8xf7Kju/3JL663tSBbXhQTjljIw3KDRL0SFDekkpmEh7d9O9CjbCP6tw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:23:19 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:23:19 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 02/17] block: call blk_queue_free_zone_bitmaps from
 disk_release
Thread-Topic: [PATCH 02/17] block: call blk_queue_free_zone_bitmaps from
 disk_release
Thread-Index: AQHYj6PtM+gQ+/kDg06GOymLpmqeQq1vUCkA
Date:   Tue, 5 Jul 2022 06:23:19 +0000
Message-ID: <48dfd9a9-ea31-a783-0153-f989e9e47384@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-3-hch@lst.de>
In-Reply-To: <20220704124500.155247-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddc8a980-75c4-4728-4bb5-08da5e4eda6d
x-ms-traffictypediagnostic: MW3PR12MB4523:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4Xv7034Le7j9qb7fepXEz8lWvQhXbUd2FuprmjdnuLd8obIYVl6BCOc7lbkb5V0O+FZ7JLIc8FyxjGZyhaNqxfJpoJ7/pnQLttHhhOJ5/6tsSgl6uwn1e5YmLf+UfTt9Ohhx/fAILo6Mp/YzlaQ+iWJYGZwx543xNaF9znQzidZPne24CNELgHYNal5uuNTrNmeiQadit55zvQOX5ZaQ4hlFxwzVQ3x71PmBFPQ/JjHNLRJHKmgGbgip1ykS0Ex83Jxu0owlVBiJUUeEWhnuL97Ceb8EFBTtiVjLAwxGmVWlu1fQwPwjP6qO3bkw3zpq/t+0Qe+ib8A6gpe1VZDXl9NlKfmuaFLefSQ6FSngLU72ZpEZoI5KorA9qHy8WDsm+ljC2aZjXM6DVrYP82jJL2fW2xPObZ2rdJILuT73ENxem77VvO0J+WOAmHZPV9/KBJWsc3Q+BMLof7lf4misx7YL0CDRrnfvkM4I2OfrgubDzX2wSGn4iBIWo1LVm/RzmsPwZyrDHhMxxCKWr4NUgV5cJnUTP+S4TZ5HiC85QxU3F2/+ATm036JdTJQOeRg1JR1oPMAEA9q1brZw5j2H3IxL1t2smPLi/4fQQBVTq6VGuDPh0s+tGKVgoXtsx4zAHiyikA3flgC488DGMFpSBkWjKEC5l1YTMfCYIXTbvCsGWq+NtuEKy4T5epoLIp2LWUuofl6i2ug0J3Xsy1fcOX0O2BItKYkQtUJh+WPJiJ/gWHmQHZuevWe9tOjFPxArMVHuVexvcorbXY7NltE3VfoPqFs7L1GiTOWwOFCu06mgPn5EMDWdXCXPhuCrjdFbQq0lQFFr0fLwJvGGpbdsEk05Y1kySOK/CMNW173sbBKV7ghzRC3Fs1FJDuGlv6f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6486002)(91956017)(76116006)(110136005)(31686004)(8936002)(54906003)(66446008)(66946007)(8676002)(66476007)(71200400001)(66556008)(36756003)(64756008)(5660300002)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(2616005)(41300700001)(186003)(53546011)(31696002)(86362001)(122000001)(38070700005)(558084003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVqeGRxVjYrbmdBM3FoYWhtelhYWEdwN0RXUU5WZ3VFemdxUGJGSDNaY2ZF?=
 =?utf-8?B?N3hSamJ4YnBxdVdRSDVTMjkxU0xrQTNLZ2llU0hJd0NVYTJYY1RJZEcxTjZC?=
 =?utf-8?B?c2NTK2lBY21ZTUJCV1pNNmgzRHZlemptc1N2TXcxakhNZ0JlTVhjRDcrRDB6?=
 =?utf-8?B?RUlqY1VlOFJTalNCOEhTZWR5ZkJKSC8xYnByWjFVNFkzWXdFcEt3enBhTkwv?=
 =?utf-8?B?RHY1dm5VRkFGRGgwbkpYU0V2RDJyTVpiOFRTMXl2SmRHL1Z6NUNHWWFCUE5p?=
 =?utf-8?B?Q2IxUkJ2VFQ2NVhNM0lSaklmSWMvNXJhS2crSThjN0tORXFZUm9MdzVWTWt2?=
 =?utf-8?B?QmFhL1hGajBNaEtsZGg3Y09zUmRpNVdHeWJ4U1FmY2xpdU40Z0xiNTJTdkpJ?=
 =?utf-8?B?VjdGbG1GMVVpS2w2Zy9iMlR5aGNDYVBHT1A0b1ZneUUrR3o3cHp6WVN4aEE1?=
 =?utf-8?B?TEdTWUw5R0dvSmlVd1lsY3VoaXVra1RmS2lmMk5vU1RRZGhNam8yVzBWLzM4?=
 =?utf-8?B?R3NTWnJTSGNDTjZ3anFuK09sZVYrcmVJRGIvKzF0RUowNzVGUlZHWXNjUThL?=
 =?utf-8?B?M2dmcHBnNU9kbzB4dmR6Q2ltZGhZdCt4cWo1R1N1dEQ0MlJRRllqVkp6UGdz?=
 =?utf-8?B?NU9pQmQ3YkxKQmNHK2xQQklFZVY3R0V1dndUUXF3M0dFQXg5RWVyYjFWU29n?=
 =?utf-8?B?ZXZ3MkMvR292cTgzTE9LSU1tY2oyaTRHU21nZ0ttZUlmZUt2NjVPWWJ3K3dw?=
 =?utf-8?B?aEk2WVdESEpXTExpcWhSRllPRnFZYlduaU9BRk05YnhzSGlFMElsR1RKV3kx?=
 =?utf-8?B?ZXhMNzQ2Z2ZtMmZ6eDB3T1FWMlVuSEg1OHduL1doYzdjQkpTUTNUVUV5TmFy?=
 =?utf-8?B?dlFpSjJwT1g0ckFwVnJ1V2RXbjl2RXcyZ29ZcU1od05wZmJJRk9VQklCL3J0?=
 =?utf-8?B?dXVYT3J2a3V0VUx2cDJZYWthSnJyYnNHN1g0UW5MaDNhM0hGc2lRQWhWRW9Z?=
 =?utf-8?B?ODFDVDk1R2p6MHZtUTZtRGx5bU9NTEp6a2ZnMTltWGsya0RXbEtCTGNjazli?=
 =?utf-8?B?RGhVWmlIMXptN0lDRDJWbXhKQzNrWkFFNi8vS0VCYzBVemJLWXkySC9ydytr?=
 =?utf-8?B?VTZ5eFhKTnJQR3pvd3VJSUtvL0hFcDZpOFJ3eCtJdHIyZUtsbk1UZWlwbzZu?=
 =?utf-8?B?OE4rK0NiU2dhdGlDNEhJbi9FQnJoSjYvOVM4dG5tSFJXdXV2NVJDTUZWUzUz?=
 =?utf-8?B?MXBoVFdkenZyblBGZkFVUmFUZmJCL25ReWh0V0lNb0JYR2xteEpkRzdITkh4?=
 =?utf-8?B?UFpJanJiV3BjOG9oNG4rWGU1NmJWTC8zWFJVb0Z3Mlg2Ti95UnF5VlRSdnZh?=
 =?utf-8?B?RHJma0tja2xkeVlJUW1Na2xPdXNDTkZPT3FlQ2FlTEFLRUk3RFNNZm8zbFRJ?=
 =?utf-8?B?dHlEZm4yK2c3K09mU09hME0rL1NISWVxdnoyMVQzVk0zQVVQTlA1dnBhRlhV?=
 =?utf-8?B?bEFQWlVpckNTRUdsZDJpaUIyTDNFTGQ1SHdGMFBTdUNmK3lBTUJ3bm8yNmlu?=
 =?utf-8?B?TVRhOS9TWVh6eXpsMjRMeUFPMXhaN3BXcmFnUDNyMU9BKzA0NjFXNVlWb3ZE?=
 =?utf-8?B?VGthbEQyZnpVOC94cnR4VDhqbTV4SG41a3RUZjlESmFpMFN5WmpYRG1VRnRR?=
 =?utf-8?B?R0JpWFpLM2RKV0NBb1duVFQ1VXBNNEkzWU41UTlybFBpbit2V2kyOXUzRkxZ?=
 =?utf-8?B?NTVUZHdaMGpSUjdnWWtxTDFtdWRpcHM3NEFnYndIMDBrWXUwN2tiQ2J5Wjhp?=
 =?utf-8?B?b1ZKemxFU01SWHY4R1hMdmwvU29xeWdNSExUeStEM2w2ZlgvWmtIck13dTJI?=
 =?utf-8?B?NmFQNXdjVWpEdnpCYkErOGRYNmpzTU80MVVDVkZOb3hsK3pzT2NoZmlucmVh?=
 =?utf-8?B?dUFXRFpDMHFGT1lXZmZBc08vT3lhZW5GVjBvSTdtVTZTZVIrYytvcVBzVGpx?=
 =?utf-8?B?elBIYmhpd2x2aytqMVJuN2R6UWY3dk9xUW56OHFXODA4TDNYdElEUGswT3VF?=
 =?utf-8?B?U2NwMExvS0s4eUpRMXZEK0h4NlhzeUF1emppZk1Fb3hOeTI4OGxxQ2JoaUtH?=
 =?utf-8?B?Q0VzdDVKWkc4elR4T2V4SkVEQUwyNjJ3MUFjTEdVVWVtYVA3bFhlTENZL2li?=
 =?utf-8?Q?7tPmq7T50woDIlNoAqEwrSHSrlBOJd+u5PxBEYcJSVoB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47E3B745C5D0E34D93AFD5645399256C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc8a980-75c4-4728-4bb5-08da5e4eda6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:23:19.0933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fDyeLeTjyZSTB5qP7/RbwlwkRvD5d+1aA17MUnGMTJkpO6NpkOmO9+L2dSQSGtv3Hq4ktEPNXp4OGE1P50UJtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZSB6b25l
IGJpdG1hcHMgYXJlIG9ubHkgdXNlZCBmb3Igbm9uLXBhc3N0aHJvdWdoIEkvTywgc28gZnJlZSB0
aGVtIGFzDQo+IHNvb24gYXMgdGhlIGRpc2sgaXMgcmVsZWFzZWQuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCg0KUmV2aWV3ZWQt
YnkgOiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
