Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EE47464
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 05:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607123; cv=fail; b=X9HSIiir8vA/BGIIb/b0hSvxs6gZoxkfk/sDAjhC6zN4IgHSf53vQ5lyD6p+x6wY0NIxC4zIyJCUNa3k2QIKbXEhBeab5qlxAwt9UtK9rdZBLb/Qpjd3oJGhXse4BmXX/rdntmedn2sDoZRSIrB9zSH93Pgdh3/8ku98Zkzha5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607123; c=relaxed/simple;
	bh=vpcZxmrCaIn2WB2H6pEzdlYk/hqKGR0g0zWeMwblCjk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dUMSWGoasJxU53s0F8Mg5oZyxtT7EbFbnCj/yEnOIU2alQTOzZ/NMcpuGImuGghrTy3/GmIotRCEKRFM2LBacxWFU8CzLYdf5fSR+Dx8ouDdPJ5VTZlwOqP/oq8fO2DfZOcc95D3eWkZr9HsV76uMNODFw7G0UDiIiKXTbptEY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=licbqlE2; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=beQyG//5; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="licbqlE2";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="beQyG//5"
X-UUID: 57d339ba984211f08d9e1119e76e3a28-20250923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=vpcZxmrCaIn2WB2H6pEzdlYk/hqKGR0g0zWeMwblCjk=;
	b=licbqlE2kSC9fnveB1BJfI6W8hzwNw7kyDRAAQuOw6/Oj6QXVRrrPELgC3jyJx3ssSVWteVBmgJe/1d0vShg7YT2k6Yu2Cb16OJfdhYpMnRUBTY0YlUwfAiv+6yLUCEWkmfT7hEztWhOU3dviDUMVueXdvLUhOYLaCX8MWpRqLk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:8efe7911-16cb-49ae-bb9c-993d70ebd604,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:823697f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 57d339ba984211f08d9e1119e76e3a28-20250923
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 810325500; Tue, 23 Sep 2025 13:58:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 23 Sep 2025 13:58:33 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 23 Sep 2025 13:58:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+lO98WA7WbNnaBZheGMDcQUIuCukrcHeOjkWB4Ll2JyYojhbfNHUbjeZVHh4VBqUvadx1oZouBPITtaH8zghTd4RdlaI+NSMy4hiN7BXDNzZIscvaM3P6kFg+WlWgvWXPsWPWc3GP+z9058LmFNFzqpFqTLQr+AV3WONdY5vqyDzFcxD+jlhLTZBOEGZKKQiOHPHJwUKxuwE5yGCE9x8XkvQT9BHaw65C0pP2y3toTsWRkN8dCdLkPJs5q4F5ucuC31oIT+ulpTKPHu/N28cC596SelBmLkgHuafat5rYGJxuL8m5X5Yg0DpVZYL4xyx4wL5gFxfOueJN51l4vKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpcZxmrCaIn2WB2H6pEzdlYk/hqKGR0g0zWeMwblCjk=;
 b=S+GAq+8zdTOREs40Fn8pvWwTbMOSFLZI2ECRJEmEUgwf8lWORGeIXN2doGiEsfHNvZ8GcOuidID4isro66soPv43bvBQ7hQ3jiTDmE0BdJnVS0c3yvmph2LRvEb96vbUwaWdn0uOlG4N6F2B7UzBDjBmb/pknRzvcqfzDEI48K7lxFLiFcBoxyqItKYGpu3SH5LFGssJYCWaMWueNQ3BRqToWIKYptZ2H4bR15HnXoGK9CgMKFe+QH/NBKfGite5rxxaXmmlFWWHTiTrqkUQ1AoVY+lwh2I58pqWKKreG+jF5EH1VRS6KDh0h53LEuF28ijxd7f+GsudeLyHkGfoKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpcZxmrCaIn2WB2H6pEzdlYk/hqKGR0g0zWeMwblCjk=;
 b=beQyG//5eOIfyQwfvKHat28kr6IjivwL1QiQtXLk8t7Cwaz8AKltY71nWA/gesNysKsIVqTEI6hKk7Iqz+WrNiwZTKSP3332DikwcZmNO0zM6Anuzgj3NyXBShdxc3aGAAGuKUUI/DTGu3VR/3+vBOsl+Z7mzCfiC3BgoqZ0Lag=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE3PR03MB9491.apcprd03.prod.outlook.com (2603:1096:101:2e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 05:58:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 05:58:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
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
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Topic: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Index: AQHcKIi68y1ScQQmRECt8lruVe3TV7SZQ3oAgADllQCAANdeAIAD50KAgACzZ4CAALIEAA==
Date: Tue, 23 Sep 2025 05:58:31 +0000
Message-ID: <987345857aa7a00c90faaa45a2498be439a79d09.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-3-peter.wang@mediatek.com>
	 <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
	 <21a451c752709cd9c1a3e18568c18f384bb77a05.camel@mediatek.com>
	 <ba381e9a-4cb5-45df-9fe0-3d370a84429d@acm.org>
	 <c5ffcc850a222b23d1b0ba93c9f28521ff2fedf3.camel@mediatek.com>
	 <1be6c436-203e-4d6b-b457-290922d15687@acm.org>
