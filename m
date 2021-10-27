Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0CFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7C260FD7
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhJ0AED (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:04:03 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:56929
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234796AbhJ0AED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:04:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afKFrTp9W3iGOelM//cMg4PWtTM8OlPiuYzSL4nuf4K4uTqA0w3iCx5NhqjYaXwIxTO/QLZrilyBmcyLB67NBKoufAL2oe0xOcAloCSpohMhlp+R4+853+nUPBkaY4OgIS+lC2bZKsRZvVcy6oDCyKieUkOl1UVi0B46P1W2Ho7qYBSNSWjcgzyjwwezVacGUeWWSUOQEo3Q+8VO/SvuCSVX/JBEuQeIt+P9tcCPQipI+0RzXAUVvzLBgQ+noG2A7gYYUAhpxt3wPvQmTXEA1eGAuBG8Yw4Da/hwBBmxDLxSn1dDBbE4r/TFuzaetnLn4G3PGZSDAQ/z4hHCR6y8XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWC+s1+lzXDfxrsuLnpDNle/kqPbdNAFb8MWEYi/LsM=;
 b=O/Y1KyYB+PXoGGHe6rb3JuFrfREbsuyRrrCahvUu3k7ylu1nIUFju/+7PKbWihMSC4LxKobEBaZkXjZo2HGaS7horcD//nSSScz+fQOmWVCGIPOwx1O/qHm/pChcbpE4YoyPRlhoS8iLPKrcvh5ffHyWTP5YweIVJ8erTLCARbF6L1KtyqdmpIzGSeGnKCD4F3c50xEadUPVRqfHP3KFCY2gPyiOlEcRyoVveqDDDFdUJglK8k53zHVpAz64aZVX3EqiPPNKkSWMZ2yUFYhaHf7Da586mXNALfvKpPK0LlQS6cdB9yPNYeuUwB5jgZWB5/D4/cyhN42W3harU4XhgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWC+s1+lzXDfxrsuLnpDNle/kqPbdNAFb8MWEYi/LsM=;
 b=abFdiQvgLXwepi9L2C/t+d2fR163Hr6VS4LuVryZ8If9m1btb1NchzoBXokal4ZTGyqtXGSTFND7zLP3II7xeAR4hMaDEEBxix5fSWLQNUEp9zy03XQGagpp1bYWHYK7slM93O5ztBC0vrAscYJ0tu8PeoSK52TjCY9FLzYKoK8txzg3Rj5GVgYMU/8e0hQ1pls78FkFZVC+eaKAg6NOmV5FTdhzmim/RjjdKGQNbzsvvrVPuCz+afqdG9ub/uNi2wx7KNJ9Dnf1if9OMWNcuZM1pOWYR/1TdBQkDvMzN2slIPweoNe1IlFhTpr7/zlL88ChtKq5gfEvt/AoOWKAbQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:01:34 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:01:34 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 06/12] block: move request based cloning helpers to
 blk-mq.c
Thread-Topic: [PATCH 06/12] block: move request based cloning helpers to
 blk-mq.c
