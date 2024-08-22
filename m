Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6F02E3EE
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 05:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724304898; cv=fail; b=a5sAwWDpG1m4nUjubN9Uy28IVrCPenNAV3avAlvnHJHdlp6PGsiBmUB4q9xGLuyc5iJ1st3ojN8QUN9Ud38IXuTqUmnTtKKu0TNP8C6aHXzvoVnMOUAJBOdG4GW3MniI97cviVqBSX+9kJ822vRBC8J6u4CduDlTbCQoQwRFCqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724304898; c=relaxed/simple;
	bh=ZA2H26QkxU1Sg91R7LNvxhuqv97wRw/MEN9DaTxgdn8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BRW3vHeNjfLZYsbQ1lMUm/v0xD6e59yonlW76ygk4JrG7bIT0bJNq59yIK2pP00nq3QJfrlHD9vFuv9VPnvqy8zuYpLdF5IWSVVPe8oBiZqa3P4NSQdPkak1WN4nnGaXJPkQecOzFqzInNosMrTeAvrIf0ypW+LQNb+bE6T+SuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EAl7zlxT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NDlcYh4O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EAl7zlxT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NDlcYh4O"
X-UUID: 3e4024b4604811ef8593d301e5c8a9c0-20240822
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ZA2H26QkxU1Sg91R7LNvxhuqv97wRw/MEN9DaTxgdn8=;
	b=EAl7zlxTBRbFPP4o5+lKRMJ8f2cdBedyD4F53A590hDbRURCFc5XOmjSgADrYGssz96SAQDA1KApQT+qalWnSxs+/zyhe83EaCRWKVJjGGRLOgzPOJ3iXNTfROrUsb+XbtSpADnAfbzhPNURDduAapaNvfNwh/ZoKn7zuVwmYvg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:b6de26f6-3f93-46d7-99dd-a42e315e97dd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:520cfece-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 3e4024b4604811ef8593d301e5c8a9c0-20240822
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 652537485; Thu, 22 Aug 2024 13:34:47 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 22 Aug 2024 13:34:47 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 22 Aug 2024 13:34:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ts/q6q0unE/W1fHJufbnajjuNiL4dvxghxmS/W5XRNFZhI/aRel3fPBlV/3qO6+lvXoseowa/2IV61JOrWWAyv5yfd7wtoxbkZ6uhL9fnY3gNjE1eKB7bpLx56U3D607LwYTDNCyNDF/6yju6I7hjgDS9p4lO63k8Dlw/Qj0HUeT0pww4tVSiIk6+LPJEH8fVsrR4lhkZx7cIItu49GS1f7/9Zct112Rl383tBzIxix5hJWq5B0gmGU3eR2JFSI65bQ7aOyuUXVDf2TfuHDDc1stgkOemNnrLrYcAGJW+UdNDmzCQIJh4x1QgW6cNXomGZ7aUq8i70kCCOCX/UtihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZA2H26QkxU1Sg91R7LNvxhuqv97wRw/MEN9DaTxgdn8=;
 b=OplBIIijP/CwDDoSpel+l+3sjqzk5ZENgBRlyLHPJvwTtO1V8J76YJ+8n6HZIjb/oM59AlEc5+Lub04fzsRAjclpoGrgzbS9J6b2LUb5797onHH3IV9YJm44zc5NkhzES/37qu8yhU5wVhE28TKC8c1iJe4uOgV546cctWZ9fmi7iK6xKwfV6j1yMIaRsHw8RAXimZKsV9ujV9yDCKwU4eRJtxAeIo0xs/AlsFlzPXKMvbNr9mWgWPBOsLCEg/t2nNVEEi72Px/7ntckOlPb9QUPZH1RRdyqYjHDQO8/VVcLnMmwwEp6FSYX6IqaIFI9h8vsS7Y+GpKtOaV7jQTuOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA2H26QkxU1Sg91R7LNvxhuqv97wRw/MEN9DaTxgdn8=;
 b=NDlcYh4OWZ7UroYnBqvbgqBcNmxWQbpeM2JeROFQGCsLfi9GBDEOfAT1NksRGuKz9bpihTsAEswNz0CrIwUIIM168dWMd7XmduvUXl0vBv129npCfeSXrTDiTK9R0RWpdqi2VZvelfCx1p14dJ5uX5zyRjLeKx9nQtyahrm83vs=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SEZPR03MB7839.apcprd03.prod.outlook.com (2603:1096:101:186::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Thu, 22 Aug
 2024 05:34:45 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%7]) with mapi id 15.20.7875.019; Thu, 22 Aug 2024
 05:34:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"ahalaney@redhat.com" <ahalaney@redhat.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Thread-Index: AQHa8/ghGzQNc4Nbn0yIAFU0+PnDB7IywgwA
