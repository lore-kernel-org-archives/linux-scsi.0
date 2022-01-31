Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AEEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376563AbiAaLkr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:40:47 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31577 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379186AbiAaLin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629123; x=1675165123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Zx/d4Flv55ZxTlaiCRsu3PicTF6PJCBpZS1Apq1rqBTfWDW8F37kePVh
   Px1KNMQL1emT3vpZmARi3AJIiwNaAWYGygPmGHjQj15UZRHTsuN0C+Qfv
   9AGw/DoEggIkdvJzMaKktCseSaEkTDgfWvSp8QvkVosc00W/EMW0vmBr9
   Er0wPAPhdD/PTdStrr3JCIx6xMvjs/6gHAASXLNn8Ck/q7WO7OL2T7kD3
   50K0XxpUFJ/fQhV3fNCE/Zyj+GOM8oxEWTfm7Ol5OYmijoDFb4JTJd4vf
   XAzpxvDQuiYTt3TxXjYGw+isHOCoz9UDPcsu9Ic9Vaw46PutoXeJ3nz89
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192789888"
Received: from mail-bn8nam08lp2048.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.48])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:38:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXVPYrKWt6pn4ZhVc6V/2adfAxHqOYP4QWN0us1zqkygLxQ6a5nk27errDlgfXoL9D/3zdQRj2YX2dopLHLYaH+2HXoTWWAEB5GTNy7XO/kV0bmgSEN+A8jKIF7RGB5eymPfQVC6DkMjaH/MOXi/gFB3J/phRcuehG6G2f7CJWgb3zuHA1VJ7V4WLDam2576QMJjxp0TvKKqJ/SwFr5MiirrzBp4Wo3vtDm8eC+6ft6W5YxxYD4sTah0tzi0zkv3q4wVV4qYn2K+6YiE1nmsShO/ivAoG4ZgMW8tvMHOHAHwQ8ohJInYTrtOpgkn4fj+1DikgO7Dk+Kg5biqYYnnSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=KZJy9MvLAjyf0cIuRRnYU59j/pB+zQKvO1vRmxeV9mmHG2cj2pRm5eQ9WwJ3PZiSEj0ovyEci8E/u9D88Rx7JuQf1Q0pKOYqUlO3pg7nymQZWGKIG3vaEvROTFaRDeVyEPb7u3wXqk/Z/Ipekeq/v02MEsDm994I0EtNM1tG2pc/BDilXJIl4uUhgB+NX4jXmf8ZHemSOwhczbOjFHah2xWeHJ3cZGKUNdi24CCdDgGP8oVKUe7Bj5YDNyY9ZUaw1kxQTC8rdS+fFdnMYdHO1c072YkNObGia47w0nsynnseGm1nHTYqd6Jzynk06LPZXzyZKw78AwLdV1+Rq40i7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=cUTatWWzFnvpFoBHma+zgBe0NJH7agTu6NVwq9ow+LBvCo7Irl2XxMWUpV5IF2k0ITufn9PbsirEs0w6NFtwynswqnGy6YrsvDI4orytf5bQqlK9GYsvG0Gl91MY0dTU8VBDKxl1DmC8/l6eebL+EWoPSDN6J7boC9T7CEXza4g=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5272.namprd04.prod.outlook.com (2603:10b6:a03:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 11:38:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:38:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 35/44] ppa: Move the SCSI pointer to private command data
Thread-Topic: [PATCH 35/44] ppa: Move the SCSI pointer to private command data
Thread-Index: AQHYFJWe9wI0myZbMUWGPXZzTHYu6qx9BQQA
Date:   Mon, 31 Jan 2022 11:38:41 +0000
Message-ID: <55f0eb83d8337ed5d164a5d904883e72a1a4ea61.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-36-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-36-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba36d585-232e-40ad-ffae-08d9e4ae3ad2
x-ms-traffictypediagnostic: BYAPR04MB5272:EE_
x-microsoft-antispam-prvs: <BYAPR04MB527205B49F7B5B78F17C53EE9B259@BYAPR04MB5272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1RLmC8m79AbLpX0m8uws1UB7woxIbtyUQxl/R2x+5ZtIjLZMIM+2zXfNOF9D6ytexJi/5ZhwKD1SgltkmEJ29BIm2+/hxQ7KUlwSXUwOYdtxwGTl/Esi5Ny1bZ/nnGApaKg5dfb78YCHRrYqxVhn2iIHJ0zrlHTJkbpoGN0xZR/VrwzEXVwYiW0Y6nn+0owcb6AK6r8TQJgVThybYmvWCxA/BIyrRPktQDMVhl0NQFmUX/JwDX5EgrF2M/MoDHnzUmfb43iUPd37DM+TuPLJ+0jQ8Bd64ZZFTIkbf3rJPW3yXejkUXOKbHbSb1L3MtN0GTXWEHzz4yusB2aXZjvhc7nTGRiZAR/xPkfO2cVMggH90JUcBiGUGGbb7M14JlL0Mb4piO4J5w0SXNRm9/VLKlf2Z1/Dz/tQhG4D9rQKAnLBtBBVvaA/61Yp/cG1FF0pQTQnNTwwX1vP0DpY8Ec+3dIRBM4o1q1+kGAgLzNvX6IpP4BfNwf5/S7dSDwnhkLj6cDUvcM5FZUv2yjC9pGt4dFVnIrdkb/7Z1jNepJwKWhI5wzIJ1H5aS8GIdzjbklNryxY/Wt80TCvYKArD2VmbNLWDPflE21Xinz77M4jtftzARj68y4qjtsRUU6XmKlHydLgUMXzB0Xc3JL9ml7TwhjsYN5E298mrC0DPNJxTWjgvkDRkXchs7mTc5nufCnj1bfi1YIUODwOyVeodN8T7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(110136005)(122000001)(36756003)(71200400001)(558084003)(26005)(508600001)(4270600006)(2616005)(86362001)(19618925003)(5660300002)(38070700005)(186003)(64756008)(76116006)(66446008)(66476007)(8936002)(4326008)(8676002)(82960400001)(6486002)(66946007)(38100700002)(6506007)(6512007)(91956017)(66556008)(2906002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUFqckxrZ2NvZGhWc095eFF6S092eFNQMGZBZEZuM1NVaTNac2FvY053YTNC?=
 =?utf-8?B?WUpSWXd3SGM4RDlndXpyV3hVRjYrV0YyMEx3c2pZbjVmQXRib01lZVhSVkdv?=
 =?utf-8?B?WVhDN3R5QmkrcVRIakFSUGZaTjEvVCtrRTd5ZnJQZ0FmVVdvdXpkb0xsQVFl?=
 =?utf-8?B?RlhzZ1NNN0xFWnNYZDNCM0lrejVBbEF1MzlsL3puUlJqQlRaVlA0am03amI4?=
 =?utf-8?B?ZDFTc01jYUk5VTlxS2FOTlA3VUg1amJ5ZGxhbk5jaUZYanA0V3hDMlA1cHdw?=
 =?utf-8?B?TFhpRjBjck9Ed2FNVUxKZUFWWDVTbGl5d2FHWk9TWVNhU0Q5UFdNbjhPUk9v?=
 =?utf-8?B?TjlNQjVCSFM1L213MXRyN1V1Y0lVaWhCSkpDNzFFRFcwOEF2YWVZYkFnUEt6?=
 =?utf-8?B?eE1SNnBlWitHM0VOR1ZPejY0T2NmZ0dzdklTZGh0SFhjdG1zUjBMRE4zTmdw?=
 =?utf-8?B?R1AzTFJtdFVGUEpybFNNdDVPNGtjOTVsMDBoVjcrV01kaXQzeFFZQ3p4Z1ha?=
 =?utf-8?B?bHhwUVJVODg0anB0cm1iUVV2WlZIYVZzY044VHZ4dmpIYVV6dU4vNnBnYzhv?=
 =?utf-8?B?UGhNRW9GS3hUUnI1dFkvZmdtdGh3anltRFBFc2ZKcDNWcDRxYTBZZnk2TFhy?=
 =?utf-8?B?SW5LNzRQQzQxVXhCTU11RUlBQ3U2Rk96Qm14T2NySlJUemQ4QlhUUGNHZ2sz?=
 =?utf-8?B?bkN4NFl6aVFpc2ZMbjFIYjh4N0FMd3B0Mi85S3RLSVpqZkd5Sm94Vitpdmx2?=
 =?utf-8?B?TW4wYTIxWGlrMmFjUFZtV3N6QmdDK2g4WWIwTGcwdHJvbTZNenQ2L1FSZjlZ?=
 =?utf-8?B?MTViWnIvdDUxaXRIZlZ5a0lJcWFSU1dqSjVXalh3SnVOaVRUWUNYWWRVRzBR?=
 =?utf-8?B?bVEwZ0czZHBWMmdCNTBYa3RZZWlTRkowMkQ3MFpjUEtNMzB2TUs4MVlGTXA5?=
 =?utf-8?B?aGY4Wk84WjRzdmJKODJNVVowZ2puZ0VxdTZ1Q1BsMFBJZEZQY2tMSUwwRDdR?=
 =?utf-8?B?SGdwM2hRTDBqenh5NjVpM0NoRXhJRjRnM2tvTDlMeFN0cjgzVlhyN1hCZnJz?=
 =?utf-8?B?bTIvM2pMSVZ1OEZzcFFOWWRIdU4xNEFORTRZbHVqQWhXalFWbnMwQ1Z2c0Nh?=
 =?utf-8?B?bWdUTCsrb0VuOWhkaHJLd2JKQVg5TmtGYU9KaElqeEUrS0QwcVh6YzN6dUJN?=
 =?utf-8?B?bzZ4U2VPSXM0T0prelA4cDlTTlVjSW9Rb2MyRFRrdTNxOEV6TSs2L2Fybk9C?=
 =?utf-8?B?dE1SaHdlVE44aVJNaXA2U2x3cXBWK2NJR2VZOFdTb211VzNGOFU2OWtzZFRs?=
 =?utf-8?B?V1pBbzdZV1U2Zlo1QjltM1BqcVErUldIRlFmL3c5bVpsYjZvNFp1ZU9BenMr?=
 =?utf-8?B?Z0VkcGNac0tYQm81NkRmVjd4RVpuVS82UG02RTZOdmxZN2x6SjRLeFZRRUlN?=
 =?utf-8?B?QkVsMk4yWVM4UlFrR3RFQy9xcVEvNUNqMW43dm9vUFFuZXdrZ01oNjNEb3M2?=
 =?utf-8?B?c2V0Tld6bkNxUUNmbEcyaFJoSW1LWHhabS9mTmVUUkJOV2s4NHQwcUhpYmg1?=
 =?utf-8?B?dXYySnJqLzE5bVZXVG5XQk5VWVhQY2VGcVJhNThrRXo4OXRQb0J4cGYxY3lX?=
 =?utf-8?B?V2NFZWFLTFZETlliNXVzd0xjMjRwZnBDMWR3TzlndVFrK2Q0aTN6YmpCZ1F4?=
 =?utf-8?B?UXZkNnNocUdpM1RxcjF5TjVmdy92eUpLUWdNNitjakZNTU1iNm0rQW5ZNlE2?=
 =?utf-8?B?blFLSURSaFlZbWpZMjlkcnYvTVBNV0xTeVdNWWRpYkNFVWE2bnB4bjUrTDBK?=
 =?utf-8?B?RndGUUNValBPQWhNMVpSTFphVXQvNGNPdTdXcHVHT2xFcXQ4MU9kWE5sUm53?=
 =?utf-8?B?ZDF0cnZPS1Uxd0ZncXNVTDkrMGpWc1AyQ1JRVUh3U0RwWlljV3NLMW1wWnVu?=
 =?utf-8?B?ajB1YTRTSFBML1RyZHZUUTExU3BHakNoZm9GVVA2N0ZaRUtUVDBOY1R6d3Rz?=
 =?utf-8?B?TVlSR1dkSFAxK0RMbjI1TGN1a1BiWEZveWtIc09rcThXdThTcDVjM1JjSDUx?=
 =?utf-8?B?Y3A4LzZZemR0Z2svQjdOVHlhVUtKV1ZOa3JYV2VpYlo2TEdUTVE4bG8yc2xS?=
 =?utf-8?B?NFJMOWRZTk95Z2Y1YlpOZHRHZy93ZGdFREU2Uk1qQUhkR2hPTmxmbzM0eEF4?=
 =?utf-8?B?Y1IxOUpMdGVhWm1WU1N4MVpGdk1rU0Naa05pNHJsWFhDVEhUSU1lZzhLMWhO?=
 =?utf-8?Q?65ov5mQWk1f9YUy3P02J+XGpeFJXJUrMVGdspMpbms=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <185307D73D0EB548B476140446C143F1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba36d585-232e-40ad-ffae-08d9e4ae3ad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:38:41.0891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JcRj5MJ/mvyN0ZeuWwOMlnulaFuyUzn4mb+oIsChUV6nTSg6STHZ8w41m30ttao3U288+lFFPkiRg1vK3sbbRHPfaYPtrYMAaQt6w4qwc0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
