Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29416A956
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 01:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780363539; cv=fail; b=OXkIaJKXt8ANIOn2D5KBx7tUYbFYMzVnyGLnIGBSzDPOvXz1MsHHlgKSgQ7U0MiucJVFOAv8PxLW5pDSGTMUOS4UbxdRz2AUtTxqkfjgrs3wbuXFc9Fn1wMR5xZR/OwbrDMcwN87Ii/8JQ8igy8uhNer3ys+nuoMCk4Pu5ek3Ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780363539; c=relaxed/simple;
	bh=sD6TIrtLgmWMeNKDr+nAu/hYAk20wG86d+NUZDEFbSo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GqFo5e/kP/oMXovqHstQ4htq+KRlz137IKjJzQ0KLBAFY8VYNMXw8TcmYi9N6BbZg9sXV5aLD88/Ns0Awik8rmEnYU38LRCcBTUhGqDTnSP2wY0dVv+pHNM0yWWdY46iuOTo4vQ4CoXqKe+wPgRrc2Xv0XF4lx614LBQYwKgi8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FmJ+ljso; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fOPiT8AD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FmJ+ljso";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fOPiT8AD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gtw0u515379;
	Tue, 2 Jun 2026 01:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7DWQgCghArnagrSxyZ
	vZGuDba6bcK8T6nhvNF0Fjy/E=; b=FmJ+ljsow9d0ycQdXVkjrcTIubedTr0Cu7
	njz2HFWGLHZbx54Uq1xeGYDOXg0XxlmIfrLDIPLK4gmd4fR385jXw+w7XOXvr5CR
	1nzJRLpC79irIcHMhEhG00EQejun/s4gpLdBPUguo6/JLk1Eyjt2VlDtdkjzwNDC
	biIkzIh1uycCqG2nnd+58MEo1UhuSNycsOSS8RQPVnSOiED0gMaCmvtKEkGqnnEC
	H1nVY3hWIVQbGwRcOKpuheGZ7IcjOU9FjGInWxGHITZid+KTJoQDAyS+R6khJ7oZ
	t+EvI0fI4Zg4pDEwNNNVWUOf7ZzShjCbaNi/3KZCTrjn75xr625g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efptbk85a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:25:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6521PLZG035589;
	Tue, 2 Jun 2026 01:25:25 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqjh4c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 01:25:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zUx71o6nr9dsMo97z57dIPTHhvCTz0SC+DHiH4IAFe5Hsp6DbshaDFuSA/LgJyTYS0BWhmOCx71KTCE+xRFJb4MlU2QXjgiEtyHYp6mTRvW+6Cj9vFVzQk/A8o8iypVYhc+A79m7zFaiZ9X1VtuKfGEYLqWBQqPCTbBoU3KrtgGEYr8ca56qHymPCeA8So0SaTh05p8HREHtYETeI4tbNzvzXApFg6L0m0ynabdSnXEJBLdAW2NeoRpHPPNCepBS9yIK84DDhqflXjIhqphOGPpyYnNMFCg380tOEOmmyFIbxp2A87kB3JvldFOaLwdc+hvgjaxAeQj/BziKjjRZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DWQgCghArnagrSxyZvZGuDba6bcK8T6nhvNF0Fjy/E=;
 b=wTWK32Dxpbcp+KAJi9etehxdWtE0txSyRUxW4RCz9mD/njP2xD1KtYypI3H/X97NB8DH9eYfWdvp2Q9uH5hAwjPgiWbhh7qrQXh8Xq/FFPW4mRXrQLfxRtWqSukdB7U57AUl/luXlNuR3wMc8Q/Mb39NKEGUtF1URxnn5woq+ETxfIVzhZR7PyIrVwjLfdIiqShU4JYvabKjzZj1GceONkHEWqLxHRt/EELficQfZCC1OgJBb0BlP8j6ZyX76f97mg7/mHuNwHPOg20hSy4G4jK3aq9uQfAl/+Qw3vnLc5Bb/Rgjudm53xD9OGg+5AakQp0/pjQSpOiix0bu8sCgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DWQgCghArnagrSxyZvZGuDba6bcK8T6nhvNF0Fjy/E=;
 b=fOPiT8ADbHtTTbFRGbMIFkAv4oWIW+4TBj8JSkivnwWWTyFXZse+Zl9/8nPJrobnzpA8RswJQ4XBlyb6uf1FpgdyWxV9Czu+n1KMdEYUu0wTiRNaFx+nASmc+CoWvx9JR+cAxHtCEFN+dI89OpDhk38vcASUiU3GcpXIlvyEdu0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5729.namprd10.prod.outlook.com (2603:10b6:510:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:25:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0071.011; Tue, 2 Jun 2026
 01:25:13 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Don Brace <don.brace@microchip.com>,
        ranjan.kumar@broadcom.com, linux-scsi@vger.kernel.org,
        Hannes Reinecke
 <hare@suse.de>, Lee Duncan <lduncan@suse.com>,
        Martin Wilck
 <mwilck@suse.com>, mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH v3 0/2] Fix SAS wildcard scan on smartpqi and other
 controllers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260513174236.430465-1-mwilck@suse.com> (Martin Wilck's message
	of "Wed, 13 May 2026 19:42:34 +0200")
