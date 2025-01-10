Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5433E1A23B0
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736544105; cv=fail; b=Qlct9wKrGDM7YPA7nLogozL7B1Em2efuEU9H4y3Jp1Fx8DGxGWpzYaubRrRjuitRZyOMvZBf6fQaMXRfMWe9OuisQdfIjqVKw5efu7+a+SlJ7ReTNFQu4c4NLBRD2gVquoIL8qeQia/9qkGq1JEUF9P/A7vePO5vsXkfM/lf3YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736544105; c=relaxed/simple;
	bh=P6kw0hKwyE5F6ehxE4EyFkfm5OeDstrzaDxCjTR9R2o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Gn87EwxmDUoZE2fOji6Z9k8564gWg5+Za+OBhWtmCKpYq2LXC/iN/UlppmSIYAkMepDImhG5R/3jjSk8aFS4P3C44Rlh+jolvcrHSk21YX8/dSEEJAz0+QveEDT0VBMSztlFWsGUewclWb/A+Xy1BvfkXICcPX6hEAQ7b/u5I38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BzEkiJBy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bb9974tu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzEkiJBy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bb9974tu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBoSR022213;
	Fri, 10 Jan 2025 21:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=DSW+9BbXpIYdBm6dQL
	tXw45V1Fzo4TS5lR6P8VCYuHo=; b=BzEkiJByyCtXLgOx5EC3tcF9svJBJriUeZ
	wWBLuRpzq86fH5ASQH9e2UuQA7fWKOGbE0wrUwCG4mmAl9sJApPW4jyVJxfdEf5G
	+6rgYrhLjDpo1uHsiO5sTpm4wA4O/rqrcULsqxG3uTCEeTm/sY7Hc7efBtVPND3R
	L1RS8YohKFoYnkzjZfVJNGOSqb/o4qt1tLkoHTjSk9LeIZ2BNB1bipwAcMGgjWs3
	ButUZdm/M7AEuQ3GIrAWfIrb7kPKSBJ+SJ/AtkKa0bJEN7b7zdwFaU9egihqkMv1
	UKHCfRBbdjXG0WxwXW9Hmf/FDflnKMGnDvfrb0jZKwmZmKanhVWg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc105-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:21:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKeV5X008534;
	Fri, 10 Jan 2025 21:21:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecsmsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:21:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOXr/DIOW+AjaPEu9yPQO24kCGGu0Z6Ufs+yDS5ZTeLZyEg8VZiClFjwhwednYxOG2TEMvV6gWoN+BRQcqCOWd9VqzZVNKQmEPzJ41Pp6FlOMZRfiJQyVEmyBzBVPS+ENvHs+StpEcRGgo+dHlCwbWbA+jOXYhbKi7O/GXV6KOC2SFGaf04shQJz/Y/6OnGpYfk2R1WLlZwpZDTAAnt/QTyFm6wmkp6wyAlXiWJQDn5SQZsWZT4tagb0jFLNUcGZ3RDC1IO56+/O1AGnpl4oEriEuUfm1ml45CVpa15bt8EiEfoOHUpNxBnWBoQxdoFhEdI/HHiefH5pH5rvL1YjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSW+9BbXpIYdBm6dQLtXw45V1Fzo4TS5lR6P8VCYuHo=;
 b=aBNERx3zWgeueMzMDaoJ35WfHoDobfFUz2ey3C2GlC7RyF/JVbdWJ0/EvOfrQIiDIq30i7pbOW3S5fF4ZZgZwJd53YOo18wt9IX9MVm0t0XgLDTgU0YdYQRzFE0Imi9VbAPn9PxU/XQZYW+RSHwojXQdXM3o4LVNOfeJCPjQwv5aaHVUxlvQZM7tXCnll5KFzYxAz2OrI4bjHZLyDC+dsFGDvSaZwVIVw+4+Yau5xwYNwcrIRu4oi+Bh69i8xQI12V517pREkbghVfPzmuXBep0LvzsLRMOrEkKFvB5Til0QOSffxTlI4hmdfBTmvZY/AI2H2/rgJA4VAMY8SCUD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSW+9BbXpIYdBm6dQLtXw45V1Fzo4TS5lR6P8VCYuHo=;
 b=bb9974tuRI2bqfu1hHcUup795/KxpREijPzo+/n23Uxd1ZLp9bVYb+mxM99Euc+8rlypXJjFGlHKfozlktoioCqWH/Y8TV+uCftP+qfBbIH0sNjjKkIiHPS/vuJRG0Dd10PG09uWVO93/2MEibjytrDWF9IXKX59q31ZXmE7lC8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7515.namprd10.prod.outlook.com (2603:10b6:208:450::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 21:21:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 21:21:39 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_debug: Constify sdebug_driver_template
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250107153325.1689432-1-john.g.garry@oracle.com> (John Garry's
	message of "Tue, 7 Jan 2025 15:33:25 +0000")
Organization: Oracle Corporation
Message-ID: <yq1h66674bq.fsf@ca-mkp.ca.oracle.com>
References: <20250107153325.1689432-1-john.g.garry@oracle.com>
Date: Fri, 10 Jan 2025 16:21:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:408:f7::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: d7269b8a-fc15-4745-bced-08dd31bcc565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IOai1CVUmkKdYieoE2WQnNrfydsNqU+S09f1q44vRmOa3ebzkXCIjbZq4O6Z?=
 =?us-ascii?Q?3/4Kn5dTSHKCX5rGXicxoQsxmvS+RuXNJcwzbHuv745P+jcTAyq1kXTUDETK?=
 =?us-ascii?Q?wOkOhgsX9epKTxA61mnuRT6lb8dhbNeDdEBhM+iCcUP8ErCTo6FLtOP4qVRi?=
 =?us-ascii?Q?dBrWRC5mF6wny/K9n76Vy5vOGXCEo0SKurMnGm4oJ5R1Ms4KL50C8gKBjJsM?=
 =?us-ascii?Q?wTCeidVxSuLZgbid6xriSPCe5dzICHFo9Etlz/hmVIshm6dU5VXyoo5V+q/E?=
 =?us-ascii?Q?u3u2dnk9ar7VZhzA4ufBlYiZWzjY7C21BWfKZDSiEZVcWTmDBpYCNdhpOtZj?=
 =?us-ascii?Q?DtRC1HTy6sApBSa06aRGE2LnCqyRKDV9dK+IdW+Xwkh09rREe0kF5kx0sjzO?=
 =?us-ascii?Q?8Itvlhnpgb8Rz92/VR0hWU8ykAlFbB8SO/R4WOhzPo7cYfer+CSNfvh+2ThY?=
 =?us-ascii?Q?j76KwaV9KEFa0l7ya19rzzXoxPo7V066rxeezbtLndMWBsga1T/vlZiqmzmg?=
 =?us-ascii?Q?I05Zes6+j2tNwWEJevH5vfpFeURheVyEfS9sdHPPVpzg5pU7gCTF5ng5p48f?=
 =?us-ascii?Q?8qAiVFB/zHOlTLxH7G9pyB3l7qmJOxKUW+mWLaLZM93xM/XVy04M3lqai6aH?=
 =?us-ascii?Q?y+p/jTyU0UDU3u+Ai6a37LPTvbMqKGWnAY7GzoNqbdm3Ec9HI5FB542tfaCK?=
 =?us-ascii?Q?Td1VgSEm304A+KW8j0AJs0wQ84pZtXbfhTmG18eVRUH39DkeItzoc3B+URdQ?=
 =?us-ascii?Q?Ixojo8zvzl12HLJLUB26oj+jQtih6SbLBfHyWMGW3siKRsMwfdfrLw61kl4F?=
 =?us-ascii?Q?LCVKtdUv2WXMi8Wlj1skvnTwSJIUh4hHrMJxmY5TI1StiAIgA7+1hnMZyniv?=
 =?us-ascii?Q?Fg7S2v+2lIjgLFJxZmKM3++MEda39Gs+Tj6mWYpQm3FtIaEixl1vKUEk+PRL?=
 =?us-ascii?Q?gDMh1WrFdChdRvw930ckUX+fjAiBmplq19fAioSJ9DXlanuO9y7pywvn2T+F?=
 =?us-ascii?Q?iz7GKPZhMMRP77R2aQbd6KAmGFk+cdTvxWy7mJV9XWtgh0WX/UxlTWLEq2QX?=
 =?us-ascii?Q?h/1w8dzoPHaqDOd+d6c8LpzI8fsumzoOeqZpbz20u9dRAd0dqKixN37xyTUS?=
 =?us-ascii?Q?sBfJJNVhtMT/D4WLM2FJ7XU5VB3JOTNBT0udyMlquws1T0U9IsJKVtZWVVQM?=
 =?us-ascii?Q?syDvOh+2M02JzDIkTCDqpBwR5B7ijGMn8FlnYFf/x3LtgmC2noVPxI9fDy5f?=
 =?us-ascii?Q?thwev/2zkRtyxOom4fo53v7DoodRtMPCNSICN/Q2f1DKQpfzr2nRioKDnvlw?=
 =?us-ascii?Q?L0xQLjT1BdkLgscS8MjKo67f3u21lsM0Xe7QUaTG5ju/xbmnG2M8DWWP3DUd?=
 =?us-ascii?Q?n3kiBrt8SYCry/9Wh1bt8+AAiSXD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5TztPdQ7bXkW8Sd7lqXIxYiK+9QqKR6ptPGX+rHHtXTmsMgHJB4kO921m80y?=
 =?us-ascii?Q?yHRpUSrHXlWlPEslg2hEnY06MQt5rG9J/OIWIcdiuxZu6VmD7ABe8Tix9lQO?=
 =?us-ascii?Q?lsmV1sU7svpsjd0JLUCXPeY1TXYxYCiluxprWuEZIzj9gOe8b6mBLM9+GigL?=
 =?us-ascii?Q?gsEyycStH0vNvguRSpLoFyr5JWtfryirv8Xhw+gjHjoCDV8eBm3HU12i0s5+?=
 =?us-ascii?Q?OxEst9kJsWxZNxpSaE+kyCAntxTkBdYrqKzgpfL3Iu9aKLc6X/K+lAAlx69K?=
 =?us-ascii?Q?CBPPvGPeIcRM2wxJYrkt7eVeXJkXIrkX0g5zytfErAUTyCS5cU+72fvlgps8?=
 =?us-ascii?Q?2UIFOg2iPJLJojrVjo0hyPhVDgzdVAnrasGavAUGQJ1/l3lh93YCo/+ygpYb?=
 =?us-ascii?Q?/uPoga8w/WyzggwJ4ZkJA+yH2zNJwTAyaH5EHJM/WYgG7K2u1fEykYy+3Zs8?=
 =?us-ascii?Q?a/78ynW/o04jFdI6mCocHvkiVyhLwyh+pMQiDky+3zWladazcFgFjKhloODD?=
 =?us-ascii?Q?93+8GUyGwLD1WXr7bsX8KXfngo8GXLQxLEDAz06C83CfIZyQdn1YUcEK7d4d?=
 =?us-ascii?Q?eNFLZVBFl6mBzAlnU8on/LY6b4IQjxO7sPB8rFdaIB/UsQNxClqbj0bKWE0h?=
 =?us-ascii?Q?TKrMomYF5evSl268KYj9NHIkSCvtzPiuoWItFZS3aWxuW82ftztN/s6Ciqj6?=
 =?us-ascii?Q?Ykkl/N24T91vyRnXa3dTP/7ZZAbeC/3SdTu4joTHgZYDmueZjz0AyLPifyYe?=
 =?us-ascii?Q?Fl8NHVd6+ml7e9X/aLFEJKDLV8bg6loc+VZbMURUoDytthZEgCRVwwNlKv7A?=
 =?us-ascii?Q?Ro/XsbuAjbCOdaRFdTmLjEbI1azv8Ry53uEiJXfSWIKbbJBXb6ktCp2Lzze3?=
 =?us-ascii?Q?b1M+lhV9EAKvigD4GxkMp1Xh9Z6ruSK9VPHIMNu/H3Wum6/9W6sAAwYNODCQ?=
 =?us-ascii?Q?3XR7ryq350RLIxWQip5YNE1Gc7M0pK3YOdFqU0BSR9OMSr0aKjTB67NDk4Q2?=
 =?us-ascii?Q?CrsQ9WH12+u2WjYpd09c6Tw4N8HGQLu16BQvZT3Zo0KiSb0QMTgDAzv8eBdG?=
 =?us-ascii?Q?logfmtA8yFVLwgcKaBRmF0PKs3lEg2wS02GCrZtUP6BCpZarhlVW8tGFXE4X?=
 =?us-ascii?Q?Rqe37fCwTs9i6BNvgmW31sxQldKs/BGV64MCh7EanpckC6qVj4JMr+fHUOOL?=
 =?us-ascii?Q?NGoVVBv3ZhtYO6Dtbg+qH2Lv0ZC6Pe+f/F4TpX3FNCpPcFsSd+kHKY3g+65B?=
 =?us-ascii?Q?6fRTPmYpjR7tHbRIM3zP3VZBZoEmDdkJMNHiVpiFt9gR6A1Ugs6v17kLnDEx?=
 =?us-ascii?Q?C52cdOkQFEewcwfuczlXtARJ8I7fzp9DTDtWDjV3IlXdvsoapxpANmSiVzkx?=
 =?us-ascii?Q?MXEyCMuT7pVf0Lytn3uv1M7ajnmIjUybqqzqn5Ut1XB9dTB7Ff3jJzQClGWt?=
 =?us-ascii?Q?bv6VJzUlFyKEPyEKpqECSU6nmf2P7cAUqyFFdtj32uvZIAJb1BcKmLfSviPj?=
 =?us-ascii?Q?PZr/isYprYr5AccbEeAvxpoMi7U85eGhd0jFXM9p++lrdhoBBaP0GQx2VXKl?=
 =?us-ascii?Q?iuthroXdxE8f4Okmq/Xm4iIMH3xu5szX7xExcpBvAa7GUoTXQZMx06pxpeCH?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7dGbSjhHBdXUNni0kUoP9eBoD2EkJ6irOmP4IIgbiUhvNxbzkfEXREIWY7BoZm54Zq6NUhRovMUGcWq2+nvyCBp2CmMHgC+PdXu4Np2dgZ2IAd2vVi6DGIKcVudVNEwt+BtF/YznLXvKjUFLWgbn35NbFLgfQfgk1ZXSnk4dMji88hBPqaFbGzHZvBzkh4Qee3aEtfbsWw0UiYqUUzMQGl2t00cCCUKIDujxeiyJA1gg17e0nprg5Ji8lxvCnJupyLWPn/QsQkgaIThvCwgRLhoVTOieeYLYWXQ4La0iXbSktxcITfHLbfjmZaYeYFP5twHo0yiwhL4LBEZKLv1tbthfjya8m1QjTWRVrwnvzX46GWf0t+qUnVZM9dO5iWdKe0zYHwzE7AC0NnymKt5ca5B5oTGTV6pHyO/nb9oPnaJTqL5BuiIC88FvErULZdt+e34uuUtBe6s0Di/R2oH+Rykw1j+PoS7zrCJE3JodWquLzxPAu3ZVAx33ScBM/Z/4sznV9aKEMDZAHxBW/txRQxhbtd/ePcvrTqkj8zd3PoDNKF/vLAQoiGzzqyfDJ2UtonrVm21DnIuPUNEDH+sLbCmA2mQz2xKVRZx0kv7KTog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7269b8a-fc15-4745-bced-08dd31bcc565
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:21:39.2946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k90R5oreDmp0yRLXgelKIxLW3O5TE3WB2GCaq2QdO4K9YxcebmKhN2PzCySZUfnf73HEo6PLzTCRJmZgxuy5rGv18SyDnPaQMk7LsIFqBTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7515
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=944 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: 6w0u18CXfxFmXh_okQPeLIcTYTgMpaXC
X-Proofpoint-GUID: 6w0u18CXfxFmXh_okQPeLIcTYTgMpaXC


John,

> It's better to have sdebug_driver_template as const, so update the probe
> path to set the shost members directly after allocation and make that
> change.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
