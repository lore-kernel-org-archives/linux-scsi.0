Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0477CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F3260EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhJ0AJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:09:30 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:15521
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhJ0AJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:09:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPTO7QJlEpce4y3i0lN9DKCmpIU1dnf2LdYG0j0oR3Sl4mxihjRC4QQGzeYAWmaBwAqosZR/1bmxrpQYiqaQHWBp0cTq6zuNRssbrQLCJGqdvwJ0rQme/Q5KNs1L7VAZk5yWDtfwpLTCwM53PqLwZWorjpMdDaqzyU3hBV2xRUCS9we0iDg5MuAVWdqyw+l1PS1g72js0P+GU2BL8i7hAbWOTxHUqlLBL40f9y/8mCX3lug6ZThgqoOoD2zxCHT8I3O6a0sCUxZLn29ITdcgUI9Twpc5OvBJa0G8c6S+OQGEji0aLn4i5e72EoxA6wPUog6hiLkJAGqq/cN/bA+djQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8S7VmVAVZ8tGtPzKBCwwxaK7myiME0mx9dijCpuYWY=;
 b=QMiIOPKWPl192fdX81u5ku2g9Tiym/XKi4D0cl/L9JPAlrOiJexKdetUQ7Nof6HjO7r8rg8Kzf7xJ0sgpKLMHkD6ch08nOaPRSMc8UI23IIMp1KC1MGYZjd+NK7J4u99bYGh8HgeIHwNUrMDruNMoHh+ty4yKWnH+zUaf5IaflbjDMatwHPgllzRudtAXvWxlneECFgfoRGY61gvrKlHMHdbnEVgwnYda7zdcQb5dX85QJMXfF/8tR4wSa3aj75xeg37q5nqDyq1pBDMKt0NdLtNEWKodTTH0tduLJwpJgiN8yf66pofkPVYXBxEz0h2/IQuHu9vF7ficL3MTzHR4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8S7VmVAVZ8tGtPzKBCwwxaK7myiME0mx9dijCpuYWY=;
 b=UwIbL5z/2OV7CXNcTnleMtl8AYiOA+lm8ZRNSw3WxnXs4LEBy7/bqzLQNRemjgRjphdd222JkKlCAZmZNBsRcxoytaks3qVxwSgfQ0pDCth/ZlLmWDkrLMfXI6N13V/tYQTeZT2MrWPMBNsVtJSUtMWfghPO94CgS/Mx0g7p/TM/S9kFQfoRsNnzJs9mMM/E5HwQBnujrEKYW6g7Uq8nXdZ62wYKGvCEixXPpvzHr9BaOcskI1c3lWvRgTZt9+Iu+Prkf8qpfnm2Ea7FJ55Zc+YD4UOwiJLVx8JGjqviGt+TnacdEFhzlMTPPYku6+4XLgdr5Zdwb0/7ZHBw4J0JAw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:07:03 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:07:03 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 12/12] block: don't include blk-mq headers in blk-core.c
