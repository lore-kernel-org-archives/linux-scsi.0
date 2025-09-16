Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD8284B3E
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 08:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758009821; cv=fail; b=cm6fUBhRkB9P/FjOYHbPvU4756ReSwpUF9cJqjgix8vlvZ6zSvb7u+iIlp63L+gc+Q7ME+aisIwig4gjB3jehiGrdGKeVRdUgx1eiZxMFPFxdX2AR0xkZ5v04ciX+zXyaIAhCz1dj2jYBcBJx285JA13RG6qvg0z04Exh+GWNjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758009821; c=relaxed/simple;
	bh=Efr1b/D+GhKdWfxNMivU/OVjfy5zKS40U73QrSbFzfs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sWPkpheb6LLSSEpmbBbncwM8u56rm+ur04ysL91KdYIvfYDxo0rjvSixCuQf9IB12Yb3XaSwh77DrMF/IJY9jphUq+5VvZiSJM4ZoKw15r4GgOnc8pRXhFcKsX/jjnuXe33T2SLtdg0SjKHIE3O1XahmcBYo6Fx5nIHVTf/Muwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RD/2TmgO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zxgB5iEd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RD/2TmgO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zxgB5iEd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1gDOt002737;
	Tue, 16 Sep 2025 08:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3akOqwrpLAwnbnglJ/7OTyMfVUxdy2ECaCX4ffWBpBo=; b=
	RD/2TmgO9IkffhOOAkpMJ15RFPEO9qVsjg+Wl61f9EB382Suix7buZdRQs9v3MDG
	bIIu+OvIV0hNQ/B/Y3q3WdxGhqhRz4GZ0t1KmyFQ1xQI8Irc1oF+1gEa/AQqaal4
	Kwc7WfJjwq4XlSfmRf1ZBYiYmnlhyvsV59SjB+AhhaCWUd8KglWJtqam3KES37Vu
	7roe8nEWq7WEgf3S42E3sbwtKVrCwC8azxTJ1XAzafirumFsU5k2oHDzqe5ooqug
	BF3fUUw3ereshJJfD2e4v3Av1FIexL2lfTULcPBWJeXeaYwHVJOPnlXchnqKx6iQ
	+uIAQRjECaHtnhmnL6Vnyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v40ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 08:03:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G6u3OK035203;
	Tue, 16 Sep 2025 08:03:21 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2jbeey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 08:03:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJZtYPgg6rNlurQTPd0A70IyGP6hfuxNnCX5HZU1FxkN1fQo4XfRxXrEko+nqIDPdcJgLHDcphkoDZbigs03rG5L2MneliEKFvGAlRlma4HfexJhcy3LbJYpUeoIOppEvxCuglv5dT9Q+0KDVS85ajsTLtbMymgQis2PYj/7P3k3XevMP13Y52EEurmgjkcvzhU0OKFnW8m6jvvwjYjyH2F0ILS9UiCQzRmzm1Rd2PIk7QCu4Jsvj8GNTBGv5LXua9SZQqwgGQtXBx6YAlIBj0pIKd8q+p97PjJ3MsJq8i/c2TU/JsavKMFgs2sCk8v5MndFoMeWtyLxr4VAh2y61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3akOqwrpLAwnbnglJ/7OTyMfVUxdy2ECaCX4ffWBpBo=;
 b=ZKrUsetkxGkdawms9i95xQQiPeNO0cf0JKFoRItX13A/al4qx/SvC+dOnR7g/omdehZGw7PSEC4zeuGuVhxFTfvNCy+VH71kE87qkZidT4D7JSCvEn58X049FNimKMefpLaH71vDFs9px6Hs5wgPGq0j0OlwownI99x5dSHXeX6Ju9XleKlPA985qSQ2ZT9CsT93tgeO0mf3wkE0mGN9PQ2crZPAyKGx1Ot92vJesZvjSN/ZI5zZAAte8OD/A1q//pzwknyF6LL8r/FVwptUBIi9VVnLfSOepdjW7uOIeffTTaFp1EHNhX0cvmoQCoEPQdbmsLLVKOCDxpl4B7lvXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3akOqwrpLAwnbnglJ/7OTyMfVUxdy2ECaCX4ffWBpBo=;
 b=zxgB5iEd33+Urk5sdBnoQP5jS7AmPYfyJQoatJJ9nbvdzbyoat07mVWZd+ONIB5y2MZfh7LoM3mldelEhrIGCad+DP5MPnO8z5I5UONMN4Ju549mffXctmWdTlXgjvW2acCNBKylZ1vhSLsGKEBaeTTrwRulZPO3h8n2lSPUask=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BN0PR10MB4998.namprd10.prod.outlook.com (2603:10b6:408:120::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 08:03:11 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 08:03:11 +0000
Message-ID: <31a1ad26-5273-4bf2-95f4-e043da00c373@oracle.com>
Date: Tue, 16 Sep 2025 09:03:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/29] scsi: core: Move two statements
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250912182340.3487688-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0355.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 347cc18a-bc2b-4cf3-51f2-08ddf4f77ac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmRTT2svbTdKUk9zN253NkRIdVhLdldRcXowTjBaMVdyUnRzVFNrV09oa1lW?=
 =?utf-8?B?ZVBRaVNoa0R6cU14bHJlS2NraExqMVU3THBqdUdsNEJYUHhYTTgyMWZxQlJu?=
 =?utf-8?B?NjI5MHhkMFVHNXFmdmRhamExcTNwSk81U3ZoZEV6dkltMjdhcnJPSWNuNGVi?=
 =?utf-8?B?MXdEdHlCTFFkdFRXMGlETkUwQ3hETHEvWmRidEU2YitLU21tL0RMa2ZXcUVv?=
 =?utf-8?B?b1hXUWw2L2kxOGJvck93ZTBtd0xiMjladjdrSlQ2WkJSZi9TQjdVVmRPZkFp?=
 =?utf-8?B?UG9VRXNZOE1MaTZMRjhCZ2IyTGs2c2xGdFQzTTVMckYrSVV1cEc0K29lTEV5?=
 =?utf-8?B?dDF3bmNSa0hYcFJKUU94a2taeC9NL3liYitRWHVRY2ZQLzFIcVl6Sjhnc2Fy?=
 =?utf-8?B?Yjd5bk9hSUhGcldGTWM0Y3lXcmdsTU5INUNZaFMwNDhkUTFVS1VzYVFyVFcy?=
 =?utf-8?B?STRBcHoyaS9aYWlnUWNLY1djM0ZOZXEzSTl3QXh0SHVPYS9ZWTdNMHFmMk93?=
 =?utf-8?B?REhJeGRSVUFLcU1GRE1ZZ3pLK00rdytaM3NTY1g5KzF4dStaQ1ZmZ2hiS05X?=
 =?utf-8?B?V3h5dlM3QXgwR0Q5czdVM2xvalhMUEJJS2xoSFpsWi90Wnp0eDl0cW1LZVcx?=
 =?utf-8?B?MkFYbGVsRUlPVnBSVnVWM0xyQ3FHdUE4dnVxZFQ0L2tVZ1BpdUZteDFsT0p3?=
 =?utf-8?B?MWNna21rUDI4eDR6YmxEbGsvWUJVMVVTV1FrcXRabC9aM2RORFdxdHFlTjk3?=
 =?utf-8?B?aWZTbnZqeFN1L1Vhei9MYzY1bW1jbUNQanhoUnZFbTN0M09rUE4yVDJsMHVY?=
 =?utf-8?B?cHVUTjlKdUlEblE0YkM5azVta3JBejk0N2xEdTFxbExmUTQwS29UR1l6QXJS?=
 =?utf-8?B?cUJ6dzVwVENVZEFXMEYwWkRBUW80SmxKZnlNL1VBV3FDN1FkUlpmQ0RIeEg0?=
 =?utf-8?B?R0dadHMxTEhZblkwZ1E3b2RsNEN5UXY3eUkwTUFZMDRjRCtZcGptQmQ1MTc0?=
 =?utf-8?B?M3l0dU95ZlhkdUwwMjNURUlBNGV0aW9xZG9ucWhHckJwUzVhYnFqVGFUa3lX?=
 =?utf-8?B?K0NNQVhiOXVVeGE1bDhmKzFkbmVHb08yL2pwZzJLa2M1ZngzTXhsR2Y1YWFP?=
 =?utf-8?B?QlVvOWdnR1phUkFpY3U0MFV2b3FXYnl0aUJ1WFhqZGNodUdvZmE4WjBkQ0hx?=
 =?utf-8?B?cXB1QVBYZzExTzEveVNyMDdxYXNNY0NOckkyM0RxNVQzM2xhSEliMWE5TVFD?=
 =?utf-8?B?ZlEyVnpTejBRcW5LaUhGbkZodDVveTFGYWIwSTZQbG9KekpRcVZLMXd3QmRo?=
 =?utf-8?B?LzBuK2MvNXlYZ0RQTnIxd0UxaXJ0ZllkbXRGQTJnSHY4cGRFakdLaCt6azZ6?=
 =?utf-8?B?WGZtK2ZQRTJmSUZxM1k5QndqbWQrY0U2K2FYREo5dnlsYlNDdTVZRWRUVGtk?=
 =?utf-8?B?aTlHOXFvNmd3VzhMaFFqQmdsK3VKZ3pNUjBXQ1Z1RDEwL01VeStlZVNDUUt1?=
 =?utf-8?B?cW5MNXJJZUVBengybFlNSmVETk5WVnVCVXhWQ3M0N1AvSWZpeW1jd1pLelBN?=
 =?utf-8?B?aExwQmcxNGpkRGU2Qi9pNGtYSFR2NFRRUVR4aUZURzk5aXB2UjFRR3BJTnJU?=
 =?utf-8?B?TnB1MXdtc2lsajhIeEUxbXg0MkRFR0M5NnVtUTBmT0tOTEROWFhzZ1RMeUFo?=
 =?utf-8?B?dVgrS25qS00rM21PdTBGbW84R0ZQeUd6R29tK1JxYlFYWi9SMndnZ2JtSkhk?=
 =?utf-8?B?d05jMlM1ZmNFWXBDUDcyQWJ4bEVnWXJCZXlwdU90Rk5Iam1rdmw2YnZuNzVF?=
 =?utf-8?B?eWt0Szh5YjB6dlJzKzRYeEtkR0pDM1BxMHVubjFyUDJJNHNGUU40ck01Z29H?=
 =?utf-8?B?NCtjOHJaNEdrRjFYSzdoaXVqYXR5WkJFMlF5bkc5aXNIVUY3ZXVLbis3N1JW?=
 =?utf-8?Q?0zlRxqlxYvY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW1ZU2REOEZqUDZwN3F2UEFhT0hzUzFsNmVuMnBOTmlQV2Nnb2ljbmxUZGRS?=
 =?utf-8?B?U1p5U2YxRTdXT2Jjbi9Da3FyaGtFS2k0UnZZdHlkdHV4Y2M1UnRINVZQaVZa?=
 =?utf-8?B?UkoxRnRGM1E2N2VxNTlQM3ZlNm1qaVpHTDdzc0hHSmMvQjJMVTM5MXg3bDhy?=
 =?utf-8?B?bEpSeUdNU0JMNlRmbXVuY0VDanpGYmt6THcyejlYT1VQM0QrRDZEWFFCWXkv?=
 =?utf-8?B?bkdXbDRxalBBWVFwaEdEdUZmcTFkam9tcGpXMVV3VkR2R0VsS2lCTml2V3dL?=
 =?utf-8?B?Vll4TWxoTnBtRExWbERjNUMwM2c0SjUyM2dUWCtuSThKaDZJaHpxd01CNTd0?=
 =?utf-8?B?bU1DaXNLdmpVSWRnN2JEVFZVdFIveG9FcXFGZ0pPcG9LN0tCQkV5c3pQQm9m?=
 =?utf-8?B?YnpOOFZSdXlJWGxQc3A0anRGMUV0NVJBRCtOYW1zKzJXSU5kL0xjL1pKeG5N?=
 =?utf-8?B?VlFHQmpSYnhDN2FZVHc4Z1lESjFVRG43eDNoM2pTWU8wZGRMWXp4UVdOaUVV?=
 =?utf-8?B?ZEFZME1xWE1yKzdiTS9ZNUtGTjl5cUZRU1k5MG5YMDRRUUVaNC9MVWVDRDdH?=
 =?utf-8?B?SDJxc1krWDJyeHVLUkMwaFYzeXJaTVFzdTE3UElGZ2s2ekpxSVhySUVSS0p3?=
 =?utf-8?B?MEtEV2hCNkRpbTJCemdzeTdhR1NYbksxSHhENjZ5UGYyT2xlcG1BTDArMGVF?=
 =?utf-8?B?di9HTHl5dnI2NjZQTHNDSDlXSTlod2NoUzlVUmJuZ1NvOCsrYXdOYWpWalRH?=
 =?utf-8?B?Sy9BS3BYNjlmTmV5dEc2VlZjMHFFRzE5eHl5WjRBb0RKUWNSY0NhZGV1UWFB?=
 =?utf-8?B?NTljWElpNG5KdmFMQldCb2E5VVp1dkZhditNUEVKaHp3aklvMUVPdGxleDlQ?=
 =?utf-8?B?VHhMQm5tb0JIR0F5UW5RQWUwMytlbW5zWURNdjRmTkFkUjhQQXljUEgzakRk?=
 =?utf-8?B?UENIWmU3aHFhajlDY09uZzlYdk1WVGRZaW9ubk1BM1lOUlUwckRjWmwzcmhr?=
 =?utf-8?B?Z1Y2TFpnY0FWVGNISGtHa0twS0UzNXZUM0lhREhtWWNFTFlMc1AzV1FLM09W?=
 =?utf-8?B?MVRETTFUVFhmV2xjQkxvd2l4U3NlTmhjR3lub2VBTlJDWVJXRnlqM1ZHaWor?=
 =?utf-8?B?OVhQZEJxR3RPV2s1cGJxaHB0YkYvaUcrY2RqSFVnVWpCcHdTRExBaUpJWm00?=
 =?utf-8?B?M2w4a2VuNzdVTTN4bk9RTG1IcVpQdFlIUGZxWTJSMC9meWQzYnBJdGdPcWF1?=
 =?utf-8?B?SFdaMG41c2FLdldKcHRDSHV5Y0hFaU9ncnZSU0tmY3ZhQ01iOVNtVXp6QjIz?=
 =?utf-8?B?bzB4Tlp4bFduQzk3K1hiM1FOQ1dsQmx4QngwQVJXRy9qT25uTkxWMFpBdlpN?=
 =?utf-8?B?czlBTHJSYm4xK2ZvODFFRzlGZ2JZbGVZNWJEZ053ZGtIb2FEVU9WaDBVNnRL?=
 =?utf-8?B?SDJIYmlnRStyUWxBUEdvY0x6UkM1Q2s2YXhxNFJwSWJPMTdyMFRveWdtN2ZF?=
 =?utf-8?B?OW5NdUJUL1gwbzlnMm9XMTFjajJnRGl1UW8vN3B1ZENKRkZOUWdZZnJoQ2FB?=
 =?utf-8?B?MGd6Z3lEdzdSRTl4eExGOGZ0TWhkcE8zK2t5N1Z4S0sxQnl4dXQzTGpSN0Ir?=
 =?utf-8?B?WHR2eVg0cXdpL1lqNlI3Snk3bmVkWXg3dzJvR1RjWlBpejRJeEcvMXNOQUdy?=
 =?utf-8?B?NlV1c1JVOXIvQW5MYnNTSm9HbkRyaWQrVEFsOFB3R3NxcldoVUVXN09iMlo4?=
 =?utf-8?B?V1V4ckN4V09TeGwrRW9vc21MWkQybHlRSDRMRHBQUFpJVXNXZVJ1dy9zZEdH?=
 =?utf-8?B?WmpiVU5ZV01lUVFhcE9aczZmd08wSWtXelJuYlR5VE5CMHova3M3QUU3cTlH?=
 =?utf-8?B?TXEzTXhodWR3ckRKc2RFbWtaSFRORi9HRm9aUXpjM0ttVExNa2F0bll2SWFG?=
 =?utf-8?B?SStiNStibFdidVlpSm1URVNldDRUOEJYekdoNmlCWmVKUUwvajZXNE8rc1ow?=
 =?utf-8?B?ZHd4UEN3RmdrODlueUh1RjBwOGFRUmZ5eEE3Z2pVM08wK2hIZ0NiQWthdFE1?=
 =?utf-8?B?T3U2YTFJeUVlT3lkRFlHY1hnc0FHOGtoNndJeHVGRzRQWHQvODl4bjR5WkpT?=
 =?utf-8?B?NEpUWUZxODdRT3BUYnZtdzNac3ppT3Y0ZDZNMUZrb2luS1JFeFZmQU11WkhW?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GvQhmKkDRBcFxujTJKCQPacS+XF2JYcLWfvZrGDItB6yC3zE6LToPxQKQwb9E3fQj2a9r16TjN81ZKVJdIMlswiMz/iXwweH1eIF4mpln/350rrJHUMJl42GAw2V1Ga/YKzeGQpTrXuY+4zm6ygf1Mfdg9ZuMTXrkAtUjNE5ipeqttg5YIjwQoarRThtrOOUEeN7/FvlG4ZyjIDLSlN8z8eHRilfvlRcS0MmrVBWlt5yGY0TeITpAZ2noMxd7XuebgIPzs76mJZtcCu6ZhKfLHVDSCIcldNY1kJMemyicoGOMiHOWLNlcmPTvdBHa5DhTQC0DKOxHU136+eaRKc08XyWU+3boRWnVCz/cq8XC9F9gub/ErGucK23m48eSaaJ/Pv9sBIlRrDiBI3Siu/UXcl2BEOGbM6HVAnibL/RnvI3EMDpxmFv+dQiKCshYopde2x+uFzK6fwACcqVWtGwhezrwgn6P6Y3hFvjg1Ez/p3iR87INgTc1IsRJFhYqmSYB1Y34sgD3mUM97ptnPbVH0e8NuVCv2AaFA7fEChN8vR7Axp1PsNTvZPHVyo0ZZ3upzlEcCAkTjG6i/XySr9UpDpwRnkkab+5EJyyJBlqazo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347cc18a-bc2b-4cf3-51f2-08ddf4f77ac0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 08:03:11.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tq/Ucw3am9uEeh80AtsM3QlXnj93b5QdApnWW243pybss1bQQ0ywFnw/mNhJ8wlpS9LM/HpT2uWbWuhxyopMQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160077
