Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39823741
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 01:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779501052; cv=fail; b=Rzpr2s2hyerOExBQqNAO8tavYVBp4DX3HvHM0mOn2zDOApOb6TvZIRco6tytDL7tyre63pNrS4ND0BnB595a8gIE0Hp8E0qq00VVp3NE/trHgil0fQOFmkUwSerzAd6bLtYPT1HWydDjBNg5ENfP6RgpgfabXO/38y3yxqZ0nJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779501052; c=relaxed/simple;
	bh=H0z2e5/e0lhUFD1dEQm2lTFdbGkqSpywzezBlDsktrw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=I9SA8bzTa31rlU6ElcWOztkNDQaGpxql8CL0zudjHwXaYsTGgVw93jn+1RchiXtzTNGS4eDS/gCtNmHHkSMp0DuGZTU8KQB1zBXV+B/hIK/97wkqVjUUR/o6+vVZ84L2N6F76ck0JHKiD34T/meLoWQaUqd2Kydldwc36/n7+mE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SZE8cu7B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QstGDvs8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SZE8cu7B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QstGDvs8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MGAor4215874;
	Sat, 23 May 2026 01:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8mjZ0A1FuuD0JEPvDu
	5Frlmb1WMx6JYjJbk3yUKd9Qg=; b=SZE8cu7BrjhXLFJOzo1kuQ8tiopn+z10Oh
	2MZIPX5wwccEP8dJAzUf4AsZPLejV0k8gBvHJUnNS8xAgbNXiBERe74wq+6bAQ1M
	+TuGUj3HhpzhBCREl1z0nVbrctRVf6nzV2FzpevqpZuu30XO82CuRhHioFuMkb4/
	PiihDJhu5E2A5iaL/xI7wN7l8o/nVcPzohYKd2WeoNYhvt9dhmzkcFNOP6EFZR18
	Isk+dMpnlDy2JOzA7WXCMRdkYmcKMYB0NTKKt72lxhyHXwPJRl7hXFK40cKiGjX3
	ML3xL3vcY1NrnjP+qxHECJ6lZUFe57cx2ng0egD2051U9U7xfTPw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t3yw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:50:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N1niVR022231;
	Sat, 23 May 2026 01:50:37 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p5ga1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:50:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGZvBdvqPnxT1QkQZK1RflPjekf7tmuLApTNUD+EPzge0RVtYZt8RmXZY7wHDdNSeHDs+0hGp2BRIT1X50aTlTvSEcYAfHnLNZ3YOa6BnoQCI2lydtfpHbYplY3ltctwwzADOAMiD0NfQe3ZsoBcVXVA80W44/VFuaqfJYsi1PVfxr/mnATdnYWSkleCJjf1GSmaQowx0DPmyPvOVUFsT14wI/U0MOHgxFWbsJtXmF4tQKZlghg2B4LobgI3Lb5IJ3ARrJO9kngYuybwvta15cfbwm+x8sK0kf1LO/nCt4U3lw9XC+wdGOGS7DNxHffPhloNeXVwOLj5U9nKtAOX0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mjZ0A1FuuD0JEPvDu5Frlmb1WMx6JYjJbk3yUKd9Qg=;
 b=G7/2rpw/bYS+bGsemZzm7J/6/E8Us9J3nwkUOsV4QwdHzKQoACZVSghegv7ZkhhtcInCBgKnMxA0q+tEmh8MF2YWmFlisjFF3U471BXLWXNeBIirq0V5cG+lrYQk4ZPvUV2185HrguhZvelmQvONX99+ky15gg7kXn17ZS0uLGhu3JSoN9Q/oU79sO6MJMxG0KYkapVWqQymUHeE+PHAIwEAPq9gQqI6+2R6tUJkswbgqYGWfLuWO7V/Y9ZhswKQYsO7YmtnDWyKAB34Cl1MbCbULAjTq33cNdi+03TX6tScW1lXXY9IsQvYQeJ7V35FGDqBF+z+EBz9BiKw4GJPGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mjZ0A1FuuD0JEPvDu5Frlmb1WMx6JYjJbk3yUKd9Qg=;
 b=QstGDvs8Dw/uGVW4wEKfMf5CAQ98RkHgnqNsXp5m4Ku8NSGSvBvjVjPcOSSLE21XL8zB8vBUEbLAUJTEfJhyo/Zs7g1BzLI2WtUekOquRi1ZUYAJzA1Fj9uFxyabJFx84RluUM9QPMpeFlaGJ6uZpC3vXP85weqVRoT8YfZ+tHg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPFA7DBF91DC.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:50:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:50:32 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 0/3] Rework the struct scsi_device inquiry information
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260515205222.1754621-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 15 May 2026 13:52:18 -0700")
Organization: Oracle Corporation
Message-ID: <yq1se7igahu.fsf@ca-mkp.ca.oracle.com>
References: <20260515205222.1754621-1-bvanassche@acm.org>
Date: Fri, 22 May 2026 21:50:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPFA7DBF91DC:EE_
X-MS-Office365-Filtering-Correlation-Id: b1e0eea4-8713-4596-eaf1-08deb86dacf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	lQSBgnFZ5sgsH7KHOUYmmeL+nuPHo9MGpu9+OsEGM/pHEMbh9UFeiYYYTf9g7yoCYnoG2MfYPF+j0TKqRoVGxCy4YMCPl0ILDhJrUrmij6mRf0VDTjM3ns4t2b21hkQU4QJa06u2ADSqzrd3ABytpzV45nPu5lYnzQawxNamJLMtsMU8v2vUQ1hMgo4IXP8/kIvx3pOtaE4c1RXL1TGWAjvcCAA3WzupLu6EnfdEV1+FnMmT2dBRHKRiD0FtiBA6lcuoAHi3kL4xHfxNy7Br2jPQuBiMjpOKJhLl0YSv3dLFN0zkJ9Z7ky/ERFhZXvoilsfrpidkqL95ua5VLQy4gXaJ29kPGmRl7y/bdN69FbplqdnAFQKcAxR5NHaSAyDzDvFk0L9tFyYrEA05qfyv/bJPFej7aoJTzAExQPt4x9JZEK4MQaZCggrWEPUwPDhEKvwJNB07RQVwW/vHdrDByQo7grAqp9d7T9HBiZZnTlBsK6Lh60zBxcszBubTrwcBmp9FL16iZmQAWbskFkX1/xcznBR4W9KT6DsDTH8LTgQjQLgNgdIv+K5RXvHtJHSY5ivgRdS0YQBxJ2YXajKqkVPrDT6tzi4NScf1ri6j90rNnMqn9SoijuBrsiG1DRUKU0xiUkgHF/6Yy31Ex1gWPSMWEoLsTeE/x83ke0ZqMcL15nknL85tZ4YnZwNHv/Y2oReICiWRq5U2JBBtb5wJZ18gdmnGTPBqkcLlfyzCKjiXiqY9BUDSbVCLCosUwIDr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MUHLJ9+SvXTvHaZGFgAEXgY1mkvYZkuNUtd1OU2aXcH5Cdr208k2dHNFfdLL?=
 =?us-ascii?Q?Y+cLPD8G7y7MWwzrwZCDi96B6pEcU8pM7DTlGoZPGFZ+pHerQK8s1IA/Hx6r?=
 =?us-ascii?Q?zzjmsLuOqts1BpHDRUNg8uNmCAwHW238gEnJq2aOJgN3ikv90HcdDpbq/ds/?=
 =?us-ascii?Q?5CGiWXFFIQ8nQyDZbMDI/gpAmxY25Frl9eznGvbvw2suOGUA+w+YkireJ4l7?=
 =?us-ascii?Q?90BtdfWA9nC65SEJ9hVECuutWxPPT0AD5THcRTuPuIi3n1O1vH5cFTBVEHTG?=
 =?us-ascii?Q?Hbk4nS3UB5FMeach/+sy3qfoXwsG4B0tcPT5VtY7OV+1gTypnMR0HfbawLD0?=
 =?us-ascii?Q?VddihL4PxX+EdgurU6alvC6DyWUzAj4sXfuoaZ0TzJvZHiEMQCg4IN97LWs2?=
 =?us-ascii?Q?iOm8962cyH+/QR7fah38hsA0A+NJDdAhQPKgB1D6Rq8VDb434dlnNEcJQkxg?=
 =?us-ascii?Q?Gz9Jely7Zx9jmyrfNgMV1J0gPsf53BC+ktaC8ELsqw1s+3/k02iYl1aoNrs5?=
 =?us-ascii?Q?WKEgT8vou1hrhPkJ/ZGvtR9vFnmy1EhrTIgyrc/gMdiIwJtlbcA8rTd0AmP1?=
 =?us-ascii?Q?2B5PKYkFxwLPXu2rbIjTAkHCNghUrhy+zTvVkPu8ArGSDA6pK3vzBKixW6A0?=
 =?us-ascii?Q?bNlfcZ3GO1B+3bFG3l72ksyUBg5XTDEW3FpavnxyPXbTfBCo4A9F9iqxR2Ko?=
 =?us-ascii?Q?78Z773DWCbEEJWvPJsVENJWiSDprOCPCzeoUCkYHxnM3BZ4tHEH1IafwXETc?=
 =?us-ascii?Q?ax7+LjjfxH86yIQOUNkH+r7W3ZDTRPbms8YufItLemdnPNzoEkngejH1ORyq?=
 =?us-ascii?Q?IeOiFDP7fjZY54/60XbRFRRtkXF/Jmv54GRS/V/IZQM2RdOGxvwFpe7QVkDl?=
 =?us-ascii?Q?4GspxKtXeToQdxVGmfgCuBb6dhmdf5cIG5O9k4PNFw28vGFXzuIIwCO0S2UK?=
 =?us-ascii?Q?4WoONtgn+Sj+Wrn5nJzbW3Qg1Wt1j5cs2oLEevGUBH+CB89z571jzZNwp9fK?=
 =?us-ascii?Q?MQvDNdysTQtzAOHr7N1PlDcUuxZeizKZCEEeyUZJlTQSCjLAa2bcEiroFtzF?=
 =?us-ascii?Q?3AVm270b5rqcqZ/3KFD6JlYLH24GQ4Y+THIMNyx/iV1y/L5kLinqhXKMMeAB?=
 =?us-ascii?Q?jbaSkRyONUORb+T7ejioMrbdYTyqw3gRMMaTaXn70rKptWlXu4wcKo9BP/lE?=
 =?us-ascii?Q?d88GEhnhfdeYmQPGPwiMHjUSvt5T388UuzdAIPgtEdjL5LhIWaxNQ8+5NGhf?=
 =?us-ascii?Q?Ex8UkR3wO3yGP0mvG9stchcD3bSxOqIWJoPRGfFYlB+ZoB0+IaI+Z5vN/NS1?=
 =?us-ascii?Q?D/pHgCcSfvykaFCZzv9vS36O3tBxfrhu6OXcP3cOhURk8GoWtGiVX11hzKlS?=
 =?us-ascii?Q?gWTwBi+2GC7Qr5Nef0JYTL0Y9UHe9xPPAJo5A+87lNdSD0xCPJ5fLiM/lh49?=
 =?us-ascii?Q?soHBkbTXDyRE94OkG7PdgfhwuRIh+1AtEFWaEYfGyYgyRJCPmGcW/P12vjSK?=
 =?us-ascii?Q?ATkyLh7GafQMFoqVrOTIlbYLUZuuSlYY0DBcGmsSdg1gqHgLay4nPWDTln9A?=
 =?us-ascii?Q?1yUAGIsCckVmP+SUmrnCIpRWsHS2KtzOeEABut7T9T+DwkC2M6apIctWFsDH?=
 =?us-ascii?Q?va9uU8YtahMq7lG+m3Syz8pGvpiT1MUSmKkR8hIjYbp0Y2yGjAWtgEI4X95F?=
 =?us-ascii?Q?32sW+/63I7cT70AR4c+DELRSt8CG11J310TyQipkgY+X/Hsr33XJgDsLoVWt?=
 =?us-ascii?Q?E8STUejwZfVcgC7NWAgpzNKEAvZ69Po=3D?=
