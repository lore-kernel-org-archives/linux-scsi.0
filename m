Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB2813D539
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 05:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747201267; cv=fail; b=fwBD5fcCwHuPJ8RsQn0vrn0e68fSp4LXGEk+tek+jEVZqmysffssRcoUtYKmFV1lxNV7bMQbRqrA/OBnngFu2MMSclRKWpCKLi3Imxo23Oqpf9CJ053dAHZurpE+qC5eEV/WCKZ5/5ZDaoWP1XOgfLKGk5Th5Y41DUahBPKjFUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747201267; c=relaxed/simple;
	bh=l3OnMtxWykdpvV7aoCcMInxAA9exnbQFtSM39exTiUU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=drdEJb5OftRtUtI9pJDhG27ucIGvodrekEt/wC3EVG80brB2O/207zsXuoaijqNVDXnZOQ0/ekwUx9fDUvesuFZps0PCTW81TSqjJaWK9Qdd1yaSn8odRQ/0mP8kbgddv65snQf5uCyYo01ahQ1TCYrK7ZDy2j1vA+L1kZ0oYCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rCYCHrBx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dI77FEQc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rCYCHrBx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dI77FEQc"
X-UUID: 0170770a308611f082f7f7ac98dee637-20250514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=l3OnMtxWykdpvV7aoCcMInxAA9exnbQFtSM39exTiUU=;
	b=rCYCHrBxldxG3cf6MM5D0HdWab8s5lfP2wvujZwcw4RkLDk8LILhiq/NsacVNOte/5di9ozq46nQvMgeT6GC7VWGry93TIf4lN+fK10Tocm/3F46lVtNJRvb2tWQfl1aNeVc5m89DbdNJaD14cvwXC+UrxI5V6ZtLdOfBWapJp8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:03e31c17-4d3c-4a64-b06b-67239b19eb88,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:1eb1b497-7410-4084-8094-24619d975b02,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 0170770a308611f082f7f7ac98dee637-20250514
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1430264378; Wed, 14 May 2025 13:40:55 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 14 May 2025 13:40:53 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 14 May 2025 13:40:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZsChZheq3ap8YKD0N4ebC8KX1gJ3xrTRcteywz3JRfcUtSB1btgzsf2edwrjAVTzCWssDfiCV8EXfIy7G2eQaMZb6Wlivpx6tcEN2+sqoM0CTdyj+PayfzEIwoDtDSj4vtprBJbVVFlZpb7d7xa6eO7/DMgmshjbPFEbjmmplJHdA3fgsz8XIFWVS2ZZCLoKNngwsGngXpqHzFwjRFkjbreNgdeEAlL6EHwT6xVwrvlsQzY0Kf57ik/rKwJ0SEJ1XEj1Z8LnheFHwbronTMepSGPN5QSrqreSprcHuNbuHOwBjcaW/CT6EhU+cclkOflAtaWwhzwlt3Hu77Rz4J1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3OnMtxWykdpvV7aoCcMInxAA9exnbQFtSM39exTiUU=;
 b=ICOBOQXvDNxTPTVkTqhzPcOC4BHlzQd485sIp4p5qYGUpW03xy+rbqhgvWeGDjZbMA09ti2aUJaqK8uP+qqWEP2p17Vd2taf+40xgJg9PShQ/ynE9ZKh8p0i221c6Zw1wFqkM/VK4cisSQDJMTWu2CrJM4/xy6xQiTOREOwRjQZjUZTEJjDb8RDkpKPNZzeLygU7L+kehEtQEfifYUHK9roai2C4l1kywQYg53t9iKoqIFYphl0plub2+jq+ucr440+0ow29W5ySp4fCn6hm3KQhGr6iDRxplzPxAkdlsORsjhx9Zb71obb/9CyY+qUGj/FQnGWpy9FBMUI0eEnIlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3OnMtxWykdpvV7aoCcMInxAA9exnbQFtSM39exTiUU=;
 b=dI77FEQcgqXfPOEEXB5+7N4JDgItuiqKArbaSlB37VCs3ufu/SPyaqNYaUlS9KSXmbEZG/Bo5C5MH/iDMInHWR0eSkRC9g6uXQH5rVGLh6he3zJQ60HYVNkhNrV/SmOqLPGvr3c/sf3bFJhDLS/YIwA/Xk9AwaQYq671W31JxsM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7054.apcprd03.prod.outlook.com (2603:1096:820:dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 05:40:51 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 05:40:51 +0000
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
Subject: Re: [PATCH v2] ufs: core: support updating device command timeout
Thread-Topic: [PATCH v2] ufs: core: support updating device command timeout
Thread-Index: AQHbwYIRU7sqDaJLTUWVsvUYojtu77PQlpsAgAEL4AA=
Date: Wed, 14 May 2025 05:40:51 +0000
Message-ID: <8ad2ef53658bd669fc2094b6ba0dea9f896ef740.camel@mediatek.com>
References: <20250510080345.595798-1-peter.wang@mediatek.com>
	 <4420fcd0-5125-43b1-89ff-c3e5edad2939@acm.org>
In-Reply-To: <4420fcd0-5125-43b1-89ff-c3e5edad2939@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7054:EE_
x-ms-office365-filtering-correlation-id: 69089c19-4c4d-4457-db59-08dd92a9e33f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aVM4TW5XYXBiNUNPVlRJczVqQWxzT1ZSVzZMWUNMSVVGK1M4Wk5mdklGSW1n?=
 =?utf-8?B?WDUrSkJmbEFGSHhQdFVPSzkvTDdyRW5vOGVRQmtZQXM4QkhQblRxdnZDWUFV?=
 =?utf-8?B?OGc0TFh0b053eTlrZkpOTmthSXJzRUhXbTRKc1lJMTdFSUR1Zzc5NTRDdzZM?=
 =?utf-8?B?emVUTUpoTmVkRkdHMktWaC9YR2dHN01HeEtmTStaeVVxQkdJSmFpT0xtRVJ2?=
 =?utf-8?B?ODF6Y3E1Y29GYXFkYjBzeUtXUXkrMEp4dW82UnAveUd6dEhyMmRVUVRiMFk1?=
 =?utf-8?B?R3ZldnJlSUsrMnQ0RlBQUVIwK01hZ3FtcU5iNThiTDJtc0t5UmkvZGlyTW5o?=
 =?utf-8?B?bXgySmpxU3dDc0hIZmRoU0hUcDh0OU83R0hMSmZQNlpIWU8za3daNEFKeVdy?=
 =?utf-8?B?RWV2cm1OVS9BN1VoZXJ4bm1OV1k3T0ZpTlFWSEVSVFZXeE11UUxaemJaZEF3?=
 =?utf-8?B?VXYwVXNuVXEyNkpTR1FaTFdKSXh5ZnhqS3JucWRHTHUwZm9KSERzdHRCc2ZZ?=
 =?utf-8?B?UnVkcmkzOHJ6T0xMMG1PTGZWTHVOQys2SUlvNGswSzduZTBoeVVyZVYwTlNx?=
 =?utf-8?B?aEcwVmRUaU8raFlqcWRVZTVpblR2Z1QzNHdIV0ZaYTZhTk1TVkFKVXlzTGlL?=
 =?utf-8?B?YUluVS9PYkpML25tT3dKRWtiTncrMmpuTytSMWRLdXZMSmo2RmxQRXllWVlS?=
 =?utf-8?B?TkwyQllhdkYwb3U0NnV0NGhtc1JDWU45WDExWFFJeEtCbGtoQlB4cDljeG9a?=
 =?utf-8?B?TTNDZS9ibEFZc0lnUExYSCtBbUpndUZaYTdRYlNpUDhpZVZBMnh5bWVIVkY3?=
 =?utf-8?B?UHVBdWY4dGtDQU9JR0tCbDNRUzg4M3Rta2gzUEtHeFppcEtIczBkNHYxRjlB?=
 =?utf-8?B?SENXYmRyUWlKTWgxWE9ySE93eVR6MUtjQlFHUVBQTUU4WmNwdExhQVUzekJw?=
 =?utf-8?B?L25MV0pVNnlUYTJnMnpPay9WRFNlK2tCM20wSklObFgzYjd2Y1pMRGsxZUU4?=
 =?utf-8?B?dEJSb2hQSWRpRlEwSDJpb2FScXRTZUJZVVBueGt2QTNTTG9BVytNNWtCK3la?=
 =?utf-8?B?bzNuYmxaZVRGUzJ6aUgwanFteS9VV1VOQXdkZ2REMG15MDlXdE5UeFlnVUdD?=
 =?utf-8?B?dTRzRlFsRWVpQi9yUTVwRDFCVmdwVmdTVmhETUxaU0NXcmVLcHd1VnNTeGdk?=
 =?utf-8?B?c2ZiNGhDa2hJYk1aOGZ0Vmk5S1E0eTR3OXFzc0JEdVhwWW5rdmZBOXlsVXhR?=
 =?utf-8?B?Tlh6R3NuaFpXVDF1eFVyOVRXRm5hMGhTRUhHVkl5djVKd00yaVhNcjM4UTBP?=
 =?utf-8?B?d1hRdWhsdkQ4V2pPY2hWbHZ2NVNyVUo5cmhwWllQK3AwTktzSkEzV1ZrckFk?=
 =?utf-8?B?dXF4ZElzeHV2czV6MGlPRDZuTVJzQlY3b3NDUE1CUXdIbEdyT2NoSUp3NUlJ?=
 =?utf-8?B?c1dGN3cwMHBueGgrZEJ2eXVCWGJKUVNDMSt0czl0ZUF1RHFkLyt0WUVvOXQx?=
 =?utf-8?B?d3QyZGJjS0dweDhVZDdsUGRCVzVSTUh3YVpPY3VScEIydUJCeWZtd3RYanRY?=
 =?utf-8?B?VkN3TUtpaTd2UWFJRFFxSFpOZ0tiVDhwaFpZaGRPQlpwbklNYUFDQzZQb0FG?=
 =?utf-8?B?bTE4Z0x6eUJDbDl0UkQ1Ym5vVHhNY2IybEVGT2twSU5KSTF5ZStEWEJ3NVZP?=
 =?utf-8?B?Qzk3LzJjcTY3Z291WlZ1bU9hQUxLdHRqTm9YSGdlTnp3YzdKR0hSSXVPUHFY?=
 =?utf-8?B?c1FTODhJeng2dnc4NWVqWk5iemJEK1NhRk5zaU1HWXpKRTBVZUNxRFYyVnNs?=
 =?utf-8?B?WUl1M2ZuaG53S0ZIMmpKaW94UldMditXeHlob05rR2dtWTV2TEVMdWJleCtS?=
 =?utf-8?B?L1lWbjRyc2FUQWlZUGhoUGxGOHBGOUdXS2F0KzdEdVk4NHFSc0d2RHEyQnNC?=
 =?utf-8?B?VGRTZTNyNFN2bVpobHl4WkRtSkZjYU5UaStVblllVXErUldZa1hRRmdrcDMw?=
 =?utf-8?Q?1lD+KCogxp4Sta9YPX6kUIAfkvqThA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU1uUEM5S2prd0JhdkxrR29KZkpkS3F5U0UzZkVuazRmOXFqKzNRUGN4aWZw?=
 =?utf-8?B?VWFpaUxiYjArN1VpcEVWQ0pIVC9XaE9jVjMyeThidmpYNlI2OEU1NkxGbjhu?=
 =?utf-8?B?b1drOTg0cWxzQnlUTFg3dVFmbisycmdQR016UzBwU0NHaGxobVVWL0h5STc0?=
 =?utf-8?B?OCsrbzFYeU9heXJyL1hPaHNER2xHamNrdDh6UDM2SzlXb0RtdDgxNEZRc2g2?=
 =?utf-8?B?V1kvWWNpbmpGMHZPaHlyRWJ4Tk51dTRtZ1NvamNnbU1MeER0emVwUDExK21u?=
 =?utf-8?B?aHhsQUU3am14U29XSUlGVDR1SU9oTW1KcUd3SnVIeXRZVExmZ2pPTEdUMWtp?=
 =?utf-8?B?d3dqdGxla2JCVTEzMlozcis1NDlUQVl3bUg1ZmVpRU1MVk0zQnpDc0NpTEtZ?=
 =?utf-8?B?VFdNNVVRbERtdGxLZGxqY0lsendDN3ZySVJZQzMxTG02TG56UTdidzJHclg4?=
 =?utf-8?B?MjJRQlgzOFFSOFFYT3dQT1RHSjNvUEJNV3o3OTF5RTF3QXJJYTIxcWRTWng1?=
 =?utf-8?B?NTlLWmZWWHkwbjFCQ2tWSDZHaHB4d25YamdGd3BkaGZzSlVMYUNzdGxpZFBp?=
 =?utf-8?B?SGgzWHpReVdxaG1RTGlWR3Z5bDJjdzJ5UnNTN3Q5OERCQ08rc056QTJjVVN0?=
 =?utf-8?B?QU1CNGErbHhvb25lN1V6MVpxdC9uYU5pWEhpcnR2YU90UzZyQ05wVzk5ckdp?=
 =?utf-8?B?L0pGWjlNc24ra3ZUa0FPR3dwd2xuT0VTekxwWkpaQi80dXRxWEJYSkNTMDM5?=
 =?utf-8?B?OTl0dHJnbmFqTlJVZHl5eEFwUmx2Y1ZyQkVGNnlpWUc3K1ZKSU41em1EOWp3?=
 =?utf-8?B?dzI1TytuSFE3NWN5MXo5bDRUVUlHUkh3SG9iR2hJYjA2UVcvTTRqQy9uTFZj?=
 =?utf-8?B?M0RNZVViazFQT3kyS3lZeEFYcFNjQ1BiU280TnRSUDBSd2swUVZCNndnOVNZ?=
 =?utf-8?B?dUgwMTVadTc2bEdaNjRyRlZieXh1S0hpNnhzWUN1bUVlTzRrSEh0Z2gxNFBR?=
 =?utf-8?B?cnpSS0Fyb29HUzZZT1hybnJsNkFhQkxpTElPRHYzb3dMVEdKd1htSjVydmlY?=
 =?utf-8?B?d0hSWFlDcFpwcVJCeEtobjF4STNZMXZ6KzB3S2czQUZQWm84Y3ZmUjkwbVV4?=
 =?utf-8?B?eldQWEVtN0FFT3lsemV5WlJLYm1oMWNFN3hrMTNMNktUSlZQczd0KzBNS3RP?=
 =?utf-8?B?bllrZ1JGUHpJbTEwWUgvZ3pjSVI4aCtUZHZqTndLN0dtOWFsWHRacDdxNWhr?=
 =?utf-8?B?Vnd2OVZQelduNzdyOFVDVEZuc0FzTVdHR0xYWlNZZ1NmYlplTXpaM2lIU2M5?=
 =?utf-8?B?RUpSeEwzeVZuVUd1MXVYbUI4czhpdU12anhSb3grOFIvQmk5K2hjL0Y1cUR6?=
 =?utf-8?B?UnZwZ3lncDB5UHBCT0t6NFVPbHZER0tVRXBSVWM4RHVsdGtUUjBoakkwZkF3?=
 =?utf-8?B?TUMyejl3aGZjTTcvblFmdUh6M0gwTGtRYmU1WjdoWVhzamRyTWpuN29jSG8y?=
 =?utf-8?B?TlJOVVNLSW84V09tVUdPTTZPaFNsd2VrT3JrWFdWeGpRNTREYlNJMUVLbGpF?=
 =?utf-8?B?Sk1GbTlyS0FFTDFkUzB4MGQ3YTBTWjJTZ1ZuYUl1REZYbjNjQXdEQ2VsNWU2?=
 =?utf-8?B?L1llUE5iUUQ5NzVvMVpUTjdiaFQ4a3BDQjFka2tKOTRleFNhZHp5dldIa2Ns?=
 =?utf-8?B?YjhmL3g1TmpkUWRaMVczNGRQalFqbWZnNm54Wkt6bU8xdE1rTDFDUVVUZnJh?=
 =?utf-8?B?Y1FnMUlwUXZXWjNPQU9ZK1p1dHpPdkxOZmtqMTdXYmpLRG5uY3ZlcGU2U1o2?=
 =?utf-8?B?VllTQUlhaWhKY2ZXZkhIWi9vUVZCSVhLL0t6OVRTaUUwUzhMdXFCanhGL1Bq?=
 =?utf-8?B?L1BrTG81U0JiU0ZwWFJkUVFoNWQ3NkZqeXBYdVZmb2tOSHAyYWY3dFhYNmla?=
 =?utf-8?B?ak1saUFibnJQTGhWUllBZDBBUWJwc3BwZG8yLzloUHhESDFDNzQ3WVQycE1N?=
 =?utf-8?B?WGxDM0hITjFJQnRXOC8wM3gwM2N5ZzZlak1yV3FBTGJhb1M0T2lER0p6dkJO?=
 =?utf-8?B?Qm95cGxMejNicTdzNitSWTIrNVNvdHNlSnZOV0huamo4V3EvR0dFa3o4bkVw?=
 =?utf-8?B?NWNNQ1dyakx3UlFZRHArRGJZT2wzakVOSGxjVjQwc0J3NGlCVVo5akZFV1lX?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D14806A1F23C8540919F059CD5665003@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69089c19-4c4d-4457-db59-08dd92a9e33f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 05:40:51.5689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uqACqkIe+x9bhhcl0nzz2Su1m/ldRfy0eLRJN/pw278E8NCUa0HcydqrtQTym6Ijs2VXxieUmZSIl+1MUYlEag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7054

T24gVHVlLCAyMDI1LTA1LTEzIGF0IDA2OjQyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDUvMTAvMjUgMTowMSBBTSwgcGV0ZXIud2FuZ0BtZWRp
YXRlay5jb23CoHdyb3RlOg0KPiA+IFYyOg0KPiA+IC0gQ2hhbmdlIG1pbmltdW4gdmFsdWUgdG8g
MW1zDQo+IA0KPiBGb3IgZnV0dXJlIHBhdGNoIHN1Ym1pc3Npb25zLCBwbGVhc2UgaW5jbHVkZSB0
aGUgY2hhbmdlbG9nIGJlbG93IHRoZQ0KPiB0cmlwbGUgZGFzaCAoLS0tKSBzdWNoIHRoYXQgaXQg
ZG9lc24ndCBhcHBlYXIgaW4gdGhlIGtlcm5lbA0KPiBjaGFuZ2Vsb2cuDQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQNCg0KWWVzLCBJIGFsc28gZm91bmQgdGhlIGNvbW1p
dCBtZXNzYWdlIHNlY3Rpb24gYSBiaXQgcmVkdW5kYW50LiANCkkgd2lsbCByZW1lbWJlciB0byBw
dXQgaXQgYWZ0ZXIgdGhlIC0tLSBuZXh0IHRpbWUuIA0KVGhhbmtzIGZvciB0aGUgcmVtaW5kZXIu
DQoNClBldGVyDQoNCg0K
