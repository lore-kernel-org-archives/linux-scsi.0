Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C27C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiGEGor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiGEGoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:44:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D9EAE5D;
        Mon,  4 Jul 2022 23:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlElc8K92j7g1uk3+dSItNlariGeDpmiAyRGjC4HzyXLFjicXnW3rahQZ23a/1EOfT+kNgbKHFHi+D9KOW5NvAFj9zM3tn5kuRbxGSsiR+9vzwbEtRy0h96tM3pp939dzt9E79+1ZttuBIEUTR4Cp0dPLqgoc5DvXmLVzZ194eIaGJae+zzy1ka30wcDQK/4wPDbwRfIdvk/fBGc7P8NjcbqsWxIlq/S5QprzfzFDXMsAYRIj1pfxpEeLsQCSLZ0ohMoLE44v5d4V1BFvaFwgNSblcZFAMZdBJ0dMgx68zHmzSqbBqnmq3zZRpgjV0v8v4LiuEN22H4F22nlMtIsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PbzGqhxHIOWD4ggYtOIygveOHKVqKZp75S16MfNepk=;
 b=GsuDXOv3F5bZb+ZbmBgrZIj3ouvchorY/w4JEsxqT0pXkStwqmJdrdewwBZw+OyLQQeh5eEKRITtjZWz+RjIdTfpxoRW+q6l+tHlFyG2uo/AcPOv/ClXqBgzDg2tVAXIS4FXB1dkDKzFWXI7ZiRah6OqfkfkT+grnsovx59T94dqcQsJAImz0YseYe/uRnbslWkVQ9J9+hIrt/SS+V+t6Wz0rOOixqpntLg6H4l8Vzky9fY2kdELH2Uf6sbWNC4Bnp6f2tBk+gw5yZqGgJNuKlJO1KJpL6ZWGgWA7pK4U0HFFkZxfAsYYHXVJdBEiHPYDhWhmTwfDXkWEe1sRIjfNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PbzGqhxHIOWD4ggYtOIygveOHKVqKZp75S16MfNepk=;
 b=dq4tcLh9XrGfgWZF2vtabsTziVF3e81h9zBvqKaVRo4/2WHzCDuep2dT9f9+bqMrfoy4bTuAjcv5vBYp14Q4m6m8waB6tF1qlLkv+Iiy7MTfNHK8CKCjLpPu0CqYCu0oC5mSNSbA0pzGkRDsAITpYoj3DegfaTUqauiI+WINAlRpHGILxAGgN+QORHohRluFlReeWkixm7tuIx1U3GvrxSTwJsFnyttzcdd/M6O5ffjYqwRCSkmAZPmlDm22a6zNqP5ha6iH8Y6g6fzeUmbDj/TQqmHlbuBLO8tZVYcNDHfZS85ReJ0YnLkPeGXZgys/WfBAnfZ/R43dyUdOswAbhw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:44:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:44:43 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 17/17] block: move zone related fields to struct gendisk
