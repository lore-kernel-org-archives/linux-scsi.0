Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A33C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F55C611C3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242860AbhI1VXy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:23:54 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:34784
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242839AbhI1VXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 17:23:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azREovUuICWjbf/w0JU6b57JO6aLPO5w1/An4yWwvintWLTGmXPUEnNmDxRDpGHFBjQMy5/h9KpATSxhXnLlRnhAhj4t6GHcfBrxXsS6sn0dYUZIUbAJFh6HTuTCh76Tf7xn2UOtAp/lh46tvPdroG2amQTCzcsCj0DuxKn7DAAwLNGVIc6O4A+1L/tTrYiABR4mEORaP2YnYJY3iyqbq0a+vqp6OR8OaB6Ier8JdGCJK/UMmhNIccWi5b5roZicjjDE0l9UaTz8p57NABlL0/F30tduDN10TdMCU5i4ziq1AyuuN8Ru2QUX19LmDpWXjkrRlGkxiStedb/pK5NO4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7qv2ZOtioflrgsFijVseRIjoP2bTPcEJ5E711O2QImE=;
 b=BDuc1vl5pNRvgiPDWh7AOBO/je+usvxOa88xEOcngFxthNmXR6Z/GuxXNFWsPS7H0I8xJ8cTIkbzH53hhHDDYifNM+fjBPHfvKWRefYcNOg4JgXinkjtKfy4YTkJ15bKT0k6LTLse2ogtGkCnVoxK7s9dyn2bP2f3VxdkPW4nmEuMDC7qFv2nf7kqgcN+VTphJsY9EL6DjMe+L++34tx+b0DyHuMrMUcfJAR/Qu98Wgf97zKjHQA6jIYPq7A5blF65kkzX/pa/7SDxFjAOvmrzWCTWjmQ7ZwZK4vrhBixwfZv8pR2SP9tsj4r/igc+H058JyBnv+53Ejosi2llyrwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qv2ZOtioflrgsFijVseRIjoP2bTPcEJ5E711O2QImE=;
 b=jDtHBtFf1oJNIOYpagqxgQl3pKHp3nfm6w7ty5o/DQIxkZ5XZ10hDOE8ULyrwP44TePri77AdS0oLtAyRA+ZgJwy0prguv1/nFrq7RnqVWh/T2OCYdlEG58vfNDyV2EbAlRz8H5z5QT+5/fluK/mgmrybUBkznhtExX5jiZAIdam2jV+o/hFe+UeGcA6hnJZxboCnt35vkbY5yd9NJVh0XbtiZ6SjW7XXf5fJNbK0ZBRkOgvE04U0gioN4ziTHENoIi52iIMSEGzwS1UzVsZiWFIa+qQqVkqZjg4fiAjERDUe0ih/wi0zUo+lb8hxobogukW5AGsodFxHb4sCI65Cw==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 21:22:13 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 21:22:13 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Topic: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Index: AQHXtCkr41vPlTt4RECKC2kVkjtGu6u59XsA
Date:   Tue, 28 Sep 2021 21:22:12 +0000
Message-ID: <244ce3f6-5391-de3a-3ba0-70d4605d32a7@nvidia.com>
References: <20210928052211.112801-1-hch@lst.de>
 <20210928052211.112801-4-hch@lst.de>
