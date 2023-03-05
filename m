Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D3C6FA8E
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Mar 2023 21:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCEVcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Mar 2023 16:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCEVcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2023 16:32:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A794315CBA;
        Sun,  5 Mar 2023 13:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkQoKezS5X0X9Rp/DW/leXRVsdHj/lzODg4JTHYpfxcLh761QTXXFWkMDaj/B/jhOgt7h/tIe2B3HpYq0TfVurBhImon4wtF+LqDlGD1cH4pqix7MlaTHHJbEf8OXj3Hm35JfP5jNftfCUQ141FjqclCDjL+j9NTYhd3PD301kONKZ7mscAsgA8Hh5N1WetTyuuMDXCMqB/O/23hOfq5HX73VNsUwGaYQH7fy72Wy40+aTAdLb2wVeeeagS7meUfuHO6Ybc02FdF/SpPyiUkJV88+n1USCOatjCGpiQa2ME1zgeMpls5pCD0+HvX5w2MZ5uefPQ5wlPx7OmioNPjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvc/ioN86HYItZ8opwSd3FBohkZ5WzeeBIc1ZZkKPyE=;
 b=GmzlnRYCobifk/Az0EUuMg25ZUcLFII1IqbCCoxiwsEs68MVOvAo8gQvsLEbOcqN490uimqMv22feG7zXyzZqNLLTUvz+UC2YO/9tLVte9S6K1UszrH4CmXSGGDJVx8T9iTWt4Z4/VqsvcXbQWFTr9nNILhWsEGIKZ+H/k/2ybqa1gmQxH2HUjNKUCtB/G+O+SWh4G+p2v6q8F733eRILZLkLpjO0Z8QYtGkAsjl7bccBUJVXlRxWxbH02saWSpGFe0AAAreNnZbexNXB0Av3P0Zsrf+lzWHWD/a2I8kS2CJ5cCt4nL0WQFBhRS92LKiOQJinMeL0Oy/NQgXaN6wqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvc/ioN86HYItZ8opwSd3FBohkZ5WzeeBIc1ZZkKPyE=;
 b=dTx9cPuOYhY3dXh9fadAVUqfJJZl/LidGk1FhDPGBzc6e2Q1QUQskPhHnoyCee0LnLUfs0R4/hlJrPabGdD4GlgAKOrvU5ZxAjLNvR6DBDGGZ2WhHodIo58HWQUEW+pWSToFixNzL6xbKR6e74TXRg9D5pGSZJp6dM2l7Ls94kN4MNMjFyBNU4rPdFxiMQTOUOH9fn3iYry2rMvUDAa3dczC+DgUg3feT5W+YWjbPlm50+T/oFa68111OBTYKXq7QBATkVem+u3h7vMjHPynsUrbfQUQ9lAa8FoOvtxRnEPDuQ8T3mUeva64GoWCnvzyrGnrX2iWvkw715tmDCRK9Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:32:06 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:32:06 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
