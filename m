Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EFC1991A9;
	Tue, 10 Jun 2025 01:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749520795; cv=fail; b=Pv9G7QPI64z/4UddXI+s/S2xva9WjPlsFKTjhoqGltU5iezVTDSRWNKIG3GKJ2BAUhA0cvz0exJu0rN0x4mEbl0V7DU60Gg0N646jGH4I74gxO9Czm+E9Eu+yLeRChc2gtpNhCxude5OeOLjC0TrTGLl3HeMq6lCXOTg0TghMNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749520795; c=relaxed/simple;
	bh=QpiyxZYRZtXjU897nCmCLQvs6EHuFLDbqGqBCVOfet4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IoYMMi8UwVvs3COGpElUdy4YO0k6LBJMOfo1Pd1opIgvWJz2mvp0tWAlIOPYA4Ggkbl7YizGbP7WN34jDNV+hcFxh5Hdd7K8vShPN3pB1q2rOKWRU+P2k1YeNwJ1FeJjvK5CcJDfl6gqV7KnKBLYeqkojBoza8andMPwvl4VgS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S8dNJwIy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wg2DklsK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S8dNJwIy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wg2DklsK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559FYqZu010888;
	Tue, 10 Jun 2025 01:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rXJAkbpYZAzQnwD8pW
	O7V880x9slM7RfmiKwte0+WuU=; b=S8dNJwIy8hNzyZ4k4hWiYJsoDt4/zRIzk3
	dWjutoUBmjpXkWboTiqcscyf6+Y1At3szSk5OjF2dfLlNDGlO/HPZnS3mLPTQ2IP
	FpNoP+pq2bf3Xv14EfMF5RmHQZjMYaomkWaqFw11D0Qx6H9CzGoTh6PtIpJ3zWUO
	ke+sB4gAZnyDblTXq6CVnsL2YzJVk2UXfXZsWopqF38G6765NwJA6wso8XZWTkDi
	g1JW2QeKlRlQBor0yIEtNa9FmHGOT9KLk3CXtlCYfNYOsYm/Njb0sIaz7y4+ViSq
	0P5o8u4DpbZXwZ4QZygIeUaVFjU6fAIXfEp4P+HOy/CtYKTS9NXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf394w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:59:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A0PfN6020395;
	Tue, 10 Jun 2025 01:59:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvec5by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:59:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1Fh8coZ/z++0erxt88nJpzjWQd0hSyGxXbIjtCAXsibE/TxCQZd7oFVs8Qx4XL+lhCXw1kJY/Vh/T+PlijqY+vCZaHluXTEGmXgaRcubEkdB+4I2BAsvA+MzDps74Cb9M4wAXy/61f6vlpdxqpgNjUh1F+PaxK8RnHX3rQH7A+8fXRPZu0Xo4/G3YUfltuJvtWXtUfQBCpuZ9t6iAHnTR4TLnxWrOsSCpCQ0kt4k0S3YxyaxRUIIze0v5ZL/vZoU/9Ece083PZnOVRDDYrBklVK/eyYngvOl+xv9Z9nBgsbMGhtM+vagXg5AcGSHIHIyE040i4komy4fb+Bm6NhoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXJAkbpYZAzQnwD8pWO7V880x9slM7RfmiKwte0+WuU=;
 b=ENBzw3CdqZsgm93hQT1Pxt5W8d5R8T+Be1LFnjH/1qLDdh9nULgwZvCTp6y7nm2o+sM90s1wjIouNUNZ3K4rXs/qK88KNOnujrSjEYp8x4oA5WeGFesMKMkyFT39lAAEmZcQSPvvnLoucLSMk6oLDA0OsJo5fd1eRdMdZqqSEF7QkRsO0RjwytlHLMTE+/B6bc/nQpr1bSiEXiQeNwacNhreh4wflRMxQ1IxFqhRdtUeRKb2P3caVJY3Ds9vCllI5S6Lw44+h9Cs5rNqbvZrGBa+VYU0NSkYZD69QfWLyuUJmO73kN4eWeJVJ/ILuXzdWYubzOTosKgnYtuQm5oZow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXJAkbpYZAzQnwD8pWO7V880x9slM7RfmiKwte0+WuU=;
 b=Wg2DklsKkH/d05PoWYLuDRO9gp6eQeg7KehIOZk8VYDlxNbjIZbVzUq4A+r16DDlcUFCOTlyCBY2IL3xNYVW27n+1GqLTRbV0uEQglVpi3Ix3hEbaINahnopOCMRxuDiFBQzPNKSHvtId22km3cmGMYYwAvGwQXIETiMr6XWcgo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ1PR10MB5980.namprd10.prod.outlook.com (2603:10b6:a03:45d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Tue, 10 Jun
 2025 01:59:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 01:59:19 +0000
To: Kassey Li <quic_yingangl@quicinc.com>
Cc: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5] scsi: trace: show rtn in string for
 scsi_dispatch_cmd_error
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250521011711.1983625-1-quic_yingangl@quicinc.com> (Kassey Li's
	message of "Wed, 21 May 2025 09:17:11 +0800")
