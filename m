Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCEEC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 09:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjHJJEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 05:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbjHJJEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 05:04:45 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A662107;
        Thu, 10 Aug 2023 02:04:36 -0700 (PDT)
X-UUID: eb566ffc375c11ee9cb5633481061a41-20230810
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=/ZgIKJKjeWlN7K+eCvFjebQ1LIJ2wSVBbNJZJcCLk8U=;
        b=UF4GURGElVG8golA6U4NF7vOpUVHuibm2DNMy7UJrV4P2v0VUNK4Fy+O1UvFMFuCmYDtLP3Nctl/wZT61OXfkTYbnW4Fg4ERIkHxw3+T69bOsMDAGi45GsHYQB+DOeC8mGATQ63piosZcvFAt+c/9gc8jSSu2mEBxR8Z59/VUu4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:b358690f-1607-44f4-b98f-eed8924fa609,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.31,REQID:b358690f-1607-44f4-b98f-eed8924fa609,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:0ad78a4,CLOUDID:5c549d12-4929-4845-9571-38c601e9c3c9,B
        ulkID:230810170433L3YSGDY7,BulkQuantity:0,Recheck:0,SF:19|48|38|29|28|17|1
        02,TC:nil,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:ni
        l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:PA,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_SDM,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,
        TF_CID_SPAM_ULN
X-UUID: eb566ffc375c11ee9cb5633481061a41-20230810
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1989039216; Thu, 10 Aug 2023 17:04:31 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 10 Aug 2023 17:04:30 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 10 Aug 2023 17:04:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2QmiSgCMAKw68S9W/WrX/wZHaPcFBDky7l8scD4/HPqqsS5185NMGS6P+bw8I7WTmQyPrntzTLNj6Lhhh/ulfMpNokRnPMJbvHXMbyBbUFGWL6FXXanNCaDO1FCbTwFXp87cTzmzkaf1lY1yAikmHlRcys05xXny49jj6OPdDaYU7uPjRgUrCNonBc3EzB7Lxr224R57NamrCzDHH4WCtagUYFjgFt48LeBn/DjgH/zZIhFTy2SSQqM59Q78hoz43tdPZrdiI+hxEt5bTxuuU3x58LgrhIquAa+RRlK52sF4ad1aoMmH6LDVTxgIJbsqkpkke2lNNpUufIcUrt50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZgIKJKjeWlN7K+eCvFjebQ1LIJ2wSVBbNJZJcCLk8U=;
 b=UJrU9z3DPM0umvQzv66WTLYAA/Ycu09ag4bdoV/edAq2OtiZb2WcnVz7yhsXXOtqiJRS5dBeq2nCrHxH4PS/IMbs274c376F5twlQlAQsibUbWAH+xuYl3BFM1KUgDjcFUeauLSx9HACe+5v1L6/rgjHtPcqkhE8NDjse40V/Kn39/Gz+AyGlDk4XV06vWp9mwjwd9PfNipNpzPKnVQNer9pyoi39GvWQog9mPhBXnsl8f+274bccY4df45MPjWu3Mz08O9a0LFcoJDrc/YBpXJFxTO31L+NQ2+dc+j75FgynwTXGJmQjDaa1dOqAyJUZGSHQhfdLR/VejM24Oc9zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZgIKJKjeWlN7K+eCvFjebQ1LIJ2wSVBbNJZJcCLk8U=;
 b=Vhpzt6WKKV6HuKsUqgsPfXy1YrKy18IcMWPHX0xI4OuLMxFf9O1qS6Q6yqhO0cuJtRPpMnAAdGqFNmr+bSVCc+kKhYUYsqkbmvVb402c4qo4ujlyHLnbO/odLvdPZQfHzXn0Le0zthicMxP69LRCviXpPiA+GS19RVwAvWChOvc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8216.apcprd03.prod.outlook.com (2603:1096:405:28::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 09:04:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::1275:329f:a1a6:a9a1]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::1275:329f:a1a6:a9a1%2]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 09:04:28 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: only suspend clock scaling if scale down
