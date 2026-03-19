Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C733C13E8
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773924011; cv=fail; b=Bwzw/ER5TC5vQJqQOnglGIDdiH0AQp8b8wmWXFqQDK8SQR5b2x2lszhURep3EuUOGfyFhNhz4RcJLXSTU8in45NyaFXcCg72JpW1/X63b9/AHSpgFp9O6+zyvKra/X/2qzSZeLtXYcVx/CBVgza5D59nSn+OWnUythAaHogpXRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773924011; c=relaxed/simple;
	bh=HbtZzbd6rsVafP5bXJ++xloXtmo4YptL5GLuqzHqKGM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dZRptQOvcGjecA4jOTwG/C5dQGab+8zWK1mYuHT4+FhF0DgavP3gzm6+1KJVkk/fTte8MRnP9CIdC2rxii2fMTjK0DKa3C1hfwd50ZcuU34bfxiAIXGvCZ3LCd7cD+hPGY8Yz70vmc7kgQvgu/8EcFG/sulbjW+2pObOkMloLno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F1SPiK3i; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lPVw1HeJ; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F1SPiK3i";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lPVw1HeJ"
X-UUID: bf0c4fd4239011f1a39cd589f645bc18-20260319
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HbtZzbd6rsVafP5bXJ++xloXtmo4YptL5GLuqzHqKGM=;
	b=F1SPiK3i2cFuMMxyaEQ9awWcyJB+VhsmMxaQJSdxDSkzxb38CdVYl2/XaS1MAwOvjPlEHg9nz4UZzIirU4BbleBDVzBFlQzuzFKG2Cqp5XN31Xe2cX0Tja4GX1tIt4HvY2st4fAJvt5NhnbCH5yjzybqJpNE5aa5LEDzpmJAJyw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6039515e-bf81-47bb-899a-c3435cea676a,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:c5aaaf4c-9183-487b-8624-e74f2dd98990,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil
	,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bf0c4fd4239011f1a39cd589f645bc18-20260319
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 864122326; Thu, 19 Mar 2026 20:40:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Mar 2026 20:40:00 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 19 Mar 2026 20:40:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k2hc7aoE2uBU5oo+bWghSfnZCqxEp7NYhuclplHXHoh3/eiSU7up0puEa/xCK1L1End9Wiitihr9KFMnUrU6loukpvwvcPwAOcwsCI4lpUb2FkCzhGS+1MdJgqutN6nl91NdI2xz1ssiLp/CN7I5/4qEAcc9ZJCc8/euHabGqgzSMlQGCZTWVAVDjmXygNA4KKtKxZYaVdjwuOckBvtKeLBEW0pbrif4rwdNRGcyDRkO4AdDe8I91Dd3BUjfMaPsdD4kmtkSoDj+Rul6+i7XMOeBPKAbtCyCh2EC2/xLFsQqzOwPWTqHyPbP1KQF9z9W9Fr3sNT2jExVN9heNitJ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbtZzbd6rsVafP5bXJ++xloXtmo4YptL5GLuqzHqKGM=;
 b=gDq+xHXY14JBoIO5CoCBmjVFuvNsUMTotYQui/4j1oPk/qNbHkItyouT2hPqwHp0vPFiIKHqhXNz0kUEWiRzQxERW9HP8IXmzNKaWuN3MxU+QrvwxOScUV7R2m8uyE67ST1fUaEg8wunRFRfqDr6VYlLYzm+EEs7Zck1jmqyR33Ov24cJGb+WkphcxuKILoDXfb1GS2pC2/skkDCj+ERIKLF+CQksexm0Q05G7ay+vtO653ksX43tcc75z1PdscEq3nf4rznmGPI7qTBokz2Sum+QIEiLRS1D6eOEK68P6XfvIHqMpFtXEeoyUpULkjC3nncITTXJCpYQwS2gGdoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbtZzbd6rsVafP5bXJ++xloXtmo4YptL5GLuqzHqKGM=;
 b=lPVw1HeJJkoODOk5l/FKufxXiv3urfkPBOF0aMZiG/Ta0MsLWzvCBuljOk9Rf5rbOgH4DUo/j72DuvZszhtNQWK3DQyD80Cugbk0R8wMwGN7Xq/SmibdNYT4TuzJEuX+i2ZxIkHvO6C8NOQJgyB2+b6JbtxGom+JyIwXWrydOzc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8648.apcprd03.prod.outlook.com (2603:1096:405:b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 12:39:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 12:39:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Topic: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Index: AQHcrSxPGnfAtrpK0kOvBMCDgGF4JrWzB9eAgADmwACAABV/AIAB3IwA
Date: Thu, 19 Mar 2026 12:39:57 +0000
Message-ID: <273fe7ab805f050ca185aaa9c48da7995f7558ee.camel@mediatek.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
	 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
	 <a341a70943ffb8b8c5bbc9b4e19c017fe664fdf1.camel@mediatek.com>
	 <473ecf74-1907-42a2-a785-6164720cb641@samsung.com>
In-Reply-To: <473ecf74-1907-42a2-a785-6164720cb641@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8648:EE_
x-ms-office365-filtering-correlation-id: cd2c312c-82a0-4153-b7fa-08de85b4a0e8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: w7vuMHWbGyx1TEOT0gmhL2xpqD2REmFjca4wkpjVUlx65MQxCUOQxUda3VWi7UAyl3FRUPfhgZ6c4WCYXQnjLeMZinhcPxQF4763Yobpj7KwahpWJsFNj4ZkmSxlGnwmfYf44veNk4x9tHeN3ChgnxuuGW+2oWcGjG0qRQfzy8AVHbsaFrVCXVhjNrzsLoFcH0/i9rd4lswXNuN69Jo1OFD6bl4LUv/8dWyYBy/yWy67IKvxff/uCpAVOTeVghV+TNCkJskH4VYuiCFGcJwXEHrONVFxCs0IoK+VFCcjlisfTQKu9olBkBThmPROywZm87dzc6WZDSRm/hqVoTrRkTX5fI6zpy0tqfd4gAAUw1H1LUD6+lX+lfKaoO08qoqNhfO1Ook/owbsD1dsiU7WTvCUFrGGJTOGebKKSPgXssNo3ihP4D75U5tX0gNzT5y7IqkUPwGMCG1NpslRtsRXLiV6Smr/6Qcn0x/RGX0+NXUPiBa53HoSIerYVtQfI35lM9ZlEEso0KLqnZSvXFd48QvtZmX18rmpMCSPGRvmoaiO5f7EfQNfST5HBzC+v/lsHiwVsTpfTh5bWMKbnlGX9wbmTrgaglgLIHBa8IhtAHyv+AvQlUzXK0mVQdt3agFhscfhuP3yleBrktd34ppHIRg6F6Qg9ChgRGo8zkLeb82dOIJyzm7P9aTIRoFgLIgnQphdlcVcU1xiVTaXOuYpDoqiU1YTeMEQP5QNK0gwPBdB7N1tQF9OQf9o/8PfU3QCvx+PTtTSpaN06auC0TFNvy2FNP2oyY/xGm9LqxWod9k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2pZNDB1YU5YNFhLbXNlZDhCKzFSaFRNeFBINnYxbUpkaHEyV0dHazF4eWhp?=
 =?utf-8?B?SVZGR0RPQ2Q5SHlldWY3ZGpOdEduV3Bpa2IwbkJlSUZmb3VTMDlNOFRJOFdM?=
 =?utf-8?B?eW1RMTY2eXpDRDlEMHhuZzhXSGtEQ2dIdDM2QUxXT3g4bTdkMlphUFpVaHNR?=
 =?utf-8?B?M0VmbWNZaUZuaTJTZUlLL3VySFltRGoycXJqeFZJUFk4ZVY0Vno4cWhEWWkr?=
 =?utf-8?B?R2hJTUVKWExMT0Y1ZGs0SXRaT2FDeHU5Ym1icFhMRld6UmpsY2s2eUl3RkFq?=
 =?utf-8?B?b0VaRzFUbUVXa0NONlk5UVBuMm82cUpaMWNHSnpoVHN4Vk9FTUxiMGNxa3d6?=
 =?utf-8?B?aWx3QkVOYVVQZnJpckJwVkpaY1kxWUpKa3BLU3lJb05QY3VRZHo2UUNyMnJ5?=
 =?utf-8?B?SitxTTR4dGs1enI1Y1JJajB1OEZNaUpHYjVneEFKVDVKOVI0a3FZaktJYjY1?=
 =?utf-8?B?bXZoZVpQTWxFMDNYNGlLMUR3RnJJQnFHWm0yK1Z3a0lTd1FBWCtHTThQU253?=
 =?utf-8?B?MWFxNGhhVDBkMWxQSVZhWmMwdWROTmlGQUtFdWFKUEIxWFFXVUovQ1MwZkhD?=
 =?utf-8?B?eGxybUw3NmlGNk0vd0VZYklkaDBCOTB3Y015VnJmRHQwSENubGF0WENJWk9H?=
 =?utf-8?B?eEpXVmxOMk5KSUtmWVlMV003eGVSaG9xTERHbkRiVUdPUG1sQm05NU5VcE9a?=
 =?utf-8?B?L05YQXdReFhYYk0wbW56Sjg5T211b3U5d29POUV5bHRrNmZNOGl3c2NCbU9m?=
 =?utf-8?B?VzNmZkFNQ2ZtaUdKVjhaR2FMeTQ1V0YwcGZTclFmQ3lXd1pyYmVlOFZ0NGtR?=
 =?utf-8?B?RGc4ZGRkSHduMm5ucW5hWjdZWnVpalV0VE1qYkc1a1hCUjRLU3BVNGViTnZp?=
 =?utf-8?B?eVhnbW9jMzVhbzNtVFhORmo5ZldJU0dVQmFEN1gxRE1hOHdqZ3dEK0FrOVUr?=
 =?utf-8?B?ZmNjQnZLd2lDenJpWUs1b0N2R0xhT09vRmQ5YTRLcDRpa2Yzc0F5SUg3NGh1?=
 =?utf-8?B?V3pxWFRXVkFJMjYzSmxjb09hQlFxc1hOOVZKNWdLU0xBZTVtNk5DV0lxaUF2?=
 =?utf-8?B?VG5oNmxMV29UTnJTbWJCdS9DN1M0UXNxUW9jTDBNemlhWjJ0a0tJOTBTS2Nu?=
 =?utf-8?B?WkxuQVRqMmNDUStTUjFHbjU4VXVUQlY4TDNxamYvZnc1cUNyTGJEM1JOcDlZ?=
 =?utf-8?B?WmxZZmxiWmVqUklUQzJubTViVHgyM0pheW5OMTJVb0lLMGF4aE1WM1FBSmY4?=
 =?utf-8?B?eE5veDRNdjlsbFFhWUJwdHpCWTBQN3BlSWNKWGxSRE42cER6SUMzYlFiZjVJ?=
 =?utf-8?B?eWhqVk1ua0cySEhHVWh0TUJwNFNkc2o3ZDlrNklqcVFuelRWNEtQQ01KUnlw?=
 =?utf-8?B?cmR5cFM2NWphbDlzenBSdGdoUjZVSzFLUDc4enRiY3VST0ttaWs5bnE5WnVJ?=
 =?utf-8?B?eGlIZHg5bmVIQ0Rqc2tZNE1tWGYxa0d6eUNVUkttTGwyKzE3b1h3ZDNiQWFF?=
 =?utf-8?B?VUViaDFuMy9IL3RvMWVIWEd1SklBdUF2YkVZcm9LdnJsdjdkRFI4dHBoM0xF?=
 =?utf-8?B?L0M0SXh0VitlVklvbVJGTERONDc1ZUNGcU8yQ1RpbXI4cUNqTmg0NzRqQTk2?=
 =?utf-8?B?YWt5QXU0VHl5c2VZUFpNMitKNHRiZVJYWHF6SjgrbG9qMUJTdTQxTUlZcHFJ?=
 =?utf-8?B?R1FvZWJ6eXMrS1RxRytyenhQTmRSL0dHUFRlMkdLbnhmK3Q4R2grekZ0b0RE?=
 =?utf-8?B?MlJmM0RLcURTQVNQOEtjWUtoTDkrY1dlK0ZwU2hMcmZKdnpwN216VjZtMkZj?=
 =?utf-8?B?b2NCY2dtQnh6WS9JUXhWZHN0VDZXanZjcXBoenB0VUV5eGIxNmVKdjRyWmtV?=
 =?utf-8?B?Q201MFRZT0czN2hZMXhYbS9iL0xlNTZSUy9WazF4b08wZlN6RDc2djN4ZWZ4?=
 =?utf-8?B?bytHNFd4Rkh0RjV1SVJReFJEZ0JGbkRvdnRQR3A2VmtaRDQ5QW13QWxMaThr?=
 =?utf-8?B?UUhiamk5d1YxdmZmU3RMWDVRNko4WUJ1TXhLTGxYYVh5a3E5d2duamk0RHJX?=
 =?utf-8?B?SDR1aHpMbzVVdi83M1A5dis0R1ltbzNpOHdTWXZwODR4VnJEU1hrSzFQV21r?=
 =?utf-8?B?b2lkWDZZalJQN0tHbWVlNHVYYUlmZUk1aUhJVlhBdXVGK3VpcHpmMXd5cnRY?=
 =?utf-8?B?anB4ZldhOFI3dXZVVnpkdEtPdXFPTlFtbTI2VmVGL1RVVHh0cVYxVmR1K01u?=
 =?utf-8?B?UUEzM3JVTkFkWUg1eERRZlV5MFN0d3k5WEZ0V2t5Znc3cDhqa1VqNG1HUkYr?=
 =?utf-8?B?dEpkTG9VSGZJSGs5UE90WGtnVjRJdzlCZ3VibmFKcjFQVTdXaG1nczB6b0tw?=
 =?utf-8?Q?lnHycbL3j9Qx4eHk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC6446EC19B7AF448249E93804D6E62E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sW1wyMoIURl1AzrY7gg3gT1YImh3FxmoQLixUXzGOCZIr9GLh8jgVJSGJaXAmqYkf7dOKUbqbDGflGkEVWusEO5AJVEinarA+482aEasgvRSIxDoKxZXL6yw5N6wV5CZ9FqHiA0iFkrKvh64iAd7c4tWqLvocl5HgCbXPjN0kLrtW48OtItTy7llSCCdJzsjEfnH6W1QLE+xsvrpgTkOL/6NQ2/o1VKR3JdEACpULznYiA9t9Gr3e+9oxf2ok3Wstp0YmpbW/BqcQe/oTTf0E+53aRo9faZWK1ca2xGWomuV6aFyfCGCt5BL4iFzoXOKLmkBYr60RbU7keO74UC1FA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2c312c-82a0-4153-b7fa-08de85b4a0e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2026 12:39:57.2789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKiiKelf6ToQMu8aRRGGJIO0q2EKaanBPrpdDJ996IysBVMU8+5BxinLJ+ozzhmIVzx/aBajrrgpmp1lCeD0Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8648
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTE4IGF0IDA5OjE0ICswMTAwLCBNYXJlayBTenlwcm93c2tpIHdyb3Rl
Og0KPiBDUFU6IDAgVUlEOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgNy4w
LjAtcmMxKyAjMTY1MzYNCj4gUFJFRU1QVA0KPiANCg0KSGkgTWFyZWssDQoNCkkgc3RyZXNzZWQg
dGhlIFVJQyBjb21tYW5kIGZvciAyNCBob3VycyBidXQgY291bGQgbm90IA0KcmVwcm9kdWNlIHRo
ZSBpc3N1ZS4gSSBhbHNvIGZvdW5kIHRoYXQgdGhlIGxpbmUgY29udGFpbmluZw0KIlBSRUVNUFQi
IG1pZ2h0IGJlIGEga2V5IHBvaW50Lg0KDQpTbyBJIHN1c3BlY3QgdGhhdCBsb2NrZGVwIG1pZ2h0
IGJlIG1pc2p1ZGdpbmcgd2l0aCAiUFJFRU1QVCINCnNldHRpbmcuIEFmdGVyIGFsbCwgdXNpbmcg
c3Bpbl9sb2NrX2lycXNhdmUgaW5zaWRlIHRoZQ0KSVNSIHNob3VsZCBiZSBmaW5lOg0KICAgIGd1
YXJkKHNwaW5sb2NrX2lycXNhdmUpKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCg0KV291bGQgaXQg
YmUgcG9zc2libGUgdG8gdHJ5IGRpc2FibGluZyBsb2NrZGVwIGFuZCBzZWUgd2hhdA0KaGFwcGVu
cz8gSXQgc2VlbXMgbG9ja2RlcCBpcyBldmVuIGdldHRpbmcgdGhlIGxvY2sgd3JvbmcgDQooaGJh
LT5ob3N0LT5ob3N0X2xvY2ssIG5vdCBzaG9zdC0+aG9zdF9sb2NrKS4NCg0KDQo+IA0KPiBZb3Ug
aGF2ZSBwcm9iYWJseSBtaXhlZCBteSByZXBvcnQgd2l0aCB0aGlzIG9uZSANCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL2FibU5rUkNfdlNWYVAyc0NAbWFpbC5pYW0udGovwqANCj4gDQo+
IEJlc3QgcmVnYXJkcw0KDQoNClllcywgSSBtaXhlZCBpdCB1cCB3aXRoIHRoaXMgb25lIGJlY2F1
c2UgdGhlIGNhbGwgdHJhY2UgDQpsb29rcyB0aGUgc2FtZS4NCg0KVGhhbmtzDQpQZXRlcg0K
