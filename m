Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0D23F405
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753448782; cv=fail; b=niBJCBT2//nULtwytBPRVT+J+LvYN8tbqEDwkZKnJSGlBkZ09xgUsG+aymHSNgvoKb+kNBj1YqFeCgyElQ2tlikxiSlYm1L7dyfDc2r0TIu5ignVMaXo2B5P/whD0/G09U81VYjbYHV5WfA+ab5fiFbZR19VrkV6UECrwAvO6qM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753448782; c=relaxed/simple;
	bh=W+tbioRrTIju7QFZlJWx2uZErT3iHpiS2zn3IfBbCs4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ucHhb48kuEWQEcj6Bn0RXjwW3T15SS/CvsGZoBj9Sfv/m3XzeGBJk3DdtCnSzJzsfgMIORYVUpRjm/bIiqp/ofStWEI9cw86e79JkqBzbLUi956MMIHiQC1qMNn0/FAdZmkeug4E5jmJUJwR3Szb2h+R6dx7YsANkLS569nEf+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lQ+T8Y/d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uUnHQ81A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lQ+T8Y/d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uUnHQ81A"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PCjqEi015674;
	Fri, 25 Jul 2025 13:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9Iqfo0ZuiSUtOMEsnb
	66Mx/8miMfli3TOT0vf6vvOsg=; b=lQ+T8Y/d6X50BOjTVEZ+jo2A6sepIDP9xC
	xzc/P9d3NS9YDHevglRog0brqVDJDgc+1RPWNUV2JtWuiQXTGnospSpt1JzKeud9
	Y/GnsakMJd0gl+om9ywHdVRnrZlLfJoLgu0VosWRy3Uti5nqsXvZ/Mk/hLTUSBh8
	07BzzU7nRcBbYRLJuh0e8sDUlHDM5DKaqFIGGM3GRSQFq0ETmjiffZ2UVegKHGDJ
	GMfCSZU3raPofarHx3UqXILuW58R3/PZ6NyxooYP4mc1ocTDpf1fUevAs7WJbJof
	VE3xICnVhz0s3SwPuNbudGBYZQdMVz9Z6RisyJzMCjqu5GhnRFCw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h0ysj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:06:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PCA2Ig038430;
	Fri, 25 Jul 2025 13:06:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801td3rxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 13:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m//Xqr+M2rZ2O1PpiAJ0eRjHjfRPqm4gZNEUnO45VRFcuWRycFPU16JITSBk/sDsn2F3C7Q5vUnd7dUfpf/nodhShi15UOUXpmdwe5ie+SQ/C/az7CoLyVgdShRU4RpXKoXPlBgy5DHRuw3xHnGElL/mn2G/0pPbeLD9avTJZAwN/wY2BWDu7Z5SbFp71IixxkIdcMUJBbZ1/X22JVQ+vChI4PEak8nA4e6B4QglsG1MHLazviR0fMNzdmAGi+kanoOhsJzQnyYEfB/b8/Q1jNaQKRxWQapqFx2aOXf1QHydba6tES4HqCrLAWmstcvLnxARUCrrLDIiSmQiV2pP4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Iqfo0ZuiSUtOMEsnb66Mx/8miMfli3TOT0vf6vvOsg=;
 b=Of7ee6HyAMQzRzpe8TUX0rVvlqeDgNPl5n+Uk7z3DlRasUrP1b51o9YgdWwEEm9d63465bcX9mGFt2a72gq/SGDa4DShu7Ls/oeIB7wZITapvXtBCxXvvaH1QrHw8/oYSO80VM2wKxsVixE1902YSw13ESVIaQXRbhjFkEk68SY1UGnrqWdiFCzuN4oxzBj0ulsNX+BJTNfDgb6TG+HKiUB1pIRD2HDksWsQBkNbJGVMUhFFKnv0+SZkLizwIPcFXJ9S8ku9ZLyEOp+8W8ZB+JNuC8FluVZTgXf9rLU1glKwE2mKQ+SUItqnAeZ2sj9iArlyxLV4WowZMcAEGniYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Iqfo0ZuiSUtOMEsnb66Mx/8miMfli3TOT0vf6vvOsg=;
 b=uUnHQ81AGvaiMPyBmv4ElpMFKHnPKVHFF/txhts4eF0Xo6tWjD4P6Iiz3p/VOVy4LJWmBOcXOABVG+FP71cCh+mgpiOOJjP/MgGp91OumVfbUnU5jhBg6u0tgFfZOPu9KTQqGt+rpnkyijsNxdsPFunY15COBW6teEfdgjpHydo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 13:06:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 13:06:12 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 0/5] libsas cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 25 Jul 2025 10:58:13 +0900")
