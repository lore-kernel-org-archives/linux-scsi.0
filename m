Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E36C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B601A6103B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhJZX7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 19:59:21 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:7649
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233833AbhJZX7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 19:59:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBRlnPv/yeHgrmygHrQF6gw+yO2in5LR3UUfa2PvtT65yHe1ZDHWy06SDNLQJxpCnYVAFRxO8W9HPqcVdz/vZE0LC3ynmGNS65D35j2P91fQwYwMUQ5qqSHDEqOiTlYe96JTgGbUZaW7tfOX0qtDeHewUWL+MM5V8GnCeiKZb9pvfk4GujgmLbhm7wIQ31NJhAM/w1n2+9DPpDQA+zm/c6aH68qiXkecAdvEsMAqLLJY3VzwgRt1i7l1pB6hPpB+BAB7ys3lwNou333E4fuPdQKcGR2VAPBuP60D+fAb5SUEAq5/AoVRsrpmIu1dK9iQm7wx5bf5tBBXqooga6zcfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WZm3Q1kOoHDIhGoHA+7uPJOdJCAgnRevv126yLEDBs=;
 b=YkWRKsTo89b0CmIS4A50gmQPswf7izI4BKhFdx3RQpRP5SWzFo2w2ez/hfwni/HT2HLmv1TfUaH4XAcCzbwiG5TXdWAC5GKNPWWujGoU1r+RQJrhsfAlyEEOE7CgW/sMEyJ0oP6DxjbBTmOZpkJyvDerUtMjTmedgouFe+lb+wGZMYV0bGUGkkxa9HOVBD9nE01p1YiAl3MXyz5UPRyxzd5ZY7L6cEHgwqHJHGEeIQLU+8QqiqP8WStgFpK6LTonEazlDIM48mVWnIbUn+f4qgeucioQxmnFBMasHEVV8Hien5SC4K1su2SXZagkr9xUUHm/urnlqeg4yTxA1ijYBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WZm3Q1kOoHDIhGoHA+7uPJOdJCAgnRevv126yLEDBs=;
 b=PWUmafrOzSiiX+jEnnmKAXVXucdkbwpRhtcGy0A1sLOBxOQhOuLnAHjb6Y35dpRJ/yYs9DwrsbcthR47Yn96HGrfUZTFDvx3RlKCiz/1nbdscXIfMnoQccyorY9pt+jV5eYgpu0JUqAwWkcQU6p8+OmDzzE6QmH429TRXGBXb/F/v/1V699dpht8hEu5+Ut3SSmHso36IdZPxRd397blwEzW3D80w2TTJSjbXtrb+mXoh445piKFoiwT3DokCvj1vU1xCmgaD9gXlefZyhM99euIYu3e/7L5xtLcecqtQc1nSB7ClIaux292WKe1au1JrkKYEWMIxGSDc/qXi+zqIg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW2PR12MB2572.namprd12.prod.outlook.com (2603:10b6:907:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 23:56:53 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 23:56:53 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 02/12] block: remove blk_{get,put}_request
