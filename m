Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4F41F4C8E
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 13:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761656759; cv=fail; b=ScRrolTZGeoo0q1noP9tL442qsUbyXQOrTi+Pwjy00gZoZTq/zjKdG7g5mCmUhbpBzhAXPb1hgIY8lEZ6k+Acu6uHgVztsfXxP3eRzVzLPUFAvb/T4A5k9dJ8zLODrW9Z/hWXxjIutSSM1mVQqIh6pZEIi7BQqk0v4pcbwfyub8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761656759; c=relaxed/simple;
	bh=IPBNManFP2MrK/JyKoJEtRfMFz6odsr79ofF70Z1p9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rdF07T81VxuCA2cJIQDY9TsLTiYijRvXdS3cleLDRrAz5u5KKSPTbsrOSYioHBzxRZOVr5a+P+uzOVHI4o3K2uL2InQT4gEGQvxOUYSTOF/lGOXOpYhSC8TWS0r1JsmDEWFSEH2lG2dXmNxzbB+1T0DsdHdcNoLP1U0ptuKMjJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MchFXMlR; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=qbiWbT+/; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MchFXMlR";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="qbiWbT+/"
X-UUID: d3a0d944b3fe11f0b33aeb1e7f16c2b6-20251028
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=IPBNManFP2MrK/JyKoJEtRfMFz6odsr79ofF70Z1p9M=;
	b=MchFXMlRS7dSJqNSXagIyKkc1U972O9JcRDlJCQ+C8e5a+8Wc+OGw1NS3QfPDm9Hx55DYpO110QxQztEHhQRepy5RtlgsOkPIczawBk5R5aAlvLqWIS2X4ABsK1WS43lrEJlE91E2rnh3jP4lFzB5/Prq9y0i3isX6SCEqrWCfo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f7724a7c-d527-4212-9fe7-1cc64112ce31,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:63776584-4124-4606-b51d-d5c9eec0e7b9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d3a0d944b3fe11f0b33aeb1e7f16c2b6-20251028
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 554394620; Tue, 28 Oct 2025 21:05:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 28 Oct 2025 21:05:48 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 28 Oct 2025 21:05:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCOWzWmAkebjPIf+DSfTG5YbhU45KlvNTh2Sc8Kh8U37yU1aCOaa3PPu6PwWJ0/JLrxGz4hQb3upvBR1Y6h1MY8YpRoeAw7a8lLfi6onuxvko5US0MdTVpVyWUfxvKR8sZXvUXPkY8HWYnBltJ0kGgG902OlyAQxCF8d0qjCAQJIzHJiCe8hgIUg4qQnx01iCXniUe1yfPaTD5gW0hjF6oLJSfvMZOGl0at/a0CcWnQzXg7coe6p2E5sUeD59PCmQEABODEzWBKElb5N1XGP6KPPU1hq8+hO6+p462MEM+CRdpAdcKW4YsfiXWGSYI951o4gH9bplzTRkcgf9ry/HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPBNManFP2MrK/JyKoJEtRfMFz6odsr79ofF70Z1p9M=;
 b=ObMtKtUayINvrldRYGGuyNhqjEn4gvG/9zKN7v9m7ZJ4y9gGKkPJr+rJFfk83WKbSFTvrEMEP1CJyLsUAuM/8Wog07o6ZK/7jmPSMWNKnJcYkeFJnJYx7Dn9jNwziZHwFebVunM5xubwE2O6Hx9ivbWxR3+mZgtk82ZkKFy86uxKTLIiGtak+PlmsYHwK/I6dgzzAjpz2n1DLGSS5IdFijV5Qpv3NrEDy6fpzYshsl5EwdD2dEFprxG9f6BvKPVT/diRtSbbMTW4BaTczMNeGUPqKONNzKpBpzZMuU6hrbU7BRfEQ/aPN9a8NzV9AhLPXCpG1CZmnLOs4uyiOge7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPBNManFP2MrK/JyKoJEtRfMFz6odsr79ofF70Z1p9M=;
 b=qbiWbT+/VeyMQSDUS9OKuuEqY4YCHPr90k8gFUZbT2YPWHX5heMJmHkGzbIwn7+en5cdgFPscQ1XpyJplSU9sqwcdXYMK3jT++by1PdJlN7ak+rPn4tPsKSh+tlIsWofZUU22D0RIRvVhFdnpbpQmkdmStkHDSN42da79MUX5Ss=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU2PPF7353C556D.apcprd03.prod.outlook.com (2603:1096:d18::417) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 13:05:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 13:05:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "ping.gao@samsung.com"
	<ping.gao@samsung.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Topic: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Index: AQHcR1i8Z6TpPPMGpUqmiLsOvKkoHbTXiHOA
