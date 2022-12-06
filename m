Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82A2C4708C
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 03:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiLFDH5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 22:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiLFDHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 22:07:55 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2B36458
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 19:07:50 -0800 (PST)
X-UUID: 84732ad6864c4b5ebd04622b41fdf8da-20221206
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=CYiUa1RiXVlW4fKVt/ALM0XSvjTnDoapIbhEGnWbVjM=;
        b=a25l/zBsFLZXMZruZV6g88RIxC6+tL93AcP8IlNF+NPfdW+J9tItILIJQ1QIHr6RH9TguRiEbzodslaDPpsSFG+lz3zscadV+aYZ6AxT1JzVQ0w/qt+VQsHdt0HHFCWJUd8CgQ+4BRTimqK0Kmb28bO3HwmGp8JjqvRfNxx5q18=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:024efd35-b3d5-45b8-b2bc-5e017acbe9d9,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:024efd35-b3d5-45b8-b2bc-5e017acbe9d9,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:83d16824-4387-4253-a41d-4f6f2296b154,B
        ulkID:221206024207O36LNWON,BulkQuantity:5,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 84732ad6864c4b5ebd04622b41fdf8da-20221206
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 788488355; Tue, 06 Dec 2022 11:07:46 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 6 Dec 2022 11:07:45 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 6 Dec 2022 11:07:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4otpPUfaXsJSX2q5EpB38yNx3F0zbarpND9Mm+7cX/nANpD0iGmPWZ+6mAU4yxpIGqJbPrj1fegepOrTl2p+0oDcitNCvx3KrVFHYN8FkWi+IBosRWLQQvhbncaWvZ2Db5NWO3UN6wbd6JYwnGJgvN9KS7BV9Ae1HWPjOr1JqzIt5yncswhTsV4P3CGBLAGNuT/qS0c5fkorQwC6KR0Mz/Nfs3VaCHrZGOXRYvxF7r6VSTar2a6d4HBy7+nlqNYCpgrlWwLkzrSTy9de4YlwusmAsJdmUlD0bQ1q7whvilpBjA5tqD3eONHHZWjTgsPlPBfhLzS9TXXiTtxpJB2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYiUa1RiXVlW4fKVt/ALM0XSvjTnDoapIbhEGnWbVjM=;
 b=dpRKWzImZyaIEZII7p5EyX1rTN0PLN3zQYkLDOu2LG/YKAwVREW8Z8qDzOKT0EHutmGAxqtsxFyO3e3+22FnFmn7L+4bxDkUpfzOBZ7v4lgUT1xhbJMVYg2RMtClx1meuBI6n3Thl93BxmaSPVWkZdo6bov30093jbZfvgq8qlrPfUYokW+LDez3oXPareXPBubHZ5xViB6CLZx3q5ZvKjjODWwaJLPlj9YPJUR4FbQOkbnoPTe6SuqRFgvIiBNUz1b/mnMN7imKHBTq2GdBHqL5KQXlPtOIBXyjuUJhBJurav0w/3keJ7InQg7D3x/XWpjTIrguoRBa65GOi0pcvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYiUa1RiXVlW4fKVt/ALM0XSvjTnDoapIbhEGnWbVjM=;
 b=ZW7lvK2/yqn7IH4DP5no6DvuZCtUYiGW+8tKnxgVslgzPcspr4tJKLw71918QwHwI8HrYFCluoSn3XGqSGZkwE6B0Re/3gZXg9xsbGfkmMSazaCZVKL0/FIsYJ90nz3OsQCdrA015Cu5jwLqimh/MpbfpGuEdypxYck6b6kxB6A=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB5914.apcprd03.prod.outlook.com (2603:1096:4:146::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 03:07:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%9]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 03:07:40 +0000
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
Subject: Re: [PATCH v3] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v3] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZBiCsowsanohTUUCNskW5wgDU4q5fpkKAgACNSIA=
Date:   Tue, 6 Dec 2022 03:07:40 +0000
Message-ID: <f27ddbdef80a8007c8c0cf170a7a442a40c91b37.camel@mediatek.com>
References: <20221202073532.7884-1-peter.wang@mediatek.com>
         <6785696a-cb52-5934-dbd6-28472b4cd7c6@acm.org>
