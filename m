Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3D439ACB
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710111619; cv=fail; b=eF4B///mqXBD/aSox2+rTh4r3uUElLW6p/jwRehDvh+Oimdc1bksh83sFFAbKlG/HehxLTmGYem8AS3SRVF+iWmmUL4YDuygd/CEYaA+R7P1WlcPUM0+3+946JcRGU78zKWIhXTdDulFXaHqP871P1UCh2T0dpgdAhyQxvjpRBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710111619; c=relaxed/simple;
	bh=2ZN/Oo2sAMRvoIhmxgpVVpVVdRQiagItQj9fz1OflB0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bCwzoeLTLFQkgL+cLswFIAL3ixFNYtmR9CafT3GChbNVXJGR4mz8iqSGdOQqSIvlV+EDwL3xuxWx7b6jaRzQ80Y+l3ZTqamKuiuYMj4yZ/rCq+py8Hu6S1F0NLlSCjj+5mLZrOkkm/un8JeKrLpd8XP3tG4rsfRuAnELyjrSz6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GGqZJw4V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tP+tJr2U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GGqZJw4V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tP+tJr2U"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42AKktKw014943;
	Sun, 10 Mar 2024 23:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=KTc+skWzERVwQwl9B36VIHrxkmL0lYs4a1c9QfoTkNQ=;
 b=GGqZJw4VvhD67zNoMEcjPBIBfpEKwOGVEZfOR6CH+uIDFuN2DrdETEMsshKLjNnPsh/t
 FgnNtVaybhyFhRqk+QWo2gbyEY1NyFbWymnUOBS+CYAF466HTjxQ5aJ0Z8iTfriTaTxi
 wOGUBdeM9qRjVIUlXloeMc8f0q64g3XqsCQMZH/4JDup6aXyF4hKU7fFoJL6PM5wDA6D
 bMSzBEt3XOcQloJ++jb/+EArVoVKZOw5v4BH8Wmnulng4YtP+CuxW3qsrIqS4WiiVTIz
 dXWJ87OxK620xONPDIMTtizybJOk0RVGv5v6E3GJhdUHKr0wgnTqj8JmKc627IkkUDEd Rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfnbhsy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 23:00:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42AK0eCJ038020;
	Sun, 10 Mar 2024 23:00:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7b7sxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 23:00:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2nb6BWtdX9kIzpYbQiDoZ82prjwQqncF4L7aDVkSRaTZVAcccQB7cHqGg3SpdQFbtRBvGGJuQVlMFnahl2caQr6QROzeQu1TOpKxfsLYKuchN5uDXFSwW7P5z7hU/eKzlKMnhRFGpJe2XfYZi+7phyRjvXgW1jkhtKPDDkAWOfUI629l6yd9m4n3DeRoV0pW1x7imGkzUes1Z+/3ykWmIvN01+CQ5q30eCsbr4i+A5vJNDjUUOROtQDT3lQr75Mz6XOLaIsBfojWrG7ZyXRXDa+EyEh5/4kA8LpfdWlHWJo4dQzvGMhEXXdvWF5q7gRNEv38G3a3LHah2et1SFtZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTc+skWzERVwQwl9B36VIHrxkmL0lYs4a1c9QfoTkNQ=;
 b=OX25raX/A4C79SyJkQlzlu94AsaEmZm8CTqmpXymF/opPbl3XkTrDDK0WRJPleFVNLuvZCBWbJkQG6k5CtgbEDgv52LfGo+LVRC+tymbsZRMh4NX7NrlVEj5rzVv/YFvy/q6tR3YmkstcuJPoNs+s8KeiGQWoK29XwRktmxvehxU1fmsa/1cEempQuzR3byQq5mqUnZ0gkIqxhNtEFdTVE7ZMBhfqBjFBf8A8/Xqh7+u3JiNkzVvzz8NItJFTvT0A73PGfCGnalHKfCkVtq/zRWCU2ewyT8ipn/lkMnjKFngBKpAM+zL1Wn5zCafiyWtWLshdRCeEapgVqRk7BNNcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTc+skWzERVwQwl9B36VIHrxkmL0lYs4a1c9QfoTkNQ=;
 b=tP+tJr2UiBlcKFypvsio9zACvumWkD+Yseol0mTSkn64eBTveGhjM/BdmapxkQKX+8gbY0FcumGMa93yF+6SJNxQK8Z48pH+P4yuuvwaqDLx+n9/DC+ln6qWq6Qf1stdTjsR1S8MYoGD6kGvCqTISEw3hcl1y/g6lY1+Z5ttlnY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4420.namprd10.prod.outlook.com (2603:10b6:303:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.28; Sun, 10 Mar
 2024 23:00:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7362.031; Sun, 10 Mar 2024
 23:00:07 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/12] Update lpfc to revision 14.4.0.1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com> (Justin Tee's
	message of "Tue, 5 Mar 2024 12:04:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq134sxd76c.fsf@ca-mkp.ca.oracle.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Date: Sun, 10 Mar 2024 19:00:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:208:23c::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4420:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1853b5-eb87-40bc-2194-08dc4155d473
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AAhqFZklsaejMsVuEEC3FyJRUrXzmH56FVvdlV1zn18kMjCqCm+5jKff8uIoTjwaYSC5O3KDrOD5SyNUFiNO8r/HEg8jbarAgtShCdueyi3hppGOVMchncUSQ2kjro91r7OFdRytQPU4jIv5A8boqW3W+6Fn9DkaED8Ud0dONg5QFL46zVwTV8inoxXDkA/JbD3J0Xc6yhaev5u1w4Xo6K5Zd+T7v/k7NBvYQTmd7YS1I+GVuShu6G5Li1VpvSu9owOVfi+OIQGxDWhzLZals6//9xVfcJNakiOdBNu8NC3HZ5d5BXwPXPck0U4msGRwwba5WPomzZYoqKyxDduQj1DMp7Os7mqdy08IWTuOq38vU2YP3K9DoesRaxxinTnGFVxqeMesvZTlFGRgJjGOnKu9HAtflTac2cQJM9vHtDVBTR9CN2/qSLCxOASyBg+vDb6tMNbab6nrfTbsqsSXSHaFF2IU9jJJ474qJI/RbG7qkHJYCzfiAFcdJR8RQNiSHfn32x+avPum/+3R1aae5c/UqEQwXfirdJUVyyXAOIOJyQURLFY0iUugfvs2PMAT/q7wInIIvohNiA5IFHzhG4HqBXxb2pAarVf5TrhXZoFIO0i33Bt0UuUxvQTIOQWudW6phPg60kKENEJ3pkjA4byhdMC5L4/hjDexsg7TTuQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?17RvrUY4cgGifnK82dS/VruUlFJLQb8wnDHDhBcQBXXGtaYLCx3hh3C4z1WV?=
 =?us-ascii?Q?zzsZdwW6Krk19I6J3khe2gJIOj71IH79trPIOr1U36b1gEPYEsssg/0gHxpz?=
 =?us-ascii?Q?nnEFVRtcZwz/JPOnfU+WUB5I7ThJk9DCjRh/QmRHgfzMbzHFiKJutaJQwOlm?=
 =?us-ascii?Q?tvhNys7vPYrA1oGsIZswQHCIwxcBZ2s6j52TQwEK5FoIMZc85ZsPHMLyhYWR?=
 =?us-ascii?Q?2CKC9IjsC1fednUwz82QWQqYN7dddBnRh2kcfOIPbU3b+1GiEzEavBIdJLfy?=
 =?us-ascii?Q?Pu2+UQChchzub48A44BT/YJiLLhZxzlr8dCfs1XV4nwQuQBXJVi6G2pqv2JA?=
 =?us-ascii?Q?MVKJpy6sZT348N818c8gdbn46JBl+I/xKG2TJ73LvWcDIx1LS6p23FLRT1gE?=
 =?us-ascii?Q?Yo/2ybp1HueShchhtCHgPD2WFGv7w+Dgoo+Opf7V+OQYG/q/FepoCzZaHzWb?=
 =?us-ascii?Q?W0zaAjFKBfRpim4m0wWVFeA0D2Kury7U4b6U3fVGp/CmHYyrpghKuTouOLd4?=
 =?us-ascii?Q?+IdCLWMpV8PRUZBJ4yjc14H5U5ZRxoEYk355OD/HyUhwhsLFj8BCz5Al2R+C?=
 =?us-ascii?Q?v81v30I6LIKIsUxjHOfc1szRIDo8/lZ9iZC5AoV8wMohfcHpUYdOFMmVGCiD?=
 =?us-ascii?Q?imUWTqRsyN3ir0cl57iw8Ks+rOE/0SKQu9nw+XvLqkEfpjGtIt6UpLTnJVMv?=
 =?us-ascii?Q?PaT0wgDNnBq+MvL11/ERE6pzagDwIfb3FJb02/aeSU9SMJ07/5+pbovD16C7?=
 =?us-ascii?Q?fZgLKRUSMJ7ax0MtRkvnBhTTg8yboMpMSaKDhYqhBDsj5XtlInAuNHA0kAtZ?=
 =?us-ascii?Q?XhSZAkW35zVanVsGl5p9eI/q5yTpy8VnImLiR8U9T5N0P+YY7WQxVovEYEZ5?=
 =?us-ascii?Q?6hGZOBeTYGxW8lsd0y+ESE/bi84toiv1GsrSC/9JV4WmIPMhYRX0ZDg9k9lt?=
 =?us-ascii?Q?NbYb3QVMIEJRgNNX4jybknWWY/D818GqvZApxscECmWiOkkWeppuDkeZeaNJ?=
 =?us-ascii?Q?rgZs/sg30kYwln4A1ceqPjT7ajbBNL1dzPta1dRe5CjrID9CkMrZYEO1QjZD?=
 =?us-ascii?Q?TcDJ2vEbLyz/ClsLbUuWiO4aKH+kCODEZrbUM29o4mN5+dcdWfK+dXgv6VRv?=
 =?us-ascii?Q?3YrOYDS9SBNvVGa0iZUho+2JugpcSayU045kHmUsQsLYufbp9OcVUIuSdFFO?=
 =?us-ascii?Q?3oJRdrfE4S1HbHdUBDOfQnV19cE7WVjlPNELRlPAOR9rZHRDUhwpjHv3qH5i?=
 =?us-ascii?Q?VjQQdsxkk9LpTkc6SlmHIGAz1CJheY16Xk0ZZKSxuQxLMCRbpbZ0UtpJ8AEr?=
 =?us-ascii?Q?w4HdV0jnmW9uNUKwEdywRWhvLMTzP7j0HZ7NhGD57wnqDuq8eVmlp1R0Sik1?=
 =?us-ascii?Q?GGlwZF1dC1LQaV0ML9hovTJE9ZLTIY/5m+JTJkNidSI93SEBpp961y19PLS2?=
 =?us-ascii?Q?rjANIB5o0fvCEpHXINmXA9cI2FnbKPmqxBBWKYcBEzLyCmAbMNzcH0MCJUgN?=
 =?us-ascii?Q?b9F9g1Bp2zWBk1iXy0IFXoPV+c3KDfI34mjXYGSxZY/1u3DTPOvBHnGwCPgQ?=
 =?us-ascii?Q?ziiEaeI5Og8q7+f1wbWqKGXNYMN2TPVC6Xb4pV6Vvc1ThU1raLFm9kVBptoD?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ipENlgyHgJrLDFuq+lMCiMV4azu3JWxYAbhM9BaNS3OKr0H/ZVO96kiyPQjUtrmABGPsS7jSTreq+nsILgYUiwPyjaA0MYyBHD3WYONeL4v/+3BkfEaEsHrk1zkB2CKzIRLi1V6rPjmyXJn9/+xNRbTq+V6lw7WcI2iMH7eU0Fs7rQlBAe2dFk7uXRWyMBEG1I9LTPsJC3TFOYdm83kSp1AZyDFMKfLPEIlfmlBnxF2zDpHdgUXUL1UWcNb3qvkJ3F/40DatopUmrkSJ2JMjr9gxOuRAQvC9qhnr9sSjMZ8/MNZMUqJjU9RLGGn1zAy8N0B65a3S8+Rpklc9QUsiSunqR9ZAZ11qQ/Q1IMNWJUWAh9+T93icNbYnblN2Kj2ygEZeund2YrZ5g2tTygTAGwHK/F95JUVdwHp8xhVtVybWz18aOL/cxaSev0FvoPK0n4V2tQy1nzYPgW11ZTKZjQCjTTvvOSpUSYHCwBUzhIlQVBvSRg6EBAZQUqGM46bL8UelyuVwnWUo7jgmTZunnSft0hX4VO5AITZVW6T3ofXoThRBGZpT6zkdcZ3taO4Nkhf+AYGvAOpafel6Z94mCoiZhLToR6f1teEaMgSF9o4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1853b5-eb87-40bc-2194-08dc4155d473
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2024 23:00:07.3169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UI5e1CUIL/zV/ZHuI7WmNPoK5tRG5FZBvFPDi0T02Dx90RpN4eiGoBLKji7byzYMN0VBxadKM4rtKXSN8oP/aqrMjIUPHEm37dSjOsqU0eU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4420
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-10_14,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=857 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403100186
X-Proofpoint-GUID: K17i0rohbfOAFQmAJQcNQEaYkQQzB79B
X-Proofpoint-ORIG-GUID: K17i0rohbfOAFQmAJQcNQEaYkQQzB79B


Justin,

> Update lpfc to revision 14.4.0.1
>
> This patch set contains updates to log messaging, bug fixes related to
> unregistration, interrupt handling, resource recovery, and clean up patches
> regarding the abuse of hbalock and void pointers in the driver.
>
> The patches were cut against Martin's 6.9/scsi-queue tree.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
