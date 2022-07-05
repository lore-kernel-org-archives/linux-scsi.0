Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1370C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiGEGlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiGEGlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:41:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC72B5;
        Mon,  4 Jul 2022 23:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMNdwN0wr5xncpzC6qhCeDD76kwEI10jf92/VuSn83XPpSq2cO5Wr0h/vBADtbzTQ+q2b4QX0ZsNy+Jrh8Vw+SYQtdDnEJ/PQTEzQqj0pLmblYhsLeVXLv3E5Ud0DbsiT3CNTvtwIMpVYUFKLG9rIDm+161xy4saeanwopxgfO2KkZKYAC4YrULBj5ztoDMurgCrha5xQ9CXXjeHQ2jYMgsmFmFVGEmYz9WO2L8dEgv9zRcio6cI98psIwCtjdNnhwIGyR/w3XNuxaRQERpkAO413KC2E5ArKgmiaYO2LMB0HjCIARKC4VgBj5+fQnHSrx63TSzHCyR5EuOa3/q4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoH6g2DDyRWI6XqmXPsu19hkiN099BtFeIILKXactB0=;
 b=h5n7ml+bKbh7ao2L+eKYnSatS/HXykvPINXMeqTs6SCiAr5rF8OoUEMCRtMubhzZTR1y4EprllNy7UKqcEzD+WIw+J3T89bGireC1SOyhAoluQx7JIvr7tjW3Sl64060nBr+Fvwe6W788PK7svID9eCOewB67/XADY1djzvh6GvMh91euXOpF07ufxi3DXoHrpAs7Gulio2ykvN6K/bLlSIz5lfziPIXewm2V4H1lMXjsloVos021RAznlhbL7wqDHNv1RWB8ZPL/9o1nax9MHdNmpSl+AuJuripRrdrIXPzXcg5lUXmTU2oQuVJ2rcWIOkXgt00QAKcYoKtTwC3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xoH6g2DDyRWI6XqmXPsu19hkiN099BtFeIILKXactB0=;
 b=BIjJkWXS2klu3rkk3IwdBbS3PkGuUiN9cfLErvfeXdnaw2acmt8HwVlrdmnwXQYoZUNknAUvfHyKy6OKBPKsbCPMazI1H6MSdRbbQLM4EjwtVm34p13vT9lPyYSSGH/u0I/esIrGsAHznZWLX3l7f0qTaUGpJ/sgtvim2SGSnjs4jQeqVFoidtMPYq/GLsCYRx2NzDkT+JzbvVttw6m2SykHD2etFgFS11Ws3jLxqjismM9KERtNRDzrZzR8aOTqh0WeqTjX72Qlf1BTK+N76HkNc7IcyN8mxi9tB03Exd0pFHtIdSJiT+8SfYFPpGbbbhoIHbTu3W05croyujqx9g==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 06:41:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:41:16 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Topic: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Index: AQHYj6QAa7pakWbCDUSIqUOKWWrFda1vVSyA
