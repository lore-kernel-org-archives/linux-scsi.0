Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8423ED75
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769153208; cv=fail; b=VHl2nuhoEAMIZUWqkvtV4Mi4Aoi8sF5iGeOHUhG3AInl9enCrgDFmy13Sm/gxOgFpZceEREJXMwAoq3EC2AbBM4qlKDVck8YGl2pVHtnT8Sq7S4fTsWalVN3Xa/092GRdFVfJAzcQWDsRgFiRsp06ouVslxZ1IfwacyiXsUsNq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769153208; c=relaxed/simple;
	bh=ijOARX73w39/4AzsioOzxeO2r1GlwBNSEqIsQYmxg3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j16rVx2wT4xjIxewCrNvXzMLGWW4kSy2Ya6iHSnqoNchm5vzczYPE+R7s518wqAAovGW7xIC3nPNCZR0dIc6Ti75094prbLmBwQ11YAHz6kKH7ON2GRnfpymi2ayNmWiBAlk/XlSFYZY9VkW7KslpkBGRcM4hBM0DgloHOYzxo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IusUhwa1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=vzZu55BD; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IusUhwa1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="vzZu55BD"
X-UUID: dad9ded2f82c11f085319dbc3099e8fb-20260123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ijOARX73w39/4AzsioOzxeO2r1GlwBNSEqIsQYmxg3Y=;
	b=IusUhwa1lP7/M68o71r1zO7u1FRvq4fe62ifJUtyq+H6nq5MvFkwD0RmTXGLV+0Q+5hullBC+heDBxk+aqnPMVMo/GxZR1q/sN29Q/PRG8KFviO/I8KUheKaw8THKAAe14N+2nn7z0xX2hMB0/IVoxjK9HR9YMSqIo7BUX4cs24=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:658fa7f0-701d-4d71-b156-22d5c806ffc7,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:89c9d04,CLOUDID:1ce1d9e8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:4|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dad9ded2f82c11f085319dbc3099e8fb-20260123
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1824403112; Fri, 23 Jan 2026 15:26:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 23 Jan 2026 15:26:37 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 23 Jan 2026 15:26:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oM5yErnK+olTU8M1O6v0ZbDS4nW8GSYezCflStoVzKniKdV1akkdTqDKEl0ENjZKvUMDBUqUMQOXwOiIJ4hmvB45IzAcIzrhxgS2oH7uOgo7IpefpynQzX5m94Zg/pgXLMh9x3PLOE5vm0nWHNVKwvSkNT4+b5d36PZAtIWXsW2hOAJpRQC5CccoB2zR6etsN5+K7WA0dUx6PGk7IcUPd8+4AIShW9PjmEagfjM8ZnyEEMyzNGfGlPVj+h3C3feT/uclT/LG7mDpj/rHHyYCiHvGCa9gAPDHRfD4Lh8mQbZVFhaUYU5TSPwgiZnlXOEt0fdaYKxa6bcckEJQtpipaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijOARX73w39/4AzsioOzxeO2r1GlwBNSEqIsQYmxg3Y=;
 b=Ik/zdDyf5+LDVbRTytRyIilhjFWyDGXOJUmWobUIDw3fv0t9BXj+cIUJWBXM4xQFUZIUrggYzdtESSQZfSJAg7LIIzQmxyGx5Mw8s42hKe83sOQnS2oKY2Xlo3wv7hZmPeolau48VIt27HWvvLoK/Fc3Aadr6qIdeFEaZ2th0VZZIQUiWpDnUfk3Vry6cK6Dw1JtoKAskEb/aQEUJBlubXs3+55qSavCdogGbCZrjdpr9o4POxWDWqvujFy1WrxJYrcoAS+ZK62BPDwJ01MZ0xMJJ4cJ2alyq+aRzqSeN7vtznDicRz6IzjRxo02zX3FbDi7TAjlMZLj2ew3EeT3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijOARX73w39/4AzsioOzxeO2r1GlwBNSEqIsQYmxg3Y=;
 b=vzZu55BDWmsyV/xYWO+/lO+1LqSbC/e5quh+nGlaTHIL1V/zxToaKcRi0wBTD5qTu3ZSajnBj8f/g208dCvnYPtnPrMN3NfKLxSb9BO74RvNGoqsAjituyhRw9Pak7M+uGC0UyXmi923ztFeotot26H9jFBSLYft/EAifPDOvTg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6628.apcprd03.prod.outlook.com (2603:1096:101:81::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 07:26:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 07:26:33 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "mani@kernel.org" <mani@kernel.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] ufs: Remove the clock gating code
