Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27914C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiGEGZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGEGZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:25:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17606A1AB;
        Mon,  4 Jul 2022 23:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cO3ZNcljVRE2BjtyizW/njmjN3ryNVlJyeVZS3MgIGH0a5VFVm9Rq/tzfE+bbWDbSTgTfdh2PLgZ51H5/T4+WYF3RqFRu5ewyuRpTWeiI9bnI96boS87JBrWWDLqU+pI2tJV81zx28BXbaw9KtsPEPbx6gak6+aANWkdrlmyeEZbGuRBjKXREAggXYfd+AmG8m+cOqmGfaTXOVY3DOOp/2b44CroQracFjfIDanSberi0dKyX1WqdvHo6Sxk5/OAkObi1irvbk4DriTQ1nXQ+5V5YAQCWGM3k2S/jFcNYanDmhx/dnkjL16xDjtZWhLd+paFfpIG3nQFzyMB247a7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxjcbpOXPEPtw9UB3XZbfkrmFcKhtLMb0gMvEFm6IRs=;
 b=ins6at5X4R7bVf5gYsJQXuOFWba0qVzzqQ2Kjp2eKTBafdTWXWvSnHh758LaUD6arupdzK+sJhRb1G68bSEiRtoWxdHF1iR/4qUqFFLPZvKR1Tkrh/O1NFDc6VqZNJyyluf/Sm/y9VPYpTnLpvwjn0On4yiqy5tkK1TBr06IqUHzSUu0mrP7/iokndrUbkNMbiQ8Vs9TQif5hbM82rHqeuQgjCJU6xURGJxnqB+NK6YN4sXufQB+MC6T1Us3ZM1mo5FiJ6V3QiHlVcgPxQh4gc7REaPx/02fYSNEDUqVcm84kvs8xvGpUYtz9JSGho+9ciOXR5IhsazVqZyQ8DOXNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxjcbpOXPEPtw9UB3XZbfkrmFcKhtLMb0gMvEFm6IRs=;
 b=IkgbxmBwkL9eLlTbsqsUbb0AyntcVGcIzZQURTEhPPxZaZw8xpHgSmhCwSzmt4fH1kkTuIhk/rw223ULBIeITbEdrsijUw3CYeF/t+HT05ZH4JgykcwkUluds37Vx79bVIuB5jJnYyD/k59GnqIcrVxxA0zTgIEguu1oUWnNDtX+ycNxEHQmX0zjr+me3x0NHeNOX++qsjMDaWm+g1ODU64Nau/LPVZnDGWC0nz7NtzkV5azz2hHzJNx0jAlgKBNqd8a0LyedD1MmeuXU+rNk1Dv3pOjZcXT7bYQgeK7tOk9ykXhylEH/sh3bwdjNFPisiMyp5fNJInffZ8+ozHanw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:25:00 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:25:00 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 04/17] block: simplify blk_mq_plug
