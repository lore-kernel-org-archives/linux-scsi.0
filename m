Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD92C11DF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 08:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776156394; cv=fail; b=TEMhrzTX3YtRrk3d9X9nsFv1k30StX0/3u/ybQwgIWNScH+rwed1kjp6qL9UMK9FRsyWKfVK8u3TwHEPXubK6UqlWieZGAsDnPjqFhQrwKXsWQUOUyRzOwmllcdYSi4pJo9cWuHtXkZK419SMiEWu4DJh4mMien6rgZuCXnN43U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776156394; c=relaxed/simple;
	bh=RX65dTSI8qao4FzKJqJPvK8P9aYOZARoe/n3qb17B8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M/VT+D7ui1lpr6Qk2BVm3CmPTJ3Vaq2Gghtjt0f9UlmnWUUKKlk6kuaROCJ9ngJsVRK716uLdprYTESgN7oWWBMxFXx58g0jxP2XzhxYxjlF5uL6emzGGKwT1pZ8qM4yvW7Fh+Lfl57INogDBLLAdCep12zULMTGbrVEdIU4CK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=L9YtWUFM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=T8VBfOmW; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="L9YtWUFM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="T8VBfOmW"
X-UUID: 6c0c763a37de11f1ae70033691e9ac7d-20260414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=RX65dTSI8qao4FzKJqJPvK8P9aYOZARoe/n3qb17B8M=;
	b=L9YtWUFMvngSY1Mc3X8qJqDwsoo3LqZaMBSH9W1aB8x1NcDleDaNMRnHLOj5o4kJKln5izJSZkp0nyXgACItirXYm3Wm1SI2+Nm86ScnuZ/cHQ/N+FsMwFZP/bRO5HCdsf91kySu3zCgwRYQlbUkVeL36OnQ6LyLoyqJbC/DuiA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8e359a0b-4acc-46e3-b40a-87e403586f71,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:1f87d824-cb5c-4236-a89a-9a7fb20c9bc4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6c0c763a37de11f1ae70033691e9ac7d-20260414
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1665304085; Tue, 14 Apr 2026 16:46:26 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 14 Apr 2026 16:46:25 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 14 Apr 2026 16:46:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ptyfKTQbE+PUHlgHRMVrK8LMBBj9gN1tzkF15ovSnQ3fyF/reseOqCfb6qkN4Q/kZM/lTaaDvaRMAcdIHw+fVf2salDcL7r9IcHiQyNZO2Bq6fsWfwyvaju7wsvOHpkOnqV/B+g98u36Kz5odF8O2er0eESu+eyq36FCLyfJBEO1KpGBfWM0r9iW+U6rgmr3ELxLLLp5mfxZsFUp80WXOp2fpt6itSQoBlbnDAj56bWISqddjbyH/oUSVsGbwcqzZZehdPcw89mudVm6KU/MWaU05IvsSuE7qF/q+0/GkSvM1dEYhcKqq6Ozc9kRHayztRdTApeVOAZaGWwIYK8CuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RX65dTSI8qao4FzKJqJPvK8P9aYOZARoe/n3qb17B8M=;
 b=Lz4kBS51sRoZatp417wERPDepuPPlmQRxq82mnmAWxDP5maoaWstuZIAMNAh2PYSJTFOWXeHFM8KZvurfSbLYPacfuG5Fx55FTnqlwiyaU52uqg5+/oU7sdemPLgC/dCXKuWvjQYsnY4Y70zUDGH3g+QfyQElEScRtZHW17VeTXpSHana35LzFJqPg25diKTt4BXiyRK5lp5TICrwgSfC5sRXC0Lg7oLsY4oME1i7G5//IEMDBISIokbCgP8GMN5FcRS7gaWfFA+F2yZzY0/5EaH+e0cOb1zSbks74rqmgeKu50bZa43Re7WCYTKqFKk6horuB5JnePnbDs8i3Orhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RX65dTSI8qao4FzKJqJPvK8P9aYOZARoe/n3qb17B8M=;
 b=T8VBfOmW83zXLjJUEHyRsqf9J8iTRizYLYJojiwkvBVz9GGpeH5XIKGDobC79fELrBdVOlI4/5WooGac6snuszjOeG+5XVAzNtp1q2w7mVTFirvMOpixpTYHnK9tSCCKT81omgRL+MLIIyU0BbXXfb/amaBV9tm9goYmaE4K2y8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU2PPFFA0747153.apcprd03.prod.outlook.com (2603:1096:d18::433) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 08:46:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 08:46:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "wangshuaiwei1@xiaomi.com" <wangshuaiwei1@xiaomi.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "wanghui33@xiaomi.com"
	<wanghui33@xiaomi.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Topic: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Index: AQHcy7VOZiE/9Rd8/UmyMJP6gMkUMrXeCcKAgAAS+ICAACIwgA==