Thread-Topic: [PATCH v1] ufs: core: only suspend clock scaling if scale down
Thread-Index: AQHZxHz720OxxTdKwkSM3XR67WC7o6/jSlqA
Date:   Thu, 10 Aug 2023 09:04:28 +0000
Message-ID: <3ad406db04438955ee521230d79c613904fca5a4.camel@mediatek.com>
References: <20230801133458.6837-1-peter.wang@mediatek.com>
In-Reply-To: <20230801133458.6837-1-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8216:EE_
x-ms-office365-filtering-correlation-id: 6b1cb458-83f5-4c45-909b-08db9980cd4e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bC5241d6NlBmszbfxs8ghpgx4TAbdSkZbRG+Fsk78avp6s/sl6WCkfiNAoNANP3a99W2EcKjdVRCAdrfEzyJzj2ES6uGtaclUYPoGtdjgvbf0lPrAL8+S/+Yz6KLt9q3rBDj2IWwnnsPSevjM1FUCGhTlj4CrlAZKKQvfmpeoCy8H+lKpYXYGf5tRPuXBf+Z2Da5AaPzoB4nI1uE2U6xxIAMdXqItnA1XAggtHu2PslIWMIcHDODY1DCXHyg59NUxbz1EHcI4/m33MztKBb5TshteuCFmewdVjNtWjFDKp9vqUaNfbLMytckroAFGEcC2LIp+gYJ5IZgfOAVlwgVdBd9522SI47yHdlO8mXwudbt4Air4EcBqcxAQpMlPdsCS6Tbh/Q30dxoyQVQQQcvykPsmcun7Ow0vh2edon0IeN82xIgdxe/M8NCbMCaR1PfkpwjqSuA9Lhq1YqwHNzr7dZ4yxb0SvsYMmQCHUdy9AyKjDftO2affANqT/IcTPixdXPzOXqe4lULMqW7sJAcBd8lHBw5Im81uBIfQMGQCY/imer2KagaGh1q9q69M8VOkSjDm8BuTlsnkoJTUQWy3Naj9sFwKC43uP2e0cwPt84n2YgkQJIfW9OPiMYIho3G8swUunNwisghfTFli4qFdlLbmzFmD+Ox03urYPZ2yE23UyKeE9IZ9mR9kgVgkvmnkw7/X/JOd67cHtC2NoIbcC8JdkqYSBjS61WvNpPC81k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199021)(186006)(1800799006)(85182001)(36756003)(76116006)(478600001)(71200400001)(91956017)(64756008)(66946007)(66556008)(66446008)(54906003)(66476007)(26005)(6486002)(107886003)(6506007)(110136005)(6512007)(4326008)(2906002)(41300700001)(316002)(15650500001)(5660300002)(8676002)(122000001)(8936002)(38100700002)(38070700005)(83380400001)(2616005)(12101799016)(86362001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sks4VW4yYlhlaTNJMUNHSlN3eUZNVHR3OTJmd3E3c3NWTUxSV3dKNmJFV2tp?=
 =?utf-8?B?RitBUW93QklTNzZHZjRNMGZwYkJXbFFraDhNUWV1b0ZlZDZRekEzUXhPa1Y5?=
 =?utf-8?B?Uy8va1dQeGhodFF6UVVrRkVHcVRXY3lsM1cvT014TTQ5RWppQ2JNUlVmdlZV?=
 =?utf-8?B?aGtrMlpRNHZqQjlHMDhmZmhvWHUwQ21EVGpreTM1UFFOTVlYU2wwSzc2eXBz?=
 =?utf-8?B?MW5oS2ZLZmVKSzhWRTAyelpzV0N5eXV4Umxpei9Yay9HaGRDRG9kK3hsUHA1?=
 =?utf-8?B?Z3ZJdWZUSUs1UXpiVSt0OEVncWU5dTFCUlVVaVhRd1RvOTloRHlDbnFPSzFz?=
 =?utf-8?B?SmZrb0RGRjdodFhtbzdLTC9ZdjFPVmlIVjlOZmFCVkt3WGM3QzdRZzdSMGla?=
 =?utf-8?B?dWNIM0ZtdDIrYi9ZQ0kxUWNuM3RiQ21SbHZJYnFqL3FERkcvUTNiTVl3bzdS?=
 =?utf-8?B?UGxVZDlIbXVudW9oNms4ZjBiN215djhLZEFYM2FFdzhOUkM2RlpML1ZGTlNi?=
 =?utf-8?B?aGJjVUhOcGFzRWhEN2doSjB2SU4zU3QrUmtueDJMaWFteVFvbmkyemJpNWln?=
 =?utf-8?B?dHRCWnpvR1p5WDZ2VmViaVlya3VjOEFyN0piSitsUE4yRHBuMzZ3M0tyN050?=
 =?utf-8?B?WUo0bEtqZ1VzRDdOT2lKbUtHV1IzeXd6S3ZRdkRkYWpPeTBhUzBqUEVGYlRh?=
 =?utf-8?B?bjJkRE40UVNxRCtYUWhuMFF3cHR0eVNCVExsZVJqeVpDM3paaS9US2N3YVZ0?=
 =?utf-8?B?Q0NyT1hXMDAxTGdheHVJbkNGM244UmZzMjA3VTIrV3g4a3BZYlU1a2E3U0Vm?=
 =?utf-8?B?b0VWaWpteUFJTnVsM3JjQVFJNE9QSVpQQ0hXNk5VOHNJZEVMTlErV2tRUlpa?=
 =?utf-8?B?M3dVZjAyenVyTjZLM2tTMDhpQXpqWVpCV0FSdERLSlZ4d3JiS1VZTzMwK0xz?=
 =?utf-8?B?bm1pZlRJaDRKTWw4Z1lKeWJoMmxhcjJROGprSHdIWEZsMHduVC81S29uaUhP?=
 =?utf-8?B?S1J1QlRnSUVLK3JheTd2MEdxVDZERzk3T25Ld0FQWmFKTmx2RGRvV2dCVksy?=
 =?utf-8?B?Yis0T0VUZU91Umg0OXk1WllYUEpleVhaMjNKSk1Ya2JkQ0NMRkpkYkJ3TlRU?=
 =?utf-8?B?ODhOVXg3YjBudTQxbmZWUk5ES2UwM0s2UFdYOHFMMk82T29NbUFvb0lKQ3Zi?=
 =?utf-8?B?YTh6RWUrbHJEbG40T1NTd0JWajZmY0RWTThsL0FpR2wvV3VuVktWVkY1TWFq?=
 =?utf-8?B?WWljeFdPMytVV2kwbVFNZ2VRV3IvOHRnZStUdW11bmNjbWhLVG94eFF6dm9r?=
 =?utf-8?B?Vk1CREZiMzhiYXhQKzAybUgvbERtdEJtWVcrdElHNVc3Y0gwSUFpMG1ZeW9X?=
 =?utf-8?B?OWdqb1BhNmN6UVJXVWsyajVJRU5YQnBFa2Nsa2gzOWg0OXd0NVp1MStkU3Z3?=
 =?utf-8?B?NWd3NnJSbzRMUit0aVVvaTJRdytsdFJkWUNXQUtRLzU4V2xGK09UNVRuUmYw?=
 =?utf-8?B?dkUrcEhocVFZcDZvQ2ZlQlQwLzdwcDZPVFFIZHlDQUV5UEN5cmgrdmRkWSs2?=
 =?utf-8?B?U3JyU3dzcEkvUVJWZFYxa2xRSGJEY2tmaHgxU20wL0YwbHdmY0JrdVBPdy9V?=
 =?utf-8?B?QTlkWTVHQWNudU0wOXAvM0FKaFIxaTZKa01qdlNQd01rTzBhaHlhOU5GWTdi?=
 =?utf-8?B?R09qanFjY014c3hQTytrcC80SFJLRVRaUU9Ta21jMzVVOFoySStZYk9yZlk3?=
 =?utf-8?B?MS95QjJEdmJyWG1leElmRjByb0NXdlFXd3hkK3d1TWpvWmtCWUNscm0vUk55?=
 =?utf-8?B?RzY0VWd0Z0NTK0NML2hEVVhZOWJyeGFlRkR3VHM4dGdpajJyVmFnTW1lSWZO?=
 =?utf-8?B?c0kxZHhtcEdKcDdaOTh1cGo1cG1LMjMzSGtlRjZyd2RyMkM4SVg2eXpCNFRM?=
 =?utf-8?B?TndJcUpsdlFLbnA3bS9JNTJsWlAvL3lIVllUOXdkQWpSYzMrKytGbEJTcjZm?=
 =?utf-8?B?NG5GVFJmME13ZWZWYU8rMlpjczNJZms1aUZKS1ltNDF4VE9XaDdyR3BTQXQr?=
 =?utf-8?B?OUVwR3UzdThzaDBwY3FXV3pBeWNxNTJxSnl0UXR3ZUNEUUNyZXZ1UThNcEVy?=
 =?utf-8?B?d1QvU1dVZ2dDbHVQOEt6RzFpUzNXZDNqRnMxSnc5b1krdmFYems4VDY4OW1p?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F57D7F97C5B60F46B87880AD01958255@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1cb458-83f5-4c45-909b-08db9980cd4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 09:04:28.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2CZNQCIhjljl0G9M++DyTvS8nWrWYf19Zthsta8+VHHw3pwG7mCMI49iKULNm3rXChxNrqKTXVCOR7vuOmwlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8216
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgYWxsLA0KDQpHZW50bGUgcGluZyBmb3IgdGhpcyBidWcgZml4IHJldmlldy4NCg0KVGhhbmtz
Lg0KDQoNCg0KT24gVHVlLCAyMDIzLTA4LTAxIGF0IDIxOjM0ICswODAwLCBwZXRlci53YW5nQG1l
ZGlhdGVrLmNvbSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20+DQo+IA0KPiBJZiBjbG9jayBzY2FsZSB1cCBhbmQgc3VzcGVuZCBjbG9jayBzY2FsaW5n
LCB1ZnMgd2lsbCBrZWVwIGhpZ2gNCj4gcGVyZm9ybWFuY2UvcG93ZXIgbW9kZSBidXQgbm8gcmVh
ZC93cml0ZSByZXF1ZXN0cyBvbiBnb2luZy4NCj4gSXQgaXMgbG9naWMgd3JvbmcgYW5kIGhhdmUg
cG93ZXIgY29uY2Vybi4NCj4gDQo+IEZpeGVzOiA0MDFmMWU0NDkwZWUgKCJzY3NpOiB1ZnM6IGRv
bid0IHN1c3BlbmQgY2xvY2sgc2NhbGluZyBkdXJpbmcNCj4gY2xvY2sgZ2F0aW5nIikNCj4gQ2M6
IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxw
ZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggMTI5NDQ2Nzc1Nzk2Li5lMzY3MmU1NWVmYWUg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVy
cy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtMTQ1OCw3ICsxNDU4LDcgQEAgc3RhdGljIGludCB1
ZnNoY2RfZGV2ZnJlcV90YXJnZXQoc3RydWN0IGRldmljZQ0KPiAqZGV2LA0KPiAgCQlrdGltZV90
b191cyhrdGltZV9zdWIoa3RpbWVfZ2V0KCksIHN0YXJ0KSksIHJldCk7DQo+ICANCj4gIG91dDoN
Cj4gLQlpZiAoc2NoZWRfY2xrX3NjYWxpbmdfc3VzcGVuZF93b3JrKQ0KPiArCWlmIChzY2hlZF9j
bGtfc2NhbGluZ19zdXNwZW5kX3dvcmsgJiYgIXNjYWxlX3VwKQ0KPiAgCQlxdWV1ZV93b3JrKGhi
YS0+Y2xrX3NjYWxpbmcud29ya3EsDQo+ICAJCQkgICAmaGJhLT5jbGtfc2NhbGluZy5zdXNwZW5k
X3dvcmspOw0KPiAgDQo=
