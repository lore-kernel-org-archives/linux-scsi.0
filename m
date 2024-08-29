Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480301C6B2
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 01:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724893482; cv=fail; b=HjPnzIOuFfpYF6skvPYVxo12m5oCEEeGw5VWFs58X5rvV68ODTESviwLhz3MClCzBXq5YEIk2PN6ART9LWMFY6cuUMfMCODVatPXEQF2CLbDkXCCOBncsC7eTif7sw1utoS81LFmXcF17m8shRu3E+MiX3BHROlR3RY4M8Fvb1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724893482; c=relaxed/simple;
	bh=/ZJQsKQrHk3U/65/Yg8ZibaeUa6y1FeMmq4ouXb/Trw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bgv0lRN4ChYz9PVvziVJIrkyiEIvraD4DzGwMhZUkDLBdetGJuznN3urxA+blDGr2xfjWdy9yx7PIHl919qMoByd8XWB/ueY7H/fx2U8KCexzK3N4plGH3/7HA2lDnVfkJYKneEaTuxmYc2c4UuKyc+bxv3FrNcrj25JD+bx4+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VqCjYype; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VMdiMNV0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VqCjYype";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VMdiMNV0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SKiVdl017918;
	Thu, 29 Aug 2024 01:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=arMCmaN897LrPI
	+ST/Y+HJEa0Ok9bc1+yxc1vk5H2+8=; b=VqCjYypeTw57+6JVcZNLFxip1kuIAr
	jfPXX3Bq4qyJ6t6VCUNnoACfWWJ3XW4CBRvHSGFthPaNoE/G5CWa4qkwdgWDxEfd
	gTLbDWa+9POgXawt2B6QmD9wb4PCw6E0cb5Icww6JJEB8pzlr88M2gC4wQ/byS/Z
	QoWV9FlQa+V1N7G4U9vY+Jlmbgzu7HyHd+JlVVqxTVDBQplX8VculcPN/zvEdor4
	OXjj2lKz0uUGWB4pQ6c1N6hACWfOLIL9PEvP7HFa53QlFDHZWelgvBlfjinE4nO1
	iRqVv9FNp143pXBNdx8QUmiDOl5BpBL1bgH6fLvHanIiUKfG7yeP0ktg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwv31t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:04:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNpvjc036474;
	Thu, 29 Aug 2024 01:04:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jmjwpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P29GjlCtl2xUsyJ9r69oAs6EqN5mUa9Z3or73hwvrsrGdIL4kXHRS8YyOu24ZcggeYr94lpqWqsONyUBrtX/SGcNKnnQCsunG17IOljSGExDKxd+6rRB/hXKvza5n7zYkk0oPgSPmrAY4vnHFKEkGaLbbum1ZPT39jTtJ7hSaAF/7lgfRAFStc4DASeMSSeWvdnygP+7xrPVDk5OgKNVH/W+KzguOQjxdh4fNi65vlFY0rudFyUUlim0KnkBH2QfMe4UXTgFJkOIf/A09gaMAL9tCsOhFwdF5xCJoq2vPNQ/vwlRic+RQAkUlRRdWsQnigGAuSA/qABY47VRvBwMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arMCmaN897LrPI+ST/Y+HJEa0Ok9bc1+yxc1vk5H2+8=;
 b=rub6Zjg+HAU+V4sXD2yhQQY/Db7X1Tqzgy4hf4giR2ZqhCuzSmQCMILUVSfZ8qQKqeBNg/zWqaV5f42Y0Eq10bbFZBq0zBj5LOHynmN2y2wEa7ENVpZJwvQEQg2etGhSCK4KM/Lvr1thcCGMwwAAz4AO4ySRr/BhN27SkbbMA0XMdCFgx4jUTZZmk6ouWN/Y7UY+uIXi0kT+W4Z0xaFAggkiCMEKhaiRyUn2a7DFGHSuO/PGnOu71KOaOZONZjoZfRtBGJAK6PSNcO4mZ9BwxD3VhAw4Gt65J3gjejJEJaQZiEg8fPel68dtuLs3m3iumP+wxtzl64FHG4bcSd15uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arMCmaN897LrPI+ST/Y+HJEa0Ok9bc1+yxc1vk5H2+8=;
 b=VMdiMNV0Nr87FA0l04tahrXmm1U8LOxjX3YOsqTVlvielqilDoSjMZkYmZtXXpV5zrihIkaRsVHUUM7Julk1D6kJa7TH05CnVrnfzcyXj0iJhfVIKSeoAl90To80m7gU48GJu2uOcthadY+Wt9X0jRKGxLJJl+xttMtjS1IX8sc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4698.namprd10.prod.outlook.com (2603:10b6:806:113::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 01:04:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 01:04:25 +0000
To: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: core: Remove obsoleted declaration for
 scsi_driverbyte_string
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240826032005.4007834-1-cuigaosheng1@huawei.com> (Gaosheng
	Cui's message of "Mon, 26 Aug 2024 11:20:05 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jzg0dtrm.fsf@ca-mkp.ca.oracle.com>
References: <20240826032005.4007834-1-cuigaosheng1@huawei.com>
Date: Wed, 28 Aug 2024 21:04:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0087.namprd02.prod.outlook.com
 (2603:10b6:208:51::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4698:EE_
X-MS-Office365-Filtering-Correlation-Id: b67364be-c66f-4ed1-bc9f-08dcc7c6869d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lxpgamBC1nbdajJq1JKoqvPGDpB0NZYjaIUgjd8+QYh/ks/ErhPyYgjPNMxe?=
 =?us-ascii?Q?QyQ0+8txLjkzyYClp37rMwSTVYXoxX5I1wMDwrFXt22EZvjRvBc+0o4cQhI1?=
 =?us-ascii?Q?Qafd2DekoKmX6ntrPF74CkTvZNLLU5gun5m8ZAcFnoAHhRCVPNhcAJauwCvW?=
 =?us-ascii?Q?6wC+/CZfWh/2epFh1evBX7YajNY/F0U8NR6/mys6T46qifoIN5j8R6zf1++O?=
 =?us-ascii?Q?MC7LQRm9s3Urd4Pezk04Nk6VkRND8EmbJxsprDEeagn/zl6HclbK/RDKROVE?=
 =?us-ascii?Q?BiWqZ+1jmp9VCZg0MhVfHLjNFcoJ1w4djoGMlVypHmPjEXt8uZSSQNmLyD3u?=
 =?us-ascii?Q?AVSckR5II23fC0Dr/0VwmePu7uTcQkGNIwnjE2eyv7BukEHS1FpCDwt0uCWu?=
 =?us-ascii?Q?ju0HcE12NLi3H0oyQ5Q/ICko9eQf6cZvnSPetjA4freGw2Ww6rYEf/BM/dPZ?=
 =?us-ascii?Q?Yw69SuZsnW2GCyAnlvD21B7MXzVHkVICcpabqgjTfjvd2FfRsGUTlXepZCYX?=
 =?us-ascii?Q?lc41uwy5HiKbmAapJBucvgsrBXdQ70tyQ0sCZaOKu7ytvEh+TKOqaTjW7kLO?=
 =?us-ascii?Q?9MJtZPsa99dQo8y3b7LNbztJ/S+klwuKorNlcgbWEln9FO5t+QnjGyPr0IC/?=
 =?us-ascii?Q?OR6T0vZWcd+qIXOpqs6iUy0kJjMwtvIXyxL6mQ/4bA+AwVG1d6Sjb6+uKAl7?=
 =?us-ascii?Q?qxdlBp1g/7VC5vlVgN4lpliA53sDx9dpoNF7huMpH7p4e0yz5x1r96Qw1FPJ?=
 =?us-ascii?Q?eH0MM5joDOxAuQv/u7LGrmL1wpmeMxP9sfb1X28nQMXoThWtvUvOv/UddHxE?=
 =?us-ascii?Q?q2piY6MUxy5SYKEGql2NI8NGpZI3uCN/EDThS4uSpcew6XYfE08REGE99nC2?=
 =?us-ascii?Q?T2K27kYYiCm9cxx4e9VZ8aFUmifNvIkvr3Y1QMSxigOnMK8Z4vsC6/znHRNT?=
 =?us-ascii?Q?riN7OHgig7KXFz5NWiMgkaYmN3V+44cvlauscIgX75uZ6+tm9m6ulFtMw0Gi?=
 =?us-ascii?Q?civrSihXdh1x31po8h6gBkQv1vOvD7YjTqwknEjpdJCP67vqlgmJaPSgzuOV?=
 =?us-ascii?Q?p7ZREGBz6XUROpTvuBtYF/KJh/yn4c05jnc2OxojKsyg+WNz+bEkbzNDHmOI?=
 =?us-ascii?Q?Te1Rr3XZDALYAToJNkLNxmIdDWuPMjgDnD0/k0cWQZ/YFOStyE+MkBGRCvih?=
 =?us-ascii?Q?8Sb9/znIMQc5UHhsy/Dk7W3tML0B947aYBPyrVAd2wxt2MRkFEjwOUrZzsRA?=
 =?us-ascii?Q?kP3vPW/sf/5mvTvsGVNu8OPR1viqRxz6CAXgURdavz32XMM2rAUFU5IgllDA?=
 =?us-ascii?Q?xWauoZlrypK4UHcnOw0PnuLjv4OGQr+aqOjg7k8O7+Nyzw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7vyC16iX2LIY0SamBOUaltRBWZXvdACZRnIhB5U0dzavwvgqTIL5FQXocf3D?=
 =?us-ascii?Q?+hefxzMa2tpN1fXutmUBNBeypLPDWMuljBHOWRkRXTt9FieHdOs0GWX2YrKE?=
 =?us-ascii?Q?Sbn6uErSB4DbVgzxqkXJ/KNtb4vOqhqJ+X2Vl5tEa4gM+vPmVsUuX2D9ZVGk?=
 =?us-ascii?Q?tveRp4DYFwpiQ/g/SS5+AotZf1nX8dpI7hRX7avkBrlveofHSJtCRG2AKW18?=
 =?us-ascii?Q?o+u3p9tkFmOCicFIlyTLvWQVCeEg4c+czToBYpAVK3SS4l3hg09V4qSfc/ma?=
 =?us-ascii?Q?w4I9MzWSvczk3tK/t9DfPa5autrKEyuhGq4yp2guTEtkzMXKKgf2b6Fv7OqH?=
 =?us-ascii?Q?m9L8tN55sf1xpYw0Owr8Dbtz9I8AiTShBP/zXd5vbNNAGcNSBoaQQIHESGXM?=
 =?us-ascii?Q?FIiV/XM0euupKXkgjP7+4/39DAWXUGmuMiMcugegRchVPaRw4qh9tWNzJ229?=
 =?us-ascii?Q?BLPe5dc/pNVfKDPUrLFnWYO0rqGvgigIWT5zlMTT4Zl+cjbeIhkTai97qHwP?=
 =?us-ascii?Q?QqxyrZF0ILZ/RWL34hMqBtyvA2c3ulmVZHyEOD6iczYM9WSAaP6TeIwkTo84?=
 =?us-ascii?Q?PPcLEpgDhnj9X3bOUbbt504B9OPX5N6uenruK7wBhDdswfYOIAcc9Qu+3xgr?=
 =?us-ascii?Q?CWcEh8CQVcCmRoNEknhfnDcuWcvAdXuQt8WClbf6zKgvr5t8CY8JFpkayg20?=
 =?us-ascii?Q?PsphkrsfISTXShKyXIn00RoFilnwIGkXkyToLPRYv5ANHFNgwPhHJ6AAYeyK?=
 =?us-ascii?Q?T4fhvtv7umhnWoeGXUeDPUsvUJSH5qZ/m25DPMdhzU7Zj85mkv0rHqGo18Qr?=
 =?us-ascii?Q?y6Cxz2AVmdHTNL/AKwLrGfHe5+akAM7pyb1Agp/PJH9kYtpyAE8AiLa/5n5A?=
 =?us-ascii?Q?0GrgEtk4V2+Rv5f7BXb4fJtkXlaPsOH7JZo9U0cwRb7XXwQesN/6QXJTjRp/?=
 =?us-ascii?Q?/GBgzFUAqp1y2w3+4NadQZmldR82HD4iPspgNjGQkmVUVmZMbaXjhngM6igv?=
 =?us-ascii?Q?mnR6+A8/arOiVz+CWhi8XwCORibpGvO1rUp/YRl8mM+jcRmiLZxStSUscykr?=
 =?us-ascii?Q?UV41nTz8TiC1c3oUDyKvUMGGaSfcLC9PiBYRPjAFmdgRV3Ape6HX1//EeMDp?=
 =?us-ascii?Q?dUcQPB5ThqcQu+tr5N1bOdLqIGM3h103i/Yd4N119NbcDwyObpp/x5QQrYYx?=
 =?us-ascii?Q?4pHh+cggGNCj1bklV6/PM1R01rEVGCNI0uDXwlsVILa6drI97hDGjPue5bjB?=
 =?us-ascii?Q?7DngKtBwNs8WoIoy9zsFZHwjqV5YGTLIChPL0EQX2mLg/RIFJdtuqdtuvSeC?=
 =?us-ascii?Q?GqVSoh1KMVhCcB0Uq0X3aD8G4AONKFOKwvnkCznLXGbOtVQmHaSRqlwp4sEw?=
 =?us-ascii?Q?0aokv0hwoWrT53ht1Fb/txAcRwNv74FoDaJr3sWP1iRavVeEcUIohTqNbC9N?=
 =?us-ascii?Q?Ec+WqZhTmShxsxmgBXGvl5HUU70tXnLWtLPmoqY7tD4xNj3rQA991bFkaOPo?=
 =?us-ascii?Q?Hxxm/AZqzpILZACvonwWd9ByV/lUkxRlmdlqPJzyQm4YYDXfyN3oqsI9PwmP?=
 =?us-ascii?Q?/wkU1wCVCMdjMoYuH3/1//e4X12sdECuIXkmxb/WVz6qKbNkvphKvhPE6E1E?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L1VQAvFj+lyQCFMMuVwuznnELpHMkb1bqKVqfSjtJCFq9jGSIgpaEsr0PSRgyzdUnoHILtmO0x8NF1s2h1ypL1CLBHw6uNb72m9cyOE4uraVLMnZ1XkXgh5p7zxOvAPVnBfS+fyzVhhpTFKe3RysE2plNBOGxSnNWvn4+KZwYhOdEEKZTTskhysYVYcVY48aE4YcWTnrRgmi4N/tYmRRXA3BsiVCEBThveb1TnK69zPvRTwfc/SLeZlhUYc58UmPf7kSNbsaF5fRM4G58CXUm6s8RnViDiglJ95FXNigAF2QLwHK+K2UwEJzoCFTs5g066a8SkLBzKDXWaNv/Gs4xmIB0jXDiRNzNiosWuF2E9cRt+E4ALY3uPHJMctXgWr18dzO3fBLZ21RZyPrye8gLFWJQm6bdiwswDCzXMRlVBHA1oTejgl7j3g3qR89hEOAKUUKFn1/RXMUucfp9JjJgSgEf96oddjo9PbIQd+ajedaIsKRpjXaFSkd9Ap6U8yQ0ub4JQqZespr4x8GBe+nvVFq6Z/XBwY349lVP3Or8u2rz8PEVZhkIdqxw52LaMQm6Da8uBylIrdDiSSiEkktQ31mRMZV9V4axZB1kjKGBPs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67364be-c66f-4ed1-bc9f-08dcc7c6869d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 01:04:25.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZbZJolSvtwALzCaKU7ANF3MLcK0+CZ3feueGZ+bKTaGxiZfoAyVKtwBs9YnOlW0AMuO+iSvA+/tdGyTsG1yenGtXKww/fMlObDEzHyT7fA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_10,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=881 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290006
X-Proofpoint-GUID: BY5Kz3haYegUd08J0hVxNCvzg0D07-PZ
X-Proofpoint-ORIG-GUID: BY5Kz3haYegUd08J0hVxNCvzg0D07-PZ


Gaosheng,

> The scsi_driverbyte_string() have been removed since commit
> 54c29086195f ("scsi: core: Drop the now obsolete driver_byte
> definitions"), and now it is useless, so remove it.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
