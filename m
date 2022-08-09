Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DCDC3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 11:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiHILMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiHILMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 07:12:12 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2054.outbound.protection.outlook.com [40.107.212.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2C52125B;
        Tue,  9 Aug 2022 04:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crfwo4sw9xYXfKEy2tFwiVhdP5jKsUZFSiD1jYLbBB1QUVPCbi2XjQs8vdLQiBoqu6JTjt59LUtTXIpBGDj+RaVBo0ICwj6UNTm/s6RhpWutDWJaJJwFY3v1PjM5ZNANo8vlnTsOOKJuopNYZFaYdk6x0BN5Js/3Eh6veCNoM2WGA4ReFPF+vYDZr86M1d5O+2Pm2BCfOATzbl9iE4bwq7oXANJgdE4dOhXM/OkA1Gp6gOwx64Z0EKO7zFP+CTGcHYgt197bn7QY6jYLCPCX/N/8SRTp7e9XtLGlzGPPbp8qr5aZfqaNZIc5si5x+I2S7XboqMpLRlq54+5jpfViRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNEOCXRoaQxnzVZ3TRtSAvOczs2XFt5xMM7dQxXg/8I=;
 b=IGSTTUxH9nMzOZJUNuDxwme+aRb0dY+fROBnfEhTnhNjGWri7DKQOyEmRztOTAoxOxJDkdvfk+Z4YQ5y5gyrrlkJXC+njaEM+6gUV/x9lxjPeQ8ckiLuQ/CHifK80/hMo/FmHPNiplhH7rv+7lEn4spk4a+NnOsPUe7B7WIMf94ezctaXrH6qpfymXFrrJseJjgGbeAx/jT0Ro3EAgopcw9nhd/yvsPUoQjYsfMxx42us3UIeMe4kp0SVFUFm8H8J977G/SnVH0sSjb6T6dNsAWVV3BpfXVkG5HtqBamMtXyESLXi46xzXHKKic4NHIEZ43VL2VLoGVK4xkJWK3jRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNEOCXRoaQxnzVZ3TRtSAvOczs2XFt5xMM7dQxXg/8I=;
 b=TIy6gV8YXC0pkGqFU1VM9pyvrEwQNImvZ/68wtaNsiniWvW7ibpIe5GRytJ41RyX9S0CUGdZ+X+8OqOmlVFnSU4OH6yHE8TKxxpLwIOgQ/HFqRCctwKgfqWO+b7c2FrhTAE1mgo6rpRXrkdSq+z2wpUud0ujyf8GBtQSEu+f2bOYLkYcD3VW84n/2Ve42hI76rjQBqiYM4p9WNsIm4vcQYaeWqMDSVD5CDzT7U01qYDSZqVPFNa2Y0NR5j5YWnZgD76Tzh/JAagY9OJI6qpNfz9rIatXsZ9J3c/DEnDqXO0Wk1eYziaXND5GRUc119wGxXfjI+8kHw2Mt14rN4hNDQ==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 11:12:10 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 11:12:10 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2 08/20] nvme: Add helper to convert to a pr_ops PR type
