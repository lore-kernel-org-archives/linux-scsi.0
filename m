Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538E26B748
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 12:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759236885; cv=fail; b=u0zUoOV3POtTvppyGJzD+kpyZEfhpCA7du26pyVSlDu+V+ym+jOs1BnpBhC1AMRhpRaQK5th4nZ9jYtowtvoyOgqR8zzSjLKtZ3QauE1X/qeWWZYFjU8RqZFuCtHcdxHKZRNy29GVld9gpJx3Bysg7taoMZrEPA2FfcUa9OTVKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759236885; c=relaxed/simple;
	bh=SAcnIiYS8eBEf3tIWjvInI5IIVi+aDJN6EOSzNRA7Sc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m/neTOppDqkRBYc7zutIYeeOs59IBDhp1e8pw1FRhVPwp1VerlAzTlbwx8y8qxGof5Y1v7IQyjtRQeSXactkvv8VwKZzQHz3FtzZE//LTqXL9pX0Ln/6kg4fkgu5M0GZldY0sXX7llANpZ6OuQ4LEU9UGPY9V5CVM/K6rdBmH4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=drgKnrCD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BHvFoJ1t; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="drgKnrCD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BHvFoJ1t"
X-UUID: 9fafe6929dfc11f0b33aeb1e7f16c2b6-20250930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=SAcnIiYS8eBEf3tIWjvInI5IIVi+aDJN6EOSzNRA7Sc=;
	b=drgKnrCDlvI6udr8CykYIRPW3MDxpmjkItTTjtPRg53AsT0ws86gd8sgPqGKg5GzheDKaqbaYuZ3ZU0oXgGgiDLNrA77xifP3jTHTtmRm1VJyEvXrNS2Th5oXEwy9/AxAq1SkIV8mbt6NjZK42bXY1aI+d1XJJNqc6PMwEcfGqA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:bd884321-4bf6-41af-aa4f-3085d654d3c1,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:aed8ff21-c299-443d-bb51-d77d2f000e20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9fafe6929dfc11f0b33aeb1e7f16c2b6-20250930
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2333962; Tue, 30 Sep 2025 20:54:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 30 Sep 2025 20:54:35 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 30 Sep 2025 20:54:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1ZN0knOhtGA7RslDNuQS1BvxH1WLoruYkDFxmn6j8yX6FnWOZu9lEcmbuAZgLN6tlVtnVftXQISRiI/xPEpgbigpts+nkWwdo1Sv1lKtkQXqKzCYPy98cpCZAtiEnYwe/5R3CF26t0E5zEczSiBS89hbut2FQ8gbrIxrbCwFIwfCO0WRf9k4ljTsHvXr1pD4KMmDttkjbfzNJxMf4MlcBHTdJjVa3ebX8D4fW3oGT1U1gWRmxEe9bCeuvWSzbb/LQZBILAQc8ICQRhGJEEayIdeYjSLhM+JiLxMLt6Xi1eZ59uJfW/ukkIhWj87edMmleHL2Xo9ovJ49AufGZ/7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAcnIiYS8eBEf3tIWjvInI5IIVi+aDJN6EOSzNRA7Sc=;
 b=umIZxP54cf+jbvSTS4yb17CZiS+PcQWro4tehWlsx5w2BRLEQnpVt9438dESUWEfqajnnadn7wagWTB4jNE5tSyxbPoWMm3SWk+qUjYDo2r02i6Wh2spFErxUCKX5oKMx6hWv0dGEDXKt7bza4//KKzNzXPLJGmjd/zkrC8IvFrrLAGgHLDANxPEoYWBCNAExChrGEPkHwju8JKFeb4K7n2F6RdIij8k4dQjCvwyg0GX1Cb9LPZSX8wtc8GzTu75iXDsPTSVszAZk4oNjyCkEg3nwCcWKtiCJ197/R3ejEpUcKZ20KalYLFyG6IBV7G6EqE+EVAEishvYrsgjgaXMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAcnIiYS8eBEf3tIWjvInI5IIVi+aDJN6EOSzNRA7Sc=;
 b=BHvFoJ1tDdBAFcUVme/TesKgY/+bQB0FviBp7ROMCaIRNTWqXvTs79yA87G+gNDDRDW3nF7VVWG+Sqp5+V/6c1gKrpZE//sjnoVV+H2/sevxu0dDjdjQYMK+oFGLp3Nl/xLWk7wAMokmuzHWf/P/Jh5Gx93WWEpvgH0y+2SJDOA=
