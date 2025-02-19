Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2E722EE4
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 02:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739932611; cv=fail; b=CkzjWPusQYrpvQaRiJD46xkJK3OK47gLyGXaV2FYK4iwYg6xp8fZKlC3Hb9aLux3TeW0r77NIcRe6d6Z0W/oNJIIk1yONB5jI8YdKzMFDVBtw4q1SDjT4JzxYemOzIwQszbrEpchegHKPUyt3/oXuIQGBsojENhy+6tNJ6NvAPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739932611; c=relaxed/simple;
	bh=p9XldcWXZwXVgW9fXXxUiQ5UeoEWR8eWkZQJD6qIkSo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BcHNbIJbyhGwv6SW3oD481LBCUr2k/RRihFtSNdIph4jgnUNqPaeCmrb9tWTttBvbuf8myt41WprwULodq7IdtiaSCrHTdJCsnpyXKTyTFtvYFw59fbLx2up6GTqwX1cZezN6wYBntcfdNOjDsyfuQtph49sLkaG/GPIhes1U2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mZWp8jsc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R2NpJVq3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mZWp8jsc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R2NpJVq3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51J1tisG026545;
	Wed, 19 Feb 2025 02:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=mdsFrbANuSjzjjWqNw
	L4d+dmKeqeAZJYDRC8HVOlL2w=; b=mZWp8jscd78JsaZAjDlmNgM5eqi9EwuGDp
	LA32YbLsDBrVXqKXGhhtJW6GdvTuKNhZfZa9FvpAXpOCbi0xtu8ZOinW7gzEUx8E
	7Ul45G5EC+1BO7uN1McaXVOBd8nxnzTMgrW/M+g/JItxBsrc3qmwuONgZMnBRUfb
	oIgSJ3hjkNpXN8GXh8Q9YpIieK5tUVxYH0H6+Uk/CxRaNROG953o4suL9eFwzhTM
	CnSPFi3T4z+mFKBsVUJFs8TD473pRamyYT9FKSO3gpY5tPTV5N0L4i7wOTrQtE5M
	Qf12MwJc4zyslJV/qSSSggcAd3FechXyQ3nYLZAHUe29+09bHANw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00ngpau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 02:36:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J2X8xl025346;
	Wed, 19 Feb 2025 02:36:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w08vvsen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 02:36:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mv6fs/3aCyS1hRlqZSdwtecbb8nMVjGSKlfk6QUgiuq9CcQQSuiyt1HfsFKs5mmC9qx5TGbC/VscfkkP+kMN1VJ3IAfk0LvG36a9v3bao2HJ9ltlRE2Ly/Kcar29UE/XZ0mnXhd+E9k7G46HSGynXrvEGKV9PL8+i7PDnVVCsjTaf5BeK/IDfN3Ia+mS0jXYKpcrOPvI8EPqQjLiODyNil6FEO1zgike7kaNSDNfz00/iHfOj/S0DbuxT9i6fCEMO0u2MsjAda26w2Nk4bp13EVqwVV3L3sv2tRkEUema/6BsVmMTHUfDxyg5TZu7c9d9V+JGfmtiaN8X6kEE+sAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdsFrbANuSjzjjWqNwL4d+dmKeqeAZJYDRC8HVOlL2w=;
 b=p5sgYXEIw9JXYd3GF30uaLEe3jOEhVrUVpTNtkDRLIzlT4mMwwiDvYYKJmKR1ml1xEsBdvevb/P3JrIL85/+CFI16ZTIOgftcKokM/GoLv/hBWvn/Co96UtG+l86KSYUOYLs2Xc05G0v4Y1Oklm1MNWfU8/ZidmAF1iJpo0XZArGGi+mzInZARHwn+FpAfM9cRZkzVbLNLgYVnqWluH5QDC5fAs4+x4nOvf+rM/LdthiIQMDJg+9IyW4dkS88OSf5GBI9gjEcHIPcfgG62RHbRdEim8QNxYfw3qMM16PCeE84xmBTGM8bUq84B8bV0hwkfDKBnnk2teyc9othsX7mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdsFrbANuSjzjjWqNwL4d+dmKeqeAZJYDRC8HVOlL2w=;
 b=R2NpJVq3Q8vIzjt9IjJrs5jZMVy/XbZrNd4IU5Wls2J+AUqp9skHuWNcLLO8JwA4qJ+33+cTGvtVlmRzDcweqwn1npNTnDbXZbNgwIAXCCngQaQa2tZbQ3J/LmRjLa2fQuj1KC/al/d7dmdtZur7W9VI8gFC+WqFBGJdsb7PasQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 02:36:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 02:36:26 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix locking bugs in error paths
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250210203936.2946494-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 10 Feb 2025 12:39:34 -0800")
Organization: Oracle Corporation
Message-ID: <yq1seoamzj7.fsf@ca-mkp.ca.oracle.com>
References: <20250210203936.2946494-1-bvanassche@acm.org>
Date: Tue, 18 Feb 2025 21:36:23 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ba294f-9f24-424c-0dd8-08dd508e3504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4LXs8Z04l4QiR/0Y5ltyfrdoQ/6/tiTz2G/hfYktJJlLw2kiaApYwQ9FJqvz?=
 =?us-ascii?Q?x/90yzDKlhSFKM9g+PxODfnl9uUeJTU5MXCE332X0O0iaJLkrexJtvo2KQhM?=
 =?us-ascii?Q?ZmdWWpf6px6CTrsN1wY8DIipcXcSF12MiGZQ08xGRLrzY3xXPfFoj1MNAYJg?=
 =?us-ascii?Q?4V991cXYXoj2b42uebug/lkU61nOe1dQpv2aGsc3Mzf28KtsIiCPMXp8+cWr?=
 =?us-ascii?Q?NZSB03lkcQ1PWloo5LP4p2vNRWRaI+6VXKj33oWZTtx6E9vwoQG1BKwoupmu?=
 =?us-ascii?Q?3agkgEw3mNUGdkHzo0kK3Am4KgXxpxIETNH5Jn4PWue+4PM4JYXXobeaZ90v?=
 =?us-ascii?Q?7QTwWvlKwj+deKjXxM+Ngn03vsrSrYmu35VG6U7H+kPTPDg7IOvEon0VWUdt?=
 =?us-ascii?Q?BDabUSgYrYBxuULh+T2kJ7T0JYFVi+EZeLo7J4Esc4y0Wgose51bpnhZuQKS?=
 =?us-ascii?Q?Dk8o1W6GS15Ohej0SMQ1Ln5ZR+OmMtLuNNbvcEdiNzNz7+rRjyqIxbxEAJ51?=
 =?us-ascii?Q?r4VfL7AybBHq19Ppxs32R+E7grs5a1AIUQxX8N8o5X3t1/lAd1Gn3yRaAHSQ?=
 =?us-ascii?Q?SQCHKWTRrTdyqtd5zjcK0hOKegaTTHBLEIjKeM7vrUKdZyHHnbCig7/PTWY3?=
 =?us-ascii?Q?4VBYQO+BjtZTeHRnfVeFBN3RTt0XdR2YZXv5/dKy5qUVMHgLLKY6vqc9XzX/?=
 =?us-ascii?Q?a1RuhMBhRNqqBPK9ES/3JdOp9bqFZ9jUX6gDsAA2CZOhv9e3M69pSYFDKJcG?=
 =?us-ascii?Q?glqPz7Kr9Wc76AE6z6PAnVvzuRNGPS3o5+cpm+stMnfQAPYZeu1ETANxgtIr?=
 =?us-ascii?Q?k6URWUJoWWbICLffbv2+NP0OS+E0BKIZMU6fH8DkY1aVCWgMgZteMVnUtU0I?=
 =?us-ascii?Q?jwPhV4G+FU73QAYw4FqxjZjyiOLxmxA9YL2Ud4988ayvp6ItUsapLCbN6GXI?=
 =?us-ascii?Q?eNzEbFdzT2knD+qBPC215Bit2uUvgW/PRK7AJoVcH9PugQz2fe/kuBqVULIR?=
 =?us-ascii?Q?pMgbVgzi4daKtE2cTh4qIVkHUVvy/mDX3U1vyYT01mSZATMpeY/8NXd4V+iZ?=
 =?us-ascii?Q?56PC5adAr8gj607U7DC6O/3oviAqmEl81svfaXGCpZU2+lkH91H5VRDRpXRF?=
 =?us-ascii?Q?X/WyhceFupjwVKH7kPTkINqGHqB5dQA7lSbiAFzzdJbONWY1kKA5Vvnni1Rx?=
 =?us-ascii?Q?WQsfCUc/a8EDSe+8yOdrW3O9LZT07OHKPLXJyyTaeePxow7sqUxW+pU3PpfM?=
 =?us-ascii?Q?NwxQMFUWz6v8Fa0sIbhb1Ai7Zawxu6fv5t4IEeP5Xpuw84cXTUt0jLZTVoIO?=
 =?us-ascii?Q?La1lk8PGHcCWuf5iGVyfdq3j7MM0D94owByXjJVGu1wpFc9ZwnaFLMyF3Kf9?=
 =?us-ascii?Q?3wkZrlywklI+ekvfSrlxLl1racBg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v39w2aZItSdzM3kFCMI023zQhKvEbkY/s9Aiqub/Tg/dFoevZdJPtdloh63L?=
 =?us-ascii?Q?wLyPpTVgei/G4lp4mQFY1Z5UnCMZSGIseC7iBrnmczOZqGcUZvGDYKPIVR5A?=
 =?us-ascii?Q?8ZJgnqOCyDglR2zEzo9QU+EJelsFZ4H6/dHdLG0/+S4iHRj0CaDBBjyO1L7Y?=
 =?us-ascii?Q?qR0LWxZKODfq0qTUQci3j9sqIIx0jQsB1YHsp11ABoYKEvbE1XIu8E2slrHn?=
 =?us-ascii?Q?tJd3IBbFmXKKmz+6VrxT0dfdwsJRXYFxqIpM+jBm/CyOZGeK4N2o77NqX4KC?=
 =?us-ascii?Q?BLJsxvyaOvXRNhiIhiPJjp/+4tl3pAvwufulv7bGqr0wmPa6C3SODYf4M5+K?=
 =?us-ascii?Q?N0Jcbbt+TIW3OF5cvRQrCbbVtysoClq/McuI7wQ28ou+sfcEYtD4+cvv1NAM?=
 =?us-ascii?Q?0qNLcTnJqScd7y1AEaQyv65ciOuIvvwPLvSe2vL4M5gDfkQMdnoqCvsvlqG1?=
 =?us-ascii?Q?cEOtOGAd5FF7bPavg1hkfN9ANgZ4XOgT1cRAcQ+pMofRiLDqyNtB1nVq47Oj?=
 =?us-ascii?Q?8jLSLEkuVvIHXDfPGSM5AD5XVd/xIPqKwZ98Pu1nGLIEhQ7yC5Glj3RZGrhn?=
 =?us-ascii?Q?Ure2KPblgoDIDzK7qDp4maaTOtAuWrNqBIaYVxT8faxe+kc/MdnnuEh90wap?=
 =?us-ascii?Q?Ca3W0U9eouLZvECcKk9M0LvLh1wZG98Snz6p2xvo/4jKTHNwwkcF6MGWa6Hb?=
 =?us-ascii?Q?U9v/MRTNtD2XTknagaB03QNelwyBt6pkvGttcwoy4m/ADoCSksIJ50wQY2lZ?=
 =?us-ascii?Q?ZJJtuDhjbgrii7Ga9vGFt33zcayuCznA+u0/xxBEJiH4hQYIyNEtyxsIx1Pd?=
 =?us-ascii?Q?2Ol5f7Su8C2uRxfaCo8TzyhG4soqLJufey+hX4kWtcJiJV57z5QrOxR8MVuQ?=
 =?us-ascii?Q?E+s3NTDAlDOpGzNg/TeYync4G81JVIv7krqspvQt/oBFwBC6SFR4mW4yr0vi?=
 =?us-ascii?Q?EivTbcHTSEQQWUiuIvpIrmU9gc3PXRHoy7zVUkHU+pl2sQu5XFSYPceKryl5?=
 =?us-ascii?Q?Bkj82ihwJLWmJ+cHYD33UN5zM/eYBUD0bWBY3HTIdHQFBCDvDZwS7vU8NPKc?=
 =?us-ascii?Q?u/HS2jXrmAGXXEJxIC/d2DU5tZJ5TB0r6S+7X2TD0+HpFO5Q/ZxekRh957bT?=
 =?us-ascii?Q?wDipkNDMERMCJaSr+RYRpkdtQu9xM5bMYL8PDiE87F2I51DrAOgohSZCEFBg?=
 =?us-ascii?Q?Bnyoxkgxh1/yRB7chMEN7DDw+MPWxS5FJLGwq1JOv7fW2CN71l+0SCJp1q5h?=
 =?us-ascii?Q?0bbSajXDbcPtpMKUpsDgI+ZWWJDE1FjJ4KZdsn9QT8GDtLq2lnm4DlDmGc6p?=
 =?us-ascii?Q?H1KmqTORBxDuXmixtpn3YPxMXNikI/LHRbVncl3mWhOpZx8y40fsHrmKVon9?=
 =?us-ascii?Q?EDwJjvnzGt5VSwdxcP6SI+x8lxhPo+rzhAvCBbBXWi57BjuS8VC+mRUUqut6?=
 =?us-ascii?Q?cnQ9ZI1X0j3ARMrcVeIPdyphdGOs+NSVivWnmUTsRJe5gc53+8WS02Wv9Sak?=
 =?us-ascii?Q?f2hyIdp3YEQ/fj+C81E/sJ5RGlg8o25WGKKqsPi5hXcOuzyiu2trJrMNcK6l?=
 =?us-ascii?Q?r9T0rc+VGAM1Ka1bX5nv24RwAPawFniNI2/2yx3FfIhuDvNjl5zO9s6KjiBA?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IifAZ5Yr8oqNovev8Vx72el5YPrA6QAvHFrqmtCx3moL0ELoAF2U/x2Y8OD7g/Jq7Vfrs7SZDMwYos1fSo5BegJ0nkJD6rUUDEc5BNrEYEb8GYRZSjfvl4wlgd3B+Exo6NQIaqGJFyOrYi7lqqvNdf0E99kQH48QluQ4K9cM3lyVLn6LnLTiYnWFMc6trXetVB6farKdMytiL/6DJ0DgpVoP/ggj3iri++RJOxfHeOgWnLuhX+vuZ5YhXuxLZalDp3JOrh5yn/JTTUk4JWGG7ebeypY1emBsfrr11bmnAfhuIPNkrsVCLu0vLaKGvYof+LUUsBFi5KoQH8jCmCO/kQ+QUbuFZqtbcyDRacQMJVU/IhLK+qK26e577cGHBe0RCNafYEE74wOCxPj4m61oTGvWZgoO68mduAK9Y0NvTPu5H6ayLhy8Vgg7oEQjJQrx0N5v2Xh0GPQrHGT4DwyY9pzvZlv/EjEcsYWAy1AzSK1ad+QE0Zn+6hAWs3ve02OMzLRRXMb75igTbZ2eLaTD/BkgdzEO2jz9w3zI4tE92bnM/kLcztje9zNpChBWS8rbbdg8iHHKqebYbnzFcl6RZKQkhbkfLhPn9dAiOm7hvos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ba294f-9f24-424c-0dd8-08dd508e3504
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 02:36:26.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVbsBgCqcI8gIV19ItMuLUX9wNgOkO2UlFp6jCGcJRSCRLnxfPvtuIEQYUWsnn2liV+v4vLyMGAlEZ8hUASnwr3pHUTlgKTQs+NakGqs4lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_01,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=536 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190019
X-Proofpoint-GUID: xw75eL_27i1iNuypU81YEoOaI9bq5f3t
X-Proofpoint-ORIG-GUID: xw75eL_27i1iNuypU81YEoOaI9bq5f3t


Bart,

> Annotating struct mutex and the mutex_*() functions with Clang
> thread-safety attributes led to the discovery of two locking bugs in
> error paths of SCSI drivers. This patch series fixes these locking
> bugs. Please consider this patch series for the next merge window.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
