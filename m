Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6B18027
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 03:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643744; cv=fail; b=JHc5FrzzUR8y9Y/yMeMgUtIhw6jT8a7naAk/dAhA7EE6TZVTwVf+kWDDPFOswa9FxIsTg5dO/bXNiVonI0kG7nJz88+T8parZggBEh5GQ8Ld4NUaDxN+RC+0Vj3DSnO4FD+xmc3vtI5FHORYRPEzgosxI8SsoRPN5r3wnHZ/VMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643744; c=relaxed/simple;
	bh=pgZLtLz9ZG+Hl3vAQnowFFAk5E0Lp89ppyZo4eNT1iU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pahyVLjqCcmEqlt9gpUVVKD/Fkz7TLlbDPGocb+VuLobOLws8CWlSAqOOdA4J5QMyGktrp0FfDYgCXY473l5Z7x955AlD2387FpqAeOL83YitjkOqP3szQGurtZMwyVV5d8/ShMwBE81uiIFbnB6dxMVVaps+miSmWPGjlb5sQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gXIGuFjf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=AjqFUMvF; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gXIGuFjf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="AjqFUMvF"
X-UUID: 2a13bd80635d11ef8593d301e5c8a9c0-20240826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pgZLtLz9ZG+Hl3vAQnowFFAk5E0Lp89ppyZo4eNT1iU=;
	b=gXIGuFjfRgi8t/JK29JYtOUGDGD7+DdbV81PDraYefwOUD1QoM3d429VY8/r1ay3TVO6EsdzHVvLFS8Uft2aF+UBSRv0UtGdt15kQHzQJ/3hKefke6sTN4/vhxTFD8YK4bCCYhhEO6AQevWvJPhuRXF7nD7jiyWQ5AXlmTTAr/c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:1f3070f1-4dcd-452d-a3e7-94ccb86a40fe,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:f5712acf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 2a13bd80635d11ef8593d301e5c8a9c0-20240826
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 656372008; Mon, 26 Aug 2024 11:42:06 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sun, 25 Aug 2024 20:42:05 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 26 Aug 2024 11:42:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+AOsOdSrPFtgAw8wmWHEjcHXm01ddPMLMo0eErVL7t74vXEJwCYCRKK9D796jiNCzBfk/1VPVXaI6Dax/OAB6LbMaNTqWlirXkEGwO1J2z8F24f7Xu89H8prVwB9RYZBoSDzd98MgD2tXQ6vqgkn00KlepoW2RYy6u0qvVxUTNWDikSxswCJz2aRoq1mYT1Blzs+ZHwTkLqMd1+CXOC3n4wRuS6UVk3kHixPGAfv6wdkKzH4oy6EcuzPoKVW6yfBJaoGI1cKb5X1iMyNopDCYC+Cs6tVjRb2nsPG1DQXSesoMpuTgE2utRmzTzxn8YGwYGNAM54ooqYf2GaqYLQKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgZLtLz9ZG+Hl3vAQnowFFAk5E0Lp89ppyZo4eNT1iU=;
 b=NrFKyNS26unLtTXIv1FnswmjycbUZO1ZMWOKwS+SinSJybYE4bXpcMdgDEv875wt2Dqb48i3OFyoWL4JpP/MSHksc0cGOa3vsgNNAFemDEch+X7q4gwThtfkxfNzgtxRBOPzOhnp29Jm7zUOmgV7xTn7C5n/GnJLncAnHc538sd0qsm0sLVBWWiE87wJRD1/FdkOEK5UF6/lc4LQF+Yoj+S4ioLy1QtD8g25DmBXUdtScMSSEUwOoYgH+XdFFbW5ZKArnA2u5RNNAHbOi3Q9Zr2QLMD1tPk+P/D4nq68aGVimoiezl8iAqQflvCpMykiS8FjeUjMDOfl1IrHu2KHJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgZLtLz9ZG+Hl3vAQnowFFAk5E0Lp89ppyZo4eNT1iU=;
 b=AjqFUMvFDQvc/sOjF3siY3sYp3FBCMyc0Yp1ABGcfjhHLUpGmYqO7Y6C1l7ybFKFntNhOGfoEcM04J2joGKu85/pW64K2k1bxm/pBMNLNmBaT1olTv6JxRHK9rHZNcSj9YT//BGhpwm+3TyGlRwQvicAv8pv3Swp0z0j8gM/IOw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Mon, 26 Aug
 2024 03:42:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 03:42:03 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 2/2] ufs: core: force reset after mcq abort all
