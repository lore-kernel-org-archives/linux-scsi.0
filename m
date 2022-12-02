Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE3FC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 06:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiLBGlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 01:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiLBGlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 01:41:14 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19577BC21
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 22:41:07 -0800 (PST)
X-UUID: d0d68989199441a6aa52c27fcbbbac8b-20221202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TJywfxZ34b0JzlZUDvxawgqLWrEJOMzz+Wvl0+RspN4=;
        b=krjmfk7L8M2hIXbnjKhYUCAAgKi4/BqAIawYSL3WrsfMNnSUloVBjPXouFowFcb1idIKhMpr38HKBmeyh1uf9h0kfnlPCUOscIn2Cmk4WusH4ziNinmi4USmM1ovaNtSC325NdLs0ac3DRvxjKPu3SqI4gNTdvXmLbSFwVFOyF0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:c03b6dff-3c25-4612-b9a7-eaeb43a8aa31,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTIO
        N:release,TS:23
X-CID-INFO: VERSION:1.1.14,REQID:c03b6dff-3c25-4612-b9a7-eaeb43a8aa31,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTION:
        release,TS:23
X-CID-META: VersionHash:dcaaed0,CLOUDID:40be7830-2938-482e-aafd-98d66723b8a9,B
        ulkID:22113018173883RKSHLS,BulkQuantity:35,Recheck:0,SF:38|17|19|102,TC:ni
        l,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40|20,QS:nil,BEC:nil,COL:
        0
X-UUID: d0d68989199441a6aa52c27fcbbbac8b-20221202
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1136334145; Fri, 02 Dec 2022 14:41:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Fri, 2 Dec 2022 14:41:02 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Fri, 2 Dec 2022 14:41:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0W3YK6NEIQwazBSlz6wxWFPUiNdxTutE3+58nIyIVqf+bV8VoFLEW4dRLEHFuDCZRIU7PGs8e46OALzC08mN5CMLqLOHClMGFubgw6EIPwcHiemhuCvh+ATGm5A/mmSD9KgJfbCyUAgnBqg265rg/ujQaavY2LuhLCQJMoGz+wJLW1ZBF2rgxsC5qY8n5+jGItKa6x64lMHNVTCt7032i+bVnGgOP2CW5HTTd9qMROMmTMKzmO+Ht0dI8lj1gRFeUjhTAmcU9wXnwG1wA8TOfUTjI5aE8yz0jTZI4nI8P/5DCjqGG64C6G29iAGi9OTQ4/qnbf+ml0ydOhTaJKR6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJywfxZ34b0JzlZUDvxawgqLWrEJOMzz+Wvl0+RspN4=;
 b=Uq2jJbTaepbvOP+syDOcdpHizhMncKj6Utg71mcbk0Wbpg/4vLxL42p5h4dCgMUW3JKdRets1pKvyZV45Xpwc8gwOf1WyQZskG4PqTwQ1f3azBSZRhPGi441UWbaIqoRsfWGaSU1u3BoOLW5BeJRDkL2rsPo5UzA83/fqhQ57U7JJiSaDQdNZ2m5SsNDfOHbQprA3XQl1hSi14qk4s87U+svxL5BH6538f1oY8it/vO4JPq0HhHhahf2YkQdAIIO9oz2aBkchPoknZ40WjqG0SPbgnLYBWgww0KhD9Uurne7tt2fzxsDV31WfMCkDREWZUEVYdxAlnGqfj2ojjXpZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJywfxZ34b0JzlZUDvxawgqLWrEJOMzz+Wvl0+RspN4=;
 b=qbgl16EVT+3ZRcZBPYKtesas3JlYkZp/YWmuCIZsNEkVsQgifCyRwzvC5jLMGO1FAP5DmhRfgqiKtpaHjenDfEKdIYfe3lv32S6TYTzm3S3u+3RhCbSE+M9NR0IcM631MF5p0n/kL/8Fmj57UbKvz7ezvSkCUCRrA8wiDlRe8Jc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7163.apcprd03.prod.outlook.com (2603:1096:400:356::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 06:41:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb%4]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 06:41:00 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "dlunev@chromium.org" <dlunev@chromium.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Topic: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Index: AQHY7f2ebQ5oIqIDLEuxQKxEnr9j6a5Xbc0AgAB+UwCAAfJbgIAAd5qA
Date:   Fri, 2 Dec 2022 06:40:59 +0000
Message-ID: <c92655563231dd79ed6d4287d7d5bad4de142a18.camel@mediatek.com>
References: <20221101142410.31463-1-peter.wang@mediatek.com>
         <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
         <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
         <CAONX=-e1NA--3taTmfbUV+hR_LOSqvBqz_=1mPmYZWaKGGR=ig@mail.gmail.com>
