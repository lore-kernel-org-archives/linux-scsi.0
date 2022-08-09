Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99C7C25B07
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 10:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiHIK51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 06:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiHIK47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 06:56:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88F5FB6;
        Tue,  9 Aug 2022 03:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0p5BfDuZs+hZ8ZtrjBJO+hlUUA+0z3jYNWHL4Ohy7iP96UWyTBOU8yijvb3vtB+z64DhlvXGip1+HKumXHb8i0CSa3DK+NDI9QoFgo6eOb9QMi7YFJbG//jXgWI8H1U2nKyo6dG7qnmUutO4HQDxdpfiSb7HQeLGf4sSJoBVqh/k582TbtTWJtM0iy1rPaN7SYALhiwdr1y/uEGUt9ZJYI6cRgcvfAcG6XhPq6o4bcmw+PTWN4K5p1N3HSaFDC0Qujh17AA5VVGFFYdOuubhdsL1KBGPU0eGU65Shdsucwk9HA5spEFFFTk4L1ehxCzOYV2cNwiOkF8DaqrOlN9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WNEUH+Mj4aDBa7wkM56RT0Cd6qjWBrV2Ix9WGbmfP0=;
 b=WkffUQw7fqYcjimf3eVSvxLQ5xoKq3w8mKwNsEtRLwTFFI4RhsqqwstP66rBP+cxiuP5zUZc9LKaSgMYlw7P+KgO/Rw9Oge7IHwBjxC6UGHWe9I4CaQ7qxIa+leWJdti1lrbpgaBP5b71Wbd4iGF9u4MFSyyLnZrw/Anp/nlekzPZw1jl/Ih224aW2H0mJ/BqKpGU9bX2JZT/3POSH0y8VwkQry0keFxh+1+DIA+ytHN0wPIGlzifjb4mbkhmMEdqJImY9DJ9rKrfsDDHbcIer1S1qzAzLhbHwRyxD97lAQ6IT5S17BVpScssu9hNgT9pCIuf9rJT5wtY0KKg5syPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WNEUH+Mj4aDBa7wkM56RT0Cd6qjWBrV2Ix9WGbmfP0=;
 b=A1JzOy1P2cutbGx+KQp6m5NvG5JztexkKAbQJJvysK+17HtHskbQQjXQBlSEu6gnP283EFLCclb21Qpax8k36aBHnVsKnjnMgFov0RlHVOBU4zAvA9JLW3qQpd2cJ1MqAd8Yvy5eUj07ges1WX5CbAree1zRtyGBzD007iHyd+kveDfDQOg7M2OHIpEwNjNSentsEAk6rByIHkh5FUryMBo4Phm+vrzoEA47u68BNCKlzEnME5H78TKr4vxUzVNwvXcUBYv+dEGdFwDCakTsXlCslNDXWRwLn+1hTM2Ta0znYEtKoKcVFyuc+DVl00GoqT/lJaJB8ZI/gZNin3+2Zg==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 10:56:56 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:56:55 +0000
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
Subject: Re: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKA
Date:   Tue, 9 Aug 2022 10:56:55 +0000
Message-ID: <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-10-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dd8b323-e501-49f3-f9bf-08da79f5e009
x-ms-traffictypediagnostic: MWHPR12MB1248:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jlcXd4BF1Mv5L7olsdpngJ6l2JrDiDK32Nf+Am4BqyFsMRIsuzj2sGKGjJXNA4vDw41JPDp7IAzWrNv6Kjldk6tasRaia3ZIDAYCGYhaEMl0VRaOtQ85HmjgOSNZ0WkiF1byGRaoVSm/+gyAqZgSXigYrDLW8GXgBCe2ym3EOnvYS2hjLojgBl8E9tn02uDT/zGAEsP/tKhbsa7Uo9msJsXCEerKHlMLXzn8mkyBT5luzfwiTGpSX2Kr+q2PGnK2ETA0HJLPpQNGu/Ou7jYJ0wwI7IJlqZZ/5TAADkBBycTW9ZdTQAfVrWOc7inLLEB2zL2Z6iA9fPB3GKmNAMk7i8gr3aXm43f/bKMNWQodmy9CU2MUh5ia+uU3cQJDWiVhvmGSqwb4LnSgsFxTPdLPZDY2EvBSj9cCUKO6LevFU46HaQX6/8tUm4KB4wmORZO1Q9GhO/NgdOaxk4VVuavB0we54tgnm7fDWynJ28ckMdrPDobXLV78pML+cXvDs/6Q+N5/UF2yUVeGwKhcmvNpDuaU8Yst/9VTsMcucAlY0xo1Eu0xa+HLu9LrFi3V1L/kWaHtl0TR/i3tgCU3LbwyMIE5o+QDMgQGF+UjRbd0uSWj8l7Nx4iwFCZJBctze5JwgyGuQxC8Iy35gZPupfWG5zq0TMSRpib9BRjUW5v8jzywmufl1+RpMEaYOFUtCQo3Xt+zdP6rKhwjUWvQ+prX3VPgBXd7mkcU1WWaboB9kfSOGClIR7dRRzKOsEx73udAfY0Z0faDZXwyr1YZK/3Gtn+KHbZohgkNyVSh26GWOS8mFZBRGbBqkwE/U8DqXaQanv9BgWt+ZSYprciWhoP6e+RiyAyLy8Rm5v25AnRpEms=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(186003)(36756003)(41300700001)(71200400001)(8936002)(5660300002)(31686004)(122000001)(2616005)(83380400001)(2906002)(86362001)(31696002)(7416002)(38070700005)(66446008)(66476007)(66946007)(66556008)(64756008)(38100700002)(54906003)(6916009)(6486002)(316002)(478600001)(4326008)(53546011)(76116006)(91956017)(6506007)(6512007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGtvNWs5eDNQSWExUjdxMVRySWtWOUVEL0tzZ0ZyaDA0Q1drQzN0YXBnN2tR?=
 =?utf-8?B?TjRLelpSZXQ4QkJsb1hsOHlpOEYzaHZaRlUwWTZra1dXeXBuR1MvNndvTFFD?=
 =?utf-8?B?dFJtWXgvN09kZHhTcDFHN2gzWjV3bElTSEd2Y2dYbGFjaldOUlJxdW1BNm1K?=
 =?utf-8?B?YmMxU1ljbmVJMStsalRIeitGWkdhZ1V0RkxaalVmTVBPNFpZaGJDWHFTWVo5?=
 =?utf-8?B?NmsvbldGOW05RnhLWlpwN3J2dFVYWXk1dDdlQUVlK2pmNmlzOTQxZ3dGVTZ1?=
 =?utf-8?B?ZmsxWVJ2SWZxUm4raUkxMjQvczV2RmxwT1VwSWE4ZUZoTVliTkFMN2V0SjVO?=
 =?utf-8?B?Q2Qzb1phTmQ4TURTbGRhbjVCcjhKdzNla1JjVW5SSTFvTjkwZXZidW53UDBr?=
 =?utf-8?B?M0t6T2Z5dS9IalN1OVZjWEVPcFFXa1Q3TkRqT1AxeW1MNmhGUUdCMEJnY09p?=
 =?utf-8?B?TTlGMnNpN2w0a24rY1RKdzlrTTByREpwT0pLSVRZazlYZVpkZ0p3TXB3WFR0?=
 =?utf-8?B?SC9JdVBnNlN6TjR4VmF1ZFFYdDRQVTFOa1FtQlg2cm1YOXVLeEZSM0czTXVK?=
 =?utf-8?B?ME9CWHdOaWxkVjVLTGNyVDg5aHVsV3JZaDhqblZPcjJ5ZUZPNG9uck9RQUFq?=
 =?utf-8?B?aGswNGtVRU53NjlNYWk0TTlraU1CZmtvTTJnV0ZCNlhWT1Uxd0J6eE9sbk1r?=
 =?utf-8?B?NUhSSFNKNHlaOXlvRTgzQlQxR2NLRGdCaDNxSGVJdVRtS2d3RlZwdTZ4bC9N?=
 =?utf-8?B?bWI2cGU4VTdiMFZRZkxEYmdWU3RMS3YraEJBSGNQbFJ4WWxNZ1p0U1ZhYlVo?=
 =?utf-8?B?cVZmcEU0L2RDeURiZUlhWVV1WFJDejdaWm95VnFCVWxHRjgyUmcxaS9tQzNQ?=
 =?utf-8?B?b3JMbGEwcWtLa01GeXovbU16citnclNEOVljUmpHTGdMbnMyMlBrcmlGWjlU?=
 =?utf-8?B?NXVMWUhETno1V1ErVng3RDdGNWhqYmt4cWpDZ0Z4ZlZlZmJJVlZWNlU1Y04r?=
 =?utf-8?B?YW5hRkhCRnFjVloxMGY1dmMzcFRlNG95Mm05TUJsakZXWXl6S2xPNjBNREV0?=
 =?utf-8?B?clVROVRxbldRdEl2YlV5aFVRRW9FSmdSSkpNb1BJaGYraEpCVmsyM2Rkbkhl?=
 =?utf-8?B?LzZnVE5DL3I1WVFmT0F2djRGeUhpQzIxSWUwQm5qTGZNcUdwOUdhTklLczFT?=
 =?utf-8?B?RlFEU0NzcEJMbVdGTTlZb0JMVVNtUGFpUXhkT3NUV1lKSUt5bnViK2dScVl6?=
 =?utf-8?B?OFpNVWpPYU1qekFMMk9QckZJTXpBMUJIZ1psTFZCMmVGZlI1U29RUHByelFh?=
 =?utf-8?B?VTZIZG84M092WFp6SmlSTllpZlBLV2VNU3Nma2FjczFYVC82MkVUdWV2ZVRn?=
 =?utf-8?B?WXBqNFoyWnUzNXFja0FpMkZJaVdOSTJKQXVTQmZuc0JiZlRqQ0k2Snd3ajRs?=
 =?utf-8?B?MHBYZWpjZWd5Zml5VkdPWXBYa3hxdkt1RW5FWnp5aWQ1bHhlakhzMVVZY2pW?=
 =?utf-8?B?RlFOTkc5VVpJcWJQWUpnKzBPNWFsdmJoMkxOUk9lYWJyeCtlampmWjRGVzRw?=
 =?utf-8?B?VnQyTDZLWFJrWDZzUjV1dXRzOHdsNUNheTVHL29IZ1ZOOFlNdmpneDg2L2Z1?=
 =?utf-8?B?SGVULysveisxTXVQK2ZaMDVmd3VSTmJ3NjR6QUwrZWhKLzJIT0kvU3Z4UHV6?=
 =?utf-8?B?WnhXM21LZnM2TytsV01xYmFiZ0tsOGFtMjd3cmF1dWVXdG5BNGZSemJna0Np?=
 =?utf-8?B?YndaMDNHMVpxMTRONXBOcTBDVWxvdEVOZXZvMXVHdHBHRFNtUmtBazF3ZGF3?=
 =?utf-8?B?ajJpeDNpY282c0EwVHNCbGtnQ0YzTGgrMVN0MHdWM2V0TUZGc01ldnFQcFdi?=
 =?utf-8?B?Q3Q3VnIwWTMvQWxjSlBwK01uR3dmSUFuYkJFejlyTGZaYkhDTmFjVzZ3YWJD?=
 =?utf-8?B?Q0tZUFFuRTFwclZwRkdMYUR6VHNMMWhBd0JuUmNrMjhZRUMrclJtTzJwQnQ2?=
 =?utf-8?B?M2xaRGt0VUtPUXIyNk9GSW1qVFZ5M28rRFV0UTg1LzRwY3Q4V3pmVDRIUlVC?=
 =?utf-8?B?R0JIQ2lMZm5GR2RWZCtyczBWeHVnM3dXekNWZGlOaDJDalFZczZMREJYK1VH?=
 =?utf-8?B?YlZtM3g3K0ZXNGhqTUZTMEFycmxjZDE2WGFuaVovbDRVVTZNakw1YTd3WUhL?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D730F7F27B5C23459200EDFDFBF771B0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd8b323-e501-49f3-f9bf-08da79f5e009
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:56:55.8576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJDCHhqomGw+VqzXeAtetvre9qeXWY9ekcS3VWsecoHC09MBOzgf2ttrcQ1K5cTxXGxY2lXxs/bIrC/4n6xuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1248
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC84LzIyIDE3OjA0LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBUaGlzIGFkZHMgYSBoZWxw
ZXIgdG8gZXhlY3V0ZSB0aGUgUmVzZXJ2YXRpb24gUmVwb3J0LiBUaGUgbmV4dCBwYXRjaGVzDQo+
IHdpbGwgdGhlbiBjb252ZXJ0IGNhbGwgaXQgYW5kIGNvbnZlcnQgdGhhdCBpbmZvIHRvIHJlYWRf
a2V5cyBhbmQNCj4gcmVhZF9yZXNlcnZhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2Ug
Q2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVy
cy9udm1lL2hvc3QvY29yZS5jIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL252bWUvaG9zdC9jb3JlLmMgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMNCj4gaW5kZXgg
MGRjNzY4YWUwYzE2Li42YjIyYTVkZWMxMjIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYw0KPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMNCj4gQEAgLTIxOTYs
NiArMjE5NiwzMyBAQCBzdGF0aWMgaW50IG52bWVfcHJfcmVsZWFzZShzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGV2LCB1NjQga2V5LCBlbnVtIHByX3R5cGUgdHlwZQ0KPiAgIAlyZXR1cm4gbnZtZV9w
cl9jb21tYW5kKGJkZXYsIGNkdzEwLCBrZXksIDAsIG52bWVfY21kX3Jlc3ZfcmVsZWFzZSk7DQo+
ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCBudm1lX3ByX3Jlc3ZfcmVwb3J0KHN0cnVjdCBibG9j
a19kZXZpY2UgKmJkZXYsIHU4ICpkYXRhLA0KPiArCQl1MzIgZGF0YV9sZW4sIGJvb2wgKmVkcykN
Cj4gK3sNCj4gKwlzdHJ1Y3QgbnZtZV9jb21tYW5kIGMgPSB7IH07DQo+ICsJaW50IHJldDsNCj4g
Kw0KPiArCWMuY29tbW9uLm9wY29kZSA9IG52bWVfY21kX3Jlc3ZfcmVwb3J0Ow0KPiArCWMuY29t
bW9uLmNkdzEwID0gY3B1X3RvX2xlMzIobnZtZV9ieXRlc190b19udW1kKGRhdGFfbGVuKSk7DQo+
ICsJYy5jb21tb24uY2R3MTEgPSAxOw0KPiArCSplZHMgPSB0cnVlOw0KPiArDQo+ICtyZXRyeToN
Cj4gKwlpZiAoSVNfRU5BQkxFRChDT05GSUdfTlZNRV9NVUxUSVBBVEgpICYmDQo+ICsJICAgIGJk
ZXYtPmJkX2Rpc2stPmZvcHMgPT0gJm52bWVfbnNfaGVhZF9vcHMpDQo+ICsJCXJldCA9IG52bWVf
c2VuZF9uc19oZWFkX3ByX2NvbW1hbmQoYmRldiwgJmMsIGRhdGEsIGRhdGFfbGVuKTsNCj4gKwll
bHNlDQo+ICsJCXJldCA9IG52bWVfc2VuZF9uc19wcl9jb21tYW5kKGJkZXYtPmJkX2Rpc2stPnBy
aXZhdGVfZGF0YSwgJmMsDQo+ICsJCQkJCSAgICAgIGRhdGEsIGRhdGFfbGVuKTsNCj4gKwlpZiAo
cmV0ID09IE5WTUVfU0NfSE9TVF9JRF9JTkNPTlNJU1QgJiYgYy5jb21tb24uY2R3MTEpIHsNCj4g
KwkJYy5jb21tb24uY2R3MTEgPSAwOw0KPiArCQkqZWRzID0gZmFsc2U7DQo+ICsJCWdvdG8gcmV0
cnk7DQoNClVuY29uZGl0aW9uYWwgcmV0cmllcyB3aXRob3V0IGFueSBsaW1pdCBjYW4gY3JlYXRl
IHByb2JsZW1zLA0KcGVyaGFwcyBjb25zaWRlciBhZGRpbmcgc29tZSBzb2Z0IGxpbWl0cy4NCg0K
LWNrDQoNCg0K
