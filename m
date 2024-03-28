Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBF24A09
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711585051; cv=fail; b=mIyOLg1WWAy0j1FuaPumXT46h97J530dLL+muf00RZQrc1CPENNqMTMIOgWT0VBUFiXP5VurLL6MTxKdYpFVXqVY6EMt4xmSIWPwcaz9oZxdRYxkIE3vrJOKxQ2NhSEAHP22RI3gbrngy86WP8lhleh4hxtNP1DLm/yd/O94Jy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711585051; c=relaxed/simple;
	bh=PhAu0Tf/JJX4MAyFcNE4no7d8baUXLLVtxpBG8mPL1k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L4oxiWWuI7jJmDNcUbyinzT5Pf2KRIJDmuxm8jlJ5qS1XLWMIwIbWfLU2ld+Hc6kcHhwCgYfhyB1MWSPZvJm07BEx2KMUijK0RdoMg0PqUGB1dOa/4Ao0rEn9jtyFjrsgtQU8Xtu6YRaLveWpZeiatA4g2njelxUm1+o4NmK43s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U82MilsU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=boG7rK0w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U82MilsU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="boG7rK0w"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42RK95PH002128;
	Thu, 28 Mar 2024 00:17:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=59ROeluxsDFcrjtqJ63sJcTUvwXNlxoNdSfd82xInx0=;
 b=U82MilsUZUoPAVpzWUmzEPkTiYYZCakl2eSxnJCook4T7xPQokEkpidTIGlqJMIqOU4N
 4ZNkU6GGSTxcC2X38W6TcFk8Ic8l5w1Ufbr78cns3RlvTq6sSEKgmPusJTTDslzJnfsS
 TyrLWGCfn5QaBz2pdiR+TKK1rPr9+yj0huaS7VRR9aQDH40O7a125LYKTuAzjDqn0cLQ
 Zdjvukoa/cjDoO9dzC0tqhqbhbZ0AB1QBrgBZnXQNXawKjgoNf0gmb2kX2stiMSLkFEC
 cGmF/b8vcNivYX3woVQ43b8+lkm624t+GxVOASU4ku2udGuuZmMYKyvQNpgyIqnsOpbK Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv48mkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 00:17:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42RMUcb8018173;
	Thu, 28 Mar 2024 00:17:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh9gh3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 00:17:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQDUZbc1bl5tLsMrQ5noAwRL0G6BMVh3PuCueQTby5daWKh8LLnie83WKRYRRj4O8dW9dp5DvPFQdnLKbh3LglYrkR1qT4B6BV0gRiBEfdWLVTJ7m4fNgGI30Q9B7RnxfDlE23j4ho5E2ww8A55xL6c6klwu/ZpetZI8mBrYEvzpO4sTPr0hHVWXaevcJ3QUTE+0k3Bb6rEpnxbgExfcrr+I5pbOZKYa1BBRRLsbhfJHZwfMXqrJjkOqOw70OP1TOh/wJqw3ryfpiPk6p3/8pGjcAEFnn+DKC9/PfMBjoNpQjqA7ZjKOJ94R2nsyqc71t1sFpEekUTTvNqO5FBG8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59ROeluxsDFcrjtqJ63sJcTUvwXNlxoNdSfd82xInx0=;
 b=IrinSGL/WvST7Bzfr+qTeIInfFXJZjYtnV9DJJyl3vHW0tsj12t2rXx2QpBaEKzJwqKDALiLeh9YyKxR8p4opuyXwihGj2pAy6lFUsiwMT5sNX81lFIaNgd0moNuyX8orGooBeFGB2AJi6fuL4M82/mJSmvuP/Olwzwr7WQpVn3qUP9mwle8w87E5viJuYvu2HpIyMZO91rDal+4w4I/jQr3GbCoZpfrcVQ08iGRRPhQCs/yyzo+ptwKJiI6iQo3ZX/KIGCGptOksP/0aYsVbFsp1zbz1iDuPoT0zdP7cVQFVlYGeAoO/aPkRSXdKAmsy3fpGUKVZJ2sxeQxf/kdOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59ROeluxsDFcrjtqJ63sJcTUvwXNlxoNdSfd82xInx0=;
 b=boG7rK0w22zsmPlKCOaXk4SGRIpc17f9kkC9/CErX9iXkKxTzgJvkz15RdMvkOBNzDLnl4mU8QnTnNvL8cOY3s4WsU6okFz934dWLNygUV+89iaOT73PZpzNGIZVUIIcGa7pyGmERfC1ivc59gFaRqQ1okQIWJgonIG5wZ/Y37w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 00:17:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 00:17:18 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: libsas: Fix declaration of ncq priority attributes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240327020122.439424-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Wed, 27 Mar 2024 11:01:22 +0900")
