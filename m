Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31B410A3E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2025 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749519083; cv=fail; b=UENV+BpmAk6r3DSPzKGH824sBO6gHtP2akUN+/s3TBdPrr5AB3vhd0mE6U/0agHe/LF1oUvpRKlEhedQmVprSczp3srHWFAqxAFjPo0+8nVKJPvhKZFqbIESzgv7UBpZZ72uThx8dSYHJmLzrRoY1XYl2vjtON8VH+khYHgFlTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749519083; c=relaxed/simple;
	bh=lK83dNbhw+IZk5AeabNj+qRKvxmzvYXkW0l9Stxh8MQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E/PXxWRygUXEwyOCWXRdOKdx/IzIijBo/J7qAqU0JF+s3OF5GtqPe9eKqfwR3RAabEBS1ws9EoCVrBaVP2nTR6Ihm8BiZeDXpEnDz8hBLaJTlAhYm9oRnlnRXy62Ger5yiH9pfdiMO8v/SjVYS3HPBYaJUwC20teVdwHYp3CZ20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H2KstX19; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mOI1IQne; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2KstX19";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mOI1IQne"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559Ft2Fm005992;
	Tue, 10 Jun 2025 01:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RD0TP2xfLGRQmXLijd
	XY4PQf37PWFiF5tR1qYvDINL0=; b=H2KstX19GsCG9edljpkxF6zYoOngWssqGA
	j6CUsvDCPzTG9glNQaStOfd+HpKCBZm2fh+2XUoGEweqnjYI7fvF30NASeHN+SGY
	UkKS3Ka1pi+6oQ4uVS3m+IscUo/jEH6qdDvVg5faH30a8LHl99z/oQ/Rp/rmHhWi
	Q/mJSXLyYLzvsrTzM0GM6Viykrv3cnjRD6g2jg+1pSM7jmA1ElSvc5MMNlU7gmYb
	AGRHB5b/T2WqgUhGe4J2tKT9szmu2IbAU55I2HR3I3znNPNGm68LCN/aTCnve60L
	Z+0MH6bQmO1/yZ8XijZp72LgOvQD3zu+i1XnKvBJH/4J5HuIsw6Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dad3694-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:31:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A0cSxi031345;
	Tue, 10 Jun 2025 01:31:00 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2056.outbound.protection.outlook.com [40.107.96.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv83vck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:31:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAJkfyNobQ8+FkqwJXZPQGTg9C/q1XCJds9rLnred13sStIR+wsZniPcBD9q7Lq5QQ6ahtTWrC3/93zf+xkciCNL6nLhVJhqi8B4aweJ8OwfpY48OO5zAkkDjludVOzhK6aknPEzYysr2nzpfTTvyVkw7vaPNF7bEsm6yVDJ0Zc7jVpPDxsCCfiWp0DH5dyVHxW6OACVHN9vghiLkV+znABnDz52YCZzXNgg31VADNEKSoLuqyJSBivs2ya5TE3pBGdcvF+ChPNWjoVGn4F3SuV8ewhoyTbGniimngEjYr7sOtOXvM4ov2mh1nmJQJBbhtD02JZsXlUcYcu8dgXlTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RD0TP2xfLGRQmXLijdXY4PQf37PWFiF5tR1qYvDINL0=;
 b=KY8wi88sxIlrYpV+dHOppUZ/Ci6T9LMJkcfi8tyB4MH8u+/KIktKFYch3aQUID18NBv/L1LT+hpBo95T3N9TZcvPP9rFuQREvXxvSZacUlYX3IF3NiXuhoj8mLIzujc+27gVTx2ZSQkWkLPPldK7xRVrXWtoJWyK3V575MhtQO/4Q6NI1qUbOKhIgm554Nlw0V86hSIJzCjjVapMrygHCYjnWwlwP9N5aT1MhHGer6d6uZYEK6xe/yDZauVAhJujn+2YAveJaH6KpgzU1zhpPHeWpmCJ8IaCQLptmxzviNY9tU3KtvcVxMDqV0Hqw6faQkQEEhU0Npm++DXcf3XpRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RD0TP2xfLGRQmXLijdXY4PQf37PWFiF5tR1qYvDINL0=;
 b=mOI1IQneW4pj+DdhheTfa6KuthuXpda0dhTs7QuGdWpXtQZ7JcWQLBD33/jSHl20urAK/hJt4L/zQAF0A7QJFYhzXHp41hDp88QX1ebNuBNmqxYD6Etlz09rVtxbr7LMEMfUQoSLPGNG7GBLfuVRw70zO9s+fl6czVZmK1xNQcM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5818.namprd10.prod.outlook.com (2603:10b6:510:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Tue, 10 Jun
 2025 01:30:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 01:30:58 +0000
To: Hannes Reinecke <hare@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley
 <james.bottomley@hansenpartnership.com>,
        Bart van Assche
 <bvanassche@acm.org>,
        Yury Norov <yury.norov@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi/fcoe: remove fcoe_select_cpu()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250605062014.105302-1-hare@kernel.org> (Hannes Reinecke's
	message of "Thu, 5 Jun 2025 08:20:14 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ikl47592.fsf@ca-mkp.ca.oracle.com>
References: <20250605062014.105302-1-hare@kernel.org>
Date: Mon, 09 Jun 2025 21:30:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:408:e4::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 223abdc8-55be-4ef5-cf51-08dda7be7377
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+PqNGXtOua2g2BHxeKmmpBWQqVM1Sw5AWzIw7lCtByFzwQOkxddWDdhhVMpK?=
 =?us-ascii?Q?Ef2vOxI7v0sOa28WiB0jaC25+OdvmEQhF9rUHvPH5Hc7Jm5emNtXVSklUnAp?=
 =?us-ascii?Q?Ghx73gFwggrdfidtrO8qw/ckLo9iO6782WGWh/JdZH4E5mbwA1uqjrgJ2Xou?=
 =?us-ascii?Q?v5de+6np8YYGaGILBSXUF+qot+wiUb6My8pW57kyt9uDliwrj/vGXI92Ml02?=
 =?us-ascii?Q?XNgH0XAdb77+u8eDeG3bNsb9ycJN1Ha9ivk96/rqG14d5Y7/GOJc28ir1ydk?=
 =?us-ascii?Q?IwuFe1PV/9Z4yKqR3RUXXb/dqiDYi+bDq368U9jV/8qOomduKksCT5VptAVJ?=
 =?us-ascii?Q?2XRyDapIfuUTV86347jAKV1Ws3O48PNaRmprixZIunhbBuXw/Vh4mcBcAcgv?=
 =?us-ascii?Q?YSyVRxVTNIItbtkZi/WQudscGQs43j0mIj6j/pV3yfoBB/iCRD4yPJzSJvIH?=
 =?us-ascii?Q?hRkNinA+Q8D6Wh94kiRUyknpd3LmgkcUpAbDIiBWhjSVcsNb4LQuptUAkmJN?=
 =?us-ascii?Q?yR8gGakQRXG1YKvks65FIlCgt5yRdvHZTxIp/Bog/Dz8xcXjVRza9y7jroF8?=
 =?us-ascii?Q?ADK+ISLcsKFTQHPUZXCaRgQDtWaLwrLwhK+Yqux/LcL+nA9XhCfthqzHOQ32?=
 =?us-ascii?Q?BHjvuq4pvpcFuByNZVefThJAacg8kNL8e8AK4XAHdaUZDBc7Pq6VfxsVdYhr?=
 =?us-ascii?Q?1BHQZDwoRvC82mG0FNk1rtu6Q9Zw4SMcVz467NG/evCaFbJ+6GNd2xDg6FR+?=
 =?us-ascii?Q?W5wYRZ93JHD8bdrbrRLJS9+g1n/SU+4/P86uI3lt5y5Vrr54sqeMbNx7dW66?=
 =?us-ascii?Q?VAJSPeBrAcZHudX/mjR5KPjbZesWdSGax8AVy/AMnWPSfoI8DNVwSk/daBPZ?=
 =?us-ascii?Q?mrda7KVNJ84hJJOuNU4HmlVmMSRPqK8ZNmBnGcGCoR/cN1hTds6pu8CBMV7w?=
 =?us-ascii?Q?qPu4ECiGDWS99Me74YA8F3upCAjV292YaTl10a3f/C09/p009kMthvd5JBNk?=
 =?us-ascii?Q?Dd6tgSGytNFv5SgVCcMMfsk3yCtroFrS8HCtDw28OERadDKIGl6rZXDXaoEd?=
 =?us-ascii?Q?4ZD+2k+sWms8IcAozwAAhtp2ybzVS6AWH90/O9kMT44QDqDz3WwF+PJUKD3i?=
 =?us-ascii?Q?kfCVgvdzRkbjnTCjH2FxrIO4tg/nzCiBDZmssZGqa5zUNnQj0o770Rt6oexh?=
 =?us-ascii?Q?KhuKE91yIlUtrhZSUebmz/qPR7l2RjLNz+eWmoVZJbgXomWblh+Xi1wt92hL?=
 =?us-ascii?Q?qHQoRJ4ASA4qKzXQHBhhRHAdqFxHsofn+pMtozs0Y0KEm1nhBhlip9JYkOE0?=
 =?us-ascii?Q?fi1MuwhYsa9URhX6YISxFlBhGGnHJTgG2JlQsslgR0t/UdMC1eQ5e03F5IMK?=
 =?us-ascii?Q?SHM4GKmGprkg1UxjhKk3MYWkVC+CmQFmpX7NMUUVwBLwllGeEkRSQTJ7homw?=
 =?us-ascii?Q?hpKAVOvpy0o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TJgOhJPiWp7nCHVfwjZc61a6VbaRLUyg69SUlHP03SVCAe1nErhgnhpTPCpX?=
 =?us-ascii?Q?Z/skIZd9sd4SE541DCtIM9we36iY/T9sY6p0XKwYj2xjfvGXXJL4ypYBzQjW?=
 =?us-ascii?Q?A+s9gBBQFRrMtk8DV4K1hnxAPgEMFqhNDCLKUAxlEVRe2uAvIE5+sXEgE6iO?=
 =?us-ascii?Q?44eYYzS5wm6kN0+cnmJgYYR1ldnYx3E0zF0tCn5aZK0YPe6bQ9vK8gDmLfbI?=
 =?us-ascii?Q?Pf5kHtjUAizVJOvaViAMBV/EWtGVCE4JlRSfamqyy9QxGZw01J2zGGzBTrVB?=
 =?us-ascii?Q?kmaIF+NROjRwyXy+nCoJH0Pz67/do5QF9XtkkA3lVhCZk0iMBjRFATV7JgHp?=
 =?us-ascii?Q?lPQExezf+5UEVX4YLscDyB/gpt9AjaM/Xqzl6PuMl4Q5mn3/iWlpMmQfNk57?=
 =?us-ascii?Q?sSCeJaDgB8+/BoHewlYi2sja8RAXakASxkIqnUWnmcpgvLVcQqZmD8Koki+O?=
 =?us-ascii?Q?+yl3iqG/fyLSFP4mO8c/UNp7baK0cZFUQn75kCsCpOc+cB4oywsxgWdhr9ok?=
 =?us-ascii?Q?m5VgQvPTnnJiD0Xe7UXhlqyDj6h1jJdnB9pQdFY9CHyVUKksC0hvvXFdCSy/?=
 =?us-ascii?Q?cOIKXfxQW7RLyAGGic1cKpG/MkEf2gXk9fu3UFrJUYYJw2aYh+jDnYnt2eCC?=
 =?us-ascii?Q?fO+6rJB5p738RuUK9ZUJzXHugsURTvmjexa6Fa994foFCqmT7ivd6GzBaTjq?=
 =?us-ascii?Q?izUHXG8mWQSkwiLG3c/0WxGKY4O30xipymcWfyQbb7vkNqtOE337zVpyRpDZ?=
 =?us-ascii?Q?4bYLgf35/8dtTRu6NniBi2Ip0aJ7QcbDzN2eD+oS1zvpu4uaxc5SVsioi6qh?=
 =?us-ascii?Q?eAfvgcqm0GuFjoJJXu91UoA+GEE9vD9poCSoYwt2rLvG4l1LKelwmLMrwu0S?=
 =?us-ascii?Q?WFENna/eUQrGVHFGbrcuEIZZPBJ6Rw4CvQqE1w78uPYGR7HM7brsJkCzvVdV?=
 =?us-ascii?Q?qydLFb2R1b2WQJTz8GS8HwkIrgsI0Je3AGgK2ThcSxGdDkpb+YGmNUJ4YTua?=
 =?us-ascii?Q?p1SRl/GDEy4KJ6a+jQy3W2+J8+YkIvV/PqM/UXVEnNGdAsO/edqQLdfoHjz8?=
 =?us-ascii?Q?nt6fJSAjrugOFywni1hN5V4o5vL20v9ll/3sQt/45niOhtZ4sJTbnWVVND62?=
 =?us-ascii?Q?6MDYDo1K8hOfDJn40GecU5VvwaQMA1QhzjRndM0CEwm0ONFefFNL6Z6uJDZm?=
 =?us-ascii?Q?NRtrIlE+yjt9ApsZJ5qGTLQAA5zBHggNsP+4EcsIQIlElSodta2oV28fBT+Z?=
 =?us-ascii?Q?807sJCjP+ZHE4LqNl2JkW94ndy60bJ1T7lNz3SdZqjblF+pEjwO1gU786UHr?=
 =?us-ascii?Q?rTQFSTAvgmVzNSMWuuFgsenRs0Rs2MPMcYxqVhyLyCcwpD3+2SGscv9LDUPP?=
 =?us-ascii?Q?mVU+qW7tb3yHM1P5DSvGwuiAuhSaop9OWFXsCQ2LENf8Jd/k2lrVyiwj5Z8W?=
 =?us-ascii?Q?44ul+J+1lzGnOAJfLsfHSgoRPhILGNxRiOtkUOIB9MTQE7lOfBi10qT8h2a0?=
 =?us-ascii?Q?19j7a7vd71WrMXvNFJSXpytQK8qJS8VWYAdeaeyseMMNH7fv/80HYJTpsyDt?=
 =?us-ascii?Q?FahgTU5XcUdDEg89jSOBN5Zq19+x/ZARH5BXRDgE0p+tLYnSz+8b1tkowC47?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C0/CLRcbvpAnxSlqOArqDR4HhiRoWpGsrUJsE7wrUYF6mJUs70tgbRPcwVLybjavHpMFmZXvqFTtC+ChuGw82r53P1o6DFUn+x+Sp8Yb9FaH3qZGnfthCq1d1sXGShuTyW/bEWAEGDDFE2EMToBsMVOVJW23VZ0/wp/4ReLufc16VlL9xoz/69/TOkbwZ5zUClDMgHwfGV9wCc4ywLTAhM6jE1yVU/rYWa5m1/tGvyV1plhl8D4eqTmprhzC7LnP8iAANAJZ6V2T02I4hd1USkyhULtkdqZ7rG++1+sjFNQ2bIjjoGtVGL8SwZBzGNbDvoLiAJeynB76qI87ZNXWGghHZthheV4Ytq2DGy9cqLYOcQ5aHSwUFJBAJ9F5RnqiIO6udorW7zrrciPD3oCg4PvPbG/DvxqgEtACMKt4Fp5Qd9x9An6aFnuoSOMGMcM+u0pTbxdzIowYrSAmM68KYhDQGRfAKYgtUfM0vCjJ6Fig+F95LQzd6Io+rO4GYH7HJ9TkWRI0Xa1NmL0NKzbGnp2pKyAuuk2USNMvTW5T05QQLn+XHZkGFdVLquLqgPekwml4vFyiEAPFA/ThPjsBcjoRH2v3UAtxdeesJXMMw3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223abdc8-55be-4ef5-cf51-08dda7be7377
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:30:58.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sx+7IKbc/LUNn/TMfFN9kdncn/TS7xGApCkrVjHc4sAsZ1I3hcr7ko3hCFXoGz5YK31h3k8Eqro+E5Isct9LG7DTGrAPUIfwhu5jT8ZG1QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-09_10,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=712 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100009
X-Proofpoint-ORIG-GUID: YUdMmRKOzszY_V8DtlchlPBRDFATeKOe
X-Authority-Analysis: v=2.4 cv=EJwG00ZC c=1 sm=1 tr=0 ts=68478ad4 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAwOSBTYWx0ZWRfX0xcCKlvww7YG vaWmit3LnOTBn6Qn5m1vEzWmqKsQP+Yx/t31I4XOOfvQ9gvOexg3utX8blDnSYrkLmNQ0oOyVt8 pytvNlh6M0z6isghwaYXD4eFrIGYyWHHn8EQkGj3QuJltEkXNDMM/nQ3gEJgU6GU17t8aAxd95q
 dvnwzrwLDqkIB1ofWdEAf8116/uxdSH5w5sCS2tSyexqX/V1T8gMx3wtap1MX1M6Am12vCNwzIn qt8uKTXfG+PrKFmp/80nbqS1H7rAg/AHNTk19gnTJ8b7KVALotp8yv0L7TaSpTaCJFFtDdWnUK9 4psoQDYUS63Q+vWturc6MPxS4Ck1HgfxlqIXYuL+JMq/UuKkMoGo+L9DRSE0wCVY2GjEn7wdEpH
 TqjLo/KGedS5ondfA3Z5xBJ5yc6FVBk7JsB5M065PwisFLBxMGIvZi/+TmG7SHeEtkdvVIuf
X-Proofpoint-GUID: YUdMmRKOzszY_V8DtlchlPBRDFATeKOe


Hannes,

> The function fcoe_select_cpu() is just used to distribute incoming
> skbs which start a new FC command sequence. But the network stack
> already received (and processed) that skb, and there is a _really_
> good chance that all subsequent skbs for this sequence will be handled
> with the same CPU. So we should just use the cpu on which this skb was
> allocated on and save ourselves some overhead due to pointless
> scheduling.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
