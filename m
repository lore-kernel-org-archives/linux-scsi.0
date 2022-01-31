Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA14C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350878AbiAaLY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:24:56 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:52933 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376413AbiAaLVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628103; x=1675164103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MlConjTENvSWANZdSyw/4HLFqWj6gsRqjFQVqKvOb9o=;
  b=glHfqCrv+d497S8vhcbYqozOMicfeMoCHh0DhCUbHz1k1pZxONqWQ+zW
   JfpG7LodsGbS48gKtt5kj67FJDYTNyeuM1iIVoD68up9yTD4sV/E04/vJ
   Q++LRhmJomKn50WODS7cEIRUILPHOnneSaUL16ehcG2+6KgEXic2Nmr9o
   RL9YosTXvIptW13wZx06Tjtnv8ZJ/vk6i5n8jZOS3sW/pwLSxp3QAHj2G
   BVbNmtc1cp1MaRODKdTaUOO3ztB7Q1bN0jN/dud2RG5Bx+baQMTG/87tf
   chTRpg0BRq3gqQF8LYHB7m09NIzwisjuIKWdBv0UjtcJcAkulTsl5X2TW
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295879029"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:21:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9J4yIFaUdp7r8iHb8zjTKPyp8UnmhoEExjXSRFzWy1CTJUIWxgfKQRfQrQet4FrkkDNLGLhhWS259GI9ruNmqrpd/K6sgT1e3g/Jdpm/rxDL0zyH3oN5F6v1wExTDaNkLEOtdt2VNERmHuppEgadg/y8InaLYSpOajO+2qEc9L7PRnZxuDWsnTBt23URB/FyBhsuDz7PFIrhdZU1oQhMGgLafkBRZEVQ1cgroczL8kDmtp2WST/AvQk+fVMgIFXdzlO1PnYdFoFHsGoPwHw2guaJu4sEbKGd/AViPPv361rUWbeJY6RqzQJXH1F71JYs9eFjDtZP7X7DJX770y9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MlConjTENvSWANZdSyw/4HLFqWj6gsRqjFQVqKvOb9o=;
 b=ZmnbQirygcGsuKNOcLy6ZDJrLQI4pPKKjAUeOSszGJbg/fxBOPb3UfnYAydFCxSTL5PK2qCWFNghixp5NgHlbYCkxmCHa32RLJ93QyRbsoRhCkFilfsRRdEMVKbRYxxMXv6J5YZp1jAbiEiVJPqc/DsDQPNjIiX1udsfBSJeIkpJo2plTZKAvQsdC6w0SAXTCNIsY15jN64tNPLTrsWG0q06zi41lL0v8LYY1Xp/asa5paM7OOthpKx8LVXl4gz/vE7uEl3KE6OP91RU9YTPW6mZwDHukZxOMrOK55LFdWXSfkVeeyFyYs/O1hEy42Fwn98fkbBAtC8Ik2E1Tj8EWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlConjTENvSWANZdSyw/4HLFqWj6gsRqjFQVqKvOb9o=;
 b=YXFoBw31RnWxW4qShtcASq2XZyYE8tI4L+zsqCuk/BvIXUDIVduu8BBkSPlHTgjM6IyKp/VhOX5COdIMqsAxNYZjAIFzH5LAw8UbyLXvF19khl9TAX1zo2BObMQMJsIbHHgGnTAxGgJr4h1W/qQ6JNJKha6fBSetrNszuqm08f0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN2PR04MB2205.namprd04.prod.outlook.com (2603:10b6:804:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 11:21:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:21:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 25/44] mac53c94: Fix a set-but-not-used compiler warning
