Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7A0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 03:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiCGDRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiCGDRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 22:17:03 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149FE45AEE;
        Sun,  6 Mar 2022 19:16:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qv4L5pdzgrU1ATwkhO1P8Y3SxYmaXBZjWZcvQ1VQsBIBcnPa/lByc2R8EgXQir++PJMYXTCvVIFExsLM5zuSbjDFXFMH+ELIaFrpOxr5fLMi1+qW1wNdfN4eyabJEjK/Jorq19EzzTCA08NqgqkQptxjlByzcmJmcjFe13NhSol1TgUXQfehOb+ugFTnvHG95xyo34Jof7mZdQkTd5KUJSH6nD0JqVUeIPFe6HAYF+BvDriDQRhB4num/pabgt5udlkDp2qUqpZmLRoR2bYIg7jYMTO8gcEcFKvYvXsniNhYWZ+drgAV5n/mApicB2QhCaaA9yXeZq9IYP8NN0AfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7xs/0/LyNEG0gkiYCR6VQXMFW+gXVCdTwiqVAp8tbI=;
 b=ccTofm9UwnezNCZpQFuzAx+E+IhWSvBLhE1zj/WRaUl0fgb3dykCDUPjfTWrPRhvL9PBBv9RWLhYuXIBlrDu4380AXNfGZVV+6971yO3fvJpbbY6nx2fnGNngziTqISKR9B0JnQV37UOjMxXD81KDh/Otej91FNDFWSNg/uNavStpDWS+A5lQd1lrssSwdywwuQtPPlAFMUBZsGkwu9ffD7YHauk5ip+3f+ENQ9VM1nmgOV9aMfVpLtfo5mTiFL29cb+In5DRapmQhMFOKFjvn5ryscGloMYXZ9+/XqzEM5fOnHvngYh8hXeko5ddaRm0P0Qi85QHcSsnCRztuJMXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7xs/0/LyNEG0gkiYCR6VQXMFW+gXVCdTwiqVAp8tbI=;
 b=ASYv0t0dg5dc8rMRgkuxfg+XSOEi9LyVjUV4CcqwMgmA4wGXi13++BmXxAAIWXxrhCxEibGnEE+80FKbIfZG7Cxwa0zP0hRmFQ2LFd3K8dd69HLCCwnX2QiBPgaOtItmpVeJ9cgdPEyr2Wq2s+xHrZ/kJb6hMK4tc7tnLUEEFJGC5gxnCzeekeqJRUpNfQif1fl5aCL/JBD8wyEiFg/HUEZ9r9i/TeejvXdoRO9CMD21AgYgTO9Y/zinoMnUvB3v0woYzYtWL71ZbcFSqaMQO0iknUTc3PZdxYgEQNeT08LBf9jG61win8jpOf9jON7k6kXMxzNrXL00FcHZBDAz3w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:16:07 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:16:07 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Thread-Topic: [PATCH 04/14] sd: rename the scsi_disk.dev field
