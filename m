Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D50C63703
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiLHDA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiLHDAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:00:18 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F819950E3
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 18:59:52 -0800 (PST)
X-UUID: 0d9d9e6e48c24f9481eecde9049f7696-20221208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wN4JD/GAEqVgMCVgXnqMQX7EyIMZ+Pm5XGYF0idyC9s=;
        b=dCWr9sz7wsbE29X3TYaV0QVnVIgloBM3k/59YMgfYVv7EN/+vJhUYVlFraQiu2AWC9PutJT1BLQU+6XemgHG9MhNI4nod5VPHdXLBNFLS7X8fF7NX2cg0b94CgiQVGwKyttUH6REPB3WvF+l2LA1mjZk8Prl55BiVKqnuzHWj54=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:960e3af1-058e-4831-8a5d-05ab9c884d0a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTIO
        N:release,TS:23
X-CID-INFO: VERSION:1.1.14,REQID:960e3af1-058e-4831-8a5d-05ab9c884d0a,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTION:
        release,TS:23
X-CID-META: VersionHash:dcaaed0,CLOUDID:6cc6f8d1-652d-43fd-a13a-a5dd3c69a43d,B
        ulkID:2212061133541Y3HDSRE,BulkQuantity:14,Recheck:0,SF:38|17|19|102,TC:ni
        l,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40|20,QS:nil,BEC:nil,COL:
        0
