Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88307C25B07
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 10:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiHIKzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 06:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242763AbiHIKzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 06:55:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF7646C;
        Tue,  9 Aug 2022 03:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2VzKL9vWM0UUgA/lksAuNOCRFcp5UqBL5pkWS0Kca/+1vY+8QxwK4rL8zR8iwXCMeLRCvs4oWKoaaHsdHN2p76287mfhcHRuUBQQcYU5sKwhEvwEcI8rmZ2iQW6bXrLs0lqeD2w0WL2FZzVMDMVq0Sul8ZpPBt82ccK3S6hyn3H9anTDgw4aNkWe6HoLAVnE4daXHaMKTQo75WWpYYN95jMXIZ7ZbH4KLm9pfY/kzPPlAVIJ8CwMS+bxQNOnAMCW/SloN+egLFlIPZ0Y4347Tn4KGbmxHNQsMXCho8eEdJcrG2Od+IkM24KMRsH8nAee0qiUNH7m5+x3JGuedRE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMUPt4Mcis1r04zYczSr+2yW6PuxwLcgj58oG5XldGc=;
 b=dGLmM30pAHoISVhpH/xRPsgMivf4JX6nu2Q5rZIn/BL7lkAYPHUbjzyc2ufKYkDEqFKe4KcAtsidyzmIwtztcphoSyDu/MNy1FwnGsjEPiLl2TNo5AiE+FTo8KNH7gDhhT1do2CnejjarL6xIrKu1I1S0KYVd+YbptUbz/yna4OxR8zb+MxWxSjt1hDXLN2pvocDgJ7gwzC7CVg+h0ni3JpSWyzAoEvHXwNLihCTEqU8KlFgYTCVDDYQ0EnMG3884YqwqDC3lRZcTD9/c0jFO15QF//9hq/HY6tlduovMUzXkTKCmUOiMUeGBfEOLLlHQ2c0H7VSIIukjYibHn5T8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMUPt4Mcis1r04zYczSr+2yW6PuxwLcgj58oG5XldGc=;
 b=I0icT6dEYmU/LLlRZW+qpfg7+ej0WSej49zSpeIg728EdZvaM8Pse/rocMV9WzBHbwuAOQRmHGtwY7Wishq91/yxfYeLnHw/0wiF9hqOXrEHWQMgNuBPUpTh4g9JgSszw6oVAWTBuzF+DsXEdYhv3GFU/tP1/ldNzAacU9ei5Uir4oZe8QzEnpYtRLMlRpFr58+LTtVKFwu11ZP11huVq+dMbWYXkui0rhEUN0WY4/ViTjZ2bQyKWxVUzTlIiKoE0i83DckhTA5NHtYk7k4vR8ToYK0S+r4hr5j88lrjkZPgpbbxBq9xiTevklVDARqMeu4Lpp29tqjl74wRZG0FEw==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 10:55:37 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:55:37 +0000
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
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZhQA
Date:   Tue, 9 Aug 2022 10:55:37 +0000
Message-ID: <de98be35-c5e9-742c-5d9d-fecefaf3c667@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 18ab9b64-b62f-44ad-f9d1-08da79f5b110
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeLmC7wJpLkozJQnfTMh/P3TheSQaX42cL3qX+/LnTxHclBwgxCIUP7P/GRfrNdJTifnKTsLkrai0aOv49EdFFTgZvF4xs3TlNW0B8bkSIc9+X8zbh3396sdAw61rP9+hDipc9gkaow/rCcVtP7quqwezzCXmvhwWGeIgHzTZ56s6aTgyVVuLMaL8uf8VoSGIlqadG6DOVmliv33fMDClqBu1Kmem2WLVATyhWHH6DT7u3rM2giJShLxcvRi/KlJaWdcIzfK76v/5LvUVakklWmzpEzZeSl0icKclDduRuEpjX32B1Z3Fp3A0P5itOtfpZSp/EIqCsOPmtD/H7sprKYmkpu44h3xpskbQl7RYYqjfcG96Gf3gQsuXsTEcrnQ9D1ElIyuDGrIQg4gKipLFqHR+0zsL1lNuHQd9/PxYGfLKWI55ZT9NqB1R7p7na1QE5daIO3QwWF0ooyHOD7BSxDasMzr52iNmN8QO24TxTVowrWvv7nXVokGA/wvfeTDv+TWSNovJSNDWdQLWSVXyajblQKoNGqGAhJHYgum3948Ri5F7T2O8MOdJu+kndIMIH2SkiXESJCOxDVD5HYjLgYGRk1X80+VixP/+tKUITZoITRzKSgKiw1eRRbGelhfXCf3JabtyxXo38s0TzIcIV9I3bc4AfjxjBaQOCTZ9lM6WXlT0y1hnDNK3KZXyVuTNcQ/QqYQcTe79pvzj+JD+8QclDsZZRVMLmY9/68ZLt3i/+3YdrOHB9HwNlB/Lqjyc2tmHnsVxtH9hgalZIoAKwc/FpFoFkb0Rocg99XI11JVVymNd2P5oBclzBmwiYaGJ0GZa1kLNHD3KOmgEGIVDLaJVeOlHu4fwEHdrVbF/b0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(4744005)(7416002)(6512007)(38070700005)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFJuMGVUYlY2b0hpOStHMm5DamYzY015aG1WWVZvVmE2RUxhUzlhUDlES2NU?=
 =?utf-8?B?d3lzek1Td2F4MHFVU3ZEWDNSWjQ5dVB0LytKS05RNkxIS0ZIRXAvTWFvMmxh?=
 =?utf-8?B?RXhqQXBuYU11VU13RzRvOTNRbkZySk9FdEwzSTMxb1NRb2tnVjg3bHkzaEw4?=
 =?utf-8?B?ZW00T3VJV3NaaFVOTkc5enVYNHhsdi8wcEdtczBHMkZWaXRuQTN4TzV6UFBF?=
 =?utf-8?B?b3JWM3FKNUd2enlWRFQ0bkFPaDdmSnNnU1Y3NkFib1pDS1A4Qlc3V0hzSmla?=
 =?utf-8?B?VVdiMlBPVEtDREZQTkxqOEtjVzUzaFVKTk5UUHhnREJaREhlYWFxZElzb0V1?=
 =?utf-8?B?bytOcWVXcU1HQXF2cGE1SkpVVXpkd2FkVlZoYW5sUFVHODNRLy85L0ZSb3g4?=
 =?utf-8?B?T2FXNzZMOFR3RGdlY1NSS2dTVnNGc3hxdnpuZ2MwNmp2eW5WWGJveEE4R2JY?=
 =?utf-8?B?a3JCUExRT2lIZEdCN2QwNG9CSncxVk1Dd0w3S21kb1pTWXlpZTF1alRiNWs1?=
 =?utf-8?B?bzZ0V0pWL0k0RWRBTkpKeGl5emdQNWQyQ2ZEcUJYUDAxZHhkVW1XYnBwRHlx?=
 =?utf-8?B?azNVUXMyQ0pJb016SGI1MmE2d2owRXlHaVhrc0wvZGFDWjM1c2hURDkzWkZI?=
 =?utf-8?B?REFJbmd1aVNuVjQ5WCtVcUdXUEd5S2NZKy9WdjFheWg3R1NpaDFaR1V1MG8z?=
 =?utf-8?B?L2o3blZGbjJvWEZORjQzWVhxSDkvVTFTS01QcVBxWnVxcmxUenhud0hOVkUv?=
 =?utf-8?B?b1k4WVJQTWJXK1loZm9RZXJSRmVMSGRhSU1YN2c3dVJwejZON1VCRHVCcGh0?=
 =?utf-8?B?ZElkajB6UmlvaklNNGMwandMN1p2RTNBTGJkOTdpdHFQZ0tlTW9nUlhWcEM1?=
 =?utf-8?B?OXZqNXhMRSs5dzY4cnNaT0ZmU1Q4dTgvZEhIOTU0djlMRzZPckJDbi9tb2Ur?=
 =?utf-8?B?S3Q0MGRaV0ltakJiSzBjQ0l5TFQyR1lpdDJId2ZJa1pVZ0hJSXJuUVFmZ0pK?=
 =?utf-8?B?d05kYWVvR3ZjM2d6bnVyaTcxWXNZa1g0UlhxN0RtbWlOS0s2THlQNC9qbDh5?=
 =?utf-8?B?MS9hZmRQZ1hjbkJabHZ4elV0TXRiamd2Mk9Ub3B1bzZLeW85S0E3UmVkcUwx?=
 =?utf-8?B?ZUNRUGRjK3RkVXdnQjJiRjdaQWozaFdBdER1VkErSzlVWHBZdUUrdkxEYm1z?=
 =?utf-8?B?bURVNC8vQVArOFpwcFVNNzNzWFpPQndsUmxrRnNjZXllSTBLeTJUZzkwdnZW?=
 =?utf-8?B?Z2JqUHE3eGFYaDgzbjI1bnFZcmlSb1A5a2FrMjRWeXE3UG9xWGZjczVRNHNM?=
 =?utf-8?B?Q3VQZHRlSkhTNzlEbzFpV0dXeFliU2RKNVFHTG1nZENOUGpEc3QzZ3NOZjZ6?=
 =?utf-8?B?RExDeGhRSVV2dW9yL1RPTWYycWs5TzNCRXBsMU9GaGtkeG5ONHpZMEN6OU9C?=
 =?utf-8?B?UTMrYXJXQW1IUjlqN2dHUjdSUElmMnN4ZW5NdE95dFBVYW12M1UxbzJhQ00z?=
 =?utf-8?B?UFpZaG5PemZhenJWOXZhQUxsNCtNV0RzMUNzb1RLQ0Uzc3Q0K3BnNnVkZmcy?=
 =?utf-8?B?dEVvTUhSU0M3OHJPWURpc1FqWnJkeE5kVlB6NEMwdWNIY3NNN1VlaFpWb1BI?=
 =?utf-8?B?TFdML2ZDKzJIV3g5Z2l0aWRSQjh1eURVTFRsdE02QnlKNCs4R2loK3hkejJh?=
 =?utf-8?B?Vm5QUHB6blY3dGJIL1ZyeWpQYnNMZ3FmcWdZeGloL21sOG0wb0VDTEFuUkhx?=
 =?utf-8?B?OW5ZRCtUZGhkQnhuZ3ZhUkl0eFh3QTc3OWxnWWRQTjRsejZjNW1PRG1UeGxl?=
 =?utf-8?B?UXM4cWxPNUM0NnhaTk5WQitWQ3B0RzZ3QU15YWRzWmZqN3g0dFVHS2k5MFBx?=
 =?utf-8?B?QTZJUFY3bENZVXdwRS90Q3duTXdSaXcxbmdhNklnbzl3VzZoN3JFemF3MFcw?=
 =?utf-8?B?R0tTdXBmaU01UStIbzF4RnMxMlFKck96bkwxUzY1U0RhZUZGVEkwb3BtZVhF?=
 =?utf-8?B?Z2JjaGs3Y0RXL0ZDcVFPS1VGdVVqRG9xQ2dGcjh2clNOM0tUei83eHBZWGhE?=
 =?utf-8?B?KzJ2eGc1YlNua20welBjMHRObFVDcGdlalkxMUFsdGRmMk00YVFWQkdlRk0y?=
 =?utf-8?B?Z2NGU1BRT3dGQ3h2L3FJYXhSbDdtMC9RNWF6Y0xMUmQvVXdCMTFsdk8yQnYy?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <166F20E83C97164DB337E7BED2C534F1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ab9b64-b62f-44ad-f9d1-08da79f5b110
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:55:37.0505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJ8nIffL+0hgFYtsRnjaU0tFBg3h3+2QOmPjmi3llOefcMjkNQOuWmoow6pSiFUPsTgXVeHRBg7tORSXYsLU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC84LzIyIDE3OjA0LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBUaGlzIGFkZHMgYSBoZWxw
ZXIgdG8gZXhlY3V0ZSB0aGUgUmVzZXJ2YXRpb24gUmVwb3J0LiBUaGUgbmV4dCBwYXRjaGVzDQo+
IHdpbGwgdGhlbiBjb252ZXJ0IGNhbGwgaXQgYW5kIGNvbnZlcnQgdGhhdCBpbmZvIHRvIHJlYWRf
a2V5cyBhbmQNCj4gcmVhZF9yZXNlcnZhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2Ug
Q2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVy
cy9udm1lL2hvc3QvY29yZS5jIHwgMjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKykNCj4gDQoNCmZyb20gdGhlIGNvbW1lbnRz
IEkndmUgcmVjZWl2ZWQgaW4gdGhlIHBhc3QsIHBsZWFzZSBhZGQgYSBmdW5jdGlvbg0KaW4gdGhl
IHBhdGNoIHdoZXJlIGl0IGlzIGFjdHVhbGx5IHVzaW5nIGl0Lg0KDQpBbHNvLCBwbGVhc2UgY29u
c2lkZXIgaWYgd2UgY2FuIG1vdmUgcHIgY29kZSBpbnRvIGl0cyBzZXBhcmF0ZSBmaWxlDQppZiBv
dGhlcnMgYXJlIG9rYXkgd2l0aCBpdCBhcyBob3N0L2NvcmUuYyBmaWxlIGlzIGdldHRpbmcgYmln
Z2VyLg0KDQotY2sNCg0KDQo=
