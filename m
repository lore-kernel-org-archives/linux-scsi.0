Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD0DC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 09:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiLAJcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiLAJcH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 04:32:07 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3354F18C
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 01:32:04 -0800 (PST)
X-UUID: c4cf3aa385dc49f0bbad1cadfa267365-20221201
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hmb76XSSq/6jRNUE8/H/Laz41T3QUY828eUo8Zbw3d0=;
        b=ZkxK3XPsnbeOP5ynkeZc2yqw46fwN8o2XkL7E74Z3Zc3b9de1Z9JeWGODWmHSMFXh+9DG5kSaQZ9TYvTCFiWUorXuhfK7gf2+4pmsK+1+mG7UObHQfhoTue8uXb/BFa0mjMzZIuUWm6pVlwqmSqirZRgKIQJqojnqe0Op9lNwvI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:61d7a413-aa25-406f-9d02-62ba4f9b7e16,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:352f6030-2938-482e-aafd-98d66723b8a9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: c4cf3aa385dc49f0bbad1cadfa267365-20221201
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1070722030; Thu, 01 Dec 2022 17:32:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 1 Dec 2022 17:32:00 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 1 Dec 2022 17:32:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNyCyvUWT+wneQgKHUBLd7ebr6Xvnko/jWIgJD02wb++XmVtJUZ3TH4VJfAuy+FK7DX1K/YhgsDkhle4RZe2u+ajEoTUiM/kJt5xYn4cszaco5YsTnWNGI+vQQHHcd5YZFxo6qGJxZqlSkM/m3/udTh0CLLmrp4n4jvvh/4c5efP+SSJ+IuOuAtzP4cJ3tIaZz2/3BEJV0wE6OkFT02UPf0uRdzVD1Nfk2rqzoOCThvol404N8JTp+mGEIjqMMz2HjKo2AFwHPx0idJzoCvpFtdtVxTg1yYv1Yn9fx4EoBH6W3HOpvePPG7IYx16ZqOclVGlaXpyFa8HmBgbLZnT6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmb76XSSq/6jRNUE8/H/Laz41T3QUY828eUo8Zbw3d0=;
 b=ZX2SJBolEDjBCn68mTaN23x8CK2yl2fNatO/JPh/ILZ8hV55qQHRZ3gcLrTuRrFe7ZMDj8e8SmMqBPvuhmA1zQj/6wWyXbLb0s9MknnNOfCIGjSkBBoShkrgzeO6+fBD7YkVRd0GhKaXzMUSKJjAWp32obw8zErjqxm+popAJU58kT4WOrq5OyzMCdXOIJliochD8JpLOXWwKTClzaLX9tnB6efdKVpQ2EOPj0Drc9LAnoJLe2+IsjPZ5+08PqcDDN8FYCkC7H8hKGy+NGWOzNruUhKAWOSyQB9+pP/cF61OsKIfjXjmRR3lUr4sKh7M9si730VI8h+52xBTE35W+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmb76XSSq/6jRNUE8/H/Laz41T3QUY828eUo8Zbw3d0=;
 b=X3UAY4ukZDPilCTqTFDR2sYIsAYcWGTYXMP2b8hflU9oAO/vuypQbqy/ZbWmEcFhuvnhr/ktqe64CWeTegdh1N+sM7hRqGA0igBuoX5bjeSUw1wqdGrOJ1F4QZokUCf1kmOasSqMFh0iLwOHofCKSPrpGgt1hri25dWamGbitAk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6610.apcprd03.prod.outlook.com (2603:1096:4:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 09:31:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2aa2:27f2:1d96:c1cb%3]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 09:31:58 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
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
Thread-Index: AQHY7f2ebQ5oIqIDLEuxQKxEnr9j6a5Xbc0AgAB+UwCAAQdmAA==
Date:   Thu, 1 Dec 2022 09:31:58 +0000
Message-ID: <cc82a2ce702cd14c8373ce57308208bbb8756696.camel@mediatek.com>
References: <20221101142410.31463-1-peter.wang@mediatek.com>
         <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
         <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
