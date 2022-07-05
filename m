Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC09C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiGEGpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGEGpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:45:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2106764EB;
        Mon,  4 Jul 2022 23:45:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMvSOdJ+JdAcPoPKJ8LIa2wGnBe4qCtoPJWmn1rZB0Rjr+UXA5fpSvT8qZUOIAU2W2dhYCpHMTPyz4agb08RwUZklQoavIchCEcls15To8E59sILMnZNvvHDKsj1s4UPajQC4IgcjOF4gKRZ3ip1TeiHTFwnD2J5490rosdGh3m5pFvwdEbl3batpG8LymuDENe+ziCr8hyEcoJJoPPw3vGzM1NDt3zoKENZ8cZIwGv9xXjeynW45KKBxbjQPHz9XxfIa4YbvyOWScXNLBDjWIS3TPpgX376vO/Hnduq2TeqQzZh3rhVTjQjyEHoUWfWnFfrrJwMeKYdRBsGGcq6Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Se4Zol5kE7WDbbdoO5qR3dV3/sae748iNJ4VfDfjBc=;
 b=hhVSi/fsWTXS7UGsGy7XgBw1vJnCQiR3a+V1dJ15P/qNuQVakuHr1DKLj9P1GHZC8+I5xphEO14yxelwYsK2jzqNJdEG2O4VRNOwpEZiIiPqK0vGgQFb5IA0RBajqVHjpogAtsP15ddh4TU6IlTgXdOabSDjaF5d0y6DmEA0PJGSt/2i9BSJwClZuKDvBk9iTUQb9jFR3ASuhEA/OdiiKsKGIAPBRAF9VYEf17aI8hVQvYeTjh7qGG26aXSNADgbmZ9/Z6t5ORGcIstE86lV/44HHz9rIMCNREvhkGnZFU/h4FL5CXPO/GDmZglJkdqC18sS7kiQZHLMoOPpQRXy4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Se4Zol5kE7WDbbdoO5qR3dV3/sae748iNJ4VfDfjBc=;
 b=AEL0KDy+8uZOdD/PJpCWdrcu3vC60fboMfp3AufG0edWqw4x+wKxC0V0tsmOEcH5LEGUlxbnP9zX+R/tHYzPznl9xEnM7lGh4ou8E7rtyz33nAV1Bnkg0FOQ3pRbcT6/zA/3LT5ZhZapDz0HPH3QhmC2P2RR2NuENQCUgF69cJGxB6rxtCRww4bwKKBzmt4ICqNScYgPrn/164/mL8xpCeVRruna9jYMByITVR4TTxGwAB0bzmNIZMs/v4j/ofNDZp0Jo4HbKQgorDniHI1p95YagdnmqQqLoTc16KpsVujsFT6nzgtOGqeZ6CtbIVTeXJA875pLTwwSYPptsw5Ddw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:45:09 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:45:09 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Topic: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Index: AQHYj6Pt5Ue956zlMEeN5WNRzyUf1q1vVkIA
