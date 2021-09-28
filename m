Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702A9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536EF61262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242878AbhI1VZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:25:20 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:16937
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242858AbhI1VZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 17:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXvCQsTidH6WSCVQYUQ3w6Bbpge09BnUV8Oy84eFH8FdCvw6F+/0LEKBnvP9znRUPiaTjGxibMe0g22emkGYMt7Vs6MS6hdN92yZlxGdne7X2Hw6H/t4Egsu9c6u/ti0joaAKV3EkdR2U7ggoT9IKjt25hw/JTpVthVbWnzsAG42vGhw1ldeZcgwLvlSl2P/gwDFJ7BBqfaRW8/HHxh+Zap8Sd98gs7LUH4i+HDsU4AKfDmmwekSs9Qx8YIVqCt1QE49/RhnzJqADl1dBLwT3UqgJFxIXs8yUj/V81GIdAzLdXdgIoQEcVh8qDjBrox3Nn09LtFcy8ULncnSkRMF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Lmd4zA33GqMGV0478UM0nkNMJmsLu50zo9N6WYrXn/Q=;
 b=gxpisJtFRgDXtfow3orsc85oiJclm2KFum6nSR5ES+XozeGIN7VHLXMwNsWnBKBV4Bb+fSFuopOj8iPxzBmAM9iFE33enA1Ps/iG4cY6gpOa8vkXUMT3pdwIWYAjbLlGeYyyGzsTEBL9EqqmHgjsCgykougRrn4gejvE8Yc/MrD6tdfxoGkAI7JtkqrEQ6JlXLxlbANxFThFsg0FpG1v+yrVrLjguyvGJArwnheN5xN2hm1fCc/kQ3ipbiJMUbQ1WpSwffy0L4+Z4kVnDUSRPtV8xCE5xKfaDITK0ytFW4ZHwtoEv5pCDsTA3fGC4blY3UgQKrRCGpjsTn2yje3mtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmd4zA33GqMGV0478UM0nkNMJmsLu50zo9N6WYrXn/Q=;
 b=BKmxEz43jzb6BSL9MQ1xDyL0hxVBwqP6CF+QKO0XqpZwl6mLot41ZOalQErftQY5Htnoh+D4n6fpPKGsq9bMn6oC3TPrJabscJA6bNZ7Dmxlc+mCndpncUhO8eXxdfHFRmVbrq+KcpEYT4oX6ZBrP1/huoRLJ2AQrxwfJmclAiSnDP6C4LOxK7wYEZQKgmzOD3efNZ4jGpmWcfVgHZARm1sjyu9q4Bggn4nN+eWVSpnqfcplsMAJzkA9ps4JmI8iA3OGTUpiB7c9nom0i44ehKX/IchDInf9KhEeW8yk9DljXGCM2O+96AwAYS+3AyBDLRpPa8GowO1oiP6Ee+9EVg==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by BL0PR12MB4705.namprd12.prod.outlook.com (2603:10b6:208:88::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Tue, 28 Sep
 2021 21:23:36 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 21:23:36 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 4/5] block: remove the gendisk argument to blk_execute_rq
Thread-Topic: [PATCH 4/5] block: remove the gendisk argument to blk_execute_rq
Thread-Index: AQHXtClJ2kaEey2kVk6VrqDO9KSdfqu59d8A
Date:   Tue, 28 Sep 2021 21:23:36 +0000
Message-ID: <095ef848-5161-cf85-d043-7c784fa0871a@nvidia.com>
References: <20210928052211.112801-1-hch@lst.de>
 <20210928052211.112801-5-hch@lst.de>
