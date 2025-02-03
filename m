Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B13A1D5CD4;
	Mon,  3 Feb 2025 22:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623543; cv=fail; b=ZUHVgG6TICVgkDj+FJ3FYk/qzEmU/bhnqExq1edItCbF9UvkDJrHVZxdaWEiDOqBWhsJ6NAC/nYnM9jPtur0s2eqoYrSknqhdAV3effhSCcEE1ysAjEmRCvUdgUy4tVuB/0/gHuARmtj7fq4oL8Myncsg7f15Rs/A6q1SppBv3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623543; c=relaxed/simple;
	bh=fLdx/nv06totiVLDokMylGVS9WUjSDVXsgT4mmNVzfU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K5uTsTivLUz5BLmwUKODQKug8WgbR/lqc7SlAQ+AoRk9zjIqqunCn5mLUOx2vLV7CS2HNFU8+Vd+O4x+QRRRhz7QBlK2co804BH7dbSZ0w3U0ZtM/y1Y10e69pkouJHin3b28IA+DTZbRGzkxvVx/4155S1wCwHwTMLvEP4HlEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kN9rfIP/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jv39qpct; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kN9rfIP/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jv39qpct"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMspN004439;
	Mon, 3 Feb 2025 22:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=wACKVqkSC/e2h/Rdjz
	4fC2rcXvfERI5L335RlPbFJ4k=; b=kN9rfIP/t/vdH5aM2dTjeVsXjKaxPfixfo
	MKORIE5srIMUR9gtgTMV0qmGZqlusIbEJucRttHDHIoly+1Iqt7Ttcran2ud7NHa
	g6VFhpdfh59QGm8fRsMIhVHJJvt+BR+CMKchGAr8cEKeuo3FWcQKl11+5LnOFORB
	Rc5pQKZ690fbJ3O7sU/tziRx6ecrdSjuCfl2Z+teohi1CQArxaiLSLF3s1AqBOvR
	QFUqMpNDLmw0n+StMBiJjj8fVk9hyVE0wcmLIaNIqNZ6Lr1Qg3Gijg1dx5S6VUVC
	XQTvd9AZAXv4IPhj/X3GtT/Oqy9PePR+eGOcbM2MhlcM2QtW0NXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73kmhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:58:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513LIABi030787;
	Mon, 3 Feb 2025 22:58:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8dkh9rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 22:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxmbL6XHELDr8p1XRbg+AHgc9kLhXUKosYuV5wjN+ar3S7pt/ZWtS3Tgo0+Jl6pPX7d9VhJJEQSmvUIBXtgMgZ7tI8a1tC90GrwneK3YlPHVhncHB3YoaeZBwByCkbTdMaIWPLw56hgr0D+4TuEWqZt5OyOJx7BPj1IOX2+Fvczoxp7K/8iwvz9jIsXbJOStn/ESBPJs1dneGcgsoBCRkUGtcAnL9Lemge7w9bZFuODTRqniHLfE+8veSTMkJ2dpzgCZJE6vVjAhPRYHx0uBaoxFZKuiBZeppoIRga2K7ukj6GVg5GGE+5WQSXfGyScJ9m2iHKWdxirqdZJm2PFlzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wACKVqkSC/e2h/Rdjz4fC2rcXvfERI5L335RlPbFJ4k=;
 b=RRLrOv+HcvkUROIe9bPrUD5gOH81BFm83TvMN6plMlzVvoT6pITQEeg1acLIvFSnWEMGc6wPQxffNZ6zQax2TjuQAbAzaB13gPTGf2mZNHF/q/w7/Y3NvQKdzWeNXIPxWL0VOhu7IkZaQmQyw3lg6BoFZsMz1qZmLV4E5RBoHdGQZPMFRhUgd/3o/nSzUsB9T5PGlXUCFjBDMULUVtzQWjAaXRbKJY2DjgdaWkshvo4sWZYfaltx/WBw+A0bjgtJYU4Drzl8tjowHfJb2qSwvhRhSBt+FBthnPEQsO9hs7Iuw3DkfLN9QPoktLIWuQPcLLvYdBzTsYurKUljuq6pXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wACKVqkSC/e2h/Rdjz4fC2rcXvfERI5L335RlPbFJ4k=;
 b=jv39qpctsYkc/NuAz0eVN5u0BdNP/nmUnVGIUeeylhZI68jo6qP1im3SnZ8vHwNkaWTETZeYkDPCH0P0V5q1eXNzZ+2Zvmcaw4XWzfqgPRWjjSCd8Bx07MPeENmSfg3b2areMj1CWqMQLkcqO04ArVcR3mUso4V0NjkaMv1SU0c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5182.namprd10.prod.outlook.com (2603:10b6:5:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 22:58:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 22:58:55 +0000
To: linux@treblig.org
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: message: fusion: Remove unused mptscsih_target_reset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250127002716.113641-1-linux@treblig.org> (linux@treblig.org's
	message of "Mon, 27 Jan 2025 00:27:16 +0000")
Organization: Oracle Corporation
Message-ID: <yq1a5b2hbz0.fsf@ca-mkp.ca.oracle.com>
References: <20250127002716.113641-1-linux@treblig.org>
Date: Mon, 03 Feb 2025 17:58:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc4dced-68a2-4f36-cb7d-08dd44a655dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?duX+xJGvKoolv1quUl0SVpfppUYc1OUEEi8IckKZ0HkVBn/m+NMduX2T5X2q?=
 =?us-ascii?Q?xXRBMhdQGdY0ifZC81wBj8A7URKIm64TZU23hal7IFseYnclcCYPg1IRoi3p?=
 =?us-ascii?Q?NR4sRS8P91t2egsynM4ED6CsvLSOqKzuDqp87C8QSCkNsIHbhkTDYpRyyE13?=
 =?us-ascii?Q?D1tNYa3asMTldiQLWnX4r6lN/j2aVi9cEUV6k6L99o5viHYuYu5HquvVpEGS?=
 =?us-ascii?Q?2maRX7zfKBfWKYBUgS89OOxvWe0Xaz6pwOaSbFFAUhDFehrEDQtrsjcGSGdU?=
 =?us-ascii?Q?XAL+UrE9V9fa/2WB3hYqIVs0OAWQYLpL+S/hhCxDtvx2rcYohb7zMjy/Sph/?=
 =?us-ascii?Q?QJP8j6QqmuQP/kYu4WX+/KOjhva7l0HYvn3ZWWXYaHA8xP0K8lj5g43JGhBf?=
 =?us-ascii?Q?zHuQLj/JTU2bBphs8uTjXx9rON1F3zZ8egifqNf+Uml5oTHtPjYA/ZJsJ/6I?=
 =?us-ascii?Q?TwJzi9MZkXpN+hZ7/LKsbocPLlOazJ8ncBckDsedy/u76SIcOjKseq78UejN?=
 =?us-ascii?Q?WEP7009kcaQSzbcwnr3QwL+FflWeyCoTA/hBA0s1Py7BBeKOurKIsE+VUsbU?=
 =?us-ascii?Q?uV8UIvxsX7G9DcxKqcoI6FmcQgKRzhM3hqmRIgRcIqKXcZ9jggcZnPqP0C3F?=
 =?us-ascii?Q?5KDOyWqmMQlM4/Mx5zk5fi4EP90Hb09T152kwTs8UMJAb/l0CkEazGayFEqm?=
 =?us-ascii?Q?zfN8cpa2E4yyQfMImvf0H7l5diadNe3b0yuFWdOf4OsWi7GpayMCDyr/EmRM?=
 =?us-ascii?Q?5qC1GwzBkDiKdOGq68yB+SINGQ6Du2kXDBsv0Zd9Do1Whta1YYvsiNkv+9yN?=
 =?us-ascii?Q?5i7ysrv81kz50TH32nQ+z0bUEGUQl58WZPODCqPVik0jyxOM4g5uL6a+irkB?=
 =?us-ascii?Q?mlXfVOLXi3O3jtljp7SAUVuBX6xyFQoJ279esf0wLTm1A4lPYNF0wZUeVF1i?=
 =?us-ascii?Q?yP1HYbBmaN4v0qL3s5E8oL1kiA9ecwQn2aOSpE5a9tg00bV1+YpoSEXJ+hsb?=
 =?us-ascii?Q?Lb7IwoiTuEQHgy/WCFKLg0huG3AoM5m9VTKfDJEuGnviltpCIK4bEmxWUjnd?=
 =?us-ascii?Q?L43vJDnS5/4cis97epM3l3QIsBy/4oErQ42XxEf0Ug7FfpWWeSWGMRJJ4QdW?=
 =?us-ascii?Q?ZnuBC4tYJM6BQlzkKnZidxU0WnZJUDZzRU8uGhwXuRkztaigZesGtiW2FMco?=
 =?us-ascii?Q?cTaYLxEMsiICJRxRKEH5fls/BOrfEKKvfPFDsVuKz9aoeNvbO21TD3+U80+C?=
 =?us-ascii?Q?6244dW67zLk8CK5LSzxdKYciYKW7nJdy/t/Bot+DuDW0GK9OoMNuabQJE5l8?=
 =?us-ascii?Q?tHASD8u1MXbV2hqtttP0CIBXPzq04RPC4oOzqUtzsfF2dpGHey+X8WJKX/KK?=
 =?us-ascii?Q?9sJ+biQ6bJnRxPjBONMvO4Fqmuyt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dQ1tGLPG2MvLbKxgWn0ShHN7UUkKNmg6c1UedJ52+nrislVo3f2oyJdH9dDz?=
 =?us-ascii?Q?V6BYHtxObeBKRml8e6163APcDdyz5MZ1YXXmVC/YVsSh+ajpSRBMOdftrsPe?=
 =?us-ascii?Q?sOGBk1/RgbSGQ+hTMchlhN3P/T99jBvSVbtN2JsVMitGC+F14IB8y4W9ps2N?=
 =?us-ascii?Q?P+kirTMMfc5/LSDFRsW0/5PSn/JUPyQ5jYAT6ovZFeKDxVqpvLHkLBn5tBH4?=
 =?us-ascii?Q?0zQyAWxncTt2/lkAO9e/kH8QB/i7AELPEd0E7/LxK29RZYEsqi7hEdHG0QR9?=
 =?us-ascii?Q?ah++Vy5PgFs2Kfk7CMeY0n8GX1e8TJH89J+VhbBWjYdaUcl0stBI5/4dK3mF?=
 =?us-ascii?Q?+mMKMCEzjY/qVHfSa9llmdQVt7+hSPf/mVA6JhRZkTiFSn+tNWBUqOHsvS7S?=
 =?us-ascii?Q?LnPrObsahmcf1lwNd+wiWUZ0n8ZbWtd5PWNB1y25Qu9IaT9bXR6INCEKNqq+?=
 =?us-ascii?Q?mR4hS/jvdf9kCeLJXEFhLx83mUASed0CRNPhH71OCMXNBNU5zEjex8DpPCMV?=
 =?us-ascii?Q?kZ4OSM91pYPu4gGj9ST065PZxWT705oHbLQCZR8bpESeVBZMj9peGvf5QnKx?=
 =?us-ascii?Q?5fY74GEDETrrjsZ/JyCYzAXVQgFztptlrg77evd4XBKezLRU5LeuIxTYXR1N?=
 =?us-ascii?Q?CuOW+OU8ids3Q1cM5jDhT3B0Y6/AmkeNvSP+KWdzgloa42rHSjUMx/itFMKV?=
 =?us-ascii?Q?yhi5Pwmye69mcRev05blC+1MXG8/SKz8wpka5lvYnJRcQek1ZGq2v/E48h+Z?=
 =?us-ascii?Q?/zMgVTCkKscIALoaQQKTqGQtthCxRuxD0YxFdEjC8vnVs1CxxooHkiyOa76d?=
 =?us-ascii?Q?wIP04R0emIttB2AHSIBBx6kswuRfO6HiZIuNvuoVJDRDt8f5JI2ykUfqb9ku?=
 =?us-ascii?Q?aqJYyfD/sDf15zQMpPkYblYKO/fHqpJ98R6Z/fEfYM1CZQHqFPBiYNXw8117?=
 =?us-ascii?Q?tQWZ2KjzZCTez98MncVi+i2PAvaIHN/lxj1ySnwO/TqfGlrVz2d9nHDVQI6L?=
 =?us-ascii?Q?khLUUkEssnYQd2dpo99G/9YkWlSRxNe2RO0ePddbc6g/+o9DKquNvfEcvQc6?=
 =?us-ascii?Q?peFiDgPyP0UKE2V/y/ZqhhhH4BQ0QUDlNRPwWg9xawFMj+3McGQQY9Nelf/D?=
 =?us-ascii?Q?fbLRK379ZAUoDVi6/CedCVM18xMCNa1Gplf118yohWPPVDBqjxXTHDH+xJ1d?=
 =?us-ascii?Q?lfAiq4mEo1tZq2G/kgEnqlJ7MwUD4PpUctwFv/PAJXNpr+WF8XYdzqrvzUYV?=
 =?us-ascii?Q?JiJVyxcOZSPCnfveQnB6WVNUqFgMhwD0QlbOiSIeELiqrK/vK8TEUvM0i99R?=
 =?us-ascii?Q?diR1N91x00U26LJFQ/9P4/p1OB5MnFp2uqJjUzvhHSalyPAwDEK8GGEUZM36?=
 =?us-ascii?Q?kC4AjTH3gfw1XQ9MuaTUcBCTy4T2ZQ5f9uYGBHtr4Oof+BsavfnPB5lFAXmd?=
 =?us-ascii?Q?wqcKydzf6ApUoscoCMizO7dYzMu+KnWzzAG3hKqHkLBTxT+XK4oBLRl33e/f?=
 =?us-ascii?Q?lAaoozD4ThwqRDrywFHmwHRxcEIYev7+W1giGJki6DXFCnF/Ytw9jWNPhzyq?=
 =?us-ascii?Q?9UbuuVv622jW6JxlaP5tYK79/7ne++ZNhLsYRovx1UH7lqQwMb0aR7/J8Ftq?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7InkXlmuvpTdDMjxWOkEqp/o5S8rqyYGuzfBIHhMrONsNzOVSNsU8+yIOKSBabgbn07hZiF1B0+vlUq/NjH2U+92MhBZvEDIVDp9VS7LO76Inwbw4HVdewQunuWnb4/gEHMeeQIyrX4mdatiI5MUaAyyEPjRCs6NvIwxXIBLhG0etd8K95f0fjeEYbhNnBEa4PZEordltyz8VKpO4HFT1afCWP+DvVPv0O2JrHT5x6ZRfdRuCjts4yNcMK30ut8UmNGk5PP9NKcDC6wQX+TCfV1L+CVOmU1nGHS+CCFcil2fo4nxjvyBPEoA9geTLeNWwTZjFjz6NoeUEUrTI1ANGaCG0xsWyYccvaU5tUUxmvOG30lDAlJevhVUEkqnaNSC8KsS94fDsbzs6swLA1dWmuXhCtm9SSiUV7tt1TqHt2PhyeOH5K7TloyXc88UBNsSGOxkIMvTar6THHGCKbuGGLk69ub34EDzkUqyGtXQzi6/sQOLhSjLB4bMaoIiyUHzsylF2Y+VQKLiKd+xAQOqoJR67nDW64XeLV7ev/PYzydTBclfZj7M7rX/ASVQ9hhUsAgthdJ0F4HCDtJyuvBvPeHRK2f5t6LwJ9+MrcXnDVQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc4dced-68a2-4f36-cb7d-08dd44a655dc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 22:58:55.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGhrB510yXSp+C1fU0nfG4w5JrjGl8dfyyRoORbZYLb+C9d6lbB7p4zHYXVlsVt82enADtHx+Tf4VwMWHiCCQK1ulvCE+8PH+/QE3YuAd2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_10,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=893 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030168
X-Proofpoint-ORIG-GUID: hhCLS-5-D02jXBYiDJDYgknL2rm44ryY
X-Proofpoint-GUID: hhCLS-5-D02jXBYiDJDYgknL2rm44ryY


> mptscsih_target_reset() was added in 2023 by
> commit e6629081fb12 ("scsi: message: fusion: Correct definitions for
> mptscsih_dev_reset()")
> but never used.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
