Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393311531E3
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2025 02:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748397831; cv=fail; b=efh5Vk5UU6PZvSjIKUlLxkYtqwEMLqoOqN6DCQ75bzZbFXQDNPMnUnf8058xEA69sGMT04S5uy9dSsullLUxWW8NkQDBeq0CpUFPooBoAy7O0LdPvbcEulEh+kfw2dSkmdKUcjbtnv53GFrCmYIdjL1Gt2wen+gd+To4l8om5uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748397831; c=relaxed/simple;
	bh=mY2tIbo1Fbar4BbWi7rsq84gYNsRid0Q5Wza32wK54g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JflqeZqZ6yRb92Xpa22cCAWxocgeVwEeTZwuUVWGM1cjtDXA7Qsgiw213+GtL5ONROS/8rPWVES+mcrRxi9KN/36dwSQe1GcIg4/HIgTgI6nzB2ifz4V5UrOM/3csb2bXEvlr/LafXGrOP+pDwlZdV3nBrQ+X3pr7XAE8kjKTVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dp6TVw+C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ghFwnwHr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dp6TVw+C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ghFwnwHr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1h4DW003349;
	Wed, 28 May 2025 02:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cqUlQgzhyVHMCma20g
	yOtLNZiAFKPLDxrnMYqM2nuLA=; b=Dp6TVw+C51zRKumWdK/DjFgKRW0wDaakB7
	tTZRHCtwgNUcsGg9ajV51PFPzVzC8ZRDovn04ddX/i/S0bcNoQ6uS+LJX8rcBvQe
	zHjXQf9rzMNMNbVA7M3s+hWB5IZLvAc21H9EH6S3yqcEJbqt+F48woTUZ2CmE5io
	M/3eeheoG2qlMSVYhwS5NrfNeh/7SUNNQfx35uBnHKJO41L5K4P6WanL6BEZu8mO
	HhNvKB0upBbnKA4pZh5rihbitCBhhzg2eUhGW/bf/u7GnV2EN55oVLveCmF3ZxcN
	KvS/I0nG16Cgj1kewkeADTeShV5sfelDC+JaFgbhXC3Hlu5kkpuA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v0ykvxvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:03:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S0OID5024449;
	Wed, 28 May 2025 02:03:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4ja2pe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:03:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zT8IXkShA0fH2IJvCkhQXp+6BV+2hKXfSdXFFl+1s/GlpkvSxsPCxtL6qLsDYfT0P9RdcSmS0amwXPb8LcPAjpfvQ12ULNOQ30+7wQ3UUZ/9ZUaKowiG/a6QcF0suCvRp9wRZFSiGwoigP7wbih3/JGdNX3NkyJNIj/j6A1Srv1W52vjzJ/cJvSomJu5DZn9sujJNHsIRRtnHkRoX8Gmql98IAplska5ko4sIzl8rKiMwCL0oSHbaN8QnlkPJYJgWZOhTv0ljTQ3oHFK5czFsCtDR6MKpidf9vnq6HTg9WJOPQpcmbB4qZLCeaviACXX9CydMNna0Ob6S1QwTjzo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqUlQgzhyVHMCma20gyOtLNZiAFKPLDxrnMYqM2nuLA=;
 b=JhUiwxfpZ1DfnsJoeKFizyVxp3FBcIFHJQhs47or1YAJb2nueSLh8RrN9iY8RurSqS4XHL03EQRQ0ljgY/g0DKVm/wyVp7uUq5XKeRHHlYvJi2mMyK9rptzc7YEm1LYV8epQIXAmqn/AKq0ehtJDr/F/xcKhDg8WgGNwU2ZEfovKZORp7dPNFNMA0smVO9osfo8wK+sDTYgSMgK7Fwp64Y5VijhMx0emHJtgjPhwaz+rXyLpI/ku17c1ontcgHxXDzUiXnDeAuOCXRIJ9xvx8MRN1twN2W5SaDw577y6Df2YxjLtqOV1WVvEc3WW6z0UizjAC+TQRR7gqlGDJQ9CGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqUlQgzhyVHMCma20gyOtLNZiAFKPLDxrnMYqM2nuLA=;
 b=ghFwnwHribgRWPY+qyGmdsBOVaQZk8fUQq1BWJzrnj7AFltQW6fAjMyG6Ay46jbTIJgS5t4dhJefCdmpbB97DHNjNBzyb3QuKzK643Z9sFE6l4le8YJu8x8Cbyb+cgSqbx/Liza4E+Af0wM2riPyiuRJgTv47o3kioyaE1L6Os4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4530.namprd10.prod.outlook.com (2603:10b6:303:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.34; Wed, 28 May
 2025 02:03:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 28 May 2025
 02:03:43 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Tom.White@microchip.com,
        sagar.biradar@microchip.com
Subject: Re: [PATCH] aacraid: remove useless code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250521165148.8856-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Wed, 21 May 2025 18:51:48 +0200")
Organization: Oracle Corporation
Message-ID: <yq1frgpij9n.fsf@ca-mkp.ca.oracle.com>
References: <20250521165148.8856-1-thenzl@redhat.com>
Date: Tue, 27 May 2025 22:03:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a4b4d4f-95cd-4387-5204-08dd9d8bdf88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oJx5vqe2slrxAld7rwfA4Ae2qqr+oMYdVjdLIzX4yIQ5RO6/xh741qyh325h?=
 =?us-ascii?Q?RPr5FSkNsw7QEXl0Y91HnX2mTh58D84dlSOSkrrN1P/7bCAgvIqR8FQ8EXO8?=
 =?us-ascii?Q?vTGvzH7piDdhOsEgcFborApDsyy/dFbw1tRxy1dFXQuqTATQGaH6AVqmdOXc?=
 =?us-ascii?Q?g7rLGnOi0byeKPg/W1PdSSgantcdYJgMKVijlPE8SGEC4I+VETquBHx4NoT4?=
 =?us-ascii?Q?yA6P3q3jyHmPdp1kFdhPS6zyw4lzmg2Dfs8Ud83pD7zGlIlES8al8P8UImDM?=
 =?us-ascii?Q?fYY94ThIuEbkhE55jYx3LAWyp1Og2lRQyRIaukeMqTZPo+aSMZMXCvCquuP3?=
 =?us-ascii?Q?flzDZsffNbU1au9cE4Cq/m0YmRzj11YZhBgTEh9D/uqRh0zIMJmSc2sEIuVI?=
 =?us-ascii?Q?i0vqhQ0AN37aPJdo/lXpzyAWtr9k8YI8SpHSJrVlmv2vW8UhaOekgYSavZH9?=
 =?us-ascii?Q?8VQvxvznAJygBwswRFBhglxJHxfu4nrq/cey96LvQnA4rAf+E0va7VCvCLew?=
 =?us-ascii?Q?YOkzmE/pDxpyNZIKW97U55/XPJtmo4ef95KR7QPeZ+GOJX7KF6UjVZMfWeAP?=
 =?us-ascii?Q?s6CRHhFDG9tCmkpWlbl20P9cxyJL8V9U+M+QI+rk0InlJ1OuYbwsGNtM+hxQ?=
 =?us-ascii?Q?z16CKP5c99GuIcAUCDU6EIj7aUHmyO6xSeHDjqXC2agbwtlYSS96YzyULLjT?=
 =?us-ascii?Q?f9n5ZmXI7L0TygQbx2Zh/7LkrhtySXT9mg1A6jra2OzGviPjVhRGHBD2rAab?=
 =?us-ascii?Q?gmDixJb4iR2DPsTRlFF5pK8elsTvp4ZuH2F5A1bE4jN0zlXhKmNbClH31gfS?=
 =?us-ascii?Q?mRAAZMCV7qpFrU3e8drPtE67XauKs55CUlz0FB2iXKcxXye9UwUMjsSWbQ0i?=
 =?us-ascii?Q?HFgX77Cfr4Lq3HGlpDEJhSQBYfSbKckqoEd2zt7tZkFhbAD0p8Sb3d7qy2Et?=
 =?us-ascii?Q?BJ3dsxw4yHBnVPiUzXZKwuwc1WIVJo9JJ28mifJudM4vY0Jyily8PgQsZkom?=
 =?us-ascii?Q?qBa0IJ6GmvIkGeM/GMyTnTTfH7LyQvxhc1WlYoNVCgQ8OyfG2n3XIZBLxQEA?=
 =?us-ascii?Q?P+h2Y2aP5w9sa86VJ9NWExxLK68VlMeUds5rS6hu+XVOehkGVmealrdYECFu?=
 =?us-ascii?Q?InV+3e5V0DUfGzinSuGvJBP0OfOUKbSgYA1rqP4kUhceLTK9xBrQ2WQw7Wu4?=
 =?us-ascii?Q?7geG5RXBveD8tORMMvbJ91pi/09JJkh7Q66dePj4zpbPKx2wayWCm7rtQdtZ?=
 =?us-ascii?Q?ncXIvsHmqSwJHYBJMVWWB+Yd/PV0vuwg5PUCJ37PXPz8Pv7gTbGlAJSMdItJ?=
 =?us-ascii?Q?0lGcas5aa5JS5pXXRGs3NQE5VS90idftHqQnzyu64DQdExgVc7S16l17rv2r?=
 =?us-ascii?Q?A28VbV5gaT326fXDpSHFSIK2A8kusFuh0FIsd8P2qpNmeLZoaZqqsQ0TTlR6?=
 =?us-ascii?Q?Utw/legnWPU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4LdwpaPzG2z9EJ+aoraKp7f5inWY7oFLfnxb/1dS/fMaI56cfqCAaxefvYW?=
 =?us-ascii?Q?s+T08EjZNVOu5uuTniLrjz92Jd5HhiJuNODvGDOvlMZ3IwGMIktT8JowDgbe?=
 =?us-ascii?Q?qFXb7KcT4yMcECGu97EusfdqcMlkt2ajDHMZszEnMAXRLk+BCelqOYu/WfCH?=
 =?us-ascii?Q?/YQRpASnz/UejxsrVq6cIiYlFcGau5/ycP6z7C/x+2L7PE6q1YJq+JBm0qAf?=
 =?us-ascii?Q?ZpsOwuceZ8qjw3Kd2Dbz+WOVJpGwsawsVt2/+G5npna3zRrvI9MiGUqXQWzb?=
 =?us-ascii?Q?WeLS4A+OnBu0xMCo3AUkD7eyXvg46zLjnR0MKYn1cgQQNjkyJE+O2RKQ7dYb?=
 =?us-ascii?Q?higZw6EssbplOAlQ6+PTO8+sjmEwznzQHVfWliKwiM2KBMtDsa8F5fKUsAMk?=
 =?us-ascii?Q?VzPleIY+/QGtplyR7Q06+H44UcvXICDOy1XUyU+5RBVq++/HBzAi1hDUD9yw?=
 =?us-ascii?Q?YAN1+m+FuLkY8yBlXOpka8YX6SofmzLKVQpMDjQty9icSz3me6Fznu/h97vy?=
 =?us-ascii?Q?mRlhknwdPeyfCFXY7DllyVRf/ENOGlOHs4/2ksWwX/mnihNm/OThcdaDlrzs?=
 =?us-ascii?Q?vx8oDz3Wqp8p4/EdEDdOew3FeEZYhzb5ta6N/fCUvbkVqDehYhWe1IGEecOG?=
 =?us-ascii?Q?iOGZeXC85Eo2DiB3SFJA683TnxAICGJXp2fJ5TJZ2v7g3Lw/mTVW3G49NDGr?=
 =?us-ascii?Q?ubK7oN66pQOucspiDVGBd+o1MUMZA37oNh1jYA511ZV7p8aPbbrYIuVFTzeA?=
 =?us-ascii?Q?nCTLaAZ0lE7nyu6CbRUDvx0V373kawZlmv1p8KgvSxrBeCGGrgyhuZmt3Wqn?=
 =?us-ascii?Q?g8mCegDHfh1Cz035b5p11oyUE9JmRliUPguoJAgjukoKZcjIDfyAOk5ZRVCw?=
 =?us-ascii?Q?6UxfTRa2fTyxnV55t8ObsX4yFLYZ+fyUIjnnsw3rBhZfsLMcywyFQaDAX/Jg?=
 =?us-ascii?Q?hnO1DhL04Iweu/Mi6iHOfDbIzAAfawqvoWupbUjqXWYDrRnOmYYVhdx1tEf8?=
 =?us-ascii?Q?MO5blagdo9c2kcIJ6zl2bgnXys9blxKFjj4/qBrv+sDi+A7A+QhhpEWNgWA3?=
 =?us-ascii?Q?TmTtUPHjSZFz5H6JcD23GdPdiTYsx6CHvWGK1Qoz41DzqgDWqRi1Fv3Nw6nL?=
 =?us-ascii?Q?s79Yku3PQYE2iHCXTZSP69hA4AkcArc6mopCaYZuQuNOIIlLL42VRM1qyqS2?=
 =?us-ascii?Q?XiS2X7KxWWb5GAOsoNB++/1S1w6dLIcgFLnM908gCPojp8bxII2Jf3SadlEq?=
 =?us-ascii?Q?V/euahbvIJLQBI1yVxklB7ljJXxLRagGUSIkcx44P+6E5rFtvFQDEmSEUKOT?=
 =?us-ascii?Q?ivuLMgmBlchsU3mPnwX5Ps0dJGTTt+OP8NJfgRpDmDQ75dMip8iOXQ7cNmxH?=
 =?us-ascii?Q?iJH95XYS6j5odVOdtVIU8RvmVEpd/DvMdXZ0cOxSYvJCV+9ohHmQ/8Tl3W2z?=
 =?us-ascii?Q?l/FdkgHBhsuC9hCkl34A28htEJFELa2NCgFsrq061ykBkAaiw0CNW+Xgsmen?=
 =?us-ascii?Q?sgBHlMEIWYILnmCCntoyXHjMVmMPQqGrtz+UiaSLUrMss+bO+LMoXakJE+z4?=
 =?us-ascii?Q?RfFSj9tSd/I6XWmWZXhXhd0Y1rb/Rjqx7QonZXEWRfxZndRxpcJ7KgwYzZMR?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VbNQjY1kc3NShvABiZBN/6xcnprQIuWa193aRkyEa7V81UsF0/h7BMowSuPreRduWDkRunTv8pR+g9ghWMsqdVVmciRqgHKzEUpcfyPKWMvKFRwEa3Ez/PEIQXGVHUxuXZPSpegkEkXnajuee8RsLr03K8dWSkq8yzZ2KQ4v3sqRvA3VNSZ9KhgGpTEu9prCJdk1XyZg/GOCRn+MknBKgbdIKCN3V/IrNUAEkBTi5eriN1q4KagedO1WDQqqhZlAbbrO22jNyoAJT/o8Qe/0c/YvzltgLw8D3NOcYsacHBXE6FCgy9xsAWVv7L5LcHR941sS5h04wSyRUaUkcL6cMMNxMd0F8JCUH7xWLI632ANgbrvO7ke41htFoNqxq/k64Wagur6GmxxOacecY0JXCRpA8V6r8rOESTxubDAXuUgLLEgDTF7a9zbEQqJbyTTCAE9ce872kqJtum+qcwdN2TYWpXqG3ezk8tp5E7p4HFOTkjXxkSql+hT0KYayYxa0/HDKdCSMQk3o0ogASNbf5s1DaUJ1Y99ikhwgb36TfJNCDWoSmFB+hIdTMJxaEzq38SmuGmHTWHAi7YsBcHbbxU5U/9lc+97UK1k0C1TO4bY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4b4d4f-95cd-4387-5204-08dd9d8bdf88
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 02:03:43.3876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFudIKyjfbus/qI1V0JMgfQvwiOYCmkvTuZ4wWfm9uUGF+OiruW0xaPQNWlD5P5g+QM3iWU1xC+dKzKyMSZ1rE+GPKhsoCKx/egNj1cOSmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=655 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280017
X-Proofpoint-GUID: z6ypOpwFZC7pFjVkusxGCSdovdFIO-ov
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxNyBTYWx0ZWRfX+uSCBPtZZuiA W1WSs+s3m/wVt0JvK447vTrMibbY10/RumU8JKQhj52wSv6j4rXsv1g5fl/YGBFHeTc2Q0n81RL 4oUYCdDqRVtSS29BQWrHD3ta2iQ5g4a+EfQ0nn9WU5aGn52nrFm1ne09qI9swjk7ugcQ4ufki0+
 XoRKP7wJabF6V6eZulFUcjX8IUlNytXW4eKeFzlcmUre1QV8Q6FC0Ohe28np0AqRv2aU1tu2+PY GbTs0gXQh3ucYTZJuGVBD8ti6ohXUFGvUG0R6cN0xoa/s9WMmIjK4N3L3qckNUp43ZBsnP5wVLH ItyWLZEHvzdXW+ux+uxnMboNGH2WA6CUk2olGNryGR+LbvJhf4O9mu0LhbS4bJkZQUlx2G+FWEi
 CeeBbzvS1M6XbDa7trZFWdmiJ+3ssE0R4sDRT90lPcKWGTlGy9G1zobOWa2Vxp1Mi2Qkp/98
X-Proofpoint-ORIG-GUID: z6ypOpwFZC7pFjVkusxGCSdovdFIO-ov
X-Authority-Analysis: v=2.4 cv=N7MpF39B c=1 sm=1 tr=0 ts=68366f02 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=5l6GhO9zH3y6Mqvy608A:9 cc=ntf awl=host:13206


Tomas,

> There isn't a AAC_MIN_NATIVE_SIZE defined so remove eight useless
> lines. When at it remove also an unused #define

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
