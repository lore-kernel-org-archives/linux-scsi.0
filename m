Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C216EB64D9
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Jul 2023 22:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjGBW3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGBW3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2023 18:29:46 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240D6E48;
        Sun,  2 Jul 2023 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688336985; x=1719872985;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=RcaOZe65guEyKsMtsPSCIWDQl5YEbHpfBHoDyz7BM3A=;
  b=mB7LfAc5Q29QPEI2cW4qL3q1/SlC9qMXFs87bZk3iZcl0QOybrICF4Y5
   t8GnSt0Z6FheSFYb9x9i7xfWjsf3v5Bzt7QsJRZ8VHBzrHArtpchll1PA
   fsbeJUELGKROQ/DCLM54P2QrreljsNkD0qdDy+VP3FH0sFnh84+SMjiv0
   aoWx+jy77h4OBKFK2UOFqwWGF++RpR2oqRl1DtOJgkcqz9sY60xUWQO0S
   YcOOCpitJl2HFtMBBO5LnAKaDeonzMcynSKskHgfTtgoPWNlDdk9l9lEz
   G19nyETLXoHdwdqWHfrO4fjEi4gIpYTXYp6cnBfbuV7cKV6HMOJWXZlJl
   w==;
X-IronPort-AV: E=Sophos;i="6.01,176,1684771200"; 
   d="scan'208";a="236752356"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 06:29:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCBbYIUbcnNpTILmwvFvDo5ENEvmx9IF1kQNHxUJwpUSIQ1+9lVM7PWUN/n4nTrcxzBHOrtGhznf7/CCY09HRP3MvnYT4aisg0ULrDnvmJevT8tNM8Z7U6VBBaIBThRYsqrLIwT9QogUkIouyufWktBkvC5K3L0yfdb+bSsJ6eOc7wAZiKAQdABj6E23JZOFgLGlm1oPTNgw6yLXbLoUR/uwRObw8tpx6vEhqWh4GEw/oGX5/mNODKSixk6EkfBiyQeUTMhkzUym6jzQHEXDICxIWpM8engwLtXGy4c9ODFLt2kmc0xxKFqj1VVNoVAY2EqM0CpkkZTjKT4uHM51+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcaOZe65guEyKsMtsPSCIWDQl5YEbHpfBHoDyz7BM3A=;
 b=V3zbvW6Gi0x09qIewMYw9Xuwnj/bo6PzlMKVaZmnHdt+3aj0RvnT9lI4sl7P5iJ4Bz9pI4JiM9S+S8vCyZk9h6aRxDY/FHksGrKnTqoMBtRRSpK31/cxZ42n61sHJIOWyqvygatub31xMgenTFlubWlXd0SKV9B2oVlJdZ13cA4BxrIE71IIIp9TGzLLpGYcvX8/5SOpWJZPFmCqvq0Zga+eQhRrrOK6I6MW17ywtPmpSUfNoU9WL/YkN5R7sTEviPWatuCwD9fPBZA6JXeTbT8KgDG6W3yoEVhbJzg1FkeszYrVDbr65eG5j47aPimjdPyEKk16BYfuehgtSTNH+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcaOZe65guEyKsMtsPSCIWDQl5YEbHpfBHoDyz7BM3A=;
 b=tuIpgr3i1qB+zB+5/vUiAk5n/A43vK6JPO3eLGXIE48oNg2se0ns7VUHRwEi0PYhbHFStiLf1j2nS0eMiJSCkLA4Lsp5OW6NgDtv6GlrQCjCsdR7Jvi/a5NqV0V3FBb4TW8J1oOfUe5eAQg2gSemqqPoh1ri4DyQ5IdxPSJE7kc=
Received: from MN2PR04MB5951.namprd04.prod.outlook.com (2603:10b6:208:3f::13)
 by CH3PR04MB8996.namprd04.prod.outlook.com (2603:10b6:610:19f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Sun, 2 Jul
 2023 22:29:39 +0000
Received: from MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::47a9:f2d8:c714:5a16]) by MN2PR04MB5951.namprd04.prod.outlook.com
 ([fe80::47a9:f2d8:c714:5a16%2]) with mapi id 15.20.6544.024; Sun, 2 Jul 2023
 22:29:39 +0000
