Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38352BEC26
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 12:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744634912; cv=fail; b=dMSjAzNlAxgmy7tulua9gw3s9yNIzvctlWsJaEI99Qtrm2VwiSvTcYwaVOtneTOlXTrQAVboVqDGMfrLjsiP2NTcs6564es3THXI+GGIov8l7UBzQs4Rdnw+VPT8S0IQ4r9BJIYBngVwusY3UJDadgqH9iT4QI4ANiuNuwxzUcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744634912; c=relaxed/simple;
	bh=j08r2fU8djLfmCZe3RU5Mn+mWCSIrI4qxgYjTDyDwM0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R5P0LgHNDOWbjIKsC7Q10kE5CxMouM7cbqNHdAfIT9gR7Aouw3urjQTsQbL922ofLhGxgFyBSIUlVVW6wVx4i164fK/plA+U2Gv03gJPLO12BILu3OnYaBwU0Ty72vZg36O8dcrNcWbEUjtklasnDOTTnK9ZZ3UWngvftI9HE/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IEtFXJs1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cGbI+P0w; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IEtFXJs1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cGbI+P0w"
X-UUID: c10b610c192e11f0aae1fd9735fae912-20250414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=j08r2fU8djLfmCZe3RU5Mn+mWCSIrI4qxgYjTDyDwM0=;
	b=IEtFXJs1JDPbpY2JMKC5u4drHsu1hy2NIX0BGxig4FjGGFQm2mnuR+vXBwdBPtZLMiWyZ7j1axUVOe7kaRFw9klX/WMm0bPa4dr0LQk3L18nSBtFaAgcmQ2cv1vzo60b5EDAWkAMYP/rMs25Is96H0ZZRnWnNei7qxlmObT6r28=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:0962d57a-9ed9-44ca-b2d6-0f9f16f69a4a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:00d3968d-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: c10b610c192e11f0aae1fd9735fae912-20250414
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 926520851; Mon, 14 Apr 2025 20:48:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 14 Apr 2025 20:48:23 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 14 Apr 2025 20:48:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4Dd11FrCB6kGBkKKPOVrbJ0xaNQfcgDMowmf3XckcSOcmZ1SqbkOpl45UTcLhvXqSJWU9adIZ3JjfNndYjBwO79zWW6S0w46qav9auOG+c6ZzkRzrHt5qLrY+KNgFGsaGcRnCLxwMQ/69VbsbYTtba5VZRLpgUC/1lHDPrIQ2U4kOe3dYWyK+6Yod6O0ALS0G2lX6FtL3a63jHHUKrkx5/l0QBU8G8SZwfvo63te7ot+UIUio3vPmuA4gXMjFmkjC7BwRor1UEaTLjeSCd7cjfgSqvUPSj/bwzz9fS/f8YFu5c433sL7LXHkmg2dVh73dPJXtYxi0lBRqHGvCRKhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j08r2fU8djLfmCZe3RU5Mn+mWCSIrI4qxgYjTDyDwM0=;
 b=fAL3uXj8Y8fF5612Vbl809usv0c1cY9cXmC7Wu7UKs78th3vA2lFS1LDzHBp7npaOElSckdMvu/KFbmp7BNTD4W0+uLqm3J1W/Gyh+05ccOg4TJEgOm0QaYMo+PHZAzGQsbPu97ZCS1m292WuE1CcxJz4CMRPvTuDuofrdX5u5GZmhb8qyaNaRwl1mFty6Zy6rz08kE1Z0mRtinBRxmIk+efvdIcxfh7mwVyS1n68xcr9nAsNBSFQchZ4mvvvDBJ/kM3wYvGIPukv206T1OXX8T+NGuDrFKGAdIee9Dz53w/THcMS1FdvF4QPp3TH2mQqTzhkxgOYnTVbOp2OTds0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j08r2fU8djLfmCZe3RU5Mn+mWCSIrI4qxgYjTDyDwM0=;
 b=cGbI+P0wbJv/+W1q0qnmsaq2n8iXA7hB7v+ffsPyJnyrFRBykaPXclw73oF3eYAsYJ8LeTj0icD4YX+KrCDl/OPikXTICulMFrJ9EiRyknqXYyXz8Z/4wQ8wrKKOX0smqbYUz0O264t+eNxVI5Lr+LQG613hAUDeEdFUa6X9FZY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8000.apcprd03.prod.outlook.com (2603:1096:101:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 12:48:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 12:48:19 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 09/24] scsi: ufs: core: Change the type of one
 ufshcd_send_command() argument