Date: Tue, 14 Apr 2026 08:46:21 +0000
Message-ID: <60e9a9f1a06692b0a4741058c2b9827c6bb98096.camel@mediatek.com>
References: <ed8f32842f42dab0a3ef4774272b41cefbfe8fae.camel@mediatek.com>
	 <1776153767063769.11.seg@mailgw02.mediatek.com>
In-Reply-To: <1776153767063769.11.seg@mailgw02.mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU2PPFFA0747153:EE_
x-ms-office365-filtering-correlation-id: 104c0ee6-9b07-4f16-1b5f-08de9a024dc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: szuqBnUs1Gzm0Eq9ZFjyKTBjEOr/m+Yg40cFNLEZesnvtq2EQF+3C+ErE47aCCrPOcSfg8v/FGVp+j0Po8rirey+0CmU4Nyja1RFm7pYMbcYkQvJ3rAikKJ3sKC92f7dyC0Y8rP1quY4HONoyEHxs/6faHf0uM6JRuIwDL0us9I1qyHqayYtJA3fhf9GcfnXDLFkomkORXHgbqpa+B1WocoWgBW6MF8se2uREbkXZJOAEMTSxAOBnLhmeVjOL1C8zVnzf2ndzKjeK1tCcSxxgB1clwFNlrnkfg67/wT74rqr9vlMeQNOSUomdzN0MwrL/kn5qau+Q0Rgc1PZEOfPyIG8SYlfh7TQIYdM8zpGz3K06ZCR6sbphwwdYsGhsiXftRhSkpjwPsRfzxNO1IStBzdbqiDILv+Bi9oAvbUONBQMpjft6dO9mM5E+swVN8gkdH47Jy77lwIuU3vsPyG9QTWGlVAwlV6xoBZzo8AubzLDoGtqTyJv11fklyPBESunwHWFiORiVE0glnhIEAQqB9ulblqBj6STXAMwLt9bW98rk0Z3/Umi9apKgalLXH2NMNI9ZWisch3Fgvv6ofWQHae8KY9qH5hkxsZLVg5e/cZmyL2mZOr7fqc15FqYX081sgPQUkC1ERIrlAZbNSnBPdqnbtGhsJlxhJ3mRoeCfZIsKutDeHaMPpig57GbP74ld/xzlidtAXn42oZGyTU/BK876/OX/PCZx46OkvFEVidhcifM51TJcVs56HaSNX5D30ZxZiAe5xUSk9j3ugfqKODFbcRLxrLz3/qhUaP14Zg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHdwN1NRR3VvZlo3S3RyV3J1YmgyRkhPa3ovdWJnTXRWMHc4VGdCNnVac3py?=
 =?utf-8?B?OCtsajUvY1RKWmdFazVSTlVBOEhNS3NFRjcrWDNNdjVaT3ltNXRnUUpWa1cx?=
 =?utf-8?B?T3ZXc3IyNHYyczFjWm14MmFocVMwQmVIbGRWUWxiZXYvSUI5bGdnbWthekww?=
 =?utf-8?B?TmNvQW9JQi9oWnJzZkFram9kRmNUdy9zVjA1NDNBaEwwc2ZUbzVvNWlJUEtG?=
 =?utf-8?B?Wi9HNEhFZFEwSURzRDMvb09ETEFjaUE1OGxSUm9abE1mV09YYkxwbm1EcFlS?=
 =?utf-8?B?WTc2eUdxU015TUFKUG90VjFBcEZXeXlGNFd0dDVLZzkzdklka3g1MEFqZ1Bx?=
 =?utf-8?B?eGlCYzBvdkRtSWJ1RlB2VmdzNXhQQ1k3U3NDQTdwQTZHeDdSWTBLRkhDeGI2?=
 =?utf-8?B?ZTVXLzdVcFV4Sk0rdmJZUkRGOWlQQ3lkZkpzdFJ3WDN3N2ZYSWRUVFVzOXVI?=
 =?utf-8?B?K0tlT2JBb3lJSnhoRXRKUWc0Z1pETkNpZk9DcXAvOHAyRUtkMU1IZHpyMUR1?=
 =?utf-8?B?UXhpMTJpUnBscnMwS0ZPdS9nTEE2RytTQU9pYzFqNHVwc2phZDRRU01ybDhU?=
 =?utf-8?B?T3dTOEhOczZNQSs0Y21KTGw0ak9mb252SE5KWForMlNtN2RuZTVBUXlhVTZP?=
 =?utf-8?B?akVMUXQ1NENERTV6cDltZXBKeWhyZnZ6OWkrcHJPVVN1cnVtWmJGdXdjTEE3?=
 =?utf-8?B?WTdsWkF1djR1cFhXcDVlaGltZGx6a0ZWdUU0eXFRU0VEVWhmZG8wNTRITmZR?=
 =?utf-8?B?MTVGL1NVdjZhd3ZlWmxQN2p1aVpTZXZ0SzRjVjFzS2dVc094OHFKREFoV2lv?=
 =?utf-8?B?UTdlYjZpNTVrK2E5VWI0U21NUjNUNnQ5c2ZUUEJ1clp1Y2hBdUhIb2xDMHVC?=
 =?utf-8?B?LzRQd2MwbTRReEgrM1hURmZ3cXMyY3ZCT2RtR2t5WVc4Q1h2eExJSkRBbUJU?=
 =?utf-8?B?akxmUTFPekt6aVcxRWplbDAvcHUxNU0vT3RRK2Roa2pLRnVZNllnaEx0cDZC?=
 =?utf-8?B?R3JaeEM3ajJPckxjYzV2Y1lEYkM4dzRoRGlJd2tIVkdHQ2g4UkdYWjZhNHdh?=
 =?utf-8?B?ck14S1hkUUFZVEk0ZWhhRlZsWHZKNGxya3F1N1hJMG54aEZBUjE1TEl3cGV3?=
 =?utf-8?B?T1FrVFdrQjJnOWdseXRTQUlEdld5T25oOGgxUHVKczBGdFNWckNUbkdRZTZi?=
 =?utf-8?B?cTBSMDJWbXdQaDl2TXErWE10Q1JYdUhpMENTYysvRzlDQlljL0xlZ1dBQlJp?=
 =?utf-8?B?Vm16L0J5cDJFcHMwNE9CakxOaHFXUnlOeWlNc25SWmM2aHc1Vjh0VUF2UGlQ?=
 =?utf-8?B?Q0U0aUpFalYvcG5YRE5KOEhTR1hucmpLcGFrcUNXUW5iVHVJYzdlWGlFUlpB?=
 =?utf-8?B?L3VrVytLdzVMcDB4WWw5ckprZ01ZaEZjYTNTV0NMN1NtZGVTbi84bDZaS0lm?=
 =?utf-8?B?YW1IcVA2ZXJOMVJUb1NtM25nQ3dkYXk2K3dQajcyeUZ6SVJqNWh2NXN4S0ph?=
 =?utf-8?B?blFpNUlOQ3dRSUZoYzVON1QvSmZ4dnVzcjdDazczRmNFd0FacW9OT1dBdW9D?=
 =?utf-8?B?MWVDK2hnamFjMXRUTVNvekJGSTE0bDJhOEo3OTFWSlVnNjN4VkpkMVN0dnMv?=
 =?utf-8?B?dUZSS1JFOTFRbk9XQ3hRK0VXZ004bHpqUTJZTmNVV1RjK0dydGN6Rmdac1pC?=
 =?utf-8?B?NzZSZTEvaEZZNTJnRk45WmlRSzd0TTkyVHI3TngyTTc5SCswenE3QWdhc2R3?=
 =?utf-8?B?L1hiOWRrWUM3RnZtbEdvU1VzR2hEbGJJNHNSTGYvbmZiM0JjVXBNOEF4ZUNI?=
 =?utf-8?B?YnB2MENTcGdiVjk0RkYwYnhTZHY5NU4rVjZSZ0U2OGREM3lSVWhGTGg4TFRh?=
 =?utf-8?B?NGwzN2wxRFd6bWZhMFlWWHN1cExjNmN1UHl4K0tESmRBRlZhRjB3SG5uMWZu?=
 =?utf-8?B?SXlXSEFPR2hoUVlTUldRUm14bndEU0JUb3QzUWtRM2RTTG8xMnpyNUUxVmQr?=
 =?utf-8?B?M2FmcTNITmxmMGNQemxPQ2JjZ2lvd2pURlhvS1owaWpRZEhHTU4zaUhLL2pl?=
 =?utf-8?B?YWNqaW53UFAvSWRTZ2FqcXRZQnNjR1dEa296cGJiU3NVdk5qZ3l6NEE5V3pX?=
 =?utf-8?B?cHhzQzFodW1RdEN1R1lCTFJLU2swd3dabVNqSHVDejJ4NXprN1pvang1cG0y?=
 =?utf-8?B?bWZreHAxNlAwcEpZNCtPdGxBZ21xRXVYb1RCZzhzVDBmOEplbGJyUTVyTWJt?=
 =?utf-8?B?ajdjVjh5WUVXcGp0bUZyZ0ZwaSthLzB6dXJ0cE45YW5IVE44WFhJcEZ4ZFk2?=
 =?utf-8?B?dHY4YXloeXhLNEM0aWdBMnB6MTF4ZzVYSmxyUkkwYWxkeCs4eUdOeWV1OVpk?=
 =?utf-8?Q?HJ2n4bmjG6lYr29c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FA2A9AB45ADD04C908D1BDFED79E866@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: XIDXaKLo8hbDVDvlmpvCwTPZORGU2gOe3Iv2fXiDDmJNSy7SS04zxL2MN42fRPBsSGjsyRkD17b0lWUUuKYaORmGdQpvpfyDWrD2T1f5YOjTx9TN1JhuYKL/7RJ7Xb+Ghy9DvtOPZvRLaoITqtBVygpFVUyRlrWIt0O6UMDcvbnGKgR9eAUPXBcVFRrnd5w8ap5vY4DdDaMm2PCtI+KNoMg1fFQVR3AH/y4kl+CFF2xGzHgwOIhhLzU5EF0hJ1CkQxoo7GflGqHqu8OtWLB2ZpbKgO8sAbACQbsuoMYOeDwptpYExSazv1iK5GPZ1u7TW1VhYZwo3pzz2zNFYJkpfw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104c0ee6-9b07-4f16-1b5f-08de9a024dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2026 08:46:21.7988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cw6U7FyvVZpTzLbiVOLlsMCqRfCalFk1rYVSpotIjyIBjg/6N5ug3Ed80myxAOCqOlm2p4bEIVoeOiYtpWAuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPFFA0747153