X-Exchange-RoutingPolicyChecked:
	h+MsC27I81wm23uYlpkAsGhxnI6tiYm5HctgwuU0qjw/aXXJbqMn7Q55LaMCSn7NkLA1sbqMs6Gb0HILHfDrFcgW4x9TGjWSzgbTJklqfhCpre8zQD4EYpJ42ojNU+HsLDp7cYgrFjr0nJD6bQG1FZ8c8NDHG1wIFO3PSDIxht8qe66FXoV0NXnkmxJf4hJ1rzK1MAPej6iTZMBegMIidKBy+H9NyTDKXTvoL7Z+hJ7ldhyKk1FH66vaKtPks7I+a3HwVwOG+dE1xFDP5k19n44zDZNUbxkJ+YREgSYpeilib0T3chtK9hdMkdDO4xpoy1zVykTSmuZI8gbBbgvILA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i4nRKJma+3v2e0ClJq0cyn9LSYNTHoxVQD/rwMqVxrL07wVs20xTy3TtXk4yp7eeU0ckeXCI5SvckuUGWi1+czuNLNNmBflPcAxPVLNpsyLD5QCfDTsBrEhwjIOBy5JjwTAbDYtwkGre9s+kW6PiV0zu+kidxoPuAiKpdcsQIP+vpDUYPCgqU6OmxBWXDyGxtDSAwRIUuyJ5mcEu53X070S9EY8L/yQWCQQvF0My3d248Zp4fWix21j1s/NSFXOcPJFOgSpxYwtLJdsJgi622eVY3+clFTfUJXZLDlkUlC9anBN29Qh6gVDR8SLTg90RWv1tqwvFhCZhAC/UsaD7xMBHndNs5GhjV+ltMtz0i3526eGvfRPBLuiQf5V7Ln3jqjBuxSuZJZ8otLP4sApum4hcHdfqokk4U8KavDWQWeJSfskXuELMUt8E9l/yN7QWcbRetUUz/rm/Gh13Tql+qKDtgZaOoJ857SS1VqFlGIssziU1Tx0FgC7tZnhJnNnDH22c6AOzGTObtreXu7LUUCZpOGLJhwZCo1fdQaXV7AIicUvj3kQHkQ48UAg5ic+LKb2H0hpIguaxJTByIWm0xd3twWOH2Ldo2nz6f9ufG1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e0eea4-8713-4596-eaf1-08deb86dacf7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:50:32.8241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1AlVwGwt1GMZa/L8A6DWG/bU336vbFLUTzS0eFX76ybjfowFuk6ftz4Wu+TatdjtTeI2ncznDalfln4MQzk4fkMNXdEvAjDq3wiiOjWpf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7DBF91DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605230016
