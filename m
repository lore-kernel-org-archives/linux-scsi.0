Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81A34D3BC
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762622546; cv=fail; b=f7Ad/jvyni+A12+g07rKJj7OUhAbQdA13s+rQt4kLrhxPz3dGmcDFIYTKrKes0UP2yVZluRjfvXeEc0DhmYjjaS3pi7YY+m3CoW9yuuUmVZEYxMvWSbrB0RX9BdfwQVv4q5zX02nCZ0Q02tq5M7hC6CcHVm1QSAvgDcKs2Bpk8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762622546; c=relaxed/simple;
	bh=r4k3cvV2zUdQqFp40fZSMlQkXRkMmCFpv0lQroR+pUg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qB+mVgOHVkdM3zvlHBQ7cVQwXRyF1RUf+8QAtgSzawsRJYWldl7E8hJ1YBERR2yEYHy1cwf+YijK4AFkJ3hEjXoJJNlflu+Y8haZ2fIKo+mVEHiXzNyu3nLq2hHuWIHksdsKCsT+EtvmgMtgd+6HyysH4a10mQ7SRHkMrucVnGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GQk6vXQI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OxI+V+SJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GQk6vXQI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OxI+V+SJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GjUMq017463;
	Sat, 8 Nov 2025 17:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IdxMg5EXDNxbClrxyS
	gfdYe/iDalgIupnsifPXR4L6o=; b=GQk6vXQIgRFOp+m9lyGtED67ULGejG02L/
	Fzvayqbef4egBGThYh0azv/iH+RtjOUBgSocI8/CipiIZJjygufy4s4TU9AC1Mri
	5+XpilUqXnqqGdle77zBZlV6mQVmiz5kf6BPmR+rHupFqq0mjXiEL19CefrkdSOb
	nZLA7HgCq2XxTuPjJ9EedVLg4IAaakRYmZQKcWTv6gaqBflr8C03s9mR0wK4Mt+G
	3vmg4Y97zXQNaZ/n5bsYUunCNatj3rGl/ggDzdagNA3OsX7XGc4iOd07HOMnCObX
	qr6zMDyfBGeqyp36AoKHdftoD/V00owrX7q0SjkL78DDXg4r435w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se023h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:22:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GdLCr010113;
	Sat, 8 Nov 2025 17:22:16 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010069.outbound.protection.outlook.com [52.101.193.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vageu0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:22:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3+2rJKb2e8DxB9Dk29ZhKStD2Sfw/6pY+lgib3e1wyV0VVWOgG9B5C+AIf0Bn0v/bWB+WXG3E1Qr2+lkVC+zo5Dv+Epj0WTIibdGIDlmzd5ZU5/EqFGrl3w20fFYj6MICjkyr8SJT3Y7e6R+kmePIdbKyv1WJsrMvCniBqBsdhODsbJS+bQOxgPKhIp3nWgCmH81vk+U9y8xj2Ei4VdIsHVNwec+Lwf1GTZ1Usv34RToB/WHl4ZVqVVEIKv+aKNsSp8BhsfOFnaX5YZLfOtvoSGymfYfuKg0g2iq5TX0JvGrPI6ayp+tGceWoVQqG1Qml7E1fLd1eN/TxYTNYUd7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdxMg5EXDNxbClrxySgfdYe/iDalgIupnsifPXR4L6o=;
 b=zQ7/9NiciK7U6/2PNxBPR6ABC+gLASsvdYds0qnEo046qCyYTJB03luttZ5JYY/ruzxqCZMlcEEnJFFIhLZMIpcv1q2w3mDY99urgGg0QBxYdk+cYz7Bq1sqSCcNWBlprZgdKK2FK3AycERGdopVx1A+12PhMTRcz0P69Sgfu7aV8GeG+M5vMyqe8ekmHqzOkKssmGMyeOMqqNZMFhC3z1spdEptO2N/ldP6S/X2FWwOuzPl3pHwtYqivpQO4Yganmhu+dk/owQNVyQBpR/yh5k+/udNvwfu+p6LhPGR5qVDfgY6DtOnJPziYIgppXeG+b8CKmvaqCnBCGb75aCocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdxMg5EXDNxbClrxySgfdYe/iDalgIupnsifPXR4L6o=;
 b=OxI+V+SJzCU7BC42skilK7s0G0Wxgh14jR+YP/43nw52P6UmsxAdegMreS+S1WviLy9bo8COFlhcZpGkaM7CsmecC5BIYTX3zaiKBuOMzB85rhAa6d3AcggfQ2Hm4lflDp8ksUXbleIdPPFtWpzDeLREdgnVaHNiI1dZsUaGLrY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 17:22:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:22:14 +0000
To: David Jeffery <djeffery@redhat.com>
Cc: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 2/2] st: skip buffer flush for information ioctls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251104154709.6436-2-djeffery@redhat.com> (David Jeffery's
	message of "Tue, 4 Nov 2025 10:46:23 -0500")
