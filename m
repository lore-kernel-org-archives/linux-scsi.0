Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858672D481A
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989377; cv=fail; b=plkqXCqk18XWaYDnkc/E5QJf5ZHNWLChU99C7sMRqY9kOPEgBYTQ2OAV8NuyMigLnSrmHkqmeeZspm49+o1AGmatmrH7T1o4zxYgMheTAbqMYxGLuMnHlISPaMt5+P4FoJIbtsBJN1wssI7LrWwdxVd6m/Zwd3rGcSz96D/RK3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989377; c=relaxed/simple;
	bh=elvNxnGpaBL8flbqvQnTUd1laGZfCST/xa871br2GOY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dj2rnY+bmgNTJHmXytMlj6c4od8Zjvspk0QijAy94qpBIIJJ6XN8tKSaCKIt7Jvsz+8z02Dun5aY4yPYFgQ5uDwSaGpDLsuMlcUzomiNujxJaCLmCaJDQEZ+H5qLDQgQVvXBXBjMkGuDI5yrkakXGNMFklpdDFL5TITiF7VkBm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AWHZXkjT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ulyQWvB2; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AWHZXkjT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ulyQWvB2"
X-UUID: 1f515a3e775b11f08729452bf625a8b4-20250812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=elvNxnGpaBL8flbqvQnTUd1laGZfCST/xa871br2GOY=;
	b=AWHZXkjTm5J+nCdnBGAWc4PJCPL7Stl3Fa46TVNuE6gx5On6kcpdUTcO1FRlNulnfHrl4m5zZqkkjexEUul7VQGIarCugH+IEM/AFNBGyLxyQismE3rRiZEkkQXwwtYZ2D0kG7L4Zxnm8F5SqLdx0PDk9NWapQPeTgcS0oZdYAg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:3ae81cfa-f400-4aff-b6ea-b8b04ffb5133,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:be8d5151-d89a-4c27-9e37-f7ccfcbebd5b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f515a3e775b11f08729452bf625a8b4-20250812
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1848427761; Tue, 12 Aug 2025 17:02:49 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 12 Aug 2025 17:02:48 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 12 Aug 2025 17:02:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j47UlGrPEmvGwHTNjZpZZOKcE8LWosXrykmNKG7j7SQWAvCDkeVBfUvJWk5MxQGXHcdV3dCPnL2r6l+QW6lzbb+dCSDRXkq2haRIE8DIwHa+QSB2IgMeyz7gugmhk0Ts40eayruqa7td0ZzJzOwYTrWy2tgKUOjUxDc2Dc5tyoMAC8qQ2EA+khrB06e7vVl2jexDqWOdavZODsYCJPFrOmOZU5WJPWafqT8LzXV9fEl7Z8Ldu8h5NEIxncle9SV1q/UhEPXaRBB4PhRSQFVWgOlXI2n0g1ikK4vKvqN5XbPwwujcO/ziy5ZrNPB2huCGkgR4t7zfkNm34n93X2J9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elvNxnGpaBL8flbqvQnTUd1laGZfCST/xa871br2GOY=;
 b=e74LE6XyKPUi9JB++u2UD6vVDRLtL11DWhiP8Lm5+wulqJFeYwxXIy5+KDcO7FBj8Vb65A5munHNCGU9+UtwXUikokhhUyOsK1F4RunwAoRly0bYJv8WQ5/zcnvks0Pe8QGPjPnKllnJ/SFBKxobnw5CVO6Apue9bwag2f830nF7aAc6gNKGgoSVyabcLC1bGoAgEvUjG0RdeoF5sJCOqZX2t7E2N2sd8YF04wnArl2hyqQ66u64R2GRRlAToyS9h7Rw6NZbLKeLOqfc/nkf5OkLpxk+IVv9O/JHBt2bxKSrdbqQoFRZh2Xk1nAytxOGUI8CjxiWrK4Oc+kaVUewLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elvNxnGpaBL8flbqvQnTUd1laGZfCST/xa871br2GOY=;
 b=ulyQWvB2i/Nh4+/D6OcCYmhhu3mU8FAH1DhhWaiEy8CR6B6cjR/sFSfZMcVyhKfwflmsouCXuq0NwnNSTeFrodKD0049xkscqQJ5MeTgoZ2rMtauFWBe4nxZSnEr160sRawHD2ADLQFhqVgtRr43m88J71Ya6v5TBDm1ybOMgEk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE1PPF1EE48B57A.apcprd03.prod.outlook.com (2603:1096:108:1::849) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Tue, 12 Aug
 2025 09:02:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 09:02:46 +0000
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
Subject: Re: [PATCH 3/4] ufs: core: Fix the return value documentation
Thread-Topic: [PATCH 3/4] ufs: core: Fix the return value documentation
Thread-Index: AQHcCtdn6W714RJgZEC6a8D0CjARpLReug2A
Date: Tue, 12 Aug 2025 09:02:46 +0000
Message-ID: <871b506eea930ac2981cc1d332a6b6ed5e2eccc0.camel@mediatek.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
	 <20250811154711.394297-4-bvanassche@acm.org>
