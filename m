Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CA51E0B91
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 09:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729501584; cv=fail; b=bqfiIfxlY0N/FfXXDk6a/KtfNu7Ivoq6nBkNJKd1lm+qFvjar4KMlVk2UPtBPL3pa/t0rGAS9YL/Ewo6x1wYcQgULrDGX9WJwJXWz5gtTWP96wfjZ4vQ9ZXUzdt5jar7PmBkuKtFpireNMrfM5eELr98He/feV6eMjjLYZy1kug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729501584; c=relaxed/simple;
	bh=NJorwUDjNVDxqyigacTD6/hibF8RMeX7VKGT2PQo1hA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qGrS9uuDyRHgsbWzQuuLZ6OlHguWLP/PxkQ+Tdq1+v7EWKyhliHceHkBqX0jKH0Ha5Mgqi63g6xBXEcVdew+UEZu0VoGULB9BiLkHEUqd6M1kA8wHdHM989shlkIiwt0LsKOdMEkasU1JTP/rpjkB0k/fF2pO7Zl+26PuJECxog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aCK6mzEa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=l2XB5rPD; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aCK6mzEa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="l2XB5rPD"
X-UUID: b98b91908f8b11efb88477ffae1fc7a5-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NJorwUDjNVDxqyigacTD6/hibF8RMeX7VKGT2PQo1hA=;
	b=aCK6mzEairOUemu7+rwg6XIFXO2zFHMgxo7UKiQTZxq5LVbJTC7Do9Iqw780tZ6e3rTtrJADdhB2sj2LFfED5BVuE72gYJct/BTdQxu2T2wyzKr4Vh7tJS7GxEr6oaAmzTYIol54QIH5w7jZPHV8x6ZbSxMqb+4n1xO6CvqZnf4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:a03dced7-6621-4e7d-bb90-3351be17c543,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0fcdc3,CLOUDID:72649541-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:4|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b98b91908f8b11efb88477ffae1fc7a5-20241021
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 971889271; Mon, 21 Oct 2024 17:06:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 17:06:13 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 17:06:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ynsCeIGvUqbg2wP69UFHzwsYfbU4x9NnKUz2WLcqUrMF972SvWScrESHeGhFxNxCLJs4HhBMiOdE+GWCGafsr4K9G6rQppBI6qe2pAywnXFzjKy4O7Nu6XS15rvpIzuPLMevQNBsTRmw9GvnCKcXo4rSeQbuV/FptRGgk/nMCP1y8BuoVkMTw8D1nt2SOh3FPEspQ4DM6UvZIIjU5Lxl/2dAo30nytOQ4B2mo0QoqwOZY9Q3Q0HNULXZUw79qfvxgqW3cLlasu2+Std7l7+dRG1II+JW7JYktJ0KwaxNOiZ7xtop29Bu+H8635qrOZHD1b90bT0KplgNN1TuaCSruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJorwUDjNVDxqyigacTD6/hibF8RMeX7VKGT2PQo1hA=;
 b=cukOuT1JACIIcHhW5DPktsjMORb0pSr+ScFis0EWos15yAEzG3Wdqr5Wu2XcgjbYaZ00aGhP17+qs+MODMMmr5waeBeL9bIHi5kC6XBnAYm91W4IsHMFuScgjMDpmDsrrW9PHM7sYUnQIqqfyH5xmpmHzDlkBd8lS5vrOiOLmgDzw1M5cAr7UW/33uK0b3AGpQXFR3ltmsrizmwq9b2cY7aDD6nbPYbd7i5BLg6XobMLFYu658B2q8rFgOhU+usCp2/+8rXSjqeirt9ib0rsNbfQgIVShyVbvYsR9TZBxgO+7qTJj/PgmzkPhEB0A+ezh82ZqyjbELiR/b0UrPjnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJorwUDjNVDxqyigacTD6/hibF8RMeX7VKGT2PQo1hA=;
 b=l2XB5rPDhv0vUxLsktes1eZmqppQ95nPo3O11CyZX0ziHOdEvN8OMtzZuRQh3Qu7anU1MmJSlyXnOUtvnQDFfVa1e6JUk6aOqAntGZb23vkRHYjA+xVoNiHZxILb4p+Uwzg5b6Nzbx4XybHHs4oranbUVDi7afb9OSpZwFOtUwU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7995.apcprd03.prod.outlook.com (2603:1096:400:45b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 09:06:11 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 09:06:11 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "yoshihiro.shimoda.uh@renesas.com"
	<yoshihiro.shimoda.uh@renesas.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Topic: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
Thread-Index: AQHbIZa5Yy0wAk1TO0qr/8D9mz+tM7KQ7cMA
Date: Mon, 21 Oct 2024 09:06:11 +0000
Message-ID: <613c9fca8e491d682bfc2c5e13699e305ff9f91a.camel@mediatek.com>
References: <20241018194753.775074-1-bvanassche@acm.org>
In-Reply-To: <20241018194753.775074-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7995:EE_
x-ms-office365-filtering-correlation-id: 808626f8-ddb5-4426-4ff4-08dcf1af9bbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Vjdka1cvSGRGK3dhd1ZyVjZEbUQ3cEVJSzdmZmJFSHVYT0UvV1JodGFZMlpQ?=
 =?utf-8?B?eG1nQms4Y2NqbXArVVc3M01NekowU2tscTVEaDhscXZZdzRQWnZWVVAzY0RC?=
 =?utf-8?B?cmFvdTFMVGEwV201dHhJVERPMnBPeDYvenVzTW1IV0dVMFZUdTNoZWJiUUh6?=
 =?utf-8?B?dzJ6c2NGNVAveDN2L29CMVVGejN3d3V5Q2J3MjFYTGxkQmViM2Z4ZDdCYlpZ?=
 =?utf-8?B?cHhtdVhFcG1jS21ySU5jRk00ck4vbk1ZOVVObFA0NDRSRDl2eExCT056UlZU?=
 =?utf-8?B?cjZDR0swZFRTZkZqMG1velU1Nkt2TUJheU1qZFNpL0JEQVZSU01JbUdDU3kx?=
 =?utf-8?B?MU84RUZOMmo5N05oMWg0V2kvdjIyVEk3STZkM0VGU0dIaVFYV3hBN3VXcE83?=
 =?utf-8?B?eDN5c1U0YmZNWVM1RnVPV1MxR0dsdVd3aDk3MWUraDNyWDEvcVlERjhBSkJt?=
 =?utf-8?B?S3pGU1FMTG4vVTB0RFg4bHpPUCtQeEZCT0p6M2tWT0JGWDdGc0ZFdWcreTly?=
 =?utf-8?B?cFFsdDRkRGRKOHlqM1pPUlVWU200ajh0cUdzVE56bUdnTDNSemZnOTBRU3lM?=
 =?utf-8?B?OGM3bW5RREQ0UlVjajg3Y1I1aytRY1UxYzNQV2Q4dWV1Vlc3WllWanhxYlRR?=
 =?utf-8?B?MEN2Rmh2QnExUVE2c1pkYkFwSTVHV2lkeXdYQlNEclhGdGZTalJiY3JMYXdk?=
 =?utf-8?B?bmZkeUo5SkpUbFBtR3MwWXh4WWxBcWN4OC8yMEFSc2F4bXJCTk5EUHFFUHNu?=
 =?utf-8?B?blJ4alJ1REFKNjFxZktLTFV6RXZLMEV0MGQ2NUI3N202M3FjbmNzVytLZGJF?=
 =?utf-8?B?blF3STEzTEd2Q3FRN3RldElnOWxiVUg2RjRNUXcySWliTzlaQnpKaWd6Mk9t?=
 =?utf-8?B?UThsVFNybGdEOVB0TDFycG9DWXpqNzhwRUpRYURvZ0xQQjd6MklEV1ZtQTQ1?=
 =?utf-8?B?TzFCUkdYbW9jWENDRXdtaElYZ2cyWHNYS3YzMitiVE9xNktDeUR2cFFGT1ZZ?=
 =?utf-8?B?cjlaK3pwQVR1d3JPSFl1MHlORzEwWmVRYW55T2JueXhBOUpIL00wdUZjblZp?=
 =?utf-8?B?cTZWSytXTkpTYTg3alFIazkrcndOekptUE95THhWYkhjbDVXYWRWSVg4UHp5?=
 =?utf-8?B?WWNKM1JONWFrRkJwOWxqQzF1UU1HeHp2L1N0R0FOSVcrLyswcEtvVEYzd0cw?=
 =?utf-8?B?cXgrY1hmYnRrN0NzVEYrMURiYWEwVTJPTjMxMzNIbmdLUDVZZ2JsV2NycW1E?=
 =?utf-8?B?SVF0bWtKRmgvam9yZThZaEZ5aDRMaGdQKzZYbXcrcE9qbzB6dHI4VmswT0Vx?=
 =?utf-8?B?eFZxNVd1U0FQaFJ0c1NtWFVDNFpBaUwyaVdCNFBaTW5xUXZIeWNGWUNvcTJy?=
 =?utf-8?B?VFZpSXNzYVRPbk9aNTZlbTdOQ1FDNmp4MWFPTVEybHQzWmVhVy95elFkK25h?=
 =?utf-8?B?V1BvSllNU3g3WStvSnVUUUJKbHU2QUUxNVI2TTY3bGJnU2RpdkFQZXZmWTAr?=
 =?utf-8?B?NkhnRW9lL1hpNWx2M1dobU5BdFNrM2xDS3pVd3BtSnAxcDVzZi9STEplNG5u?=
 =?utf-8?B?WnFRdjI0NnRlZmNFeFdIeFBLQXdidm8yeDVYVnFqZHVyNXFNZ2FCNjBCRUNx?=
 =?utf-8?B?V003ZDlMSXBJd2F2MVpReUYrUitCK0xLcmlJbjdYa2Y2aHNyclJtRWVyUGI2?=
 =?utf-8?B?SDBkWW9XeDdzdit3YjhlNGFsUGh3Nk9ONG51YXVya1RrUXhTaWR2NTBFQmdz?=
 =?utf-8?B?K2pTcysrMUsrMzNDZm03R0hsVFdQVzJoWGQ1RjVJYTVkMEFlekU2Q25nZHY1?=
 =?utf-8?Q?m+za9Rzyj0f0IUY1GNSe89S+Poc12rVMi7d1Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OW9KajlLaUgvMGxaV3hRbTZMb08zT1ZsbDhZYXRrU0NjVFBlb1dOc2dESVp0?=
 =?utf-8?B?UjFoNnJreFFoKzNDRm5vaDhzazZxeEtqV1MvNDhvOExabnozU0pSdDJ6a0hU?=
 =?utf-8?B?ejhLaW45SnE3QVJzVGdHelNxUXJiOUxmcDI4ODd5MmxNZytNa2hBbXdOdnBV?=
 =?utf-8?B?WTM0U1dqMXNGVkNzWDBUNDMvc3I1L29pVHk4bnhhYXVHenRKWVdadmNPSU9o?=
 =?utf-8?B?NUNWdmI4QllCOUkxQkkrWTNCMEkwL0VvZzEyUHZXQytsa1JzMFJQYWk1Y0g2?=
 =?utf-8?B?eklBeWNJbnIrLzNOS0puaFgzekZyN2hxbi9tTUJ3dHA4VTlnT1hPU3ZmR20x?=
 =?utf-8?B?WTRNa3BhSEdtbDFTZEwyV3E2bVdqcGt0bEJKR1drK2pkQkwrTlh6MklWL0tH?=
 =?utf-8?B?Y01RUVhhd1NDNTZBUWVQYmdNNkc5TldHeTZxL1VZSEVhczZobHd6ZHN0dUN1?=
 =?utf-8?B?Q1I2bU5BTUhGVTk5aDFqc0lJOEVvZVc5SXFydndiQTdyY2ZKK0tmTm03TVQw?=
 =?utf-8?B?aW9MSEVpajRzeWE1T01zQjRhaEhtcVY1N25pOTRMOUlDaFYzakMwbmtIcWg0?=
 =?utf-8?B?VTUzVzF5djNLWGVaeVpWdFhVS2JPOFBHQm1jS1cxU1RRSDNUektjbnFYempJ?=
 =?utf-8?B?eEhIQXY4c0ZjTFRiMHJpdjhVeUNFMTVtYmxtb3Z2QmxwU3dPT05hZE1EU1dQ?=
 =?utf-8?B?cEZ4dktlUWxIa0xXUTZ4ekJBODlpS1VmbGtiNXZXa3BJNmNCMmFzQjlCOU1U?=
 =?utf-8?B?STlvdmVxSDZQZ042aHBSQVZUNzJzakF4T3Z1eFo0dUp4b3Z3Z0tuSjY1SVM0?=
 =?utf-8?B?eEtlUXRsT3lHQi9PZ1NVcTM3NGJ0NExzbnp5UVg2dFIrL0d0V0V3ZzhsSXUw?=
 =?utf-8?B?bk9YNW5aaHk0djRPWFFUZkVtdmhYcUt6VzRxMmJ1Rm1mK2w1cHUyNXpqcE90?=
 =?utf-8?B?dU40QWtGZ2VJMS9PVFJhNm8xSGNpbEJJUFh6OVFMa2NQNDhaYlZzOU1GbGha?=
 =?utf-8?B?VDRRaUhwM3NqSWFSNEdLajJzTzAxL3U5R3dRQm84RTlYVnF4T3drbmVHcXNx?=
 =?utf-8?B?N2dwekYrNkhOOTFpeXZHVWZkeWd5TThNZENkOUFVdWx3cFoxenJ6bmFSSkxp?=
 =?utf-8?B?cDh2VE9qUVpQQTJCWk1HenYrSk5FS2tQRW9QZUZLdjBCdUVtdVFMUEwyakc5?=
 =?utf-8?B?K1E1WHZXelZhb2pzQXdjbG1xK29xVVFwSGNaT0E0U21VMjJNcU5rWXlYcmxt?=
 =?utf-8?B?bHdvSlg4cXl2OFowV282dFMyOGNYRk5VZkUyZjkrbE5GZGlrYjFnL3d0aGJE?=
 =?utf-8?B?SDFmamF6NDZWVTJ4RnNubjJkMkd3bVN4eWwzWG9FOG9tTkRVdWVHdGNsVzhp?=
 =?utf-8?B?T0xsNWpjTFAvalgwU1B1WDZHa3F3WEpKeXlDZHcrV0VtTVUzanlINTFsTHEz?=
 =?utf-8?B?N3hRazVzNUZxd3RBbHdwSlFpeXJXbmJ1Q2I1NnkxT2x2UHQxdGlOSVd3eUc5?=
 =?utf-8?B?LzVOQWlBNnNLYVZUTzA4dTFDaG9lMmNkM0NsNEtuZDBzQy9jMDJsV3ZOVTh4?=
 =?utf-8?B?Y1U5UTV1THhNdmVvRkFBY29kS2xyUlRUbEMwZHgxbGZwZGYxblJUc2Q1RkJQ?=
 =?utf-8?B?LzA5N1A0bU1yVFNLazF0TXFBZVRHMUh0cy9PZGZ4Q0hjTnlsNWM3OTJBYXFD?=
 =?utf-8?B?RVY1OWdkTXRuTjYzSEZrSnVJUVg1Ym53eXZ1OTBXMHIyR29scnI4dS94NnNZ?=
 =?utf-8?B?dEVGQVNFOUFPSU51b2I3c200ZXl5SWFHK3Q1b2NaVHpOemp2VTZqek1qbC8x?=
 =?utf-8?B?OUptQmZmVzNMdmtQM01KQzNrejExd3FEclUrTmI2RUl0T1FUQUs4dHNCWjRW?=
 =?utf-8?B?Z01tcVhRSGtqVitqbm5uRld3YzdTbHJiTisrbWc1NlhIZTVuUU9uSk9rUGJl?=
 =?utf-8?B?b3RFanVWY0w0TEp2YjlCYld0T2FObnI5U3AveUxXZnkrVmR5N0h0bEZUbnNm?=
 =?utf-8?B?MXQvczcrUlRLVUU4Szd6ZTJyN2pEUkNnTVEzUkxXZ0pVOWxNOEJFZk8yU2xO?=
 =?utf-8?B?VzNCdEZhai9hWVFmVGhUU2RKTm1ldW5LQnc2RkNDQ2RWc2NPLzhTdDNqSFNH?=
 =?utf-8?B?UkJ4cHdUUGdhcWdtNjE4QjZWeVJTN2ZGUDVmazllR2JZU3pwUnJsWDJmUXBp?=
 =?utf-8?B?VlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55CC86AE4AF2394297BA41D207BC579C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808626f8-ddb5-4426-4ff4-08dcf1af9bbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 09:06:11.3580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CFAr9syJWm8Wt5cOBtvUrz88eLNkZXdI2NX4dIyIj7w6I1z6W+qyqaa+pm72mG7vRFbD4lwLjhKUnPCJI7RAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7995
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--12.315900-8.000000
X-TMASE-MatchedRID: h20DFeLkM8/UL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo24bl1FkKDELe4vBuE2X0HlfWAXs8IQX1ucNi
	oSkggDzl55MrUBR+0shvmHdgIY5hMlwV2iaAfSWfSBVVc2BozSpwhktVkBBrQxq9PbUOwsP9QSF
	bL1bvQAcK21zBg2KlfFEAkLaTcFnqkEkKNgqnsWveN4lzmlShS5gsfcaoalBsAGb1lqDqDHQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.315900-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	005C5EEE299E98B817ED0D3F4309194E4B62798131EF79DF7C679D3CA9BA1AD22000:8
X-MTK: N

T24gRnJpLCAyMDI0LTEwLTE4IGF0IDEyOjQ3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgUmVwbGFjZSBVRlNIQ0RfUVVJUktfQlJPS0VOXzY0QklUX0FERFJF
U1Mgd2l0aA0KPiB1ZnNfaGJhX3ZhcmlhbnRfb3BzOjpzZXRfZG1hX21hc2suIFVwZGF0ZSB0aGUg
UmVuZXNhcyBkcml2ZXINCj4gYWNjb3JkaW5nbHkuDQo+IFRoaXMgcGF0Y2ggZW5hYmxlcyBzdXBw
b3J0aW5nIG90aGVyIGNvbmZpZ3VyYXRpb25zIHRoYW4gMzItYml0IG9yIDY0LQ0KPiBiaXQNCj4g
RE1BIGFkZHJlc3NlcywgZS5nLiAzNi1iaXQgRE1BIGFkZHJlc3Nlcy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRy
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgICAgICB8IDQgKystLQ0KPiAgZHJpdmVycy91ZnMvaG9z
dC91ZnMtcmVuZXNhcy5jIHwgOSArKysrKysrKy0NCj4gIGluY2x1ZGUvdWZzL3Vmc2hjZC5oICAg
ICAgICAgICB8IDkgKysrLS0tLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBl
dGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