Thread-Topic: [PATCH 0/7] ufs: Remove the clock gating code
Thread-Index: AQHci8TifHJljah/kk+EIn3dUw3jc7VfW6cA
Date: Fri, 23 Jan 2026 07:26:33 +0000
Message-ID: <cb72534c1eac0740e24eed7ca4207371f55bb273.camel@mediatek.com>
References: <20260116182628.3255116-1-bvanassche@acm.org>
	 <r3upegmcqg5fxo22u63dwtwrlc7qpwi57drlvujtw4jkbinx7f@xluie2klyr55>
In-Reply-To: <r3upegmcqg5fxo22u63dwtwrlc7qpwi57drlvujtw4jkbinx7f@xluie2klyr55>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6628:EE_
x-ms-office365-filtering-correlation-id: 5e2ebaf8-5c5a-4729-4551-08de5a50bc43
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Y21WV0NLN3lTVEQrRTBsazdLaTU1ME9ZQXR1eUNscXluSWRxM1pQSkxJRTJu?=
 =?utf-8?B?UG9iVkJPZ2pUVERXdkJjb1EwYnRWbjZkbyt1OHdKczh6amVPSmdkQ28rTDZR?=
 =?utf-8?B?ZEVxU3Nhek9YZVZVOVcwU3lMNE5TbklBbDlOcVdYcGg3Y1RHZTkzM2dHRUxR?=
 =?utf-8?B?aStSOFdOWkxmSzY1MlNBOHh0QVlMdlJlcHVRY2o5c1VmY1NKNzFsOFRqalg3?=
 =?utf-8?B?ZFVNQzNZZFBYd1pFc0dtN3hFdkxVdys3b3NlZFRwS2diazVhOHE1Y0EyYTd1?=
 =?utf-8?B?OGxINVF3RlFnVUllbHlVYjFGT29iN3ZMN1dPcGx4Q2N2RTVoUTdZMlBvVG4r?=
 =?utf-8?B?SFQ0UHVqZm04YkdNYmU5cHFKSmFtWkJ1ck84MmwyejlZSDFBLzd0bktmdC9W?=
 =?utf-8?B?dUlCY1NQcm5WTk1paVQxUllWQ2xQTzdldUk4OXAzVit2bERJcGp2ZnlyUGtI?=
 =?utf-8?B?a3FPWWtPTldWbFdjOWFWbWVFTGltUk9RV0xvSm4wUDhUUHdSbnR4M2NwK0tI?=
 =?utf-8?B?N3hqY1E4Y2NCUThRdDc3cFFSWTVtbGo4SXR2TTdJajVaTzUwaXcyYmRFUDda?=
 =?utf-8?B?MmZ6WGU4S0d0YXZnc3ZTRkVsZmZQTEhoRWdxQmhPdEQ1UzVBL3czU1VadEkw?=
 =?utf-8?B?SHdTVDVZalZXa0huYlNibEc1VjcyUUpTemlNNXY4QTNGSkRyRitManRtcnkx?=
 =?utf-8?B?QkFhNFZ6emEwTW1EekZGUmhGbDZOcERWWmxsdktnY2pBK1J1MGg5d1Z1U2JM?=
 =?utf-8?B?OHpYTHpzSWdRMTZDNGhlYjkxWE5zcjNNRFUyU05lUWYwQVFXclNjaTJOVXZN?=
 =?utf-8?B?dHJ4dkZWUG40b3EvbTc1aklGZFB3c0F2WjZoUGc0SldHQUlZdThXT0dabU5I?=
 =?utf-8?B?UFZXTy9hb3lOYzRsek1ZMVozSHJFTmVmZDlObEJMYUFXcFVpbkFZdkVHZ21k?=
 =?utf-8?B?cGtVRlptZDczRU1waHg0OEFidmtXSis3NmdKWHkxaklnWjFVWFEyL2Zud0Nn?=
 =?utf-8?B?VWhFOTJ0OXB0K2JhbWRSd3EvZFRxL29TYlJzRmpveUVsT1NSNnRGQ3VlMmpQ?=
 =?utf-8?B?MmFHRXZxL3IrMGgvSDVxSmMwZkpDdndyOGVOVDJ5Q3N5YUdZdm1aeXdLRjdG?=
 =?utf-8?B?VVpGMWhaV2RaV3M1QU5vanJWVDNKd2lTWTNueW91ZWhLNlhlUG1BWmM1SG5J?=
 =?utf-8?B?N2JWbEFBYVZqNHh6ckJCOW9mQXdpdHRjYjVRSENSN3prdkl0RU1RKzJsSFUx?=
 =?utf-8?B?a2UrMjZTS1lxaEVZL2t3cEx2bGRLNzFGS0VrWjJPYzZQMU95MlowR1VDUU54?=
 =?utf-8?B?Z3A4MHYwRFUrZFdtRlRZZTNqaHhPaTBnMmZwVGZ1ZHNVNnozUk8vOHdhbXFy?=
 =?utf-8?B?MzU5MXMrSi9qdmhxVzlna0pvbm1PRWs1SEdhOGtHbGRmK1RwQW5XanVYLy9T?=
 =?utf-8?B?elVuM21haGJjcTdmL0RBYlRVaFlrRGtxZUNCYjlRdjMvSElBOUVXOC8vZVZ3?=
 =?utf-8?B?YmhvejhuQ1JYSG90cXJMc1p4WWFXWU1waXFiZXNuTTlKTXZTbTFoVm14OFl1?=
 =?utf-8?B?SVNDODgyaDcwelVyYTN1UHdHclVyTzliVVNaQkM2dWVRL3J1aG55aVJaKzRp?=
 =?utf-8?B?ZkEwdVRZUXV3THRRT1B3YjVKdGoxMXQ4NU5vemVMMWJ2MUp4RGFtN1BHSFlT?=
 =?utf-8?B?WHRxZnJveUZlcjhiWjdDQWl4aDFxY3JSblNiOXMvMnpDWkVlL00wMWp3VWZ4?=
 =?utf-8?B?YnlVR2ltWjg2K21yYzJPVGg0cEJOWUIySEJWZldLNlByVTJnZFJoWmkvVHV6?=
 =?utf-8?B?Tk5rYlY4dDUxUE5CWjJ5MHc2Slg5Q3lUaGhJaUlkZ1Y5dzJJS0R0NXdqUjlK?=
 =?utf-8?B?NEhQVVJ1TktBWVFDckhMWFNBNi9ya2xhWWtRZ1dmUUVLWEcvU01qNWk3NlZ0?=
 =?utf-8?B?VU5kWExDQ29Cc2JlOGZod3ZCUFRkUUNsbFVIdlh6Q0txRU9QNVlOaGwvKzlB?=
 =?utf-8?B?dWd1Ny9uREZmeHhYS3hpOUkzQjNsaDJ3M0JXYlpGdlV2aXI5N2swLzYzSGtk?=
 =?utf-8?B?SEVGVXN4MjIrNmJOUzJMekc4WHF3Y2pMNDZlWnNLVW83a01Jd2RNMDEyK2hI?=
 =?utf-8?B?NVVRQktka2M0Y1VTZTA3eTRZK0JsYzJPUXdQcWltK0RGR1NqNkx1MzhmSDJO?=
 =?utf-8?Q?8hLGhDD1TyUjKVDZe8vpGbM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzVkMHpSWU9vWmhBSjM4WHB3Z1dQbkV3US9yT0pKV3JaWTY4aXlaQlM3ZU5F?=
 =?utf-8?B?NDlPV1pyK1NYY3l2QnllZG9mZHVjSUdOVG5YZGZCaWtISFRuUm5YeXVUc1Bl?=
 =?utf-8?B?WEdsL1ZzRVFBMFBwWTAwYXE2QzViZGQvdTdlZC9qb2g5OFUxdlArZHRmQytC?=
 =?utf-8?B?WnZKbkhjcUlFV0pMZ1JBcC96QlBJWVZxM3N6TW1Gc256QlltWU8vM1ZEZXV3?=
 =?utf-8?B?TFduOGEzNlp2VzNzZThQWTRTR3FQZ2pxaTM4Y09aU3ZpS3FvZ0RGdlYrRCs1?=
 =?utf-8?B?N3psc08yckpIR1BTSDRUWDkvRHFJNnIwOXhLdDNYeUl3ZVhLQUFhcWZmZmdX?=
 =?utf-8?B?b05WSFZpdWMrVW9uYTZ3aE16MjUwWThBdWZoT1ljS3NyTURvQytwK2lBYmNU?=
 =?utf-8?B?bHpneHVORGIxUkoxUXZjaGZoZGNrai92MmZRZGp3ZWlmMGhuM3BSdlpIcFNi?=
 =?utf-8?B?QmEyemxkQW1kOE9ObjJoOXBwZXhvOHIwVTYzK1FUK0NUK21nTmtMZVFsNTR5?=
 =?utf-8?B?R2NxTTFJM0lBc2tRYVVGc2FVNWlaakVLRzZpWWlNckRrUkdOL2t6empzQlNU?=
 =?utf-8?B?VHBsalptc1JiVDVORzNsQzBaVHdIblJpYUMvVFZLK2ExOHFRa0dKSXJvSmN3?=
 =?utf-8?B?azVvVC91Z3FXY3FRUk1td3NRK2sxazVadlMvWDBLbnFYN2ZocWtNZnFOaVNw?=
 =?utf-8?B?Q1NXbWF1Z1FoN1BZZ2tMNmJwUzdUQVFDQzVCSHJSTEJ5eFlVWGJLOWg1bTJB?=
 =?utf-8?B?ZDVDM0R6bkJCRi9ITGQzSzN5UUhML2FHbVpXMWVGVXhIME5uYkxMbkp4ME5F?=
 =?utf-8?B?NFJMZXVuOHFkdWtMY1BlR09HaGNaNFpwbTQ3cGVIVVBPMi9lem80eGh5NXFZ?=
 =?utf-8?B?TERBUSt6cEJxSG9mMXhJc2hRUW5mTkM2UHpKVXdMQ3FVOU45L0tBZHZyMVBx?=
 =?utf-8?B?UGdqZUZ4bWNEQS9GLzlZU2cvTndMTzVOdHV2SjFnZGhtWGZEYnVONHRzaDJZ?=
 =?utf-8?B?emhRdzVsdk9SR3l1cTMrY2d3akV5dERrRDg3VVdIVFZIKzlHZGVsWCtVdHFT?=
 =?utf-8?B?M0VFRVppV3JxaUpGaFc3MWVwK2JSb3RlQlhQWEdMK3RlZFNmZ01DclFHaE5o?=
 =?utf-8?B?Ny9aSWVXNm1ZSE9ZTUs3T3JnTDFFMkV1dXlEVDY5NVI1TXM5ZnRHTnR5cGVK?=
 =?utf-8?B?QVdkOGs4RUtQbWFjbXpqSy9jVDBrc0gxUk1FVVZBSVFESGdsaW9aSW1PWTJQ?=
 =?utf-8?B?cnRMdXIzQUNoUmYrMzZFbjZjSWNTaC9FMjdmVEJiNnJNN3lWNXBMVlI2RDlj?=
 =?utf-8?B?L3FHZnV5NnRvN1MvSXBabzI4NXZnQndIaDdZcFVSWHRDT3lYNVR2dk8wYVRh?=
 =?utf-8?B?TDhZV1VJWDlKbDFjYXRvM0NicUNtYVVFUHhmZ1JMaXJmQW1YQm9takFaRWxq?=
 =?utf-8?B?cm4vc1BIbkVsQXd1T2JKV0x0STNIUmUzNUNiQldhZnowOWQyTUkwWHVkV3BH?=
 =?utf-8?B?TXltT1pKQk81TXpDM0VyTlR0UDVXU0NlMGg5ZVY0TkRoZlJhME8wOG9OVFZ6?=
 =?utf-8?B?d1o4R25EU2hsLzdOTW1oc0UvYzZOUXVqTjRFeDZLT3dlU3AxZTVCdFBtallV?=
 =?utf-8?B?WVpVR0Q4S3Q2WU9DaEVOS1U2OXNFZzNVMDBkRXB2QTh5dndJc3NvVXZrMXJI?=
 =?utf-8?B?OW1aNWV5L05EK09IY3p4cWVDcUlMamRDZUxPdnk0NEJFaHY1eHI1ZmM0WHFM?=
 =?utf-8?B?Rnp6ODRJYVdNc01vZ2puL0hLdEcrdG81U2NOZTVXYU9VL2txYjBBZXh2T2R1?=
 =?utf-8?B?WGl2U0NwWDNnWHpSMlA3Z0RHaXN5TFVQVFMwU3RYWFhKQUZMazVGSFhMbzJo?=
 =?utf-8?B?OW1oMmxVc3krRWlXSXQxYlFsYnRTMEJHbE9OaUlsc2xJYnNrcERxQ1U0Qlhl?=
 =?utf-8?B?N1dzQTBqMVBqQUNmQ2ZhdnJ2OHcwVDQxS2FycDViRDk4TTBtVGZ5b29ka1RD?=
 =?utf-8?B?NnZaMVRObnBCdVRkR1B0U0F3eWdhay8zU0xYSW5DMlducWk1ZUExamkwM00z?=
 =?utf-8?B?TWVjRzU0dUZ0UmlLM2YvQjFUY2ZuOStXRVAvTzdlRDQ1d2hDUVdLOUxxWk1V?=
 =?utf-8?B?SmZ5QlZHU2llR0N3NXNSeWF2K2VDYmZXK0lYdk9hTzNTdktwQjBub1luK21M?=
 =?utf-8?B?YXhwQ1JTc3QwNFg5UkVVYUo1a3NzZUdKQ3hmWVRIejNHcTlNcm5aSlpRbFls?=
 =?utf-8?B?L1l6L05tYWFIdXRYUjlBYVo1V0hVc3dBREVoWENtaHVDZi9KTTduMGJrL1Rq?=
 =?utf-8?B?ZytmZVF0dlo0NUUxMUJZNnlsOVVHUUNzMENnd08wYndjSVpSU2FCZE9rM3Rw?=
 =?utf-8?Q?YbcIUvtZKiQcTmLM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31DF7FB3E6829D4D8C85FC364B7672E1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2ebaf8-5c5a-4729-4551-08de5a50bc43
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2026 07:26:33.5483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ggC+9iVHjfE8hR74H1XGAdGGjAtIKgPZXwUNTf3IqGU463mfhFCapm9YBaCovNOs0sFPKVTk/naOoHhZhJw9Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6628
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDIzOjAwICswNTMwLCBNYW5pdmFubmFuIFNhZGhhc2l2YW0g
d3JvdGU6DQo+IA0KPiANCj4gSGkgQmFydCwNCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHdvcmshIEkg
ZGlkIHRyeSB0byBnZXQgcmlkIG9mIHRoZSBjbG9jayBnYXRpbmcgZmVhdHVyZQ0KPiBhIGNvdXBs
ZQ0KPiBvZiB5ZWFycyBhZ28gYXMgSSBhbHNvIHRob3VnaHQgdGhhdCBpdCBkdXBsaWNhdGVzIHRo
ZSBiZWhhdmlvciBvZiB0aGUNCj4gcnVudGltZSBQTQ0KPiBmcmFtZXdvcmsuDQo+IA0KDQpIaSBN
YW5pLA0KDQoNCgloYmEtPnJwbV9sdmwgPSB1ZnNfZ2V0X2Rlc2lyZWRfcG1fbHZsX2Zvcl9kZXZf
bGlua19zdGF0ZSgNCgkJCQkJCVVGU19TTEVFUF9QV1JfTU9ERSwNCgkJCQkJCVVJQ19MSU5LX0hJ
QkVSTjhfU1RBVEUNCik7DQoNClRoZSBkZWZhdWx0IFJQTSBsZXZlbCBpcyBkaWZmZXJlbnQgZnJv
bSBjbG9jayBnYXRpbmcsDQpzbyBpdCBzaG91bGQgbm90IGR1cGxpY2F0ZSB0aGUgYmVoYXZpb3Iu
DQoNClJQTSBhbHNvIHNldHMgdGhlIGRldmljZSB0byBzbGVlcCBtb2RlIGFuZCBwb3dlcnMgb2Zm
IHVubmVjZXNzYXJ5DQp2b2x0YWdlcywNCndoZXJlYXMgY2xvY2sgZ2F0aW5nIG9ubHkgY29udHJv
bHMgdGhlIGNsb2NrIG9uL29mZiBzdGF0ZSBhbmQNCmhpYmVybmF0aW9uIG1heWJlLg0KDQoNCj4g
QnV0IHdoZW4gSSBkaXNjdXNzZWQgdGhpcyBjaGFuZ2Ugd2l0aCBRY29tIFVGUyBmb2xrcywgSSB3
YXMgdG9sZCB0aGF0DQo+IGdldHRpbmcNCj4gcmlkIG9mIGNsb2NrIGdhdGluZyB3aWxsIGhhdmUg
YSBuZWdhdGl2ZSBpbXBhY3Qgb24gdGhlIHJ1bnRpbWUgcG93ZXINCj4gY29uc3VtcHRpb24NCj4g
b24gUWNvbSBwbGF0Zm9ybXMgYXMgbW9zdCBvZiB0aGUgcG93ZXIgaHVuZ3J5IHJlc291cmNlcyBh
cmUgZ2F0ZWQgYnkNCj4gdGhlIGNsb2NrDQo+IGFuZCB0aGVyZSB3aWxsIGJlIGFkZGVkIGxhdGVu
Y3kgd2l0aCBnb2luZyB0aHJvdWdoIHRoZSBydW50aW1lIFBNDQo+IGZyYW1ld29yay4NCj4gDQo+
IE5pdGluIGlzIHdvcmtpbmcgb24gbWVhc3VyaW5nIHRoZSBwb3dlciBpbXBhY3Qgb2YgdGhpcyBz
ZXJpZXMgb24gUWNvbQ0KPiBwbGF0Zm9ybXMgdG8gdmVyaWZ5IHdoZXRoZXIgdGhlIGFib3ZlIGNv
bmNlcm4gaXMgcmVhbGx5IHZhbGlkIG9yIG5vdC4NCj4gU28gSSdkDQo+IHJlcXVlc3QgdG8gaG9s
ZCBvZmYgdGhpcyBzZXJpZXMgdW50aWwgaGUgZ2V0cyBiYWNrIHdpdGggdGhlIGFuYWx5c2lzLA0K
PiBzaW5jZSB0aGlzDQo+IHNlcmllcyBpcyB2ZXJ5IGNyaXRpY2FsIGZvciB1cy4NCj4gDQo+IEl0
J2QgYmUgZ29vZCBpZiBvdGhlciB2ZW5kb3JzIGxpa2UgTWVkaWF0ZWsgYW5kIFNhbXN1bmcgYWxz
byBjYXJyeQ0KPiBvdXQgdGhlIHBvd2VyDQo+IGltcGFjdCBhbmFseXNpcyBvbiB0aGVpciBwbGF0
Zm9ybXMuDQo+IA0KPiAtIE1hbmkNCj4gDQoNCg0KTWFueSB5ZWFycyBhZ28sIE1lZGlhdGVrIHRl
c3RlZCB0aGUgY2xvY2sgZ2F0aW5nIGRlbGF5IHRpbWUgYW5kIGZvdW5kDQp0aGF0DQppZiB0aGUg
ZGVsYXkgd2FzIHRvbyBsb25nLCBpdCB3b3VsZCBhZmZlY3QgcG93ZXIgY29uc3VtcHRpb24uIElu
IHRoZQ0KZW5kLCANCndlIHNldCB0aGUgZGVsYXkgYXQgMTAgbXMuIFJlbW92aW5nIGl0IGVudGly
ZWx5IHdvdWxkIGRlZmluaXRlbHkgaW1wYWN0DQpwb3dlci4NCg0KVGhlcmXigJlzIGFsc28gYW5v
dGhlciBzaXR1YXRpb24gcmVnYXJkaW5nIHdoZXRoZXIgYXV0by1oaWJlcm44IGlzDQplbmFibGVk
LiANCklmIGF1dG8taGliZXJuOCBpcyBub3QgZW5hYmxlZCwgbWFudWFsIGhpYmVybjggd2lsbCBi
ZSB0cmlnZ2VyZWQgYWxvbmcgDQp3aXRoIGNsb2NrIGdhdGluZy4gSWYgdGhlIGNsb2NrIGdhdGlu
ZyByZW1vdmVkLCB0aGUgaW1wYWN0IHNob3VsZCBiZSANCmV2ZW4gZ3JlYXRlci4NCg0KVGhhbmtz
DQpQZXRlcg0KDQoNCg==