In-Reply-To: <6785696a-cb52-5934-dbd6-28472b4cd7c6@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB5914:EE_
x-ms-office365-filtering-correlation-id: 699368cf-327c-4c06-1e68-08dad737090e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r8+wa1XhJa4/iuXB993WNJk5NxkwNjoH7zleQUIA0WBkBLhh2HHf04tZZ4/7YWEBjAECrTT3RpO1FzrvVEtqH1WsL3hRpBMySxMkcRhv7cqh13X9naAG1uTgI1Kbe7izapJvhJBh8rZ16tYCxmddedI1QnREzV0KgAcVOtR9Yu2rmH+2jY8yJba1GJtpZi6hK/dAU5vaM41ABZzYbZ3ouiUHA8j+okuAHLVhOG2F+kJ+QCYJQuhQlp4JW0OEdFoDNMa2OU9+2qxL1hmDKBbUdc6OvJhYu9V+vGNupO7mNihYGoUBuU43f2UEy9G3nAdVON+PfyW6T+c0A7MsebcLByv7tuZ5lnYcJWAtk+xm+ggGuYGuZlskH0kuQAGwHs9n58qq+RnsqVv2+otKNowjBQWEAeFuX8l+gpQMzIC7lLmiyflLwIPDFHveWas/DXO3Io0K3vqPngXTq6ReXVc5rgQC/UtLMOyue0Ldd4Yk3OMHVdA/2hTWRg/A4drCUPIJbNqRIjF6s2pUNy2wOXT0wPUNDj8/o4oAa1bvrcBClVa/ACVlL+Oh+KM0eJyB9B2jpHn4yBxm94esUEKF7YtyyQ7L022VEQV1cgBIMFU3YQIudh/NerF+QWCely5L2/rj7gkr1hYAjbZVK9iWqt8fg8mBcQWx/ddXeS70VjHvvaNT366O68RIxapLhSEVLGG2hNvwdGV3BaTXosmHCFp/LS/yalZvWWyeUZDCetVrjPA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(15650500001)(6512007)(83380400001)(26005)(41300700001)(2616005)(8676002)(66556008)(76116006)(66476007)(66946007)(2906002)(53546011)(38070700005)(4326008)(64756008)(66446008)(6506007)(5660300002)(107886003)(110136005)(54906003)(85182001)(478600001)(36756003)(91956017)(38100700002)(86362001)(316002)(186003)(71200400001)(8936002)(122000001)(6486002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejl0Vmh0enRTVFFVd0VSb2d4Y3Y3K2NWUHlFMElVSDRxdGtLQXVkSXpxckxP?=
 =?utf-8?B?NFovTUg1bm85Rm1QZ1VqclZmZVNURGJ2UVNwYm5oTUdCOGxTSmdxZXRWRWpy?=
 =?utf-8?B?RTYzN1FSZW9kNkpJYm9SeUNxTG1UZEJNckhrNHVTdUtlVGlaOFJIMWI4L2NX?=
 =?utf-8?B?OFYwZ3ptVjZvMWMwQ1BCRkZHUlU2S2MzM2FNNzRMOGJEdXFhWXc1QVBVNzBG?=
 =?utf-8?B?czhia1NrS0RFcjhQTFAxaWhVSVdjR0RlWlg3Rk1iTTBoQVJZWXRCckVLQ2pk?=
 =?utf-8?B?bVJldmVxZkRwWXVyZXM3YmNIRXI4TFNuRCtacUVZV3FqUWQ2TEpWd2dxbGg3?=
 =?utf-8?B?WkVkTTdhTG9hQ2swRE9FZ3drejBJSi93azFPcU9oeXRZcUtCOWJTMm9obllJ?=
 =?utf-8?B?dUNhVjBzZnVVeTQyTVZoQTJnTzhCZnFkWG9Mc3MvSHlkeUUrbENrTlh4WUlB?=
 =?utf-8?B?WHF2N0tUYm5INU5XWmhubitPdnlKSXpzOFZqOXJPaTVjT3ZFeGlIS2JMVWNk?=
 =?utf-8?B?SXpKcitLRVIzVUJ3S2JFRTJFdzlFcFVNdWNrOUc3blNKcGhYaFZGR2hZUkl0?=
 =?utf-8?B?dDZxNU9TczA2K2tuNWNvVlpUbEFjNHZOaDc3Qnk2TDQvZHIrZGNXSFpKV0pG?=
 =?utf-8?B?a1BYYnluT2NHUFgxSTQwallBRWFyMVZnNDlmdzMwSXY2YTh5REpKUkV1cCtV?=
 =?utf-8?B?T2VmSFVlNjZHNzBKMVp4ZGZlS1NXbWFyZEY1NzRld2c5OTBYRC9jUFU1bjhP?=
 =?utf-8?B?UFpFTlN2SnNaWTFSZklzUFdxR0k1c2x3ekhsU2JRUG9Ucld6MVUwTVVqcGxJ?=
 =?utf-8?B?T29GS2xzMTdoTnh3eWl1LzFoK1hkZW5pV3dFZ1NCNTFXMEtQMTh5SUJlK20w?=
 =?utf-8?B?NzV3elJ0d1BCQ2Y5TjFSckhKYUlmdHloc3ZNb0pXdnB2blIwY3V3SHMxZ3U2?=
 =?utf-8?B?Q2prSTR5S1RmM1BMei9JRWxhWTJoYndGRDZNRHh4czVhRXQ2SllWMGI1MUtp?=
 =?utf-8?B?SDVDbTRGaVpSdHU3NXdjUVAxdlJ2S2podXhiUCtiU2hINXRhU08yaTBLL29x?=
 =?utf-8?B?dDBXaklaSk1hT0RUc0lyQkJTYUMzSEh6b1JSNWJxYmJlNHVYcThjQkFhanBl?=
 =?utf-8?B?eS84YkNFWnloaTRKeWxlcXRKVXlkVDFZRG9PWUpIaUd4UWR5Z0E1OU5IUHNa?=
 =?utf-8?B?VGJQd3VqYW14cUJVZHZDaWxLTkMycWF5UW5TME51THUxUU9jNWplem5iMStK?=
 =?utf-8?B?ckhnRjJibFlIc3laTnQ3d0gwZnlmODdKZG5MSTd4TVdvRUVhM1lWb2tSRTFQ?=
 =?utf-8?B?UmtscjZaNGFqditabTRsb01xbVU1UHVkZCtOcDFoeGpnSStuOTNtVmhpMVdz?=
 =?utf-8?B?aHNmcUhRNGhZaFpVSktQVXhjTkdvREUrckpldkQ5WXB0bXA3akZsT2lFZHFp?=
 =?utf-8?B?eFl2ZGVtdjNxN1ZkS3lzN1M1UlNVRHRNZElsbklxOHBTTVYvVEY0SGYxY2Fa?=
 =?utf-8?B?a3pFbFlFeHVwNFo0bGplSEp1UUh2ZVBaWVhmNXNUOWFXMmpjWHp1QWpta29C?=
 =?utf-8?B?aS9seUl6RTUvS0hCVW9JaGZJTjdHREpPSENmMDMvNkJJcnFZaGFNRlB3ZkJX?=
 =?utf-8?B?TFFWL29kZmRGUEtuV21DTHdGclJVaUx0alNGcStxaGdOUTdMS0hYM1RkODI0?=
 =?utf-8?B?N2wxWXhJUjdRRVFISldCZ01VNWtQRDl2YWdiNmtoUEdFNFlQZ0piZ2M1NGNI?=
 =?utf-8?B?bEs4T0htNEpaRm1oYzZ3elh0UTBQMXp4M0VPOHJZQXRyajhxeW1MZmkrQUlX?=
 =?utf-8?B?THh6UWhHZzBGN3FPNlU0OEVGRkZVdmtlditoQVE5MURMaDFraG9DeS9XV2pN?=
 =?utf-8?B?djBKY2JEajRYS1pNNnNpZGNxOG9uYXZ5RlRyT3lQVmtKbXQ2Q3lCWGt1V29n?=
 =?utf-8?B?SGJjdFRVZm9DdHJQd0dqTXFPYUpIa29nTHJZaTRUVFNkMS8xNGtwU0EvNEpU?=
 =?utf-8?B?c0xNUnFDTFgzM2RQZ08xMWdiNUxXYno0UjlrdmtLY3E2UEk5aER6N0ZGVU1s?=
 =?utf-8?B?UzBsMXVKU3dXdmM0ZS9aZ3J5a3RBZ21hcmtXRzRsaHp6UksyVUZ1QTIrVzY5?=
 =?utf-8?B?Mnd4eStldnI4MElXNTMyaTRGaWNYcURJek9qQ2t0Q25ObzUyZUhuNE0wVG5h?=
 =?utf-8?B?eEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C02D3D80674238469CE89BBB2A37DCDC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699368cf-327c-4c06-1e68-08dad737090e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 03:07:40.0971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uMhNaZnJq1hC590PBE9OvP5d5mSH3P8EX0lUBF2NlDHUdXCH0ZmXn+pORjR4NyGaAMJfB/TNGzRpgU+mLTguiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5914
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIyLTEyLTA1IGF0IDEwOjQxIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEyLzEvMjIgMjM6MzUsIHBldGVyLndhbmdAbWVkaWF0ZWsuY29tIHdyb3RlOg0KPiA+
IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IA0KPiA+IFdo
ZW4gU1NVL2VudGVyIGhpYmVybjggZmFpbCBpbiB3bHVuIHN1c3BlbmQgZmxvdywgdHJpZ2dlciBl
cnJvcg0KPiA+IGhhbmRsZXIgYW5kIHJldHVybiBidXN5IHRvIGJyZWFrIHRoZSBzdXNwZW5kLg0K
PiA+IElmIG5vdCwgd2x1biBydW50aW1lIHBtIHN0YXR1cyBiZWNvbWUgZXJyb3IgYW5kIHRoZSBj
b25zdW1lciB3aWxsDQo+ID4gc3R1Y2sgaW4gcnVudGltZSBzdXNwZW5kIHN0YXR1cy4NCj4gPiAN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAyNiArKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKykN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCBiMWY1OWE1ZmU2MzIuLmEwZGJmMmM0MTBi
MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysrIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC05MDQ5LDYgKzkwNDksMTkgQEAgc3Rh
dGljIGludCBfX3Vmc2hjZF93bF9zdXNwZW5kKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSwgZW51
bSB1ZnNfcG1fb3AgcG1fb3ApDQo+ID4gICANCj4gPiAgIAkJaWYgKCFoYmEtPmRldl9pbmZvLmJf
cnBtX2Rldl9mbHVzaF9jYXBhYmxlKSB7DQo+ID4gICAJCQlyZXQgPSB1ZnNoY2Rfc2V0X2Rldl9w
d3JfbW9kZShoYmEsDQo+ID4gcmVxX2Rldl9wd3JfbW9kZSk7DQo+ID4gKwkJCWlmIChyZXQgJiYg
KHBtX29wICE9IFVGU19TSFVURE9XTl9QTSkpIHsNCj4gPiArCQkJCS8qDQo+ID4gKwkJCQkgKiBJ
ZiByZXR1cm4gZXJyIGluIHN1c3BlbmQgZmxvdywgSU8NCj4gPiB3aWxsIGhhbmcuDQo+ID4gKwkJ
CQkgKiBUcmlnZ2VyIGVycm9yIGhhbmRsZXIgYW5kIGJyZWFrDQo+ID4gc3VzcGVuZCBmb3INCj4g
PiArCQkJCSAqIGVycm9yIHJlY292ZXJ5Lg0KPiA+ICsJCQkJICovDQo+ID4gKwkJCQlzcGluX2xv
Y2tfaXJxKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gPiArCQkJCWhiYS0+Zm9yY2VfcmVzZXQg
PSB0cnVlOw0KPiA+ICsJCQkJdWZzaGNkX3NjaGVkdWxlX2VoX3dvcmsoaGJhKTsNCj4gPiArCQkJ
CXNwaW5fdW5sb2NrX2lycShoYmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+ID4gKw0KPiA+ICsJCQkJ
cmV0ID0gLUVCVVNZOw0KPiA+ICsJCQl9DQo+ID4gICAJCQlpZiAocmV0KQ0KPiA+ICAgCQkJCWdv
dG8gZW5hYmxlX3NjYWxpbmc7DQo+ID4gICAJCX0NCj4gPiBAQCAtOTA2MCw2ICs5MDczLDE5IEBA
IHN0YXRpYyBpbnQgX191ZnNoY2Rfd2xfc3VzcGVuZChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEs
IGVudW0gdWZzX3BtX29wIHBtX29wKQ0KPiA+ICAgCSAqLw0KPiA+ICAgCWNoZWNrX2Zvcl9ia29w
cyA9ICF1ZnNoY2RfaXNfdWZzX2Rldl9kZWVwc2xlZXAoaGJhKTsNCj4gPiAgIAlyZXQgPSB1ZnNo
Y2RfbGlua19zdGF0ZV90cmFuc2l0aW9uKGhiYSwgcmVxX2xpbmtfc3RhdGUsDQo+ID4gY2hlY2tf
Zm9yX2Jrb3BzKTsNCj4gPiArCWlmICgocmV0KSAmJiAocG1fb3AgIT0gVUZTX1NIVVRET1dOX1BN
KSkgew0KPiA+ICsJCS8qDQo+ID4gKwkJICogSWYgcmV0dXJuIGVyciBpbiBzdXNwZW5kIGZsb3cs
IElPIHdpbGwgaGFuZy4NCj4gPiArCQkgKiBUcmlnZ2VyIGVycm9yIGhhbmRsZXIgYW5kIGJyZWFr
IHN1c3BlbmQgZm9yDQo+ID4gKwkJICogZXJyb3IgcmVjb3ZlcnkuDQo+ID4gKwkJICovDQo+ID4g
KwkJc3Bpbl9sb2NrX2lycShoYmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+ID4gKwkJaGJhLT5mb3Jj
ZV9yZXNldCA9IHRydWU7DQo+ID4gKwkJdWZzaGNkX3NjaGVkdWxlX2VoX3dvcmsoaGJhKTsNCj4g
PiArCQlzcGluX3VubG9ja19pcnEoaGJhLT5ob3N0LT5ob3N0X2xvY2spOw0KPiA+ICsNCj4gPiAr
CQlyZXQgPSAtRUJVU1k7DQo+ID4gKwl9DQo+ID4gICAJaWYgKHJldCkNCj4gPiAgIAkJZ290byBz
ZXRfZGV2X2FjdGl2ZTsNCj4gPiAgIA0KPiANCj4gUGxlYXNlIGZvbGxvdyB0aGUgY29kaW5nIHN0
eWxlIHRoYXQgaXMgdXNlZCBlbHNld2hlcmUgaW4gdGhlIGtlcm5lbA0KPiBhbmQNCj4gcmVtb3Zl
IHRoZSBzdXBlcmZsdW91cyBwYXJlbnRoZXNlcyBmcm9tIHRoaXMgcGF0Y2guICJpZiAocmV0ICYm
DQo+IChwbV9vcCAhPQ0KPiBVRlNfU0hVVERPV05fUE0pKSB7IiBjYW4gYmUgY2hhbmdlZCBpbnRv
ICJpZiAocmV0ICYmIHBtX29wICE9DQo+IFVGU19TSFVURE9XTl9QTSkgeyIgYW5kICJpZiAoKHJl
dCkgJiYgKHBtX29wICE9IFVGU19TSFVURE9XTl9QTSkpIHsiDQo+IGNhbiBiZQ0KPiBjaGFuZ2Vk
IGludG8gImlmICgocmV0KSAmJiAocG1fb3AgIT0gVUZTX1NIVVRET1dOX1BNKSkgeyIuDQo+IA0K
PiBPdGhlcndpc2UgdGhpcyBwYXRjaCBsb29rcyBnb29kIHRvIG1lLg0KPiANCj4gVGhhbmtzLA0K
DQpIaSBCYXJ0LA0KDQpHb3QgaXQsIHdpbGwgcmVtb3ZlIHBhcmVudGhlc2VzIG5leHQgdmVyc2lv
bi4NClRoYW5rcyBmb3IgcmV2aWV3Lg0KDQpCUg0KUGV0ZXINCg0KDQo+IA0KPiBCYXJ0Lg0K
