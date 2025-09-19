Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579A62C028E
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269573; cv=fail; b=NP1B09qTpTLnkw/2S0IS85B1G61v8uhE/BunaFqh6Au/yR0M8mP1iAVdtZFdsWA+2ikhPTjL4NVVrjFAovavh84eGsabcwozij0vSOzdkHfq5xiV910XxVsHm+asI1/kIdbl+zTYSI9dFjXjdThU5qPMqoZoTCWXNksL09XHE7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269573; c=relaxed/simple;
	bh=2WXJwqKCGfU/rqB7PtU6dFcKPYf813i/f8+HuBJrHdA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S3V844Z61eQVMNuIeRExgcMDbd4lSL5Idthyuqn6/DwgtNE5k+QCQhww6vulS4+8Ll/RTyHMi5ONp3U+RXlDSfcRCoNyfkwEnK7DTp1tUyyXhIONZ56oZrzgsqwarOaBBYPM40M9W7PADqMHb9iuzU2fNmQIaWXX7XDIiXeUs/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OfcFW8Gi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NZbWMnQ+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OfcFW8Gi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NZbWMnQ+"
X-UUID: 6e075938953011f0b33aeb1e7f16c2b6-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2WXJwqKCGfU/rqB7PtU6dFcKPYf813i/f8+HuBJrHdA=;
	b=OfcFW8GibcrUA8XnuPWozEBCknpHua6TwzULEo38E9yETsetxPNM6wKvykPHQ+LrNUrByd/LJQ0YOSQ5g0eE6orNbaTZQcCOFDNzd9jBDOMn48tB14T9mhIS/RNOD+kf4OYYkPt/jd+sWuWW0HmPHepoP9G18Bx7UNA1db78ddc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:63f1a0d7-7ed6-4909-9e7e-b8295a09d305,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:7f1abb6c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6e075938953011f0b33aeb1e7f16c2b6-20250919
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1157803017; Fri, 19 Sep 2025 16:12:48 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:12:47 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:12:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fQXcAqoGEfUraupxZsFhiCqfXgS2/V7BxDVzrXTubquiAMTa0ckhIn6rVnx6HTEfhuCrL+1NCOfknvQLVQ3DYrkP+cgvilky0JbZDPnIFX1BtTRHUTTGIhlaiyt73NMoyFisEp9a3DZMiX9+YCRbDKWpgNdXFcquk4YbEFNbToffq2D5pGGg23E3u/gKHLLuQRmOTNq9z6DN5gWEsIUG6R7/XuQh92Nf+8wxzRM+w9Pt5SZ1vX2TukUi9I8FUDFodebMdKHZzZh/jXeBDvcOUutNiGKRLRiE1zFHkKuXO7lt/gI1nKDNF1+6+v8mg13uTfixcAopye3acfHa/ns0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WXJwqKCGfU/rqB7PtU6dFcKPYf813i/f8+HuBJrHdA=;
 b=i8CxTXOg3t1LT3LxlRKqZUcES+gJ3gZfDCCwFZakZnjuPnmRCTpoT2lZb2h0Q793vul55qv5A+FKh6qGlVbBc4lB1mRWHDQglQR2Put3yrOCo8CN1zfWJdXu8CAVocJYeWZXod71B+3aJoL62cPMqnXuK5DjkflZsDTB4ZNncpBDlYmLWBrJB2FgzqVsmnHzmwS7nCk7jinbiW4h3pZHfeEWJrN2O4LMWzcVwwZU/4ThamGyDMq7UlHKmPNH1XKnwSnOVZFEdLhrG7vwBp9aanetxFZkKOI/rln130CSsXP6qXIOWVOmKhewHE0fMheLIVRpBAV790LlnF7r+EQN3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WXJwqKCGfU/rqB7PtU6dFcKPYf813i/f8+HuBJrHdA=;
 b=NZbWMnQ+s2wo0ixzoDp3VmMVdbdkUV27el6bMGxGwCRWnSTO6eKZHIuqvErBzFDCAv0NC9pc41rKfa2SYC1WRCYElu3sBlh4PmDDZ0bgrLWtLLmg6EvK6lO/hG/Ug4auzto5I4pra6kUWuI2XbJQF6wxVni0dEsFpb2gFha6PnA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7996.apcprd03.prod.outlook.com (2603:1096:400:44c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 08:12:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:12:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
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
Subject: Re: [PATCH v1 05/10] ufs: host: mediatek: Adjust sync length for
 FASTAUTO mode
Thread-Topic: [PATCH v1 05/10] ufs: host: mediatek: Adjust sync length for
 FASTAUTO mode
Thread-Index: AQHcKIizkmhDcDTILkKnaSAmJBYWOrSZU6SAgADVpAA=
Date: Fri, 19 Sep 2025 08:12:45 +0000
Message-ID: <3e86fcbaa7a2219d6421c17c1e52d0fc6f4163cc.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-6-peter.wang@mediatek.com>
	 <ff2243ed-3f7d-4746-80cc-b8f3f1b9e8b7@acm.org>
In-Reply-To: <ff2243ed-3f7d-4746-80cc-b8f3f1b9e8b7@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7996:EE_
x-ms-office365-filtering-correlation-id: f6843f63-d7a6-445a-6509-08ddf754503c
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bDZ2ak5QeEgwaWdwVHlWWDhzWnFWTWQzbVJxZDVjRnVHQjAzUmdackp5SnBC?=
 =?utf-8?B?bCszV0xPYTFiR0hFcG9kSlRTVnZVdHl4eFAwcWtoMTdLRGc4YithYVdlTURX?=
 =?utf-8?B?UkpGWnR6MXpOZWdzR0xGYmdoa25GWlNEWHRxelRHVjM2OUVqNHlSdDRPV1Bk?=
 =?utf-8?B?QzNFR3dSbHlXSjk0Rk1PUTBndmxBd3E5QThDbTJWQjdsVXI2SzN2bWdKdHJz?=
 =?utf-8?B?U3BBK0FqOG1Va29lMkV1ajZqaHpyWi9qeFdyY1ljNFI1KzROU3dUR3ZGanEz?=
 =?utf-8?B?aUM1WGhvdzVDWHlTcklTYWtncUZ3VVc0TW8vV2FpSU5LZTVPd2NYSnhZY3Vz?=
 =?utf-8?B?dXJuOVNlT2wwYk9rbm1Fck1VY1Fmd1pocitQaXhvb2NhU1plSlhoSk5qZFRw?=
 =?utf-8?B?OTNiRVM1aUxaOU9LMU9IRzVMdHNudXhyNzcrbkZFOWVyYkEwbVpCWVhmbkVD?=
 =?utf-8?B?TldwMG9UQ29EeHVRV2wvTjJYZ0dKN0ZWWHZXS3Z1aGxaWjVrVWZ3U2U2Vk9z?=
 =?utf-8?B?N3l0YmhmZDU3ZDdZbkI0a3NCWXpSTEdvWmJwbjhTeDNIY3dBcEdFV0RpelhK?=
 =?utf-8?B?N1JZd2gzazlSWWlRYTIwbTNMWWNGcUxKb3dXLytSN0NFMGRaSzRxMXBXcE5i?=
 =?utf-8?B?UDQxMkFnVm4wWkVyUTEwa2NYMHBNQ2M0bkgzM2RmNTJzaUVTd2hPTFExRFNh?=
 =?utf-8?B?RkdCSkVFU1NpWGhnLzg0MzhTNjFiS1dsSlk2QVl2NGZnRHJodWZEZHczTkIr?=
 =?utf-8?B?UDk0MUlhdDZvclUxUmRhM242ZGs4c21zU2x0MHN4YUNZRlNsUWd6K1lSZnR0?=
 =?utf-8?B?VWV6ZGdyQzc0SlNGQ2pEUEFlM0YwRTFLVWV3ajRUempiaENjVnF2WGVvTmFx?=
 =?utf-8?B?d3lkemdzU3c2NWV3RGoxZHFjandqTENXckhxb3BRNm5RMEpRVmxZbFdKTDJQ?=
 =?utf-8?B?VWgvSmQxbUtuM0NwbXBVWEZJMHRpYUVBaEhqRFc3b3VOTm8wRGVhMVpnNzla?=
 =?utf-8?B?NWlrZHBBUVE2Ty95TmwxUEd0NHQ2VENLQXJnODRQRktSbXNtNVRzSVcwZVFR?=
 =?utf-8?B?NmxTamtoa3l3UTZMRFA5OHFRaFRmclRlTWpYbjJFeFQwWkRMR2xESTE1Wk1U?=
 =?utf-8?B?U28ycTZ4K2FROFFZSzNiQWxISmgrdmZqOEVuL2lPd1RuMi9Sc0ZZR0FJRDh2?=
 =?utf-8?B?eExIWDR0YmM3TkdrN3NzeEsvd0FnRkw0djNVQjR4N2p6NEUwaHl2cTJmdStF?=
 =?utf-8?B?elloNkwzaUZBMVhPWEtOenNyY2IxNGoxc0JERFVwa3dxTFM3dnBURWg1RDBj?=
 =?utf-8?B?WU5pd0xxd0xLWERpRW5kQThacmZ2djdmcG90SkU3Zm5QdmFKN3IwNmRkQ0tv?=
 =?utf-8?B?eHIrcDR2aHIwNDhDbGRBWktaaCtsaGRyTzJRbVkyYWViM3hPb0t1NTdoT0hL?=
 =?utf-8?B?OUxjQTgvbkdZRDZwS253ZzkrcXB5bTQ4Nm55RVY1ajRjSUZPMk5Zb1VQQ2kv?=
 =?utf-8?B?TTVhQzZVV0lQK1VibnFZMHk4MVpGNW5NNHhvL013MXEyTzdsNTh6dWlxWSt1?=
 =?utf-8?B?aUxpNUo2bHBCeng2aDFzUDhiaVZoVi9FMllyYWtvbFQ0WUJEZlZXQTBXWnpU?=
 =?utf-8?B?UDBoSWJjTk1IdXovMzZaY2MydTFacTY5bFU5Ty9RYWJYdWJQZTN1YWswNi90?=
 =?utf-8?B?WlhiUzU3ZjNIbHpET3ZTM2tXL3ZaN09zUEtYUHNGL2VvSGRZQ0xEdStmWkU1?=
 =?utf-8?B?anZVNGR6QXNYMHV4cDdxaHpzVGxCUVJOUnl1UDNLMHg1YUw0ZFU0MG9qNFl2?=
 =?utf-8?B?QXZ1cHduaXBxcy9lVmtXVVB4ZmxqbDZGakhhMlNDUFh4UnBraUtiUUNOcCtW?=
 =?utf-8?B?MGdFVmQzM1V3RkF6WFNxWnFoM2E1T2loeCt1YVB4VHlIdnI0TWpNTW9GK3ZK?=
 =?utf-8?B?M3hYeFFidWhHbFRXdkMvVmYxbWtTNml2YnlxbFpVdWkrSTI4TVQ0N3I2L25W?=
 =?utf-8?B?dWg3Tk9JM0JnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjRuNndxMHFHME03cXVXeFNnMmZicDhOZnR6bGlvQ0JuK0hJZlUzVXdtendZ?=
 =?utf-8?B?ZVNYVk0yNzN3Rmx4Tk13d3NJbUh0MEtFb1E5RmVYNlN4Y1VaVTZhUnh5ZHNv?=
 =?utf-8?B?Mkg0ZnlvSDBNenNwTE9FdEZWZzJVbWJBcUZlTDM4TVYzOEcxVk9yR21tWVBi?=
 =?utf-8?B?NitKYU5QSERGSDRwV2psblNLa3MycWpEOUJ5ZGo0UkNnRm50RVpjbWdNUk1q?=
 =?utf-8?B?MXR5RUROdDg5RFhTd0pvT2dmZllmSCtYQzRrdHpBZjVvTkxpZlJCeWFLWUtM?=
 =?utf-8?B?K0Z0YnNNMVl0RzJKbmp6SFErMVJPb2VvSWVhVG9NSjdqMlgraTJyOXY5QlU2?=
 =?utf-8?B?U1IyeC9aRWFtN0NFZWoyMDAzN2xqM1dMOGNQemRaYUo0TDBKblRwdWVCeElH?=
 =?utf-8?B?N2o0NUVnelM1VGUwTWVINllmUEt3amF3NC9rd2hETDh2S3A1bXJpcGVpWjZk?=
 =?utf-8?B?b1pwTm1VeHhCWkJqazc1YzFwQXMzcE5wOG8zRjl5UERZdHFyTlg2bUxIU3Rp?=
 =?utf-8?B?ektpY01wUHQyendvSmRGalgzYTllbHBiSkV5VmF3YWpVdllYd3A4TXdIT3Qw?=
 =?utf-8?B?Rzc3U1hSUUJkcmtlOXE1UDFTMkJyWFRwcFlHWGt2UUFZdzQzQ2RJK2s0ZGFS?=
 =?utf-8?B?b2tic09ic0o1ZittMTJiUjVaUUVtQ3hrZmY3M2FzdlVyTS94TnVpMFN0MWph?=
 =?utf-8?B?TVdkVGJXTTdVMFhlQUxKb0szYlkzdEI4cGlYSi9ZeWFIeXNzb3V2WWtndUV1?=
 =?utf-8?B?VXdsOGMyTFJIUUxoQ3drMzhqZnpqUWpMU1BjbFcyNWZQeW5QQjlaUkJDaG9G?=
 =?utf-8?B?TUV2bzFsV1F3Q2RKdnIyWXBKV01vNDdmRU1wTFkySTBTbjFGOTBXRGQ5b0ha?=
 =?utf-8?B?NXdaaXRUY05SckROOW4xU294ZXJnRmlsNUcyb2ViVnFHeThuZW1hT2NySUFB?=
 =?utf-8?B?cEhheWxCaUJ4bTFZZG1ES2NHM3VwWm9YYk9CakRCUWR5eDdxTklvYlJxaUw3?=
 =?utf-8?B?U09KYzk2M29XVHBpUXZNSDBvWXlEQ2UvT0htYnVia2pwcHpUc0M2OCt2S0xO?=
 =?utf-8?B?L0lDUHJ5b1hTdkZpei9GUzdiTGJXVjh3MU9QaU5qQ3lHV0FhdTU0SzV5eDlD?=
 =?utf-8?B?bjBmQjUwUU5DZnp5c1ptcHZ1ejJvUFZNNDh6WXZVMStqQkFIN3A4ang5UVNJ?=
 =?utf-8?B?VloxallKWnJ1RCtYbXFTalI5UEFya2Z2d0IybFFqWGZHVDNPTFdwTmg4Y25N?=
 =?utf-8?B?UDV1eXhHN0wzYlBPeDZIZFlHZUVVQ2QyTTA4K3VHQWpGRk1pQkg1TjR6T1BB?=
 =?utf-8?B?ODFEb1RVWXRBUklVZFBLR0xjQWxpN0hnMUpPSXVLTzRveldsa2MyRHh3QlRv?=
 =?utf-8?B?QnZjdTREWTdONkd6S2x2SU1mcEFOUmhiRm10ZjNZOXhmOTI0bExBTDdPYUQy?=
 =?utf-8?B?dU1oNStjUVA0SHRyWk0yRzhhaEs0bkJxQ1pnVTBQbXFwSkRmZ0d0dGNJY3Iw?=
 =?utf-8?B?dXNHT0dnTTlPRGplME9vb3BIajJEemN5UEo2ZUU1a2pGN0FJRGNSZWVJejVL?=
 =?utf-8?B?MWlWNk5JcHZzRTlSMkVJWi9zQmdjd2pQVDdRWUdYd09kU0VIQTJkU0ZnUHFx?=
 =?utf-8?B?blFhMFdNTENBT2t4R3Q1Sm1mZ3JrM0wwZkNBdFVPLythMllQNit3NjJIcVZa?=
 =?utf-8?B?bUJLQWFSVEtJUFova0ZLOVdXM0VKcmxVZWp3c21SajVHenBUQ05aSmNqUnlP?=
 =?utf-8?B?blVSSzloVTJCVlpIbTdlbVhXTDNPcTNidkRhVzlTN1AvQ1Jsdk9jdnRTK1RO?=
 =?utf-8?B?NXl3bnU2OTd0eFNlajdFM29uU2RtcFU2TDU4TWtKN08xVUI4WHBrejVaeWxX?=
 =?utf-8?B?d0s4cm1pOHBYZkJReUlzMTNpWHRHQUw3ZWo3bFIxU3hNQUQya0NTMys2RFQ4?=
 =?utf-8?B?dFl5aHVmL0QvWC9XSkNkMzlZUTRlR1VJWGd4NStWamFvMmFkSUhZNzVuTlFh?=
 =?utf-8?B?cFRuQkxMMitnWm1odWJ6N1FkWkFmRnNGTDZLV1pkcCtHYXNadlRwSDhsTGNZ?=
 =?utf-8?B?UG5QTHMxbkp4TnFlNUtxYlB5SnhXQW1GK1FJc05PYlR0d2xOREdGZHQ3UXVC?=
 =?utf-8?B?WHY1ejFyQ21CYnFvZnIwdWVHS0M3UkxFT3NabDBQVllYRURqZ1JYbXN6WUcw?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD3B5CF79FC0104F8F477CE7F51F5F64@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6843f63-d7a6-445a-6509-08ddf754503c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:12:45.1416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sfxvoR3j3xl0DSBa1rgoNTm9f5s5nvaYcvCEdLBz4JkrY6QV1q6O/hG0Um9nBFL+kflaH+Ek3dcKH1TDLD1H+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7996

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDEyOjI4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IEBAIC0xNjAsNyArMTYzLDkgQEANCj4gPiDCoCAjZGVmaW5lIFBBX1BBQ1BGUkFNRUNPVU5U
wqDCoCAweDE1QzANCj4gPiDCoCAjZGVmaW5lIFBBX1BBQ1BFUlJPUkNPVU5UwqDCoCAweDE1QzEN
Cj4gPiDCoCAjZGVmaW5lIFBBX1BIWVRFU1RDT05UUk9MwqDCoCAweDE1QzINCj4gPiAtI2RlZmlu
ZSBQQV9UWEhTQURBUFRUWVBFwqDCoMKgwqDCoMKgIDB4MTVENA0KPiA+ICsjZGVmaW5lIFBBX1RY
SFNHNFNZTkNMRU5HVEjCoCAweDE1RDANCj4gPiArI2RlZmluZSBQQV9UWEhTQURBUFRUWVBFwqDC
oMKgwqAgMHgxNUQ0DQo+ID4gKyNkZWZpbmUgUEFfVFhIU0c1U1lOQ0xFTkdUSMKgIDB4MTVENg0K
PiA+IA0KPiA+IMKgIC8qIEFkcGF0IHR5cGUgZm9yIFBBX1RYSFNBREFQVFRZUEUgYXR0cmlidXRl
ICovDQo+ID4gwqAgI2RlZmluZSBQQV9SRUZSRVNIX0FEQVBUwqDCoMKgwqDCoMKgIDB4MDANCj4g
DQo+IFRoZSAiI2RlZmluZSBQQV9UWEhTQURBUFRUWVBFwqDCoCAweDE1RDQiIGxpbmUgc2hvdWxk
bid0IGhhdmUgYmVlbg0KPiBjaGFuZ2VkLiBJdCBzZWVtcyBsaWtlIHRoaXMgcGF0Y2ggY2hhbmdl
cyB0aGUgd2hpdGVzcGFjZSBiZWZvcmUgdGhlDQo+ICIweCI/DQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpZZXMsIHRoZSBhbGlnbm1lbnQgd2FzIGRpZmZlcmVudCBm
cm9tIHRoZSBvdGhlciBkZWZpbml0aW9ucywNCnNvIEkgY2hhbmdlZCB0aGUgc3BhY2VzIHRvIHRh
YnMgZm9yIGNvbnNpc3RlbmN5LiANClRoZSBjb250ZW50IGl0c2VsZiB3YXMgbm90IG1vZGlmaWVk
Lg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
