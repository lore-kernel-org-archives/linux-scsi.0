Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062DF1F4298;
	Tue, 21 Jan 2025 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479963; cv=fail; b=hIolI1i87NORgCHdjo0Mvs+Z2NKA5Gu4w6epmH8RXtgI1dJmAiwn0VaKcKwVTEvGBQU9tHl6S7vtnEzbu/18OjnY8PVtxRx0dp+yv0olFpID6QWzk8bKxeLIupLDZUjRJVxHubg8rxVRy2nN8CL6GMHUdJA6a9u8wfFp4CLzR/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479963; c=relaxed/simple;
	bh=FAjhLg6ELpK9RFa/O0yj661VLYnmbpvULsMhA6Jfh84=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ndE5z3rJm9CloYHnbGBe5H7d6MPxOxPwENj8iI3pPH/1nYJcP00OkC8EBFceM3Uk0pJM/usjjszFzwsouVD8eJF54VL6bSlbVdMwUK3l6cHkYC4IEwLp5CsKFOscaOgRJw04vPFVegvzSIFrR3YvTxyX7NGmM94VSR/bLVNMxbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IDqBQtry; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hJcbtX30; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IDqBQtry";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hJcbtX30"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LFE1Oh000709;
	Tue, 21 Jan 2025 17:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=6ghRqbolgGu7RBSJOo
	nHI6cBzq7Ffb294nzZ2tzoAAU=; b=IDqBQtry9Cph+0AETE/TOhGLMbLgduEhyk
	/sB4S6hpqy46ZU2osHiIeYXKxIir1z0KWjOxU8wacsz00LoxSO9+7sCkWPBFqPBE
	2/XgivTkzGwBR3Zh9+IcJ2KpUlGYZexQmD5vlFcbuxEmL5ktnBjwV7HIFp+QjPSk
	LNiTdaXIu6fYXFi6q9+rv3fO22E373ym7CG6y7+I7Za55iOZAqZvE7OWA2oLF3RH
	uyCUssFiYyP4YbSqDaD1mJmOPBVjrB+Do/jw3i+YNXkdQG+T1tSNQMaVdMn0yUe5
	P5zJPVA62M5RKq/QCoP5xc3yBJApOcsZyyTwdTu4tXKCq2Xa0rJA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485nsduk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:19:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LHAbWE038271;
	Tue, 21 Jan 2025 17:19:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4491a09jjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6451fEetY+Y4ZZosG/ZdVPDzuy+2aJN4otQELB/64M7Lk38VBlvC3UU+42RuPw7ioFZikL7G+4dYuf51dtgb1OLhx7TrEQeKkQUANyA/elyMjUFgYqMH8xW5gZF1YDPjSPcVHYWL1MaFpopxBv5UfRw42vfNy0R0TLUWBLxlcbNCJ7UualeeKmWiVRN36oPaiZtVoTC+UGOVRJPlVdZLMt+eRS4CmTkOXbTcORZD43Q3F/kJDosJcNGaEUOE7+zrzNNkLkU+yGoPp/47IX6XbkUupC00F6RkWTBtKlt02HO8nKEpLM+JnEtKk2SGTjKxenRmPxnDxuhW+dKRR0gVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ghRqbolgGu7RBSJOonHI6cBzq7Ffb294nzZ2tzoAAU=;
 b=wnpqsKH2i4ouMO9dByAjxvRPhWAndfuTKMVo5ND9XZxNtxLFoGUV4NbLzoWv0+qTORcfb7YLVA3334n3Q8k1oc88r8QFfbZjF8rWB3qLqghv9oByCFWF/HDUtN3dzfH5A+lOo2rE3A6Lj9F5Demci8wGQ2mCVqUXwKxOOZ2jW+rBelFYJMnwT38xJJz48C0sc6QMseFvkz1Py6t7Q8wIn3DnqCaZu8185E7cElU5oXvubj3i7juLStbZ7dUpyPT31Qj4RJs+81Zs2vhb4rYHkecYw5sObAnHcvzYlimWrFaMcf4B643oxtWpxEuGJIMFU5INonND2SbyKYcJ4dW3+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ghRqbolgGu7RBSJOonHI6cBzq7Ffb294nzZ2tzoAAU=;
 b=hJcbtX30lgPduVRuz3G0a7nZBVRCuLVl3ntHS4LMHt+iAByu7xHgeNniHD+J+iOrNVMXJ22Z0v74kn/qGH63wCJXw3l60q/cZwRVELdox+S05C7YhHIA6CSxQJ5L2MreTSyg9dzkYrqP/jqgeAXsyX2JIRGjYpTQyM4FKj4TbdI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB7993.namprd10.prod.outlook.com (2603:10b6:208:504::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Tue, 21 Jan
 2025 17:19:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 17:19:14 +0000
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: core: add line break to status show
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250114025041.97301-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Tue, 14 Jan 2025 10:50:41 +0800")
Organization: Oracle Corporation
Message-ID: <yq1r04ww0dw.fsf@ca-mkp.ca.oracle.com>
References: <20250114025041.97301-1-kanie@linux.alibaba.com>
Date: Tue, 21 Jan 2025 12:19:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:208:134::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0e1319-b596-407d-6f5e-08dd3a3fbab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G2xwkF1qqNQRfzCKnli4uXjwMKPeid5rCLBbq2vbhT27Re91hpOhNba2ReH4?=
 =?us-ascii?Q?8INm3w37Jj7eOripzRvy+j96JyKorJEwVm6ycBYzM/XvaMX1KK0oFD2u6Ves?=
 =?us-ascii?Q?kfnQNHykfWUzv9bIGOYsUu5F6Sdl5kOKWyz+dpGpZIs2oMPokIKCPyj/NVjH?=
 =?us-ascii?Q?8ki4+p4sq3fd/NEDV1c4ijn0sKf5w48iVR2kA3BF6CvwUt2Naz5TtfjMViUb?=
 =?us-ascii?Q?9hwWlrJmDRq9cjui20vWJDzH6S4GF+qDhFMfVH9r16rIqVmQ2PLhOepKsfTk?=
 =?us-ascii?Q?BvOsoAX0yaNccDJX6lfQsoVaUlwu/jtUVR5cmQytHe1WNnCFrDArdyiXT/Kb?=
 =?us-ascii?Q?gCT228VLJlpjX8iLTW9D9l2wLZ8fhswhZ82Hm8cgoOy2xXNOxPWqLpP+ZAK9?=
 =?us-ascii?Q?hf8Yq01nfV2QHegsEBBMx2uIvzEFop4MG6A1ZkrDT3fBFMMPx8dKK3tOBANd?=
 =?us-ascii?Q?3akl/QNgfZG/1c10E3d3aJR2exBmBRkV6fr3BBtPGN/wBeaOoGvlwoHudDKU?=
 =?us-ascii?Q?tPqT7tscL1JraaS4lvE9HiX6t8voXhSlhfSnhyGv7BdSW7EwoRvJM/VC3Mfk?=
 =?us-ascii?Q?H0BMMVV/m6YP+zrEitr4f6/ISFveCMT4nmhNfvp3HyxUd9UM9BvQFVhaMdQw?=
 =?us-ascii?Q?whyNRqok7kVZYLm+L3wz3x1R0ChbxgbzSJcfB7pnxuZYAI6W7iKboaLOuyCg?=
 =?us-ascii?Q?IWoA8/z0Wd/7hhaILqzZOVFn03d2bVsC1QYtMnffR1+rV6W1ABXGlUaFp1qQ?=
 =?us-ascii?Q?/cVmXmNHcEj78dhYcL/3YeNuigXkfYRDqW5MWIgJHCsGGIpenRJ8UE1XWJRD?=
 =?us-ascii?Q?KY8fLZCl+k6669VH3PO74457LBjvZPO7PJf7ZbTVVSmrcA2vrH2Qv6pr3YL6?=
 =?us-ascii?Q?BuyTbeUFbgrk6WfP/bjfP9o8dgoEZHKcqCWGtI9bmAA7PIiSkdXVw0n1Q3ov?=
 =?us-ascii?Q?mBh09R4mRdIaoQjfhUfiEuacb2yBYr+Q+/fCRYfhprsh/NcVaw9AWsoo+aRJ?=
 =?us-ascii?Q?s09hZA483kndF/7ezM5I64ndAKfUWdNb9nL6eIXj51uGO/P+szRFPZcAu5PE?=
 =?us-ascii?Q?iZo3Um4eJcJH1fbIMSoYZ0Pm4jbOXMdbR0+2i6KqvBXIHJSp/pzWNYkt+NPh?=
 =?us-ascii?Q?bg428yXTsv8TMjcjrwSNrUC+gLN82KwLgt0k8SInLtl4kLzWOXRjCET+ZiaS?=
 =?us-ascii?Q?V2MQUWTyosemqs+ZE4L7yRRMG7O+nZdrYoauQg+uwXYsBFfnObtW19zie8Mr?=
 =?us-ascii?Q?fbbk5vkQ3Hnlv+4TPzoUjlP5NT7HO3S8hk7I0OY3tS9LUwALsEay0GMXWJ/q?=
 =?us-ascii?Q?c4ByOw/m43frGVAkS7zJJR9xQjDqJwWuDApJ10F9ONGB1jNPeUpqU/Fz4O+h?=
 =?us-ascii?Q?tlCCt2JAOX3zR5fMXNX7sz90XzmP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+PFc+vudrF+WVHgW2S1biYs14lMimFHeUELftcuV28bieFMPqby6mXCf60oo?=
 =?us-ascii?Q?Q8S6AgzsFxsdEnGW2Ad1AN/pq64/zqDvwmXRrZUxOn7IY76oIWAvWBhyIxN/?=
 =?us-ascii?Q?RrMG+J70iCh5lFbfJ7j8srAmkWJn5+3W+cMpepKWVuiv5+tgygEjZZ0mQqoa?=
 =?us-ascii?Q?0KrZ9/a5dYLjUu8Aeb0St48bbuPJn5UzBCJmBeL9GpNvltErr+wBZ6KqR9Xf?=
 =?us-ascii?Q?5B9y+yZGMc0b9rfFDfG33wGpHMxxmaa4+BQY+a/eU1hVrjdmU5F7W3peZfwe?=
 =?us-ascii?Q?6F2+eMCx8WYdpJl29YCjA1MRSav0+cM2DVq2XeJ3Pz0COKxChiJ87U8qCO56?=
 =?us-ascii?Q?tazUZi8TzXB02+bJIa1NqXWR127MGeW7gdJZ2N/yn9zH5VJQ/Ux8wRMb9TCy?=
 =?us-ascii?Q?J/5xX1kfqbA3CSy0tW9VphSBUSda0ZCmLpE7qpGN0EzOSJ6liD4+7UoO35A6?=
 =?us-ascii?Q?GpNwjQ+0CtGL6MhZDLpVrMzsZSbQmSg2XJy4iPnWgfAysRBhdG+FWCiNvFS0?=
 =?us-ascii?Q?j91/NMvDy0c7OCkRmW0CnWXeXVUU6q/niphYqN0s1NdI+8mgeaR/QYP8uQkf?=
 =?us-ascii?Q?H6HYucWP7EFZosN+mTaxJeumUBjgLlmia0fgZTA0yZqAjYcwC+vcQBDWUDCJ?=
 =?us-ascii?Q?ZOwxcyagatvtW9pbBV6vTqlr8cdWO+AHnHryR6dGsqFDVd3hQRSuWpvr4uSF?=
 =?us-ascii?Q?x1S3DYR56+7BcBw0iJOCzX5T4Pptp1kYbRRffxlNqucnKuycil6HhEZ6qr3Z?=
 =?us-ascii?Q?OtPazvioPYXQxhdxUgbXsFDCpPbVwsN60g9v5Gk9wvN4vBKa3Jw3vLQe//NW?=
 =?us-ascii?Q?d9LO4d9r+gjcU8t0Gxq9S3TUh0BBwY2cfObhqbPqTSS7BuRPLfzGf0pVaf9v?=
 =?us-ascii?Q?nbW8Qnq1Mw5CEZw3w6FopzuRF2c6w2+YiUxtlRRB6YhJp32IK4hw8bzB9Q/S?=
 =?us-ascii?Q?kxNaC80w3AluOoghfUnk5gmU27/P4cRugKY0WIv7/fvvc1DLioenz9hezm73?=
 =?us-ascii?Q?faRbCgwIAU04TIlmtDl2qE505e/t6LJeFJ7mqXqtOQdZH2GJlTDPRP/jOlAv?=
 =?us-ascii?Q?16jEJPz3Ha3q5pIjjOyLaiDpaiG+Q1Fl60BWlEyLxHt/36KLyKSJSyNgZeLX?=
 =?us-ascii?Q?1zDl00tHSa95ly5+O/Y5tdl033deDln31TGRpEIdctqvxCFTgTBeTYK/rwmd?=
 =?us-ascii?Q?ob3/6tXkuKAXleakw5qAc+5HS07ceKFArzg+VglXEaSMGdAJiusnY0wH8/D5?=
 =?us-ascii?Q?Dd3DUmKqu+5L2eTSJztM3mURLY3417P6jkZdltzmtXs4gnpGp/NDKupzJQOS?=
 =?us-ascii?Q?AvRwEKdc5Rs7QvAmAHqoVx088R1yuzWHqXQWQofHOkWxyuesRSr+X1M8xTy+?=
 =?us-ascii?Q?ARPHw4YApq4tg54y8TrPdG1Su6D14dPj0yPZRm8wkurZqsBhy4k6ffYRvjhc?=
 =?us-ascii?Q?13WKCYYjX47d+clI8tFZOuT2dLFjs27UhxZb6pKyrpIwutUqAQjZc8e+8xng?=
 =?us-ascii?Q?H6jSZKj/zjRQAbVDFalOCYn8xmY26sMcnAp3puhCw1H8T3I6KCbpzlEWv2I9?=
 =?us-ascii?Q?10KHzbSB5UkSvW6wEpSZSRk3XdygbaD75zpPKtnNZdTNVfkKCRlXJGHhvVM0?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/nJHwdl/suH8em/TfgS5toaOPAgbgDNb+Be0T89XjoAnmUDfH4UHRsgyu7eF/bKSDXQuZgrfXE4Y+vbWwlV0e0HROK6S+Z8z1juIZ2FdmWIed15mpzorUb5N5RrJ2R0uYfmIgxeFgzN1EZrXv2+kv0fuA/ipsCrAhRsq0DOJ5DSNolRI/tq4Ksu6pRh6GKtKc6taBU0t4l6fHI5+/kOEwmgTks4Bx6JH1WC1vOr9T29XPs7oUQq8yw3gdKFZoLnaCIDJsKQREW0u8fn34ljyvjx9ehfBGt5MUnfHwZrmHypp6xBSIVWWANMjwCU1COBzVPJIGRuYZWigPmA3ZEY4YB+wZkP8sR8vIrZRmC8UZFRLdqhxMUhifDMBKZIgazDZvu9qtXSK/zSSN7o+QiYOBj+4hNYqq3IcFFT5uY1TzIBEdO3xALqZ6AfAELfztAD/XcRmYzGAtzcq+8j42KMd3+vTlkL9dTLTDynv9x0NoX2vDXtEqpM3iell9fYuXqICDv5tVNJoN/lom4ZYkN0+8s45D5h8wf8yUtZ/aYtvJUq7hOzWpcj/UMHhj3BcNqcMNTIeHxqOpvxcku1UCcDPy7iiDkvagdZZLf/QjOYBTKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0e1319-b596-407d-6f5e-08dd3a3fbab0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 17:19:14.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNsUNaMxelaJYgRbvddHtw14FAmPdwdAaeKgX6hpl32hdOfYkwb0Osco0os5WXIOOPapJPrUy2D4S0GsL3OMIOF6tQqYDH+K3idUzvG4kPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB7993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_07,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=895
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501210138
X-Proofpoint-GUID: H7e3rc2tDQ76ucaY0_5FHtHR5qP6hSVh
X-Proofpoint-ORIG-GUID: H7e3rc2tDQ76ucaY0_5FHtHR5qP6hSVh


Guixin,

> To ensure the output is not tangled with the shell prompt, add a line
> break to clearly display the status.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
