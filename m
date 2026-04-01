Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A984838C2DF
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049056; cv=fail; b=ZUPuuYFTpkH4Y+jG6stx0Sl7LoWs6YCvWoY5apLsy5XOJcUKj/z8J4S0NEShaTrUCn74HBjA9mR5P/4JPpTp5eK/Xu/R5f0OmUW4jnslAZK3VjBYkETCZKT9ZnRobNoovz1+Xy9b4IxFk68c9Ytk+lClDXkqIB1B82Jg2a49V+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049056; c=relaxed/simple;
	bh=MNAg9POL3YOmLkahK40+n/I1mKAmx+SUujVxx++1pss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fIuQJoLROqd5sGGpnlR0Fz4FsazHs6JgvcVwTAwcSq7+GdkzuLvYpqX3p0u4Foa33fN5DfhqW3ZJBqp5hepKVnDOrLY54/bnH2hj7l/OOfg8I9S8IzwgN4W4FaW7W31YyC/nMOOg+qfCi6wD0M24nYsqhru9MDOU5rHlxsGXvm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EeKTYG5q; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Ae6cA+9f; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EeKTYG5q";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Ae6cA+9f"
X-UUID: 2fc0244a2dcc11f1ae70033691e9ac7d-20260401
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MNAg9POL3YOmLkahK40+n/I1mKAmx+SUujVxx++1pss=;
	b=EeKTYG5qiQxMjjKNNEn9UTfqxn6rKl+rgYY2TnMqnuUG5+b3X2VFUxeV2gbNojHOhiJrksL+iIig34Amr9jF+Ae1VFt80Mwy6pCbhzkqApsTD7pg9dzoibIgPbOfYenR1CA/gU61UgbarYnKhVgNeFY8cc7uRKr97kylSt/7GCs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:474929fe-2518-41c6-9024-96a3c67f6363,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:3c537794-f8ef-4ca8-bea0-143568f9ca1d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2fc0244a2dcc11f1ae70033691e9ac7d-20260401
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2019137417; Wed, 01 Apr 2026 21:10:42 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 1 Apr 2026 21:10:41 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 1 Apr 2026 21:10:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYUeZm3XNAzTgllWIALlqRiDGrj9t+7JD45wjmQAeM+ymR3mq8lXENTaoQF19S/eWo/Mzz5Q7gREvA9lBBLKWpDPNZ5VoWsEzQdoOlxRb6bNnSA/xGxlMBmay0J4oZ/jVZSA1msBkjFP1dYz55uEdNBEGvqedllYtJNsDdkiJgSNAQx++RQ6QhPIn3GjtuNrrFhCNS/Qwx/+O5Lqx5rskhGTlzBwkxLBVuyND+v+pjnkejAnTIOHdaRxwANymK7CNy4sYqQAETwb6x3TTO357Edc/sU7eF3oCKp4ggribxqDmfkWddKc9Uzm8Uqob/HcTAcpOyLvarQuJXwn1Woe4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNAg9POL3YOmLkahK40+n/I1mKAmx+SUujVxx++1pss=;
 b=NNIZ5yzb4mpF5/x9/Y+hskFUDM5pAs8Fu7Cj3bkyp6yO6C+0UolJmrF9zg4rv7VrEROvPd7UrXA/KXlzm/XnDpgGeEIvk/PCMCroe/xI46vpHUWSduIK/c6XvsGgtNGY4ODXpKGP6QcYD8qYneNQqcvd03BGFTep5OvMnVwIVaB4xycn3lu9mlKdaFkkmG5mf3uCVJwzxtr2LyKNq3Sn5x+Mrjzf3+GjXW9bRPAMG/H+MoXCK29uapAIQV8LskOBnOZesxqnIebuetf/aWneWTcgnyYYWj7DnmRX9Y/M9Ai2QAUZo8RgCCbgqvEANltLA0TyYHv6+OOIinsOFC/E8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNAg9POL3YOmLkahK40+n/I1mKAmx+SUujVxx++1pss=;
 b=Ae6cA+9fGoNxrktn1WPDeZveHDjfdrynwo0387aM9WDkf9x2FRGu4S/M9X7MYPsjqaTkr/+pvXCrz9iojDrrAiKHwORggOETEyujJ1L7+tEJY1WGJnj+MzqS89P2DqfEQAXLxRnvic9DxdQZBT/7F8Vw8Zk9S7+RSYJGOEZ2sVE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY1PPF538CF1BBD.apcprd03.prod.outlook.com (2603:1096:408::a57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 13:10:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 13:10:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chenyuan0y@gmail.com" <chenyuan0y@gmail.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Topic: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Thread-Index: AQHcwHPS0LRtMwK95kC+/vV31GyfvrXIZE6AgACkNQCAAShygA==
Date: Wed, 1 Apr 2026 13:10:38 +0000
Message-ID: <4a4f2054634ca20195467c0869ba88251b13e107.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-2-bvanassche@acm.org>
	 <4685d17dbf09397aef70c2e2b84ee13f1c48d4cd.camel@mediatek.com>
	 <6f4d9e81-b300-4603-9032-e2604c0b099f@acm.org>
In-Reply-To: <6f4d9e81-b300-4603-9032-e2604c0b099f@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY1PPF538CF1BBD:EE_
x-ms-office365-filtering-correlation-id: 0045aee1-cb99-45c6-06b6-08de8ff011c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: Dgf+OpOqaKzsXl9wPjZD0Ah8uT6rMa+nvaeJ+I1GQkvc49mATYI8SEcA2nsvY9JbZeLLAkbPqTaIOxWR2v2ehgHT9/QVKrs9efMygsQ39yDUx63wIACilXrhIKEnua9jPOAcdppA1GuJv8aSFk4t8M5yJH5Cu+qmpVDCHQoXp7affomUpxZBPu5BjgfbpG8LbNEjTdvE1moXmT24FZAwfnAh4XNg7qSr0B0XVeyt2f/BmFAzHSoWPTUMvLvmTygh8F9Qh7hDw4fRF8yCHKPIWfrRE+5GYgBQrA5nxqF/+ZBfUSxj3z78EMG9vM4bLl41mO70zgN1osx4ZRBZ0RPrCSgBV0MMw48xcrziefSf10hMUkyyrFaBRaLisdOLWlT3OI1pDT2iJkSzyt9PVR7DWSJidSu3v6hJe0TQHS7Z0Mi1MuQvY9TfOolBmegsAjLWoI6DBpLng0CavE8KPZagxje822LvQrMtigAxIkoVC9pW/4OI988GUGHbGPs2Bbn5a3b3fy4HGJ7ADHiPetecjLQ3s6rp/+Wpq5a+qKuafv1CA+7KE1EHm36kclQ4R22qIbvSpmOK8zM/XFk8HnMnnSTLIMG2/ndR1282d663JkpVtitIZHUjyGbU+iK/t+YHKCEkYFeoSKulhyfQ5FbgbtR75g/EzrOGhZKND9ir0ChUIMTxCmLAL1MGhX17m6SEnGx5Vw1UmJ5Le01hSfe8e/rYwKkwO2AW5uMXd24JMekLcM3fMQ3M4f3CbCfXcD1y9q9wmB2IYeTlIWQRKfSzMHuDmmPLlRl3ccW74Ob02Hk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDd1YmhSdXU5S0lyRU1LS3F0bkdHMW1DNDcyY3UvSllhOHIvMXRNRkwwNFYv?=
 =?utf-8?B?aC9VamlYRUVsL0haQjdRKzBvZExvNlAva1o1bysxTWp4bTFOMVlWVlh2Zk1m?=
 =?utf-8?B?YkQ5b0VIaThuMmJwc0RPTUY4WHRIemZEYUpOVHBIdnNBZzE3VDJJc0ZpeWlz?=
 =?utf-8?B?SXRUZURTd0hxZE1xem9SL3JZdDJablFLUHpUSjF4aXdKUWtDS2dmK1FTV2la?=
 =?utf-8?B?enpZOE03c0p0NDQzWUtyVmtpcjdYd3JLNytVcG9ITHBXVU1KWVZ6dnF2MWp3?=
 =?utf-8?B?czdjRUNCaGtGdE1rNkFGSVZ5disxaHVVbkUwc2VTK1FVZzZ2UXZDM0JFM1R1?=
 =?utf-8?B?ZzZ1M1E4SWJOMzF2RkZKMkk0UC9RbEU2YS9rUzRqNzZ3WVd4S3lzSnB6R2lZ?=
 =?utf-8?B?bmUrb09yU2s1VExKQm9hQ3NNNEU5RTlnaXBNRkJHZnNRSFhMRHMyWFgrU2RL?=
 =?utf-8?B?MFloQkh6dDBQOVh1TzRXNWp5bFg4dU1uSUpIN1hwaHZtUGYyTzVDWWdkK21n?=
 =?utf-8?B?U3dSUXd4MzZsSlJ5Nm1TL2pDZWJJUGF3WTFSaEpkUlBEV0xNT0tyZHEzOERT?=
 =?utf-8?B?RHErSEhVSFhnVGwvdVBnVGNVaVJzdHB0RnRoQmhWUlVMdXQxcTQrdEJpY3lD?=
 =?utf-8?B?UmtkZ0Mwb0h6VkQ0Mnh3S2lEbk9WN0orenp3WjlsUVNTM3l4aGYzKzRaSjAy?=
 =?utf-8?B?aEwxbHZnTmptNWFYd3ZhSXhpQUliOUhHcm8rbG5nNDE5UVo2M1I4ZGdyRnBI?=
 =?utf-8?B?ZXV4VWtHSjU4aDZYVWhiZDdMR05tS1hGZjFGdG5kSXZBcytaNUVpMXQwZSt2?=
 =?utf-8?B?OEQrQ1Vld21pNmo2ak8yb3RJOFJTMFhvMnMwYjNWYWozWEdoSU5WWVRiUVY5?=
 =?utf-8?B?RWxGYy9mZGNwNGF2L1c2WUdIcUtkZW5HMG9qYjU3OUh5V2pMWHljZ09idXZB?=
 =?utf-8?B?UHBJREVNUWtiNTdTTlpQcjBBaGQwMzdtbDlCbEY2V3BaTTFxY1BWOFhqbVlL?=
 =?utf-8?B?TWFSM2YwOVFkUU9ESnRzbUdOLzZRY2poU3hzYmNJSTNkdVh4N01ISnZmUkxL?=
 =?utf-8?B?R3BwMVlKVUwrSGxvdENRSENtK2tka2ZDRks3NjVlZndKallyTmtqYzMzNDlZ?=
 =?utf-8?B?enhHZTRkZks3YlRxdUEyLzM4VTNTY2V1dW5UN3lHM0g5WDB0TWxrMjJkSjc0?=
 =?utf-8?B?QUtEV3JRdGQxcjBXRStRWDV0VG5maG81WWdLQ1Y0MGpxblBNaVU1eUdWd3ZD?=
 =?utf-8?B?VjF5WHFXTnBLdXFRTWRYVmNNeXdoaXhEZmVjSVBONnQxL1M0ZnFQUk9ZOElW?=
 =?utf-8?B?QUNhaE9IQVpWTEIzc0ovYnMyQnR5Q2gvY2xXdzJ0ZWFNMlRBRkJSbWtGU25z?=
 =?utf-8?B?Z253NmVjL0d5L2FWQmFyaVZoVnZSN2tSVnM1VVNuMHRMWmdYS3JuNzdFNVpI?=
 =?utf-8?B?WDkvNHo5Q1R6S2NpMDYvUlhVMmczbmtFL0c5b2U2bS9CcWYxZkpHeGlzZExw?=
 =?utf-8?B?ci9DenBJVThteXcwRjJoNzFkeXdTZUVqaVVrTUFFNXBPejhyVVZ2YWRnMGZi?=
 =?utf-8?B?eGZMLzdsdHQwSWZGRkVYTlVmdzc5Rld4QzRzZ2JhYWg4b09hQ1BNeWlJd3N4?=
 =?utf-8?B?UlhkQXFuRVdBZENVeEFwQzVyTVJVZWppMGVybkZmTHZla29tQ3J2Z29ucEsz?=
 =?utf-8?B?aTJnUHo0aERjVytvSGRxV1ZnNXViTVVxdjhSTFlLaDFCSmxsL2E2bjBhMEpn?=
 =?utf-8?B?UHJjZldnallvVXZMWXBYbEdURS9OL0tBNytqUHFwVE8wY24wQWNhTGJENUE2?=
 =?utf-8?B?b2pyNzJLaXVnVnc5dTUvMWd2SnR0eUc1OG05ZHpETkphS3NPY3kzOGo1aU9s?=
 =?utf-8?B?THA4eVRDbkxiVWtTMEZnbGVVV0VkcytuOEgxYko2S1lyUUpEU1R2RVlFSm1a?=
 =?utf-8?B?Qy9BaE1TWWdCWVdVL0RQbjlNMitoS2FQNnZtRFJzaXJsNExtWkVEcVRJemdl?=
 =?utf-8?B?VUxuNld6VlBrUGtOa25KSFFONVlydkhNL0NCcFdFNHQvVzV6bG9wcnpucXpM?=
 =?utf-8?B?eXluL0pydzFwekl3T3k0Sy9BV3EzWkdaM0RwUURQUWcwcFUzNVdNL0poSGd5?=
 =?utf-8?B?QTdYaTZJUld4eXh0VThLblAwdnNDbEROMnJaQSs3bk1reCsrdTFXSmhPc2F3?=
 =?utf-8?B?czlRU3BYK1RyU1NFQUNiK2pkSy9jcXpNUm85a1c2TVBtUXRHaW1naGgwUDdN?=
 =?utf-8?B?cFRzN2x1SEhoYjNDK2krbms3VFgzbENaWlNhQU9nNG9ycVcvZE9SMWZWWVZI?=
 =?utf-8?B?Ry9EZHMrRTBEYnhlSGsrQm1qcEVXL0hoQzV1TlQ1NEd5dHlLZ2hzRUNnOVVr?=
 =?utf-8?Q?9EXIOJG1RLlYwJ+I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9019F7C006BEE24695028EC84DE9099C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Yz2ohQFlwb1ljJKqTWAKEj37OTySuwueKfvB8zrcfcLyN5s8VxT/ZC40oiSMIAU4TtqXYXNwrslmhplt6na+31JBKXQ7gNqI6FO/eURrKf+aIsw95MKPPSLk55MKBhNTUK4fQQMcFMrJUaNWejEs0+39Krwu4cBPR30Ig2XYaftflMw+/Xio6zVsfT6oX96CNjvHzhqY414rHB18twU7OLKmp2a8Pg80DX5uEDnpTtylrlNUOv0nN138MSSOaQ2qFRbE5rSSM6nNeHXIjvpbX011QSS26rSwDqvEtNVlh8nbSfhY6GgWVD9/yLWfRyeq9DELXiG48kkO89ImmkIFSg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0045aee1-cb99-45c6-06b6-08de8ff011c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 13:10:38.6265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FYGwd2sIai+RTzoTfXh5mNTV5bKBwioTyibJVff4QckGJUuUghzaWtShZXBSiegO0z071vXu3uX978ROEwbWFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF538CF1BBD
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTMxIGF0IDEyOjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gdWZzaGNkX21jcV9jb21wbF9hbGxfY3Flc19sb2NrKCkgZG9l
c24ndCByZWFkIHRoZSBDUSBoZWFkIHBvaW50ZXIuDQo+IFByb2Nlc3NpbmcgY29tcGxldGlvbiBx
dWV1ZSBlbGVtZW50cyB3aXRob3V0IHJlYWRpbmcgdGhlIENRIGhlYWQNCj4gcG9pbnRlcg0KPiBm
aXJzdCBpcyBub3Qgc2FmZS4NCj4gDQoNCg0KSGkgQmFydCwNCg0KWWVzLCBidXQgSSdtIGN1cmlv
dXMsIHdpbGwgcHJvY2Vzc2luZyBhbGwgZW50cmllcywgDQphbHRob3VnaCBpbmVmZmljaWVudCwg
cmVhbGx5IGNhdXNlIGFueSBwcm9ibGVtcz8NCg0KDQo+ID4gU2luY2UgdWZzaGNkX21jcV9mb3Jj
ZV9jb21wbF9vbmUgYW5kIHVmc2hjZF9tY3FfY29tcGxfb25lDQo+ID4gYXJlIHZlcnkgc2ltaWxh
ciwgd291bGQgaXQgYmUgcG9zc2libGUgdG8gbWVyZ2UgdGhlbSBpbnRvDQo+ID4gb25lIGZ1bmN0
aW9uLCB3aXRoIGEgcGFyYW1ldGVyIHRvIGhhbmRsZSB0aGUgZm9yY2UgY29tcGxldGlvbg0KPiA+
IGNhc2U/DQo+IA0KPiBJIHRoaW5rIGFkZHJlc3NpbmcgdGhhdCBxdWVzdGlvbiBmYWxscyBvdXRz
aWRlIHRoZSBzY29wZSBvZiB0aGlzDQo+IHBhdGNoDQo+IHNlcmllcy4NCj4gDQoNClllcywgaXQg
ZmFsbHMgb3V0c2lkZSB0aGUgc2NvcGUuIEkganVzdCBub3RpY2VkIHRoYXQgd2hlbiB0aGlzDQpw
YXRjaCBpcyBhcHBsaWVkLCB0aGVzZSB0d28gZnVuY3Rpb25zIGJlY29tZSBzaW1pbGFyLg0KDQpU
aGFua3MuDQpQZXRlcg0KDQo=
