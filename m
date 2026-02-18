Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8844CB5B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 02:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771381953; cv=fail; b=bHHEF/EqNVstSBXTT9dzT+ojxsq+s1TBh1PVaC6EoFAM4pQGeGOS+7Lxr6n5Dwgc8XkTOJ1m/ESV8AlpJ+zRsqWDxTgWJQszAeWQIqHVssbNgizsIyxLOa5h4CMQTB3tiODrZ+TBspv/2ynwdI1tpD/oYWrVP2mQO51EFZZt7ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771381953; c=relaxed/simple;
	bh=yPJAQrdzBMhK7LNO5pwPKhm5t8giIykE3/nuaVUkyEM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SZIgvR9RCMUa4kPtok2Z3UdBwAFmDxGOzI07Z5Uk+kOJPMrPMeH/Td0+5+AsV8YUCg2iIhv+H8qGR/+GFKdFGU2QJYpGVD1kHhNNY3OJ8BP2XrLFVB/IAupAu5ef7OsumDnRfNnW1n+ZXCNRKagdXxOC2mmKQhDtttYMW89w+mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GG5ZtuMt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XFoIoNp6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GG5ZtuMt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XFoIoNp6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNTwq250938;
	Wed, 18 Feb 2026 02:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XNlKQ2CLo/tgcdH5Je
	fl7wk8Hu7O8SKLxupBDBHdetg=; b=GG5ZtuMts4QiXOOZKF//hwnJnuicA5Tqd8
	0LE9zTWkkXzZYg09jfLtmX9kqQew+U4crIUzIX+NVjRXLxF2kVZ/6v79//H57s6w
	PmfSppXnQ9AkGUCvMeIUYyURWk+JFV93SqZM/PPEkjvzt9d9Duyr70O+NMvO+4Yg
	00hIQT9OybSYzU5vU3byycHghN2NaxmyzssGd/CgFmJvaJiNUVXKsTQMXVnMB0Aa
	3W6a9sLq0/KxTfjiJbQFRhfdaqXUdoYq0E8OYnICGjIboIhyt91ANbh6dHvsnAK9
	Q/GGWU0yI0LXOsPLgwMrVeQGiesF2N4xFPOUrk54tohWn3wOTY3w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0wmrwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:32:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I1qShN009951;
	Wed, 18 Feb 2026 02:32:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb29h05r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:32:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uh4nA13+GNFbg6porZmSOqDP4FwuAwXPtPb6B14FKjTxNm2bkX+CtLFzeTgEfx7oKbGdsCnEJGYLnS/w/kY6NuAZS1JFNI/+RrHEZG5uxpbTKofNiX6co4zcyrksCjyiywy+9mMqMqH42QFlY1+YYG8qAILPZgD/g95Pk2S+i1JzG09S97KWxzp5ma2SismrVBFheS1SiL0asVOeNAHkuVQxMnAepSF83tr2pNnQhR6DGOjKMyuzOGq+dUegucm0isaqQXYJRJkGh5s/9i7QtsvQ0k54pfPligP2KA6HDzrX0Sp0pC9QfFnLigiiTX31A7DjscBt4HYw48kx94s89g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNlKQ2CLo/tgcdH5Jefl7wk8Hu7O8SKLxupBDBHdetg=;
 b=JGh62kV977ByXTe+9vbCdualzqMH9s9G3OgyJKXLa1S3ITBG29uuP0JEkf02a9c16R8ZPrH0HFalrIcmOT5UkziuJFxouR1OA9ZnV2/UUrMaG2D1ebryz2FKILiPGgLDw3Mbc/hlSPcAEdw3CR7hKrtFPjS0+Snueo3eK5zaY2LqtRv+8Y4LWn3XAgPWKjv+KIVeSnucs/wOjAFWhUpAv1952Yq6NGbmuwfqNesO/LNtALsLgxi8y4djjhIae51BJ5TnQs0KkvkkMkw5cJQ5xkSMahq5qZXZH0VkrAO0Sn/Y7GzHLx3PCQbriTQECrp5pic1lilczWEF5caaO9NRRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNlKQ2CLo/tgcdH5Jefl7wk8Hu7O8SKLxupBDBHdetg=;
 b=XFoIoNp62qGKkOJAkrfie2wanw28hJkr8JYdp/aRONykdw8fFK8OjIJqierMZIwFYXxibeHpheTU7D2+eyCWaYTZJocD1DxQG16XJY1ySzfB7q08zJhXL8GKcxtrH7987/GT58cNmzFLu8XC9pFwa38R8kLatJ1TlnedQoeru9E=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6286.namprd10.prod.outlook.com (2603:10b6:806:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Wed, 18 Feb
 2026 02:32:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:32:26 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Add NULL checks when resetting request and
 reply queues
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260212070026.30263-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 12 Feb 2026 12:30:26 +0530")
Organization: Oracle Corporation
Message-ID: <yq1fr6yeq93.fsf@ca-mkp.ca.oracle.com>
References: <20260212070026.30263-1-ranjan.kumar@broadcom.com>
Date: Tue, 17 Feb 2026 21:32:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0171.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: 59949a52-9a14-4bc0-4f87-08de6e95f447
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?qtsTNK8zh65iS5s2jxIaVWctxzn8eHM3kGmQnUnZi8m9oA1JxwUpUPy19tTs?=
 =?us-ascii?Q?vCFcj8gvFypyVJH5K7xrouzxxV/4J3VlyIOcfwGXyVqhKf3tdCs6mC5lwJzq?=
 =?us-ascii?Q?ElkubOSRzKUobnVpmhQuSbHFhXT65bTN+ll14k3vegEr4xbSNxJmo7MWFhwb?=
 =?us-ascii?Q?SAuA7sfXFQooqMdFtjC1A1iKJ/IAlg3pf1znUF6NBFZ6tYpHijF+oI51NzrG?=
 =?us-ascii?Q?tdVHuJjjgnBwKpiOJhKgZD+oi7vdU75hEYxeHJInIFcWq843d+L3Q0UM0/5e?=
 =?us-ascii?Q?d5RJZRysJ4XXxT9tzViZbvVCtJ+pRjplr7wX9/T5Gaxhy4IDWZGEv4e0r03H?=
 =?us-ascii?Q?ouc6jdYumYX7IJ7bz1JZC3mGpIFpx2lGlHKWyNnfz171kngh7YJ7+4UXRfYy?=
 =?us-ascii?Q?05hbkzK5Rvk47xe+Hl8FVOZtnntHw+kuupDWT/DxHhoO8IUkK5P4wCHa8l7v?=
 =?us-ascii?Q?TeerArYrqffcdot6TGmvE+d0FLcxWnx1lRD0YgEnwFk1q4aHl+6oiw0DkUbi?=
 =?us-ascii?Q?v+3VxG4skIHqV30c3VDW8pz+qzUuatAlvjwEoAe60iE/b42NrrH7slS/u9xL?=
 =?us-ascii?Q?Pj236sVnaVpChJ6l7CBezQw8dkOftDDVqRScAj0RxTMYSahqCfvnrC5PCOzx?=
 =?us-ascii?Q?0vPBw+44NTZAZDSHHJLPiqEQubYWDmMOHcj/GhB/24df/LIqdbFhVAUocFQm?=
 =?us-ascii?Q?anTKHgXOsbrQtBzMY/Hhy5rn+gYye0gHsOBvS+k+VnCCHk8OnzKMV+cwc2na?=
 =?us-ascii?Q?/a1druJ4/+8tjpyXvvLcTwRpBQ1Tn2HNlKW5ID3rq9DEeRx8ksBDB4yq3Hxe?=
 =?us-ascii?Q?Xse1KhqlG8061Fojt2YA+1mIsAVWuNaGojbZPhp0nFaUB2qk9SC13RUGesew?=
 =?us-ascii?Q?Dozh6dpf1yDHmWcSUPDvusCiBTPkgqbYb+csHnyEM/HR9ksb3fAomidBfC0K?=
 =?us-ascii?Q?c5crtSfe2bas1Os7XCdKWg0SJY/rEZlziV+hWqbA064OhFVMpAbcTjuhyY1U?=
 =?us-ascii?Q?cyuf/QdiL8qYIF5n55FCS2eZfBOvCFYNjlyndev/P8OfHmJGKORofu50Objr?=
 =?us-ascii?Q?EU6RRaBnTJ3RbNWf7lcyx11cWOG0QI7jm98gvF9AyuUW9iIfNcCOrNc+uvJU?=
 =?us-ascii?Q?0kRj2H8Jhm1Mksq4JAKrCLy3aLc0uUmQqYWfDXZXQ/7Wl5dYjkzalpaqTf/e?=
 =?us-ascii?Q?u2hdwWDUpOLcYjX7mos8Q2JieLUIivp1e5zs2Q+/msekRpH2PQ1sw6G46Z7S?=
 =?us-ascii?Q?Yq4CUkPBAGX/hXq3jrsRzF/S/XNruYESOIzxDX4sGqkH6u1hQ+diVgFVTxbm?=
 =?us-ascii?Q?mJZCHqGhNSR2vmhJqbx0Idup/ODCsJ6NXn+T6s1zqIpBumNJHAXHHldWe4GB?=
 =?us-ascii?Q?yAq9qpcteLQZlzbkx2D9ipaqRSb4cANvjxlGz+YHH+aPQIdBAKq5GjG08XKQ?=
 =?us-ascii?Q?j3TAB3HjoS6Kt0ftJYdMDjtkJfOD9DTlfnOI3ZeA21ANqRnMMP25EZKHd1i8?=
 =?us-ascii?Q?CJ6KyMiiUSWEWXaYo28M5wyKhIgxXRUaJgR+iVacHhB7a5soYNyCjr6QUFIM?=
 =?us-ascii?Q?ja3YkZHc4BFCdXh8cYE=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?GuayyYPx+zsb4dKfty0Hf9T28vIee/plN4pBTVEDLHK5XmQDXANytyVggwsU?=
 =?us-ascii?Q?xGmo2XPdq6zM4Oi6ZB7vjgpNBy+TarrMszM/w/tlPeXJQBAEEDizC7GKVujw?=
 =?us-ascii?Q?ajldhW9OJggxmhiIvv3Ss4AyXxBf+tom3z7QG8TYV+t1mjKRS3hEtACUwlSw?=
 =?us-ascii?Q?bBAsAwl8LAQoGC2Igrs8RHEs6nnePHplC/Qq0pX5Y3OmxdvkIGKko6ile2A+?=
 =?us-ascii?Q?BdRcJqTNBaeAqEc18NIBa3Ike4O99QrCnyPQRY5qSKlBLISAHWeglSlig2lY?=
 =?us-ascii?Q?H7RZLxNiv/SOQGiABV2JvQp3tmvmFp2kKo02rdtF3IDGhzpSLaK8FmWRywPW?=
 =?us-ascii?Q?UP7k+nyLXvdmcNpBBW/9j+gAKHtypEgopKcp6BC/sH+HKg+2h+81kbynVtsH?=
 =?us-ascii?Q?ABd8QDbwrzmATFWa75fmjg/eOmgLXOMb4JcpLmzN/r0s22f35I2yA4wgdt3n?=
 =?us-ascii?Q?zGmZrCOgokorhgqLRWKe5icL8xfTdCP/936QXOHLoKg9z9Zqf00J6vScMZvh?=
 =?us-ascii?Q?CwL2l2t700rZBG9kgewA4OW0WJw97BXswtiVylewj0FNxZwQssCm7rJCv9rF?=
 =?us-ascii?Q?zoaALPfeGtfEsCOdqKOQbps9WVmifoxAAMb/OPAzGIZ5oZ9J3XYOHrY6u2R6?=
 =?us-ascii?Q?DLzN1gyInOAT3WYds13u6XvTQ4X1Bx3ZcWjD/d6GN2OtjDgc15l+8n+0vLoX?=
 =?us-ascii?Q?dOLHj8ZbbwlCssSh4tYErTT2WU3qwTYqMozYKbTmdtZx87GZvQfFnx9CkGkJ?=
 =?us-ascii?Q?805NEBlnCYUgS+7FMruOvQ6axS2+rg0v/ppvP3D8IefgI3QsdC+3A1WrcZhB?=
 =?us-ascii?Q?mRD4eMHo6bDT05+qpj69FYV3mhKKF13+lA2OmiK5ZTpRrMqeMAzcB0jdCiuK?=
 =?us-ascii?Q?Lpm3zQN+rQiSF+nuq2BzfxLxfrIjgRh23qHOOT0TEoS/zSZj2Ww0iT54mKPB?=
 =?us-ascii?Q?v/pJg0MUsJi7m36EG9jM2DRIpHuNrbBlkWZ7Oh99tl5FEhgCD1IgzPwm08Sv?=
 =?us-ascii?Q?hOZjDtriU/vLgy7t55u+fZ8N4wHfQRURocOSJBpOGjEDPbjDSEfkCMXyeDbb?=
 =?us-ascii?Q?3I7A5bBW25TNVeRxopyeWkC9o4Nz+PDBVIcvFj2K+9pz0edxFkIl6hVS7gDK?=
 =?us-ascii?Q?YelfkpQPJk1JUnP0r/RPmL07w8gkTqg2LsSXRhNvyyUXxAiPVJyeaT21Q0BB?=
 =?us-ascii?Q?6t/MyJicwhHwYplBHtsQE8NSSkaa35FIDvvqCW0fWYYHfqYYkE+K2nX/x0Au?=
 =?us-ascii?Q?+Ibe2JvpXJfom2A6jGjmY/4TsTeKSsTqzLQ6oJJT8rjxELNsRQP/0OPb7I03?=
 =?us-ascii?Q?cF8c610dy9H+/tFrL7wo15x3v2gEaPP/jaCitMpZLbECZPJfg5btZS/gea+5?=
 =?us-ascii?Q?D9XdpUjV6dwzSq+FBz0qP6AzLVCF8GAbuaDhnqcp5rz4EUtgrNQuKHbjydob?=
 =?us-ascii?Q?4YCvugHmvLDlBZdWgz6ByOuwpGWBD/kJY5KJui/oUDaQ/JorJQkb1M43NKRe?=
 =?us-ascii?Q?rL/63wRH3WF44kcyw/EEFPjlU70GG8fsm9sukU0MDlMU3Jsmkb+QgCeuVdkX?=
 =?us-ascii?Q?aWXsq+SsmwpJTd8Flhk4LOthqAVp4FhZAxK1n9zXQNLZDWguSirBa5OD5jup?=
 =?us-ascii?Q?H9OTFsIxUIQAOebxIFjZJwqS0M4iJ5G/zQLxhOwd5zj8EyfdKmvVLAQ6Pi1y?=
 =?us-ascii?Q?/sh5gKA1QJe3ECqr3q+1AQdszmjLXIu2QI0ED6YlM/qvf2+k7WtdEbh720v8?=
 =?us-ascii?Q?bEaSFuJwaJigH/R2qkEtROtBdhJ0GDA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	roQZRJ2Rvv0VT3HLRFzbQ7EfXJwmOYZjgV212SoKlrbXpQpzEUQLfKV4bC7WWB1aoiViuOb3qU/0K5WJafgGN1hNpxTHeJTCMNrhKcWUeHvo5+mOpt20F/4Y6gCC0w8RYAeUSjFXlmSPDBu1BNCRzP1UEM/DL3C6eG8mGdFRCZZBzMByH9lP+PTsPHO2CPgcCW0pSRXtQ+cl4lW7o3ueRyeGf3WWywCRZOLn7NLsv91mT69g9poH87GFX/e7yHLwumP3Xb6Vi0QwdZ6Y6SPldUqfNfDcC8jps+2KzP9NUcUM2u6jClDvd4AV9JJaABuHde0+Vvho0SvVJ166/N/y5hXqMhiY9uiD7Rqxi71HPtLkBK9jAW0Jx7USx5s7fX8nDYENGkp6L3+gqiUBMq4LCTH8QVuRNUhfqzmC9lbpOCbKUlp6+tZykFgu+xyqAfMov4pUA/1lwik5pn7lbWnqOdT6eVdl0h8EW0l2GiaWpU0u8qu6mdgqnwizBINFJ3Y/Du+PhrmvGN8rVnrgo10MFX7PvDG0xzC5L7TycamjLTlyJ99V5OgPx27c/DvDXuk5R3MKT2VW4auYggmGMmpiZqWk+zi/AP1WWArC5hfUNNc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59949a52-9a14-4bc0-4f87-08de6e95f447
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:32:26.1956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWAeD3ihof9b5QGTU4aj23NCWxUhiKnpghdUf6lJk7FA5PBL1vSW84n95n50srz+vRhcnK3IJdPJ24cQTnAHVk3S7Fn9PmFgqeFgCDp1+NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=759 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAyMSBTYWx0ZWRfX/u+opwZZJJJO
 /okw92sZBZWQk/1JOuQBEIaLlxgQiw0w02r8BHNvUaCdhMkORpctsVwdSfLBUZzXURhbx+LlaaX
 XbV6m3S7MmLsSf18Qze61gH9xVenVFweafrAsJgsN9bMgvy7o8NZyqRoqHtlGso2eo9uEBqZGDo
 9sIe3ssBXMIHqspzMfP7M9jFSWvB7fx4LkQLspoEXgMrPOE3cxTZz8zg+7JKNC/EjIa7CVrNrAk
 r57tryrIXXjpuDyTOS7a4kvplzQxy6zPwHCAxoWGYQs+g9Q7ZKO7tzSylE3aJxlHT47Q6ka248Z
 TodJBH3h8nmH2z9r160NZXzh7jS6PvKMf+oQkF2WcAYqLXSCq+RzkXkNmhIH0MqbQqRJNgpSSDG
 pBvIN3iUCX3E/LZnWKW1PVzorKeiqKgBAk83Opti+dq3UyMQ5aTMF66iPJtpFJ9JRhgwLf87LCr
 9uti+cHYlOoECb5IZzW/GJNQOrf8JzlL4RAFsKx4=
X-Authority-Analysis: v=2.4 cv=ZMfaWH7b c=1 sm=1 tr=0 ts=699524be b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=-0MmZp6aM6Otg50y1MIA:9 cc=ntf awl=host:13801
X-Proofpoint-ORIG-GUID: 13ID4uGZJYFAHZRYu_1pSM_UUdzB8n2x
X-Proofpoint-GUID: 13ID4uGZJYFAHZRYu_1pSM_UUdzB8n2x


Ranjan,

> The driver encountered a crash during resource cleanup when the reply
> and request queues were null due to freed memory. This issue occurred
> when the creation of reply or request queues failed, and the driver
> freed the memory first but attempted to mem set the content of the
> freed memory, leading to a system crash.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
