Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098516A342
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901537; cv=fail; b=THnrVv9xKIloVntEkySUJScgXyMa9Bvobb7TJYFAbwpcsRSBYcJ/582a9fWmwdDyHzW6yaV+rDziZrhTudA03+uXJhKC18l948QDp9nF83c2X4WonHwiB4GBW/W4gSizoz4x/VyjcSNAs+nEFxDFy8+rzBCJyislvoydmWFzdxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901537; c=relaxed/simple;
	bh=qd+IXBXGpTlhwjkTOwlUYG+6sFj3WcYU5HUI1wRUjf4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qG04+WDWWXKC1H7RtTRuaKRhnmxgGeoXgNoy8hXTjISoZtpIgeQAWCqpc4KJmamSrSf46tpDdyt4LOVCtOwJYWn53B7XzzPrZ6Oa3+IQcLD0gAf4/jiKh/5SE2z62eD9T+aQSkIwY6GVxi6PG9Ld8E0pBjtWS6uayiIn4hIBu/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cxsyH+te; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tdnU6yig; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cxsyH+te";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tdnU6yig"
X-UUID: e143bf16383b11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qd+IXBXGpTlhwjkTOwlUYG+6sFj3WcYU5HUI1wRUjf4=;
	b=cxsyH+teMe/m/drjrkbLLfntLvxIyqAvzHKo1vjbVMqawkFrAeQ2vi98zqhyDpb/ji2Q2co4ewTJylnn2Cn86O/Af1T3yxCsJ+BaqlXFjGAvrtB4+U5w5VGQqHii93XkxF/J1J6dH1re6IzjWaJcRmX1MWdl8i6cs7t9xj1tdCg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:d2a4395a-c58d-4b16-9bd8-de7843bd60a1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:6e41f60c-46b0-425a-97d3-4623fe284021,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e143bf16383b11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 271554419; Tue, 02 Jul 2024 14:25:30 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 Jul 2024 14:25:28 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:25:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7FHlsE1NM9N956a2plhC3MyWCO7NAkth/qPFAE8Bsi9ndoN2WVuK2fXbTgYhPl3NFFulnvzzwiy/CjfEE2rJUDUyWQ3v6LO2NnU7uJPsKpTaxYb6xeY/CpnfIQE1POBwpLPSRX4WpMizgnPfgFGVyP6co8eBJ6x5V3B/6+BiAa9KgSWfsgQeFGyj1SudTULWA7vGD1zx8IWKvu2ZcB+7tsuKUjPRD5LwfUD3q/XK4631KmAMUJ6+wQI0pqbkLG9MfKV6VZsYsNPbB8JKALd4qLT1TmUPGg9hiMQTzFYbdhKoghu0rbo/62ocGabPRpFagwuercdkRkVefGsGkpB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qd+IXBXGpTlhwjkTOwlUYG+6sFj3WcYU5HUI1wRUjf4=;
 b=SOOhj/fWUtVlcKdroLNkC+oHoijejO+TXWUpQe0C59ZriDbD3UsLwyXHKG90spyvK327Jcw1+0AllVr9vcoXkW2o+TqqVS+z37pr7ye59DC7Fj0G+DBTKcZGEidtlz/rOqpTE/sx6ejEk2mrdKfZ3EVJ0Bb5HwIEk/+LuSA4VB2NrVGkcbDb8gepohLo7CEYplS5MAfpyaOMmPz1sTgoOcD+jUurmcY3cfPD0yjSFr0A53u1wxloVWwrgz0HXUiN2qsvCV6K7J7qc7U2JPZCndVEWSebAF9bpafC+4KYmBit2hEE8ak63JYel8joT8bKgoj5GCi1vGkJ10G3o64wVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd+IXBXGpTlhwjkTOwlUYG+6sFj3WcYU5HUI1wRUjf4=;
 b=tdnU6yigJxoJhbQsNHIGHF5CUMDexLcl37b/v96avxVWfXjniXvrhg61XuywxtRdPPsJL4UODL3Zmnk8kiTkac+Jp5uuUxIHOvsio5BQGq9EGI0YXuHwWR2AkFB4CzkYxaCFSLi8OWZJUHhqVEk5RmV7YcaxadVpxy/4jR7+I4g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7708.apcprd03.prod.outlook.com (2603:1096:400:432::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 06:25:26 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:25:26 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v3 5/7] scsi: ufs: Initialize hba->reserved_slot earlier