In-Reply-To: <20250811154711.394297-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE1PPF1EE48B57A:EE_
x-ms-office365-filtering-correlation-id: d7ecc015-8c67-41ac-73d7-08ddd97f0136
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y1JnWlhIMUtJeS80VVFIVk1Mem41ZWNabkZNZFRaNEZreVFHUTdDaVJJeStk?=
 =?utf-8?B?YnFRNy9xM2xOV203enBTQmg0bUdvaml5czlyZWxZTURpdDZxWk9Qc2RHRU5w?=
 =?utf-8?B?aW9waGZ3TkR4ZW1jVU9NVVp0c09mQVp0dTAvMjBqVE5sSGxHdXdXSE1xUGNO?=
 =?utf-8?B?UGNhZ09uZ2tlaTBoWUFqOUJoZDdKeDBOMmpWdGVTcFh0ZHdPM2VUYmV6U3o4?=
 =?utf-8?B?dnhiQThPUlRCRXlwaC8rMERabDVSMlJrU0RXQ0c0RFFmVWxhNXM2VWRtZS9n?=
 =?utf-8?B?bCs5TmlqaVRtcDhpdUQ3RHZFVStmUVlrWUlHRExsY2RJSUhPbGoxaVprc2Uz?=
 =?utf-8?B?QzFhZ2Vra2tGTjc3T3hKWjBja3AwWnN5bS9SU3ZWekFFVWFMOTcrVy9XQ0RP?=
 =?utf-8?B?dTY2MTVWWTFzM2lKRmZ6dGc0RUVvM2xqYzJsaW1kMVA3NlEweWhmQUQ2bHlF?=
 =?utf-8?B?bFNJYmFQbWJSQ2VKWiszUi9oZFI4ZzJoejFTbGpPWTBWQ1F2b1BSUWc5K29m?=
 =?utf-8?B?aWxzZ0JDYnZKdEhKYW1leTh4S0VjV21nWVE4RjV4UFRGOFAxdkdZODRmdTNB?=
 =?utf-8?B?bjZvRWZQQkJiR3dCRm93d3VWOGlCbkh6Qjhha0JaOWRmQmpQZGJRdzJiUFgr?=
 =?utf-8?B?SHdGNHpKQ01JM1dlVmlQRVo1bVE3dFBYb1ArU2RUR1JBdkEwTlJVLzV5UW5Z?=
 =?utf-8?B?MEMrbUZSUlpyTWJYTXNYNDZEb21sOU9yU1kyclpHemMrZjV6YVRPbFFhLzVK?=
 =?utf-8?B?c0lnMGtDWWhYbTVzaC9Zb083cEhoV3BMV2JRWS9BZ09mY3BRTENJalRSa1cy?=
 =?utf-8?B?L0c5SDZ3MWZGemhIak9PVWREVUx2d3hSQkE1SnhMeDNZekd6YkpsYnJKUWRT?=
 =?utf-8?B?QmdjVTBBOXlEYitwK0dybGdVSEQ0b1Fhd3h0Q2JMNGNvL01EdU1OQkRUdkQx?=
 =?utf-8?B?MjhWWC85bHVKMDlnSnhsUnZGSGRwK3VOUWNxbHN4Y3JRZnB2d1hvdVBTMThr?=
 =?utf-8?B?cElQRUZmeisvc1N3SmV0dkFabkllQVBDazk2bFJOOWRJRXAvb1BaZTlnbzB6?=
 =?utf-8?B?R1NwUmZMSW92Z2p0NW90dXhhWHFMRUpoMkpEZ1pWdVVOQm1xeGNINnRhTFJo?=
 =?utf-8?B?N3NhVHRHRkN6WGZxNE0waExoTmZTb1RXbnhhcHFEdDZTRzJ2MUplS3Z6UFA0?=
 =?utf-8?B?ME9qSm0xbFJtUlFMcjB4b241ZFhaSFdXZWI2bjdJdTZZMlJ6b2c5OTEyOFFn?=
 =?utf-8?B?TFNzdHpMREgyVjN2QlJBRTd2OVlwU0xOWnhidkZSUmYxWEVpdmdBKzI5SGZT?=
 =?utf-8?B?ZmY5VkFjU0FjaXdQWFNZYTVQeFZhUDNTdW1mOEkxM3BLRERLSk9uSHFrbDJZ?=
 =?utf-8?B?am02dzZuZmdycWorWHdRd3JzOEtBaGpKZ1A4ZVh4SGJzS2dvZ0pJaWg4MmJs?=
 =?utf-8?B?d2sxV0JHNnQ1Ull2N0tFLzlVVmFzeG5mN0dpZk9rcmNyRkY2aXlXS0ZMVXpz?=
 =?utf-8?B?U0cyRm1XaStmdC9XQmN4ZGVLUGYzNnlSMzlOai9FZ1dXejdBdVhiQVh1Ym5I?=
 =?utf-8?B?bVZtUVdMSUkxMXVRSG9wTjM1aER0ckFPVitKamFoSnRSTWEwSnBZQTF6b0VX?=
 =?utf-8?B?YnNVL293YjV2ckJRb21Vb0V1SjBWdUEzb3NJQzN5VjBoR3VUSDhRTE1PL0h4?=
 =?utf-8?B?MlBneTZHeDEzR05ibmxVL2t6WXZYWWEzT3VEZzRMdU5WRE5HN1ljcjZqU2dR?=
 =?utf-8?B?Wld1ejhvQzc3aExFRWlYTmxGRGQ0b2VJbnpuWUJKcHlSM09ONWR5WXZMWlkz?=
 =?utf-8?B?VXFWcnNvck0yeUg2aWdVUVZjZi9Fd1ZCeEZYSjVjN3VSL3ZZcERpck1VYlA5?=
 =?utf-8?B?ZXhINFBsa0NPWm1od2diTEEzWVFNTHpHN1MzUlByY1RWVGU4VlFLc1NjR2p2?=
 =?utf-8?B?Rmt5QkJZZUE3TjFtY1d6cEJaNkcvRnZkakhqWmZrcGZnYVo3anRXcWdoWHYv?=
 =?utf-8?Q?a51T2v9RoKqoUCVmp101a5oob2JauE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlhkZHBUajVrUTB3N1RuYllNWVhmSHdud3E1bUFrUE42R1dzOHU4WVYzK0pH?=
 =?utf-8?B?a3hTb2RhQzdiVnBYdGtscmdXa29Sc0hpWVk2UDJPb2tuOFRQQW1IUEs5d3JB?=
 =?utf-8?B?MmFqWTZseUt2M08wd01xZHpMMFRoYXY5VmtaSVYwQXhOQjRHc0U0b2JXQVBZ?=
 =?utf-8?B?Y09qN2ZPZytTaGthQnpNblN1L1h1MWhpZmJEVDFnVXN3ODNrMlJTa3kyYXZn?=
 =?utf-8?B?UEYvT2dqdWhSUzEvZ0FRUi9FczZmYTlqSm1KbVpQOG9XM3lGcVhxMkZWNzB1?=
 =?utf-8?B?RUc5OHBZYyszblVNdFFiWTgyL0N4T1c0R2FQUU5yTy91ZVMxSXFZVzFlQ1ll?=
 =?utf-8?B?U25iK1lHMkxkdzhFaXp5bVlNeDVTUU9UVVJTeFhvZzE0b0JXcTBOTlpielpI?=
 =?utf-8?B?ZTVSZjM4Y2JPSHBmM0xUVHg0QmhOaEtLOVlRQkZNemFaVDJkVkMybkFIUk56?=
 =?utf-8?B?M1FKckhvVVJHVUxOc3JmNmNETjg2NlN1eVJXek5ySzR1dEZZRCtvOGNhc3lz?=
 =?utf-8?B?TFJCeWUrazFqQWVUeTBtVmQyaklYcFl6V2FtSUREZDVoOThOMDlwbnN6WElV?=
 =?utf-8?B?SWk0djZyMVFsQnVYY0VQaXoxSUFNRzNDZUxZbkxxWHhRdDhvRUxyaldPOTJo?=
 =?utf-8?B?VDRxTExPc2JCWEZaUW9Ea2dmUWRvSW1uR0ljWGJoZHRjMGpNbFROcHFkU1N3?=
 =?utf-8?B?S1pocGF2TGNTSy80OVFsR1AxUyswSXZmNjh0RHhVUyswZTNwMi95K1FhTUk2?=
 =?utf-8?B?UytGdWVDa1lTUVpnNDhzQUhaeGlEMkNvSXVxWUJmS2FTOG5XRFNKWFpZWkZl?=
 =?utf-8?B?Q1VHYzVJV0c2bE1MS21uVWMvaXVqVGJiQlJTQlY0NHZhWUltSldzL2xOK2oz?=
 =?utf-8?B?M3ROckVTLzR3L1RJUmZEL0ZKYXhhUFVpZWNOa0tTZ2dlWlJ2T0RsOWVlbHFZ?=
 =?utf-8?B?ZDZ4UFBzb3dyeGh1ekpCUWtKNEhqUjhYRjFwVHNTRGVrRnVvTzRKQ1hZVE1l?=
 =?utf-8?B?dHc2NkpnUzdYZ2lrYlZweUZ3YjJNbTVmVVd3R1JhbzFwMVNwTjRUMjF2blVa?=
 =?utf-8?B?ODE5UTdnNVQzV1BTMXhnREJVR0hrZEFXc29oRDV1eGxMcHFSazFiMkdjZDl5?=
 =?utf-8?B?OFo5R0hkZG5CRWx3SWs2cEVCVkpaR3BZS0FQT0Iyb0VNenJneGMvZ245MzBB?=
 =?utf-8?B?RGxHMVZmek10ZGVvSTlXenBWdEdsWFdqQTJ2Nnlwb3MrU0J5Y2V0V1hQZEh1?=
 =?utf-8?B?WUR5ODFUdzZ0eGxwYUY0YnVKZnNaRHdYNzVzcGpvS1lHdmMwMGZmUHUrQU1n?=
 =?utf-8?B?RVNXaWFBUnZHK1Q1OTAwdWhEd0RyY1hnRFNZQmNNRTJ0QzFuTnBPYmhHMmZV?=
 =?utf-8?B?dldOT0kxMVRsWWpqZlk4RCt6cGoveWsxVTNyUDFFSTlETXJUdEo5M3E0N1FY?=
 =?utf-8?B?cXRhaTFhVGEybEQxMFl0M2NvT1k4S256Q0FqSkN3Q2V4WnFESS9VKzdZSzV2?=
 =?utf-8?B?Y2dXTTlOU3doczloOEZJRVJuUlZMU1VwWnhITWJNMDV6RTArT1U4SjFMS0wy?=
 =?utf-8?B?MGMwUGhBNTlxTUpvMWlTWmpjbXlWYlZoU2gwU1hVamQrcWJLSDRMWXA2V2pa?=
 =?utf-8?B?QnFQNkJyb0hSOEd3SFpvYW5JNWlCMkR3NUZqL1prRWdqeENSUDlVQkNQaWNr?=
 =?utf-8?B?YmZMOE5HbzFUTUZpZWM2VWFtdlpGYldpNTZOZ25LbnVUVzNtcWNGSm8xZFV0?=
 =?utf-8?B?WGdhMDFMUGpGblRuSDJXZDI3V2MrenJuTlU4VDZtb2VvbWx2elNSdlRScTV3?=
 =?utf-8?B?RXlQalNlSHFaTjNFQkxrN0Q5MUlYN2p6MlJ1SVhjdDBwblVvYnZaQVRMK1FM?=
 =?utf-8?B?YjM0QWxLRFpnZjhkRFlJNDQ3ZURaSzlST1VhTXBwVkxoS05rQXMrVjYyaU00?=
 =?utf-8?B?c1ByT28wVE81RUVqVmYrai9odENGb2QyRUZJZnU2cTErRWEwcnR6QThSZkln?=
 =?utf-8?B?dVBINzIya1VMYzVKWDRseTdlcjdKS1gvZkNiMzV0R0d5M2hBc3p3VUlnZVQx?=
 =?utf-8?B?eHpwT2xpVzhsWFdKaHRQaG1RVnYrM05keVdSeHhlS3o0Z0g2NHZFVE9QREQ5?=
 =?utf-8?B?b3UyTG1COEQrOUw2WmlXRXdpcHdrek9hT0tySFc5Ri90dk9Da2pYOTFyQVNW?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1C0DE92CFA61344A0641508F5165128@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ecc015-8c67-41ac-73d7-08ddd97f0136
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 09:02:46.0626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XpvzpXpe6gR9r+pst7ZrYJTC2ijPvTeXwwtpq3VBby4FHC7hasVL6ElWmmzkuli7hgGP1NryPep8PgEzPQa1Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF1EE48B57A

