Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BCFC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbjDRUUs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDRUUq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:20:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0660393E2;
        Tue, 18 Apr 2023 13:20:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJrPenQxQq9OnCuJqEz5wy+TZ38fvFVyogI9pnbsuA4rGnrQ7oGt3FwGVAj+nCR5iDR96CztGF0uK2T0te9Z6g1fmR8PaZcYaJplwaY92mmGgVOxAqXdLWvFrAiWQoQlSGGDuEXzTTFsKeTqsBY4f8/76i2CnjEVOfJ+LZxwjQ9MBx+nKOUPtHq6CEzpVwjdyUqzU4dw42X7UqArgcUTOb6WeQK1BuFF2v36FphKWuhg65/oHeXk2Z7qMx7JCt7R4we7FhYZ+dY0k4kRgD7PNuGXccPjSVh1Wym2OVIzBHk98PjHu8AWcjlfR1kFHss3yeBPybhI2NC0BunuxM1LOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFPwSiDpJgIqcfsXTy/42bGXAB0aSHfepdXG4MP7zGk=;
 b=dEadORMvz+X6Y1F3qi1aUBLtDBmq0nhjJdhwQJvlyI6SAsDsY2uSQoZGsGNcybWt/UktqDQ64TjdYqZOgVfaF5QhL5QU+ZVAw8H14QHnOaX3QJKdoko/O1XLJxh2mTnLHxiPHwl6f4PrCHDaaJMRB9YqcophBjqGKh6LVzDYhXzuEFuVX30gs0GgeMJ5/XgX5pHEfyTtnmsltXtUJtOLVQL5RY0HXjuwLpl648rLfN/uFXlRd3pHHU5kjhGNk/03zcVj1b9XgpfmIlH5V7wUchEGoe7KsPxmz9P4SVDGbwYZ32843LmDzpzsC1a+nR7eLV3J5SSIc7ofDe3EIXAxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFPwSiDpJgIqcfsXTy/42bGXAB0aSHfepdXG4MP7zGk=;
 b=rt7x6QvgDgzvhEUtZ7YU1VFpQ5WTebr3aCYFdTTGP0FPnnob5xZjD7WD7HgnUHy+/UA5BO14X4wLcbQaAJU33g0D160P9BpZubDzrzegdsNJFDeZoQLqDvbgfQE6CMa3qINzkJDo6aCIA9+rzNDyKfw32qdCIcs+CM3FsRnfd5Y6JXNdz7E6yuJKuXtCVJAIgFPhBNfKUeFE23i0VP3o22ziPC/nLcyXRw3tJnEdOgofwPDb5Z+/eK7xcPgtdOd3FX/VsxYqdtxIf521wnKsWZZze+dtLMsF82O3l6Cy5FIuhorvnIKXyGGAdVKT3DOYMRf9QLgdX5b/K5FXAPSE3A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 20:20:44 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:20:44 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 8/9] block/002: allow to run with built-in
 scsi_debug
Thread-Topic: [PATCH blktests 8/9] block/002: allow to run with built-in
 scsi_debug
Thread-Index: AQHZcS5TMBrBr52fwUyJ5P0yJHAFnq8xhCOA
Date:   Tue, 18 Apr 2023 20:20:44 +0000
Message-ID: <f3e021c2-a0c0-dc31-ca09-62d54361c6fc@nvidia.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
 <20230417125913.458726-4-shinichiro@fastmail.com>
