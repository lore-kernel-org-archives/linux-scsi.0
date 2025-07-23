Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282D3BBF0
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263092; cv=fail; b=JJ9UejJw7ZiipCdbb8GwJb7XFXYiM5upPkkLFUzIhrqFu/JCF2691iZ1wbRGWmNjyZVkgvRubmwIRTSao2zEe395WHaiWIFAkgx9qmd7T0i5yC5kt9QftFOksyGljx86n4ZGHQ1SID5N7uf7nbyVSCutC6Q5ET5aHp+eBveenAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263092; c=relaxed/simple;
	bh=rIcxfYEuqtW2zRytz1Z3RuXvbJ7AsB+nf4RWSR4boUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QLng4DHMuUAD5YtG2hi7uUcNFCGzKOlKren/JwiuWFlMOaCzLrXJbTQ8+P/jJjcmRy8U9+MuDxv9x6xGTvPzAlPjQtowV4lH0F40gMeX8uskd+lBRUZfH34kWMHWYpYkpnfTjF3P1Q0uLrxi/uXt/pXIJFwLek6pIhJnJ4jLQd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hC0QksZ3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=INNGIA4m; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hC0QksZ3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="INNGIA4m"
X-UUID: c81d31a667a711f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rIcxfYEuqtW2zRytz1Z3RuXvbJ7AsB+nf4RWSR4boUQ=;
	b=hC0QksZ36AC2adeToZOdO4Wrxj+e/n1xijbeFrVIJ5PpFTJiWERcsX3RFNiLYJ7WJJfmxKfktKCCctVa7xqviFk9e5qW4DeCJ5NcMNWlnTTq7l8QsxXurQgqU75L0FDh+XIv1NwsWqOUdhjUsq9f/tyP5y9inhEYTGnLqreGmIw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:509a83a6-f9d1-4ac2-915f-017a042a06b3,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:33ddb208-aadc-4681-92d7-012627504691,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c81d31a667a711f08b7dc59d57013e23-20250723
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 964319747; Wed, 23 Jul 2025 17:31:16 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:31:14 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:31:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kuGhSSbPH9/zJDCZkctepVs+7EdgBmQe7VgIkt9zOaMAOIfqj8lE62HKiHIIQTV1a30MYGTWJKHyx6ut3nYe04ylRZ56LGefq55YGqSx4h+osBS7SV9YcOet+6AwA2JQ17/MVW3hTpKpNdgOmM7bZkRfu5999zOuZ3R8PGe29h0FUt9HcNgFIiYOh7sI22xQLhPZuJs/20SSizj5hAx9oFTJ2SGCgDTmefGUbedLpDyEz+OCNnM0HBeioLFzG4aF9714k99Srs0o0nxuGWR0As9V7lijbc0xsRUSQNe8AIiT9FUhT9z2VCLDH4H9e+/XhJZMLBPXPO8QNtJ9GP8zeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIcxfYEuqtW2zRytz1Z3RuXvbJ7AsB+nf4RWSR4boUQ=;
 b=t3d4qxYKgI79Wtbwpul1GGpS6mLLk3PpshlYgdFJGzQAc7AVXvcTAxIoy6Ychko+YuHjIvea5KnYb9VDhXtOrwz20xIKu0SPZIuk55kNDTJfa2AF+IFAE5pkDXi+a/yIxjfsEs/GUgQrgxIrM4tzhSnLD8L7Vqa0xTyux0PxAnA/WdWrrM6/hS1FyG5Nku7dmzmUYZBV9f3YjYyJ/PILWgKdINI55LFTTYeamAg0VDRSZNeJzQKvhEfFasivkW4q53sB4vMyWmH+lZZiKECc+0B6YrC4iJm2wKw1EOHQl5N4tftX2ynhQ6/69HxZQp+DPFjT3sz8ujAj/qt625Txuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIcxfYEuqtW2zRytz1Z3RuXvbJ7AsB+nf4RWSR4boUQ=;
 b=INNGIA4mnqo2f2rBDR1Ho+7YzLiIwgx1dv19sFw+WKiXmBjol0tWgEODG1qQASSnvNkF8uZtzeuZmwrcOpGjzmrpQvhKbzXn/RCcg86uyjE9DKIdylpsGle20z2WrsOjrJL1O/ttVLWWXU/0CwqqXV9ootF6i9UyetGBtyv9OLo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7562.apcprd03.prod.outlook.com (2603:1096:101:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 09:31:13 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:31:12 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "huobean@gmail.com" <huobean@gmail.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "andre.draszik@linaro.org"
	<andre.draszik@linaro.org>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] ufs: core: Fix IRQ lock inversion