In-Reply-To: <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6610:EE_
x-ms-office365-filtering-correlation-id: 6c43d659-f58d-41a0-39f7-08dad37ee4b6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ONDQHkgb71i5hQK8eT8Htr2UpRChuTp9gRZzyGCPI3A3lkMVNrpL9OPUGrz3dRPuEGg74JHHJylbGUa39wogxI2CBPbUeJsHCzdFrZ9BHpSeDfeo1sXd6/zCw0lq7t0XH/sDQcxfugJAP/ZZxDGYGU5fxrgTd+jLVvSD93PuvJjVBhDeCWsuIV79rXgjNIQvC6QoM2UVx6GulnzntpejJRE8tznqBS/u2EhFlgyZN0uWu+9cftqgNdWnEs9BZlzv/3YJ9btHcHGEuxwwM3NxClCCEfsxLzIp1jTs3lKXe0onTcZJxRL16Qdx/13wP4KjNt8iJ5Yh0CPkrQpaBGPNcljMTq7MPzaMzUjhcIT7oS+qIjKxQvCHWpYDz6BlQwRXeLIRQ6yEuMJfy5qCwC7bG5sVJGNDcswxB6P7tDr1ngSuHAIF/MKb7l9BixrZunqmc5X9qpMz81hlSyH8fGNQdg7CAF7kyTTI1R1qNpXEwBNFi2bl4m+meVUvlmW2yPQXT60wUbC2iqbCUx/O39AWdu1I3OIM7Sy+7fQ0kNXXGXvXoItsBmZFK7EkCbp/jUa4vEmkWm01nO2M+2xdM4FvrNfHBYex+Rghcqvn4h1pWcNap62zNZmG6kAZnCpet8Nlh7glHikhpEoeeorQZ6lGWCKUC7FddA7B0AZ7Hg3WF6bxpFTnlhzeSTmCe3gX6IrU21L/oHblS69cQh7cn3C3OovsKgPbZ+iz7eSfTOnIG19pAF1VvhtshOJE64YAok8IXzFpFJACHe7k3gBKZc47iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(38100700002)(36756003)(66446008)(8676002)(4326008)(91956017)(85182001)(38070700005)(66476007)(64756008)(66556008)(66946007)(76116006)(110136005)(26005)(6512007)(2906002)(186003)(122000001)(53546011)(54906003)(86362001)(4001150100001)(83380400001)(41300700001)(8936002)(15650500001)(2616005)(5660300002)(316002)(478600001)(6506007)(6486002)(107886003)(71200400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VThqQXprYVhPU1ExV0czS1k1RnJtVkViVUZMdVB6U2R5Sm9FdlNzbEdOYm5I?=
 =?utf-8?B?RTF1K1pFeVpPekJvWlFTY1g3TDZpVkF0L3d4eVhUdWJGcHBwaVVyV3dKM252?=
 =?utf-8?B?OWp0eVdkVERxSHd5ck13VGo1SmFRRXA1c3BXM002bVBCQTB3NUJYYUV6cDcz?=
 =?utf-8?B?RE44ckplc1lWNDR3c3FrQmJTaGQ1R3BxaXFjSVVZb2dLZ2JxZWVndXNmSlEw?=
 =?utf-8?B?RmJVY0VIZkNwL0pjYU9YeVVFUWx2R2JBS1hkTmxzWDBHdzF1eERTM2tOZGtY?=
 =?utf-8?B?N3M5YlJPOXZvUzZOcjhXVDFhNU9acG1PMHkwMmxXL1lvYXprZDVZOGRsUzZi?=
 =?utf-8?B?WXNsMEdkQ3h5WG5vOS9lazltMEFSQkMrOG9MZXp0aHR3bnpWNUZTekxhZUxQ?=
 =?utf-8?B?K0FlUlJaeVI2ekt5ZGNJaDNCN0xiWlN0SVI0K2YwY0JjMG5BTHpFZWsyOGI1?=
 =?utf-8?B?ck12MXhrZUJCeVZjcEduSTBiVEVGemhZWlFMVFVCS3J6RmJ5Vmt2UVNhdCtX?=
 =?utf-8?B?Q1JXbjJWMnI5dTYvcTJHUi9QZmlHN3NnR0FDcmU4Q1RyZHpiT04vMHI5K2pN?=
 =?utf-8?B?dEcrTkZKaWxmMnU5a1NnMFA1VXNDNFRPd2U0TnJiUTJRRWs3OGM3cWNZUkMr?=
 =?utf-8?B?TGVKUWl4d2NPQXJPQ1hUVDJHZE9tc1RrYnpqaUtONm9EM1JMcGFIUlJVNU5V?=
 =?utf-8?B?alVtNXg3SmVMNTkxRjNJNEhENVBzb215ME9kMzRua1QrTWkwK1YvekpzYnR1?=
 =?utf-8?B?TCtoMEJUcmxNWUlacEx4aUZvOXY1M1JxK2NzdjdDUFFIQURHVFM0VFE3dHdz?=
 =?utf-8?B?QVFvcityRC9ZN2hBemRnQU9WRlVZSU8xWFhENytCb2h0R2FuZUNpWmhOSU5D?=
 =?utf-8?B?dXdzZ2FXV3kvenJFcnBxYUpOSWl3Q1RRWE5LY3grbHEvMTl0VVZkeUwrbEJE?=
 =?utf-8?B?Z2Fwc0puUzVUZHU4UGtPNi9pNFhOMmpDN0ZRTWdpUHA1cnlad0l4SFF1UTFr?=
 =?utf-8?B?L0puTWd5OGxlTk1GR0V2MDhhak9NcDA4U1ppbFRpVHBwUXFkdEdiVlR1U1Np?=
 =?utf-8?B?RTd3ekRuNVpRSVMzNXJFYzVWYzFraDhSU2RjYVVHR3FhaHRLWURNZEZFb3lQ?=
 =?utf-8?B?c1JIcDJ4K0xBTCtoajUxVXhOK25aYnViQzhOeW5XSzJsSjFuejV5a0RFTEsv?=
 =?utf-8?B?bUQvRnFzNGxxTzNrRm8vUGd0NHZQbmJXZEl3WFUyK3UrMTVxZ0srcmJLaW5P?=
 =?utf-8?B?djMrdHFGMTFaREhHdVp6TTJOczBURkxQdFpkQ3dxOGVLMWxqajVrT1dIdEFY?=
 =?utf-8?B?dzNBMlRKazJtT3pFRklscVh4Z0xHSC9Xbjl1a1hsTG1LZi9YOE85eS96MzZF?=
 =?utf-8?B?TTZUOUFYVTRzN0dLQkttT3daTkF1QlJkbVRCQmJYN25XNTlGVmgyTklTNDlh?=
 =?utf-8?B?bWM3RVhtbklXb3JzNWlHVlVIV0VKclluVXBPME5RSG5tanBTN2F0NlhYTG9o?=
 =?utf-8?B?ajlNZktnRzFTSjduamgwUkdmeDczY21TNWhEMFZJTE5tUkV1UmdVVmlWbnd6?=
 =?utf-8?B?Z093M1BhOGdEb3pRZTllMkpick1HU1p0TDVEdjdLRzJJbkRUNzF2bGhnTTJV?=
 =?utf-8?B?QXU5elRGQ1RyZHp2dEdGV081aXVaVjkyOEhyMDZTYjNnK2w3QXc3ZURvdWtr?=
 =?utf-8?B?djNsMWhhOE56aVBBOWQwTVN3eWtwRVdYZjJDNk5DaXBlczhwbE12a3RNQlNG?=
 =?utf-8?B?UWp3TUI5RW5uN1ViODBGUU1ZVzA2ekg4d3dMYmtPc04vVGtzL3dxNWVoaDV4?=
 =?utf-8?B?dVdDVEltdi83elVHUmtySFVCK1Fhc2s2T1Jhamkwa0R5bUw3b2RMaCt3QU84?=
 =?utf-8?B?Z1RVVGtvZlcrZjZDMlRJUXg5a05icFlzTno2YTZmc240c2VFWE1xZ25mbnoy?=
 =?utf-8?B?N0ZtbEkwc1duR3hBMVkxSkVtWUpHQ1crYitKUElqdWFHR3EwRHU1NnRzRVV1?=
 =?utf-8?B?VFljL2tac1IwNTlrejFpK2FOT3lNbHU5NzQ1b09lUEx5T1kvTVJRZnNsdVhT?=
 =?utf-8?B?Rld3K1ZYK3cvMm1XdThEeDRBRWFEYXd5amQveHJrSGQ4ZHRzejlOelQ5YzdN?=
 =?utf-8?B?a1JUS0hzbk1VRU10QnZOaHBGdjY2M0lkNTBLRVZiRnMyZ1AxK3hYZERmZDhU?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B2F2D0484EC82409B4CE902BF71D4B4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c43d659-f58d-41a0-39f7-08dad37ee4b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 09:31:58.2521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JQtOIImPxNIyNngFEVAniui2CSHvRGLlBJgnaqaFDhL2Yj4d2w4RoU1DlyTqoDj/u8inlHwwFZyiOPNJ2FLgJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6610
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTMwIGF0IDA5OjQ5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDExLzMwLzIyIDAyOjE3LCBBZHJpYW4gSHVudGVyIHdyb3RlOg0KPiA+IE9uIDEvMTEv
MjIgMTY6MjQsIHBldGVyLndhbmdAbWVkaWF0ZWsuY29tIHdyb3RlOg0KPiA+ID4gRnJvbTogUGV0
ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+ID4gPiANCj4gPiA+IFdoZW4gU1NV
IGZhaWwgaW4gd2x1biBzdXNwZW5kIGZsb3csIHRyaWdnZXIgZXJyb3IgaGFuZGxkZXIgYW5kDQo+
ID4gDQo+ID4gaGFuZGxkZXIgLT4gaGFuZGxlcg0KPiA+IA0KPiA+IFdoeSAvIGhvdyBkb2VzIFNT
VSBmYWlsPw0KPiANCj4gSSdtIG5vdCBzdXJlIGJ1dCB0aGUgaXNzdWUgdGhhdCBQZXRlciBpcyB0
cnlpbmcgdG8gZml4IHdpdGggdGhpcw0KPiBwYXRjaCANCj4gbWF5IGFscmVhZHkgaGF2ZSBiZWVu
IGZpeGVkIGJ5IG15IHBhdGNoIHNlcmllcyAiRml4IGEgZGVhZGxvY2sgaW4NCj4gdGhlIA0KPiBV
RlMgZHJpdmVyIi4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KDQpIaSBCYXJ0LA0K
DQpZZXMsIGl0IG1heSBhbHNvIGNhbiBmaXggYnkgDQoiW3Y0LDA3LzEwXSBzY3NpOiB1ZnM6IFRy
eSBoYXJkZXIgdG8gY2hhbmdlIHRoZSBwb3dlciBtb2RlIg0KDQpCdXQgSSBhbSBub3Qgc3VyZSBp
ZiBhbnkgb3V0aGVyIGNvcm5lciBjYXNlIFNTVSB3aWxsIGdvdCBhbnRvdGhlciBlcnINCndoaWNo
IHJldHJ5IGNhbm9vdCBmaXg/IChleCwgZGV2aWNlIGFsd2F5cyByZXR1cm4gc2FtZSBlcnJvciBz
ZW5zZSBjb2RlDQp3aGljaCBob3N0IGlzIG5vdCBleHBlY3QgdG8gcmVjZWl2ZSBhZ2FpbiwgYWdh
aW4gYW5kIGFnYWluIGxldCByZXRyeQ0Kc2lsbCBmYWlsKQ0KDQpCeSB0aGUgd2F5LCBpbiB3bCBz
dXNwZW5kIGZsb3csIG5vdCBvbmx5IFNTVSwgYnV0IGFsc28gZW50ZXINCmhpYmVybjgoMHgxNykg
Y291bGQgZ290IGZhaWwuIEkgdGhpbmsgaXQgaXMgYmV0dGVyIGZpeCBpbiBib3RoIGZhaWwNCmNh
c2UuDQpIZXJhIGlzIG91ciAweDE3IHRpbWVvdXQgZmFpbCBsb2cgYW5kIHJ1bnRpbWUgc3VzcGVu
ZCByZXRydW4gdGltZW91dC4NCg0KNDczLWMoMSksIDIxMTQwLjM1NTI3NjAxNywzMTc0MiwxOCwg
cnMsIHJldD0tMTEwLCB0aW1lX3VzPSAyODkyNzU1LA0KcHdyX21vZGU9MiwgbGlua19zdGF0dXM9
Mw0KNDcyLXUoMSksIDIxMTM5LjgyOTQyMzcwOCwzMTc0MiwgNywweDE3LGFyZzE9MHgwLGFyZzI9
MHgwLGFyZzM9MHgwLAkNCjANCjQ3MS1yKDEpLCAyMTEzOS44MjkzNjE4NjEsICAgIDAsDQoxLDB4
MWIsdD00NixkYjoweCAgICAgICAwLGlzOjB4ICAgODAwMDAsY3J5cHQ6MCwwLGxiYT0gICAgICAg
ICAwLGxlbj0gIA0KICAtMSwJMTczODM4NA0KNDcwLXIoMSksIDIxMTM5LjgyNzYyMzcwOCwzMTc0
MiwNCjAsMHgxYix0PTQ2LGRiOjB4ICAgICAgIDAsaXM6MHggICA4MDAwMCxjcnlwdDowLDAsbGJh
PSAgICAgICAgIDAsbGVuPSAgDQogIC0xLAkwDQoNCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
