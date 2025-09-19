Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD49C304973
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269480; cv=fail; b=l5j8wzIiE5a0pUrFTCWIECXTggOiHEAupLOoRbZ5y4XVK9UV6UCOhHQGpgTOzJmI1BVNS2liptTJ4W6V2VyczRejv8ogcjQPk9FK9oEyVFU6Y4CjZVyi64v+jVRtY+516zYJly56QdL/ChzNe6vbYLQGh0fhDv5bDoG1kIOLhuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269480; c=relaxed/simple;
	bh=JxgkEU1gShM9uJxzwsvTwIXUlTnx8XzlcVBUnuOsvFU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f/EbTnWLK2hsDJsvuF3KmRFyDjU49U48g7ocaPwhGbWXIyDgioLbs5HqPXJBNeTuiSKblbiHmgbM0xsfRXbfUKUQA7PK6WCiQbOJpKR+yzz/XVmnl92kc2ck7/6RIbvoaShAJ20VVWJyRWqvQD3kIsESfxXOjn2m0S6p2ohom3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XxpAhIAt; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=A0CyTwv4; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XxpAhIAt";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="A0CyTwv4"
X-UUID: 33b3e2d8953011f0b33aeb1e7f16c2b6-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=JxgkEU1gShM9uJxzwsvTwIXUlTnx8XzlcVBUnuOsvFU=;
	b=XxpAhIAt8AY+80UzShjdIT/gofdvzU+JSplQ17GYztFuTbLnwJStHS5iGTHaX2Z0VB6FzfSElxbC9rjKgjVlRSMA1qe20W0wJcWK3wai13XJBqlbqwgpzIeAWQe/WLNNG2fEw0VlhP3thZfDJeC7WbYG0EtGZLOoE/l+KdvoDBs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:11228549-402e-4b42-995e-4b0ba2b294a1,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:beaf79f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 33b3e2d8953011f0b33aeb1e7f16c2b6-20250919
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1698875643; Fri, 19 Sep 2025 16:11:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:11:09 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:11:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C4jYbPNOv8na35PdFGAMXky8SytCbR7nh6WNH21BcoAOCh5VYOjZl+uzRfDpa02DYBrqQsdz3y7ZkdeY6byLj23009knwz5/+UF0upm85fC+vtPxl6eaoNndlELLd90WeayQ+NVgGYcgi39RGHyk2HCCXUzg/XBwv37rIomJfULPnSDZJdMWQR6kfO48+lhYCNaCMu/u0jqxOMtxQl860lvYrKpREA4lI9Ab8KvvbXm5bogJKHBoBQuWYrXjHoHa++SCjXz7K7v9HOyeK5VbdhwKKJAtMyiX1TrTLRzUSmMziDUxyvzH8SAgxvUR5tAf+aI24MXDqMyQsvkI3Lv5Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxgkEU1gShM9uJxzwsvTwIXUlTnx8XzlcVBUnuOsvFU=;
 b=WWVfi5dksC6vsGZ9BxApti/VriTUgNQQccAZkME4msmDj7XE3Fij7k8pjycJVIXkz+sECiHlYk2E6o8tB4sqeghK3deAg2KefYabkjagIaB/FQuJSIRnQeh49fhpzp7Z0i0tKXOSBw9SllFTCzrIu+d8Lei0aLsF+Y+Nl/Au90rOJ4AXr39mWsrGXBiZPEiFFcWQY/H3NkqZBftDYZchagQxukGMbEoWn/IIJuA9sJj1Wb4Y4dnFBdR1fq/I5SoisBbSA54a6ce8UUZmQFpbI+ZZyb0tpu2fSN6fV3KR+56Th11Im7G3lpYfVPuMM1GJYiOqjXNXupreoYD/ZNvA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxgkEU1gShM9uJxzwsvTwIXUlTnx8XzlcVBUnuOsvFU=;
 b=A0CyTwv4ULLvp6BM4G5M8PaFYphNKo6562UXI3mKB1sEyOZdMHZ14+GK/+O2AFDyGt+1stq/TZEaDhdtUpexBCO1xd2gUxe61hsnAAA0fLF9kLLcQU4NlcVShJzfV7anSmORDF/h0uMjwYcy4Rn+mqOZVvdcEZsJt4EBsKFqFQw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7996.apcprd03.prod.outlook.com (2603:1096:400:44c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 08:11:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:11:05 +0000
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
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Topic: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Index: AQHcKIiuaKZL4LPKzU67kdo2+Ird9LSZQs6AgADmAwA=
Date: Fri, 19 Sep 2025 08:11:05 +0000
Message-ID: <bdb6ee1402ae4c9ba8919011b1d8fcb9d984129f.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-2-peter.wang@mediatek.com>
	 <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
In-Reply-To: <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7996:EE_
x-ms-office365-filtering-correlation-id: bbf6aea4-695d-4963-5afb-08ddf75414f9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VGJXaitzNm8yWG9oYmZSMHA2bHFYK0FuUGc0OWpHU1I5eElyQ25xcWd1SWpN?=
 =?utf-8?B?Y0oxQUJiUks2RTBXWklqU1NQTnZDV1d2L2tSY01Fbng3WUlkTmtnclRNVUVm?=
 =?utf-8?B?dHF4V0dqNmEyWVRXU3l6MUV1UTVwQjVTcStXWXo2YnllZEt0eXd6eWpaLzdv?=
 =?utf-8?B?M3JUZEhna01BRTE4Tm5PeU5maUNrVnRpcllVYk5xM0lYQVkxZHk4d21jNFpB?=
 =?utf-8?B?MWdiTW1oTGJtOFI5NjEyNmljUmV1UGZKOXFrYXJ4ekdNK0E2WG15M0trNzE2?=
 =?utf-8?B?ZGFGUnVvM21zRkJGei8ydlBybHVHUkpJNUwvN0tJcmhHQmFESi9mVWVLYUtH?=
 =?utf-8?B?bmtHVldzWFZkUVFjVnhEY3dCWTBKdUNIZHV1QUFjQXd5a2dIbTNoSUJHaFRJ?=
 =?utf-8?B?cTRGUTVFM0UwQnBrblo5S0s3eHZJKzNDaGRXRjZyaUlPWCtSUE1kQm5PZERn?=
 =?utf-8?B?VDZwL0pQVGZUd054THZxOXRqLytVc2czVXdzaStwUkpHZWdGSkVjWVlZR0VF?=
 =?utf-8?B?ODhFNnNUSGZMWWRrYTZwQWpMREtldklMK2R2UmRNck1pYkJmVGNJRGQzZUhG?=
 =?utf-8?B?OTRrSkFnZ2g1VGMxRUs3Y2pBK2luYmJkMmVieEdQNEt4S212MWhmdkZHL3NY?=
 =?utf-8?B?enJIY0YxZzBnSEpYVDZaTEN3TC8zeXdncSthRU1mUTRXZHViM0s5WGg2aVpp?=
 =?utf-8?B?L01YSzlqeDZRMXlzTUhSTEcvQU9IL2N0aU00RGNYbDRpZFpGYklYZDVndnVV?=
 =?utf-8?B?UlZEVU1Vdm5LQ0QxZDRETDlHU2dVcDZZUzk1VmpzYkhCOHZ3NThJdE9PY1da?=
 =?utf-8?B?bEt5SzZRWmdGOHYzNzlER0FNVSs0bWRPdUt4NzMzbTVRdDVTZzJEUEFZY1Z3?=
 =?utf-8?B?MkhITWg5MHRCWkwzZUQzMjFFVmZWTXBPbUpFNlpXT0dOMUxjcnpSRFh5SHNx?=
 =?utf-8?B?SUVRMUsvbUloQUZ3ZlR3ZDZRZFJJN05kQWc5ZEFuNnd5Y2oxUDNLQ3dqbVpT?=
 =?utf-8?B?V2haOWFPUGJQclE1dXRTZHVnVTVOQzZzdEpaWnpYY1BsUXRESVJqeWJrbFN5?=
 =?utf-8?B?OVNXOWJxWC9kVTdpTlpYYmZqc1FHRDZEcnY5eTBsSGRCRzlQSjlKTkx4QkhI?=
 =?utf-8?B?T3Aray9pdHZKTkF0aUpWOHhIK0xHYXVCV21COEVzWkREQ1J5WVZnYnlwVlBo?=
 =?utf-8?B?Y0wrMmZESDhVSWg0RXRTcEx3NDIxaHJyUXpJV0gyTmFZcGgvQVZUTTlpVzha?=
 =?utf-8?B?NytiMWhjZ1ZLbVFxdGplSDBTdWc4M2loY2M3U2VyQlZ2RFFvSXlVMEZTeEpR?=
 =?utf-8?B?VHo5bForVGlwTGQyVXJuQXdqTnhBVEJNMkg5SDhUM1hzb21kK3J4VEowalRW?=
 =?utf-8?B?UW83RmVBS0dsemlpd1ZHb21kaGNRNEZHOUh6Z0RsN0phQXlWTmhJK1VYZUVm?=
 =?utf-8?B?VCt5REl3V25Lb1N4a2phYjdMQkhBeEw0N2k5ZDJHTUl2a1RLTjBmcmhud1pp?=
 =?utf-8?B?WS9vbzM4N3FNeVlibFRVck1TZjZLdlEzVFFESmJQSk0vOUkvT1I0eUZtV0ov?=
 =?utf-8?B?YlJDd0Y3OEM2S0twbTYyaXlqMGh2NTM3NlFsNStaS2xZUDMxQ2FmLzV0amRo?=
 =?utf-8?B?b3poazE0UzlmSUw0dlh5OTloWjk1QTBBNTQ4RUJBTytmK2U1a3o5ejA2WStV?=
 =?utf-8?B?ZlZTQ0lBb2NiQjhYS1BHdWl5WmlETTN1bXdqZndqbnlVbC96SU5WaXo4c0VY?=
 =?utf-8?B?N3c3eEl4Yk9qemltbDlvTEdVeFpmZDFtWFRBOXh4U3Ryb0hvUGZNRzJoRC9F?=
 =?utf-8?B?bXcxdmFBYlpZNk1VbzQ4dTFrWFZEV1NZSkFhYWpmNWpYR0JNcUdkcWM0ZWY3?=
 =?utf-8?B?TFdYNVJPbWl4cEdkU2tSc3pZUnlMZVFNNzdiNVF2MVJGZGl2MlN6U2FaUjhI?=
 =?utf-8?B?MFBRbWFSbmczdUJ1QmZ1cXRmalE0bDRhNEFaTURwM1lYWlJyek5IcFpZY0dM?=
 =?utf-8?Q?fjPcgPVV4BnjKs/BYalTXzOJX7SB/o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dCtkb2R5ZGRWd0ZKcGUzVFpJWnV5V3ppOFpya0JYRysyOE8rZENoU0JBT0Js?=
 =?utf-8?B?KzBMVFhjWmRYS3M3RVNENkV3TnpDQXRIdXFjLyt2dXZtd3NNSi9VT3BXR1Yz?=
 =?utf-8?B?T1VVQlVOVWozMGdhYm9MUUxIaTY4TWtjZTZpbGtwMVNxdGIvbmU4STh1dm8w?=
 =?utf-8?B?TmlBTUR1Y1Q2Qzk4bWFzZ1Vic3U1YUVyZEtNV05aYVU4cHdnZ2tsaVpLaGdH?=
 =?utf-8?B?UkI3SXlQR2sxejlzR0JXUVM2MXVEaXlkdENxbDFVazZONjl1clM5eGx2NVFV?=
 =?utf-8?B?L2Joa3I0VUw0cXN0Qll3VVR3K2o2NjJtN2pXWHlIS1BXdnpRSlBCQWtpRGQy?=
 =?utf-8?B?S1pqZnRxelhoVjRoczRPSEtVeHBYdFNiU2p3b1g2c240UUJIbjBZU2gxZSt2?=
 =?utf-8?B?M3Q1YW5tTC9aSWpKWVFzWFlhbTh4NUNuMXc5QW1LMzNocWN3aWs3WkczMFlK?=
 =?utf-8?B?dkptVEc1SjNmbFBjMC9CeDNzbWNYSHZiTWl0akZuYkVleTE3d2xvdDkxUVhZ?=
 =?utf-8?B?MkxmWmxidFR3NG1mbytWc25aT1hjUnMwMUQ3Sm1oS0FHbk9kUjBSdmlWZEw5?=
 =?utf-8?B?SE1MOGdxVkhLd2FKWktIcHRhQmpGdGpxYytjNXlNMWFzd0Rvd0FqUHA5V0Ju?=
 =?utf-8?B?amFVT1laNHY0YXVwZW0yMjdnVFI2OEp1bVhpVzMwWlZackZpbFZiREhGaEEx?=
 =?utf-8?B?MzF4VWFlV0kvTUJ1a1A3dElKSGl6dWtOUlVRYTBxK0RFR0x6dUdicnp0TlE2?=
 =?utf-8?B?Q3RLb2tCYUhFc3RXcVhIazBlbjdKR0FpVmxlbDdxbWVXRWQwRStvQnNQRFQ1?=
 =?utf-8?B?NUI2M3UzQkFNRWJ0QzJKZmgwMllyNWdaa3FBYXBoeWlNeUVidlkySVIwbXZD?=
 =?utf-8?B?WGxBbEtESG9GWHZIcVJ0NDBidWxkU0Znc0RoRWdqZU5Hc0R0MUV3b0lLMVRY?=
 =?utf-8?B?UTllRHorVmN1VWRodnplNHYybFJCc21HNm9LY1VIQnNEZjZncUQ1Nk1rUkhw?=
 =?utf-8?B?Y01EYWdEY1Z1R0tQU3pDRXR0NW55SzRmcDZrVU5KZ2ROSGlnMWNRdGRYb2JB?=
 =?utf-8?B?ZVFONmlzRmRXV0VPUENKU0JhUnpqY0tpU1pyRHpsOHBRczF3bUp6R2M3Sk5Y?=
 =?utf-8?B?SmZlU0I1YlpKOXBkT3YzMUlVb0NrMGh1Z1hLck5Ga21IcWpCcXZTNmgrVHps?=
 =?utf-8?B?L1NYTEZFYXRmNk1aQUp1THBqR2QvcmE5RFIrWFFMdVd2bG95RUZFd1dldXFJ?=
 =?utf-8?B?VldIMTNtN21pMlZSTTRCY0JxbWUvNVdjdnVSeDJVRUVmQU02THBMZDk5TGpm?=
 =?utf-8?B?dnJ5Qk1FR2hoWTR3amljTVgzdTVlVDNSR09Pb2RlS1hFcFpidkluN1B1VUtr?=
 =?utf-8?B?OEk2SnBWaXZ3VENzbDJmTXRUTzNEcXhvUFZyTW5SMGhiRlFJemJZbmRyVXNm?=
 =?utf-8?B?eTc1d2FTcTBad3o0RjNmOXZqT0g1T1E1eVZORW90b3UwakdhT0c1UUNBRjdr?=
 =?utf-8?B?K2JHN3FZb1M3TEUrT2t3WEZCazlseVBHWG0zeEZQYjMvaURkeVA2RUdpYkRB?=
 =?utf-8?B?V3dTSS9jakFpZGtLRmZja2lnVXMzU0hPalJ2NW1UdmE5M1pQZTJQY0tXRSsx?=
 =?utf-8?B?bWlqbU1rZkhwalViWGRrWmRZTVRaYVk0NDV2SEM5d0lpOWE2OExUQnQvcWpq?=
 =?utf-8?B?OWlJVmV4ZEQ1aFFuOUhLSEhVZEtkbTQzOEdNNGhwT25VNjIzWjF6SmJwemZl?=
 =?utf-8?B?MVNyQVphdEhzbmtmd1NYQy9rNjdneVloU2g5MjhyeU9qT2hadTJBWFFaNk10?=
 =?utf-8?B?M0d3L21Ya1htQ081TzlKMjNiVjBRaGNha2FTb1BuWDZvQ1JuT0ZoNHBOeURs?=
 =?utf-8?B?bzZxNnRpMUFDOEdRbmFwK0sreHk3LzJHM2JuR1pRbkdsYkF3cDhpL3dXOWZ4?=
 =?utf-8?B?MFpSQ1BtU1FRZnNXUnRrUzVDcHBNS2xMdmNEQWgxNVRXWGlTSzZ2cml5d2FB?=
 =?utf-8?B?VWZmeEZ3L1Jsak9mNFpXaWg4bzFYM1cvcFRuM2JrZ1VteG5ZbDNnS05oTGt4?=
 =?utf-8?B?cVNudHVBMitWTnhLQ3g4VUI4aEcraU5Wb3h2RGpVcHc3YVd6NEhoSWRyWlRP?=
 =?utf-8?B?V3dQWDdxbGVRVGlLVGJKdTNvcnF1SUVHODhZS3ZUTTAvd1BVU3VoS2poa0VE?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E86E95A77665DD42BC1CE44CA90BC7A3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf6aea4-695d-4963-5afb-08ddf75414f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:11:05.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: htpJydL0A/ghywhfiajxozirY1nTMj3WXPYu3U4gT2+ZWjP27cyTYSmOxLrMnivrzVxWmD/X2jiLvlUSSrwmcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7996

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDExOjI3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IEZpeCB0aGUgZGVhZGxvY2sgaXNzdWUgZHVyaW5nIHJ1bnRpbWUgc3VzcGVuZCBieSBjaGVj
a2luZw0KPiA+IHRoZSBlcnJvciBoYW5kbGVyJ3MgcHJvZ3Jlc3MuIElmIHRoZSBlcnJvciBoYW5k
bGVyIGlzIGFjdGl2ZSwNCj4gPiBicmVhayB0aGUgcnVudGltZSBzdXNwZW5kIHByb2Nlc3MgYnkg
cmV0dXJuaW5nIC1FQUdBSU4uDQo+ID4gVGhpcyBhcHByb2FjaCBwcmV2ZW50cyBwb3RlbnRpYWwg
ZGVhZGxvY2tzIHdoZW4gYWNxdWlyaW5nDQo+ID4gcnVudGltZSBQTSBhbmQgZW5oYW5jZXMgc3lz
dGVtIHN0YWJpbGl0eS4NCj4gDQo+ICJlbmhhbmNlcyBzeXN0ZW0gc3RhYmlsaXR5IiBzb3VuZHMg
bGlrZSBtYXJrZXRpbmcgbGFuZ3VhZ2UgdG8gbWUuDQo+IFBsZWFzZQ0KPiBwcm92aWRlIGEgcm9v
dC1jYXVzZSBhbmFseXNpcyBhbmQgYWxzbyBleHBsYWluIHdoeSB0aGlzIGNoYW5nZSBpcw0KPiBv
bmx5DQo+IHJlcXVpcmVkIGZvciB0aGUgTWVkaWFUZWsgZHJpdmVyIGFuZCBub3QgZm9yIGFueSBv
dGhlciBVRlMgaG9zdA0KPiBkcml2ZXJzLg0KPiANCg0KSGkgQmFydCwNCg0KQXBvbG9naWVzLCBJ
4oCZbSBub3Qgc3VyZSBob3cgdG8gZXhwcmVzcyB0aGlzIGluIGEgd2F5IHRoYXQNCmRvZXNu4oCZ
dCBzb3VuZCBsaWtlIG1hcmtldGluZyBsYW5ndWFnZS4gQnV0IHRoaXMgcGF0Y2ggaXMgDQppbmRl
ZWQgbWVhbnQgdG8gZW5oYW5jZSBzeXN0ZW0gc3RhYmlsaXR5LCBhbmQgdGhlIHJlYXNvbiANCmlz
IHF1aXRlIHRyaXZpYWwuDQoNCkFuIGVycm9yIG9jY3VycmVkIGR1cmluZyB0aGUgc3VzcGVuZCBw
cm9jZXNzLCBjYXVzaW5nIElPIHRvIGhhbmcuDQpUaGlzIGlzIGJlY2F1c2UgdGhlIGVycm9yIGhh
bmRsZXIgKGVoKSB3b3JrIGlzIHdhaXRpbmcgZm9yDQpyZXN1bWUsIHdoaWxlIHRoZSBzdXNwZW5k
IHdvcmsgaXMgd2FpdGluZyBmb3IgdGhlIGVycm9yIGhhbmRsZXIgDQp0byBmaW5pc2ggYmVmb3Jl
IHNlbmRpbmcgU1NVLg0KDQoNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMt
bWVkaWF0ZWsuYw0KPiA+IGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiA+IGlu
ZGV4IDc1OGEzOTNhOWRlMS4uYjE3OTczODY2NjhjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
dWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5jDQo+ID4gQEAgLTE3NDYsOSArMTc0NiwxNSBAQCBzdGF0aWMgaW50IHVmc19tdGtf
c3VzcGVuZChzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29wLA0K
PiA+IMKgwqDCoMKgwqAgc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOw0KPiA+IA0KPiA+IMKgwqDC
oMKgwqAgaWYgKHN0YXR1cyA9PSBQUkVfQ0hBTkdFKSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAodWZzaGNkX2lzX2F1dG9faGliZXJuOF9zdXBwb3J0ZWQoaGJhKSkNCj4gPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gdWZzX210a19h
dXRvX2hpYmVybjhfZGlzYWJsZShoYmEpOw0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIDA7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXVmc2hjZF9pc19h
dXRvX2hpYmVybjhfc3VwcG9ydGVkKGhiYSkpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBlcnIgPSB1ZnNfbXRrX2F1dG9faGliZXJuOF9kaXNhYmxlKGhiYSk7DQo+ID4gKw0KPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyogTWF5IHRyaWdnZXIgRUggd29yayB3aXRob3V0IGV4
aXRpbmcgaGliZXJuOCBlcnJvcg0KPiA+ICovDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAodWZzaGNkX2VoX2luX3Byb2dyZXNzKGhiYSkpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FQUdBSU47DQo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBlbHNlDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIGVycjsNCj4gPiDCoMKgwqDCoMKgIH0NCj4gPiANCj4gPiDCoMKgwqDC
oMKgIGlmICh1ZnNoY2RfaXNfbGlua19oaWJlcm44KGhiYSkpIHsNCj4gDQo+IEhvdyBjYW4gdWZz
X210a19zdXNwZW5kKCkgYmUgY2FsbGVkIHdoaWxlIHRoZSBlcnJvciBoYW5kbGVyIGlzIGluDQo+
IHByb2dyZXNzPyB1ZnNoY2RfZXJyX2hhbmRsZXIoKSBkaXNhYmxlcyBSUE0gYmVmb3JlIGl0IHNl
dHMgdGhlDQo+IFVGU0hDRF9FSF9JTl9QUk9HUkVTUyBmbGFnLg0KPiANCg0KVGhpcyBlcnJvciBp
cyB0cmlnZ2VyZWQgYnkgdWZzX210a19hdXRvX2hpYmVybjhfZGlzYWJsZSwNCkFzIHRoZSBjb21t
ZW50IGRlc2NyaXB0aW9uDQovKiBNYXkgdHJpZ2dlciBFSCB3b3JrIHdpdGhvdXQgZXhpdGluZyBo
aWJlcm44IGVycm9yICovDQpzbyBpdCBjb3VsZCBoYXBwZW4gZHVyaW5nIHRoZSBzdXNwZW5kIHBl
cmlvZC4NCg0KDQo+IA0KPiBUaGUgVUZTSENEX0VIX0lOX1BST0dSRVNTIGRlZmluaXRpb24gYW5k
IGFsc28gdGhlDQo+IHVmc2hjZF9zZXRfZWhfaW5fcHJvZ3Jlc3MoKSBhbmQgdWZzaGNkX2NsZWFy
X2VoX2luX3Byb2dyZXNzKCkNCj4gZGVmaW5pdGlvbnMgbXVzdCByZW1haW4gaW4gdGhlIFVGUyBj
b3JlIHByaXZhdGUgY29kZS4gUGxlYXNlIGRvIG5vdA0KPiBtb3ZlDQo+IHRoZXNlIGRlZmluaXRp
b25zIGludG8gdGhlIGluY2x1ZGUvdWZzL3Vmc2hjZC5oIGhlYWRlciBmaWxlLg0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCg0KDQpEbyB5b3UgdGhpbmsgd2Ugc2hvdWxkIGNoZWNrIHVmc2hj
ZF9laF9pbl9wcm9ncmVzcyBpbiANCl9fdWZzaGNkX3dsX3N1c3BlbmQ/IEknbSBub3Qgc3VyZSwg
YmVjYXVzZSB3ZSBkb24ndCBzZWUgdGhpcyANCmVycm9yIG9uIGFsbCBVRlMgaG9zdHMg4oCUIHRo
ZSB2ZW5kb3Igc3VzcGVuZCBvcGVyYXRpb25zIA0KKHVmc2hjZF92b3BzX3N1c3BlbmQpIGNvdWxk
IGJlIGRpZmZlcmVudC4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
