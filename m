Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F0239185;
	Wed,  4 Dec 2024 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733336067; cv=fail; b=s6hAPak7vt8Hvjud6++FgIltyNTpqIPd9l1WmrBBpff0oaqoOEc+OI9avlYcs4lVLJ5QrWzfWebAj55qtOKJBkMz8Wu1M5ZhR4MN3rHvC3Lz+sS7U8UDvm0o3AlNp+e7Q+keGo2nDJtqltHlBxgpONmxc4MOv/I9QiwhBXrxSyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733336067; c=relaxed/simple;
	bh=IMD/TZAHRWs/U6p1ykUFu+1URzsWSGAJVYmCPP++tj8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BpO7cuI+Pq0gG/ezFLaLRxvg86SglaKYOASIRuqy9+jEsalGJRuqNozgcCKtclwYZFFyDM7L7qx4U0Md18RxDtf9zVkAMqRcMaMR4NvHyqepXUPsaTwH3HVlWvSRmNd1Alnb/wrDyGpMvoJbQ7G8lspSVqe4BL4km5CVPIOQtuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DJHKVBTW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yrTv8tM6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DJHKVBTW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yrTv8tM6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4HtV4j019689;
	Wed, 4 Dec 2024 18:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=IBkfMb44fX2P6i2b23
	Qgm0skHIxi5zSh3WXbpuYKTBs=; b=DJHKVBTWyTZ/8jzrmvQZgCjBzkxUhzBbJm
	KG9p8HWmzEIm5nXksgTWLyXqbJ1XakkvKf18Cuupk3igHSV5h8m1/Nr4np+6D51+
	1cuJhXDRrQ9vksQo5U6wVFvPi8JAT3dYLN367o/k8oFwN471OWQENqbqR7AZHm88
	JxGcRTFKO3s5wYnrCKOujShpP1V5oXMn/o8M7R947csVnGha2ADYRdvJvTJjiyWk
	7ZfAIFZH7P/iY9DKmCg1zaTL4McUIBjJ/SDL1NGJrGIfm+e5mI4z/RCKFNYMMEwH
	TjZuQvpILOk3aIzg3wVvS4Php0Lem+RHkBs5BpsQtW3MLgzxwZYw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c92gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 18:14:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4HkIVY001440;
	Wed, 4 Dec 2024 18:14:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59tdnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 18:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JaH+xZUMLmKxLSeKy926RNxxlOyiDuRtJyQLh8rG2k7h8hnftGRtRPz4D9PWQevUBgCBSLljxMxaz+MIINVyPuYYE7aanesD7x6l6giwVyYw/C9uG79eLbFRWhbvvaBp1ANeBhRyem20jtmLKZiDDfgH5rZbIqpokcBi1lRXP26q7316Lh5ZiXbZkcMsNdAQ0Xw4YZiwu7G9rjDbi8SY6XjmDWnIGcfxzcMwGr3dEeW7nDEuQdxJmBnHC8zKZY8BWPzFyTf9gzzPw9YWyXNnKFwC77x4iaYLVwJNly0eApbEFQfFNIDOlGyFbyEDvelJHYPjjjaTCmDak8Pw8n5tTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBkfMb44fX2P6i2b23Qgm0skHIxi5zSh3WXbpuYKTBs=;
 b=p0XBKoKvLvRBvjpk1WuX62DVVW2t9rLVszqOv2MI2g6WMmoIeTaYQkzUlt/TeV+59QxRjRW0y399X8d6UDx15OaKiM0G70mbfsNexrw0auy3f9YQsWe2joNEgww8g2zs5CQF+sE6APgm9b1rdXhscGXfVdTBktvndDzyRFBiR5uxdl+RdYaCy76xIsnA+vSwv4r3hrstg1s6UfapW1PybHOy9iIsXPLy7qEOQiwXG5SoQB43G5aLuEoIZIVwdLb1jYEXaMSNWSb9i+lG94PAQFKyEtD4OVOoxxN8+CZuAy+bovZhQ0b6ssm2Hi587l+KviW8wGbaChPqSsm2p+ybNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBkfMb44fX2P6i2b23Qgm0skHIxi5zSh3WXbpuYKTBs=;
 b=yrTv8tM6vCZ0UVvpRKf60Sfnyy7KauK0IylQBpIGEpcqi9oqv/P5wxqhNFxqGwjGVxIsFUiFGnatutKZZAv4qsSBExaQaQ9Lq7KvnBZqothtneDzcUKyE+Zc9TOezDksOg1NK42nEXfoXm4b3201qe7fMMeM0f7PaJ9FF8UvefA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5592.namprd10.prod.outlook.com (2603:10b6:806:207::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 18:14:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 18:14:00 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 0/4] Untie the host lock entanglement - part 2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241124070808.194860-1-avri.altman@wdc.com> (Avri Altman's
	message of "Sun, 24 Nov 2024 09:08:04 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ldwvqpt0.fsf@ca-mkp.ca.oracle.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
Date: Wed, 04 Dec 2024 13:13:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:207:3d::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1adea6-1771-4526-1f81-08dd148f6d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vgPP2WGNMK5LGhF1vT5b+MrvTyXBNuztamO6/0FMzjjD2aYFP3wmZwzwAq6b?=
 =?us-ascii?Q?sCJCmj/sKsSMEiD3wAwMPP3opsKpuD1HO07xsibmSFJv6c39GIofY5d8xAWi?=
 =?us-ascii?Q?lo8O8sMD81Agq0Q6zV2Ogv6qkmuWwmVWzRe1DSxvhRYGiGJiSPCrDTzP4/NU?=
 =?us-ascii?Q?2soQMxrSQRT7SnkkP5y2YGSYO/wZzG7B738bTkzvb7dt+DNOxqX9shnpjTBl?=
 =?us-ascii?Q?iMMop4T2E7fuFFzyTkrA9hcO1za6xkHLyhHMsky2693hG6QH0fIE7lq6qVZV?=
 =?us-ascii?Q?iAmMPnVeYl979YDZBBNiLIvGeN8It2RsleZMipD/gLB4AZsR9fHMyHxS2Qrl?=
 =?us-ascii?Q?mu0m3QYptccpArNpBZwF9mTlYeLQ3aSxF2/LQ4VGw7xz/N4dxMVH+8zQdsR7?=
 =?us-ascii?Q?MmDtq4xgq+1cHNFgV/370n8s/0C7cSrC8qx9WNQM90BUkwAZiqDPGqLxfoFj?=
 =?us-ascii?Q?JYOrfqESXFMiI0c8/9WCepyUGX9vTMnJX5zviNMVnSLlsL0spm57/8RGEl0U?=
 =?us-ascii?Q?Na2f9N11zvRpGhOxq2kWXHAHWAfrP1dXPnR5K/2vclEFC63ppmaDNk96XQzz?=
 =?us-ascii?Q?jjYQM5WkfFpsC0gYdVQbjL6/aJ+ae/ly7m4q/dVGGL1JlzsR1pROCcNX2J86?=
 =?us-ascii?Q?tCR5/ACfOy6C6hFPlf7jD42M70XwQjxK1Y6siw10w4HA1t6jR2IfJW18hSVm?=
 =?us-ascii?Q?nvSTrLckimJllGchVOzkW5+leV1bIGtKhfQAsMKYZiyZcFyroXKFI4kv/Cnx?=
 =?us-ascii?Q?8AxlNbINfMzuphMK26E94ZnV1IfECGf5Y+Difq0hh7qJW2y1TdMB1bOL+pKs?=
 =?us-ascii?Q?I7pFbittEUSxnv+1yDeXqvOxLRMy/5+vu43MH8X0Ebd2RwklV904jtE21Xf0?=
 =?us-ascii?Q?Zzf9TUnMlGtc+AooZ1G6bgTtsECQv1vR9N6tMU6etbo63brcQYocqf2Bdm7D?=
 =?us-ascii?Q?isepIqTh1ymMHPK7tEh2H6IRUKWkSrH14tq2TapMIu683nsRCthj1//OT/JH?=
 =?us-ascii?Q?0vcbQuOMOi1R/o5yXrPbcvzit0TrfLTu9otXANPb0zJ148p25aHWXZ/IxjlK?=
 =?us-ascii?Q?dyCE0SLvLv4VsZxJpjRq9T5x1XJPBmrI4ZZy/Ywe/OQu1DoC5k2horKSswRk?=
 =?us-ascii?Q?1ujgjmQ8Xv+hry4faXgrCHVrLanAMGFa5/ORx4PPFXwIbPaEGb3sla/5BxFA?=
 =?us-ascii?Q?5+ill0SpVtGPzl6NCaBTQZlHYtFNqJTi9YmGz+1AJ+ogmJTuMUdXoZDSkWQg?=
 =?us-ascii?Q?+DbsfkXKjO/Br6aGZSB853LVWteZXTrp5ZWgZHqIKkQruLxO0rxpSKEmTmLU?=
 =?us-ascii?Q?oyxJjTB364oNVLsy1A79nQ2YpILT/hcOf6XdGHaA+CnRgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PgchlPFsM63CR0iNpRHWeyALhTrKXN13b2bqrnYLnfN6Vz1UpL3IBFdD/qzG?=
 =?us-ascii?Q?cxjNrEgqb5OleVUBfKqHfQU0HuybFF5nXrt/ffKBU7SFChntLxcRgGXaVjE5?=
 =?us-ascii?Q?cxQNuukvkMRoUrY1BOaP02iSc7ZFa2lJtDrOMZLv3oHf/Ytaz3GnzcoPE1oF?=
 =?us-ascii?Q?pyANNN2B3K14r6Dz9kNUVeRo31hWi0V8AqcBo8Gc6iMc2mcm/iiivUMZbwCP?=
 =?us-ascii?Q?0vyFVDP3nSVr1GHAalpqvphyRGKMSDQ72u5uRXobJrKRkLd6w5/j1xHdLwj8?=
 =?us-ascii?Q?nj6ZpqX5w772F1mo8IIlXZ8rPX8UmLQoBU4RmsE1dlHGT/jNpL92dowwqyFO?=
 =?us-ascii?Q?SPUZceKztW9RhKl964TEJeWHQvX2I2fTcbdQhWv3S6Xu02DKn52MblTBQBLX?=
 =?us-ascii?Q?m7AKTTDgUcfVM4loQWTc9Vr55osceH/3y9J3s/3gsTKjz+AIjPD+vGBRHl1B?=
 =?us-ascii?Q?Ok8yJHdmOzjVumGgtmwwa45rR68r4/WrCpChLN11csToi73/IgOexy1R4Hjz?=
 =?us-ascii?Q?vVjj8DI7YFFNHe4rKRcNtdScn1gUpshQtKXLnJTl9/5HZ3tJ/T4kmSaotsP4?=
 =?us-ascii?Q?7lmRYSnB/PJXqsBUgNLz8erkl95zsr4dDMRWxypJZZQ31EMvV2Xl/+xZbsOR?=
 =?us-ascii?Q?0lagyfE5XJaIM501PhYeY1JcrBPcxLXjnEKUznb8l+km6GygsUNE9Ajw0eJW?=
 =?us-ascii?Q?T6eaWpqM+acnByBCpTPPTX9uiHyJ+uptH+/DGIprq0DYAHUgVWau2FTnj2F+?=
 =?us-ascii?Q?cQJ0nq0dhy3rKt8uMl1xRyhX7jp9z3pUIwC96XbzzDtiLM5J/3sV0vMl7PYg?=
 =?us-ascii?Q?yZM0H5jsN9+UuZSGS3Poe9V+M6goMiv4v2Rqs5ygM0Ke4zCoq1SErl68CYHw?=
 =?us-ascii?Q?me/o/Gt8wCCmz641KWNVPWaMW7xFyxaE132S3DkMWFUxUktRULGILHfjlsQ0?=
 =?us-ascii?Q?oKPeS79JKun9jpRdvGUne0Fvy4CRAW1HK8kxiMY+EKPiFfQmhO6e9cwyUQFZ?=
 =?us-ascii?Q?O4w04PVv/geyrpBbaleQVn49rnKps8u3my4SnLYgQIwEHdLvilNuL3A4PpRu?=
 =?us-ascii?Q?BUkMBn4g7NwSU/IM5lx4/rX7tHub1hnpELoTmtVKVJE1WwxuU09CTtPU4neJ?=
 =?us-ascii?Q?+ja4ZlJzsqqztf6gF0tCvtabXBNbfWIiZ3cu8J6wsNDDd2wV5uSFnzLYsMVb?=
 =?us-ascii?Q?d27Ge6S5CGSpTHHSiKLdR1TScRAisnrCYsC8Tc5zFie/E+Nu7o9MjGtxdN4E?=
 =?us-ascii?Q?eYOH0fx0dkVSawXxEFubZuXvHRO3kMmXl0fH8WBEjSmZ2jLwNa55MqrO1sAg?=
 =?us-ascii?Q?zropWF8ZuWy7Hk5mmD9EJvoWKXDDDRyAh6YQ1l4nexKrB7ZGQs7ZcMyWy2GB?=
 =?us-ascii?Q?XfoMpBzEPoJqyW+hh3NkNTs/vhbuYU/KzupLHuiXpL/KJuHJvyc2dSCj9aMt?=
 =?us-ascii?Q?nWsAmCiFdwyMfuAH/yhEtCCMBkivc0SuaXj5X95eV776GeNB3Cf/FEdi4ENP?=
 =?us-ascii?Q?S3h/ulvOH74IUnyfVu+fUNyoKKoqZAted1h9vGEASS0+GMm0SkGLpn96VsYi?=
 =?us-ascii?Q?JkA2rdRAvZd5KWGj0+qm2/pkfo9oBt2JpQX6QZthxmU8bwAC1I/byuwLKOxk?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OvfbGX86pvluJZX6dy+c6AOkVy2EPHT/cxCnH2drIlEaBYUWErwvzGdrzc7k6g5gyT25SIFZ/+FovzYVhXmQzqE1m4nSA5TdEwHDlqwk3lVvJ9SXTCKILgXAjeyix5joDgtxoONrAWfSnXhA91q3RpUbDu0rjrJo8Eo1aHS5CnRVxA18RgSnTsm+0c3Y+ducC2uF14WxgshXdunIdO/l6T7VmmMjcYNkC+aOK9EcgW6W9YVrfdVtrhFjpitdg6nYOb9HHffmodHzLTEr00KFbMxboXVfGXouYeyHbz+aqPlBbnyuRAsgXfWMvUsHBje7fU3HgvjXBBC9aj58vi64W0g+6p/BLZOneO5jW4OWCQcUhiYQAnMn0XeThIebTx0TudYZ56Elf1G9yPcFLMnrTH+ZPGNXdv8gzgFejyaHYU98TzPjka90E2xLJZHyFcu3Fqd8hFIvwUqoOgXF4B6TPiB7kRUw9lkAFtIcDKJIkbW0MQAU2uaNbi8Mwl46P3oyJwE2FhFSro8jDKbk/xxLHDxG2+tbG0XdIzBXpfb8zTk2d+A0qnInDpVtSxD1lvFbw9LaYGL0fOQGWAmMm5NQ9Z+IFaYNeqKIcsQN0WoTeUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1adea6-1771-4526-1f81-08dd148f6d18
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 18:14:00.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kULa3Rn7luTFi5mxT89hV3HVNLDZKIGEXXyrq67lGxTGMSEi0eBXxmg27E+idNV2Z+ahQhesniU+QYhuKsyMnM3sFsOnqp/3nD2Po0p95lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_15,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=723
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040139
X-Proofpoint-ORIG-GUID: EiYjGXeLkT4N9BIUEKhL8o8T73nZ5PNG
X-Proofpoint-GUID: EiYjGXeLkT4N9BIUEKhL8o8T73nZ5PNG


Avri,

> Here is the 2nd part in the sequel, watering down the scsi host lock
> usage in the ufs driver. This work is motivated by a comment made by
> Bart [1], of the abuse of the scsi host lock in the ufs driver. Its
> Precursor [2] removed the host lock around some of the host register
> accesses.
>
> This part replaces the scsi host lock by dedicated locks serializing
> access to the clock gating and clock scaling members.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