X-Proofpoint-GUID: ptXbjIhGyV01F5qajqLDS1SHFLTl5KHk
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c919cc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8
 a=EXoRt7sUP0gmiqUpUYsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX1NKzV+pDmBfb
 XjvyZSUiITM9QGKGNQ/2mw+W0lTMM6DyBsgz4b0wQokvOboUgo+kJNxPHzTyvBWwKQPmMJlm2fv
 OVRbb2eRn+Yp6ADdaHbHB6C5Mrpfi3VwL2DrTjbABZAL8ViviheJqCyxE816K9gVlAFeCvcxikm
 wDz2svQaRKyxPCR7lX9hDh9LGmELOyU6VL+xvR4slpZ7mNP3B/62Xm93XfqnW1ZLUsBTHyExRKC
 hEMsll1ei6j2xH7YllUA1G1ggp74jORRjMQ5bmp7fgCIVwo8sfh9dTVoi9ltMR3yH8CtkS6CZpW
 NuRZfbSD5VtrBqDIKIj4NkMmOBf+56evAWyKc5guMXYaVvaL3jGZM/jnFnNlXpbyAOSNu6exveU
 jjRTwhwEQdn2JYMdzFMdm2Z3iLJDqA==
X-Proofpoint-ORIG-GUID: ptXbjIhGyV01F5qajqLDS1SHFLTl5KHk

On 12/09/2025 19:21, Bart Van Assche wrote:

About "scsi: core: Move two statements", you could be more specific, 
like "scsi: core: Reorder some sdev initialization"

> Move two statements that will be needed for pseudo SCSI devices in front
> of code that won't be needed for pseudo SCSI devices. No functionality
> has been changed.
> 
> CC: John Garry<john.g.garry@oracle.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> ---

This change on its own looks ok, so:

Reviewed-by: John Garry <john.g.garry@oracle.com>

