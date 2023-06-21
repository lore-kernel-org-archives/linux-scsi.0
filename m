Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D57BEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 07:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjFUHhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjFUHhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 03:37:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87899D;
        Wed, 21 Jun 2023 00:37:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+5uaQRAsrDUrO9JrAeDQmqN1/T4IPMqp33oqNUuK3xXDzyXNxpQOY5VPrlY3g2oQre3a5He7RC5WLkA5w2z2h28xsefHpviaRuXhZWuKcHgQu2ncfHntWGElCfgu39E+2cmJfQG7zKvM2ZD/U+9bUeTBAGdFfJcTSIvFyQN+VHZrie2DhwKGq/ekit3HwLBFYN8SqPEnKCJsMmrWh+nWhIHxN5+T0dcHCZ6xeAi/LAUrMo/a7VpMdvEf0bkmeMkDSQbaWD/cD0IgU9LxoUDLcRVGnHg9KGLrKKgeLmQRLwHMx0riLjptc73o4K2Bs4yrrD4kNV/f2qYvgBeXlQf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yDjyjtdFShmevxTngHxMtPYUVCVmI+HalAidrtRSFE=;
 b=dIez2rGnGkH4MpmH4kWkPtjRfmWSixZiEi1+tbEme5vniaDVxloXKv+IDZHAg94CAcm2EeUyQHkAIxUpAGlEZKz17C3qOdRUyknMhEK64ou6B8dNezfKGXAIot3OzKH/IGfTZzBEdXLvnSOyfJ2kTjyGndfWoUfiPT9YVf0cULCvaMg1z+1n8D7jGK79jVMb1aN2aC0s9M7dm/7LTwS173hmn1uXA1EwvhJRAg1sy3IMNUBWNu5zQqEBcjJDO7VJbuDPNhwCzx60Y6q7RjkALzwwkl1PwqOGIpIpf7DgAdFfTE+5X2o4zOYUMUjbBldrs5rgb/QC8zSAJd7NhtlU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yDjyjtdFShmevxTngHxMtPYUVCVmI+HalAidrtRSFE=;
 b=BYDhtWpaNoQJbYkhnpFeKB/ZC3M/eZVlR5l3j5ykOWa88y6FOuSuzMRZLc0Cqk+R6W1Ta/pvbluR5oYhBt3ZyzaVTtG0WqHEUTtAZxlPMo4769V47vpc/nDlq8yrVUZOX7ToBltg8oVpRnPCn5KBKZU7Dh65Nlz7Clqy9Ec5rQMZhtd8yuzyLC1u92bKVKjy6x6IQshwcUhJBS1tMUG+k9mVqKKVASwOdGFviiMv2Ih8VJn+1zBil9uD2gLv8z3CBtNqEZIfGQOOlQs5umR/XK+Oyf+Ryh9mT0ZksOAt4tdKI4wqZ07TwTdIinpR13JdtyikT3OSu0Z5r/0WZQxE/A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 07:37:04 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 07:37:04 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: block test failure with scsi_debug
Thread-Topic: block test failure with scsi_debug
Thread-Index: AQHZoz4AGlJ6LeG3CU6kLWItstvxmq+UjrIAgABHm4CAAAfFAIAAAcoA
Date:   Wed, 21 Jun 2023 07:37:04 +0000
Message-ID: <7d2e0016-91f0-227f-328a-8fd43f3b24d5@nvidia.com>
References: <1760da91-876d-fc9c-ab51-999a6f66ad50@nvidia.com>
 <zgp4nnbryukbgnv4cdtdnn3hwqvgggeknljmobk4moobiffseu@hiytoqbf7pol>
 <fqix34ny4enu26rqgbohuknosejgn5uikloeam7rbzjyf5zvux@f2uuriyeddhb>
 <35cece9a-0790-c7bf-ffdf-2ba14fb5479d@huaweicloud.com>
