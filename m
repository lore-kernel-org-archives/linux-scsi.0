Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E507101CA
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2024 02:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098349; cv=fail; b=bcb8JB7dHxJszydJnJnODlp3gNMGzT/PFG5/8ocXBa0revd+s0Zz7eyXy+IcXsD5qk6MAmdqc7QLa7hTN2pTAEwP/MxKu5s9R884z9cP3o1/ci2HZ1fsc5Y5uAynlk1hAWWN7FrhYhnXr4doYO1jzPGBj2pO07sv9kXsrLwLBqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098349; c=relaxed/simple;
	bh=NgNPefur0E74dc1VYsMeOgFSl9u37b0UJVHYlL93S9c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mcqn00jRaA+g6wpaKFGn9BD0tdX6/Uf4pW9UrB7z/pYr5U8UrQT9JBp5/aQdnkQIcIMnTarj0jHbD1yKe94bAZeYUan3NLSSMpbyn5XRaAQgybujyHWJvK9i0XXr8j0xTdZ6AXGKqGYavGuF7Qmdj3TvmUrtJgb0w3qoKlE7Z0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iAhtRcEV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TGvPrqGs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iAhtRcEV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TGvPrqGs"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FLKmw9026816;
	Tue, 16 Jul 2024 02:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=eE8uhrRLo3099h
	MqBeZ26dLN3Vzco0+TICPhs2rHQ9k=; b=iAhtRcEV8eZeYTL2z4L5idXe9Nr9to
	qIkjxTu7CGdszgurH2qM7ghWp8YBhoNpcb8EVTOuJuKTAvHR+r4J/WO4ZcV/1IfE
	BqL7W09I9qjUthw9zsPtA+GJosL1MszfI52WECRen+IMP6PIRkCKO/TuuSK/MWNr
	UfQawY3CytdFw1ZDDo+KsZBmPXAdwAg0Dsw9tVSS6YXIlrFZc/ukbMy7bA37JjuX
	MtBEsIBqUnHcmwsXVM7hWTQRaWKtE8UBmwFb4gAchCA+ZIbULyDlXW6eKy4ZNVUl
	A2v8YaGiv9nje0S/TLvlyp5Aik3EsSxQ068QLDj3sFrt2DRl5t9jBgTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bggb4q05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:52:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G12DGL038942;
	Tue, 16 Jul 2024 02:52:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40bg18u479-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=weZRIxqJLcVfumxNOqHEOPNsCxXNIQQfZDK1PeKyQ5B41anZFVGnF5d4Y1VzpnHVqkB4zAP0jEgOIhO/AzJ/jC9c0/MgyQ3zyJI88gI4X35FBBIA5tNVgsmTMSlUPeGxNFXJ1ZwWncsP0MZ8KvILUH016hFaHHUrKPrdyWFXx7eBqzCAAte/tnBJGhcdFHR17NvQpjS+j05b0h/Zt4fvxuDs6fz72IboxFmLDNtFnMvMTzFNTqN91hhirz0QaFUmG/ejwW8DZVRCnS3qmGrwF+wJ00v7LHPmQiLEl0/MdlOmO5V7/KvmW8sdOWYBUQXSGjjQ/6I4W1sSsDPfjOWIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE8uhrRLo3099hMqBeZ26dLN3Vzco0+TICPhs2rHQ9k=;
 b=tpCg/LR6/O6tzDTocFIjYl3qPzFxp8ZoYxpYp7TbHvhzYDZG1w56tAwFguwRWlQSddisRZi2MXgmcyhEOgHRhPHjcjEK6qp8vOhq2OSoHMa2EUkh3fYUmo26gMzWDGXTIWUchbPrFqSuVRQiR0Fz3Dtok+5XWYDCAwRudCLMAha0SUtmvSNREy5kkg561K6qoVhs3jDqPaA93vnbnoTWGLIyVCZgfrUY7CYT8zMP2LzNSmscs0dPwVSoBTEyEdeDw8sUY8X4BuPvSHeEFdcnYhc+bnbTuD7IzoQSugyWrWSGYmXQjU6LZpb9utEsj8lpvtLvF3Bypne82vg+hGb+Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE8uhrRLo3099hMqBeZ26dLN3Vzco0+TICPhs2rHQ9k=;
 b=TGvPrqGsDbxppLJf/pOuTdalPAv32iwpRs5uomdZWC55FmCL+QEyxcBAosiS8bhKpMfrct5EYuoVPG5UnA1yAnxXDhC3MEasVUNt+Nn/bo4Cc2txZ5YdApd47MAS+fVT6aArJ02eAHjUd+1LOOYFmk9S3drhKDBBT+SBJ00l5F4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7866.namprd10.prod.outlook.com (2603:10b6:408:1bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 02:52:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:52:12 +0000
To: Kyoungrul Kim <k831.kim@samsung.com>
Cc: "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "Ed.Tsai@mediatek.com" <Ed.Tsai@mediatek.com>,
        Minwoo Im
 <minwoo.im@samsung.com>,
        "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V4] scsi: ufs: core: Check LSDBS cap when !mcq
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
	(Kyoungrul Kim's message of "Wed, 10 Jul 2024 08:25:20 +0900")
Organization: Oracle Corporation
Message-ID: <yq11q3ukq0g.fsf@ca-mkp.ca.oracle.com>
References: <CGME20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
	<20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
Date: Mon, 15 Jul 2024 22:52:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:a03:80::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: ee80e4fe-b0eb-4da2-f295-08dca5424aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?lWNNMmiDPoPUwtcLJeUAbMOKXgqGurR6QUazzvFJQa9VDVf6PvZbDEF/Nlpg?=
 =?us-ascii?Q?mpOmf77agjLBBm8Gjd7aQZkAXwX4jcF+tv3X4bVpz4EkxgC6pZKz5zOUC0by?=
 =?us-ascii?Q?FOKn+9NyJ3uFpsJS7wPDOPj49Uw+7Ds4gPbdzS5/lC8UkdZe02MRhFnuaMnx?=
 =?us-ascii?Q?64nPBC/MSOlkXkpRN0/onyoxV2713NBUYFy8KT7sYt/S2CGDC6h8sTLUD0ej?=
 =?us-ascii?Q?V4rc9viE7iuXymgALgbD2fk1KT3yxl/FoaOQ3Yo3uOVlYui9HFcSReRNH3Ee?=
 =?us-ascii?Q?PKE1g9jxntzxJqIGB9t0cXhv4n6jjfnP/9XBH81tPZFU4JV8H9vrU2qcskH3?=
 =?us-ascii?Q?rPeDTKclglfe+Pi8gn19K5nnA/LHH/K175RNfhc+qWSaQCXD0u/WcSYK49iq?=
 =?us-ascii?Q?t060DHhDCo6bV/eSKmX8A0qX7yuP0ntvN6L3+S+ZUTNyk2HrQvVa4wOO+c5v?=
 =?us-ascii?Q?RAoOlaRkaDfdno/V7cwPHB9MluOGJSecCrhs6i1Ow9z4+QB+wPe+taFVnzOA?=
 =?us-ascii?Q?qnFtWM7SgUchdjrfMgzzTA7RkvgGbh/HYvvaRKmuIqdzjMSiCv3R0QZ92o6b?=
 =?us-ascii?Q?oKxkTEUcr9/jpoaxoOJHfuh1mhPpbeWlPVnEvR7PDEddDWYQeYXgDkuQpP4P?=
 =?us-ascii?Q?FwbtDUpp5FYnUjUumQJ72emKJ9b5yg573PJqPGOSTHCaW3gU0ny2ID+qL0lT?=
 =?us-ascii?Q?0ewP0GEciv/N8dHUoB5dwsvqXVFv1haPbKX4f5Gq6460IICAgrFMlLSlSMqw?=
 =?us-ascii?Q?6/G52DB6xJ8Q9feJyGDAo2CplJqv/rVkEsUIbrnGHT5QMfTKkprTbpprVa3l?=
 =?us-ascii?Q?urrAsoa1DuI6usPXJiKkA8xx1DMWaHUuQUbFRX0VubK0HX3nSdl3VLp/To4W?=
 =?us-ascii?Q?uHiRA+YuaypMHiAnRlby7PJ6KZBjWfpDhNhW68ceMk3BrTXKFIIUDmA1joit?=
 =?us-ascii?Q?n9LiAlkc9DNC3eWGmV8T3ChhSVPKhgS9JvGTD+yf16RjAvuSW+NmjutHB55+?=
 =?us-ascii?Q?qZ+EN4HKGUCp98FJFlEfPSsn1iXSSkXnBwm8u4QRr164ILPH84LeoVHafajM?=
 =?us-ascii?Q?gtIVYfOEzhyNwp2El94GRhx1O+J9ixw3mRwQwCxRFjv9Mr2NKApZb2mEe46I?=
 =?us-ascii?Q?jQbL7jVZwKAAj90wR9fNczv0cUDg9Bfx3a8hhDdFeOJbHFjpMrmETDP61TJn?=
 =?us-ascii?Q?JTGtLm8nUSBL+GtUC4CMR6POgKChdnXnde5xUDbiNssAucGfMNuW+j6Mxd8W?=
 =?us-ascii?Q?zro+fYlJq6Y6OzhE5t0scH4b+KHRfTcGc2qqSxRCqJ9pn1j0Jcv57Q0dxnT/?=
 =?us-ascii?Q?JS7r2WPCLDRH8Z9wpBy4C+SKbc8wqSRFp8yRCjGmqWB7qw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XWaxYyWrTwrSuy4tWLd6k5B9+7DiYLQYyeo+Lj3N/72sOGlyFLwYyzHfph/1?=
 =?us-ascii?Q?ZznAtUlkfPW1E2/9lUe1itB0GVEF2E+1YeKiJEBER/6S//Wk/OI9gy9PUaB8?=
 =?us-ascii?Q?+5ZqZhYDJ4FZxpw68kifkG9mvQ1KLLqUFEt1egK9LG3wRv/3gHHgPIo0h0eS?=
 =?us-ascii?Q?e4UN3eKMLYkk6NAkRQYvtPlHXyhmA36kPF92WsZEZ4yc+XLB9cm7Pkcmnpm/?=
 =?us-ascii?Q?h1aN41pvCWjiV9xYcc5QsGRevCu0kIVynQNMVWrQ7sAnTZYPlRDPtzOv+ucv?=
 =?us-ascii?Q?v3gxMdKvmyA6X1OYD4ulTltHJ9YS5wV1o5ykX3yDv02BOVwC6/PEM1eMMogV?=
 =?us-ascii?Q?FPFAzry+Dm6Ba7ewnIJPiUYIgtO2mE0A2uMfSy+YQ7ATwQqEmRgD3uJ7g44i?=
 =?us-ascii?Q?s0+HQYOQI/JHUIKw++/yrChSCNk22pFNydmmZBD0o3SNbnxQtDCOFW5G3td/?=
 =?us-ascii?Q?KjDt5USunMMVIsnuZR2EtWTQ9mLjQfaLMe5s6yYXiSjZ1V4+JvvaZs1OTr83?=
 =?us-ascii?Q?dcT5gy3FfWsyCg8hPch+q5hMy1z4H1DlyVxxs/05lB5XlVekkj6nR82aCjRK?=
 =?us-ascii?Q?XXZKe8CXhxyH3y3dtNxVWgLroOsmlJeUKEbwWvwvGSvRduKPZL+0zIlcq64r?=
 =?us-ascii?Q?dOED9gHRIEYaPZFopKa0QhC7y6inChfOkUJtDPxGVc7q4eyPCWTI1kHWxOrT?=
 =?us-ascii?Q?Ov90cquKK34Rb0kqNbwuIpGpplQ+VealO6DMReHOl9M27uAW6zCYMfFD3ooZ?=
 =?us-ascii?Q?m2KoerXXUHfh+XcvHT0h3v7gk0aBpJY2XPui8n9CcBDFyIUjwcn3veSV1gw/?=
 =?us-ascii?Q?LJmWsLE2DxM0vLrOIe+eWOc9r0xanfrpJVi+S/Dfga4iQa0qcEuBhgx9MB0v?=
 =?us-ascii?Q?+zN0gYLdQKFpH2HkK19eaQsYQkD9K4ji19FtThajelP7XOgFa7exzLGlMq7y?=
 =?us-ascii?Q?jPFBOjsr8gYXQPFhKczs22LyfavtfJtxdjdYYa0sBYlCD3ZrbraA6bj+xtRE?=
 =?us-ascii?Q?eWswRPzJfomd5CG4YVlXKoQX2kvrOxRI9Jw2iXXzreDo8IoFAuEhFjb6UxWG?=
 =?us-ascii?Q?v3VY/w8FLM1+gft2hbzzzP8qv+wyuEUovdvseRacQ6vzhFriQt8MGxYVHyUJ?=
 =?us-ascii?Q?paIPjm+RK6UAS1OJT18wSjWpBQ94LvHf58c2djo2pmaDmh3FTvh6P2sEaown?=
 =?us-ascii?Q?IysvJIdibb692yHIqERiHfg9YrLMq5IDi1h+cqBpzAvF8mb57EPJCx//7pmU?=
 =?us-ascii?Q?UxK3q0FPIz5Tx1zNi29wYJTfC/uFJeshyROLFCjfLh4b5Jdn+Lxq7YBVPNdH?=
 =?us-ascii?Q?EwDM61fhZln5XRncDclQK10WUTuTP35yRC8r0SacjhULoShKwIdISowrUfgH?=
 =?us-ascii?Q?A+wYybMczfUznzQ3Ez7g5QYgZfUJiAqTqZDOIP/EXnalnvWCgG1xikH5L6J4?=
 =?us-ascii?Q?MQt9BVCFr964OypakfahtpMcN/9Qx0jCQr5f4TGAgSJl0HNvfxFYZYdR3Gbj?=
 =?us-ascii?Q?JWARVqJ0b8lCNJxqxsc568hz1r+P/NFuPjAClnQtUXDG9w0EwHHaQPHJV5N5?=
 =?us-ascii?Q?9+B7OQzDxeEjqnNW4AvUgXiC8l0b/vRzkykD1jq0R1x4eDw30FDq5ZGBo5Ut?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	l5ieP/Eq6HoDPJta82Zku3pxPovHPznYNMld7hizuoCWOajoHmkzoVa3jtTaH6NK27Vmx6+B74BhKyrZBcegJCvJM8FNJovFLFXPIcTFuA9filzIAPBlzJ5JSVgv/aODpuUtBJCoWd1cSZKYa2TLV+jZofMtyKUNLI++NX3MgqVdbY+XO4eMXozEUJuBxwsmeGKIyCJXN8M6tK/EXIQDrVO/L29X1nhNtScikj4U4aJ3YMy4PSAw19UF7ezBZFuU+RKsJ60W6l/AkXq+5c21gDESg1Fb2ANTgL+o/yH2Na8SC+8VQQsgy+I/I9GxIsFULEpyWehjm3qg0xqvNChsNhfVVl0IJXdPBUldimX+wSqSbBO6BL1n1ANHOg0/DfKX/Mmk0t7m5md1vr5htZkF+LLCsweT+n24JGqQ6I6aEoJI2xyzZXFq/UdAdENUlmqc/NWbxC0BZMWygwiw8j6Hbhfh0ctBjvv1LOt55v50H0NpCt9taonWyBB5F3uJ3BtNBJPE8tFBTcO0OSbCps3gKSyTnfDQtmvwBeXAkDpyQEnsGBfJVjt4rk6kLkWsUOT+drsSBcqSvWtwKMTbp7Y0+T1l43bOoX4aexy6fPCrvw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee80e4fe-b0eb-4da2-f295-08dca5424aa9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 02:52:11.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K06FU23gIJscGWgWtBzcP00piIv9TJQQ7q7zKNkzdDWkZCvnHlitfa9z++7fM+2mUvbX5w0/wwcR3s1fzp3EScE4UbMS4JU2fH9XJZD/T9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=817 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407160021
X-Proofpoint-GUID: _UCEr8rUdfyUhJnTJN1Ae9mEBFovGCUm
X-Proofpoint-ORIG-GUID: _UCEr8rUdfyUhJnTJN1Ae9mEBFovGCUm


Kyoungrul,

> if the user sets use_mcq_mode to 0, the host will try to activate the
> lsdb mode unconditionally even when the lsdbs of device hci cap is 1.
> so it makes timeout cmds and fail to device probing.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
