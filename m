Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001ABE80A8D
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 05:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjI0Fkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 01:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjI0FkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 01:40:02 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D63D10E2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 20:32:33 -0700 (PDT)
X-UUID: 79d8674a5ce611ee8051498923ad61e6-20230927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=waxxOtWwvLXYpVI40PmgoKFlJ1QDTx/b6JpF46oD44s=;
        b=bO8r/xi6MBwRUmJYr898v1lXeGp1SZ06a1qjf1MA5xnvnhxW4RwS2OhPQIhK3VetWqKzBwKK+yiw/T4ezIb2vQCHgg2soZ7YEmDYV6OaCmGM9lN/84L81gveUvZRFaKTiPOb7U3SUWb/DEtuEeV+A+8eqbAag8OObW8VJ3cuU7w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:f964145a-42db-4698-987d-2dab9227c3f8,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:629d2df0-9a6e-4c39-b73e-f2bc08ca3dc5,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 79d8674a5ce611ee8051498923ad61e6-20230927
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 500629119; Wed, 27 Sep 2023 11:32:25 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 27 Sep 2023 11:32:23 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 27 Sep 2023 11:32:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1MtfVbAFL4fMkabR9eeUUd+z7TveVWKWBv0jOEUBP0xOpWPpNX6p/yvGXf4ei08VNAGTk+4zudcaCiNrNequFFZdAbY7lWUd3fY6UA4IxBXC4DRCSMH8eFY8nHeSvvxiz0HcgUcQL6B7C4ISMeBnA+WgqtcG9CefCHyKcIQvvI1i4OyDK3V9BmeXa4+4OAPV4omnnzeKeYEm6icTWA1mEyxCT+srrg/0cGwTKsPYUInIme+13h93xqEwH30/PsCTrvIuGf/eCnV2dTp4ehOmFEFPDwWILoqZjkvyymdyawz9fBtzw3sCh9VprhXVVDWuR3yJ8T6UhngPgqRp2KTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waxxOtWwvLXYpVI40PmgoKFlJ1QDTx/b6JpF46oD44s=;
 b=Hw3TXwEQOVDGW4UY6x+97oR+md97TSyfrqW/ETd8XgK3N89Y2B6pWg1qttRyVzORLQpK5q5BJX2Qk+PAZqaB2jbIAOPf4f9djc5nWtv2jrBR7y4UEnu62eTf3kIbKxj3QIo3TPLluNi8HwI3z0pSp+P+oGdm8W7C5YJVWUIoj2m1IFz7A33bbMcBsDRUkhVtNh+9xu9fOTWG7HtAJ4vLFI+nPUMoM5pA65nMQr98kzKbXkCWaw5wglw41KPTgxtSABjrTcpKzbehxzOa6kpupSwy0EHfa2LR3FXJdQ49yUIfWvdhEABpTjUoYueXAZEs1gPKJQFQBQbdJStbYQZRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waxxOtWwvLXYpVI40PmgoKFlJ1QDTx/b6JpF46oD44s=;
 b=YCTfIgCUdpw6jkhMqC6j5Wk6ICurPiiN/pvTzoxgH0ZAEV6RyXCJ/oSn4G9E0q7JxL634cTTx5tm1QWsg9nfSWRhnkV8lcNO2vZ8vDJibxZm4Crbyx2I+beb4/u1gzLx0sRMr/4pTNkrTZfiJUKPl5v2uyiVkfS/KPsOADx4rOA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8182.apcprd03.prod.outlook.com (2603:1096:101:192::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 03:32:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739%4]) with mapi id 15.20.6813.027; Wed, 27 Sep 2023
 03:32:21 +0000
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
Subject: Re: [PATCH v4] ufs: core: wlun send SSU timeout recovery
Thread-Topic: [PATCH v4] ufs: core: wlun send SSU timeout recovery
Thread-Index: AQHZ7TSACjZ7KD9RGkyeHXTyvz3HuLAtdF6AgACXqgA=
Date:   Wed, 27 Sep 2023 03:32:21 +0000
Message-ID: <846b29ff4ec350e7139918373e5de62d6452bbca.camel@mediatek.com>
References: <20230922090925.16339-1-peter.wang@mediatek.com>
         <f10fff07-8a7d-473e-b793-95c2796e63f2@acm.org>