Organization: Oracle Corporation
Message-ID: <yq1frekpghz.fsf@ca-mkp.ca.oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
Date: Fri, 25 Jul 2025 09:06:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4552:EE_
X-MS-Office365-Filtering-Correlation-Id: 268817b2-1940-44c0-e087-08ddcb7c0777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j8V1/dZ3t1bIPjUpIUOUJhwr/FqPUWXn82A/gwPK+oW0EHKDfmwr2Dq9qCXw?=
 =?us-ascii?Q?PV5EbOu2sfJxt/LSfn8v48Mqkh3DQYShu9dUQ+N0RqPIk1Vp6jj7BYNIp1S0?=
 =?us-ascii?Q?ZYgASdTy79Ak2SNSbROKvu771BkA7l1y2QglQbDkIzTncfIzv8Y79RwmJIig?=
 =?us-ascii?Q?O+Rl+QsrSujaV1m/TJUAlJnA1+AAqF6VEQyJhFaXnatdh8MYS3LnKJ4sKe+F?=
 =?us-ascii?Q?j3sGjwlz0rI0euMB+So8B8Gnej8AAk5CcoCvJ7eHFfFfNFo/RQnBYwF9u33e?=
 =?us-ascii?Q?8Ir71liP+G6N381gFnzDVqvYiJgWVZosN/hKrMqQC07QdnScrlRHcWUC2rdo?=
 =?us-ascii?Q?LTwaL1zAFTRfAjiuG8/KcM4CPueMEXJksM85bfoJfS9Me6Nc13zFLeGd3caN?=
 =?us-ascii?Q?raVUIruIBFnS7YGPlwUShl8zEnluJCdo82/rcw2Jq+Fj+uWqA3JZif0+TwrZ?=
 =?us-ascii?Q?fafHZFoMI7qLuL9uoh8HyEHE6Nar2MPhGsSBsw467F/nGKRDbsEbfOollTP6?=
 =?us-ascii?Q?vz5S9QnzLWj81lDu0hrLdeAfCUno8NtAJS3caOlNBuBCxlIHoUucuhCl377r?=
 =?us-ascii?Q?E39WZzSNBXi5QvvEJyEHOJyydmMvVhaIZNFdM7DFHGvq8c6Z6iKQYCsIt6pg?=
 =?us-ascii?Q?iHss0iK+5KCc3SeOWMz1kyuYT+PKr1SdOZOgMSc1xTgMZLeg79H6+ysfqXGS?=
 =?us-ascii?Q?FrK8NJDdjAYa8oC46dUHnilyvHCZmyvWrGl0ubysuSWTyavj3DpH3hkof1iY?=
 =?us-ascii?Q?vQMWphTJUwOHh4jqrcPOmn3DwFkYF09je2dbkTPJEZYav9DAXms4v0r3rHPd?=
 =?us-ascii?Q?tg8lahDiCTOpOq67x4egbakjOCnsjvcMOQK9H+p7BT7MGwQfaad7gKBJU1Bg?=
 =?us-ascii?Q?EoUpgUxb1N+JaXEzOuBaeEDIPuUeWptWQVXUuP8tPCmtNjHewNoJRQ9IzENG?=
 =?us-ascii?Q?ZsY4bEvCcW/HJgXJl5dyJgjRF75CY3uKxIrRTQltIJDz6RVQVxVdKk4hjhzS?=
 =?us-ascii?Q?JZOvPcBwouwkkWT83/zOms5ldwbOcm5KOjbn1GQdsWC04DMLfMC7MoUfxAxO?=
 =?us-ascii?Q?rekNGB2gLXZjVegY8COK0zgqBrQPllTk9H6JTnhiXtkBtuBSRLbpbeGe7GY9?=
 =?us-ascii?Q?XkFWU6swUUBNjc+NlEsPNHlc5xDdl5156hxaUttzpcC23hOubexTzzMC77eH?=
 =?us-ascii?Q?31kT09BoEnAn0GLsF8g4ocNeUq9r+ZVe7DBiS1zBexZycLHc3DUz2hI1wTo1?=
 =?us-ascii?Q?X80k2KOf1Anm2op8U9bYbMTa1mkvblnm3U6mf2Ra5Je/Vc12tdjOq7eK9z64?=
 =?us-ascii?Q?r7TQiQ+5Zp4iKDVw159DbLLB56vZIuvnNc0eFQeXhjeEEWGmJj+1WfOdIB3q?=
 =?us-ascii?Q?CjFNLJU99u6zkzznIadtX9P7JH0pPifs6z5mXtb2oWcI1n/L43LcniwVVHYR?=
 =?us-ascii?Q?SgxfN9U65wU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XrN4/Nv5w/1QRLOfTp0ki9JRJnC/lRpjNMZIb+1/IPJ13xLs4HFPXM2INXI7?=
 =?us-ascii?Q?yOhrlZXUKI6SntnXJafFPEtOJnNN5dcpvy8cwW4dF8ogslA/ASEivmyV2snA?=
 =?us-ascii?Q?Ci6NNuKWVDyA22fUoAipW217aK3x1BzOKL+wjotni0v4eirHJ0o/ejo+1Nyq?=
 =?us-ascii?Q?PzVyrv30aHlvSnmYiw3p7dBGL/cVhJ1vOr2kHXbA3CbiDglZS56eL5J6KlGB?=
 =?us-ascii?Q?w07G0gdh/hWeJjaIT1ofahNfYN3zLFefJC1OkBm412Dxa2/TJE3WcJQN9+ta?=
 =?us-ascii?Q?4uPoSvXBcWPdQPHtKel4HYwa78OycGbVwZVHP3vfnvXCWy+QdgEWJDav7pCS?=
 =?us-ascii?Q?GYSTUyYkvntouqnImtdl6UqpaSCMqMDuHDAvZbgoF1qzMtfxH+Zcw1kg/cGX?=
 =?us-ascii?Q?VYnz1i+Urghp3By9rsmpmcxYKKFQw3AHnGFLjnDyI5hGAmFe7GCkFtBz8yKl?=
 =?us-ascii?Q?zSGZL41MR0seX2zT+xtHP7BBe42OyOxi7PS3jWUFHfG8JjgHoqRP+HJj29r0?=
 =?us-ascii?Q?+FL2M4LxOaq3L417HgWNAuslip0JW3B8imKK03VytHQe7w7xrP2SZAd523av?=
 =?us-ascii?Q?XOymkcBA/Mn+ci5M7JhJuzcBe+eNiAo5nChtFOlhF3JnN9QRqT+aXytkjtxo?=
 =?us-ascii?Q?sLJKOQNYS6zn2jV4qdaPpZgMRLhfHWHwOqo7BQxAOvl45zoNmmk8wLDTYvcI?=
 =?us-ascii?Q?+2/oILariM5AdEL4VEG3ZcLtotSxtx57+QH5sjb2g7piGp4x+R9PxOer0+6W?=
 =?us-ascii?Q?DgzF2oz3Up6o5qQ0MxR0G5sTNUBZbN52JqO9TiwNnmVD3GVfWzSkRTG+sigf?=
 =?us-ascii?Q?k/kJMNEeJABQMhH0Q/UmH8O057B4BIOI+q7OVHj6JJ6crHMlbNLrM9myitpG?=
 =?us-ascii?Q?BkyKUTycWnBq0KHIqQNyLlDT3jHedMJJRBbaSayRtz9/KFqKe06hu2wOcD58?=
 =?us-ascii?Q?oXEv7+z2Zq4xGuRN1zZGjFCf0pAOsROMFmY2t/JK0htfmoFWD6on2hk4ulng?=
 =?us-ascii?Q?bhgsH5hu0mKs6JrkckSuCjdN7nC/Ba4ePdBFeLu6jrVZyRAohYoQIjYr1lOA?=
 =?us-ascii?Q?hr4wPTFN4Zch7Jt6hyqnlyyzxYNKbC502gGEsc3yo1xb/P8kHJ53I9XUintA?=
 =?us-ascii?Q?b+eJk2vKtxxgOORYj2s8oY1QclRM0w5F1G/vuP5dVjYrFJrDOwvDmBxVcUQk?=
 =?us-ascii?Q?34oomjK/T/t75Sw/TH+cyXrfl1f+OLHs9G55yClG3g23iTiIF149N7CFuTdk?=
 =?us-ascii?Q?3DdL3+NGoHNGxbyJ3n1i33d6iiA2+eFI6IgIXXj+hQOUmduTCpqetJO/1raE?=
 =?us-ascii?Q?Ksj09AgxoOC1ctgzLBmRLsJbjFUq4W2kuxzxXdv4e2K+tj4lULDlsducVzKk?=
 =?us-ascii?Q?Zt45R7O7noF193RGXzgPBPlwbaEzX3NO1Zn7lqwu/u/WFn2I4LDE5/+htG08?=
 =?us-ascii?Q?sIqW9PKZHTI+VxVpBuhnKkOgMfqjCu5Orr36qF/7Ficczio0+i58zE4Y2F3d?=
 =?us-ascii?Q?k59TVC64CzWXuER2tp6WUqTyVb8fbx74lJ5p+6jFInNPFzKN9muFofw1lv9l?=
 =?us-ascii?Q?wEKvU3AKsa3I7ZOu4BT0zHLtLbFTjIyyNWBms6VUrqThnmDaY0c6uWmYdNbZ?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4CM4TOJ2cwqRY4RnyG7hHKXTmK1CWnMmhI+qtDDfzWJms2Xt6v2NogjjXlFoPoJ7RlIbJlpzHIjdO7o7N0zLiHbvdoZR0POwdx/575xnxcjFpMVfmOYoIv9ACfLmcqTCQdtPyGFNkpCrGOOOaoPiRCzBOiGHCBJZvTGZjXiGU6d9p8cdinZdZFQUSnHPVgoJnfM296Q+ryQFyhqSqeCVtVxnr0MG20G0cyyq24ocYVRew2Ll8/JH6IdFjs+tdnczIWEqLUJCbRzCkGyanc60p+IpoV6S1QTh7gv2ZNuj3Ll0xdv9MZ2/CriOc1nqNB9JxiukngTdBqXTL8fDNKd1uOtEN0PmaFRjHU0brD9uJ62fGfKvlzmZwztfaVtvHPp0lO3WwEOBRNPB89tQfmbd6KxsGCvBQO+B0YyjzLt/Z19/rMuob0yc76xJJ4BBj/zNXxq+xT5QqgON83wxvAUoNpk7WYSDwF8XG3dty9Wl6WcUUdpc58ccohxQbQgN6Uxw8N8/BbFNXhcy5CnARGkw2IJ9USKG4CbjiOrDbSV853r73k8M4ah5ZyD487ChZRb907HQyXDwxeRIFTkRZIxJ5CtmLar9q5VtnAVqio5XoF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268817b2-1940-44c0-e087-08ddcb7c0777
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 13:06:11.9987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Sor6O9T9vQRoiQvunOy3RljEoOT3ex3EceXzIU7gF14WgDp15vhyViYy6QsDT6/p23YJJTXYCZ5qRsToEt8WyGg3f9h5927ouQ4u4THr4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=747
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDExMSBTYWx0ZWRfX56p7VOgtJXsX
 Zq6YFm2o1QVpSwllCf053+eSav5DUOdcuM6wU2ISp/PyzDUcYJW083RW1aZ2TZMLehb3nvFLIh9
 wi/yPNQjT8U4Ln6DazsDfAdQ9lRFnXymka30Q+xBjRVryCdn4jYKB9DoB7fGuboCt4ypAtPFP5H
 i/QK0EOeDFGF1yWGikaD5aykEBHUGHlj5wAiQmZTobk2dQzhf4iFakGHBc4/csDBLqKKz4r8Bpa
 gzHwK0lhJRrPUoPmfz67O8IxduDgRIp+HfW8m+d/XS19IgZujjMdFEj0FJ0vZNRasCTZlHz2CIx
 QFLnMjLUMReAavPm6GkDaskDUi+QHn8oJDE3fRPoVw1L5NEgHZnOBQOQGIndQu8z3i/fGORzmqQ
 4Wg6/6lgweBxAAkwEdEQuiO7jvdW/72yXnVhMe7hzvi1PffYQM56NGJi4mUybLNn7xwJz6/m
X-Proofpoint-GUID: 32J1tsr7tOFBEzdjDwmDHbTqcU5Ij3NS
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=68838147 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: 32J1tsr7tOFBEzdjDwmDHbTqcU5Ij3NS


Damien,

> While debugging an issue with the pm8001 driver, I generated these
> cleanup patches. No functional changes overall.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
