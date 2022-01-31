Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4516BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358307AbiAaKo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:44:57 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5269 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358150AbiAaKo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:44:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625897; x=1675161897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=ht1l2oohOzSjiq0eM/ntSiEl5fmA84BR2EYfi1g9pg3osXs5sNBnvV4k
   CuK2nTXXZxWiWvdGsM312YZ+X+wtzY9VRcsnXN/cls25wiGKr8ZWDG1xa
   wCdtFUhLBvEWR3ncrmss0FmxnB8dbfjIvFiFrfxDYcs3mRQhEco1hoh0N
   aqHcI2cwKtV7wMOln+9+2BWpjhWXc5BC1yyzT6EMipg0LtyfSMprmzqbO
   OSN8i96oCxzeyWrG2hhkBif7n183jjyYk/2uKq9VDgMZ345OmTdXmfv+Q
   7mVptV22cO1iObDv/GNMP36dRLSsJxTzXN9Bg3n56WhKnZod9haSLwRki
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190744272"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:44:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq+k1mXtfpLaHPYLs2VrMlCuvLnAkPv23IGVasjY7qTKQgrXRhk9VWddFpu2aqz7+I740BzOwvWwX+aAXg4ni2cCJgwfFjh1BAx+Tl28byky6Bs4im+o/niHVk7anBatNkn2gSnofnpZ+QQAQcg78IMKHaCfaduNOqk3VTem5qkbsiwGJVXdTze+yQZWKEIIf4V5rh/JQaoR8/LdDwtBb4koFqVPpqLLKgjPdepfUw5jbBWgu2KrI2vV1hPo4omkUUdmwl3uJdk76mpKlHdoHcJaqbF3V5YHcwER/KLi4gnIQAVIFCvDfJulclDGsNocOJkrZ8IJGkQOoOZd4vMo6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Jt0poAW64jGpTdmSeC+XDQLxkhSM45bgeRrZqUf0cuL/pRbtDXlMe5mA8nR4J4sBoZaT5q20kz6K9NBGmLbDfcL0+9hNTHhgtlC6Ud8FZtuDtl+bURz5fCjFpAQ3o6Gtpgqv3LB5238DWx7r8R7nfhw+Ix6g9xlsQ4dY+CqiX7dcD8Eax8odQYn96RtQXpUIIKSC6n6JJEwJV5jQoImbwP0YKA60gL6PIr0xHLHgKYb0sFGwopcp8RAgjibx/aaJw2OYfGfLoBOsmUP6PF74YbpgKqOFkQFgNZDwqAcuMrkXyn9TiR99KF1YdfIIZ5KWncYP4ZaHRP+9YDNzphYXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=mQ7ddPTAV9OhhDUbeMVKu0aQ9Pm00EigSXZikyywMjTfWKCdnDXOuDMB0QVDAg4Q4vdoxkOCgwRUo06jgUVGLsKPKH9qwH2qGa0tXIWESYqspZEKHhTYFffA8mVdm2NWKPQYOOjgF917BA2cE2KtmgBB2z60KsQf+9a/AJTIHKI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN6PR04MB0226.namprd04.prod.outlook.com (2603:10b6:404:17::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:44:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:44:54 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 17/44] fdomain: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 17/44] fdomain: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJVmGFCfbFrZX0Cj2y0GTt3N9ax89f2A
Date:   Mon, 31 Jan 2022 10:44:54 +0000
Message-ID: <5bc1256dba325ebbaa7f0bf9f894b20273b5e9f6.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-18-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-18-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b35e7e5e-b905-462c-9bb3-08d9e4a6b78b
x-ms-traffictypediagnostic: BN6PR04MB0226:EE_
x-microsoft-antispam-prvs: <BN6PR04MB0226E95F83C7A6F9B8F4508E9B259@BN6PR04MB0226.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eBHwgSw0Rcf43MwRL5JqPTGcb6qp6UJ2dcukfdl7BO05j2YLn26rx5c4YST1K05f+aSkjK4l6BPbF9kSUwzbhQQySdGwmvT5hj3cGQuhkuUhcvnDYVDyEWjDCwHOoRzhyJPx5NatnG8ZsqdKJUr8GSezMyNFxbojzNMq5hObcWLqCvbn2SsIZB2+4c8He/bn+0ovh8/iSeQaKOiXVhCBm02h79JO7b9zsh6S7MTVb2Xcdivzer3Ia4e7xsO3g9vfevWDF1c1RPQsnQdV59YYs45sMFYIZW5LW3DTqYC4HDD24aJtNxgCRUrHqJGOeUbdIR9P9pTAtvoKBbNVzyqOJb9jK+SiiZb9Z9cuFcRXaeKv3WPT8KGnoAXG3YDw7Qw3eqDJ+kewrHGLD5shinocZUYcFSBkPRlL2LAd3nRMaVmZr4JOSNW76tu5kIUskQeLgV/WfNUmDJrcPbTpV+Wi2RlEW85C/fjfckItgvvJ8WgI8CZXTZKx+UZpSC9Nm/5NDpfSQdY9yI8BxeplPRox4mk3+oJHr9c8zhH4I+9Qv6FN+OTP3tTrxiAA4EsE8bafFteAQJHIrYi662ikJuf3RghWAWtw07PvKTexr23DCf/dSWL5Uclb5X7KLyq+7v6Cw5yaM0h01n/c00JFOtT6qMqc4hHNIeh6l0E4lpKVwKtfyvpQBQu6pSgi9eIsWHfiR4ZpmYkVUtqQYpC8alTtoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(6512007)(186003)(26005)(19618925003)(4270600006)(558084003)(2906002)(2616005)(122000001)(66556008)(38070700005)(86362001)(316002)(91956017)(66476007)(38100700002)(6486002)(54906003)(110136005)(71200400001)(82960400001)(508600001)(4326008)(36756003)(8676002)(8936002)(76116006)(66946007)(64756008)(66446008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z01pQU90SXhXU0VZSTJQY1FGWjYwM3M3bFh5OXRzd0k3MFVWbDNCMTRSTVZY?=
 =?utf-8?B?VFRHcEErS2JnMEdtVjl1V0ozWXc1RUh2eGZNSHJpOUJoR3VxbGczdEpkbHdE?=
 =?utf-8?B?cG53UERkVmlqbEhObFhkaDhXMWZpaVcwM1N4VkVSMjFFY25nSEtpbGU3UHRT?=
 =?utf-8?B?RkNIdWhQRVR5UkdYcG11WGJUam4xV0FxS3pUWHg4SHgyNFAyT2lmaFg3eFFC?=
 =?utf-8?B?UDVUaCthcjVFanRjaG9SSC9Sd0ljQzBJMUhtYUloZnlFZkdUT0NUWG1OTlRq?=
 =?utf-8?B?ZDlkQ0x2ajVsWDNSQTZDVDBORUJNU0hTODFUcTFNSitUZENGclJpZ0dFUTA5?=
 =?utf-8?B?QjFQNElDZElocTF3NHlJbFdJdWxrbGpNSHh4UTNnOUQ2bXMvSnJXOG00UGlB?=
 =?utf-8?B?MHVaQkRrRy9PZEtwdGd6TjBiYk9LY0Z2dXFtc05SVWlVUTRrNkNlMEliVmNT?=
 =?utf-8?B?T2RveGFpV29xWjdmdHlqOVI2Q09BYTBIZzBoc2s3bTVyWGNFR3lVRGg2eVZJ?=
 =?utf-8?B?anVTNWRWbm50UWJLcDdRdnlTL1pnMkhOUTJvM0tGVDZFRm1semkyZXRzckFU?=
 =?utf-8?B?SEFUUmdHK3pycjdVTjlBRDMzZVNQNkRyWllSRTh6ZjNwN0w3K2pxbS8rSU8x?=
 =?utf-8?B?ZTBKVG52WVdVMThuenowYnY0NFN5ZzAyOEdUREp2dGJCWFh5VVMzMFRUVEk1?=
 =?utf-8?B?QmlMeEprRlJ1VWp2VWgrWmt5YkhJRVdsU2lUUVowOEFwSEx3MkE4WGJ6TTJH?=
 =?utf-8?B?ZGplZ1BsQWoxWmxjaTRzU0E2QXpwdnVmVjZsNG1sa2k4UVlPZFVsYUtLWHhM?=
 =?utf-8?B?WXFWbmhsc1BmajRmQUFyQ3JZTXdPMFl4Vm55VDI2b3Nrd0RiNGNNNjhlQlZR?=
 =?utf-8?B?YUJxMDBTRDRGbG00UXFUbnZRUmV1aStvR2NUbFF1SXdWZE5SZXM2bUt3MlZ6?=
 =?utf-8?B?RnlNN3orUGV1Z2QrZ2Y2RE5yRWo2RnRkNHFSVWRhdHY5WXpFczA5QXhNb1Y2?=
 =?utf-8?B?c3FWTThRVWFFVC8zY2tQK3lXOHFvZ2REY1QvTkdTdVZFRHdJUkRDSGlTNGcy?=
 =?utf-8?B?ZjJocVF6V2JpdlVHRVNnWkUzUURwa2pDajh3U0NjSFNxSUxNZDFLOEd1R0dq?=
 =?utf-8?B?cU50UEpmRU9LOE81VmYxVXd0RS9pRTFXWGdtRjdxV3c0UlRXUU1qb3U5YXM0?=
 =?utf-8?B?V0xjSVpZcno4RlVDVFZaY2xjT09ZWFJTRXN6SmR6bTVPWlRERmZXVmNrZjhi?=
 =?utf-8?B?MnRqaEwzZkZBNGpvd1ZMQlRwRlNIclowL0czUldoWGJubWM4amhUTEpBMGNL?=
 =?utf-8?B?OXh5Y3QwQ3dkeTVMRktDVG9kaXBaRzZTdWs0UzdXdkJ3U0FhUzFqTUsyanM3?=
 =?utf-8?B?WWZqRk9tMjR5d2YzdXFPRHNzSTFOeGoxaFJlbThRYVJSazFOQys5NEhLWnRZ?=
 =?utf-8?B?N1BRQjRwNlZ0N0thZ0lmWEt6L1hjdjFPL28yeVF5aFZndkhtamYyZVNha1ZC?=
 =?utf-8?B?UnZFLzhBS1k3bDB1ZGI1WVd1Qm5Ob1c4cW13Z0h2YUVKdm80cHRtdU9CTWY2?=
 =?utf-8?B?cHE1MTNkRXliR3ZielJDRXdtTmtHMG40dnJBZGRqT0xlbkxHU1BVZWFwMzJ0?=
 =?utf-8?B?VnVGQmR3b2d4ME9nM0ZqNVc2R0xqNDhVa2pHalJKYVpsS2FrM3dHdTN6UDQy?=
 =?utf-8?B?OEZTUDlMUVd0a0Zwb3VyN2cxWWwwOWU3YnUxMFJ2WFN5VDJaZGdrb255VWp1?=
 =?utf-8?B?QnJVM01PSUxaSVBTZnZ4Mk4xeEhZMWZKdzY5VVdpd1hFRXNjRWdGZ0I5MjBl?=
 =?utf-8?B?UUFxNitzcnRHUUY3MmRVRHFGM1lOODF3WGZVLzB1Y002d0w5VmlqWncrc0t6?=
 =?utf-8?B?Z01EVnRJNlpTUGVxS3k4U2FIcEpKbGFSWEYzeTNDZUY0MThtTGxnMTVoSUNE?=
 =?utf-8?B?eGNMM1VQVUdPTk4yRDJCbS9kQmVzMWJqVU1mVVVjNWtxZ1EzSmpIVVdMY0ow?=
 =?utf-8?B?cTVGejJGa3ZWZU1weVFnVFVkQ1YxMFhsMU53VFB4OGZGWkZUNHZ2b2pPQ2Vk?=
 =?utf-8?B?elhvYUNyUUk2V3hwcFN4VXkzU093Y1NuK3RMVklXVDlaUm9VekJ6VFVobFVh?=
 =?utf-8?B?b0FrZUYvcnBLZXBBeDRhbUNWZFNEL2ZSeUF4TnIydTloTlVqWkZKYkNWWXc2?=
 =?utf-8?B?OERjanZycU1zUTdxbTlIUlpmckFXaEJiR0Yzb05ucTN2RWZ1b1JZVHk3ME1N?=
 =?utf-8?Q?Gij/LnGQuJXwxTKKmNoOIQZPLaBkRr+kdamwMCIkCQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F4B2A275ABF3F45AB82AB347B7F52A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35e7e5e-b905-462c-9bb3-08d9e4a6b78b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:44:54.3469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3V+UbHqjG9HVfQZ5iw+rrAY9nvLN/iOHQwI2qk5HIQNRc3mmq8HeaVINtXjhHf4xIK+TG13udhJ/B8C47LeXQ8NesChSelr1+ERo2ZB2KWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0226
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