Thread-Index: AQHXyW67kYHQRMDBD0GFzaNjSRGcFqvl+L4A
Date:   Wed, 27 Oct 2021 00:01:34 +0000
Message-ID: <7b98c0b8-e437-c1dd-ae09-91efce787c26@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-7-hch@lst.de>
In-Reply-To: <20211025070517.1548584-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61d208dc-f579-4d7c-6f95-08d998dcf08a
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB0016888541154E8549E3D9A3A3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:287;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sE06cGod0n5xoG1IM9nUlzc2PS9uo5lamS9/IUMPmCke9aLFByOrkyayQnD/8L55ZlpUNZkXKFjfzgcQutTHvCQsOI2hlySt1FnzRSlp+LtXTQD0rIriChzur4iHSoPWks7OlZvSpT9/9Ee96scEGebCvkqjn+WCmuOsmncQSiu4WNH6DhFExxyt0MvZLrkj0fHbcoUANGI5vbRiXKVrVygdexDqJQ3YDqM63ZdhRNstqdkw+xPnxxmbTZmnNPhnWSnD9TS72mJSLyJprjiXTek9xl0YNTh/F9QDYgPrBW/8N2nkenQ3nItuJz+BGaeNpHCkfc/qLqtqL2i3qxDZL1WMwRStYe9Rxh1SttVHmSgK5tFBVBkg8fN4EtpmXEsEITnzJExCywCC7TFprqhQZWPL/A+6wNfw+zl3RVT+tqCI3/8TPDwwYD2ksNFtSJ9o5RfjAreQuhFsP+Tyy2xrtpoUHD+DfsWvcQVPO/92nFtW5gs6OawzvLiier18ck5jhvRnnT2KY7K6pavNuIXsrzE5VxEN2uAvNYc6nbFzIh7TLQNnFyemtJCRsw4sWj41vM5Y+OXoyf5AjD1EA+HRXpPe411sD3QY/8OlboU9z/v1auBmClMZ+773ikhziIwgq0LVTnQ+5xa7YXWH92pIUmW+c/r06u2QTWOqE8EY59rRkqDQigFeBnCImZCnmLROsdBcmkhL9r8fEqJ+b0f28B0N1RLgaZsQKpSWHyMbo/qgdlrIde+hBhZrYlrnaM27lz3Lb+aFTvwn0nKaZKWwmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(71200400001)(66476007)(2906002)(5660300002)(38100700002)(122000001)(4326008)(316002)(186003)(8936002)(83380400001)(6512007)(38070700005)(110136005)(6486002)(36756003)(31696002)(66446008)(66556008)(508600001)(66946007)(53546011)(6506007)(76116006)(54906003)(2616005)(558084003)(86362001)(64756008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUNmSkIrUnY4ZU8vZDBNOXBHZ2dKMUpqSU9WTDJackZCRzRJUDY4Z21hZm9D?=
 =?utf-8?B?YnNVK08wczMrTUtpYU1XSGtqOUNUU3UyK1BONmZPclRENmRUUURWY1hIZWtV?=
 =?utf-8?B?QmVyeVlTRTExUWxocnBFZkZZTjdzamsxTzRVajNjbUs1N2FSVEdsdWsyTTBU?=
 =?utf-8?B?Y2IwQnpxOEwzMDNQcForY3VFanZYM00wcEp2MXJHcGU3eUZpYU10WVlJUE5Q?=
 =?utf-8?B?ck1mc2R5V0VCTHVKd21HWHhMdWZoUEJBU0dVL0J0S3hwS1ZVNkpvUklYSnV5?=
 =?utf-8?B?KzBBTjRVdG5XRjdqMkV6ZWJlaW9nN2YrTjNKWGtZcTBSd0hHckZQWlBibkNR?=
 =?utf-8?B?ZTJ2OXl6S3B5ekRiT2dqYms0WTNrNy9YTzh4ZC9EamhLZHk3dFFyK1BFNXpl?=
 =?utf-8?B?UlQrVGFBTFBiMEhsWkZCbHdrTEVEVDMwS1BSMXJhTEZ4bk13RDIzMDRheHFP?=
 =?utf-8?B?Mmx5QVVjVWw2MmcwaWhURTJyKzBzRjQrMGNsbCs3U3lCUkdWL1ZMdDlKWDZp?=
 =?utf-8?B?SjA2T1hQTk1hUi95cjlobFlOeUVlbnhGUmRodXkza3BTNWROS2ZDR2JraEJX?=
 =?utf-8?B?cTZkNVY4V2JiRElxZjcxRkZxckRkNkt0N2ZRTXJPSjh3bHIvU3JuQlZaemZQ?=
 =?utf-8?B?NXBFelRWZDl2MkdJS3BSMEludVpGV0VkM2U1YTZZQ2x3Vm5TK0w5TWxadEtw?=
 =?utf-8?B?NHRXd09Eb0p2TGJaYTc1a2hBQVRJVXlWV2RvZHRhNXZxd2oyaFlid0w0TGFE?=
 =?utf-8?B?Ympub3JyVHY3clZaOWpGNjVtWnZLQ0pZQTlkSHFLY1RMTGtCUHN0d2QzMm1h?=
 =?utf-8?B?ZDRLMkVtRHorc0dlMi9yZ25MLzBWN1FpN3ZWUWRmM3FUNUdXSUR3VnFSQlVV?=
 =?utf-8?B?aDgxVHBCeXZUT3BlVC94elhLdmFiUEI3WUg2SVFRRFFETWw1NTA1Q3d3eExW?=
 =?utf-8?B?NkxBc25YT2ZsUU9KR08yUWg5S2toZ3dEbGxLUWVmYngxSnd5dlpjdVorNnpQ?=
 =?utf-8?B?bVV6YzM2WlZFOHovN2ZGUVpZWXBhanhGTWdIbWdwekM1R09lZmFNcHBrdDBR?=
 =?utf-8?B?U0Q0UGZHak5SSTdCeHRYejA1d0l6SlZjSGtJVjBIWTYzT2RyeHhWVXBKeGkz?=
 =?utf-8?B?YTlsN2xoTXZUQlgwb3ZOTUMrZGJvbDZHMWhFcEx4aHZXVWxJbDltQWdaWkdj?=
 =?utf-8?B?QzA4bUVxZHkxdjNySnNsYnRpNmlHMUduZUhEZDRIaEZMTnZ6MXJqZjROUFNQ?=
 =?utf-8?B?MWFqSW95WE00ZGNqNzQ4SUdSSy9xVW10NkdHWXJKd2VsTEI1WWlObk9MZmNs?=
 =?utf-8?B?anM1bTJscHRhNUtQSFUwSkxCckpYb1pEenNhYWRibDJPanhOOFpZNjJOWkRh?=
 =?utf-8?B?Z2lVMElnVkg5bzF3N2V2aEZqVkVHRzNkckN6L2s4TEVhdkpJaXJkM2hYSm9P?=
 =?utf-8?B?eldZQmg1T0d0R3djeERlWGdHWTZVcEJ1T0p0M2dxL1RPSHRwVlR2dFVKRUlw?=
 =?utf-8?B?Ti90NXNsa1hvQkhPWU84VCtVNEh6ZmRQSmN0bUVoZWdVUFFhYzAvODEvR3lr?=
 =?utf-8?B?K00yK1gySGZwazFtcUppbWNEd0xDL2tkRk9lbnFRTExpQm0xMFhOdVNhWktM?=
 =?utf-8?B?T1UwNWhjeUxyeVVlMmNKWmdHYTNZMUR4dUlmTklBQkdTWWlRZWR3c0J5bTNW?=
 =?utf-8?B?Q3p3L05VNmxsTXZBa2tGb0w2bDFNV0NzRWJoT2RoMTl0ODEvUjlkVTJLV1hn?=
 =?utf-8?B?dWVjWUVGc3drdDZRa3dlS01UdXdmZG52KzlpODBzSTVSb2h5c3hWU3dpRTJz?=
 =?utf-8?B?eURqZStkcGl5ZHhNZlJQQVdoeW1BdnRTdm12eVVOcUZ2L0o2c2RXaDB0VUgy?=
 =?utf-8?B?aUhBT1l1WUxlWGh6cmkvSllLSWg5b2J4YktrSWE2bGxlY240dnQyU2IvUy9S?=
 =?utf-8?B?ZmZsczdwRVEveGtJT0hXNlA5U1VNbmpYSVhha1RUbWIzZGtGcitDK29ReUpx?=
 =?utf-8?B?VUlET3o0elliK0x6Tko2WlZrVEFHYVUrZU51czNibUIwY21aUjlFczllMm5h?=
 =?utf-8?B?aDZ3YTRoUndzaWhEVmNpamZxMDdzS1dSN3lLZXlWdWUyZ2N0N1JJUnBEZXcw?=
 =?utf-8?B?TXFaT0pwT2E4TU93LzBPc3JGRHdZZ0MwK09EeDlxV3dFMmRubHIwZEdJSW9j?=
 =?utf-8?Q?v8DoQTsnemNB87tlWKumLQ+k3C3YjJdEVix7r8oriqSX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D825C6E05E12B145957AB093596E9539@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d208dc-f579-4d7c-6f95-08d998dcf08a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:01:34.4247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sMe7vuT5fW8VLPewA8BdmR5z4nchG2NuWFR0cMl76pFq0j/ibsar2QCsolDvCrBzSxyZZynXsi3Y87jW08fFDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBLZWVwIGFs
bCB0aGUgcmVxdWVzdCBiYXNlZCBjb2RlIHRvZ2V0aGVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQo=