Date: Tue, 28 Oct 2025 13:05:46 +0000
Message-ID: <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
References: <20251027154437.2394817-1-bvanassche@acm.org>
In-Reply-To: <20251027154437.2394817-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU2PPF7353C556D:EE_
x-ms-office365-filtering-correlation-id: 69d35b00-3bf6-4cf5-fda5-08de1622b58d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aXdvbFJHYi9oa0p4bWZ0R3BjdDJYa0JWWlJFSW41eDEyK01xam5KS2hZNnhx?=
 =?utf-8?B?U1RrNUJUSW1NSGFBYkZaM0N5WGJsb3RNTnNodHNGNlR1OEhNUTZFYmNJeFhs?=
 =?utf-8?B?Q1drNHNjZVUrc1FFMlJJQjRoWFl6SzJBbjlyQi9HekUwVjRIR0ZUS3lCYnRN?=
 =?utf-8?B?alRqWTM3S2dpRUJ0alhjS2k3Q3gwTzFsSzRsOXllYzREeXhGUi91VkwvY2ZZ?=
 =?utf-8?B?VWc3OW5qRGFpYmcrckZ6Z0lrRXVuK0JxQzlka2dObThpTTNsL1RiWWNTQitq?=
 =?utf-8?B?ekhYSEpEc081VjRaZWU4ZjVMQ0hMUVEzYkhNUjlRazNWYmZUZ2w0cFRJSGZR?=
 =?utf-8?B?WC9lMDV2Nm1QL2JoZE44cHpIRW5GdzJPeXR2L3hzWUdwNUwyTDBleld6TG1O?=
 =?utf-8?B?QUxiK0t6ZDY0MHpyOENSaDlqQ2xoYzN5dkNiVEw2dmszdEYwM0oxRVhSMUJQ?=
 =?utf-8?B?VHlmVHRkL3FuZU9xMzFEM2c2bm9FS1lZaTdiWVJUVkZZSk5xNTJBbEkzNDMr?=
 =?utf-8?B?TXZYQndYS2xLSDh4ZmFTbmhVMDg3MFpHQU96cTBMUCtkQVRmOUVkeS9GQ29J?=
 =?utf-8?B?VVhJeDBrb1UrWk1OUGtmaXBSZ0diQjl0UnFxNGxiZm56WTJBc0tVNEFCNDNR?=
 =?utf-8?B?ZExpdDdUbXhXRys2TnZlRXREUEd4d043QUZ4ZGNOUVlobWhRTHAvQm5mMVl1?=
 =?utf-8?B?M08wVXMvRVlINFdXYWx3ZTlMR2hhT0NXNldKbDJsL05xZnpjYnNWSTBDOUZQ?=
 =?utf-8?B?YWVjVm50Zm94Q2IvMzJ1Mjg1bGdxMENXVVkvd3NzbDNKTzVTdjFVL3dLQzBp?=
 =?utf-8?B?OEVQVk5RZ0FSWmt2MkcwMHo0dUhhS2dqak5pdjJVaWJ1Q1BNcFZNTU5jMlZt?=
 =?utf-8?B?N2xIcUhTenYvWHFFMTZicmowbGI5alFCN0t0ZkJYQm1CYVpQYmVDT2VxUkt1?=
 =?utf-8?B?ZGNEMEh2ODZHRXdXWGxMU1o0RGV0WWdJNkxaa1F0ZzU2eEJtdE82TlgvcVdS?=
 =?utf-8?B?cWJEMTVrTWFnaE1uSzFPRUdaWHg4RzBYZGZTWHJ5K2dRYVZLSVgwNjB6SndQ?=
 =?utf-8?B?bHNURFFUdElZQ2NjMm83dmtpRHlUTUxiWndOaWRKMHZXYmJjRGVDY3RKd3p5?=
 =?utf-8?B?ZWl0RERPWk8xZ1drRUdPVWlGZExKeEFhZlFPQ3NTV2xTMVIxbTF6SDArSEZG?=
 =?utf-8?B?WlVYTFlFRzlMQ1IrVW85WlMvSDR6cDY1ZUgzQ1VIQTVBd2xqY2wvTUozZjVt?=
 =?utf-8?B?T1dhYmo2M2hyenZvdnVjdTh1Z2c2YjJpUFRUejBWYTAxdElFYy9LNnVNcjBC?=
 =?utf-8?B?bk1IOWFzNTFiaThtWUlsT0xLdkhUb053eEJHRWRFejE3NStEODZydml0aktT?=
 =?utf-8?B?K2puL3VYaVNOM2J6Tk5BZmdVdkdJKzMxdnB6cVh3anp0NXozQURkeWIrMEs3?=
 =?utf-8?B?N2plRy9jNklxanZEMllBM2FtTk9NZU03L1hjZk1tbEdCNEp3K2FNU3RQNkxt?=
 =?utf-8?B?RUZMUFhtZUZCQVU3dzFpbjBGR05mMnNvSlBubmg5Ny8wQU9QMkRKbmg3RHlU?=
 =?utf-8?B?dkZaODFOTDRDWU9kRnJzTElSVHhNd1BtRjlURTNZYm9SenJZMjdiaU83eDBI?=
 =?utf-8?B?YWNDSkhIRXYvUDljanY1N2RaUWNwNXdiNk5nS2FmVXc2dXlIai8zOHV1L0FR?=
 =?utf-8?B?c3ovZkE4QlRPRjRkOTNsbEJCcVp5K3lqZndCQ2NZaFk0VnFrRVZHaWpHeXVi?=
 =?utf-8?B?SHZ3T2NxQjhlK2RLdFNkbWJpWThYZzJBb0lRcnp6MU9NSXg4cHBtQUE4dlRR?=
 =?utf-8?B?YUZjaDVFS0J1aDVLeXdjVXNUSkFNeW11Z012WGpyZ3Jud3ArU1NsTUZEWDI3?=
 =?utf-8?B?ZlptdWh1Q2ZUNENUWmNXbG1DMkZVSGpzUHlZRU1GaTJxZ1lRaWZ1Zy93d3ll?=
 =?utf-8?B?dTlhMzVzRjFFUUdVTHZPSUw5bTlxMjBBRFJZNVMyNUNNcXpudGRzbmJyTnhT?=
 =?utf-8?B?SFkvK3lSZDVnWW9oRzlWc0JPRS9KbkEwcFU4ejk4RllTYTlpbDVxY0t1QUZj?=
 =?utf-8?Q?8n6XN5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkRhOXNHV29OU3NMMUgvZ0UyQWZCbCt2RXBSaTEzcGtkWjVsVXJiMVhUdmxv?=
 =?utf-8?B?T1RkcmlDRFRUZGZaRGhmditVMXBOZ0tvWEIzdm9waVZYZXR3cDhTN1ZWYmg3?=
 =?utf-8?B?aVdwVWQ4ZVRHR1k0My82ZjkvZGZueXROa3pFNjcvb1VLUFpqdVhLQmFLbXdD?=
 =?utf-8?B?aXF5Qm55OVIrV09saUFxbDFSN29iZkZNZ0Y1dTZ0elV4bFdqMnU3UTVoendJ?=
 =?utf-8?B?a1l3cHZQUDFOM0tQeHlRbE5kV25lbzVqQ1Q2UEFhOUVuSjFHU2FnZWU0YjRx?=
 =?utf-8?B?T0lCa1EzelZOUVlkMEVXVFFUWDBzK3R0Q095cloyZ1ZEeDB5cTlWTFZEMFp6?=
 =?utf-8?B?SE1hSlg1VmIwbGlQb3R0YVdUajYrelF3NGxDalJYWHMwaXE4YVQyTU1ITGpp?=
 =?utf-8?B?YXdOanVFZXY3OEI2Vm5OMlNRMEdDMlFDZjczQW5hTDBPSVdEVzhoVWZVSTMw?=
 =?utf-8?B?QU9TNXNRRGd0NVZXL2pIb2o4cW56TUdLYVJTRGF2dmF4YzNJdVFvc3hOZSs1?=
 =?utf-8?B?R2I3enRWYjZ5RVp0cjFUWW5xVXlqODdzTGlUdDIrbGlHWndleTZCb0hJWkdt?=
 =?utf-8?B?SFlCT3ZtT1YrenZwMzl5cEdrNThubEtMMGZJNmhsNEF4cUdKOVFxbG1mbnZr?=
 =?utf-8?B?Z0h5bUdHVnkyZk8wZTR2S2JRNDd1aXRPUE9FODFyRzBNQW1MNmZnMWFUSm8v?=
 =?utf-8?B?RFVoRENFbG5oWUdHN1JhUTlCN1A4cldsR0xDcENRMDQ4ZTFOd2RoNGpmTFZV?=
 =?utf-8?B?VWJnNCtqam9yTTJETWdOR0pPRzl6UG9LUGE2cXJZWDBwNkFQY0VSaDA0aHJH?=
 =?utf-8?B?L0lKV2xEeFkyWkFVVHA2VklnRFpVckxBTFlweXUzMU5zMU80M1hSWnpsL0VL?=
 =?utf-8?B?K1JoRXpwalErUnpvUG9QTU5uWWNOWTc3eDBzbGRNZVczY3N2V0lFU3Z2K2g5?=
 =?utf-8?B?b1hNb3lqZ1hFU3NTQlg5VkxURThUUUNQS09RNitJajlsWHFjZkU3eEdRakY0?=
 =?utf-8?B?cWlvK2NBdnB0NVJyRG94NWFHV1FlOXhnalJua0RxNUt2QTAwTktnOHgyYkxL?=
 =?utf-8?B?RmhtUjBxdlZCU1NvWlpQNFZwMVpOMUIxaGt2Q0RuNTM3RittWDFhQTFzei94?=
 =?utf-8?B?aFg5aFhWWEpXY3ZhUUlNbDNkcXp5dHdsRWtaMEdCNktjM2xENmpPK0tSWlFG?=
 =?utf-8?B?YU9ReFRqNm5YZkhhZCsrcURBY3VQKytsZkU5dGVsL0J5TDhOZlNXcDdBVk9a?=
 =?utf-8?B?REJnZ1VYMGVsSnRrTFNBNjBVZFdNemZOZkhland6YXpsczZzRnRRNWllZG0z?=
 =?utf-8?B?bWFCaGJrZTY5Y0M5akxGQ05uQXF6TVNOZ3Y0VUlmVUxmQUtHdXVpOENnYXl2?=
 =?utf-8?B?UWtyMmNHZzhGYW9WQVFkaTNrL2duWFlpNXdBY1JtUFNUejNWY1BsR09pT0li?=
 =?utf-8?B?empwcmRnL0J0WGFBcjlacnNqS1ZRNTIxNjI3WmJaZVEzOUZ4ckpmN2dxekhI?=
 =?utf-8?B?RXJUYU9YQ3V3bTdsdXZFbHBndTFuMCtLOC92TklLbytVamZBUi9IQlk5NW5w?=
 =?utf-8?B?bXhCU3dNQ0tzMFNSM2wvV1JPR293WWZmM1JDTFVuL3JMK3Arb2wzUlkwQ2pn?=
 =?utf-8?B?cnNsNUZiWTBTelA4NTI3S1N6THMyaVdoTmQ2R0RIM2dWa2RjbklwWG5oL2FN?=
 =?utf-8?B?Z0JYcG5vVmpwcStJYzRYSnRRMnVVV1Z3eVJYbVJiVTNadWhQQSsvcGtUSFJC?=
 =?utf-8?B?L0VFTzBZak9aRHZOblE1ODFNc09DZDM3V2d6eVhQVVhzakhySDIyMWN4QkFG?=
 =?utf-8?B?M0xDanE3Y3h5ZDlzRzhrdTNqeFJEZzBjbnNVMTdBQW1obzcxVnJSQUhMZTVD?=
 =?utf-8?B?TDN5QkcwWkZWN0NJMDJGczhkMzl2UldyMStvRUFIdUdvK0MwekphWDYrajdX?=
 =?utf-8?B?QURubXI1OWZSaDZnZVlUbmtCNkVrdlZWalV5bDZJVGRGWE12cEtxVnduTGNP?=
 =?utf-8?B?Y1pBTFhLZVI5WktXOVRmSmorT1dxRFdHbFR0enJYb1FPNmZ5NFRhMTF1UVdn?=
 =?utf-8?B?ZTUvUlVGTkQzSUlDclpkckRPRDdtZUdWRjd2TFNma1R2eWUxc0ZUcFhzUTll?=
 =?utf-8?B?MzFzbncvSkRLdzgwMjRCTFYxaUtxME1wanNVdUg3RVBTd2kxazIxUVZzL0tu?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE9ADBB7C5DF7948BC32839B2C4D8925@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d35b00-3bf6-4cf5-fda5-08de1622b58d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 13:05:46.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0cjLoSkNhcpYzMH4lCrMMS6qa4nwacCWXaCqkRRCGsaRyEmGOZN9v2sc6tZk09YhVjwMCT3/7Mnzia8SdHCOoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPF7353C556D

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDA4OjQ0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHVmc2hjZF9tY3Ffc3FfY2xlYW51cCgpIG11c3QgcmV0dXJuIDAgaWYgdGhlIGNvbW1hbmQg
d2l0aCB0YWcNCj4gJ3Rhc2tfdGFnJw0KPiBpcyBubyBsb25nZXIgaW4gYSBzdWJtaXNzaW9uIHF1
ZXVlLiBDaGVjayB3aGV0aGVyIG9yIG5vdCBhIGNvbW1hbmQgaXMNCj4gc3RpbGwgcGVuZGluZyBi
eSBjYWxsaW5nIHVmc2hjZF9tY3Ffc3FlX3NlYXJjaCgpLg0KDQpIaSBCYXJ0LA0KDQpXaGF0IGlm
IHRoZSB0YWcgaXMgbm90IGluIHRoZSBzdWJtaXNzaW9uIHF1ZXVlLCBidXQgdGhlIA0KY29tcGxl
dGlvbiBxdWV1ZSBpcyBzdGlsbCB3YWl0aW5nIGZvciB0aGUgdGFnJ3MgcmVzcG9uc2U/IA0KSWYg
d2UgcmV0dXJuIDAsIGl0IG1heSBjYXVzZSB1ZnNoY2RfYWJvcnQgdG8gdGhpbmsgaXQgDQpzdWNj
ZWVkZWQsIGV2ZW4gdGhvdWdoIHRoZSB0YWcgaXMgc3RpbGwgaW4gYW4gZXJyb3Igc3RhdGU/DQoN
ClRoYW5rcy4NClBldGVyDQo=
