Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90303C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358148AbiAaKZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:25:29 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64318 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358132AbiAaKZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643624728; x=1675160728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hqIlNMIt5vCQkMKMLZKjMxXiVnrfi5BfDcQuBjck8iQ=;
  b=pLUm9QFtjIKjCJUQJ+Q0np1sWi/12oakB7daiK+h6NrvfxBLEx1QWpk7
   aJrfdIi8NIAunUrKk5SHMeKLqqC9BB5huxszzEMS2cOHFDIwoSvBzs6SK
   F/a9ZfZQYj5hL2stz2HitFfTezhfQ9ONX/tOUG1kGvJ7TLc1+gpC4cQqC
   nD7kjYb6l6nnYejQKBHHjqP2A84ElJwuA87xlH0mMb93S0MpCdwD7Jzy5
   x4yGWUk8BDrZ36yRnH3rYER6fugB4x04K/DKXaqtvZACW8giojgpTNZo5
   73dc8u2Wagqm4DNEOrAYMd3DYMIjijiIJ01vfCZ26yHb0BC5E7gDsKQdB
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295876627"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:25:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hl8AHGymaM406Zb2a/DjogKpBOh7/PRlJLWuaHM+PLjn9p6QtM8iAh32rOxhfI8UPtMWwkgo+sEMBYR2wADQhUwSSF8jYNt/p5As9ymQ76u0tQvnw/TTzFXcTCTUkx3AEjNXRZUirsdt9UiL6EnnhGpalKUzuM8cCcX+c0DiTLlPTUsAx5kz/jz6ffEhlnc88Ltw9vTmpTL0xXHHhmVSsKtMHYPeSIAdqtB7reJ4+a/gjDO1wmTt6TH5HPFSE6OtajtZqmvDBGsgGmkQ3zvOwhEyrVl6DJHVC3/fLNuBvGRVugNbhdh58OpUFJFcxJOlIXJwLhW1wEex77WxG5rkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqIlNMIt5vCQkMKMLZKjMxXiVnrfi5BfDcQuBjck8iQ=;
 b=KblyLp1TlljB+ylPemvCkGtTnpxSKzJwshA1QY/q9j1F1Zy0/CDeTZfNhbnLlUFrlk/myZZ4eLiSdVLwNvZeqygk92urECXmAXoocWkncEq/B2KOAx4ngluF4e5pgvgHbpLV5sfHsq6qWCwVs3Gnvpv91qAVEbBMgjh4TCg6W/Q4WyIMss18Kt4opqgF27gynCjjJOSp6K5s4srpLRoL3qAy2XMU3ERGlbmPh91kke8QW2yLkiTf5k1l6KSpcAvcDbf9+siWCkeaQ1E7NEP2wOFW3k/MWTfbzUkTNsPlbP7Wc0KXPFwLOYQH+RsujqgHHmxxBX2AvBIzuUuN33Tk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqIlNMIt5vCQkMKMLZKjMxXiVnrfi5BfDcQuBjck8iQ=;
 b=SjecPFtwv7vOOZT9W+N72IYoPyHBOP6WQSiLiJOrFCcPBsvxhFP1KhckYRESG1LgLM/sbKPmhuMvYfpzmpHb0zCOGzPSRRyg7MJJsmzpqBSLGJKhO7r/wlFZVvODBeD42znvgEeDr9leYwT3htqXLdVbpYGrkxGqU6Dx20ny7qg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR04MB1001.namprd04.prod.outlook.com (2603:10b6:910:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 10:25:26 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:25:26 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 11/44] aha1542: Remove a set-but-not-used array
