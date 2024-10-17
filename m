Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16901DFDBA
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729188473; cv=fail; b=PJ0fAlTZQMOP0h+PQyjaGl7u5TdUgrF8PtMBh4bf4NGCgpYw2WxQp0aCwsMXrfMxubenX35wNG6r05f+gwTzpy2yrGV48wO6330A5CifL+L8te4a82eRjV2v1pufyazbg668MEDYHmUCUK8TseDZXsP9HSu0wayuiNVCzL76p2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729188473; c=relaxed/simple;
	bh=EpyYbxzDi6qW2slRY57ivl5j3BjrjcyOsREML3QfJE4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uHhct8fkXLScUOJbBr8+eeFGW5LuYgji+OmmafxfBCeDo50lMjHb/BL2QLWjAQYFtzCar1suTHLfF6SYouWAVd1np07Tne7dPNSBpbX4y4A7G6frM++eWWYsa0OTSwgm+uJEl49kcjpBOh0I/wyguNu55rxRwcsr+jD18SGBhvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T7XNka6Q; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vooE7ip/; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T7XNka6Q";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vooE7ip/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729188472; x=1760724472;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EpyYbxzDi6qW2slRY57ivl5j3BjrjcyOsREML3QfJE4=;
  b=T7XNka6QEciGoyrfPiba/WK2Kx78uOe2EXCsMcSqTReSRbCHh2bPLGGK
   0TBPlJHEXLYhhz1mok3lhvU54kBwBm9Ktvi5c788A2sMOSc++MdMZ1kRB
   DoLWzwi6gB4iK81wL7VGKFMg2Vy7gfuxqxoZ/IaAx+2EjZcjB/3sbRpFq
   pNI0KBN36uUEXX5vZKuF5oLJ8dPFRXjlfcRqZzx2xR33TbTYdXl8WwSt3
   1PCBpMwWrJJ/NvkSx4GgwuWD2bIws86381VudCpCpetpRynM2Ia9VqWDO
   a0SuA8UYC9/z7XCsmeBaGZf0JhL3bJBLL9EqfSY20gpADxGv7wATbIHe6
   A==;
X-CSE-ConnectionGUID: v6t7mglHTVWpAP3NaxCP5g==
X-CSE-MsgGUID: 5tjUnKsUSfuMrZ/s2hmZsw==
X-IronPort-AV: E=Sophos;i="6.11,211,1725292800"; 
   d="scan'208";a="29316851"
