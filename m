Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF71C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358188AbiAaKc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:32:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52483 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345599AbiAaKc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:32:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625148; x=1675161148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NHCuA+nUGqUFFh8VmF2jQMvZXn3Y9f63XGJONsn1g0g=;
  b=nJjqETLkj9cHQuzbB31NT8EOPx+4Iqto/l8skT/KOYkQjyiaPpvSyLVA
   O3D2s/YWnXjjccjZMvVh+JguvZ7Z/D1tzrA64TK1rpAR/dRKBvXaWyotV
   RjLD3Xbfp7HYYftCiNcrKtwaudpJG8Xw4N3qJ1mRYywUizS046VHwpJ70
   D560aIC8myu9Y9RwU+IltX7+Jm7hihOmavYMJqwl0FO1L11HEDRf7XXkA
   kQfnE0Gx1E8Y0M9Yd5iSPZLEb+xtbu6oD835lw67yCQfHY8mKf8xhEU8X
   Naawk7XuYrDPJy4SCW6y2tZgXqNLyWpaiCUuTP1IKSFfaEUOml6q+gwZ7
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192785606"
Received: from mail-bn1nam07lp2046.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:32:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwAdESq99AT22cDWqeQFjwjB3ZFM36mZ+3zKOFQChsI2M8r+P+ANvumI5Y6AKmgNvmWW22XmySYG6OK7Sn6LGmv3vZ81igSLNC1NT+ZiAPfhqzq+sEHquwTB1qmTb8pSSNQhC40Dy8lAISg23rrFNCTMCGe/+BpXK1JKVfS54fYLJVcUnVqcERyR0ym3SAkMsNGHQr20YuUQRUCSUVTNUdXIVWlaY+T4ampXYvYKbnWQNJI1Fz+3tiu3ZVlv5cetewKU3bhcb6vBJCL+FvAw709GDAk6AVv/gRZ5MnFRsvuq27yqYxzPnSg/1Lun2+Mk+19w/fr7ef4wxkPWJXq0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHCuA+nUGqUFFh8VmF2jQMvZXn3Y9f63XGJONsn1g0g=;
 b=ggHQy+OBuFO/DLemB83Q9fyzRizyZKifOSp5nDNdiClj42EafUORGgiXUdSujAyJbA3Y8+18NDBrS94QJ9+cWmJtpSEC2oWbJ4TenSw1yt/urpNZ+fRHZhCE+ThCndfUN2uMoGTSSajvMWcDGEcogsfNCGc/mMCSPlS6f7D0u5UZfqwXbWnPm923rLotAdHSWW5uAS5vi04wWuM0UiYZSdCZ8pOkY0ZYdj1igELIFT5by2UeMiJR6XA9paBHoAGVQuSYCOGlvkwY5HBI/mRYXmEDv9yeppdoIyuhXxLiOJOlNOoaFbwlXFM09tAAZSKYnG/G+ibNPYK/12WNQ9xtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHCuA+nUGqUFFh8VmF2jQMvZXn3Y9f63XGJONsn1g0g=;
 b=oeFz3hFItWd2fgGyKBCWmhVr6smKIdd/1gZIiQ1wNbq2fX0nQhcQH0blRSxeZExxCCdfAh9vctR83VVoaWU8/IjdXfRj+QubW5DiMhSSrf5ML9mMstEos1HI85CZwuwdzK/dIkspOtIbe2+PD7lYAuWTX7wze+PDnC7kR94Meh0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6689.namprd04.prod.outlook.com (2603:10b6:a03:228::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:32:23 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:32:23 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "fischer@norbit.de" <fischer@norbit.de>
Subject: Re: [PATCH 12/44] aha152x: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 12/44] aha152x: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJVaz6NzKSKhHEyDXQtCW+04X6x88n4A
Date:   Mon, 31 Jan 2022 10:32:23 +0000
Message-ID: <431c691634be06d6c97d15da8e6e53fcf580dfe3.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-13-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-13-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bca2108-c192-4132-b11c-08d9e4a4f818
x-ms-traffictypediagnostic: BY5PR04MB6689:EE_
x-microsoft-antispam-prvs: <BY5PR04MB66895A579AFF39239BC34E139B259@BY5PR04MB6689.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Yb7/rsTLgel/+TxidfjL2r7fSZrf4zgfag3fsEms+zNnML9oLpMQuZTlS5sKUMx2UiQYU/OXq7w9QUM4Uu1E9jiko4ILyIBR8D38q8KIS2EYvF8dqnFx/P2LBMcqpeew5npfs2x3F3XJjIdB758kOXIhQhuIsy57NuT0ZxiK2UFnwg824SPSWViGfLY0H/26IFD19a6WZci6wxsMEf+5dg39i6pL9dgAsPinlG1qmpxJM8KxqFd3rXmjB2oKEkpMa8lM4MmaUaN5hC/0nL9D1LMw+hwcRC92HzhHL5nDPUHAa80PMHs6tpYF19HbipmpmmlV749X3qHT2dMpd9J/uomQW28ufWip+SYuhWWeg3DIee6N/ilD7C+tu5XkiUx/GCcLAa2dt18DHvhSGGCAg+LoE98sRPR3FuLekOmrS4ommHrf8So2S3HR0vuAFo1xJu6S7n+kcoTPbo/1M86HjjlR6fTHH9rCIgrR6rWcvxhQvg/ShNd9qzXL6YjM4RLaN1dVbENx8gXY/viOiGvEBpwfZwvaMevg//aLxv1X42RQ3FOahJEdlytF/cOZbPgVo31GrkG8GB8P5Qn5lQ4/58PcVY49PD43s5O6jtgrfa31xAhw3aSoq1ZvT/bm2wy3OYiHH0F+t5F26RgL39khav/Ol6XCgim/JPlXw4oKLodcgGhC5GAVxRXMeSCJnf6YHwORAMRdB1Af4STrT/lpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(54906003)(91956017)(76116006)(5660300002)(316002)(508600001)(71200400001)(186003)(2616005)(26005)(6486002)(4744005)(110136005)(36756003)(8676002)(86362001)(2906002)(4326008)(38100700002)(38070700005)(64756008)(122000001)(66476007)(66446008)(82960400001)(66946007)(66556008)(8936002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1VzNi9iZC9VeWxpOW4wRzh0UE1WQ1F0ZUdJcUFXZWhwVVJlTko4K1pkUTlK?=
 =?utf-8?B?Y0gycllNOGo3eWlUd3hybUk3UUpvWFJSamJiaGpXTm1YM2MzcWNpam0wWVpM?=
 =?utf-8?B?RFBqanZERm5QOGpLMzMyNHppQmJMZ2treFV5ODNDNFlUZnhudXVYNTVhck53?=
 =?utf-8?B?OVRCVjZMYjV3VjRYY0xJd0dhSWZQdDFySG1sMzFtaEUvcTFBWXp5OEhsN2x0?=
 =?utf-8?B?WmhNWGxUcnRrdlF3cmZaa0NxTEtiVEk2UjlVbmJIT0h3WEczTGZRMTVnNTND?=
 =?utf-8?B?b25mSmJ2SExKOUh5Ykx2ZEo1R3BKV1dFY3JDTkZXTkdFaUljMk5yY2ZPcWhM?=
 =?utf-8?B?Q2tVTzZHeGQzbEVQYTJGb3hFcUpCblREMmtsTWNYN2R4V0xtSWRNL0RUU0x6?=
 =?utf-8?B?aWdobEV3eTRoNFR6dFlkMm5BbUVjblhzTTJINVg0VkNtL01zMk1FTmRaNzVB?=
 =?utf-8?B?Mm9HYXdpK2tJa1Z2aTBEdVZ0Q29Mak9hSVVOUWtvT0RXK0piQ3EvNDM3bGlE?=
 =?utf-8?B?MUZDcExTbUZZMmRnVFVmelNmRXJOZ2liWEFLZVBYbS9WWVJMUkt3VVZyZlpM?=
 =?utf-8?B?QlV0REx0OE1YWXJNNnV6b0oxUlNpWFdCUFBwdnN3eEFWcTFXNDlFQUdzcGh3?=
 =?utf-8?B?S0NVSG1NQ01HUUZOYlB1TnVvUFNyTEJub3FRWUxrajNEdnFyNlQ0M1NqS2Rx?=
 =?utf-8?B?MFlBVXpsWC9CN0RXajFhcVZuL0h3dktQMktWN0ZGNEJOUXpvcGpidnRRNCtF?=
 =?utf-8?B?UkZFVXpZTUJpM2lBWjFtSHBYRkhGTE1yNTdtKzcxNWN5bWlGVWE5c1VqeGht?=
 =?utf-8?B?K1A4RWloMXlCbGJlSHBHajV6OWdvWlk0U3pSTENZNXF3TDd4THYya0YweGRu?=
 =?utf-8?B?dUFXLzlNT0p2VGY2aC94cCt0d09kNjBSVHEyd014eWt6WVhFZjNlQ1NIekNM?=
 =?utf-8?B?b04zQXBmY0lMTUd3Um5sVGZVdzFKdVZ4WDZOTURvSVk1Q3JRejhDZzBYQ1Rk?=
 =?utf-8?B?K3l0ZjN3cSt0TmlHU1FrWWFVQ1dvYnlpd0FrK1JpREpCdWVHNlo3VFVoRkMv?=
 =?utf-8?B?SDFCcitWdC8vdlBhZWo5VnRkcjdmSmJhWHo4WjF0cVVmaU9yWjFRSEI2dCtm?=
 =?utf-8?B?ckgveFBIazdhbWlscTNXODRSTElpSS8zZitBRzY4dE1hMXc4VzJuNEczbXkx?=
 =?utf-8?B?S3M0TXRrUUtTK1BPeml6QStmZXFrN1dlZkRSVmhWSTRydHdMaU5LKytud25h?=
 =?utf-8?B?R1YwemVSMmU2UEF2WEgycjA1M2RSMUVrNk80RkpERjJkNXY0L1RiaS8rcHIz?=
 =?utf-8?B?cE80eEtyM3VGSGpFRWpKZ1RUVlozdVRaNTkxN2FSSE5uTVowamlJd3JZNGh2?=
 =?utf-8?B?YVh2bnIyazFPMzVVcVQ5RWpiaFlMT3UrQVlyVy9IVWl4RFQvZjc1MEdIc1pN?=
 =?utf-8?B?cGxFR2lsZUdiZlZna0N4b1hSay9EOU5YS1pIbGxORTNoTVkvL25jbld1M0Fi?=
 =?utf-8?B?NWNGUURGSFlHVi9BZUJEWEhxbUx0NWVxMG1mSGpWaW1lajZ2YW9VdmZaZ0Vu?=
 =?utf-8?B?d210U1ZSWHlZMHk2dXM1M09DQlJ1M090R3VtTURFSlRwZjBjdkpLTHZLcUZ3?=
 =?utf-8?B?OVE5d200UGk5NUwwZVVxem9vOEtEbmRNOGptcXZyVWsrQ2VRZG52K0NRYlp0?=
 =?utf-8?B?cFVaNWZKVkVUS2ZrbzZMQWZwWmU2ZXR3VGs3VUE3dFlUaXBXQmIxOGFzMTBt?=
 =?utf-8?B?Q2JCaWFON3RvNFJoT1I0L0xKdldWRXFoQUM5eFBYNE5vVDc3aEV4a05GekFN?=
 =?utf-8?B?bDMzZ25VOUQzQXBFRXNUOUNFeUhFMTRJNXhYRzJ4QU01aFlCMFlBYjRkREgy?=
 =?utf-8?B?NG1WdVJ6ekN2SVRRUVV1YlA3Z1VyQ0syK3VOU0EwMWZvcTRRVlpkakhsZVNl?=
 =?utf-8?B?Yng0SlB3bVFKSEUzWlNmYXF0QlZxYStKMTAxVFR5Z29kRlZLdVpWNzhMZllo?=
 =?utf-8?B?WTBVSUUxOVNuUHQwUGhuOGM0MHFha3RDNjNyb1pZSXRTRVJ5dDUxdEtTSC83?=
 =?utf-8?B?bzFnZUFUdGo1MDl0bllMdHJ0aWdHdU1LV2RkdnM0UGhRbjlxUklEcE9pWFJS?=
 =?utf-8?B?NXhQTjdKV3JzMHNGWjQrelcrZG5teGdwK0dqYXhDQnNsZWtNTXNLMGdOTGkw?=
 =?utf-8?B?Nk5NaVdReEZkcHRwN3ltK2FNTTMvVFNXWk94cGpvQ3NaZDdjVjAxaFBHcEU1?=
 =?utf-8?Q?8fcbTbGU9cpoOD+1vvaj1Y+WhYJ4vtwdN9Rk5Rvow0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFA89BD7F72DBF4395EF32B85B298EE8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bca2108-c192-4132-b11c-08d9e4a4f818
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:32:23.6534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSlUsYjTtSxZ/18ahrDljvCS6Vs5re5e2GXExHmvvahQLVb6aXfxzecSKozAukClIghriA49oJMLuPtorL5895HepVoafbCZ0ALdwdrqQzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6689
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDE0OjE4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChzY3NpX3BvaW50ZXItPnRoaXNf
cmVzaWR1YWw+MCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgd2hpbGUoZmlmb2RhdGE+MCAmJiBzY3NpX3BvaW50ZXItCj4gPnRoaXNfcmVzaWR1YWw+
MCkgewoKV2hpbGUgeW91J3JlIHRvdWNoaW5nIGl0IGFueXdheXMsIGNhbiB5b3UgcGxlYXNlIGFk
ZCBhIHNwYWNlIGFyb3VuZCB0aGUKZ3JlYXRlciB0aGFuIG9wZXJhdG9ycz8KClRoYW5rcyBhIGxv
dC4KCk90aGVyd2lzZSwKUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+Cg==
