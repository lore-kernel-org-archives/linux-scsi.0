Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2126D846C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 01:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655789; cv=fail; b=UUCGIyZYpeRfUfce1Byix/sC/H8qjmfEuw6aoxASrp4pzOqxIW2BTTrfF5XXRqhkypgBUNA7vYK4wC/DAwkbWTsqF8u9UTt3gmwPwELAf2lV9geeOr3ShdA6A88kBMwK6LHj2ifxE4aS4d26tbhHqgeTjt5eUIKPbWwoPi0/TME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655789; c=relaxed/simple;
	bh=4pSsPO55FundXlKI0X1RIHNmrf7wF6KA7uPHqmSjZoQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=S5P+k9WVfA6ne7W7iGutSLfYWCeU6bbduACvZs66VXq4DPJfRmhf8k8dUys07BiCOOoET+Grqo0pNrZcsqPTcTc3bI6lMt5m5VcNi/totJBK3gVsz8w+uHFpFUbu0/baMJGgvR+ReSFbwQzdxStpk++LYi9hUNQmSVSs0Bgy8X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ne+uaXlx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x/19nFj/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ne+uaXlx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x/19nFj/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfr3o025198;
	Tue, 11 Mar 2025 01:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=LIgMXAHR2K/9Rf7f8T
	xkorxazE3DExLbWq7uP1wuZtw=; b=ne+uaXlx4p4Ok88kIX20h5UUIuULXqoIRu
	DlRgDSdeDscdw7qcJp5XX8Mf+bi86iFwR7Ug0F7jC5DfC6wlylf7I50ClOwmjkie
	g/P7hVGBhJpP2uUxA0RDcgjFLB1+m4M0jaL+ycw4Z0Irr669J2jDqnd2dXnvk2MW
	fuAFsx+IXbi4ryHPv+HmXcinpmInMzUDPuBXM5y6kCtobpBHeyN1E5u5lHqRslC9
	5EGNhlormSwqxeGyDDT/0M63vcN4DJ/+/gwheS8pyxyAHuuZLilud2jF+UD7C17z
	ruNrUebXlreRAjiedhy2xBeKZMWKQ8Ufp8r9NzEJDdKgqFdFoySQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458ds9ku5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:16:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0H7ND026199;
	Tue, 11 Mar 2025 01:16:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb8c8m8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6pAXASZacBSgcQkBWT+hj9qSnT+QKsJLW8MdLMEdI2tyTiXItfkkiN2xRSb5eQzJIzUgNztzj60qxKbPMiahuu1WlqzQlk0UgYfHFxjoJcD8lMC1Z8yp3r5WofTbGadu2kVz6GLZTDJDykYZAMypB4CL3NLTEWbq8nTtbKDt0L7RM4LCN4pNAKBfcvuukZv76Qjr27GFxNWyWaJBYcC8nViD9zvEYsvthZOK+57iQp69gV3XmpG2a/fs5LaeocvY6Ye1TK97JksDhb8QPsF2tRy5wbHArVhxnAckwuh9cTzHgbmeOEXYO7qURAGG8zP1gdZ65fNLAO1Zs87mNQAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIgMXAHR2K/9Rf7f8TxkorxazE3DExLbWq7uP1wuZtw=;
 b=afyYOhbNLlVfRQXhRRVi3QWNo5vtTKDG7xtVfVJsAiLA54xKIJIas2CDx5rn1APghhfDBJVuPmSoNMcoNWY8WH4ibq6/Yy9pMpfYyT3nGVaUgPOym5pYC5mmj5chfvHhNXJVW/q5zftl2aUcFAl1hIXm/qSjcH9P59qRC7E7oLovr0j6QXhri0XLSCwYaeF/1/+/5U4Iu6Is18d2l1EKmtaRGIXsQc1U3+XHw7pQWoZRN9NrmKNhu4g3Yw3cLvqT8n/hZWFr/FESt6y4Ec8nxJTdwubt+cyqfXgA3D0ZzTpbWWdTl50RmVnbUhwDeviahe71izPl+U/1z19A1KeSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIgMXAHR2K/9Rf7f8TxkorxazE3DExLbWq7uP1wuZtw=;
 b=x/19nFj/e0NZNp1FRIDujGidsqbA8efK7IlekHcvY76e9Dy/3ceEId1wenCZDAENasAp/ic3ztKDtsswPePoytzqcUGZfwxZYDGsgE3XTEaiswXQOQhNfcwcrPRktx3mzpJpOGYRF8TzSh3wd6rRsy/JFbPOyT8EKImW8zijTyQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8137.namprd10.prod.outlook.com (2603:10b6:208:513::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 01:16:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 01:16:11 +0000
To: Hannes Reinecke <hare@suse.de>
Cc: John Meneghini <jmeneghi@redhat.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        pheidologeton@protonmail.com, kernel@roadkil.net, maokaman@gmail.com,
        Sagar.Biradar@microchip.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, thenzl@redhat.com, mpatalan@redhat.com,
        Scott.Benesh@microchip.com, Don.Brace@microchip.com,
        Tom.White@microchip.com, Abhinav.Kuchibhotla@microchip.com
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <84a87c16-0738-460d-b83f-55f8181d536e@suse.de> (Hannes Reinecke's
	message of "Mon, 10 Mar 2025 17:44:14 +0100")
Organization: Oracle Corporation
Message-ID: <yq134fkjrlp.fsf@ca-mkp.ca.oracle.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
	<yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
	<PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
	<8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
	<yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
	<2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
	<84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
Date: Mon, 10 Mar 2025 21:16:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bc7b7b3-9bb4-45e4-dba1-08dd603a4f13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?10BKQ58x0jvAfGYlTbZq4hghf6GkAfaQQ48vAqTTHotTiX9Vip9fD/FcHMxn?=
 =?us-ascii?Q?ol2yq7qgjaBGRKkZiglFWQl9NLcV0VDB+kmyMnpj2BsddNzFsxsnlL1oiN7n?=
 =?us-ascii?Q?X90mRXfJSNULfxJkVBOYlcwXvY/1fp5rig5MuNGLkeaFgw7BB7THgR3JY+An?=
 =?us-ascii?Q?6qVzpIUZ/eDCZoL/L8iSNfg7nCPIPYy2zZvKQ6Wd+7KyfDwAOw8xt4hHBIaz?=
 =?us-ascii?Q?okKmYmZxlswUKM3/Mqa4JuiWQfrH0B6ueOxvIWOJSWpNGa5j94kfSdqWK1d2?=
 =?us-ascii?Q?aD6cPSI1dWWxAioR4gahFoziijVI8KNiWg6oBfx5sxbU7lyI+2BPjut225we?=
 =?us-ascii?Q?k+1PZfl7QYvoCvYfZfllSTOVnT8NOm3PLojlwZth4NOg+gA9UNtb5dMeeYGf?=
 =?us-ascii?Q?G3BFlhPEwPa5l23MUvvS6LPP7bcA3/e7sgNPMQXHOEVw1ZpP88hlN42sfTgQ?=
 =?us-ascii?Q?OMrThQ3ntsST7VuhyPjPtnhI59JlVh65G7mdVJOwOTHzhmHJgLtkCTJE2cKt?=
 =?us-ascii?Q?xwOML9gz6soh4F5kELkR2Z10vHm09Pvr6dJLJxaAw407eIJb/JWPOCB95q1T?=
 =?us-ascii?Q?mLdZxKFPHK/cMMJBzjL/k5/vlDmDuctxaLJ7o7AGqxLZ1PHsKH2jT+IiFeqP?=
 =?us-ascii?Q?IEft4eJnE1yqzj7Tqyj5Sd+jJ30hS4gw9J8nE5RJTkq3CC0cFdCfHrlC4IaE?=
 =?us-ascii?Q?i4mBdDuI+VTRCLWT3DQvtutoPPhP7KIlroaFSOOpMoFzijk9nieiJIfenjQb?=
 =?us-ascii?Q?LqSQCuC/WInUg5gLm6FSkoSw8SqgDFG2IBfXz0hmA2Pr8+sp8tOlzEqo+Wsh?=
 =?us-ascii?Q?eN1S9zRgZcJJ2Xpz/ioPAVbJlxAV5AYdfRervdh7W8MUr4gFiqCzwed+25/N?=
 =?us-ascii?Q?ZRN0ab4y/o9IYrBZJIy1HUc9/O9LQMR7J8UPH4l+uzeofObx8ZIBImknWnL5?=
 =?us-ascii?Q?GyvkWCo4Z4dtrhjOp6WwwPzkkB8pXoOLnXDh4HQEUYbRj9sJUipMCId2vy0J?=
 =?us-ascii?Q?mXRCnn1MmwoSXUDR4xANslIFhdh/Q2fLM+AzZfSwxXKGzbPAmDb5EIMlfWZ6?=
 =?us-ascii?Q?FRGZWVpHjpPHTNSMSvkevhq9IOUtg0+1OcE43ccGrZeBDlImsqh/xRPui45Q?=
 =?us-ascii?Q?d67xkMj+CURvYd4jttSUFPfQs36JC106GoA5DM+N/XUfSVbRAi2kTiKeJ05d?=
 =?us-ascii?Q?Jc2V9wNtwHtue+hhByHyQY9tsP1tknh5WklFkh+jlGd+OEoeDpz+3hbRr0JZ?=
 =?us-ascii?Q?SvlG+Vh2pntChDUEFfOMHr7hpHWjmcXCjBgmjR4L1IGnvGLD7HUWJPFFupPE?=
 =?us-ascii?Q?gzm8OwTIyPJH02KdpS84x9oYuNHH+I/9dv/rnaDYl1+9ugRdsrY+jWUkcCcl?=
 =?us-ascii?Q?DZ17bvFr5n3f4sk817LEPpZZQDwY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D7vGaMBX8QqIuPoMy8rXwY67mJblLUNZHe2cj56+HYu9ApGMT26kjuVHH9EZ?=
 =?us-ascii?Q?Vuw1GZXcOtCsr7BT3y7W/6IVsFnx0CHn5QiFlZJe70l3QCPzKbjJ+EL1jnt0?=
 =?us-ascii?Q?XElE2jFSutQDrty5QAHE+NeMaAcylqgnWM18IpCZF3i8+AOUWBw1b8lPBJQk?=
 =?us-ascii?Q?Od6t9lsPcUFyJ3Ch73ulGzqhhZBrE344zPWPPhpxFa66HE2Fe4WGu7c87Rck?=
 =?us-ascii?Q?0fTZFP+y4sqA7g15AUw46Ln0Z4/PcofZDGZcmBnDqhrHO1XuzwpVM+9fJmyb?=
 =?us-ascii?Q?YdADWdMLuXXtVhdbD6nAUmtPAYYSVX1Tw5yS8YqcM+9p1Ry8sM80aXp/Qot7?=
 =?us-ascii?Q?WnCx7iEGVmxowYV4BWN0dQBmegOxDtLlD9rNF8qoo7JawxPSIDG0jmkl2ADS?=
 =?us-ascii?Q?z728thPWbbUmfW1BIpDR8yPl4biFo3Lm5xUHFC4iW2StWqPRZ56xADLv3zeu?=
 =?us-ascii?Q?JScIJiw7NSX/hXfvvKn1gC1JYjV9es7y0vxFHVQi4kE529+QoPjJt+JcnAqe?=
 =?us-ascii?Q?1ZJZhgzKo9KT+mT3aLJAngmPBZ5Xm7nfhD2ImWAU7OWLD9sd7T3etlzCdMrB?=
 =?us-ascii?Q?Izx/XWCmAtGtB6df/U6qGFpI+HisMAh3Bhnj95tF0vI7BZtJP9LKeb1t919P?=
 =?us-ascii?Q?gHqWDX931YE7lUaKco4KGDgY4ufCulgThzIsQEoAmOSYcQUoncTj1H2EP5+J?=
 =?us-ascii?Q?KwVleqtIN11w2NpE+PbklHDUnrNRMO4uoPwoIDV1QR3v6zrH/8nEKFo9uYnv?=
 =?us-ascii?Q?lT19hLMEp2XYZpPGCMSMPgK/tdOmvFxogOTHzl5UcrX3JniYFeyoh5UqAj+x?=
 =?us-ascii?Q?RVzCTNjCEwW1medgAtVrmml+FZvtFBR9o8WzNEqtJPa7lX74JGatzprS15f1?=
 =?us-ascii?Q?tNFl2tiId/MgMmG2u5vXFUd/xNuU478DS+t1/b37lBldOzoA9ZvZ75k6fhJQ?=
 =?us-ascii?Q?ZC1gQs7BncMCNnsBd38BR0ir5Bz6KMQwx8cKpyOg2nf12raQZR/qjRLC8X20?=
 =?us-ascii?Q?gvDSLr31d09Nmx5ZXzci2V1CK+tzDdw81ub2BNfZxQLYGTxHpDeQeW+dhiW5?=
 =?us-ascii?Q?BrVJLxiJxRLzf4GC4dgy6f1jqHpw9nW8CqAuuZfVJE4OJvg9lJNyIDewPOpX?=
 =?us-ascii?Q?Bvn9nsM+ij6dZlSfRlTDm/OCQKSa24GGr5L0KwgAISPRPjOtr3TaKBoXXFOp?=
 =?us-ascii?Q?sHFZw5qIektKd4rzR40nrhPwvpO4FNUzUy4sDU0vxhpkz/t0aQq1lTKNtVNw?=
 =?us-ascii?Q?tx0tWrY3Kky8ssoOsANfk6PA25lG6cMLw5SsexGiSjlCgskg5UwprUJKROGZ?=
 =?us-ascii?Q?fjF8KPwLd6cQLDHQhkui4TyENHMIes0C5s8QL0Qh8LuEPwopUoOf5Yj1QQ1A?=
 =?us-ascii?Q?jEQZlbS1pa0Dhy/imrvpOE0jiz6vWKBPRYC7ybaGU0a3pCN4rT3367cPrntB?=
 =?us-ascii?Q?jPurXzCwguijluZuTsWHoFbs1ij5LaxIgQjyaFWYJQ9/JcQ1kkv4Y9fcLRbN?=
 =?us-ascii?Q?wKpknuWxsjyrh9ylOn2R3CtFr/Y7P1VMn+TDf1k3OOu9aaAt/aQhLdmkVnjJ?=
 =?us-ascii?Q?jvP00mwuMTl1FbOAxi8VgxdQDXMKiwroqPqsPCrS2Xo7eG8+ljYx5FAyBsG3?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cy0W28KWLKhBnIONJNhhcwBmLjtWgiLeX93k4g4jpj3383dTU4uaYOpcgtK0ELINru3D4uj1XnN0aHU5IsfUdBg/z6LbC8UoTXSdl7xVq0g0JXbT7no7ZR8INVverdwQINYQHd82DzU4zdSPMKv+GcH7LvLnpw5SoMFBJarGKn6T6a/sf0toyDPN1AhQHzpxeaFkevKr1OEUoYEPTm2pcGy0dB8rvngxCWYwa3Kx56iJqasfj9gWxxNe/23mr1RMaSDWNNa7MPpaZrVjdrUlNkwpPv+8lagPOtNYpjjR0gTzXHRmks7lZbD6GDsa1gm5c2IGn6nDMmzFb6ZGy8VHgWAw8xO78HmUBeoXoj1ni42BK6uhMUqEtszBsWDM6/ilqp93IrIv1HkZkTSJpFHh5nS2tF6QAisNCTtdSoaY6WmhoRChyrtIZKCpUvM+GkSwAEcEtVVzvwKtvneL56lWTlVLygMwFfiUKgEczojPUd/SWYOpHJ4d8P4GsYccgyBGiNDLYFzVBFrWAZ4kBpILpFt0ug/X4D+8Jrz0PvY+Fon/kzwZfRpk93mj883HFuvDlaDcgk77wUc2DK/wZxtZVOcYczeI7OLudqWJfszqTlg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc7b7b3-9bb4-45e4-dba1-08dd603a4f13
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 01:16:10.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dc928/xO9Qf/YorGVHVS/W+fXdb+F4DvRDRX80fyKLJnCNiWEUp+V3rrebbl7vQ2y1O/J5rIBoG/oC58ro2L8c8zi+Tctp54VSfzcfeBFII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=843 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: DUKnP0yfXwWJZSlsKmDOm7a1oauerMoT
X-Proofpoint-ORIG-GUID: DUKnP0yfXwWJZSlsKmDOm7a1oauerMoT


Hannes,

> Wouldn't it be an idea to check if we can make this a generic / blk-mq
> queue option instead of having each driver to implement the same
> functionality on it's own?
>
> Topic for LSF?

I would love to have a generic fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
