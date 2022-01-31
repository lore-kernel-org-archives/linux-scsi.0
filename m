Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F40C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359275AbiAaLcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:32:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:65175 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377760AbiAaL1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628427; x=1675164427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=MsuA64oPThDZznxPiJYlXnU+h63h3Ca1kIi0H1liDtei59Y3XSc4QEJM
   k59lolnwh+8MAW/QnyTu1sqZO07GeWWrmTzpeiwv9yTxf6a2/NkeW5IlK
   hpIrCACUXtmfJrKENVwSCbl/gNpeELHn31+PibtC5p7umgNORLsqHAZKO
   eVXuA49Bb/xybReiD/fvRhmc+B61jMPFp3veTCPec5M29zP3QWGPCxUgh
   iQJ1LSOLa6yjl2WXhhcLExpcvYDcOAy2bXLhjg+B35XzTrF15VhrM8f3C
   AuflbijmWD35D1pv0u+XDMH05dCfp/0s97Fb1dP6EtLtk1mtKiyqbnKwO
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190746324"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:27:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiFbLyJjZpQ2Cr20GZeTijLve26YCRl+f3m23VDHj6rmB+qfneVV4ZHx4hqd3UWIJLb2IXQDhpyWUwHZxYj0F4BySndlmPdFeBu+KBbNKn1TxyyefJQJAxaS1gR4gtt0MM8PGjn3/uIBhbXQnYjyUb6xOUD/fmUoGEzoownoAm7eUQx9fzIT5pEgGV/GJ7bI6qX0oyhHONwoMUoLp43PE13BVGc4jat/Oz1shfdFI0NvVRZYsNpDwg2smq+J12C1/fjz2RgWeubvqChyux/Od1UVitl7tt4UA6Ve0KfKCeqBkC8vZbxVXqXgGwBzxHKqeLpFAiPnscSTc1teOuxbiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=cnnchpFejbC1wsU/5wZkCxQfiLmHtDIHg0804wZcdOcu8um696jWLUG5jgLcQPthmhCVviREfuYojNf589nDAS1kLQvPGHJJaQxDoPnqsN/IKCVNS1aFfFZiVAORJyC4wDZ1yoCGTW3t74LrQBPcLYS5tmEu4CYGtvU8j6MH9wq22k3zoaBduPFBq1OQnmtEBLmQcWU65MoAP9HjgQYVH6BlGZo+zZjXQCdVNzHzIok7ElFYE4eLaIxKtuqLGpmPp7fUxQEjHzkswDn9bKmt09/gDECdDGQGxpfhjjrS/M89efnWLMZHZU0LDONIi1LgcBCLCwMNKDgL/ocpGGiyIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=FtB6MvbOtmbG1qwXHohQdmUJxt1AYDcVnlPaKAQqGiGQ9Ch9Zy7qyZ/ItfgS/T/nbbAo0NvLWMhOp8r7I6QgMLRstx04PnpwN6gDBi2jVM9h0tlAEqO52/9aZNTGfqcXWhiHTPl9boG3CjvJGxpSMI1+dSXJNBc33+iXdMTThxc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MWHPR04MB1185.namprd04.prod.outlook.com (2603:10b6:300:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 11:27:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:27:04 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: [PATCH 27/44] megaraid: Stop using the SCSI pointer
Thread-Topic: [PATCH 27/44] megaraid: Stop using the SCSI pointer
Thread-Index: AQHYFJV9g2dIFLw2UUiYoSQdlKMstax9AcWA
Date:   Mon, 31 Jan 2022 11:27:04 +0000
Message-ID: <84127493c964aa1d63d0aa7b929b69e9a04df03d.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-28-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-28-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e039525d-095b-4fe5-51f8-08d9e4ac9ba9
x-ms-traffictypediagnostic: MWHPR04MB1185:EE_
x-microsoft-antispam-prvs: <MWHPR04MB1185E11E0324E29AA600434F9B259@MWHPR04MB1185.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dxSYY2tU4obwGqA4XPhKKsFjCyFP7wJ0ctr+dTtKfwA0YwVzX8ymNGRydclMWVyvfoNZuVtJ8Z+PbLviLjJH3eDStsyHyVMvQzhrSWPuvdqmb643j/Bylc5nePG2H79r+O2JgN4O64M8u39uYUGBqIyoE6g69rhlWQs7rFWwNYdvvpkTTydmCye03+5aHebdpbI/y6BKzSrz1OfWFQ/uc6BEhL3EBiT8WHvl0vGnTfrucsFJzKLz4ehuOhrS9M6ULA48DZ4ZxfDMumJfuYOAJkQaFOtcda7c+9hw17v0ALkQKcJmfsNBxH6fOOAoFBHeGYav89BzXf/VndtKGxhr8OokDh8+UigDIUaai62ERqDYq6Y7eXsYD7VhZVK+QTjoQNHdxKesuRCKrdfZNuray7qoEBHuMZlVusqqpeP2/tFKTYxCFZgfHbDfYDYz0JbKPbMn49Gb8a3A0zwEbIwaMtFYEZ6iyhGwYa1XZJFUcugNP5nKtxulM/8hRo1flDKkZXW+DvM80OjoTxP/9MmlyxBwI5w44P4ntIVLz2mer391Uc/91tDHXIMkGM3j3+mUUV91MWdAHMjJ2GId1DnG6+ckCFd3CIsG5ZbcUVKGPIUarKdmyV65HD8G0qMq0O0QYmP+x6ClcC0F/+snHOzA18IPqll3lKqxfqlSNZiY1DMsFLFnc0rPfcEVlr9EypNeadUgrSwSMy3kvkwigDqbqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(558084003)(38100700002)(86362001)(38070700005)(122000001)(82960400001)(76116006)(64756008)(66476007)(8936002)(66946007)(66556008)(71200400001)(66446008)(8676002)(6512007)(4326008)(5660300002)(6506007)(508600001)(6486002)(110136005)(91956017)(54906003)(316002)(2906002)(2616005)(19618925003)(4270600006)(186003)(26005)(36756003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGZSZURndVVLY0dwTmdkUWtQMk9Pd0NaVFZtQm9TWTE0UzFaelNnT0dsbTl2?=
 =?utf-8?B?bmxFc1lUQVBGenh6bmpld1B0Umo2VFlEbGdoUU5maFYrb1NXZFpzc0lKOTBv?=
 =?utf-8?B?VUk2T2p0YXZJb0FwdzVzcjNxWDhxT1paT3J2K20zWjF5Z1pBaUJqcElmVlZX?=
 =?utf-8?B?NG92ZUlxMEwvRlplRzJxTWJvYnNWTlo0VGl0SW9jcUQ4THROblNBSVRBcVZm?=
 =?utf-8?B?Uy96OHNIdllLdnloLzZVQTNrQUxwUkUrbmJTWS9jOHFBblhaUnNQQm9FRjl6?=
 =?utf-8?B?VTh4RWVyb0wzeGRtSXBkazFxSWYwQjR0MUlUTDNNdjYxbkdjakQrcUsyOWxh?=
 =?utf-8?B?N1ZmS1VhdE5qZ1JMOWpicWNUY2tWK1JVU1R5L2poeStobG9Ta3JhVGEwbnFO?=
 =?utf-8?B?SU5ncCs2QUVMbnowZlhmZVE0NnRLNzZHczZWYzlZb2lxcXNZZjF0L2VHRkM4?=
 =?utf-8?B?Q1YxbzdrMGdIS2k2OTdKQksxNnUxSEFRRzZwZmZSdmpSeHNPZUlRU1gzVkpY?=
 =?utf-8?B?MW96cUNNTDB4RHlRcmE0eU1FR0d1MzdFcWdDRmVIaGxaSUx5UVNRNmVDVXNm?=
 =?utf-8?B?M1krOVFXcEJWVHAyR0V0QUg0WnBIbysyZGV0Q0lOWHk3VnVsOURRdzM4M0Vr?=
 =?utf-8?B?N1N5ZFVwRTg4Vzg5OEVBeUFhNy9LbmxQeGpwZXQ4SjhhSytENkZ5UDFYRWNk?=
 =?utf-8?B?ZHZBd2J1akNETmJRN2JkNmJTN3k4YXByN01HdjM1NzkrRnhFeHpEZjZkZVlB?=
 =?utf-8?B?MmoyQjVXN2pKWlNLNThqUUd6T3JWNnNRU0NpcjRDVk1FWHFRby9uNkM3MXRR?=
 =?utf-8?B?bjBwVGdqWWU3RDM1eXhxdU0vRGl4NThVRlpNOEtSVWdtWEJxbktPYTdHSjM4?=
 =?utf-8?B?M0JJOE1pc2MyV1JGM3AxdXIyQlBvZzFDVzlIVWk5Q3JabmtwRzFiVU1PYitM?=
 =?utf-8?B?V0Rvb2NJS044bThBMmljekhzVkJnYUx3dXlWVUdsajVvN01HQmtZZFU5TzhG?=
 =?utf-8?B?RThuNGtDOHhhUDBSTnpRZjBxNGZ1WkF5bWIxVkF1cTFabUlycXdTU1gyaVVN?=
 =?utf-8?B?cjVrM25Hd21Wd1RBU0V0T0FveC9YMERpM2N0T1FLNkEvMFRwdTBZdUltTDZF?=
 =?utf-8?B?T3A3bFZxV0NXUEJOdUdtMjRrQzgzdTB0QWQra1QxYkJpUEJTOEt0TGhKTVFn?=
 =?utf-8?B?bGJQVWhUaEllNzBPSzY1WjJCRHo4WndDSUpEclc2K05LSWZTSUtrOU1hcEZY?=
 =?utf-8?B?M1VnOWhsWnZZcVlkNGZSM1dGQVdGSWd4U3BFcHBud3YvV0RuaFFLMkZJajVq?=
 =?utf-8?B?c3cvNVBoTjA5ZlBzaGFxbzJEZC8wUmlDNFlSdnlHVmk3YmNWL0QrZ1dUdDNG?=
 =?utf-8?B?cHZ5N2hGU0NPMFRnWDF3QnY3L21OdzgyY25qRVlLTDNnQnF1N1hFUnFmemZJ?=
 =?utf-8?B?TjRZY1RGMHczMUg4dDRIZmZJUjVPTVBaQXQxREdwNlhiOThhTWZmbndqVFpB?=
 =?utf-8?B?dUNiOVNaeFJxWVBiUE5OOE1zYW9qQmplWlZvMzloZGV3U2thN1ZzSVlzemdQ?=
 =?utf-8?B?UnNjVkIvSkl5aytBcHBkajhpQi9CV2Z2bVVuM2tQN2ZqZ3JnR1dJNHlFZ2Fv?=
 =?utf-8?B?cHBjU0ZzS3R3c21aMlJLTElzTEdQSjYxeDZLeHNyL2c5NHhzQ1U3NlEvbURN?=
 =?utf-8?B?K045cU1PSVZpQVZ1WGhFRTZ6YkpQQVB5YitSY0JCK05Ec2o3ZnJTdXdpeTZp?=
 =?utf-8?B?RnhYQis3MTFmMjBWZTkxNmI1c2U0NTROUVNaYnF1VXo3Vlh1djRiSy9aY2N1?=
 =?utf-8?B?dHhaT3NDTjBBTnFpNnNnZjkwc0pxVWZ4QkEzSUxLQS9MeVUvN1hwWTVqOUh3?=
 =?utf-8?B?NlRVbDR3bEZ4QTBFc01BUXd0ZTFQRXRIb0pwajVoMTBIZTZ0a29lZlNVWXBh?=
 =?utf-8?B?N2xKRW9NSEFUcUV3Z05qa0x4T0QrMVphbnhnTlR5YUZRd0RIdnJnM0N0cHJt?=
 =?utf-8?B?TndTZ3FYeTNFRy9xVVAyR0FIQjNEdEdlWDF5dlVFZFFhNzNpcVZyUExZeGNm?=
 =?utf-8?B?NWJSOE5lOTJ2MnFpblZsazVIY09jTW5heEY3R3NQSXJpSWtiTWtqSjJJcWNo?=
 =?utf-8?B?WisyUDZ2YUVQRjRHSnRQUzlnWVhxYmsrTzBqKzk1MTIxUHlRUUswbGtWNHZR?=
 =?utf-8?B?MklGZ3Y5dE5lcWFzY0paVzE1KzM4eU9wTzlBQjF6VEdBTXNwQUJ5QjQ1Rmk0?=
 =?utf-8?Q?0MtBh1SU+3HoQ+Q/o9ewWHlh+wE0In/uC6jTAVauf0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <866D1A10D72DED44B7747A20778A9C46@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e039525d-095b-4fe5-51f8-08d9e4ac9ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:27:04.5302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3YobMxc3SnBfamgPBLVcwPjUo5MDhmW2g8hZ2lSKg9b5oQLBP4a1U8wARuq8kOhFP2OFYYy/JzhAj4i1QgtuWdWld880dTrrbZ17wbD/Q/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1185
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
