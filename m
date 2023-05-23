Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091CDC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbjEWJTX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbjEWJTV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:19:21 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9165A109;
        Tue, 23 May 2023 02:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684833557; x=1716369557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=cLBpfoHhmJ15v3K+amFkaaC/FrF5FUgacBsRAB16gUtazTuVm9rD2p/x
   +ipkNBXzh5Y1xcOQCslVq0VIcWWD/J7gdBIowuU+5DVES9zpaTcT9Y2O8
   C5ro8D7E11dNJQrogvx3Xm0rfKvM7Bzp3QE6d0eCV3A9fiygN/QBJJB+w
   RwiXnrSkZJoS9HITAP6d1ua/5kBPpAlU0rzqApdri80tCP5pb4fY0k75a
   ZTPtRLoSz1lCN7tvUbe84P0DxJ0+nHOPTCO0TITqpHoUr/KXk3Fjps7Km
   kV18zZYdB32TZZa/byRNO8szazzwScMP/7xB9VFp014h8tC9TGalnNIE1
   g==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="343512423"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:19:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRi47a5jPMimavd4ZUZqUv1Z2Fawlex4atUOs+8NoGoZXnv47c4PExEE/3K+Cn4kX4+fO0+Mw425lj32XMVjnEHcIHfpqYizvZga6+pjlC2RwbPQGYDwe/wIk2h7eNiXt+nSpDqR4t9JUp53rpgSUgl0dfhZAroSSmbYp6Isa6K6K1CT+6+5HVH9BzgXiS3RPquLVd9rYZe0KvAmJaE9DfXgtYmriMztYC1eciLiNWZ6b0OR1a0/F06tBVqmLSHeL4HOgHbDUHyUP3p/jH/fd6zm7bTgeUfwL4xcwiuMkc4VM6D2YamJYxAGT7MxwFkKOVZqACJTeFH+Nh4F3wDw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=JSrZJQy12Vg7qAQBfklSViRJmXVocgKai2HCvtn4fybrnExXyUDWiKUGVOpOWYYpWZhRmwpOJIsx1/Mkgl+gV9w0brzePKDkqYbTogAn8TqnPUaovYtVTlh3wgTzWRQE/659TSuf4YRIT6p9pDH8SnHSx45UQZAALUlGe2JWcVbV8nWC3yvWUugBfSUXlpeLoq0NlWBWo3kC1tCbQNUMIiwBR4gXg1YXziDCfJBBV8vy95rt0+hc70Wt+n7kUCnhrv9dZ2hclcE35ZHkmyvj1AorI4A+j/h8xUNwpE6RvLc6xV1/lyvjaoUe87g92JJInoZiySZyjZvFsdF8x1r6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=T8rHbCbH1j75jOtixlFM3+abu8zSpLKsVB1B2FrNoeL+OQMgXVdUC5AyqDYlgQFg6p+hwoSY/+G8dB9/SvWrJ08DDOdQtEo/cp5DlXtYYzCa1GdSK2sarwmgRMZ6xE3WjNk5nJGn/bdq9eGWYrMDRxZ0X5voHfr9d3nZI817blQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7853.namprd04.prod.outlook.com (2603:10b6:a03:37e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:19:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:19:11 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests v2 2/6] common/scsi_debug, tests/*: re-define
 _have_scsi_debug
Thread-Topic: [PATCH blktests v2 2/6] common/scsi_debug, tests/*: re-define
 _have_scsi_debug
Thread-Index: AQHZd2voXzwXtGjBVk2EeR5TwxAoza9nwGsA
Date:   Tue, 23 May 2023 09:19:11 +0000
Message-ID: <27a12b87-75e8-96d4-0514-c637d7104278@wdc.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
 <20230425114745.376322-3-shinichiro@fastmail.com>
In-Reply-To: <20230425114745.376322-3-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7853:EE_
x-ms-office365-filtering-correlation-id: e6bee283-bb5b-4761-c9cc-08db5b6ec4f7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlTPfk2BP5KV6w0I68gDWNJiEggOj3hU4qv/q7s7Vv7AifQNNfBiBEGzse4H1yGaoHdImYWWCpjzvQTNPm4BWQ8B7udLl8ll9mZHvohm5w1UcYDi4y/jUB2s7gRjFNFvEJ66DAbmlz/YxnoWN02zUB646E3lRU+/uPvmEYYjvWmb3ICrFSHFtP09SBpFqXHajnrMgrnAKuFmecQEuNxXjs3t4BeIPReELQkC6lQpAo5VkGyr8p9LLyKHfL+h77PpKOw3IESnw0g78xT8NfJm0Q+4tNIm6ZAXICMl67NPjqkI3VRGuox0x7Odn6AkB6uXmr70agRyEJv507JY0pDUjvjGyofCk+HQfp2MvfImn/bBEJAocABRbW2+mMgUiDUm9NCxsAA6F6KiTzyxY4Q7ZWX1HQOIQmLYUX2OumySM4gIFJMHtXp72N+ilgnW1iZGGDgNy92jtMA3S9aIqgukQTlhjkBhVM2gFYpKaKHmVWKXqklNBakO6mB9M/QnSNEZK5Mv3T5BIJp31tvcndkHYADxvKXOUD+AuTGMa6MkWXG4hepM6ZnPbUt+Yr7bS4N34LiDLCHasgEM3FNORsexL9QZLGmUPWxC2bTaTwD3AoZDktNve65laCFiPEWQEC3iVM9TqYAfACDK/NXUFaDVzSf8+oT2q51mzeC1lYaZh9ziwBbkHmB2Mt74QphnB4hT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(8936002)(110136005)(54906003)(38100700002)(38070700005)(31686004)(122000001)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(478600001)(86362001)(31696002)(91956017)(4326008)(316002)(558084003)(71200400001)(82960400001)(6486002)(41300700001)(2616005)(19618925003)(36756003)(186003)(2906002)(4270600006)(6512007)(6506007)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aExsK2MyQStFU0dRRHMrK3FlbnBEbWZTL2xLQlJ2WEFWT2ttV0FLVHlTTkll?=
 =?utf-8?B?SDZBbXlPSWJpclM5b2o2RnFXaHdFS2lBTi9PenN0OFNyTjZRVFdOeEJ2QlE3?=
 =?utf-8?B?UjM1bjNmR1gzMlo1NmdaSDVZcGNzY2ZWR2JyNnlGK0FaMWo3YU9DeWpFMWV4?=
 =?utf-8?B?MXZYZFBtakhQR21LNWlLTzMrNFBZWVIyV2s0SThlQlBxQWE5VGpXbWd5Z1Vh?=
 =?utf-8?B?cjRWUTNtSVJ1aGcxODRnNk5sTW1Ma3VNMHd0b2diYVFhWHNRVVJpMnFWNFVX?=
 =?utf-8?B?cG9YenNlQ2s0d0Q5TGNIMHJTQmN1REJsbDY2aGFIVC9jdURseEJLcmRJdXpQ?=
 =?utf-8?B?MjMyVXQvaWEydXBiMThKQ0FXZVdOdy9hSmtiejBEbjFiVGZYMis3eERBQUJR?=
 =?utf-8?B?Y0hVUHBBTitGU0tQN1hST1pteVBiSkRNbFU5ZlNoQXZLb2tnaU41NnVIeVVT?=
 =?utf-8?B?REswb1lKUnBYd0c1aGhzWnp4U1o2OEsvUjMySXl2b3FZWXdWUGZGOHJlTE9W?=
 =?utf-8?B?WmdoZW1nM0d5MmVleFI4L3R1U01sczZrdTcwTkkybFVNVzNpd3JEVWgyaW9U?=
 =?utf-8?B?NXVuUzRqVW5pQ0Y2dTVobngwRVlITVNFSXVBbllTRHk4VmFKVktUbUZEQ291?=
 =?utf-8?B?dFdna0lPUzVLMEo1MG5LTUZ5eUpEZDN4dmZubkR5VE5kSGh6RWJTbUUxTHph?=
 =?utf-8?B?OGtBaGdsNXFDVlFpYmhxVmtUTzU4Rk1kOHZNQWNPU1lEdjFUOUVBRFdZVzZr?=
 =?utf-8?B?QW9pNlZBay9Ja2w3cGZCKzZNRGNVZEpqTEU5RWhZR2dTVTQyWmZycFVoZXVw?=
 =?utf-8?B?TGZMWCtZQStGZU13ajdkMUN0a2toREdBNSsrU2hZN2FncUYrYnpTZ1AxTDMy?=
 =?utf-8?B?WFBYMnNnbVZpNURDdmN3WWY3aFpTNjY5Q05VOXVRMTFONFFKQVI5cDYzU1I3?=
 =?utf-8?B?SlJLREFVb0MrOUJ5NWtxYTlwTFRCaGFML0JzVWZlbTFPcDZoaHFTMGhDRVM1?=
 =?utf-8?B?R0lZQ0hpZTJWc1pTVTRxSVB6MExSVTNnRXkwWVFma3htNUVzQks5WTJKTVk5?=
 =?utf-8?B?WG92VmcwVm5VckFNeUZuaUdIMG15NDFhWFgvS0g4YVhCU0F0UjBTVEYrMG1B?=
 =?utf-8?B?SXBtWWRjU3Z2TjVXYVRYMFNpdEd3S2FqdFd2bEhJTWxVZHI4MVV2NlpGVmJu?=
 =?utf-8?B?OUQ1RHg3NnhGdUdLU1R4S1V2U3pYNHgzNlh4d0luSy94M2RqWm8rZERwTUZV?=
 =?utf-8?B?dXZxZFpyU1lDZmgvUnBVMjVXYmlKZ2IrTEM2Q2g2cWpEbjhxN2E2V3JiRFgw?=
 =?utf-8?B?Ymp0Qlg3ay9TYVBGSkFrM212N1VLcStSODZIR3c4aEo2T0lxTFh2UTRvaGNS?=
 =?utf-8?B?Z3l4SjdIN0VvdjZWVWRKM21GenhjR1c2MmYrYy9HZ3NEZlVlQXBQZG4zQmRj?=
 =?utf-8?B?WlltbG01STRueFBmN0hKWThLNFE2U3NHaFFOTmIrZ3MreXVzME95a0h4dElX?=
 =?utf-8?B?UGN1Wk1oT3dWN0MvR1drOUpVWWY0akxCSjd0RWp4ckwyVzd1S3h3UUNEekYw?=
 =?utf-8?B?UU9kMW5rWE1zUEhubzQvTFRTMFVYQWlGeTA0akh4ejdaTVloeVc0VmdTd2pR?=
 =?utf-8?B?ekVTVUtVOGQwYmd4Q29ibm1NNWRQRWhkd2FIQ3pUN2o4UGVaa2pESWhQSGp6?=
 =?utf-8?B?Z0JJTUYvTVA0SDZqQTY5cHFyQ2s5ZTk3djBxZHVBN1FzNjYza0hPODI2VGx4?=
 =?utf-8?B?R0dKN0RDVnRGbTRQenlVUUVBOFFiMWlzS04zRThYL292c1hjYWtKZm1QSVRV?=
 =?utf-8?B?cHNucHN2QWlxajBSRDBJZGJaMHBjWnZMU3VnRUNYSXNWbWhJeGpsWll0ZDNH?=
 =?utf-8?B?M001SGxKcHQ3dXpvcVIxZHdKbnNqVTN0RW5VUzdjZmZMZG96V1ZlaXphQUlu?=
 =?utf-8?B?S3BVU1ZleDFyYyt1VTJYQlZOQlNHRlZGRnpPNFpZMmRMUW1vTVprZklmVWFF?=
 =?utf-8?B?QnVTbDNybS9LYW1vNTlvdjJJVk1SdEFwZ3F3T3pZV1BIbnZUem5iVUJnR0ls?=
 =?utf-8?B?Rm1hVVhLaTlqUFAvNjFzQ3RKbHFOTjZSMTFtell6SzhveGd6YVpJa1JlcS9x?=
 =?utf-8?B?ZTA2bndkdVlnRkNXSjU1MXpyT0RxY1pxdmhMdmREY0VxSVA1WXQyWlZ4K1VG?=
 =?utf-8?B?ZVdkKzBaSXJ3S1c5NUNvWVV1WnB3cnNyNkxmaSs2dnJQZm9hcDE2bUduV2xx?=
 =?utf-8?B?SHBVcHpUNEFrbUJLSHV1UXpZSzRBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8724473903E2344CAA3E775C5D235631@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hLsDMKt+36kI7arhZFAqVHyDegp+ZusSNid4h0NaSKefI7m/rTdTXcwsz5m+uHvRFNiHBymcA5Ht2dvP3laLuXlA6BJGZrylyJ/Q5vWAQ0bk9+ePQOg7xG6RYIE0az07DYN0QH1xzksizwygB0Y4CEbnfF7c7DTQmTv2mnCBAlSNlDOGtihOknR8DXSlhK0OUxvyFdmmPImzb1ZaVRb4ln+VOkQKlxXFYIDri2eZ7awbTb9P0x7dynpQLbzhZUHVJuISfQ1157ObIPCly0ZlhG9O7dbWgmKg5T6Pa9PUwTF+wm7mQl6VfI2+uoDhx48w/A0HEU2Ir9C58U1dTaAxwoLgpl6OKgKvT9P3K1kFSvHFm8UWYs816sA84qb4E/9FrGv5DR0KAchGXCwdA3TP+1KN+ZkPzIhxbHksz/fRonJPaw9hjeBZHnZvSPuz6TCELy8EhCVVmXXJJeJfjvBcLqh7OcZJ8n7G5QplyuLwsXebFvPeeF06fmYF8sw/0C/GZ3ba4POu+NURZY/nI1SU2Y76VTLY1PQ8dQOBuvHt+A7KKAJjeiWR9jGtHtn766GmBmo+C52Lzd2Dgs2038M4BfrZXNQ/xgn/uVeCFctxj5IreZjFRjkj7mBwf4h/55UCp90ytjPHsp3pDqWsG9/DJv0s2FjuOSjF89gKq0Up5lPdMAbKuTK3CJk3/486PvZWwi5j4RKhJek7jLWQvZ6CaBxFGh7iDW+do1Cly1B5yTrZOAd57VAlGDhFdWpfbuBGZdvk2SH5pCws9u7UrrQs5HOhZ+TpbG0R3S0Cqw0g1tg5KQ+T+YsZLyLCiAREJoX0iYZoMGW6JscbOuMAXCCFmw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bee283-bb5b-4761-c9cc-08db5b6ec4f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:19:11.1731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gy8+iZ/9W+tT1c18qL3nYvPJKHYgahAHC25dngDA6+XqqnQiVgzeifHc12AzrV1bXJwQnIoGv756wAlF/cLqu8jztWb/ZK0LGqlwTA6rVH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