In-Reply-To: <35cece9a-0790-c7bf-ffdf-2ba14fb5479d@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|LV2PR12MB6014:EE_
x-ms-office365-filtering-correlation-id: 50c954a3-e7e0-4f1a-064b-08db722a4f2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SLPdsRg4r6lbUOQXSMZvc3BdIXu5DbCxGKPLrj1aT/T2EsHMlbtLvXc9JDHc+j0L5wQHaxR1ngE7eIFPR24eGkMdTinZgP++keQLb1uLbkC4YkHi/7m5vT7uszNW02YSdXRJIWOzRLT0PvQZ9TiqJvMatVWs2VaI2xgQ5vIsiI/Rx2vezDJOkeCR8DWafjSEtxXGLhHWu2LalcIdRwMiuh5MFAlj0AlmGf257Qc7d/G6apExND9EcuUsV+MrdEmlskwUMPKKkGSglmV+hDaTJLZoWaoyalghuq6SGewakXgjZQ6zVh5LtTdZkL5KkRLCyPocGjTdUB0KoO2vntfSy5QcZq2RvwPs8CDx+mNoUwsHbzbwcdHWyHApQmdLfa534gLFbETsef/QxWpSyHhDORnzdrp+jc2AxFO60vQrs3NHUKuVSOwXON4R/2HSnCgzaeREv4vGMVa9GYwbUFKIYnSdBo/gVuGtnPqg0Rd14mJOuN96VD/B3i9+S12skTQTzwHDxzPDtyvJzN6UuuZuYisS2R7p5lx4+yQ/mtLnFma4VZzKyYXsh8eNOBIX7XJHtQaovIJicIr4RdHGnjNCY9GbWY9EVTSwQKZD4Jv6/FuMmn9s/aDYYcZGimeuO+EzHWD+KIRrSVJ0gRW0Lte76c3AsELNF/XYTi2gF/TiFvlxDRYTlj+/HfKV0ESYCsZg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199021)(31696002)(86362001)(83380400001)(38100700002)(122000001)(31686004)(8936002)(38070700005)(66946007)(41300700001)(8676002)(5660300002)(66446008)(66556008)(64756008)(66476007)(6916009)(316002)(2616005)(6486002)(6506007)(53546011)(6512007)(186003)(478600001)(54906003)(91956017)(71200400001)(4326008)(76116006)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0RxZHZVdVFhbHUvVW1QelkyUnZCOUJlSzhJazdwWWRoaWUrZE1XR3JLOUtH?=
 =?utf-8?B?cDJKQU9td3BHTzhOQmsyd0JNOCtVakhhckk5YXhBOTVnbUJXN2lDRHNMYmxW?=
 =?utf-8?B?WTRRc1I1dDFOS09QNVNLT3REejJub2xVVWZZdEpsZGZnT3FoKzFlbjVmV1F4?=
 =?utf-8?B?T1BrQTJaVldYNnRENWZKZ2s0YnN3Wm4vQVk2enVVYjR0bUc5RmdWcWZKUjUx?=
 =?utf-8?B?K0UybEpGL3VnZlNZNHFINThVUW05WmxSOWpDQkN1OTMxTm5zbmpGWkxuM21O?=
 =?utf-8?B?RERtQ0JXbHhOL0txNHFpWlVaSXB6d0NWbGZBem9LOHd6N1ZHT0ZlbS9qWVpZ?=
 =?utf-8?B?amdTQi9GVkxRTldqRWk0RVNXejJaaC9VOVNLdDlqNVBiNHVvcFVaejdPSytr?=
 =?utf-8?B?K2k1R3lGSW1qWE44QmlvRmZuQTRSdDZ3ZnUyc2t2NnRLcFpUSWFJYVEzeWxQ?=
 =?utf-8?B?RE5uVGRzdGdsQlZqaWp5SG1ENlhBV3hJT0p6YWlnYmhlSlVNMENtNU0rM3pZ?=
 =?utf-8?B?bTdZak5FRXZnZWFGOUNpajBsVHRiZFdyeWlvQVhONDRVOWU0TTdrN2FKbFJq?=
 =?utf-8?B?Q0lkcHdyM3pXS3p6Z2VCc0JILzAwNXJLVDNqTDV1TlJLVW9JK1ZPYXVpVy9P?=
 =?utf-8?B?bjU1WDk1YlFKMXRhY3hsWSsyVVBlT0Vablp1UnNNcWYvbC9hV0sraWUzdFFG?=
 =?utf-8?B?QWR6WTBUQmNmRFU1WHhPcHEzSE8wQUd6VVZoWEpnUFBveERFMDRHNTdlYWJW?=
 =?utf-8?B?anVvQ0hpMGdmV1k1ajlQWGVkcm9zUXN2VWhLSnQ0WUlFRndydTVpNHhkZnRC?=
 =?utf-8?B?Y2dQdTEyS0VQSkNtdmZVMklkWGtpM1RnM3VJV2ZhYldoZkN5SjE5ZjdDVUxx?=
 =?utf-8?B?a2lwRGtlamNMeTdtN2hxVEVlTEtCSFJwOTVJdzVnNFhVdkNZTFJPdWdRR0pj?=
 =?utf-8?B?aWtVYlp2anJzdTdTQWVZa3BGakJrd2ViTzFCR000Vm9aYWp2bkp1cytCQ0Y1?=
 =?utf-8?B?ZjdvRk1lT2F3eFM5Zm5OS3pSWjhBaEZqZVRDMWtKaG1uS1JOcHlaSStrMnI0?=
 =?utf-8?B?WDdCRmZnaUpNSDNMMEN6dTlRaDg2cnI0ZkVFMU4wSUo5L3VuZHVFU0ptK2N5?=
 =?utf-8?B?OGRzMm0vamNBUXFhZ1VWWnQ4ZlR3THNmQnI1TFNxYm45UEZHUGJFVkpSV2xP?=
 =?utf-8?B?OGY3UURHZThaOW1taXVYSXRSZC9XYWNNaTJoa0FEcTFoSUthWDNOWUdDeTBj?=
 =?utf-8?B?UnpOaTRPTjB3QmthYkhBR1pTS0wzQ3hsOWxDZkhTUCtCOTlHM3l5a0Z6Qk9U?=
 =?utf-8?B?U0lOSXlrUlZQK3h5K3FvTDBlbHpDbWN1SWw1UDhleFhZMUZ2WHRxaXpiVC9u?=
 =?utf-8?B?OXAzMStoUHZIZGliR3dkTnd5eWVQbWgwN0hBU2Fsc2VYeGNrei9MSHl3UUR3?=
 =?utf-8?B?L05zcEFPYXhrcUgxcDlNQUJoZk5VbmpOaUZFQkE2VHJDV1lQT0FKRU1WSEVY?=
 =?utf-8?B?N2NKV0hvY3pjcHdWYS94QjRLRmFtUGcxdGRvSVRZU0xwclY1TGtBT0dnRmcx?=
 =?utf-8?B?MWErbWlrUzFTM2RnNFVWcVB6TDVQSytZSWJDT2t3TUpWL1UyazVGQ0ozUENP?=
 =?utf-8?B?N3paZDlBL1JEMWZhU21uTDRpTDBmR3ZKR0o1ZjlsUGQ1UzM3ZU1aNjNwT0xT?=
 =?utf-8?B?bU8xcDFzVHF0YmY1Z1ZNQkVIazJ2NnhnWEgrakZRRytSN2JNUDV4a1JoSDhO?=
 =?utf-8?B?SG1rK0VCQ002dEtHallJSGlCWnJsQWtjVXdOWkI4djRxUlZ4RXRjY20zT2tF?=
 =?utf-8?B?Nk5yZWp0UXNRcXBXbm1pNnY5TDUzOURyZEM4a0xqREU3dkRNVlQyUk5HWXBV?=
 =?utf-8?B?aEJ2RDlXbzN5eXd0YWFKUjI1RGZEVzhWeFRMellDLzZTQ05BSDNRR0FRbDh4?=
 =?utf-8?B?UEZrbnV2cVZwUDlxWlVHcnl2Ky81RGpFSE56NGdEZDBzeHAyWHViTWxiU1VW?=
 =?utf-8?B?QzhMVUJvR1BDL1pRMWo2dWtESUdjQ0xhNDRiUGxVeEZoVTdBcFk5YzJMQmJX?=
 =?utf-8?B?QnY1TzRlOWx4MitxQmZLSVU0TWFGcGU3ZGZHSU1ncGlUMVlWL0xLSmdLa2FX?=
 =?utf-8?B?bGc1cHJ2UlhWYVdlUTNhQXJFbVZrbmFaNlpxbUMzOEt5cW0rM1paanlmblBm?=
 =?utf-8?Q?a9s95PDugb7nbBD/FOmwl9AyGwSjURKL+/zUjizLiKov?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC6E76E39E46A641985913412F9A0E91@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c954a3-e7e0-4f1a-064b-08db722a4f2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 07:37:04.5055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLETE7OSPPEgbNzrtUUlt8Ip8PBa41+Utv0/Skhnm/++zWZeVElAEWEnuDdIzZ5q126gATSaN7RTwvsDab3r6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNi8yMS8yMyAwMDozMCwgWXUgS3VhaSB3cm90ZToNCj4gSGksDQo+DQo+IOWcqCAyMDIzLzA2
