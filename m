Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6837BAEC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728440234; cv=fail; b=HseogOqFPtSrr03iE64+0E7xVr7J5WHFOuznutQyjt/frl0qVC/DTsHrJgKkuiYeMztNs86flHdC1CZQBcd0GxR3eiCrVChT0dO6PiTGMT2Mr8/Mni2TJwz0+9vBP4ByWY+jeAlMSStZD5fb3k0AseZcXrshAPNs5AyV5i8qxWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728440234; c=relaxed/simple;
	bh=miCjEEzKO1GygC+6fckZr2tTz3Xb1PEgVTmxRXwlzqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D1hRJnWP7k/2BrzCXovVCniZuSbTJYnYREc16+GGm1ZPVRNQMeVM4z2KAMEx3Z2X06pBChkXxBrXdVSdUuy1SET36/gPfP3JiQTFfvIngvNbtjxg+sA1zcNvr75hOoninkP4P8yTDXYkKYx9y8yILXGIgL+ekZWTXDkofoFiYMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mR3XIldT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=pqpKNU0k; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mR3XIldT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="pqpKNU0k"
X-UUID: 95710be285e411ef88ecadb115cee93b-20241009
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=miCjEEzKO1GygC+6fckZr2tTz3Xb1PEgVTmxRXwlzqU=;
	b=mR3XIldTguwYLIBQP1+1C+Whmg2c4Yb0A1CPS7mxtf/bqs7Enml+zt5kp+YZKcN9upVNPoKXR+JpF0At9KViR6gJ4KVYwdwxrKyvO/vFXWovjIgOq6HvIwBOK+Cn6y5tQuhLgSCcXMgJQmvi1YdF98TqYwMlcQ7jHDLe0bW9V5k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:89429e25-60b0-4564-ac20-4fe3695d6f0f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:302b8126-5902-4533-af4f-d0904aa89b3c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 95710be285e411ef88ecadb115cee93b-20241009
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1750369857; Wed, 09 Oct 2024 10:17:07 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 9 Oct 2024 10:17:06 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 9 Oct 2024 10:17:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3CJHBd4UbfU9qL6R3V9jqLaaiXAidhb81Y8038KLFN5r4hyxXi9itvLpuP0XE1GuDAZhY5AKRUCcOYMIP02oOiYumKmb8R2LmXAy+sfzfTgavqkv+4G8pgP1aBqCBomqwT5WbSr0OlofWo8s+cuzZV/zApUMLlHr/Uyzp2QSxVTZH3dz2wwLiguctpEalGfniNaVyhef2FicPJGpEU6GLfgd6P0/eWFTj5YAr5Gg+mDf6IrpOJkPRU47Bx6sM50rolvE/6Xhnl5KLC+bot+nXmoabWS+MCMKOxQ5kbO5OQvXmzcqsKPr2dl/0qvP2NgaWUQKJ6KCOzvabZQiSf+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miCjEEzKO1GygC+6fckZr2tTz3Xb1PEgVTmxRXwlzqU=;
 b=WkyPcjsNNKumasGQK5TNFr1Ew1xodM3T/zBz7fsvsxb4SiK7IOf8d2DXg0lJ8Gm21EoCe17WDp9+BDpUj4xwT2hhJScCLXCYFU9n0tuNY7zr+66Nzy9EbUbuyrWJOFHjuGHBkdjuYf7yX8FhmsjM0Q4KG/hV03Iwgde81SXy+BcxWA+WucnMZ7VBcxP3Sj10zLquAxlKZ1rcxy2EDCSYUsVmdXpYL1vMQQoG2i+fDt+AoixwrYtdB5N1hHfU+lE1dzaFl4/lB8ED1w8j8RBZyNw2PQ/nrHvl8Eb1pr5r5uXXuznArriZSiuzRaZPgIk3JGaLWfGnHc6nH7fMzGDnAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miCjEEzKO1GygC+6fckZr2tTz3Xb1PEgVTmxRXwlzqU=;
 b=pqpKNU0kNmyCP7sxM9BCM9H2oUQqQdW6KMyNi1dNp57UKmiJILpjmA6VXhGl0CUSCOjt9auR4hQZqH2GZi+OKNSWIMzrFWIHs7GFFeErholBWWl37Rj1IG44e2/jZ43n97niUaCkULY+1Z+5ZOl2l8/PbodivVgsw8wVzsiUdWA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8264.apcprd03.prod.outlook.com (2603:1096:101:1b3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Wed, 9 Oct
 2024 02:17:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 02:17:03 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: wsd_upstream <wsd_upstream@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Topic: [PATCH v10 2/2] ufs: core: requeue aborted request
Thread-Index: AQHbE+Mn3m6Kz/z9nkigLrxdmIZYWrJyIqsAgAFGjwCAAg1bgIAFdH8AgAJNQICAAIKNAA==
Date: Wed, 9 Oct 2024 02:17:03 +0000
Message-ID: <bb9280de1a6dde857f0f3fe8c784bd71653a5ec4.camel@mediatek.com>
References: <20241001091917.6917-1-peter.wang@mediatek.com>
	 <20241001091917.6917-3-peter.wang@mediatek.com>
	 <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
	 <69a77b95da27fa53104ee74ecae4e7da2d1547cf.camel@mediatek.com>
	 <e6e93ff1-cba1-45a9-b4b6-7dcbd7fca862@acm.org>
	 <8c463196860b71f26bddad0e7e8be6aacd470109.camel@mediatek.com>
	 <a02c83eb-d057-48cc-9735-770928a2a0a1@acm.org>
In-Reply-To: <a02c83eb-d057-48cc-9735-770928a2a0a1@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8264:EE_
x-ms-office365-filtering-correlation-id: ab741557-6efe-48b3-1a9c-08dce8087721
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QU5Nb0YrTHBZcnB3dE81TmM4VVNHMmQwcURXMGR1MVpET2FnVmJlSjNzdFkw?=
 =?utf-8?B?SFhMRkFDTnczb2EvWGlaQ2gvaFJwM3ByVDlLc3pkVXpJN3A0NmZxTG5hVXh1?=
 =?utf-8?B?V0d0LzkrbnZ5YWpHNFVNKzBkWi9IU1NUcCtrRGw2SU5wSjl5NUpqMVpBZnpU?=
 =?utf-8?B?aUxCWHlEMDh2bHpJeGxTTnRqRUFINVdJK3lHaFl5NDd1NENoUHNIbzkvZzlE?=
 =?utf-8?B?amE0V2wvVHd5QXE0VDhPTWQwRStZSzlKUy9UYkNiRElyOVVYMFdLMEhzaGlT?=
 =?utf-8?B?VHl6SGNJL3FOZTNsMzc4VHptN3lwUDV4MExXL3A1Y04ySTJiNytpaUI1TkEz?=
 =?utf-8?B?aXUvdnNPWVp5QzRUb2FOQWlFZUY5cFN5Zlk5b3JNbkE1L1BOVHB2VU42a3hm?=
 =?utf-8?B?Mk5MOUdadkZQZUk2YVR1YlJWNzNraDFNbjZVQTc2bVZlVnBBd3M2WWswQ0tJ?=
 =?utf-8?B?TlZiUTF3QmRLUTFkVzhFRkpvY3NOTHkzMkJQUldzWWtzcmxlbUczMDQ0TXYx?=
 =?utf-8?B?QnVVQzA3S2QrbTh5UERSOXZ0dlNQZ0cwc1lnNk9rck9kdy9tTkRXSEFFUzBT?=
 =?utf-8?B?Sjh0MDE1ZDlUOUJQQ2xvY0lraVdHWDRYWG00dHhJdHlPTHZQaEltSE5KYWh5?=
 =?utf-8?B?b0htMjJZV0RRT2Q1SmNaeTYycjFKOS9Ud3AvRW00WWM1NXorVFdXc2c4eFhl?=
 =?utf-8?B?R255Q2YxMGQvS3NxYlJ1TDlJOW1zR2RJN0FzRERMZVdvMGVKaVlCQUtWMkFN?=
 =?utf-8?B?cFZwQUF4OXNOZmRQNGtiWENwUmdPOUl5bjh3bktFTzFYWjMrMVZ5cTZNN1lt?=
 =?utf-8?B?b2dhV1BmZklWL2E5MDNlcEY1Z2h5WmZ5Uk81V21pcVVzSW9RWmtDNnhSNnRo?=
 =?utf-8?B?WnR6WXZpN3R0UmtXNWx4V2pJYUhTeEJMSngvOFJRVjFvQU4yUmp1M1RWUmJ2?=
 =?utf-8?B?ODVYZWVid3ZZWVNObmhESDNLcW9na3JmS2RFS0E5WWd3dCtydEJzTllUZ2Qv?=
 =?utf-8?B?cXdCWExCWHN2M2FpcWwvOFVLd0RKcVhMK1pyQmNqTnEyQ1BoQThlQ0x1Tndh?=
 =?utf-8?B?dFFidFRYTnJJVjFtb3ZrWVZwVjFyRXhTbnlCV2tLNTR5SWJsTGRKbHVWUWlM?=
 =?utf-8?B?aUQ2UWFFRmR5UE5aR2FLR3o3bUo4SHJwMTFYeFpkK2x1QnFNT0M3ZUlEL05p?=
 =?utf-8?B?TjZlUHdmbU1hUy9EMXdpR0hoN09LRHBlbXZpZU8yT242Y1hZc1FCVHVvR3dT?=
 =?utf-8?B?MWtzQW9TQ05ob3ZmMUZ3OXRKdmNnMjVxRGZwdGRrSlNuOGJ0RG54WW1OSk9z?=
 =?utf-8?B?VXlSK1VaTGdPNm1xcTlYWndnM2RRUFU2eTIrcktiVjBiTzZsdzRpcG1Ed21R?=
 =?utf-8?B?Zm42Wmk4b3dxdys5c1VkS0V2UmUxMDVJaEk4OThCQTlIc3VKMGFDQmR3YitT?=
 =?utf-8?B?YmNrWmZBTFpwM2tqeDkxUmZBcmFxMkwvRlVIYzFLV1NSUE8ybWVqcjI3SVo5?=
 =?utf-8?B?VXl3M0x0SUVnbFMzSFkxMW4wdFNlSGE0bGpiVFZSUEZZWGltcWl6WDBQNWU4?=
 =?utf-8?B?dTFWVVg5eUp2elpacFFlUm1wVDlJb1FwS3A2WlRoNldiT01qdmhYSDllb1pU?=
 =?utf-8?B?NzI4ZTNUVitLc3B0UWowTE4rblhvc2VMMWlDN0JHWXJkeXc1dExkN2lKUm1k?=
 =?utf-8?B?UThvNzNpNktLaUZGZlNhSHkwTVNVYy9lcDRIL0xDT1JyVUxORVJ2OW1QSklX?=
 =?utf-8?B?SXdjMEVob3Rvc0tmSE80MEJmK2NITmt0MFlWbkdIRTRlQzVsc3JWOVRkQ1Vx?=
 =?utf-8?B?U3d0ajNBalJZYzQ0ekg4QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkdOc2JvTVdia3lJZXF6WWFFOGRNWXdDcTYrbkdhUnNxcGRLTzI4bTNCVDdk?=
 =?utf-8?B?WklsaUZmVjM3ZU5ZRDRZSFdrZjc4dG9NUy9rTllTRkJkbUpzaFNveXhPaDQx?=
 =?utf-8?B?eVpZeDdpQlpTWmV5VmlFUnlGYTBWZVBIMHZUcndVVU1lU1AzZGJINHNvdzk4?=
 =?utf-8?B?SUk0bm5tRWlMbzVnRTNEb0crRHhzbERIOTVZR3hESEVMY2EyRmVGZ0s4eDNY?=
 =?utf-8?B?cEpKR0d2UjdwQkVPbkk2QmVyTGFTaHNvMnFwYTZkSXVYVEZuRHlsOVJuaThu?=
 =?utf-8?B?L0ZtczYwcFBaRGxxRnhqRzMzQWNLanluMm5EYlROenUwWlI5K1BhY1Y0TFpV?=
 =?utf-8?B?T2VaQWRkSDh6MThOUW1UUmwwTm41Yk55RlFEK2FHV3d6aERudWQzV3Q3cVI1?=
 =?utf-8?B?VkFlUnBKTnJQdGd3aWZITnhVRk1Kd3laTm92UTFlcmp1U2l3N21oZE9mdEJX?=
 =?utf-8?B?a2Z5Ui95Zk1oVVdpd3VzTUE4UmQ0RUw0OTJoWFBOSWw0MnBPNzYxMWlTYmpu?=
 =?utf-8?B?Sy9VMHhlU0NJRzZSYVYrVG5VQjR4TXlTSUw3ajlwQ1c1cjBwaVNXTHhmVnA1?=
 =?utf-8?B?TitUWkY4eVdNNUNTWGJLOEc3ZUxjV21yc3RrUkphZjM0QXBqaGFISTA5VXRk?=
 =?utf-8?B?dmZNSGYrQ2RQM2loZTlQWGJLOHRYM0hXTkluS0E2cWdPK29XRUhZdzA2NWk0?=
 =?utf-8?B?TE5aTjdkcFBJZ1BzRlJERW45c01CVm1WODA4L05HM2FsMGZJS1pKVlhwUGZH?=
 =?utf-8?B?VVhlcmtzS0dyajYzRTF0MEEwUmRST3RXc2d4cnU5OVQveGQ2WUY4TlluakZm?=
 =?utf-8?B?ZC84eGZvYWp1dHQxYUs4d1FVZWp2U0ZCVkFqRnpCQWdSS1RCUC9rYTV2dElq?=
 =?utf-8?B?NFBJUnFjQ0pwZFFkRHd1RDN5eVZPOHNBUHYxMEVFSkdUOEpOUFVjeDBhN3JT?=
 =?utf-8?B?SWRXMlV1ODhxelBWczZna2ttdE5OOC9IQk4yNnhYQzZHQWpLWTlRaG5qdFBr?=
 =?utf-8?B?WmFROCsvZUJmT21OMEhYQ2d3UW0vcXJsTFNXTUtlZ2I2THlkRGp1cmdxeE8v?=
 =?utf-8?B?QTVEb0pHSFFYQUtyQm1DVjZQaTRVUnJFU1Ava244N2xKK0V2cnJ6VHJjZjhS?=
 =?utf-8?B?K01Ec1oybWt2Y1ZqZjc3aGFrU0V2NXFKTXYxR0dKU3lGbFVJZXdNVS9tSk9L?=
 =?utf-8?B?d1VYWFQvSXNLeUMyc3hFRlFoT1EvTnJ3WldxbFhvRXdxQStyYTE3UTU3dVE4?=
 =?utf-8?B?NXBlZFJIMEZRM0ZRWUIyQnBPS0o2K3Uyc3B6WjVxWUVDeVptenpDNC9JOGV3?=
 =?utf-8?B?MzhDWUcxaTlxbjR4L1h4ajVtRlBJZkhTejM0ZGRCNC9acjdPeU5YSG04TG12?=
 =?utf-8?B?R3I3RHJ4aG9ZbDRyZ0djMDNuSXVTdHRFUWNnUWJTS2Rzd01TVUxIMy9zdjFx?=
 =?utf-8?B?Wjc2R2Z0RnlxQXpreitpaWMyaXJ3c011SGV6Vk14UlUyOU5FdnljTWdnQTFh?=
 =?utf-8?B?Z3NVLzF5bVZ1VzJ5OTR5WGlQcklHMDA4NWJpalhEQzNLdDV5L1VhQTFqM3dj?=
 =?utf-8?B?V2dHVVZwYkVla1ByRlduVE1hdnJnS2tKSzg3TnhWTW9Rcmh5NVFFL0tiUGl4?=
 =?utf-8?B?MlpkWWx3dEVQY1M5QjJkc2c1bTUwemVGRXRCVUhHL0JQcHdwZm0yUUlrNldH?=
 =?utf-8?B?SkpNd2hjR1RyNXZrcmRSZ25QbVdiSVN3UGowYkJZOHpKUnZPM1N4OGFYOHBl?=
 =?utf-8?B?NVV5NW02b2RXMlQrS2hqVnNCU3JEYTViREc1WVk0NnpoWW9Ndk5Tci9mY1N2?=
 =?utf-8?B?c0s1cU5wZ3RGTE5FY2d2SmZ4KzBldUllRmxOaEp0QVBsNmY5OEtiSjBlK0R0?=
 =?utf-8?B?RE56alRDUlMwUEsyVzBuaVhKcDIvenZQdHpUR3ArZXhvSEF5a2dwZkxFYkpE?=
 =?utf-8?B?QldPb2xydmlJOWxvd2l5YUY4R2pBUXgrVmt6VUhJai9Hc2RpOUpmYjBPUWJS?=
 =?utf-8?B?YkprTzJ3Q2dmN0l0c2xyY0UxTjl1N1lrQ1BHK3MwY0Z4LzJDZVdTclIwVWFH?=
 =?utf-8?B?OWFHRjQyYWorbjUwbWZBMFBsZzROTGN5L25IT0xnWlkzMllWaWo5clV6MUQ2?=
 =?utf-8?B?YUd4eCtmT0JlbkpTWHAwRUNJRUkrQTM5b3V3TXlmRkxXUTVzTm1US20vaG5x?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D388E4D99E784F40BED9B26BFF046B21@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab741557-6efe-48b3-1a9c-08dce8087721
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2024 02:17:03.5652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qISJqjuClBwf8dmF0jL9bz84v5hwdtyN96lYfnrNl8MJKbXic5lbA1ZxlsX3OCZ+h87xOp3Pm0oKGkQlEXL7vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8264
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--19.842900-8.000000
X-TMASE-MatchedRID: Q8pJWSpPf0PUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4+qvcIF1TcLYISC
	l3uvYUiS25A30Tzvjf68jB7LYCUVUW00sCPwNg7wkJi1wdeHFtoxmbT6wQT2awZbeEWcL03Vv98
	4uoE4bamsp9XzC6B2sB5f9e97VEQj0RCs70uuPqEXrP0cYcrA2wS7cfuuBhWp2Rwj7dgeV+TyjI
	ozxd1UGCya+v8M/Jfc3i/waIXC+zNehll0JtAbYYzb2GR6Ttd3kdS3kPlaZyUM74Nf6tTB9tpAZ
	aJZpBgl1WFj9taZNXoH4jvnDtS/ykL9tcyTZdAsgxsfzkNRlfKUGVjlL4Q/p9RnEQCUU+jz9xS3
	mVzWUuBk431H65J9AA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--19.842900-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	F7CBA3C44A908B07FD0DBC2E214B84CA517C2B07C04DEC7C1EFB918CDE23C8D12000:8
X-MTK: N

T24gVHVlLCAyMDI0LTEwLTA4IGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gSSB0aGluayB3aGF0IHlvdSB3cm90ZSBhcHBsaWVzIHRvIE1D
USBtb2RlIG9ubHkuIEluIG15IHByZXZpb3VzIGVtYWlsDQo+IEkgY2xlYXJseSByZWZlcnJlZCB0
byAibGVnYWN5IG1vZGUiIChTREIgbW9kZSkuIFN1bW1hcml6aW5nIG15DQo+IHByZXZpb3VzDQo+
IGVtYWlsLCBJIHRoaW5rIHRoYXQgaW4gbGVnYWN5IG1vZGUgaXQgaXMgcG9zc2libGUgdGhhdA0K
PiB1ZnNoY2RfcmVsZWFzZSgpDQo+IGlzIGNhbGxlZCB0d2ljZSB3aGlsZSBpdCBvbmx5IHNob3Vs
ZCBiZSBjYWxsZWQgb25jZS4gSGVyZSBhcmUgdGhlDQo+IHBvc3NpYmxlIHNvbHV0aW9ucyBJIHNl
ZToNCj4gKiBBZGQgYSBmdW5jdGlvbiB0byB0aGUgU0NTSSBjb3JlIGZvciBzZXR0aW5nIFNDTURf
U1RBVEVfQ09NUExFVEUuDQo+IFRoaXMNCj4gICAgbWF5IGJlIGNvbnRyb3ZlcnNpYWwgc2luY2Ug
bm8gb3RoZXIgU0NTSSBMTEQgbmVlZHMgdGhpcw0KPiBmdW5jdGlvbmFsaXR5Lg0KPiAqIENoYW5n
aW5nIHRoZSBlcnJvciBoYW5kbGluZyBhcHByb2FjaCBpbiB0aGUgVUZTIGRyaXZlciB0byB0aGUg
c2FtZQ0KPiAgICBhcHByb2FjaCBvdGhlciBTQ1NJIExMRHMgdXNlOiBpbnN0ZWFkIG9mIHVzaW5n
IHF1ZXVlX3dvcmsoKSB0bw0KPiAgICBhY3RpdmF0ZSB0aGUgZXJyb3IgaGFuZGxlciwgY2FsbCBz
Y3NpX3NjaGVkdWxlX2VoKCkuIFRoaXMgd2lsbA0KPiBjYXVzZQ0KPiAgICB0aGUgZXJyb3IgaGFu
ZGxlciB0byBiZSBhY3RpdmF0ZWQgbGF0ZXIsIG5hbWVseSBhZnRlciBhbGwgcGVuZGluZw0KPiAg
ICBjb21tYW5kcyBoYXZlIHRpbWVkIG91dCBpbnN0ZWFkIG9mIGFib3J0aW5nIGFueSBwZW5kaW5n
IGNvbW1hbmRzDQo+ICAgIGZpcnN0Lg0KPiAqIEFkZCBhIHZhcmlhbnQgb2Ygc2NzaV9zY2hlZHVs
ZV9laCgpIHRvIHRoZSBTQ1NJIGNvcmUgdGhhdA0KPiBhY2NlbGVyYXRlcw0KPiAgICBlcnJvciBo
YW5kbGluZyBieSBjYWxsaW5nIHNjc2lfdGltZW91dCgpIG9uIGFsbCBwZW5kaW5nIGNvbW1hbmRz
Lg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCj4gDQoNCkhpIEJhcnQsDQoNClllcywgdGhp
cyBwYXRjaCBpcyBvbmx5IGZvciBNQ1EgbW9kZSwgYmVjYXVzZSBvbmx5IE1DUSBtb2RlIA0KcmVj
ZWl2ZXMgT0NTOiBBQk9SVEVELCByaWdodD8gVGhpcyBwYXRjaCBkb2Vzbid0IG1vZGlmeSANCmFu
eSBvZiB0aGUgTGVnYWN5IG1vZGUgZmxvd3MsIGRvZXMgaXQ/DQoNCkFkZGl0aW9uYWxseSwgSSBz
dGlsbCBkb24ndCB1bmRlcnN0YW5kIHdoeSB5b3Ugc2F5IHRoZXJlIHdvdWxkIA0KYmUgYW4gaXNz
dWUgd2l0aCBsZWdhY3kgbW9kZSBoYXZpbmcgZHVwbGljYXRlIHVmc2hjZF9yZWxlYXNlKGhiYSkg
DQpjYWxscy4gQXMgSSBtZW50aW9uZWQgYmVmb3JlLCBpdCBpcyBwcm90ZWN0ZWQgYnkgdGhlIA0K
b3V0c3RhbmRpbmdfbG9jay4gQ291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IHRoZSBkZXRhaWxlZCAN
CmVycm9yIGZsb3c/DQoNCkZ1cnRoZXJtb3JlLCBldmVuIGlmIHRoZXJlIGlzIGFuIGlzc3VlIHdp
dGggTGVnYWN5IG1vZGUsIGl0IA0Kc2hvdWxkIGJlIGFkZHJlc3NlZCBieSBhIHNlcGFyYXRlIHBh
dGNoLCBub3QgYnkgdGhpcyBvbmUsIHdoaWNoIGlzIA0KaW50ZW5kZWQgdG8gcmVzb2x2ZSB0aGUg
TUNRIG1vZGUgaXNzdWUuIFdlIHNob3VsZG4ndCBtaXggdHdvIA0KZGlmZmVyZW50IGlzc3VlcyB0
b2dldGhlciwgZG9uJ3QgeW91IGFncmVlPw0KDQpUaGFua3MNClBldGVyDQoNCg0K
