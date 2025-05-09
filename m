Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49523235059
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808024; cv=fail; b=TUHxYwwfAniwdffj+3TSuuGuQYUR1xaxKZzWA5cxh/X9da+1BC65mk3X+TRgMgCjy2RGDg6U7eZEtw2kqGU4ZbIy+edX2npZ85Ttoh20B3KzQE47VCMsh8aErp+GrLxY4J8b7Z5EAmOtfcdd9o+xOJtcpyXE+40vbmFum6nvGmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808024; c=relaxed/simple;
	bh=MEChCiopruYTK4z3nsJzZjOcvSyoGokyUhYF+s/2vIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aypVRr81oHXBzy2MaRk1ceSMnFprhsaVVx004O9hLsjOX7WVXY2M1rjNqpfNPUuiWowMg5HYvQOTt+eLIzHbFMyil2kIvIcquJlP5TE1+8WPLyud6TV2VvdYMXrSdv522TOoj0veyMwLUPNaIxhcmveJk748vDTSgg4N9YRf9fQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sI3lmIWS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NqB3YgVL; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sI3lmIWS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NqB3YgVL"
X-UUID: 52cfab8c2cf011f082f7f7ac98dee637-20250510
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MEChCiopruYTK4z3nsJzZjOcvSyoGokyUhYF+s/2vIY=;
	b=sI3lmIWS6+4y0t36674mb4lxjVaedmVNg080VS3oxZhIM440hTyk9KzDipYrgTN/OIK+V77i6nO32aN7Nuk0OG8jxNOMFty2qlRAYT9wriqRDMt6UDxnsje2BWhHIMNqzXXYp7qxsxcP6x5+sRhW5/Em6XMbxMFZtIQpQTw49ck=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:2f66df68-c138-4e79-b227-c1c4bbcc9b8a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:f7e5d8f9-d2be-4f65-b354-0f04e3343627,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 52cfab8c2cf011f082f7f7ac98dee637-20250510
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1734664828; Sat, 10 May 2025 00:11:54 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Sat, 10 May 2025 00:11:50 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Sat, 10 May 2025 00:11:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjmB+yacl2CdlOW3GeULq6hGYRwaYeAXHZ5MU0kwJ9s5JxX3UFk4NlOpXoNERLMP9LfDWmpUvZjVJqMAD7t1TNMdUw0DaX59pbiwuOIfpTag5N/ewDrRyhbmzFBOmI2c6/rwzFY/HXZfFx+pPZ13CWEEEUE26YfrWKMes8vuY/5Qj207WPblFCJqlUXXIsG6wF6C7UNHhp3CYEbwegJeobb4VYA8JgVNIsmIW04F8PwA29Mq8zIT4T9wzf1JhjYyY9R1bIxlT3DSc3x+c13pe/xzLM/6myeBWGkFo1+sXDNiE4vtc0+jNTbFjmP4IjBbD6xuRUNrsDJ5TG9KNAVdWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEChCiopruYTK4z3nsJzZjOcvSyoGokyUhYF+s/2vIY=;
 b=IYs+6MazGFTeRpr/HTvQd48DKMaVlwm7QYd5HCAqqD2I7m8BkENwD1s6dDruCODyPlSiTt946aCALCz7m8RoyXFQrWRWMlZS8ldEl0csT5Jo4kJcdDfykn24LBog06BKXE6jyjyB2rkwlxcd0GAPnp3J6Cn4WOmfeOmoVvAGmE8b/LM65E2SoV1agEphxgpdpIjyWzjtTHW9T5hxZSkSxl4ZGBUYYlHJ6BccCIreBPo479J1bkfe4WR1xzG3VJ0LMgwgcPVvyyIAfMFQvKb7UtIrOYonFPMvu2yKyQs8H9Eo9fZ3tBUBldQ7FZOQLWveA1g2RQt5iV5YUH1y13Uk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEChCiopruYTK4z3nsJzZjOcvSyoGokyUhYF+s/2vIY=;
 b=NqB3YgVLBiz/6qVSd24VA/BDdAzqREyc19DjLlvh7Px+pmmDbePHLP24R4YeOsDmp4eUpPu0gt9vUwLzjz0yMeIPWKeVoRqvPyTaeAjopY5DvYjhmP6PtPrFGw8dC814IJXMJUTLy9+PPC4G7L7YMRysnft0HgTt8zaNkWZQJL4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE3PR03MB9356.apcprd03.prod.outlook.com (2603:1096:101:2ea::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Fri, 9 May
 2025 16:11:50 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8722.021; Fri, 9 May 2025
 16:11:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
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
Subject: Re: [PATCH v1] ufs: core: support updating device command timeout
Thread-Topic: [PATCH v1] ufs: core: support updating device command timeout
Thread-Index: AQHbwLF1DYss94wTFkWYHqsKw233xbPKZuWAgAAR24A=
Date: Fri, 9 May 2025 16:11:49 +0000
Message-ID: <8b56be3dee19dd210ceaac46a30f29f34b31a83c.camel@mediatek.com>
References: <20250509071029.446697-1-peter.wang@mediatek.com>
	 <946d62cd-b1a1-4ddb-8411-2060362f7d33@acm.org>
In-Reply-To: <946d62cd-b1a1-4ddb-8411-2060362f7d33@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE3PR03MB9356:EE_
x-ms-office365-filtering-correlation-id: 15c1ab25-71e0-4b62-1cb1-08dd8f143466
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z3l4bFJVdTUrOFlZcER4Ym0xbVhWTmVtaGN6N0F2eHozVzQ4ZGYvMjkxc0Nt?=
 =?utf-8?B?WTJzRUhncjJsUCs4clNQano1TGNEZll0N1RiRXFZUG9wSGZCWFk0QXBEM2h3?=
 =?utf-8?B?VHN3eEd4WTNQbWtOZm1vV05LS29BU1ZOcy9GK2ZZU3JQbll2cE9HTFBqR3JX?=
 =?utf-8?B?T1dLTThUUzBGSEwxYlFlb05JNDBFeWtYQ1BmbGd3MkxueEpBcnhVVUs5Y0dK?=
 =?utf-8?B?OTRDakJjclA2ejlnTEhXcHV4NS9TVW85RmwyRHlnLzNkTzJnRkRuMjcwOHdH?=
 =?utf-8?B?L05haHo5eW8yZjRxRWtxRDBFOHVFbkhEZFN6OHVzaVB4a0ZpYlZuVE9WRkZU?=
 =?utf-8?B?enp6ekEwRVRkaWc5SUcra0pIOVZJWk91eE1lci8rd1Z5TkhRVE41ZWVBeVNC?=
 =?utf-8?B?bXV3N1VYa1JXQ3k3elpiTkppVjRYQ0doMjY0YkNkQmVpOS8wZi9rQVhUVTdU?=
 =?utf-8?B?dCtkNk1vdkc0eUgvdzdKWFVHK3ptTmZBTzRNbWhTS1N2MU5NQk9sRTNWOENT?=
 =?utf-8?B?UWpNL2YzRnVqWCtCUmNldk1ZV29NSWpzeFp2N242a2JPSjNyYnFsTXNEbnQr?=
 =?utf-8?B?QXU4QmZXM3hPRUx2QS9MUWRTSXpidTFUaVJ6WldMMnN2bTA5a1hvZC9VZ0ZZ?=
 =?utf-8?B?MWpsQ21Uc1ZsK2hnVU9PWGsrYkJOSXZTVG1KS0JXWGxZWUM3aGFBMm1pRDVS?=
 =?utf-8?B?NEVYczRqQlJCZDcvdUJUOFJhcHh4K3I0dUNFRlpOZ0NIaTRkVnFYWlVNRG5l?=
 =?utf-8?B?ODBSRFV3V21YWXVxZXVKd1V2bTl2MDdheTRzenJOZDR4YXhOdGd3MGtBNUtT?=
 =?utf-8?B?Z1pQaTAvNzhzaU94MmxGL2hYc2VjQ1RhV2ZVQUdZV0xmeUlJaFljV2J1WGR2?=
 =?utf-8?B?UlhYV3kzQm1xa2ZIOWJFNEhyNnlaWk13TnhrU2RwQVVzc2w0ZFZ4LzF6RjlJ?=
 =?utf-8?B?Uys0TjlLajhDckdreldXaWFRaktrSXhSaWJyVzBnSGM2QXFvRzJPUGdscVlj?=
 =?utf-8?B?bDFKeHhxNjgvSXZPcURWSVRsS1lwdEFlMHNxVlBsRE9mclNBQUVsUUdDaWFq?=
 =?utf-8?B?ZWpRYU5YZzY0V211dkd5MzFybGdEWVJRYUgvVFR3VWo1VWVheitLQmE0OGY3?=
 =?utf-8?B?blpRV2FvS3JaaEdxS0NreXJDSmxPbkl0MEc0aU81L3F1dnMrUC9sZk02alVU?=
 =?utf-8?B?OTZlamxiaWJSOHVhOGJaYnp2MXRlMm9wejZvVlF1K3VhTEdaaDVtaVJMOXVJ?=
 =?utf-8?B?aFVtWjRiYnozSDE5U1dUYzJKZnM1ZTg0b2xLWDExRG1GOGtIYVczeUlMaXhh?=
 =?utf-8?B?QzdJVnJPd1V0Z3YrMnhUQTZXRnZwc3lneE92WmNBTVpmU1pvb2tYejRmanJF?=
 =?utf-8?B?UnZINHAvd3V0MHF1TGJCcFdwQ2MzdlZzT2NobnFwSTZJQmVoSXhOeUVKWHVa?=
 =?utf-8?B?ckRkVEZrUTRobytobEhBUFk3cmU4OHcxd01DZ3l2TmRjNmZUdmlFTjVJY3BR?=
 =?utf-8?B?cUtEL3RYK2FmWE9oRTFGUzl1ZDU1aXVHOTBQS2NkMWRaa1A0K2NuOXNxQncx?=
 =?utf-8?B?WDZtMTBwdkRXYjIraGYxMjI1dDdHbWdJUDA4eEdQanZpcmExSkxsM0NPMm0z?=
 =?utf-8?B?b0NGUGJFVnByamJ4RmRqS2V4NGxVZnRSOVpQbUxHL3hxNFBJRDdUZjVyN0do?=
 =?utf-8?B?eU94YlhhaUc4VHRNdldUQlJQNCtxclNicmp0L1ZYcW1vMCtaZS9FRHBKR0JS?=
 =?utf-8?B?SEQwM2NPVTNMQU56QmhvVkRYeHErZEozd3VBRUJJeEpBVHJRbkgvYytBYU9S?=
 =?utf-8?B?ZG42Uk1KYnZBVDNCV1I4dzhybk1KbENYSWszVFpjYjAwYlFrQVFzNS9IUVhE?=
 =?utf-8?B?YjNGbHdCQWpJUUtudXF6M014S2N1dWtSTjZMMXVsVEtOdGZTMlRSMlJ5T1Fu?=
 =?utf-8?B?Wm1iM2V0bFljTStmNzZEdFpxUzRIbTdIbHB2V1VOb0RiaEJyZG94THpuTFZk?=
 =?utf-8?B?R2lPS3c4YXRnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWdTcERJc2VxQjBSRk5ISmluckRWc2ZkQVlOVk8xbjJPekFJbnkrVzF3Kys0?=
 =?utf-8?B?TnpubGIyUWFYMWszYmtTMEFNbGdaTVRRRUhJVGQwbk91ZStqckpUWjJOMGN4?=
 =?utf-8?B?ZmVIRllKaXRKMjYvUGthaVRSa2xNS2xIM1RBM3RwYUpEaGlhY2FHbCtpNE1G?=
 =?utf-8?B?ZXR2ZjdBYlcweVhaL1hpUkZKS3VCNDJwcUNCQ1JkTlpwRUE3and1c256aWwy?=
 =?utf-8?B?Q2FWOFEvOU02Q3RFZ3lhS1FTVktCK2Qxd1loL1NmR2NDLzFvaVZtdmx3N3VB?=
 =?utf-8?B?d1E4SnR6WUs5YkJ0MVFRbW9yYWtrQklaRkhjSkgxTkxEVjN2ejhDNDd5dDJE?=
 =?utf-8?B?czFrNE81T090NnNqSGxOQWhxWkdxOTFRam1FQW1YNjB6OFVEbjlkODZEZ3V0?=
 =?utf-8?B?MEN6VzJiKzFjOWJFL2ZmeTh4Qm9Zc0pIazJWSldEZUpIaUVEOFB3a2UxWW9i?=
 =?utf-8?B?M2pheVRtUDRVSURBMXlEMjNidTZLUXRrNE5seGIyU0hiVm41Y3VxdWRJWmQ3?=
 =?utf-8?B?NU4rWHA3VEx2SjF2NEVadVdTUWlJTms1NHVnMm5NbTZFTmwyalVQSnUwb0NR?=
 =?utf-8?B?WjFmV0VqS0kwQ2pqeE9GaXNYaWpkWU8wcDZrUDlLTzF2MTFvdTgvUU15Mk5q?=
 =?utf-8?B?T05MUUZiQ3RYall5L2tpV2dJYy83UUlsbElVbUJVVEw2WElCV2pmOC9XV3pV?=
 =?utf-8?B?UHJ0ZjFFWndZa3gwMVkxVjBrTVEwaGxpeHRhSzZxZTVrNlBFUVVhcVpEaWc5?=
 =?utf-8?B?L1hZbkk2dHVPMVNxaWx3TnNxUW1BdDJWdkZCUDBnYm13WmVxRENaTUtwS0xV?=
 =?utf-8?B?T0hUWDJqVzMwTXJYb3dLTmEyNUpKU3gya2hxZ29ueHoxdzVVWEMyNXlPU1Nq?=
 =?utf-8?B?Y3hjeTUrY2ljdkp5M09TdGplSmRSMi9tNm55QXA1YWlWQjdiZy9DWkUvNzBT?=
 =?utf-8?B?dit1WnVwdmdxbThUbkdvRGQ5aWJSczA2VS9qSmM5dTJzUHBNRko3S2huSTZ6?=
 =?utf-8?B?elI4MkVKUEtSbHVzS0RoQSs4eHJ3OGRxVHVVRUdOdjR5QUYvYTFlV1FmQ2dy?=
 =?utf-8?B?TlF4ZnRSeHpuajkrZHhGcVp1S0l3UDVTVTJZZGhJdTVBYm1KU2g0TFJJekdz?=
 =?utf-8?B?R1U3V3JCdU5ndVdXak9tczg0WThqcmc2V3JVZGU4RW1ZSFpqQW52dFYzUXVX?=
 =?utf-8?B?eTNiMmRsTEtzN3lqL3NYV3VkMWpTMHBTOHZrWGl3SVBKQVJrVXQxSHFtejh2?=
 =?utf-8?B?ankzYXJLQ2syK1BXbHcxK0hzZFZZZlUwWmFMTkNCcmY2ZytleVhHbUE0L0Uy?=
 =?utf-8?B?bUZidkhFbkxSZzNJRlZFYzdvVzRRN0lIR0VBNTN1aWtNQks5Y0MyNUxwa2Rp?=
 =?utf-8?B?eDFQZzNEMExXWHNrODBDeCtjcGNqME1hQkk2WjN4U1pQc0tSZlZaQ3oxc2lG?=
 =?utf-8?B?ZDRtWEp0d3pSaSsrUVB3UER4U0FCbFlNaCthQkNiekxLSHBhSGhNbDhjSmR4?=
 =?utf-8?B?Z3VRbmdwR29sbldUNkFKWm9jWGpzMktvdVc3OTdGNWcrc1d1MFArMWhTdTBi?=
 =?utf-8?B?T2MwN01TRkFEZ0g1Q1JWMUdWSFZkWWh3SkZGN1M1V05FZERFcHdxWndtTFlu?=
 =?utf-8?B?dFFkZDVYakdJcG1WbEhOd1JiV1RpTkhxdG9Ib1R4dllLdFFhV3ZjRlpNNUJh?=
 =?utf-8?B?SU92STZyQmRmSVVFbmxwRGFpN1EzYVh1dytQOHR3aFI1Nzg1c2d6SXFsQzB6?=
 =?utf-8?B?MENXa0R4UXNpRytEcElkQmdzQ3E3aVllQ2VMU2NUc0JxaWZ1YVc3OWZoZE8w?=
 =?utf-8?B?dlkzK2NHVElvMlc2UGN5V0FaNUVBd096ZVhvQXY4WmY5TnN6bkJYa3Q3Vk1o?=
 =?utf-8?B?UzczdGNoZ1R0b21UMmFxS1JHbHFZZHlVb0k5bEwvMnBCc3VsUnZZa2VXWmt4?=
 =?utf-8?B?SkdBb29la3B5RHBhelJRN0dmOWNCTHdPdVNOU0wxL09ZWVdXdVR5VEhuTHNV?=
 =?utf-8?B?SU1jSTlzcXA1aE9MMUU3bjI2TWFtUTcxVm1vUWxCQWVRNkluRTNEQjBCNzBT?=
 =?utf-8?B?a2hZcitwWW54QmZZNkVOQU9LZDFZaHplYS9Jdm9FUVN6WkpmbWJVUEFWTW1G?=
 =?utf-8?B?aGNPa1ZEcGFRVzNnaCt5VHdBbmY2YytoZGZyaHp2cWxXNys0Ly85K2JSNzRL?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <653780F2BD956047A008D70CF1D948B6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c1ab25-71e0-4b62-1cb1-08dd8f143466
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 16:11:49.7572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63BYrgNe5/LYgvGN2vIzDtpjYjZ7cXVnxBSxmLvg5TEbzZIEqoXdG+FxZ2ZwKv8eQjYeFv/SdYWpLCwwS63vmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB9356

T24gRnJpLCAyMDI1LTA1LTA5IGF0IDA4OjA3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IERvZXMgdGhpcyBoYXBwZW4gd2l0aCBhbGwgVUZTIGRldmljZXMgb3Igb25seSB3aXRoIHNv
bWUgVUZTIGRldmljZXM/DQo+IElzDQo+IHRoaXMgYmVoYXZpb3IgcGVyaGFwcyBhIGZpcm13YXJl
IGJ1Zz8gUHJvY2Vzc2luZyBvZiBkZXZpY2UgY29tbWFuZHMNCj4gc2hvdWxkbid0IGJlIHBvc3Rw
b25lZCB1bnRpbCBTQ1NJIGNvbW1hbmQgcHJvY2Vzc2luZyBoYXMgZmluaXNoZWQuDQoNCkhpIEJh
cnQsDQoNCldlIGlucXVpcmVkIHdpdGggdGhyZWUgVUZTIGRldmljZSB2ZW5kb3JzLiBTYW1zdW5n
IGFuZCBTS0h5bml4DQp3aWxsIG5lZWQgMzAgc2Vjb25kcywgd2hpbGUgTWljcm9uIGRvZXMgbm90
IGhhdmUgYSBzcGVjaWZpYyBudW1iZXIuDQoNCg0KPiBUaGlzIGNoYW5nZSBtYWtlcyBpdCBpbXBv
c3NpYmxlIHRvIHJlZHVjZSB0aGUgZGV2aWNlIGNvbW1hbmQgdGltZW91dA0KPiBiZWxvdyAxLjUg
c2Vjb25kcy4gSSB0aGluayB0aGF0IHNldHRpbmcgbG93ZXIgdmFsdWVzIGNhbiBiZSB1c2VmdWwN
Cj4gZm9yDQo+IGVycm9yIGluamVjdGlvbiBwdXJwb3Nlcy4NCj4gDQo+IFRoYW5rcywNCj4gDQo+
IEJhcnQuDQoNCkRvIHlvdSBoYXZlIGEgcmVjb21tZW5kZWQgbnVtYmVyPyBXb3VsZCBtaW4gdmFs
dWUgMSBtcyBiZSBhY2NlcHRhYmxlPw0KDQpUaGFua3MuDQpQZXRlcg0K
