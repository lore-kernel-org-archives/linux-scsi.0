Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257AFF4F5
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2024 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717555926; cv=fail; b=IR6losseY6lJvCd7J/qwAAjuG8JF6C0RyMKHDHhj75ZgDmhAjBsRQ0eGJD13ZHa+nxgvUn2j4v4N9PVkLYwT/iQjnKuU4OwQ6Xe8ax6TviVr6XIPjHAAz1FqZNb5mZyu9W69xeKmVlaY6A8nEx1G4pngGVCMoJYaUaiCXDCeMho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717555926; c=relaxed/simple;
	bh=PtGWQiPEU9cxhYXqomq+QAezke5cRSFo/ObbUNk/GlM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HHCpeL5Komk3LTLleT9iMb2OhT+X2Tek9Ce+oQoYtkD7KQmwF4CHc/YfECiAclcUsCGEV/2iT4OeqZs5bPrxgde8DP+Si7H5XHwEnOgXjBPQ3svuiHR/hLdjrvk6S7saneaTMQp5hf7GPz2CA7Rxv3zmJw/aR+y9OM2f3cVQc74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GfBVgBF3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hb5U4RgV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GfBVgBF3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hb5U4RgV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551ECXJ015603;
	Wed, 5 Jun 2024 02:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=gxj1J7LkHFol8p9rgiGyHEdxwVtrzm28BjyCsDKL7EQ=;
 b=GfBVgBF3+AUw6U3MMuxGSbfc7dAEzXCoFYy8R6vtwcqO2bGO3crBzdn3S0H+tOD9eQ6o
 3ph+7hiUkEqT3eBJfd1qjHNeJJpT+s7+4Ip0PotBnauqmhekpHqDQjJxmRf5sDaNdBk3
 /xPMz8F8b2xycriC4kLvv94x0WmrzibGmiaWFqCO2z/AxF4S32GxHLa8zG6z0hFq499o
 vet4A41gEOYISNvb84aSaR96sr98CzqWpWXKBqRO/AHN5WulHab9JDux8Up6df/Vdip4
 p1q/q1k3gSamQNEytqF5Bytb9XNzxY9UShjaPL1dq3GubD+SAwMWWK4IUCGIdAgg5f7d sA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbsy86md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:51:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 454NsuvN020565;
	Wed, 5 Jun 2024 02:51:47 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrj2u9ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:51:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmVtGGJ5/IDoZ6RAZjG8jajpGS/vrBZReLDEs3kLtsbk2IqmccW74k6e3Q9MTGiEz5e+tn+GnelDx0s56Xxx2NVIKkOLgwsb0xg4wHn04YcEFGq59egjpXARebsexdcwwKYwn5pa4Cpvtf74ypHyAEHUvWUOX8/i3cWfun4yhKDfBIRgenUwUjk6bhVQF7MnBaemT+YHx3RtuEQuMJnQmS0PyUwHF9+/uY4BngThsu6DA6oMPRsBBNX3idl4WW/EtD0zmd/LpiTd/LHs2K1YcrEGdhCwzbA96eNwnMJNbj2XXgvHqBbcO1MKovRhGB2nFAB3fHg0wbImuC9vEq1egA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxj1J7LkHFol8p9rgiGyHEdxwVtrzm28BjyCsDKL7EQ=;
 b=QIu9AyXL9VhoHpNv1RfyXsT5NP47GoId0wOqVts7sSUYR9PzWf6RdBDDyCGxybkJP1Uv0VIC8MCQG9740eDkcrSOu4xdZSATmM3CJkAjfHcm0WzPPDfnw9dggO5PygTFjh+2ia7mWH0qbzWTkrRATjHsLWsgld+jDo/iEcub3kP6nI+G9LCtS+xzny5G+9Dkc7HQnEMcnpvfDwwAfzKR3ld2fAIOE11isIJIEeoY/rLPPjSJcUf3xFzUOa0uciq01czMHMNU4q/iP1A3Uw1Ds2hbA8z92yvrT0O1fOyTXN7ulXRfBvssyoBun5n5w8KnkEk6WR2eXH2/gIbjqtwBuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxj1J7LkHFol8p9rgiGyHEdxwVtrzm28BjyCsDKL7EQ=;
 b=Hb5U4RgVSOb8i+qbN0KJZSXAoi/BiHNlj0IccNraRWVKqPBqYIGGz600Ml+dGO6zLpea5EkE86wQ7WS9C9G5MsyL0f6KfEsslhn0Wk+v8k3OxmET/wamKflBokojG+Ci6A6BQTQuW/YG3S/HgKfi6TgHDAs0d1Lioi4Tr3YoD3U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4911.namprd10.prod.outlook.com (2603:10b6:5:3a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30; Wed, 5 Jun
 2024 02:51:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 02:51:22 +0000
To: Aaron Lauterer <a.lauterer@proxmox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <449d764e-6e56-43c4-a461-e63a91ab19dc@proxmox.com> (Aaron
	Lauterer's message of "Tue, 4 Jun 2024 14:12:43 +0200")
Organization: Oracle Corporation
Message-ID: <yq11q5c9kkm.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
	<20220302053559.32147-3-martin.petersen@oracle.com>
	<449d764e-6e56-43c4-a461-e63a91ab19dc@proxmox.com>
Date: Tue, 04 Jun 2024 22:51:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d9f2b9-0482-486f-3cdc-08dc850a6225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?0Anw5U9O8KBFgGN4ntVutX5KsuF/qaPg5j43T454t9XuNVI4CznMEnghOXhw?=
 =?us-ascii?Q?bRnm0PrQYl9kSr5S7ZCj/AkKBTY5WE+zONX5PFYDm0DSwHGR9M/6drHUNudR?=
 =?us-ascii?Q?hOvOhdufLURC8ZWEK3ke9D6XU1hvwy5AXjYO1Bljz4tHs8GnKqKqLGVAs5Qt?=
 =?us-ascii?Q?wcye3dtvHwcwl7JdQrpsnRvojJAHZdy5k9C1YF4oBI4R5QY4OlwZG49bNHVs?=
 =?us-ascii?Q?HYZX/+oylWv0f0P2uXCs1hiTAoSzl4yvVO5veUKVxwUWHZXgZaKnbkRlC4Ok?=
 =?us-ascii?Q?lAxmybxx3RYPS/owSvruKzdFkyt5E/88aVRsnzjO40EB0XAPJgSJ8bp5+Uqf?=
 =?us-ascii?Q?uYzkNqnXb11dhyi6xiGMgLh9939LrK/LTHNhqoisffTWAfQdeiObuy04P05D?=
 =?us-ascii?Q?g8T7owJC7vuHx2TVxk6HYi5yOhD81FFqEHuTl0r67HuY5mQ5fiqi1Ipz1O7P?=
 =?us-ascii?Q?qK029VXjoZmApZo9/J10GCzsG7hwfa7ZWtZo63U1GDE/S7s5qk+htd5sulEc?=
 =?us-ascii?Q?kfwTHSAfvyuQXkZCSISFMWBUWipqWZjTL3mmAJSy/PPZacGBuvvOZ6X2fuAG?=
 =?us-ascii?Q?QJXdJNnOru6bEyI71sKvqzkybevVUCswQUJ1oZEF7FhtxCisq4I0DMpzrJoi?=
 =?us-ascii?Q?Wq0g2VbrtNhEwPJ5gnVeedEXzvXvBvhOUDkBsbYeJvu9vRR+SDs2/2oafL+K?=
 =?us-ascii?Q?CozYrG7RYrcoOIj4x6BVhdZhB3D21mIRPCt2hdVD/b8dVMbJsTYhWnqslt95?=
 =?us-ascii?Q?I7s8O9PRD9lITaA13FYBVgMljQBq/fF2JXppeT0LZtB/gIwe9/pcf9sZ0Yaa?=
 =?us-ascii?Q?sAPjWmVRZH2S2U5eShgU0KWDu45Xvh2YYS8QcsDcZM/qH/22zg6//px4sVSJ?=
 =?us-ascii?Q?2mpVfr8xpO7i7YqIoWQ+TenRR9oUos1QFT75mR3dKK+zdUaFlOFpVHWbyNDf?=
 =?us-ascii?Q?lcgJpuGaSk2bK+3CtJZsDyv/eB32wbXFZKjpmGiKbxdv1SbErvwhx6ftqwYe?=
 =?us-ascii?Q?K3hw++ORCk2FKuELtEhNvWp0Nj0Rxcp/wZj1Fs0vVfHrEq/kxnOVGY5SKVdt?=
 =?us-ascii?Q?rSdRxmeYhrnthNu/44bK3O1Ql2locYAABG3lREMdegXfX4nxT4kWecFTKjXY?=
 =?us-ascii?Q?p7IoG5EZhK1xE+mqXeEj3p2ZnzjK4xMIaxMB9eaUhoTW8OVZb9qwMbarOZQL?=
 =?us-ascii?Q?Gtj6i7ekMxuhBZFfUpACZcMJfqLKaTc659gDpkZ9lFBNkDzB5/B8AwEFDBax?=
 =?us-ascii?Q?sBEmMCthu+MHNVz6CnVZG+9jCZp3C6hv806mGD+RNA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?v1tTKtIMQREhDMXW0K1s77SfYMi6EY77TB7drRgbc1S2Ln6yOkPn8yVdJ8nk?=
 =?us-ascii?Q?1RhirUfUZrDzOoTSRam/IC7lGLKI6z/bd/jIJIZMn4nt6QoDA+iup39OrIM+?=
 =?us-ascii?Q?lC+zkwXWia4l2k/FcD8Ex/HuBzHtPjTbxbwWctvSQ/DE6gKFIiR3u+zCpyZ4?=
 =?us-ascii?Q?sDa9kZOWYl3QV08qOrltYcILevAIRM4UO8V3cIyteU9r8/Q4EbW7GGTAnQzy?=
 =?us-ascii?Q?EkAnNLJUGerN1bhLwnoxWMX/qkmBYOBKOykw9PYxug/A4WKATGwCCfXQI8kH?=
 =?us-ascii?Q?Ig/Kc4rwVacoVO+yM5PMM31XcPhFDgyV2/zDpLZT4PjP571Ba2vIM9qvlSDr?=
 =?us-ascii?Q?pviYvMj3L6LUUtrtPts/bSSH+a1HroYJZGkBQpZo31q9EnYBPyMs8O/5JWoX?=
 =?us-ascii?Q?vI8j+Ltn3ZMBH9QCBREcaaieH8V3f+yMUDWA+3IpI2ZYm/axTTZdXRgOzNWP?=
 =?us-ascii?Q?6WlCva4/MFyvYCP9bN+6eGWFp9jjJPw979E7Gn30/tR2CiLtTFPHZ4Ayxm7C?=
 =?us-ascii?Q?2JXE1ipgl9BnF4qUNhx7CDwcvg2P+EK8R/r/pCa1nawGL1/UGJg7GI72VYsC?=
 =?us-ascii?Q?UHSRrfkTeFORLtLsk2jN5CiTHSp3uwAssw8QPDyHKQPT//X59FCckKDSXA/y?=
 =?us-ascii?Q?rpPxREfqxidy/jvdmbVhNdmQTHFKOL9GEX9N9uoLSmcLlWONGo31kdtLNl20?=
 =?us-ascii?Q?H0YIbIh5UlFb0ZSLDJycx8/5DHdODhIWMrY4WZDgtqwJ1jPDmv0xzGbu9rrH?=
 =?us-ascii?Q?vCQMVVt1xQ+2CVXBnvO2VowkuusC+F8jdCj3+xO3lFoFy+rKKx3mqQ38BRCo?=
 =?us-ascii?Q?D5JHLz+QjoJKtoAVe3p54wJnrwmFQRm6/h1ah9iVpdRIBSwCMVG5hGn4QILm?=
 =?us-ascii?Q?vcR5fbMvdBwrBX4nYHaKGoKDM/HrpVn39OuZq/Mdw+ZZd4/dQuXY/OQAzXqb?=
 =?us-ascii?Q?WXoxjQ6Ummj1eL4uZTaS6TD6A4V1aMdmzowR/6eav31zdWj/RpgQdWruFyTz?=
 =?us-ascii?Q?vZ45ZYHoleVHxbCYRZAbH9kbUi0Ji+rGwh3NXEhG9xfncoOO4q2QcRk68+3P?=
 =?us-ascii?Q?q4ttbr+6a/1dWtYeHSjBTxt7CAaenT/W16TesiCTv0CczTZgMOs6rcXxO1a5?=
 =?us-ascii?Q?w/s++OfHBwINkm0xysSCIyIOnDyPY5m+I319UAi9LhgQ7Us7AzKTDU7f1wUY?=
 =?us-ascii?Q?bL2hIronw2jmuKG7k5UkFAEiejIk1ThSZdAIZsbzCtzwdhFfX8e8fCt6LIQ7?=
 =?us-ascii?Q?smZumIQcQePIYRCtcIy764FoasQpAgvmJ374be0tbZusBM6a//6TnbON7oLW?=
 =?us-ascii?Q?rjkEkMauFfarWCgSCfvO7ftFUUnSazQh8vSt3cRALj14nAERXzNXsd+NfWkV?=
 =?us-ascii?Q?NyfWVNtFVGaFzxqGmbIgFuzH8yyTenNLi57A8aKA5jMSsoNKZmlSMZx6+Zm5?=
 =?us-ascii?Q?t6+TGdh6T1oGYkP/4aS35E2V6lnUSgq/CFRpPgGB1AhfdIWfFaeIbBs/DMnU?=
 =?us-ascii?Q?YVKYIesLMcvFPKbFPktrSS/+foKIKTj0c3r+RmmOl7XHol2XtDfciVQhOqli?=
 =?us-ascii?Q?W/VG+Xi21r3szQxBL7161OPbTArTjsDerfXyFszAEK89hCx/TU8XRWWuvSLD?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7y1m2y6hMDgEBPdABkGXwXWQlZaWgNA+2gDLyWOgYIxATn3zcNt5b2vO4WBw3GfLyar6+rZKzNXETmieYJTTr1mdauXtYfqDewrnqAlHm1MW6swp1mqfLRImzJoBO9l3luKwkj5Wy1wYcES4utphW1Xpk0L0ntFyxOuls3hbO7nhabMTgd24Iw/CFde4Cr0Nar7zLNG8XDmm1lvi2GD5gFv/IsMErGkZs7qEgLMjy+1WjQ6aLkgVfCisQNPu12bLaOwK3DJHPQ4gRstsLPd5+5hk5MyDYjPur8ixyi/aWXtoCehuc4uE8ra35oKjTZLSsIMI8ZEfnT5myXDizDQWXd4zGwfSh7i/rywwxjbrzPOLzE45clYVx6TITMdqq0dMQm70FWgat0pOHZLR3hjKBRU+MHgq7B9EVxhXzCy7pS0B4MVabWMEOx2ElKlw2TY0726denQvSkLBpBMjPL20eBgnWVPhAkdQCtID2rvCQSV9AMg4bBe+rywQ66aJ/7odAh6r7vrmqFVy7WQeA10Z5xvkLlz8LOl0I5fEd8iSQ128LTYTZ/oelFqKCD64RZQCT3q7IcaBUp+6xhU+VbAzLq8ZvXYdQBDeEFVjYhxLp7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d9f2b9-0482-486f-3cdc-08dc850a6225
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 02:51:22.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmpr1gE6691C5NqphIYGPDXAgXs5Y2ejNMYMDTbhv9mxef25vCzNrAclpgCk2R2hyf0z4r6PzsDK9HpV+cDF7ynGH47tNShX4Hj2TbvzEu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050021
X-Proofpoint-GUID: QVnkwGwbnGCeOa9nWzrmMPeUaipcw7QT
X-Proofpoint-ORIG-GUID: QVnkwGwbnGCeOa9nWzrmMPeUaipcw7QT


Aaron,

> The target is an HDD behind a MegaRAID controller configured as JBOD.

Running in JBOD mode is probably part of the problem.

> root@pve1:~# sg_vpd -l /dev/sda
> Supported VPD pages VPD page:
>    [PQual=0  Peripheral device type: disk]
>   0x00  Supported VPD pages [sv]
>   0x80  Unit serial number [sn]
>   0x83  Device identification [di]
>   0x87  Mode page policy [mpp]
>   0x89  ATA information (SAT) [ai]
>   0x8a  Power condition [pc]
>   0xb0  Block limits (SBC) [bl]
>   0xb1  Block device characteristics (SBC) [bdc]
>   0xb2  Logical block provisioning (SBC) [lbpv]

I am working on a fix for what's probably a related issue.

I would appreciate if you could do two things:

1. Please send me the output of:

   # sg_opcodes /dev/sda

2. Try building and booting:

   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=6.10/scsi-fixes

   and see if that makes a difference in your case.

Thanks!

Martin
