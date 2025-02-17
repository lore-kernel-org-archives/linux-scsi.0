Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F992137750
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2025 05:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739770318; cv=fail; b=EnQYyAoLUVII4CJRdiqE6TV3yYdvT7kQcKmUou7WpcQx+wQnf7uFcGT8gWj+KgZXqdb6VoE9WK1D19bKDbEQDfPkbISmn9azBNrXa6mAoDPi/qJdmBPcJ75WVU3f9dodapVwz8CY3i53QEEwWWiEnVsHGkWBg7Y0IoIpGJT491k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739770318; c=relaxed/simple;
	bh=toajiddPrYGuxZQ1C06ojtjwBXb7Jr55vXuozP2em9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OkMgpxAfFF+1OkUeoeLrrFCUzFsOqq3gYptj//VjMIcmSI7XnmgXx0jspDLASlXJqyOc1J6vqBpV+e1GnXhuGAgKymdaQoP3rFIN9fWxMN+E5FNaOgbS/qJ6aENs6dSMnIo6KmB2Q+vsYxm8nGJMgKQ+1PHYQX/gxOdPUL0ECVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LmALe0Wu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=amAaZbM+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LmALe0Wu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="amAaZbM+"
X-UUID: 7c86fba0ecf011ef8eb9c36241bbb6fb-20250217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=toajiddPrYGuxZQ1C06ojtjwBXb7Jr55vXuozP2em9I=;
	b=LmALe0WuaBAqcmjK2nXBABT0gc6Hndy54q9r04YgaV9TDMalncb0f3O2GBXmH10QtG6WjI0GtTv6aUKk2KYJJLRoVxFerYYZBAzwx/oXz4iLHtTdsNqtGxX9s8XyeoOtbyYviX9il7dsCFHTf3bm08cOSgMzpk4fRlutK3K+2ic=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:826c5908-3532-4bca-aaf6-8094349962c1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:6d3f7a88-f9ab-4ac1-951b-e3a689bed90c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 7c86fba0ecf011ef8eb9c36241bbb6fb-20250217
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 766199204; Mon, 17 Feb 2025 13:31:49 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 17 Feb 2025 13:31:48 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Mon, 17 Feb 2025 13:31:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SThGUtsl7Q1jsptSgRxEavzLbARiYzA0RLHeSRVWj+nQNDwtHzmfvMTLGKvvxDtku977XBT7w76sPtxwHiLE/kDHiIVHza2yAsaf4H2XFrMe9yZA0HsKGQVM79F95UebJdZgerzsyEpCuTHzq7l2VCKbQDLX+s/hM5Hk3lGxS37JeNI6ikHUtCC8BrHEzvGw5CwgGaO4WrpwcqtZno09O1iJ7ro+iWyKwQGghkVwkS4w6ZZc8erfHk3DUUJSdSHEM7dnW5yuQDqiux2jkCCLMIi5kpi4TwY9OKMQqdIkL12CU46Qrz2Jhf3AYl7Wb5yZ90c8GwYyvGiuITLhXV8MqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toajiddPrYGuxZQ1C06ojtjwBXb7Jr55vXuozP2em9I=;
 b=vElT15AMloPvRqVAi1WcLAZ/EsgjUuWLrlUc5igxHdyIYjXSig4z5jApqJpL19IVZK/KnkJsIihSemIkrFtl/SaSV7eYgXojEZqDNlsWdYymrW5AOjYBLNQN9NVJMeALFv4e0bG7i50pYwJmEGlejwxHoybmo/ETfhTuGvhOVq9NIkFxf7/c0+U1ZfRuw/OFSbWfcue/nPhvHHgNv4VuULjIsMSzbRuQZEyE4behTU2IBLJjtJcnRRNe3rVkBvHt7HnV86CgJVVsAXufBr6Golxif6P3OfKa7F+y/t/j9VHYd9cdP50vxeI+3PgpM3B8gNKHDtwvVeehi15dpZxOKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toajiddPrYGuxZQ1C06ojtjwBXb7Jr55vXuozP2em9I=;
 b=amAaZbM+5QdEChiaLlKGat8xJVQTGXKJ2ppGrAZUI81nuL23COFWmnJ/F1+z5x+HqOA44UKcafFJtGdDuYoJHostXAPiOj/ze7kytaUQXpvsC/C3P6YDoYOSSoyl3+6sLc/mZjeZjMDG0y7dQIHjmpJ5qN5WzeFLWwy2d2r5h2U=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by KL1PR03MB7599.apcprd03.prod.outlook.com (2603:1096:820:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Mon, 17 Feb
 2025 05:31:46 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%4]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 05:31:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: Fix ufshcd_is_ufs_dev_busy() and
 ufshcd_eh_timed_out()
