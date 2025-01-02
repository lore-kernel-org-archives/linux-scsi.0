Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A036229408;
	Thu,  2 Jan 2025 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735842162; cv=fail; b=iTtcgvXAGb3qwtFrRse4xIijGHF31sludz0kr8JYpy2/l7WeuwVLpMnKz25694Dv4Yy12EjAIZ5IQHWmP2OeUg6pEnXs2dPU+QIrBDJB/TTgt9JwGz26ul44EFTkIMWruCIL5Pk5NhxNrs9dXRzIp8dxxrsc68lC0PN2PlAnMq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735842162; c=relaxed/simple;
	bh=TMz70msbXaa6E3vhCT6YtnVnaR35rAk1UzEFtBMw45M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Wgpt7AzXZ8OilXtijXlnaWujdm4+VkgbdKv1St9+6kg8ipndvtK0m3xVlrwMTgiNLauvCUZRN0C2HBnH3pf21s3wjTo6ly8+P4K64UgC4Nrsi48UZ6SVT9829Y8fHB1NPItmQsitDvZrWIVOKw3TF7/2+SX1U7vh974QaT88Pao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=laRljV8f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mD3CmRoh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="laRljV8f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mD3CmRoh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXqDD012055;
	Thu, 2 Jan 2025 18:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=wKa9P2amxBdvg55He3
	stkWzJisDpiL0xsUqF8t4w5Wo=; b=laRljV8fB7iJeMWWwEck+pXyk43X+oXuwL
	Zt9xoy16bx2XEUV/e8jqjqXS6J4wIrrptzP/YFe8537vrmj2laLCu5+R1aO7Vu2v
	4w1uEup1n2T3XVWL/8KvuhxxDbeT0geVvVPZfPd2BPlwVJuPvoaLHYRn0yVh5v+Z
	toyMygZ9e5KqvQZU04tsNRos9mgPYpxMkN02AM687PyH40zZ0WqnARtOkVlx+Aat
	jxuzNb1LNeE9387ledY/l9e8ol2YxPVlT16C1OzlgGa+y9EyF2/E/8rF2CWk2/YF
	20Ki6o+6WOVO0bluk4kawlLjfnn7sqz+vc/ykbtbBtyfRdQT9yqw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t88a6bwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:22:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502GZe9F012363;
	Thu, 2 Jan 2025 18:22:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8v2r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJe010lN+EkPGBIrRl10z/vLzXMwHFnLFgDXfPFKxeDqMBMrId4sqE1XXHgmyuakWIEcY/b/n2K51QsRuLRsmH7zJ598iN3pyn0IEZHZrCVRZwcu5JJ9npClr3rpu89zIf8AJxRN1aoRQVfmk8AEmNwoTcSZqaqo3d2NRn2xYgF2vnQig7BrMR0TbJVX81lkmmxW9OKSecJ1OGqoQwk+/yqfapHviGt2xSk9U46XVhPPlfw7+BiQIirP042OTowhWQ/pun0N70fjH2FiYpt1dRDbNuH+JJ2y0WoNK+g5Qk1Xq7j4JJ6TC6Dt0odLS1WgdZkXqFnZ/6sOwYaNtHI+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKa9P2amxBdvg55He3stkWzJisDpiL0xsUqF8t4w5Wo=;
 b=ma0R5Dy2+3PK7ueL5Oj8eYKHZQ6QU3EI0HTMwW1v9EP4/nRDj+jeouJHQecJ5eD78qo42sIZkwEU4V4RIeqNoogxPNidUndUhSkBecAT25MbPFpqocqYLjw+LP4aasnEbBntBva1iy4VfuFBKcrRowWqx6ikBEnrPbq3Fig0DlYpYQmVYgUs6X7TSkh3m0QRfFf9Y6PO+iWEzuCVMa2B3K/faIGwytQGjjeEwi1TNxKIzWfVLsAT/K8qbsmtOzuxfbBojjB6c7egPzs6fzLy5Aw+i/3+oD27fCWs/lLdeyMjNho/yMAlawZxRaz77crdvkSTwfg9yiiuBmTWbTLcZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKa9P2amxBdvg55He3stkWzJisDpiL0xsUqF8t4w5Wo=;
 b=mD3CmRohgwLSJnsfVTsCrUrutWBQe8aLd2eY4qUtCeCOJHedSKM6XlkUwzhHXj/dat3GpmqKnxjHqkYJqaQdsdJQNxIHZSbHnZDEMt3rRGu0ofw3Z3i6fDMv/xQwSjMrzORuxtI2udwlX7k7Qrpu/A6zpJ+drNLH0YNJ2J7eaU0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6332.namprd10.prod.outlook.com (2603:10b6:806:270::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Thu, 2 Jan
 2025 18:22:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:22:24 +0000
To: linux@treblig.org
Cc: artur.paszkiewicz@intel.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: remote_device: Remove unused
 isci_remote_device_reset_complete
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241223180218.50426-1-linux@treblig.org> (linux@treblig.org's
	message of "Mon, 23 Dec 2024 18:02:18 +0000")
Organization: Oracle Corporation
Message-ID: <yq11pxlgjor.fsf@ca-mkp.ca.oracle.com>
References: <20241223180218.50426-1-linux@treblig.org>
Date: Thu, 02 Jan 2025 13:22:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:408:d4::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: 79783249-41d6-4238-bda1-08dd2b5a678e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YEKEBJkeNQYI6fA3wGQlCKxzOpFhz31cvDmkILgRJUzNKrGf+auG7/Id4Zw6?=
 =?us-ascii?Q?tnsPjkBgeEdqefr4ESCsgT+D9LBcz/kHnoeA3jVT20jA/oBH0ISC+fp11Yxk?=
 =?us-ascii?Q?qew/OhDOQU8Bjp/6JzMVwIdX5S5beMHGZ8b5/Nc/ATAD+e6wytvRz+69kzae?=
 =?us-ascii?Q?DxPEZw/Igcgq0WQyoLiM+aiNlAF9NFooRnmQDcLZsOP1tb4Ul9kj6f1RnkiR?=
 =?us-ascii?Q?wssAPpDaTvqDOdPYO0cjCCcvnR43P3vOrQe4fskJZXjcnyGxUeSYx1xyVQcN?=
 =?us-ascii?Q?AQTB8e7rAY1E7BjiV48io2ngc9O17fwERHxdx9N8wvFmSWfu868IQdl/sfBo?=
 =?us-ascii?Q?8ZjHRYQ6aeJ3hGO+Kge6esk6uUlP0qkFl5ZUl/gjPIM1zSaWJU+0L8Mk2rC+?=
 =?us-ascii?Q?QkfGqybG2V7w2TbQQ7pC6gX242/4/B4hu2Vs5K8yAwZPUqBzqvSbOH0K9/Lm?=
 =?us-ascii?Q?inyA58MaPKa3RHud8NiqCzmBa5UwMhIwZkRYYOpWs21ZSf5kAAtD2LIKg+06?=
 =?us-ascii?Q?Tf6LUT3SK5oaNYhUi2nUmCSQCHlK8z7PF+va1XaQSkyEtRF11xya0in9RDzK?=
 =?us-ascii?Q?syWjS2gED0oOkbYliNyvDGa+Ym3JE78E3hSHIJz4sH8gAxFkwyD1Tjdk5yEV?=
 =?us-ascii?Q?KxLceXkEFAYl9YnzvAQXqNx+5kBPK0FBY4phxT+/9EGLFayzUybUqVCYdRgd?=
 =?us-ascii?Q?V6s5NN2vBvK34dqyHYcLC2WNKnDKoyV2ctCLjNItvTO0euYoRrNWkeIzUiPz?=
 =?us-ascii?Q?ENY7Zv7prwO+rkUzdvMU8fX7k/yXD4GRvaQttuYkd7UUXDcAfmOF2r0ym2Dm?=
 =?us-ascii?Q?2nPhfGzbJPJ+JvrrpIGHWV6aGPlureWMg7PuWuzx/meCXjYhKotgETFmlirH?=
 =?us-ascii?Q?TgkTbJBhBQeCKl1Im1kKiaaw9N+F/neEm3Vc5PYavxRsqZ/nCvodsdwSAijD?=
 =?us-ascii?Q?VYQ3MVlVxrFIem78t0jNV+cJ5lW0YE6QECALqJkpGuDvnSh5+/CY1DkpHtCt?=
 =?us-ascii?Q?yOjol5Tp4gl1XNFfBwfnbkiIzG1mYjHsbZJCz7ZsSdUEWQxN76ieevOCiLpL?=
 =?us-ascii?Q?kmQGHMJw1Is7LMtyHe2CTyROZwLYTGPShH4RHBdqvZSbx5ZrL/HvI2X6SaZb?=
 =?us-ascii?Q?xHTBskdm3Fs5zPu2VRnhAliQF0h3GupfMN4N813KC5DFm6tlG1++fA4ILRcl?=
 =?us-ascii?Q?Ir70VBJ3//EozHmXhB6aqUwGUYmK+GF24YFnvYh2GnD6nZh6hRcr9qu9NaG9?=
 =?us-ascii?Q?yDEV1J+kPCeJlGT3CHTuy0E/En+h7vYZD2nnOn6N3RpIWFn1QwfRknkeduIf?=
 =?us-ascii?Q?aKwZxwdsvUb6xBE7hHw90DnDoq1uHH/HwNCRV2ntsaMhefKa7KN0HWFDtmYz?=
 =?us-ascii?Q?5x0ljYXkPq24ChPNeiQjPGc7r4fz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xNARg7dxS6MlB9sVszVDJh4F+UEtPW1xeprt4qLsivB4LGiYrGvfBYKG4H1N?=
 =?us-ascii?Q?9kmXtrOiDFtorgB4iqyFTWm/ODMT9pexfUJ83gkuqWreRJj1fGnQBlph18y6?=
 =?us-ascii?Q?RQ1TymOP3Yn+J1HNoyLmFRqarSQlQDSIu2JLNX6HgzrjBZZNuBO0fW00kz+U?=
 =?us-ascii?Q?d4r3yhuR2W4uNAbFpOfSYT/ZWgL1gpCHkvznebTQ3cpVb9SAC16NvNLFmk69?=
 =?us-ascii?Q?wPxH/bYm/urDxT3b6qIKWl9Yk+he2qMg/mJeZtVykoN5XJx2AkdFVn3o29sE?=
 =?us-ascii?Q?xPqqWYgK7tJCwZlxB37PvmwZd/2qYRB4LfKw1ecKjHhinEhlhTl3BmsUBr8b?=
 =?us-ascii?Q?2hvse9PWiQQ77pJZoN8Eu8bISf/FSqPGsqday/rUEXa/yFfaelmcnhjCxO1M?=
 =?us-ascii?Q?4lPS1J09KChTkwEauG2p/EON95X1DIcI+wapMKH/GweiBfXQdrXplLstICSm?=
 =?us-ascii?Q?owHRVzs7woirgkjUIHEKq9tEKo1bF4S7Pjh4Y3kLTYwm0s73jChDWSykg/x+?=
 =?us-ascii?Q?cywpV3AzTHTd2HbCdbx6/5KUvRkF6btsMnHkv9cUuUWSq7yptOZw6FtdkX82?=
 =?us-ascii?Q?g7JDrfIKizihdQqqgRu048U+U8cyRd2NG/LHEF4A8ehAi2V7U+QgBmxRXwLz?=
 =?us-ascii?Q?LwzVSts0UHFUMqE++5kiqi53oLvm8ihBO2GRveAf80YufAYyhhw3UGIl2WPW?=
 =?us-ascii?Q?cc/JDvkKNhedWraNbxof2UgRH7vgyBC4lrgcADewDjDslrQaaDlbFjNoUx4y?=
 =?us-ascii?Q?Xa4VsLK49qE8by0zYrpMl+0QAGLSZtZ0Uk7J6vs1RL8ntmcJ5EC6cSKldaYp?=
 =?us-ascii?Q?sIsViCyfrYFUAYI6/UkE42PbtZuoXWpbnDtj32yMNoAZFx0tL5gVRZEYq7vt?=
 =?us-ascii?Q?+G1HGBCr1wjo0cmjp259HZOBRofdkOme8HqLNbSVnj+mRwYRwjrY4EHa6Xzt?=
 =?us-ascii?Q?xCx3fiozvyvHj7SjXWN7HfBdu/f4SvmmjBfE+QQ2/ccf2iXix9k5F8/vRxOd?=
 =?us-ascii?Q?mUo+c8nfTfJVv6sY6jYZpyGA1WTOjaRqAirQleX/4ePjbH5HoCK0/ReOYonO?=
 =?us-ascii?Q?KOdiFehUA+gFC+aHUHiy12SPPfdkt8kFRPJ+n/18GdQrFChfHbpy67d4aqzP?=
 =?us-ascii?Q?ofL67W0TQo4DWSwT+YF8iX/1Ezy1rkaOmk7D0z0SABcENd3v9DVuJKZzo2BZ?=
 =?us-ascii?Q?72MwxwQbaBBYJOHhgSPwx7mvjNfmIu899TIfTQrchQ6B1dseM0Q0S2VNWzvk?=
 =?us-ascii?Q?97C2MgdlX4gCdYHf90WVuAh5nTjQ/eenpmp/ekMk5VDKKvpRkwq6d9jKz8bk?=
 =?us-ascii?Q?WiBv2pnrzqe13mHsQhusdihWaghGa0/MZUkbBrMM+1u//1VBgQyxdTzo9J8x?=
 =?us-ascii?Q?fiOTjOG6XDn4ezesjmuYnIK/2SmXd21ay8/vL081XZlPT6Hr8/xRtjvunFx0?=
 =?us-ascii?Q?eP/Prjbf3UJ5W5ZuUgueLyhOOg0U7AUsg8ZmTx8ek1WISEgf4+9E7S7HRZvd?=
 =?us-ascii?Q?UrXPHgw7WBQXHPA8h7Kt+mzXrI2g7hcK5f/bt8BCjy10+j87zEXhwlixjYOZ?=
 =?us-ascii?Q?oNa36+eentNoljPj5mRsGhP5OWhZD1pVW44FiGhZwT0pjYosWWQe2MsNU0Ws?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8kWOwmeAEpUNTh/ZErpRtwcga0efkWg+g4OtcGhV0aATVMj/oDIgBrIY7+yETZBRc5FiXc2akFTrJY5BFYTrC7PbE2k6+NwGns9k89GCSQ3lYHV9ga/oAW2RzjzdvHAWfp3W7OcSvDna7RsPC0UEMO5vQ3/bR8MRYc4c79Ps4hVNid2tZSaj8MgHP/9eI/GwL5YQd7HT9wIuYz2pL8dtlDQ1m7WaWUkELlmtHiHZXYW7D8wFa/MpYQqACokmV4kPHm09dh0z6o08BD3c6AJhP7afsPZntmV/r48LmLgvs7+23HqE2gFZNGUFgkBu7lqFNE6/o3BCmcMjX1z40J0RQTr36wsAWn7/jQg1WtfZxOe97+SwAc/S+OCYzaGB/c67uj3huDEvVmby36K+0SL1Zywd1jFY/+kk08aVpY7fpgbCyDmP1rxwqTRwJKKX3X94Y4bHgaS0P5h3UrOmbTqvp0imyaDv2tf20/URNzWvokRYoo9RpnbcUgmOU053T0TexFoN0tm6G3aoIB1YjQuzTezPWsz8KHM2U9L0jOTByEd/NdQdnshJxRenrrtXm/9T+JDV+9lrSsQx5N6feA1m5svGOdq0uaZvA7hiO9ZST/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79783249-41d6-4238-bda1-08dd2b5a678e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:22:24.1988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/mf3JfQ62T/kp/lhrdM4sxoPHsxVjpgvksMkWnX1ifoO13w5n9/0OxpJf79rhC+Hy7aJHix0bc9/CpPEdRcCQsdXQvW2ltiIHQnKGUXAtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6332
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=751 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020161
X-Proofpoint-GUID: cCM9Q7lUSu6IcqRA8vUa5DP1q6xlZ741
X-Proofpoint-ORIG-GUID: cCM9Q7lUSu6IcqRA8vUa5DP1q6xlZ741


> isci_remote_device_reset_complete() last use was removed in 2012 by
> commit 14aaa9f0a318 ("isci: Redesign device suspension, abort,
> cleanup.")

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