Thread-Topic: [PATCH 12/12] block: don't include blk-mq headers in blk-core.c
Thread-Index: AQHXyW7GmBl15+ndJ0SDYRRv4B1Y36vl+kQA
Date:   Wed, 27 Oct 2021 00:07:03 +0000
Message-ID: <31b6e649-0970-1762-4ba5-7c7bb2c903e5@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-13-hch@lst.de>
In-Reply-To: <20211025070517.1548584-13-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27496363-1081-4bca-f289-08d998ddb45f
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB00164E0B087ECBADEAADB9F4A3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XGVp8zssofqHZvA8UKl5aL5GQIq5RubghR1rNhy2MFzugUNITyc7jMTi5yqAMJbdKp2BbsAn+uhDtdvF55YfnCGLW++mXvjbYtHkww1yOPP0QHKh/V78bKA3JQmeHCQS6w5oEkwUaqS5MiY1APK32LWCpmyr0vzmP43OeM0/UrSDxEB1IAakuCE9Fjsuuac3wGMLaSzLfVMYFukSxATwD02B8/zChQE8Qx+g2yzTvS/sQ3ZgjxtK+wyLVfayoB5AZcJnHK70iBeiypzJXa3CD1U5FWNVWUyP0N1d1y5OthSXPmuu6gm17psYM9ni3euDR+lmAUWAhz32UitXIk6zAYwmukdErkKfD0nTE3iLHXAXwvmz3d97H3UvVzYfjk8/3UYzLzwWZeNBCiO0/BT5GT3cDWJWnfd7KVl7fJS4gbVNnJvSen3VEU/lC+wzgyozphXkeyLRiXsMRSGT2qz0gpy0I0Dycxm0y418QZAu2ODzaYPoqmiWYOvayW0hrGnhDO0fSfmLZ33vJIUDqocPzGeEkuWoxQlfvvS6A03o+BMWmez28XDBdehBkkex9Qmp5hEIwth5h4VK4oY+FIjavhI3B7CExtxyBEGj+GFIdtoznMm5lzwqqBWuQwxWwVav6oW/k61BdZs0k5G9t7ZOk2lBfWLYA/AuIAOfJYif9c2q/1ck+94985vRXzIV6t6Wjoyp8PCRquRlcVgXTPy+Qs9LQA5b0RttFBfnCkY/g8ASigJGIrzrccAOm2Sa7PvPXrHgo64m0OHy0fI6xtuqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(31696002)(66946007)(66556008)(508600001)(8936002)(83380400001)(6512007)(110136005)(6486002)(36756003)(38070700005)(558084003)(86362001)(64756008)(8676002)(53546011)(6506007)(2616005)(76116006)(54906003)(2906002)(31686004)(71200400001)(66476007)(186003)(38100700002)(122000001)(5660300002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHFQMkxMRUNLanhCRDlTbkF4M0EzdDhmalFKTHNqZTBYamZuNnR5d3A0MEZL?=
 =?utf-8?B?UjdETTEyS05TUk1yLzFrNHVpRWFFUitaNFZyUTBpODJDTEllNTFBS0tEZ1Za?=
 =?utf-8?B?aVFyM3d1Rnk0ckkrU2pSdTd6VDJQcnJxZEhmS3grbW5DMGlPN3psL2tLUFFr?=
 =?utf-8?B?RHJ6cHA3VU5wUVpvTHVnaG8wanlrRzd2clllSTNZdHZFSGJEaWJWSnRSMWNr?=
 =?utf-8?B?OEU2YnNXR3QvRWNGK2U0MXVBZ3c0TkI4VFIzN2J3MzlWeWV2OExxUks2Z3Ev?=
 =?utf-8?B?eXd3MGpzUXI1S3BtY3NpMTVyaHBvYjE0VG9HckJIM0dvUmZGSlQ0TlduajFo?=
 =?utf-8?B?MFI4Ylh4bXlzazVWbzNIU2g3MG9rUmZ2NElLNm1kUzdJSXNvK05RejFTR09s?=
 =?utf-8?B?aHhZeEVZSW9Vb0dsSFY5MlpIUmFNc1JmTnhmTVcwVG1Id3ZwQUpZRXhpeGxT?=
 =?utf-8?B?cFc3L2RWTEJTTlhqTWtQRUZkSW9oUmxqUGZSbmpRN2hpeWdKWUJydzJHalc5?=
 =?utf-8?B?aXZSYldaTElZY25JVWRPb05IUTlDYTNFSUJNM04xQ2piMXgwZ1pWbWhCempF?=
 =?utf-8?B?K2ZUZk9nQUcxVWZMOXM3YWFwbmxmcms3dFIrcFpLTGNxa21vcUo2cWZQZmt1?=
 =?utf-8?B?SWFyKzNieThpUlFQc0RUd09NYytMazlUaW9Gc3VRVEUrNHJPWUZVWWszejdh?=
 =?utf-8?B?R0pWS1pPS3Q0d3VJV2NXdXpJU2R0MXpYLzF5OXR6S3JyQ3ZPbGVIRlBHdHVp?=
 =?utf-8?B?cmxpR0c1S1hTanNxTllncytxWkhnVktvVFBIbW1rRHlwYXhCZzdjNkxPM2FQ?=
 =?utf-8?B?dTBDeVVwWmdlOTFiZDZHM2o0bkxGWjUvcFFyc1IwbEIveUZXbzdQMERjOWlh?=
 =?utf-8?B?WitEaTVpWllPbkM2aUJGQTg3UUxQaEJERThpK013QU9lT0NNb0Z0MlZDM1Q1?=
 =?utf-8?B?SCtEVGNmMzh2WWhxbEpqY29vYXpBdXdTT2RIbFhjekZGWHNTRklTSCtVZ2d2?=
 =?utf-8?B?b1czbXVvL2lzWHRZRjIwbkI1RHVEVWVaVHYxdldJVkhOUmhOZWtJOTYyaEFZ?=
 =?utf-8?B?T3NGcDJpZ3lzOFdWcU4rSFhKSEZvRlFwVjBseDdsWS80dlc1SXQyazFrbjlr?=
 =?utf-8?B?L0NyclVMS2dMUmJYeGRTMlRJbG1PQ1JJOVBnQkhTa0l5SHc0SXNadHNGU1Zn?=
 =?utf-8?B?U2RxeXFqTzZaRkxpd1RlMHJRWDNWNmx5emhkaFJoVndONlNLOWFVcVJhTFFm?=
 =?utf-8?B?NUlENktna05GSGxUL014eUI4N3kzTzJsUEQweGJqOVNUcEpXYTNlZm01Q2h0?=
 =?utf-8?B?T3RYenZSSkF3UStucDNxSFVZR01GaFMrazJ3aTdJaWlHSXduZFhSdUpyZEYy?=
 =?utf-8?B?M1liRDhvQUFDekVxdUxOajlWb3B0Snl4enpMeHh0L092SXlsQ0FMSVBZTnlG?=
 =?utf-8?B?dk5iQ0JrNmxzZHRMM1QydXJsSlhBUVczTTBzRXFvUitXSUFJMFFsYlVwQVIv?=
 =?utf-8?B?ZC9nQ1RLQng2VGprTVFSL0FvdkJ5ZnFCaVBDaFNXQnM5QUVVM2FlZnpscDR6?=
 =?utf-8?B?SlJVMWdGTUhicjFXSlNoYnJ2K2p0dDlMRDI0VUZhTHRoNTlUSmsxQ1BtV0Fp?=
 =?utf-8?B?aVZMQmppaEFSb2VVTS9qdkdyaDFkTnFXdHltblhiTXlZaFV0YWlFV3VhTHlT?=
 =?utf-8?B?bTVnY25qa2drUWYvNG0rWTdsOUtMRG50YTdNWEhDY3hNTzBFTVlOZTRxUGZQ?=
 =?utf-8?B?ZmtzbXFiMnFTY3JGSWovQnBaRS9jYnEyTFdtT05nalhYbGN5bzBPRzVZZ2k4?=
 =?utf-8?B?T2lNTnRXWk1Bb0xwSndwQXR4NVBYQ0dKWmh5WUNjNFZsUHVib05heUxML0tH?=
 =?utf-8?B?bGxzTVd3aWkwbnczcG9QcUw1UWw3d25JRWdFMjZpcHdJRndaT203VnVBVytL?=
 =?utf-8?B?eUlXR256NTd4a0FLdXNsM3hNZndrT1MrcVhDeVJQS0JCV3dpcUxjbEF2cVd0?=
 =?utf-8?B?YzRORCsydVlTaXR4UktFekR6Y0MrWEJERDIrMysva3BleEwwZ2J6MGpwKzls?=
 =?utf-8?B?Ynh5dUpwUEh5T1RkOVBOYm5PRk4vcGhJZE53THg1MkQ5anBaczBzVTd0VGVQ?=
 =?utf-8?B?MHMrZjJ4YnVEYkwvd245NGNzQXFnODNmNnUraDNWT2hRVzdMSFY3Y2kxK1hC?=
 =?utf-8?Q?DlClH7U89Y846apr5mqgYA7/0rHrHBwsf2+GPa6FPkXx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <868C9FB66E2FB8488F81D560DD78A9D3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27496363-1081-4bca-f289-08d998ddb45f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:07:03.0137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uWeQqCw/DGfPjpPpAanxC0DY9oql27LyyU3QhjHWblB6Nz8X53992rHkC6P/L0Vhzl4wwBhkRRo7j+D6XMU6jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBBbGwgcmVx
dWVzdCBiYXNlZCBjb2RlIGlzIGluIHRoZSBibGstbXEgZmlsZXMgbm93Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KDQpMb29rcyBn
b29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4N
Cg0KDQo=