Received: from KL1PR03MB6391.apcprd03.prod.outlook.com (2603:1096:820:96::9)
 by JH0PR03MB7465.apcprd03.prod.outlook.com (2603:1096:990:a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 12:54:34 +0000
Received: from KL1PR03MB6391.apcprd03.prod.outlook.com
 ([fe80::611e:e2a6:1614:b9f9]) by KL1PR03MB6391.apcprd03.prod.outlook.com
 ([fe80::611e:e2a6:1614:b9f9%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 12:54:34 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v2 0/8] Enhance UFS Mediatek Driver
Thread-Topic: [PATCH v2 0/8] Enhance UFS Mediatek Driver
Thread-Index: AQHcLTf3Dcuqj7lnwkmYe3xhFILaELSruEyA
Date: Tue, 30 Sep 2025 12:54:34 +0000
Message-ID: <dc80211c4a31b03343fe9646bd194dd59d36159c.camel@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6391:EE_|JH0PR03MB7465:EE_
x-ms-office365-filtering-correlation-id: f6f2de70-5c98-402e-a7e0-08de00208160
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NDNSbEdtM2xlSjFtRHRZcE9TZjFObEZneU8xMWkyd2FpMyt6aHFXQngxa3Zi?=
 =?utf-8?B?M2NDaGRNc3ZrNURDMTluWmFLRUdGWHMrWW4zQ3lVS3BZRzBFZzVDUlVZdU5x?=
 =?utf-8?B?YUMvdkRqV2hDbURWTXRvZGtaMmdweko0YzlEampscmIxZ3ppYW9MeHhmWGhw?=
 =?utf-8?B?bHd0TGhPejlpT2QyZEtwYTVBOEVVWFFHRDJjTXpqbm01Si9lTXB4ZkU5Zk5E?=
 =?utf-8?B?Y2k1REdKekpuQk85Ti9ON2M5OXpreGozcExsZEZVQUovdG9GMmlOQklMQWhF?=
 =?utf-8?B?a2NmRjJsZ2NMdUQvMW92SGRPZkg4dXh2Tnh5VVBHYWtrOExzZ1Z3ZjhUaDlF?=
 =?utf-8?B?bXJPbURRUU54SHh4MlZGT2M1aXBLeVJtOWQ3UGMxWmZvenorQU5qRkdjWWcy?=
 =?utf-8?B?dVNJdWtFQmptYnRKSGc0N0lrSDZRdnVmTW9DRmJqNGNyNlQvelIxVmFESkVR?=
 =?utf-8?B?YkN6M3ZRdWVud2dWcjhISHdlaWtkSSt6M1Q2cFczMFJlck51Z2QxY0dvWENU?=
 =?utf-8?B?NEFFOFJ4TGE0d1ZpTk9GY3kydm5lUGN1RzdaTUlzM0R4RXYrVUtRckpka05V?=
 =?utf-8?B?ZjcxT0lTUStHUEordjFPVytaUkNwWVk2ZkJPL3lLcGw5eG45K1hkQ2FHaDEx?=
 =?utf-8?B?YmlwL3gxWExUQnVXUEJ5djVwUnNDZElUUFRrVjFlc0RXejg2cFlCZ25UZVZU?=
 =?utf-8?B?Sk9na3JvT1JIb3BBL2Q5NHNLc2VKcmJ0TkpPSkRTdlF2REM3MGRmWnplV20x?=
 =?utf-8?B?aHphcERvMHJGU0JJUkQ5WVdhN1JQMVJ0SDR0TUNtdlVzMElVY0VSNWhUQ2Zm?=
 =?utf-8?B?cE9odFZsek1JVklDUDhaakk3MVEra0hicmFuVkJCM1QwMzZLYnBnSFlyN2JB?=
 =?utf-8?B?b24wSDI2R1ZOZUZtYVlJSkYrcTNyWTljZjM4eWhvZGx6VmdqQjUrUlpCYUZX?=
 =?utf-8?B?amYwTmlTUHI3Nkg3eGh5RXkwdEZMYW00NFhOMmpaeVBEV2FYR0NyV25OU0RH?=
 =?utf-8?B?cVJFTkk1MVRBNWpYQm5uUURva29wNVhIeVlkNHhZOUFMSDN3N0xpa0M1UFIw?=
 =?utf-8?B?T1preTdxaEMzUndoMG5SbHJUL0hGU2h6NVczOFpTeXhDT1dyYncyRXV5SkxW?=
 =?utf-8?B?eG1KVnBuUHNTTDg5OUwwS2JiUWt4ZERncVdnVUdIMlhRQTA2VncwbTRHS2Fl?=
 =?utf-8?B?RlJYQjk0d1FIS1pVQ0xDbDVXVDN4dWdHWTMxVDk1c0pzSS9YQXFtMFRUbUg3?=
 =?utf-8?B?RGdEbHJhajNSU3M1ZExGVlorcnY1VUlkcnErb3VrKzQ5bmEzWlJYOVpKb3Nr?=
 =?utf-8?B?VEJKQk5XeERvU3RWem55WEZlOEc3eU82VkNDMndFV3hSSzBHY2VTWVhMV2tz?=
 =?utf-8?B?N20wRHR3bW8wOEd5b2dGZ2tibHlaOWNBQjJPYVd4UmtvN2tPUFVLWmYzKzNs?=
 =?utf-8?B?OEVkYzdEczhEZFRUaUJzR2gyV2xwVkI0TTZIU1d1VDAxMnVCU3FXOSt0WmQy?=
 =?utf-8?B?QXZOSTZLeDFONzFxRzBXYXRBb09EcTMzU0N4Rmd1OTZ2STBmTndScWEwOTl5?=
 =?utf-8?B?Sy9LSUlTdmJtZTRhU3dsdHNORW5lY1hReHZyeVJ6NmFzaWQvMlVtRnd5SS9r?=
 =?utf-8?B?TG9zdUFqOWx3SzVGSis1ZHZFSGJxQkRRK09DTWJIM0NxNk5QWjcyR2tKNUYx?=
 =?utf-8?B?andMUExWT0NQSEdpR3NMVnRocVhMQlRwWFFqR1A0bFdBcC90NUUvRlVoRFBk?=
 =?utf-8?B?aXdiZEtFVzlEZDlSdlQzVndGRE03TmNTc0VhN0tkb1k2M1ZrWi9DRDkwdzNU?=
 =?utf-8?B?NXhKL1o4RGJGY3pLQkdCYnRKeFdTM0tialdNYWhPcnZyM1pvOFNlRXlSQ2ta?=
 =?utf-8?B?dXh4MnY4azhjU2FHbU9MWDVVYURnakltSVZCOFZrK01Va2p6SGEzd3pFMndR?=
 =?utf-8?B?WnQwK2dmQSttUTJtS2NHMm9QUXhTVjFKL1lHMVBSc1pqWVAvUDhxOHdDVTIw?=
 =?utf-8?B?UlJiWmNnZ1dPRWZvSlBQYU1VVWRkMStiKzBYU0pHM3R6bDNUdVJSeUJ2QVlT?=
 =?utf-8?Q?xyXudQ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6391.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3NIdlZiSllSRFpRdDVGNTBFcWZESnI5QUJzOEkwVUJ2SnpuQnBaejAyRFU2?=
 =?utf-8?B?SEg1ZmoxUUNjVW1JbXRnRUxvaE94cW80d1RUNUVsdllIeEtoWFBxc2pxWWor?=
 =?utf-8?B?djJQb0tmMzQ4aHFyR1dQU095aWM3R2ZaWnhTMHdlaGVSUXBPWDQyR1V1UlpC?=
 =?utf-8?B?TTkzN3ErdURsR25MWk8zT1lIY3c5aW52OElQNERBOXdoWmVnNjIveGl2c0tU?=
 =?utf-8?B?ck84azF2Zm5rVzR3a2VHUlVjejN2aXFzOHdoWkRjMDVKejI4VlRjaTFCTG52?=
 =?utf-8?B?NFRSTWtheU12eEN0K3FTcVkzWjZDemhQQnAwNHpYTlQxTEc1RlBaK2dxdDVn?=
 =?utf-8?B?dlNVODYxZjFHVzNYQWZ0MElQRHJLNlY5L1doUG00OGdiVFRPNi95SmpNSHpN?=
 =?utf-8?B?VUZYM0pWdndhSWRxWmFVczRnTDJ4VmFIVWVJZHU0bEltQTFSdDVVSkFTOVBS?=
 =?utf-8?B?SzBpRVU4V2tWM015MFhsYkFMUkdzWDFoQm1hdHFRdnBhMmdIODdnNmIveFAw?=
 =?utf-8?B?V1RLcGEzWVRvRWZ0MXY0SVFZMnhRMzlNdTVTZnNGbHpabnJPUzJlajI1SmRj?=
 =?utf-8?B?YkNoSW5RRTQ0cHRVR0dqWXhBUEFBTVBTdHRFbExWUkpTb3U5M3JLT09qRlNa?=
 =?utf-8?B?R0RUVGtLOGVrQXdaYUxlbTdncyt2c2ZSNjF5L1RVTjZNeENnNkpjNm5acjcz?=
 =?utf-8?B?WE01bUxJQm5keHNSeExMcWt5dE5Ic3p3b0ExdlM5L3p0RUR6dDNkbmlWNWky?=
 =?utf-8?B?TGI1L0Y3dWRVUHhZWkhpOU5KbXFFWU5vL2hYSXRHbC9nTDVMNUU3ZDA5S2k5?=
 =?utf-8?B?dFFnTFpzR1JiQUJMcTFsSEl4b3lXeFhzbzg4bGJzUlpDRldIYmtrbmVRelF2?=
 =?utf-8?B?QURSSUVYellvQXdaSUQ1aDlmNHBsSitPcUEwNHhFVzc2bGhmbUZCejVMcmhz?=
 =?utf-8?B?ZHE5T3FYRWFPQkM2S0NMd09JSHExZW9sV1QvOVBpWHVOcmsrR2Iwd1dSaTQv?=
 =?utf-8?B?U0RGYkQwSy9HNjJpU09ZZTlBTTZyRW1EMElkVERoOEFLVTZMQjVveG5hT2Jw?=
 =?utf-8?B?VDRVcGtkb1plR2M1UVVCOGNHaEpTUXFEcDVMYzMyRXVTSGg2VnMzQzBwVTUr?=
 =?utf-8?B?OVBwZE52Y3pBdlRoRjZ3Y1lOQ1B5Q1F3ZWVwNEFZMmlVQjVUSURQWmpjL1du?=
 =?utf-8?B?UEFOWCsyL3ZqSmcwN3ZwaitySThxaWdQbCs0RSttT05KRGpsaXNaRHhxSEpL?=
 =?utf-8?B?MmkxNlJWS2ExazIzK0kxSkU1bi9iMjJxcndwQ1pVeWdiMU5OeTdaTkR3ditZ?=
 =?utf-8?B?R2lVY3ZHcmlGRDU1TXVWL1pUUjlsSm1Md2FPd3J3UUtxT0VKMmt6WXNhSlFh?=
 =?utf-8?B?Q2dnOXpNZzhNTHpLb2FLOFRBbGZmV3NXdjhzS3ZSOWtuTDNHbk5kOXI0K1Bp?=
 =?utf-8?B?am9lUlNLbGtBYStGeVlSWDdBNVA3WnByOW40ekpvNXdOOEtsRHRsWHB1ZllX?=
 =?utf-8?B?VWFScVY1MjRPcHd6Mi90aURrUnpRZXJMN3hlcFl1SFY3bkhLeitmUTJTaWRE?=
 =?utf-8?B?SmJscDBPMGQyeFBnZTlFdVJtZVdNNWh4aDZ0b3h1QU1OY0lpdEV6ZUJJQ2J5?=
 =?utf-8?B?MzBTL24zd09yZ3ZZdVFzZk12UDZNb1Nhc29KdXlPM0tzcEY3L0V3YWhucjlB?=
 =?utf-8?B?emtFUzJ3cEF2aDJ6ZW1rOWxodGxhOGNjUW0xN2FvSmw5S0RaT3IvL2VYWkY4?=
 =?utf-8?B?eE1aQjJqT0IyOFU3NkZBR3p3SjQ0YnRvYjJoM2ZsSFphS0FJOEVYWWxHS3g2?=
 =?utf-8?B?N1YvS3JuRzlvZGRnN2UySEtKekxublpVMGJseC9LMmJXMm96SFFtWDE4aWZ0?=
 =?utf-8?B?Y3A4TjA1STFlSW9CaHI2eXBUU2Y3Ky9xN3JQcGpMeDVVNkk4dU1PSklCNWhG?=
 =?utf-8?B?eHF6WGZvbjUrZ21rNFhKWkRGclZWYzBuSzV4OWFOTHhoNUFONStRQjBIWmhO?=
 =?utf-8?B?U0ZmU3dwUFVJa1Y3MlRINWlRcEJZWWUvNUI3N004Y1MrckdQOHBhQUJCOEpU?=
 =?utf-8?B?VkxRcEd4dE0rVXd6MmUzZkdaTFBoeGVjd2NOaFZQVmh5SmhyQzMrV0V0VG9Z?=
 =?utf-8?B?RXoyNTRzWCtvUml2MThvbE11ZFI2VWRmV1NueHRqbXlDbDNIcFRWSFRJRENm?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE838E1F93954B4EBCE9F881A3BC7870@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6391.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f2de70-5c98-402e-a7e0-08de00208160
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 12:54:34.2583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAj86HPJy8n52y8s8cyqdDnsPq4Z8DjC4VWJ2GrJWOeIt1w0nSaMwuoNLA8ozwdhkgAZMJ3MrgQCzNaP3YpcyhYqdLuNYj8kd2y5zhOVhik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7465

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE3OjQzICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBJbXByb3ZlcyB0aGUgVUZTIE1lZGlhdGVrIGRyaXZlciBieSBjb3JyZWN0aW5nIGNsb2Nr
IHNjYWxpbmcgDQo+IHdpdGggUE0gUW9TLCBhbmQgYWRqdXN0aW5nIHBvd2VyIG1hbmFnZW1lbnQg
Zmxvd3MuIEl0IGFkZHJlc3Nlcw0KPiBzaHV0ZG93bi9zdXNwZW5kIHJhY2UgY29uZGl0aW9ucywg
YW5kIHJlbW92ZXMgcmVkdW5kYW50DQo+IGZ1bmN0aW9ucy4gU3VwcG9ydCBmb3IgbmV3IHBsYXRm
b3JtcyBpcyBhZGRlZCB3aXRoIHRoZSANCj4gTU1JT19PVFNEX0NUUkwgcmVnaXN0ZXIsIGFuZCBN
VDY5OTEgcGVyZm9ybWFuY2UgaXMgb3B0aW1pemVkDQo+IHdpdGggTVJUVCBhbmQgcmFuZG9tIGlt
cHJvdmVtZW50cy4gVGhlc2UgY2hhbmdlcyBjb2xsZWN0aXZlbHkgDQo+IGVuaGFuY2UgZHJpdmVy
IHBlcmZvcm1hbmNlLCBzdGFiaWxpdHksIGFuZCBjb21wYXRpYmlsaXR5Lg0KPiANCj4gQ2hhbmdl
cyBzaW5jZSB2MToNCj4gMS4gUmVtb3ZlIHR3byBwYXRjaGVzIHRoYXQgd2lsbCBiZSBmaXhlZCBp
biBVRlMgY29yZS4NCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogRml4IHJ1bnRpbWUgc3VzcGVu
ZCBlcnJvciBkZWFkbG9jaw0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVrOiBFbmFibGUgaW50ZXJy
dXB0cyBmb3IgTUNRIG1vZGUNCj4gMi4gVXNlIGhiYS0+c2h1dHRpbmdfZG93biBpbnN0ZWFkIG9m
IHVmc2hjZF9pc191c2VyX2FjY2Vzc19hbGxvd2VkDQo+IA0KPiBQZXRlciBXYW5nICg3KToNCj4g
wqAgdWZzOiBob3N0OiBtZWRpYXRlazogQ29ycmVjdCBjbG9jayBzY2FsaW5nIHdpdGggUE0gUW9T
IGZsb3cNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogQWRqdXN0IGNsb2NrIHNjYWxpbmcgZm9y
IFBNIGZsb3cNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogSGFuZGxlIGNsb2NrIHNjYWxpbmcg
Zm9yIGhpZ2ggZ2VhciBpbiBQTSBmbG93DQo+IMKgIHVmczogaG9zdDogbWVkaWF0ZWs6IEFkanVz
dCBzeW5jIGxlbmd0aCBmb3IgRkFTVEFVVE8gbW9kZQ0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVr
OiBGaXggc2h1dGRvd24vc3VzcGVuZCByYWNlIGNvbmRpdGlvbg0KPiDCoCB1ZnM6IGhvc3Q6IG1l
ZGlhdGVrOiBSZW1vdmUgZHVwbGljYXRlIGZ1bmN0aW9uDQo+IMKgIHVmczogaG9zdDogbWVkaWF0
ZWs6IEFkZCBzdXBwb3J0IGZvciBuZXcgcGxhdGZvcm0gd2l0aA0KPiBNTUlPX09UU0RfQ1RSDQo+
IA0KPiBOYW9taSBDaHUgKDEpOg0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVrOiBTdXBwb3J0IG5l
dyBmZWF0dXJlIGZvciBNVDY5OTENCj4gDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnMtc3lzZnMu
Y8KgwqDCoCB8wqDCoCAzICstDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuY8KgwqDCoMKg
wqDCoCB8wqDCoCAzICstDQo+IMKgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDEx
OSArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gLS0NCj4gwqBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5oIHzCoMKgIDQgKysNCj4gwqBpbmNsdWRlL3Vmcy91ZnNoY2QuaMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArDQo+IMKgaW5jbHVkZS91ZnMvdW5pcHJvLmjC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDcgKy0NCj4gwqA2IGZpbGVzIGNoYW5nZWQsIDEx
NSBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gDQoNCkFja2VkLWJ5OiBDaHVuLUh1
bmcgV3UgPGNodW4taHVuZy53dUBtZWRpYXRlay5jb20+DQo=