Date: Thu, 22 Aug 2024 05:34:45 +0000
Message-ID: <50e21f3e873c19da78b108b0352a8aa6cf95907e.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-2-bvanassche@acm.org>
In-Reply-To: <20240821182923.145631-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SEZPR03MB7839:EE_
x-ms-office365-filtering-correlation-id: 8a805eeb-62dc-41ad-5eea-08dcc26c214d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVVWWVhTMHRlUnpsRnZpdzAzUUlsbFJsRUJjL1BYMmV4a0JJY2FkNlY2bFNt?=
 =?utf-8?B?ZS9kSmZmcFAvT1dVSmZJTkY0L1pZUHlCdjYwNC9mb1JxcTFObWZjQ2VQTitI?=
 =?utf-8?B?UmFVVko5WVpia1I2amtFalhpMklKbk0zZkw4RXRSVmt0ZExXYkt4WC9aNXVF?=
 =?utf-8?B?cVhvTFN6cjFQWlJaTGoxSnBDODdsVWdBT1ZOdmsrR1NXdnpLRVV6bWdBWUd2?=
 =?utf-8?B?Y2FIdkozazBnb2ZuQ0gveDZtODlSYkpIaDdqYXVrK0Jvb3BGOUxkSXU5TXNB?=
 =?utf-8?B?aVFrTCs0ekhKQVJrSldWbnZCNDZrYTRqRE83YTVkdVNFYVdjNDRBMnZmNTdE?=
 =?utf-8?B?dGh5d05pYVllVWpvRWFnbmZBcUtvWnRHaWt6U0dRY3JBQlRNak9xaUxBQ3A1?=
 =?utf-8?B?Vk1tbW1Ma3YxQUhCdk0rTU1TTS9xbXcxYS9TSVBNOEFoTURxYmFDMlRkcTlk?=
 =?utf-8?B?NFFDRmszUUQrNHgzVFRZQmFnb2ZzNTM5QWVTSTJLM3prNVAyWFlBUldnaUth?=
 =?utf-8?B?ME1Nbjd5eEJzNWNoTUJIL3hpeVhCVjZjRGx6M1Y2S2k2N2o0WSt2WnR6YWZv?=
 =?utf-8?B?L1lpQmt3V0g1NXJ2QjIxTnhTV0NxcnM1THgraFZRRnNONHB6a2FxUC9RUlhV?=
 =?utf-8?B?NXd3SnhoMEdFVFhhUjZmZlNtd3RvK1kwYjZiZHZIRmMrL1pKREg0TkRSMGZM?=
 =?utf-8?B?VXlyNkkxTWpLbUZNSUJDMnVacHpSWGg4dWJKU2tJcDRjQTFMSHFFSHRVY0dB?=
 =?utf-8?B?Rm12b0ZnU05pakpPaThReDgwbi9UdjB2K1dlZytOUFdycUpIUFZqcHNnYm8w?=
 =?utf-8?B?dm1iWjlZVzhqck03VTI5WVpoY0hUQWs3UE5aVGpDd0pFbHR3a0JqNlZmRGFk?=
 =?utf-8?B?RVFRdUxJbTFsTTl0TG1mclRxTzdtd0J5d3VPSVlMWENoN2EvRkx5TEtsQWpY?=
 =?utf-8?B?RjF2dEdudnJ1VkpkVnR1b0V6OW1XVDN5RDVxWG1sNjRTQnFiL2NFQ1h5WGdw?=
 =?utf-8?B?b205QUZGR0Z4MzR0VDc2L0wzMTVJbTh5UHJmZDFZRU9WNThGaFV3RWl3WVVH?=
 =?utf-8?B?azc5YTk5dDRFTkZ0SUJmZzFVbzlmbDBhb2NnUWhobFpiY3U3S0FGUzRUSmNa?=
 =?utf-8?B?YlcyVXdnWnlaUTd3N3kxWldGQS9QMjk5OU5jdUJKUDRYUVAvK2FoYjdNck5p?=
 =?utf-8?B?d0cyNDF2UjVqQ1hwQjRYY0VLcWRYbXVyM2h0VmgxVGl5WXpGYy9oY3hkVzYr?=
 =?utf-8?B?T3hPamhzQzdVV2Qva0lTSGpTYUVTQ3JXcHMvckFDaFpEKzFIVDRSL0ltRHVa?=
 =?utf-8?B?MmNGcjBMTGtXS0Z3ZU9WYisyZFE1VEdoUzI0UWxuZmNjOU1vcWtZSFFENy8x?=
 =?utf-8?B?NUZ3YVhWbXVmaVJSb3lpT3JYUEtBdlBkSkEyTUY2YmVKSGIrbnIveFNLVEFH?=
 =?utf-8?B?WFhrc3A0K2JUQU5aNEVtc1hYaXc4R3JMdkppanJ2OWk2RjRrQWRTMFhzTE9Q?=
 =?utf-8?B?cm5OOWtwVlZZc2s4SmJ2NXRvNGNWWFdBSys1TmNoRlBPMjh4djBJcW1FbVda?=
 =?utf-8?B?YWxiZDFNR0dnZHVXenhOSzJpc2I5Q0ljbXZJNlh2dUhjTUNjWHM4Zk1KK1VG?=
 =?utf-8?B?Ty9XTnc5UDlVWWkxSkZHQ3dkMTI4NGdmTjM1MC83a3hHeXJvSGFxUWtGdFhG?=
 =?utf-8?B?VVNYRVBweTdiM3lFSE9UWDJDQUhNNS9xMzBScGxUcmYzV3ZaNlRYUEcvS2NH?=
 =?utf-8?B?eUlXTEtSUTJsQVNYeXpLaWR2V2o2L1BBVURXWGZ1d2l1b2xiMFlVUlIvMlBY?=
 =?utf-8?B?Y0s1bGFiaUw1VlVzb1dBeWRSYnp5VHdVSEo5STRuQlFrdmVDUm9nQkNaK2lH?=
 =?utf-8?B?MCtGTzFRaldROGszbFp0N1hBWmIxelhrWmg4M1F5RzhHTmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFFIYnNmSUFvNjRDcVdvblFvU1dqcDVyMHhvUXlqR2xZUktKUjVQT293dVd4?=
 =?utf-8?B?R1E4OVMxV1BnWVp3QzcveUltRDMvZjFqcE5xUzJ4ci9TdzhnU0FrcWFuZjB0?=
 =?utf-8?B?TzRONnZrclczbmRwZXA4RFB3RXRHTVgwbkRyR0xMdUw1WDBzK05iWk5HYlRi?=
 =?utf-8?B?cGdjL3U1YjhTY21hK2dzaWJjbVltc2Z6d2xHU1UvUlNTOGI4RjhmWWhocFds?=
 =?utf-8?B?dm9pMm5SWktUNVV0d0srMXVtcUxTMkR5U25RZG5rZGhWc2JDaHNKMmVzL01w?=
 =?utf-8?B?K0RGdnh2UXVPKzg1WTRDMnJMOGhzRkhVZW5BNjkwcVRTVUxyMklOOFUyb3B2?=
 =?utf-8?B?dis2YWpva3ArQTk0S01WWEJnRkg0T0hxeWowYU5IdVJuSEJTc3NkVmtYR0ZN?=
 =?utf-8?B?d1ZHdVkrZ2c5N0F4YTFuTmVNZ0VmaURITXNrcGlPemlzMklBVWtwWDJlTmZw?=
 =?utf-8?B?b0VLaE9pRlRoV0x3TUN4NWc3QzVNanRGOUZuSE5wLy9rbUdjUXIzV2dDTUhX?=
 =?utf-8?B?dXhzYWNPbS9MalExODlIUWhyZDQxNXdvN0tWOTY2eFhUTEJmL0FONlVodHNI?=
 =?utf-8?B?aHpVVE5BMHdtNUhPOFV0UW1VQy9PbmQ0cm5vdlQrOTl3amg2Rko0ZEp4Q0ZB?=
 =?utf-8?B?MlhRZkROVkF5YzFjS3ZjYmxkSmlYcE1nd2huSmNjSUNESUdiWml6WXBBYXRt?=
 =?utf-8?B?OW4xdWxjU1d6S3VYWFduN2RQZExtcjlvcnZvbm9nQVRRVER2YzdwZHFhM1gr?=
 =?utf-8?B?c2xSVzJFZkJ1Y3BidnF5emNIOUFaUVhMZ0ZhZjBMWnBkWU41UzM2ek91d0x1?=
 =?utf-8?B?Z3NwTmZIdXduSEJqME9NSGxUVE1lZXdLYytxdk9HM1NUTS94TUN1aVpjN2pL?=
 =?utf-8?B?ZWVTZ0F2a3psZ0FIL0N6YkMzOTJGcW5rVFNPT1NIQ3ZHRkJMYzR3TU9vaVpZ?=
 =?utf-8?B?NGE3VFYxNGVTeWVKdzV0ZFJ0L2VmdjUvYVVJMGwxamlEOWUyTmpZS3RndXF2?=
 =?utf-8?B?MlZHVzRPZUIvS2pNQVZ5SlVzRjhFdkNrMWkyOFlmaWpESGd2MzhyM2NuVTVo?=
 =?utf-8?B?QWcxOW9QOG1xRWlLTTUwTVRzbkh2TFV0Y0kwQmVQR0tEWXlYSkNXOTNCU0tT?=
 =?utf-8?B?bnBscmVoMUhpTmVKRk5nWmtaZnFtelVmblZnYXdHZ2ZXa3BzUmR3bWd4UVA4?=
 =?utf-8?B?REwySXpoL2VCNDFkN1oweXdMVDY4cnoxNkhNZTV3dlRhVG1BOGRJWXZJY1Ny?=
 =?utf-8?B?OWQydUV1TmJDc2wrUGFJMXBCUGZTREhuVGJiY2hUbGtuQkNpMkl1R2JLYTZk?=
 =?utf-8?B?eEVvaGZCWGg4WlE3Y29aMmhXL2JkTm9pa3pPQzgvbEdhSzhRSGkvNHZOS25r?=
 =?utf-8?B?dHJ2dG9HL2RxWGI4ZFFuYUtjdXU0bDJkVGdPM2ExdmV2L1l2cXhBRWZ2SEcv?=
 =?utf-8?B?OE5vdm5IR0psU2VWVkw0UXhqbXZYT0xLSCs1L1BGQzlRTUIzaXRqenV1ODNt?=
 =?utf-8?B?ZXArN1RKcmM0ZFRDM3BkalUraTJNcHlwNWJZcUIrZGJYZytlaUV3QWZOa2l2?=
 =?utf-8?B?WitBMEtZL29FRFNFZVZIOVg3MEg3MTBGdTBjTDB1cnpObkpNc3dJL1FTT29N?=
 =?utf-8?B?SkRhbVp1aks0MHlWdTgzMWhIZFN4dkU2RTJTZldOazF2d0RMUGdBTFZWdEVs?=
 =?utf-8?B?TXlSdjRDcXdXYjcvcngvTFRFaCtsUlFXaWxpRXpTMVR6ZWNTV0pjb0hLcU90?=
 =?utf-8?B?NWlLZnhQTHFIZytRTXFGek13MUNNZGFqdXJjTlkxemk0VFVkYjRHLzI1d240?=
 =?utf-8?B?Q05WUnpQYTZEMVRSNDBzdjNEM0pIdzRMaE5LNWpCZE5WYmFzdnBDeGxpVU14?=
 =?utf-8?B?dWtsOXozTmU1Mkl1MjYvYjBPQUtzTXlmM2Qzc2swUElVNGQwWnBHaDRKakFJ?=
 =?utf-8?B?Q2xKTGx6UGh4cVd3NEp2RTREMnhOaksxU05HZERPbGNLdEV3RURLZXlvQVE2?=
 =?utf-8?B?SWNxZW54eEVyRVVtT0pHZFVBVS9XTG9Qb1dNZXRGM0s0Y3lSU3V2TDkyVHZi?=
 =?utf-8?B?amovVXU2bWRKS3ZLREprQzBwY2Z0VEphOXlwcERuVGN5aEg2STMxcjlNNkdt?=
 =?utf-8?B?aFRQNGFwZURnYTVRM1NmdXBqbUh0Q29haytRNnEyT2h6N0VEZHB1ajlZSXYv?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BDB01DCE39F254E93D3C2FFA69CC78D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a805eeb-62dc-41ad-5eea-08dcc26c214d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2024 05:34:45.0687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OqPUciT58drZ1c6E7a1zsrkBDzuyRx0dyMa78EDOhjAI/MSNQbJ+bsqoYIq83FXJCderhtsJlohn6GoNhKHyHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7839
