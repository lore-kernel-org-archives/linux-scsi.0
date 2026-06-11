Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6875A34D4DE
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 23:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781221533; cv=fail; b=Gp1OsasmovnV5WTs4uH12IIH666b37qfslAN++AGAQ4d4njg9YTfmSCrFcsyZhseWe1cFQd1OvgJeFokJ3VJNnz1T8qC2KG4PJnQFjq92bQ4n58AbV5Luq/89okgtC3GFv4Shn16l0fNONfiWWN50m+/eSA2ZZ8lR7UHnw74+cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781221533; c=relaxed/simple;
	bh=0NN5M26uUtDajELPipmUxIZtPGRR0iiKy6/gdV9tAiU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NAOlsPrfhTTWAZ/L11ASkmujXpzxSP1PzXVilTjmPD2aKAvFZUfvj4C48xvCkBCN4GNEhVvNhOCWucqASAJMpjWwsClbt4TI7KVNGu3HTG9gglZu+0au30Q686bYVRR/F2MAAnxnnzi+IZoqjNHvNMfzu5yc9U4099ZUkHVsylM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rAbecIcv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oTidParc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rAbecIcv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oTidParc"
X-UUID: 9b84b17265ef11f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0NN5M26uUtDajELPipmUxIZtPGRR0iiKy6/gdV9tAiU=;
	b=rAbecIcvgDaUIiOwJEYk203sQtXJzPW3AdkPRgUUHq1VOVDDgTSR/3POLswXD76xwSuWPygy/qbTwXopSrjW4x54EBnG4+WRSmOvb57yUG37EAzntUCBn5b7E2+AQAi6moSqBTTebPpj60i2o303l/BsXYMtBi8FFtR5UkQsdVY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:fa09519d-c79e-4010-ad55-2b9a548816d5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:08f4f8a4-9ef7-4489-861a-e83b251ece46,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9b84b17265ef11f18dc8c9802ae25ab1-20260612
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1559659669; Fri, 12 Jun 2026 07:45:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 07:45:19 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 07:45:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcEOORdko3PK9KUhIO1HE/Dgr0+WAERwNKnAm00ocboLsBVYEtSLVjDWJT0F5YD4bSmeeYcVLzBK+jSSxl5Dg7iefBX4VPadQTmZp4mmqyi0WS09ItOk5IdRf2QlI1sMoX4BDNZk2rt2K1HSqDYqRA8sP44OZ5LEXUczGo/Nlo07jk7VnHhcVCaAzt+54/iyg4tSWFYHhK777WtVj4vmBll2OIfaN6lEzLhR4ozSQe5XXoNZIUT7Pnuj/cM4qkd9wWiOm/QyYp/81o9vOHYDC8z/0MnXVFnC2yrzM9pYziHcMV8YoHBNqevDGdM2/WMeBRxU/SWSAf/ElFLFovJ19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NN5M26uUtDajELPipmUxIZtPGRR0iiKy6/gdV9tAiU=;
 b=Jad1tt0fwSp6hTxFthcDhsz6cJGbolJo8zxY+HQZA7Gp3VVx3vXtbixjZpjiGwXslu5GWPJDzec6DoRHUf888bZ55cxrl6HRPgY3PbcPbU33kELTwlbjvTtB0bzTibQFUCGq0akB6GrSORO3kkmVCNy+0W1ZSjneD+2fOqhzdg+9YL0ilSr3TMSi6cfGXvPLJZ5ZfWBHpYJZ9ifhU+nFBoN0Io3B6xGCM4Ec0dTLErpUNQDB53tlyyDiQNs5sEvVJgXk7dLsLPByGishon948ktyzEHjrATImHi5Sg+TNVsFFkmDE46BNBSt8VkNrJNib8tNIrls+Pz/mTUQ4TSiuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NN5M26uUtDajELPipmUxIZtPGRR0iiKy6/gdV9tAiU=;
 b=oTidParcuRars/fQVcvmFKTQrCtM+HUqO+IR1PBBvh6jBVZWI+WkTi5k0sji8gTcOh7XDQ1svWOUje8InUNhwBvNIpBdDOhsyq2rRt3njge7fKWMu8ArHPo3VHy3lK6ro81hFFhP3vRELq0uz325/iBymVBsjX/fEIxnm8Z1V9E=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYZPR03MB6447.apcprd03.prod.outlook.com (2603:1096:400:1cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Thu, 11 Jun
 2026 23:45:16 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 23:45:16 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ufs: core: Remove max_num_rtt field from
 ufs_hba_variant_ops
Thread-Topic: [PATCH v2 3/3] ufs: core: Remove max_num_rtt field from
 ufs_hba_variant_ops
Thread-Index: AQHc+fnQAsVGPswchUyJiOHc0Vx9rbY6AY6AgAADMQA=
Date: Thu, 11 Jun 2026 23:45:16 +0000
Message-ID: <ad34cb0527688ed0eba7040606a71d52641c155a.camel@mediatek.com>
References: <20260611232632.2324422-4-ed.tsai@mediatek.com>
	 <20260611233350.199321F000E9@smtp.kernel.org>
In-Reply-To: <20260611233350.199321F000E9@smtp.kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYZPR03MB6447:EE_
x-ms-office365-filtering-correlation-id: 43e4767a-e750-4f3a-9d5f-08dec8137d6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|6133799003|11063799006|4143699003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: 4NmGNbM8KGaJN/zjFJTwXiTIF3sLNtBGGsErp1hcakOZo7kLMqzQDdsfD0uMrNn9o9lw85u1q5bDNKrEZVJ1HC4vUsWTtchTBB1cRn51OjBlotOq2uWbcgCjvatr+OdKhKkfIQEgl4GZcxO/PoQyapmw8wz7LIYRgaLAibx3FBQf7Duo0fuIaLSV5gVNqhmsRa5NRgLBCkdZOLXAzo1m7/DxtDaMEQ2gXVUVHTdF06fHmGuGh12Pdc32IuQ6oqSL2oHrMW2Rc4Q/o1A4dEDx7gKHto9G2lNOYoa0NTtypGSkXl4CyQcfWcjbT4AirGKqcObH/xXtisH6aRUDujimb16y9TyKekM+wja0UaGsjf77qYxSWsGqCR11+YO0KjJlRORCjhT4a61SsojQ2IE5rXe7qniN7pLBA5Msq9FvD1DEaNUk9WaQCC+uQW/G64ogWCtrclCwCTaeSTsxeDx0M1zroE1SDKJeF+48QZWFUTrl5KCvaxHdB25Jlj+4a8ccy7oEFBH6wyAYp/NW/YBNaBV0p3dYK+LtLTOYmMSWTrL2oStJ9eopZXZZ1HzaUO6ph2fy88CgPQIKAgdOdIldj2Gth35b6NGJiC3aetdH7MhfU/pTG4nDvvMwZAalu6taXlfK+VN4vqeYqX+e63X1d8AX70ldJcQVS6JBA79yGI9SMdlNv+50TpxjkmQRX/cwuCyFIyT2DTeMtrk45iitdCsqQy4PlcpkjwUvUwsVHDvheIoJPLqaBNyXRh5J/F3r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(6133799003)(11063799006)(4143699003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmFVVjhuSC93bFhkR3Ribk5rRFA4YnBxcnBlNjZyNEFML0F0UE9aUis1U1d1?=
 =?utf-8?B?K0FCbFBpSVphblpxVzJlQXFoN2FHM1JYZTMrcXFrTGR3NHVIcllpL3dHS3RS?=
 =?utf-8?B?Zi9HZE5YVnBydU5td1RQVVlLTzY1czErK291akZma2wxdVk5K2h2RllFT09I?=
 =?utf-8?B?SUJMcmJsd2RSc3FkbTNlR1lMNWtsbzk2enU1cjA0aXgvaVU0anM0S1ZuM2dX?=
 =?utf-8?B?ZDhpT0dKWk9LYSszQ2loSm9lekxZclJEOThxT2tMK2JraHpRMnliWGlJOXox?=
 =?utf-8?B?ZU1RRXYxejM4RUluNHB5T09ucm5GSmYwc3AveWVaZjBYYnFFamFhM2hJM3pW?=
 =?utf-8?B?WXlYNFpTY2dnMHN1V2x6aktoOUJWQWloVk51VC9qMEJGQ2xGNkZkTUwwNUNy?=
 =?utf-8?B?WDl0UDNhRzNTQ1FJSHFRZFJsMktQcVhSRldlN0RIYnZzMG9QNnpnejhETktF?=
 =?utf-8?B?QkNkN1J0MG5YT25HU2VPbVlxcTl5NjZrNFVaSjh3NVlpeVNEcFo1Nm15RlFz?=
 =?utf-8?B?SjZGdlpkb2UwclZRVXg0TGxlR1h6QkpiTEE4OXlVOHJsNlUyS2NQc3pYNnNQ?=
 =?utf-8?B?WVdmZWtHYTJUeU5WcTF3ZDNkOVJUY3crSUEvaDFPekpXcm5WSWJWQmVlM2xa?=
 =?utf-8?B?U1BoN1gwbVlLVHgwZVUwQ2tIYzgvOVIxblhRd3FHb2hWUUp2dVZlT0x6N1J6?=
 =?utf-8?B?QTZNZGorWHlUdUxHYXlXcXBSdGtMSE5VVnNtSmU2RHROZWRtZ1BiTEVSVm1W?=
 =?utf-8?B?Qk9RWDBPV2VmczRJS0dqdHBPR214eFVIREgwVHFzK0pFNkdRc3F1dGg1cW43?=
 =?utf-8?B?VVovZW9WK05tTC9DOGFDWSt4ZHRyU3FLUDgwLzdMYkJZd2JlMHd0cUtyYkFs?=
 =?utf-8?B?YlVxdm95YjRtMXJWU2Z0dDliSEhmK3g4Y0tlM3FHcFFpQWwrS3RnWm1odHBB?=
 =?utf-8?B?Tm1uOUUrM0xPUlZhdU1jMkR1ckN5akszdHB2T2RBa1FyUXZ4dXc1NTFFY3pP?=
 =?utf-8?B?NDF4djhGMWRUQlp4dlVYa3JwMzlWQWMzaTVVZ1haQWNvK1BjMGduN0hyd3Ev?=
 =?utf-8?B?ZE0rY1lTby9MNXNBcExJdmZQTmY0c0FnbjlxbHJHYzlDdlRtQjNMTEh3anQ2?=
 =?utf-8?B?aDNSald0VTg3YTJxSmVwOXlQeDhseXpKOUdjQVFyUU5BNm8vUUw1MWFqbEJx?=
 =?utf-8?B?UzMyUVpydnRlNWI4TnlXd2NySmNTNHplOGdTL0Y5NWltWnJkMk05RE9mZVoz?=
 =?utf-8?B?REdzNTFuSjlhb0VvZEZKZHhMVlMyQzJYbit2NEhyaXRvQ0g0OEMzT2QwNWdr?=
 =?utf-8?B?b2NvYUtIUE9KZkQ0cjlRVFBmNlNJZVhKQ2FoYU1hVVFJbDg5MEJlZE9RSUR6?=
 =?utf-8?B?ZVlRUlRkOGlYZVRudHBQcEtWQ0x5TngrUXUxZzhuZ3JXSGtCemluZmJhZTZ6?=
 =?utf-8?B?bDVEVjNCaGZUSXF2dXhhL3NZZXpjNktRNGhpNmNqdzYrLzBmVnRiUFlhSEFE?=
 =?utf-8?B?cjZtdjhNalRLOG9aL2w1S1NoNVNjZEd4b3NqLy90RVNYSWNEUlh2QlhUS3Za?=
 =?utf-8?B?b1RPSi82U3p4VFVZYW8zK2Y2NC9Wdkx5cVVMeXYyTFJoektKTFhPd1V4dm8r?=
 =?utf-8?B?VHFDcGpqVURIaW15S0JLZW9LY25pSDhkNVQrajFlcVRzaHkvaGFqcy9hbGhz?=
 =?utf-8?B?SzN3ZExEWGJxdTc1TU1QRHphQWgzNTg2R1p3azMrbmdhTUtXUnpzdlVqcWxa?=
 =?utf-8?B?bERuZThjOWZvTXlsamtkKzRrcDcwTEpYVVBXKy9pcDFEV0xaNzFpMmZUYjJX?=
 =?utf-8?B?ZnRCTzdnbmI3eHVkMXBqRnJwQkZiRzYvSGdxTnJCRVJBZXRwVHU0ZXIrdE8x?=
 =?utf-8?B?dXM0bUZIdWFTTktoVlZwUTdiWlVuaHVhbXJwY0NBTW5tdG8yencxYzhBL3JI?=
 =?utf-8?B?cS81M1JzQ0dobUFHMHozQnkrZWI2ZjN5T2ROQzBWQ0J3emV3aVNEQVQyQith?=
 =?utf-8?B?VnpVK1phdWVRWHNCSjl0WmhPZ3JpMHJFbWNtVkExNy9uVS95cXBNUmJoSzU3?=
 =?utf-8?B?VFk4VXYxVENUU2NjZFVTT2xaNGEyNzNCZGUvVGhSQUNOM0txNmVqT3hCSVR5?=
 =?utf-8?B?bmw2L1UxK3lZUDZpQ254R3dTVjk5U1ZsWHlLQytJdFpROVdDQS80OGVVUThO?=
 =?utf-8?B?R29ZWU1lZnlWdTdwd2dBbjVMdzRTbXRHbmd6SUVQcXdqRUxIcm5rUVRtaTFa?=
 =?utf-8?B?OStyUmxNL3I2bU5CbTMxNWFYRGlmdjdHaDErVG9zT2RzUVgyVGxhbXdQNVFj?=
 =?utf-8?B?SGJMQ0d0dnZ4dXJNUk9LSFF5a3haL0x2a0IrbjMwZ1NoMmhPeXZiQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE60D1963F9FC148A3838643505467C9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: UehX8MrVCmq01TYrEu7QsdMOA2M2s4DKMsjHuKM793iorsNjq7U6pK1DytcEfqasQYfOsD6/4jskwHgsjwHevXlvHhyX4ZR1Jiky5YmamG1gWEsSczGcbZ7QzDBdGMeh7uWsJrldAXGMR5Q7IY+tL90Cu7+rLSFBFS33jbYPgrbniCWwtosPsfnlwbTNNT50JHG/dJd05l8kFEoCAvWJsiCubKrzGqybqEs2JJzMGetd7ymDO5eOT9bFEj7XyDzZm8OdWGx6rW8hOXZQ5j1X3Ew4N8bX4+CINMPQ4mp209FWh96pnU3R9dqfcAKjh4Q1chGx2KVMwcHfNdSF36+2IA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e4767a-e750-4f3a-9d5f-08dec8137d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2026 23:45:16.7139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNh1TWqFxBSa5Ul7z29K9ayC5oFE+UvZfHU577VUjWyM1/ybEhA7VwPTqLW3Btxv46bNWJjslbBKEYyWBQITqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6447
X-MTK: N

T24gVGh1LCAyMDI2LTA2LTExIGF0IDIzOjMzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gVGhlIGNvbW1pdCBtZXNzYWdlIHN0YXRl
cyB0aGUgbWF4X251bV9ydHQgZmllbGQgaXMgcmVtb3ZlZCBmcm9tDQo+IHVmc19oYmFfdmFyaWFu
dF9vcHMsIGJ1dCB0aGlzIGh1bmsgb25seSByZW1vdmVzIGl0cyBrZXJuZWxkb2MNCj4gY29tbWVu
dC4NCj4gDQo+IERpZCB0aGlzIG1pc3MgcmVtb3ZpbmcgdGhlIGFjdHVhbCBtYXhfbnVtX3J0dCBm
aWVsZCBmdXJ0aGVyIGRvd24gaW4NCj4gaW5jbHVkZS91ZnMvdWZzaGNkLmggaW5zaWRlIHN0cnVj
dCB1ZnNfaGJhX3ZhcmlhbnRfb3BzPw0KPiANCj4gwqDCoMKgIGNvbnN0IGNoYXIgKm5hbWU7DQo+
IMKgwqDCoCBpbnTCoMKgwqAgbWF4X251bV9ydHQ7DQo+IMKgwqDCoCBpbnTCoMKgwqAgKCppbml0
KShzdHJ1Y3QgdWZzX2hiYSAqKTsNCj4gDQo+IExlYXZpbmcgdGhlIGZpZWxkIGJlaGluZCBhcyBk
ZWFkIGNvZGUgd2l0aG91dCBhIGtlcm5lbGRvYyBjb21tZW50DQo+IG1pZ2h0DQo+IHRyaWdnZXIg
YSBrZXJuZWxkb2Mgd2FybmluZy4NCj4gDQoNClNvcnJ5LCB0aGlzIGlzIHdyb25nIHZlcnNpb24u
IEkgd2lsbCByZS1zZW5kIGEgbmV3IHZlcnNpb24gYWJvdXQgdGhpcw0Kd2FybmluZy4NCg==