In-Reply-To: <20230417125913.458726-4-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB8862:EE_
x-ms-office365-filtering-correlation-id: 74656bd9-41a7-4032-8ba9-08db404a634a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYJtCo/hMVCPar7+183J2hVv3cwjGkkmX5fowDy63Wsxrs/zZeq99HETZFid/4I6y1S4E1F3vfS7+bAw0SvoQjkQOZ9gRcV7d3w11NMe0P4/qz99qwIQNBzCnQFirpNUOfRLIS4YtyJuDBTlZBLe3ZJyFN2QY0oIBuXh6opYngWssTq9qTeu+GbZVt5LrNs9Fxg5s3oWe51WrzaevKQZADPkrqaD2k9/uQslNhmxLU9sEiYNNHzpLRr9jhAz+SVwp6bZrhEtMlAfouIZdjWsA8+I6QOmN2wpXm99Zd5c2Uu1XEy8BeAPkHd0SSIzOUZJ/undx2seRxne29KFLz1glyxzDFDPj3ZZPJD+NuqqLLZd1LdnN7tLsmwVCIKKYV5vhhvD4BT6YvXcCWTJgkxZIn6oNE7R8/EIpFhNUz+mn6UIv1tKEQp7Dve0eHXiH6o8g9sWj5GPB2WViL5wLciZIjofFXwF0Rrb9dtBA5AEyO/aDrFih+5+YZP1hRZnmh6VVdZamQE8uFeN+MrS4Iz81uI3T8ClrIYTSx4znxAflHg1SoX88XBto68KXDLlhQPGi+cBkrqyYEwarEKJLsLeUe9xy/sSczOoptgBi42myFjvlU+9ZVJ8+jZbAO5PT++gEmLsDQY+i2Ke3h8LtdTrbwRj6xZbsFVJlp9KRL4Xlo8RJaQMo9mzjc3zwMCJDzk9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6506007)(86362001)(64756008)(6512007)(53546011)(38070700005)(36756003)(31696002)(186003)(2906002)(4744005)(2616005)(5660300002)(31686004)(6486002)(38100700002)(71200400001)(8676002)(8936002)(66476007)(478600001)(110136005)(122000001)(41300700001)(316002)(66446008)(66556008)(66946007)(76116006)(4326008)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlVROTVuZTJYNjJwSGxjUEIxcVAwUkNzTTlSaWlLODZRZ0x2NDQvNThjMU9j?=
 =?utf-8?B?T1JMNEVGY1BSbmhEa00xSkVPblNoeHBwbkM3SjBaT1F3SjE3OXFFencxMGxC?=
 =?utf-8?B?ZzJGVjBJVFYwL3hINUlkeEQwdXFFZFprQWhKOXMwZE1zQ2FNZGtDaGhHSzNO?=
 =?utf-8?B?MXRvcmFaYkhpajFqYW1vWVorSm1nQmJMd3QvT3BzU2xVRkxZWGFlVXdubDJq?=
 =?utf-8?B?bG9va2QyQUkxMmFDSFhncW5ENk1HeWEzdk1xb0ZRMXR5NWtpMjdnclp0eXRr?=
 =?utf-8?B?bGw4aUY5M25WSVlaWjUzNWpORzl1RGE5dHRselpBTW1OTThkN1RQQjViaHlk?=
 =?utf-8?B?aERDanRiQUFmMWdNSjYrMnMwZ0NTTDZPdEQ2bmF1bGdnNURRSkRRNWNNelZ1?=
 =?utf-8?B?b3QvVUxIMFVCdW8wQ053OGxyLy9NTjd3ZVFibW1HaEg4akpabFpVc1ZWWEpU?=
 =?utf-8?B?OXByazg2OU5MVldDUjlkMEZhMVBVTkFIbW9BYi94VWY1UmJ4WU1leGJlZ0ZI?=
 =?utf-8?B?a3AvSDMxQjZsMmV2VHdkNHVwdWZrakk3R1dWQUFORjlHV1MrbUtZNEJhYlpJ?=
 =?utf-8?B?dG9xcm81dTZVYmdLSjYzcGxVYVZqTWlyMTZYT0IwZS9KM0lGZTUyVFR5Ui9I?=
 =?utf-8?B?aXdXQzAyMmVKa05Bb1lmMm1iMDlaN2FBT2FlOWdGK3lFM296d1N6S1RpS1Nx?=
 =?utf-8?B?T1p4Ym9jR0FwYlRrbzV4R0REQXdNQUpPMGtIb0V1ZytaaHFGT1k4bDNMMHdJ?=
 =?utf-8?B?VE5QTTF1SUQ2UjFpSmtXRXdDaDQ0ZENOU1lRNExGak5IcE9NeGx6eU0yWDlh?=
 =?utf-8?B?VThhQWJGTndWR2dBb0crTk9EajRQNUxWNTF6Q3d2TEY3WEhXWndMQ2FwMzNB?=
 =?utf-8?B?V05kUXlJSUtEMzFnQ0RTV0JVWitpTWZVQU8rc2o1OW8xZC82bWFVclZmR0FT?=
 =?utf-8?B?S05qdW5vS2pEbmM1Wk9kY3ZHNEpZNkZURUVicWpSUDgyM1FhT1dzTzhkelNK?=
 =?utf-8?B?Ly94SjFJR2FRdlhqWDR5ZW5vK29XSFNiVytqOW1TRTB4M0pGUGNUSGFGb2wv?=
 =?utf-8?B?NU0yMk9yRXY2bVVrbDZ5QmQ5T0VkMEYxZDdDaHdINWFHQUlwSm9Pejdhd2JB?=
 =?utf-8?B?UEIrUm5qSG5IWGNmMW5IV0dOQzR3TGkrTVFkT2VYM0l0NFI2aU4wT291SzN0?=
 =?utf-8?B?aU16QysrWHIxSXVteVhMS3RWMkFQM1NSYnpmNnFydGV2ZC96VkxmaFdjbklI?=
 =?utf-8?B?enNkOGtsWFlqUEtDK0FINkVIMnRkaFpIKzRVYTBvRGtMTkRndEdsaExSeitZ?=
 =?utf-8?B?WlBXS3MvMWlyT3ZMRmZxbzZrV2lPTHBWeVVzcnhWdDFCcDVhRUpOVmlwb1Zk?=
 =?utf-8?B?UXFXemJ6YUNNUmhLVmU4VmFWK2hNS25NVFFsc3kxcmM0UkcwVEROZVFZSzR3?=
 =?utf-8?B?UFMzRVdqL2hKSTN6a2pYQzRqbERyTTNGZnBOMExjb0w2NExSRDVTdGRlRjVL?=
 =?utf-8?B?YmROdTRVQ29SN3RMSGNkVHAzWUFkRm9YS3hEWjhnaVdQUUtlSDVJbFBzRlRK?=
 =?utf-8?B?djNaZTI3N0I3UXBLdE9pdy9JbnVmWHVkRTMwMnphODhWaVBCWlNJdXVNQ1d3?=
 =?utf-8?B?ZmRVaytLdWR0YTN0MnhNOTFSdkgvdW01cUJjTUdSZFJ2VkdJNHlVVU0vVlBu?=
 =?utf-8?B?QndQTm5PbHhGbGNlK3RzRVZscXBlYmNvUUVucjdsbXdaWElxT3lzUmhTSDhX?=
 =?utf-8?B?NUwvY0lOKzJueXovdkhXa25oYmRlNE9NK3JlZkIvbWhyU1FOZWhtVmE1ZXBZ?=
 =?utf-8?B?Vk9zNmFoRitDNDBsNVRwVG9iT2RUM2YvMGY1MmVyZWx6WXFDUm9jYU1HWDM3?=
 =?utf-8?B?ZWZkZ0FmWjJXdzNIM05WdlFLU1pvVTFRWUhuZk1nOXZ4aDQ5STdtb2RUdGRK?=
 =?utf-8?B?WXl4ZWJRNTFCSkJxLzhnMFVzZ2lLZWwyNGVwTFhUMzhwaVpGTmZsYWtXaTdV?=
 =?utf-8?B?bms4aWpoT3NtSnhpSmNPZVIxQ25tNXI1TXVwOU5MTERrNmI5SGNELzhWYmN1?=
 =?utf-8?B?b0Y3Q3JPYy9jb2M4TVhVYzlYTUt0R1REbTNZMHJpcGFMU0M1bHdpbXRtdGtv?=
 =?utf-8?B?c1k0UEpOQ0dVYXRNKzVFM2gvN0F4dUZZZFgyZE5WOEU3NEhhaWZUMEJzanp4?=
 =?utf-8?Q?lmp34eK1YySxbdoCrnGa3m8wgLwT7j7RycLx6BqEFe6Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <486F7F30BF34D1419046DF8F26F695CE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74656bd9-41a7-4032-8ba9-08db404a634a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:20:44.0249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JsavJ8Dj8PIIHKSeLESmQDpFJeEhCr4JhnK2vAcg2B5mdX6CkDsTNnROuwr3ebwkvV43LSCd24JWWn+QnkYt1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo1OSwgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFRv
IGFsbG93IHRoZSB0ZXN0IGNhc2UgcnVuIHdpdGggYnVpbGQtaW4gc2NzaV9kZWJ1ZywgcmVwbGFj
ZQ0KPiAnX2hhdmVfbW9kdWxlIHNjc2lfZGVidWcnIHdpdGggX2hhdmVfc2NzaV9kZWJ1ZywgYW5k
IHJlcGxhY2UNCj4gX2luaXRfc2NzaV9kZWJ1ZyB3aXRoIF9jb25maWd1cmVfc2NzaV9kZWJ1Zy4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3
YXNha2lAd2RjLmNvbT4NCj4gLS0tDQo+ICAgDQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
