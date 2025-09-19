Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9983054D4
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269707; cv=fail; b=GK3rgVIbllcCtbSnGQXhD7trk7fK0JbSw5qu2Mi6ybge+D+q6DgSizz4357Cfyz0MlWepVcFTJDsP3f+lMn9HKCkRX/vMDJpZSY/T051jO7wcrtzkOhhSpCM8o2e8vPqkhPzyF5/nZWPbf8zvT8thYAyg4FjsN1QRaB+XES2N+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269707; c=relaxed/simple;
	bh=+CyT9gpQ6gSOf1El3osIB0a5pQpjr4Xl/LfB627vLoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vDwP6DATMIn5eCLkWn1WGGkOGRWLwuQ9+t182IBEMGAlEnmNbtjCoxsBqfeyuwCOvyAxrE8xqkxcaUttyRJKLKChml5HUA+60jPLrXQAe3fXY9KvCBG9F2vHUctx2JjllZZq8KS9eLlgXcZni5+38yjn5UkizPEp2xgk11fh1xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MMsy7ti+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Y76wFttc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MMsy7ti+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Y76wFttc"
X-UUID: bb861460953011f0b33aeb1e7f16c2b6-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+CyT9gpQ6gSOf1El3osIB0a5pQpjr4Xl/LfB627vLoA=;
	b=MMsy7ti+V6quBuGgVKPX+iVMbIv1u2+nDFCk2Z1MhT8BNHm4X57MbJoEDKgCyZy7i3dqAFcsX4rJj92jdbhtxgmUhevf3qITMHoasDC/3Ijq7I95wFH8uPRto9rCwcYDeiYpnb4WgUVCyWw1CxCq5tkadC04kiNx5DK+O2Lt100=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:0274919e-a82a-408a-9070-ea12353ad8a8,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:ebf0f684-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bb861460953011f0b33aeb1e7f16c2b6-20250919
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 676908535; Fri, 19 Sep 2025 16:14:58 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:14:57 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:14:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xl5zLniiigmGnduDsKeeTejJYZ74q11LeEq9/AZ+DrtsTc4OLRWKCf2W4deesK8svulgM1DNzgFIy1CXHXqx02K6omKWbUPQqyUaeevKtRAHzGczlKkYLY4+rQWmbqfU5xj1YFF8j4vNkYMnKEWKJujVe+qEZzatLmxZ1dqqKm9XBMJE6iEcom7gnEzY7KWBQJoHoi99MAHFD/PMkrDkD5QUiziRQtIh5Oa0f6JAA3TEJrpoRe5WkWLqcJQb56gH2QCGmlvntdYRyyfUKxoWTQRJ7mOLKmeiPjrMhlL0A7h0PNc/5YLhOehCRU0LCMWn/wZaskA6HMspqC1zg1A6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CyT9gpQ6gSOf1El3osIB0a5pQpjr4Xl/LfB627vLoA=;
 b=v6zONuEpYmlVRAHN7DbgaARfpCzZwL7pBWwXLZ+cGs5xbmURBNmYvSrTSTQ8Oo/6JmH5RZmpF7fQ5NUdI65+un4IvWRIBa4xOYXMi9NRWmAM8LonCDlRUmpGsvOjVDxhelag0mvIam5VYFjhF89aFPo9SHTib5rxTtnYf9H/IO4LigvhwlJMFwnRcjLBVcJ5fb14xy5SSZwBDIZOHE7d3AgX+qia5kPyxSrjyyPkwjCXzGAoWVUxe8qdwwXXHNhY4qxLRBP5TwAYqM7yU/JXJyM3mP4PTsG3D4C0a/WUAgAqdsK5tGcaS+2CkODuZkxmDA3GveWSdojl1FeLJhhEyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CyT9gpQ6gSOf1El3osIB0a5pQpjr4Xl/LfB627vLoA=;
 b=Y76wFttcVXAFIFZDrHbBuWBtvswxPEmgH966meGL4PA5RNyt5bmcmV0Ozk2RMR1NLE8q5/shc+xqT+LZYstmj9GpC2PsqXuSagsZMJy41AR2KC63qrAOYT3zY838t3S+cvYT/phpIFMmxq5XDJH/xVymBwNh5L8r1v2BFVRgqqk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7996.apcprd03.prod.outlook.com (2603:1096:400:44c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 08:14:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:14:54 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Topic: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Index: AQHcKIiyg6scP6qY1kauuFd5GClYQbSZRI8AgADlVAA=
Date: Fri, 19 Sep 2025 08:14:54 +0000
Message-ID: <beda693842394d162c95d5523eb90373fd975d3c.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-7-peter.wang@mediatek.com>
	 <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
In-Reply-To: <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7996:EE_
x-ms-office365-filtering-correlation-id: 9deb5056-aeec-4a3d-8830-08ddf7549d7f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?anpQRk1qZU5ydENmQWtsK09KUVY1RFcvU3pJWVQ2d0FwWUtkQ05UZmdEZGc4?=
 =?utf-8?B?ZlJTeFdVK0FyU0g0SllGSUFCZVFISmJSTVhxYXp4ejNzR1FsTEtXQnZyU0VM?=
 =?utf-8?B?ODRPRGhOZ0lIVFZ1MFJ0M2lxdDdYVFQ1UFl0TzlmY0J1eERTc2ZzcTJLeFpo?=
 =?utf-8?B?UDczbFUwWHMzSlN3YkVGVzNSbkdSUkNFdnNzbUNLK3BTNFNPdzQ4cG04QkpF?=
 =?utf-8?B?dXZ4NEZYYzdTU3ZLS2JjTDNWenVoZGRqS0xjbmJwUjlHMERrcGhFS1NhTGhM?=
 =?utf-8?B?Y0RBSXRqQVRkVU5MU2lBeHRpTlV6a3ZNRzlDTlpVRUg5Tnh3b21iUHR2cThm?=
 =?utf-8?B?c01PZk1qanVCWXpFV0l1WUZUUUZDbmhwaFNzd3U1Q1hUU3lmVXMycG9DMHU1?=
 =?utf-8?B?UmwrSlBTdHVyWnhwUEdEdkxlNFp0cWxtNnlrUjMyNVQwNGFOc0FIWnJ0aktk?=
 =?utf-8?B?Y2JCbEQ1clZST3lsdUZLRWNZMTlkR2hRQ3JDemF0azNWM0hlTUNBbUJkQVNv?=
 =?utf-8?B?N0JlbWRoKzZsaFlMOHpwWStGbUZBY1VqSnNUK3I2SXV6SlB1YW9PdzUzTEVj?=
 =?utf-8?B?dmRtU1QzSXlrNE9TcHczdndzZ1RiYzdRSkx0SVMxaUI1bXNrYm8wYkczNjRU?=
 =?utf-8?B?dHU1S240UzNiNklJandFdUEwWllXTEFrcFdRbVNoV2VoVlZJMFBmRkRSR0oy?=
 =?utf-8?B?RjhpRCtpYlIySkduWmJ0S20yKzhWaVJNU1ZRUlYzNlZhV1JJVkZUM2FNTUo5?=
 =?utf-8?B?R3dnS2o3QjRSN25Edk5xTnRnSC84UHFTM2kxZkZaR00yS3dSVU1YQWIxTk9P?=
 =?utf-8?B?TE1aMzVRRE5jWUZRRyszd0Q4YnlJMCtmYzF3UmI2eEgrOExndWJSZzFWdER3?=
 =?utf-8?B?QzV2elVZOU1yb0FkcUJqOEdmakZnOEZKRW4vMWdZR0YyekpQV2gvQWJ5Zkll?=
 =?utf-8?B?bmFub0NBSlJyb2Z5TWR2NmVHd0VCRlAvcjhaV2ZET1JPUFJUZEJwaXQyQW1N?=
 =?utf-8?B?elI5Y3Z0RjdVdnJhdzRpQk9xcXpzc2dYdlYrakM1T3Bvazg0N2lhYm1DSWtr?=
 =?utf-8?B?elVIMU9GNjU2Vm9vcHlnRFpWcWZ1MW94SVJ6SVRFcUJZNm5FQUZUN2VFZUkz?=
 =?utf-8?B?c2RXY2VqdHMwV3ZvRklqTi9IL2svSWg2dGR6b0xucGtwVmRrd3UwUFZOOWpJ?=
 =?utf-8?B?bFBybkFsU3gxYnlVY0ZwZnBTaGFhRFM4Ym9Wckpjd3ZGaFRHU1pLM1V4UHZn?=
 =?utf-8?B?TGs2ZEg5Sml3VzN3c2VnWnc5Vk03c2VGTGN0WHpRWi9GOFN4TG5uaHJNdWNG?=
 =?utf-8?B?UWVxR2JFY0ZxQmdzWWc5QU91azRSKzNJaE03eHVIREJmUGRtd3hsaW40WDQ0?=
 =?utf-8?B?c05HR0ttcW1oMEJKdmpVYkpHaTFGeG9JdC9pUXdoemV6VTlzVElvdkpqaTVE?=
 =?utf-8?B?RHRGZ1B2ajh4Y3M0SCt3UW9Bd1MvK0dYcEFadVUzR3hieUNYbHh6Wm1kTWxE?=
 =?utf-8?B?MTVZeDF6a0xsQ2dkUWJMaUI1NitrR2Rna3RpMldQWU82VmliYmtrQ0gvNmJp?=
 =?utf-8?B?eFVkL2ZCc1NrdGpacmFvNWkyakZrMGU4OXd5UmlFL2lHRit2dlJFbm05Y3Uy?=
 =?utf-8?B?THRsYnM5NVdLOXJuWElURUpqeHlCU1JWb3Z6Z2FvaG8xRHhYdzdtd040NHFF?=
 =?utf-8?B?SVZxZWU5VFpZTkFqUFlOZmxjdVY3Tm1tSEhkQUJ2aWd5SVdEQThKZXNDejlM?=
 =?utf-8?B?SFE1d045NURTUy9xRjFvZXl2UlY5MGR4ZWx4RW1pN2dGMDZPL25Ka2FOWUN1?=
 =?utf-8?B?UTBFc3k0VmNucWVCNW1KclB3UHVnSm5RYzFmRTFMcWxBcVQ0WmU2RGpEbzRT?=
 =?utf-8?B?aFZvZUNvcm9jWVI2U2FvdWJGSWM0dmVOTjZtdnBzeXA4UVY3SzcrOTZNYWV1?=
 =?utf-8?B?b3lGWEUveWZDNVdlS0xrdnFrdkE3S25HeDNLcWNjOVRRZGpyUkxjNVFabGNu?=
 =?utf-8?B?NGZhczNoTHdRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2hnU3JKVlo3SlozM0F1MlFieFl6b0RkNG1PWjJ2YzBGTlJoL1FZNFFTQjh3?=
 =?utf-8?B?blZUblpQQ1dvUFNpQWpIVVRwd1hSYndXM1VISUxvd0tPK0ZZb2tFd1UrY0FY?=
 =?utf-8?B?cGxVdlFnSnBqVWFuWVIyamU4Z2JhNHFSdTZXakZnTWY1cEl1enoyY1Fab3Vr?=
 =?utf-8?B?NXVVbFZBMS9KRUFhZ1pPSmRaU3hwVUF0TkZ6eG1lb1gzc3FYbmhDRGNYdFRP?=
 =?utf-8?B?SXh3OEx4dWYwVmg5Q2RjQXU4RVdaaHpxR1FWRC92NGRweXNpNkpWMCtvVEpq?=
 =?utf-8?B?dzRZcW5hY1EvcFRFU0FRN0tVQVoxLzVXRks0NmVkbmNvWVMxRTRSM2FIc0ZK?=
 =?utf-8?B?WGd6SE4yZThpRUVid295c3lEVHdWeUI2MXBCTzBpTjhNOVFDekgrQnB6cnpL?=
 =?utf-8?B?ZnhTbyszUGR0SlhxUFRsaEp2YU94bWgrZHdQTkFFQS95SXBUNnAyNzV1V0pC?=
 =?utf-8?B?MWR3VW5mbGE5WC9Hc2hzYXFERTQrYzZJRUk0Vjd4WTJPRUF0Q1hnWjZITGp2?=
 =?utf-8?B?bTlxOFFkeGpjTGhHZzl0MHA5K3o2c29QY1NCdmlRaFMzeHdiZnBieFVEU09V?=
 =?utf-8?B?bnNOOFEzR09mTllBc0MvaG9uN0NFeTR6aHVtRzFLY3Ewd1lyT0psQ1d1ZTlQ?=
 =?utf-8?B?allNZmdsUWdDMWlscFV4WnY3R2pGV3VHZlJacHpGT3NPT2ZQSzNXZkhrdFpZ?=
 =?utf-8?B?Z2NWdXU1VitLVHd0ZFVWZ1AwR1p6VW1aUzFQK3RDYVJhM2tUUFZTV3g2K3hl?=
 =?utf-8?B?anFDTTRrbkYwMDlTQnhpenpaTVYyL04xSDNGUG5NbVVZc3FXYXJ2UmtZVHZa?=
 =?utf-8?B?OUxWZnNCbkxRaTFrSFpCY1pIdGcxcDZZalF6bFhWRnh3aUNYQW9SdTRyaERR?=
 =?utf-8?B?SDh5M3o2b2lJRStsKzU2TU9TVmVNbW5DUkQ0emVlSGhuMG9DYit4eCtYa2Nh?=
 =?utf-8?B?Vlhvd001cFp6aVhjZkJSVHNxTS83VkpMd3FBU2htZ01PSnUrTG1NMkRmcEZn?=
 =?utf-8?B?Nm04OHlJa0xtYThKc1ZqNGVzTjNyUHNaZnRpanNScUNIcWlSL3IwZlc0amlC?=
 =?utf-8?B?eFRjbk5PWkNDZDc5MlRnUU9TWUZvaTVxM25rQ1Y5K3JFL05sdFRlYnl1WEpS?=
 =?utf-8?B?aUtSRFQzbVJwbU16NEZobGIvbzF6QU9SeDMyZkNVV05xWXZXNXE5UXRXZGhG?=
 =?utf-8?B?ZEZ6K1BRLzMrWEZqc3h1dXpsNUtQQW84TXNRMDRZZWNYQmwwLzZud2d4Vk5E?=
 =?utf-8?B?T0lBQWdsOFlud1VqYVR6OWw5dlFVSWZENVhnMDhvZ3VHbENKcFdzMkcyS291?=
 =?utf-8?B?aitIZ3J0MlhPbENxOTA4SnhKcnZxdE9tN25BTmZXN0FTekJYZFZMTC8yQXRh?=
 =?utf-8?B?WkVKd3A3VDY5V1lhZDdmT0hKNWxDWUVkMUZ1a1VyeFU0VFVVV05DK0h1R0c5?=
 =?utf-8?B?S1BRdDdDOU1PWnNMYTN2MkpMVmZIS0VmSE9oZlYycjZ6UWpscFMvTnpEa2JN?=
 =?utf-8?B?WHN3U1Q5MkJoTEJDR0hHNGgxNWxSc2pXOWErZlp0TDZ1WEtXTkQxaE5OeXRX?=
 =?utf-8?B?ZDdLUnE0elBPWEVTL2VncDE3MjlzRE9EQS9xWlZxZkJxTEppNjd0Y21Ecngx?=
 =?utf-8?B?RzdNZE1rTzE3c05sbU9UbFpidHZUMmcyWUtMOUMvQnBhM0wwU0hjeVpGQjZ3?=
 =?utf-8?B?bnB5cm5qT0tEenVPWW9zUDhHNW5rRXR2NSs4dDRvcU80R3MwVHF5c0M4cFVQ?=
 =?utf-8?B?K0NoVFQzNzlVelMzR0k0VmVRT2JHV01KOEZDSFN5QzBYOVYrazh2bTlHTzND?=
 =?utf-8?B?R0VFT2hTTHBMTDVzRSs1VFIrOW4vNHhyalRLNWp5MGdrMGUwaVFwclUzTU5y?=
 =?utf-8?B?NDcrYXBTMlVTL2hicUQ3TVUyQ09TWlV5bDZaRWRLcGtzd01jOThkR3Q2aWdM?=
 =?utf-8?B?MXVubWxFbDNDNzZyVTB1dU1IZHJBdGZCaUl1Y3M2NHdVTVVFQnM1bkJ0UTZu?=
 =?utf-8?B?SjEvVXdhVnpQZ2c0Mjl2d1JneFUwOGpMYmwrRVBYSXhjL2kvKzZMcWNENFBX?=
 =?utf-8?B?cUNHY3l0dEwwK25jdHR4UTRSUjRSU0xZUDlwK1JIZ2xsMjJmQk45eU9ybmZn?=
 =?utf-8?B?QjAxcUoyUWpxbFBWWVRxQ2tJN1Nib1NURlo1c1NMNnB4KzFFeHltMkwyTzJx?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D556A24D8A87B945AC4246FCDADC32EB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deb5056-aeec-4a3d-8830-08ddf7549d7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:14:54.7791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbcaE47IOEHClsiMC3eTnw3x1XfxLmmexxao+1THsJHmk2opRBdTkvOUdQuQaRdSw2G+gr9u42fubnmeUa4niA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7996

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDExOjM0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IEVuYWJsZSBpbnRlcnJ1cHRzIGluIE1DUSBtb2RlIGJlZm9yZSBtYWtpbmcgdGhlIGhvc3QN
Cj4gPiBvcGVyYXRpb25hbCBpbiB0aGUgVUZTIE1lZGlhdGVrIGRyaXZlci4gVGhpcyBlbnN1cmVz
IHByb3Blcg0KPiA+IGhhbmRsaW5nIG9mIHRhc2sgcmVxdWVzdCBjb21wbGV0aW9ucyBhbmQgZXJy
b3IgY29uZGl0aW9ucy4NCj4gDQo+IEFsbCBpbnRlcnJ1cHQgZW5hYmxlIC8gZGlzYWJsZSBjb2Rl
IHNob3VsZCBvY2N1ciBpbiB0aGUgVUZTIGNvcmUNCj4gZHJpdmVyLg0KPiBQbGVhc2UgZG8gbm90
IGFkZCBhbnkgY29kZSBpbiBob3N0IGRyaXZlcnMgdGhhdCBtYW5pcHVsYXRlcyB0aGUNCj4gaW50
ZXJydXB0IHN0YXR1cy4NCj4gDQoNCkhpIEJhcnQsDQoNCkJlY2F1c2UgdWZzaGNkX21ha2VfaGJh
X29wZXJhdGlvbmFsIG9ubHkgZW5hYmxlcyBVRlNIQ0RfRU5BQkxFX0lOVFJTLA0KdGhlcmUgYXJl
IG5vIE1DUS1yZWxhdGVkIGludGVycnVwdHMgZW5hYmxlZC4NCk1DUSBpbnRlcnJ1cHRzIGFyZSBv
bmx5IGVuYWJsZWQgaW4gdWZzaGNkX2NvbmZpZ19tY3EuDQpTbywgc2hvdWxkIHdlIGFsc28gYWRk
IHRoZXNlIE1DUSBpbnRlcnJ1cHRzIGluDQp1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWw/DQoN
Cg0KPiBBZGRpdGlvbmFsbHksIHRoZSBhYm92ZSBwYXRjaCBkZXNjcmlwdGlvbiBkb2Vzbid0IG1h
a2UgaXQgY2xlYXIgd2hhdA0KPiBtYWtlcyB0aGUgTWVkaWFUZWsgZHJpdmVyIGRpZmZlcmVudCBm
cm9tIG90aGVyIGRyaXZlcnMgYW5kIHdoeSBvbmx5DQo+IHRoZQ0KPiBNZWRpYVRlayBkcml2ZXIg
bmVlZHMgdGhpcyBjaGFuZ2UuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQoNClRoaXMg
aXMgYSBjb25maWRlbnRpYWwgZGVzaWduIGJ5IE1lZGlhVGVrLCBzbyB3ZSBhcmUgdW5hYmxlDQp0
byBzaGFyZSBmdXJ0aGVyIGRldGFpbHMuIFdlIGFwb2xvZ2l6ZSBmb3IgdGhlIGluY29udmVuaWVu
Y2UuDQoNClRoYW5rcy4NClBldGVyDQoNCg==