Date:   Tue, 5 Jul 2022 06:45:09 +0000
Message-ID: <5723dbf7-33fa-00ab-b599-b99523f6c626@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-4-hch@lst.de>
In-Reply-To: <20220704124500.155247-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 710bfb37-6e15-4d2d-d30d-08da5e51e765
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eHfb+X9zfppf9PXXyIviJvd2Q/50b+YybNC6fxRo1PF/oNNXbRokCDkzJqMyFBepnfOJm8a4GVDMSJ1edzIqoyfTlf23/0thpfox2CHPmZl7nSzS4OnHln+HwmiiB7N6pI6bT/1UO2U8Q8iJN5NFRHX2UZJPveYEOpHcE51V2j3jMxpplNmaFQ01vnuJGdQwiKAw1K9kwgVQV6M4MllhsWkhGmNW66hdQ7XEwzSMHpazkdYTJyYTcKyBSHC1gmxivMyhHZjFgspG7VihuLquRtHFiu1IHrAuza8zJBTCgRY5XD4c23HyAi4mbJkq6qeJcLuchT+vax2GJQuLWjm5/fnZvxcVIRE0Zrx8vjzMoJyH28UMJNKYiwZms3ASb5f7Ov5Fb2lSxvOICgGKlsYFCzgweC1muyYGc2igm+ty5xTdA/xkpDK/stj+kydsbJ5y2smIVB8oG5ozYYEkGTH3EDmwhq4FZ5bXGYW3NC15BD/EZPxT6L3GE2a4WHCiYY24RD9isHarhPhLXIcCvfHJrUQfZCBtFsOQNdrc8uwvONaZfIiRr2Zgs4fcE76lw40ifRLoooHNR9Q5QxPlur3IxZPflxaglExaQ9yPMVknfil722fqPWkVCJHBCfvWsf2ltKmHjUMYeWJT5i2Hv/jFDNoQMulyZZnVXqfzyj4qi2nEx1GKBQhJDAXRDU2qwaEbdTIX619/f4quMSUauN6qBtMs8neOvgz26MIjPZM0t//w1NeJ3k+8FOcGd2SeMm9lv2mBNEGhXcbvS+nO5f7CJ4B9cuB0ATtSOaYpCh3AIODe0UKLMnDuLxFyhlIshaHfwL+V6Z5S/V8PJf3VXnZkUDpfu+ZelbJYpCJmVwEefQ0wwFPqnPGiy0+PQ85KT6Gm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(558084003)(36756003)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(83380400001)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFrVzhVQVBmTHYzbnVaU1lNRTl2cHJ6V2QzWVJBYUNFYWZ6L0F4YU45R09I?=
 =?utf-8?B?NnQ1Y1NsMk5yazVLMUNYSGwrNE9NdVNIMG5UMkJhMExMTGZHQ1FqSXFRY2t3?=
 =?utf-8?B?eDNpNEk4cXdoZjdtMkNZUnY0bmYzdXd3cVdwVXlwZ3NNRVJidVhvam1KUWlN?=
 =?utf-8?B?YngvU1Y3bTN0RXZ6dk9JRnA2bjcydklnckVuRjVheURIakwzU0RmMU5lZWtu?=
 =?utf-8?B?NVhRaTdUUjhNU281aWJWQUROZENVUE5QdU1TTlRUUGFWMzFaKzZ2b1pkV2cr?=
 =?utf-8?B?c1R2WEU2TTh0UytOMTg5OUdLZCtjMXlkbXQ4c2lqYzdONWxVZTNoaUVLRncw?=
 =?utf-8?B?RGFwNmNxbk1lVWozKzR5L0xmcG1GQUxmcnA1TXFwSHJmSU9qZnN6QzRkSGhQ?=
 =?utf-8?B?YU9OQ2JvT2RQY1J2bDdLVlBjUXkyL2tEY1dNcnVJa3FOeTVERGQ3a3gzVG8x?=
 =?utf-8?B?U0d1L3NyMVU5ZWdZaFk4MDBvbURNZVRIK2swRVh1RXhDZFM0anNZQUx2ai9x?=
 =?utf-8?B?VFVpRjFZOU9Sb285UnU1SkFzUzlHUGlOR1h2M3I3dyt4SFVHM090U0VHeVFJ?=
 =?utf-8?B?czUzUUpBTUV6aGJlUGNnZEFnMW1xUDVhY1BVMVdYWlhtaitFNnExUjdSV3Uw?=
 =?utf-8?B?ZHV4bzZKbjRUa293WS96dDdMd01JUWVDbFNMaDF3MDNrd1VNWUhKY0lkREd4?=
 =?utf-8?B?cmYzdlpXbm5FbEV3SktTek8rUXByb3dzMzMrKzNYb3B3Tllra29iVFFIaEx5?=
 =?utf-8?B?YUpqN3AyOFplRHJXOWp0SnYybERZUnVHczV3ektNVE9lUHo1ZFU4WFVXUE5p?=
 =?utf-8?B?QUVyS3l4ZmRHdjhjSHZWTVRWL0xWN21TWFc3T2l2amdNMGVBbEZMdmtRUGha?=
 =?utf-8?B?Q21ZeHBNMkliOVQxdjNhbUxUYVM4d1RlblpOSmRVZW81RXF1NjdPUTVHQ2JB?=
 =?utf-8?B?Q0I3anRObG5zRS9YU3YrMHllT0VSblBENVhiL0ZKKzdxSm15a3ZXQk9jRy9n?=
 =?utf-8?B?MUozankyQUQyNncxSC90dlFZZzZYMDAzZzlnUjFRR0F2Mm54TjBMcnNEZmNw?=
 =?utf-8?B?V3ZVUHJPRE9GeXZmMm16bjNHTUhrV3RseHBTS2hSVHdRQ0dIeEhxT2w2bnhY?=
 =?utf-8?B?Qm1BRHJjeVlraTFNOFFQNE44MTVsYXVpbTZRUDBUREt0c2ZJckxhN1lhUFVz?=
 =?utf-8?B?ZFVnTTJUVm1VS0krL3NMbDIvaitjNHVzTkRJZGkrOGdhZlpzVmhqZmsvYytW?=
 =?utf-8?B?T0dXa25ia1hacW15TGhGZlcrNmFsU3hHUEhybyt6S040VkZSVWVvU1R5WkVP?=
 =?utf-8?B?VW9mWGdud3RmZmJuVTlGUjMvTHZKZ3B2aVo3MlhlYlRjSjluYUJCSVlRNXZm?=
 =?utf-8?B?Z21zNmNNMklabkhkM09oQnQrUllFNTQ3K1B6cUlQT1BpcFBZQ1N4MkJKRkhL?=
 =?utf-8?B?NS9jNGZEVDZCSXRySk9iMnJ3QjcrR3YwN1hxSTFkb0FlZ3ZmVkZiT0NQOTAv?=
 =?utf-8?B?NnZEa2EyaGFKL0tCcFYwZlFtcGxQb2FibXZaQ1NibFZiTVg2amxXYWJPS0dx?=
 =?utf-8?B?elg1TWpVMEdHUU9EOHkxWUF5eVUrKzVyMk15RFYzTmhEOEhZWGtmeTd6SFkv?=
 =?utf-8?B?T3RLV3g5SGMxODY1ai9hMWQzOFNCc0FBdE1mLzJMcHIxVWJxV1VDc0lTYWox?=
 =?utf-8?B?ZGdVUFJMa0d4RDVwM2toTWNmRlB2MG1VTWp6RFgya1pqQ0hjWUY5ajdFdzlD?=
 =?utf-8?B?dDd0cU9BaVJXeWdkTG9iZDIzbGRPKy91QXViOUVGR1Z5ZmJGaFhuK1JScERN?=
 =?utf-8?B?d1VjNkdPczY1THZIRzJVZ1FmYWpxamFCMUMyMm9FMU1remF3OW83elFzUEU0?=
 =?utf-8?B?bkErVmdaaVVYR2ZDWWlTZ3g2T2hqaHRlWGxVT1RiS3NkbWQ4Vmg1YkxIMmh6?=
 =?utf-8?B?NGNaakJjUElzZHNSd3NWc0ZyNjhUZ0k2RTVaTUxHZkMvb1RZMUg4UEhTZUhq?=
 =?utf-8?B?N2hGRXNTTHEyR1haZmtnTEg2NVY1WVdWNmdKTlRDQ21ZZXRzZTV4VzhEa1c5?=
 =?utf-8?B?c0hJUUgzd2JhRTBtRWdOaWlZQTJVZFdFakRYbVJoanZYalU4T0dXakV4YmxV?=
 =?utf-8?B?WEhEd1h5QUpqeXR4c0llSzRMREhOL2I1OUN6LzN2WEIrRE5ld0RDNUF0UUY5?=
 =?utf-8?Q?4r/C4v5KgKW4Uq08a5wieUOS2QVVjGP+jGvr3dkIwBYe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9864ED06C61E6F4D913047AF914697E5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710bfb37-6e15-4d2d-d30d-08da5e51e765
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:45:09.3606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7KszDDUfDtlXu56kTGUPShMa1rEA79DDj8FZB6gtICKVjsC+pgOrONeEwQnAIW1jJinV6IKyxj2JYnAkq/P7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSBiZGV2
X2lzX3pvbmVkIGluIGFsbCBwbGFjZXMgd2hlcmUgYSBibG9ja19kZXZpY2UgaXMgYXZhaWxhYmxl
IGluc3RlYWQNCj4gb2Ygb3BlbiBjb2RpbmcgaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJp
c3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNClJldmlld2VkLWJ5IDogQ2hhaXRh
bnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
