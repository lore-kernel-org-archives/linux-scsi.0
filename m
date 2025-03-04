Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E81215E5D4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741054626; cv=fail; b=YHdus7csNdoCyQbG6dshQOsm7gHjU4R5SfzX5lOQOmIEyEsP7WZsSQZb3cc42bPq3L+Gu2m1v5EjWQGKzx1kGG0yCLZ2TsZsiTWg46OIKonVHkztZ/AUeJyywt6K9XTxBRzbHw+GYO5lEoPxglNcf23iP/72EFOV41YvFytbMpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741054626; c=relaxed/simple;
	bh=4bk8NmYvmZRJJ/9KdKkZGvkaa7ZmDAHtDC47AnnZpkk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tsaAuIHNJyJSoyTmC0U7u9bIXim9GtsA47nu+uQSmqqZvKvErJ2YJ9rjK+omv3l0li5unRvbzMPWbCxSU+GJp5Qcci3yh4AxtFATQk5UjX7jO2Z8BcP2KRVQ/4D6F6dB+eYl4itP5XRzWLEOxI72QIggNzX4xNk2tKbHmpaWsMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q3RFjsdu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f/q/w87L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3RFjsdu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f/q/w87L"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mexn019182;
	Tue, 4 Mar 2025 02:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=DlRd9mzAKMJC+X4qJW
	ggKcX1fgoi3qtNmfgtqeT0qrk=; b=Q3RFjsdu98f2eO7QcX7TRSZBuAtTu6PblT
	OU/R44XiNXAMrLPXwwVdtYizgEmQnrALTSgB7sczXX7oKUksT6z1zYm4gbgKkjaC
	30zOSeIvbAyX8e6V3ZBsR9Iz4/aliVfys1/HjHK5BoRQ/wGu1Din8EYpkiHs3SL1
	HGtWmOwyZ9AZmvogtVTswQITbLoPms3op9cR7uMk8NVmGwVya67nJ9r9tCGzFgGI
	yQxOt25RkXh8zrZDRWMsltlnfWxzZ74sEoMThHmP1BjFPHiEcL+zQSip6g6RgDIS
	McEIRo7aoLWkSi16cZ66/TDS1dEeBsEM1T3eNUM6CARWUEbCCe7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453uavv0n4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:17:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240eElQ011453;
	Tue, 4 Mar 2025 02:17:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9ubrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:17:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvQbuZZXFgEdgOIzpyaSkMjCeJreGV9MJX24QVUpAswdRKQ5upDG7EA/JMetCzSYxc2qrI0F8jGFU7jRm6w2aYo0QCmxLyG6pJz/0NYGf6/doEeWirBM857Ev4b7EVyEU+jL/Ob8eEL5tYWOMw/McNxVnU0U7g3lFyl55ZA3TUdKA0n5cn9ayqg1yMqvpemSxK4XmPslUKDwOTWpjNmpGZY3+XAnZyKtxEh+Gm+rGvftbkkrpW/SL2Q6GHmsfwAkJ2cljADzyL84B5EOe9bqBGFN8VgMmLpXLwTsXpgRd1H2/T4eKuZOYAn+9fo1cM76DGt0Z1fDcHFGFsGrxrkSAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlRd9mzAKMJC+X4qJWggKcX1fgoi3qtNmfgtqeT0qrk=;
 b=LtlGmInk2GE7fWH6CX+AZyZbqJiv1qY+Qvd41msoz2/f1SVvOL26E4rCpjAXKYzT2T4HTIiH1yuRMTFe1PHZUYrBbf4melRPh8DS6V9Ar6B+T4oQ/njeYq1x8qid0jgQaAb/xw1KL7IIuZu7XOVjbZ+znEob7jYfxXg0EFIS1WiBF4Yxlc+0UOuuhStmKGoYThbL+0rlm67jjLmDe8E6R7HiLSVZ5jl0mRSde9UGBbRhHvgb1KWNTQMK23N5Ng2jmuT/C6GpGIT2vaEXVStAVQgGLbYgWyyZygb9pfft3SpSIKgVxofVoOJhq+AagqIGnsU04MvgeejZpE31JpqG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlRd9mzAKMJC+X4qJWggKcX1fgoi3qtNmfgtqeT0qrk=;
 b=f/q/w87LhoMfrn5cWu6Xe2mfvRz2rAHXwTClF6krWuF6Km05tpDx9kzXo/8DSVG0gMZfGM4vcOua5gVQDmxzJkVTQF+a6x0bpM46s05TjuU+eCMG4pziGThLLL+KNlCUaLiWZuOn3IVjECbvyrIU35e+yNsdHDSOX4dL/qYATjY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4964.namprd10.prod.outlook.com (2603:10b6:208:30c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 02:16:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:16:58 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_error: Add comments to scsi_check_sense()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250228031751.12083-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 28 Feb 2025 12:17:51 +0900")
Organization: Oracle Corporation
Message-ID: <yq18qplv8tp.fsf@ca-mkp.ca.oracle.com>
References: <20250228031751.12083-1-dlemoal@kernel.org>
Date: Mon, 03 Mar 2025 21:16:57 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: 91800ac7-a25b-42ec-9cae-08dd5ac2a49a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FqxTc7uUEay23YCWs+Lpx8kpWyriXchdCZIBeXZsc0i6Z9GoztRpYiYTkJEd?=
 =?us-ascii?Q?7z7klv2MXo5toDQWsupzalD+ifb0SaiHh71BHf8vhkmyX8XE/cAmoBRXAx1T?=
 =?us-ascii?Q?RWMAsxM45ywasUpAiEZCTjuwvURxJ9Z1EN+fQnNscZD22nsUiigJoJs4aL3n?=
 =?us-ascii?Q?AjHYJ+lQKxT4m/cV2RAHjzePIUhREt+RBxruqNJkgwLTCKP8N7pz2LiDq/5d?=
 =?us-ascii?Q?Ggx0TzmvO/BiQfpB4p+5lZOnP82ktrP37LF6WHwP7oASybrgPiom4r3Aq25l?=
 =?us-ascii?Q?mWltq40kbykDUwwCASoEN1BQ9/oihfvW/lNaUtHIeqHT+i5Q4v9hFGCFeUO6?=
 =?us-ascii?Q?LZw13bNBL7Lj3VaU5VDZS++cdOKdsjALGbm2rHnh64pSTO08IapAsThEEFPG?=
 =?us-ascii?Q?wDltAKZLp7PidGrsdpN3C5FtOTuq8U+KWuCY27Vp5l/+tCUjUyk//sbNpmZR?=
 =?us-ascii?Q?FqGrxo8frtuXkJgcVd9eu1MKovSfgUVfg7JJr82Rfyv0NerUIhFZGKTKs5wN?=
 =?us-ascii?Q?mcNzS28lMu53NSXRKaLxNpgHtv2CnY89ZFU2Ig7X3uap7QFdS0zxBNOPc7/9?=
 =?us-ascii?Q?mggVYTaQSSPniVRd1VRRW3oVpw4MPJtc6kN9a9Vy+1IBsOgUD+ihgnjrlkcN?=
 =?us-ascii?Q?kwqiSm/o1fkHAbdIv5NkBxva8bXUOWMuCYDBHmC50JjJ7utFs7mr8Q8g5VA4?=
 =?us-ascii?Q?8xScrkMcg+CmlohB5O8ZQZ/c8KU+3amN0b1gAk7ff9JTETZGsUfUhDTaR2gj?=
 =?us-ascii?Q?gMDEuY7RF8Ka7rIAxQk+F6QcgCzWdXYtPajb1CcXGQfLARbakbuMqQ2CCrf5?=
 =?us-ascii?Q?GNgNoYqMBN8ssmbQ761azv8i8aD1O4n6Fr3ta06OpwpSt4QyNMr3vOLb/G7h?=
 =?us-ascii?Q?ec77nFsC+Z2x1HOp6UYkX7V4RFjWE8Hg3NatuuPvJQ0tKL0FmGBr3lSGlDF9?=
 =?us-ascii?Q?7BxV3ywE7+cmk+imBR4dgu/NK4eqem9Uyj6UcuoosBNsEx1cl2/xhDsoRESv?=
 =?us-ascii?Q?lCd6SHz4u6VR4Ee6uNEp/+ywy6SHWAH4q8yiWhUx0n7znq0exN/0deFCxHeg?=
 =?us-ascii?Q?PtytbxeKVe9bf2KqIfvNf4J854k9IvPaBsydtna+XmZAPeAIyEsyevom5vbI?=
 =?us-ascii?Q?29v/JGi43n6MJgjeo1rPvspc3bqeWFO/r1g4VDGcPw8ZaHYpd3gpxRrbH2Pc?=
 =?us-ascii?Q?5S+rcJqDDTpAE3QuPEkcM9TOea8jUNGR4BSvku6Rl/l+b1wfbzSWOv9RhGX2?=
 =?us-ascii?Q?MxX3kxR21gT8FIpHGgqoCf+Kh5ySI1usJ0JcyKSA6Rhy/Us5tcz1mnUsctuQ?=
 =?us-ascii?Q?kcjv584FEmt1Sc++PDtKAO4N2m+zF5eRnLdI+gs4wQ4i5G0YTdH8B+uUMFCS?=
 =?us-ascii?Q?tA5X2bmCPLf5MYXFuN0Llr1sLzv1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M8LDrT1R1C/8WYiJ60BRKIa839KgQ/mD5kNdpylTcJZVTT4bgq4O/YduU/OU?=
 =?us-ascii?Q?m/O9tdgrI00ICUHJeCQ5CHM776zn1sMdvR06Ov2XUL48vrTpvPUjhOlwntaf?=
 =?us-ascii?Q?DT4WUcdiDtUGNaJIF8cRa7LhrykR7aAhbwictevGutZTyb3tqUv6Va3nhpDM?=
 =?us-ascii?Q?bW7J+FmAp97+ayla5KpQiNWLc8dth7qE4EvWWM90aABIbON7rPyjbb45OkeE?=
 =?us-ascii?Q?AbpJHkMc7s2CGkh20e29m+0Hb5VeVyRtfo3BDROi1Tp+Iyrv4pC9FFq9qPlN?=
 =?us-ascii?Q?TQzSWAv6rBG950hALNo4t8WoHHloykCFGUoA/TlI8HzNDa2WfJ1giHCt+Nwu?=
 =?us-ascii?Q?mJUNaK2zFK3rTWdvdBz/d+kLoZTbPHma57zXcznvpfyJIMorO5ax3hoqUuR1?=
 =?us-ascii?Q?xcZJLqw827MsBQSf6PfIigu+KhYRC28gmP3t8PuvorCtVy8JOzpnHpLipeUv?=
 =?us-ascii?Q?4L3reC8KAqXoqrkCSujkmQxdGCmdADD+lyOd3ofG/Jmeeyol+0XErJSIWmnT?=
 =?us-ascii?Q?EtyNukm15LHphiVp8RbxOrMk5T3BWkuJpdRCCLiZ5ZXcazH1EccMfMOR8WqY?=
 =?us-ascii?Q?BP1h6WfogOk6jidjekw1CePIONjE39DhJ3Mj1258YgzyXUAVk1zgfhc6XPL7?=
 =?us-ascii?Q?g4Y3TeoTXbuefkp7LWKt8ofKcRZhP0jk0/fGAzdVuLaqJnUm7LMI5+xqciFV?=
 =?us-ascii?Q?MxHGQW/vT+fD27lV1S2qvrQcDnc7AxzXDAodOSEkLQXeAZEO74ShXYWiSWBH?=
 =?us-ascii?Q?3PoVaI1tZthvpiGn599+2DB7Odc2Pfqlg3V6MmWQMpsAo2hkFrFwBTmOFCKY?=
 =?us-ascii?Q?soc5I6Sd+DfQR7aq8kiRyKKuqngBo1EJOOVKkDDxAq2gIMc8nJCIvqUwKpTq?=
 =?us-ascii?Q?OujV/HDP4b7yUF4pVgoCSYV4gCzYXoeroV/w47btpPIv6iEu1KK7TfOhWUtO?=
 =?us-ascii?Q?0nE5xmJ9IKsXarLxVDhoj/E3SXwEYNYBsWLfER33E+tQJrNsMCTprAzGjrfs?=
 =?us-ascii?Q?oqDJImf0h8uV/kGUYdhUHJPrjN6YRj+7YD1ZDkXjU9IsvDSIWv/ta/+KjbgG?=
 =?us-ascii?Q?tbv/WyxLVFDbKvKuUOBebaQTI550Fj9aWivcAUedRDKOhRw8b/FkmXLjTems?=
 =?us-ascii?Q?5ZHqHa8PQ34NcZ+nVZEU5WXclTDQE0REXYbrv/5d5v0uLFDH+IQUyG3hHAdO?=
 =?us-ascii?Q?ixkN8lc4sdbFfR3rUfXKAbomFe8IELd6WuYnMsAjEyKWe7/jjtZY3ngeKkFB?=
 =?us-ascii?Q?+xu9KMmQwV71rfO/a9yd93m7wbCsDaocUz8CgnxNylBDwNxU965JYgajlKKM?=
 =?us-ascii?Q?tWYeCwJbJl9N1rdUb/7dg5K4K+JdMv3oQADkmkQYkkTl1tGhxqaGpoZH+SPC?=
 =?us-ascii?Q?nbC56LdIQJiPurTG1HxTdDMXiWT4r76dE6oXEYYdF2uQeoFwu4l/LC0Pa/fv?=
 =?us-ascii?Q?Z7citchrWz9BhcyIGgK/pU7YbALecYqBvcovxdQac917/z7Oh00ZbCkCBsUx?=
 =?us-ascii?Q?Hu9Hf2EWeEQ+NLZxbkcd39K1ccHigwX91q9K4MJm2uC3sh3+Mzchk8SZVWkC?=
 =?us-ascii?Q?dvG1tI7/ynGQU833EyF4a5BDIJ5ybBK5VKnksmMbR1cppjiQxmkyBoWn2m9L?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XV5f+UZEoyYjr8RpsHyz3D7sxTBgDSqQcaJ+jbNiMr8wYrBTCysXRyLm6YoleO9ql6ot5ffgNacO+tB+qo0hJM7NY9sP4l0f/RVME2sY2EB9sse/EbzxLX33SJ7SawdafjHicfoZkfYI0F6Q6Byf5BNeT3gWNVrm8D5Wxyh7k60YvYjaudNRfVF7lmXQUPGg8GjXMXtOCXC/KHI8grm0RZH2+YLidSX6I4OBuWEVjKCXuZFZas3bU8LewxAJjZEnqSeE15zT0h3u1H2rcQXxFKe5xE7RJ0X6TAoifIvcwKG5Hhuyj7fNUGbH6zeiShf3i2ET6HkUFwki7NyisiV83WpCYycvUb9DzmQi75czW2UwPstna8Vi0HzYLD2SH7bQ3uy+FAfRoSsDp2AnyrH0sXWik0UujBKSE8V9qTp0Q3nBVMRfph3SqKnWxAcSH3AbvAFc9CjfnrsleHVL8Z2YqTXdfbA8Mj7OheivPirX1hK2wsC4BGxsjCMv5FuOpmoc6/wQi6LpVILhO/rR4Poalm+8hw5qo7IImrDBoDfKpUoO3819ddmjz/wfoWxcfaPXaFIGY8gIR+HHa25eGhUHIbOi+kR+XT+UUGU5Z8Fp/ac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91800ac7-a25b-42ec-9cae-08dd5ac2a49a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:16:58.9196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDmT+PSsy4c8YIj9tXB7fHUd5LWlU1UA40apBydPT5yeUY/9U9z6fkDT5yYYREK5PRg9hahxC+eYfhzhuRZpucVAtJdynFKWixYTEdtngpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4964
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=868 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040018
X-Proofpoint-GUID: UA-J9fYqbjhgpFIe786tZT_ztSngnt1Q
X-Proofpoint-ORIG-GUID: UA-J9fYqbjhgpFIe786tZT_ztSngnt1Q


Damien,

> Add a comment block describing the COMPLETED case with asc/ascq
> 0x55/0xa to mention that it relates to command duration limits very
> special policy 0xD command completion.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