Thread-Topic: [PATCH v3 5/7] scsi: ufs: Initialize hba->reserved_slot earlier
Thread-Index: AQHay+E+7QmtfwQxsEae7/521a4oIrHi+XyA
Date: Tue, 2 Jul 2024 06:25:26 +0000
Message-ID: <c1c8bf50958118606dc0ce15e1f36732da54251e.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-6-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-6-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7708:EE_
x-ms-office365-filtering-correlation-id: b4a36e14-f7e0-4929-6d42-08dc9a5fc338
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SHJraVZWOEdIVHhReEVpL05BblF4TmYwb3VIdFlJRGJYRW84U2ZGMGo3aVlq?=
 =?utf-8?B?MmV5dHBpZGxBcWhtRnhYZUJuNnN3cTd4dXJFV2RYWFdSbHB2eGJGdkMxYkNp?=
 =?utf-8?B?VUo0cFVkZVNkSWNvTmsrbGdObVAvM2JjVWVSN09sUGVxcXVDOC8xL2cvRDFF?=
 =?utf-8?B?WTVWREEvZVBIU1QzODVidE9QbTYvQUVpNXZBMWx4N0g4R1M4NDR4OXRocUNy?=
 =?utf-8?B?WEU2NnQ4RklsNXBNcEJRSTdFZWpORmVuMHhFTkgyRGtuekhUdkxETDFHdFVl?=
 =?utf-8?B?VmllWXZHK2kvYnVZRlJMTi9DM0p5K3R5WUR4SjYvOGJWcVhNVTlIMnhSUnA2?=
 =?utf-8?B?VXlVOWJ0UFAyMjY0eGZOSzN4dzlFZWRNTStYM2hyTG5VNFZNOVRTMllNYU5D?=
 =?utf-8?B?WHJiNzlqN002cjFWMnZNK3c4V3IvaXdydm5uRFRSYks3YTdRNjk4UThmQVhU?=
 =?utf-8?B?bERWbnY1N0lyRG1aVUlNbURoems2QnpabXpkTkpmSzFwbDNsZTVYNHdieEtu?=
 =?utf-8?B?Q04zcU9sTDlRekluVlZ5SWdiYWlKenVHV2VjKzlJRXBVS2NRNEVsRFJIVnl3?=
 =?utf-8?B?eHZzd1JTL1dLdnBzUVlvM3lyMDU5MzJDTkFnQ3ZucGJSd09OU3V3L25RdnZL?=
 =?utf-8?B?M2tYZG9tYlp6M2ZCTlJUb0RmQzc4eWZhNDZrYk45UzRjeVQ4Y1hFeDY3MXpu?=
 =?utf-8?B?eVRweXlKREw2VFhIWW9scjA1ZURTNXo2Sk4xTnJyWXE4Q2cwSDFRTDdiblRL?=
 =?utf-8?B?ZHRVVUlJcnhROHV4NVE3ZmYwdXgwKzJ2cFZEdkVKMStpQ091bVBod3BIZmM0?=
 =?utf-8?B?UzFMbDBNZlYzWG5zd1pIRFB1SnhZWHQwcmpCdGVLRkcwblB6MnRhZW80V2d0?=
 =?utf-8?B?R2FoOUhPZ3VTb0h2enlzY0FwaE1EKytvOEk5N1UwQlQ0MXdVQzRjZ2ZqSkFv?=
 =?utf-8?B?dGw0S3BCS0NFckRTUlJ5emp1RHFJK2h3SSszczBNZzIwbVdSQTlsRXczV3Vo?=
 =?utf-8?B?MUowU0tXWDQ4c2Y3UzVPMDhGVUVsNFF5bEdwMEp5bEVkQzk0ZGQrUDBjZW40?=
 =?utf-8?B?NitjYXFwa0hobHFTWnJOcGZnaUdVMGVLZ0M3cXdQeStZZmtqMmhaNjV1Mkxw?=
 =?utf-8?B?dDhJZU1uSmJyS1lJVzlvQmF0ZzIxQkRHS01QTW1veXE3UkVweFhEeVB4Rk1B?=
 =?utf-8?B?YXdhYU5Rcm5UemxnNjhjbHUwc1RZMjlhMndnTm9QWmJDMXdpVlJxZ2JhYkFx?=
 =?utf-8?B?NWZjR2xDN0RyYU1aRjdiWS9kYUtHL3dhWmZacHpGYU5nVWpvTDQ1S2ZlQmIr?=
 =?utf-8?B?bUZCOEFOZ20rWEFJUmpzaTRNZWlPVmZXRFpiRzgwR0RqV2JZK2k0eGxhUWFQ?=
 =?utf-8?B?RlJoa3ROU2ZIekE4ME9CUEhNVUQrTWxweHowV09BSm9wUngzTGZrekFMQUdp?=
 =?utf-8?B?UnNzTUlzbjdBU3NtOVlVQ1RSMWZoNVFZZHRmdFdoblV3NkgwVmlWaEhBTXpM?=
 =?utf-8?B?N0JwMCtBYXM0b2JqQ3hKeDFtYk5GQVF0dUFLS3ZwNkFHcXhHNjltWGxucXdx?=
 =?utf-8?B?a1VRVlY1VG1hcHB3eUlEb21tQTkxdXdqRGVraGRhdDNYcW9qSWRMMU5LellW?=
 =?utf-8?B?Ui9MNHlZc1RBQVJwUnM2c1pLVllydG1LYkNkcTJvZjlNekFhYkU3NDI0Zjll?=
 =?utf-8?B?QUEwenFma3dWS25nSUpHbHVSQk5tanVKL25FL0UvMklFL2JMczFaWXNUblVQ?=
 =?utf-8?B?anpsUnU1aDVQN3p2TVN0dERiV0VtM1RaUSttK041QnFmSy9mYnNPeFdHUi9W?=
 =?utf-8?B?eFFybVpaYWFDQ1dRblNUankweTNadGtSN3R6SlVuZU83Q204SmJIcjM4L1o0?=
 =?utf-8?B?TmFDMmtnZkE0cERZdVBQTy9Sd1ZNMGpXZmRMQ1UrYlM2c1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXBkemxxd09ock51amNnd3UzUzNpMHoraGlaR3hVbWVaS05iYzYrMTBKYVdT?=
 =?utf-8?B?WnBQR3VQVjBSQVFmSnV0bWkzZ1dXRGpsZDVwelpOOTR2T0J0VWNjNENlR3Bo?=
 =?utf-8?B?TEVKV2JuNURhbE5ReThtRGNTZTF2RDE4SUd4WnE0aTZmU3dSNkhFeWUyYjVE?=
 =?utf-8?B?WGJVSU9ySlRHWEpJWVplaXk1Qkc5YnBYTi9KZ1lGRVJMM3pVa0FnOStsV1N4?=
 =?utf-8?B?blI3aFptdmdDSVVSUzdtaGlvbCtxMS9OYkt5RmN2NkxPVFNOMFB2STY2MnZq?=
 =?utf-8?B?cUo5aEFLS2ZxS3Yxek9OMzJZMGx6QjBZYmY2UGJjNEYxcjNvTk9WdUZzT0Q4?=
 =?utf-8?B?RGVreE5ab0l0c3hTTE8zaWhRMC9yeXB1ODZDS2k3WVNTdGdFbzVYUkI5NFNR?=
 =?utf-8?B?MGhINXZZVk5OVVNpbzZVTUhMenBsci96Z1J4SEtZVmJlRTNPUmhYVGNzWXh3?=
 =?utf-8?B?UWRTSWRVM0U5MWJ1YmJWQnI5ZjYzTzZidUNQSGh6aWpGUmZhbEE0M2NidkN1?=
 =?utf-8?B?M2h3WjEwb0kvLzFJK1RnMHdwUDBRVWFwZHJ0SDJwaWV5Z1BUTFovNVdYdjRp?=
 =?utf-8?B?d0x1RE5lQjl4THVMVGhmb3BDN1dTSGp2ci9UWm9KYTVvNVpQekZ1YUFva2ZQ?=
 =?utf-8?B?TzByQzMvT3MzOWtlblFhQzRSRFRYVDQzb1F5dW1YcjE3Nk5taVVhRG0rNXJI?=
 =?utf-8?B?dHdjTWtPa2tNVHZmazdoU0dqTnEvcGVoK0s5VHh2cXVnektTUmczNk9ncXM2?=
 =?utf-8?B?RjZRdmFmN1JpVVUzQTc3QVI0eUtlcE5KQmV6MTE1UG80cWNIUDJLRmVXSzhF?=
 =?utf-8?B?N2RyN2FMTUJQeFZsbjRKVmp6QWhBZ21XakoycEdGMnIwR04xOU12dmt6aGN6?=
 =?utf-8?B?UVNnbnJnU0xrbHVVdy9NSE5yUkhIMzdRQUZRS0haZHNBWCt0ZVdwaHRUbGd1?=
 =?utf-8?B?RWpDbTZYelJPMm1RRlB0YzhiTWt2bTgvYVUybzlwM1FuZldPKzducDZIc1dY?=
 =?utf-8?B?a2VwZGVMV0R5ZHZQYngxc0V3dEdiM0lhdVZZQzhQUUhhQVpZQW9QZVY5U1Av?=
 =?utf-8?B?dTlXdHdONVlQbDdGa05rdEE4ZDlhMUJMZzEvdUhMREVzUDRjVFJSaEt6OWhw?=
 =?utf-8?B?L1hwcG9iZi9Ib2UvSU1xcW4rb3UzRjJId3pOLzc0ems0SmN2SG5mTzhLdG5t?=
 =?utf-8?B?MnJRbUNwSFJ0ZHBOTWl5TXRyTXhOWFJTamZXRTJOMSs4dzd3OXBxVlhxeFpj?=
 =?utf-8?B?MFJPUEgxUGF6NnlWK1MrcW5wTFNNNUtPQkY4eC9SL09aTFZEdTV4ZXUyOFVw?=
 =?utf-8?B?ZkQ3aHU3T3FsU09vOGM2N3AzTUV3ZzF6YmVVaTNFbERpU2Q1bE9wZ1Vkb0tI?=
 =?utf-8?B?Y0Z3dlRpUURuTUpiL3ZGeE00UHk3ajRwTlh3WHhQK0tjcEIvTFY0d0dZVU01?=
 =?utf-8?B?emNndy9ydkRNMGUvTTRWT09XNkFEOUw5eGNXdHQzR2F4aUd3eUwrTklYWW5E?=
 =?utf-8?B?bEhBbG0zcTQrYVBxQVpuV3BKdWQrK2FvMWtHdG9PRU5WdFdJQ3ZHaDZBVnNK?=
 =?utf-8?B?ZmVFeVdpNXoxd002UGE3RkZ0S0lGck1FQ3BDdlplM1Z2cVVoK09FaHlSbmJu?=
 =?utf-8?B?K0liTEdyYXhRdWJEQXQ5MXRYa0l2QXdPaWI3djRWNXlHbnZHYlZMWDZ5cVdH?=
 =?utf-8?B?WVhYbXRyaCtOTkh4YjQ3VG9xc1ExVFJaRjltdVpJSE9JdDJrTld1bU1vcXhH?=
 =?utf-8?B?aGZvVUsyREJHM3R5Q21Zc0xsYjNSTWJ2UnRnV0Q1ODRxUUpLOEh5R0h0RnA1?=
 =?utf-8?B?TzVSY2lRWUhwZWVZc3BJOVlBaldlZlZSSkVOUEVkamhWYU5LQTcwVEF2V0Vz?=
 =?utf-8?B?QXZsVUJpMGVPQ25ueVhraFBwa0NvSGU3S2hsYkE5Y011bXE2bjBWeitBT05N?=
 =?utf-8?B?aTFTaWRyUFpxVGVRcTZNazFlbUlEeHd5NkhUYlpEMWwvZ2pKZlk2eUFZdVBQ?=
 =?utf-8?B?RnZReG91TUJRUnc4WVY4aGtJOGdveGVSVTdEcmRJdmV1Y29jMFRaRHVsMWtW?=
 =?utf-8?B?NGZnanJlSmJxZ21RR1pVTjdldGVPTVpSb0tvOGtLMUY3MG1ZWmx0UXBJKzlP?=
 =?utf-8?B?eXZVN1ZXb0xYRmVybTBFN0p1UE1HQkFiRHRsaE1FdGVUVmJ2aEtsQ0g5RUpB?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18EDC39D5962124BA93DA110E763374F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a36e14-f7e0-4929-6d42-08dc9a5fc338
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:25:26.7206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EE+wyvwdcBjhh5Hj5n+BMRHtnv84u+WZkNfmeWXpz3MoL6iKEUtP3E534qov0osp841kMOJ1XgU+dKQXjTfgjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7708
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--18.633600-8.000000
X-TMASE-MatchedRID: F7tLedRt7ifUL3YCMmnG4n1zro62qhdC+WzVGPiSY8iNxnMeHrmB78kU
	hKWc+gwPyGJ1SiZNgOOsXAiB6VK48AbbLE2rYg/9wvqOGBrge3shmbYg1ZcOnpgWnaLDiGghCKh
	uU3rY4TB45xrTOnbTlASaXduTTrxLXF+ghSx47zPISPeZE8elXmjdirk8LAsCOGCgDN6EbfZdHL
	0OBPA3VGVGaPxFYgIXkZOl7WKIImrS77Co4bNJXZaWKijZlsbB2bNx1HEv7HAqtq5d3cxkNQP90
	fJP9eHt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.633600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	CD32F39C1BC831BA41BB57165027325775116FB8B631F9F2EF0A48A1D5E2FDE62000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTW92ZSB0aGUgaGJhLT5yZXNlcnZlZF9zbG90IGFuZCB0aGUgaG9z
