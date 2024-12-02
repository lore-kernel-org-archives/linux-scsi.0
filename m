Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AD31FE46F
	for <linux-scsi@vger.kernel.org>; Mon,  2 Dec 2024 13:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733144473; cv=fail; b=szcKMOV7TGsm5D/+wJPHzsWU7TbUMFAQFuLgUoRAFllEAFGs+E1VYnyr+JbCANvdvg3tsyWp7Hmcic8OCyKIlNgT4+BsHnnN21xpuIli1mNK5y7pu1fzBEKP9TmnXpur9EnasfYTxO5VzXX/GOjspK1xiKX7CH7HnfpGVFuuPu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733144473; c=relaxed/simple;
	bh=uSYA+zZQ9P9s00qHkR6fGdPoYh7hyh5EDBj6LpWJhHw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=KG2LJLDXYLKn8GUbREusgaRt3Fai36ST290nORPJuaFeAerBOpoRWOrzDqnNKoJjbnWeu8gg3AIWQRA/u1jfoJPoRSFxQl+mdGUVbzq9fMkLYiTDcss7/p0zm7ZcyEDOPJdoL+ZI9U2mt0oDeKOPuRLsGyLs3Bb0WuuM22qqK3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B3zn1uwp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UERSBUs0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B3zn1uwp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UERSBUs0"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B26WvlK006631;
	Mon, 2 Dec 2024 13:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=QMdp1BNtBurMK/ji
	Bh7GAzdGA1Gt2xmFlvNcPC/bMec=; b=B3zn1uwphKYtpH1IdBqZ1+volNKe28Pw
	0jBFgq0HVUk1xt9ySkYa4Km33mCe4hveM/rlB71+vQvzjOd1HgLF7WgR4Tht9WVI
	k5UQ6axNT2VEuhu6Q8DaWgTpOHmEok+npSH8rxvU1Vqty5bx0S2sAD5zUgGilGgd
	JdiGLUkHfTivq3ufOI7Sd5jk59De8RxBHCPVMYybLHHApvJjmA4JHujCwV/uj2if
	HJmRpAG3nzvSietXK1SCg9pqAz4gfyauuylUmxN8VYQpuVH8YI3kiFfku+vdUtKc
	P7BfXw1z8HJ/fWUVoQvX8IimJhF4d/To75qIQMSkfQzolR1QF+Csmw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas2yvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 13:00:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2CUKIt030953;
	Mon, 2 Dec 2024 13:00:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437wjayx5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 13:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDU0o+iMBq0MG7hhZ2dFnwhMUL0m9nRwAlUoOYCLctJ4/b6B+rDZ13rBbAmp4LkLrCy9ZyeGmJu/+u6EC9D5NMUAWlPOmFjMrG4M6wSFK357d1/kvcRJGZOERaBrDO3V8G9IeV3mBfhwKyoy/H/do4R/yFUVOmmEpoAbl8N3V+B6j9Rym+TpFiaBBn1aH1UOJv1yloVTZqUq46qsHERaQYweeS2h8RQ+kW8jeNbV3LGR6vz3ENrgyi9XH3f4mlCu1xCo6jU1vtEJjyItbgw556dY03I27mczJFeHiyV1qdWxG2frK1DsW2FY7NHmPpOeVjKN0mNDJE2UCJZowOkFOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMdp1BNtBurMK/jiBh7GAzdGA1Gt2xmFlvNcPC/bMec=;
 b=Uyl5ZmfbUrTLls0klHlUIUkzwVJIUgz9H7k/RIS4TIt8Z39CT5x3VHG49AkZfk7kqsq5xs+ANAKo4LefdGR9bONSOzAQL2zrsT6hOlpDP2LTI2royvLRNP7+pnPkE46hiSnHZ08DLnKfk8YgIdJhcugIhmuIzdsQywQ+BxSBs5QSXrzFXz+T6L8hwXn1TB/7XjPsdBlB5y26Li/qyElI3zjeY3GHgbfsFIvNE/bl1am3yU4D8vVFpFb5X84vKLIcinLPHH+e+qL/Zmsyc6u5qlY4uggnuXDDZRlqt1dxlqD3mnWJhx8yBWB2vXjz1UkQKPvPNtErMZpy2Si1qcWZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMdp1BNtBurMK/jiBh7GAzdGA1Gt2xmFlvNcPC/bMec=;
 b=UERSBUs0rJ8KyO+/7+V4auVi488A0vsdLwF0mBWcIRUACUKMydJ9h7yqmw8d9U+d3vb2Vhs5qiOouRsbYMIh6mJHUwK5BlYftiXLjJlhiEeZ/x5ZvNQMfwX4V8cBiTB5gSKWrjPP1+d1JFjkh1CTYpARLoJWxgM7uCjmJFWnMPM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Mon, 2 Dec
 2024 13:00:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 13:00:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: scsi_debug: Fix hrtimer support for ndelay
