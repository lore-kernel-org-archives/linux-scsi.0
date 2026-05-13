Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C123D523E
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 06:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778655072; cv=fail; b=jMsMYkUkkNiVHq1VVSnrBHDBie6IQoKNbJzR3GtglN0Vtn00AnWBQDovrNSJbqUcrqvULQw5HaHs6r6gUf6AA41WJdUKb0nREvaF6x6lvVtlJ5OkKaIUCdUBpQTdQE1QlkK0SnQam53c+cPqiGUdteXZvwOSg+VyJsFOJguYOOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778655072; c=relaxed/simple;
	bh=7TVAwCJbr8A9hD/CDP+rDuHH8HHR84H0z9+RYmTFBTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aLiEJkmdXSfUraxlLZNVJcCMViHhGVfMe+bAF3Yyit9O5p+sH1rgiPIOQSuXZ6JUPukbqwWRPrEAo2NsW19tn8WdqXObAKUcB86iBh/8jngT6iLksSr+8jIkL8v3BSRle+D575pzbx9th/aSOFrRBkHyOEpayp8DVuMJmrpUABc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fHhskTLx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=O02qpqlm; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fHhskTLx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="O02qpqlm"
X-UUID: 18a0f2024e9811f1a3561939bc42ff46-20260513
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7TVAwCJbr8A9hD/CDP+rDuHH8HHR84H0z9+RYmTFBTs=;
	b=fHhskTLx6hdDkjJYKPS6ZFJqxOdNDTe7Rq9sQb2mQvi/k4lTuiXPrspLMd/zugKLzkyM3bhVVx+RcVjo1JJJgUzj7W9cqByrriO/IwQAm/70snMnpqwTGDffG7MndkTiY8/AA6poJZVPG4VzJ6odqaeEYE3omCysCW1P11bJukA=;