Organization: Oracle Corporation
Message-ID: <yq14jcr5hxj.fsf@ca-mkp.ca.oracle.com>
References: <20240327020122.439424-1-dlemoal@kernel.org>
Date: Wed, 27 Mar 2024 20:17:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:23a::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: 85949ba0-f517-47a7-fc16-08dc4ebc6e15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5sTnlWqkVelNXYYqRyo/GJkEjbOp+kw4LahCsogvo6dI07/nZ6Il/OuP5BWyhFOOHx6QJDFdg0hugE9UEss52smSa0O+yGmVlFjvTqPOiF6Pt2t362cbLo+HYQJVp7goq4VMl3ivGaln8O09Pw29NwsxjQ6WxIJBJ2OfYMNfYQLl5lw11P4ntg2yEJ6Lsr1s+yJfqNWXaygD87EgWq6EQk0ewIiFPjfl6nYkMRvqLhUCT/NtAXW9XQoAjTaxWJ5ugncPq+PJ+2kUe84q6Ey1oM3epqpJv7alBowEVt+TkKdNk4ihEpSqrCUd233sKmInkveiomjggXog89XfEZhvm5VHHsqp82Gk92Sr8iOeJU6yFgh8VwSJnUAp6yOE+qKVG/8VSsdtpV7u+33zdqjdTqV0v+y6uH8YdzUa4p7++tjv2YEyY4Jlm7gQPdEAGsAcIPunqXAYJZE/fYSspQekxldk7f9l8/+U19FvbM0qrgKuMrduui9eKXt89Lyu9PLQm5QrezVeFEMCEbLjUV2V8AzsocjKRPrO7RkjQ9lz0qxiGflKzkaDvE0toc2Iw6SRhaQCFwv1zJsRUcd7VO1kuJSgFs2mQH0z1/CxGv61l5PYW9cyAQI4iXdm8PxJRQrShcW1usdJNSrBcPzmCJJDlXQjJt/GPsFHSHPASBOEZTc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ihOp7a2rTvUMHk0V8o1OSuUifpcFL9qXRWA59/xys9v5XKWw1yaGhYxatpJK?=
 =?us-ascii?Q?mtVQx6DA3u2Xnp0ShojRwW5xES42zSTKqwlEzwVPSAK/LVsXLcPQR9qyMp+r?=
 =?us-ascii?Q?l6n2wJ2Q03yFxhWutz15ViV5MqYaJ+sPkqHPs7GFlypN1HOB+4sSfrvOkdrO?=
 =?us-ascii?Q?VIKmmyNPWGNzmMwXZWekOg4Rv6QgpKY7dn8/AkS++xcigmcNWfzTbxYcpexW?=
 =?us-ascii?Q?ykZvKwORsB8/RcfiVjhyZmdGNi0G7sgSitj1rY1zTjvv+e9//33KfkcLaOZL?=
 =?us-ascii?Q?UqLghPz1mVcnMvvM6S7YMs1n2CpDv1oPPCBUECqcHte7RfiEGwHQh/RoykG+?=
 =?us-ascii?Q?YytD98DhV2jowTN8U1LT7auNRhLU6aiCLlJNecBvdIcDRerdtsXueuqFL7tQ?=
 =?us-ascii?Q?GE6BUK939WJVIPIvpesW3WdqO3q+cq4WTDbtznhra9yGFRw5BWBoJdx4YnNE?=
 =?us-ascii?Q?UeqKVEg33Qvid3VktiKK+0b5uLVujlbccRSui4rPgkwmiOuYDj5eOPo61BN8?=
 =?us-ascii?Q?uDLapjY0eDt5EtgK6KmM7h+L8Z4Oz4tJ8yDKcu/s3e3i71EK5NH7NdBhQw0I?=
 =?us-ascii?Q?4xx3JlfN10Y24kFJTZK1AZ0J4kEfsmCkpRomFW0tbiT59AiMEsFiEZRGGSiY?=
 =?us-ascii?Q?m7qG/A6nKkVFVkm/vve5gOGXssTSDjA0oPAh8dDsLTtukd8lm5Eee4QsuEhB?=
 =?us-ascii?Q?Zkh9dBzzbV1DtawiQKfBs7zT9TsqidHolnN1Mou0gKFhb7CRVeF3j4oyusAL?=
 =?us-ascii?Q?MuXcGMpubAObkMLhhI7bunY9iIHtj6T6MQ9kvb4sBMcAuRp57+cal4TWQulj?=
 =?us-ascii?Q?AlPuzvz10wLi14XCYCYRK86cYxSqgM8CDtkJbJoDFLuBs9FIDb8qp4OfIlnV?=
 =?us-ascii?Q?7O7DqyQgkTqdQWCS4aih5bFLSrQqzir86uOmcY5sv55N5YT3uTqUeO0wZYkM?=
 =?us-ascii?Q?2uAigB7rZa5jXl8KQzkfCkFZ6hO+vnTmDty33AWCTMh6G32dRMrDyaQfmw2s?=
 =?us-ascii?Q?IOMdzhLQy9PxgH5eutq7Ma7m9tbtxi6qyk3h44WiJELDZ+XoBIicU2Pol+ra?=
 =?us-ascii?Q?8bc5JL9fqRRNuYdaRTT0oFwOVFo/y9tx8CedgVaHehFNIVQpfoBYCBXH1z9k?=
 =?us-ascii?Q?Kldmwl5JMFIGdvJP5kJ/ZrgBMHsVz7L2OllalQpJXMBBAATUcyNdMNtISs2V?=
 =?us-ascii?Q?5L4eIkz6nAQoAN31F+4LFZdQIIECJ9vT7E1KXdNTq1GqHkXbVVlQNY3XGA3m?=
 =?us-ascii?Q?Ft48vqMCIdfAHHSQHeqJJXXewgQRvgKnyZ1USHnrzwIar2SDbRP+J8uLfnkC?=
 =?us-ascii?Q?MhxH14QrTieTzz1CZzB9M5Zda62mndHyikYHpCSguuQFsuFFRbuFwi81neP1?=
 =?us-ascii?Q?Hu+uoQeu10jyj6RGGlkWmeZ95sS97Jgbv8yDMqVcnppPn+bTEI8Qtrrz6GUh?=
 =?us-ascii?Q?Czma7nrpT4TZrCumhhgvjLAIdwyl3KAI3M2ESfDd+jfxGlDUzT4xvni0bOaL?=
 =?us-ascii?Q?9dRVwNkDT7tCRi1DXohFqZyjaeelPbaXlKZ3Xv9AWwP13CI2UIc8eWnLmNJU?=
 =?us-ascii?Q?LICWgQQ23xYSEAToMAGs2jfEquqZqIsPi13rJEzA9V6pNWlIF6mNd5xBJ0tH?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	izrzOqgDQ3mmOCpuF1KQL21KnzL9se1L74SRBzYi8VRHDsGn36tNy1rmQ0DAttVrSiDFmVKkT58GWrHq+95cyHOQGrPcK24vkMJddA0uhepSF7ZMIqM/xradYkxMunOObFf2Z78VRVF7OwTaGlvTgllgyC2tEKppd5U+D0fzZIbtXHDGh05K6KqpTM9O0fSxust943x78ADQiI0ehwUHBeud9M/I2XOqMhnVzM9w88nAnCQpQX5tGae3ihpxW2K+OEub4NNQgH0jyFpd2WWspcU3C/8xlJaToM+m/Rebuk1Cc01b9gGfVYtYcQPNwrWwfW4h/5ubS1oGHv3MUzR60mZ7/BJqB2wQAhBdryQLiiLZGuuqFvttToxGU1sEJiZu9Vy4GfMi456K7OZ4botOxmcMo7uySFT1kD2roncXS7Xl6qETgmdEDupv1xMIOHVgqZgJ2uutfeMffM+G5IiwKisfe2IKGs8zMZszHUxba8f3K/dIX6qJN0OrA7mMze+V+Tl/2VFPVF0bESICXlzs1jGfOcljSBHzLdFf2JsfnTTmstjT29shekuZofZH5TrdDoZ0VL0Ogk/oeoLrlZyp/wPgdNLXkoe9r/MzEil2iiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85949ba0-f517-47a7-fc16-08dc4ebc6e15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 00:17:18.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +FTamQ4zeIXQvRu5N0mQ2gspyhAFhmUQnJJZiUBamrweJWdG3ZdycyuGiiPXENUGlIyJvLyxH21x/toqzwFODWr/vKWrRtpH5mA1dkRlHt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_19,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=931 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270169
X-Proofpoint-ORIG-GUID: OESmXz0OR0aSXQ3ciSayb4yPG1jVXRx3
X-Proofpoint-GUID: OESmXz0OR0aSXQ3ciSayb4yPG1jVXRx3


Damien,

> Commit b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs
> attributes for SATA devices") introduced support for ATA NCQ priority
> control for ATA devices managed by libsas.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
