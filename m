Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75D1F4C8A
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765244; cv=fail; b=D5t87h8xDgY8dpHs1imhDee7pET04You/5W6Rn5YWGJH4Wb5Hdt8x98Az7kf9AZ5rqM4fGMqXaNRseHbKJA25jLI+VLoqphHbvfdhFtbYFt2C0OMHz9TcnsRosyk9QJOSvQ6e2IOJVxTK7MyQKNL01/en7khMnjIyEdaE+fU/FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765244; c=relaxed/simple;
	bh=D5EEyzPa8LZGUZgLrdeym0ijCrOqosq+EBdCa3kWjII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F+7xVyDqdMsOoFie2j57WRps/OgfksMtTZGKiZA5vIQ98Mfzwhvj3b2CmWvyPeeI5hGYxj4EdEtirNJZ8ydbBLvaaOv8VYe9fPPHxhq+vZkulJc/U5SMS9qqCZl81R0mj/2PEpYHB35wMKS9JFf5e0zqc7mewXnSruRIq+yuUyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fs8EBqUA; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OF3NdHZR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fs8EBqUA";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OF3NdHZR"
X-UUID: 48d3a876ff1511ef8eb9c36241bbb6fb-20250312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=D5EEyzPa8LZGUZgLrdeym0ijCrOqosq+EBdCa3kWjII=;
	b=fs8EBqUA6qtStZ5JEKjIsaptLQd7wWAr/BCZS9wrcxHKWPIrSwMpQA0glg3VOBPpbGa5H0TbgiPQ9G3lPYC7IWPxLeDv15yxJovOQ5h13O8sJTkoJH0Qd02sKX+AkY+yWo9erszsqac9MxqCreKC3/6FK2YFkZUKDgKjOvt4x0g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:2f3a872f-3055-4617-b3ce-5788ee91a668,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:375e014a-a527-43d8-8af6-bc8b32d9f5e9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 48d3a876ff1511ef8eb9c36241bbb6fb-20250312
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 528596340; Wed, 12 Mar 2025 15:40:35 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 12 Mar 2025 15:40:31 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Wed, 12 Mar 2025 15:40:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+yZpI898KOur/K+T1baa0CPDKyG7vZAFRv8swxWq13A84Ydz5GKq7vdghkldqnEL6oN//XlpU9tsAMHlzydqAZcMSc4Q9SfNtvHRUWw6yB/3ZSDCbFUaJoZgVBJm6kerP5JLDRXiSKZgbwUI6f3m6gzJnkK3VNuAZFotaySdFC1Y4QoZJEjNIREGMX9c0W6kk0kiwOenShfdMcTZxq6be2zB3USt+pwSbNtGsqezrzRPGLWjdwyEGAFSvelwS5a2EXQ/QO2InZAVwje79rRhHCCq1IOUJ6vRYZSWHBQ2sZgny4ZMMAn7oJe1WSrAVm24thtahxxyBYnv61Ia7C1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5EEyzPa8LZGUZgLrdeym0ijCrOqosq+EBdCa3kWjII=;
 b=GvfnVihDrob9/L6nc1etvIgZ/Dav1cAWgDCw/2aEzwhzYwRfTHirfPjhyrGE5arrRp8CpTRdQlhAWzzDOA3rfRITN4+G6kFkI3d3mgEmLiZrumH4Y2M0jhVG6Z5R9n6INhxpi3z9Q+QX6RCH8QQqQxaZvBvI7nAe82OAxaGffYH1w2GbLdGfUoIPPdApvVKBWpCH+NDIBk8quatbple5TkjAmW4+bvJVJjGtgwe2m5Us3YvAb3yYpsaAzNG21w7Ev+UYIsvPSrdEFMoPR0tPx+jnmg/DlFKqyQzKDOj4RHCO1Scu60pQ77Q6o9qvvmvOMagduwxPdMAFcorwKXaTiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5EEyzPa8LZGUZgLrdeym0ijCrOqosq+EBdCa3kWjII=;
 b=OF3NdHZRe9N4BapM0Y1kRGTaGhdkSRb5b1j96WPiP670yvegMPfNYI10cq+5b/phLzZHM+mlnUz5aKXfSGNjGyEJl0C4F7PLo2IQDh4nhBJRHqTZBk1O8TIAztKjEcdzaDUdyfDuOAuFYem5a+FF0z42VmgWUbr9YZzrDSgGD+c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8734.apcprd03.prod.outlook.com (2603:1096:405:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 07:40:29 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 07:40:29 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Topic: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Index: AQHbkr93pEGS8YZmHkC6xyj/wGdwgrNvHo0A
Date: Wed, 12 Mar 2025 07:40:28 +0000
Message-ID: <4a09a365e5724c3262b5622b679449a0d18f22c0.camel@mediatek.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
In-Reply-To: <20250311195340.2358368-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8734:EE_
x-ms-office365-filtering-correlation-id: 54f7c960-be9a-4726-39cd-08dd61392938
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S3FNYTdnOUZobmlRMG4xeFpRSnV0TDFYN0VEa0FtYUtsZm16L1R1ZTVkSzRr?=
 =?utf-8?B?Uk9GWlR2a29TVkdwMHZlRStaclQrd21tWEhndm9DQk5lNjQrakR6TVFsdWk0?=
 =?utf-8?B?Q01jSDVYaUJRdEJrT2JkV3RHanE1UUl2NUFGNjBaMnZvckVNR2JMK1EzUGNZ?=
 =?utf-8?B?YXZKbzNMTEMwTXBhdTV6VHJKTUtkbFpLbEp4dnh6eUtCM21IOENkUmhVdFZn?=
 =?utf-8?B?N0xDV2Foc1kxTXZjOXFsL1p2QW4rOUJrMGZEbHYrTEZrY0UyS0JrNDl6TGFh?=
 =?utf-8?B?RGRlelBRVFBnd1JyMWZHOFAwam90WGlGaEl0UFRlNHF2dGVnaXhJT0RTYnB5?=
 =?utf-8?B?QmFNbUNQcm9keEl6SU1sRlZMTTZCUVd0VlJyR0dwM2lsMTdVQXE4Uy9la1B4?=
 =?utf-8?B?WFZ1aXNyT012aTBiYUpwNnFRVE1kNjJZUDVNVVB2Y1FsN2JPRzZVZVprY0U3?=
 =?utf-8?B?VDU5ektvdHo1VTVoSFd2RENndXZ0SmNHRjh2S3JjTlVlQ2ZaQzRUMThxLzNJ?=
 =?utf-8?B?MXRnWU43bzVpRTlrM3NVd2hTeCtnQyt0TExqdWsrNGtRWUZ3WFdoSDFXS1V1?=
 =?utf-8?B?TjZvVVU1ZWRTc256Y3c0UWlCUUFHS09xb1M0V2Y3NExYNU94STVzM1BXSC8w?=
 =?utf-8?B?QlBFdkhidVZmSUlXejd1MkIxakF6TFFBdG9ITEVOY0RROEoxamk1L0daTjlM?=
 =?utf-8?B?UVhjaFdGRXFxNTVRTGphTWcyQ0FEWjloK3hxSEFuRFU2SGJCcUJTVElYclRF?=
 =?utf-8?B?TWdhQjdYMklPeWdESUFUZjlpY1JFN0N5VC8wZW1penRseGF2L0p6TUtnQ1VD?=
 =?utf-8?B?ZEJWdW9Ta1M3b0JtTWFXQWcwTkQ3Y25tTGUwZkJia1BXeUNZbDFWOFpzVTRv?=
 =?utf-8?B?REp3ZWVrSnNSUnpuN0F2UjJEQmJxTlpGN3VXUi9FbG8wT2wzdHpEdzVXZzZC?=
 =?utf-8?B?WmZ1UmM5aVd5QTVTakJENlJ1c2l2VGpuOGg5MjVsdCtQTU1LamdvODJTb1hM?=
 =?utf-8?B?UG52SytjRmZTeUdsZzg5N2NpYnpHV1lWZ0kveHpXZDMxNVV4a1Q0ZHpJV1lU?=
 =?utf-8?B?N3hwZlFWc0Q4UzNaS0xEbkRzYmNiZjBEMmM1eDI3OHRkQ3FFZW5hSVBTdFBn?=
 =?utf-8?B?dXV5cCs0WXd0N0d5TWREKzFDL0pkR2sreXg5dGRoc1FEOUp2bEx6MGFzSTBk?=
 =?utf-8?B?Sk5rMDMvdzN0OHhBR0dibnBMSUxYWUF4VFZSQ2pMZDV2TEpKeUcxRndJVTJH?=
 =?utf-8?B?bUlmZk55WTJBK1J1RnNOT04yT2JtUzFKdTJPOEJ3Qmc1aUFyOTRVdHdWV25Q?=
 =?utf-8?B?VWsxUlRGVTlNbjFFYzFQSEZGV1lVcEhicVlrc2JjKyt0dzg1WXlYcDVqeHJN?=
 =?utf-8?B?SnE3V05zRlRIRHZZRUdSRmMrK0VGUXhXSkJySHVRS0k5Nm4xQ3g4UkNSZXRO?=
 =?utf-8?B?Y3hPeXdhV0Z3a0JuUzlXeXhlYzhwVU5vMzlOeVQ2R3g0SUhFNzVrblFxRi9l?=
 =?utf-8?B?b0t4NHNyczQ0K0ZOMjZNUFVITE9WRXZ4R2V5TXRyR0ZhUERzd1pKTEtXZ0Ja?=
 =?utf-8?B?YjRySDVLUXFSWXdyZE5rY29hTkkwNzMrWVlGYnlNWnB3TEkvVFJZcGEwbmZi?=
 =?utf-8?B?ektmSmxWTmZQRXhRYWJ3enRSRnZTQ3NsZVFaTDZxaHlXTFVXYkkva29tRFRX?=
 =?utf-8?B?UnhxZm9IWkNSYmhwWWJ2NWVPVkFmbXk4VzBZWUFUSWRSV05FMFZRM1ZScVRt?=
 =?utf-8?B?SXFoRkpEb1VlM1VXUUFPUlExbHZFVlJNRHA4cWEzcyt3VzJLRCtRQVVWTjhR?=
 =?utf-8?B?UmYwTXNSRllNK1ppU2xDOG9lMExOZTJvc1VZd0VxdkFKRlkzRmtBOWxTQ0Zq?=
 =?utf-8?B?K0U4WjQ0TnNzS3o1Z0IzZ2lSUTREZjYwTCtTV3lGQjlmOXl3OWFWbElzWHJ0?=
 =?utf-8?Q?LywGmvXH8nrLUZZVYjuXmAgOnCFCL1eg?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OC90VGpqaFBDcE9CbUl5L0RqZUJuamtkTDV3WFJxZ0M1Ui9JVDQvTXVRWWF1?=
 =?utf-8?B?TG5wT2NsOVQzblgrVmdQa0s5RjlJSm9wdVJoTE0wVVdjWUxJbHZiYVZyVXh5?=
 =?utf-8?B?NHJFSTlQMSszbFNDN1M3dGhEWmU3QTBVS2srUHZRSUo1R3QwRmUveSt4a0E1?=
 =?utf-8?B?eTgrbXBVYW9HYUJqbVIzdXpybHBYZjNmaUNQQUk5K0hKM21qbU5mT0xoR3BG?=
 =?utf-8?B?MHRuM1Z2VFlCTThYTDhSS3pkc1pQVE9XdmM4aUhYKy8wSm8wNFVVNjBvbnhM?=
 =?utf-8?B?UVBBMUtDWmhrU2xXVUhhcC9rUWRkV1k0bGE1OXBIUmVmODlBamg3WkZ6MHZv?=
 =?utf-8?B?TjR5bmlZYmk5VXRtQWFHMHpCOEFHM0l0Q1QrNUJIQURwV1FBTFNReWhGV1Zh?=
 =?utf-8?B?MXpYdEZMNERoNmFQSmZDaG1JMWpJRHgvY2tyMkNjUVZJMnQ1RjFQdXRZTWNj?=
 =?utf-8?B?TXF0SU1PWjd2QXVvSjV2Y095N01IN2k3TnVvVkVDUnAwNjZWbHd4Wk1rN29F?=
 =?utf-8?B?TEk0WWc3SkZBM21XdEgxT2VqNm9PTkg3SldBZEdsSDZCOE9JaC9FRkxRSFpu?=
 =?utf-8?B?NE5YczJDQzVWblBvVkM0dWtFcUtLdmwrcmQwUk05OVQrQWM3SDZnMGQvbW96?=
 =?utf-8?B?aDJMaThpNHpPOGdCYWRVb2pUK1NVTnNsclpDOHhWenMrRVNDWDFJUEsyWVhi?=
 =?utf-8?B?d3RDcEVTT1FCcjVRMzNxblVaR1o1QzlpdDM3UWFrYzNZWENGTE5rY2tkTkM3?=
 =?utf-8?B?N3NZQkI0VDBxZDFmL05EcTFqMU5yLzlqTzdXY1YxTGtoZU5GaGRVdWU3ZUpk?=
 =?utf-8?B?am1saGt6RTc5dWFQbUI4akZ6NG9vZ1F6VG43VkhEcHY3Qm1EbEpibUprVjA4?=
 =?utf-8?B?cDMvaEJkOWEydTNyaUxTNDkzL3BUelFoRkNXcnN1VnFxTVVvc3A3MjNNTlJX?=
 =?utf-8?B?S1hVZEx5T2pOcXAvZEVkRkpBVHJsM2RialZvZjF1dkFrQ3NCY2tjemY0OUNq?=
 =?utf-8?B?bHhFNHVlV3FsdnQxbnR5NGZWZTVFWnRuVVMwNWtvNEFKeFFKV05DZlU3ZllN?=
 =?utf-8?B?R2luSERwMHNMSHgyZHRYYnh4d3o4cnRqUytWbmNGUVUySmRnNFF2elpMRzhS?=
 =?utf-8?B?c2VENktyekJCVTA1L0FiWm51SnNxOEduL0tTR21HRVVCZHJKWmtWRnRlUWx6?=
 =?utf-8?B?VmhtOHFBaUpFRE0yaEtFSHR4Szd4OEV5VzRDeUpuTldSOG5lSG53d3p4eUIx?=
 =?utf-8?B?eTdkYVVzWEVmMm11a3BYL2oxby8xZmpYV1Vwa3N2Snc2WHdnUlM3VHZEM1NM?=
 =?utf-8?B?eUNXVEZXeTZ4VTE3RUlwLytMT3B6allOS2xRMXVjc2hwTUU0dHd1eGZtSmlz?=
 =?utf-8?B?MjUxbno5U1ZlM1JoRTRrMW1zTDJyNGQ3N2pZbTVJMG5rdGFTL2pyNWlWeGxB?=
 =?utf-8?B?RTZUNXV4YUFzbHJoLzNmYTBGb0Jwb1Q3cjVDT2p0ei9jWFl6NDkzMG9CZlJw?=
 =?utf-8?B?UVFoR2NKY1VuaFpXUkZPTVZiUGNCUEdxcHZMWVl5MWExR0NBZXoyRzkrQkQ0?=
 =?utf-8?B?RWt3c0FFRWhuRHY0OGlUY0FpeTE0S0tSZ3QvKzNtZWgzQmRpV2p2UlBoY2Vr?=
 =?utf-8?B?eC9qKzl0a1FiWU1yVTRXYjd1em4wd1BUL2Q2MHhPSTJrYnJPWk5mc2ZMNVBh?=
 =?utf-8?B?a2tGVm8wSG84b3V1SlpNWC9qc1llWU1oREdiZ05wUFdpcm0yMXFmeU1QYStp?=
 =?utf-8?B?MXRYQ25FUy9WNGVRQjdqNnFnNkNCd0F3LzRFZmE5endiYmd0b2R0WFZzSnM5?=
 =?utf-8?B?NldmSk05Skl3YW1tZ1RhQytxVGlwYlh5Zi8xUmZUTjFOU2gyMS9CZVBSS3N4?=
 =?utf-8?B?SHdoZkF1dUFoZm55S295bHhJbGpGV01aUWVnczFoQlFZclM5MnlwM040MElz?=
 =?utf-8?B?ZWJLNGwrdktVK0ZpOE8wOXNCeWNPNlhPYzZid01pbGpaSHNqeHY0SEJyMmtk?=
 =?utf-8?B?V2FmR21iZCtOeVdQd2N1aFRNSHF0MEkwZEJpYkptQnhuQXhUQjVybTVGRGZY?=
 =?utf-8?B?U20xV1lsVC9YN0gzeGdEOXIvaWxDZUdsMno2OGQvM295dVpxZldZdllLdDJN?=
 =?utf-8?B?Z05Sd3JQd3c2L1RmZ2tLY0FtQTFiVmgrU1RXTzUvL3Jja0lzZDhqQi9vOFRs?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D23DD3EC35E3749AECEBC4722B78B3C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f7c960-be9a-4726-39cd-08dd61392938
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 07:40:28.8795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7AVezUcJcoxz6ekK9jFUeghQU/jiaZiLpOWcWUUVpLu+pVDXF45uITSKiCSUPX/EmbRefZymcGKxUEUvjN+GqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8734

T24gVHVlLCAyMDI1LTAzLTExIGF0IDEyOjUzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gQEAgLTMyNzIsMTMgKzMyNjEsMTAgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2Rldl9tYW5f
dW5sb2NrKHN0cnVjdAo+IHVmc19oYmEgKmhiYSkKPiDCoHN0YXRpYyBpbnQgdWZzaGNkX2lzc3Vl
X2Rldl9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0Cj4gdWZzaGNkX2xyYiAqbHJicCwK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25z
dCB1MzIgdGFnLCBpbnQgdGltZW91dCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgIERFQ0xBUkVfQ09N
UExFVElPTl9PTlNUQUNLKHdhaXQpOwo+IMKgwqDCoMKgwqDCoMKgIGludCBlcnI7Cj4gCj4gLcKg
wqDCoMKgwqDCoCBoYmEtPmRldl9jbWQuY29tcGxldGUgPSAmd2FpdDsKPiAtCj4gwqDCoMKgwqDC
oMKgwqAgdWZzaGNkX2FkZF9xdWVyeV91cGl1X3RyYWNlKGhiYSwgVUZTX1FVRVJZX1NFTkQsIGxy
YnAtCj4gPnVjZF9yZXFfcHRyKTsKPiAtCj4gK8KgwqDCoMKgwqDCoCBpbml0X2NvbXBsZXRpb24o
JmhiYS0+ZGV2X2NtZC5jb21wbGV0ZSk7Cj4gwqDCoMKgwqDCoMKgwqAgdWZzaGNkX3NlbmRfY29t
bWFuZChoYmEsIHRhZywgaGJhLT5kZXZfY21kX3F1ZXVlKTsKPiDCoMKgwqDCoMKgwqDCoCBlcnIg
PSB1ZnNoY2Rfd2FpdF9mb3JfZGV2X2NtZChoYmEsIGxyYnAsIHRpbWVvdXQpOwo+IAoKSGkgQmFy
dCwKClRoaXMgY291bGQgY2FsbGluZyBpbml0X2NvbXBsZXRpb24gb24gdGhlIHNhbWUgY29tcGxl
dGlvbiB0d2ljZT8KClRoYW5rcy4KUGV0ZXIKCgo=
