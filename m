Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8031643D
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720149991; cv=fail; b=F4HdBhFXKJtRvDRiy6qCtld5WY2vXEdXNrt9o0JF9T5QToHfNGXP37ptDbeXP7alxKVXxPSsdTa/MzSefGwMyAH+iPPgI91OruTdMkCimyh91QQoqTxGGW0xxEhSnM3k8ZDfiioo7wnWiCrHtME0zfCkjKDdO3MXew/CVxN8vM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720149991; c=relaxed/simple;
	bh=z1a/13XNg+aSoBmFnByMtn2ZWBDw4H89yl7EUnW6R2w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PaVwdz9M4CFF2HNZpimSCYrkhYaVk+mGY2eab00lOx1WdFfcFcTgKh0oTtyhpmxv7Sg8+wiOgVHMZwWitQ27gmQf9bOvUEwVob1dQ0+bpV2fG0zzOmfEDjIW9O6s1inPRc1ucLHbLQ+meMqaYvKSzXNecHhUI+l7uUYkD1xUBrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CxwuhrRu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jycu3979; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CxwuhrRu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jycu3979"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464Dx9vS032187;
	Fri, 5 Jul 2024 03:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=YKmgao7x939saI
	vQMYUdBIFSbRyslR8ZB1oRBhov3ZU=; b=CxwuhrRu+azPGyWBMNqNL5xZegGNgf
	q+28CR0ap2+g8YWvgmw27i+JfNZ86E+WDd1cGXiRutkIxMe7ciUmOIREwvwpoZ+D
	rhjvjtoAQqQNUENNPw04udjnl60mbuXbVbAqOSH+0PHuonyMynHg37C/G42mEIjj
	W9FEu28CnJETsYMkYXzgn/F1Fw7DHeJCjU3LjFjQsTPUFMpaFTZ6vr99Cwma66yD
	IyNBNOB162qFp+dgrrAouqMcfD+lVPIS2gTQi9TsLI0A9aMq6UZ8vKlyyFYK8qdl
	kvda+l7wkOsG2pkXEmcYPJ81c2W9uPiOmJaKJx4wYtFH+gJjsZ51K6FA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402a59at0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:26:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4652ulHg021541;
	Fri, 5 Jul 2024 03:26:26 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qgyynm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YO8UESo5PyV5kFwOLlON30vVKu0kSge03kmKka9TnmquhZ/iiiTK62HlEAGurm1fGAanjPwtmev1COMR7QcKpi4XNBQGm1jaeVSWF80mdx9DpwH0ajugvouiVgy+Qu1ysBAruDo4pKl4MLb2JfmpFdSYEIhZ0WklaDjj2qPVvWwf9YQ6cmLkXXTrUDaW/NpGxbRuqPkdVF/nQQB3EYm5domPHPkQE9Nar6N3WaXBcORVwUEh0s86JRYlJH0nQ/bWkcpgLhczj3SANg2MCH9vtg3Evlr3lUaUydAsW7jL3bpyR1IKBfpaTxf717T7IEOAbtCN+Vd5GSRYc1C8KhuJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKmgao7x939saIvQMYUdBIFSbRyslR8ZB1oRBhov3ZU=;
 b=BPeR1+BBJVD3p/H2ouxWpAgB7QeCPfsAelhWub2GqITdDXKHZ+sUZLMiBKRQuCBuqYbrQWfUFrP6ZtnvpGbQ0Ad70pOoVdgIPvw4dFh2AoyJXWoGPQ0Llpjd8cer6GKjgtXrgBl+/eAav7aGEWVm89xKdmitM18u6t/ZE0iYLQqcLiMUpMbvridhc6w78QOyq/VTUgsSFwWFHfmkuyW6/Xn8QAUXEBaeY66LKiO2anUDHwPfWj3PVf6xdta5gLJ5D29zmm0Dd6GWjtSClNxVnw/Iyp2U0Kt4tgJAcUOBLWIsRX2x/QcHDEKiDWE2tp5KbmCwovLyxnlttNyCBpaeXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKmgao7x939saIvQMYUdBIFSbRyslR8ZB1oRBhov3ZU=;
 b=Jycu39795O4CsEneBdeXwGD3sl1CgtCJdNcz4ivNA2Q+WQF1uaxFB6Q1IdM1s7VRjFf+zD417p91xgGMmuYMdFq8rYlN8X2onuBWcfAqCqiO0uiJoqmR8hxMOyisNIo5m3aP6ffQmUfYbOStDRDE10wzt1bN6Mv0ShLaJM+X2bo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4235.namprd10.prod.outlook.com (2603:10b6:5:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Fri, 5 Jul
 2024 03:26:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 03:26:24 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com> (Justin Tee's
	message of "Fri, 28 Jun 2024 10:20:03 -0700")
Organization: Oracle Corporation
Message-ID: <yq1le2ga5bj.fsf@ca-mkp.ca.oracle.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Date: Thu, 04 Jul 2024 23:26:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0294.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f3c2f12-2c49-48cd-7081-08dc9ca23f46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?3Vn84vU59h7nbqYhRvWEfezQ8H2CQX5wsfJl+n2GCi2wDsV93AwKcSzQulAR?=
 =?us-ascii?Q?hqtxg/H47m/sgr+Wsg37irLfldFjPGFJ9fDc6ltfRh1rZE173dBt0XIotQWd?=
 =?us-ascii?Q?7xQQi+wbdScfFi6l2KtzLbrg6QonRTKQS438isoJlDRo3Kzaj4ozxkbF5vWM?=
 =?us-ascii?Q?It60Quqc8OBBOwZDkpQ1CKX/XsJKZ2AI82H1/PxdY0FHyX7ZVBMbFTQoo+kx?=
 =?us-ascii?Q?/DXvBSPQUxvTCpr2tq41/iXv1IolhHjySWMbjFH/UasFv+nVSrpiJAj46O04?=
 =?us-ascii?Q?qSUbC4zeLtlrPlwJiwXM4Btg8rzQtF38TrtBEU5HFwV2bfWrgcnlPW+rOL0u?=
 =?us-ascii?Q?a6CD7EOxGdCcu1aAzktCrtA3I7zIWZQBh9hravs0EEzDh5fACzaDTDUdedAk?=
 =?us-ascii?Q?NznGmpZV6WXd7XJX9vVcVxsOmNXqKswC4vovF85IzYBngLfLs8laT7QnLL8K?=
 =?us-ascii?Q?s6Ia+Bl1KXCSLH1HybbOpOr6hKVHdT24hB3PYOsTrFU4Sq9KdEtIFIsa0iTz?=
 =?us-ascii?Q?qcd/5wdfL4ng+mAEM27p++r5R/Tkrxf52zCmGkPwde44Yn6tkUtAJbrCYWPf?=
 =?us-ascii?Q?Ab+/EWPmY7mAp5gmX78qTV/zPFTQljzIBQKucIVIsULmOZS6c0WjDMaOO/O2?=
 =?us-ascii?Q?GsGp5vwKlBoAfgEfHG62BdWXS7CT4B3K+AhMVZQYvFo2ogDbEQYaA2WqJn7D?=
 =?us-ascii?Q?xY+ELb/XsnYm6LoMvuXKp0//FjGhYEKRSQ8DNGccSYTUKq/4wdK+jAkF+YDq?=
 =?us-ascii?Q?22RvpLuDpdIU1kXws/tPp5CbO8NKpi0DUH6pXNSIsNexFIxA5o4CEWbHQpsU?=
 =?us-ascii?Q?HjKhl0PmMyew8QWNJaiHlFiD0XKSGUPjRuiwyT7TPlsIJKfnuoatISnoNgUW?=
 =?us-ascii?Q?k/i1bVzRkwF2s5kHuQQ1ty5eozjjpRY6x6D0jJevHroQyEmWWwOAjKbNqfZj?=
 =?us-ascii?Q?37yd1o7dXDP9Ztw8A8Hvb+3yEzYMLwOopDSEg9rivIbvh/9W8mrFjFMuWAZ7?=
 =?us-ascii?Q?KgLdrzf7nFm8ZVeiYdc1e4YFft9UkYCQIMuQQlNBGQjARPA34CbJPntWmyVm?=
 =?us-ascii?Q?dtOvvdUsD/2HQerMaqCobsZlrmo/w919goH3NDT/n7ES045U4Z8KALWizoN8?=
 =?us-ascii?Q?t26MB4vx0H7yJsVJeOmt2/pz19213smxoU4yaiVasOlQEEWkPu1hnUsNUshe?=
 =?us-ascii?Q?51pa3U05+hrnYRJbnzVJoUusd1cWWeIs6V40BUHOV2UfQllAYyRFYyREwQvA?=
 =?us-ascii?Q?xudvLWjHhpzPbP2L8//hIIM8B6U80qysDsLfodSfUiEZ4MDXVMFwPJW+KqTO?=
 =?us-ascii?Q?HPujmLxyVspOZdostB45fo2OGF0c5d+4B2Q6KcdXjlvc3A=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7PFyrJDSuCmzyxhWzEKpB5ZR/bo1VCpJhIrQQEFeEmZHDElBYx+WpYP23c1l?=
 =?us-ascii?Q?GVvj9lZZQHQO1HveNfU7mlLuFpK6hxyk73RGIujhn1MGLBlqdBlNjMFosWAu?=
 =?us-ascii?Q?kDugaYzJko3Zgrek0lCWPAYRwudNBitlZKBo5q9UbYrDDi3ksH9ejUDar/4l?=
 =?us-ascii?Q?mMITCVv02ON5GXathvyvdIrJ0khs/MEXr+f0S+GSJAaGseJmYA/H9MkkPvDn?=
 =?us-ascii?Q?hI5A+BGD48GZHKC7FO0TzdFS0xos3bk1/w56pSAjjyvxpP7lP6iMosj+Llyz?=
 =?us-ascii?Q?Kqck3HyE8bK09zFoVB8XH1BbujEw/F+guoq6Ivotd1N2df+fBd+SJGdL4ut5?=
 =?us-ascii?Q?3YHdE9SdueU+Q9WCjlkHPPIQM9ye8PdS4LFkkYgoX9Zu/cKdivv8ecZyvija?=
 =?us-ascii?Q?JmnQ75Xhxsy1K48V3BTYepG2+xOCk3v6bmcYBahBCMfOYuitvubTcvcgOaG5?=
 =?us-ascii?Q?4h25emFV0YL/zlQoBjTd0grxzVrchK5xxD9sm4BOOfg9MTcVM0Q1DWY0muMs?=
 =?us-ascii?Q?UnHaUbxGESVKdeo9qqVSwwzevOMz5LIMHvSUp4EWxYFuTe620PEqyEK2iXxD?=
 =?us-ascii?Q?AUCvk8TBeVlDaKMEgmIpeRnkwrp+zl+M2YY5kDTP2FHiXBsN86fdq6jPpBqM?=
 =?us-ascii?Q?I8YCpRuGJes783WT/FKRZ8Dbd4skCHBAyH+iXzidwq8/ydsici19nCdTnAIC?=
 =?us-ascii?Q?v4Zf4LSp0xYyMDgaa4dIu0I9Nsia53UWkW+WsM3OnM3zewdJ7jRrrh0umT7g?=
 =?us-ascii?Q?8dqqsReI96jfMr532jH0/40Evb4SGsxLZqJOZ/EpDlBNIyFgdVAb+oJU8p9c?=
 =?us-ascii?Q?rdXZC/KY59OmEd9PWwWbBDOOncUQaK375KA+yCqy4q5M5y17bcQ2DCLg1s0K?=
 =?us-ascii?Q?puHozhXzx8gFugncwXz8Ts+ajuUZjXigzCCdcyM86MdWieC4tMgA8ltL5Zfi?=
 =?us-ascii?Q?Z3TdrlAJYWFMO69b+122t19UYY7NDE3BpGpnso2d5vpmX2ELzEQM3HBxi/XJ?=
 =?us-ascii?Q?hzsW1utBsXoU5xyhz4P3RBV0BiFmvZr/74zol2cAa0GK6IK8sSqeZbYqnhFV?=
 =?us-ascii?Q?VU/G0h+t5XHIYtPVYdmM1XGWOTZwOayRzfnu0SwDp64d44/FPqGtVOJ4epOC?=
 =?us-ascii?Q?5hpbYdvQ16FsITD+u7wPzkmSAsP/301ft7Gmj7BVHgSyHghDOeuUKE4WpsTK?=
 =?us-ascii?Q?V8rS5n1GEg1QDljI8BCuSV5sMc//73fQwMqkhtb0dHgJPo/WendnE6Dbf42i?=
 =?us-ascii?Q?I2T0JTM755ijX8gT9JuX4Srip1kVdgjqzMXrhxZHRgs5Y/rBnSe8jrzpGwzn?=
 =?us-ascii?Q?qfki2OJf7xN2Z+YCA06tY6SzwMur9NjnHW6WxW6rVy6NgsvLRLcBdLshgxBT?=
 =?us-ascii?Q?34UbibQpEuQM9K5StzBmrGZIBCdmVyS4d9dJMMHg1DRP8waopSe1nk6FUEh/?=
 =?us-ascii?Q?Mq7aGDMz8Xat6iwgQ2zOmaHRmAso2GD/0MRIHNIVXLZk7F1046WzItz34DgL?=
 =?us-ascii?Q?8cd6YAgwFyYbV/2e5+GPaDuV1C4cvvSkGsbq3V5Q2mC+Wt4goeQlylne424Q?=
 =?us-ascii?Q?27/9X6/xMePX6yl3qtDgSTS6xSSdQv+hwEYPSrx45sWhdZsZAM2AeUjm7kQr?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6nwf2PkCpymemU7vcy8lraNAyFyWz6QTJ/YLJ7cQlSkBrxjMJRI6FdYeUrIOq/bnIdfDf0HML2qgrL81adWRhxvBjqp4o8DyCY2M9n/0ApbMXHbeEhrK01THbegF6J6T505dc4GOwuwZY3WGjaDYVNHWejR6Ut+20ZJ8wLm+SE6/o0QDusODSzV+T5ls7+G2R84RFgReaFtAmTGPTfB7u2zLhCcmH70axXkoXX7pe0sMvZh31+tFKL8J62ynBzEZlBtY5zC5EJPdiHgykO5N8weJIRiWOTwUXw+rvB2YM+oGUNh95RAZDZ8yhFogiU/ZUFTDuq1bTJAZx92ByxqmIVnVjGJmyr5G1Qp0vCKfdlDUeCuVKLUwlyOkcAMD1313j72+pRDt5DJhepnYStOziIlmvwjkyUVqOSmhbeuFlRSaHRM2YTFF2INYJC5y98M70E7l6vk6PENSoxLvNl1xxb+qOhOj/xm+oV9lLJNE5a5mKvXvwHRagQOzmxYAcbOdlRHHabUhRx6pPzpdWWFPgfz2Ic2KURhwYTo8GwrijtSlvM8UxV/+xitaZljIWbHlJyd6FMmgnfUCNjKaycZ3ForvR8Z1FL8gtNMjQyG3tMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3c2f12-2c49-48cd-7081-08dc9ca23f46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 03:26:24.0867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiMa9nuOnLdAyccaQD+IlbNf9Qq9SrkroUebhMxjq28UOx4qsZ3l6Z+vSABNlrixRbIIF9Le0HvsJMV4HRmZKmyUzsVu9qBj+SAejhCkQzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=607 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407050023
X-Proofpoint-GUID: tsHqDOnoifp2tAQ8mEruUw_GX9JHGLcW
X-Proofpoint-ORIG-GUID: tsHqDOnoifp2tAQ8mEruUw_GX9JHGLcW


Justin,

> Update lpfc to revision 14.4.0.3

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
