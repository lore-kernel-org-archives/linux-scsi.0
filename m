Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E836C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377146AbiAaLZz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:25:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:41512 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378268AbiAaLXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628233; x=1675164233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=HhTgIpbFVeRln+0us/HMf8o/kolHrI6aWVDhsB7xG33XF5kzM1lAc00t
   4zlv0vRZLCeUWBvV4VfgIU2Ka8ZdMSKeQTO8qFqtHgmqxHyBoy4rdq2aj
   QwC2eO7gDkh4ulM/W+KMAqpGZ24+8oPSvL24CnVwPszR5KkB9Cjqf4cyU
   jGCc7+ToClJd6fH6vJinHUjq5a5rL8GeImbV6lkFFWkMfXzCIENvDkI3k
   dDqH8Lv/XJNBUf6ObQHkDCZGRTLr48ZpD+3iPBnrhlQ3zbXgZfpP2NNwH
   h1k6GCeH3wUpJ+t/VapZLBOziiZB6o22814uJdCD30tgBCPRFa/QvMoWq
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="196594044"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:22:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+3uKDAelzaI8d5r5koL5zlLbZdW6BgvJan/8wmKQLMzEZfvhWmItjDewTEFexZMwm9Xuun+BUqlSvVPwRo1MiClLx3JCCS1s15NNBj4PAzV4Y33UCypTXj0sj5XzLWp/YbWFThpUyCfXbLNPa5rjcBT6pnuYODg1QZrI2rnBSfJWE0asLxru+Z+R/y6PMpKgS1Ov4zfEsiEhFwBb+AxtvvBn3hy9vimbjHQTkRwCPbXO3YZn/Swz7BuUtsvywET4vo1sMdDLvAqxg+JgD8RJguw6In28glG9eq967YdoqqHoSyp9w4W0dRmobAsyTohSpd9zSrDLqIhrfPmdQFSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=d5esVCmeg1nSmNz/f1s9MgSDZzSVybmXbFRDuOnUTzUmgej8vJpFq09CCijBeAoyz6fdpZOfG0Kfg0DUAT9HvkGQPtbgQPs2RT0c4b1rmTMpmKOLeY2D7K6DM21vA5TloKMctXQfCDNXVW33MCn4j/1IcQF1R/8DlAAWilEkyuAmoJmGIty6Tj8lShFJ2CLEhnH4J3YayKtSeyj3y/RlXBu0GMX0EyI9t65+A8vWBuycGIp1qRQKGht+Z7A9XuyNy4lihVlbJOYNvP+RF8c2mfeGL1PjpM4KntpNKk81QeCXIA16Ph7MrslzLZu6uCJL21O+ypuiuQxoJs0MadDwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=nbbokXKy+ttsCoORR5wSF+KJGQ/V+UdmtxX0oLdWmdJPUSUvbnszw6fuS9F2AqiuT9Hpv9f5hrOXfOsKJXY3fo9gwKmEBewyBEuHU8aaNvUYxDnyQ5DOpvrDCK3Bmvi4xhwQZ1bdwTwP4uQzlnf3TMjDDcLpXcp6KFqxwxYIAL8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB8289.namprd04.prod.outlook.com (2603:10b6:a03:3f1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 11:22:52 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:22:52 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 26/44] mac53c94: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 26/44] mac53c94: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJWApo3gEcv4IEamNbxPmXmBtax9AJiA
Date:   Mon, 31 Jan 2022 11:22:52 +0000
Message-ID: <bc3977c757f70082a31a84b3569c949972aac1b6.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-27-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-27-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78d8388b-ba9d-4417-1c95-08d9e4ac055f
x-ms-traffictypediagnostic: SJ0PR04MB8289:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB82899CDE3742A47CAE791F989B259@SJ0PR04MB8289.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H346SB4BJqUDc89cY0Mp9Sk++hVt9HmC3nxtuRylqL1z5sj0CRuWVAQmk5JXdoIDZF75Pi/x4cZtTIkHO6vJp+76bfx/vDel+XEkRKsW/zI/xQXyNEDnd0tLntEDUkZJTn8fugSyJLoF4P6XNa6L6cyomD5F3w96a7SmpOFf3UdiCzvwnYoDgrFsyW7tYi37ULMdfIH0yk62ZHNALjx+lPSjqdaF+puBRIQhb76UmzmKmsrpkKflKzTkxZ5zmusdlb4Bo9h9XAhv+lC8ZxVXWtI/tnVypI4bJtSeP0wUnzrYIdWnd2/Y6lY6An3sEcSFh8hKUUMHMcfqTB30Huk0dqMFHsRGTLY4J6XhNjpt3ASfrJQ3k/ituaMZsawznFn0/kueJ/KIaS4vnxx0rVhKQxpiXdWjG0E+qnJWAUpwVO1IJeqvu4kD2gAOwwCFAxDoe1KRio6CoOAw33bm9J8+j0vQxeoW7kUEcyVmUzPTo0vB10fFjMb5TuLOy/7ZBqGNegv/I7ndFIHR1BOsE/4+TKiMe3o43yAJMPYMZFL6J7D8NcmmX8jfHUAAyA1KIPTQd4nK86vz0XqmnXQcfEwqtIwXRKZasZFEg3S+iijaApwmVLnAhsE2L+qfd1fF9zsPdB9glZ/bhzWLGS3DNgyunrco3tExMJTX3PiyX4pq+L2SOgDVnXmY+TGRXAsiOmHnLp3QZhAy+hvAgZku5EuS5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(26005)(186003)(316002)(558084003)(54906003)(110136005)(508600001)(4270600006)(6512007)(6506007)(6486002)(38070700005)(122000001)(38100700002)(86362001)(5660300002)(19618925003)(71200400001)(36756003)(66556008)(4326008)(8676002)(66446008)(64756008)(66476007)(66946007)(76116006)(91956017)(2906002)(82960400001)(8936002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkRVUnhVdTJacElGcXI5aHh4ek5KNVZuQzZWQ2dWcks1WXlGclUvUXpPUkFq?=
 =?utf-8?B?YWtyNThFKzdESDVMekdUYnJuOWFIemNmNEJ6RGM1WHVQalRDRVJ4Q3E4blJO?=
 =?utf-8?B?S2N0MjRHZ0VaRm1YSHFkeVlGRkhsVnRFN0ZNMVJRdnRmenI4YzhNelNLeDZT?=
 =?utf-8?B?QzZLTGNKUHo5OXErdXFweWhuejdXQXQ5Nm10RGRxdEo0NmpSREZ3a2JHSHYz?=
 =?utf-8?B?UlM4Mjk3MjRoZ1dMaG1kcU9sZ3FaLzJOcng3Tkx5OXV3UzNHR08yVGNoTGZT?=
 =?utf-8?B?cUc0TDU2eUkzOFc2ajdTT3VqcVJVRjFYNG5sS2E0YUZpaWIrenRuVXN2VG8v?=
 =?utf-8?B?d1hGdW5FZ0h2b01MUGlRck5oVThtdGRMUGRMZHhoeVI5WkRLK2xRZ0VOMWRD?=
 =?utf-8?B?eE5HZ016ZFViaWtvVDR1N3QwY2ZHd01FWGpZNjRadGtIT3gxY2xqQ0NBc0ZG?=
 =?utf-8?B?cFhWOE94eFV2U0xwSHFwZVNSWnhaOTRhM1lRSW9MTFJ6MVZDTCtWd2dlenpH?=
 =?utf-8?B?QTFPdFlIQnYyOTQ5ZlpSVk1VbTlxSGNZVGJEcnFPWjNsdTU3dzFudTJLOXg4?=
 =?utf-8?B?QU8rZnhPalVuMysxcWhDMFlPekkvOEdRZWJnN25DVy95Z3hzQnlXTnU4UGlX?=
 =?utf-8?B?ODMrdkpzdHd3d3IzUjg1eVMvblFmWlhnSDhMalBHOU8vSnloT1hEK1VCYmZo?=
 =?utf-8?B?NEpmMEVjMUJvNUpaamtIaGpFTFhHYmFLWE54ZTRmM0FQWkRHeVp1OWkzdGVh?=
 =?utf-8?B?Q0V4OVBFNTk3QmZZeW11WG5OZXZucTIvWjAxUjZVZzd5cGQ3alUrSFZhanp6?=
 =?utf-8?B?M2g3eDAzamhpRks3ZUdIK2ROTnVDYWN0ODdWM3MrRjJVUklXUVZONUxCM29t?=
 =?utf-8?B?MkhVNGxrOXNQbS92cHlVM3hzRVl1TjEyVGZvT2R0d3lXd0pZNVpFc0dRTUhF?=
 =?utf-8?B?dUd4S1llcDZhUzlGTllOL210MUY4QUI4YmxrZ202M3ZxVG5YSzdwTEwwWW83?=
 =?utf-8?B?a0tsbUpRQThxMlVZWS9OUnJUVWtTVldkV3dJcUlCSkFmdE4vdkIwRzk2TEtv?=
 =?utf-8?B?SFMxQ05FcEZ5WDBndUIxN0RxOUNSblkwb3dmYzd0QWtvRmlmeTlrdHcyQUd3?=
 =?utf-8?B?R09XbUNySytMYXlsWUxjbyt6WjdhaGxXdG1DaG9CbXo0VDE5Y0tMMDRBNmlL?=
 =?utf-8?B?UVg4d3NYWXVpb0lsV3ZTakZ6T1k5b1hqUTVPcGNDdG9Kd2lCWUFaNEt3Kys5?=
 =?utf-8?B?RWF2ZGNXbzJkbnlSdWZCc2x1c0QxaHFneUFYOWwrZEoxM1VsVmlqWUpKUUMx?=
 =?utf-8?B?MGxjekxReDRQT1g0TDJKaW1NVi9rNGJvYmlRVGt6T2pFUUtIb3JTWDRuTnVU?=
 =?utf-8?B?ZEJTSzN4dXZHVUU2TTN6dTNTQnBBVWFWOFM4Y2xCOTZsQTdMZ2xhaW1SOTlU?=
 =?utf-8?B?bXNiWHF5ek1sQ2RUcWd0ZWZ6Q1poZVIwSlY3RTJXWHBvU3NuZ2liOWw4bXhr?=
 =?utf-8?B?VU0wUkllWlllMXU1MXk3U3c1WG1VaFBCTXJybEhqVTVTMEtTdWhWS2RZSWRL?=
 =?utf-8?B?RXhPZTNOT1FPZU03OXdsQW9DKzNKWU5ENkxKaEUzUFYzUjg3RjJBOTBta3ZD?=
 =?utf-8?B?TzFLSE1EM0J1alB6TUFhVFVXTitIS3UrdzZVblZqazhteEs1WHh1Sjl6SWMr?=
 =?utf-8?B?d3pZU3J1N2pZaDdTSCtZZjJIT1hlTG1heUV1TUkxUmlVTzNpV3p0N1VWVGI1?=
 =?utf-8?B?VjF3NHlGaG5CaEh3Q1FlUW9vZ0tsMmsvSU9kNDBCQlU2b1luZXpVQ3RHMXBJ?=
 =?utf-8?B?VUZUVy9MMWFoZWlZVmlCeXdXZmhnSk5WT2xkUzhmRVh3YTltZzRBcE9QUHJI?=
 =?utf-8?B?Z3dtQUZnZVVNaSs3TjdxODU0emdnYTJ4aklKTGFlNEYySk1GRUJsRnFiVldO?=
 =?utf-8?B?ZHROcDY1ZkZsRUtIQ241T2N3R3VaNXFpbHRsYmNXNlJwVE12aVpzeUtmQzRB?=
 =?utf-8?B?ZXRocWF6TENJR0hPdlFKR1o5enQvRC9mcEJHMy92ZERlTlFSRStVZVNGelpU?=
 =?utf-8?B?d3dDS2VFNU03anpPSmkyMTl3bjAzNXJ0RnRNbTJLOElWNHUyRUdjK0xXYWha?=
 =?utf-8?B?UW1uZFRJaFhqZE1hTXFQU0QrOWFYYWtzY0VBQTNjL01GMzkxRWN1RkhXb3Ro?=
 =?utf-8?B?bkdHVUpXc3RlaEFCMXV3b0JjYnhDY2ZHbjJUNElhYTh6Znh2Vjg3YXRWRDZC?=
 =?utf-8?Q?G0SJ02+Xy54TEUhPxn6i9NJinld38JLreVWe3+vHco=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1EBF8ABAE4BD44EA15409657BC7D1C1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d8388b-ba9d-4417-1c95-08d9e4ac055f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:22:52.4013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wq6vUou4C54akohOwrsdf+QiLKO9KTlZ2r3UxSMqTDXa4GteKXzYXUe5/OW9ZsHinZ5ZM5BCrFQQ6Cncmny6dGhPEA7lad8K8uBr8tNg+lY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8289
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
