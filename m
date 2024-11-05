Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7D3C30
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730771353; cv=fail; b=oZ/8lk9QS0qORvaaNI2an3U1ZMwpuuVPJPbzfnOm4wdgtsfYkR5N5qrLxh8jlAE8wajg8uP6FytF7jD2nWY8jl4+uLLVJs/LLuxTd8HgHX6n3SgwVsU+fhl0/HEJl2wT5JmYwDKraKTkl8mwjR8fwK+BTlRru7VUmjpWMJCXgb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730771353; c=relaxed/simple;
	bh=F1X+d3VSjL/t30YcJf/f75AFsDyW8aOPpFmDjfJp3Es=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ONh09gR6SPawBVNm5t5nF2BBnjC00BeIaU3p3LckH1YS3XdmGNIOWw0Yx890wJPSBcxI71KjOHc2DMjNVzQjoA+ic8nXbFQyFkTVhWFf5tZ44meh4see4vsVKRDtOTiQmtp7+CmgsiH2p3iLod+NsNDqdzB0xR4plZ4quDFVVYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eqBKjkbj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=doLmf14Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eqBKjkbj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="doLmf14Z"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A50fXtm023791;
	Tue, 5 Nov 2024 01:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=VMTFh13/ESZzZgOhuC
	SJhizEXvfDNIALGlnZLoqlaic=; b=eqBKjkbjdGw7pd/m9nwP7HFMuEipDgnUD+
	t4gdSqhWRuhfrrt3fI4e6mTEz3eaA2Vrlwh+qAzUWFVUeylFXGPg9XYC0vaJsuHr
	pp8XeE4W5japnZJKd3lrECuvEwHO8g0GBeA2JRW6hqRIRMBokQJZRLfEVC1fQKC1
	vgZkgdQwv0cZVwt5DuUDz4OqviXTcpYhVJfs4EOctEWZZI8b3K5k14XjlVhb810O
	w12gvCbE5CChDkiKuCyBV8clLQqBsVEeVf3JHMkUHVAERrPuY1Xgg9xiOLPwPUji
	EzXcINSo/7Fr4pSECsrWULlk/51j33eeSPhPetlnmaXaCwV2bBTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4bv85h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 01:49:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4MoRNp036924;
	Tue, 5 Nov 2024 01:49:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6f5u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 01:49:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9ui//1mqB0QHon1GphA64iJZJUuoak7YdRbSuWzay35viAgjlwDATw+1KH3yKXeQ8VuWcNz/GM75kTpxNwtoZICvhaeG8ZAesJ9+oxFDwDoHpZN2UqXP56E2lINVzbGrVv/TfRKuw6jK8KgeFUPyg6ah3q89iAXugL0e9AwdUhpJbHja9LXEq1z6pMdJ7fMfW+u9OVBHfFfh4uyHjeMpL3c4ZFi/VYpNR1SMFFO4TZHNaXAE8RBU0Guhi31IhMYPyPfuOkoxTHm0A4etnHKiEh5hF6SsKAXpdjrGlhYngIzewVR7C1fqqXg20G1e8MPYY6kTeLHNtqoWvoCI/mtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMTFh13/ESZzZgOhuCSJhizEXvfDNIALGlnZLoqlaic=;
 b=neQBjRCB1+mPA8lLLcKXtySMuaZKZGVZSZSxoQrVShLXezPffRob9uYrMC6IrCy6Iy3oLaroifYavTqpV0kdQE/JVg5d99JZfR50GmWCTmS+zHKnmQPCD6csXem7Seh12rYCSTkH5gd245Zinc+yCuIBBeu1/zZdDPk52jHAXdYRjVe+0QYAjq/3gMdIhTiYm8t6XYpuIQcMHOWwjp35RE39um3GrvZNBmAtbk/Y3pCgurRAL4uIqlzQysC0hpOYJ0mm00SU2W4Xq3W+hs5LmZFrDKxqzTvLLz+DKJ4xkpIbsqszKvLu9jPaSDxoCNbg4LUsNWlr6+75UrGMMiDNYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMTFh13/ESZzZgOhuCSJhizEXvfDNIALGlnZLoqlaic=;
 b=doLmf14ZCb1AdJ/doeAcMvGZypw5ZdjP2ojyNYW3R6WluVHMayFq8cAI6oGcGa86naUFU/wvUD0j3NMYdkLGcx9kUTiZQg8sGNAjzTo9weSvkGESOxeIF4iphFsVakaBQ5DVz8ofxlbOWYcWVmZ+JjQX6GJxjGRZ2H8o+HP5ppA=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CO1PR10MB4644.namprd10.prod.outlook.com (2603:10b6:303:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 01:49:05 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Tue, 5 Nov 2024
 01:49:05 +0000
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: qla1280.c
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241104204845.1785-1-linmag7@gmail.com> (Magnus Lindholm's
	message of "Mon, 4 Nov 2024 21:46:00 +0100")
Organization: Oracle Corporation
Message-ID: <yq1zfme4fre.fsf@ca-mkp.ca.oracle.com>
References: <20241104204845.1785-1-linmag7@gmail.com>
Date: Mon, 04 Nov 2024 20:49:03 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001640F.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:16) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CO1PR10MB4644:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c78cdc-acd9-4343-744c-08dcfd3c07c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7E4IcL5USFf8uypa4AcApiN7iV1zWiq4zhujRxHduYLsnOMtvtVXxBNOaRN5?=
 =?us-ascii?Q?G6Rl1fcoIwp+cCmF//uR0IdAVA8nh8o6wzcv0DiIjC8gvpNxVHr0i7X/GnHV?=
 =?us-ascii?Q?fz8fsXC4BZ2d7vkGyJSIv37wd5EEtwX3R+X77DNiyMKLJ+Y7S9iiNfpaHvpI?=
 =?us-ascii?Q?TIPUOxltILCiboJXMc2OqFrwDLocOggp3JHp41LVTv7xZx/YcBFVav1CEJyz?=
 =?us-ascii?Q?B17XkYtrTgBycM4KvkT8IiXQCbcrf/f5qxk/RF4zTl/n9SnHtKql+T+eDj8e?=
 =?us-ascii?Q?UFXn+lCQg9McjaRIQycpRXbuEQCMvs+L29iQ+1XQmCebySrWKpqbbMtaKSFf?=
 =?us-ascii?Q?NQWCckmurafvM689GmKkTGhthmZvPAeJzmFy9fR1rXmuUxoIJGCMgSF2pD5d?=
 =?us-ascii?Q?zhlAHyPoFCXfsLPYGTnRqOecfBHUr+0LjUJYEC977oPFU2BzIuvxwO9mA7OL?=
 =?us-ascii?Q?BREYlKwiRdIMonYU5wiqxRd1exwlsTBxmpfniz2KBjX5fyY0NUeOWNTf+Du4?=
 =?us-ascii?Q?07Q1XEUzcXckx2XjMttf52koJe1zXNzNza8U7HnuoWuOjDJCxgrd4f0o2OvZ?=
 =?us-ascii?Q?l+C5mqsul8UkAZgbAPvBbEc0DUPGeUkL58D83YtDo3nw2LM30lmOGawtFoJM?=
 =?us-ascii?Q?XdCh5GK8iTDbhkoEjYxESrFkhwgpMgv7LZtMfMoN6LG4SE84xU9suZlqKsBU?=
 =?us-ascii?Q?W1aU4WWS+mhSAF5nheYbhnwBn2nK1jBmWWnne77SewmlIYcl1hRIG4iFGvah?=
 =?us-ascii?Q?RrRffMRgO6m5IvEIjN16JQBzLRSp16kLjFu3zojIIYwXwVEsh5B/O2z0Ms43?=
 =?us-ascii?Q?MHoWFlijp2n3Zz6BDWHglDuNSQ4b2LPUXh4fGWFt1/rUJzyt2cDQVwugYN49?=
 =?us-ascii?Q?dHgRgYxSG/DioH5WPqhyMl4NI26RcTST6Gtz5YZMClEb5orhA7DafgM4yXIy?=
 =?us-ascii?Q?OlKcq0tO3dOQq8gepYYVgyzArPmb7Qr+nW/Le2pG8HhXJJlMKHx3J+JlRFqr?=
 =?us-ascii?Q?QfhsRIU9CT9g/p1IbjPbcuYnaZzORhO7uHjVJSaeNFyoRkD8+AocY+oBkwgv?=
 =?us-ascii?Q?zrV1W0GBXYVChax7qS/4A0HnpLRfQvmdo0ee7+7yaEymGIp13PqAcZRWXXi2?=
 =?us-ascii?Q?3MtpShIHDuIWQMjkGpWjySvmQ1sxAT0uzQ8IwZAkuMNWmGAxsBXfcE1kb2pu?=
 =?us-ascii?Q?cemyVptmSf0hZoFKP6RyNdWpsKfYO12MRcMMhLPAA5PeHFEXZujb06MuL7Ez?=
 =?us-ascii?Q?TooUQimD02J5qJlUDYOe6sMUKS0XVuGLNW+C4l5AMq6xMml+eCj+bjZY0Vjr?=
 =?us-ascii?Q?C8uCoa4OSMvpi63Tb/OlOAQr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FHFOloyL/F6ZbDmtGFE3uLt7vthmEH31/guDpFA1d7x/2FEb2/3K2aP8l+pd?=
 =?us-ascii?Q?B0O5ulyMrcM6vlGRd4l5MqE8ak+V09JezVXElIjVXnEC260iqsHrEoPj2ihR?=
 =?us-ascii?Q?JcIygKlzvTJHAARaycQdIU349cnQiXfDkY9GwRLRZ8TqY+XYVx8rhHwiBzFt?=
 =?us-ascii?Q?S2+R0mrIvpXf9dEmybkq17C9VKoupSIgrtiUGy10FGy9Zx+O9OIxzTePIbn4?=
 =?us-ascii?Q?yPK9AlRTALGShB3aeNNmxuQWLjQVGlr92D2lrqA+YHlzt3ek063DHwpYsEiy?=
 =?us-ascii?Q?I93q/qR6HmU9pvcpGjGwvS/OW7YwWMMiokMmVZBgdcaxrIkAxgtq+k0DC+eA?=
 =?us-ascii?Q?auEozuMGpAiaahGu43qaXbYd0ARQua6njbBfsIZriHAV++mrT88Hq41697Cj?=
 =?us-ascii?Q?ED3KhU1+MhEbnWxwlGNAI2FZgmoJtZRoEVk8YP3I3+IDfHjxJ++fsAyEU/NO?=
 =?us-ascii?Q?jC/FgnoMTG/RHX3MWYXztuGoIyZ7SX2rns9x8DDBke3Lfretbf25ArC+HT/1?=
 =?us-ascii?Q?F6HNd3AbQ/Svaj1vlJh/yYTUKtvPtXD1Fw9Czb19W7usf2zkrvj5+618Lraa?=
 =?us-ascii?Q?JQzN6KKTlOUnsMO7iz3d6sQmyVrGpa2W9cXlzkCB64ORXWYl/7VmfKSXYdfy?=
 =?us-ascii?Q?5DnAbjuFAeLljYcVKg58T3eMO06uf09ISk0q2UXxiE5g0DQjLgvqOD1Tw9kk?=
 =?us-ascii?Q?Zb2BmHIN9R/NC/3ObFUpml5RAY2iZc2CmJCCgouLd8q/OcrSI6wV+n7Z0MwR?=
 =?us-ascii?Q?LiROv/i9TJyYCVrZeWJ1Td6DmV+dNW1gw8u0n7r1nKAAAWWAk78TD7/fQwfG?=
 =?us-ascii?Q?CRvuwsVVFcsM/+x7NK/Crh6BZbOr4U5AKktWgOJivH1M2G23MeYN8VI4f5Gu?=
 =?us-ascii?Q?F9QZwbfjPwZs7VtrZyM8ijCcnT293V3kmmr6CSrtlpGyJCmdiX26e1FJ2JpH?=
 =?us-ascii?Q?y2SMaJZGErSLTXvDuNBXX+1cjpe0B42ahvkaZigD4GriZnmCKftw75fsF5ND?=
 =?us-ascii?Q?jACvRC2Gk4D6H+gFwpKK4qomKxYS+OcifFjLlAIuQQ52AsfIUhtVGU4D012f?=
 =?us-ascii?Q?d9rO2ETwBINDGKQKK9ReU0AdFUMayMNM8Fxz62i5DQRfOVyrDYD0sdzBwVfn?=
 =?us-ascii?Q?2N4DLTJUqYYXT+DDx2VonQjsFeZLGvU+rS1eDiSk+FwT6bJrpjyfUusxwxpH?=
 =?us-ascii?Q?kL2Vs6hHl4aj8XePpP0bmwaXXMa2/Y8X14sGxfKcGFrWk1Hbf2ATJPbhwRT2?=
 =?us-ascii?Q?E2itdska9zEmD5/jcRQn3tmRQ1edop5v9KH+dxCATfy09583jzbRyTNXljeA?=
 =?us-ascii?Q?itIeziHr4Lc/jTTzWL2ByuW97aWaX8b/kNuuk2r/T45cvYwwYAGyW8O+zB+1?=
 =?us-ascii?Q?uO+WjNWAujvYkwXy7norYUtkQW5Uzkihiwsm7hNui1WnVSj029XIJBy2IiTi?=
 =?us-ascii?Q?d/P1xfGU+vfG+dr8W3O5LQruHBIdGZFc3bj1UCONsK3tiaioJ2Z/dBmoR5Yt?=
 =?us-ascii?Q?eyUnt9MMGnflezENF4RVR6K6n+nxiXMvsKwP3WtrvEVxsFBoWdjyMtDm80XK?=
 =?us-ascii?Q?lPXCZNNDWINNdhdyDhPmCA74mJFFFOnaI7i9G2DOXq3CiDNkC8a1A9udZ+rr?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BXQ8xFqE4uxWuV4uvyXM5AADBxBzP23tFsqVQaY7fPDBsimSZomttbsg0fW2bPRXoY9gqP+5sSfZnSXFvMRKjp7BumCylelfZFjK+DWhHqZiAwFZmTNmXwrzDAv31pczehY/J/C62FjXB3c/hzxZomVBscPPaZWpD3brCeD6BhqmyZ02pA2ShXUi3sIkynMU/cHTs7V6U1cPeiQxZtrHC7GL8jGLJjWofM7SQNNGcngzxX7saxoBsxKl7KxK7DsShJsF6p2pi8+R3ZLTkQJMQ8OsSLphkSW+A9fHZ4Ved85DAg7dAUGZcboWhlFiICP0q7rAXkvxv2Vz8Ry3aCSEnfVAEmfK6RLaWjES1jNuZXNzibPMI6QL0DD1pTCCZ2J2FC3ksunDJOTEDSgPOdzC7zwIKW6C3lcNheDo0fuhTevdTbefsFR68AhfhP7tNzyJrRgxpeuP/8nxrgOaHdPCB+a0E/GdUWhS6jMUhdcJKwCGQVeKhYB14mtCj/Znt/xYP+CZfJhkzd5TLOPdG850Wp6vbyqKethcDIu/WX/YR0nNTZsJpylMjiCJsNVzKLdIAWeJkrNG9lsmWwto4N67rmnrDvmFVlsazpwnWwgrIzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c78cdc-acd9-4343-744c-08dcfd3c07c5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 01:49:05.1170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ex8IIT9dLU1O181DG4Qo5uV+Jv/SSn3xjdGZ6ZaLZ5yn253fAvsfA6/AhI49SwgzpVp9CbmoAymfn14vNKngYTgYtrZqtz9rVx0uEWxucSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4644
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=946
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050013
X-Proofpoint-ORIG-GUID: vQn13rA8drlZa7F5i5_cJEMu0B8-yV5d
X-Proofpoint-GUID: vQn13rA8drlZa7F5i5_cJEMu0B8-yV5d


Magnus,

> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 8958547ac111..4ba4084bf252 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -8,9 +8,11 @@
>  * Copyright (C) 2003-2004 Christoph Hellwig
>  *
>  ******************************************************************************/
> -#define QLA1280_VERSION      "3.27.1"
> +#define QLA1280_VERSION      "3.27.2"
>  /*****************************************************************************
>      Revision History:
> +    Rev  3.27.2, November 3, 2024, Magnus Lindholm
> +	- Use dma_get_required_mask() to determine DMA_BIT_MASK if QLA_64BIT_PTR
>      Rev  3.27.1, February 8, 2010, Michael Reed
>  	- Retain firmware image for error recovery.
>      Rev  3.27, February 10, 2009, Michael Reed

Minor nit for your v4:

Now that we have git logs there is no point in updating the version and
revision history. We leave the original text there for historic reasons.

-- 
Martin K. Petersen	Oracle Linux Engineering
