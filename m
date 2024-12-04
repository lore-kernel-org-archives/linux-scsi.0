Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4851C3C04;
	Wed,  4 Dec 2024 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733341928; cv=fail; b=WqQORjJ77QJ9y1q4Ryt+IfsIM6QYzoalIQdGUbnFI174qoi1r1ECpafO6+YK0E6bI4CdRJfub4Oz50yatQ7RmRg94qF3hebaHMOWELQkNhVaaT14Q3WF9HiwZ2xGaFcyLZInNlqmOlb4HPKtrAEMs0FR1mm3a/YIROuwreknobI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733341928; c=relaxed/simple;
	bh=OFZLct7btsucxhLr7eNDP2fLEd8E/ka9hggXRPV2X0A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Do7ncoohDeORBdfWsK6XvdRsaJwvpDyN5csvb0SCxWhyJeCWNhfLoYyLZHVqqlME+krwMOXW3LjJfejcBntcxPFWhrGdmN64iEA9D0XGF52fUHxjpSFJ2DYIIyNmmPkvjcygqFkfzZYOIVTZcdvAgnPIOfIB3CmpzsrfbR8rrd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WLkLc6tM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P6PxQZbv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WLkLc6tM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P6PxQZbv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4IuRsI018380;
	Wed, 4 Dec 2024 19:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=uBVGtKVzXcQaPsQqpJ
	LXdX3CwgqgovkyGEBUjVUAN50=; b=WLkLc6tMU9ooe07KBPE27tKyqbbP5jkqXy
	bLF0E2ELDtLUYVxzviFYY3MDrl2Dh3MmjbZs4QphC+Nh+DrydOGiAgksoRvOpO6G
	m8FdHmLZZ3TNQ8jZLUnaMd5rKapoDm+j4DrLTgnhAylIsCFAQdStJvhf1nCjMq0V
	L1XbRWbGgweklwQ480BpCZkpQ3VzwRci3qdPb/ZZBFM5UoRQGOy7sS3y9hh/zpz+
	9CQZEpSRZkPtrAsSmYCLJBt4e1wrekc2HYfz7sWzPky5Bp8xOjnBKJJfsRzR0cnW
	YlK4QfdlnidYC1XiefUtE9ySPilyT73yn1iCfHcEmOWKGYy/K4Eg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c994a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:52:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4JZMeQ001352;
	Wed, 4 Dec 2024 19:52:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59wyp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:52:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxHwzC8hB3KQoTJpLFEFHUbL3FFCv9xMfuPGy4tIPB06lYX3zx54dMXA+QufXbVyH3qQYB9WLfQ0qqsSm04RTUS4PmsHX+8BymmBkIumIaR41Aoe3TirUYm7RfzXlCoLymEIv1zREAjFpIXWmbEbxWGteTuBNaWfpWW+G7BDosI7NXSr1SjVxTOABOQcLbNOSI+2qlFnbM1oLqeqe42+TNcGcPxTzWFEri/DKoClYsJEs5snboinjmfsI0W6glf8QsHp5N2GEfjT2YOzO3yjeWAsmgsMYY9OWQD/EByCaSCiwPpWeneRtC/xgn8C7ZpFranTcwqcxHknWDa4LWrUtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBVGtKVzXcQaPsQqpJLXdX3CwgqgovkyGEBUjVUAN50=;
 b=sQpJRyL+HVDwexjxZ3ycFAjkgEVagJBno6mUenwoIi5DWtNXbPHRyz7zhYx+XXgLogDWxEr4OquEw446ZEgy2mZrU+7YUP+IQUahO5Sgyb/4JGTyUaHsUM8afNjA9RZZuIMA0hpGn2hjyyVCqepLnPsr1tFyvcaqybXrjQP7FIfqKoknh8vKSu1zKqrgCKftNfGXgopzu/ptIcnXugX74R2nP1ex3asreHSVFySSPbPgimstijtOe+u10YiUu0INKuy5WBwzx8DN+P6Y7RcFkUwMXvMxDb9/jIOfzBPVAnpj64nzB+RmCwHvMl7sxZFwmpF3dxeITdSz57j77JUmAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBVGtKVzXcQaPsQqpJLXdX3CwgqgovkyGEBUjVUAN50=;
 b=P6PxQZbv20qeTtlKxKgNRddlzXyMYQD7YbiSga3hKx6NTodnOiiUK6+KPd3et2/zNd4dbhiGQhtTamDqR53dxKoh+3TCQJYkcsEpR1D0zfDMeyCt9/OrRNnZ3p4f37WXswXi+otIAbZ+G0WA2VkCp0f83WekYeBxSE06F+pYePM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5153.namprd10.prod.outlook.com (2603:10b6:208:330::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Wed, 4 Dec
 2024 19:51:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 19:51:56 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Increase reserved tags from 8 to 128
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241126224923.973528-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Tue, 26 Nov 2024 22:49:23 +0000")
Organization: Oracle Corporation
Message-ID: <yq14j3jql9t.fsf@ca-mkp.ca.oracle.com>
References: <20241126224923.973528-1-salomondush@google.com>
Date: Wed, 04 Dec 2024 14:51:53 -0500
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0095.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: c2944b8b-a409-48a7-57ed-08dd149d1bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9b1kFM6sLrTY0vASUU3Xu4w8Cwqn6Y9xwGCozxvv9QysyMu4DWTuIpR2Sz+C?=
 =?us-ascii?Q?aK+ejy+7EJBWloDQFGywJJzLgz/AtQG61YUV4chEKGMpgAWrqkNrtyjwBQMo?=
 =?us-ascii?Q?0fTJhhRfV1WFK+Fg/aP/1705oWArhNfTIW22P3lA6SNjOzFWMCigyPg5Iuul?=
 =?us-ascii?Q?jd00JdQ4gt6BW4cwFeFPbWGOI30lOfU4aI7OjzcapDVjBD+RuBV1bEvVrmpe?=
 =?us-ascii?Q?WUg/IuvRzIaFeL37MItIImoGAosd/Cmcb1pZ9QdoV7jqApR90GGuc0ATRdd7?=
 =?us-ascii?Q?an2NAD82acEBMC4nySDnyfARiaX3s+48luX7qXBFsp4YDZuBcdZOobUhZDzZ?=
 =?us-ascii?Q?5QMZukDDPvQMRK/KVpYlmT3CEQ666wyflRiW0HQMvO4epzX2zhvhLCgPSNSi?=
 =?us-ascii?Q?905dHDOOpUg57B0SkaGLnMxmYZXdDtCLYDCfh+Lx1cetfBuwjCMwjp5zpXmf?=
 =?us-ascii?Q?JRwMdUswXXUZpCqNhh/lYupMoOKaRmtRMNA85LCkaktPo41ticCQnBPxmlGd?=
 =?us-ascii?Q?x0Civ0nnXSRmYpMmz3XcblcYwPVcVYLA7+Nr7EL4CgjSQ8mP5ZMTy491WuMJ?=
 =?us-ascii?Q?3bGI+YjcHyC5O3vsIpWdI/98F99yo2UVihOviuPqmW0/L+SKVXZM9DEziwVT?=
 =?us-ascii?Q?IcqCRA6LLjvJ2dh3ecA5L/tT+99ciE2Odxr793FQQycWCZidG/E9JfCUUvW0?=
 =?us-ascii?Q?8it99KqS6Un/X4J9axrSSe1mbT6a7W6i5IuwAgV/8bNmfDCsWZnJHr8ei5a2?=
 =?us-ascii?Q?PfNO212OhdD3pbmVUN7qQ1puPnkOKi9c0ADVp9TuRyG9n2jMY8K1xr/tzekv?=
 =?us-ascii?Q?eU993KvHSY/dZuLhn5dHtd67eI2KXDLQm4R7A8sDn6Y3Jq7CEOYrZE1uzlPV?=
 =?us-ascii?Q?d9QVH9+IV3kFfTPYRsLi0U3s8Y+o6E62B5Dp+kcIwvpOptRMGwUBnBNpzP4k?=
 =?us-ascii?Q?cymqdD2dIZFd0LHyENVAbwaDjBA6nkXPEkWlP99sc4CjhpUDNe9RT1PknL8c?=
 =?us-ascii?Q?l94xCzBnrSMvIXRN44uc45969ATm6B65tayn07ywMpmKQXg/ugqeRVIbcspv?=
 =?us-ascii?Q?Mu1MYa0DEIrojcm9Izc7aksn94LrfcrEJmSra4OIB3RkbufQMg4NS2dwo1D/?=
 =?us-ascii?Q?Zl/luf8DdAOXUKe74+z7D5HffWP9cK8J0u2ZqkgYDnt8Xuc5wqzEVSEU8dAW?=
 =?us-ascii?Q?k4o5SnB8fovZwHOqG0dBTTlkDScyHt07znHhg+FtQvgz8CEhFhV+qu0BA6SX?=
 =?us-ascii?Q?NOursSC2XbOnC7iNMknSCL7eYDmNE1jzT8lOs7i2/wSCKZZKf/K+bVXYJsNk?=
 =?us-ascii?Q?4bnLvEla1ox8XMm5Xo0Yvc1BXB926bzCcTexSKZRttYoag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dh288wM3stwTDlowOirXgYQJy8s1SUgxa5WehjeuxUGoSww5/DVF3dhD4oiI?=
 =?us-ascii?Q?WXq+GA2I2VX/Iky2vCAx7W32B3eE+xSR0D/Fj3Cl9zgt1K/4VBUq20Y5xcTO?=
 =?us-ascii?Q?cRBRaMEqwVovIkc1U47FdkKrbNg/m6NtFWe0GTooxGFh/dOUuz7WioNdkmRB?=
 =?us-ascii?Q?b3BJzwNg9B9tnFx8lTfTn89l1XUkReKjZUUih9TP82TVW/rX6xCYd7PQJz/X?=
 =?us-ascii?Q?39kDKFmC/0puTCTqVuriIlSTEvbxA92Xa4kx4aJ0ag98LC+oXdAnGt5Rf2ZC?=
 =?us-ascii?Q?MfVbXP7Zk5//jMANPg8mtBWFTYYMhjhjB47WZuvW4IOgeHiXi8R7mym27gA+?=
 =?us-ascii?Q?CKXfJkCtd7FTHfvjAKOkPruikVktOjkbcp5EzRLBiLzvvqlVatHk0qqEFy6l?=
 =?us-ascii?Q?wcpYUt0y5uUaoZBxNC4m122MkT0Iljh3R7rdu2YZ4bNJD/OER5nEWDiWWWdl?=
 =?us-ascii?Q?RibiuKhK81vs3YW9gHsJRgi1IyxeUBAvIU3JL3RPNyqZrFJatqjmX5WhTuJg?=
 =?us-ascii?Q?7Iv46YiTOL++cuGAgmJ4Sgz2YiiDOEIYgdKKoFmVZHR4bb2xG9UATdiuwnVm?=
 =?us-ascii?Q?8N8GmWdAc446QVeyO3q7djLIC2rAjL+GUBrrWxU57qV7rduXBJRrs3bGcjHr?=
 =?us-ascii?Q?wtUNn9giiJtExy5YrUsUC8Q5AwbI6jW5bw2vpWZjPJk0uwBWxgK52bJEcTvQ?=
 =?us-ascii?Q?0PdR0G0Ti6XDqHHFZ984Yo1FLMc+2THeC8e8TbiLdgpei/Vcwl+2iBb4Aumn?=
 =?us-ascii?Q?R/MwjaawCxFGFkcRSfIM+e2XpI3KXiDD5OFiPnD4LZUQ+JNz+pIFM2H8+QyR?=
 =?us-ascii?Q?dg9C4LIoFc/iVHzyv/bzZ289JxhVFBnmRJluA0D34dkcNlJI5PZTytKnmUYT?=
 =?us-ascii?Q?hGJr/+tl3jJZwEudpE1AWJvVnWccnEc8wZVoeRFE2V/26nVVeuvl0w3Twjbh?=
 =?us-ascii?Q?XTYne7HEAFqGKSM7v0mW8i1msdXTOCkzw5gJefY5i2P4QRLVZFGjIYsBcIMm?=
 =?us-ascii?Q?1FkyObnKpBfcsPnBACuzcOMhIwEawwM/Amo3F8p7DgsX0ukTDwdDl93mFHCO?=
 =?us-ascii?Q?aGwmn5d2Z0uQR+39ypDEVNy5U+HFXNWgLbXVOu9BisAeB1eYwgh7K1JiUJLh?=
 =?us-ascii?Q?zYOpeU58zmsHCbIXlVuhujXMYfjgwB08HrvGwJ6szmtikSH/Nimvw8ebO0gX?=
 =?us-ascii?Q?SDrNX1GuPDrk8+nubMKyh8PzCp0f2LAEkkQZOkdVxlBh/6Hy/I4pyn/M7R9w?=
 =?us-ascii?Q?KdEaruz5IIGcOR3wU12FNZx7duzH7OgntsWnCG+pwH5F6F9fVBH+tDDVLATX?=
 =?us-ascii?Q?3ATtNEFTHuQop2Wq9JdRJFwngofKr5G4T5VcfRm/FXoOR8poqOzZXR8E2mH3?=
 =?us-ascii?Q?bLthQKAitytY/xg2ImoAUh9VeftYAlxxkBBtK/o5xTHrTQ1qPvoevuzs32yX?=
 =?us-ascii?Q?wIuaYHthya/KescjW+rJ8YUFkMyndeU6Vml557pa8xPuiBb7kzV9xfUaHnyx?=
 =?us-ascii?Q?boAdELTstioZmEuAW88mzuO3c2mCl5ZpE/4LSL11VUiRznIl3/H55RPiHykT?=
 =?us-ascii?Q?fQLS8C4T96moxfeGD+QW5pI6VNABX5MhS+74tC3jogJnV0in4YnutUnVF0AK?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KFhRS0WF1oDmxszQbIuTYgmvIdACOELBXq81oX3dtsw7bhpnGFvwkLgYL/h4vKA0ycTwL48CR0B/bzP+kOqiyUw5yIVGsQ3NwKLDmBA3pXaJ09YkYIO2iVZLpCIFVLo9WUn1uVy7Iq3UtNAQxU+Gt8xj8c/RFx1JWP8jWm5hy6xeP3gJRP1K+5kEGsHltXWLdjarMj6AWmXx7uMo0m4x+i3yu8r9/Vu9oi948u9BDoq2lLGT0LdXldf+47c+3ePUxQYfIqRinwtQuuUvlWE0qbmT5eVWNivwFxuAJUV/uyZ8dVNAQhRUYTMS6+llvcXbTNEhX2cr88ziT02UWi50HqNaQnvvIPwynzxrr1o1a8rIP///IA9ltkgef/N+TbwIjUw5jB6yTudrW24J9InTskS8ebAh6h9EfeCK+xqJ8czxDpWutw86WPI9kXvUQXn9xHtyc7pKYml0eShuo//mTDI0On57qVmGECvvmpswlGG48UUl71NcpQVvjdW96NgbdSQwTm+FeSZwxUO7IxOC7Svd4B9YJ1a8Sw7uyB4qD8d3bRgQCLftTCz2flG1jXELrJRE/dvb/TCJfZhwzi9e2WqQiV0yn1cugp2I6XJmMew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2944b8b-a409-48a7-57ed-08dd149d1bb5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 19:51:56.5193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/S2p3xARVIfipDhyIxytWhRzZQsvvGz60Aggt/4Dl5llbilG9CrbWTdKY3sfevl0ESlpdsRGX9h+laF8/1mVgpOz/2HpXg7ImTGfbj9tnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_16,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=674
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040151
X-Proofpoint-ORIG-GUID: KhgqGoyagRsQkXI19GauIqSWpDhLo-Ph
X-Proofpoint-GUID: KhgqGoyagRsQkXI19GauIqSWpDhLo-Ph


Salomon,

> Increase the number of reserved tags to prevent command processing
> failures when the driver is under stress. 8 reserved tags are quickly
> getting all used up leading to errors when command completions are
> delayed.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
