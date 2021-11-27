Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F658C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 09:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353212AbhK0JUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 04:20:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24134 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353211AbhK0JSP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Nov 2021 04:18:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AR8tAY0004165;
        Sat, 27 Nov 2021 01:14:57 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cjv2xbna0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Nov 2021 01:14:57 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1AR9B4Jp003188;
        Sat, 27 Nov 2021 01:14:56 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cjv2xbn9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Nov 2021 01:14:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqMJ9y+Jeu74rW9ZNyWod0iiaELy5yMsx4hSPjppFr/sV4e/jJjLOzXwscAggjDNqpOE75hR/CGLMK4oZe5SZz6LgbBKW/xuXpQ19XuLJNMMa6l1IwyjWnJS3Xvfr8o6nwSQJmSJvhLXTgplzNGy/ph0XliWyhdlhSsW4hhlC1c3hldfAIQaduAgWBKYRwBhiByKcxzEUou2BunuHv8ZWE25el4F51UEqwdxf1An8RSSjXFyuQT1sMZHYet25FPJhpAmQEwbwR9T91VF78YRE4nCKdIvIL50frrpsk+klV79bXf6L4pX9PplMSVxMNBpihZQYhCQO4dE8VlcwN5LTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/+dJkkJHct9ldjKHyAbX3KyQ4JmGk5lmKhW6+p8lcU=;
 b=ltlD1IM/Rn9MBOoqCYwjO+WjeGHsVXK7wFCtGSUR7nd3lq2Sp+dV9NkQ3wmnsIqh3FKkYH9BT5VVhqLgnZpw0JNqxbd7mcxWR7q8z8XDuKuFr0Q0+Cr89xhHjVHVYxMp0KsqT4d+2SJgh5DICW6QryLUIJf0I6vJGydLlfTZ1EfQWAoeSqhj53U665iDYVV1JHZwLAkFWH1PBmTlF5hhBQImvYWN53EmS9ue++9DZnlLiU8AoEFFLPd2+3YSHlIXqZNUtSINVqRtzJLuvZK1JOjhXClEtd62sFkZJWpgLNh5l8KTf4ju27dmu3KZnBqBVXyDM5dK2ayPj9YZ/wu/ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/+dJkkJHct9ldjKHyAbX3KyQ4JmGk5lmKhW6+p8lcU=;
 b=mp8lxmqeIMsDJS2yW/NgG7qvFb6HeCpixcPurvXNL2ZKC/X1sqbVh5CF3N+Dnib05kVhI2DYACS8K0dnscnt12KbyL+Pr9060MJ8FtGrN4PcYk2Vdox8tgAN3fv58owZcyYciFGj1/sseWOL7y8YXLBj1y41+Ay12pDS1XMzQiQ=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO1PR18MB4697.namprd18.prod.outlook.com (2603:10b6:303:e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 09:14:52 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf%4]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 09:14:52 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     kernel test robot <lkp@intel.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:QLOGIC QL41xxx ISCSI DRIVER" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page'
 variable
Thread-Topic: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page'
 variable
Thread-Index: AQHX4oSo8afFlgxayk6RzvRV857OjawVgMlggAFaUYCAAD1ucA==
Date:   Sat, 27 Nov 2021 09:14:51 +0000
Message-ID: <CO6PR18MB44197657240086A7B674F00CD8649@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
 <20211126051529.5380-2-f.fainelli@gmail.com>
 <CO6PR18MB44199C2AE98B79EE9D46D679D8639@CO6PR18MB4419.namprd18.prod.outlook.com>
 <be1624fe-f1e5-f008-32e8-af00a36e284c@gmail.com>
