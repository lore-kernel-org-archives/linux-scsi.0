Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E664C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 06:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiLBGrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 01:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiLBGrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 01:47:47 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4381DDDC
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 22:47:42 -0800 (PST)
X-UUID: feb76afc42b545889d11cc2c9b21a31c-20221202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=SG4REZCw3Kf5rDNwHRogRI4FUIKtpZvNnbccGbfke+g=;
        b=OTFMfY5cAzgS0yFVHfEeneCVZhopo78Wxm3nyv7cTcLSn1h6u9/FH5up3FTq7/SK5jOA5pGWVbBgvkeEabZOMjPclibw0h91V8bBhx67LKVoVxST7kRFiiCEdVZgo3+DEFn5JESYK8GaglBlAA7404fBJVnH2+OP1wiq1x30Khw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:9a43067a-1862-4f68-91c8-2ecbe5ed5c2e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:9a43067a-1862-4f68-91c8-2ecbe5ed5c2e,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:dff17830-2938-482e-aafd-98d66723b8a9,B
        ulkID:221202024433FN04C7MV,BulkQuantity:4,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: feb76afc42b545889d11cc2c9b21a31c-20221202
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 650890152; Fri, 02 Dec 2022 14:47:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Fri, 2 Dec 2022 14:47:37 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Fri, 2 Dec 2022 14:47:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Snro0x8KbpYHvFFD2u3YuVt2pYlSZK59rcMCZAOzQGXksnWc7w7VK+zGw3jhOjjx1u1aKidKSLRst3iU3YUidas9C72ITXIOTrQl+T3vLhn09j2tjDfTvtaN2uBJD0q5RRA+ky2DZIEwVGSQzqUgbPygYvv8IPoKM5pmYK0a2cH2MWV4LCivdWH5g8+IjkzQLOYc1A+0mF4TFigSiSfGnNImCVhLW+hCzzzwZoNZRcv0mqVnKVborQCz44xGeuMxeHZ27AbEKq7VPSnpQy7fKJsXGHE5gw3Ty5GFFkwmVdRDTF5di1wq+bQ5xjhQ7/pLevvMud5oy4JrSXEXbuJamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG4REZCw3Kf5rDNwHRogRI4FUIKtpZvNnbccGbfke+g=;
 b=UwaGeosLah8C7xVNt99a2PkFQaR2yKRUhSXtI3mpmtEwlVdE1M+r7Bw+H+nRakk05hXWLPbc0SUL4ubZXBK7SydnDymA7YQoxMnFZP5SsnLHIXz48/j0NhQaHE5GqL2kyBabrO88uOFyCiZrQxJmOvWnMdUdyBTgefwU2sSftXEM7w1G8qEhTYbkGN/9mG7t2erz1sUQ5Aw22J5vZa2DJ4RMcJG/+ojrSnAveZzqOLEoiu7mIZU/TOECFFt526ZUulrBwMxARRY8d3esfyXNYt2FxeTAlBGZCcQlI22yt/gFUNwDyXr/OBvrJOVXvMdkJuz2A9m+xhjtyFLlefeKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SG4REZCw3Kf5rDNwHRogRI4FUIKtpZvNnbccGbfke+g=;
 b=uRNUBB49tSRVDU9FrmSfhRUb6hE4Z/7MqOlhvzFyhlcw4XL2NBW7MpbpPWv+8dgw8+wwdW9hDJt6bqTFgpUDGqp9nGgvF0ZVsvtWBEp8zsXtqTwRu/PDPZGdYLqzVwfHcyy8jScwf8GZoluwl8Hszsr5PndKzQ1Ci6VoEvNmhGg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB5471.apcprd03.prod.outlook.com (2603:1096:400:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 06:47:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb%4]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 06:47:34 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
Subject: Re: [PATCH v2] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v2] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZBWl1ScqHL3ZvzkqkZDIJT+HYga5ZXwuAgADKC4A=
Date:   Fri, 2 Dec 2022 06:47:34 +0000
Message-ID: <4e58e0a42c00baeaa0c3c704cbef4a0642f3c0d1.camel@mediatek.com>
References: <20221201094358.20700-1-peter.wang@mediatek.com>
         <c9a68946-1015-9b9c-1023-94919d001ece@acm.org>
