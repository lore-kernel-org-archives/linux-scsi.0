Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABDC2066C4
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742262103; cv=fail; b=oUZT3le9yiKyo5NgELoGIuOcus82YqKXTfFbBogqZoPU4NRtjJaEPyrp0d+qiDBtW++PJ7My66FU9eNBdsYc+OtMXPjZrUrD1KmBf1SGlCZWloPbgnPr2HV2Q+UvtkZCm4pdeMJ1hh18BlAaspNa2WYVd4w8pxlgE3bjyfJI9Ug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742262103; c=relaxed/simple;
	bh=rk/hzOES+LuePlCnOLEqb9yDA8x9lDCl/UxVeH3Poi0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fbsE7lElAtBcnKvgXHTQVSAvA8xcYFsy2ft/GGzNQkDE3QeW2sSdlryRbbJwFFpzmMV76hup0ijV0qBqJi4+WvlpeMeOne2cMmHckfe8kpbUfBAnk1muLOTgvm6GbBIKZ7U66Wi41JmsEFuBay7OkI/DgFHqRZlwimZ8k6I3dt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fz1V4tj5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I6iQcUTb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fz1V4tj5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I6iQcUTb"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuu5s027799;
	Tue, 18 Mar 2025 01:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=eD6HTcJLjByvAo1Ajn
	HszPjz1Ct+CRIbVhT70xGLAXM=; b=fz1V4tj5S55fR4qq4j3zMWdj0KNEqNJAZT
	6mD0tZKRM0S9FtDiqjfIXnVRglf7z55gPnTRmuNu6wRAwEaqZ2lbFWKk6zL9vz99
	ZL8ygjLTYKPMZqEF+k96kXR+nd0+6kfRyv/J8HmilLq4JWQoFJVGJ37DS6Twf/f7
	rRHerW1J9/roAy37etGoZoFrWKQs/lYLah+fInoDxW0HSV2wPo8v31lk9CGKH6in
	pvoNG3XoWZu0BWnEDzUGKIW8O5P/vl14uyzQ2l4zLJWfxkfWIvtW2MZbgVKq5FoE
	rFvofQLQAsesMDzJTKT5Fca/0a1UfFPjUjc/qH15p7ZL0WkEWiyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m0v5f0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:41:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I13jdN018764;
	Tue, 18 Mar 2025 01:41:17 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxdjdyg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+0DBSkN8o+dY/US9nWfGunmu37ZBNdOrOwqXdhftX1eC+gp44J/2yoQkyCSo5hiN/+cmMQjmvNIB5yPb9IREej8nblC378NQsVHFnwDeY0ePqXn7XDFVOiHweTVHoJksK+EIjqemUXaAU+xeqIjbmIw/ZOKAhpXQkZTS4zLUVtBeKX8Xww4Uk3TdN37E4TWQ7Kd58GqId0cMIJMXi9+aBBNYt+RIeRH/r6b6pZ2c+8DTWqoHdkChiFMbJt/ZT0LNZydYGPjLJUnI4viENNC80bWiyXBUlgsjqDNhC8zWNx9rD+gbEGKjmDh8DAZgfdGjNUmWHrNeUQoRV1uenjOhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eD6HTcJLjByvAo1AjnHszPjz1Ct+CRIbVhT70xGLAXM=;
 b=kWb86z0b+kScPoiJ+pvTIBPwxkOWwdFFX4jOg0QB/wn7kPPyp60ZOKmcp9EsFY5X1439VF2GFe1JKaJZFYmvzdi2FTL/w+IQwMYHDXYvPt9uDm7eH6CqJ009kwmW5YcCb0zbUQbYZPo5RdSeJpZtfJjfDhG5Pu9DMgWGUWZXREbacfnj4AZc6qRLPMjOCDY9DR/uk7BSemyTnl2kaCyPriIySJA7C0jex8psjF7Sl3mcgCKHP1K0cmKaaI/njGQVz1KT8erzogazRH1/3Y4DYPiU4SwGQlJbU0SDYlIwB9tCkPT0Y4scpgnvP2ay84cX9RKSsz+lg1U7i8Db4tPJ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eD6HTcJLjByvAo1AjnHszPjz1Ct+CRIbVhT70xGLAXM=;
 b=I6iQcUTbPdUjoFWA6uoTSRjo2H+eD9m9Al+Dubr6gT5zYJvv5DJVM+P4CwHROtOKO3OfzuNSa9ljrdjlge+rqLM9pSrpukge9YUd8G074V6YD4JPRzwaSCSsmS0hVTne/HLAN/N0knsg5dpymNf/2mjHEoZTlgH6bioPDLF249A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPFBE2296547.namprd10.prod.outlook.com (2603:10b6:518:1::7c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:41:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:41:11 +0000
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com,
        james.smart@broadcom.com, justin.tee@broadcom.com
Subject: Re: [PATCH] scsi: lpfc: restore clearing of NLP_UNREG_INP in
 ndlp->nlp_flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250317163731.356873-1-emilne@redhat.com> (Ewan D. Milne's
	message of "Mon, 17 Mar 2025 12:37:31 -0400")
Organization: Oracle Corporation
Message-ID: <yq1zfhjcdzt.fsf@ca-mkp.ca.oracle.com>
References: <20250317163731.356873-1-emilne@redhat.com>
Date: Mon, 17 Mar 2025 21:41:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:208:134::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPFBE2296547:EE_
X-MS-Office365-Filtering-Correlation-Id: b55ac519-e8b5-450b-8002-08dd65bdf613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gI25d2GoQMi7F2+pEXeLXsolGZOBTNq7biyvaNmR0Kk03Ax4msU+Djz+asB1?=
 =?us-ascii?Q?qo5JojFiK8CArmEvje8HIB7hGtP3okMVEDbznPERU5Wxc7B6ZzRu+wnJUAx5?=
 =?us-ascii?Q?X1rQPFTE67FFLan0TMYtU11lBgkEO1KX3FfKyf93TuRWNzhUQiKwmkbbuZ7l?=
 =?us-ascii?Q?9rqaJyq6pd7b2j3dUEoxv385JTjFb2q6gRzaB7eVm+PtYoFlirgygQkaQ3Ai?=
 =?us-ascii?Q?Gt4na0lksEqYDdCfAUReW0EP4fZid8G0LzHN9dd4/8vcxr6VoOanPkk0SZSm?=
 =?us-ascii?Q?ANxQiGGl+Jdwrm+B5TLn9dZXFzs1foK3UKW1PZb6sBSc3TEtN66VpNCH1GYK?=
 =?us-ascii?Q?5W5+usAgOpgExCaon26CKSxWDEut/+atT3u3uchHF/bNdhUqP6M6R/hjuJ8L?=
 =?us-ascii?Q?8Rsb4d5WPgh3bxCI6RRho5RfaBbsLLopqctQxNj+MpNoe555IlGYN500UR+z?=
 =?us-ascii?Q?VKSdenwwQYAQl0bRz20BDK94MlSsBk3MiYoJ2W3dA6GAWRHwwh9bZRwlU0yI?=
 =?us-ascii?Q?iNU8oyv9rY/9EPas6mJNa/Y+ngX6+tADRZ01GRSk49aK2ewmpdePHwR+xldT?=
 =?us-ascii?Q?ZUGIeaikfn/UVzdn8inuaFjpl6fDHQZAkj+Q1CJKNIc5fIisZ4OtW2e3K613?=
 =?us-ascii?Q?9udN9rsqgMTBhUGjKl2hhBBL/1pGNGDR51VbWxLKNuqL/dpnMj8WzqkWZhFq?=
 =?us-ascii?Q?viw5AMRGBzcIPwXHOlQilaXmTmadB4374Tif9ZP02fCsO54HBg+KFa5F2qS0?=
 =?us-ascii?Q?ZM/WkFv3+BXkPLKZBC3b7cXtSAgaNHtoM0mKKy7463437AkrEUlggxWumAgf?=
 =?us-ascii?Q?d+b7WSxCyLLMiCy2r+r61tkGBvO3o30wYEihG/yVTa8bXOO+49pufAlVnCu1?=
 =?us-ascii?Q?uj1xzTLNziwjGGQVbK5o8gVikYWjHZvvE144yH6iJqY+GcnTMQvwinpNUw/c?=
 =?us-ascii?Q?6fvsxjco0heDLXdyUwtz6tFkEjSp0ZpznrqzJ9d482AZYTgKDIziJJYWobe8?=
 =?us-ascii?Q?Vy3oEid4ljsDL8cKMDuIGjSWs9aGC32SBGcHSYhmdK3CxSt1QAGVnELA4hNZ?=
 =?us-ascii?Q?2EtFdP3+GAve4NIuO61BvbdIzlxQI3wsaU+Fz9J0HMDSWf0FR0hsh7WF0hlY?=
 =?us-ascii?Q?N7jppfb3faFztJ1wmVIbZ6NycMSFVwiZchdPgtJAE5pZgkvOafPS8PARVBxw?=
 =?us-ascii?Q?7JloSCpOikR1DglrzeBI0es6SIag1dtKzVDcL0X8Qju73jDDlk/igRTiWoUn?=
 =?us-ascii?Q?Zva5SNgcqRyVRzaeRf8rg5Hc+0YemCk8/G6Rv2pBX3F+BchlZm0hm4ETcl7T?=
 =?us-ascii?Q?kOZeQiL+mtSw+Y6DRfh6Jgyei6KiUHOUbVMrRgUUIrmHszeC9fufqoqkJi33?=
 =?us-ascii?Q?7OK5mDpgEGBUI2rRuNi6U9dUNcWj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V/n4GrIbA1Y47c2705DhXsQxRsHFjUPuKiHTBD0zSqlgETuuAwFLDeplIOma?=
 =?us-ascii?Q?rZE8XXC33hYQ9uSiZdn+fgaO5ZmqFBzdKE+PJvkcG1V11LYuYe7xXOv1Efs0?=
 =?us-ascii?Q?2aqrci+HqCgw3EsLfgc3gJku54W1WRyKBW237B2jDv/KXmIImhLkzNvUBxNy?=
 =?us-ascii?Q?ySofa6zZq42+CpvNrtz+fL0b/GdoAz1lG+PjVDq3VZ0UV33409bt5NjHS2GN?=
 =?us-ascii?Q?YZ2SOVECn8NtwtMLfhwusC0LVmkihJNrae4QLGEwMcVnpTsMYqGU8yr0NtJq?=
 =?us-ascii?Q?8yuMHiZkKoUApYe2m8YHtVA0lERi6tuUu7Mb9FwB/CBh5VgTNmzgtXiau/IK?=
 =?us-ascii?Q?KF0LnFcedbAeLKC1lEPReRQILJbiyh+GiQxzTt39L/iCx4IZmecGABA+Jb+c?=
 =?us-ascii?Q?+ZsAoBPA4Q0M0m2urxDq3SEw3EMBZ0xArOel8Z8rubKi3jYw62VSXM4ARF3+?=
 =?us-ascii?Q?PAjAKf7ZK73xhX37obJoCM0GIp3lgNRf0f0j5sxagWWTWB2tcUWsQeZAFnJ0?=
 =?us-ascii?Q?Mzi/Ch+8GX24iHgunqZVMuyUc6hzhz+0xd8zbjByZPGNVKkC02tUyTuDw8A7?=
 =?us-ascii?Q?+5vgWYTOXSL4jhnoFzwiY0niIqbarN4wpqzc32Ulo4Lg8ApScIpySvmN+wOM?=
 =?us-ascii?Q?JV3B1W5xJEjLxhA1cFp8a2dG384u3iRbeqPqtV3RpzTUXKyy5E9iXaWtcnYa?=
 =?us-ascii?Q?KLlmY1nk4u9qQY0pOiG/ESsHNvFxaKsGOrJ8orAjmlGyiseN5H9RHqfP3SXl?=
 =?us-ascii?Q?j2Tsx4hFVZYwVZlK8lsq7uX9HlhNIu3U5Sgc9hgeIF06waMO/ZYy+sZ/FyLf?=
 =?us-ascii?Q?clp9CUhB4NITBz+tqghNocvc8JqfdRuXKvtNqSfpFZXAoOY88r8f/Ql781ZR?=
 =?us-ascii?Q?Pe7FGFLY1Lsc/Wkq/cVinA34eDU2W2fs35u7y0ajK2m48v0aDQ29d1emwhW6?=
 =?us-ascii?Q?Ozg0iFr36huJXAnZhCbiLUvS7iiyBGIcCjJFSDIr50WoKHBbaOAYUST9ih9w?=
 =?us-ascii?Q?EZRUl/rxhO6AvFzy1o56YChgXHaNjK90b2fAOoQAl465refqYUXqtV1IzyYC?=
 =?us-ascii?Q?RKjSGcPaxzvb7Ajl3tVtVXTwUpbuNOtKzcqia38mdO/BWZXDbNRV+/URSDCG?=
 =?us-ascii?Q?D/MZazq1XE9qW75LuKB+IPZGX9T/IHoKs1v8fmkTXyaLt9mFqbrl2My5SB9P?=
 =?us-ascii?Q?CHzJH8HDjIHgxSC/Io/fUxd7Kqhp1e0K9eQ7SFJ6OIL8+dKgB21CF+lc5huZ?=
 =?us-ascii?Q?YCBwKXJ/UhUfBHCTqLXBxKbMwgJ2SvlKA41zcT9hWXv/ypw/DDA2I3vdnBot?=
 =?us-ascii?Q?GDeyXRaAkQ58CDDRWKasa1e3eNEQk0raipjkONNnMwE7jkSSjVMUaZkiCsGc?=
 =?us-ascii?Q?ls2zuzQwzR/wR/mywpFpdwyRANieqwUPkuUheqezrqHbhyZGQs9j6mCSbSX8?=
 =?us-ascii?Q?lemthBa+07FbLlp4IVdcwgzJj4ChhhbcZpTo6FA+4zyHaTYHdaAGOzTCwOBT?=
 =?us-ascii?Q?iUiF90rPECURCS1LvhJ8/YSWEzrxDylLEzyE23bhWKu2/m0sLPSNTKDzmaZP?=
 =?us-ascii?Q?EFfXcBu81XSgQJHz4cmcDXZ7+XfOsTtkH3LHd/xSaJwF0ukBobMwZxcNH1mi?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oqf4cchhvun9o4t9EEpRiKDu27FN6MzZtNFdIJDxRC0mJt6vTDb3FFD+EgBOqmqfp+EuUVJD4qdSN14vE+P+ORXpCKmqhFO+BvSqe69v3tweU2cTK/EzWxJGpTlwdbc/fBpDJbcQ1/qiwrUQk8/Aj8j++2ymqJ8mo9qU/oJJqI77he6PF5SBhxU4qQQeJI7BCV86RB2qLY+fAFAC9zXRz+Rr3oXc9GPHt5mFVdF4PRGjLf2bcLRuvy80wrvKZHpNQ9sjlCiuCEtT+W8iKuHycQNyI4RSOHl8ebAYd7ygDclWHt2wNr7tbfxh375Xy8DM4Yg/jEJe/9zbw2EtWu7DnwVM1fGon17PtG23HHRb2Kcso1ceEK5iltozwSSRg3D2mPrAgFVq+RWbYVBxNOYzHhhq/oIfLYHcv83Hl9yt9btqg5kqm5Lf8ntlZ+6beL1KKr1CCcT/zMuNaNYNzmlLKlYF069nabj7lSnjXqf4sbrhQTVqyLcoIoZi+McxKQWUdf/4ZmaqBT/YeZcXf1XhQpiLAC8QB73zDkMDE8o2LfoLMWiEHMN1I08o+0dZam+bUMT/UPNWPQen+77SwIGJgdjd13kh6QxqJui7MKbbg0Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55ac519-e8b5-450b-8002-08dd65bdf613
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:41:10.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7cx5tkPnz2rVAechLmW+wf5YTreDMZgFTpxAZeB4GICMSE8jpnuv6xZL4dpvLGIXtp6NUQ40wkBMfiEJh0ritfKJZQ6ZhgmFg5mFA5xbkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFBE2296547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=959 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503180010
X-Proofpoint-GUID: K6ntaafGRwJPULWHDrrZHbEZV_Psg2Tn
X-Proofpoint-ORIG-GUID: K6ntaafGRwJPULWHDrrZHbEZV_Psg2Tn


Ewan,

> Commit "scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure"
> introduced a regression with SLI-3 adapters (e.g. LPe12000 8Gb) where
> a Link Down / Link Up such as caused by disabling an host FC switch port
> would result in the devices remaining in the transport-offline state
> and multipath reporting them as failed.  This problem was not seen with
> newer SLI-4 adapters.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
