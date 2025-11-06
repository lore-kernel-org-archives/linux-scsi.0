Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C3523B616;
	Thu,  6 Nov 2025 06:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762411266; cv=fail; b=EvcJv/hQoS28LQUd5YDth+R8Zdfl4yjHW4OcXzHEZS7zpLwfPat+639eTgfEK2bUu1ndlICvveIggwOCSUybE5HKjqmYuFHxuPMkxssua3ZT11vkJzjT+2kVAiAebS8ORLmfqPcgzilqjaUHmeML6MOJVafFNH9gx+Jkbrmmgak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762411266; c=relaxed/simple;
	bh=ikut3mlNIkDOV9hWhaM7/BtT0B41LgEVjkj9GB7Ksxc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TwEWHnXi6h7IQFVf0MoZ2NwGsXoLLJX61QxaY90MRG6VU4RHTyqg7/S6VcFRKwmugVCd7pKk3Sqd3vx2pR1hZJ25zj0Fq6insSNHcIEWbkCYmQ0NO/toaEUOnfYuKzSn9KIKOaH1wP5LmEw1CvcRSA9YioKW0ezqvYRogpWeVvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KRywKLS8; arc=fail smtp.client-ip=52.101.43.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KRywKLS8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFD9jMMCxexk2StjpFyr0elY8Cw7STBSgMpcQztMMO3jhHwic1qqJoYCzi7nkUimFjaEGlZWxM+1mHv+YndgZ8XdbZsMkwwy+3iGYpiK5lJNvOa7qNOyDDUB3l5oltNDy8KwHDvxg7FcXYRa61deWJYZ2pqw6bCO/qcySxrK5J71GAVmOAvKSCmNLk6MDg3dqEprU3p2xIdxjaGITfMQcb+LBzb01WabQ9D0OwcZPvGVPVlKMNorvT5YhXUC6s/wZX85+bce5FoD4UVMSvWfy5qga8ZlSug0Z9GTB3FJLeRzRMcPAwtxQy8OeAxqMpATn3DWwDwWGwC6wWBPsN44aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikut3mlNIkDOV9hWhaM7/BtT0B41LgEVjkj9GB7Ksxc=;
 b=aAVNhfdOOt12lSUVwA8H2HR5y36K0r8zvmbZkk1p1q1j9VoNRQ0Ckzx5d2QUXvIpnNtjiwT2HE7j3T1bVtkOE6Gy1GPcKXjHiTDRo8J40Rhmqy8wUfNghT1gJYmyI3CslZ+27kaiYvjxwxGeSWjJzPMUFBpuVsDdnCn2LYf+w48CP3j95bFkCifyGEvcgtgsDGVs0aQiTDgvPp0DF4rJQGvQsmEs+wuPbw2OpAFTOfYZS8HMTIDUNJOy6BH+x71Jy3fha5IjCv/2ai5wsyeiRi6auPEcZkDn6dOP3DEXxCtlSBQxe82/Z40cGZDlzSNbvT1/WbSabR0QOWZWm1dIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikut3mlNIkDOV9hWhaM7/BtT0B41LgEVjkj9GB7Ksxc=;
 b=KRywKLS8u4t9MGYO7dbI10pv4Q4j8cCKWueiKehb7unOv2Xm8UKpKv5G+kWGS3eO7wsohDvL2LFOkqlzTyj5BKp8MbZcoitq6cBf7Gf3W6YQ5Ms6oOTuXFCWvpZbcc4qWu8Ql8adrgq8BiMEFWJgweZ92SySH4WgY+gCHj+GqH+Kh5HpJgZlv4BKThGDswi1BmrPn3vdWBvEdOdxVxYKifhCw4G5yG5XSUJY2pyCTnSIpJjjmTcor1XVLBptwam2dAL4aJcE97/eombNsnvKNtyA5S5I3Xqo0P/oSiMjnUt+HzZeG4pIjPyHDuynpF3yfHuHBkoyTtE9u5dVJlaVlQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH1PPF9C964DBFE.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.20; Thu, 6 Nov
 2025 06:41:00 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 06:41:00 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, Guixin Liu
	<kanie@linux.alibaba.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sheng
 Yang <sheng@yasker.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, Allen Pais <apais@linux.microsoft.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: tcm_loop: fix segfault in
 tcm_loop_tpg_address_show()
