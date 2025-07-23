Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92E1C84D0
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263173; cv=fail; b=NdQgvYqqUchllXLsXzDFPp5qAlonKqD8q70Z6EklSjjJPBGUhdNNxVx54jmODiFx47DLfefb34s3YhUzWuX9LjDpwMAK7d5tC6Tj/+jPN/fcHx8GWeQRsoZokioqP1g78toL5ggl/TXwPkCvKkO7Wzo4qO2ORSTzsieZShwU+eE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263173; c=relaxed/simple;
	bh=1z1GbbtoinBeAAtgC428ysu7fLTpGgIUJJRFW26Ezv4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hL0gTLWX2ZSgORCFA4w6WkPAzXMa6XNkiFdWJLf3Be4OEsgC3Nl4fCwk0+dV8dr5LdZC4Qsi35in4FPlcrW9ypecXThUN4JGvfrNfT4Bc2h/IblR90r88niqaX9I9mzc0klzltVnfgG76oM0F/nbM/a+AHTxLFc43FX69mpl2xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F7tKAOe/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Kq0G4XK4; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F7tKAOe/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Kq0G4XK4"
X-UUID: fdb4125867a711f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=1z1GbbtoinBeAAtgC428ysu7fLTpGgIUJJRFW26Ezv4=;
	b=F7tKAOe/ylnAYBQZxTsGYAd+vOEJVvgvUQndpz+0aRWF7crKtCC2y2eTE8uxI4dATjRO3MqJSO7F2JuoRtpl6ZBdO1+kWhtlxbg6uZb1TWkgz9PSsPJrl07pVRfsiM4H+aEvFq3yYViHCuewS1Bi9Toyd1ILbwDd35hdzNOOKBA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:e324d996-d0bc-4cac-95da-d016ed5e6b43,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:248c2f9a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fdb4125867a711f08b7dc59d57013e23-20250723
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 128774452; Wed, 23 Jul 2025 17:32:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:32:34 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:32:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GU5/rOWXAyZQbA+och1a3tHHXriGiotFCbyZvy0rr2j8UoFu1akQEfghGPvdKep4DFUAs4kjezAXl0Pv90GVnghY66KmK/BovcsdDF5IouQO7YdXn87W+g2Cx/dpDFWg7aqHC0/nlR3CV824SWYXGydP4GyNkpRwIAccdWbVPblHgXw1fn9KUlwh03qFNJsvtDhrxG3t23M9YQRmo8ggVihsACC1rpwQlA8fiyHV6wIXDfeetoMbr5RIIadIUZ5dacuoeV4SgGKitVPB55MHbZwvRBE1d32qGNr0cq0wUuYCOw4G+gi8GXw8FHwD4vcncnQiUWm7hNj+mi4j4+viXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z1GbbtoinBeAAtgC428ysu7fLTpGgIUJJRFW26Ezv4=;
 b=Rayx9vfi/5iX8inWUWezzDFuXVYy2c/BSuyxRNEEXEd9BNef8mG6fCdbtB9/HYshS/oEmuVA4Vf0NW7ogJJnvAR7U7phu/oYdlTFIiVBXLyrCMz3siCoRRBb9GgCk1q51lHr/hxHiUlyVzBoZrAIFnjZkTcXiM036BEf1k1C4xDOo4jqFje+wU8OGN5mYwXTarYiwiirF62q9HAvLEN09Q58aVjf4FxNs00fpw310PqTo3OciU1Thb0oMglmNBQ+s4pbJSPuvbUt+RC4slV7xpCJopWqm9KvLWmCNxFwi3j34R3QQ/kwK+u7ZTU+l4TfJq/hnLoAtTKCqkbmMqnLEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1z1GbbtoinBeAAtgC428ysu7fLTpGgIUJJRFW26Ezv4=;
 b=Kq0G4XK40Y08ZPP592pH3A9xi6K2b/ZzTEVTkAKl4ufagDmIhKzmQJkikNvxowj8S2dK1ghjLW6BKfyaN0u6rP28GoHnac6LT3XRop74KlwqoDPPYZpJJlpN6CcFKigj6gl1tgk77DFWz1uI/BfR+/btfnjb/2vuenTgziDRo5M=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7562.apcprd03.prod.outlook.com (2603:1096:101:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 09:32:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:32:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "huobean@gmail.com" <huobean@gmail.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "andre.draszik@linaro.org"
	<andre.draszik@linaro.org>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] ufs: core: Fix IRQ lock inversion for the SCSI host
 lock
