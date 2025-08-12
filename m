Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D25311C1D
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989283; cv=fail; b=QGqGwKRKhZ5CRzWBrSMyRRpV4+zBWPaRij3UG+dS9lsw2NbFBQqChj10YSvEWwqi+y/g2PpZ4AMNRbCErsBRtIk+85zm8BPtubM8rAqy6NzFtjnPRnal6lnkZdECJ5Gl/l+SVUAzLFZwz0eyajDeiPMMHUhDEFNnNXaCrtdwZaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989283; c=relaxed/simple;
	bh=cbzo0bEylYwqbFZ0AfFBP+CDFchRlEVuucNacscZOz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uqygLAcRIdjR7iQgcyKYjoJEgh9P9DfoQ15mZeVsk/xniTR7irF1jvusATSyS1OxHkSMh7S6nNheGucB8GjvtBy9tghO5FiPhih8WhNuh+r8+LMCBIwwEKtnNXEHJnuWl+591tuZf9yYtrBJ4yf9rpU6/zKy202u7OX9rzfM7UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DGoxs9F1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=n7ywhUab; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DGoxs9F1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="n7ywhUab"
X-UUID: e3bb12e4775a11f0b33aeb1e7f16c2b6-20250812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=cbzo0bEylYwqbFZ0AfFBP+CDFchRlEVuucNacscZOz4=;
	b=DGoxs9F17XKgd+3uVEvOCM/KPg32He0yzCwh/n8n33/9rU5aInUdoCgAq98DGRG+PHyXea/Ds/etcAv0KsxpxH6ZMR5wH2LhjjT5hthdY3hGEIUbGb5Ir9J3DtIn7boW3XuRRqsZ1KA+nlwAEYeDVymbdCohdAoxGNPqrelkIr0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:28f21462-f4d3-4ba6-84f6-376800a8a914,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:23885151-d89a-4c27-9e37-f7ccfcbebd5b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e3bb12e4775a11f0b33aeb1e7f16c2b6-20250812
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1657732739; Tue, 12 Aug 2025 17:01:09 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 12 Aug 2025 17:01:08 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 12 Aug 2025 17:01:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJUoX+vhEOHcSe0bS5ZTkYAGlc+QzPQ3AOxXUE9DQcleZMJPqvrAjGLePCt5bKKxk1Ihl0t+PMcSHHjqVe50Bwi37c0boqOGuLcXpkJpWuA1/s0gDliCfwTRENZwVrUNGbqBF9UWmjNhkKk79UPKG9ZGqpkN7j2nk4genROuObL3ord5QYhZinVEVdxng8yTaXmssMGnHdEKXsfUxjhbPOamvHPDu6Ji2RL7vQELXvhqcQunrtwfzuU4mG9Skh/SBmScAbYMy1F10W205xvLFlNkOB654EBLyMBJV8z6GLuek75131c/rtZfkhzBhJe9ohPOI1iXAhCA4kZ76dGnmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbzo0bEylYwqbFZ0AfFBP+CDFchRlEVuucNacscZOz4=;
 b=DxufPAt13arphBYrme5h1Sl3obhiAwrfAw+qBEst7vTPie690myDbF8krwSHDvNbmYFXdD96Kh6ln5UPDVvgkN8P0QG/qr3nRAJ5k1e7J12S2Op8CQIWB5mgc1bEDUjWEf0Q+ZEB3DIQG723D+agu2VnaZM4HMwAO6ftZebXO/Ma3lwqDo1mK4f3PWMBomg3ZPyitkgRy4EO7S97lownQKLEAS61Y5NcSuw9uZrn5pHKx7v6HyI6kGYHCZOMWhzLoFLFqNWY7xvtNyzlL8/loqSRriKhEWdeIgM9m2/uae/QVy+2vUIVQvUzF+ICfepZ7HTazI7P8yi661aKWhVDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbzo0bEylYwqbFZ0AfFBP+CDFchRlEVuucNacscZOz4=;
 b=n7ywhUabGU+/oAwT/dMQbg5iZeqRLCd7p47CVGBuzn83ngFCCUZA8XChTN093arl+1NeOmlB52XrTyEoje3NS4ZlGwyY5NjW+mtB3YwY7psNHH9kXHOQTsgQ0mN/laSPFxIoKbFa8CQ2ij6flG2+GAq/8YDtBQyEZS0EqvOy4aA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE1PPF1EE48B57A.apcprd03.prod.outlook.com (2603:1096:108:1::849) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Tue, 12 Aug
 2025 09:01:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 09:01:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>
