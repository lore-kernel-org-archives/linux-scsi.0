Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43753C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359581AbiAaLVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:21:18 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:52572 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359737AbiAaLRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643627828; x=1675163828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=ApmUQ31aJgpsryMcxdfRIAXsgBW7kIpMQT6jrU7Yw7N7o83CIRHO7kK8
   bab0t01Vp1VDI5eZquUOGLY+zbA2ZF5fYNS0bHJ9Nu8exs2N3a262OA8a
   NXJRWiGN5M2AHW/N/OzX6+jWp0mTBzemZX0U2nlWo/cOe2osLdTRA1IQH
   LgTtME8gy/TMCfJD/7Sm9h47VvphW+omNhN8uL9WzOI6YHzbLhIPMKOms
   FBTP8asPuDVt/MOUSqmRu2O9Fyrj3i7xMt2w5f+mfs1cmMIdOHvz06DGd
   zI4X7uM97+Ncut8TQlyh529W7HMsgXVWUjehHFaFNffLqJuusOWW/UiE0
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295878870"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:17:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLM/TnPhSYsJbkIYZio9y0AIyzIaM1cHeyw36+jIca8wxj9J7tDK5b4BFAXJWznJqBWwxwojRjUOazGbROSEHo2k+HxT3Tz3bqmsbF2Al74lDDLzkWk9CVZ/TMmy5QYMWRc+toCZActVwgOPqMiG2psZWCDFGvzuw39qwFObUqTxA27rGe1pCSeKVNAwQdzGOgK7MBJI+FR3qGbkZnqFrZSMvidW7dUaE5Z03WJwamNx0Xuh2vicTvfrrV8IPf27fztL4TTtHUYfp1fl7heMHuxqFsLEd5XUgR/7XabLIV0ofrfQyDIogRDkq6nxkp3U1ilJ9GuFG1/j144P8TsTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=P8w3mUh8ChoLfjVF5UXtkiB1HVj0B9Yzevg9jCIFMadAwQJtjQNbgpNHxyEuJwVszuepZjPZY4vnuxtJh7EpP4Oj4HX8Eq9u6We2dRlcULgfBwy3CedWDioe4oQL1GbCcvzq8svILz0sWgW+aYtxxQ98VVWiOE/DjqvpSHR/zK1hK9tBu0pRA2IotWGJiMqb1uS3ykBnVE/hADGxta2WGJIWauepDb4+6BvdjAJ+8ZFPmBi2tlcXFWKThe5zJAAPt1OuvT6E0lLbji3rPNIhEB1QBEKAmJ+eSDzQD0eDZ9KjZyo4ttQzNqFA7T6gOgLAMJdo98r7yTjWteuDbH1e5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=xEijM3a7PMhLmbOED4zdsGkSzbB+uxa41mxzNPSqA2YaQ2UXCQLcPHW3LQRBo9swS8QnGQa0A164ybNABYsUTDYEuV/dzCN0I2p4aius4PCBmD1i26voA5VkHoAmp7tOy2N7r/kPyQmHYYS8LBrIdpFyo8VAB0hhcLOOUcx6mXQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN2PR04MB2205.namprd04.prod.outlook.com (2603:10b6:804:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 11:17:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:17:03 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 21/44] imm: Move the SCSI pointer to private command data
Thread-Topic: [PATCH 21/44] imm: Move the SCSI pointer to private command data
Thread-Index: AQHYFJVoTaO4ejucE0WGQ1gp78Bz16x8/vkA
Date:   Mon, 31 Jan 2022 11:17:03 +0000
Message-ID: <782ff0da3dfc739a5a04414606f5c0b011693aaf.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-22-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-22-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae578467-e58f-40a6-edfd-08d9e4ab3581
x-ms-traffictypediagnostic: SN2PR04MB2205:EE_
x-microsoft-antispam-prvs: <SN2PR04MB2205617DE055BEC10FA487249B259@SN2PR04MB2205.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzItYcCZ9RpUCAAmek0ZvP8AXmp4xej/XzDCSq/agEqiiFfSyFIwddgSv+OPFSgt49tmaon4X7xtEsr1TppzVTeg4zYi9gFDOFby10wxs6X34hcfP5XMOzGTOFFhPWt9BrAr/gA9MGLaE7RYpmw+s4xaag11HUm3aQ3GIR71y08iVr3FXo3hc/jbjrUaMaMEio5DKBdRZvRVXarVCIqseUqDuItOoPLqrwELtlDAmYWB+RZIkcRg2mPzwRtvNJBwIepVC1eF+FcViUsQOvh8eRRv4ZwbdHsqYnC5+bjnzID1ZPyHmpk6VATqhfF9bFu+NfBbj5H2Vu5Iy0PjA7+YGqFC6XwAmLlNy/qqvkemPFfMXuY0hdpyBwfMYTkbIQESjLMfiH6lmvLcv+CJdCq0/3B2dk8IFzLrCL99MYybwcRaaO3KiZAFKnlQpAgnb8a6DirZlnIfmUTbvFiZCsROToz7Tpqf/aVdecjLe6LfJ0iIUjKW3c3y8WAtB5xvEF0NEes17Q4gCXD23itE+l5F5mibJISAayEfjfC61xDFViw+e46Qb/14dtV98JyUC8BEs0pZPwyuOW7p8S973kf3MOwrAUbA9Y/gR/nBoTMqxDjjnIuuHlBpYVtpbMxH4s2IPUh9fg68sMrkEkqNNKpo+S2VDSrmMxZi4PgZLhqbJKgMx9exGgo3fqi2yncNsj/OWXk6sr/7ohnSjrBLhObn0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(110136005)(8676002)(6506007)(82960400001)(54906003)(6512007)(66446008)(4270600006)(66476007)(558084003)(64756008)(26005)(2616005)(186003)(38070700005)(71200400001)(508600001)(36756003)(6486002)(86362001)(91956017)(76116006)(66946007)(122000001)(4326008)(66556008)(5660300002)(19618925003)(2906002)(316002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WklueUdlSlBrM2dnMytYYytpeDd4VEJkQjZUR1ZkVUw3a3kvM1Jzc3dIT0NE?=
 =?utf-8?B?Nk1IUmpKOUo2YmJrRkV1dGplamF6NFY3ak92bm8vMkd5SHRUa1d0c2hnL1h4?=
 =?utf-8?B?U1p3amVXbmJHZmFJYzhuRVIyRXlackxKUDduQzhTUmJ2WGhTd3g0QmxQdUR1?=
 =?utf-8?B?TDdBc1QvN2Q1RjM4R214TXlySVI3S0JDYWdlSHAxVzM1ckhQMFhlcFpkUWdR?=
 =?utf-8?B?NDFuZlBzT0FQMGE1SUtaakJZcTVqM0dDamZLM0hSWUlYU3NrMzExdElMWlFC?=
 =?utf-8?B?VFFMUm1GVUJEdHpFamZ2bzNYc2EvcnJWeSsrbFp1WFdMenIwaTFGck0wMnpL?=
 =?utf-8?B?Wkh5NkhmOU02V0h6c0hHcERSZFh2Zm1hS3hleGtsazhaaXVyOFFGOEtXSUFY?=
 =?utf-8?B?MU5oQlpQUlZZTFQ3K0JuY0RIMGNKMU05RFR5SFNUeWJnQjhGamNzSmlJQ0d2?=
 =?utf-8?B?SUNJWE8wKzQ1RnVtS0F1WndyOWtOQnJXbWpmaVhSOXFXU1o5Ump3Q3BZZVNP?=
 =?utf-8?B?ZU5oQmhYUVBDV2ZqN3NPOGxaLysrMU9GZ3JaV0FwYnpBVnZkaGYrdmJxMTAw?=
 =?utf-8?B?cWlMWFkvU3VEdWdLSkptVDNiSVlBd1JtYWpEbFFUdmhDa0FhNEY0ZE9QRkQ3?=
 =?utf-8?B?TzBqU2l1aDZzQ3BWRWlrVXJMQ1ZhMzUwbFBjVDhPdUhDTGV1QnEzZE82Y1cv?=
 =?utf-8?B?N3BFQytZdzJWRVRRbE4vZjNvcHVCWi9BaUR6dVJRMGptRm5ob01mcHNlQ25R?=
 =?utf-8?B?d0VSQ01VZXBtRGl3RDdCaE1TdVBIQS9KdDdhZ05qYzhMTTRtWGNDZ0JVdGdY?=
 =?utf-8?B?UnVmZmdoUVJkSy9WdmRFdlNIMWhWR1Y3TFJ3eXlwYXIvMExVTnBVRUVFRWUv?=
 =?utf-8?B?WHhORmh1QnBFaVFrVjNWWUlGTzMwNjMvTFphd05vS3htaXdPOEJwZTR5YlRC?=
 =?utf-8?B?V3YzT3BCQk1NS05hMGxiR3ZmN3RDRFFXY1NwM0dYd1ZFSmVsdmRQVFBNaTFz?=
 =?utf-8?B?TC9Xa0g3bHdIOUpqeGdhUmJVaFBiY0VnbHVNQTNKendXajRLNVV5aHVTUEhW?=
 =?utf-8?B?ZFcvVlAvZ0xsejkyVVVlMnNCWWNvaDE5SEs3bHliY2UraHBuVWJya0dNWWZw?=
 =?utf-8?B?UjFNelEvYjZ4VUtRdE5SNVJ1MzlFN21uZkE4bEYwQlFPOFNmNVBMOW1YWTR2?=
 =?utf-8?B?akxrS3E0QzhkQXVCTWdjekZsZVlRbDJMZmFuM2NNNTRBZGxvMmZmTTNybXNQ?=
 =?utf-8?B?UEw4aGlBY0FWQ2xhVi93Rks4ajF6ZVhRbSs1WTYwaFQ5c3N3dGIvS3MyRmht?=
 =?utf-8?B?MVIxV3BUQ0hxTzhoRFJaVFJJeWhVeTQzUnc1d1M5UVZpNlk5b1lWVEM2UmlI?=
 =?utf-8?B?RXZPZURCMTRuVktXZkZNT3p5SzhQUTlQbVNJT2NUMXBTY0pTcWg3ajYxU1Zr?=
 =?utf-8?B?aDJwRWZOOTVnYWVPampwL1NNcHJHbmVNcDU1SC8vRlFXVkx5ZHd0TXQxbDRM?=
 =?utf-8?B?YUhlTUFYdkRiM2MzWERMcWJuemVCL2NCdDU2ZDRKTE5JMlQ2SW9KMkxVV2Jv?=
 =?utf-8?B?eVFtTWhpYW5rZ252amlPOEowc1l6NDhReVZGRG5uNHhzZXpRT0p5UlYweFNO?=
 =?utf-8?B?N2pNUFIrSUgweEo4K3JXSDNXMm1xc0VvaktuYkJLYU83QWs5aUJzWjNYTTNt?=
 =?utf-8?B?Rm04VDJYd3k2Qi9wbE9taDhnbHQ1a2RzaHhscGtYYXR6UmJqdmM4L0s5dzZT?=
 =?utf-8?B?TkpBdnI2QXo4UnFIWjR2czJuakw3OUNYMXZoQmR2RUNzUkFmOHU3ZEpjRzBP?=
 =?utf-8?B?bVd0cHd2UnlzeXhrUDAyWFprOTAzNnR0cTRNcmNRYisrV1JXTUV0QS9CZDIz?=
 =?utf-8?B?LzlpU3k0L1B0MzBPODVramV6M29kSXFuZTI4L25JRnRSazlFckoxNzcrMWh4?=
 =?utf-8?B?V1p4enpDVnMrVlRVamdFVlk2eGtxOEtYS1J4UUlRMTlNNGxnVW9yTTYxcnBI?=
 =?utf-8?B?VGRmTUNudWVTUUpnVGFtUm1uVmQ4aVBtTHhvMkhtdklTa2poRndPOW00ejFL?=
 =?utf-8?B?OEdTZ2V4SHpEUGFFcUNhTDRCaHFlaSsraC9CejdJZk5jbmM1ekU2SGJoYnY4?=
 =?utf-8?B?c2lReVhlbjBYb0Q3K09KU0RmK1BhWEJrcmprZ200MityQTJXRzhPZmdJTktx?=
 =?utf-8?B?ejZ2YU1ML0RMY1NLN1hDdHNFZ0NXZEZUZnR3QTMycktDRkQwbW5Lb1Y5M3lx?=
 =?utf-8?Q?x4nTXF1Gf2R/KSNiwgFE7RbermwUJCULIR3zlERLig=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED382844713D0B429743522015E89072@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae578467-e58f-40a6-edfd-08d9e4ab3581
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:17:03.6477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQTA6Ab24U8ZtYvmhnCSEXUnPXOSg7wT/3+4NLTCMx1JYc9GSrgt0jdDatKW0fPXbrAtTF9bt1y+ao9Bv/lqyxdYWrBjGPW1tBEu88iZIH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2205
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
