Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF8B13E8BC
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 13:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715780840; cv=fail; b=OKompmhbYtcMDkpEHqdPJyVt+ntDS75ye0LdPs18lZ5V1M/ZOVjO6u1R1SngcqsdQG9IU7cIeMbyUZLf4fz40l+kjOXVn+CchQQbpnaySfAwl5LQbrRY6iVQNW+xepULOjJkuHP+WEoQJQyW0d5J64RYKIhCslVJeLjN9A+LR3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715780840; c=relaxed/simple;
	bh=yXY1N6i55tHaOMKl6RUn11L/IM+zZdrvhdMCyYKiSWI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AA0xDKy/uTb7UAAECIlZmHpoWLxLRyIHJwBozweRKM0UdVowNwlbHejbiPavcXJxFKgLju6J0ztJz2LfBdiBWftpG6zjOxd4yzRjeQIIIg6T46WhdtHD4y56if6Fp01wx3I0ZsJCilQOlp7VDwYoYfmBPweRmskKZanArHg/88c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bGyKm3BE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ODMJfRwc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bGyKm3BE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ODMJfRwc"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F7nc7o008122;
	Wed, 15 May 2024 13:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=LCPLFXXqTdQ3mXokKC1xvl1MbjnYqG68vjGi5tyTZ50=;
 b=bGyKm3BE8PL8KqugmsXpInhit58OOnyHhgHFmhIw9l0bkrywauEeCK1P9Jsh07DxKrme
 ACCmWHbD6rRJyEIgTkc0MM3C6/HnpDuQ6HEYR+NySRB2ghscQw+yLaZ1YX/U6wEvYJr/
 sZt0hzIAgfJ1YtaHGYjktbdOif0NvTh6X6VVtjpNMf3hd7gb0S2T+OaJbeufNKuUY1bz
 rqMfxGshxg7WfQ+GFIocKqFbI3bSW+e5Y2GhGIgPFExImB2j9lHuieyFRTOiWGZzpWm6
 NlMco4Q2WpoXPr3mH2bGJ7g7IWcqMIYHsPyqGYpmQ/L5P1gBb+vw2FDnoufUylrdORj5 2Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y4c8r2vrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:47:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44FCTD7Q019149;
	Wed, 15 May 2024 13:47:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y3r86bh8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jP/UQOeyhGsVs8zm+88DADzx1cRKxEPTK8Vz/8FlOp+lTYU2obNu6u4cAFK7E2RE2TPkV7m98KIldkmKVxvX2LOvH1Kjzr7BymlAe1Vvtz0HuU4PjuyrVrmpQZuU1in1bNMNdHKAApDKMdVDYJou38hlUbmFQwzt3jlsDd1y54hioW/XrqluOJZAiP2hnNcjmeNQ5fHs2SSclYnKwWuVbcyzD55MQg/gHY+Jg2NKEzU3aMGGc88lWQXyRPqy1sxWtHw/fkR18bbboOH2VlMHZLeltZP90HBlO2X/OP46cGacPJMzDCaVIZYFw9hasFBK6L73PDe2iKNpYO7ub8Q5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCPLFXXqTdQ3mXokKC1xvl1MbjnYqG68vjGi5tyTZ50=;
 b=ghrfBYBJVvrCatpDU92qSVbtPvm98EE13rsiiLj0wExe2iOGF9aztzyrsmnH8luod18F014R6wa/I8g4NkpcwYTxthcJWZCdvZCH2hZtZboEMHlamG5H2dvBFbunzSONeOR/G4mcDmDhD3VNlB0EVnyKDzR0z6q0SsfgvmkJ9QMAJG/+j1MmFLHPQsbMo3jPRxNNPq5RbaY7AUQvwvy/dRR4Ku+N8fEoneeR23/TDMFWeByxBqKpwq7E3ZlwV1fovRHYscvVfzDkwroeMwLjam67vmwf3ThYwZgwmxwsYcUvTDthrVGDqLdeHT5I2HzV6KgvK9Ns5s+WEZHEFKodzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCPLFXXqTdQ3mXokKC1xvl1MbjnYqG68vjGi5tyTZ50=;
 b=ODMJfRwc0bLrP/m/xw0MtSOkzFjB8uos1UExLyyoamZLIjcHJSyU2ejpI7soNlMOPV5BekwodT8P+r4enYHcos3FSNC7B7n5Pw6vAsdQCxDdxnhHs65Co/fnzbT38Ld6GGxlYuPqBEBtXbEwNTLX4tNoBEEKFXMfQ1s9RzY7bz0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6149.namprd10.prod.outlook.com (2603:10b6:8:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 13:47:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 13:47:00 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley
 <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Martin
 Wilck <mwilck@suse.com>
Subject: Re: [PATCH v5] I/O errors for ALUA state transitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240514140344.19538-1-mwilck@suse.com> (Martin Wilck's message
	of "Tue, 14 May 2024 16:03:44 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seyjrxvc.fsf@ca-mkp.ca.oracle.com>
References: <20240514140344.19538-1-mwilck@suse.com>
Date: Wed, 15 May 2024 09:46:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 2567dfd1-85ee-4cd2-ad9c-08dc74e57eba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?YBV1m0I5gqHCOPjJ5PK73IZXPwnvX+z9iW938zcRpImyeD8y5JiWMPqIeEIo?=
 =?us-ascii?Q?yE5PMdX8AcjvF+olkIWRSGWX/IOZdrWS4R5ViWU5FECEWROC8ZMfhYKkZztG?=
 =?us-ascii?Q?Km9y+EIQXJapZnJ9491/VGltkO9eHFCjY/GR6CpmwH0R9zOzGZCyCdQRNlKm?=
 =?us-ascii?Q?IN6SGrOll8kViRQGZ3OMIw7uvDTI0cyMU+gJWvHgTGLaZqVCWcHLjY6orPqX?=
 =?us-ascii?Q?xo/l6eINrIhliawJfkJH4F8DrQJcWMAUydmUBIl9syAt+xCtuLRidB4TOvIE?=
 =?us-ascii?Q?uytKB2FHWNPUxe2nOrKZidyI4m2jB+bEmJ8yayDTOr4SA7cucgu0Mm/VPIfR?=
 =?us-ascii?Q?ylt13yWYbv10TNVC8pcTIR1p1n0aViCiJHcJqldq/aoeKYTaqMNJCN0ffYJl?=
 =?us-ascii?Q?50IV+okJNvluw/S8ah3ZTxj2rc6Ft2cUpSOZZDOITJXzKLW40EhCt8zMBNoQ?=
 =?us-ascii?Q?Qx4Ed/Dfp1MXMJNh31HpNdnVAJTMIpZtNdcO+fPEqxtMcufGYmBS2iVW4I1o?=
 =?us-ascii?Q?o3dQc41BLDnWj4rH4utiJjipHJjz+Gkcwj5NEINHQ4qibh9y77NK7fldHZ4E?=
 =?us-ascii?Q?8c2EMO82f/4fPHmDIREHii2uzpJshHYN0NG/tXfnr4h/bQ1rejNQdueTe8CR?=
 =?us-ascii?Q?anulm+mK+D9ZVkpYvIHi7i8bFVrrRvftWypnYsirnFrnCrTpHDiD6hg93dz2?=
 =?us-ascii?Q?i0jBZyrZ+BOqOl5kGYNMGIFIHNro85RfNb0U0f92Lb1Dv7yU/mfQMBg9wYg9?=
 =?us-ascii?Q?QtUHJbFXXg9gunBYsUOXJXPCu/vLtH8d3LS23LKCQ5B1HpPm6ltVzXh6jy1f?=
 =?us-ascii?Q?kv3i8dhshPLVVa6tRHiRmpfomhL4zVgRCQRlx+tBbVqjRnh//eMMmag0UDqC?=
 =?us-ascii?Q?cTQJp0gz8M4m68gIAU0/ukrprQ5H3ATP9AIImXKt9k06PT58mIabr7DxxthO?=
 =?us-ascii?Q?UPW/p6WXCav4voKd8seMvUGc0rWAgh3vpkdQsIW3WMHWiA/YA+yUH2VO206x?=
 =?us-ascii?Q?ilTO5VRfd4GJrmCBecOrKiFSOtPmxGON50Dwmc52v8MTpyzD3bL7YZshZxed?=
 =?us-ascii?Q?EZrtZYUdwLw550/1Iw5mB/Zh5GHmom8nQgryFqub+2zQKdx/5OteyaYWGdHX?=
 =?us-ascii?Q?ThQW8LiSiFhVET8dVeMgllmBVSj8FLP79nG58x+rDYMtPqd2FNMn97l8hbfA?=
 =?us-ascii?Q?33pn32U9cPdpLtRh2ULlm8/76kaQD7BggjmueblyHku0wwO9Gn2iECZU+TOC?=
 =?us-ascii?Q?y/Cq/w0QS7diHtCDtJQ3Vn+rx4sGbK4/cyzspouniA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qRiewrDhJPA+kID/HWsv6LBSNnezPAZQRhZj9e0yW7uXV2JqOAR0a/slx97E?=
 =?us-ascii?Q?9Hgc/eqabkx68FuLGLEhELCsnUlePOElDK+8YYabmB/UN5tAEFot5/2vESpY?=
 =?us-ascii?Q?/wpNe9a8mC9nkMk1/wIHWv23YBzGGRTwCCvzefZbwtlpWkCgGaPvZGJlsJ0o?=
 =?us-ascii?Q?YcjxnpbBYxk0BIlLGBsuGujXepiqv7R//2cQrzqLCw2EHsKA9vvftR8Ki2Z+?=
 =?us-ascii?Q?0UX/oU5AUhAHzalbbU45ET9W4N7uc3nzq4M9eV88uxd9sw4CaMOBU/Hibt+D?=
 =?us-ascii?Q?eZvrWVSYhWmbbDcJ2bNQ+Qo2l/WZ/7P7IFx1/vRqK9W67dmnrJW+1h2LUX2b?=
 =?us-ascii?Q?grGbfT5K8wNwN/4snctWV7g8J2x7P/G+Wuh/mXUXJu6uYng8mNX1A/0LwK+p?=
 =?us-ascii?Q?5/hbvlq0ZNskEOLtcwSePR78LNy33YJiIz3h/jZJQhKKzL+tYUP9VgSkFj0r?=
 =?us-ascii?Q?/2055m7/qBIc0WzMmcw2SLiqO8joasS5yjMHOUU9jr6xK/WL6TrL6S1DJztg?=
 =?us-ascii?Q?9rYtC75HTAK62ZIDRoCEoGfSxg1w38IBsfZdnkrN+mk7dDGm7aCC4SYjROfF?=
 =?us-ascii?Q?OJCcJCh9PXXfo/PxeiIsdOW2tY+gSJtzYloIa8lojfgfRLkIoOjqGvDkY9Nl?=
 =?us-ascii?Q?fB2nmySQgVHfjagpv5lwaL9YYgRLZSRvWonssMcOXY0GmZQLvHd7la/I2BlL?=
 =?us-ascii?Q?qlJ9opREOYqK5KdvhkCrRt+/m0BbiS2M24XXCWlRF6OA9fBxLS0ukvyLFYIg?=
 =?us-ascii?Q?sa5wcfuhtdHwxH4h8W+3myLeq2nTFGGl3JVGM8Z1HpwILiqEA7LbaJNFJHed?=
 =?us-ascii?Q?BtXsc4FwVp8MRFUacU+Cr9yQZ+5nIXLiPoL39XewapOY8wuxfRZOUkBQNlM7?=
 =?us-ascii?Q?8rRHf4b274gGmv5d2Jw5MIZJyuYAGkSDUfANe2j+k/Yc02XS3sX0Yw3oDH91?=
 =?us-ascii?Q?EvSvSbgjUaBxCd3sL8WwRQrw8+3n+WVVvoJ/iVELlkBMxP+WoYrb72/Kh66b?=
 =?us-ascii?Q?T83aHjEcYMnycucDzjGQeZoPBsMBaxk1wOVE1grI1Ydh+o/4YAn5fEcqWgyi?=
 =?us-ascii?Q?kPptFhy4sb7o8q6JP8/aWij0K5QTzJHIRUdLJmnYue1CXM3FXihl9xmABHZy?=
 =?us-ascii?Q?4dEfg53XxWhR8LhuvgYewJXaZOqNWboNxc96wuIW9vQwohKkZ80CBULG0uhC?=
 =?us-ascii?Q?ouCuGPFVKg+mdDB5bB0NgDxXgLQm+7/mYTG/SFhQvzglL1PSs4i3snhIIPc9?=
 =?us-ascii?Q?KgqBKiTBuRrJZKfrM5+ihZ35t/eRL2BmEpR1ZpC+L45CY4JXPtS3g7eIMHxt?=
 =?us-ascii?Q?B6uLkKmF7yPZXVrqwiAtN7pc5ytrECiGX8mVb+oFjoXopmHVaeTtzApolJKi?=
 =?us-ascii?Q?hTWPE4+01QwpoWd+WGnm3eyq1HQ6UH/zEqOQVbZNsqFbh9tr55ZoRHEv7i6T?=
 =?us-ascii?Q?o1FYY2IdRkLmcVsRA2uG1AZSodx3pSZAHvwwmwRJ5eKmxd1jBFCc/GYxsec3?=
 =?us-ascii?Q?wge4+KlV8NPNnMNSH9rvopdN3c96qF9pAiHJrtSGEmioOTH6776wlnxBYfj8?=
 =?us-ascii?Q?m2IYsozerIbeTexbdLtvdDSXdzZufWl+DRKEcnivnAQOzJnVg1Gg+7RVvEPt?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/bGWYD34wiVOc7Y8iI7AKy1uUgk59IYC7gDLCRGrl9sMNdaYn9z47T0L3ilit0Ws/y5y/+AtcCx1k/HrZm2ROk6O3lLabjhBWheXaYRD/qJO8VrRXYqWURNwgswCj5EmCowhc7E6bVbg0GlcgBwU+l4R6j3qgxPYQUQ1WM3cBhogJpYK0MMP0/CpjW+ZEq5+ykXOD2GNyXq6b5228S/j/AqH+JWPkiuQgReyf/TGb2dIKaBrLG25xgdCGHM3urYlTr9hAuUTTXavWZdXyP0eGF8WvKmLcnEXjNPRcYFaXsdokBQ6iMtLMtr42lC0uh/DqYh4VFSmPUXbTCds6dX/LCXsq5L4sTTpnTiZdOr0IZRbHWyo4Vd3mIL5ddmomc6Nq8rppNOy+gQT5KJhTkQ2wyivbRSOB217C4lFngEihr9qG4lTecsueGbDfyGctTrvYaqpYTxHG5Mcz/uwBv8nf38I+UNUZCckg+088PTHGKxGuGIvw7ySn3P0FDHvC3P0dkDoEl8c09fR6HN/1OSaDVT125IrArGNQfoBxD9hpOsMy0G2dtOEXcasNx3hAqgAmGITL93yZI5bqpJE4MlFMBXCRQwv1FpETuUqrMLBofU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2567dfd1-85ee-4cd2-ad9c-08dc74e57eba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 13:47:00.3356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxQOuYkvXD6YBv9nRoWyMr4fNVoZm5aT/XjPOzkLTVnyYfpN0278llAefu3jw7AFdSrCv0+kZgNR6/qmkgkUQK+QP8FMuw6xYOCP3zRMtH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=525 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150096
X-Proofpoint-ORIG-GUID: zhrpA_0sI5raVjiB4XKfpfvmIQsAIXjj
X-Proofpoint-GUID: zhrpA_0sI5raVjiB4XKfpfvmIQsAIXjj


Martin,

> When a host is configured with a few LUNs and IO is running, injecting
> FC faults repeatedly leads to path recovery problems. The LUNs have 4
> paths each and 3 of them come back active after say an FC fault which
> makes two of the paths go down, instead of all 4. This happens after
> several iterations of continuous FC faults.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