Thread-Topic: [PATCH 04/17] block: simplify blk_mq_plug
Thread-Index: AQHYj6PwIC3ApSu660W2Xk2WoLNgQa1vUKIA
Date:   Tue, 5 Jul 2022 06:25:00 +0000
Message-ID: <ef027919-4daf-b167-cb8b-157ea7b55397@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-5-hch@lst.de>
In-Reply-To: <20220704124500.155247-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d582d633-8873-4b64-fe56-08da5e4f16f7
x-ms-traffictypediagnostic: MW3PR12MB4523:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NDuQOT6zs/CXSQrcdu0uFm/i6gekwTWP9TQPeCwpKvbejI5bHu1DwIsXDv5/TZyLm10G5FBVrTCoiHcyR0NI1h4F2wTJ6s82ZNr+cj9xWz1Do/kGmxEPXpHFSSuYUwXblylfAOtq8w6eudks8n6WDLVV7eKPPPrRhj++b0wGDwWfOau0sCp46kGK7Uq0V8kIozI5EWOhA98YpseFT2B9zpuuUk/laD3M305hTwHCnVJ8T3vE12OVwU80ggqRB0yitY7ITqoTIvq1PT0ghCVS6NecZSzk6mIX2fFukxBavn1S2ErqIg4+bbzDmVZffiNO+LBFFleUDpNCuwcNFylSLYwjZkCI3mB6MwnIHEaZ3jLoVL2JSti0Q5vB7G2NvfvJ8zFoqTuuUSmaRt0o7367PpPk67Y2k5oXDViStB5I35SpZSFjribvzRlOVWUikow9eeAtU7rQajuCpiwTs/tHiOu8ssXUnaMK4e4L40pPWiDzYuhG2RbJ0oOTOP2DGbbRSTV34fp3tqZAJKe3EbXb1Yj1/RKQiX+oHxFlNSRNyNZzkIPNfQilxLicprxWPeNlQC/9cW8CT0jTK8CWSECXdYlqp55xcUq4aQUWaaOBSEBUvNwCQgHhA2jlpOHf+H5M2OeSjhvxzcqEJTuYCtSxt+E+YAfcnkMxurDoOtsm4/SWF2yG70OAXvfCmrnSrudiwygU0qahTIY3jO5cmHdsAuZ93AEz9ikPF1y71VpcGrtHMKkR1/l3s1xIoFXLGPlCepk9LUKHhpSQF0HdXzmLu+srYCZ/AQG02HUm8rQKaWNx3eUV0y5HB28IhLwMpOQMJb9ulBlVC4QH86B5gnqtPti4tQY6mgod5BNv9Y8uldMWzrcaRk61PzlNDzpgFL9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(6486002)(91956017)(76116006)(6916009)(31686004)(8936002)(54906003)(66446008)(66946007)(8676002)(66476007)(71200400001)(66556008)(36756003)(64756008)(5660300002)(478600001)(316002)(4326008)(38100700002)(2906002)(6512007)(2616005)(41300700001)(186003)(53546011)(31696002)(86362001)(122000001)(38070700005)(558084003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1VkUjAySHV3b0Y0S2I1OEo2SURkZmRRNmwxbTlIMjNlU2Y5RkN1Wms1bit1?=
 =?utf-8?B?SHdEWlFrSFRLUGl3aVAzQzZWbzJ6VUNRVmZhcVBaZDJTYVBsazJzdkhDc2pS?=
 =?utf-8?B?N082UE9tc1hrbVhYbSt0YnJXT2g3bVFVVHJwQWpaMVFrYmVPcjd4cW4vLzAz?=
 =?utf-8?B?WkdBSWtNNHlGZ1I0NXdJM1AzNXdWR3VGdnVtb2FScGt0YVhTVE9wQjUrUFJL?=
 =?utf-8?B?NThvTDlJeCtUSEY1UnQ4M1d2Y21mbGpBSzBFSFpFK3l2UFhzazVtNzFpc2cr?=
 =?utf-8?B?TWhYV0NaNkxZT21IZGZOT1hBNHgzeTlXVHNhRUp4R0d3OEt2cm9FdmM1VlpX?=
 =?utf-8?B?c1ZrWEpac1I4dm5hcEJEVldqN1BkeXBkVkRNUUpDUFIwM1hkSG1BMm1QSnlh?=
 =?utf-8?B?YWFpOEZjQUhSVlpHWHpORm12VkpyUnNOS2d6c0cxSmgxZ1lTWVhVQ1QrMXY4?=
 =?utf-8?B?dk9qbTJINllBemllT1RpV3dFNlRXNmhJUG16VDQzMWxQeWZYWkhuRXlscEpJ?=
 =?utf-8?B?am5PU2xiV2ZwWDVwQkFHa2E5Z0FWQ2ZBL3A3aEs3KzBaT1NJZEw3T2ZTWXY5?=
 =?utf-8?B?Y0lUTUduUW1zM2lveng4UmJzUDhxZGd4VUhBbWN6aC9maHlJSE9JTnJ4V0ZN?=
 =?utf-8?B?aXprWjRMeWxvOExUTmh5aUhGdHVCUXRFdm5vU0FnWHp4eEJOcDhxajJ0L2U3?=
 =?utf-8?B?ZXl4R3FkTXRxVGN2bGdHU0tKZ2FjSFFIbG83ZG5JL2FWbDc0Q1ViYVNCUE16?=
 =?utf-8?B?d05SdnRZMzdPanRFVXlDVlpDL2kyK3VabGZDbUdZZXFKa2paUXAxWWwybWUw?=
 =?utf-8?B?M0orZlI2czVNNzRBVzV3c2ZWRkhVSGJqeTUvL3lSaFRTbXNRbjRLaTZLRFV0?=
 =?utf-8?B?cmw5UDJLekJuc2VJSm1SRU5MRmxITVBjRWprelduTm9JMUlyR2E1bzFpZFRw?=
 =?utf-8?B?WHdGZ2d2VDZjMUlTS1dmSWxvMElVajNLSE5WQzYwM3ZYSHNTbmNxbW1odjFS?=
 =?utf-8?B?NjB6OWJ0NWh0WFMvQ0xkQXhpMlBVVkJRQnVpemlKNWl4WXptdFJGUDN2UHll?=
 =?utf-8?B?Mi9vTm90Q0dSWHZCcVRvUWI5Uk05aW1NaU1pN0NueGxPOVNDeDZzZXlVWjZo?=
 =?utf-8?B?akFSR0VCZ2Q2VVY5dnlHZDFXemNuc1N4MStuNmxEMGpROUJrbEhCclBrWmUx?=
 =?utf-8?B?SjcwampldzNab0k0NzljUFVSNEdpcDUrcVMzZHA5Q0hiTm4yOEYvT0F2ZzQw?=
 =?utf-8?B?NHJrc3pqM2lnQVd0R25KNkpLdURrWW9oTWJUTDM4KzFSZ1dWenRzNDVSRW9C?=
 =?utf-8?B?eGk3OGFjTFQ1SEhlbkRIWHFRZzZqME9UQlBzUk5HNUpqUThjMGU3dXdEcGky?=
 =?utf-8?B?SSt4dkhuYnBZSjl4NTNOZUk3SnVSMy9UUFhPOEtvdWY0SHZxSFVIeTNNWkx6?=
 =?utf-8?B?b3BBZUJOUkU0SWxwYW16ZGw1WXZPNHJadnpOMTR1WVpUQWxmMkR5bGNqN0dk?=
 =?utf-8?B?QThEZkZQeGFrZll6d09URkVscUNVTkxpTFZwalFtc2l5WW1WNmRycDFGSXRt?=
 =?utf-8?B?N1ZmMTUwUDBKQ0hWTWNPVlBmYzQremZGNjYydjk5TXpoTkcwVVVjcHBqbm1M?=
 =?utf-8?B?VUJ5SkNwL1QvamVtTkF2Z3RoQW9mKzQvNUZLUGw3NUZxSERyZkFpL0VWSldN?=
 =?utf-8?B?ZXYyYjNQdUtZRFpPUkRnT3ErZGQ3d0U3RzE5bGZTTEFUVjhRczZFMWN5Q3Fm?=
 =?utf-8?B?MkNjTmh0WlZySHJadlYrS2RxbzAzVUhaZ1YyNzRaZ29KMVd4WDFMS3JlZERI?=
 =?utf-8?B?VTY0dStvQmIrYnNNR0M3dER4eWw3VWJ1RWVJYTBkWmFveVZKd0QzUm9GWmdW?=
 =?utf-8?B?NG1EeTdJeVJ4UGFRSjhORkFadkxrOUdPQ3A2ZDIwSHBySm1zYzlrVS9rSlVz?=
 =?utf-8?B?YUJDaXpWcTBIeTRYRGlQb2RnTUJuWGhLQzdzaFRUcFRNaFhEN08zTU0rZ0hZ?=
 =?utf-8?B?R0pvRGIwMit6UUFDK2tkZ3ovcnVraitrRlBKNTdzY2JOODJLQUhHazBLUzFx?=
 =?utf-8?B?VktoSnQvR2JEVVdFaytwWnA3dVV2QzloK3ZnNzFwVWtYU2hNWVBucHhnUGZn?=
 =?utf-8?B?eTltbTB4Rm1NbDdxL1Q3UU1NczRSemhkODE4ZmRpZmlGWDVRRTRLYlo0SVZV?=
 =?utf-8?Q?qKtydlWQUh7UyoMnzRWjiqwdUzvyABDK7mxTNTkGTY+Z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F644D290EA2C9248A844FBAA9388F2D1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d582d633-8873-4b64-fe56-08da5e4f16f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:25:00.6500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzG3BAltTbnBif5mXIwIx/tVFwUXKLyATkjLVNzN+iopoeK83z6MvVAyezVvrU5BVQt+jlZ4HAf5kDS6q343NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IERyb3AgdGhl
IHVudXNlZCBxIGFyZ3VtZW50LCBhbmQgaW52ZXJ0IHRoZSBjaGVjayB0byBtb3ZlIHRoZSBleGNl
cHRpb24NCj4gaW50byBhIGJyYW5jaCBhbmQgdGhlIHJlZ3VsYXIgcGF0aCBhcyB0aGUgbm9ybWFs
IHJldHVybi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPg0KPiAtLS0NCj4NCg0Kd2l0aCBEYW1pZW4ncyBzdWdnZXN0ZWQgY29tbWVudHMgOg0KDQpS
ZXZpZXdlZC1ieSA6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0K
DQoNCg==
