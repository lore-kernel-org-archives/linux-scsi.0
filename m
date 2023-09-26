Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ED8E7D27A
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 10:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbjIZKYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 06:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjIZKYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 06:24:02 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F011D
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 03:23:54 -0700 (PDT)
X-UUID: c93d6d525c5611eea33bb35ae8d461a2-20230926
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=frLqIp55Q46qIZgePQo4IJYenZxzH+7/hl3hbFdrppI=;
        b=aUzmnEIPP742y9TWY8pUDkykkMIq/R+BeKs1SOcSfyHh05tjWg49avPTa6k5HnCNz2TJ3jFc3lfnntda6lA5Dp+A+iG8euGYJOkQ5Uc10+0y0o5GiYtmTgCzdfRa4sotIeuSvCRdS5niEVpu+7nORtF54KP1FS8873wMyN02LLo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:e3a77aba-a350-4631-872b-1141f68745e3,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:e29626f0-9a6e-4c39-b73e-f2bc08ca3dc5,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: c93d6d525c5611eea33bb35ae8d461a2-20230926
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1579593957; Tue, 26 Sep 2023 18:23:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 26 Sep 2023 18:23:49 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 26 Sep 2023 18:23:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqgFIK302AfoaZ+kcRkOSaYfxsq5YB2Y0tQpkm1MkBhkp56LJBWXiQJaGNcIGReVqmB3gnlYzrScLt6wliwklwAkxJjcXXx8wUDpWKIwKhfBNzY/PDWwtteSlGYFyT6JbzjC7I5+7dP/sOjlgxe7iY+BbNK1/2LoMETHm1/Ar8OiImr2Uv2NojkFgjfZKXJ76pbqAlwQdy6JWRaarjbwq8jAeFNJpAbIQ/aAs9XUTwoT3/NCCsd3ZqJcw1jVtmaT2NbXPtNT5LrnoqDzPiOF41gqokYAeDmFNv9O0mdq+DnlwMaESmcr/VVdC84I5d6tcDh7h9O2MVxAyD6bql0EXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frLqIp55Q46qIZgePQo4IJYenZxzH+7/hl3hbFdrppI=;
 b=HYP4L8o4IryJF9pKbB51wqXdGqf83KqdKarxaOA2MzIW6AbZZPHK3484xCmCk9FzNnaP8BAveCds4GCJFHxRVEjr4O6cw7azy2gBCdk5Xnam4AZa30yIVdkG6/voxDXxGbckxhJDEbf7odffGPxbCb5cfGltFsQ1gWnffEjQGT7CXsonynlV4hXwdGlZWxwji2nfo76fB/9py4jVEFN4oPUleyh2MTQ9FMXg1jj325Fn7nwHTRpG9PobFgA1/USsp3z/d9q1iXC1VpSHBDkE/qRHuTe8x8p2qi3+N/cxIBXdQ9QWkFKCchWkL1O62gli2BKEWvlCeSJW+X+ztbuOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frLqIp55Q46qIZgePQo4IJYenZxzH+7/hl3hbFdrppI=;
 b=uFBwzTS1EK8bDk5dTuP5XQnxAcCJskfghX/m/xX2QyaUPbqi5s7lieL+p13bvSQaQVgRI/b8q316TUqyj/P4SGY8TVLnwQtvvQtUZZlitlpXaT3I6ieYm80+l3uIAvgo5pHGlb4X4pOYZcNUGgdf9/mMpDQSDnB6JU6NSmugEO8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB6113.apcprd03.prod.outlook.com (2603:1096:820:90::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 10:23:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739%4]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 10:23:47 +0000
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
Thread-Index: AQHZ7TSACjZ7KD9RGkyeHXTyvz3HuLAnAviAgAQ9fwCAAN51AIAAzbsA
Date:   Tue, 26 Sep 2023 10:23:47 +0000
Message-ID: <93ea4b18ddb010547d3170c73403b3e9985795f4.camel@mediatek.com>
References: <20230922090925.16339-1-peter.wang@mediatek.com>
         <10bf17cf-8a92-469b-bc5c-1f0dba0ed5ed@acm.org>
         <39e0a8b6d6f235dfa7dd36a4436c9eac5ab5210e.camel@mediatek.com>
         <98f256e3-72f7-48cf-8d25-58781d7051fa@acm.org>
