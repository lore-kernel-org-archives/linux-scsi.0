Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37297462
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 06:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727678729; cv=fail; b=LrpuDApMTWNDpc2YyKTF3ruPqTx5lX71VH8cD0jPS5srqnvoxQ6+SQpmg+D33pRh4bZ+qKiIVfrY9Yu1KgvGVi9IhXkRhiqZxiE8qaRdcUh8NGKHMCbqkAJKskiCCgU3f2OTWMyXTkv6mMKB00vWvT4u9ha8ZZJ5A0Bcvip2dW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727678729; c=relaxed/simple;
	bh=K8tcpjo4zM3xr5oFtPDNu/alBhuDUZLO8SG0kOjCurQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q+DMkYqIu+npMzhQqasCfvBhgqEa7SOl8H8Eclfn0O1DYqmtCE9BSt0aM68nauvMW45trgKIucaLAaAUNvwOhHfgd4qrEZJquMcLNnMp1UtMfRWuqYnjvpkHZuXi2KiJwN2EOic/MonB3UWcVIg8s5LaxUWAox+aVySHGO1TQ3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fQOP8b4I; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=f4SXI483; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fQOP8b4I";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="f4SXI483"
X-UUID: 8f820a727ef711ef8b96093e013ec31c-20240930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=K8tcpjo4zM3xr5oFtPDNu/alBhuDUZLO8SG0kOjCurQ=;
	b=fQOP8b4IWDjD0VR48fM5KzYtYyK3u482b53CBJr7vkHlF6AT/Qe3DVpe9qPYhWrieJl1cg7jRy7XTVG2BvfC4lIaEsnb6RVrUS38nJo8Ah9XtJpjY4NsiBYmmrPjFRdrCtRyudnEk1Xnv0sjNr6bbIgm+2NtR7Z227Ph9LkQrwU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:daa01784-18a7-41c9-9b62-97429dda761e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:2b9e7618-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 8f820a727ef711ef8b96093e013ec31c-20240930
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1015793690; Mon, 30 Sep 2024 14:45:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 30 Sep 2024 14:45:17 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 30 Sep 2024 14:45:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/FlplDFkqqCH5N8wMRAjCfSj6CfqFwMAKmm8pI/gcfkC38eIOE1+aJdD3wbc2hgw9JqJe830HKLsnbPY1IA4NW9JylKA5XnP1mUQvfYmemK/9oMP+RYI1UVrYCrasVQ/bi80OSQ/8bfA+3xtj6sGDwbJdPMxwT90NhExf2TALQFn4mJ9zPN0yhJIpjUINwwizja8qOAecbNg45LJFkqHgF0VJHd6KokgFaC4C3v5rAsT1shUcMGWazV96ZkidgwTaUSGvcFwPR9isjAk2MeqwKwlsDlZkUMnW0zzKpOvgPgvhBw7Px96XGOeCAF+QbQCtt7VZ10Di7yXavk+oRzMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8tcpjo4zM3xr5oFtPDNu/alBhuDUZLO8SG0kOjCurQ=;
 b=oPgbFkMpfuEqXmGim9G4p8pnBp1hyUwsWiRrSibXeHoR7tgONDtApr2FEmEP58tU+abibuvQehkL9WuBKeQrhN4Ba4m7Jp2gghF94ZeHWOIfFpNel1gzy7N0NUFsUxs6evXc26Sios6Ey3W+WnEyuhsVu+OvvYlAW5WjP1WiupLQmSN6Tvbb2TAfKeDQb2DTfCwPKRyakhSWoh+QXjq9mSpLGOE2SvAxDM2j2LJstjITIBNRpm8g6J1vnW6WfGW299YJAQDbGN8oRk0ytrM2+WcrgQhRKK8fc+A7xQFATR1MqZxl+0fNkT9tzCcr7eQSJ3/ihnZ4DIKKmBd5TCYVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8tcpjo4zM3xr5oFtPDNu/alBhuDUZLO8SG0kOjCurQ=;
 b=f4SXI483z2sTINUHfm3+ngpvNGS8347FNssA/W5ql7gOvxJvxtzRr6tDf/wGunlZuFoqOEC/K4EZRlqb4vfsRXSCc896Dx5fZPPJ36YZhUF9LZqYkLCgVXmhWMOJXp9Zs2OaQbN+yuoKbnoz21aszEkxubl87XZrupj8UulRp94=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8436.apcprd03.prod.outlook.com (2603:1096:604:277::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 06:45:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 06:45:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
Thread-Topic: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ
 abort
Thread-Index: AQHbDzNnjCHDHRi190OQQBukK2Coj7Jot2cAgAC3HYCAAPZCAIAA4Q0AgAKS3ICAAhGGgA==
Date: Mon, 30 Sep 2024 06:45:16 +0000
Message-ID: <ad352469b3a1b6efd07506fba78c8f8f7f0295b0.camel@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
	 <20240925095546.19492-3-peter.wang@mediatek.com>
	 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
	 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
	 <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
	 <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
	 <c014f499-1a5d-4e3a-adc1-a95a38bbe2de@acm.org>
In-Reply-To: <c014f499-1a5d-4e3a-adc1-a95a38bbe2de@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8436:EE_
x-ms-office365-filtering-correlation-id: a9ff058b-2d35-4c88-875c-08dce11b7159
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MTJJQVBDc0RLK29KVVFwSlp4Qks4TnRtK0k3eHREMGtvN2J6Q1RWUmR0V1JH?=
 =?utf-8?B?czVZRW0zOUI5a0hjVWRERFRYc0NGMWppRXVKczZNSlY1OHlDc2RlcnBFZy8w?=
 =?utf-8?B?NWplSk1PeGs4TWw1RkhhUnpMTXJrem9NbjN0UmNiSEQvLzg0TktCVkdKblJT?=
 =?utf-8?B?Q0o0c2ptMmVaWVgyYnlwMlk4RVg0b0FzSWk1TGxXZkxHbEVaZmRrUjg1MlhX?=
 =?utf-8?B?YnVyWjVwQldNRDV4K3l4ay9ZTWprUGkxSUJveTk2RnRIeS9SMllLWlhaZDZh?=
 =?utf-8?B?ZGdiYzJqWkN1U0lGVEdYSlBscitueExFTGl5Z1c2bWNGRHZ3OU13Q3d6QmtU?=
 =?utf-8?B?dmRPVVZQM2p3YmpmLzJlNDgrZ2lGSTE3SU14YlBuSFMzR3VDdW55SUxXYm1O?=
 =?utf-8?B?NEdSZTR3SDZyR3dWWVVHcFJYVFExeFdwOVh6c3luQ29QRk5jQ3FYamF4M1M4?=
 =?utf-8?B?TjY0UlhUUFBuNW5EOEdtWjdYVWtHS2d0NFljbGxZa281TE1iUE94Yi93VFlU?=
 =?utf-8?B?ekVZcWhqNUhDMldRMjhJSnZwT1NNNjN2YnJlU28zTWdaSVRqcUZESmxqK2ta?=
 =?utf-8?B?bGs1TW1yb3RPVEZ4YWNHMGlzTnFPSmEzL1RndmZtQndyUlRSa3AxbkJYS3RU?=
 =?utf-8?B?NTBLSU9EZGVYMWJmWktkVFd0WStCbTRITEF0WUx6NFZYOXV6bWZaVmx5OE13?=
 =?utf-8?B?NEVqaGFBMnNlQXc3d2tnT1FzeG9jWERoOHJWekQwUktuS0pEckVHcVNUSkl0?=
 =?utf-8?B?ZmhQMDRrR215ZTNzUHZ0VnVoeVpaOWRHRWhtdUVyeVlhWVlHZk1pVVpSb21X?=
 =?utf-8?B?QjhwM0QzQTQ5ck8xQk54QlhncUlLWlRwd24yRzRyTGJXYllWZ2ZxaDIxZUlH?=
 =?utf-8?B?WGFqbC85WWhxRVdmNzVsNko0MFRRd2xjRUhjaitGSG1VQ2R5UTlrNy9SUUg5?=
 =?utf-8?B?bUJJMElRcDNtZDhFUzZScE8xTmZ0eklvL3ZYZWxyOUxzbHVtMUhoeEhNcVdF?=
 =?utf-8?B?Qzh1VzdsS3JFYXBJTkw2RGgwYTFleWJMVlVCTDMzRzJwU1F4ak9hTlBMVFFo?=
 =?utf-8?B?Ti9RdGNxQzM2YjN4VHM3czdCT0JQWWppUFFTZVVkRU5sSGJ1S1JYRmpmengx?=
 =?utf-8?B?ZXo0RUxCK21OeDlTK2pQb0h4UzF5R0J2NGlPYkVzaHlPMHhMRkdvNVRNNkJj?=
 =?utf-8?B?WWRwMWV5MkNBTHVzeHJFTU5UdE5HTDRWUHZURDg5OXRIeVArZElEWTRocEtP?=
 =?utf-8?B?dzlPWmNVdGxDRFA4VFdjZ1B2K096T25zZHZZYjBheXJOdUIybWhicmhpbU8x?=
 =?utf-8?B?QzVFb0VxQWNJRkVQd2pUY2JIMG82R1AzcUdFanRuYWNsMlFDOGRBSkZmQUVH?=
 =?utf-8?B?bUlZQTM4Z3VuZkYxRUU2bklVWXEva1pmZW5iVW03N1VwNnMwOW1DTlJmbGJR?=
 =?utf-8?B?dlFFRXAyejdsL2VGalBzUU03V0xkQlVmOC9xclUvbjFYMG96dzJLSFRnbTUw?=
 =?utf-8?B?bGtUdVdlb0xFemZ3UDk1TnRPNWpWeVVJYjJwcTFoTVkzSWJhbnF5YUZ6c3BI?=
 =?utf-8?B?dWdoRTRXRzNrZ3hhUHd1cnRiZW13Rk5tTlRHbGZwQ093c2REZkhGMEI5NGlD?=
 =?utf-8?B?eDZNQmVJdERXcklHdmhJcHoyS2RjN3BobkVyL1cyYUVSbUlnV1MyNVNsYWw3?=
 =?utf-8?B?QkdId3dqQ2pMSFI5d3piS2pWdmhyWGZOL251emk3UUk0a25zeEhBWCttTzlx?=
 =?utf-8?B?OXVWbGpRZjEwZGM2bzVKUGhleURrcEl1MlhGd010K28yOXdxV0VpL2FuS2Ix?=
 =?utf-8?B?a3ZUVE5ycFpqbHNXN0xuUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2hEYUlIZi9hVTYrN1BvZUJZVnQ5VVF5aEdNM2pKRzdXTjVYNFNDQmpOaC9I?=
 =?utf-8?B?NWcxU1dqVW1Gcm4vOS9qVjdHUWwwUmZtNHFBKzZocmRGVDRQbkV3eVQvVFN2?=
 =?utf-8?B?R1ZTVkZvSmFoaEJ5aDJweU5QWTM4MjhGMzl1d3R2dmZhNjREampXTHNPZHMr?=
 =?utf-8?B?VG1jaUg5dy9YNnZDeUZVUVZrQXRlVVpIL3QxQUxDZGlXbHFiY0JqQnY5QTgy?=
 =?utf-8?B?SDRFU0hEUDgrNlhleGpSeldrM3pDK3MyWURQa3RUUHZvU2t0Q0NHZFJ6OFlz?=
 =?utf-8?B?UEd5WDUxQk5IbXdRNWZCdGp1dFFmdzNFL2dmV1NoT3NwYTh3VS9OZFkyRVNZ?=
 =?utf-8?B?bGFsZFR0YXp2TDdFeDdwbi9DeVlQL1Z1a1lIYXVscXpNbGpiNTd4NzFoNDND?=
 =?utf-8?B?YUwzRk1Ec3FPTk92SFRXVmR2REhTa1B0ZDNVWlZrbHJQWmhPVENzTEFKekdZ?=
 =?utf-8?B?cEk3VU4vU1Jwem9tZUs4WUxZSUxVSlJGUlBLV3lFS09zakZtM2YzeUdqMmZj?=
 =?utf-8?B?U0NEWjVXVG1zTEVBVWc4RitoejlPTGZUbjh2cXdVZ2NrZ1YycDZMaDZNdVE3?=
 =?utf-8?B?UUpGL1FWaDU2ZFZycVZiK0JjeGw1OE53bDRqODc0Y3RBYzlIdnZLYXJpR0tu?=
 =?utf-8?B?SVlZNmNiQk1wZXZ4UXBwYzdPOFIrejRFRDNLYitWb3l4enJTTTNCQXNSS3BZ?=
 =?utf-8?B?VUZEb1g0U2ZRNDI5MWZiUjVaRGFreHl5dEpxMmRPeTlhVTBXdHowbUlUN3Jz?=
 =?utf-8?B?UlBrNkNOYmlSaEhmemNoTFZiTlZBOGZNaHYvdnlGY1Y1T3dEK0tZWkNXdW4y?=
 =?utf-8?B?WmZJME9sVU9mUElZOTFPcTRZeEY1QXFjeU92RDZJSHZtMVQ4UGdnMlV2ZDVS?=
 =?utf-8?B?OFV3YlJiVVBNSjRPQmVOYVQzaHpJSENmL1c2NkNjVVJPd051UDF2SWlCMnkz?=
 =?utf-8?B?VHd5VmN6SjcyMEFBbmU1aGRtZFpkbTVRdU94WDJ3ZGE2Z1d3SVlJQVBFSDFz?=
 =?utf-8?B?Z21LaGU2T3NzWTQ3SHlFem1uSlBvRWh5dmt0djZUME5XTUVtS2w5c05KYnY4?=
 =?utf-8?B?c01HT3lPR1cySDYweWFaamI0dk9tVGtLZEhzVVRuSGpjazZoTjBxclNIZStp?=
 =?utf-8?B?SUE2UDJIZjUrTk1kSkZtYTZFdS9IYXJiREl1MGg3a1IwZ2kvL3ZpSzFHcHRx?=
 =?utf-8?B?Tk1MWVFxNExTRnZ5VlRXbmMvbGYyU2xMTWVsd0dyVjZpd1Vwa3BZK3NIaTVj?=
 =?utf-8?B?cUh1WWU2ZlJUalJ2aGx4ZG9OS3R4QW5EdlFIMzJUbWJEMnJHWUUwZjgvRWVW?=
 =?utf-8?B?Wm9WdFlXSy95SUdaYWVkWkFnekU5Wmw5WmJFMjViTTFRaThsZ0kwK1hNekJn?=
 =?utf-8?B?ZjRjclNJbFExVG4xakZBNTJIVTVDYnRTY084S0tiZHE3dE9ZbXlSRHMvZWRs?=
 =?utf-8?B?bk1OWHJSeFZ5aGhENnd5R0lYR1dlUFVMQXZDaGNaWWQ4T243VHQ0a2hsT1cr?=
 =?utf-8?B?ZGp0VmdCVFMvMTdWRUpIOXdQdnJpUUZJMU9TaDNXM1N4TWZHQlQzYzE3cWdE?=
 =?utf-8?B?U0dnSHRUTnBSd2hWczluZlYveHIrSG8yd2lOM1hDZ1Z4SC9ZZ2M2UHBKYTRP?=
 =?utf-8?B?SG9DZFZ3UjBYTEZKV0VaRGtVK0I5cDY4ZkdudnJMamg3eEhNaXFIak5pWU52?=
 =?utf-8?B?a3V0M2ROMGI4QTNodWJieVloRlZpazZxc3hlbDlKSjRqaTMrNjd4UUhjWlpC?=
 =?utf-8?B?d3pTcnBiUGx6ck1uVmY0SmtwQXdvUUJMd1Y3N0o0MmVTL013UTl4Q2lRQ1h0?=
 =?utf-8?B?ZUdPMnRQaWpYOGViRUdwMndVTXpIRi91dzluRkw4Z0FncWlmNmZzYjZrcEFo?=
 =?utf-8?B?dVFjMTBRTXVmRFdickRBMkhHdzhyZFhGZ2lnRG4rS2EvNi9BWWdmWWVqSW0y?=
 =?utf-8?B?UmZKT01YNkJnRDFhUmViR2EzZ0JWb3JBU0ZVWjJNSlFkbk4vNDkwSG5vSlFP?=
 =?utf-8?B?TEhUZ2o0RGZxMWpqaWFRUll3VEd5ZkV4MEIzUG9La0krM21JZzlFSzkvLzNm?=
 =?utf-8?B?TUJuSlZRS3dJSjNLcXBPRlBYSzhpclNBWDYvMkVNbS9BNTN1SEJINkdNSlM0?=
 =?utf-8?B?cHRKMEZtd29QRXRkb05ZbUVlYUlTRlMxYjJ3Y2lpc2dpTVJYZEJodENIRXQ1?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <208FBD2A95D0C84386627E8528A0D2AA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ff058b-2d35-4c88-875c-08dce11b7159
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2024 06:45:16.1449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yume/hx4OIg+yxbp7xptcHXHJoRM5vfaRjI8xqVKsSUJmU97sHsVvRp8Ehq0KLHBckorfQ1az/80VCI0FyhHgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8436
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--13.279100-8.000000
X-TMASE-MatchedRID: Y6GLOewO+JjUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4+qvcIF1TcLYF0c
	vQ4E8DdUulzTX8f2zjo7V2y6PpJnIlZQN44ncFR1aK+MsTwM+1nAuWcdTSiQDdqCxkzSpW/XV2O
	iGxTSnds8Hy81oDpzjiUTPXtmIyDWQOfw0USEkBxT46Ow+EhYOClayzmQ9QV0OW8XgChxVdgjDr
	hrReC9RAJxYw2ZCX+uXnmAH8WDUPK9+a1unxzP854CIKY/Hg3AwWulRtvvYxTWRN8STJpl3PoLR
	4+zsDTtgUicvJ4MChm4lfca3JAKNm6FPsF6toHC69R0aS0HdCAGC+PSS6aNiaqWNszmCAdw
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.279100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	51042D8A75103A21489C7E1251F56B1E5AD762F402FF40069F9812F7D4D18C692000:8
X-MTK: N

T24gU2F0LCAyMDI0LTA5LTI4IGF0IDE2OjEwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFRoYW5rIHlvdSBmb3IgaGF2aW5nIGRyYXduIG15IGF0
dGVudGlvbiB0byB0aGUgYWJvdmUgdGV4dC4gUmVnYXJkaW5nDQo+IHRoZSBjb2RlIGNoYW5nZXMg
aW5jbHVkZWQgaW4geW91ciBwcmV2aW91cyBlbWFpbCwgZG8geW91IGFncmVlIHRoYXQNCj4gdGhl
DQo+IGNvbXBsZXRpb24gY29kZSBtdXN0IG5vdCBjYWxsIHNjc2lfZG9uZSgpIGlmIHRoZSBDUUUg
c3RhdHVzIGlzDQo+IEFCT1JURUQNCj4gYW5kIGlmIHRoZSBTQ1NJIGNvbW1hbmQgaGFzIGJlZW4g
YWJvcnRlZCBieSB0aGUgU0NTSSBjb3JlIHNpbmNlIGluDQo+IHRoaXMNCj4gY2FzZSBjYWxsaW5n
IHNjc2lfZG9uZSgpIGNvdWxkIHJlc3VsdCBpbiBhIHVzZS1hZnRlci1mcmVlPw0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KSSdtIG5vdCBxdWl0ZSBzdXJlIHdoYXQg
eW91IG1lYW4uIEFyZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IHNjc2lfZG9uZSgpIA0Kc2hvdWxkIG5v
dCBiZSBjYWxsZWQgaW4gdGhlIGNhc2Ugb2YgYSBTQ1NJIEFib3J0PyBUaGlzIHNob3VsZCBiZSAN
CnVucmVsYXRlZCB0byBPQ1M6IEFCT1JURUQgKE1DUSksIGJlY2F1c2UgaW4gdGhlIGNhc2Ugb2Yg
T0NTOiBJTlZBTElEIA0KKFNEQiksIHNjc2lfZG9uZSgpIG1pZ2h0IGFsc28gYmUgY2FsbGVkLCBh
bmQgY2FsbGluZyBzY3NpX2RvbmUoKQ0Kc2hvdWxkIA0Kbm90IGNhdXNlIGFueSBpc3N1ZXMuIFRo
aXMgaXMgYmVjYXVzZSBpdCBoYXMgYWxyZWFkeSBiZWVuIGFib3J0ZWQgDQpieSB0aGUgU0NTSSB0
aW1lb3V0LCBzbyB0aGUgdGVzdCBiaXQoU0NNRF9TVEFURV9DT01QTEVURSkgd291bGQgDQpkaXJl
Y3RseSByZXR1cm4uIEJlbG93IGlzIHRoZSBjYWxsIGZsb3c6DQoNCnNjc2lfZG9uZQ0KICBzY3Np
X2RvbmVfaW50ZXJuYWwNCiAgICBpZiAodW5saWtlbHkodGVzdF9hbmRfc2V0X2JpdChTQ01EX1NU
QVRFX0NPTVBMRVRFLCAmY21kLT5zdGF0ZSkpKQ0KICAgICAgcmV0dXJuOw0KDQpUaGFua3MuDQpQ
ZXRlcg0K
