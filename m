Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBA71078B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719458421; cv=fail; b=D02iSoetQf+wHp+e4pF44DjBgUYZpanEf35om5EdVOFoKPhxuQCpvH7lSApmJO0tPIOUo4qmQrdo2LM1zsZWIsHJ1P9ZKhyUnPj93mzJF75LKwY93CkqsMjkOBVHedt91OkjhIOsqAK5UtuFRdTGA18kWETl+uDeKnf7APSmhxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719458421; c=relaxed/simple;
	bh=e3DMQHd/v4bYRiQ1TGX5mG7ylAYNwBPQaq+U+HNNZp4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TcfwgbxBXImMvJZFtsBacfIFM5gv9Aem8RRtRWHSEXDMKZFtaSb9bS9d9HRndogamR7mtNfrvV7S1r2/UmjEGSm/G2KgPtwWZmz9Cp/mSmO303sc4ux4I7zvrAKkI4xTQB89x6LM3QFwZIzA8W3lDzvHfdkeMhLg00ifdZdjjwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ieUSm7yx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ll3JkJzd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ieUSm7yx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ll3JkJzd"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMwKO013536;
	Thu, 27 Jun 2024 03:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=1i07M2M73OygYn
	gj/RpeSbW/s/ma1EYnq8MrQy1bfPM=; b=ieUSm7yx/nWmTyM1ID+CoIX8ybonvF
	VM1EJtNpTeJB1T8t4tGe50MxOQId1Ppa51m4b6QCvbCiJNKzr0TlUJqZn1oSBoLW
	f54qZW41rFECozr4TqYwKftdtTDvexBc+R7xAEMjyVHftShQwAJYJJ/z7por3ZJb
	ZpwvlmDl+De44z5yXbO5u0M1kyYT4EfSeIQYuYh2NrQ3uKvUhSE2WPAFCbeHdzCZ
	NgC2hNUVnvP7iwtnWomfwRg0xvBYewG3wXO4b4AbrPeQdskJmV4yEMHWvzO6WoWf
	JvNp1bDvw6W88ouc0C0bkurSFLdtImVa/FvlEzDTtqWaOOzXU2lGiQtA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpg9ck0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:20:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R3JcG8023563;
	Thu, 27 Jun 2024 03:20:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2gbcah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRmc6xoj9GVBJ2oG/yG1yi1IlIWUeasBZuXzMT/BrKauhHPlWRdYGzPw4VeXYPQ1/6r9LF0dczh5fVQlM3R+wKyfDG4uYV25eI0ypcUndhiiZxwrb6Hpkb3X8j49leeB9JINfx89XbIsZHI1lcWPP/FDnPsWpyErIhJu1ZMyaec2fQ2m9T+4KMA5pZ3ohpZh+JIpvvXv95Uz0fPXh+8DW94UBX2QsQxnh675uP4mLaOG66G9OOtvDPW+8UAC7yXkKVOwkgVp2wRvbhJqsucbm5joHzUmDZzgurS1FW6ExZC4cXswMXz31hPLWLpcjIf8y3mi0y2QHuRn+88CvMTqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i07M2M73OygYngj/RpeSbW/s/ma1EYnq8MrQy1bfPM=;
 b=QvenUdSudWeoGAeWiFuGn2OVtlqQm6J0owMM+YQ3H/z1VxTdvQhKAMyPVwOzdsM0DKpeeZ5KXgVpXgSBWYNhBjyNl75tx7qtlGe1NO2mgjG6UP/TECwHoMNpMGWSEeU9yUrdxOdxpzh3ifrt/Nl5avPei8IU5T/lpo55FbHfaCnOCTvTQiysUHrMfgi52IBocVxWqLXHxt/5Ea+IyZkEqB0cWw9co7qXqcuOoS5hMMyDGhXAa/duV16bipFOGdeF41UZ3Ao7jVgi9vwz3v21hsNxr30v1MOEAD6HPLEbPMn9icF7QgSBP+1al3aR9ZrAz3YFbTDW5AS6SbRm/kdNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i07M2M73OygYngj/RpeSbW/s/ma1EYnq8MrQy1bfPM=;
 b=ll3JkJzdCUEzLL2UlGmDqmUgBL2w53k0MmX+MYWkPHOkJkyIDYgCdvBKuZZMJPz4VNgz9NYwito+T6L2QMMdlaPGRzExuAFMnDsKhVDaPZ/ixMnGGCwDjbQpdd/of0ImzkMBr9c5fn0taDVAZBbsAflw/9P0f/MvgFRaGrof4/Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7617.namprd10.prod.outlook.com (2603:10b6:a03:545::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33; Thu, 27 Jun
 2024 03:20:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 03:20:13 +0000
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/14] [PATCH] SCSI: Replace ternary operations with
 min()/max() macros
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com> (Prabhakar
	Pujeri's message of "Wed, 26 Jun 2024 06:13:28 -0400")
Organization: Oracle Corporation
Message-ID: <yq1y16rf5yj.fsf@ca-mkp.ca.oracle.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Date: Wed, 26 Jun 2024 23:20:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0040.namprd20.prod.outlook.com
 (2603:10b6:208:235::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0f4963-78d9-427b-ea3c-08dc96580ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?yxd9j6xCV3jG1MwM1dlDS4uFSWMBXxzl2uhs0JjOU82xu71AgueUVl3zulwj?=
 =?us-ascii?Q?zcvRD+FOHSSa+KoAsCocNdfHKvqnYvaNzWfaBPj7LhifgzdbpSFymdb2XdyA?=
 =?us-ascii?Q?DQed//BglQk05wF0k+8ftu4YRem/0+ESlmoCdCT8o6VTA/BMozkNKMaWl4w5?=
 =?us-ascii?Q?PM3RiLuFMpX2Ce7aHFdGC8IFmJt+7nfEPXcDSr6iLRMAWYbmwPBiWKzq9euD?=
 =?us-ascii?Q?5Fl5IPgz9/SbiSIXRjcLxAahDKoX6BMPdiMTGsKUIx0zSqJTUcTYAGyadENT?=
 =?us-ascii?Q?DukxGvOq23vxnct2WHMJZDHtJytwoJiowg8vo8hiNUdRnO+CnN92ni+oJ6Vx?=
 =?us-ascii?Q?Mlb2rXul33+MVdvcSFuqYc2ybzfIkCUCzHI8ghkr3fQ0qnWHfwYY+VjtiVPQ?=
 =?us-ascii?Q?9uhFytabmrnubKi67IqEwFjv3T6vAO3YbgqkcmKPb0WZENztcUjblLCGlnP8?=
 =?us-ascii?Q?/SgNkfTwsWOAV3wECtIG2YAIyuqk7/CCVBHD7dkve3E/yN/W6bNMk0zSCqkE?=
 =?us-ascii?Q?kFIl5zItt0xljZEtB5o688bApdopRnYs+EiiyX46AgAXPStO16veft5KtR8x?=
 =?us-ascii?Q?+0Bjtu00wK3GMQYkz3j0JB4kutIu0DqA3W60olx9PmIm1PO713rn/zHY8Q3e?=
 =?us-ascii?Q?USUy+pXmSJvkOl7lLLnCL13xcEhY7U/LLSpBEpr9ISvIXcCWm+hbDRxpTBV1?=
 =?us-ascii?Q?SYssEApNFU+b9l1bWZKePamDTSbdQU6Zl2sgvlpRn1hUJPOxMe8OIjmSbkqS?=
 =?us-ascii?Q?m6Fn2odvx6iNMXcGxzXX/5AQCIDl4s4+UFLFTPi0aakSqAV8aCUbzW3x66F/?=
 =?us-ascii?Q?4NDvmAtNswptq4MDS7539N9RFDns1eRClysN5mmuOdtJwanp9w2BAb8DjvK7?=
 =?us-ascii?Q?Z5iOWvQ7SX5q/ZxtoX+aBDiZyCmJWknRKBlS4HSX+qdTAJNnqjyhIxP27S65?=
 =?us-ascii?Q?My+95AtIebHokNp+NQbGSnM5AIr/1ODXAkn17Th47g5qowRS3AOEVbHEcVwO?=
 =?us-ascii?Q?K62YsVPM0IXHCoTB5nPH7f8a9Swmv7xHUbLgnj9dVRHu+KKgyYaFiglhTpr0?=
 =?us-ascii?Q?8EK3YHEI0tOQkf9v/5jewyk048YgLqRbNpvx/b/cZrujvFfLwtCtEam+2AvX?=
 =?us-ascii?Q?FidjbzFdqT3FKkxaSl2lJE0+OBCYd0dvPEOxFhuXY7rT3wDIWxlDmpMVvt/a?=
 =?us-ascii?Q?KSk9qUuMf4rqrwVU/a1Ez6Ttv/Fi+BSwq7bEZdLNWxCUmdeApb0PWKYY0vog?=
 =?us-ascii?Q?zVWwUC9sgT8B1g1li6CKH0/Ej3/94HJsrjc29uBhv7KWER6lyK8Zpe5eGl1r?=
 =?us-ascii?Q?aXpGEpjq5vLgIIvYAPYLuXTLmfyshf9R4EEpM9vAo+FnkA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8j6GnwdqyGoEE4oUbf5RFJNzZrE3IC/e2QqTm1YWTqMIqRlRgrGisSiYThV3?=
 =?us-ascii?Q?JohkS1vtDWp3MjNOk4EiikvENCP0/j6GWBNDirROQTQTcVTQV6zuqsUH/TtT?=
 =?us-ascii?Q?NK6zTEKJOZenuL26v0c8E6druk1KcrPdYmidrhx7IRSO8s2gB5FRVEncPssg?=
 =?us-ascii?Q?eFOR5U85G/EmSYO3kAdfv7DcHMjVBD+rxuhPmRQ709ckzzXVhgIToSDfFEZj?=
 =?us-ascii?Q?uvprMujmMKaMGczYS9CT49ROWsrFvnKRG7oWnfllonYL40nNoWbIHGVvFqkN?=
 =?us-ascii?Q?Vp7pgcZhvWfBjun532qWw85+200q9Be2q56Z23MMRagaRF83IWJw++gu0P4J?=
 =?us-ascii?Q?A7ZsR1rRzK5XF00vfSjVsScSt4RPFN9n945g/TisJKXMIdKoJsdJ+4SrTNKL?=
 =?us-ascii?Q?elfE9s0GXQk4sSAxNpgmvs7BhaiJJKmH+mLno+KmFn++Axe5PucPMzaGyTci?=
 =?us-ascii?Q?/m5Re+UsVzSjRBxMWFdR3uI4egQB5jcqRTmjBevid7kqQjlGATjOCC7DfvSc?=
 =?us-ascii?Q?Ni1Sg4HYzfiQkuUf1cIaSSO9isRhNnq6l+Goq/vXDiDLU5gq+KMIAmeLwINC?=
 =?us-ascii?Q?M8Mle6Dzy5HzkzLouNf/hS3ok8yb+fVI3URDCr6N+DIciMpRXF5UkddIO3Vj?=
 =?us-ascii?Q?mkLw/sh8ZjpjsR558YkeU+QB24ZHXZPmhFRfbLtnws5HI4zqsP9nDWFbX6yP?=
 =?us-ascii?Q?lP4euTgCAyEY/uRE6D5EhqepSJltsUd3hfaphp5UquHwV528k97H/ppGrVpd?=
 =?us-ascii?Q?3YAtNfP3l45wwwEdo9Ub5v+6ymQDwDuY+wcPScQOS2EFvxHRkN9wqIFyioOU?=
 =?us-ascii?Q?Bc7DUi/8zEnLOThk5TmspfmM6qrxJoqKa8x1GHpCzDU6ZjAt5QKv6UcnIkrq?=
 =?us-ascii?Q?LYK88Gi5ZxBPNIMVBpe8qVcy6ta1H7VlUaBNnhGKGlUREviHSeaMquuY/5GO?=
 =?us-ascii?Q?JqpOxVMISaikwV7rX0mdZMCo+OH5972+splgGYlCEFlYDXmB05uHwpqU1XW1?=
 =?us-ascii?Q?jfOseHClvyl5EuU7P6aMLzf3kpoZCOhDUbuS8oILSEBjaR9vRqJagiu2F6mi?=
 =?us-ascii?Q?VQIdwVpcBCnaaCQisCLnxexUA1OjKDwyIvYbq2hjAPsx4yXHVh9C1jHS3L3Q?=
 =?us-ascii?Q?TwaKmtpK6UlWgLDk+oQ73ZpmMGpx4fKcozJA5rToNNOk1alsClplw3fLFgfz?=
 =?us-ascii?Q?N7uVLkJRc1p+47F02wcrS5iBO3vO6YFndL49oKpBqZ+cA7WM8iWCG7KIlQVh?=
 =?us-ascii?Q?rp7TXDdcLU5w4EVMhkVEKlx4bwmNRv5UFWEbiZkVpXUPiLLJ2QMbuREDa2VI?=
 =?us-ascii?Q?42JyBdbY5PbqVW3RuMjdCgF0fqepDN2hO/+GxocbFJMoyM+RRUt1RfVy7MK8?=
 =?us-ascii?Q?uGb0LyrkH+r+iX10qwXHQ/tpFt1nUcvHb35PqcEyRZpiVcLZyDYT4klDX1Pl?=
 =?us-ascii?Q?zyZihL7zwVEUOvJsy593Gej4YuKmMyG3S0owOsOMqY3qtxycsNmRLKrD+AYt?=
 =?us-ascii?Q?WaktjDbWGgYIzpZnuHW3zzZAyPswOabczKp9EO66iNgc0AnZDwNUUxkjTI1A?=
 =?us-ascii?Q?NnWau28dMIK06DJk/TB5EKRyMhc9oLDilwDSiZr4JTUH0KqTvlPNKvLzgQmt?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0yvu2NaIMzJ8MWgRk/JmNtusy56RazlYkXfwnd0LYAkNrUaHAVj8KYWRgIR+7ZJtpmp7v3uQBEQtYVNbbhQW67fNFc8VQALP9b8Bi+ITZ3YjVZASidJ2eCkpiUTSxXLxtnaF9VSYYfsPDo7kpwWm6JTtwABRbYh7xHFONgPt2CBmXY1Ne4QuBsCMwUVQ2aSgfwpRCA2ewAon9sCPmnm6Jc6OvIm1yUogAMmzkrx5I5DpDFvFAJtNdDjt2JIiPjp7chkvWo78ZAXcGzTl6ZYnEOZCJbuS394zcIqfuiHaBol+fb9fuSNBzk398Vfe05xlIb+PlzEdCl6b/3/kjy8h3octPca76C3eYkSYavdBvHzp8hlRzONSPRVBFceL23trciGhsEQlnMS3VCmSKv1fef5D4KKFBWvIu/YZLRzook4Z3mooaETEY2Y/XdnxBf+lLadlu1tFyUtTeC66iAJvNe/CvIcUE+5Z1fbCZESI2kUZlKg90WE1eYZEr2jQ3qwHbS5CBEhYzjJP2dhzPbzGUNZxsvl63JKhzXCP2LAzByS4Uui/az581GZz44XGm6DAHdUMN3qnAIobNJk1mzvR6Bcb/tK+GsWI/xiyjW9/gK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0f4963-78d9-427b-ea3c-08dc96580ed9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 03:20:13.1035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCmGCdcYQni/TmVdunrom0GrB0mbxSAmMBBw+3lhi0DwHXraWEE09u1hbmF7pP3Cuw2LvzlrExrVdDjzgPqRD1IceyjErJd/bMtobfXJR2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7617
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=948
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406270023
X-Proofpoint-ORIG-GUID: ubka-dfUbYemGs7jdP4xPICDhoYv2xu6
X-Proofpoint-GUID: ubka-dfUbYemGs7jdP4xPICDhoYv2xu6


Hi Prabhakar!

> This patch series, generated using Coccinelle, aims to improve code
> readability and maintainability by replacing ternary operations with
> the min() and max() macros where applicable in the SCSI subsystem.

Your proposed changes do not improve maintainability. They are creating
additional maintenance work and making backports of bug fixes more
difficult. Plus they introduce the potential for regressions of tried
and true code. So the series has the opposite effect of what is claimed.

Readability is in the eye of the beholder. Whether to use one approach
or the other is the code author's choice...

-- 
Martin K. Petersen	Oracle Linux Engineering
