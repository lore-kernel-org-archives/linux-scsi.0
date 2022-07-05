Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B51AC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiGEGnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiGEGnl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:43:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297CF9FF0;
        Mon,  4 Jul 2022 23:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtP2hgPn00zu/jzUfWwKKTBXGIt2VY/AP5c+dVHLTM4vbvUeTmTIIHRAda9ws/ZzVbJmgK4+mR8uajSqhZjYMoXq7+AHPoHgtFT9uqGWQ4lUX7KjEDxFQ1zERwTkLa7887TCJ1azlNBqZRSlqp3zpuNjILVQ2Lx8au/I1LaeDkPY2/xA1s66AJC2I1CPAOPkSKjGWBRPfcJ4tZvbr5Wh9au80TvW4ZlnXhPyGzoR6w6Am4cuVQvS/plYmCsdlSlVBz5OFOKaXrBJKNnSO/68pgHjo9GmHr5IRpATiifZxNsN3WA6czvUCoObaYuwui6xyVo21QWLdnmJGsTGfBOLMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dveU1xGpnxLMvlOBYyu5pNSuPLNyKteGzadto/h8V0=;
 b=GeBzvy5P60ylqDQGPcKdJ1jWTFknEpL1YDej4S6YFi8fnhD4gx3yEdyFj0rVQSJ+zYzkPSx5makMG+mbW7WkuT09xTPr5tVpQ3CdUwJriv5knnhtHxqo+Lh6dosn3fj2fNS6ff3UhYBW37BnMbaKn0/non6Jrcs+AZPk15iSb3pBPWEafdUMbOpH6g+Z7V2wBZQBxlKcnQLqRpOWMe3uC9Cqa+22jxOYKDXwtgVUC5xoFjoish73x1RfveCKgzkpmxHB1zH8Rl3mw+Lyy3wY17eHNzbjAlwkHsnv6vXBrLt/E6cJtVgsV/3mfvyvCsBTHJ1Q2m6QggF0RyrxzLsdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dveU1xGpnxLMvlOBYyu5pNSuPLNyKteGzadto/h8V0=;
 b=sfaz09o0MR8I08IW9zfeFqBVHQ6SU/mtF8ih72dxXK/La7HXr3Dadp8ZT3o4SPwaPIbv8gVSdhdCylN+oA6ia412PGlEupuzfiogKfeqcdK2FgKtxE3yo9uVZGgt1hTRcO5zFiXmz/ulT301Cf9D6PKvVOGWfYlH7U0DaPxxoK5VkL+HGcoljEinEYVqg3Ik+jJ4YD1VQ481kkefNuN+ZEPoIdp4ME+RdFeMBMAm3a0b6PVTB2UhNc095IBdDWiW/XDWPsxDqi2ATWIA6H7XsB4BeufmDBqfL6lzpNLajUYR5la0nhTmbwUqPIZuv1tU6NpPDJm5wsKCqoq/FuSkew==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:43:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:43:39 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Thread-Topic: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Thread-Index: AQHYj6QMT1r2i5a7IECmjg585tUSsq1vVdcA