In-Reply-To: <1be6c436-203e-4d6b-b457-290922d15687@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE3PR03MB9491:EE_
x-ms-office365-filtering-correlation-id: c40e590c-feb7-4fee-8285-08ddfa66399f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WjdtMXArVHRwS1JyMnFUaUtNUnR0WW9sWE9iRmtORmtIc2M4cEZKZTVjYW1D?=
 =?utf-8?B?QzllUDVhbFQzaUhpNUFBSEE1OVVNb2N1SUtVdVBtbERkMG5aRXR2WC9tZ2ZW?=
 =?utf-8?B?Um9VWE5QTnVXTVh2TnNuWjVrTTMyZ2VlV3o2ZnBQbG9qd2lWRlQxYlhKYWhr?=
 =?utf-8?B?WVN5WTZobzhycFBZVjh1KzFPZTdLcDVuZWhOUFVUblZCUmJWRlFpYjMwK0pr?=
 =?utf-8?B?aTdXWjhueElYRks0Uno1elZwVnE3OGpJTER4a0ZDTlgvd3p3OWdHYUxHRXFK?=
 =?utf-8?B?ZUdJLzl2WVh4YzIrSnZEZGRzcnA5MTRYc2VJcnNhU2JoaHlCdUg5WjUzV0dO?=
 =?utf-8?B?a3VLVnF5MGgyQmhBTkJBVWc1dUF4ZGFYeXI5MDdwSm5tRjNTcjg2SnJsOFRr?=
 =?utf-8?B?NWwvOHhjNllGOW95bnlVSUhOMGdDVE1UejJMbzI3SnY4ano0TWtyTDdsdEZ6?=
 =?utf-8?B?YnMwR0VGa3VmczlPYWcxNzgyTUo3TXZIayttTFQ5K3FIa0ViTkJ1eHhya0ln?=
 =?utf-8?B?cU9wbkpDQWYydmppdmQyT2FhcFZZYlFpaWNacFl0dHVQRTZWR1hGTkVRUktk?=
 =?utf-8?B?U05OTkgyTkswaDV0UW9ueDVUL05nNlc4S0hKYXV0c2F6cVpiODlqNGhBaXVR?=
 =?utf-8?B?eDZZNGhYMndMeXlxc3VwcjFmdFNoKy9meGkrV1htZitLbTVWZkVSQjRUMzha?=
 =?utf-8?B?Ykdlc2MzYXU1Q0ZZVzUwZXA1cDJoNlFzUGlvQnhxN0NoOWlFN25aN0k3RWNu?=
 =?utf-8?B?L05QNEFhRkxPdWFoMU83YzQ5ZzRTSHFIUUFVa0g4cy80MFA0cGpKSGNXTS9u?=
 =?utf-8?B?SWRvTGhWbnJpSUtWMUVXRUhHVjdRMGc0bGxkUGdZY2ZkTlJGNndqdWtrQlM1?=
 =?utf-8?B?Q0lxeEVlbkxvdkd2Nk80NXNGTXhKUWdrY2xuM2xLQ0IwVmdyVFk2cDB3cVNn?=
 =?utf-8?B?eCtyaVZCQVRqZm8wcjlRQS9QZ0o0bzlTTGpMUkdsTkZ5VGZMZkpkMU1veWoy?=
 =?utf-8?B?b0M0L0FVcmdZUDJYTGlvNkkvSlBDU2JMSVNaOFplZFg4K2FMMTIyRHZadEtQ?=
 =?utf-8?B?elZjNU5wZ1pBYkk3ZSsrNE5HclVYYlFpa0k2U3c1NUtReG5FS2JxSTEzNTVw?=
 =?utf-8?B?VXlHOGJUWjgweHlVTzE0Yi9mYnBEQVpuREJic2RxYUVGclVPQ2U2YlphUHZI?=
 =?utf-8?B?VjhFUjh3cXN2Mk5CYjJNMHpLY09VWitKTTdYekRqd29UT0szZTNtcnE3Vlcx?=
 =?utf-8?B?WkNRcW1IclpkT0xZVUNFZXhzOVZSaVVGOVhzcEx4UjlWS1E1SCswTjI1T0sw?=
 =?utf-8?B?T1EwRjZRUVhGV2lhTWxsOFE2N09UWUxTRzJzeVIrcTZRSmMxRUtBK3AvTktF?=
 =?utf-8?B?cmZ2QVEydkw0TDhUTmJSQ1phVnZyeCszUDF0LzJ6ZENNbWt1MDlqQktWSHNS?=
 =?utf-8?B?Z1VtQ0NsTmF0MnVwN0VLcEEvbHVjQ2x1US81eFRCOEhxQTNHR3pidS9vK0VF?=
 =?utf-8?B?NkY1MUQvdnZKRU9iWnhGaVQvK1hTSUN5YktzSXMvMGNDQlJRbWdpS0J1eDll?=
 =?utf-8?B?V3h1VFRCQkdMTTdJOGIrQTc0UnVsalZpcGx1elcrYThvMy9yakJQcFZUVEY4?=
 =?utf-8?B?ZGJ2amlkcmRlMkcyL3NwRGtGSzdHdGkxeXhLZ1Eyb0JFeS9aTHVEZVRBSGVo?=
 =?utf-8?B?aTRUeUtRalY0VTFXTlVWTytlSEY1Rk1SS1dpRlpudW5xOFVYSGYzY01SYXds?=
 =?utf-8?B?TFFlUlE1ZWJYamhVeGErQkxNdGRhZ2tjdklEYjM2by9PeXFRS2pKTEVQQmpi?=
 =?utf-8?B?R3VzZS9iZGJucHAxZDU1WVRoR0hsL0VidHp3TVltUXhuY1VYekhMWEVJT0JO?=
 =?utf-8?B?b3NGdmg5ZXB4bVBXWDdGbUN4NXd2dTQ1ZE0vK2VZcEc4Y0EvMlV3NGlROFhv?=
 =?utf-8?B?ZmkrYkR4Um1MT1JLNTU2ZjVLSitEM1BVcHVtWEh6NmpCUW15N0FjRXRkdHNB?=
 =?utf-8?Q?vtfVp+MACK7MjvhYxf5B5I0f/9o55U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnhVS3J6M1pkZVJud2ZGNjB5WFE5dVpNU1FPUE9xUzJHWXBzcHBibHN0cDBJ?=
 =?utf-8?B?dEhQNEdrdEN4VkFqRGRNZ29IMThtVURScGZLbTdselkrL2gxNzRxTkVSU3Zx?=
 =?utf-8?B?MkxLM1cvaUI3NU1lQWtoZ243VjFWNXdrSDdlZ3VScFJBL3lBYVZ3anVPZGRu?=
 =?utf-8?B?UHpEeDFoVi9tM0VKcVE4ZUhqanlEVGhBQWxZVmx3WTJuV2tOaVo5KzRQd1pq?=
 =?utf-8?B?YXdHcWJSV3NKOG9WZE83U0FFbGlFd2hzalF1R0xIZitEeENIMm5ZSkl5WXdu?=
 =?utf-8?B?dCtOUnUrOFp5QkpiazNVcnBZWlVRaFk3U1lLL3pOOEJkUWpSVjVHV0pFUUcw?=
 =?utf-8?B?M1FkYzlXNW5ya29aQ3ZyaDJtVklXKzc2K1h5M1lNSGZMdENYQ2EyYnUrb3px?=
 =?utf-8?B?NUdvdmNyc0VuNmh2cmdzZCtqZmZXb08vbDI0N3FXcEk0S1RFM1ppRFRPV0FS?=
 =?utf-8?B?eXkrd2dxSXpkWHZQd1MzUDVFRkpWVWVFZ3YwVng2eDFPL3d5TlZ2cnI5cnhD?=
 =?utf-8?B?cmVsSXVreWVtYmRLbk9Sejh6aDZVTnRvME53YWVxeTNpMXMvV3NrNzMwdXpE?=
 =?utf-8?B?MlNsaE1KNjNsbVFROEZoS0VaWkRRMjdLNWZ1RjkzSTY0UzFFLysrNVFJeE5x?=
 =?utf-8?B?RGRxZUw3eFp3TFRWQzUrNGo3Vk1jMHYzVkZ2dms3QkVGdGNyUFc3T2ZGTzhE?=
 =?utf-8?B?b01UMjhPNzdrVXdKS0tRd3lubDF6MlhYT2xqdVNza3IwMG1kdDc2V29sTjNI?=
 =?utf-8?B?eEJ6RGM5ZzZsWkFzK0xkNzl3cXpjcFFGZEpTMWFEQWxwZ0xYYkh4blNDaFk3?=
 =?utf-8?B?VzcxUTUvT21vU2t2VDdMVzZvM21kRWVWUEpFdlpOSS85MHhMbjFYLzc3Zm1B?=
 =?utf-8?B?MEhJWEoyOElUZDJkRTYrQysyNnRIK2JUSlFlUVFnQ21SNElxcXlObTF5ZHJP?=
 =?utf-8?B?cXBHblIwTnYzalFmZHpFY1BTS2hSN3YzdkJucXRvNXRLTXVQT2pvdTVuYStW?=
 =?utf-8?B?bG5FWGtvbldSWEM1WE9aV0VvTnhRMTg5WmZvVzJZclZoNHBnS0o0dHNGbHMr?=
 =?utf-8?B?MWo3dnJ1b1hiQ3pIV1llSWpjTzFFSm8xUnJKMXdwSHNmbDZiOTdaRm1rTTlV?=
 =?utf-8?B?OGM5Q2NhSUtBSE1ZclIyaUdYZFBzTWl4Z0hKTWpKS1VSaGpkdU5UYndwZjBy?=
 =?utf-8?B?dkZaTyt3S1RvSlJ5cklMeWoreWJwMnprNkJ2UHVqY0YyNEU3azJhU0U5ckRV?=
 =?utf-8?B?am4rOG5BbUVUMlJvSjlwSFI2c3pMd1c1VERKYm92dWorWmViNU9xVWorb0dP?=
 =?utf-8?B?RUEwbVVxblBzR1BFazdFNmdIN1ZTUldIZ3c0cGFiNWh6TUZoNHgzdk50OWJH?=
 =?utf-8?B?TzhQOGtpaVlISUlkbjZ6Q2FVeDBzVWg1cXQ5Z0tSS3J2R2trWHZZbDA5Vk5G?=
 =?utf-8?B?QUhSdXhKV1k3WCs4QUt0RG9uS3ZIVFpFQTliN0ZlK3p6SExGWDNoV2ZpVnox?=
 =?utf-8?B?SDB6bEFmR25PM0hiZm9FakVTM2R3QVNLZUt5UHFHUXBIZlVSS093ZXFGNkwx?=
 =?utf-8?B?UVhUYTYvemRHSkN2Ti9KaFJISlNhbG1IYkx0THpZRlpQQW81dGVFZUpZOEM2?=
 =?utf-8?B?ZEZCeXJ2U2RnSG1rTjVaelhOS3JpUjdFcGJYcGNydE5Ubm1NMXBsRi8vSVhD?=
 =?utf-8?B?ZzdSRlJ1VTNRMmlrM292YnNrWXRTYU1UNjFVajlVZ2tXYll3NHZKc2taSzZL?=
 =?utf-8?B?Q1BxaExhWnJJdTVIeGMvZXlua1hOQnVmVlJQbHBNWWxPQzFBQUhyZmxQSVJJ?=
 =?utf-8?B?NkdySjVXYi84YTd0ZXBtckoxbzlvVy80UlR6TlVod0VqOStyMXpvM2NqT1Bh?=
 =?utf-8?B?R1F5MmhaMkVqVDdyTnF3ME9XYUdVdmFQQ3VmUFVWR1ZEaS9SNkR3bzAyYmVz?=
 =?utf-8?B?dUE3bHhuNENEeld3enEvZVJuSlV1OWttNGRkRGQxaEJzOVBzYTdIdDlySEow?=
 =?utf-8?B?dXI0eVNab2dWRlMrbWsvSjZyL3BBNmZRUXhUSG00bUwxU1dwbFp5Y2FXR3Jt?=
 =?utf-8?B?Y0JWamg0aThZaVZKRUZqcU5oNlhMY05WWlR1ejlsRVFGZnU2MzBFRzNvV3JG?=
 =?utf-8?B?R2pxNnNFZEdjUDArUm5QNCtydWVCWDhlTktYcDZSRjMycjdDVm1iM0NucVZ6?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D13AD928F44C9B408F9C697AAFF4BABC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40e590c-feb7-4fee-8285-08ddfa66399f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 05:58:31.6225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ZQaeVWnV2GfH/tDFO8SwJZCMK7rGLX2FHp8NKQPmsmhAD/LkYV0FA5y8EPj3tMpPvXl7FZeT4zn+I88ZS3ZyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB9491

