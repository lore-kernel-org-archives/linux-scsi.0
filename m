Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F5BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 09:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DE3615E5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 09:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349479AbhI3Jo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 05:44:56 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:36705
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349427AbhI3Joz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 05:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMl0Trj3HiIkhSjDe2+IwIDS7qLZe4xkJVLM2Orjh/ZD1cgUlpZsEwOpmMZtlVU3i1cFkpuDkuXGjnYgDsAb8Jy4Ji8z8ALkupPDtNn+ge/Nj1ZcLEjRwLBXgou89aQ+nDeKs+JMqhPUI/f2Wpm9kH+uD6UUz3bl5NZryFOhWebVof3ZyzgJ+djTK69hBrUL/zmA7/iRjQq6x4+RpOmUOopUP8ZD01xbrgG7qQf+gkfGPq7cQW3sLCNHr4jefTySHHKhFnuQxlE08gTE8jIB2/p4Zq81Opr2DF2PAzpdrP8Lniq0nM2Oa94NbJwTVpNBrXsB0xfz4CFdYryt97Pd5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VBKJr+9jizTvhrrGpfxGKwOV97g5/OB/Qe4WRo8wohg=;
 b=jCX3RmhyknandCGbMPU3dQWh/ooW4T0TxNKplXY1NpLAmbi4CywQrWhUSqwN8qNvHZGhd50NecsCQP7tRlti3RkkIcd2fQ+T3ZCphtZ9fLBUfzpf8cCNhb3qcJsgZwRFqDwSgkcdu4cnMLctzpiRDuQwbkUGQEd2LSX74ZoH/CQKd4ByChxYoOmtmemAxAbyNBOiABKhDvAMDZlRrDEIqd0JJK3GOgW1E5kICNOguJ/bPFZVLv6DFbLGksDhvL+BfRCyudZT7WAJnaKCCzhy8pbUZfpQJCNkEzzVT0rDPhaA7utH/JWXJXv8POVNLyWe01Mt7WsKacWGOQi15Xv3cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBKJr+9jizTvhrrGpfxGKwOV97g5/OB/Qe4WRo8wohg=;
 b=UEwwqaL5EKAfOwWH655PxB6NSn/Vleieb5XDM6L4w6k9/ijqOOmJE7yP9CBm7ouBFNmxvkfxdNqcRQYPkOsoeir6uF7NhOLEXIILT9yeF5K9r8ZlG3rxC/rysl0mkU0U+ykigxBF+ui6WK/EiKvICNaFeo4q4t9VjQ2vpAsbLJEiaija/0NStGqsf/fPrLbXY9bXaieqOY3f3snVYBa5FkJ0kz/NaHiwTnZuG4h6fSiHZwjhfDvOnYhMOYvdl7YrA4laqaj6b+TI2TSEF2r3RUMtmeW5+Jr3RpRSkz5xXS3Egelbmnw3g8MsijgpusPDlWTIswIZcfFc1R2KilCCSA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW2PR12MB2442.namprd12.prod.outlook.com (2603:10b6:907:4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 09:43:11 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 09:43:11 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXtJz3aovD145e60qqb0tlGftm/6u8Ve+A
Date:   Thu, 30 Sep 2021 09:43:11 +0000
Message-ID: <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
In-Reply-To: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81ce62ce-b56c-4737-68ef-08d983f6b7ae
x-ms-traffictypediagnostic: MW2PR12MB2442:
x-microsoft-antispam-prvs: <MW2PR12MB2442B7A3E508E6B51CD0DD15A3AA9@MW2PR12MB2442.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j607uCoOoLdqnyboCoDplMyqsdNSSW1Qxqxn8PXJlNkTvj/Zb+YxUyK1pcZhtUD/jqrNQOHrL1Xy9OEJxcAXTadDA33OIQtWFz40K0m+Gv2sOFjImsoQWtYMYFnPSjxe6WkcNNz0SqgFfsDNsI8MxyKdPjQpcIkdW0ibz5N30Jwa8orSMlZHQsj+bFrZDOVnry/rPoLLitk9SwfRN1Xv99JCBpwhiG5e7F9FqqQjmWgs9HHT2LG5TQNbrUJ28NngWT8jIkjnoANXP/PP532UHJ2aL33NuWfAHCdHUnpZeeXRcP6+ORKJW3iCS3F8OmihOLIVWa8KZviyYPDUkSktBCm+nmDlgVh+hYr0i2+Rhds3NXtS+JeNAd4aALxTUp/kMAHe/afg7MVsmVlnKBFCLzZtw5ZEo6WAz1aBigbKLnhCLv4rzB4SMZ7qIUJDElTxTf3AatoMqNCE5IhvkjQl5UD07Qx6Rlno+g6KlLEBYKZJpdLrnDe/C0yuU43To6vik8y0In6dpgsuz62l3UBMgDD8UKpI66LQL+vDrYuRXA6X6HA7p7MTLOIXizJX4Rtt1nk9Zg0bxkoh2qHU0Ii/B+XByyCvoXGqLiEBPFWZ9Z23doCuoHmEw9Ac/QpPMvXkHqDuVkN9kMjDcY16tSTgDW/BSiez6PXUju27SOsl99RhUY0qqB3BTMcLgtV+tkC5VTkm7o+I8LKVptin9BTdPQWiHwMulvEDH6+Rlm8ZmPl2Erw7v2OpbOOWj8oIDyCu4FiOozSTBdMOB1sQt6sH9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(316002)(83380400001)(8676002)(71200400001)(7416002)(6506007)(2906002)(31686004)(36756003)(26005)(91956017)(186003)(4326008)(2616005)(8936002)(5660300002)(86362001)(110136005)(54906003)(6486002)(508600001)(66946007)(66476007)(76116006)(122000001)(66446008)(66556008)(31696002)(38070700005)(64756008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEg0cVgzN3EyQTlRT2ZtQUJ2WTNxYmErcXpzeEdHWEVRcmR5c0FMUlh4MmVU?=
 =?utf-8?B?Ty92Mnp0T2UxUVQwUzd4Wmh3VFhaNEY5eklmQ2xEUTN4UGthUG0yYmZSSDN6?=
 =?utf-8?B?UTlZNG5yWEdLWjR1dWI2MWJQZy8wNmhZQm10U3d6bVczQ2Iyd2dTYmFHenpN?=
 =?utf-8?B?VUZ0M3BPVTZDNUd6Qm51aERRbHNCZDNIOElwVjhEbi9XLzhNckRIWW5BZlVC?=
 =?utf-8?B?dXlmTXF2TWg2dDZsRm80UmlzMzlKaG5jNko4YUdOK3Y0M05WSDl1cUxZTEpW?=
 =?utf-8?B?K2VFWHVRb3JSK3BIa2YyaDRjWXJKZW5DZk5aYnEwUnl2Y2ZmYkJJb1hJYWRu?=
 =?utf-8?B?WCtDMnRGL2g1MmNYNE00WTF3SkRRZ1BxM1NKNExFaEJVUm1JNXlBNlFNQndy?=
 =?utf-8?B?UFV1WS9KT254enhHNUpQM25zWXVoNE5tMVdGdTdEQjExQmdNelJuOUNCZ0d4?=
 =?utf-8?B?V1lVTGw3UE9lSTZyMno0SGMxQmJPZklTZWd0emVMMWRQd2doc1BMUmV3YXZq?=
 =?utf-8?B?MTVoNTdSYktXcmtVeWFKTTR3cTlyYnlDcmk4dzJJYkNPYWU2UGRWU3VIL3lz?=
 =?utf-8?B?ZWo5NC8xYXFXSjMwVGVNTUl0Qllva2VJWDErMGVrQjc1UHlsc2JvWFFMd2JD?=
 =?utf-8?B?S1VwcUpDUWhpSUlXRHJ5eXVyZFVhcWFxdWxwellKaHB6Q0xWQTZIdkovNHZ4?=
 =?utf-8?B?b2xxN1R5WHhhVklDUlljdXl1eUhmK0diRDlETWNWQnBlQTdLbWExRmVhWWxD?=
 =?utf-8?B?WXAvNGtkbUtrOUZIVVhQOThsTDVPSEh1YjZWZ2IyNnJ3WmJNc2hMeEJSUjht?=
 =?utf-8?B?eEhOZXgxc1RkWGgwaklsNWhac0Z1TlA1RVlYSHFkZ0pyRzJKcEoyK2NTWjN5?=
 =?utf-8?B?RW5FOVlCNDBqVWdHODZkM0F3QnlEM1kxZTVVR1R4TmNhOVV3QmxCcFpiT0dX?=
 =?utf-8?B?Nng1anI1c1Z1TGZkTTlLdjg2K2NqQ3E1WnRucE9pSjFVMGhqNTE2SHo0UGVn?=
 =?utf-8?B?Kzc1ZTFPRXVpZTRWbXhhczBlTU1DMzg3dStkTGpadHNteTVhZHNDRlpKeEZV?=
 =?utf-8?B?VDBIaFg0dEMwQU5id0tlMWI5TmdrWlNTQnpNVFZCajBQd1c0dWlndWFJN3ZR?=
 =?utf-8?B?VmNhTlh3VG1Wd1VjY0VtUFRqNEh2aUFIdE9lbURZMytpNVUvN21LN045Vi8r?=
 =?utf-8?B?M0FOK3JBS2NDSmU4Rjc4U202TmdSWUxyanVDeWlvSldPWDRPOERKOUhUUHlx?=
 =?utf-8?B?Sm9qTXdNazFPRHFBK2MydEpmN1kyTHplRXpLeHJxN09MdUdOR0xLK05MVGRR?=
 =?utf-8?B?QmJhQy83OGpuS213Wk82N3FlUUNMakNPMkY2WU1jajlwK2ROeElDbW1OWmVU?=
 =?utf-8?B?b1l5OUtLTG4vWWxIZFVCOC9vcnBRbmUxUFRuUC9oZEEwKzlhQ2ZSNksyeXB4?=
 =?utf-8?B?Rm04T25XcDJ4SU1LM2J0NCtOTllDWldYbTVJdXVGSFZ5VzY3K2tJUWdrTTdw?=
 =?utf-8?B?YUZTTURUVjBheTlvS3ZZZllFTmhOUHV6UG56VHNkU3VySTR4OThZczFtU2pL?=
 =?utf-8?B?Q0ZhbEorTzdwNEp2MGdtamkyaWVCS0lUdjMwbHU3dWxYMk96d2w5dkhCODA2?=
 =?utf-8?B?Uks1YjdxZC92U2NiOWZ0NU9JZFJVSEttWGRUZ1JHVkNTeUlJOWp0RDFwREVk?=
 =?utf-8?B?aEkrSGNaVUE5b3BIUDkrNXk1TG1DRmFnNXFKQ3p4dnl1cEVIZTZadFh6NVQv?=
 =?utf-8?Q?Ta6oJjsCjt9qMC7P+8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <049DEE6DC5469349ADC32795CC0EFE79@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ce62ce-b56c-4737-68ef-08d983f6b7ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 09:43:11.5340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTedOFZJZ+uBys45CPMkRArj1B7by2DXmQRupbClzsc2pCP54pLAjjLkXYhH8BCUm5xhAkK/dhmgmqoUi8Ndyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2442
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SmF2aWVyLA0KDQo+IA0KPiBIaSBhbGwsDQo+IA0KPiBTaW5jZSB3ZSBhcmUgbm90IGdvaW5nIHRv
IGJlIGFibGUgdG8gdGFsayBhYm91dCB0aGlzIGF0IExTRi9NTSwgYSBmZXcgb2YNCj4gdXMgdGhv
dWdodCBhYm91dCBob2xkaW5nIGEgZGVkaWNhdGVkIHZpcnR1YWwgZGlzY3Vzc2lvbiBhYm91dCBD
b3B5DQo+IE9mZmxvYWQuIEkgYmVsaWV2ZSB3ZSBjYW4gdXNlIENoYWl0YW55YSdzIHRocmVhZCBh
cyBhIHN0YXJ0LiBHaXZlbiB0aGUNCj4gY3VycmVudCBzdGF0ZSBvZiB0aGUgY3VycmVudCBwYXRj
aGVzLCBJIHdvdWxkIHByb3Bvc2UgdGhhdCB3ZSBmb2N1cyBvbg0KPiB0aGUgbmV4dCBzdGVwIHRv
IGdldCB0aGUgbWluaW1hbCBwYXRjaHNldCB0aGF0IGNhbiBnbyB1cHN0cmVhbSBzbyB0aGF0DQo+
IHdlIGNhbiBidWlsZCBmcm9tIHRoZXJlLg0KPiANCg0KSSBhZ3JlZSB3aXRoIGhhdmluZyBhIGNh
bGwgYXMgaXQgaGFzIGJlZW4gdHdvIHllYXJzIEknbSB0cnlpbmcgdG8gaGF2ZSANCnRoaXMgZGlz
Y3Vzc2lvbi4NCg0KQmVmb3JlIHdlIHNldHVwIGEgY2FsbCwgcGxlYXNlIHN1bW1hcml6ZSBmb2xs
b3dpbmcgaGVyZSA6LQ0KDQoxLiBFeGFjdGx5IHdoYXQgd29yayBoYXMgYmVlbiBkb25lIHNvIGZh
ci4NCjIuIFdoYXQga2luZCBvZiBmZWVkYmFjayB5b3UgZ290Lg0KMy4gV2hhdCBhcmUgdGhlIGV4
YWN0IGJsb2NrZXJzL29iamVjdGlvbnMuDQo0LiBQb3RlbnRpYWwgd2F5cyBvZiBtb3ZpbmcgZm9y
d2FyZC4NCg0KQWx0aG91Z2ggdGhpcyBhbGwgaW5mb3JtYXRpb24gaXMgcHJlc2VudCBpbiB0aGUg
bWFpbGluZyBhcmNoaXZlcyBpdCBpcyANCnNjYXR0ZXJlZCBhbGwgb3ZlciB0aGUgcGxhY2VzLCBs
b29raW5nIGF0IHRoZSBsb25nIENDIGxpc3QgYWJvdmUgd2UgbmVlZCANCnRvIGdldCB0aGUgZXZl
cnlvbmUgb24gdGhlIHNhbWUgcGFnZSBpbiBvcmRlciB0byBoYXZlIGEgcHJvZHVjdGl2ZSBjYWxs
Lg0KDQpPbmNlIHdlIGhhdmUgYWJvdmUgZGlzY3Vzc2lvbiB3ZSBjYW4gc2V0dXAgYSBwcmVjaXNl
IGFnZW5kYSBhbmQgYXNzaWduIA0Kc2xvdHMuDQoNCj4gQmVmb3JlIHdlIHRyeSB0byBmaW5kIGEg
ZGF0ZSBhbmQgYSB0aW1lIHRoYXQgZml0cyBtb3N0IG9mIHVzLCB3aG8gd291bGQNCj4gYmUgaW50
ZXJlc3RlZCBpbiBwYXJ0aWNpcGF0aW5nPw0KPiANCj4gVGhhbmtzLA0KPiBKYXZpZXINCg0KLWNr
DQo=