In-Reply-To: <20210928052211.112801-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59de3a72-c220-4807-ac04-08d982c609e0
x-ms-traffictypediagnostic: MN2PR12MB4342:
x-microsoft-antispam-prvs: <MN2PR12MB434231E01FA11BBD265C11D2A3A89@MN2PR12MB4342.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kk/RQwzOMv1e+1wkTDHNBKpvzENqMWapO/8Xv7o5+MDyhZ5bd0+S70bpoMjcyUHGvt6ExhxlTz6I+W8XloHOQCIhljZSIDh5dtwMe3pwDvPR7eQJcBDvnIHkwgKRURfuNgaA6RXvKwylSBTs+xN8941aGSvgRHkdEAEI20fal6GRTQ4gszsEQmIe/wnOs7IW2mZZ0D8ugq6Cx0wDItHHc2YATfWsMqGqNOkkh1kqfhyXkNzhdemsy2RK2sQwwdTNzGXwnM86Xe8cPD30Q7CXef43uu+zkJSbN4sA5qXJoTYbIXkWAS9nbkmtcP5eJkbwIUyLB8fgBfXCCNxA5ykFCcOAUZfKQCCzxEq822H75AoD9UBrfuDVKVZIkPXPhScEFS2DAwKrXyRGz6oQheg7F1zTulAtmnwDFO87JayMumHa2AKCDkBMD/RYzdF6KbbRPOjo4ZLLetDcx5CTJtQnRJmnqEJSRtLt6ilud+6vEMVBT3PVltEfSIf2HjsJJv1+BzDS2T+oiB6wpfmaXk/IKZjMmNex9kYjjoQZV0TzMzG1gXxkJdhgAb4zik0UvTuKuXE/8rSzzJpkgv4ytYTv2uxyG30f5ims9IzvrjB6/uptBmv2gJ2XQFNOGK/q4F9DRzy9mNWwUMBn27/fz9cIr177IevNbLposDRws94qU80/GNK1RxluJVS1Nfk0l2DhA2LC2qBYlXMoCJd4VV/2dlL7vQnrHjU/U1kjTuZ+hpU5pcmkeUCekV3N6qjXnmOfxTOapt9HMTGPK3skVegHDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(76116006)(66476007)(66556008)(8676002)(66446008)(64756008)(36756003)(5660300002)(31696002)(86362001)(91956017)(4326008)(38070700005)(71200400001)(558084003)(2906002)(83380400001)(186003)(110136005)(6512007)(38100700002)(122000001)(508600001)(2616005)(316002)(54906003)(8936002)(66946007)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3dhOUJzTmlKaTFxbGV3ZVJLRFdBT1NWT3hDQ0NwSnY0ZWp3SnljdHY3dEt3?=
 =?utf-8?B?VlY1WGIwcXdzQzcyY3NwekVsdmF3amFTS3RGeHRjTTdhWEhXSGdtY3E2ek8y?=
 =?utf-8?B?dEtMMU01RUpjR1Z6QUNRSzRvVmthdUhCUndra1dyRE02Q1RkdHRBdXpCSEtt?=
 =?utf-8?B?L0E0NVNvNGpHdEE4UGlJdHQvNlhjRkYycm50R3Z2aXpDclZyRHMwVW5OUUhw?=
 =?utf-8?B?RFpYb093ZDByZUcvWmtWUHd6SDZ4ZmFwMjFMS1NhZ0xvL2dHRE45V1R1dVl5?=
 =?utf-8?B?anowcVBNTXZJampJM3RIZEcvc3ZTZ3Z5emM3ajVBWTJBZjUvZEdhWE5BNHFM?=
 =?utf-8?B?aElKL09oK1hLb0M4c2I5dXYwNWZEbHlpZ2hXb2s2YU13cUpFWHpOOStSbUpv?=
 =?utf-8?B?VWR1NnJ5Vml4cHI4Z2tmN2xqL2Z1b1lSMlUyMzRkUUtDSVBKcDQ4RHhJYzVi?=
 =?utf-8?B?NjdRalFtYUNWNDZMdlZQNHZUQ2JuZlNUbW01bzZDQkVMTTRZWTVtZDRMSkJl?=
 =?utf-8?B?VXBLU0lENGlwckhPVXYrTitPTnZqTVljV0ZQVzBXcWdlc1VmYnhrc1dMRmJV?=
 =?utf-8?B?ek5IZ3o5aHVaMEtvdTBjYU5RV3FzNE9NM3c1ejJBRFFJaHdxbDNDdExLTy9G?=
 =?utf-8?B?bXNwekJoMFk0bDcxWWJiVVdmcjlGbDhubnUxOStpdWtiWnZSSlBkbFJFVnBj?=
 =?utf-8?B?dHBTNlFlYVlTQWNsSGJabm1LRC80VWZKNnUrSmtnRVJaVEw4N0wyWmo3bUpm?=
 =?utf-8?B?d3pvWWtDa0VZM1UzQ0I2WHV4YTF2VW1rUXJuazBHSjdwRlJxam5PdkFCNzhm?=
 =?utf-8?B?OE9HaFB0SENTUVhhYnJ3cTJ4UkZ4UWdSRm82aG9SMEZsZEU2ZDQyczdYa0Z5?=
 =?utf-8?B?TG1EckZpaVdYRkhuQ0IvYmE4SExjWGgwUXBvS0Z5NGt6MDlqeVkwWU96d1Jj?=
 =?utf-8?B?N0p3TGkxTkhFUUZKRHAxVWlPakVWQ0dOR0ZpNWJMR3VMMkdUaVZTRmFGTTZQ?=
 =?utf-8?B?VGw1TjJrR1BRQXRmeGp5MjVWd2tESVBNcDBZNnc3S2tkK3BRcmovZm44TjVQ?=
 =?utf-8?B?TGxKV0xYSlRuWEtuWjlyNTdtQkp3NXprTHpabmFzZUVwUEdSbFhxYmR1SHM5?=
 =?utf-8?B?NXRWWFhLZG9ySExiSHJaQnBaVFFXcytXN2o2R29hOERmcUR2QStHUFpFVjdt?=
 =?utf-8?B?UFUwNDFmU0dLRjJxeHEydGRYdUdBSzlMY1lxOXBYZXFVaStaTXY0RjJFbXZE?=
 =?utf-8?B?WWgrZzhwa2hIcWJQeUF5OXVWakc2dXhUM1BUNHNpaGdsOSsrelh3MkthTXhu?=
 =?utf-8?B?ZWhzVTc3SjNpQ1FjK2pMMWt0R3JhYkNQcnRPQmFHY1dXa2thMUc3K1V4UnV5?=
 =?utf-8?B?T2xzdnNIcU9wTUFQdE1HY0pZaEV2MWpjUVcvK1NOMGZzZmdvTnlYdE05MWor?=
 =?utf-8?B?VHJjZitQdjdzSjdwRGdxNEIvbGhYb29vQ3ZuYWtDSnFKS29oQU11UXlkNVBF?=
 =?utf-8?B?SGtvYmhMYjZRc0xrWVo2S3RReTNvOUJFYWpQbjVQTmZMUU1SODhiYkVwOWVn?=
 =?utf-8?B?TWhpS3NHQnVtWm8rekRsNnZTYmo3ejBYVnplYkh5cUJRNURzTkpjV0Fhcmtj?=
 =?utf-8?B?a0tIMDBwRnRKSkRvZW1OUXhoZ2ZZa2xCRnVRVEl4SHVZR2orOEEyYjM5VWJN?=
 =?utf-8?B?WnpUc2dIVUlqbDdJb3ZuWWFlT005T1BrWnlhVHUwYmI3NlFCVlNpbHI1SHRS?=
 =?utf-8?B?RzBZcWs4eDU4cGVFOENOZkMzSU9aMHF3ZUFqODNzM2llMFNBdWlOVCtla1F1?=
 =?utf-8?B?Q1YySE5OS2U5VS9NeVRiUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <45346346433BA54EB73203AE2DFB8496@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59de3a72-c220-4807-ac04-08d982c609e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 21:22:12.9970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1Zdb6RBU4/xC6muwTSz5QGO7AkPo8zMbUUKHVUzmNOrD55hUlrW8xIxog/h6zvMnz+ETi7qdyzd837y0x2PhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8yNy8yMSAxMDoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEp1c3QgdXNl
IHRoZSBkaXNrIGF0dGFjaGVkIHRvIHRoZSByZXF1ZXN0X3F1ZXVlIGluc3RlYWQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCg0KTG9va3MgZ29v
ZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoN
Cg==
