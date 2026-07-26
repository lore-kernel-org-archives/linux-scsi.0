Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE24377EC6
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jul 2026 22:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785103577; cv=fail; b=UptfUm5NBhSvLyKwT7jqkPhxVKqIi//JtIP8vXOUo+3LPbHm5QSR0AVpxllfPRehUcVtheAyVUzX5A67wB1qjeOnbWvYD4tLKy8FA+7Gg+vKC5VuKQUbN3ZlLExvExZIpZc1XGW/aLfT2IWxJB71wklFbO0tX4ZUe68ilFlrCNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785103577; c=relaxed/simple;
	bh=VmE6pQKqK++3Zbt7bmNohYepDfGcr8XvHMXYPbjKK2w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pE7aIRlIF2hz4wQ/26D9KrW8Xcw4DNxLcBrObLXEYuJ94mjrmWFZGoFyqjpzUHu6BOaKDljHKoI+96idiqsPovrVuy1tUt+21M88dKFrdXKz8M8mqYHMB/2wBwjBWBm7naG0UltrcB1zoNwBC1xIA7Uv9HRKiUaEikUDLZLgHHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ltsw8quZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cr9+PA3S; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ltsw8quZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cr9+PA3S"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QLjZgr600114;
	Sun, 26 Jul 2026 22:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3p++nP0gH8J8qqTRxW
	qRV4Ug1FmZwB80txmZxOZtDkw=; b=ltsw8quZjZOSLhS88LIz09g4A+XKPWRHrH
	h23KK2yTcdn9jHlPfITCKeYzijO7yOyzA6VupwYiBdk7QbMHfxsRW0+WXmRBb/K6
	I4+VGl1L2ZcPnvktEcaSKvpo+rwKvzHMfZwR6ZC9ehwJowRu1ROvGfBCC/V+aB0V
	Er2oRi7IeYoCP1YK8vku9ZcC97THjKLn2JEfHL8JSHijLiTYLh6ANj38jJ76uFuI
	Px3bmkl+DSlsEbJb6nsAHRGN6oEYCXuwcmJelYtGdT39c2kudATVwiaIx59i979d
	m5wLLeYunIKlA0HoPDc7IW8PkkctmA4SM2ddOgA9FH2y6UQgmQmg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym10rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 22:05:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QM53JN010811;
	Sun, 26 Jul 2026 22:05:46 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnheggvnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 22:05:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hp/2IZDfL8MkrinJVAi2Sjen+/xu4ZLIwPhK6PTbQj9AwzlQebIX/Rbi9b1opFHa19VjcdKF6ed9nPy5HdvuaB2KlRSuJo4pKBuAsOA8xOxDnCN3kZdwFNtphWTGrySF0tbaOAI0Eq2/Z6acg1ziEIJdqvYBfVEHAe/87FIXJZBbwuglyuPifwaB8r/OzBz8zpPx+w8vPnpqDmKBb7ZWFl/YumGb6Ra+G/nvTvzHeRzrrSGt9YFLDAzFw+6kvryAam7Cbjn6h07omDMDrg+Z5zaDtoL/flrG7QG4tZKH1CKVteMxXvCrqzphRfl04nTyZ62AF3M2exdnRGW8E53YqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3p++nP0gH8J8qqTRxWqRV4Ug1FmZwB80txmZxOZtDkw=;
 b=quk7SCjQVR95P38Ftbt1zaktm51Hw1LyneT13yp4nCNVPW4zTPy+SkUkN/xMXkGsCDIaWbA3HFv3DuZNJ2ADjitPnqbv7Y8VZniqpVc0n+egrnCVqzq1/RzmYpWjg4OXL7nNsi7THBMB0qanRVNAgnEiXi1Czm/D9Azoj8mnmK5ZNNjkuMkZau4qLWD6q5VoLI6CzwkrpOs5lHoFl5PwTRujSrczV6A5UtwndDPdMzWU6IafJmtrlOSa0eqdXnhXhKm9v3ciH2XL7VsEk7B5PxV7IUY+In7LkrSoFUAm+kCT2LQYxAykvnYeipuPXc3g3dUlC9pecHbaqeBBHVevTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3p++nP0gH8J8qqTRxWqRV4Ug1FmZwB80txmZxOZtDkw=;
 b=cr9+PA3ScmpDs+i59qeINXbu0s6H6C5WL+Pxs/2qxXu/NNfqht+Kp1365lD9M20a0mONVLfI660i9HpCpEI6TaZdqKiq5mq9QQ2zJOuoTNjyyxljkeHkqj+8IqxcINPZEwHvYOmPuMorcnUEnepPWRX2O7DCHiz5Hdg8ZedJ9Eo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SAWPR10MB998087.namprd10.prod.outlook.com (2603:10b6:806:55e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 22:05:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 22:05:43 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260720013759.2979593-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Sun, 19 Jul 2026 18:37:59 -0700")
Message-ID: <yq1cxw9z9sj.fsf@ca-mkp.ca.oracle.com>
References: <20260720013759.2979593-1-rdunlap@infradead.org>
Date: Sun, 26 Jul 2026 18:05:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SAWPR10MB998087:EE_
X-MS-Office365-Filtering-Correlation-Id: 605ccba9-9d4c-4e20-457b-08deeb6209d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+o9HShJkkmsbCgVh2Ko/rkg7NVrH0L9L92nryaM1oSHFe+P8WP6IAcxRHnojZtCplfuuiRf2Pa1W2xAxJrkKZlb1hEtHWGx9gbd35qoJjBfybuk0UWMVCKClNpN60HzZjeT7vAQ41DwhqKP3jFhyyv6Gs92ICGhXvgrAnyh7cbVEN6OQV91P7IiyHNwGgFut/x6LaxmXyMxg5By7kKCSEBDdk1OyuoOEqK+zurKXLRspF3gdrfr5zpkO6Ii3Tz+J8oWEq2rwanoB2Sw5BI7W9nxPIm0isOs5NllTFPig55I3gyxBHdTPYiQOkEkwh5YfaA4MGIyySp60bxFA78dB0NiXxm3B5Wgj+515koSU+lZfWLnOv+158ipirvclQO+HxyAtue50Nv8iWEWtHNd2CVs6BlxvZDdVYhaTt/5FX/p2foZAbJBRu6qeYHzLaw0ep0/n17kURfthBPtXw13QkIJ29n4Cg/KX5xRojR9ONAhdVffGRmz9bD6xjgYoHVdP1sIKdeVbdxvDbRw0YeUo2I9ne58/tRYsO41Y4S0xVkspGwugfUY+YvuIIE3nEnGmKUZT2GfQj2z2fJpnBF9HeELVvOYAfcKeePeG5cAGO9sWF3vEgwmc8u1Os/QUB3+e3gdoGPJPSAvwiqg4ETsKgMv4ntQh9/r2Ws5FJVB3HCI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QZ8sSZQV5af3EVq8H4Mfol1XEbJZE+SUyvBXcIqjVEYGvBnRGzAv+LOtIBvO?=
 =?us-ascii?Q?X64BW7yL1f0ftumhMiTpSAVnEBkh+mDJDPiDWifaLv/JkypXe+38s7vN9V0w?=
 =?us-ascii?Q?wZ0ScGnLp/GcshohpEITR1KpsTXVolRefcdhFI+ClForG0puAsqaJWp3Hsa1?=
 =?us-ascii?Q?zt4QUIynPhGVCvsNN8J0h26s+U2GZlvMnJR/vZpk/ygiZ0n2ZswUnzs7IckH?=
 =?us-ascii?Q?ODd/8XWCbFNwOZk/9NuhbQL4NTcN4u22EOxyGyYmblEtxOk9UWDDqFwYNkDD?=
 =?us-ascii?Q?LgYpQbiURp1bc7fdkWp4KI857qijkAeO4Y9bYw3zZrMygKSC+6pZHy83FfUB?=
 =?us-ascii?Q?DWZMOX4bDQ11bm+BDdWkDAr4lQjwVlSZROa5JLZ1Lgt6m1l6oDoiLt16wkGe?=
 =?us-ascii?Q?sJNS5QI9BnDJuB+qWhmz9AJZ07XhAurybZBR2RTKNsrAdRdnG8YNBh7WTCvw?=
 =?us-ascii?Q?Y0HMms6+OWoABe3/lJm1F01kv6lkQX495FZ3Oza3WPgOhmakfoJbTM62fy5B?=
 =?us-ascii?Q?NQP0VHUR/OkOigiTkUzybXlJZz7odcth5kwfWpoywr06L46EUVUlmN/tINRI?=
 =?us-ascii?Q?yXL1uuCu8QBVk92j9RZ0oMrOxyhrxBB0e0eMvZxPqrnOO08OzEISk0pa7NXj?=
 =?us-ascii?Q?/RwDA6z4ayERN3sAca/mfAzZ2MNmBPF9juj/+1sKP5/nu7/7//rVjjjwQbbQ?=
 =?us-ascii?Q?k8SVbaMeGReygEEhfDe0mQJGGJC5f3x3ujw7Odo5Ib06d2VkvT/UODY+AUjw?=
 =?us-ascii?Q?Z6CoZ3RHDouAdjt3pMMsyAhByOr/YlaxTk4gNlBf2Mw+Cg1GXnDq5q7Hm2AN?=
 =?us-ascii?Q?PLQfxUXiTZkbn0XHaW1lZFEABh5tDH92+XAdnPfInYQ10yLp5TDhITXOEQHo?=
 =?us-ascii?Q?IONFT8x/GH2GmgiHQk6Xtm6VgpdfTxV+hGdQNO8+uU0mgRZn53og2C8kvYTs?=
 =?us-ascii?Q?ssqOpBs4tpuEaZEr/r+qc/pHgcUn6I084qpauOUPT66jhNZJOyL5KH9eSzgQ?=
 =?us-ascii?Q?ZgfHEf4e70jTLDCm9evxEmiq2hs6YgQiXHEQjnJwTrco7CNIDL2vAfNzndWd?=
 =?us-ascii?Q?Yz4l14V2KXTrctb/Eumb/nwBWIc41jXQhyBjv6HrpKpMfdTxEo++QaTMQMZq?=
 =?us-ascii?Q?4G/QTNqByiDgfMgs+p6y7SfBkiN1VW98cJm+K7z+OJy9f4WpF017xwVzQLBn?=
 =?us-ascii?Q?6R9qUHSFE3pIPQfl3O4f6HjUof2UtyTDCWXFELDbYwdl4RtRqujOhG9HbmHk?=
 =?us-ascii?Q?gUwilPgYA6nqEWCcp1AiAdYReCWWFJfPfc0QKw4rvKVUtN7LOVHKCfOPZG3J?=
 =?us-ascii?Q?bPqKSassWk2OgA60V0JRl30A+knQPGyRRhniYFKMblJX9/p5dhDEGsTP4qhn?=
 =?us-ascii?Q?tRt6dh4el5YfzPdZ3Ygw5ak1DdvsqanR8+cfr5PVqENQgtErDgY+GuOIXwz7?=
 =?us-ascii?Q?ti3oi0XKxT/EUyGEQ8BrZCeMof00MApM4vdSxR8+FPDgf8d9+Ie2//1TVMxH?=
 =?us-ascii?Q?FS2QFzaZ4cJLd/C+IBlkSOizyhT+jxKfLf0rTcxWi5RqnZ9Ck9PbKQVtA9KM?=
 =?us-ascii?Q?kTTpB2Ge+938apQC9Rlk8mpr+9UIRORCgck6WaeZyCz3sjxobS09JrOqmF09?=
 =?us-ascii?Q?UyLWNHhyGj3QFhl+k4Eyyn6betjcApLGeu7yAZ5yUgbhmXKyyzMsy1YzAlbW?=
 =?us-ascii?Q?26mE7sBNb2R4Cr0CFClWmfo/eq6/XhNKkuRguFWcVFpa2L/7VvYlYuIErOmG?=
 =?us-ascii?Q?Vg0wJRzWiRULED0RTzWn51Dkmko0beg=3D?=
X-Exchange-RoutingPolicyChecked:
	SDscqvyF/ZhGUZeMej9LfHIRycntnyzbKVhwKlGK/koiXiTPuEc70JiMDdCp8ANyU+S7ed532lNfcvhDvQWBU08HCF76GcfkcWhFXM2734c7x8tl9xdBQH8qco6esEd+oCTawv4y8/Jgq3RYT8QUfso1Xendb31/2Zt0p2joUfwXVt7txcccpquB0a7TTlkgMIsqwmOK0RrpRM/HBLKDtnuX4Sksk1AqhjsoF4xteQpnRtDcLJ00/9sb+ro9eg8HNOj6LtQXYtF35ECUZk3LFzFvfe4a6BU7Bcw8y7Ksr3U5L3ExmxjVqgnqcmFBcOEBIX/b97/Sb10Wrs2Ni7dd/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0s14GXR4N2J0DWQ0jiDXqWiSggpGEqmMEavyK+KnWWlF2qt9tmrkgaVSbxNI3dE+axayVpWlO9aJuc5ngZmuz4LyrsT3iqw8uWRncrsSQ+kzjQ7ZIn0CEGWuUsR1LFo+vDoGnbF3alb8Bfs0NJhTlSuzEvfJkDSpv3G3QWDkPKUJoBWQMyiYCV7XmAOwoM2gAjCkgJU8yyUO8MX2Qg3GFNMOT+vmtdJhXoKh31tiOlz/NMbw2AsMTZgl/bYpXqU8jsiAnq10oGyCGEPYRStNm9JqXerq9OtFcdi/iAvyYEBdM/0PgvuMXlKIXjqBL4u268UXPuasaHZqpE8O2cYSZWeNt1X7BcDyTANBUDsvxhLBgk38GBGRaLAFeSN2DYu1j0KUl0PKMZ5K5aypN891i1Edy6oEf7tpR+Lcv18zdQhPk/xQ2MPevKNHtOiN2SFiJiqJUVbK3Bz2MVFIMjIgMk2ZFcA4oRQhzKxhvTFr5DmfVoa8gkoLCr8udYtuUnUXzVBM2cCl8jIUogVaaGA/65KfdbcgmLyF6SD2Yt7mmA6JZU1jHtkjxHn2/Zm066Ec+WmbPeI/kVUAYucTUHCGGWB+CIW8l487NNhOHwbXS60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605ccba9-9d4c-4e20-457b-08deeb6209d0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 22:05:43.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltJPuqVm0Af5ylJBgdlSdplqCt/g8oGJx4v7Yb5F5uMP3+6A7Sk96xxRMK2US+mM4wbNLv91tfkiqGG8Kf/Hv0peN/3geU5iyQDe0H/JWLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB998087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=794
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260225
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIyNCBTYWx0ZWRfX7Gyf9dKsSDqk
 v60FEn91OWkcmMnkPybIIcZx66uiXQglIGfS666DbjF/uHaZja3rYRpzSmqW95tIPrsqizCWA9g
 RyyhEnzR8tkEjXwgCri/JJ+AUq//0E+q8pqmFQYtChQanqX5EedW
X-Proofpoint-ORIG-GUID: XOSU23Z1NHq5GOjoE-f1GW7QPqfZQhDT
X-Proofpoint-GUID: XOSU23Z1NHq5GOjoE-f1GW7QPqfZQhDT
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6684bb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=LPHoXlmML7JLwi0qdhEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIyNCBTYWx0ZWRfX9E8XE8YUggqX
 SkUhp4Owe2HJcXXGWHyTcXqRPqho2PX/qpSs6yYgT9iJotiVgUZgcYz2doeKXmuqNiq1I3LCdU/
 GokQrJg2MzBzV73cUDAGEXK2scjuMWZLmovKm8ZHCKywm752A+Wov5lxvHLbLM0fontxpq0YWhb
 XNEpitYfZ56sGI5+kg47MQ7tQ3ij7WoK04vpV3XFVsh7LTU5kooR6VePi52CrSgd5FZj+VHrFqY
 18n519yA/cKrGLGaEB47PrL0dnzUWHKMEm+QcZGDX0HYaDoglVuRnRNjFw3jrWrUIW66xVjdQIe
 9SZE6hGRdliGfyv2KlvaGVNoOH8wE9P03+qPHv6uWZdeRAfMIJkRHviYRUjsloZcLXEocvRCE43
 ZAXN0ODF2vVOBvWblfZ3DqB37fsP5FhMJtV3aNHZcMWAM/mzNUbImw05ZRYlw+2r0VCJyrUPpPJ
 ECFGy3wV5bVjGP1tPrA==


Randy,

> - use the correct name for a struct in kernel-doc
> - add kernel-doc for missing struct members or correct the name

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
