Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1FF2B9D8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901356; cv=fail; b=FI03KLoLcC/zeeGByMcNaJbtmE9PdxKHgZdrqDovLe1AWStDWEu/tBnKZKWH/DtR2c4gXsJqtnOcOcvOd+KnsGoJtgi2bHksKiGJoceyVD4zMbEPwXbOaPQ7YwRnGtVVfDElLl0EeZi9PwX7R+ijG1fAziBkr+Ximn7WtqaDHP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901356; c=relaxed/simple;
	bh=AE/m4FIKECb+AckOwrPnkt86vOQbF+o2Rk6HiKLmhlI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FXGqWvUSbgaMMgLi0cpM5emIjiGroSn/6wytax3awW7Gub42Xb+7EQdRwRt7vsLXXvzRYx2nipiFPImomORrKyrEjvi1GyZUw6sNbmjNCeU/0kxE1GVkQghCKOd1ilUN9A0Av4XyhsvqnW8VkaFopTDSw8iMhZWuM4isqSKWgBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IvQAiNcm; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LqE15KbH; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IvQAiNcm";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LqE15KbH"
X-UUID: 6faf7dae383b11ef8b8f29950b90a568-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=AE/m4FIKECb+AckOwrPnkt86vOQbF+o2Rk6HiKLmhlI=;
	b=IvQAiNcmln+94tz6C2w6dCdIoFmKQ51luWSQesngRqfGJlDd8LTnjHKvFVlgDjWJIebS/dUY9CVNYSsxUb5MnVm0tCqt4P+lwYaV8Wez+8UKjR4TUyj7MP633vXIhrfdIwspIBKpDkiB+r7e/FUlbC1VHLqqtGw2H3jHT/2OD1E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:64f0888a-201d-49b3-aa08-f9341533e3d5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:00b9cd44-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6faf7dae383b11ef8b8f29950b90a568-20240702
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 997938646; Tue, 02 Jul 2024 14:22:19 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 Jul 2024 14:22:18 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:22:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/hJAb7ePMKaNv0jDopBnGSYdYdJGNqOSI5JLLQrq9rgr+zO3uNJg1kWqArK2Ki80ugN1D76K2/hFgHO9E0+P6/wdHLd3jgocPVNA4FLEhXeGKPQeEDjmhkRZFiQ4MOT76XurL3q638Uti+Syr3EQ7f391J6b4qwM9w0Hu5ts9MZAWXAkA8fEaFiUf+mfZqwehVgIwmgUWlib8oLsc5aacGb80+c18LyjOrgBYIRyNmk1xu33B7opH607IfJ21QZslTKzLLU0V/5HQdjq0sNdElfD2ZGqNptLDPGC/IWABzynkABLKr+/IZ1t+i+OCqKLExm+M6/a64KIzsmXEM+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AE/m4FIKECb+AckOwrPnkt86vOQbF+o2Rk6HiKLmhlI=;
 b=iA79Ac9E4rqHYVGH0qaCWndCfKTNEIBAViCwUyfZaT/Qa1DK2iquIVzoosr96PAlHgZvDt4IfHNsgtS8XwAPosBRu6S0f9GYkBS4b/X5XibBAghiu971bkicsJEOOF686ETcxS/Xne5t23MFxfRJ3qb+zNdhHnanqWGSlWFazAGzqAP5lOaovnXwV6YOZprgP2Rp47oE9dxPRrEkmh3/SKCcCOoWN0Wx8aQj7+e27bC9RHJp5GXH9y2PXWsDV5ICUFYDkCj0F+DcYw/OuJBDABsv77yXGaVfbBFRXEsTLlalXmLLPLFq1EFxS6ZmGNpduPGSybNGqWRAALpYnAJ9Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AE/m4FIKECb+AckOwrPnkt86vOQbF+o2Rk6HiKLmhlI=;
 b=LqE15KbHznpbnRkjFHQN+GQe7PXaugKcrkVcmFbyLS/zjE1Wsvgz7RZ3To28E/B+OjsQQ6VSHP0blh02dCSRnm53HDdzhECfKuKWns8ip3wArRgQtzZNVvFtNtDMZkqRvT8+QuRTqtn08O5AEslgzbMzetyJqHf8NAkPSGFBA2Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7314.apcprd03.prod.outlook.com (2603:1096:101:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Tue, 2 Jul
 2024 06:22:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:22:14 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 1/7] scsi: ufs: Declare functions once