Thread-Topic: [PATCH 17/17] block: move zone related fields to struct gendisk
Thread-Index: AQHYj6QRGzRPu2/7Z06qocsraRie/61vViSA
Date:   Tue, 5 Jul 2022 06:44:43 +0000
Message-ID: <b57984f5-4a9e-3fc1-ca6d-ae9987250780@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-18-hch@lst.de>
In-Reply-To: <20220704124500.155247-18-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e97e9a79-f062-43e4-ade7-08da5e51d830
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2UwKVUpB72RqKXz5y7E4+pKzwc6tc7D/htlYxdwRivtmDY1pse/AuM9MTyxHXo+kzCIvuhNLMqNUhIvjNAOqDfsXdMd0pWTgwM0SFgQWgW77RAe1lG2IGr4zQhBec0c4L8ow1ChR4YVXhikWsFH9IN7oIdPX0YuNmyiDXP6Nto+/9UmGroqxrSAumQl1DykDva1bxn7guGXZHeRiTNakgppeHDTP9+KnrGdyWwpyUszZNz4L/owEjIxVukN7Tqu8KP7APuadvnhmK4ypeh2JBwK26UB792xPGFFEJv3y77SWMFMf9QUC4WNXfdao9yAC+kcDpBLasdFB3SY929NwK+0C7yu+6tWzrNy2WXZjY33e6fPzuVhtd3GaU14mDWSQNPCZklsnztXBpTTRRcBKqgF/p14DzwuON7rJz5Gd0u8uEX45eogdgQ5FdOZFlPpp94K/if4MylNAeKeP9vZ9rn1FuCYQIYtu9NC97WMumC2tBlPXJ4qAAtOB7jZhO/JrgZrp/BahUpsMJ5/YM+6EZFblwsGP5xsSbDEJTkNeEC7H9eiBL27ZrlP+jWoWT2RwMTtEONygz1XyHOMOZamfsZqwzmACrJ9G/Xeo2UuW5ULQDCo3fIQpJphnYL4J6Wg2bnXwJBXeGGBt01rQiM+/bFdDAsroNjrpHTYWQ9KVSUy1GOnYcD4WZsJOzT+yln0DQMG3qEAlh1o/QC4LhvuesN0i3xjo+Pd0U1APTRuB0owUxdz6tvdNvVaL9ILtoxoX+4RInyahfXCtJ5ump57CXuhIrUKMYA80op1zEsz0Ghfv3/0VbsX9IhhP0DFJQkMNPeHh3KF9vaLA5ILXpwRH1I7s/jt4aqrZcOv9KQZnNk3doWpgp9/M2XLJXBBCmVIV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(36756003)(4744005)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(83380400001)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTA2UFNEVDlKTDRtY0dGRE5xMXJ1SFdqcmxNTlNjcWZURWFsSC93K2EzbTIw?=
 =?utf-8?B?NVFMUzBEajdoczluaDUvNE8yT0lRU2I4NjYva3FKc04vL01MVHNyeVVlVFNI?=
 =?utf-8?B?TW1hNDNJRVZzTTNaUFp2cW5uOXhtcVI0ZkJvOVdqbG9BTGlKcFM3M1ZQZHFZ?=
 =?utf-8?B?WXQrQW9tczZwK3J5dUpqZThWczg3TlVlUUd6S3kwQkZmcm1TVnE2OHM4bFQw?=
 =?utf-8?B?dStLVkY4MlRHYlZBOGUxNXluZ0s2OGpPTTFETFRGK3g3cVY5OStwczR1MExV?=
 =?utf-8?B?QkMrdU42ekRsQjRGdFRqUncxeDhzbXRMczlCSEFPVmtjRzdTRmhleVZzNHRa?=
 =?utf-8?B?bzhubU9oQ3RVWm83anJLNnV2a3FNdkRab2lrK2JIZHNTMnBYS0daZEFmYXF6?=
 =?utf-8?B?RXIyblllbmEyM0lKREcxaWFINGd6UnR0TlIzT08vVFU5NHY0OEsvZ1gyR2du?=
 =?utf-8?B?QTBpRWRrRzFYeFVqU2dDdlB6NzBpUHl3M2FVMHJQbENCQ0d3bisxcUZabXB3?=
 =?utf-8?B?UHppS3lCRmpYYUJmVHFpM3E5UHc0aU5xWmZqZjRQWkMvZTRBY09tOHV2ZVFB?=
 =?utf-8?B?alovK044alNwNG5zUSt3Ukord0JNaVh6NnNHOUpCRlJPSWxoTE1JRWhqMWx2?=
 =?utf-8?B?ZkF5T3NBTDJuTHBYcmdSTmk3eVJyT0tEb1RtYnhWQmFPcElrdk5jQ1hWMHRN?=
 =?utf-8?B?N0YvVG5td0ZuYUdaT1dpNzcrQW5hK2dqVkpVTnRRM2pPbDlWMkYxMXNkL0hy?=
 =?utf-8?B?TW5JTWZmaGh3blo4T0NzWEVtUSsxcmhOUW5yL2VZbEV0ZFBGY09ON1pNNHo3?=
 =?utf-8?B?anVualBDalBqQjJYMUNDeGI2Q2gwaER3UzlIcHVOSGNERkNaVCtqY3YxSkY0?=
 =?utf-8?B?V1NTRDh3L0E5S1NIL1ZtYzYwMWhHZ21mdGhxRnRPRVZJbTdjcXZiUDNGTjB0?=
 =?utf-8?B?eFhlczEzZ0x5L1VFeHBlaG9ra3JBVXE1NVBqZEdqUGxYTVZ0MnBiNnhUTGRX?=
 =?utf-8?B?bjYySUdEUWhMaFBJTitIU1pvVmkzUjQyTnM5UW9Wa25uTHNweS9ZSnQzWkc3?=
 =?utf-8?B?dmJtWHFWcGkwRjdwTFlXNHZ1ejc5RCtPNnNtSU91OTFvWmFaMHlsdldWWk9W?=
 =?utf-8?B?WEZld3pVWTJ6eVBnMlJlaEt2MDZVMFkyVkMrVmVmd3pjamlxUG10RFp3ZzQ3?=
 =?utf-8?B?UjhZdXNYRjg2UGg3WTFONjZhS3NaOW9xeXJMV2U3ZTBCREdrSVpVUVJjVkpY?=
 =?utf-8?B?VWEzb1laNlludW5aRFI0ZWJJczFlamdtVy80TDE3R2tyWWdkV0VBVG1GcmpG?=
 =?utf-8?B?bmNsbDRDbytTdlZTd1pkTFJGSVIvN0haMFQ5THJaK2pzczBrSk0yb2U1ajB3?=
 =?utf-8?B?L0t3OTlNbkdINFBNc211RlJlMTMxM0JkVlB3VjNNR3JEdE9ZUzRjUGZJU2FV?=
 =?utf-8?B?SnA3K1RIekd6Y2hZY1N0UUltU2VaUWpOOUtobm8wNm41R1ZoU2RHRXU3OVhQ?=
 =?utf-8?B?T0RWMEJpSmJZR0t3WkFyTFJzdnkyZUNIcVladDByaC9lbTcyL1NhWVpnYUJn?=
 =?utf-8?B?VVlqSmFBMmZldDhwMndGS0dqaG1xZUx3TTJZM1RDZFoyNVFmRWlCU2pPQjhX?=
 =?utf-8?B?KzRNK3VSbUN3cFJjejNyd21lM2FUTUFucnJOdk9RVEoycnlaK2l2cm1lWUtC?=
 =?utf-8?B?eWZxN2g0NVBKbmgrMmV5VU91bzd0dmI2Q0JydnQ5dGtjU05EUUs3THQ2a3RO?=
 =?utf-8?B?ZkhRaWI1Mkl5M3ZqQ2EreWtTT0ZCNzBTS3FFaHJHaytRUUNaeDhHYnN1MER5?=
 =?utf-8?B?b291Q2NhaDRNQ1NrV3FVWFpqQWpNS2RMdUhnMXVnMG5WVVkxYnZiaktFOGVE?=
 =?utf-8?B?cUFEMkU0ZEkwWEpnTWRvQUJUYXdMQkx6SzUvN2syZ014VkJKamFkSWllTXhH?=
 =?utf-8?B?TXBUaXZobWhtUWlCajZXbm9Pdld4QVhvcENWS0o1dUF1Q29sTjRkM0xGU25r?=
 =?utf-8?B?OEJUT2JvYzdBczh3VnlsWUJDbThuMlpxTWg3eC9iTDVpaW5EQUdSK2h0bTAv?=
 =?utf-8?B?ZzBoUUY4ZUtnQUJ1d3c2bk0yWFFQSnVQaUlOWWZnK1pkbWJlWHdqanpwUTBP?=
 =?utf-8?B?eTQ2aEJaRWMvSGNEc1RUVVhYU2NZeUltYkxrK2tYRFFJRW1DU0hsYVRXTVR5?=
 =?utf-8?Q?wikokQVForj7safWR/I11j08QW2SeYOFQcMQUbI/wsSy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4869BC309565142979971D7337C8046@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97e9a79-f062-43e4-ade7-08da5e51d830
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:44:43.8152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yLDLVkNE6ALTDlfmUROpYjTxndWy6boY2eiB0idWZ7UPAdbI7zkUoecNYqrvAjfAzNQ+dAauP7uI5tZcMxMZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NSBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE1vdmUgdGhl
IHpvbmUgcmVsYXRlZCBmaWVsZHMgdGhhdCBhcmUgY3VycmVudGx5IHN0b3JlZCBpbg0KPiBzdHJ1
Y3QgcmVxdWVzdF9xdWV1ZSB0byBzdHJ1Y3QgZ2VuZGlzayBhcyB0aGVzZSBhcmUgcGFydCBvZiB0
aGUgaGlnaGxldmVsDQo+IGJsb2NrIGxheWVyIEFQSSBhbmQgYXJlIG9ubHkgdXNlZCBmb3Igbm9u
LXBhc3N0aHJvdWdoIEkvTyB0aGF0IHJlcXVpcmVzDQo+IHRoZSBnZW5kaXNrLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQoNClJl
dmlld2VkLWJ5IDogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoN
Cg0KDQo=