Thread-Topic: [PATCH 02/12] block: remove blk_{get,put}_request
Thread-Index: AQHXyW67lRu80ajfd0mN1bhV2VAZ3avl92+A
Date:   Tue, 26 Oct 2021 23:56:53 +0000
Message-ID: <04dd1425-7043-ca0a-479f-83b6afbdb813@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-3-hch@lst.de>
In-Reply-To: <20211025070517.1548584-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 183ff52f-a06a-43e6-89c5-08d998dc492c
x-ms-traffictypediagnostic: MW2PR12MB2572:
x-microsoft-antispam-prvs: <MW2PR12MB25722DD0EDDE19D6550118A2A3849@MW2PR12MB2572.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:130;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OiIloLH/adlXXGZ4cn8ZZ2soMuKsZMLErsUcxOtSodeop9QyeNmOMXsKMprJpQeeFU4gIyHVVpqj237BpvC0IdxbuJtgJIMgcjyAIeQSpWdTN30RLPV6Mps5Me4zze2OiUgLfcDH5nhLOeFwmNGNOnLjghIGBWrM5gYDeFYdLJ/EJ0s29Dtodj15DyD0NwOzu+GWC4EOj+Kb8pfHGz4+YjVYnsm1f9RDEL4rlx8d1WP6lSl5OYBKb1dkzPpG/NQXdkA24FgUa0/maPUQc8j5KZNmcCzJWAZm4CzGv0aWc9v5GAlxkcy8li1/W6sIVuOy3IEJQwwgSLlylrdzsctpkEJnasAk6EhryR1w/hrRiQETEWys6kVnwyOh0o1mPqbxcsmtYK2dKBvs5shURC5IYhl2FOPt4m0aVDUcbI9zMouTlfF2r3mvHqSifI07HLnX7lfjqz9XYaMUJK4s79kMrSku7t0vSts6+4biRYBK4cGp5q2A2/+kGgzgZfbRPHV7AkYLD6HxbK2VRUsPsRiYTPxsBRYkVwW/enJyo2qcSNQAK3EWazdOlSMesJ4O7yrGoS3i1r1yAx9g0x7hvaEyklt4FDKsAIR7fNg+lSVGeaBskbcYZv+XD6+9mBAax/EjMaTQ8SaNAXOEbivkcozQaDznXL/VXhZYEzyZA42Rt0M0Pvg6lNm+D3q9VN6wC6ox7e+1jWk4V7XastPvvQIjDqhUQwCGc9TcCiqbW3enK8kfRMy8mke7C6WKEspovc13y8fHW/sLhWLqzID5aucNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(5660300002)(8676002)(316002)(6506007)(53546011)(31696002)(8936002)(6486002)(76116006)(4326008)(54906003)(66946007)(64756008)(66446008)(110136005)(6512007)(558084003)(36756003)(38070700005)(71200400001)(66476007)(86362001)(122000001)(2616005)(66556008)(508600001)(38100700002)(31686004)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2ZmcVZyUWpOWFF3akZjVWVBcEt6K0RFcGtpRmliV1N6QjU2dnkzWWdWeFps?=
 =?utf-8?B?TEV0Q3dncURpTjlHS0lMaWhhSWxVMGlpeUNIcXd4c29XRUVpY1FxQmV6VzFj?=
 =?utf-8?B?enJQYWxuczY1a2k1Y0YzbDJMSnRIS1psOGpzOEFFQkdDQnRLbmV3TFVUQnBS?=
 =?utf-8?B?UVZOMlNoREVMQ2dndHlBZTNGVStrMDZTdU9keGR4RnM4N2xSalNJTVpneWF1?=
 =?utf-8?B?aWxUb0t3cFRGc1lRamRmdVl5TUhBWlRlbmwxandnTGN6emQ2a0Z4b1Fsb3hU?=
 =?utf-8?B?aGFHM2Nta1c5NE9lekxmeG1xVGlCRkZ3cHFyOFliZFgyNFlIK1k2NHZpQVIx?=
 =?utf-8?B?YldOZ3RFb3Babm50L0NJZ0UzODlkbnJXMTAzT21RQWJLeE03VFAvanRkWW83?=
 =?utf-8?B?bXgxa1RTWVp1REZCcjI1Q0lRbWlueEVFUzJnNmx3TlJKaGxtaDhEL3lsNllG?=
 =?utf-8?B?UVhFTGxsNUVwdnNNWU1XZ0FjVzhGNW1VRCtoajYwSDNsSFFsbXRzVHZtL0xS?=
 =?utf-8?B?dzZLZ0NsZEJUVTFSZ2hYQXp0MnZPWmppOHZkSW9LUVE5TkF2cFhTTGIwNkVR?=
 =?utf-8?B?VDgwR2xKZDVHMnUxTUlsUnM3WTYwcmdiSkEwNDlKMXZzOXNONjJuYVdjem00?=
 =?utf-8?B?MUJ4RGFEWmIyWmNEQkpRQlY3bHRsMllwTjFpSUZZN2NjUTBNTUljdC9jK1BB?=
 =?utf-8?B?WVU5ZWlzTXhXOHBycUNJWWtuV2N3SDVBdG01c1E1dnVKV0plOWdaNkx0YXk2?=
 =?utf-8?B?dXBaK0lOcFJwempuUFAzUE1oN2FacTZ3NzlQQzVsenZYQVJLR2hpY1lsc2xZ?=
 =?utf-8?B?cW1BVjFkcHRyYm1CbCs5UVV4b2FDaUpSU241V2ZvRGxGWUovckJIcktEREpm?=
 =?utf-8?B?TE8yVlErbGtwUVlRTTdFc1AvUDMrYlNTY2ViRUhoLzZocWVIUm93cVRQNkFK?=
 =?utf-8?B?eUp2NFFiTTVRRnFmL1JUdWVKS1dIcktMZ0Z2TnVSMks5Q2lORTl5cHd1amFO?=
 =?utf-8?B?Y0FjNkxvais3aG14SkovS1FqekdBckEvWXFUVi9mbGFEV0ttU1U4MWxyM2JO?=
 =?utf-8?B?WXJxMFNlY25xYms2ZlNTa2tlL0JXeFoyekZVdmhnTTd4OE1DRjAvNFFtZnRI?=
 =?utf-8?B?MU84VXRRRkFVMEhrRmEvZXFVRGw5bXhWRkNOdlErVThLTGJvZTJSTFVjQ2I0?=
 =?utf-8?B?a3pxMjZuUENHSllPMm50V090ZVNxdDNINFc3ZWh5ejhlWk1rbGExYTlJcU5S?=
 =?utf-8?B?YmZlWWpIRGFadlBVb2lMaWhQQ3NKb3FIUU1jRkJNS21RQThIcmdiTVpOQncz?=
 =?utf-8?B?YWRLL2JpZ1A1NzAybHVmUnlaclJtSGN2cS8yT0Y3OXlVQWkwOForeWtzd2N1?=
 =?utf-8?B?cnREVWFtK3NhRHprYmgrNk0xY3h3Z3YrTy9OUUJoaENjN29WbHFqTVdidDdS?=
 =?utf-8?B?a2N0cjd5TllXb1FUd3BRM1dwcjdjcFY1dVdNQ3RRYXByRXJET2FpbTA5a3Zr?=
 =?utf-8?B?NDdVUnpjZWoyZFZFMjh1aDMxQjFtZFk2R1dRY21xUmE5SytoUk5aMWNKajkx?=
 =?utf-8?B?MTFIYWRZTVJtclovb0NlUWR0K3liQlpaOXdHcFpUR3RjY2FtTVFaWCtXV29C?=
 =?utf-8?B?S0lVQk5meUJpTVo3VWlpM0RuVExxTXFrdWFKdWpTcG52ODk3dVJBczJjc2Fh?=
 =?utf-8?B?RXNwUU50YmIvamtRSm5ya2E4RVlDUk9STjdSSHhFWHM3b2ZsL0plamdYUnE2?=
 =?utf-8?B?RnRZZVQzMjhlVjM5WjYvVEE5WlM5TGR0Z3Zxd2FKRUpWajNLOWxXWlo3SGI5?=
 =?utf-8?B?YW14OVdYanBzTCt3MTQwYjFxbzVFZ0FkL3d3OXUxeVY3ZlMySDBFNXk3TEpH?=
 =?utf-8?B?OEUzdWNOcWZMT20xMThXRVIxazljT3hwMnV3eVpkenBDYVh1bFk5aG15K0lD?=
 =?utf-8?B?NFhIY3djWkV6S1pFc2JCUGV3SjBEY0t3dXl3NEl4YjZzUXhHOHg2cHdXWXJ3?=
 =?utf-8?B?NHA3bDZJUXRpTnBFaEpIeXNoQnM1NkVldTRQOFFOdDBwVjhleFIyS3dDQjNx?=
 =?utf-8?B?aEdabHRKSjgrNDFjVzIzZnltOHBFc0UzVWxhVklQcjYyQnVBd3NMQ0dpc2Z2?=
 =?utf-8?B?QzVBUE5VTXNsL3c3RjZUS1B6eG9DbU8wdXFjeXFxdmpHdUF6Ny9oMWFjMXZE?=
 =?utf-8?Q?+IxS+PQ/z11OTyGS1rpPcEJjkdbhmYB0n/9yYamPOKNV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7426C8B3B22AD74897FAB35B6CAAEA30@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183ff52f-a06a-43e6-89c5-08d998dc492c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 23:56:53.6798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GWo/En9QSymy839r16789BAmOVlCsl65kt7+kxfst1syjS7hA5/aVai7l2rhx7VAon5s3HTYA/B+VBOGU992WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2572
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGVzZSBh
cmUgbm93IHBvaW50bGVzcyB3cmFwcGVycyBhcm91bmQgYmxrX21xX3thbGxvYyxmcmVlfV9yZXF1
ZXN0LA0KPiBzbyByZW1vdmUgdGhlbS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRh
bnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0K