Received: from mail-westcentralusazlp17012036.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.6.36])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2024 02:07:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubq0mWKdkkv5pDU1CpjzDeaADOyUF5W2Zwl5QyA6uNDIynKNXXCBrWQWyR+5kG2ThJibn2X3Lo5n1yTKEinPFfnYQASAfqRrrG2CTXJ8v7fvCKnI2GgP6tClIdH+gvSHVMiYzfaIlJaPOqG3HjW0Wsxi82KIpEiWXZIvRUxNvuXTHdZN/wg0qqTimawcOyhAD3+NRiEU+SNUng/P4cuKUPFADeam/R+OWKjl85ZGBj0sZErmh7YFMsL4tbPnOZKFe8yKSUtNhQKiC6SSNkiz02/nhKjvho6sr5TY/UUmgG6+WBrCZGbL3PXHlBeRl+RBpWB2GtiBpk4s0vKLb7GdSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpyYbxzDi6qW2slRY57ivl5j3BjrjcyOsREML3QfJE4=;
 b=JAiMl17dNgTrEnmW/sBjRYqm4HjTBh891ZY5sFZweHr5YxIq6AHizbF79SFc0wzuPq1nXUayxGdzd5vGXBCHrcN1+RN//lpgnMFD5GTBK3WDVJzgScpJYGQ30j7p/BQUimMdIZt3m4EAfEWffxvsYO6Zri6hz8OMa8NMrICn0mZg2HorK6THT2OWSMYBt+MKT6qdgcnPMV/erk+kB82A/ZGkHZcGZSKzSeEmyv9e9zpVItbtwAzzU9XYbhKQQLZobs0bFkm67WBI3BP/mJW2IeKK55FsK7d7NI6Bs6jgIpJ2F0FUBYJ9c3LAEdcgL6cxtYdk0QzHDeV2JcuXcUYWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpyYbxzDi6qW2slRY57ivl5j3BjrjcyOsREML3QfJE4=;
 b=vooE7ip/x4PM+aG0ePCD9G6lom6r9idC7S7aWqf1pWrC9vLf7ZA+ipjt2VxsLYXehazY1fMkdqkH5qG46X060R/BUr3ReUvil+zcEIzS6R/sCiZkxk/36L632tGIC1noz9b/yq3bHEvFY4k784p3hXTLc3w3ZUFy0DAt7XLH8pk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN6PR04MB9683.namprd04.prod.outlook.com (2603:10b6:208:4fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Thu, 17 Oct
 2024 18:07:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 18:07:42 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Chanwoo Lee
	<cw9316.lee@samsung.com>, Rohit Ner <rohitner@google.com>, Stanley Jhu
	<chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>
Subject: RE: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Topic: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
Thread-Index: AQHbIBBBWZ/scSktVkqDqxLsXwv7OrKKgX/wgACy3wCAAAcykA==
Date: Thu, 17 Oct 2024 18:07:42 +0000
Message-ID:
 <DM6PR04MB657523DB92B671DD8F06723EFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-7-bvanassche@acm.org>
 <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d97543f4-f394-423d-9ea0-819ddaeb7749@acm.org>
In-Reply-To: <d97543f4-f394-423d-9ea0-819ddaeb7749@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN6PR04MB9683:EE_
x-ms-office365-filtering-correlation-id: 6348a4a3-d322-4053-ef25-08dceed69838
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SHNHSFczakNSUExrcytGVmpFdDAvdFJ2ejF6akpYNU9DdDZwcUV3cWUvclNF?=
 =?utf-8?B?dXVCZm1NTmJjcEpQcStPcGY4aXpnbGpab2NIem05cm9ocGxsSERUVUJvVnBt?=
 =?utf-8?B?ZXdabmFxYkZ2bXBRTThuVlFlQjBpNFkvaGVGMzZzcVZrYVlWSzFPeFZndk1h?=
 =?utf-8?B?N293RmFRanVhVmtVaE8ya1ZlbmVzS3BmWURCdVZjdWhUTGVJMVdIRG5QeTJa?=
 =?utf-8?B?WjRQTDNPRnJ2bDMrZ2R5eksyMCtPaWhBdUh5WXRId3BVZ0FNb3MvaE9NcHB2?=
 =?utf-8?B?bGI1YUh2SmZ2amVWRi9XaG14U1pvQ2tPVnppVllTWVVFTXZ5eGtRQWh2VE1T?=
 =?utf-8?B?enFRaVNBMXZ0MDZ0WEVFYXFYcHNIWEFoVEZ3c3dLc2dPVE1WQVUzbDNPQk42?=
 =?utf-8?B?Mm12Yyt6M2twWWpZWWVWaytJSTNnek40Z0FLZFEySTZPeUlnWVh3aVVPdytG?=
 =?utf-8?B?Z0pQazFMdTZlUm9iUnA3NjUyQm1Ga0RNcXV1RFBjUVA4d1RGOUp4YW8rYklQ?=
 =?utf-8?B?Q0xjT3grNm5pQWZ1VGd0djFWc3FuMjJRV3dYTURTZ2ZWNUNKNmoxU3NNcjYw?=
 =?utf-8?B?ajlDcUs2S3lyQWt0eFp4Ri9kd3BjRjRoN3dqeUNCZ2t6cjdyWjNiMkJDUk1E?=
 =?utf-8?B?cU53T3F2TUZVek1YeWhzZko5Y3p1SWh0QzZMQzlQNGNkRGZ2cVRGQlVRU3hN?=
 =?utf-8?B?amhBTng2eG1jSkcvWnRyMVkrUDFBRWhLSUg0N215RWJ5Nk54SGdHQnZxbEcw?=
 =?utf-8?B?QnZ3a3R3N1paRVN5T2Y5NWIvcTdFaEx3dDk4T1d3NlUwSktiT3A3N016VXZV?=
 =?utf-8?B?NnkwMGV5azFtOVk3SVdCbGE2Z2FEMWdZSUFPUnhMbE14LzVUdU5EdXc4b3Fo?=
 =?utf-8?B?QzJtc0xBZCswdlRIK2tadzNiV25VeXdkSkdpTFdWQkdFVGVSTUkraGJ1SEht?=
 =?utf-8?B?UFh4K2xza1JkVEhWa0VQTGJOc3RTMS95d1lKMEhEMHpQcGdwbW95UEt5WFBV?=
 =?utf-8?B?WlhjUjYvTHJUakIyaHR0S1hkeGRrdU9iZlNMQTJZYXF6RkRIR3U2NVp6djZK?=
 =?utf-8?B?ZktSMlhwTGRtSmtvT09sRm5sQjJzQ2tlMGluak5qUC83UUFhMytid0tRMk1n?=
 =?utf-8?B?TElLTG9ZTzdpVG1YeXFXRzJJNkxwNHBYRkN5VzRBdlhVcWNpdlpGT0ZKOThG?=
 =?utf-8?B?bFNzUmlqSURFb2MxUVVXaXp4K1RBN1RuT00yYVFWU1dUNzlzVzZjeENhaDFX?=
 =?utf-8?B?RXZoQ0dYVDN5aXZmd3A3UnR0YzRBYnk1cnpBQkdZTEprUUxxdkxBeUR4ZGdU?=
 =?utf-8?B?OEUyYXI1aGdBTDI2ZXE5TEQvRXZCZ2Rod0ZibTFUaHZPNGh0S2tGZGR2RWo2?=
 =?utf-8?B?WUpnVTMvRTJmSnpkeGt1OTJna0l5c0Q1UC8rZkI3OUJMQWRkOE1tUG5seFNC?=
 =?utf-8?B?NkJnY3ZpbnFvcFhpTjVxRlJnMTFkYjZQbXBSWUdYa2lwSkxxQ0VBd3d5SUs4?=
 =?utf-8?B?UVlqOFB3eHM5Y08rbzZmb0xuejJ0RlhqekIxVHVQaDErck15RUVRL2lRUUQ3?=
 =?utf-8?B?dkt6cUMvOWtxYkhOcGgvQzJvV0p2eTFvVUNVK09rakxITnpTczd0bStId2pY?=
 =?utf-8?B?cXEwYUJsOEpiQnBHT2RKcVZEVXRrQ09oS0lvMWhMQWU5ekpoMEdhelZNOUJW?=
 =?utf-8?B?R3FnaFpBSWZDbldtc09JZVo3Z1E3b1pRcDdnT0RtNGRiWnNJNlhKSTR4RjZQ?=
 =?utf-8?B?UHRaQk1RYUVVRXB6ZWZsazE0UjhvY3NTdExCTXhLRkxqNWdRUlpBbzQwMUhY?=
 =?utf-8?Q?JI1vAXr46W8YbzRPs2xxKIZsqZ2r0CnYhC3Jg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bStiOGYrUFMrRkx4QXprSmlXckJSSkxnYnA4WGFuNEdKU1RRdHVpUHR2bXdN?=
 =?utf-8?B?NEh5eXdNU2QvQmFaZVUyTlQrUXo5ZWUza28xQ3pUUGRwM2xFd2hlQWJGZ2Vo?=
 =?utf-8?B?S3Y4MXdJbjV4RnBGNzU1TVR0YStzaUhkbUE4WXhka2kwMXJ5cFROejhCRUhu?=
 =?utf-8?B?bWxLTHZ5U0cyUkFQN3lYR3hoYWVQcFU5aXlqaWhzZlFiOFpVdWJJMDdZVlBV?=
 =?utf-8?B?MWNoZUJRcXI5MWNhdDhVQXNidytIYUl6QWtLVG9LcU0ra3k4dWsrazN4QzVV?=
 =?utf-8?B?bkRhQ1pFYm9DV29oWCtITmNFZ05kMmViVHJIUDBId2NyRmJaNXp1cFpCTEZP?=
 =?utf-8?B?akIxRG5KaFV3eDhmc3hUUDNlN044WFFNWDNTNHUwZ1FGellHK1JyZHNnNDF5?=
 =?utf-8?B?NkZ4alhzbkhDSzhWVkJUYWQycnYreWNEY0JJWnZjeEVKL09uNlV4R0UyMStC?=
 =?utf-8?B?UURiai9iOGEzdnA1N3ZsNjBpTTYybHo0S1BrcVFraWlIUUFmWSsraWJmbVRP?=
 =?utf-8?B?RWJrTXFYRXhUOWJ5UUJxOXBHSHR5U1pTeDBaNmk5UWFOb3JZRkZBQzdmN0Rp?=
 =?utf-8?B?SlA0NWtMSlRYNWJNRjA5OTNVRit3d3QwNXE2UUsrZTFVcTRiZEdMbE13ejlB?=
 =?utf-8?B?dTVyVHcwNko1c2dNWVhZUmZNUWZLdWlmR2FFTmlWNHZUOXpFb3R5ZTRDbjU4?=
 =?utf-8?B?UEs4VVR3dzNESmIvaXl3VnhSVXRMY2c1ZUFvbFppdDlCRmwrd1J5VmFHOVNE?=
 =?utf-8?B?bVZwVlBFUkN0ZHB6Rnp4OUo1TmQxNURXN3lBemRPSGY1Q21HUVRjN0xQVTR3?=
 =?utf-8?B?T3VLMFVqdlNVNzk3V0R4MEl0a29rWHBMZ2YxZU5la0VOeEhiQ3V1TDhkYm1Y?=
 =?utf-8?B?d09OcEUxVmFoazY5RDFyTlRBWGowS2MxNnl1ODc1RzV6YmJMendWeERVSTA5?=
 =?utf-8?B?VXBiTXlYNEp1cTFRUGx0dkhHM0xKaFg3UGMybmNSQzlUZnY4bFQva0hwbjJa?=
 =?utf-8?B?SWJaZHllMnNWNjNHeWMxdHU0bXNLSU5tVk8xeXFKaWh5WDNSc0ZaM0RpZ0Yy?=
 =?utf-8?B?K3FBZWs5UURQc0d6YXpURzU0QjE1SzUvSUh6N2FvcSttMnFkT3hLNUVNSEZZ?=
 =?utf-8?B?MU1oeEIwSDF1MjBwalFLenQ2bzltQWs4TElpc0ZZMndGejBROVZxQlYvcnlN?=
 =?utf-8?B?eUxzNFZJczJQUjl0VWpoVVJ0OUZGSmc4ZVF6cjVKZTAweUlhT1E5MTYyYk03?=
 =?utf-8?B?ejYwK05lZlkvdEI0NVNKeEw2NWlmaDlLcFZJVHhNR2lkZzJ6cjVpMjVkVDlo?=
 =?utf-8?B?RzFSalFld2wydHFtTWc3M0Jnc0RwRG4zWWFzRjNmcGVwWC9oaXJ2Nmoydm5X?=
 =?utf-8?B?aEtLR2w3TldOMmUzTnRYQmpGM3Y4ZHRYclBON010cjF1UGltZmtUMWE1d2RD?=
 =?utf-8?B?NWFvV01XRGl6Z3BjdWovTDEzZWtONXZFbjZaNU1TaXJ3bUxXeENiYXduQjYv?=
 =?utf-8?B?TUxtTWVHQ0FPemVoRjB6cUIydG9nS09yOFZiQjhaME11U2lwL0gxK1VScVdR?=
 =?utf-8?B?Z2IwdnYvb1N4R2dZVHhmYmhhSEJmMmFURFF4R1lqekkxMDFxVTRTQnlPL0JE?=
 =?utf-8?B?akJLOVRxOE1lbG1nK3Z5OE93MUFvUHJrVHU2L0JSTHhvOHhTb3Q5VndFNWVB?=
 =?utf-8?B?K0dlcldCTnNla0ZCNURGUVBrZmpuNlhNajN6akNtSGRIdnIvc0xyc2I5K1RD?=
 =?utf-8?B?R1FPbE9MSzRwQTd6a0ZVWS9zdEIrODU3aHBhbENZMEpVSGlFb05uRmpla1JI?=
 =?utf-8?B?ditOSmVtUUNla05wU1RZNG5xcmttV3BYWExCMXdZRGhLT0NnUWd4d2Q4Ujlx?=
 =?utf-8?B?MGZ4d1VESVloN3NkbzNnWDlVN2hBT3MvYVZFZDg0Ylk2eWoxWTU1ZVJTVk1J?=
 =?utf-8?B?RTFncFlKQmRBYWJ2bVR1SDNoeDFmZ3Y1UTdTVXR2VERyM2s3NXZBa3AwWTRF?=
 =?utf-8?B?MXoySm01NmoxcXcwcGc2RHFRNjZaS1ZJWlI3MjNpUVFrYXA3RzNuNHZwUzFp?=
 =?utf-8?B?RllmOWhiU3ZGSEhHaTE0ZHRxMlpSaVhQOEJmVG1ZYXFBQURRbUFJSllid3VS?=
 =?utf-8?Q?yrkKaXx5AQeWXhqfUcoQO08lf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QVp+fZ/hktjtlcXtXIH3Ss5qiO5NEbEt/BkNevlhXgG426VoE28yW2TR/5EHZM735rik4V5Wbn5YCDgE70zNaniSWPYQswOIQ9UxBdde7USFWsAu33YotkvFLe/A9/MJdmSMGOrFOxjjo/cQAhYWSwAbSXLUY/8LSQZot6wzqeoY9YQ2QIJnVRfkL/8g+JQnTIh4uc0g8M1e+3LGVMEWFv8cf7N+bQ2cPKHcMp6uZicaO5bSznHwTUnEGsvQlvyUHdva2M+N9jIDcKiqBrbh4bZxfR0pyOXyMRGRAl5wkVY8hZ7Z+BEtQW2EqHyOMmyjkQ53wMak3C/qQ0p05jxbQoq7A9vvroDflXc5K4IDIcwGrQ7G8KvV+AGMIcz9Qa3sLMelrPDWcMLCu6PWzy2GaavViWFkRsmhalD2iyBQiI7f9efNZ9SoCW0iPqGuwy3NFRiNOnB8kW1kgvjLeZGgwGZNjhHym4zmN/PLxru9wovfrHOKHKZ4j4MUTObi8wV1XUypPpgdcJw5IpUSCexE1sQ0pi58IZBNH2LZGlbvjTllK1ZzHR+qb7FiZ41ftvf7haULsvzbQgr4JbrWGIoPn5SqAipG3YSAItgVHB11Ev8XPl5L7L7Fxsa0S9VnyfTr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6348a4a3-d322-4053-ef25-08dceed69838
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 18:07:42.3602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bVIxZdY8twX05peuFueHX+EvGUmWQS1jgcIPj5Ztyy8a9mI2mnLbpgiWflkTtdDcU6Esll7Wrd01QJ0F2msHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9683

PiBPbiAxMC8xNi8yNCAxMTo1NSBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4NCj4gPj4gLSAg
ICAgICAvKiBQb2xsIFNRUlRTeS5DVVMgPSAxLiBSZXR1cm4gcmVzdWx0IGZyb20gU1FSVFN5LlJU
QyAqLw0KPiA+PiAtICAgICAgIHJlZyA9IG9wcl9zcWRfYmFzZSArIFJFR19TUVJUUzsNCj4gPj4g
LSAgICAgICBlcnIgPSByZWFkX3BvbGxfdGltZW91dChyZWFkbCwgdmFsLCB2YWwgJiBTUV9DVVMs
IDIwLA0KPiA+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1DUV9QT0xMX1VTLCBm
YWxzZSwgcmVnKTsNCj4gPj4gKyAgICAgICAvKiBXYWl0IHVudGlsIFNRUlRTeS5DVVMgPSAxLiAq
Lw0KPiA+PiArICAgICAgIGVyciA9IHJlYWRfcG9sbF90aW1lb3V0KHJlYWRsLCB2YWwsIHZhbCAm
IFNRX0NVUywgMjAsIE1DUV9QT0xMX1VTLA0KPiA+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGZhbHNlLCBvcHJfc3FkX2Jhc2UgKyBSRUdfU1FSVFMpOw0KPiA+PiAgICAgICAgICBp
ZiAoZXJyKQ0KPiA+IENhbiByZW1vdmUgdGhlIGlmIChlcnIpDQo+ID4NCj4gPj4gLSAgICAgICAg
ICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogZmFpbGVkLiBod3E9JWQsIHRhZz0lZCBlcnI9
JWxkXG4iLA0KPiA+PiAtICAgICAgICAgICAgICAgICAgICAgICBfX2Z1bmNfXywgaWQsIHRhc2tf
dGFnLA0KPiA+PiAtICAgICAgICAgICAgICAgICAgICAgICBGSUVMRF9HRVQoU1FfSUNVX0VSUl9D
T0RFX01BU0ssIHJlYWRsKHJlZykpKTsNCj4gPj4gKyAgICAgICAgICAgICAgIGRldl9lcnIoaGJh
LT5kZXYsICIlczogZmFpbGVkLiBod3E9JWQsIHRhZz0lZCBlcnI9JWRcbiIsDQo+ID4+ICsgICAg
ICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCBpZCwgdGFza190YWcsIGVycik7DQo+ID4gQW5k
IHJlcG9ydCBSVEMgb24gc3VjY2VzcyBvciBlcnIgb3RoZXJ3aXNlOg0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIF9fZnVuY19fLCBpZCwgdGFza190YWcsIGVyciA/IDoNCj4gPiArIEZJRUxE
X0dFVChTUV9JQ1VfRVJSX0NPREVfTUFTSywgcmVhZGwob3ByX3NxZF9iYXNlICsNCj4gUkVHX1NR
UlRTKSk7DQo+IA0KPiBIaSBBdnJpLA0KPiANCj4gIEZyb20gdGhlIFVGU0NISSBzdGFuZGFyZCBh
Ym91dCBSVEM6DQo+IA0KPiAwIDogU3VjY2Vzcw0KPiAxIDogRmFpbCDigJMgVGFzayBOb3QgZm91
bmQNCj4gMiA6IEZhaWwg4oCTIFNRIG5vdCBzdG9wcGVkDQo+IDMgOiBGYWlsIOKAkyBTUSBpcyBk
aXNhYmxlZA0KPiBPdGhlcnMgOiBSZXNlcnZlZA0KPiANCj4gRG8geW91IGFncmVlIHdpdGggY2hh
bmdpbmcgdWZzaGNkX21jcV9zcV9jbGVhbnVwKCkgc3VjaCB0aGF0IGl0IGZhaWxzIGlmIFJUQw0K
PiBpcyBub3QgemVybz8NCkkgd2FzIGp1c3QgcG9pbnRpbmcgb3V0IHRoYXQgYWZ0ZXIgeW91ciBj
aGFuZ2UsIHRoZSBleHRyYSBpbmZvIG9mIFJUQyB3aWxsIG5vIGxvbmdlciBiZSBhdmFpbGFibGUs
DQpBbmQgcHJvcG9zZWQgYSB3YXkgaW4gd2hpY2ggd2UgY2FuIHN0aWxsIHJldGFpbiBpdC4NCg0K
VGhhbmtzLA0KQXZyaQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
