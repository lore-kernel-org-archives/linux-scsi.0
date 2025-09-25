Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E476227FD7D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758794621; cv=fail; b=eERSairOy1T5Hmbab2nF3ys1kgujBN2/YkACwXhhh/X0YErf2jXYo+KSCou/TQklzccLZCRNjo6x6UMQadCNenftWoeJ6FtKH91DbKpg8WYjg0E8IRvKDFAfnD7fOPvk5b1toEOI9Wrz5EBqptaYFxYZp9/SoKhLPVzXoc0vDEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758794621; c=relaxed/simple;
	bh=28WVZ+Bkx6liREuFasZGwt9GPxgdQfoYRlRCRt7jx9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jKSYceVQP6iJKxGsiEMnOeyeB14Z0OZ8GRIzG9ynjxyUtV6ynFLpkfycCyn2mLTQZc4vwXhO9aUblBuTFX3H5pu4DxIcFSqvJrhI4CleezXFUzSTUi3IQmU5od907aaC5vwTDmTbeYygjlO2ApRTFIHEsavWTe741JXU6GIyUhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Mmai629Z; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=O4soQ3FX; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Mmai629Z";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="O4soQ3FX"
X-UUID: e1f2bade99f611f0b33aeb1e7f16c2b6-20250925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=28WVZ+Bkx6liREuFasZGwt9GPxgdQfoYRlRCRt7jx9I=;
	b=Mmai629ZNPYS7shiLLnbyjT+m3FKkqDP3+kmqhYgZe0O+cZ6JZR6z2I3ucGtiVSgBUI6Krjgi+Z4zC36ZA4gq46W4u3bFdn7oifQ6JrJTiGZSKYmpzyk/0IqQJXw+c37tQpZGcmZxUU/SeGwoNQKP5EGNXWmNW/DJsM3jngmBn4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:110368fb-7e9c-4cec-b5bb-4469160e2547,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:0362aef8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e1f2bade99f611f0b33aeb1e7f16c2b6-20250925
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 553799065; Thu, 25 Sep 2025 18:03:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 25 Sep 2025 18:03:24 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 25 Sep 2025 18:03:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzVmmdGdOapmrRHVRLT+HocYRASowMyt4DpaSoAPrwz+3Q+2LCx3+8Iia8k5H34Bbn+7MI84In82Awvijpb0yjIpGULSD/ThSGQenW5beMz281x4oJsrNptxAsp+BN7jFPXXKJ2cxJaD2+zVwugRofsyJUee89IMgNquYKIaFvV53bE5MxUmaRMcU8n7xvY2x8DmiWK7KZvdo1L5CJIy7BejMLHkuDsvFyoo7fVjVQUxSbLRz5A8dib6q+VMtDVc7jX8eOnRj+SMIj6uA51vQomzXkPheXoHmNNabzcipw/8AruicWyRySCS96m33BbfkKHe01tbh0nf0Gknoe2mcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28WVZ+Bkx6liREuFasZGwt9GPxgdQfoYRlRCRt7jx9I=;
 b=QaPSo5xsaq8MOuvf6MQ1j9PTIgQ5e5YjvEzX+/rBMqIvcvQPTF6ciRNUx7k4aWB25kS2J/QP1BnwB3pdcKokL2M4Y4qtYvgq9vc0iHVYTdm3zbafuO8LPk8xJgKMXI851QFdOLHSFksZIOF/glyYG2Ta4Ebx9+B7SUVeUPulbunG49i29HeygE0GxEWkx74csOsMdd/kolZTxUqin0MR3JS63/B5EqHV6tOnlspqA46iunGNRxvej7c7CIBrKsUhmQthNlZG0Huy7NqnvpLikvHKUm8BhzaLSUNO89J7+PY2lpGrRBW6aajBxgDocYBs3bVizZ9VFU7uoKbPiIlybg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28WVZ+Bkx6liREuFasZGwt9GPxgdQfoYRlRCRt7jx9I=;
 b=O4soQ3FXUIUF/2SVDWw5heQuT2YBGHzmlFyjAJuDkWWhPvMXaBtLW1fvGmzB3jsh+Cs/Xe5rqxW/YdvUqWWAPke/G0IMRddZKmG6YGHV+29xFueo1pzGYbFZ/1+T8C1EUofIVT+RPuOi8Mkc0Vb2x9HzOTFSbGKMYl0gVM8qbPg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7114.apcprd03.prod.outlook.com (2603:1096:301:104::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 10:03:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 10:03:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
Thread-Topic: [PATCH v1] ufs: core: Fix runtime suspend error deadlock
Thread-Index: AQHcLGMd6+SljMTAGUerWxHWzkJ+3LSg73AAgAEiYwCAANARAIAAzJMA
Date: Thu, 25 Sep 2025 10:03:21 +0000
Message-ID: <a6c52b9f7f3f7e1e17a0777cbb0bedcf32b284e1.camel@mediatek.com>
References: <20250923082147.2491450-1-peter.wang@mediatek.com>
	 <ecc17025-692d-45fe-97eb-9cc4c4ce7a06@acm.org>
	 <2ab086da45acaab5ff6ff5117670a8ae65d2f0ca.camel@mediatek.com>
	 <c2b02246-1ff4-4882-a856-4af888f1a80f@acm.org>
In-Reply-To: <c2b02246-1ff4-4882-a856-4af888f1a80f@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7114:EE_
x-ms-office365-filtering-correlation-id: ca5339ec-c3fe-421e-d17f-08ddfc1ac274
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a3BFeVhDR0tlejhNdUtWVDhudlM1SVpGVUY3ZmF2KzJTZVord0tMNlhwWUF0?=
 =?utf-8?B?a2xYZ2lSWjV1NHdyVTd0b1FiYUxTcURtR1NhckptWUtoWVNyLzFibHZvR0E5?=
 =?utf-8?B?d0VGN2R6STBLTUxJbUlwVmFvcDVzK28vWXFaeW4rN3d6bklWSFVpRTduODJr?=
 =?utf-8?B?dHIrWmJxQXNMMDRtdEM4SnBGYWxwY1U3K0E0UFFVbFAraFR5UTMxaExTRUVv?=
 =?utf-8?B?MUZjWUdPK0tMWENGRmlySFVMdlhFVVlNcEx5NE5CeERtdVFVdG9jNmtYbEYw?=
 =?utf-8?B?ajdYRDh2cWV2WW1YcUNRSkZzSk5OV0F5d3hzSnlZVmVieklzUUwvSTgwWG1H?=
 =?utf-8?B?c3Y2QzFxVktqY1hzc0hYVk9pOTBSRWhwN0FFRmhLYjNONk1PVWlFY2Q5OGxU?=
 =?utf-8?B?R0Yyc3cwUk9VWjlkZWgxdWRnZ1RncTZnYysrb0NXRkpMSi81K01yT254S1l2?=
 =?utf-8?B?aDBLMDRSR1FpR1F3WkNEOXExdE0vRmtaSUtUUGxBMnE0RlI1U0UxWXdtdlJK?=
 =?utf-8?B?N2JDM0R0SkkwSWJjeFoxNGEwVUluSDVKK3k1dUJMY1ZScGhVeUc1d01meWpT?=
 =?utf-8?B?ZWgwQkJrWHJYcUtFTFJQQ1hBWERIUnU0S21Ra3RoRTZZUGZsY2Nwbi9rcnZP?=
 =?utf-8?B?RHNCck4vQzNyWDR0TVJ4akx6ZEdTUzJkaEtRblQ5VHBYQlY3bVRsS0hvN3dk?=
 =?utf-8?B?TFV4cUxqVmFEbzZ2MysxMDRPeTFxVkY3cVFXR0czOVdTeFhJS2JkMU5PaHdB?=
 =?utf-8?B?RTEvT1IyYnVtQWxLR0Q2K2VNbnpGLzZid1pDd2phUlBjdWhpUy9aeHJTOXlL?=
 =?utf-8?B?d1FaYk0zR0ZEWExsd1haVVVsVkllVWJ1TDFLY2NJYWxqd1JBN3UrNEUvSTl2?=
 =?utf-8?B?RzFVZ0pXc3I0dW8xU3N4SmpUQUNkN2xSZVRrVWlVUmwyWWV3aUJ6TTQxTWo0?=
 =?utf-8?B?NFlGaW54N3BjV3lCdHA1VElhSzg3cDRJUDdFa2U4RlZKeUpUWmpjdjBqOVc1?=
 =?utf-8?B?Skc2bmFtMWJ4Y2hvUmNyK0NaTHRMdlZjek1pWkdiMTFqbFZIY0x0V0ZPaXZR?=
 =?utf-8?B?Y08zUlFRejRpTEZnM2oxMjRtTjZmTVNIUXRuUGdVMXVyY1RFVmxhNWNzZWlS?=
 =?utf-8?B?VDVXb0lzTDVocFhhTWtnN0hpM3dTUjdJWHdzU2tsa2lrRkdNOEZLWGc0Tlk4?=
 =?utf-8?B?N0N3UkdER0RCUk9XWUpvYkZLSkdlMjhZd3RTNE9JYVFnWjlCTWZudXJCNzRo?=
 =?utf-8?B?TllWU3B6bEZyVnQyYUdtbnJCaTEvUElFMzk3WHlmQlplWHJpV1RMbHlTSFZO?=
 =?utf-8?B?RXhRL3E4MmRzN0wydzM0ZG5UQnU2cXJNQlN2MTJKaHBqSHg1Ymg2VEhBdUJq?=
 =?utf-8?B?YktmUHJ1WXUzMFJNVTdRai9hRHNwM2ZwNG5VdmpKV0g1TG8ydU5qejZWOWtm?=
 =?utf-8?B?NWkwZmpSMzhheHVSWGlSdlVPNkJ6QjZyV2ZQOTlxZWhmOVdtR2N1SWlnOW45?=
 =?utf-8?B?WkU0Szc2UnNNbUVKWVdWbzVseEJXVGlVMzlvZlltenlCcmhUYVp2RnhSSkM1?=
 =?utf-8?B?eDJHUEVCQ1FyRURZeFRaMGhlUjl6UzhQY2VWYXc4YUZPR2IvSUtwUURwQWEv?=
 =?utf-8?B?L09ib2U3aS92N2h3Mm82SVdtTlFaUVo3MVFQZWZBOGRXZ0Yvd0pMVkFTdlcr?=
 =?utf-8?B?OGhnaFBqSTB5dG1YczNYVjlyK0UrNXFtRngyRGJrcEMxR3c5cEVncFMwaVJG?=
 =?utf-8?B?MmpOcHVYMVBhZ1EzTkVZNjhnQlZhdnVESlVyczVzU0o3NzI0NURMK0hTVEJM?=
 =?utf-8?B?by9wUHNheFRDY0dYTVN2Mml5OVJYT0czaDdXMCsrU2lVUVpxcVJYQjVSOXZR?=
 =?utf-8?B?UnBtTG4vNkdSV0pFQnVLRFlhQ0JCREFuOEJlNTlTaHpnREF4MzlkS29GVElX?=
 =?utf-8?B?Tm50b0hnNHo1ZktERjFuanpyRWNDbXdYcDhZOENLbkpXdiswOHZkZ0swMEd6?=
 =?utf-8?B?Y2pvTkFzYWJBMUtGSXdzZFVtWklHYmVSa0Y5cFExSnJyYVQyNEFTMGxUR0d0?=
 =?utf-8?Q?aLVgZf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVFkenZlMkd2aVZPWTh3K3VQTkczVzFIR0Vnb3hYMU51VDZoSHdnanFNZytT?=
 =?utf-8?B?OS92cmc3N1JTakF0Qng0R3I3enZ6VVYwSWQ2VHB4ZG5Mc1Y2Mk80Z1kvdTBC?=
 =?utf-8?B?NDlkWTVqMWx6RGhBTTNkbnZIYjJkUmRiem5FVWFEL1JCYlB6RjNocjROYjZB?=
 =?utf-8?B?eHRmS3lwU2xSQVRyQnJ2Z0h4Z2NyeDROd1BHdVB5RGZnUGV1dVBIQjY4V3lK?=
 =?utf-8?B?dWYvMlFzV3RQdzB4b3kxMjRyWEh3Z2MveU93MXNWdnI5WkxaMXdnSGhITUl5?=
 =?utf-8?B?Mi9NQ1YrU1VJMlRQSWlwT3ZXQXRRN0crNFRiRUsrYk9CVGVOTTFlTzF0N0Fa?=
 =?utf-8?B?dHVUeThHWGRwWFFtN2VrZW5uRlM3TW9qNGpUSDBTcWppRGlrSXF3QzE0M2Rw?=
 =?utf-8?B?Q2VwbmprWUVBNVVBc05Nb2J5YlNGN3V0RktTZXZXNHUwWmtmcnhKYjNtcGpi?=
 =?utf-8?B?Y2lCYlhLY3VKYzI4bW1COVVpUjltbWxnY2oybnd3QnNOWDZKZmdsY0d2VVRD?=
 =?utf-8?B?RmJmTlhWSTc5ZFR1RFpndFVDcXpPUldWNmswUWJSWXhzalhrVlNlVkY2U2hH?=
 =?utf-8?B?c1o0bTFmaXBWTWZIQWFDU0hOcWlFM0YzMHN3OTZsaDVwVE9WSkszTVFKU1lF?=
 =?utf-8?B?VEhXdnJWbC95cXdydFp1b3lpS3A3cGIyYnVVa29RZ0FTOUJFNUZneFE5WlB3?=
 =?utf-8?B?OXM2SFU2MTZ3QytzNDZ5elkyOEt3eDNGOWNQb1BPeXY2a1NVcWFEMVBYRjJk?=
 =?utf-8?B?SDRxeXdlTDRhUFBvRVBNaWkyYUFqQkpCelhaUXNVa3MxZnk5S2pENWY4bExH?=
 =?utf-8?B?MUhlcUNBN0c2SFF4bnlKcHljSTdQdnhGZ2FEWERxalljT0VVSGlHVUVueFVv?=
 =?utf-8?B?REoxem5uMCtLYVFqS1VCbm5kSHNhVG9yQ3VTSGlrMFd0K08vYVR3YkpnZExG?=
 =?utf-8?B?ajZCK3dTR2c0UVJzZWZXUWFkUU5URW1JOTg1cTgzZGlDRjhxMHQrZHJlQ2ov?=
 =?utf-8?B?WXlkZnBYdWhDMEdHMkV6Rk5ZUExLZlJXQkhuM0M0bjVCRFR0RlRmZXFKdjR0?=
 =?utf-8?B?bnpDQnVWSWNDYk1URGVyWnpuWnI0YnQ4dmVHN01WSkk3OHloZm9aVEZDdWxU?=
 =?utf-8?B?OUFNbmdNLzU2QUdKMUIzTnRRVjIxUm9kSXh4WFRrcUk2UStja1A3TVEzek1m?=
 =?utf-8?B?TEhTQm9udFJXQzM3aFRoQkFPSHRXTGJKWkNJN1VsUnFQaTc2eklYSUVQRjly?=
 =?utf-8?B?N01HaWs0Z1NJZnlNUFBLUnhFQU90ZVpZY29wNGxuOVpyemxqMWZKQlFtZGtL?=
 =?utf-8?B?R2tsSzZNekhYMU9IcWVGNXZLUXpsb2hKQTVHclVZMm1MMlA3SUlMTDVoQXQr?=
 =?utf-8?B?SnZwd1FaUW5rWFkwaWFwb0tEd21LaWpXMExhS25LeXJ4cG51bmRMdDlsSjdn?=
 =?utf-8?B?cTA4ZjRrQUVmQTF2N2NWaTJlbGF0YkZYc05qbHMreEx6SWw5UFpWTlpRQWUr?=
 =?utf-8?B?NXdQdEZvL2hoYXJWcFV4Y1pZQk1Cb2phUjNCOC9EY1F4bCt0WHBnb2RFM05E?=
 =?utf-8?B?Tm9wVU1RaHQyd1ZwcmxhVHhUb1dJZ09Fc0tkeFdLdFRsS3I5djBCcXRVOENh?=
 =?utf-8?B?cThaK1c4bGt5MmNLeENuWm5nS3U0aHhPbHdpQ0l5SGsyaDI1RzZGUy9zYlNp?=
 =?utf-8?B?eXk2UjBON2t4b1M1azNhKytjMkE1U1FHaS81YmJ6VVJHclRDM0w0NU1YVzFa?=
 =?utf-8?B?VWtTOGtxT005MWJVVFZqc3VHY2lianF3OEdtSk1MVThqOXpGTU9uSDBFQVFE?=
 =?utf-8?B?Mjl0aGdsMTQydFVubytwMURUdDJ5S3QrY3JBTm1RQkZMMUlPc1hqeG5mbnpQ?=
 =?utf-8?B?Uk9wWU9DRWhBYnp4S0duWXk0c25JV01UY2l1UnRLNjVGUDBWQWpyZktjSUpp?=
 =?utf-8?B?L0xJRlNqbkNwY0xMNzZsNWwyRnN3dVdNakRpRG5TRmwyV2M0VzA4ZUcrdTdC?=
 =?utf-8?B?ejNqaGZ3UU0xMkRaUnlINGx5aG5tc095S2Z0Nk5Db1dWNi9GbkIrYTBzc1hM?=
 =?utf-8?B?K2UrRTRqakNWbnZrQTJpeHFMVzI0Q1FyWTkzU3E0bGp3OGFXUDhXb0ZyTjl5?=
 =?utf-8?B?dmRYT25obWRWc0ZFQTlkdmVpL240VWlON3R6TTR6a1FWOTJwZTBqMHZ6c1BZ?=
 =?utf-8?B?c3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2800A8DE99F9844D8C6DF2431D7A23F3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5339ec-c3fe-421e-d17f-08ddfc1ac274
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 10:03:21.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M7IZ1GtXPgAHTCsv/epCiy5+pot/XCLwE/MchlzqOh77cqnlZ2gCWuabDQMoFjR8agtCR82KjRyA2CieXjr0Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7114

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE0OjUxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFRoZSBVRlMgZXJyb3IgaGFuZGxlciBpcyBub3Qgb25s
eSB0cmlnZ2VyZWQgYnkgYnVzIGVycm9ycy4gSXQgY2FuDQo+IGFsc28NCj4gYmUgYWN0aXZhdGVk
IHZpYSBkZWJ1Z2ZzLiBEbyB5b3UgYWdyZWUgdGhhdCBhY3RpdmF0aW9uIHZpYSBkZWJ1Z2ZzDQo+
IGNhbg0KPiBoYXBwZW4gY29uY3VycmVudGx5IHdpdGggcnVudGltZSBzdXNwZW5kPw0KPiANCj4g
VGhhbmtzLA0KPiANCj4gQmFydC4NCg0KDQpIaSBCYXJ0LA0KDQpEbyB5b3UgbWVhbiB0aGF0IGRl
YnVnZnMgY291bGQgc2NoZWR1bGUgRUggd29yayBqdXN0IGJlZm9yZQ0Kc3VzcGVuZD8gSWYgc28s
IHRoZXJlIGlzIGluZGVlZCBhIGNoYW5jZSB0aGF0IHRoaXMgcGF0Y2ggDQptaWdodCBub3Qgd29y
ayBhcyBpbnRlbmRlZC4gRXZlbiBpZiB3ZSBzdXJyb3VuZCBpdCB3aXRoIA0KdWZzaGNkX3JwbV9n
ZXRfbm9yZXN1bWUoKSBhbmQgdWZzaGNkX3JwbV9wdXQoKSwgdGhlcmUgaXMgDQpzdGlsbCBhIHBv
c3NpYmlsaXR5IHRoYXQgcnVudGltZSBQTSBpcyBvbmdvaW5nIGFuZCB0aGUgc3VzcGVuZA0KY2Fs
bGJhY2sgaGFzbid0IGJlZW4gY2FsbGVkIHlldCwgc28gdGhlIHJlc3VsdCB3b3VsZCBiZSB0aGUg
DQpzYW1lLCBqdXN0IHdpdGggYSBsb3dlciBjaGFuY2Ugb2Ygb2NjdXJyZW5jZS4NCg0KQmVjYXVz
ZSB0aGlzIHBhdGNoIG1haW5seSB0YXJnZXRzIGVycm9ycyB0aGF0IG9jY3VyIGR1cmluZw0KdGhl
IHN1c3BlbmQgcHJvY2Vzcy4gSWYgdGhlIGVycm9yIGhhcHBlbnMgYmVmb3JlIHN1c3BlbmQsIA0K
aXTigJlzIG91dHNpZGUgdGhlIHNjb3BlIG9mIHdoYXQgdGhpcyBwYXRjaCBpcyBpbnRlbmRlZCB0
byBmaXguIA0KQnV0IEkgd2lsbCBhZGQgdWZzaGNkX3JwbV9nZXRfbm9yZXN1bWUoKSBhbmQgdWZz
aGNkX3JwbV9wdXQoKSANCm5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLg0KUGV0ZXINCg0K
