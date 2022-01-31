Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5232CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358299AbiAaKns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:43:48 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38440 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358150AbiAaKnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625826; x=1675161826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=YAL/aS6wXk4F7AXtK7ELGv5bOvAiX2SG2HzNGckYpfRcxegcmVcCR95v
   QV7alLVKcE4EDVG3vS88QMYyzcdwaoomOhrWb+hvvqJCuXIuaBabeJ6/4
   9ks4W+M9xHub4UCU0L2C+zjgpw1pruNcj810Dtv2oPBJDniHzt0DhHc2l
   vqSL6gnH1DkYyvw4vLAKPgV4ExQ8uEg53oXh0tnyqC12V3TNOTV68JsIZ
   QwdJBGt3eAV4J5PNcGav03qL+AnkIe9WiFR1nY1UtbpFBbDI5unAA/SYh
   DDXvFBTIQodTkBG2cnSAnMpX3R8x9ZXm3sDD5+qzPN8r9dwqlVXKvdkrk
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="196592210"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:43:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNLXF6SaCpMgFJwPh6yzL2u+OmTxzkLD4KCFjjYBCSgE7a5RhsaACx/jrVTP1DKVu2GlsRpLR3Ap4EfHr31B3y3l51hwsoMiPujcRC66J3MUrhferGJgKrHidYOo8oBe/n4o2j4cWRFo/LsRjaZlCKRsCMykyheYBHikjl+YOeCt+8tlcKodih/3RU+EXKxPK02bC5LYJAChj59i8G7w2PCT1Gjiontbk9Ht0M9ttdfeNTlLl3tr39Ao+32KVGsKbWtd3qTewLlW+8O95dYjG7dGW1hM0z57F2BTjQfJDfkKNB+mX3FNi5JDK/ilhqGG1SNwXiBsRF6oBYEPYdo7iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=bZ1y9kbFlwvrCW+LD2b8egxd9ZR8jVhe2t5w6qLAMZLH2VXRdA85dMB7o9bBx0chlG5fhXxcllimnaNOpDfJ8ntSmhWzGHS0cEFMqUUd5Vcio7afUx0GCeeuYZ6qpcFlIG88ygJ8rkHdmQd3BXtAOWc9OXjTMAbcEoIlw5jWo6dWIGxK1vcG/bkjHdPsNCsEBjF06WXWMsCIAlh8KeV+R63EFhlu0vnYuQwwDmkeuWyvY6x0VS/+2o1JAqko3AuTt/YZLmy3wnwQlG+5niAPxZOQOKKvjqokFKWW5x/Iwi7s8WSZpKjrdI6FuJQgG/UF1ZVQYwIK7hfOgwoY02UCpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=AM5pZmeHNXgN1qvQJMllpPw9NLR1JJVPuirX9AsrcMSzUFOgBOzaeKfOJ4xbmtshEG6bjWWGxbpowffqHrVlQIl07scvsUwDhZp82y6UGS8tfYb/PCJCGv1xlcSvAdRMG0GaDaufd0vXNaC3/nXrrcoqMUui0bqMNv9xvnUdZHU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MW4PR04MB7265.namprd04.prod.outlook.com (2603:10b6:303:7c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:43:45 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:43:45 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 16/44] esp_scsi: Stop using the SCSI pointer
Thread-Topic: [PATCH 16/44] esp_scsi: Stop using the SCSI pointer
Thread-Index: AQHYFJVjemlmNT+C/0WRG6B2mNKqRqx89asA
Date:   Mon, 31 Jan 2022 10:43:45 +0000
Message-ID: <ddea12a2feaace12394b61611c60417e4b27984e.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-17-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-17-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f178009d-fcdf-46ef-3a64-08d9e4a68e63
x-ms-traffictypediagnostic: MW4PR04MB7265:EE_
x-microsoft-antispam-prvs: <MW4PR04MB7265523ED55E81E360F7F8869B259@MW4PR04MB7265.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: grptk7HYmiqd43q5FTLeVG4p95rugYegP2+bDd4rG8gNDJM0MyRnl6njG/4cg6Qor8F7gccm4oXj5TSeixGsxVPIIA1PkUHaHDMGbcqlPliFms0vKuLmqi4+yBEQO1W7XjqzdjK6uNUyE8W7yoxttXPfkhmRfzVJ1gnRsLT7pYJmmGtaWfIVlihQ9PoBbSNiSg/c5Mld00a063LIJJ/oKNl6S0AQFiKp5sy7zFKpx9xvqbBesTet3/hPJhXU/WAy169DGEQxlUAbRwx/bmFAXej4JMkWkxDMDTXro+cbHCUn6fc7Qcj1rOOBGNnDasEVWcOTGiJrnkYWxaZk17z1S3Uss9DyN81/z7of2O6aNyl/T1ydhCwMWYZDcBDsqwydjMsts2ypKcWow9ZUnRu8gRkH8d4ihvuJndT5PBZnNGmk0izlAADt4it8PR9QlEWUhgueZhnWkVfBEObgSQBQM5XejuscagXw7osfCM/TPq5PPG4h/wtp1AG80giLYDMCNt1pOm8XeUQdS1laR0m4swLM/5y+Txs9ezLoSsU7R+vi3XyhvhLkagcUdxwypXkas3wdWRwfvIuKlBvCItMuOQR2nEcu5plUSnBBJoYjlhk7hVoWsT64mjYOe6E4Z4yL+GXWGG9f1CjGks/zAYiqPqZdizxUcIpMmyi6m2LLaDXPaYmUb6ycllFMmewN4aoIOuzVC/9G9vr364Tm65x/+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(19618925003)(82960400001)(38070700005)(2906002)(38100700002)(122000001)(6506007)(6512007)(316002)(71200400001)(6486002)(54906003)(508600001)(8676002)(110136005)(26005)(4326008)(8936002)(64756008)(4270600006)(2616005)(186003)(66946007)(76116006)(66556008)(66446008)(66476007)(91956017)(86362001)(36756003)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3FxRHlDL3FOQ3JxQWREckFQVkViNWlUbGY4eVNJME9VZUE4T044a1ZoODVD?=
 =?utf-8?B?aW41QkN5b0lHSDgxeVJMMXBkMndSSVJiWDRGVGJmOVJNcXI1YlFXTzhiQ1VQ?=
 =?utf-8?B?Yy95LzNXOW4yTWJ5WlFNQ0k0SmtmSU1RUm81b20ybmtPVDBHUmdQVk1odE9U?=
 =?utf-8?B?dDNhZmd0aVRvWjgzTUlkd05KSzI1N3dHVDhRM3BuSGttaHJNcWpBNGdQK2VU?=
 =?utf-8?B?NFFiTGVkNTZwVFlkL0RFUml0TEdkNnJ0QTVnajV0ZEE0bkVXaUJZUEZITVIx?=
 =?utf-8?B?M1d6bXg5VkZsaWsybmkwMm5Bc2lva0VoWUVqNXRVU3hnYUNpSlAyMlJJODZw?=
 =?utf-8?B?THA3Q045eCtuVnk1M2tUQWhzeExlbEI3ZTFsWGJDanI5dGpPTll1c3NvbTYy?=
 =?utf-8?B?Tzc4VGNXM0ZmVEpwdzU0d09oU1Z6QU11WjZhbk9scmhPaWFhUmpyTmFNY3Bv?=
 =?utf-8?B?R3AxRGV6NjF3Mi9EM1B5cEZEbDZXSjFTN0IrMFJJLytLZlZxV0tXc0w4a25W?=
 =?utf-8?B?c2I0RHpmTWNqTzN6K2ZZWUVHMnE3dzZNS0E0dllkREtkdzFKb05TWVA3U3VK?=
 =?utf-8?B?M2lITVVaVVdtVEhDT2ZOUjA1a0ZxdXY1a05yOWUrU2xVZENYa2J0UVZpTmlX?=
 =?utf-8?B?S0hTVEpnSG1jN3N1UG4wY2RBZVEzYkZQc3I0TzJzNFpQVE1BK2JxTDBVdDhO?=
 =?utf-8?B?bnRnZDVUeThOQkErR2tlRnNRaHlYcmVMMWUrVXE4MnMrQitXVzd1dXhYZ1pa?=
 =?utf-8?B?cXRwTG1HS3RObDZyODRGNHoxZSswYmVkVTB1aXRPMkV4Mk1zK3ZVdnAxNksy?=
 =?utf-8?B?M3BITHY4TmxUTjMwVUEwSzBZVGhmNmJpNExCYk5rZnBjQ0FlYUI1Umc1Rlc5?=
 =?utf-8?B?WmNkU1VUSzF2bitRYkpINmluSDVxRExLeXpXc1U3dEhuR3BQTEd1STRPejRO?=
 =?utf-8?B?OG5TSG5wU2s4SFJ2Nm4zVTIyajBWOGxpMDZwZ0Jrbi96SXJVTmNpcTlPR0Nm?=
 =?utf-8?B?b3RROWw3UlR4L3V5V29tMXMzNFE2T3FYS0crLzVobVZoU0NxM0pOS3NTd1ZD?=
 =?utf-8?B?ZFAwWDYreTlaMGhDLzRUUSs2T3AvMjFuWWNlTWo0aFhLcXpxSTd6ajZlYldn?=
 =?utf-8?B?ZFJxMVVMdUtQUEpnbHhEWkRGeTRUVHR6RkEyREJrdEpUZVJpZE9na2ZBWmRL?=
 =?utf-8?B?SlJQcGRNV1M2alpvWTV5NGhWY3dyZ1dsc0pyNHdOajBsWmVGZ0dOZi9TVjZ4?=
 =?utf-8?B?U3B2U2h1dXdpT2x4bjR4U2o5bDEvL3VqbThFMGdvamZsdUt3clNmaXpkSUdS?=
 =?utf-8?B?SHZFeENSQ20xNnNOemhSUzFMQnhOaVV5aTd6NHZ1cjZHT2RyUy9RUU9PdkFZ?=
 =?utf-8?B?NG52SUxHQmUwZjJGOWFwWU1Dc0hKL2t6TGVZc0t5NmUwY21pbFNuWmtGcmlN?=
 =?utf-8?B?YktTditSUHNLOGVsZVArTjBjMUJrdEE0bm9aMnFUVUFhaXNISkJadnhCZnVu?=
 =?utf-8?B?ZEJDUEhBa2pveHluVmc1Z3FkMlhXL2NiOFc4OGRnbG41L05WbzRqL25Cdms2?=
 =?utf-8?B?Vk5BRC9USm9IQlJwbWcweDFQcUk2bU5MR2JyY3JZOGFpVDU5WkI2OWJFZ0Jj?=
 =?utf-8?B?WXdJRkxKUTBhYTdicWFFYjdxQW95R1U4OUV3aWxSK3hlMGp0MmV5Ly9BL1NO?=
 =?utf-8?B?ZkJYMDRDVE81MlFMWGdBSGw0YjZwR28vbjRBcFdEYnJtdlI2bGFQa3MxbWtI?=
 =?utf-8?B?c3dQbjNCM3VRa3JWaEMzRkh2YVdqMm80b2J6VWVpNFFVOFAxQ3d0YVNCWm8r?=
 =?utf-8?B?bVljbU1GcE02eFRRdTJDZHExT0c1MHpkbXJESnRQSWxDWXlGRlFVTzloSkVY?=
 =?utf-8?B?RGxVMFZlNmNudXNTNUFMc2dCLys1WFY2S1MxamlCMSs5aGdzTlNUTlorZHZ0?=
 =?utf-8?B?akZvZWphaEJlNDFJWXczS1IyS3VPMnRDWnFaWFJhUlhqZUxyZER5eDFHQjFk?=
 =?utf-8?B?b292TzUxY09OYzc3NDhGcmo2QnYraGdiUk5NTUtHcmw0blNobjJUd2xVMU04?=
 =?utf-8?B?TWVOSGIrb0w5SE4vYnB1amlDUjJZUmhDZkpORG00WExrTXllQzJMb2JIK3o1?=
 =?utf-8?B?TXZrM3JGUFFaUXo2dGR2dUVGK29LUTJkTzQ2cmZNNWx0K21iQTlHTXg0SzYz?=
 =?utf-8?B?bDByaGwyR2tLZThkNjBVRU05WHFLQjVpWTdFMDF1WjM5Q1pTVHdXQnZweVhn?=
 =?utf-8?Q?3MsV0piCJCqmqYnzqBNanas6aw3I/J086W3SO6m0fM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F153EA6D612494CA9949790F6BCEDC2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f178009d-fcdf-46ef-3a64-08d9e4a68e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:43:45.2645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yVwEs6qAXhzaNEZ7lRvpSQBs5NsvarDhn8FDTRklKqf4u9N6Wd8/kO0n3AtOvQ9bFkp504fnRkXM9xBL9qE1e0tr/Z6ugsAbrE1dkQk2Mt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7265
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
