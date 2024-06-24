Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502543C684
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jun 2024 09:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719220442; cv=fail; b=FGJjA6oTDDQ5H7lsMb3BJSGc86O1F/M0/fxIl9bOa/hhqNAjrUvPAJhmqAnaY8n5sigzDm647iiEkDE6b1DnwtnT6M16Z5E7qbaF+Lqw/u9l2wlIr2HQUDqBYXNsFz+7WKyxnsV1eNVdWQbUMnGlHzEQ/8pxOF+9bLkFtW0pPxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719220442; c=relaxed/simple;
	bh=XqRQH1QN+dpOSvrTyWyen7kMJS0i3pMU8QO9mFl+xLs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LUs1dIb7r+Ktxlm5fyo2n2xPMll/2B0MaHtTFw1hFdLp3giLf79ZwTfi0xULRxykXkeTkEZbHG0TA9ZO4HJakiQCr6+Ty/r8bHX+OmdfTmEs4D1N3uT9DK24mwfxU92u/moG3HP1l49YMWMy+JKH4H2TJ9D1c3IsLu0Cq6qFBU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=vFaE7e1w; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=B/0rUp3S; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="vFaE7e1w";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="B/0rUp3S"
X-UUID: 0ff24022320a11ef8da6557f11777fc4-20240624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XqRQH1QN+dpOSvrTyWyen7kMJS0i3pMU8QO9mFl+xLs=;
	b=vFaE7e1w4f2j7h+T1iaZtEA8rCRKJkqZ9VTXQy4TN1X87wQTzW8JHFAJb4Tbz+xcGG4BPIe9Y+zQJPkhE8vnbSN6OJ8WFvRb1K0XwwXND4oaPazFkVIkHcBQPWSWXJz5oIiP/4zlJIJ3nCriIoh3KS0QxM0BlGvbwouxniausDg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:75919660-b764-4578-9e1f-f9ef1e757fe2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:c7dd5c94-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 0ff24022320a11ef8da6557f11777fc4-20240624
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1930043608; Mon, 24 Jun 2024 17:13:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Jun 2024 17:13:45 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 24 Jun 2024 17:13:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py0qN5Aknu09SUrBpG3Z6iOTR5THg3dQvixNr7QrSiVn8aoerHjhk45os6QPDLB5q4IKOZlsQ1zqanbhM/L/Vz0lDCpmPUnmxHxPPTP+7FU1xcJsk3h++WX3ELT2GDcxjXpINaFt/BgKDygjK0ohosEBPNQi+ZQZLB5muWlaxfKIZdi880evyx9o/Q2VPbg00XCf5x4+tsToJVDB+Qq1M100UZX+9Ca1Sa2WaeV+b64hVZQGq1ETFd/BgO3e1MuLdzEUns2RWohN8Bb9r6GE1nvQ5q4xlBWfYmdGB0tkfScD+tmhI6MZPQpcw/5bz6OVO3cXQznvL21ycZmr2FRzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqRQH1QN+dpOSvrTyWyen7kMJS0i3pMU8QO9mFl+xLs=;
 b=SPVsFwl3QkZ0BmmaF+lYHaNJmp5nPgac44dCAMzljPsQ8iBqesg0uVBbS4ZSMKNJUWZ31tBiZ95MzkSIlV6YtsLBcEhXXU7NNuZgJWjGCmdCq7PQjEQu1/pM7/EqqyWq+8j0cu/rpxWQaAGFouywW/kxNLVEoutBiXhwNXQaIYl8Mi1/4dIG0PfsdKs7oRiinGQYij6hL2/fv34xC43kdX8gsF4e+lJdnDa+H2i+O+mHNjh/WHKiQLoUzQCfFZ7K4e2jmsoSmup7qm1WBl/Gcn976wMNZVY8l0BapCfqL77IH+6JZZ+E4N7V2/fxni9rbPVhCHT6LqQJBbj6vxSXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqRQH1QN+dpOSvrTyWyen7kMJS0i3pMU8QO9mFl+xLs=;
 b=B/0rUp3Sa617CT5VwcN2MUzw6vdWGrv03DsHB4LmhLSFvGioVfDu0zaTEitgbl2VgxU0Lm5zUNZQ4dCrzHZPDuOIP3spBnHgprcwh23UnULioxUHvA9Jeegt5hoxaEXuo03nCh26fEoARUmOiocNqRPJkS28Ax8oj5HJrVpnFGc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7301.apcprd03.prod.outlook.com (2603:1096:990:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.27; Mon, 24 Jun
 2024 09:13:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 09:13:42 +0000
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
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix ufshcd_abort_all racing issue
Thread-Topic: [PATCH v1] ufs: core: fix ufshcd_abort_all racing issue
Thread-Index: AQHaw858ZKlOGAs2+EKLkeiREOgt3rHSdbYAgAQwSYA=
Date: Mon, 24 Jun 2024 09:13:42 +0000
Message-ID: <4572ddf23376d8f2e3592f1730f127d223039c26.camel@mediatek.com>
References: <20240621113051.29523-1-peter.wang@mediatek.com>
	 <4ad91e15-f1f9-40cc-b45a-4eed2932a72c@acm.org>
In-Reply-To: <4ad91e15-f1f9-40cc-b45a-4eed2932a72c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7301:EE_
x-ms-office365-filtering-correlation-id: 4261a1cd-5b5d-488e-73f5-08dc942df17d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|1800799021|376011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?dFlmeDV2MGNFbmhEUXB6cHhkRE1CaWtqdll1Qll4cWRsQ0hlV3Z4SWkyZVp0?=
 =?utf-8?B?d1JzUTRTdzRhYjhqK1NLanltYTNYK0E2aVc0ZmJvbWFBaENNR29HV1dESEVj?=
 =?utf-8?B?TU1yMkZpU1FoSWExMURyMDNqbDFyU1Y1L3JPZWlKZmFHa2dyVVhHZzVVeVVi?=
 =?utf-8?B?b0RIS25Cbk11K2tUelo0NG1uWEdFSjY2RHZxQ3R5a1VLbFhsUE5lMVBpaUJG?=
 =?utf-8?B?MWNoNnhiU0pKcHhCdTZwWmU1TTdadStRSEYrL1ovNytjNU0vZ1R0aDBOMnE0?=
 =?utf-8?B?UEJwVFUvOHNQa1F0NTlHNjVoME0waU11cUJ5WTVEWTYxMC83ZmdqeDhRcWVu?=
 =?utf-8?B?dTdRdHJyUHV4cHhRbnd5dkZ3RWRsTDQ3MVdwTTNTeHVvS3VKWll0VHNkZlVr?=
 =?utf-8?B?NlJTZ0M1UHRNbWRCQTUvZTV0clhsZ3F6ZkRraDVvUGJZYm44NDZ4L2hySTF5?=
 =?utf-8?B?Y1NaWUpNWWd1bHNNem16SC9XOGM5aE1XL3hkYUhtcGR2Qm92Tnc5TjhvSTZP?=
 =?utf-8?B?UE1VWjlqdkVuNXJZZjl3MFNmdlgzNjN1WmZYdjJxa3B0NDkwdXpVRmVrSTRs?=
 =?utf-8?B?RklvLzZzVTRhN0U4eGdvZ1Y4eWVLL0Iya1kzTUYzNU1WTGVoUlVldDFPQzln?=
 =?utf-8?B?TTI4b2NncUlSdXc1Wi9odURhVGZ4RngvR0QxV1FUZEdyTW8vOEw3L0pPYzhQ?=
 =?utf-8?B?dXYyY2VkUUJRNkNJM1V5dHlqQ2t0WnptaGoyYmxmRHYwakgrMXVRZDN6bmpy?=
 =?utf-8?B?UXlnYk5hV0I3N010T2RUWncvdE1KR1F2U0tIS3hqUXYrWmkxcXJBNDZRL1lD?=
 =?utf-8?B?VEpQdUJQNjZZZDVsZTlnSUNJQ1VjMStaN3AvRDRLdEtXUytVeUZTVDM1MDIy?=
 =?utf-8?B?U0d1SVhiUWJlMHFmS3NCMURSV2NwaW9MQnVnalV3Vjc1bGR2RUExNkxoeUlL?=
 =?utf-8?B?RmVFQzVOVi9jVzRYM1RhcGphVVNkWklYSU5VR1Y1VlVNZkVxQ3BtZTdHWDFi?=
 =?utf-8?B?LzduQlRPV2lYdjN0Mk4vMFM2L2lnVDRkSDhST2QwU3dpSHI0dUoyaVJQbjdv?=
 =?utf-8?B?eXlEME1rcUZJRGRlcVN0UU1EU3NrZjNCQmNMVDdKVHdUdHhtMGlWQzk2andW?=
 =?utf-8?B?Tno5UEpiMm45SkRhUjhrekdldXJiZjZGeWRhYmJ3OGlNWjhyVGdNS1BxaWlM?=
 =?utf-8?B?aGVSckdaaks1YlJjRUxSRnppbUVyYnlscGlVNURkZytEdE1QVUwya3VUR0NM?=
 =?utf-8?B?SFpoUlJqZjhpR1RLL1hGT1ROYmNhT2xVL2ErYWNtbjV0SE0xZkxLdUdmWFZM?=
 =?utf-8?B?UjRuT3MrZEd0cUROclc3WHI1TlRmS3JGRmtmcWtIOUQ4R0p3MmNzb1Z3L1Jo?=
 =?utf-8?B?Um9jOW9IQUNORzZiOFA0MDJ0VXZmVW51SGpNRzZOMHhTM0NWUEVKOS9JV3dM?=
 =?utf-8?B?cVU1cklmdVJNaG1neHR1M1JYeUhoSU1FZ3FHR3BsQjAxaGFvRTF2bURWVEJh?=
 =?utf-8?B?NnpsRUJlYzRMMS84aTJmY3hlNDJsajRNQ3dhOGFSaStyc1REc1c1YS9mOG9Z?=
 =?utf-8?B?ak9xU3hORENnS1ZVVDdkcWNRRkhCamdMS1k0U3kxeUN5cEZZNCtabUZLK1lV?=
 =?utf-8?B?dmh0NzcxeUw0U084aHpUdXI0MXZUcGxWdU4xcDg3QitaRGEvR3JZUFkxc28x?=
 =?utf-8?B?VmcrVkY4QnhwVE5wT0Qva0RnNEN5N25JNTdTOElkMjl3bWxHSXgzdElUZldB?=
 =?utf-8?B?TXYzbmlRRkp6U3JacnY5YWFkT2VPUDdURERlVlQvNERDU2Y2cW0xVGRkbGlw?=
 =?utf-8?Q?Z6bR2xIs6+wbOjN0CdFKgvZreTVRZVZrncFtY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVJSSzl6akZUbE13b29RcCtkMVQyV2J4VzRjci9yRk1EWUJxQzRLOUtuYVFN?=
 =?utf-8?B?N2VnQlNGZ2pMaGFicy9NQUlDV1VJc1M5dFNOMkpYeU54OFN4QmNMNTcrZFJv?=
 =?utf-8?B?QmxRSnp0cTBXSUI5QVhmckVBOUhLUnFVeXZIWkNUc2V1d0kwdGpxZU5sYkw0?=
 =?utf-8?B?UWY2ckplWmVza2JSV0RMSytQeWRLMjI3cVZxQmVuTHovSmp0Y3U4S05zc0Fl?=
 =?utf-8?B?SnJTY2Yyd0x6UVBMY2J6eWFURm0rNWRnR0lnQ0M2Ry9Jd0Y2L3lxYmRrZTZZ?=
 =?utf-8?B?anhvMkdldm5WRUJNZU1yZm9RaC9PWjhvQzdHNjdJRjRZK2VvTjA0MHY3MzMy?=
 =?utf-8?B?NlJxbnRIZXh3SEZ0bHN1SnhnTGJac2hkdUxuQUtZRjM1NVBwV3M3T2hEeGJy?=
 =?utf-8?B?UUtHZmpWeDdLakoycXg5eGF3V1E2ZENCaEFubkplQnNkSHhkVSt5ZlNuVlQ1?=
 =?utf-8?B?MzhMWUlNRUxmMTdWWitRbTFqUG1vRHpFcGhtUmZKNXlPQzQ5U1YyaDI2SUdx?=
 =?utf-8?B?anRYSXRnSHNnSktneVVNQVUyMUJXRllTUmxMRVdZRUVObVU1TTJtays5V2lQ?=
 =?utf-8?B?MzE2Q0pUd0c0YUo1dGQ1ZjRwTXJnbmhkUk45c3h6UG9oUnZ3QlZwWmNBZXdZ?=
 =?utf-8?B?ZjQ3c2R0TXFEZ2hUZjRTWE8vK2M4cVdUV2VEcUtBVlB0THBEdm80QmJ3bmdF?=
 =?utf-8?B?K0ZGNXZlaGdRYThPMmxWeVo3V1Y5bzZqSG95U1BGTHNQZzNEZGtQbDI3d2pM?=
 =?utf-8?B?bUFFUFpzN1UyWnNtZzRXWkJKRGpmZUE3eVRZN2M4WVZSbkFMNFo1MlBnUmds?=
 =?utf-8?B?bThTMng2ODJPM0lWcTZQVU00UFg3ZWpSWkxFNzhDR01QczJFRTQ2UndyVzVG?=
 =?utf-8?B?MjBoOUZ2K1dGc2R5VUgzSEs2NEJkTldUVXhsNGhxTzNZN3VYSWpxaExQYWtS?=
 =?utf-8?B?VUVOL2NJZTNlN0NJNSttb2NTSmRVRWc2Z25obkxWR2FjUUxXTFNCZ2VFeTFN?=
 =?utf-8?B?SnpaMzM1c2JyT1FoRFRFVnRIb045bEx6b250WUx2QWxnOHgwSXZhOWpaZmdm?=
 =?utf-8?B?NzhvQXJQK21ZcGNwcGFtSzZhNTJvaXA3cjNtYkgwNGF6TzR6aFRUNDNQTVBH?=
 =?utf-8?B?UmVqeHpwa0ZXVEwxZ2Jib0d0VTdYSXJmYllyTEc0L2lTaUduS1lDRHhMdHZa?=
 =?utf-8?B?ZWpxbGZwOWlyM0dEalRwQUJ2VTBsdEwvWVVadVVicE81clVmYWJOdXluZks1?=
 =?utf-8?B?R2ZGdzhHQXM0Q1Y0S005V01qOXErOGkyOTNpbGNXZUhNVEQ2ZE5za3FaQjIv?=
 =?utf-8?B?RmhtOHZhTEJVRTlOZmE4L3JmN2hqdTBoNk1sdW5laCt1bXZYWnpuck9uWkoy?=
 =?utf-8?B?MzJldnRSQ3pVeFBnajZtSGFlMG1NeEY2THVET2tUc3BIeWlJb0dSc2xJYkdj?=
 =?utf-8?B?ZWdhQ2RqYXJMOHhhcUZJamszWDB6N0MzYlJTVmVNMWFNcmlFdTBwcWQ0K3N6?=
 =?utf-8?B?eXVicHZhYUR0ZGRNQTJqMXRaR2Mzam1xcmxmcTI2TDZEK05xOHV4UnM1NTRl?=
 =?utf-8?B?MmJKZ0RFR3U1WjExSlM4QThoWmFkODlYL2I5OWFKeXBDQlRpVUdKN3JrZDVu?=
 =?utf-8?B?SW1vSFlmM2MzTVlSMGNaM0pnRXoyenJGQ0dJekt1NkdxeVFsRWRQTmhvbkJV?=
 =?utf-8?B?MlhUc0dtSUZPdm5VNEtHN0I1TlMwU3paWm1VclNqRWdCTS9KbDFnOXlPcG05?=
 =?utf-8?B?dm1ORStURlBjSU9TaVhaUHRWc3JTNjVMMUFRT01BMEwwUkFuQ0k3NmpXYTRJ?=
 =?utf-8?B?K0ovWnQrMVY4alh6VkZZWHdPN1luVTdYK1pneVgwWThaVXlza2ozalp2akF5?=
 =?utf-8?B?RDBqNDJ1YWd1aEZueXhxdkhIQlpwZFV1Y2htYnJ0aTBFdWhGU1dzN2xjMXMv?=
 =?utf-8?B?QWQ3eERYdWZnc1oyRytaa0kxU3ZJckV0N0piQ0pzdVlUUG1ZaE9aSW14eEpD?=
 =?utf-8?B?QTNiK1lWVVlyb1luQ3NhTDQ2QzRKRUhXQk03SnpFYVpWMElkdFFoRVhZMkw4?=
 =?utf-8?B?VHdQNUg2a3FhMVBHU1dCZnpiaG1zWFdpT29mN1M5d3NONjQycHNqNTc2eWRp?=
 =?utf-8?B?MGdLbXNUZUZabnlQakdBV0ttZmVtQ1owY1hmMkpMRHlOMVpEOGxNUEFCL09F?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98A3CC1B1F96F6448242A3C1136FE441@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4261a1cd-5b5d-488e-73f5-08dc942df17d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 09:13:42.5346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPtoGqsBC/dpOksL0g7nXEfQys5T/VGdLRuotERd+QDhl/VQaHlbFjRoP1JAm6fGjPU/EQcMdhyStsgnKjHUwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7301
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--31.456400-8.000000
X-TMASE-MatchedRID: UWn79NfEZzbUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu99RlPzeVuQQtYw
	ybS5m3W19VK5Cn+Wq2DL7GX7LrXWiu9okb5cOFzbCz1ymGcrCUW73ma3jsPM2yWCL+8tLbvZSk3
	lvhd38XXc5Wj8WOFr8NcvGh0jjI991ZIBJvSVnHcnUTf2MoOKYn8dxVYWr6D1XPwnnY5XL5CzEU
	5V3Ctgt1HThx8+Lmdku5ed2FW2K2ZAbpTKt/Q8o5O5PclyYqqqIrmqDVyayv6vM+zzl/BSTaF29
	jZP2X5cYJMEVb1jPE5GTpe1iiCJq0u+wqOGzSV1GONWF/6P/Ckp0ODI8GjvXKrauXd3MZDUD/dH
	yT/Xh7Q==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--31.456400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	4633658022E58B9C00C329C1AA6701F664B554802098AC14EE8E34DA9AB396562000:8
X-MTK: N

T24gRnJpLCAyMDI0LTA2LTIxIGF0IDEwOjE1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yMS8yNCA0OjMwIEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gID4gWyAuLi4gXQ0KPiANCj4gRml4ZXM6IGFuZCBDYzogc3RhYmxlIHRh
Z3MgYXJlIG1pc3NpbmcgZnJvbSB0aGlzIHBhdGNoLiBQbGVhc2UgYWRkDQo+IHRoZXNlLg0KPiAN
Cg0KSGkgQmFydCwNCg0KT2theSwgd2lsbCBhZGQgbmV4dCB2ZXJzaW9uLiBUaGFua3MuDQoNCg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyBiL2RyaXZlcnMvdWZz
L2NvcmUvdWZzLQ0KPiBtY3EuYw0KPiA+IGluZGV4IDg5NDQ1NDhjMzBmYS4uM2IyZTViY2IwOGE3
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jDQo+ID4gKysrIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gPiBAQCAtNTEyLDggKzUxMiw5IEBAIGludCB1
ZnNoY2RfbWNxX3NxX2NsZWFudXAoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gaW50IHRhc2tfdGFn
KQ0KPiA+ICAgcmV0dXJuIC1FVElNRURPVVQ7DQo+ID4gICANCj4gPiAgIGlmICh0YXNrX3RhZyAh
PSBoYmEtPm51dHJzIC0gVUZTSENEX05VTV9SRVNFUlZFRCkgew0KPiA+IC1pZiAoIWNtZCkNCj4g
PiAtcmV0dXJuIC1FSU5WQUw7DQo+ID4gKy8qIFNob3VsZCByZXR1cm4gMCBpZiBjbWQgaXMgYWxy
ZWFkeSBjb21wbGV0ZSBieSBpcnEgKi8NCj4gPiAraWYgKCFjbWQgfHwgIXVmc2hjZF9jbWRfaW5m
bGlnaHQoY21kKSkNCj4gPiArcmV0dXJuIDA7DQo+ID4gICBod3EgPSB1ZnNoY2RfbWNxX3JlcV90
b19od3EoaGJhLCBzY3NpX2NtZF90b19ycShjbWQpKTsNCj4gPiAgIH0gZWxzZSB7DQo+ID4gICBo
d3EgPSBoYmEtPmRldl9jbWRfcXVldWU7DQo+IA0KPiBUaGlzIGNvZGUgY2hhbmdlIHJlZHVjZXMg
dGhlIHJhY2Ugd2luZG93IGJ1dCBkb2VzIG5vdCBlbGltaW5hdGUgaXQNCj4gc2luY2UNCj4gbm8g
bG9ja3MgYXJlIGhlbGQgYXJvdW5kIHRoaXMgY29kZSBwYXRoLg0KPiANCj4gQWRkaXRpb25hbGx5
LCBhcmUgeW91IHN1cmUgdGhhdCB0aGlzIGNoYW5nZSBpcyBuZWNlc3Nhcnk/IEkgZG9uJ3QNCj4g
dGhpbmsNCj4gdGhhdCB1ZnNoY2RfZXJyX2hhbmRsZXIoKSBjYWxscyB1ZnNoY2RfbWNxX3NxX2Ns
ZWFudXAoKS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNClllcywg
dGhpcyBjb2RlIHJlZHVjZXMgdGhlIHJhY2Ugd2luZG93IG9ubHkuDQpCZWFjdXNlIGlmIHdlIHdh
bnQgZ2V0IG1jcSBsb2NrLCB3ZSBuZWVkIGtub3cgd2l0Y2ggaHdxW2ldIGxvY2sgDQpjYW4gdXNl
Lg0KQnV0IGJlZm9yZSB3ZSBnZXQgd2hpY2ggaHdxW2ldIGxvY2sgY291bGQgdXNlLCB3ZSB3aWxs
IGdldCB0aGlzIG51bGwNCnBvaW50ZXIgZXJyb3IuDQpUaGlzIGlzIHF1aXRlIHRoZSBjaGlja2Vu
IG9yIHRoZSBlcXEgZGlsZW1tYS4NCkNvdWxkIHlvdSBoYXZlIGFueSBzdWdnZXN0aW9uPw0KDQpB
ZGRpdGlvbmFsbHksIGhlcmUgaXMgdGhlIGJhY2t0cmFjZSBvZiB1ZnNoY2RfbWNxX3NxX2NsZWFu
dXAuDQoNCiAgdWZzaGNkX3RyeV90b19hYm9ydF90YXNrOiBjbWQgcGVuZGluZyBpbiB0aGUgZGV2
aWNlLiB0YWcgPSA2DQogIFVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJl
ZmVyZW5jZSBhdCB2aXJ0dWFsIGFkZHJlc3MNCjAwMDAwMDAwMDAwMDAxOTQNCiAgIHBjIDogWzB4
ZmZmZmZmZDU4OTY3OWJmOF0gYmxrX21xX3VuaXF1ZV90YWcrMHg4LzB4MTQNCiAgIGxyIDogWzB4
ZmZmZmZmZDU4NjJmOTViNF0gdWZzaGNkX21jcV9zcV9jbGVhbnVwKzB4NmMvMHgxY2MNClt1ZnNf
bWVkaWF0ZWtfbW9kX2lzZV0NCiAgIFdvcmtxdWV1ZTogdWZzX2VoX3dxXzAgdWZzaGNkX2Vycl9o
YW5kbGVyIFt1ZnNfbWVkaWF0ZWtfbW9kX2lzZV0NCiAgIENhbGwgdHJhY2U6DQogICAgZHVtcF9i
YWNrdHJhY2UrMHhmOC8weDE0OA0KICAgIHNob3dfc3RhY2srMHgxOC8weDI0DQogICAgZHVtcF9z
dGFja19sdmwrMHg2MC8weDdjDQogICAgZHVtcF9zdGFjaysweDE4LzB4M2MNCiAgICBtcmR1bXBf
Y29tbW9uX2RpZSsweDI0Yy8weDM5OCBbbXJkdW1wXQ0KICAgIGlwYW5pY19kaWUrMHgyMC8weDM0
IFttcmR1bXBdDQogICAgbm90aWZ5X2RpZSsweDgwLzB4ZDgNCiAgICBkaWUrMHg5NC8weDJiOA0K
ICAgIF9fZG9fa2VybmVsX2ZhdWx0KzB4MjY0LzB4Mjk4DQogICAgZG9fcGFnZV9mYXVsdCsweGE0
LzB4NGI4DQogICAgZG9fdHJhbnNsYXRpb25fZmF1bHQrMHgzOC8weDU0DQogICAgZG9fbWVtX2Fi
b3J0KzB4NTgvMHgxMTgNCiAgICBlbDFfYWJvcnQrMHgzYy8weDVjDQogICAgZWwxaF82NF9zeW5j
X2hhbmRsZXIrMHg1NC8weDkwDQogICAgZWwxaF82NF9zeW5jKzB4NjgvMHg2Yw0KICAgIGJsa19t
cV91bmlxdWVfdGFnKzB4OC8weDE0DQogICAgdWZzaGNkX2NsZWFyX2NtZCsweDM0LzB4MTE4IFt1
ZnNfbWVkaWF0ZWtfbW9kX2lzZV0NCiAgICB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2srMHgyYzgv
MHg1YjQgW3Vmc19tZWRpYXRla19tb2RfaXNlXQ0KICAgIHVmc2hjZF9lcnJfaGFuZGxlcisweGE3
Yy8weGZhOCBbdWZzX21lZGlhdGVrX21vZF9pc2VdDQogICAgcHJvY2Vzc19vbmVfd29yaysweDIw
OC8weDRmYw0KICAgIHdvcmtlcl90aHJlYWQrMHgyMjgvMHg0MzgNCiAgICBrdGhyZWFkKzB4MTA0
LzB4MWQ0DQogICAgcmV0X2Zyb21fZm9yaysweDEwLzB4MjANCg0KVGhhbmtzLg0KUGV0ZXINCg0K