LzIxIDE1OjAyLCBTaGluaWNoaXJvIEthd2FzYWtpIOWGmemBkzoNCj4+IENDKzogWXUgS3VhaSwg
bGludXgtc2NzaSwNCj4+DQo+PiBPbiBKdW4gMjEsIDIwMjMgLyAwMjo0NiwgU2hpbmljaGlybyBL
YXdhc2FraSB3cm90ZToNCj4+PiBPbiBKdW4gMjAsIDIwMjMgLyAwNjoxMSwgQ2hhaXRhbnlhIEt1
bGthcm5pIHdyb3RlOg0KPj4+PiBIaSwNCj4+Pj4NCj4+Pj4gSSBmb3VuZCBmZXcgZmFpbHVyZXMs
IGFyZSB5b3UgYWxzbyBnZXR0aW5nIHRoZSBzYW1lID8NCj4+Pj4NCj4+Pj4gbGludXgtYmxvY2sv
Zm9yLW5leHQgb2JzZXJ2ZWQgYmxvY2sgdGVzdCBmYWlsdXJlIDotDQo+Pj4NCj4+PiBZZXMsIEkn
dmUganRyaWVkIHRoZSBrZXJuZWwgb24gbGludXgtYmxvY2svZm9yLW5leHQgYXQgZ2l0IGhhc2gg
DQo+Pj4gMzM0YmRiNjFiYmVhLA0KPj4+IGFuZCBzZWUgdGhlIHNhbWUgZmFpbHVyZSBzeW1wdG9t
cy4gSXQgbG9va3MgdGhhdCB0aGUgZmlyc3QgdGVzdCBjYXNlIA0KPj4+IGJsb2NrLzAwMQ0KPj4+
IGxlZnQgc2NzaV9kZWJ1ZyBpbiB3ZWlyZCBzdGF0dXMsIGFuZCBmb2xsb3dpbmcgdGVzdCBjYXNl
cyB3ZXJlIA0KPj4+IGFmZmVjdGVkLg0KPj4+DQo+Pj4gSSB0cmllZCBzaW1wbGUgY29tbWFuZHMg
YmVsb3cgYW5kIGZvdW5kIHRoYXQgc2NzaV9kZWJ1ZyBtb2R1bGUgDQo+Pj4gdW5sb2FkIGZhaWxz
Lg0KPj4+DQo+Pj4gwqDCoMKgwqAgIyBtb2Rwcm9iZSBzY3NpX2RlYnVnDQo+Pj4gwqDCoMKgwqAg
IyBtb2Rwcm9iZSAtciBzY3NpX2RlYnVnDQo+Pj4gwqDCoMKgwqAgbW9kcHJvYmU6IEZBVEFMOiBN
b2R1bGUgc2NzaV9kZWJ1ZyBpcyBpbiB1c2UuDQo+DQo+IFRoYW5rcyBmb3IgdGhlIHRlc3QsIHRo
aXMgaXMgYmVjYXVzZSAvZGV2L3NnIHdpbGwgZ3JhYiByZWZlcmVuY2UgZm9yDQo+IHNjc2lfZGV2
aWNlLCBhbmQgdGhpcyB3aWxsIGJsb2NrIHJlbW92ZSBtb2R1bGUuDQo+DQoNClBsZWFzZSBtYWtl
IHN1cmUgdG8gcnVuIHRoZSBibGt0ZXN0cyBpbiBvcmRlciB0byB2YWxpZGF0ZSBmb2xsb3dpbmcg
Y2hhbmdlDQphbmQgYWRkIHRoZSByZXN1bHQgaW50byBjb3Zlci1sZXR0ZXIgd2hlbiB5b3Ugc2Vu
ZCBhIGZvcm1hbCBwYXRjaCBzbyBpdA0Kd2lsbCBiZSBlYXNpZXIgdG8gZ2l2ZSB5b3UgcmV2aWV3
LWJ5IGZvciBldmVyeW9uZS4NCg0KLWNrDQoNCg0K
