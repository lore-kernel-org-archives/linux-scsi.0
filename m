Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A95EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4590F61002
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbhJ0AAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:00:34 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:53729
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237473AbhJ0AAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:00:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIofubBE4WjzjZNOaz/Db8yRATQbXB9KWXyG/q43RqBm1pCnY2bzVuwafxGzvCHU91RzWWUCGzVb4jeBRV3m45n/c1vtoTXs5NRfbIroRZ9LFCkPO3Zw1Z6wHUvIzgOXUt+XHMy8hHzBbx9vGfZ3w4Oc6RRyIcUFCaoZGcGBmuprAHyGbsYJDL2vSqADb3td+FGEmMLDNrCqHamAUXTC9BJ4GVvU9oMFs18//Bq8x4SXscrCVg6pISfvMBo1qagKcPPDZl+y9AA620Fs+k6Im65tBGV+2viSK/GwLWR2+1tkL4qzCIwbJRsVkTFJY9K+teFSEPPz80gQ3sCY2zu2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipY28YzBOGJEzzGhcvAZA1tXWNc3Eq4gTH4arIfOQQk=;
 b=WI7DQDAmYiLRCtJpnTVEEK1/hnfy5zT93xvzr309+hXth/f0loSxBWI4WgR1UKsX75wpq6mB4qczGLI6cP8Jwoc3kqyx57qN7/shuHHLZjmD8BmogCpGuH4HV6F6zrxyNLnHxYJxi2XrlohUSUYmOWW438mkDzHrGhSeSVUOJwW2SAd1q8knooUFgyhyJBBb9gaeAODZylm6zjyvicREMRyZbG9P0ck7rP1v+qhwwQdOPYQe0SNFOu2W3nxqj5BIZYtMFUsodV/LOcViws6IMlWvlqBZK6I2Igk8tf2R7MDIfEKlr9U2to3WEJcHEw4bdAgf9XGBlaEaBl5VsvNfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipY28YzBOGJEzzGhcvAZA1tXWNc3Eq4gTH4arIfOQQk=;
 b=WLyrh8R9OsAPBMo9Eeo7gyHaYIhO1E8VhO+lJCSVrBYpoyakQNAtZzk2yh4PP3OkqyAqsMCz2yGmE+OJsDFIviMN55mcApb5wVTrKdgpUKieBc0fEKjfkZu1MarDlAliScmfaloJLNv+fqwz93/mK1UCnQKioAymoksnk9fxIFP7ZWAgDxRfPPuIkqexa5eO7YQNwWUDTlge9Hz1PMa8eGbHFPHCztY5gpfL+Qtqu9F9wWBt9XupFX7zOCspbT2HO2vMyI4LcdRmm0VqQzOkA0QzLdsVaGEtiHWymfzcDglVQ985KCGh+LyxFlgKXDCYbiZq9B7liTEr4waBeC2IgQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW2PR12MB2572.namprd12.prod.outlook.com (2603:10b6:907:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 23:58:07 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 23:58:07 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 04/12] block: remove blk-exec.c