Date:   Tue, 5 Jul 2022 06:43:38 +0000
Message-ID: <abe926f9-5630-bf64-8f16-7580e72f910f@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-16-hch@lst.de>
In-Reply-To: <20220704124500.155247-16-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f535b59-a342-41bb-bd90-08da5e51b183
x-ms-traffictypediagnostic: CH2PR12MB4837:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aOZ3ljimNNi8FKQ7AhmGTrQq3je2wqm9Blf6H9UnLCI6nxvCExywh122gKvCbie/ugxSJfVA3N8uTeeYMQLjtwhoWtIOReyYnfEDFmDGyT9X66onnEI+TnEQ88RhmmJzp/mB6c2wP/NFI6iYviNDJZBYVM0i9u4rVCRQyr2ihK86QNXFfHbXtOdlp6mBht3Ab+a42bVp9H9LOF4Y+29909Sc15LgOFBjSEpC81WWdBMVNmASnZCjgrp3tnE/vn0CqNdBpq2lu1CKoH5B8oNcfcUfB+j2/cr+qykqW9aVf4wk8XUk9C3csa/GfdFM1wpd5VLfCWqQdCvfL5t3Q+IxgfNTx0NMIo7Lwd1nh48QMbP7enjME9mnl7jvjod56RQxbGNBtm+2bYNPrZRwK1IN44Dd/+yTZKeFbfG4C6blo/2lTs6hi1NcFdbVtAY81yd3Z2aUG0eOQ2jyDRxVrfLG4BIJMLLMjMju3x67ThGyPfE8I7Cr+WIEQ5jZUblB298N7iUDS/pHNd6ixBZ1ZqgDbtdEMpLgkuUX2KMNDjyRaHl6eCaMI0v/qt+HYYo5g/74vBNEBIOBe3vxbBKE1uUbaCYLPTMkhH/ZZ3YAkA5mhXHuwjcMBS3FruMcBaXltu3pvUDLf1o4qeeMn7Ajt4y39alcUHN6mY/SNsQbrlAHm1IlVXjk5T5vOT4MtF+WntRaBELdHRDeC9+oRw/AZQ8pD+rpI2u5rbLFpEJVxcSncSk3N1aOOXzOwYeo8Rh5u3XcnTFq/8DuIFrjreHQ2SVX5npq7KtqP2CTYpPzuDVMMyhR0JvpetUG4xsMdte3BQu7MnnRRTesN3hZU9cn7mMGvot4leTuSm/kYDbU6eW2YPJDfhlnxqRm1gmSYG28Audm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(8936002)(31696002)(86362001)(478600001)(6486002)(5660300002)(558084003)(2616005)(36756003)(186003)(31686004)(316002)(54906003)(110136005)(38070700005)(2906002)(6506007)(6512007)(38100700002)(122000001)(41300700001)(91956017)(53546011)(76116006)(66946007)(8676002)(4326008)(66446008)(66556008)(66476007)(64756008)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VThJQTAvbzRXVlpXd0cySTkrUVZ4R24yMXREUVNFZ1FYTjJUUkJuY2JBZVN5?=
 =?utf-8?B?S09DZHRKVnBlUnhBRjhmcUV3NFJ2c2hxMncwVjBjUnVSVkFVc1JwNXl4MWF4?=
 =?utf-8?B?alM5RGoxRkRNbk95MWhRaHlJUFl5SzFueVpOMEk4ZVlHcnk5YmFNU2R4YXpY?=
 =?utf-8?B?aHJnR2tpZzZtT0FsaTRFVFhoVkZRWDZ3ZzVWRlZnTVBRVGtZZzZXTjd4NS8v?=
 =?utf-8?B?cVhSMFhFc2JmLzBoL05XSjFmMnpsVWZxM0hsYlBHV0J0MTQxSXR4TWlHYTdt?=
 =?utf-8?B?SGJXMHdKbXJGWDJhSExyS2c3UGhaWllLb1hSdGtFbFE1NzJiSVdWMXlmVk85?=
 =?utf-8?B?LzRETlVkRnNtYXRvbzVWWXdJdXVHcDZFOGhMamV0dnlrVXJEMG1kc29QK3ZC?=
 =?utf-8?B?KzlCekY3SmZNZkE1ZGtHeG9wS2plMHpaVElpRFVoT0x0Z1lkNk9kNi8wcmtH?=
 =?utf-8?B?bFZvOWVrSHhCOWVDWis0QzVFeFlnQjhSSUp6dTdmN3NkaUV1M0xubjg0NC9u?=
 =?utf-8?B?aWMyQmx6QzFoblhLMm0ybnB4eGxmYmFTQ1QrUnd1SzhQOHhIZzhKMjhSWGhI?=
 =?utf-8?B?YXhIWWxzaEZONGQ0QWJ0eUFDbklXbGdlRmRSRzV5TXNnZ1FKYWlCRk5QOTVZ?=
 =?utf-8?B?SlY0blY1ZCt2NnJ4Z054NGx6QXZrOWRnc2FocEU5cUhzY2N5YzNKb09MeG0z?=
 =?utf-8?B?c1UxaFN0ZkQzb0RBUjZGdVE4VkU2aUttS3lYL1pISytOdDg2RWlNdWN6Umc1?=
 =?utf-8?B?bkcxcUZJQzFVZHZTaXphSXF3aWZXdFFaMWFRZVFSUThmdW15TTJmSFRWNlhJ?=
 =?utf-8?B?UWVnbzhrdHptUGUyL3UvK2crb0E4ZkRSMkY4RW96bStpRXNuOTI5bllWTXlO?=
 =?utf-8?B?Q3R1Y2hBSTZ3TFRZcVpwV1RQck0zSnFYL1FHMjhIL0R5czZqVWdlMUZmUXY4?=
 =?utf-8?B?MGhVYit4WnlVZGVkTDdnZ2s3ZSthU1dTdXJSSTdkMm1jaVRGd2swRUh4bHRN?=
 =?utf-8?B?cGo4SDI3cVovQTRXSE9mTG5PQUkwRm1IQWQrVkp3Vko3ZmMvYndzL3ZNbEsx?=
 =?utf-8?B?enYwaGRaaXhLUDR5ZWYyaEpHMWJSNExJVUwyNVRaUG5qdEFKOWhqSEdSR3Nj?=
 =?utf-8?B?NHJjdHArRk9Xem5sWVlFWFFVMnord1BJVkpZeHcxNncrTWF0eUR0SHBlMFEy?=
 =?utf-8?B?L1BlcGVwYWlUaEN1MGp6bjJLdXJyc1hOdExuNUt0Nko1bWtmTzFpN2pJY2ky?=
 =?utf-8?B?QnZIWURiQVE4ais0M3BPQ1BGV1AyV3NhamYvekFMSzFENGkwU1dzMmZpWll0?=
 =?utf-8?B?RXo1T21NRzlQZkNnQ2ZtV1dGUTc1ZE9CM2dReWN1NUFNekJCRHN1eVUyeGFz?=
 =?utf-8?B?OWhqTFN4RkcvUmFhN3llWkYrcEF1S2xmbi9iaTM2RFZhTzd5RE52bzlqcDIy?=
 =?utf-8?B?d0xjeXNrVmN6cXg0bmRyQjQ5SXIyMmIyZGd3WlJOQ2o4MFRMbnpVOVFpZHhJ?=
 =?utf-8?B?SXFFYzVTejJPS1MrZENXa2IvL1lLZXRsaFpnZWNzTGFMelo2aUZJVW5xSTFX?=
 =?utf-8?B?WVZrbExoNmVEejhDNkJ4WE5NMkpMQ3VNU2p0b0ZXSzk4T2tlMlJHYXFuUGU0?=
 =?utf-8?B?cHBjbmlPckZZUzdQUDJYbC9rSkdzaTRjV2tiM3E5RWtiVHNxckcvS2NzUWx0?=
 =?utf-8?B?NW9PWWQrMjVVc3FHenFkTWt2RzQxbGczMHFpdEJFS012WE5LZHgyMnl6blJL?=
 =?utf-8?B?NHRqTnFwdVhiRE5pcU1FVFNKYU8rNUFka05RZEdkMm9senRjN3krRXQ2K0Rr?=
 =?utf-8?B?aHRnazlsV0Y3Qkg1TXJ6WW94RFJWTFFlRXFvRUJpL2NMSzlwKzhTTkxpaEpr?=
 =?utf-8?B?eUVidHk5Q05GSjdWRW9BQ21PMHdJaXdYWitjS1NyeTFZQjRRaHVLdUxSSkpY?=
 =?utf-8?B?ZFdBa3lOK2N3WlJlaHlSQVhzU2l5WG8zNWtoSlBOTEdodTRVNU1vWFRLNTJ0?=
 =?utf-8?B?TDFiaVE3MEp3ZDZaem01YUJ5eUFsV3E3MVhrclU1c09NZmFhL2N1ZHRHTktQ?=
 =?utf-8?B?WmxwYXUyVXNDcS8yQ3lJQVJQN1RaL1dtQ2dJSjRnUjVyc2xmaG1iNW9OcFBO?=
 =?utf-8?B?Z0pWNXRENVVjck53RjRSU2JMc2NhL3Z6a2ZIK0FBVTVML1IxRFRuUnAzRGlP?=
 =?utf-8?Q?vlMVPIRd6v5zMiz28DaKttZkyKVg9apUDQUb2krWzkx2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB41F8F8BE167D469DB731487BED916B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f535b59-a342-41bb-bd90-08da5e51b183
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:43:38.9596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VCtRSSO/pB9J/JXJLec4/8VfHQyr6bnvFwFEtDw4VbHUM/UYyjVd38aCWHGTx/zICaKVWPlGFLIqGejK7nEQ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUg
YmRldiBiYXNlZCBoZWxwZXJzIHdoZXJlIGFwcGxpY2FibGUgYW5kIG1vdmUgdGhlIHpvbmVkX2Rl
dg0KPiBpbnRvIHRoZSBzY29wZSB3aGVyZSBpdCBpcyBhY3R1YWxseSB1c2VkLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQoNClJl
dmlld2VkLWJ5IDogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoN
Cg0K
