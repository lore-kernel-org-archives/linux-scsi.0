Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F60C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 21:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241816AbiEXVAa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238452AbiEXVA2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 17:00:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10595443F8;
        Tue, 24 May 2022 14:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8PwJdFpgpqCx5D8jjSqcQ/FntGpj4GlogJ+an3nJJt8kewCBGVcI2ctqUfofe/9T293T1zjzuYscRC8hrivoberSCvt38NsaDeNVy7WH0nDQld5znAM0jU9RNK5M3vFZvnjKbxxCfcGnQdE9ck5PFK0az3vxG4E7SKld0DajjDMGnUJ6FgQ5J3zPWIBrT1AaP1LFoUO5iKATLrD6rVX3QoopynQ6V1p5XOLAnU6ZWE+qmTn4lFXgI+XA9FKBbrXfoa0uVs2IELRittFjSeMSTdyQKFRyAeAR3fzTPmFE9iVfZUa60CSZrSqLavp0mkGnGoY/itEdu2fklRiM73emA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfMllAzx61m9EL53sveyFUxaQ0baJ3KTwQ4KEAVlVoU=;
 b=A/h2TniZIwfDLND6V25RFYqSO4c+B5Eb6QmVFN6PfBjUxm4dtsACaV2dPumS5DrUSzTSHivMFB1/b/FPULnOmIGnEjTdgk8wB164/daHKCV06xZom/xZvaM9b3DkjTlgk1tIu0MLkBjvsljRT9wn3Zye5SqnUHtlNBT0XMzNIA67sW0iLy3sWuW1qql2vxCWpUHXiOVJIJUz3VXB6eGJPrCsr8MmR7zKLT4ADoW8/rmde2rW4LZ4GviPTaINio5tqYxiIhGCmOjI+aSE+JAJJQOdTUkMIRwEsetF7qL4qVCCM2Jcx4jE4e6ZeBBk5ieqftdd4WUvj0LF6OoBV6gRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfMllAzx61m9EL53sveyFUxaQ0baJ3KTwQ4KEAVlVoU=;
 b=bHasUtkVcfNinzX9qJ6ZL+2ebLDRr21cSI1LHcufcSHgCthlPSGh7GeatxgS/NnlmvPullTdM67+GkkSj59oNVSPa1Ui+KZhDgprXj/s9gqaCYJGYb4/BmrZTp8ReyiDfu8OoO7HETAYQmBdYg1QkpKQcvJeJjWM5B0Na1t7VtMATESIHoeojMwKA3C0L5bK/8Q7PxbLW8Xk757aj3/EAjd0mrrZOP9QXFqkkcP2ztSnP1PO0GKxw2MYogdCWeHRc6zg8b1Tzdug2L8let4zZ6ocXs1ZNe+cX/yDPtq2KLqBxHADffbJ+YCy5qDWlxCN6itfEr5mtzPXcXS4mt02pA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL0PR12MB2530.namprd12.prod.outlook.com (2603:10b6:207:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 24 May
 2022 21:00:24 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 21:00:23 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/3] blk-mq: avoid a mess of casts for blk_end_sync_rq
Thread-Topic: [PATCH 2/3] blk-mq: avoid a mess of casts for blk_end_sync_rq
Thread-Index: AQHYb2f9NbkhOO7my0O4HjQTrUvoxq0ug8AA
Date:   Tue, 24 May 2022 21:00:23 +0000
Message-ID: <92c57ebb-d699-1b4c-8443-013cff373ce4@nvidia.com>
References: <20220524121530.943123-1-hch@lst.de>
 <20220524121530.943123-3-hch@lst.de>
