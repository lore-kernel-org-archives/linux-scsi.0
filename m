Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A928C43219
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbiAaLfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:35:40 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49395 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359290AbiAaLb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628717; x=1675164717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=mwvG1w5QA4ZKxvAe4Fu347ZBet3hqrytEERj7+3E+9/j1cK7Np5KwlNa
   QKUN6cQCuIST3DWZaxXOJ6HYKydoNcrKUF4HRVPCBXiz98zWT5gk6mtY2
   7pxGB92ATXFrIU5pzdR2TkKi9nLrE8tRnxOtxvOIF7c9nQ7kHmlG2rJ3B
   zVktNQ4YkXN+w4MckzgPUsF2i8DOorAMmvWWssFPOy/gutbpVM/wB2g6V
   aifMK+Cq24kF9O0AzupgWhzEQ8/udAOgbdB3Wjlkk0WDfnpE7Zu4mTHVY
   k05Eu8HYSu2APNRaDMrlWcFPaG+FEaxp5RgRNx2qqMViqfmns/pOgUZs3
   g==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303682338"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:31:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB+FMWVJJEyslaC+tUnWE4oSAbe2GFQYxLbtT/WAyUjIsPAc5lpkaamKrE4GzIZztMuVwHts7eiGuacF8PwaXvcTrCL6qiYvMV6VjGDeZfWSH+2go3jkK0GC+VGyBkIIp4H6mb2aFjKvgNa9HGTUt/LH2IsiRcuVKTkeZaDoXxonORgNrZhc8j6IHIL4g0ICLaX6u68pRkTB+zlTjdhu11ThbTqYFfCuUJQiIt/36Sm4NRDyvXebhI2LIUYAH3y7u65zimRg0laFeNdL6sCv5mq2OnUOxH5fBSa0VKMJbQuGHFiZFpmJ3oVAEvqL5QWUEdPTOZcGpHWQc1Eu/yu6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=S5lpVfH0x22QXFCy1iPYS9b9yc/2MPDxbgdN8ICU4P9YskeyvVg04aj7FWddzJ1NY7BlO6nUMX2sy4nqt8RXpV4SlbiV4aMge8lczUVyP1xJTJ/SkFSuedhsiilbGfXFwj2wMB+S+PN/hBm1aGbradLR0Icw+o3phPQMBpLQePtFCxDRrDM5cqUhfYnZMVY5LjvFf8WkNNInst82IXl40H1PuDKj1yqlY/C3Koxwje9gUSOH9qG5KnvKIeR2kbBIPINdFVRKIrBot6hvE8/GHBQMkxmtnKk6GpzNc9LmM28P4U3bBYQpiqX4zbLBJQ0XBctyOWcJE79nXXRZS5K37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=U8Uz7bdMNXlxyysWQUzAvaN+zwFQGNvnaFkYLCGUHI2BlC403+2BL2ocTxYr3bMmTOJ55EJu6G3dM8f5SDULkczZ3jJmpIrrZwDsbizAWnfKE+nG8bvf5Kz2IYUEtk3Aqd6zc912UDC+oA6HQaME45tN2k8Rs9MswmR6d9nqdjs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MWHPR04MB1185.namprd04.prod.outlook.com (2603:10b6:300:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 11:31:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:31:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 29/44] mesh: Move the SCSI pointer to private command data
