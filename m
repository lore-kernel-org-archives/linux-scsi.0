Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D91C4708C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 23:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiLEXLJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 18:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiLEXKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 18:10:46 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD46D2180D;
        Mon,  5 Dec 2022 15:09:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq3QIzLmL8XcqaSAsH6C5ZM3Nhv2Lr2ZUSRCA5IeZWYnZYKcrA+b9XVgVx8BV4GW2ov6R0fw+tzUrU2Xg+TxBjCX0z2DMoyedrA5DDrKJlhyQTHZF4EZvsUz9auc2ypQ8/WMgAiblnaQL0sA1MA7jTp7H10EegVo74FaaRMepF35e7wFCMG09tSAOs9QYJPYhxsm9dNIdZSWFJHvV7xPq7aPPVVKYJrVeZelE6KT/1hEP2sWcmwoHsYZRtNe2KS6TPqBGL8zA22fV1LUQAYq9NRtiACb1RpV+N9UaDTAA379FhGVNcAt3uKhkq2prz6MTYhYSnPQ7dg/C4MZ1adpJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLN6G4jR0FKk/UxhjH+YT+5kYTRtlwsf4X5bwrNVmLU=;
 b=Wv9begueSek8cMCzbQ4bEfMoqSyMGZtlHb5vpDookS5He8edgxlTKz4dpH0CIYqsniTr7azJ1tXPnl4a7QFMcpbf4WbtZzsRIYADTsKcktjxTHSdcXe+1GwxNWeu8FfGYmJvHg88Szarli8YXZ4kWlTBSVomlItYg9cO4Q7lfpRSbLTXeMM6BcfC6di5qNVdq5/1/4S25uzeVJjxOYI9uLdsoGs7g2rEYn5f0pD+hCmuuqozSCtWsTTG/Hm/tO0j50uf5qCJBrAIAGSNqsVTtPppVvb9ZEMiB+48i9/BDuboox5eL4za52bLVRblXqlu/FeXZ7WCrWfPDIu06uC3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLN6G4jR0FKk/UxhjH+YT+5kYTRtlwsf4X5bwrNVmLU=;
 b=YzYf3hChagPLjfOgwt8Z0WvVwMxTAv16nf6YlZNzfeu+5P7enoZ3AyzRCTf42M83biwIDCy2wkHhe9Bk1HoOH14YLXBqwhunCY1k91zyFalGI/AMtusBs0Xz5r7C2gYtugQcCKWWLhOCc/nAtif88WJyo+Iq9AGvO27tLvlX60zDksnxcngk1zdtG3UhUANO+dPV96gd9h2PAGb90ugqXpU4ZN0fE4VJysEDYeEC2f9pwytbakwmsCnCHQ+e52ftGxX6uLqd0pppbKejPLtSlAy7uuxvLrn45GiXEcLH/GHuaspFNDbYl36BT/aaovUaaXyvP4ND88Q7bIaKKHeUrA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MN2PR12MB4333.namprd12.prod.outlook.com (2603:10b6:208:1d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 23:09:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 23:09:15 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Enrico Granata <egranata@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5fm/IAgAADgoCAAATVgIAAGpgAgAABzACAACr4gA==
Date:   Mon, 5 Dec 2022 23:09:15 +0000
Message-ID: <ec9ef065-253c-267c-8407-1ac6cbeeeb74@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
 <20221205152708-mutt-send-email-mst@kernel.org>
 <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
In-Reply-To: <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MN2PR12MB4333:EE_
x-ms-office365-filtering-correlation-id: 1b27a293-d588-4175-9b59-08dad715bb01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PDOHs9jMQL0LC79icT2/o6GAPMt+iO8HzDHroGRQ2WRdDx0ga9jepiaOQYID2Uq53xReGppjlZihpwuOXtJumf/9RNLYc2Ohf4n7Bbatt+nVFLQBpvFPmA23GsXmRb1QhZUtiaqvObE2Bvvdfysif8SnMh/KRQV00QyxxkehKo9hVQZ8rQoCdOVFNilsEhDpFusKcf7is/GYT3D/S+gMPBt6DWJfOGZSUCAXT1DM14g5MYZV9Q1XktJjbsnqX4QNtQaUuu3dD9y4RYVoegIXQHI5AIkQHlSJg7eGbufTYSTNBz9wuLC8NL9g4U/r19k3NSoQYpO6uOc0b9BCTXkvj93bAnIhEHvfpD2ixI7PnwStdDZuNBVdoZB/jBmSByv8Pg98NPU4tkKc+VQdjBB+ObDvMdC1oypmCIb1obELG7xFGr105QA6wbdGcoa9bA0bjigd8LkjhHzxrvhcJFJVbfssKrlHiyEwOJaSe1mXJnYgglISVFJiBUaoQUjaGpyHT4Awz+njFL87zC10WHJZygRYSNT5Mmvjlu6rOzjXdgcCO0rvs1dvkD9aCv+Bd8jcfbmTCp2aEGm4XGn1mXM8trMJaN8n2UDurLRz029g1H0es5MVXT2bEeXGygiARXf4vQcQ9tpxEzHthde6GnYcF1RP2f80kGpRUf3TPgsYSRh9TsU5aGL2Ot4FgzjadJYBIGCgzs2aMGXVzaMwWL5TqPMQn6DMZUfcHnbIdN7ufLL8Ot3PT1mkjRBVFYRku6x33p2NwD9MaqV95PMPy2giMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(36756003)(86362001)(31696002)(8936002)(2906002)(4326008)(41300700001)(38070700005)(7416002)(122000001)(5660300002)(91956017)(66556008)(66476007)(76116006)(6486002)(66446008)(54906003)(316002)(66946007)(110136005)(2616005)(31686004)(71200400001)(38100700002)(478600001)(8676002)(186003)(53546011)(6512007)(6506007)(64756008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUdCR0Nra1g3ZHJrdjF1Wk1FcWN4WUVKZDFlMDBKNGtUbVlZc2tEbEJXcy9I?=
 =?utf-8?B?Z0tiZzdHaFFNUXpxWFJhWUlMVHhsMTFLREhqdVJhYjhNOEZISmZadnJ0WGt0?=
 =?utf-8?B?Sm5Rb3J0L3UvdElScXV2a29sVzNlVS84SGdyaGxBTVRQZ3BJa0lkUjdUa1FW?=
 =?utf-8?B?MEdZdzhBaUFJQTNlcHBNeEVNODNNbHROSEZwYkZVR3pLdGY2Tk1iRnhHQ285?=
 =?utf-8?B?RTRHZ3hFWlZnWGVNd21UdTJXdzNwWjlEeFZWMWN0RXBDaVlKSlIvMERSTWdX?=
 =?utf-8?B?UG9nZ29GTm1oVkpBRy9hU21xWXhhZTJhVzhhYVlUdWxyelVrQS94aWZqdTl2?=
 =?utf-8?B?eTVJTnhkT2x3NVZmcElrb0VzN0g5c2NyMDdTTkRRYUFsQTVyV2xiek5PMEJR?=
 =?utf-8?B?dE90Mm5qbitYTXdEeXczKzhtRVhiaERYcWRNa3hEaXgzeUJ6YWxyNHZMc2tO?=
 =?utf-8?B?S3pleHUrR2lORnU5REdtS2Q3ZnY4SVVDYXJLMGhESHByZFg2VnlzUlNmbTBR?=
 =?utf-8?B?RGNndTVLWDlrV1gvREZKMCtsQi9PVlZpbVk5ejJ5Y0RRRE9EVjkrSlZkREZu?=
 =?utf-8?B?TXdUcm9ldTJWZGRhb0tCSk9ybDViSVpYeVBEWi9tNnhZQndabnlheXloWEFH?=
 =?utf-8?B?YjZIOXArK09GUzQ3alRJeDI0TENMNUdsRk9pZmdTM1JzZnVjdVB1Rnk5WU13?=
 =?utf-8?B?eVBIZGNkRGwyR0ZRSmhGaHIxK0dZODdGSlpCYTJESGFkZDBkNW1jbGxtYUVu?=
 =?utf-8?B?T3ppTEVDMnhnWFBQbHdJVzNwY0lLVHlqWU1TT3N1bzE2b1llMzI2c1VVYmxJ?=
 =?utf-8?B?dHoxU3hsZENaTW1vT2Zwcm83aDFTRExVbUV6VTc2c1BaYVJJeTFSbFZOQVZN?=
 =?utf-8?B?OXBzUk1TNEVBSTI5M05kRUZ5cXkrOFUyOWR1L2VsclBmcmVsZXFFUHQyb05k?=
 =?utf-8?B?VGJwd282dzdwT2haR1FrWHppNCt2WXBTU25OcU81bWI3aHVuN1BWNnZQcUZw?=
 =?utf-8?B?elZMSHA5QUo0aFU1bXNYcExOQ0xSak9qS1J1dHFvUUpYRHhydjE1RVpyelhB?=
 =?utf-8?B?WjdiNDEwbEVPdXFudnJsbTZUVTFteExlRjBYSXNYWUVTdkZtRGJDbE9oTTlK?=
 =?utf-8?B?T3dsa3p6NXBkSlhzRUd2UHZsM1hpZ3luSm9VVkR6QmdZTjZ3YVpWdi8yUVNq?=
 =?utf-8?B?ZThKSXZhd3FZVkV1NGZmZEVBNkVMQTc5bGNzTHJ5M1pqWjRxVlAwaCsxM1Ny?=
 =?utf-8?B?UnRJVFloYnQrNStJWFQxT1F0N3pjUTJIbHZhY05kbUQwZVFrVTVuQWlMYWlS?=
 =?utf-8?B?Ym5zNmtnSGRyWlJlNVo4dEdNQ3llM0hlR1hhL1ljMjBqWXBPY1JYRnZVcWdS?=
 =?utf-8?B?WCtrWU9nNDUzbkhZVmFKVmJHTVVmZFBYTzBqWEM5QWlXdzkzTjc2eVhoMG5o?=
 =?utf-8?B?a3JaalBUZndqTHNGYVpCQ0FNcFIyZkdTaGEyUkRDQ3NqY2VnMnllejY3VVJ5?=
 =?utf-8?B?a1BjRFhMbk9IUUtMeDFsU3RBLzFrbmJXMTlLcTdMVU9Tb3p1WkFyN29PeXhQ?=
 =?utf-8?B?U1BQNXVKalVmOEpZcCtRdit3c1pRaEU5N0RWeUp1VEU4dmFtTTlzUHN5aThF?=
 =?utf-8?B?WDR4ZEdoQXRFK3FHVHJjVFFob3RnOEtqeGlrOVhvQWtXbEdzazBFMFZFRmll?=
 =?utf-8?B?SDlEaTN4UFlyNUg2bWsxREc3dkhlVENGb0xNTU1GcVRiWDRyZWdKQlM5ZkFv?=
 =?utf-8?B?UVI1a2FtbFNyWEswUS82Wjl2S0JXcm5iRWZxdE9JdEROYjB2cDV5Z016Nkdj?=
 =?utf-8?B?Q1hPUnhIdGFNMGZPcmtqMXdsdHlLNVVoUkg5b2V6WFJkbDF2N2NEbEpsQVpi?=
 =?utf-8?B?SFJyNzU0QjU1ZmVydmMvQ3hLczJYSldYdHhoTlRsb2xqb3hOcytTUlpSZjd3?=
 =?utf-8?B?WVJPcVhoSVFpM0FIMG5JK0h5UUozbG01ZmpYYm1uY0RUck5GK1dLODdRQWtG?=
 =?utf-8?B?TExJMWN4U1lzSjZXSlIreHRtTXowdWxWL2NPeTl0Y1RUQnVJZUN6dW5Dekx2?=
 =?utf-8?B?clZ0dkk1VjZxWllDT1FvOTUwN25BRTJYbnJCVTI5L2JJTTB3dUpTU20zTzhE?=
 =?utf-8?B?ZS9tZXhwaU1YTjhoSkZNVWM3RjVxdDZ1VDlhSlozQjFYS28xeVIxOUpVMjVl?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5A05BA46B99B7468259A95FEF1269E6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b27a293-d588-4175-9b59-08dad715bb01
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 23:09:15.7920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uysi3Rzimpawwzvli83Q6CpJtY7bCrmuFzBiMFFj+1s1ASLKLrDEaKTTqosC4/KPXXobvnL2l5clEM/0H4K5Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4333
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvNS8yMiAxMjozNSwgRW5yaWNvIEdyYW5hdGEgd3JvdGU6DQo+IFRoZSBvcmlnaW5hbCBk
ZWZpbml0aW9ucyBmb3IgdGhlc2UgZmllbGRzIGNvbWUgZnJvbSBKRVNEODQtQjUwLCB3aGljaA0K
PiBpcyB3aGF0IGVNTUMgc3RvcmFnZSB1c2VzLiBJdCBoYXMgYmVlbiBhIHdoaWxlLCBidXQgSSBy
ZWNhbGwgVUZTIGRvaW5nDQo+IHNvbWV0aGluZyBwcmV0dHkgc2ltaWxhci4NCj4gU3lzdGVtcyB0
aGF0IGRvbid0IGhhdmUgYSB3ZWxsIGRlZmluZWQgbm90aW9uIG9mIGR1cmFiaWxpdHkgd291bGQg
anVzdA0KPiBub3QgZXhwb3NlIHRoZSBmbGFnIChlLmcuIGEgc3Bpbm5pbmcgZGlzayksIGFuZCBn
b2luZyBmb3Igd2hhdA0KPiBlTU1DL1VGUyBleHBvc2UgYWxyZWFkeSB3b3VsZCBtYWtlIGltcGxl
bWVudGF0aW9ucyBmYWlybHkgc2VhbWxlc3MgZm9yDQo+IGEgbG90IG9mIGNvbW1vbiBlbWJlZGRl
ZCBzY2VuYXJpb3MuDQo+IA0KDQpIYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRoZXJlIG1pZ2h0IGJl
IG5vbi1lbWJlZGVkIGRlcGxveW1lbnRzIHdoaWNoDQp2aXJ0aW8tYmxrIGZyb250ZW5kIGNhbiBh
bHNvIGJlbmVmaXQgZnJvbSB0aGlzIGZlYXR1cmUgYW5kIHRoZXkgY2FuDQpoYXZlIG1vcmUgZmxh
c2ggY2VsbCB0eXBlcyB0aGFuIHByZXNlbnQgaW4gdGhlIGFwcHJvdmVkIHNwZWMgPw0KDQo+IE9m
IGNvdXJzZSwgaWYgeW91IHNlZSByb29tIGZvciBpbXByb3ZlbWVudCB0byB0aGUgc3BlYywgSSdk
IGJlIHZlcnkNCj4gaW50ZXJlc3RlZCBpbiBoZWFyaW5nIHlvdXIgdGhvdWdodHMNCj4gDQo+IFRo
YW5rcywNCj4gLSBFbnJpY28NCj4gDQo+IFRoYW5rcywNCj4gLSBFbnJpY28NCj4gDQoNCiBGcm9t
IGEgcXVpY2sgbG9vayA6LQ0KDQpUaGUgc3RydWN0IHZpcnRpb19ibGtfbGlmZXRpbWUgaXMgdG9v
IG5hcnJvdyBmb3Igc3VyZSBvbmx5DQpzdXBwb3J0aW5nIHR3byB0eXBlcywgaXQgYXQgbGVhc3Qg
bmVlZHMgdG8gc3VwcG9ydCBhdmFpbGFibGUgZmxhc2gNCmNlbGwgdHlwZXMgdG8gc3RhcnQgd2l0
aCBhbmQgdGhlIG1lbWJlcnMgbmVlZHMgdG8gYmUgcmVuYW1lZA0KdG8gcmVmbGVjdCB0aGUgYWN0
dWFsIHR5cGUgZm9yIG1vcmUgY2xhcml0eS4NCg0KaG9wZSB0aGlzIGhlbHBzIC4uLg0KDQotY2sN
Cg0K