Thread-Topic: [PATCH 25/44] mac53c94: Fix a set-but-not-used compiler warning
Thread-Index: AQHYFJWMYFFjuwx5s0SqG9sSAkViO6x9AEQA
Date:   Mon, 31 Jan 2022 11:21:41 +0000
Message-ID: <95095a97c5d9015cd259afcbf6e01ee52c839d4e.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-26-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-26-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c73074ec-7f1a-4f90-ba12-08d9e4abdadc
x-ms-traffictypediagnostic: SN2PR04MB2205:EE_
x-microsoft-antispam-prvs: <SN2PR04MB2205996D751BC670B814796D9B259@SN2PR04MB2205.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DFVuxwgKsf9FYmn5xhhJGa+ooT89+Xr0z31K7dvRrd7rvwoebbl+y1q4k8NQQCterFIbM6u0meWGJJxPTYeIt2SAJRmKTws1GrzgjPyeQWdY3O2+TPoSqL6hVwShg1FBPMUPFbJZdIQwDulg9uVO9vwlSFejie2u4RyF+rjzKs5r6pnDsdHNMfwYkxpfzjEK+tCYBXLmc4FneYD5RBHzbIiMWQs+sjFlMMvxlQZ8Th15KAK1YY5ah+2dgetS6VZqqmWC1wAcqqI9j3CbPw22VyxlcYcpjBgMlA6UuDMT9FUYUy92KB6VtlzUUAGxGh0dFoDPwJGRLk4QkBQcRWoh+NFlhEFXyeVQ6I9Xi6cjTjocShzd8BJTJc8VP+hmEWkM16MHAK62ausMZaf/feYxzr08qoBkuGUm8RyIl2EUCadXb0W/+m2VjylPeJBtztCPvLA/rbD3aHlc4WJbBSzZytGogENut6siStvYam4Gark+850tLK3xc28KUDNYfxeE+Xx2l+fjGeLbRe7w43c9NWt3xgS2AHnxP4S8GRorzPGWluBqu3auEISF7mZNrGNtcXmB3VNB3uvlSqnhJbT/pUYS9J9h0qOhuCO/9enrZCInPBLS73JaTppZP2A+Q3mJMR7n7yHZj7zzKdKMbpTjw7FOTjyAJsWmAlfUqWgE6zIh3p3W4cmUB61eQN4yHN19ibfQ/P+PwLIoaxJfJTXx9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(110136005)(8676002)(6506007)(82960400001)(54906003)(6512007)(66446008)(66476007)(558084003)(64756008)(26005)(2616005)(186003)(38070700005)(71200400001)(508600001)(36756003)(6486002)(86362001)(91956017)(76116006)(66946007)(122000001)(4326008)(66556008)(5660300002)(2906002)(316002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjFQd1BDallCOW9UeWVlbXhNQm1zSUpjell2Q291eHUrU0MvMGRXcVZLa21i?=
 =?utf-8?B?SjU2SGp2ZlRYckFUdXoyd3M3Z3MxbGowSXVlejFsRlE0NHhMRWxQT2d1bFpE?=
 =?utf-8?B?OHVzSEpGN0xTOUdpdnNjdExNeXhvZFl6OHlvVzJ4ZGxLUTdBamZlYmgvZURW?=
 =?utf-8?B?U3NsM2pkVEN1dnlrT1hKdFpMWEJGVzY0RHhFRTRDZkJnNXdpektqRDMxS2ww?=
 =?utf-8?B?SHNMUC9vYXFONVVNMzFwY3A5ZlprSXZJMXJ3SVVxUy9UWWVHQzdEdFhCREs4?=
 =?utf-8?B?UGZKYkpWZlRmaTlHRXhlZEIwaW0vb2Z1OEhEV0xUYXd5cEhURXFXT3ZhYmlK?=
 =?utf-8?B?bm53aXNqNDZ5QkpFTWV3OWFXUElRTXN1NEg4Mm96OHJQYmpFQ0JMWTRPWlB2?=
 =?utf-8?B?Wkg1Q3QvVU1kV09KVXNNU1hNVGNCVHpnVEFZSVBYTjV1eDJic3JaT05QN2Zs?=
 =?utf-8?B?QkNDb3FNdG5zK3owcm5QNHYxM3NScWlNUmJRTTArZmNOYWdZNzQ4UXRjNU5Q?=
 =?utf-8?B?OWpNM25odEkrNXYyaDYwT3ppNkdobk9mK2F1YXRWNGVGbnpMTG9GVEZkUmFY?=
 =?utf-8?B?Wk5ESWQwMmx3eXBrQ0xuc1RlY21hZUliVVpleTQ1bXNNbC92dklNbXpGVzIw?=
 =?utf-8?B?MlpVZllHL1lWTnVlQmczamkrbmxHQ3VOWllKWFFpaHhZNDVRd0RTalRsRTRs?=
 =?utf-8?B?ODJTWGhhVkV6WXVFL0NEL1FadHlNNmhNVzdFR1BLMlFheXZ6WnkxQ0thQXd5?=
 =?utf-8?B?c2NGQ1QvaFVTSTFIK2NPMDJKMEMrRnF1L24rQ3VVVUk2cndITXdvdjVGK3Na?=
 =?utf-8?B?eFg4Q1A3a0NkTnlKeGlmOFlUVUY0b3V1N3EvMEFNdFpyckVTbEZtVXhqVndC?=
 =?utf-8?B?SXJLb29tTWxUVTYrTVJrRjNRNEpOSjhFM3ZwUUlOSnA2ZGd3VEg5MWRiS1pQ?=
 =?utf-8?B?aHlTQ2FMNDdWbWxMR2E4ZE03SkdZdkhWTGp2cGlqVW1PbGk2SEt0emlmaWZh?=
 =?utf-8?B?eXVCMVdYUjZ3dVJ3RHdYdW83MjZrZXg3WWFhR3FSTlF0TmVGZWUyYzgySEkv?=
 =?utf-8?B?dDlPSXY1TFlLYXlUNW9FNG40SDZ1REljb2hjZUhzOHVQOTBEeFF0dmV6NUUv?=
 =?utf-8?B?OHV3a1lJQnFsZE9wMi9PNkFuczc2U1JhbERDSC82czRRSnZaWVpVa2dSNWJE?=
 =?utf-8?B?OG00UWNrOGIxS2R2MWtpbktFZDBpSlo2TjZxeXZUZmJXSDFXK25tR0dLZUla?=
 =?utf-8?B?M01ESkFneUNnV1pzRkRIRlNiUHRWNUJObnlMV05xVHdwTlB3cHdzdm1obVN3?=
 =?utf-8?B?dERhY1p5R2wydkh0cGRzZGpWNllJSjl6MStKMjNtZ1NpYko4NlIrbmN6S2kz?=
 =?utf-8?B?cFZyOUVWNlNGMEE4bFRvck4rNWlrZlorWE5wWko4eUVBZDVLdGdmcnUxZTJD?=
 =?utf-8?B?ZmVLeGtNRmxreitacXc2ME54dGs3dUJFTlNDSmI4SW5HWHM2cTJPTVRqZXpv?=
 =?utf-8?B?eWJBUUh1WmpzOTl4N0lsMmQ1Qys5alpqdXRhVkw1cWhLcWVXSGdGUmg3cCtR?=
 =?utf-8?B?Ly8rY01jVXlYZnozYnVmUkRCUWNpYmZDVnREUjEzL25kQUNUanZuTTdpSklB?=
 =?utf-8?B?NDNOekN2ZWNUYkNUOUlyWW0vUFNHMVpCV2FKdnN3blhEenRKRnpNdk0rbzBT?=
 =?utf-8?B?Ui9OZnpzOTJGMHY0cE5iTURESTNiSmRFdGRJQlVneWJaRGFzajNwbnNjR0tT?=
 =?utf-8?B?VHJxYUEySzZZRXdJelg0a2k3TkRuZkxXWVNkZnNmU0JqTDhCOVlMa2VuZTBX?=
 =?utf-8?B?cFNUV3g4QkhaUE1IY2JuUFQ3dDVnWEtkdHdPVTE2MzhoR2lBc2JiMG5kMTIy?=
 =?utf-8?B?T1IrNU96V3Y3K3k1RnVqL2JwVnhZZTY3WVNEMlRiMFhWSU5WZjVIMDFxajBj?=
 =?utf-8?B?bjg2VG9UQ2o2Vi9YakVpalFiWXJuZjYwWHRDbEk4Z1BOZ1ZNUnZwVlk3VVhL?=
 =?utf-8?B?cG9iZTlMMG0yWnMzM1RYY2tUbm1leUFZaGx2ZXQ4WFBBN1JyaC9ORjJ1dmNs?=
 =?utf-8?B?RlJtOTBWWVRSaWZqYk1IVGlRS0VDWGd0bzVUcG9YWlJtUnJXQXREbE8zd2h1?=
 =?utf-8?B?bnFhQ3QyVXBwTVdsOWdRWURPSm1maVo4b29KVkUxVUdpdGpKTHNoM1JzM2Yx?=
 =?utf-8?B?VFdnWkJac0hpV3k1WWhjYTV6dEhzd0FWYWpUM2FhUERpZm1kNlIxMnA1NXhv?=
 =?utf-8?Q?Sadm/iASM/sc6phD9j46GUSILGG7/wvRxXW0t7IJug=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <031089B366CB4448BCF68766199D7BB3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73074ec-7f1a-4f90-ba12-08d9e4abdadc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:21:41.0356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Latyek3cytpf/7aoLpj9yYmu9b4UGZWUw7EuYCRoe1cRKp7dvtxcSZzuiFca7+CY7kNj3XEB4lnMfdw7kmaF5ACB/6xenxF6RGyG2QACUYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2205
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDE0OjE4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICvCoMKgwqDCoMKgwqDCoHJlYWRiKCZyZWdzLT5pbnRlcnJ1cHQpOw0KDQpBZ2FpbiANCg0K
CSh2b2lkKXJlYWRiKCZyZWdzLT5pbnRlcnJ1cHQpOw0KDQpPdGVyd2lzZQ0KUmV2aWV3ZWQtYnk6
IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo=