dC0+Y2FuX3F1ZXVlIGFzc2lnbm1lbnRzIGZyb20NCj4gdWZzaGNkX2NvbmZpZ19tY3EoKSBpbnRv
IHVmc2hjZF9hbGxvY19tY3EoKS4gVGhlIGFkdmFudGFnZXMgb2YgdGhpcw0KPiBjaGFuZ2UgYXJl
IGFzIGZvbGxvd3M6DQo+IC0gSXQgYmVjb21lcyBlYXNpZXIgdG8gdmVyaWZ5IHRoYXQgdGhlc2Ug
dHdvIHBhcmFtZXRlcnMgYXJlIHVwZGF0ZWQNCj4gICBpZiBoYmEtPm51dHJzIGlzIHVwZGF0ZWQu
DQo+IC0gSXQgcHJldmVudHMgdW5uZWNlc3NhcnkgYXNzaWdubWVudHMgdG8gdGhlc2UgdHdvIHBh
cmFtZXRlcnMuIFdoaWxlDQo+ICAgdWZzaGNkX2NvbmZpZ19tY3EoKSBpcyBjYWxsZWQgZHVyaW5n
IGhvc3QgcmVzZXQsIHVmc2hjZF9hbGxvY19tY3EoKQ0KPiAgIGlzIG5vdC4NCj4gDQo+IENjOiBD
YW4gR3VvIDxxdWljX2NhbmdAcXVpY2luYy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFu
IEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gDQoNClJldmlld2VkLWJ5OiBQ
ZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
