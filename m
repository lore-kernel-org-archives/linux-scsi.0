Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5EF70817;
	Thu, 21 Nov 2024 02:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732156840; cv=fail; b=F+IpNTXoj7oq3zVtpOTH/x7ba+1DYk/OUUbeU1tIzs60EKYIiYUlTUs99Y2z2/jIoxX3rUbG+F3w5aRC2CdLPh4CL93jl8FswHUAzI+h4cnKnMxqg5xLyDPF9uOw2u+/Jn4HFICg5wDVT+i4artMhPCkvxgHD8V0uageRg4TVqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732156840; c=relaxed/simple;
	bh=XvjjNr24PiACf6t2kL6i62qc6xUuIhZw5FvJw2ylrGw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SAtYZUkIgr0PnHuNDF4+oPgGlRBJ+l7rRQQ7LuQSbqg/bcbsI/A+sOhFmnwL5HHQo+TTfOhqSN8u7soocfXwgYUCgYq64pd9EhJX4jK+2Ae6t3VdRlwXK7qA2GgrxWGiQWmORIXU1Hv2F3gTdXeWqFPQHzHlWxjkqakEvPkUVzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SPz0+vm5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UUQ2H9Ul; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SPz0+vm5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UUQ2H9Ul"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL1gHRS009804;
	Thu, 21 Nov 2024 02:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=TcKCThrQnwuoOAOOid
	wNI8Tk2K3iB1hxWLgcEDKRAFk=; b=SPz0+vm5MSFgHrxhIS5uJ1JySZKCvKM3ZL
	kQbJAxf3wRTU6YAALkaeI8OH3vQXhJIxmD4Uyy5bX9Wy8MqKqRVs2YZuXrelUPqb
	1Iymr3ggII6O+oMkOEgX7JIzeV0K3cHLKUWwmxIAGWtnKBda+LE4IQko/4/cBrq8
	HCY5FxoKyuGPiplK4tOie2dX4BAeUeg6UTiNjNjJi+VvV8vrJ7UHyreXk+86XNWA
	o6qNnSMGwcbpMDn3IFFAfo0HctDUQ4N2zL9K8Lkj8GbEw8wl3GnQbVuQqOgYa8NA
	OYyUtS9re4fm3Glo+zCmG55aQcutZsYYWxVGM55t9OkgN/uT1Beg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xk0srrgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:40:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL048Fp009110;
	Thu, 21 Nov 2024 02:40:33 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhub5uy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArA76IBGG8TxZ/mircECErvs74baiovGFkL9c5vAjhZpdjU8qYmJyGQbsVDc54NrMVyw/gNGyF8Su/wESWWN5YIMXFsx31XYgH8Iw5+vWkBFmU1Reby6XtZPMJ2WnUgr44YCzoNDU3kDACve8ieO7V9ZojnUk0xQujtCDt73PmmRszx7uz/QtpkhdcxsqMstPou72M5hNd+0Rl5Gjscz8gXvgDdiccc4GSRWFulzr8VI2eNElCOUYYBCiAZUiRSIpvfFFXjGMYmWecrKfJMkF2f9hsNdPjKTjCrwXQg7vDge15FD0FFVlkJToDos/Eu1xvFKqy1rWuRN1ar86HfImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TcKCThrQnwuoOAOOidwNI8Tk2K3iB1hxWLgcEDKRAFk=;
 b=Gcy0JUR/nezUDpUSj54boyN8uKLVywDztfqZ3Wku15acmgeGP63fpzUD4X0YNKUrQt9Son0XEVip0OG0hfa7QJ7ZxgYFHBrML14QnYsokd7zR2AJ2JwEYJqaaIxGH6XEy2omc4ieWqRts9Uo/L+LHILjlzfKuGJsDo33PmxQJ2PWvzSQJZo6ZIUWIEOcfy9Vv8drmeKINhm3mTMMRfDsUkvEKTemT8sRBWEnugu2p9/8a+4Htg73HHUSbOZlubhmQMQ+AJY/0EBCd8LaDo+1bBZp+9LN/7wdoCy34MCUEI++5GRtdZ6GFOfnovjQDOIS2a2d0JzzwsWoDF+jlPMlYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcKCThrQnwuoOAOOidwNI8Tk2K3iB1hxWLgcEDKRAFk=;
 b=UUQ2H9UloIEzcjGoVPDhdXE5GfBt23d8fzUcPdBs2fdk0eaX3JyAnMhfxGnjGYXP70vINA4SWQrBi5CTfT8z+jThfzi+esVicIW4D7HEN7xfRLIdJ6sdVRHg4u3QDyj6I1sFyDwnPOGN20Z9t4Z0Gs4XIYBQPxjY40c/ydXoomg=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 02:40:30 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 02:40:30 +0000