Organization: Oracle
Message-ID: <yq1tsrlag4h.fsf@ca-mkp.ca.oracle.com>
References: <20260513174236.430465-1-mwilck@suse.com>
Date: Mon, 01 Jun 2026 21:25:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b9e6b00-2fc6-48ec-dee1-08dec045cb3a
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Ly5COZyFctRKWIoh58gxxvYzqnUDamue1LNuej++O5x3MkqpLajsjFGEeGUQ6AL1jjjdAUJHMC9x+Vsww7mK46Jq8HAHC71kgfJ6tZxNavHuvWW7vZWmYLtw7t7CShASNkCmB7fCbEc909DEuLIT0P2vCYZusQpizhC1N3Dk73UTU0pYxPMRDc1d7MwOhSt9XTOvsO9xkyk0Vny+I6qRxT5MR5BQ1UfrDKnn49sNVEF1RweeS46KXjL/bZbals4u29oaMMLJsEFpKbQgcnLWyiKJbtnS2n/P5V/dy6sp7AkFfBLtC34e/OhIfV43+byik45pKSMAVdEZJ1pUajt21UBGj24RDQmP7ge9SURNHFx3t+HPX3KULl/PVMNXpFHmcFTdDoNP5lYb16+rz+CSykTCF5+uSAwt82pwFbAMWQIhJo1OcviXWR2qkd2DvX1x3FqmpHNZ9iYy7WnpK1FpRhfZs4RKTasCdYX+kYP2IechH6qk3w9m8ganS8aVXL4w3/zX4+/IOb2NI+pf8tnQ/u/dSAKXul/O4Vsj1s7552p/xgUNR1ULX1laWgu3hiSsKmwBjwcpUs0YpJIAX3d1t3weNB0yMKwBMU0qvT4Ce8rkmitYqdX1T5eBk91nWan8E6JEMRcTJlzA03CM6z5qESrcMmBPbU1KBil00w9Dl6RlbwFncJZ2HHYh6rssveqi
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?uG/w1UU9Imkk4AqngUqYBOZUAp7sORwXbbzqfzLYffeE5zxCBevxReVnYulY?=
 =?us-ascii?Q?yYzcjYMbSytxEvGXOJSjK+hnj7t5errJL9RQFRuEZ1VpVteW3gBlcXwPceR2?=
 =?us-ascii?Q?JGuIWFYW6CT+Rf9HozdJ28SUJUpIZ9UlIML40KkOgmqKhHL15228YpGxTEmD?=
 =?us-ascii?Q?EFKAKPYcBNBZ2VeQ41OJHEhSKx4/+v/M4d4jLbokTo8ED2clmxLmscDKjoEm?=
 =?us-ascii?Q?QJ+zZg5GSM6kfmz3G1TRryrVvf/0nrICJVTAQrIhUwT8W5XSFVGIMCCLq4Lq?=
 =?us-ascii?Q?TopnsCR5OwcOdmsGGqE+nS0QdKPNq2k3LWqAcWfZckbl3a/TqwjQSq5D4Ba6?=
 =?us-ascii?Q?1USNosqp5zMs6W1dbsn1X1XnHzBC/G7Pqpje9A1vH1wdGh+pxbtAq27QhLs9?=
 =?us-ascii?Q?Gx7JoFY7nfMZZHrXaDDa3G7K+d3u0tq8CpSADbEBEtcuukWx0yp9nlfMNzZd?=
 =?us-ascii?Q?6lagiJrmIwU5rtAvf2OELETQ+GGDFT2X1BczEkHaln6CqdMc+IvRZpfCsmHU?=
 =?us-ascii?Q?M6wojy0Xq2yBA7AybZYQRY9XQ4//JPefBXiZ/1Xf81eOo0YZ7nRd1En+vyj5?=
 =?us-ascii?Q?1FohLRcWZxEPpLkPf5HohCGIMdPnZ6rOOjnDSMV2PLo1sm1krJ6aRRTklJLT?=
 =?us-ascii?Q?jydq45wwv57bqtxOVFYdxXzJX3EMj4I3sLBH4rB8aZfb9gIzcFlPv7YJa6nn?=
 =?us-ascii?Q?uKKjF1ErCCeg4oWX5kth+CCo225XUVf/UcgSoUM+iTtgiGOCbj6EwBH19mtf?=
 =?us-ascii?Q?a+FAAm2guo2vl7PwkGOKzZ9giW2s5XY9qOJm++zEEEmBQR7uFO99HWAolObA?=
 =?us-ascii?Q?2oXsz8qeYSFKJnNOaa44p0f+U8D/jFLGbCu/dDprZrl93u0qizrtUTIMiR8L?=
 =?us-ascii?Q?WZO8V1M+WDZay3b9g31IedJ1K2Mmhdi55h2kC5lP7GSqH/mMqZ4GgjDjDblX?=
 =?us-ascii?Q?wZmNpsc37SFJXmpJTQxGAkfNOiTYc+/jxkHLLJFFyVtip+GBXr8rHCsHFP1K?=
 =?us-ascii?Q?PXVz6esxOyeRrEFQWDCN6vrt3xksntqUVWX5h/Sr3SVrShCSWBpfbYvK0bP/?=
 =?us-ascii?Q?QPZ/evmUBQa08sc+Ee1U4qOC8gdd/bswCk6w67/FI3kAvl4GIKiTKwSwHbGe?=
 =?us-ascii?Q?hPuyrN730/nwvW1Gd/z6sLVXj1MnHcbN3t2FU/E5oq2Cs74mSyN3O5BJdE7n?=
 =?us-ascii?Q?GV3qeq6Brbl+aej4Amcsn2KQOQaee7XYeEcE7iFJAZe7u5vt/foVCOWBdBll?=
 =?us-ascii?Q?wN+gOApNopoJqetBa9QNfxy81H/RgWxN6wUvPFqF+YQhHIvY5ajagiYcxefL?=
 =?us-ascii?Q?r+nG4RVDLRYqDdhmvVRIEjDyR3oaARJO6ycSnECs8rlceQ/UtRWf5sGXlZAB?=
 =?us-ascii?Q?yVi1Q94p1DSW+G+WqIgi1NfPJG5jCMt/XuAXbbypmQXda7z6QPr+Ies2/WBs?=
 =?us-ascii?Q?0EbGhkaIi8Z1ekXWtsWYYircWFfc2QEE2M6HQ4lRATygDE/MKW/gYT244HcA?=
 =?us-ascii?Q?KRIBGn+cQz+noEtBphOFQZg+s8CSzBkNf4rzqPNvYyrAEgGy2YffiHISDEJn?=
 =?us-ascii?Q?75k5vItruWv10/GsaCqoJHKKfmYpI0nMWUwQsJ1n/leB37zZmhkXeG03Iw89?=
 =?us-ascii?Q?jNXhrwQjyVHi/dmDy8VYyKuf4HyUP9tK9e5C0aACHq8mJhUWLTnw8BV1RDxL?=
 =?us-ascii?Q?PM3KYECZrNzedTurcYf/GPDRbp1jsYn9dc6wH5HL+XsZLjCgPrrV38+CDMhn?=
 =?us-ascii?Q?lnGRYiyI6ysdp1uExlDuNs5gZd8xsi4=3D?=
