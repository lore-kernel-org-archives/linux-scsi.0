Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3083EBF32
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771380722; cv=fail; b=An0t5heobc36ZfWBLfAreiTE0hF78ByaJl89V0+mKqXPvGLbhCbX5WMEry/8farPz8nFNmU9BocvBGSZUOp+cpLq+Pj+JCk2e4VZbwPdKVg0JyRr0fCw8vFLC2lWbax28r6Y0dMXZzGO6x1umm4/pILyDf72QrfMkpNIzYBrSQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771380722; c=relaxed/simple;
	bh=QUClRV+UkB1aweKIoA0DMdvPQsnn3/BTMMcHpLbZd6E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=l+gdAibQ/Hn/qWKCBLXmG8vEpJqWW1gPmP1anE/IztifPlK7sd17iwaSho2FYPGIgu6Y85fd0zWe71EQcMI9XQlBm5+IvWz/bRHid1aZU5JTuXb24ipYHgHVjB5eFWhU08br1ewFXXqrmeUL7kd1RvNDBCpURNdsD+6xko299Os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DogmfRXp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KnKxREwb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DogmfRXp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KnKxREwb"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNTNb026389;
	Wed, 18 Feb 2026 02:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gM7Pp6s2VsXhm9mLlr
	UQFeg6tr6JiW6c7aRy5ytVGFY=; b=DogmfRXp08hfrcqHJUQGbwo96bib67zl3j
	XZawhOyUUbCF7Psj4QigZ7uPkAz/YBdc2jIHpcSfPa7sSk+MAogMn/19/mlGzmtX
	senRkJKE2WwAt4ntXsI1Hl3don4Z4C2J4mil5wzfaejecORAQivcuiGmVreztIsK
	V9a6+feVaiz9iMUKt4TYY1q1c+vouwwO+/133lvnai7IuPHSkBhnI0Z39PW0cE8g
	C/JvsqRBqDUKDhcYUU+Vh7x8sVSJvdlGxk/NNNmdhCSFGT9ZA65u6FfGNiW9BXut
	BVLfDwk/77tU23hD5tjGr/wx3x1aYY6Ci/mQssL4gD91rxApZ/sg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0rcshj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:11:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I29Diw022958;
	Wed, 18 Feb 2026 02:11:56 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2d0tb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W09NEEC7ndtn40KzidT0BCJE1+mjVI/ov8M4I2XHFtqSrdOu2yTJKAv7jknV1aduyD4sJMHh+l8KErB64VBOGzC80NVjmSv4+KrDJ2c9FFX3y6qxkZ+h26P2vAP1uKYLQp1nHOGwOtPwnRJspXMdpwkGcOvwYPymr/5EcfdhglFvLq7Pr+WSv0raG/SkGf3qKOKldVIDc9jR1yoW5zAr0p1CRmPHQeSyIZGOkIY9fBQ/0FkIywxpCJJf2E0MosAkoGnXGOWJi3wTkzbsuveM2ItAHUut3e3NomGsZoE6w5VefnLsb4IbICqeRbvPv0SFDLOFgy4TCviBeM6h3ZodRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gM7Pp6s2VsXhm9mLlrUQFeg6tr6JiW6c7aRy5ytVGFY=;
 b=CvnWqcIKzFsyUvq2qH5afio8unX2e2oK9sYbtBQxE5UL0AUAPChW9QwfaP2m4+DsbaTMWDE/OtUdgcpHCz/HpO7v06MmqvDIbkWB6o3PHE+2dIxd8/hlnXtmSbcs/SP+R4oXwfLfDvDimpTTvytLfGCwCACuu3JbC2FKp63uw7UrQGh+wgF9od6LokUm/wkxxk1F/otwUIfHA7ShNhnS8q2Bj2mJ+t0di5/lSwBYsGHpsG8RJLBmMo3JzOLHSdei7Kce+jz4X9I0+qh7kZRGu0rqyVtzLqhlEsLxRvURKeefvLLrL5cKsyzm5ObNY0qBu4vMdJ83jmaPH5Dp1WjUpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gM7Pp6s2VsXhm9mLlrUQFeg6tr6JiW6c7aRy5ytVGFY=;
 b=KnKxREwb324bFzrjwZTDvxQHMX09d0YUCbE67DaSwYbTrsVzTjfswqYw6BmEAZguZSpRsTCUCPfYM9Rm8dY97+h0uqHVPU9DMxSIDvtk/0kG+6cvzfbzy6pou80sCsI8S3HuTyvhgfcsE5MB5iAsx41TjM1rhKbTIbEhSzmeGnk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CYXPR10MB7924.namprd10.prod.outlook.com (2603:10b6:930:e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 02:11:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:11:52 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart833426@gmail.com,
        justin.tee@broadcom.com, Mathias Krause <minipli@grsecurity.net>
Subject: Re: [PATCH v2 1/1] scsi: lpfc: Properly set WC for DPP mapping
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260212192327.141104-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 12 Feb 2026 11:23:27 -0800")
Organization: Oracle Corporation
Message-ID: <yq18qcqg5re.fsf@ca-mkp.ca.oracle.com>
References: <20260212192327.141104-1-justintee8345@gmail.com>
Date: Tue, 17 Feb 2026 21:11:51 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CYXPR10MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 78723087-fbcf-43c3-20af-08de6e931509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RUXYjc4KGbN+NUEun224s5gbvP9+BXQw9TATO8z1qqfoorc+q8Dw068vrJHq?=
 =?us-ascii?Q?j6PeMDNni5urw8b30piEVfK4f7Z1U7ZMfR0kGHZ34+osfuzPnT0xfKa7m6yt?=
 =?us-ascii?Q?avIk+SjLvMB/nMbMAT5pYdkXIl98tEIZCezzZRnRi6EN3274+TCAYrdHsoUi?=
 =?us-ascii?Q?mglV6EzsAcOvHPVWWIRAg9aZBtmPyCHCISqCwaBUEfOYmCB/IVnaMAyOxJIX?=
 =?us-ascii?Q?BV9wcEKICHWiJFaqCc08DDylVcmz4Vubt0QRt2SzsBv/i1yD1MQQTjaaUIzJ?=
 =?us-ascii?Q?k+oGW6btxiHwnsnB7+dfwFxz22cbVkXt35oOK0QJtbijXIeQTREymkf2ORUO?=
 =?us-ascii?Q?9iUmb4veRfsJHBamg/6eqhheRYsgeHbxVgZ8QWjJwO2s0BybFNQ6odXP962s?=
 =?us-ascii?Q?Tb3xVmP1pSLt694a8nNNHHlhagwggZCBpbKxv1CiGnZsx3yKnEk8P3OeBcz6?=
 =?us-ascii?Q?eJs92kHpzQOxqp0fXs9uoA1tPkk428pj51rSRqiEtopiB8/jPRtT97KsNISC?=
 =?us-ascii?Q?JmIQSK+g4wRz/k/Ara4aWL8pViYRJqWYPt1Qm+4lJ1EXi0g8emWHa2wu9RNl?=
 =?us-ascii?Q?8WAhjUDPRDTfzYEGUcYx+uHCqE4erP4sKYBnc+BF4ll3EFWZNnmiy7tBTFmC?=
 =?us-ascii?Q?OUV00Xk4JYp82LQkFcn3c4vlYIe0bByYVUElZq99scw3SH0/0qG1ieXpAUgl?=
 =?us-ascii?Q?9EEgpxQOdlSMZ1oyqK69qBXmjv2sLKTHKjDVYI/MT/Y+NqgEYOKS8i2vOpqa?=
 =?us-ascii?Q?m2Frj7IQ3CrCk3IHWdLn4FvC6Evc4oWPm7baZHpW9ONxjXscSyt5us0mBHfr?=
 =?us-ascii?Q?buKeOUqbfkpxdFmkL7dbpQuF5Ed3bddbTBzjvhXfY9fZTFTCqmlhJFgGFVPT?=
 =?us-ascii?Q?Fc2ftbIMA+rG8MtOjvx8h9tXW67q45akOV8rTE02pojjQSHZkiaq8JHIASCL?=
 =?us-ascii?Q?BWxHsEs8E1jchVd+fwa6Ik1mU6qWG3Eg+pybp5jUAy3tc70GR66Vgmi+bnp3?=
 =?us-ascii?Q?U1nO1skQI0zhI5noViHniid/fWofa5oPoTISE1SmU6qeOci/21JmvxiSWwwC?=
 =?us-ascii?Q?ZYhva+OtSveccCX9iLmz/8SmLSC1mxmPAN2tNKIsExF9N2mTudqOtjNrGQJ1?=
 =?us-ascii?Q?3X/yXICzWKXJBC+VHmeJSRX5CaTM7yLAQTysm0w4z2z3IUCmkr0pOTotCwrf?=
 =?us-ascii?Q?SAJeQZ3rKcasdOTqVDmOu/RrOIYzmPW1Ka38SyUItoRY8OPEVjmXtlR3gDU1?=
 =?us-ascii?Q?EaRv3jO4+WMXxOVGjhyAGv+I7wZyDTigYp+l3YpihecTMdwQXX5h/6oz3CdS?=
 =?us-ascii?Q?oz2Tv19lpKtvHOfICm34yHz2Qjwr1Qigdozw9yxmd/vEWONGf6vzSbeJqCmr?=
 =?us-ascii?Q?VnrzR/npnV4FItr02ugeuKdsscXkdqoCWOMM8L2D9K0FjvvIyWKsjesaCnuZ?=
 =?us-ascii?Q?ggWPtsl2ysjsk01P6NcicfpiCk2IsBH8um5l/m+ON6ougH4s8xAKrPgXQu77?=
 =?us-ascii?Q?BK4iN2c97w5ttnj47o9XIUhpeGD0fTmpKKXCDngjTjpBKnlz4SIgjRv431Bi?=
 =?us-ascii?Q?8dUpisyUVLIbVMlPyDM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JH4OnKJ5vw4OabRvy94tYMz/W1rI64qVfb+ZKXwSr0Ka/tjK8zGtaiVYPgec?=
 =?us-ascii?Q?pp7KHrSQgUizAQsLf0/+NhvfUgc9f46R/uhYGi+i61Pma7FgoEYF4JQENw48?=
 =?us-ascii?Q?tdPJDM6xEsN6rIikYeCoew7BjING/vPShJmlUrCMz9q09kxpQsLDVmrugpP9?=
 =?us-ascii?Q?noyxC4RfHy307ibv6G8ZZoGOV7HgtJ9Tzv51nlqjLgS5UgN1M01OEz68yjn3?=
 =?us-ascii?Q?YaTApqvAO5D6sfQvhIuwYfPaoqjD/QnMwYk00n5G5W2g9Xp5fRGpm+ycXUBg?=
 =?us-ascii?Q?mSLAF4w5ucfM9+nVbv8RZ+3SrNFt2348zkk2eNfaLQXoKkeMNlMYts5HdJfb?=
 =?us-ascii?Q?V5qdnVfB3T8TzklwrW5FVmDwb+YsSbo49IhixaUfH9COUfE18jelYeB3JvGk?=
 =?us-ascii?Q?U5CVCFsyc4SiPTM9GHwxxeQWFzYaKZIbA9BFJZZpCNyqxEHKNKizM2EeRNOM?=
 =?us-ascii?Q?m3Yp0siNP4giXUQPddoL2vJ7wyxJWBb2ZD2Bskp6kLFiyMy/44taXsV97Wwo?=
 =?us-ascii?Q?MMFUHBox5r4el0+8CHnqyfxnRS4OMQIQdh2bgrE26bCpZ4m8nkINBMPyzOMx?=
 =?us-ascii?Q?qQDVsxkz/WgylKmZzSRsMOFUNVUQh1kOYrqHARN7po5ihCG9R1cSSn+xNI8S?=
 =?us-ascii?Q?Paf4OWUJbNXE8v5dSAjeWzwzpl3dAvexxwrgBKnsQnVovQdMO5NBPn/J6/aq?=
 =?us-ascii?Q?3NIbNXb7kQJSh3erU7h9De6HNAJct6NzKVKfeC+iOvQ05s2WB89IxvDNoZ6G?=
 =?us-ascii?Q?v1lfjRLBwzBKSFp/X5s7yXpeMZF1Kxe8VjvM5JKJHYFS5wLp9hQGqiYGuuBt?=
 =?us-ascii?Q?McsVGC3VZO2qAlsSKfq7xh+roX22QilKKpV/yEzqG2E3+0Zb/UBQ/sVNC9pd?=
 =?us-ascii?Q?JqE8UC0SxQs4C+SGi/bp2naAbAe3d3ZyJA/KAKivWFkjpt2W0aLK/pa1tpPT?=
 =?us-ascii?Q?d+9J/w2ItdGoYyMlL31dxOaBLoPmdv2XbKl/C0sXMuG6AH/eRc307YLz03Mk?=
 =?us-ascii?Q?pxWzsN3kFkTXYUS8dvfrvr4i8mwOmHwIbeZgkmg/AKbVWrK6GdloTaLAiOVd?=
 =?us-ascii?Q?LOVp+Wp8dT0wb0ynxjW6JgH8dXkNtBPeaEjMhMqb6H9skolsx2SawHZUZOvD?=
 =?us-ascii?Q?RnvTsJOHHsxc/k5xawMGujgLwvg5013nigpi3kIcJ8kvG4+9WMQy7e5IbAPW?=
 =?us-ascii?Q?ek5nvDIhcOrVO+WTPJ4jF1WHCSULzuxes/YP8nR4cUjhtjv5ndDgQ5wi1BGy?=
 =?us-ascii?Q?o7Sk8JsAYkv908/x+NlJZp7Ks8haZxlDTDJeqcKQm14hmSwvuY3z5NYAuEW3?=
 =?us-ascii?Q?Uw8o1Hax/Q4BGcNHhrz/M5Flj/0zU2Y9zdEclg55cwiTVZcOIZwv4fXD6ulU?=
 =?us-ascii?Q?hoyBaXX9XjuNj1gZUGJJ6Xtt72rkmGCDS2E/OhU6VCAo15G6nxLj8w9IW8uS?=
 =?us-ascii?Q?aUnOlnpOOhlZxr7SGs1CdsfKMptGcPpO9OTu9xSqAFcaosg2XOqy6DTePOX3?=
 =?us-ascii?Q?PhLTaNtbt6v8szH05zPbtJ7nyethPZ+5WOVllStaz4anyB2FcxfklbZU0giw?=
 =?us-ascii?Q?Jxwpu3B6qTB8bxWm7Trv6ZKji3d9T1OGYdngix8+RtolE7Qs2q4OOIkpQ5My?=
 =?us-ascii?Q?OpQEpmO3PW/0LSsr++mrkerWnakcvHq7CRLyJfCpf5pMhBES2d09z7YA9Xbl?=
 =?us-ascii?Q?qpybHa/OIFMin+wHNWCq0ttenVQTuuYPKOYLN5D0tEFP8ZVaqpxSEpd8ubp4?=
 =?us-ascii?Q?3FEGkK3Xl/m3azQnarh4TsPp5lxGjiw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0flY12RYH3+h6RtDM3tpSYRo+qJvVPE3yMbFOB0H00VMDmaf0ruA//QgcuXWiR3UrpbRBFWV+MjM5j01kPTEDwWWdekv5kOMWnXwXHAMQPqmnvbbCL6Au2k4Ep9rJrUMMzKcVnga+Zo/zn1unRnz52S3gvs5SvedfEpiaUAs2sZF2UitNL1TTylkApNTt5q1Myut0R3dZnmxjW/JwmxLLDGn998pOw3DwLXBjBLpN+09HbQg81sx0j9Io+5wAQmfzenVSqjQr5ac00F6iHtiOO1gjT98Grg8L6e2C8YTt7mOAaENlZFUJDpHSJsYuoCnbYD9Df7MvsDxHamfnmDu6Fryi6vyIBg6UQBoTXjDPCB1XGmmr7IDCqhuhq3tTtoc1I5Zuk72IuAUkDH99SSOVBqA/e9KWhdBfvH6DFWYKJGTEDmB+JxNlZn6XP+SOfO+sVvE2xrsDgYPGmWIAdDkdDLN2MhNk3RBL+7vOspvSile7JurEG2o/or8v7DAwb/NxFkWockV4mtPG1fVWSQIYyTNda8kxPctsi8AEP/uA9m8glKbFjvoMQMKIavMGvV8DE/OiOWM+LA2Tgy4iDXpYoD8SSqDqDu/BcRc5HPi1Cw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78723087-fbcf-43c3-20af-08de6e931509
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:11:52.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mk/qZI6VKUuEwab8bOqSZdGbpMUeJzwiVMzaGfSYl8AQVh7gRhB7G3Gb01o5RsSg3G6TOp2vPdLKEGSRHz5o9gIZASh1VRD+FXw1KNxkeuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180017
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=69951fed b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=I1Tdq7DQItzesNog64MA:9 cc=ntf awl=host:12254
X-Proofpoint-ORIG-GUID: 78kBoi1-r2SJ6NxqNMbx1Z7RHQjeF9PA
X-Proofpoint-GUID: 78kBoi1-r2SJ6NxqNMbx1Z7RHQjeF9PA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAxNyBTYWx0ZWRfXw4zGzItWb6iC
 CHC+oM/MrDE0dBgXfKEuPLN0meBuQx9H9Kt73UQe7o1DVYOPlZWBbYilglC52m0i69SqSPEuF9B
 Dsf/1kzFL1/mFdyasxkuShc/DFdgUEjrvF0Wpe+2WVMWlVt8Ouqc4wbkc1yVH6AH58k+F2+PDAR
 NGBqYccdigB5EAcboWCu8N4QPKn9kHlaM4+05wNI4nFkBcVwE+8ZJCF4bxvluk6A5leeIvg0kyj
 aP4gO5eO7qPm9hc2Ja1bs4rw3ne11/qfl6/bW8Kzi0mvH/DCB57HBwpnjrKsbOXHDR+Idmhx7cg
 0awsH+bXiqapJ/pOrxbILjV+18oj9lYnuP3QahfvnCp+uI5iXdwLoOtA4lLuJfmWFb7xInYJOQ2
 ah++VtuYUX98VtUEK+ZGnZ7tTrCOaM3+EwH/TsxIRVnCJMF78ryOxZSNOTaJi0CiUqugZa1AEkT
 TXZ3zujlA8Q4qUPoGSp5HX8fi82AXCoeToXNKFBY=


Justin,

> Using set_memory_wc() to enable write-combining for the DPP portion of
> the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
> only, not MMIO mappings. In fact, as used currently triggers a
> BUG_ON() with enabled CONFIG_DEBUG_VIRTUAL.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
