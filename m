Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3928C218593
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566616; cv=fail; b=nJxELIcYCEr1iZgOdp6+S5/YZVmNd1GWVlYM5oQX49pRKAAKj/Jsrc+iN7IgQ0Ftt6jc8g52tj8fGn9PAZFghiJ8M0Xk17B8YGPOo7ZnF6elg9luyNrC47UBxAeqD0Z9bE7eEhVvuny5nSkJq3p8rC92+J9pWoKj8oklPFizRZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566616; c=relaxed/simple;
	bh=IFf9FiRwvS4fzBzcSTv89YNCdm8kQTioH0y052z63JQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pRIveRmvYZVLbZqOyndwMExbtTzdl8VqEkofy/afmf3Px/NKvEU5NZQH44ILwVVLreOAXiE9UbLEuxJJCGybrp1kwP1QOui4UiqmPUcHRwY97QRxU/1qmMmvkpk2zEP6Jzq95nZYquLB94H+p+emIYiTHBCIbOIIeZ/A4wKqOKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=nxSGs41P; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="nxSGs41P"
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55A5qBnD012307;
	Tue, 10 Jun 2025 09:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=I
	Ff9FiRwvS4fzBzcSTv89YNCdm8kQTioH0y052z63JQ=; b=nxSGs41PqkxmG9KL+
	ymagAGJcg4Yg0qYu/SHgjKY3kxZsW72KyIPHfUNtBCYnN5u/DxI3Bz9FD2Df1UZB
	EgCaqO7TM0GUucfW6ZFTwI3jEL7970HZkLPg14PXR1CPxNjB7YlcRNW1Pvtpg9nU
	raV0C1O0xiSK1wOpojhPx+zcEFh2sn1oAsL06Z1rWKjxnGCJO6CrfwnMKIBrcRMM
	2nASQR/dT+zXGdhTGTayBVe0VmLqPBAWnJILFGmQ8N62my6w6cTfsIMocESKZg1l
	Jnaw9ZKOda87aM0glbGEnxwrKNXup5tBRuq9e3lIzeinBag4d4joG17IPjS7p6Zh
	ZmWKQ==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 474gk1vhte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Jun 2025 09:05:41 -0400 (EDT)
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55ABo0sT022503;
	Tue, 10 Jun 2025 09:05:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 476m6098f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 09:05:41 -0400 (EDT)