Subject: Re: [PATCH 2/4] ufs: core: Remove WARN_ON_ONCE() call from
 ufshcd_uic_cmd_compl()
Thread-Topic: [PATCH 2/4] ufs: core: Remove WARN_ON_ONCE() call from
 ufshcd_uic_cmd_compl()
Thread-Index: AQHcCtdhxQ/C6u66pUCWlL5COYVjCbReuZUA
Date: Tue, 12 Aug 2025 09:01:05 +0000
Message-ID: <4cbfd49cfc99c33606b7d0fda67e3aa353d74cb1.camel@mediatek.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
	 <20250811154711.394297-3-bvanassche@acm.org>
In-Reply-To: <20250811154711.394297-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE1PPF1EE48B57A:EE_
x-ms-office365-filtering-correlation-id: 3810c36c-0f53-40e7-e7ca-08ddd97ec540
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aDl1ZHRycmxHVWNtNUZqbUt1NFVsSjlDWnZNSkd2NGhyN1B6UXNLSUs0Q3o1?=
 =?utf-8?B?WlRvbHM4S3k5dGl3T3pxQ2FoTHh6c2Zmcnc4cXJCQXZ6TnZDMU9hMzZteThN?=
 =?utf-8?B?Wm84OHRHNlg5QnNMd1VhRy9UbTZjOFRvVTY4RG90aDhQWlJMaHdvK3libEJN?=
 =?utf-8?B?TWoxRVZXcURiSlZUVUxLNk9XeTlEY2dHdkw0SER2dVZyWWRkODFMa1o5Vzl5?=
 =?utf-8?B?eXlFVlZyODF5NVUyUG9OVHBGb2JBMlA5NjZiQUlKdnVFY0tLOEtUVzlSUWZ1?=
 =?utf-8?B?dHl6S0U2ekdXK2lhVHRMWitHclVJVmxVMkZhY2xKdURMdlp5Q3l0eUREZ25o?=
 =?utf-8?B?aUxpa2pDNzNEcjdVTHAwaWsyaDIvQlRTSC9XeUllOE90SVJtYnI5UVY5Y2JK?=
 =?utf-8?B?VFRSOHdQZHVhblloUlpCN0JNa1F0aDVSRGJKekFGOUhIVUErZ0NIOHFob1Y4?=
 =?utf-8?B?dXZ2QVl3S08wTVFOYi9HblNaVThnaytCZFBDWDBza2ppZ09GakVVVjY4MVIy?=
 =?utf-8?B?N0FmRm96Mmowb2tIdm9wMERnejdBMGFCYmhWUVJhc1FLV21aQ20zUzVXU0pM?=
 =?utf-8?B?SWhObjRTYmJPZGYyeExEMlA2ZUY5N2JDZWorZWJOM2MrbzBRdUhIUHp3dTd2?=
 =?utf-8?B?a3ZnVHh4bWRkQ2dSMU5QOUlxWE02SW4yMGl5eko3NDE4a0Y1L3hEdlVGaUF3?=
 =?utf-8?B?ajZXZTgyaC82RmxtbElwZk1RTktMRXRKRmRhY2NIYVdpYjdISDkwZWFSTXd1?=
 =?utf-8?B?R0lNZStKc0ZncjhaOGZzWnlxdjd3a1Vsc3RJaklyZzJ3ZHBpbzlqcHZjTkFP?=
 =?utf-8?B?SHpwU0JMbENYWVNjdHRUUG9IL014YTBYMGRiakJlTnJhMlplcDJGUXg1N0tV?=
 =?utf-8?B?Qyt0a2NYTVFYdDFMNnNxZ3doNHlDRWhZcHhjSUZsaExlQTQ4U3U5MGxVQVZN?=
 =?utf-8?B?SEN5enZjK3A3c0JBVDJxZDExdGxJWjdoSHk4NTJWY0ZpT216eXhUL0VFL1c2?=
 =?utf-8?B?UFhwZGg4Z0dlaXJUcnl5MkZqRy9Wa1N6akVNZkRKKzkvMkNnamZwVnBvbVg5?=
 =?utf-8?B?dnJ0TmFyWGdtSzZXQ0g5NlZuZlBIMkdzOVZYOVYreHk4WFdaS3RyNGxMTXFI?=
 =?utf-8?B?MUhYbHNqSG56TmxCT0RLRUJaVkl0ZXR2L0Rxa1FZVVF4eFMxYjdhYllzbmJN?=
 =?utf-8?B?clY2dnBKSlhISDg3WDIxVXZ3MHdnWGdma09nbjVFazVLaWZudlNFRm9sam5h?=
 =?utf-8?B?RmgwS2RxNGdKWnlDMlNXalVzelhNQzJFNitkQUUySTBWaG9ub3hjcTdzeHJs?=
 =?utf-8?B?N1M5bFVwcm96anpBUVpjdlQ5bUtJME03cUNONEZITHFpRXNjalBuQmd2VWln?=
 =?utf-8?B?R2dJS3RtUUJZbzlKLy82NXBMenJVNHFKZ1RBaEVPVG9kcGZhZGQ3NHhBMGY2?=
 =?utf-8?B?d3dLdjNRL0hLVHJTMDVIczhRYW12K3F4am5oSktCczdkUndrV2ZIV2kzSWRh?=
 =?utf-8?B?a2FkVnZCenJteUErYmZRU1VFSHZhdkdGVlJ3K1JRN3BhM3ZkamtQWTE0SnBq?=
 =?utf-8?B?aE92M0VRNkN5eE52dGM3ZnNibW8xUFlVYmp2SmJ6dlZNYkZ1WlNOc1AxZUF0?=
 =?utf-8?B?MlkrY25aeXRkdUhHWFZNMXg3cVlEa3hkUGY1KzI5VXJwTXRPUGhHOXNzcW5y?=
 =?utf-8?B?QVFZbzN4dmt5ays3Y2p5a2xZZmh1ZHV2bVJsNFFYbkxMV0Q4NHFhL1ZhNWRF?=
 =?utf-8?B?Wngwa3FMUmtGUEdxSmZVUjFFdzZZZDlQdHhXT3VIZGh2NkEzaUxuL1JiTTBR?=
 =?utf-8?B?Vk5ZNk1RRFhQSUp0b0lFTEdYLytBQ2lyekdHY1dRaWFsbWZ6T3crVVNyVGZp?=
 =?utf-8?B?YmEzaHBtMnBHVzVXcFZjMGF2OUdpWTl6V1hPNmZjZWlJeUNVRnJSNk1JTU1a?=
 =?utf-8?B?UW1wQ3FhZ0t0SmVPSm1yNEx2U3pWSWhxT29QKzBYVzUyV2tzWVB6WSt2TlhU?=
 =?utf-8?B?QjE5WHdhZXBRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmE5SjJ5NnpJbWZONGNhM3RUYms1a1BDVFNxb0Zzd2Q3Unp4SmNGcXkxUDNu?=
 =?utf-8?B?TEpVWlJzRGl5V3cwQUFVeGFLMEgzdjYwTHkyRjJkTEk2WS93U0FZMVo4OXdZ?=
 =?utf-8?B?cXZhTzJiRGhSWlU1MmlzUEhncnFDMlp1cDNSOUtrbFRHQmpYbTNobW1OK2V5?=
 =?utf-8?B?bTRNTENMdXBNV3E4RElxVDhSb1YzNmJBNTcxSWdWYk5GNmEvcjdidFF3ZXZo?=
 =?utf-8?B?QlhhbGNZS0VxL1pkclZ5WnhHVEM0dGY1NlVCbC9yb2FFb2ZlOUxuVW1QcmVq?=
 =?utf-8?B?YkcxdFlyL0daejJqWnFBcENXN2tPRVlaaTdDaUlIS2ltS25WbXpEV2U2Q0dw?=
 =?utf-8?B?MUZZMWJQS2ZFOGZGVDUvSkZLSzVUektnSnNQTlR1Wi9CSUJlQXJEWE1zUVhO?=
 =?utf-8?B?WnEyclNoVGJ2MFZ4QXNXZWlkSnprdlc5Wld1SVRkdnppd1BScTVJclhQMThM?=
 =?utf-8?B?Y0pyRm5EakpuODVkTHpqSXd0L0NTSmg4V3NTVVRTaHl1OVdhNXErdlVTSHFG?=
 =?utf-8?B?SzhWdm5QRmwxbmxoMnRxcWxUUTVhSElKZUE1S0Y1NnZzNm1JbEJ4UEZhOFI5?=
 =?utf-8?B?aTZjMGc2VEtpS3gxbXIzc3dYRXMzYktSd3VJZTVyUkgzaWJZS29jM2k4dVFt?=
 =?utf-8?B?MzBWWW1XTU5qWVovdGtBM2Q5S0xTNEoxRFFSQkUxMDdVTk9FZEIyTFpFamNh?=
 =?utf-8?B?TEJtTHZaNXY4ODZsa3VaY05lWld1WWNmODRxbktXWGhXUWpHZjREUFM2WktF?=
 =?utf-8?B?QUcxMHY5YWlRVW1vc1N0S2o0Y0c3WiszdU1Oa2xXN01WK1g2MTFqMEt1SlB4?=
 =?utf-8?B?RjhFVnNWZUxFVDJiS3FOcUlxZzVoa3h5aUhlRE8rMjNWaU03bnI3T1N6dnNC?=
 =?utf-8?B?OEZvSVZGd1dub2FzTlpwRTd0dXQxKzh3UmFxcWRTLzd6M1EyV2dsMnAvT0o2?=
 =?utf-8?B?Q1V4SnpwdXU0UDkxSjB2cHNKaVQ3TFQ3U3hUU3pxekJHZld1TzFrR1gwMTli?=
 =?utf-8?B?akpvOWdYbE9Kb1hsS2grc0xtRDVOOUpGTDFuY1FIWnBXMTMyMTBROGZDOUNH?=
 =?utf-8?B?ZVN3SFBVNWJCYytSd1VCNG0yeVZHTEtHcnFZRzl0YndLV0lHRytpQ2t2Y3lJ?=
 =?utf-8?B?M3ZaNThXNEh6YXRsUzh2c1haR0lNbWRpWXJkUEJFUkRveGtxcXh2NWY2SGMr?=
 =?utf-8?B?NFV2ZStrUjU1YU9Wd3JHTG1EWUpkdkloTG43Zm0xeGtXVlVObVROdTBCNkxD?=
 =?utf-8?B?UE9pNHhXNEJtcVErTzdra2xKWWtJekxORjZRY2U3ME9MN2hTZWVUelMzUUdJ?=
 =?utf-8?B?dEdZVE94ZG5UTzRBUWpFMEFnbEw5QnhUWndqdkJmc2ZtYkR4RG5WNkZ4R3ph?=
 =?utf-8?B?Z254bWR5MmlWZWovazdSSCtNZlIzTDQrZVFHdDk1cDZ4NjRDM09meXFVbmFz?=
 =?utf-8?B?VDZCZng3NmVwYzJrZnBaVWZ6MWRORFdXM1I0Zm9SclprSEVxSldyMU5CQTJM?=
 =?utf-8?B?Q3VsVFhVODBOQ3hqTGhNdno4bU9CYTNqZnFtUWsvT3BrTC92b2J6WGkycWUv?=
 =?utf-8?B?dkJqbDZvdWxoOG1XSFFmOEo4c0pQUENaN1pwaExTTHNPTmlrTTV4STQvbG5N?=
 =?utf-8?B?QVZRWkFwdW1uY1ZqdnQyaUtTV1Y5VjFBUk1tZGhzV2ttcHBDaU5odUFZQTdl?=
 =?utf-8?B?OE1yOXRDRlVVVWZzVHdvcTd0b2tqSGxqY0Q2TzU2SFlWMjZhQnJDOXNyMkxp?=
 =?utf-8?B?aGEyU3VVSVRxUXpkZGZXVGF5N2RuQ1BJVWxZckZlblZLc0pBcE1XTWRFRHhO?=
 =?utf-8?B?UUFFcHdoYXNUOExmWEJpbDJ3YmxKV3VOZ1poSnkxZ2RsRm5xN082bytnMThT?=
 =?utf-8?B?aklQeVBTZlhpYzR1cVdGY0xndnVEdzEvVi8yRXZZVTJTYVJhcE02UDVtVDI5?=
 =?utf-8?B?QWJNUnJhTWIrbXRYckhLM1FMTmwxWDRaaG0xbDV0WHB3d09wTnU5TTB3SkR2?=
 =?utf-8?B?RnVacm5vcDdmWU9OZ3VSRS9MUEhjdCt0WEREa2x3V202MWYvZGxQWlV6Rzgx?=
 =?utf-8?B?aXJKeUVFMDlDN2dtYTZWUWErZHN0RVBla2p0VEg3UGl2a0lNWVl3dFZsSDI1?=
 =?utf-8?B?Y0orTGEzaWgzWTJkYzhCTkRPZ1RIVmZxeC83NnNVQ3JhS1ZuaGNob3lWc0tP?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25427A784677DD49A080F09E34652807@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3810c36c-0f53-40e7-e7ca-08ddd97ec540
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 09:01:05.4344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9xcDJTJShqctEPXhFN7JyMnyWMrnvPiRDaRkdEIUcYJp4iyxKpQ8b9pdvUVhgrA93k+IRrFfGvfdke1i0ViAXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF1EE48B57A