Organization: Oracle Corporation
Message-ID: <yq15xbkjv7m.fsf@ca-mkp.ca.oracle.com>
References: <20251104154709.6436-1-djeffery@redhat.com>
	<20251104154709.6436-2-djeffery@redhat.com>
Date: Sat, 08 Nov 2025 12:22:11 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0054.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: 66745187-6912-4b22-62fa-08de1eeb5c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D2RWc5uod1lkoFJawTV/KVyC/vd7rSy978b7ctbv+IPv+g78Yr4OsZSlYBYY?=
 =?us-ascii?Q?igpgXITD6SkqpY/sQOkBsdTEAjp6cc55ksJCwODnz2ilJ5BvZDKIQexxmI9U?=
 =?us-ascii?Q?AtwAw9fcnibLL+vhd3gMXlkQN4jkfpC3C06Gqq6GeZt1SRyN2QBhuP7kdPkd?=
 =?us-ascii?Q?ihwPXqvjkhdvNpgqPvn01EkUMFSLkSM+QgxmnGm/HO1dTqnyzpEoo4hhp7Ws?=
 =?us-ascii?Q?qwxceaSAEvupYaQ1lLNh45hIRrIPqBNq7fv/TzSK6jnMsX9A3+R1K7EK/HPq?=
 =?us-ascii?Q?fhUyfLCnB4KIi1F1FbXu9nHN2+hID9KlPqO7ELLPN3j8tzVMViPKG3+oywvt?=
 =?us-ascii?Q?lDtSKHUZ9RWVdBwP+kCQOonL/ISkcXeo8DgVUNEUedxrzumumOKZT7zP8b+/?=
 =?us-ascii?Q?lsRWV74Ny6LyiHMObgl2NKRKBJcWru1HanD7x8B5LJd4MvO2tJYcMZUySX0b?=
 =?us-ascii?Q?+4TZrkrfm6TEz/3ZRwdzNFAl3a/v7WKMv0FUohwCu2JX6ND00R6snLecKolp?=
 =?us-ascii?Q?ZKd65yAo30RACgnA241nWCG6BEcBUYUvvJKPSOsm54wWSfSy52sBfuDAk7X2?=
 =?us-ascii?Q?AbE/QTli/mNlfuD695rgqFnxqX+l5AFTjZrJPcXrBvm85RH4R0rUC2No6PxR?=
 =?us-ascii?Q?U7u6/pYichtViV3P6cpS7LC1a6fBznhgaqTEFW9x5QjwDkCQd8RR4tQfUz9+?=
 =?us-ascii?Q?Ml3mktHR17j70k+EdKzWG0XbxG4V7Ow8tyB6WXsu23IcooX/wYURkWznVYi2?=
 =?us-ascii?Q?b2VTDde0zFYxTRiPFZjQZ2Zocpw32xStViw/UHS4I+/fUcmJ5JBhZ1vNX723?=
 =?us-ascii?Q?VMmdYKIpnqgWVtWw4ZTG8MameVpjOx8REUBp01z+Tn8UYDhfH6Pl6AkBT+Cb?=
 =?us-ascii?Q?yE8t0yeRFpS9e/gvOiOeN68G4BrS8vHCR8mAv2dFz4VVzElys+yoovwE//aZ?=
 =?us-ascii?Q?ldPnt3Erk+CK4co8XaM2tK8N35IfsPOU39vSy7o0vWl/ebbBra+xfwunwjS5?=
 =?us-ascii?Q?NH5GS/ZDav3AiEG11WP1/uX/MUBEZhAApdXKho6rAGzomPNyGPMjCGq0jIUk?=
 =?us-ascii?Q?Hp2NMtDAsCkyY9iPFwRat7/PgZF5J67HeuiaPxcNkoyA78k2eli799CgLZxr?=
 =?us-ascii?Q?00wm2nD3O+KuwVoyqngb7qV2KtenPev2QJVPDwpUcQfC/hom0+WQdah5Z5zd?=
 =?us-ascii?Q?TCkJLBTYBZXCWLW95dJGOtaUkEorw+CijKQWvkWDI8X+YkaP3fQY0WJgzJ+b?=
 =?us-ascii?Q?aLtJl0ZltJLqAJajsViJrBAnQ1HhZ+a2PctQ8NCZt/sxnuR6eKyRIOF9YC7N?=
 =?us-ascii?Q?PafbEerFqyWKbL+yfi8NDmHLxu4CpNyQxypKWEFkxV6aoalmyP82XjGacdzF?=
 =?us-ascii?Q?EFqn3Ui+rhYO2b0KtYUZ7L5d8ftbJiR57FD/wbMMTsuTozOBvUmZ/MF976Iq?=
 =?us-ascii?Q?VlWBD6Lv+UFz68pDt6X2K9CoKlbKDcBw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qr1k3ttrR58OkigKRKDat5YMMP9dHr9XEmnntHAsLEW28fziftsXqqJhN/2K?=
 =?us-ascii?Q?+IaK6IlYEDrMSr744arZlQyliiLi/j4VX0GpKGKDguxBVgEBI2k2Vp2DML4g?=
 =?us-ascii?Q?Lt2WmYij7hvj+BFh135V1uE9C9u3OesrxaDj8d2GzdmUt9KjA56j3o5yMgpv?=
 =?us-ascii?Q?Vn+jXwgghvJ/tL6PRYFmAizQHe8wK/uyGA2e8fxaqrn7uQR+UGnsCBHmSYSh?=
 =?us-ascii?Q?n/TwDdGt1w6NPN4bnB2zgqRyl9v/K75nkf1nROv2MBUJLimuuo2X3h/fYV4j?=
 =?us-ascii?Q?P/YatPKoLkM7i918eFiU/+YAYzT18fdCLjVIENGOrIJL9lMZIxQz+oSRuvD5?=
 =?us-ascii?Q?U4Bpcc25SBDr7Owl3GCpzn9q3AmUcFLPdXJ5s4iYd7xkTLJyMCspFBujjVeD?=
 =?us-ascii?Q?NrWjmha9AsiUO1caEDzwUsw0LJIo9cDj6y6l7nDtuw30I/fs5UkFC6LfXCDd?=
 =?us-ascii?Q?kLQ525pqJbQgHJ3QYQ7tFuMTfP2PYpwf3q09OZ9iE/6U11A2bT68Upsg8f+J?=
 =?us-ascii?Q?tYDc4+vphLVyHcAIRUhtdCRYKUP+eP/UAni1OdF5AUCm7aXk995QiIdM0jq6?=
 =?us-ascii?Q?RVjXIyl/qq2K7U66C7tS4lRZ928qDk1fBfJyjXbHlir/QZ2B8Da+QyAureYk?=
 =?us-ascii?Q?OVnO8m9/PQreIB5dbrfbvcYSzm52oelvKQxcKE0fW+2to2pXkj0MszYfpFXx?=
 =?us-ascii?Q?dTkBW2/Omb271rSKnBj1alMCNFuh0O0lzDMrUd/kHYGEldezvxmVbcmgB6on?=
 =?us-ascii?Q?RwFultzONyVXrj+PyC+jGUHR05YWk+SQ/Nm6+AGs3V1ImzYStG6o1Ob1fiTg?=
 =?us-ascii?Q?LNxg9oG3xgWbXHKkQlaodBp/Jm2/bZUTlS32W/bq0fHedZGd9PIVgs9c6vrq?=
 =?us-ascii?Q?8F0YX608TXKVOmYC+XnxjqEb0Hmuizefp+LjGaLu0iJ8V/C/9nAn2CpNDIW5?=
 =?us-ascii?Q?BxIffPfr3+gn0O9B4pwC2V+tVmWWrWB+8HY/WIDPE7oWQ23Ge7aU4VYe5POw?=
 =?us-ascii?Q?Lg3cBtgD9PYu+7DED4N/f0P6S+fP67rJmCiJICJUSz/p8jj3wPpgFJBx6c2J?=
 =?us-ascii?Q?yqHPNWmgbHIr4bYqLt3WCMNnLDvQmfWFMhoo2hzSj8FvSvP+LHXleHV886Dt?=
 =?us-ascii?Q?twZMMk4CYqB63Fhw6XvKObQH6bl9vQm4stFIUY9rN2OGo5P20ogFvtWU8yXE?=
 =?us-ascii?Q?i41YZkdbE3XGpYM+i1wWQ4VthFuohsEC5tGt4qr4alVgcEa0EVM/dHLomHUr?=
 =?us-ascii?Q?NW36mxgXHTIZQX/Fca0jhHgM0JGaAiMQHf3AG4jRntTXIgvZhJKpMXb+lBxO?=
 =?us-ascii?Q?pn4M4ohznZZMJyQDrXDAhwbUWGTAuuBrhA4AwBRHLk0C3xS2i5wvHSnzxm3U?=
 =?us-ascii?Q?0SMINV7KDUoOk6oywbqU9bVjwEYqK7WwcOomg8ADyaeVBWwBw6E9MTn8D2D2?=
 =?us-ascii?Q?fIyAtwipHT5A44kOHVxSYGB3jknbirqWVOJUTfjwa95hiu+1xVy0DwcAZati?=
 =?us-ascii?Q?6SGTNu46D4sGtXOB3Lk17bORD8pAou/wFu6HCWttchRAkPMZLEq9pVNsEImQ?=
 =?us-ascii?Q?vXZeaEhx1VwnaZH5ci1BCuO0GPxuyTAksToK2w9WkyQq64mqTEcWd/rHk6Yz?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WxM6EbSQt0PgUB3ogBVlejovc/exMiWDdRrntdrCPFKng4PnZF5jn6oG7N9l7QHPpRq5qfYK0dthGPz7bPmoSTe1Ap2DcAx8s0Wt1T4TWeHGXo4dyClzyBXafm04z7f4C7YLGkC+tnQgU202JzfNqv6Ew125HvDn/htRKV6r7+/32YPMkYKOLhhbLa3fP7xbjNqtstSY61sHPOSSpZ9G+XgGSHHZd7NvCl/9zVHjkWx3sg5X8PnEB0/ueRJz4owKR8Y9kRmU0gsT55dpsA1+AIZUNC1jvSpWeE5IXOfajuGIZVh78vvXnreltera3SKOrk+Y7+D1d/UWh35YFzmhFIBfBC9BZLQlNYexVQpf4zauure6fhg3hZny0CwYZQ9q0VCqb8ytPIRKzg5ZeMHMYkA98ekZycjAOGatSH6TCTkXn8fjqXC56OY57Dk3h/wbdiamO4vXCTHBsntBJN4xMygFUrM4pjPko6xJvpH/CFwY+/E/JUDLj4IcXKV3gETdXfytHd1DP6bCLJ1mQEl1+iEC1NeGNxN0E5FXkuVVHoitzRMzaWxQv1kCs2MNjLla49A2t0p1lZ56yNuX9ewrSjs1QW5w46xluYitF6hYA2g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66745187-6912-4b22-62fa-08de1eeb5c07
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:22:14.5367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YayywKHL+MswVS+s7x0O5Bk4iGYZenYPgZX7R7ectCKfdnNlDs6XliX554BRYYGCBvwpfpp0tBSM0Fl2i3315NKz8sw/aS4eZ4p2ooFQP78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080140
X-Proofpoint-GUID: BC9U1N-Rwr40oZni1-T1jli1Gs2lxGK_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfXwbqYVFb/xX/R
 +8Np/2LNqkcpMmMo4bKnQ3c0oXMf6443G4Kfj/2IhjlcPzJgS1ZCXdoM8W373PmkPCP4G1E7N+I
 c0V43YKngys8mMHy1OmzfbBjghKXf9FU5a7D92aGDVCxu7x0rUqOsjx9bKA1ropUSw/FGhfiLhu
 mdA94auwMR+7v9hdHSczHBoTX9Goe4CZYJyfTdZOo57UrkKaVpKiz3tPsGVNG1GUxRCulyJMXmJ
 OjW5uVLHsX7Q9qbB6OAVSUT7NESpBCWHGp5RdKBNuSWbozewZaIQPiItxES5WS/Mf1Yryi3MU20
 csx96v2z4Dl3DA7JOcYDZXZIfpGqsdiSWbPbcBdtW/zXpVKiVaEMjI1i1y9gQcKXsCfNYTE67P3
 YL3KM3+SS3jb3Jeghb6zVOsP0esEkORLdudYxu4sZjF2b+sRrrA=
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f7c49 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12097
X-Proofpoint-ORIG-GUID: BC9U1N-Rwr40oZni1-T1jli1Gs2lxGK_


David,

> With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
> some customer tape applications fail from being unable to complete ioctls
> to verify ID information for the device when there has been any type of
> reset event to their tape devices.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
