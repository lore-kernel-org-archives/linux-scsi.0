Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C877C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E51B61078
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhJ0AFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:05:05 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:51040
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234796AbhJ0AE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1Q1tziqGo9+tGzuPH2a75WOROoKsZ+C/yfiLnANZq5+uVMoQJ6R2H9tVdC77iMW0FBE1vcBRLzmu+nPqagRbNBZe1OoQpSanqkcgm0IZYA7mBa3LCVsYo6ZgfgYpyioQrnZrgjbpetACURzQlaf4TqAr5cKCEYHIbXE8BAykiR5uPHVkxIv8NDeEb/43s4+hNRu5TmT92O5a4lsQ5O5JcGliyQGJ7DEdpyHc9BvcK2TrqPSFHmtXzXHNnxNxLvuwu+wDjceFK2dYn6nScezmuQ+/g+HFj7M/155OkXLVVl/IOtiselZv8kGvvjsIXIt5c+cl4Q2aH3HWR23FYAUUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5iXYGP/Ew6S7tlH2ogdZD7kNi4b/o+WV7qEx9sJHAM=;
 b=ksC7fVjofsDtu+WDi0oLPtDJXSem59ad318cysMVhZ2bbEzYEtGJkyyHSoGtL3Tjb/8NPwGXtIHdWb/G9dQdzc25VzjHXm7xlifGDMr4N6zVO/Cs4ixpdMQNHgo9LbbyNGG+epWPT9sdbaYvXCcjB2hu8rWeII5dwxn2DQryvxZl20OSviqh6Yk9y+3XMAG/LIe5vxvXuG6why3Q9AFBzOAaXWCTLRpcw8MMw2nlOZaot+6fm5FuvvQyFn1tIWglrP+HTt0FvOKmmA7mle6Mxi9TXAzBYJeRLcR/BbDQSogjI/Nvxqx0iRVK1NsIcbgxVGnHRCvRp6HctOjL/E+Nlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5iXYGP/Ew6S7tlH2ogdZD7kNi4b/o+WV7qEx9sJHAM=;
 b=gj8W2/8qq9rn4GlIVmTC7KO1aQ7OZpXsR/lUe4V0pg73rExWYkA131YM7MzLB8rvVzSLHnKX9nvS/RtEkb6+c2zNyavXPn2uHObDECB67s0cCl0EaKI7Y24nWQd3QbcnVS/UCXS6dcFhdXLrG58QQIO948qX0Zre3YMUN14vFgZb8J5BODba3kuPJ5MBsHP4zifGVARLIUGUSsaPkt1B/iLDnKcs2xO9Lvfni3+QRmuwkaN81qM13AXxZ7HZMzsB+fmGkL50v5yV5GLBmWNhZUWTVHZ4i/AGfyd0Cw/RjtspGF7r+0UV3LFR3dUq3Bb2VeSQajh2/dMYRYqFK4EHbg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:02:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:02:32 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 08/12] block: move blk_steal_bios to blk-mq.c