T24gTW9uLCAyMDI1LTA5LTIyIGF0IDEyOjIxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRpb24sIHRo
aXMgaXMgYXBwcmVjaWF0ZWQuDQo+IA0KPiBIb3dldmVyLCB0aGUgZm9sbG93aW5nIGlzIG5vdCB5
ZXQgY2xlYXIgdG8gbWU6DQo+ICgxKSBXaHkgdGhpcyBjaGFuZ2UgaXMgbmVjZXNzYXJ5Lg0KPiAN
CkhpIEJhcnQsDQoNCkJlY2F1c2UgaWYgbWVkaWF0ZWsgZGlzYWJsZSBjbG9jayBzY2FsaW5nIChj
bGtfc2NhbGluZy5pc19lbmFibGVkID0gMCkgDQphbmQga2VlcCBpbiBoaWdoIGdlYXIsIHRoZSBw
ZXJmb3JtYW5jZSB3aWxsIGRyb3AgYWZ0ZXIgcmVzdW1lLg0KDQo+ICgyKSBXaHkgdGhpcyBjaGFu
Z2UgaGFzIGJlZW4gaW1wbGVtZW50ZWQgaW4gdGhlIE1lZGlhVGVrIGRyaXZlcg0KPiBpbnN0ZWFk
DQo+IMKgwqDCoMKgIG9mIHRoZSBVRlMgY29yZS4NCj4gDQoNCkJlY2F1c2UgSeKAmW0gbm90IHN1
cmUgaWYgb3RoZXIgcGxhdGZvcm1zIG1pZ2h0IGhhdmUgc3VjaCBzcGVjaWFsIHVzZQ0KY2FzZXMN
CuKAlHN1cHBvcnRpbmcgY2xvY2sgc2NhbGluZyBidXQgdGhlbiBkaXNhYmxpbmcgaXQuDQoNClRo
YW5rcw0KUGV0ZXINCg0KDQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCg==
