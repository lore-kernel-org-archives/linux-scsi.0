Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB01C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 09:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiLAJTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLAJTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 04:19:48 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15632862FE
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 01:19:40 -0800 (PST)
X-UUID: 7907e1cf62684560adfb7f5c033bfdd5-20221201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=FS1L/hCQ5wOYhs0fOISDrQFyEWwO0kR/FsdR62WX6IM=;
        b=PYlyLXhCEXuLPN0V0LRJuIgCvC4zsh0fUVYyaKuWMC/OOBgS5GPRSqU3Vm67QtNxPKxVdzp7Epgqn9OhkGYeyypuVTWWkoWp0cHSKCxo6jy4RikYuvl3Z/+9oLUm0BM0FiBeaADCdfSOEVD5GIaUo21UODf5jBQJWcqBOocj/rg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:b9684211-79a8-4839-9de8-fbd11592d0eb,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTIO
        N:release,TS:23
X-CID-INFO: VERSION:1.1.14,REQID:b9684211-79a8-4839-9de8-fbd11592d0eb,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTION:
        release,TS:23
X-CID-META: VersionHash:dcaaed0,CLOUDID:3fa1426c-41fe-47b6-8eb4-ec192dedaf7d,B
        ulkID:22113018173883RKSHLS,BulkQuantity:8,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40|20,QS:nil,BEC:nil,COL:0
X-UUID: 7907e1cf62684560adfb7f5c033bfdd5-20221201
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 122987627; Thu, 01 Dec 2022 17:19:32 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 1 Dec 2022 17:19:31 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 1 Dec 2022 17:19:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEz+gj/9erJhYNIUIHUjaVHdcpUDC98OYc98WcQYTuqAuCbRm3n0TNA2a5hhWpucGIINk7CriSfOJbMQ/vAl3OsRukog2qrvkGimkq7dpns14/OemHJ0SBuHzEs6I1CTdqhowgOOGItehYQm6Jz4Hicpz9AlXXWuyHiLCkbnrVkBnuZnW2q4Kl6Pp6c5Crn9BO0dkB1ST6uBdoWM53lgIxw9Zqz7PvihZOsKotICqC5mxRdX7fEUoyd7JG649iUG2N++im5/lu/eT0rtMZJBarANnzE5VJMFZeMCF12eQrZysoE+sVsPoSwKXV115WRcJzIsupZMHgRH/ZO/vsZReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FS1L/hCQ5wOYhs0fOISDrQFyEWwO0kR/FsdR62WX6IM=;
 b=LiI5EtegetRA4aw6urG/rskWcYmVQfxr3oeNqnsY9vA2PXqv4eHV7xgHy+ZDeUzl94NPIiIgUoPh9Bqv3FwWjQZHPhYMCJn3XPuLw+iYaThxclsKuJNkSyim9hk9ZszRcwXokEHfCD0Jfk18zDoCFUf2Af5Uf97dB8g9TholkBSIpVD9MPRSofq13CI34E6HpMyOacwhawLidlt24GDFOVyBsmGWbkn6UGtnUw4NFOjeWOC6/oDJfKLnbJ4tnhCed1ht9gQ+3l553I43ClXcVYk28AyFdFyZgJXx3fcJ4Janx2G0inUmnmiaUkUJ9hgeHMTQRXUptuv8UawnxjeoZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS1L/hCQ5wOYhs0fOISDrQFyEWwO0kR/FsdR62WX6IM=;
 b=ZlYPdq9ubtBwGzsSLFHVbyMFUMCKDymGPyxe3h5VblRRs8qjApqyrT/hhvoVCZJFBBufJEuOihUBhe0zO9lPxWxS9ppDLmw/mOAnDNk/yzwjNtgJdFOc5JvdIMQC5y1fiMlZK8VmHCQIx8jcPTcFwXRcFbpAFTzKG6uYxAD+mc0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6456.apcprd03.prod.outlook.com (2603:1096:4:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 09:19:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb%3]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 09:19:28 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Topic: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Index: AQHY7f2ebQ5oIqIDLEuxQKxEnr9j6a5Xbc0AgAGCPIA=
Date:   Thu, 1 Dec 2022 09:19:28 +0000
Message-ID: <b773dc509936a40ec43cabeea252ff73305bd7fa.camel@mediatek.com>
References: <20221101142410.31463-1-peter.wang@mediatek.com>
         <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
