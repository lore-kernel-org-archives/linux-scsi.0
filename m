Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D2D1885A0;
	Tue,  3 Sep 2024 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376130; cv=fail; b=iqvKLocJs/wyCwWaDO0EjdamiJjdGfZKn+Rn17SCB9cLo7taQPCX+NEBbs2AcExK2eh/7y+nd+dDu7DDg4Sr4yjb95aSvIbvI31kpUQ2w4xkFEsq5N2qqM+g/g9fBBS4wTz9b/iEwoj6ydOg7JtjvzUdI96a9q3onfSajaa+1Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376130; c=relaxed/simple;
	bh=zTXb4t6rrue7+qqyc9EpzfN8DwOOkBPWCpFaUioXAbI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Oi7jTOZ45GS1T/lpszfGziqubYbxXxFgyRM0aNzl0EyU1Hhn/h7YCZSrHabmcoboYkcV862rqoxfiGrpjEYyEWfEcJJS9VVC5sBfeNzMvyDE4d0woII8N1pQSa0M3ebSUywASU0Rva1U0+SkJ5vMjA4UUnyPs1GYKcxJkxNXa3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=STiaIWq/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KQjAgduo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="STiaIWq/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KQjAgduo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483EupdV008140;
	Tue, 3 Sep 2024 15:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=EYH9930SDH4tpm
	yEzs3Y5Wo84a4+LOQ9fsdS3vYETDM=; b=STiaIWq/VirGLiBa8aJKrJNgIM1HYJ
	5hMte2baacbxrLnudMHKMXGLmE0vZOWxJL0PbU9QC6ScyUht0jm5giXFNV4bf9kR
	yfknvjAyHNEGj2MwwVAEQtuowBhWgfHxGyppeX2daRfQhG9BCOfhE811eIcm3HY3
	QHeTWbu2P9CcDMT5Ko8sGg3gZ/mb7delFAN80uOE/7DLYEFvcCS6GYFy5MuhgDPG
	C3llKebH+Qea8vjnkEtjPAmjs6gEotxoSX1hxdVuL//xOBtkofczRy7dc9R3llkg
	7Hpn0aQ0E2RZ43qz1UhM0OK1TpqWrc8IjcClxGc55+bX9+J8qstlGcmg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41duyj16bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483F3cBC001727;
	Tue, 3 Sep 2024 15:08:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsmf3hc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hm+wcSvCyWfSpztF8fdsjMjqpeq7h9fVs1FnoMeF6hrdBJDkk/ky7V4/IqZsfZldI0inLyvOqBLKV/Rn6Sc4zOaxYnC2o0dQj+WVcpo5977ZRB00Q0iqJ+ldenF5mCx+VpEuYVMec7XdUoVCoA6vYeK0BYMD49iobVLr8NwZNcYTT0vR7AM77wmMaWwB4KqrPM6v06qRjh1XwIMPhLY3xefNT6G3w9ahGWDjZwkVgAXY+qnlpxOZt66eABikEEQTxzlE0f7W4FminNBoeUBH85+RSPuywh3HcmF5rki0xw0teO8DHLhJcUm8LwU1JTPiu+E+prj16Z8md8H1gBUjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYH9930SDH4tpmyEzs3Y5Wo84a4+LOQ9fsdS3vYETDM=;
 b=xZErveTNFtIZkam7gilKIa3C7a5YYrKSp2hNg3ELZ1GXuI0IOvYwRKirc/FL9oWHkxb0eozDs4dMrqQtT0iBodJRGwR2xH42MQnq3zV/jSaMzJU3sVSRcyU5Rp1MVNGH4Hm2apcMyaUw3n1YZ/8NcGFkMtxHQTIo49s/c6B2VqV0TU93V6RENNUSvgAm36QWpCjGDCHqnetLgUttRySdPBogFC5FVIX5kr1pnstBqh98XH2IVQUNMvyBnnsDyGuUmWxWvISso+nF7fBi2KzMeVG+FMoufHKc8BjE1Mnl5VDYDSI+WMfaL7qdFOQK+3WPPRqkf7ukQWwMj9GjEFr1cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYH9930SDH4tpmyEzs3Y5Wo84a4+LOQ9fsdS3vYETDM=;
 b=KQjAgduoxUdIFQpeuXkq6OTeiuoquKVj5diGcwS3A8IQv6lkMEW6gu2yTfkfKPD3Q0n3i5PguxwH6siK24+InHkneC91OovVksi2PWNJzZOlgfukISxGcGJ1XC8M6Wg18vyJDqDtKLpe0qDRHUHbjJ+1UB+gKSsclzCbfKiB+VY=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SA1PR10MB5781.namprd10.prod.outlook.com (2603:10b6:806:23e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12; Tue, 3 Sep
 2024 15:08:13 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Tue, 3 Sep 2024
 15:08:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 0/4] RAID0 atomic write support