Thread-Topic: [PATCH 29/44] mesh: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJV9sIHBFm7IhU6LXjlaFGFFUax9Ax0A
Date:   Mon, 31 Jan 2022 11:31:53 +0000
Message-ID: <3f5c0567cbd7d0b772d52ae50c1eb754ab36d432.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-30-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-30-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47893190-b49f-40a8-223e-08d9e4ad47e3
x-ms-traffictypediagnostic: MWHPR04MB1185:EE_
x-microsoft-antispam-prvs: <MWHPR04MB1185E9F93CBE1215731FF5759B259@MWHPR04MB1185.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2e6zlbUCj0pziLpB0pn4Mlm5nxg2okGZFXUpFnvmPgZltwMCIOhaIqXgDhUdviqH2gRSRbc2LFaT3TAnXZVQQ3VXrgk+bwHyWvYbIOb6V29gUJZXHb4SIh2fCWwxLI8puWlK2QLJnNJq73xf3DZArN7X17uo1x1sd5h3m3GrSxzovAJKjqlDvs5CE7zVoKnaSP9CWzjIaNMKLBSs4EKpqlt6HrQoT+CiqAnt67hpWLtDW7ostUa4Eq400Eh/Gme86akdUnPLHv6K8JoyAl6N91uGbOGDEhQA35Cv43bfpXjfwL+CQGQG/FuFluKvxXKzuVxZZuNQMnKGKtG1RwU7N1qIPPBGaBAKvLKYV3Ra5bHazOeV/JNwl1gt/vh+xCfO+AjVMrSnpViRBH5EhsajLyCZwKAoKuCKHTUM9y1hFyJiUsQQ4vztwnqqQ4UIG6BllDQJNQ+L+BkdCNsnazc5Sa4dIER+eGhN0tyUbxzXBAoiKI+UvwiUqw7xlevcxNth7QPyD9OSO82hiQ4qv6+oBzAmr6gplOYFgadCcctMbpOxGJ08uEjX8nwdPhyGWYe5OHHySwSy5yk+5Rla7tkgPkX+cujd0Zxx/uYMJVajnGkmWSxxBAIuIQM5xFq9+uvp9u72Cc66LHYUwxSeaNGcDxljXtP7F0nzFTrPZ5cGHhs+42hjkKjBWU2fz0zSX9NJSjL0VUOxtCC1vUuu55VdSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(558084003)(38100700002)(86362001)(38070700005)(122000001)(82960400001)(76116006)(64756008)(66476007)(8936002)(66946007)(66556008)(71200400001)(66446008)(8676002)(6512007)(4326008)(5660300002)(6506007)(508600001)(6486002)(110136005)(91956017)(54906003)(316002)(2906002)(2616005)(19618925003)(4270600006)(186003)(26005)(36756003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDYwb2MxaWhDS3pQWDBjRzRLYWdPa1VIOThucXFhcyt0SFNISUs5Ylh2VFRB?=
 =?utf-8?B?SncyaFdoS096VjRDczVIVndMRUg5QjV6cUh4ckYrTlRtVUYxYWFwYkcrazhi?=
 =?utf-8?B?SitONWVhVklkckVDS2JCUWQ1ZDN3K1FRS0J6M0xLZjhWNjR2d0s4Q1hBWHl2?=
 =?utf-8?B?d0RLV1p3VDVGbVh3N2w4K0h1UG0zaUx6VnVKSDdlZzJTQkl1c1ZuRCt5VDZK?=
 =?utf-8?B?Mk5ScVBEV0x6VXZjZ0x0c1lOZDRQL25qZXpDektvamJwdGN3TmxLL09vejdy?=
 =?utf-8?B?OEtyZEhjNGx6TzRhT01qY0R0WElZM1R4eEtTR2IvUWc3eXNDWEJ1VGNBdS9s?=
 =?utf-8?B?YnU5OEN2Q2JwWVBmd1k2L2RzblZRckdPczUxcEx6S0lXZ2piVzRmdmN1dk1N?=
 =?utf-8?B?cCtRcDBnelF5SnUydU5YKzlXZ0kwMFFyTW92b3JWelZnOHJxV20wamthUW4v?=
 =?utf-8?B?R2JRQTJwY1NEelZQaUtvZ3FscWR5ZUwvNVVxZUxvMVdLZkZOSTcwMUJhazFv?=
 =?utf-8?B?MExLQ1BTZWREbTFDSWtJSUZUUHI4S1JNZ1YvVzlNWm80S0pJS0dEZ3hIM2pp?=
 =?utf-8?B?RkQ1MnlJbkxDcWJwVjB5N0VuOXJnWVVqaCsxc085L0ptbVViM2g1UkY1UnpQ?=
 =?utf-8?B?YmV4MFFLQ2RoUmRlK09iOHV3ZkhBd1RuZWhvaXZ4NWdweVZua0NEYzRBMnpq?=
 =?utf-8?B?bmtoUnlGTnhZc3R6OTFYWHJZakk1Q3o4cnIzM3lZekVVbTdYSVFzVVU1RzZt?=
 =?utf-8?B?eExVQVFVNjQweWgxenV3WUhrdS9hM2pXa2wrWmNQYnNDY3ZVYi9qRldiVHF5?=
 =?utf-8?B?QU81NG9DMmRKY3F4UGxhL1h3Zjd1K0FIREJXb0hDcmtkZE5IMUlMa3owejI5?=
 =?utf-8?B?TFlZb3RZTWpja1NMbDFzL2d2Yy94Nk5EeUZTTlpIOEwrNmNZWmwvVVAyZFdI?=
 =?utf-8?B?UmE5WW5pakxhNGxINm5WVHlxZFcwMHVHSGtUcU9ZZnlBVUdJdXhmWlNia3F2?=
 =?utf-8?B?UXJOcjFUZ1U1RmRCbG1LaVJOcWRVNExTVUJDSFBPWHhWZDM5Ky9VZlUvb01B?=
 =?utf-8?B?ZnhzWGFYOFhScGdBRGZST083RzVrUmIwSHV2cEthU0ovOVorWW9Zb0VCbWhH?=
 =?utf-8?B?dFhIZTJGZHFmeFRIQWV1czY5bXMwdm5YOXRtbHVNeHA5YjRTWG1lakF3N29D?=
 =?utf-8?B?LytMUXpOWGNBU0FnSFBXZ2V0aEIreUFvNTVGblA3Z0VlcDErRStUV09TbVdx?=
 =?utf-8?B?UWEzanNnSldWMHUxZzFxZDZXZHduL1JKMUlhK29nUUNTTjZRN0xUN1I1bTdK?=
 =?utf-8?B?S0xCVVoyVCs4amNVK2N3M3BFVG15cFhDUE9PUlFQZS9EQUVqa010K2hUMzFh?=
 =?utf-8?B?Mk15SWUyMDQwbFUzU2hvcVEwMWJrRmpDVS9zUVRaUURRSzFBL1puaUZQc2w5?=
 =?utf-8?B?SFhGTlJyRzVkSm15bS85eVkybFJOT2E3RkMvRUhQcEJ2YUorR2NwdXJrM1Vm?=
 =?utf-8?B?UVRLYmpWTXpqWnNaMWhoSTBDOGU0OVZxNWJGWGFPclB2R0ttd21qejR5VzFo?=
 =?utf-8?B?cGpDVVhQRkM0QzRtK3Q2bGVUOTRtcGg1QVdraU5WSldtL2hxQWExUCtjMGMw?=
 =?utf-8?B?QXNneG43eUxEQy82NmxIM3U1djMza29IajVDc01EK3VzT1c3dUh6bDlqVkMx?=
 =?utf-8?B?cHFjYUxWVElzRVUwVG5CSDl0NGN5TVBqaEVON09OQTJPaks4dGtMS1AycUFp?=
 =?utf-8?B?UHBuWEdXLzVnV1B5alBtUzF6VllPUFB2cUdrZnFIMEx4Z0MweFgrOURneis3?=
 =?utf-8?B?bVlHNXVCR3E3ay82Rkh4dFlFYW9EbENYajVHemtZa3I2TmJOblNZbStneVlO?=
 =?utf-8?B?VWE0bTJTTFYwWmRXUnBnRjA0SURrdHQ1eE91NFNrWUdKSk12RzJkU2QxQUg0?=
 =?utf-8?B?R0d6Vm9mMXBnYWZTRzZGQTZGQm4xNnFzbWpuSlRPRHRiQlRUUjhRSmpNSHNj?=
 =?utf-8?B?dTNmdnFRSDFoWlBiYkQ5WDgvbVRKeFE4enRaWUR1Wi9WTHRuSndjc2lkeGVm?=
 =?utf-8?B?cktqQXZINkRhd2VHa2JSblMxYlg2SG9GMkI2TzYxQ21JQU1DMlRaUWZMOXp4?=
 =?utf-8?B?OCtKZ3M5RGJjVm9DbGU2eXNLdDRrTTdxWExDcXVTMnAzUUd0cG04S3diRWMv?=
 =?utf-8?B?RytaUi95TDZrd05sUmUva1BEUGVLckhlaGJnZ3dnZzAvZzZPckoyOXRpVTBh?=
 =?utf-8?Q?t+TKczRhg7v3UYVHxP/VP92G2JwJ0Ljx11QSDPp0w4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3145C176D9DB3C4A90990F949B8449DD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47893190-b49f-40a8-223e-08d9e4ad47e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:31:53.4928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UIxm3aeFgPNLt9tTwpHT+mGh5nA9PKADr1Y16vf1aWB+/8dPLyfNAQV743QJtCC2DJthBSm0ophCDds3mCVGHyb+aQw+h12h6mwpMCqWCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1185
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
