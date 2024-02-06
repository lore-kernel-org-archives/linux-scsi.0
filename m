Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1272056754
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2024 01:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707184438; cv=fail; b=AD65rWU7NwiprcoqM1cVhXqh9wuvPLpTjedoTXkjBK4ryoedbw5hZTHVE15QjITbU5gqn4GnDZ2GhlivuUTdTe2E5o05S7yYiTlvWjJIuXVO30+lrig9NfWHtf3pxGwgDeiWj6s8OcVpm1Lrk4UF51sLBObHR/2knO6bCUxulY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707184438; c=relaxed/simple;
	bh=O3jiQwP0OFK7F8V1DaqVB2uYeFgP8GgslwdhitFYfwg=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=IJ6alHlTa+a3tdxYKB6ZXcxcG6ssf252//UfKF4vfc09wnA97fZ/ut+FJy6345flImRRZf0qF7IhnZf3Qzr860+3V/5FNGQkimGz6lSQJA9ceATm5E7OHm+xEVz2oqYRR3mn/LKtfutuOfr9tB4WBuFGY7ZJoIKdS9Dgrwbb/Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MF3Izu6l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CvDJfOla; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MF3Izu6l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CvDJfOla"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161EvvL032169;
	Tue, 6 Feb 2024 01:53:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=DSSSuqRflSDdeGdDjD2HbVVTpj3vwa/Bmrz020klSWc=;
 b=MF3Izu6lQWs/1DVJAwoWPXQncocw02cQsS+Jy0hQoPHDg0T9kZ7gFwRneLCn8zTz2Ta3
 MOJpXG47c0gTmqEq6biapaUbN7kWH5IzMlc0zHyKDexbnJB4ZSqq6ARokowxu6JMb8sS
 Z2Q6PmobxsDttwcp99ehXvv4V1fNFAqHfU894yohsq+oUHF9Z62UU3jwRRN5Q78Oyc4s
 ny6psNh4/q6K9miOO2EPJ5mqYbxjWAD/NJLcpuDdQFFzSZPIec3P6EEgMNj1WDTDUsRs
 HMQszbgt/5lUuG/00rCN1NCnsqgNdk2e92WoWKnWGHfmmK3rW4rkxW6dPfNfFFI13DoM hQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbdejn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 01:53:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415NVdmG038394;
	Tue, 6 Feb 2024 01:53:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6ctcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 01:53:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVwZmDGtt6sWW7gZj8SHih+SXMqgopLCxQrIFy0UMiYq8/SC7hOLZCvc2acQ/tn0CKey+S4DkDb8l5pDQFIgHvjFyE9p8KyvDZ58zF80UmlmbZ4hWMZRCHRpSL8c79LI5rq/yxhsFl6KlL1TmyeEpGSdYMlrHIHCUvkvs6ts6F1U2V84jX8wV/EsLYJ5+FHaxTBhAhIZN2haqEBwbiBg1pHpR2t13Bw//CqkADGo284rmK8TFDD7dCFejIiXj4GmXdfbo1eb/bi6Ig+BpxcKOt+gUQ763kTGdC04vsUOxfzr4oUr/CWVIm6I4cuNmonOX1YAx5KMLjpNkkwLADmu1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSSSuqRflSDdeGdDjD2HbVVTpj3vwa/Bmrz020klSWc=;
 b=OKHOk7tOv85W9SwPMEHwXcUuHOEzkE8s4q3ff7RDbFspBhh5e89IT2L4DTzeBy2W/JUUSrnHpISFZOTJoqn8tYQPWnrWifP8ysTpNRdcf2zUbrk/qpjasBmCMYC2oUFPEbPnDqs4lXA/1jmnSAdKd9lbRXyrCUX8oPcbPdF2kr6GjJAxeGk2+17UmOn5EprjQHbhcByPD4mhTZwM3rjzWclns0pMCRa6QJBtNcXZPOWtLigxghzdcLMdklTTKUUDmbjYcts1iUOuoMivceiHy6CM05yzqR/y34U7io1vq8QX54Xu5uA1fj9bJqLXo2h3ZC37iwxOF93z862p8wRVhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSSSuqRflSDdeGdDjD2HbVVTpj3vwa/Bmrz020klSWc=;
 b=CvDJfOla/MOucEgkZ24WqkQFY7+rbqH46QWDdGADXUvdPzDerwDJk+0THjOM4r7yxhtIxdqUKODMVLGavxKVQND0/BFxfG76X1IjmM8MRFNEMHVHdezIuRcvbUPXRvvX6K57Rb7KwvMjNdwLILZU5nw9+Z2aEZld/fYbf9WHM7g=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7406.namprd10.prod.outlook.com (2603:10b6:8:158::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Tue, 6 Feb
 2024 01:53:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 01:53:50 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com,
        himanshu.madhani@oracle.com
Subject: Re: [PATCH v2 00/17] Update lpfc to revision 14.4.0.0
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15xz2pdcv.fsf@ca-mkp.ca.oracle.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Date: Mon, 05 Feb 2024 20:53:48 -0500
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com> (Justin Tee's
	message of "Wed, 31 Jan 2024 10:50:55 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7406:EE_
X-MS-Office365-Filtering-Correlation-Id: abf3382f-b175-4cdf-c53b-08dc26b6773f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rrTiHUAUFW+AXFneVKGd6AfZQcUQJ7QqBIF7StTjqFrT8BxHup5PU+2kjSeWFwbjN7d3CPyD50S+wNviWcpl/2E/0sgpCnRIJSsD7KS1+tsqgI1vuepQ/601p/JI3fVM/W3/S1E9s+eZHGdRyPX6a2qB6M2gXC3Tw2QieUeX9iKZ13yJHxvjhCh+bLXVEwB0D3PdwOmwlD/+NAzDgFLwMOqDyFR3MOAmEZEKVFtKjYz5cWlCaS9QSX3YRIOn+DdGyf3Dh3HN2AP5qf6IvfqhWqmN+qeUoaB9DfySaKCAR+XuVd8JZD5ZesUnplSq4WO0RE+Rmh/Rv2oaReAQzvwA6uFSD7MTg6rsP8ZkQrNHnNiCyJvK4yIOUlpxtABTEfWV7o1mGFI8+D4wlb/6QsQgVuocqWUA2lKYDKi3E3gdxvmqK6CY0PJlpJl3G1/ddWFwtqgX0n3ThrsrLv+kWmcaNjGIWoDZujDG2+RXEXYarYa/mSFJzTxiXYz7LrjCGWy84UmtHJTif2qmW5Kjidy++mPszRHqEpJ0uGQlyar2QE9YL8+QqGAC7Yt6TDsJ2nPL
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(39860400002)(396003)(136003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(4744005)(15650500001)(5660300002)(2906002)(41300700001)(86362001)(26005)(38100700002)(83380400001)(107886003)(6512007)(36916002)(6916009)(8676002)(478600001)(66476007)(66946007)(6486002)(316002)(4326008)(6506007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?m6KLIaBtvePmDVT/eyR2aUxz3kTVQaosxlT5Json1iyQA5UKtLq0VGA5xhm3?=
 =?us-ascii?Q?+eKrzRYTdgSYRsZOPUmin3Uhp54Ia8ao1SFRl88xoCIL6g1mpLfifZH+90gS?=
 =?us-ascii?Q?EFGBIjm7BU3bkSmo4W9clXjBs/CcfhZ69E8/5pze6NDB5a/uvHHe2890LRQq?=
 =?us-ascii?Q?Epgmofpff39UBEuJAXjEmZD11PE8thaH5VuNZq5wYoTzsz/4PmlHX0PQ9PKH?=
 =?us-ascii?Q?n0Z4KCOpzALY7svGphvkQaZcSkVzNUcyK8WlwL7QD/o2JbJz5Vp7w0EXCG4z?=
 =?us-ascii?Q?Mbc+P7AgWYCcpYCwJvk9jC7cEcBzGNYTMgR4o1EInddl4vo5W6VRGnepVh9e?=
 =?us-ascii?Q?Pppz4X8cIag/pw+bSGi/4bKGVWiHotSbJT/r0rCrwRiaWR8ENxRBhOz6EhCV?=
 =?us-ascii?Q?1oEJSojWOY3MRvRr29Xu3Za5gMibIYgykuD6qVkyvI8KVxw4pXXbkVKSv5PP?=
 =?us-ascii?Q?X7eUrvKBC8jiLuD/v2u+LvXhQ9vdGsaEJmG36a9WS1CXYO5D3qm6JOzYbmIS?=
 =?us-ascii?Q?ginVoI14Eg/nu/Tet3dCqY3rL94OEc6nSPGO4R/5C4COifD8N5d9b5Wet0O0?=
 =?us-ascii?Q?yKMDZKppuWjnkjRf06fQBFxOtKkQTm0QXaaq0/gKEDRja0aEceEzW3COJoBH?=
 =?us-ascii?Q?w4+dmJmW1W8q4EdeoCOf3+NXB2RoOsPSeJLaPIrSkBF12kPlQJzX5Sa0Vu6f?=
 =?us-ascii?Q?vDJ/ZLFOA2y+nsq/TamB2lCizWk9kFl1ekNzE4HooRzJ+vhNwdY8XQii0ziU?=
 =?us-ascii?Q?W/9ZiHBlATuNpdmGuazGDfAwjd6WfExrBZQublCZ2pSRd+k4rrCMXEHKxrpW?=
 =?us-ascii?Q?4JQ0n8rkJGXWfdYxHH3BskFsiO03y+jIxhWlEUAUr+bm6/3TukOqEavtHJq+?=
 =?us-ascii?Q?RaSIseAIk5Ny2al/b5g/PA8+6htr/4Nzm9B7zQCon6Wdwe+aTL2+IeXk3gI2?=
 =?us-ascii?Q?T1sez3YFZz7mMBsj+n+O/C+9T9acdgiBdWCskbAnSvyjcAwXaqUd9C26itok?=
 =?us-ascii?Q?g4oAhIwc+TAk4y0QKxx444qiWjoB68ddKBBbUK8IIE6l8O4G7fuRbxsf5mxT?=
 =?us-ascii?Q?ZDwuZGIF+myclc46j2Zrr92Ds5NNdCStwWXNESZ0SckRkc50UXy8aZ8xAjEi?=
 =?us-ascii?Q?rHhlxXiNjO4QsOeTAI+H5u8WhS9Djg/uZMCNhQQN8bvEF5ErIQqgThfYDOAT?=
 =?us-ascii?Q?DmWe5vZhZTnKwm+BFbTDTUh+r6moM2W6vDl2orxX6LelglDscdAg1TZ/mhte?=
 =?us-ascii?Q?kmAzUFFah/CCC1KkJIzSH+kxZzx/lOvW0CQ959SBEyuqhQlF4K5BEIWvsph+?=
 =?us-ascii?Q?fwm66IG2TFSqdZfwKv9q6FMgNCT+zFOMTqypIdxlWrF9rdkZSSCtYWeY6GOq?=
 =?us-ascii?Q?e7SFJFJUrcEiHDlL2Xz2WS2ZSVtqto34GfGG4EwZB1G5Lm35iu/anHP78VMa?=
 =?us-ascii?Q?/y76U15pDZTPvCZbZidgzNJB6X3hVVvfPWIKCPYucSWf618jHUjhTehWnLY0?=
 =?us-ascii?Q?iawVe0ps6sCpgYr7GYjjC0uJQYKPX+Dtb5RCb/iwN54F26KyRB/o1/rd3zmp?=
 =?us-ascii?Q?GiP47BkhvWnaCKov1upT3/LxPyiLI6x5uyhmBGCpex10m6NGRBcqlSYG2qgi?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ytDWIluTgCttmb80V98vTDtizhUKNXwZSWB/4eFM5B4vsPuVfnJGyU3lmUSeCwQbowBppRkubA1sFPQbYlt2LRN644xn30rx/xo1PX03tqb6ufoA0p4skO04RVmV8Od+mnZdfSsP9FrAibvX8KEb6aN5ACsaZy0hM3NWQby8zXGmUpxeIp1HBLrRvBTbtfnQjVB8ZFFhsnQ1G5/g4PUYVPKzTuS9gnYM8OTI+1lbWdzQo81t5WRM2IuvKhd9pEHvs7RyRECCdpFTgSk5zZ+VumlM55y0+kMIo2kTz+7e4QuhnY2RsyKySNwEBXV/xKWZcwA0jZEytj1yG/cXuI3WvoHL2WO16lnWjatSxCTbjglcu6iJjnha1iAgjav0VDKNSGKP1yjKtLRyRNJt9XJ3vE7amPz+Ewl15lpZnKfg7JP7Oxc92ctNmaIEdIhhjS5v7KONjCRDL0eaTtXDI5BZ3Lo9+4dHku5wTMIgCm52OWIylQ5MYporL1G/RJN/pX9g442yCezm1wTerJ1JbCf8JaZj8VNoKhDtURpjPIbGbwwcOxLIPAV/Ksn2os8hVFsP55B+Wjrxv7Plwb8Q7lmiVuZzNMGxvS60BA/x3R1Y+7M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf3382f-b175-4cdf-c53b-08dc26b6773f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 01:53:50.7272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3RmLv77d5hwqRoYMIRgDq/gVz01rsizx5Tn1vPg7z6EJdouqk0cbsyPPq2H2o2XVve62ers2E+MAuz8ng8uNlp2ARfY/cl7DOCQgKoXWx84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_18,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=500 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060012
X-Proofpoint-GUID: w8boRiUPlQbvF3towdqaGaIEGIVScmu9
X-Proofpoint-ORIG-GUID: w8boRiUPlQbvF3towdqaGaIEGIVScmu9


Justin,

> Update lpfc to revision 14.4.0.0
>
> This patch set contains fixes identified by static code analyzers, updates
> to log messaging, bug fixes related to discovery and congestion management,
> and clean up patches regarding the abuse of shost lock in the driver.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