Thread-Topic: [PATCH] scsi: ufs: Fix ufshcd_is_ufs_dev_busy() and
 ufshcd_eh_timed_out()
Thread-Index: AQHbfzKrZ3I20FMAekilK0ujHZZg1bNK/BGA
Date: Mon, 17 Feb 2025 05:31:46 +0000
Message-ID: <ab81d45c9789e4e2ca470437bac56394f081a5d8.camel@mediatek.com>
References: <20250214224352.3025151-1-bvanassche@acm.org>
In-Reply-To: <20250214224352.3025151-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|KL1PR03MB7599:EE_
x-ms-office365-filtering-correlation-id: 8d953b69-5074-4045-e215-08dd4f145e9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dFhCVW1VRXNPak9TVUNtbjAya05KS1hTNUd0VFhDUXFJamNTMSttZWxUSHlk?=
 =?utf-8?B?aFhzck4ydHpGaGVDU0VjblRFSFFJRVRmWlBvTkVHVmVTRGF6ZjRqamlXTUpP?=
 =?utf-8?B?OHlXUDJqbEFOcEFySC9yRFdwalRmb2VtSTgyeEtDVDBoNHpVQW9oQXZtdldL?=
 =?utf-8?B?VStzcWc0cXJwd2JyQ1FFd0FOeUFkTVNUcTZIdWhBN3VvMVFwaHlBMWgxbnhM?=
 =?utf-8?B?ZFJCT05ZR3BQRFgyTWJXM21DUU5NZUwrV21USXhJZ2E0MHo4QVcwM3JYRGZ0?=
 =?utf-8?B?L1MxNk9oRjlXSFh5Z1JJVU5VZy9XSnRjR3NmTWtGYlIzNHg0WHRYU3ZWaEpW?=
 =?utf-8?B?WTk3by9SY3BpeDhNUmd4NkEyUWlTdVA4TXNCRElSNGN4eEFhVU16TGxFcTc0?=
 =?utf-8?B?dWh0b2puVVdRY0RvVXh0dGl5SHJRYW8rNWVOaEhIeERKS0xGVlJSek13bU4r?=
 =?utf-8?B?TzFsQ3hYTjRkK0liQVpsUkRrcCt3ZFdZbHZSTDRoZzJaU05xQzdFQWpTODF5?=
 =?utf-8?B?eXZUSVFWZmJvMHdhcks3eExBZ010enFOQW1FVm10YnFsTDRaeWYzMHVnaVN5?=
 =?utf-8?B?eTl1Vi83WHN6RHh6OG1scU5GM2t0SHh2L2d6RGlVL0RybUkvanhKWmxrMWph?=
 =?utf-8?B?d1VpbklzcHU1bnZMclR2N0NSeVNmMVB6VTRLaEVTUjdheVhLbW1DRFZwVUM2?=
 =?utf-8?B?Q1A2Y2Y2KytDZUN0ZWlmdUNOL2lVck5XcklwMzl5T21MampuZDd2NGFURnNW?=
 =?utf-8?B?MTZuV3FJSnQwM0IvdmovQ283dGZObjhrWWlQQnZ2WExGSFp3S2pDY0lPcXJ0?=
 =?utf-8?B?MW9EUEcwWUpnam0rblFxWHBHYVh0SHF4TlByTUFtZVdjYWhZYzZmSmY5RUMz?=
 =?utf-8?B?WFVTdVlTREFoWkdNaC8yeHh0UTd3UlhqUGhnU1dqZUR6RVFvZXB3RFpzUzhz?=
 =?utf-8?B?bjJVc05xQWdHZXRCVGZ5R1JxRDZlTGt4WDN5Q0xvcEZtNWlSREJWeWRaQkxI?=
 =?utf-8?B?dVFlTVVXUUt4dEFmaVl3MVpPUStJbitEZWFFQmFpeS93bUxUSzRFeTcvcEcz?=
 =?utf-8?B?NTNGUCtGRkx5VHZVcnRpMlZFc3pUM1l0WnhZaDhkQnBkUDdiRlBRenkwN016?=
 =?utf-8?B?Q2l3S2RZT1pDWnJJWWJwT0tiSUJmQjNYRE9jMi9CUEl3VUpuVWVEeE41eEdX?=
 =?utf-8?B?MzREbzhyRjNpbnpnNlg5Y1RDZTYrMW4xSjRXbWZ4bEN6a0NOTWFyUkVGaWg4?=
 =?utf-8?B?UHR0cGZyZGJuVC9VY01sM0lNZzBxTjlaVnREWFJkcUNKZEdJejZoOGFFTnFM?=
 =?utf-8?B?a1QzUUpzN0MvRjRMMFZGdTFxSXRxY1dXVHV5ME5tQ2hpQVdLbzYzaU9rZ3pS?=
 =?utf-8?B?aWVVWGtDK3g4dG1peXRZQUxGV0JvMk9sSnM0V1BGN055VVVsVVpYbDRZWUto?=
 =?utf-8?B?L0VRS3pma0EvMTVxTmR0NzUya0pSbHpRbjZ6OFhOMHdkWnNhQlNCdXdxU24y?=
 =?utf-8?B?U0Nud0t0aUp2NmloZHJsdFdNQkUyRGJ3VnlQR0tmVHFFL21OOFRmZXFKVU1B?=
 =?utf-8?B?MzF0VTJjS05ZbzNKOVJpRkVkVTBCTDFqT0ZGT3dsTHU2MXVxM0ZzNlE2K2N6?=
 =?utf-8?B?VDdrK1lFeENoS3FFQlB1T1VHQ2pPSGR3SWJxaFYxb2x4SWM5T2JiTCtiV2F2?=
 =?utf-8?B?MjRQYWZWb2tEcDRsanFPbkJ6WDNxUzQ4UjlHd3JnNk5YNGd2Rnd2bnhiNG95?=
 =?utf-8?B?ODduWTNpNUNWVUFSS2dLUjJweWMrK2hkRTRhSkQ0VnpIRHcwbnF5blRPTXhM?=
 =?utf-8?B?djE3MkNyWFluLzl1OVZ1K01KM1lSWDMwNHNWUEZSYUdjK1NzVHJobmFoWDhm?=
 =?utf-8?B?NVd3ak9qRG9UM2xzOVhkSXBZYjhPRmlROFFYWmVSVmY3a24rWUxzbE9xQ3Nj?=
 =?utf-8?Q?IFr+pe1kVbCcbR9xcDMIEr2arRdlh8Uy?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGM0TmhzYkpUNDFlTWV0RDdpRkNRaGxzRElGSXNWVHAvNHRWdlV0UUdZcC83?=
 =?utf-8?B?MEZnaTJld1BaNHgxczFaRFlTNUV4QThLUWNuS0RWdTY2SkI2aU4zcGhKTTBi?=
 =?utf-8?B?Q0FoN1BsQkdEWUdOT1Ywa0pzZVhSdjZLUmxMbXFxdCtKdTN0N1FjRlV4UGFJ?=
 =?utf-8?B?WTNmT3BrSlo0UUNOOFY1Qzl6c0pxZ0FiV01OVXVvTlV4cGM1NjJLR2xZVFJQ?=
 =?utf-8?B?d2FNcS9NMGdtU0ZuU0RWZVNjakszclJnK0JtQnJQeEJoTVc2TFVFaXRFekps?=
 =?utf-8?B?UnJJTHg2aTFTa3VJdEtZdm1qVWx4TnhWK2RUWUtmWlA4QXh1eE9pWXVYNjlr?=
 =?utf-8?B?czN4cnpCcDhCV1lQRFVwRkt6MEtPZmxrYzlsczFEVjArZDRLUTRlZDJLOFJZ?=
 =?utf-8?B?V0VjQzJiUHQxOVg3QnM0clNGcXlvY0hWOVQzbHFNeFBXWVlKK09oYzZsdldN?=
 =?utf-8?B?bUM4UEp2MkFmYUpYUHIwVTlzUWRhdEJmaVFiTnN2OXVXZWlFNjBnZi95YkFX?=
 =?utf-8?B?VVVVcHllaVZZbHUxLzlNeXVuTlFEb25DZ2JFZEdyRXY4dzlGWkhRQVBEcDRi?=
 =?utf-8?B?cjdWTkxqK2FDQ0g4L09wbHZRR3BTOUVUN1RBeXM1WEZoYWZqS2FqZVVYMkNi?=
 =?utf-8?B?RkU4R3liaFNzeDNxRGYrVnNGeFNkL2FVbHFRY2o4NHg1Q2pWZUdWS3NWSWlN?=
 =?utf-8?B?ZEpqc2NvaTQ4Q2dVOWF5aVNvVXZFRWZmMXdyRGlmaFdqWXlGblNuWE1OVlZM?=
 =?utf-8?B?Uk1BTUU0UDV3WXVyQTUvY3BUVGtEK2ZqUDF6QWlVOExseU1KMGNzVnk4VnFG?=
 =?utf-8?B?ck9WOUNQUjJ4OGZVcjQyV0dBeFhBalNHK1orc3luR3dHeWFkZnAvYjJ2aHhr?=
 =?utf-8?B?SndsN1hLQ3JsdU8rYjFtSHBibTFQTXpPYzBJd2xPS0dQdldFcUc3cEhtUXJj?=
 =?utf-8?B?T244clg3UW91cm85MVJaY2l0am1QWlZ1L0VQZjZyYmtUTEIyb01WN3dLOE50?=
 =?utf-8?B?d3dkZGY5aGhKOXlvdVFPT1FOOFExT0tDVVB0MklObWJMNmlNWlRaUEFpd1Ey?=
 =?utf-8?B?NmFtRWVIS21LWFFMY0taZldJcXJEaHJhcFdtQXRQREtzbGZVVGNSOE1IRmdD?=
 =?utf-8?B?NnJveE55T1JXUXJqT0VQZFdzK0J3bXRsT2ZlVk51Z3hDSkk5TFF6WXFhK2NJ?=
 =?utf-8?B?NWoxOXlEcXJPV29sWTJQeUhwRlBrcVg1QWc5NkZkN1BzLy95am0zc21FajVr?=
 =?utf-8?B?Wm5INUlHTnd6d0gzSm12dnA1bjZra2JwT0s0RU9GN0ozcUsyNVV0Y2dHKzlI?=
 =?utf-8?B?WDViRVJhbkJDRmJHRzNIN0tHTGtqYjVFUStzTHpERjJQS3ZCajNhdFhBL3Z3?=
 =?utf-8?B?a0xyWVhOb05pNTVWRkswR3Y0czBXaHo1Sk91eStYUUJLUS93dGFCRXZnUUFI?=
 =?utf-8?B?cFpCb3Z1UzRUbmowNVdVOE9qVUM0TlV1VzZENmFXQi9KeTFsL2ZNSllnTFNI?=
 =?utf-8?B?RzNiWHA3WEUxRk5aeFVXMDhqckV3SGlTSkoyM01XanRGNW42STN6MnBaRVV4?=
 =?utf-8?B?SFNKc3JKUzJwQytoTUxpWFV6TTR0dkR6ZDlLa1g4d2o1a3kwTnVCaFYxQXlS?=
 =?utf-8?B?NVhBZldSYldrcUJlaFY4MW1GQ25tMFFrWE9ITFAvdWdnem9tVXp5eFJRNFAr?=
 =?utf-8?B?NWxGVWpYTjFBVkNNQTk2Wm1xVFQ4eW1LQXYzaEtQU0NmWHJ6Y1dwYzNINmxt?=
 =?utf-8?B?R3JaWkVaOE5YWStxbEh1Q0xyNXFkN0FvbEphM0tKRkd0Smwrek8rRHdsaXRx?=
 =?utf-8?B?SWViMEZFUVlLNk1ySkQ5cGRpVVFwK0J2QzU0NFJhbmVrRmxKTUp2R2l3RWQr?=
 =?utf-8?B?U2N4TjJjeElZOHlrMHNtRG4vdDk5TjV4RXUwSzhZTEVuTVBOOVZieUtrZ21k?=
 =?utf-8?B?eXZsWmkyK1FSZ041KytBaU56QW9YMjY4VnRjSHFzVTU1TlZ1WnpZb095T0Fn?=
 =?utf-8?B?c2dYQWVmZkVKWHdpSnFnNDNyYW82Q0xaU1ppcllNaCtGZmphM3hlT2NMcFU3?=
 =?utf-8?B?VEtiRWczZjE0ZEFQYkFKaEZrL1hpTVlzcHhubUVlaVloT3VHcjluN2RuUlJP?=
 =?utf-8?B?TjZ5ME9BekUxbCtsYlRyNEkyayttMnc1SGg5UHR5NUxFZGtyRjhKcEZaMU9S?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D37A9434A70F3A4D9D203C68BC939DDE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d953b69-5074-4045-e215-08dd4f145e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2025 05:31:46.1150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PuFIKL2701sdoPbDRSpldHww47y1lOtir/dBG2JEXEW3khwmUG6D6AvysUEeSSVsNXX0jiDWaIqh1IP+fuETkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7599