T24gTW9uLCAyMDI1LTA4LTExIGF0IDA4OjQ2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHVmc2hjZF93YWl0X2Zvcl9kZXZfY21kKCkgYW5kIGFsbCBpdHMgY2FsbGVycyBjYW4gcmV0
dXJuIGFuIE9DUw0KPiBlcnJvci4NCj4gT0NTIGVycm9ycyBhcmUgcmVwcmVzZW50ZWQgYnkgcG9z
aXRpdmUgaW50ZWdlcnMuIFJlbW92ZSB0aGUNCj4gV0FSTl9PTkNFKCkNCj4gc3RhdGVtZW50cyB0
aGF0IGNvbXBsYWluIGFib3V0IHBvc2l0aXZlIGVycm9yIGNvZGVzIGFuZCB1cGRhdGUgdGhlDQo+
IGRvY3VtZW50YXRpb24uDQo+IA0KPiBLZWVwIHRoZSBiZWhhdmlvciBvZiB1ZnNoY2Rfd2FpdF9m
b3JfZGV2X2NtZCgpIGJlY2F1c2UgdGhpcyByZXR1cm4NCj4gdmFsdWUNCj4gbWF5IGVuZCBiZSBw
YXNzZWQgYXMgdGhlIHNlY29uZCBhcmd1bWVudCBvZiBic2dfam9iX2RvbmUoKSBhbmQNCj4gYnNn
X2pvYl9kb25lKCkgaGFuZGxlcyBwb3NpdGl2ZSBhbmQgbmVnYXRpdmUgZXJyb3IgY29kZXMgZGlm
ZmVyZW50bHkuDQo+IA0KPiBGaXhlczogY2M1OWYzYjY4NTQyICgic2NzaTogdWZzOiBjb3JlOiBJ
bXByb3ZlIHJldHVybiB2YWx1ZQ0KPiBkb2N1bWVudGF0aW9uIikNCj4gU2lnbmVkLW9mZi1ieTog
QmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMgfCA2MiArKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tDQo+IC0tDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKyksIDI0IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IDEyYWY0ZTA4MjRjZS4uYjUwNTdjZTI3
YWE5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTMxOTksNyArMzE5OSw4IEBAIHVmc2hjZF9k
ZXZfY21kX2NvbXBsZXRpb24oc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gc3RydWN0IHVmc2hjZF9s
cmIgKmxyYnApDQo+IMKgfQ0KPiANCj4gwqAvKg0KPiAtICogUmV0dXJuOiAwIHVwb24gc3VjY2Vz
czsgPCAwIHVwb24gZmFpbHVyZS4NCj4gKyAqIFJldHVybjogMCB1cG9uIHN1Y2Nlc3M7IDwgMCB1
cG9uIHRpbWVvdXQ7ID4gMCBpbiBjYXNlIHRoZSBVRlMNCj4gZGV2aWNlDQo+ICsgKiByZXBvcnRl
ZCBhbiBPQ1MgZXJyb3IuDQo+IMKgICovDQo+IA0KDQpIaSBCYXJ0LA0KDQpBIHJldHVybiB2YWx1
ZSBsZXNzIHRoYW4gMCBzaG91bGRu4oCZdCBvbmx5IGluZGljYXRlIGEgdGltZW91dCwNClRoZXJl
IHNob3VsZCBhbHNvIGJlIGNhc2VzIGxpa2UgLUVBR0FJTiBhbmQgLUVJTlZBTCwgcmlnaHQ/DQoN
ClRoYW5rcy4NClBldGVyDQoNCg==