X-MTK: N

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDExOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW50cm9kdWNlIGEgbG9jYWwgdmFyaWFibGUgZm9yIHRoZSBleHBy
ZXNzaW9uIGhiYS0+YWN0aXZlX3VpY19jbWQuDQo+IFJlbW92ZSBzdXBlcmZsdW91cyBwYXJlbnRo
ZXNlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBh
Y20ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAyMSArKysrKysr
KysrLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxMSBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCAwZGQyNjA1OWY1ZDcuLmQwYWU2
ZTUwYmVjYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysg
Yi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC01NDY0LDMxICs1NDY0LDMwIEBAIHN0
YXRpYyBib29sDQo+IHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZXJyb3Ioc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gIHN0YXRpYyBpcnFyZXR1cm5fdCB1ZnNoY2RfdWljX2NtZF9jb21wbChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhLCB1MzINCj4gaW50cl9zdGF0dXMpDQo+ICB7DQo+ICAJaXJxcmV0dXJuX3Qg
cmV0dmFsID0gSVJRX05PTkU7DQo+ICsJc3RydWN0IHVpY19jb21tYW5kICpjbWQ7DQo+ICANCj4g
IAlzcGluX2xvY2soaGJhLT5ob3N0LT5ob3N0X2xvY2spOw0KPiArCWNtZCA9IGhiYS0+YWN0aXZl
X3VpY19jbWQ7DQo+ICAJaWYgKHVmc2hjZF9pc19hdXRvX2hpYmVybjhfZXJyb3IoaGJhLCBpbnRy
X3N0YXR1cykpDQo+ICAJCWhiYS0+ZXJyb3JzIHw9IChVRlNIQ0RfVUlDX0hJQkVSTjhfTUFTSyAm
IGludHJfc3RhdHVzKTsNCj4gIA0KPiAtCWlmICgoaW50cl9zdGF0dXMgJiBVSUNfQ09NTUFORF9D
T01QTCkgJiYgaGJhLT5hY3RpdmVfdWljX2NtZCkgew0KPiAtCQloYmEtPmFjdGl2ZV91aWNfY21k
LT5hcmd1bWVudDIgfD0NCj4gLQkJCXVmc2hjZF9nZXRfdWljX2NtZF9yZXN1bHQoaGJhKTsNCj4g
LQkJaGJhLT5hY3RpdmVfdWljX2NtZC0+YXJndW1lbnQzID0NCj4gLQkJCXVmc2hjZF9nZXRfZG1l
X2F0dHJfdmFsKGhiYSk7DQo+ICsJaWYgKGludHJfc3RhdHVzICYgVUlDX0NPTU1BTkRfQ09NUEwg
JiYgY21kKSB7DQo+IA0KDQpIaSBCYXJ0LA0KDQppbiBDIGxhbmd1YWdlLCB3aGVuIGNvbmRpdGlv
bmFsIGV4cHJlc3Npb25zIGJlY29tZSBjb21wbGV4LCANCnVzaW5nIHBhcmVudGhlc2VzIGNhbiBo
ZWxwIGltcHJvdmUgdGhlIHJlYWRhYmlsaXR5IG9mIHRoZSANCmNvZGUgYW5kIGNsZWFybHkgc3Bl
Y2lmeSB0aGUgcHJlY2VkZW5jZSBvZiBvcGVyYXRvcnMuIA0KVGhpcyBpcyB2ZXJ5IGltcG9ydGFu
dCBiZWNhdXNlIGRpZmZlcmVudCBvcGVyYXRvcnMsIA0Kc3VjaCBhcyBsb2dpY2FsIG9wZXJhdG9y
cyAmJiBhbmQgfHwsIGNvbXBhcmlzb24gb3BlcmF0b3JzIA0KPT0sICE9LCA8LCA+LCBldGMuLCBo
YXZlIGRpZmZlcmVudCBsZXZlbHMgb2YgcHJlY2VkZW5jZS4gDQpXaXRob3V0IHVzaW5nIHBhcmVu
dGhlc2VzIHRvIGNsYXJpZnksICBpdCBjb3VsZCBsZWFkIHRvIA0KdW5leHBlY3RlZCByZXN1bHRz
Lg0KDQpGb3IgZXhhbXBsZSwgY29uc2lkZXIgdGhlIGZvbGxvd2luZyBjb21wbGV4IGNvbmRpdGlv
bmFsIGV4cHJlc3Npb246DQoNCmlmIChhID09IGIgJiYgYyA+IGQgfHwgZSA8IGYgJiYgZyAhPSBo
KQ0KDQpXaGlsZSB0aGlzIGNvbmRpdGlvbmFsIGV4cHJlc3Npb24gaXMgdmFsaWQsIGl0cyBvcmRl
ciBvZiANCm9wZXJhdGlvbnMgbWlnaHQgbm90IGJlIGltbWVkaWF0ZWx5IGNsZWFyLiBVc2luZyBw
YXJlbnRoZXNlcyANCmNhbiBoZWxwIG90aGVycyByZWFkaW5nIHRoZSBjb2RlIChpbmNsdWRpbmcg
eW91ciBmdXR1cmUgc2VsZikgDQp0byB1bmRlcnN0YW5kIHlvdXIgaW50ZW50IG1vcmUgZWFzaWx5
Og0KDQppZiAoKGEgPT0gYiAmJiBjID4gZCkgfHwgKGUgPCBmICYmIGcgIT0gaCkpDQoNCkluIHRo
aXMgZXhhbXBsZSwgdGhlIHBhcmVudGhlc2VzIGNsZWFybHkgaW5kaWNhdGUgdGhhdCB0aGUgDQom
JiBvcGVyYXRpb25zIGFyZSB0byBiZSBldmFsdWF0ZWQgZmlyc3QsIGZvbGxvd2VkIGJ5IHRoZSB8
fCANCm9wZXJhdGlvbi4gVGhpcyBhdm9pZHMgY29uZnVzaW9uIGNhdXNlZCBieSBvcGVyYXRvciBw
cmVjZWRlbmNlIA0KYW5kIG1ha2VzIHRoZSBsb2dpYyBvZiB0aGUgY29kZSBtb3JlIGV4cGxpY2l0
LiBUaGVyZWZvcmUsIA0KaXQgaXMgYSBnb29kIHByYWN0aWNlIHRvIHVzZSBwYXJlbnRoZXNlcyB3
aGVuIGRlYWxpbmcgd2l0aCANCmNvbXBsZXggY29uZGl0aW9uYWwgZXhwcmVzc2lvbnMuDQoNClRo
YW5rcy4NClBldGVyDQoNCg0KDQo+ICsJCWNtZC0+YXJndW1lbnQyIHw9IHVmc2hjZF9nZXRfdWlj
X2NtZF9yZXN1bHQoaGJhKTsNCj4gKwkJY21kLT5hcmd1bWVudDMgPSB1ZnNoY2RfZ2V0X2RtZV9h
dHRyX3ZhbChoYmEpOw0KPiAgCQlpZiAoIWhiYS0+dWljX2FzeW5jX2RvbmUpDQo+IC0JCQloYmEt
PmFjdGl2ZV91aWNfY21kLT5jbWRfYWN0aXZlID0gMDsNCj4gLQkJY29tcGxldGUoJmhiYS0+YWN0
aXZlX3VpY19jbWQtPmRvbmUpOw0KPiArCQkJY21kLT5jbWRfYWN0aXZlID0gMDsNCj4gKwkJY29t
cGxldGUoJmNtZC0+ZG9uZSk7DQo+ICAJCXJldHZhbCA9IElSUV9IQU5ETEVEOw0KPiAgCX0NCj4g
IA0KPiAtCWlmICgoaW50cl9zdGF0dXMgJiBVRlNIQ0RfVUlDX1BXUl9NQVNLKSAmJiBoYmEtPnVp
Y19hc3luY19kb25lKSANCj4gew0KPiAtCQloYmEtPmFjdGl2ZV91aWNfY21kLT5jbWRfYWN0aXZl
ID0gMDsNCj4gKwlpZiAoaW50cl9zdGF0dXMgJiBVRlNIQ0RfVUlDX1BXUl9NQVNLICYmIGhiYS0+
dWljX2FzeW5jX2RvbmUpIHsNCj4gKwkJY21kLT5jbWRfYWN0aXZlID0gMDsNCj4gIAkJY29tcGxl
dGUoaGJhLT51aWNfYXN5bmNfZG9uZSk7DQo+ICAJCXJldHZhbCA9IElSUV9IQU5ETEVEOw0KPiAg
CX0NCj4gIA0KPiAgCWlmIChyZXR2YWwgPT0gSVJRX0hBTkRMRUQpDQo+IC0JCXVmc2hjZF9hZGRf
dWljX2NvbW1hbmRfdHJhY2UoaGJhLCBoYmEtPmFjdGl2ZV91aWNfY21kLA0KPiAtCQkJCQkgICAg
IFVGU19DTURfQ09NUCk7DQo+ICsJCXVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCBj
bWQsIFVGU19DTURfQ09NUCk7DQo+ICAJc3Bpbl91bmxvY2soaGJhLT5ob3N0LT5ob3N0X2xvY2sp
Ow0KPiAgCXJldHVybiByZXR2YWw7DQo+ICB9DQo=