In-Reply-To: <20210928052211.112801-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c86f5cf4-2524-4350-6ce3-08d982c63bd6
x-ms-traffictypediagnostic: BL0PR12MB4705:
x-microsoft-antispam-prvs: <BL0PR12MB4705D6B7C4DF5CF4F9FACEB7A3A89@BL0PR12MB4705.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PZOsKYA0Tn8hR36Cpkh+4iRWaLtvIzR2cUOVKnWxvuJbe/hcC+/x0QWNPw6Lq+bUiYRR71IwykH2Ibb819qsmoH1AmxSFFqfzVQ+9tFpzHQVeacahlC8iLznQi5VfRU278tJtiPKbVmWcNlHaDH9fjzVUcJ3QbjW80ZM3cHL5r3k3tVutKbDEKA0iPwjLE7yb5OOFqYwcUUTIRhmHNVz9BiSdzFVe7NQ/k0qcSH+JU6M4EDPvDWo+NkSqGqpkFFV2bVcm0yUYaZYTxdY6KyNmEOi15HZh4LQJfe1pdonnFPXUU1PQEcZQxGhp1d3T+xOYbtF3gBhyGwFROFLK/ACTaC1RVT9YBwOMTBXzmUtz/C8wkkFoZJ8AwnXWhweQM8FH/BX7bFEoeA/WiDds0ZZNKSoSoZfFqZ8i/kvoUVfY4WFeqIHFm2TumdAVso0T6179esiVQtehhDSCUdbpO4Ony9KSR3ZzsYytg9awX6iqqxbuEm1//PYb347imfdAXdVF94JEr0ETiUKTUF/Io8Mwa4PYyxQixANTwbV9PpV2W+41WZOX3AmX+F1x4CeBrzyfQq1OjPhDwfiGYfudLf8Iu+C6PveWDSSa7RsMjJueYLU43GiFVJEeEFVBAErjWU0nKwIm8Zl65Da+Tp+ocsX5fdsjwA0p67IEXO5MuhR0F5YBZ+Nyd8FjgeVLzT6uFhnWrz8Css2gu7TzZpX3Ny0FAZomvpE/ra2Vjm+7J8uopabW+hb+yxsUHIhq0n9sOjcXHapsZMTIdH2vNpVdDt0sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(2906002)(6512007)(4744005)(4326008)(8676002)(186003)(86362001)(71200400001)(5660300002)(36756003)(6506007)(66446008)(64756008)(66556008)(316002)(66476007)(66946007)(53546011)(8936002)(38070700005)(83380400001)(2616005)(31686004)(91956017)(76116006)(54906003)(508600001)(122000001)(6486002)(38100700002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anFja2tkVmhOT2JhMG1aTHo3VUpuN0Fmck5oUFZIL0dWUG5rNkFLVDNGZkNZ?=
 =?utf-8?B?ZlcwMEdqR05lbmZoZFVSRThyei9ERGFvWnNiWkY2N3Ezc0czMzFGWW16amYv?=
 =?utf-8?B?bHNuQjJ5Q2FIZ1NGUjBVN3U5bEJHZGlDUzRHa0hISTdaVkFYNGJuOEs4ZW5R?=
 =?utf-8?B?MnhQUWxGOVk0c29JazZ5MFFKNkxIVmZseWx4eEZydnhJVUkrVDZHeTJUWTF5?=
 =?utf-8?B?c041aTNLeFBMVXQ1amhNNDRzU051emhscFZiK2h0UllQWHd2NlZycEFkM2k1?=
 =?utf-8?B?ajFHTE1nUFZCdXhuU09ETy9BN2VoWTV6STRnVy95eHlrZ2U5NUlmam5yVHVh?=
 =?utf-8?B?ZTExK1dZY0RSekJmWlp1WHAzS3dYdnYrVUJvSHlmWjZHM3JoLzU0SXBMUXll?=
 =?utf-8?B?RUJlZU50S1pYR2pzMnVFZk0xSW9GNEdheEs4TGNFdnZzR3h2YklneHV0Uy9Y?=
 =?utf-8?B?OFJwR3BLU05iaGczSU1ncVMzZTRkWW9STDJwMHdrdFZyM3Q1dTdVcERQcXRK?=
 =?utf-8?B?R2lCb2NxaXpGdXFheEEyREM1eGFvY1hhYTUvSHl0ZnJ3eWJrendnM29ZV0FO?=
 =?utf-8?B?Z0ZUQnhhZFQ5bzVMVWFKTk5OYjBDcUlMR3dnRXUwcVRMZFNLSjU4VWxsY0Ju?=
 =?utf-8?B?SXpKYmErYitzcURzaUEwWXBQdjBuNkRXbUYwOHRoN0pBL1E3NVlUZDBkR0Ux?=
 =?utf-8?B?cWd5ZGdUU003WHdTYkk3dDVXaFFuaFZ2RGxXdVFiWFliN0ZmSVRicUFWT3hE?=
 =?utf-8?B?bkx4RWxreEE3L3dHeVNDVHBybm8xQXUycXFhaElRVnpBK3VnNWt1S2JiWHRN?=
 =?utf-8?B?YTFPUDN2cDBSVGp2UzJmaWlSSDJMbDFmTXR3alVwbjQySUJ2bTlFY1FGZU44?=
 =?utf-8?B?a2NwdUZraDJTY1MxUzlna1plTDJ5RzB5blhPclFLUlVXTVlhTERad1RhSmxm?=
 =?utf-8?B?U3RxdU9iS1R2ZmlEd1JOblZ4WnpZeWN4TTE3Q2pyL1hJU0FWazFaTTNPZVgr?=
 =?utf-8?B?eHhKQXUrNk9kNXJqVFlPeCtmRC9rL250Z0ZqZWV4b0w3KzdhVTRpOHNFME5V?=
 =?utf-8?B?VmU2dXJTbmo4RjY4M2htdGJwMEVvcnJFT1NBb0JIelAvSUpQcnNybHgwLzB3?=
 =?utf-8?B?ZGN6OEt1dGZmdEU0YUFGSnQzbXBhZ1A0eEo3OEpLcnZzM01oMFZqc1oyTVRo?=
 =?utf-8?B?czlXMmxORXJZME9jWkRqSFhNVWhEME51U3Y0eEY5bCtzNVpuVExsS1F2VjZj?=
 =?utf-8?B?NWJ4cy91b09EUlBZeFJLVW1RZ0pWU2RuU0ZFVDlFakJWVVU2Wklmb2U3WUk0?=
 =?utf-8?B?VUoxVkp4eHJnUlQzaGwyaHpFeGVpKzRPVUUyUG1uWWxSRjRrR0YycnM5N3c4?=
 =?utf-8?B?OUZJME85SlFHMXVMTVhXd2tIaTJOSzEwNGVQakxDbFJZQWMzdllhZ0hSS1ND?=
 =?utf-8?B?UnVFVU9mR0d3Q1NkYVZPOGxVUmFLMnIzaFJYVytPMk5mR0Fyd2NXVThxUmFD?=
 =?utf-8?B?NVBGZER2dDlkZEdjU1RqUlA1Uld3YmNuR0FRUFFGWnFHTGJaT1hMVTl2WEZG?=
 =?utf-8?B?dWw3TFJqZ05leEVLWFdGM1Y1cTV6QW85LzhYQlFmcmJGdnBGRU5GKzNhcGwr?=
 =?utf-8?B?K3ZDNmY4bFdNbUtkcVBWamUyaDBZQm1DVUhYUmUyODdwU1JpYVJEbS9MRDFj?=
 =?utf-8?B?cFJ6ZVppdXFqSUFXU29PSnlSbUE2UVhKTW1rbEQ3VStaTTdydE1rWXNQdDVJ?=
 =?utf-8?B?N2VEaUZENWJBZFFnQmJhZGgwV0Q2VzhDMTR6RmRvZzF4YVJCNFZOaGJmdVN0?=
 =?utf-8?B?bE1wTU5xZDRlM0lQMlMyZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9DA7640C494CD4F8C4CAA065E6FDA9F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86f5cf4-2524-4350-6ce3-08d982c63bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 21:23:36.7490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8V6UcGaX/fBLNs4Yy5MEGCF6cMAdXm8CUmTVwak5s8RGrapkjE8YnDeyl1mNZSWiGzLU63XMgjhDDvwCa+RzXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4705
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8yNy8yMSAxMDoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFJlbW92ZSB0
aGUgZ2VuZGlzayBhcmVndW1lbnQgdG8gYmxrX2V4ZWN1dGVfcnEgYW5kIGJsa19leGVjdXRlX3Jx
X25vd2FpdA0KPiBnaXZlbiB0aGF0IGl0IGlzIHVudXNlZCBub3cuICBBbHNvIGNvbnZlcnQgdGhl
IGJvb2xlYW4gYXRfaGVhZCBwYXJhbWV0ZXINCj4gdG8gYWN0dWFsbHkgdXNlIHRoZSBib29sIHR5
cGUgd2hpbGUgdG91Y2hpbmcgdGhlIHByb3RvdHlwZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2
aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCg0KDQo=
