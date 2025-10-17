Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499AC1D554
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 08:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689756; cv=fail; b=KYAcPYhjSf47SQ/uTQdM+lXOPRuzy13hYOZR7Wvsc02Bl0I+TL/6EgyjX0ilZhWnqqX+CTaRYlo3LuPWK0/Z9tixXE4M1TpY2nD6IbjswGA/Z15BDomsbPT7suSqSj0ytKAVjcs9WipoETiRKvvRstTMlAGVaZV2QZ7ko2aVGwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689756; c=relaxed/simple;
	bh=+RLdF20tDZ/Ho90IwcE8n4zyXCvstxjS1WROZm4F54w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bKyCxtoFSDPflK01VT1CkLO8ChKi9QKk7P4N7SfK0S3ytbSX6snBHszkePu1jResqAcZZt2EytOWGzc1wq7ElULrQ7mKJ0y6f7Rg2FlfsEyBlbXmEzZgbOEC89ZukxJML1abZ0oRZfh6EGUHrVfIQOElbgAklTQg1W+F4qnNx+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YYutEX8l; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tvzuEpgR; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YYutEX8l";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tvzuEpgR"
X-UUID: 5a30171aab3311f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+RLdF20tDZ/Ho90IwcE8n4zyXCvstxjS1WROZm4F54w=;
	b=YYutEX8lHthXPAVj/yliVw7YXQ6k6ojoEq6ZVHNgUThXGS3DlmaRu77hzNjO2B7ZDKRwXgVxhswWPYukjiaybPR/Ntf+cvKP98bCqNKVaOMWbtf9TEQ5NoziyBPrKWW+hL0bQGWykVHYrvBavL9ldN7hJGIuU5b6DzEmM+SXHrA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:7cc98484-863a-4634-9b30-9cbf7add0bb2,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:92eb7e02-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a30171aab3311f0ae1e63ff8927bad3-20251017
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1109622972; Fri, 17 Oct 2025 16:29:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 16:29:07 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 16:29:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bbfXXWwqY1JBjtEJbG8NgMzurHKumaRducljYvzexfj1edV0K4cdtR2hnds07mwVqh8vCUdpmrZIqjrXu/FV2rIZH3/1mH5S147GDuQNaUkrkMpRMPr0agNaUCVZhefw703h8jaO/K58Ga95mnQGKHuY4C67pa9dQMj53XMhpTwgTqU5C+HWNk9QGATpxfaI7Fk7vXukGB3T6P4qTOxCuDhE2KzCDyYGLk5a/aaAfVR7U7WIyrDFAHW8npj2bVi0NFcoM6W0ZtWRrLo/mrEoXlkjuijrSh3pYTHFPpB69+VyluBvGd/xpxCdNiemTqxYe5M/FyBqed0Y6lh+ynC22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RLdF20tDZ/Ho90IwcE8n4zyXCvstxjS1WROZm4F54w=;
 b=GuNMXy0dZtqPX8vkOmHFa+kSfrWjdLNCq3i00MwztN7bdzgQhJZGCVEG0UX9Kyv7oiIdMwr+xB0P6ZoPddQ02llZyKd29TYSbRXnOifXeC3AvC5zKQ/MR+Z69QkGqkYNnjPHRUqiF1b+WcoCatvul2RxlDY+uXXyPo1PWJGTQkIJt2g/GZjjuKq3bUal/tq6LY0ntEMX319MOp8vnIV1keNkS3Uak7K2dk8YJDL86oQW5lsBZJ2dCt2xEhGlw9wm9S2/1FpTJir49HZaQGSXMgaPa5C/Txb0YKFB3nmzB8+xD3i7LQKYUvYWW94bV4Wbw2anthNin4oCL6vsLevu1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RLdF20tDZ/Ho90IwcE8n4zyXCvstxjS1WROZm4F54w=;
 b=tvzuEpgRFDd1KrrwHZKFipamMWIHvtIbI1G4WQbDi23odB0o5FxfCMA5ClECzev0tAiq5ACzLmd+cmOUYI8fw5ZZOZWE+4Ei2lv/w44RS2CBFFwQz2ltKvdgSdIupkClnussRgHmPFAfkyP+fa/JV6w6NjOQpetgjzxCoa6Q6iw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6847.apcprd03.prod.outlook.com (2603:1096:400:25b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 08:29:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:29:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "quic_ziqichen@quicinc.com"
	<quic_ziqichen@quicinc.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>
Subject: Re: [PATCH 6/8] ufs: core: Move the ufshcd_enable_intr() declaration
Thread-Topic: [PATCH 6/8] ufs: core: Move the ufshcd_enable_intr() declaration
Thread-Index: AQHcPUWaH/DNPbp0Bk+X9UsFvjoNLbTGBagA
Date: Fri, 17 Oct 2025 08:29:06 +0000
Message-ID: <e2d12f00a191bfdc7e32d942baa2be6bd270c056.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-7-bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-7-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6847:EE_
x-ms-office365-filtering-correlation-id: b1a299c7-9aa3-4ef8-aba3-08de0d573d03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UDFNenpwVDFWbDFlOEdSTGdjK2FxbjhnTUFuS05OUGZ6emIxZER2NCtzTEZC?=
 =?utf-8?B?blRWRXB2NjJPbFRqYWtRUWtYSU1NZ1dqc2c1dnpZUzliRkQrUXR6VnVxcGRt?=
 =?utf-8?B?ZmQyYUl0WFRRanZseXRJR2RiTEpkKzU0Um8xaHBVOFlhSWlSeUNPbERUL2Iz?=
 =?utf-8?B?TmUrSkpjRGwrL29HVlFLZmdYTmZEcm9QTThXQ01BL0MxQzlmK2NmUHpSMkZF?=
 =?utf-8?B?eHpNVXBGa0R1VURkL05MWEtvNG1kaUo1cVpFVjEwaURUQ2c0Qnp0WHhoTWd1?=
 =?utf-8?B?RjMyR1NzTmN6ZGRBdkhRa2pyYUZ2QkN4UFgzbXk5ak5iZmwzRVhIclYzYVdh?=
 =?utf-8?B?SVZCN2dpdVVyTjRNWTRpTzhYVm5vbmVSSHQ0UnorYmhwdWUzTlQ4MFVaMy9M?=
 =?utf-8?B?S0dLSkp2K3Q5SFpzaE5obkF0Y1JqQlIycHNQYXdQekZESWZhSDl5WXVZR3VX?=
 =?utf-8?B?MGt1RGlOSEc4K1pOV1NkNGFFYytkQnk0aklVVGsyQzNhbVBuU3ZHWDM4aWR2?=
 =?utf-8?B?S2pLWnJvWlJ1UW1wV3A4ZUxmQjU3VUozQVBtdUNFNFNHMnZmME9TYkd3SlVa?=
 =?utf-8?B?RS9ldUl3Z3dYWWpHUjFSL1ZUK2Q4WTZsYng0TUlJbTh0K2o3bFZvVU45RmR0?=
 =?utf-8?B?NXNDVFNZVmRIVzU2L0NMUGJNaTFRNWRWN1EvWnArM2hJWThyVktQOE1WWWRE?=
 =?utf-8?B?dEd4Qy90NFA3d200WS9hMUNtV0dVYStFNmp3NmcrUVh2OWpIZk9Fb1ljZGU0?=
 =?utf-8?B?K0o2b1FjZDhPdjl1YUNxWkJlV0ZGRTVwNHYyeFY2L2NTaXY2SU9sY2tIVGtM?=
 =?utf-8?B?SUJCTmdnUUd4ZWNLTWxnVHY5cVJmVVJHM1BkNzdBVllVdkZuODlkMTcvOHB4?=
 =?utf-8?B?NHlneTVuVFJHOURUZDkreUt1b005R2hZbWl2VXFnRHhONzRWc0g2eFZLdWxW?=
 =?utf-8?B?Z1dJeWRxWHNLUFRodHA0WEh1Y2M0MU1wM3lhNWppY2J3ZCtxSUUrWDVrMnI5?=
 =?utf-8?B?SnZtOWgwVVRyaHg4cWlmQnc1YzVjSEFua3J0YjBVWFoxYXFpSTdCVHR4VFRU?=
 =?utf-8?B?dzFTVTdVY2kzOEFXdWF1ak1aTTBGTEdNbE5TWXRuMG80ZVhOaTBYeGJya0RU?=
 =?utf-8?B?MWJ6SEVRRWc2WnRHdHBMWFpwam1RSFdnTjAzalZaQVN0YXVsQ01aclZTVU9U?=
 =?utf-8?B?cmlva3FwY2tmeUFSRVl3RUJpUUh4bitRMFJBTVFOaEtpVDZKdFBUQW5OL0Iv?=
 =?utf-8?B?b0pFbHFWdE10RWtacGpQeE5uTDBYeXB4cCtmRFI2Wm1iTEFSL2hYNHE0bTBS?=
 =?utf-8?B?ZDJHRDV6eDN4RUsvd1N2UEF6VStRQnc4aElxTEhZZi8yOXZrc2tiUmhTYnZo?=
 =?utf-8?B?QnNwMnlicVNManZqcDVYK1ZEc2xZRnNLbFhyc3Bja0pVUGNRWUUwdnBSS3Zj?=
 =?utf-8?B?dmhxUTRPNDdXRlRnWGQzbzBBMXJaaFU3d2crbmFKakxkSVlVRitsalVYaXha?=
 =?utf-8?B?YUlUMmtQUFNkdHlDVDZVei9OM0tEck9MRkxTVG9LVXZoWmZxbldwVXdGKzM0?=
 =?utf-8?B?dE11K3FLRkNXR1pXL1VOajJkVlNKN21zZEFyZHVBNS8vbEdITFJSN2JWY3J6?=
 =?utf-8?B?a3N4Z1FZc0NyM2hsQ3VpaHpFUmRGb3VWTVdZb1BEMDY2RXh6NVpKN1lyQXJu?=
 =?utf-8?B?cmlkaGV4QWZoS01zSTN4czNjUVpSYUFQN2N1SlF2ajhkWExIbGw2ZERrMHRj?=
 =?utf-8?B?WmxLb1FGYlFNMFZSMkNpTFMyZ2V6ZWtNb0RoaWowdjBKS3JmRGZsM2V4amJK?=
 =?utf-8?B?ei9XWmRLTWRWVFE0YXpRcTJUY29lekNnMlhEZzNXaEtlcWY5ZUR5RGdodnk5?=
 =?utf-8?B?S0M0c2ZrL2x5b2lzY0VpbkZmS2ZRZEdETDQ5WU11cXJuK0ZwMHNkOFJmcDhE?=
 =?utf-8?B?amxTV3FzdHZDOWg1Vmh5WHpwaFQ4WnQ5R21sbzZocFZGWVYxN0tyRERNVFNS?=
 =?utf-8?B?WVpKbEVYSks1V1lVZ2ROcGVsYkFXMWhGUDE3MXZQbU1TUG5yRXN5UDY1TnJz?=
 =?utf-8?Q?TDzrBe?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1VsVUdvSDJlM1BXeFovL3Zud01mVWVmdXlDY2praWdBSnkwMk5SMFA0Lzlh?=
 =?utf-8?B?eDlMbWZtMUFYUmJKQ3BvT1NCekk5NW5TRWREQVVEMlNDOFRFVFpyRjZKcUYw?=
 =?utf-8?B?Ky9ybk93eVlXVnY0YUtHQ0pFbjAyUEo4YzlWZ2l0TktnNTY3RFdUNmpxSWt2?=
 =?utf-8?B?Zzd4V0VUNTlNUklhWDhmWG1DVTIrK1FJUmdoVTdVZHNhMDhYZzFkd2xZNVZN?=
 =?utf-8?B?ZndMbEFwVmZqdTFkaW45WWlFbWJpMkt4S0g2S1hSVHBoRjdUNkhQM0RBcWRR?=
 =?utf-8?B?RGJNR1FHeU1OaVIzNTJ0VWZsLzFMTW80dVFCT0xrKzNxL1REVWd0OU95V3F1?=
 =?utf-8?B?bGg1TkRWRHVyK05YbTUwbGlsNGZHb2tpMEV4QlVqVm5WTk5SeWUySXFycnMx?=
 =?utf-8?B?eFVxNVdSY3EvVVYzK0huSlNHUWFJTkl0RXhnRUZER2UzRWhETVFQZ0Y5L2JS?=
 =?utf-8?B?QWtheDkrZitIYTI0ZHFGM0FVTE5EenUyTzRGNHpMZy9OT3FCNUxyWkQ4VnNB?=
 =?utf-8?B?YjdhSkpmL1JxL1dGU0E3Q0NSZFRpMGNLd3Q2MlZ2OHYvcG84bUdaSGVYWVJi?=
 =?utf-8?B?Ym0rMG1BNnFyekVKNDd1UTFqMGpIWFg0SkIwQkFTSTQ5ODRXY0VqMmdwVWpO?=
 =?utf-8?B?WmdsZFpCRFJnaVRiWkRaK1hJZ3B0ODlrc1FNODNoRnR5VlNXUHIvREpFTktS?=
 =?utf-8?B?NVMycnRqbkF5aVdsdGFqTFJVbStaTmxZWVVLWWhMajY2eWFNQXZ2VHM5cHV3?=
 =?utf-8?B?alV6SCs1M3FsWlFUcjJYMzUxMFNESjc0L1cxczdFYTJBNkhVeStkbEZkOVYz?=
 =?utf-8?B?clFHT1drNDUvRXIyb2dXZVFVUXdkdmw5Q2Y1em94cmxScEEvcTA1MEQ1Y3Nk?=
 =?utf-8?B?RkxvOVkvcUxJZVQySU5IWGUxTExKZHB6QVowcHFlY291ZCt3d0FwNktDcHNO?=
 =?utf-8?B?TDZrc2FVZGphaFVMWEFvTy9mOGcrbWJmTEJycStqRkdqRTVmU0kyQnN0Sndv?=
 =?utf-8?B?UUp3aExzZUY1ZTNERHNJTGU3TW42MDluMXVYT0hRNXhhbERRUkxuRE1EZ0VY?=
 =?utf-8?B?QllmZkE5RzkwV0JmNEZWSUcyUGJTMkF5dzMxbkJreE5CSTVrLzArMWNQSXQ0?=
 =?utf-8?B?WGJ4V2VDVC9GUWJHU3pGSFhUNW9OcVVFNGVlWFVZN2QraXRQZytzNzRLVmZI?=
 =?utf-8?B?dmFVNUVoSzJTUHFxZjZrcktiMXZqZUZKNmRnWEk4bldyRmhvVmZaS1hlcnNm?=
 =?utf-8?B?V05la1N6aEJjRE92ZUpWKzZtNm16Q292TXJhUTVzdWd6MEFuT3FLUi9lSXR2?=
 =?utf-8?B?WE1nVHJ0b0puUG0ycFlzbzA1MWNUTDdCMVJxRWl6MWhrcHRuWjZuRlNQTjZ1?=
 =?utf-8?B?VWliaFpPS0hHK3dIYVN1NzZjWGllSVRKanJyMWcvL0NHQm40M1VoNUV2cXRy?=
 =?utf-8?B?SVdIZk8yNVV6ODdtcHRIbnZRVi9uNnBWRXdiMnQzQ2dScU9hMlgrUHVtRVhh?=
 =?utf-8?B?c2FlMVA2dGV1alFwZEtWOEF1L2tFUm80UjZjdEtvanBQYlV0OXpXVWU3ZHFO?=
 =?utf-8?B?MDVmb2xhbzJVM3E4dEs1MTR4aGc0TE8zUkpTekNWc0JDREsrZjVsb0dpZlc3?=
 =?utf-8?B?cm1LWmptOFRmZnUvWlVBWk9QQjRuTDY3WktqeGRFSWFPRCtPY1AwbUV2anhy?=
 =?utf-8?B?eVZiZzFoK0g3d1hJUU9rTUZSVENYSXFmZXZVQi9BYjBPaXJiRnM4alRGKzI1?=
 =?utf-8?B?Njl1RzZKY0pxZzlDa3VlUllnYlNCRG9XYkltSlh6S1BPRzZGTW9iK3pPcDNP?=
 =?utf-8?B?L3h1QUtCMFFXUERScm9LN3RUTHlMVDNobjRFWTBtRmdBelQ5aDNtRkhuK3B0?=
 =?utf-8?B?emtLbCtOVks3YitGMVhRS1AxU1IreFptRlVGcFVsUHdHdjk3aGpkR2NUSnJ0?=
 =?utf-8?B?SFNNWkszcDlQVk84VkdiK1RHb2VrY1ZyS21EeU9kRG5MV3U5Y2dvVWZ6dVBp?=
 =?utf-8?B?MkgrRTZIZSticC9EYkFOVVJLSEUyWEpSeUoxUWoxVlo2QjRSM1ZKREZ1dG1z?=
 =?utf-8?B?VS9tdDZWYjl6enNsQXUyWkNWK3Z5aU9aNWhHVTZ4cVpHZTJISFY0cUhrT1gv?=
 =?utf-8?B?aURkR1IwVU1WRTRvME1QejdGL3FXZjFla1g5bEpGR3N5RURBaGJ2RmRCQU9H?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18F3FC80628D0E4898B2C4EB05E38CCA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a299c7-9aa3-4ef8-aba3-08de0d573d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 08:29:07.0108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wJIDy8gkqFxPryMwwCzUHLtuGfMntyaR6Go8ExDQ8BN60zpKfflFzZ5fbxld5OJXLnETr6kEIFKJIXMX6tCs1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6847

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHVmc2hjZF9lbmFibGVfaW50cigpIGlzIG5vdCBleHBvcnRlZCBhbmQgaGVuY2Ugc2hvdWxk
IG5vdCBiZSBkZWNsYXJlZA0KPiBpbg0KPiBpbmNsdWRlL3Vmcy91ZnNoY2QuaC4NCj4gDQo+IEZp
eGVzOiAyNTM3NTc3OTc5NzMgKCJzY3NpOiB1ZnM6IGNvcmU6IENoYW5nZSBNQ1EgaW50ZXJydXB0
IGVuYWJsZQ0KPiBmbG93IikNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1l
ZGlhdGVrLmNvbT4NCg0K
