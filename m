Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9164C31328E
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761722337; cv=fail; b=RXH3LGUMdQGGb6UQnCaKtOBWqFJpTAJ7LMNIl9jkuZZwGNOqqerfpAewpJGrtke8ExK9PVPsfmC5Wpumcnu/71wFz23iUfPQo0Vj4yKsJbGwdaX6IKOwbfgbzi0DVdYctCMOqTRfmJF9Qy8RpoJ65WHmvSyYNKDcOJL5iX/wS5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761722337; c=relaxed/simple;
	bh=HaNhWSdJXOxYA896n9Joerw/a4VwaB28rs+1SaRg3ow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nqug2xmCyKDKfu7/5CvNtSSQ9nAjT6xbJZQjZOqnB2m6FxC84GpGTPX2puNYMYfYWuhYN/xs3hjAPSyu3a1btRjJVUGQWzWjfkIlGIajuafuPC6fXVPuu358dfMhaw2MIb6o0LE93AZ6dgA9uCpQfnt5kzjUIsAaRsaIQagO6Bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VO3f4vUx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=t/tq9w0U; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VO3f4vUx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="t/tq9w0U"
X-UUID: 82f1724eb49711f0ae1e63ff8927bad3-20251029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HaNhWSdJXOxYA896n9Joerw/a4VwaB28rs+1SaRg3ow=;
	b=VO3f4vUxDfMHRS5LyNQKBcI425Jrz5ZTw3/Xr0YkysP4dbON//XbVOpuy4kXCYnASKpORzWrai9w53EjOwc8L56gcI2v3tvYsghAz8ukYd+ppxxVZ/YH9YYT0LYgJsYAsPFxg+mm1O/kbeWNI6xCFYot3rxood1SNGbrdiGrmuw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:7c49e85e-37bb-4f26-a0f3-c549f433b75e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:8191f158-98d8-4d0a-b903-bc96efd77f78,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 82f1724eb49711f0ae1e63ff8927bad3-20251029
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 931886223; Wed, 29 Oct 2025 15:18:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 29 Oct 2025 15:18:45 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 29 Oct 2025 15:18:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzjW3SYGANw8S8pDD7HnH+MtKH2f13r3Yz3BkxsdaJ3pF3gvlf0Oo4Q07VOkMZ+WhQuTTPLael+3N2NFUi725XMIgku5EABRIeeNJ0vWI/EgXU9R64Cpoa3FTk3Kiuc4hOskQ/y1mhBj8R8KHK1JMnepI2MCdgu6WjOoXgirQF2dL1Nuaf0GZ86s7lZL+CqLJvnWe+FSYov3cTxjFg6QwF4SDKPrC5cpDACaxhDpCR7BDtfcmRo2PI3e+ndmjhDwrBqTSxUiXI0kCqXVDbMdLrVDGes66aItynA1trxKcV0ksnSV/RIGALxsyueZhpiFvX9OsIXhYC4mE9SejpzDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaNhWSdJXOxYA896n9Joerw/a4VwaB28rs+1SaRg3ow=;
 b=dYHY66p5siAuH0BfWjJXVuXCjK2Dfn3zFcDXHmWBgaAz76AZeUtA1oEEzRzAxx+OQhpEvw4akTkSoisiGm+YX2aJOvmf3kKQrfaRwkC7NyUEX7aJJ4Rlb20Q84N3Rhfhn5NXIFDSyAHeE0wwrDTzYM1BJLTMn2E8z3N5QIoXOSmDGFf/ie7DYfks9fEKq4gr0UtZpx7GLrAQSta7cM2SmdUSMc8z2Ja7a6LOY77so8HbhcZ2po8A/jLQ6sc6tPgZwocPDgOUUWl5oThmhCyrYpJwpYalugsvuLZBQJVCzaXCwUUo4fhgMVTzrek7lsO3AhU7hkuWwXyQOAc74bYGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaNhWSdJXOxYA896n9Joerw/a4VwaB28rs+1SaRg3ow=;
 b=t/tq9w0UJIaBqyoc5TpLb2UACUbB0q5Wd3uZnjjwdF3D6CaE819qeSQlhkkmPfuxAtjjsHgNZRepXt6GdPrfLvMEI6CzAg9hr3VipqEr/ToXbrXucKSuuvy7c4zZqXCucNlp7udXT+2UZo3nYPHGSwJtp0rlllKzXHnSXIMCoWo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6715.apcprd03.prod.outlook.com (2603:1096:101:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 07:18:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 07:18:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "ping.gao@samsung.com"
	<ping.gao@samsung.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Topic: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Index: AQHcR1i8Z6TpPPMGpUqmiLsOvKkoHbTXiHOAgAALWQCAASYDgA==
Date: Wed, 29 Oct 2025 07:18:42 +0000
Message-ID: <7d955a693d11424d527fcdaf4f05ffd792e1edfa.camel@mediatek.com>
References: <20251027154437.2394817-1-bvanassche@acm.org>
	 <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
	 <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
In-Reply-To: <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6715:EE_
x-ms-office365-filtering-correlation-id: dd217293-42b6-4078-b3b6-08de16bb642b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UG9CRDRnS1UvTmp6bks5LzJqSjRFZFFuQnRBWXMvb2lUalVLcDd2YjRrMjEx?=
 =?utf-8?B?RXNqN3ZjcTdkY0VLZHRKUXk4TFo3aWhnN1pENnNRb3RJZ0dDOUV6L3ZSdUlr?=
 =?utf-8?B?UWl4N3luNjhqQUtFdWpuRXk3U0tURlFGMTlwWWJzM0cwOGFORk5odDdaVFZk?=
 =?utf-8?B?S1NxOUdiR1lBTWhKc1lZcjllWWZPTi9Pb3ZkTllCOXZZZWFpWVRlLy9Gam1l?=
 =?utf-8?B?QlBYa2VDTDNkUlNsK2xDYnVzbUg3ZUlzSC9yR1JaREc2UEZrcVZMQUdhdFVZ?=
 =?utf-8?B?U3dZaktDMkFCdHlhdGV6NjUreU1DSFVJNDMwZnBFT0pJcGo5OUtiRXdCdk9W?=
 =?utf-8?B?OGdmUmtjcnFoUXNCWlhIWnVSbERIdlNRQSt5OGVwS1IrMTZNcTg0ZllidnIy?=
 =?utf-8?B?cWpDSTBsaml3OURobExPaEtKS1NndGFXaWxhZEQxVnF4RlMySVR0bUMxdUhU?=
 =?utf-8?B?KzhSSlpET0ExdkxsV05qVHBFZ1ZYQml2M1N0cEI5ejFsaU9QYk8yUEp1elZX?=
 =?utf-8?B?bFE4WlVSUmlrOStBZy85eGs0c29IVnVxY3lLUlYwQUZOSXpHakY3U1pSVGRy?=
 =?utf-8?B?UGg2S2U1OGhtbVhUeGxyVExWcWs1VXIxcXN2OVcyZ1BJeEY0WFJxZDkvR0pL?=
 =?utf-8?B?RHU0SG5YZlJIREpYQnM0Z1ZuODlQdzg5dlEvaWFOVTN6Sk9YVnFWYXRLUUEv?=
 =?utf-8?B?akI2UGVqd3Baa3p2T3N3NTR3TkF0RnBwK2tXeVk4V3haaGdmdTkvcnBRTmhF?=
 =?utf-8?B?ZFZjamN4Tlo0UkFCc3d3UnQzSnFTNlZITVpUQStwWnMvMXcrQmxwTWVBUFV2?=
 =?utf-8?B?ZHhySW1oeklqR0xYMkhiL1pZUURVOXhLTTdWWjdIcXdLUmRWNXB2WTJsdWVx?=
 =?utf-8?B?bWhRZ3VxbnFuV2Qzc05LU2hzbVZpamdyK0I2Vk5hbm9ocDM4OFBKdXBqV0o0?=
 =?utf-8?B?ZUVPQTJ6dVRwbDhqWTIyQzVwUitqL3ZTVWlnR3dQQ25qK01OYlIxQ3l2RXJm?=
 =?utf-8?B?eXV2bDlnUlA1V0JQMlhIZmdVM3VIbkJ5MHRsYkpRMWY4WURvNmVpaUtRVURS?=
 =?utf-8?B?S0JvQVlFV3FLWXYxbHdDTHp6TUw4RUVTVkVlTnl3MmJmaGxNMUlxbDM3aU41?=
 =?utf-8?B?RndWMkV4L0M2Tlpyb1daaFNXMm1odmtaNlAyUEpDdkxadEdPRjFLeW1JZHVF?=
 =?utf-8?B?RzJIeFR0Qkp1YmhBZ3R4bEorWUJIUXdvZFJneDU4S2t1MDZIS0xxTHN1UTNx?=
 =?utf-8?B?azdscjB1QVYrdnNpVWdIdEhUSlZxRlVDN2pPSEoyNGhiRUgzM2ExVkUraDNz?=
 =?utf-8?B?Y25OU1RmRWFIVUFSNi9abCtXS1B0Y2MwOEZ6WC9lOFU3M2p4bDJOYWNqbE1P?=
 =?utf-8?B?cE9oNmNzVnRVTERWSnJuSzNGR0dqN2RIUXY3T3p5QWNmYmdKZGJvUDI1aEdJ?=
 =?utf-8?B?ZFRUVjdVTFJpL0U5VWowSW5Nem5CaU1aeTZjd2doUVlpQ0VqUzcrVExmTjdw?=
 =?utf-8?B?QlBtWmtWQWJORXUvS3pOTUp5Slord24zZmwxWlJTYVB3dWFtcDNHTFdjcWZv?=
 =?utf-8?B?bVcyUDVGMGNLbFdjUXN1ZEw0Wnh3WWlGT1JITlIwQ1laSnFtRXFRbG5ZMVhs?=
 =?utf-8?B?YlNtQjNQa3lMZlEwdkgrbUc2Nm1lRnFaei85LzRMVCt3RmQzL2ttNi8xb1Jp?=
 =?utf-8?B?RUN3MHl6VWhkNUg3aDlrczRQTmZTRVBFOE83bnR4c0EvalFXZGZpWlNLVWd1?=
 =?utf-8?B?SEFRR05SNHBKcUpRelY2d0NjZlVkRFlqbmdZN3lwdytwdkZ5SFZaOWpiT293?=
 =?utf-8?B?QVFZVXF5a0tERC8zTUVCcXk0VUo5UmFaYmRuMWhTa0hVWGw2d1JDbUNmL20z?=
 =?utf-8?B?SGYwdVFObnkvYVRFd0RFQkhZS3dWUFlTOVJnNzdSNHc2M2hRNnJhMGEyZitu?=
 =?utf-8?B?SVc2czdLVkN5bDdqZXA3bVlJRVVXUTh0dkcxaWF1SUVwNHhOaWN4a25kWXhJ?=
 =?utf-8?B?YmZZcjlsWkc4anYrWEY0aEdXVmkrNVFYMWRDWFlVeEN4NG5wcTdiZlNlM21G?=
 =?utf-8?Q?N0vFau?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTRNZXZwWHgvR0FxLzJwcnk3eWpCbUp5RWtnMlcwYXhuSjBrMmZMZVhZcXg1?=
 =?utf-8?B?cjBQK0w5WDNWOGQrK25DQVByWHIvaEdRQkRsb1NTWlU0cTh5bTJRbytzYWRG?=
 =?utf-8?B?KzhqWHdrcE0wRFlqMFpUMU0rUTJybWREQkNsMTBDZTFUREs5ZHlOZDZkbWhV?=
 =?utf-8?B?bkRQU1JHbEozaS9RUy95R01sRFhGSml5WTZIYzFKd242RU1ONXZ0a2ZRa0NN?=
 =?utf-8?B?VlI4RGZITlJITU5jTGVQUWJSU0dWem80eXdHclFJak9PcGR3WGlwN1I5ZW1p?=
 =?utf-8?B?YTR3MEhPa0g0QmYxSEpSaWdacE45Y1d3aXNaajZySEFjWlpBcHFpZm5lU1lu?=
 =?utf-8?B?T2dJUnVCbml2QzNpYzVMQ25FWTNQZzNqYm5pOEZ1WHp2R3N0SWZ2MHhwM1dQ?=
 =?utf-8?B?U3RDQVliajRkWCtLdGpUcWlRNjVveG5JSkRaV2FjMjV5K1BkbjJRT1E2TWZB?=
 =?utf-8?B?bVpHUVVnSGpLNUk2SmEyc3BJdFJ1L1dkRndENjZCZDZ5SXM2YzhJVXBXZnZu?=
 =?utf-8?B?L20zeVl2MVduWnIxTHdzMU9mL1NHMTZyM2liSmRnZ0djNkNteC9vNzBqRkdj?=
 =?utf-8?B?YVFJRGJjRkpIS3Q0aUlEalc0THpyT1dYR05LS0t4MnVKRFJmRHBhWVpxWlV5?=
 =?utf-8?B?ZVNQNUdOMU1NSTVNSnovUy9RVzZrMDlEOTFrcVVIWDk2Z3NtZWh1L2pkOE9M?=
 =?utf-8?B?dDRDZ2liWitkcE1GTWxrUFVYOENqMWdhMTB0WUkyMmZHcEdRS3Yzb3cyLzln?=
 =?utf-8?B?UjBOeldGOU95WUFvblVWbTNLekExckxNVytPK2kveXMzWmRKVzRHUTJ0SWlh?=
 =?utf-8?B?azhMOXpKcmRtTFVSWW5PWUszcXNmNnpyVitmTFJwZFE3QmpyK1BzTUt4M0lM?=
 =?utf-8?B?dDFNRU5hVmQ3NzdQckRlMFRTQkxzb0hyQkFyVWF2VDQ2SC9JeldibTRqdS9u?=
 =?utf-8?B?WGxDRHVmWm05WEloNWVRMWlOcU51ZW9HNUhUYmZ1d3pXU3FKM3I1SzBZWk55?=
 =?utf-8?B?RkV4NTFjUVFvZlk4dmlQenBYcGtka3o2Y1laVXpyeFZtYWFBTlNpT3pXT24v?=
 =?utf-8?B?cm1Jc05ENXZQQzYxUEwwaWJWQ1pzLzA5ZmNKYU40ekE5NkdUYzdGeVEvNG00?=
 =?utf-8?B?SnptZHRoWURwWm1DN1hpTy9ZZkNyNHVqRkJzMEtzMnQ3T2Q1amJXSWM4TjFz?=
 =?utf-8?B?YTF3elc1ZUJBbmI2TlJQUVdNY2VRc1k2R1c4eHZzc3h1aDJzRXhoSTB5b1RI?=
 =?utf-8?B?N09MZWdCSCtRQThBWkxVVEhwWVRjT3ZXTFRDYjVWMzBhNXBoM3piVzMybW1l?=
 =?utf-8?B?NWthZ2Q3bm9GdjVnUjJXaDNrN3FNS3BVc1R3WmdCeHRyZlMwR2ZRNHgyNFNz?=
 =?utf-8?B?NUtxZjcvL0FEMEZZNVhNL2N5blNwQkNnd2JIWVlMWHpNRS9sdVpyQXdkSHhB?=
 =?utf-8?B?MDQ2dnpJdXNqbnB4N2VzNjRJR3RQL0x1SE9xMWswNWRyaHI3U2g2Z2NFcTM5?=
 =?utf-8?B?d2MyR1dkZklPMVNCbGhJYm5YNzFoOEx0Wjc5Y3c5ZFk2cHh3eWxmTlp2NzF1?=
 =?utf-8?B?QkhTZGw0NkJvaGJUNFI1R2JPbHFEaURkQVAyRGRaYWV6Q3lvUmpNTmU1NWdx?=
 =?utf-8?B?UVNEQXQxVUlFM2ZiWTNKWi9LeWZkM3ArMVBNNXk3QnVnOVhVbFdjbFVlL2ZN?=
 =?utf-8?B?TUhSLzZWR3lXVTl2VExsaFVHS3BQRXhaSHpVbmVoY0VuRVBhNHpsOVYyZXJR?=
 =?utf-8?B?S3Q3eXlOM2JyR1R0dUtWYkNqcWNpcWRQYnB0c0tsN3JqN0lYMGdVdFpJVXl5?=
 =?utf-8?B?cnVkekxIekxTWmpMNEtNNEpGMldiN252REp0QUIwemhtSGc0Z25XVmR2My9U?=
 =?utf-8?B?WElrN2xxczZ4UCtML2ZqcE5sMFl4WkViNTRoeHp6MlJpLzFJTFJUS1Rxc0M1?=
 =?utf-8?B?d0Jza0ZxQ3BoUFpyM09WeEpYMUNHNmhHdXZ4ZlJHMEV5SzU1dnVjdkFvOWl4?=
 =?utf-8?B?SlZLcDkzSnI1REhoVnp2ZmE0MHBGOThGekRnN3RVeHVYWTZaWnFqelFOY3BP?=
 =?utf-8?B?eXNuZkRTMndTU0hCOTUrVitMWmFHcFJKaGU5V2FaWEgrL214S0ZVRnpoYTBW?=
 =?utf-8?B?S2RQa3VZNWdzQTVxbGN2Z1NDUGNyV0xiM3g3bXFyUWh0eWJyTGFTbENoYUg2?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B81BDE534DA76246BE7B20FC53FFF458@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd217293-42b6-4078-b3b6-08de16bb642b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 07:18:42.7948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: di33BXBywhXg9TBDKzCp0UxP8lBJ4r7Qm8/hQO5HET7K5K+PbspJp96dyZidAdb2nLsEMzF6jBwD1k0goolQlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6715

T24gVHVlLCAyMDI1LTEwLTI4IGF0IDA2OjQ2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHVmc2hjZF9tY3Ffc3FlX3NlYXJjaCgpIG9ubHkgc2VhcmNoZXMgdGhlIHN1Ym1pc3Npb24g
cXVldWUuIEV4YW1pbmluZw0KPiBjb21wbGV0aW9uIHF1ZXVlcyBpcyBub3Qgc29tZXRoaW5nIHVm
c2hjZF9tY3Ffc3FlX3NlYXJjaCgpIG11c3QgZG8uDQo+IA0KPiBUaGUgVUZTSENJIGRyaXZlciBp
cyBiYXNlZCBvbiB0aGUgYXNzdW1wdGlvbiB0aGF0IHRoZSBVRlNIQ0kNCj4gY29udHJvbGxlcg0K
PiB3b3JrcyBjb3JyZWN0bHkgYW5kIGhlbmNlIHBhc3NlcyBjb21wbGV0aW9ucyBxdWlja2x5IHRv
IHRoZSBob3N0LiBUaGUNCj4gU0NTSSBjb3JlIG9ubHkgdHJpZXMgdG8gYWJvcnQgYSBTQ1NJIGNv
bW1hbmQgYWZ0ZXIgdGhlIFNDU0kgdGltZW91dA0KPiBoYXMNCj4gZXhwaXJlZC4gVGhlIHNtYWxs
ZXN0IFNDU0kgdGltZW91dCB0aGF0IGNhbiBiZSBjb25maWd1cmVkIGlzIG9uZQ0KPiBzZWNvbmQu
DQo+IFRoaXMgaXMgc2V2ZXJhbCBvcmRlcnMgb2YgbWFnbml0dWRlIGxhcmdlciB0aGFuIHRoZSB0
eXBpY2FsIHRpbWUgZm9yDQo+IHBhc3NpbmcgYSBjb21wbGV0aW9uIGZyb20gdGhlIFVGU0hDSSB0
byB0aGUgaG9zdC4gSGVuY2UsIEkgdGhpbmsgaXQNCj4gaXMNCj4gdmVyeSB1bmxpa2VseSB0aGF0
IGEgY29tcGxldGlvbiBpcyBwcmVzZW50IGluIHRoZSBob3N0IGNvbnRyb2xsZXIgYW5kDQo+IGhh
cyBub3QgeWV0IHJlYWNoZWQgdGhlIGhvc3QgYnkgdGhlIHRpbWUgdGhlIFNDU0kgY29yZSBhYm9y
dHMgYSBTQ1NJDQo+IGNvbW1hbmQuDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpUaGUgcHJv
YmFiaWxpdHkgaXMgaW5kZWVkIHF1aXRlIGxvdywgYnV0IGl0IGNhbiBzdGlsbCBoYXBwZW4sDQpl
c3BlY2lhbGx5IHdoZW4gdGhlIHRpbWVvdXQgaXMgc2V0IGxvdy4gRm9yIGV4YW1wbGUsIHRoZSBk
ZXYgDQpjb21tYW5kIG9ubHkgaGFzIDEuNSBzZWNvbmRzLiBTb21lIGRldmljZSBkZXYgY29tbWFu
ZHMgbWF5IGJlDQpkZWxheWVkIGJ5IG5vcm1hbCByZWFkL3dyaXRlIGNvbW1hbmRzIGFuZCBldmVu
dHVhbGx5IHJlYWNoIA0KdGhpcyB0aW1lb3V0Lg0KDQpCeSB0aGUgd2F5LA0KdWZzaGNkX21jcV9z
cWVfc2VhcmNoIHdpbGwgcmV0dXJuIHRydWUgaWYgVUZTSENEX1FVSVJLX01DUV9CUk9LRU5fUlRD
Lg0KVGhlcmVmb3JlLCB0aGlzIGNvZGU6DQoNCisJaWYgKGhiYS0+cXVpcmtzICYgVUZTSENEX1FV
SVJLX01DUV9CUk9LRU5fUlRDKQ0KKwkJcmV0dXJuIHVmc2hjZF9tY3Ffc3FlX3NlYXJjaChoYmEs
IGh3cSwgdGFza190YWcpID8gLQ0KRVRJTUVET1VUIDoNCisJCQkwOw0KKw0KDQpzaG91bGQgYmUg
ZXF1aXZhbGVudCB0bzoNCg0KLQlpZiAoaGJhLT5xdWlya3MgJiBVRlNIQ0RfUVVJUktfTUNRX0JS
T0tFTl9SVEMpDQotCQlyZXR1cm4gLUVUSU1FRE9VVDsNCi0NCg0KYW0gSSByaWdodD8NCg0KVGhh
bmtzDQpQZXRlcg0K
