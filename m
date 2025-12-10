Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA607275AF0
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372502; cv=fail; b=iGzh0NuxGhAp+cbeEoI9gNp/qP8qYPdwtQYg4q0nJIPyNHFidRbQK7wpvrNW9E3aBhpJjV+kyZO7vYP6zGQs10QwpD+e1DCHUYeg7PckL7Xt2LLvXac21wsBSjRqpZSlOoh5C1GIBLDOOrB+XyUDvKl5QDcp5T+ueks0DOEa1Jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372502; c=relaxed/simple;
	bh=qrpDio+jk4B1YVBb0d1uazjiqRCuFxGWeDETJMm8j6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DP5DhrdvmdPSjyxODcebx0FpW4ZiVj0ptGb6r+fC4i3mJ1Tz/4sKNg1wpuy98s5Y0enpACxthgzi66EQodp6gH5IWoA9SBhgW+n8kvQmS3/YT/HIwCMXiptP+ZP1sk8xzqFiu82vWaSRyEW3yJkfSo6MYICbarsmN2SdFRqgjjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kyhUpPtI; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VKcmoX8x; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kyhUpPtI";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VKcmoX8x"
X-UUID: 35760fbcd5ca11f0b33aeb1e7f16c2b6-20251210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qrpDio+jk4B1YVBb0d1uazjiqRCuFxGWeDETJMm8j6g=;
	b=kyhUpPtIjRlZ4ikvxTrzNyQUFmZm7dH1JQwYzIFv6fV+4USkdcm5KwU9jFcGgo51MA8wcGEMymixkhJmljHNR2yibGI5g2aUvlm1/dzMz9MxVNofNzp/nbiWCAkZk+eFwvU4aLFdKs185fpceDkQDXjRUj9tJ2Th2SomIZnR54E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:bbd58a28-5023-4f9b-8ae0-a061741cbe3d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:80e65e28-e3a2-4f78-a442-8c73c4eb9e9d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35760fbcd5ca11f0b33aeb1e7f16c2b6-20251210
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 165201342; Wed, 10 Dec 2025 21:14:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 10 Dec 2025 21:14:49 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 10 Dec 2025 21:14:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUrzaeo5zUIm/IjuLkJgGvBoWTf8QPPab6kKqx58jEf6AaeKIRgCdQeY6mHj4nMth+pn3d4Z8M9TCiAy4RxWTDfettVdYhBwlPM6/bVpJ2kXbrmAqfPs/PpKUvw/CXXykB9NooQ1qWQKCLqYtn8ZLWEJLUrCoES5hYVQHs6vQ5vuNh5GrUa5z5CIb0fERSBsRP4NFWM8rn87Eax2bzzfC8uASp/31/vxhmfhwkGJRK3sPnxArHSWInGmK4FKjpPSXnLqvOLmZcJsITggRixLQlyNGp+yuEPBvKuE5Xq66cdR9p+vyU0vyEmtUcCNZBB45LB5qr1sbbt+/GuyeWzAAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrpDio+jk4B1YVBb0d1uazjiqRCuFxGWeDETJMm8j6g=;
 b=tyDDAUjsEmTx+k253g4gUDDUX+Q2e0YBkLZ8Tq316Py2oNLyulp47qB5FPtOsvvAvp+kkrBVjHgtpz/JuEJzHB7OkHpQdFEmJIJ2K+6CyD82i0Sp0dYQtF2PoVjmltW7cJ7lydbRRWLAdkxm0cCVq5KDBYORR7bMU+/fySf9yfUgDNF+iMBlZDxqBLC4ImaxMtv8MGWe9MDvdLoEQMTgjq+TwBaxxelZ9uB1jRXf7eXVef24hBzB7EIdGXSTGHWMxiWaUOeQt0aVXEM2wKnNXCVrMFVfFEx/lshnS5rKhEuyEuPJr3j16YbnqzsYbIrxW2WM43rP4uDMgQFFY6vACA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrpDio+jk4B1YVBb0d1uazjiqRCuFxGWeDETJMm8j6g=;
 b=VKcmoX8xL4W28uez6Z6PaLhdhYxIvg7tJFxzrIdFN5o+wiICpvLHOLDZ5eyXaovxvex114O4aIVxA3W9aMGC0oBULJ9tuhLMDitHGZDML4fin8uVyH+9HpB6sw+EOpTKriu5XYbfjus36qKa+m2Cc0RusWKIwOdzU0TtPJgB+VY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6599.apcprd03.prod.outlook.com (2603:1096:400:1fd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 13:14:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 13:14:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: Uwe Kleine <u.kleine-koenig@baylibre.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "mani@kernel.org" <mani@kernel.org>
Subject: Re: [PATCH 8/8] scsi: ufs: Convert to scsi bus methods
Thread-Topic: [PATCH 8/8] scsi: ufs: Convert to scsi bus methods
Thread-Index: AQHcaUzbF6l0ozmQIUKVM1MgpEfkCrUa20oA
Date: Wed, 10 Dec 2025 13:14:43 +0000
Message-ID: <0876a138442ed69465015dc338ced364f8976640.camel@mediatek.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
	 <56e89c3f452dc3c9f343f1b9a9c8b200642da593.1765312062.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <56e89c3f452dc3c9f343f1b9a9c8b200642da593.1765312062.git.u.kleine-koenig@baylibre.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6599:EE_
x-ms-office365-filtering-correlation-id: 6e59b441-b0c7-4ed8-e229-08de37ee1566
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YXZyYXEweUNtUVBxUFJkSVYzTm14dDdhNnI3TnhSUGJyMFVKNXJzSW1YTnhY?=
 =?utf-8?B?YTBrQkFJODZaL3lTY3YyZXI4c0lTTlZLTmJrMWhVNHd2KzRDMmh4QjNlU1Vt?=
 =?utf-8?B?MHFTdW9mWS9XbGd1N0FXYTFnakwyNEZmU1dycmhjUml6Mk9sQ284OWYxZGRi?=
 =?utf-8?B?c2oxT3MzVllYK3d5bmJsdkhHeEFxcXd3S0RkcHNRL3RRY3FQSE90TzNaTVp3?=
 =?utf-8?B?NWMwMElWcTFXckVJUVdBZHNvdnBYODgxZmVlckQrSUNNOW9TeGVmcW01UjVn?=
 =?utf-8?B?RWtjM2RKbnB1SUM3eWRuVHI1NzdLcmI0Q3g4MmhZUG1ISXpPQW5MbDBrZFJR?=
 =?utf-8?B?Snc4TDE4aXp6NmJsV0w0Q0x1Ky9uQkRScG04UVlpb3prTVhNMmR0MWwyQnYy?=
 =?utf-8?B?WDdRYWJMeFNsc3J6S3lRNnFFR3BpbWc0b3kwdEl4VGFub2JHU1ZhYmFZWHdK?=
 =?utf-8?B?SlJuWHphOHE4eEVTQUlYZW00WXhDUVJQRExvOXhKWVZzSFI0RjRaWGgrdDNV?=
 =?utf-8?B?ektXamVodUlXTGUxOTZOdXBNSUQ5SzFPbnYwT21ucVpSU3c1MjY1ODZYdW5t?=
 =?utf-8?B?TmswbWhrYzRwUUQzQkNxZzc3MDlHRVFCQjYvWVh6OTNyVnZMVUdFUkU2VzEy?=
 =?utf-8?B?YVJvK1kzNW40ZnhkRjBkUXRvWFdGbm13QWlXVjlWSEdWbFhZWUVXV0RiNTlF?=
 =?utf-8?B?eVprL2ErTDI2akx0d2NjOEJVeStpTnJ6RHl4SGpqTEpBbWdPa2lLbW5XRWJn?=
 =?utf-8?B?N2YxYWhwdjhRT1VLR1lUTkU1YW1Zdld4RzRXcktkU2FSMUdXYXVyeVhFNUlE?=
 =?utf-8?B?cmNqUk9INEZmUmVaNUNrQWNzQmdjWWFROE5BVGh4QzB4NDNRVGc3QW5kOE5p?=
 =?utf-8?B?MS9uRExJSkRLOE0zYjJIdXI4dVdtVjRINnVQVlNERm9CbDVVUGd6QnRqNEp6?=
 =?utf-8?B?T1UyUUdlNEhpQWlIWWlvWi96ZHkyVThGeUFWSlRmUThVeTczLzVxcmhRM0pl?=
 =?utf-8?B?N3pGYXhiN2xmTFNxalEvQ2VOeEV5Y0JSU3VoUXNuNXNEY1RkYnhoTVc0UEVi?=
 =?utf-8?B?SXM0REJUUU1UVlppMlJrbS9wdlV6UHlMQkFxM2c2U2ZsT09QNGZQSmhJUHVN?=
 =?utf-8?B?S0dMamhxd0VXby9wVTdCaTVaNTZ3dWwzWFhEZnBhZzJPdURDTmNNNGRTRTU0?=
 =?utf-8?B?NlYvNmhDQWZkN2JZYjlrdzlOSWI3c2ZuUmNHektrT25oYmxoNlIwMjBPN1or?=
 =?utf-8?B?bmw3bis4UW12UmdjSUJvWDBsODI5dEw4RXR0RjFQbndEMzh6QVdEV2FmZ29j?=
 =?utf-8?B?QXRVQmtYNTBsaVB1VzEydDN0cDgzSm5OSWREMVArZXA1NWNNVFBEc1d4c3Vi?=
 =?utf-8?B?akdUWFFGWG5rSFR0cWpFWUJFeEpxMHMrTko4MkdoTnBmRUZKQ0F3SFdPMDQ5?=
 =?utf-8?B?bCtkTlVQOEFXaXgxclJTOUQ5UndLeklXNU1SMjc0THRnSXR3YmF6T2hBTUw0?=
 =?utf-8?B?NEdvdmpWOFI1ZWxqV3RobTNCTEVsNko3RThGdzZxWFJ1MEdUYnpXTnZCa3Bx?=
 =?utf-8?B?anphOUNWdHhUUzU1Nk1kUHlEWSs1UzZKVjB4dWtWZnFnZG91Y3FwcWV4UU9H?=
 =?utf-8?B?dVMyZHJsWTVuOEpFVjZncUxoRHRIYU5MWndaMmdQYzF6NkNCWUlzSEJ4N1gr?=
 =?utf-8?B?bXhZd09SZmRSWWlxL3l0TWozZlRnQjVNekF1T2RkZlVTWk9SdTlJNSswUUtB?=
 =?utf-8?B?T3REbmdJV1RXRDVHaWpOK21uRzBKa3NUY3l4SVNzMnFjR0ZaVlMvenVoMGJT?=
 =?utf-8?B?a3h4QzZKZDNiTHp2dWRPRDA0Mm5mcjR4YWlIN0lPUldHZUx5SmdUd3IzMGhq?=
 =?utf-8?B?US9ZNGxlMytEQldzZXBLd2FhZjQ0VUw4SjV0UjJuZzh0Ni96WW1oMVZOc01X?=
 =?utf-8?B?aEcxN2tCb0M3ejBKcy9pSGp6a0VSREZoUnY4S2tFNDhodmxiV0FZaFZSU0Nw?=
 =?utf-8?B?d21IM0F2ejgwQTl6QkFJRlpmbzBKQ2toVEIyNjhsMWFWSUlNVTBUQitibWN1?=
 =?utf-8?Q?gNBpsh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3JUQTRDdGZ5Q2F6RS9vcUdEeXpBOSs5M1NzWUc4Y0tzV0Q1b2krQTZtTDBk?=
 =?utf-8?B?OEVWdmxaM3ZnT09ScU9qZlpkMVMwM0h4bXJ2cmZQaStHTi9TMEE1MHZVb1Y1?=
 =?utf-8?B?YnFXQitFck56SU96eTZOWkxKcGNwK1JmN2hDcW1ZQlJKNG5SSUVEZlhCL2tU?=
 =?utf-8?B?TmJZc3I2M1B4ZW5HYXRzTFlOSWtMYXlGWGNIWVN0Z3BpUklVYmhrd3FSUkc0?=
 =?utf-8?B?dkVPck9TUU9XQ2k1V053ekF2T01rSGlsczI4M0ROL21IT3NzdVhtUy95ZC8x?=
 =?utf-8?B?c3M2SzM5MVpSQTFpNEJTZDZvSGk5UGpuSFVJMno1RjdVVWt4azR3TGthRWhn?=
 =?utf-8?B?b0l4anQzMVJUOWtkMlJ3OXVPQlRlMmVQWXBDa0ExMUtramkzT2Rhbm5oRmNo?=
 =?utf-8?B?b1JaeFRKYWxNRFZUZzJlN011U0phUXMwTUNqZ2pRa0l6Q0pKekNYYnA0ZkxJ?=
 =?utf-8?B?Z2FTWnhOVit5OEFMSjNLSkdvVXp6NjZBV3JyOWpicjJwaWhlb09obTV0ZE5K?=
 =?utf-8?B?R0I1UHFybkh2MWNmZDdYM1VGT3RCTUZua3p2cVpsVTA3Z1JSaDVLeDVrb0dm?=
 =?utf-8?B?NXZ5cXNkOS9HaXlZeHU2WXREVXR5eGxqMFRpc3Z5aDQrUm1HbHJHQWt5eXlj?=
 =?utf-8?B?YnFGMEFmTVlFRURvUUVqcy9OSkd1b0cweUF6eGUzbDV5VEU2Y1JSNExURVBE?=
 =?utf-8?B?bUNHTVB6NFVJVzRsemFva1kxaHpUelBQanBsSVBXSHE3SkZGcHVzZlBpNURm?=
 =?utf-8?B?Y3QzNElIZnI1RHh0L3p1UmJQeHBsSGdFbzJ2ZzlodDBhaDBBYmdqTGpDOWpP?=
 =?utf-8?B?VGRvYU54RnB5RW1WVDFqTVptZzladnY0bEN5K3VjaFhXaTlLSGp0cEFQalhJ?=
 =?utf-8?B?aGVETDdlbk5id0o1U3UzcUNibG1oZzAweUZYb1cydnVBRkNtZHdHU3FiUFZK?=
 =?utf-8?B?SEhlbVJUWU1Xd3o3cGhQazZiR05CcVo1WDNiUk1tS3RjKzR3NzM3R05VL0hj?=
 =?utf-8?B?VWNWempBeU1PMjU1UFlqYU0vbVRDOHd4aWhKTlBNT0FEM3cxYTZiN1Z0cmJJ?=
 =?utf-8?B?TWhYNnJWLzR2MDZqVVdyc05Ua3Nld1lyNWVreGlLT29MazExQWVNL0pWQjg5?=
 =?utf-8?B?SEtjZTY5M2RHbXkwSVk4anlqb2gxWWIwVUhaT2t6dUVMTldZcnU4TGJOOE1v?=
 =?utf-8?B?QlFlNVpIcDdKRFcvT0RLUHorKzdqYUZHZEJ6aTBpZThRVDUrQ0xtR2hDNDdw?=
 =?utf-8?B?ZC91dUFLbHo3Q2loZkJiamNzWDlHVkxZY1RwWkx6MXVUZU5jM2d0N1dZT1JG?=
 =?utf-8?B?L24rR0JPV0VpRDl3QmYyUXRMMUdzOGhEcmpBK1ltTU4vRFMwaTAwUjB0ZGU1?=
 =?utf-8?B?UU54YjZaVHc3VERIM1RNYXVwWTJSUnRDTCsvLzdvaXV0MGxFOVVjMFVqWTBq?=
 =?utf-8?B?NWxIZnk5OEc2NDZXWURwclQydXFaODBBTkk0VjBXQ2tUWURGSW53QUZQN0Fq?=
 =?utf-8?B?RjlLWCtMVXBkcGNSZ3NWWStuVUZJVDN2dENydVNqa2FJS2tsUXJiT1ZIZ1lB?=
 =?utf-8?B?MXRqK3VGMSsyK1NPTU5seEFPWVhLbGpkRnBPSFN3dlA1WVhvY1NhampKR0U1?=
 =?utf-8?B?dlBoME9MQlZMSEozZlhoUlRiaks5WXljOER6eTlWR3VBc0laaDd3WE9raWpo?=
 =?utf-8?B?cytrUU8vVUlwOWlPMG5Oc1I2Nzg3TWhmYW9MVVhCYXZUUzByM05TRC9TNXFN?=
 =?utf-8?B?SWRiUjExSk00a0lJTU5GbkZWclEzejJRek95Z1RUQmFBdkR0YXdOdUZGL3Rh?=
 =?utf-8?B?cXp4OUpvdFVyQ2FLTWtac0Z6M0wyRXhvWEJ0a3F2SlFVcjNrUDM0QlNHVkp3?=
 =?utf-8?B?U2txeThwRkQrWVNlUlpqOHFKeXViOHNrcWJHYmtiSDZUTlBJZ0c4U2hCQ20r?=
 =?utf-8?B?VFFKWGw1MXRMNVUrakxCSHpnTHBHL1FiUE9VUzdvNHNiQWxWaE5BSTZzR1do?=
 =?utf-8?B?dGUrOUhwdzZVWWZPNG02d1ErSmhzUi9LSmw4VGs2bk8yVnBZTkx4ZmJ0bFRS?=
 =?utf-8?B?QXlTald6VnhQOFRyWnN6WEFsU1BidFpTV2JNRndDNkRFNkQyYWNqaW15SXEw?=
 =?utf-8?B?VWRUL2ZOOU1DV016b2Rrc0NvbUdUSDJjMDM3MURYaWtub2VleGM3WDd1a095?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <221419E1F975C043B4AE2C36E63E063C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e59b441-b0c7-4ed8-e229-08de37ee1566
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 13:14:43.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QjP0liOEfcpTulzl1iD0Cu9avBDxvfyzzotavDSoyP160ewMbjIDYymXhoVp901KImF98SFJPFBIZFdKluaHMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6599

T24gVHVlLCAyMDI1LTEyLTA5IGF0IDIxOjQ1ICswMTAwLCBVd2UgS2xlaW5lLUvDtm5pZyB3cm90
ZToNCj4gVGhlIHNjc2kgYnVzIGdvdCBkZWRpY2F0ZWQgY2FsbGJhY2tzIGZvciBwcm9iZSwgcmVt
b3ZlIGFuZCBzaHV0ZG93bi4NCj4gTWFrZSB1c2Ugb2YgdGhhdC4gVGhpcyBmaXhlcyBhIHJ1bnRp
bWUgd2FybmluZyBhYm91dCB0aGUgZHJpdmVyDQo+IG5lZWRpbmcNCj4gdG8gYmUgY29udmVydGVk
IHRvIHRoZSBidXMgcHJvYmUgbWV0aG9kLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVXdlIEtsZWlu
ZS1Lw7ZuaWcgPHUua2xlaW5lLWtvZW5pZ0BiYXlsaWJyZS5jb20+DQoNClJldmlld2VkLWJ5OiBQ
ZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KDQo=
