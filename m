Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9A1ACEDE
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736544000; cv=fail; b=NKMhVkbe7YuiDUH8vC+8Y9De7B1SDsZuXbDQTX2Qiz+t1aPrNiNuSb7mza33FnJJhw6jTn82/wIUiggQ8I4y323v/aFo/Tk2Z9bwlYt3AI9yytwM/bFO5i2gzkzTEALEqppIZUoBfgnuUP/qlgSyzx5k3CLYKXgKTyISdOevGzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736544000; c=relaxed/simple;
	bh=v2vzpW1/7uK7KXnOWZbG1uRGnKRjD0Q//OWpiP233CY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fTfb58SwU2OeCtE+UzPtVnHX2qi7QMZWjhJmEi/yA3/NFy+50p43BEHeh+EPPgSglGfmSBYGMs7v1cLmvavIYBZRnYAJFyOmK3471x8gnUKqKG7P5hW9dyk7Nv9K+SnTK9TS6QDpolF1Bkl1mopj+Rmatodvia47OoK2hJtf9s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W5ILJP+h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tZasp/Ia; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W5ILJP+h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tZasp/Ia"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBuZx015604;
	Fri, 10 Jan 2025 21:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=mpxnzPk4cvsJ5m/8Dz
	idkqGb/82iLcnZqyPi8o6U/oc=; b=W5ILJP+hQgZfgFYwfS4LdWlTenbzJTpijc
	vsiwggc2asbDN60EyttmGN9pZxNdvIE4+Veoe0iYLpNBuO2UXrAFTlS4dSEGFAEm
	cPmvP0Wtd/YYCFF4VWurqlVKZ7m8qShh9RFOWEfoyY1z8wK1ae2bJdAfx9DO5WLU
	ei57F/+swiBN0VF7qaHUojA9QgbNl/kYScyPr2B9JWnYjvat+UqB9xpnvRH9h2dK
	+GzC/GiGRXWwyv46Fjt6EctCahuhokO9s+5K3Yc+JW1fR183AtyEr66MiyXQT6lS
	tsPXio5wbWZKvkCZ1iE4Cbpc9PZRss+0aoFPKfsuaIIUNXe6JnYA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my62652-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:19:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJNbKO020026;
	Fri, 10 Jan 2025 21:19:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuekabsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=swDqfsijAHvWUTQWeFF2VkDVLCPKlD+LPN974+W893Z5U47PqTU/HD9/fTkMgqUannROWBBkC4mle6zx/Pj9E/WD+0GeKdzGJH5IEOIB0/gzs8tK/xFqY89EB+UroKKqU0pI4eNZn5iUvqrr6VD2SHuRZBZoEgYnT7HBf+/5o3lm7xRp9LCwjT5M8ZwGit1df0jxXAT7faeAQ+GH9WcB5ivv3Nep062NWIptNW2XhqsRf3Xc7/zgz2uZKFywNXKlN1ZwVZFDSPJ0gRIs5kakMe/RU3H6Y5H3m9f0Af87Xb6Jp+KH6hO6qQkCKZI11Nr43O94DyPJ6TMqN6iSHbY8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpxnzPk4cvsJ5m/8DzidkqGb/82iLcnZqyPi8o6U/oc=;
 b=AzrhKt1sjiJzBZLp+ycYCne6eNmzeuf+KaITiOCfeK1U1+4UfyQBYaO/3P3lBa+slwQI+wDQLvPBXPMcnoPAO9f9xLU1s9xZfH6ArG5Y0bG73nUMm2cOPaYIVZZWklmtCauhco0V3Do1dhO08Rp1NAY3tXfXmn5THVtV7bo7Ak8B+IXxvWkd0B5q8C91cr03lfSYwOO0ZWYxdwuCWgww1JgBbgqRCemCLpZTWuSW1NZGoFNPN2H+TezEKZ6E41F0q+kcAh8kkT5+SDHaq5g/Fz/5EAQ8MGtE508gzHsN3PNnHw8thPIVs/0G8kO4Ae0qVcR8j0I+vgoxqqC4Zl3ADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpxnzPk4cvsJ5m/8DzidkqGb/82iLcnZqyPi8o6U/oc=;
 b=tZasp/IaQqRY4btKm+TTcBtWjlAKnQq1Kw0e1hcfxE3U1ChmQPK0UTLwI2HG4KEgUZ2kRdXV2YBE7Jz2Mmw7A9NvOEeHQEjIpr2va8fYmHOEb+NKcAQvSr+k9HZd/D1CCZxPd6xv/EYcxlCczBzENeqPzh7CMfXIW486H8abqmU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7515.namprd10.prod.outlook.com (2603:10b6:208:450::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 21:19:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 21:19:53 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Kris Karas
 <bugs-a21@moonlit-rail.com>
Subject: Re: [PATCH 1/1] scsi: Fix command pass through retry regression
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250107010220.7215-1-michael.christie@oracle.com> (Mike
	Christie's message of "Mon, 6 Jan 2025 19:02:20 -0600")
Organization: Oracle Corporation
Message-ID: <yq1msfy74fu.fsf@ca-mkp.ca.oracle.com>
References: <20250107010220.7215-1-michael.christie@oracle.com>
Date: Fri, 10 Jan 2025 16:19:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:52c::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eac6059-d934-40a8-68dc-08dd31bc8674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c17g4Kfj7ojC6u8IuySLNRRXjTmTZu2jyoccS0lLCHl9zKU+B/DW5geixp5H?=
 =?us-ascii?Q?8yYXCirNbHfl/0ksuZmekWlfBTXzydRVAM+qA+K+yIKWv2im3HFBhfAbnaav?=
 =?us-ascii?Q?IDCJWp1/LBcDUY9hpweJ+34Vdhd8TdU7X7UBRb/y5YYrwOJbNZQNoDxpBRHI?=
 =?us-ascii?Q?LvZw4zWDSKrGUGBJwKmNV0z2J9205WHsGYElB4LO5CHfLUcxmrzXdtAiw34f?=
 =?us-ascii?Q?ks/yrUp4t3ewu0aX13N6YubhtbEDOInIjDDaRRkK8ZNvUctJFLiNH5Nt2kqK?=
 =?us-ascii?Q?GGwqbui2UYkNXDhN+9oUiEwINSRvFdWLS9RNiPPYRBDEJ9tIMylDwdhFsNRC?=
 =?us-ascii?Q?P85zOrbjJZpjwL1p4Z/vYV8LbuJ+y30ndn9l18NsdWOnJRNTDE0LQcw4Ji5x?=
 =?us-ascii?Q?gSEMQCsxr2HazSgTwTzgtBixmgtrM4uqHHG5iB7Ws1G/NeyfDQ59QkUVNCoq?=
 =?us-ascii?Q?UQ7ycciAgj5tKIKs6myiB7ZpMq3y9fn7aHhqme0SFc+gmhWaSsAzpmGVzQXM?=
 =?us-ascii?Q?uBk/FldqhXYDTikudkW5KS2PcqMoFHQS0coiogHEysviiQbnT5dl7q9OyLYe?=
 =?us-ascii?Q?z4THG+dIKQ7mKp31B4wUZzEXF/tZjdW2TmBBaDHvKROKD9ir1XyZviOvSUN9?=
 =?us-ascii?Q?cXEYSuai3W9d/3L4bhWBG00aC4F+2l67XPSdtu5dVx+dINnTmzZOu3pK7tiF?=
 =?us-ascii?Q?UNCO8C/pF2v6j3oR2/pNdTW6NqmUhK/+jqPmPz2LGCsACNJmoFUiA0NZ2MXH?=
 =?us-ascii?Q?pg5oiY6lXM92Rb0S5Cmf+eSpVFt9ynUufx2wWuHt+XQwTlmkB+UX8S0Nn/t7?=
 =?us-ascii?Q?KGOOpBNi+HZb7QjEaSFmWGXV35AGiW4XPa97UmvnFwuulzEhGUE/diTFWVjf?=
 =?us-ascii?Q?oiHIjlhlGQBNUCJEfkg/8226s6WjjWoepfPbYUdcNrQciGAiG5P09WxQsAyr?=
 =?us-ascii?Q?jd8WiozqdRZ5DrxXOwms8FhvjswzcVtGOUxlwJpMEOLsub0U2a2PjunOFyRr?=
 =?us-ascii?Q?+xcrdrNjbTh0PUk3s6tPXzesLFaWyVwWXPgGkLW53nDsgVCpxNeHEB/PuJxq?=
 =?us-ascii?Q?MnMU1CqKAylwO16vhNUpIgm4360rMc2x1V3V0HjZJ6wcX+hX3VbckWvb92mL?=
 =?us-ascii?Q?cbppYtGSp0e1GgRULbWDZDuEfb5d2TCIZGN8Fa5XAMnhp8zYUZ7eG4ux8NGv?=
 =?us-ascii?Q?zsBhduDc7dZVQ4YLoAW9WabSquCUVhTj6cedrc24WmXWbW70/eV9/3SJKT+C?=
 =?us-ascii?Q?ueCgv4s3s4/DEzmgUTszZG5r2c1JhTJsRiVou5Aetv3b5MMuHEfVniJ1MQfN?=
 =?us-ascii?Q?RgMYnO4AzWxxPjhDMXi+ZxKhLm5UV4qOffUM443VU2nA9S96FZxkcOdmUNGJ?=
 =?us-ascii?Q?tSPYs/J6AKQ7UYsF2zzzHuqONdNw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fHsd7NEjN+fCht6jKZ292ssMA4W6tMfNOp4A7Br5sDbBjyWhqWhfcv6pmrqq?=
 =?us-ascii?Q?t/jEt7twDqPwDXLzplvv7fhnUVhjISdIL5EVAomzm6cTj8ZTLZsIa56qAFyp?=
 =?us-ascii?Q?L0pQX+n7LcR0bqeg1elnWUGNsW5f6CiCUdKysY+miQIKYQGjUck3tdZXvoyC?=
 =?us-ascii?Q?OqewqojD2rLJ654LzbkJYlGutzdAk2wTNsogggPSZK3G6JgZnYzNT+Mj60u8?=
 =?us-ascii?Q?dYT25+vVRC9UwHnlzePv+5FsPGEV/1uLFDJhZafKlzUggW02A9dMTZT+dWXA?=
 =?us-ascii?Q?0qKIScNSpgX4NRue/7Wz6vwq+h9ygwLZolZpj7W7AHyHwF24nwa/S5f1AYMv?=
 =?us-ascii?Q?sVsu3JPMI8jTHl6pcX+AwWj2RQp8/ZSOaK1VNmvlXEA4lSq6nAIJwzvlCZMD?=
 =?us-ascii?Q?a9sOSZdTtblWvt1/+Gmiul6hii6/XELBD9cYqhDsNRdyGY1nz8ingtOL9kC0?=
 =?us-ascii?Q?9eySt19WcaA+OTp/mKCT9ViDOnUctx5FEhfnV6PklQvJNfk6rlspdYJCUThN?=
 =?us-ascii?Q?BEjJsuiB3AhcyWQ7Tsh6M0sR3WN7VsxFmYdT8mjk54WH5vI7MQDYKVwvRv/I?=
 =?us-ascii?Q?40IIOonQubr2X46HiMMZsUQuNdOcIaqR8oGuL8irXkBC3cSF977cu3pCbNQP?=
 =?us-ascii?Q?Ng2cgHVbAXtwYYFXoUOwopCzx/xTpPV3CdXMofKFlvJYB6+RSRm5A7NHEe5i?=
 =?us-ascii?Q?0kmX8EPRKgn7JMlVEy52iKOKIlb97mrcYMB1ieuHHpY4BuecCxUqPXd3GePd?=
 =?us-ascii?Q?++v0fSjj2G/Je9/nHVYNl5+6z+fHKRTTRcWRxCrU6s5FBqT8gldv11RO3ys0?=
 =?us-ascii?Q?hBPa8mgmGIoY7CBbiSjJ3yhQWUTC3aWM/BHTUzH/3kbOhoCSj1d1I+uCpzxN?=
 =?us-ascii?Q?uIh3564abaEINZ8GHA0tgkABINagLTmKrZjhPamWOBEpw60qoMLeNYPnahjW?=
 =?us-ascii?Q?/VIW0F3ygBZNNxSGo4G/fD9t8E0fZ3AfT062P2ZcalldwjOK87x85oLrxAm/?=
 =?us-ascii?Q?LMiOlVWWfOv8HoDy7pZ+3la6lACLED0aIHV6+V/iLCnOWSn3wRLl5IzjlDBF?=
 =?us-ascii?Q?VSfMJ+WNs3h6FSb2UDXQBNeOFdkniXfx1fZxXYqmna7oQDXWFawdvDnTaapx?=
 =?us-ascii?Q?Yk3hsou5t+giV5v3i32IC9FpCj62UYvalO1WBpdyvirj1ARlpg+kLOF4fmyv?=
 =?us-ascii?Q?PcQ+ScshosNxHS9cfVMZGfMx1jLs/aZlYv1JKph3W8MYKqXMXkITC54b0UV2?=
 =?us-ascii?Q?d57gH4YHAL9XM3eOAc0M8i0nlc1N+PbKnsM1fDlCYhwIHSMB298ykC0P7ki9?=
 =?us-ascii?Q?jeWeW6FDwoWm7G8FN7gPGb3M0lsXoQC6cqCXYGMB4pyNdA+elZ/7ZwZwWPK9?=
 =?us-ascii?Q?rfO4Ld/7NozXxfc/qWtVVAndFbYdL4UYXdFuyTGkUtKwpkIs5lvxtkJismti?=
 =?us-ascii?Q?8DJsTXLP/PQ8Q8cUNILX19rhX5yUJb0yl2+roYTpAHncOPqA8sDDxwlDxyod?=
 =?us-ascii?Q?GQRGco8w2zAJiqj1EzHTdFEfbWbJ/7H6HjPsR3RxcEYsioMLkOUgaMht618/?=
 =?us-ascii?Q?lJFNiATcilTRFQFkkg0QGMPGW2o1oy1X4+hhufRn/5ZQ12olSHrnid3k8p7u?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r6ez+p8548TbUEl0xuZSG46F2ohPO+sWjU/olOwct0IdFWGn2tM3mZK3y/oQRG3M9G3VVyntzokK1xK7AISp6N7zWMFgpFu5RMzZZ85KBGYQoE4BSIxr3qgmPesJ3szkES72aPftAUadNRTV4SqPq4NeaZDL9R1JpPsCCY48akhgk32Ujq/SY2wvr6uRAoHQyOSqRg5pDJBm9zr3Y+up3DL79BGjGB3WbSisScW03MZnvsYqLWPcBxpad8ZXEuWlvjsBHnqM3tGQSaEn2xscwMnn7T3PwV3eJHdKQnWsQ6+zgqC/jqYuFSbOVmi4/r1GoJ0A5uosd8iBCTraTeLdgxbRphmDjf86NgBh8V4VVsSRQrvYrp2uN/qcU0OVYEfZ0jCTwhQSUfS0V+KVWy9lFtHZituP+QQ4jc7A/accywJdOentTgkGJ9l7NG+Om0eVya54/u0eQdbI8m60iq4NiACMGnDglBZSxeikKY7jCvaG5Ku1+Z4FkoYzQcg3zYvYStQtHncGGQ34RvR/oKvYo9pRnNJS7ozqRYzGzFvt0bhMDsRctqs4l/cC/djdcw6sCL8NM9Sg/XGfgJCcDp5F2gaQCb/fe5hAqSvozB1O0ow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eac6059-d934-40a8-68dc-08dd31bc8674
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:19:53.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJRk2crAATzy5+tsNRWZk4sujb1lviNKM0crXkAN0dQH2SX8+D5TJsuSl1FnVCfvgH+zmS6jbrjHjL5k1DZQ64DGSERzsq5AbicsLHF9HcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7515
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-GUID: Gt2DUYOqxO6-X9SjdKKephM6MydABXgt
X-Proofpoint-ORIG-GUID: Gt2DUYOqxO6-X9SjdKKephM6MydABXgt


Mike,

> scsi_check_passthrough is always called, but it doesn't check for if a
> command completed successfully. As a result, if a command was
> successful and the caller used SCMD_FAILURE_RESULT_ANY to indicate
> what failures it wanted to retry, we will end up retrying the command.

Please add a suitable kunit test for this case. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
