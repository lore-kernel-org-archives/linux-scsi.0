Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BFA932
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759820496; cv=fail; b=OInelNHbGEAIebRpIEU79/YhukVllO5TkH9DLVRmrqApKar4KK9ZYxBJQF+32X/rLOmVwaaHIx0+FamSwmAtAWCjX6UaWK5vpk7onrhX15Sb7yInknEZx+mpTWq84NcdLkEyz/BETvSAnfRfy3bXl1BWqpOdTFeK+hVXlkm4pJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759820496; c=relaxed/simple;
	bh=UsNEBiaZI73/G8G5LmPT9cFioVGptTWow/N+a5LqwyU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eE+szBNLnclGg9OSej0nnmPzlA+GGBgdGihteLuR1eZLPmprPNZwBhTP8JG+io2nPzkQwCGlWzXfXobsht4qM12s/VhuwzGdhI4N359ttDts9+lzZyhcQHrBxV9J6sKTIB9ysvH8Aa1ZnO8oP8Tl/iDiBln2RXjCIr3myjxZC9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=juKPsOdG; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=eMDjo0OK; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="juKPsOdG";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="eMDjo0OK"
X-UUID: 6df811a2a34b11f0b33aeb1e7f16c2b6-20251007
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=UsNEBiaZI73/G8G5LmPT9cFioVGptTWow/N+a5LqwyU=;
	b=juKPsOdGOdEBuova/ieVcD6y0leTB7HAnlX5AwSgYs6Q3697g/MKKoKK+Ia0cSnSBdNtYbBd3qEW13bW1Ikl6uMaJgzCJZNO9o6a115NF0VfomvnkD9fMwzvozlZRyvhf8N8f2tM/kzqCxdxfU2MeLzff+P7UbpbLUYYzPlY+go=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:cd41e79f-fded-4853-9dbc-1102a3db4c02,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:d7e2440d-cc8a-4e53-aa28-1b6b12a69d6c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6df811a2a34b11f0b33aeb1e7f16c2b6-20251007
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1097857435; Tue, 07 Oct 2025 15:01:21 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 7 Oct 2025 15:01:19 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 7 Oct 2025 15:01:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1VGkoLPUE5MRPWQVV8YgVG4IA9yFncGELR5m2RyPlbga5O3x2P3inTUYFIKD0lx2EZHgVYBeDKO4vXs0MWdqCZVdaxxjO39SOw/+YeqOic+BjxLePhoNi71p+Im7f+zmjhfcjSStxrUHr1GAYkbnA9xk5R4+APzCPXjviu1illDWbp0Yad5LOeCq91A++agqTyoY9WMjZzvnGbGy+ure28Dfc8Fy3dC0f56ZlMNI/d9wZhdpmW89M1/LC1WHLiwD9dtMUz6qAadB0D7jfob2hjhZzXJUcssV6dAW/dClyg5M6dgz+MWDkSUcd/erNcCc9euQS7WBYMWHOnLndgBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsNEBiaZI73/G8G5LmPT9cFioVGptTWow/N+a5LqwyU=;
 b=Uc/PDGjYX6fUBZ8c8l33v93TiUWAdt8HygrMpkisCJctKUGm3LZ1EJAonAx4LQ9rQH/ksIxyXeQ5pcLbZTmLpeiNxg8LgLenezvAWFspfem+VEXY+PA5nJBtnrlOLKmS4us5/SzkQPJe1CM1uzziCyhnvdj+CyZZtwjfsmEtS4l7TYMYObaqKZTA0ZS7OeStOcfUT6wLExe9b8/7YOGliDaA0ZrJuOL0MWo/tIpvQgIwqDTKwjsGUoxhPuzFfkliI0UTKgFVy4pC2wQJJcFj7nkimpeAQjCVwLfkLO5LjN3GsjPHMkEYd/aIDtQfwTDgg0DICO3H7PVj935O8MO8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsNEBiaZI73/G8G5LmPT9cFioVGptTWow/N+a5LqwyU=;
 b=eMDjo0OK6rXSnd4obs3TojtnTI7hkFjTlc3fswHfHJO/AUTSi0Yz3c3dsJ1vTiKn6+aa27IFqASM0+5oNTAxyqcOOCiAh2CGv3pV3U6uJw5+KJ0doeaZn4ZhdUuYmomXJiZSZUyKhg55ztADNYHVAISMb6DCgCJFtzV+8+MKbMc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB8330.apcprd03.prod.outlook.com (2603:1096:405:1a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 07:01:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 07:01:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
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
Subject: Re: [PATCH v1] ufs: core: Fix error handler host_sem issue
Thread-Topic: [PATCH v1] ufs: core: Fix error handler host_sem issue
Thread-Index: AQHcNE3xfnA5Lp3JNEepwG1XYGUBJbSwmUEAgAWudoA=
Date: Tue, 7 Oct 2025 07:01:12 +0000
Message-ID: <c5c8293b093a7d8f03fc8b25059b5566214a8c06.camel@mediatek.com>
References: <20251003101115.3642410-1-peter.wang@mediatek.com>
	 <3e673104-d36a-4128-bb5c-a71093eda419@acm.org>
In-Reply-To: <3e673104-d36a-4128-bb5c-a71093eda419@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB8330:EE_
x-ms-office365-filtering-correlation-id: 80e5002a-93a8-4433-bb40-08de056f4d5b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UWdyYUJtODQwaW5PQ3ZXMDMrMnZXSUI4V2c5K2FZL29DbksvNlFSNUlWMkRE?=
 =?utf-8?B?NWJmYTVlNGN1UWgzZEZzZkVJYk1NN3VlaW5EWm15Nlo4SXQ1b3NXUEZDRy9p?=
 =?utf-8?B?aWFIbGFRVHNsclJ4NS9xNXJpODFHWSsxeDZ1SWxFSU5ybjBqVlNiMFVLdGd6?=
 =?utf-8?B?eHFmakFPTkRNRGRDcEJQcmF2UDN5MWFjY0Z2Kzd5RTMzTEEwdVQ4Z2phQU1z?=
 =?utf-8?B?OE9uTXRRWlc0eHdoR1FkTkliWlZLY2k5MExxbW8xLzVVbHhyK3l3T1lrRWNw?=
 =?utf-8?B?ZllCcUVQR2hLNEh0V3J6cExaYVRzem14VktRWVdMdGZqdmJaTmhJNi9POWJ3?=
 =?utf-8?B?VU5jNHY5dWtrSnJ4ekljNjhIUUhkRmo2L0Z2djNGWFJqUDVUODFuc09jc0Jv?=
 =?utf-8?B?QjdhbEM0eXR1OU9VMUtyb3kxNS9XU1daOFJaT1dzMm8vczN5alkybnNsSzQ2?=
 =?utf-8?B?UDg2bTJsRHBIQnZSOGVtUytscnM4aXdMRHo4cW9adXdjczFMeWNkb2gxS1hF?=
 =?utf-8?B?bUJheTlUODRLaTJScCtHdXlRSktKTm9PelpzNW9obmFMend1M3ZVa2xDY0hN?=
 =?utf-8?B?SUdGMHBzMnJGUTNTY1lBNDRHU0hZSUlqRG80M0c3TlROZEVSRGZPYzloWGJW?=
 =?utf-8?B?ZWk3NG9sQVArcG5Sd3lkaGJjSzJYOVlvb1hESHpHSENPUXY2RElpT2p6NFJa?=
 =?utf-8?B?WmwzNzVDQ0lFa0pJRDRzWFVUZEpDVENRWmxDTStuQ2tLUE54eUtLa2kxNCt2?=
 =?utf-8?B?b2hTUUROZm1QTTVocEpqbkdRZUcyazFJb0p3YlR4aXI0bTRibmMwa1hFMnVH?=
 =?utf-8?B?YWoyaVBic3lXTCtjNXZIZ0svbVc2UnE0QmhQQm1ndXJMVm9kWEN3TnV0c1g3?=
 =?utf-8?B?ZjhvYkMzTjdaTmlHa1d3WFcrRnlSNUhzcktQaUtUanRRWnNYTEdncXZOY3NB?=
 =?utf-8?B?eDRtVGR6b3NHK1M2aEFpZUYyRHF4QlIycVV4NDZrYzNVV3lPdUd5dEpDaWZt?=
 =?utf-8?B?T004UWxNb1ZNN3BmZ2lCY0lydkhsanpTWHVTdHB6RThjMXlqV3owM3J4cytJ?=
 =?utf-8?B?TzVDaERqSnk4eW56TVlGNUUyVW03Zlg2QnVJbTdGeVBML0NWTThkaFZRNFlm?=
 =?utf-8?B?QUp5ekRSZmluSURablQrbW1vQVdTS2RyREJhbGd0b0MwVnRINzJka0I2eGl3?=
 =?utf-8?B?bHphR01lbzA0UERrTk4xNERMdFpsaTBtTW1DM2podGwwaFFmdmZiUXdzTDZy?=
 =?utf-8?B?eVN4cFE4czNNeWRLZ0QxVm1PM2N5SnZ0MDh0ajY2N2ZWOS8wRXJBcTkvSXRV?=
 =?utf-8?B?cWdQdGRzeDVlOFFyS3dWVjRHQzJHYUVrZi9paXNQZmFXQmtnUXQ5WVl4aUtR?=
 =?utf-8?B?M1FMN0NJWVVhR1ZBWVRyNFNwcHNnem1ZdVpXNlRMMjBuTmNqdnlTYjMyYnZj?=
 =?utf-8?B?Ukt3dCtqbmt2SHBMOFNocUQyNXUwcXZoM0Z2dGtUR2ZmajlCN0VGSld0bXRZ?=
 =?utf-8?B?Z1E0L1dyN3IvVUZJK0lDOFhTaDN2UXpoUTk0aTdNU3NmdWJ3QmI1MFpyRHVQ?=
 =?utf-8?B?SHNxVXdwaTV2aWJ5cmgxZ0ttWEpaYllMcXdpWU1NZVZCKy9NR3d0UjVMZUM3?=
 =?utf-8?B?MStvb0ZpL3ZSK0xHUTlzQUpDV1FNMTlBNDk2VnU5bGZCL3BOMjhKeDExK3NL?=
 =?utf-8?B?aHdNUzJpNkM1bk14bllXckllWlFIWmlKMUdjUmFpTVErMzJ5SlpvalRESXBz?=
 =?utf-8?B?R2NrWGhMTmxzd3hXVnBULzNrUFVuYUVJUUpJMzV1VGNHRXJyRm5wQldBS1o0?=
 =?utf-8?B?N3ZKSHZTdXkzQVJBcUpkWlRJVzJPL1liZkFDQUtrTDB2QVM5c2NXTHRabFdW?=
 =?utf-8?B?RU9ZMXVzN01EOWRnR0lQVnR4UnlacGZvK2o0Q1Ayb0NPbDBYeFV4QjVGelVs?=
 =?utf-8?B?dVNxN3ZBVllEQi9jdVdreWdUR2VKeWxmY1pqc0h0eHZyK1QxVERYdHhBVDI5?=
 =?utf-8?B?UTdndXNFalhsc2YzQkVuY2F2VjExZnNPSXdUWjlzSHQ2ZXJyNUhLMWJtYjlt?=
 =?utf-8?Q?o1mnjw?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejNWMEl4OVBOVVZ4eDlhanRVSkh3cXRjS3ZoRG02bHJONG42b2Z0VlczMFpY?=
 =?utf-8?B?SlFRaUZCUnUzYjhWYm5lbmxRMHEvNWhBeHBJelI2MTRWSlp5elhJUjdDWU9t?=
 =?utf-8?B?UjU2eUJvdkx1RlZHWUR3YmxqUXZXeENoaXlJbkE5UE9zaGpYcTV0OThUeGhr?=
 =?utf-8?B?cE0wL0lHWUJ3U2RZdGViQkxHUmhsMWtDSUdiQm5nUlc1YlFhdEpWMWtBUHdK?=
 =?utf-8?B?RFNPWUdnRHZMODg1OHRDd0FNMzF6NWpkRlB4WldDUkc2VEZiVWZSL0JMUHcx?=
 =?utf-8?B?bnlrU3RxU0YwYnRmR1Uzcm1aZGhKbDNjY1o1QVgrSjM5L0J2eVZxOTB0N2g1?=
 =?utf-8?B?bkVmdklFR1JFeXd5dDlpTSs4WU96YmpWbm9ncUNuQU1KSTdwZmlkM3JRTGpF?=
 =?utf-8?B?RUJlK1JTZXVGWmJBeWR3TWt2UFJBcW5XL3BTN05scWhpMFJsWDFTdHQ3UlRT?=
 =?utf-8?B?VWRWQ2YvTXVUZXM2cW9GQWkwVWN3L3NkbzZQUTZ5NTBpSjlrcXZlSlBFdGpo?=
 =?utf-8?B?VnptT0xuQXFhVkxhSnNrOUkrUXQ1b1hzeC9uUWlKOXJLVFNQd3ZqN0JJYUVK?=
 =?utf-8?B?QW5NcWM2V091SkNuUGhhenJoVHo4L1hEa2t0SmhTSUdreWJOblZ4eTNCTlVB?=
 =?utf-8?B?TWc0TVF1a2QrUXpOLzdzNU8wd2o4MEpxN3ljVEFSRXVHRGYyQXBobUF0MFpV?=
 =?utf-8?B?aHVLd2Y3QmFodzFCbGZ3b0tVYVJWRGluUXFJMmc0L2w3b0VUbllNRzJzRVd0?=
 =?utf-8?B?cEJkNHRUZFBpdWE3SUFDNVpvZENteGVhNFp5VDc5UGt3dUpkNUlrcUhocDN5?=
 =?utf-8?B?Tnd2NjFicnlxbmpVY2tScGN2QUdvL0lrL1V4M2x6dXMvZDZNZE9LS3NxTXRp?=
 =?utf-8?B?a3NjenZPdWRkTlVXNU02UWUxYUVKcHBrWTRpR0lkMXMwSjA0U3h5aThkQkx4?=
 =?utf-8?B?V09MMVZ5b0Q3OGJ3SjRmY2VFeC9rVlY1RWJxWnhVY0RSdWRRUkdRZElabmlo?=
 =?utf-8?B?bWIzQ1kva1pwMmowMlBVUWJnNk9ReU5jUVRYUW91TGlNWjBvWU9JQVhvaEhu?=
 =?utf-8?B?ZG1PQW1ScFZZNkNSMU1BSXZmd2V3VEg4Q3BTTE03QnhCalNTcDhQMDBXSjBu?=
 =?utf-8?B?bEo1OVh0dWlFUEFUUmFHMjZnZmUzSmJITlZSdUJIcGdBV29FTTh5dlFQQmpn?=
 =?utf-8?B?d1hzM25pNFNHLzNMQWJkeWp4YXFZR2pKdTFvZmRKYTlUK3pqOXdUVEJVOExB?=
 =?utf-8?B?dXZFa2hoUXV0TGFQU0YzS2kzNmozbjljZWhOMXRXbWoxbGJHbm5DWThWcjBh?=
 =?utf-8?B?Mm5NR1BPQlpqUjRFOU9TV0RnbU8xQkFNckFtM0NBZENTN1RvRm1Lc2E4N0R3?=
 =?utf-8?B?OU12ODJVeGEwZmpEZWNwSlFsTVNhWjR6ZUN6aldlT1g5SGd4QUloK2JSVnVR?=
 =?utf-8?B?UjhaWm9wYVdnb1Y0ZlRiU1hmTnVJT3dCaG95OTFydnJ6NG83QjFLSmxnSG5G?=
 =?utf-8?B?ckdXVm1ySUVySUNrRjdkZEgwb0kydkI1Rm5xK0VDWGYyS2wyTWF5VEV5OEVk?=
 =?utf-8?B?ZzBpUitRZ2QvUktETjRQYURYUWs2WCswOTFTY2EvWnE2ZjFTbTArbkpnc0RZ?=
 =?utf-8?B?aVN3bVQ2ODhWU2w0bWxZbGFQbFplaWtrdGdMaTNjMHMzL0VrR0U0K3lkeGFh?=
 =?utf-8?B?c09xakNLMFloUHo5NFJOZG01eFRnK0t5dTYrbS9vL3FKMWZUTUkvcUFpVElQ?=
 =?utf-8?B?a1V3a0IrT3FYUDNOWE5SQS9XZUZwUkhtN0V2NUJSamN0ZWJuVUNGdTEycmw0?=
 =?utf-8?B?M2JzMFVJRkJqNm8rWENxbUd0R1NTSFhnY0txUmtOMWRoTjY3NThhUDNUQW1r?=
 =?utf-8?B?aW9GRUVuM00yK0tvbHdvd2E1M0ZPYXdyaGhtRTNLK1BhSFJYRHd3REN1RWVW?=
 =?utf-8?B?YVp5cE9oMjBUZzlSUHozUFpjS21hdW1DcVFONDhlRXhZaVBadkxtREVKYTZW?=
 =?utf-8?B?M0F5VDFNSlVMdzNCSjNsSm04dFYrUHQwdGJFcjRuTFJjZFg0TmRTZGZwVTR5?=
 =?utf-8?B?L3JHdTJhV2pibldaYVhhWUNhRUtBbFRxdG5ZSUpqNzQwTkMzL1ZYRy9EeW93?=
 =?utf-8?B?bEFaOFk3QjZZdTlVZmtGN0V1RnEzRFRTYUZFTEE1U1NpOFZsSmZPTk92T25G?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09EC0917DBA51B4FBBE4CD1CA868BAE4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e5002a-93a8-4433-bb40-08de056f4d5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2025 07:01:13.0428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //3pzBQeV5RUog8nQeiCahKVoWU2gMnS3aewCxcE+8ggXBVs5q8BCmLZEdP30SggxJ1J7jyT6Hza9Ap7aC/low==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB8330

T24gRnJpLCAyMDI1LTEwLTAzIGF0IDA5OjE1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZSBwdXJwb3NlIG9mIGhiYS0+aG9zdF9zZW0gaXMgdG8gc2VyaWFsaXplIHBvd2VyIG1h
bmFnZW1lbnQNCj4gb3BlcmF0aW9ucywgZXJyb3IgaGFuZGxpbmcgYW5kIHN5c2ZzIGNhbGxiYWNr
cy4gSGVuY2UsIEkgdGhpbmsgdGhhdA0KPiBoYmEtPmhvc3Rfc2VtIHNob3VsZCBiZSBoZWxkIGFy
b3VuZCB0aGUgdWZzaGNkX2xpbmtfcmVjb3ZlcnkoKSBjYWxsDQo+IGFuZCBoZW5jZSB0aGF0IHRo
ZSBjb2RlIGJsb2NrIHRoYXQgaXMgbW92ZWQgYnkgdGhpcyBwYXRjaCBzaG91bGQgbm90DQo+IGJl
IG1vdmVkLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KDQpIaSBCYXJ0LA0KDQpObywg
aWYgd2UgdGFrZSBob3N0X3NlbSBiZWZvcmUgY2hlY2tpbmcgcG1fb3BfaW5fcHJvZ3Jlc3MsDQpp
dCBtYXkgY2F1c2UgYSBkZWFkbG9jay4gQ29uc2lkZXIgdGhpcyBjYXNlOg0KDQp1ZnNoY2Rfd2xf
c3VzcGVuZA0K4oCDZG93bigmaGJhLT5ob3N0X3NlbSk7DQrigINfX3Vmc2hjZF93bF9zdXNwZW5k
ID0+IG1heSB0cmlnZ2VyIHVmc2hjZF9lcnJfaGFuZGxlcg0K4oCD4oCDdWZzaGNkX2V4ZWN1dGVf
c3RhcnRfc3RvcCA9PiBzdHVjayBoZXJlIHdhaXRpbmcgZm9yDQp1ZnNoY2RfZXJyX2hhbmRsZXIg
dG8gZmluaXNoDQoNCnVmc2hjZF9lcnJfaGFuZGxlcg0K4oCDZG93bigmaGJhLT5ob3N0X3NlbSk7
ID0+IHN0dWNrIGhlcmUNCg0KVGhhbmtzDQpQZXRlcg0KDQo=