To: linux@treblig.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: bfa: builder/parser deadcode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241117135215.38771-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 17 Nov 2024 13:52:13 +0000")
Organization: Oracle Corporation
Message-ID: <yq1a5dtqphb.fsf@ca-mkp.ca.oracle.com>
References: <20241117135215.38771-1-linux@treblig.org>
Date: Wed, 20 Nov 2024 21:40:27 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0176.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::16) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 5629522b-831c-4464-1d32-08dd09d5dd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXBE4RViHa/a9eHPa60a3IpJAkvE8JcmKbHjjrupcsTnRtcZcJTojk9WZaIP?=
 =?us-ascii?Q?wN9tPEdC9IbaZSKvqnEZaCRRLXV51RgBkMeaLEsrom2uw80ZxJ8AbTwFSRmo?=
 =?us-ascii?Q?QfmzToCUUJaVjLm56aaEJ4XbJ7JNZnROqKlhGO3MF4y9JehBxphhWfoQItU8?=
 =?us-ascii?Q?aLWgXoVYDxCDFAAExNBAGF5JQMomG9MvhhzhtWwLbg+ynY/r41JJWP2GI36r?=
 =?us-ascii?Q?0Bqd1+4EIflwmf4qdjZuhTxLf9B3BRh54nmAUFEOPYIl5YUNkojW3ghkb5jS?=
 =?us-ascii?Q?T2epXnJnqCJkoOoMCuCJjRtDDx1qrbxyMGQeN6LT9gXK6ZXB5yjoZnlcopM7?=
 =?us-ascii?Q?Ci/4UhNP+sjesT0pKTnmR7Iu0R75YxsONmns6f4UwZspIOGPFT6fcOaJN3Q2?=
 =?us-ascii?Q?bxaJ1NuK1RtKdD/1GfVTSj4tW/D/3yeEdA+dU1phD/Gn6Mvf4NX1Q/twxvY/?=
 =?us-ascii?Q?ysI01XqhTSxmR2pIbYbF3V8v40kAd6hkrDoGb4n7oQQCR/MTfJGUCF0HRruY?=
 =?us-ascii?Q?N94uBSPAQgsDE9IRLYH14hq4WvH4zUY81YMLN+BU1bvuzIvVWfwUclKSsQ1C?=
 =?us-ascii?Q?TwxKzrc5Vc/yD5mOCaaW1VX3kKcMBHRmVKFKyE6Cg44B2vT+yZHy494zs6Ry?=
 =?us-ascii?Q?zPl8+NXtGr9pKXJHLd2W+7OfeM1MixnhQcJiR82KPdXKSOf/DtDySq3nQeHQ?=
 =?us-ascii?Q?XZKsipeYhaG+tc/TKKkR2EsCKVCvZ/aTeDWUXtD5rejcjI/yF1mO80qGRw5V?=
 =?us-ascii?Q?YjJqrrHrnd7EaqwzptOEFo6BNSr8KMaN5p78JalPqvhT6d8cw/E6K6uhgdCu?=
 =?us-ascii?Q?UJL1gqktxoYJpN1vI75IW9glzhn9nauxEl+aoq2bFumSn6jMOeu9EpcEJhFm?=
 =?us-ascii?Q?EVX10HOCBrD8567bkWlnkJX3dHwNC6l8Wa4E6exhBQDbJeS4ORrVoiTs2k4C?=
 =?us-ascii?Q?L9to/nwLlrP8zc9CkzXOSK9Rb412+ONSC9VQyAZ7D66W518V/v1qgsfxaQYc?=
 =?us-ascii?Q?BGAr24FYABygdfeKFXGxydgMzIdp7yNjTvfSzkJYtxqj+jTj6wr2ITUk7AFn?=
 =?us-ascii?Q?OvJpeI2BQo7K6JzEfqp6eJpp5QOf36NgEgk+cP6SlYF/J6XJxtTtKGzctg0g?=
 =?us-ascii?Q?gwkH2o8XsQqC3Lw9v1hDK4cbeOndW+9SydzPYyHI0wtL3UpqJs2YzmL0Jhzi?=
 =?us-ascii?Q?cJT/naFTlUvqaMLoF0VjH5FJhtEGthBZuytqUuHzOyZIssNI11wGGT29MhYF?=
 =?us-ascii?Q?9MoO2GPi80aAv9crrQRZo6zVqVLp/4/w3nc6tq2P3jNL+fcTAOFumMY1p/IX?=
 =?us-ascii?Q?LzgZ4++dx0BGp7J83zAJ2cjA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fNLYHDEzSQ5ZbrqrvkvblbVI/FWEFr7QvmgSyKEg4XGdmjRAU2cGTQW7mEbC?=
 =?us-ascii?Q?nLa/LmH1haRGAUYiqaxsV4G62XvT1XrhZby0NREkDo66jrEYABTmcdRAkEWG?=
 =?us-ascii?Q?MPAK0Nf8C8oEGoVZWYFzAqoclDedjiWiNzmmJuYOhjovgi9AZqoIXYZCknC0?=
 =?us-ascii?Q?rl05R3jp9Zmd0PQymj/TVl3nca3Qy43NlZ6L3BgFleX9rbc1VB1O/uiV03KH?=
 =?us-ascii?Q?i3GP2uYgdnJll74iXQV68w1gM0xf0kNCVEOnmua7JI4x3r5ccCgBfhtWbmWu?=
 =?us-ascii?Q?DmjBEElGnJJdRQgtrsbu4MUxPUdHT/ick/pSryejSJCXPb4x2uQPH5MW1t0o?=
 =?us-ascii?Q?Jv8PAlPbUr+m6r2Y67Utp3Tdr9sKlA1iEcYjQpLT117XJYVj/XgntPKM95RT?=
 =?us-ascii?Q?3s/Z4NsoLFi201oTFQ6oT+n69qhdJiDrah7NVc7oSPVrM6yy0CQu21lRA8Wp?=
 =?us-ascii?Q?EjeaOcowhkPTLGNJkcxtJq6g9BmB1iejpzYev4lc2l5b7qNKq9OgM2rofb/R?=
 =?us-ascii?Q?0dsYSoyPgX1/N8wNukosHLlV6BYAtP50hRKAeF7vZjEObR3Y5XGldzfDvPYg?=
 =?us-ascii?Q?jK8BV/cWCO5eTf+i02hjj1NEGdOIVQeBJtyYPnjIfiY+oi3uNdAJgvN3Z/Km?=
 =?us-ascii?Q?k8EM6azZlwKvheux9wevv3v2Ib8MUhQBH0kahEiH5BDz8uH7Ogkdoy5ZWe46?=
 =?us-ascii?Q?qZm7UiBNrbqUL/Zml+FDTAO1fJPk7xKtmEM1w5pdbJl484NTEXmADEoOtkLL?=
 =?us-ascii?Q?ZP7V1m01ocXa7kNZuupKJtS+EUj0KwS8ovPSZ7D4lxRZuh/3u98zdzYTfsq+?=
 =?us-ascii?Q?K8G/Mz0fu4a87GTqV7WPVoUeMEPQxEDDAxqEfKtiUxYT+NYt+ZG23JC8q7aX?=
 =?us-ascii?Q?sSB57pnDnitny/9w0yHB4pwHMZrdtYxel6FHaoS1v527tXcU05VvARPtCNXz?=
 =?us-ascii?Q?K28L5N6vYsc8w2RpdUwmlEMQX8CQQls/9N89MqGkRcyUHjYQnxw8rm9478Lg?=
 =?us-ascii?Q?WMQS1BbuWCFu84hSwBgyxG5Mb4zhnqaWyTIQxDEViXLoNcoMFOsSh2gnvv9f?=
 =?us-ascii?Q?LUNUhAvYIwTqhWYwdqqYo/yogeqh7E12H2lwoTL0SLjdlS2hSApmOipDPknD?=
 =?us-ascii?Q?BYjkyB4bWtCcSTlLLOIyAOAZH3H1naobI5YnwJSvqH6T5MHElZnObIr/SD3C?=
 =?us-ascii?Q?3G9BbPAZmCX/5zvtIv6qTjStHF7XzSH9NWvfFbeEDwL/v22b8lGYTowD31nf?=
 =?us-ascii?Q?Pb0Wy5kyxBZbNvgOXBP8HJIY1e+zq6HsjwSPAiw75DkA/860EC5nxl3BrDVO?=
 =?us-ascii?Q?tJdJmnR99T6RXA3ERBKFNuNeMOZNi/6mYRTg4cYV9vYuQ8iDpoY6ls0MyhSm?=
 =?us-ascii?Q?mm3Oiv+TjX85oK8lCLNPaWdyZLfjb69JurqkTWzHGZk8fiWnK9ySggw1XMiB?=
 =?us-ascii?Q?VJWkez9Zg9/fPUPGwCwo5NUD6xK8kFjJxrOnQV9k48Ak+x0mE5UsuTxxWTAo?=
 =?us-ascii?Q?bphmVCzlfzsFYme4FWX3G92twIC4VJFl967TPr1rU2VGbVKdK/or+gE9uCWF?=
 =?us-ascii?Q?fk0zANGZU+o9PnRIqYqEKXLctRuTUq1ZOo2ke4HDqlI0FACz4kQWItyYawkU?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xjbglK/bFsUfTIozHuYLZitzQO/Tc4zfoBOe4Xz76PBNPioTqY55zWbAv3J316QDBvcoNVJTAgVK/t9SrBj0OZYushwujH6nOm2ndpwzjXkpiLS5JBbAhCmMgZGOlXo2LD2R/4cUa0A5GmIGRVwgsInBL3R2hgM+rJGGdKZrQ+hlQxLe8nqxsnL2vFWy8ZOY5PAUsXBlKHNU6ye7i7nEeUhL94iX3RvvZlEcRPD4elIjPxxBgko1wMTXtwa2a/QkwQrQv6GZ5tCnVMn/eWQkIUWZiOfmLZdAy30Efkj1ns+E1yebhnXEloDGPWuLrxl8FjVWa8Ilhdwd0GtG51PgA07Z6OMApoPceEhtyqaeJ9DEYRQdztAin8eW6ZC+zYvhgIFrMJ1TnpnuQXZjp/MM/6jQbFynMPo3VFMdnrZE4sONBvIxU6OSDAtwA1nuY14MtCeyJb5C+I9nnH/Rb/ABCPBsCFcETZffhBSCobSUWkf9/3n85L5Kt2bdYzhtiRbylcrM79yURB/zkliSY9P898RpSL3/wOmr502/1X10Id0Q78jEGknI8XaniVSwdwFVYE2z3m9UPOKz02GEa5JXCHXRw8GgB2W2f0fZwqvJE58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5629522b-831c-4464-1d32-08dd09d5dd7c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 02:40:30.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZuj+v5s3mK51b+QZuWfEWpXQRe+NIXuAzJaZgcpNXVpqIyTVvL3C8VefuPxYgyeZ3TVzZ2FrFNt2rFz9lC8LLq1O2iYVU+/O/drNKBZu+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-21_01,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=692 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411210020
X-Proofpoint-ORIG-GUID: AUHHE420eWksQ_gX_bEunxImgjm9RN2B
X-Proofpoint-GUID: AUHHE420eWksQ_gX_bEunxImgjm9RN2B


>   This set shaves another chunk of unused code out of the
> bfa driver, in it's structure builder/parser helper file.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