Thread-Index: AQHYL+F0GXdUtekwq0yG7JdFYA0u06yzQ5yA
Date:   Mon, 7 Mar 2022 03:16:07 +0000
Message-ID: <69c7c931-7dfb-c0db-86f1-28793026791d@nvidia.com>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-5-hch@lst.de>
In-Reply-To: <20220304160331.399757-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8924617b-9fa1-49fc-8270-08d9ffe8d256
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1853474CC4A3E1F08F39BFAFA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UsSARaY75NYSLlrVNIoqNJPqWYGyVkY0CpLbcsrykW2kMXoTE0VSopM+6j2s/9u8zzAJeCDa/7gaYBrZWIqK+UUHyNjI8dHojhPo7Bq0sdN1R0L/Y/R5CQD30062mzhlllE4IDs7XQTSQ+uT96OFc5TBzH9/a0dltJ9kEq3L7nrRIhjc/kgkBhg1LxDqbI3AZ3WKTYrmwiwzTYquHx1Iod87N+5Kc1yoCi5XaKF4ujs8IIeYFoHS9UZSAByOicACsAo/dgnmx/OjhIOc6lVGI8NC1MqvFO3HpFqJZ7ViRKuYQYEu0Wqbb+w5+R5mZ08ZrPDjbvocLIJ+UaWX4cCuzCqzQNoKRGYakoXjWUr/4vGk2oCIPax8U5vJ2UkAp7Eu2bYe8IGkC2wYcRJvcT7F4+W8GbRbxKJbNCekvzjfwQuXoNTPHXWqVEtspcPi7qsiOn5ZfJb8EfSjbBUX9kLrYmHhUR8hs4t6+0oMixFJ4apz3bfiANY1K0vA02TS9iSb+u0zQh4fPg/rDnwugefWw9Q+gjV5ed+K+hEBm2bclJsUymtXc4Ej2JMWQ7xmTOzgdE6xBzChAUAHI4G2AbUG76l5T8TSrh5RxxPENzEr8jzxCiKygztMfIZLec8qS7GcS+ggqd98DWLL2HwR/YBcAH6+6ZwwAOpB7RIWbMSlgVpSFGfFSO9lR4Y9IO5kJnI1iu51ym/Mx2iR5Pjez/1sA40G6BweX8NEH86fetyPb8rkJSG8f037N3NYPbbtehOM5nl+ZDAuPSRcjFaA5h7owg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUwrNk4vVE5nd1RLekxMQ3hpSldnRm9FMGhNbWZaUldGejBCcmxaODJpNUxI?=
 =?utf-8?B?UlhVN0ZyS1FXdFVFYjg3Umkva2lYenVGbkc1WThSN3c3S1k5bDF5dnN2Yi9O?=
 =?utf-8?B?ZlkrWGU4c1ptT3k4QkswY2xtSHR6QzVHdGdYRnNMS0syYzBjbEJOOHhNL0Za?=
 =?utf-8?B?M21ldU5UbjFDOEcvVXVzMjBJUzFvRERHckQrdkN1Zk5lSUQ4TDhNVUFiL0dy?=
 =?utf-8?B?Z0JoSEw5ZFBRMXhPajF3TW12Wmx3d0ZrU29xZFBjYktMdzBaL2RFMDJqNGVt?=
 =?utf-8?B?MkNZL2JJYTAxckhyT1JXN2hXVitiUnBnWEZ3ZUppdFMvVmhBOWRWZmtxazFW?=
 =?utf-8?B?SDRBQWJqY1J2Wk4wM1pETjJrYmYxUGR6bWhDbVpQYmU4RVpXUldwTHBTTDB4?=
 =?utf-8?B?TXRyY0xLYlBtYjMwVGdYVTlma0dMUkhzZ1E2S3RPdmtUenR6d3ZTL0VaUWxO?=
 =?utf-8?B?cDZKYUt2UVFzdVRqOHh0MkcrRUQ4UDRQQjlDQzRXcUJaWjVRaFRPN1kycEgz?=
 =?utf-8?B?cFlXRzVhUkxlVElyamwwVFB0L2ZiR29aWm9OandkNlpreUdabFg3NWF0ZGNo?=
 =?utf-8?B?aVgwYnFYdkFJWEVRZTh4ejRnZ0lVWWJRVWxtbWdjRUU0QWttR1dXQ2ZlM1pa?=
 =?utf-8?B?V1A5dVJIc1dvS1I4blpOS0dvMnFMRmVkK25pek8xUHE5TVhjaHF5MU9BK0JC?=
 =?utf-8?B?VUZDRVB6RndKV1BKYVJsSVJpNmZTUVUxWGxPVFB5VHF1MlN1YVN2bnVFVzMv?=
 =?utf-8?B?ai9PUW16QmRoRDVZZkw4YTlFK0l2ME5TZThOTjNXSTFsbm1hVkR1WHFDZk9Y?=
 =?utf-8?B?M3h6Z1BLaTlhSW80OG1kMit4dGdVb2xEYUkzWTB3bHB5bGYzdFU1Y2xTT2pO?=
 =?utf-8?B?RzBBcXBLa0pCNjlIaW4yTU54d3grUkVzK0Vla01vbEExMmV0L2ZYd2NUb2pW?=
 =?utf-8?B?YTFUYVR4aDJpcXJCY25WcW1BYjBrOGdxRnpuWDRQNzV4M1hjVVV4eXFRL1oz?=
 =?utf-8?B?bGhFbEdFL1RQNnJlOWlNRk8zS0VHRFU5bjYrSXIxRnFkM3UyQ3BQUFVndkVl?=
 =?utf-8?B?Zm14dzBNdUVwcFlKQWUzb1ZaVjdYckl3YXBmNlVLT1RMWURyVjhib2pSWHJM?=
 =?utf-8?B?OURBc0pld3hGMU5kemsyVEVkTjBWeXBzaTQ2NzFJUkF0UEMrNWlRQis2cWkr?=
 =?utf-8?B?bTN0M1lLTEo3MlYydk1yZ1pMbk0xTWUzNkUwbFZOWDFJRzVpQ1YwaThBRHJI?=
 =?utf-8?B?em4xTktFL053MWdvcVM0OEk5alJUeGZ2N1J2YjlvU2Y3RVhUWTlOYkpCaU9R?=
 =?utf-8?B?QzByQnlEbk5WRWVCRTlGd1ZFbnpiMkhnZkdUR2JHamYwVWVYUWtqMDBEbUlL?=
 =?utf-8?B?RGVmSW1HWEw3NTFKT0R2NGY3SlIyaUdGVHdlY0VLNUQ0RDNXUytLTGROQnh5?=
 =?utf-8?B?SkhZZDM3VTBSMllqQzdNZ0pXVnlIRUk1OWkrZlBwVGJrc2dtOWtlUVh2bzZE?=
 =?utf-8?B?anY0dk1vY2JDOXNWa29mdjdwSWJJUUZmbHRLWGV5ajNMMzl3UUkvT2Z3VUVi?=
 =?utf-8?B?cVJZcDFsMENBZjVBY3VtRmhnOUdCMlVzQkVSRlBHUE1JWHVVR0R3Wmo4VDdq?=
 =?utf-8?B?dDU2N1czWWNWbXdjVmJJNmhHYWxXYnhpRDUzU05TbnpESTJTQk1FT25iVHdB?=
 =?utf-8?B?R3E0S1V2VlN1UWVxY1Z6U2lkdENaUGMrUkYvdjgvY3lFQkR2M29DcXprMHlK?=
 =?utf-8?B?TEo1SmxudkxxRjQ4bWtaekZ3SW9DZWZIb2pUY0JVV3VjYWZkSTdHazJyQlJ3?=
 =?utf-8?B?LzZLYzlzWDRrQVN4eDhNYVZKMWhPOEMvZWhhMHgvOE53bk5nS09SbURLQ2ZN?=
 =?utf-8?B?MW9yZFhRWVErRG1DTnQ0RzBTTXdkQ21MR0NLRkpsZHJSWDNTYXhOK3RJV1J1?=
 =?utf-8?B?b0VQM04xaERpK0hSY1VLRmZDYzRXSExWNlpJRjRwQ00xR3A1aytjNDZwUUJE?=
 =?utf-8?B?WTZhazdvby9hUUpUTlVXcVo3bVVXS3lmRzBSMjFNeFNJbW5mMzBxWWVHend2?=
 =?utf-8?B?YzYvRlhaK0lhbFU3TUxjb2RDRnZCb3lkMUJMZXRzQ3pJZVBocXBERHpvS2F3?=
 =?utf-8?B?WWFGbmFMZytWdERmNzBjT285WGJtdWs0QjFkSHl0cUpmU09ZWUQ3SldKeVNv?=
 =?utf-8?B?bGQ1YzFEYzBKUCt2dUlmSWV2ZjdZWnNBeEp6VVByd05mYjRxOERBamFlMXdW?=
 =?utf-8?Q?71V7feS8YPOhetMUKD9hEE2u7ZFRkuYC6XATwCY/jI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25E856D42C368040A61D410557BF5E78@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8924617b-9fa1-49fc-8270-08d9ffe8d256
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:16:07.4922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3GfDy11h9v6/Eqf51QD6bOp3oPVogL612USN1XjgYx+97U7wdjj4ZcFT8eDGSVE1xO2wV+A7FAFn5n0AKs9wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMy80LzIyIDA4OjAzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gZGV2IGlzIHZlcnkg
aGFyZCB0byBncmFiIGZvci4gIEdpdmUgdGhlIGZpZWxkIGEgbW9yZSBkZXNjcmlwdGl2ZSBuYW1l
IGFuZA0KPiBkb2N1bWVudHMgaXQncyBwdXJwb3NlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQoNCkxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg==