In-Reply-To: <be1624fe-f1e5-f008-32e8-af00a36e284c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ea78425-e21b-4422-c192-08d9b1865ed3
x-ms-traffictypediagnostic: CO1PR18MB4697:
x-microsoft-antispam-prvs: <CO1PR18MB46978EEA6E88FE2C26EF2AE7D8649@CO1PR18MB4697.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQ9wCLbN8a6JKS2n3+PEWJygGgvZRBQLDjaXSMTog2SE8DcJy3WIwK1LVVfi9qsuKfpGkWo6jgMsAIa6RmqSFnDZVke0HwewzihPJ/TP2uQ/BTlAGh4eB+eZHxosrgtCE8IMGY2IBWodC2eDvL8YPbvmr50QXgvk0ItQsU/GnMbL9MNaUrvg7CDWK5q7bVAxb64Z7+P/IaeMjXZbd8qOsFkOOIIahyWTxJazcEb9LmHRw/jBoSg8qodDW8m0kCw+ftpjZieWA7KDlTDht5Zev2L/HSiuTe/o67sRot/nMyIOgMOZ2NNUQjuobx1p1XR6wXiQ1y/xY9zAOwZ+ZFZVteGqzMpmctxA2PaxEOgaMsJocvK2Pez+ilxbie+kNzLMSAhRmzBYgXiJbtMWz5Jka4NFi0vNXoFWQjw8g3LNt5U/k4984ysQgX/SQgeNb8eYrD0qqwvY2nZHCJesQQdI/qMEBs9nV9oBXENWjcHtYiu6DekrHoAAyd+v4olmW57xzAgdB314VKXWsFtFIGPmzo2Yi4chlMqRpJq24dNgTdvKOtPPaUoSXj5hycGkIYdOjuiiv5NSncVXyWwYBLL4NOl0qkHlrRFJV+YvYrDs6WOi/v3FZTy9Qcm4006kxwTvMze3/HbNAm9fLXKq83ETiHOCka3gwgv+aK9BCTPMPVbus/Yn5RD2QjIxA6pk++qJnej4a0E8tAycDxTNO5RIDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(64756008)(8676002)(66556008)(6506007)(110136005)(508600001)(66446008)(54906003)(71200400001)(5660300002)(55016003)(316002)(52536014)(4744005)(7696005)(2906002)(38100700002)(9686003)(26005)(33656002)(186003)(122000001)(8936002)(86362001)(4326008)(76116006)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHQzNlFHR215M0prbnJkekhWNURRUEsreFowZS9TVG5iNExldmUrRkljUmQ3?=
 =?utf-8?B?UUhZU2ZvU3RpQmZVTVFzZ0c3TCtqOXFHbGtjVy91cXB0ZXZVZFpMam52MXNz?=
 =?utf-8?B?WjgyMnprdjM5TXBGLy9FZHdxSU9vMk1CMG1ncWN0UmkyRnpqQ0tWUEsvUUtN?=
 =?utf-8?B?VzhjdkczZS9URGZDVWtaRUVOSVJ2dEpyZy9PRnhnMlA5N25MaVBWMEJ4bzdN?=
 =?utf-8?B?Qno5UDNjekhYempyaHMzb1luTFM3QUc4alZMZDZpSDM1cXpvazJpYmV6NnBi?=
 =?utf-8?B?eFBScUFpRE9iTUpRRyt5VkpGNEVDeU1WRTd4eWRNSVM5KzB1a244QXp3WVJG?=
 =?utf-8?B?RmhmWTdhWDVIV1BKOG1aZjRqNVBSZUFPRkQwd1F5bC83RTQ1NUhUZWVBb0xB?=
 =?utf-8?B?dlVQUGhCenpzcXgxbE1nOTVBWlpqNUUwYkw0K3JERFpCc3NTajZ4a1I1UkRw?=
 =?utf-8?B?T3hGeEt6d082RjJnSS96Qk1kSmFpblVYMm45RW5rSFU4cks5UmRKL2J4TFRW?=
 =?utf-8?B?OGQ3dkJjbFJpR1BpclNndS96L2VMcndSM3ZRbDlQVTBHNnpRSDlMdktEK21q?=
 =?utf-8?B?ZzNQQjk2eExkZkNHamZrZ0Z0Z05rQUJKRTRmanBkVGp3Z29xdHVIWU5CY29m?=
 =?utf-8?B?bWtOd082T25YSlZoNkdhUEdtUWhRRXp1NWdrcjZ5UGowaEV1TGFVem5Vc0FU?=
 =?utf-8?B?SlpieUlBZVo3SWdYNW0zM0JySzBqWm9TemVqdlRqZ0tpUFJQWm1JZThpQnhv?=
 =?utf-8?B?OWhJbktRZXVhUUhhZlo4TXA2Qkx1YjFQMnAxM2Q2Q3NXeVpNbkJLOUtDakVm?=
 =?utf-8?B?V1V3bS9hK2MvdzdUeStMK2U1MjVVdnlvUDFGcm8xSURSZFRxOXltV0ZwS2Yw?=
 =?utf-8?B?RkdYdUUxRUtGUmJsMUtTbGRUTDk5RDJhaVVCV0F4TVRvNTkzZS9wd3kzZGhk?=
 =?utf-8?B?QWJlK3ozSUNFaTdpVStsdHI3VDNUSHhPV2JKTVJJdm9VRGVONkN0NnAvZFMw?=
 =?utf-8?B?aUdKZ1haTHpXZlJkTktYNVRkQlNWS3hoZjZWQS9EcEVCTHhCem8xVjgvdGRh?=
 =?utf-8?B?ZE0xTlBOWFNKUDk3S3h4aFZveWRsYjc3N1UzMXNKWTNUSk1FL0MxZW9NNTRR?=
 =?utf-8?B?WnEzc1h6T2xNZWVXOFgvSGZQNlBJV21GVTAxSm9kUC9lUUc5dEM5RlBlT09E?=
 =?utf-8?B?NnBiajZ2V0VLaHJneGkzalZWYTFuOXJmOUMrZTFvWUxMWkpDOHphSnBITm11?=
 =?utf-8?B?aXdPYjRSTTlBampQd2NMSUxqTnV5c1BPcEZZUHZ2OWEzVytRUjdoaWcxZ3Zw?=
 =?utf-8?B?bWR2VFB5THJoSVh5SCs4cU8zczU0VTMxclM2MTZ6Z3JTanR5YUpMenE4VDJ6?=
 =?utf-8?B?ZVU3KzZ2SyttT3ZtcGlBMzhyNlhHN05aZU80ZlA4MFBFbUNxbXI3NlFxVy9P?=
 =?utf-8?B?eTVvYTJId1JjT3BXUGlHd1kzdTdXSWxSTng5dXNkWTNleFRqZ2h5Y28wb3Mz?=
 =?utf-8?B?Sk1MZDlUSlg4V2tkSTNWQmpCQUhFYW9EWi9XVTBkOWp5SUFUTHFrVzhqWUs0?=
 =?utf-8?B?ZTUzR2ZEQXBDUzZsemlvWTRkWHhmRGtkLzczN0lSaXlxcEpJYUZQeEdrZU1L?=
 =?utf-8?B?V3RQbEdKMmsvYTNHQ2JGR2VLb2lPY2o1dmlDMDhwRFoxMWxxV1JxZkoxNlhh?=
 =?utf-8?B?eGFFR0c4bHNUdlFsbExqVnE1VnZ0dkRXcUV3MXFqWitGUGhwS3VEMkRVK21Z?=
 =?utf-8?B?b1ZvQzM4UlcvUk41M0NPbS9BYnpWQ1lMeFpieFJlMmVXTTVnam1BM2tuYnNi?=
 =?utf-8?B?OWl4eENXdzBBVzB1bjZLUkNCaDJVZFIwWlE1WWpCVXhtT3ZyY2o0Z2tTeDlH?=
 =?utf-8?B?NVJFUGQ5ZFhXSEFmK3ZIeVBMT0toSkRVZ2JCOHN2VHY2Z0hybXdNUmJQQW1O?=
 =?utf-8?B?ekZOdmtHWkt1NC9jVkhSU1AwTHBNSGhaQmc1NDQrTG8raVVXbmRzc1dmQmlN?=
 =?utf-8?B?M3MwTjRSMUxPZlhheXg5SGZpREErNVhuOFdkK0ZYT25GTlZzNC90WmpxNjlC?=
 =?utf-8?B?d21MbVpTMnJpejQyR2xNMkxaQXZZR2NVKzdPcG5nYXIybDk4cmdlV0tPTWxE?=
 =?utf-8?B?TFllYklQNzVRU0pBeEVqaUpaVDJqc0JNSkhmOUJxNnNTYUtsODdaUk5kVzJB?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea78425-e21b-4422-c192-08d9b1865ed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 09:14:51.9994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2DInNQgWl0pzA5D4I+l80GEJkDXsO17l4Q1RUTVzoTDUJFwaPSQrVLR69oCpGpf4SDQQUVK+qp1pM1L/OZVV5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4697