T24gTW9uLCAyMDI1LTA4LTExIGF0IDA4OjQ2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gVGhlIFVJQyBjb21wbGV0aW9uIGludGVycnVwdCBtYXkgYmUgZGlzYWJsZWQg
d2hpbGUgYW4gVUlDIGNvbW1hbmQgaXMNCj4gYmVpbmcgcHJvY2Vzc2VkLiBXaGVuIHRoZSBVSUMg
Y29tcGxldGlvbiBpbnRlcnJ1cHQgaXMgcmVlbmFibGVkLCBhbg0KPiBVSUMgaW50ZXJydXB0IGlz
IHRyaWdnZXJlZCBhbmQgdGhlIFdBUk5fT05fT05DRSghY21kKSBzdGF0ZW1lbnQgaXMNCj4gaGl0
Lg0KPiBIZW5jZSB0aGlzIHBhdGNoIHRoYXQgcmVtb3ZlcyB0aGlzIGtlcm5lbCB3YXJuaW5nLg0K
PiANCj4gRml4ZXM6IGZjZDhiMDQ1MGE5YSAoInNjc2k6IHVmczogY29yZTogTWFrZSB1ZnNoY2Rf
dWljX2NtZF9jb21wbCgpDQo+IGVhc2llciB0byBhbmFseXplIikNCj4gU2lnbmVkLW9mZi1ieTog
QmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMgfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggM2U5NDM2NGY0NWQ1
Li4xMmFmNGUwODI0Y2UgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMN
Cj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNTU2MSw3ICs1NTYxLDcg
QEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91aWNfY21kX2NvbXBsKHN0cnVjdA0KPiB1ZnNf
aGJhICpoYmEsIHUzMiBpbnRyX3N0YXR1cykNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIGd1YXJkKHNw
aW5sb2NrX2lycXNhdmUpKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gwqDCoMKgwqDCoMKgwqAg
Y21kID0gaGJhLT5hY3RpdmVfdWljX2NtZDsNCj4gLcKgwqDCoMKgwqDCoCBpZiAoV0FSTl9PTl9P
TkNFKCFjbWQpKQ0KPiArwqDCoMKgwqDCoMKgIGlmICghY21kKQ0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAodWZz
aGNkX2lzX2F1dG9faGliZXJuOF9lcnJvcihoYmEsIGludHJfc3RhdHVzKSkNCg0KDQpSZXZpZXdl
ZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg0K