T24gRnJpLCAyMDI1LTAyLTE0IGF0IDE0OjQzIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IHVmc2hjZF9pc191ZnNfZGV2X2J1c3koKSwgdWZzaGNkX3By
aW50X2hvc3Rfc3RhdGUoKSBhbmQNCj4gdWZzaGNkX2VoX3RpbWVkX291dCgpIGFyZSB1c2VkIGlu
IGJvdGggbW9kZXMgKGxlZ2FjeSBtb2RlIGFuZCBNQ1ENCj4gbW9kZSkuDQo+IGhiYS0+b3V0c3Rh
bmRpbmdfcmVxcyBvbmx5IHJlcHJlc2VudHMgdGhlIG91dHN0YW5kaW5nIHJlcXVlc3RzIGluDQo+
IGxlZ2FjeQ0KPiBtb2RlLiBIZW5jZSwgY2hhbmdlIGhiYS0+b3V0c3RhbmRpbmdfcmVxcyBpbnRv
IHNjc2lfaG9zdF9idXN5KGhiYS0NCj4gPmhvc3QpDQo+IGluIHRoZXNlIGZ1bmN0aW9ucy4NCj4g
DQo+IEZpeGVzOiBlYWNiMTM5Yjc3ZmYgKCJzY3NpOiB1ZnM6IGNvcmU6IG1jcTogRW5hYmxlIG11
bHRpLWNpcmN1bGFyDQo+IHF1ZXVlIikNCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hl
IDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdh
bmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