Date: Mon,  2 Dec 2024 13:00:45 +0000
Message-Id: <20241202130045.2335194-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:208:32e::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 60db3a82-d03c-489f-3441-08dd12d1589e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EdiPk46dEnPlOiZETVywDx2MbSQH5zCV6F1HpwYROc6KWjs86iZUAPYzQXm9?=
 =?us-ascii?Q?Bcuxq5DB+8dA6f2lN5/K8JJXzhE394fROMoIEH+LzwsJplEoGa1YsZwszMBw?=
 =?us-ascii?Q?vwhjume5ZtwrnYDW70XnFN5QIMNghAhpA80KEpjZ4ihGU+Y/WXC/fp35hpEV?=
 =?us-ascii?Q?3s8R1huMP/xtGvZyG2FRij5gdK/nXtddz3s7gN2zfU3vovx0cf6S7AUpGAkx?=
 =?us-ascii?Q?P4rqECACgK66Ib8uRZoAmLnzeT7XZOYN9ShuxwzIUafJSmgYKpjQmluI5kzo?=
 =?us-ascii?Q?M+0+8s+mqpaf6YeJVXcM6MFaVG3tCp453VkAQiwUj9vK1cC8TxP2sHqyYFsM?=
 =?us-ascii?Q?H+UFWIS0LzvsqcnFVSL0UWbG59K7Hvb1hUWLhgcWBAr2kpcz7EZYit8fyNoP?=
 =?us-ascii?Q?6QM4lso+NN9s9FFyJJnJOzLQ978X2/iUwTf0s/aZiLBc877Aux8mk0G+6JH2?=
 =?us-ascii?Q?Q+EpkXUuS/2ONlQmziUFXWpJpR9gxYp3atkhfGg9F9j17Nq3sTUkYIz191Cl?=
 =?us-ascii?Q?NRQrPVZhQ9RoQAYxVKGgm8aBxDxE9dTr15/y0E2ngiuc/FLr+b0t4zmeSLWz?=
 =?us-ascii?Q?y7yEgZg9sQc/wLpQctPg2X3YtfsUscoIwWGTKLpLNRenaDuIJix/aJTIP+Iw?=
 =?us-ascii?Q?hTQz+WeTInjKpm9EZ7i1+TKtiKlUGgEc/WZs3qeuQlK2NGC2OAlTQwAYv4Fq?=
 =?us-ascii?Q?OJaaxyaQr+UfVDeFXZisqRPDlsSsBsYxwA+6PbvQKJ/KELBEym9smcvC9f4U?=
 =?us-ascii?Q?yrnF2PpZeBoQClcsUxR4frT+/Wfa0JCFTprHf9IOCgfi4X3NUxuLU9p4W52u?=
 =?us-ascii?Q?gsjPbUiB5BmPIIsWu8RooGXQIICKHGdi8b/dKhs2HUFDPr0MlITATkknNxcw?=
 =?us-ascii?Q?LU9XiorrfLrgL0IDf7EKsiuZ04GFSiV5TJC1sdJKlTgO4XH/pcBUK23Mb9he?=
 =?us-ascii?Q?DoXqfWmnd7/45sXuufGG+vBy9vCv63+P92rmyMVDuSH67IpnpK+9a7HL9DRd?=
 =?us-ascii?Q?ja4TI+gXI9VvkPba5/iocpyTx1PHosszpyVScETCqqw6nElj/varWIQNZIub?=
 =?us-ascii?Q?DRR4z+OupCFq9//6VfMSb4zeridL0sKwCQf1qHwZ8navl9yEAG33Ot3P2wjq?=
 =?us-ascii?Q?8el3KfIFMqYCKJRDKbYzYqnwaFBlryib/zeHxgXQoHDAdQrongZQy0JfXhlA?=
 =?us-ascii?Q?3mn//w/JvRtYfBDl/iZXn2x3VRTZlXARqwZudoUf6qWHYHhhGQBLF7G3Ogvt?=
 =?us-ascii?Q?lC1zFdgooj3vfgZJsKfpQTlzAC6rR/r6dyCmfAI0eMaiG3x/mQkgnmUmMP7t?=
 =?us-ascii?Q?LKdhIz91LkU+5VlB3psxpwscIIqru+TQV7qxOMa/2MmAGw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BwgX9NBxv8/SdZniBXhd9WrWB/XhR5hq6o6yXdjGm8PyDzGkhd1U/gakd2vq?=
 =?us-ascii?Q?O9ZG8LN96Y0mh/sIZgWbPRAVds9wczHmAQttboMU4H0Wf4+afIliMOFaVHSg?=
 =?us-ascii?Q?k3WOo8axm3FfBV/pC3gDsXNZoM/kcK9psvKmidDpRlsZD/JCy3mZpVWo1DCP?=
 =?us-ascii?Q?Hx9M8R1U9v9vpOXt1XkyvTvQmLctLp6wNI8bXbj5NRgGwtUSo+PwYWL5YNLY?=
 =?us-ascii?Q?9qGoZ94H9w7zKHlBS+LN2RKjZ5rvQ9HtnHxCRwRIoFMK55AwXYYyw9cwqf1j?=
 =?us-ascii?Q?biUpKXATlPIQ2z700XNgU/bDtSzcWf7diW432CCSFOjYRI6uoVdJPvPySsAL?=
 =?us-ascii?Q?VPUu/SnmTVGXjYAdoY11JVO6bgVSPMVmVSlEBtMq94ch71yDAJg98dMRf5Ch?=
 =?us-ascii?Q?w+kUxx4MkIgHfI8wbKZKhlVeXz2gUVJ+xWtz9lUJtBS35D7C6Uvj298VI7zv?=
 =?us-ascii?Q?9C8+RvGeXDYvNNmHJQwzLmvAzKxk4tmNEEmZejrnKYAnlmaQGnDoP6xi+Aqf?=
 =?us-ascii?Q?x+dH8sN0gcrxXkMpNp1QEuQs6SDgiDvO67m6QWZM3kFTfDzuMXbAcJPOo217?=
 =?us-ascii?Q?61D808m+EanMgt1fCdT6XYgHi3HzL5CAPIMsbiHqpLLT/4m1GcnW0hWPXx9j?=
 =?us-ascii?Q?3prScIzkne3O9co/ipDhZOYFUvP7xNTX37OzT2z8/JgcXZ01JuAfxOs1rQb6?=
 =?us-ascii?Q?MWrx0MWel9eKlmhHc8015NEV/qqm82UJyHSsF03ZrxBnoqXgOcmHSdhMuWkH?=
 =?us-ascii?Q?qGMtJvTa101wNuC1Chht8lZg/gdjBAUX4aS5NsGA/btCPtW+2qI5I8iOm8/z?=
 =?us-ascii?Q?n4+ExZfeTR6PJ3X5hnmLBLitsWRFjl49Z2dF1JY8CqPsuEBkQhnkTwL2vPHA?=
 =?us-ascii?Q?yagaTrjxyK0/OFt5YEppItfygX9kSXIdk1TUTXujc9k+jKTOZYYOyuMkxgqt?=
 =?us-ascii?Q?j/kkyQfiLom931yUeoVLrkV9UHR2tyNtcB9YOjzO0pAxHPKAduMsHe4c/uZL?=
 =?us-ascii?Q?bXaQG2y5pFyvpvurQDChEI87Cy7Qi8aqN/WJB2HreZBi/5OU30xLf2vje5Pg?=
 =?us-ascii?Q?g76GqdLLRdKBIJXiaZDvC/MKLeyevrgCnBf/Y6NjUQvMbF5vK9snkR9FRb92?=
 =?us-ascii?Q?YD4fjbcE8F3qIE7BpLjT9rlBEwV3/pLRo/nsyvoQwqS3+cWFAyTXb94zD9bL?=
 =?us-ascii?Q?Qobt7OSOv/SPcrB2vIus7EEujbu8hXvB6eP2HdVmJqBW8l2+FH8hCZFJVtO+?=
 =?us-ascii?Q?qSna+PFjxKVt76CiINV3xJ/AN6VyftGcIgFVPF0LG8GMMg3bVDdqC7bETvGd?=
 =?us-ascii?Q?YM+hVaP6hjN5fn7cH4hj1BjHgwohpnfeXfV55tpVFcR6GLSIjlE+6lfqjHr4?=
 =?us-ascii?Q?XEqia2FyvWtC3enO1izkQHy5A73Jqs+HgMGAykl8lLYoGOLoN0nFUQpbQoib?=
 =?us-ascii?Q?MrsKqV+4oDU1SiMkgYQHcfUz7VgnPelNpeWePErPBZlEs3tHjHXdVoZuq5S8?=
 =?us-ascii?Q?nUOgkgE8+rIZ5mvWGrro351ilcl2GrGpn20v/KFd2f7CDLbh7GBTLqqE7tkD?=
 =?us-ascii?Q?wpi/OvPm4T1tyyRxZofCjHrIC+zxoHaPM0gVjHciY4LpUES/BvJnakPI5N+1?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IAVBR4aLrI7zix2SX/fRs7GGOxo1jMvmf4959v1UIM9bMAfgu17hdvjYNpanTu5gGES0DIxlJZ9+VKFQPKncYw8Ol8YqiISQCS7ZZ+k7khdnSWLd07d1lXFU4kHP3v2WlQh41dKLeCJP8rVAIdov726Ahi82dhAydUtQRiXeFFGoJCuYLttPIiG4m2GfWxovRAIJ7WPHj2GDdF5AGmTO8tolvomVFScRINNKnReYVmPqfGu5y1GIMvKTPQDMEPKAq+BDNg3btdp1Bex9k6+hsR5lkkHMM2Lfk2SUK3LlR/cBJtBUwZ9fFan7TCp3Dh970fanUk2Qp7eEkDITWfTp0G83UtO+BRm0aP5Ccex3wdW5rjdW8kRWyDo5hotQjdD7Tr42y8AXA+7tElzwT2Tyh9E73Np3dSgFl512B6DdK+YLVDwX8/dBAUy/3xtBXeNm0bARGKokgUWjTeMAY3sNVK9iX3emx4R9H+vPGM14f4hEGCfgHLkPluKum+u16UHM3B/PGiMzZ+TH54m4Q4xmFK5RvfgEJYazCec0wkbmJzPA8QqpLUSI8kiqnOREDrVys1kfv4mWw7UETLesYBeqTrVaAz9BLmAQsrn918NJVW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60db3a82-d03c-489f-3441-08dd12d1589e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 13:00:50.1921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HuXELhzdLqXYfOkThYN1snmDghSvNeZIZlKoYDBqb29IrPnxyXKhzgxxum3UGVvYD8GprTG50jowmpD9jk59Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_08,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412020114
X-Proofpoint-GUID: M-DzXbijiDGzxLWIhuSHM5_MDgwE6mNb
X-Proofpoint-ORIG-GUID: M-DzXbijiDGzxLWIhuSHM5_MDgwE6mNb

Since commit 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration
calculation"), ns_from_boot value is only evaluated for in schedule_resp()
for polled requests.

However, ns_from_boot is also required for hrtimer support for when ndelay
is less than INCLUSIVE_TIMING_MAX_NS, so fix up the logic to decide when to
evaluate ns_from_boot.

Fixes: 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration calculation")
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 936565b5000f..8a8ee4aff49e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6447,7 +6447,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	sd_dp = &sqcp->sd_dp;
 
-	if (polled)
+	if (polled || (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS))
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
-- 
2.31.1