In-Reply-To: <98f256e3-72f7-48cf-8d25-58781d7051fa@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB6113:EE_
x-ms-office365-filtering-correlation-id: c0a5a19c-afff-4d74-81f4-08dbbe7aab61
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFGWjMOCakDh2XOGMSHoHntSFrwDlOv8saPq0xaG2ySRrKBEc8vY5uVfTCoV6AwaxUWLntJeqcRhzu4AwEOgbNRqYUgLFlHHJBhiUJLuKsqAzIWGJetAi1gpWmKaUeqk3BMno5vbs0D5Ww73Wrhp6Eu2VXE35e5YpKLz6o9wiryptSO38iQsnlwKw+pl5MwUbLxThCaJ9gMopsHpfyxVIVpXsh+u5E4rVQi+SIlsUPaXp33A0ln0dWlXq7RBnjZLxwTrkjomlT5V3ZdmqkCcRXRgeHEqpf0wdt0Cl3u1oGxwNAEfrz6svYlBn0Kgn80efwAzLHYoJxPOgegr6qSB32tzu06wdYOUyj7XM5OmgTJn6iLPnj6+z2tGKUVa46gj3wA8RYhEpGI2/p1lKqUJOKbxgN4/Duygk6XlWjHD0BOEKDm7gcFJV0LFJT+cvfFkEUbgRYNodQmTl26uFV138FaSk0/T06z9020GsI3sAymsCwviXbyvlC8GJwC0ix56lqN1cN4SLSHG5BBumGqeSROkLBXVTXvYCOz8BS8uJLS0POMzCX1c5fkMqh4TBqNSFRVAPXyl4RSb2XZVy359nyxwvIzVfTaPAxVfaRiYKbZ2QsWllvtFovMdMZGvOQZY8oPy/JsaaAhixzDNYyCPm7cu2Yc09RH9tQYFj8g2vAg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(451199024)(186009)(1800799009)(5660300002)(54906003)(83380400001)(8676002)(316002)(41300700001)(8936002)(36756003)(85182001)(4326008)(2616005)(76116006)(66476007)(66946007)(66556008)(66446008)(966005)(91956017)(110136005)(53546011)(6486002)(64756008)(6512007)(6506007)(71200400001)(107886003)(86362001)(26005)(122000001)(38100700002)(2906002)(478600001)(38070700005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXhzL0Jzb0FjYkJoeXhoNlRISEk0SEp0ZlpadWZadHhtYmtpUTZPVitFUnZx?=
 =?utf-8?B?VitrT2ljTk81b3Bjb0F5Q1U3M1B6RHZaRXBvQ09mU2JmRVh2enZHTGFaRnVU?=
 =?utf-8?B?Zi83Qm9xRHRYYi9LK3F5c2tGSGhuSlZIT2REdlhSNGpCUlplaWVCWWZWaUVa?=
 =?utf-8?B?bW83aXVJQlFoQXJpVFpxU1FxaXllcTBhRk45Ulp5a0pRWXVQN1MrdVRkOVh6?=
 =?utf-8?B?Nlo2VWszTWZpY0dudFFIRFhSVGFUMmJMMlVicUx3MThNSWNFQ1Bla3l0Ylp4?=
 =?utf-8?B?Y1R0cURJWDdBUldydy9lZER6Skg2RS9ZZ25rUUF4U3h4cEpNTmdUdllEc1Y5?=
 =?utf-8?B?YklGS0RQQWZEY1RJMmYwVUZ2K1NZdW1reUlKQkk0YTJaYXI0Vml3OTdLMG5r?=
 =?utf-8?B?VmhSUkZpOHZuOW9SN2s4S2lzNnFIMyt6UGpOSjNWaFk3bVBxU1BzcDM4NWRV?=
 =?utf-8?B?SllQUjNUNjJ4YjYrazE4OWs3cnM3V3RWTXc1RS9FR2JIRDFYVlRUV1l4QmxE?=
 =?utf-8?B?dmRDRDZFOFM0Ui84cDlnd1ZreE1ZVWMvTXV1a0wrcm5adnQ0OWtHMUFNRmN0?=
 =?utf-8?B?Tlh6WGNRSDdncFcxV0VhT0lHOEtqNGo4Vks2SnBVMGpJV3FzcitFei9iT3RO?=
 =?utf-8?B?Y21UT0llc3hoa01Bc2FhTjR5bkJ3Z0l2Unl5Zi95aHBkbUlpS3ZWa0tGbzNI?=
 =?utf-8?B?RHozalBJamhna0IvU3ZtbUNkRm5MVEZRWk5yZzFERUNxMVhja3htSFVLUUQy?=
 =?utf-8?B?SmdQd0IzRytieUorOENFczNIbWNMV2lDUDFtSlJtTEgzRTA5NnNEdVI4VkdZ?=
 =?utf-8?B?VlNENTArcnBXUjd0bXBBY0lEcGtkOVVDREdPYzBGN3E5NlJuNFhnWCtaUFp3?=
 =?utf-8?B?VnZUZXhwRTkvU1U5Z1Ixa29oS0lITHJqb1ltMTdYQ2pwWGEvTGJ1OWdHdDE0?=
 =?utf-8?B?ajBURmlhUmtWRnE1NFFjUkFhMnE3elVhN3I4YlB3SDFDTjdyZ0hiTU0rbEho?=
 =?utf-8?B?TGZSNGxnTE1HREtXZHJ1czliVnQ3TVN4ZGlhQ1d6WmJtN0hrMDlmYzA1M1FY?=
 =?utf-8?B?dGtlNUh2Y08rSVhXWkROY0FpbWU2SVlBUUFXMmd4azM5Y0NVUW12T3lyYlFU?=
 =?utf-8?B?UVZ4d1ByeVJZbFhOaVNZSnJaQ1V6NGEvUnljU2M4VXMzVndaU2dTSUhIRHZp?=
 =?utf-8?B?Y1N5dmErZGllazVzQmxJZ0dXZXM1LzFJU29PZFZvMDk4aTNUYmxsQmx2anVP?=
 =?utf-8?B?MUxrWWRoY005MVRJcTFqZC9mdjdkS1U1eDdiVUcrRC83bWhVTXdCbzhkNVNO?=
 =?utf-8?B?UVR0ZDBmZE9iU3FFUVplbFNYc1Nwa1lNQ3NFcjgwN3pvRDI3K3M0RmxHaXA2?=
 =?utf-8?B?WlMzeEZnSzlBdWdrcmU5NnAzTUVtR3VwUXN0NS9yU1IyVGdTZHhmc1ZKVFdU?=
 =?utf-8?B?dlMxWHZNN0YrV2J4cHNEUy90WDcvTTg3M0ZFSEhyRmd6YzRSSHZJNTlObFEy?=
 =?utf-8?B?YnVGOUVmbzlxaFdXN3lXYW1BdDNwRHl0Z1BaVUZNU1lHZTltaXJoTVNvM2xK?=
 =?utf-8?B?NGpHUFV1aEh4dTBDK0dveVNNZTNVMitnTU8zbEN6ck1iTnJwSVptTnVHMFcv?=
 =?utf-8?B?TXNrUHd3VlVaTHpWaWhjdDZTNnY5Sk8xb2RacjBjTHpHL2o0N3ZOckpYeFh0?=
 =?utf-8?B?ZEFzVDhXWk9vdWpzcWQzWW5OZkI0RitqUHZQSTl6dGp6KzVudlh3Y1ZINkov?=
 =?utf-8?B?L0NTbGlTTE5QUFRkNmlXSENJNXhzdU93UFpWRVY3VUd4RzVsbEh1OVlHd0NZ?=
 =?utf-8?B?R08rTEdTRXFpUmlhMk1MZStQeU9lOXlEQVQ0L1RDNFFqVzZkVVAwTmRRS3BH?=
 =?utf-8?B?aHYvWHkwNkZWbGZFNmNFc094S01meG5qajdBSkwxS3llQkFXTUVBeGVVdFg2?=
 =?utf-8?B?anNTdjR4amIvMHQvVWJZWDFwVUxpekRCZVRscmthK2htZmxuaTNmWk5INitm?=
 =?utf-8?B?cWdhWTNQcGhqL0MzM3RQUXI3QkUrbVBMV2tDT1F0RmNENXl0RDZIYXN0WkI2?=
 =?utf-8?B?RTJQNVArZHY2bVdiNXJNZHZobU0zNDYzc2t3bUd0NWhJMkVIOWhsdDc5SG81?=
 =?utf-8?B?KzdndUpzVnRRQWN1OFRYRmhQaDNKL0VMZVM1YjdGb2lDTHlGc2hXNmJkNERi?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33A89B6716E6B1499CF9D150998103AB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a5a19c-afff-4d74-81f4-08dbbe7aab61
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 10:23:47.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fI0tXMekVJjHCATgQl2zvns0k1hCycs3uKTYFdxBgxet2eTz+FPXWMQ6bZvSnTLaockHyx2Vv1xKN8kYwacF4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6113
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIzLTA5LTI1IGF0IDE1OjA3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yNS8yMyAwMTo1MSwgUGV0ZXIgV2FuZyAo546L5L+h5Y+L
KSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjMtMDktMjIgYXQgMDk6MDYgLTA3MDAsIEJhcnQgVmFu
IEFzc2NoZSB3cm90ZToNCj4gPj4gT24gOS8yMi8yMyAwMjowOSwgcGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20gd3JvdGU6DQo+ID4+ID4gV2hlbiBydW50aW1lIHBtIHNlbmQgU1NVIHRpbWVzIG91dCwg
dGhlIFNDU0kgY29yZSBpbnZva2VzDQo+ID4+ID4gZWhfaG9zdF9yZXNldF9oYW5kbGVyLCB3aGlj
aCBob29rcyBmdW5jdGlvbg0KPiB1ZnNoY2RfZWhfaG9zdF9yZXNldF9oYW5kbGVyDQo+ID4+ID4g
c2NoZWR1bGUgZWhfd29yayBhbmQgc3R1Y2sgYXQgd2FpdCBmbHVzaF93b3JrKCZoYmEtPmVoX3dv
cmspLg0KPiA+PiA+IEhvd2V2ZXIsIHVmc2hjZF9lcnJfaGFuZGxlciBoYW5ncyBpbiB3YWl0IHJw
bSByZXN1bWUuDQo+ID4+ID4gRG8gbGluayByZWNvdmVyeSBvbmx5IGluIHRoaXMgY2FzZS4NCj4g
Pj4gPiBCZWxvdyBpcyBJTyBoYW5nIHN0YWNrIGR1bXAgaW4ga2VybmVsLTYuMQ0KPiA+Pg0KPiA+
PiBXaGF0IGRvZXMga2VybmVsLTYuMSBtZWFuPyBIYXMgY29tbWl0IDcwMjllMjE1MWE3YyAoInNj
c2k6IHVmczoNCj4gRml4IGENCj4gPj4gZGVhZGxvY2sgYmV0d2VlbiBQTSBhbmQgdGhlIFNDU0kg
ZXJyb3IgaGFuZGxlciIpIGJlZW4gYmFja3BvcnRlZA0KPiB0bw0KPiA+PiB0aGF0IGtlcm5lbD8N
Cj4gPiANCj4gPiBZZXMsIG91ciBrZXJuZWwtNi4xIGhhdmUgYmFja3BvcnQgNzAyOWUyMTUxYTdj
ICgic2NzaTogdWZzOiBGaXggYQ0KPiA+IGRlYWRsb2NrIGJldHdlZW4gUE0gYW5kIHRoZSBTQ1NJ
IGVycm9yIGhhbmRsZXIiKQ0KPiANCj4gSGkgUGV0ZXIsDQo+IA0KPiBUaGFua3MgZm9yIGhhdmlu
ZyBjb25maXJtZWQgdGhpcy4NCj4gDQo+IFBsZWFzZSB1c2UgdGV4dCBtb2RlIGluc3RlYWQgb2Yg
SFRNTCBtb2RlIHdoZW4gcmVwbHlpbmcuIEFzIG9uZSBjYW4NCj4gc2VlDQo+IGhlcmUsIHlvdXIg
cmVwbHkgZGlkIG5vdCBtYWtlIGl0IHRvIHRoZSBsaW51eC1zY3NpIG1haWxpbmcgbGlzdDoNCj4g
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3NpLzIwMjMwOTIyMDkwOTI1LjE2MzM5
LTEtcGV0ZXIud2FuZ0BtZWRpYXRlay5jb20vDQo+IA0KPiA+IEFuZCB0aGlzIElPIGhhbmcgaXNz
dWUgc3RpbGwgaGFwcGVuLg0KPiA+IA0KPiA+IFRoaXMgaXNzdWUgaXMgZWFzeSB0cmlnZ2VyIGlm
IHdlIGRyb3AgdGhlIFNTVSByZXNwb25zZSB0byBsZXQgU1NVDQo+IHRpbWVvdXQuDQo+ID4gDQo+
ID4gDQo+ID4gDQo+ID4+DQo+ID4+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZz
aGNkLmMNCj4gYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4+ID4gaW5kZXggYzJkZjA3
NTQ1Zjk2Li43NjA4ZDc1YmI0ZmUgMTAwNjQ0DQo+ID4+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNoY2QuYw0KPiA+PiA+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPj4g
PiBAQCAtNzcxMyw5ICs3NzEzLDI5IEBAIHN0YXRpYyBpbnQNCj4gdWZzaGNkX2VoX2hvc3RfcmVz
ZXRfaGFuZGxlcihzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ID4+ID4gICBpbnQgZXJyID0gU1VD
Q0VTUzsNCj4gPj4gPiAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4+ID4gICBzdHJ1Y3QgdWZz
X2hiYSAqaGJhOw0KPiA+PiA+ICtzdHJ1Y3QgZGV2aWNlICpkZXY7DQo+ID4+ID4gICANCj4gPj4g
PiAgIGhiYSA9IHNob3N0X3ByaXYoY21kLT5kZXZpY2UtPmhvc3QpOw0KPiA+PiA+ICAgDQo+ID4+
ID4gKy8qDQo+ID4+ID4gKyAqIElmIHJ1bnRpbWUgcG0gc2VuZCBTU1UgYW5kIGdvdCB0aW1lb3V0
LCBzY3NpX2Vycm9yX2hhbmRsZXINCj4gPj4gPiArICogc3R1Y2sgYXQgdGhpcyBmdW5jdGlvbiB0
byB3YWl0IGZsdXNoX3dvcmsoJmhiYS0+ZWhfd29yaykuDQo+ID4+ID4gKyAqIEFuZCB1ZnNoY2Rf
ZXJyX2hhbmRsZXIoZWhfd29yaykgc3R1Y2sgYXQgd2FpdCBydW50aW1lIHBtDQo+IGFjdGl2ZS4N
Cj4gPj4gPiArICogRG8gdWZzaGNkX2xpbmtfcmVjb3ZlcnkgaW5zdGVhZCBzaGVkdWxlIGVoX3dv
cmsgY2FuIHByZXZlbnQNCj4gPj4gPiArICogZGVhZCBsb2NrIGhhcHBlbi4NCj4gPj4gPiArICov
DQo+ID4+ID4gK2RldiA9ICZoYmEtPnVmc19kZXZpY2Vfd2x1bi0+c2Rldl9nZW5kZXY7DQo+ID4+
ID4gK2lmICgoZGV2LT5wb3dlci5ydW50aW1lX3N0YXR1cyA9PSBSUE1fUkVTVU1JTkcpIHx8DQo+
ID4+ID4gKyhkZXYtPnBvd2VyLnJ1bnRpbWVfc3RhdHVzID09IFJQTV9TVVNQRU5ESU5HKSkgew0K
PiA+PiA+ICtlcnIgPSB1ZnNoY2RfbGlua19yZWNvdmVyeShoYmEpOw0KPiA+PiA+ICtpZiAoZXJy
KSB7DQo+ID4+ID4gK2Rldl9lcnIoaGJhLT5kZXYsICJXTCBEZXZpY2UgUE06IHN0YXR1czolZCwg
ZXJyOiVkXG4iLA0KPiA+PiA+ICtkZXYtPnBvd2VyLnJ1bnRpbWVfc3RhdHVzLA0KPiA+PiA+ICtk
ZXYtPnBvd2VyLnJ1bnRpbWVfZXJyb3IpOw0KPiA+PiA+ICt9DQo+ID4+ID4gK3JldHVybiBlcnI7
DQo+ID4+ID4gK30NCj4gPj4gPiArDQo+ID4+ID4gICBzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhv
c3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+PiA+ICAgaGJhLT5mb3JjZV9yZXNldCA9IHRydWU7
DQo+ID4+ID4gICB1ZnNoY2Rfc2NoZWR1bGVfZWhfd29yayhoYmEpOw0KPiA+Pg0KPiA+PiBJIHRo
aW5rIHRoaXMgY2hhbmdlIGlzIHJhY3kgYmVjYXVzZSB0aGUgcnVudGltZSBwb3dlciBtYW5hZ2Vt
ZW50DQo+IHN0YXR1cw0KPiA+PiBtYXkgY2hhbmdlIGFmdGVyIHRoZSBhYm92ZSBjaGVja3MgaGF2
ZSBiZWVuIHBlcmZvcm1lZCBhbmQgYmVmb3JlDQo+ID4+IHVmc2hjZF9lcnJfaGFuZGxpbmdfcHJl
cGFyZSgpIGlzIGNhbGxlZC4NCj4gPiANCj4gPiBJZiB0aGlzIGZ1bmN0aW9uIGludm9rZSBhbmQg
UlBNIHN0YXRlIGlzIGluIHRoZSBSUE1fUkVTVU1JTkcgb3INCj4gUlBNX1NVU1BFTkRJTkcgc3Rh
dGUsDQo+ID4gaXQgbWVhbnMgZXJyb3IgaGFwcGVuIGluIHVmcyBkcml2ZXIgcmVzdW1lL3N1c3Bl
bmQgY2FsbGJhY2sNCj4gZnVuY3Rpb24gYW5kIG5vIGNoYW5jZQ0KPiA+IG1vdmUgdG8gbmV4dCBz
dGF0ZSBpZiBjYWxsYmFjayBmdW5jdGlvbiBpcyBub3QgZmluaXNoZWQsIGp1c3QgbGlrZQ0KPiBi
YWNrdHJhY2Ugc3R1Y2sgaW4gc2VuZCBTU1UgY21kLg0KPiA+IE9yIHdlIGNhbiBtYWtlIGl0IHNp
bXBsZSBieSBjaGVjayBwbV9vcF9pbl9wcm9ncmVzcywgd2hhdCBkbyB5b3UNCj4gdGhpbms/DQo+
IA0KPiBJJ20gY29uY2VybmVkIHRoYXQgdGhpcyBhcHByb2FjaCB3aWxsIGZpeCBzb21lIGNhc2Vz
IGJ1dCBub3QgYWxsDQo+IGNhc2VzLiBUaGUNCj4gVUZTIGVycm9yIGhhbmRsZXIgKHVmc2hjZF9l
cnJfaGFuZGxlcigpKSBhbmQgcnVudGltZSBzdXNwZW5kIG9yDQo+IHJlc3VtZSBjb2RlDQo+IG1h
eSBiZSBjYWxsZWQgY29uY3VycmVudGx5LiBObyBtYXR0ZXIgd2hpY2ggY2hlY2tzIGFyZSBhZGRl
ZCBhdCB0aGUgDQo+IHN0YXJ0IG9mDQo+IHVmc2hjZF9laF9ob3N0X3Jlc2V0X2hhbmRsZXIoKSwg
SSB0aGluayB0aGVzZSBjaGVja3Mgd29uJ3QgcHJvdGVjdA0KPiBhZ2FpbnN0DQo+IGNvbmN1cnJl
bnQgZXhlY3V0aW9uIG9mIHJ1bnRpbWUgcG93ZXIgbWFuYWdlbWVudCBjb2RlIGp1c3QgYWZ0ZXIN
Cj4gdGhlc2UgY2hlY2tzDQo+IGhhdmUgZmluaXNoZWQuDQo+IA0KDQpIaSBCYXJ0LA0KDQpZZXMs
IGJ1dCB1ZnNoY2RfZXJyX2hhbmRsZXIgd2lsbCB3YWl0IHJ1bnRpbWUgcG0gcmVzdW1lIHRvIGFj
dHZpZSBpZg0KY29uY3VycmVudGx5IHJ1biB3aXRoIHJ1bnRpbWUgc3VzcGVuZCBvciByZXN1bWUu
DQoodWZzaGNkX2Vycl9oYW5kbGVyIC0+IHVmc2hjZF9lcnJfaGFuZGxpbmdfcHJlcGFyZSAtPg0K
dWZzaGNkX3JwbV9nZXRfc3luYykNClNvLCBpZiBydW50aW1lIHN1c3BlbmQgb3IgcmVzdW1lIHNl
bmQgU1NVIHRpbWVvdXQsIHNjc2kgZXJyb3IgaGFuZGxlcg0Kc3R1Y2sgYXQgdGhpcyBmdW5jdGlv
biBhbmQgZGVhZGxvY2sgaGFwcGVuLg0KVGhlIGlkZWFzIGlzLCBpZiBydW50aW1lIHBtIGZsb3cg
Z2V0IGVycm9yLCBkbyB1ZnNoY2RfbGlua19yZWNvdmVyeSBpcw0KZW5vdWdoLg0KDQoNCj4gPiBT
aW5jZSB0aGUgaGFuZyBkYiBiYWNrdHJhY2UgaXMgbm90IGludm9sZGUgYmVsb3cgZnVuY3Rpb24s
IGl0IGlzDQo+IG5vdCBoZWxwLg0KPiANCj4gSSB0aGluayB0aGF0IGNvbmNsdXNpb24gaXMgd3Jv
bmcuIENhbiB5b3UgcGxlYXNlIHRlc3QgdGhlIHBhdGNoIHRoYXQNCj4gSSBwcm92aWRlZD8NCj4g
DQoNClllcywgSSBoYXZlIGNoZWNrIHRoaXMgcGF0Y2ggaXMgaW5jbHVkZSBpbiBvdXIgY29kZSBi
YXNlLCBhbmQgaW8gaGFuZw0Kc3RpbGwgaGFwcGVuLiBUaGUgc3RhY2sgZHVtcCBvZiB0aGlzIGRl
YWRsb2NrIGNhbiB0ZWxsIGhvdyBpdCBjYXVzZSBpbw0KaGFuZy4NCg0KVGhhbmtzLg0KDQo+IFRo
YW5rcywNCj4gDQo+IEJhcnQuDQo=
