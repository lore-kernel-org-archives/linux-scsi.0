Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3595AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159BF60FD7
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhJ0AE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:04:26 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:36768
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234796AbhJ0AEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:04:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed0t9vaJvDDWJSr5Y0+xUESuDWjOCvDyoXKRghT/cQB4pgz2r5HtN6dzc/dChhi6OVhdsn5h6c9OSBvjkpIWK4B3SWjRz6gQvsFGIIC1lTDu5eHxvoDSQJByoOh7rluAzrcBdpCJ+GkCvTuYU20gYD7t1ywz4EpE/T1yqFYWwnuxdrv+GvMb7qJ/aEEZ9RAFP1UTSgmFgpiEVTzHa6cQ8+6M5H1+bTjxWaG2A4+hESA4N3IB8ONC1msovWZLvOnI0EJr2oC53D3WmatQgI5m3YdiNC88KD1oGlbvJGzhDpNLIcfk2gzpgpp2tM5zmi5fQ9cCerYZhVKowaDYHBWv8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPxRVU5FRQqffJkUlGzjeJ3xaAzsp2jla0T1FeSzOeI=;
 b=EP+UJXlA+tqPaW3NcJB3W5bKAs/3OL8gLTl3f4BTTVPbtJgqVWZ4HYgYFkz5HQfK+DNrdrCU3j1AbYDE3tGmrqJ8kkuftBoHw1XZHkIRsRI+prKcMWe4gdo1uIW8dhUratbPEPZV3JtiobuZ9TlBo7AZ0UJ2qrJUiXJqL2fgZ9O3dwK7rLCHvIDPgjiu9YobCdOiAA5zd4KRdfy9xarPhOzPzT6O0xisWzONnF1lC81OlWqHVrb89IC4z26CQ+E1TKB6FxmRGBlKHHdqKol1hHbW2m6QyBYdQWchJ2eAIuwqKdyXmRFh3jf/j6b26gDu9AF8eYSjiV2n80Kh3kzZvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPxRVU5FRQqffJkUlGzjeJ3xaAzsp2jla0T1FeSzOeI=;
 b=Kw2rZJ+3IbrbZ145iNmm/iwZ8sovGzW2aAN38FXJpjnFbUUJnOIj1x8qJ2b3N4ubnqCiX4SLWL3I+Pvear68xkmJqhnExuQY5S2+WlxYQbaQJwjIQeNFjA12SWURzjNlD2+6fN5U5KbBWqUIF8MyQJ3/eTWotszz+x2dnWxO6oOSo7HuWpoyuUuE0qsEIh3+a8kFCQouLU+JuXoG3sddPWCsaNR0pGQwG0iJx2QsYZ+VrwbsgkQBOhL1DQ0HAEsUqm8LY2uBK1+mC5Ko3epDVJWa0FcGEPHp9Tfkw6rZK7mGnAKvMj9XKnEI77Gmr7NFf2CoqeApVLTIfvvxTikbvw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:02:00 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:02:00 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 07/12] block: move blk_rq_init to blk-mq.c
