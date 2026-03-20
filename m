Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A530E0D6
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773972619; cv=fail; b=RAoqAQeICl3cpr1i5JGZETPuAixkiv2zLHlxwD4BfK1S5OFNDLMdHNu9TV2wnFlqu8fcB42B0PR/t844+ZIJVkBf4aenoXIlOyoKRnDT54P8xqA8o8J+Dad/NAv2Q/3vUO6FBy2T6Q2zWVQrbaUgTnssJkZDBVc6DD2LeHiVI0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773972619; c=relaxed/simple;
	bh=XpeQoFvJMftKGbwm2wmYcUWwMUWqIGEzKOsHRNk2qio=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sqxoiZI9B5m2fk8BbB4B0CntnfYDrpI/Y7pHHM3g0eyQKL2brp0avINn4mq/LuyW51G9G17gQFsBVit9DDeyqUqYRH3nYeYAprjFseJUPALZ6nd1vDQoR3e43gQsskOWvWhG33z4KJi7Ebnab6UJcp2leI2Kw5dd9uRhSy1lh3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XtAc3wta; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rfTxd/Kq; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XtAc3wta";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rfTxd/Kq"
X-UUID: e9032b0c240111f1a02d4725871ece0b-20260320
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XpeQoFvJMftKGbwm2wmYcUWwMUWqIGEzKOsHRNk2qio=;
	b=XtAc3wtaOF+wA08IKBQmJo5f2Q7UYq55/V/meyYN/2I8hLyEFyGfYD3F5Nw03S2pkdW/ti6tHJpGmmjgSkTnt0Zj99Cf1IWpZACm8u6S1Lkn0aMoqC5+N3FtTB536uWa3cr0lNDGsIiEteVwC0XR7L01S6UdYxRSCk5oQZyN1SQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7e7b572c-3d5f-42ca-b1b8-031d6b19bfad,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:72f10094-f8ef-4ca8-bea0-143568f9ca1d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e9032b0c240111f1a02d4725871ece0b-20260320
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1822664164; Fri, 20 Mar 2026 10:10:04 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 20 Mar 2026 10:10:03 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 20 Mar 2026 10:10:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BvrGuZvTdlXsVEIcUP1hkXZQYwqIy7vt3JX+NL65QwliVo/7+SkephXlovIUUN5WJJeghdrWa0tBTlbjyMkHy4z0B48XtpXeW4KipkGqWiv2izR9Qz4Je8N+OYUdmOjqJ94IB8xFv2P9/2Cappg9+7ktHCIW8h5sVruSQKp8Holh4Dctddp8BEgqe3wiTiMJImyAPgUPy3teQEJ6Jr/QNTeUjS0qPzY51KrLFIHESp0XKbnay5Xd3CrfQHVZAPrhrRW9jO/Koq18iaIvtD5ana8TjW5w23MKPpTJ9MoCILzK0RzDEE3n5TM/R9OT/AzQauLSeFgNAlCUEj5CqSQkzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpeQoFvJMftKGbwm2wmYcUWwMUWqIGEzKOsHRNk2qio=;
 b=e0tx0e47fa2KBxMcad8wxSd/OS/QdHqMQ7GVUclyt3d3XJvJDnCy2xrZX17wh3M50260plmosYiLffhh/3Upfj+WJf7UEwwB9hcBgiOluJxM1Z+T3crcYgLEUDgWEJpUecS17HZFLco9zFXGyix7ws+SN0x5mHNZC0KUFmqXcqe73kSsI2+v19zbPJhTpd9KajfC+xr3h1UqWDzAzZIv69FiC7Mk+kfrSuQdfpRj4+eVw21YHAQhF1GZDTZ8M3nUaERCYcjjGCtciv08VrWDHxq7aEuTwtgrOgRcEVcEh3iGK/G/gXsl5qPrZw0V5IDPbZvBhyaPQf1Y89/fP5OG7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpeQoFvJMftKGbwm2wmYcUWwMUWqIGEzKOsHRNk2qio=;
 b=rfTxd/Kq1wAS3pBWi4FmDhIExfx5qzJ10PKXqQy3jamz7L2O/YpzONv4CwNa5zJh0u7xHqK5LIBHJHkzFoWzfAGpl2SLf1LvKQNGxoSFMO2k+uv4RdHQNoyk1NdK/E6vy3/IisMuSIZI1r2hZOF2zTCJcuJVC6r02cMxuv3/M1Y=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUXPR03MB9737.apcprd03.prod.outlook.com (2603:1096:d10:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 02:10:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 02:09:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Topic: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Index: AQHcrSxPGnfAtrpK0kOvBMCDgGF4JrWzB9eAgADmwACAABV/AIAB3IwAgACDXICAAF72AA==
Date: Fri, 20 Mar 2026 02:09:59 +0000
Message-ID: <48b704b7196fc5bba01d12418188764ebf23861b.camel@mediatek.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
	 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
	 <a341a70943ffb8b8c5bbc9b4e19c017fe664fdf1.camel@mediatek.com>
	 <473ecf74-1907-42a2-a785-6164720cb641@samsung.com>
	 <273fe7ab805f050ca185aaa9c48da7995f7558ee.camel@mediatek.com>
	 <e26d9c27-a2f0-4b61-8cac-56b404b884b3@acm.org>
In-Reply-To: <e26d9c27-a2f0-4b61-8cac-56b404b884b3@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUXPR03MB9737:EE_
x-ms-office365-filtering-correlation-id: 78c05b09-b224-4b1f-c6f6-08de8625ca3b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: QYAOfLlmjTkRLe5or2lukqUheEZvuiDlYuD6rG+GanUBHxWqs6m3UD2GTMfDzSTuEAevmLbq1/XUT5kvms4o407aqMoGAHtpjNHQ8q+dlu1JE02iGjU89AxPAq04hlYzMO/foms8h96any5nH92IYe6o08u7nvlIpQdtHkvlzl1WEwGyhjPpVKXKoguBakD94Zyxn3HXn6qZfCmI5cg4uHZSKLpYuAELJ9+QZK/YAzlzikYSlUHzkjxbMPhaRef7pfCHniEpALJt5tzipKvF04WvsC96uSgxUxZXlv61WHJidCagc/AYv7KAdSbeJ/YJuIvHoq31Ij4fqSwYR2FnZG0OsFwLXN7YhklPLo24YYVBD+h3wVrUwFD7zzI4L2p8RG8uXail2hvkGVZP5lm84JFSGpwCgbdDZjOACzCuoUnVBlnPPIwGMh6g+0P+r05LlTNY4RKuewHxhAmhmhEjcu+/UO64uaZnpIfBTKvAAqFhdF+8JcOtsQwgfoM+gO76FGlGXm5Hti7rmdc+n7hdGApz3QQa8OHuJUUgEBWyl5aEfsFw9jAAnBbRszr0vliC7kE3YKFFdX+q/bCy5fc4VuBH+trn3AfJNTmrsdSlcMHaoM86NDmLy2TWw3yq0nstPF3MTVKpuRPbUvrMy9kYsIGXNYVtc6Tta6R98vXb5JJ0PXqtlSY7NjebIkDpckC7ZaH1dEF4fOMSn0O+p6/oibWwIKKwXRBmYrQnpi5vL2TdPkNPPjFgiU3FVMm2ajAMz6XvPe1scEokLeJ2/gJaQpUrIYT18fJfEkTZxcU/Ujg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmFTWndqaWdFSzF2UmNreGRsb29naGxrODl1am9ZVzFRT3lpWGV3UzUzWDFJ?=
 =?utf-8?B?b3FVbEwwQ1haZGYwaFdmT1BFR2l2OFJ4OU9lUWFCWHQ5eldhM01LeU1Qc1Fu?=
 =?utf-8?B?U1JLVXpEa3dIQ1Ywdkt3L1RNMW1iTTRVWXN5Z2oxK054SjZnVnZlY1pkKzd2?=
 =?utf-8?B?R2ZWV2RzR2pkTllYTEprM2ZINVVyVDdteXdCTWVpdXU1KzlmZnlFMDZmMnRx?=
 =?utf-8?B?Yy9kaWwvZitFVklwdm9MRXZrWGFLSUdnYzZHWENGMmJGNlkxOEVJcUQ0RFVX?=
 =?utf-8?B?UXRtUGF1eTVBUFZDdHNlTTBnUWhCcGhnZHNScDE0Y2ZOenRQZ3VGL3RobUVo?=
 =?utf-8?B?UEt3aGUyWFVZbFk0d1dsZ1JOUzFDUXlSRy9UUHRSTlpGbFo5U2VPUzFIaDJ2?=
 =?utf-8?B?Uk0xKy8vZ09qcUxpeSsyNytKSEkwTHFNYkhOeUV2VVk4NDQ4blpVV29hWTFX?=
 =?utf-8?B?SEludWxITkRWZmVyMXlyZHlKZGpWS0dBMmdhZTUxajNjZ1Nxc2VFZG5vUm5D?=
 =?utf-8?B?WVFGS3BDVGR1eEFEZVJUOWVKeXBmaDV2Q0pkbTQ2UVEyQ3hya1Vyczg2TmV4?=
 =?utf-8?B?VWtmeVhNTlBGRFBBWk5pZVZTYmRxRG1sOWtDNzFoS05MaGFSRkFSOTF0eldQ?=
 =?utf-8?B?OGtiRG9VbkYxRHgyV0MyTW1PeGFRNktoeGF4WGlud1FiRmhoVGhZZjFtZDZk?=
 =?utf-8?B?WTcxZG92OCtqUngzZEZnY1Q5V3VwREJpd2VHWmhJc2c5ZUJrZUN3aEw2QWl2?=
 =?utf-8?B?RHlxK2RmUmN0SncrcHhYREl2TEhFZit0dHcxM3MrMWhRcGRJV1A0MGg5NGI1?=
 =?utf-8?B?WTdIRHRHckJGM0NVc1VySDUwVlVNc1ExTFpwS2pSNTRtYWVyS0hGQmdzTnFS?=
 =?utf-8?B?M3lrdENQU3hJVVNQWTJyTlhzWVhpeThia3MyM0RaRUhYRnZlVHF6b1c0SDJk?=
 =?utf-8?B?RERvd1RjRTRRL1Y0cjdDbExLWW9LTDRYZUUrZElZZDRnb2kzL0VYaFlpVGd3?=
 =?utf-8?B?ZGVJS2xWekdLYVVIUUwvQ00wdlFjR24xWHlwa1o5ejdodGFGTUY5YlJ4Mm5Q?=
 =?utf-8?B?MEV4S2MrWmpXV2d5UUJaSDNSbm5CalViaVJKVzRRbDhmYVF6VW01QjMxRXE3?=
 =?utf-8?B?MjVJMHBPUUNBY2tjaUYxSmhYb3YrVCttZ0phdFRUNVhtV2hkVG96ZnFEY1Ji?=
 =?utf-8?B?eVFoaThrOENWcWgvWGRwaHlsWE0wSlh3RnJjc29IOVJWcGJIUFVKUXUzS0Zn?=
 =?utf-8?B?SW4ydWdPRDJBRFVFRWVLUk1scUx4cU5WM3F1akJESUpiZ04vRFgrejUzcnRi?=
 =?utf-8?B?S3V1TEplWkhXYXFoamdRTHhjQjJ4WGpDYmQyUGRBdTRqNjFsYk5RR2x2YzZK?=
 =?utf-8?B?THVhL1I4WTk4SVlsZ1pKbW1EWlorUlpQQ3dPTnU1dnpmWjRyYWd5c2ZFZmdo?=
 =?utf-8?B?VjVGT2tGSnR0ZUxyaEVNSTkvemlMVlpUZ0pGblNIUm1rY3JxT0hIVGtkUGpn?=
 =?utf-8?B?MGJ4MEowR1RFUWpWVW9pSEZJd0lpME52a0h1R0dhTXd2YUcyeVJ2R1lxYXBw?=
 =?utf-8?B?VXc1YTdKa0FuZVQ1M21xa3NkSXozc3JJa0Rlb2NoUXBDNDVDRk9NMlNKdnNQ?=
 =?utf-8?B?T080QW92OVduVlVpd0lEY2JTN3hmQnJtYU50cGt1ZldWdjFOU1RnaUl2aFBJ?=
 =?utf-8?B?Tm5SYmlsMVBRY3Bxb01RRWNienBGeUdIcmFtVXFFQ0dhY29qdmpnMCtzQjJ6?=
 =?utf-8?B?YlpjYyt3M2VzRzdSTDE0U0xwYlRBUUh1UzNRNXIwSFdMUlhlMk1wd1NHVXhr?=
 =?utf-8?B?L1g4MHVmS3o1bzk0eTFNbS9ZdXF6Q3RvZ0lzUnhvVklESEwyVUFDaUxDQVQ3?=
 =?utf-8?B?b0NWYlBrenhBeXUrdDRVUWQxVUQvamN0eUZIN21BSkVWQjF3cndOYjZGZEZN?=
 =?utf-8?B?RkxwTEhZME00VlNZSVVjSjR0UHdRb1NzT1U0VDVPblJiQ0ZnZml4Q1RTWkFs?=
 =?utf-8?B?SjhtUFRLN0h3YjhWdStMLzR4VkNEd0RnOFhlcXFQOWZ1bWZWckE4NXpPdTEx?=
 =?utf-8?B?NklFWXVrV1d0ei9GRVIzNDlBQk1yYk9FSDc2MDQvdU43dXA2NWhPVnBhMzZF?=
 =?utf-8?B?OEdheGorT29IdW1kK09QLzBLRDNPOVpTSnhQSEVUOXdKcjVTeWJHaFV4aldV?=
 =?utf-8?B?OG5SMkUva3dXcXAydDZhY2lzTEtETUY2SzF2NW15MHErTmdXeGh0eVR2ZDFF?=
 =?utf-8?B?TUc3MGpLVDYwNHNINnBmdHE4WkFJWlNRZ2xXUExnNVJuSUFnTHpaS2V1VWd3?=
 =?utf-8?B?ZXlxeFBjck8wTTA4ckZvd3RTb0hRcU8yQUg3VHlsZzd4UkhTTEJHd3BJcUhL?=
 =?utf-8?Q?aJ3BESsUznM+x7xc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8272F3A62F76E74AB76C7849AFF8D74D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: jjEG13awkgRiP3PZW3PcTslDyhzTsLZ4Rg3njtgUSFH8zAct5QKc6ohKI+HmZhlG9voTdwBmUTAmavJTc8Xfm/YJTSomdqRkuFwxKeNM0qrf8o/J9JXQNuGp94dmj8wPoitFikLzSeEXbfbBYFWh+uz6+fYuUZ8fax1GkL9mT1NDEd7Jiu1eV9mLYooDr+uND7Nv6OfDC4gUeW4s/BN06+SzCm2x7sWYnTh83km/gGds1QsIF16Mw3RyYc/5U94QcQAhTwTGLbMdoeuJuxg7CWPVx6LP16io0PuAS4gpzl+J1TvBzuguDkK2eMILs1SaRLgm8429duSo1bn3UpejhA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c05b09-b224-4b1f-c6f6-08de8625ca3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2026 02:09:59.7413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1EWeGhAo6rl8KW62g1OhRt+k4lXdsROFK8oladQLWGrhat1qPuO0Rc7cBbBME8DYHGBRf91QZ3NLz8TKxyKGeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR03MB9737
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTE5IGF0IDEzOjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IElmIHRoaXMgaXNzdWUgd291bGQgYmUgY2F1c2VkIGJ5IGEgYnVnIGluIGxvY2tkZXAsIHdo
aWNoIEkgZG91YnQsDQo+IHRoZXJlIHNob3VsZCBiZSBvdGhlciByZXBvcnRzIG9mIHRoaXMgbG9j
a2RlcCBidWcsIGlzbid0IGl0PyBFdmVuIGlmDQo+IHRoaXMgd291bGQgYmUgYSBsb2NrZGVwIGJ1
ZywgdGhpcyBzaG91bGQgYmUgZml4ZWQgYmVjYXVzZSBsb2NrZGVwIGlzDQo+IGFuIGVzc2VudGlh
bCBkZWJ1Z2dpbmcgdG9vbC4NCj4gDQoNCkhpIEJhcnQsDQoNCkkgYWJzb2x1dGVseSBhZ3JlZSB3
aXRoIHlvdSwgYW5kIEkganVzdCB3YW50IHRvIGNvbmR1Y3Qgc29tZQ0KRE9FIGV4cGVyaW1lbnRz
IHRvIGZpbmQgb3V0IHRoZSByb290IGNhdXNlIG9mIHRoaXMgaXNzdWUuDQpCZWNhdXNlIGl0IGlz
IHJlYWxseSB3ZWlyZCBhbmQgY2Fubm90IGJlIHJlcHJvZHVjZWQgYXQgbXkgc2l0ZS4NCg0KDQo+
IEkgcHJvcG9zZSB0byByZXZlcnQgcGF0Y2ggInVmczogY29yZTogQXZvaWQgSVJRIHRocmVhZCB3
YWtldXAgZHVyaW5nDQo+IGFjdGl2ZSBVSUMgY29tbWFuZCIgaWYgdGhlIHJvb3QgY2F1c2Ugb2Yg
dGhpcyBpc3N1ZSBpcyBub3QgZm91bmQgaW4NCj4gdGhlDQo+IG5leHQgZmV3IGRheXMuDQo+IA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpTdXJlLCByZXZlcnRpbmcgaXMgYSBxdWljayBzb2x1
dGlvbi4gQnV0IEkgYW0gY29uY2VybmVkIHRoYXQNCml0IHdvdWxkIGhpZGUgdGhlIHJlYWwgcHJv
YmxlbS4NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
