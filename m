Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEE4279DDA
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755655360; cv=fail; b=oVxJ3BLbVlteThCNv1sOMDznOaR3wp3MfQTOXnXx7B6M9miLC5hTZd0idlIGahBCpMfyw0l+tJVDiV2JXSA2ff8vxrxTwdgDshY0wLYQa3/ywgkMUQRgYKS9GlrI9m2lXoMhq5Ja70Cwsi3RBQVcs7L2HGBhFJoeU9YaoiVHX24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755655360; c=relaxed/simple;
	bh=giJecN6ZQ4Sl+s0j7BfqfvfVxqveD9T/b0VYh0tpf68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hSJLui5xuvkospHivK8Xn5KrMs3Is3gqr9uYMJC2WLAuAfNwlNtVdn3jSuNXN5mCqtIWe7/O6DRr/cBuVnG2kYNTpOXi4x5Ik0yP/u+51VR1Cx6Ikj8kyM0bzNMKatrITcay4GhZ3CrDTJrR9AHlheBnwRJvXJRorEK1rgd1nzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cTGhOFrQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i3YpPDXq; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cTGhOFrQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i3YpPDXq"
X-UUID: bb0593287d6911f0b33aeb1e7f16c2b6-20250820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=giJecN6ZQ4Sl+s0j7BfqfvfVxqveD9T/b0VYh0tpf68=;
	b=cTGhOFrQk5fV/UHYMm0nQY0702xTm1wToqaH5wa6pCAo2SCcQ2QhsdOTK7nT3gigw32BfGnb4LJ7T3Wvp2mazM/O1zycQey7zbrcf+S1cHdhdDSkRxPaR867JPEgt3ZVr/IPM1ldV9julbHgqTFFf2O2mXN1VSMzi+PtrLXS32E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:b45cb85a-497c-4a1e-981a-bab66551e8b4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:2972a744-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bb0593287d6911f0b33aeb1e7f16c2b6-20250820
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1874148236; Wed, 20 Aug 2025 10:02:31 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 20 Aug 2025 10:02:28 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 20 Aug 2025 10:02:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRGVAU9P+juuAqyz2+72REB+4Roz0S2xJpIiZmysznldgtcVreymvs8V90cInnCds4x7EYuxH2AL7mAufbeL8nwijsg9icdZwwB7M/UykXraYx279dwimmo1DWbIyuWYFQI4iNQLVBeLG8twJ3fxSVZG0gpWE0dS0bPQUsiLMnuWJwOAeUjKww2bNU54Z3WgJms/mkNx+J4SG2hWp1uDK1vmtCQ4Yk564xDQljmf6IwH7knkVUQRwWIL4S56WE/9iz8Wl+62y3vbb6yPM+O2jdg2sFjQVOQXzYBQL5KjzPArkJJggGX8TAjneYNGcgRcF6vTBJa3Lc3trbBerc9SYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giJecN6ZQ4Sl+s0j7BfqfvfVxqveD9T/b0VYh0tpf68=;
 b=rhdHhLiLdA298KppJcLQjMmrb4Li0Ncj9OFCw1s2Q/tlFck/i4EnmXA5zgY4AruSpwkchrirS7qCHkZeuL6Qb4WJHOwhzt0zlnOew8REAgpCgWr/aBcpaJER+5TLKCrKFHYcZJfRwJOaf5WhM3bx8PVltLQPYAu3LdTkayEMjFamfgGsu6sbwOwfZlOSaoWXdICErMdKGnHQT5xZli1T2gnGR/6C9032ORzfGpL5beY49PcEyJSydRe1jyzCfe78cyLbrs3a1gVMPhkQdhLr7FhZhjxi0QQc+wiDx5YCV8st0/TSqdGBYBxlRrUbusADNO9lFq05+ldlYcVGZFfnbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giJecN6ZQ4Sl+s0j7BfqfvfVxqveD9T/b0VYh0tpf68=;
 b=i3YpPDXq85yCuGCCReZ2FnQsTuijPPmyZbVBLNGc+1qTi+ynozVWexqZraSypPVaMZ7ZdhJ9y0G0ryExjmEnHy23ofBH/it6YX+3IyfWmLigZscNaNKZoVX3lVJjYGvBeGXLN0Itoa7ptzPncTTNinBcdQgPN0ZIib8HcjcyLxg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8354.apcprd03.prod.outlook.com (2603:1096:820:111::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:02:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9052.012; Wed, 20 Aug 2025
 02:02:27 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>
Subject: Re: [PATCH] ufs: core: Reduce the size of struct ufshcd_lrb
Thread-Topic: [PATCH] ufs: core: Reduce the size of struct ufshcd_lrb
Thread-Index: AQHcESAy8n5zXqgw6Eyekj5IzxxhMbRqyrMA
Date: Wed, 20 Aug 2025 02:02:27 +0000
Message-ID: <0e9315e763f03c4672145f523e3290c36d03bab5.camel@mediatek.com>
References: <20250819154356.2256952-1-bvanassche@acm.org>
In-Reply-To: <20250819154356.2256952-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8354:EE_
x-ms-office365-filtering-correlation-id: 653039fb-deb1-4fa4-dcd1-08dddf8d9d2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?d0pWbmludE8rYnMvYnZ3QWptR0d6d1VOVjFuYy9ZcDREY3hqc1g2Z2hvTGJh?=
 =?utf-8?B?SDVMYnl1UnJZQyt2SGpSbnJQTGRyM2p2VDI3SUdRd21WYWdzc0JmQW50RVdS?=
 =?utf-8?B?RFg1VkJ2K2JGRWhNWXVqa3ZKaTN1cDY5M0RUNzhoRkVMTXRyNm1CcXhjS2xM?=
 =?utf-8?B?RE51a2dwbnhKU29SYWFROFJ2eDJzRDZlMXJmeUd2UU8zclArYk5hS1hUMjBX?=
 =?utf-8?B?Q1VwY3FNZjRXQlBRa1k2N2cvZ3gzN1JoT1BuelJVQjl1MUpjT0NHbHZ0TmJP?=
 =?utf-8?B?MnpBek5Id2tFbXE2ODRnejYxblVHMFhnL01MUEkxUHJaaUZTelY2RU91SmRq?=
 =?utf-8?B?SDlRMVlrbmhFalM3a3J3SEJ4K1RMQk1DWU5YZ2RBekFSNVFnalpZRWk4eWcy?=
 =?utf-8?B?eHg2a1NQcDNoalZVQ2Z5MHRwZDVDclJsc3gveDlyT0MrNlJ6dGZsbHNYRmd6?=
 =?utf-8?B?aTg5bnlMOCtycGN2aUNIZFpCbS9YeHphQTAvenRGVWJrYzdYUVNuTlpwa1ZN?=
 =?utf-8?B?SzFPY0ZmVGZITURTdGk2WWJsK0M1Mk03ejBBbzdvOXpYcTRPdFQ5Q0pMTm5L?=
 =?utf-8?B?TkVNL05rdUJrc1J4NE50TFJseVozWC9UMFNRc1FqOXJhb043YWkwNm5CVktT?=
 =?utf-8?B?OTI4NGY5Ny8xcUNLVG91YU5WTHBUUGFPUXBoUk5VOFFVSUtkMEJNNzFaRjRC?=
 =?utf-8?B?VE96aXprNFl4T2FFNlhPbThaZ09QNTMrenE4Y2FXbTE0TUNoTjVwbDkyVWpm?=
 =?utf-8?B?Zk14TkpNYWRoR0JLQldzeFZrcWN2TmRsaHYwdVpxSXc0TnFCbkR5TDRHZi9L?=
 =?utf-8?B?Z0ExTk5ZV1hndDdoc1FpM09KZk9BNWI3WHpNNURNWTBJdUJHS3p6VXVRRkxO?=
 =?utf-8?B?OUVKOXVZTWVJdXVHYnNZcUdHL3FiRkRrOHVPN1hLWmJKTURta1FmaWlOTHpS?=
 =?utf-8?B?RU4rVHJhdTdtMk15d2JjajJRc1dDUmRLSFJPaFVwZkZjTjRiZ1FJMVorcnZw?=
 =?utf-8?B?dDhoRVMzeG9rNlI3TEwxNWFJMzBXR3kyZmc2WGlFblhCVXMwVEtrWCtQTnNy?=
 =?utf-8?B?aGlsYjdRRjFmMUpHTEdNN243MkFuK29EVVBzN2Q2eTNmQjFQZEpGWENMM2FO?=
 =?utf-8?B?Nld6WERWcFloRGdDdHQ1RnFna1E4V0gyM2VQNk5xVEZzdzArRThiTWo2emNY?=
 =?utf-8?B?VlpQY3U0ZCtKeU42Rml4aU5KNGlDWVoyL05SZExlb0h6NEZEUW5mbUpCNzZm?=
 =?utf-8?B?NEhDeFFnMHVwTzNxOUhCZ3BRUkpWcDNNOXNialNtMVVTUGtEbDFIaGNueUF4?=
 =?utf-8?B?TkhuWmJHM3lJUUNGQ3dYVG00TVhhcTZ0Q29NQVVrOWpXcE1xMU1Idng4SlNN?=
 =?utf-8?B?R2F4U09NSitNN0FGRWRwMDZQM0NhK0dWRHJvdTJ6WEZaVEZHdWJ1bjQ5SkIx?=
 =?utf-8?B?WjVhdHJCSzNIUHRyM080bC90MFdZejdNQlB6OUNvTEZ4R0JOR1d0c1NrbEpO?=
 =?utf-8?B?VzkxczNBRHQydG9VMTFyNnpCb1JwdUJGV1lkaHEwQkgxQm1UYVFGOFIxUFBm?=
 =?utf-8?B?US9lTDJsUlV1c2dacTNRMDdLdXRIVWJXcVVpZHJzeDhMK01sY3ZUQmpldkdw?=
 =?utf-8?B?aVNSSEQ1SU5PRGR5WDBMMUhDNGdjMUd3c2xPUGdGR1hnSS9janF0OXRlMXZ0?=
 =?utf-8?B?OXZHaDllTzFURVNqUzJYRmMzZy9JWnhnWkFNVldNRzB1Mzl5ZUk1U2IrMTd5?=
 =?utf-8?B?akVkRmhVdG9WRnhDTnFieFFZYVBGR0trc3BweW9rUWdMdGxzUTdhSFFJbFVW?=
 =?utf-8?B?enlpRGVCNHdERVJ3d3Y4a0lpVzFDQWo5clJLTWdBYUV2bENYdjUwMzZ5U0tr?=
 =?utf-8?B?ejBqSjNRSzBsdlRucmZXbGo3dllSQitjNDBjWkx4ak9WVXM1MTJRS3lKZjcz?=
 =?utf-8?B?V1hrK09nYUdFb1lSM2dwM1NmY3h0Qkp3YXVPTEZvaVF1bW9paitpV3Y2Q2Y4?=
 =?utf-8?B?MVpWeGZzVTlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0JTMEx1TGxZOWx3RlNqY1ZSMUR2N1BwRWZ0ZXFEVHBFYWtqTlNSUU5HYjZH?=
 =?utf-8?B?bnRWbHV5Y09Sbnc1ZU1GQWxRZWNrVXlxV3hSZjZtUksxM090QmpodGpabzdR?=
 =?utf-8?B?MDU0WDVnTzJWUkNMVkJ2MW4vNDBhWkpNS3VMQVl2aGhSaG9weVlqU1FlbXJm?=
 =?utf-8?B?SEVIalJRTUtKalNMNnpKcUN0eWN1TVVuUng0RVJHYytsT3RUbDgvZ2VqeUhJ?=
 =?utf-8?B?TTcyWHZseWVGNWdKS0oyQW9TSjh1dW1ZUUNSTGZLUUc0V2lxTkRVTmNnUll4?=
 =?utf-8?B?eXB0eWN5ODlMa0tpeDQxcFNKZ0pqVzRJWnBZaGlmNWtFMWF2aEpIQzVVaWpy?=
 =?utf-8?B?SkpKOFBTL0pqQ3pNZWNoYmo2ZzZRSWtCNXRJZXNMZHB4eFp2SHVPRkRubFI0?=
 =?utf-8?B?NXgzcHNxUGhWU1RaWk8xUW9GdHB5QnRXYmVXN2t2ckNKN2E1dWlWcDNsT21T?=
 =?utf-8?B?dGZ2dk5IMEd0RVNrV25yazFLOWhRS3NvOEhONHJ5SURnYUlkaDZ0dnJVS0F1?=
 =?utf-8?B?NmpYRnBSUFpzQndWWGhMU0Q0VWRsNTArcDlWU25EbHQ3L0IvSnNsd3NoZEYy?=
 =?utf-8?B?aHJXRmNaMWF6M2FrbFpvTEM1cHAySWFBV0VBaDFQTkpFMXNJWFNjbHdSdzYx?=
 =?utf-8?B?TGg5UURsOC9nUy9DM3B2a1V1SGt0dTZZQ056b1hkQkR6MkpqN1BUekR2Rkh1?=
 =?utf-8?B?UC9iQlZ1MFlyQkRxcjVhSkxiMUpNc2NEeGlFVVcxRDBmLzJDQWlZYmhBejVu?=
 =?utf-8?B?azRUSldPOVpZajVGNWVQU2dWcEl2VVdIc1NHMjFmT1R0L3IrN01udnhmczla?=
 =?utf-8?B?NXpQV1M4QlhvZHU0cU13aDNaVnpmUFdqRzYwaklwZHFZQkxQZnE2a2hncUdX?=
 =?utf-8?B?Uk1OVlVYUm9WR1p5TlpXNmd2RHdobWV6QzdlWWw5bSs4ekcrNzRpZitmYnZ5?=
 =?utf-8?B?S3BWSTM2dGZ3cTdtVTVSUnlTTDE4M2xlZGRSRnMyTUM3TzBtL3NRRDBnc2tG?=
 =?utf-8?B?eEJGcnl3R1JKZFNnSDQveTJ6cURpUlpKRy9pMHRkUWNlSDBRcmhMVFlqdnhX?=
 =?utf-8?B?QjcxZ0NDckF0cjdLWDgwamt3eVMwZG1qdlpOVER6bnNrT0NoWFIvUE50RElt?=
 =?utf-8?B?QVJBRDJiUDI5bzdYak41a3pIL1ZaeVdhcXU5UXpWaUZYT2V2d2kvU3llZjZN?=
 =?utf-8?B?QWc2V2NhdEdpU1ljVDFzU2xSTitPbEFoMGlQNGNFUUZyU0F4Y0JhTmdLU2U1?=
 =?utf-8?B?OHRpMWZrYmpzMnRsWE9HOEV0bFE2T2UydHBYbjVoVmVkY1N6bXo5aU45VUhE?=
 =?utf-8?B?Kzl4R3lvQ0Z2WjZpcmNXZnU4TVJiK3lXc1JicXZaYWNHK0gyQlU4dERMVFJw?=
 =?utf-8?B?MFZ3dkEyM0o2dVJPN3VZNHVMWWFIN3dqdUlvNUplUDNaQ2RWOWtadE0zeW9I?=
 =?utf-8?B?UllzU2s5MHQrUkFKVmhDbW9GakNGQVBoeFVJYjkwam5IckRycmY1K0pYUDRQ?=
 =?utf-8?B?VzRDNTkrWkx3c0xqaWxjYVh1QnlvdjVkTjNCbGpGZzRXWThNdlZQWGRGNGVi?=
 =?utf-8?B?Vyt0a08rSDhKeXgzZkNNZEtLN1VjejhjanlLNENtOW1OUElDMzZpcnU4WTF4?=
 =?utf-8?B?QWZORWNwNjN0QWRKNUxhMWpjeUpEaEoxMitSNlI0R2pjN3FXZWxQeFB6dXRw?=
 =?utf-8?B?SnVGQmw1NHhBVWphamIzM01pM2RZWnIyVE5ZQ0ZnVEpDaXFvU1YxODhJRndm?=
 =?utf-8?B?MWZ1L05OR3YwTFJlb3Y5UlZYMVRnajVzd1cwNmUwSmM4WEFROWV3RTZxMjVw?=
 =?utf-8?B?NlRPT21ncnAxOFlPdjF5NUhSSDkvd2dhNWhjWXpRSVljU1JtVkxJWmlzUzdl?=
 =?utf-8?B?NXRsTXVtcC9nWUZtYXRyMHE4czdBNzI3QkNTeGthK2c4Tm9GQ2twdWZpUGpC?=
 =?utf-8?B?andrbGJTQVN0L3k1UHFZbTNTbURGeGs5c3l1RFN1Snh3V3dPcTFPSzBzS2JC?=
 =?utf-8?B?aDl2TU5qTE5wYmFJc0xlZHZ5MVJPLzZXT2x2ZmRob2N0VmZIdzRZRHRIU3dB?=
 =?utf-8?B?UDJBVTh4NEM4bXFmcncyMEpLY2hVamp2TEZrZUgvbUsxUFh4WnZpSHBLWXZ0?=
 =?utf-8?B?Tzh3NnFDeEkwQ2Vsck1uQ0ZkZmlpRldtUE00S3ZaMVZieEpxUVVxRzVZSkgz?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB7EE1305FC93445B302E34682BCD709@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653039fb-deb1-4fa4-dcd1-08dddf8d9d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 02:02:27.6807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fd2dF5lq9VVtQuoNpNmFvobPac/C1/bCYHKnVPsxv/s86dUtuvtR9S+hak1cqgeruA/3sTTM7Ia2iWDdzD25Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8354

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDA4OjQzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IFRoZSBzaXplIG9mIHRoZSBkYXRhIHN0cnVjdHVyZXMgdGhh
dCBhcmUgdXNlZCBpbiB0aGUgaG90IHBhdGggbWF0dGVycw0KPiBmb3INCj4gcGVyZm9ybWFuY2Ug
KElPUFMpLiBIZW5jZSB0aGlzIHBhdGNoIHRoYXQgcmVkdWNlcyB0aGUgc2l6ZSBvZiBzdHJ1Y3QN
Cj4gdWZzaGNkX2xyYiBvbiA2NC1iaXQgc3lzdGVtcyBieSAxNiBieXRlcy4gVGhlIHNpemUgb2Yg
dGhpcyBkYXRhDQo+IHN0cnVjdHVyZQ0KPiBpcyByZWR1Y2VkIGZyb20gMTUyIHRvIDEzNiBieXRl
cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20u
b3JnPg0KPiAtLS0NCj4gwqBpbmNsdWRlL3Vmcy91ZnNoY2QuaCB8IDUgKystLS0NCj4gwqAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCg0KUmV2aWV3
ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
