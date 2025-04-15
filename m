Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C4A27A900
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 07:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744702633; cv=fail; b=QviVjWcUmo7YLhcqAtDkluF1dREBr9NtsjBe30iTjOHZFzB1qtChZS7Z4NA5gOhJ/eoZ3yNRZUrj1s1mxiE06My5p4qfwPX47eSsdBVnZDlYKuF34EtS3o6eMmIXZXQTHJp87INqDFMwRmxhLMYrGB06rt1WRjRZqia317WW0jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744702633; c=relaxed/simple;
	bh=tkcRa+i90esysSVl6PL12kq0LtucyoTwB/U3CQltRcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ECDm2uOTn8L1Nf5GYEMHsQZSwjIAMk9fckybvSDXTsYg8DFQZAty5y4KOlrtt8Hx8Lx1spG4B7mH6MWVCFAi6xSzSrHLL+FP+aofDU0KyDODrmpsMSZWMPwU+8PKLi7AbnZBD9zx5eT5loeVx/fQdCvitW0daeuXcsiT88YJYbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LawTBL3T; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=v5QnUzrb; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LawTBL3T";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="v5QnUzrb"
X-UUID: 6cc6b8be19cc11f0aae1fd9735fae912-20250415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tkcRa+i90esysSVl6PL12kq0LtucyoTwB/U3CQltRcA=;
	b=LawTBL3Tv15bfNlRtcMG0zLZ66vSSvs67DdDs1fk1xk9hZ1bVW+vnoMfVo4nlz8UIcGsN3FZBUvDOQLpHZEnp8azSb31HQ/sKJBa6YJG+5aTxvP+FcgmqlxpEeJR8EGxMxgQhP6daqnY5PlS6OLPtOP/xBmHLAkjLD1ZtqEVciw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:ab2428d3-f81e-4f4a-b6aa-7adff0d500d5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:3ddf438b-0afe-4897-949e-8174746b1932,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 6cc6b8be19cc11f0aae1fd9735fae912-20250415
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1977457727; Tue, 15 Apr 2025 15:37:03 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 15 Apr 2025 15:37:03 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 15 Apr 2025 15:37:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtJxtrOnf8/SlouUeHmjXmc1umZSgyC29Y4NgvvyVXdEgQkLUPpnX998cIx11YewNj9FEXWd/zp6mhhlwLqqRdJhy4oWbVEn76tyOyu5Nl48b7nxTSz1A9Tvs0j0sl3j6+tmcrCr+kjlajHYhjKNORQiD7O+Nf0wcKMBkRHHxTAAriwvyT/UDriC/GzjDzqQ2pSUJ08O323aOF/aEGeQwE+UnLH/yCChQ2Gq+oe6PmNjvofMLeqUO8liOlQH8IAF6Nqr01gyEy15yS2lyo95mjs8lUN1p2j8OLK0O0dexFnmubnfL0CSSswSGJjuuY2NURvmp69nV3Yrms5CQ9kJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkcRa+i90esysSVl6PL12kq0LtucyoTwB/U3CQltRcA=;
 b=QLWAr1u6U+Dn2RwGic/6dLkDSeFbD5DMzVgLgj4lqKR+dU3+Ev2AFpnGikQoNfrBrO4P7flRIrBd7bmDWA3+K3pH0NrkY1qgSHdCXQ/C5gxZvTU1hNSdmyDMB5q1GVEMDixxzln+9z71e/+FksWWjfRCknVJ33QkdamJWgsONGePQM3LPdcJsb4lBgihV16lOcjNqdamVeNwb+ViM1r7EXZCuG7Cdi9NxfOAxEIKxp6lCUrWZGddMahDZqUcooOYLvDhc1aoRWUu5uJ3WdsDJMR1w8nhpDi8XXCZIjozMw4Z6Xcg4dyJebU4By1RV10bGS6gnjSWVZ83s0lRV/vB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkcRa+i90esysSVl6PL12kq0LtucyoTwB/U3CQltRcA=;
 b=v5QnUzrb+4BweuT+1TG61CyToFHyRzs2hxQf9NpHtr/SVzffW9D+HpaAndP1yUJTz0bZzRmrdZgNQG1FW2gEfd86UR0vHeXcQ+Ysj+/JAOxerDQJkpfXwtSpMFNJryQA4c27CAx0VrZrrlX1HD5A2+qR/0wF5FkSdDo+d4zeyPE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7199.apcprd03.prod.outlook.com (2603:1096:820:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Tue, 15 Apr
 2025 07:37:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.036; Tue, 15 Apr 2025
 07:37:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 11/24] scsi: ufs: core: Change the monitor function
 argument types