Thread-Topic: [PATCH 09/24] scsi: ufs: core: Change the type of one
 ufshcd_send_command() argument
Thread-Index: AQHbpN5uqzSAN/SvBU6U3ojCLswddLOjLUAA
Date: Mon, 14 Apr 2025 12:48:19 +0000
Message-ID: <01744ff92c6be09d3d48a2000d0671652dca4611.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-10-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-10-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8000:EE_
x-ms-office365-filtering-correlation-id: 221d234b-d8fb-4586-563a-08dd7b52a218
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bG93Q3JDN0xtN0VtT3dzSDl1WVBwRzc4cHFhWFNCMXhrV0V1dmxTMVRQdnRG?=
 =?utf-8?B?TUM1K2F2NURORkdZQ09QVm5mTGZaaTZ1WFFyQVNRT2QvVER5OG5jbkEyaXpM?=
 =?utf-8?B?YjBZdks2WmliTURwV0tpb2EwM1lRd0dHd29uUmRBVHlkSTZ5RVVBbWtYNXd0?=
 =?utf-8?B?ZW1NbnNublRvbGs2cHp2cWEyclVyNHBVRmpWTnd4SlR1cHN2SFo5Y0NrZHlQ?=
 =?utf-8?B?SG1mN09yMGdkUncvSkVQdVBUWjZEWEhIZzQzS2pRN2sxbUcrQ29lNFowa3ZZ?=
 =?utf-8?B?Mi9Ga2VpMXpFUWg1YmFwNzY5RWtNbDlHUFNZS3kwSXZjRFVOMjEvaENqZjI4?=
 =?utf-8?B?M3VCc0d4UmVyQ2hRL1grQW5yeks2bHNPYU9seUVzSmk0L2FzMEdHcnFkT2E0?=
 =?utf-8?B?Qlplc1JmWGV4ekJ1bzVmcllEOHhvQTViQk1PazlIWkhNcDFpRG9aWHZpNFd2?=
 =?utf-8?B?NHpnMHQ5WXlrcTJjNi9OSy9RUkpkWnFTMkx4VFpVeU5TSSsyZFk0M1JaWEtG?=
 =?utf-8?B?NTRZUEVSTHMzSHhMMWE2RmR6RGNYZW1tMjhWazZlM1B3ZXpjOGwxdjlQYlNG?=
 =?utf-8?B?S2NWNFhRcmI1RDR1czgvbWVSbWs0Y05zaG5aOWs0UDNSOUEyVjdJVjFqeUdH?=
 =?utf-8?B?M01Wajg4NXlyTDV3RjYvVVE5SE8zMVRucGYvOWtzQU0ydGRHZ1FMTlRYZnlW?=
 =?utf-8?B?VjMyMEpGTFFIRkRKS2FzSXBLL2dCU1RRSXJjNjgxOE42NkVnbkxJcjZiL3Bt?=
 =?utf-8?B?dng2NjNJU2FtRVRTSjhkRS8ybFhTZjI3NWovYUxWalpSWVRSUjlicFA1alU1?=
 =?utf-8?B?ODhyTTJYSUhMMmlja2lLT1p6OXh2ZFNndkxzOXVIQS9uSEJJb2dxR0s5Qms1?=
 =?utf-8?B?UFZyYTFMaXF1NlNiQTlwNVMzTlZOUkxoREc0dzA1cDIyWnZUdkoxd3Y1ck5v?=
 =?utf-8?B?RmdxcTVGUk00VDFsdGFDWjNSbXA4TFVKUkRtZjVRUzhhUmVuVmNCWGkzK0tI?=
 =?utf-8?B?OFVURDJLc2JUYjhHdmpCYzRYMkV1VldDRWJ3aWpPVTcwUi94WXkxbm1tcmR6?=
 =?utf-8?B?ZWhXOWxOK255dnVQWThkTmJiQm5PdVYyYTFqajdsRVczMTFFa2ZmNWtXdkUy?=
 =?utf-8?B?a0xTT29HV1kzSHJKOGw0bGtVR0NiL2MyKzZucXR1NWxLcEhyMDdZeUFtdmhj?=
 =?utf-8?B?dmVCRm5rRndTWjRIYWllWjZPWHdqZ2NKZEpXMk5TUEU3VXRyTk1PUEs5WitW?=
 =?utf-8?B?Z1VBdDFpb3lwRmRqRFhob2RaVHRQL2NZSkVKNEtqTmcwQmszSGExUGtucVlI?=
 =?utf-8?B?cEhzdjNhMzYyRVVJNC95WXpqRGhuNm85MGVkS3VxZUZLVUlqVmhlVXBjQ2JQ?=
 =?utf-8?B?MGdQeG53L3plSEh5eXpSWXptVmExMDFrajlCVnJxVjJHU3FwRFBGOHdzSHA2?=
 =?utf-8?B?Vm5JWFVDaWxDeXhVblFhM1l5NUZmdjkyMFlLN2F0b1RDSDBya2VyUDBIbGFv?=
 =?utf-8?B?K1BQMERPR3JveHRUN1hvRWVXYjVyZWU0MW5ZYWRZUlk3NVhETUd1SWErekF6?=
 =?utf-8?B?dlprMFlLZmFNazBDS1czTUJxOVhpNjhaUW04OVJSZFNiaDBpM2VjOUZNU3l2?=
 =?utf-8?B?OWlId3lIQWZ2N0Z2Z2VtdG42UHNONkMyUlAvQnRTaDZEb2lVTDY4Y1VtbWk3?=
 =?utf-8?B?WTVkTXdlMGRCQ24yV0lGRTM0SkJ1K1ZFTkNRcURmWldiUlZWazJJbGJ0TXRB?=
 =?utf-8?B?OEVqS2MvOFBzOEQ5alBQekZWenBXUEJUaDd2c3o0aDNwWGNFSzlpWUFOK05X?=
 =?utf-8?B?Q0Jlc2ozV0lCa05sMnJBOTFBMDJOSi9Yekxsek8yYzNHZ3BvM2ljbTBqUXZM?=
 =?utf-8?B?eUlHUmpVeldYVERaNmhVM2g0NmRjdkh1Z0QyYTNYMHI1Tm9rT3hhcnV6V041?=
 =?utf-8?B?aFk1UkVGQzNhVEU2T29wS3ljazM0QmpYVys5clNNaUpnNURFSE9aUUF6ZGRy?=
 =?utf-8?B?UitoU2ZjTWlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnZMaFZPSlJkUitacVdtVGlaUlhjQy9FNVBvTTNaN1JncUJWcVdPMmtObHM1?=
 =?utf-8?B?M1RsNUY1Z3pwWlNSNC9jRm1pNkFnRkNEVVlzZWNJWlJGMXpiS3pVcStaOWxQ?=
 =?utf-8?B?NnNnNkRURnBsUHVoTGFRdERvODI2UUhuM1YzUTRJeW1rZk1hRWVncitNekYy?=
 =?utf-8?B?R2swMmFqalJYbGROSndxYUtZSE05NG16Rm4xT3I2d21XcWdyMncvMW1xM2tX?=
 =?utf-8?B?Q3puY3V3bElkOXhDaVFxenROdUh0dUg2TGxjSWNEbm9NZ2FZaGpFLzdyWldG?=
 =?utf-8?B?VlNHeTNtOGd4bkZzUWtTYlJldkhkUUZ0eFdlNUkxOEEvT0VOMTVEY0E4VkJQ?=
 =?utf-8?B?K0xoVlI3ZDN2RlR5bnByK3BjdE52aFp0aTROUDJuNFBlbEQ5Z2w5djE3WFNx?=
 =?utf-8?B?b2NZWEtpYVlPRGZpakJmMHpHVVdnTVo3VEg2djdxbk5OZGtXZUtZdWF0Tnhx?=
 =?utf-8?B?RmpjYkNzbm42cjAvUng2ODhhOVA2MWMxejV5QThteGN4MUZnMU9RRWVwMTM3?=
 =?utf-8?B?d0ZRMGM3SFU5SXVWRGdGeHo3TlJ3V2hvZzF6cll1RmhNcEhYeW1aSXZBYnEy?=
 =?utf-8?B?TDk4NjNZc1pzTEVTVHU1VXBKa1J2a3psMkdzanBOTlZHYmJ5WmwrcDNoTGhS?=
 =?utf-8?B?T2lzWUx3ZXdFNi9xSHlpTVFmZld6dGZTazM1MDd6QWlSeFZNRWorRUlMMGdj?=
 =?utf-8?B?RFE1QWtFalNMc01YZWNTZ2FYS3VPanZzY3JkMVgwY2JBN2ZpSU5DQTc2cUtF?=
 =?utf-8?B?TTE5cEJkUkxMU1FVZ2pjcDZwSUdKVnpFOXdCRUk1OW1YK2x5V1hDK1A5dkQz?=
 =?utf-8?B?bnJiOTRjNk56MSs4U0dwUUJJemFYL0tzNXl2YitCeG9NbmN5R0NCc3o2ODEw?=
 =?utf-8?B?cUFON2V4ZFlLUm9MY1pWeURTN0dIdVdJVFJnVFhFdnV6ZmIyeVhNR3dQanNF?=
 =?utf-8?B?SVIrNDVOQjZDb3FZeFMyRnlUVEdFSTI3d0VwVjRTN2lOLzNQUmdEQkt4d052?=
 =?utf-8?B?Mms0UktDZTlZRDVEUFFKUzZ5VzJkNFBTd3RLNFV2dXJrczd1SnBHbHFjQnJF?=
 =?utf-8?B?TlRsYXFsOFliNU5YVjZyWXF1K29MTkFSbGhBN2k5M2NxL1lxZWJyWUNwYkky?=
 =?utf-8?B?bGdCeDFIeDJ6SUhFK1VMTHVCeW5jUDRuaTBURkp1MEdPQjg5YkVVVlRhV1hX?=
 =?utf-8?B?MkMxY1RvSzlIa3lGYzVXZTRHU2pVaCtkYmVCNFo2Mm81clNpN1dEaldNWmlT?=
 =?utf-8?B?QVJTQ0k0RlQyYUhITzRxOXhOQ1htZ3lOeFlLeWQyUENFWTFmWWpvSWZiWDhU?=
 =?utf-8?B?SE9yNUFLYm15T251NDhoSWVFOERIVE1OVFBrOE1YOFZzRmUyUEdFMGFRa3hG?=
 =?utf-8?B?Y085OHlyWitPZ0VmVzBHaHdwaDVWYVlBSXpNcysyeTB5Ny9SRENHN3RKOHNr?=
 =?utf-8?B?NGtkRmVvK1FJcXBEWjBjVmY4alJWSE9KeGU4Y3VkQWxzZW1JTHhva1BSSVRr?=
 =?utf-8?B?Zmg3SDA4am1ZNkZvdXNiWlg2SHNuQTFNKzdLdVRqS3I4aXkyakZRLzFOTzd0?=
 =?utf-8?B?ZWkrSVVNZlZqM084bitGZEJveVNLekd3NDd0TDdWaU80WWoyUlhSWWs1UFNI?=
 =?utf-8?B?S21UZ1ByVDFJNjUrakZzeFpTMlpFZzBYQXNKZm1xQUxwSWhmdXdnK3NOay95?=
 =?utf-8?B?N3BxN1pnSjhaM3c1ajF0eDljOGRxM1QyUGJYRUc2M0hiSTJsa0k0eVpGUVlz?=
 =?utf-8?B?cm0wZUlocVFsVjFLU1REa0xqeFZybHYyTDlvQTEycjJoWmw4bGlmamFsdmFo?=
 =?utf-8?B?bnJ5eFphUEJSenhNZTBrbnZsMFB0T0pYZXROMEt1MXAzSTVTMnRZLzI5MElJ?=
 =?utf-8?B?UGd6ZWtVUWVyY0RhdWVxUGtzTmFyRnlXVHhHUC9NbHVkSXN1cFEwL1pGY2wr?=
 =?utf-8?B?Mm8xdTgwRkM0OHRTcEVaRFhUVExzem4vK0tiUTRROWhpdW92OUVLdUtaTmVV?=
 =?utf-8?B?SWU0YkE3ZnJTekdvR0ZwTHFVLy9wVlFOSTFpMnN0N2tiRm1Pc2xjN05nTWNX?=
 =?utf-8?B?UC9MbW5aTGhGajRCaCtDK3VnL21vWGp1SFFXaFFTR2ZVQ0M3RVgxMVAvd0lu?=
 =?utf-8?B?dmFUNmloc2ZtSTRPVXpLUlV1Wlo3alRoUCtHUU8vYzc5TDZWdzFuQzRQd004?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C4EE2077F2E9B4E872BBE5C90E07A27@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221d234b-d8fb-4586-563a-08dd7b52a218
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 12:48:19.3151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qQQrdnYgeMh1z6bnNEH0Wk7T9u1deGnuWkMwG6vRDJiUil7eS8Td1Ir+/dcQzHcTfOPih7xII7QuUdSOQ35rPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8000

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IENoYW5nZSB0aGUgJ3Rhc2tfdGFnJyBhcmd1bWVudCBpbnRv
IGFuIExSQiBwb2ludGVyLiBUaGlzIHBhdGNoDQo+IHByZXBhcmVzDQo+IGZvciB0aGUgcmVtb3Zh
bCBvZiB0aGUgaGJhLT5scmJbXSBhcnJheS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFu
IEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