Date: Tue,  3 Sep 2024 15:07:44 +0000
Message-Id: <20240903150748.2179966-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SA1PR10MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d98328-a5d9-4444-02c1-08dccc2a3af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BE0o0gul7VYDYY0iB4/UiKKZ0RaUJJvjNfk4nUyqxXE+wKXqZ271TlHhOnWq?=
 =?us-ascii?Q?Ous7K4h+FSPI6T7bbAcPSM6QMjngsQ8cWfpYZAZxHPssVfz2I3AQ7m6RAD7i?=
 =?us-ascii?Q?sp03SgHvUkGsYGtZN7O/U+r4iybvudWZXIGx46qxVnFbRJRHxVFQj3iT8+tG?=
 =?us-ascii?Q?qTBcyzxffUlk2Vh/G9xWNydJCViQtkDajq+r6ktPalVQA+8KFp32uaVSXDXc?=
 =?us-ascii?Q?QSQ6KOTKRd5ZSdKPtX9qiMGbof/ORL7OEvNBHa9KJBJ7/5JTJd7SeMWbYcKc?=
 =?us-ascii?Q?3cZPc0SGNm6iWtwtWe0ccDu5rpxndYp0ADZlrzDhYW/800fqVKzhtMCQDfnE?=
 =?us-ascii?Q?dMWmU/YY9tpzGf/cPZPhD/fe0Gm8X1ilc9izpy8VTcGTB9PFcBPP9mW1r/bY?=
 =?us-ascii?Q?zRwlEBdd1lN/rmOZTUyzkKyHpGTP+qt5HpjVGemARrd3MkT16bNf1sNWKFOP?=
 =?us-ascii?Q?zvOULXmy/c9JN8X9psu3GO0UfOGz1/CiamQg5Ok+F+M2T0rHwGd8JPeAFDuN?=
 =?us-ascii?Q?oJu6KA/AQk2hrFbFU7Q0nONzqOjjxxp/d64zwGEeRvraM8xw0laeVUdidaX7?=
 =?us-ascii?Q?V6CAva69V0zB+T9rhrEQp0UBpELTcH8Ss+CG1BUzHLz3S6eTT5vfI9jiUzE/?=
 =?us-ascii?Q?xm8+mQcleN0FxqQqvmM2AU3rkJ0HH8Z6Mg5/GCLZfTC/5c9Eeztv1zUJ4jcX?=
 =?us-ascii?Q?0/klDOsdlpxfkDc4GVc2JViCv1QhO2AHuoYbE0huYL0+9xWK1j0fkzjLDekl?=
 =?us-ascii?Q?Z9EALQwbxLXf8TfxLi3ln7oggybYHesSDdvBMuKqVsx2euD0E/qOhgD4qcL6?=
 =?us-ascii?Q?LqwwMwGDBv/CWCrcUcGXyhVHU3W/sJs3C3GSKxxTxOiiLT7b0Y8u9bKWp/4j?=
 =?us-ascii?Q?G3m8o0iv4JmQCO7ZTsHwqrSq45tNKcP/A305X4IM7RZgcBcyShJdyRX3GUMZ?=
 =?us-ascii?Q?hDhrMHV+tsSqwpqorh/qaiplQNQJmKcapu+zOXx0mC+WpFA9v5et6kINj2m/?=
 =?us-ascii?Q?PcIO8BgEn/hvDix10EevOj7HD1jNdmTd8nO3k4/4K2YUBDx+2LgY/ceaph2i?=
 =?us-ascii?Q?21covBEVSCgR5tN5a1CAedffcI83dYC+I60qijn60e82llUSVF171rIdsHdG?=
 =?us-ascii?Q?2I6K1yOtCTDcDcBoSZviuiudKedAinCWjJWi8/XATSZdg+Cuw+Pz2x4rwpt/?=
 =?us-ascii?Q?NONuCqAcvB9aiQ9LDKc8XPwmhvkBYtjBYvfES5gcCarx2keQKY1pmHRjNYxs?=
 =?us-ascii?Q?1q4U6jKIz+jPpUemrlrqV74JTxMC8xmTKIH36QQBKUcWok/Q3JiA6dhjQATp?=
 =?us-ascii?Q?cxKXkRIwvUwJ3G+OjWyC6m7P8vko9x0/MLfyfgZ98XCyFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KjiwwXEGu8KzxqH4BrvywNuru5oqVtYd71mrPork188wbdZ3R+YySYzjoBet?=
 =?us-ascii?Q?+ZnYmNMYZwC9h2ngyVM84hYmxyOlcEcjhsDzrWW/s6n+fq2w0TsOOnpAXkaG?=
 =?us-ascii?Q?T4DmcDJq4hk+esqT0wt/9MS4eAf0o15nejQYfu2D7zl+ivmnNhY9C3za9fic?=
 =?us-ascii?Q?pb+JTfIBgIuWMGfIGkItXfdyX4WwED6NUIzkfulsFmJCg0z1pCAnIcq8U2A5?=
 =?us-ascii?Q?ry/3LlVMNGkNz17St5+Sn0bNYNv1AViyF8gku//QKHGMjdeqQt9IC6/ZzDEi?=
 =?us-ascii?Q?6POFpwcU0YSc8N9Ml+OCjxlyRoVInbQU6epW88+hRqPQiK/524NtUI4/8DWt?=
 =?us-ascii?Q?e52+nFQZKBzdwXHwJ3gGloXqlAoq+aPlXEIyjrPB9V6b/y36wxPENG54XJuq?=
 =?us-ascii?Q?ODc9IwumNw7K1AEwyujpfQ+D0IoNaIELmHfsUl/2iYBTAmrLW+6tYGR3RXG/?=
 =?us-ascii?Q?OfdZFesvmZ9fPmEXIF86LKSR6/a4XuZ0rKAyHGP7piDW3bKnH6IfUfDd9rED?=
 =?us-ascii?Q?DnnTkh0CM6hXlaNTFho+9zMApE5EAg0qviSMBGtEJcKLHG+xz+3jJ7eJJdRT?=
 =?us-ascii?Q?Y1qnxH7KdfrpgtNfugS4OdCdF1UrKdv+x3nsY0f9vjcRXil/+evH44z5GgZO?=
 =?us-ascii?Q?fJtv7q8aHhjFZmYcHce/aSWM+Ah0jir+aVvX27U94SA9CSHAvZ4VjIfghPnS?=
 =?us-ascii?Q?lqX8ckYZi4pAaSne8eAePJ5iQl5E6uA6ajseGyjoYvcJmq9LqwAkE/jzG4L+?=
 =?us-ascii?Q?oBgo8pumf6pPwYiXMJ51v1h1RhrhyoYqskGTv4zyF7N4BTzIkI+vmpboRv3U?=
 =?us-ascii?Q?pYqq6WcRxR6dYFRllGG/UeF2ACgkjHOazlOq+c7Hf3fBetiS9Av03oPhDCI9?=
 =?us-ascii?Q?9DmgQAFNe85yp74Ah4Ca8OkVNioofJkY811t+xujasQ4ccLrVjZXENiLCER1?=
 =?us-ascii?Q?HIlF+5OzHvIRcXU8mf+lHNqSSdDSOLybX2ubZuXkgaiRx7M03Wn4iNyNe6GK?=
 =?us-ascii?Q?c+2BoS2g5uFmut9Wvq0jgROx/2jXSrVnQFRBLZvRx/HxBVjXMwLJ9BQdQzF5?=
 =?us-ascii?Q?aPeRLh3IGcKafAhuoW1RUQAcYachLXZUGFwG0pAhG9+kYZ75QN2ANvMzJFDT?=
 =?us-ascii?Q?2XEsSQxv0i5hFWdWmoAknyf/MPovZRjNzHOE+26wvgl+0jIli4qKq9vyBk4U?=
 =?us-ascii?Q?17maF8QqvDrHomCOSMq8dn+FjaUjY2ooZse2K+X5KcGN0NaLP6YxRxELOebg?=
 =?us-ascii?Q?nfC89KSJdW5i3xdhunwjyyM+LMDYgK6bdX2h+UxmDhJ433jH+LxC7t0Ea0Jz?=
 =?us-ascii?Q?dBzJpGyPddKv/jUU43ARMS13uhyVfLHlhJcM30CuetDZElQCsmSI0k0VIKMx?=
 =?us-ascii?Q?kzgOby4lTsbopBR1ETYuVR2SiqCphejzB2yb+tSPvTXuyNTSGVxkusPrNQP/?=
 =?us-ascii?Q?HbOp8WyGW2emxJeZSBu+Oo7YxbLUluujuc+4bTQfm550xlEsceK2X84vj+VH?=
 =?us-ascii?Q?U+8fRnXgOpC3CDw+vLFW5K3lT7G6F/i5iPmTbh1B2y3nnUd3XEagjGGiHVYX?=
 =?us-ascii?Q?YrT6wZJwHP40VUzEieOUVpgM1m7F7Sj6xZxZN71Ssk4kCp4pT5rwfFY0vJAe?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	71D1tjgW+M5vRllDpKLTCEXzYmYLFx1fJrilkCS/qiVCwca0cy9gufcIP9Vowc3x5Vwopxs1RdbjDKgW2K7cm0n+CFYysoNBzm9rhEwPJzg12Xe644M+gnCrPXT4SKKWvhCIz11szdxba57FUZxMB0oZa6as+YXHIklWWtDZwx45Lwm25vwFfiZ48GV+3tEq9xKok4d+hNLZFwm+2QcztokC3gC/C+h/Tl+rs5bN1gwW55PoZRdNhLD74IPoxtQsq64VJPKRBPfF8FGT1wd+88j2t9+dF/tIbvAVcq2wkR5RtHvfjbgyoXtYuKqJI0oydzkxHa+HWe2rP3OedraH7Hsw94Ow/FnSlVK7XNUSFh9MSBT0FlHJD3RvBToWmlRGFeCNxBTAbbjV2c3BqsCFrM8LRzTxQkJXtjWW1zlv5IxcYkBHcwsjlV1XhOSYW8urFJ0haNy/Ho7pOpGkvS5hHAPmUoydqmw1o/q6qwmq0txpeH2JfvPMkIqwGYsUgplwxZARtHQz+TRtnwedZ6lmXZrom7MH7y9EX17lLsf4+16MyMt4I+Hk3d72QmxPLhuUwgj0e9vMS8QDyNzphYWAuGKM+4fWNnZMtDsFMzZXaZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d98328-a5d9-4444-02c1-08dccc2a3af4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 15:08:13.1439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWREn2jZEBWSzbUcMtfrt2W5Vtd8QtXixnJElpO6l9gCsU8vu0hqNJdPrSiK/07Pjl+Qixbk0OsUXWNdq0M/Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_02,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409030123
