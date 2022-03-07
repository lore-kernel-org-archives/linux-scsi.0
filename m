Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F376C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 03:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiCGDPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiCGDPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 22:15:15 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483FB44762;
        Sun,  6 Mar 2022 19:14:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TB046jMgdE6Mo2ru+22dMYSnaixIqZZMIDv0TGZLp8fPHul/ZzOPKostKu9RIUIcLimNBhpUiDrIg+9O1YNuLVLKe36tEKoJryGInChR57fajWQzPkVK7mE2ZOYISWZaWGchyfhEwnYsKV4cjfzaGFdGupsaEciaqpQ8ulaXNR1hECH5hN+/VoM73Nf75Iur7EFu0xq2HLcfPz/9991SJczbvXQCRAl+pKzVtRucCrslQv/kC8ye3sZ8GXNklgkqxHJsP0GiycoPprwohGvIR4LdMIwDoxXU6yeXszz5osEpHgmISK85w6Rk9ZsDEq9WoswVlLGSXxv8mu385cG7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXNYCSbh/d99VC1thbi0ISZC/nbIchpxT69Js2aoDF8=;
 b=kR9Qwb5PXSQ/evBK1MVglOMLVbR9XlZEz+3/7q/06c1CW7voZ7pzdwexy4ejX3GYx1WzfPQ3BPZILqSU/DoS/atrLbZT2S2dj5xzehpM6ivGPcGj99y0wi2Yj6jDuUwlcOG2CV8mpSFHeiXSDPiiz9IeyrSwXDf5v6Si+UmzsrGIOKHGf0Aa2XleXhy0vqqthTzLuIClvh+iKnMDfts1Ck+mzzPo86B6b/2ay84/HHFblCvvebzsk20SFvi1eDAxSA6wgs5rGfH4sg1wz7bZ1kctXE8hekbdhZBGaHW0qvjwkCyS+4vn/ISa+hfXlQtC+unL9Cgrczps0dLpvPteow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXNYCSbh/d99VC1thbi0ISZC/nbIchpxT69Js2aoDF8=;
 b=S1UZaNWnS3ymwtm0sTt2E91PHJxBBNGxoHmunDwTfMf9LKrwIXRcJxwIUjiH2JcgPKkBAjqPY6WPlWrZU/S+SeX89mpAx8NlBErTYLOaieTcb0R0eztYpJX7B883eu5LGS934zYfFsK1p0rxHbTl/ieTbgtMvt4ZDMBozxja5Y0DyfkaJz8eexPVCDAujv9s+l18bDPKbpxHQO9sUzikSsWsS4xVwOKMIxkU0cmSpsJhDt/nTKtOtVGiOVMyGOyg7yFBxNEd5DVFjHGeVjlpGVWsv8Acktk0bs6hsRUX/d/PCBaf9mGpjGWzPS+w876ZAOL3mwGtORLknjQLK6KAjg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:14:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:14:16 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/14] scsi: don't use disk->private_data to find the
 scsi_driver
Thread-Topic: [PATCH 03/14] scsi: don't use disk->private_data to find the
 scsi_driver