X-Exchange-RoutingPolicyChecked:
	D99wq8iCqwoav3/8+BAanfLTa71+OhGlUrfLoweegMuqpHHn28UiZqHqsTM5oYRocNM3dqZU1xhJP9Vm9kdKxDqWWDLKOB7eebTmMZrnFZOKp6/o/wPiTIfEUzAVR8Zw17g1s8bkmbP6371YqaqagnBvLp8wRh0XvBQAOYIi1rVcd6RbBUlsId6mcWflbpITkwE6k7HItlsK9RTt2ym+cDScgTXflP5vfhHZLmyHe2xUvm6G84loT8i6gJYFJgb3JfKunFWgY79umbxX7aSlUEsbSpImYQuLxrbvQEesfjYihunHXGH+ydxtazvEuNXWR9xVCouKbOOxH8hrSzSuJw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O0scMjxyLzGyeIu8dfcDpEgforK/Xas2MNGMLXpCYl0u4PPyatMRZNt+dh3eo4tcovYHd2JXt2HDKuh67ZZnGVIPDqESvR0psQK+zN5rAhg1IMLj09lnqry3reeu/+Y7+gxw+Tk2Q7vahzSvhLpuAmeVvBmh+8H/ZPdKzIbGFqWidOUPVwjwiUxQMp/TtwDOnwTecXL6WbJH/uU0kn1zq1suTQEDGYHO9pkRi0r36lPyUwiU6BSz2hyj/jwFW4DiEiGe6wct9/nvSTLebjADTEYzRvRbUc/VhlT7R8LYj1o3H707EuyDNJmTjC1U09NAGBfL2UbSYBCofEz4WOuLohURe6VMN4W4WmTUC4MOdkg7I4Y7nbhjDzbmvbLdlqiJkjgNAC+zDXLsKysIoy1LqI/OhWAp56WtEHB+m5HZQxj9Ownk5a72csnmeYPq9pA6R/1aWfRVdF070hkC7RJ+ApbbJHdBQrVQj/rx+sz5A/U9uNKSFUBukIayrQ+cimhM34/V825+MoyEU1iwKKl+ivb2616dT9yEUXO+itKu7ia/GZadjQVlcrNdGm77n+8omJ7PGEHDiUIqAzAaRN0y3m8qI1PwiheD7XcJUazNhkI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9e6b00-2fc6-48ec-dee1-08dec045cb3a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:25:12.9246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGCZvmZebwbxuoXmKsGQQVSXLzQuWHlkiYvgeRzJjAzUwqu5wdMy5Dnr8E0PpKxmcyI2nYpkvyT0bkk5WjWRwmD6mBapKOQEk992fI0Loec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020011