Thread-Topic: [PATCH 07/12] block: move blk_rq_init to blk-mq.c
Thread-Index: AQHXyW7B1SCT1KQU5kGgTyvn4J2MAqvl+NuA
Date:   Wed, 27 Oct 2021 00:01:59 +0000
Message-ID: <c4524ae3-26d0-3f12-ed82-7611e56b8d04@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-8-hch@lst.de>
In-Reply-To: <20211025070517.1548584-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23cabb44-14fe-4f56-109e-08d998dcffc6
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB00169E976B7B8AD6ADB217EFA3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:234;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hh0oFIhAmdkH2uiB+30besP1SpFxX7eFuh02GT3qTLjPod1//sagVxpIRwloO1Nu6nfgwXuv/69YkP1W4FhwgV/G0uNpfIwgx03GOZ2WAjiYevRAikYs+eG6+p5Ni7vwTmznvOi87E3v0NatlVZ22G9Ks4DJobq1V91rHaCPpiS/dOVHizPn8tRwzaBjFjaXkim4lXcyAwCp1iJudhZovwx0+zt1EEwig+lo53xTR4k+iYjrBWLbZI2W+UfVq4bA5Lik9Zcc7Zy5gKaiaBg2Ut+CfQYcbLErhRsJAVrBbTC4pGBnxwFGDKrOs6qVt+SP6tkBnBTsK3LFImzpXyHubWc7ImMiCV/hal+91Y6izHG/hIjxPEYP5/6i5/A7YkavDE/41JHtLhO9dkEUXFywDaWA5nFHOONofQr9V1GarOF0ieH+IojDovUEJb7ymC/W3kDz5yvfqmR+sjJmw4ih2ynNdV8gI91MkrX83veFV1U8nMPVTs1S6uZGjw/ej9uWSoHCPnQN3UjmDn5iBs+q8DdqS/sKjuRpw0MgvesGEzZ+AD9vAv6K7S5hYn5N8ZkfXb5zziDovyurtkYKCIctuz0Ld7GbND4GVdW6b5iXIP/ifo2z+tp9EtR3yOQRJ9X9pmd1ksS4jENzidMQ1toGC5ywHbV+Ms8lfezIrVRlU6/+J7m0KZ+iqJd8ZrONLKQb7WHWJ9QRxwFdbI/jSBXSwFPXoXSlOXgwkE2urqU3nGw2mZXrlX0RPYzyfUULD7FDuEsh4Z4u2Kn12Rn3YUTocg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(71200400001)(66476007)(2906002)(5660300002)(38100700002)(122000001)(4326008)(316002)(186003)(8936002)(83380400001)(6512007)(38070700005)(110136005)(6486002)(36756003)(31696002)(66446008)(66556008)(508600001)(66946007)(53546011)(6506007)(76116006)(54906003)(2616005)(558084003)(86362001)(64756008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dC8wWk5hK0tKNTEyQUdQOVNGOVduenUrcFhSWGpLdm4rUkRMK01yREE2b0hP?=
 =?utf-8?B?d0pCYk8yaEdaTGFlY2xCRVVQSE82YWQweHZ6OUhOVXYvZlVjNmZEVGtEWFJI?=
 =?utf-8?B?V2kwSmNKNlBXbXdtaW1PSG0yK3M4OHhxLy93ZkVJZVowdjZuR1hqZWUzN1lV?=
 =?utf-8?B?VkM2UW9Wb1BxZmJheWRtNnhjWkpnVFJEczFYV3F0NVJDYVN5TEVmQUExQU90?=
 =?utf-8?B?SkI1ZHY2RHd0OGRpUmtHZS9Qc1djeUk0VjZWL1piTWxScGhralkyK3MwaHlO?=
 =?utf-8?B?YzV2OEJZN21ObWJGUlFUbytSakNYSWtGUzZRbmNsMlRjOFZRWThsWFRBMUlI?=
 =?utf-8?B?UGFONGI0SEZXM2xVR281V3RnWFd4bnpiSVhBNllQQVJLa0tFdFdKcHhoWGpr?=
 =?utf-8?B?TmZraUZmWndQWE0rbXdSVHB5RXJBQkZpeTUzaFFnNkdhTzVzZU1OcG5CRmdH?=
 =?utf-8?B?Mm1Gd2hpbjgwYVU1SzYyaXJQWGxwRzlzQ2Zrb3lla3M3YnRLMzV6NGcwMWhv?=
 =?utf-8?B?MisycFpzSFdIWktNUjBCY2JVSWdOZExqOVZvZjJUaGdwaHhuUGYyYjFSbmg5?=
 =?utf-8?B?akhVSFhMRG5ESmhLRzRNSFVJN21rNzJ0VXUzWmhXTGdtZnh0NkdUUlpZemdh?=
 =?utf-8?B?RmFNMDB2M0hpYmFLdi9GaTJRRTBubFFYdHBGRVcweGZERGpQYWt4YnFlS3Nl?=
 =?utf-8?B?Y3g2VDNkenJIamljMmQ5Q3ZVZ3JUb3ppK05xbDBHcjBxU1JsMDl5Z0FjQ00x?=
 =?utf-8?B?UnpvNUM3V3JPMTYvU0FMWm9HYzJEZi9FcFlaNHlIQUFwVHVuOHZkb2s0eEp4?=
 =?utf-8?B?MVBCaURCb0tTZW50L2ZVVzB2ZXRoV2hwbGUrQzNGTzhrbUVrZFFubkx1cGc1?=
 =?utf-8?B?M1A1dE9pTGlucDhkWEZPRVNHQ2IvSjMyenR2WE1BKzM2bHo1QjhnOUhMN04r?=
 =?utf-8?B?cDZRR2RveVNVZjE4aERjWWlaVXBGTnpadXVQQ2l3bitoOWFwckJjWkEyZVM3?=
 =?utf-8?B?MjRmMFBvSldlUGc1Uzh1dWRtZDh3Mkt2QUdLemFhWStsUnQrRXBsMmphbm5F?=
 =?utf-8?B?OUl6MWMrUzlrSXNFVkpONi9zZlAvZGtGVnRqdlB3YWd6azBKbDJBWXNWeUNr?=
 =?utf-8?B?N3IxYVpKbjlVbnYwQUU3US9YNVloQll0WmNMblUrWDBvc1dNSU9GM2g5WlR0?=
 =?utf-8?B?Z0xjM2o3OWxockVtVWFWdHRuQVYrM1dFZkxmUlU5WG9XWkJTWmljdGk5N1FX?=
 =?utf-8?B?L2ZiWTF4M2ZJZHQxNWNybS9LRURlU1JIUDZJSjBNckc2TU1VT3A3UGZPZzRL?=
 =?utf-8?B?S3h3a0RIZ2sreGpkZW5aYm5xUjJXMStObXJkN3hRZkJhSjBPQWx4NmJESWRE?=
 =?utf-8?B?dU4vN1JSQWlzNTM4TFlzeFpIeUltci9nVTBQRHBYTi81K2x5L0pHZFBSTG9r?=
 =?utf-8?B?d0puT0MyamtTTmxDVzdQTG9GYjBuUno0Y0hJTGJsdEZyMlVNd1NjZUJNTURY?=
 =?utf-8?B?V3hvdU5nTFl2OHNqdXdJTlVUZy8waUQ5NjJ5dldyNlhHNFlicGwzaUtVK0xu?=
 =?utf-8?B?RVl0R09hVGxJb0FHL2h5c0cvSC9xc3RrWk0vazdmNGtUTXJKMGs2RHlGcFNV?=
 =?utf-8?B?WjZ5L0xsTnRZUTkrUHFhbEd3OVJXTWxRY1RaczBNelk1TkhISzg2OFR5N2J2?=
 =?utf-8?B?MUhGMkk3Nzh4ZktTWjhQOTlMYllQQ1FGM3YrQm9CdGhBTEx2Uld6SEVzTThv?=
 =?utf-8?B?YVFySWl5MFZGTDBtd1JwbmdHN1VFY2h2cWJqdUdGd2dpeVZSTVVRL2ViTHAx?=
 =?utf-8?B?U2F4QS9hWnEvRTdGNGVIUFdlOGlqWFEvWllFNW9FVEJoRndkZHQveWEzSEhM?=
 =?utf-8?B?WVhMVmY5dXhvVkdxQ0FaQ3ptOGM0WWl1NnFwLzhBODhYZHc5T25SbkVtQmpx?=
 =?utf-8?B?VmlxZUY4dDhYT0s2ZGgra1lsWXNvemVYUlJta2N1d3pkeS9DVDQ4bzNZYzZ4?=
 =?utf-8?B?S3lLVXRlbHg4aEpIVUJZck9haEI5QmhKWVVlTUkzNGNNbkFWL0NOK1ZTQUJ6?=
 =?utf-8?B?UUI3OXhGdStEMHhUTXdnT2xuS3dmbi9mcStKZVovTDJVck5rSkZ2eWFaUCt4?=
 =?utf-8?B?RzlabHhBVnBRUTZjSDBscHptZGE1aTNlOTd1cWpndnlBenp3cGsyNDY0cGpS?=
 =?utf-8?Q?b2Qxyyw//d6qbx04C5Yv5uHo6tkRpIoZJ9k9sv7TgV65?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C70747988900254B9B25BA41075DB8EA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cabb44-14fe-4f56-109e-08d998dcffc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:01:59.9564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWqhTL3AsQ/NO4+3Z/iba0w2r3v2J2+/Cx8e8HXBqrHgDI7BlyxrdY8k+TMuYGXS1LYja7yI2PFD+JTN32eMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBibGtfcnFf
aW5pdCBkZWFscyB3aXRoIGEgcmVxdWVzdCBzdHJ1Y3R1cmUsIHNvIG1vdmUgaXQgdG8gYmxrLW1x
LmMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0K
PiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8
a2NoQG52aWRpYS5jb20+DQoNCg0KDQo=
