Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC068C77B6C
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Apr 2023 08:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDHIFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 04:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjDHIF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 04:05:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C3AB76C;
        Sat,  8 Apr 2023 01:05:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2AChgGwlSL/kMVJvHo8JdHfB2virJ7JrVBfmBPjTdj9fFYJ/h+2vZrh7eST9OpzruiZhzckVm4bGWUQMA7it+Qz91ChZ2BstcF34Yc622F2TcJP0SehGnMnIerDstTCFURaNe25n4mFNICspoWRH6u8G0bhWE8ZyKxH6y9k2fohO9rBJJaOQyspChQ704WsnAgE5Sgtx3k+xSZi75a72THyMxok5LMWyiXA+4vQ+eGAuPCLh4ke3xBW9gd9/2MHTLHtObMn46ocU4B48t1ELWYlrUs6ijpoQjzXI1a6+wg2e6qVgxJv7/TLMwltR30M6Wp/b3HwiC1nYDVKv6qPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m24MAmog5JpiDYQT37qaii9RsoiJ1uLtNIxoJqyeelk=;
 b=bhZzWgYsrUZSgUhC4Cu124TViexqUjtyr4cwH7clqbdHOHVLp5wo5XMCELMpWiUjzIUOeGYPd3K4FwA2rWlDKOh6VOyCdxFBj38o9KfOLAZqo1shdHgY4VE1idptzCEwcEfDv1oUtFa6aNFfsHq0UKRYN/3y/ul4xeWe6BXQanTANupPcM7yGWpR0ae3yAjlJfxpXG9WpcZW9/nLpzruNDQdzEKqvGxyhSs4bCmgL0Aq2jMCotgJ9JfED2byirTrxSKtGxfm0FRvaGKSp2cT76J8PQQ63EbWoaZ81OdKL8fIzFqnDDErHvJNeZo7AykeWvnWRNLHLrnMTzuKZVnQHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m24MAmog5JpiDYQT37qaii9RsoiJ1uLtNIxoJqyeelk=;
 b=b7lYP9cqYYTwF0vnJfP15xhCXk3OdMufWdqhVpuU+01yosmP5sRurYDuOUGAOdgEurt6s886JNqp7wrYsunHtcnEnnWaC+hfo3XyLSy0Val0bnFeggKIVqSg9W4v8FpSVivOE/6D/0wVFPgKQPepiDAc7WfkIjYxwUM11dGoONruMgJoYTmRkf5uTs7cfu2wmNr059Wo3JlzyDK2BLw2FHOz/bVxJrsCd4KXNiAFFCz3i5p9/oKguDImmaMsu6HEaGn1+Cg0FeF/3XpME/X9wjm4fFke/3ZrUvzYuCMWInwQTGcU5iTge6qetRaJ4g73u+3O57Mo8vlwzM10Gvh/AQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 08:05:26 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6277.034; Sat, 8 Apr 2023
 08:05:26 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     Stefan Haberland <sth@linux.ibm.com>
