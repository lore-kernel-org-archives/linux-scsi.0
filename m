Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B201C64ED8
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 23:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBXXyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 18:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBXXym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 18:54:42 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89B3B21B;
        Fri, 24 Feb 2023 15:54:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK0a75U7BikmLsZ3+uaeFAzfAWRWA2stDpu1DQgAzag7ntDqoSwvB/WnY4tm1suYOGHckuWwsGbVfeTabAxQf6ZgOmg+XQEB06+gdH6cyud4TS0ZSyHqbHosV7NO6Jqido7PpG0xTk+0k0EwPLTxh5YuVoS2VEgyvfuqzPgxD2c+j7fY4fntJnvn0zJhm0FuWx7yUCP9eaRDJzRRRjf0VidkBFvhlq+PbRGW6XRrqBC3BR69S59YVCNFv3m9wvVaQjDGVo9H3JjEm6I8UK0YboUOIhMclS8Keyt/MQMpFOsIQpaH7t6IOmBZrVg+vyuRjcXFRUGoiC9JvDmZUi6lOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eT65X3s+EIPmgl2BcafGrfMEKGAqO3SEXxP3sIoHj4s=;
 b=MRehRCOkrKNLwglMlzQ6DWn3ZeA2OEaDfRgnSmKnHsuD9dakV9yfufqR9+OCdbLi+L/mrBDMskW0TjllYs6kxgDFSnL+7sHYJw4rirOQk/9FqOeVQpA3A5WzmuLXVndwvl80sBnslVmzZ5q+ug1IwlVWfzWvJWikkFYp4qWEeyUwGgQpEY7x5l1Prem9++Y6PkjRoma5dNgaCb/bLZ0fx661bo7eX+w3FihoS6UcdtaQWotDqpkr6V9iuIoQC47kBHa+Z5dRAXNBWscX9GmMo75sJ+ozVjJOuqRV4Thxa434UwlHM0gg5w7pfbVDwJQNokStakzePKSAu+hXmAS6Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eT65X3s+EIPmgl2BcafGrfMEKGAqO3SEXxP3sIoHj4s=;
 b=Ca+K6Q5xtVUT8QDdbR2pdTGOa4m5WSVX75QL9tcq29huhv0E5N9mtUihGbAB8rK756Ux8Fg/rt6nc//RU+rAuuGG/lDtxuiO3j5PlmzPz8V/Sk6pdthvdtvvA6W7VQLRGRLcYz8koR/q/b0h1/Dehwb9bnT0EOEKP4r+rraYA8lNKZeIcz6FB0VnmUbLEK+D8EsO4uhgfw1M3ExmM5oDK9KKw1vw35BrSk+KXgoJDpJgZ/7B48QFjXxRU51EUA9bFSOJFTfUwr8QeeL0Po8ayUD17f3SYffSTGraJMJ7FO/auDelfqP/Ir1+b4lVpTYRwT5hxJfhajTj03Dw3BNpVA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 23:54:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 23:54:39 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dgilbert@interlog.com" <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Thread-Topic: [LSF/MM/BPF BOF] Userspace command abouts
Thread-Index: AQHZQfzSsG6TxGrAL0SqQW/HeL2g2K7RxtkAgAXw7wCAAeaTgIABdCaAgAAEaQCAAZ3/gIACHdaA
Date:   Fri, 24 Feb 2023 23:54:39 +0000
Message-ID: <73b4dd39-9ce8-9b55-8a1d-06865f3bde32@nvidia.com>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
 <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