Thread-Index: AQHYL+F31GGRbURjTkCFUTEdZsxJ2KyzQxcA
Date:   Mon, 7 Mar 2022 03:14:16 +0000
Message-ID: <ced17845-4f26-e902-0aec-d8ccf31bd0e6@nvidia.com>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-4-hch@lst.de>
In-Reply-To: <20220304160331.399757-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08ca57c5-bf50-4482-1e5c-08d9ffe89059
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1853506959FE00B3C457FBDBA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EZ0P2nZPMbJ63Fys2GLd9uau9PemTM45rmxsneJC5eljFdPghwLLpjA4/h4B4j6FPeiJr6knhU25HOj7zIk3Tgfp+fegJQ8YYs9DFmg1hZ+iv7QVdy/17w0GFSVEGRwGQHc8eY2xmjrstOY+1k1VlzdphZu0r0qL42VwahfT9NnYfcc3oX8aCkpuS0FgEJE6IgEbeOuU56FqnzodKf20QnSv9O8X81RX81S9sZnceBhFzkgwMl+Ab4U1Rh5XPQziBlZ/zydXQO8VvQhkbug1va8rRGh6qL/CIUWg+YDvsivT5AtmL6SLZ7z7dM7RxmOPLo9ajnbesPt7E3KWZejMYyK3BtKMHM81lfNi016HQQ/uKssJvFFziabKB6cGxrA5g2Q76Qy6tg07Kzw3wT2FH+gfaYw9vQd+TPHo2EfNix1bN+GiCvXM138mjZG3jblk4FVluosFLoLIG2yzJ5UuOWAKCH7V6yzjaLEMHO014Zu3U6oDolc6M04vHFAQFzdE1l4DtQlE4KQ62cYQ3ZRyOUVLF3u5bcS2bX4mQ7JUa1FzhZEWl5qijOkzepN33dlfnWPsti1Sq6hc+0owUfA0efpelrgm0n8SkTznitcDXOVJqNRhD83X4wAk6InOWMcx90YqERvf0E/4QzMLxO3FkrV3JoUwoX8iXkDsUpSmr4i+FjySXMr3hy1EnMXEHMEIra08tJJLAXQRjJSFjSJfRTWTURkJkWNtkgVOHuc7OangJo1JzC+oWS1+HXraKR1uRZbChJomV+V/pd1R5hORByQDDLcpZmpZBhXo7VB035I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(4744005)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(76116006)(38070700005)(316002)(91956017)(38100700002)(37363002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0pneE8wUHcvWXorYW5ka05OVmNCcExmVjdyYU55YmxFRkVNMDdhSllLdlI1?=
 =?utf-8?B?RUcyRVc3cXZpenJENUJ6bm5sRUNScXhBcCtNTlFLeklRUyswVWVMU3hJUXl2?=
 =?utf-8?B?WDZVUnl6c3NYbGFhZUV6ajR4WU1XakFVOXRHMEJmZFI2cFZiNXlQZnhQWDJn?=
 =?utf-8?B?WXJRVnJzWDVPei9zUWFPY2dhYWJZWDM5UkNTRGpLaXNsd3dMelpYVlA4Q0dN?=
 =?utf-8?B?Y3orRzlwSzJna3k3N2NSV3MxSHFxanZEa3hvZlRVTDZ0NElpTnlWbGNzYXZK?=
 =?utf-8?B?SWpyTndMWElqNDdzQlBiMzNib1VZank3YVlPeXhpdzF0SzBqZ0pEWHl0MzZT?=
 =?utf-8?B?cXBxb3V0SHJqMjBwWHFybnpud1NZVHFuZUZrYS9JSUR0Y0lETVRScEduQmQr?=
 =?utf-8?B?dHpoVC9NVzkvU2pCa1RjR0ZteklqZmI1S2NHRml6UEV6Q2pmeVB2YjdDTXZZ?=
 =?utf-8?B?SUJvMllCZjBjYk1JeEdYTDQ1QkVrVVJlNmNpc2NUa1A5UzRMU3JWZFQvODQr?=
 =?utf-8?B?M3g2UWI5QUI3R3U3Q1hQWVJtcGEydWVHbTRXMXIxN08xaDJvQVBqaWZUSlN5?=
 =?utf-8?B?dy9jbUFRV3JrSzZ2Q0puYTBYWVdIazlOSDZRWWtIeWZia3dkdEdwM3JaeU5h?=
 =?utf-8?B?N2MzNjNjQmZoU1RBRXFzMk9vSHhvUEU1NGNUKzlyRmZTeWU2SEVoLzBRd0hr?=
 =?utf-8?B?d0xMaHRGMTI2dTJkWkxHWW95RXBHVHM0emRCN1hVR2Z5Y0F6a2RvL3g2TG9M?=
 =?utf-8?B?RjlvdUc1TmN1MFRpQSs2bDBPc2Nuckl3S2JZeDZCYkwrd2NPSDlZRVQyOEpp?=
 =?utf-8?B?bEZ3RWVwejhnSjF3cytoaWJPMGozQ0VzMit5RTVScll4UEZXQ1RINktoTngr?=
 =?utf-8?B?SDRRcUlKcFZCMThTNStXTjc5d0k2TklvTFhaTGwxNnlvM2I3MnlvSTQwWWVx?=
 =?utf-8?B?VWtTTEk5eEVzNGJmeGFqdmpPTVFoV2s4QUtRTnZvRlBRNHNmWmVERXF2aU5k?=
 =?utf-8?B?blRiWXlyU0JmRlRLSmVSQWt1ODU5UURFaFFzemszMTU5TWtnV1pPTDM4V3Bn?=
 =?utf-8?B?NEFHYkphcXUwZE9jZlpmVDRjVEZCaTZEZVBBK05HbWRDejVsVjhoL1MwdW9n?=
 =?utf-8?B?anNhRTVOamM4U3NoNkRTL01SVE8reE12QTVnTzFKOU9CTjZpeXZ2NlozK3hI?=
 =?utf-8?B?THlGTlZnbnlSZGx6aTMxMmZVSEtiTWJVV05YOHArbEFCMXY2WUtpMEVrQTBv?=
 =?utf-8?B?ZmdqMDE5amxnWGJXMitNaWp1ajBpMk04TWM1M1pnRkZES3Z2VWtKdzZ1azJE?=
 =?utf-8?B?N1NhbVR5a1VVWUJWVUFKSEdRNEpzZm9vL3dsQThjemZmYlJZMHBzYkNkaFRv?=
 =?utf-8?B?VC9vM1JtNGhmZGkvWFhiR0twSzRvWjhYWS9kK0U3a1dXQXV3U2dZRWxxbFFo?=
 =?utf-8?B?VkVpQVpwUk5QdnlVZWdUTCtOdWZWYUhFWUhVejJVT3hGM0Q0RXowUHdzZTFo?=
 =?utf-8?B?bllRaS9LM0tQckRqOG1NRkFicVNnczBJR3BReGVmM0l3TFJZQlhyd0pmd1hC?=
 =?utf-8?B?MzlmV3JxRS9RQlRRY2taV0ZYaE93VTlIbkxzTDFjWHdONU5hekJ2UVB2Ync4?=
 =?utf-8?B?K0VmeTlTTjFsZVVDRjQxTXRHVmxVZWpja3h2UXNGcnJzUVkxdzkvamZrNlVo?=
 =?utf-8?B?cDZSRENvZG9hZkRKTXd2WTRBNWUxemVSSXRIbVgwODdOdFhPMXhibUNtakxz?=
 =?utf-8?B?azhvVTNEQVAreXFtdGkwT3QyTmNlNDZtRnhjOFIrRk40QVpJUTFZTlhWRXlt?=
 =?utf-8?B?d2ZSWVBwc04yVlZKWkYzZXJFK1pHRUFIMDFiQjRnaFpteFdOZFJiYXpwOFMr?=
 =?utf-8?B?d20zTFVBS2d2L0FmMmxxMENtYjJWRWJDRDZRUGkrdVNUQ1JtK1AxRWppZmhu?=
 =?utf-8?B?RjErRThVUmhBQzJENGZQaUlYc3VxckpDSkhGbk0xelRRem1xVjJ4TDFUSVlB?=
 =?utf-8?B?R3hHNjlaempkcmdrNUtWeVVoMUNzekxhaStKQXBNSlY3aTRUMUxLVk9rMStC?=
 =?utf-8?B?NDhLMFZBM2RsODVPK0VuSmxTcUFVUyt5RHN3UUs0a1dLaG5NRDZnN2dHa2ZR?=
 =?utf-8?B?MUd2aUhCd2lGbGlpTy9hYU15bmN5TE9EN2srMU1LK0xDZ2dHb0Y5OHpCVkcy?=
 =?utf-8?B?MWd1YWJIWVpGbk9JNWNRaFRrNG8zOFNUZENRK0EwT1pMZ04vQlR6VUZHdkE3?=
 =?utf-8?B?YVB0RXpMeDh3dFIrSnBOV0dKc2N3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F46418D96BDD344AA109EA1D0F6673E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ca57c5-bf50-4482-1e5c-08d9ffe89059
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:14:16.7797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2I+gmVautQNV8O8UAEWNC6OYIiW/38mPViC/QrTlMDva8raRu2F0w72t9cZA3QvDuxCKSXO7T9G4bNd8DuEjLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMy80LzIyIDA4OjAzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gUmVxdWlyaW5nIGV2
ZXJ5IFVMUCB0byBoYXZlIHRoZSBzY3NpX2RyaXZlIGFzIGZpcnN0IG1lbWJlciBvZiB0aGUNCj4g
cHJpdmF0ZSBkYXRhIGlzIHJhdGhlciBmcmFnaWxlIGFuZCBub3QgbmVjZXNzYXJ5IGFueXdheS4g
IEp1c3QgdXNlDQo+IHRoZSBkcml2ZXIgaGFuZ2luZyBvZmYgdGhlIFNDU0kgZGV2aWNlIGluc3Rl
YWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4N
Cj4gLS0tDQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJu
aSA8a2NoQG52aWRpYS5jb20+DQoNCg0K