X-Proofpoint-GUID: 3eCH5EzxZnnnHxmHB8bfemZrqowEk2Oi
X-Proofpoint-ORIG-GUID: VIk23WBDdOvYseParEtDL-5tsquQViEE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_03,2021-11-25_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+PiAgIAlsaXN0ID0gKHU2NCAqKXFlZGktPmJkcV9wYmxfbGlzdDsNCj4gPj4gLQlwYWdlID0g
cWVkaS0+YmRxX3BibF9saXN0X2RtYTsNCj4gPj4gICAJZm9yIChpID0gMDsgaSA8IHFlZGktPmJk
cV9wYmxfbGlzdF9udW1fZW50cmllczsgaSsrKSB7DQo+ID4+ICAgCQkqbGlzdCA9IHFlZGktPmJk
cV9wYmxfZG1hOw0KPiA+PiAgIAkJbGlzdCsrOw0KPiA+PiAtCQlwYWdlICs9IFFFRElfUEFHRV9T
SVpFOw0KPiA+PiAgIAl9DQo+ID4+DQo+ID4+ICAgCXJldHVybiAwOw0KPiA+PiAtLQ0KPiA+PiAy
LjI1LjENCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBBY2tlZC1ieTogTWFuaXNoIFJhbmdhbmthciA8
bXJhbmdhbmthckBtYXJ2ZWxsLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgdGFraW5nIGEgbG9vaywg
ZG9lcyBub3QgdGhhdCBtYWtlIHRoZSBsb29wIGl0ZXJhdGluZyB0aGUgbGlzdCBldmVuDQo+IG1v
cmUgdXNlbGVzcyBub3csIHRob3VnaD8gU2hvdWxkIG5vdCBwYWdlIGhhdmUgYmVlbiB1c2VkIGZv
ciBzb21ldGhpbmcgaW4NCj4gdGhhdCBmdW5jdGlvbj8NCj4gLS0NCg0KV2UgbmVlZCBsaXN0IHRv
IGJ1aWxkIHN0cnVjdHVyZSBvZiBiZHEgbGlzdCBpbiBmaXJtd2FyZSB1bmRlcnN0YW5kYWJsZSBm
b3JtYXQuDQoNCg0K