X-Authority-Analysis: v=2.4 cv=I6dVgtgg c=1 sm=1 tr=0 ts=6a1e3107 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=DMx1oP9MIIDwXaO-esIA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13714
X-Proofpoint-GUID: vK3kLRQCp2QW2gL0moJ4NYK8f6WQq8b8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxMSBTYWx0ZWRfX9uzrGmRwD0p6
 tfEXFriNIEZNXbbrWO6PKvMMuwbRLqYaSWqecmuTnO2Xl8KeTQKa6TvBtnVtS1WqocZyZOUF4Us
 2e2Pi9HDHgKJHpqeEiNPDE+J24RxAqRY6I1rfhbUWpOC7T9fJCzoSQXTaNvR+BxZcmy3FdmiATQ
 Te/esXJs+VVxrbfOZ+rD1hqqfeXlH7mYnLNhBjKTB/Wx3PMqEryoN4DxjjQC8fjWeeElF8+TGvu
 V8XA6Kp5AtwjHvzq39raE8fvhUfed4IaA8eUtLbbiuBpKGMRuKA8h0Nq+VrPmseGnd8Cse+AEE+
 p4KvIwf/7ePKLPu3vCj6JRmxa0RnquY83cJot2EPraoyA1IsQW51sfn7A7jEoMDK6FjUkCZsTcW
 R4MUm7OIQlMz77maezq0NgbZgVonsHhJXf8EG2vOmVvpBZAdDVlnuK9zXZA1s1CHq4JLH6tF102
 QwVmLVQACyq1E92bC5hMFaSXcAI7k2buD1ZDmX+A=
X-Proofpoint-ORIG-GUID: vK3kLRQCp2QW2gL0moJ4NYK8f6WQq8b8


Martin,

> commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
> multi-channel scans") modified the way SAS drivers handle the common
> way of rescanning SCSI devices using "echo - - -
> >/sys/class/scsi_host/host$N/scan". Before this patch, SAS drivers
> would only scan channel 0 for this "wildcard scan" scenario; after
> this patch, it would scan all channels up to shost->max_channel.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