Thread-Topic: [PATCH] scsi: target: tcm_loop: fix segfault in
 tcm_loop_tpg_address_show()
Thread-Index: AQHcTooegBtc8NWtFUGJEyZsUVk5KbTlM4wA
Date: Thu, 6 Nov 2025 06:41:00 +0000
Message-ID: <2c70e9bf-e6fb-4443-bfc9-fab448fb2f65@nvidia.com>
References:
 <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
In-Reply-To:
 <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH1PPF9C964DBFE:EE_
x-ms-office365-filtering-correlation-id: 37e25be7-9f51-482e-b93c-08de1cff7312
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bmhtNXlZUXhLTTYvMlcvbE5xZmJrRFlQRkRMNVlNb1pwTkZ4MmVEWC81ZFRK?=
 =?utf-8?B?a3RMUFVRbFVBdFRnZ1EveE9kQUNQdU5xQUg4dFUvT29Wcm5HYlNsTnNDWGVt?=
 =?utf-8?B?ODRWZFdEZWUzMmZaR2ZuNUJKSFFjdzE4eFhlSVVvVTRaUUJ0VGFtb0w2Y2xu?=
 =?utf-8?B?YkFRV2cwc29vVE42c2NralhNNlVXK1gza0JaVGQ3V1YxV2x5dXFhRHBPd0Rk?=
 =?utf-8?B?ZHhVNWl3MXZ4c1RUQ3NtL3Y2Z3FRNER4YlMzcGxaUjZrZktkOU0yMG1qODBj?=
 =?utf-8?B?eE52WXhDT1FwR3dwbVA1RGU0RXBMVmNCUFc0Q0lTaWpsUXd6dVdQa0wvNVo1?=
 =?utf-8?B?cG1KVU9wSkgvMlJRQnZHdTlUMlo2RzRGb2gweUUzbnpSUTl4Q2NSU0dhQ0FT?=
 =?utf-8?B?cE5wdjI4QlVHbkhzcTZ2SVZIOU5RdUtXOG52Q3E0ZWdMOXhKTE85SUN5Wk10?=
 =?utf-8?B?aXNXRjR0eUlJUThLU25EQjArdU5IT3ZjYnQzcklpbWZmNUU5VHdMdVBoV0dZ?=
 =?utf-8?B?bit2QmxOZEhIYlkreGFFRGtTaUpSUktQdTRCeTZiTGhQM0ZhTHFFNHdseml3?=
 =?utf-8?B?VFY2d1VxNnFJbVhCTC9URVBsbnM3dGNCQmdWWS91SEp5cDNLTDhYWUcxTEJy?=
 =?utf-8?B?RTFzbWt0R1lVYWZxSC9hSzRKTHVqNnNhME5HVEhSMnV4VjlIUXpURHZEMXZq?=
 =?utf-8?B?MmRJTHRTRGVhWThMVkpLLy9WUFovSUpLR085OHdhemtnVkpTZ1M4TXRnM0cy?=
 =?utf-8?B?VWxBS1pCNFVtTGhqRzRqUDVWNm4xNnNVMDdiTXRvZ1RrVUJHMVY5V1BhdGtI?=
 =?utf-8?B?MDJOT0FQTU9yUFZrUCt4MG9KU2QvcDQ5em8vUEdCSDFISllYVVVjZm1kQVo4?=
 =?utf-8?B?UjhTQk5nQUVxQjBnQlo0M0FsTlFVUTJkMG5UdXYzRTI3aFVFRnN0MVpxeHRl?=
 =?utf-8?B?TXp6SG1lT2J5T3JuNklqZHJvTjhLUUVEbmRkdGUrZmRoVGhQOGZNbytYWS9D?=
 =?utf-8?B?SGc0UUsvcmhVVUo4aVVlUkRpT05JamZLUnlyb1VoNEEzdFpsUTdMeElFODkr?=
 =?utf-8?B?SjVKbnVMOGhmdG5WbW1CbC8wc2Fkc0NwT2xBUFduYzROdDFHMEZKQ3M3Vm5G?=
 =?utf-8?B?SnFyblBnMFN6djFJcGhJVTZUMnVHSVlnSldKWHpIclB6SFRnRnVld0UyV0pJ?=
 =?utf-8?B?TDNpS0g3TG4vQVQ0bnBmQjc1Vmd6K3BERkttRFNrc0I4Rk53NEcranppWWZ2?=
 =?utf-8?B?R1I4Rk4wdUF5S1VrWmhXa0dsZHVhd1AvdEdPT3JpTWRGSVk5VlRLQjFybVQy?=
 =?utf-8?B?SENrdjlrdlZubi9VcnFzYnRYZFRaV3FLRzBoUHFXY0dVRThuNWtBZkk1OS9m?=
 =?utf-8?B?U3BpVEF1WDFQVk1mT25EejZWa05NQ1JMM3Bxa2pCQlBOenYwOXIyRnNBdTEz?=
 =?utf-8?B?ZTlTSzRyUUtTKzlzZXZ1STRLektic2JkWTMvOU9GU0JCSlFnVzE4ckk2NGlF?=
 =?utf-8?B?bVl2ZWViZDR0cVZJeDlTZEpvemV5djk5VnpacnFKN0t1eHRIdmplM3YrNDB6?=
 =?utf-8?B?blJqYUM5S0ZKWlRKdElMSmtFNjFpZ0loSWtFbXpLQ0lCRXI2d3JGaXZ3NWlx?=
 =?utf-8?B?blBIQ0xIWFdzbmdKTkRKTllXa1hZMVZ4ZzdvTG9JNFBDSlNLY1lXaVlvUjJT?=
 =?utf-8?B?Umh0YURMWDZBTUtlWktOS0JqUTR2S1RIYWlvRlYxRmVrVG9lc2FpeWtBaXVl?=
 =?utf-8?B?ZURmOW9EeXc1SVYwd0xReXMzV1pzNjRqeSswTis5amoxWTBKNTBxRnpqNlJi?=
 =?utf-8?B?bWwwUG04dHl6UXpwL1FlYjltcW4xeUJ1WHlpZXlFVGZrVExKKzlTZkhyQTZx?=
 =?utf-8?B?bmZGeHpUVTFadm1XSlRzVWxJUUZweEk3bWhoZVJxUjU0N3FzdUFvT2Y1ZmR6?=
 =?utf-8?B?MXU4NUVLRy9vYkdLS3ErL0tJY3FCR3FqRm1EdldhZWdLL3dYMEY0OHE1L2F2?=
 =?utf-8?B?Uit4WnRNQlFvZjNmWmJMZmdKbDVCZDQyWVREUkVBNDhHSVk4NTFiUWZaU0Y2?=
 =?utf-8?Q?6gbaGy?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TDlyUVJZM2VMdHFtUHNuSUo3MjFEM0QyUkEzSkN2b2g4NUM0d1ZYY1BlNXoy?=
 =?utf-8?B?VGtSY3gweUtWaTFqaS9lSDk0TWw2K3NpVnJJVDhxREtmZlBpM2NJL09YNkk5?=
 =?utf-8?B?MlMvV00wbU9PdzlOYXAwd2NTY2RYWG5WZCtWNDVJMkhhQ0tnTkRGenRGL3dx?=
 =?utf-8?B?dXlnL2pzNXVoYzBobTJqcVd0NkRUKy9KcytMeHJqSDlyV012cDBMaEc5L21X?=
 =?utf-8?B?eDlVL1hJekJqbWhiR0tyQWVzLytxQ2NIYmNLaXpJL1k3aGlydzUreVlVSWN0?=
 =?utf-8?B?NHo1Mk5ucElHUEZ0ZzJrWGRtZmI1SDY3SjFoeW9mRmRHcjcyZXcyVGNYWllS?=
 =?utf-8?B?NktyQXgzRzFuNU02a3JsdE01eGpKWm1UaWpyc2p6Z0tBK3NJamMzSDRWYXBR?=
 =?utf-8?B?eXNieWlaUWR6MzhCU3Zjb2NpWXUrRytGYTBKNUZEREpFdCtQNzZDaHRDWTgz?=
 =?utf-8?B?bVRIRXdLcHprOEQ3TmFYLzZpWG84clU5Z3ZjcGMvc3oyc0hrSUxsOXA0dmtq?=
 =?utf-8?B?WXkycmJrQi9lUUN6ZmxJbkhpdGtCWnNYR3N4K1JuTUJOV21OMEZnSWhxOHAy?=
 =?utf-8?B?R3czR0NlSXFDRnVSa050OVcyWEduaWU3MTNTc0RMc3YxeDJ4bk5uaTNaVXhO?=
 =?utf-8?B?QVNkOURIU1BpaGt6dW9NQkhhWXlienN2dlNhSFdPTTNNSkdMNENsaTFSOVcr?=
 =?utf-8?B?Zml3QW40T28rNUVtYm5sdERHRzFxL0NDb0VWY3JwMWVhamU5ZHVya2V0YzBW?=
 =?utf-8?B?d3o1V2gya012eEpCS2VibVNUVWcrUGEzeGUzNHBlc3NpYnlNejY1aWNKVXBj?=
 =?utf-8?B?Sm8xd2I1czhmanR2MlNIOW1WUkhVZTFhbjEzME5iQkdNM2RBd0F5YXBwSjIw?=
 =?utf-8?B?T1JBTDBZb1hpVHpxTDZsQ0xOZzhsOWFOOFlaUFNYUSsrMTNHNWZCVk0wSGlh?=
 =?utf-8?B?bDhURkJmeFFxZ1UrRnoyUDV3ZVQ4SXJyVlNIRm9NQUowcGgyNUxYVThMVW1k?=
 =?utf-8?B?U0VSYjh2NGFZRURCOTlQd3kzNWlhQnkxK3Z1bW1DeUNrNFlST2x3djIvWWwv?=
 =?utf-8?B?ZkNPdHZLZXJ5THJJT0daaWhrMm5yc0d6amxXZXQ3b3RQUVFNbUxiUnN3UE5K?=
 =?utf-8?B?R1FUSHBCTmNBc244RkdPVFdIKzRqRWwxS3kvekprVGVwVlB4ZnBTWmh4ZVdr?=
 =?utf-8?B?MDBhNkhwZXJJckh4dkRzOS9VeGNqRHNXR1BNNElkbmtGRVB1b1NidlNnUGJ1?=
 =?utf-8?B?c1lEZkhxd3MwOHpsbDBITUV2bDg5UWlBVHRBaHpIRk9mN2dBRVRHRFFIZjZV?=
 =?utf-8?B?N3VaZkV5QjVMdTd5L3FvSm1YZWtYSUl6RFdyTHY2OXlmRDlBSG95YzRUdXBK?=
 =?utf-8?B?UlVUZHZjckU4Y1YrRWU0VWkzOGp2QVAzYmR1MFFCRkJ0N01nNlNlb2FSbVVh?=
 =?utf-8?B?VllZUnp6NlUwelNsZUI3Q0JOZjk0YjdPNHhhWjlwNHVZSFl4VnIzQmowdlZp?=
 =?utf-8?B?aWxLdU9ndnFCOVFCRTYzaWNsMGRTVFhJSDBwTWJEZWFJa1BETWs4cnUybm5Q?=
 =?utf-8?B?TTF5ZzVrTzRGd1dvM0NaRDlhSkN4TmNYS3dnRXBDRmJheHE4R000Y1FBekRk?=
 =?utf-8?B?UlVhNFBaUDhlMzBKKzRMdzNtSm40MmxOVGFNenFUVjUvYk5XWHkwWGJsNFd3?=
 =?utf-8?B?b0dzQUpZRThJQW8yNTFManFuQ0lTS3I3cElvVWdZVzdvMTFLWFRWNDMvbzZR?=
 =?utf-8?B?d1RIbFBhaXVZVWg4cExkTnQxcklUWkFhanJmTmo2UmFWNEFmb0srTGFpMTdn?=
 =?utf-8?B?WTRmYXRtOUJiRHhPR29HeE8yUC9qSU9vZGJ3eHVNOEFLMXl6RzdpVnU4c1VV?=
 =?utf-8?B?NWY4K0lGbXVkZjZDcVZBRVNKZzlUNVp2eDV5TjhFZUljMC8vSGhCMnpDY2lx?=
 =?utf-8?B?bDJtNFJ6aHdZTTBKZ3hVSWczc2tJNnlDWml0LzBkeFA0OUdkL3VmeXIyNm42?=
 =?utf-8?B?YXRlMHlJVWg3QnNxM1FHUUY3ZG53OXRyYTRMdElrdzRRS20zRTNDM1d5R2FF?=
 =?utf-8?B?R0tJbWNXMWQ3NUQ0dDZJSjVZNXY3S3EvMnZnOTVpM2VKbzQ5TG1YWkJscWNB?=
 =?utf-8?B?UHFjMWIyRmZQZjlDVGVVSEtuVDRYVmhmT1lVeWdXRU9wZFA5RkFHeFZJLy94?=
 =?utf-8?Q?RbsojBqUAwVr3g7GhJo8qhaGG/zioZdiAvL6LUCEOhVa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C34E1061542A44EB8D541DA56548DB2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e25be7-9f51-482e-b93c-08de1cff7312
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 06:41:00.5808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iq8X30yyP1ijVUMRl039Ss/41z71GZQm/lcnE3krq/E0YVUBMnHdKQfVag/D2VGzWPZg4A4pCN+r1CgohiI0Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF9C964DBFE