In-Reply-To: <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SJ0PR12MB8139:EE_
x-ms-office365-filtering-correlation-id: e62fcd1d-40f0-4659-c276-08db16c27ded
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SRFW7E6xr5r+3MjqbbMiKt47K1sgoCy1OZxSyeIWgnkDWxVPqsZx1gmgLXgCGG+qT9IRDD3vNSpqIYTJ4AKYBflOz/I+jBcTs7R0ec42SC83QJFriErUBdxoSWwF0zDJwNclwxuyKlygF8P342dS9f4XqVB42Qfqlkex4nxhkfqSM7l6E3B/ag/rRy9YLswQQevHRwjvNDD2sfB47z7n3un+fCexTCfS/mHpm1m3eRsB/9xsPvuo0xkpP8YGbLe7H9xnsjKwIfw7QwZfLfTt521W4sIA3jR9X4GThN2YTUoU+xOMHJEv/QiDNK8imb9Ud7a5i2c4m4xqbGR/54NhMJDGqqt6QEDxw0ai+hGKTloeuqHSKP8x81e2+jXwGeHsPWNSgYuatMVfv1TNiXFXLXxa3bmLPdL6YMXe4KzkzMGbmyxJ5lYzwe/se6B32mrBhSm+xb2gQVz453YekopXqIbzph9oORn6k57qCp9Awzdv+1+FiwI5W2D81SZToObJJtZyPBCgobJR0EpA17jmBAd88kaCUuJ5+6KMjx1msrRlxu9UO33RrwmouftPupkIndpiDpLhfYoOpVT7RFJeQxnkHhvCKiKOd6tHUa3TRaP5vlaUtohbkUXCKGLgCtFQzvP340rqcWO3pgwOiTvJybAhpGLecw+cWzykQPkA/lzDCwgf0zlev32TQWbwIdMVkHM0YjbWSDQco+QTil5y9+I1L2QN/wrLetUs7zNAOE6btVdoTuTZYjoDOde4L5Ns6yf+qltaK8BS5Se28x/0Kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199018)(2616005)(91956017)(66946007)(41300700001)(83380400001)(478600001)(186003)(8936002)(38100700002)(86362001)(110136005)(38070700005)(31696002)(8676002)(5660300002)(54906003)(7416002)(4326008)(6512007)(6506007)(76116006)(316002)(122000001)(66556008)(64756008)(36756003)(66446008)(6486002)(66476007)(53546011)(2906002)(31686004)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVoyWm04YWNLTCsrd0dTaTZYQlFSL1dmaVNBTW1QREUwRUdEcjJRTWxNRGo5?=
 =?utf-8?B?ZjkzOTdqc1lkWFQ3T0JqbS9ncWtHdVBucVlQZGltZlgwanBwSU9hcEl6VUVB?=
 =?utf-8?B?V2F2b3ROM1g0NTRRN1BlVlY5bGNlWXlBNytYOEZybjN2dTlYbms1a0prZVVW?=
 =?utf-8?B?dVpSUEp3aSt1Wk9TbllrTE9WV2gzWU5vSmlhUWh3ZDVoUit0LzZNZmNtNFBr?=
 =?utf-8?B?c2NCcXRiNjJ3SE90SWhoMjA3WXlnWlJza0YydjZDR2RhZWZNZjFaUUNsMVVr?=
 =?utf-8?B?TXV3UHE3VE1ETE9KVm1VeTRsL0s4SEtDQ2ZkREZTdXVUWUpVVC9xN05zSWFF?=
 =?utf-8?B?ZE93VkpqVXJoK1JoZyt6dENvT2JPTU5JWnp6eUM5alV0NFVhdGVrb1VxRVZT?=
 =?utf-8?B?OTlWMVRzWXRBOGw5RFFHYU1JUXovd0YvTVFYSWYwZU9kNEpIOWxXeXhWOWls?=
 =?utf-8?B?NldYNVI1Y0hmY2syUS93TTdpbHVNZ2JLZU1GZnNkM1F3TXdGYVdldVRuemZV?=
 =?utf-8?B?RDJuRi9RU2lCdURFSEUxV3FRR3hVWnF2Z0J3bUx4R2RiUGptUy9FanBjTDBB?=
 =?utf-8?B?SnpEcWFMS3JuRXprVzZ6TGRCdytjb0YvRGRESVVmM2ltSkRncW5Mc2g5K05k?=
 =?utf-8?B?MzNEVm5qZm5CVVV3TGp1a2xzZk1yb1BQWHNIWmQvWE1pN1RZMkxXN2JQV2tR?=
 =?utf-8?B?bWF5bWhNM1FIODYxajhxa0pFU2padzRVVDlLYnZyaDNkWllodTRUY0dnRVhx?=
 =?utf-8?B?bFNoVlBjcm9GaUNHa1A4dDIvd2xDTE9TYVJNL09IVTZUdXp1OUFWUUNqN2la?=
 =?utf-8?B?eHFMYlRKYWFaRitLZ1RUb0xwNUJYTzJCR2hQaHJOdll6S1lCV25HSENkOUpH?=
 =?utf-8?B?YUFLUmRDWElUanNVb1IzKzM2YjNmN3J4T0xtMSs0V3o2OHFyMUZCa3JqaWJL?=
 =?utf-8?B?OGZKckpjOWk0T3kxMzVMWjlWZFRROXAzNU1xcTd2a1FCTkxlWW1UMldycXFO?=
 =?utf-8?B?UzR2enBnUGhxR3RuZEhJN0hZdFVqSlB0RkI2bUtYejh4RlhsWmlYdmNFYTZz?=
 =?utf-8?B?LzFSbVowK0lxbVlaOXRLL0VwbHkvOUIwa1ZsbEF3M2lEWnd1KzBpQ1pEeG5T?=
 =?utf-8?B?Y3Z2dVFkY3Jsc05UQU14M2JGZFJBWmd3WUJZM3BvVVQ0TXNaMGNDSEh6Nm40?=
 =?utf-8?B?bnBDejlxMFJIWitXMDN3eGJ3bFhvTEdXNWNwSmYxMEpVTTBsdnhRZm5QQjZY?=
 =?utf-8?B?cCszUloxUEE0VGUvak5uNTZRK3Q4ajNRaWhzUEo4Q0M5cGhnVDZZNVdGNUFD?=
 =?utf-8?B?eEYrc24xSGNMWGZpTzV3NSswUDZ0eEpiZjRVOWo0ZXF1Rm5QZWM3WmJDdXN4?=
 =?utf-8?B?dWVTUGoxVTFMdzk3UHFveCtWUzg4eVFLYldWUUx4d1ZNUTFRYUVmbnZOOTd6?=
 =?utf-8?B?aGdpcFVKcWtFL3dTcXJuS2JFMnZFekRYUkJlRkFWRTVQUlcwZmRFOXNWTDRu?=
 =?utf-8?B?amZoNVZqSzlMVlpJT2pyOGQreXd5S1Fla1VqYkVqZSs1RUFoWDF4eERnSzUz?=
 =?utf-8?B?NWZjN1JqeUszT1AxRmt4bVlNeGNWcG9zdmNuc3hXTTRjc2lxN0JJOUJGd3hR?=
 =?utf-8?B?VXQ0NU1xTVdxVENJUG51TU1jeWg3Mmx5U2kzbjh2cVkxR0l0U2haZS82b0J1?=
 =?utf-8?B?VFc0UWkwdnFCK3FKRlI0WExiUHpuSkFJRWlycy90MjI4M1FmUjdQNFRielFV?=
 =?utf-8?B?RlpUenRzYlY0dkZKNmt3ZStoRGpVSDlrcU80UXQxYTczZVQ4c0FwSjJwTDE5?=
 =?utf-8?B?ejhDeEJWVEVZYW5kK2FiMVJyMEJ5VWZUdGErU3V5aFZqQnZKNkRkbTFtRStm?=
 =?utf-8?B?emtIMHZIeWRKOHJHd1BNOCsvbVFRVTIvaEMzd1NQWDFjNUx3ZFJnSjA0dysx?=
 =?utf-8?B?bjJmYTZXT1R3bkw0MTN4UjIzQ0x3K1N6dFRkM3lLMkxqRUM3cHZSN25wK2xE?=
 =?utf-8?B?cHBoeHIzRnU4K2tYeWNpb0YyT3J5U2RhWk12bDVhcloxQnVkNjhTeHFoSzky?=
 =?utf-8?B?UmFCU1lJd093ZHcyOVVOU0pHT2k1RHcwYXp4TjZSMHV5eXB2TEFxSkgrMFIx?=
 =?utf-8?B?VCtOQ3dTNzRIS1ZWM0ZhRDhOcFNmL2ZsUEZkZ2VvYi9HV2xaam1zbk52ZzFE?=
 =?utf-8?Q?gylfyZ5ZRQ/+7iB9fYpEVwHiir5R9hzROUI64cwOCJo3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3429A3BCB82DA34896E8FF1E3B10B56A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62fcd1d-40f0-4659-c276-08db16c27ded
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 23:54:39.4632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMqhg8hrLrRvUtxigG7/BDKkg+3nu2DNpSWqfz2ojMcF7FcRKKTXKoqw+IrQeTOrNeqRXhZgJ8r8CyUEEqpssw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

