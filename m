Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECB7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B462D6135F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbhI1V0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:26:17 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:18144
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242914AbhI1V0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 17:26:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kV4u/+bW43+E3Nxfq1FrvtA2Rg2vU2OhBbcrt7SBPHMSwCqmzEFqyjBityJjplvttmq4emiVYXv4RLMnsnbrCTLg+PmnMTHxPrX8GzlceCLugy+aqY7qYyG7VDAfkQ+355qG31QmitMblMUKquKcsZZ3tN2IUsjaAusgOix4e2jEh2goLoeJ+CYfsVLjQX3ca9SPNIQxnG+PJPaB15ClGz8LodfccvEEeg1u+f+3foM2XGDrRffZGeKpy16iG6TI1l0XvVFM5OH+1rFsY19aGBFVMEG9+T4IcFyPasyDYSyfW71U7l479gvmTE62J4Omj6lYDGsVR4o5CEYWutyQSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zl7rATBtlPlMDkU1HqMqr8trBOhqTMBMPE4YXyAPLg4=;
 b=dpkMr1U13rtgk08u442W80BGf5hiIGhq1cgIqtU96RY5dQmyUomGljkZpfRSX5ab3Xvgr5ExGnArLukQ/alfx7dd75lt+D5u6/7+tfd4vDgK3usg+EGTtO5GEvHLHA543VAssuhGEQc+GF4uaXPRNS2kNesAACJ5qJNMAmqB+gz9F3Kdy2vgRwyzb3/m+T/R68cY62htCYJaqqrqHi1WJcEYIXsvV1mIifWdkaa/3P6bWjj32Eb84cWO9Td8pW1pUoGUuRXLUJNAoo/MDNi/WSZSC/LPmeAR8Kj54mAiMJJ80KkJsNSuETnM4Dm4QwVOvbM0RRZLo2uSslm6KJ2Skg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zl7rATBtlPlMDkU1HqMqr8trBOhqTMBMPE4YXyAPLg4=;
 b=uiTV9leTXy7vRgHoxUKgOPFVjnzN648WfASuUi805kHUkVvwrJQO/XkK/01lVaGFbylsC9GwH/do3GTQ3nQ/u0pzsu2qcEv5d1qo84Zc5k0xd6L/zyf7yodHGQock1j0Qt9kq3GyttpfcmEb4Y0DA5788/JNZrLvO3RIplhdF68U43VWvvWWN1A0XYRrWKrU3mORFeMXGOyHg6yF/hGlwiKr6HT2EcTZ3eBoOKQBXUM5eoAStIsUXuQcACI01QKWTP1T5W7I8jYBuxb0G2+4Un6UGktdA6v6855c7KCaLAfXuWvdkrbNOaU2qyT5ZDEkCX0skAhiT+N4nKfmjL/V4w==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by BL0PR12MB4705.namprd12.prod.outlook.com (2603:10b6:208:88::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Tue, 28 Sep
 2021 21:24:33 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 21:24:33 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 5/5] scsi: remove the gendisk argument to scsi_ioctl
Thread-Topic: [PATCH 5/5] scsi: remove the gendisk argument to scsi_ioctl
Thread-Index: AQHXtCle4uQziXx8N0Orbawuxujm8Ku59iKA
Date:   Tue, 28 Sep 2021 21:24:33 +0000
Message-ID: <802e76e8-0bee-5154-01d8-6570d87caa38@nvidia.com>
References: <20210928052211.112801-1-hch@lst.de>
 <20210928052211.112801-6-hch@lst.de>