Thread-Topic: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
Thread-Index: AQHZSHgc3xJ2ofNqXkeIdkRZxLK3/q7swu8A
Date:   Sun, 5 Mar 2023 21:32:05 +0000
Message-ID: <ce7d9459-d672-6389-99ad-dd6b2c141902@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-14-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-14-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: 91992d17-ea3a-4ff8-9b24-08db1dc11150
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BKz9AUDBdB7B1gmlMhhpXQBKtV4PeB0uLT+fqoCdkil7uz3rFkz0/qe4d0CuT2ObRIgoT/cio7IL/NBcMvMbtG9BV24pwJ8GWEzvchQuTXXw5G6e1WBwiKDeJA17VQF0c8T3wJE6llQS3NmleYlnUdT9H+5CdEiWzeJ5uFj1x/+EcoZJmL03G5uQEnzr37Vl1eA1ATa2CjguYvGhNrJcXAZD6ZVG6nj1pAnMnGZ6C30a1is9Sve/ELBbddT3j1yNilAVplkbf5QvjYYd7SiSXiY9iETRr+UIxFU4Fv8PSJ1lnJFY4gscITlkCorIFKp6f4VGPdkrfe4B/KQCcPuTaAieX3sr6gCQ0lFDj3eWBjYlUaaUH69IQXvt6l7pFiMx3B3OrT4+NYp+0F8U4RMOXqVjvRsMoaqr5PoqaA/Y8Hh5vGtjdC0ICB/ZSVI3qRvBzXHLLSoIHc5VJt6Z0lzqtqInN8vstipt/2BorNdOhn//pJm3mG4IQiRR9ZtBuj8S3E2RLMUIo5F1vzcrgAo4GzuX9+ijNuSZ8QF/n9i0E7RVF6DCXrCuC4Q1lOYmapjDNkpINBaoJZ9TJUYwACG2PL77FAk4FuTAX5YT+BCUrxHHY3ubwQWb/i4kUWAgw/tp62nx2KxtQaZIiZDLR9b40qxEJoxS/wvY8/UOeswBmH0BO/8V9SVZaZz/iflC/VEQgsqwF+FEkunew9BvM40JGyGiGGv8RHKVB3TgsxbRB8m8KpbTkYH+bKKk3lmA3RdR8jhzRumosq6+eVIhjT1g/G0T8aI06TFXfRHWl5XwJ7Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(83380400001)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEVZSExsc2xrK2NncytwUEEvR0g2UHh3cStNU0FCVFJ6WGhDTng4TEpDUFpx?=
 =?utf-8?B?WU1nYi9UUVAyQ3R0K2F4MHJVOWViaHB4dXRmRjVYS0JPbmpHOUtCSDBUQ0tI?=
 =?utf-8?B?aWtLU3B4d0J6b3lEMmttV3pRQTBXYUZPSGJqNmtWMDZ6YzlBNjVPR3RoOE51?=
 =?utf-8?B?NzBHOXdRRzJqemwzK29CN1YzdDJjYU1Cb3V6ME04OVhqM3c1UlBzMU9QaDNl?=
 =?utf-8?B?eGZXNERxSFVBZElJamtLS093a1RJRlBTSmFyRmduTnYwTTZiZzJ6VFY1UVZp?=
 =?utf-8?B?UC9yMmJTZFBFaXVpVDFpRjJEZ2VpSTB3WUVsMUMxRWVTMmdNZFRaV0tmTWti?=
 =?utf-8?B?N1pjSHM3dnY3Y2F6a3dEWXp4Mlc5VlJOdVR6MFJZRW1XWGs2SHJvMUdkRTk5?=
 =?utf-8?B?MWdidkllS3UwY1puVUVjS08yNmQyTjZ6WUVxUVhtTGF2MmhoYWIybzVJd1Ey?=
 =?utf-8?B?d3ZNc0E3Z29NVklxamFFRjlmdVhoek5nYUV0eWhUSGo4OStuUFlNR0tkK3dI?=
 =?utf-8?B?bXJtT0RoeWNoQkxsZ000WjBEaTRTU25UZ2NMKzFHMDRLMVc0ZnFQdjJvNFc1?=
 =?utf-8?B?RkRubktJZXJuR1Y2SjYxUWxrNkNxTHg5N0xFWGN2ZzVobERiRHk0a2VqY1hN?=
 =?utf-8?B?R29LcEV4VWY0SUZLRlVSV01nQWNGSjNiSVBBZ3VOMWNqbHozczJYTGZMU21i?=
 =?utf-8?B?Wm9pL29vakN4RVZsTWY1ZWdZdk5XV2RBSytUY29LSG1lQUMxbEhKWTJSY2tz?=
 =?utf-8?B?THpKRkhOU1d1Sk42ckluSUMzUVJ3NkpJdUVJQjdpdW1QV2IwemxiOFdROEZF?=
 =?utf-8?B?NzJSc0RJTzd2RXBiNmEybnVBVE1HbnhoTVN3RVIxWkVneExpK1QvZUF5ZXNG?=
 =?utf-8?B?aVh2Sk0xd1hVMVIwWnp0TSt0aEFCaExpdFdpc21YMzRVT1F2ZG1HaVl1Uk5i?=
 =?utf-8?B?ZzRZMlluSUR1WjN0TGxLVVZnV1oyLzM2YW15aEZqczdaZHNDaEJhMThpdFFZ?=
 =?utf-8?B?R1ZzMno4Z0R5a0VCU3BGd0dUc2FLM0QxTzEvczBxb09sdnJLZU1UNkZGODZm?=
 =?utf-8?B?ZVBpOHZrM2V2RWJTMGU1OS80S2tPTjBaTjBka2NJb0hqYUg5QkZ0TVFFaUpr?=
 =?utf-8?B?K1hJQjRob0VCTEtCNS9sK3VpOGRUaVZOUDBrMENHRTg4Ty9IZlRQTGlicVI5?=
 =?utf-8?B?di9mOEFKaFp2UnB3WG1hbDhNM1hRUnFOVHpaUGE0SnRUV0xDand3VlhONVlm?=
 =?utf-8?B?QkMvSnRqOG1yU0pxRHp4MmRIYzZlcjErd2pFYmRZc1dRZm0zMG1UR1dZR0Zq?=
 =?utf-8?B?akM1bGQyRDM5Z3FIMk1MMlFQU00ycFBZS0xUZ1ZkSWl2ZnRRNFZhWVZkR01N?=
 =?utf-8?B?US9LNWJsMThZUEp3R2pldlFmbEYxZGJYc0NieU5yUTR4OVo5d1dJSnltNEx5?=
 =?utf-8?B?UE9ybXEyMDZXQ1hxY1JFdnVRVzhMYUF0Q3dZeE1LNnJ5eTA4dEpIYTZyTHMw?=
 =?utf-8?B?djc2UzZqOUZ3R2IyVlowS2hsajluNFZqSXlWMmlaam5MU0twazVWbnNHb1Bu?=
 =?utf-8?B?b09zZDdLL2RaV2toWUF2aEZyNndLWXJEN3ZuYjN0K0xlSXJTZU84QW5qUERp?=
 =?utf-8?B?WExBbEtrSDlPelMwcjF3alhPME9sQ3RLcVhmLzhsUk01azZRWDcybTN0UGFs?=
 =?utf-8?B?YjlhMFVxOWZXeEpMd2gyTW52WlRKbHkyK29TUWI4RlZCMjd1R2Z4SDZGdnFX?=
 =?utf-8?B?RFpQK1hUU3U4b3BNVXFidmtsWnZXeDRMVEZqb2NoS2NkV3ZQWlRKMEFFelhu?=
 =?utf-8?B?T0RycUFpOXF1TFYvQk1BZ254YzkwS1QrbGsyc0djTkxHa1Z4WFNoVHFvNEUr?=
 =?utf-8?B?R0I0a2ZjSU5KcUZVV0FVS2QyNU9RU0I5MjZuYk04RnoveGlrbm1ab0tnbEJm?=
 =?utf-8?B?MTVlek9FWXFRRVRyMFhhZXJiekJBOFJCaWZFVzllMTZnSUYrQ0ZDeGkzVXJI?=
 =?utf-8?B?ZCt4WUl0U2t5eTJRQVFyWUhJNmZtbWtldXVGckZTdkFkd1VaOEQ4MG41WmdG?=
 =?utf-8?B?K2pkWWdxM0lCNUpNS0V6dGR3SS9zQ1NGYzNnbkZ6NDZQTU5WYzQxT0NDdmJt?=
 =?utf-8?B?RGVHSjlwc204SnI3amVrdkJ6VDBDSWJxTGhuZ3RMWFM0K0tMUlBDS2laUzFO?=
 =?utf-8?Q?0rIWKxxnUvZuW2lPmCUUv7oQSFeQX755h5KMlr3J8vXL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AE43FA79600114A84A33EA6962144F1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91992d17-ea3a-4ff8-9b24-08db1dc11150
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:32:05.8821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSeHjKjoJvf2CxX4HujPi0Vb7XU7ZxrUHW8zU28M9zUWth1uiWdeAmK+XqEjXRho6sdL8UXfI990w92GfaxfRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8yNC8yMDIzIDk6NDQgQU0sIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgcGF0Y2gg
YWRkcyBzdXBwb3J0IGZvciB0aGUgcHJfb3BzIHJlYWRfcmVzZXJ2YXRpb24gY2FsbG91dCBieQ0K
PiBjYWxsaW5nIHRoZSBOVk1lIFJlc2VydmF0aW9uIFJlcG9ydCBoZWxwZXIuIEl0IHRoZW4gcGFy
c2VzIHRoYXQgaW5mbyB0bw0KPiBkZXRlY3QgaWYgdGhlcmUgaXMgYSByZXNlcnZhdGlvbiBhbmQg
aWYgdGhlcmUgaXMgdGhlbiBjb252ZXJ0IHRoZQ0KPiByZXR1cm5lZCBpbmZvIHRvIGEgcHJfb3Bz
IHByX2hlbGRfcmVzZXJ2YXRpb24gc3RydWN0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBD
aHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPg0KPiAtLS0NCg0KTG9va3MgZ29v
ZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoN
Ci1jaw0KDQoNCg==
