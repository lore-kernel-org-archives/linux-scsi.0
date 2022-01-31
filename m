Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A26C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 09:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiAaJzi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 04:55:38 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22674 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242276AbiAaJzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 04:55:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643622937; x=1675158937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Xzw65fb2dEvVlDAfwTx6FZF86PsrndTg9+tTvQnwdoze8h9h8BOw20P5
   04QfvtUFZealVDHOPX3Hlq7JvL12L0RmB0HflLF9XZQro2K7Np+cTz45T
   5BRhzMldpZ3aJVkcKXw51/tEkay+uuRx+ro1kafeg4+wrBGYC5kA79XHN
   QUL85NppNPWdX2DVpdV94rPuUsxHN//Kom4tDzLJhnfJbuRjaCbiKawQL
   dVhbpdJCG03b7ElShXhvk8qy/vuqc13KpH2yzUFBF2GNQNY2HyVn7SWzp
   oIwoqpQ5k+DIM6VubZ9hSChW+q68r+dzbEVqjCBbRIedwyHhSxgXkaTyR
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190741050"
Received: from mail-dm6nam08lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 17:55:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANlddsLwhmsoLiK9qn6hVlYwtWIOb84P4ftNRO7792wRhMjSQgQuGfXZmL+akdUH0h4/Ohm5js4WWOR2wzSLwJqTWO3/m4gAPzM3mFKycFxPL0gieIKIFtVpoYyDRpUrCbGfrlyk86QWAveCJiAhCDW7D2oHORqhH5f9s9Hp3ZJ3lZ8+iHYSEqIWLXScgCXIC9ByjqK6Su0hxxyab0mDWL6VKvgXBz9bkZLWJCyFYNsUatRKW9y2wmYbbaqD2yZkZOqrFkRh0Uu+Z+wl48elAz8m+U6/4YKfF7enlrWrHldTnvOIrxbG8yXjfD1fYjVVH9DjdEecvoEjCkF299QSXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=a/xoKlph8ubQtvBkIBJuQQkexLJAZ1oJ1k9dmbrje10ZqglBL6GmrDJ18pBpJQ4fZ+9KIIpZFWqnPbVi7YLLkvVWU8BJFchtDrPHXqf9Yz41EH4mHH8YcWLIbcfR3AiLtX7agcwDREK6cIlA+BeGXXQCzxM4jgtIXpI0PnyROqZjYxXSCgacqUA3sdTcgl0ARguamCXC8H8iRjcIhi1ZDGJzwze7IbpkiIwwrZHD6yiPREuVH/KXSgBA9zBVni/plStOnuMb2lWdOiluZRdWER/dF8jIU8DPvPijC9PGCOdt5esNCX51QQCbtH6fixXSOCO6o8sPOmmXXLGmtvhatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=MvjPC+rHhVgh0a/kr/rAHsqGflgmfFKNSXPRl1SWOI+Y4PMVhN6XuHQERZXvYUdHEocIu3jiHsM3zLHeakgrRWrTaOAvGzF7QGckBK9F87hUHDYtaKTzFE29ctBvtGTJ9qpaeucWmC3X1KNVE2j1QxNpzireXvZOSyGvBcfvjIE=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by CO6PR04MB8378.namprd04.prod.outlook.com (2603:10b6:303:141::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 09:55:34 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340%7]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 09:55:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 02/44] nsp_cs: Use true and false instead of TRUE and
 FALSE
Thread-Topic: [PATCH 02/44] nsp_cs: Use true and false instead of TRUE and
 FALSE