X-CID-CACHE: Type:Local,Time:202605131450+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:8a25c136-6cd0-45f3-aba4-01129dcef220,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:c5d8c443-11c5-46fd-96b8-8ddde212c99a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 18a0f2024e9811f1a3561939bc42ff46-20260513
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 431141270; Wed, 13 May 2026 14:50:58 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 13 May 2026 14:50:56 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 13 May 2026 14:50:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZDEbGAvStPWTqKIB3z6QmGZGv33nRzuiN2/4DrJqIzxY/mO5+NasnCdmcNrZ+lx9mU0AA0ir5g4DedQ/PBJ+Aaq+DKCSyXhgCXxSpim67utMhRHxdtZ6D2kAf7Td/HIkcIcvWjQTijLB20LA+ECoAQBQVQzlWwOdndKr30Pg0giUVFyhongAyesEX/zv8qPNDZErelqu6z2K37nuXRvItq2LICwFrSi4uiwy0oWkewZc3niX18XHv4Lden/KxtIJlz60Q3qXuQu4zne2AjslmpAOfRlI/xJlLBgw7/e/xHP4us+MS/7XUQg0CvcdeS7mYSIcQGtB6zJrZYACBpnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TVAwCJbr8A9hD/CDP+rDuHH8HHR84H0z9+RYmTFBTs=;
 b=GEBKF70lhONra8Z688IjYUTaLx8a3NIvN88iJRIit0OAuvOcCfCEHssqxeo7ColsofYR1ZpkDtBygSGaDZIwvmT6G+GoH0qhUBsifX2fofU4gIiUbK7zN7qRg9cyZ60/qFYWE+Oz2Cr6n79mOrEtoHdjy+Wr6J/fso8enEPTo9bXWr2saZlLNYLDprPjMDn502HKOyXYc2ABVtFdjqYxDCJTDwukAo1VAMMEiIhpAoPnPs4ObfI137XVKKK+uAIgHdAOrAtEDl3QaT+XtO6P6Y+jUw/oqlRIhyyY/nKApFHMpIc2y+EQ6yvl/cxLkUUG8RCGwd9Tm7Mi5WVGHdDPXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TVAwCJbr8A9hD/CDP+rDuHH8HHR84H0z9+RYmTFBTs=;
 b=O02qpqlmCVC/e2r3ZK8UVJefZpUBONAFlN9IovOZaPoWCXbOGP/ISQRKabIKy/38xmtpChS4rTZzXmLUvjRIMf9fbIzWq60pYzFDBYBZWoFkZkjKW+YiisdVFAk9HvHVOxoGsBJQE9oArpwCfo9y9H34cOk8Fo4Y8nYkKuSlXow=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8424.apcprd03.prod.outlook.com (2603:1096:405:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.15; Wed, 13 May
 2026 06:50:53 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0025.012; Wed, 13 May 2026
 06:50:53 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
Thread-Topic: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
Thread-Index: AQHcwsRHjzi+tuh9QUq8azIMBSL1hLYLxCQA
Date: Wed, 13 May 2026 06:50:53 +0000
Message-ID: <459ba5ca0f24ce49fd7de7ae6e014588f40e2445.camel@mediatek.com>
References: <20260402171404.3008494-1-bvanassche@acm.org>
	 <20260402171404.3008494-2-bvanassche@acm.org>
In-Reply-To: <20260402171404.3008494-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8424:EE_
x-ms-office365-filtering-correlation-id: e1274f9c-2736-4ea2-1050-08deb0bbfa39
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|18002099003|22082099003|38070700021|11063799003|56012099003;
x-microsoft-antispam-message-info: FfTPBesxLfSW6bnPF2Zok+gZfsBKHh4kgEo9CrjoxL6k7YYYB9arcq8uAlVaE0oNXDjh3s8Sz2PoHlz3mXyWQMmSAcpRaZ5j0DomZD7s9HCwIiF6dCYkwePu7ldLBz7y3dDdqfL5kEVBujUpxgMXNZfebqJ6SHquO7+Odr5eahaHAP37ij7XkYPS/tzxWO4jJoqxPbTdg0aS/nLtvDbRgupX/ix/npA2cC8NGj4/WSE0zRbc933treWJIu3BlavzQxjmkv945mQpfIyfsU6ByhYW7bKKDyRDS9LGNZgal6q/37Y3838cVrNXOYtTZUW3VkusynINoTmTfldlK+f7wVsWZs157Us4GCHOIZBwZS8LtAuCASSd+qzI0RkiTsv+/IhD3FW+dmHd6RoRkBW1tjDZJ1zbWVEGZZDnhQsSz8dWtMxX/nyXUWc18TXWZTF0y09lWQYbnSrPuI6GwFuD9ZHp8iubft9BHS9OcpEu81lacoiRnJsO93fEHBoWtIXDDNqbmcdy4LaZdOTaNwAk1psLIk2XYj3WKFgflb2mAcA+S3TX/P/fuXWuJT21PQf4bbh0lAVf46qVX/O1PH7WiX3OcqlLf8nxhBLOClen687Kq0SlgKNjaW+ti2Z6HQmgeaVFDEe+UmvyZEdPJDGTnbv8oV+5HiCaObH94iwaVOTttbRIvFgPZ1LL47GPdXvlmK2Pb1RaYaRQtSskLMpLys13h98gYY232OsqT22dZx554OnNABGUqSkZvMQ62X1o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(18002099003)(22082099003)(38070700021)(11063799003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3UwelJsTFUybVkrQ1E4TFBQNTFSSk9nZTlxZ1hIMFUwYzd0UERpcXBrUXBC?=
 =?utf-8?B?bElmUnkxTjk1UTVsbXJsNWdXZmp2VUZNa0NFcjFQc0xPbUo2QWMzRS9LbFRJ?=
 =?utf-8?B?V0kxZlp6QmFDMjg5UFI3cVpVVHdjZVZUNnJIaGpzdUdGdnM0YXBuRk1lNWN0?=
 =?utf-8?B?elRHY1luWU5QSTJ3Rlg5dEhDaVIrSHpFMVJmNHRIaUxwRitwMlIzeklxQzlu?=
 =?utf-8?B?Tllkam1ELzdscTQ1SGIrOEFHWjBNSFpXNGZYMTYvYmErQkxnRWpWa0o1bURi?=
 =?utf-8?B?UmlHYnFwK0E5WlpGaFF0ck1WS1hDSnlDdGNFeTYyYVJVdU9Qam5sbkpLT1Ay?=
 =?utf-8?B?RUY1R1dGZ0ZIRnJLazIxUG5BZXFjT1RmZXVoYWxXSldLZXNCOWduYk5jTVh3?=
 =?utf-8?B?SDM1SlRabzVDalArWVNvZXdwOXZyS3NnbWhIQkwvZUc3c3BEQWNVWkVnaWR4?=
 =?utf-8?B?Y0tJRGdFSHBTbFVaVjdFTnArNEFTTlFCL3l5VXd0UGgvNHBxTDVlcEhFZzNR?=
 =?utf-8?B?MG5Gdk13Tkwyam5ZYnRFeTBnTWVFOFV6V1htdFhFK2tsRHhPdjJxWkJBMTJN?=
 =?utf-8?B?bm1tRnN5dFlsTUVPYUFGbHNSU044aWs5M3dadmlHb0x6MDh6QXlwaFRrTmgz?=
 =?utf-8?B?cG1tNGFFL2F0MU43dmRHRyszS3B1UVVmWHQ1b0txZU5VdzNSZ2Z3QTRRSEx1?=
 =?utf-8?B?enAxNHE1bE9ldzBCTEcvUWNEcmNxQzlDSjVKcEtxSThoUXB0Z1d2Z3BUN1Vz?=
 =?utf-8?B?aW5LUkl3bGlJNVJQSjlZMzRxeCtkTHZra2VmOWtFcC9xcG1ZWk4yNHZLd1gz?=
 =?utf-8?B?YVVnbFdMd0tzdWhnYkgzWFZuM2VqUVVNNldaR2NGK0dDc3hXZ0pCMGVHRE9L?=
 =?utf-8?B?U1pkL3RxS2NsbkdzUHMyUkFZQ0t0bmM4dC95OUg2NEV6QXNseW44a1FrN1BT?=
 =?utf-8?B?YzFUdExtZFdrYmkxRk92VjEweVAxRnJleExJZVFqYzNnaXl6dmc0NkFNYkxq?=
 =?utf-8?B?a3EvZkFUVXd3YjBNOVNURWlFNURqTTJmY0IwYkZ2b0IxUVpyQi82bllwYkFK?=
 =?utf-8?B?L3JTUlAyT2FoQzJHd1JtM2UrbmJPdEdickZ2dFFFb3NkYURLK1FjNWxHRURx?=
 =?utf-8?B?M053dkZFN0VRU2RxQW9IWlZlb2NFM2g1QllQa1F5OUpBTnJYdllEc0tRcXV0?=
 =?utf-8?B?QmY3YlBJV1ZZeUlIZVM2SHBnRmNlM01zVHdsYmgrWURRTEpZby9GMWd3b09Y?=
 =?utf-8?B?UDBVcmVEb1l0ejdxcUVEeWxFRVpsNE0zR1pGd0U4aHZydTI0SFpGNE1uRzQz?=
 =?utf-8?B?di96NWIyZ3k4NEpRMDUvM2RhZGZmYWFPQTFNd1hGNTFWVVNzMnN3M05JRGV4?=
 =?utf-8?B?MExhaDB6SWFHNlpxeXluYlBSWFZRY1RLSGplRjFPMmZ0UlN0d1BsenY0VnZ6?=
 =?utf-8?B?d3gvb0hiMFNPblpSd2g5SlYwRUU5bEtlOXdxRlY4Yi81OHBPWkhUWlhVNWha?=
 =?utf-8?B?WnpVRkRoYzdPOWdkTzZBcFNEWEZPTXpQWkZnRGFBbVlqOGl0WFpYdDRTNzVo?=
 =?utf-8?B?d2dVcFkydDVwdC9COWtyRWloRW5oM1AvL2NPcElyM2JyZUxyMWxlOFh1QkdN?=
 =?utf-8?B?L1RNMDc1WHBCQVVtUEFNZitTNkJ1OWpqZnk3RmVQUzhuQ2d1MTVnOEx4ckp6?=
 =?utf-8?B?eHZDZ2EyeXVXUnpZd1g0SDNzRE1nb1pvMUJ5Y2djSjJpMDU2amxRaitWSnUw?=
 =?utf-8?B?ZjdPL0txM3lDN28zaXdtZis0STluNWFHRUhaaHh3d1BFZ1NHNEZMV0x2OWJo?=
 =?utf-8?B?cW9ZSHBUSytvNGRRNkUzT29WUDNwNExlRlJ1Y1FCQWxCeHh0YzhRb1VjZDdk?=
 =?utf-8?B?dXppdGFNcnRYNmRNdHVXc2VHcE1zVjVHQWU1WFBzemtrV2l4L014NTV4SHB5?=
 =?utf-8?B?M3haQmlGbTFkY01QeDY3bUwwRGViZktFcTdXSGNHMlpMcjRrdTNWOHJGNTk4?=
 =?utf-8?B?bnFsZWZnaVRIS0ErL01GVXVGYnZud1A3cTBWeFZnVFFpeEpTb0c0MDNOZy8z?=
 =?utf-8?B?M1hqT2VoL0NnblZyK1NFSDhSRjlnTzREZW9ES1NnUzFNMVlHTlBwOTcwTVNa?=
 =?utf-8?B?SXQzWEVpYi9HYllBTVVqQTJYNDd3ZExMT1VxUWMvU3Z1YlZyQXlQTTVmU3R4?=
 =?utf-8?B?K2R2NjFrd05iZENVa0s0YzZxUHEvZ0JrVDZGL1VpUkRMbFVWQ3o4RmFRc1No?=
 =?utf-8?B?aE1TcG52Y0QralVJOFlXWDZoL1dsT1pvVGNNUXY5R0dHbDRubFJ4azI3ZjJI?=
 =?utf-8?B?TTRENFVRNzE5V0lNZUk1R3BxTVdadkF0MmZCNjZJMUdmay95YjN0TTFGZlgy?=
 =?utf-8?Q?OZpNZhDenjxEaKLU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40481C3897D5E548AD956AD9F2438A0A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VilZiZQbgJG1tNE7B2JO2faVkVTzapStuv22pXW7VmgwC2+GqvV1OCv2pHnTnoW1Ta/UMSGInLNuXoSDd6pCtrBNr6V3TTCC+LZP7B6ojqq4pBBqVBLZG0I+d0o1Ct2Esei3DxxbvtvZZsD/2B3wkGSRFsKi54YT2oxQVZnJL0cBoDg5M6JDsSlqdNKn8d1MhU+sQb2nvPL/6+m660Jqu+h5oMGM6tFKrS6ZYujxHf65FtfSQdODwC5IKC2UGFe60LaoFOG7O18OzRkq8F6OYLyfspwumy6PYycznUknALiRmlyV+Nan0gaOjiPg7yPY8I4B8fQ5X/aMnmXi+QPY3A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1274f9c-2736-4ea2-1050-08deb0bbfa39
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2026 06:50:53.6506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0+mGgBn6gRrUJ8QDK+w7USOwfLc1KW7dMV1luTMkBzTmtP9xmoNXVgd2X4JmI22S4z6mo24+OG8Mj0uiCYLLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8424
X-MTK: N

T24gVGh1LCAyMDI2LTA0LTAyIGF0IDEwOjE0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEludHJvZHVjZSBhIG5ldyBmdW5jdGlvbiBmb3IgcHJvY2Vzc2luZyBjb21wbGV0aW9ucyB0
aGF0IGFjY2VwdHMgYW4NCj4gdXBwZXIgbGltaXQgZm9yIHRoZSBudW1iZXIgb2YgY29tcGxldGlv
bnMgdG8gcG9sbC4gVGVsbA0KPiB1ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2soKSB0byBwb2xsIGF0
IG1vc3QgaHdxLT5tYXhfZW50cmllcy4gVGhpcyBpcw0KPiBzdWZmaWNpZW50IHRvIHBvbGwgYWxs
IHBlbmRpbmcgY29tcGxldGlvbnMgc2luY2UgdGhlcmUgYXJlIG5ldmVyIG1vcmUNCj4gdGhhbiBo
d3EtPm1heF9lbnRyaWVzIC0gMSBjb21wbGV0aW9ucyBvbiBhIGNvbXBsZXRpb24gcXVldWUuIFRo
aXMNCj4gcGF0Y2gNCj4gcHJlcGFyZXMgZm9yIHJlZHVjaW5nIHRoZSBpbnRlcnJ1cHQgbGF0ZW5j
eS4NCj4gDQo+IFJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
DQo+IC0tLQ0KDQpIaSBCYXJ0LA0KDQpNYXkgSSBhc2sgaWYgeW91IGhhdmUgYW55IHBsYW5zIHRv
IGNvbnRpbnVlIHVwc3RyZWFtaW5nIHRoaXMgcGF0Y2jCoA0KaW4gdGhlIGZ1dHVyZT8NCg0KVGhh
bmtzLg0KUGV0ZXINCg0K
