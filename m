Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5C1E810D5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 01:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjI1B7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 21:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1B7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 21:59:03 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971B9AC
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 18:59:01 -0700 (PDT)
X-UUID: 95afc03c5da211ee8051498923ad61e6-20230928
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Vv+dT2lx+zx06ur9BQFCbkwra+eY3mB7UvGrjmF2I0A=;
        b=b2wZrtRq8x0w0/D2Z57QCg0ZHVWDFDmQStWE3iqosCjyHEyT+7wiVcNnZgBuddXd7NVAwqXdYA0jQtmWEBCEM7tDqCrf4NO6pCHNztfWQzRoIlPIWVVTuyMfdu61Q2fm95ajvG9BVjU3n/f3CFXKZFUW5QkPBSl6Ec5PVnl2weM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:91ff28ef-79ac-466b-84d1-ab88a2531c63,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:a2877514-4929-4845-9571-38c601e9c3c9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 95afc03c5da211ee8051498923ad61e6-20230928
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1107093172; Thu, 28 Sep 2023 09:58:57 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 28 Sep 2023 09:58:56 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 28 Sep 2023 09:58:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYNJngrcUtthG809KKceVRov8qSz2mul4R/t2T+qkYFEvxK3eHfJqHkkt/hRVK6ouTzX6b5q/S9DHOsjE0SmJKzSaE86dgjh718D1djw1EoMFRZ/x32Q/ciph7NPpXnw4pvclpxYOT5OSuNOnOTDn/vZ99JaPyy0DAe1TVbz496sQDE9qcJTB89h9g9J6Muv920UaIqcSt6UTBxrwOSCdO5UyycMwr6zQcOL018ojH09JuY5s4MsGbDvTegMzlPVKesbTGA6VDX21oHHhSSLxRDNTEgVzYnQSKHrab/V045iO5K7rxMnW8fvLSkVk9ipzX7PYXeAysBnjomGVMJ5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vv+dT2lx+zx06ur9BQFCbkwra+eY3mB7UvGrjmF2I0A=;
 b=EHE61eJ8Cqr8N8AnioWZ9/mVuXbRafv4BInE29GqkJwU5dnNogdPLhshhd+Mfy0WEdh/rDJTxxgSIcU2mP5m/pUyXKwQtlOkGb+zMSQiC4hs9T3k9v3c5cfA+v9MMyhzDIVhfXnVRvboSRwsD9Zj39oOQN4D+k6nVBQgGB1iojPpVwJOf2PavtQ7VwPz6K+QbE+Re3TeFe9GRyXMmYkawT29UbnUO64Z6nwq8FAvvdwmDYkLYf5dHaEjVWrUo6rQ+tnHRM7q8bMbZP50EB8B9fJn1JVKlOsH5U7udbzIh/aFr7s2zl1+fRN8/LwxULkAHeg2MGhneydj2bK28qR7oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vv+dT2lx+zx06ur9BQFCbkwra+eY3mB7UvGrjmF2I0A=;
 b=NdaLCmA/WxiS7h5K/m6u7avg3hQxayr0Hpzd+pFeTxijFpwg9vVdxfly3lG6BQiX2Q3nw8ysGlI6zpLVE8CkZs1h8ySxXYQCd5x9eflNdxh0Ej1lFcaQNWbNaNNVYzMuUYdR5BgXgF8t9PRz82ZE8SvLoW8go11c8itlZ7uuQJI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB6967.apcprd03.prod.outlook.com (2603:1096:301:f8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Thu, 28 Sep
 2023 01:58:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739%4]) with mapi id 15.20.6838.024; Thu, 28 Sep 2023
 01:58:54 +0000
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
Subject: Re: [PATCH v5] ufs: core: wlun send SSU timeout recovery
Thread-Topic: [PATCH v5] ufs: core: wlun send SSU timeout recovery
Thread-Index: AQHZ8PO+bjVk3l0RgEGfvYmq0IU/lrAu/+OAgAB83gA=
Date:   Thu, 28 Sep 2023 01:58:53 +0000
Message-ID: <a7804d933e2ae9f7c0709d99dbba1d51e3c8f3a7.camel@mediatek.com>
References: <20230927033557.13801-1-peter.wang@mediatek.com>
         <2c428d68-5fee-4db7-8349-eee245c62ff8@acm.org>