In-Reply-To: <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6456:EE_
x-ms-office365-filtering-correlation-id: b06b7e78-91a5-440d-7fe7-08dad37d25d3
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zeuEpFIGqUYu5O2BRtplplBDUiOsz1tJVQ0PjlDbsw8vnIMoRMvU7kz+nuysa8YSqI3/tLscZ59DWW/931eYuNXjIMsVUWn0/OukBy4ciOC8iggxkPp3Okqxqtta3kp3+nM4kJAJKcPLm1f3Y/NcjNZuhaADNHjcde47e9JR4Cj6dL2z/i7QlMfGzYlU3gZ+NIDIz5UZoGbLLTC+v3WZk4BpB888LRBNEe1FwjJypv/4Pdo+eoxSIrOX6fBeG+bf4DnQaAl9OYfIWxxAUMzpthCUZs1vde/giFWLJqdAnF+1syHJemYvI7Jt57roeUpulReAR48hItdD+LWjfJ2IxVzGdlOxf+zNHVPXJQOgYSyH8yE4SJVjtDDIJGp6gZSQWmV5y6q5GjQZBYCJl52CpchYGbQmt058sXgR8u2PGQiU5GQccTLjvdQlmqBf7SKDh34iaC6ZXBTIjOWRtbziasKpO54xUa10I3yvVa6M7VXV5XuSkuiOE9FN2oRP4pKiuBApZGlC0rzD1ALW0nmV3jVWx569i8XvmVYc5FK4fUbUasPQloE2NFrVRjC8DDfvjG4w5YaVh3LsnxkVZ+j9AKWScRXCVsHsgHcZGOjFmoSXOLUUarlF3zAGXa8kMbakNsseIQn7BwbHsk6tctDyxmksNrToC0PZ2S/nHA6WlwTbfFC+A+g6t0NoHFVd6q2KoYVQeB4Tx7vMz409M7AhOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199015)(64756008)(66446008)(66556008)(91956017)(66476007)(8676002)(41300700001)(76116006)(66946007)(316002)(54906003)(15650500001)(5660300002)(4001150100001)(8936002)(4326008)(110136005)(85182001)(6512007)(6506007)(107886003)(71200400001)(2906002)(186003)(478600001)(36756003)(53546011)(6486002)(122000001)(2616005)(26005)(38100700002)(38070700005)(86362001)(83380400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eklhd3lEZFFxSm8vRWh6ZUFTck5wVUNKbnBZSmw4d0VkNGpoNng0aktwVWxa?=
 =?utf-8?B?aTVJam5DbWl4UU5rTHB3aHRQbmpYRXJBSk55NzRObDVJRmRRY2c5RE9SS2Jt?=
 =?utf-8?B?YVlwYk4rV0dHWWgzYWoycUlzcXEvWkNheEdSMzdpRU5LR1FVRklLRjhuRjV4?=
 =?utf-8?B?VmYzY0IvRjFGcStyYnBQaGhjaDZvdEtCM1U4R3ZvS3dVaXZVWXRyRHFIU1ZT?=
 =?utf-8?B?NENXdThTc0g1RDkrbG8ycmxTREpjY1dZaHNkVHdZenMrTUxXSU13RVcxNGZ5?=
 =?utf-8?B?c28zZ0VFUnUrL2NvM3czSUU0c05RM3ZKOWdMcWt1ajNSV3VrVzB4RmYzcGVz?=
 =?utf-8?B?enNNREk3Q0JtcHcyOXoyUHgxUDR5U29pTUM2ZVRjWG96a09KUDRWZktHL3FK?=
 =?utf-8?B?Ykl5KzY5OGw4czJhNXFqT0tIY2tXdjZrUlROZm03bjQrdGR4NXZDMTJyUHdj?=
 =?utf-8?B?TDVtZCtKbFd1RkttWHJiQVpuOVhEenc1TDJicFgyQ0F2SVhLTnpLYVhnN2JF?=
 =?utf-8?B?RGN0OFVkRzdOSDNvbEFrWmwrNWRJL2prL3NjMlZneURDNzQ3dXpFSFRjSnEw?=
 =?utf-8?B?M3hmTzZ5OHN3UnBOSmFuZEF6ejlQNGJVdlk5eU02OERSOCtUYytrUk54cEZB?=
 =?utf-8?B?YXdJc2w1WjdYaURQRmlzOEpWOUJCaTRjQmRPcXljam9tMW8vbWdLRkpzTXdl?=
 =?utf-8?B?TWVRSWNEeHU2VDFWRFNGTTlqczh3YnNudURKR3k4S05rTXJ6RnErMXJ1Tloz?=
 =?utf-8?B?dlhDN3RNWWI3SXZzM2FCTFN3dmJmUk5qcDJ0NHZXQkhRWjVOYVI5QU5OQk85?=
 =?utf-8?B?T3h1MmEyYXhWZlZwZGJTa3dubFRnV21URW5FUUtxVE41clozYzRiV3hOcXFS?=
 =?utf-8?B?VUh0aU5tM0JIR09ENkpwN1k2TG5IaEprU0I4ejhRcnRNeHRtUE9uZ0cwclpF?=
 =?utf-8?B?MzJVQjJBSEFPOXZQYU9VZ0Q3Z3c5U29rcnRKOGxCR0kzNEVFSTdGUXN6bEJy?=
 =?utf-8?B?SithbUorRjkyRENzeTFPYXJCU2N1SXpqNlFGUFBtRFhjTFE4ZFVqeE5HNTAv?=
 =?utf-8?B?Q0Rha2grTkNLMHJ4bmhJbGw0Y3FmQ3liTUtUQ0x5NUk3MjFnVEwzanBUcEpV?=
 =?utf-8?B?RnpSejhkYmsrUmppOWRyTGFxZzRDaStLZWZwQ0Njb1RBenpZemVxZzZmZFVl?=
 =?utf-8?B?eTlNaTI0bUwraUFpbE5TMnhVRlR3dG1VNndJRkgvdnpLbFFCc21XcmwvYUp6?=
 =?utf-8?B?dmplMU5JK0JFVjJRTVZUMDJJVmMveWJEejMzVmQ3YWxHYjA0TWJxV05NeUds?=
 =?utf-8?B?dUFaMTR5bS9jQ3hoU29FaGhud2pYY0YxaEFnZGNmK0tBVHFqY21XUm9WSC9C?=
 =?utf-8?B?elpKVlo0bkUrMGY1Y3lieHBrbWJaZ2tlRVBlTytxUFh2K1RseDdLQ2czQjJy?=
 =?utf-8?B?SHhHSTgzSDdTWmhhYVZuSHZYZjBzWGxTTGgwS1lxTHN2S2JtZmxTL294cVpq?=
 =?utf-8?B?RmwraFdwU2VMMVBSSExhZk1JeFlZK1BEdnVVSSt4aWRLK0I2WlYrYnZML2Nx?=
 =?utf-8?B?dWhTMXBuaE1wRXhsc3BLc1N6Vk5RSkVVeXR5eTRDdng0endCZGFBYTVFdk0z?=
 =?utf-8?B?OUtIWWd6WTh1QjEyRkRSNHRlMjY2QkxvOHhNMGVVbXRkSEZhUTBBN2ZEb1dG?=
 =?utf-8?B?OFJsMGhZRDdyNzRQeS9lcU1JM3hvUnNhZHd3MXFlcmpoLzk3S3IvVU83amVm?=
 =?utf-8?B?TWJBWEJGblpMMzVkMjEvMUZ5cnYxcnpmZVk1S0EzeHRPQVBlOGg2eGtCN1M0?=
 =?utf-8?B?R0NhN3d6UXg5Zmw3cEkxOFJidzR3VExoSERpMkxoaGtxcmJkK3ZzcGVMVFBj?=
 =?utf-8?B?alRKWVFKZUxoQTFZbVBQWGxwK0ZML21nSHlIN3dOWVYyWVVTQXdyU3hYc2Fa?=
 =?utf-8?B?VDYvckE4RjZScDBjNlIvQjkrK2lZN1cvNWNUT1FIUmh1STVYWXlXZTV4eGNC?=
 =?utf-8?B?WjcxL3BZQ3dIemdsL2xOWHlWMkVYTHlwdC9BR0F2azZqbnhWcXhpSVROOE1O?=
 =?utf-8?B?REJONlBobm5WRWZoN0FDMGZLSnBsYUpFT3hWRklza2Q0Y1IxTWsrTis5ckxt?=
 =?utf-8?B?eTh4dUY4ZzcyUWt4UjR4UTA3cE5TV2V6YjE1N0FIMjh3YVJGUGpJL2tjSi9k?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <183E9793ABA49945A6BAE3B509F74BA0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b06b7e78-91a5-440d-7fe7-08dad37d25d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 09:19:28.4868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOdtpXiPjNXQI/E6kRMpme44LmOLBO1bJOJKypptO8UTVAvuwkWuuUhIhDR73XRg2Z4xbFEmLv3rWJ5lnwqROQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6456
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTMwIGF0IDEyOjE3ICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiAxLzExLzIyIDE2OjI0LCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiBXaGVu
IFNTVSBmYWlsIGluIHdsdW4gc3VzcGVuZCBmbG93LCB0cmlnZ2VyIGVycm9yIGhhbmRsZGVyIGFu
ZA0KPiANCj4gaGFuZGxkZXIgLT4gaGFuZGxlcg0KDQp3aWxsIGZpeCBuZXh0IHZlcnNpbywgdGhh
bmtzLg0KDQo+IA0KPiBXaHkgLyBob3cgZG9lcyBTU1UgZmFpbD8NCj4gDQoNClVua25vdywgaXQg
aXMgc2VsZG9tIGFuZCB3ZSBjYW5ub3QgY2F0Y2ggZmFpbCB0aGUgZmFpbHVyZSBzY2VuYXJpb3Mu
IFdlDQpzdXNwZWN0IGlzIG1heWJlIHRoZSBkZXZpY2UgcHJvYmxlbSB3aGljaCByZXNwb25zZSB3
cm9uZyBzZW5zZSBjb2RlLg0KU28sIEkgdGhpbmsgdGhlIGRyaXZlciBpcyBiZXR0ZXIgdG8gY292
ZXIgdGhpcyBlcnJvci4NCkhlcmUgaXMgb3VyIGNtZCBoaXN0cm95IGxvZyB3aXRoIDMgdGltZXMg
U1NVIGZhaWwsIGFuZCByZXRydW4gYnVzeSB0bw0KZG8gZXJyb3IgaGFuZGxlci4NCg0KIDI2LWMo
MSksICAyNTc2LjA4NTYwMTUyNSwgOTM5NiwxOCwgcnMsIHJldD0tMTYsIHRpbWVfdXM9ICAgNDEx
MzYsDQpwd3JfbW9kZT0xLCBsaW5rX3N0YXR1cz0xDQogMjUtcigxKSwgIDI1NzYuMDg1MDI3Mzcx
LCA5Mzk2LA0KMSwweDFiLHQ9NTMsZGI6MHggICAgICAgMCxpczoweCAgIDgwMDAwLGNyeXB0OjAs
MCxsYmE9ICAgICAgICAgMCxsZW49ICANCiAgLTEsCTMxMzA4DQogMjQtcigxKSwgIDI1NzYuMDg0
OTk2OTEwLCA5Mzk2LA0KMCwweDFiLHQ9NTMsZGI6MHggICAgICAgMCxpczoweCAgIDgwMDAwLGNy
eXB0OjAsMCxsYmE9ICAgICAgICAgMCxsZW49ICANCiAgLTEsCTANCiAyMy1yKDEpLCAgMjU3Ni4w
ODQ5MTk2NzksIDkzOTYsDQoxLDB4MWIsdD01MixkYjoweCAgICAgICAwLGlzOjB4ICAgODAwMDAs
Y3J5cHQ6MCwwLGxiYT0gICAgICAgICAwLGxlbj0gIA0KICAtMSwJMzI4NDYNCiAyMi1yKDEpLCAg
MjU3Ni4wODQ4ODc2NzksIDkzOTYsDQowLDB4MWIsdD01MixkYjoweCAgICAgICAwLGlzOjB4ICAg
ODAwMDAsY3J5cHQ6MCwwLGxiYT0gICAgICAgICAwLGxlbj0gIA0KICAtMSwJMA0KIDIxLXIoMSks
ICAyNTc2LjA4NDcwNDI5NSwgICAgMCwNCjEsMHgxYix0PTU1LGRiOjB4ICAgICAgIDAsaXM6MHgg
ICA4MDAwMCxjcnlwdDowLDAsbGJhPSAgICAgICAgIDAsbGVuPSAgDQogIC0xLAkzOTc3NzUzOQ0K
IDIwLXIoMSksICAyNTc2LjA0NDkyNzY3OSwgOTM5NiwNCjAsMHgxYix0PTU1LGRiOjB4ICAgICAg
IDAsaXM6MHggICA4MDAwMCxjcnlwdDowLDAsbGJhPSAgICAgICAgIDAsbGVuPSAgDQogIC0xLAkw
DQoNCg0KPiA+IHJldHVybiBidXN5IHRvIGJyZWFrIHRoZSBzdXNwZW5kLg0KPiA+IElmIG5vdCwg
d2x1biBydW50aW1lIHBtIHN0YXR1cyBiZWNvbWUgZXJyb3IgYW5kIHRoZSBjb25zdW1lciB3aWxs
DQo+ID4gc3R1Y2sgaW4gcnVudGltZSBzdXNwZW5kIHN0YXR1cy4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4g
PiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDE2ICsrKysrKysrKysrKysrKy0NCj4gPiAg
MSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMNCj4gPiBpbmRleCBiMWY1OWE1ZmU2MzIuLjJmMmQzZDVkODY4NCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy91
ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC04OTcwLDYgKzg5NzAsNyBAQCBzdGF0aWMgaW50IF9f
dWZzaGNkX3dsX3N1c3BlbmQoc3RydWN0IHVmc19oYmENCj4gPiAqaGJhLCBlbnVtIHVmc19wbV9v
cCBwbV9vcCkNCj4gPiAgCWVudW0gdWZzX3BtX2xldmVsIHBtX2x2bDsNCj4gPiAgCWVudW0gdWZz
X2Rldl9wd3JfbW9kZSByZXFfZGV2X3B3cl9tb2RlOw0KPiA+ICAJZW51bSB1aWNfbGlua19zdGF0
ZSByZXFfbGlua19zdGF0ZTsNCj4gPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gIA0KPiA+
ICAJaGJhLT5wbV9vcF9pbl9wcm9ncmVzcyA9IHRydWU7DQo+ID4gIAlpZiAocG1fb3AgIT0gVUZT
X1NIVVRET1dOX1BNKSB7DQo+ID4gQEAgLTkwNDksOCArOTA1MCwyMSBAQCBzdGF0aWMgaW50IF9f
dWZzaGNkX3dsX3N1c3BlbmQoc3RydWN0DQo+ID4gdWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9v
cCBwbV9vcCkNCj4gPiAgDQo+ID4gIAkJaWYgKCFoYmEtPmRldl9pbmZvLmJfcnBtX2Rldl9mbHVz
aF9jYXBhYmxlKSB7DQo+ID4gIAkJCXJldCA9IHVmc2hjZF9zZXRfZGV2X3B3cl9tb2RlKGhiYSwN
Cj4gPiByZXFfZGV2X3B3cl9tb2RlKTsNCj4gPiAtCQkJaWYgKHJldCkNCj4gPiArCQkJaWYgKHJl
dCkgew0KPiA+ICsJCQkJLyoNCj4gPiArCQkJCSAqIElmIHJldHJ1biBlcnIgaW4gc3VzcGVuZCBm
bG93LCBJTw0KPiA+IHdpbGwgaGFuZy4NCj4gDQo+IHJldHJ1biAtPiByZXR1cm4NCg0Kd2lsbCBm
aXggbmV4dCB2ZXJzaW9uLCB0aGFua3MNCg0KPiANCj4gPiArCQkJCSAqIFRyaWdnZXIgZXJyb3Ig
aGFuZGxlciBhbmQgYnJlYWsNCj4gPiBzdXNwZW5kIGZvcg0KPiA+ICsJCQkJICogZXJyb3IgcmVj
b3ZlcnkuDQo+ID4gKwkJCQkgKi8NCj4gPiArCQkJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9z
dC0+aG9zdF9sb2NrLCANCj4gPiBmbGFncyk7DQo+ID4gKwkJCQloYmEtPmZvcmNlX3Jlc2V0ID0g
dHJ1ZTsNCj4gPiArCQkJCXVmc2hjZF9zY2hlZHVsZV9laF93b3JrKGhiYSk7DQo+IA0KPiBfX3Vm
c2hjZF93bF9zdXNwZW5kKCkgaXMgYWxzbyB1c2VkIGZvciBzaHV0ZG93biBhbmQgcG93ZXJvZmYN
Cj4gd2hlcmUgc2NoZWR1bGluZyBFSCBpcyBub3QgYXBwcm9wcmlhdGUuDQoNCldpbGwgY2hlY2sg
cG1fb3AgYW5kIGJ5cGFzcyBVRlNfU0hVVERPV05fUE0gbmV4dCB2ZXJzaW9uLCB0aGFua3MuDQoN
Cj4gDQo+ID4gKwkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0NCj4gPiA+aG9z
dF9sb2NrLA0KPiA+ICsJCQkJCWZsYWdzKTsNCj4gPiArDQo+ID4gKwkJCQlyZXQgPSAtRUJVU1k7
DQo+ID4gIAkJCQlnb3RvIGVuYWJsZV9zY2FsaW5nOw0KPiA+ICsJCQl9DQo+ID4gIAkJfQ0KPiA+
ICAJfQ0KPiA+ICANCj4gDQo+IA0K