From:   Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
To:     "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 4/5] block: virtio_blk: Set zone limits before
 revalidating zones
Thread-Topic: [PATCH v2 4/5] block: virtio_blk: Set zone limits before
 revalidating zones
Thread-Index: AQHZqy6DPyxlRelGIUyXM8vw2HODg6+nEwIA
Date:   Sun, 2 Jul 2023 22:29:38 +0000
Message-ID: <29aa661719696a1ebeb8f1dffbfc47175b5f4405.camel@wdc.com>
References: <20230630083935.433334-1-dlemoal@kernel.org>
         <20230630083935.433334-5-dlemoal@kernel.org>
In-Reply-To: <20230630083935.433334-5-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB5951:EE_|CH3PR04MB8996:EE_
x-ms-office365-filtering-correlation-id: 959fe42c-2576-43ca-1835-08db7b4bd280
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uDs7X7avLx61n4L3EBURgvHeBXt8S7V3UPSaghEIO4l9Q++Ga7CUcJJzuVgfPmNsU7vgGW9rC4UEh+y+eO4sO7zG3irhAq4AhDbnnKSgcRof5Skn9MNwARvXzU+cOUOKGCVRYJoZxrz8lWOqTCOVDLUp8o/AyxfjwLM5k5bpxXdh8W2Og2R/h12TO693twhmFIwaks+8YSwkjgFvjI55Q35gun6te2XVcrPiukS6LmQXLw6+n6rlCSLN4Vz02byJvWXrAPTW5lqNrf3STopXBfDbwfCaqmKKdsFdK9Vo2Ygt94JQiOGfMxrtQR0bLDFJGct1MYEEGWZyrGLVlgsgwA5ClvGwNNLbXimJWK9QObZw2AP333GldFKmnAK6UgytyUZhUXZU12SCDDqKafAAH0OxzYLKUrd0U5gHW4c1oExlrWSV2ZIIK5R/c2cKJcZb2LSZMBBw+LIELd4ROzCHmDHlhoyp8s6jnOFC3a/DJ+SSvrOqXcD1ajA6DlL4bEPVfQGPMY1U3hLK/dr0z2XpQgweRfIyXmHdXdwzzagxbjNdUsxQidEiQfUQgHiZpPAINVsHDy6XENuHoS+1pZ9N3BmhDZzAtOFdI20+RFdS6kcXJFR67+totVmkgaPKLa4d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB5951.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199021)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(478600001)(316002)(2906002)(36756003)(8676002)(8936002)(5660300002)(41300700001)(6512007)(110136005)(86362001)(38070700005)(38100700002)(6486002)(186003)(6506007)(26005)(82960400001)(71200400001)(83380400001)(122000001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFR3MG1xN1ZaMy8xQTN3YUl1T2dCQkFqU3EvWlBlVHRKZUcwTGNCT2NGM1Ev?=
 =?utf-8?B?d3JaQTRDZVRzVW84eGYyVGcvb2s0T3MvWEllME1WSWlmVWFlcnJnZWpXVUNC?=
 =?utf-8?B?V3REcTc2R20yZmh2VkZjcTlvbEEwVUpPLytWbWpXdHNZL0hWTlNNd0srUFhJ?=
 =?utf-8?B?b3J2blNYVFk4cTl2czM1L0EzeldmbUhMaXE2ZW1PMUJCTmtlR3NldlBKeW56?=
 =?utf-8?B?WkdqWGlZeFJVQkpaSS9JYnBsUytpZVJIZmEzSGwvWVoxR2VxNDFJVUZjdWJN?=
 =?utf-8?B?T1U1bW9GYXNQZHJXdnN1eklSemRNQk1kMjhhVUUzVTl0MTZpN1VHbUt5NVpN?=
 =?utf-8?B?OW1wdFExUzh0MFJDaUNVTFcwMFRaYzd3WU9zYnFZaEFSVTN5OWZxUE5hVFVD?=
 =?utf-8?B?YlNmalBtR1QrUHVPMUVWRnBUSEd0VkE1UnNtcmh1aGNJSDM0bDhud3lLbWhL?=
 =?utf-8?B?d2M5UjdzWEJydnJnUXg2aWk2bElGUmFGUko2N3FBdlF1ajJ2RzVvaStKdXBE?=
 =?utf-8?B?dmxSbVF1d1B1Y2VIQUFkTTNXSGhLcmV5V3lpZ0R2OER2eU9xa2dpOGd1ZVl6?=
 =?utf-8?B?a25sY2dHMWppem1YMU1XVVh1RVlVelBaNlY3TkxmUnVqQ2RBTWIzemRmZUVl?=
 =?utf-8?B?SDNvaDRVM1V2VlB2VERtY3RsdlhFQVRoNHptN0lycU0vaFZ3M05LWTFMLzVC?=
 =?utf-8?B?cUZicklIRmxRMXdPeHpUelZEN2pjQm9xb3NyelVhY2d4S2lERmdnUVVtVWU5?=
 =?utf-8?B?Ykc0bEhzTkVqbWU0QnkzS0xsYTdUamNoSVhjcFQxWHpNRGpJSW41ZVBOeGN3?=
 =?utf-8?B?b2I1WC84MkNZSXZOYStCNllaLzhkVElGV3pKS2NzV3BjbUZSVFFqbUVZdngx?=
 =?utf-8?B?TkFVWHk0WmYrbXpRWVlPWkNGVjM4eG9ZanA4VnVIdEtZZzVKaDd4S2lBRGtv?=
 =?utf-8?B?Qk5zUFhlQVJSTGwrTnlzNjJZMzFoT2ZJOU4wWEZLZnloTXhlQ0NhNTh2S2tS?=
 =?utf-8?B?QWpZZ2xvWU9wanB2a0RDUmhiL3FtRlJ5R0M1NHVpVkEvQ1N1WFNkQy9EVE9p?=
 =?utf-8?B?S2h2ODI3MVpRTXcxYnZub3dmdFdlWkc0d2ZEU2lCVG8zVVFibmh2b1d3bklx?=
 =?utf-8?B?U3FvenM3b0h2R0JBQ2U1NzJhSUJJaEtzT0JKb1hoUHNqOW9tUy9vV3EyenBL?=
 =?utf-8?B?V3NVckI5RVNSTFhsWFlJUE5jOE04WHRNY2ZzSFVGcUFSd0lHSW92d2JGd2JW?=
 =?utf-8?B?QUQ1alIzOWZaRktnOEVSNm10OGNhRU1LbGlJeFYreU1jVmNmc2NTTFlYbmJO?=
 =?utf-8?B?Ky9VTDk0THJVeTJsdE92dmxNRU9aaStZcHE4Q0ljZDVBSnhEWEVjc2Nzbjd2?=
 =?utf-8?B?RGc0V0ZycXJDOWtwUXd1NmZObUF3R1J4OVk2U2w2Si9KTEJHWU9uY1Ivb2U1?=
 =?utf-8?B?VDNaRjdSZnNRcnVJT0Y2YW45MW5TdjlJbFZqeTd2dVNvKzQ4NmdwMjZlb25u?=
 =?utf-8?B?Z1JIa0ZlcVNOdWtRNDQ1N2V0bUlZVUNBcHhyRnJKNzh1OXFTbk9KQXM5OEU5?=
 =?utf-8?B?YU8zZFZQRlBtVEFQKzE5QVNOS25YQmNRZlRPQW44QlFFTHNOdFNLZWVla0pH?=
 =?utf-8?B?bXhPa2pyU1pjcStaS1ZNd1ZvRTYvY0loMWJKYW9qNi9xK0o5SkdPdzZXQTVi?=
 =?utf-8?B?bEx4YWU1WiticzRCblZsajZ6cGpBOWYwUktzSzJZRkYvZWVBbk5VRmY4N0xW?=
 =?utf-8?B?czc4ZjIxMGJ2N2J1akZvbXNYT05EQXpIcjlWWWFscjZQM3ZMTFFrd0NDaFJs?=
 =?utf-8?B?WjY4bk9RWmk0SEhXVVdIeXhwQSs4eTZlZkJnaTAxTXVBRkI2YTAvUmFEejB1?=
 =?utf-8?B?eFZWMGR6Y1dSTDhGeHBHRFpTcm90blJNZm5qY0Y3dlArQXRmY0VJK3BsVUhs?=
 =?utf-8?B?b2xoNVdBWDl1UWg3S1BWMis0bnBVclRMUnJkNkJaZzgzeE5IbjFlTFYxQ2hH?=
 =?utf-8?B?NTQwL254NUMyOE1CMGtEdFA3Q1N2bG5kdkZzMTYyM2wzZ2NzUU80TkdLd3hv?=
 =?utf-8?B?L1phallsZXl2bWhUSWVLelZLMHVPZldaQm4rL240cnZ3ZlF1Uk5xc3FMNG1a?=
 =?utf-8?B?RTNkNThydGtORHBYTTdnUzFtNFJ6MW1ZSTdrNHlGeXRndStSZTJ5UFVHdHk1?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F29CBF13F044BC4486AADCC8040B3D6E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SEJiK01Wc1Zqbm9Odk43ZTJGRnNOMEEzVm94R1VtRGhaUmYzUGxhS3hGclJJ?=
 =?utf-8?B?N0Y5c3VPUkd4WUtoS0pCNnNuU1NSczcvQkthelZmMW9BR25Yck1DdG5yRVZB?=
 =?utf-8?B?WTkrSmpFVnVrbHgxK2lGQ1lhaEd1N09XZEIxYVNkUzVLenBQditkb0lUREha?=
 =?utf-8?B?ZERFRm9WRXlGOHltS2lVTkRoNnJlaTJSOXplLzVhcG1ZS1VtVUtCalh4aGUz?=
 =?utf-8?B?UzhBaWZqRkp0a3U0KzdhM040ZlJVTG9FbW9JZCtkeW1PNE1SQTJlV0xza0c0?=
 =?utf-8?B?L3Y0aW5JS2dqc1lrVkYyYVU2dFNrdGQzSzNxVnUzWFFYN2x0bk1BNWFZVVBh?=
 =?utf-8?B?R3dNd1kvcE5zZFJ3Y1JKcTFKR00rdEhZVVlxRkNvaisxV29PVFVqQzRJaGE0?=
 =?utf-8?B?a0lkWjNsaC9PQjhWWjFvR3pwOWhMbmNuNytIYXluK2JoMHFWM25RRTNtNzJW?=
 =?utf-8?B?bnBFbXUrTndsVDdLUmkzYURzSkxRQXVOY2VNbi9paWZBclF4dWV3SXBleGcz?=
 =?utf-8?B?bWpyeStZcGl6L0loNDg2NUZkd3Q2VzBMRndNdVk0NndpNGY0dk55Ukk5aXRR?=
 =?utf-8?B?bDdJRzRERHR1aG0xL1RUV1IvejRaTXorQUFOV3VZRDczS2ZWNjYyUEhCeEtH?=
 =?utf-8?B?WWluU0g0OUU3OUYzRzByUWRqSlE5TTBsc0hEZ0VTUlJydVd1Sngxc0lqaHcw?=
 =?utf-8?B?U0s1SmgxTEZuakVXaHRMbWtmOFJYTFhycWRweTFEZVZEMDlSU2ROUlBKUTFm?=
 =?utf-8?B?dTFzSmZSS3RhcytIU2NjRHp2MlNyWklSRDBuN1pnZEliN3ExaFlOdTJmS1Zr?=
 =?utf-8?B?YTlrVWoybEloa1FrWFliZ3RRQ00rNURFa3JtM1RJZmdTdnFSNHMzZW8wWDdp?=
 =?utf-8?B?QWlrVUtxZnJPVFBqRVkrK1BTeC84cnVENVhKTUdCbG9LRnQ0WkhKTnRiRnRQ?=
 =?utf-8?B?SXppZTFENXp5RDUzd2ljaHJsTG1haDRMeEdHSEkwOVZmSWdJdUVKbCtDOGNk?=
 =?utf-8?B?ZkpjVDdzUC90bkpscmNhWGdaUS81K0xmYXJlcE4zVnlQeDh1Wll3UnBaam1a?=
 =?utf-8?B?ZXgzcDlpdG15Zzk2ekZrOSt2NTA3LzNxcmM2SjlzUnljVjlHTHRySjV0emtl?=
 =?utf-8?B?N0F2M2tZY05IWFVYQUczNytVNHR3ZW0ydkpSeEUyMGd0Y1crZ3FhVVRiQ0dR?=
 =?utf-8?B?NXlhSTVPeENzVUdNaisyd29XRDZHLzZLWVNCNmYyREtFZmE4VGVwQm9jUlNC?=
 =?utf-8?Q?1IbYFKFnf2NgRRl?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB5951.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959fe42c-2576-43ca-1835-08db7b4bd280
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2023 22:29:38.6993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xmiP0gGvaHI4aG9ZRPRTGKmOvJCmoPJ/ExVF/LUaunoTHa6fM8UkwohztuRXuTFgqvV+WJ2bYZZz6L3SjCRgIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8996
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDE3OjM5ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToK
PiBJbiB2aXJ0YmxrX3Byb2JlX3pvbmVkX2RldmljZSgpLCBleGVjdXRlIGJsa19xdWV1ZV9jaHVu
a19zZWN0b3JzKCkgYW5kCj4gYmxrX3F1ZXVlX21heF96b25lX2FwcGVuZF9zZWN0b3JzKCkgdG8g
cmVzcGVjdGl2ZWx5IHNldCB0aGUgem9uZWQgZGV2aWNlCj4gem9uZSBzaXplIGFuZCBtYXhpbXVt
IHpvbmUgYXBwZW5kIHNlY3RvciBsaW1pdCBiZWZvcmUgZXhlY3V0aW5nCj4gYmxrX3JldmFsaWRh
dGVfZGlza196b25lcygpLiBUaGlzIGlzIHRvIGFsbG93IHRoZSBibG9jayBsYXllciB6b25lCj4g
cmVhdmxpZGF0aW9uIHRvIGNoZWNrIHRoZXNlIGRldmljZSBjaGFyYWN0ZXJpc3RpY3MgcHJpb3Ig
dG8gY2hlY2tpbmcgYWxsCj4gem9uZXMgb2YgdGhlIGRldmljZS4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBEYW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwub3JnPgoKTG9va3MgZ29vZC4KUmV2aWV3
ZWQtYnk6IERtaXRyeSBGb21pY2hldiA8ZG1pdHJ5LmZvbWljaGV2QHdkYy5jb20+Cgo+IC0tLQo+
IMKgZHJpdmVycy9ibG9jay92aXJ0aW9fYmxrLmMgfCAzNCArKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tLS0tCj4gwqAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTkgZGVs
ZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svdmlydGlvX2Jsay5jIGIv
ZHJpdmVycy9ibG9jay92aXJ0aW9fYmxrLmMKPiBpbmRleCBiNDczNThkYTkyYTIuLjFmZTAxMTY3
NmQwNyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL3ZpcnRpb19ibGsuYwo+ICsrKyBiL2Ry
aXZlcnMvYmxvY2svdmlydGlvX2Jsay5jCj4gQEAgLTc1MSw3ICs3NTEsNiBAQCBzdGF0aWMgaW50
IHZpcnRibGtfcHJvYmVfem9uZWRfZGV2aWNlKHN0cnVjdCB2aXJ0aW9fZGV2aWNlCj4gKnZkZXYs
Cj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHUzMiB2LCB3ZzsKPiDCoMKgwqDCoMKgwqDCoMKgdTgg
bW9kZWw7Cj4gLcKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqB2
aXJ0aW9fY3JlYWQodmRldiwgc3RydWN0IHZpcnRpb19ibGtfY29uZmlnLAo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgem9uZWQubW9kZWwsICZtb2RlbCk7Cj4gQEAg
LTgwNiw2ICs4MDUsNyBAQCBzdGF0aWMgaW50IHZpcnRibGtfcHJvYmVfem9uZWRfZGV2aWNlKHN0
cnVjdCB2aXJ0aW9fZGV2aWNlCj4gKnZkZXYsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgdmJsay0+em9uZV9zZWN0b3JzKTsKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PREVWOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4g
K8KgwqDCoMKgwqDCoMKgYmxrX3F1ZXVlX2NodW5rX3NlY3RvcnMocSwgdmJsay0+em9uZV9zZWN0
b3JzKTsKPiDCoMKgwqDCoMKgwqDCoMKgZGV2X2RiZygmdmRldi0+ZGV2LCAiem9uZSBzZWN0b3Jz
ID0gJXVcbiIsIHZibGstPnpvbmVfc2VjdG9ycyk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYg
KHZpcnRpb19oYXNfZmVhdHVyZSh2ZGV2LCBWSVJUSU9fQkxLX0ZfRElTQ0FSRCkpIHsKPiBAQCAt
ODE0LDI2ICs4MTQsMjIgQEAgc3RhdGljIGludCB2aXJ0YmxrX3Byb2JlX3pvbmVkX2RldmljZShz
dHJ1Y3QKPiB2aXJ0aW9fZGV2aWNlICp2ZGV2LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgYmxrX3F1ZXVlX21heF9kaXNjYXJkX3NlY3RvcnMocSwgMCk7Cj4gwqDCoMKgwqDCoMKg
wqDCoH0KPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHJldCA9IGJsa19yZXZhbGlkYXRlX2Rpc2tfem9u
ZXModmJsay0+ZGlzaywgTlVMTCk7Cj4gLcKgwqDCoMKgwqDCoMKgaWYgKCFyZXQpIHsKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmlydGlvX2NyZWFkKHZkZXYsIHN0cnVjdCB2aXJ0
aW9fYmxrX2NvbmZpZywKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHpvbmVkLm1heF9hcHBlbmRfc2VjdG9ycywgJnYpOwo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIXYpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl93YXJuKCZ2ZGV2LT5kZXYsICJ6ZXJvIG1heF9h
cHBlbmRfc2VjdG9ycwo+IHJlcG9ydGVkXG4iKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PREVWOwo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB9Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICgodiA8
PCBTRUNUT1JfU0hJRlQpIDwgd2cpIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGRldl9lcnIoJnZkZXYtPmRldiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAid3JpdGUgZ3JhbnVs
YXJpdHkgJXUgZXhjZWVkcwo+IG1heF9hcHBlbmRfc2VjdG9ycyAldSBsaW1pdFxuIiwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB3Zywgdik7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gLUVOT0RFVjsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+IC0K
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYmxrX3F1ZXVlX21heF96b25lX2FwcGVu
ZF9zZWN0b3JzKHEsIHYpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfZGJn
KCZ2ZGV2LT5kZXYsICJtYXggYXBwZW5kIHNlY3RvcnMgPSAldVxuIiwgdik7Cj4gK8KgwqDCoMKg
wqDCoMKgdmlydGlvX2NyZWFkKHZkZXYsIHN0cnVjdCB2aXJ0aW9fYmxrX2NvbmZpZywKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgem9uZWQubWF4X2FwcGVuZF9zZWN0
b3JzLCAmdik7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCF2KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGRldl93YXJuKCZ2ZGV2LT5kZXYsICJ6ZXJvIG1heF9hcHBlbmRfc2VjdG9y
cyByZXBvcnRlZFxuIik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAt
RU5PREVWOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqBpZiAoKHYgPDwgU0VD
VE9SX1NISUZUKSA8IHdnKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl9l
cnIoJnZkZXYtPmRldiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCJ3cml0ZSBncmFudWxhcml0eSAldSBleGNlZWRzIG1heF9hcHBlbmRfc2VjdG9ycyAl
dQo+IGxpbWl0XG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgd2csIHYpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVO
T0RFVjsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoGJsa19xdWV1ZV9tYXhf
em9uZV9hcHBlbmRfc2VjdG9ycyhxLCB2KTsKPiArwqDCoMKgwqDCoMKgwqBkZXZfZGJnKCZ2ZGV2
LT5kZXYsICJtYXggYXBwZW5kIHNlY3RvcnMgPSAldVxuIiwgdik7Cj4gwqAKPiAtwqDCoMKgwqDC
oMKgwqByZXR1cm4gcmV0Owo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBibGtfcmV2YWxpZGF0ZV9k
aXNrX3pvbmVzKHZibGstPmRpc2ssIE5VTEwpOwo+IMKgfQo+IMKgCj4gwqAjZWxzZQoK