Thread-Topic: [PATCH 11/44] aha1542: Remove a set-but-not-used array
Thread-Index: AQHYFJVYbfOQg9riO0qwiWCfp7vyHax88IwA
Date:   Mon, 31 Jan 2022 10:25:26 +0000
Message-ID: <bf7e5fb43e80ec74fe88014bba6c3ebbdcac3a19.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-12-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d06f805b-a738-46c2-d7bd-08d9e4a3ff33
x-ms-traffictypediagnostic: CY4PR04MB1001:EE_
x-microsoft-antispam-prvs: <CY4PR04MB1001E75EE01ADAD3B7828DF39B259@CY4PR04MB1001.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7OPC6Tuzji0x3LnxPNt5x1R7Qnr7P7AnQ71bW08ITheQPPjAqcRhonZGwsv42nQpPjrsg8oawTDs+uUI92CsnmKXNWBshWgBdO4yv+0mSpGpkYEajK3k84WWsnNYCSyHugwd+/xeMcINjUQTGAQfK9+cADAeQHV2DA+2TyjZ0QjqEv/Ad2QsixNySRwMEaHvxEi6jcXPUaYEs23rxZaBRAwjMJbbhFxGHC0uO6Mx8wj4AjArdMM0q6JnujRtxcWsJKbNvxhJilPRnbs0hra3tWA85nb+xFLXNpRJM7uYv+Oz3E69nUMIALRjKPGIx8dGoGCiSjG4ADtHO3GawLK9LP+08NWlOlKJ0SPW1F3BlakPQPtJ43DSdhrOBcaG96PjPkAfVXfVOE7rotREX7qTjXfMj1vhL7EwT8Tulh5gSjKT3YBg2YrJ1kRNl/2U1PTjee6UVkuGJ2LgWlMeBaGoGAClKn7iJDjrENCskpNEa6HalhfnO8Rhbb/ZlP72Ryw3wgoANTXYCXBGxgBNKSujQy8tc7mo6QfPDeAJ2sVnCklxjlbyUJee15/+hWepBHFsm1Q6wh0dzhV0uInyCE4aT54OwYfK6rJFUl5kTz2EOCrlrB9I6CWT/cPMaR2RvgB0MwlTCIhhGi0tlJ0WPdubcKxMOQh+msX2bQuRUF7SxLFtV3powF0kq1UpvyGWf82hqAcNM22zzQHnMB9cdnsPHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4744005)(6512007)(5660300002)(6506007)(2906002)(71200400001)(2616005)(26005)(186003)(38070700005)(86362001)(64756008)(66946007)(66446008)(66476007)(66556008)(122000001)(76116006)(4326008)(8676002)(6486002)(508600001)(8936002)(82960400001)(54906003)(110136005)(316002)(38100700002)(91956017)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVYxYVRON2VhYnlTckdlZW9tMUtVOTZLZUFiUkh3cFQrUzJ3WUVCbklKV3lj?=
 =?utf-8?B?ODIrZTZFaGtzYnBadGJIWmZuRHhia2JHU20zNGcxSW1WL2kwWVVtUmFTeDZv?=
 =?utf-8?B?UXBDb2JvbS9OYUYyZnNObCs3OGlybGxDRVNLemxEYlBPVFBhS1paR0dpRndI?=
 =?utf-8?B?aXVPeHZ6OVZTUGdQY2U3RDI1aDlDYW12NHM1ZHJnSDN5L3o3YnVCclBJS3A1?=
 =?utf-8?B?dmVDOHdrY01uL2c5aVdiT2RzbFVxSFM5Wk5xZDFQR1NmbktrOGtycHY3QzRl?=
 =?utf-8?B?anZrUmxrdzVuaXppamtnN0d0Y2pyRzBneDBYakZtbkdHOC93WXhnZTlUUm84?=
 =?utf-8?B?THNIMTNIdnprejEvZTh2SzVyakJiMkJubzNINDFSV1ZTdS8wS3ZjZStmS2Rz?=
 =?utf-8?B?TjJLVndnRGRlRDBJL3JYdkRpVDR1Njh3TDNzdlJIQkt0RE9XQnJjUEZvVFRn?=
 =?utf-8?B?ZGFYVGhkVXZhNzdNaHlCVEN1REMydGVJcmpYSXBvU2EyUGhRZ2JKN05MUTMv?=
 =?utf-8?B?N1h4bGk3RVhoSklCQXEyUzk0d0FnUzdiM0xWSE9EbHZtcWQzYUdjbDB3QWRk?=
 =?utf-8?B?UEVmcWlJcFlJc2FkanJMU0ZSUTIvZmJ5LzZjRjlwOTNuS2NxS0JwYjIxeWhy?=
 =?utf-8?B?ZmNOOUFzdHQ4T3Azcy9DZm5kSDdiVEs2aXRCMmljYllTY04zaFdVSG5YVWhT?=
 =?utf-8?B?WnI1clN6akRDUHNDL29QOHNhN0hVQU9Pcnc4UUV3QnhGb3pjS0FMUVpVOTBi?=
 =?utf-8?B?emN0QkdDK0VrS21mSkdLamdsTWFvSlFXMkxrbWlyZkRpdi8vcUdUb0VLMHBr?=
 =?utf-8?B?MHJXazE3aU1JZ0NpaUxnclRQVEhtTjEwWk1uZ1FRV3NpUUpib1RHM2ZjeXhX?=
 =?utf-8?B?bTFsMzhYVWhCbFN6Y3BrUFIwd1g0OFNRM1Q0Tk03MmhDZlJqZXV6M2VvbzNB?=
 =?utf-8?B?M084NCtLYUV0ZWt0ckJZbDFSQ1dTaDk4T2VjN1g2ZHI1ci9pVTQ3UTUrSU85?=
 =?utf-8?B?TmV3MUFoYWMydTRHQnBGemtSVThjZGQ1aEJzSG44TE9tdlpiMDNEVDBIb1BP?=
 =?utf-8?B?TWtpaVZaSUlaS3VrREdCWm1RZWdJdzdVR0NlNlRoc0ZIY0tNUEtCbFJUQ0ZY?=
 =?utf-8?B?NDNVSzJOeWZ4TzJMK1Q3Vm5LS21EbS9XdlcxMW1nUmdZRjJQU3kreGJjYzBP?=
 =?utf-8?B?dmFCZXk2NEM4bUxFYnFiSGJqYVczWHREcUxFRFFFbGNpaWtkcHhFWTlkN3o1?=
 =?utf-8?B?cm92V2ZQdm8rVDQzU25FcTJkaXg2Uld0N0doRWhWVW1aWUFPV21mQlErVWhR?=
 =?utf-8?B?WkhhMlpqVlFxYmRWbUNFQ3l3dFYvbE9MckNWQTJHZjY0bVljSGsxdm1oR3I2?=
 =?utf-8?B?ekNUUlR5Z2d2OTFXcGNCSWEyOExiOWRpVFNrYU5NSHlqamllZUN3SXNUc3Jw?=
 =?utf-8?B?NmRsUW1pMGdEbVYydXFWMVJ4Nlp6VnNpSWtmekcyVVJZMzlaeXBmMFFXbDUw?=
 =?utf-8?B?ZlAwOUxoVytTbzFycjZIWFYxR1B0cUwrZG5RdEpzU1RFMktBVFhhWW5rNC9K?=
 =?utf-8?B?YTZYUnF2QkdoWE1LcytZRlovRWFqSmJGOStDVzRZM2l4bXpnT2hyMHRIWXlU?=
 =?utf-8?B?TG14NUhsV3ZXTFhQNU55MURveDU1L28vcmRRTTYrK0pSSUVDM0VmdVF1Qlgv?=
 =?utf-8?B?RXJNOWtSaDQ4MjQxUWpvQXREWGtGYW54TXVBSzBURnpmTm1JaVd1QVhnRTNR?=
 =?utf-8?B?ZkFmVDFtR0tQQ1FVNUhmRlVqbzNnSVV3SlFubDVKSHdVM1FxTFlOK2FVZ1lT?=
 =?utf-8?B?UlgxRDdEb0pHM24zY1NOR01OaGxjdUR3NzU1UjFYOGZWbkNhVDc2M2UrYTNT?=
 =?utf-8?B?MjZwUlBYaU5wbEl4eEZXUHI1eVBTaG9POUl1ZWNQNkdyYURCTlZDMnB0a3Yz?=
 =?utf-8?B?eEFKbjMxSlJENStNWkdjbWVuOEtnam1idjN3YnFSWUR5UXVkbUNWSW9McnJk?=
 =?utf-8?B?aElOMGllYTNoa084dXppbWI3dnY0Tk9BcEZuNFMvSkkreUlaakFMOWUrUXg3?=
 =?utf-8?B?N0srcUxiYU12b28rUy9GZFduTXhyL04vYW0xQ1E1ajVEck1SNTNRVmxUVHRF?=
 =?utf-8?B?SUViY295dDZSRDdFdUxuWkpUUm15RDJUeitjZ0lQSTlidENXY0xBbjJVcWVK?=
 =?utf-8?B?Z0JvZFZLMlljVGJQODlhYTNwY0ZaWEhaWHVRcDl4SnF2Q3kwL244Y1IyYXFP?=
 =?utf-8?Q?4VMwDmhEFH7UPmyi2MD3ltBb30Wn5UJXmtwMVkZs3o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDBAF1E78A170A439E5BECAA3419BE98@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06f805b-a738-46c2-d7bd-08d9e4a3ff33
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:25:26.0463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vMCZsmO6q2nTC9etOkNZAagwCO+pKKfzSxxyqxmcjb0G0c9QYZ5vca1ou9UJH2+x4KoV3OvItnBAHkKk//WSZBLpoqGd0mEGD6Pk4cWbp1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDE0OjE4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gQEAgLTI0MCw3ICsyMzksNyBAQCBzdGF0aWMgaW50IGFoYTE1NDJfdGVzdF9wb3J0KHN0cnVj
dCBTY3NpX0hvc3QKPiAqc2gpCj4gwqDCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCA0OyBp
KyspIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghd2FpdF9tYXNrKFNU
QVRVUyhzaC0+aW9fcG9ydCksIERGLCBERiwgMCwgMCkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGlucXVpcnlfcmVzdWx0W2ldID0gaW5iKERBVEEoc2gtPmlvX3BvcnQpKTsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW5iKERBVEEoc2gtPmlvX3BvcnQpKTsK
PiDCoMKgwqDCoMKgwqDCoMKgfQoKCk1heWJlOgoJCSh2b2lkKWluYihEQVRBKHNoLT5pcF9wb3J0
KSk7CgpzbyBpdCdzIG9idmlvdXMgd2UgZG9uJ3QgY2FyZSBhYm91dCB0aGUgcmVhZCBkYXRhLgoK
T3RoZXJ3aXNlLApSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVt
c2hpcm5Ad2RjLmNvbT4K
