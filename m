Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E477CBA2D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726190607; cv=fail; b=dZ3sdJrPHxUU/x5F89q6isHjn7dllFOktpuVztYE2DpoVJ9pSrnaRMMVof2iCs4bAvGyp4NV3oyS5nWjqCaUhZP5lKZy1WBZqjPjAihDb1mORg64FAoI+ftjFuRG3jTFEqPlCbI14DHo1IWLr/lXH4vQ/wpAGQo9Uj9ZnaaJ4Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726190607; c=relaxed/simple;
	bh=PO+ZNCVxK9cmfI+HC9Iiwc4Vk1o2LLigUHMqqwdBcjY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UOx5xSTpPPC/OXTizK5tbzyHf7rd6w7XBTzOPS+IT5+pg624CgVD4sd7IaKBcUU4savzyz3deN3yACTGg2XkZtQQ0UeEI/ZGi0V3FCFj6OWxl0jygtoH/tqMGMOT7NonhN9zq9nS+auIDoNr/WtWXcF73sicoT8wJzXaZegznYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dqPclcDN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TeQSh4Xg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqPclcDN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TeQSh4Xg"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYUg023296;
	Fri, 13 Sep 2024 01:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=qSUPsaQXXJypWW
	vyAnze6HlvBltc6Po0/RNNRuW4jSE=; b=dqPclcDN66/URNiMwYaPSi2LRmO98T
	83AEuER0AZy+8oHdT1t3Au6P3DFxfXQKOUV8Bk61cAClVF1gNMDD1QFdIj8gE5tV
	b8/C233T0d+5yHcQ7hOmKPWLYTb3GlBw1X7CzWxSUSscaaPU1XRY8LRW9hG61q0P
	P5NylTyshNPxLbHNyArrY8W8HgVNILLU97EQ8O90wFU8hUNWi09khJ0wksaDE6pv
	L8B39bO072aEM5kJV2jvsWzoBV+EbmLmL+xKG4GYfahdBZOGYA7k4dFve8jBev5R
	beTRqGP9H9KgMzN4EE0GZLsDv7aw/i6YyZqxznqCOpCEhu9bgnJEOpsg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d43yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:23:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNHxFT004165;
	Fri, 13 Sep 2024 01:23:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c2n0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:23:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qtd7rAkj1ObMqWUf+pNngcaJ/b7H4p4h5ZAfxRsIysli8yvpysQf8aoe2y1IhjBEEwLPojH6oyI9ZOTS5Hc+Q9YfneIgFm6MdQhzicp23WXkO+He9hjyCKj3pYcezVD4EssdDKyLSvvHvDEznGvfJqepV3p7eMUY6KLRPxyQAS/8obYAsb6ZIPY+jFs2b72mwThkK2cI7iXcO5Y1Jh6/R9isq+GCRdNj32BEifGtpuWFF5dKoahadorxRcvj5HrP3vkxxbIVnsKs3ZzYoLIH5YLjpwAZVqTUv/FfG5zeKwjo1Yg1cis4eBdj2RLITNBZUaH77Va/BLceniCGh/vPgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSUPsaQXXJypWWvyAnze6HlvBltc6Po0/RNNRuW4jSE=;
 b=qF0f7rba3fRXfYIKKeoilCyL7IZitGYoYEBsL+Af1gVbGxDzGassuQGqM/LtayMv/3wXOybeYf1UKO5vid03+atPR7SbRWnvjCpeqjcLg+D1y3lZ53OO3yUjt/kjNk1PAlGEFV2l4Ng8+ZBQ//cE8oMPhEdKbnolI1je/wDRQHo7BQjyx8YK6G1w1XvV9a4V/5GnxLXkn7gRL3AVzgGtjxC4ENHiz2tND7Z+/MK2LNiZI61jW1pEqTOO/Aqhe1psDWLMfd4ZPauV4vJp1eYR7bTwCXEQp4nk7qSLqg5y9/6j4jzy7/sdJa23XbFoWgpGCKmjoVC3WuJO3VyWI8P+pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSUPsaQXXJypWWvyAnze6HlvBltc6Po0/RNNRuW4jSE=;
 b=TeQSh4XgqVwnMBWiEk4oxz9G6xnBw0X4I2N+sFABhZIlHHkWIT9h/t/xvcRSs/I9yZIlu5d0naHFjV9640i/l9TJlnxlpblBCtTQYx1BThv4v2F7V4xiRbaRkGm23e2tQL3wR40EDpJFLe5AWX2FnbQY8Y+uc5WDaTICX/66HI4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB7029.namprd10.prod.outlook.com (2603:10b6:806:346::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Fri, 13 Sep
 2024 01:23:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:23:00 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 12 Sep 2024 16:24:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7z0uz4d.fsf@ca-mkp.ca.oracle.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Date: Thu, 12 Sep 2024 21:22:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 02211054-10e0-44b0-83c3-08dcd3929b8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HDILt+r6h60k3xSRzUHFq3NcD17rkfE7jx1HE5VSehYG4jUdb7RCOtR6g6N6?=
 =?us-ascii?Q?q8yrrNOe3GPfFn95JY02mYD5PFI3lWd94KiJauGELEi5i21AK3ZcmSFnqKXI?=
 =?us-ascii?Q?YkwKrYltJhCht9QKk/+khJpJp2e8Q7bkfa1PZoEbN563NEdLPAtDpZpiGepv?=
 =?us-ascii?Q?VChpsab7g94Lk4HaqOch4eWgcinC9p4qZsitOtrQevMl8Pqvp8EMLgKhdjOq?=
 =?us-ascii?Q?Jd6Bwi5/NbgCO1TMy3ML9m+AM9uWOvIU00h14qYCFTnxoQCrBEz9jzXDBkya?=
 =?us-ascii?Q?RKnqbNlohWcHDIFCg6/xQkK5OLoDTR5uaHix72bX1LfgXwa2YCNRPxzz2wS7?=
 =?us-ascii?Q?jvuXKmsAAL6A4rXrrgUJ4o5RPsehRRNT1cmfwqkVk96oK7AdyQ4IykzUQYX1?=
 =?us-ascii?Q?vvzGQB6IkWmCMRcXidwu+Vqa/59sIBysZVpDU7F7cGXasDZTTV9tmcWrj2i4?=
 =?us-ascii?Q?4r0n3qI53W9b2v37VDbNT0dPyCqCWdCsqAazhhXwR6+wIkNoBu2blGwBWYMR?=
 =?us-ascii?Q?m0BXeZh58097z0qtAM4x6qIsOffEJadyuqk6B8fWFzQDCYM3AilFHxnDnXxG?=
 =?us-ascii?Q?GqoIzK+8AC8NDuo4VpRuOrb0VrPh6e6uL5JBhevmK6BTX/WGyxqVnWVRv4PI?=
 =?us-ascii?Q?S5dOeE3I+sZjzwnugVkfcilwvfrE0jkSsbgTektdXMwqRzA7Nnu2SeTqL5X5?=
 =?us-ascii?Q?b582KyR3P1nqyOUb5S+0j9oysAiziVUUakpJyWSLbiaQQ4EGBK6CER4GAKSd?=
 =?us-ascii?Q?5nV6pxWjG1d7ZwGhxnaq7pMjNn2NbXPx/IC3cJR2QlR7a7gRfz35nodvbxla?=
 =?us-ascii?Q?Gwfl3ITQ1l6gdKT4PrqLzH9iA7LVa0Ntc6G3Lpek7C44uD+RL07FPMDmmwR1?=
 =?us-ascii?Q?8ZTXs2v/citWdrEJmcIIYVr2XLpwFxz9zs2Hj5oBRlczLhq8sLOAKbX5vidO?=
 =?us-ascii?Q?QDMbPVGTWRwq+PAgQ3wSuMTLND8QaNqLlq+7AWjaefxXuA8OmReFVsvfcyZu?=
 =?us-ascii?Q?gz03b60FQ/9oLjKVN0mlfeVwHvwqFFGs8/tJaAFPpUyQus/ltG2ttoOylLKG?=
 =?us-ascii?Q?yfqK/LdrpxltKtHRe5Gjymp6v125EWzTU2/QQfIyXBqdMHYXinRsz9AIyfcL?=
 =?us-ascii?Q?IV5RO2jSB4G1qHjn51uYcc90un/8TF8ecX+DNn0iKuXwjjTyUuzx3fRPVCWx?=
 =?us-ascii?Q?7sjk0+/knZ4oUW7xhqNguiljabpjWxYyTe/6xjL3RCcr/G3y2WQH1GEaVk19?=
 =?us-ascii?Q?GWbkDOfIZMdRT06z9m8QAO6CI2Glg2EPS753S8E9SlU4rBSv7CTAVcQOGHCr?=
 =?us-ascii?Q?GgHkiBKTw8/8xcQ5yhWMmRe5alhvCYl8qO1xo1SucNmOXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D0m/9VbkXbgVjTj4S3tP3yQZdIj0ZD0QsvE0H7PuyJFHrNHf2H/W6cZ56h1C?=
 =?us-ascii?Q?NXID6PuDhyiVVJQjCywH8bil51n2RkRxFKlqBXh4pnHpjhdg6TAEhkxSH2js?=
 =?us-ascii?Q?JJeZOt35SelcYthyNDBrnguAM0xpXC1zPgoTbjznHwJ5ry07MKcLjyaJTFbS?=
 =?us-ascii?Q?aaMLl38BxZdxcv4/Sy94XU/jfeheM5ZKZPQvSoMTJz1gtUr4JeGzn4uVW4tu?=
 =?us-ascii?Q?BMH/I2tFnnymfUUiOiE46O/9A9x+hoMppoMRFYVedAIN4gfgXP3kgNr3atDi?=
 =?us-ascii?Q?PEFKgZqK+d1JcmEYc7wjkvGTJbOlr4saECiz0jih06ahHTt4Q/fyihJnXjmm?=
 =?us-ascii?Q?MsNwwni5BkVyomwUHo84+M+/BGUBjZngiTcMNEVBoaEw5t7mCJtZ69T6w/cr?=
 =?us-ascii?Q?tdKNN5Gsof8GBtmNbwGUxw2a7ud+2EdeUh1tlkbD+hQO+M8rN/q0YEdBPqfC?=
 =?us-ascii?Q?kDsY6yYJ0xAFyMq5CmBCLDGT8MkBHNHsyfKB59czwex+8nMTPYUWVlG+qlov?=
 =?us-ascii?Q?44tZEOyP3xNs4Zop0lZ2cXUr8pb/3WngUWjqsU+9YY83bkG5MnhQdetRXdGu?=
 =?us-ascii?Q?Vkiq0Mvqy4+ffX8pvi5CRGJ//XeTBdni0BPUOjgMQ6onq1tnH9YfNKIy1VZw?=
 =?us-ascii?Q?8GJBPg7NbftDjeQGrsW0Hj02QFHRDSzYM/BJyU1c/lqkVltjBkATSolP+ybZ?=
 =?us-ascii?Q?+nty4dhvKuRRddaFfIDXtb20GW+KOfFIWnbsA434PL0Sh/tGGxytEo+rbarJ?=
 =?us-ascii?Q?EpHxXphBH1CyBgTYXT4hr9FJ+ytw85DH+pt/agY2EONyEB+GfkMw0s+APAzG?=
 =?us-ascii?Q?S1THs8BM+zNU4RTcevASbrtXA2fdKpNnISgzZWNWOu5pohO42osdS41KRilz?=
 =?us-ascii?Q?InYFziXfH8JIMut5ZFr4ONc0gqfuRtjD2uMJ/8dOiRJa3/k9nMcg7nrT207m?=
 =?us-ascii?Q?5j+w13ecAh2fwbj/CN+YdSEMzqeFL0YyOAamqHHFLdz4hZQzl+E+TVCPZSZ+?=
 =?us-ascii?Q?fErQTe0Ws+ufY31/d+PVPEW3NTxTz+esGNrpC6QamumoMTqScAlM+sPI2lnY?=
 =?us-ascii?Q?YGAlzn0gNuIKwYVBq2FffuAvPuo2MgJMxflis3vTvFUzFEp9vNAMkzaA2uJR?=
 =?us-ascii?Q?GY24MrvPEtjcrVWg/PhJXpm+TaRdA8Vk7xk1lYcU8mdAXzqdEQDK3uVHRDrA?=
 =?us-ascii?Q?kp/MVh9kb7GWHb1dfwr01L2LFH/BhKtWh5j324xqzWgm3vj0MA0llqGsmZU1?=
 =?us-ascii?Q?6be+ZNj/tCsVbWTtAKragbRX9lZaDD7eSs87CYy8F0iZHftgPjSeWfZoNGOT?=
 =?us-ascii?Q?Om5jQ4r6em2LgycFGx6j+QuIekvQ4ZI7hCtnRocTdaPNvkTg3sU70l2KoW6e?=
 =?us-ascii?Q?oihfpmMQ0Kn++mDXmzIyRue4BUm0Xb0/8OeDq+JGP6HWqOflhB6DH0It4Aig?=
 =?us-ascii?Q?0Bv6m7TwvPHn1X1vs1I4+YkmxpbTHj+1Zs9ELkwkgdYL0ITMdhY+j1PwUZFF?=
 =?us-ascii?Q?eotpC+OiK1n+oQfwerOhFkK7OqQ0GBOIQLBx4o3lZcqU4CGHQ4//HuWabvvX?=
 =?us-ascii?Q?n07MA+p7UAB/beUQXeUVuRN65roRUS08+bkus7WhxZatcnBT3pebC6vBi40x?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ol4kxclSeH2CM3k/3BIvZae1mF4IR6O5yhWpsskt16kEtTILFZL8ee+vE7fQXaf1q5p1i2qTUk8H5d2GpCmDaGK6ts82JiKIOIuI2U//1xM8kH1/+2Dwxb3s3nPozp3xJfzpTtisKaoh7yFyWTK4DZmfyBY8EeR4eZ0lEGOyqXo7sOHe94wIPW4VXmE5N/tgal05vKYKF0+Z22IxmeddIAFa19WlxAguaaj5Ro8jcI2IKh5E4hW44sEYqzMeHdg68mT8ANb4PZ+iEp1rIhx+1f72HXz1ITNYlSAPdHbhcc/DgLV9fE7PxxeAgzdbSgvnAa+WBqcqlH3LeI3frH31Go04d/Af6Z24Nbd+zsCpfCOIK+pcCtlLvJaosc/8EvQskb1W3s4UgK3YINN/QKAaXxCNWz1Rq5TpwPlWXriUn4Ciw67DeFoH3Lh4ndMTpN/E2HGp5otVBfsa7vcjPuyIyOGNjtj8nPe1pY4qs3j9ms6xz8BuC4gzV7zjKkIkgEFHivgk7gg62gMhhIee3P+4KfbZYvhimGcMjK/Wxh8HjJiVpef2xQE3jqUkpzcLncorlM7drQV6XjRPAtp61mOWGmstYInh1OhN9DXCn5TvEn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02211054-10e0-44b0-83c3-08dcd3929b8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:23:00.8992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUPhpAuuIyZorEQwB0wiIt+KzLFSrrmhsSPJMJXwcO+3/36YcvmcCg8pLJeu3V76vHL45jsGPY8ekM4Pk6HFeXG4YHzAp7qR3Q89ui8gTdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=596 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130009
X-Proofpoint-ORIG-GUID: Jp83EGFrxIj3jDicDyIlOu4CT5-lUTlV
X-Proofpoint-GUID: Jp83EGFrxIj3jDicDyIlOu4CT5-lUTlV


Justin,

> Update lpfc to revision 14.4.0.5

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