X-Proofpoint-GUID: V5Las0Gl4o2M_FHwjEOdO73qnC7IjZOV
X-Proofpoint-ORIG-GUID: V5Las0Gl4o2M_FHwjEOdO73qnC7IjZOV

This series introduces atomic write support for software RAID0.

The main changes are to ensure that we can calculate the stacked device
request_queue limits appropriately for atomic writes. Fundamentally, if
some bottom does not support atomic writes, then atomic writes are not
supported for the top device. Furthermore, the atomic writes limits are
the lowest common supported limits from all bottom devices.

Flag BLK_FEAT_ATOMIC_WRITES is introduced to enable atomic writes for
stacked devices selectively. This ensures that we can analyze and test
atomic writes support per individual md/dm personality.

I am sending as an RFC as I need to test more and I'd like some initial
feedback, if any. Furthermore, RAID1 support is still be analyzed, so I
am 100% confident that the solution presented here is final.

The first block patch can be considered as a fix.

Based on v6.11-rc6

John Garry (4):
  block: Make bdev_can_atomic_write() robust against mis-aligned bdev
    size
  block: Add BLK_FEAT_ATOMIC_WRITES flag
  block: Support atomic writes limits for stacked devices
  md/raid0: Atomic write support

 block/blk-settings.c     | 22 +++++++++++++++++++++-
 drivers/md/raid0.c       |  8 +++++++-
 drivers/nvme/host/core.c |  3 +++
 drivers/scsi/sd.c        | 13 ++++++++++---
 include/linux/blkdev.h   |  6 ++++++
 5 files changed, 47 insertions(+), 5 deletions(-)

-- 
2.31.1