Thread-Index: AQHYFJVKCZEDRCOhPUy6o0g5kCgqm6x86DWA
Date:   Mon, 31 Jan 2022 09:55:34 +0000
Message-ID: <1acd0618fc753bd5d3443e03a11907eac6ad3abe.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-3-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27b6a33a-5517-4472-2b23-08d9e49fd362
x-ms-traffictypediagnostic: CO6PR04MB8378:EE_
x-microsoft-antispam-prvs: <CO6PR04MB8378DD369FAE466A41B435499B259@CO6PR04MB8378.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: anG+eN9spLB7sxx0YY0jH8JKo3mGtQwCszGHn7kkZ7PQ1U2oHMTX1C88zyM4jfikd4I5iqRfhXpamCf9d9R4wKMzADQROjGRNyttCaFKSzAdVtniglRsMxtItagRtwSlug6OIQb+LdrTE41lEjLQoaYVie2WNc+2BcjA1/v/O53I5cjG6idkDTs2Pe39amzIQn9h3r7ejDbS7R/uAyp+cTh2K9aRWadiXYLHxK08MmfCxWqw69YcPuN8IjhdCM+L9o7t4VtuSeuMnU4ow8HZ0MLLgBxwoIAVj+XmQYeZ/D6pn4+iV4sekuc3JECKd09rrcUu+7q3L+bzzQcvfhOD0fTqapmFF6EvEsFuwwY+6EoTthh8rk68G6surl+syKYP2hibWE1OEFFlJ/Vchfo/wW8Z7Eaisb4vMquhwXfwulzp7fwnjATWfGlJQEVc3aqt8uM2Zd9ycdnk1i2htPZgWwMy9mbWpYlzEEyt3gj/NoT2v6M/qRmTgUgIxR8DE84pZ5snlN4xRu8ZNitI2xv2h9q+h8Y7rPA/HjQVLKEc1F/eGbZu1bqwU2Y7o67g1Ybq1sad4qAmH2FSBs1iTKOgcnTGxllhsqNSOZOfenAimHCercd0ddsEM3WWFNoC14JKrBIS3XCoK301EeCmLPlSf+4AYNk59E0jx+alR2K6+TV9ukpHjReSpOD6jocyrHirPzshXZ3KizeWWO5FZPlrnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(6512007)(26005)(186003)(19618925003)(4270600006)(558084003)(2906002)(2616005)(122000001)(66476007)(8936002)(38070700005)(86362001)(316002)(91956017)(38100700002)(6486002)(54906003)(110136005)(71200400001)(82960400001)(508600001)(4326008)(64756008)(36756003)(66946007)(76116006)(8676002)(66556008)(66446008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkZBRHYwdFA3RlFEY1RuQmpidC9wRHJJcDQ0bzRNVUVqaUZ3SVQwV3JLQllK?=
 =?utf-8?B?eUxKRlJ5SUdSSWt3Y1QyMzNFNjd4bnlaTTJDeVprLzBqSm9UeCt6YXNyekRq?=
 =?utf-8?B?elZoYkFGM3hmL1puc1Fyb3pUR2lTOWFmaDJVUkptK2Z2cFZvRjBYNU1yOWFq?=
 =?utf-8?B?czJzQzBpbGxZdThyYm9yR09NN0l5aDBhcUhPbFU2N2plVmRyTHpVeXo1aHJI?=
 =?utf-8?B?QWFFb2FuaGtUcVlabWwzanZ1KzhDdmJhekRrZk5pTHVqZTRBem11NjBLNDVX?=
 =?utf-8?B?V0d6L0F4b1hPZzBDUWV2MmlvQUpyaDdlOHRSSkx1bGVzWWwvdmdLZWxKVGtO?=
 =?utf-8?B?SFNXYlgvT3JPVXNmWHpQcURuT2R5U2hvMUdoYnlOcFdrTVloOGVVeTdBcFZY?=
 =?utf-8?B?TjJzRnQ1V1FuL3phK3dEbUhOUFFjZGNoSVd3Z0ZRVU1KZ3lpOVRRc2pLc21J?=
 =?utf-8?B?Z0pnTDNnVVI3Z1ZaODBJQ2JYZ0dwWnBaQ1JwRVR0MXBHeTNWT0tCMXBVK080?=
 =?utf-8?B?dzMrOXZQRmZlVjdDeDQ1dFl4Vy9ZU1ZCZUlpUVNZT3l3YmVNVU9XM241VVBz?=
 =?utf-8?B?VUVLb0FJQ3ZvVW9TdXVNd0xyekF6S2w2WnJYRlljNWdzVFF2dHN4TUNnWGdD?=
 =?utf-8?B?Mi9Qb2x3UWNDTzNFdjFLNzhOMFFkUlQvZ0hVaG9aTUhKRnBLZkx6SjdBMWtX?=
 =?utf-8?B?Y1EvUkppdHJSUzBmakw2Qm5wWFFiTitpR2psbTVvUTlyYlAxUHplRXBFSVhv?=
 =?utf-8?B?dXdxZnZmTEJ5aGJlL2lZMWIyUnFTUEcxa2lpcnhkeXZIajFjclUxdkZldVVI?=
 =?utf-8?B?dCtSN1YwckFEMVdvRUxwS2ZLNHN4cG00QXpQU3ZJcjkvSEhKZ1RYZjJTK2VP?=
 =?utf-8?B?TXJ1bVFmYUFQbkVXM3VjRnVvdEVqekt3K3k4cE9aNFNseldTT2RyaUZQcU9N?=
 =?utf-8?B?MlRJdUdzLzMvUXpYa0lzNW95QlU2OFFRTjJEZWpjT3JLelVra2NMdVp6OE9m?=
 =?utf-8?B?eXBLKzUvZ1ZMdVdnYnZ0NlhRYmF6cnUrb2JWUjhFZ2s4L3FjeDFmVEJ1cVRS?=
 =?utf-8?B?Y0x3QnlhdzBGTWhaM2ZKNWc4T21WR2tFSUc5S1NyanNnVWdnc09CenlxNC8w?=
 =?utf-8?B?QWtXZmV5bHBjRU9QRzE0K1BCK0crdWx5UjA2TDdvSUZJRm9JWGNHUzdBb2hD?=
 =?utf-8?B?Nmo4SitzYmh5NHcydGZDemt1REtUSjVLcWFsRzJBRnQrUUxqZDViT2hpYzdq?=
 =?utf-8?B?cmlLQUVCYXlBS1Y4Uy9yS1djRjJid3RRNXRrWVgveEhlRm0xZXdXZmM0TEJk?=
 =?utf-8?B?ZkJTZE1JakkzcE5RMk5IcEtJNS9CVDZ6NVAySHhWeklkek5sYW1sMFU0L1NP?=
 =?utf-8?B?MUt6RVZTaUdMTXBPUlRnMkFEQlIraWJBYTRpMU1QS0kvNkhKanFtMWJOTHZu?=
 =?utf-8?B?MUVLaExNa053YWtaVzhRSW1SZm1nUTZFd3NjM3FNcVNXWDlwN2g1SUxJTnYy?=
 =?utf-8?B?VUtqd2l3eW9xMjJmN2pHaVZDdUVWMWNzWlRPMjkzUzJZdG1pM0lDZVc2WGJx?=
 =?utf-8?B?Z2RLbkdGajhrUUg3WFB6VHdzL0luMTJFeUNjakkzK2t4dnlJV1pyZnhtN3Bo?=
 =?utf-8?B?OFVET0dHYUNIb0VPejh4NXRZblA3Y3NTMGo5MFM5UmtvT2RKNWZHTThoVWlE?=
 =?utf-8?B?Uzc4VGtOWWpJQmR6TXZ1QzdvZElaWFpxVXpOdnltM1FzMytKQVJ5V3ZBVkVX?=
 =?utf-8?B?Z3ZYVldoZ05QbXdHeER2KzB5OFlXbXN6d2J4SDdNeWtCV0JLRlh6cks5L1NQ?=
 =?utf-8?B?UFM4eEF3UkJQbnZtV0xnbktlRnRtblFaZGF5N0NZT1YrRk10OFVrdStVNjVR?=
 =?utf-8?B?QlVabFEweFhlS0tHYzJISmtrSnlaZFdTeldrc2FOK2hheG5YQ1dpaXFDc0JX?=
 =?utf-8?B?NGpYcU52ZU4zRHNWOEJQaSs2clUzbXM2R1pPMVhOMDV2RE56TTBZVTFIcUY4?=
 =?utf-8?B?S1JOaDk5OUFnd0RxRnlCUHJoZlVEd1lFYnF4aTIxcWpiblZ0YjRGaFdEaVEy?=
 =?utf-8?B?cWhBUU5KTUhYV1FjV2xucmNGZVNwVU9SdWhPcjQyMzJXbFRlS0dWRW1sa3U2?=
 =?utf-8?B?WWxWd1ZJTGVJN1FDVXdtSkxKYy9qT0ladm5PVmhTU3dNT1RPQlZRMEp0N2c3?=
 =?utf-8?B?UHF5andZZGNhb1ZMMEp4b2ZHNjJ2aGlDRWloNHBLdnM1UDJkSHBXaTQ5MUpL?=
 =?utf-8?Q?2UmA87n20Pi3dASH9ouGYcFIaf4wG4tiMVWEeT/O+Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98A3BD5668541940A8979794143DE787@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b6a33a-5517-4472-2b23-08d9e49fd362
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 09:55:34.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r73/smvItkLxrzM5QB4X6xJWa1aOXifFQ2XdfalGEzBtv5bv5royuNzAU2fGwsFXTvBlJDYjQiWqhPURnoOrXfRYDhUpU485s4gJ2je3m/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8378
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
