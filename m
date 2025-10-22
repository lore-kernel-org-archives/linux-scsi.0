Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3D1DE3C7
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 01:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761095849; cv=fail; b=X2RtEEDSPFCBnkYzc+uDVYWKTYarHjMf2FNdU3P/CA1sqFiW0TzQ4RSjyzpv5CcFFSd/jVeIwXe3bPI+45K1W85IcHccyPyRX3yaPAdkZf7PCvcNrEYkMxMD5ZBsstIjkRCRtzQwmrxzh63CbkEmeT2xodo095WJi4X98aNOgnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761095849; c=relaxed/simple;
	bh=sf1hGXJG/kzI1l84BFjBgzUhKa42T2AwY23k5C04qN0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SBDcSD6E0rVHa+pKZ8q68XjyfvAmo3XrvtCoFVzEwiA8GolU+AO+hMWqP2fs+mSetyBpLi/+vtX4Sm22q6FK/mpWbiYlf/RlZERWi6wTikH29Mp6q8AqrbdthJiWoVczrsW0RWNT2fDHMS+gl6hr64j+Uz5mb0dHTRT0EQKJZAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sFWhyv/F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QhLAtw7I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sFWhyv/F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QhLAtw7I"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMu9IO008000;
	Wed, 22 Oct 2025 01:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Pdn2xwwKuHJPB3vyeb
	PZppDmcjRA/mZ5LBilA7Mclg8=; b=sFWhyv/FBhRG9LHJDNZPGMQWKR3JP2wRN6
	eF8Y270mK/l4s1L4+x8hwrkUgI1hJDxlV+tdAmepUxEbKluFAllxHJ1uO43JxLLt
	/IMk9j8+x3xp0IudXBOQGVmU64gPKWvtPhZmYeQ++LMlndph8TFoLhBxMVjO5C+f
	cD+kQfdy82zxFMzUIupq3UEKaoGC1ykbLnbQk+MKm8qDW2fViOFUUqrx2rPbDE9J
	5oUcvsYKYS3vcBMxumgz1tWgBlQQkIy2ZpMDH0B289GLO/LCI0RPqsCbbHMHoVj9
	yLb5E1AwixVhj8DTLw593srIjQpIEMiJVlBYio467E26zwbq4V5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d6ush-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:17:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M093rJ008674;
	Wed, 22 Oct 2025 01:17:15 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcrtum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:17:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffZ89OzC17SRiQgMOdq3+KEhpbebTxWdc+bd9LTlStDMv0XDM18DU4bD2spFD0gaRnvVM8kcnUApc2QooemUS2VzXRg5I5Zto+wzalVSc+AbYsODHmJPwN2LOp5Ao24Hc6YNANUOs8P5TCa0U9YzAx/2rTSUf18/k3OHoJ+UxjPj2FWgbICBvp1/g31LdhVosFb2o6Q8q7Rj1iJPjyvkB+HDKdEYG6hhpciW+/s5ERFMafs9A4N4oavXWnPUZQEWHsbGH1DWgHuL74CFKYE0qsYuFE+EvdO++khMAgVLz3u5kN+FNKgL23Wxt/+rzhrjtgUiV1gjGlRosRhjqQfvuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pdn2xwwKuHJPB3vyebPZppDmcjRA/mZ5LBilA7Mclg8=;
 b=EeOKnJacDUzdNEAwy4b9I8aSjIDB/UAiAENXD0O3akqOkdLdZ7eErOdxs802b0egm8vAvr99SufBWfs7IPhxdA2J2X7VoT95ss4wVm80H3vNeTslCZSVBvIgIbNycGrZVaU/BFwq3rxhzILnIzruNFaS7KRiS5t1iReLu0BdwykcEUs0T2Rc6jVsihO5wdl5P+1fasOvvPOlTgg+5cleTmtVZYKRB8wtao2L6/MccwGIboHFQaUiOxIfzbQ9M+NAmBJT7SlAjBlGWioFRo45y0NqyOyO2eL9Kec+6Zd1lamAYist/avU41Wz74+vr8CZvXg6rCsgXV8gsNP7PwVP6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pdn2xwwKuHJPB3vyebPZppDmcjRA/mZ5LBilA7Mclg8=;
 b=QhLAtw7IuqBGFsAJBW+RdMJlKqcsumdZt1EfEz+ROsoSrKG8u2XC4FViy3/UJgiX4pScXRW3oJ77t8ryzEcUkH5FzdWTdLTCYYbvkHmr6tMsA5PJYZw7/SyTjntWhwdO7Vuu2hqOnWm/INHimWGmGOHSNhOLN+JEbJbpy1nwcEA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF00080FB4B.namprd10.prod.outlook.com (2603:10b6:f:fc00::c04) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 01:17:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 01:17:12 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2 0/2] update CQ entry and dump CQE in MCQ mode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251016023507.1000664-1-peter.wang@mediatek.com> (peter wang's
	message of "Thu, 16 Oct 2025 10:32:30 +0800")