In-Reply-To: <f10fff07-8a7d-473e-b793-95c2796e63f2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8182:EE_
x-ms-office365-filtering-correlation-id: 2d57e644-25d3-49a4-8e73-08dbbf0a5be7
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYV1De9c+sTVRzZREH4kumLFnD+5bg8EtvvC07kbR4ExmPUa4WftvT3226ppkT0Oo1VJ+jbxgVAVGGWcSKgsqwM2vZmobyElaV5H3s1rqyvM51O/xwb0VztfkSEIBCVOKmd5yaYruiUDouoBaAeVnf7THvoDg1hXtA2G28DklwOjQ8/dqy5tnhLzbaVB8emSn4yuGEqSoQYxMjZsBZWJUtqL+pbib5o24kr/RE0SqmjnyePX52pgnjIj/9qKalPkknbpEwWYE0YeqgrUYyv4Pbkn6a/+7mWalInTSDCCGdvnt1nhX2MFHlUqCqu7ow3GzTz6dLH34jCXZIevtd6uCdFmk6hiwnVXpKrhOS2bH/od1wfn3F6ktTSaX8D0aCN9OtIbcUsJStqu2hLLiwWENiWK1V76Pm0WcF46q0c132D5ktdcO2qDDgxxX3stBMqxRz4cfvDB8jQvbjAQF/whIP6KEtO6adl1ODfIz/P+wfxyfmoehHl/ZXcf08UoClqtt7JfmPqzhUlG1hiMMZGFEf0+b7ZJYXG/cx0OYXkDZ8VWSBi0w/9NexMKrZDMZmLeee5+FFQp9r391XOCHcZovUc6Tj85rq9uI+UzuMbnRLJjoELFGg7N8ouAsiEA6v+jYHDvnrj9H4qPndxCzwFRVn980Vib9VFSbGHDae6vrqEPofC9VLhsp+Y9heaLqsoM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(396003)(376002)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(2616005)(83380400001)(38070700005)(38100700002)(26005)(2906002)(107886003)(8676002)(8936002)(4326008)(6512007)(71200400001)(36756003)(6506007)(53546011)(5660300002)(6486002)(64756008)(41300700001)(54906003)(110136005)(66446008)(76116006)(91956017)(66476007)(66946007)(66556008)(122000001)(478600001)(85182001)(86362001)(316002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UE1aaGlhbm9NWUxrcURlUlZEVE0vMUhISGttaTlGcWVobCs3a1NYTzdzZ2hW?=
 =?utf-8?B?Q0IwNzcxT2ZvOUxzODc1Si8wQlc3MGRkdFEvcTBSemRiOEhTQklqTDdneUZY?=
 =?utf-8?B?WDNxOVVLNWwrN2NqTXRsWXh0YmoxWVVYTGIxYWxnMUUrVUtNTnFsWVJSZ3dT?=
 =?utf-8?B?cm9CRkcwZDRJUWc3N3dWR2dqY1FPZ1hhR3N6VWdhQnFnMEcyeWNVQzVCL2x3?=
 =?utf-8?B?WVVMd2NXQ2l2aVNEWU9ENk0rL0xlNlR0dEpHVnRjMEk5QVIzQmJxQlc3dzhE?=
 =?utf-8?B?U2dCUzd4b1ZLakVhc2E1NE1YQ1VDbWYvYzJMdFIySVlqMUFJbWtSZ1dIM3Iv?=
 =?utf-8?B?YjBERzNrZUh2MUZLV0FEUDMwWThjWFdYelY1aXo2cEs0SkV3SjNWOXJsQ28x?=
 =?utf-8?B?elpzRUpBczBUSEtkMVQ5Qjk0anlGb3ZTVVU3NGlqNWJoVVpncWdTOGpmbkdC?=
 =?utf-8?B?UW5lOHp3WHVRWVY0cjcvY0E5ZWVldWoxQnRDOExSVmhra1pTNU9nTjloSzky?=
 =?utf-8?B?dWpjMDZ2NXdSY2FFNnUxZzJZWXRxdkxqZ3FuR0pNdkVJMy82ejI3YUNhc0lH?=
 =?utf-8?B?eit3VXUvM25DZ05FL0xKNStVOXp6T004NzhxSFlIaXJVRFBpYzAySjM5QjZC?=
 =?utf-8?B?bVFabEEzV0ZuZXdRRTMxSXNlQ2Y2U1BpWWw2R3RFbUc4aGdjZElNM2FoaUhL?=
 =?utf-8?B?dFYyN1p5dzNleFB0eW9qZmV5U2VpRW8wVjUwKzV3MkpyL24zUFlUY1UxTm9a?=
 =?utf-8?B?eE1sZkpSRmk2NDB2SHhDQko3eDRIQXMrU1R3aktiT3FDb2I3KzFlcDB4Tnpp?=
 =?utf-8?B?Vkd5VFRJbXNHeStzcTFEeWRXd1luVklPV20wK2JURUxFaXg0UEtPbTJtampP?=
 =?utf-8?B?OXVUS3p3bnlyRTBzbTN5ekxmY3JXMG1GZ1pmeDIvWnRmNldkSXJBYWMrUHg5?=
 =?utf-8?B?WE9VbC9kdEFLOUxVVGVPNUJYN2YxSERVRVRRNEdOMHNWbS9EMHprTlhweHBY?=
 =?utf-8?B?Y0tmUHZjdlVid3NueXZnL0lUbTltNVQyUjVTakVrUUtxRlFUdG1HVGh6Q3F0?=
 =?utf-8?B?U3NENm80aHpXc0FRSGx4WTlaRXZoWUMzWjlobjE5VHZNNlpTWFdmbGdDU1hm?=
 =?utf-8?B?aHBWeDZEWDNWQlgwL3ozRlBvdEpZeVYwbkRtREhOTEFWTW54Rms3eTdsVnJx?=
 =?utf-8?B?WkdzY3c0SXVhdU9GU1F2YWF0SU81MlhoT1c0ampoeUEwdzg4OHF4d3BYMGRL?=
 =?utf-8?B?bUJnMy9McktuRHNleENwaW11aFRXWkdmdHBTSU5SbTNHbkgxWXB0RmphYVZD?=
 =?utf-8?B?MHU3TzNXVi84em5mQkYyK0h4TVFVY3ZkRnVuWGd0MjE4bkQ0ZDVxN2NCdHQ2?=
 =?utf-8?B?RUo1V0ZoTVExTWVPM1p6K3U0UHlUVlJBK2JHeXlFZ2xiRFRrZnc5WkNiWlJm?=
 =?utf-8?B?UnFIdWVmcEM2N21ZM2hjeXNwYTcwaUM2QThMZ3RxbFZocldFY210ZHk5bENI?=
 =?utf-8?B?dlB1eGFMelgvbVdqcTkxRTNGcWlWUXBaa2hpSGMxRk94VFBidWc5eFpndjNB?=
 =?utf-8?B?SVhTcnhpb2xBNE5udnV3bWNDellFbmdmalRTWjk2Z25iZm9ZcythWW5XZnpM?=
 =?utf-8?B?QTZ2amovakdNQ293RVpPeUg5aURwa2d3WHh1eFpSRHNyWGl4OWdONUFzVFdX?=
 =?utf-8?B?V1h0SDlWN3VTczg5MGVPdmZORUMrWjcvTmNqYklkZ0xKdk05OFo4MitjdUc1?=
 =?utf-8?B?VmpKeEQ5Nm1MaTdYdmx5elZKTkkweUI5WUNxQ1gwSTdQOERkZWhGTi9hWU5X?=
 =?utf-8?B?RlFKTWNXWVFlTTBKVjdpMGRaWlJCN01NbVltM0lkNHRPeEcvQUpkMTYzcWJw?=
 =?utf-8?B?cGxQc21YNjRBZXRQajRVRjZ6Z3NrTTVHSjdBZXphd0ZEVXRzcnk5bkVvMHc3?=
 =?utf-8?B?cU92MkZ0V0NocExDd1NvZ3l2SmNMQU9ZVXdZMDg3S1FxckRnNlNPMStHNi90?=
 =?utf-8?B?MFNheW9ZczF2eG9HYlllV3B2Z1pjdUhnRFZaTStVVlJtVGVScHY1ZzFlYk8z?=
 =?utf-8?B?bTArYVZUcUpMK1Vwam1jRjNSYUdrNVIrOXpOSWFlem1IRVVBZmFxdFozelFR?=
 =?utf-8?B?OHpSUDYrS1NKcDRHaXROSGZFNmVmWmNsT0pTcjZJTVdDbTA0ZFoycjUvZG5Z?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCDA9258376A464786B0F215CAE9EEF1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d57e644-25d3-49a4-8e73-08dbbf0a5be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2023 03:32:21.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QWqvlZCYScidy2NZvawmDj0+6Dxe+cqQkvgKcS7NubfcFeOVrEtsx5HF3hlMZPGB1L40NHYXMM1DulVObNTvpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8182
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--23.185600-8.000000
X-TMASE-MatchedRID: GBgFBUqwD4HUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
        WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosT8kg
        eyY1buLM1Cissf7mOXp625Q+rMfUPVJ3fELbkWegVglQa/gMvfHzVh6U+16DkZoOjyDyMC8sXQU
        5a094toi2TF8JaS5nzcavgKu41MNiPLG+A0qvEpkhwlOfYeSqxfS0Ip2eEHnylPA9G9KhcvbLn+
        0Vm71Lcq7rFUcuGp/HCttcwYNipXwKmARN5PTKc
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--23.185600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: B2340FAFE10F52996ACC84361037851EADD35C08FF8FD0B3FCB56FBB6D7340E12000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIzLTA5LTI2IGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yMi8yMyAwMjowOSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20gd3JvdGU6DQo+ID4gKy8qDQo+ID4gKyAqIElmIHJ1bnRpbWUgcG0gc2VuZCBTU1UgYW5kIGdv
dCB0aW1lb3V0LCBzY3NpX2Vycm9yX2hhbmRsZXINCj4gPiArICogc3R1Y2sgYXQgdGhpcyBmdW5j
dGlvbiB0byB3YWl0IGZsdXNoX3dvcmsoJmhiYS0+ZWhfd29yaykuDQo+ID4gKyAqIEFuZCB1ZnNo
Y2RfZXJyX2hhbmRsZXIoZWhfd29yaykgc3R1Y2sgYXQgd2FpdCBydW50aW1lIHBtDQo+IGFjdGl2
ZS4NCj4gPiArICogRG8gdWZzaGNkX2xpbmtfcmVjb3ZlcnkgaW5zdGVhZCBzaGVkdWxlIGVoX3dv
cmsgY2FuIHByZXZlbnQNCj4gPiArICogZGVhZCBsb2NrIGhhcHBlbi4NCj4gPiArICovDQo+IA0K
PiBUaGUgYWJvdmUgY29tbWVudCBpcyBoYXJkIHRvIHVuZGVyc3RhbmQgYmVjYXVzZSBvZiBncmFt
bWF0aWNhbA0KPiBpc3N1ZXMuDQo+IFBsZWFzZSB0cnkgdG8gaW1wcm92ZSB0aGlzIGNvbW1lbnQu
IEEgZmV3IGV4YW1wbGVzOiBJIHRoaW5rIHRoYXQNCj4gIndhaXQiDQo+IHNob3VsZCBiZSBjaGFu
Z2VkIGludG8gIndhaXQgZm9yIiBhbmQgYWxzbyB0aGF0ICJoYXBwZW4iIHNob3VsZCBiZQ0KPiBj
aGFuZ2VkDQo+IGludG8gInRvIGhhcHBlbiIuDQo+IA0KPiA+ICtkZXYgPSAmaGJhLT51ZnNfZGV2
aWNlX3dsdW4tPnNkZXZfZ2VuZGV2Ow0KPiA+ICtpZiAoKGRldi0+cG93ZXIucnVudGltZV9zdGF0
dXMgPT0gUlBNX1JFU1VNSU5HKSB8fA0KPiA+ICsoZGV2LT5wb3dlci5ydW50aW1lX3N0YXR1cyA9
PSBSUE1fU1VTUEVORElORykpIHsNCj4gPiArZXJyID0gdWZzaGNkX2xpbmtfcmVjb3ZlcnkoaGJh
KTsNCj4gPiAraWYgKGVycikgew0KPiA+ICtkZXZfZXJyKGhiYS0+ZGV2LCAiV0wgRGV2aWNlIFBN
OiBzdGF0dXM6JWQsIGVycjolZFxuIiwNCj4gPiArZGV2LT5wb3dlci5ydW50aW1lX3N0YXR1cywN
Cj4gPiArZGV2LT5wb3dlci5ydW50aW1lX2Vycm9yKTsNCj4gPiArfQ0KPiA+ICtyZXR1cm4gZXJy
Ow0KPiA+ICt9DQo+IA0KPiB1ZnNoY2RfbGlua19yZWNvdmVyeSgpIHJldHVybnMgYSBVbml4IGVy
cm9yIGNvZGUgKGUuZy4gLUVUSU1FRE9VVCkNCj4gd2hpbGUNCj4gdWZzaGNkX2VoX2hvc3RfcmVz
ZXRfaGFuZGxlcigpIHNob3VsZCByZXR1cm4gb25lIG9mIHRoZSBmb2xsb3dpbmcNCj4gdmFsdWVz
Og0KPiBTVUNDRVNTIG9yIEZBSUxFRC4gUGxlYXNlIGZpeCB0aGlzLg0KPiANCj4gVGhhbmtzLA0K
PiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KVGhhbmtzIGZvciByZXZpZXcuDQpJIHdpbGwgY29y
cmVjdCBjb21tZW50IGFuZCBjaG5hZ2UgcmV0dXJuIHZhbHVlLCBBbHNvIG1ha2UgaXQgbW9yZQ0K
c2ltcGxlIGJ5IGNoZWNrIHBtX29wX2luX3Byb2dyZXNzLg0KDQpUaGFua3MuDQoNClBldGVyDQo=