In-Reply-To: <20210928052211.112801-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5983739a-5dfb-41a7-5df6-08d982c65da4
x-ms-traffictypediagnostic: BL0PR12MB4705:
x-microsoft-antispam-prvs: <BL0PR12MB4705FC0EA443ADB87DB14831A3A89@BL0PR12MB4705.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +SeQBYFev9BjIFNlbdb3fQz4x/qCle1w7zlFiWWdeB2A9uin3yfik8grYGbT0ysN8QJmWfDZLPcxxQSkBhY4/aP2r4lbMBAFR9h7RODCLB7nuHH5j+UEzOudDCavholo7gE5lhkpvrGFQAGIeGFKDqVC2CYsHT4xKzwXbDcxJ1UC2zoQ1oMParKjfgXxC1/+vab097cbQPrL8/CZGrTyhQHhGOkwyTIESlc0Oqt5rW2r5yOqg1jIs6nYhrmCc5sTVIsDveuDALpZzBZtCW1T62PhkuQclI2YGph6it5b0itzrj8zKe3QOIiWscKYUuQuQ1DGaTNxeouK/aScAvAeER6W1obAR/AXnYGtWRQ/G4MPll9ncNVyuXjhcuTcszEB0KRB+UjzsGt9rk1usQGVs8Ixo5fDW2sbDteilQNISYVumrZEoIHltLaKGXJmqs6afg5fOHNXk7jH3ITaaJdv7x/PI/7Ynrpm54VAbpaMBPDlC74c8t9aWGZVn3/5aT/UQLiY2bQdu2VTNPNswj4oa3oMOAn/33Dg9oDoPfo3KPMBJjemPFOsk+cUWV+cfiPCSVdQg1f0zY2Esij0nu9FbXSetjK81abS+WldLPCHT5/8RDWrja8MnalfYLstSrgNlne6Kyx6o7gaAF6eKTDm5G7OvvVdvXc13CaIvWdabc+G0Kiu7LvHElfuDn5oIK97CoaoUIFGN5Tz9BPHmizFyuyzUE8wb8P/vyX8L2WTc5KM21oYX3tGyDkZ+txcXHKrWLQQcGrdkEH5MCqO4tl0og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(2906002)(558084003)(6512007)(4326008)(8676002)(186003)(86362001)(71200400001)(5660300002)(36756003)(6506007)(66446008)(64756008)(66556008)(316002)(66476007)(66946007)(53546011)(8936002)(38070700005)(2616005)(31686004)(91956017)(76116006)(54906003)(508600001)(122000001)(6486002)(38100700002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXNuTVo2eEJNSE5KWUZtMFRGRkQxM09FU2VaYldwRUIydy92aWdWZ2ZYZzBn?=
 =?utf-8?B?NEZDZUhUMUpxbU04Z3pIYll1WW9YdTc0NGNEYk5jejh2bjFtY1NGcFRjbXlK?=
 =?utf-8?B?bHRORFZOR3hzMFlsaDdzek9EclpKTkhqc3JWcGtxRHhjd3JmYmV6MWtMWFMz?=
 =?utf-8?B?akVKOFI0Wk9UaTMvUVFLbHF4bDUzSTV5UHNpb3AybTAvSjJveVM5ZUxWK0Zn?=
 =?utf-8?B?b3IxR0FpSVR4U0JJL1ZsS09aZExIbGJBcDlJdUxJUGhiU3owTnpHTkIzNFhs?=
 =?utf-8?B?REMxYS9HRmRYVlR5UHpYZG40MjUxT3NkdkpCb1dSUWZJZkhwbGVXRHRyMFNk?=
 =?utf-8?B?TFg4cmF1K25kTEoyL00vdDhtaWpGYUVia2tYY2YxM1RSNDdxbW96dWZ1RG9D?=
 =?utf-8?B?enRIZlJ6dlF6dldmdzRaYUR1Q1B2aEpvNDVaMENldVdXdk5EZnpjMDlhT2xo?=
 =?utf-8?B?SDBqNFRBN0c1bVBuOVV2RTVoRHphZ05kdW1UWmRQUGFsaFJwTVprNEQ0QjZ4?=
 =?utf-8?B?YXRkdmpoeFhpQmRIOEg3Rkd4RkxBT2FJZG83VStTMEpwbHYyamJZQ1lhZm5o?=
 =?utf-8?B?RVoxaUdJRTNkMEp1K204SUhLR2owbVFZRUJERW9qSTJJSmQ1ZytFVnBuMTk0?=
 =?utf-8?B?eWh2OEpvOUNvMnM0L1N6cEVKWit1TlphQ1VJOHVZeDJhaVVrdFBIUTdhYS9M?=
 =?utf-8?B?bkVsRnhVSC9Lby80eDZ0NCtnYy9XRUorSWFkTkZXWTF6TFc3YXo5Z3R3Z2pq?=
 =?utf-8?B?RUZOR3lKQUJaU3oxUkhidEpEYldIdFVnaktxMHFrWm9VdHhQQTNRc2Nqdisv?=
 =?utf-8?B?WVlLOVFVNnhPTGIyWHY0NlVtdDZiZU9xdFRONnpnRWYzaUhPZEh6OUdQcERM?=
 =?utf-8?B?aitWVGt0L2JLU2JIeS9DRlZvWEUwbDAwbXhrcVUxQ0JBUXljanFqRzh3MUww?=
 =?utf-8?B?ZDlCWmRpeGRVWU9oUGh1ZWJ2OE9meFdySkg0WlJHRmpnejJaZlJXVHk0aXF3?=
 =?utf-8?B?TkxRQU5qVFRWUGFJcU5EZUtuQXhxVXhjQ3pmK3NRUGh0NDB1MjllRVZBcnFP?=
 =?utf-8?B?UmhadXp6cWl6clZmNDlyQy9tZlh6ODhSRHA1M0E5QUl5OXlrazROblR4TzJv?=
 =?utf-8?B?OElsTkplZ3RaVzJRZGVNcm1lOEkzRkZJWTRQRlduMnVUNGtGUXJkQVVPWVdF?=
 =?utf-8?B?TXlsVjRKbzJaU2dSMURCZlJXcFAxNWJRNGRURmNaN28xR2pBcTNzVmZwSEhT?=
 =?utf-8?B?RmdZaW9EcDA0WmlveWgrTVRSa05CWkRHT1pxUVFpL0hjSWJERlloMTNvejEv?=
 =?utf-8?B?R0NYWm5QWjB0SkVMYngxQ3BxTVJFVFJlRVRKWEdjSDVZUWdKMElnVWlxR1Ir?=
 =?utf-8?B?V1ZzZVZxT3IzU21OUDBpOW9YY01SamdOS0VWQUJiVXh0M0lkNWw3cmdFU1hL?=
 =?utf-8?B?WjRGV1FTZ0pxK2dtQ0dYQWdiSUowUWNIbUs1dG9DbHhpaktkYkgwN29SbGlk?=
 =?utf-8?B?ZnFTOTFEUGNrWTQ2YkZ1Q1E1ZDhIcWRDaUFBWDQrUVUzcURkVmZqRUtyU09w?=
 =?utf-8?B?UFAzYWRSdXVjak56SXFrRW5ZWVJCaUtzYyszOVk1S21qdlRQM3N2aU02UEht?=
 =?utf-8?B?NUJUT2gvV0NZYXBTY0J5bjFWUU9SQ2k4bVFnYjNSMlFLOGRNMHJBa3pUSnNK?=
 =?utf-8?B?NFZFaTFvOWNsbFlzNU5xQnhuSVdUaDI5cExqazBVeGs1ZHNFLzRIUjFnbGNK?=
 =?utf-8?B?UFA5bjUyVmp2ekdPVkRhdnkrTVVYamhqci83Vml2d2NlMklvUUhJcGNZRzR4?=
 =?utf-8?B?NmFXbHpnclVOR0tuUEo2QT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0345DEE9F0F55845B7E22406B52FB2BE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5983739a-5dfb-41a7-5df6-08d982c65da4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 21:24:33.4894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMxe9kbjerSK/iD2Rgr5VLnQJii4KNRBSmbmIAbtOBOmMR28EE/bEtA1eLYJ3QUSSXTVTUrIt93hA6rYSgYtjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4705
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8yNy8yMSAxMDoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE5vdyB0aGF0
IGJsa19leGVjdXRlX3JxIGRvZXMgbm90IHRha2UgYSBnZW5kaXNrIGFyZ3VtZW50IHRoZXJlIGlz
IG5vIG5lZWQNCj4gdG8gcGFzcyBpdCB0aHJvdWdoIHRoZSBzY3NpX2lvY3RsIGNhbGxjaGFpbiBl
aXRoZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2No
QG52aWRpYS5jb20+DQoNCg0KDQo=
