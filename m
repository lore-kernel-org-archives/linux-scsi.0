Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9254E139D16
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714050934; cv=fail; b=pjJNK8Ld2wQQ6Ft1tkrU8g7gwFTeTuL9uJgt+vzD+Y3L4SAssQ5BH38w5AhR8KQhqArBMQ1pfRCn8bALuzXi3//u16voswfh+rDLS4NETBp4LiJflboCex95/le2JHxetMtq6ypv8jVFllucXf8+cFO9PH6OG4A6biG65ypSsxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714050934; c=relaxed/simple;
	bh=8YF1odXLF5bEV+XGiEHa68vD4GqJh6VmX2L+A7NdM8Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M8UAMjzULRf7mvBXW9PClDTx7CiH+zZlo8bxET2iGYuC2aWncBEd2wZgSN5p2RP3UcBzEXpDoJjzazWUBb8ifFRUvPg45xv+SOZWrw3Fbh/baueix6FwDbnNRraGGZ83zwqVlcdhWHhO3/UPURIgtIecLVXFqLRUvXkU06kD68s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bvCVNY1F; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=PTbk97cg; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bvCVNY1F";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="PTbk97cg"
X-UUID: dd9c7116030511efb28d91f3fd9a7a2a-20240425
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8YF1odXLF5bEV+XGiEHa68vD4GqJh6VmX2L+A7NdM8Q=;
	b=bvCVNY1FMwsgXZcz+uqaqqu1Sonksoe7rf5r5zW2a+ZbmRmqKH710vjoSlcfd101HTGdFnSNBE4axX6uR7Z4Y0vKIMGnkqawZkwyj8arb45ubwKLj030aMIAOsWQJv7/DG9QnySYrONFfX/Jv380vHYoHqxJ+Ex6yB3jwiosv7o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:b4e6f177-2d7c-4cdc-9239-89e3a88eee0f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:82c5f88,CLOUDID:6c260392-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: dd9c7116030511efb28d91f3fd9a7a2a-20240425
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1795231605; Thu, 25 Apr 2024 21:15:19 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 Apr 2024 21:15:18 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 25 Apr 2024 21:15:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yfbcm5vMnc0btSK/tmANNsiyo5NJMniJEdTKWRnxV5rm9JPuSIXGp4dj2Dn16l4yWv3YrVFl5KGgIw1L/rYUvq2YMfpPWzEokiN+NXRdAK+w3rc9/lZmzrjcuTiQvQJeRq9zt1AUbDvMuXcT3hWKk5LaIj2aoi+0S7tuB2iqznU6tN7+OuZ1tRKqTVEflc2HD/R5Bwx4si+MP2rpyd3T+n3X2sAG1qaWpswlOuXcZoKZt5DekwpsCKlfUovsFHoA3vywrVNgtKbaGVeVZFVbB8oNsprNxoK6MOytHN18jgExyZQUOahmYBMoIGbaS5w7L9Y0LOBI0iAOfJayF3kUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YF1odXLF5bEV+XGiEHa68vD4GqJh6VmX2L+A7NdM8Q=;
 b=H/Ktdj5KnkhUwKar45BHV/S7v/7z4Z8thSN/EqaeNpcYgmyFFcBzv2vgVHKNwldRBLwEnWq3mYYmudAjTHvZULFISspnDQKS/hNNryS9O6GoG9l0GSm6eLf/dvk/MbEOUTDX52hltF+pexyg+tjROIqUf/EBEXVHXU2NAdC2UXsxWGRtArOeFMQPyQDNoFur6bZRAvMSRCYRKcA9lWOk1zo4/OZkXUkQH2dNu9jOxw2diV/VTgtg/TMDFZfgtVpnEGS6xviU+FNodxm/Zj7jUD8sH/tMUoL6h5oWmRrArV+FLdCm/r1jRR5KRnpT+orW5Y5oDqaJ5RnKJ54mHVJyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YF1odXLF5bEV+XGiEHa68vD4GqJh6VmX2L+A7NdM8Q=;
 b=PTbk97cg/Q1qRSNDoja37BN8hl1PLxnPrQxGmIi5+S18UKvh7uhYfAuqJEXfkzwhk7d7m1Z+6ERF7NWI5NX3n6NWLy1DrRtIafSWA2hM1mgRO5bvaWfhvmrg6OyMUDyKYsQCWdiT3PwbcktttXhbWRrdTygD7mBzWRnvkBQs1jo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7309.apcprd03.prod.outlook.com (2603:1096:820:cd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 13:15:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7544.013; Thu, 25 Apr 2024
 13:15:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "quic_rampraka@quicinc.com"
	<quic_rampraka@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_sartgarg@quicinc.com" <quic_sartgarg@quicinc.com>,
	"quic_bhaskarv@quicinc.com" <quic_bhaskarv@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
	"quic_pragalla@quicinc.com" <quic_pragalla@quicinc.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Topic: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Index: AQHaagfdnu/7dWEB3EK21x4WVKWgnrEg9A2AgAfVtYCAAFrfAIBOVtSAgAHVtIA=
Date: Thu, 25 Apr 2024 13:15:16 +0000
Message-ID: <5e71880541ad80f545f045816ab9f13d4a89003a.camel@mediatek.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
	 <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
	 <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
	 <768897ca7336df5b159c7d39e467b5b74f49b3b4.camel@mediatek.com>
	 <2d0c0aee-0dcb-7ac3-907c-ee477d5fc376@quicinc.com>
In-Reply-To: <2d0c0aee-0dcb-7ac3-907c-ee477d5fc376@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7309:EE_
x-ms-office365-filtering-correlation-id: 3c014b7d-86fa-42f6-136d-08dc6529bfc3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?VEUwZk5aZ1IvQU01Vi9NTUI5cjRYenFKa1JyeUNpUFNlaHZ0V3FrbmpFenNW?=
 =?utf-8?B?OTBJamVwbzdRQlBDNTBzYkI5bEZ3TWxobzBSMmkxWW9TK1ByR2ZTQzBmc2h1?=
 =?utf-8?B?TFVuVzVodmdza2paSU9TN1FLdlpHY3M2eGxzMXQ1N3hzbmVIaDFiSkkycFJM?=
 =?utf-8?B?WVcyQjU3R3NaM0pjaFhFUjAyRUx3cUd4a0JnV0dWcGpmdFFFQXFLbXFUc1lX?=
 =?utf-8?B?RmRpUFZUK0F3WnZGS0g0ZUVEUTYweHJIUlBMK0tpL0hIcitZSW9TTlJLYWR5?=
 =?utf-8?B?VnRwTDlXZDVvdTdRNTJGajNvUzZTVHBLR1RHbWM1cVBtMU5od0lhMEo2Zmtz?=
 =?utf-8?B?RHk2MWJOUTJSNkVvbVJXTFBFM29aOHFWb3FuUW1rWldjUHZRRTdNbmpnNmlm?=
 =?utf-8?B?YjgvZktBQVV4UTJrNE4rRXBSMW1vUldJdUdOT3kwaDQwelhWQURFemtWVTB6?=
 =?utf-8?B?TmcvQ1ZFNmxNdDJ1bHVlRmIvWVIrdHR3OW1YMmQzSjF4dFdLNERlSDhCOVBW?=
 =?utf-8?B?VUJKMnFwaG1Xcm9hbklJT003U2lkbE5Fa2t2YUlIWWV1ZmQ4UEErbmdPNm5x?=
 =?utf-8?B?ck5uU2hpZ1FSTjB0eEhnN1hXeDR6ZDc2d1lYTFB6WDhyby9kM0dvcTZSRkNL?=
 =?utf-8?B?SkdUWnNjWHFoNHUzT2JUOHZITGsxU3FiVWpaM3RXYmVkdEJWRXl3bzFQdTYv?=
 =?utf-8?B?VHVwdEwxc0tuSnkzbEZNajlKNWROMGhlZXh4Mno1YS9rQmFnU1VvSlloZ2No?=
 =?utf-8?B?T0gzbE1tRm84OS9TMnFVUEVWd3lMRkJ4eWczSktuN0J2Q0VZN0RrbDY4NzBE?=
 =?utf-8?B?cFowTkRTRTgrc0gvS1cyWnMzaVgxTXY4bC9uajZWeWdtRmc3cVBhK2RuQko5?=
 =?utf-8?B?bHRNNll6TG5hdEZMNjNtZml3V2lTMXpPRzFZVVVvR0U4REVPU1M5VW13SEJp?=
 =?utf-8?B?QzhSTEs5TktoNG1WVjNoKzdPcEcyUWVkYmZOcW1tZ1R1VEhxaFBLeGZnRzJp?=
 =?utf-8?B?TjJhUmFzd2dOcmEyL25PTnE5NlQwQndMZlhlWE1rRW1yQWpwR2g3ZWoxb3Zy?=
 =?utf-8?B?WE9uRU1sQWtqZHoydkUxUVg3WHppMmtjZk1XZ0Q3ZnMwRGthZlRKaGk3ZUpV?=
 =?utf-8?B?Y3JVakwrUzdsTENmWnBwaHZuZ0lRNFBIa0JZSVUwOGlsYlAxUUhPdEdzT0RO?=
 =?utf-8?B?N0RBOXdyMFVZYmo3U3FkSVRJYklmL01odmRCV3VvcWlTYldJb3dRL2Q4SmlM?=
 =?utf-8?B?eGR0Ym1oWXlqbFpicko0T2ZpbFNvRjlVNWJuUDQ1VlVyWHpMay9qeTZ0eDVr?=
 =?utf-8?B?YWdHblRPVElkOVNIZG5rbzZ3UEIyLzF4UjhYa2U5L2tYcVhWWkVXZWpYajA2?=
 =?utf-8?B?TXpzTS9qT1JzdklOeHgzeUoyaGs1NzFHKzVwaWxEa2YrRnFIMFpSVnZHNkxn?=
 =?utf-8?B?eEc0ZDc0aVlJV0ZJMWV5UFF0ZStqQW5ETC9nbEsrTHBwbklkNmNuQU41Kzla?=
 =?utf-8?B?OHV0WTlYeExKcTlNM1grSWE4SytIbml6R3E4SStaSllOa0gwbWZPUE4wOVFh?=
 =?utf-8?B?MFl3dWlrTG4xaXZaZUtBOU9TcDFUeHJxSit6a1Z3Tks0aG0zOFNJOHY1T2g1?=
 =?utf-8?B?RlJoSnBWVlEyOXFrVHJiRWh5U0FKdm5Nc1UzaGpJMTUycUhjYWJLMDRpYlQv?=
 =?utf-8?B?MlZWeEN0SndnU0NaVDRDL2dVbVdpOXRYKzJ5eDdCQkphTW5vcUkwYmZKNkFT?=
 =?utf-8?B?RTEwcVE1OWZld056NGF6R09BN3RIb0hSUUtkOHRiZlBnenB3V0VQZEVaODVm?=
 =?utf-8?B?TFJxT3c4NTA4R3ZwV1FOUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEsyQkQyVStQbFQxY2xUa3U1ZUk3dmo1WW1wTG1PTFhTUXp4ajdlYXBHZHAv?=
 =?utf-8?B?aW5rU3QxdmovbDlWZE9LbGJxV3NmZ1RlY2dUMjRDQXkrUHFhNURwNUtyRUY2?=
 =?utf-8?B?cDRCRVBuVG9LL3BnV0EwdzBlNUYyOTZXSnBqeGQwbjhiK2ptTExCNmlWdXRo?=
 =?utf-8?B?QjcwY0h1TEpTZjBpakRNR3NFQWlESVd1Q3FjNDJQQ0JhK29FVEhMell0S2NK?=
 =?utf-8?B?V0JZNFMrZ1pFcHpPemR3aUs4R2JtS1pCN0ducElsL0JSU0V1ZXB3QzcwV202?=
 =?utf-8?B?WHQ1S3p1TnhldFVMeWt3S2swVnZVN01sK3JPb3dLZEdoZnhlUGNuWStTVEJQ?=
 =?utf-8?B?N0FqaVFsMUVnN29KUWlQZFZvY0k5UDhYK2lNNG83UkpVbXZLMWNuRmduaGx5?=
 =?utf-8?B?bUdkUlpEYUdURjVycUN2VEp1UnVsY3QrNUlqUEpqN2FnS05pM2NkbzYyZjRm?=
 =?utf-8?B?VnRKTW5XYllsT3R5a3lqM3M4b3Z6YWlQUkpSdXpYWFh5WkQ1YUFocWRPK240?=
 =?utf-8?B?ck5rejM2UElqQW56Y3lyaC9xTzBhd1F4bzBFazJyV2JsWi93VktTZDFFVGNq?=
 =?utf-8?B?R3BQc2tJZmxCZXpmQlkxZXNpQzhUaUVrMXlob2YxcjEwWVhmVFpuK3MxaytI?=
 =?utf-8?B?OVVvbVdEOFpRcktPTlRHNFBYZGpmcDBSRnFwTk9IcXU0c1BSS2hrVmI1SE1o?=
 =?utf-8?B?OXVCcXZ2bTJKWWFUWVNOLytkMXVJRjVrY29HcVdQLzh6NXZGWkN0Nkt2Nmdh?=
 =?utf-8?B?MUtxYkVyM0NQaE9iNzFWbmpFeGVRcjdldlR1SER5MWxNVGVibkpDRXlkM3pX?=
 =?utf-8?B?UXdaSHJ4RmFwSjVBZUloS0E0SmVsU2FXVGlvTEYzUnRXd1JJdUEvRzNmQ2Na?=
 =?utf-8?B?M3c5NTNkQVdvd1RqV001YUpsbnZyR1NKMlhXYzIyVmViUWt4ZWcyU0RPcktW?=
 =?utf-8?B?QURMaWR6dVp3NVl1eGh3ajBUMW41REtWcGJRNURLbExnZjhZS2VpcjR1cCsw?=
 =?utf-8?B?K0MzS0ljQUlOdnJpSEtQOU9Sb0lpWmo2dk4xWnVESFVHNERnbW5URnlMUTF2?=
 =?utf-8?B?bkZpVmx4K05waGlQY1IzNXQ1NVZ0aTk2WDNwT29qMXc3M1g0VldqRVJFcWFx?=
 =?utf-8?B?bkJ5RkNueUQ2WDFJRVRmdFlxdTVNYXlQbVFJT1Roa05LUzNpTEVVYlhCbm5r?=
 =?utf-8?B?citURVFPSHRFTFQveWtZdFZaQzhQUEVIUzNuV1JRZkhSNXovVmNaREM5Nk01?=
 =?utf-8?B?ZUNrTWlyNmdoMVdwRElza1B0VSt5aFlJWXg4QXcwT3NrUVhkelNaT0JDZnE4?=
 =?utf-8?B?Z3hWM2hJVzZpVE9WQURTd2NxQ3hMbjhwRGN6aUFXRUg0STNtOThWMnBTZFpS?=
 =?utf-8?B?L0lxNFBJMU5nanlpOG5wMjB3b2lqNXZWV21idVM2UE5QQXBjeFVFQjdMZXg0?=
 =?utf-8?B?WWIyVVcwV2t6NW90YmpETUs4VGl1bHZXNUc4WTVydGMxNHM4Y3h1YUxwQm1F?=
 =?utf-8?B?Lzd3UlF5aWZ3VWRteFhYK1FUcU9Rb2RuRm9iTFlvRW1DMUNxczNaK0FMT1JU?=
 =?utf-8?B?ZS9ZVnJwUkhlK2h5SjFVNXdKU1ZHSWFyeUgzZ0dFMldBRklHTm0vZkpvZmly?=
 =?utf-8?B?MGRVcEJkbi9pRmg0YktSRXc0YndRRVErc3N3QWhDUzVuTmljVlNtakpjcVZH?=
 =?utf-8?B?dlBpdVZHMThjU1Rqb213V0lFd21OcmFkL3BDZWMxNUZWQjhvQmtSVGtoVWVY?=
 =?utf-8?B?a2g0QjhBbmMwelJlWGdOaGdWVVEweG5abGhkVjA5QTZxU0ZaUmk0OHBUWC9u?=
 =?utf-8?B?SDNOU1dTVnl1Zm5iWUpBWWNjWC9jek94UkV3SWFqWUp2QkdmOUxadkd3WDMr?=
 =?utf-8?B?NHY3SGNFMWdWR3FzN2c3UTQvQXlvVHJXWXo1emp4RW1xWXlmZndqbXhleXM0?=
 =?utf-8?B?R0JsYjdOYVhQZ3NFVXZDZXZxc0pCRjFEc0lTZ2Jsc21reDMxaTVSWnAvR3dp?=
 =?utf-8?B?THhrWm1zMGhPbWNrNmlEdThWTGpqY1MzZkJ6cU1VZEFNKzZSL2J1VWl5QWZ0?=
 =?utf-8?B?cEtMVmhoNUlSL0FHQ0NnR05jNExOYVFOby9Najd1MmJWK3pZUHp5NENjeEtW?=
 =?utf-8?B?bjVKZjZyMGFUSWJTdmo3WGxFa1JTUk4rOWZHL3ZGTkQ1dFdEbWhSeTV4Q25u?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7F6931002816B479F54D5007595E951@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c014b7d-86fa-42f6-136d-08dc6529bfc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 13:15:16.4625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7S/Cbe+uqkQzTm5af19DtmsE4jqs4M9KW1cUJOQZuW9juG7aSK6rUxC1kmoGa+xNocr8a+l4Iu0fNAsLD0pfpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7309
X-MTK: N

T24gV2VkLCAyMDI0LTA0LTI0IGF0IDE0OjQ0ICswNTMwLCBSYW0gUHJha2FzaCBHdXB0YSB3cm90
ZToNCj4gDQo+IEhpIFBldGVyLA0KPiANCj4gSSB0cmllZCBkaWZmZXJlbnQgZHZmcyBzZXR0aW5n
cywgbm9uZSBpcyBoZWxwaW5nIGluY2x1ZGluZyBlbmxhcmdlZCANCj4gcG9sbGluZyBwZXJpb2Qg
dGltZSwgaXRzIGRlZ3JhZGluZyBwZXJmIG51bWJlcnMgYXMgaXRzIHRha2luZyBsb25nZXIgDQo+
IHRpbWUgdG8gc2NhbGUgdXAgd2hlbiB0aGUgbG9hZCBpcyBoaWdoIGFuZCBjbGsgaXMgbG93Lg0K
PiANCj4gSSBjaGVja2VkIGZyb20gcG93ZXIgc2lkZSBvbiBxdWFsY29tbSBib2FyZHMsIHN1c3Bl
bmRpbmcgd2l0aCB6ZXJvIA0KPiByZXF1ZXN0IGlzIG5vdCBpbXBhY3RpbmcgcG93ZXIgaGVuY2Ug
SSBhbSBjb25zaWRlciBhIHZvcHMgdG8gYWRkDQo+IHdoaWNoIA0KPiBjYW4gaGVscCB5b3VyIHVz
ZSBjYXNlIHRvbywgSSB0ZXN0ZWQgdGhpcyB2b3BzIGFuZCBpdCB3b3JrcyBmaW5lIG9uIA0KPiBx
dWFsY29tbSBib2FyZHMuDQo+IA0KPiBoZXJlIGlzIGEgc21hbGwgc25pcHBldCBvZiBhIGRpZmZl
cmVudCBhcHByb2FjaCB1c2luZyB2b3BzLCB3aGljaCBJDQo+IGFtIA0KPiBwbGFubmluZyB0byBw
dXNoIHVuZGVyIGEgc2VwYXJhdGUgbWFpbCBzdWJqZWN0IHRvIHJlbW92ZSB0aGlzDQo+IGRlYWRs
b2NrIA0KPiBiZXR3ZWVuIG1lZGlhdGVrIGFuZCBxdWFsY29tbSwgc2NhbGluZyBjb25maWcuDQo+
IA0KPiAtICAgICAgIGlmIChzY2hlZF9jbGtfc2NhbGluZ19zdXNwZW5kX3dvcmsgJiYgIXNjYWxl
X3VwKQ0KPiArICAgICAgIGlmIChzY2hlZF9jbGtfc2NhbGluZ19zdXNwZW5kX3dvcmsgJiYgDQo+
IGhiYS0+Y2xrX3NjYWxpbmcubm9fcmVxX3N1c3BlbmQpDQo+ICsgICAgICAgICAgICAgICBxdWV1
ZV93b3JrKGhiYS0+Y2xrX3NjYWxpbmcud29ya3EsDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICZoYmEtPmNsa19zY2FsaW5nLnN1c3BlbmRfd29yayk7DQo+IA0KDQpIaSBSYW0sDQoNCkl0
IGlzIHdlaXJkIGZvciBtZSB0aGF0IGlmIG5vX3JlcV9zdXNwZW5kIGlzIHRydWUsIHF1ZXVlIHN1
c3BlbmQgd29yaz8NCkRvc2VuJ3QgIm5vX3JlcV9zdXNwZW5kIiBzaW1wbHkgbWVhbiAiZG8gbm90
IHN1c3BlbmQiPyANCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg0KPiArICAgICAgIGVsc2UgaWYgKHNj
aGVkX2Nsa19zY2FsaW5nX3N1c3BlbmRfd29yayAmJiAhc2NhbGVfdXApDQo+IA0KPiBIZXJlIG5v
X3JlcV9zdXNwZW5kIHdvdWxkIGJlIGZhbHNlIGJ5IGRlZmF1bHQsIHNvIHdvdWxkIGhpdCBlbHNl
IGlmIA0KPiBjYXNlLCB3aGljaCBpcyBkZXNpcmFibGUgZm9yIG1lZGlhdGVrIGJvYXJkcy4gRm9y
IHF1YWxjb21tLCANCj4gbm9fcmVxX3N1c3BlbmQgd291bGQgc2V0IGl0IHRvIHRydWUgdmlhIHZv
cHMuIHBsZWFzZSBsZXQgbWUga25vdyBpZg0KPiB0aGlzIA0KPiBpcyBvayBmb3IgeW91Lg0KPiAN
Cj4gVGhhbmtzLA0KPiBSYW0NCg==
