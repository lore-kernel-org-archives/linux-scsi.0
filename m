Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7E200CD
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729500959; cv=fail; b=XhYdWcgs9ACT92prYzIsknK6Xd2X+nNDzlh1Fr8POzUSP2lV8SbNBd/kt9/zLNCSXSkLErx47YqeReh9l3zpqI4pnUxryeLYSpl+DCWcr6vXTEyAQCvJLpSRCK+D4OtVnKVG5iZnNL0P2NfJsiPtt7J5A6Vwl2RUdD8xe+xFLOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729500959; c=relaxed/simple;
	bh=wmsB/MWr4a6wej2gqwtWM+QesUitZPm13ZRV2ToZgho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bo7kC13z0tZYByiBewDoX4T68r+xttkgHi2e6UHmzZbJTZdGjEDpEYWr4Ay0x7yyFxSgew6IWMbolGltlfKgMy+nI3Kwywq80+KVU3JT9eQMuRUYSvwBEWhTXKFqHSkS35pRfE9yl8rTdrFM8db3nX+VdNG4zun8JG7V6W9iGvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=K2lTrORk; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Z0XdopcL; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K2lTrORk";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Z0XdopcL"
X-UUID: 46afb5d08f8a11efbd192953cf12861f-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wmsB/MWr4a6wej2gqwtWM+QesUitZPm13ZRV2ToZgho=;
	b=K2lTrORkYGSriSdSAXpdedaBoV7g1A/Hf9S+rPUxwa6Nk7z0b4+KtvnG2eP3086FeA2xb41oVYRntWHs2YIM8JmBilFVGPjbi6OQNPxxpT6olozn+vam9vqwvgq70s0ClTpxZZs4T96H6mMd4HfzozOGPNpWVs1mGtn4R/jP0/o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:798b47c9-5b29-49c5-8e3a-3068a176874c,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0fcdc3,CLOUDID:77a41f0d-1043-475c-b800-3262c01ea3e5,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:4|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 46afb5d08f8a11efbd192953cf12861f-20241021
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1697678990; Mon, 21 Oct 2024 16:55:52 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 16:55:51 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 16:55:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nreBUWFdJlNgFGb5rC3RUFaxl6DT4yh471P7MaDZeZ6cuIhUfDsGasWEIBzJnZPaJlQRaRFhGGQI7LCWGEXopjkZonXqgCvwfRThKwEmrzz+51i0Pynfs7lt4NFel/W5+aPi1lJHlGb05ibclS5sJKrP6uIDGEODFvlR5biuKC6o8JvKCnKB8CmD+9mEGAi8iAkASzZWSPm2WUCT3sC0MwW0BKBPtxHt5MwVmQCnKW5Tb/PAeS1W/+VUqDnUGVwVnq24G134sSjT6ELsnBYf6XepmV5M3pM0bBGZc1eSRPezhjjMYcGaB0URFhBAFURSe4E3aUCHN5tAwjYbhVSKxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmsB/MWr4a6wej2gqwtWM+QesUitZPm13ZRV2ToZgho=;
 b=i+WKYACPOi857saaG6sofIgAHXU6qgJIA8iCz1YXUwkbL684QMRBUSYsvfPFIDTuauWLbmNwjvBDVzrpNfPAMozaouIQDRVHFs0itfitgRzu10LVBQQFRrzBT/qxzWNuJMS1zPXOPXFT8PVG4j0i/UdFjaQzbGe9JW2o9m+gMEH3DJsFbPXqE6pMqOtHqNO806YkoZIWec4wfqj14nbM64CwSssMF5Qql04gDKKS3dgUOHLgUZRmeJg80H2l4lzj8tcxuHW3E4e+OutEwZEGk4AoTIYxwOP6MA84KcC2p4PujsIwakwM3XuRrS+yXnsuVK8o6HZ1ShiBEn23bvRQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmsB/MWr4a6wej2gqwtWM+QesUitZPm13ZRV2ToZgho=;
 b=Z0XdopcLUi/ock0HrEcuhFeHbMGFHSk26EiWffD42hrky5akqDaGcxfEL6z3GwCZi+X5/tFLgO9A63hOg1fLuguF+6kfZFKj4zp5on8zSXAQxveWD33mlkYJD4D7/g0ieyzCjDxZ1pYvRS2Oby1HPE7wuJti0lnRxpyPh31HWAE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6768.apcprd03.prod.outlook.com (2603:1096:400:200::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Mon, 21 Oct
 2024 08:55:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:55:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "rohitner@google.com"
	<rohitner@google.com>
Subject: Re: [PATCH 1/7] scsi: ufs: core: Move the ufshcd_mcq_enable_esi()
 definition
Thread-Topic: [PATCH 1/7] scsi: ufs: core: Move the ufshcd_mcq_enable_esi()
 definition
Thread-Index: AQHbIBAiEIZ4JQUAR0i5E9RyPuvxQbKQ7emA
Date: Mon, 21 Oct 2024 08:55:48 +0000
Message-ID: <5115d780bb67260a3a78ad56d9813ad4ba35b9cb.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-2-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6768:EE_
x-ms-office365-filtering-correlation-id: 214c17ab-984b-4b88-30ab-08dcf1ae2857
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NStCK3paTEhlK1BCSDBpZ2pKZ2dCQk1hYlErNkFCd0U3eTFIV2JuRk1MMFlj?=
 =?utf-8?B?aCtKbm9DN3NxVllaa2R4UitCNEhSV0ZpdTBuMUczaXdSN2U1UklhaFBRbkJj?=
 =?utf-8?B?QXJqZ3pVRlNYNVg1T1NRSGIwK0hkbldlQXhPMkdSeWtva0crdEI5cVM0cFIr?=
 =?utf-8?B?VFBYWmFnN2tnMHpSQ1l5NHVXTmYvMlE3UkNaTW05OVh4U3I0Qzg3d1FlaVpM?=
 =?utf-8?B?OFhOTVlCT0FpZ0EwODc2elZmTXYrODRCbWp0VGRlVGt0alc5SzQ1ang2cmJ2?=
 =?utf-8?B?UmxobTg2MXJGMnUyRTcrRlBrQWNxTnpERDI0cXdNd3pmMzZ3SzVyQkVML3Ba?=
 =?utf-8?B?Y1dtaG9lZUVvb0R4NU1JOVE3WHFlWXZKK2I4d3lmNmhlb2V4a0xwN3JqSGkw?=
 =?utf-8?B?VWpLOXpkRDNJZ1FjTnFPUWhzYmE0aHorMGhuYTAyVVd4YUNsbU02VVRUZ3NG?=
 =?utf-8?B?L29NMzl4T3JQOFVQTFZPQTV3cFR3ZUpGQVkzLy9vaGRscElrdVhhcUR2M1dF?=
 =?utf-8?B?ZWRnanJqc1FJaEZGMlV0bHZleUI1dTFpN01KYkcrR2xUN0ZMeVFFKzJCWWJq?=
 =?utf-8?B?SVM5Vm5oMFVieHRXUVZ4TXlIZHhZODlCaUNqOXpvWXF6eVpiazZlTUZlYWRz?=
 =?utf-8?B?VWx3L2hYc0FuRkt5cmRBbUtQMUlLREJqRkgvOTJ0SXUyY21CcWhHRi8zdEh5?=
 =?utf-8?B?OWgxei9IeE8zM3EwaENNWHJCd2FoWXQrR3NPRUxMOGh3SGVyZ2xmTk9TeUNz?=
 =?utf-8?B?UWJWQTd6SkVNYXhZMFZQbUdoT1FUOVR5eGtYNnJNTzJ2YkVEalJnaUVtdHFI?=
 =?utf-8?B?VERMbDFRRlF1SWVBc1U0UDZYTWRJcy81emVXVFpwTE13T2h0OTl1VDR6NzZx?=
 =?utf-8?B?Wkl6MGk5czlCblhZeG5oOVBQZHZOSzY4bXQrY3ZRenpIbEJ0NUkzVW9DeStw?=
 =?utf-8?B?NFp4RUdnVVd6OVpDOHdsWXQ2Vm9idFk0Zy94WjY2RWN5SzhsK1hlODdQTnBr?=
 =?utf-8?B?YmlmM0kxT0c0OEplMlVlSEVyVUVwTk5Ta1dxVURBRktYc0hPTGpoWEhWc29H?=
 =?utf-8?B?VGIzdDRPOW13VExoTmNDTUk3WStTWkdMS2NyYmZMZkZsUThnWUNlUmhaQXhk?=
 =?utf-8?B?dW5Oa3g5VFdUcHQzd3B6U1lBK2VOUEg5MVBIdHdub3dmZ3dPTEZjTHFIT3Vj?=
 =?utf-8?B?Nmp3b1VnWVdkRDlPWVpQQzU3RnR6YWQzTE9RRCtyRklidnNDOS8zSlJlaUlX?=
 =?utf-8?B?QmIzd3kwbHhqcUF1QjQrak9VYXV3alQwVjF6MmVsMTRBdnZ5bjdyVWtoOWNl?=
 =?utf-8?B?ODhmc1M2bkNnMUo5QmNVMFArdExPV0RHV0RVWFJ1SlpDS0tkdUsvYkNCTWxK?=
 =?utf-8?B?dGlMZ2s4R25pY0x6Zi9LQzl1SVNDUHpZRXZaa3h3TFhWeHM3SE1iN3V3YVJJ?=
 =?utf-8?B?em1GYXJnbUFqK2F1STl2WGVQQVROdzNaajFWQkN0YUZ1NEM3aStPSEpMdTU3?=
 =?utf-8?B?UWc5dTRPdGdhUVZGeE1zV0p3bmphZFZuTXYzUDNQS1g4b3hBbmJFcHh6S2JO?=
 =?utf-8?B?Ni9EN0cvNzdKK3g2MVp1YTB5amxRUE0zRmsva1BVZzhDd0FMMTRJNGlpdUo0?=
 =?utf-8?B?eUdJRFFBYWJYT2RrTEhrV0F2cFBhNGwrdU0zSy81SWJDeFNHMnBON2ZUMnJD?=
 =?utf-8?B?UmgzbnhEQ1pqNHJHbmU5VmNGYjZsaVNCcVNRZHRhUnpYdHJXclVXQVJQcUhK?=
 =?utf-8?B?aVEzcWliYTZTemJFZXhZS3NIaGtscFFWT2VRU0p4NERDSTNqbUdPRncrR0o3?=
 =?utf-8?Q?T1VMmmm8Cox7mgBb9XQpfW7r5j2koeW7PjbDo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHNuVEJJSXNqRUZJNkdaYjg2Y3Q4K2YyZjlqZHhOZmxzQitkS1hOOXJjbjN5?=
 =?utf-8?B?ZmhKRTRFQmhxamd4TFdzNjlBWUFBeWF1SS9QbW5LMXR4QW9SOXBodWphZTJZ?=
 =?utf-8?B?bjYvT0tmbUE5SkxCa3pZWU1UUUJYM1NMT21oUytnbzlaK2FxYzM5U295dXVH?=
 =?utf-8?B?emxNWGl1UDQ2SjhXMG9zeGpxMkJNZ016S3k0YUFJUEYwbFR0VlBkTGIyZ05w?=
 =?utf-8?B?clo0MFNEREpDMlJGSEliVUJMRlpkd0pmSjR5S25rN2RZRWNySVN4RVlhTVo3?=
 =?utf-8?B?K0xBN0RsSTJiVUllb1ByeFJZK2ltS2ZQNmJiRXgxc3FXeFZoS2RybVQ3S01O?=
 =?utf-8?B?UDVVSlpFdVo2YjYza3EwcHVTeEZwQytSTVRLZXpkTFFKc3ZmT203V09tQXhz?=
 =?utf-8?B?b3J6M2NVUHlOUkN6T2FlenJ0M21UYWdSRW1PYmNFZ1FYMXBHS0tPMjRQdzhy?=
 =?utf-8?B?WW5CckNmQWxNOG5GTXVWMTNmTC85ZC9ibFcyZkVMTzRzWEdESEFYSjFOWUJr?=
 =?utf-8?B?c0pVZEZyeUxORjhzbnZQbmkyME15NHZWcG5XblE5dFZFYnJLYVJDSkNBdGxt?=
 =?utf-8?B?Ly8xdEpOMHE2Lys1aEcrUzRoc1VSM25ZdkpHdzdUZlc1L3h4S2tZUXZzRUFP?=
 =?utf-8?B?blNnY0l1ZDkxT09Pbll6YXJtRjFURFQ2RkM0bFRwalVvVGwwdEdPOUlVN3Jj?=
 =?utf-8?B?YUo3MUtaYnRBTEVQYTRsQml4Z0k1MGM5cHJ1MzlPNHBab2xsYWZiYXJMRXdL?=
 =?utf-8?B?TitCNmQxdDIwcGRWY1VKTnJNN2xweXdPQkZBM29FR0hsQnVwaXlKeGQ5eEVQ?=
 =?utf-8?B?R2dVdGZRdHVaZk5PWjJ0a0NvNlo1cjg1M2tuQW96S0NDQnFFbHUwK2g3SGFy?=
 =?utf-8?B?YlN3Qm51dTc1Q2Nibjl5ZXhxSWRSeFFJRVBCWHEwZkZQZ1BXNDBMU1hmMjE5?=
 =?utf-8?B?ZEo5NTFXTjVnNFBubVpnYXlqU0VlUVB6YTlvZUtkOGxBUXNtWUNTcC9XV3Nv?=
 =?utf-8?B?Wll0dlhCSzl2aUYwdVR2RnZSclVrb2V1U3VNeWVaT2dWa0ZWSWFVRjU1a2RD?=
 =?utf-8?B?S1BUWklCemZwZS9hZ3NxUFRKMnFkclgyS3pFdTJVZ1dWUXcweFErZUROV0Ji?=
 =?utf-8?B?N2s1T01uQ1JaRUFrbFVDcmN0emwrR2tNbG1mbmFmZENqZnpEYURrNE02WUpi?=
 =?utf-8?B?OGtBR1ZzL0EvTDJ4RSsydXoycFQ0TUhiRXduZXlBTU5teTFYdFZGdEpzUFB0?=
 =?utf-8?B?amgzNHVseCtlSW5EUFpFTEFxeWN2dUhBVk8vc1NRQ3V4OHc2YzV5S3VLdVc3?=
 =?utf-8?B?dklmZWxDWDEwNU9wUFFRTjdTME1DNDBnUEsycDBYZUVBczhBUkpmaXlib1Jx?=
 =?utf-8?B?WHJwT2lhWFVwcDM5dFp5S0E1aDl1d0wvTGo4azZpYWl1UElTdmVWRUNJd3FE?=
 =?utf-8?B?UkZKWXpRUjB4Z2pWKytQOS9HZHdRSDVNTmNhNTNxQmluZTIwQ2d6b2MvWnE3?=
 =?utf-8?B?S0ZmelFwNXlqMk9Hc2c1S2RYaElZU28vWDVZS3pGMlpDNkhlemhVYVBFOFMw?=
 =?utf-8?B?YkJqc3ZuOUhZWEdGTzc5SUQzRVFZR1V2NExMTU1ZOE52L1k1dWVMcEVRNm5D?=
 =?utf-8?B?UGRWREVxTldCeDFEeFdXbHFOU1pFa3UyY1hDcFEzWERzV0Vrb0RKUTNGeGV1?=
 =?utf-8?B?Yi9DdGVyaVpiZlo1YXVqMkI2N0JoaDRDdjZNMjNpcndhNjVWSk83dyt3eUlz?=
 =?utf-8?B?eXhnZCtseE5QekQ3Q1RWWUIvZklna2FBU3pnaFpQaHF2elhodGxPdnJUd2I1?=
 =?utf-8?B?MTJvcGdpWi9qemU4M2tYbmg3TWNPZE5zdHF2WHNCTFFuclRXR1hTcXN0bE1E?=
 =?utf-8?B?Z3Q4b3J3UktJT1gyVVljTVlaTkQ0TE12VUo3bUM0bmJOclNDUjA2QTNUZFlO?=
 =?utf-8?B?UTFWanJIY0sxUWFwSVZ3bXQ3VkZtNVV4ZHpuN2hnTGQ5eHN0WWZKVnpDbmRq?=
 =?utf-8?B?QXhKbUt3UWhlNWw4NG01TjdzcVFHZmhUeHJ5TDZsN3d1WHJSZ1A5dC9jWnBI?=
 =?utf-8?B?aTlkM0dkZnA5dlE3WXVmZTRlNVV6Yk1wQ3dQdjJjM3VCWklsamdDYXNSbTFx?=
 =?utf-8?B?dGFHMyt0aDhJTDNETUh1WDcrTy9UWDRPejN6YXNxU3FRcGhXNUpOcVhvVFZB?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC4C42855995314488368CD30F89AD7C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214c17ab-984b-4b88-30ab-08dcf1ae2857
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 08:55:48.3052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CD/nMo0fhZJlG2S4jYcsDSaVDrcXWcKObsQIOwCzQxzrwEoszspMiD/214a+sN6Ldf+XUD/b3JKULXMTIB9kGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6768
X-MTK: N

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDE0OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTW92ZSB0aGUgdWZzaGNkX21jcV9lbmFibGVfZXNpKCkgZGVmaW5p
dGlvbiBzdWNoIHRoYXQgaXQgb2NjdXJzDQo+IGltbWVkaWF0ZWx5IGJlZm9yZSB0aGUgdWZzaGNk
X21jcV9jb25maWdfZXNpKCkgZGVmaW5pdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQg
VmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2Nv
cmUvdWZzLW1jcS5jIHwgMTQgKysrKysrKy0tLS0tLS0NCj4gIGluY2x1ZGUvdWZzL3Vmc2hjZC5o
ICAgICAgIHwgIDIgKy0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KDQo=