In-Reply-To: <c9a68946-1015-9b9c-1023-94919d001ece@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB5471:EE_
x-ms-office365-filtering-correlation-id: f990b90b-792c-4803-662a-08dad43117c6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sXnhEbD5ABRC36u8SnpmyWfQLYoKrsLZxZApieQWOKN37+EBhDBpcOrdRn8G2lsAF+KOZR7mrOmZqCcvsvONSAG4aCR4/nF4l+Ow5UYSpxvfDjYp8+AtNoD6j5Fc6+X2enH7NhdaIGWRVg1VK/3h2GV3PY2YcD81pd6utmF9c3sqjLxQ+X6Hl+Vw2vCG2yaKQyDBhvKZGzWi+r2euRx79A5ErR8u1QFXjin9FsXImQmO+QrlJlkYqgNxzqNQi65gkyVqbaHL78XtrTiQQVx6I0NO1wEyzmKRP4aKaGzF8timciVzW55/bOWdIV6VSq69kUNHXcmZKFJqUALPUh0DebcyizXcraAsV6vXs5oX9bUP596bsYlzR8hE7rUVZRSEVpec3D5I1SPZJdF1y/lNbRBVJ1+ZwjxlwuCBTQKL7xQoAlzdj5UER+CMaoNiMLpmcIKKPD7ad4Q/xsVM6Ti0EZDXykpxmiqfNC0ixRAMzDScr5JTaUV3RbbqN+CQAB7U46M4nrwJzIdDelX9cAgXP5hoCrsNrZ4P9DmAtUGV/gB3w1gi8HP5Fg4/kx9HxyQMj75QkE2k70MRhGFrF0T+OQx/gf6b8FJ5TcYV/UrmJyFETsE6Kyicxadmsly3DpfoxFNsElN33iL54kQdS9ZgUdVxw2EmcKVUL+/EnMSA6ipUoFjIPo2O+7bSnc9dc0cXRs2lwUkHYUj+Fceoow9xctBXsfJO6Jwww09n5AoDCzGCCel071wsCmKakHOUjpjpinpIduIrOGpJqY1Tn0e/tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(53546011)(38100700002)(8936002)(64756008)(86362001)(6512007)(5660300002)(85182001)(38070700005)(36756003)(122000001)(478600001)(6506007)(8676002)(66446008)(26005)(66476007)(6486002)(66946007)(66556008)(316002)(15650500001)(91956017)(2906002)(110136005)(83380400001)(4326008)(71200400001)(76116006)(41300700001)(54906003)(2616005)(186003)(107886003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWtEaU1nMXZoblNQMzc2OVZVeWFueUhuT0tCMjFBSDlQQkl4My94ZDZMWHFC?=
 =?utf-8?B?VEVQR0Y3MlBrZkFNamVrM2pad1F2a3FTekFRd01HdG1aNEtlcVNKdHF4d2dm?=
 =?utf-8?B?N2NpbHUxWFgwSERTY3hIRzRkQzVLeEpPN2pOeUJFT2taU0wxYXFpWG5tWll0?=
 =?utf-8?B?anZ0QVA5cHRncEg3cTB1bFNnUUR5V3RDV1FKcWtOZVZ4cy9UMXNMQlo2cExn?=
 =?utf-8?B?UngxWW44SEQrOWxGeWw4QmNpVFJPNk5YYlVEN2Z3SGZPTE5CeG0vNFYvZE8y?=
 =?utf-8?B?Z1JGNjFkM0V4L1NPRkRicXJJemlmbW5icEtUNjM2WlNYZDhlS2tyKzFnVGpz?=
 =?utf-8?B?NUt6aEVVdnBDYlBXVERlYTFsMkdHS1Uwelc3TkJQWjZCVE8xUWJTVCsrYTE2?=
 =?utf-8?B?NlVKRTlPRktOaVhuZlR2VGt3ZzAxZ1hIUUVmUTllTWk0L1F6aEFvQlA1a1RQ?=
 =?utf-8?B?b0NGMk5Yd2QwcDUwM2U4WkRHZzB5cXBFK2Ezakp3T1hmaUM3NTVSb1Y4a3I4?=
 =?utf-8?B?N1FSY0NORk1Pb3VrR2h2aWc0M1RUMWU5ZlN5MHNLQ3hSSzlVejlPMVZQOTBz?=
 =?utf-8?B?aFZrbWNHT2liTSt4cFJJMlRTRDZkcGdGaWJDU3ZockcwSG5MaGRxZ1hYOFlv?=
 =?utf-8?B?YXVSV0xBeUxUTHRjT0JzQzA4cDRJSXNPZmthbnRMTmNXRmdoN1BNK0hUM2pC?=
 =?utf-8?B?c3dDSUdFMkVWb04xOEd3Uk9YUUU1R1doQmFURUg4bEtWNkowanZCUkh3RmFw?=
 =?utf-8?B?cy9QTzIvL2VyRjM3YnpaQ1dmMUE2Yk04ZmVLYnlFMEw3R3lrUUpmTmZuWWpD?=
 =?utf-8?B?c0g3M2VFajlKa0YxaUpEV3RkTnhFbWhnSThUdlE1TTBoZzhBek9jR1RkK1Bx?=
 =?utf-8?B?cTRmRjViR3A3V3NDVmZQVVJXaTZ2OE5Ib2ZVa3h3MWJ3VGh1Y0c4aEZNYVFo?=
 =?utf-8?B?L0owQWZKZ2trOVU4RlNqdG5BUWtQczRUbWhQRE1ibFIwcmNrVXdkQThNWHAy?=
 =?utf-8?B?L2ovS25zUXFodm5Wcngra2l3eE5URzZ2dVgwdE9uOVlkdUpodDAvTzJEK3g4?=
 =?utf-8?B?bE5zaHAyYlRKU1ZkUEtaMFJkSjlBSkJzY2RqZ1VsbTBNcmcwbmN3RW1kcllN?=
 =?utf-8?B?L2FjVkNrNUt6cExmM1R1MFg3cDgwVHFPaGtLaW5peHFLaThWd1VvT1lhVm1w?=
 =?utf-8?B?b3BBeW1RaVlxWHU2K3hYQkw1Ui81SWdKVzhmeHlQRmhZV240RmsycldxbENK?=
 =?utf-8?B?MjFTKzBiSTl3VUtaZENaQjJKRWVra1VIVHJRckhIOGNHaTNrb2NuWU8rL3U1?=
 =?utf-8?B?ZTkxS0NvdXZlajRycGV3ZTVFTDNYc0xwcS82L1pvZ0pEaVEvd1ZBb0dkWk9k?=
 =?utf-8?B?S3E4dGNJeWRpdzJtWVFZajIvRUxXSm55V2luN3dJT2F2Nnc5NXRFdWJyMTB0?=
 =?utf-8?B?M2dMSUw4NWpERHJjQnUzYzZoOGhINVV2T3RxTVAxWnp3bzRLV0FmQlE1WGwr?=
 =?utf-8?B?U0ExeEtKNnlTQUxyTGExSi9JTEFycDZsZDZqRkcrTjdvWEg5TFhpVEtxUFZG?=
 =?utf-8?B?cEsxSS9xQ25Dem8wYWN6UFZFUGh2U3p1ajk0VnBQTG1ER2tGcFZmeWRGajZE?=
 =?utf-8?B?RXFITDB6d29JeUJadlVVSnQ3TzRyK2NDRWNKN1ZqNHRJS2lSelk0SG1jZkVG?=
 =?utf-8?B?K014K3RkQmJQaDlPUkVzUmttNkdlaVgrdUswUWdZVVBqMEI0MVhFRUwrMGFH?=
 =?utf-8?B?S1RHTWh5R3VoY041YjAxbmFUSkdYWmxONFdRYmM5Qms1NDdZUlBEN2RuWnVW?=
 =?utf-8?B?U0dBTzdNVnZ0QU1wdHR0TU5FL25PZXVtbzR1cG5ySWZmL1VoMDB1eU11bGxq?=
 =?utf-8?B?RWpQbGtmWjVoQktHbHNWRU1jbGR1Q1IzdE1EdGUwYUZsU0hvVjNsSythUWo1?=
 =?utf-8?B?ZExyMEFhQ3pSaXhFdVFzRHFjWTV5TTE3OVJmaUcxMmZoUUdNbERselR5cFBC?=
 =?utf-8?B?QVRmSk9KUXFMUXlKMTczOHVRNGpWWGMrK2ZsNzlXT09oWW1pUmVOSlgvTWxp?=
 =?utf-8?B?VWhpRUpzQU5WbEN1MG83OXB5cCtTcHZ0OGZsUndOK0NsRW9kc1Z3OTkwUmYz?=
 =?utf-8?B?enpyZ3R1MHVRVlRvektjTFYrYjhxanFNUkhndUxWVVkyRy9mVGZQRHRnS0hB?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9819798C221DE14DA71188735F16E5F6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f990b90b-792c-4803-662a-08dad43117c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:47:34.3242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nMSQ60H8vQs5ud6ibChNpCkBsmRXGokVKW2c4cWK9hpIRoHGWQsUkdqj/DORFIervVDRvbTfq7MRjnAhhWwlLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5471
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTAxIGF0IDEwOjQ0IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEyLzEvMjIgMDE6NDMsIHBldGVyLndhbmdAbWVkaWF0ZWsuY29tIHdyb3RlOg0KPiA+
IEBAIC05MDQ5LDYgKzkwNTAsMjAgQEAgc3RhdGljIGludCBfX3Vmc2hjZF93bF9zdXNwZW5kKHN0
cnVjdA0KPiA+IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ID4gICANCj4g
PiAgIAkJaWYgKCFoYmEtPmRldl9pbmZvLmJfcnBtX2Rldl9mbHVzaF9jYXBhYmxlKSB7DQo+ID4g
ICAJCQlyZXQgPSB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZShoYmEsDQo+ID4gcmVxX2Rldl9wd3Jf
bW9kZSk7DQo+ID4gKwkJCWlmICgocmV0KSAmJiAocG1fb3AgIT0gVUZTX1NIVVRET1dOX1BNKSkg
ew0KPiANCj4gUGxlYXNlIHJlbW92ZSB0aGUgc3VwZXJmbHVvdXMgcGFyZW50aGVzZXMgZnJvbSB0
aGUgYWJvdmUgc3RhdGVtZW50Lg0KPiANCkhpIEJhcnQsDQoNCk9rYXksIHdpbGwgY2hhbmdlIG5l
eHQgdmVyc2lvbi4NCg0KPiA+ICsJCQkJLyoNCj4gPiArCQkJCSAqIElmIHJldHVybiBlcnIgaW4g
c3VzcGVuZCBmbG93LCBJTw0KPiA+IHdpbGwgaGFuZy4NCj4gPiArCQkJCSAqIFRyaWdnZXIgZXJy
b3IgaGFuZGxlciBhbmQgYnJlYWsNCj4gPiBzdXNwZW5kIGZvcg0KPiA+ICsJCQkJICogZXJyb3Ig
cmVjb3ZlcnkuDQo+ID4gKwkJCQkgKi8NCj4gPiArCQkJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+
aG9zdC0+aG9zdF9sb2NrLCANCj4gPiBmbGFncyk7DQo+IA0KPiBfX3Vmc2hjZF93bF9zdXNwZW5k
KCkgaXMgYWxsb3dlZCB0byBzbGVlcC4gUGxlYXNlIGNoYW5nZSANCj4gc3Bpbl9sb2NrX2lycXNh
dmUoKSBpbnRvIHNwaW5fbG9ja19pcnEoKS4NCj4gDQo+ID4gKwkJCQloYmEtPmZvcmNlX3Jlc2V0
ID0gdHJ1ZTsNCj4gPiArCQkJCXVmc2hjZF9zY2hlZHVsZV9laF93b3JrKGhiYSk7DQo+ID4gKwkJ
CQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0NCj4gPiA+aG9zdF9sb2NrLA0KPiA+
ICsJCQkJCWZsYWdzKTsNCj4gPiArDQo+ID4gKwkJCQlyZXQgPSAtRUJVU1k7DQo+IA0KPiBXaHkg
aXMgdGhlIHZhbHVlIG9mICdyZXQnIGNoYW5nZWQgaW50byAtRUJVU1k/IENhbiB0aGUgYWJvdmUg
Y29kZSBiZSANCj4gbGVmdCBvdXQ/DQo+IA0KDQpCZWNhdXNlIGluIHJ1bnRpbWUgcG0gZnJhbWV3
b3JrLCByZXR1cm4gRUJVU1kgaXMgb2theSBmb3IgbmV4dCB0aW1lDQpydW50aW1lIHN1c3BlbmQg
cmV0cnkuDQpSZXR1cm4gRVRJTUVPVVQvRUlPIG9yIG90aGVyIHRoZW4gRUJVU1kgd2lsbCBrZWVw
IGVycm9yIGNvZGUgaW4NCnZlcmlhYmxlICJydW50aW1lX2Vycm9yIi4gKHN1cHBsaWVyIGZpcnN0
IHRoZW4gY29uc3VtZXIgcmVzdW1lIGJsb2NrIGJ5DQpzdXBwbGllciBhbHNvIGdldCBydW50aW1l
X2Vycm9yIHRvbykuIEZpbmFsbHksIGxlYWQgdG8gSU8gaGFuZy4NCg0KDQo+ID4gQEAgLTkwNjAs
NiArOTA3NSwyMCBAQCBzdGF0aWMgaW50IF9fdWZzaGNkX3dsX3N1c3BlbmQoc3RydWN0DQo+ID4g
dWZzX2hiYSAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCj4gPiAgIAkgKi8NCj4gPiAgIAlj
aGVja19mb3JfYmtvcHMgPSAhdWZzaGNkX2lzX3Vmc19kZXZfZGVlcHNsZWVwKGhiYSk7DQo+ID4g
ICAJcmV0ID0gdWZzaGNkX2xpbmtfc3RhdGVfdHJhbnNpdGlvbihoYmEsIHJlcV9saW5rX3N0YXRl
LA0KPiA+IGNoZWNrX2Zvcl9ia29wcyk7DQo+ID4gKwlpZiAoKHJldCkgJiYgKHBtX29wICE9IFVG
U19TSFVURE9XTl9QTSkpIHsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIElmIHJldHVybiBlcnIgaW4g
c3VzcGVuZCBmbG93LCBJTyB3aWxsIGhhbmcuDQo+ID4gKwkJICogVHJpZ2dlciBlcnJvciBoYW5k
bGVyIGFuZCBicmVhayBzdXNwZW5kIGZvcg0KPiA+ICsJCSAqIGVycm9yIHJlY292ZXJ5Lg0KPiA+
ICsJCSAqLw0KPiA+ICsJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBm
bGFncyk7DQo+ID4gKwkJaGJhLT5mb3JjZV9yZXNldCA9IHRydWU7DQo+ID4gKwkJdWZzaGNkX3Nj
aGVkdWxlX2VoX3dvcmsoaGJhKTsNCj4gPiArCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+
aG9zdC0+aG9zdF9sb2NrLA0KPiA+ICsJCQlmbGFncyk7DQo+ID4gKw0KPiA+ICsJCXJldCA9IC1F
QlVTWTsNCj4gPiArCX0NCj4gDQo+IFNhbWUgY29tbWVudHMgYXMgYWJvdmUgZm9yIHRoaXMgY29k
ZSBibG9jay4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCk9rYXksIHdpbGwgY2hhbmdl
IG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzDQpCUg0KUGV0ZXINCg0KDQo+IA0K
