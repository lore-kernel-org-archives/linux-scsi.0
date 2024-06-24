Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA89130A66
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2024 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719219269; cv=fail; b=nIyhDQNR18WGOZPmSk+OmB8uWvNv5cmadZDIxPYNLynP3gMeSCAbKeHZ6sTv3ggz/o6Ml4qzGXrwIxbL7IyeGI42n6Ymqsrvkas8bZFbxs7XNImcDsSxCvoC7mOS+dXr2ftGroJSZPLD0t0uUoUn0TgfBwcOTJLDELscgYKQcTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719219269; c=relaxed/simple;
	bh=si28DouvFb1oWD7wPKHncu+IBDj95WwrS8hwYEU8978=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EhVpoiJeF4KdmD0sXmCHFCxCtzw8/RoBqgjTdPedfOVrU69Uv74Z13GvOelSZioZlMFj3wbWFFKs9KjRXx/gWz4paI6tkDb466hVuqEpWyFGrdTB6pY1sfXEb4/Y9y+tdo/dC9C32ITUC8YYYgBqiOJXAUltd0+/9aGvQGyaO9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bHe1as/L; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fvSqhWIe; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bHe1as/L";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fvSqhWIe"
X-UUID: 56c4392c320711ef99dc3f8fac2c3230-20240624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=si28DouvFb1oWD7wPKHncu+IBDj95WwrS8hwYEU8978=;
	b=bHe1as/LiS2PtPN9ICnWJRVVrsqyIlz63p2Gz/zpInu5W6kvSb6ofTiNnzSWs7ruQfi+dDDqo5GbzFhMAp2iZyUQFjK0/Q6a/1+mISCsi2OzSHtM+/vg7RGJN3eQwbVyijpKaahr92t29VyHIcW0EQKua0tCRy+fNc4ljcZsK1Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:6d09e454-6d11-4349-82b8-12d7d1b1c359,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:0a9c5c94-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 56c4392c320711ef99dc3f8fac2c3230-20240624
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1316345706; Mon, 24 Jun 2024 16:54:17 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Jun 2024 16:54:15 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 24 Jun 2024 16:54:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nmyup3knANPVLa4bcTH9DsvJ1AFvkdDMDE88xYQPlOxiNNghCrVsOSIllKpesOq1sPA0sDtvYKcM8qt4bWSAVDyYuMLPtCBuGFxkCPO0rKx8zgKT8Cao1WqwbPiGsJ1QwVLaBbwt0Xjx+w6UZOUOog3m1C31GKsv7YhNVckrfiI0mH6hiQjHBSRNCZycHbVrBzZdjEeaBtiAFSXRQXl0zsumibuNNENfeVA0zwQQ+0r38pftZdYnmD8dWxkin9Jv9yDlXgCkYDvgM8mLASn7vSryK66soDkH4uuGKCdwApMaXmc+IVuYfn2twXskVcxtHqCt0KJaU/t0k4B4C9sgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=si28DouvFb1oWD7wPKHncu+IBDj95WwrS8hwYEU8978=;
 b=fVuDLy0foYD3d8hWJ0EJrYfvD+5a650TB61jsC/h+NswAuRDZY7UApXeiGPDyn/NLEGs9Z3g3uiIBKn6G6fP07SyP3LD8CoBdPwiuvGKenm2EIXAEf2MVgaHV0zLM8DGlEM/cmxd5X9FTy4yGqJ/ofBBQp6ro0v99K8z6CF4O1GE1yCRIRZi4nu3TZD0P6+3zdFMgVw/rARc8N3C/nXOoya4RuGAJJg+5bqDxN0Ff2eHW+Fkk5Z0ustYKhvjawS0xws2sibGMfzJK/Bg66GS71t0YJViJQglNxBILpGPTiQGCo77eMYdqZlkzBbglA3xICk7aoq5R2wJ2Myj1mL4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=si28DouvFb1oWD7wPKHncu+IBDj95WwrS8hwYEU8978=;
 b=fvSqhWIecm7sr12y/Mhsy6cAu0LUVb2VwLt/Qm37Ah4SSQuTCr62cXIuXQzyTwQxTpBnqRAIlKyw93pnJ8KDahyTbvaO2BYIKCxJfECkf92Sc3fvio/42JtbErMyIFlPMg3grqR1cZR0PwDgvdQ6o2egNxYC0FkGZgPHp/2pPNc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8539.apcprd03.prod.outlook.com (2603:1096:101:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.25; Mon, 24 Jun
 2024 08:54:13 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 08:54:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 8/8] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHawPrEvEtR2PxEBkyAfPJ3MA8LCbHRzdSAgACvsACABCixAA==
