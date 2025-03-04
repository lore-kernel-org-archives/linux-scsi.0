Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E68D1940A1
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 02:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741054369; cv=fail; b=of06het6lsq/Y131zbtrVhRrqaU44Y6b2CK/eyBXZQ/6BoA0MF+7Fgy78+RurtfxMgNkCGrrxvu4DLtSIATTfNo3STu/vXNWD6oc5rcQdfYFRRMU2gXUgAXB52OKjjQlYnJVLjyp5+xPuIrF+CtrKtVtS0sF4Yae2wqxEYOo/BQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741054369; c=relaxed/simple;
	bh=b9of6Z0kEGPEfQk+0aIhFyYxLstkfezWwykJIUQ/iP4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VuzfAbFsGao+C5Ee4owscJ8mr0CxSHzI2jVR3qQP/hBS0Rt043pLzdap96Nlvw4o5D2A23QQrY8+8BPLldxMajjWO7ikvD7FSMu5+AqfnUhZsFjA+Ejov7NW/HNgDyeU4xI4sdxJb5Eo8On7EtC2ePm9hQS0aSQnrJ09lrD+JS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FRmA0+/A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KQlAd7qW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FRmA0+/A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KQlAd7qW"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241MedD024001;
	Tue, 4 Mar 2025 02:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=FSBm4cQjTcEQHXtx7D
	U+gjddJXv3GqO/xrwu1BEf4wE=; b=FRmA0+/Amyfo77CsWJcW6G8yalSy6OppJu
	jRqyJNjQoYY1bZy67ScoR9IWQ1KkcUpn0e7L3hBwLVF5JXmBAyzqqGj13fIJcslr
	S3aFO//iqqsl0vsGnjDx1xy4/1kh6SUO+DVBn1kf8N6udaGHEMudBsT6/8Ms79dv
	GC6mVtfOetMf+fXJ5xDl/K7jLY41tBvLwsrAATWGgpYe2b7zgnpMeMVOaYv7hwaP
	7mpscHp8Jf9+miXsWneF5+oTj5iCJpaSElHdMQfdTB6Uis3KYawmpdrFtCAOxyOt
	WBHc5aHLXYpXuTAvRq1mQat5f8/bTCePi6unRI5t77vUN2DCmADQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wkyay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:12:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240K4iX039130;
	Tue, 4 Mar 2025 02:12:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp91c5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcftzkR6KZXy2Nn8pb+uHv2ZvmXzRwmgZIIkjEHB3i9laNjBPzlzNVD9IfaSN0mTDOyQpDCI7mFH+pvFQACF3TenU6r6A04g6+JB8pipOLtYYIYWM+rnSfRf12sEK7tmmXfcbdnHBGlztiy1A31kcQjR8HPvLTHBsyI92F3DZ5fVd/bHDQ+jIWmlWi82eOeecvCajvwFLbSF5Tx+t6v6/tKuPnZetUsZbrjyfwJNdI8G8lseEtk29I2U88xcmQXuA35HYSdSfFJqOgm9f+9d2CoAnFl3c6OsRuTT5mlfAkH2BNRN2BxYHiEvvd9s+mm2UwoT1UfCLA/Lt2nwyJRmtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSBm4cQjTcEQHXtx7DU+gjddJXv3GqO/xrwu1BEf4wE=;
 b=eLQfMVij+FiQ245QUoKSqvpZLzVxqez/IgZgvS6zOre6Oxe+FqxK27/qfylzmYLzzqEWSpGwmhOzdl6rSMqdzKE4y7um9dE82wriyadj0FQHdvE8FubmAn5+QgjQdeQ9b9DaqZBp2QB2wsROZSvcXwUsMJ5m+m793SPSjDRQlQNJp/1R5VxdPuGQ+cRm/SZlkG2Dpe7NrUz1MujmsTBfO6hx0JjA+WYlOW+Zcb1WBqHGEsMVJt9OWxCwxXt6YTP40NZenKWbqVKDTYtPFhoptF8r4D0Et5KBsA3BKIjf0n59QK/U74nCfYJpvBjsNQJqqGkG/p4IN8BwwI+p/R/59A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSBm4cQjTcEQHXtx7DU+gjddJXv3GqO/xrwu1BEf4wE=;
 b=KQlAd7qWDg8gh5kkVbLV6dSaCaNAFJjgRjO/Srw6isMSByT4vl+6PbtCNLntMH4CPWF+zZ45NDEiey/E1nSoFabAKPRV1Z6bhp9bprou562LP5d96NAAh63NN6AHe8rb14yEJe3OTQvD/25j5A4ifCmPJUMAp9wE/x7obLoRXOg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4964.namprd10.prod.outlook.com (2603:10b6:208:30c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 02:12:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:12:37 +0000
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: ufs: rockchip: Fix
 devm_clk_bulk_get_all_enabled return value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1740552733-182527-1-git-send-email-shawn.lin@rock-chips.com>
	(Shawn Lin's message of "Wed, 26 Feb 2025 14:52:13 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jz95v90y.fsf@ca-mkp.ca.oracle.com>
References: <1740552733-182527-1-git-send-email-shawn.lin@rock-chips.com>
Date: Mon, 03 Mar 2025 21:12:35 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:91::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc9de49-3ed1-48cb-ce1a-08dd5ac20871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ESPMwuwjmUZsb7M9TQ5iYh8pqjJZxSFTcj//YErIJvoQJl8vM1z7aC3k4wUd?=
 =?us-ascii?Q?9Tki1rGlwOTGaSipB8j5bF278p1SSiZkWyGLbXe+sDjM3a33NpGFeKMPafWc?=
 =?us-ascii?Q?jt1IKvD+l5Yw6+dFAM6bxGJMIdpWLeEhSZPHWRh2OJ1fihngNmQFp592DzBO?=
 =?us-ascii?Q?UOktj3eelmSRkNPWHVz00nsq+0yWlQgDDNGbxrBUmlspmLPupTXQuDtTs/Fj?=
 =?us-ascii?Q?XTWv5faSxBv7F+vMOJaSRBqo299C4KdZ7McH2UfHyhg951K1xM8pj0OmPg18?=
 =?us-ascii?Q?R8csPtGooNoCS1BkShcHt3RbT9076Yqr3lkzlEXsGrbZLfZ1jDcbXqBt+pvv?=
 =?us-ascii?Q?jcpF5+ZUUkUQ7t3+OEqEB7F+pHosm8EjAVYf3heRYthIwZcRv/S5ysb6Tvle?=
 =?us-ascii?Q?iG+4Q1anWD/ZlAQNYIcFoWNtURh3RPyI/syYQH4ZsZZxWGqZ5I+jFpbfiEbp?=
 =?us-ascii?Q?cxl+eE+5h7QReKvIZNo/ySgPySy3a6G3Df+VCrx6uStwWj1fP9Nk9NfkU3/5?=
 =?us-ascii?Q?GbZO6JjP6T8P2zj+Ca2t6Q9UCvPcxfU9e/ErB/4PFm/yJxTTTAtdai1w1gqD?=
 =?us-ascii?Q?1icwsf3KxFcxpvLuZB1qM4leJOh2i90qJuo6L7IUmTEIhkBbTLSCv3YNVJwt?=
 =?us-ascii?Q?NgTPGuOn1yyqnkRcdS1K8SYdQOWCiT5NcG9QZQRV4GdBb4h7ezBtUTTXd2eH?=
 =?us-ascii?Q?YOsBxyye3B467rqHlrODDMVDaUOClMJW5BfxMCO5vG1UpS9JnnyXuZxmYJDN?=
 =?us-ascii?Q?eMzAuwFhVPfzZZnHVr8TKETrOGSMzH0rWvK5PJUCrGNaQbkSeTF92ByOdo+v?=
 =?us-ascii?Q?gBbUCUP9OgxynfDdIwsrgIlnJcytIDoliP3GOMoAKNjYkhY5Y5IPKX8WnJC4?=
 =?us-ascii?Q?3J9uYqDw6V0ECAXHzaZGAOXsrFnR0lbnZvacRcvDGTNJDTYD4SwArjUP0kMc?=
 =?us-ascii?Q?bnwWhE2KR2MNbMIuMmeF+Y+iNTj2HUEj8u58ykHblOF8qMvjnlei9+tUyC3I?=
 =?us-ascii?Q?NfXr5bWaiGlZZCswLI9VFvrpIR2TDm067LrDatcxrGG/aXrWS/aSSg2v0+YQ?=
 =?us-ascii?Q?QpRYEjRIbXkB+cy30SoE7IKTW86Pf7bBGg9lZ0+bNQ1mWp9n3Mqz3qrdoWyt?=
 =?us-ascii?Q?xPyNz/E1pIPaY+uDwG8whp96sotavLv1VmubEw6TJ1apD96ow8zCVlSJJys4?=
 =?us-ascii?Q?GYE/fw8GUMj97nhGNzydXcDegMXANONfx6e85pd5Kd/eQ/9JZggMcuHMND5r?=
 =?us-ascii?Q?T/G0keAwPlq1b2EnZi7nMXJM3uVoz230WVgGNVMTufdElgEk9dyc/3QAQa+m?=
 =?us-ascii?Q?awsslKlAWtDWBxdbRCg1b/h4KWmmMhK4U0lMTwsxTUsUyCxQhv+TukGv5tFO?=
 =?us-ascii?Q?VcT0gcuRTdGKROpU1KdW2lwn6UqW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IGrQyG3sAgDgOV/EzNekYepKne9kYUSGGujEcPiOG6zljFvbYuGAh8vYiHwz?=
 =?us-ascii?Q?6aHRkJ0rY1cxkMdlD9M1hKUGnk1ZfGqbv/rbdNdKTo612RZH+vGRTgXfqqA5?=
 =?us-ascii?Q?qNHDrJyCMfc95iZfmxBJ4fpwpA/BQxQYXbr63jyX8BoMlWHAqZDA16lzw9hY?=
 =?us-ascii?Q?CyuOM8OB3kBjjoeiztq5o6MWTJp+kN2chXsl42XdjDcrpGVLhgMXtZDhgUbD?=
 =?us-ascii?Q?ViacBPKBP2klL7BkNq5C1AADfqIQkOVA5jR6qit+oA9SGL8lRTwG7Jq3f5KQ?=
 =?us-ascii?Q?mfebVFkBlU7qd13+QIZrki1cGLsIFincBChaPu4qdCZZ2vTECv+VLyR0xz+k?=
 =?us-ascii?Q?8rrRz4hWws35YbKoEAu69TaDGQgcqkl83mPLk6V7dz+VQ8RCIg4uk+NJgIZ2?=
 =?us-ascii?Q?fAIMtQTPgmXGDNP7bDd+ePCtzYCygQBsiyacVrZHKwm1K2UWWZ2At2Wp1p8N?=
 =?us-ascii?Q?3wQmTXjwGmm+RrY/DMV7XyrorjI8xfJ+qrZJc/4OyDGUpzgYIfBZiVoEJi22?=
 =?us-ascii?Q?hZ/u/f/DkhKeUaHHntWFZ6pUd32oer5qYr1rW2ZIyQCJH0opvwEqz6uHnfPK?=
 =?us-ascii?Q?KL1vFvEmG54rru9LPeDVME0xSXLAvXghnfpuFRG/X7UgeDHSWY2yX9wXXigm?=
 =?us-ascii?Q?SIqOMC989q0FmJKt8xzXvezzRy6S4SErci9Kxzz3SN8p6Wrl/NVrotZDL13b?=
 =?us-ascii?Q?XWPMO1XKVPLWPLtuX7X/IZQFe2Ij0ES/lav6t1WULT+ZnhvTQXgJCm89B3SR?=
 =?us-ascii?Q?HQLKqFbbpCN+NgijzWcj8FxnR7btBO8jyaETcasO+RVsYtNyMo4ARcAXZBaP?=
 =?us-ascii?Q?sWFf+UBQFmCMTIb/x/hd0Ubho3vXAWwhijF3m2kPo0OPk8nWtFc4dQaOo7zK?=
 =?us-ascii?Q?coIQErwFds03aNmOdXWq7Y41f5zNV28H3LQT8ezclzH9mr611cAdJd1GLN4j?=
 =?us-ascii?Q?Z1o9MsQy9gZ/EbRfDpab0isTw1R/3YfykbURTTHp6KcN4lAeR81mAdMWKyFe?=
 =?us-ascii?Q?tN1e0Zmix6ImYJa47K7HQsARcPIYmoE4ZGMILfGR7B6V6AxzW0YC0K6w3cL7?=
 =?us-ascii?Q?IvLo767x+YCypUeBFRXJWxXI3Uabnn5pM/Ru4suDkXIU5peK1z7j4zyF2FuF?=
 =?us-ascii?Q?AcT4PA3fZ6bi3euZVDQK1wgDDxgNdqOT10xKzbViq8O2Sp30P0NPmZ23ZshD?=
 =?us-ascii?Q?SGVgOGLj0ZG/Nknt/mopX5+Evz9gJPGOuZ7OZu5oTvzCKQqQ1QoQG1mN68Nn?=
 =?us-ascii?Q?vjy2Y1TuTLoJjIRkynOJ9oajr7d1bzE5jXjNyE/SW1qv0EL1lhxsL+U6jU/S?=
 =?us-ascii?Q?+4RO4MaLywbUX5ppSurtLkkNbt+Xo5XBczEDdPyS+oxh03zGSfkS3P/SgAVv?=
 =?us-ascii?Q?5qjYMmzBm6cJG43E5douaD4J+aiQHlBWZ9x8UgWIA67+Wh5Rq+lYRmya7+Qz?=
 =?us-ascii?Q?RRINhHxVjE+/9r2uQVinZ7Zx5qfX2M/U+USExkVK7Y+FOTV+ptK9O6jU4s0p?=
 =?us-ascii?Q?xaOir0dB3qVYD6lhrrQ/eunxcmS6JxvHSG01h0dtDiRE4SCboLwo7KHfJ+Mt?=
 =?us-ascii?Q?F2+NVnENOXul+TP6OiELdAKea6BYa6tkkxw6gdQKQlQL+Z+nFvtvaliK/96+?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	etgx/DnB4XqiIjg8Tf6chJiTgSdXHrp9rj0XgIetaEV9HCZu/doIYnYmDecVHDesgGnmYkSSd5lXG0ThW2p7+D9k1kYoBFrnWfpOHjjZwkKBz5M2dURBdeBjGYjdh6MA9KTf5pSlF4AZLcfciNa2SljvIiT763hibo5trdBDhghAc1yzp3ECUOaBkvlllz14zuGI0Ss0pW3C57iBEbsRAyn8/i9Ck/2VaHxYD3/jcZTf7Ao+X913YsMGlw5B+6NsV8yBj4CvvOiJUIoxwd0LOCFCL6NNtDw6hM8yDc+gcZCGW0rRN/o+d+eExsK8BqGKFPr93lo6zHCVTfr6J4bGyU4LHwYpK1z71FItdkQYIaExkxE90ngrMaPs5pceitlBLQhy7y2GzruifUTZ/VFlc3QipIahXnyONrf/k8cqrXv9mpxYjnzE9FF5CPprSzZxZhCD0me8NRHrfSKFDpDXpC1Lvw80UA6QPOXpJYZaJG1FLU06vqx+RGonLL/em2fcslJ4kLOR4JZxW+JBSt+GCFkLBGPUlup9WneZ+HSHUkxsZGgMiPmeueBLbwXyHPOF7cbMmRPykKAUQEJj6+EbyPL6M/fpKvueDiRNH+mU63o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc9de49-3ed1-48cb-ce1a-08dd5ac20871
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:12:36.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zR1W7om0M7dm9NMuaeyyDynkgR0AcJYnsyO291k+0DKIRiIZVjQytoI0G3HzB9KgxH+bQFkRL0HjaQKjQ/mrb9dn8OfyAksLtoysNCAgQ2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4964
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=599 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040017
X-Proofpoint-ORIG-GUID: DEbOcGtjP4zTvekV1ELRFharlG14bYoj
X-Proofpoint-GUID: DEbOcGtjP4zTvekV1ELRFharlG14bYoj


Shawn,

> A positive value is for the number of clocks obtained if assigned.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