Thread-Topic: [PATCH v3] ufs: core: Fix IRQ lock inversion for the SCSI host
 lock
Thread-Index: AQHb+0ON5o/y3tApo0m54Qz5c/IDR7Q/cvIA
Date: Wed, 23 Jul 2025 09:32:42 +0000
Message-ID: <2aaf5787ae231e3082721838278b336dade81edf.camel@mediatek.com>
References: <20250722200131.1322561-1-bvanassche@acm.org>
In-Reply-To: <20250722200131.1322561-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7562:EE_
x-ms-office365-filtering-correlation-id: bb677f22-2119-43d2-6cbf-08ddc9cbdfdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZjNmYzNZN29nSHVjU2xDOVFyZDVnQWlNMW9YYisyc2VkRHp0OVFwUWR2VGhz?=
 =?utf-8?B?TVRDVnE2YTFwNlR5azZuS096dUpOVjZYS1JRdk9ueWdieGo4U3pFV2JEenlG?=
 =?utf-8?B?UWpMNkxBTDV4V29LTUFXY25la25rM3QrK296RVZEdWNKbjNCVllZbzJ3cXFp?=
 =?utf-8?B?Wk8xVkJiNFJ1Vkp1N1dkUXdEN2FjVXg0S0orT3Fzb0U4ZnNESGd4YVh1SERW?=
 =?utf-8?B?ZnViSDhuci9rczhWY0dmU3ViUmh0ZWsraE1jUTd6QnFyRzkxQVl1d0JZM1hT?=
 =?utf-8?B?YzNyeGh1aDVkZG1VLzUrLzJ6RXM1YTVoTmJNWFBkdGhVTmFWeHE1eHdVckda?=
 =?utf-8?B?bkdUVC9FN1lYYjJuMXNvUllSRC9Sc3pTdVNLa0Z5dHlZcVMyNFU3N3lMV3lP?=
 =?utf-8?B?d2xxeG5CT040WS8rQ3doT1V5SEVOYXZFR203ZUlSamtrd1NEMHVZaXE3OVNL?=
 =?utf-8?B?OVF5VktTWEhzNUJuMlVCbTdYN2U2OWd4WFN2eUMrYm9ocmVId2RjSS95QzM1?=
 =?utf-8?B?NWNpNkNlTnNaMWdLQXFqd1FtMVNjanpnSDJYT0ZLRE1EdzcxU2ZkZ243WmJ3?=
 =?utf-8?B?elViSU1iU0lkVlBEYm8rWWF3dXpMWjdrSnUxTmFURHBScGhuMmZPNlNDRnJ1?=
 =?utf-8?B?cXpSaUZnVHdwYXVxOTVUaUxhOU1jbVEyYUVRUDRSdkxzTCtTTU1YSHZ0M01R?=
 =?utf-8?B?TkYrNUZ4L3p1cHRSMnlZWVFZQWsyOE5IdjMwZEd6NzB3dGFHNS9JMlhOdlcv?=
 =?utf-8?B?VjZ5VTlRUE5ScE8zUVlkV3p2U1ZocVlIc1UvZ1Z1aDNSUW1oUXJwOS90ZU1T?=
 =?utf-8?B?Uk50M2wyZDBzSWp1cGdyV216UlZxZTFFNjhtMHdjUTBRU3l2OWxydWM5TUJE?=
 =?utf-8?B?QlVVV21Ya0lnczF1VEVkOTFNUEdNTFJsQThyUHppMmhyYUJvL0JzVFNzNnRL?=
 =?utf-8?B?ZnBYWUt6M09GS2l6THUzNk4wVVNVUDhJRzFLa094WXFrNVFwQ1dIYTkvWVln?=
 =?utf-8?B?aElsTXl6SGE3bVE5aGNrL1hrM0RMMWZFRy95VklobWpsOFdoSzJST1V0RXdi?=
 =?utf-8?B?cTF4N2h3UlN6NWMwYlNTam1qeWFWa2R4d2Z4UW1SYmFGaWVJTU16QW0wQjdC?=
 =?utf-8?B?eXBaUDM0VlYxTlVjOVpWczFlWXBzVVh0UDJpU1UzRVVFblN2VXk3T2Y2S0RN?=
 =?utf-8?B?cWl5VkRFSTRQYUozN3EyLzFnKzRxZFJndjFzL3cvbXh2Zk9BTDlacmJkVUM0?=
 =?utf-8?B?dFVlMHVrRDZUZ0I2T2tGdlVFMXlHUllHMEJOM01RUXZjVDBXQ0lIYXQxR2NN?=
 =?utf-8?B?aHRnVWx2TzBvVWZ0Sm8vQmFKMWtnRnpBU2hjcEMvS0lqdENYMk1lWHBjOXd0?=
 =?utf-8?B?Z0UyT1JOZXZMRmhnc3pmTXlOTDFxK3k2WkxxSmRCblFZb0IxWFY0UElBY0tj?=
 =?utf-8?B?OUlhWFlGME5pb1VYT2E1YWNPeXg2anJZWVY4OVc4b3dNT3ZtbW8weUVzdkxO?=
 =?utf-8?B?blBYTVV4MmRzaVZIaVVzZmh3T0M1eVk1cnpHVEFKY2RoS1F3WEpzMU4vOXZ2?=
 =?utf-8?B?bnJkdWFkSDFwYm5vcVp4eHRDQnpSZWk4d2ROdi9WOVhMbzVBU3ZCVk52Mi9F?=
 =?utf-8?B?TndmakdBZWtySGV1RXVJOWhqeWhBcFV2RFJJeWgxellyeSttaE1halNvWUpW?=
 =?utf-8?B?cFNIem13Mmh2aCtQTmhDbXpsMmdzREFHN0dpbTNWMUYzN3kzKzJZS2QvSFZs?=
 =?utf-8?B?cEFkSGhTNDZ1RGI1Mmx5SDRieWFPQ3RhUm5rK0g4RTA4NHBsZTdUdjRINXBP?=
 =?utf-8?B?ZkE3STUzTTdQcFhZVVdKU0tBN0FOUWNLMk94SHl6UUdvOVdQeW9kanZUTWtv?=
 =?utf-8?B?UGlIYkVvN2Zlbnd1em5MbTU1dHlKbHdVdjBnM2tkYTdUczUrRzJUdzFRVDZk?=
 =?utf-8?B?OWl4Qk9KUEYvQnJKWjlZajlXVnFnQTc1ZVRKTmpxOGljd0JLT29FZjI2WkM1?=
 =?utf-8?B?Nk8zc3VOY1RnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?em55NUpldjlzTlhYM2ViZmlnMHVYL0g1aHMrYWN4WmFlc1pITUNnSFp0bXE3?=
 =?utf-8?B?S1ovMTJuUk9ZY1drcUVBTzU3U3c0Ymw5Z2ZoVTVIZDFTOThYZXRiQmlad29u?=
 =?utf-8?B?WktIb0pLL2drNFY5cUZ0RlZvenRyRG9LSFNJSURiSTN3eTNIWWxDTW82bncw?=
 =?utf-8?B?M21zZlkxeE1hbERFUlJ1QklCVlZOWGdKWWhuRXViQkVJRWNuMlRWMlYyVkdW?=
 =?utf-8?B?NXlTQUlhVDdkaEdNck9PaTZpcXRWa0NQUkgzcFJBeEo5Nm91TXdFaUtmWUxh?=
 =?utf-8?B?UzRkeEFiei9vVHlRMk9FMERuQmpRTTlXVisrUTBLK3lidjRkdHlIZVdEYSt2?=
 =?utf-8?B?L3R3dzBSMlpiaEpiUTdiVzRzSmp6d3hKYlpTUzhKZEQ4b0FuOU4vR0p1ZzVp?=
 =?utf-8?B?cEY0SUIrUlkwTngvZEJkTE4rUEhNYkpzc3l0Mk1VNlRSL3dEMWswTTJnRUN5?=
 =?utf-8?B?RU1LRnBWOTJjOHlFd1VENGpNbWRUMldXcXl6cE1CaGgrdWJuS2tsaDFsbXNr?=
 =?utf-8?B?SjJTWHVpdkN1ZW5tK2ZYdXZKbTJ6Wko5c0x5Yk96WXZIakdlNnMyUE5Gd1lh?=
 =?utf-8?B?ckRtSUFWaTJydHFVN2l0NENGRlk5S1R0NFp5RU5mVlhCT3hYcHNXdDB0Q0Nk?=
 =?utf-8?B?MFNuNWVEVnMxU2tqN3pnajhiYkdxTklTWjZ3VUpzRFdBVUsyRGZnMXBmcVpU?=
 =?utf-8?B?RzZaZzFxV3ZaWjJPT1l6T2pxYTNxVUczZFR6SGVQQVcrVzlKMmRnaHkxYXZx?=
 =?utf-8?B?c0VlaXdCTVloS1FXQUVXWXpIUU0xUnNtcWRZcDM2Q2xHUzhuUmdFODRIZVVw?=
 =?utf-8?B?Rkd4aVhCbS96bzZReW43dUJESGlUQ2NXZlJWNzVzVzFMSXBCbndyNDUvWWk3?=
 =?utf-8?B?ZmpZTXYvQkorOFlsakJLMmYxd2lWcDJ5V1RRMVo4MHhzZFF1QTBpblp1Y2NY?=
 =?utf-8?B?MWVNcGw1RDN1M0pBSEVaQm9zSHRiSlBZOTRyVVlmRmJCV3crUDBJV0huSU5U?=
 =?utf-8?B?MUMxUFJsU3M2R1dmelc0UWhGMjhiR3lvRTBONUQ4MDBZNTVieWNEaVl2YWhp?=
 =?utf-8?B?NDA0WUFIZXBwVnZzMGJPdGZpMzR0bDJXdkcrdy82SVQzQm9PNDVJQ000d3J2?=
 =?utf-8?B?cXcyNHlXTVRzcHdkRnZGdVdEeDFtd0xUUEI5K0RTakZSQmN4dThxWkhuMTR6?=
 =?utf-8?B?a1dsRGR3WnJnMFhKOTRuZFFURDR2TlBGMS9nR0YzZ0owWHBaNllTMXFYN01s?=
 =?utf-8?B?Z0tGWjRmVi9DZ0FZUkd3RjBOR2FGTTZBU1VDSzhka2JObTI1eGdhSjZYcmZP?=
 =?utf-8?B?VHdFYUw2aDFwaDNtdm5XVHIrQ3NSNVBlckRvVjlhalZJM1lvUjRObDk4RDFq?=
 =?utf-8?B?WG5JOEc0RFFKSll4emZLSEFlY0ZjOS9yUWF2SHg1TUtkTDd3NHR1RStjb3hl?=
 =?utf-8?B?NkF5TzMxZC8wUUp1d1l5b1REeVVYNWtPY09kaFJHN254ekQwbHhXU1luYit4?=
 =?utf-8?B?QlRtVzduTDM4cnN4RTZKTUE1MFpJdmRvVGxvR1BQTCtBM0hEekJKZDVkbFpL?=
 =?utf-8?B?S0Y0dUI4a3MxcysvZEo3bTVLbWRKUjFJa3RlN0dLTWV2ZnpPeXdRZ3psMEMx?=
 =?utf-8?B?VXpaaFNCOTlLN1dUbGE1eWhxWTJkb2QxQjNJR3FOR2FDazNRTDR3MlFkM3dG?=
 =?utf-8?B?Rk1DaXNrR1J2aEQ0S2N2NGFHc05IK3g2Z1daR2dZcGRuQXdQMnJTU21yR3lw?=
 =?utf-8?B?UnlKMDVRdUthazR2dnhQUHJKL2dnL0VjQXVhaFBtekc1Q3FvcUJhK0NTeWZv?=
 =?utf-8?B?MlFqZ01XQmVXZFF3RS9BclFzUHd6ckJzMjJ3ZFBzTktrVWZMSGtSc2dwZ3l2?=
 =?utf-8?B?WlIxTjhZMjV1WG00YmdUUVZjT3lzZVB0cVQyc0MvallNRkExQ2VtS2UxTklz?=
 =?utf-8?B?R0RXUGxYcEhxQUlhWmtGRS9CeE4wbjlPMkp6a0R4cGlxOTJ6cit5NHBlNDRD?=
 =?utf-8?B?YXZwd0FVYTIwL0EyQmlTZ0djenA4UXR1cGxKRUduQnlRTm1uMHNDd1N3NXRJ?=
 =?utf-8?B?Zk1rdzUzNU13VXErejkxV2l1SjlDNUFKejUxcjBlUlFERE54MWlWcU5kWXFM?=
 =?utf-8?B?cnAzZTRlUEEyOXpjV0xCbGlva05wdUZtbnlGeDBFcHVaLzZoWmI1WHFLcDF6?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5EBA9178AEEF04D9A9F6973F8E07A29@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb677f22-2119-43d2-6cbf-08ddc9cbdfdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:32:42.7186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FryoutD8y5GZTjFwPXcysel41HdXfPYEF3ulh+rJ+/W+Rk7JDqIFXHp4/dExkxImpymFFK7aCMAteajyAftOLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7562

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDEzOjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCBhY2ZjMWI0NjkxZmEuLjgyMDI3N2Yy
YTkxZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysgYi9k
cml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC01NTY2LDcgKzU1NjYsNyBAQCBzdGF0aWMg
aXJxcmV0dXJuX3QgdWZzaGNkX3VpY19jbWRfY29tcGwoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwg
dTMyIGludHJfc3RhdHVzKQ0KPiDCoMKgwqDCoMKgwqDCoCBpcnFyZXR1cm5fdCByZXR2YWwgPSBJ
UlFfTk9ORTsNCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IHVpY19jb21tYW5kICpjbWQ7DQo+IA0K
PiAtwqDCoMKgwqDCoMKgIHNwaW5fbG9jayhoYmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+ICvCoMKg
wqDCoMKgwqAgZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSkoaGJhLT5ob3N0LT5ob3N0X2xvY2spOw0K
PiDCoMKgwqDCoMKgwqDCoCBjbWQgPSBoYmEtPmFjdGl2ZV91aWNfY21kOw0KPiDCoMKgwqDCoMKg
wqDCoCBpZiAoV0FSTl9PTl9PTkNFKCFjbWQpKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZ290byB1bmxvY2s7DQo+IEBAIC01NTkzLDggKzU1OTMsNiBAQCBzdGF0aWMgaXJxcmV0
dXJuX3QgdWZzaGNkX3VpY19jbWRfY29tcGwoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGlu
dHJfc3RhdHVzKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX2FkZF91
aWNfY29tbWFuZF90cmFjZShoYmEsIGNtZCwgVUZTX0NNRF9DT01QKTsNCj4gDQo+IMKgdW5sb2Nr
Og0KPiAtwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4g
LQ0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0dmFsOw0KPiDCoH0NCj4gDQo+IEBAIC02OTIy
LDcgKzY5MjAsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX2NoZWNrX2Vycm9ycyhzdHJ1
Y3QNCj4gdWZzX2hiYSAqaGJhLCB1MzIgaW50cl9zdGF0dXMpDQo+IMKgwqDCoMKgwqDCoMKgIGJv
b2wgcXVldWVfZWhfd29yayA9IGZhbHNlOw0KPiDCoMKgwqDCoMKgwqDCoCBpcnFyZXR1cm5fdCBy
ZXR2YWwgPSBJUlFfTk9ORTsNCj4gDQo+IC3CoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKGhiYS0+aG9z
dC0+aG9zdF9sb2NrKTsNCj4gK8KgwqDCoMKgwqDCoCBndWFyZChzcGlubG9ja19pcnFzYXZlKSho
YmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+IMKgwqDCoMKgwqDCoMKgIGhiYS0+ZXJyb3JzIHw9IFVG
U0hDRF9FUlJPUl9NQVNLICYgaW50cl9zdGF0dXM7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAo
aGJhLT5lcnJvcnMgJiBJTlRfRkFUQUxfRVJST1JTKSB7DQo+IEBAIC02OTgxLDcgKzY5NzksNyBA
QCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX2NoZWNrX2Vycm9ycyhzdHJ1Y3QNCj4gdWZzX2hi
YSAqaGJhLCB1MzIgaW50cl9zdGF0dXMpDQo+IMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gwqDCoMKg
wqDCoMKgwqAgaGJhLT5lcnJvcnMgPSAwOw0KPiDCoMKgwqDCoMKgwqDCoCBoYmEtPnVpY19lcnJv
ciA9IDA7DQo+IC3CoMKgwqDCoMKgwqAgc3Bpbl91bmxvY2soaGJhLT5ob3N0LT5ob3N0X2xvY2sp
Ow0KPiArDQo+IMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXR2YWw7DQo+IMKgfQ0KPiANCg0KSGkg
QmFydCwNCg0KSSdtIG5vdCBzdXJlIGlmIHRoaXMgcGF0Y2ggY2FuIHJlc29sdmUgdGhlIGlzc3Vl
IHlvdSBlbmNvdW50ZXJlZCwNCmJ1dCBpdCBkb2VzIGZpeCB0aGUgcHJvYmxlbSBpbnRyb2R1Y2Vk
IGJ5IGNvbW1pdCAzYzdhYzQwZDczMjIuDQpIZW5jZSwNCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdh
bmcgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb20NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
