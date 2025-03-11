Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8541253B5C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741696360; cv=fail; b=Pb2poLcPd5r+iyje/B7xtGB1K0LLM0VAeaPADikA0pMuVwSFLcVijRbhORM7uK1XhZPgZxPKsSyJ6F0mMZ4co7ey/3sz0nG7FJUWXDp0uhJUiSPJxrFuEoQ08NOYzPk4cB/Jncm4pZxubwFbkmQR+CILpnUQRucHFuj/njePbDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741696360; c=relaxed/simple;
	bh=xRsA9I07fweTnNrDJ6GCEEwgvJ7q02GUKBQ04rbOw3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CN4UISMcV+qBeACExHuF3Pjh8eHTQjUhGe6tboP241zVLxtvJLBN06r+69ckwuQtmSXDZG87eBkZMVwFnEBOgwpqNMBvGbYi6hyT8/ksnr864CmaDuVnmvB/Xzkar7l28qMYNQ2QDc159HTPiYlxW6fUkm43WfGl84gdTUzMQoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Geu/Okam; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KishX1gv; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Geu/Okam";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KishX1gv"
X-UUID: e6e4ca96fe7411ef8eb9c36241bbb6fb-20250311
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xRsA9I07fweTnNrDJ6GCEEwgvJ7q02GUKBQ04rbOw3Y=;
	b=Geu/OkamxXD6PWJE787uQVSRCJERsitgE4IoqO3wK16viNzbFp4n6P1JqCj7415tQJjv+6Re7wzuH8Cwuanxxjx1b2k2WYlRCWKZgFkfHOZ/ifuLbS5cZ0FBwfGNcyHEerknquAvP/6eC7hgcEYjwqoLA71HXdmvRcl9kZz6ukM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:71a6dae9-2fd3-4a0c-a653-541805485fb6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:daf1f749-a527-43d8-8af6-bc8b32d9f5e9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: e6e4ca96fe7411ef8eb9c36241bbb6fb-20250311
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 606993585; Tue, 11 Mar 2025 20:32:31 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Tue, 11 Mar 2025 20:32:30 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Tue, 11 Mar 2025 20:32:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRJa5u/+isP2BjymiCFZInGkrRNDkYZzvHRLjfo8HAl+/lPgd4Yo3s6Tm1JRxct9ckk/dvPBJTcyTyoXmSjFtfKAnk8nvLfFxbLMSkofsThNuCIlkpOjTRgxUkbg3mI9w2BeiV1JpqxdV1/5eZ5U3Mb5Z7UnPphuKr29ge/JA0rNHH12k8yO7Drboc4iKeSLvs3yENwMeFxWMjCoIXy/uCBMdLDy5JZtTrGmiwJ0x85fAcRc4yJf2msdCdGv6b6HjQQHdxRR53JBKaeyDt3F8cv/l6lGfBhr21tF/e0SF2WqiRu3SOCl8CgjLX/LatZMykXaSkwo+WFh4EwTVjYldQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRsA9I07fweTnNrDJ6GCEEwgvJ7q02GUKBQ04rbOw3Y=;
 b=UBNR1yQGeH1rjVrflMJu2ndoSAyet/bSKf+c8+ZgRKk1Fn0uW6rVelVAjeM7Ut9T+S4nMe8D+qMiiT9BCHBxSTjid15Q66ptDX1gdy7rjGYo+SlO0xzrSc0BsPz9OyKK5safTROn9ROSk7roTQeCQOlhAmD155fX/V5aGdRv+znaQkJnxFarnpxn3ZGj3in9PZaJEDVqZ6VfSEWqHWRnlKCspiESycCy+HPpl1y4VjVswdy6/ayhCUFTwQaoWVrhx52RbKryoEApB5x2c4WesMp3EbymeNMRdzTIb7kdEc6pQWzFQV/eDwGPFUlNIcQ0Hr934l1tfU6iuFcDPi9DZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRsA9I07fweTnNrDJ6GCEEwgvJ7q02GUKBQ04rbOw3Y=;
 b=KishX1gvdmeTnxAA1Cg57+JU0RUdrMca/i+ieHWK+IyuRrYstF0qGBl18XNCJHPr+Z3X6UhTjwIEkhiDrdeK8Xj9FWbYSBWXgD6+/dfkatl7B3s4c2RobO4Ko7iSPlh+Ylcux3e1NncwT+EVFQ5xuGeudNky48P5/C6A77CClXc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7293.apcprd03.prod.outlook.com (2603:1096:101:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 12:32:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 12:32:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "qiwuchen55@gmail.com" <qiwuchen55@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "qiwu.chen@transsion.com"
	<qiwu.chen@transsion.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>
Subject: Re: [PATCH] ufs: fix deadlock for the case of pm shutdown during
 suspend transition to resume
Thread-Topic: [PATCH] ufs: fix deadlock for the case of pm shutdown during
 suspend transition to resume
Thread-Index: AQHbkmGr9jJvuBUZk0Cdib+ca+/+wrNt3ocA
Date: Tue, 11 Mar 2025 12:32:27 +0000
Message-ID: <c1e59928f26d59ede3719ed66aefc7b53a259b2e.camel@mediatek.com>
References: <20250311084257.8989-1-qiwu.chen@transsion.com>
In-Reply-To: <20250311084257.8989-1-qiwu.chen@transsion.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7293:EE_
x-ms-office365-filtering-correlation-id: ea23d2ea-8d5b-4839-a043-08dd6098c872
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TmcxeGYxL3gyZEhwRTJYZFc0MW1aNWJ2WTROT05EakxlRkxOZU5yTUllb0l4?=
 =?utf-8?B?WGYxdmlRaStQVHlZMU5vWTg4Z3hJMzVaS2pHUFU3Yi8yV0xyQzhGNUVKWXAv?=
 =?utf-8?B?Z0ZNRjRwaU1rOG15ZXMrR2xaeCtzQU9BeGxkUTNwdHZzNCtaS2RXd3ducHRP?=
 =?utf-8?B?QWVxd0ZWMVRvUkNGSXgrcFVzdStKRFozQmM1ZEF5RzV3eHhPVmtJUWs5OHM4?=
 =?utf-8?B?QU1sTldhNDJlZDFYRUN5OGxTa1JCVGxGdGpsVzh6ekVDdWpGbkQ3MVRNZ3V0?=
 =?utf-8?B?bHBvd2JuSSs0aFoveXdUajNFbkZPbVIwYnNIQ2YyWHlDbUdxVitxcWJleGNQ?=
 =?utf-8?B?NFJMMExMVldyWmt2bzRVVE04ajRUZktlUU9VVXZLR2VKSStHTWJKNjgzclhx?=
 =?utf-8?B?SXMzdVlzMTVyN2F1ZGVwczFSYitxcmlSemhYRGNScXpCZnVXaHEvV0NEakpD?=
 =?utf-8?B?WG1tT1BIVjg4alg4aWFJcThxUVRGcndFZVpRQS9RTUgvZVFDRGhJdEJ5RUpD?=
 =?utf-8?B?Z3VHWFVUalRZMzRORUl6S1p0b1FkVEhITlQvOGRiOCtxMHgrYXhCWUVKK2tJ?=
 =?utf-8?B?clJHL1lBSHRrYjErWkZDd01KNml0eWx4UWEySzBJVGc1NjUyeDVEbEpaSFlX?=
 =?utf-8?B?dkt4aVVGYW52c3JSMUdUcE0zSXFhN1cwaFQrOG5WbnllRVVlZlpzbWNiYi9h?=
 =?utf-8?B?dE5idnIyUTNWUDZzSkkxVmRWSnRoams5MitFWHBqZVFxbjhMblMxVkd0TTZl?=
 =?utf-8?B?bTczcmdKdEhNTmdkUTJxTTdpRGZNQXMzRVpQWXlzT0pzWU41WTZucUJ0ekdF?=
 =?utf-8?B?MjNCVFdvZXZwOE93eWtCUDhEQ2tIaUpQRkU2Q2NXdlVxTDM1TXBUTFFzRXls?=
 =?utf-8?B?dFcyaW1MMzZQSzRkQkRLQTdzV0ZZOGNPUmYxMFBZMFlKRzN2THZoT1FEUVpi?=
 =?utf-8?B?bmtReUtmOE5NMkNzUTZNZTNvTi9uVFgrMHdITXB6eU5vYndYZTgvQzhXemNs?=
 =?utf-8?B?MjQrYTVMTnN3M2pwY0dsSEs0WnFTbWxaamdRT1RFSmdCcGhRd1FuQ0pKMmNS?=
 =?utf-8?B?dGoyT0ZsQ1pndFNDbDNuYk5BdFhHVTA2aWZUVkZuVldHWnN3NXViRUxFTEho?=
 =?utf-8?B?YVJPSTR3Ulo5NFJpQTZwVXg5R1czYmpjVGN6dVhlTS9vQXU3RFVJSVJyVDBW?=
 =?utf-8?B?T1BzY1VTODhFL29JbTl4NlIwK01rdXVDWHNhWmljcEpUcHExVzVhK0pJazNk?=
 =?utf-8?B?MlpjbWxHMk4rY1N5Skoya1VBZEFRbWlRb2Z4eDluTHNOTHhMcENoZDJlUlYx?=
 =?utf-8?B?RDI1TjE5ekhPRVFNVG4xQTJ2elV6dm02c0pIamFUWk5DVEFXRnlsK2VGRTdK?=
 =?utf-8?B?VzVQQXdOY1BzVXFRUnVmQ3NxUnA4VG4yYloxVUdnbkp6dkVoeHZlWkFMaXRZ?=
 =?utf-8?B?d29LRmQ2bzhhdXdjMVAxNmlNMHA5S2tYSVFZclFESGpyRUk2T282UXlpRXFN?=
 =?utf-8?B?d0tTK0pkb2ZoaGYzd1l3RkMrRUd2T3BHV0pCWmo2em9Ia2J4d1NGRUsyOWhG?=
 =?utf-8?B?Vy9pb3hxMDZNYTVsMndDdDJERStRVDZZZXhqbEp6OXJKbmlOTFVIejZna2p2?=
 =?utf-8?B?cUFSdnVCZGNSYlVubm4vd0wwSWFqeXVVR3dDRTM0TTk2aGhnU1Jkb1NJRTMw?=
 =?utf-8?B?aTl4bm13R0NvaU5QcEVSZmYvenUwanBYdkcxajFVb1dOVDVJdm9EL1ZXUnpJ?=
 =?utf-8?B?dDZQVGZGQ3ZsQmh6QzVqd2pjeStZZ0U0NHBTbkhBd3dpZUc5bklQTldhbjlN?=
 =?utf-8?B?RnM1cU11QW5vbWcwWDNmZ0NJc3YwT2FLdEpnbjQxZWZYclhvY3BnRjJnTCtF?=
 =?utf-8?B?c2xmSGdOQlQ3ZDdoQkN0Y1FUeExpckpSUk5Idlo5ZWxEVk95QU9FYW1JaUVK?=
 =?utf-8?Q?7Xntmo60RlxPrbdCrxpJf3r9l2GYb/Ow?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzJTM2pEa3NQMUZ6M1BUYTQ0cmIrNnNYbXJ0blJvYzhoOVNoV1VwUmdTZ3NL?=
 =?utf-8?B?RVA4WUgyTFprbHVlR1R6L01zaE9XK0dsbkNMaHpGU1lWRXZTK3I5bi9RUjdj?=
 =?utf-8?B?RXBZVG13RHJmZVdKN3ZRN3MvbWg0YmJ1dmhXZ2hRQUIvZldVNy82OGRWcGJW?=
 =?utf-8?B?TFB5d2k2MWlrVFhUWTVuaVpERkF6MFVOb3dMYzFXR3pKUWd6cDdtQTBIVTR2?=
 =?utf-8?B?ZVNpTnhvTEhoWjBPNDFXdE9QMEpseDUzN1kxOU01d3k2STk5UkdDVWVKOWRP?=
 =?utf-8?B?eDArczZ6N20zUXRJY2VHb0FaK2ttd29IaU14QU5ZYU9ITzQxZUtmdWJreDVa?=
 =?utf-8?B?V3pja2M4ODVSLzhSaEVFRUhUcU16b0JGVnNqZnNRdVpwclV4S3FSTCt1d1pi?=
 =?utf-8?B?QWVWbUFEZzA0VCtXUDBCd0I0YzBWb20xdERvMFBYMmFqNzdtR1k0QVFNVTVs?=
 =?utf-8?B?RW1RKzdBVXhTVGdSMFlEeE8ybm0xYldQTzdUWGZibkJwa1A3c3FNWVRoa25O?=
 =?utf-8?B?UTN1bHh2ZndNeGpCQ1p5RE84d2dZV2ZvdkUvbG9aTTlkeDQ1OEpRZzg4TDk3?=
 =?utf-8?B?cnRMQTJBVG1hVE52RXY2RmRvRWg2Z2RjUzZLL3ZnVk9UaWFVMUtzbGpqbzRY?=
 =?utf-8?B?dWpQeEw0K0c1VXpGaU4zV0hvQXlMU0E4SzZzZ3JUcTBPT2FKdUUzOVBLampD?=
 =?utf-8?B?bTR4NnpqSGF1aU1WeG9mb0pzck05ekxBcTVLc2pIc0dUNzNDWTJUQW9JV2tO?=
 =?utf-8?B?K3NzMFRYRUx0cFFCbm85cDFpSlRJK2lia0EwT2JKVHd3WkcxRkNSZ2RIQUhG?=
 =?utf-8?B?dloyODRnbHBoNWNJYUhqc0RXQXYrNURHbGtFSjZIZlJnMkVvMkxmdGdBU3JB?=
 =?utf-8?B?ZUN5NFNvRm1RL21SczhjVXdQaFVnanh3NCszUFVFVTF4QXp4SDZ5cGljWnBh?=
 =?utf-8?B?V1hzWlZ0bFQ2ejlEYW8rY25jUkpPY2Yzek9hVHpUTTl5NUVSZ04yZzdYcEE4?=
 =?utf-8?B?Sm1icWcrNmx6d0pJUXpwbFZXa3kyMGxTNkkyM3ZQMTJiczZmOUg1cXBxL2ZY?=
 =?utf-8?B?ZVRsbFRsS1VUbFlYQkk5Y2ZKSUFsM3pRMGQ0VlNja2l3TU81YWRjdms2c3hs?=
 =?utf-8?B?amFXYlU2VUdhRGtxRUlBcTF3cnZUMTRzVUlZejZXa3JsRnhuSXpFbzJSa1dm?=
 =?utf-8?B?b3ZBUUpjeUNhK0dYZDdHMy94QmRJUXFDS3BhNmJxWGhMNmxKZWQ2NDhvRiti?=
 =?utf-8?B?bGpLQmZBQmJVR1BQSzQ3LzRUMUh5T0YydWY4ZHExUEhvV0lEVi9kZTc3UVUr?=
 =?utf-8?B?ZmxqK3BzYzc2c3dDOVdMTUlCNUUrcXkrbmNSOWlmRHp1VUh3REdvQVh2OFc3?=
 =?utf-8?B?RzVtQlZVS0o3VjVKRmhDNy83T3VHVEovMnhZZDlLNXFwc0FHczlObnYrd0dP?=
 =?utf-8?B?V1pBaUhhd0NsMUR3WTNVQlMxMXZYdllRejhtR2wzK2ZMRU1VcXA2ZTVPOUlj?=
 =?utf-8?B?VzV2b2lQMmJ6N2RSb0hDN2dWOTlTNVlMNXlIWkg0Zm1mSFBLSkNBaFZqTk1N?=
 =?utf-8?B?T3djaGU3RWVZSUw4dnRFaGZPOUd3THZmdklCWWRvU09VRW9HdHdCR0xNOFFW?=
 =?utf-8?B?MzF3ZEVhVmxtc21HZzRsdW94YlpIZmNNdW1teGxqSzJIVlZBZ3p3UlhXVEdZ?=
 =?utf-8?B?TUVwNlVjWkdWNDd0RVlaeW5lMnFnSkNUTXMwZTFMT1NhNjc0a21jNmgyY3ov?=
 =?utf-8?B?YkwxVFFTWVlXMUQ3bitoMU1CNTNTRnlEVHJHdHl6V0svUkJodmV2a2g5bEtl?=
 =?utf-8?B?Q2RaeFVYbmNoRUxlREJvOHBvRDE1WGxoeFd4MDlIbUlQazB3S2ZMMlBWazNK?=
 =?utf-8?B?VDhQV1NmdGpEbmRWZ0NtQW1lMkNGcEh3bHE2cGRTTmg5eXhoTFJxRjhwencx?=
 =?utf-8?B?UCtkRWN0VzVsNzVBbjdUZTJWTnIvWjBlcTBwSGh0QlRiaUhDR1NJR0duUUJG?=
 =?utf-8?B?d1M4MThxbXJVa0NnQ2Y2RGw1VzlxMWY5TTJiaHdwakVkQzVLOGpEdFZlcmVa?=
 =?utf-8?B?OTBOYTNNRlVyc2QxLzFDVFNBR3VBY1ZnekU2VUxQUnQ3MGdiVEp1NHJ3ckFP?=
 =?utf-8?B?M1VoUjAzK1EyV2dDS3hhbUNmbHhDQTJWeE83T1MrSW5MdGo4SXI4ZFcrYjE3?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0767E8DD2384744837889F2DC827319@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea23d2ea-8d5b-4839-a043-08dd6098c872
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2025 12:32:27.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3KUvczP3FdXAa31+xFMarWu6oGG2JVY/nPNs12DRIZ82ku9c3NJql1Dg2EBlucvAMAFszxyIk/l3HPYKgkebA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7293

T24gVHVlLCAyMDI1LTAzLTExIGF0IDE2OjQyICswODAwLCBxaXd1LmNoZW4gd3JvdGU6DQo+IFRo
ZXJlIGlzIGEgZGVhZGxvY2sgd2hlbiB0cmlnZ2VycyBwbSBzaHV0ZG93biBkdXJpbmcgc3VzcGVu
ZC10by1pZGxlDQo+IHN0YXRlIHRyYW5zaXRpb24NCj4gdG8gcmVzdW1lLiBIZXJlIGFyZSB0aGUg
aXNzdWUgcmVwcm9kdWNlIHN0ZXBzOg0KPiANCj4gDQoNCkhpIFFpd3UsDQoNCkl0J3MgaW5jb3Jy
ZWN0IHRvIGRpcmVjdGx5IGNhbGwga2VybmVsX3Bvd2VyX29mZiBkdWUgdG8gbG93IGJhdHRlcnku
IA0KVGhpcyBpcyBlbmNvdW50ZXJlZCBkdXJpbmcgdWZzIHJlc3VtZSwgaW5kaWNhdGluZyB0aGF0
IHRoZXJlIGFyZSANCnN0aWxsIElPIG9wZXJhdGlvbnMgdG8gYmUgcGVyZm9ybWVkLiBCZWZvcmUg
a2VybmVsX3Bvd2VyX29mZiwgDQppdCBzaG91bGQgYmUgZW5zdXJlZCB0aGF0IHRoZSBmaWxlIHN5
c3RlbSBoYXMgYmVlbiB1bm1vdW50ZWQgYW5kIA0Kbm8gbW9yZSBJTyB3aWxsIHNlbmQgdG8gVUZT
LiBPdGhlcndpc2UsIGlmIElPIGNvbnRpbnVlcyB0byBzZW5kIHRvIA0KVUZTIGFmdGVyIFVGUyBz
aHV0ZG93biwgdW5leHBlY3RlZCBlcnJvcnMgd2lsbCBhbHNvIG9jY3VyLiINCg0KVGhhbmtzLg0K
UGV0ZXINCg0K
