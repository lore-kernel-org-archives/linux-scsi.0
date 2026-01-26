Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387092D0C82
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 03:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769399096; cv=fail; b=nVEyWrid0OCZ13iSn2cCPtlQ/mcFEOn+MsLyLvAJjq9IlgJbjcgfbh7EWltkbvXdHYe0D6wd0UYsBc2IlwadtiOUbnAjPzJSv/4p8QQnShthyd0447e2rLFg//SkxuwS/FEMmmPPT0psqy5+5hT4F8CtkRrYkbK3xPOrGLiawks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769399096; c=relaxed/simple;
	bh=BOIub7S6qV6XKrEfmOnfAJRH0XzNecwzJoDX59PtCF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pONn6kM0WkQ0qRdBjP13qkp4fyfkVc9/GqmUwXkmmlOTKZ9/2aai4RSdqSrvO7JiFSZTgu5MMrFFrXRoPGI+N1xVXaiOWQViXCMMbIjwN51S8S/iuHblvF+iZQc1AFTpgN5tNrgG2WPSw3RKfpzispA5iPvsx/hQBn4+nq4U6sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gxreYVHZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IOQoWozO; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gxreYVHZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IOQoWozO"
X-UUID: 5cdefff0fa6911f085319dbc3099e8fb-20260126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=BOIub7S6qV6XKrEfmOnfAJRH0XzNecwzJoDX59PtCF4=;
	b=gxreYVHZaQEfY+xyNuxIB2bF+CcOJXqWaVSIL7YrCB2zeevdhS3H8Rz0tza494V5y1A+ZxOSwTl9Sn4PfOOOq989VWPClGOvGDiTYxoTocmEmNvn3KiCQopO1ZKbKjF0OxeAS7CP1sGomz6BRLG8mII+sj6xuR8QVIEQEF3wsp8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:e7c8d69d-85af-4214-99c7-fa5f314277a7,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:89c9d04,CLOUDID:e152367a-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:4|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5cdefff0fa6911f085319dbc3099e8fb-20260126
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 934247678; Mon, 26 Jan 2026 11:44:48 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 26 Jan 2026 11:44:47 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 26 Jan 2026 11:44:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHLJZwZVf0qHqzc5BoZkLV8v5jjAJQiLdiS1Cwn6XioCvwywfvHbvW7ETCx3kXBZQtW6g+CIWxc+t67gSUF1hOGBadg89izlaSsoMnGazZhQq3N08AklZ2Xe0UKtJRDVuHqYPCA8Uk1O1wXLkFWz0lWl74w60BO1jmART+A6JC/SqgWhRzwxcXo9xXnCZow4wtztoYP4prcqk7jcTrcF3GPdb3yEqINuqsrKbdYH//WSiKox4GvtZV4IGTGreYGl/i08jxd3d+/yu58hGXMyRfg6ytL/AtcTtuEflHYs394oiUlEEiS/Z3KWYNMI2NlQqbYB4wtcAANgqdjBbwP55g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOIub7S6qV6XKrEfmOnfAJRH0XzNecwzJoDX59PtCF4=;
 b=qAPW8g6gMHIxqYembztEQADbq6ctsSZiPKq5wAEYw/ww1UOBmMOfSKt7aC7sg3cNHousbH4c9U/RcARn+R86cscRQ5DPmbMc05ntwPlulH/ptRi7t89B6rkIu18aEgq6XdtkUnImpzP2U+kw2Bbf9BjjCaMyCj3pXuQR7dcE5E559V4KR9+Plz47AdLF82Zq2oHBYbk9ux1cnKrTJsYK4xHOK53Niilariyugze4N0ADoJvi1+DUniaef4Cy8sPtpw3qFg8Vs50pTem+orc5KeU+9EzUc33h1aEE10DnGpeGz/zRshyqW2IxAEdtGP0wQatctnaBi2RCkQZlNcxp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOIub7S6qV6XKrEfmOnfAJRH0XzNecwzJoDX59PtCF4=;
 b=IOQoWozOYD9nciOMPZ8VzsWefuDnRys9uUObSjGQDU/nE/N0pMAvsYgClDMMIlniky/Qnj8YKZjdydoiigjNRzrD5cSi5/E0PZtYirISCcpzcorbMNuWYgvoxYVPKyurPKBcwbX/S8O9qeZVRd9IPuveVLi/KcHvsvpzuhB2C8I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7785.apcprd03.prod.outlook.com (2603:1096:990:10::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 03:44:44 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 03:44:44 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "mani@kernel.org" <mani@kernel.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] ufs: Remove the clock gating code