Date: Mon, 24 Jun 2024 08:54:13 +0000
Message-ID: <d6d329a3d822cb34c8a5bee36403c59ceab015a0.camel@mediatek.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
	 <20240617210844.337476-9-bvanassche@acm.org>
	 <054eef8dec43e51aec02997ad3573250b357bee2.camel@mediatek.com>
	 <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
In-Reply-To: <1f7dc4e4-2e8f-4a2e-afbb-8dad52a19a41@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8539:EE_
x-ms-office365-filtering-correlation-id: 9130d23a-eda9-4ea9-44e4-08dc942b38e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|376011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?MlVSY3B0UUpmOXdUTmZibGdLWFd1cFhOeTQ2dUh2UW5tSlVDVWJLZCtZbnh6?=
 =?utf-8?B?eWFpcGNvTVVjeVRZd0lNNkVrU005WUs2d2hZZ1VWYWExR1ZzLzByS1plTE56?=
 =?utf-8?B?U3ovSWsva2JUenBOMEZtazN6NmFLc0krcUJEdmpEVktrK0RLR2VrUm1mV08r?=
 =?utf-8?B?cTQ4NWRoOXdJbFgrZ0lEcEhyNzd5ajFuNjlLWlF5T2pRdXdFN3l1dWxDTFh0?=
 =?utf-8?B?NzJxSXdoK2RIY1NFeTdMTnlqWmFWaFo4S2VJd1R4c3J4cjB5a0tBUGdlWTRU?=
 =?utf-8?B?MnJEbmlaOVdhb2ZZODF0NzJiWWJuN25DaUFGNTZkZWVjWDdDVHM5OTA3eDZk?=
 =?utf-8?B?djJLVGIxejJ5YVg2cE9RdXdZSXhqeU9Mb2NaWlgybC92Z05wdW15WHVka0Vr?=
 =?utf-8?B?azJla2xGdjVDaktHMVVEaFlEZXBYSWd0VjJLdUR2OUVPaGJhTkF5Wjc2WWtF?=
 =?utf-8?B?dklCbzVuUm1JTG9qYW1sUGRYZmp2djY1V2dZQll4b0sxV3BNQVB4UjNacmxi?=
 =?utf-8?B?YmwrSEpDNkpCWVFjdW5NUnJJV2xMZU1YMGY5T0RGdUVUMVlIeXA4Nm9Bd2R5?=
 =?utf-8?B?QVFBb3hSUlcvblNkZ3pNbXhGa2pGSHhMTFhDc29scVJ1am5HWlZiQVgwWGN1?=
 =?utf-8?B?QjFTd3grdlJEL3hGWUtKVG1PZkJCbzROWVdWYjlTdUxFRCtDSGVVNVdla28w?=
 =?utf-8?B?amZrT3lwMmhtTjJoNFhFWkdPOVFEL3owOFJ1RDVrZzZncHlBZjJMYVRSOHdC?=
 =?utf-8?B?bTBMc0hWVmU4NHdvQVRqbDB6Wm82WW9JMHNxekJhcjVERlA0Y2xibnJQNjhL?=
 =?utf-8?B?VlN5eFRWUUw4RkFVQnFoWk9iWUgzTThOSnJJS0U5a0VRMk8vMFJuZElaUS9Y?=
 =?utf-8?B?N0lEZWo4Z3ZGek9aK2lKdmgxM0RrS1BtSnRNdXl6RjJIK1dYUjRyVXZ0S09w?=
 =?utf-8?B?SDErbjdaaGN4amcyZkdIRzFtTnd6c0tvM0lhdkxtdUZLSGpQNGowamtaQzl0?=
 =?utf-8?B?SVl4U1RPdFZIUFJXNlJZZDZEQWRTczcxM0Q4d2VBZklpN1pzSDltYzVFbHNp?=
 =?utf-8?B?Z29sQ1VPU0JibUVJSHNXWlRvVWFSSXg4WUlZY2dmbHQ0Z0UyaDZpVWVXcWNX?=
 =?utf-8?B?NW8zcEI1a0k3WlFVUEZFVU1PeEFxMS8yNk9mcDczRVpIbjNkZGdISGNNV0RL?=
 =?utf-8?B?ekIxR1hoa2NVc0dYL3V2dVBIaFhCOW1TWXYrKy9tVHBmNGtma0tLK2tnMVJW?=
 =?utf-8?B?S1E3YjBLRXk4bU5BazhpeGpqQjdSR0dPUldPS1JPOGZKcVRGZnJBQ0RSaCtG?=
 =?utf-8?B?SlFvdnhqV1kwYXBqd0V1T3RQcllDTmQ1SUdIR2NNRS9Nam1Da0VETS9WenpW?=
 =?utf-8?B?eHF4Q3pMaUQ0S3pzTjE4cW5WbWZXaTZUV1VwUFlPV3lwQ0VLNmhaVnN0QVFD?=
 =?utf-8?B?ZXcrT3NnTXArKzV2cDQ4VmxCTlBUUWdDZ1pnM0Zma2JBRGZQdXpSZSs5dTRu?=
 =?utf-8?B?ZTduRjkveXl4K1R5V09LT2tNWEtsbXMrZldJL1NSTHBmVHdzOVYzMUFpZzFG?=
 =?utf-8?B?czRqWlNWQ2tIckh5Um1Sb09mbkx0L2VxSXI2cnZYMzhPd2VkRzNKQWdIVDFB?=
 =?utf-8?B?TnJEZkpsRUJGRkJVRHpCam9EV1JMd1ViKzFHSXpUbU02ZmZGbzBpdE5DZkoy?=
 =?utf-8?B?d3kxSDBhMmd3S2RyTTdwaHYvcThvaWVUNG1YbzdZNy84RFgxeVdKZFVybE1P?=
 =?utf-8?B?ZGo4a0R4K21IdGVGNTg1V2Z5czF5VDNaU2RTM2FWQlBEWUpuNHh6eDBjNjVX?=
 =?utf-8?Q?DRKx4NXUC1HQzocO6nzH9rqYA9vPP0PdHA5Fs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjhCbGhVTHVjQ3R5R1lDTGhZYmU2NVpTVTk2bm1od3ErQXNJYTgzMEVoeTFU?=
 =?utf-8?B?WFN6M2NEek8xMzlLaW45RXZhcGZMbEgxSTNWUmcyVko4SVZSTWk1NmtDQ2dw?=
 =?utf-8?B?QUFWZE1kYlZMb0RYbW10Qkc4SUp5WVY3ZEN2ckZmeEJsam5ZUW1uYVRPc0tL?=
 =?utf-8?B?ekYrMml3WERYcFVyTHRPZGNqOWx2YUJodnRWV0RPY2g1MmFmeVN3NzVEemkw?=
 =?utf-8?B?UkVsNW81SHlTZ2gwZ2pobGxFcnVmeGQ3N05JMDBRRjh5L2dDTTFza1dNOHdK?=
 =?utf-8?B?MnYvUmQ4MGI4ZmJnU1BKNEtFRlRTSkdmTjcwMnZ4bUJzbG1vaUU3aVhGcmRz?=
 =?utf-8?B?L2k1bXBkdVo5dVRhRnYyNFQyM05pVFFPalR5b2tuWG9qRjJpbWFFNGhobXRD?=
 =?utf-8?B?YllFSzdzaHJRbXRCTXpKUnltVkZQNGhYU0F1Uk1vbE1JeVpFcW8vcHIvT1Rh?=
 =?utf-8?B?Um5Pcmo4clQ4bUl4RVZBcjR1Vjc4djhBVjNta3M4MGFNNUphbk1SWjRySThi?=
 =?utf-8?B?eVh1YlB6WjkvWTBNU1JjM3RVS1FON0FEU1I1dktzYjhNWVFRNE1keXB0aGlk?=
 =?utf-8?B?NDR3WDZ2UnlQV3pNUXJCMkRXSU90c2tVMVJBMmtzdXQvVW43dllwaGtrYVg2?=
 =?utf-8?B?dlgxQUhHb3NyUGVtRzVUUmdabjNvLzhqZW5XcmorMmdyUjFlVldSVHdseUxu?=
 =?utf-8?B?akphY2R0Nm5yR3YrMlRrSGpyZTd5UUpPVGRWckl1bUpRTWVyNzVFTTJTSWQ3?=
 =?utf-8?B?M0t1MGZpM25menNoZXROcm9NUzNlbXJpM2VmV00zekJManErVFNjOStHYncw?=
 =?utf-8?B?MmxkREM0dTlRQXpCZ1lHT0RGUkJjM2xHa1h2TTJkWEEyMk9DQW1tY0NDS2dR?=
 =?utf-8?B?MlhObEFkNk9CWFYwK01RaWkybWtOcmVjZWw0R3lsNmplSmNOTWYvbTI3SDdi?=
 =?utf-8?B?TkQxWFF0YmYwcWloTFJLaXQ5TXZuZGoxaDhweDlyL0l2aEZ1THZ0ZWo2UTZ1?=
 =?utf-8?B?U0xsSTdmTmZHSzdrRnY2RkU2UUkrZHBZMDZjaUdWNXU1cVJpdHREWU1RSU9p?=
 =?utf-8?B?Q2s0c21OQTdzbVd1Qi83UTdyQ1BjT3g1enB0aW8yNmcwMmJ4Z0pSL2FYb2Y2?=
 =?utf-8?B?WG1tQXYzdng1Y0lGZEt2b2w2aVUrU2VwWmpJNU9GUzMyRUxaUGZhdW5LSmdV?=
 =?utf-8?B?VXNzUUkxVGhkbWhZdVBFM1k3TlBIamFCbVNycTI3c2c3elpvelU0TXJiKy9G?=
 =?utf-8?B?YkFwTzY5QWNoWEgrTU5lNUwrYlFFVEJNZ3JrQWxCNCtWVFJoNk9vQm1JQkln?=
 =?utf-8?B?eHJDeC9MNy9Zd2p1b3RlZ1IzMW1QMFJYNjlMTVZ4MEZMbFlyTzllb1VsUzNn?=
 =?utf-8?B?Vi9ZaE41WnM2MzJYNHdzWlVPWk1IekR1RUR3MjBLYXMzSENwc1p0T2M1OTJM?=
 =?utf-8?B?SndxYzgxSEVQem1qbE5teGtUbEpkVkhOY0d0cFhVT25IeXpPdU9FRXpPeXhK?=
 =?utf-8?B?bFFYM2FJc2dwU2lIOERxQzJ4Z2JQMStTVTJnNVpmQjZWVzN6T3NQV2wwTFNi?=
 =?utf-8?B?aVNvbmZ4TUtzcGxEb3ZEWm8xVkk2L1FLc0V5KzNqODZOSFNjeGpFOTdaYmRz?=
 =?utf-8?B?V2w2SENNVXhrM1pQREZWTVNpK3I4TitzYUExUzdKV3Nrd0VSTEUyRTZPeWph?=
 =?utf-8?B?V2Q3ZXZEQzg2VGJMc2xkNnY5Z1FVbEJZMDhDNWhIcVdBZnE3YWhPeE80VFp0?=
 =?utf-8?B?YVh5V1N6YWtMSEJHallmUlpSNE5VNjJZajMxKzZ6dlVXeWd6QndFZGxSa3Qz?=
 =?utf-8?B?UVRJaEJZTVFKSXVZZ1RoY0s0ajgvQ01CZUkyZ05kVnAyWk9KbEYwM0lwUVdl?=
 =?utf-8?B?NDM4ZnZoTlhQODMxci9zZTVoNmtmYXRkMjJQRnAyY3VPcnk0U1p3NXIyLzlP?=
 =?utf-8?B?RXBXeUtUbW11cHFkUHhJSi9ZTGZFVSt1RFN1M3lBTm5PQmtoRU94WVpPWUx2?=
 =?utf-8?B?M1NDWlowU0VaN1N3VE9yNVlBM1dyZ1I3NmZCaGdsTVViV1pVMzNvMUhDODM3?=
 =?utf-8?B?eDJhVTVCWDNmaXpML2lCM2NVOFFrZ1o4OElOYWFRMUpkTnJVT2NnRkpoRGg0?=
 =?utf-8?B?djlybml3dk1pMjMrUE0vcm5LV0VzTkZBSkZ4TlhEL2FVVHVzc05XT0xzc3BX?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A325B8651655854CA7FB3A3DACAD09E1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9130d23a-eda9-4ea9-44e4-08dc942b38e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 08:54:13.7959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SFuvxrxn7g0sHXjTU55G8V7pdPmSBI6HX/kkNuk2QUioxrz9RHSg22Hpx+ZG32XBZzAoniR9SQmV1aCyCLaauw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8539
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--19.431100-8.000000
X-TMASE-MatchedRID: 3FtKTYP2XG7UL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTqv+
	rJDXrRotOvGitUUDN4RCyFrD/CmZGWU/fB/XFmJzk7k9yXJiqqoiuaoNXJrK/47E6rstCUYvxHZ
	GwpE0CXWc1TI/CPtiTc06gFXsMyio5clR/IzUrTZdc7I2df+msEtdrY/Wb3fPagsZM0qVv15CqC
	Cpmz7Gr+clmm9iOPW4197cQb1ieX95ZY75Y7TbeQpxiLlDD9FXjAcZeNJgY95soi2XrUn/J+ZL5
	o+vRV7w1ZkKqeMpEwFcppCzPq+1UkGUtrowrXLg=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--19.431100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	EF7E9C272B4E9CE538BD72FAC02C2875A3E7304C58FBB3EAC83BD2A07316EC802000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA2LTIxIGF0IDEwOjIzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yMC8yNCAxMTo1NCBQTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiAgICBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2UgYXQgdmlydHVhbA0KPiBhZGRyZXNzDQo+ID4gMDAwMDAwMDAwMDAwMDE5NA0K
