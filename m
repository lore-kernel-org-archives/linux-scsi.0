Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661FA12CDBF
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 02:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729564712; cv=fail; b=DKFH+WN9IKSDaukUHbcGJPvGI9D+FAGLbJXVR9Rz7YctoqzT3sBUfRHvd4xFWBjRnz5pKyzr+oPPm7uxT6PVbeQgHm3S89XGANii0ruLuyLqXWWaSUCvufwrbmqG0gKPqa9kVa0wXiHeqrQ3ZjFkRcCy+fUA61oaNiV9fqO2q2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729564712; c=relaxed/simple;
	bh=1XP63nvPPQtF1s/fwznmxXlUIJOcSnXxPqEXIsmiiAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PJnbr5BZCXvDlFMbbGCSAcCXRjwbLuBiqnPKlqRxrQm46mev8T8AiTOkhq9L0j+6Urdp5ss0Rz7GTvcn2Ovu1fDz0lZHT7jfks0K0iuJn9rOGXotWIfn8Zj0rSx3VQfC3+DH9Or+tP2aL8mftHSwAGoSZRvoJAyqJ+DxeFz4iLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LlHK7Shn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CE3HbRVv; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LlHK7Shn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CE3HbRVv"
X-UUID: b3882702901e11efb88477ffae1fc7a5-20241022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1XP63nvPPQtF1s/fwznmxXlUIJOcSnXxPqEXIsmiiAA=;
	b=LlHK7Shn0F6hJpuf1JjH5ug3jhzFN74165EK3f2M/bglS7udOlxHemSgArmJj2vO3z7KQHIs8weRnKSjGzH+zaOxkvy9QoLqi+UV6/P6Q+O4EXOZsbNbyUHr7d8dBFklJui6seovFKWIS6OT9DRgV3EKIGUVhkIsSwA3xFCxtXY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:1571237c-fff3-4efd-8b29-e22477ebb28a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:85409f41-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b3882702901e11efb88477ffae1fc7a5-20241022
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1707173054; Tue, 22 Oct 2024 10:38:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 22 Oct 2024 10:38:19 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 22 Oct 2024 10:38:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmpmGsic20om0YxGQM2qjDF3m7IrihpV36oEQOxTvSBOn5iSJDeug/n0+/lNeOrEjqoP2Fi/37JALBtxvarGXKnppcOrljR4ZbU/O9dqflILXeBrSMzm7RNWssFSgRYztuIQNfRab01WmPY+xDPLXQbI4nUKz9LLrtiIg5Pai8QPl3fTNgxjljhm7ppQgvV6MPSiRyy+7HvAws4ImTyuJyX0Ff5ntaDE6DhLVgkgGRVRoMvhIeVqymmE7EgZeS3hGEiME4zV/S/n6ri6V8v+BrMt7OulT0uVqCthpmAAPNn89sBJ9wIXY9TuTh9fdwgtAFpoa69bzuuXAgL6I640bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XP63nvPPQtF1s/fwznmxXlUIJOcSnXxPqEXIsmiiAA=;
 b=MleBi30YVWcVDaTQniqh2zgHywX9jVeRINvDcNt0s3v7wANCnWDHX2PPdC9lckOtdgvrbb+2GjVJmzbBQtJVUAijM7Gd1LKW5VSC8NMjsevPkm0w8fuV3x5Xah5L0OKOrkYbyyjRVfYEzObxv74JSs9ScJZfVEHQQFEIY9QMO0cBOTG3/oeSvSXmZKvycAxK2mI7F9autEwtklULtDVQH4d1HxWN1A9PlnCx31VoqJckfZhwHTT5WD0KEx/PQi4BhkyxTPGfcn4JrZu50o3IT3kFSV77PZeRBze1HFEdDfb/IS71W06q9gY6Blm4mUrENVmUJZ53VjtZLXGrTXBfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XP63nvPPQtF1s/fwznmxXlUIJOcSnXxPqEXIsmiiAA=;
 b=CE3HbRVvidQ2M4/t2e59TChJs3XfLDkcVhjS28RATsf49qPpbW6tk9a+Jn1HP3aUhtD/g58CGtoyLQxKZzpgEPGflvJ1eqRa0uS+BLE6uNFvgjaoK4XVzqkm6O8sU61I1NthVy4dx/vCbqZGXiHGXexSQY4q/ApxqkdBxkUl/vM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6845.apcprd03.prod.outlook.com (2603:1096:400:25d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 02:38:18 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 02:38:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Topic: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
Thread-Index: AQHbIBA1pPTrBqoK4E+TyRNuUcqSCbKQ+x6AgAC37YCAAGO6gA==
Date: Tue, 22 Oct 2024 02:38:17 +0000
Message-ID: <0fd375959cb12968d30e3b3db90bea3ab1691eb1.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-6-bvanassche@acm.org>
	 <37f935a047e05f001e1fa38f58d98abac4543ab0.camel@mediatek.com>
	 <dbd8fd89-57ca-403f-b47a-a3fce383d75f@acm.org>
In-Reply-To: <dbd8fd89-57ca-403f-b47a-a3fce383d75f@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6845:EE_
x-ms-office365-filtering-correlation-id: 57ff653d-5933-4e84-89db-08dcf2429613
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SEpoU3BwNlVScEEvUXFhKzlhSENkaXc0QW9CaWtncnNlYUt1Ykw3WEFHVkN0?=
 =?utf-8?B?YWdBWCt5YmxqYlVJTzNTV3VJaThrVVZiQld1ZGJaQmdTWFB0TndiTXJwc3Rz?=
 =?utf-8?B?TkY1cS9JaktMWnFhZ0NGSTFEQjRTenVaZlVOdUhudFJkVzhCa05xUGNHRE9F?=
 =?utf-8?B?ZXdzdG5ldjkxZUoreEFxdHdZb0dxb3RLd2xDNnh2OVVuZURvSGFXWDZhRkto?=
 =?utf-8?B?TnBOdjRoWWZrSkFDcmtxeGZXSmZUQzl0bUxwMXE5LzREbllzQ2ZFY0Z2Q2Zi?=
 =?utf-8?B?WHlRWHU5NkM2Tnp4V2lyR2MydGlzR3BKZmpHYmFrNUZmaWp3MDlQMkJodkFN?=
 =?utf-8?B?bTdXMFNVN0hzUVZqd1pNWGhRWDJmTml5SFBLQTZVNDE4cVZMZVRNOXg3cFhm?=
 =?utf-8?B?SmRGc040SDhjbkZoTjRWaFdBZHZWZzFqNDBOZWVCYmZYVXdvZnN3ajlwTlUy?=
 =?utf-8?B?QWplY0RxNDQrQVBoaDFMUzBFdmxPczY1MXN5QkNyNHkyRHQ0YzFvTFk5bXdT?=
 =?utf-8?B?K3oySXlkUG5VT0ErNFo5QUpYWG81enlNMlVBOVQwb244WXZ6bElLWDRUMEhP?=
 =?utf-8?B?V0RsakM4WG40OWxqMzRPRUppcUVldEFXeXU1ZnJEZEdxMk1oYXZYMnNiWDhJ?=
 =?utf-8?B?NDFKaVBndnJrVkV6a0t5VkRQVG5hcjVhem1UNWlaRDlwS2ptTDlheUI3ZGM3?=
 =?utf-8?B?RURCOEk5dmJvK0xQL3o2R3ZnY2Q5K1dkUm9qdDcrQ1NES2YrMDRnYmZXNUwz?=
 =?utf-8?B?RkUxbS90Ti9CS1pTZlZFdnZ3Z2UzUE9WY21jRTAvdEJyUEM4eXU1YWMza0xN?=
 =?utf-8?B?RjhSRXc1TnJrYjhQRU13elBpOEpSc3Z3U2JaeDMrNzdlbmZ4dzhkTWRtS3Q0?=
 =?utf-8?B?VEtQb3lzK3hMWGNJa2tmWnVMRUtFcENRZ0hFakYxQm1GdGpueW1EWVM5VCt3?=
 =?utf-8?B?UlBMYWY4VnlJSnZvc0o3MDBpbVBtclNQZlk4UnovaXovUFltMjVtS2xwejE0?=
 =?utf-8?B?MEtxUUx4c091b3I5ZWhOempiNFZzZ2J2ZUNhN2pLb3dOR0xuWTRKekxKVTFQ?=
 =?utf-8?B?NFVJS2hwUXdSbUMxbHA2S1JsVGxKYjd2SUJweHlhejgxQTBjK1htU2pnSlFV?=
 =?utf-8?B?aU53eVdHK2d6bERoTDIwUktJWnd4b2c4cm9VUC85WG9tUDNXMEpBbUNEbUdV?=
 =?utf-8?B?WHZtRzMyWHNmWnpMeTdaTHQybk0vcWhsa3ZUemhWTDdvNEt3MHExcHlxTkZo?=
 =?utf-8?B?YVl6aUhraGlIWFFnRWNKMXlxa0Fyc2hmRkgvT1dUUHhDVWpkT2ZHOXh0TTBt?=
 =?utf-8?B?dFJ6bEg1Y1c2NnlRZTF4cWpBaUhYZTJBc3J2bmQ3MEJhMjYvUjVZVjFKRHEr?=
 =?utf-8?B?dkljY2JManhMSE1sYTU0RHVUSTJDUEpkZ3dEMVBnNjJHUS9FdmFwOWhqS1Yw?=
 =?utf-8?B?SmxRQUhVRWRwei9MQi9INDBuSks2YWZsbVp6a2hERnlmZDlyUWtYVWZKajlx?=
 =?utf-8?B?cEkzYTFRNUJIU3BTQmNkMEFKRmJ2eS9UVkZTL2M4WEdTbkhYcmRnT3NzWlZu?=
 =?utf-8?B?OFlxT3ZQcndMdi9Xd3pjNjJ1NWIxaDc5SmlaeTc5emllbDNUYzVSaVh5b2ZC?=
 =?utf-8?B?VGg1eG1GajBxT3dkcnpSeEd0VVVOUGw5V2p5TzdtTENERkdBbEEvanBuMXkr?=
 =?utf-8?B?SGgxejYyREk4U3habHJEK3lIT1hsVVFRM1R6S2tKZFBic1hjMHJrNkNCR2Zq?=
 =?utf-8?B?TTRBTVJibVBnWU1mTUFySWswYm4zOHN2ZnpNMUNjQjVwUXZiV2ZkdXFuZE4y?=
 =?utf-8?Q?DfYHmjFpekCM4dsg/kYdpM2T5lAY5G0C4AJXE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGxqRVUrRTNwL05EaHdieVp0MGhYUmthTjY0ZGozQWpZdHFBbmdERGVUREZO?=
 =?utf-8?B?alRkQW1DOGM4dmZjUG1oMnVGNnhZdmZoQjZ1UndDZi96NEVhUW5aQjRHQ0py?=
 =?utf-8?B?UHJ5MDRKcVNrK1ExZnFzK3h0VmFnV0oxVnZOSlFxTmozY0VsYU5NU0dWWUVu?=
 =?utf-8?B?SkY3Q2Myd2p2YXlGRkl6ZTRlWlRsY3U0OTVNbmZBK3gxdis1MjE3TE9nQTVV?=
 =?utf-8?B?OS9yMEVrMEZjeFNBSlU4eGlNakNyQVBKeDIyMFRnZEh5SkFURUhrLzFJNG5R?=
 =?utf-8?B?ak81UTBGOEFYQjhlWkx2bTVENGpkTDRKSmQ5ZGsrSEVLazhuZkZkNjdOVmNv?=
 =?utf-8?B?UDFrMEpJOWpKQVFyUTU4S0g0ZWJLRnFPNDlHV3Z4SEdzdkp4RHk4UzRiMXhI?=
 =?utf-8?B?ejNWZUV0U3daUDJGU1BiZjRhRFlNYWdleUFtWmp6NExVV3dQa25Kc014WHdt?=
 =?utf-8?B?REh0RXNOV2piNHNiVUV4SmJ5MlduT3NDRFk4SnV0TnR0QXdtek9XbjRlc0pr?=
 =?utf-8?B?MTdZZXh2T0RQV2VvSXhlY25EWENkM1JsVkU1K25RNVJlSytXc3hlNmMvNGpH?=
 =?utf-8?B?REQxRWFCRnI4RTBybnY5TUZ5ZTVJdCtrdnQ4SmE5N05WR1NBQW41Vy9XVzlu?=
 =?utf-8?B?ejRzMTJlNklTdlhYcHNTTDVrOEJJZTRjaWpDWXo3cmFYMGt2eG51d2RaMDAw?=
 =?utf-8?B?bkFzWEVHZzlFSUhNdm5NNmhXVE15K0QweGRVNCtIUGxobFVtNksxR3RuZHFz?=
 =?utf-8?B?TlN6QWxEZjJxZmFKWGVINEZPSjdvQUNVR2U2dkE5SDhHakg2dDlscnZSM2FE?=
 =?utf-8?B?UW9FOGt2TkNqSDB1Mjd5bDFWZkZaVG5lMTlTTWwxckhCa3VNbVRlYzhJN0Zq?=
 =?utf-8?B?VmtsZXZWbWVyRlNNRDc3VHpueVc4czJNWU1jTG9xS0MvUSt6cjN1cVd4NkJz?=
 =?utf-8?B?TVREMnhEMmNuL2F1YkhxUTU3b2syVDA5bitWWlRZTUdJa2Nzd0xrY3pZbDFj?=
 =?utf-8?B?cUFGRng0S3NZQkFSSnB6K3VlUk9xTGxjS1ZLTk44d2ZuSWIwZml0enMwL0NB?=
 =?utf-8?B?aXpMODVtNjNEQitrVDlpbzNkV2g3b1Vhd24yTm0reElZTWJOUXlPSGFRNU95?=
 =?utf-8?B?YVkrb213aDVEVjNFazRMWk53QS9lQVlzdGRpVmd1WExVUTNpNms5UW9lTUpr?=
 =?utf-8?B?TkdteEpqQ1dybW1QM20vaE0weGN3ZTlZOGFFeFZzTUl5UDN2WCs3MHd2TDZz?=
 =?utf-8?B?aXc3N1N4YjVnOEF6R1Q4amd5VXRWV2EySUpVSGNsZkhDaW5NTkIrbzJTU3ZT?=
 =?utf-8?B?a3ZCTlZjZytGeERaNlR1Q3V4YU53c1R0RlRmVFpoWU0yUTFsN2ZXcXowbnNi?=
 =?utf-8?B?UkxEMWZ3L3RYY1lpYUlacnF4MjRQc1piYTVnWk1PSFlMd3pPczl6MWsxSERH?=
 =?utf-8?B?SDFHUXhvQ3pjd2JXRk51cXVSeFlDVlkrV3dUZUZJbXNWTVByUjhzclQwbmtt?=
 =?utf-8?B?cU1EVnhmZk9MRjIzYnN2VHhHUldLNzREa0ZNUkVxdklIWnhFY0kyTXl5bWlH?=
 =?utf-8?B?Q2JsY3FWUVo3VzQ3VDA1MWh0TUpNNFh4L2orOXBWTEp4ZFVMc2tkMTlnK3Rn?=
 =?utf-8?B?ZTVETG54cTh1QWc5amM5ZW5TdnZNTzNJdVZaZXdUZ3lhVXZWMnJJcWpYc3pz?=
 =?utf-8?B?VG5rUUY3c3pwRnFSMkVPc2dzeWhnWHMyY3VybmJZOExndmdTL202TWNzZUla?=
 =?utf-8?B?ZitHSnZ2bm9MeHNPa1IzaFpWU0NHR1NoRk83QkhZTVEybXNYYTRyM3VSYUVK?=
 =?utf-8?B?M3FNRStpNEJrbW41RVJ2eDRCbDlpTHlrdXJNa2VkREFQYkg4cFZjaXdOdTBo?=
 =?utf-8?B?MWQwemdiRU1mUjVSWEk4V3NWTWFZS29tb0RmRi9aYzlaWDhPTVZ4M3ZnZnd0?=
 =?utf-8?B?MkJ3RTVlNG9kLzY2MDVZUEJUanhjcThvY1hrRzJxNDMwUThHbXNJVnRYeU1T?=
 =?utf-8?B?bVNoVEJiY2ZIOXJQVjFXajdFd2NMVWdDbG55aFVZWm1iM0lQRWRLK29mR1d3?=
 =?utf-8?B?UXNpK2VIcEdObU5rU0F2MGtQekhoNHRGdXlJNmdtRGhjRk5mUHh6YnpKNk9z?=
 =?utf-8?B?Y3FPRFoyR0oxSFVFOWdpMXN1OTIxWXZxMFNnSk90Uy80Z2dMOFB5UXA3YlI1?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B9BA05B07E984469820AD50C8014E55@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ff653d-5933-4e84-89db-08dcf2429613
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 02:38:17.8853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6rvmpzzMFANZjy/9Ylqap/iWeMJ8ltaSBvOmDPv1DDxccUgwYD//Y98A5H2yszfOrlIvDu54fYeH8f25Aa/Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6845
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--37.780500-8.000000
X-TMASE-MatchedRID: xIhOSkOSohXUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QauZoybwHAwk0/x
	bS3+sxpRUZVKRsGcIuEhxaJhuh0LPwAMZ9wQmHhX0hv/rD7WVZChRWQHuJ8meV9eB8vnmKe9EVz
	8zAIggpSeULiW8I/Yq1S+wyEMlXe+riHqOVeJd03uTVkeYosXtcx5k3wffojNF6yga/Gq9sopbw
	G9fIuITXr+1sfTf9zLvagU6YVGYT8OJmY4XRXkVjNvYZHpO13eiNCtus+nPOn3hz57t9YhwhzsN
	pTq9I+7XuKn6Epb/8RpAxUsb/OiSis5BDvTwTvOeAiCmPx4NwMFrpUbb72MU1B0Hk1Q1KyLUZxE
	AlFPo846HM5rqDwqtlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--37.780500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	9E92C4B11ED37FBE763587ED25A56BB5D79F017B1731A1BECC64F965D0CD2A3C2000:8
X-MTK: N

T24gTW9uLCAyMDI0LTEwLTIxIGF0IDEzOjQxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMTAvMjEvMjQgMjo0MyBBTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBVc2luZyBibGtfbXFfcXVpZXNjZV90YWdzZXQgaW5zdGVhZCBvZiB1
ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cw0KPiA+IGNvdWxkIGNhdXNlIGlzc3Vlcy4gQWZ0ZXIg
dGhlIHBhdGNoIGJlbG93IHdhcyBtZXJnZWQsIE1lZGlhdGVrDQo+ID4gcmVjZWl2ZWQgdGhyZWUg
Y2FzZXMgb2YgSU8gaGFuZy4NCj4gPiA3NzY5MWFmNDg0ZTIgKCJzY3NpOiB1ZnM6IGNvcmU6IFF1
aWVzY2UgcmVxdWVzdCBxdWV1ZXMgYmVmb3JlDQo+IGNoZWNraW5nDQo+ID4gcGVuZGluZyBjbWRz
IikNCj4gPiBJIHRoaW5rIHRoaXMgcGF0Y2ggbWlnaHQgbmVlZCB0byBiZSByZXZlcnRlZCBmaXJz
dC4NCj4gPiANCj4gPiBIZXJlIGlzIGJhY2t0cmFjZSBvZiBJTyBoYW5nLg0KPiA+IHBwaWQ9Mzk1
MiBwaWQ9Mzk1MiBEIGNwdT02IHByaW89MTIwIHdhaXQ9MTg4cyBrd29ya2VyL3UxNjowDQo+ID4g
dm1saW51eCBfX3N5bmNocm9uaXplX3NyY3UoKSArIDIxNg0KPiA+IDwvcHJvYy9zZWxmL2N3ZC9j
b21tb24va2VybmVsL3JjdS9zcmN1dHJlZS5jOjEzODY+DQo+ID4gdm1saW51eCBzeW5jaHJvbml6
ZV9zcmN1KCkgKyAyNzYNCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5lbC9yY3Uvc3Jj
dXRyZWUuYzowPg0KPiA+IHZtbGludXggYmxrX21xX3dhaXRfcXVpZXNjZV9kb25lKCkgKyAyMA0K
PiA+IDwvcHJvYy9zZWxmL2N3ZC9jb21tb24vYmxvY2svYmxrLW1xLmM6MjI2Pg0KPiA+IHZtbGlu
dXggYmxrX21xX3F1aWVzY2VfdGFnc2V0KCkgKyAxNTYNCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29t
bW9uL2Jsb2NrL2Jsay1tcS5jOjI4Nj4NCj4gPiB2bWxpbnV4IHVmc2hjZF9jbG9ja19zY2FsaW5n
X3ByZXBhcmUodGltZW91dF91cz0xMDAwMDAwKSArIDE2DQo+ID4gPC9wcm9jL3NlbGYvY3dkL2Nv
bW1vbi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jOjEyNzY+DQo+ID4gdm1saW51eCB1ZnNoY2Rf
ZGV2ZnJlcV9zY2FsZSgpICsgNTINCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2RyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmM6MTMyMj4NCj4gPiB2bWxpbnV4IHVmc2hjZF9kZXZmcmVxX3Rhcmdl
dCgpICsgMzg0DQo+ID4gPC9wcm9jL3NlbGYvY3dkL2NvbW1vbi9kcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC5jOjE0NDA+DQo+ID4gdm1saW51eCBkZXZmcmVxX3NldF90YXJnZXQoZmxhZ3M9MCkgKyAx
ODQNCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2RyaXZlcnMvZGV2ZnJlcS9kZXZmcmVxLmM6
MzYzPg0KPiA+IHZtbGludXggZGV2ZnJlcV91cGRhdGVfdGFyZ2V0KGZyZXE9MCkgKyAyOTYNCj4g
PiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2RyaXZlcnMvZGV2ZnJlcS9kZXZmcmVxLmM6NDI5Pg0K
PiA+IHZtbGludXggdXBkYXRlX2RldmZyZXEoKSArIDgNCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29t
bW9uL2RyaXZlcnMvZGV2ZnJlcS9kZXZmcmVxLmM6NDQ0Pg0KPiA+IHZtbGludXggZGV2ZnJlcV9t
b25pdG9yKCkgKyA0OA0KPiA+IDwvcHJvYy9zZWxmL2N3ZC9jb21tb24vZHJpdmVycy9kZXZmcmVx
L2RldmZyZXEuYzo0NjA+DQo+ID4gdm1saW51eCBwcm9jZXNzX29uZV93b3JrKCkgKyA0NzYNCj4g
PiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5lbC93b3JrcXVldWUuYzoyNjQzPg0KPiA+IHZt
bGludXggcHJvY2Vzc19zY2hlZHVsZWRfd29ya3MoKSArIDU4MA0KPiA+IDwvcHJvYy9zZWxmL2N3
ZC9jb21tb24va2VybmVsL3dvcmtxdWV1ZS5jOjI3MTc+DQo+ID4gdm1saW51eCB3b3JrZXJfdGhy
ZWFkKCkgKyA1NzYNCj4gPiA8L3Byb2Mvc2VsZi9jd2QvY29tbW9uL2tlcm5lbC93b3JrcXVldWUu
YzoyNzk4Pg0KPiA+IHZtbGludXgga3RocmVhZCgpICsgMjcyDQo+ID4gPC9wcm9jL3NlbGYvY3dk
L2NvbW1vbi9rZXJuZWwva3RocmVhZC5jOjM4OD4NCj4gPiB2bWxpbnV4IDB4RkZGRkZGRTIzOUEx
NjRFQygpDQo+ID4gPC9wcm9jL3NlbGYvY3dkL2NvbW1vbi9hcmNoL2FybTY0L2tlcm5lbC9lbnRy
eS5TOjg0Nj4NCj4gDQo+IEhpIFBldGVyLA0KPiANCj4gVGhhbmsgeW91IHZlcnkgbXVjaCBmb3Ig
aGF2aW5nIHJlcG9ydGVkIHRoaXMgaGFuZyBlYXJseS4gV291bGQgaXQgYmUNCj4gcG9zc2libGUg
Zm9yIHlvdSB0byB0ZXN0IHRoZSBwYXRjaCBiZWxvdyBvbiB0b3Agb2YgdGhpcyBwYXRjaCBzZXJp
ZXM/DQo+IEkgdGhpbmsgdGhlIHJvb3QgY2F1c2Ugb2YgdGhlIGhhbmcgdGhhdCB5b3UgcmVwb3J0
ZWQgaXMgaW4gdGhlIGJsb2NrDQo+IGxheWVyLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4N
Cj4gDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1xLmMgYi9ibG9jay9ibGstbXEuYw0K
PiBpbmRleCA3YjAyMTg4ZmVlZDUuLjc0ODJlNjgyZGVjYSAxMDA2NDQNCj4gLS0tIGEvYmxvY2sv
YmxrLW1xLmMNCj4gKysrIGIvYmxvY2svYmxrLW1xLmMNCj4gQEAgLTI4Myw4ICsyODMsOSBAQCB2
b2lkIGJsa19tcV9xdWllc2NlX3RhZ3NldChzdHJ1Y3QgYmxrX21xX3RhZ19zZXQNCj4gKnNldCkN
Cj4gICBpZiAoIWJsa19xdWV1ZV9za2lwX3RhZ3NldF9xdWllc2NlKHEpKQ0KPiAgIGJsa19tcV9x
dWllc2NlX3F1ZXVlX25vd2FpdChxKTsNCj4gICB9DQo+IC1ibGtfbXFfd2FpdF9xdWllc2NlX2Rv
bmUoc2V0KTsNCj4gICBtdXRleF91bmxvY2soJnNldC0+dGFnX2xpc3RfbG9jayk7DQo+ICsNCj4g
K2Jsa19tcV93YWl0X3F1aWVzY2VfZG9uZShzZXQpOw0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9M
X0dQTChibGtfbXFfcXVpZXNjZV90YWdzZXQpOw0KPiANCj4gDQoNCkhpIEJhcnQsDQoNCldlIGNh
biB0ZXN0IHRoaXMgcGF0Y2gsIGJ1dCBiZWNhdXNlIHRoZSBsb3cgcHJvYmFiaWxpdHkgb2YgdGhl
IA0KaXNzdWUgcmVwcm9kdWNlIHJhdGUsIEknbSBjb25jZXJuZWQgdGhhdCBub3QgZW5jb3VudGVy
aW5nIGl0IA0KZHVyaW5nIHRlc3RpbmcgZG9lc24ndCBuZWNlc3NhcmlseSBtZWFuIHRoZSBwcm9i
bGVtIGhhcyBiZWVuIA0KdHJ1bHkgcmVzb2x2ZWQuIA0KSG93ZXZlciwgZnJvbSBteSB1bmRlcnN0
YW5kaW5nLCB0aGlzIHBhdGNoIHNob3VsZCBiZSBhYmxlIHRvIA0KcmVzb2x2ZSB0aGUgZGVhZGxv
Y2suDQoNClRoYW5rcw0KUGV0ZXINCg0K