Thread-Topic: [PATCH v3 1/7] scsi: ufs: Declare functions once
Thread-Index: AQHazEgQMtp26R1wS0yamlAmKaKQbrHi98qA
Date: Tue, 2 Jul 2024 06:22:13 +0000
Message-ID: <99667a9a9d180ada77f3070ba9dbe8bb617a1746.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-2-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7314:EE_
x-ms-office365-filtering-correlation-id: 71dc8d43-266b-43e6-048c-08dc9a5f5062
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b3g2dE14VmJiVkRCTVlsMDU5V2t3cld5U21GbnlqUlZXOEcybG5wbjBoRGI1?=
 =?utf-8?B?bXcrc2J0amNqaDc1eGZ4bG92dU1CT29qWU5TWFhHYmVZN2t0ZXhtYytsTzlu?=
 =?utf-8?B?VHNFcXJQbm9UdlVtT0JFUEdaSUtiUWhrZWE0Q0lURFBTcmR0VHY3cFZIWC9Y?=
 =?utf-8?B?RElYd1pLOG11YlhsZDVBMmV5VlNBQjRUMGhrdW95SkxPUXFRR2N3Z2pOTmht?=
 =?utf-8?B?R3dYcW1FWXYvVkdZZm8rUTNMUWxtUGxyNXJQdWNObkFhYU9ZMm8wYUloaVh3?=
 =?utf-8?B?TTJLTXdhTklmZWozNmtSazhWcS9LTThEUjZRNXNVZzB6djV3M1lxSHFHUzdO?=
 =?utf-8?B?aWdpZkI2aE9RQ3NTNlQrT0g4bjhjdVhMQ1lHTHY5d3ZzSE9tbUF6Zks0a1p3?=
 =?utf-8?B?RVhrZEpTOFV5c2FvajM3ak1rcklDL2JTWEV6dlVsYmt5blArYit6bjN6M1VH?=
 =?utf-8?B?MThtcVZENGZ4Uy9GOGIxakk5UkxhVllxOHpobUNDajZod1NYa04vbzlkUStv?=
 =?utf-8?B?eU5sdjhUdEYxZnNmL2ZCRFhDSWZ1VjU5d25XMzUwRTNGL3BYL3I5dlRuakVu?=
 =?utf-8?B?S3ZiMTlHbEphTlZWM3FIeEFSQ3lEUm9UdGxxSEJGYUdJc2N4WS9zNVloTnJN?=
 =?utf-8?B?QjE5Znp3RnpIMmVVeXh2M29GYU1XWjdHSm5tcDNycHBhanhRbU93cDcwZ2g3?=
 =?utf-8?B?c3VIQ3dJZHpHdGkwbjBKMFNsSFRMbTNmTVNyTk1VWHpBSENzV1BwODAxZGRO?=
 =?utf-8?B?d3RFaGdkbFJGdDdGc1pGTzdEa2lqa2IxemxlZllDZnJtMHBqMXM3UlJzV0hJ?=
 =?utf-8?B?eDd5S3kxU1o1OVdWWkFzZVExdnJoc05JZ3N4TzhSTnI3aG5Td1Jsci8xdlY4?=
 =?utf-8?B?R0dlUnhPcHJJVithZlZlZFhzV3Fqb0x3TVMvcWxwNDJzckQxbjgrbGJHRVNQ?=
 =?utf-8?B?QXlWdExDR3E0amRXZkQydi9tcmdwYW5hcmU3eDdGMzJ5NlZSSXYwV3FPZWRO?=
 =?utf-8?B?ZC9sQ0Q4WWl4SFZuV2NreDFVYXROK050ekNjaUIySDhHdmU5S2hlVzNReXpz?=
 =?utf-8?B?N2lOUXVqSjZSTkY0U3RCSW9waUJYa09CYStNajU3Wks5elBFZjBSY1hxZnRP?=
 =?utf-8?B?MTFlWkMwQjE3akJkdXNFdEx5WDY1TUczU3Z0SzB0dDlzYmNNVVdWQTMyYTl0?=
 =?utf-8?B?RlBLQUhlbnBWUmVUNjBCOEdtZFFyNnZwZkdqZGRvTUZWTURUTEhaQlJJNHRS?=
 =?utf-8?B?YmIyYmRQNSs0SU5MUE1TY2FCQlZDY0NOQ1dCUjdDZEwvUmRyejVJeVFUWnNK?=
 =?utf-8?B?SlhDOHRzTXQySGFEUGdWM21TWjVHMWVKdnZuQUdCQmVJaE1LcnczVjVRRkhw?=
 =?utf-8?B?WDVhUDRWUXlTRmZJeHg3SWQyTG4yc2lTbG9lalBGeFNUSWZmSWMyd1pIbVdv?=
 =?utf-8?B?OEJZZHBlSjQyZWFTRW56SHZyZ05XQVJsalJpa3p4dDBwRFhBUUcxQ3V1VGNw?=
 =?utf-8?B?b3NpaGJMY0VFZkkxb203Q1NENjRhOGxybGNpbjJCYUJnOTVzWGJNNlh6Y2RU?=
 =?utf-8?B?NGRMRkQ0UTA5amFUQjFjQ1VlVVp0Q0d5YVJRdGdzS2Y0MXJYblNpSFhzeFU3?=
 =?utf-8?B?dmh6Vnl1TFdOazJrWGoxSUQzeHVVQkdPd0Z3bldzaHpYVUxubzMwTDdHd29v?=
 =?utf-8?B?emlFZHJyaVZpVzBEYlJkaHdBVEZQT083cXRtdzlRMTVoOFRvYjZmdDVRbUhU?=
 =?utf-8?B?ZVh4cU9VNGdsRlBjdndyVjVMMHhpU2VjU0NnYTFNYUZDTUNkVHpoTUM5U1M0?=
 =?utf-8?B?Y1ZhbFlPcXl5eUV0Ty9BWWZOQmdWMllwV21PamM1TndJRVRUekFaekN5U1Y5?=
 =?utf-8?B?dW1vM01PeVRJdDhLZWQxVXlvSUxyRXFjbDlyR3hMY0JFTmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm9wVHZpZFc2MmxycHlqUDBaQ2YzVWZhTFVKZmlGWERGMkV3b0VKN0VBSVFt?=
 =?utf-8?B?QVAzdHV0WHFTWlV1N3ptcWJSNk5tZytxV2E3MHJWTDBOWUNkQ2ZHbWM0QWs1?=
 =?utf-8?B?NC9PSEw2bXd6RlpWNzdaK3I0REtaK2hzNXhPWFVoMmloQWdYdXN2NzgyZ3hm?=
 =?utf-8?B?Y3NqNVRuazQ4MlgxSElSVUNaVGlyRmlWS3B6dkZTZUJJZldERlgyeCtxV2Qy?=
 =?utf-8?B?S01ENlRObFBLSlJERncxWWJHVWN0L0REbldMTHNjbXVsQllPd09vNTJjWWNx?=
 =?utf-8?B?Z0RxRVhtbmdIR1BwcWxmaUJIcE1JQnZjYXBJS3Rla0tBSVlnbE9qZmpiay93?=
 =?utf-8?B?NnlNVTVFWk5qV1N0NVl4UllyakQyeUdYelZzWVlYSlVsOU15UFVxc0RUVG1x?=
 =?utf-8?B?QUxmdnh2cnJmSER0NUlBWlpXb1d3OUI1ejUwSG43YVRRd2lmRFQ0Yi9rU0pM?=
 =?utf-8?B?NmJuS0JSbGJTaUJRQXRQQk1LSlo4K1NtUWRVeTA1QThreFJLeENQOWV0SVlU?=
 =?utf-8?B?MlV1RUhMRjAwUHFoOGJhK3V1THV3dFl0clVWOUFxcXFyZjljU2FyTmdWK3VL?=
 =?utf-8?B?R3VtY1VjWjd3UUlWVnhzSVllOTdTaTN2YXUvUTdOUUZRQVpQSFkrOXJ4WlNT?=
 =?utf-8?B?aHoyekdoSzhvZjZwdVFhR1NiQVZlMlBuTGg4aWFTTXI5Y0ZCb1lYdForeWtt?=
 =?utf-8?B?V04vQ1lkQ201YkRwTWhuVS9idGpkdnlBR2QyQUJ0YzVUcStzVGw1VEJOeDZO?=
 =?utf-8?B?ZmE5WnpmMGhlTjlEUFRIS1V4aXpkNXN2cXZhbWNUWDRXSnBYbmRxell3bysr?=
 =?utf-8?B?bXljM1VqU1YzQXJtTSsza1ZvS21tMW1pblkvTzEwR2ZNR0lNcGFIY0ljbE80?=
 =?utf-8?B?TzBrR29xeERTRGsySTRQQThtWDF1RWdGdUZFelBDWm1qTE5GVjlNS1JJbHA0?=
 =?utf-8?B?TzRhWlQxL2dIMmVBRkpiTGJyUUJsbFEzTFVTdHZpeVIzVk05ZW40N3hWV0tv?=
 =?utf-8?B?dzlMMU1jRXdNR1daTHhoczlTZnpRcmNhUi9YWitCemtMVWN4bDB0dDZJRndF?=
 =?utf-8?B?U2gyd0RSUWJHb2dlNysvbktQdlpxaC9sbElIcm5RSUlLSUc4UWNyaDNJV0JV?=
 =?utf-8?B?UXdHdWNyNkpvZ2sybGFsM2cxbzVtazZ2Q1ZuZDA5SGtJbHRaTFB1dzh3bFUr?=
 =?utf-8?B?Z1BQYy92UGFNN0wzcytpVVRZZUMxSU0xYWR6R3FQTE85b051YWRkekNGcTFW?=
 =?utf-8?B?QURkU0JEZU9OYlB2VVVkU2NZUVM0VklUUWh5YWFUZllpcjhRRWg0blFLWUN1?=
 =?utf-8?B?QUkrNTZqZGovOXFSekw2WXgrcDM5ekZUemRKbVpUSjhWSi85Qk9URytWcTkx?=
 =?utf-8?B?SjhHN3ZQeEZyc3JHaXlRT3lROTZ3ZlZSQk5CcEE2T1ovMjlBdXlJMkdpOTBG?=
 =?utf-8?B?cmxRNlV4clB0TGNtSk1iR1FDR2txWHRQajVyTGlHWTNCR2tkeXdxd28weWND?=
 =?utf-8?B?aFNiYWRPVTFUOG1wajc5OXBlVkdEeUhGdVZMNWZzd0FxSnRvYm5VUHBOdUcr?=
 =?utf-8?B?TVEyblNrMHVGZW5YTE04anVMZG9rUjZQb0RPaDRkanVPZy9NSnBFUHFNR1RR?=
 =?utf-8?B?VUQ2ZkluUU8rdURjcGthb1RCWTJtWjQrNnFzc2s4cDVIeElDanNLUGNuMHRv?=
 =?utf-8?B?emZXZVFkWTN1eFJjMjZUUlAxTUJSaE9uQ1laVUJ6TmJ2QTlGYlBSalBRak15?=
 =?utf-8?B?cWJGOXRsanB6SDN2Z24rLzkreDlDQ3RobDZoKy9RcnAyUUt0VTZlZWpGeGhP?=
 =?utf-8?B?dmZGQ3Z0OEl6YnBBaUtTNzBYbjlYSjkwd2F6MHMwaXdLM3B0dm9EWEJHenk5?=
 =?utf-8?B?WlZCL0RpeHBoYTQ3ZjJEa21pVTlPSTRGQkw0VG1lLyt5aGxxOVdNajhjOHV3?=
 =?utf-8?B?UDJwZzJobXI4MnFzSlFCQWFNQlZIZGMzUlRNNVdoUHFhQXVWWkI1NW9pM0xR?=
 =?utf-8?B?SDVsQzN0NWNMcjNDUEpkSlFocjA4NWoxQlBtREs5T2tWTlJMSkpnMDB2cytj?=
 =?utf-8?B?YUp0bkUyZUhqQXUvVWQxbTlKc2duNmhJSC9iZTMzWHYzaU9MLzlvUlJ0LzNw?=
 =?utf-8?B?U0hDRjdNblNOV05WNXdabzdIUTBNa2xHZHU1MEZySDhpdnFQVHlsTHd2Mmd2?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3CDA80C0E8313439BCBF098638FBF6C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71dc8d43-266b-43e6-048c-08dc9a5f5062
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:22:14.0335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6rCXXfObbv6/ym3I4kOYoiwDmPWZGCA6RHBpB0Y7XabnZGzSI3p6fJVOkA3v8dMb3jy3SexXHLSxqwqch40Xew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7314
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFNldmVyYWwgZnVuY3Rpb25zIGFyZSBkZWNsYXJlZCBpbiBpbmNsdWRlL3Vmcy91ZnNoY2Qu
aCBhbmQgYWxzbyBpbg0KPiBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC1wcml2LmguIFJlbW92ZSB0
aGUgZHVwbGljYXRlIGRlY2xhcmF0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFu
IEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBSZXZpZXdlZC1ieTogS2Vvc2VvbmcgUGFy
ayA8a2Vvc3VuZy5wYXJrQHNhbXN1bmcuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdh
bmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
