Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687E12EB84E
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 07:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778744104; cv=fail; b=Zmey+542SYLiDbfn4mOnXDB1Q5c/IWmT2IT5B1byP1FgV/UzkERUm0xuwSJeCgVg5k7UWa2ffWR3Cs8QcD+sSjUtx4e50DP1q4lDJOO62oWZ7KxfZME9daaXYJkDsMiaT+XaR+UvrH+hcpp1lTRzsdzygEKP8QhzVlouef+Z5rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778744104; c=relaxed/simple;
	bh=dmI0MnUD1YChxdbgWer3e66SwfmS4A0VmQDSgg9TtiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VCZWs+4JUJZlAtQqMJUv0XIX0YMBaltT6p/AihhGyzGNFrZQrcsMzKXDHoGM8Oj9pA0OhmWnQG9yB/iVw7aMmpDcokMq0x13AawIa3+pwzYK9JlUsueFowgRPfFFCgBlbcZ2BNDQSVp7LXuRZ90I8yShKqS1m+ukMeMJ2r9oT08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Opt0MxWx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vUtXm4Qg; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Opt0MxWx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vUtXm4Qg"
X-UUID: 62d8cc9e4f6711f1a3561939bc42ff46-20260514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=dmI0MnUD1YChxdbgWer3e66SwfmS4A0VmQDSgg9TtiQ=;
	b=Opt0MxWxvL2bVV+oD2hMIw22c3F3+evJW6OKzPFjSUM34VEjnCYn78UP9V6yD1MiDk5d/tzpNuZrycidIqcjaXimWXAALKwvFHHyh5bTMjndNYtWNOpCJLzCMOa+3CGFnK3MzlcpPwmc7b0z9Fvhaodr8SjcYi/wqVZAuZQPBTs=;