PiA+ICAgIHBjIDogWzB4ZmZmZmZmZGRkN2E3OWJmOF0gYmxrX21xX3VuaXF1ZV90YWcrMHg4LzB4
MTQNCj4gPiAgICBsciA6IFsweGZmZmZmZmRkZDYxNTViODRdIHVmc2hjZF9tY3FfcmVxX3RvX2h3
cSsweDFjLzB4NDANCj4gPiBbdWZzX21lZGlhdGVrX21vZF9pc2VdDQo+ID4gICAgIGRvX21lbV9h
Ym9ydCsweDU4LzB4MTE4DQo+ID4gICAgIGVsMV9hYm9ydCsweDNjLzB4NWMNCj4gPiAgICAgZWwx
aF82NF9zeW5jX2hhbmRsZXIrMHg1NC8weDkwDQo+ID4gICAgIGVsMWhfNjRfc3luYysweDY4LzB4
NmMNCj4gPiAgICAgYmxrX21xX3VuaXF1ZV90YWcrMHg4LzB4MTQNCj4gPiAgICAgdWZzaGNkX2Vy
cl9oYW5kbGVyKzB4YWU0LzB4ZmE4IFt1ZnNfbWVkaWF0ZWtfbW9kX2lzZV0NCj4gPiAgICAgcHJv
Y2Vzc19vbmVfd29yaysweDIwOC8weDRmYw0KPiA+ICAgICB3b3JrZXJfdGhyZWFkKzB4MjI4LzB4
NDM4DQo+ID4gICAgIGt0aHJlYWQrMHgxMDQvMHgxZDQNCj4gPiAgICAgcmV0X2Zyb21fZm9yaysw
eDEwLzB4MjANCj4gDQo+IEhpIFBldGVyLA0KPiANCj4gVGhlIGFib3ZlIGJhY2t0cmFjZSBjYW4g
b25seSBvY2N1ciB3aXRoIE1DUSBlbmFibGVkLiBUaGUgYmFja3RyYWNlIEkNCj4gcG9zdGVkIHdh
cyB0cmlnZ2VyZWQgb24gYSBzeXN0ZW0gd2l0aCBhIFVGU0hDSSAzLjAgY29udHJvbGxlciAobm8N
Cj4gTUNRKS4NCj4gU28gSSB0aGluayB0aGF0IHRoZSBiYWNrdHJhY2VzIGhhdmUgZGlmZmVyZW50
IHJvb3QgY2F1c2VzIGFuZCBoZW5jZQ0KPiB0aGF0DQo+IGRpZmZlcmVudCBwYXRjaGVzIGFyZSBy
ZXF1aXJlZCB0byBmaXggYm90aCBjcmFzaGVzLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4N
Cj4gDQoNCkhpIEJhcnQsDQoNCllvdXIgYmFja3RyYWNlIGlzIFNpbmdsZSBkb29yYmVsbCBtb2Rl
LiBCdXQgSSBhbSBjdXJpb3VzIHRoYXQNCmhvdyBjb3VsZCBpdCBoYXBwZW4gaWYgY29tcGxldGUg
YSBjbWQgdHdpY2UgYW5kIGdldCBudWxsIHBvaW50ZXINCm5leHQgdGltZSBxdWV1ZWNvbW1hbmQ/
IGNvdWxkIHlvdSBkZXNjcmliZSB0aGUgZXhhY3RseSBmbG93Pw0KDQpNb3JlLCBiZWNhdXNlIHVm
c2hjZF9laF90aW1lZF9vdXQgY291bGQgcnVuIGluIE1DUSBtb2RlLg0KU28sIHRoaXMgcGF0Y2gg
d2lsbCBnZXQgbnVsbCBwb2ludGVyIHdoZW4gcmFjaW5nIGhhcHBlbiBpbiBNQ1EgbW9kZS4NCg0K
VGhhbmtzDQpQZXRlcg0KDQoNCg0KDQoNCg0K
