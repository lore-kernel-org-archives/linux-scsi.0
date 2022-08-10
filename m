Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C415C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 04:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiHJEyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 00:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiHJEyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 00:54:22 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CCF82FA9;
        Tue,  9 Aug 2022 21:54:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBUuxMHxPqs4GPiNrA122Gj3oPLC4MmjZpex54ZvmjXzoIyPsjP4Us2dgj2IdXskuI8QjCrmGG0QXetDkkRNu3VxVopo7bAu8Ko0A/t8Dc7yPJh5AatDQ/8pu6iLzgE0zvMzJgqFcesn0RI2Rgd/NFk3N7BjDcLfz7Jk9JuzKlG3nbyfevZMA79LPtUIOLM5EY/R1SEraqJqzSUyzTx8d/GNShnCmKaWf/k2JN5mm3DvUHDiIEtPRtpiUuQ6K4T+aHAQ4EYe5blNLbRh+FkkUFgIlj1t260BGLs8w1m3yPWUPBpRwB0IedStsHzPPeMjTQ2Vzgxzq14iDN2/dtIS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcpjeaioTsbdN6FeC5QDCGtVT+HxTILzFAuMcSse8TA=;
 b=LKbsJ43pgYVvgVCDsGyFm65b7eZZQOvwBNcCE2hnE5mutZvhPcFO+vFFyJ7KqVgOiYBateWxoxEIGDYVjHY05LWtxjwH+02FlEYeVstfzxHJ6dpf/eB3JUNu6vNi7tLQ5yuyrRfLBvOqf+Z4IXFUBos96bczwycOMUBt91nyBoGuiQPsMAPI4BJ/nE2/PJQgtgawOoXK2/1WGF0xZvLVIIn9LYtl+7bF8PvPOvpVM+9ddT4Ad1/5T8Ovxg4VRLrpJSCs7haqFn3ptwilejjAzmJEW3beWQckP03dT+q4TVhbuApIFSJaV/9JLop/1sDKO7GLlujqC43/81mlYHWRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcpjeaioTsbdN6FeC5QDCGtVT+HxTILzFAuMcSse8TA=;
 b=XLZZ3G7PYDvMPjOWKmHSkms05jvIzCwDEk9JZcizCQ29dqlNRGySGZclpt238KS9q3WzBHORlNc8Vur1GVzc9INiCN/aVLQooOVK1zPaoumYvX4Taa1vwg7gcpxh/dMHIHvWvG/SwCf1C67/OGI1l/wuQtB8OFB3X0mn3FtVJoMwGWDmXj2KfG9ui6qtVrNpHA+T2nEjlmfcHVjnPW3qnn/W9/rf8ZuBofov9eskbuuKNLV/wztICMShA8EO1S/7cXNTUNbyZhwSKOtxdzjYQdmKoRdtWN+MpqxjIMCw+BAlRfgE+V4CRNcWkElXsMTKZ7KlMT/XcD5c5xO6o+rXKw==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB3263.namprd12.prod.outlook.com (2603:10b6:208:ab::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 04:54:20 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Wed, 10 Aug 2022
 04:54:19 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKAgABBcwCAABkjAIAAncQAgAAZlICAABsXgA==
Date:   Wed, 10 Aug 2022 04:54:19 +0000
Message-ID: <bdb23ae6-8b66-fa50-7c51-7381da9d9478@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
 <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
 <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
 <a0184a51-ef30-dc80-412e-6f754c4d9476@nvidia.com>
 <YvMjQSlFKJE8Cp8w@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <YvMjQSlFKJE8Cp8w@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ab6f64-79c0-4027-6e0a-08da7a8c62d7
x-ms-traffictypediagnostic: MN2PR12MB3263:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ztkv77BZ8I2KP9q4kKWEGQFw9fJsf6GaAiKLHFlk16bHvL2faOj5YP17DIuuJAuu9NwbYnmhnNXgDU7Ki3gS1nknoK3W7pBG+SxbU/1Zj6Mi1YQq+9lpAOoQAAJZx81+RxAe3JqX3jBetB07EEJDPLmywP9c0r9xd78os9u3pQ8IeoF3cqZ22lmcEHw3exBEIPauLsrZsBOljRYulgt09K67VlAxLGpWGHr/4tzx7I/Hs0tMBg8a5Jt1C5IDvjHNHceFy3vQUbdGKb04LV+zNaomVcx912ovRcu/CptayS3DJoZGpAfPRh6Qqnx4iuqEF00wF/+7i6EhZp9dHqU6Ya8YP+yBdnaKaSwoPaVGx0EcmI/I8+zBE9ZuP5ymb0BUfgwmSYtr/7A+pNdqZD31FV33O6VEsncUdNci+oDLx0AN150jDyQyCEaDlE1cbAXb+PhpYEY+FYhDYqUsIzhIZqftjXORiBW4nZ/cF/PUab14+BUnF+/BHJb2hdF3+W82B49Wfo4knrX9iDHzhTnLPuB5y/WMm+Hw+hHfNM6gPWALwJ0G1DlF7ASns8jn1B2fpNLSPibnyB8nw42MDovuPTbiBYjShobnKqzgB6qdj1/0Jqk18xK6OLC2dRvqPHDZnwzlW+DkyPbtm147unUHCbMAR4t0sk7bRLYGuUlCAuy6Frz9YrX5RvGGJ3FluLuPIczcBeBQQYMV1DNuYfj34DtvUcaJ6hzrdJS+OcDCotNFSWRn4eVfkDZjvo0It4UgOMH8t5oFr11G8EBzdbsl6iTUJSu8cSJOuj+S0O+fxk8QWwTVzZbdCRpvFt8DCKUi8QYwfQpr7jvIaFyRWwu+WV6Qf25QOLyIrVgXR53dEehWNmBwRO1XgD7PoM2pEnI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(66556008)(38100700002)(66446008)(71200400001)(66476007)(6486002)(122000001)(64756008)(7416002)(66946007)(558084003)(38070700005)(8676002)(478600001)(5660300002)(31696002)(54906003)(76116006)(86362001)(4326008)(91956017)(316002)(6512007)(31686004)(186003)(2616005)(36756003)(8936002)(6916009)(6506007)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUc1dUxiU29rR0V6UjlndTNqcExDSGVTOUZiU1l5bk1Jd1VrTWFORVg1SkxB?=
 =?utf-8?B?WUcxeVJqd0Z0QnNwTlNQUkJ0TStRaEZQbHBkeXJ1ZzRGR0xXcWJYOTVaeWRm?=
 =?utf-8?B?SVFWV1BxUU5RSytHV0hhNHFLRmJVb01vM1RYSVZMclNmUmhrY1JtbkU4bnVr?=
 =?utf-8?B?bkM1OUJqL243OGdTZk4rcVFpemJYWGppRGcvODJsOEdlaFIzVFJYMkxEMXhR?=
 =?utf-8?B?QktHaml4RzRvd0ZjTFI2ZWpwb25xRm51RXZhTk5FVGwySnI2YzlJVDRWdmdj?=
 =?utf-8?B?U3g2N05kVW0zbTdadXZtR2lUUFBTcEtGL2x3MnZjeTJxTjVZbEdpaEE3ckV6?=
 =?utf-8?B?VTN4aWkrOTJ6emwzbzhxN3hUdEZLZzRDMjdCcThHUUFBblo1N2RNVkxaam1i?=
 =?utf-8?B?U3dQcnI4ajhldWlBd0lqVVhNQlFxY3F5QVhrRTNUZVM5RXA2cWc3dEY2b21M?=
 =?utf-8?B?UUpneUtKdkU3WHg5VWJCR1VnYVpqR2oraVVWWHRETXh2cFQ2dVovbXBrK2hX?=
 =?utf-8?B?QXR6RTkxNUREeVZDRnprRWN4emlEUjBFODVzOHlYNGtGNWpKdHY5UUZVakph?=
 =?utf-8?B?cTIxcUdrdFhDeEEvWjQ0WGJlTEk1eUZvUXJwa1lVcU5NVW01ZkJaOFFmengv?=
 =?utf-8?B?UG9SZFNyclJ0Q3FkMDJtNU1tV044SzV4eDV4Z1hCbFdwbmYxQzVKdjFuT3A0?=
 =?utf-8?B?dnR2Q1kxZmJIR0VrdzVoWnFBNkxiVnVTN29yZ1F1bzd2NHdFL0JLMTM5UCtx?=
 =?utf-8?B?ditzR1NNRTZ3U2Q5R0xpdEtNd29CTzVSWi9sR24zTnRDWnU0dUpVN2lMRk00?=
 =?utf-8?B?NXpYR1Ftbi8vREZtQkpndVpaY3dyMXFaY0N0ZUovYnZueGNMU2xhYUJNY3Bx?=
 =?utf-8?B?dkdRY1pBMnVMSUxTNnBqeDBzeU5sK3pWbWtSZ3BQRjlMaXJ2dHEyV0RkanEx?=
 =?utf-8?B?VGZNSXBmZGtlNGNaUnVlaGFzTFlwTVdOSDllUUtGQ1ZJVmtFMGZoeHVuY25K?=
 =?utf-8?B?RFU3bVlLUmJLeXkwTHVHYmk4MmdCajY3bmd4UG9HSjRxSE9oNkZDWm1LRUtE?=
 =?utf-8?B?NGc2SFp2ZWhaZWt5ekFwc0ZZRVV3aitGYzZSOTRrb3ViRndDWkdMWU54TU93?=
 =?utf-8?B?cm1pT2xFNE1za3JwcDgvd3hNSTA4bjE3U2R3WmI3Ky84aWxPTFZ4THFyQVQw?=
 =?utf-8?B?YWM3QzQ5YklxeUhUNmxsazdtZEpKRXBzUHd5SDFSY1dWS2tnWWFYUDFvNXRB?=
 =?utf-8?B?VzhqeTU5ZGxMREFCNU5PTlQ1VFVsalNQU2pvNmMvRHdMWmhWa0lacGVlQ1FV?=
 =?utf-8?B?bncvVVJveHdWNHBIdko2UmVSUG5zdmVYempiSXkrYUNaM24rbXpPRVkxWTBh?=
 =?utf-8?B?THp0dkVGRlkxdGRoZUZqZU9ONnNJZHFjY042UlMyZERVajJvdlJEQ2F1K2E4?=
 =?utf-8?B?OVRnMmhiREJISFpROCtvMlNydllGOVIxM1loamdOQ0FLbmJEdVU2VEhveE9w?=
 =?utf-8?B?cTlLYnRYUnBRSERGcnhENXhvN0Q4RWxpN05HZ2pvQ3Izc0R2VnRZSnVTU3Fz?=
 =?utf-8?B?Y3VndUxRcXBCbE9KcVoraFR1c2Vxc0tjVzFBcWtMVWZlVDdKdms4Qno2bVJq?=
 =?utf-8?B?NjVCZlFFWXordkcrMnJjZkNNWlV1STBZRnNDSUxiYjZpRHRJQTFXQ3ZIRER0?=
 =?utf-8?B?UHVQR1dmeVQ2N0tET3daeERFV25LTVQ4RUFpdjZJWDhTcFNoWDQrdlgrcFQ1?=
 =?utf-8?B?R0xieENmZkV3ZG95MG1sQkNZdE56SmN0dVlxOG5PMnZVWTBpVUJ3bjBsTUlx?=
 =?utf-8?B?TGlzOWs4cHQyMTd4YkJJNTI2NnJuT3BSa0hLSlBOcWU3cnArRUMwM3NsZzVF?=
 =?utf-8?B?NTNoMENraHFRTGl1MnNBME4vVHRUS095MDR2d1lxVXVMYkVzVHliUlZmeGU5?=
 =?utf-8?B?cDNKVTdUcmFmSFBlajBsaEovL0tDVGtlaHFtV2VRbHpyVHZ0d3pBWkFFemha?=
 =?utf-8?B?Qjlia1lYTmJDTU9PMWhoZit0Q1UxRDZxTHlNaGtVM1RZQXMxektyK0xmclBI?=
 =?utf-8?B?ZVNrL0p2NVQyMndHQXl3K0hLYjNQZlBjSFVyNHZqSlRoTWRuVWQzVHlQVTJL?=
 =?utf-8?B?Q044anVMbmlDdllzTXdHM2pkMExCcU9HdXBUUUM0YjZLU2VNZ2ZJZ1FVb1A3?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1329D89C68561428369DFF7078A0DDF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ab6f64-79c0-4027-6e0a-08da7a8c62d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 04:54:19.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0UPfnaoTcJnkUYj9cLoQFcnE71n5yG70gaXGf25Qeb7BfKOHEgd55/yRiCYeMRWuvutVpqps32E7TOnit54XAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3263
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IGNkdzExIGlzICcwJyBvbiB0aGUgMm5kIHRyeSwgYW5kIHRoZSAnZ290bycgaXMgY29uZGl0
aW9uZWQgb24gY2R3MTEgYmVpbmcNCj4gbm9uLXplcm8uIFRoZXJlJ3Mgbm8gaW5maW5pdGUgcmV0
cnkgaGVyZS4NCg0KUmlnaHQgSSBoYXZlIG1pc3JlYWQgdGhlIGNvZGUsIHRoYW5rcyBmb3IgcG9p
bnRpbmcgdGhhdCBvdXQuDQoNCi1jaw0KDQoNCg==