Thread-Topic: [PATCH 04/12] block: remove blk-exec.c
Thread-Index: AQHXyW66YqHi7Rrj6EWJ8v8dOOl46Kvl98eA
Date:   Tue, 26 Oct 2021 23:58:07 +0000
Message-ID: <06aa0694-fa50-b82e-7b4f-f6429f902451@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-5-hch@lst.de>
In-Reply-To: <20211025070517.1548584-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 739f8bd4-737e-4ffe-61cc-08d998dc7541
x-ms-traffictypediagnostic: MW2PR12MB2572:
x-microsoft-antispam-prvs: <MW2PR12MB2572EBA5AADCEF7847690F48A3849@MW2PR12MB2572.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3hqmttuqt2D14LA25Dj6kICm0RJee8EjBz+UEAU+j+NohucleS/8ALZ4a7CnvGSTuqiqVQOuCEAlgju4skaryeyljnydLl5vKPQwpOnHmv22lIalpWSioa23IEwjm3ZpACfo3HdEso6g7N5eiKL70TpQgQnpJaQk8MjDNKXHzRoCDkIQJIKqsjvx+ZubtnPFbdhWlSjps1CE8RXzu/XD5N/1et6EEft4Za/xb/Ac6EsxZLIivO7oaJvsVTz3cnKaVTygI/PwWo2wnS0e61QyNy3Q4vQIjk/Ip53z3tPsG9SY97rn1M7oo6QXffClgsiAeqycUJjKpWnLiMc8sbWJTt+r2DYG/ztPeBMbWz0AGb3fKmpke3mF25L3L27ZweJGwV/xBCYpVfvP420pBFqxSTNF4U14xNjnaTOCtitRmDs0jOE4LzB1bta2bnhkibQ+jYraH1kbLmfSTRyzGNDMwQOQaz4z5Nq5G80zr7htiVzlaXPLXgn+eZao5ocbzS+9rrl/G8Xt9fX2xbA2MQyVRN9D2s9i5Gu52Ex9c5FtxnApY1WHpM5MGE4REWzZgTjBoMeiJlpSgUXR7vGcryAbcVzKeXKGcJl3l7nrBw6BBXMqKvwaHf3jgbZgJt1RohufyiO25gMTVuNN3sOJheM9/5jOiRbeRHDQmlGXGDyyvyAMnXrKOCH+u1Zc4f//N71MVUD4zYIwWRVZUWGui2dM2qxtPY1aHf9kL05x+nkbpsnsHAsmixxHHL5L1KV9bE05DKkK9A56vasJyGcE3Cjjig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(5660300002)(8676002)(316002)(6506007)(53546011)(31696002)(8936002)(6486002)(76116006)(4326008)(54906003)(66946007)(64756008)(66446008)(110136005)(6512007)(558084003)(36756003)(38070700005)(71200400001)(66476007)(86362001)(122000001)(2616005)(66556008)(508600001)(38100700002)(31686004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cERDeSs0U051MytCS3dETjAraDI4SlJRbjdYN0UyVVhBQ1pQaVdJNlBacmt5?=
 =?utf-8?B?VnJta01XaU1uUUprMk5kc2JzdWpvVFdubVFQdk9aWTRDWUY2NU9iVE90a1Y4?=
 =?utf-8?B?WnlJaThJMTZaRlI4T1ZGUHVKLzdEak1YUmxqS0N1VE1Xcm5hSi9KSDZpWnhW?=
 =?utf-8?B?bUt1VlBrcWdtVHV5VGhLcEUwM1dENGk2TE1ybUttS2lTUmdhSzFYbUlXOWJX?=
 =?utf-8?B?TlFmcjVSSElPUm0va2NXdXBGT0JYbkZUZjA1R1hCdlV5b0ZENmM3Tjd2TkNx?=
 =?utf-8?B?MWdWTHptRXlmOHhKcnFlbDBnZEphVzJUR0pFV1lOY0tkQlIxV0dtTG1DVG5X?=
 =?utf-8?B?M3pudlBvQTJFdkpVK2s5N0ljN0c0aS9xUGJUVTQwVlgvcVFlb2pIM1R0bjNl?=
 =?utf-8?B?WUllUlhleFE2K1A2ZFQ4dEtnWVdkUE02Y0pncSs0NnlRZ2Vkc3BKSHFNMDlr?=
 =?utf-8?B?VCtkRDFmMVFRNlhqeG50dmRGdWhRNXcyVmZiN2Q3SUp2MmpxMUhMTnpVekRH?=
 =?utf-8?B?OTQ5ZitjS29ZaERueDBwUFFxREJocEhKcDFmc1BVMUZaVEdJTFBzQks3WWgx?=
 =?utf-8?B?bUM0akxPUEZReENmRjBJcjZOMVhOQmJXRUkzZ0duNGlQQUFxMCtCaVYvRXVP?=
 =?utf-8?B?T2RJeXJKMmVlR2RwTTVxSXRvd2t6V3NRUVlLWWtlUTZsRGJOdEdhY3hESFZk?=
 =?utf-8?B?WkJzdVVsMUVnZUUzUldxYkFkK3hzT1FwWlBYdzdnZDl3WnhXd1Azb2VPc0JC?=
 =?utf-8?B?T041SFA1NWNZY0p1Qy92alpSbXVwZElYRUpEbE1pK2ZwNytZc0Y2Y3o0TFZK?=
 =?utf-8?B?bVViU2MwMmJvOXI5MEk1ODlRdDFSSVpnY08yYVJHbnZ3NWMvbUZFQitzUmtC?=
 =?utf-8?B?SXR3a1FteW5SSEcrZG8zR09sL0xGWHdSK0ZsUXZkdmRWZUE2T0N0TWNoTCtX?=
 =?utf-8?B?K3RYZWQvZnJ5b0J5aGxtSjlZV0JNSm8ybHE5ejEwSEsvZUtYK2owQWlnRXhs?=
 =?utf-8?B?OEwrQXhQaUJrSGZuaDNmVEYyQm1WSnRNcGxneTdJMzNyN0xhNnhKbmozYkM0?=
 =?utf-8?B?ZSszWTdnaFR3K3FnUzh1eXpjejlOV2RjN0tDbVZHZzhuRldReThqeEU5S0Vo?=
 =?utf-8?B?eUFBSStXNVJ6NkFER3hXdjRFYzJ3SmhVZzM2M1hZL1p5YmVnK2FlNUVYQTkr?=
 =?utf-8?B?NVZjMllWaU5ZcnN5dHVITnFYUjFIVTZZazNCdzE2MkJaVTJ4UVUwNmNtRFVH?=
 =?utf-8?B?L0V4azBOVXFTY0E1OWNzTEY4dzFaU0xnNlRpQ1RlNVR5UDlYNUxRcHd4S2Rt?=
 =?utf-8?B?UGlUaWphS0VTczFwZUNMTlBySVVwK0tXdTh6VXliblUyQnFJbVpJbnl1QkFK?=
 =?utf-8?B?aVNoTjF3MlBMY1NNTXV2LytkZXRPdlRoam10TnNUU2pMSkdsaE8rSUQyN0tx?=
 =?utf-8?B?YjRuWVhwNFhVWkw0ajFQb2ZUalZqRlhQSFliU0x5S2Nrc3pmbFFvcU5iQ3pm?=
 =?utf-8?B?cEV3bjRnTU5UbUFuSUlkMDZoWGFFeGFkSDNUNFIyTTc1S2R3SFgwZHRXcHJR?=
 =?utf-8?B?c1VGQkRPRTdyRXQzakx0WlJ6a2YxZmFOVW45VWl4Mi9wb3JyOWpZdzE0K0Rl?=
 =?utf-8?B?WVB3dUNvZHVrTDU1dExaTFphTEJDN0l6V2wrVE1uOHVxcWRUY1luNE5nZGI1?=
 =?utf-8?B?YjhocHQ2dTVRVDRmUWpYaXdRanRsSWFCZjhWQzVXMzlwNkRkcStYUUd3b3Iv?=
 =?utf-8?B?V1g3am95b2RDSlFLWVcvR2RQWTAvNG95WFQvUHkrWm9XV2dDSER0Vm9aRTVV?=
 =?utf-8?B?OTBiSWFLNm9UUXJMOGZ5YjB4OS92NVhBKzFzZ1VLMDA5Njh2L28rQUQyMjV2?=
 =?utf-8?B?UDZLREJIeUtsa1gwU1ZHNi85SGVwb1BPQis1RWFZTGExQlFLRnJkaDFTL0ZM?=
 =?utf-8?B?SUNBQktUVmVHRHJpU0pVdzRCbGZRMUJlbHNBanU1SjVEcmNad1dGV0h0QlMx?=
 =?utf-8?B?VDJnQ3R1b21wNTd5aTlrd3d1VmlzUUtQTWJ1TStwazU0RE1nZUQ3NGh3TDRS?=
 =?utf-8?B?c2kxMzZjcHFiV05pbEQ2V2RQZkhHejRrMExVZThwWENobkExSXpoQnkyem53?=
 =?utf-8?B?NGtnQWRTaXBpM29GaG9yOGdSdktoNjNOSlRqK05MdXYyUVMrd2F5UFV1ZkVq?=
 =?utf-8?Q?G3w9AVWRpIWsmjmBZfYNL8Jf+V7oV+r9+q8WzfFBAI7V?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6910B64D2B77640807801F102801DB7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739f8bd4-737e-4ffe-61cc-08d998dc7541
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 23:58:07.6102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEDripvxwiZ3XM0JrlmZcpMc+U7WDlpOojX/QI/aCYDqXNH9uQ+ULxVOmdR7Cg6vPn+0+ZXTneC3SGkt65u/9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2572
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBBbGwgdGhp
cyBjb2RlIGlzIHRpZ2h0bHkgY291cGxlZCB0byB0aGUgYmxrLW1xIGNvcmUsIHNvIG1vdmUgaXQN
Cj4gdGhlcmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxz
dC5kZT4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8
a2NoQG52aWRpYS5jb20+DQoNCg0KDQo=
