Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4726E2500D0;
	Thu,  3 Apr 2025 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743692144; cv=fail; b=LIyD/UpBbxFSgDt3TZmfKh2ljqfNBJmQIV4BJMdyfegm58a7NRKZIjNHelH71ADOpuz20BQCBaFoIZGQMhwgQcD/Pb3/eMDJpVl96ECANT7AtfiB/ycCHGwNdqjAbY7Axx+RzFsN/8mw/I0iqvmbbQ7zCsAvEuhPikFQE6ASNnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743692144; c=relaxed/simple;
	bh=ek1QXrDBlRYz4RHH/fOYzubD7FkOyxgImemhhGHlSV0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mZzuGViOMggBAVyOm0KReAG9htIcnUOfLxLOQgKTyfSPtVdiFlb+FtUZZT2dlEfywSzTCOdD8LA7plA5443SDeBRrZAwY5AcOycMYT7PK2pVIp2+2bzT+2TCZOht7YfqEwxAYkFfBMjwRCagWXnVp2b2E0q8Z7VUKpGEcf3Ts4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CujKhtud; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J2NoElYd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CujKhtud";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J2NoElYd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHnKC013149;
	Thu, 3 Apr 2025 14:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=hlIKe1s+1UoC+o2DuA
	bk1EvJ6tTiZWWEL+VR0N2NO/s=; b=CujKhtudXZn9sV8sVFEa5lai5rIHHcZakY
	2wTFuBPMDREiZvmxX7ICmLm27pfFnYm+voiuQ+sIcJkdIKtxhNw3TEzlEvExPfXx
	v/PqVXvFTOi24PY0+LZORho5L8rydd5tiIxJ1N7CdC07WlGkSwSBgdIMsOqdxZWa
	mgL45D0LY85h8PJyHUGQps26OWF5M3verP+CtNZoxIWgZeBOmuXh9hP9JXA9nxdw
	3OMPI53vaVqMLh4JIYlVczMTGQgRzLbo0JSyaQJLghgOjCdR12yiV+x55tOK7b7r
	iNYDL8Zf0CISx1V0EzR0A4VCisP6FCy4lF2qxEAEv+/kDXRrpGYw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p9dtn0mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533DSKR5017869;
	Thu, 3 Apr 2025 14:55:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ac9pra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OdU8psB7LYFYFHucz5xp+qhOiaZ3OlhFOXAxyXZELVLjGly+HfcpjmDjSvWWrCjGN2Yf/MvtlEdQEwWQ1W+mT7ROp/0ZF6eKzzb/zmLBBWCMvF51BX+14uRVFUhuuRogMwlw+8Q5pI1kz3Yaz/YnwK6WpjSXRE90bh345Crspd+AeZfzAqtq58qER7H6ljlgXRQGHd/5ihXuz8s310rkBX5qbOUUBmYHBdfnPWcOCsjiMGEtyBufeI5zsLvDNFeJGmWpxu7dFR/AmBOxwPHJxHp2mGLvVFxHVbTohZCTOrL2d5PQahB3Z0NUZ811pm00VkdVDBnmzAVfAS0gZdyLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlIKe1s+1UoC+o2DuAbk1EvJ6tTiZWWEL+VR0N2NO/s=;
 b=bGH25CimZ/vfn0/Jfc1U5ML2nqi0SpJJyUdRkJCNH1Uo2kcxmbXZIWoMa0pg7PVLD5AyubtgT92iI1xCwMZRug+OCKlbmOfcCVIxNTSz3m524A6oG49vSTdcQBua1/X9wkF4OoNyKVrhe22zjirnRbYHU/mKGdFauM603Tsq1cQfJFkOfByEvSAtd4cem9BMrFMcss8u77/LZ5dAHuI9yjVhknzxBsSSDmryY3gNuPUPmCXdGzrGAkjlqyVgmCD3RLZjAT83ij0Cdnrct5gBW2oTKmOyj5FXLoDUKeqq7dfcgD0bVbtQ5G6I9RnUpqKJEWt7zsAlcFOXoDwwPHJcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlIKe1s+1UoC+o2DuAbk1EvJ6tTiZWWEL+VR0N2NO/s=;
 b=J2NoElYd8OR7K2YBbZOHgYZ7SeZQvb7LIqoa723JPtr+qkYVFRgVSByT/Qv+Sz7Ywc1tYTBVnjmFWMEcpos+A1ykI4EEWyjSvn029UlnOo+WTHZzph7HHcKGE8qBOaV7lqOhwIc7o/npx8iFWFUdHiu7sJU9QRJAX8jIwxUKdW4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7555.namprd10.prod.outlook.com (2603:10b6:806:378::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Thu, 3 Apr
 2025 14:55:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:55:36 +0000
To: <shao.mingyin@zte.com.cn>
Cc: <james.bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yang.yang29@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <ye.xingchen@zte.com.cn>, <li.haoran7@zte.com.cn>
Subject: Re: [PATCH] scsi: scsi_transport_srp: replace min/max nesting with
  clamp()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <202503311555115618U8Md16mKpRYOIy2TOmB6@zte.com.cn> (shao
	mingyin's message of "Mon, 31 Mar 2025 15:55:11 +0800 (CST)")
Organization: Oracle Corporation
Message-ID: <yq1y0whthuq.fsf@ca-mkp.ca.oracle.com>
References: <202503311555115618U8Md16mKpRYOIy2TOmB6@zte.com.cn>
Date: Thu, 03 Apr 2025 10:55:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:208:239::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: f2293328-cf11-4087-c9a9-08dd72bf9766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uYjhBw9O5rwUsBtexjpyhZTgN2jjY3CtD4zpO65pIU3zuqEuXp6Pvk1b/DTu?=
 =?us-ascii?Q?0rR5nv2Yd2jJV5tqoneJJ+TQzkAvNgbY7YBBHAcjTQzwkYm7HsAEZBFkk9hI?=
 =?us-ascii?Q?msqwP8Odu+jqPNQ2VdOBp/tkgXvk/cCMd2t+FTKjZAjqLylT00GfRp7i+xcQ?=
 =?us-ascii?Q?DO+fEtd3WJsXriTS5fbORLS2K/1zgUt0ScCaDK2tIZya/lORQmvRzeZsTtpI?=
 =?us-ascii?Q?tNm2oXqiHp49SV41W1o8w8XXteZIqbaJQtrMusv4WFOSqmgyRnQZqSKxofuj?=
 =?us-ascii?Q?AzJxojA7jQ6WIeEbZges3aoEFrGfxhd4PomA0F7KAk1FOmKEWCCt7sxOOPpB?=
 =?us-ascii?Q?RDWOCS9y/095Q/VHR456VXk4jBl/POJzsyfrSsHpbn0WPoa0ASAzNIeUCl9/?=
 =?us-ascii?Q?trO2ej2/jrGiNhm5dHbCgaFsoOEWM5XKtnYr0UW/kPr+1LmTmdOF3u5agF4a?=
 =?us-ascii?Q?+S6/euSjdOzcShdAKvmg/ofgWJNFLlpbJeKDt3jxIAz97enBhS/6B3QRNfKm?=
 =?us-ascii?Q?3M7zhRj5M0hCjKo9lHWtOpNtM2bBSwVxqpnGnQSqS/ViMyihUPJ+qzKAperQ?=
 =?us-ascii?Q?a5Igi7+AeuCw6pstgN+vCzk5e8IrbEA62FwYozH/GaQIkE4bNAa/4XA11VGm?=
 =?us-ascii?Q?VHxbNNl5/WD3yd035W+YKcRIv7R26YkytolMscDXRDwPeQaFHqk4cJDGLMfn?=
 =?us-ascii?Q?PG84DNI1HieOousEoUH+adfYZzzhfsi8RlKYNRJgabm6JfifQvTeOd8pfmYY?=
 =?us-ascii?Q?pT0vynlaHHNTMA+UcM1NrYDqtN5Pp7Me0fDxpY+g4H2QOxXDjVTp+x1R6ykf?=
 =?us-ascii?Q?uisrL2LjJYL/VF5v4hmz2O9jXNc9GCLeVyjxkEegFcgCdwcY1ZMjM/CXGy0Q?=
 =?us-ascii?Q?821/dwbpCr345KDN1FyfjvcdXeIzCjeIWnckjT6pPu2C7G1ea9aLxkTKuTrO?=
 =?us-ascii?Q?OcK3ssfXsqH5/m4Qb2bJkzDV7vJ2WmxdcXtfUWn/a1VgiA74k+PUptL1zDtI?=
 =?us-ascii?Q?QCIswKqze5jbjvzzxGn+k7gI8wQye1GTwYdoPZXNFFZbTq5GYxUur9QK/3pD?=
 =?us-ascii?Q?H7KEI1Gk65zwqwyofrpe9z5gHn02iXjdAkP+9CzWKIZIrU/jcJ3LkQVvxP8q?=
 =?us-ascii?Q?joMvUjy/fA6MJ3hyoP1fufAf4ov19V9EITpevIcx7hqhSG8QIT6VDeaoVbyO?=
 =?us-ascii?Q?/YMlJNsr130E6d1vfYRms1MhWtuDLFgVshqLV6jHCYtAiT9J/llnyHUgOoxl?=
 =?us-ascii?Q?ti9gMeLpscC1zTnWSX4AaKo4MQgu2kfUw3PSj9L15ZtZYP70RM57vf1fBhLo?=
 =?us-ascii?Q?0Zlm5XD5nbzuKO+tRwOMDw9/0HSQe+jIXSAzRzA/dw0Ciig2XebLA91WIqN9?=
 =?us-ascii?Q?rxU0kH9rXe+jo0q4lrYDOcQpgTyc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hlsScJ4BDcmTQDD9V7TLOtoux1NlDU6qRjHEszBUCAix9iFMCai7S9D+WH7n?=
 =?us-ascii?Q?rriqFkEGrABlEBQFBr4ud1GF0ujWi1C2+vjNFotmw9xTbkgznBjLXntIQZht?=
 =?us-ascii?Q?HX+TEamjmG8vX7CpwAg0Qs4EtaU2vM4nyLhO7NM5621PW8pH81MH3VEmQdNB?=
 =?us-ascii?Q?lODmMoebJYaHldzrqH6SYJSDJBUdxvWDl0l03NN/7J8893pJ0QigGhcNT4h4?=
 =?us-ascii?Q?i8pvbmJJWGHTx54Da5lcG+PgvwNNa+lirj1OlkMKgkdPqpjLNaDtX6UYPoW9?=
 =?us-ascii?Q?n4jJU4uKRPxE8Qtq2lSnd+4klsrcxHAj69+JFyjkn0XaMLpXlDGti5uiOOvq?=
 =?us-ascii?Q?ZWWHqBtYUra04Q/VOyFywuq315jRGbaBDvoaArPuvJ78GH4vtKmo+asLbrpk?=
 =?us-ascii?Q?V6FwpjWVY9vnKeBcYNMr5bNpkBL5MHiNgy/ohXPiWlgZ2JS4Zyf3ZgqchNy/?=
 =?us-ascii?Q?dluXXXsdFkKL4pGcdHcAA9TjQ7stFP6sehEa+LyK8vdV7LsCxeYeTSUdrpvL?=
 =?us-ascii?Q?qKFWk+3zurAOvKxJSUyjdx4B4mxIW5p7ngcZ+l5hnuiBVOrlI1LW82EkrKp6?=
 =?us-ascii?Q?yLDfJLI6bkYwCgdSipHif9e+Yw125hkDTydNjr3QV/AY0FFXJHwkpyOh4xgp?=
 =?us-ascii?Q?kc7fOuPCMHzuRkUg3qnBG1CpERzN4gm5pT/S/Pe9SITgm4hPOjPhDxh62lOl?=
 =?us-ascii?Q?V3o1HWevcplLmZFNL4Ha65eL02pc05n6UJppl0kfPIAXhlsc8vhkJOlw9Iph?=
 =?us-ascii?Q?dK19DUYROj6OUeU2JjZnloadp1EsWuqkT2W12m0VDL1Hozw7btN72h1AarLl?=
 =?us-ascii?Q?vy7e/+FtVreXuDEMc0UsihFhfvxTwapMuyjHFGGOBYVds/90s7KenHNGGWat?=
 =?us-ascii?Q?oew9Vcb02cUTiOjAUsXTL/hXWTkcAkGr00ie51v9+uRO/1fmaKqEeCtTzYHv?=
 =?us-ascii?Q?QHL0ZG2J5z2mb+A2dowyCVlaoZIysTaP3qXOzvXspSQED/XFI4ErsmdwU+DD?=
 =?us-ascii?Q?Td75PcY4wL1BzVtD2zOBGqvax98IPJ5qJ110lDbaXGBEMnZNCfLEmLKlclud?=
 =?us-ascii?Q?inze53JjMw/hEgKfnRY42JSaz8PKLY3WDJPwz9AopsjRFtTrXn6jyUNwwUb9?=
 =?us-ascii?Q?8ZVIA/1NjwwNZe8TGDHQzOBSX66GJDghbPC/1Gyu8hDRru1sG58YsTCqsoY6?=
 =?us-ascii?Q?rROapHOmDgplz0nQ4d18grs5hZ6LjH2zDIlKPJlfBn1JUus7lZcddjsNXNOq?=
 =?us-ascii?Q?6XV7fYMRYWs+WTb20LQzQoRrn5blKCITORPttYbjr6+pDrNArnPgVEYrqpTt?=
 =?us-ascii?Q?CMK81QhPGhpsYdOu4ynp8wV3HfZsWzaHAbNjykdKMMODYXZoldu5HhqLBmmp?=
 =?us-ascii?Q?4n8h12/a79E+t7FaTcl/sht7guHjF8oOYut+JRuiVN+HuNGRpFdscRtCmGSE?=
 =?us-ascii?Q?x1XOyyw8/mb1ijLS9wOOGW5WoXHxq5hE6bTHvwsuXgmCSjMA/axKujL27saa?=
 =?us-ascii?Q?e39Yy2uWMlwxt8ZcrJ4Zv+o/8jjUpddRr6YiAhnipRroABzz8UAEMNxOz4Sc?=
 =?us-ascii?Q?iJyKXPOh6Vxo6MBu3HX2AJSKpHSFTNfbhHo5CmGbh4xS8TG75F01ynC/bcT/?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qd4IIxZPqBVTdozqGuHQYJa26z3R2PXCCNrqkLgN77mNcoXWIV0w5pwL/CX+z9VBSI5vJm3cKiQQ++E0LnTCez21nfDR9z/U343QRr29EKBycXSPe1UnUl1UyNv3mh/NXmNyMcf6n1zFoycGKuSnbYwbTYzKl9ebeeF1kLJnsNrWnIBnPNLXd/9AJqP3yNzAoer31qEa0ZqX8oI7q8xN467YnA4q52x9MMFneuXG8n3JsHuaUA64VNv1ZFBT+BlCzLidG79OOJNt/nUjCzjW+hIiJefY7cVdDIVLxs5I0u86DCi4rDh5o6h7vBoCTwZvACFKdljgepVwjLTYqh3d84Q+f1JHiist+obmHubveOhaozoKSKdVWwBt/9j6HaL4iFeNhOpa5Nxx83sgvziuBoaUUQebkKlx3puM3Byc4ZJKTjdyoCzFO30B7omkGAvLmWNnudyhyVuBCXaNgYwMOzYCwQWQsHI7C2Ldb2Kgbv6A9idNnQ3RSKrdAU0zOmF5xqI/RM0ZOHzPj3XLHq0VtnrvBfoYazx9QThmF2AGgaNRZmUs/gFaDZx1ncVzxWZLS/xqgv367lluTU5zQUI+Gcz7WyozDiJj9OLsv+2iEAE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2293328-cf11-4087-c9a9-08dd72bf9766
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:55:36.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lvb4w5A3A1gFvQD2huqTGpJnEFCPy0HezQxPKdWyTF+iMymc5wwX0Ov3Mb68i1Zs/tRIRY09GvQJtOo5oKJ8Bb57oZYLuJXRISRJPaVEKog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=628 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030070
X-Proofpoint-ORIG-GUID: ptEchmUU7b8z3sF4ZnG5pC5S_GHIknWT
X-Proofpoint-GUID: ptEchmUU7b8z3sF4ZnG5pC5S_GHIknWT


> This patch replaces min(a, max(b, c)) by clamp(val, lo, hi) in the SRP
> transport layer. The clamp() macro explicitly expresses the intent of
> constraining a value within bounds, improving code readability.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
