Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCB640DFC5
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 02:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776738634; cv=fail; b=fJFLKibR4JCV1qhhB9H3c8ZnI8BOKQIQoYYqPG54oussHmAW4X0t6NHE6O1JRfN6CPy1kw5ehbk0JvKabkasqKFUkaIUW3+Zld1EnDDgWNGGWVbR8/gnE+pfjYu8YhKkqvjlp0fOySl40VzwHDVX2sVQtJ+BD1KWvlnp0BcPRgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776738634; c=relaxed/simple;
	bh=c69rXjfnAsgKOGWYYhRDcjQ9Uylz2aQePBTAUZAW5DI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p24YS9DwCVKcfgCO65LlqfHdT0B3lo8O4sbzoIgDq52SCe2/uoMPpTJcXFQaoJ+8G7xtDYQjsPk5lBjGxbUY/CisxMfn4f8DF5UZFZe+AjC26cnEisfzN7uvzyL347fFQndj8pYznjT4dvhq6t2n6bgb/zYYd3VzuNC6tuG4OzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JHgSUb8v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CpJnI3K/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JHgSUb8v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CpJnI3K/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLtYw62109992;
	Tue, 21 Apr 2026 02:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ICySLxGtQ5Y8w3sNth
	BJY8wQLn+gX+hlxqGxBm5ZIt0=; b=JHgSUb8voIVylnTYq6Ifu8ojNrcSwcLR5a
	gb+DeDBbvy03oh8PmS3r/nGb08BTp5/YSUgRQ4WvvfLFX3wzgiWcRnXTCuHOtz6X
	IJ4Rns8IBSdsdkm26uTxb2UUOzVn4c4Yw6HK8RkvJXRaPnHXPeBHwZ/Zs/BbJxC7
	eQEbaPtZ6BvcTftc0+H8Vcc9/K83ollmPdxBXiobHU9M3egbzjkGU54Na+H0hw8S
	k8wYf2y6FqR+IoSq8Iq/aEGzeZ2Dx4MvQoVs04Zu1UbvsrR6vAbGXNVBBt1TaQR4
	J0lNkpD27nIkKoR9gLS14ztQrrrSYWrEff3wTFZHiR5ABK0xzv3A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2a5vjsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:30:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2QFov030526;
	Tue, 21 Apr 2026 02:30:28 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1afeqs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:30:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5QbZlwHprcoaPZ2pK0Wp9t25hB6hTrm87IlB/ykf+1TyzkWadIv0hEgn4xNh69ZF9utr6yFTfNahT+1LT4DTX1gxjXUYqZAZi2xtpvp3cdpsqQvk3mQEoqfkcVeJ2CMZ/C7cdDNa6NmnYp8AikF0592Usum7a44a8k9zItVXX4R7S4zusnh5xKLK5EP449Dk7va6YsFjqD9GrRyz2u+UAJzHjQEKhUh/JCNJD1XjheUOvvaK8Zt+MoKqHCECNn7AIsSOkI5my0x/9hndlQUR2FBevqbjDYPWRQwuWVxdGaWVc9dKHa2nVkIY3/3ihok2L9ZK82aig1/dmoA8gSpzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICySLxGtQ5Y8w3sNthBJY8wQLn+gX+hlxqGxBm5ZIt0=;
 b=LIbETkZbURJpJR+BogeJKzzHYeIfMakFB/1BSZWJelCKPfqAH5cW8Uk6BJ8HFBPx61POvqJXLz86WeErOdKxsa6sIL+HuONHsi0YNwBSUlsEG2c4UsZDWWLDZAMiL+JWl1XR6gCrJGs3Mo43EQ3ZL3AIbjjEgqqUD4JzhFfFnzhApp6NPi0z3GnyCUAdwnfRk/imshiMiV16tMgrzKBBKOGKkYY5etdOzz3Jx4DIpn2zy5+5T5nLLdVl/4BvHWIhaGraLHISR9PGTpKJuTSDEwUNgsafzHjJiUisZ7j4EA8zvZUjohst+wv1KZ2fTiJBJc5Au1723tk8KdMkrfqGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICySLxGtQ5Y8w3sNthBJY8wQLn+gX+hlxqGxBm5ZIt0=;
 b=CpJnI3K/Pigs3fTbHbY1vWgkaS/lH4hBTbOg2RK7cu766OQZpSa4UtO3LHRZEsJ+Pi6ugC33hwaeqfN8CcFij9zdMp3zEFO1ikvtuRgVdfXabL0N3xu7XsJDNd4Gm026XaxycJyBodpXvyUtiIgyGOlzoXlREM8qWFTzKef7bv4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF715E13019.namprd10.prod.outlook.com (2603:10b6:f:fc00::d28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Tue, 21 Apr
 2026 02:30:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:30:25 +0000
To: Brian Bunker <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de,
        Krishna Kant
 <krishna.kant@purestorage.com>,
        Riya Savla <rsavla@purestorage.com>
Subject: Re: [PATCH v4] scsi: scsi_dh_alua: increase default ALUA timeout to
 maximum spec value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260416165512.26497-2-brian@purestorage.com> (Brian Bunker's
	message of "Thu, 16 Apr 2026 09:55:12 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h5p5oxjd.fsf@ca-mkp.ca.oracle.com>
References: <20260416165512.26497-1-brian@purestorage.com>
	<20260416165512.26497-2-brian@purestorage.com>
Date: Mon, 20 Apr 2026 22:30:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0162.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF715E13019:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9a94a8-eac4-49b9-a94e-08de9f4df1a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d3SABWIfYmzVhT/fN/yFCNabvasMzCIQNoXjigOmCFc1daMnCW5Wdxqkr7bRwtAeYa549sisDSNqPfGS8qtOhqEmB9Jov4v+rqb+4KEgjkMXT4viVamXha1dgyRxXh5VFquiAn639+R51c6lJyIYXBK86n6J24HjoYI1PAEV8KTnpeDoDDpxEA2v39pg327nd7NUPpFqG9UJYAeDUU/qKN3AsUBMzm7ycAurqlhPq48v7yq26Jao6ZKL0z20OmbbczboYoGrPIlRi1JMOds10cT0G6KmM8yZm+8MqKt+s9RTNvhsEiCkz/hu92wGb4VE5x5Fn1/Jl7Lq6bZGxpNLh5EYc7NvLpMgMao/l4BQKTt/G+Q1DWxJ7pV1Q6lLpVrFdkkezBXgArKBPwPsUMltmT5w5rtMnjPVfSl1sjvI5Y3IQ4IeKrU4NCATojYUupF7mvbZJhHY3WxnRmah3rx1UCp+uJ1psG1W6JMLwjXT5UGWNoZrQ5DjerZfhjGsY3h6C+zLVVe9ifTVzfaeqMgKgVmJ7Gab1yf7HwTNLR6x6NUtKlqSiyMTbaMh8xVR6P9j4ReHpcFVeLu0WHC37gFlQxg3vJRUQKFYQ1wUHJBBYhh4QxzrjTPomFZ4UPFnC4YsqiK8ImcHxoZnTWwsubLig5Hphc+RPwz2Aobk/4/9C0o34VRBjbF7u3Q7jhDSPMbfqvpvjEJ0mgx9ZRxerCk94TE8GQ771Uf3HXGCMDfBlLE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CZzftng/Iy9/LG7rCexUX8cAw4C79NdVsqfEWFc0byPCwHZ5Mt9S9+XsInCp?=
 =?us-ascii?Q?fnHf6nBULFQjqh4ga/JGniaBORBuiYNamNmEaDEISCZvRTwJasC5QZSzOaPt?=
 =?us-ascii?Q?WICI4Fk1Zd7UaWE8cFZTZKhl7YWYbeOI33zNT80HzizhOrFdZe7FOPK+4vLr?=
 =?us-ascii?Q?Dqh4NF4Ju0Dt0G3ihppbQo/wXrMQlRAA4WZNVllVzX1WHgePKny8NTcwRBWV?=
 =?us-ascii?Q?VvtXGloWAHvWRbvP1sp+vUw1R1hGQY7dilMxXaFtWTrHqHcKfifAM6LoqwCc?=
 =?us-ascii?Q?5HUYEvue/u3X7JnQIHz06JwgZ/z0AsUIREu7h+lmp6TW3qRvZ4iJdzK82fZG?=
 =?us-ascii?Q?f1O5S6EtYvEmn5c03jMK7roet+Pofy1ycb9MCeFZlZo4qpH0/Vi/RQ802Kpb?=
 =?us-ascii?Q?UrPYt4a87sGsY9cXjsrL8zxPPBdc/V5OH4OVER7GSSKpH4ekTtMd/Bbbo1RN?=
 =?us-ascii?Q?aNqkJk/+3pzvhvF6EA5FUnCVNcYw2amNhcIgLWuU2p0kQcEGk9WV5i9+A47M?=
 =?us-ascii?Q?DdYehskmAZ6sCW97X0rHsh0edLabMOpVptzP/07ESTj+PD2Ndbr+nAROflHe?=
 =?us-ascii?Q?1w8ZBMisVtJK9gtil5di7qmKoCaZZJwTyvVDWBuEpZxbuNr3idCxAHcyOd1X?=
 =?us-ascii?Q?mPohEwv4woTb1rT8gVUSBNIhDOpLsA48tqjNy53xmqh6FmTcgFtNaRcslXMI?=
 =?us-ascii?Q?mPwq778RzZbYUe4J2tI45yvIkwkoJpMm/HvbjTklrAegCLQfwJDqSGLCme7V?=
 =?us-ascii?Q?8ExhdxQMEzOmE8KwauHhi3ItPdITvXI+HOIxTmLCtnwiI/Z3MczmVicrzCqj?=
 =?us-ascii?Q?ppEHEZdd3NUJIrwd5lkT/iAsrxKXG/SNe4oOJg52dRjDiAMWDz58Vzdith56?=
 =?us-ascii?Q?BOtdmCdBA46ZBzwRJ4WhDswZJadRLyVnGj5XPFaDs1FvzidOJDekfC0bN8ip?=
 =?us-ascii?Q?Pv4KoTmazFBdMca+q5GJhdhKJTj1JfJSoP8oubhVOVnSgOZJuKiUk3M0NJlb?=
 =?us-ascii?Q?KXTgpcfHl5c0VrH6XiVTl9vjfHTUYfBJ1irpc9dqkrOJ81plVd3Se63q1KnP?=
 =?us-ascii?Q?5LDrWGsPjUHHALo8CmsVIKMUx3Nzn8ShGny/ffrc8GKAbEcqZK6mWhTktFO9?=
 =?us-ascii?Q?Vxx/bq60AXMLTOClKHtLB7k9VUhpxY/iSkUvcMGikXt/2qCGF3beNeh9RAa1?=
 =?us-ascii?Q?Zpf4GkRurtmDxE0LPcBnrcoshhO4702g6+lbTyTtxYc7DztHpiwT900Ekg6/?=
 =?us-ascii?Q?phekExYL/5JP4KmfHahsZBAnr3xCTigvwZz/K3PA7eMvkhSMKG9hVWE4XMhW?=
 =?us-ascii?Q?I/3qWDZhGJoYCgCwCnEkxNvtj+cJItmbmuOXsPQLUrZg4sH8mj4De7ZLRu0N?=
 =?us-ascii?Q?di3JW+Y/PVIFJ5MYGaa5tb2mCqZgUdBxeMw8pzEqBldaV8Zx8EZbvtFkF6Vj?=
 =?us-ascii?Q?RMYbSf4ibAAmQfJWTj53+gSbCQ0Q1oSZfk02rkaca33Y+w6tlaQfEOo9GBt1?=
 =?us-ascii?Q?XzM+P5khiFjJfLccPXnS53MqD1C8NyOs9HdDw0ge7SqxVGtObByTBoQrBXrr?=
 =?us-ascii?Q?Mv81s+T115zWU3dnOA+THbunW7q+N9SXYGWCNYvCXcdMa1zLt4qtOzAUJ25N?=
 =?us-ascii?Q?GB4ruNHPB4le5nQlWuxX14rv5ryYc9DzNarlAySNSY5MHuNtHH+JIxUMbXs8?=
 =?us-ascii?Q?yNbUS3fpwAgmXY4z6b34IvwzHNx6ZKA42cat48vESzhylra3fSlnU2iXhfEk?=
 =?us-ascii?Q?AIOmtobhBJvGF09+672Qj0PH8rrcsPA=3D?=
X-Exchange-RoutingPolicyChecked:
	wdcBN4/zGBUXVKCSpx9MqseGk1e3UU4w5AgNQsr6VkNpGUUPn4dOXFF1bwib4xyax/pLC3jn6K85X98fEHAuctWCnlUdG8k9z9w/YZK4oc+luNbWoVRgNXm6f7Mg9rLVRXxOmSGFOLqUr4yJLyIIJxljKvscdHYekABRyuPgjMCMciL62J/TaJoK29D+jGduFyYrVUa1YdEhziSEAe8Wfrawd74ZMmf+fCyWapH3fvRnD5TndALtyBlzbt7oEpEUPAIYvXgvzvizW+EHHPyTeMD0hT97LZ2g4V1di9HLXzIvZtfNMH0YzCHkMdcOxIMhTgwh8XT44rP4+iJ7262Saw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KTXvfk25IIsXJQrga7ECxxEP2TzHGp89xpn94byGdE6gcMQoOyO42fVPhQHUaXTZiiZ7fsKpr+cuV/WtMRZLLsFJYFQ5+C7rVSyTmrimIwRakSr5lljjG6l6B0XTcqY5siI3mceoKLzsdJefT3Zzlm5qtpEKQXxyHv++CWKavxyZb3DsyaRtv4pTYv67XE6II8swzkkmqkUkrJa1K9wKQRwZjnn5XsQE+gVF6XmyCSwCrWZLX46YF7AedOo2eAL3oB5DTZtKtv+t5kQd8cG10ol+lQOqQX0U8MA7xtSt+9KCZFqfW/2YofiiSBDVpScDgq6KiBZIvo11Tztq8qZwH/g2mvvC0ihubNLDJmL4fGe5bhs54yJ2YR6dqtdBtiOeejspwTIjx4AZWCJTDdpzdIO3HPQKty1lEKhmji/cYRtQrAeA7m6lvViieWiNDIpK7B1/3QcPt/WfVxVXnoa/CJL4FjjnFF30eWTs16EMl1yRsGrQr+s/kqP0eqWl1bO8B82iP7XnNK1Ixi9ad8u9Kbm1cJ7IWxYIek2RQxm1lopfVNKlGUbSLt/hvdssh7Y5LRY1v0CUvoX4hx8atz6/QO5zPdCWAYlK2RhMEZix300=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9a94a8-eac4-49b9-a94e-08de9f4df1a9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:30:25.0612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5D2tgcYA/5fe8fr0BoqfDPodPDhXrSJAvaLVpKwAwofg8U2C/i0maKDFzECm3ZToo8mj71RpvWZhHtIZoeSLA/rupLMsL/5XAxY22L450s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF715E13019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=971 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210022
X-Authority-Analysis: v=2.4 cv=U46iy+ru c=1 sm=1 tr=0 ts=69e6e145 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=JBNebbC9HC7U5k7cQ9AA:9
X-Proofpoint-ORIG-GUID: EAQ6a5-lvIuSSblIzuoIol_znqYZGk1k
X-Proofpoint-GUID: EAQ6a5-lvIuSSblIzuoIol_znqYZGk1k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyMiBTYWx0ZWRfX2lFFEJVw3QYg
 pPVyE1o/mcSa1qXdVz4Af69ddcI9T2YtSVW29eaSTKnzNy2k0fyrFMiSi/jRulUI0KZMntHcCDx
 eldT1eiF2K4mM39629Xa8PDigmyVermdkeP6Gvklo1fnCbi2XFcdbAOGoiCjXvjbAGmsSKnM7y8
 R8gqCHD3yESUKGgjzPZNGmkbrYHLISDpzoA9fe1/OxOz0IYTgR6e0TlvOQjeAOHoVqHND0/ZGIO
 vj+HdztYFDzWPBdLJxyzS8676Q9+IDB4Wm14HS3TLBXq9ejqfG2SHHSZ2vyUO2GD+Es2Mw4eiPB
 9uu82DFE3lErNbu1DxDRKs/EvNLar7NakSyGcm9ZlFTNprX2PDKSstonPOYd9ihm21R1e9+40tD
 8LWyBpFbBJpKpDk4Rk7ZCG9ePdHBRQIiOeuc+NX3VFlSL5f/6jJfCso8N2PH0j3OOVoLluL1r66
 EuKFZ8Js0xkbAMxWNDg==


Brian,

> The ALUA handler maps a 0 value (no implicit transition timeout
> provided by the target) to the ALUA_FAILOVER_TIMEOUT constant,
> currently 60 seconds. This means the kernel already does not accept an
> infinite transition time.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