Organization: Oracle Corporation
Message-ID: <yq1a51j68hp.fsf@ca-mkp.ca.oracle.com>
References: <20251016023507.1000664-1-peter.wang@mediatek.com>
Date: Tue, 21 Oct 2025 21:17:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::38) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF00080FB4B:EE_
X-MS-Office365-Filtering-Correlation-Id: f46b0141-32ec-4b20-7f75-08de1108ba9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?znfbpbK+oCCFiy+jtuKeSvlVI5plwsrDRc8sQF93AqfEk0K+lcWzzuH+QZvF?=
 =?us-ascii?Q?Cic8anjWOS794RE5tzocpF7R9mL30WkbU03n+fZ3yVZYMrJCguZOKuouVyYy?=
 =?us-ascii?Q?O6NKOVPVBQn66zVFhxsJO5L5sLPDqOubLBAew4TXUGBMrwWpDAxJjJ5kHc8l?=
 =?us-ascii?Q?9fO/NUjcGFvwrgUaNAjuSXLuHS7fCsCqQMim7VkjBgiCaHeNh8YZ5CeVKin3?=
 =?us-ascii?Q?Mz8/Ansh461rk5cvaOnlpdW59FomQOCQnOTPSNxGWONAhFYfj5KBJKla80ue?=
 =?us-ascii?Q?quo3jmD52drySSWd2vUMZsa3tX64ic2/DuJdpoRA+PIg0Xz0kwJHAhKZfKkX?=
 =?us-ascii?Q?J5SFA7hsibbor1MK/T/JEb8xSx/6CMSgh/YYVTyD6Ky35amDsSUQpBsC2u5W?=
 =?us-ascii?Q?f0UMm79fRVdYR61ZU7nMztEL+ktmwBSxKRVOm2LjyeGOTZhi+z22FwmBnlHM?=
 =?us-ascii?Q?R2hUDLZokj0Ur/95JKVnqOlUVX2fDWLRWdY21/SSiixU11ZA5TU46aUyJvos?=
 =?us-ascii?Q?+paSgDGP93CSH49JPfYDLFZq5mcnl4B5HwpSriYPzPWj5TqTc4B6ChJu9ZGS?=
 =?us-ascii?Q?kRUItlhj+fsn6gYijxEFyyQNYQdFB8PYZLxfSpk0P/hVTyYqsNI+i/+kN5ob?=
 =?us-ascii?Q?j2sXS1cS4DkcGvfZp168FXIomqVoR+bNvtEyXC/uRNWmbi7ZMpTbhOJvKgid?=
 =?us-ascii?Q?sNrQgh69XcOc3or1oXKsj6zaSsz1kuZOhdhBDxhYzgeRxBZ8EW6LN+dQUFjN?=
 =?us-ascii?Q?nVOLT5vt8e/26iDgkZ8DDnUvWEpUZW19EcyBjuTAyY3jlk0C9+7UeF9BhEnc?=
 =?us-ascii?Q?i/ZaA2HAt7BwhbTOYNn2E6VOT5EqFCQ1OlQln2N28r1mesUgYjFXjMSEL/S1?=
 =?us-ascii?Q?atYPw108AOyu3Bx6W4NO1SvDhtK1qVQegurrJxA/3VQYLhzQa5wOsh+nqnhV?=
 =?us-ascii?Q?pfxsROQkQkG1vCWmUb8e6sriJIgPxyTuivbgVZvZIFdiqGeqiM/sOXYo1ekm?=
 =?us-ascii?Q?GZX+Ee26CW/e+y0H1I4GE/cO3ihMFCPCfJ9v/WvUNAZ5rTcBNElUVDeFOIt2?=
 =?us-ascii?Q?C21ltFe5EGnyEMwYxlDgfO/1sPBusuwTnpKe1dLtFw36oUqQcFLg6dIo4FIo?=
 =?us-ascii?Q?+FfjB10WkHIDcat6CtyOd57Riac3R9lr1GpJ8ciiLCIxZzLSfZGfKvnh91sF?=
 =?us-ascii?Q?5pRKhd+g+utRDCYaa22Ko505m/Mqu4+ZCg61Wmfn+gOddMn34vKNhz1AdWQo?=
 =?us-ascii?Q?yqVyLC4y+rylnHahAUVhhR4Fzbca4CUNf5lSeq2YP9Rkc7KbSYwB7cwzA1Ma?=
 =?us-ascii?Q?Ius8O+DjUdMiNmoMbB/CljplsnMLIxlUdLJ4G/K1KLF4deVwVuVHhcSQRi28?=
 =?us-ascii?Q?WonYvkGnS29yQjLmShDa1AOq1RxCsla13N7lZHHV+qkTJ8Eft4bodmU5ga/h?=
 =?us-ascii?Q?SJjYX+QSIN+SemJAFRG/ETkDiWlo9AS+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LCnpHozReojzy2/skBXWbchjOr+fDOiaDo5ILwQjEMlStas64v1bGsQnInaT?=
 =?us-ascii?Q?zAvNXRjI4baaZNrkXD8DBNrjt+W3aLBLWcF+RHUbN5r6fgKlHhzcu+2ubkb1?=
 =?us-ascii?Q?OYgFbGHdWg9xODF7wLXXaQcF4FpAsJ7qVTMgvKzbBU+zsdThzM89IPWfe+8u?=
 =?us-ascii?Q?vAEJ6Vv331n1JM6mNnIDNBQxumOTHCWi0GmSDvF8glcM9FRqex6E5lSqjrnP?=
 =?us-ascii?Q?UK7Jd1WwM+nPYM70gq81vqFo5rnzER4lQx3l6fLb0JAAq9TTx6jcJ/wDnc9e?=
 =?us-ascii?Q?g9cp1KmmNDlUfY4g2BC6bD3YnmYjMC0f7zYj2gl06xRrIernJYpaZyC5ikaK?=
 =?us-ascii?Q?hr0loBsXzhsSWWYNSE5YL9vYzU85h1yfC37sVjI157hcYSvTFYvp6T7sAKkh?=
 =?us-ascii?Q?msz8aZNM17O5CXPIvXUDrq1F1vHgN2ILnwzpvdtIc37FNvmqOYj5sQtaWPX/?=
 =?us-ascii?Q?7WNP452gG9A40Fgv3cYuwWbomKdDYqNXSncpx2c2y9Pm4HNi3n+y6NEgC5fm?=
 =?us-ascii?Q?YtSqno0vJlVnEwnIax07yqaQK4Cfs3z6fTXkXGIBofbmn3++3w4r6s8Aemdf?=
 =?us-ascii?Q?woPndBvNv5U77zwtpu1+iLXaDge5EutQRdsk8PX1J6JZ5rVp0G5wIChhJ8t1?=
 =?us-ascii?Q?yumXvcfRhcjjeSBKbB/KUtERMTj1KOjiGcnrzHiWEGCulpNTaHrCQkCUKqZ2?=
 =?us-ascii?Q?YDqgyzIX0n5+x8LjPiBsuCC1SixgXeft/8WzbtuGWoWJJ4+FTaKsz3pmFSxD?=
 =?us-ascii?Q?ttuS7oOezK+/RZd1ltWEzn8wfeN2uRLvbsl13aM97cXejP19K27yW10TZq5o?=
 =?us-ascii?Q?HFPxeuxgNpvG9moubRihCkeHEyF/LdnjcYH/CHxuydTq2CT7GziiO8impL3Q?=
 =?us-ascii?Q?M+MUHKl4ic3RvqcmzI0W83ZCe94KuL8fBENYwKOlHHenvgJEV1VWAAUm0GIB?=
 =?us-ascii?Q?6C/wnkKCwmvq2cYYlevhnm/+ecqrkzIM0YaxcpdutmwMOvTd6dMnSRXR+16k?=
 =?us-ascii?Q?/GZmuQL5/IbgBagaI3ikV3+tWO7cSNjVV8WUnsSha/dYS+GjaD6Pibr1ZjtF?=
 =?us-ascii?Q?Oo1MPzs3JEvmkDtu+MKPvIirq3Vr4ha6bedm20EgCqnFf9EKGGnhD0DaS+Tx?=
 =?us-ascii?Q?UEl5FehaFnxFZcUg/s03RtiDG60Zm4Z9tO2UK62u497W4WSWapS8Q0lxI+mO?=
 =?us-ascii?Q?hmaZ0DW53Yg8Co8KIKR95e8mkjXvv3yuFdjByV4Gp4dyqnsihniFWvuMEKPA?=
 =?us-ascii?Q?jfR1ecspL4Fk50oFciE9zZhUj3dwmxPOb0N4u1cyYugRNYW3o4jfCgxgTszr?=
 =?us-ascii?Q?flxrSDqQRHTNuy0Vtt7qyU3zsSokX8Q9OhJzNDZkjkr8IaNKsATG2FNzlDr/?=
 =?us-ascii?Q?t8IPLf5EB4krktT6o4OGwr2qoM/SwJwAiaHyc9mc7T94wDTk91VuIRosK+ZK?=
 =?us-ascii?Q?gg9yxL4qsWBfEFOm4Gg1fmg+O+PjUAGHGs5aI4ohxInHN9l8iEDFUiVB579q?=
 =?us-ascii?Q?Z1KReYNj5V2427NcEZ9x75GXxpW+bLu4xe/ufj9fkIA0ZvQaHiIAEAgh7XnO?=
 =?us-ascii?Q?F3X93g5YcYF/eFYqx/awUHifMBGlsy7WhcpTjD7ZsVxwZtj8N1YKNh0fdeYN?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oQZrsBy4xX1+Dh2IlAvisTYS1PtOPMfMqKcWyEa4bcSJ+Hcy7lOphP1BdQcrmU0AaODyXYmEvKzZo1r/OHO+oqmf+QOJMKcmIgcCTRDxpaULh8bGsDXZQ0FMRTAjPCvLd190tZ2tfySWgJjOf7XA+qsytqoFUXVVcaqh6cFy3Flw7B3GGfcM3a3tToB1xV3iK+P5A5JpoiySxPxTYEl/4X5ZX+EbyJcOwT4+BZ1yuHJAaG8TrcrD7jSmNw4hy1E9HxqdeW0PS8fhYh0jmCIXQBQDQowpzSyxLW4gI4LXGjs9+tS1Nz6B8UMuRawYruBtUX4cvF/n4vQjq2Fd6zGJkZNsn/jvUNZrSssS8EIxeLafxcXDluPMPUGAQJ37TbxaOrs7Tq33D3QX2xTcLRa1IkaYuLVICX727t+mXd+OsP7YCROKdTRVjvYH54UAzqm/fBmCfdLJ2azmvkzlxKWCXt2KmZYyEvdxvU9ub97AOglErWaKcSUeKSO+2UtVH3GjvyWs79PywPkdBbWBk1zHPij6B8rIqVed6kXuiV7egbh2grfq4MvnCLOAiHKAxt1ixnmOyuko3OdgrMKm7mf/S5rQQwnTBQhHcEay2CpK2/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f46b0141-32ec-4b20-7f75-08de1108ba9a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 01:17:12.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98Xca0ntOuJyn++EPKFuU27ZKFyg2XzzO61caNWvO6/jZb8TpHk30nrakHXwHUSSu5bxKtkBJ97bqVr26l2uqQDC4qCwPVFQobSHQZoqDGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF00080FB4B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=768
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510220008
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX1x0WvXSg9etD
 5aX5PCc1aS8hUqVrBZc2u3NUFSm0E9BBn5PUfjLCncHbiQlQzSWPZxulvWULde3ucWMr/rOGnrt
 rLNjzheOB9+EKw4zDDBe5DAR4Qkb4e+Swnr1vRoTu/S4g32Mct6nmxrhZoy9vBgE4iq6p1sT4NR
 y9m5w6h8jvNOGFU5TITIJ23Mu/U0fYntlBeJvZWIVb7a+YQaAyKIG9k/bEFzgyqogJRq1/BnPC4
 BicuI0yJ3zTh0rOx7VpVvds/7uICdzcRSkrUSHR8F+gwgtqGE3jKpbdCdjXIx6krlCSDT3o3YXd
 wXMwytaUTFn5pfGIDgF50YGx4+xfiLPNLc9WvKDkatAxADJqOfdqYLejFtvyt4NaMlVG1SYjOt8
 m39kXty629wjUXb2qXJUZllrEKN0FA==
X-Proofpoint-GUID: 6OGbZPisbXqkrbHV949izbbtLmtT-xVw
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f8309c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=01obCpd897dJ6LtwzUcA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 6OGbZPisbXqkrbHV949izbbtLmtT-xVw


Peter,

> Update the CQ entry format for UFS 4.1 compatibility and add support
> for logging CQ entries in MCQ mode, enhancing debugging capabilities.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
