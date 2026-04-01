Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE0223328
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049085; cv=fail; b=Hs2c7e/I+qrpPD0dc1LicKr316Ax/pRRQHRVy9/zHeoKf4XAokQNHNkiY361CbVQMZh21Tjp1Yl8XdifuVU6+36Qu5XmY2Tkee4nPG6XpmZn+H0N4e8BevA7tgm5EBtmv53BtOB4d9RUprFq1djzGxrNu//wbtm4a0w5bl6Qf+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049085; c=relaxed/simple;
	bh=mowUph6z/PkSe1kHWmxkdZdRn37OtS/1jRZe5DkFoVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JitfXns83rRxXXXZ/+kk/pCPQ7dAnGEWk5wFh5W/Q4rt7SGxuOveFgsPtDpvV4bHOrtqjM1TTFECf6o/WOczcxc/0hrc4DEtrOwgL7bj8nQ/iIk5X4UeKPRjOBd7tDhrM5zRSm3ihEN1GGDOQPI5VeFrqaN+T0AdbqohyTlgsbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=E2G2lv/2; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RnylWp/v; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="E2G2lv/2";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RnylWp/v"
X-UUID: 455619f42dcc11f1ae70033691e9ac7d-20260401
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mowUph6z/PkSe1kHWmxkdZdRn37OtS/1jRZe5DkFoVM=;
	b=E2G2lv/26JzVizlg4LsB3N303510TQPOuVekhY1Pmisjyhb76W6SkEPdBodjLrafhrLh1XciPFnH0FWZy/nDOoDMA2UZ1rK9GnrNBQ1SkIRkWN2HHgqOvheP8iyNDarkrlBsTOmqEFGnBIaUbudC7I892ji4+hbpaiXs8msWK1k=;
