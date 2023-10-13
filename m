Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282F1CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 09:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjJMJms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 05:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjJMJmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 05:42:38 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D9110E
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 02:42:35 -0700 (PDT)
X-UUID: d24a5c2669ac11ee8051498923ad61e6-20231013
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tdt7DEalTs+e9pbUnFtXinlyDY+ZuOLZCQjB3edT23I=;
        b=ZGj33OIPgQBk0Kt2ofm/6fP+V8Lu2J/09PgZuljQMbPYZ7Vvxy4T86J9LlFQ6rFjCvCaQJV9nlD03w0pcbx1qZPnuWHe0NfrzNq+O21EyBV7KXK5uu+dQNneaAk/pUo9GzCLdNxHBNVlCCCtv1gzmxxBK9GdlmfaM1gviO6a/6U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:3abe4967-f1e9-4d13-bf8b-c6d431697f4b,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:5f78ec9,CLOUDID:1c8aff14-4929-4845-9571-38c601e9c3c9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: d24a5c2669ac11ee8051498923ad61e6-20231013
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 551840018; Fri, 13 Oct 2023 17:42:27 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 13 Oct 2023 17:42:26 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 13 Oct 2023 17:42:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nB3XGiFbxzDhvEo6Z6IOyZI+T2laubGSuwPMsf91Qm9UCjS0Wpv0NmYX0CJbcqdjGpD+EsU97H5re1WvjCfn9V1qvYRLiPHiEGF61dVsgNbljPyem4VdQd4T24JwjIBs7UriYuTDKciFyZJRh39vkG7P4CSH2lPafjle7ZABbow8BBWpu6Y+f6CIF1aUDFRuVk859QllVACuUruDZPWy9GSqyjiB5L7LKp01s7TlfMsTC2+2zg0Rb1Nyi5XgE+FdCxGZ2D9acW9cq5ijf3J4+0IiSR4Jy2JujDac6RHXCKeKron8BtXWwF5lDQ6hb+9cxC0J9vcuzD2pg6deXmJoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdt7DEalTs+e9pbUnFtXinlyDY+ZuOLZCQjB3edT23I=;
 b=HkUBVx41vrSNcm3n5i64QK2YrRbE9mpCSpzrNYD+9K1FQfyU//+/12MJg1jDB5JhiVv5p/Dy/lllHUeXPZE6rBXqgdFsEuHbuEa9XeXytj6akWX7kdKpzq1HZSQ5ayEPG3Rgd6i5K01teqVlhHoXTANNiWFVlRRNe/wNA9Q1uAjzAwf6WbobyeAb+3Xb07YQu6JJAwktdgnVYqiTJyNs4lEK0SY5DNiWu+dqTJvZVyrav/rwo8iSvPaFglK4oYM9yke8HvEkYcGx6iT2X4LlydCeNiMJ9qBYaBa5uLl7SkGPXMTG+rwwAJiOQpNgurQSyJ7CrROXoTsTftwfogF8Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdt7DEalTs+e9pbUnFtXinlyDY+ZuOLZCQjB3edT23I=;
 b=TyAqyDm3T7Yz6LsLlbpHcH5gK5Wro8C97C7I2+Z47MlLqKeuhTDQdaAr/dwxBIyr7y3yypX93PZVpb2G1zFRtWKdnVp2qcWeJCE7H50set/mY7/ICJQgxU8gq8U0CQhfBDUZ+a+r9ZDEB+2+wRmR3XrBInUQz2VF5D15B2BgFKA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6026.apcprd03.prod.outlook.com (2603:1096:4:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Fri, 13 Oct
 2023 09:42:23 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2eee:9111:fa17:658f]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2eee:9111:fa17:658f%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 09:42:23 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
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
Subject: Re: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Thread-Topic: [PATCH v2 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Thread-Index: AQHZ3AxeUDIKUfthIUawl3tYlp/OMrBHuwgA
Date:   Fri, 13 Oct 2023 09:42:23 +0000
Message-ID: <5afd3b643d75cd3a65adba84b2d31ef355e58abe.camel@mediatek.com>
References: <20230831130826.5592-1-peter.wang@mediatek.com>
         <20230831130826.5592-3-peter.wang@mediatek.com>
In-Reply-To: <20230831130826.5592-3-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6026:EE_
x-ms-office365-filtering-correlation-id: 2bc8ee69-f59a-47ef-fcb2-08dbcbd0b3ab
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /z7Ek6/IhRab8pDrvJdyvmGJ8RzyRkYgYrd4Bu+r9KUt26139ghm0NdGyDmnz25n38R2qUE9JXV5wSv5QosG8wTCcaRGaqvdX5L0j6EXFx0KnjR6SnIOSy5bL10mWebCzMS7loWgOrIlvAU5gwr/i2/lwIyMyvnwsMgffQcR4zsHEKSlIffx0FUQIaI33Wk0i4vALkzq1BDjfHf0mt/4OftWqQJpNmx6LacuEmP6yt52AsWBgYy6HjtCePjl0jjFYjLom4ZiYUB6ZpRWA/k3FcqxR3FQ5rfPvIxqQ/v22RNU8ZZddsEpS5162pmOLUeNUm+ObA7o3XX82yR7GwDLcVmP7MPsnzMfJ8FUWgTl4YCzyOtmWQRWDJSQLqRSAH71ipYGS2Qu2DMYHCaz8LqV2mgmtZQMtLMVnSIfWGO2GSqvmlAdcos+BMPUMtbz89x3qRXoNlH7bbNJtI/KDcOimxAKjdvaC+RNWzMy09mIoLhkYDJmJR1OhxxA/LxH8b3Z1a/CRcwCzFiOQ4BKLwQuX+ofDHuURWybbDQF0pJczGMAqV+90WBlDJRyf6aDCLxvGQ1WJosmmp42zyKiYO0n/vwFVIMlvWt53wLbxnY4Qqo4PBH/T+w32TgcHhjQTbIgD5GDLCSTD/ewNmanjxl4lAJ7eKrIH6QU4fmmPR4GsJUFFKInh5kfXUl0gAVYizi7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(376002)(136003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38070700005)(5660300002)(122000001)(41300700001)(8676002)(4326008)(8936002)(2906002)(86362001)(107886003)(2616005)(6486002)(478600001)(6512007)(6506007)(85182001)(71200400001)(36756003)(26005)(66476007)(66446008)(66556008)(316002)(38100700002)(54906003)(76116006)(91956017)(66946007)(64756008)(83380400001)(110136005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmhKcm12RlJoaVcvSHFOWVl3Yjk0M2xacWw5U2UxUUV5UXFxMGhRQ1FRLzZj?=
 =?utf-8?B?SjQ4WTYzWUdLMmt6MllWU0hsT2R1dUpsbGNXRnBFZmtlUXB4a21YNk9FOEpo?=
 =?utf-8?B?ckZkT3VBYWdsK244Q3F6WHUvUW9jaVd3L0YvenNZMFFpQnRTS0ZXRFUvalNl?=
 =?utf-8?B?OWl2WG8yemdCZ0M4cDN3UGpmREtkSkFWRWV5Sk53VmVFblBPd2c2am1taXM4?=
 =?utf-8?B?SldBTld5NkRZNnl0K3kxMHhFTjV4eFh4S0o0eXR1d1RjakVudnZNZDZIZXFw?=
 =?utf-8?B?TzRReXFsZlJwYXlzcm52V2RJZ1A5TDl0YW9wMXNXck9JVkRLN0FZMS92azJx?=
 =?utf-8?B?VWE3K01NYzNnQThOSVJyMUN2bjlqVk9yUVlNNUlLNXVMT0RDWVZvd1RrNFMr?=
 =?utf-8?B?bnJ3WTA4TVFubFBmb1c1L0hyeDQ0Zno1dTVkSXFva0RNZGE1VklKTFVSK2Ra?=
 =?utf-8?B?cEFYSHQ3TmhEcHdVSjR4ZWlBQnJzSi9pSzdoclhnRk5rRndtcnAxZndaNHc1?=
 =?utf-8?B?YlMwN2tOMDJRbE9sQjRYeVRYZ1FCQzc2L1Bqb0FQbzRVV3BkOFZvUnVTSTNR?=
 =?utf-8?B?a2c4Y29qWE5rL1hpc0JVWW16cU5iRTM2QTVlUHF1USttb0JpZlFRaVdNUDNB?=
 =?utf-8?B?dy8vQitUSTdNejZxWC9WMlpxN1RCc3F0cW1UMXNXZTgyMVNZTmVGYjlTTzFx?=
 =?utf-8?B?VkZWM2tnV2lmVnBNUWEvRWIxNEdza2VJOFN2WnNqYzkxa3NzdW50U0VqdzNq?=
 =?utf-8?B?Q05INUxWOGNPb0xndEdOVVJPaUtNYU9iclpnVkZWSkZxSG94WjRiWVlxS1ZQ?=
 =?utf-8?B?N0lNQ3YwSy9xWU1UT3UzZlFMOTZoT3dRMEdFUUdFWVN4dzlYelFFSGdYaFlV?=
 =?utf-8?B?R2ZXMVhmR1lXMUN6a1Q4c0xVVnY5bmJHWi82ZUdrdysrSFVDdUNTSVdEeG54?=
 =?utf-8?B?ZVNZRWh0Z3I5c0JjelRzd2NYTkdxWGZsOEhKV09rUXc5dTZtSXpHakJQUDRy?=
 =?utf-8?B?SWZKK1Y2a1FXL0dnTlZsSXBBdVdkUTNwTnE1MTd3MkFKUUtMZTFvOGVDSVpP?=
 =?utf-8?B?bmdNVXF3MHJSbXVmSjU2Z0ovRXk2S0loc1RlbUcxcTM3eStsenVuNlRkL1c0?=
 =?utf-8?B?NE5XN253ZXNxblNnM1ZXS09VOXcvN0hjTzFQUWkzVGRTcDMya1ZySmVvc2JC?=
 =?utf-8?B?d0ZGZlN3YUQ0aElIaFFHSXZQTU5zMk81RWU4ZFlULzIxNDBMZjZ5NFJsOG5a?=
 =?utf-8?B?REwrMjZEK2N5c3JTbmtPeFNrNWFlNDRRL3MzL0tSZTBmTnZtNDA3alcySFZV?=
 =?utf-8?B?dHBzNVQweGJVQ3FWc25BK1pZZXVRdndVcGZuUjZtQU5Tb3lMSlc3cmoydko0?=
 =?utf-8?B?TUxOVUV4bGNybURPb1ZvTmxFWG5oank3bU02TTNiRWxhL3R4UlRoWWxsemY5?=
 =?utf-8?B?SXlPT1d6M1lwVTZqZlhKd3k1dWx0Z3dZaEZvZmQrMGFDb2JGb2ZyVGJoR2pB?=
 =?utf-8?B?cjE1UFpGM2xCdGZmYXE1Y1c3cng3ZW9UQ1RMUzdmUHRvRWFobnZUYlN3cGlC?=
 =?utf-8?B?dDN4Z0F1ckdxYnBGUXJJbUlJNFA5UVIrWFcrUkFyREVUQlRRSSsrVWpXa0du?=
 =?utf-8?B?Z3RQK1R2aUJ3M3A0OUlLY1NObnZONG5iZFh6WkZBcE0vOU1DcUFJR2duTklZ?=
 =?utf-8?B?US9kQlBMQXIxTkVTcHU1S3ZWNVdjL1c3ODBrZ2RycC9hREl0NkR6QTMvaGlX?=
 =?utf-8?B?a2I5N0dyRC9iRlRJa1A4ZHpsKy9RTmY0QXp6aC9PTExrQ0l4eFZycERzalhv?=
 =?utf-8?B?c3VpdjJJc1ZYSEdrUjM0OG5DTm0yTEZlc3RCMFRWaHZNNDdic1BMdjZkd29s?=
 =?utf-8?B?ajV2Q0NBRXhaU0EyNEw3VS9Id3VhaU12QkxJQTdEekRsTWFkZktid0kxSW94?=
 =?utf-8?B?SlhJSnB4Tno2Q2doRjJsUWs2bkNkSEF3Mi9QNGt4R3FvdGNIRm1BcG5sRkFs?=
 =?utf-8?B?VXY2SklZV1J3NjNkcmVJMFRZME5zWlhaVWZHRTczdFFZZG1uN2pza3Z0TEh1?=
 =?utf-8?B?K3JVTitZUWxMWm9xcTY5UklWQ2JZS0o3UGtCc0NHQ1plQXNPRXgyeUtzWFFI?=
 =?utf-8?B?d2tSZ3ZVY3U4aDcyMndJK2dSMFRzRHJ2TlN3ay8vVnFmMjR3OXdCL3ZZTzVJ?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8D201BBEA17EB4581756BE059539E28@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc8ee69-f59a-47ef-fcb2-08dbcbd0b3ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2023 09:42:23.0774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFVLMcHpfKjzxPdVInZNZ8wUh2mCLBhyyOOM3Uaf+kwJszEyM2OsSdoKEXv1xPPUlMKlq0LAdMDQ0tduP6JDyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6026
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.258000-8.000000
X-TMASE-MatchedRID: 0aps3uOmWi7UL3YCMmnG4pmug812qIbzNjuRIfuOU0f3bdEB5dQXKV0c
        vQ4E8DdUXk6mOXfvRmDlPWOZdnoFfEHWbmeNr66RNCWPXerN72kZKp0SZ4P+dWecrqZc3vabwbD
        ngUleUcLyBGddnpVbSKExyNdv2PXTEuYl3YX/IW7il2r2x2PwtTGZtPrBBPZrvG/ZjO2Z8dSsVO
        9nWK57KlopIzoFYSSAx9bZ3MTEvwK1DfGM6db7X54CIKY/Hg3AwWulRtvvYxTUHQeTVDUrItRnE
        QCUU+jz9xS3mVzWUuCgZHIBpyeFpjHe5WQP3EeL6Fj03F09VmCY+rwcjXoWXE+WSkrykXHxftwZ
        3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.258000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: C02E6DC239A793B5CA3219B62B212A0C12E39FF627C403DC4354871614A75E402000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KVGhpcyBwYXRjaCBzdGlsbCBuZWVkIHlvdXIgcmV2aWV3Lg0KDQpUaGFua3Mu
DQpQZXRlcg0KDQoNCk9uIFRodSwgMjAyMy0wOC0zMSBhdCAyMTowOCArMDgwMCwgcGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20gd3JvdGU6DQo+IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KPiANCj4gV2hlbiB1ZnNoY2RfY2xrX3NjYWxpbmdfc3VzcGVuZF93b3JrKFRo
cmVhZCBBKSBydW5uaW5nIGFuZCBuZXcNCj4gY29tbWFuZA0KPiBjb21pbmcsIHVmc2hjZF9jbGtf
c2NhbGluZ19zdGFydF9idXN5KFRocmVhZCBCKSBtYXkgZ2V0IGhvc3RfbG9jaw0KPiBhZnRlciBU
aHJlYWQgQSBmaXJzdCB0aW1lIHJlbGVhc2UgaG9zdF9sb2NrLiBUaGVuIFRocmVhZCBBIHNlY29u
ZA0KPiB0aW1lDQo+IGdldCBob3N0X2xvY2sgd2lsbCBzZXQgY2xrX3NjYWxpbmcud2luZG93X3N0
YXJ0X3QgPSAwIHdoaWNoIHNjYWxlIHVwDQo+IGNsb2NrIGFibm9ybWFsIG5leHQgcG9sbGluZ19t
cyB0aW1lLg0KPiBBbHNvIGlubGluZXMgYW5vdGhlciBfX3Vmc2hjZF9zdXNwZW5kX2Nsa3NjYWxp
bmcgY2FsbHMuDQo+IA0KPiBCZWxvdyBpcyByYWNpbmcgc3RlcDoNCj4gMQloYmEtPmNsa19zY2Fs
aW5nLnN1c3BlbmRfd29yayAoVGhyZWFkIEEpDQo+IAl1ZnNoY2RfY2xrX3NjYWxpbmdfc3VzcGVu
ZF93b3JrDQo+IDIJCXNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBpcnFf
ZmxhZ3MpOw0KPiAzCQloYmEtPmNsa19zY2FsaW5nLmlzX3N1c3BlbmRlZCA9IHRydWU7DQo+IDQJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssDQo+IGlycV9mbGFn
cyk7DQo+IAkJX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nDQo+IDcJCQlzcGluX2xvY2tfaXJx
c2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA4CQkJaGJhLT5jbGtfc2NhbGlu
Zy53aW5kb3dfc3RhcnRfdCA9IDA7DQo+IDkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+
aG9zdC0+aG9zdF9sb2NrLA0KPiBmbGFncyk7DQo+IA0KPiAJdWZzaGNkX3NlbmRfY29tbWFuZCAo
VGhyZWFkIEIpDQo+IAkJdWZzaGNkX2Nsa19zY2FsaW5nX3N0YXJ0X2J1c3kNCj4gNQkJCXNwaW5f
bG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+IAkJCS4uLi4NCj4g
NgkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssDQo+IGZsYWdz
KTsNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAxNyArKysrLS0tLS0t
LS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggZTM2NzJlNTVlZmFlLi4wNTc1NDliMGU1ODYg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVy
cy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtMjc1LDcgKzI3NSw2IEBAIHN0YXRpYyBpbmxpbmUg
dm9pZA0KPiB1ZnNoY2RfYWRkX2RlbGF5X2JlZm9yZV9kbWVfY21kKHN0cnVjdCB1ZnNfaGJhICpo
YmEpOw0KPiAgc3RhdGljIGludCB1ZnNoY2RfaG9zdF9yZXNldF9hbmRfcmVzdG9yZShzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKTsNCj4gIHN0YXRpYyB2b2lkIHVmc2hjZF9yZXN1bWVfY2xrc2NhbGluZyhz
dHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gIHN0YXRpYyB2b2lkIHVmc2hjZF9zdXNwZW5kX2Nsa3Nj
YWxpbmcoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+IC1zdGF0aWMgdm9pZCBfX3Vmc2hjZF9zdXNw
ZW5kX2Nsa3NjYWxpbmcoc3RydWN0IHVmc19oYmEgKmhiYSk7DQo+ICBzdGF0aWMgaW50IHVmc2hj
ZF9zY2FsZV9jbGtzKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgc2NhbGVfdXApOw0KPiAgc3Rh
dGljIGlycXJldHVybl90IHVmc2hjZF9pbnRyKGludCBpcnEsIHZvaWQgKl9faGJhKTsNCj4gIHN0
YXRpYyBpbnQgdWZzaGNkX2NoYW5nZV9wb3dlcl9tb2RlKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+
IEBAIC0xMzg1LDkgKzEzODQsMTAgQEAgc3RhdGljIHZvaWQNCj4gdWZzaGNkX2Nsa19zY2FsaW5n
X3N1c3BlbmRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICAJCXJldHVybjsNCj4g
IAl9DQo+ICAJaGJhLT5jbGtfc2NhbGluZy5pc19zdXNwZW5kZWQgPSB0cnVlOw0KPiArCWhiYS0+
Y2xrX3NjYWxpbmcud2luZG93X3N0YXJ0X3QgPSAwOw0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGlycV9mbGFncyk7DQo+ICANCj4gLQlfX3Vmc2hjZF9z
dXNwZW5kX2Nsa3NjYWxpbmcoaGJhKTsNCj4gKwlkZXZmcmVxX3N1c3BlbmRfZGV2aWNlKGhiYS0+
ZGV2ZnJlcSk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIHVmc2hjZF9jbGtfc2NhbGluZ19y
ZXN1bWVfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+IEBAIC0xNTY0LDE2ICsxNTY0
LDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2RldmZyZXFfcmVtb3ZlKHN0cnVjdA0KPiB1ZnNfaGJh
ICpoYmEpDQo+ICAJZGV2X3BtX29wcF9yZW1vdmUoaGJhLT5kZXYsIGNsa2ktPm1heF9mcmVxKTsN
Cj4gIH0NCj4gIA0KPiAtc3RhdGljIHZvaWQgX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nKHN0
cnVjdCB1ZnNfaGJhICpoYmEpDQo+IC17DQo+IC0JdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gLQ0K
PiAtCWRldmZyZXFfc3VzcGVuZF9kZXZpY2UoaGJhLT5kZXZmcmVxKTsNCj4gLQlzcGluX2xvY2tf
aXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiAtCWhiYS0+Y2xrX3NjYWxp
bmcud2luZG93X3N0YXJ0X3QgPSAwOw0KPiAtCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5o
b3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gLX0NCj4gLQ0KPiAgc3RhdGljIHZvaWQgdWZzaGNk
X3N1c3BlbmRfY2xrc2NhbGluZyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0KPiAgCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7DQo+IEBAIC0xNTg2LDExICsxNTc2LDEyIEBAIHN0YXRpYyB2b2lkIHVm
c2hjZF9zdXNwZW5kX2Nsa3NjYWxpbmcoc3RydWN0DQo+IHVmc19oYmEgKmhiYSkNCj4gIAlpZiAo
IWhiYS0+Y2xrX3NjYWxpbmcuaXNfc3VzcGVuZGVkKSB7DQo+ICAJCXN1c3BlbmQgPSB0cnVlOw0K
PiAgCQloYmEtPmNsa19zY2FsaW5nLmlzX3N1c3BlbmRlZCA9IHRydWU7DQo+ICsJCWhiYS0+Y2xr
X3NjYWxpbmcud2luZG93X3N0YXJ0X3QgPSAwOw0KPiAgCX0NCj4gIAlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ICANCj4gIAlpZiAoc3VzcGVu
ZCkNCj4gLQkJX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nKGhiYSk7DQo+ICsJCWRldmZyZXFf
c3VzcGVuZF9kZXZpY2UoaGJhLT5kZXZmcmVxKTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIHZvaWQg
dWZzaGNkX3Jlc3VtZV9jbGtzY2FsaW5nKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo=
