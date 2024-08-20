Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ADE282FD
	for <linux-scsi@vger.kernel.org>; Tue, 20 Aug 2024 06:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133649; cv=fail; b=M0hbmRK9AVvdgJpxwUhMSTOn6Nt6IemFdYF/eFKIbJU/W25OTrG/gtYXIco7QGwbcW6EV28Uteol+PIKBvSvfCwOvDlpUeMqemr6FOMbMk4hjyOXmauk/UqPYsqv+c+RZjtGzqCcDO123XSLuN+QMB9SK2GftP5MxBuAy6PaG5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133649; c=relaxed/simple;
	bh=ax3mBadCgfY3YmwFmJh7kvXMOGriasWWjydDWbiJ3jA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GOC6b6Q0k5NZ2oK6uG/uCKCfhvA4dmtkToSRRpj2xUFRItl6gY4S/LluAhLg7zOkVBNx9qkp5PcYCN9tNJ/mFPT9vHEE+AB/KB5vIdoYIP1qqzg2AMcoyppXyR34014yOe8oVkuhLohcaARnS9FKufY609wBKGlnCtelM23xq0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eT6yfb8C; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Sp5BFCHY; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eT6yfb8C";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Sp5BFCHY"
X-UUID: 85556d2c5eb911ef8593d301e5c8a9c0-20240820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ax3mBadCgfY3YmwFmJh7kvXMOGriasWWjydDWbiJ3jA=;
	b=eT6yfb8CpkvvleJbbuW+pR4XoJNVOjdKGzsMmCPdfPhCxvWcf8rnDXqjLob1SyJbDVABHFYWmzPW1mol7L2M/0oHCi5DiAC9pL94UkeWG3SXiX9SoeoiUyeMnj/56iYSMVi6qHGAW+aGM8ZYYk8xcQBJ7WKHenR4PFPErLiItDU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:de419f63-d8f7-425c-ace1-b124e33bbc39,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:8984dfce-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 85556d2c5eb911ef8593d301e5c8a9c0-20240820
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1890696465; Tue, 20 Aug 2024 14:00:37 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Aug 2024 14:00:38 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 20 Aug 2024 14:00:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dURCyzWWj1or2nL4Pt9jKJVkDeAQmiFAU/9J4CflHRuYPPTL4yaZihelDRWpJUoU/L6+rUBXvIoUOsUL1Z62lKxRfOvxEJMY9vRNewPqmRs622oQ6C5F/9OR65gBSE6X4LYPof8GTO1TEvvVvcPav9qPOmc7bBCX80a+g/V+rMSh/L9Le5knBFcI30IDKZAg3Sf5wx+uHplmrbNC8wrzECIHwy3wSpG7alHn1RiTsD5UUBom0LO7rFQmLvXUOjjk1yhe+MWtoh1EH8sJO99c3J0ctaeq4kfoiWSm1hZq/tgSJsvUOhla5+M7ZSkCSuwUjUo5WDDpzN+pbOHIUVYgXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax3mBadCgfY3YmwFmJh7kvXMOGriasWWjydDWbiJ3jA=;
 b=k0DfB9tpI9RXMZRtChdIQGbfuHtEBocS2fZXAjZafAIpKQaz/U/qqrdzub7Xgn3SV1PUqs9HLBHs+Jhr5ifiQxAHYyXCdVNrmCpzy0whuOe7dRDkIn3CzCrlaWddqdysthEytKlxT19YrjZ8OUyCTDGFZEdHEM3LtgiJqAEuQcBWOP51pPJxXUnpfUnH6nMtSi0G5WQTTvTitWLNN6A4+NFYjytd721QbrQDUeadX2PPVFiYF40LC9EJMXFXSrtGPn12Z/QJN0Xqo+xvFXGJHpi0nkXQiEssdJLdY3PB3jRdR0db9gEb8qD+a+vlJoOXw8xx1dG+SAUGbApOjKJUvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax3mBadCgfY3YmwFmJh7kvXMOGriasWWjydDWbiJ3jA=;
 b=Sp5BFCHYwC9Z2tnrn2hRm89AbkXZze77okmZoQgRMgmYAqQwFYCEliAT93Ag7w3FHkZDNo4QXlb10tB4Pjn6G5bHq32qWf6MXc1ya4/Q5k+9Iwr1LL8RAVSdCa8M/GZfSOIxyqUa9DrdNB24xXlqkOgbbilFmUYSgPJJrsvU4Mk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8254.apcprd03.prod.outlook.com (2603:1096:990:4b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Tue, 20 Aug
 2024 06:00:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 06:00:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH v2 17/18] scsi: ufs: Simplify alloc*_workqueue()
 invocation
