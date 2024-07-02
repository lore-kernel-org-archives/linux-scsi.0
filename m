Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E612B9D8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901398; cv=fail; b=V3gQAkTTUDuzvjP7yPxXSmurdmxS/9MrU9coOIiku6toZ34lD4wnIfjE0mzwgnB/IUDNmITGDrIEd3Te2HTgHK1LEHSjpUi7/qZLPOctsSlr0NRdQkydJ+0KA5+iqoTefCPDvz+tA4E8PQAMmky4nP1HfMUzjIWkJ6dVCt5sBD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901398; c=relaxed/simple;
	bh=ejKGMHBvamYZkEbd0+5jOyWeVR40/GVaB7dzOlJHcmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YVgel5aIZiA0qUvgrOJPRi1nMrSr1VuJG4fyUUiDwzmaEMxREp+ous1a7IIrIF9Rnj+i0rRMOg9ObWmWDTDzOyNA4MwzwhFoLxkw1Nlzxbr8eLsaI4/IGj8fETuoLhnoV7QBc4yUzHX+N+epznpW02REdloPrtyR5Y6xX/KNmlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MFVXWTni; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YAgHTMAN; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MFVXWTni";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YAgHTMAN"
X-UUID: 8f13ee1e383b11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ejKGMHBvamYZkEbd0+5jOyWeVR40/GVaB7dzOlJHcmw=;
	b=MFVXWTni6q+HTN4In6BKaOi7GemuRJglQnfPMJqueJKspocv/ztWyl4+XssMxnGv3Gr9m6BuRS/zfWhbkHLwPRvK43ADbQyCab0KlQzl4ENMStW1SkMOdAbNfmhTTO+dMtYP2J+0aVBJEHwlJExQj+NpUOIHCIM1uNgMP0f8zUU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:cb7894b4-8474-4dd2-8465-6462607db419,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:a0bbcd44-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 8f13ee1e383b11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 253823602; Tue, 02 Jul 2024 14:23:12 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 Jul 2024 14:23:11 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:23:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEyXA8ShfOHML8AEvnarSoOkX/X1edzjpC2Idj+pLpmDY+IzaliF+7bAP77Aqv/tQccB0CTCjkEhFMwDI+3jv7p8J3AvSxkrTNCSIAEIc9ACeqUZVoG5Bat4NrWt7f3u80iILjdrQyRSxc8wiZ07kvRnO8TLpJnB87xfZZOmULB4QWn0S8sveD6J3QLR4xX4CwzKz506C3Icmbjd8IDBLeKLmWp9j3szuf4/GRi2hHIwQ9YoxMOkB2qDGM9NNH5ni0fZQVLgn5qEyQiRKpRfNJyCbYJhCevXtWl3js5boXp3C3o0YE9s3wktnOvqQwmkzoCWrpIpUq3UsN7rBYbEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejKGMHBvamYZkEbd0+5jOyWeVR40/GVaB7dzOlJHcmw=;
 b=BVHpM/mlWOJ/wslGq//wZWius0FMNtJE4NWtPeh35nt2pIklDD6lAFErc1cYrtwsZvlLVSQyQFndF2qW030piugvaZe86sHBBLOKJ20I51YHNzVgSAiRMKyX29BWELzDDGuh08856pQ38miUQ7Afr0XM6v0/i8F+cIK5ozkzAC+U3tJ7lhOr4g7VfNg/d9Zk2JCrNVSfGnYKZh+hY/GPXlNLSS0zi/8Vs/C8Kxzv7PYQdtzqcp1JeSPs1zdRkIMN5aheCnmFfOahGoDrycuFP/wbs59Xtb43K73FX5qGmSM6gSKCR+edo50lhXb1nIu5C7nP6RD+gZMqNCpWQEUdHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejKGMHBvamYZkEbd0+5jOyWeVR40/GVaB7dzOlJHcmw=;
 b=YAgHTMANdA8tcN3fq3bBpewFQBrDcErUqOz5oHuXlN7SE/k0auWe+NIjOGI7QrJ87RhBflCHNabSWMKvqrxjYfIe8ujMXqKhuuicCyowp1PDEqFCyrbpegZ7hiHwaXfhMZixwSOBcI2iCX/nTRJ1WqfLT73ygYIxAk0n7uvW7dk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7708.apcprd03.prod.outlook.com (2603:1096:400:432::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 06:23:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:23:08 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ahalaney@redhat.com" <ahalaney@redhat.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "akinobu.mita@gmail.com"
	<akinobu.mita@gmail.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "daejun7.park@samsung.com"
	<daejun7.park@samsung.com>
Subject: Re: [PATCH v3 2/7] scsi: ufs: Initialize struct uic_command once
Thread-Topic: [PATCH v3 2/7] scsi: ufs: Initialize struct uic_command once
Thread-Index: AQHay+E9AqR0Wb9XO0eFDT2mQVoOurHi+NkA
Date: Tue, 2 Jul 2024 06:23:08 +0000
Message-ID: <e536823e6fddb381a7f80be9298b438fbd19ddf0.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-3-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7708:EE_
x-ms-office365-filtering-correlation-id: 6663134f-26a1-4a3d-e412-08dc9a5f7112
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?anJUZEMxdXFtMEgwSi9uS3V1YnowMlZpOTJuaTFheUd6QVQvclRmekl3djRH?=
 =?utf-8?B?Zm1nMkc2RWJqTHgzcTFmL2MwdTYxdDY5cW9ERTZsTGxqUzdkOVZkVkF3VCtE?=
 =?utf-8?B?R0VBUkpEQXlsQm1iMWg4NFhQR0FMdG1ZTkRJMTBURVNTNWlzRGp1c2FJVXVt?=
 =?utf-8?B?M3J2NjFSMG5selo2SHgya3ZqVUNDcEtWZU5KNTQ5QmRUWGJYeGhmM1pXa0Nu?=
 =?utf-8?B?TjE0U0F2Wk1GL2lWbldvSkpMQ0JYbXh0STBBVjJpKzZVTkFXUm9oOXdvQnNn?=
 =?utf-8?B?ajJJa3ZGRG16cko5WmNlM21SQ1NLZFk3bk9iOU43aGVhTDBITUFTVEs3d1pQ?=
 =?utf-8?B?dHNtRlFlblh1cytBd0E2T3pxSVdVMHBvazdCRjJCd2RPTWhFS2tLTi8wTzFu?=
 =?utf-8?B?KzFzWWdISDFpOUpIcGk5OEtnY0sxdkFUM3V1UW1DWmxPb0h5dXVxQ3JsbnBE?=
 =?utf-8?B?NFF0MlZMR2kzKzdhWkJuS3JDd0MrNUxIK2xwUW54b1UrNzZjRmtOOXdlWTVx?=
 =?utf-8?B?Z2w5OGxvalNZWW5rZENNRnhmTFZCSzVkT29Hc040Z1MvaFBRcVhSS0VLMXk5?=
 =?utf-8?B?S1Z2ZVh2bGVuYVBhanAxQ0hTaDU3Mys5Y3hZYXEvRXdSa2U0SHBWWVpxQ3hk?=
 =?utf-8?B?WFpJQ21hbjNNY2kzMWkyQUZMQzVOM3UvUjNGSmxHWE1EclhsRmVESlNOcUlC?=
 =?utf-8?B?Vk96L25ZNXd1bDlWS1doYzlxOXkxdkRaZUFQZmV0WVlLU2VvREJzQ1pFRTFC?=
 =?utf-8?B?Q1g2WDBhdzNXN0V4dVZCbTZTbUVsekZtSlZ0M3hVQkVBTVloNURRN2xtM2hL?=
 =?utf-8?B?bCtiN2JEYU9sK0I2d1d5STU4Y0NDb1hOYThCTmhXU3NnT0x5WjNYd1QrM0RW?=
 =?utf-8?B?cEkwNnpXd09rWTJMQi93VTFUeGJUN1d5eUlSeEZrdWNnQmNmNVZ2ZFhzRGlj?=
 =?utf-8?B?K3NEOXhVb0FqcTR1eTNsU0JwWWFWbW50NE9aWW9RaTdyNHB4aExEbHlvTUU3?=
 =?utf-8?B?aU4wbG9hTlJWQnYyWGxkaXZ2VEtxbnhOVmVxWDhaUjcwWUo1K2hNSXJxdEJv?=
 =?utf-8?B?WmVHM1p6WlY0Kyt1czVkVkMvdVAxNFhzcTJlVjBSWEc3ZGpNdHNHanlBY3By?=
 =?utf-8?B?V0R1K0ZRUjZqbURrMWRKK0Q4Z3dXcjJoenhYRXU0T0xUVHd4eDlyUC9tcmJJ?=
 =?utf-8?B?a013N1ArR2REbmVLYVczYlRoQXdjUGZ0dzBFVk4xMWxRN0JCOWFCdlRnRm1Q?=
 =?utf-8?B?QnBOV0R1ZFhsZXZZY1lmakd4Q09zUUlKSy9MM0ZFTUY1Z3ZIdUZXSzlPMFAz?=
 =?utf-8?B?ZVh5K1p5RzhNd1Q2Z2RIaURmV253Y3FnbXh4VjkzcVFEaW9DRTBhdDQzRjI2?=
 =?utf-8?B?alBPa2VuMVFwV01OTS92T2trcCtBVUhFS1RtYytjU0xmL2RobzAzdWxaMHJo?=
 =?utf-8?B?aEtITEowM05NNkxGMjRzT0RIaUZiWTFSOUo3MVVIOEY2L0pSN1VKSE94WE1N?=
 =?utf-8?B?ZzJxY2trcjRxRXBIT21wdUhYWk9mbDlQbmJ3RnZxSEhURTNEWHFhL2NaaFFo?=
 =?utf-8?B?MDNDSkVxdU5FU2FmeVlVYTY5S0ZZb2RmeFh6NElwLy83ZVRYdGhPekRCVTNp?=
 =?utf-8?B?M1RBODVFUWVLN1VWWEpWc05PTTU5OWRQQkpScWt5eEZnSjgzbmJ6WXBhcHY2?=
 =?utf-8?B?NjNUdmNtSDNPeVFTbWJzQlZFQkhGclBKbDVmOS9Lakl3OVgzYVM2Smxvb3g5?=
 =?utf-8?B?UkZCUWRYL0ErZ3F6dlZZQzFDNEMydmlUaWg4Mkw5Vzgxc01EMHRSUHA4NXZQ?=
 =?utf-8?B?NHlSaDZCRU1kejllQy9Gc0ljTFU2dEEwTmhvUTRkVXZsRm45UkRKVmlsMGlX?=
 =?utf-8?B?SVNhY0xVbDhuY1lVSWRiRzRFb3QrNjZjcEpmUFA4U0NEclE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjJlU1RLc0FWbGN5aFNWU0FJZk9ZNjI1bGw3WHFNc2FTS0pGUVZDRE9CQVQw?=
 =?utf-8?B?OWpDRFNHd29iU3pQeEF4OThTN2NvMVEzZGpjdVZqNVJtWkJxSHR6NUlUUkVn?=
 =?utf-8?B?YnA3aFRvVnJFR3BuT0pPSUdmQlFBdVhZbGg3K2dvMlJIcDBRanBsS0xiU01W?=
 =?utf-8?B?bEI2UDJuaEJERTJMZGZWM3NZdDQvdlVnbnNEVW9nVTV2UzZjVUVmZHZBRDN0?=
 =?utf-8?B?VnlPKzd4SUhBWlZpL09IcDhpL3ZNRFoxUCtqWTZFNVNOV3hCclo0VmpNbG9P?=
 =?utf-8?B?NVpnc3hQanZ1ZVN2VUhuT3QvVVNZWmo4QnhFK3JQZVQ2VWh2dEVOcVRmS2VC?=
 =?utf-8?B?bGkycG9Tci9Lc2F5clRXOTdPM0RoaHc1SVNIaGF5ZFNQYXZSS2xuVEU1QmZO?=
 =?utf-8?B?eHlrdUxRZ0dveVVlekJ6eVU5dUJYWFo3STFjUHMrRHJmVDRkS1pmSG5QN2lw?=
 =?utf-8?B?MVFnTTVtUlpFblk1U1YxUnc1RnRodlY2MitwTFBDLzU3VVYrYVdLbnk5Nkdq?=
 =?utf-8?B?bjlRYnZ5cjdGc1k1ZHRUWGhLcFFYN1BDV0ozTm1vQXFjdk1RWXVpSWd4S0hQ?=
 =?utf-8?B?TVhodEwzTCs2Skg5ZHA2N0I3RjY1Mlpzck9aclNZMENpb2tOS0NyalBpZlVT?=
 =?utf-8?B?NktkZ3NhU2JtRHpDUjdTdit6VTJEQzJlamhSZVpDMTFnVytrVEt4VXFrRzN6?=
 =?utf-8?B?NGtoR0o2aHdYZWdOZHBJTmZMZ2FZbHpOc3FKQkxqNjJHKzY3RFMyOXhjUnRM?=
 =?utf-8?B?UzlORlM4Um96TlVWdktlY25qejdJRm9zNVFZUCtvR3BSTmU2S29HMFRKemZm?=
 =?utf-8?B?WnA2Sjk2RUo3VWhJTTZtSHZqNXNqOWg0RjBZT0ZGc3dLSUhrUm9neWs3SmU3?=
 =?utf-8?B?U20relR4WlJwVlZOSExTNWREUnREL0hVTHpnSXo1MDN4Y2h2OCs2b1FvS0VO?=
 =?utf-8?B?V1NDMmV1NmpFOXdYMFFhTGUzNXI0cmhiNE9UU1FNMDc5Z2g0RmR1Um12NVJL?=
 =?utf-8?B?L0lPUmh0VGZSeHYvTUJiVFlPZDFqWXh0dEVLdFNWWE9wMXkyWERsMWFRemxP?=
 =?utf-8?B?bjZXZlhaN3RjUXFJVStGNzdkQ0tVTmp3dDJ4M1NOTjV3VjlzYXNWclBhclpE?=
 =?utf-8?B?Qk5wS1dEZndlUjFyWENUWTBtWGR0eXNRb2JwN01zNllZY2djZjh2RlpwRStu?=
 =?utf-8?B?WDF4dElkWXVDMjg4ZE1EUWtjeW1ERmdiQmVKYXhFYUM1Nmp4VTlRQXpIZXNZ?=
 =?utf-8?B?WkhHL05ndHJXOWZvdFc5b1NNKzQyU0NOVjdVdnJnVXBOZDdUaEZGck1mVHhs?=
 =?utf-8?B?bjBYOUx5eXh5QjJ5SUQzMUtZZEE4U2I3UksrcUZ6eGw5S1hTRDdHUXZGOXBQ?=
 =?utf-8?B?am40a0ZVbXZjNDl1YVp3dkNuc2FyQVc2MC82Wi9KNXd2YnJYRmpUL1FFZFpn?=
 =?utf-8?B?WUZaUmhZMU1FWk1GdXBLSWYvdy9yUTBlQUI2REdNekQ2bWVzbDFwMExPVGtk?=
 =?utf-8?B?YWtVbll4WFRXUXJRSUtEY3VwQnFQLzMzcEZ0MGRPalQvNzhCaUJqQXRsQWp4?=
 =?utf-8?B?MkZORzhUQWtCZk9ISW16NHc1TEZpZHlySWxzcmhjTFF1ZkN0N2NKMVNkdEdF?=
 =?utf-8?B?ekF2NzNaeGcrT3pxWkthVzc0NGdyd0lLNmVONmdtRVFvRkFweWw1U1hjZnpR?=
 =?utf-8?B?YUhJdzVHQVZvcDJTb0V2aWdSMTRvWWJOMUNYdlVROXJlZ2ZjYkQyTUd5UzJB?=
 =?utf-8?B?M0RTWS9DMlFQRmhBaG9QaUpLRkg2MmVLelp0Y0NZOHVJeHFQNmxqaFRNRi9x?=
 =?utf-8?B?cURzRHppNE1EUi9ndjJqcHlxQ1JyQVYyR3JKT1VURnhvUTlFd0Q4TS9RUWZ6?=
 =?utf-8?B?aHhkZEh5b011bTVEZGVnNGF3TEd2SVJ0czJadlh2TjBuSGFaYWxnM3dVQ0Iy?=
 =?utf-8?B?Ni8rb1Faa3VlZ0E3UDhhQXRqenpJZEtFdDU0aDFjRkl3QVdoalF2VHZWY1JG?=
 =?utf-8?B?anNRM3k1QXZLV2Z3RWduWUcrMnZXUVVSbk5Mc051Y3NzQ2c4akkxKzRKT0Nv?=
 =?utf-8?B?ang1Tmh3ZDFHTkw2aVBzVHljZTUzbmxxRWY4NGVjVHBEMmNWV2VBQjgvMC9i?=
 =?utf-8?B?Nm9rVXJTeUs0L2Y0aGhjcGVWVTZiMFFwUTB0am5ZV0s3TjAwVU5ZaDBtSVhk?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52527CEB7A91854E9E90204CC537F32C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6663134f-26a1-4a3d-e412-08dc9a5f7112
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:23:08.8872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HR6AETnIWjZNHzBhgmfQ/jQZh7A8UPqum2XkLElYYhJWi6gWmtbPjQuoY7H6O7qOxFZ1I+FcDi7kuwcOUXCmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7708
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW5zdGVhZCBvZiBmaXJzdCB6ZXJvLWluaXRpYWxpemluZyBzdHJ1
Y3QgdWljX2NvbW1hbmQgYW5kIG5leHQNCj4gaW5pdGlhbGl6aW5nDQo+IGl0IG1lbWJlcndpc2Us
IGluaXRpYWxpemUgYWxsIG1lbWJlcnMgYXQgb25jZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBEYWVq
dW4gUGFyayA8ZGFlanVuNy5wYXJrQHNhbXN1bmcuY29tPg0KPiBSZXZpZXdlZC1ieTogQXZyaSBB
bHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+IFJldmlld2VkLWJ5OiBNYW5pdmFubmFuIFNh
ZGhhc2l2YW0gPG1hbml2YW5uYW4uc2FkaGFzaXZhbUBsaW5hcm8ub3JnPg0KPiBTaWduZWQtb2Zm
LWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gDQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
