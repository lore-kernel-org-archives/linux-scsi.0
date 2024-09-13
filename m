Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CE0FC12;
	Fri, 13 Sep 2024 01:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192489; cv=fail; b=EefedepF+0XXK6eSV7XkBj8IIlU8eqRd3OZXlMThACYjDAxhm5nOFT04eWxNO3dawdMzXOA45kJdJtH+V+/3Gmhs/Jin9kXnVnCH/e+li8RJ/VBq2X0/jhv+Xrd3YhmTpifoEfbQtGv6Vup50eFCQ5WY2l0CSqqm73m8zXq30Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192489; c=relaxed/simple;
	bh=PSbSl4alLt8gHbDF7RcNgG16sHGoQuzxT3fbB3r3kgw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k/HZq9uMLxmo1kC/rmo4JGFAt0NzHUCAA3vcz8jImjshUC7YcpCX3FSyQtrSK96RbW8jEJp6IdexkdQXMFU6bTqe2qldq/rMKpkP2V8CWIRbkd8vfQ/+tdaGkrVNjyvGv8W4RrkoCsHV84nox3uJHIHI7ma2+NSmZLDezVWiNhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SwfYZbIw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AEdXYDiW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SwfYZbIw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AEdXYDiW"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYd4023301;
	Fri, 13 Sep 2024 01:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Zi12HLVTxPqQ2C
	foGGHjo01JOqmJCD1ZSiO9lDtWLWE=; b=SwfYZbIwHET597S/V3NluuVawLMasH
	lLsbsts4DKypX5UsHkXKWuhu/9sWe/GwOIRWqibiUX08mP4+iinur8qig38zsmgS
	z7r2le0FeNVjVjHegoRMwA4u14/37Vv3Tx7I1QzhFEF5en2xefhESiKQiwmNoDWM
	isMiJ+4Lz/UGLHKoLJgBIqI/vNCO0f6LhE9881rWzhbEQbKtYwJVJRGdmqLnsCqB
	pl/yA84fnjRcAAEnOfMS0K7wasRarndXj/tAk+Gi3hHVOJt0shCmiOwzxE20VzX9
	YKQxNGdTlhuqv9tzYUH2gDmOGkFYHm766+kN1Du/GiiASNTeLBnDS+qg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d453k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:54:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D1b13e033008;
	Fri, 13 Sep 2024 01:54:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jcfm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iBUeZ0x/57M0CX2EFmELhF3nrRQP0YAJjCT0+PYBGVSBjt7u8f9kBRb+WwFiXjUbpQbcpQ18PYLf+TEZjJM416SSfNhpdwMySyW1GSZZHGlm5nm1V5SpuMK7DWwBgis79KOvfeBnriTAgQPzb+rHT30hMuuOtRvmJmFM2uCu+UYKnJR5A+CohAuJnc5v/W3JdAjhzt02nE+WM2vMBIw94tL8NUZddbpurBm5PB8mCqeTWe2SgFr/BWWcWKqaqzh9lj+7vvLWDCtWAnKdZKyAgORdUOWpHMHaYsmCMueBkTiuFZ55Qu8L18Tz9NkNm/PpQKGeWwcwCSwip0o50x2G0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zi12HLVTxPqQ2CfoGGHjo01JOqmJCD1ZSiO9lDtWLWE=;
 b=wKO+UkCx1dfc38OyUkODOVGv5QJ7bEDCemPSE4UvOwb2lq3bciRSgtV+WNwhPYq5sbksaVkNBNtXGr10351uWOy4gqhpHydZwfyRlvhfnhtmrb7+K/3MzgdVtXNiR0Yo5YF1pi+UahARP4mFVFV9PK1I0NktLk7/ivnC8Ni+NcUTIt00qQlQ0gqCIVzvQtznvtkArs7xvmfMJ5IZcpI8Rd4NFUDBQwI9HP/1PH9wGPqdj8sJFoTjBx0ddZEQXV5v2y5EYvn1QAu54uorRezRCV6DpBYKDX/uT0PWQpoJEKXfl5oFkZ7E5EcCNY7viIUBwMFSVtQgZ3anGz28ru6pew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zi12HLVTxPqQ2CfoGGHjo01JOqmJCD1ZSiO9lDtWLWE=;
 b=AEdXYDiWRwbkrT+9ozuHQxZfctHvenPRADaLv9zOBAxLbIAfkbyQF6nxKICCLDqhZbinGvBfFl2XjVKflE308OjmFeu+OJqtvxqtiXXH3e0L9O1wrAPvHzn8OPcDNgML79PPeGtUd7497JnpZGVYLo8Di7TyHZV6vOOICCUus8g=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 01:54:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:54:34 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 09/10] block: unexport blk_rq_count_integrity_sg
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-10-kbusch@meta.com> (Keith Busch's
	message of "Wed, 11 Sep 2024 13:12:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ldzwtj1u.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-10-kbusch@meta.com>
Date: Thu, 12 Sep 2024 21:54:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:208:23b::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: d0cf3411-3a4b-4b88-f124-08dcd39703e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ixMuoihYoSOT2HX4vJASAGe7g0h0DphE38zHr6mFKB+37+951FY0fOfllNY?=
 =?us-ascii?Q?02lpTU74QXlHWosdkjMgly7EV3ynOMAXY0d55uvflQkQnEU1gsa53gfkS3QB?=
 =?us-ascii?Q?CmF9vZxNVSX3WDCvONW6VGh43OH6AaGY9buFjMRrkFE/FzjCPhH5QKikoY5s?=
 =?us-ascii?Q?wDgu9gvBqSz/f41oqMhgKZnTuTZ0khcNR9crnx+Mn9fnaKJjSD7HOJ2730Le?=
 =?us-ascii?Q?XeKuQRiWdszt9GSlmtnZChRRUBH10K2whCs27XGkNHSw7VLb+BTlesW3MrsZ?=
 =?us-ascii?Q?nsEXUT/rr33HcVcpbdaD4LYj9a7aizqdYySU7/ZEU2/skH8ThkixZ83Ig72R?=
 =?us-ascii?Q?31KTtIlL+wJ2lehITnFHLskLWezYYssWwEIWxALVtDdPr0sd6/HJaCJg/nO2?=
 =?us-ascii?Q?fVnkHReOzLstKlZAtdXk/KpYv8offv/phAGwF3+jDR5tFqSbBee44r/gqGuW?=
 =?us-ascii?Q?D4H8t3h25zcwdmXb3kJUbCGTZI3iRTw53nDjq4bcmcSUWRmVYxPjAQWT+D7Z?=
 =?us-ascii?Q?EkzlgaMAXW55x+xsSzphiZDRBYpr6644cjrvKbc2QVOf/r//sfFpYcN2keIJ?=
 =?us-ascii?Q?t1KgUVMPIb0zaIYA6ESGyJndre2+ZkblFIlzhy8hL5W3vWwQyDTVsDA1HEK7?=
 =?us-ascii?Q?z8XdNVbaR/jxaEl4tLGR62/5YmT68sxO/rNoMk6/hH3eZB2TPbkfuDKBXfRc?=
 =?us-ascii?Q?Wht6R3aXdjGr4KN3KBg63yxvtesaz3GbtnaWCj13k8f2CVloEUMplAMNaqFc?=
 =?us-ascii?Q?PCYLzEnEhE5pbWzqVH8do69Q8RX4JG3LyX4JixiaEcl6hNRKlQrxQwb0pRcn?=
 =?us-ascii?Q?VFOchc+t/2XJPZNjJJri86tC7iJuUXFoi9HTug1jdn4kbkDAMUr2+ZkbdICG?=
 =?us-ascii?Q?jp4CixN7BUUfdTBM3MjC90V/9o40ZJrtnRBL97a8oJWq9/fZxa11clmxtEO7?=
 =?us-ascii?Q?XlgZdP5CvEw/kGoJT4ogeCTHOiuHEBeOfsjJ0IKQY+JgM/y3ZUjbM+QuYtiY?=
 =?us-ascii?Q?c0gOBgDXy5VPJoNGjOohewOfBrpXZ3OJj+W6EnYheAXVs0ANRxUlPScghaNF?=
 =?us-ascii?Q?MSrcqrgvZOLfb6LOJnPh3VuzZub9sY2cbby2NakJB8DoHd9KaZ0NUHY3Nb50?=
 =?us-ascii?Q?eveCC1azZIXNS22iMzA32CLml1RTiAbX1PAVmtD2qSlttTQTOS3Olo3zzDtu?=
 =?us-ascii?Q?F661qHzqsl1vYKE4ZAnp7508cpmKcxz6PZFcbvgijCq1M6MY1CbN3iP61K4J?=
 =?us-ascii?Q?AhaE5hYicWGYiM0D2FtNElhv41ptK4hhG1Slt2QZM6fD2rkIwV3M26FWQIcH?=
 =?us-ascii?Q?PreKBBXJQjb3RY9tCZ4rzdgxJeD94zCGUconqKZzQXz0dQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BcyRRPbf0ItRTVfRQ0S0yXH6GsSq1n4EqdJYS9xFUTMaPflBjf9g0f71X8bx?=
 =?us-ascii?Q?mShLU2jnIAN90nERspAK30COYJ3L2lbGpu7aKIlP8xL+pVObwRwZO7AUZlCT?=
 =?us-ascii?Q?sX8aBkCyW7+5YXzFuK1JA1veTPSd9BpnRtYI8ouk6hBzKCUK2rqpFk51VxoA?=
 =?us-ascii?Q?nVQraGGKWQcIbuSInSlYTTY/3iJwTFM6aOJCL1eM6ZGFCegrZYVPh8QDkgIb?=
 =?us-ascii?Q?BddVkhzE+mT3LqCk5OSDRHWpPQvcpW7uqoDv5Sy8QTcWOFjKfCBMCxcKqoY2?=
 =?us-ascii?Q?aMNhGyiCD62zz0CsnGVZ2XXU0A5UkVBidGvGnWYz/ncAXGk55ny2lHfTV96H?=
 =?us-ascii?Q?KvmMUdtNUnNg3tY1LVNG/MF8c+QNjySotsfmwN4I8PQLHWkaOtVEHtr+BNFD?=
 =?us-ascii?Q?pk6t3lvYRivtAyQffM3tpCX2+yQBlJE9vbvCPRxnJKAIBZd2YIosje+gL74n?=
 =?us-ascii?Q?gfNHBNYOpAtdPw2xZDtQj7cHm7Bivx34imxGI995AspaYXnvIXWvsXVz/7k/?=
 =?us-ascii?Q?WU/kIEZSZXWbV6utz/3zrOoWz9A6g7okDXMsk6QYabmzDekNn9FttZ23kyWO?=
 =?us-ascii?Q?v6wH/MPUT6wMSRDlryYKgwth8WB9SnaSCyJ3Jdr/RBcWit8RAT8pO3c3VYOg?=
 =?us-ascii?Q?uRvUh1CokL3na4FHsD3ev7ndmrkGJPY8+6F+sbK2CwPoxO0cn6wM9UWo9TLu?=
 =?us-ascii?Q?688D/7yyYQa7l6eJCxPcNWgAFH6ht7TGRaUqfevJWifNCl6gr/f6PI1o9ZWl?=
 =?us-ascii?Q?1UjAxxGOY4mvAftNuzaCZNLExIzkBWbScZiuvyQ3DKVGNgRVtgAWWUmzGD44?=
 =?us-ascii?Q?+DSDNlFj0uJPe/+gvRbWGRR+nbIRJnWa2kylMf55C7zCxrcJTks9o2gQuMFR?=
 =?us-ascii?Q?jv+vDCcUZW8JyxPnuGJMD7i6xuasbGWC6pwuezyHwrGRHKdbXxRogBnjaHaY?=
 =?us-ascii?Q?k+VvIG8iyHRwFLD/JJUPak3gv27hwzoJAzuhfykwtAEX0cG77YcZZxGhxchz?=
 =?us-ascii?Q?8CI2Dn3CfneA1eIdMtxvpuyDKZB9oFmHEvFsiaT2AAm0/3xNut3nh4mQ99Zr?=
 =?us-ascii?Q?yiq2LxCk5k/j/o1fwPTMQFjpo6BRWrUQi0QReEHs4LXFwjXjFEmplXffbRWK?=
 =?us-ascii?Q?OLFH9oIMPjUcE2C6/qclvC9kHGmCMJ8Z8/52BYvZw4e7VdsW917UndFwVKOY?=
 =?us-ascii?Q?Z0eNCA2FtXZJ2AA652FOeru4ECUivY1LIrAHO+14nfgI1MMXKGTZauSlxxLl?=
 =?us-ascii?Q?f8+Bt0+GRVeZhVQm3oKZ9Hd/iEo3iWegfOecTeaJRXyAwXE1An3rmu2pALQt?=
 =?us-ascii?Q?lzOC8cWgME9N4sjJKDq1K5HdPJDZagmXA3h5ripVQIvMauaxsZ9nTWWqfo8h?=
 =?us-ascii?Q?t1bcXaCS9H1w9gQ7XIgCLRdt9nEcRhMSZbC5EExbVatpsI00+uH2+AFeRvKt?=
 =?us-ascii?Q?3EbsWBC6sUe1jtzRNmbF8M6AuOAvgBiVZBza3bR1FuroLJo5sqbdScZWkc4U?=
 =?us-ascii?Q?AyGIcUGPSRzl3nMiQgtuwCPJ+No/mS4pY9d7xt2yYP+TEIv1Dz52E8O0rDmL?=
 =?us-ascii?Q?qH+c6cwze0tpW53zJ4j4PjFOl3Q1a01M3Bgt2N8USFetAEUZ3M3KVAIsnfNB?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XRWFfLhszP/f7Urm/o1+CCZvCdL18m/BeNe7VoZ+vIvXhlQDuB9gzZ1pmarWR1i66afPe9ihyudmoVQGEzaYHr9m7ebMLZtB8Q48Fm7HQL1MDW9JtB0pGagfia+JbFRYYyf4EToSa0Y4vG2ZJIPY4SyoNstwRXMJ9LEEyyTVruYXP87O6UtwUpM0vll8T/plCt31bBsPFMBYUg98TmL/PThhHeDFqc1x9SaCI+l6e7qrxKt7oOwfPTPSMnRiVhBRUsXOxMY+KtgdjnOLA7+HSdX1qXLjlVv1TZ2Vm34pJsN5ex662wRR3YIp3V3DeDRdi118CnZqMTsH1u2gdpR3JkpvOZ91QeQCNR+0PA9Z5flhtPQSKMqgWOuHk4iEq3x+xKzexB6RB4ylHEDSKtfVnLAaL4EiGYk/iXHienO0s0I/rHTyaNHsLh4DONqbpagR0Qhf4WiwOmL2w5ZZw6xzVQr0IMrA4F89JdsmJFgpAv7kInrSZhXc8E8ctVrNVj1Q4H18PlxQLHKf35r3/8fIxOU5x9ytNFWeqmkV2rwk+GaqJ2B43mjXhZX4p9T6hQ0gTZAbOQC9RVAqPiyd1dhJzy5xOJliiqKEufwbFKRwcUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cf3411-3a4b-4b88-f124-08dcd39703e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:54:33.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNzm8wk6l8egLSayEHL9lfkfG7N12ofRNo9VIQatNld6C1wkrK7PI9hD+GWSdXXFWV5sBTWJsudXS8ZXMpZsMJTrAAtcjfVuM5bhpqzPCUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=961 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130013
X-Proofpoint-ORIG-GUID: NEQJoe-wZBWTliFhHIpCrwmrcqcBfsez
X-Proofpoint-GUID: NEQJoe-wZBWTliFhHIpCrwmrcqcBfsez


Keith,

> There are no external users of this.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