KCtNYXJ0aW4sIERhbWllbikNCg0KT24gMi8yMy8yMDIzIDc6MzUgQU0sIFNhZ2kgR3JpbWJlcmcg
d3JvdGU6DQo+IA0KPj4+Pj4gSSBkaWQgbm90IHVuZGVyc3RhbmQgd2hhdCBpcyB0aGUgcmVsYXRp
b25zaGlwIGJldHdlZW4gYWJvcnRzIGFuZCBDREwuDQo+Pj4+PiBTb3VuZHMgdG8gbWUgdGhhdCB0
aGlzIHdvdWxkIHRpZSBpbiB0byBzb21ldGhpbmcgbGlrZSBUaW1lIExpbWl0ZWQgDQo+Pj4+PiBF
cnJvcg0KPj4+Pj4gUmVjb3ZlcnkgKFRMRVIpIGFuZCBMUiBiaXQgc2V0IGJhc2VkIG9uIGlvcHJp
bz8NCj4+Pj4+DQo+Pj4+PiBJIGFtIHVuY2xlYXIgd2hlcmUgZG8gYWJvcnRzIGNvbWUgaW50byBw
bGF5IGhlcmUuDQo+Pj4+DQo+Pj4+IENETDogQ29tbWFuZCBEdXJhdGlvbiBMaW1pdHMNCj4+Pj4N
Cj4+Pj4gT25lIHVzZSBjYXNlIGlzIHJlYWRpbmcgZnJvbSBzdG9yYWdlIGZvciBhdWRpbyB2aXN1
YWwgb3V0cHV0Lg0KPj4+PiBBbiBhcHBsaWNhdGlvbiBvbmx5IHdhbnRzIHRvIHdhaXQgc28gbG9u
ZyAoZS5nLiBvbmUgb3IgdHdvIGZyYW1lcw0KPj4+PiBvbiB0aGUgdmlkZW8gb3V0cHV0KSBiZWZv
cmUgaXQgd2FudHMgdG8gZm9yZ2V0IGFib3V0IHRoZSBjdXJyZW50DQo+Pj4+IHJlYWQgKGkuZS4g
ImFib3J0IiBpdCkgYW5kIG1vdmUgb250byB0aGUgbmV4dCByZWFkLiBBbiBhbGVydCB2aWV3ZXIN
Cj4+Pj4gbWlnaHQgbm90aWNlIGEgbW9tZW50YXJ5IGZyZWV6ZSBmcmFtZS4NCj4+Pj4NCj4+Pj4g
VGhlIFNDU0kgQ0RMIG1lY2hhbmlzbSB1c2VzIHRoZSBETDAsIERMMSBhbmQgREwyIGJpdHMgaW4g
dGhlIA0KPj4+PiBSRUFEKDE2LDMyKQ0KPj4+PiBjb21tYW5kcy4gQ0RMIGFsc28gZGVwZW5kcyBv
biB0aGUgQ0RMUCBhbmQgUldDRExQIGZpZWxkcyBpbiB0aGUNCj4+Pj4gUkVQT1JUIFNVUFBPUlRF
RCBPUEVSQVRJT04gQ09ERVMgY29tbWFuZCBhbmQgb25lIG9mIHRoZSBDREwNCj4+Pj4gbW9kZSBw
YWdlcy4gU28gdGhlcmUgbWF5IGJlIHNvbWUgYWRkaXRpb25hbCAid2lyaW5nIiBuZWVkZWQgaW4g
dGhlDQo+Pj4+IFNDU0kgc3Vic3lzdGVtLg0KPj4+DQo+Pj4gSSBzdGlsbCBkb24ndCB1bmRlcnN0
YW5kIHdoZXJlIGlzc3VpbmcgYWJvcnRzIGZyb20gdXNlcnNwYWNlIGNvbWUgaW50bw0KPj4+IHBs
YXkgaGVyZS4uLg0KPj4NCj4+IFRoZSBvbmx5IGNvbm5lY3Rpb24gaXMgdGhhdCBhYm9ydHMgYXJl
IG9ic29sZXRlIGFuZCB1bm5lY2Vzc2FyeSBpZg0KPj4geW91IGhhdmUgYSB3b3JraW5nIENETCBp
bXBsZW1lbnRhdGlvbi4NCj4gDQo+IE9LLCB0aGF0IG1ha2VzIHNlbnNlLiBJbmRlZWQgSSAqdGhp
bmsqIHRoYXQgbnZtZSBjYW4gc3VwcG9ydCBDREwgYW5kIGlmDQo+IHRoaXMgaXMgdXNlZnVsIGZv
ciB1c2Vyc3BhY2UgdGhlbiB0aGlzIGlzIGFuIGludGVyZXN0aW5nIHBhdGggdG8gdGFrZS4NCg0K
SSBkbyB0aGluayB0aGF0IHdlIHNob3VsZCB3b3JrIG9uIENETCBmb3IgTlZNZSBhcyBpdCB3aWxs
IHNvbHZlIHNvbWUgb2YNCnRoZSB0aW1lb3V0IHJlbGF0ZWQgcHJvYmxlbXMgZWZmZWN0aXZlbHkg
dGhhbiB1c2luZyBhYm9ydHMgb3IgYW55IG90aGVyDQptZWNoYW5pc20uDQoNCi1jaw0KDQoNCg==