Date:   Tue, 5 Jul 2022 06:41:15 +0000
Message-ID: <e77e7fe5-18ac-6df9-cec7-aae187c407d1@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-12-hch@lst.de>
In-Reply-To: <20220704124500.155247-12-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37139bb0-3c73-42d0-df64-08da5e515c54
x-ms-traffictypediagnostic: BL3PR12MB6476:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: epAMUppxWMrGZwfcOAy5W5jDFlq+lwfSsuwVlKrzlpY3PQBeRrVK3+XJoPKhShQh/snWf1zhVQlmduGmyZSbuFqXnhi9pOY/h56AGxDU0DYbMZb7w3KKqlXCgJyLuIsTsWFcepCng1T4x8Nz3AJFiB12OxaZVaKyMInAeFQMHh/OspP/Su6efQk5VkLunvjFh7Wj527fyUQ9akg3CbLqYk8Yu+PVPuAstpIe/vbwdFv79DR0FcZ+Zqnz9Vf16gDDz2RHmLNw6mTPxVfJfTi0c1lpUshB3xvNsuBI8mLFkIWRbXgco+A1MsSf22Jm1XpJHg/PUI4spy7spmeEZc6C0L75ehFyUifTPdxJSgjsabLPrI6pLMbq2/N7KNF2R6nSOsQP4AWIZYa+sNRAlTTF07pKIYFiv+velrNWFKsihLzkTITlggSeSUj1klckm9tP6Wlsy8ifxmhfpOT3zJCF44zs0Fc/4RrypSya6I799JA0capToS3TZdj43XUpMpr7XIXKfyr6Xrz9OubwmZzeeOkki+j/+NFCB9pRYPG2YOOUdFlQe9g4irr1NoHHUb6aiKkaieIt8A9+n/lhwG0PqUxEJ22pX9cpcp1QON9X18E8CuU8Ep6xv0efR1wgi9qCr936sEmuZzvbP+CszE4WcVMeKvLEeXYmEKJX1wfh8mCPQjJbuDHKakJnp5AsA+bwi1ITrH0p7hx5hSWcN/qRNp9AWkuqoGH1mgXyML1Z7q+2Jlp231t66ZZ7aBCvM/zdg+QZ7ozTc7zDowhbNX7SlUtmH4ILLwDg3ScSum8kxEsxjU4iGDfDVgg6+EmIr1/XVFUGsWDoELWBC4mB0/oaqntNveD0S9bXy9tIh+iO1kURZHNh0eyNkMkQht/IE6JW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(6512007)(71200400001)(66446008)(38070700005)(2906002)(6506007)(478600001)(8676002)(4326008)(53546011)(86362001)(64756008)(41300700001)(31696002)(6486002)(31686004)(558084003)(122000001)(36756003)(186003)(5660300002)(2616005)(54906003)(66476007)(316002)(66556008)(8936002)(38100700002)(76116006)(91956017)(66946007)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGJYcWlKS3RxRENYU3R6ZVJiblpwSm0xK2xZNkF4RWU1RmhEd04yWWVoR0ls?=
 =?utf-8?B?Y1dSOFo4OWVac3BvYzVRcHp3U2lqRVhvTDkrTm1rQ0w2RTBtRTN6S3RLcjZz?=
 =?utf-8?B?YjhXZkFENi95d3FMNk9pQkFIbEtpdEpBMjA5YjJhdUluZjBCTEQwd1BVYjI2?=
 =?utf-8?B?TkdYc2NES3VlajBzQ0lqaVFLS0hyVnlxN2JabTNyQ3Y3L0c5emp0eVVHb2Nk?=
 =?utf-8?B?NmpDWmo0aTVCNEdXdnBKQlBsRlRqc2R3OW1pT2FRY1lyZDhpR0kwV1I1Y3Nt?=
 =?utf-8?B?UUp2dXlYck5hVUFIaVlaSEwxbTZ2bnBoUWlXQkZNRXhrVkFoemNwaVpnemFI?=
 =?utf-8?B?RmZoL1Z5VkZteithVERISkJySVlmajB1MGFXd2dQMmg4WGtIdlpua1A4V0Z3?=
 =?utf-8?B?WTR1ZUYxZVdBK2NkMXYyeG1uOTFFTHZJN3hDNllwRkt2N1k5YzJpbWxLWVZY?=
 =?utf-8?B?UWhvSW9NTFd1azdIajZ5TjhyUmJPYXhkSzNRMEJsWHNzTTVBd3hYZ2ZOSlMz?=
 =?utf-8?B?aE54elJTTHFneWNZK3k3MnE0ZENJeHNmaTF6bW9iZDM3QnFOc2diZUtZeTMy?=
 =?utf-8?B?NUVIM29tUlBGQVdwcnM3MXFzT0dManV5S1FBWXNpQS8rNEhIQUVqcG8xS3pO?=
 =?utf-8?B?T0E5S3l2Q3ZqZHpOcVVWckE4RTY5Y3p1eldPM1owSVFScnVsUEViMXAwMGRj?=
 =?utf-8?B?S3JaRHJFY2piSkxuYTdvQmRCQzJDTGFRQk44aldkRU8zS0pXa21hYkpnb1RO?=
 =?utf-8?B?cUc3eWdLaTgyQ0xXdm0ybngwd3hSQ0U5bXhlNnRJZTgxNG1xejNNY05JV2ZG?=
 =?utf-8?B?bWJyQ2dRVE1SUWpaNmw4Y1ZjNGowVGV1R0R5QzZJZkZVSllaeGZNWjdISFJX?=
 =?utf-8?B?K2NIRElRZ1d2SndNZHI0Z0dpbzdZQWtIbmFONm44M0RzeDJjY24zNWFVbnhM?=
 =?utf-8?B?Y3k0dEs2WWZUUEh3YmtTcDNhRWx2bW1FdUtoR2NCQmd3TTlQUU12OU1Hc0ly?=
 =?utf-8?B?YW85c3ZxK1BJc0hxZlJLSHFUYitkQnF1KzE5UWZrOTFROGx1NmpzQ3JvMmhh?=
 =?utf-8?B?QVFkOHQ0NExZMmc0aTlkbm11eXF5S0lRVkZ4L3ZXMjkwMzdTcnNGYVRPYnRD?=
 =?utf-8?B?Z01HNDVlRWNSRzZpVWt5dFdTUzlKREU3aGFYTUw5UklRRnBtZ213YkhEZndk?=
 =?utf-8?B?QWZJSHI4aHlsQnFJam9XWElvME9icUVOUVpiQitiSmxEUWJMcW5aQzBQc3Bl?=
 =?utf-8?B?ZHZCVU8wZXhNZkRRQ0hWaktZOXgzMXo4R0ZDckZRd0h0eXV3a3dpZmhkK3dk?=
 =?utf-8?B?U0hqTGN0VmdtYWh2OW9KOGpHcCtHOXFuWmFJMFk0K3kwbU5jUW9ZWTVzSERJ?=
 =?utf-8?B?USt3VWRUL0FFQUQ4bTVWT1hYR1g2a2FrcEVjVTZNMW5mNy9EOGE2clFZQ29P?=
 =?utf-8?B?dWZYL05yc3JROFpoTXdxdktVaDBxVlNBYTZGUWowLzNHWVdpM0NUZm1uZi9k?=
 =?utf-8?B?OFhEcGxyZWVleCtRMWYvRWZYQVViTStyOVFtQzBOMkhnOVBWMzluUVp1blhK?=
 =?utf-8?B?K3J3RzNWK1ZEZjkwQ0pEMW1Ma0tYQW1aVFN3ZERZdk5GNlYzVnlpUnp5Z2cx?=
 =?utf-8?B?UUwzaU5ybVVOLzZKQnl3WU5VNnhURGxORkxQeXk5azRRY0pMMm55T3FzODN5?=
 =?utf-8?B?TkdRbmhFejNrWU0zN2pERmRJQWhKeVF0SzJZdlQ1dm1OamQ1MFRDNGUrcUxz?=
 =?utf-8?B?Y1JySENJOW1pbFZhVnU1bG52a2lXeXZpYnA1Z2tuN3oxMzJuTHNqMFlHRDI0?=
 =?utf-8?B?MVd1Tm8wSjVhc0p2TGtoZ0p2NFhuMmFJTkdPUy9kS0E4N1gveXVmUC81Uml2?=
 =?utf-8?B?U2o1eS9HYWJUQkttTU1tN0F1ZVMrNDRSZ2FKM29mQURlY2lBK1NjUjFock5C?=
 =?utf-8?B?eUcwd1ZhTFBvS0NhZHh4UkpEbmFScmZ0aU44d1NhYnM0RUxPbXE5UlpvajBC?=
 =?utf-8?B?cGdFbWpUK1hSZG42RTdMTEtBY1BiYzI1Rlc5cHRlVS9uL21kS0dQcDhCUjNj?=
 =?utf-8?B?N3VqelNhS1J1Z2R6aTZESXVWQjZWTW9LZ0c1Mm1NV3hlL2VQWWtGWEl0WXNC?=
 =?utf-8?B?TmlTT0pxWW44eUJVZWI5aVI3ZkZUNkJNVExpK1hTeEdjWm9NSytsUDVVTVNU?=
 =?utf-8?Q?sJNVxD7+1LBSrkpDcnuAesZOEmhtrY7NYf1qbm/bqF7d?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15DD4FE94A7CEB41ABE772FC197808C2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37139bb0-3c73-42d0-df64-08da5e515c54
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:41:16.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: POyt1CwQcz+/F3BTcT8IAXKKWlmaBRS1CkzZfWUpATZQndlVmALTK79M3HiaO4T8x76MqjwGIfzo33mzSeKS8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFsd2F5cyB1
c2UgdGhlIGJkZXYgYmFzZWQgaGVscGVycyBpbnN0ZWFkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQoNClJldmlld2VkLWJ5IDog
Q2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
