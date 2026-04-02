Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C631362143
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114359; cv=fail; b=g93VcmxFnyar1vLGEWuICaKTUKpOx/hqSazlgkBhGBcFuC8WButEnjXg2NxjQP8QAd7BA3o316yH18u3phCYk6ikktZ+gNzre9x3O65t5kO2/SMaGwT85RAQ0dNGGA8iBd1V/1RUvCkHfwLylkDPzvaKDtDb0rATjg2lPZBT+TE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114359; c=relaxed/simple;
	bh=766AFai0HNayYevTj1q9gwP6IvmEQSOQ946rMln4PTQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dk5KzstG25NCa/Pwj2fpsKQ9Wy0LrnjdIRhtfe/gSrcGO1nZRzOFu0tumbsZoxBgu2nG0Z/OSDFrTgNKI69X4Nj0aCk6QYU50NL0QY5y5Edbtl2W7G86wRyUoNPhv/o6JcITRRNyw0UKYL1QC1KLgns3OrQK91ggxo8Y0gMs/Tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eWRvhdAa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bSF1FNE7; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eWRvhdAa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bSF1FNE7"
X-UUID: 3f1858f22e6411f1ae70033691e9ac7d-20260402
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=766AFai0HNayYevTj1q9gwP6IvmEQSOQ946rMln4PTQ=;
	b=eWRvhdAavBJFhCDGdcQ/XwCrp0yTOwhPyb467y09uPkBJ5I65nV13e1ncFXPpKDyxoGUzoftzZVemawtr1D6Evtyvu62UMG8eoAFOSXRNB4Tn2LwVdXfrdBRivDaxifkEe/0zrOMBNqnrHDjK6GHfaCXCOIpNzQZWiglviC8sPU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:bc98a2ae-ed82-4c80-a361-e7a088c12d22,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:6e116cd5-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3f1858f22e6411f1ae70033691e9ac7d-20260402
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 485177014; Thu, 02 Apr 2026 15:19:11 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 2 Apr 2026 15:19:10 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 2 Apr 2026 15:19:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHRGYTIV8LmWdJrXCIe8kygb/uFmOvoDersZoQuRanI+tnIV2k+KAhtpiI1KQ/aMr4vobmaTjbUO6O+KK6i8W2CW7Rp961tdgxa4wXMYBCR05Fzrj85xcQrlT0hD1YsRICjOOBAGVOe6Lg4fiji6HuqsYNPpB7iN0It5HcHqzug97GcGizEVbLyh3Gx8GLsCkfn3I7svJjAn6fpKa7ytQjm9EXfllo7CABlfnQmXeQ3CbD8wyXY3XhP0oRgUGCTBjXVyNRjO1MsufF5Z4b00Ox3cpCiYcvdiyDbO+LnOP5GRvqSKkaJXN6RMrZBaAGAyq0DmL1dRkgUUWTmY4IBavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=766AFai0HNayYevTj1q9gwP6IvmEQSOQ946rMln4PTQ=;
 b=c1tH3VaFuGIZiUJf0zL0JWEsan37zz1Jc8VsReRwR02wksY7aVZKe1YtIRDxnhQ7a9vxqzL2Qrif6enAZ0zYQUSPSIgMwn6lRKY8QuDGSh+zk6Ml6NbZ6LqFunUvVP/ogXX8tuPIIeNKPILjTV1x+ukgEai/2c2t96s6j2LzVykxhcqdQrzGjBXjM6+CLdKj1gha/ry7Elf2GHT42SwX1le2qSALNG+7fc9W6cqt5UyhhgKKKdcelfbGkFXiZhwe9iZl/MU2j/vCLiMdugRvKUl3AGoxuIkHvSbcPA4cw7jmXDoYS9id/1N957fkzjIPnqq5FY1siQBzhl2RXmegQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=766AFai0HNayYevTj1q9gwP6IvmEQSOQ946rMln4PTQ=;
 b=bSF1FNE7aV+36xXkX3b3+1iBJEk1kRIdEa6Zj+kcWQpXAOXVIEuzWM8N3DRvSdqXH8stALlAKs5xKz1jIHSyeTUu8970lZpSOg96h4b5qgnYzTovWKeUP/S6cvpCisOC3ivZxyC1TetoaHLPYZy5C4HE2+w8iSLKChukZW7r/w0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7163.apcprd03.prod.outlook.com (2603:1096:400:356::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Thu, 2 Apr
 2026 07:19:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9769.016; Thu, 2 Apr 2026
 07:19:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"ping.gao@samsung.com" <ping.gao@samsung.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "rafael.j.wysocki@intel.com"
	<rafael.j.wysocki@intel.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Topic: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Index: AQHcwHPS0LRtMwK95kC+/vV31GyfvrXIZE6AgACkNQCAAShygIAALO+AgAEDLwA=
Date: Thu, 2 Apr 2026 07:19:06 +0000
Message-ID: <3094656066abda37800ac293e46682b009526a8d.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-2-bvanassche@acm.org>
	 <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
	 <6f4d9e81-b300-4603-9032-e2604c0b099f@acm.org>
	 <4a4f2054634ca20195467c0869ba88251b13e107.camel@mediatek.com>
	 <7e700ec6-3c91-4afe-ad1f-1769c23f8c6b@acm.org>
In-Reply-To: <7e700ec6-3c91-4afe-ad1f-1769c23f8c6b@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7163:EE_
x-ms-office365-filtering-correlation-id: 10b460ac-0bb8-4b4b-c4cf-08de9088208d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: InXVUb0IazugYYULpABh5Taz69htNnN8/e8mPr3Ed4e+DnooUTqK6EnXpHP7pJGAN/KHbOJRNEPkC//dp5WrnxwfEbMzGcHV7mPgtlxMd7QY7bauFYmQdSj02fXprsaSB8dA1bVOKNxHu/5JsqNXpBigvD57QmV0LaaKW+KkrQwvKtJNAyLkAervLv0v3LRmZnK7oNjonNFfUTFkxiMGFgpihsytFdD8C/VtyoKto6BrKn+TmPKAftVU17gP4c2HKfg2iflnKv6WAiKfchNA83THTJRR/inYxoajh1MDqPdmRl/A5+V19xA5ffwltbY/kGVusXiEUgA5ApYw2mAkNH6uV+ni6KOyP+WYI/+GZBKDJTyqYx+rf4bZQl4TVq6SQ7JpF2No6IZ9qU9fenhCb0Jzc7+FmjFj0Raay9SsQG56LjdT0NqTefpL3nBBaX63Cc3L25y7CR0/GSiKS9epf6jSc3ZNlAxP8Io8+/aobapoSFs6d3m7+suSk/ULMFdIfwnYLDLxykxwDyqmXYtXPO1Tm3MYufpnz6vLOJhl9jBXAwZdzBxZZHRFi9xqHNnXL1+ztK9wk+7NIkas01VO+ZccWOK5tuvQdllVsW7YqJZD+4BTY4NrOIODdPTDl/OiqoP1ce4zYQsKtEulRUhDt2YU03O3V+V0jGr6MllxBPMC1EHgMmwdUwGQQWn4muL/RwyMQ5ZDlCLHycJ/a+6SfkNrmE5cgbCrRSdeob5H8wQ89WwZwOrhvB9p1SRCW/CG9w9k+oJ46GKAegKbb4uGnr2wWkrIlAwWtZ8mQD9xcL4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFU1dURKYy9pcG1KU0RpVXNwckU2ZHg4ajBVYW80T3crcWl0dnJLVWh5NVBI?=
 =?utf-8?B?RHk0akUwbnk3bnd2bEdkNlJoaFZXU1pXdllnQ2tkQThuY2NQQzBXUXA3Nmxs?=
 =?utf-8?B?U1dUK3dKbHFUb0pBSnltQ0JjUkRTOTZwTENZbCtXQU1ZZjhLem5Pdk5rYUpL?=
 =?utf-8?B?ZEE0bHc2TmNHZTA5WWNoZ2dReFhKTll4dHJTZHI0eHRMcHhKR00zL2hWTjFy?=
 =?utf-8?B?M3NPT2JIamFkamwwalhoS2JPTjFLOHdBZ2oxYnZBMDNYL0lhU3UrMi9VZ2Ix?=
 =?utf-8?B?S2x2OXRWMjlyTHlWL1RUc3k2T3ZNMXJSTG41cWZHaW1lNzdscTFpZ3dlRjBr?=
 =?utf-8?B?NmV1dnEySDRURkNmZmg0dlVKZG9pY1B1cW5KK0RoRGgyRDJLYTlOZzhYa3lU?=
 =?utf-8?B?U2RTSEErbm9Ubmg2b2sxUUozcG9mb0EwVHVHamNmbzh6aTR4WmE2N0xFeE8y?=
 =?utf-8?B?Wm5HTnR3ZXU4cWh0Q3FxemJ2ZW05ZG5QOHM5NjhldVlKYnQ2a2JZNXpYdThy?=
 =?utf-8?B?ZkFTZlZieTFYY1NzK3RpSkp2UFYxdGszSlJMWnlsWHNITGczOFJvOUVYcU8x?=
 =?utf-8?B?OCtrUTFadGswU2I5MlZZOEkzaW9lVUhrdURuZmFicXZVZUFvcUN3OUxhZkxD?=
 =?utf-8?B?ZGdncXdVaGQyajR0QXRSbFVhYlV3NkZQRko0TzZTS2JaNTBJQ1hMYkhmWFJz?=
 =?utf-8?B?KzJoYWxTN2FEZnBScDVWVDRsdGV5aDVrcHlOWldnaWRXR3BxNmZFYkF6Rkdl?=
 =?utf-8?B?aDc0dmc3UTRWZ3dvYUpFTjIrcnE4eWtDNnBVMzJPY0Q2RnFoallEVGIvYTFF?=
 =?utf-8?B?cXdMcURvZC8vRnlMU1M2UmhNenJCU29iUzFnYStVQ2ZJRTJnRjhXK0FKbDhh?=
 =?utf-8?B?UjZaMENsZVhUOWxrYVhyRGNPczRaalE5SDBab20zNHFjMHFOelpsVHBtQXZB?=
 =?utf-8?B?RXJybERoRy95TW1oVktSdmx4eWxOcnFkMkZGemdRZEJCT09Sd0FkM1BLTWsr?=
 =?utf-8?B?VENsL3BwZUhJbUtDZmZrMjdUUmp0dy81Uk1ZcEwwV3p5RlJBcHd1MzNyMXNR?=
 =?utf-8?B?K3FSU1lLcUFzTUwzb2ZnRzcyL3J1Q1FEMXl4cUlPWUNBbCthREtpN3lrZ2xw?=
 =?utf-8?B?TTc3M0lzM2R2UGU5bVZtWnhtcXh6Mm9QK3hKNmk3Rmg5SERCUGh1VXpERDc0?=
 =?utf-8?B?dXdROVpBWCtnMXFEUVNXNEc4RWJIbzVvOWkxQjg0TkZyTDVpMlVDWHJNV3pU?=
 =?utf-8?B?T2RYcXdSNWFlbVFvQkVndW56S1Y1VDJQRzhUNEt4cGNka1RuYU1RaVlmdk1H?=
 =?utf-8?B?MmxIek5GaHBhQWJvMERPaXdFd0RYQlgyclpHODh5RUIyTHJ1TktXY3ZkVjBI?=
 =?utf-8?B?bXpzeTRrbmlncmVhUmUzc2d0YWplMm1DVktpRkdiYnYrdmNyNE4rbHlrbzUr?=
 =?utf-8?B?TzN4R0hLQVNvYnR6WmZpaG1jV0M3cnl6Zjl3NEZLYnZWT2E5dFBjcGxLa0Q3?=
 =?utf-8?B?S2NHbU1rRVkvRVFqYTI5SENRZkVRSCsyMUxybTdTNW5YZjNJZFhZWUo1RjR5?=
 =?utf-8?B?Q2tacXhTWS9CSDBFUVA4NElFUWM1ZnhUNzlVRkdkK1hrcVNrUTVWU0dpT3By?=
 =?utf-8?B?S25ndlFWWUxCZUk1Z0Z5Y1hWK1d6RTNuQ2VRVExXaXoxTU1mSmNRZ2hkMmwr?=
 =?utf-8?B?aEMrZm1MbVJ6cnY0WDRNRzBML0dlU2ZTR3U3d0FiVVZNTlJVTkIza0liVTZF?=
 =?utf-8?B?NDNoYWM1YTYyQklwOXhGanRoejZHWS83RUgySzF4Z3Nic29QRjBuOG41Szhh?=
 =?utf-8?B?ckxyWlNQWEtRcWZTQmw5MXBnaUdkOGxTd3pDOURGNW1DRkQ4MXJET0paTTly?=
 =?utf-8?B?OTUvZlIxcUI2M0xkcnBOblY3U1MwNHNScmRQLzVLMFVqUkdWYUVLY1JSU1pT?=
 =?utf-8?B?RUt4MkdZWkl4bDlTMkhnTW5Pc3h5TjgvaGd0ckRXUldMRmoyVzZ0cFhLZWdn?=
 =?utf-8?B?SE03bEZ1OFp2YXpudWMwUEJqM1hYaFNJY0hzM3M5VzErWnJRRFd6VnlTQmFN?=
 =?utf-8?B?UnE5YnlaclRua1p1cUtrNjVaclhuYmx6ZGpsMzArQUVqeXhrRW5HTC9xbXIy?=
 =?utf-8?B?czI1RVhOZkJpYk0zVThPaEZmcEdvNXN2dDRndVFneHZaM1dTbVVxRy9xUmJr?=
 =?utf-8?B?YWcvUDg2elg2R2k5VzdFc1htUkpxbW5OdUZIRWpsZnQ3ek9URlJtdjl2N2J4?=
 =?utf-8?B?MkNQK24zSm9BclJPWDZQei9NbW56cVZQWElYOW8wY3dnR0UwdHJrR3dnOFNL?=
 =?utf-8?B?STRIaWgrMjZ3QjNuU0JEMVErR3l0eXg3eThncjJtNjkwd1JwYVBOd0xpRzFR?=
 =?utf-8?Q?AJNYdRV2n4JSRT68=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE2A695FEFD70440A6E99ACD5A913198@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: T7sFuX12bvP7wyZUQiFnbk9XhyIC9WY0wWNuqgGPmDHD/EnTSWjeFUNcJvRXGd5UAnULxMaKbxplWMMUc4nYqqGxDTcdN1SIxtXzKVHCE1kdY4k9vvCcLAu7UGcQAD3mKb/Lf1BDnbkbpylp3vg47M5VNCkZ3DfTPxYKyF4mF8atM8nXHU828SndpG1dtTlWV/3xJbxYcZJMiV0Nw+iZXVQeuwVeCXhKlHcQ4tzBqhkwn2xHOTuTFsT09glNl660yKBTDRnaaz55UpgEQbqJWl6UZXSp9nnzJnzvfhNQmct0iOgdMIoFi5hWJH9qDxr9KglGVEkKZuvsdxE6d3rxPg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b460ac-0bb8-4b4b-c4cf-08de9088208d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 07:19:06.9279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOM8QMqmQRw4oO/2FgI2tuMjRGEGSK+6o1aWJyaXf7/DWqGcCBtowdjmbIrx5Mxsl+aY5iFFg1PG6B4M67x/Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7163
X-MTK: N

T24gV2VkLCAyMDI2LTA0LTAxIGF0IDA4OjUxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGUN
Cj4gDQo+IEkgd2lsbCBkcm9wIHRoaXMgcGF0Y2ggYmVjYXVzZSBJIHJlYWxpemVkIHRoYXQgaXQg
aXMgdG9vIHJpc2t5Lg0KPiB1ZnNoY2RfbWNxX2NvbXBsX2FsbF9jcWVzX2xvY2soKSBpcyBjYWxs
ZWQgYWZ0ZXIgdGhlIGhvc3QgY29udHJvbGxlcg0KPiBoYXMNCj4gYmVlbiBkaXNhYmxlZC4gdWZz
aGNkX21jcV9wb2xsX2NxZV9sb2NrKCkgcmVhZHMgdGhlIENRIHRhaWwgcG9pbnRlcg0KPiB3aGls
ZSB1ZnNoY2RfbWNxX2NvbXBsX2FsbF9jcWVzX2xvY2soKSBkb2VzIG5vdCByZWFkIHRoZSBDUSB0
YWlsDQo+IHBvaW50ZXIuIEknbSBub3Qgc3VyZSB0aGF0IGl0IGlzIHNhZmUgdG8gcmVhZCB0aGUg
Q1EgdGFpbCBwb2ludGVyDQo+IHdoaWxlDQo+IHRoZSBob3N0IGNvbnRyb2xsZXIgaXMgZGlzYWJs
ZWQuDQo+IA0KPiBQcm9jZXNzaW5nIGFsbCBDUSBlbnRyaWVzIGluIHVmc2hjZF9tY3FfY29tcGxf
YWxsX2NxZXNfbG9jaygpIHNob3VsZA0KPiBiZQ0KPiBzYWZlIGJlY2F1c2UgdWZzaGNkX21jcV9w
cm9jZXNzX2NxZSgpIG1hcmtzIGEgQ1FFIGFzIGludmFsaWQgYWZ0ZXIgaXQNCj4gaGFzIGJlZW4g
cHJvY2Vzc2VkLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KWWVz
LiBOb3JtYWxseSwgaWYgdGhlIGhvc3QgaXMgc3RpbGwgd29ya2luZywNCnVmc2hjZF9tY3FfY29t
cGxfYWxsX2NxZXNfbG9jaw0KYW5kIHVmc2hjZF9tY3FfcG9sbF9jcWVfbG9jayBwcmV0dHkgbXVj
aCBkbyB0aGUgc2FtZSB0aGluZywgdGhlIG9ubHkgDQpkaWZmZXJlbmNlIGlzIHRoYXQgdGhlIG9y
aWdpbmFsIG9uZSBpc27igJl0IGFzIGVmZmljaWVudC4NCg0KQWxzbywgYXMgbG9uZyBhcyB0aGUg
aG9zdCBpcyBmaW5lLCBtb3N0IG9mIHRoZSB0aW1lIHdlIGp1c3QgdXNlIA0KdGhlIG1ldGhvZCBi
ZWxvdyB0byBmb3JjZSBpdCB0byBjb21wbGV0ZSB3aGVuIHRoaXMgaGFwcGVucy4NCg0KCS8qDQoJ
ICogRm9yIHRob3NlIGNtZHMgb2Ygd2hpY2ggdGhlIGNxZXMgYXJlIG5vdCBwcmVzZW50IGluIHRo
ZSBjcSwNCmNvbXBsZXRlDQoJICogdGhlbSBleHBsaWNpdGx5Lg0KCSAqLw0KDQpUaGFua3MNClBl
dGVyDQo=
