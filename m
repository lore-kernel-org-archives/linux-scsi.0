Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8945C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiBIItF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:49:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiBIItD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:49:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EA5E01093B;
        Wed,  9 Feb 2022 00:48:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZxLmB5GvpILO30xJuiySR0gvyAiYN452xiseCVFGL74AjoJw9MTevgAwjP17Hnrqgbnn0tL+7RJgELOgCt3WTYbNgwegTTIwiBRagABMKVYSHBxjfX48eC6hXhvw9wiZhC1GrZ7rxP272BNai5QORwNg7/hKEEFxGBPdULswlvGyfwe0+pcjrb1saJnZLvtHV8jOpnJKoLV4ZLFg7bdiUCx4n6pt3yXVumcHITpRMQbOMOgzG/0sOG9W4dd3r/j9T3bdRYVNJfOEXApprCMMSnspks8a8LfaNWt88wZ9KRcEgZeg8ae4P0TnrB56+RvNSxMQdXVLZKE6mH/ZXuEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8tZdVMNUJhofQs9fXcHks62x1F26uV6hqZDAAu4Dmc=;
 b=lt4WQhJgi8gRcQ1J3uDFC09B2dUnShWiKyDP8nQ2LTcgQ138bldkUs4QnFvtemy6EV+RF+9EsnDdDHm6CaHKkyAjwn49zm7WHvs2PkyCypjNWHynlaDEEKOd/DMB0gB1MWApgDTYdqtKs5maVc6jJXvwKy0F8rwLFE08AkpdsN69xC3TeR5HoCJZoT+a8FRVhvd/FhvCM2V+957mANcQLByo47yKKB0JfDtJtRhS9nRP7zELXCjRNuCrd52c84K3TbkBJH8izmDgRwWf7JuSJEasWQ2KegbvTsL5vkf/9J0zi7Z8DaozsVojFFfPfaXNcni7NH0BQeuIC3/WH1OmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8tZdVMNUJhofQs9fXcHks62x1F26uV6hqZDAAu4Dmc=;
 b=UtonplSpVQbuJ3BGj0RJW1AMXHv+fJRFnyz+YUWEWnfKj1L5UQHVs9egn6HrdWNPuocUH4WOOsy5/lJPZAeEAf9WxSMW+pzyIgyah+kcR9Yx8EWPyOJ7LGVav5wENgqOPGKdEdd1gk9jOeOACo0fMK0IpoAXzBCzigH8YKuqsG13p1e7dHdE2uf5ZvvRTJIALJQbdeVZ724f5pji8e7oLRvoKOnRhCwJlpQ46c18vEkSC50Q5BokG8jVPtqc0D1qs+gm5SszH1P+7LtwSSSq4ZX9Z5V3mXOu8OMlpoCWaONc3m3L+jOuoiwXcLuVIsZC0jhoKCeMAPfVDvMlzvq7Gw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BN6PR12MB1346.namprd12.prod.outlook.com (2603:10b6:404:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 08:47:59 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::846c:d3cd:5a30:c35%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 08:47:59 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: remove REQ_OP_WRITE_SAME v2
Thread-Topic: remove REQ_OP_WRITE_SAME v2
Thread-Index: AQHYHY8g7dGkHRh51ESRa3jEASWdiayK6FsA
Date:   Wed, 9 Feb 2022 08:47:59 +0000
Message-ID: <0def0f5c-755e-9664-e6c3-677934bf6708@nvidia.com>
References: <20220209082828.2629273-1-hch@lst.de>
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 632c0bab-b6d1-4f53-7a82-08d9eba8dfc9
x-ms-traffictypediagnostic: BN6PR12MB1346:EE_
x-microsoft-antispam-prvs: <BN6PR12MB134678B461EC88342AB07953A32E9@BN6PR12MB1346.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6QtglzwPev7nWUP2v4cH+jxzi2UrTnBV66rVR0O1EqrLnT/nBXOSpjHEktp4rlzUWVhTIjLKmIE3kN8tVyfv0gYOW9IamYJlxL4SajwvEM3wiUXNzSK2IdRRg58/ax2lUi2qeS2b2ECaXO031PFUBSjkU/z/jUSKrmMw7mnOUPC+S18eR5+0Cj+95/mE2BGdU9vMc0v2OIg6ebHjQBbAPwL8+0lNFTrz30leO+tFWNA3pMciyNjdgja8ahhG93eHlNzDmUFEzJetdU/0SB0+4kRQI9nVjXCuDCe9gZGNchXb2UvsJ0tNT/nD11DC1sEeOM3nwLvDOsvvt+qY8pV5A1TY1R1hd/hy8Nz3kcKLdzDF688zjwtdijAvKupUqNtM59qebGBLNIs1KSjdSLkFFcZVXT2mbtloJLv2euqnDTBeRqQLBX6W6PAg3hbLwUqR5C0X3m7KYEGA+46/Y8WZ0foRjKJx4N+2JSdIj8dCiV16gvvXjpYKJnXiGr7DM0Jqa7NC1MPScWJCSuFjAU/gYdeWYJXzeStpUBxC5Z2WhQfZKdlkdl3MkoTaa57QxMTuhAiuXBFq/0B+r58M/qC5CLNvI6in13wzd/dSVaR7iPq8uv6mYauKWh1K9kfpRM3inzKK191V0uHGPxhLnDnUkyain/tdzZf1VbapRcOxoiPas5XInZ5iMOI2Zgy1iHqw58gT12sToEu9TDOVioWzfLIzN8GuZexKR5Bcau5rj2FdoAsTjACliATjhlMX8efoWYz3BR5+O9sEGQkSY5lwbfUsXWlRgLzVC6mEjMiLCjhj4n1J7Le1reDYaSkXsEH3thFUHy8YocKmKXCyVX0SJSBhfp6lGTYfVxCmT+I8buY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(110136005)(122000001)(966005)(31696002)(38100700002)(6506007)(2616005)(4744005)(8936002)(66446008)(8676002)(66946007)(76116006)(66556008)(66476007)(31686004)(316002)(64756008)(186003)(91956017)(6512007)(83380400001)(6486002)(508600001)(4326008)(36756003)(38070700005)(5660300002)(53546011)(2906002)(86362001)(71200400001)(7116003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlFHNkZXcHF1Rm0yYWhVRzQwRFBwTUVQY1hEekhkRXkvSm9yVnoweEJTM0Vt?=
 =?utf-8?B?Q3VYc1hnV2lXaTZabkc5RzIycDZ6enJrdDVOWENSRlpoMytBbXlBSlBORFpa?=
 =?utf-8?B?MWUyNnd1WDVhejZ5TGVrWDViVnEvVGlBZXZJdWN2bmpFTTY2YzNmRVF2KzlK?=
 =?utf-8?B?OTRqUTBmcnVBYjZFTTRrUFVZUXFPMUtGYmRuMkkvTHhKV2w1dko4RGZPc2dq?=
 =?utf-8?B?U01kZVhLWUN2V0NIZWZ6MlNQamlQSm9WYzI5MmhHcXJEd2UySlBrYXlHYndn?=
 =?utf-8?B?SkpSNi9YNEt0ZVM2RnpXSndQcXpNTWQwY0pQZlJLTml3aWU0R0RBRXhwczhk?=
 =?utf-8?B?UDM3NjhPb3hYaUw3eGVuUzVhVTBhSWVTSklsdEZ3dWNyOGhDbDlpV2V0bU4r?=
 =?utf-8?B?MzBEdjFSdTVHS0NCRklXTXlLcVVabEZ5U08xeCtJTFA5YlNoZ1dVT21ZVFBl?=
 =?utf-8?B?eTFKMHByRmhnVU16ellRem5KOGFwdzBmWjI2bjdNV1pJd3Y3Nys2RnQzVTVw?=
 =?utf-8?B?Zzhlck1oQ1luaUcrLzlMU2dCbXpBdXgwRGxtMXB6d0JqSzFSMG5KVzhhT3kw?=
 =?utf-8?B?WHlVbHhZQVcxMnVYbE1BdVpIRU1XQTlIWTdTSmhUbXFVeWZtZlhEbWExVzNL?=
 =?utf-8?B?by9RNjRYOHB6SzBnUjQyWFVxOXZZRkNETU5xRVQwWGFnOXRNUGdNY1FtV1RT?=
 =?utf-8?B?cVhINDZ0c25LS1cyY0c3OTBZaGFEWGFTN3VlR2xhVVQvM3B5RUMvaUN4aWV4?=
 =?utf-8?B?ajRZQTFQa3Ezc0cwUCtrSjB5RmlqOFVkTGowaGlrd0p4S0UzOU5IYTA2YTE3?=
 =?utf-8?B?blJ0U2hwdjh5c0NMK25ZNXg2UHhKNFJBRlFJZmd1SkZaUTZ5S3RFL3RVZlpQ?=
 =?utf-8?B?M21KcWg5Wi95VXhjV3c4eHJxdm5rbFJVeUsyNjl1N2ozSFZaVkp4ZS8yK3ZC?=
 =?utf-8?B?cFNqWmVBTkZmOE1NVWFPUGFEVUxDS3l2RldJWTJLTzVFYzNLTlNKUmwrSUZX?=
 =?utf-8?B?R0wxVU1ZVUExK2QxVXJvQ3VCdkM0djBMSFc3RVFGRTRnVXlxazFaTmpZNndo?=
 =?utf-8?B?SHBtbGFOcHZJMlJxYmtrbDY4TExTTzRxdnY3VlMxZW5DaE8vVGYxQnptK1pU?=
 =?utf-8?B?MDQ5dDdCQlQvalU0MUl6ZUpSbGV5NE5HVDBKVGJCMmhiaTFyeEt1akc5Qmdy?=
 =?utf-8?B?L1dWalVUdjhmYTdXanN4dS80dGsrekRIOGRXUUtOZlB0VUJIOHJwWnpMZjAv?=
 =?utf-8?B?eDZkcWRFMEUybU5XbWRsMzA0VXZudFdHa0x6OG8wNWpQbnhudy81NlZpeVhT?=
 =?utf-8?B?dEpyeUtTNDY5VWdKRnJMSHJvdnIyNG9hV1ZuTnk5enhrclZ5amhuakJLcVNq?=
 =?utf-8?B?ck5oZDByTmUwKzlHTlhIYWJYVEVvZkhOZXJIK3EyRTBiWDdRRlp5SFVNWlVs?=
 =?utf-8?B?RldJbUVTelE5eGlNeGF6a2lDaEJCaEwyTHFmMVZwM1VkS2VRMi9XOHFwQ1Qz?=
 =?utf-8?B?VDdTTkFWT05XUkx2dmVTL3B3TWRiSlJUVGlOai9oMVJQd0xxWlQrR0loRWU3?=
 =?utf-8?B?UDVTL0t1dTlPalRNUzNHaUVxbWcwVS9haEJ1blhaWWVEdlBVMjNLTzB1WmY0?=
 =?utf-8?B?eGl4ZE5PaVNEYzBPeHpVZE1IcUpVZngzTGFsMlZVVHdJSUptajhUekkxb1hl?=
 =?utf-8?B?TXZyWWo1YnZxUll2VGhqYkFaRk9tQ2lqb21Laldub2lla3ZlbGFZMjQ0U3Fh?=
 =?utf-8?B?UElVQ3JOOEtLQzR1SU51S3BtcEx0RXE0VW15cUVSRHRVT3J0QXgxMkg3UTUx?=
 =?utf-8?B?bXFVaE40a2J4RnovQkxFRjZGVlVCZklFdExZalJTK2pJSzlTNjZCN3ltdE5L?=
 =?utf-8?B?akh1QmxaVUR5QXBoK3FSSzZ3Z3l2dU9zMXl3OUNyV3NCaCtqdzdwVm1QYUlt?=
 =?utf-8?B?Wjl5TDNlMUZuQndXTk9hTndLUmQ0ejVxcHhtazlGWHVGRGlOcHRXM2t1K1lx?=
 =?utf-8?B?NVh3M1lLN09zSXBISEU2dCtBWklrUDJDVXRsUnFUUkJLTW9WcnJjMUdJa1NP?=
 =?utf-8?B?ZHBrcEJhVmxiK0ozdEpSMDNNR2lvcDlSRHdmM1grNHZLYnFUWWtRU3ZqWGUw?=
 =?utf-8?B?SFdISFcyV3Q3aVZGRE1hMFd5TDlOTEkwS21KZ1FucGhHUktxVUZyb2hib2FP?=
 =?utf-8?Q?fJVw9rDaBCZIuox8FhwbpegknyFt6kenBTVq+6lununO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5E8EC0137ACC46972DAC71A3FA797A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632c0bab-b6d1-4f53-7a82-08d9eba8dfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:47:59.0410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 65zdzv/7N6H0CNFko4a995XEv1oRaiVnhxmVcWAlxgivvR6YOCi9mOBaBBOdcN+AXVxsC4S3+sD/dkLfcUsrMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1346
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi85LzIyIDEyOjI4IEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gTm93IHRoYXQg
d2UgYXJlIHVzaW5nIFJFUV9PUF9XUklURV9aRVJPRVMgZm9yIGFsbCB6ZXJvaW5nIG5lZWRzIGlu
IHRoZQ0KPiBrZXJuZWwgdGhlcmUgaXMgdmVyeSBsaXR0bGUgdXNlIGxlZnQgZm9yIFJFUV9PUF9X
UklURV9TQU1FLiAgV2Ugb25seQ0KPiBoYXZlIHR3byBjYWxsZXJzIGxlZnQsIGFuZCBib3RoIGp1
c3QgZXhwb3J0IG9wdGlvbmFsIHByb3RvY29sIGZlYXR1cmVzDQo+IHRvIHJlbW90ZSBzeXN0ZW1z
OiBEUkJEIGFuZCB0aGUgdGFyZ2V0IGNvZGUuDQo+IA0KPiBGb3IgdGhlIHRhcmdldCBjb2RlIHRo
ZSBvbmx5IHJlYWwgdXNlIGNhc2Ugd2FzIHplcm9pbmcgb2ZmbG9hZCwgd2hpY2gNCj4gaXMga2Vw
dCB3aXRoIHRoaXMgc2VyaWVzLCBhbmQgZm9yIERSQkQgSSBzdXNwZWN0IHRoZSBzYW1lIGJhc2Vk
IG9uIHRoZQ0KPiB1c2FnZS4NCj4gDQo+ICAgICAgZ2l0Oi8vZ2l0LmluZnJhZGVhZC5vcmcvdXNl
cnMvaGNoL2Jsb2NrLmdpdCBkZWxldGUtd3JpdGUtc2FtZQ0KPiANCj4gR2l0d2ViOg0KPiANCj4g
ICAgICBodHRwOi8vZ2l0LmluZnJhZGVhZC5vcmcvdXNlcnMvaGNoL2Jsb2NrLmdpdC9zaG9ydGxv
Zy9yZWZzL2hlYWRzL2RlbGV0ZS13cml0ZS1zYW1lDQo+IA0KPiBDaGFuZ2VzIHNpbmNlIHYyOg0K
PiAgIC0gc3BsaXQgdXANCj4gICAtIHJlYmFzZWQgb250b3Agb2YgZml2ZSB5ZWFycyBvZiBrZXJu
ZWwgY2hhbmdlLCBpbmNsdWRpbmcgdGhlIHRvdGFsbHkNCj4gICAgIHBvaW50bGVzcyBhZGRpdGlv
biBvZiBSRVFfT1BfV1JJVEVfU0FNRSBpbiBybmJkDQo+IA0KDQpUaGFua3MgYSBsb3QgZm9yIGRv
aW5nIHRoaXMsIG11Y2ggbGVzcyBjb2RlIHRvIHRlc3QgYW5kIHJldmlldyBpbg0KYmxrLWxpYi5j
IG5vdyAuLi4NCg0KLWNrDQoNCg0K