X-UUID: 0d9d9e6e48c24f9481eecde9049f7696-20221208
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1766197085; Thu, 08 Dec 2022 10:59:45 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 8 Dec 2022 10:59:44 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 8 Dec 2022 10:59:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idfTrlFkdAT7RuTai/uWoqc9UZ0pcN0L4h7bZC5+/duHhMfKBEIcuVGJDSRy8yIGXKE0PJoLS7zXiLpkaYwb1LFhjTM5pLxMNzi+GOtL+mCnfLG+jL/nLoKWT78ibyDwob+m0Ehcrkrn6mNq3+sTS0fvHZmuU8u0OAkpFDm/6evDPIhgWK0jn27f2bf+ooukoR/stMYHDuNvs1qXs8UJKiUSey9BGETxst6e/rCA1D1pwhh4km4UOG7fI9S+UYCUxp8r2cpDJvG0yhGEoRspAU06epYBran6uYblP0mntQIZ/T8o67h8200QarPOr+/Tt1OOZbznnun0rBcCQaVSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wN4JD/GAEqVgMCVgXnqMQX7EyIMZ+Pm5XGYF0idyC9s=;
 b=KaD8RJzFC2UOvc4/WB2BwM2Zd4N4xnMqJDwn6VJ7NH+J50U02MPYVJ5rhwlBry/15bDW8PiGM9waHRVqLc9zRSexrBIH0v4R9IIVd6rjpv4Q1zX5vZ8Xc5HMEj+vw0WBmpuaVxkHlU3JTgkoX72WhhHEtpTg0mVN2frZo1jHoEcPr2L91E9hiuvIGi/5yzwPuMzvz1lzikRMF4aPj6aRGAnWQEmR47r7owhxJKnIz4eyD/TknOtcSLKujbPJpqftlHHqhd8RpjKshKfj7IvwiEY4fdG8T/c/JadLF90Eyb1kbmYCYxK2+/WzWVikhIPZSIR0GBNBKW2QhxSWyuCFUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wN4JD/GAEqVgMCVgXnqMQX7EyIMZ+Pm5XGYF0idyC9s=;
 b=FfoJK2AZxhecsW4SBOGSJ99KGC7txqE1lUx8rNlyJYcDSGNVkKOpKAoPJqt5iymKW5rSSMRzd/H6UoUh6XNnXrLoYRxf7jwF+u+EM511X4KsvqvEsDArQBMMBvUTg9nt/XRNrkJj+7275HbG25W874wpInsCZXOtmPPM6OsUf1g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB5563.apcprd03.prod.outlook.com (2603:1096:4:126::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 02:59:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 02:59:39 +0000
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
Subject: Re: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZCSBmwUDmapEV8U2DywnZbmWqca5irU6AgACiqQA=
Date:   Thu, 8 Dec 2022 02:59:39 +0000
Message-ID: <440e135732277e1cb12e688036325150e510b2f5.camel@mediatek.com>
References: <20221206031109.10609-1-peter.wang@mediatek.com>
         <4ddd814b-c8ed-8ac8-710d-aa317882fdb1@intel.com>
In-Reply-To: <4ddd814b-c8ed-8ac8-710d-aa317882fdb1@intel.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB5563:EE_
x-ms-office365-filtering-correlation-id: 2ae9a057-c160-440e-a0f0-08dad8c83f5b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C3BUZib0QXckiBERp9f+wdh55Js3P66BPg+JzZ5dEvH+W0mFAIhrDtkEUTFC+LZIuicbK/L+3oOwxgVfV1Xt9W+e1hipDmLtEapmxn448cQOocyTyBWdIjR3FL+VAtFNBIOOaOj5t5GQFuJiLyLVMOOTpfkpF/2s5js+pVeJl8t5DKjX0iApgxqx9O86S3bTqAwA+2/wZusBOZ+B2eUzvKrIyH0e/vQ+GVh1+f7iOq3+FGLlvPOlpPFjzj+m19hJU0qLM6GW66QIU8a/cSdfh/D4nBCjOWXml+unYw66Ga9u4gjLvnXAg+yZ5I5d3I+zvUEHWOGN7j0fRBD1mbHR35prtA0EOxrjuYOroeQuZWSzPUPRLeW9lh+6jEBkRUJ7mX8M0hqUfiL9RcNcZfT5vW73moKvMdJ+lGlMuCz0Y7iaN8O0/W5e/K8JHrn0KJ19ZnAUVz44XNn4Ts4AZNBm2PyHqaszKNnwO8zvGL7XyJGfsY0qpY38ot4Q4g4ePV8AZ/acTBw2s16y8dXBWVNg2clCwrdJjlJ1O799Uq4qRG5UlFA9Rc5sx4NCdRNrGr/72NP8wdzkFm02hAJ1qNVJ64U82JtcXwd0LHQFOKKGka58zfVwJ6rjEGj8FnDGlpF9RuJ/fDrPYFzf/BNns8ei6Q+Nhn7ZkfKTo3JZw8iqU0UEyMMbPX7BZdcfAClVO0jK2WQTxQSCU/jJ3Hai6gvZGrt9TEWjnNwmsW7SJg4njWo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(2616005)(83380400001)(186003)(6512007)(53546011)(26005)(6506007)(15650500001)(66446008)(122000001)(36756003)(66556008)(66476007)(85182001)(66946007)(8936002)(76116006)(64756008)(91956017)(38100700002)(107886003)(6486002)(478600001)(2906002)(38070700005)(5660300002)(71200400001)(41300700001)(4326008)(316002)(86362001)(54906003)(110136005)(8676002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEdNb2xzM1J4bUtHeS9wMEJQc3lBYnZ1TWJ5QkUzZDFlWFlULzVkQmt3TU1W?=
 =?utf-8?B?QlM0UmpKVzBtVmp3VjBiMjFYSmxyUUVDZFVTMUNCOElEK21ZUUJLY0o0Z3NV?=
 =?utf-8?B?NWhKZzlVYUFwNWRjTGJLUFRvQnZpSFo1ZzRTVkRKR2taaGFlNDJuUDBXV3g0?=
 =?utf-8?B?L0ErclFFV3JJUjVTV0thbTBNSmhFNW1FVmZUQ3ZYV0JIRnFVWEJPSm1uQmYy?=
 =?utf-8?B?Mm9yeXR0VEgrZ1V3YzdJSC9EUEVscjFmdERGRWRwenNMTisxT0h2bkMyQkxq?=
 =?utf-8?B?dG1Fdlg4WDZZZlRBTHVDZzJhemtMNUwxRlNpcmt4WS8zVUt3bTQ0cWZPdFJu?=
 =?utf-8?B?RHJoMFJkWlA0di9WTkdTNUJRWjJ6TnJBdENSTGJqdEdwc25qNTB1SHpvVEcr?=
 =?utf-8?B?dTRTWVc2WUk0dGY1NEZQZ0Vid0lmM2hEVnc5MEN3eDJuSDlrSjhxTFlHWnRx?=
 =?utf-8?B?cGQvKy9FMGdCN3NhN0g3U3JWZVNnSUZlTjd1eUg1YXdnNVgxWVZWbDNUNUZM?=
 =?utf-8?B?MU1IMUcyMnFZa3pSYnpaYU5Lc0s0ZVE0SDV4Snl0eEsvTFNzb2laL1hya0Jn?=
 =?utf-8?B?YXpLSUhneXNsWGtyaHhONStVcUNGcFVNM0JYSTlMM3lkdXpBSGs0QjlvUVdQ?=
 =?utf-8?B?QmZ2ODY0Sk1yOXJSTTVMc2xVS3M1RXIrRk5Qb29DVFEwckIweUF3TThEcVp0?=
 =?utf-8?B?WWZyK2xkZkJDbkZvRHNVTDJ3NVpjREo4Y2tweDIzbVVjYmw5bmtoaEtnL3VS?=
 =?utf-8?B?bk1EUHZVWHR4Z29FMjQzOVFSUkZkRGtkYWhlM3JkYS9UMUdNamt2TjZCb3BB?=
 =?utf-8?B?UE15TWFVU004djJ3ZENMU3YvNHVzbjRIbVZKd2RzL2hzK3MrdWZ6R1dibmFy?=
 =?utf-8?B?VVkzcEljd0dlRFUrUmFZQkdjN3lWcXBJRjdMcmhPMGNCZ3R4M2U4S3NGN3hT?=
 =?utf-8?B?RGFod2lnbXJNWm1lYW1uakJabTFiVldFanhjMlkvRGhXUTBmb0FpZERNRVpv?=
 =?utf-8?B?emtCdlpUY1JQRHFkcjA1UEFJUkJCSjFZOWJWVFUyeWFJamYxbEQ5b2FSUndX?=
 =?utf-8?B?cEJKbGEvVGxHMS9LZzhBdklCRk1zc3ZmcUFhVVI2NkNPTWxDcG5vMWNBbU1F?=
 =?utf-8?B?OWFOMkUrVXVaSXBCS0txSmw1bzI2WnNtR29ML2UwNE1SZVBiZE54UVhQYWg3?=
 =?utf-8?B?MkNGOTdSaVpkZUFDcXgxako0aFRTazhHblQyemljY0xOUnJPcE1FbUIzNTNy?=
 =?utf-8?B?aSsvMlZSOUNpekRCU0ZobzA0bk9pY0xsdHBvRlIwR3lmSExab29ndWQ3VDVZ?=
 =?utf-8?B?eWdZNjV5VXJSNHd0WTVhb3pBRlVpY2Z4K214THZNRWJtK0JWUGgxdVhWbkla?=
 =?utf-8?B?enpoRm9IU2xld1dYd0NsQm9uSzBidUVkWlZNR1orcGpBYVdSN3ovOWYvdW54?=
 =?utf-8?B?bU5STzZBeVFISjdwMGJIdXdhZlk0Y1d2ckdXODlJMFZWaUR0dzRrM2paY3Vx?=
 =?utf-8?B?NUgybXQ4SHNzUUt5T0ZaTFFjTnNGK0F3Tm9BQ2JMQ05zZnZNKzRIRnNIUisy?=
 =?utf-8?B?eFJDM3BqRTRnTVRGbFREMTJHbmh5ZGhQZERWV1dNTWxHMWhuVGQrcnk4YUxG?=
 =?utf-8?B?VHZLaGlBNG9xczBYSERrVTB2WXFadkppeDNacDlTcDROVWtVTmRyb2hxR1Nw?=
 =?utf-8?B?MElWRXc4SENEcjlNSm8wZytudzgyMFhHZXZHamc1K2xQRlJqc2VNcWlLQVF5?=
 =?utf-8?B?VzU1ZmI0b1VlQU1yNm8yR3NOSGRKL2o4LzFGTmdRUDZBWEZSTzhjdUN1QUpM?=
 =?utf-8?B?Nm14SUNKOWFNV2xFdmx0MnNpOUl1UXJRS2tlSmlhQUJJUFgvT2hTU0NUSjJo?=
 =?utf-8?B?aGVLcEVPTXdQampLZzBWeHFFTGVlaVBsZ21jR1dyZGJITVVmQThkL0xYMlhw?=
 =?utf-8?B?bjJrMWJxd0ZxeForeXJjRGJoWjdWR3A2Rmhla2ozeExuYnZIV0Fodk5CRTQ5?=
 =?utf-8?B?SFVjSzVuMUFXMGRadHhCMittN0hUUWJsQTE3RTdwaTlIbHYzWSthcElwRVdw?=
 =?utf-8?B?MU5ETmFLdytpQzNxZDAzc0diaHY2QmYzeEJhUlVYRGhtZGdGQlFNR2xqQ1ov?=
 =?utf-8?B?SHJCazZUa3A3eHJFSWF6Q25GeGROdll3WVprOTBpRXNMN1o5Vi9EK0hobi9I?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63AE6B94BFE8D14A84A955AC146A0530@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae9a057-c160-440e-a0f0-08dad8c83f5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 02:59:39.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVuHOTU6CIO7ov5BgaPrkDoymaAWS/j6dYpsVZIfBdV6TwztfeK4bgqrXSW1scGF61a6LDSX/4mJIhzqY+e8fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5563
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTA3IGF0IDE5OjE3ICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiA2LzEyLzIyIDA1OjExLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiBXaGVu
IFNTVS9lbnRlciBoaWJlcm44IGZhaWwgaW4gd2x1biBzdXNwZW5kIGZsb3csIHRyaWdnZXIgZXJy
b3INCj4gPiBoYW5kbGVyIGFuZCByZXR1cm4gYnVzeSB0byBicmVhayB0aGUgc3VzcGVuZC4NCj4g
PiBJZiBub3QsIHdsdW4gcnVudGltZSBwbSBzdGF0dXMgYmVjb21lIGVycm9yIGFuZCB0aGUgY29u
c3VtZXIgd2lsbA0KPiA+IHN0dWNrIGluIHJ1bnRpbWUgc3VzcGVuZCBzdGF0dXMuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBTaG91bGQgdGhpcyBoYXZlIGEgRml4ZXMgb3Igc3RhYmxlIHRhZz8NCj4gDQoNCkhpIEFk
cmlhbiwNCg0KWWVzLCB3aWxsIGFkZCBGaXhlcyB0YWcuIA0KVGhhbmtzIGZvciByZW1pbmRlci4N
Cg0KDQo+IEFub3RoZXIgbWlub3IgY29tbWVudCBiZWxvdywgb3RoZXJ3aXNlOg0KPiANCj4gUmV2
aWV3ZWQtYnk6IEFkcmlhbiBIdW50ZXIgPGFkcmlhbi5odW50ZXJAaW50ZWwuY29tPg0KPiANCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDI2ICsrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspDQo+ID4g
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jDQo+ID4gaW5kZXggYjFmNTlhNWZlNjMyLi45OGYxMDVmMzI4NzcgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtOTA0OSw2ICs5MDQ5LDE5IEBAIHN0YXRpYyBp
bnQgX191ZnNoY2Rfd2xfc3VzcGVuZChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEsIGVudW0gdWZz
X3BtX29wIHBtX29wKQ0KPiA+ICANCj4gPiAgCQlpZiAoIWhiYS0+ZGV2X2luZm8uYl9ycG1fZGV2
X2ZsdXNoX2NhcGFibGUpIHsNCj4gPiAgCQkJcmV0ID0gdWZzaGNkX3NldF9kZXZfcHdyX21vZGUo
aGJhLA0KPiA+IHJlcV9kZXZfcHdyX21vZGUpOw0KPiA+ICsJCQlpZiAocmV0ICYmIHBtX29wICE9
IFVGU19TSFVURE9XTl9QTSkgew0KPiA+ICsJCQkJLyoNCj4gPiArCQkJCSAqIElmIHJldHVybiBl
cnIgaW4gc3VzcGVuZCBmbG93LCBJTw0KPiA+IHdpbGwgaGFuZy4NCj4gPiArCQkJCSAqIFRyaWdn
ZXIgZXJyb3IgaGFuZGxlciBhbmQgYnJlYWsNCj4gPiBzdXNwZW5kIGZvcg0KPiA+ICsJCQkJICog
ZXJyb3IgcmVjb3ZlcnkuDQo+ID4gKwkJCQkgKi8NCj4gPiArCQkJCXNwaW5fbG9ja19pcnEoaGJh
LT5ob3N0LT5ob3N0X2xvY2spOw0KPiA+ICsJCQkJaGJhLT5mb3JjZV9yZXNldCA9IHRydWU7DQo+
ID4gKwkJCQl1ZnNoY2Rfc2NoZWR1bGVfZWhfd29yayhoYmEpOw0KPiA+ICsJCQkJc3Bpbl91bmxv
Y2tfaXJxKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gPiArDQo+ID4gKwkJCQlyZXQgPSAtRUJV
U1k7DQo+ID4gKwkJCX0NCj4gPiAgCQkJaWYgKHJldCkNCj4gPiAgCQkJCWdvdG8gZW5hYmxlX3Nj
YWxpbmc7DQo+ID4gIAkJfQ0KPiA+IEBAIC05MDYwLDYgKzkwNzMsMTkgQEAgc3RhdGljIGludCBf
X3Vmc2hjZF93bF9zdXNwZW5kKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1f
b3AgcG1fb3ApDQo+ID4gIAkgKi8NCj4gPiAgCWNoZWNrX2Zvcl9ia29wcyA9ICF1ZnNoY2RfaXNf
dWZzX2Rldl9kZWVwc2xlZXAoaGJhKTsNCj4gPiAgCXJldCA9IHVmc2hjZF9saW5rX3N0YXRlX3Ry
YW5zaXRpb24oaGJhLCByZXFfbGlua19zdGF0ZSwNCj4gPiBjaGVja19mb3JfYmtvcHMpOw0KPiA+
ICsJaWYgKHJldCAmJiBwbV9vcCAhPSBVRlNfU0hVVERPV05fUE0pIHsNCj4gPiArCQkvKg0KPiA+
ICsJCSAqIElmIHJldHVybiBlcnIgaW4gc3VzcGVuZCBmbG93LCBJTyB3aWxsIGhhbmcuDQo+ID4g
KwkJICogVHJpZ2dlciBlcnJvciBoYW5kbGVyIGFuZCBicmVhayBzdXNwZW5kIGZvcg0KPiA+ICsJ
CSAqIGVycm9yIHJlY292ZXJ5Lg0KPiA+ICsJCSAqLw0KPiA+ICsJCXNwaW5fbG9ja19pcnEoaGJh
LT5ob3N0LT5ob3N0X2xvY2spOw0KPiA+ICsJCWhiYS0+Zm9yY2VfcmVzZXQgPSB0cnVlOw0KPiA+
ICsJCXVmc2hjZF9zY2hlZHVsZV9laF93b3JrKGhiYSk7DQo+ID4gKwkJc3Bpbl91bmxvY2tfaXJx
KGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gDQo+IFNhbWUgNCBsaW5lcyBvZiBjb2RlIGNvdWxk
IGJlIHNlcGFyYXRlZCBpbnRvIGEgaGVscGVyIGZ1bmN0aW9uLg0KDQpPSywgd2lsbCBjaGFuZ2Ug
bmV4dCB2ZXJzaW9uLg0KVGhhbmtzIGZvciByZXZpZXcuDQoNCj4gDQo+ID4gKw0KPiA+ICsJCXJl
dCA9IC1FQlVTWTsNCj4gPiArCX0NCj4gPiAgCWlmIChyZXQpDQo+ID4gIAkJZ290byBzZXRfZGV2
X2FjdGl2ZTsNCj4gPiAgDQo+IA0KPiANCg==