Thread-Topic: [PATCH 0/7] ufs: Remove the clock gating code
Thread-Index: AQHci8TifHJljah/kk+EIn3dUw3jc7VfW6cAgAEMiACAA2x9gA==
Date: Mon, 26 Jan 2026 03:44:44 +0000
Message-ID: <2798fa37f745f9d91757f5097e158c61f72bc835.camel@mediatek.com>
References: <20260116182628.3255116-1-bvanassche@acm.org>
	 <r3upegmcqg5fxo22u63dwtwrlc7qpwi57drlvujtw4jkbinx7f@xluie2klyr55>
	 <cb72534c1eac0740e24eed7ca4207371f55bb273.camel@mediatek.com>
	 <1ebc9a1e-c36e-4d9b-a695-a6153a32e0c0@acm.org>
In-Reply-To: <1ebc9a1e-c36e-4d9b-a695-a6153a32e0c0@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7785:EE_
x-ms-office365-filtering-correlation-id: 58c2004c-522a-4f5a-52de-08de5c8d3ec3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RThjLzdEY2Z3RHY2NkVvNzJZaFlDR0gvRlduTk9kaGtmVU94K3NBNlg3anU5?=
 =?utf-8?B?SWQzYm1pN084OWMxbWpqVUZPamRtT3lmSFR4Y1NMWjBsUUZOMzBLcnNvWGZ6?=
 =?utf-8?B?WVc1WENlejBEVWRnd1d5Zy9EdkNqcENDK2Y2bnVnYm44R2VjeDNldjYrOVJY?=
 =?utf-8?B?bXZCK1pGcEI4THFOa0lKN2txMW1BM0JIcXkzM2l5L1VEdnpnTW5RcURUV1JC?=
 =?utf-8?B?ZHZpbXJrL2FyTHdwSlF5ajhLTGllMkl0ZUdRT0ZaKzV5U1kyc2xNdUlWZjJi?=
 =?utf-8?B?dWlMTW5qNW0wRTQwa1FmTllxUHhid1RtQy9OU0g3MDV3Zm1EQlppMFFVZTN1?=
 =?utf-8?B?b29qSC9HMVpYeWRQR2pBUFplRWhwUTNQZzg3eE00akh1U2dHeS83MVRORFpQ?=
 =?utf-8?B?eWQreU9MU2xzOFBkbnJEWVhQTXFyZDBMbUpTRk9rZWM3aStBS3VSTElnamhS?=
 =?utf-8?B?OHJkUzFXais2RjFXK3VZVTNNeDE4YmMxUEY3ZVlUYWUvVjFtcmgzTGl1OFlk?=
 =?utf-8?B?Y1M4bFkxZk9HNEdiSVR2U2xKajVOeTE5OFN5SVNtWjRFSElxU1FsZE43S1Rs?=
 =?utf-8?B?a2QrYjZlV0MxMEpuQytxKytVRDY5bzRYK3BXMkVWN0lYZWpLWDl6ZnYxTjgy?=
 =?utf-8?B?ZXZEWU5uWVVISnFvanlqYlZFWjY0bDFhUzA4T01kU3BaTXpHRHpiR00xcHJq?=
 =?utf-8?B?bEhFQTloU2VOOXVrMGZCMTd6SmQxVWZ1bHB1N1YyWkx0Wno3YXAyVXpLNDlu?=
 =?utf-8?B?NlhhTksrWXVyRmMzNjFYQ3NCN3dzcGkvcjlEb2xxTit6S2dXU01nckRFNHZB?=
 =?utf-8?B?b2JrWEY5eTBHSEZZQXNmdG1xdU5od2JMQnJaZ2FmL2kzdjExRkdiTlRvN0I0?=
 =?utf-8?B?dVg2cnRJSENvUExkVU1zMlZ0L0hPTWJTamlKdlYwdzJ6aFd0ZlZZUWQvaGZF?=
 =?utf-8?B?UVRhMDlwQ21tN3dheXByVTVVTEE5VGg5VnVMYlo2SVBOUDk0amRxSHNZam02?=
 =?utf-8?B?QnR6RW04SkgyejVqZ291TEpRSklxcjN4THRDaUlIeXJSL2ZlNFRaaDFNQWc0?=
 =?utf-8?B?S0I1NHYwRU5uTzdqOWdpTi8zMGFZcDhrR3IvQ2E5V1U5VDg3T29DWERlN1Q4?=
 =?utf-8?B?K0tidzdaZ1htajlpbW9wUTFYNlBKYmJhclB0UXExbTlSd09vUm93MU9TenpP?=
 =?utf-8?B?aVlUS3IxVlJhUEpFVEsya1Y2Y2Zla2pqQmtSMVh6K0tmYkNDUUFBd3BoU1Rv?=
 =?utf-8?B?TkVwZ1N2Tk9RVys3Y3FCa2VFNWlaQWl2QXdTSFRNSXB4SHVrdUJVaXR4QkFk?=
 =?utf-8?B?Wm9UVHhrVFBDR2J5eHlOallaNTkxQnpYcHptWkZjZ0JIbFA4dzR5QXFzTFps?=
 =?utf-8?B?UTNsQkpSRVZmQ3RBNFh6Q1JmcmJSVndSdjVSdE11Zjk1QXp6aUdVL3JORDNw?=
 =?utf-8?B?b0gyb3JINVJ3M28rVmVqSmpERmlSZmJrSUJRdExZZDRpYVQ4TTFuOERzbWs3?=
 =?utf-8?B?cHpJeWJtKzJnTWtEVFRmVmZkcWdOaUFrTGFYbEorOVlQM0pVNEp5Q1pFRUVo?=
 =?utf-8?B?ZHNWTUgxTTU0WHp4SE9kWnhOd3N6N2VPaWM5eW9TWmpOVTNSdmFabmZnVFBN?=
 =?utf-8?B?WTJOZldaYXlwQ1YzWTBhMHJYOXdhQzdUK2c2dk1HKzlPazBvL3R1WXFteW5D?=
 =?utf-8?B?OXROcC80UDRkeVY5M0JLOHV2U1RTWmhqdzFzRGhnOFVIeUVlNnY5cEI4di9r?=
 =?utf-8?B?L3JlV2tLQjkweFRvNld3Rm9HNmF4VmJwVituVUkveEhZb2NCNHlRUGl4ZGUv?=
 =?utf-8?B?VUtEblQvN2RFK3BqZVBqS2FBOTR3MVloUitDVzJYbkhMVkVxMmwrL2N2aDUx?=
 =?utf-8?B?dHV2UjVEY2ludU9xdlQxNW5BNzhpK1ArY2RkbWNubmpLN0N3aXhmQ2cxVURI?=
 =?utf-8?B?MjNRS1ZpWUxvUFVkQ3VSWDJpWU9iaDlLbzArQmNqdjc5anlMQW0zTHZLdUtO?=
 =?utf-8?B?S2NCTHVjaFBqSHRJMDBuZjFjSjh6Uk1zQTdhaUlEYXdveDhFZHR4S1d1enlw?=
 =?utf-8?B?dDlra25LZys2QTEzRitDN0p6RmZ3eG5qT05WY0tvK0FHZXl6Q2J6cGtuWVB4?=
 =?utf-8?B?YlZxS1FuOHB0eTBsamhCa2dxamlHQXdhODhOVFB0bkFpOGtRdGlrMllzb2V1?=
 =?utf-8?Q?UYrTOVdn0AF+eIPIMUg33XQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WURVWXVJbXBqNkJCNE9Vbmlid0Z2bTIwK29OT2hlQzUyTVhQTi90Tms2Y05P?=
 =?utf-8?B?eFJmTHZxS2dtZTd3ZlZPY2RLejZLd3JMWFRGV3N5bVRaZzdGY29EYU0xZFpT?=
 =?utf-8?B?ZkFDMUluU0k2Y0pzb0NldFNhc2dsSzIzNENuaFU1OGlHa3AvTXloN3B1eDRx?=
 =?utf-8?B?OFdpaUVxSDhSbWhaV3pqOGh2MkRtRUVkdUFSclJxVStVRktCS0wydFVESG5G?=
 =?utf-8?B?bkxyWmhGTkhoQmR0MUJwSWpTVXJLcGt0VjV3bndMU2F2TWZITmpQZTVkTys2?=
 =?utf-8?B?RFFxeEpqdU1zeFNlSVhDYzdueFBLdVB3ZnE1ZXhsdDltWS9sYy85OHdqaXEv?=
 =?utf-8?B?TXdUSG9TR3NwSE9LZ1NTd2Q5NFZFNWRIR1RZOTg0WU4wbXUxMzJGMS95Vmt6?=
 =?utf-8?B?MlhsdSszZDhleTVkWVNQR29IVmtRbEllS2lKSFBUbHpVZC9TMkg1T0hXODg0?=
 =?utf-8?B?L251MW9ReXY5SnVpYlFCQUZNckhuUlJWZ3F6RnF4ZlBlRWlVaUN0MlRVZWlu?=
 =?utf-8?B?RmFZSjhMRmdWcjQyTnRDcmlaR2hVOVhNL1NrQUtKL2RxUFEraThiNG5LMmJE?=
 =?utf-8?B?c2FHbGJOY2d0V3I3ak9ZV2NqVHgreW11YUFnd1E1R24vZHphaGpSOFpWMUZJ?=
 =?utf-8?B?Y0hYdVJoM3g5VndraExPQ1kwZm12cDk4RGxTV3h4c1YvNm4wUnNkSnNuZW5s?=
 =?utf-8?B?VmdGQllEVlRUeHpiZldiaEExRGs4dHhUNmhOZEg1SnJEdXZNN1VNT0g0NUlL?=
 =?utf-8?B?Qnh2UGRvdVN3b0IxZUt0R1dQTlhjTmEycmx6OTA0TVo4M3FOK1J6ek1iUWdK?=
 =?utf-8?B?T1lTWTNMRER6NFJ4YkZDTEJNNmc1MUFCay9IOVJFOU5NWjJqL0pQZU1GNW1F?=
 =?utf-8?B?QndLWUkyem1CTCs2VzFqbzZyN0hxTzQ1QjR1K0U1clpjdXFaYXhVWExOcWQv?=
 =?utf-8?B?L1FaUEl1NjNiM2NNL29QZ1gvRkoyTnZMNTZTNjlKV1RpNkFITVpTZ2pGZkdK?=
 =?utf-8?B?RC9vcWhtMjVCaWNwVk44SkFka25FOFVFRTRaR0c3ZFUxRTFseExQZEl0bTFi?=
 =?utf-8?B?VVRCTjlZSkZMemlxbHZOVVp5alpzRnc0cGlQajlrYmczc0NXNy9ybmcrZkJN?=
 =?utf-8?B?KzhZT3M2ZzZzNS9SS3dZbHppTlFZa1RvSHoxajlEdDJaZDF5enBkbXlNcTJG?=
 =?utf-8?B?QVYyTktTWkwzS3E2UW16TGkvYXc4VlJhVExaaFc4N29aeVFUSzRlQnk5c1Q5?=
 =?utf-8?B?RlEwWkZDYjNZclpsTG9vVGhRQk4rM2tKZUJqUEVSNHp4QzRvVVRkNXE0U2x2?=
 =?utf-8?B?RGlkS0NaaHQ0VmY5eDQyRnk2ZW9LSC9lN3FXWnEyT1loa0dQZG1xdE1QTFRp?=
 =?utf-8?B?N21zRjBaU0l5NWhWbGlFSFVTVERyK1VDTml4blJjcTdpa2ZUdWJiNzZTamVC?=
 =?utf-8?B?WXN6RHQrK0hLamE5Sy8zRXBOeEk1VTZZTmhnT1hUNnRSN05uQ1ZSaG9nYzVH?=
 =?utf-8?B?TzVvTUV2ZmxxVlVUY21SUUdZM1dEZEphdm82Q0lvK2FqUlo5am1BNVhBZGNX?=
 =?utf-8?B?Q1NMeHdyZUtzaEtuTzY2REJQTmYwMGNFQkppczhzbXZmamNvMHA5SXRxUlRI?=
 =?utf-8?B?YW50TVZRSXdvbUw2Tmh5SGJTNmdoUnFlbmhnV2E4SWFiR0QvMHhLeWVQUzE3?=
 =?utf-8?B?MitIdzZUOExmUDJaYkhYSVdCbTZtR1pteXFmNUEwVlJhbnY3cVRKdFdGVXox?=
 =?utf-8?B?RG9wNVFvSWpsVWNKYjdtdlV1akd1cHJsaERnbE9LeUxsN3drdlJQbGhoMzI4?=
 =?utf-8?B?RUtOanlYdFQ2UTdLL2hHTjJBMVFybTJmU0IxWHovOXo2MUFoaklKSVBEeWw3?=
 =?utf-8?B?UnNBUGMwbXBPNlBiVCtaOTZROXlnZnhRZ3V4aTNoSVFNQUxRS2RFanlmdEdn?=
 =?utf-8?B?blUzMHZZUm0yUW01Y0tTZjdNOXVaRDRnUHZyRU5OcE1hQmV0RTRtNHlkRzQ0?=
 =?utf-8?B?RHRBaTE2MnpkQWpJbmRiQzh0OEk5bWh5ek5PQnJjU2pFUmIrSUY5aTZDMTJ6?=
 =?utf-8?B?aFlLMHFyV0RYL1dIVlBpVUFmMGh0cmI1bXpDejBEd0RBQzVwL3VkaG45b2NP?=
 =?utf-8?B?MVI3SEhqeHltNjJPeVd6bnpaZlZ0TXVGMzRBOUsyZEZlbUpHcDhNQ1A2QTE0?=
 =?utf-8?B?d0lPMGRYQ0pwMUZjZjE5ZFpQL2piZVg3UHhRZU9IcjF6OVd1UncyVHZuUlJs?=
 =?utf-8?B?MmtrYnRwNVhaKzY0OTN6RWJTZXk4YlZBUE8ramlzMVFxSW9zMDBBV2N6OXhD?=
 =?utf-8?B?RkVVRkcwQXZUMFdxQXY0UkJtVU1KNkE4ZWJGVjYzRWZyYkFVSDVIMHZRejdp?=
 =?utf-8?Q?EhPZeQUz8ZTO8n/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E5CE84045C0F644B959572EF93AA36B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c2004c-522a-4f5a-52de-08de5c8d3ec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2026 03:44:44.5795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7hr7shuGpsM7h3pCSSRVOZpRasB6NhBw+bEbcBFUa5eeU7p61TelTQ+yIMypD8QDtg/kyPA0bQwdGlEve52uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7785
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDE1OjI3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEvMjIvMjYgMTE6MjYgUE0sIFBldGVyIFdhbmcgKOeOi+S/oeWPiykgd3JvdGU6DQo+
ID4gwqDCoMKgwqDCoCBoYmEtPnJwbV9sdmwgPSB1ZnNfZ2V0X2Rlc2lyZWRfcG1fbHZsX2Zvcl9k
ZXZfbGlua19zdGF0ZSgNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVUZT
X1NMRUVQX1BXUl9NT0RFLA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoA0K
PiA+IFVJQ19MSU5LX0hJQkVSTjhfU1RBVEUNCj4gPiANCj4gPiBUaGUgZGVmYXVsdCBSUE0gbGV2
ZWwgaXMgZGlmZmVyZW50IGZyb20gY2xvY2sgZ2F0aW5nLA0KPiA+IHNvIGl0IHNob3VsZCBub3Qg
ZHVwbGljYXRlIHRoZSBiZWhhdmlvci4NCj4gPiANCj4gPiBSUE0gYWxzbyBzZXRzIHRoZSBkZXZp
Y2UgdG8gc2xlZXAgbW9kZSBhbmQgcG93ZXJzIG9mZiB1bm5lY2Vzc2FyeQ0KPiA+IHZvbHRhZ2Vz
LA0KPiA+IHdoZXJlYXMgY2xvY2sgZ2F0aW5nIG9ubHkgY29udHJvbHMgdGhlIGNsb2NrIG9uL29m
ZiBzdGF0ZSBhbmQNCj4gPiBoaWJlcm5hdGlvbiBtYXliZS4NCj4gDQo+IE15IGNvbmNsdXNpb24g
ZnJvbSB0aGUgYWJvdmUgaXMgdGhhdCBSUE0gaGFzIHRoZSBhZHZhbnRhZ2Ugb3ZlciBjbG9jaw0K
PiBnYXRpbmcsIG5hbWVseSB0aGF0IGl0IHN3aXRjaGVzIHRvIGEgbG93ZXIgcG93ZXIgc3RhdGUu
DQoNCkhpIEJhcnQsDQoNClRoaXMgaXMgdHJ1ZSB3aGVuIGl0IGNvbWVzIHRvIHBvd2VyIHNhdmlu
ZywgYnV0IG5vdCB3aGVuIGl0IGNvbWVzIHRvDQpwZXJmb3JtYW5jZS4NClVGUyByZXN1bWUgdGFr
ZXMgbW9yZSB0aW1lIHRoYW4gc2ltcGx5IHR1cm5pbmcgdGhlIGNsb2NrIG9uLg0KDQoNCj4gDQo+
ID4gVGhlcmXigJlzIGFsc28gYW5vdGhlciBzaXR1YXRpb24gcmVnYXJkaW5nIHdoZXRoZXIgYXV0
by1oaWJlcm44IGlzDQo+ID4gZW5hYmxlZC4NCj4gPiBJZiBhdXRvLWhpYmVybjggaXMgbm90IGVu
YWJsZWQsIG1hbnVhbCBoaWJlcm44IHdpbGwgYmUgdHJpZ2dlcmVkDQo+ID4gYWxvbmcNCj4gPiB3
aXRoIGNsb2NrIGdhdGluZy4gSWYgdGhlIGNsb2NrIGdhdGluZyByZW1vdmVkLCB0aGUgaW1wYWN0
IHNob3VsZA0KPiA+IGJlDQo+ID4gZXZlbiBncmVhdGVyLg0KPiBBcmUgdGhlcmUgYW55IFVGUyBo
b3N0IGNvbnRyb2xsZXJzIHVzZWQgaW4gbW9iaWxlIGRldmljZXMgdGhhdCBkbyBub3QNCj4gc3Vw
cG9ydCBhdXRvLWhpYmVybmF0aW9uPyBJZiBzbywgaG93IGFib3V0IGFkZGluZyBjbG9jayBnYXRp
bmcgDQoNClNvbWUgb2xkZXIgTWVkaWFUZWsgcGxhdGZvcm1zIGRvIG5vdCBzdXBwb3J0IGF1dG8t
aGliZXJuOC4NCg0KDQo+IHN1cHBvcnQNCj4gaW4gdGhlIHJ1bnRpbWUgc3VzcGVuZCBhbmQgcmVz
dW1lIGNvZGU/IEZvciBteSBvd24gcmVmZXJlbmNlOiB0aGlzDQo+IGludm9sdmVzIGNhbGxpbmcg
dWZzaGNkX3NldHVwX2Nsb2NrcygpLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KUnVu
dGltZSBzdXNwZW5kIGFuZCByZXN1bWUgYWxyZWFkeSBzdXBwb3J0IG1hbnVhbCBoaWJlcm44IGFu
ZCBjbG9jaw0Kb24vb2ZmLg0KSSBhbSBub3Qgc3VyZSB3aGF0IHlvdSBtZWFuIGJ5ICJhZGRpbmcg
Y2xvY2sgZ2F0aW5nIHN1cHBvcnQgaW4gdGhlDQpydW50aW1lIHN1c3BlbmQgYW5kIHJlc3VtZSBj
b2RlLiINCg0KVGhhbmtzLg0KUGV0ZXINCg0K
