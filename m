Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1100284684
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 02:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138328; cv=fail; b=Me0L78WuRqBQg+a7L6grqbapFOEXcabLQ0dKFFaRUT4ijjOzLwj2+Mdjj/q8qqv/M40TrFJf1O6pDlh3BZrnCsrdlZYS9ECd7msbtEEUwH23TXGjYTeTVk7C+G3MP5wXXrqutLjc6wPMJIqsPeBVUew4JbHcd8uO61FZAizU3JM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138328; c=relaxed/simple;
	bh=kChPrbtIfw9DSA5t7ooONfjRXN9v7Up6MfLXWY2mwsI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DvYudaDy9QwE73Drf1DwV+p7ikSgzqyACGEJFFfXmfImiw+MIP+ePWjpFzLG4FPwW+I2mpWrqQquLXxM+kgqRhPprqOqscHZEQEQXndkbLobm1SD7ZYz/fBGiy35hGrPVjcagaRg1ZXbYhSQxxXEG7VSfTH7wAaCTVP8TfoIfHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=saRWfqQB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xVbY1LOY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="saRWfqQB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xVbY1LOY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32oBJY019779;
	Mon, 3 Nov 2025 02:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DZMgW/h4oWc8ic2M+G
	tQQ4PNUlj4A90Ha6Ay59UWaWo=; b=saRWfqQB2CclVOE3I+qCI3/XNw8K/T64jM
	EBJdf8CbzHdFAXwFtCvO2orXjZ852sGrZvSIpLOVWat4e/f7ax9SazPRO9u9aIcG
	um6nMFCK6ADDzgYps2AbUYvvKvAeehgsrXzLUYqyCsi8qEaY332IeI4l/duov2gm
	4uNEk/cd07/HFQIGXkjRGbzqLuZkBWq//JEo0ZtWTQYkiA407BWlAM4Ozb4Hj6ST
	9V7deUfHSj3e6YhD1R9Z5wgF95bgUQsCx5mui99vqsrdos901x2qa925jmmU7ewV
	iFrZEGN62gw7+joFbukqtRYXk6DD0SuTJbTq1uH0WMU+SVtP5mjg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6kxsg00x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:51:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2NDVt9040450;
	Mon, 3 Nov 2025 02:51:46 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nhav6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:51:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBvYxhTshKnHHXqb5pagOIajUwEwxKN7QxMsMtIh+p1sjUyldy0PVH+FfAB/1ERYLwt3QXYitAd8pVXZC2OG9hI1or2MS09vrdZFmotDmqpbP3MkPwe/elbNBpkNl3J6Ub4TAibwWQcPttHN/CUodMaPFDJ4wfnIxNd8CyLhYf3EvzpRYDpZx0YmGBc+XpnS1LpOq24+rLGUbZXMcCDsR+4J8B1Iks2X1IOM6hlrc35yy1+3tSNa351lCgVW9o0Fdn+8M2yZa1su20ATxFx/5h2aHkniMtTBYL3OZJcYwocefsuEhsdyaeRrWW0pjK9txN4hQeneXzCdRbPSlPv+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZMgW/h4oWc8ic2M+GtQQ4PNUlj4A90Ha6Ay59UWaWo=;
 b=mv4eHtBC1Q6KaNjWlZYt366c5QYh8jULFKrPuCTB8GAPfxf/N3DJrA1UNFcKwtQwSsB08oEA+K40b4OXsEX2XnqEdvb3s6jAJvk8bejrvvZPPCEP3RYfY2iNKC9Y7dgVK2ID0/3IE9E1UUkIujwxEuHVaQrpUrGAzVV68vcwXqwsFpp/O4w5oRH98Bri7Yao/iY1cQsNh4DC8byoI13pyQuqmWLwuLFYU/DDzerZ2IAEPUDBoFpMdxrpwruYZNIEHzRE1lDdlATxb/2A51BHD0gJlThGYV25/BL5dCkVEw+4ibBYBECIbhXJDs2WDnEcNt312QAql89vBGfeeYTLBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZMgW/h4oWc8ic2M+GtQQ4PNUlj4A90Ha6Ay59UWaWo=;
 b=xVbY1LOYaQU7GAEqO9IBFWwdtJ+WxP2brSjIUn5q8ki0VFgt6N2V4PD+KXnwcxaHNKTBwtzikT3wEXTeMejkdSiaM0oKIvv3W7UpeCrUYnu2RiwLQ7atb0nm2HgEVBG7s51K4YjuYAIQ+QbtT1XRO5SjQghKanqQo5p0+L5DkBQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5027.namprd10.prod.outlook.com (2603:10b6:208:333::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 02:51:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:51:43 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <chaotian.jing@mediatek.com>, <matthias.bgg@gmail.com>,
        <angelogioacchino.delregno@collabora.com>, <chu.stanley@gmail.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: Re: [PATCH v1] ufs: mediatek: Add the maintainer for MediaTek UFS
 hooks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031115356.1501765-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 31 Oct 2025 19:53:16 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ldknsua6.fsf@ca-mkp.ca.oracle.com>
References: <20251031115356.1501765-1-peter.wang@mediatek.com>
Date: Sun, 02 Nov 2025 21:51:41 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0283.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: b382319b-5a86-4a18-d7ef-08de1a83ec10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3rPxpvFW0CSbjbMsD+kPAkLHI8PYiyhmPfAHMojN+IA8H0+mnyQ4Nm6B1Bt/?=
 =?us-ascii?Q?Z6j++XXBiCMc9apefPjq+klL+Bqa071zlecz4W5o7xOP2TgFkw8UPCeOzKiI?=
 =?us-ascii?Q?ItQPmNouU9lNFkUT3zpi3pBhxxESZt36A1n4CPUoll6TzKyPql6GB71ygPQa?=
 =?us-ascii?Q?VGcYRuOujnWAef227VLJntaOp9oTHKbhLHM5hsU0Sk/NARSKgYARlZc+ve5I?=
 =?us-ascii?Q?uHOxhBDpQd9cMS7jifJL0OZWwPxAAuHp48rO9g0amMZ1sFJXzVTRtGzZqh5Q?=
 =?us-ascii?Q?k/iDup84vtCqXCeCVDjJAwk+yrzSkrCtRkqhIGAx8UfGpYHAYt7GS7M6MKGz?=
 =?us-ascii?Q?52GZyRTSHZaUawSZJG2HQhZ6sofW7H1Cdd1n3LDFCbdUtzBDaFLUCDq4QLUq?=
 =?us-ascii?Q?yuYjwBiN/iYVV+0NU8qWibe+e2/+zIy6BJGIPdmd9a4AOlpZMPXL6yJo6ik8?=
 =?us-ascii?Q?yaEHHHxzFqJud46PNwXi0ZddGowE6qkHE6NZ2TKdplXm6yRIAw8X332Vq7ez?=
 =?us-ascii?Q?Szjb63Nnwmv1CDIL88nclXCJp2bF/oq3EpbhKl6i/ld/abs/hAaJSXQ0E387?=
 =?us-ascii?Q?zlyqEP1ThitW9ILGNf4tN4PqnXar8nFJve2mdcn+ZkxTmTIcusK3FGwGnuMf?=
 =?us-ascii?Q?OJxha4mYceu27dkCj8ibF1iKztMluvrjyHvat9kAMLaqsyQQA8sZ7qFstAPO?=
 =?us-ascii?Q?Uz81Srl3j7hu75RLqd2d3w77412lu9DG5e7M+iS5TzXdw2GCEBHb1yv4gcGK?=
 =?us-ascii?Q?06zamZ/Sqh9RMa36HjhcMcQt13vQkGqpJ2MpKoNEaoBWH6N3kIXWlpdc9GM7?=
 =?us-ascii?Q?94iGZhhisliSQetbKTl2aU+osAsHyYbgK706mHBzloLZp3+kdk0qapILBNmY?=
 =?us-ascii?Q?QZWJ0DQxlS41vei2aSNc0++B9eVwgnD/J5vFpa1IHbgvcCjXGyphtxvh1qZO?=
 =?us-ascii?Q?+GspEYI6JNtsN5cAeoeUyVPpZ7SPDkhBG7UKcmQiJqNZieLUkO3GMkkb1WYU?=
 =?us-ascii?Q?4xtoM9WtS9gB6xsIu/4sQn8+348i1YX+mzXlTc/UJgKrLncp0/yJNcGsN25n?=
 =?us-ascii?Q?RGb8qFlTp0K57L2CZz1gTyAJaixxubSdZ5lVdDAzEoLXHjNXQ2SNZtPTcLDY?=
 =?us-ascii?Q?cRubjl5mxKKbZ1SazcM3iQvtl6jnNuCWoxnClzPya3f4P31/LIKVvVSKR3av?=
 =?us-ascii?Q?Pp3JiojMoomD1YBuACVxCSn3CtbSsrX1DY2qSYXqlE31oButLEW4BR+ROG34?=
 =?us-ascii?Q?e5aJ+Oc/XnB98FainAtHnGVJ1LxITRFfXby4pAtEPqJCTMxiEUr2OAr10uFV?=
 =?us-ascii?Q?ZHvfoGOxMvIMsDBLjev5IfaHDXlVdPtRcBPBJY9qVESgB7IeO8FwPCJP7wFR?=
 =?us-ascii?Q?tiZuFFNehQ45UeTi5QXERjb053ezmm+HCUlQD+LSOoyJCqooeCdCCYqd3i8v?=
 =?us-ascii?Q?IVvKDQjC8pdZar7uPaL7tqvi7z3Q7a7y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hBR1ocCVWraf/So0gnBb6IyPAK+Krv9t6jwimNUmQQoeenQUtI4JEVM9VP+j?=
 =?us-ascii?Q?SL2v/v9+xGJHOTPq+6AxY9klbRK6oEFvY0idjqdpFKttaxIJKouOIBt9QCTD?=
 =?us-ascii?Q?27B4eUey+9ZqoL2rBKlxxVevLGa5DwCL2ze2r1NDEOpYamNK314Sr+YFfUEz?=
 =?us-ascii?Q?lcxVZT+GD0cnhLhSbkyGRLeGBUTu7dWWg7ss/zjs3A6oc2F6KOjX5XBjidfa?=
 =?us-ascii?Q?4ITBTFxziYT9mRc7cgpknSZUuwiujvWgsA0ioW72hpXJqLa+HntFAobMnd4N?=
 =?us-ascii?Q?4TOpXdxy951z7/IzLURs07VuyEBIRTGxqgDmFhJrCIMmyHFP3b+6ky2UvxPg?=
 =?us-ascii?Q?33ayZdQ/EHXSbWFsBU5oVXabQ2bY1AQmSXiaVivj9wdXIRMncoAVo9N40gT7?=
 =?us-ascii?Q?qkJwMpYtXLeUhRbcrS4l36nyVEA6oIsbPcS77jMwtjAe+uW73rAMl2vHhuM8?=
 =?us-ascii?Q?L9LZvOzmrlxHhG12JxSxDzFf9xMVCpsA1afmYYzV+ENbpY93hRqdsAcXynQn?=
 =?us-ascii?Q?OeGl+AbIlmEMgswkl4HnhfqwrsncJzinAhVGpaa2HZzLxzeaP9ERyCCaYkN2?=
 =?us-ascii?Q?WgFiJqUreZy7OA7xDo1kXPvUGPb+juFQXa/WDx18NgFYCwxEM3TvzomNYYkI?=
 =?us-ascii?Q?/1Lj608fms6HuM6fW4Fjx+AqBxFrm0+d+Yk+IiEEla1Zh6ZdS4Qqwslyy6s9?=
 =?us-ascii?Q?F3lRVc7W8qWzJsNOtRv2o/DUD7I1X8n+1Gq9jA/HU5eQN1J8CewHJNbgs2VS?=
 =?us-ascii?Q?JPZ1AvZ8lDCcNKTJ76EAojlANCcX4Q9vA+4LGf0HEpXZCAKWWp4Ky4gpJgBc?=
 =?us-ascii?Q?oKzI9mr2ADdyDKuSceFGjCbpePc2kg/3dHmiXQbTq0Iw7SRiFgI4JJx7y5i1?=
 =?us-ascii?Q?Nai1GnaxI189MLg2MbM1f4cqosItyWt/B2GQlaFLP6NeoquulpdH0z5w7GJ5?=
 =?us-ascii?Q?Tj/FXCgSpA2io5tYd89c0il1Cj8LBbBOtfVsl0yMsYNkmQLCbIO+Z+2RAHRY?=
 =?us-ascii?Q?dMB0kG6Buo+1hvEln9eTBUe+wAhmarQ7+XuuD36IKX5dJQBY+hTRJ/3wN3GI?=
 =?us-ascii?Q?+zbQ2DOCW9z8oY+DMZsx/vJ8t7GWo4J5lF0g4ppammlalWohd0ktC1M5PgrH?=
 =?us-ascii?Q?SCXItm3QXQ/7NevvJ1se1wcdt7A9BqyAo2Vlh/qnPIZrR8xN5rhwL5/PDkcZ?=
 =?us-ascii?Q?n7g1JsooR6L6xENsRb/o3ke6d1YRPdE6IYoNlLz1aM7Rh2sG5Ocwoq7oAb2y?=
 =?us-ascii?Q?gv3AyH6oW203MjA462X/3OFRR0xbyJYD1YqA/3PX4zV8ZKySC8eZhEWrMYI8?=
 =?us-ascii?Q?shZZcknDAaYKOM6MT2BhNVWcdDYSIAisHN1l5EFi76qQmdYhk9u6vGpVhpVC?=
 =?us-ascii?Q?XFgbKNNh/1TNDNc97YGU2El+kI4xz+nn0o+oKCd4f8VS9SDBz9+fTuaHEg14?=
 =?us-ascii?Q?vjM23DO9+gAZAy+oQjXPWnwuxZD/VMlnybbuWiofblFzd8nXUZY7w2I8zZAy?=
 =?us-ascii?Q?AhU5kQ/2USfWFWiA7V7/62BDFDV83osiWmw3dCpH15JZ8JbOASutq8bBd7cB?=
 =?us-ascii?Q?WcmxOPjHsabj+3grafGWlJl0FJhIcse6O0FXl4P7YGDwa/neG5JcwRji9hIO?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4/AWZ4R2YIy3RxUWohHK+BqkWQd9fQkvyVpqn0TKuVDOMW7r7wBRPh3ysx8uR0bikwoE8RgecYsRSRy70bu54oqukj5hrL9qWc+iyEJpC9ckxeBDDDD3+n1WgJTxMMny88mbd/MWHhoDZ2+3G6wbARBF5seaGqxkBm6K11qXmpGOA46tobIBEC1ElrvIM8RXR4q6jwFxrmcdjF+Iivpou2LrHIVeQbWX4N4i9UquIgEsOlWaEGuNLQavoJea2TbxOA56AwP7rCDeIRKYlcdmbFz+hLwpKryoFifVO0WqP9uLG6ueL2NR9us7zCGC9v8dsK/3kSn6CKXDtwhYK/8shRTC5EBS4qkn41eSRTu+dwDuJ64rqJPQzeq0TXZSuZHUWg1ra/6h311zSKWNxWnMecDOOayarY2h3DmusmyFH4wLIBBy56Ml1/kVGLb0hz7VR+p7Ca6e/mASfyr+CWgPAERx2OhriTji9PMnwVfcmD7bYwZFGw9cjfzhVJRmv0bmI0z+x+uYvY6ukjkqChw6r//ECBawut3e/FrsxOGjuy/mQN4mWMvjZ0i+1HYgOd7LbjOLgpbDTt2KnOQWazjTN0ztEDcdiP5zQSFIyhTwsP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b382319b-5a86-4a18-d7ef-08de1a83ec10
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:51:43.7965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBs9lWxf3zkc1S0ECgWLjAg6cJTL+NwPGncwK97mqKvq+RNk9miKmK/UmIlC3GI75YLwBxj6VdliFXhp45jOvia4DQpG9bC2NbLPWG87WFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=693 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030023
X-Authority-Analysis: v=2.4 cv=ZZwQ98VA c=1 sm=1 tr=0 ts=690818c4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12124
X-Proofpoint-GUID: xbi6hHkjqG5xIPF8tQGVux-54ym2d5m9
X-Proofpoint-ORIG-GUID: xbi6hHkjqG5xIPF8tQGVux-54ym2d5m9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyNCBTYWx0ZWRfX2uTCEOWDWpAM
 C1WThMKbzyHI9MX9hlryNaUZ26950RH+gj74ySKkl+KW0fuDI5T41VaAw7DcUYNItOykP50nvGj
 loOsCrAq+o4hK+NWmy+oCyaq6+66HFN9GfpAsvmVYEskg3xloOuTrOuQ37qjmE+jPg+Ngw4TWnC
 Z7TdBUW0jgE3GHy0SrK25dCIyKvzdfQj140gZXCzQNQDy2EI5PvGxkiEVZr1Ob8NA1NsxITcbIH
 erutBSBgn9F4wY8a91UE4FQ9JxJG4Qk78r8sgLyN4AwOP+wclRzUjn+/3URqkwfUC+xgG1+n+2V
 4i0kTKFh8R7C60vySbMJtaYUfrgh5jxXarG74CudgMfudoM+JKkizg5EA+glMcFJl3anydiu5li
 GHQp0jaQrTAknbFErYIoU+klIEbri/aDgViah6e2qhScaURAbrw=


Peter,

> Add Chaotian Jing as the maintainer of the MediaTek UFS hooks.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
