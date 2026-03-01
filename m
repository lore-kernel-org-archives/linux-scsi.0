Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4F2857FA
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 01:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328370; cv=fail; b=ow8R/LRDRrGuU0++CbZQI8QSy+51/fRfewLwLzyRM8hRDebGSAWZCLUhqe5xM5LwjU1dVhbqMB+kMr0CDANHocgOzzce4AQoxpU37yMiN2rXU8LYYUIRCZuLDESHN4GkfjtmmyRRbn71Lm+5CG9l9a/UQyLnwm0z+huN13mQOS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328370; c=relaxed/simple;
	bh=ZIAq9L7Tm/5k79xu8qcjJyiUG+GiDmrmWBq+9kRXSZ0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VtYJ0/nY64t1ZNEbcIB61wYNCelxQwP+AY8S6C1lv/JLbb5RVo6ukM5RpdytevlnE7gHfnp5PvWC03c+dYS/RpRivuYBXIomcmK5a8z7cwTiJits9AUWIUbl/qk/jBusr1Eii8fTmTPMCFsbOcJ3qpVNU2Zhn5BhW9spUbtchrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=roq9/sWx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gBFsymmt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="roq9/sWx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gBFsymmt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6210rQtD1813923;
	Sun, 1 Mar 2026 01:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u+0iROL1c/G3wVds32
	dznDd6J5s9XFFosJ7aI5dxEBw=; b=roq9/sWx684UUbPg0pZ4Yw+oQ7yHatZU5Y
	YWgjhKO8YRY6iBcWgvBOjGK6Wpj7K2kEU0R1WC1kIlV/7p1GojozGxbXEXdiMTxg
	SMPnYnKLzKhDXJVwW8p/9Bm6eDbNcp5z9xV04NUGtc6B5UD//ngnEuHP2mwtTw6P
	j3YBEcOfZadwCuM4Kstp+visJ2f3CpVjf/6VGK5f8gec2tmWdhVYyCmJv9l6dYl2
	A+MsYyntoE5LfND1h6OmEdX3QY72aPPN+LiBPsCNPh1nTszuJuIaw04MmrwIMFbk
	3Fno9Q9hPXclw7zrTh9WBTuDOYSM6j33Dp820rdpkGqmP2ZVExVg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksg80pgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:25:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0gwK036951;
	Sun, 1 Mar 2026 01:25:41 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7dvyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXEewoXE+Zqj8YvzYdXny659o44efBEpXWWka7NvbQ9lMnd7DPuXsOYmn2bjdHYB8XlphyNt9y3eP4b0AZJSIzW04vaNmoFNahPpTO7NSaM1iPwfqgB/TTIqAhQDhukHaU4MAPh7jQ1/Zw5b+L3NplJ6s4gGW/gNCBE/StSV92IKmdxz5NTCl3mMVu0pX8bS5mXlVO0w77dC6z98ss8hvbTIxgj/1eqjkPz+r3hDFZu3EkxvtstVlOgPt4THfZu6VJpYzuz8bT91g0hhtyPQaVOJnyFUXRKto0WTZjLuT8kiedxY/zADXxiaXz1TyDZya6Ozqlj66IWqIst2NBtr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+0iROL1c/G3wVds32dznDd6J5s9XFFosJ7aI5dxEBw=;
 b=o44kq+Yj+uOWG23Pp9eFeW1AbsV0It2cx+94GXt6lRfFO7inLmTPyyyMA5eUGpAno4i2xI45gGDVSS9yOaUdSCX9XOKcAD5AeG0mb56030y0oNncxf5LN93o6KQ1YmJSdBlKTV3Q9jcvdRsaAbWSXGiPxhlLkmaN4Otj8Obe58eVpKHM7sjO/KObpDCvdM+cyQnSChHdgzr18/XlTQl9zSsRHZfChr65De43DVtUO3ysRjd9+HraSAFcYwyso9C4VjzPSYOR2msw9mNAzUjbAtIggSEP1KsykWoYRoLUvHNcAAXVCrXik4gznB5/VIFhhwHqu7BYErtOxUEcnLPX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+0iROL1c/G3wVds32dznDd6J5s9XFFosJ7aI5dxEBw=;
 b=gBFsymmtUpKRK1ap1psW+TYF5yGQ2NevYB99VgAY5+BeTYr4r73AzSwYOvotc3ESwx02/1878z0tQDr6hgUEsGVPBnX1YTnXYR9o2CNyfiWIdcUIJ0iFLdG6XtXS4W+K1FY/G1NgGracy4wh/5QXH887n52LxMr7ArnwkaA+zBg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6500.namprd10.prod.outlook.com (2603:10b6:806:2a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Sun, 1 Mar
 2026 01:25:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 01:25:38 +0000
To: Yang Erkun <yangerkun@huawei.com>
Cc: bvanassche@acm.org, dgilbert@interlog.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, yangerkun@huaweicloud.com
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com> (Yang Erkun's
	message of "Tue, 27 Jan 2026 14:20:41 +0800")
Organization: Oracle Corporation
Message-ID: <yq1o6l81gu7.fsf@ca-mkp.ca.oracle.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
Date: Sat, 28 Feb 2026 20:25:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0199.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6500:EE_
X-MS-Office365-Filtering-Correlation-Id: 619562e3-9914-4805-cc42-08de773171af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	tDAWBJxWspR2lEKLzTQoVKEDlGa1X+q5T1Ly7/LWiqM4owWEFHVA4vsHN7ZMyqFBIIWbImVuTPFgyxCqniWMxCIou9wSlZ6nVklmzxNxO0+diYY30WvFh1GOmODkg9Qpzc9FUbgwj505Gcal8jsnhCYkzYDKPpEFrt/30SozJV4t6Nod4oU5dQBbdBippzLcPtoiP+jn6HJ6OWqXez8YdhgHoQYwzrkEYgyvjO8LABhAf7BxxY2GB/PA3VDwdXFi4dvPecBB6l55Alql/cdeRPqJlZjqL/6WryOgkWINaH5rcGoIpraH09jrmr/LURBgS4sMea9H7tZS54i5gxBYImvO4lNb+dJhIoCcOqnBgttuviT7UOlD7a5/voxSEHDj3gT2vSmpKAU8EZXJWjemFYRym/5EsdndwWeHfEas7P3O/a2EgfAYghL6bfjplyVzyopcmFmS7wKZfrZs3duOtrXexXuSpPb9qAli0fETMk3iQwSQCL5SISI8bn8XdSkQ1e8AzPSjOD8/N1UIc6fyGcDb6RjmB1/livcMSu885RWWZ2RKRXNj91W4EhQe0oiqRz8/8MTJKqjJOL0lBRb/7OHmFT/gLoidOr8kcWGS3oEJSk7wKPof+AgvJsqeZMfRQWLGvrep5mRbrsMSU3afLIDw6wYa8jV/eAFXoylZ8c0hViXhnI69H2YMpqkJL0GW5RLrzpE2w037SxnYJkiy9LqNooLsg8Q3fCbGMUXDTEI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JVHaHantQAz+vdrzkaQVw9fP8/TiCgay2v8nZXTVuwy24iwnjvfvTMBg29ZJ?=
 =?us-ascii?Q?izAQ2RJNX0IRnO1V1eeKTBQ+eT7dfJmI9Mprp7Hct7qEX08k+2Gzd0vgZnO4?=
 =?us-ascii?Q?AhcKslPJpKejL2dMhNRIWUBkBbnSC74hik8H6ytVelrcsLGMZMccz5e7g1Mz?=
 =?us-ascii?Q?igmcurjMh6jeaCyEjPhXoNqEiGNO6pF/mMPCRWQeixLOaPkyhALeH+IDcLtf?=
 =?us-ascii?Q?qxSni7I2Di93F9OeOHt0kP0q2Db7cIVfAxXt/p0aRDIFOenwybagA60q9Q8U?=
 =?us-ascii?Q?++TiyHMgVtrlNblmMjnTjWUF9+KnxD8wsh2nl/jLq9VTkNzFOspqrtH0601J?=
 =?us-ascii?Q?ZsOBNboZELdrSsrpEwcyLPETC5XDC+6gUFmHh4frqtZdWuyrXcSKA5/dbcvB?=
 =?us-ascii?Q?V3+xRPvLlJCvHLuDaznptI4he/KXGr6pSYjyThVT12VcoaFpMt6qO9DzmfBJ?=
 =?us-ascii?Q?AqIPHzaYKztSYl4boo44rSSNEUT67GW9nLOJKlOTZ2ic+aYJ7+SHdpWUyA7C?=
 =?us-ascii?Q?NLDz77V74/CddSzr1fTl/uT1Vj/+hK78EGdLsORgKVQPdCi108AzK5cbdwpw?=
 =?us-ascii?Q?9juUeTrvUg+pCQF32g85EXIus5D415VTcFsRR3yoKkr8NHA/5k8dHGsf+AfI?=
 =?us-ascii?Q?8NzfjZAaaD4d+MFyuFLPuOhSvS8d7uWld1aNj3kZX33B2AlCDDQqp0WJRxbx?=
 =?us-ascii?Q?5h2K5MSGf5Yfe3Z+j2noKyfFfQDQyfDS/J8dZITuu79g1Le6veR6kcbBdN49?=
 =?us-ascii?Q?xHt3wuwYZF/TW8Dg+9YEyP+2VmOq0plTnW6UEWQqSLR5YfVA6oym+0ZmDJAP?=
 =?us-ascii?Q?5RdtYZR/+aa13cYjFNk9L6TQeePgJJ65oI5j9XX0EpnYvUWxT0MQPr1/8Q9d?=
 =?us-ascii?Q?GZuw++caSj4GmLRMnvcbjCiP9FApGIaPz9OJmghkLB2q6CMvWhgNbmUbTvTh?=
 =?us-ascii?Q?Frz8iGhW3k9szDPZRzVEpSkpe0F40cFvAnqOuNWJ/VLG4uKgSjwLQ7Da0Le3?=
 =?us-ascii?Q?dQAyofxhLstHhOX5ggh6b8bxUKTBSw2gD5s1a+dL8fusI2YNYGggs8auuwPM?=
 =?us-ascii?Q?ejyfiMU4p9kFuYHL33apMm18tZfRsHs655HB+6kv28gjOo+i1h97W8o57muo?=
 =?us-ascii?Q?Q78jbAgUiknP40w3QUts+QnuWgPf1Q5+iBarKxwpQ0xqOyYeCf1fvYnT7GWf?=
 =?us-ascii?Q?Kkpy31jN1yN6LzoCEz7Tf3d+Z3wIqculYGLQXMcGAVSXZxOriLv7Oj+BEZaH?=
 =?us-ascii?Q?ReGShy4E/i5zYzjQqIhwc74e0eZOeZDe8Ls6jEUkX8ykHhHB+54O961GJuWu?=
 =?us-ascii?Q?kfC7d4pkVYUM+cFvv6SJ8yXvQIDlSTXS8B5WHfBwZc0RJrjQeBjRHMvhX8H3?=
 =?us-ascii?Q?GKnSy0bflnYgm5YHM4m21FAIySlb/SW2nmJr0+fVlOqmlR5DPojErd/3kVKs?=
 =?us-ascii?Q?mJZULdYjrl8z558TlEVo2CEXZuxK304fc2+QY8bCJP/4IzIOWxz/uo/FuQr3?=
 =?us-ascii?Q?U+swGG6Pk/U3LXvzXSQXpEvCSyQQHbWeIm4wChxj6Z2jWbK89Q38ozuOdDXZ?=
 =?us-ascii?Q?rzQa7+voBRTGdjP2yFqaYxjYIGGfKHOcSF3mdLBUHv8AxGPd2pDq7UFZh9kU?=
 =?us-ascii?Q?NRwW8uwPZ9Pt5EZugr4vtV//SB/MM4vriM+qh3bxz48s1+hiC7Kw3vs0T2kw?=
 =?us-ascii?Q?kn1QiMLgxdFx3S1LFlnomwNnLetkkfUbfJCpjR1y/4OyNMKYsbmcLmyrkoaZ?=
 =?us-ascii?Q?LRNnT5hpU4cVzztKDE3+1nLdrG2ZiE8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6DkP1T1fXGuEcwVLYEHnpoSObDiNhWuKSShv8R3g7liT3jKhwshiDRT5PWD4zgYoGCDZHyRH5e1VZ4rPvlF2UGxLtEDyb8CuQlBeHWTFOjuIV1sqprynaxXoAEGFZYquznX412RB5PbLWxBQhR2UAUbJzehZj8esPUeWTHmFz33dQlaS8CRCHc5A+9K13H208xWFiiVhsbLRwjePaYSz8t78rU8C0KmPYctgQBOKLZVDsBoqgQgm1jqaEwG5yw6rlcxHseuj0OozTvLnIO6mp6+p7JulTOVTNW6OriA6YUF/gk+QajJVHDaXR6rJvYTopkYohqeK/telIBfe1LREDYOgj/UeNLBjyr0fVNtfVbvULMMk1E2NMi5TyPmqKlG+al4cXU6lPQBCK6++FS9u+/Q1wO6eyyaoZhptaUtkg7A4A8pkYgPBWkZETHmAaJDzPM7WSEwRIQHYCNirrPkH54iwY7OANOC+z9GCKjWmKul+z0oiVAksdGVY9agbamIalK5A2KzssXMVBMdtZEWEpCcWBLZiq8+O2AWssfcJo+AkQDQqeCgyZfJERareAibq8iTJL0MNYE8F30jeLRXlFFJI98z/6zL8PXfF3X6cBao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 619562e3-9914-4805-cc42-08de773171af
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 01:25:37.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DM+21JfaCw6KwSw4xdD9D3g8HES3eFqAu2C+eIcpLWsOQBy6yKIKYeQGx2C1Qyw7JTg8VeJCxyv+HTdEqjzmX2afh3fP5wRWjaUcVJU5HwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010010
X-Authority-Analysis: v=2.4 cv=bbJmkePB c=1 sm=1 tr=0 ts=69a39595 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=eRtNvDbIwmESxZLwdKoA:9
X-Proofpoint-GUID: bZkCQj8Tr3AAmR6UMRezt_25K94qA0Pj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxMCBTYWx0ZWRfX2uh+Y0QdWroZ
 KtCr9Hgps9rlT7Au2p+ZhpvOYDN4RIuinHUZgTJ/ZfZFLdYzUiMBQIiTZjLSu8PB2D/h4UDWnRg
 u4ppRHzO6r8/R2LXzFfa6cYINmIwwSEB4ggpYx7nWrXVOOfO/I3M3zGrG+z9Ucb7Xw3bHUc4aC8
 UgvJgRwPxGYUnuYqFGNmWsmyRQkBOP59drU1W+mq0QzAIIBXjUcMpggT6KDz0KjuGlPGCKA7Nbl
 slhHsB+6B4zAV700tL+PPlYL7uk3XusrvhGI563X1YdE3FozUsVoHPrjcPvYeoXvXcN3YB5VobS
 BmBWE47xpBaCh2fZhGi/PGnx1516Q+pQkHeLRP6euRm1dad+D+885MEyf36CBI2Rzj+bLSccMbC
 UQsMUkFG2heG7pZb2wqUJy+SBEMox6IG0Wijvp2Dkb693Mj1VZdx2hoNRlA2Ik3QNsandKsoLrm
 cPS+w85hltqmHKvv2Pg==
X-Proofpoint-ORIG-GUID: bZkCQj8Tr3AAmR6UMRezt_25K94qA0Pj


Yang,

> v1->v2:
> update commit message as suggested by Bart

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
