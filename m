Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D981CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 09:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjJMJm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 05:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjJMJmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 05:42:12 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE8CC
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 02:41:46 -0700 (PDT)
X-UUID: b748af7269ac11eea33bb35ae8d461a2-20231013
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4JRR8RhI/vx7bS0tSs1xRhnM2y5SDDBz5TJmeQZs8S8=;
        b=EbDNf6eaXu13MLpVpWyo4AfcoNKoUU7Dz5xwDZVTaJfT5D+lxTKM5Y384X6RWOt5CU+2jNBZV14gzOB3301RVZIxv1oqOyUwVJEoq0zOcm/PYOls4hzvTGHSEudiNz78WSJXO7PSx7OTmQdud/G33Bov1EomeG7VPKHDfFcOrRk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:84f08d06-e145-470a-8140-5ae448b6e87b,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:3b6816c4-1e57-4345-9d31-31ad9818b39f,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
        DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b748af7269ac11eea33bb35ae8d461a2-20231013
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2070404409; Fri, 13 Oct 2023 17:41:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 13 Oct 2023 17:41:40 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 13 Oct 2023 17:41:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQztKYSq519bbjvv865pIpuD8k8B1LsKdSG/4jscNAvFvgmX5ZtZ4Zhuz+MxP1IkOREtpAjg/dH0NwpTSpS1f+xtR1JsrGd4JkK1I78eS4EpU7lxgEq4EH2zxzQRxRb3wx39WFH6GSgf80IbR//7NM/p+ySN09tV2ADV7ORxCmVUxGwceOmyHebOKdVikMMZQ8i5MmhmDlD61qHD2nqiburAmNvBcE9eVCYMXtd8M11zuT4+r6zOrdowcXNe5DGzOnreFrmCbHL8fL5zUAQkuwBNDN/KChQ64UHx6fqsx0omDihgHN/+9ccHcXBsB5Ze2JhjdBo5VNYB+AbqZWeTjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JRR8RhI/vx7bS0tSs1xRhnM2y5SDDBz5TJmeQZs8S8=;
 b=PuQUZb9O503hxKmVe3ZBEMEwdX7fs2IC56ZHGceGf8shbGQPpG6y+kAaaEeTZu0B5u8GhFcW1P3SpyTV08bItx+V/X+8/9vEZWtlMcfi7oLStn5QCBPaWMIGIj7d5lXfBf7oY8wfTgC/VcJcHmHrj73M2L+5Y10glGpXslA9hfOMeSqRqKP6amBjRoh3kU4tXZDKTQqUxH96/BYanoFzdJxRaJFoWdMpPuBkWqhbCJvLcG6eDN1w2P/r1gVdbNpWCXAv1un+XnOWzRp9GrsvNYI45SsdW8rcn8OhuZn23p3NBSh1+FfBxrUxen8zl+sMY32aYU/MfF/z9UYGy5Y2ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JRR8RhI/vx7bS0tSs1xRhnM2y5SDDBz5TJmeQZs8S8=;
 b=jTZTm+MwUhfYo3t495c5Dd85+BvRHBwsbpG3EmGspOZMHUkXWSb8rdPwp4Edcoy/OnoVsX6U1eXiCl8vGDGzvQmYhxGI7a4BCSbvPlSQMogp18RO3yB2JsPrnKWqurCGWx/Rocb9m7VDoI5J8BNC76q0zNYkSkk5PiBJem5PniA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7658.apcprd03.prod.outlook.com (2603:1096:101:12a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 09:41:39 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2eee:9111:fa17:658f]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2eee:9111:fa17:658f%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 09:41:39 +0000
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
Subject: Re: [PATCH v1 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Thread-Topic: [PATCH v1 2/3] ufs: core: fix abnormal scale up after last cmd
 finish
Thread-Index: AQHZ1aR2BafDuhwx4EC7CJqwb4QAi7ABinIAgACmkoCAARgtAIBEfnIA
Date:   Fri, 13 Oct 2023 09:41:38 +0000
Message-ID: <f09f76d727903ec1e1596961f9f035f858ec5f60.camel@mediatek.com>
References: <20230823092948.22734-1-peter.wang@mediatek.com>
         <20230823092948.22734-3-peter.wang@mediatek.com>
         <468fb5a4-32d5-42a7-b00f-115044954125@acm.org>
         <3d3ef797414961e2eb6bc9d6dbfd45a32e7381eb.camel@mediatek.com>
         <822010a3-aeb1-4ef1-a2fa-ea100c33b3f2@acm.org>
In-Reply-To: <822010a3-aeb1-4ef1-a2fa-ea100c33b3f2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7658:EE_
x-ms-office365-filtering-correlation-id: 3ac5279e-7c6f-4b28-5346-08dbcbd09961
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pqg78cv6fv/Cqe2ORzLwUpBGSw4F4zWATLHVDU3/OUfo5cI9Odt2F9eFBetpEctJwj66JryU9CZOibGqsnxlb4UmEYewmXxb7tVECkLLH1Ve5hd/V6Q/x3lPoPGzv90Qnsi3g+KRDHq3sXBaZcjDVQDDaCUIZxqqeaKmCE9s8CBGvX6eLzr5w8wYnfFYVlQWQtFp17gLd6Jv7GFcgx21bLjkOwgscugKnTCkaS9CSAiWGKDYh3GPNnYZ69Jk4x0wzys4MNp3hTRHSHqWSPKS1rRdsE+DnHtOrtUM8OrQkCCpPZ4FC3rE2cS2MrJTlLxXLw0pao014DzpsbDcGPkhKN3MgscGH4YZeGZy9INQM+kG8GfHmdmCTPLc+FStVhQiZ/ePVg2zbJlgl8qmiYlNNq/F3CZoa4j7tFg/VDDGwALInqrE3nhZSOadcz4eYr30/hBE5PVFXpy/6iYIc/rfg61tFmBpb099gppjrIrKSNX9nkKYVb/GhVNJGTxy8rMnt7NeB/1xrCS5s1vVOjeBj2LyDBpgdUPngApgHppID5934pRVlbz02HY19UG4xEsR1OjFyhOLVcf8a7UieuzJoPsYkFZTPJaiqn64sGX7q+InGgqEJOmHIvvTV17QNWKKtOxJcOs1cVICb3frhT9r8JAwr2br2h8780JdKnDfPSK97mpafFUeia03V1V6EFJ2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(376002)(136003)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(478600001)(6486002)(85182001)(107886003)(2616005)(36756003)(6512007)(26005)(2906002)(122000001)(38070700005)(38100700002)(83380400001)(86362001)(4744005)(71200400001)(53546011)(66556008)(6506007)(91956017)(110136005)(4326008)(8936002)(8676002)(76116006)(66446008)(66946007)(66476007)(54906003)(316002)(64756008)(41300700001)(5660300002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFlMR00wOEZHZVJSbTRZUnpkaGR2UGN2d2ozM09KWHVZb042Z0NaZXFET2lm?=
 =?utf-8?B?QVB5SlZkc2ZBRzBIN3NGaVNzVWRlWTRsbkZURXdVOVRGWG96bWUxdE9UK2p1?=
 =?utf-8?B?RzR4czhKQ3hpUlVzaU1qUDNtNEhQaEx5T2VQTzhZbDZEU2JJNTJYYy9qcHhM?=
 =?utf-8?B?MkM2MklFVDhVYUpHSFZUQ0RvKzZuNlpqbHQyNitYbkJiU0hla0E0OGcwUXMy?=
 =?utf-8?B?VFZDYmNTTXIxZFd0WHhZOGowZHlDVUNEWDdQRmEvcVBncERDWVpjWi9xWGhm?=
 =?utf-8?B?WXl1cGdqSlZGbFl1V1pOZlg3cXBLRldOWXdkY1Z2dHFPeGpmSnhjVDIzNVls?=
 =?utf-8?B?ZmkyNzJSTDFuam9SY2duM0pJZFhjTjUzUE9pMUVoS3hHdlpIL1F2N1RoYmFF?=
 =?utf-8?B?TUpqR0xwNHo1YWF3eE1aK0c2bVlCQXhGSzJ2ajVzdWRRaWhvT1RObHVqM1RU?=
 =?utf-8?B?V0FoMFhZV1dWZVNweC8yUG4zRVg1M1JjWGpDd2d1dklqeVNUenI4YlZFc1V4?=
 =?utf-8?B?Z2JFN01jYldOa0U1VkZDejExeHlwS25zSHF1WSt3cVd1N2xKYmFrdXRwUFR4?=
 =?utf-8?B?cXEyYVdzbXZzbjB2ZTk4RmxwakJHWFhyUEhlNTh2ZGFrdVE1T0JXRWJ4U3Fy?=
 =?utf-8?B?YmRuTVgyV3NmSGtuMEg0TkQzeGhMNWlWNG1mZ0c4WTRGLzAwQ2FnTlg3UEQ4?=
 =?utf-8?B?WjBJeGZiSHJMVlFORUIrd3NMUzEyaEQ3SkIzN3dQU2JjRlhWUHlwTFVtTkFv?=
 =?utf-8?B?aHhNanFIalRkWDdFRVppVEdPaGlud25KMmFJMFNWTURZSm4xN2RUdkU2aFNK?=
 =?utf-8?B?dEEzZ3pSa0RydmNsSUFYT25GVDYvUkg3QUpGc0Vjb0xCUnFZazMzOGVtb2ZC?=
 =?utf-8?B?bDdIUmNCZE1YRTZhRTNLUGNIWCs4ZEZLSjhQMmhVaEErNXlWb20vUFpoYVJy?=
 =?utf-8?B?YU9MZ1VnbjFrRnhUQ2l6Vlh5VHBJbUZaU0RuTG5VRDRmTEYyWXh5MlpvbVk3?=
 =?utf-8?B?eEIvRUtUQTJVRHFhUDFvSzA2bFc2QUdHeFVwbEdlYll1eFpDa0ZrbUJzdGFL?=
 =?utf-8?B?UkFWTmMwV1Y5VmVFSXZ0a2hUYXIrRWdOV04vQitZcUIrTGppdmNoT2N0d1ln?=
 =?utf-8?B?SEFCSlZQcnFhYU9TcDhmWEVuY3NvYnl1dkF0UGl5Q2VZSFhLTWV2dWVQVy9Q?=
 =?utf-8?B?bFcwSS90NnU0WjRVdVFzK3NCd0FlVjkwMTNHcnlIQ1VjM2w2UzZDY2FKQ3Nw?=
 =?utf-8?B?aWFicFVGU0RmVXJ0ZDlPRUR4VHdZRGhNeDlsemdQV2NJNWNjMnV6QjRCUXpH?=
 =?utf-8?B?amJ0LzVUZUNvanlTTWo5UTRyVXpXU2ExTjhvZE9GSFpmblJzcCsvTUR6aUhs?=
 =?utf-8?B?YW01WDc1KzRVS29ZdldsaDFZRVJUVmcwTHpNYVJSbnBvY21XeUcveGwrNHZa?=
 =?utf-8?B?YjNkLzZDbHNvdlJOQmR6aEoyd1RKdmtiZlFBdFJqclRsUm0zZG1WdFlBVGxM?=
 =?utf-8?B?TWdqYldzUXgvbzRtd1BqUEk4MTAwVytGUDVZTnRhZk5Nc0Y3N1VlWkV6czc2?=
 =?utf-8?B?cUhxRjN1YzYyUHd3VFdkTmhHdzZLOUFkdTV5aWhIMEYwRnRHc2p2YnlYNXlv?=
 =?utf-8?B?dTA3bTI0ODBjNmszT0xucGFEWFE4TDRJNkIvelZlaDNudGhMVWdBVXQwbzJm?=
 =?utf-8?B?UmtqNEc2eEdENGVZYkN2ajNtb2ZPUlNSS05yOGcyTFl1SkJoWW4zSjRZVlpy?=
 =?utf-8?B?Q2JwVzlBRUowSDZqTkFJNkJhZEtFU2lKUHZoZFVoVXlBSnNrSkR0c2FyMUlY?=
 =?utf-8?B?aUh0YmtsMFV6elY1WnFEM2loOFhYcTM4aFp5TlZrbllhaW5OL1NnSWVZaEVH?=
 =?utf-8?B?NG1mVEw5aEwrdzNycktNbW5qZnZHeDZrditUTUE0eDJTQStCdmhwbTMvS1h3?=
 =?utf-8?B?R2tWYnhCcDhaYS92aU1tRE1GS0o2dkp5aUZtNTlTNU1HY2xQSXc5bGVnREty?=
 =?utf-8?B?N2dqaCtPUHkzTFBybmdrcTcwVDRmODlKVmFpd1BOeDM0anQxSURiS28vN2t2?=
 =?utf-8?B?WmxkQXZDdjFLb1FMWis3ajVKL2NhWkw2dUlmRXpVU1Y4T0ZhbHZ4b0c5ajkr?=
 =?utf-8?B?QmFYT3FHWFJCRnBRcG9TNSs5dnFlaWRLRFZyWktPalJDU0Y0NnpOcjQ3UjBM?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AEE71C5A1247D47A8D4EDD9F8AAEAE6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac5279e-7c6f-4b28-5346-08dbcbd09961
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2023 09:41:38.9652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jp1GYW2q3melbFUFaCBjOfcmnMyb+DUIuQQgdqAat0AfR8Wc06hMyb06rcQQnkaWI0moG/BKpfsw6ddCmrpNaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7658
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--20.978200-8.000000
X-TMASE-MatchedRID: TDQWNTPftUDUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
        WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTH5s
        pzYqDCI/OLY/Jp308G+JB8ihO9+4zAMFp5W5WHQKeAiCmPx4NwMFrpUbb72MUZYJ9vPJ1vSCMa+
        I77rKoOxMQLQ/0+9hG3QfwsVk0UbuAUC1moT5enH7cGd19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--20.978200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 6095ABDF7215850091E3F79823B4C69EB58AD882D394ADC5F3BDF643C5958E632000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIzLTA4LTMwIGF0IDEyOjQzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yOS8yMyAyMDowMCwgUGV0ZXIgV2FuZyAo546L5L+h5Y+L
KSB3cm90ZToNCj4gPiBTZWNvbmQgX191ZnNoY2Rfc3VzcGVuZF9jbGtzY2FsaW5nIGlzIGNhbGxl
ZCBmcm9tIHVmcyB3bCBzdXNwZW5kLA0KPiB3aGljaCBubyBvbi1nb2luZyBjbWQuDQo+ID4gDQo+
ID4gU28sIGl0IHNob3VsZCBiZSBub3QgYSBwcm9ibGVtLiAoY21kIGZpbmlzaCBzdXNwZW5kIGNs
b2NrIHNjYWxpbmcNCj4gcmFjaW5nIHdpdGggbmV3IGNtZCBzdGFydCBidXN5KQ0KPiANCj4gVGhp
cyBwYXRjaCBpbmxpbmVzIG9uZSBvZiB0aGUgdHdvIF9fdWZzaGNkX3N1c3BlbmRfY2xrc2NhbGlu
ZygpDQo+IGNhbGxzLg0KPiBJIHRoaW5rIGl0IHdvdWxkIGJlIGJldHRlciBpZiBib3RoIGNhbGxz
IGFyZSBpbmxpbmVkLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0K
Q291bGQgeW91IGhlbHAgcmV2aWV3IHRoZSBuZXcgcGF0Y2guDQoNClRoYW5rcy4NClBldGVyDQoN
Cg==
