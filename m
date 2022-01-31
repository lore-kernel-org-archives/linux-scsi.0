Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131FDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378075AbiAaLls (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:41:48 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53244 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359748AbiAaLj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:39:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629196; x=1675165196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=qoEw3u1EQgzX0ciqEvxrTMqC5I0SA2Wu7O6BqugSSkpzItmXcBxm106n
   LdGxdN0Zmpq4Dg/dsctEpffQjEKUpeJ5s2MimigQ/6i4LN0yROXTtiHve
   fQzJYaNSIdBlhy0YX7jxdYN3bUj0VI5kiNCbQDpYAEULzWMLuN71FwGW7
   FX0DRRdZUyh2MwLp2oIAaTCs0EFvvuFOP1Jagm0Xct2mhMPejc80Tl5Y6
   qMKMkBcXOQeoSyBMhY0agWXDLbzfeWNBhtnCxASCZJ1+cXtukHSus5rHr
   5ORIkUUVidi7ModOXWSANnA5lPdBG5AlE0DWJnqLijtdKRtAl3IgaFkIx
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303682634"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:39:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ3WaVXLxfpLBFwrX84IjsvjuxRVr7vLE6ZwbJfxitl1ZXhx07+kV1od5ajTbKkHtSJ3UQV8kf3qyxyyf4I7yOLBo4IvbIxf8lwVKX69TLpBUM4z+FfQyo+NNTTYFmNd3AAcgEvcUGeEFMY8OhYRduaDEQwEztts9jguC17d6WftCrZqUvTa7QPB3rm+P7O94ERaaNXJ7w45QrrSMpFAxEKd+xXODgSQBmVV1clzEq3o8O4J/Kact8XbOlDjeRSx0rAWqa16J98FdsZpdKeBfFXbwNvxke/56xgT4NZiY1sC9wPujRUC4UE3GA4d4YZn2aADOX1m+ggWw5vcnvDtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=To6mRuq4sZbG07K9jlFPrOREbB0LL1qDftbAU9zejt78S96x/DxqK66uZkcuUqWWW0HWmpEFkt25MPyTjBnCQPYLAk5CEFYSveZVesUJhoCR8Q6awEuq9gNsj3SWx+IacPi86OH+zoqXnwvjPkF4UE5R17AV6pNlu1GOfGRAHyLHvVBNgBfSxUhQMEb3SnH9a5zN84iZx1L/HDLAFnJJWbfeQ388PrSU385lSNDV40buXq1oC/14FyrjnCDl8pTA7Hl/PDwl4mIwOr1VDP2phGIAraJz+Y1SOsAjRNpeg+sNPlCqfa35VWQt/R3FeevhStX9FcPUEDAWUFT3tPvc9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=ztP11zaOeETNdYXOxeB8dv0+viN0hkRMAFakOPWa4cooG9JvrMVE7P+MFCLbMNd7aWAJ4rnyh/QUNmGj3TF10FUvc+PMVwEYKkXuRzJ8p3504h9SwtMhLGtaKj6zpVLE/UjtAfE9BsrxuFeI9g04EXfgsxnnt4+brKyTRMfxVW8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5272.namprd04.prod.outlook.com (2603:10b6:a03:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 11:39:52 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:39:52 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 36/44] qla1280: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 36/44] qla1280: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJWIO63hZdosTkKYE3xgezD6nax9BVoA
Date:   Mon, 31 Jan 2022 11:39:52 +0000
Message-ID: <52081c53e80ce0e1d724f6acfcef9da6303146ef.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-37-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-37-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23d85bde-30c4-449d-ae30-08d9e4ae6582
x-ms-traffictypediagnostic: BYAPR04MB5272:EE_
x-microsoft-antispam-prvs: <BYAPR04MB527287696A7A5CC4644D25969B259@BYAPR04MB5272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qiZT+jTj0C+YbHxdDJBNEKthkWYAIfaYRpY6a5zkbNCo6T9OBIyNKMKtOefqhgPwnosq/nTStM9D2qbSXJJdWNlx/yIArdcOgfKpFnHo8z4A668vdyTHPmMw1tXW+P+VpYZ9v5EmUq9qXKrs29NShQOKV1uCHmM1Vb+pnthT3ZCq5U0nyH0mSPNaJoSAuTKaRASu40i3nbSkvnizilCdY36xDJGTh/KlCsARSqgrZiUut2Dlw5O5AkwnUzz19MT3cu33nZstkVnlfvPDoZkfy226mtT3cTMWfsFUTI5inJhoARFWE3eOLxXJ/LsiLp+djEZOOEmAulaXh7tKvPzJ+6CQ590k8rxedfh54PaZLrQNsdKmIDXRjcrxN1Yw9uA+KhlU190Vls4SvKxUaVJ2Gn7EGkL++BJ6hitLEvE89iFDTNDXrUoiSYkc/G10MHdngAqSEw14TsjG/HNqa0kuN7gNMLoyDsCjeY+SgRCZzzIMrLcrAP1PyY4Zrurc3ETagnmKhIddHNVpEAkd0lTWlaw01dQOAQ92DL9M0Mb2VfNRV8k/Qtbkq5aZFCkt2hqCZhX8/fQnM0Z5FQVEwoVoREcTUaTjbV/ruU3G+QTKbzvaaB8hrN+VMpRdIOITxHa0KNyRbIcVGQ99xegcYRuN/YbSxSZqogMpqJxBYd1g4NSbusMPzPffSRNgJh2Y2s9ZYKxVeuAaTll8DdZitGR1VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(110136005)(122000001)(36756003)(71200400001)(558084003)(26005)(508600001)(4270600006)(2616005)(86362001)(19618925003)(5660300002)(38070700005)(186003)(64756008)(76116006)(66446008)(66476007)(8936002)(4326008)(8676002)(82960400001)(6486002)(66946007)(38100700002)(6506007)(6512007)(91956017)(66556008)(2906002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHV3elBGd3Q3WDRZUDdPRWllbThXaHVRTXdZdU1YYkJ4T0d4T0xaS0pKT1Rr?=
 =?utf-8?B?UnQyQU5qUG1pQ1NjMjM5bUtrZ2g5Vlp2OWRKTVBJeG93S25HMzdRNlhicWo5?=
 =?utf-8?B?TzduRUx2NlFWTzRoQkhzN2kwVUJUb3lGWkM0RHVERGpLVGZiOVVDZ2FUWEZh?=
 =?utf-8?B?SndlWHVCdEZXZ0NodW45Rk5ERVNJZkc0U2RuVHFNSFY1YjdGdEUwVVdYTFJM?=
 =?utf-8?B?eFNjVllacjFuNGwzQXNVaVN4cEQ1MmYxODF0cTZ1ampXL1N2d3hEazExYXhU?=
 =?utf-8?B?TkNraTNVakVXMzE1K1pLcnY3RUJZS3g4MldydGoyeGZNR3VpWW1CSFFWMWpy?=
 =?utf-8?B?SWRpTmR6cU1lNVFYa0dNdFFManVSQmFZNVdobDZGSHNXbFNmS0RwQVlrcjk0?=
 =?utf-8?B?OVRSWEx6MWNiRnlRU0loOUFZV2FkNDJqUG9Pa3dpT2lUdndHOTFsVzBwMjND?=
 =?utf-8?B?K25XOUJJS1FUdkhCVlpUalpwWW90ZUF0VGlTdmVsWGdDSVJjRGpQUDBVK0dp?=
 =?utf-8?B?WFlBb2l5b3g2a0hkQnY4Ky8xY0NtMHdzQ2dIQTVwb1ZiVENNcEdJTkdNdktO?=
 =?utf-8?B?ZFlUVjRRcndNc1cveFdRN3krb0xDSkhzbWswTUFxR0N0SU8xRDYrWm5iK3h0?=
 =?utf-8?B?Mkp2am5FZlp6ejdtU2IvTFUwVll3K3VFSXNhcWFMVVhHcGx4cDg4Sy9oNEM0?=
 =?utf-8?B?U2lNZTh2Q0o1ajJYaktXMGhKVERmWm9jK3YxM0tZeVN0aW1tRkk3RVZlRjNz?=
 =?utf-8?B?UDJNV3lxNERyZkhZMTJLODFLUndONGovU0xINnpPaEQ3WEhZTkVCUXFSdEtm?=
 =?utf-8?B?cWpYN2xKVW5YMDJYU0hCKzM4YmtucU9vODc0VHFBTUl2TDd4MzNPeERkU3Fi?=
 =?utf-8?B?UEJ4YVNxTkp2bGJodkFZeGdtZDlFU0Rzd3J4aldUS3A3ZXpKOEtDSUg4YTFL?=
 =?utf-8?B?d3o0clNVMWwxNFJiR2hOVTk0aEIzZFl0YmVkOS9lMDhJRlAzeEFhRFhPZXZW?=
 =?utf-8?B?VXlFTFVRWnZ4VWpSMWZMU3E0dVEvVVArRXNtbjdUYlVTMnJkZ1dUWS9LVVlz?=
 =?utf-8?B?cW1jbmNPa2VhcHgxTVJEK0FJeFhZZ25vR0hTZkxzdndNSFhKblVKQ3BHbkFp?=
 =?utf-8?B?UUZYSjF4VU56cTdVcE1oZzZlQXhVa08vd3d1Wm55cGwyRXkyU3BuYmd0bDVN?=
 =?utf-8?B?OGZFWVZIZEhMUjB4U3ZRWFRSWjlXcUI3cnl2UlNiUjNPR0J1MGxrSmhONjgr?=
 =?utf-8?B?UmhiUVNIWEEwUEszNWtwOC90azlvTW9CanRVMlZoaC80MW9OZ1NJd09TTlpj?=
 =?utf-8?B?WW9FM3dUNDYzR1g4RkMvY0dUdERteTJNODNZUjVLRDFsaDNmOEdwbW9BMVRH?=
 =?utf-8?B?NkVvRzhVbUdSLzRKVkZJeFhBSlNJVUpZVlZIelB3OE1LbStaT0NQNnpEYmNW?=
 =?utf-8?B?WjZYV2w2M2NuSnN2NVgwS1k3R2IrNDNCczBab2ZzU24xV1BJRStxMFQrdHU4?=
 =?utf-8?B?bTF4SnFrTnZZM1RjWEprYUhjZzJDWVVlRGtPTlBmSUI2Qzl4YXhOQmNjOHNw?=
 =?utf-8?B?ckNjbUVnT2RvUWpsYjRhck9pN1gwQnc2MlNmdlIwMGN4Ukd2T2FGZVN3eDdD?=
 =?utf-8?B?aStvMEJ2a2d6YWtONjNnbXJuTkN3QVZZdk05bm9PUytlU2hmcC9TcEdKUzMr?=
 =?utf-8?B?VjVmTVh1REgrN3NTUkNHRHBLNnFQQ0tody9pYnVKZnNJa3VydW5SMTBLV0hu?=
 =?utf-8?B?dlBWa3pOS3p0SkZWakd0djNGSFVCSGd1YTA0Uys1ZDJ0RFU5cENUbHNVQlRn?=
 =?utf-8?B?YnZBMkM4ZlBMRUMrc085QlBJREZMZFl6ZDVuMXphaDkwVzFaZlhtMzV3dWNm?=
 =?utf-8?B?WE5zNWZrcUc2anlKMStVRVhaam5udm1qeVg0QU1VS0F6TkVCNGQvcGVnZlpD?=
 =?utf-8?B?alRiUFRBZDd5YzRwa2FWQklMRFR1bXc5cXhoWXJwV0x6c3FHbXNtR2I4QnUr?=
 =?utf-8?B?RFpSbXFRWnFtYitqQjViRVJBWStDamE4VnJUcjY3bmpJeU4wNURNWkJRaW10?=
 =?utf-8?B?MExqZzYxengyL0NEaXFvQ3czMXI3eVZudUJRMkc1V3pBcGNrTFlGR2hwTmRE?=
 =?utf-8?B?dDNmSWxrVXJRWUNUcjQzamo5YVMwR0xJR0tyNDBaSFd6dGk5MWFDQmphdjl1?=
 =?utf-8?B?MHFNNjlEMGwzZUYyTUlaeGE2bVpTRFAwQVp0U0RMUlZwYUVZVGIvUTFLZXBo?=
 =?utf-8?Q?v8LGBlcmVwcAitxtd62NTMCU4smtYyUARxeoUsMpR8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47F342B656D62144A347E35F14DEAF9F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d85bde-30c4-449d-ae30-08d9e4ae6582
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:39:52.6735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LDPn3OCDDy4Ov+3NpThKW6P/CjZBaZOuqPsclC/LIAmtjcEzoWOFlMy/CmEdeI+hHgVXu7T31OkNZrci+0MYRPSSnvozbitdhn6l5RNOAPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