X-Proofpoint-ORIG-GUID: 59kpP1gwHGP9x_0vsiHUZ0kX1AeI3Vd0
X-Authority-Analysis: v=2.4 cv=aoKCzyZV c=1 sm=1 tr=0 ts=6a1107ee b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=X3SM8jDDoWpPUcvSxwYA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13835
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAxNSBTYWx0ZWRfX6gnEeOKcY72V
 kOx3XGnYb3AHKP4US6neniIq2J3py90OkG5TiNFOcjldiUGdd4zN5ydH9TsUoVPhQfKRaRhf7IB
 2EYYnU4NtTVI0IGEwDbkitVbDpYeOyQHrbS4Lp/JYKGo4o9H1zBxNRmXCKAcE77ItXVsTF8xI0L
 rHje0ZIGIlRDHZpZJDyIWZCJNTY0HMptsJVvUhmRjh+OE3TRASFMS+AGaKpwWod3wyZBEorE8QH
 ItIX49X2OmDxIpc84iKWsi1cQdvXaEF1ZjmkN/wp6t4UWAsv86cOk+gN9XcHr623wkWdfLFhIy2
 pGo4OAjbeagv5K7S67EM7x0aeMpjvj17Nv/Syk9Fl71aCpV375Oezbb2KIhZ4sfYvGWgEfrD1Ad
 +psaAwop5VrBMDBkubBF6QYlN0i6OBtjPS/VF0mlO/iMmXDqhHjUZhEAbYJs/t9F3mBusX3lGGY
 ygzo9ETMgLqCuCaBO/9Pm7IeYdoKtReLlrTaPBA4=
X-Proofpoint-GUID: 59kpP1gwHGP9x_0vsiHUZ0kX1AeI3Vd0


Bart,

> The vendor, model and rev members in struct scsi_device are
> fixed-length strings that are not NUL-terminated. This patch converts
> these members into NUL-terminated character arrays. This makes it less
> error-prone to deal with these structure members. The patches in this
> series have been implemented such that the number of lines changed and
> the risk for regressions is minimized.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