Thread-Topic: [PATCH 11/24] scsi: ufs: core: Change the monitor function
 argument types
Thread-Index: AQHbpN57VK129VD8MU23n8ZEQ45zu7OkaJyA
Date: Tue, 15 Apr 2025 07:37:01 +0000
Message-ID: <41a87716bb67cc0360108ea86fd380f0bde01273.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-12-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-12-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7199:EE_
x-ms-office365-filtering-correlation-id: e412aef0-13e1-4d08-5c70-08dd7bf04fbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UUI3ZmNaVUtESXhxczJ4SzdmNC9RQzVhOFRObm5ONHM3ZzZwdlNjNE9UelVa?=
 =?utf-8?B?MWNudUo0UTEwL2dBTDFvYyt3R3ZCYTdhMWcycnhVYXJjL0ZSUDNKb0VxUmFN?=
 =?utf-8?B?Y053VURtWlluL2VUY1pzZHlwV0NFUTY5NDAwRTdKV2EwQkd1SnJaaHZ5SkhM?=
 =?utf-8?B?bVN3WGtMQjNrTmovZ1R6WEhmWHFpVm5ZVTkvUlJVbklNaVJHa2Q4Wk1XTThh?=
 =?utf-8?B?TkRvMjVFc3pBRDJaR2pvYkVGREZaNGw5NjluR1lKeXFpdWpRRWFlSCtNL21C?=
 =?utf-8?B?NW9sSThnc2UwUG0xUTFGNzM5bGtqQ3Z1bHo4NEZ5UFdxQTFkWHFQN0tOTGlE?=
 =?utf-8?B?bkhOTjFBWnJZNDdWUlJ2U0Q0SERSWFdsR0xyUXVjYkpwSXFsKy9oMy9JR21Z?=
 =?utf-8?B?SHd6R0c1QU9WWmE4cUNpSDUzWUwrbVltNk1xZmhySEp4MElycDRFaVZ2Zmgy?=
 =?utf-8?B?OW16OEdLdmZTSDd5a3JMQ2JEalVsa29lU2ZLUjdmSnJxVWZWTWJUbVFNalp6?=
 =?utf-8?B?SDFsODBBRW4xRE1STkdCQkI2Qis1cFRNbUdPbzdidjdkZVFxTUlYMzN4WlBk?=
 =?utf-8?B?cUNEQU5lYnM5VkpCOUdWU2JDWlJ6dExjRjJwQkRPZ2QwN0hBZ1NZSlZKcXlZ?=
 =?utf-8?B?ZXQ3YWlkOTRWYld1UFpyZ0UvaFpyR2U1VjZjVnN5a2h0cSsyUlpzdWhYbXAz?=
 =?utf-8?B?UGNwYWEzRG41bW83bytEb1loODdQRGRFK24zdTRsL2FrWU1DTnlSNHN6VGts?=
 =?utf-8?B?ZWg5RFFyMlFBUndudWxxK2hDTzRGZG85ZktEN2xpNWNBMEdnYTJ3V2dYNklV?=
 =?utf-8?B?T2hPaCtWSER4dlY0ODc0Wld3SmVuaFdnOCtjRnNEWGI4YXp1N0JGZGVkSFVY?=
 =?utf-8?B?ZFl4V1ZtWGNTUDR6R3hmaUczYXpEV0I2cDhwZmVBelVTclU3M0d4RnpxcUw1?=
 =?utf-8?B?R04rYlBtNUFNazg2bUNtWG9DS0VSYzZBeElsMURUT0QzSE9NSUZRZ09vcGUy?=
 =?utf-8?B?N2JKR01VYmRiNHp3YTgwQytlNnBKOHl1VUMyNExVMzgzUUNkRFNmVGVMSi9B?=
 =?utf-8?B?NUpzOTZvSlFrWTl1T2ZXZEc0OU9TeE9rYVBkS01UWUtUbGlBVVZ6Yit4aVlF?=
 =?utf-8?B?Z21KcUxYQVdEQ0EzdW5pdU8yYkk2TmxqRk12amdtSWZWbjViZDlpakV4VFFR?=
 =?utf-8?B?djZ0a2FRUGlRQWllZENyZDZqSFhSUjRsSmg2TEhMVUx2RTJkWlhoVUp2azVv?=
 =?utf-8?B?MVFCYjBGblJBQVd5RmgyR09jOGwyVVF3Z3ljNTFXdDdoeTA1RlVtbHBIYVYr?=
 =?utf-8?B?TWpDZjV6ellaWTA4QlNsWG8rUDhLSnZ3OW41VVMyUERRTW9rMXVyM2pod0ta?=
 =?utf-8?B?T1hOOThIaHBuNjRiVFk3KzNweXdTSGZIOTZEM0pHV2E3TVpYWFdGa1kvWW5j?=
 =?utf-8?B?TGpvVnNzUi9KK09yaE5hOVczbENxeXhaQ3ZPSWticWJwTUhiZ25WNjFyb24z?=
 =?utf-8?B?SkVjN3RjQU1TYnVZc3pzMjNLZjhsaksxK3FDbUlzcE1zMTFFMXFwaGU3NS9L?=
 =?utf-8?B?Wks1TUx1WE5RZGpOQmRRK0NSMVUzeEhYdzdMYnF3MlJlVnZhLy9RVkszZVdO?=
 =?utf-8?B?bzBUQUdwQzZ2ejROc3ZBdytvdGw0RS9HUUw4bjljRVZnaTNEOWJod2IyWEpP?=
 =?utf-8?B?MVRKOE00Smc4dzIzRVpnNzMwVWpvaTd3OVdhR1o3aEJwc0tQUVNBMWlldEdU?=
 =?utf-8?B?RVFoMjl4NXlKN0Uvd1dlM3A2VTBNSDdFVXJ0T3lmQUVGcFArdXBxSmVyWUJT?=
 =?utf-8?B?V2lNTS90c2hndDlRS3QwRCt0OTlLL0xXdGE4MnpaVk5nVVhuZkVFeG5iaDNI?=
 =?utf-8?B?REx2VHNBWU1kQ0dEeS9uditaYlc2aU00Ym5WOFFnWHl3U3pGT29BSjdlcDBG?=
 =?utf-8?B?RHNGaHR3aUUvRUJsVnlqQk9OL25odXh1SmtEMUZFQTdzOCtYbmNaYUtpZmU1?=
 =?utf-8?B?cnI3MDAyelRnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0hlYk5oaWFNRXN5ZTZEUll0ejNZd2hRcktUODArK1djZ2ppSEFkK3B0eGxF?=
 =?utf-8?B?Q1huNFIzWDNtUjdIYmNaMnlFa3haOEVHbzczdU52UFE2SFlhT2xlcm9ybStu?=
 =?utf-8?B?TUdOdlkvWDVwbERMSC9GSG5OaFkxMzIwL0JMN29tTHNYQmV4MWQ2YVluL0Zu?=
 =?utf-8?B?bThDN1NxS21yd0VPeERHZU9UZDZpNFhNaGlaeHUySHN3eUVSUzhoQnhqSkVj?=
 =?utf-8?B?NW51NkxmdFlleGNNMy9uVXJyTlBBVFFJeG1CVWMrZ0xsbXl3Z2pIelNGa1da?=
 =?utf-8?B?eWFpcmVmR2pHb3htVktKZ09maThBTnJBRlZEWGk5SzBZeEZER2lEbkl1QXFq?=
 =?utf-8?B?Qi9xWW00WWY0QiswWEQxQ1V1REFKdU5QNXhLNm5PM0t5LzV6YVRPRlpBUUFG?=
 =?utf-8?B?Y3ptd2dJa2VSeHMxcHA4UkdPS0NOZDFSYW95Y0F3QXVucVA0R3A3Wis1SGNJ?=
 =?utf-8?B?RFJLdXI4L3dGbHlUNkJmK3EyS085TC9sbXJIWFNXK055K2NVV2x0dStsV252?=
 =?utf-8?B?NjFYWmtubHhQUEp4VkljZmtWMzhvQnJjWU41QXpTVGhuSHh4M3VWdW9mOG9q?=
 =?utf-8?B?TkxOdnZCSUhxZmd6M2pHZnduQitFcmRDZU1iWFZhTHZtL1dNVWpKeXdPeVpT?=
 =?utf-8?B?NVByWmMrK0VGaUY1TGZtMnpuR0xvNUxMSDIyYzF0dExUakNjTmYrNjlhb2V5?=
 =?utf-8?B?OFhYU2FnKzYrQ2J1aVRMVUVNTVlnZ3E5eDZiQUViWUVPTVIvRHUvQVo2M01E?=
 =?utf-8?B?cnhTejJrOGRJL2N2STBxR0ZiMWZWdDRwWFZYek0rb2hLRTJrRkcvd2xsNkR3?=
 =?utf-8?B?OGo2UGtDTTh6RzRUcmRZaFBpRlFFcml0Z3FZWU04REV4d2R2N0ZpVEdFWmM3?=
 =?utf-8?B?VWpkSWdGUVc3WG45TFdHZmZ6aGl0bit0Z3JPWWl1NzNrZndBY3Q4MGlGSFh2?=
 =?utf-8?B?d1h0TU4xRlJiOXNuamNJaFlFWENHZU5jRXM3azk4TlVHczVxeVZYQU9wN1pq?=
 =?utf-8?B?UVByQ05WZ2pzK1Q2L1lYS3VDaHhxWlhqaUs1ek9zOFRFQlV4UVVTcWs2RGp5?=
 =?utf-8?B?TEFidERLYXFQSFhxaWV3WmMrcStsYXQ3UXJrY3dkczU5TGFSemViTDIyVUJ0?=
 =?utf-8?B?Yzh1VHFkcGNnYU9ERlUzQXcreThpMHplbkEzamo1bFgyVFI3OXZ2cDFYbmRV?=
 =?utf-8?B?c0xsbHdwcW9zU3FlSUtsVUVqb0krWkYvaEgxRk5jMjQ4OTVZMllucStFN2xZ?=
 =?utf-8?B?aVYzVzlCMFZCYzZQUS9BWndnSVN1eG1JMU9DY0d0d005YlA1TDhxYkFJckox?=
 =?utf-8?B?NmJnTlI0ak9PU1ZjUncrcmI4VlRYQXlZSmswRGlaS1pTUFFaY1JPbTJVUnVN?=
 =?utf-8?B?NnVmREQwc3ROY3craWpyZzhVcXMwbTgyVnR4aEY4MGRyck1rUGN5YUYreCsw?=
 =?utf-8?B?cjBLT1ZOb0dEeXZWL1hpVmk5VUtlK0NQd2VBODZTNUFWd2YrSUZDU2FBY0Na?=
 =?utf-8?B?dkh0QloxZ0drbktsSHpTQkFSL1lTT2dnektVbjBiRU5zeGJSUkdqL205UU1r?=
 =?utf-8?B?eEtmamp2V3Q4QTMzZXNuNGNjSS9HQ0FFSWhuQmVpME1NeitGR3dON0RsQUR3?=
 =?utf-8?B?U3R5dEhneUZqQ2pQc2MxdHB6cUpudGhxMEtqelVUYkZmbG9RSk5kWkdLWG9W?=
 =?utf-8?B?RE80RU5UZm90RXh2eG5jNGJ3azQ4R3UrMzdpb1M4Y2k2cGxQUWtCVVp4SnRj?=
 =?utf-8?B?OXF2TU1sWEt2U1BQWUs1ZTJJN2VUQWgzS3VSQzMzeTFEM2ozd1ZMTTdTeXJY?=
 =?utf-8?B?TWtRNHR2RHltU0JRTHU5cVM0b1VmWVNhWnkxS2ZRMXh4RHZjMFZ1ZWp2MGlH?=
 =?utf-8?B?R0pRQXFsY3R1dTFBbzJXUFRyTVZha2E4aUdnNm5LTVNhb08weTNmWmJ4ZTdP?=
 =?utf-8?B?cTFQdi9iWTlxTVplUXgyUTRLUmZLRjViQzNFbTc2UTNVOXdDN3lKMjlIU2Ev?=
 =?utf-8?B?aXFDUlRUN2UrT2ZUZVlzNmF0UTNuWFpOR3NDRXRhMkliS0Z0Tk1CS1hZS0FT?=
 =?utf-8?B?b2ZKTjExdHNGbS9qaDEybm5rVG9aaVN3a25MeWg4SXhpSkNQNDhVV2ttQjg5?=
 =?utf-8?B?NlArWTVQcWEvRXlPUUp0UVZqSlcrWVQ3TlpkVW1VL1c5Z3VsZ3B5T0NQQWE1?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EDD4DA087A58249ABCF40DF774689AA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e412aef0-13e1-4d08-5c70-08dd7bf04fbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 07:37:01.6429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TN5owq8wmCX2UgPyKeSLnWiTlfpWCMQqB3F+gS3ARHwC9o4dJuKB1T28uXnlIsuiZDSzEEp6vta1s9i+2xF6uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7199

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gCj4gQEAgLTU1NjIsOCArNTU2NSw4IEBAIHZvaWQgdWZzaGNkX2NvbXBsX29uZV9jcWUo
c3RydWN0IHVmc19oYmEgKmhiYSwKPiBpbnQgdGFza190YWcsCj4gwqDCoMKgwqDCoMKgwqAgbHJi
cC0+Y29tcGxfdGltZV9zdGFtcF9sb2NhbF9jbG9jayA9IGxvY2FsX2Nsb2NrKCk7Cj4gwqDCoMKg
wqDCoMKgwqAgY21kID0gbHJicC0+Y21kOwo+IMKgwqDCoMKgwqDCoMKgIGlmIChjbWQpIHsKPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodW5saWtlbHkodWZzaGNkX3Nob3VsZF9p
bmZvcm1fbW9uaXRvcihoYmEsCj4gbHJicCkpKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfdXBkYXRlX21vbml0b3IoaGJhLCBscmJwKTsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodW5saWtlbHkodWZzaGNkX3Nob3VsZF9p
bmZvcm1fbW9uaXRvcihoYmEsIGxyYnAtCj4gPmNtZCkpKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfdXBkYXRlX21vbml0b3IoaGJhLCBscmJw
LT5jbWQpOwoKSGkgQmFydCwKCkhlcmUgY291bGQgdXNlICJjbWQiIGluc3RlYWQgImxyYnAtPmNt
ZCI/CgpUaGFua3MuClBldGVyCgoKCg==