T24gMTEvNS8yNSAxMToyNSwgSGFtemEgTWFoZm9veiB3cm90ZToNCj4gSWYgdGhlIGFsbG9jYXRp
b24gb2YgdGxfaGJhLT5zaCBmYWlscyBpbiB0Y21fbG9vcF9kcml2ZXJfcHJvYmUoKSBhbmQgd2UN
Cj4gYXR0ZW1wdCB0byBkZXJlZmVyZW5jZSBpdCBpbiB0Y21fbG9vcF90cGdfYWRkcmVzc19zaG93
KCkgd2Ugd2lsbCBnZXQgYQ0KPiBzZWdmYXVsdCwgc2VlIGJlbG93IGZvciBhbiBleGFtcGxlLiBT
bywgY2hlY2sgdGxfaGJhLT5zaCBiZWZvcmUNCj4gZGVyZWZlcmVuY2luZyBpdC4NCj4NCj4gICAg
VW5hYmxlIHRvIGFsbG9jYXRlIHN0cnVjdCBzY3NpX2hvc3QNCj4gICAgQlVHOiBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlLCBhZGRyZXNzOiAwMDAwMDAwMDAwMDAwMTk0DQo+ICAgICNQ
Rjogc3VwZXJ2aXNvciByZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQ0KPiAgICAjUEY6IGVycm9y
X2NvZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UNCj4gICAgUEdEIDAgUDREIDANCj4gICAg
T29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIE5PUFRJDQo+ICAgIENQVTogMSBQSUQ6IDgzNTYg
Q29tbTogdG9raW8tcnVudGltZS13IE5vdCB0YWludGVkIDYuNi4xMDQuMi00LmF6bDMgIzENCj4g
ICAgSGFyZHdhcmUgbmFtZTogTWljcm9zb2Z0IENvcnBvcmF0aW9uIFZpcnR1YWwgTWFjaGluZS9W
aXJ0dWFsIE1hY2hpbmUsIEJJT1MgSHlwZXItViBVRUZJIFJlbGVhc2UgdjQuMSAwOS8yOC8yMDI0
DQo+ICAgIFJJUDogMDAxMDp0Y21fbG9vcF90cGdfYWRkcmVzc19zaG93KzB4MmUvMHg1MCBbdGNt
X2xvb3BdDQo+IC4uLg0KPiAgICBDYWxsIFRyYWNlOg0KPiAgICAgPFRBU0s+DQo+ICAgICBjb25m
aWdmc19yZWFkX2l0ZXIrMHgxMmQvMHgxZDAgW2NvbmZpZ2ZzXQ0KPiAgICAgdmZzX3JlYWQrMHgx
YjUvMHgzMDANCj4gICAgIGtzeXNfcmVhZCsweDZmLzB4ZjANCj4gLi4uDQo+DQo+IENjOnN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4gRml4ZXM6IDI2MjhiMzUyYzNkNCAoInRjbV9sb29wOiBTaG93
IGFkZHJlc3Mgb2YgdHBnIGluIGNvbmZpZ2ZzIikNCj4gU2lnbmVkLW9mZi1ieTogSGFtemEgTWFo
Zm9vejxoYW16YW1haGZvb3pAbGludXgubWljcm9zb2Z0LmNvbT4NCj4gLS0tDQoNCg0KaW5kZWVk
IDotDQoNCiDCoDMxMyBzdGF0aWMgaW50IHRjbV9sb29wX2RyaXZlcl9wcm9iZShzdHJ1Y3QgZGV2
aWNlICpkZXYpDQogwqAzMTQgew0KIMKgMzE1wqAgwqAgwqAgwqAgwqBzdHJ1Y3QgdGNtX2xvb3Bf
aGJhICp0bF9oYmE7DQogwqAzMTbCoCDCoCDCoCDCoCDCoHN0cnVjdCBTY3NpX0hvc3QgKnNoOw0K
IMKgMzE3wqAgwqAgwqAgwqAgwqBpbnQgZXJyb3IsIGhvc3RfcHJvdDsNCiDCoDMxOA0KIMKgMzE5
wqAgwqAgwqAgwqAgwqB0bF9oYmEgPSB0b190Y21fbG9vcF9oYmEoZGV2KTsNCiDCoDMyMA0KIMKg
MzIxwqAgwqAgwqAgwqAgwqBzaCA9IHNjc2lfaG9zdF9hbGxvYygmdGNtX2xvb3BfZHJpdmVyX3Rl
bXBsYXRlLA0KIMKgMzIywqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzaXpl
b2Yoc3RydWN0IHRjbV9sb29wX2hiYSkpOw0KIMKgMzIzwqAgwqAgwqAgwqAgwqBpZiAoIXNoKSB7
DQogwqAzMjTCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHByX2VycigiVW5hYmxlIHRvIGFsbG9j
YXRlIHN0cnVjdCBzY3NpX2hvc3RcbiIpOw0KIMKgMzI1wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqByZXR1cm4gLUVOT0RFVjsNCiDCoDMyNsKgIMKgIMKgIMKgIMKgfQ0KIMKgMzI3wqAgwqAgwqAg
wqAgwqB0bF9oYmEtPnNoID0gc2g7DQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENo
YWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