Thread-Topic: [PATCH v2 17/18] scsi: ufs: Simplify alloc*_workqueue()
 invocation
Thread-Index: AQHa8CdQAgnxn9dndku8j1T4aMHij7IvrD2A
Date: Tue, 20 Aug 2024 06:00:36 +0000
Message-ID: <c7633caa78ee1ff0414209c6bc006228bb5ea734.camel@mediatek.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
	 <20240816215605.36240-18-bvanassche@acm.org>
In-Reply-To: <20240816215605.36240-18-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8254:EE_
x-ms-office365-filtering-correlation-id: 1ccf1fbe-9370-40dd-ddbb-08dcc0dd6938
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dUlXUHgrdWVmVkJ0OFJnMkhIbHdIRkg4K09FSzhEM09obGw2N0c0cTlrZFd1?=
 =?utf-8?B?SEFydWVJd2l2R1FoQkRiR1dhbHFlVFBWb1hwd3lTR0dJK09kMUswMCsxS0U4?=
 =?utf-8?B?VHM1TWRkSEpzLzQ1Wi9VbjRaVWFoL3A5VUZMRmtoa1dXYzhYQ28zQVVlTUho?=
 =?utf-8?B?NUxsWW1pSHg0MWI3c052MFpqSi9PTjZoWTc5eUdsNERqeFIxUjd2Ny9zK2pZ?=
 =?utf-8?B?Y1FSaWdXZ0FEeXd0YklSb3FkMTdrTElBR0g4UTU5KzBnQzhCZktnRWZSdVVD?=
 =?utf-8?B?RkJTeFkyU3doeVZDamNsSisybFdnUURhN1R2OWZaUEFiQkFqUXpPYlEwRzNZ?=
 =?utf-8?B?SmJGeFJ5WXRzTm5nWE5SbzhDVXR2VTlFY3I4dUc5cFdDakJPOGx4TWJSMWI4?=
 =?utf-8?B?dmFSVkVKdlVKRzZDSTFMb2krRllNOGlZL0NnM0V0WVNLWlNhMDQ1WEN4Uitt?=
 =?utf-8?B?ZHMzTFMrdUlDYUZqQTk5NjJwdWlET0JObFRXakVTc2dNREdDazI0TnpvSjQ3?=
 =?utf-8?B?YUpqZkYrRk1halI3VFhnR2p3ZjFJU1F5bFdFWldwTURJUTdWVHVGMSt5WGZx?=
 =?utf-8?B?OVVCVk0rdEpaWFV0VHJIbmlBSHBlNlZDOUhFY1U0aW9aSEcxdkhjL0p0K003?=
 =?utf-8?B?czRTQldkMmsvTkMxUHdDRFdrRmFGWGNHRG1BdFk2cDBDVUMvWEZ2NWVOK1B2?=
 =?utf-8?B?cGc1UWp1VkppL2kwb0xRZVdETWpiNHhZNG04Z3h5SXNXN0N6WGRXWFMyMWhK?=
 =?utf-8?B?UVBDUVZpUGZIRzRxb3gzK1ZjK01SNDk2eVRacE5obEo1bHluNDllV0Zveith?=
 =?utf-8?B?cHB3aElQZU9JS3lhRFNtdHZUMXM1cXRHc0pha0VOUStQc2ZvN0l4VHE5OGI5?=
 =?utf-8?B?azVRTzZQYW9WalhobUJjRlVnY2JjSFJ0cElxYkoybThJWTBLMFNLa2dTbjds?=
 =?utf-8?B?RndUY3h0bFF2bzh6c0JvbW1pSDU3b2xtcXA3Wm5Nc3JoeGtCVTNhQUlOMGow?=
 =?utf-8?B?NGtvcUJRYjVlTXE3YjNkZVJ1cjFkdXZKRHJlWkkyYU5kR2VyUU01eXAwYlVZ?=
 =?utf-8?B?cVpYYUZaQVA0MnVVUWg0cEtHMHBtaUlzWUVIdG9MdkVFdnJZQnk0MGRTWnE2?=
 =?utf-8?B?Znl5RXAxVGtnM05lTFBkVnlmeUdaWFNZdCsvVDZZb1NrSFI4c1dRMWJPSm0z?=
 =?utf-8?B?RmoyREhxSkx1SU5kRDllYS96d0hwbnNlamZEaGlad1hkN29qTXdkU3dMdlN4?=
 =?utf-8?B?MzdXRVhET0V0eVU1c0M2OHVibkExeWF6Skk1Y3NmRytOM25zOWx6WjJvU3c0?=
 =?utf-8?B?Ny9GTitSNndsWURWb2t3eGxCYXpDWmEzUVdxT1UzTTh1ZU0yUkdJYzZJYy84?=
 =?utf-8?B?NHlZQ3k0ME5mdDhyWDBYY1U3dC9aeklEa1BaTnowOVdlbnlUOHpwTmE0VDR1?=
 =?utf-8?B?TDN5WlVKc1JxRTczV0RRQU5XZVgvTElNRktLQ3JjMmZQeDU4L3p2QlNrd0ht?=
 =?utf-8?B?ajVycTdBTjFOaXJZcFpLVlZaTkYwcllYVzZBU3ZDc2JoM2xxNmtnNS9NUEkw?=
 =?utf-8?B?dkluWStXMC9wWGcvUVYvT210cDVBanlLUzVJSUgrOUdLd0ZuNFp2dW5LZ09y?=
 =?utf-8?B?WmJRLzQ0TnVJVEY5WTNObFVKV25ma0c5aTNjUUh6bVc5V2RkSTBIZUFGVWlJ?=
 =?utf-8?B?dktHZHdrcGZsV3NNSk8rM1RBaC9nb1R4T3VZZGh3Z0tranhGemFUbTljalNj?=
 =?utf-8?B?ZXhEWTdwMTRtR09maXlFMnhsMis1UFEyREpLWDI2K2pxcWIyZUE3dExjVzVj?=
 =?utf-8?B?ei9yR3N5WFFha3UxUWdzZHY1ZmlUdWNudWkwTVluS1o0em9GYU52bEdDdnIr?=
 =?utf-8?B?cmp6MFVhYm14bmpjbXV1R1hjM0thSmE4Q1cyWkp3QXJ5TlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0RxSXJzeU9rUzRJZzJpdVVIbjl4NDZUVWxIbWFQMHB1T3Y4QXAveTMrbzJJ?=
 =?utf-8?B?dnFqWGFMVWE5U1ViSjlobzh2VzNLd0c1T3h2KzB6UkxLK2NpaHloK24vbFJ0?=
 =?utf-8?B?bWJyU3V5QmI5QXhXRFpFbUZYTnZQTkZJajRGdkY5QkVVNklVZWdub21QcTIx?=
 =?utf-8?B?VDM0VDcyVUJQTWFBdWMvV2ZuYUozSDlzUUgxNXI3RlcrOXFsMzhCRGhaOVJ0?=
 =?utf-8?B?Rmw3VUwyK1RLMm9CUExmbnRZUG0veWFvZGJLR1ZPK25tV0MxZEg0aUk3VmZR?=
 =?utf-8?B?dk9zTXc1ajdjNFcyQzZHR0FJNDBYTEREN0Rzc0huTEROWTd0Mm9GNkxNbWpB?=
 =?utf-8?B?ZVl3WUZybERNYm1USmFZYXFXN0lqMlRKNDlWRnBzVGdYQ0N1TkhRSlFab3B3?=
 =?utf-8?B?RGpCSk5rVFdSMndCalQrdjQ1dDAwaXZ5VmltZnRHbHM0YktWa1hrQzhpVFFp?=
 =?utf-8?B?RTNTb2lvVnNzRGdta29Dc3BTSUVMbVlFOTdidnNpcjBJcUEzYlJ5RDgzVVZq?=
 =?utf-8?B?dGVqZ0JjL0ZZL3BEN0gyZ0pZWW5ZbGpLWXprRHNEa0tTdTRwZllTUldldFhH?=
 =?utf-8?B?elkyd1V4b2hDT0JWcitkWDJLT1RDWmVBSW9PTEJTZTJnYkdBS0p6cGc5QW04?=
 =?utf-8?B?TXRsNElTWXV1M3Nyb0lINFBuK1FHOEhOanUyblZSWG93S0hZOUhuM3ZSTFpJ?=
 =?utf-8?B?YTY2cVQ2V0JOWXF4SVA1WnpjMUMrOVg1R3dZWDAvRHVKMTRqZ3kwV0svN2tK?=
 =?utf-8?B?STcwTE4wZWdVNW9IYmpEUVNHdnpBeGlvVFlOOHZqQmZHK2xkdS9NdnVpRmdz?=
 =?utf-8?B?ZTBHQy9NSm1Na3B5d0cxbjRSbnZGYWRmekp1ckRvdlE5bEc1UGdZQXFKZ2ZM?=
 =?utf-8?B?VDdkNEhZK3VxYWY1MUVDUks2cU1GVzQwWWE2OTE5MWpaU1RtWitZQVA1eHpu?=
 =?utf-8?B?Y3hpVHpvUnB2ZWtUVXQxcHA1eEFBU3ZoTUl2OGdwWExtRCtDRDYxdWZHUENQ?=
 =?utf-8?B?bmwycm12b1prNVB0KzNZQnIweTlCWHpBZEpiTVBVZHVvbkN2QzZPSW5WQjNm?=
 =?utf-8?B?a2tyK2xjVlFZcGJKZkI4a01tKy9rTUxlN2V1U1QyTjYzQlAybk9wYnVGV2p5?=
 =?utf-8?B?b05uRWRHblJqOHhzZFkydndWZ2hKcGJCOFF3S21rVU9Pa3JKTGR4NHhoRGRX?=
 =?utf-8?B?eENnZm4vdXhXSDZpVVd4Wnk5ejlYTnpjdElyMFhMNVA4K3NvakViVFFYYXZl?=
 =?utf-8?B?bEVxc1lxQUtFSE8wUi9iQWV2NUJXbWJQUW0zODlQV3JLRkZkd3lkemQ5WmRM?=
 =?utf-8?B?NzRLTTNaSTEvOE42cC81Qks2UDZydHlhL3k1YTFzb1pVb0lWdzhreThrc1gz?=
 =?utf-8?B?SVRHUUNPTlppTFRDNmZjamo4VkFZazJhWit5MkgzNFZUd2k0eFdTUXNwdHhQ?=
 =?utf-8?B?SXZTZklaS09qWW9qdkJCdUljdEVBTnJTdVJXTyt0UEswWkdQby9EQnZRVFhw?=
 =?utf-8?B?ajBWbDdJUVdLdTFndk1zQmJsdTlZQitIS1FtR1lzRWFWdXJ0d0NOMkFHeWRl?=
 =?utf-8?B?dXRZOUVCRFZubVVoZGRYSTJ3SHpPZGxCOXlWMHJnU0lGdmlscHNMelpKazlM?=
 =?utf-8?B?RUM5OE9ibCs4TFZ6aTNzZ3BzcWorRGUxeHViSXpEdEF0ekFwVnBiRnFsbHVW?=
 =?utf-8?B?aVpRL2hLRVVQeVQ1QjBVM1RlaGt3UkxhQ2IrS3c3VW5tOGtvUHZqK2h3K3dR?=
 =?utf-8?B?YVJTMFpDTXN6ZnlnWkgzSy9oYmRlMHozcGJKeWJyY2MvcnE1d0JtSi9lRXRE?=
 =?utf-8?B?R3A4VVJSUkdNM2s2WGdzbXQ3WWVpOHI2d0JIVVVNRzcrc0dNc1JleVVWR09Y?=
 =?utf-8?B?eWdRa1dSaGdDYkNZS0VKL1huOXNRazkwSWEzZnVnb0FqbXRZTnliTTZIZVF4?=
 =?utf-8?B?NFNWTFRVRlRPSSt5LzQ5K1N5ZW42ajJKUFpqd05NZlU4TjNRK2VZSmdjQjN6?=
 =?utf-8?B?OEFDekd2SDY4Q1dKOVVHRkxFZ0IzWGxiOWx5cGpjaldGOGZ0WHp6YThGSGpy?=
 =?utf-8?B?NDhrZTEyb2trTU84TEpKS0JBTXlOL1pGVkVYYkVUbmFpc3JvSExxMUJHWHVJ?=
 =?utf-8?B?S1o1a1gwZ2I1TW44cTRIMGJqVlhTbHBGSXFnS20rOFl4dXgwU1cxQmhLdzFF?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91C1F7BF1E0C504C810CA3676E9E0F16@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccf1fbe-9370-40dd-ddbb-08dcc0dd6938
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 06:00:36.5157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFcIhayC2bSumWbS8WWuxhRiAUIP/fSuy6rFuMlj5lMCCcl3o358nnGull0ZCGlBplEK7I6zYJNMmQlPOF12sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8254
X-MTK: N

T24gRnJpLCAyMDI0LTA4LTE2IGF0IDE0OjU1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTGV0IGFsbG9jKl93b3JrcXVldWUoKSBmb3JtYXQgdGhlIHdvcmtx
dWV1ZSBuYW1lIGluc3RlYWQgb2YgY2FsbGluZw0KPiBzbnByaW50ZigpIGV4cGxpY2l0bHkuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4N
Cj4gLS0tDQo+IA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20+DQoNCg==