Received: from m0142699.ppops.net (m0142699.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55ACWC5D027144;
	Tue, 10 Jun 2025 09:05:40 -0400
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 476m6098eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 09:05:40 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCDxOYEgDAVCbbcHwp0VDKcl0x6IlpnFt97G+6zSdmvVG1uyxcnSYk3Q0qeCd964f45rFhSYpt2mR9yVgNRxDoGGyisDt7C9Bs7YTxvwVp8I6JVHMhXrA2E9nOpYwhDelOREmBSxtya3gJNnU9JbDncCyFQqtIf+x6og1fm845ZWs+RDLW/uuHbIF4J+f8oIx+dXCIPEGGpZFGRtq3PXearyzDaaT2gALirXczDytiIu8mdkIpIcevZFWA3sne0FF4IfgRir73SkQ0sBmNjHEW/gVCBsEzSu7vS+J3ZGo+dlogcgFBwe8rnZqCzIHQFoZ+L2hWKoUiPPYFx7dZm+xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFf9FiRwvS4fzBzcSTv89YNCdm8kQTioH0y052z63JQ=;
 b=bqDJqZ+7kNQskfF0fnCTrEwmg8BNVh1fkfJWXXfrrp79BSIb1BXgY6FJCmGgBAsI7j0rUFJxVcgD68gtQxg27bDII/jtDmppGKBYigVDMNSnJnrWkEXBAnL5gug8p6OdjUCPLZLTNwGaHI9I9KeK7rJZX3ykqP2uUvPsoXZ8K0kYAfyIqt558nxv7Jh1MCjIcqhDZ4vAJEnjgbskCVRlshMXGQkedSzwWpZf6lJ+iZzw4O0mfNCORHKQ1mH/uT0+IC5DYHRRBiq01OLFI3Mlm+Bttaya5IpT4HaVBnAxR8g5/se/sLlqaLFZeVTsIomdfyd9a4aCsf/Tsraazykg9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from PH7PR19MB7533.namprd19.prod.outlook.com (2603:10b6:510:27c::13)
 by SJ2PR19MB8096.namprd19.prod.outlook.com (2603:10b6:a03:53a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 10 Jun
 2025 13:05:36 +0000
Received: from PH7PR19MB7533.namprd19.prod.outlook.com
 ([fe80::79cf:e57e:fe6e:95b6]) by PH7PR19MB7533.namprd19.prod.outlook.com
 ([fe80::79cf:e57e:fe6e:95b6%7]) with mapi id 15.20.8769.025; Tue, 10 Jun 2025
 13:05:36 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: 'Jason Yan' <yanaijie@huawei.com>, 'John Garry' <john.g.garry@oracle.com>,
        "'james.bottomley@hansenpartnership.com'"
	<James.Bottomley@HansenPartnership.com>,
        "'Martin K . Petersen'"
	<martin.petersen@oracle.com>
CC: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index:
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEAAB4+wAAANgfMAACRv3gAAUU6tAAA5fz4AAALb0kACNhawAAKKd7xBNCiUDYA==
Date: Tue, 10 Jun 2025 13:05:36 +0000
Message-ID:
 <PH7PR19MB7533B517D647D88C48BE215CC46AA@PH7PR19MB7533.namprd19.prod.outlook.com>
References:
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <ec087459-ae19-f593-f046-846c041e397d@huawei.com>
 <SJ0PR19MB5415CA74D010E7D35263FFDCC4E32@SJ0PR19MB5415.namprd19.prod.outlook.com>
In-Reply-To:
 <SJ0PR19MB5415CA74D010E7D35263FFDCC4E32@SJ0PR19MB5415.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=b46c10d7-e9bc-4162-981c-7d27da6c0870;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2024-05-14T09:17:31Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR19MB7533:EE_|SJ2PR19MB8096:EE_
x-ms-office365-filtering-correlation-id: bdc219aa-4d1b-446a-3582-08dda81f7dfe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WFVZUzQybkpPTG9KL3NqekhSaDhHUnJDWjRWeXhKQ0FxSXpJeWlQNUp2bGxu?=
 =?utf-8?B?T1hzTFZwd2t6b0R4VEhkSEpJQ2M0TDdsSHBpNnd5UTZUYUFnMWhVcU9zNW1k?=
 =?utf-8?B?NG54MmcwOVdJdG5kSkxvSjVIOWpnQ05abXZZaW5VS1kyamgvdkFWcDZiWjNQ?=
 =?utf-8?B?WnpJMEozV20vMklmL2lSVzBkY0V2bk9iMElpa0NWOUszWmJja1E1ZTQwMmc1?=
 =?utf-8?B?WGpzNGk4amUzUGM3Q3I0OHp2Z3NERytnRmI2OHM2alF1TUZEZW5FbFY2cVdH?=
 =?utf-8?B?bUIyTkpRR3ViL3RnRzAyTGlqOGZlK3lHMGNCZS94NWh2YnJSSElBUDFtUUdG?=
 =?utf-8?B?ZnRIUzhPZDZ3Zk00d2pGU1MwWCs0SnlrM3Y1WklXblpBRlF4djN3ZW1VVlBj?=
 =?utf-8?B?TzhOK3NMamtRQzRLZ0YvWjhjY0NNTFhvQ2k2Vy9qeG1RUlVhRzc2a0szNGlw?=
 =?utf-8?B?czV2N2Y0MTY2UHlkZmE3RitNQXpkYTlGM1pJaXJoVFVSUTBPRUdFYlg1RU11?=
 =?utf-8?B?VjNWdy80ODArUmR5WEpaNUNGUW5LdEUxSlFydGFUZGNpMkpFdXJVdnZsNTJI?=
 =?utf-8?B?cFhvcExQRDVpNXZoK25leXFpM3pPbUk1S1l4NnQvOWJKQjJ1WVZtbUIwUkJU?=
 =?utf-8?B?SXFJQVVvMWFuRnlIM0EvZ3Rsc3l0VkNIb1VpMFh4MW1wYUZ1KzNlUGltWk8y?=
 =?utf-8?B?b3p0YWZ4RERad0dUeGJWc0hpZVRpcHZoZTFJUmdKTGYzT2o4ejVWczdaOE4x?=
 =?utf-8?B?dGgyVmtJVko3S1pBM05QcithZ0tCcytzeGFUcTBlNmR3K0xNTnkvSXF3MlZB?=
 =?utf-8?B?Y25qeDUrc2ovZVdxYzZoSFB6aWk3UWIwVmxCY3hlRlYyNzY3RHpHZlkwREFa?=
 =?utf-8?B?TlJHMS9FZUYwaGZ5MmU0elcvc2J4Wm5pWlduMGovcW4yNXJFbUVNRnhWZkor?=
 =?utf-8?B?UnAxZVppK0k2ZHFmVzVVc3BPMnlmTG5LcnFoRWFyVzlxN2pDMTdqOW1DN1FU?=
 =?utf-8?B?UnVMOXVyQ1RmVzF2K0E0U1ZoM25ER3FMQmlSZHRzbXBQVHVUN3ptR0hqZlVy?=
 =?utf-8?B?L2tPNzZ2VVpKeXBWUEVKcDd3bTNRc1NkTWxYTnlBaFA0ZlRDSnA4Qy9iMHFl?=
 =?utf-8?B?SHlCdUthZmE3MXNYWVR3K0tTNWJBT05mbmROMlBEL09aN29KZ0JzU1d4WStv?=
 =?utf-8?B?SnloTXhIQkpYUjFNaEtyalB5QktrZklwYUR6MnVMNi9SZWFjblo1cy9MR0NS?=
 =?utf-8?B?ZGNjYjJvTHdoeXJXVjVXZG9lZGZnVHh0YnkySUFIcGhGYnBSeUJKdzBWNDg1?=
 =?utf-8?B?aEdzeU1rYkEyN2RzVDdjcCszRlpBZjJ0aDdqam5jN2lPeDZGaUZmbmF4eXV2?=
 =?utf-8?B?UGF2ZVBpckY3VmNIcGVSVUlZckxaSGt5M0RNMGNVdHdXcHhaRXpCSjFQbmE3?=
 =?utf-8?B?OTllQkF5bStQZXk2TUV3L0Y3N0JBb0prT1NHZkl0ZkRQZllhRkVwbCtWck5n?=
 =?utf-8?B?amdTdkZ6YlpTNThtMWpvRWYzV1VIeDlhbG0vTVRObWc1c0E2OTlTaDhJM1dr?=
 =?utf-8?B?bjN5Ykhac0R2dkJOTFdZTWV3aEYzYnlUaTNCdTNqRGtIWHFxQ1JsVWh2RDRv?=
 =?utf-8?B?aXh5NTRNTy9XQ3hCck1hZ0xwR1FTREYxUkNpNTh5TmJjbEpkSzFSQ2hsNU9s?=
 =?utf-8?B?VFM2WldYWTR2OUt0QU01emFKVHkrNDdCMFd4ZzM5bVBuVU42cDFFNFpMWHFC?=
 =?utf-8?B?aHBjYm13MHljQzV0d1ZmNHFPVDRKaEx2QnBjWThtenNEaTdQb0c1VklqRGtG?=
 =?utf-8?B?V21OdXRYeWtWTEdpQTkvTGpXNGJTZUJMNUxkbHZUbmQwbElITlhOOXA0cFdH?=
 =?utf-8?B?Mmg5bEQ4TDZvcnJjZmt4MlNIb2Jjd0xsZXN3OFNQRTBEbUp3eFZVQytGQWNz?=
 =?utf-8?B?Q2VzQm9JU2pHejB1eStoSmVJMi9MY09ieUhKNHFNWTlvTWtwdXZaMVV0MDdN?=
 =?utf-8?B?QUU3WmhwYXZRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR19MB7533.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eTRWYm5TTHQ4Mm1NdENNY2xYY1BJM3RwSzdoU0gvSmFmbXJKR2lCRXhzOWRa?=
 =?utf-8?B?eGZzZkFXc05JTk5zanlwd3o0d0pzOU1ick5XbDFPTzJ6dGNSaHV6QUVaWlZi?=
 =?utf-8?B?WEhHOHc3OVpvL3ZNRnZhdDcxUWxZcmVjVUE0ZVVuWDE2aTBTVDU5MHhXTEsv?=
 =?utf-8?B?Z0VEVU1jQ0o2Lzd0b0ptS3M0L3o1akN4Z2dSVUdXVnlFUFZBa3JKNDY4ZzhM?=
 =?utf-8?B?REkyR3prS3hydkhYZWlDNDVOYms3a0VveGkxUDY3ZlNRL3U4OVZqTXhBeHB4?=
 =?utf-8?B?azU5Q2tGN0o5ZXVLRGZVcVV2MHNXdXpXeTBkZnNYVEp3Mkg4NEFEckVEZHNR?=
 =?utf-8?B?S3FwV3QzbU1RQ1BvSzBvYm1oSWNuQTRTWFBVWVduNUhTTE1LSERZM1VZMXIz?=
 =?utf-8?B?OHBEbWlPSmZCZFFhK3Z0bEZLdmx2anQ1T1FNOSs3VUdrK2N4NVRkN3dqV3d0?=
 =?utf-8?B?dDJhd3ZoWHZqSzh6VW1xTnplaVlDT2t3UmlGNnRkcEhJeHVPREdpTk9LUFE0?=
 =?utf-8?B?NHRUeFc2MkMvVGZlRG1jMmQwRjRMMHE3RVNKUFBlZUZSYm9kMFVRRlcvcXJ0?=
 =?utf-8?B?ZURlS1c1YmRRclRoMWlvZDlDL1FQQmRPc215QjNyQlpiYllaVzQ1RThaUFY1?=
 =?utf-8?B?NlRHQ2VZWDZwNTVockIyenNFMVhZVVZOZEo4MUtFdkpKVUgyb3k2QzlQdmZL?=
 =?utf-8?B?Ylh1bGdpOE9QVUQzeDRDKytKcm9vNGYyZnFraVN1RDl5YmZOUm56cVBkQzJH?=
 =?utf-8?B?c2Z4bFpNVGVrRUovaEJvQXNDM0orS2NyN0RJMzkxZ2xuN2JZb2NPMFd5VGhP?=
 =?utf-8?B?MWpkWkFIS2hIZ3haeTBxTlo0eWROWGpEU2h2WGZQR3d4ZFo5MnhNN2REYjlU?=
 =?utf-8?B?UTNEL1c3aUhFMnNMNzZDaGxwZ0REQktxa0Q4cnFkM2JrS3N2cDlVM01xUDVj?=
 =?utf-8?B?N0pHSXBZVm9PRi9pR2NOa1dHUTR6U2RNTVpBbkxqaGJPdzlOKzVwRmp4YTlC?=
 =?utf-8?B?RW90WnBGT3NxOFRXZ29GNG1ybFUxcytiQVpZL0VhMTcwU0hmejFBbUc5WHdK?=
 =?utf-8?B?dXBCOTBmTmNLTHdYSGRKa3gyalRPd2ROeUhMQlBTeFZ2YWp5M1ZGNCtNY2l2?=
 =?utf-8?B?QkNYcnAySkZOck56VW1UbTROTSttdFU0cHNzMTRmMTRXYWZDUkl1b1U5MkY5?=
 =?utf-8?B?QkpjeGNwZFlBY1Npd201WWtIejR6VWdWRnlJMS9YUHNRZThBMTROSDBVNVhO?=
 =?utf-8?B?Qm5MbURuaUNQNlBPMEplQXdDYXNndzVyM21WVzZXalBXd3l3U3dWMmQ4NDZO?=
 =?utf-8?B?SFhQZkczLzc1YlNpMDdKK2xoNmxaaTJVeEx4ZHhMZzYwQm5iSmx1cm5iWEtE?=
 =?utf-8?B?N0N3RUtBUnpRTjBzOUFKRTZ6K2FNSjdhSGNPdXp2V3lDT0pHbHpaWStEZHBo?=
 =?utf-8?B?aUNEdHNZeGFmVWlVeVpqV0ZyeWlySm9sTGdZWGsxakNQdlJTRFRQeE4vWHVR?=
 =?utf-8?B?MzN2TlN1WXlEOFJRdmlkVDZlaXVudy9uMmpaNmxxc1ByWWF0MGhaOWFneEgr?=
 =?utf-8?B?L3BQRksvZE11TXVVbnRibUtYR0hYaC9jTkFuVWt2djlGSE42Ui9Kdy9WRm5u?=
 =?utf-8?B?aHJ0WjdNTUJscTRxci9hOW9ZTWN1M1pBaG02RTBWYWc4bmhraVJPNVRjUjlH?=
 =?utf-8?B?RUhySjdIQllnZTV6Y3Rkdzh0b1RBY1Vla2JGWGt4S1pjTUdoSE9DeWxyckVh?=
 =?utf-8?B?MEs0VlBwaFR6aFdnWkFiTDkrSENyaXMvUTEwRkUzR0MxQjBzSmR4OE1razht?=
 =?utf-8?B?N0t2VWVPN0VvbEhDSDhaUXViR2JjZEhUYXVZcHlldEh1bUJoUVY3WVFWb3B5?=
 =?utf-8?B?Ui9NeWN5R0xIbzI3MnA3Z21adWY3ZWQ2Q1dldTEvTHRpc0ZvclhLdXZxMEpH?=
 =?utf-8?B?Z0JoeXZRRzF0c21sdGhRWkNIY1Fad2dnS3ptMEpkZW9QdHZ4RDcwN2tUMnVp?=
 =?utf-8?B?czRrdERwRnhwK2tzOXBTaVJrMzFoK3J6MmgvbVViamxyNmhmMTJFU3E4Qk9u?=
 =?utf-8?B?ekRVRjZTbTJkU0QyQW1mRmY5YlczRjNET1NvTk8zWGhrbDhDejNvVTBDWUlI?=
 =?utf-8?Q?ZdqUPKiX2Ih+0BJcJ4jYuJWfj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR19MB7533.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc219aa-4d1b-446a-3582-08dda81f7dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 13:05:36.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZ70vbRX/2VL5W6GI4FsSXc5IrxyE1Su5c4s4XN5lr5/Blxthg0Ikyez97zK6qjyavIKjKH6j/HjPnL2udDwJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB8096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1011 mlxscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506100102
X-Proofpoint-ORIG-GUID: W3v9piK3exyPhb8LngxUTZgDvrX1sc4y
X-Proofpoint-GUID: W3v9piK3exyPhb8LngxUTZgDvrX1sc4y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDEwMSBTYWx0ZWRfX6ICANaDQnvUL qZT28Cb5EHOxDEHigtBX1Bf1srfEHeRM14O72eWTB2zfDnYO/8Dg7spnYCTGQ2JctLFOapMBQ0G FQmvSGD9LqvN3TT5IGxBS6qDrYR2bJfFptEZ291Lyqe2wNC+vU7vszLxLdVoQU/V6hqaFcIaWuS
 9KoYw9ynhpGp4lOVauTEh/mi7rtHhOpfEAaMmSFTgELgitdmgBENRYAbUgkAdX7/ndDqiN+Z2K7 vyujK4QyUUT0II4f8RYtk7O1XlY58knrt9iYBGR54GT/dJr8oPvxwBOZXagB/+5O4fbQNxWVRxJ D8hquXOlCUdyVZERkyBD3GIjn7fDLYaynwfVZntrznIefgiifK6OH7HrfsPYAXMwXFxWeWEmkls
 uKajvxQsSGa03yiJe8SorHUResKrlUP3WO5KWcSNbx0DkALSITqifQy+39MsIrmzL5FDqdPx
X-Authority-Analysis: v=2.4 cv=BvmdwZX5 c=1 sm=1 tr=0 ts=68482da5 cx=c_pps a=j0++y401J6f/BxNAf5EDow==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=etr23nxs6_M-gndy:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=bLk-5xynAAAA:8 a=VwQbUJbxAAAA:8 a=iLNU1ar6AAAA:8 a=jsi4ET_n1fTt7euw53kA:9 a=QEXdDO2ut3YA:10 a=gbU3OgOOxF9bX48Letew:22 a=zSyb8xVVt2t83sZkrLMb:22
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506100101

SmFzb24sDQoNClNvcnJ5IGZvciBib3RoZXJpbmcgeW91Lg0KSXMgdGhpcyBmaXggbWVyZ2VkIGlu
dG8ga2VybmVsIHVwc3RyZWFtPw0KSWYgc28sIGNvdWxkIHlvdSBwbGVhc2UgbGV0IG1lIGtub3cg
d2hpY2ggTGludXgga2VybmVsIHZlcnNpb24gaW5jbHVkZXMgdGhpcyBmaXg/DQpUaGFua3MuDQoN
CkVyaWMgTEkgKEhvbmdnYW5nKQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IExpLCBFcmljIChIb25nZ2FuZykNCj4gU2VudDogVHVlc2RheSwgTWF5IDE0LCAyMDI0IDU6
MjMgUE0NCj4gVG86IEphc29uIFlhbiA8eWFuYWlqaWVAaHVhd2VpLmNvbT47IEpvaG4gR2Fycnkg
PGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPjsNCj4gamFtZXMuYm90dG9tbGV5QGhhbnNlbnBhcnRu
ZXJzaGlwLmNvbTsgTWFydGluIEsgLiBQZXRlcnNlbg0KPiA8bWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20+DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTog
SXNzdWUgaW4gc2FzX2V4X2Rpc2NvdmVyX2RldigpIGZvciBtdWx0aXBsZSBsZXZlbCBvZiBTQVMg
ZXhwYW5kZXJzIGluDQo+IGEgZG9tYWluDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+ID4gRnJvbTogSmFzb24gWWFuIDx5YW5haWppZUBodWF3ZWkuY29tPg0KPiA+IFNlbnQ6
IFNhdHVyZGF5LCBNYXkgMTEsIDIwMjQgMTE6NDEgQU0NCj4gPiBUbzogTGksIEVyaWMgKEhvbmdn
YW5nKSA8RXJpYy5ILkxpQERlbGwuY29tPjsgSm9obiBHYXJyeQ0KPiA+IDxqb2huLmcuZ2FycnlA
b3JhY2xlLmNvbT47IGphbWVzLmJvdHRvbWxleUBoYW5zZW5wYXJ0bmVyc2hpcC5jb207DQo+ID4g
TWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+DQo+ID4gQ2M6
IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IElzc3VlIGluIHNh
c19leF9kaXNjb3Zlcl9kZXYoKSBmb3IgbXVsdGlwbGUgbGV2ZWwgb2YgU0FTDQo+ID4gZXhwYW5k
ZXJzIGluIGEgZG9tYWluDQo+ID4NCj4gPg0KPiA+IFtFWFRFUk5BTCBFTUFJTF0NCj4gPg0KPiA+
IE9uIDIwMjQvNS84IDE2OjI5LCBMaSwgRXJpYyAoSG9uZ2dhbmcpIHdyb3RlOg0KPiA+ID4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPj4gRnJvbTogSm9obiBHYXJyeSA8am9obi5n
LmdhcnJ5QG9yYWNsZS5jb20+DQo+ID4gPj4gU2VudDogV2VkbmVzZGF5LCBNYXkgOCwgMjAyNCAz
OjQ4IFBNDQo+ID4gPj4gVG86IExpLCBFcmljIChIb25nZ2FuZykgPEVyaWMuSC5MaUBEZWxsLmNv
bT47IEphc29uIFlhbg0KPiA+ID4+IDx5YW5haWppZUBodWF3ZWkuY29tPjsgamFtZXMuYm90dG9t
bGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbTsNCj4gPiA+PiBNYXJ0aW4gSyAuIFBldGVyc2VuIDxt
YXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gPiA+PiBDYzogbGludXgtc2NzaUB2Z2VyLmtl
cm5lbC5vcmcNCj4gPiA+PiBTdWJqZWN0OiBSZTogSXNzdWUgaW4gc2FzX2V4X2Rpc2NvdmVyX2Rl
digpIGZvciBtdWx0aXBsZSBsZXZlbCBvZg0KPiA+ID4+IFNBUyBleHBhbmRlcnMgaW4gYSBkb21h
aW4NCj4gPiA+Pg0KPiA+ID4+DQo+ID4gPj4gW0VYVEVSTkFMIEVNQUlMXQ0KPiA+ID4+DQo+ID4g
Pj4gT24gMDgvMDUvMjAyNCAwMTo1OSwgTGksIEVyaWMgKEhvbmdnYW5nKSB3cm90ZToNCj4gPiA+
Pj4+PiBDYWxsIHRvIHNhc19leF9qb2luX3dpZGVfcG9ydCgpIG1ha2VzIHRoZSByZXN0IFBIWXMg
YXNzb2NpYXRlZA0KPiA+ID4+Pj4+IHdpdGggdGhhdCBleGlzdGluZyBwb3J0DQo+ID4gPj4+PiAo
bWFraW5nIGl0IGJlY29tZSB3aWRlcG9ydCkgYW5kIHNldCB1cCBzeXNmcyBiZXR3ZWVuIHRoZSBQ
SFkgYW5kDQo+ID4gPj4+PiBwb3J0LiA+IFNldCBQSFlfU1RBVEVfRElTQ09WRVJFRCB3b3VsZCBt
YWtlIHRoZSByZXN0IFBIWXMgbm90DQo+ID4gPj4+PiBiZWluZyBzY2FubmVkL2Rpc2NvdmVyZWQg
YWdhaW4gKGFzIHRoaXMgd2lkZSBwb3J0IGlzIGFscmVhZHkgc2Nhbm5lZCkuDQo+ID4gPj4+Pg0K
PiA+ID4+Pj4gSWYgeW91IGNhbiBqdXN0IGNvbmZpcm0gdGhhdCByZS1hZGRpbmcgdGhlIGNvZGUg
dG8gc2V0IHBoeV9zdGF0ZQ0KPiA+ID4+Pj4gPSBESVNDT1ZFUkVEIGlzIGdvb2QgZW5vdWdoIHRv
IHNlZSB0aGUgU0FTIGRpc2tzIGFnYWluLCB0aGVuIHRoaXMNCj4gPiA+Pj4+IGNhbiBiZSBmdXJ0
aGVyIGRpc2N1c3NlZC4gPj4NCj4gPiA+Pj4gT0suIEkgd2lsbCB3b3JrIG9uIHRoYXQgYW5kIGtl
ZXAgeW91IHVwZGF0ZWQuDQo+ID4gPj4NCj4gPiA+PiBJIGV4cGVjdCBhIGZsb3cgbGlrZSB0aGlz
IGZvciBzY2FubmluZyBvZiB0aGUgZG93bnN0cmVhbSBleHBhbmRlcjoNCj4gPiA+Pg0KPiA+ID4+
IHNhc19kaXNjb3Zlcl9uZXcoc3RydWN0IGRvbWFpbl9kZXZpY2UgKmRldiBbdXBzdHJlYW0gZXhw
YW5kZXJdLCBpbnQNCj4gPiA+PiBwaHlfaWRfYSkgLT4gc2FzX2V4X2Rpc2NvdmVyX2RldmljZXMo
c2luZ2xlID0gLTEpIC0+DQo+ID4gPj4gc2FzX2V4X2Rpc2NvdmVyX2RldihwaHlfaWRfYikgZm9y
IGVhY2ggcGh5IGluIEBkZXYgbm9uLXZhY2FudCBhbmQNCj4gPiA+PiBub24tZGlzY292ZXJlZCAt
PiBzYXNfZXhfZGlzY292ZXJfZXhwYW5kZXIoIFtkb3duc3RyZWFtIGV4cGFuZGVyXSkNCj4gPiA+
PiBmb3IgZmlyc3QgcGh5IHNjYW5uZWQgd2hpY2ggYmVsb25ncyB0byBkb3duc3RyZWFtIGV4cGFu
ZGVyLg0KPiA+ID4+DQo+ID4gPj4gQW5kIGZvbGxvd2luZyB0aGF0IHdlIGhhdmUgY29udGludWUg
dG8gc2NhbiBwaHlzIGluDQo+ID4gPj4gc2FzX2V4X2Rpc2NvdmVyX2RldmljZXMoc2luZ2xlID0g
LTEpIC0+DQo+ID4gPj4gc2FzX2V4X2Rpc2NvdmVyX2RldihwaHlfaWRfYikgLT4NCj4gPiA+PiBz
YXNfZXhfam9pbl93aWRlX3BvcnQoKSAtPiAgZm9yIGVhY2ggbm9uLXZhY2FudCBhbmQgbm9uLWRp
c2NvdmVyZWQNCj4gPiA+PiBwaHkgaW4gcGh5X2lkX2Igd2hpY2ggbWF0Y2hlcyB0aGF0IGRvd25z
dHJlYW0gZXhwYW5kZXIuDQo+ID4gPj4NCj4gPiA+PiBDYW4geW91IHNlZSB3aHkgdGhpcyBkb2Vz
IG5vdCBhY3R1YWxseSB3b3JrL29jY3VyPw0KPiA+ID4+DQo+ID4gPg0KPiA+ID4gYmVmb3JlIGNh
bGxpbmcgc2FzX2V4X2pvaW5fd2lkZV9wb3J0KCksIHNhc19kZXZfcHJlc2VudF9pbl9kb21haW4o
KQ0KPiA+ID4gZmluZHMgdGhlIGF0dGFjaGVkX3Nhc19hZGRyZXNzIG9mIFBIWSAocGh5X2lkX2Ip
IGlzIGFscmVhZHkgaW4gdGhlDQo+ID4gPiBkb21haW4gb2YgdGhhdCByb290DQo+ID4gcG9ydCwg
YW5kIHRoZW4gZGlzYWJsZSBhbGwgUEhZcyB0byB0aGF0IGRvd25zdHJlYW0gZXhwYW5kZXIgKGlu
DQo+ID4gc2FzX2V4X2Rpc2FibGVfcG9ydChkZXYsDQo+ID4gYXR0YWNoZWRfc2FzX2FkZHIpKSBU
aGVyZWZvcmUsIEkgdGhpbmsgd2UgbmVlZCB0byBzd2l0Y2ggdGhlIG9yZGVyIG9mDQo+ID4gZnVu
Y3Rpb24gY2FsbCB0bw0KPiA+IHNhc19leF9qb2luX3dpZGVfcG9ydCgpIGFuZCBzYXNfZGV2X3By
ZXNlbnRfaW5fZG9tYWluKCkuDQo+ID4NCj4gPiBIaSBFcmljLA0KPiA+DQo+ID4gQ2FuIHlvdSB0
ZXN0IHRoZSBmb2xsb3dpbmcgcGF0Y2ggdG8gc2VlIGlmIGl0IHdvcmtzPw0KPiA+DQo+ID4gQXV0
aG9yOiBKYXNvbiBZYW4gPHlhbmFpamllQGh1YXdlaS5jb20+DQo+ID4gRGF0ZTogICBTYXQgTWF5
IDExIDExOjMzOjM1IDIwMjQgKzA4MDANCj4gPg0KPiA+ICAgICAgc2NzaTogbGlic2FzOiBTa2lw
IGRpc2FibGUgUEhZcyB3aGljaCBjYW4gZm9ybSB3aWRlIHBvcnRzDQo+ID4NCj4gPiAgICAgIFNp
Z25lZC1vZmYtYnk6IEphc29uIFlhbiA8eWFuYWlqaWVAaHVhd2VpLmNvbT4NCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jDQo+ID4gYi9kcml2
ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jDQo+ID4gaW5kZXggZjZlNmRiOGI4YWJhLi4z
OWE4Njg1N2JjNTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhw
YW5kZXIuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9saWJzYXMvc2FzX2V4cGFuZGVyLmMNCj4g
PiBAQCAtNjE4LDE1ICs2MTgsMTcgQEAgc3RhdGljIHZvaWQgc2FzX2V4X2Rpc2FibGVfcG9ydChz
dHJ1Y3QNCj4gPiBkb21haW5fZGV2aWNlICpkZXYsIHU4DQo+ID4gKnNhc19hZGRyKQ0KPiA+ICAg
ICAgICAgIH0NCj4gPiAgIH0NCj4gPg0KPiA+IC1zdGF0aWMgaW50IHNhc19kZXZfcHJlc2VudF9p
bl9kb21haW4oc3RydWN0IGFzZF9zYXNfcG9ydCAqcG9ydCwNCj4gPiArc3RhdGljIGludCBzYXNf
ZGV2X3ByZXNlbnRfaW5fZG9tYWluKHN0cnVjdCBkb21haW5fZGV2aWNlICpkZXYsDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTggKnNhc19hZGRyKQ0K
PiA+ICAgew0KPiA+IC0gICAgICAgc3RydWN0IGRvbWFpbl9kZXZpY2UgKmRldjsNCj4gPiArICAg
ICAgIHN0cnVjdCBkb21haW5fZGV2aWNlICp0bXA7DQo+ID4NCj4gPiAgICAgICAgICBpZiAoU0FT
X0FERFIocG9ydC0+c2FzX2FkZHIpID09IFNBU19BRERSKHNhc19hZGRyKSkNCj4gPiAgICAgICAg
ICAgICAgICAgIHJldHVybiAxOw0KPiA+IC0gICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShkZXYs
ICZwb3J0LT5kZXZfbGlzdCwgZGV2X2xpc3Rfbm9kZSkgew0KPiA+IC0gICAgICAgICAgICAgICBp
ZiAoU0FTX0FERFIoZGV2LT5zYXNfYWRkcikgPT0gU0FTX0FERFIoc2FzX2FkZHIpKQ0KPiA+ICsg
ICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeSh0bXAsICZkZXYtPnBvcnQtPmRldl9saXN0LCBkZXZf
bGlzdF9ub2RlKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGlmICh0bXAtPnBhcmVudCA9PSBkZXYp
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gKyAgICAgICAgICAg
ICAgIGlmIChTQVNfQUREUih0bXAtPnNhc19hZGRyKSA9PSBTQVNfQUREUihzYXNfYWRkcikpDQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiA+ICAgICAgICAgIH0NCj4g
PiAgICAgICAgICByZXR1cm4gMDsNCj4gPiBAQCAtOTczLDcgKzk3NSw3IEBAIHN0YXRpYyBpbnQg
c2FzX2V4X2Rpc2NvdmVyX2RldihzdHJ1Y3QgZG9tYWluX2RldmljZQ0KPiAqZGV2LCBpbnQgcGh5
X2lkKQ0KPiA+ICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gICAgICAgICAgfQ0KPiA+
DQo+ID4gLSAgICAgICBpZiAoc2FzX2Rldl9wcmVzZW50X2luX2RvbWFpbihkZXYtPnBvcnQsIGV4
X3BoeS0+YXR0YWNoZWRfc2FzX2FkZHIpKQ0KPiA+ICsgICAgICAgaWYgKHNhc19kZXZfcHJlc2Vu
dF9pbl9kb21haW4oZGV2LCBleF9waHktPmF0dGFjaGVkX3Nhc19hZGRyKSkNCj4gPiAgICAgICAg
ICAgICAgICAgIHNhc19leF9kaXNhYmxlX3BvcnQoZGV2LCBleF9waHktPmF0dGFjaGVkX3Nhc19h
ZGRyKTsNCj4gPg0KPiA+ICAgICAgICAgIGlmIChleF9waHktPmF0dGFjaGVkX2Rldl90eXBlID09
IFNBU19QSFlfVU5VU0VEKSB7DQo+ID4NCj4gPg0KPiA+DQo+IA0KPiBJIGFtIHN0aWxsIHdhaXRp
bmcgZm9yIGZlZWRiYWNrIGZyb20gb3VyIHRlc3QgdGVhbS4NCj4gRnJvbSBmdW5jdGlvbmFsaXR5
LCBJIHRoaW5rIGl0IHNob3VsZCB3b3JrIGFzIGl0IHNraXBzIHNhc19kZXZfcHJlc2VudF9pbl9k
b21haW4NCj4gY2hlY2sgZm9yIHRoZSByZXN0IFBIWXMgaW4gdGhlIHdpZGUgcG9ydC4NCj4gQnV0
IGZyb20gbG9naWMsIEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdGhhdCBjaGVja2luZyB3aWRlIHBv
cnQgaXMgcHJpb3IgdG8gY2hlY2tpbmcNCj4gc2FzIGFkZHJlc3MgZHVwbGljYXRpb25faW5fZG9t
YWluLg0KPiBKdXN0IG15IHR3byBjZW50cy4NCg==
