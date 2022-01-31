Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB656C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350669AbiAaLqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:46:20 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40134 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377550AbiAaLl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629289; x=1675165289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=a0zIFPea/Rp2S4sMPAUrBwPea59gmnDTUiGL9J5raGqvAQXpHTRNHcaP
   187qguLRg7hbKcyeoj/Xztf4bibjh433LXjLCIvJvSDO0L8QzsU3wxVSc
   RMzLkT/VVbhmzJNR4Yhgb1HQHt68BzkcMESs0blMVs3KtPV3lKy6J93Gi
   c3clmp6a6pWGySaqCD2l9EUtPBv6vjjFTBjwDDvQhu9mh4UVpGwvd7rWl
   cmvYVTrMUD6rwcy184fo8W0t37DxI3pkE0VGFhG6dMjiKMwbQ8G+5ISJD
   1UTFIGwVX4U0dMak3/LYQWqZod3cFispXGKyUdMndEurdjYE8yBjTXict
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295880056"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:41:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm63Py4/LoKE4kT1HdaXYVKXbn8TYABV0yy3JFHrfTkLJF2i3ATVyhOxYfrOwhf6YEnfSeruHDIWfO9+iWtnWXGtR5Ny5v27AnrE+FpkFCbDMMweIm7LlzxvPTmU9fgZ8IwEAArKEhXsbhn2Eq8Is0+Up7JGX7lkGZopxezhWQgqZ0w52INiWs07KAlIPEW8h/7ak+3IndXbdML+rCUybUuFRJxP2qNEBlEHqIZjtJmwX54MuQH0ClU/Hug+BqLMaqaxt6Q0DRcBRymG/Sgstj/g5NnoA/NRHeTGOmFf56UGJ+xGvvn1jagcH3PsHKJS5MEZRL/QLN/u+ni3FAif/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=BBkNDP4/XgQWsmbgZP1xzSJaAjeBIxtYoNid04/M0TcjERKp6ZPPHagfYLBa+9WJbFjE9TGVXyPeK/9Hnc4U/mrY35j421QGEP/NWibu4AOtEpjcUjYaMOaLjWxjkjq+9uPK6in8/5qPRQdqpGHGPY1GeTb/3nQDFbe7XAlXs0QZz4gNEgt7ZIMi79gBhG2922jhE8epNeBYleKgogkyiB6iKOGLh/x+KqS83NfjqYAgMPeB3mUsLXk1dDzP51gFn5YWt5QhZ0cRdyy6WFvK5cqYavWwYqxy8f71k4V7nvwmKPGjmDuwtvN2CbGgN7QMzxtISq7gZR+aZnQvZGn2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=JvO1oSBM0wUJ4hPCLQUMKf2xySkF9XlGEhqHz3UdycJ6C3Bfy5H2+ARF2rumsgVdbZMeNG2gN6OMzKJV1d2YE3uY/s6jfdLbkiGljFepM7jiYcp6cykRc1IWBnayAuodELiJJMeu2OAPIbyoPeItvMxDQAQ8w+g78cVSorLixb0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB3829.namprd04.prod.outlook.com (2603:10b6:a02:ab::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 11:41:26 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:41:26 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "don.brace@microchip.com" <don.brace@microchip.com>
Subject: Re: [PATCH 38/44] smartpqi: Stop using the SCSI pointer
Thread-Topic: [PATCH 38/44] smartpqi: Stop using the SCSI pointer
Thread-Index: AQHYFJWBAucym7GqgkOMen8qXpJr6Kx9BcoA
Date:   Mon, 31 Jan 2022 11:41:26 +0000
Message-ID: <7d6eb50f4b495207c346f7bf736b7bc4c5551a0c.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-39-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-39-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c3b2c7d-d588-488b-18d9-08d9e4ae9d84
x-ms-traffictypediagnostic: BYAPR04MB3829:EE_
x-microsoft-antispam-prvs: <BYAPR04MB382999C37038F4DD08701CFA9B259@BYAPR04MB3829.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fsbSlA6ABoXXzIG7OgRMNQJp8Hkuml7KCm/0EWo+xsPYN5xwswFFPsvUAXKxxldr2fK+xbusGovM+P9lQuI14O7kEaD7OkxB0OMi1/5KiYLmyTly+RL5lBjZjZ9hdENHtn6e2dDBM4eGlGLzvIwaOfDDaGlVIskeYfWQ8AGtKoGRb+Eg+dGErn0rMsoR9E8GHNnBE0cuMOgJ9XmkwxuJoDxW1KdsGLzuhHGXpCHJtBLuuHZhmXesqCWDa0Wr9o/umq7WwhFlBuDebCT7bTyXQHve3yfyAq/6naeq8Whup92ZdZ1vYMJbB07n58hUHV3LXT+5DyJ+hgLKySJJhTvtELnD00fCPKEZ5pbXnCNg2RncDfZTeJVSsKuNaL9dqCPj0/77fCKcb9FuaHBaZ6mru+rfnzLhVDHy08ahPQ1I5Tmbe9zfZJJ/ZAapI8f9unt6m+wkbMypTz3tJiPk2P5fOu7xwTEZ4KANAob12nLWA/9/nE1cn3QTdYQ83ZQ/7itbmyN0fTvl36jQfBkEzzxQc5f1AWPBA5fBDNrpkclt5gwDbw8K3Ra8HOLYm0+hGS/mSZhKlZZVu4G2oWZTYOUyM7hyf0n0WZZT4xMCToajRZdhNjM+PXXfafxtnCa7ob7uEUsJJbiRazVUV+9rGvwQUjerSwYAC/dBruUjladDyqdQi1uLSEqiAU0/KF69YQeD6UDyI9RNbI11ftDdiibYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(19618925003)(82960400001)(38070700005)(2906002)(122000001)(6506007)(6512007)(316002)(71200400001)(6486002)(54906003)(508600001)(26005)(8676002)(4326008)(8936002)(64756008)(110136005)(4270600006)(186003)(2616005)(66946007)(66556008)(66446008)(66476007)(91956017)(76116006)(86362001)(36756003)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGZTRDNDeWxFWWtueFBiMXdrY0daT0Roc1MyOWVQeElQSG9rODY4MnppTkRn?=
 =?utf-8?B?OVRlbXRUVm1ZUW5VMS9IRVlPLzlnMVl1TFJSbndUcmUza3ExZTVMVHl1cnN4?=
 =?utf-8?B?aC9EcnRTeFpIcmRTWWo1VDQzUFpuMWRCRGxTQkRqM25vZDBpOFBuaFl2cmhV?=
 =?utf-8?B?eHYyb3BnZTBDZDlVb0t3ZHZVNjA4UVViVitTWkZDR3N1WE9MVnZISUc5aGg2?=
 =?utf-8?B?b0xEMFRyOXJWL24zVndkTG5GT01tRkp4d0ZySGVqWDJMU0F1UzIvRURIcTNQ?=
 =?utf-8?B?eUUvc0pBcy82WlRuMDQxSGwrZTZlaVdRT3V2TGJ4QTdsV0dSeWJYNU9RaU1o?=
 =?utf-8?B?Z3lES1A5UlZMRXR1bWRSeTQ4ZjdnbW1tM0pBeUlJRmQvbExBK204Tk1na1k0?=
 =?utf-8?B?cTZzbk9mTVNpK04vYkJPUVc5SlZyM2ZzOUdLanBjMkRYNzIwL3dtMjN0aVJY?=
 =?utf-8?B?Y0FheE1qUkxoOUdFMnJFSGxiSXl0N2tsS3pQdFRPblQwNzg0ZG9aWjFkZ2cz?=
 =?utf-8?B?amJKQjRwTU9MZC9IVzB2TWdQQzdVNkJINFBrZCtTVXhyblVzZk5oY0VHUXho?=
 =?utf-8?B?Z2kvNHN6c1duM1l4UE5ITUkrU2dvdjhqK2F1Yml6Z0I2RExjMnQvVUtuQjBw?=
 =?utf-8?B?TjRPZlp4QVRqYXcyYy8wUk1TVzFVcUMrYnRjb0VNK3ZBdzVBL0YwNzAwNkFy?=
 =?utf-8?B?NnV5VXFjaDJkaGVGQUhCai8xVUxPLytiTnZpVklPZE1sOCtXQnRiZzRqUC8v?=
 =?utf-8?B?K1Q4a0pOV3ltUWxSeUxqaHp6cjg1aHZ4NHdyMnlGdXVpS0lHenIvMnhsSGk1?=
 =?utf-8?B?YmoxNm5Ta2I4WUQ5Uk9ueGhnZ3ZCdzdkM3NsdFhrUlk5VzFlZlduYld1NmNV?=
 =?utf-8?B?SkpNN2dUUVVwZWJ4d29VdjBSZDJmYmxLTk1oMFVOcVNHK3ZlWlZlU1Q0V2Jh?=
 =?utf-8?B?aEU5L3F6NTBiRUEydjUzU1JLQkN0VWlFQ1dnK1JLWkNFYlJ3emo1VTBMOE8w?=
 =?utf-8?B?bllLcUVjalJpVWtqRzNGUzl5eUFWY1NyaU5aak8ra2NNU25wWFNteXQwRFRs?=
 =?utf-8?B?ZTE0YmpoMndjNTZja2xhaHJLNTVuUTF0K3dnVjlpODh5amtNZ080TXJIZitt?=
 =?utf-8?B?KzBaTHlpT0dNYXYrU3c3NDN6bENSb2g2eWQ0b1l3V0tYV0RwWXFNZ3MzQlVJ?=
 =?utf-8?B?Z3pPcjlPcFd2TndxUWw4YmN2MGluc1VQd2o4dE9Rak45dkRsRUZubGFhL0R3?=
 =?utf-8?B?TjZ5RTIzUzNPM0YwcFMvWERDUnlRUnByYnR4ZzhDTlo2ZzV4UEZEUEFERjZB?=
 =?utf-8?B?OFloeUd4YUNQa2pxZUlIUEluSU5UMjJHUC9DS1E1YTB1b2s4NzdBNmNIZkhq?=
 =?utf-8?B?S1dwTlkxVmVrTlRkWGExOUNhQk50QU9OUnVzK3pNYnVEOUMvYlU4MUZvR2xP?=
 =?utf-8?B?TW1ER3d2ZTgyQlJXUFVVaGJiL29TVnJjYVV2L2Z3R3VEUXNjTTU1aUVyUVY4?=
 =?utf-8?B?T0w0dmEwN1BkYWtCZFA5ajV3NURlcitEaHhuaThrY0NsemRHRXpDSVFpQStt?=
 =?utf-8?B?NG9VTTByN0M5M1J1TDdRVEdScEkzRUxRTkVDRU9oRFNabnIrMVduVGJSQVhV?=
 =?utf-8?B?dHl1QWNEZkI3ZHVmZDVrWlNZVGVYSTliWVRjYStPZU96Q3c2MUIvVlgxaHFh?=
 =?utf-8?B?MzFWdGo4b1NCTlg2YllLRFpXamNQNElha01MMFhramVXdWZkVzZ1L041MDBM?=
 =?utf-8?B?UGk4OFAwdnFBMDJkTFF1MnI3T0ZFSTlKbzhsU3Z1WUhDSTBtZHVKbUtYVUdK?=
 =?utf-8?B?Y2UvNkJKUUJDQnp6UnpMMnFaTlk1ZWtidWVEdUMreTZXaWZJcFBEeHdZOWFO?=
 =?utf-8?B?WFA4OTIvVHlRZWdzTXY2dUliak5qRUZiclg0dmJRdnY0UEE5VXFGYUFDVjlU?=
 =?utf-8?B?TkFjL2hDQkw0NDZ3NDR4dHBzLzJWL1VtUjlZMlBsVkNkdDltSmdtY2xyNDcy?=
 =?utf-8?B?NnZtQmZ2NFhaNldSVFA4anlJVzVvTUlrNGoyaWNnb0ZYREw5NVd3WXVJczNz?=
 =?utf-8?B?a09sU2x4NGxLSlVNbEN6anhyU3NQdXVLZHJEMmZXRWIyTDdUbXFYQVpUc0xQ?=
 =?utf-8?B?alpPb1R0TkVzd2lRVFBWOVYvWHI3YXJsUW9GZXQyNzRsQ2k5aTM1TjVWRVZH?=
 =?utf-8?B?MFRqYTJMOEdyOHQvWWlQVXlUdFQrRmkzcnl0UjEzNFhDYTRkc01iRTZqVmR1?=
 =?utf-8?Q?pQc0XtkXNZ5bAlKklwlDbi6ykgkLjkVTCRIKu7ZNAY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88C78C862C139B43B7F539500EA54A69@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3b2c7d-d588-488b-18d9-08d9e4ae9d84
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:41:26.6039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+2+giGVrTYKshgKtAAPWmiNJgeAAF1yFxPJZq4NBWarRCUur2LAtZ9Ym7F2ZNu0kXhKg6gvadX8f0bkbg7UgLMx7fiCSI/yihzOR+6pGs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3829
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
