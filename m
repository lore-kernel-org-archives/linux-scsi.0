Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EFD8635E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739411943; cv=fail; b=ntgYdtXctSFKsgIa1VVHcqntSxy+UnyE+QQrhFI7FkPjGkKHEiRCw8vyg40Qvho/ZL1GixFykz63d5fxx8Vc3AvEzqKKRCsHJ/pNPUSBDcx9jOB7i3f2y1PY78AGVwuCg1j/vFvvHPqwVijP47dr+bvfXflpw4oxZfgF9QDjGKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739411943; c=relaxed/simple;
	bh=TTn3t3P47ga/vgwE+Nw997pjQzt7SbPKLAgWwnrgdbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EiSZI3/nK7NiY/H/6GeKKxWj8YJkTCILfrDw0KjpHnx0fhrXH1O7hUXtL3+tWeALHi3w7vqITJwsx50fY6dmMhbXsK2I2uSmNfDza0o95WUEZlmwbE/fXpMFHzffM2oGChj1xHHhtQWI/fKfkpjeH4h3bKN0ttPuPKACEK4ckXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Qd/YiIkn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OU99gGvF; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Qd/YiIkn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OU99gGvF"
X-UUID: 14dbe7a8e9ae11efbd192953cf12861f-20250213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TTn3t3P47ga/vgwE+Nw997pjQzt7SbPKLAgWwnrgdbs=;
	b=Qd/YiIknU+CZrp93qT8PIzPKEF/LSo0IrsT1CPQa0g23EKG/vtTwDj0AYA0Fqm3N1g33YxGprZKsunyfpql9b8oe+UY0v8G7hcmrKTzIH4yIrK11I9CRBx1TAVZye0U+JkTl+VAzEYZBb7ExpTt7vA4w8igfeUuSa+TVhLG21Kg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:e95b739e-f762-4818-9b25-2e98592098b3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:cd747c27-6332-4494-ac76-ecdca2a41930,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 14dbe7a8e9ae11efbd192953cf12861f-20250213
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1319496091; Thu, 13 Feb 2025 09:58:55 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 13 Feb 2025 09:58:54 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Thu, 13 Feb 2025 09:58:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcHR2enCj+wD5Xv/EUK5odkU9dMUxlh1EJj44ZedfWgcvYhuS9omaS5GPzjYurGJZ2nBS1BhGH/34klGMPvKgPhkzGRxiSuDm5iew2kYYwGo2TGEDoXhDAonP3TVkp0oT1i+apJ9iM1eilcd8V/BpHpsIZGmnPWy2vDnFELuiQwg714yfujJWmpkcOAmRqh/vl+j8y9p0lhVHfxRftM5ispEaO8EgHtiIP2Ao3MzmNMJ6Z6Kzj4iA5Jn1cUHGb+1Zy2G0xVlwQFidL3iqFs7nZXAVKYd1WmZ73gih5NabPaGTY2oCGxopmyMSzFdmgKeXn+70wvitKOjTBu4QaXrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTn3t3P47ga/vgwE+Nw997pjQzt7SbPKLAgWwnrgdbs=;
 b=JPn76yGgCbxxVZiqyYKasmshabYJDt0jBU64Iewv1+4Oade5ncrljxWDB4EXAzl9iRgyuVcIjzKPvcSohhOjl0twMtEaTkYfIHwRryB8vHrOH8WGkxuhxE5lCw4/jAHrIsxfYwDOtojMP3kFLkKFXG3OdFmt/6lzx/UbhkuRTRYEs2OTnOBYkfyd9IH+Maym9fbYY8OyPmZXVs6edeB69pBRio98GeVMIgzCkm8jyuMH4BhoOkUGxLFmgPRDycw6pCSk7xVFcxb8G5H8sBrlCR6i5SCpmjSAnj97LoAc7Ds9ZvACd5c0tUcqI38lgbalXhu1YoH99ez8LxbP5IVy2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTn3t3P47ga/vgwE+Nw997pjQzt7SbPKLAgWwnrgdbs=;
 b=OU99gGvFAYwGfGgVFiRi6+v6ExivHjmxpSBE6HrGL1sGbH/vom7bEy+wzhqgYFetJV/TJeeja8/7cMzIaNqt0YIkMMuA8uvsRs/Hcpiki9+w5CiJp0vtJUmHaA8dQjUEpSSDptw2OXqlPS1q+hWtu55YqC46M3VK5zDfXpL3mf0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7148.apcprd03.prod.outlook.com (2603:1096:101:ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.17; Thu, 13 Feb
 2025 01:58:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8445.011; Thu, 13 Feb 2025
 01:58:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "sutoshd@codeaurora.org" <sutoshd@codeaurora.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: add hba parameter to trace events
Thread-Topic: [PATCH v1] ufs: core: add hba parameter to trace events
Thread-Index: AQHbfTdZOCgi8ib3AUSALhG96YK/R7NEBVOAgAB14gA=
Date: Thu, 13 Feb 2025 01:58:49 +0000
Message-ID: <b3efb32a6fbfeadd9d9c98fbce5024e3e85264a5.camel@mediatek.com>
References: <20250212101723.716477-1-peter.wang@mediatek.com>
	 <2fed801d-9cba-40cc-b50e-7ec9de041f1a@acm.org>
In-Reply-To: <2fed801d-9cba-40cc-b50e-7ec9de041f1a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7148:EE_
x-ms-office365-filtering-correlation-id: 25076485-17e7-4bf0-6243-08dd4bd1f539
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUJ5K2ZLRE9FVUFYYllYSWtmL0ZpL2pmRjVaVmdkRVZYUFl3TWxuWkdHa01M?=
 =?utf-8?B?Q1hrVjVrYmdrdjBBMzZuZmxrbkVjUEI2Y3hzbWxDRDNZTXh5YlUyUDlIbnU1?=
 =?utf-8?B?T1BhU3dQa3J6NDNzdmJsRkxCR2E4bHVCdmJJRXgvbVYvQVB2ejUySVAyRmZv?=
 =?utf-8?B?cGQxUlNqUldOa1NpUXZPNkJKYjBHMlVjRC9FT3F4STNUMFN6MEd2bGtLOGsy?=
 =?utf-8?B?SldIVDVhZ2RtQlJNS0ExN09JVmprWlFVL0dQQktJb2g5RVZ0dGlnYkhDbmw3?=
 =?utf-8?B?aDB5ejh1RUM5azBNNC9pWnMrQm9QVkVBZWhZTEw5bmdIWmdaQkpWWWNxUTdU?=
 =?utf-8?B?NnVPYW1zL21BNEVxd2VPL1B4RGQrZ0hoY3Ruakw1MjVISUR5K2FyTmUxb2sy?=
 =?utf-8?B?a1gzVWJDN3lmZythUkhNdjJ6d3R4bTNJMDJPZUZJaWU2cTNGVy9Td1M5RDVi?=
 =?utf-8?B?R2FOaDVYODBMUGNDYU5TYW1JbUtKS2pibG5TWW9GTmZDWE5VcjQ2WDZKWXZX?=
 =?utf-8?B?ZXMzWnVLVTdMZGlOQ2JqczljUkZ5UFQ0RVhBbUhKNmJlTFNnRFl3N1hKRTNW?=
 =?utf-8?B?R0xJVUdjSzB4elZ3dFRlaS9yblZLV09OM0JUN2EyaGx3MFNaYUtTSmx0eXFk?=
 =?utf-8?B?TTFIZndSSVQ4bVBkd2JBdk9zNlN5Ylh2M1dBcnFsUVN1U0Qzb2drQWowTmlv?=
 =?utf-8?B?VWMvUTZZUnBjMTh2UzcycHlPYlJMZXI1T0huVGc3WUgxNDVMcjFXWDdBKzJZ?=
 =?utf-8?B?SDVnUitWa1lOektJRDlLN3dNd3g5Qnk1aFM5UU9LdjZid2dyYkNmaFBTUTZN?=
 =?utf-8?B?eVNNOU9KaC9lVWZ1NEdLbVIwMHZMUFo2YzhvVWFIZzNzWnFDK3ZiZkNMZnpt?=
 =?utf-8?B?L3Z5ZEZRSytXNk00b1RaS2NDTjdiaEp4VTgyZFZUek16ZmxVT2VCM2RFQSsr?=
 =?utf-8?B?NkZaNEhiaVRkai9DVHdYNlZ2VDBZaGlGTi9jbnRQQmI3TUxqTHplNXRYOEtx?=
 =?utf-8?B?MzcveXE0VHdYNXN5T0pndzJvK0hpM3dNYWl3dW51VUhDZmpkZkx2SVFCNmlC?=
 =?utf-8?B?VDJZWURuRjc2K1JabnU0ZFVSZGU2Z3RiR2ZjNTVEN0szN2kyWlA3eFQ4eDJX?=
 =?utf-8?B?dGl0TmJvczN3KzhndWR1ZzFKTnJqT3NiSUVPS3k4N2xYK3htN05sNjc0YTJr?=
 =?utf-8?B?ckIvZTk3K25YUkpjT24xUVBiR0s4c0hHQkdtdXk3dHh5Mld6WFlSeGNJc1Zr?=
 =?utf-8?B?UEZlalFYRzZnSHloY1ArWlE4d0lGeS9Xcng1eXZJRFN0YVBQdlFSdVNBWkh5?=
 =?utf-8?B?bnZRZ2NlclZmRjd2aUl0R1JxWWNaV2ZMbTdqRTVHblRiSmdRTFRFSTBHcFF0?=
 =?utf-8?B?UFQ5YWovM0NmTnVkYUx2ZVdZV1lkYTEvMkhTWEFqbnlYYzFNZGY4cW5nQ3hQ?=
 =?utf-8?B?eG1vZHY1RmxoRFJRWHdEcHhBOVBWK08vUnVOQldTUjBibWRiSTF2eXpFcUc2?=
 =?utf-8?B?b1FTdEN0M2w5Y041bDRZblFTQWMzWkU4aURjenZiQU9xYkQ5VWladlFRVGl5?=
 =?utf-8?B?cENGT2t5Vll0SFd1YWd1OUs1aFMybWZ1VWpEdFAxd3RpZHlqK0pIcWdLUXVz?=
 =?utf-8?B?dkg4YmxqV1V6Y0hjaWVSRmJ4VDhjWEcwZkMxdDhWZmozSjBpMCthQmJ5YnhN?=
 =?utf-8?B?bHNmYk4xMjZaNEw3My9mbXNiTEZtTjNOcHJhd1RBTGJUK3lGcHdXTURJcWRS?=
 =?utf-8?Q?Gj9ScAMXvKJ1J7sgJaQbAlC2yIFXv8jmOOpsfJq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUZBNHMyV3dOdUluV1U0NHFWaDg5RytseEQ4dzZzbWpxVDRUc0RtR2VSMHNJ?=
 =?utf-8?B?c2hTM1R1YTRVblRtam9NZDJiTE9zOGRXWmJZSU8zeXAvNS95QkpCVnVNR0RI?=
 =?utf-8?B?RFZNYlZGTmh2dSsvWGIraE1aL0c2TkhTdUVPV1p1eUxuQkdKMDNnTW13NG8v?=
 =?utf-8?B?VWpaSzZWTHJXWE9USjVJd1piQjY0cWtuOHNiNW1nUTY2OEFFQVh3L3Erc0hH?=
 =?utf-8?B?L2xSTjFyb01jcm9EMDJKZTNsUTZRekRodUg2ZVdWS1pWQjBRZ3M5Z0VhY1NL?=
 =?utf-8?B?WkFmcW9EZmhuUWE3NUczenpJWUxKTmZVMk9HMG03d1M3TjZNN3hIWlh3WDVu?=
 =?utf-8?B?c2NtSTVLTzZIYjAwelZuUWZ2MXA0OVlTUUF6dFZ2VEVVbHFEVVVMNFBMK01V?=
 =?utf-8?B?SmVNbGgwY0xOYUpMWUJNenhWOU5vVjQxcS91NE9aMG45alBLZ1hKSmVhUmpN?=
 =?utf-8?B?NExCK1Y2Z3NZNjJrRHo1TUJxZkRST21uWVI2SVZyQ0hIVzcvcFR5U0dnRTgw?=
 =?utf-8?B?S2RNMUI4clNwUTV0eWtVeE9BaTkzeXpzbDdiZkVUWFR0Mk1Sd2RGN293YUtn?=
 =?utf-8?B?N2l3c3Npd3Z0OEFTK0pBU1VtZWpYZXhvbk0xajBLRC8yM2RXalRmZWZZMUFK?=
 =?utf-8?B?SnpnODJoZGhCOWdxdzNDVGdLUlJtRmkxb1pwUVc4dDdhdFc3TWZvQ3NrY2RL?=
 =?utf-8?B?ZGZHSXdLdk12VDRzeHZ0eVkvbUVGcS8wWEZ0dy9RekJnTnh4MitnRVBQK25O?=
 =?utf-8?B?SG1NajJjRHRPOFZ0UXM1Wm9DY2VZV1VlK2xwV2IwZ0RMbjB4VFBNMjA5eDVW?=
 =?utf-8?B?Mmt5dEpGcXY3akVpbmRlZ2oxaVd4VGNDNW1TcXFVeit1K0YzcEJMMks5eFJ3?=
 =?utf-8?B?VVhRbXZNYWdUcWhPWk5rSVE2TC9qWUo1R1BJMG5YL0tkZmtpYzBEWXRmWDFY?=
 =?utf-8?B?STdyeE5HSGtlTTJIYU9JaWhlSE5RTklvZTdGeUFGWUgwbjR5Z1pPYmEvZzQr?=
 =?utf-8?B?Njk0MTdLTW43dThDVVpJU1JobklFZWYxS3pzL2Nvejl5VS9kemU1NllHWG1U?=
 =?utf-8?B?ZGtjSjIzZDhWeUllZVlZVXBCR2kySnNobnFCUUZsamVLZjdIR2ZFb1c1S2hF?=
 =?utf-8?B?MXBiVzNOcXNNcDlNOEhNcEFGRjlyU0dNczhvTVowbFgzWEZMdGVGN0dGNnRt?=
 =?utf-8?B?YytJRFdEeEVHSTA5N0I1Vkl0NnhyelkxZjNGLzhEMHBOQXljZUt5cXRSc1JW?=
 =?utf-8?B?eVBjeEllV1lhOVdIRW5VUUNDaFlsMnJqcnJmNld2ZEp4MlpySitlRkVuWHR4?=
 =?utf-8?B?a2xWd25ZZDZRaVlHaitGZ3FvZ3JSV3Urby80YjFHMHVsMkp4OEZlaXFUNFlv?=
 =?utf-8?B?QWNHUGtVbVMzRUkyUXBoMll0bGhWQnZhbkV2RTJKUGJqVjZIUVV3Mkx6dERs?=
 =?utf-8?B?bTR5aFc4SWF5dDNIenhMN2VwQUZKZnZ4NnhMYmR6ckEyWU42MUpNcVdQaDBs?=
 =?utf-8?B?VlNvc1lTbjhtYURtdlZKdGZ4aXlVU1ptTEIzR1JHRGFCdFpLQ0dYOEtFUXF1?=
 =?utf-8?B?UTdIU3d1eFlCa3lWbjJWeTN0K0I3L2FCK3hnYnU3dEJjdnhSU3lKOFFKWXB3?=
 =?utf-8?B?azlUVDZTR1B6eUxtcHVxbzRldStaakxVUTV4MU5yZm8yWkptdFIyUU91bmxM?=
 =?utf-8?B?MHhERlBTNmVSeExhWkpLMGdHdGFyNEQwTW5ZanllaDBHMnFLa1lKM3dHeUFQ?=
 =?utf-8?B?a0p4QjFMNVR2Rk1iRUZuN1BIU0ZQNFBDYXRhdEpuaG1maUdlMmdUWlQyb1Zs?=
 =?utf-8?B?ZGVCRmJmY3ZKWUdHWGQxYkE2ZmgwVGljZzhmOXlpOStHRzhVQmtldkJRblpi?=
 =?utf-8?B?MHFPUkJXTHdFejJZbzh2blpNY0Y0WXpkZ1h6VEt4UWVDK1E4M0gvK2x5L000?=
 =?utf-8?B?UTZlRGM2ZEV4cmhJSlhKb1k1dkpQVllzbjNoaFhKQys2SFYrcm5SUjBMK0dz?=
 =?utf-8?B?NHM1RFhoZXpyS1FDUG9oSWkwLzd6NDFZcG1JQUxhTmxyZmxQUDgvWlgwR3ln?=
 =?utf-8?B?ZUltTENwVFFCVlJNVVU4STR1b3dlMFZSWUVXdlZkYmdHRXlMUm5aL0EvazZQ?=
 =?utf-8?B?b0VkSTR2dWpXaFJNc0prbUpnY1BmeTNubjFUNi9MU2FuRnpKWVlhbFVlc0VT?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35AD05770827B94CBFA1471B291D2372@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25076485-17e7-4bf0-6243-08dd4bd1f539
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 01:58:49.0750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BLgKH+jY3Ys6iOh7b1MK9araOqIP9tu241sZ3sQlVS1N9qvZZRNro1q4P3CSBaDps2o6Hn3rl2G23uvFomwyog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7148

T24gV2VkLCAyMDI1LTAyLTEyIGF0IDEwOjU2IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDIvMTIvMjUgMjoxNCBBTSwgcGV0ZXIud2FuZ0BtZWRp
YXRlay5jb23CoHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc190
cmFjZS5oDQo+ID4gYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc190cmFjZS5oDQo+ID4gaW5kZXggODRk
ZWNhMmI4NDFkLi5lMTc1MDIwYTJmY2MgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29y
ZS91ZnNfdHJhY2UuaA0KPiA+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzX3RyYWNlLmgNCj4g
PiBAQCAtODMsMTcgKzgzLDE5IEBAIFVGU19DTURfVFJBQ0VfVFNGX1RZUEVTDQo+ID4gDQo+ID4g
wqAgVFJBQ0VfRVZFTlQodWZzaGNkX2Nsa19nYXRpbmcsDQo+ID4gDQo+ID4gLcKgwqDCoMKgIFRQ
X1BST1RPKGNvbnN0IGNoYXIgKmRldl9uYW1lLCBpbnQgc3RhdGUpLA0KPiA+ICvCoMKgwqDCoCBU
UF9QUk9UTyhjb25zdCBjaGFyICpkZXZfbmFtZSwgc3RydWN0IHVmc19oYmEgKmhiYSwgaW50DQo+
ID4gc3RhdGUpLA0KPiA+IA0KPiA+IC3CoMKgwqDCoCBUUF9BUkdTKGRldl9uYW1lLCBzdGF0ZSks
DQo+ID4gK8KgwqDCoMKgIFRQX0FSR1MoZGV2X25hbWUsIGhiYSwgc3RhdGUpLA0KPiA+IA0KPiA+
IMKgwqDCoMKgwqAgVFBfU1RSVUNUX19lbnRyeSgNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBfX3N0cmluZyhkZXZfbmFtZSwgZGV2X25hbWUpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBfX2ZpZWxkKHN0cnVjdCB1ZnNfaGJhICosIGhiYSkNCj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBfX2ZpZWxkKGludCwgc3RhdGUpDQo+ID4gwqDCoMKgwqDCoCApLA0KPiA+
IA0KPiA+IMKgwqDCoMKgwqAgVFBfZmFzdF9hc3NpZ24oDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgX19hc3NpZ25fc3RyKGRldl9uYW1lKTsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIF9fZW50cnktPmhiYSA9IGhiYTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBfX2VudHJ5LT5zdGF0ZSA9IHN0YXRlOw0KPiA+IMKgwqDCoMKgwqAgKSwNCj4gDQo+IFdoeSB0
byBpbmNsdWRlIHRoZSBIQkEgcG9pbnRlciBpbiB0cmFjaW5nIGV2ZW50cyBpZiB0aGlzIHBvaW50
ZXIgaXMNCj4gbm90DQo+IHVzZWQgaW4gYW55IFRQX3ByaW50aygpIGNhbGw/DQo+IA0KPiBkZXZf
bmFtZSA9PSBkZXZfbmFtZShoYmEtPmRldikgc28gdGhlIGRldl9uYW1lIGFyZ3VtZW50IHNob3Vs
ZCBiZQ0KPiBsZWZ0DQo+IG91dCBmcm9tIGFsbCB0cmFjaW5nIGV2ZW50cyB0aGF0IG5vdyBoYXZl
IGEgSEJBIHBvaW50ZXIgYXMgYXJndW1lbnQuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
DQpIaSBCYXJ0LA0KDQpUaGUgc3lzdGVtIG1heSBoYXZlIG11bHRpcGxlIEhCQSBob3N0cywgYWRk
aW5nIEhCQSBoZWxwcyB0cmFjZSANCndoaWNoIGhvc3QgdGhlIGV2ZW50IGJlbG9uZ3MgdG8uIA0K
VGhlIGRldl9uYW1lIHdpbGwgYmUgcmVtb3ZlZCBpbiB0aGUgbmV4dCB2ZXJzaW9uLCANCg0KVGhh
bmtzDQpQZXRlcg0KDQoNCg0KDQo=
