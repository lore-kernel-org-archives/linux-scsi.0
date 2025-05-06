Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971C328B7CF
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746496945; cv=fail; b=H53Li85ER+RNgARrKCL+g/CHoUo6Efzlo3YU080ZraZzVQDxDLWoz/4dZ/1K1D5/aQ/dZQBWGJYrrYD3aZN1YUcy80KA9+R0LnXRFm6+n3xx26kpCx3pOz7CzE/jgEb/9rGGgm5f5n12qonJBj/TeB+X1aUe+hZl3KhW884CTUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746496945; c=relaxed/simple;
	bh=W68OYp2Q3ixlkTd/bco2C6HecByA1DA2qBdA9/63sww=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sZ1svH3SIJJG4Xuh+aUbRHOZJxTjxyx/i6Kaj2nTYB3z10yLv/QNkwi/VYoPiVDZSYryA6vb/C8DtvOsc6EOaTmGbtb+RFOuFHA0k5ibVnPpuw8eAzL7TMud4DM7pZ0dpPbG8jbFS6GX6ZjUW9Y0nr82O+g3xfXVV+atWoEyEck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AEj1pjMt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yAAFQc7L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AEj1pjMt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yAAFQc7L"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5461WWqk010792;
	Tue, 6 May 2025 02:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WMxR8entjoQljo8YEY
	WsUIuP7+mpKQaylRu6PfSnvnc=; b=AEj1pjMtwysSCpN7L+iFAK3jW938cGJE1g
	MTYoc0r+gBLgU7vyKfLRiUlgVgePyMVUF86tncZa4+W1PlPHoJJjfxXOo+O3gDJp
	6i6w6GJM03HNWp+v/NM/pshmDuThDhhzYoH4n2dhfRTxf61ZZlf9yjF0+++iHIkk
	s7+tgK5xHtlVseouhs6J8GV73rxH0UhE963YZJ8awXvaRoDj0JdBDMSIPcnyGtuv
	RZUj8mx1NVhdQdwVRqtApdm1FOlwB80dnT6nU0TyO2Uf6wkbEgHQFSKm8EJi4grY
	1lT7b5PtZVR3QuwX75FaBxkOkdHqlKia0VZCk6cjK0WWKv5S6NmA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f8uhr0td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:02:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545NsRJ4036209;
	Tue, 6 May 2025 02:02:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k95j6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mPTONSECXn6ZVNnFmZWHiMXMUqigZWlKgXouvCClGdjl1phhHRoaUU8B47sL84RNm7FIp6z79CJdcqRrgP5/o2o3Y2w5OEEEk0qu/g0erS9TRnXnW/2KB2BsSzW32I+ZKJzOipejrMNX0ntMABFJYebXlcx1Moy2S13yRNuJdbbv43nrJOboFq/SS8SHJnGs8wWfd/378mAC1OR5ihsP0icCulfRnJFQavOdcco1co/y4AwIWZ+HfG/lPdY3GYeUHbDYYR3CBVBbrETnKwwZF8cwAe9696jf61JKEGzmg/PXvSG4Npahb99wJ5rc3EIbCeGJMjYufEJaMZM+OL2STA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMxR8entjoQljo8YEYWsUIuP7+mpKQaylRu6PfSnvnc=;
 b=ZlZSc5GJX5ALV+WpMuoXSWPac35ipDENPVZeRAxg+rS9zY9l9tflMG6z0L7ZZmrs9auqXiA8bobpseGyxZj6CS3HtVVnkF909fy7PyHPCX7XFYEHpQBKPmoJKt854VBXok4zEaolvQ8jdhyg7XqmJ6cBBFDpcWn9o/+WjPhNoTLF/uxZIHxaOgBBDkxkCa5Z5xFKYAd/hWUJ079wNosrnpIsxvDQocSJcUULytBEhpWkri+f0DF1lQ4z0EO1OYowj+Q36DU9HaWbarfdlya51tCRRQNucelmclM1heS+wuAndgIMK5VLXz/PqQJKZkZ1RC4d0EMoq2qapQLC2+wYmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMxR8entjoQljo8YEYWsUIuP7+mpKQaylRu6PfSnvnc=;
 b=yAAFQc7LO9sFXzMRus+s8a7Qie0Bq+f+OeDUtNsbO2PUGECK+9CyvqtcyP0lZQD5LURXMtTqsuSBVfe5GkNRnFAbzrfG5Ut6poOTYUAzOZz4zUhETGJV6y3Oceg479FqVIvL2V/ubQmtYwpgLgUJnnHpK6VSbZGacRZB5YGdLrw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB7548.namprd10.prod.outlook.com (2603:10b6:208:490::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 6 May
 2025 02:01:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:01:53 +0000
To: Nathan Chancellor <nathan@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>, Ali Akcaagac <aliakc@web.de>,
        Jamie
 Lenehan <lenehan@twibble.org>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
	(Nathan Chancellor's message of "Tue, 29 Apr 2025 17:46:49 -0700")
Organization: Oracle Corporation
Message-ID: <yq1cycmwlcd.fsf@ca-mkp.ca.oracle.com>
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
Date: Mon, 05 May 2025 22:01:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:408:141::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 4020266f-9ba6-47e7-ec66-08dd8c41f910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9TEJ7OGkDLSH/taF7WMEjabiL1kYmhzOP/WmQ4k0IDNPjYyuGs/6LAHfamdt?=
 =?us-ascii?Q?vS8cPOzs5EUX6tmPi47hmkKcOx0qF66KBoaWiGzXCLqvqQn9NacOzNrEX/OS?=
 =?us-ascii?Q?ZZKSunFkaCjLEgsnIsBWcLEgssHoRbtpSrH3YH2YmEsPv+bcI47vJuYKln1q?=
 =?us-ascii?Q?SG+H5huvdKgcWq4grLAx/1AF9nk2/bEt5QxVaOJT7E3MnEdx/zaDkKBTJhJH?=
 =?us-ascii?Q?v/4HGRBeeaRAt9kWbwpQfGLFs8ENOqS0LOZOm1OzUCMwgvRhcl0RuVybPtID?=
 =?us-ascii?Q?3P2rFzJfb50yRou1nTyZpsvR9x13Gsm6C/DMQHjLgGgjVDGeYSgbh5LncxM7?=
 =?us-ascii?Q?0ubPjq0XoTcxH+8khgPED9S3DyYaeiEyMS1RKmo82CrxUOHPi7ffo795JYZT?=
 =?us-ascii?Q?6hnIF6a9tDXyH7wT3YHgAJnV2kzLJYNgteTui04qfiKIzITVHmIy2CA79gui?=
 =?us-ascii?Q?speiNOso1l4eLg2yc2IzSVJgG+1s8JcpAj6/tp8K7hQOot2+5AJ7vF1U1LQw?=
 =?us-ascii?Q?Hc+WUAr9LQ/lmS6zwysivIVFqun/Gnn1ATPyJtxsJXH+B+1jBMCrttYBQ+TE?=
 =?us-ascii?Q?Wosf3fhUIhB+S5RbrK6k5qk/3Fl7UBcUJp4zGrdQ9aAddYbQYXdq54RAFPvq?=
 =?us-ascii?Q?sC4+IQCE9nv36sYvTxVq1+Q87gttr1Rw50bOr6dTalvsS+VQJzV6RtB/KkDY?=
 =?us-ascii?Q?7UnGScizo3F1eWwowp5UDLhp9oBgIYmtHaSKhNLOVtkhS3HyizNa7rv6r1FH?=
 =?us-ascii?Q?1Thz17P+CmbDXdjZ0+FfSpR/JGAZti1pNqEIkVC7kwKtwacFDp7l5bFSuRRd?=
 =?us-ascii?Q?+ZVCVGTq3dWX7RZfwElFPh9b/M8dbw/6Pca5yKpieEjj31CG8tWbBH2FD+tG?=
 =?us-ascii?Q?HEOcELmIcnXx9l1vfMiguQ+8kjZxheqxS3kqplPLTC324pY/H0IqDnwuIHZb?=
 =?us-ascii?Q?Ou5KCBPIs628J9ZWaPpJwUC7AxA8p/14Zl9nCmuy4X/Vw1HTHDnPHuDPgs9X?=
 =?us-ascii?Q?bhqlbMwit/1UlqsKoiuq1+l0iqy/OYvNEQzptDvBiRdg1RpMAsJDMVqnd1vq?=
 =?us-ascii?Q?4hS3akqCPgl0VkTsCd0YtrpX23/K/qOlrlwno0asvsEb5LoyiPOeJIRdn1+x?=
 =?us-ascii?Q?tLIx92Pnhyo7iPv7OeS9oJlVvCFb+QsYIUiTSGHn4huVjJLJbxhXg2Njnf8b?=
 =?us-ascii?Q?v/MqxUigVba3saxuMfIoMvjqFm4KU0Fb3Mxj2HgYDJAhqO/jJBqyJ+pycAQS?=
 =?us-ascii?Q?Vn/FIkAwO+rI5rhwVNeBvIoM0EDJi8ppseoNAq25a/2QzqC/m672kwsLso9o?=
 =?us-ascii?Q?l7JLq3QxbFzAE3NgtxEOsDZ+MZG6JS4NPKYfdlmf7sSrUPRYWyZRI5okuH58?=
 =?us-ascii?Q?BFeKW32p4CdlbPbXo2MuaxJzpto0lRHuuVBYp2IYYijRcwvI28aYC85NeiKX?=
 =?us-ascii?Q?UeVSDGRPDys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oKgPhojZEe1vc7T1UEEc9KyVg/jbH7PBdfqynrH5reuLb7NzH4p+yLqB6UeE?=
 =?us-ascii?Q?HVcS73J26Mk0sUQMzUfmESm8bxbiC1j3sTAUmIN5hmVNQbd58qsWd5K8i0NC?=
 =?us-ascii?Q?3gJJUEUz+cmV8pNqh6ITu49JB3nPuaZerTNfNvlud56DBHwk9YKaUnlPwjPk?=
 =?us-ascii?Q?l/PtRnFdGMragSHeOJJ1jRRrjs37UurzDR0f8Z/afAyv6MzjN4Q82SZUOcp0?=
 =?us-ascii?Q?bKEXvXOhC6mfF6nPPPyCNb2pFo/5qoS5nyeg2FShuwxVE5Wnfk71yxVI58DS?=
 =?us-ascii?Q?hR3wZLWfwkVnXIOquat4gfYZQbrQoKO/qjeOoZ3s3AFk0X1BQ6pUkxm3npSO?=
 =?us-ascii?Q?Tn7fcSZPHWQLn+SyEPOxGBM57dF1JYK+EL46Hk3oGSvmfVF/PRzRXqwMj/GX?=
 =?us-ascii?Q?DxkP0VysIK1Ty4aNKBSj+aS/s4rJCatQCtD/4gBPXO9fIgfGtgRPiMQ8hWpH?=
 =?us-ascii?Q?F9AHk4sh37UXqTzhEmLX40MwGH3PNfEKypwMJgSA/SxL+jC2KaZ7H1uSmr4l?=
 =?us-ascii?Q?6meS1ejs3m5zxb1ew9nzb3ayU75mRjPTfpwOSGKt1/6ZLbEQlydyzO4B1ULS?=
 =?us-ascii?Q?hgSOfhW07xTT0cmlFjya1+FZtRcvjDXayYaXEUpLO9rrmYPao4qIxLcSchL2?=
 =?us-ascii?Q?1Sx6HCwky9LICr3Y0NIi5R45np2SF3AS+suGWdPvO5KKGIujPM9/kin7GC0U?=
 =?us-ascii?Q?pMV2hvQ6AYNWOaaLfk/MD/nk5XSIWaXSCF8JhPdyDV3b2YbwCYKww+U6YXpk?=
 =?us-ascii?Q?dyN8TDWoMTtdhXOsfgU0MpJizUZuBjRYBEZzLAOc8L9PeTUps2wKamLWi9Yk?=
 =?us-ascii?Q?1fC3UPsAee8BDMNF16CBlDEshDLObcCglO3SWA21zvZs8wy4Q1Y2a4veOT7U?=
 =?us-ascii?Q?4j3DGPJKfJro+eZaClmVC0QMdqqAzeYIItcOihyIWYsq94ufq5Vv36jVjMgO?=
 =?us-ascii?Q?3287QPesJAEMnHVIMEJ4u4fjIjm8S+ZMCneKTfCWcKitEQsOBdQbidhBqh2X?=
 =?us-ascii?Q?HgLteHBsMV5L4fPjeexRLXGzvly1vHe82DSKuDHFOIGa2k+qky2e7ZlKOmSL?=
 =?us-ascii?Q?6PD5exIRzRKaeF03aVyBUdFIYQzz35r4hfxL4gtd9SXFmYHzGd2W1F5JMAh7?=
 =?us-ascii?Q?eqhvZD9JmG0SYV5WSnD81NvPTu4gxSEiMFBqAOU1yK62wXzC+rt6R334Y+JY?=
 =?us-ascii?Q?LKUvbhVRBMxe9myVoslPhx2ztJGVuBvMcOZ0sDowm6in1ncx113dPgL2jdJL?=
 =?us-ascii?Q?QnPuOwWqLrDEeLTDFEaOvUBhrJBqs2zOZ95Y7HCctQ6f/JjhvyXjw5BKkDUr?=
 =?us-ascii?Q?McEn7S/1qpwUyVah9kypZTBdl+bOe/La4McIQSfAmuyM0OIZZ8XSELT3/+4N?=
 =?us-ascii?Q?YOk6IxUlu4cQ7V6XxaevVAhLTsGQGNJuie0UusgYW/4ywzrrBI7btKR+VouJ?=
 =?us-ascii?Q?AKxeuJoVa1wSFc94pJX6qxtl/IVlfViT+tSpi3aOriM9czz47vXCVrjr/ZEL?=
 =?us-ascii?Q?+ji1/sHbgSPlPUIuVfXXdIk0I+DFWMDKM48sUUtPIoFMHTnZ4NRjiAAWCQVa?=
 =?us-ascii?Q?WfEungHl/5CefQ7ciZZe6HMMJ9TwCP1V09AjV9EdBs8LAyv8DJ0EKGjRd32w?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jNSHdJ4bpL6yGVNhXQieSlmgd1yaEz9FMdTjsrZbhZryN1afvoTk9g3+EDONAWh9WtMA02bpYBpSold3uzgfeiFqpSkxKMvPBhoFeAxgFCZm48lPRTlrDE8BAHR6254+8rAB+GUKZXUNy9FoNcH3xttODgipOW65pdob+ZGQeNKvePLjw7OwvFvmtGfoOC6Eo/Xv0BL2kv0ww9/b8lpQDq506fEn8RUoSJAMhwBidwZSmKrSgyXXi2oDGvXsBRtV51DNh2rkf41Y8t+JRiFjhjJfFd26nKzcsNhO72t0XACeUlgdbdrnj4knQ3BvSjf5hDBkOhaO83eOAJQp3JhpFNGFa0TthtkfSQ6enURKSW6rG+Bf6/0dSlIbX8ecwPykcwRf50Fawq6BtHT3lbdvcG7aiOAJyLgCYOTu0T3zUvBQoslH5b3mbe/yLZLChrbO2oNCZb2MUraPS9PHMGYuB2e4MiGAlWswPwdetdMfB0k060887sydMA2fweMUNUs24YmVLPEuxEO8dawH6Kbhiah6IRyTSRqDQoVBRQeSjTT/QtW3kReqE3rctnsY+yv58INeHjYMJVHljtgRbZk7dMdR5EIPJelQB6yGuZoymsQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4020266f-9ba6-47e7-ec66-08dd8c41f910
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:01:53.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ex4AGtzYFr2NniJKpOoGlayyNxITbim42fOGeCNaQBehbslYUD4q2h87JrBVuX2izrBWSiW+HSuMoGilDeGqMIW2AMNMS3xUXWhLJIUONUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=937
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAxNiBTYWx0ZWRfX3wb2AxoMQYVq l9PY6vsRSJoaP9ysjnKiI0vH/GJ98xETczXC6tbEyFT7xUvkXKV4EUuFXlpd8dOGVWespp8BO3o gitYcqJSekC/QXXwbS+8Q6CagyIHkLHr5ivrnFG3NTVAm+eqd2dglhlK8DKBUd7L2GaYInO934D
 WtpCSQ8YMTcnPWyPtVeCMditVGj8YQA1/I9LUgxslsHGgAp6+lZ/hmuN+rwwvDaWOxCcWXcjpWs eX+xB9PW2SeaONNoGfwYqLmZikbdnekHiymoIQCHXjPktYSTSc8qjna5gVx7O3vMgPUkypoHpeD x0eWbt76k6ci7DkdY6LLzAk0Si2raKG/uo+raR4F7QEVgpkKtoCnvricNpRSBR98j5o49TznvMR
 UapaNQ0p+rbAghM8q8vsEViRkqpceVT/x15BoG/fXsOUT5wJSborLVuZqJvEaGQB2iLDJO2z
X-Authority-Analysis: v=2.4 cv=Hsd2G1TS c=1 sm=1 tr=0 ts=68196d9a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=1ActYlBAga4uRFfLGWwA:9
X-Proofpoint-GUID: FOysFEQNfKYoZuR6RKS0Rddj_0CpqzOp
X-Proofpoint-ORIG-GUID: FOysFEQNfKYoZuR6RKS0Rddj_0CpqzOp


Nathan,

>   drivers/scsi/dc395x.c:2553:6: error: variable 'id' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>    2553 |         if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
