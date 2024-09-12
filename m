Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6921A76BC
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147641; cv=fail; b=sTlb62zBILWj7p2olkm9TXS8oMafO0kyGiXjk2odXEgZYk52uMVGlHqgtM+Yi3sgkrf25k5cMcBbE6jjhakq6bvw6lprmKrjMRHZyaRchLEYOpRqIZ8bLaHTpuYsUK9x11bDdbhZAuxt0xrPB8uMboqPAxv5YTw4FxwfoC2wN7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147641; c=relaxed/simple;
	bh=LAT454siQP4RusQLpdgcAOCLLaialyZTZxZrSsXWeLQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UQnLx62+DY2ldvw7Qxe1dAAcC4Y2r+6aPlpH6R41nBe1097mLrRuv6ojYJsrpSdMsXvyMlreKmvLrEWZuD3AVFdRXYUuZV8DoDNiTW44MUulyK959MRGpY+ZKy3a0UYFKuh+ZreQV/fYgzbslZaXZoe6+Bq7bX4ErDGVA8WiHQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Maa1ZBAi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=PX4p+NHR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Maa1ZBAi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="PX4p+NHR"
X-UUID: b5aa31a2710a11ef8b96093e013ec31c-20240912
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=LAT454siQP4RusQLpdgcAOCLLaialyZTZxZrSsXWeLQ=;
	b=Maa1ZBAiS0KYWzgNXC4QD1Gje3dxrDuQcCzcqwEb7uy4F4ZoUZq+wkNOYN2AAhQB2KXcTxF7oDK/on+gqoXH08TRQVR9bHi98l7FDKJ+/MFAO1pXSdkqTwz17hOWdko/DC0K+WzhSO6duVIjFVSP5lVhk3PmBg5Lj+817KhZH7Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:871179bb-e3e8-4c09-a2b3-d976d38efbc6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:2c0fddbf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b5aa31a2710a11ef8b96093e013ec31c-20240912
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 484907785; Thu, 12 Sep 2024 21:27:08 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 12 Sep 2024 21:27:04 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 12 Sep 2024 21:27:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UY3n9nwsfn415/QNFiFOt0G+OFxt5JguOiosBIG6V5wY6ufbjfUP8F0iEAfQPxAzmxDqsZiM4Z6SSEgL+fYuNAqNs+hCvo58eTWaJnpbMaa+HVrhNH9BRk8eRSn5k+C3inJp5P6tBW4jFArkzKThcWileQ7BHdHDbCqa5y3Nn+hPI7iogkXpcZb2RuaCI/WfQpl4utoPslV35LKtP8hZYfMZvDNkk6e04C8cxlxYQastreRxF4KrATOH03fmL+QN+zqTfFvxLHBlGkH6Gi2Iyd1HnT0ilKBkU9Ero5LL5ssa5uWYW44leNqpLKIb9NFFYdc1P0dZgj2ikxoGkbq86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LAT454siQP4RusQLpdgcAOCLLaialyZTZxZrSsXWeLQ=;
 b=HRcpNFAx69/LbkQh1Vkq3pNxKTjaZpx4H6LVRko6HG5nqKInG+9fnn3EGA/MfrNXcUlrt3ay0eBS+psX/lyWJd1UEUrgx2ru/BQJS+hF7b7P+bgrUAKp6bsNgBkiWCTyROACJeOvI8I5ZrOPgN4SOyR61oz/cIKGiTemdjoKhPLXDRrL24mSoKUWaR5E5VHUbmHuGta8ekDVXfG3HyejlMtXGm+a1p6wgvLv8lJJLCJ9z8BAEJyFRwHf+OJdBZTRl5+BO4RAxcHuTS+1/pcOaMZU813JbrSbe0tBGG+lF0415HOC6BeJ3Ch9j/Bha3SbJy4bmtiYUmq7D5uBW69kzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAT454siQP4RusQLpdgcAOCLLaialyZTZxZrSsXWeLQ=;
 b=PX4p+NHRM7F24JBv2zUQw8tMiPIw/bnXf9U/KtnCw8TnZt/WanZnAeKuZiH0r49gCvMAIKQtd3bVmxDWUWxtZSIvu2dlYLtwc6eTjJ43Xh2lYjm3JQIIJgOwX+q4zbJsk/f4XHCNLwxmy+2jRQKDVQ0wQ2TN+84WLooKAAXLzcU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7897.apcprd03.prod.outlook.com (2603:1096:101:189::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 13:27:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 13:27:00 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH v3 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
Thread-Topic: [PATCH v3 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
Thread-Index: AQHbBKsrgvEVCVvqTUSdU3OwpKeP7rJUJY4A
Date: Thu, 12 Sep 2024 13:27:00 +0000
Message-ID: <d9827ee4adf5049ba27e857de0815b0006044147.camel@mediatek.com>
References: <20240912003102.3110110-1-bvanassche@acm.org>
	 <20240912003102.3110110-4-bvanassche@acm.org>
In-Reply-To: <20240912003102.3110110-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7897:EE_
x-ms-office365-filtering-correlation-id: d6a5956c-dd9f-4bac-6c31-08dcd32e9558
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Um1OL2RRU2JkbDBTb3E1VFl0ZGtRVjE3eG5acXNSY3Q2ZmVjSXVXRllvcUxh?=
 =?utf-8?B?Y0tUMk1iaU5jNC9JQU91MnpyL3NRdU5YL1NrUldRanJWT1JpQjBLamVkZGZR?=
 =?utf-8?B?Tk1wWG9XeHJsVE0yV1hXUUtQTFRJbUNEYU9zK1FCQ1NrTmRnUUJkZkFJU2ZO?=
 =?utf-8?B?KzV4UmJVZlY0dXdCMjhPejBkRklNbnRlZURJQThQYjJOK3FxaktzZDJHdlB0?=
 =?utf-8?B?dk5RYmdsMUtUR1kzTmwzK0grdUNxb1NXVnNBVHRVWmpqdU0rbGs1b2thSllo?=
 =?utf-8?B?L0ZuL1JDSzFweXBCYzN2NlVzcGo5NlB2eFIxSUw3Zm5mbUlCNSthNlhYcVpY?=
 =?utf-8?B?NWEyQlpHUEVOanJ3RkFaT1FuYlN3SURkMlBuY1ROK2U4WXdMaUNsSWEzbUNP?=
 =?utf-8?B?Ymk1bUpKQzFoaE85M2NCd21COFEwU0hnZlNBcGF2aUJheWwvcFErZ2dqVGpo?=
 =?utf-8?B?Z1gwd3dTTFdrRW9BN2hUYW9YeXlWMExWNzcxcjRRZVlxaklucmhqY3dySkF6?=
 =?utf-8?B?MEw4NWZBWVlRdnZyT0JpcjlVVTcxR0FmYXdJUEE1TDZHcFZLQ05DZ1dBSTM5?=
 =?utf-8?B?a2R3dm1vUzVmdnZ5cGh3a1dQQTF0a1pUMDlxd3ZzL0t4aVBOS1lhVk5nZE0x?=
 =?utf-8?B?TWVYQTVwUFQ4QVUwMzF0cjMzK1QxbW52a3FsdGdUNFBUNDlybEtiYjZkSHhF?=
 =?utf-8?B?RnZ4VTJ0ODRNTVdLS3lUSEFSUXJmWnA4N2hQcndDZ2tiZWR5TE9HdEIydEk5?=
 =?utf-8?B?aW9XditMalZUcHlJN3lpVHd5N3JjcDh4QzJQaXBoMzZMcUtHTHBDZURhdzJq?=
 =?utf-8?B?aEpRT3VEdFJvRGFrZ0NZek1JZW1SQ3BpUmUyS3B2aUExOEJGd25McEdtSk1s?=
 =?utf-8?B?VkVtNDZXVEVweEZIdGU1QWIzaHI5c1NxdytVNVdWYzhBL2Z1blRBYUg5YVpj?=
 =?utf-8?B?QmJtb1ZTRk1KK2ZTdHVkMUpTRWRDSzFmdjN3R0d5UEoyeWlKWElCMHdMdGJM?=
 =?utf-8?B?YmRVWVFoMHkzbi80M3RQZHN0QzRwRFdMeE9PbUthelNhU1hzVC9FTGI1dTFo?=
 =?utf-8?B?NVZKbjIrZVF2QW05TEdXcHByc3lSS1VuQUo0by9kaE05ejY4VzdTTWJxWU1w?=
 =?utf-8?B?dUc1ME9NaGcwbVIrcTk3NFdwVHZTQzcvODZYaHhRNTNPOUpoL2gxWm9iOXN2?=
 =?utf-8?B?bkxPZ2gzQnl6eC91emREL2RkWnRrb3g1VjQ4b2orU21KQVNua2V5amdLaGh5?=
 =?utf-8?B?akk2dDFlWTRHQjl6dnk2YXV0cElyallGSkFaRmZKWkI2ZE9CQWtvVExIdkE2?=
 =?utf-8?B?elRRa2ZMN1JCRkNMQUhuOUc5SDBRMzJHS09jNDcxYjdFV1YxSURBSUl0aDRu?=
 =?utf-8?B?cGVmL3pGV1NDMjA1T1FlRUxseXF3S0thamI4ZDI1U052STQvTkE0aU1ZeFdP?=
 =?utf-8?B?cDI4RFR0d3ZDbXFtdVVXUHNNcjkyZjJBUDZnQWUvbXR0eERML1M1ZnI0SmFO?=
 =?utf-8?B?N0txMXNNRlJjbm55eE82TktqcWtmMVJXU04zWlN2c1FwcEczTWtVRFZ6OVEv?=
 =?utf-8?B?d1prTHVTYUlrSWpiaE9QdWVIMGMxS1R6cS9rNi92eUc0OHkzSDVoS2ZnUmxJ?=
 =?utf-8?B?ZExjK00xRTliZWh6R0tNUFpzR2ZvWVV0ZldncGRFQ00yV0hEQXBKUzJ0YTlQ?=
 =?utf-8?B?ZjdWSytEQ3pLWUFkMDZ3cGxUYjFUcjJDanNQamxtakx1UGV4QURPS2s2Qm54?=
 =?utf-8?B?M2tXSlFsMXhPRjM2d0EzLy8yNGhkR1dVNERKUFNIVGp4THBCR01nVExFY0N1?=
 =?utf-8?B?cU9lNFU0QkwvSE92bWVUWlhmYVJIMXhQM2FOa2duWCt1S1g2aldPaEZ0V1VQ?=
 =?utf-8?B?Tk5TUDROOVFyb1AxcTNYV2d1dUJjVTBNQklyZEJ3Q0dEVEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rjk5V0FZTWN5dUtheWNpdE50aGh1ZXd3OWd3bitMWnMrSkgxQ2R2dTF0bis3?=
 =?utf-8?B?aDZ5SElNWTFUTDF3Y1JSY2pVQmh2Zm5FSVExQ09MMDV1WEQ4VTMzcElOVEh5?=
 =?utf-8?B?ZlJGaEVBWkpsd20zYWI2U3NBRWlhakFMNnpIaXlsekRkbE9DM0lGYjNqenRH?=
 =?utf-8?B?dEdPOWNBMlRHWGdqMXoyL0pRWTBXdWN3eUVjZm5LWVNZekZEUmY2WHcyMXM4?=
 =?utf-8?B?RmNMNWVXamRCZ285YmNqbDNlMjNLeHBBVGJhVzd3eFA5V1l4c3g1cGVVekgz?=
 =?utf-8?B?R2cxREZGV2U0UWhlQWVSdXdzeVJ5QXIrWUk5NjhENGFhYzEyc3RCa3FGTDQy?=
 =?utf-8?B?aXFvdDhERGdtcmpjT2JoSDd0RC9lNFVMa3dtUEVWNTZXRE5wTzUwTDF4QnhF?=
 =?utf-8?B?SUh3WHcvMUZnaWhJSW51VWJQMWtLLzVYSWV4OUszd3FxT2EyWXpkUGlUUjVW?=
 =?utf-8?B?SkJxMjBzYWF4Y2ZkbmU2bENTbXdkMVU4Wm1NK1dwZW5LMXRGWExNcWRIRVBt?=
 =?utf-8?B?d3N6ZnRRbmVNR1hibTY3eUhaam41THVqTTRQcGxnN1lXNVV4bWpobE5teU9z?=
 =?utf-8?B?ci8vbVdNN2htODg2UDA3dS9hOEJPZ0c5M2p5ZmpjTE80UXp5K3M2YndERFVV?=
 =?utf-8?B?NEIyUTlEdmswV3FCYVlRQlpwOTA3WFh2NXYwU0FZcXBvWm9NU1pCRkNnWHc0?=
 =?utf-8?B?Z1QwVXpwa1NaM0w5S2FuZHVSRFNiZklzNEZtZUNhN29CdkZuN0lCa1NCSS9I?=
 =?utf-8?B?UWo2OHpLYTg1ZU9vQTFxUDNNbmRNSDIyaVBhZFVRa0c4WjBPc2x2S3lWU0c1?=
 =?utf-8?B?R0NUTWpvRXN0YTFqMmtBbytXbmZJK0xWcGQ1bzVjNUNZaFBhcGRNTjdDNFNR?=
 =?utf-8?B?T2tJRkRTcFFaS080MXVHZW1BSzJlcEp1MXBkcklXTk55TGIrQkk4aTNLQ3pC?=
 =?utf-8?B?eVk2Q0JpTUVGTUhTbVRiVVcvdnhQdTAxdHp5TUxZLzl6TTllZG1xY2RvYnJL?=
 =?utf-8?B?blRSUGVVcmowWmdETFdtdVhpSzkvemFhT3pFdFBaU1c5blNqODVhWWM5VkRa?=
 =?utf-8?B?VlQ2N2VWSXA0UFVxVUNEdjJnUHc0OGs3M3NUSXJHb1pseDh1UWJQS1cxZ2pi?=
 =?utf-8?B?ZlVuc3RqNkZYdEZtUDcvOVZKMy80VXFVUi9ZZTVRYmkvOTRGWjlXbTdKaWpN?=
 =?utf-8?B?V2xJclB5ZzdmQjdFSzZwVDhvWmk5Ynp2N1l2MmYyWG9GcFZhNERlTlh4WnV1?=
 =?utf-8?B?ejRXUlpUK2Y2aXNZVTNuZXpRSFBCaWxPdHNiVE1DTUtGTHJaQkNxQWVaUCs5?=
 =?utf-8?B?TCtBMzJiMG01RmRMZTBURFpET05vQ2plbDdPWWRSREdrOFdhVGpQZ1FxaUVC?=
 =?utf-8?B?ZUF1ZkNhajBXYnQ3Y2NYa0ZYRXg2ODNwQUlIbk0vNVhoNmJHdFhDMDdOUklv?=
 =?utf-8?B?OWdkNWVwakdHNk9UcEpFQ013ZS93aG8xOHBTV2F4Y2xhWGpCdHhBSU93a0Nw?=
 =?utf-8?B?bkRLTWhtSUJ3SCsxdmp6MDF4Qld4bnV2cERoZHBrMzExQjN4cnlGOFRZNzdQ?=
 =?utf-8?B?ZCt5c1ZwR01PSTRiNG0yWWVOVTQ2bnZDTkhuWDliQTcyUWExQjVvLy82UWxV?=
 =?utf-8?B?ZkcyYWN1V0s5bUYyNU04NFJvSFEzZElaeU44YUwvTGNISzd5cGg3Vmx3djdW?=
 =?utf-8?B?OUZlUVdWaEpNLzk3QnhLbXIxZ3h0dk15RmlqdUg4aS85ZGs5UVVrU2VEdmg0?=
 =?utf-8?B?UWs0TEhPU0UzZlZRWjJMWEEyd0gvajMzemFmTzVQVzFXWFhoU1QyMkN6Mjds?=
 =?utf-8?B?eW0wc01VbU1UKzFaV3NoZTQ3YlEwM3lUdkFqMWprdU1QY1pnaDZtc25ZTERm?=
 =?utf-8?B?ZFE2Ti9QYW1mWnRyYXJYVjRYWHJkN0FpeWhFK0FYMVpSQkduSy9scGZqMnVE?=
 =?utf-8?B?eGRuT0grSEZkZGJUN0xVRkJDYW9YWGNxNS9CS3JMSEJqMGhhd0ZMMjFXZTM5?=
 =?utf-8?B?ODVBVjBadlJkOWlqUlZjMG80NmhCTjhTaThLcG5tcVVCOFdNcWYwRnlkMW11?=
 =?utf-8?B?bkNnMDNQNVRFRDBxRzlXTnVOMDBaZFl3NTQ0VnZNazFsZXhXcU50R3VTcFo1?=
 =?utf-8?B?WlFHTzRBSVZrMkp4SElnNXF6djBtSTRIRUFTYkc3amZJM2VoT3JqejA0NGxD?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DCAD1AAAFAF5C4BA227F0BD2E27D6EF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a5956c-dd9f-4bac-6c31-08dcd32e9558
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 13:27:00.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XjCrR29mf+RXaXHCU67DnW60y5pdQ5UZFvbP1zP4ODPEzmaip8NznG9zUZut/F6kLs3/ujhMJf8YD6Zgcj8z2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7897
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--20.146700-8.000000
X-TMASE-MatchedRID: Q8pJWSpPf0PUL3YCMmnG4omfV7NNMGm+bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CxAq6/y5AEOOslgi/vLS272MJM
	V/Fqds50a60S5yaTEp8DPDA2+oXjO/Guz40Ud3KRGWpKGpvfmnoEcpMn6x9cZXFNHTRKzg/ppRe
	zoWC5XLQlYWnzcSFNXXcLoGDtXnNFhOZgw+QLWVXXuAcDIAWvTwJjn8yqLU6Jk5Xdw2ydQhubgI
	7H1SfKA0mLc3GCLyvY7+HoDr4vIo5H0YXYnbGoz0gVVXNgaM0pZDL1gLmoa/PoA9r2LThYYKrau
	Xd3MZDU980qe9xzB3A==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--20.146700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	79FCFBC05C6B1265E2BE4474DD3D6A90376A7429559A2F95DF1B952FF9B2724C2000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTExIGF0IDE3OjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW4gdWZzaGNkX3VpY19jbWRfY29tcGwoKSwgdGhlcmUgaXMgY29k
ZSB0aGF0IGRlcmVmZXJlbmNlcyAnY21kJw0KPiB3aXRoDQo+IGFuZCB3aXRob3V0IGNoZWNraW5n
IHRoZSAnY21kJyBwb2ludGVyLiBUaGlzIGNvbmZ1c2VzIHN0YXRpYyBzb3VyY2UNCj4gY29kZQ0K
PiBhbmFseXplcnMgbGlrZSBDb3Zlcml0eSBhbmQgc3BhcnNlLiBTaW5jZSBub25lIG9mIHRoZSBj
b2RlIGluDQo+IHVmc2hjZF91aWNfY21kX2NvbXBsKCkgY2FuIGRvIGFueXRoaW5nIHVzZWZ1bCBp
ZiAnY21kJyBpcyBOVUxMLCBtb3ZlDQo+IHRoZQ0KPiAnY21kJyB0ZXN0IG5lYXIgdGhlIHN0YXJ0
IG9mIHRoaXMgZnVuY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUg
PGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
IHwgOCArKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IDEzNGNiYTBmZjUxMi4uYmQ0Y2UzMzk1
OTcyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTU0NjIsMTAgKzU0NjIsMTMgQEAgc3RhdGlj
IGlycXJldHVybl90DQo+IHVmc2hjZF91aWNfY21kX2NvbXBsKHN0cnVjdCB1ZnNfaGJhICpoYmEs
IHUzMiBpbnRyX3N0YXR1cykNCj4gIA0KPiAgCXNwaW5fbG9jayhoYmEtPmhvc3QtPmhvc3RfbG9j
ayk7DQo+ICAJY21kID0gaGJhLT5hY3RpdmVfdWljX2NtZDsNCj4gKwlpZiAoIWNtZCkNCj4gKwkJ
Z290byB1bmxvY2s7DQo+ICsNCj4gDQoNCkhpIEJhcnQsDQoNCkNvdWxkIGFkZCBhIHdhcm5pbmcg
bGluZSBpbiB0aGlzIGNhc2U/IAkNCldBUk5fT04oIWNtZCk7DQpJJ20gd29ycmllZCB0aGF0IGlm
IHRoaXMgc2l0dWF0aW9uIG9jY3Vycywgd2Ugd29uJ3QgaGF2ZSANCmVub3VnaCBpbmZvcm1hdGlv
biB0byBkZWJ1Zy4NCg0KVGhhbmtzDQpQZXRlcg0KDQoNCj4gIAlpZiAodWZzaGNkX2lzX2F1dG9f
aGliZXJuOF9lcnJvcihoYmEsIGludHJfc3RhdHVzKSkNCj4gIAkJaGJhLT5lcnJvcnMgfD0gKFVG
U0hDRF9VSUNfSElCRVJOOF9NQVNLICYgaW50cl9zdGF0dXMpOw0KPiAgDQo+IC0JaWYgKGludHJf
c3RhdHVzICYgVUlDX0NPTU1BTkRfQ09NUEwgJiYgY21kKSB7DQo+ICsJaWYgKGludHJfc3RhdHVz
ICYgVUlDX0NPTU1BTkRfQ09NUEwpIHsNCj4gIAkJY21kLT5hcmd1bWVudDIgfD0gdWZzaGNkX2dl
dF91aWNfY21kX3Jlc3VsdChoYmEpOw0KPiAgCQljbWQtPmFyZ3VtZW50MyA9IHVmc2hjZF9nZXRf
ZG1lX2F0dHJfdmFsKGhiYSk7DQo+ICAJCWlmICghaGJhLT51aWNfYXN5bmNfZG9uZSkNCj4gQEAg
LTU0ODIsNyArNTQ4NSwxMCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX3VpY19jbWRfY29t
cGwoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGludHJfc3RhdHVzKQ0KPiAgDQo+ICAJaWYg
KHJldHZhbCA9PSBJUlFfSEFORExFRCkNCj4gIAkJdWZzaGNkX2FkZF91aWNfY29tbWFuZF90cmFj
ZShoYmEsIGNtZCwgVUZTX0NNRF9DT01QKTsNCj4gKw0KPiArdW5sb2NrOg0KPiAgCXNwaW5fdW5s
b2NrKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gKw0KPiAgCXJldHVybiByZXR2YWw7DQo+ICB9
DQo+ICANCg==