X-CID-CACHE: Type:Local,Time:202605141534+08,HitQuantity:3
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:5721e5f8-0fc8-4142-ab4b-455c659c6c51,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:f36115f6-8c44-46d7-a1ca-a9bdc4d4a626,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 62d8cc9e4f6711f1a3561939bc42ff46-20260514
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1869315127; Thu, 14 May 2026 15:34:48 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 14 May 2026 15:34:47 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 14 May 2026 15:34:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOz/Fhfq0uGNrjLdobbr/fmPGQJzRHf3KGIQ08YyYlmowy2nIeCvKQXyxbBT6gu5znaZHF9vzT5ykRIolk6vuHyM9pxWKR+8OkC2U6p8X6ud11DavPj76qGOMN0JDgzBb8+coy0RpXiysccR/9CdlX21qBSNDkxdtUMPXsGOqd4z3EKb4kMMQYDgy73cNrGJsCOyROo5RO77686fRbOT9JXJKXhBx/IEHJ0scpBQsbIkKRUyRqiFKuJFOJInW6cbLRCk9OyRhsFttzaDXLYa7HadXemXVLcZzLCwzydyZsWcLIKJ45T9rVsdHsH1iQ7fitYE4rzocSRfejY5H/NZVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmI0MnUD1YChxdbgWer3e66SwfmS4A0VmQDSgg9TtiQ=;
 b=KGK6k69+o3NFbFpqCBM0Pk7ZKM+woa1x4B8kCO+t2uHzVsVAc32jpbyitQoTzwnTK26aZXdD342cbYrqvaAvCcSRh1hNUuopV4WmdZm9F6BEI/1eE5KnIrZftU8fo8dMd+9LOxZ5fcBGxTdHtdrQY46C0zQRKEISW8XzcLt6Qem6MXyS9+CdZ9BMBQ5yvZ9IblpOfKDTyuz1M8mSIG0CqXQXDdKcsRZ0TUPDhuwZxUvQrTARboLqAsk4w2tso2VH1aHbiTe+dgQVFFLN0zW69/+VGd2/L2jS9L8iE91fjFwu+VdD190MWBLnMJowT+/HsG4WRo2fmOg7ksFaspSLDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmI0MnUD1YChxdbgWer3e66SwfmS4A0VmQDSgg9TtiQ=;
 b=vUtXm4QgPyA1t7B6OIAthH2MtSpsrhLjcgw/lXFwnY2d2OXp1SwSo/QUmiPk2umZ8/8BjZ5hWgmhBK7aFcmDzFuYs/s6crL6PoLy1mu73g74O/uaN9pnacQKwVz3UAN0Z4x1nEbSViLrZtqZWE2tkl9F4j78gA+Yc3nyKzmDs50=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE3PR03MB9377.apcprd03.prod.outlook.com (2603:1096:101:2e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Thu, 14 May
 2026 07:34:44 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0025.012; Thu, 14 May 2026
 07:34:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chenyuan0y@gmail.com" <chenyuan0y@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "ping.gao@samsung.com"
	<ping.gao@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
Thread-Topic: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
Thread-Index: AQHcwsRHjzi+tuh9QUq8azIMBSL1hLYLxCQAgADTFACAAMuBAA==
Date: Thu, 14 May 2026 07:34:43 +0000
Message-ID: <23d57dd91882a3014c0d97a7b08b81117ade5b72.camel@mediatek.com>
References: <20260402171404.3008494-1-bvanassche@acm.org>
	 <20260402171404.3008494-2-bvanassche@acm.org>
	 <459ba5ca0f24ce49fd7de7ae6e014588f40e2445.camel@mediatek.com>
	 <d81c6987-6f76-4391-a713-96bbde4efc8d@acm.org>
In-Reply-To: <d81c6987-6f76-4391-a713-96bbde4efc8d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE3PR03MB9377:EE_
x-ms-office365-filtering-correlation-id: 5b279e13-7954-42c1-d9d9-08deb18b4445
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|18002099003|56012099003|11063799003|4143699003|22082099003;
x-microsoft-antispam-message-info: 75jFrXOFVUKF7wZpvBcAaHlynMK+UiJYJLWuGMhrZQ9/OAri04MO25o9vZ6QGYBgq+sTHfr5UzgP62AHGg/z96LigOnmU0W0uk0t8b4C4JWGaOKVeXt9l2kswJY5YlllJIj2PRtd5O4QwqLxKebkHV2x0fP0IqLeW6eJJEteEewAdM7oW5mx+Ns5mChFn3LtClgO0yO9KILLLRrTQQzTKRptApcriYGrCmXRMz0YWvk7bI64xWBxZLqBR1FOAJ5vU1xPgjD2QCWihfvnTGlg+RFhmtDYxl2ZxBZjwsAFtMBFXoDtpD8HB0RJ0ZSsYmdcnecFM8Ji7v/bX5FzIfxK5Fa38RVlmYlHn+0Y+v72WBIaafaQRZes8seSgTWUR6PTaHlLMGv++IaK7QMyyqquCs5HECtA579GKrdqy1TonCmX9WcdaFfxS86UalXku4lq6aEkIVSWyCpm1H9XJ+214BEQrGiFUXoaf7j0lj0dzAMkHmyQnDyhLLhGCgDJbqSw1bU5CmKI3cAgYQbKR55uKvjqap9CygfeZ0JxQWcfT7u3zuRo+fLIncAbTf2THTqlXyqPQHuPI88M2fp7GVm0o6m6mYJJGIgZceCH19rgE0M3JJBudVVfct80orpH+KAPsfFSKXy67ymZn2r/yZXdWEoiv6pB6gnUrOdt1t4hjMqcyR3W43zvE4E6bYE5sODRjXuY7GJzCUCUABTJgz3tGKObyCHoNZ0+7+V4ilRSHN45gbKM0pcic3O2EXoxYNeT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(18002099003)(56012099003)(11063799003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0FVTENtODArcTAyY3l4VzNIZGtmbmtkRVNWcWFaRWg4b1NuYS9ack16WWh4?=
 =?utf-8?B?azZaZ3FwNW5XajdZM3Z3VkVLb3NBdFlkSE51S2tSNUtJbkNORzREalZWQ3RF?=
 =?utf-8?B?MXRDSnVndlBqRGtZUkZHd2J1RTR1R3kzejZnbjlWMFM0R0tOSDBFa0pyQ0RY?=
 =?utf-8?B?NDhjVERPanEvRHhMNDhSZ05Xd2NrSGRZemhxaWlPYUtUT1FTb3lIbDE5V1dR?=
 =?utf-8?B?OUJQMHZGdFo2ZXlCd1plMzJ4aFRmTEJkYjVHYXFLOGwvZ0J0OGFvNmdqZm5J?=
 =?utf-8?B?ZEMra1hvQjd3WlJya1h5aFdIcVVMeWlWK1UyVTBwQjBKRFV2VmE0RU5iM3A1?=
 =?utf-8?B?aHlvbW9EVnRLSU1YZkErejJXTXNZK0svaWZHVVNMOEpvalJ4VXhGanhwakJm?=
 =?utf-8?B?ejNRRzdtbWswUmQ3d2N3WTlmbWZxTHM2TCtGNElsYnNPVlJqc0NyMUpLVWxV?=
 =?utf-8?B?NDkzYnF3eG81RzNqTGFBdWhSYTkzQ0JCYjB4RkhyUXdVbVliWmFlcklaV0Na?=
 =?utf-8?B?eG1hblpNSktpQmhQamhlWTNtK3FPQ2xaOVk3TC9oZ2lJMWVDMk1QdElEQ2dS?=
 =?utf-8?B?d3pHT0pOY3Z1cU9qNFRvTnJLM3RzVHpWYThCaG1VUXRlanplUWJtNnJzSSsx?=
 =?utf-8?B?dllxYTFtM1JnVEkxanRiRHNIQmV2cGJybjZpaExIMEdhQ2NtYkcyekQ2dnZj?=
 =?utf-8?B?Z2Rra1dQWkJZTkZHWDNPR0RsOEY3RVgvTldHMnlnV2F6ZHFyMGhMME9mSXlu?=
 =?utf-8?B?eXBydVdER2JSblFPZXZObWRkK0c5aTg1YWFHRTJlaWN0OE9kYjlGQ3l5WG51?=
 =?utf-8?B?ZHJyc0Z1eDNhQitQTS8yUTM2YXo0YnpuczcyVSszSnBTR1pNMXcvTEEzYXF5?=
 =?utf-8?B?ZWwyd1Q5RVZrZGw3L043M0hIb3pnT3Boak81V0k3RVlVMG5rMDVENE4yWStX?=
 =?utf-8?B?N1cwanc3UUtXdEZRclpHVDZzUEVVVTVMLy9USVdtZ085b1hhK0hycW1lZ1dS?=
 =?utf-8?B?WS9LdVVkTjQ1cUo3TGU4clk5N1JQQlRIU0FKOUlCREFqLytWT25Wd041bXFz?=
 =?utf-8?B?R2lWWDVZYWNWSk9NcmVtT0VSL1NDVlZ6RnA4SHZoZWJicnB4c1FIQjNVb3BR?=
 =?utf-8?B?WmxjWXJhdkNwQlM4TE9hN0FXYjVUeC9hdG1pM0pTUktHampjTVFlNjYzTDM4?=
 =?utf-8?B?U0hxWHoyNWNYa1lBa2tvdXprRmNBeHpQNEdBUWd5ZXRFMDN6dE5zOUNLbGZI?=
 =?utf-8?B?QjROek00RnVuRWVvRTJ5RW9Cb0EwdXJPMkNQNkgzaVJPbm40OEJvd0htK2FR?=
 =?utf-8?B?SUhrYkpQUDdVdUhEeHBxdTFxdWppTll0bFNKd1MvcHZ2L3VKVGpwTHJ0TDRJ?=
 =?utf-8?B?RHB4R0cweGp5K1E0L3YrYWVVakYxSmdjT0NzeFl3WHNXd21Ic1RuMDJkYXZ5?=
 =?utf-8?B?cDlVSWNzTlpCRnQ4aGVGMlUwcmJFWDRsQjRBZk5NNHNzcVB4cHJaQVgySXB5?=
 =?utf-8?B?bUVoREUxc0RXMHVweU15VjdwYWhQZkhwZ1BnSUFpekJzTGtib2ZLMmVUeTFY?=
 =?utf-8?B?TXB0RGhqRE5iLzdqd2FmQkdsV1k1aGNpYjFSYXJ4aDRKaDcrT1FPNGJNNTdv?=
 =?utf-8?B?TXFwaWc2cVp2ZksweTVXMXVhK0U2QUxQcXIvRDhTTXBrNm9rbjhiL3Nra2k0?=
 =?utf-8?B?aFF4N2kzenlFbjZkaERaZzFaV2huRzlWd1dxMGd3Rzd3bUtETnRQY08xRTlR?=
 =?utf-8?B?cTB0N2VWNlJMNGEzdDJZa3hlQzdxSzlJVThhTTVuNzlWL1lldEx0Rng2SDRy?=
 =?utf-8?B?U2F2aEVUYVBMUW52RU5vREFydytia3Z0bGt6K0Fxd2FqWjNOd2JmdDA5L1hQ?=
 =?utf-8?B?aDUrUW4vdW95SllWQUdmdDRrTVJSVTV1UlhJYjhXMks0TW1peDJyVDJqa2Ns?=
 =?utf-8?B?MWhNeW44d2RlQTRlVWswcnNGRnZMSE9uWUsrcTJ1VzBHMTFzaHdNVy9wT2tE?=
 =?utf-8?B?VnpLWWNtNStlU0lKM0g5VDNpdzFZRlB6Q0Q3NTQ1T2dJd25ld3RZczJUY2VM?=
 =?utf-8?B?KyszZlRvYzJDb0hheUF1c2R0ZnZZN0hrUkU2Yzc3ZVlSRlRRUE1GZ2RrWmlw?=
 =?utf-8?B?YTdwWVRPQXVVelcva2EvTk5oRDlSck5xWnhyTUx1Z29MYjVQL1RqS2NBejl5?=
 =?utf-8?B?cW02TVBuOGp2NnY5YjZkb0xLem85OGk4MHFRUWwya24wbTIzaWQ2V3NSOW5O?=
 =?utf-8?B?aFk5VENOczhZWUFJUzVyYkZmZ0d1dzJzK1Y2cHJtTS9YaUowSE83OWhmQkky?=
 =?utf-8?B?WDd1dllFQ0NrcUtQUFVLSENXc1F5Lys4VHp2OHBvWmcxYzBHVFVoQ0daTVU5?=
 =?utf-8?Q?n7wOK+VGqn7z9QQM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41E95720FF0F4745B29EE7A74F80928C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: UBk5UqQQNojsbzkn0AMxexsmrFGKQzSiWumF6m6BySsvMcgwbTIBed1SZ489mUN4p/DH2XOu3VrnuqTHarS5gD10OG6jzRlPYydwhofXepi25BPG7bdY8b8tk+mNJ7otZ4j+jnodda/aL1c129b1URAIwau8JXiF8a9PpM2uVHw7qlfU9T86aYYBT3UIOscbQZLEXCof9DSB8QqwTqhCkecSI3fviRFMaLvbfTu+F7do0KNwo/+9ieAwXxRqwvedRF+5NhLpuqxJ3gQWMZOdWT/qRc4oxU6kuzE9dkah/eOknRD3ewExzd+nSpJE+VosB+DToHxcIODcIH4c8WsOsA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b279e13-7954-42c1-d9d9-08deb18b4445
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2026 07:34:43.6829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IFvdcuQsPcDH4O3yeXxUgzp1PAgj+jfXATVC7jjRK+OpKnkm2MsyQ2IbF22UYyutQwvR+UU70LAt3qucV8XYtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB9377
X-MTK: N

T24gV2VkLCAyMDI2LTA1LTEzIGF0IDEyOjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDUvMTIvMjYgMTE6NTAgUE0sIFBldGVyIFdhbmcgKOeOi+S/oeWPiykgd3JvdGU6DQo+
ID4gTWF5IEkgYXNrIGlmIHlvdSBoYXZlIGFueSBwbGFucyB0byBjb250aW51ZSB1cHN0cmVhbWlu
ZyB0aGlzIHBhdGNoDQo+ID4gaW4gdGhlIGZ1dHVyZT8NCj4gDQo+IEhpIFBldGVyLA0KPiANCj4g
QWZ0ZXIgSSBwb3N0ZWQgdGhpcyBwYXRjaCBzZXJpZXMgSSBsZWFybmVkIHRoYXQgZXZlbiBwcm9j
ZXNzaW5nIGENCj4gc2luZ2xlDQo+IGNvbXBsZXRpb24gY2FuIGNhdXNlIGludGVycnVwdHMgdG8g
YmUgZGlzYWJsZWQgZm9yIHRvbyBsb25nLiBJIHRoaW5rDQo+IHRoZQ0KPiByb290IGNhdXNlIGlz
IGluIEYyRlMgKGYyZnNfd3JpdGVfZW5kX2lvKCkpLiBJIGhhdmUgcmVwb3J0ZWQgdGhpcyB0bw0K
PiB0aGUNCj4gRjJGUyB0ZWFtIGFuZCBJJ20gd2FpdGluZyBmb3IgdGhlaXIgZmVlZGJhY2suIEFm
dGVyIEYyRlMgaGFzIGJlZW4NCj4gaW1wcm92ZWQgSSB3aWxsIHJlcGVhdCBteSBtZWFzdXJlbWVu
dHMgYW5kIHJlZHVjZSB0aGUgbnVtYmVyIG9mDQo+IGNvbXBsZXRpb25zIHByb2Nlc3NlZCBpbiBp
bnRlcnJ1cHQgY29udGV4dCBpZiB0aGF0IGlzIHN0aWxsDQo+IG5lY2Vzc2FyeS4NCj4gDQo+IFRo
YW5rcywNCj4gDQo+IEJhcnQuDQoNCg0KSGkgQmFydCwNCg0KSSdtIHN1cmUgd2UncmUgZmFjaW5n
IHRoZSBzYW1lIGlzc3VlLiBGMkZTIGhvb2tzIGEgaGVhdnkgZnVuY3Rpb24NCmluIHRoZSBVRlMg
SVNSIGNhbGxiYWNrLiBIb3dldmVyLCB0aGUgVUZTIElTUiBzdGlsbCBjYW5ub3QgYWNxdWlyZQ0K
dGhlIHNwaW5sb2NrIGFuZCBleGVjdXRlcyBhbiB1bmtub3duIHRhc2sgdGhhdCBkaXNhYmxlcyBJ
UlFzLCANCnRoZSBkdXJhdGlvbiBvZiB3aGljaCBpcyBjb250cm9sbGVkIGJ5IEYyRlMuIA0KSSBw
bGFuIHRvIGZpbmUtdHVuZSB0aGlzIGJ5IHBvc3RpbmcgYW5vdGhlciBwYXRjaC4NCg0KVGhhbmtz
Lg0KUGV0ZXINCg0KDQoNCg==
