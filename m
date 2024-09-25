Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0A01B85D5
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 05:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727241559; cv=fail; b=nVYMQZkty5qJmEyeHhcYMXOXneHy5k2vNQ0keClci+ZAv/bwf0L5+cMwxr6Cl/JoeNMg88Tj/9t9IZayMk886ffhAW0nHdpAYSqMGOANxjiT36VRZcHHM83aqyfj4PuNhDF2drbhz5/QpQj/PmwHbIay7k3UffkmctaTw/IxRaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727241559; c=relaxed/simple;
	bh=yGvAlvzsc0g7XbqA9MX5JzQFPkJs+RHu6p4lOhT+ldc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dZXXr9/p5enraMOQaQPRU/kTo501vZLEjfu2ov1kHmSD4vrX8zYDosLHbZLih+OePMUV7F5rpdHsyIFL9k+2SaQXe5hnaNzB96RK5Noj1HMvbh6mH/EsV0yij4dSuNX4oZEmpZZBn2E0MZjB33ix+AKMAAnUnhN4wN7QP73/fzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AdtTypr0; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=G9tQQXrh; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AdtTypr0";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="G9tQQXrh"
X-UUID: b40d205a7afd11efb66947d174671e26-20240925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yGvAlvzsc0g7XbqA9MX5JzQFPkJs+RHu6p4lOhT+ldc=;
	b=AdtTypr0JJ1Bv/Jr1hAq4CFoqYLoIqUGeflptqGE5GqaMn7aySfkE4g/GVeEAjQyiQVu4jTHaawrhl4IX6l28TeXtGTqifE6fap1eQjyJC5Bd+sZMr4ekm8yHAvlpXNI1J6dWuYwsJq9YR1sougTwvs9babCg0+xwPdSd393azw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:04e380b5-6d6a-45a3-83a8-5e6872c4d75f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:0bf13618-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b40d205a7afd11efb66947d174671e26-20240925
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 615517591; Wed, 25 Sep 2024 13:19:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 25 Sep 2024 13:19:10 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 25 Sep 2024 13:19:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWcpkuGeb1PimZrMwFX74Slz7wClmLJ0nICnzLzT9pVRnv0zsorppfAJGcLScvYQ+7O52bio05PXOuMWu8JG13Lzr565xeJzuDaok9WG4KJ2tpTe22NgGr4TwywTKdnBlxYM0uuC10J1rwbC19IDxRmsPJagBbEirL/tlpl2LMdgcX7P1whnf+sDXfed99YOnXt9Zpek0AQI+Qyn6Vbl5CyuGsKcBqz6+JReqSjMyPCOHP6YXxK2FmmyZIP+rygpKAUcvzVXXNyS9j33BjUobnnxGLJwOYBfIJFn9rCjS/oxLgkHkUfvvemPaUmuybmz1I1viWfFVPfo15+86WhgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGvAlvzsc0g7XbqA9MX5JzQFPkJs+RHu6p4lOhT+ldc=;
 b=J7FARK9XDatJgjAtFjtROpj+PqCqSvo5QpLOCLFFCZGKm8Tz+x9ItMuCHVMqGJLwLU5ecfTMxfFWkHebdP6dWfRsstrE6bV+HoDgdB5/0CS0EOVXJ+B8RGKqHx0B/B1Rk2e+RsbSrbu1A5dZLWGQMU6shYVm277X/jDSpct3LJZjEIITvA29k55YbESfvOesNTx3AMTtkLE2U15BTUl9Wqeje8D0sR80bMM3jW13Xu59pxmzA0+GZY5ZLhyCZiZ5XCYE6wUOS4/L7SwJzLQxayoH20ICGGLujksHPFjA3gq13wVQPiuwTRPuS4yEgs9nu92WV1eJljbrPWqI0c+5fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGvAlvzsc0g7XbqA9MX5JzQFPkJs+RHu6p4lOhT+ldc=;
 b=G9tQQXrh8BxxPyYS4ZxVzp4BnQlDJyGIVwniNCcwjoTZLfaVev8wbE1MO4Y2YiLLWHf4cvSo8kXpiQgaSc8r67jH7UTfCslkHkSAVoccJtkEyCo2+MKKSnklDa87mb/uLBwAGb0TOtVw94OWgXf3gaPofInrpl65AoEy9GEGA08=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6477.apcprd03.prod.outlook.com (2603:1096:4:1c4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Wed, 25 Sep
 2024 05:19:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 05:19:06 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Topic: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Index: AQHbDY8/Q5BIR9JF0U2fs4d8wWNPObJlrgQAgAD0qYCAALRhgIAAorUA
Date: Wed, 25 Sep 2024 05:19:06 +0000
Message-ID: <cd94ff09e36c921f5725c6e7b36ea743a2f6b872.camel@mediatek.com>
References: <20240923080344.19084-1-peter.wang@mediatek.com>
	 <20240923080344.19084-4-peter.wang@mediatek.com>
	 <ce42d310-2a23-453f-bd14-71eeaf9f5664@acm.org>
	 <e0cb5defb8894ea8fb058c617e9de3d3cfa9763f.camel@mediatek.com>
	 <fb02d4c2-bb0b-4d26-8d6c-f76f309679a1@acm.org>
In-Reply-To: <fb02d4c2-bb0b-4d26-8d6c-f76f309679a1@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6477:EE_
x-ms-office365-filtering-correlation-id: 3c050ce2-2b92-418e-e1f8-08dcdd21941f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QWRSWVQ1dGF0bzVSYkhOc1dOS0lEdy9veGZHOCtTemM2TitSTGdPYlNFVFVq?=
 =?utf-8?B?WFpNaFFEUEVqOUg2V1VqdStYS1NIbElGK21GS3p4SkdVUmQ0SmNOd1VpR3FN?=
 =?utf-8?B?UlU2bTdSZ0UxYnlOK0pNZ1RTRitGc0NNYkpuM0UyaXZtT1JkZnUySE0zdWZz?=
 =?utf-8?B?eGVHNTFzL3VNZ3ZpdHZvdnQ2cG5TZEYxdXZHNWZtelVOVVQ3OHBuMnZwUENE?=
 =?utf-8?B?RGtIZ0xZaCtlSzkyWlFGcW5UQytkUkQ3WGF4eU1MMnlOd1hpWlpnSlhxU3hZ?=
 =?utf-8?B?bm91R3ZGVkxEZU9DSnczK2lmY0prS1ZxcnlJOFFZTkx4a3ZhanVDNnFXU2E5?=
 =?utf-8?B?bEYxcnphY0krQ3c0ZjJqRUkwbFhlT3J5dFRUQmFUSUVBZjhkZ1cyaCszRFFr?=
 =?utf-8?B?eTBtczEyYkhmUUpaUWFDeE5LbDd6dk9LNldaT21Ic2libGJIS3dadC9GOGlx?=
 =?utf-8?B?QmptVXVaWUF6dEY1bXNtQ091dGMzU3VJVUU1ZHhDK3N2bWQ5bEdla3h3L1JS?=
 =?utf-8?B?SzBkOG1NTDYrelFHK1FGQkVMZGNENTBUY1BLbklibjY5M2lpREQrTGFqT0hu?=
 =?utf-8?B?VnZoU1h3U2FwbHRIQVlHRVV5bDdna3VPUm9FQzF6ckVZZFNNems5dStGaVlO?=
 =?utf-8?B?RWprQVAwRUhvQVYwbUE3MU43T2c2Z0o4WFV1cnY3RW16VzRDUDdPRklEUUxR?=
 =?utf-8?B?WTRwc2dEVUdXcXFGWWc4aWx5YldEd0h4R0Eyc0hKNzJReXdDS0pqVmg4NXZT?=
 =?utf-8?B?TERQQXBFTEh1NkNxNkFBV2U4MzBSNi90WDVUVmVCbXpoMlg4Rk45SitlY0Ru?=
 =?utf-8?B?MWRpb0Z5R3ZGcFQ1R1JUaUpvb2R2ZTVjUUl2Z3ZoVWVEWXFyVWxQWjZScytM?=
 =?utf-8?B?djliQTloZUtwc2U1U2t2MUljbnVFZDJycnhwTjBSWGxaMnA2aGZnUkxoeGI4?=
 =?utf-8?B?L1IwaGNSUFltU1luQU1OaHI3MTA2NWcrcC9Hekpld0JvcVd1UE1HVjY0RjIw?=
 =?utf-8?B?aHI4aVZOU3ZvcG5HR1JuNTZxWGNCdmJlbTRQZUJ6TWUxVlRHbmd6a1pPc0RX?=
 =?utf-8?B?NVhXNkJvOVo5YTk0cmJVRndYSDZiVjd1QXVwbDQzdm9YTzZmUUxodEkrbW91?=
 =?utf-8?B?K1EzaXdBWjErdWdoaWd5b28xbURodW5oNHNvYmJzUmZUaWZQS0crZE9UZndI?=
 =?utf-8?B?TW5rT3JLSHAxbVNFVER4dk0vYy9DRGZyMzhMVzhDdW9iS3dpN3hDN2JOVVlJ?=
 =?utf-8?B?SGIveXVlYWFXMWNpNHZjaVJ6SnEvaGNVbFdBL2g0OXZDa09yZnZ6cHMwdE5l?=
 =?utf-8?B?R3dDTlF6RTVxUDFFSEtDZUVUc3VNY0htRUUzK1VQam14ZFIrT2gxVVVHTUY3?=
 =?utf-8?B?ZU5WK2xOcTFqTURiMmZySmZkZ0pXUDd3VnZhMkxOc0xLdHVMU2RNNU9kUkRM?=
 =?utf-8?B?QW1aS0l1OW9nTTE2dHlhSEFCTG45eno2a1oyTTZNZkZVb1NadkR5SGxWQkZJ?=
 =?utf-8?B?dTE4RXk4d2FMR3A1R1kyYnU5MEU2Q1NPQnBiWDg3RnlsRW9CWTlVQkxBTnZP?=
 =?utf-8?B?dnZPYjFNK3ZJVnEvdGM3TklUSzVDdStGcFVBWllWdWgrTTJVVDRpQXJ2STJJ?=
 =?utf-8?B?bm1kYi9KUGNvQ2FjZC9jZWd1SWxFQUY3V0ZzUmpHcVhEQlZxWXZpT2c1WUk2?=
 =?utf-8?B?bjExaE9GWGIwcyttTFVjQUsrTzRlZ3plUTJuaDJtcWI1dzh4RXdvZWttMTU5?=
 =?utf-8?B?NE5aMCtrZjNtSkx2SDRtSVNQSDZKaEp6VVlGSzQ0UWpMc2ZnQjU0T29WbDR5?=
 =?utf-8?B?UktDd0pYbVJlL1NYZVQrZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1ZsSitBMk1sc1hoMkYyeERucXhQZThUNFYvb2N2cVpqQ3BlNERXVzV4M0tx?=
 =?utf-8?B?ZG5YamdpQXF3NzZ2K0xRRzRTcFkxMXpnS1lmb0hycWVGdFhHZW11LzhoL0x0?=
 =?utf-8?B?WWNLN1U4YUttcnNja2Z3UWdGMmpSejNRTUMzVmJZbUpLR2tneFhKQ05ibERO?=
 =?utf-8?B?Y2dJYkJzODN6OVdvOFMweWt5ZjJSd0w5a0RRTnIyMG5qcmhKVktTaStIMXZ6?=
 =?utf-8?B?MS9rRGZ6dFdwRmZGOXp2RjFWMlc3eTlrelZ2U2dHWFJxUWJ6ajNXaGVvR1FF?=
 =?utf-8?B?MkhiMFh3UEovREhaOFZVRUc0VWxob1VaWW50NUpLZXdqaVk2TkJndEIxT2tE?=
 =?utf-8?B?OFIyWDJ4U05OMWthUmI1bGZNVFB6TmRDYitSazFIYVVQUEpSU1lwNWx0d3Vy?=
 =?utf-8?B?dHRiRllCU2VicG1pY1VKdzlyVnpWb1VYRjkyd2VlSmpoMGdXNGJTUWlQeWN5?=
 =?utf-8?B?ajdMNEJJM3ZuRVlHTytjSW5hNC9oLys5M2pablRsZk1sY291dkRNcjBta0RW?=
 =?utf-8?B?d0loVUVQaFE2SCtvMmUwZUQ4WDQrZkJqYkRHQmVGR2JRV1ZQamZFRlJ4UDJC?=
 =?utf-8?B?KzBZbVV5RE9CU2U4a3dtUGNqQStBR25TUFBQMjc1WnMwZ2IrNER2MFNrRHh2?=
 =?utf-8?B?cXNHMG1KaS94aXQ2QzZnVUFhdzZLNHJRMU1ZQTRVclRPcGRhcW1VR040S3pK?=
 =?utf-8?B?NktSWkxlY1Fra1BoRFFVOElmNHN1Y2tWUVY0MXo3emVyd2lZOFdTN1ZVQ1pV?=
 =?utf-8?B?c21qaHB6TEhvb2ExRmFzRE80enZ6UXdpaGNpWWtORUJDMWttdkFaYWhNWUVi?=
 =?utf-8?B?djQrNWYrczBKbXdyTWRyRUVtdXlUTDNJN1dhOURNUnhZWW5vSVlESUVtazVS?=
 =?utf-8?B?OGI5dmZPWkFmNklXYnUyMmluWUxXZVNhcnRSQjNXVktMakxEdGZuZCtsQnh1?=
 =?utf-8?B?elZ2OXBjd0tTZXk4Q1E2K0JiTlROWUhxd055VUFlVWZ3NWNjc01kdlowa3N4?=
 =?utf-8?B?bUVSR3pnYmQyOHFYZGF6L3VLem4reG9lZjFpckVYVkVpK3crUUQ0bC9yN2dQ?=
 =?utf-8?B?SllUZXM4aU5TRldNNVZPNFZlZlZPcU1vekQ0S2lScktIYmFKOXl0dGEyTEVM?=
 =?utf-8?B?NGdPR2hENGU1RGNSU3h1d3RrU25JUVIvc0g0K2NjS1FYTFoybEE2RjR5cjlT?=
 =?utf-8?B?RGIwbXc3VkdhbWNucmxqSlNvbDE4NEo4Wm9sRWRaYVNoY0NrTXp2WXh4MjBy?=
 =?utf-8?B?VW1oZ2VuUS90ZjRhMmtIdVNhTEI3UHFGZWQxZUZNVzg2cW5hT0dhTlVPQjMz?=
 =?utf-8?B?ZjJmb0tVZWkwdUxJZkw2REZSREhMR0tnSmFzby9QbFFlVWwxYmRCVVlVMEJD?=
 =?utf-8?B?YU9RaXgyV2xGb3VGQUJUNDhPRTBKOW9PMFdlZWNsTUVNR2dFUjhYZHRFaUg0?=
 =?utf-8?B?SmRONmJTMHA1S01zbkZJc0UyZXZDT1ZobEExeVNNTDQvRDFJajV6TDMwelpn?=
 =?utf-8?B?ZjlRZm56RGxnZGVhTE9ib2xOYk5tZDA5UWgwNDhkaGFxWjBuMlhGdmRLSU9O?=
 =?utf-8?B?Vll1ZXg3VzNQL29BZmEwRXZBTzhvUTJrN2U5Tkl0NjU5NlQyOFpmSTE4clNn?=
 =?utf-8?B?N0EwRkY1YlJWUlBsaEthQ0ZuSk9VV1BVSEw1Q2tRZjlsQ0dQUmt2bVBUQnh0?=
 =?utf-8?B?dmNpTGt3eDBCWm8vMHVHODMrWGpLTFpYWHg0ZTYwZExocUFqcmNlTnJxN21r?=
 =?utf-8?B?VFdub1V5Z25NTVdXaWRXRVp5bFY1WXdZcUtncytUTTVJejhSaUZQZmlwUGJ4?=
 =?utf-8?B?RUxNUGxTSWMzclR1QkZlRmRQenhWN0RYcGxybE1qSmJ5akNkdllwNENBNXVQ?=
 =?utf-8?B?d011cm5GSFlGbkNBaU9McEpMdUtnaGNsYmxvc2dGWlRuMndab0tMUW9LZnJq?=
 =?utf-8?B?K3lScldhS3ZWbTljdVk2TXpDUGEzZ05LRVQwY21USTFnMWJyL3QzRWRZREt5?=
 =?utf-8?B?OHBvZkVVRlJkMnlXZTJIazBUNzkyVGIrZ1pTTk9FQ0tWai9NVHdkYlJOeW9w?=
 =?utf-8?B?aGc0dDNFZ1VsVVFlTVEyR3ZxaHFRcEdZdFlFcTRNMFkxUU1PMnQ0WnZINUdT?=
 =?utf-8?B?cGRvOHZSZWYyMHVVSE5ySHh1d2xBZFcxUElkdGthTmNKWnZMT3d4VWwwUlla?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9434333C7E3B84991E244EEC1816B46@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c050ce2-2b92-418e-e1f8-08dcdd21941f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2024 05:19:06.8164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlfHasVcJ6Qyxjjv+fPa7b7kl9wcFBSQyEp4Q+D68HJHHaChizy4Oy4Zy2KYRRrHCP3/DZsujB3IwvcwhW92Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6477
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--21.835600-8.000000
X-TMASE-MatchedRID: Q8pJWSpPf0PUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTWXO
	j3NIpqIqkL29G7tapIH1jjvok3ObGL8FtBODBllSOFfLQqF6P0rdO/3LnRgJ7Y8r/ndGdDsUOev
	AL5im/ajxYJr3lLWMkqlf+sx/kw32+3Nh8swsKKkKcYi5Qw/RVGQEVrMR8yHMY0A95tjAn+yvd+
	2hXReVzmSG5dofH8oMGEC0uDOekzA5xGkgZNT4QngIgpj8eDcDBa6VG2+9jFNZE3xJMmmXc+gtH
	j7OwNO0RTWyDkald5Q==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.835600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	313E2D2D3248FC4C2E4CC964BD601FD25D4EB780B13EB4A8E94C03CB4322DC112000:8
X-MTK: N

T24gVHVlLCAyMDI0LTA5LTI0IGF0IDEyOjM2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yNC8yNCAxOjUxIEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IElzIHRoZXJlIGFueSBjb3JuZXIgY2FzZSB0aGF0IEkgbWlnaHQgaGF2
ZSBvdmVybG9va2VkPw0KPiANCj4gTWF5YmUgSSBtaXN1bmRlcnN0b29kIGhvdyBNZWRpYVRlayBj
b250cm9sbGVycyB3b3JrLiBBbnl3YXksIGlmIGENCj4gTWVkaWFUZWsgY29udHJvbGxlciByZXBv
cnRzIHRoZSBjb21wbGV0aW9uIHN0YXR1cyBPQ1NfQUJPUlRFRCwgaXMNCj4gdGhlcmUgYW55IGNo
YW5jZSB0aGF0IHRoaXMgc3RhdHVzIHdpbGwgYmUgcmVwb3J0ZWQgYWZ0ZXINCj4gdWZzaGNkX3Jl
bGVhc2Vfc2NzaV9jbWQoKSBoYXMgYmVlbiBjYWxsZWQ/IElzIHRoZXJlIGFueSBjaGFuY2UgdGhh
dA0KPiB0aGUgY29udHJvbGxlciB3cml0aW5nIE9DU19BQk9SVEVEIGludG8gdGhlIHN0YXR1cyBm
aWVsZCB3aWxsIHJhY2UNCj4gd2l0aCB0aGUgaG9zdCBzb2Z0d2FyZSBvdmVyd3JpdGluZyB0aGF0
IHN0YXR1cyBmaWVsZCB3aGlsZSBzdWJtaXR0aW5nDQo+IGEgbmV3IGNvbW1hbmQ/DQo+IA0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiANCg0KDQpIaSBCYXJ0LA0KDQpPa2F5LCBJIG1heSBub3Qg
aGF2ZSBjbGVhcmx5IGV4cGxhaW5lZCB0aGUgYmVoYXZpb3Igb2YgdGhlIA0KTWVkaWFUZWsgVUZT
IGNvbnRyb2xsZXIuDQoNCkluIHRoZSBVRlNIQ0kgc3BlY2lmaWNhdGlvbiwgdW5kZXIgdGhlIGRl
c2NyaXB0aW9uIG9mIFVUUkxDTFIuDQpBZnRlciB3cml0aW5nIHRvIFVUUkxDTFIsIHdoZW4gVVRS
TERCUiBpcyBjbGVhcmVkIHRvIDAsDQp0aGUgTWVkaWFUZWsgVUZTIGNvbnRyb2xsZXIgd2lsbCBz
aW11bHRhbmVvdXNseSBjaGFuZ2UgdGhlIA0KT0NTIHRvIEFCT1JURUQuIFNvLCBPQ1M6IEFCT1JU
RUQgaXMgZmlsbGVkIGF0IHRoZSBtb21lbnQgDQp3aGVuIHVmc2hjZF9jbGVhcl9jbWQgc3VjY2Vz
c2Z1bGx5IHdhaXRzIGZvciBEQlIgdG8gY2xlYXIuIA0KVGhhdCdzIHdoeSBJIHdyb3RlIGl0IGxp
a2UgdGhpczogDQp1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSAvLyB0cmlnZ2VycyBNZWRpYVRl
ayBjb250cm9sbGVyIHRvIGZpbGwgT0NTOg0KQUJPUlRFRA0KDQpUaGVyZWZvcmUsIHRoZSBzdGF0
dXMgc2hvdWxkIGFscmVhZHkgYmUgQUJPUlRFRCBiZWZvcmUgDQp1ZnNoY2RfcmVsZWFzZV9zY3Np
X2NtZCwgc28gdGhlcmUgc2hvdWxkbid0IGJlIGEgcmFjaW5nIGlzc3VlLg0KDQpUaGFua3MuDQpQ
ZXRlcg0K