Subject: Re: [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Thread-Topic: [PATCH v6 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Thread-Index: AQHZaYxrwFmZ/Fcz9kCsacyH6PEO4K8hDqaA
Date:   Sat, 8 Apr 2023 08:05:25 +0000
Message-ID: <6373054b-b7d4-6cb4-1a88-35f69d1e9cc3@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-3-michael.christie@oracle.com>
In-Reply-To: <20230407200551.12660-3-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SA1PR12MB6920:EE_
x-ms-office365-filtering-correlation-id: 636594a8-36c1-446c-3de5-08db380802bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iAgi9tc05pn9JZSUL69GM4Ch+bUrvIqLX74uXyb3AFVCOPOgUVyn9GWgiI77PfFV/umC2m0AD8ghzeUU4d44qrd7JKYGtERLZHQlEVlF3qWzbLd2pPeELfqGz4vsbWdbnddlndq62lgrA+pO3m20VnD9uE8DdQi9zCHR3nzz+udrL5XCXckZoVZ5R70rXgz7aM8XbgoBBnlaqHtddC7UQSccW/a73hVzWio5e275uZyqOSGm1suT7P6FdKfaTwsONAwDizaQ/l/HqsYF/V2ORsLlKVIzxW+OFgyNBxq1C88RIjnnnP8wHk+qenH+KWVSpDJswua7voLUqjNC0iISHY1nxIJGDvevi0vyF/k+BHLyFVEXFIfXn1BEDx835mPu5BoDmzRRVvfg4MwPki9tDErNrJDrLUw05a7TWi+RClJu4U7qGJYVSNDJSWWFC58M/ZIVQDaefFdXQDjXNqO4B1ia+mTBBnoUk+v0yFCU60Y7or+Br4Jnqzq/hzNK2NQjeblUXFG2dihm8gPXIuZJJmQXQ2Qgvyjvb+ZkNmASFHoMsQyrFyOd+a76G/XBk0ipYe8XijSc4QhQ6554P6AEW0pBJihNHebT/+DvEsFW+TuEY1pA7IBW+xdPsOT5JKZLzToWdMcufdfnq76/wFiqLbyMWPAI/KlTnI03oxfXcWN4+Xk9U0FqJt2nLJp+NqEGhDiNbasQqzpsosgP0I15Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(921005)(122000001)(38070700005)(36756003)(38100700002)(31696002)(71200400001)(86362001)(6512007)(6506007)(53546011)(2906002)(66946007)(4326008)(66556008)(41300700001)(66446008)(66476007)(8676002)(64756008)(478600001)(7416002)(5660300002)(31686004)(8936002)(316002)(91956017)(4744005)(6486002)(110136005)(83380400001)(76116006)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0dMbXBkb0F5SXdvMWpZSW5Ydyt2VVNGZEtvcHhjRmNKUjh6enN4bWdkT2lO?=
 =?utf-8?B?blRqTFhXSGw2V21Nb2xwWk11cGVHSndxV250Ri9mU0w0MThCbFk5bC8xWmJQ?=
 =?utf-8?B?WUdvODJmay9VeEZLRFhLVTh0Q2ltL2VuSmF4bjBDY1VHT3YyTlgyeXpXTlhD?=
 =?utf-8?B?NUFlNHBuaUg5R0I3Y3NnTFkvdE5PeFp4MVhKck0rU0lYTkg1cVNnOFp2Yngv?=
 =?utf-8?B?RHBNbXB3WFZHYWdpZEEyMUF3My9VSm5SYm1wdnViZEIxd0ZjYlovWmNvL3lB?=
 =?utf-8?B?VzBqWWw5Q2x3bGRTdXdRbkRhQ1RBUzh6N1dVd056VElSbVpoNnhkZW8rc0t3?=
 =?utf-8?B?c1VyanV4N3NDMk03b3pUY3VuQnpBODJRQW1xQmRUVWU1UjJmeG5NZkFWNkEz?=
 =?utf-8?B?T0thcXJkc1NzeG0ra2ZkRVNqeTMvMms1bHhpN2xVTVN4ZExzTUNVOU56Vzcx?=
 =?utf-8?B?eHBkaWloT1ovRSt2TjNlZUlWd3AyYzN0cDRtVDZ3VnRuczM0ZitFaTErR2hz?=
 =?utf-8?B?SlpYT3p2c09Lak9VMEdMTjFjVGc1VitnZWNkYXN6dytXU05IOGRtUU1kRHpt?=
 =?utf-8?B?Q0l0TXRzaFpYN3dySHcxeVplUHJVWFUzVVRlTE9MNG45RmRCQktZaFE3NExi?=
 =?utf-8?B?VFl6MnNYdnZSaEJLK1FtU3dSaS96TDFIbUkvZlNVNlFMMnRLYUJremsrMVpp?=
 =?utf-8?B?YnhZSzhOSHhrTEh6Mno3cGdIN3AyaXRpUEpIa2lMQmp1SDk3NG8xY2V2ejVa?=
 =?utf-8?B?MENoUGdaeExySTBIa3pMMmFFSVo0endhSUIxMGl3a3ZPTGxrQUoxa0lOOGN3?=
 =?utf-8?B?YXdweGtkN2l6elZvbDRvbEpxemJFQ1dTVHJDVm5VMDkyRWk3cGNaSm1tUnlI?=
 =?utf-8?B?dGluWkJFa3dZRkJTemdQcjZtVldiTTFQYWF2ZE5ubVhhdU5mRjBiM1p3Nk12?=
 =?utf-8?B?dnEyS2JPT1FUL3dLSy9ydXI4d1ZMQXNwTlRJRlVmbktuRGY4bFNKS0VFQnRw?=
 =?utf-8?B?d0JORE1EZVBaWGdQcnF6Y3pIU1FoTk9JRjl1bUk2Y1dsUmE1WEtYWG9FMUNo?=
 =?utf-8?B?ZVFiZDl4cFRQS3FUZ1N1YU9nZkhQSnAyNGk3b2hrRGkwQUp0WGNMZ3FWWUhs?=
 =?utf-8?B?RWwydTBkTHArRTFXYU9OMmgrdndDbEV5YXBiS3hLUVBjODlZNDJScDVnYkxC?=
 =?utf-8?B?OE9PZ3NsdGVhWVplRlpLNHVYemwvcnlmVUlQdFQ1VGFNb3VkRkNJeWRxY1BJ?=
 =?utf-8?B?ZVJxRW9mTFpLbDBuRWlncVNLRVd4M2E0eERTa3J1WFF2Y2c0SEFSWUNZVWda?=
 =?utf-8?B?dUdNMDZJSy8yNitsMThDaXJWdHVwd1Flb21CQk1pOXhEUmtLUHRPWmZ2cHJ0?=
 =?utf-8?B?dXBFVjhZbUU3TUh2SnVzb0gyR0l0U2dlbzE5NWRJbWo1bk1GbXAyVjAzVnZV?=
 =?utf-8?B?SnZYTjllVmZJVGlzcVo5UXpGUTdUSzBLQ3RNcUYveHZ3NE5vQ3B2bkxSZGVo?=
 =?utf-8?B?YzRFSUFyam5mVlZIWkZZRGJqTlJ3Y3k2RmRISVYxdit4enZtdE9CZHlXNDRG?=
 =?utf-8?B?Y3FzMlJPemFWcHBsWXJGU2NjVUVaclFTOXFtZllsd2pyMFBoUUNocGlHS0dm?=
 =?utf-8?B?Tk1GN0xEU3ExY3pjWnN4TUY2RTNDSjNRa3lVcG43MUJXZUdHbXloaE9UUlZB?=
 =?utf-8?B?OFRCTXREbld1MDRhQUFsUXh6bzk1SWRVdGlmdGw5aHN2TFo3ejRaa0tmU0dH?=
 =?utf-8?B?L0ZVVEhld1VFOGw1UERqYlhvMkhTSFhhZUFURVZ1WUIvd2ErUFNoZG8xZjd0?=
 =?utf-8?B?Nnk3a1c3dVU5UXIzRmtmYmZtUkNra3p1aHRCSytJQzRLTnVJbytCU25wZUE0?=
 =?utf-8?B?TXJKcDR2TkFmTHgrWWEwbWxYVHNYUC9mRzJ4N2VkeUVGMUlPRGlBTEpLTEl2?=
 =?utf-8?B?NElyaGFzZVV3SkVFakh6WVJxbnAwM0RMaVdJa0JwNkIxU3ZOdFdoclBONXJN?=
 =?utf-8?B?djF4U2o4QkVJc0F4RTJoYlVxaHcxdHY3Q3R4dGs5OVFzY0trQWI3N0ZSWUdQ?=
 =?utf-8?B?S1k3ZVIvZVpZMnh3RjlFajJJQ0tVMjhTZlFJbml3NGg1UGRqVVZuVXFFYXVN?=
 =?utf-8?B?bGJ0cnZMTTlhdFBrVUxIc3VoNzFxbzcreG5uQ3QyZDA3MGRvQ1k2ZEppYkdj?=
 =?utf-8?Q?3TwKfLuJNuGfaVMrmt8btDvOvQZycXuaeb9MLnd771p6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB7FE23BCE74BD4182FB6A0CFF66F14A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 636594a8-36c1-446c-3de5-08db380802bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 08:05:25.9585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mm9zIpS1vx8FMv0s5cfy7XCioZH/W3uU30HCOmT0lGV9PuBA5InvBxMBMqz6Qm2Ho6bfAdUnATdvYV7bnn4pFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC83LzIzIDEzOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBCTEtfU1RTX05FWFVTIGlz
IHVzZWQgZm9yIE5WTWUvU0NTSSByZXNlcnZhdGlvbiBjb25mbGljdHMgYW5kIERBU0Qncw0KPiBs
b2NraW5nIGZlYXR1cmUgd2hpY2ggd29ya3Mgc2ltaWxhciB0byBOVk1lL1NDU0kgcmVzZXJ2YXRp
b25zIHdoZXJlIGENCj4gaG9zdCBjYW4gZ2V0IGEgbG9jayBvbiBhIGRldmljZSBhbmQgd2hlbiB0
aGUgbG9jayBpcyB0YWtlbiBpdCB3aWxsIGdldA0KPiBmYWlsdXJlcy4NCj4NCj4gVGhpcyBwYXRj
aCByZW5hbWVzIEJMS19TVFNfTkVYVVMgc28gaXQgYmV0dGVyIHJlZmxlY3RzIHRoaXMgdHlwZSBv
Zg0KPiB1c2UuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hy
aXN0aWVAb3JhY2xlLmNvbT4NCj4gQWNrZWQtYnk6IFN0ZWZhbiBIYWJlcmxhbmQgPHN0aEBsaW51
eC5pYm0uY29tPg0KPiBSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFj
bS5vcmc+DQo+IC0tLQ0KPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlh
IEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
