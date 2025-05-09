Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB133F3
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746756956; cv=fail; b=n8aV49Mv0w7jdHIr733ARJBAv6YXA2s5wqU4wH8J65vgTx7Iu0y/UiB5NUupi7GvAnKahRClPN5sh0Qz24nxDTkTNHBOzTF5lDrF+S6Ep81fUjBbj1i5jf1zE7sUczWULrVYxeA2hqfGqQxzLWiGpZ4SFWGFQeS3Xs69K5MyvCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746756956; c=relaxed/simple;
	bh=fIQlHoPfjXgsmVIP4UBYirS4Ijh18jTUrnGtkfGD3Gg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QAF9f12dBBtJ0/l2+ZAgK2V2mW0roCBokzOXHbd3/e65vfMaJGJwhLl/oJsH+MQiN6jxzlLYiJ5sKN7xVI+7AGVqpeG2xWZyecMtPR1rafc66BdvYbyG28p4+5TE96FgLeZf9vV/qxM4Gg6hIng5jIL1fPPFYSPVmS7dH+ILTvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NzknWjhz; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VyWlh2zb; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NzknWjhz";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VyWlh2zb"
X-UUID: 8331a1382c7b11f082f7f7ac98dee637-20250509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fIQlHoPfjXgsmVIP4UBYirS4Ijh18jTUrnGtkfGD3Gg=;
	b=NzknWjhzf/hRb1nfG5GSJSMnzJ0ljlWT1ebsU9vlGeN5Uyr5M1Z6UaX/08HopYBGqO3iJmo4joS7rmhTbodss68FLq4cFsiLmiffWYcP5Melyw+dRH6WE4Gufu7n/4WEMEOeyZQePjIJmk9ufKZtJDyTzzmw7eXhx3jEo1hGN6Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:5034e1df-14c2-48ab-b0b7-951bcbe9b974,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:d6b15351-76c0-4e62-bb75-246dfb0889c6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 8331a1382c7b11f082f7f7ac98dee637-20250509
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 128850754; Fri, 09 May 2025 10:15:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 9 May 2025 10:15:39 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 9 May 2025 10:15:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqKFlioQ/JrOhVVqog2NIr/d2Fo/C1CLFzjDDPQf6vwTb+WUcApaGV6HqXu6Da6s4Yi8sdwzxBchmYCowMSYD8INJUK/EdEqtvLx9GmGBxg7jtqyXvJMfDeWhcTIb7DeNFkbxp2n95EVgUtqCbhkKPGc5wkTIqFfMW1q99DdChcutRuWEsMADpTJQ6AEvuOK9vkKtBNWrZ/8esq6EGHnOG5429TjZdk+1fLwwmPrxpIOFFHkx53HQvpdaSOepkglz5b9n0v/VNDGGHBME4goNs60UQyGffarbMtFh8dybp9iTBj7QZR5w8oICJuIt4hYXY5pd53q0O4nnDK6BgrwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIQlHoPfjXgsmVIP4UBYirS4Ijh18jTUrnGtkfGD3Gg=;
 b=l0sowg7eEVLnpApMy2uPkVcCXpDGBWWpVJidntBdZvkNsA35+/e8mFe8W3ZJtwee6UJ2fJFb0EW/jJctKjwnihiHOrP8GXTz30WSjLNbyee2+Lhc65ozEMs3v9U2/1WeY3h8CVvkhXxS/0rgQhc9Ms74fdfGB4rjPtdjxDSKepTNBbgnFftg4pQ6tRr+hQhf/ooxD9/GRBYHh+RZ+/KLd259n2KzzJs10Q0pWTAE0g9UcsdoVY+D1+mpoSIZ5eh+c1few5TRUEN5ZxCLWm75vCIiDxVo9ow5Wt1kWcQQFcZspMeUy+CYLbfoojqTI3NqsJl26Ynqaxj091RgDWlqIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIQlHoPfjXgsmVIP4UBYirS4Ijh18jTUrnGtkfGD3Gg=;
 b=VyWlh2zbOXLYzDfcGObNoCiapFwWoa+gv/dOTtWA0TkRcM4UAugzLqFBeVsF7DzdP4An7L+1JAgJhDIJCdxpDOC+BGql2fFD3JHnpSKtUcQ9elR4Om4QsU5bib5MzBaHjQ3AB4HYkPYNAUSsOlT4atr/nTv2Hwl/PcKj550a0nQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI6PR03MB8611.apcprd03.prod.outlook.com (2603:1096:4:247::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Fri, 9 May
 2025 02:15:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8722.021; Fri, 9 May 2025
 02:15:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: behavior change of hwq_id type and value
Thread-Topic: [PATCH v2] ufs: core: behavior change of hwq_id type and value
Thread-Index: AQHbv/pIOdrvJnL4q06WZGXAs038QbPI2ZCAgAC2+wA=
Date: Fri, 9 May 2025 02:15:37 +0000
Message-ID: <b5046a752b4deaa9f84c0b848eb2062d955d1d51.camel@mediatek.com>
References: <20250508091914.307944-1-peter.wang@mediatek.com>
	 <b3fb4302-462d-4b92-a6cb-784000cd796c@acm.org>
In-Reply-To: <b3fb4302-462d-4b92-a6cb-784000cd796c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI6PR03MB8611:EE_
x-ms-office365-filtering-correlation-id: 3d1ad228-b66c-4a1f-4f30-08dd8e9f634b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NFBoV0d3aFRkUDl4d1ZzeGhYNUNqNzMydHNkdWp3bmRkRHAwMG5uMFByWnA1?=
 =?utf-8?B?ODVhRklqRHdxbjgyTFhkNjJvc2tPMXFUa3B3VWxPUWorRzRDOEMvT3RnakhY?=
 =?utf-8?B?eGV6eVppcC9LbnBGY0xyWG1lL0VxYi9MQi8zWEJibld1NWR2Q05OYmRhSjFx?=
 =?utf-8?B?WDF6VXZyOUxaMTNkdjFLRU5mNitGLzZmbC9JdWxuOFJidnZINlo1d3ZHN3hE?=
 =?utf-8?B?c2c5dVNtV3FqQ2tMKy90Y2RZdjd3ZDUyYWRlOUo3QnVVWHdoMVM3SExXeGtV?=
 =?utf-8?B?QVoxWDRXdDlqdGpqd3I1cmd4N0xTL0JCWnVuL3NobTloZ2M5LzJOU3ZxVGhM?=
 =?utf-8?B?VGdRVW93L3BxRytSWEY4bVJBbTQyekkwQ3VLczYvR1dKcmkzWjdHdEhBQ2FB?=
 =?utf-8?B?SDJoWE5qZFk5K1puS0VLQkhiWTY0RzhnckVQYWlkYzdGZ2s1NDlwNXRDYWU5?=
 =?utf-8?B?cy9aOWdoL3lOaFNtMUdtbmg2dkdwUGNGUmdkS2doOFJ4VFd2b3NmcG5EVllM?=
 =?utf-8?B?d0prVHZMb29pZEJ3a2VPdmlSL21CWXRRQXdjZUt1L0lDQ1M3WTdqSU9qMUdz?=
 =?utf-8?B?b2xTWkZyWllqcGF0UUJ2THUwL1orWHBLSjZxN255bVVuVlNSYks2cGRpR3JW?=
 =?utf-8?B?TzVRY1IxRzRQTW52T29xV2RJdnJpa3RLdlpjNkk1U2JJN3FUZlRhd3JBNUE3?=
 =?utf-8?B?YjNUaHJFbjZoa0lqRlNBVmxoZ1ZMRGJnREpEWkxBNmNHc25yOUJwSTI1aWVJ?=
 =?utf-8?B?c1pYZ0RjeUNhV2NaRm1wSVo0ajBxWGZSa1pjMHZzNWxZeExMS2hLRmJJYVNy?=
 =?utf-8?B?eW55QWF6UEhLaTFPY2o2Zkh2cjlqekJtdVNoVkdHcldMcnNwQitGSkF4ZmRq?=
 =?utf-8?B?ajZ6R1JORkFDeDdHMG0rbnVLcWQ3dFhQdTVZalA5b0N5cFRSRDhwUnU3NmxX?=
 =?utf-8?B?RjNxSEtPM05ySHdQNXJ1bW4ydnJwQWJKL1E4eC9qRzkvN2gwb0NZZ3MvUFJa?=
 =?utf-8?B?MFlJZEs2cno0M1RINFlOVUVsTnE4WDkwcDhVMEtNTVFObUhYQnRTKzN1VjJs?=
 =?utf-8?B?Wkgyd21FcEl4clZIQXM3dUJqT1NiNW9TL2FjdkU5MkxTVmhtVTFwS1JDV1d0?=
 =?utf-8?B?WTlXQkM1a1BuWjRnMkJvU3JVSnRzWHFMenRoL1BtNVpvK1k4K3JJZkdNTSts?=
 =?utf-8?B?eGZJMDgzTG1wM21yS1NBOUtZYm8wczllMmovZWY1cGxXWWRGaERRTWRjMUpM?=
 =?utf-8?B?ZEVrMDMyTjJ6SWVETzV0NTNDdE1Fa2trTzZ1OURxTWZKc3lDaDlUYkloWExq?=
 =?utf-8?B?bmZxOTUyeDMwWE9jVk1IQXcyZytFUVIzR1NuMnRBMjNkZVArWkxaWmNNbC82?=
 =?utf-8?B?UjlCcVVVSmpJenhsY1JTSCtBWk9SM3l4QWVERW51YU5NQ1E1L296RHRTaENv?=
 =?utf-8?B?MXRSM3lLVXkzR0ZGRWFML0tVU2JYZUJ0R0ZjaXhQWjUyZDJvOU5LdGtOczFq?=
 =?utf-8?B?WXNOQmdiK2NacWgybEdueVdMVHJMZGdscHY2VjFWQi9aNDVFQW1uajVIWDZB?=
 =?utf-8?B?eGw5d01PNTZiMFZFQ2NBU3k1VXkzTS9udkp1dlMwV3k0RVpzK3pRdFRBa2ts?=
 =?utf-8?B?SGdZenhlZEFONnAyUUZFSTRGTHpsd0hhM1RvbmEva1d4WC9WOXMwdTYvRTND?=
 =?utf-8?B?R1l4bnRhZjJReVc4bWhGZ2RLS3VJSjg4WE1tSm4zMHoxNU50WWVYSit5L2s5?=
 =?utf-8?B?N09zNDVzQkhXS0gvNVRTZkpFK1g5UFZHOHdySnJMb2l2bk5aaisrMUJSbWUv?=
 =?utf-8?B?TWx5Rkprc25IMkJueVFST2p6bU8wZWNrR1V1NHF0TWo1ZjJLQTdBSnBWNElt?=
 =?utf-8?B?a3JsdzU2dnBZSmhFY0hYdmNvSUl4Wk1BWlFDNUdGVktLeGFLR0MvbVU2bFNF?=
 =?utf-8?B?ZU5nU0RkbExIQ21YWXdvWVJaMnZ0cjVONVNEaW4wdkxDaDk3MnBYYjRHLzNX?=
 =?utf-8?Q?Fn9y68MogAFIDcI7b9qRRin7hpXiw0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUJjcXRsRm1pTEgrWFJTRXNURVFhdHhtV3dVc3hxREZPS1dWQ1cyNGtqd0xq?=
 =?utf-8?B?amtyNHVNNjdKZ1JpUHdNNVNlZ0V5OEI2ZVg0R3F6WE0yUHl6Y285ZUg2VHAv?=
 =?utf-8?B?TktGNS91Kzg3ZnhVaEtpWHI1NWlOdnkzVkxBT1V3QXl0NXBQRlp6dnVoZFRK?=
 =?utf-8?B?STI0cEJUSkhJN1pNWWJ5MWlYWHB0WVgydTFOYkJMTGRWc0dpMzVIckRkeE5Q?=
 =?utf-8?B?OVIvM2VYMXVXV3ZhbEk5WEI0bmp6Q1g2TGEveFZFMXdraHB5MTRqV08ySTBs?=
 =?utf-8?B?QWJVSUZJak5yUjlzRElCaTJaQnpxRjZHTTVJVmN2T3Z3N3daOE5NekNtYzRh?=
 =?utf-8?B?TElPY0QvR2c3ZVVaZWQwQ0tSQmNkaU9UWiswVWgzb1Fqa3A5SG1hQWExbUtY?=
 =?utf-8?B?UksyS0R3M1MrTFo1VUJEWWQzZDN5d2tEOHRxa29oL25IM3ZLQVNHYlJ1MDdu?=
 =?utf-8?B?YWpWYUJFTGZUcktweTJETW95UkZRUzlkbG1FK2JkMmZKaVRITmxIWkQvRkxh?=
 =?utf-8?B?YW9OS0xuSGo1UnZ5YmIwSlpJc1ZiYUF5bGZaODlmQkJrdk5vMTFkUmpldzRn?=
 =?utf-8?B?dEhLR2YrTjFuTG0rNndhc0k0THNkckZRS1Z5ZGszWU5PVU4vdW9QOGxBcmFj?=
 =?utf-8?B?bUZpTGpDNjZOM3Z0UzNrSGFLL2tXZk1nWW4zM2x0VlA3QnlDNXUxWXhIQ0VQ?=
 =?utf-8?B?c0kreXE5cmRMajVleW5wT0pkS1BvNEJxUndwV25VSHM1RFJzSllJbkphQ3I5?=
 =?utf-8?B?WWxKYk9lU01RUVlLTVpiVWV5NnZlWlF1cStNU2ZVMVJudkZkQVBFQU5vNlRz?=
 =?utf-8?B?ZnlHeDNJbkMvZkRxOC9lU0hnNGN1YjQydTNVUWFwVldiU2xwNXc4K1NBVERI?=
 =?utf-8?B?N2MybFBuYnJNZGpncU5jd1VUMGdhUDlybXljdDZRVndSdzd4cS9zMTROY2Ju?=
 =?utf-8?B?ODVjTlBCUUVtYzlFUTZtOCtVMmtyMFpjUFVvL3RLa1BsemV2cXREYTlCYlVl?=
 =?utf-8?B?bmRnY0JueGZhVGdhUHVmejkwV3RLcVFXOEl1WDhTajZ6b1hIRWNVenJLdk5G?=
 =?utf-8?B?YU5iL0t3cG9Wb3BCQkJwU215MElOMkc1Z1BhZVBMcHBOeTdiTW85bWpwSUlh?=
 =?utf-8?B?MnlZTklqdDF0aE1ITnBMUlJvY2pNc3ptLzJiTGl0QS8xTFhIdkNIN0RDUmFt?=
 =?utf-8?B?c2djQ3NZeGxyajcva2thd2lhdjViUDAzZVFwdGIyRnlXcmkrZUZDcmJjVU1i?=
 =?utf-8?B?ZUU2MENWTGNVUkdaU2s2dVJDUlpINmtuVHBrazVWbGw4bk8xalUyLzV6MGhF?=
 =?utf-8?B?VWI0djRFakFHMk9INzNPd0diakJycS9FU1ZCbHJJN2FQRzgway93YXVqaktN?=
 =?utf-8?B?YWI1SytlaUpNNDRBaWd5Z3VpdGsxWG9pbC9hV1ZQSURLZU16VXU3YjdxV1pn?=
 =?utf-8?B?SmVKYmhUNkkzKzYwWlBESkhIclZRMkVRQ0Z3ZDFGdUNzRkFQRkZ5dVdvRnhl?=
 =?utf-8?B?NnFLei9PeG1HL1dqTjZnT2RRcEZibXpNaEJqMG9ka2NqS3AyakZ4RnB4U1hW?=
 =?utf-8?B?RzlBNU1DUk1IQWF5dThXS1NxVTZmeXVwQXJmd2ZRcFo1S2NFY2JDRGp4WTVo?=
 =?utf-8?B?Vm5pWkFGYUJZZEFsenlNWG95SWFadlVQZkNMMW0waHV1bmpPUUhBZGVVcGxz?=
 =?utf-8?B?M1pYcmNHRFdYNG1jNzU3QW1pWVBMaFYwU0JyMTUrdXlOSlZVSDlmRHRMTTRD?=
 =?utf-8?B?akc4bTF0NE1hS0J5c0pqM05lZTRPdW1wOEQzdkVPTFZTekFvdEg3bUVER1Zo?=
 =?utf-8?B?eFRmMy9PY0NFWTZxQ0I5YXlRNlBZdVUyMk5EV1pTbmdWMkVoNjVacEZHSFlr?=
 =?utf-8?B?Rmk4MytxZGc3UzcrWWg5WUg2dzhIVjZKRm16Q05LanlMSS9Id3NqYTJ4RXBm?=
 =?utf-8?B?YS9CV0R6cEJvYmVoSmFXczg4S0hMR0xTZC9SVkV6a2MvcVdUSUt0Y3lqKzc4?=
 =?utf-8?B?cDh4Y0Uzd2RSRUZ2aXhhOTQxS2I3cnVaOFNIeWFxMXg5SWxLNEEyWEhTSnJm?=
 =?utf-8?B?bEluSGN4Z3ROYWFjdHNaUCtPaUUwMllqYytTbVAySFFXWWZSK3U1eEh1UzRI?=
 =?utf-8?B?VzRvck5DQ3JOcVUvcllrbFJpTEEyb0tNcG1zNmVId0tNVkhZajY4bTBJdVoy?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEABD03D90D7B54BA11E0B4125555EA4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1ad228-b66c-4a1f-4f30-08dd8e9f634b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 02:15:37.2686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IpYEfmpjGynQmv5ZoN602kZffVPvhRLly6lVii4loqKFZwhFJnuWTCDWgEQ0xMVcniIWQh1GSgSzAC3SeKvYWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8611

T24gVGh1LCAyMDI1LTA1LTA4IGF0IDA4OjIwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDUvOC8yNSAyOjE4IEFNLCBwZXRlci53YW5nQG1lZGlh
dGVrLmNvbcKgd3JvdGU6DQo+ID4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20+DQo+IA0KPiBQYXRjaCBkZXNjcmlwdGlvbnMsIGluY2x1ZGluZyB0aGUgc3ViamVjdCwg
c2hvdWxkIHVzZSB0aGUgaW1wZXJhdGl2ZQ0KPiBtb29kLiBBbnl3YXk6DQo+IA0KPiBSZXZpZXdl
ZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNCg0KSGkgQmFydCwN
Cg0KT2theSwgSSB3aWxsIHVzZSB0aGUgaW1wZXJhdGl2ZSBtb29kIGZvciBwYXRjaCBkZXNjcmlw
dGlvbnMuIA0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQpQZXRlcg0K
