Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A61E868
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 02:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757558303; cv=fail; b=uB2/xft3cWEg3dAQR5eF0E1+iyJR+rL46dI4hYqfh4/lJiJgA2r7P1DGi354asYN4kyxNVImhoAI9pQIyHOuP5aCoUq/1Q/h0boDZXHxP3cMm0Rgubauq8UmD4EamrhWlh0PK2Y6duCozwWs8+vUDckcCtfceuBL0YG1KMk2UkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757558303; c=relaxed/simple;
	bh=dYf0gkRPwANaip7+VCf5VflHS4zl8TADGQwoNkbevaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dnpkuwfMTRbQFPU3PCBKInQGqkCNTajkVY/GsHbjwcAlBZOkoWltojnHioZu2hA89BqJinEH7X6RyEZLGSX8xLkXa9jBx+ejYbZ1p5OXSC/kDaeZUNecTKOFidj5jL4ooHEtMTxEUbrCajeODJkgeKqfKFaeuvEZQbQnhuKjs8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kfEDnV6k; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ITnXF+Pv; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kfEDnV6k";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ITnXF+Pv"
X-UUID: 5e3894fa8eb811f0bd5779446731db89-20250911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=dYf0gkRPwANaip7+VCf5VflHS4zl8TADGQwoNkbevaw=;
	b=kfEDnV6kEx8MBgIRnaZM16EV61/LTcCAlfuj6gX7nRr9ShfVpWwPqqpr+kHsi0YDgQRqvXexHX3m6MGhBa7IFPu6sV2keQPr4dk78EPVDQQKdr6vz0M57Uw8O6P9htJoJLreXkpnoFx09yr77k62N5KUhlGHxtkIeaGMAuZknkY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:a9ff9964-d9d1-4b3a-b6a4-9d809475b488,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:130da984-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5e3894fa8eb811f0bd5779446731db89-20250911
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2111773459; Thu, 11 Sep 2025 10:38:15 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 11 Sep 2025 10:38:13 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 11 Sep 2025 10:38:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPYHVTFTuBxr+nhWaiZ/B1Fg2br6doFDa1BiAEWF+ISjh+mrt5mKCCaIurj8gq2B9AzbuK0AInaa8/LKSEoD0dbWHz9zK64mfpwgiOCFPpC8A+2xvMbJTGrWx/3G5iy4GPsQWNti5VCXWmTjXmuHfGK8URMtKTzurWUFE95PAPkqDT3Ha8oHE9jKPmBMcZ1G50ueIa5OXsBx9YO1cvujqTC/PGj1MqXvyqyViF0BrjeH95ttYih89aEuLbGmKmRRWwuiFGArq4YwKT9f4gxF2gcFtLDSsp4Ey15BbKX/Z97Ouua/MvHVd23C3CXEvTeKsvBs5MjohCg2aNqMjiX8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYf0gkRPwANaip7+VCf5VflHS4zl8TADGQwoNkbevaw=;
 b=sB7kVe2ZCX2Hi+nOXmMOEl1Q+DViANMfLLWXkKduqRJ4xolReEJDYPfehiijBv8aYzV5NSd1Uqy/DNle0OFW9d7g0RJaqO7oMrjfzNMSyuzfdsK4j1DD0lhENHMry7Xr2zQiTusHGwlTqFmkbYaGJyGNbfS6XNUdlhwp1rVWm23tTDSpEYROG4aLtXyRreqjoV52cp9AXqPK3DNzZop0hcwKI1iNZCaVH3/ihSypxTAGua+oUuDi8/X4N4BwK1KYrRelaJnoBZheP/8t8nP7lQv6foiqOiR6jqaeVFYdGcrYP2tWd+KddfMm6/bLswA4rQ2Nz6Yg0g6PnL463P05ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYf0gkRPwANaip7+VCf5VflHS4zl8TADGQwoNkbevaw=;
 b=ITnXF+PvLJAoj9SNiiz8bHeUyBnXUSx2VWJ8H5zrt3hcqWv2N2xm+9zWhMOfXFIl93k6DKeY479y/Mg5WbOR+e4NADDzWlk2Ii+WPq883f9FL4HgYXHaqTNOd8/CM5ZM6UGv4ALEHCEecRei+8dSI6e/4qTWaHuPoIJnBr+6ojc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE2PPFB8E7763EE.apcprd03.prod.outlook.com (2603:1096:108:1::4a6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 02:38:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 02:38:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "quic_mapa@quicinc.com"
	<quic_mapa@quicinc.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
Thread-Topic: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
Thread-Index: AQHcIbztwIFSSd40j06CWZdmUZA8fbSNRr6A
Date: Thu, 11 Sep 2025 02:38:10 +0000
Message-ID: <3d09e0ff60640528b3113308c6d28841afe1635e.camel@mediatek.com>
References: <20250909190614.3531435-1-bvanassche@acm.org>
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE2PPFB8E7763EE:EE_
x-ms-office365-filtering-correlation-id: 35d1a7d0-58fd-4526-1cd7-08ddf0dc3f7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZUlaUFhkbWR5WGE2YkRsNjN3NXBzMy9ITmRlMXR0VUpjaUNnUFlycWFWamtn?=
 =?utf-8?B?Vk52TDc1dnRJdFdVVGR4L091MmtGRkVTT3lwZm9PVDNPR2kxaTVGS3hySURE?=
 =?utf-8?B?VDRpVERmOWFzZzUwR3BNMXVVMGszZmlpcStZWDVOQUQ3VUgwVnJQNE9RSG9Z?=
 =?utf-8?B?WGIwSFI1U0JVbG1xNWlVbzBaTkl5QmR2cGZmYTh0dXJoaXVUb2RBYnBjK2pU?=
 =?utf-8?B?T2JTc2tYVnJ6dHhNOWhvRDNXaHpjUWlmWXY4S2ZNTmhrRUdCREtzYTRGTys5?=
 =?utf-8?B?TTE1WHRxTnc4bGxMUWpQSDAzengxS1NDdFJKVVhvRW5ZZ1YyUW0wNmhyWFFl?=
 =?utf-8?B?Uk0wcUNhbGFFdmdtWVV5Z2Fpb1d2L1VzdkFjSDRndlBtbGVmSXJiU093KzEy?=
 =?utf-8?B?Y3VpQU5WRy9tdVZUMG1DRzlQVjlRdWhqbERpMDBlaDhVaEhSVmsyT1V5dDRQ?=
 =?utf-8?B?eU1rNjhCODJBdXVmeUpFNFMwbXZlaGRxOFFxSUx0Wi9NdUdhdVNNeGJSUjRT?=
 =?utf-8?B?RDZkWVZGRlUrbU9iTHB3ZjNWTksrZkhjWTlMd2lJbzN1emt3cnYwQjZKT2VD?=
 =?utf-8?B?WlJZbit6UjcyTjdwSzdSTUp2ZFl0Q1gxQ3JRa213SE1Ra3ZUTElkZ3ZUOU5j?=
 =?utf-8?B?Yld3czdua250REtwRnVKV1g1VURWOUhOS0NvV0RIblc3SHkvODRwVkJsdnhm?=
 =?utf-8?B?aGNyQ205US9UNWhWdkFrMnR5ZE1XQW9oYW1qUFo1MWlKcjhGbHFPWFpHQ0VS?=
 =?utf-8?B?ZVZIZm15SW1pUGVlZGp1bE4yaHBQMnNuSjlXeXVhaTd2N2dWcGkyM2krWERE?=
 =?utf-8?B?dUZaZ3NMREZFLzVUSmN4SWFDQU5FWEh1TGN6d0pIb01xUEdZZkswdFNTSFR4?=
 =?utf-8?B?OVF0Qjk4VU9oSzVicTY3SUZ5T3RsVnFFeHRxV21qSndKZXNwZzN5QU9KSWhL?=
 =?utf-8?B?aTlvMWxyY0N4Zy8zck94QzkySThxS2p6d25FN2ZBTjBRR2JQbWFOc2tBTndv?=
 =?utf-8?B?R251Q2FwY2NYWEY2dlZpdEt4eXpPSlhrRlFjRzZEdEx3UGg5TWpVdnVQeDFL?=
 =?utf-8?B?THR0YXd2Y2VMODhRN01EcENKRFEvL1hTV0taQ0JqQy9xVzBxN3JuZ3F1VEY5?=
 =?utf-8?B?ZGY4ZGE2NENvMDJiTGtObENiM3F0dmNjbm5iaTVsdXp5KzcwaEovLzhPY3VE?=
 =?utf-8?B?T2Z2VGdkKzNNS0ZabnFFMjVhZmsyYU81ZUx6VmkwUmlIajIxdHFKQ1FSTlBP?=
 =?utf-8?B?NU8yZkhweDJoVTFKRklYS1VBcEFlbXFCTTBuWitsNjBlNVZKMkJ0Vk1XQi9P?=
 =?utf-8?B?ajFZQzBpRFgwOXNkWHNzNmQrYk0zUDdtallna01CYk0vdjcxcGhpUzRUbkV3?=
 =?utf-8?B?TW9Kd0MxbkkwZTBnZVZxN3d4ekNXUnUrVkJiMmZ6dVB2UjJCRDRrbm5GTUtN?=
 =?utf-8?B?WlFYNGpQVVN4T2Rxb2hkQWpOWGVEMDFDa1N6bDlMbkJENURhbEtzQzh5bUY0?=
 =?utf-8?B?QVdReEUwNkJpcThLZittZXBRMDdMbDlCSFZmRm9sc1FXRUQ5czJyMkRjRVBP?=
 =?utf-8?B?UmF2OHhQU2lOS3BxOVhpRHJXdGNGVG5USm9ZNVRFRkdYVWZmdDNtUjRRcW9C?=
 =?utf-8?B?WGhocTRKdkhLUkNNc0N6TjVQbE1ZKy93MW1nVExwNFI3ZmdhZFN1aVR6S0h3?=
 =?utf-8?B?R2UxcmxZVXkvU0tzQkk3bzA4UDZBYmxBNm1KcnpMQXJvK1hEL3ZRRm9Oeklr?=
 =?utf-8?B?YUxQZ1RlTHphVWExdlcwVHQvM2h6eUVlT1F5aGFYK3FIQjk4cElpR3N1TlRu?=
 =?utf-8?B?MUFBNk9zbi9nSGM2STA2d0hYNmVnL1ZzZDNmcFNENGN4TXZEV1RZWFlHeG5U?=
 =?utf-8?B?RTJGMGtBMmRCU2NKeS9xdEcvZGFCbVFldWhoTTF5dXNaS1c0VDQvTGVLT3lT?=
 =?utf-8?B?SlVpeDhhMWtWVmdZTXZvWmVjUVgzcmNISEpDclgrYzFVbkdCd2ZSMFRRMHFZ?=
 =?utf-8?Q?M74pMQ2tuRJdwRAicQdGkHo5I0KEuw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cG1uaHlXdjd1ZDRFVmpqMEpZamx1T3BxRkdkOFloRWVZcGdWQUVXbGJqbzhn?=
 =?utf-8?B?REYyY0svMUZLaXZ2YWczSTdPcFpsQ28rMzlMWW1TV1hsQkMxbm5scHBnZlJW?=
 =?utf-8?B?NlM2VkFhbHlNU2VOZjhqSEtDWkhjM0R2ZlBXaHp6QXVaWWhiUlJnMlNYSVRo?=
 =?utf-8?B?ODZETnNxVys0TG1yVjRkdW5KYlMyMGhiRXF5dyszS1lWemZvNWpXSHlIY0xy?=
 =?utf-8?B?WEp3THhoaUhibmwvVlFBTlVBKzkxaC8zOWtMSStTcmlkUm9aN0VvQ2pDd21F?=
 =?utf-8?B?V1JJRWN1WEFYbjhPeGd3OFlZWXRpVUJLMm9QeC9kU0w5cmtRek5HS0xOUjJz?=
 =?utf-8?B?RndFeitOSStnSUZZb1VIbG10Y1lzSWRaV1lsVUhCZDd0YXNVK3h3TWJhbFVL?=
 =?utf-8?B?WXdGbWZBNGpTTUUrbGh5a0U2eEpOMlRHZWZoMEhGbURZL2x4dnA0WXBmSWtY?=
 =?utf-8?B?MEZZbGNMcEtxMFdUd2lDVjFtQS9tdzBjTjBxR1d3NU1oTHU2NndjdHRtSUdh?=
 =?utf-8?B?dUhFMFJZamZtVlZ5aGNDRW5PSXdxK2VKR2VmMlJybDZtOGxHRWxJWk0venpQ?=
 =?utf-8?B?Y2ppRWM3YVAxdk90YUJKTmRtcUh6MGRiSzhFS3BKa0ExYXFIZWNpWi9JblZG?=
 =?utf-8?B?bm5kSG9RcTVCZkp5Lzg5aGczWElwMDNWRGRJbkF0UFhYbVFTNGpZZlJCaUJw?=
 =?utf-8?B?dTQvdUZjS3VIVno3SUVCWGxkRmdaZUIzZkVPeTVjVDYwcXhrOFRWcmdpbXE1?=
 =?utf-8?B?amxsODczRzladWU5Y0dsaGdFRTJ6bnhVb0ZGSmNRWU9kak1nbUNQYzE3Tm90?=
 =?utf-8?B?SUx6Y0tNOEZyYW9pK0F5YXNLdGoyc2kzVjZ5WlduQUdkeERBSlE3Q3d6dDlB?=
 =?utf-8?B?aHhFN1pwL1Q0SWlrVXBhTyt2endvRm1OK2JPTmlBcmdpVnhvdjY5b1lWOVZi?=
 =?utf-8?B?Z3FZdGg3dFhjYnE4VHBmK2JqUjJVR24zclE3MzluR21DS0MwRkVidFlXMjJ6?=
 =?utf-8?B?Uklkb0pLSFdsSGRySWRjYzhlLzRoc0Q5MzVXNXdZUEZmNHllWWtyVnl0Unkx?=
 =?utf-8?B?NUl4N3hhemsyNUNDWSs0VDNkOUtXL3ZFeTY5UEVYcDhEdTg5Y2xHNGNQZ3JG?=
 =?utf-8?B?TEtaZ1l6YWJLSVpyeThlY21YL01Nby96VlNRVXdoNStGVXBpbVdMUmFxWWNt?=
 =?utf-8?B?U2NFTEtxNlBhdDFsZVNFZDZoMUgvUENiaG5wSng5SnNJR2NxUGxqYVFwVnc5?=
 =?utf-8?B?SFoyQ21aVnZ1eGxyVmNkc2VxS1IrM2tjdWJxSEh6RXE1L05zOHFaVE92dFZS?=
 =?utf-8?B?VkxhTFVlekFHYXpwdmhQWEw0VTBxZUxvR2VPTkQrS0E0d294MDNyTE82Y0lU?=
 =?utf-8?B?aENocERhc1o3ZmYrVWg4L2JrZTAwT2Y5a29kMjlWZ0JacmdSR2N0c21aQVQw?=
 =?utf-8?B?L2N2QXdtMm5sNGNDZ0cveURveDZVWXBLU2I0ZUZ3d2toOXFlcG1DVlhDMTZY?=
 =?utf-8?B?RnJqK2lsTEljMmk4TWhxdU1paytPYkZPSS9MM05VcjVjS3NiMk9vTm43R3hX?=
 =?utf-8?B?OXpzTDQ5TGRoUElyTTcvdVkwakkwcUNZZUtsUytMRGZKTFpVNlVHZVZhUjU4?=
 =?utf-8?B?WmRmYU9UT1BHbW1VNDQrWEhqMWFsMjRuRjJWUEFhcWR4Y2doQllTVzc1R1l0?=
 =?utf-8?B?Rng0NjhqVjJmK3pCc21lUWJDZWd1bkxQdnRMSUNJbkplN0RDTmp6ZzZHM2sv?=
 =?utf-8?B?dVZyNllCQXdKVnhVa3VLdDlBWU1tODNuYk9OTFJSL0V1MTRjdmpJY1hhYUlO?=
 =?utf-8?B?ZzkwbTFGSWhJZTRzR2xDMVp6eU9JcmhNa1pqODVUNXAveWxWY0M0TTcxL056?=
 =?utf-8?B?anJFcHZyNVNQVWExL0hGRVVkTFRzU1FJeU5aRzdGbjlOU3o3V1VJYkxxN01v?=
 =?utf-8?B?V3lhRndNM0picm9ZckhRaFBxaldZa0lFdThkMHRudEpucmdXa2gxNDFCWDRy?=
 =?utf-8?B?SUFNYjVUUlJRWFBSQWZES1E2VVVKbWpUeUFmV3d4TjJoZ2Y5bytzcGlxK0oz?=
 =?utf-8?B?MURkQ3FCcXdUSG03RCtWYnRGNEtlcjRPdktqZHdQdDV0VVJYL2F4YW9rQ0Za?=
 =?utf-8?B?K2QyaTFOSzhhSkM2bS8wNzdXbnBRZTM4dnJpL2NzS1JFNVNiQlFYdEdpbkFG?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFBEBD93297C904CAFA94D67100912FE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d1a7d0-58fd-4526-1cd7-08ddf0dc3f7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2025 02:38:10.4732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dZtYoTZNrcj+hjzurJVfqeViDAgIFU4wjwzwUTfUrFwMIMisnN21gzoKnn8lHy1obLRTegpaiYZdAOruqaipw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPFB8E7763EE

T24gVHVlLCAyMDI1LTA5LTA5IGF0IDEyOjA2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFNvbWUgS2lveGlhIFVGUyA0IGRldmljZXMgZG8gbm90IHN1cHBvcnQgdGhlIHFUaW1lc3Rh
bXAgYXR0cmlidXRlLg0KPiBTZXQgdGhlIFVGU19ERVZJQ0VfUVVJUktfTk9fVElNRVNUQU1QX1NV
UFBPUlQgZm9yIHRoZXNlIGRldmljZXMgc3VjaA0KPiB0aGF0IG5vIGVycm9yIG1lc3NhZ2VzIGFw
cGVhciBpbiB0aGUga2VybmVsIGxvZyBhYm91dCBmYWlsdXJlcyB0byBzZXQNCj4gdGhlIHFUaW1l
c3RhbXAgYXR0cmlidXRlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxi
dmFuYXNzY2hlQGFjbS5vcmc+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0K