In-Reply-To: <CAONX=-e1NA--3taTmfbUV+hR_LOSqvBqz_=1mPmYZWaKGGR=ig@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7163:EE_
x-ms-office365-filtering-correlation-id: 8a3bcce0-555c-4e23-cf4b-08dad4302ca8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FAIH+Jh2+Z4EokbKghjKtiOtU94GkScYmgdEaEJ6/wEqcRqnaN67b1jk3TDJ5Za9mXqjr6whUYbJ7XlkFqKoVhH3J0AGOrNXyzqmOMg7bSOefu4qOkAchMK2mdyqxyEsxC4K5QfVg+ltbQ885NjXqRpuO5QUlVzrowXFLPGSj788qa16u1JTjERMHwq5815J8wkYlia6gtyW1dgHZlwvIPmZ6FMlwguK559QG29Nl6urbK7JUo8rMH2m4EryEt75gzRz8sh2ZztRkwuGnPozig0hqWYvh3/AIWB2H3nz+BG2UyY+TkqtLjiVH+4Auk8APTri3KkzdmHviZbjoEG9zPuyOxE6WRGFsAM74Udh2rS+fe9W05dJDBZ8hbl2QuVVWQDOFclbfKqs7wuPLGprvLs24B9Ku4vn52syXaQikVk1UQaS7YgwWsSQwDTMxbxf9Eby9GP2eoBkZNTOKbL/2+9n0R4J8SvYggXAhY6ApmUbD+5DyUX26N4vKWzJjcPvoR4UF9ygysMGuxIGcf4oRhXGnL064N9nwo0RjmidfIg1ee5ZVaZbhx724M69XExyPjE3xzl75dLygeDmjhnYE3ayWsHSoQSkJNT4LrRou0Lpnj1BSlb7F1IdB82ocF9qm1zt6D+YeZFzI8W+FPataArOU08YrkUtbMciiUeznRJqwD534RH+VQTCmstMopHA35lH+kxYVo20wqgJvh6HLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199015)(4326008)(8676002)(41300700001)(5660300002)(66446008)(76116006)(64756008)(66556008)(66476007)(66946007)(91956017)(15650500001)(316002)(2906002)(8936002)(54906003)(110136005)(6486002)(85182001)(36756003)(478600001)(71200400001)(53546011)(6512007)(26005)(6506007)(38070700005)(186003)(83380400001)(2616005)(86362001)(38100700002)(122000001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mmd3dkp3ODJma2NENGRHeS9qTVdqMnMvajlhbjNEcUtmMjYraGY2dW9MSFcx?=
 =?utf-8?B?L2JLK1Y2WmJhLys2azJVWHpKTUNxRXdGREZOcUYwSnArL29wbm05SGN2OGJK?=
 =?utf-8?B?OHlrM1MvcTBzZmtDU3drUVBFUk9FSmJ3cGFKbzhzU3ZoOGhyV1JTNElXMkdW?=
 =?utf-8?B?YzZWdVFTWmlLVGpqVEVkd1hpQjlHMEI1ZHE0R2ZvU3UvQTE0NGpOR3htY0hW?=
 =?utf-8?B?Q0M3MjNLajdVRzZJV2lLbEhZY1M1SklUSVJwRlNxVmJ1QmNsNW9xemFQRCtX?=
 =?utf-8?B?VlNGTUNkRktFQXFkM25qa0dRaXFXYnk0cUtEajVvRzFhdG5aQUVEc2plSStj?=
 =?utf-8?B?Sks5TE9xc24wMUk4Q2FKZGRPNnBWUDUrNTBMZnNLUFMrdFYzc0IzNGx5MGFj?=
 =?utf-8?B?RnFObnYzNkdXZVNvRi8xUkcxV2NLYm9EUUdyM0pFc1NOVS9CQXp0UlZsSXBC?=
 =?utf-8?B?WWVBZURhcDd6eVNVSVIxeFMyNUw3Q1oxYkJRUjNRdGVwSkZzZ2ZRdzNSK1pu?=
 =?utf-8?B?dnhFRVprWmJ2T09Ja2o3V05kYXMwU3FKY0NkR1ltb25pNklSUjQ0bkVrSC9O?=
 =?utf-8?B?UWYrUDk4R3ZEK3VxZjFhbG10cE51bUlQU09vS1AvMDN6Mi85YVNkUlRFa2xF?=
 =?utf-8?B?S1lLNlVpNVZWZittVC9oR2lNS2hGaWd0Wmw4dlplaFdMNk5RNkpYUVd5b2pG?=
 =?utf-8?B?U2REVzZCVVQ0cjEvZlNEZ1N6bGtLQnJ5MFdXei9HVzQ1emxpUEZZLzNBTUhR?=
 =?utf-8?B?NFJTc3BBMDdkcVhYcVh6TUZYT1V5NGpxUzloRktBQnZIdWV6VEM5aytUemli?=
 =?utf-8?B?elhkUFl4d0g3SXcyTHZOc3I5eHk3a1BzUmFtanJWbXB4TDFjZ3lEc1liaGZJ?=
 =?utf-8?B?dGovdGl0OEtiU1NhQ0VKblcyTS9FSjk0L0g1RGtuMzFqcjR3d0gxYVg3bTY1?=
 =?utf-8?B?dDRJQlY3VFZweENBVllUNkw5WEtlVHQrb25nZGJLcG1ORkE3aVQxN2orY2FW?=
 =?utf-8?B?UUorVHVaRjFxNXhDOEtMWHBrRTRMamg4M3I2bkEyUEY2WHJhZm52ZkZCMk9t?=
 =?utf-8?B?TUhNSUhOZVBnSDlYcXlOUVFORkJKbEsyTkEwOG5CNnZsWFMyd0FXZWVRM2xv?=
 =?utf-8?B?UlVncW1nVDB5a0JvSnV2ZUY0RElpckRzbXEwRW0vQk44ZFBCZEpnY2RXbU53?=
 =?utf-8?B?SW9TeWFhNDY3dTlCeDVNZXVNeGp2THRuRHFKL3ArVXdSWnR0M1NYV2MwQXBH?=
 =?utf-8?B?TzJtYWk3amQrRzh4QjRWMlQrQ2FuZGxXSysycGpBdC83UWh3UHdUZGVTZStN?=
 =?utf-8?B?VmJaQWtST0MvVm1TRHI0aXBJUnJPQUxSYkxUZ2RSUWZPanhvOUx0RWk4NHdW?=
 =?utf-8?B?dExkZVB1MVVyQnhCUTJ3dlBKNkttM1dtNENZdFFyaGdEKzZRRkNIT1JXTi8z?=
 =?utf-8?B?WHpMZ0pxU3Q1Y0pnSjd2bUxmNmk1bitIR0M2VStVaFgzWVB3RnBQd2YySWFP?=
 =?utf-8?B?NUY4dmppK2pLV2x1MUZmMHplNHlTSExwblJlSExNL1JISlhqRmlaVWlQTlVk?=
 =?utf-8?B?K3F5aXBhdnhYMmV6bzRRaU9tc0Y4M29na0pEc09IM3hKb3FHVGFjMW1hcWpI?=
 =?utf-8?B?OFBHT1UyRENMSDV1UGlOeUZrazlkckkzbkJTM2c0bCtmajcvYVlXZEJZQk9F?=
 =?utf-8?B?SEFOM28xRTRlaVcwRmZNQVhwckpyQjRjNVNnSnZWY2E4aDBwa2ZVVzZnQTc4?=
 =?utf-8?B?WThoa1c1bFJpa3V6YW5TWkJRUmtBdDJQYXJXdCtsMmcyV3dkOHB0NEFhNnZo?=
 =?utf-8?B?VXNTSjBWU2psQktyS0JPV0RnQ0trNmQydFVMR3BSaHV0cmVtSk4rNEc5TjJR?=
 =?utf-8?B?SThkd3k1czBldXNPYnhHY1c5VmtaaUVwanN1WDJRSzE2UW9WbCsrWU4rU2VR?=
 =?utf-8?B?b3JxYkEyN1RhSjhzd1F6V1FsSHlqNVp1bkdHbTZhYUZjbXk5eFF0aXpRbVpY?=
 =?utf-8?B?UFo0RGVvZWJ2cmJFbGE2eTlSSEZFQmlTb3dKbXVnbEZSZVAreUczcTlJRnZs?=
 =?utf-8?B?RWwzN1dWaWh6MGM5eTNjSjUweGhBSHNDUUh3Um9sMDc4RlZTWExQZlFuV25a?=
 =?utf-8?B?Vm4xVjJKQjhSMWhWaGR2RzB2biszNVQwZ3VxRkE3Ny9nUWFpbXFuUy83MkVu?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88F522EAA75A7047A3B2206522B65BFA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3bcce0-555c-4e23-cf4b-08dad4302ca8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:40:59.8657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8QYgb3oKdijr4pYq4+b8WaMvjQ5yhBR+7OwZvybIKbqQ3QiBXA5ZHcgaZv9rauoG0fK856Q/sOb9U2HNiig5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7163
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDEwOjMyICsxMTAwLCBEYW5paWwgTHVuZXYgd3JvdGU6DQo+
IE9uIFRodSwgRGVjIDEsIDIwMjIgYXQgNDo1MCBBTSBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NCj4gd3JvdGU6DQo+ID4gDQo+ID4gT24gMTEvMzAvMjIgMDI6MTcsIEFkcmlh
biBIdW50ZXIgd3JvdGU6DQo+ID4gPiBPbiAxLzExLzIyIDE2OjI0LCBwZXRlci53YW5nQG1lZGlh
dGVrLmNvbSB3cm90ZToNCj4gPiA+ID4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRp
YXRlay5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBXaGVuIFNTVSBmYWlsIGluIHdsdW4gc3VzcGVu
ZCBmbG93LCB0cmlnZ2VyIGVycm9yIGhhbmRsZGVyIGFuZA0KPiA+ID4gDQo+ID4gPiBoYW5kbGRl
ciAtPiBoYW5kbGVyDQo+ID4gPiANCj4gPiA+IFdoeSAvIGhvdyBkb2VzIFNTVSBmYWlsPw0KPiA+
IA0KPiA+IEknbSBub3Qgc3VyZSBidXQgdGhlIGlzc3VlIHRoYXQgUGV0ZXIgaXMgdHJ5aW5nIHRv
IGZpeCB3aXRoIHRoaXMNCj4gPiBwYXRjaA0KPiA+IG1heSBhbHJlYWR5IGhhdmUgYmVlbiBmaXhl
ZCBieSBteSBwYXRjaCBzZXJpZXMgIkZpeCBhIGRlYWRsb2NrIGluDQo+ID4gdGhlDQo+ID4gVUZT
IGRyaXZlciIuDQo+IA0KPiBXZSBvYnNlcnZlIGEgc2ltaWxhciBmYWlsdXJlIHNjZW5hcmlvIHdo
ZW4gYSBkZXZpY2UgdHJpZXMgdG8gY2hhbmdlDQo+IHBvd2VyIG1vZGUgKGUuZy4gZHVlIHRvIGF1
dG9zdXNwZW5kKSB3aGlsZSAicHVyZ2UiIGlzIGluIHByb2dyZXNzLiBJdA0KPiBhcHBlYXJzIHRo
YXQgaW4gdGhpcyBjYXNlIHRoZSAicG1fb25seSIgY291bnRlciBpcyBpbmNyZWFzZWQgb24gdGhl
DQo+IGRldmljZSBxdWV1ZSBwcmlvciB0byB0aGUgYXR0ZW1wdCBvZiBlbnRlcmluZyBhIHJ1bnRp
bWUgc3VzcGVuZGVkDQo+IHN0YXRlLCBidXQgbm90IHJlZHVjZWQgdXBvbiBpdCBmYWlsaW5nIGR1
ZSB0byB0aGUgZGV2aWNlIGJlaW5nIGJ1c3kNCj4gd2l0aCBhbiBvbmdvaW5nIHB1cmdlLiBUaGF0
IGxlYWRzIHRvIGEgZGVhZGxvY2sgb2Ygc3Vic2VxdWVudCBJTw0KPiBvcGVyYXRpb25zIHRvIHRo
ZSBkZXZpY2UuDQo+IA0KPiAtLURhbmlpbA0KDQpIaSBEYW5paWwsDQoNCk1heSBJIGhhdmUgYSBx
dWVzdGlvbiwgd2hpY2ggZGlldmNlIHlvdSB1c2UgaW4gdGhpcyBmYWlsdXJlIHNjZW5hcmlvPyAg
DQpJIHRoaW5rIGl0IGlzIHNhbWUgaXNzdWUgZHVlIHRvIFNTVSBmYWlsLCBhbmQgd2x1biBkZXZj
aWUgcG0gZW50ZXINCmVycm9yIHN0YXRlLiBTbyB0aGUgY3Vuc29tZXIoc2NzaSBsdSBkZXZpY2Up
IGlzIGJsb2NrIGluIHN1c3BlbmQgc3RhdGUNCmFuZCBjb25ub3QgcmVzdW1lIHRvIHJlZHVjZSBw
bV9vbmx5IGxlYWQgdG8gSU8gaGFuZy4NCg0KVGhhbmtzLg0KQlINClBldGVyDQoNCg0K
