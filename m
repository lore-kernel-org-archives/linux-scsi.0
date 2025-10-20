Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165232D9497
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 06:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760943102; cv=fail; b=pAqXGAKd/btq8eN7TmUAEgiLKs1v9B7OPgE608Lf5pvndfCbdeRnbDpfR+GM9zT+kgZosDaCko8CazkSVquqgFCozlvKT8rhDy3PcO4vkmdUNcXOxXvtPJ3IUuc27fHMEaXHDbmoN1Vu/L5TNILNm6w9HTTYWBGNgdIV+e56sAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760943102; c=relaxed/simple;
	bh=tTioGYxeSF9U0Rl0W+E91hNrvphcFolwdZaGSNWqeKQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l6YiIZlF4fPEANALzAmRNGWJ2E9t+ZRTYNrs4g+GjdehIEIfaqU39OVFXeFCeOZSO09ar2P6qM/lf3sgmE/WGCSOTEN15OjZIm0SQjMerFYtA1ATdCH97ob0uoiJtqPm7si2mCXrwlMHzdcKHfwHZfRxZkzdY1v4cDpEbZoXrmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VNg1+NRR; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=isQ6T1cz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VNg1+NRR";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="isQ6T1cz"
X-UUID: 32406ad4ad8111f0b33aeb1e7f16c2b6-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tTioGYxeSF9U0Rl0W+E91hNrvphcFolwdZaGSNWqeKQ=;
	b=VNg1+NRRdTVmLiPx47pBk5+EZgayJZlrsjdMwz+syQiZcX4C52ga6Yj8VUcnXI5NLHWAav1pQGpEM6297TSLSfAjseySS3YaqzKqbHCbqySB4ytFfvuNLfYlDIkZWg3oUjAWKqOZ6EDrrImeyj1M6qPr8RbhleXTTBuRrrPb53U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f1fb19a4-4ae5-4777-a661-3e617125c343,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:c29c9202-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32406ad4ad8111f0b33aeb1e7f16c2b6-20251020
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 401656517; Mon, 20 Oct 2025 14:51:25 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 14:51:20 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 14:51:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/y7OZX5cjDtsD4PG9G44E264g8rEBa37dM0J/O3I339cwcYP5m7CZbqD0vUHfdb1quAeRVCp0a5Fhh5Ci26LV0ASZQ99e8OL6JPdcNDA9+6AQ3Y38pvT7iDkw4TjLD4J4w9x3jXg6x1r1qPppxqUb2z+Y22oweWRthDJNZyPrLM2uw9I7p7XxTIeZQKsFoYMy81djX72kg/3ltGcz3cAaZNbX5AqUMvj0c95XEDxddx/ghT+sv4vPvS7e6IUsLkXGGpQIfMZpr0RO3m4La1/nXuL3RQQZhlwS7u0XQpuBm0m4lm5eI48hoG5TRNKNO+eEsuZrIHMc7G64TDP1X4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTioGYxeSF9U0Rl0W+E91hNrvphcFolwdZaGSNWqeKQ=;
 b=Otfbh5aKFIwwrGNGjpTTL+90/OlmXO0Fu7UakPDqA4cp0lBOw+65uJOhEDv+wZH1qKuXoMKUFiQm6szQ4ptkf0NeEmVhD6KWTUCVujTA7KGWOwoY89ww9LJK7PskAfzjcmele9HvzISJl7sknpj7J3hTzKIHGMS73hOYa2gPBL8CEgwFmk6od9Lf5XS21X94KDqBgYkKfIOrt6dvhhUO7WwXZZyGrmqEcitNT0b8J1wbacr6s8obgWq5k1t3OACUb8UHZ7sgVlauVa1GtWpSYSGDLeQSfRmFW3fCshfyDBLnqWw3DFDLn5+wTw0RnLqlUgcmlI+kkQGfIIu4J1vB/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTioGYxeSF9U0Rl0W+E91hNrvphcFolwdZaGSNWqeKQ=;
 b=isQ6T1cz4Mj7zovc9v9U5s97FjkVqbb8y7sq7IwsNh47u34hWQRNE1G3l2Mlrlz1+l4ikKvEYLOj5cANnPTxzsvZM4W7sjT1jfoeX8FHrQFtlTkeJpKD/lwIlRtECB9rJ2U8O8/sCmCgaRD39YGCzF8KUhqHi/srwSzuRyDWefM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6632.apcprd03.prod.outlook.com (2603:1096:400:211::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 06:51:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 06:51:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chullee@google.com" <chullee@google.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Topic: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Index: AQHcPUVzmnY3uUn2AU60C/91apcezLTGBUiAgACFlICABBZ7gA==
Date: Mon, 20 Oct 2025 06:51:21 +0000
Message-ID: <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-2-bvanassche@acm.org>
	 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
	 <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
In-Reply-To: <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6632:EE_
x-ms-office365-filtering-correlation-id: 8bd25339-02c3-4ff5-0920-08de0fa5145e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NlU4ZFU3bUNSbmNOM25hZW5xQ281eE9oVUtTdmpaY2tMR1dxTnhBeGJlMk9K?=
 =?utf-8?B?MmYxdytqN2N5VC9yZXBLcUVpTnVTL2lnQkl0VU5xNGJrUGx1Z2QvQ3cvcHFr?=
 =?utf-8?B?WlYza2U3WHZNQXd5czRNamVaQmZPS1RWWG0yLzJqNW1yTGNHUHFEMTdET0ZY?=
 =?utf-8?B?QUg0OFNLUzBYWnVpTXA5UmRDYldkMWMxS3NBUktMbjFlTHJUVnJuSzlYVVZ5?=
 =?utf-8?B?S0l2dENUODFDS1NlQXBPZ281NlFqQkdLSFFqS3hTNGNuY3A5cU0yOTR1amZm?=
 =?utf-8?B?T3NTci9QenV0cWtUTnJQZEFGQ256QnBOc0pVTUNnRjhkT2c5eE9nM3FWRjB6?=
 =?utf-8?B?WmJMZHFmUnlFRzA1TlFmVU5ZektqYVBsNFpIOG94cFFpMkNNdEJsaWRPN2dO?=
 =?utf-8?B?NklNNndmTTZDVWtUQXRrdm1oeHp4QlQxK2VEb085WUpnVmJzYWl0NFR5NGIw?=
 =?utf-8?B?UDU3TURubHpmZk1GNEMyMXNxaS9tSFcrYkJzNnRqQ2VXcTJBNjhuQWc2VTJI?=
 =?utf-8?B?YmxEb29kQnhDbitsQ1F2cHdPaEh3bFk5V0ZDVmY1ZUFtTzBJVmtxK3QzQ1pL?=
 =?utf-8?B?UzUyNTN6UHdnbmU1THNITGdqdmhZVVNEQS9ZaWE4TStrTXkySUZlWXNtQWVW?=
 =?utf-8?B?N3pOai9JcDNPVE5jQWovUkhUb3V2RitOUzNmTUJVZUVjaUR2SzRxeU1hMmUv?=
 =?utf-8?B?WUxIU3ZMZUhKZElJdnlZTm96MndIcnZ3NEpQd1RiR3BRQ1J4V1dqVWRNb0pS?=
 =?utf-8?B?cFJzNkF4YUJDeityTlhGRVlWNVhzZFVOMThXL3BnajBmNUlRRUJPS28zM0tZ?=
 =?utf-8?B?bEE4a0ZwUHJ1bDdaNlBxUjRmUGpDeFFEZzVUeWFxWm9lbEp2QW1QMU85RVRx?=
 =?utf-8?B?WmpVUnhCa29XY2tudjMyTW0zU2Z3TnNldWt0YUUwWCsyNUdoc0RCUjF3T25C?=
 =?utf-8?B?QXh3d0Q3V2gvaVZ0YmZIckUxUXVBc1NSZGhKTVpHdUpGV2ZsUjFlUEM0Rng1?=
 =?utf-8?B?RVY1MnFhN09LbklESVRSVWRwSEVMWUh0U3ovVzBxbzIxUXhNejBQQnlzMENE?=
 =?utf-8?B?Sno1SGYraVQ0enhuRGRqZXQ1VFZ5SEI1d0I0aGlNSTB4d2w0ZTVXZlo0bHRZ?=
 =?utf-8?B?bnRjL3ZIWm5RVDROaENScFRjNTRLMDJHQUtsTVlkOVQ3WGhYYjJ4YVI3NXpT?=
 =?utf-8?B?a1hNdGFLSTYzTzQvQWZvb1JMclViNmdJUHQyVjdpNEJHNEJ6NDJjbTFSQTdT?=
 =?utf-8?B?MEM1enhleWtmRjBTc29yZFBYb0R1NlQvOUJtWjhCclg2T2ZBYTNIbFE0L0Nv?=
 =?utf-8?B?RWxjbDhWMHpBZW4wcFBCNlRpWTl2Z0Y2WHc5dzBIdkl0c0ZGUC84RWJJQThm?=
 =?utf-8?B?QnFtU3ZEdk4vN0dnY041ZG1FRmc0Q2RjY3BxYXRlQmhDb29OSklXc2hvK2Jm?=
 =?utf-8?B?OE9mRmVodklmWGpseFZkeVVaN01HUloxeSs4M0UwSFc0SFNrc3lralYvT2la?=
 =?utf-8?B?aENPOUhHSHdJMXdNdWxwbGZ2YndoR0FrUVJhcjg3ZzNvd1p6cWk3TWZtbDYx?=
 =?utf-8?B?M1ZIQm92dFQzMjV3Zy9KYnFUTFhFQytSeXY0MDNEb3V5VTJ6Rk5wZHlQdFp4?=
 =?utf-8?B?TjI5NWRGWlRpaERMcTVyZU53cUMwV3NNSUJTdlc1YXRRZXA2RHFJcGJPWncv?=
 =?utf-8?B?OVRhNlRSc20zWDE1RkN1amNhYUw0SHpjWCszWWxINm03bmdXOU50Rkg3YThj?=
 =?utf-8?B?dnV0b29EVVRlZGRkdkZqM2NlZ0M1TTFadWFyQW9icUVxMlZKbThhVXpHNXlT?=
 =?utf-8?B?S3FPTC91MnRYekdwMmFqTEVGYUxBK1BwckI2cGs0STdZSnhkTnovd3NZT1dU?=
 =?utf-8?B?VEx2WFM0NHF2QjFmSXE4N1VNOXJqN3lzWXhLR0xmSVdGMXZEL3V1cjFUbXl2?=
 =?utf-8?B?RjdiU0hhTnVjQk9lUlhObjhhTWZvNVhZV25Xc3ZGM0xmWjFkY0syQ21qbTNX?=
 =?utf-8?B?b3lQRXhQb0x5NzN1SGpZVWw5ak1aaGVVQlhPY1BwRHd4WnFWR2c1aC9EQVdS?=
 =?utf-8?Q?WgteOW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3lRQTlHYkZKWWk4MTBqUUdLaHN6V3dZYXJKaHplbkk3WGl3QVRmTllEV3dJ?=
 =?utf-8?B?SjA2elhsUDRraHNCL25nTjNQQUVLN3hVcUFOaUY5V0x2alFQTHZNUlRTMlp5?=
 =?utf-8?B?c3FFOWNtRHB2ekdxMDdqamFjeWVKY1oxM3NSc3VvWUYxMDBKYkp3YnFzTGZj?=
 =?utf-8?B?N0JFeXQ0NmkwNDF6aFcveWxGQUVoM3hMMWN1NHR2cmdJa1ExSUs4eDFJTzcv?=
 =?utf-8?B?MUF4ZlNHOFBZcGdqSGZDOVd2M0t4NmxzcWIxdHA2Wjk4WHA3aVFLQ1BTYytz?=
 =?utf-8?B?Qm1BRkt2L2dBYkRyQ0pWSkgyTDBNc3JFSXVKdjd2TjFjbG1JZGFUbVVsYU14?=
 =?utf-8?B?N2liMkJyRTJYcWx2M1RqTGE4L2lEU2R3QVJUYnJNZ3NJSFg0YUN5K1h4NEFN?=
 =?utf-8?B?cXMzdG9RelZSUUF4QjN6RTdJbWdFYU5rZ1dTUXhWbzZQM0ZpSDZ4cG0wWjJY?=
 =?utf-8?B?Qkpsa0lrYjhPK3JNcVh2czRQUVZCTS9IUXpVY3orWGtWRXhuazJ1SEpwdTE3?=
 =?utf-8?B?WjRDM2Fqcy9mTzhVdThVbzBkemkvWXN3V1Fla1pycFM0TUttbEs0a3hjVkpk?=
 =?utf-8?B?TDBxQmp6U2N1VWNPTlNSV2ZXam5yS0NsL3ovK2pBTzdtZUd3ajB6TEVNSUx5?=
 =?utf-8?B?Rmg3My9mak0zMWx3aDQ0NGorendLZzBodThnTzZhVktvNUhCakpCdzVQNm9n?=
 =?utf-8?B?MHB3UmNGcXFOcE45b1BzRTN3ZStTOXBjaDRWQlZJcnl5Vlk4bzFIUXlGM0lV?=
 =?utf-8?B?STh1SXljR0FZL3FZNHo1ZzhhTFJGYzREeXgxMEw1SmUremZhOVN1M2JPU214?=
 =?utf-8?B?Z0VtM0gwQXVoeTA0UUNrYldFd2FyZkhmZ2Z0L0FMeVVmQzJTMUo1US9nZ2d2?=
 =?utf-8?B?cXFWZE95ZEFCak1mdmlSNzRNL2lPbVNrOXlsdktxZ2dOT0liMllWR2lxZG80?=
 =?utf-8?B?emU1dTJzanFmS0VuOUxaSHgyUVpheXpNNXRXY2NhZU5tWVVHSFlsYnFSSHpH?=
 =?utf-8?B?OWk5eW8vSmRlMFNBMzB2eWp5MGp2cTZVNmc5QnUybTdaNGFWU015Y0Y1cFRT?=
 =?utf-8?B?b2xuK3hHWVRJWEt3Ymg0QU5ZTTRQekplSno5Y3F3M09jdjROMFkvSTdLVmxJ?=
 =?utf-8?B?V1huQUZxdkpBVE9EQm1GU3B5YXNIdVN2eThuaC95OG5wS0ZBUTJFaHFyY0p6?=
 =?utf-8?B?eEtsM2ZYekRqL0k0L3JHYzN1NmtIMzhXcjBoaG50ZVpncmtwL0s0QkxBQnMz?=
 =?utf-8?B?Q0gwZU1ZM2JKUDNIZ0x4bjUwNmYyTSs2YmFDNVg4U3RVREN1UmhkNUM5Q0Z4?=
 =?utf-8?B?eDhZQ3h2ZWgwZ3o1c2Q5RW83MzE4SGlYbGNmNVRQdVVjbzJnM1NTcDUwK3Zm?=
 =?utf-8?B?QTZFNHlJWVZiODVqUUxXRVNBaVFrZDFVVjNtcEJKQ2orZU5YS0syTDE0TXUx?=
 =?utf-8?B?Z2VsdEhwZHYwcjNwOFBqR0JUc1p4OFV3aXpCYlNSNzZNRlk1M1hXVkd0U045?=
 =?utf-8?B?TjU2SHdPaG5uaE5XQ2dSK01jZnJCV0Fwd1ZBajhNdUQvUXc3MVpSWDhteTRZ?=
 =?utf-8?B?MURqbXRpYmhOYS83MFU3WkZOSzUwWVV5WlYwRjg2b1NDbk5PMjNXREw0RHFi?=
 =?utf-8?B?c0pLNWp1VG52dTRMTUJOOFl3K2tZR2RRTkw1a3VXMmpPZ2pIaGVhODN1aDM1?=
 =?utf-8?B?ZzZDT1NLNU5iaC9OTGdsenVtbjg2KzdmUHRVa1JuT2hneWNlRUVCMEZZeXY5?=
 =?utf-8?B?T0tDUGt0UE9ZbGw5MmRrZ3ptMmhPR3pSZGxGWHFoTktwaXBOSzcxY213aTlx?=
 =?utf-8?B?TDI4T2ZGVmgrMjZ4RGRjSzVacC90SER4YWtUSTU2OHBRdHd6dUlubmo3QndB?=
 =?utf-8?B?R0V1QmpPdUk1eFdkdlZlVWlHNmFwb2hzbWtjU2FVbVVXWG1WZFhKcTg4dkFw?=
 =?utf-8?B?a0RRNVA5NytGNno2dUR5cVNQcHlCa2p6Qk4xdmpRUzNNOHFLNEVJeVduN1kz?=
 =?utf-8?B?OUsvWHN4TFpiTEhTU1FadC9uTXU1NlhNbTB5WWN0OCs0MXNkbi9HMDQ3TEk1?=
 =?utf-8?B?ckNuWFh2UWtOYkRmKzRsL2M2SzF5WWl5WU54Snl4TjlkYXVvd1RjRVhlTEJx?=
 =?utf-8?B?WU1KY0lDT3ZSTEhXNGFHT1NhOWtUZU82dTNBbk9ONEhyd0xSdlZtVGVLR1gr?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D84F25CF2ED4EB44BF8432C9A899CD30@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd25339-02c3-4ff5-0920-08de0fa5145e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 06:51:21.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9PknmyGnWpxCrIeqUKyH9gBoe3ghwsPfIUuA9JIdsgl2IJbl2c+rZNTIXpAVlH9ZaAFV77efYFvjnW/J/OjSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6632

T24gRnJpLCAyMDI1LTEwLTE3IGF0IDA5OjI1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFN1cmUuIFRoZSBjYWxsIGNoYWluIGlzIGFzIGZvbGxvd3M6DQo+IA0KPiB1ZnNoY2RfYXN5
bmNfc2NhbigpDQo+IMKgwqAgdWZzaGNkX3Byb2JlX2hiYShoYmEsIHRydWUpDQo+IMKgwqDCoMKg
IHVmc2hjZF9kZXZpY2VfaW5pdCgpDQo+IMKgwqDCoMKgwqDCoCB1ZnNoY2RfZGV2aWNlX3BhcmFt
c19pbml0KCkNCj4gwqDCoMKgwqDCoMKgwqDCoCB1ZnNfZ2V0X2RldmljZV9kZXNjKCkNCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3lzZnNfdXBkYXRlX2dyb3VwKCkNCj4gDQo+IA0KDQpIaSBCYXJ0
LA0KDQpJdCBzZWVtcyB0aGF0IHVmc19nZXRfZGV2aWNlX2Rlc2MoKSBkb2VzbuKAmXQgY2FsbCBz
eXNmc191cGRhdGVfZ3JvdXAoKS4NCkRpZCBJIG1pc3Mgc29tZXRoaW5nPw0KDQpUaGFua3MNClBl
dGVyDQoNCg0K
