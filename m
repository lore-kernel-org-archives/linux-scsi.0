Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86413B7AE
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764448231; cv=fail; b=hqEIyaYwuc3Q8qmL8S905gsJu9byzu5v6JS6MHpldUsUjLahWXe3NesY3Hc6Ni9mJmOzqUfucM0Yklre9jfr2cluOUb+mqFTPLaRaMOKcOsVT+Rmg+hMils1esCW6Fi5QmBSWVbM4jrWct9fF2s2trGMgVgpJQVeEQDB8yYyLTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764448231; c=relaxed/simple;
	bh=nKPDNhLc8GVHWbcIxuUqI+ANLLwCiJdkBVjqFtMNpIo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tdekpXhT3gfoQwT+Oobzh1pXiaMQKMxqV9woNsqZXRGvoJ/fgSOJBDIL+DWhXBl/GVb/+DC4MDzpyXvKja7sydrQnH90ps0J/Za9DPEj+qj+vMGSrrAgYSo/OTyJqSiOgCM2HVhjzyntbE+FgFaRGoo0v0vEExJGKzXwrZPS/3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C1jW9x/f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uJxRkhuS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C1jW9x/f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uJxRkhuS"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATDMFjS1624002;
	Sat, 29 Nov 2025 20:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CvYEiH/rI80axs3+Zd
	MSY/xH4bWHypgNd4IIDJhmd5Q=; b=C1jW9x/fLraUpNg9QTENgkfxIajwDmGV4X
	FvAV5SutLEn+dslz70+vt7Ev7FuUifLwuMnrI0wVD25VlQoo5B2hsmwmXsxK/j39
	ctPN32uuQvSZpnREuGFFilLDZrvbLinH9YzXYD60+WrZUcKS26g8xhvWDrIWnR63
	rV9Exv8JYzQaH72bsqGCXomoJazDFtWT3X9wd3lsAy+xsVjnTSLLUt2Yfe2ox9BC
	c5De6QG8euLZdMnpx4g9hTVBqX4joI1XxbkMsw6Ih5nsDDe4C3Nqi7VXyAA7ik1v
	/B21xt6Jvf9D3Ih7fVvOCq7LTdS1bPvFNAuFrPEYmKPgU/bdgeeQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqscr8hr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:30:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATJJSJM028878;
	Sat, 29 Nov 2025 20:30:25 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96qmsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:30:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltWJAY73gsF/FTD0H4aqBmTTRclceAEQT1r0OXVPNptaVDnJry8s2Hd1XfO7BGnLk2Y7bRC2t067ksLWYC4yoAo0F1PYKFqefDZrxrpx03q3AFwBk07l9J8yNzwOtCukrZZSCHk9rEin2TPZY5/ecSZbpQv+F43HA9934wlRoYJGhRlY90SwFlflEMQu15wMiGNZwzUeaKd518hvh5n1H54B/percjVC/l7K1QFO6e4q27FFsC2nFaZVFLXOJgWidSf29ep2lMUtxkKHqV+WMcvUtGNWnOz5hGWjsPDvHaCbm8x++3LCiiGBJS7wRLbetMZQlc5lB5P/psfNoxkzWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvYEiH/rI80axs3+ZdMSY/xH4bWHypgNd4IIDJhmd5Q=;
 b=ONTa9zeX3YNQMlAwAqzlTm8ATghirbZjfRKCzbIPGCtb9vv+h35z/eq6PYMf4IXCuvqurE5h6dC3qNM6r0UnRofvGhVvWfXfrdJxuXD+dqE1OttUNkozytocg1dMYXxWoBNOGr/VJK1tB0MnHy306FL1IbkTLQuaqJ+RXP1VdiPHK6B2bKv7c5eYiDw4fHsjwPEjrwVvI/sdHsuv5OxgWHpe9Xo4mUv/M80cPTFGlEF9vKV8yinx3zenNlFOsxVbzHZaqT3yi7bm1m60JwBjnyaXi7sfc+9IDfxiw7+RMm6vDga6jL4he0K52tXcHZoHuzKjrZdZXkcYeQHub+CJZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvYEiH/rI80axs3+ZdMSY/xH4bWHypgNd4IIDJhmd5Q=;
 b=uJxRkhuSgLHCsQWFJze5qnedZQ1fg+oKYdmfc2iqbffLQm6hoFyhuEEMCEXN30nGxeN3Lzpt7DnVrsY1kUzkr7lzsNgQzpjaC6RrbUH1fHpY9IM1IuYSl9IsHvv+X7PM3T1IjtnnMiogEWJA7Hbf3sfsuVtkIO36qNmDlUzCsuA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7323.namprd10.prod.outlook.com (2603:10b6:8:ec::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Sat, 29 Nov 2025 20:30:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:30:22 +0000
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Chris Boot <bootc@bootc.net>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: sbp: Remove KMSG_COMPONENT macro
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251126144027.2213895-1-hca@linux.ibm.com> (Heiko Carstens's
	message of "Wed, 26 Nov 2025 15:40:27 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldjoy42y.fsf@ca-mkp.ca.oracle.com>
References: <20251126144027.2213895-1-hca@linux.ibm.com>
Date: Sat, 29 Nov 2025 15:30:20 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cc7329-f538-4a9c-79d5-08de2f861f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0/cDoZpAMlHpd/qLhrJgnFzRRHNkg82KHKNrc+bUWkM01SSdn58H4h9Pq5qL?=
 =?us-ascii?Q?2PAylFAllnrzyPudwr3tAbhU8eAh/5RdOvlaqNqKoM9uQrnSJc/7tuNpHabA?=
 =?us-ascii?Q?A4mlxmGOhB4rC/rFm6J9ZB3/C2jOBXYi36K+YfY6MpQokWWFGwiZW1at3noc?=
 =?us-ascii?Q?w54KV5wIcwe33NG/qS+hGUcvuYZNjs7VFhio7Gvr2d0Z71LR0iC6JpLm2gDD?=
 =?us-ascii?Q?cKfNaYraHGpi4FsHMfuXtAAMK5N6mjlkNYZagNgSNUDnlocuPD2SJItHR/SO?=
 =?us-ascii?Q?hLWhlfpixGiZDM2z4Eix7GzVF33gPEOPhLt2i9vx70SknrnN6i7p8ZqNlti+?=
 =?us-ascii?Q?MOibBEt4jAjgMEn/hhdNNweEMxHsKGJw7s6d1GrxpP2rkYRZh2jOsdtPHZCY?=
 =?us-ascii?Q?xYZ0VpDLDQHnC3qqPdqeBMppm5FE1zq21GZWuiwAff5LNnEbzZ1+1bfKidIO?=
 =?us-ascii?Q?BM783LVU8RrlJ91eYjY2NLP2qrBheIPuGj7zvOOrCaLeZg3sS8NnI9mCvTi9?=
 =?us-ascii?Q?Jtl2B4GhKHV/ukzRJcRiaV2yGGQ/rbaAJXAs9sCSoPzGJueB4+rn2rlHb389?=
 =?us-ascii?Q?P3zOy06m8ORXSUy2hOfQqgRU/RK/XyheNQbD12/bAauPFl4TNpq1EQe9G+Oq?=
 =?us-ascii?Q?HtBpMbesWINLHjoW+0rL9NKasEPplokOMnmsA+Lc7QW+R3PFXzNPgG4MObKp?=
 =?us-ascii?Q?Z0mbkPVVURk+8h20RkfBQ4HhqNM25WG2me8Ut/7ppn9g10tbHY4h6AcTb/0W?=
 =?us-ascii?Q?/yAZQ5X9ChC7PAXHPUygS1xUzjo6DFzzMc1T4/f5/qKhbpvo/5lDJsbUuLkX?=
 =?us-ascii?Q?rTXyAeOb9FB4thUiyTdX/F+tPzMFIxbQvGi49hRPIV9CbCmb+DiO1aB4czji?=
 =?us-ascii?Q?91n57M7yLxmrAB+JhSscpbAjjwGo5v2wr655bHEWuFTrYyerYx6ujANDYsxk?=
 =?us-ascii?Q?CLWb3ooNY2nC83W4xtWwtA+WsjOlafkSYURuTvdET/J/ccPM3HbxKM7o3fpx?=
 =?us-ascii?Q?deATpcOik2IhsEwqQJWpz/QnXlUUQBUaMhfCYj7s1c44K6PmKfCapsvpuHzZ?=
 =?us-ascii?Q?+prL+6agK21D2q1EDY8Ogj2gr0TPeoCUckLKJ6QQamb9BIvbc3v16+vIPT0/?=
 =?us-ascii?Q?rSTDl0QABYCgmxsa63hnO36lwvk9QChPSBkOrVc1dwsmS/rEP/LqUx+P4z7h?=
 =?us-ascii?Q?XY5f9KOlG4Mkrpg4WPyzMa1hDEQXynpmZfQUHD3jwHCjcoCBsdNkF3Y1SiYK?=
 =?us-ascii?Q?bRuQipOYl8CI1Y/OsJlr5KBUJYeKpqY285UVPtSzKwq6EWua9uswNI2hh108?=
 =?us-ascii?Q?1RyIXw01Kk5Og3oKcortZ5RLAp9yo2gJfH4T3+tjMTrAt5OKnNE723CrHgOp?=
 =?us-ascii?Q?G6UBnKJ3csTlfdq0vc3wISpRN3/U8vRQnynzF05jBQiZ7FaaOsXWCLZ7kl6M?=
 =?us-ascii?Q?BJUjk7Xm1QqdPstsK9CScb1C5x9i7ePE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hu2YrNoKklOwL24CCp705f4jubvBTLVwDEks2WkHJkaUNzTqMtpJuA+0VZu8?=
 =?us-ascii?Q?Z+AE2/71G8XzK9bRy29Ndi2RMp7gzvIAIfcFxFz+YGjUSPRwFwXzJDbVFbbP?=
 =?us-ascii?Q?VN762mb3NHcSLPgOzaOSYvcbnAUNy71cxbRasQxsKPlSx+Ji/QtKgxHWTIjo?=
 =?us-ascii?Q?5k9Ulu9AjcQYrLPhdPv6oAtDlVX8e5mnNEUrWaUER+GT4n4ECiCysXs2NtDD?=
 =?us-ascii?Q?jQXypjdEN9fkzHsigEJKINoyB5Xb9+wngKVJAZOVK1hP23IcmkdDz1KiYVR5?=
 =?us-ascii?Q?PVxuMq26dEfDD5xQBMptDPoZuFngQj4rq4zXKbbvpYYZsjX2U7QcKJqRSuRd?=
 =?us-ascii?Q?/eZN7i/u5VEkoJJLb41Bp79S1PZaq5++xfnApvaESscYCjllAdeXVmqO38Bj?=
 =?us-ascii?Q?ZOD/G9Cc0q3FpuBKZoeDOXs8Kkygv2CHe5Guyei0Mz0jh3NRdPvUGgLJPVFC?=
 =?us-ascii?Q?9gTU7UBfSN4RP0mzmYDHjcXG0bNlvG3zFWHyPDn+UmkJyTkEap9U+qH2xObK?=
 =?us-ascii?Q?mqBycIypKIG6HaKwa3irSLKiaK6Lwqy/aDY+W52/MJ9mNXW/xGt3nquUKjzb?=
 =?us-ascii?Q?xmim/KzktFhdaJynhOVaEx9F0pZzE5g/VLvcFwh3JGkkwwv5xFLJcz8nSp1e?=
 =?us-ascii?Q?MPQmfjYhJm+NNho36VTPsEbH9dWz3AMVbuxe6G6h//+yAkkRXoVGPR2Z1xiX?=
 =?us-ascii?Q?J7eYCNBluMuEjH4FdchL4t10E5V/1sGDl0/qzS2HnzVIfeOu8duWBdNYo2AO?=
 =?us-ascii?Q?iFjS7XiQ8JD5KXklNt6HvO3JjMtT0ZzdmKZkeopoHDr6W4HMtzwCObV688Lw?=
 =?us-ascii?Q?wsaScn+aRxiBbD8sN8yNEfFz+xYuRihn6nqVWmzbi+bqK1Ag0/P/OyMOb71l?=
 =?us-ascii?Q?GtRZGgXS8Sftx79sWLXvo1G+K5X4vdC3jDznH+6RSpsHcLksEKwN2i2trmW5?=
 =?us-ascii?Q?3Hh2+2Vox9icmsP6tqk1ufKoYpysCSJDH+IR+u3sbLQIXz2xURzHqw4sma77?=
 =?us-ascii?Q?VjwsYmGwrMYrzHk+U6YyqOKcPlOBLonYlmushSBc6RINrFLzNGm7B4s4yjU9?=
 =?us-ascii?Q?935XRNTJpPkjZiB3DN8cRbnyAasv2sHxc0Kb29rIJ6gQerXIjcaxINJ0PRgI?=
 =?us-ascii?Q?X++GPEEZ0WSbAuwUq4b5PKFBqWW4woECDqmVATDR1RMv2zZVMLAsG5Zip9Pi?=
 =?us-ascii?Q?/YaAkJVH2FEWz5n2VfoVllHcT9yhb1pycA54qNhMTmX6m57xCitsfZEfMgi/?=
 =?us-ascii?Q?dqn0JWSB55fBpasdXxokkBqUc2YbLJWITKHChoY0+lINPnSarRTXtmHnbJvN?=
 =?us-ascii?Q?yv6iWHvZy+eyjqALsRqTEpXalr+OLl6ZP8dG7rmrt0f3wk1JCEOtyECIKGBh?=
 =?us-ascii?Q?rxOIX8Sap6UObg1NCHaqMyopzUT19sbuNFCs38ZdqvWoGwttrTWHBuZjxN26?=
 =?us-ascii?Q?1No4OZoOPsX8n/GpIqY3jABfJKXHSooNPXjo5H6/UrvqXs9z4ydVGwiJ/pEK?=
 =?us-ascii?Q?Sd1OFJqA75G54ckPMdqMaYjYEUbT3+Ls4KzDCIvtb86Dd51pLktuqdP8Ai0E?=
 =?us-ascii?Q?q+biBnZC6zF3blz8LcR3sFidKPlH0ve6KXUd90bM45NjwLb7EQInOujYId8H?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a3XoBeqFpE/K44lpcclbedMnBibJYF/35pwZ6cQ92Zoh4J+Keqf/+AAYvCB2NcACpuMxICe235zvdQSLqEs43TXln2wI3j4iMIRaBdfbV6sesTFVv1nIeotU3ppBInvIGg5kq+v+iOYkHkeJNLokEOD2O5UVz6GIyuB/rDNWD1DwrpTwnGWmbXh2wBoQk1ViLPEPoRyy4/LpNwBdfnyKDbOoq8ULSYS37JvojNTMxLupqhusgGIvOUuUwbg/1KMcFHntZL0YDTD32HHlUB8J2hBYpkjie+HzUtKDPhgI+W6iFiFafFHwJfIcWzjB3RiN1x7ZwtjoyVL6CayBTj0YH55rTKIqT+NeZqDHdFCW1l80hIruF/I2zpxfwMhkg9U7UPN6g9S4I6G/ogaSxUPYoPnzkW+3FobNYJkHJDv/8zqtF3l7ObjSE3jw1tE0B1E1KJg35rkHT4V+62jXPWCroGPFtOtPNTYJWhgiM7f77UR4Vs+cwzjFdi+s7MVaTE3sYzvGi82a5ZjwMXQ39NQ6RbbLCpbOioPTneuvItntV9johIPWuFXqp+xAaw74pzVkDWitPebxAcyv2bQPjJuZ8tDqvGnNHWa62GvFZRFLkGc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cc7329-f538-4a9c-79d5-08de2f861f1b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:30:22.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYVPgT5kiKbZXH0Wsl4RqFf0LhOoS19FBHtFp07JiHTsiOKnzJ38Bqw7tgv4iW8qAOo3RJV7IM9NP2ZrpPAz5rJX8DB1Jo5xEx4jXI9JGDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290169
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE2OCBTYWx0ZWRfX/LjdvdOFlHIc
 ahDy6FKNfUE6NWQGI8UXm4rPyVrE7SCmJ+savQX6iceZ1dZlKrZfMuVedANw4vIHPyeThY1gzKX
 jyQIFzF+QzqeHdsOgTNXFAP2kCuioBhkRhrFTxorBjh+4wtDfcrTiaYVNpUS6yIloZ3HuJ1PBvv
 37a+cA+Ttp50SDkMkB1a+OhDhgXQ1082P/2KNtSo+xVliB7QWAyW5pgYdlX2nBVdBE7UkZPUWzs
 ZK1Qt8nIIA543ym+JVt+V4E2U1gxDYi5ZZMifqF7d3ey5/fTGJinG89CLHQ1R4yXGKeKnB/ANKe
 0UsxqxwAeJWnwBYVRBSEv77N18qqJ/Suih0foEer79PSiYuCR5tRRzLe7toZcn1VfeptIMOcxfR
 tDAGaDrpUW0mefE919w8n8CWz+ulrA==
X-Authority-Analysis: v=2.4 cv=S7LUAYsP c=1 sm=1 tr=0 ts=692b57e2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-GUID: 8nLK21WVHfO_vtyWGrhMducOgboKIOnb
X-Proofpoint-ORIG-GUID: 8nLK21WVHfO_vtyWGrhMducOgboKIOnb


Heiko,

> The KMSG_COMPONENT macro is a leftover of the s390 specific "kernel
> message catalog" from 2008 [1] which never made it upstream.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