Thread-Topic: [PATCH v1 2/2] ufs: core: force reset after mcq abort all
Thread-Index: AQHa9URLZ1ILOHNbqEuFWWewi1hSd7I1BpiAgAPisgA=
Date: Mon, 26 Aug 2024 03:42:03 +0000
Message-ID: <02b49ffb41bef15d40a7caaca975482ee6810ab6.camel@mediatek.com>
References: <20240823100707.6699-1-peter.wang@mediatek.com>
	 <20240823100707.6699-3-peter.wang@mediatek.com>
	 <ab24891e-f7a6-4185-9235-ffdc13c88f53@acm.org>
In-Reply-To: <ab24891e-f7a6-4185-9235-ffdc13c88f53@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: b77b36b6-c318-46b3-13db-08dcc5810c84
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bmpPZWF3aVh3clB4dGxGU0hCb2NpNjVKTEJkeWhSUlJRMHV0YU1QYmxvbU5U?=
 =?utf-8?B?MUJpNGl2ZDNPaUpKTU9RcExBS0MvVHFTYjY3eG90bTdXcUZ4OTdrTnhWV3Y0?=
 =?utf-8?B?NU5wQVdaVDNrN3daVWR5ZW9sMTBEcnNRYkk4c2IvVW5XTFZPQkxTZXFBaVV6?=
 =?utf-8?B?L2JqOW9pazRCMkJneDd0YXllaVZkYXduVWRoM0ZrNVhNemgyUkFURWt6NFJY?=
 =?utf-8?B?RDJ6WHhCK3QvSnI5RVVmU1FqMW12ZHRjYndBYlR1V1Uwd2ViNFgwVHNsckE3?=
 =?utf-8?B?bTJySHlEQWIzeVlSMTN0a3BzY21RZFJUZTJ4SUgzeHpxQUdnUmRXaG9xWEUv?=
 =?utf-8?B?Z2lvR200Z01JM0F5T2ZEbjRHMzNNNTZ1UE9TQURyT2FYUW5QeFBHVjhtLzJX?=
 =?utf-8?B?dWFYMTZHd1NDV3ZJaFVoK1RXWHEwTzFtb29nS2VyU1VZSU5lY2ovbnpBbzRh?=
 =?utf-8?B?dWN6aE1pb2RVWENxQWs5eGR5UHBpbHdPekVEK1ZUZXdaZU5GU215WWZHb2d6?=
 =?utf-8?B?YXlIYkZxUDY0TUtNQlN2MFRDOEtvOUpmSTlrK3ZHd1V1L1o2VFpCMm5qNGll?=
 =?utf-8?B?WFNjMmM3ZzFhWHRjenFaNHdLMVJFd2ZjeXRUWEhqUnNpeFBMZ09jRzIxN1Zs?=
 =?utf-8?B?MGhvRWZYZ0ZrcVZmM3Vha3V1amhlN0UwS1ZLMFlWbTFtZ3NFa09CQkNqeGFt?=
 =?utf-8?B?ZE9BamxnY1YvdXNZT2IvUnhXWFRIRm5peUozMTJpQm9yREZHa3lkYjZOZUt1?=
 =?utf-8?B?N2dPaXdDdzZEY0czUEs1eThhYUxFYjJ1WHhmeWcvbHBycmt2T3N4cEZtMUhr?=
 =?utf-8?B?UzMyRklsYldJeUJuU2tmbXhsUHVsZ3YySXY5dDBEcXRhaDJ0dVV6QUtzZkpI?=
 =?utf-8?B?ZUpLck1oc3Y2WVVpbXJIWk9hMXpFcGVrcjREQ3lzZTJZeXMzNElleVRJZ3RJ?=
 =?utf-8?B?Ymo2U1ByOUpQSzJ1ZnQ5L0Q3YktUc2hmNWRFcTJ6SUtaeDNkN2NESU9YTjhI?=
 =?utf-8?B?d0xseUxSU1RRRlQ5eTNXSjZUS2FkZ0NRV0MrNWF4UVhRSFhIRjZ2cEZ1RUVN?=
 =?utf-8?B?Q2Zhckg4ZmJMaG50cXc5dWcrYnd4QnpVQnozRWFtY1RwQmxNckJCL2NEZElR?=
 =?utf-8?B?R3VLSkZQWFNhZ0kvQW1La1JYdTErMGVLZVMwNW5ZVHIrRk0yTFJ0VXZ0amFZ?=
 =?utf-8?B?TFMvNThlWU9aRGJqQS9EOC9xdWllNWRvK0pVb0hHdEFCbExoSzJnNU1EaFp0?=
 =?utf-8?B?ZFcyTno4RER3Z095SDBtVjg3anJ1ZlhjUmRIMHk5ZHRVQzlmUk0yNUxrQTE1?=
 =?utf-8?B?cTU4d2RQTFZXNlEyckxGK0NzWnBlVmIrQVZjZDExTnN4QjYvOEgrSVZLMkFN?=
 =?utf-8?B?Njh0VTZZVnRqNXRrd2d1amt4cG1zVU5JN1RxWUd3ZVY4YzlYaG45VUpjRWdH?=
 =?utf-8?B?bmo5U0xieXdhaGNtcThMTDNpb0ZEUzFPQTRRUVhXaThtalVtemd6ZFR5Q2ts?=
 =?utf-8?B?YzVhcmw2OTNNVTlpeGlIUXhVZEliRkMzb3FuMkJKSTFIZlg4cXR4dTRiNTVa?=
 =?utf-8?B?cmpVa3FYU0h1bDd2L2w2bkh5ZEJ4Z0FZU0tRd3Ixa2VwZEVIUUQxRWYxdUQ1?=
 =?utf-8?B?cTE4eHhYeWtJOUF3WUtVMWoyR2grUHUvWW41czV5TXE3WWVjWWthaFV1YVIv?=
 =?utf-8?B?VHRDRWd0ak5UVU9zL1BkU2J6NUxEU1habStsWWtodGd3K08vUnNaYkVyYy9k?=
 =?utf-8?B?SzZqVkZQUWV3U0lYZUl5emNKZEJLUDVyUEVEZW5mYU1ndC81RTlIcjhwNytQ?=
 =?utf-8?B?cVlhYjBjNkNITjkzUVR6cGcrVDVicVM0ZUVwTXIzbzNsSnBJYWpwVFVjWWdo?=
 =?utf-8?B?VGZSOCs1TjB1MUJ1c3lHeDh0Zk5PQllMMHcvcnloRjVUeEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmhQSEFrTmFKakpZWWtsbHJkWTBsUzczYW9KN1lHeTN1czFBV0NiN2xVRytw?=
 =?utf-8?B?SWsvd0VyZm5LTFE5bjNXN0NPU05YTFJzbmFmcnV5eXBPenRKSnJxZHZSbTlq?=
 =?utf-8?B?M201MVdIV2dydXBYTTdSbjJrQUMzWUlIYWUxTEdJY1R2MmozY3JJLzhVMGpF?=
 =?utf-8?B?ZHJqM28xQk5kTnl1Qis2MnI0TnNtVkU2SVlvYitJZ3B2dHF6S1c5Z0NLb20x?=
 =?utf-8?B?WlRqa0VDdUwrWFFNanZ3dHRWYzVpWkVzYVlQcEpId1VqcG9iUkRsWndVMUNw?=
 =?utf-8?B?Z2RRTlhjNEtJSm5xRnE5ck5qbXRuVEwyS1UzbWtUWWpwa04xNUJmWEtPakFt?=
 =?utf-8?B?TmlJcHJnMC81dTdXWXY1Y0FuNEJrVlUvbDFrMHcvTUlZUjJ1WXdUKytCTita?=
 =?utf-8?B?K1d0WHlhaW1EQVlFelpTVVB3cmNDVDlzeVRkSEV1bVk0WWtiaDJKQllUOGFi?=
 =?utf-8?B?cS96QnIxaE0wejRCREVqTUJnV3RUVStjRnQ3S2tBR3k2cWZUeUJnZ3hVakE2?=
 =?utf-8?B?K2JFaWtzVUZOUlpFZFpoZ09yallkaldQVm9hczdYY0hUODMrcHFsY3VUUFJB?=
 =?utf-8?B?azNyQjZ0NVlYUmdLVmxGZXZoeSs5L0JCWkM1Rm9iV3ZFMStlNXllSlVrVkh3?=
 =?utf-8?B?R0hycFJUMEMwTVNPQ3puWDIyL1V5R01NUHc2RE1VWHFjRXg3UWNDblhTM3cv?=
 =?utf-8?B?YXBpLzQ1SVpvQjEweG82K1FCU2dhNHNnQUNVVno0aGRMK25LMGk2VGF3TnJZ?=
 =?utf-8?B?Ykx0L2NRWjN4NlVxZElkRWZwWGI3eXoyOUk3WTVnUnJpc2VZclVxbEpQQlg1?=
 =?utf-8?B?d2FXOXdQamw2UzUwQm56TENyWTkzSGpERU1SL0x2QldLOTJkVkRQRkpsTVVu?=
 =?utf-8?B?SEw4dWdmK0R5MlN4eFliNVk1OWtIc3FNWXQxWVJJS2VHbmF0VlBjNVNCWmNh?=
 =?utf-8?B?S0E1bG5mSm5VRzhhUFd1bnNJTTFOaUlMMXM4V2psRnYxZzZ0eXhPaDBEK2JC?=
 =?utf-8?B?aEpGUTBiUEFIUm1LQmFTZ1drb2NCK1RiR29nZ2dRU3dmMUkrV0dDQTQ3ZFlh?=
 =?utf-8?B?RFFZZXRTM0ZrS0ZYN2FlY1NMTjJnQTh4cVR3N0ZyYzFhS0VSMU0zY0xDUVBX?=
 =?utf-8?B?RENtSkFGdWFzR2E1alRUdW9Cb3hCRGRUa3Z0blJoZ2FsVkNIczQ1MGFvZEJv?=
 =?utf-8?B?c1JVdlBPQ1pUYTU0NUN2RERWZmJNRzFCVVpWaDdHWEt0Q01xOUpIbE52Ukd5?=
 =?utf-8?B?V0psNVpUTFVKczhUR29pZS8zV1JLTU5Ic3EyZEphWmVncmdLU2h0SVRuMVdT?=
 =?utf-8?B?bFg5clQvL2FBNitnang2L29tSUdPYW1GOTB1Qi9LZ29veDI2YmcybGFITVFE?=
 =?utf-8?B?VDZxN2oxYVhUcFFVaDh4VXErRTBoS3dzdFBwMEpJTVI5WElUczQrTE9vaXA1?=
 =?utf-8?B?Nk96Q0RWeUk1MDJ2Ull2LzlkeWZDMDFxL0FDMFVkQ05LYmFPay9qY1FtTVI5?=
 =?utf-8?B?S3B2TXhpTk5QeUlWYXpBRTRBdW1PRmlRTVRWSkZJeVh4MnRoaCsxUTZyeGs2?=
 =?utf-8?B?RDhsLzk1L3dOZCtWb25OeHc4N2ZETkN2V3p5UU1mQ2h3V01KYXVjU1VqV2Zn?=
 =?utf-8?B?aTBzakNoTW11cmVOcjJCaXVwYjNaUXlxWCs3SC9Wci9mbFVNcVNLc0VVRVp6?=
 =?utf-8?B?bDYyK2Y4V3paMGVtb09tUG15Z2JxSTU5MjhNbFpYTERkVmNmNjRyVkFWRkRS?=
 =?utf-8?B?R3NQQ2hvdEJlYmZWSTNwUWJ1R281bWN0WFNySFJLaE83dEdXUFBRbG1BWGdw?=
 =?utf-8?B?dW1rdms1K0cxUWg1QTV0YUVCWWZlbUExSHlOOVdjelRKSjFJUzIrWHM5Szkv?=
 =?utf-8?B?WWFwNjRiSXR6elp4R0Y5WWpnZThVQlFhKzdQcUxHV0VpSDFpemljN1c0THFi?=
 =?utf-8?B?eTBUZHJXajlQNWFRZXFRei9pbE1QV2FtaHVaWGdCMllpb3d2b1FLZnpHSkwz?=
 =?utf-8?B?aXpremZueVNPS1dWM0pkbXhpbFlBbXc5c3NacTVXTlE3cjVhZzBLSEVXNkYv?=
 =?utf-8?B?ZStzUFhzQkkvSVlEK3hNa0p5OHpNU2dSVUp1MTU2V0pTcEpteFVnMEs0V3hy?=
 =?utf-8?B?ejJtNE56b0JGemZZOWt1RFFtM0FsVy9wckc2OXFBNHV2eGllYUFrc0VuWThw?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55647AA1EDE05346AC520EE0931C3E0D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b77b36b6-c318-46b3-13db-08dcc5810c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 03:42:03.1044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaypkzXs8a4SD7mBP9Xz8E04HZ0fcbcUj87/B9AYJ2M59nWct7NyG2CqolXWfObehuVULIYOoAWCv9wxIxWPjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDA5OjIxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yMy8yNCAzOjA3IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBJbiBtY3EgbW9kZSBnZXJuZWFsIGNhc2UsIGNxIChoZWFkL3RhaWwp
IHBvbml0ZXIgaXMgc2FtZSBhcw0KPiA+IHNxIHBvaW50ZXIgKGhlYWQvdGFpbCkgaWYgdGhlIGh3
cSBpcyBlbXB0eS4NCj4gDQo+IHBvbml0ZXIgLT4gcG9pbnRlcg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg0KSGkgQmFydCwNCg0KV2lsbCBmaXggdHlwbyBuZXh0IHZlcnNpb24uDQoNClRo
YW5rcy4NClBldGVyDQo=