Organization: Oracle Corporation
Message-ID: <yq1plfc5pch.fsf@ca-mkp.ca.oracle.com>
References: <20250521011711.1983625-1-quic_yingangl@quicinc.com>
Date: Mon, 09 Jun 2025 21:59:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0072.namprd15.prod.outlook.com
 (2603:10b6:408:80::49) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ1PR10MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: dfe9cabc-4814-48c0-99ad-08dda7c26998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BQ/d7NICTQsSgEBiLnGTTAjOkBz4Tfpc6S7Pazs9S6ftJNx3KMT7bP+BSjDL?=
 =?us-ascii?Q?3ZRURVVSPDbT5ozdgliV2MQ6IJbHUWXqn+wjxrv0f1R73EqF3Cz6ZRe9P0a2?=
 =?us-ascii?Q?53s+bDnIANyxYaQynAUogAxyIHPSdi+K+34ExtRm0eyGNYPKsQGx2vYttm9Q?=
 =?us-ascii?Q?yuzrgN1/no2NJkVy9arjOvTdgwicCdzEurIeTFKUG2MzNiEipz2bLSokgC1s?=
 =?us-ascii?Q?j6MhMgYMd/Bx7dRQ5pT0YJ4ibYh4WQ4psdZivrhBzdxXmFRCDb6ermn/f/c+?=
 =?us-ascii?Q?RZUoJJRARxS6Hds+UoXLor5FWJuGjxl2zkJjM0bkhrV7uLm5+EGlA15xbyeu?=
 =?us-ascii?Q?Ui7DzR8CFyXFQuJjkLfxSEb5chUjsV7ae/4Lwt+UdMT0pEFcmuJBGMfqYOU0?=
 =?us-ascii?Q?vOdf+EpTupNJrHhKdoC5dKDcePQDwSdq0urqqXVEg/578Iod8eH9ilaHd/Yh?=
 =?us-ascii?Q?JDiiUzY4odiRe8nW3Gtrq6OPr1cBSAYo7coDXiN2nLMm7JuFe4FWhFNc4BgV?=
 =?us-ascii?Q?rOcnlfWOWGUfLZvb2SbZLcp+tAK8fhuhuC4bOct7gHCpVGpfvWJm523dfuJa?=
 =?us-ascii?Q?uEzTwouCCC97+3ENfMLAKZzSSpKmwX/00+NpaFxQH3aYr03ZHnX6j1ZEIv8K?=
 =?us-ascii?Q?+UVOk8ZHcKjGPT0PfGdGaoZsynmIR640/WTXZ5inojnWPdRD2+s2hAYkJ2I9?=
 =?us-ascii?Q?togB37o5Ah0hqbmmLICtRijl5IDTXOYufgk/hhrGR6ZVJOs2CQ7J0Yj6DRT/?=
 =?us-ascii?Q?mMm+B1zJCBI3NnXoIOdcASuG31sgiKi6lk/uPSQ3yznEVSLENH2xDcnfa+Xx?=
 =?us-ascii?Q?25AyHVMYm5vLBya+JABT2CD8iX1CPV2+8MC3INuU5mlNakxXlNq9UA5HCjcL?=
 =?us-ascii?Q?iToaQZO+xavD3ZQAYF8TjE1D+ezt9Yggu4gZ2Rsq4IU9uotCNe9YKFUk9w07?=
 =?us-ascii?Q?IGPVH7xJIDmZlT1bPs27djNDeSopunxdxWUWKrhTbqBcEYuCxQ5Pl5yn5WsS?=
 =?us-ascii?Q?AqKJPuTd9GLe2aXpyZNSIizCJMvgxoEafROT5CNN/0BnJgkqcvw+CNYpvU9D?=
 =?us-ascii?Q?WWIeH5QZLJBv13BjUFZGEdFJCHbJ7UZtGUC4a6q1r/Qpy2Y54SB9M69GlmIE?=
 =?us-ascii?Q?QLM007QVfYCMJacYCWRvNdmTitcN4TKqVqcUI1WotfpZE1EHbCWUnZwyQz9p?=
 =?us-ascii?Q?bhQpNT0yYY8hz208m8VCFAa4yErvFrqBAyJA5014M5yI1MYVzKwv+WTrR5jz?=
 =?us-ascii?Q?9veHfcdgnX6mj7FlO+/Br0FN9KaNF7TwETAv2T+RZJNMZOmDA7zQeWe+hDVL?=
 =?us-ascii?Q?vYm5dR7LcyKsN7Zv8Dwz2MY1BhaLUuvmDrhN3KJ6gqx1hHXeGX5bJOHfpnAO?=
 =?us-ascii?Q?etPmX4rhj+H6+yEmeetMWpVQXq9A9R6HOpE3RVusa7iE35BP56Fyn9/ubZMs?=
 =?us-ascii?Q?X8+KdrptHS0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f/GFk2BDyg+/8E4kxUryJzNApYfFQ6yJjbuhrcACYmGSnw4XlqHxtCz3x2cw?=
 =?us-ascii?Q?sL/k1RF7QlFgIenQDkpubOEGFfhWRk6pMX2JzHIOwXfX9UqWwie8ATdNdgg9?=
 =?us-ascii?Q?uZ6s8yy5KXDSFKQm4oBi/3HYvCSuy0g9EYeBH+TAhPccXOgEM8GnscXMsYng?=
 =?us-ascii?Q?nOIH2/iaxhdFCTvTpGei/KWNrSRI3knbsvpSI7C78ocz418dhJpVTlNPRq6H?=
 =?us-ascii?Q?DpdQv4tlXfk5r9N5uPUWBQWEfHdukac8NATks43htfo4AH4Ox3y1jq+tvTp4?=
 =?us-ascii?Q?Jf2fuvwyLelrjVZK4L7BsAL3Yl2rSdoWmN7H7x1MAYTU/IVfdIJW5q9uSOym?=
 =?us-ascii?Q?t1naLyRuFkntgMLy9C+FjHDeZbCHf4rVtH66ccK2KcWXlrxIliCiEICJREoH?=
 =?us-ascii?Q?VUjyV/NABp2cg1ISZ3XdcnvgrIRxuzRKMezI9hxE1FpgmUC2Plb5qqtgo1QS?=
 =?us-ascii?Q?IbN8qEVTr58V5PlZHUOchzUgMAd9lHY1KemvODyriudAsV1RhTD5nsRi3Fe0?=
 =?us-ascii?Q?7VxSgNKDbeONFmtdbAXwgu4PPzTiar+H0E9wUxO/Hk3s8pDCkun4SyaAC/1p?=
 =?us-ascii?Q?7+0mZ/TRFJ29rSaxpNDh3J/W7SylpzZGxlHMgpIbm2tYJADq80m3JBamJpsr?=
 =?us-ascii?Q?7NNWeQ57bw15J45CmwYtE5MJk/Xy17iAqM7myGIWvwQcHlk/14+XHvGiasWm?=
 =?us-ascii?Q?ApUDHVKU+QlJRVZpxBTVssvKkpSA/D8CffiFFdXaqhNaOyVPxXT2JGej8/+E?=
 =?us-ascii?Q?/HvjTKaCbmnjqWdckbRf2GFo8Dev30wzfDOaDHiNUqW1FqTAdouM/HkpTcO0?=
 =?us-ascii?Q?gxrpS1FeBWkY1IbUWAeliCnYJnz5yP0vYhmjb/3Yc7H+Q5feMEBtKuv+Zu8L?=
 =?us-ascii?Q?Pz/p2W+u/kxSxI0K3hWbv1YRcqUuNTaoCZJU2JPjmq79U5dOZ+iBRPpLnA+U?=
 =?us-ascii?Q?R6LpuVm1/Yx7BcJw8iPAbyNXzVGWXXxiqGBu75lzKuZ/mLzBqo/eMshX/9o4?=
 =?us-ascii?Q?EJIIxTEvx6GBPWpOVoIE1vaYnDMAsNzvM/zxB3uTqL9Uvjo9Dl0u5YVDmf5X?=
 =?us-ascii?Q?wp+fIXeNVk27Kbfti6+8+KQ4tZ7+EKiCP2yNUUOTW1VTJhKlZ5mbgv1FYuS4?=
 =?us-ascii?Q?Mh7J4ik7FZJTYexKHcPCVW+sWIgHA2D83k2u2fQxKY6cuVRb9RXIMPkUp3OI?=
 =?us-ascii?Q?QCRlvNCSLuxQPIQwSvH/EBf7l2jzLVqY2KXS2gkICP2ftKcb7DRAT8TJWbmk?=
 =?us-ascii?Q?qDF0m5+uX8DahD1r9fV2JvYhr6WwXdy6ftFlzfJTabFvqjJXeJz//Eb0ipJL?=
 =?us-ascii?Q?D4F+lVkq5EmV6s9u5/UODNVCROnFbNsvf7IO5qvs3rfwyZsCGHEnsEf+EdDd?=
 =?us-ascii?Q?ZXkJqeaIB9c1ZNGXiGrUE5Wik1TPx67nhbLAxujUxKBdkO9pil4Derwk/tap?=
 =?us-ascii?Q?veyDX4PR0b0l5kJrSBvf7MSvhib2RP7SI2FQ5SKwUEo6fBknoTcoByP8BaNj?=
 =?us-ascii?Q?jkNHjf/ggRFshu+tuC3Rqeefd+FBY3qfGx+TRnE9IgzpzU0XCE9WBtrfZNB7?=
 =?us-ascii?Q?0CZ36sEemZL9SyZEf36+FLygU84vIAMU8yuXCKvI28ayxfNHDFQDUtAQKS6t?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z1fgaAv2Z/hnpPwDHfmkSjJyx2lzCDGsCD8wYUXNg6aKh25jpkMzdNEMgd8npgv5s11uP6TntIttVAYFeCgDFbLDq7CXynmPEb+M/6TxMgI1ki9aYoGYcwS7KJ4k1vk5AzLCj1T0mNTY03NcofqKi5U3KKzmf483Uul3GHlC+OBvCRHIT50MC314rMYp+V/G4mcgC0zkC7wJ5ET4Ify0z4Vrf4pbGIQhNpccug0o655srYsiebVypcqwWGBNrmblH/FADz+0T5Nt2HQ7zQyv6zv9XI21NdqMWUgHa4hqc2s7si8O2MUpKihLqMxwyy5IiUlNkT770rseT6++vFudVay664pDP/i0RJfP86SsxZDui2A/t5Yk1fHd09beOU0T2nsi2eD2GgubDHqmp0rjP25uNoQ0ato4D9KoiU13dkd4zkvgLdrgEzbRa9szK0ayZ9afSKBWkx+6frRUJLmMmKf93HZBAwfU20X6+FjIrtiSoRe5FlDbpA1Y5DmNEpXQdrmJYC4EbNZdnNRfGZbLc4qP3uArLFWZ+wkLlcgX2evVlStGUgyreJ/UsMEMPAdvXJyAXPOoHt8kBLIHSTYAEemz0x1QK2N0morYdFeH7E4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe9cabc-4814-48c0-99ad-08dda7c26998
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:59:19.5471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiANjlBy6tEwCRr0+ZjOmAagxqw3YJu5Eu/Y/6le6bo77N5CfqTBVJsKihF9jTXvORzY0vILg2U3sVQsadE8TEQsNHEFLakfeRSuaTspY28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=930
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100014
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=6847917a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=dwjUrGB9IrXjjL-PHH0A:9 cc=ntf awl=host:13207
X-Proofpoint-GUID: hos7zAPRBH-1Z7BRi-lkGB4tUrAMFeOW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxNCBTYWx0ZWRfX/71/v9Gamabj dFF2xwKKihpquCFLM39oVvCyU+wspzxSorUwtuaO2kuVUNEmH3ldW7P9kIVqQZAPlUh5yYyJAdu +Gg4ZrQx4TrFwfhlUW8GEn2LHb0gQFGZ3pERqsr8uIxe2SQ49tSOvoII+YQAvXCHdxds/YO9Exd
 xJrCtsgmykKSHDcOgzjPthuK8jL6K4A4DgCGcWPnNxfEE3TWnxjZ9DG3F1DDtaQ9+kB5oh3Zoa+ eBnG0q2cimnqHaX+HzE1NqwKcexew7dydI0bPgKpOLMaBdGeqGwzhRIQ4LhuNa9qKfz8Ud6N0X2 tyEYd2tO4p53/7iRPpaP8AqPl50kMr5Pu1QFj27fhmhw0kM7yJkxYqhX8ytzu+YnWgw7oGlyQf7
 8vmdSKEWeaHrisfMYzRzbYZGPfmSkq6PLrBBNFhmudy7UPnvLVHstIwF0pGSHXwsj5GEBxI/
X-Proofpoint-ORIG-GUID: hos7zAPRBH-1Z7BRi-lkGB4tUrAMFeOW


Kassey,

> By default it showed rtn in decimal:
>
> kworker/3:1H-183 [003] .... 51.035474: scsi_dispatch_cmd_error:
> host_no=0 channel=0 id=0 lun=4 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT
> _NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