X-CID-CACHE: Type:Local,Time:202604012111+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f86f16fd-e583-4098-b56a-b0bf830020f9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:bcf6f38e-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 455619f42dcc11f1ae70033691e9ac7d-20260401
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1567574804; Wed, 01 Apr 2026 21:11:18 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 1 Apr 2026 21:11:17 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 1 Apr 2026 21:11:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yiYXhExu0p4g8pFQT+kHV/syCs49hg3RTcfV+rsW8AZdYDWEEwZDxz8hrCFixSuR8pFkZVlfzBItvjCSYnU+4L1Fg4unzwXT0pbVAEviWVmlalLiy13vrg9yyN+O98sOfsAQXCWImSDFP/u/Uv5a4hu1y8zYGsOjboZYtF+jynHj2P4OQNfa4pb1IeAaAmRiXC31HkbhceMqZGPFUJHroQP2ws4Qm2iLPeeJ47t2RKgIZkYZHTy0EgQKA02TBOXtNRmaGg0nEsEAMU9boeDgQ8WEWA67bXRqEFNUwgXnDeYjxVevI1SujPY0vpcfKuN2y3AWqB+fU179g2gMzlEbZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mowUph6z/PkSe1kHWmxkdZdRn37OtS/1jRZe5DkFoVM=;
 b=b3CKBKt9gmqXGSllRhXYakHnP3ICyEE61m7/zHz72xiKr3oguqKWzFJWzqiiHzaqRdAqSPscjlShpCfSFz03c7rMo8xOrPGSAVfm/Mcpjvc5PvSsRoO2aZLhaTQUbtAEXWE5xP37GkbhjOeFVouorcMuMlzs6UnHOCbmPhdtoTAc3LyHxiswGC8DMr5YMaFTgJAKE2ZFn7cT948vtJtGzElHVLZ4K/vFCUp+Iu/uw7RbShseczfScP0iBrxLKh4JaLi23PNQ1/0mT9x1s4f9w1V+7HGR7mWTcc1qsxwtHcQk2iNQGLhHrx/I6o4uP7b8sUk+3Ysmr3V17EnS/Drolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mowUph6z/PkSe1kHWmxkdZdRn37OtS/1jRZe5DkFoVM=;
 b=RnylWp/vLare5ugn8F2TnEGeDfyhQrAUV4u/U1rzA3xU7azHI7cpF3OsX6fxTEjcvC2zMx+0g3PV3KZNCj7FsSMjEtvT7LcPSqt3JOa4rcjVCn/EaqS28GrctjOMM4SgRL7Jar5GQ1lh8AczGpHGGO81qGg2fxXHG0XbGfqYQYk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY1PPF538CF1BBD.apcprd03.prod.outlook.com (2603:1096:408::a57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 13:11:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 13:11:14 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>
Subject: Re: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Topic: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Index: AQHcwHPTaq/YlHAI7USfheU+xp3IirXIZMCAgACkUgCAASgPAA==
Date: Wed, 1 Apr 2026 13:11:14 +0000
Message-ID: <3d2ed2d4027f508c48897c40d11d0cc905568feb.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-3-bvanassche@acm.org>
	 <b76180520d10f2811c072f0944a0864e779e3868.camel@mediatek.com>
	 <a043946b-14e7-43da-8b68-dc47a08c12ff@acm.org>
In-Reply-To: <a043946b-14e7-43da-8b68-dc47a08c12ff@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY1PPF538CF1BBD:EE_
x-ms-office365-filtering-correlation-id: 696fc24a-451e-4806-e086-08de8ff02768
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: 30aUxFtRExRRLMdjJnVyTVKILbeyPDH2Wxn/QLrE0JjhGxPXxr4gpne45X0BXq+D3MjGbAT65WxqNmq6eMyszQiB7v9xsbYhqznittqErPhtsecTy0lJv4byA2xiEBbO38D8aAL2MwvQ5RkYN3UCCng1Ijxwclc1Wn4SHarJT/OvqUHdYd3bghqhlLIaVSiyyl3oSf/v+O+5ai1s8Ac7y0L0eaSkyFy3PrVnP0rILsu1PN62EICE0yZijjG/4mEIm7/ZzI8tMGTKwFOnjKr3ZxobYvJxwE/paZBBRu2ikEckLFg2p/0QNTyhWDqUb9u1HF4bWqIvfPtn7fIOHJ8+MasCX9Kd9vx/1cyRw05nyZJkDZuGvOoS6pMnj3AUp4IUysWFa8LJJAWsQlJ5m3u+KxXk0YmeAlRQQX+e0OkXHq7+KBbsHiAucIaY+TltNWwA4WdlxDD0tkv/T6REcWR0l5DD2969gkI9tgUS0eoi4C/eHUawvEPobFsjrXcFK7rQ5a83Um4yywqJxr0PfTLm//G5KYpZc5XGqlVtuinABzjVMtp5FAwkeU1EKjeH+hsSHuFcQdJYRnbKqzPMMl8yPLFDG3FVavPSSNK9G5UUTwW5hPAuiIti/O6sGJeqxZFDDDFa8fc6EkC+ksYZ9vVNyGABK6g7SPuW7qPqVMrvHtAKXFNLmZyxSznuFBYBp2iLYe5yY2LMtE2SCR4GMm/bpY5/SKXwIv9qfu7b403D2Da7EBS67cRrgl2H/ZYRPudrNZLsY7k09K3qL4F0kRUuPJPVpUi60vy+XIWORexHmjs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzV1eTZGUnl5aXJ6R2tQK2hjdXBuanQvZE9ZYVJTSXAxc0FNaTNmUzhmbzBM?=
 =?utf-8?B?ejRLNExGSGFlS1RPK2NOWWtMRGRQK25wOGowdHhPeEJsNWNCMVVsQ0U4ZGpR?=
 =?utf-8?B?L3NDbjM4bVdBWXExV1hUUFMyY1oxdWlBOHZvbTRtTjl6VFhLZW1zMHFvNklZ?=
 =?utf-8?B?YTMyanZGYmlXQldMS0RRemtJSVdhMjBDRE1FQi80T2tXQ3pSSEd0cU1hTVNV?=
 =?utf-8?B?WGFBcjJ4VENCLzhGdW8rSG9mSkxnRFNNM3k0YzBEZWVpUkM5bWFXV2hUWnNx?=
 =?utf-8?B?dmR1Sm1oZXVBdFR3OVg1TUNPTkNkajhXQk0zSFJzT2JmZ3R1ZFJDV3N6ZnU0?=
 =?utf-8?B?am95ejc1UVJ4bUR3U08vdmQ5WVhRUWNqQUZKWkVXS0xpNWJabk0xWFdXWUpn?=
 =?utf-8?B?aEJILy9LZVhFelBVUFBjM0l2RDJwTzNxbkVXSTRKVWZkOVhLMUYyQ1c2V3g5?=
 =?utf-8?B?ZFJKMkRQTGFkK0dXL3BvK0pRbkNyYkFHYTM3Z00yOVhSMjBFRURpa3dzaXlu?=
 =?utf-8?B?U1F1SUxmeXhuTVRLaTJsaUxHTnpoaVRVQWV1UFcvU2h6TnF0Y1RSZ0dlaEc4?=
 =?utf-8?B?TmJuc25DRlZpYngwSjBNUlJrbjJRU2c5NHhUeEFtVm83a2xCcHUrTGFleS9o?=
 =?utf-8?B?VjhuRjVwMkQ4M3BDSS84WGtIT0J0S0I2SmRScldIWU4zcXRGSzVPdU1iNXU0?=
 =?utf-8?B?U3VFNHRGSmdEeGQrZTdCWHBFRVlaZ3I1Si9RZkxBamxSSy82bDlWNXZoT1k1?=
 =?utf-8?B?My9FLytoT2VCbit4YnQ0VmpVaXNlK2V1NURnaHdJVTVtRWFEVWp0NHJyOGdx?=
 =?utf-8?B?RWlKRWttdTNMODNxNUdzcWFDcDlXVmZMd0Y0N3l6T21abFBnTkxqaUlCdDhM?=
 =?utf-8?B?VzF0SFBIV013c2JNeDRnWXBYQ3VaSy9Vd3NKSnJmYjJTRmdUR0NLODhzc0xI?=
 =?utf-8?B?K2RpelRiV2xOQUtybXk3Ny9kdFdCcTZ2VnJMVzlTbmFNeStJdHRMMDhGU3pk?=
 =?utf-8?B?N0RSS2JENnQxZGZDNzlFN3BmemUyMlJ0L3VkeHNkN2cvdWRGTFpWTDVQVFI2?=
 =?utf-8?B?ZU5waDRkb3FDZTlJODJORVEvUlFENm8zRE5FVDloVEZIN2lxMitiRHdTQ2Zu?=
 =?utf-8?B?T2c2enFXd1RaVWgwMDFyWG5jNGJGZmtLUGYyQnRFY3BSL1o5SnFzaHFLbzRX?=
 =?utf-8?B?WUhWR2ZMc2I3UzRLcHU5WFNUTlVIamNGcTcvV3BYU3BGRGhYaS90dFhJNTFQ?=
 =?utf-8?B?ZU95eGdUWk96enBCWEZkU3M3cWtCUUFpOVNGQ2xYUWJ6S05MMzFjam8wUUNr?=
 =?utf-8?B?WHA0TkxNSXJwWXpiNnIwVjUxWExkWlc3YVkwV01SenRTeUVlWTRpVjRRM1hT?=
 =?utf-8?B?Y3dINGMrVktoWUdDc1p4dWtyMVE0Y3NldU9NYlJsRmp4YVdpdG9obmU2Vlg3?=
 =?utf-8?B?OGpleGs0L0UzbkNHQitJczhtemRhajc5NG1OVXM0UlcwNHFCRXRrVXFQdkJh?=
 =?utf-8?B?Y3ZKeUptTmlKWVZvYmEwNW9mYnNQWjZGTzBYQ1FQeUtObnBXMFRld0huLytQ?=
 =?utf-8?B?Y2ZCUlo5SzNiRk9zWk5jZGdXZkh4ZHJENTdNRWdDL2c2MGUzRVBCZmR1Q2lw?=
 =?utf-8?B?cG0xSmdLSFl3RnNNT2RrRzlhR3VFMGNhK2t6L01UbkN1a2ZTZy9LeTRNNVN0?=
 =?utf-8?B?VnpwR2tLTzU2NjliQ2dhaXpYTlp3NlczakhHZG5KTTUwM2M1eWF5NzVpM2tr?=
 =?utf-8?B?aTVKTmVEVk0rMDB4Ynh4KzhLYjB4eFNBUjhNY2V2djFyUWdCZU5MRXF1enlO?=
 =?utf-8?B?bmRwTi90NXZDRlRGY1RuaGFQWXhhNlJVelFnN0o1UXFBaGYxSGMvdGdOQi81?=
 =?utf-8?B?MklodjdneXZ2SGM2dHdjcnQrTndmVnBjTlo1TzYzeVBnY25mUVJUYXZNdmlL?=
 =?utf-8?B?M29POUlyaUx0SzZUblJuRmxrQys3OUk3VVJhZFczV1JBbmFmcm00d2lZbzYw?=
 =?utf-8?B?MmlyOWpMMFVLVTM0U0krM0dUZkNYS29McFBtMFpTQklkWTFQM1h4UGJqYUdL?=
 =?utf-8?B?bXoxU1picmNmbHd1bVh6S0h6cTFaeFdXUFJXbnRsNWg0U21Cc0xTNEVXMHl6?=
 =?utf-8?B?QWh4NmcvYW9JQWE1Tno0RHV2TUhGVzBpemlUZVZ0VjljWGZPTXJjNDJaN3hT?=
 =?utf-8?B?TWMvbmNKUlJqR1M1dXB5akI2ZDBDQWxuQk5rd0svNHVROFZvUDdEdG00bTBF?=
 =?utf-8?B?UzdVM0RSMUF0cldwam94bHVsbElDVDFwQXNqcG03R3d4dEhNdkJnR2ZYRWx2?=
 =?utf-8?B?TVdMM1VFS1RRSENDUHdkblFDTU1DekxnMzVLeGJLVGlBUzF1NXJpTW9vZE4x?=
 =?utf-8?Q?ND+VFOXPXH10llzQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D13A098D4B75A4C8D6342E35C54FA29@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Yoey/wz6b5YUbAMMer7HZu9CvquuZwuqJJGZwa/gUGrCvgKeWuBZpD/XDN/ueeyfNVkxAn5EIxlgtyy3Ac8W79Zn5f3QuzKFQnyDLOAqDYkwSAzxTvt4hGxOLU/VO7K9hUQXoZrUcZlo2GJj1jrXqwqOOzlhyeD/BTX07+8mFV5aC2P3u21QkRFH42Htx+aVURb2REfAJxx9q5DdJ668UAwuApvZz0wPGTKdHdHG/87Jmc6futozgX4mcbx6/1RMzuce9WoqC3iY2xRiSGsm6M6gMv6x28dtYiQpp+CNqUfjvdG4Yw0v7rWHAIEG58RNpXx1+3at3PSigeC5Toemsg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696fc24a-451e-4806-e086-08de8ff02768
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 13:11:14.9261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HtUY270WjPJJhxca6aA3qzjxPxj5jDz/P5LtZUTaDBTKTqzxxpJzeyUjCaEXKhmyLj/t59xPK/LT7UtIr4WEgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF538CF1BBD
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTMxIGF0IDEyOjMxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE5vLCBiZWNhdXNlIHRoZSBjb21wbGV0aW9uIHF1ZXVlIGhlYWQgaXMgcmVhZCBiZWZvcmUg
cHJvY2Vzc2luZw0KPiBjb21wbGV0aW9uIHF1ZXVlIGVudHJpZXMgc3RhcnRzLiBObyBtYXR0ZXIg
aG93IG1hbnkgY29tcGxldGlvbnMgYXJlDQo+IHB1c2hlZCBvbnRvIHRoZSBjb21wbGV0aW9uIHF1
ZXVlIHdoaWxlIHVmc2hjZF9tY3FfcG9sbF9jcWVfbG9jaygpIGlzDQo+IGluIHByb2dyZXNzLCBp
dCB3b24ndCBwcm9jZXNzIG1vcmUgdGhhbiAoaHdxLT5tYXhfZW50cmllcyAtIDEpDQo+IGJlY2F1
c2UNCj4gdGhhdCdzIHRoZSBtYXhpbXVtIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGUgdGFpbCBhbmQg
dGhlIGhlYWQgcG9pbnRlcnMuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0
LA0KDQpZZXMsIEkgZ290IGl0LiBCdXQgSSB0aGluayB5b3UgbWVhbiB0aGF0ICJ0YWlsIiBpcyBy
ZWFkDQpiZWZvcmUgcHJvY2Vzc2luZywgcmlnaHQ/DQoNClRoYW5rcw0KUGV0ZXINCg0K