Thread-Topic: [PATCH v2] ufs: core: Fix IRQ lock inversion
Thread-Index: AQHb+om0sAcuxUwFzECYg9tHXZCQB7Q9vf6AgACJUgCAASyrAA==
Date: Wed, 23 Jul 2025 09:31:12 +0000
Message-ID: <b0a806687ebad27c20424fa5bfae8c4755b86c09.camel@mediatek.com>
References: <20250721215055.2885241-1-bvanassche@acm.org>
	 <0c1022496d2eb5cbe0d86ae3c249e28adf6a9c94.camel@mediatek.com>
	 <6d603276-1114-4dc8-b622-13716f3ea8c7@acm.org>
In-Reply-To: <6d603276-1114-4dc8-b622-13716f3ea8c7@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7562:EE_
x-ms-office365-filtering-correlation-id: 02c49469-8fe4-47a2-d5ca-08ddc9cbaa49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c2dsNVBvRUd1N1o5QldBNFEyUTFGeVFYckp4MkZxVnRNdFhCT3BSUERJc0Jq?=
 =?utf-8?B?R09UdnoxNWo4THVQdVNnVDh0UWRSQWZkYTJMSUp2NmVOdktKdEczQmJnbjUr?=
 =?utf-8?B?dGxGa05lSzZFN1ZiTmF1SC9uZVlyeStsSW9vNXBjOFpMZGpJbHBhWDFMWkpE?=
 =?utf-8?B?UXRXTkx2UzY1SzE4Nlg3MnFiMVplbzVZYXgyQS80MlI2bmpmTGZwanVHSlVJ?=
 =?utf-8?B?Ymdic0EzZ2VENm1xRk1FSHExd1RWY1F0M3NmajY4ZDNQR3U4T1JoZmE4eExz?=
 =?utf-8?B?Nk1mTVVRd25RQzZEdXFSbGorTjg1TmhIdk9qdHdiQ1p1V3JBZ3lDSm14OVd4?=
 =?utf-8?B?M0w1Q1VWV3hTRVNoeU9NNjQvbi9va3VKWnpLWVBQM0gzUi84anhIOVVYNWlm?=
 =?utf-8?B?NWJPMGRrck9jUHhQN04wbW5sWmRaZzBBb3c5T3ZOdnlOSjNMN0lDMnJTWEVw?=
 =?utf-8?B?T0QyczFIWnVrY1V1S0pMb09ZTVhjTytTbjNzMTJDOUlxcWhLWWZEZEM2S3JF?=
 =?utf-8?B?WUl5VCsyS1JaVTBtZE5qa3hqNkxyQi9vdndqUnRvQWZPczdXWHVZelFCcEh5?=
 =?utf-8?B?ZSszb0RiMnFJYzNrbkU2c2hleXk2a1N0cHk0NllyQXFNc1E2a1JlSEVUYUxJ?=
 =?utf-8?B?TTluSjY2R2tpVm95K2xQeTRHQ0t6a3dtZFNQTTJ0WXc1S0cva0V5ZEZHblpx?=
 =?utf-8?B?MGZjNzFDbnB2MTFMdk5JekY5c0tpZVd1cjdjbzdOUndpeWtJWUl5MEJJZHJM?=
 =?utf-8?B?WW1MQUJXem14dkxaV1dZL1VWQzNTc2ZKdFc1RlV5U211UlRlVk9JN3QzQis5?=
 =?utf-8?B?MEVDeC9UdFRPNy8vdzkycUo4YXhaQUIvLzhCTU4zRG9kK0lKaVRpVjJTNnl0?=
 =?utf-8?B?cUVWNFZoOWtxbjAxS2ZmcVhxKzFKM0FZcVM3OC9HYTl3V2ZlcTBYMExzUUc3?=
 =?utf-8?B?Szg1ZnV1R0NBcTRXb2p1aWY0eHZPWGFocmNDd2V5a0YxTXo1ZU1rMDhGT01z?=
 =?utf-8?B?dXdTZEpFQnFXeXl6aHk4bmtmYzdLY3R0RDM1MDdqYWxMdTg3UUN1UXY3K0lp?=
 =?utf-8?B?NlNUSk1iUjFrWnYwTWtOaE9yY0tpelRHS2UrZ0R5c0huSnF2Uzh1cytVVUNo?=
 =?utf-8?B?aHZnWGNXYXBsSEowak1RMmxXWmlNT0g0ZGNldE5BZktFZG9vWm93R1N3aTZ6?=
 =?utf-8?B?UHJoMVBhdVBPMndDSlJVZFJ0dGxYTU9pTm5NbllEUE9SV1BvZkREUm5oUTgw?=
 =?utf-8?B?RjQzbm5lV3JwMVB1SkMzTHBXWEdybjRJeElzUFgyVlQrRWh1RGhMRUpZeUMv?=
 =?utf-8?B?RVBRQUJJOHliM0pSbXpSZmYwazYwL1NoekQrakIxRnhxSG00S3dTRUh3SjRV?=
 =?utf-8?B?blJ2UHBJWnFRaktWWVNYMFcyUDVaOXl0UkE3eGJpT3NmMlZ4NSt4eU4xUEt3?=
 =?utf-8?B?azh6eitoTnN4VlVGcWhRemRGNGQrWUZUVDBoMTlCaUU5L0FBSVpCWmlmU0JY?=
 =?utf-8?B?QXFnVFZENGV6MStBZkJPRndnVnc0a04yTCtwcVFpMVlNNWJBUXVXa3BnMkth?=
 =?utf-8?B?Y2oyRjNMRDhmcmU3TDJtK2V0akR1VjIvRkhIRE5GZ2pvMnFjclRVdC9EY2ZD?=
 =?utf-8?B?VU92b2xETzZBTGpwbW9vS2hOODF3RlA2REFpbnFtWjJYNGJsQmZDUHJoOGpz?=
 =?utf-8?B?Rk5tY3FoNmJLUk41TDVNMzRoZ21pSFQxY1R5NzBNSjlneDlnd0d1dmZTMktD?=
 =?utf-8?B?RWhURVd3a294UG1DM2N3WG1mU3k4RzRYWm80dUk2SUh5dEs5MHRYRVNFekli?=
 =?utf-8?B?ZXJzRzZvWExHT1g3MktXTVE5bk9ka0lteTVpVWNlMEFURWFScEtnWlJMeTkr?=
 =?utf-8?B?L1ArbUh5eXNhbDI1czdvUENzR0VXOXRQcEh4ZFZpMm9jWmcwNEFoSGRLNTUr?=
 =?utf-8?B?d2hMU0NodTVxck1JTW5LcnNPcldHN1ZwVElnczhPczFLMXJIZUhUWUZTQnlR?=
 =?utf-8?B?ZVVja3N5WHJRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjhlQ2N0dnlvdGNOUkZhcE5MRG0vYXdhYTJzYnN5WEdEWUxTTzE4R1llQ1Rq?=
 =?utf-8?B?ODg1ZXZJNlJSNStDc2U0cUlMSXBlZGRZeHVZK2FkdXl3WHd2aUJ5R29nNmNT?=
 =?utf-8?B?eVhpQU0zejdPa1JVazN0KzFDOUxXblNlMHA5VE83YnMwL2dLanZ6dnFVMEtu?=
 =?utf-8?B?TldaLy9kVTVrQnJFaTBuTmFXQmZwbUtZSUxOdm9UanNEdzAvdlk1R2VvK25S?=
 =?utf-8?B?ejZsRVo5eUwwN1lPWTNYeTQ4bmY1OWlEOWU0V0xydXIxbFRtNmVqL3RDRlpH?=
 =?utf-8?B?Rkp4aWZuNVUvS2JNeWl6Yi9PMi9Ya245ZFJyMStPK1BibXNJY3dPR1Z6S0Ni?=
 =?utf-8?B?NlRBTXVrTVF4TzdTMG4vdGhzWm16TG4zMGF6ZE5IK01kR0RwUHBmdnNoWCta?=
 =?utf-8?B?Y3dPL01TZThtWmRYeGhxNzVwdGZSRGdIY1dsTW81cGdLSW9WUTNUZnNnNWhs?=
 =?utf-8?B?MXZQbTZJVnZMYkNGdHBVYmN3MDBndm0rNVBKK2NlY3NxMzNqbXdRcldKUnBQ?=
 =?utf-8?B?S3BLR2I2NXJleWJmS3FPQW5vRnp3ODJ3S1RJSUFKRGlqTk5MMHpvSjVKNUJU?=
 =?utf-8?B?N25DVG5HOUxrbll5b2VuRjM3SzZkWFRFMVg2TmRKdFMzTVZrb3NFQlprd0NQ?=
 =?utf-8?B?dUd4SDl0M011T3BwaFhnOThsQ3U3OE1OK0RVamxxL2RmcHRUZExTMVgwZE14?=
 =?utf-8?B?SnFyMVVmaThTaGlxNWdkSDZJbHlxQlZnVDZYaE9qQ0R2MXdpU0ppUHh1eW1C?=
 =?utf-8?B?MTUxejZlbUV0TFlnSUZJTXUwcEFVODNjMXB3Ui8wd3M2cmlWcmlHbkxyNS8v?=
 =?utf-8?B?T2ExS0pVMlN5cVhMd3hZWkUxZFNpSG8xWms4dllMelVsSGJjUDZKcWliTnFk?=
 =?utf-8?B?bS9BWndMR0tBZFZSUVFYKzRLZFgrK24zZ042Q3h0OUZQazBKNXhhREhQQUNW?=
 =?utf-8?B?VXVVYitqUC9tdFBsN2M5UzgxUFFsQzZDczZsdkN2R25ZMnFhMEF0SVp6Z1pB?=
 =?utf-8?B?UkkxcHF3Z29SaGdENnFOVklYeDVnRy92ajl0UUJjUG1LdTJmZ0Y4TVpwc1J4?=
 =?utf-8?B?bFh6WG9VVmpBcmE4OVBrTWpORjVIdzRtenVhaVJscU13SDNoclpFd01GNTR6?=
 =?utf-8?B?dEh0eFZHOEd3WGFBWW1YUjFQOHhXeEVNWVZHMU53Q0dEK0dyS0JQd0NFcUhC?=
 =?utf-8?B?N3JkY0xoQnJvVkhja1Ara21MN215ZWJoQ2MydXRhZHZhMHRkb21yakMxaldw?=
 =?utf-8?B?ZmVqZ0hxd05FMzB6L1BVRFdPdThoeXVXVmVYNE9HSG5QNERZc1dGcHNiVitR?=
 =?utf-8?B?bCs4ME5pU0hwWjBBSHN2Z1Q0bGRVZGRKWTBUVEFpZjZ6MGpneVRXUkNzblps?=
 =?utf-8?B?ajJTd3ZQZ1lkM1FTT2tISzlxVHRFUUhIU1V2eFBBMnV5cEMzc2p4MG96VE90?=
 =?utf-8?B?VmZTSzlJLy9wYlc4ZC9ESDdyQk1RTE9TMEVCcE15Z3NyV0tIWHdiMFlkaTlB?=
 =?utf-8?B?UWg5MTNVWjFaTUxiOUNWTlU1VjdXV0lxU1BnMnJLeUhvQytORnRPOEFjYXVL?=
 =?utf-8?B?UW85OE8xS3JPVjJoaFFad253UnlITWNUK014NE4xR0J4K1VTRUE0UGtFUEE4?=
 =?utf-8?B?UERVQ0xISTdYcG1oK2M3Um5DQ21VWEE2bDc3ZDZ2bURhUjBHYkNsOWFKU1li?=
 =?utf-8?B?NElNdzlHaTZtSGxUWmozeG9GMUEydlMzS0RZd2hySU9EWk83ZzdqOVdnT0sr?=
 =?utf-8?B?OUplNldDeFRTQTRENUE0RWV3Zjh1bDcwUy8ySXFQcW5tbEF4NHZQMFJPbUg0?=
 =?utf-8?B?N29TM3IwN0w1bVcyaXZ5VjZCSFd3MTVBQnRlNjVYQjlTY3FxUzZWak1UMjVN?=
 =?utf-8?B?ZjZ3dm50K0VxN09PYXdhTG01SFVWbUpTbmcyU2ZZVHNwRTVnY1RISkFCUDk1?=
 =?utf-8?B?aG40ZVA1UmxqN3NRd3FyUXBtZitQZEpBRE9UVzJ6OWIzY2VNV3FGREJORGZH?=
 =?utf-8?B?RDVpUW0xT05odENZVzR5cTl3anNoWlJSRDJnWlV6U0dMdWUybkZxRzgrdnhy?=
 =?utf-8?B?aHdHcHRCYnEzVFhaZmxZYWRrUEgyNWRaSTY1em9wd0grRVBjWmxCRHdLL0FY?=
 =?utf-8?B?NVRDd2ttMGtyVytLdTJWUU9nR2dHQnFFejdpbWQ4U0NuZ05xRHgxNkc0WVNT?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A313FB24C76AB4E957E697EF286E6DC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c49469-8fe4-47a2-d5ca-08ddc9cbaa49
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:31:12.8958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdS9JjX5zBPa/5q34NmDfqB0mvmwqlJgiy+4/wt5HWJuLFg9EojEho2pg2ohBa2kNSrtwn7UyGuujNU3ziW6Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7562

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDA4OjM1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ID4gPiANCj4gPiA+IDQgbG9ja3MgaGVsZCBieSBrd29ya2VyL3UyODowLzEyOg0KPiA+ID4g
wqAjMDogZmZmZmZmODgwMGFjNjE1OCAoKHdxX2NvbXBsZXRpb24pYXN5bmMpeysuKy59LXswOjB9
LCBhdDoNCj4gPiA+IHByb2Nlc3Nfb25lX3dvcmsrMHgxYmMvMHg2NWMNCj4gPiA+IMKgIzE6IGZm
ZmZmZmMwODVjOTNkNzAgKCh3b3JrX2NvbXBsZXRpb24pKCZlbnRyeS0+d29yaykpeysuKy59LQ0K
PiA+ID4gezA6MH0sDQo+ID4gPiBhdDogcHJvY2Vzc19vbmVfd29yaysweDFlNC8weDY1Yw0KPiA+
ID4gwqAjMjogZmZmZmZmODgxZTI5YzBlMCAoJnNob3N0LT5zY2FuX211dGV4KXsrLisufS17Mzoz
fSwgYXQ6DQo+ID4gPiBfX3Njc2lfYWRkX2RldmljZSsweDc0LzB4MTIwDQo+ID4gPiDCoCMzOiBm
ZmZmZmY4ODE5NjBlYTAwICgmaHdxLT5jcV9sb2NrKXstLi4ufS17MjoyfSwgYXQ6DQo+ID4gPiB1
ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2srMHgyOC8weDEwNA0KPiA+IA0KPiA+IFRoaXMga3dvcmtl
ciBpcyBhY3F1aXJpbmcgY3FfbG9jaywgbm90IGhvc3RfbG9jaz8NCj4gDQo+IE5vLiAibG9jayhz
aG9zdC0+aG9zdF9sb2NrKSIgbWVhbnMgdGhhdCBpdCBpcyBhY3F1aXJpbmcgdGhlIFNDU0kgaG9z
dA0KPiBsb2NrLg0KPiANCg0KSGkgQmFydCwNCg0KSSBrbm93IHRoYXQgbG9jayhzaG9zdC0+aG9z
dF9sb2NrKSBtZWFucyB0aGUgU0NTSSBob3N0IGxvY2suDQpCdXQgYW1vbmcgdGhlIDQgbG9ja3Mg
aGVsZCBieSBrd29ya2VyL3UyODowLzEyLA0KdGhlcmUgaXMgbm8gaG9zdF9sb2NrLCBvbmx5IGNx
X2xvY2suDQoNCg0KDQo+ID4gPiBzdGFjayBiYWNrdHJhY2U6DQo+ID4gPiBDUFU6IDYgVUlEOiAw
IFBJRDogMTIgQ29tbToga3dvcmtlci91Mjg6MCBUYWludGVkOiBHwqDCoMKgwqDCoMKgwqAgVw0K
PiA+ID4gT0XCoMKgwqDCoMKgIDYuMTIuMzAtYW5kcm9pZDE2LTUtbWF5YmUtZGlydHktNGsgIzEN
Cj4gPiA+IGNjZDQwMjBmZTQ0NGJkZjYyOWVmYzNiODZkZjZiZTkyMGI4ZGY3ZDANCj4gPiA+IFRh
aW50ZWQ6IFtXXT1XQVJOLCBbT109T09UX01PRFVMRSwgW0VdPVVOU0lHTkVEX01PRFVMRQ0KPiA+
ID4gSGFyZHdhcmUgbmFtZTogU3BhY2VjcmFmdCBib2FyZCBiYXNlZCBvbiBNQUxJQlUgKERUKQ0K
PiA+ID4gV29ya3F1ZXVlOiBhc3luYyBhc3luY19ydW5fZW50cnlfZm4NCj4gPiA+IENhbGwgdHJh
Y2U6DQo+ID4gPiDCoGR1bXBfYmFja3RyYWNlKzB4ZmMvMHgxN2MNCj4gPiA+IMKgc2hvd19zdGFj
aysweDE4LzB4MjgNCj4gPiA+IMKgZHVtcF9zdGFja19sdmwrMHg0MC8weGEwDQo+ID4gPiDCoGR1
bXBfc3RhY2srMHgxOC8weDI0DQo+ID4gPiDCoHByaW50X2lycV9pbnZlcnNpb25fYnVnKzB4MmZj
LzB4MzA0DQo+ID4gPiDCoG1hcmtfbG9ja19pcnErMHgzODgvMHg0ZmMNCj4gPiA+IMKgbWFya19s
b2NrKzB4MWM0LzB4MjI0DQo+ID4gPiDCoF9fbG9ja19hY3F1aXJlKzB4NDM4LzB4MmUxYw0KPiA+
ID4gwqBsb2NrX2FjcXVpcmUrMHgxMzQvMHgyYjQNCj4gPiA+IMKgX3Jhd19zcGluX2xvY2tfaXJx
c2F2ZSsweDVjLzB4ODANCj4gPiA+IMKgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQrMHg2MC8weDEx
MA0KPiA+ID4gwqB1ZnNoY2RfY29tcGxfb25lX2NxZSsweDJjMC8weDNmNA0KPiA+ID4gwqB1ZnNo
Y2RfbWNxX3BvbGxfY3FlX2xvY2srMHhiMC8weDEwNA0KPiA+ID4gwqB1ZnNfZ29vZ2xlX21jcV9p
bnRyKzB4ODAvMHhhMCBbdWZzDQo+ID4gPiBkZDZmMzg1NTU0ZTEwOWRhMDk0YWI5MWQ1ZjdiZTE4
NjI1YTIyMjJhXQ0KPiA+ID4gwqBfX2hhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KzB4MTA0LzB4MzJj
DQo+ID4gPiDCoGhhbmRsZV9pcnFfZXZlbnQrMHg0MC8weDljDQo+ID4gPiDCoGhhbmRsZV9mYXN0
ZW9pX2lycSsweDE3MC8weDJlOA0KPiA+ID4gwqBnZW5lcmljX2hhbmRsZV9kb21haW5faXJxKzB4
NTgvMHg4MA0KPiA+ID4gwqBnaWNfaGFuZGxlX2lycSsweDQ4LzB4MTA0DQo+ID4gPiDCoGNhbGxf
b25faXJxX3N0YWNrKzB4M2MvMHg1MA0KPiA+ID4gwqBkb19pbnRlcnJ1cHRfaGFuZGxlcisweDdj
LzB4ZDgNCj4gPiA+IMKgZWwxX2ludGVycnVwdCsweDM0LzB4NTgNCj4gPiA+IMKgZWwxaF82NF9p
cnFfaGFuZGxlcisweDE4LzB4MjQNCj4gPiA+IMKgZWwxaF82NF9pcnErMHg2OC8weDZjDQo+ID4g
PiDCoF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDNjLzB4NmMNCj4gPiA+IMKgZGVidWdf
b2JqZWN0X2Fzc2VydF9pbml0KzB4MTZjLzB4MjFjDQo+ID4gPiDCoF9fbW9kX3RpbWVyKzB4NGMv
MHg0OGMNCj4gPiA+IMKgc2NoZWR1bGVfdGltZW91dCsweGQ0LzB4MTZjDQo+ID4gPiDCoGlvX3Nj
aGVkdWxlX3RpbWVvdXQrMHg0OC8weDcwDQo+ID4gPiDCoGRvX3dhaXRfZm9yX2NvbW1vbisweDEw
MC8weDE5NA0KPiA+ID4gwqB3YWl0X2Zvcl9jb21wbGV0aW9uX2lvX3RpbWVvdXQrMHg0OC8weDZj
DQo+ID4gPiDCoGJsa19leGVjdXRlX3JxKzB4MTI0LzB4MTdjDQo+ID4gPiDCoHNjc2lfZXhlY3V0
ZV9jbWQrMHgxOGMvMHgzZjgNCj4gPiA+IMKgc2NzaV9wcm9iZV9hbmRfYWRkX2x1bisweDIwNC8w
eGQ3NA0KPiA+ID4gwqBfX3Njc2lfYWRkX2RldmljZSsweGJjLzB4MTIwDQo+ID4gPiDCoHVmc2hj
ZF9hc3luY19zY2FuKzB4ODAvMHgzYzANCj4gPiA+IMKgYXN5bmNfcnVuX2VudHJ5X2ZuKzB4NGMv
MHgxN2MNCj4gPiA+IMKgcHJvY2Vzc19vbmVfd29yaysweDI2Yy8weDY1Yw0KPiA+ID4gwqB3b3Jr
ZXJfdGhyZWFkKzB4MzNjLzB4NDk4DQo+ID4gPiDCoGt0aHJlYWQrMHgxMTAvMHgxMzQNCj4gPiA+
IMKgcmV0X2Zyb21fZm9yaysweDEwLzB4MjANCj4gPiA+IA0KPiA+IA0KPiA+IFRoaXMgYmFja3Ry
YWNlIGFsc28gbG9va3MgbGlrZSBpdCBpcyBhY3F1aXJpbmcgY3FfbG9jaw0KPiA+IHJhdGhlciB0
aGFuIGhvc3RfbG9jay4gSSdtIG5vdCBzdXJlIGlmIEkgbWlzc2VkIHNvbWV0aGluZz8NCj4gDQo+
IE5vLiB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpIGRvZXNuJ3QgY2FsbCBhbnkgZnVuY3Rpb24g
dGhhdCBhY3F1aXJlcw0KPiBjcV9sb2NrLg0KPiANCj4gPiANCg0KV2hhdCBJIG1lYW4gaXM6DQp1
ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2sgd2lsbCBmaXJzdCBhY3F1aXJlIGNxX2xvY2ssDQphbmQg
dWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQgd2lsbCB0aGVuIGFjcXVpcmUgY2xrX2dhdGluZy5sb2Nr
Lg0KU28gQ1BVNiBzaG91bGQgbG9vayBsaWtlIHRoaXMNCg0KICAgICAgICBDUFU2ICAgICAgICAg
ICAgICAgIA0KICAgICAgICAtLS0tIA0KICAgPEludGVycnVwdD4NCiAgIGxvY2soJmh3cS0+Y3Ff
bG9jayk7DQoNCiAgIC4uLg0KDQogICBsb2NrKCZoYmEtPmNsa19nYXRpbmcubG9jayk7DQoNCg0K
VGhhbmtzLg0KUGV0ZXINCg0K