X-MTK: N

T24gVHVlLCAyMDI2LTA0LTE0IGF0IDE0OjQzICswODAwLCBXYW5nIFNodWFpd2VpIHdyb3RlDQo+
IA0KPiBIaSBQZXRlciwNCj4gDQo+IEluIEhTLUxTUyBtb2RlLCB0aGUgcmVmX2NsayBmcmVxdWVu
Y3kgaXMgYXV0b21hdGljYWxseSBkZXRlY3RlZA0KPiBieSB0aGUgVUZTIGRldmljZS4gVGhlIGJS
ZWZDbGtGcmVxIGF0dHJpYnV0ZSBpcyBpZ25vcmVkIGluIHRoaXMNCj4gbW9kZSBhbmQgc2hvdWxk
IG5vdCBiZSB3cml0ZSBpbiB0aGlzIG1vZGUuDQo+IA0KPiBIb3dldmVyLCB0aGUgY3VycmVudCBj
b2RlIGRvZXMgbm90IHByb3Blcmx5IGhhbmRsZSB0aGlzIHNjZW5hcmlvDQo+IHdoZW4gY2FsbGlu
ZyB1ZnNoY2Rfc2V0X2Rldl9yZWZfY2xrKCkuIElmIHRoZSBVRlMgZGV2aWNlJ3MgZGVmYXVsdA0K
PiBiUmVmQ2xrRnJlcSB2YWx1ZSBkaWZmZXJzIGZyb20gdGhlIGhvc3QgY29udHJvbGxlcidzDQo+
IGRldl9yZWZfY2xrX2ZyZXEsDQo+IHRoZSBmdW5jdGlvbiB3aWxsIGF0dGVtcHQgdG8gd3JpdGUg
dGhlIGJSZWZDbGtGcmVxIGF0dHJpYnV0ZSwNCj4gd2hpY2ggd2lsbCBpbmV2aXRhYmx5IGZhaWwu
DQo+IA0KPiBTbywgZml4IHRoaXMgYnkgYWRkaW5nIGEgY2hlY2sgdG8gc2tpcCB1ZnNoY2Rfc2V0
X2Rldl9yZWZfY2xrKCkNCj4gd2hlbiBvcGVyYXRpbmcgaW4gSFMtTFNTIG1vZGUuDQo+IA0KPiBU
aGFua3MsDQo+IFdhbmcgU2h1YWl3ZWkuDQo+IA0KDQpIaSBTaHVhaXdlaSwNCg0KT2theSwgdGhl
IHJlZl9jbGsgZnJlcXVlbmN5IGlzIGF1dG9tYXRpY2FsbHkgZGV0ZWN0ZWQgYnkgdGhlDQpVRlMg
ZGV2aWNlLiBCdXQgSSBhbSBzdGlsbCBjdXJpb3VzLCBpZiB5b3UgYXJlIHVzaW5nIEhTLUxTUywN
CndoeSB3b3VsZCB5b3Ugc2V0IGEgd3JvbmcgaGJhLT5kZXZfcmVmX2Nsa19mcmVxIHZhbHVlLCB3
aGljaCANCndvdWxkIHRoZW4gcmVxdWlyZSB3cml0aW5nIGJSZWZDbGtGcmVxPw0KSSBtZWFuLCB5
b3UgY2FuIGVpdGhlciBzZXQgdGhlIGNvcnJlY3QgaGJhLT5kZXZfcmVmX2Nsa19mcmVxDQp2YWx1
ZSwgb3Igc2ltcGx5IGlnbm9yZSBzZXR0aW5nIHRoZSBoYmEtPmRldl9yZWZfY2xrX2ZyZXEgdmFs
dWUsDQpyaWdodD8NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
