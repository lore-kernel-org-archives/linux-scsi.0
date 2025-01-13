Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84351189F20
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736791726; cv=fail; b=XkCbxl0UGLEURmL9rbDQwYDzlE8H5Wlif4EiL5KcLbebpu8R4/OawoA4jYo2178PT8JSB042itE/xJpakqLpMkifpd9FTomGQtzoJnfT874ttvIZDZnnMtlnlrU11YAFBiZKN4ejvbCKXK93Ta3JOEpuFkrtllfFQOcqj5MTj6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736791726; c=relaxed/simple;
	bh=sBUTkhMP6770nnWVcnoT9/jV0dDk3s8Ybnp8r2q99eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=n5I9e5BMuZzuxk3QPNZcQCuFonnPBhCszvnM6X/YZr9YYUaTgz2USxGvUCYTn0xburKqZ4NG4kWTILBogQFNvHWJiDsZ1M7w9xTtskTXXhHxBdgNrPcCGXH6EF8j5GN27qgDFKmcQfQmJrEboOk1xxFLF+pEglacjxVRyyv+/Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mHS4cWB8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=it1EIbFV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mHS4cWB8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="it1EIbFV"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DHMxj6029452;
	Mon, 13 Jan 2025 18:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=49ya/Q8aKCdIvMcU
	1tnoJCbLUOm6FIdzyBaYKQ2ad9w=; b=mHS4cWB873yKdnD+L86udMyjxQRTNuV/
	2EJ9RYXibJ/A8f167s+RP1toJitPMFDNu2mzI9e2+oCgC+J7vZpPY0GR5MX4mL2F
	CuZquc7W4O6i8pXbp7+Tale9Bx/FIuBfIh0UHA2xEm+gkBdqYpHugWNU3szyqAzv
	BGS/jtDim/TqAFZfpVBa2PRgcVeEFA/JDJlCnj3KfE/9xf3m99tcIQ6IcMFKLSiP
	7Z1Yn1ZWXHNurkVicLnICik/+11SpWqVhQCe7epUlluohegHNR28Cf+x9A5TID3E
	m+y+nHCPhicXp1JXecfnHGPtqy9IcPagqu+Xtt+69VWnewpnR/TJ4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gh8v2yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 18:08:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50DHlJmG038717;
	Mon, 13 Jan 2025 18:08:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f379m8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 18:08:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUBaO8O2Rhq2GRHubdKCaWduEUTeEsKrkxOJgxT8WGBFa5wIS7pt7XS/RtUtb7EZLfK5KoSJdwrVzqqFsHUyQ/5jG4uolAoIgPjinolyRILcZ7Vlba7fskcp0XrBLIoWmQilZeBfo0UFCFgBc85Ze44oYxa3JIckG8wzTYz5hazh3ZpA0LJXJ/uUd3e7d/duqM0stGX7ofe69vNhRMuVxArpxvc0QOd42AyvI96jloH36TMHr0W/2NCo8S+yr2sC4eCeZwFv+3effd9u7I5zwVg9FCxy4P7qFKlzic8Ia47pz1OkY7ofhSIVB02ik2BsWmNIEwXn3qedV7j2I2uvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49ya/Q8aKCdIvMcU1tnoJCbLUOm6FIdzyBaYKQ2ad9w=;
 b=TQZ/pWagfsMFUzw1mclk+3xEBxZ9jKXlUtLuhsIBR2n/WDy8gL9/zo8kLuhxSOdYkP7CAthIwnF4uN2R6v5aIrOEbOQ3i7pU688wpxEl0QBVpkM0YjWsMOZ4EK68pFlSYpKL90cDGJdjIx3wuY7nlssB1iqtF6OPUJk3nZMXzH4u9XV/gvKRH/t6Rv94hSt79FSnwEESEsR4N1xknzXO17bIBjQm6kCoC0dfA4BWn8VAngQdQ9sRDjEmRJeuTvspIkJzJhIleeAw/u0t6kRnbuAu513/YhUqnpy5Qd/sCt8tcOwuDuu8oZnl/gMtvFU8ul2JzESWc9vG77fzPbOnig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49ya/Q8aKCdIvMcU1tnoJCbLUOm6FIdzyBaYKQ2ad9w=;
 b=it1EIbFV7UScnqP0Ogv50dKuYxUGSaMYIf6yk+HJrpPMdT+5j7Yzu09RCuy0ZB3+c9vDuvEDeVNTNDehVcuKmIZbg/4XZPWbyn7/Bj+Fd4ZhMabqzDXRPepmdW+0ylaz4cIsizznUiEtldikU3w5PeADyHzAUX+8ygmrXBYnnXY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA6PR10MB8109.namprd10.prod.outlook.com (2603:10b6:806:436::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 18:07:59 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 18:07:59 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: Add passthrough tests for success and no failure definitions
Date: Mon, 13 Jan 2025 12:07:57 -0600
Message-ID: <20250113180757.16691-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:610:e5::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA6PR10MB8109:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f8b9697-ac37-4cbc-c77d-08dd33fd36a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SVsshNd/qLRt/KKDYx4gf7ql2jknSv+5OhaPNvswdBsSzdxLNodW3A6CFmfU?=
 =?us-ascii?Q?eOsph8Ls1r/CKbD4xiXrHlsAoh5aRn2GnCW4dXq4S0rdaStigLPE1Ha4HqMr?=
 =?us-ascii?Q?Kzl/MYN/6U1xSBg7GxQiTMj7GIaWwH/W256ymt1BluDGQZYQp7bMqY/AniAn?=
 =?us-ascii?Q?v4utakr81qi1Jt+TRK7fI9Obedq8ZdyfkLunBV3xp0+/8mqISLBWiN0bROby?=
 =?us-ascii?Q?OLUfcDCsCdCy2bLdHdOvhi40FDAPh9ZFg5Dd/GOtyjGDtbaIidEAAqRd84VX?=
 =?us-ascii?Q?pPLIHJN3IJfn2Wwv9bUto451Fq36BbsLFICmgQRdUA2veavzhGHKTaO/9qJc?=
 =?us-ascii?Q?Qh2Grdrw6NuKwr0gqX7Dm+gpm2PIW6/eK8f6iwVHL5uzfrg2SAb+kidRcFak?=
 =?us-ascii?Q?mtBIWx9pr0fzd/4XvsDTLzCeSy7JCzor/XRTyjnD49ZGnCoXuAZqGtcDlLlZ?=
 =?us-ascii?Q?48keZZLORwMN+WMvNkmEb9Aoh6kHFrN3x4f4uMvDdakJdgfSWXKf7MqfxiHH?=
 =?us-ascii?Q?TFROk0URJWoi33Zw3KW9Q0BUAzfMd5NSfzjkvxFPAf9jPBc2D0JODHpvhQ+x?=
 =?us-ascii?Q?eDqOl1a0MFHDHq3igCyDZcomlD8WyCY3UPdBw6iesAfNHpYH6tpZBo4tbjgN?=
 =?us-ascii?Q?bn86S9mY6vqwJ8AVWzYKqBbIgHnj6N5TB+H9X2jjmbtutdXa4CWFGCrA5YnW?=
 =?us-ascii?Q?EZXcqDraS1WhkpLB33QKSRTUMvh+aOdgi1xsq111GkKRE1mRIHXpqMaPD2to?=
 =?us-ascii?Q?4Dil18oQQ/4+1d+Yvkzl+sHhA46HFg+hvMHkV3nUzrEyE9Z5T9RKDUoGAYgs?=
 =?us-ascii?Q?B71ZE6NaVr0suJVwhYyAy/XSbSTALLp5iCmDzl7icGhBz4kQmz7UD5mb/5XO?=
 =?us-ascii?Q?IwX/SeZqH5D6XCdUDdPv1JxKVkPXT4llXxUfLsQNme6Ex6Ks81oN0ylftjSw?=
 =?us-ascii?Q?7qoYHT6GV4YUYsWlRKfJVNkZrK2565Y4LDeswWrkS6jP4QagAsWFUxvCxrdi?=
 =?us-ascii?Q?FicGl8N/gIxqeXSfzDf9+/0MTaq0N1FlMCjX66oxQUIX2YF5mQ4/8yrRaqBx?=
 =?us-ascii?Q?c3yHWGX1rh4MD/woGlw0Rkv+fv817kh2699xC/Kho4vfL/CJaoVL7puB/Z2W?=
 =?us-ascii?Q?mrvjmQJc+wOZBMMTPqTxX1e1K68+T1BR+vm7kR5NaWZzxuAv0gT2wI2ftlGi?=
 =?us-ascii?Q?9X7VMY5eb+nQwoSxuk3Kf7G5ADxOxuuLo3fjIFjAA9vgF5vCxWO48W1aGpJB?=
 =?us-ascii?Q?56K8bMExo/ct+kl0vLIifTbHn0lpav8YOEUVtyYWlIq8kW3k8V+YD/DdEJeZ?=
 =?us-ascii?Q?zueaMze+RjThr4UmqsZhwrL38LEXsNa0x6+sC5mreovIHR3Xpcz2EX42B25D?=
 =?us-ascii?Q?59btEm3hMc3/zEc/AsI4DzW7tzU9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hkNSqxiYwRDvQZ+tHnHcZyun4VpqeVbpol/8yAy1jTeuQ3LP3Y8RlcXZpqsM?=
 =?us-ascii?Q?c8NOZUskOtfEAZd2E1/uuo3CdK/0jdrzxlHAdR3a3FRV1jZ12qhKhzX1+Usu?=
 =?us-ascii?Q?cXBwdgPJFA5CR6OSGBQ323hNEENU9iWEwTkFUuAyIZe/U/YQRzyuQAzL7y5c?=
 =?us-ascii?Q?sVN3vnX51qGK/Jd6SlBmcqAo+vjgWEk+ltlv0W/VS8RfxjHwzKV96B9gOsP/?=
 =?us-ascii?Q?oBAZAAMyS3EmfKEWQX8DsQSPH31AueRJYKQIcjxfycJoq9xnnIVQbEfVyH44?=
 =?us-ascii?Q?muhcyEpRrCZk+jt9J12qKsWI4eNZn08C7TCfvyNCQmgHKGp+lP1zWZWZBJTU?=
 =?us-ascii?Q?Xn69xFWyNyh8RM45kOdPaz9zCsPPYG7Aor6pNm/0XSclsskuFTrmn5fE3MbE?=
 =?us-ascii?Q?5TGE+AE9jMG2bb0EEtrR4rsZwBvQIGObnX4aJqIM7rfp9eXFBU4UglsgXv0T?=
 =?us-ascii?Q?pg/GtM6uPhj6rlisr28kWk8t+Snzn6yDN54cJ9jiQMf9t9fNBS9PQPQeV7JT?=
 =?us-ascii?Q?zpIFfym1G0OPQWx9nbfdDbSwbvGZ9baOCwSi1KghDLiqCANPQRSeby68g674?=
 =?us-ascii?Q?IvcRGz4SaLCUl0dlfbzVbBzaRkTWfs49XxMB/iR3vqzqve3kwHruosGCpUij?=
 =?us-ascii?Q?Wa1FKIui/cvLt3/4NxDsLDCpKkwa82S4yMqDxqxf9ODWD72knZktL0E5rOFf?=
 =?us-ascii?Q?Gad5xVyODeOCI9c75gEY+2rKuuIHL3ucbuolgcE7g3Ml7VTNjh5I0O8gCJvP?=
 =?us-ascii?Q?WU4o2xbs3YjjRzFRWiNnKnFqQDySFG7L8VSOwOz2mp4Hd40E/+W4A7ysAnI8?=
 =?us-ascii?Q?JZwYPBiXZWiZ0zNIDB9i6p1bBzW7Ubmzt9JjJPqygRO+cuQYbz9G8D9da6mw?=
 =?us-ascii?Q?JnfeWqrhO9SoflWri/zvCjj8BaWkTpCT8mMtPwopOxmT7pWFjhnr8uWQrSUJ?=
 =?us-ascii?Q?j08AZTAiGZacuwzMG6EVJoHY++AKy0e44OIHggR/J1UZOTbr68qwtv5qSlnu?=
 =?us-ascii?Q?Rv3xeUkcyMk+fW+qxn7UIWtbGyNvmY+oj2e5hUV3K48ojLPDnIWW20fXHFyl?=
 =?us-ascii?Q?yvFutOMuamZjOf8zZC2p53+97dWJof4DNPwR+5zASjy3T4oJnz5KejMm0PgE?=
 =?us-ascii?Q?ifBGu/zD4zLXa8zXws8hbcf9R6BoVLlxZ/q672tKxU/6vkcoAPoWdJVmYRFG?=
 =?us-ascii?Q?N4hJN14fPwDMg/5iuFX8anKH/7VobJWz5I5hHgFs7mtLUYgEL3XOgmwb9f2A?=
 =?us-ascii?Q?t7F/HE2WdJca6Ww/lqg+s13/OsVli5p/lMvWYS0/gAozARFOMKYxYaCf3SUW?=
 =?us-ascii?Q?s0x+knUPY196559KRPjVcUKnb6FiQeNcpf4S/W0MG0FuKw+MDrN64wLf23mY?=
 =?us-ascii?Q?mgQyfXuMBfQglMFiq4uquNW7Ue2CarAfeVpS7Xv+78bU8um0nj4ql/5Fwxc0?=
 =?us-ascii?Q?2j909mdMeUT6HJE4t2JASIdpeawbBpEBzFnT6HSX4m3yrzRjWUEudoMEGtP/?=
 =?us-ascii?Q?m1P6jHVlqXIMdPczD5CgkUF/77RxoFYLxcOK5/tBIYhnqLTg3+8U8V7TudRs?=
 =?us-ascii?Q?p0Cx+Px6Ra2saElIUep0WiZhtN6PvOZNXp680zfqqpiYuq6ooFhlnmiJZb2M?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xTYsqCHbW/YnaPFipel7TSYt7zfybOOOqOlZssdLgLcO3l2DyWFEoeQZxGV/r1ZOUQQ5OZlQljyrAy1taET56pgM3c9EL5z4MaTMXNcoEnCtEvvtq0WGiCo1PmnUMsqr2v857jniRHpxeVZXDowq2cDlgwy7Jbr2rv9pQQf3tIlDXYSqxaQHg1hAnAzhQsXnyw/if333lo1OvyBvP4fyw+2AI/OPXPB5wYF6dpoSTikFeVF92OUJ9NsXx/Dmt37TqPGShP1DCIgJx2sEr7B2QoR176HyFOrmtOUDMX3Old4FzOuG77sMiV8JDAVHOqTBJj8MVFOycJRYt+JmJKgOTwzN6dZLUTGfc7scqJp0W6gXUk/X5eoUUsoqud763ONy4zGXAUdA9h3PSL1CmsTg8g1XVVEp/CH0YDvbwJ5bZ0lpL+VWbk77eZwwfGLdZGZmqykrPRMS1x0qn4HM+dcWdJkfzhWeKn1mxVeytTIMheGOJ/gq6RqAb7LA2uVJ1z4P1p8L9E+d3i+QH+GLab3yDN7sCYkI3kyZPsFnFk5tnLFIGYH8eEsrJ3M2YioZwJGXJzHAz3KK1xVyfQjqkeud9kq1Qtc7g5zxRpNKCeBpnZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8b9697-ac37-4cbc-c77d-08dd33fd36a9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 18:07:59.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0JoZ8QPzyvuR0APw/ovNNO+V1HOBWyduX51HC2Kg/isfB7Fnc0Sjb31isLZMYC3Fj7Y5/+siL3loNIm9HYPD85B3EUMDkolvYUd9qd0uxcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_07,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501130146
X-Proofpoint-GUID: TTeT7fIOByQdfnwQK3-DJqsaLHRwjp6g
X-Proofpoint-ORIG-GUID: TTeT7fIOByQdfnwQK3-DJqsaLHRwjp6g

This patch adds scsi_check_passthrough tests for the cases where a
command completes successfully and when the command failed but the
caller did not pass in a list of failures.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib_test.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index 99834426a100..ae8af0e0047a 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -67,6 +67,13 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 	};
 	int i;
 
+	/* Success */
+	sc.result = 0;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
+	/* Command failed but caller did not pass in a failures array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
 	/* Match end of array */
 	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
-- 
2.43.0