In-Reply-To: <20220524121530.943123-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b71a9b8b-9f5a-4865-ee4a-08da3dc86b73
x-ms-traffictypediagnostic: BL0PR12MB2530:EE_
x-microsoft-antispam-prvs: <BL0PR12MB25308123E04E009EBBD59A96A3D79@BL0PR12MB2530.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ThYipkhOTW9LhnVNMaChNOmPXrdvlqz6hhtIKWFsP+/PQpd2+E7/GFva6rFAuvek2UKsQdqXQACOEnGfLL+EjytdiOO+hRfx+ih7NkzU+yUpRWW6P+zXRJesf6nw3akVRpZesQY4nhva7MoWALugeMWqhtPRGHj3WTaExtUV09hS90SgdbisUsnSq/ZEc/G1Sv7da3Otfdpwji8tNcTwrCFh6nkewCFEQOf+8VwmOF4xRbH02W9dpAbxpD2LL4o4VXoy8RMStmm78EFCcrUu6Lz5LwAFiVSs4xa3hNRY86tCiN+tmr3JZyqUoD9mMrWSuqj2e3oVEmSvCjjL2VWbZepxuDDLAWSVl209WGF3KrwmcSRwk0zdtrSUN7KYUaKJZmMk+EiqrMJwgjPDJopuhrYFJzcrYkCu80wJiE/WbNJpz7FGiRyEsIGjoWYQ+eYdaP4GaSn7HhfwXNo6biiDJz41+s1AE8elMvZfjmUiPtL4AXVcdn+j0zU+AM5PyCX8B1SqiS+nvXIGcz5W4ac8pYu5iVTHfsXC6sUtsTxtIkNe3Grqfw+CgYNLuK6ttgLOH4n7ZrEs8aQEU6xyedgiDYzJsVL6SBZUnXVsZznBqhKG4FOwt5q7JVevfc6rmzEVql5corH+WR+PWSKxuqfApHWqXmkuZqRzoQMni6LrNOVQHvlPDCbGKzsY6gzDl0Tk5d2h+iiWNxebep63+8ek+mid6MXwWhZyqHBCswpAclak9Ak+j4S7v3pgMrruRy81Fr+mKQMbeEkfeJKpXYxHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(91956017)(36756003)(76116006)(54906003)(31686004)(316002)(6506007)(6916009)(53546011)(38100700002)(122000001)(4744005)(4326008)(508600001)(66556008)(66946007)(64756008)(8676002)(86362001)(66446008)(31696002)(66476007)(186003)(2616005)(8936002)(5660300002)(6486002)(6512007)(71200400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGJXY0xFTEVFd1FIejZoK3ErL1RQV1VVQTMrQXZYZDZ5Q3pHSFFRN3czT00y?=
 =?utf-8?B?L25GeklldGFwZndSKzJlcElpdmdrcUd1MmswNHo5bVZ1M05kWExINitvQzJO?=
 =?utf-8?B?ejRLNm05QldPQktTSFQ5TGw5d3YyS0xEZEg5V2tydjg1Sy9TdGtEaUlidGRj?=
 =?utf-8?B?TzB4NWhxRDNWSWFCZTJHUHk3SXI0NmoxQytQNXFDY1BCWFhCS2N2UHRkNzha?=
 =?utf-8?B?VCtOMG1qdFZaWXE0UkM2aENwbXJockp5TnJJdVFGc3E1bHNVdzV3cHBueGll?=
 =?utf-8?B?RWhvdzFpQmp6dXhuRzE5UDVIL3d5RzljRktXTFV3UElhNXdsWG81UjNmVFdG?=
 =?utf-8?B?cVRacDNQZUxoK0JxdW5mUUw1bnlRUjNBUGlSNHZPR0J4NDZrbXM2SWlaUmRr?=
 =?utf-8?B?SmhRS3JLSE11LzNBTVVBbkQ3K3dZTmRKWHpYcUp0UjQ5NHZ6Z2JUVUVEWXQw?=
 =?utf-8?B?YmxsdjQwdHZDbDdXN0FIeC95S1poSFpJMURPN0RpZko2TnQwU0M5T2U3c3BS?=
 =?utf-8?B?anRhTXpMQXZwMWVFaC90ZG82TlVvTDNvL2t6bWh5STExVFU1QmVCNnZEY3RZ?=
 =?utf-8?B?RFBCSVhqdVQwSEM2S0ZjSDdGbkNGWi9KdlpCSkxTRzNYaUFha2MwanlaTitR?=
 =?utf-8?B?R2x4OHdNek0rZ1dlQmJtOE5ZVVBxbU9PcldqRmR1ZnFXN3JHRU5hOTlpNE9i?=
 =?utf-8?B?Qk9lRUc4WithbExBR1J0WlhadU81MU9SU29MOFM0cFJsS2ZDSThrUjlEdlJH?=
 =?utf-8?B?aVhNWW1ERHdKenBoZEVqbzQ1aXJBakJXS1JKeWxjdWlVT1RFRzl5MW00UGJK?=
 =?utf-8?B?akJjZm95STNmNGl1bmNmY2tScFdDTEJWNTVXdzRBTEdiUzRIVjBIZ2tJc0JM?=
 =?utf-8?B?WnRROU43d0R6UThNaDkyWGFHSWxJeDdtSXV3cGNyMU85d2ZSVnJzUDZraTNi?=
 =?utf-8?B?ZGhHSmNVTnVoV1ZxamVaZnhwa1VRVGsxNzFMM2VwRy9uMWxMSDhta2NkbXUy?=
 =?utf-8?B?M3FFZHJhT3lXRVJ0Tk1iRjFGempXR2M2dDNoQTlXMSsza2FRd2VmQ09OQmxa?=
 =?utf-8?B?ZU94aS9EY21sSWgzaXVKS1dqOWZzalNOeThRVS9ubnA3VXRpeFM4OFIwaG92?=
 =?utf-8?B?VHRzVTgwbEdWWUM3RG91alZoUDZRK3ZUbzYyNVZCRTBGRTBqdHZJdWk0Sndx?=
 =?utf-8?B?T09IWkNaSDNudUNweU1teG1JZGV0R3RxYWRuUW5LajBqaFRRWURKZTM1WDNM?=
 =?utf-8?B?ZEFULzNxVXV3Q1FVWmt3TDhKMHZ0VE1uNlZ5N2ZmNXBJUWZBYzNSb05Od0NJ?=
 =?utf-8?B?K1VzaURNaCsyTE0ydllBbTZyV3ZVcmFKS2ZuU09LMDViOG1WWVFITFY2QU5C?=
 =?utf-8?B?L2JTNDJwNE0yZTlXTlh3WnNsS3hLUG9RMjFMRGtpRG9sUHNhRFV6bEthNy8v?=
 =?utf-8?B?ZkNobDZLdDlFOUMxaXFGd2NxL0hLSzN1eTlMdFplWUhocFhQTG5NQWFlaEJt?=
 =?utf-8?B?cTVzQWVjL1pid21kNG5NSWEyR0xnWGV0YlZ3R1BveHA2OHpndGdpbm1YQThZ?=
 =?utf-8?B?bUtNUnJyblVBeXJFbXBibVl5K3grWGtZVUtWay9iSmo4VVVwYjdnWHpjdFBY?=
 =?utf-8?B?OTdINUZEV29WeWpTbEpLOVNsMmt3dWpKZEphVXV5VnVGYzVGd21nYndZNCt5?=
 =?utf-8?B?ZkVweWZmTTBFNUZlL1lXeU10dzROdkhRdGdvdlF5NGEwVENKYnY0TjVzeURq?=
 =?utf-8?B?blhVMXNxN3UvN2luSHVTTWh4UlQ2WHBob0JPU3lMeXplU3ZEamhTYlBKNGVK?=
 =?utf-8?B?S0djQTFRa3BqRE5oTzZhNWYvVG1OWjNCbWQ1VkxhNFM2NnVHVTc3a1ZTNDE0?=
 =?utf-8?B?eFN4dWpnK3lEc3dUbHdqMmxvYTVENjZrdTJtbSs2dGliOVltWUx5SUtnVHg0?=
 =?utf-8?B?YzJVRGpzQ2VzdzM1NU13VnNQOUpoNnNyVDc5NXV2N0NLMGVXdzlHUG9TT2ZF?=
 =?utf-8?B?Z3Z5VlhIMk5acGxTVlJZMGdwL3EraU1IRmxyeEN2YVRjTlZ6c1lTSkNkUFR5?=
 =?utf-8?B?cDlzaGY0UUd1NCt4cVNXM2tpN1pqNld0ZDRXRzVBT0liU0FrTVRhaWlMYXQ1?=
 =?utf-8?B?RGtlWFFZNDBySFFDZEw2bXZSTXNPalNIOEg4eU5MMm9aZ1RCY0JzMDFUaXln?=
 =?utf-8?B?RkFWdGJ6U3UzZ1Z3RURsNC9PeCtZaUhhTEttRTZySHY4LzlhY1cvMGJ6ZjBo?=
 =?utf-8?B?LzduekQ5cXgxclFqWWgwOFN1ZVVBeFhCV2EwbVJUdFA0alJMcFcwMm5hMXE5?=
 =?utf-8?B?aFpTWW1CY3grMXZYRVY4ZnVaNXYxY2RFcythTGJnUGxEWmF4aUJGQ0QrR1l2?=
 =?utf-8?Q?Sj2BYubCS2u+KHHpc69L0Z3fE1bgWuRvMK1MEGdBq0Z8S?=
x-ms-exchange-antispam-messagedata-1: FauER+0PNanhYg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B649251DA6D216418A9B97E759FD5A26@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71a9b8b-9f5a-4865-ee4a-08da3dc86b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 21:00:23.1234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kEcXalokpjaB0w/gett5aBm4w8JJ6GIZzpisTpg8rimU0w/IDOBmtmnGmCSgf4Z3TBBSPPHcSduI/Oy7cOlByQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2530
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNS8yNC8yMiAwNToxNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEluc3RlYWQgb2Yg
dHJ5aW5nIHRvIGNhc3QgYSBfX2JpdHdpc2UgMzItYml0IGludGVnZXIgdG8gYSBsYXJnZXIgaW50
ZWdlcg0KPiBhbmQgdGhlbiBhIHBvaW50ZXIsIGp1c3QgYWxsb3cgYSBzdHJ1Y3Qgd2l0aCB0aGUg
YmxrX3N0YXR1c190IGFuZCB0aGUNCj4gY29tcGxldGlvbiBvbiBzdGFjayBhbmQgc2V0IHRoZSBl
bmRfaW9fZGF0YSB0byB0aGF0LiAgVXNlIHRoZQ0KPiBvcHBvcnR1bml0eSB0byBtb3ZlIHRoZSBj
b2RlIHRvIHdoZXJlIGl0IGJlbG9uZ3MgYW5kIGRyb3AgcmF0aGVyDQo+IGNvbmZ1c2luZyBjb21t
ZW50cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
Pg0KPiBSZXZpZXdlZC1ieTogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPg0KPiAtLS0N
Cg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
