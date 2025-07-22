Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F572D3A7C
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 07:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169027; cv=fail; b=ECYpyufcX/JRx2ouAPZEZveQrJaUmV60WTUtYaBZC4dbvsqeZlPIiJrZYtkqJFzhiGd4d8x2rltW8Oi3Mc/XVlamCrV6qgGG9LxNaEHZyzdUsATTb301/u30y2iKEze/0+9ZFHu5PebFg5fTxDO5cI7S22X3JiZVV8iyoWDfdg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169027; c=relaxed/simple;
	bh=EtpCgxVqG6E/xcBcgoTNNGGSNEEj6uD/0OWeBhpKrNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iYXT4Xjum40K9PESH/cnlQBnC1Bd7WclpAo+R3iJvNAokosYPtD2M8ql2E1QhjSWzWKe6HRUdirW9vo2TspaSbRMU4CfDNPle3WrokYl3OiezoyEgfvdh4/XjZivfb3apQWqIf2CKRbIxbEceRBNf7ri+x2q2Q0CkChh8Knwth8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AsJCPzLi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=G2y4EIPo; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AsJCPzLi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="G2y4EIPo"
X-UUID: ca6a9c2c66cc11f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=EtpCgxVqG6E/xcBcgoTNNGGSNEEj6uD/0OWeBhpKrNU=;
	b=AsJCPzLi8xRTsRUHA9vD9hMBQaZqvxJOBUm8gaQoYlRyEKqCe1P4+Yjj1nqzi2VlX+urpYBS2KQTF7ksjLZ1Mhvgrbg56A0RhIKbFnXd6fwiNq6VAuP09sLdZAEMYKC5+bx0kEi9bdd1WSjgyhCpwVqeIDeKq3ipZUly5orLfJY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:56f93bdc-96c3-4283-be5d-761797c6ef5c,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:7c97239a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ca6a9c2c66cc11f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1296499051; Tue, 22 Jul 2025 15:23:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 15:23:39 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 15:23:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dloq7yh6Hgg1y1aylWnb+m1mDA3m8ZoscE9thTiNdyiH70i3CUF9uBh7wH+7AZFMWmC65tGuPSVIx+4rENrt7DqxYnrRETlgwc0E8DI4ndzsa2Pfs4EzUbIE0cytuOh/LXdpkFEpgZM1PckAhdJR0PWZcory6vc797LWMesSXF8o5uWMJIPuUF6JHa8riO/xiNkAsxKilGvKHeQ1t0VwBKwJ8xdqa68F6sZXehZB9S5H1wHx/M3DSDKp3qW8dW706bgRJW2J5S1xPTf/rCF/TJoocEpKKhK+4oi3c1+pCtqIuCQR6gUEDrCgsX8livrb4cxOcAVvLSthlHwgWDX+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtpCgxVqG6E/xcBcgoTNNGGSNEEj6uD/0OWeBhpKrNU=;
 b=Vv3Utgz68bJPfayaXHbDmTLDRZfTCKGlLpvo+pa0J380ye5LaD9Rbw6CVs8vg4AhE+jWpg/MXc1w/9WT2OfcaOGxE181v+vkrf4dyH8ljbJeTpesyUPFUokTmkvXWnsB+kLB3w9aatO3YT+94nl1JrzHeKmhMGoSAmLEk6pCWDzDevgHntdEb6deDFuaS5w7i3uevtSzQaWATYwN5c9Tr9jX1EylHSSzd4PLhMsqe1sHkN08UFqBRJA+tF7O/DXukyB/icy+VCFILJTo+wwjYaMI3SjLqyNGTYakXvQ5/wo/i2pRprkivNbeng7WosDr0Zb+bgqFPqY6q2tVyaWVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtpCgxVqG6E/xcBcgoTNNGGSNEEj6uD/0OWeBhpKrNU=;
 b=G2y4EIPoBaaKjL36NQBdp4uxgU/OMpnxFBUS9+e2HZwl8VEe3frdUTH4oG9GdP2LM9sncEjKsu0gfPTtmFy5Wd5QIcI8P21iyIb0hx+iKKzE5/9ZAJtLnDXBfDqicLtrXl9rJeUPxYjBm2uuOIGvzVbCDdLici8qIRnP0W/N2dk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8811.apcprd03.prod.outlook.com (2603:1096:990:a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.42; Tue, 22 Jul
 2025 07:23:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 07:23:36 +0000
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
Thread-Index: AQHb+om0sAcuxUwFzECYg9tHXZCQB7Q9vf6A
Date: Tue, 22 Jul 2025 07:23:36 +0000
Message-ID: <0c1022496d2eb5cbe0d86ae3c249e28adf6a9c94.camel@mediatek.com>
References: <20250721215055.2885241-1-bvanassche@acm.org>
In-Reply-To: <20250721215055.2885241-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8811:EE_
x-ms-office365-filtering-correlation-id: 1f484160-fbe8-4429-346c-08ddc8f0ac40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MlN1SFFNOVlBVThWekZNNHB0QUpxVHhKNW13TnYwaW1YMEo3dGVWdGVBamFE?=
 =?utf-8?B?d0ZzWHpZTEUvd1JnZEs5NlJzUkF5ZWdPS01VWm5heXVNSy9FYlNITUVIcHlZ?=
 =?utf-8?B?K1pNQ1dRQWVPRndBcTdiMk95bUlSRHBLelppL1pxY2RsWC94Y3hoMGdpVmFT?=
 =?utf-8?B?bE5KNnU3d3lwSVFacmVXajB0N1JpMFhxVFV6ZzN1SDF4VVJJZGZCZXUxRDdD?=
 =?utf-8?B?RE9IVzRQbzg4TkZnMXB5OTNMdVl2UFJiRGh0ZXVDVnBiZlRaaDFPanFiOSt5?=
 =?utf-8?B?ME4wWlRDVVYvVWZTYlE5SnBFUHpTU1VKV1pNMTF5M1oxN0NTWHpEalpyNEdy?=
 =?utf-8?B?UDlUaHZVeVFPaE01emFCbGE5cm9QOUVhcWt2aUZmeDd3L1lpWkhKTkFGMmVM?=
 =?utf-8?B?V2NCU3k2dk9NUXRUWFUwQ1cyb0R1aG1qMW91bGxlczJqd3hrZWZnVEN2RXJv?=
 =?utf-8?B?SUlGSmUrM2hzNjZvRlFqNVJDSHlUU1N3eldMUHlUSlpPR3RIQVlBbVJYcHVB?=
 =?utf-8?B?MFVIWDQrcVNvTzMzNERtb09DWjVXWURqUWtmbUFsQm1FU3pDUCs3YWZwaUQy?=
 =?utf-8?B?UkZMdGlYb2lnZWlneklpRkoxUU1hdExPRDFFY1BDU2Y4SWZ3bXpBUXhrbUpr?=
 =?utf-8?B?dU1jTkFON3NjT1Qxb3NvOTR3dkl5V2RHNmJnZ0ZUL09yZmhsOW02WGNIdWVS?=
 =?utf-8?B?UVpUc3JjQ0xJaDA4UmFTd1Zra29MU3ZPZ2ZXTkVMWlkxaEJHWk5LQlJ1emp5?=
 =?utf-8?B?UVE3aEh3SW12WE5PQWt6aTZrT3BZNUlQQjJYN1pBcXlLQlIyaXNVOENHNmdR?=
 =?utf-8?B?Nll6dlZxdWRVRjAvdTBiWm9rU3VKdDFQQmhGbnMybWdmSGRENWtndXhpQkg0?=
 =?utf-8?B?ZzRnbXBEa2VsSUJOZ3hNZ1ZMYk5Oellzb0hhdWliMFpCaUQza1FDU2gzWWtL?=
 =?utf-8?B?c3IxbzQycEZnREFBWTF3QWlnK0dhUUdNUzE5emM4QXBIbWQvSHNGc2ZGVGh2?=
 =?utf-8?B?NWhjVnJwZmVtRnpyL0tqcjgzNWxVUTREZnlVbjhIRUJsdE5hWml5MFQxb1Rs?=
 =?utf-8?B?V3FKMjcvQ3FkWUZ5aU96UHlxQjFZKzBhcU52Vy9zQUxBdVo1ZTdvOWJ3cC9Y?=
 =?utf-8?B?NWdwckF6U09vSjZFQUVKV2owaHEvclBjcnR1eGplNldTRkc3dFRxcklGdDZO?=
 =?utf-8?B?VGpRblR4QzlHMW54c0R4a1NoZXpXcmNzZEFFdW5Dc3dmRDV1UC9UVnNIcElG?=
 =?utf-8?B?ZS8vWHJUbW05M21oUEN1aVd2MFVYYlUya1crSEM1U1lzZzByV0tvUGwyZmZr?=
 =?utf-8?B?YXY3TnROUE9zZUprdmlRWjN1cWVTWEFzd0NaOVlXT2ZsR3hDQ0VBUUc0cVI3?=
 =?utf-8?B?VHNlOVErRC8vSVdrVkNXMWpod2NMQW9rTnpocXBsNGsxU3pIaFF5Q3Iyakpv?=
 =?utf-8?B?MEpScENac01qR3ZReGNwOGtETEZLODdzcGlaeEZLanE5cGFNbTlBYWYxd1Fw?=
 =?utf-8?B?VG56NWt4eUlwZmNiemdLUGlOdXRlemh6ell2WHd3cElQbzdOT3Y5a040QWdC?=
 =?utf-8?B?RzJGckErOThkV05qeHVReWhaTlQyR2VTRkpJQTMwYkR3dTNzdEFyTUFRa1FK?=
 =?utf-8?B?Z01EVFdIT1FyM0tPeUN4OURCNmpMWEpCRGJkVC9DOXNJN2xJU0ZhdEorRU51?=
 =?utf-8?B?NGtOQlpLZStNdEZzWnlFMTJ4alF1a2pSeUZ1MXc2RkZ2dmlEMG5BakV2bVQ0?=
 =?utf-8?B?V1FISjZkc2V2LzIyOGpaNFN3N0VwUGYxYUJpOWFWamNEc0pMNjUwZWdWUGRL?=
 =?utf-8?B?K1dZQ0hzNnNWRkRKNjR3aWk3VUhUQzJFYWlyTHNFanliWGJ2NkwvSDl6R3Iy?=
 =?utf-8?B?cE16RXREUUc3MnYzSFNJKzZMbU14aFp2RTB5d3ZOaUNXVThTaDdndVpxelpi?=
 =?utf-8?B?NGVmT0lFZ01WOWJWM1BpTjBHQlVBM01FeGp6clg2dWtuK1NsaVd4TUVjdEpw?=
 =?utf-8?B?dGRnQkc3SFhRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEh2SjcyUHNwQjB5WW5uSVRJRVdIMkFsNXp5MnkyQjlGNWtIVGszMU13T0ZM?=
 =?utf-8?B?YmJUbmdaa1RDMUNHbnk5NWk3R1VDOE5ZNytzanV2emFOVDhXN2FrWHNLRTBq?=
 =?utf-8?B?V1VuSWJqUnNXb0dUQnJ5ak0rd2RuL0sxMWVyUjVrTVUrdWN4RVZaZ1pFQkV4?=
 =?utf-8?B?YVVkaVhDcjhEbU1sUmJwR0x2cUVYbW55UDUxSG1rS05JYTJSNFZIS04yRDEy?=
 =?utf-8?B?U2hBQ3dpVVYyaDIyS0xPVXBiU0ljdHJ3ek9WdUd5SU9CQUtVSFAzWTJabEVs?=
 =?utf-8?B?QTFMeDRoZHNvS2pDOWpBbitWbzdrMlVlZnlmd2w2RTBRRkE0eVdEV1M4Vitm?=
 =?utf-8?B?WkxPZ2tsZldoYkpQeGFzNC9VOVFqRUhSY0ZnNTNnZkgyL0RZdUM4SGlVRFA5?=
 =?utf-8?B?Z1B3cGRRWjVhbVgzS01xOG0wSU4rSnBSRHFWZnJFOWtIWUtYKy9aOVlxQzRo?=
 =?utf-8?B?QWhFc1NzR012VnBaRVNhb251b3EyRFVKNUZuQTgycmpHRi8yVk10bTlWS1A1?=
 =?utf-8?B?SGhBUzhNK0lFcVFnZzN3cGFuS1UzNzFha1Z4ZlBpWW9SeGtnZUo4aEtuUzAz?=
 =?utf-8?B?d1ZXbkc4Zy9kVzkvVzFKMWZxbUIyRERlWU00ak5laE0rWktlc2pleGZ5VE1Y?=
 =?utf-8?B?TEhrM2kwaDlQMU1LcXdvY1FsQ3dpSldWclVvWTYybmdzRkxORTFpN1Zud1E5?=
 =?utf-8?B?YzdTZ25nUjNuc0NHbEpOLzNEaFdFbFZXVU9rdFJ2OVNaZ2dhR2psRUxKVThp?=
 =?utf-8?B?cjRCQVQrRTdGaFdDeDVqaDFESVlmTFF2ZzFjeEVpYkRYTkJhbnZocDV2YXVz?=
 =?utf-8?B?dXpZSXBhL2FqQTd6YkZVd3RVck9LM1poMGRMaXdSNlFzVDAzTzc5R2JpQmpU?=
 =?utf-8?B?aTZ3Sm9ud2NPeDZYaGtoNHdYeUorVno4bTl3TkNlUmozWlk4MHAvbkVRVHY0?=
 =?utf-8?B?K2pRWTZFYmNjV1ZHRFVNVEE4c0h0Mi8xWTFabWdEemtQNWxCS1FBZlpnaytL?=
 =?utf-8?B?TzlkcklBL3FHVGFiN1EwakNDWVk2bDRzVnhjU2t1K201Yk9abjVGZFNkeUND?=
 =?utf-8?B?QW4yNjVFdTcxZnNBTEZHQStldVdITnNBakZRaWU2R0FQSDRQeXJPMGNVV3Q2?=
 =?utf-8?B?S0RqUEs1b0FBZWxSNzNlL05sMnZ5TEhCSDRUcTd6WUIrdjEwa3EzMHRvbDRj?=
 =?utf-8?B?ODlWUnM1OTB4K0dXOUxaWDhtYlNhVlJybU83Q2RQZzVhOW9aUFFxSTZyZDU0?=
 =?utf-8?B?RysvbGZYaHRLL3pRUzEzU0NkS3lKd1Q4R1h6cy93b3JweFhHQ0g2OGN3V2Iz?=
 =?utf-8?B?TEF0V2RkYWRFSE9KSERJc1JBM0tjTU41MFZSQ2dHQlpPZlVZRmk3cGVhSjBw?=
 =?utf-8?B?ZTBWb1phMCs3UHhpc2NTRDAvL0I3ZmR3QnYwRHl2d2lXRWlPdFEyVjFmZGxv?=
 =?utf-8?B?bVh3NE40akhoZ0FMVk02VDd4THpNWlB5MjZlWXR6NnM4b1ZHcUtqQU9yR25I?=
 =?utf-8?B?eXQ3Y2pXNVJPZ3VNSVhKMnFwZ3ZQYm9iSmpFVGhKaUVIQzM0V0tRcE1xbmcx?=
 =?utf-8?B?K0tERjV5TXFBVVc2MTIvRkFqai9SLzdKU3NFSHBrMldET0l2dEs5eHZJV1gr?=
 =?utf-8?B?dHpkRjlaMXIyZ1VKZnFBNjlQVDYxMmFaUmVHd1kvMlhITGhmaXppWk40WFh0?=
 =?utf-8?B?SWU5OEMvaUZsZlJsTkJMN0JPOTBzcTI0SlErYndxYjFsZXpVcnBUV1NZZjVI?=
 =?utf-8?B?MG4vKzYyVmNKb1cwbjVzbTB2YVl0Y1dXQ25QUlZYc254Vks1VzVCUHBmb2dt?=
 =?utf-8?B?c2xrQkxQRHpYTlEzL0w4ODh5SExYY0JNZXpnNnp3SUN0ODJ2VjRXcWc1ZkQ5?=
 =?utf-8?B?ekRTNVlHNG9DOTJBSm5PMzNSdnVGcitqdkNGMDlCeUlBOGVXTjlyZG1FT08y?=
 =?utf-8?B?Nmp2ZStVcCt3NHdJQjdEZmk3aU02ZTg5czhabUJzb0VZL2ZJdWdZZGJSUjdj?=
 =?utf-8?B?ZmdhTyszZDBFTG1PWlBaVUJyeFd1OHlBMXVQclR6K01ISStNeDg2aGpUZWJO?=
 =?utf-8?B?cDh1U1BvalFBNVYrZ1RLVXFSOUFzRHMxR3Rvb3ZoeFZmR3R2ZnFCRzE1RWgw?=
 =?utf-8?B?VzIyQy80MG9FV3JxdWdxZkQzWDVoNzdnME00NXhJNWhJazd1TWQ5UEk0Y3Vh?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <854E4DD381516A409465D0122AB872F5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f484160-fbe8-4429-346c-08ddc8f0ac40
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 07:23:36.3892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: niMoF3YAu4aZs+LvO7y3Heqad3G0pj4zmmx4f1eqPK4GUBmuGHcHnJeyGNIxzYwjRCZgnc0bjwzs9oeBN3UPFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8811

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDE0OjUwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6DQo+IMKgUG9zc2li
bGUgaW50ZXJydXB0IHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOg0KPiANCj4gwqDCoMKgwqDCoMKg
IENQVTDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBDUFUxDQo+IMKgwqDC
oMKgwqDCoCAtLS0twqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLS0tLQ0K
PiDCoCBsb2NrKHNob3N0LT5ob3N0X2xvY2spOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbG9jYWxfaXJxX2Rpc2FibGUoKTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGxvY2soJmhiYS0+Y2xrX2dhdGluZy5sb2NrKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxvY2soc2hvc3QtPmhv
c3RfbG9jayk7DQo+IMKgIDxJbnRlcnJ1cHQ+DQo+IMKgwqDCoCBsb2NrKCZoYmEtPmNsa19nYXRp
bmcubG9jayk7DQo+IA0KPiDCoCoqKiBERUFETE9DSyAqKioNCj4gDQo+IDQgbG9ja3MgaGVsZCBi
eSBrd29ya2VyL3UyODowLzEyOg0KPiDCoCMwOiBmZmZmZmY4ODAwYWM2MTU4ICgod3FfY29tcGxl
dGlvbilhc3luYyl7Ky4rLn0tezA6MH0sIGF0Og0KPiBwcm9jZXNzX29uZV93b3JrKzB4MWJjLzB4
NjVjDQo+IMKgIzE6IGZmZmZmZmMwODVjOTNkNzAgKCh3b3JrX2NvbXBsZXRpb24pKCZlbnRyeS0+
d29yaykpeysuKy59LXswOjB9LA0KPiBhdDogcHJvY2Vzc19vbmVfd29yaysweDFlNC8weDY1Yw0K
PiDCoCMyOiBmZmZmZmY4ODFlMjljMGUwICgmc2hvc3QtPnNjYW5fbXV0ZXgpeysuKy59LXszOjN9
LCBhdDoNCj4gX19zY3NpX2FkZF9kZXZpY2UrMHg3NC8weDEyMA0KPiDCoCMzOiBmZmZmZmY4ODE5
NjBlYTAwICgmaHdxLT5jcV9sb2NrKXstLi4ufS17MjoyfSwgYXQ6DQo+IHVmc2hjZF9tY3FfcG9s
bF9jcWVfbG9jaysweDI4LzB4MTA0DQo+IA0KDQpIaSBCYXJ0LA0KDQpUaGlzIGt3b3JrZXIgaXMg
YWNxdWlyaW5nIGNxX2xvY2ssIG5vdCBob3N0X2xvY2s/DQoNCg0KPiBzdGFjayBiYWNrdHJhY2U6
DQo+IENQVTogNiBVSUQ6IDAgUElEOiAxMiBDb21tOiBrd29ya2VyL3UyODowIFRhaW50ZWQ6IEfC
oMKgwqDCoMKgwqDCoCBXwqANCj4gT0XCoMKgwqDCoMKgIDYuMTIuMzAtYW5kcm9pZDE2LTUtbWF5
YmUtZGlydHktNGsgIzENCj4gY2NkNDAyMGZlNDQ0YmRmNjI5ZWZjM2I4NmRmNmJlOTIwYjhkZjdk
MA0KPiBUYWludGVkOiBbV109V0FSTiwgW09dPU9PVF9NT0RVTEUsIFtFXT1VTlNJR05FRF9NT0RV
TEUNCj4gSGFyZHdhcmUgbmFtZTogU3BhY2VjcmFmdCBib2FyZCBiYXNlZCBvbiBNQUxJQlUgKERU
KQ0KPiBXb3JrcXVldWU6IGFzeW5jIGFzeW5jX3J1bl9lbnRyeV9mbg0KPiBDYWxsIHRyYWNlOg0K
PiDCoGR1bXBfYmFja3RyYWNlKzB4ZmMvMHgxN2MNCj4gwqBzaG93X3N0YWNrKzB4MTgvMHgyOA0K
PiDCoGR1bXBfc3RhY2tfbHZsKzB4NDAvMHhhMA0KPiDCoGR1bXBfc3RhY2srMHgxOC8weDI0DQo+
IMKgcHJpbnRfaXJxX2ludmVyc2lvbl9idWcrMHgyZmMvMHgzMDQNCj4gwqBtYXJrX2xvY2tfaXJx
KzB4Mzg4LzB4NGZjDQo+IMKgbWFya19sb2NrKzB4MWM0LzB4MjI0DQo+IMKgX19sb2NrX2FjcXVp
cmUrMHg0MzgvMHgyZTFjDQo+IMKgbG9ja19hY3F1aXJlKzB4MTM0LzB4MmI0DQo+IMKgX3Jhd19z
cGluX2xvY2tfaXJxc2F2ZSsweDVjLzB4ODANCj4gwqB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCsw
eDYwLzB4MTEwDQo+IMKgdWZzaGNkX2NvbXBsX29uZV9jcWUrMHgyYzAvMHgzZjQNCj4gwqB1ZnNo
Y2RfbWNxX3BvbGxfY3FlX2xvY2srMHhiMC8weDEwNA0KPiDCoHVmc19nb29nbGVfbWNxX2ludHIr
MHg4MC8weGEwIFt1ZnMNCj4gZGQ2ZjM4NTU1NGUxMDlkYTA5NGFiOTFkNWY3YmUxODYyNWEyMjIy
YV0NCj4gwqBfX2hhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KzB4MTA0LzB4MzJjDQo+IMKgaGFuZGxl
X2lycV9ldmVudCsweDQwLzB4OWMNCj4gwqBoYW5kbGVfZmFzdGVvaV9pcnErMHgxNzAvMHgyZTgN
Cj4gwqBnZW5lcmljX2hhbmRsZV9kb21haW5faXJxKzB4NTgvMHg4MA0KPiDCoGdpY19oYW5kbGVf
aXJxKzB4NDgvMHgxMDQNCj4gwqBjYWxsX29uX2lycV9zdGFjaysweDNjLzB4NTANCj4gwqBkb19p
bnRlcnJ1cHRfaGFuZGxlcisweDdjLzB4ZDgNCj4gwqBlbDFfaW50ZXJydXB0KzB4MzQvMHg1OA0K
PiDCoGVsMWhfNjRfaXJxX2hhbmRsZXIrMHgxOC8weDI0DQo+IMKgZWwxaF82NF9pcnErMHg2OC8w
eDZjDQo+IMKgX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2MvMHg2Yw0KPiDCoGRlYnVn
X29iamVjdF9hc3NlcnRfaW5pdCsweDE2Yy8weDIxYw0KPiDCoF9fbW9kX3RpbWVyKzB4NGMvMHg0
OGMNCj4gwqBzY2hlZHVsZV90aW1lb3V0KzB4ZDQvMHgxNmMNCj4gwqBpb19zY2hlZHVsZV90aW1l
b3V0KzB4NDgvMHg3MA0KPiDCoGRvX3dhaXRfZm9yX2NvbW1vbisweDEwMC8weDE5NA0KPiDCoHdh
aXRfZm9yX2NvbXBsZXRpb25faW9fdGltZW91dCsweDQ4LzB4NmMNCj4gwqBibGtfZXhlY3V0ZV9y
cSsweDEyNC8weDE3Yw0KPiDCoHNjc2lfZXhlY3V0ZV9jbWQrMHgxOGMvMHgzZjgNCj4gwqBzY3Np
X3Byb2JlX2FuZF9hZGRfbHVuKzB4MjA0LzB4ZDc0DQo+IMKgX19zY3NpX2FkZF9kZXZpY2UrMHhi
Yy8weDEyMA0KPiDCoHVmc2hjZF9hc3luY19zY2FuKzB4ODAvMHgzYzANCj4gwqBhc3luY19ydW5f
ZW50cnlfZm4rMHg0Yy8weDE3Yw0KPiDCoHByb2Nlc3Nfb25lX3dvcmsrMHgyNmMvMHg2NWMNCj4g
wqB3b3JrZXJfdGhyZWFkKzB4MzNjLzB4NDk4DQo+IMKga3RocmVhZCsweDExMC8weDEzNA0KPiDC
oHJldF9mcm9tX2ZvcmsrMHgxMC8weDIwDQo+IA0KDQpUaGlzIGJhY2t0cmFjZSBhbHNvIGxvb2tz
IGxpa2UgaXQgaXMgYWNxdWlyaW5nIGNxX2xvY2sNCnJhdGhlciB0aGFuIGhvc3RfbG9jay4gSSdt
IG5vdCBzdXJlIGlmIEkgbWlzc2VkIHNvbWV0aGluZz8NCg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4g
aW5kZXggYWNmYzFiNDY5MWZhLi44YjcyY2Y3ODExY2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBA
QCAtNTU2Niw3ICs1NTY2LDcgQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91aWNfY21kX2Nv
bXBsKHN0cnVjdA0KPiB1ZnNfaGJhICpoYmEsIHUzMiBpbnRyX3N0YXR1cykNCj4gwqDCoMKgwqDC
oMKgwqAgaXJxcmV0dXJuX3QgcmV0dmFsID0gSVJRX05PTkU7DQo+IMKgwqDCoMKgwqDCoMKgIHN0
cnVjdCB1aWNfY29tbWFuZCAqY21kOw0KPiANCj4gLcKgwqDCoMKgwqDCoCBzcGluX2xvY2soaGJh
LT5ob3N0LT5ob3N0X2xvY2spOw0KPiArwqDCoMKgwqDCoMKgIGd1YXJkKHNwaW5sb2NrX2lycXNh
dmUpKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gwqDCoMKgwqDCoMKgwqAgY21kID0gaGJhLT5h
Y3RpdmVfdWljX2NtZDsNCj4gwqDCoMKgwqDCoMKgwqAgaWYgKFdBUk5fT05fT05DRSghY21kKSkN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOw0KPiBAQCAtNTU5
Myw4ICs1NTkzLDYgQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF91aWNfY21kX2NvbXBsKHN0
cnVjdA0KPiB1ZnNfaGJhICpoYmEsIHUzMiBpbnRyX3N0YXR1cykNCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHVmc2hjZF9hZGRfdWljX2NvbW1hbmRfdHJhY2UoaGJhLCBjbWQsIFVG
U19DTURfQ09NUCk7DQo+IA0KPiDCoHVubG9jazoNCj4gLcKgwqDCoMKgwqDCoCBzcGluX3VubG9j
ayhoYmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+IC0NCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJl
dHZhbDsNCj4gwqB9DQo+IA0KPiBAQCAtNjQ1NSwxMCArNjQ1Myw5IEBAIHZvaWQgdWZzaGNkX3Nj
aGVkdWxlX2VoX3dvcmsoc3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gDQo+IMKgc3RhdGljIHZv
aWQgdWZzaGNkX2ZvcmNlX2Vycm9yX3JlY292ZXJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IMKg
ew0KPiAtwqDCoMKgwqDCoMKgIHNwaW5fbG9ja19pcnEoaGJhLT5ob3N0LT5ob3N0X2xvY2spOw0K
PiArwqDCoMKgwqDCoMKgIGd1YXJkKHNwaW5sb2NrX2lycXNhdmUpKGhiYS0+aG9zdC0+aG9zdF9s
b2NrKTsNCj4gwqDCoMKgwqDCoMKgwqAgaGJhLT5mb3JjZV9yZXNldCA9IHRydWU7DQo+IMKgwqDC
oMKgwqDCoMKgIHVmc2hjZF9zY2hlZHVsZV9laF93b3JrKGhiYSk7DQo+IC3CoMKgwqDCoMKgwqAg
c3Bpbl91bmxvY2tfaXJxKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gwqB9DQo+IA0KDQpUaGUg
b3RoZXIgdHdvIGZ1bmN0aW9ucyBkbyBzZWVtIHRvIGhhdmUgaXNzdWVzLMKgDQpidXQgdWZzaGNk
X2ZvcmNlX2Vycm9yX3JlY292ZXJ5IHNob3VsZG4ndCwNCmJlY2F1c2UgaXQgaXMgbm90IHVzZWQg
YnkgdWZzaGNkX3RocmVhZGVkX2ludHIsIHJpZ2h0Pw0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg0K
PiDCoHN0YXRpYyB2b2lkIHVmc2hjZF9jbGtfc2NhbGluZ19hbGxvdyhzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCBib29sDQo+IGFsbG93KQ0KPiBAQCAtNjkyMiw3ICs2OTE5LDcgQEAgc3RhdGljIGlycXJl
dHVybl90IHVmc2hjZF9jaGVja19lcnJvcnMoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGlu
dHJfc3RhdHVzKQ0KPiDCoMKgwqDCoMKgwqDCoCBib29sIHF1ZXVlX2VoX3dvcmsgPSBmYWxzZTsN
Cj4gwqDCoMKgwqDCoMKgwqAgaXJxcmV0dXJuX3QgcmV0dmFsID0gSVJRX05PTkU7DQo+IA0KPiAt
wqDCoMKgwqDCoMKgIHNwaW5fbG9jayhoYmEtPmhvc3QtPmhvc3RfbG9jayk7DQo+ICvCoMKgwqDC
oMKgwqAgZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSkoaGJhLT5ob3N0LT5ob3N0X2xvY2spOw0KPiDC
oMKgwqDCoMKgwqDCoCBoYmEtPmVycm9ycyB8PSBVRlNIQ0RfRVJST1JfTUFTSyAmIGludHJfc3Rh
dHVzOw0KPiANCj4gwqDCoMKgwqDCoMKgwqAgaWYgKGhiYS0+ZXJyb3JzICYgSU5UX0ZBVEFMX0VS
Uk9SUykgew0KPiBAQCAtNjk4MSw3ICs2OTc4LDcgQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hj
ZF9jaGVja19lcnJvcnMoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGludHJfc3RhdHVzKQ0K
PiDCoMKgwqDCoMKgwqDCoMKgICovDQo+IMKgwqDCoMKgwqDCoMKgIGhiYS0+ZXJyb3JzID0gMDsN
Cj4gwqDCoMKgwqDCoMKgwqAgaGJhLT51aWNfZXJyb3IgPSAwOw0KPiAtwqDCoMKgwqDCoMKgIHNw
aW5fdW5sb2NrKGhiYS0+aG9zdC0+aG9zdF9sb2NrKTsNCj4gKw0KPiDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gcmV0dmFsOw0KPiDCoH0NCj4gDQoNCg==