Thread-Topic: [PATCH 08/12] block: move blk_steal_bios to blk-mq.c
Thread-Index: AQHXyW7hQcjp/+RoK0ePDWeE9sY47Kvl+QIA
Date:   Wed, 27 Oct 2021 00:02:32 +0000
Message-ID: <4e3879b3-cb6a-d7cc-099e-dc1739e2d520@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-9-hch@lst.de>
In-Reply-To: <20211025070517.1548584-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83529f31-987d-4ef6-b346-08d998dd1329
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB001652A0DFE842CC8F73C781A3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:287;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //yvbxxesonysdjm3ytnTGTg5V6P3IpAk/qRTC7l1D7heUMrTWuHwuchTCgOVUAM5E8ohyQw7+tOKM+YyCoxI6RY4ZyC6s2rXe2JLDNvnXIY6F5kJgwEO0FuxMYXwIP+ZaC1bgMsEmPzySrT/DTMHIBpU1JqDXinOisQTFSE5IhjXCiEqZ5I4FXuMP6x+MjPijJG0Rhe45BT8KZvXq8EbtdExgMHau8PqgrH9jQO8XTaz+d9JRaNiq8Xe0isYW871AvgwWvCnStmUTGeq5tyMe07tJPC5cz4pGUt6EY3XyUC5ZG7gPuFlCGs4sGNZCVdKhsLH7TOJWG8U/2OForUGQTJLpPC5ZBiBjdK0XPdVmpvvI8GUHHLFfy5QU8bygLmpOkxwnNv1K3nw9MpyrH42zHKaOeSMM4W/CfAzNpiaGgP3m5MJUtKMEpAm8Jg9BzXMjxt2CBH4M9LpLT/KF3KJd3IZtNBE3fea/hdJZn0pbhw/kUq0BpiafZs3GFJ3ObkVPxTnVmzNVLaPd5s/1C7txY9Pt+gRZOTd1iCEP13AKP/Y8VET/iJI6Ow2x1c350rD3Oq1oXocep012tEuAytup16kSzRda6icSPxA4is3DTFfyBqKyzwH6AzSWFoJDkR4to6L+UIZAeSNNn3Nwf7KHRIdTbTQjPDOxnU69h3bTRdWxDtfb3wn5wggJ/DP8EfJFumEQv0ZuGdwSu9PLm0xfhLldEvqSa34XkIurM64GJ5l7XdzMhIR+OtyY4IkvyQYvhQmNEihhpBUDRO1SNyKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(71200400001)(66476007)(2906002)(5660300002)(38100700002)(122000001)(4326008)(316002)(186003)(8936002)(83380400001)(6512007)(38070700005)(110136005)(6486002)(36756003)(31696002)(66446008)(66556008)(508600001)(66946007)(53546011)(6506007)(76116006)(54906003)(2616005)(558084003)(86362001)(64756008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cG0xbE8yWGV2OGVodDlMV2ZhUndPY2tKV3BxaTkxZitRMG1QOEs0aENzdmtq?=
 =?utf-8?B?ejRjSFM5TzN4Z1NqS0ZWTFl6VjAvYkZIc1FvaDQ1TVNSdEFWcW9WUEpETm00?=
 =?utf-8?B?d1RHVlJ0SEVHVXRjL1prNUdKQWxTQitXMm5rZ2RKelNMTzQwV04reVpUbEc5?=
 =?utf-8?B?V0xSaEJnNkpqZG41ZGtWQWJZY2p4N2dGSnZWU245cnVUVHZwTm5ITG9VZGM5?=
 =?utf-8?B?bFdLNkxncVE4bWsxd3ZEVlFjS1FXTWpCNmpUVENDYkxmaG9YdmthY0g3YlhS?=
 =?utf-8?B?d3VMR1J3UXd6SGs0K2JxVjA4dTdnNXpDMFVrR2VySWVpQmErbGdGbXh6am5P?=
 =?utf-8?B?UFJtS3dmWFo5aWQ1UzhPL0tPekVwUHdVU0Z0UllnVnhCQUEwd0IrcEhQODJO?=
 =?utf-8?B?UEU4aWRBbDE5SWFKOSs4NWt6ZWpZc05EREFJV0wyenNpTWQrNDVBNDBwZ24y?=
 =?utf-8?B?ZFBwVnNOcHNsV3p3QzdZb1RwOGNsMVpqWnVqVFlEaFpucnpsZFFaNUx3UGN1?=
 =?utf-8?B?UW52Q1VuVVVIS1F0WGtld2ZSVXppKzVpM2lzRWtqUFdPZ0ZGY2o5SDFTdE9W?=
 =?utf-8?B?N0hMOHJJdlpzeHhzaUgrSzRvUWJPM3JUM1VmWTVKR0JweHdWV2dqY2gyci9T?=
 =?utf-8?B?ZjJhT0tXZzNVNldyR3ZJdXRzdTNFVzZPMlNHaURJRU43R0lFb3hYQ0Y1cVZs?=
 =?utf-8?B?NkZRQ2VsbTdMaWdtdGxrL2l5QzhkQUdoTTU2THVFam41SUU3OUdTSTkxWWFT?=
 =?utf-8?B?bFIvWGduUEFaZGlwRlBIdmk4VWpHRHVWdmhRNFJCakNVQUNDY3AyK1hsVjI5?=
 =?utf-8?B?QkhvYjZUUENDZ3RoTnZ4K0pFaEltd3I1VkxSNkNPZk9ISUVwN2ptZ2tBWmZx?=
 =?utf-8?B?TlhqWEt3REo3SWtlbEt3WTF2aVpGMFljNmhQbkNWclVXZTl6aWNyVHBoeTRo?=
 =?utf-8?B?dk50eWtvbm5yWUZQdXI2MDl4M094OG4wQU1zbFdDaTJGNk1zYTJ6b1RreXRa?=
 =?utf-8?B?ajVNM3FhQnFkV3k5Qko2aFpienE3aUJsRGd2TkU3R05IQ0RBRGsraE4yZU8v?=
 =?utf-8?B?NktERSthZVJPWGxsT0lxNDNSRklJTFVhZ3hVcGx5TC9YSW1KZWQ4ZlhKeml6?=
 =?utf-8?B?OS9PM0FuVGRuRmxVellSN1UvbjdFejMvOWgwMUlaaUVzNHhrSDFBRytFUkhT?=
 =?utf-8?B?Q2ZzdEUvVXVrbnZQcTNTUEV6VFNqOTc2U3Y3S0tnQ3NJQVUwTWcvSnFvQTZ6?=
 =?utf-8?B?RHdYMzgwYk05Q3RsMFRUREdtZXZxVjNhWnZkcmJ1cHQyTXlkSi9sVUM4emtp?=
 =?utf-8?B?SkVWZUpQenVNMTdFUXJzdmlRUFRpYnRwZnpXMWx1NUJZa1h5cHQ1c0hrZkJx?=
 =?utf-8?B?VlcwbUxQNHdHK1pTZnl2TDFFV3NRdWVMdTdscVl2U2dScmZsWTRuWEd6NXFJ?=
 =?utf-8?B?ZFZaQTM5cFg4MnZsaVYvdC9PellwaXRqYngvUmVNRURCWGw4QmI5NFlGenpH?=
 =?utf-8?B?czBzZzhIR09pcy8zNVJLTENQL05NSGk0VDViSHJWdGh0SHE2cytyTnFsanJm?=
 =?utf-8?B?QmdUaHdqNzQ0VGE2ZU9saFhFMTNHbU9Uc2hZTTBWOWwzVGdicVJoUXVNQkhp?=
 =?utf-8?B?OVhkb1NLbGxMeFNJczJnUFRjMjFLSE15MFBUVFBueVp0NUF6YnMxcTAva3JX?=
 =?utf-8?B?Yk5Ramx6UWFNbklZY2g1Q1VpNVJkUThtNUkrRVBpVFVSVmI2OUFOTnY4MGRi?=
 =?utf-8?B?RlM5LzZyRTg3VGNtbUxtc3lVUlp2ZU9NZlhSalA3bVRDd2N6Ui9hM3lOYUVG?=
 =?utf-8?B?U3BtM1RJSk9Kd1dkSDUwVWZ5QkVjUzlGZHlGdlpPYXR5VXU4M1MrMFk5NlFT?=
 =?utf-8?B?ak9iMzYwN2FjV3NHQmVlOWNaa1JUUXhGdytJaldUODM2a2hoVDVvaC96cVBH?=
 =?utf-8?B?NUJCUS9tYmJCVGx6ZFQyQ1hnZHZ5ZURCNFlocEJTRWwxU2JNUFRlN2hMS3hG?=
 =?utf-8?B?K2hmVzNzUDh5a0hjcnJEbkFQSkpVVGd4MnQ0bE1MaWM1M09YSUJnR1dzak5O?=
 =?utf-8?B?MlZyaTZUY2I4YmZtZ3lGeDU1TGhoamhsK1pEa216OE9hNXVoN05YbGppUEsy?=
 =?utf-8?B?U0RkdUJhUGFXb0w2c0ozb1ZjdGY3YnluNUJJRUphQVhURzE4RnRNY204NjdC?=
 =?utf-8?Q?3cDMzYuz3gnGnlnR1dHX9qCdowKE3vJm9YWxoPOPTunn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <417DF312B96657429793250AFC72A4F1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83529f31-987d-4ef6-b346-08d998dd1329
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:02:32.4970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: azpRoiPSCYgwCpXZ6A3liDmcM9KhgGma4u4nYK3ZvI/6QVdTMvSzwo6Eev/PCubovd4U+ueivl9uTOmELkNwDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBLZWVwIGFs
bCB0aGUgcmVxdWVzdCBiYXNlZCBjb2RlIHRvZ2V0aGVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg0K
