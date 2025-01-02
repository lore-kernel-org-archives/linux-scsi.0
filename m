Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C721B4F2B;
	Thu,  2 Jan 2025 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843574; cv=fail; b=pcqKTgbGDCL9fZyDY0d4eLKfNOdGNFsyKvNMh/79CH+ZhAfK0HcpjUVPmtwX8kZDgjI+oDfmX9zj+aLFhv+4JiNuDnE/i9mviBe6Do+BIRkWW50p1PsFwls1wOH73znakRuOJZ6UaHeCQY/4SVNZOZGX99e2/DUdQONtQZSW92k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843574; c=relaxed/simple;
	bh=fFXCe3v5gvENHVcxjWjUoq3x/QR65+D3vVtFpAzztOo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eoRpJe5osII8zT3VsJZg7aH4r3d65hug6xb9ocLKwGGKC0CpmWGpJ2chR9PZcDlhkEvFUpPZLWqNs1kguLtFuP7s6e38StMZVlWu5aNimMZ/9rHobAENzcSsUCS/1+Dfv4CQgHQAL152b5sWRoW41Gf0C1otSErh/17Xet5q81A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O3TYovro; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M+GAPDqE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O3TYovro";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M+GAPDqE"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXrQV029964;
	Thu, 2 Jan 2025 18:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=fV1fQ7/q3gZ+taECUq
	aivyDX5HN5/IlqrHXNidydeVg=; b=O3TYovroDHfAIKk08I+JZYk/QhGhBUy0Xr
	iTs1QAPRMMcRKHRSOZSFTSDR8fNQDM/CeXJhXOncdeOb02Pli8rpaU9OE4AH7aFT
	ijcp1lNOXEv3H9Zc3bn8qmEtBiXfrp7JTNaiSShVMaHze4tA5v7gbPa1oA5AYcwa
	ItfscLgSf0+es1SXOPcN4LPn1IgSC0HsZvDbUzYCdEnD8ZgcrZ1EkDDuVzah+lY5
	qixJm7TMCx66fAPhk5FyojVkTWr6a2bWdDFilXfq/kFtkQPX4pFQtv8fz9I8cBgQ
	H1JypNUI+E7HUAGTug3yiO8+9VEq0iuXgh/tvbg7ziE8LsP+gUxw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9vt6f91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:45:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502I55gV034122;
	Thu, 2 Jan 2025 18:45:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8nsya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlcPVie7B2F6urG7qtHNr0BVIjXMBmVxbHI3G3G0XDA5kMu0ujdoIPdqy1DvyBTWZ+CRO+j1oio/xr8LYA2jwbdmKZtVFUsIXPoUfe08hYnmoNxKLPDtnOMN6MqlisdxBrh8O9Kc/pbSFL5YTWdnm8yCo/RLBd9RkhAq6+qY3Tj1OAdnENOidhLhnBdcL9zTUg8BFTQFjWyOxyYeuE1/tWEYgXg4PBjGt6FgRGdIwJb3AnlObBalZm4RkaoR+9gPwDavNMHhcFA3F5uyvC9Dvc4I2vNjClDpx5rmk8gXBi/r3et6ovW0i0DjJhuQany8YD7hrz6LtbIY5ACXwgEc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fV1fQ7/q3gZ+taECUqaivyDX5HN5/IlqrHXNidydeVg=;
 b=a5VdDBgo8BxJW7/QuLTcpZP2SjAQfHkGnPSznWi4PbwdRFA1wyGaGN0juIANrVuhh5X3yhVoBvSooCD2Lz5Laig/zAghPWTLKBq5cLcPV8dSzSHbgTHQf33cOJrSR//PGwFkTAm7xnYqq1/uGj9mtgu+TyApetI9ij70cMK7S7qWTdso5lslDXOgeZgG+iyAGgztQk5/TaUndolWvnycfG5ZBjSKBHak/6qjpSHAELq+gdZcCXrhpAyahKvdvkRJprgcv+xVI28HAPzeHw/p1Ry9Yxu5KB7CQsUmm0MF7QbSLU1M+Rx5TxSlqYtWi2unf2IxpuP+y3FOs3B+GleZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fV1fQ7/q3gZ+taECUqaivyDX5HN5/IlqrHXNidydeVg=;
 b=M+GAPDqEB+Xt6xsJGVfFeOvgTMzJKlxWPmwlZpi4Z01WVuMxoiHbJPw5blMAoP/AhmEqe0eu1VRaX/JcCiOflAAepHFbnqZYZgmttxwW3sXrh6foRJNOfD/6EL12joNIxoP3yih4QdSz1I3IfcuOvxENbzz6p1cp2abFNGKUvtk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB5863.namprd10.prod.outlook.com (2603:10b6:303:18e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 18:45:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:45:43 +0000
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy
 <Sreekanth.Reddy@lsi.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode
 directly to 1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241212221817.78940-2-pmenzel@molgen.mpg.de> (Paul Menzel's
	message of "Thu, 12 Dec 2024 23:18:12 +0100")
Organization: Oracle Corporation
Message-ID: <yq1jzbdf41h.fsf@ca-mkp.ca.oracle.com>
References: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
	<20241212221817.78940-2-pmenzel@molgen.mpg.de>
Date: Thu, 02 Jan 2025 13:45:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0541.namprd03.prod.outlook.com
 (2603:10b6:408:138::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: 122d67f1-4d52-43f1-2bc0-08dd2b5da9af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tPGc/XytFFilPpWjCci7kPhXmIuiyEjk72ZaJxdHQgnh3SjaQAYQ2gM5sfVf?=
 =?us-ascii?Q?CFIB6ga6vnfJH/M/IXT+CVcOLdlzkrknL/vl+dlkd+d3MDxwXJte9wRoRE0j?=
 =?us-ascii?Q?DdW8H5B704oM08C3dQFKIm/H31Klkdp2jrLlDgM5l67I1LBmU6A6uoiwly6L?=
 =?us-ascii?Q?RqVQfVfG8V/YYCmJFO9hsI31Ab0KV2WNU1EOTMDzUTXp/c0zJwZduLR4Tr+a?=
 =?us-ascii?Q?1ERt+wFD8ccBUp1zYe4t2eQ/uM+7XxyDtl5SGngj0VX9ONBkqIQZMPdT+gul?=
 =?us-ascii?Q?Lxe63np2JKTkuv3jOomOFFoJqQLsbuPYjC+4AZeIt3FTPL3yidvKsLcbni4g?=
 =?us-ascii?Q?B8X/Ikmtu7Xk8Cv0QPm+LXnagMpoZq0vPX6mu2nGRMTBZ0oPUw1B1lk2nrRz?=
 =?us-ascii?Q?nGT759huKrjS124ilKgnSB5xumzrawZFx3WikmfWV5/094f0XrAiuvDOHq9j?=
 =?us-ascii?Q?SiU9x7TeMj83W0GCMtWD6eGwnhCpJj2/D3G/NNiWr4fNlJ+FQMaYZ3OgfrMG?=
 =?us-ascii?Q?XaGxDsuDrKsHozgOlfb5+Mb9e9cdNcdGNfvHGp9p9v/BCGL4xkrztraiVuWh?=
 =?us-ascii?Q?dkt/6DGc88z8IPlshWMCs68wWSGzSQABJ9VZ1Ebs2aq8Z6KcDD0V+/2Pkdy/?=
 =?us-ascii?Q?lcA2r5ASj/dHMmsAqljR2kuDavsg7fp39Rl8CPldUezZHwNaFe1zKKdc+wpI?=
 =?us-ascii?Q?EkvaCFuEFXLsxdVBNZLqP6B+ulw4EI1f2FW8ULKcP50i7V8pDQbGtIHBMz1J?=
 =?us-ascii?Q?l3IGCERVbxi6QbG+0LPG76xDGgt3rKCG+zTTEWa1pXVl7aSP6z9/CIC+wQnL?=
 =?us-ascii?Q?egLlDJgG/iCyVuKdD4PryM7KJdllNL/LDtHU1N28+wrL9FlFzqYuYPDUlhoY?=
 =?us-ascii?Q?N4eHPqGtBBG1nSA9h8mjkJHbd7qWd5bj5Rrjvh81RvGwfszJ0x0qmE7VEWv/?=
 =?us-ascii?Q?n6kKCantyeL7SbVRvUiKZX+2EwciGP+B143mcDtqd7scC/Mfu4ADXYghB/Aw?=
 =?us-ascii?Q?D6P9ICFwwkjRVY5sS/reeDefQa9bo1pUPtvWG69B5iygygcM47LfsetSck/D?=
 =?us-ascii?Q?IXiN0d/yT191mO2w6q9pkqNTCsA57hSZfuA76QWueMjCokPM7PD2Sya3C9ru?=
 =?us-ascii?Q?ESMsizOQExUu3PzsssYxgD9tdGVcbScWa3rR2ajL/cB422o/0u+9A+jIO5NT?=
 =?us-ascii?Q?GnGtYuHfTbC9CyMhBs+2u6zx3GQbX3DvCe0zL7UjkZKEx738zRbRB7Hmq1mz?=
 =?us-ascii?Q?Jr1ftNN5lUpYNDq6GlfuV26K8Nd6bEQ+Qre3oXHWD/UFR8uBeQk/LmHXWvcz?=
 =?us-ascii?Q?xiLNaFAfS4hXZUJw+nosB9kEaj3ZAq2oglvv09GIazcE1OYgU8/CBluxt45x?=
 =?us-ascii?Q?apuCoG8/hrTwyicm4iz+IbgPLL2b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HdkDhYIdDIbM7O7D3U9Pj5E5KWzVAkk+yDalAV3po22GKp04V9hrMjBpGbBt?=
 =?us-ascii?Q?3n2swrcyG9bi9VRlLwR16vozsEYkBgvKAEBdaYR9Y/4qrnjdEBnXc0eQTh43?=
 =?us-ascii?Q?HuXp4hvW+h1JN4QmQbp401tMfhMk2j/gPFjbbKD9U3fK2PUT5McRvOWgMOfO?=
 =?us-ascii?Q?Xgcb70rqTpjRw/HAdxm5dVnDHfj57qCNe7LY/i6D8qzbqW5hYrqNaE7BdRtq?=
 =?us-ascii?Q?ZSeSxNmMMl3YEpoTGiMzU+uKyBephTbK1SQ0RHhrt7smP7pYnIALuysB3yBj?=
 =?us-ascii?Q?UhvKfllC2m/Vkae7rj9TZYkxxbc5QHWMylrrEIzBw4qFUbn0cpdzF4u5ag25?=
 =?us-ascii?Q?jTORj/qATjnDkYZ2UF4CKOmy0AR6TezrV7b3OZiMv0RvexbCTki4v/VR2xWF?=
 =?us-ascii?Q?Zor8y7lTg6Yqp+RrrncUsbM7XLvpCNKcV15JUp9LhuSVLv7UHSw9fzPmVhIb?=
 =?us-ascii?Q?pDgXEmlG9eE/8GAbcznPpblfVw0tFxNON0NAOwxUF7k4dXqSKrxvLRgykYul?=
 =?us-ascii?Q?LpjU9X3VuhOCYNvEEjo8QIN1sXp2qyEGG+YeW5rjj1i7fpIrViV9w/sWJJ1W?=
 =?us-ascii?Q?lWsyHPlzwQ/eG7s65TRE9UFwc1of5oToDSlCk1NnTm/Hk1xBG7jdhPcfvpKV?=
 =?us-ascii?Q?5cKrA892HVDy+SaEMJ/DUGx7tk9bp9+yD/KbeluKCqcLoxs9nvs0pse2z7Xt?=
 =?us-ascii?Q?chwvnoTfpizSnqfblCCd0vM88N7WKTXMOYEd4oER+fEmWhto7SvYKxmVHnYE?=
 =?us-ascii?Q?pvoThJrbpzzn4AQo7j6flk+29OPeEyO0h4/egBuG+RlGoc0PO3211vaFrTIk?=
 =?us-ascii?Q?abilAdHHdlbfniLiRaIYPfD3ic4XJ7e7vblbvI+Ze+tUCG7aovTYYJzD7xxT?=
 =?us-ascii?Q?O4xVBiNvRVjQ0SsqODVazJn/WM6IbzlM/SJV7X7YH4h3N3E2T2SrwqQjIcpf?=
 =?us-ascii?Q?0hX85Amhu5xceZ3+4JW9PfdqcVFeGX3r+gw5cbz8jRJLyIWOryx5Fnk9j1xE?=
 =?us-ascii?Q?LBz4Xy3GG+72bfg+RZXwnnDigEdAjjlvwL4b/OUda+hsy4Cg77CZldS3ZuUC?=
 =?us-ascii?Q?TFxHTmXF2puaR8fXUdgBo3LCZnPBLbqWKgfoXxsKSzhmK3yrcNK+NgmKzRuz?=
 =?us-ascii?Q?WuAQqEbqzeQlRB6zmqOkPJKEkJXMv7pEC77LG7TKVMGFpPjQyCR+nS4rGh5Q?=
 =?us-ascii?Q?JNYdviIIAISdYNJLHd/jDwF85fsq0A/0OPtCL7LX/JMRhHNBZCalnLV7qP0o?=
 =?us-ascii?Q?y0pHWElIxz+zWc5kyKfj6OVAPKCXNEV3cJBPAtHITSuu7udjrLHsHAYOK1Pk?=
 =?us-ascii?Q?CtussS8cK2IPYCqCR8Yb/idzlY4djaKswGL+krKmuLOmndfmDIEa53uPWkeI?=
 =?us-ascii?Q?UVpBXgMsHiOwFUPwd5iF3IZXFEIkKUBCf3ZNdBnCqL1YFjOWfG2hyCbGwOV2?=
 =?us-ascii?Q?plMT4d4F/ZHF8serO5qEPHo2cCRGDSi9fqN1+EWOhCoqqj1XGlohK6lBMMmC?=
 =?us-ascii?Q?pZJcDAvaXkP+xdUs2r+djwhbJt3Qmp/nDv2vuwQ898I0GbmPR04GkfjEm9KF?=
 =?us-ascii?Q?1nRg+7igdXoOFsyb8/1MOGgIgN6N+TUIhqzL4aLekJ+JC6W1EzuhKiFXwGgW?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KIZ36oK9U7GXwKFN+qOCnHrb4I4aRUsfKJy8R5//dEVFPoXPHXHkY0YQddMd3+93+0M0Tpt4C3PgoX0j7slbADjve2Ca1uWDlugauxKBBr05rDNgKGf4C5zUtxVJi4eg9ws318o/74C93MVUvxLrowoWWlPVLBjOQojj1rB1HhPVq3V35XQoCf4VUHR56MKh3ZYFiCDJgUfaHRjdMQ4bkC+dS6ck3uimVUDgEUnRpD+4Y+5213B+OTpTGATqki6SJYUsCv7ZYGuc6MDVTDZsnhjUSiz/CvF6Ouefekr1dyG/61MNBBzPs64ThuS3k6nqGy9T1hZCR+6lhXx33hr0nraUUgf0Xej/bR7RuwBa7ADrY4jvPcrydUDpQScEaiqSsCoJaAGP6Vl3EWAl2MaDWj6Y76+a/wykB9KHYGGMgA0pMH8VjfJNscvozPWmUIpXNmPsYlOqwvnbK8/FCwnysymI5CQfXRSeaLn4rfRvWjuaal2DBuKhcHYYmKdohwYlpnWPnpClGLx22fmxy3sZC1DJPJNOOVqPv59TMAXUI/kVUjF4qO9q8OyYUXhDWARZlu1Kzfpys4cKmNUWl9At2qGZqNl30+jiu4AXMgAB9T0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122d67f1-4d52-43f1-2bc0-08dd2b5da9af
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:45:43.6309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2pbo3SMhf2P+5L8AelNtz8iozbqHy5p60pezUg1fpTbMazR7wcO8Vp7sj/2c8Nfjj/ecV2MmLrhiyzspwPA+uLJkpiTkWdylbFo5LPfeLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=870 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020164
X-Proofpoint-GUID: XI59l1qgIhA0CBFPZj1D1Ve1_3ffl09l
X-Proofpoint-ORIG-GUID: XI59l1qgIhA0CBFPZj1D1Ve1_3ffl09l


Paul,

> Zeroing bits 0 and 1 of a variable that is 0 is not necessary. So
> directly set the variable to 1.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