In-Reply-To: <2c428d68-5fee-4db7-8349-eee245c62ff8@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB6967:EE_
x-ms-office365-filtering-correlation-id: 7e3ee9bf-9127-4be9-08a7-08dbbfc677de
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KX7vpyeWlNSALpaBktnSHiZK6qKO6f4NO0egZbavLLN5tMu7N3vqL/RVE2hi9jbKdoMigfQKowu+Qx4gGu9GwG7tdlunTPbxrJPs/CT1GA4kB5lEv3hchw9dvWNLo5lG/JqeJ2MjmDTtYaRAWsttgVKyKEi/C1xBwM2Qm3suvlEDjIxF1LFHJGVM8p4RJrIh+VPO0UkcRp3TcIMZuPE4Lty/3sckfWzb+yQv4tL37Hwb19rcSW+/EMijfEXJEvxG3kUxH+XJM59OgYeweiQ6Gz5XSKll9Yk9DAnFPnERBi2y8vXz89K+glXfWUX9NR8svV4b+iImjXGGaIN688Ks6Xnc0jQBwi9/zy1cL/2FaQnyx3+uPeHG3EylxwmJKvjPKb+weVJ7l/7HvjQhO6oZogQGfY9iqBJvVZhaTjVwUFiFK3o89Gq4u9moP3A0mGl931+NRExJTAckrxQu7kJjf8JkXNp9soyOZUemy3pGS6qNnFUQfOPJVeV6MzBEdSOSw+fckqd3cXGzvK9+U7Oa1U3ukHrF32RFAg2szpJDzu07wYS3m6yyqfh+5dXRLd6TldNDslo/OQZc0Wmwz3aSa0m0EQ6HYkYiY4xe3zk/0aJR8pfCCIu4XuGz2AG8ZB6CuQUU1VWz9nFCxT+AhLHilgJTyQ6rybmircd768g4rZXeC14+pOOpY83nh4+AC4gs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(346002)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(41300700001)(71200400001)(4744005)(316002)(54906003)(83380400001)(8676002)(91956017)(85182001)(36756003)(8936002)(66946007)(2616005)(4326008)(5660300002)(66446008)(86362001)(64756008)(53546011)(110136005)(6512007)(6486002)(6506007)(66556008)(66476007)(107886003)(26005)(122000001)(76116006)(38100700002)(2906002)(478600001)(38070700005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkhqKzY4VVh3KzRJb2tWd1drakx6cjYxUjFnQllEUVlHY0FYQXgzZWVHWE9N?=
 =?utf-8?B?dkdtdkt1cTFUR3piVWp0b3dybVJDYnRHOUhQeUNwNDZCU3QxTnlHbHNiUTI3?=
 =?utf-8?B?d3Mwa1NKcGdYam9pVm1kQXR2TmlGUHA1TDBNZGhUUjFxQkEzV1FNemRlL3lB?=
 =?utf-8?B?dTJYVVhjRFI3SWx4UU5kVEFPbUsyY0hKR3hTN1BxaDFVVHRPcW9Wdzd4TWx6?=
 =?utf-8?B?bmRBZmJRK01lZEVDNlg5QVlnNGkrejR5UzcvSVVQTmVUMEladjJ0UHFRam1E?=
 =?utf-8?B?MjJDR3NHSjlBc3F0WGhTZ29RRzcra0xNSjVXRGdhR01kd1Q1UXhNS2l1dHZO?=
 =?utf-8?B?U1grN014UVA2SHgxZnBEMW9UZWVVOWFEcEtLL2p6VkZmbWdaRjZsUkRuL2hp?=
 =?utf-8?B?WTdZcGphc2ErOWFIR1dTejBudWE4UEZaNHpxOEc3d2c5Q0dlM3BxK2NUejA3?=
 =?utf-8?B?YTdjTnMzMkJwSlFrd3RDRk05cUxkZHo1Q1FGb3doM1BPMjFuZEdFUGtJemRa?=
 =?utf-8?B?Z3dwTU9UVkdwMDh3NWI1d25ncDRBWkNCOFVsQTJUYzU1eXo4OVVkNTdKZnp6?=
 =?utf-8?B?OURPUVhib1JQSGgydExPa29EamZuV2tkVjFZNFpPTXJEd1dXUkxUc2l2eTFT?=
 =?utf-8?B?bE55NTFCc0owRERtaVJhZHhQcXAwZjF1Rlk3UXpnaEE3OHBlNGhPYlgvNkw4?=
 =?utf-8?B?ZU5pUDJRc203RkllcUx6UE01TW1NOFN6cURCUmtrRjlyVElqUklrUXpSWmJG?=
 =?utf-8?B?VFlWbElEb1JmdHp4dzZBSldPVE85T29nWFE0dmE0Qi9UNG5DSHlROXR6dDRV?=
 =?utf-8?B?alpMSGlGOXpxb20wZnpTQ2c2Rndkdk9sN3g2d01kT3dwZWZ1TDNGc205NHJJ?=
 =?utf-8?B?RVBoMHFBSnlYYWd2dDFweU0vYVlIbVhaaTV0Y3JRUjhsVDRacFZRQ085Y2d0?=
 =?utf-8?B?TldmdjhvYUFFdXRIQ0FUOVQ0TGxBWWJNN0ZKbHJiNElnbE9kSmV6MjF5MCt0?=
 =?utf-8?B?U0tZa0kxQTZwakQ0OW9WR1hPT3dwUWVoWGg4cGNQY1d4YnBiRmNsUmlodFBm?=
 =?utf-8?B?aW9paDU0V0JkczdER1RGeW1wYlJGNUJQaExwQ21IYm43NG8yRkhoWTJ2WEtj?=
 =?utf-8?B?bWtrZFQwcmVhU3Bqa2ZlTDRTbDBWMjVxaEV6UDlqVzBrNy96ZGVqOS9NMXkz?=
 =?utf-8?B?ZUNtc1lCbmZNcU44b3BiYTZIZzhyOWh0TEJIRnZERkNiU294bUdZcGRxUGdY?=
 =?utf-8?B?SFc4WjR4YXlRT3FMRzI5WTk4MVUySEEzY29wNWdtVldDSHdpOWxEVnpZdlBH?=
 =?utf-8?B?V1l6Z0JCVVNaSVNMbW12ay9JL2ozWkJxUU1DQlF4OU1ncWpqUk1qVkVRMTZa?=
 =?utf-8?B?YTJhVnhJM09kdHhnV3dwNVdHOUgvVTR6OHc1a285Rk8rM0FMOFl2WVYxdDZn?=
 =?utf-8?B?UDZYNmtBaVlMTEhLTGZ2VVlCbFphM3hLZlNNb3VJa0pGRzJvdFU3NVIwTDVJ?=
 =?utf-8?B?L0hvRHZvdE5ybDdYTkNHVVcreUFoMEZhNlp6TnlVZmRJMTBSVno0L2dJUzhm?=
 =?utf-8?B?Q1hRLzBmY1ExK0VMRTlZUE40TE0xYXo0aVV3VXBkUW12azRVQVZFZmdjMTBq?=
 =?utf-8?B?Y2NmU0FTTy96MTZWa1ZnTUdnbHZ0SXRmbzhSbzRYZU9Jci83aXcxMWdsUlQ5?=
 =?utf-8?B?dUFqTlh4U28rbjQ4b3VVMWNid1c5bW13SEhyQm11TlpRUmFLS0FmVkVadTFK?=
 =?utf-8?B?bGRRYlRMcm43OHBMWU0rVTVaRy9RNklLNVNJRzNvSEFVUXVnVVp0MXg3bkpk?=
 =?utf-8?B?ZU1KN0UyeGRrbm8zQW1xN3JZTGlTNy9aTDc5TDkvM1FEVmlRZkFJUmRPTnhZ?=
 =?utf-8?B?UnBWREpWcnRMd2phWDNQeDkvSGhYelBISlhBL3hPZ0J5a1pqMUtLL2JrYWRl?=
 =?utf-8?B?NWZsT0hFSnRDWHdRd2hBY3FPMS82M1ErditVbGdHV3VnYjlkMlZ1QWYxaUVn?=
 =?utf-8?B?KzYzUnJudzNlTzg5RWQ3VE9ndTNlTURhM2Q4NFZ4LzdSb00zM2t5Rk9vYkhv?=
 =?utf-8?B?WEpHYnViR1c4TGljeDVpemUzMjUwc1VHRHBhZTV1OFJWak4vQWtyQitSMEhj?=
 =?utf-8?B?c1lCYmxiY3dRS2ZaM2pxUHNCNFdrZzQzNFNrNS9SaEZxK3RLN00zS3ByUWVw?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F932B3AF801244EA85BCD688228BACB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3ee9bf-9127-4be9-08a7-08dbbfc677de
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 01:58:53.8426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rCzUMJ8CufMTdKqeit4SQDXsUUr/xF/3pFVwGChYpgYLp4tklcKiB0F5G9ib9y4yJfnBclmIxUn8yF2cdNvGCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6967
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIzLTA5LTI3IGF0IDExOjMxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yNi8yMyAyMDozNSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20gd3JvdGU6DQo+ID4gK2lmIChoYmEtPnBtX29wX2luX3Byb2dyZXNzKSB7DQo+ID4gK2lmICh1
ZnNoY2RfbGlua19yZWNvdmVyeShoYmEpKQ0KPiA+ICtlcnIgPSBGQUlMRUQ7DQo+ID4gKw0KPiA+
ICtyZXR1cm4gZXJyOw0KPiA+ICt9DQo+IA0KPiBUaGlzIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUg
YnV0IEkgd2lzaCB0aGUgYWJvdmUgY29kZSB3b3VsZCBoYXZlIGJlZW4NCj4gd3JpdHRlbiB1c2lu
ZyB0aGUgc3R5bGUgdGhhdCBpcyBwcmVmZXJyZWQgaW4gdGhlIExpbnV4IGtlcm5lbDoNCj4gDQo+
IGlmIChoYmEtPnBtX29wX2luX3Byb2dyZXNzICYmIHVmc2hjZF9saW5rX3JlY292ZXJ5KGhiYSkg
PCAwKQ0KPiByZXR1cm4gRkFJTEVEOw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoN
CkhpIEJhcnQsDQoNCkl0IGxvb2tzIG1vcmUgY29uY2lzZSBidXQgY2Fubm90IGhlbHAgaW4gdGhp
cyBkZWFkbG9jayBjYXNlLg0KQmVjYXVzZSBpZiBwbV9vcF9pbl9wcm9ncmVzcyBpcyB0cnVlLCBh
bmQgdWZzaGNkX2xpbmtfcmVjb3ZlcnkgcmV0dXJuDQowLCB3ZSBzaG91bGQgcmV0dXJuIFNVQ0NF
U1MgZGlyZWN0bHksIGVsc2UgZ28gZm9yd2FyZCBpbiB0aGlzIGZ1bmN0aW9uDQplaF93b3JrIHdp
bGwgYmUgdHJpZ2dlcmVkIGFuZCBkZWFkbG9jayBoYXBwZW4uDQoNClRoYW5rcy4NClBldGVyDQoN
Cg==