Thread-Topic: [PATCH v2 08/20] nvme: Add helper to convert to a pr_ops PR type
Thread-Index: AQHYq4PvpAt1heJFb0KT8DNjDUVZra2marOA
Date:   Tue, 9 Aug 2022 11:12:09 +0000
Message-ID: <483733f3-bda3-7ea7-7975-7394388b756d@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-9-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-9-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 177731a6-667b-4d45-0d02-08da79f800df
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RHO7KF79ZZQeN5rgzMs0b91f5pePPGcX3v/hDfBNd4fD0eyLo53Wtuh24y/QmKLLn6kodPlqn3rSnBB4oAqbDSHq0L8VOAwS5qkz7Ar8lZPBI2Cd4E19ctviCMk2y7TK7XfKsXERa2/Duxx0Bod/t2JOPXlFSUaIQdDhbFepyeP/qYWtk53bsxK3B0y+q/gLOJkcqKL4zq7zi1Oz4yBiD2iNEvlmIPEe6c+UAbN6FetKkBCBc+/+DrSAYPuoguttiWI93RceGXMpGjk7WmEODcI0HsZzHMSeG2DsyCTeaIFqVcLYeoeqTjkAe4UZe2h/17cm3TVyrZr1uIeDiAy+dVDGrGrawdqMag08MhyOFMqHUBAfD/PlyPfi922RsGgWuv3h+CWxvrlsHtW4EA7Gzne71LLZ2L9tu1ijDeu6P2ZsNkhDgdMy9kuPxnJJdqqle8aql/iXWOtOvh9ePzkUGNLhI0Eu8DKAxwGkSfOYj6bfg7Q+A1N3F7ODj9Su+NUMkUMCZK2IVwG1egcu5nHGlguuclrrEYwqPviU3l9xUiUFbxkFT8USl6MCYF0/o1FasI6PrY4CmRxiFtZ2OuKmUbGgAJ9OAuS1NCPAKLJl23Pt31hXWES7kjKtbAP4buZrf+71eZ0xIcehOfUcrxUXr5DVOtOJnC2kmWx49Nnoxit0KFIE/7GeL+B2FQSnh50u+P9/ZIro2G6nnZPyt0dKZKv2qnsGp2qgv2lJRxM98bgN8XGhIqTL4vbUk/LWliNu8yRtw59PGyCSjQuUoQjJBFCTfmehCINaGsXKHPtXxai//cD8q35DoCMdWSn8uu5U0NCuZ0yrp4tt1neq8KPIoEWPDbClPiBCguHwd9rOo4Zc7e+dKxoY0lBNxiPW5FVa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(7416002)(6512007)(38070700005)(83380400001)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnFBakNSM3E4NmdPOTkxU3d3SS8xUnJObWtod3lCV3JFUkxkY0g4UDhjcDZM?=
 =?utf-8?B?YjFueEFoZXVQcCtZVW9LNmNXWisrenJ2R2hrcFpjbTE2VEdHOGZhY08yY2lz?=
 =?utf-8?B?RmlLT3JIT2RwMTFOVWEzc2tDZ1hJQlVaTXJQZXM4cnBnTHZPWERwSFcxYXE3?=
 =?utf-8?B?bU9DN3VwWHBEcXUrZjZ2eDJZbWJPakZCdGxlVzNOMDR5MEtZdVZUVFY2TWRL?=
 =?utf-8?B?MDczRk5WWmg0VDRIMnRYbWQ2OTRYdTdXN0xEc1hycjFiQ25WRk5KVjdnQW5v?=
 =?utf-8?B?U0w4NnUraythdm9obE5ha1NZazM4cFhvR09lQk9tVDRybGE0L1JRb2o4cnNC?=
 =?utf-8?B?ZzYxU0UzOXUzMk1ENTVaZklRL040ZDU4Rm5EVllYZGRrREJGWDlvaDlxbWxx?=
 =?utf-8?B?VXRET2VwUEJxdGhNYkdTVkw4aXErNk5JUWxFc1JoVEkyejgxMHJXbzRHaW1S?=
 =?utf-8?B?THRSZUNoYTNHRm1xM21UL0wrSFJJS29ibzZhZk9NWHZUaG1SUEhlRTFra0xQ?=
 =?utf-8?B?N01jTldpOW8ySVUwaFhBWm1RTHhQakNYMFdnVjlVWmt5a3ppdnRrdWpsa3Z3?=
 =?utf-8?B?ei9yV3JEdmlMVXduVFc2cWJ0N21XRWlDWjNRd3JiZEJ0bHJPSE9MSlRlQTk0?=
 =?utf-8?B?cWlGTlBkTDJLM0JLQmhMMGkrYXRkNDdaa3FWVnc3OU5rTHZZdHV6U2h6Y2Q0?=
 =?utf-8?B?K2RYMGtGalFuSnpVQWFoeGVWekdsNStRZ1pjNlJuZ2pRcU1NYnJVcVJXTE9v?=
 =?utf-8?B?QkxnSWdqT2Q5V0JnTUlwRi9XdkpvZnVGdUk4ZHBtVDYxeUJvY3BheStSa0Va?=
 =?utf-8?B?dEpyY2Q4RGQ3K2xoNGVJK0FzUVI0TjFtU2ZCdG9qUlNlTnV1WlFoTFpaSFN2?=
 =?utf-8?B?a3NVREZ4T3VzNU4reGlacTRJZXIvakNFRHRDR0VtNjlOelJIWlVXWnh3YytP?=
 =?utf-8?B?NDZJNlh4eW5PVXlZdEd2ZlZaUnJqWGUxUm1iOVVXbnJXQnhNUUxEWnlNRkFq?=
 =?utf-8?B?N0R1YTZJN3BRL1BNeEM3T2tmV0dPV3NnTklrZHdqWTRlK0NYWlhCVUY4TTQ1?=
 =?utf-8?B?VVV3amNzemNDQkZHdUFMZWhKZ3YzK09HYW5hWHZsc0lLZG5nS3d2TE4yK2NY?=
 =?utf-8?B?cXUwTEVGaEJxRlBOdWNUOGJja21wYVhKdEwzNVgrQjl4TlNjak5PQU9TcGdw?=
 =?utf-8?B?aGs0UmtHYlNMNE50VmFvOXdRMUt1RU82WnlOcnRBS1RVMitheEZTa0VXM0Yx?=
 =?utf-8?B?eTFGT3M5Y2cwK0lQVytXWmswY0llV2EzOUdySUpFSUZxTTJmTEtTNUFyRXNX?=
 =?utf-8?B?RldwSWt6MVIvd2RzbFVIMWlRcW9hNnVBdjNCczlxSFFHMS93eWk4NzJyV3RI?=
 =?utf-8?B?VVlTcVZrZ01LWnFFMHZNWnViS2hrVW9IL21BZFBqRTN4aktYcEk5KzJpL2RM?=
 =?utf-8?B?eUR1Yk9ia2ZtMHdYNS85WUZ5ZjRLaldRL1JJZE5wR2toanpkNW9iVWVudWxu?=
 =?utf-8?B?TVZjdGdmWGgrdldEYXVNQXBTKzNONVUyUFRQRkJKSDBNVE9sdkliQ29oOFJv?=
 =?utf-8?B?dzRrYm8vbVQwbEI5Vk5FbGw3NWxLUUUvTjhla0Z4OUN0cFJSV0QwT0JXU3R2?=
 =?utf-8?B?VjF0VkJTMzZJQUFiTWYvY0NtaVVBaktNYUM0ZnZ4UUlWcmNDd0ZzVlpQR1pi?=
 =?utf-8?B?NVhCMDVyT2k0cDJLUHRMdjJMNmIwU291YlFkd0UvcklpS1NoOGh6dDcycG5h?=
 =?utf-8?B?dTZEME5yV29GNyt1MXF3cVUwWWk5R2ppSUw1VHpqak81bkFjcWxROFlycXQ4?=
 =?utf-8?B?ZEplbkdnYjFyTVZHYjBWOUNGYzlLOG9GL3J2MTBISXlGN1NGOHUwc1JrVDUr?=
 =?utf-8?B?dHdCUTQ0R1NSOGVkbHV5M1QrczZUUTNla0twaDVZZmNVVmt3ZDY2UmRCS1JU?=
 =?utf-8?B?eW9DdUVjVDBsOEIxL2lmNDVMN3EzTmJvY0RsaDlYd0VLZDZxOTJnaHRWWEZv?=
 =?utf-8?B?L0E0OEdvUGZ4NlVheGVEMVFGT0V3UGpzS1I0RFJBQWlSVGNWOGdWdHUyNmg3?=
 =?utf-8?B?c1oxR0hhSnl6WWFXRVVERG1VQjlBOG1hMDB6MkhJRDNkVXR4UVRiMTlFVEZp?=
 =?utf-8?B?aGZ6TjBBR2RkTTlZaDdaUWFrWTh5aEN0SStjWHR1VXhBMjdITGxOR0pjOXRt?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BB043579E4CC44BA3A6610FEDAC49EF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177731a6-667b-4d45-0d02-08da79f800df
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 11:12:09.9658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+mXZ6iPJewi4jAFeX2MC7F8r1CJC0mzXYyRftz95QRQgX9WPDCAO9kTbxhr5VGoa1BSTev8MDTh41Skg0qgcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC84LzIyIDE3OjA0LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBUaGlzIGFkZHMgYSBoZWxw
ZXIgdG8gZ28gZnJvbSB0aGUgTlZNZSBzcGVjIFBSIHR5cGUgdmFsdWUgdG8gdGhlIGJsb2NrDQo+
IGxheWVyIHByX3R5cGUsIHNvIGZvciBSZXNlcnZhdGlvbiBSZXBvcnQgc3VwcG9ydCB3ZSBjYW4g
Y29udmVydCBmcm9tIGl0cw0KPiB2YWx1ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hy
aXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9u
dm1lL2hvc3QvY29yZS5jIHwgMjAgKysrKysrKysrKysrKysrKysrKysNCj4gICAxIGZpbGUgY2hh
bmdlZCwgMjAgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYw0KPiBpbmRleCAzZjIyMzY0MWYz
MjEuLjBkYzc2OGFlMGMxNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5j
DQo+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYw0KPiBAQCAtMjA2NCw2ICsyMDY0LDI2
IEBAIHN0YXRpYyBpbnQgbnZtZV91cGRhdGVfbnNfaW5mbyhzdHJ1Y3QgbnZtZV9ucyAqbnMsIHN0
cnVjdCBudm1lX25zX2luZm8gKmluZm8pDQo+ICAgCX0NCj4gICB9DQo+ICAgDQo+ICtzdGF0aWMg
ZW51bSBwcl90eXBlIGJsb2NrX3ByX3R5cGUodTggbnZtZV90eXBlKQ0KPiArew0KPiArCXN3aXRj
aCAobnZtZV90eXBlKSB7DQo+ICsJY2FzZSAxOg0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVT
SVZFOw0KPiArCWNhc2UgMjoNCj4gKwkJcmV0dXJuIFBSX0VYQ0xVU0lWRV9BQ0NFU1M7DQo+ICsJ
Y2FzZSAzOg0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVTSVZFX1JFR19PTkxZOw0KPiArCWNh
c2UgNDoNCj4gKwkJcmV0dXJuIFBSX0VYQ0xVU0lWRV9BQ0NFU1NfUkVHX09OTFk7DQo+ICsJY2Fz
ZSA1Og0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVTSVZFX0FMTF9SRUdTOw0KPiArCWNhc2Ug
NjoNCj4gKwkJcmV0dXJuIFBSX0VYQ0xVU0lWRV9BQ0NFU1NfQUxMX1JFR1M7DQo+ICsJZGVmYXVs
dDoNCj4gKwkJcmV0dXJuIDA7DQo+ICsJfQ0KPiArfQ0KPiArDQoNCm1pc3NpbmcgY2FsbGVyIGZv
ciB0aGlzIG9uZSA/IGFuZCB3ZSBjYW4gdXNlIGEgc3BhcnNlIGFycmF5DQp0byByZW1vdmUgdGhl
IHN3aXRjaCBjYXNlIGZvciBldmVyeSBuZXcgbnZtZV90eXBlLg0KDQotY2sNCg0KDQo=
