Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749C520B22;
	Tue, 11 Mar 2025 01:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655628; cv=fail; b=Bd9NJdOXMYdJ+3IVYYyDQzsRzTfxN773Gm+h32DS6xYKB7nBbb9goCn5AlPMO/atTSA6ni6x7mC1imvcOK8ZkPompz+DnB0p+ERDifUTewQSki0Fyf4v7hWIV4PNM4io5ua+XqtAC3SgN+sPTXi6qXKLeovRYFev+Kx0PER21oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655628; c=relaxed/simple;
	bh=OL5Ht5a+d/TfHzpK15uG8h4n1dSI770SJG2WMGjvxRE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FQDuguHa8I0zU6y4A0fjAvUK0fXlFLDfm3jNxNXIfbMWFlR2zV9nuOqxjP+w/UnY0d32gHuWL23IZqcC6X/SPCByXyaituyFsOBI+iBhA/FAlRvON9h+Oa/eO+py/TzplqcvPt4lkTdAQjPefX8rkM+ov0fPMXCqGJsvpEVGq2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VaUGjXC5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ll8Pwqaa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VaUGjXC5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ll8Pwqaa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfxoB002357;
	Tue, 11 Mar 2025 01:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=WoKMFa+i/ELkXJ5drN
	pESn8fu1Ki3WDg8i/V1EgyCOk=; b=VaUGjXC5bEJGiyeAMZUeY0JNBWKOrEPYVV
	L8micLUFXQEc6In3+D42W7aeQraUVhcxzDr9+3HvYFdbO9rtZpF8snQr8V1cH65Q
	AzcJjRysBiQC4RsfBkHgyXSzdvXiaLnq98Tucw0JxXeTiTeA8djjWI0eMXvFQnzM
	eLB9L+yihgFpD6I6m9Cim/J2v0lT16gKgqwaD8QYoWFo9knl/0AsTo0amHzn8jgs
	oecZYkv8YG9kETz3GUlQjSim96i/hT0bFr+KH7yZB3KKKtv/AHno2kzkWXB3QQSG
	AnVpzA1sdtCvJujQIB3KTVN00ice2GJDGHZHceHSo4/x+HHZa0fQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458ctb3xp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:13:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0H7MY026199;
	Tue, 11 Mar 2025 01:13:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb8c6sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:13:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcDeXMm2rG65UBceS132qF1KLRVEUYsj/DckLkgP5NJdu0g4Px/RhmQVQurN3YSfFf/yHNKTNnV2GxN3mz4KWArsVJCCPS4wabNgp4bsfLL9v9RnKM3nENFeqit6Vb7JKxOARaqfUCSKMXfBfnBz5qrJMCz/9TH07Y2LYDllSRa6S/36ms/HKzRdaWm08YhkqdwHwnk6rcsMmBDsr6s9p7FkGebir27gk1xgbfFUD1gr7zndW2uNZ9egZSzpZUewo30JJ4lwGYOcobVQWpsczjfq2i/nWxmpYDua5QtK799TLwrjaRyzqu2ha672vDJPZWVoPmsNk660QoY6KhC9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoKMFa+i/ELkXJ5drNpESn8fu1Ki3WDg8i/V1EgyCOk=;
 b=Sz/JyNt9VWvwRy7Pwiio6oUL51R3TrKKd7l7bnwy/rCEVB8viuZ3h7Vk8dc/qt9QySWlQ1HgK44TjJ4exHqevPiXhmMESgOSHi3TCL1JGcNKtJVEs1SlPaAnCHW2MOFI76t7n4IWnjh2OjrsyjWhzgApZnsXRp1x1X234d8CWgcAh1Cvt2I9155iGKzG/6thvDtw4eWQot/Zeq2XvdWkGyuUHHe59StdB6F/8+K8ep9wiCIKK9FaQdX/94Tck5kdK0NVdAqnYOr2JSx48uTbRgAGGIFTuuBoOU4izjLStiYzThjvYK/2hZPxFkJORlE7bRrWH3xi/w3z8MsS1XiUfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoKMFa+i/ELkXJ5drNpESn8fu1Ki3WDg8i/V1EgyCOk=;
 b=Ll8PwqaaWpALhF0WafnM0ss0Dcst3housI3EzqDfJI1nSDdHK9DQ7WiFn+emDm4zrIvCeIao48Z259qM6+U5alFqseent+d256mDbDXJKZwwOWTR7GSYbCZcJbJgXys+3jKNuWNep4SCmNngRlHYwIn/Z/cyt5WuzAkdRsWvExE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8137.namprd10.prod.outlook.com (2603:10b6:208:513::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 01:13:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 01:13:39 +0000
To: linux@treblig.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: static most module parameters
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250309145044.38586-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 9 Mar 2025 14:50:44 +0000")
Organization: Oracle Corporation
Message-ID: <yq18qpcjrnv.fsf@ca-mkp.ca.oracle.com>
References: <20250309145044.38586-1-linux@treblig.org>
Date: Mon, 10 Mar 2025 21:13:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:408:ea::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d3484da-d59f-406d-c8f5-08dd6039f514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XDNgigQGu8Jqdtki0Ki6xYSaFLucUeTXkhVAViS2xUHl/YUYR35ZExaCiNAw?=
 =?us-ascii?Q?rMpfLohp9MFPzv9VF4KS1XhfjPPsBQ/0koA1ChX7YDeKSFON2Rkn2ymIkc9+?=
 =?us-ascii?Q?rHm5ZEgcQ6k2Ui5xxAhEzJy0JYOjihkjOf5PyHsDkO9QaBNp/32AosCYctUv?=
 =?us-ascii?Q?f0m4yY8vMHfTlUFu+tdY3ISNFYbUnw/QNFkZRPR4eJOMWH6ZHRTq5yNsyY15?=
 =?us-ascii?Q?U+qYZVtwTzEROvocZ1pxF7mB/gwBboJYiOlNoMggxvp+UiUwVLPdKXrOyh6x?=
 =?us-ascii?Q?ZiZi+c2BUI+WXbOplw5OTDmX0A1dW/mI0kunc44tZs5SpTMWO+bQLST4R9+I?=
 =?us-ascii?Q?7agTvf5cfonCcw9F58kr6CcwCfg+Zo3wUr3W3axiZ+UwkQtPng9D6gw67jYW?=
 =?us-ascii?Q?ebuVU2Ccs61Tus4E3ago4+DSeWq4S6B6dW3e3zhJzSl8tIZ6fBVfQOSzDxBI?=
 =?us-ascii?Q?8mSHceVjk2Jja4fWZ1T4IqkpDDuqKtA51YM03msWUAy2dPGx+3F6hUGRUKa3?=
 =?us-ascii?Q?mrGmerIOmQ/eWYUwZOIhXiCgetnLCKHSAAo4dbaIyrJxYPiLl/Wvtzc7APH0?=
 =?us-ascii?Q?rumFxCuGTS4QHSJbAtAO0ahH1aeskdmtoPjoeN3Lv1DthkY+vnr0V8rpgJqs?=
 =?us-ascii?Q?mePoQ6TnKEkZy9zM1UKzutrvSf7pPpudyACUHKJ4hT/QdlJxfuJNGdH1MjiE?=
 =?us-ascii?Q?fEMzyk0ZCwtx+loyVVKYiPUs/bNAnTfFHqgvaD+K+TmMGi6inVUMiNfZ5wV0?=
 =?us-ascii?Q?8oOetX/3JtIbdS+vYN9YtA9DY2/xk+8dC9SRxIKAW3Rdkv7dW5YAxaMdbofd?=
 =?us-ascii?Q?bi06u8KIWB40WrvZlfOSseCqbPfiyCGldGrvvEglHJhr4u3DSmFy39ZNvAUx?=
 =?us-ascii?Q?K8Lr/VdmtHzmZZ123+yQnWS/DVp6LY88UrxOYMajXrfjMFRTVwZVL4+8VAw8?=
 =?us-ascii?Q?NWDK5WyczrJheVgufL5OpcurljjL+gVJsL+spBnVfxSWFoWz1bsFWBGcslTY?=
 =?us-ascii?Q?Mj0RV4PiOXb8n53Sz24oI7uAGFRXnNBWprei81CD9muzPPkjgmzYI5WYYXJF?=
 =?us-ascii?Q?NIrSYFuMsuMyqAYFo7vfyxYI89hx+XGdyWvSBRmJcQ2EPemcWiUmkInBmPFN?=
 =?us-ascii?Q?quAcw4Wnnz9DiAHO5bJ3uLs0905Rz8iSex36DE7YSxfWrgXvw0jXeO6fVqfi?=
 =?us-ascii?Q?/jBg1YlL0RY+QYKYMKjFn3/qNIAgY+FWNcJxTz/UvjKzeziLzN3UIms2Y1fA?=
 =?us-ascii?Q?Wq5FlILTmYD33VJzCE6JBArl6aHKnhWkpdJxxP7M+/t7EWSvkQ3gE5HqmQiF?=
 =?us-ascii?Q?l4SREhWbzDB7LACpXynlrgy41j3nn3kEFFHtsw1zz0HfxVkklwAKhAyOjbN/?=
 =?us-ascii?Q?5QPgS7k8rAd0Ef6F6jQgqqCNZwie?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0cK2SfSwrXKDC32ibfiHiaPIptOt1CBr3FXnXcAz8uYP0n0xcqFlMSaaqMQ1?=
 =?us-ascii?Q?9rvQCHnRoGkYpulhfklNUzqqoeh0n2DWyW1dDPpTJiLqQqazbq8INKm3QwRM?=
 =?us-ascii?Q?fMGM1BKDc//gtCfdP4HPY/5J5pDGf3zDHi5ZTIv1+uyhPAeqXnqJByiig3xB?=
 =?us-ascii?Q?qpm37aQMiqbP8SwLCLRJy7iG9r60ybofFH+LPuESrIzkcvPhWzBsHB+3ZAcv?=
 =?us-ascii?Q?yTEAx0SNY68gLEIacNup2y11HxP50IK12P4wAMXt83cXEa0jqiQv7UJs4R79?=
 =?us-ascii?Q?VEe/BXCzuJEeTjgfeHxS6p8On1A7EzKaUOOWLTWOwD3wsKYunYCfwOtup8AS?=
 =?us-ascii?Q?Xw0zHMpBHV16SA0J4uvZbTFOQjkaQwkOvMRHMx9ZsBDirTPLpvFJlFLtBGJu?=
 =?us-ascii?Q?vbXvYoxhpmxb0T9bJPo4Bn1d/xF55Zm/z1ecP7ohw6ntyjbNUYwRvmdMUe+i?=
 =?us-ascii?Q?iZ9Ps/2/GKSPrX68guzqdZoqVTZ3TtwVNqQnQJ+zF9CryllYPuW6jtL1mFI8?=
 =?us-ascii?Q?5GQwXlrFW2KP4t0ImRJ1aZIJWVj1YQBQZ1th4RTb4Q2A2j9zLC1zG5ulP9HJ?=
 =?us-ascii?Q?xE94Fgm+eBos7DCa5vNf+xmXurX26oFM5MKuuiVLJt1Cf/UxgfTPCrzv5p0Q?=
 =?us-ascii?Q?t3aszvR5u0Uip0m45jqVyYbgPY8EtZFP2axz5hWFjr5aOmZ5Y/a2xi6mi8Uw?=
 =?us-ascii?Q?w92Ik47DsBydFr5UuqAI4y2TodppSYjWBuAIq+ihW9cclJk5UpLUnRGrBFoV?=
 =?us-ascii?Q?42WC5Z0mbWRVAYogboye/hhg8aDsCyMtPmO9rqTiWnVw9G9AYqjZrsKusbb5?=
 =?us-ascii?Q?flGHDNi7ngeYjWhbIDqrwi9t1+IlBvB/xr39E1H6BEo/jFGNaEfDeAZsvRLg?=
 =?us-ascii?Q?b5WhZI9kour0U5xf5bHpc1tmfYczYBJFU1zTynwev/2ZxhsSrjtqGR7p3y2M?=
 =?us-ascii?Q?8BkL5KaYHeZYG51fk7/MUEOooQicf5QHaL0NZopdsHWft30kHc1unwWBwb8G?=
 =?us-ascii?Q?MWlwWMym7wDspCrkT8wH14uW77I7QFqbQnAx8u5AcDtULG4qkTs8EZ8Y7JyW?=
 =?us-ascii?Q?0a7GE9H31RfoX5xtQBA2dEIU48UmQuC7AaVLZ+IIe+k74YykvgthJX46gUW4?=
 =?us-ascii?Q?QqZIndPhohK9M1cjnmoJhWq4j9Ag7tgKYXfUKuAZZzzDz0gMGiu2j3L/e81X?=
 =?us-ascii?Q?O1YBwlVegRah7DNIxwrUoc9mcwwP3Cawe96BJc35f4LMwZKsoceEMQv/+/On?=
 =?us-ascii?Q?M2RBUzmBDqoTTcp0WKTujJRTZBlVDxaTvae0Da8YqrGkmFahIq/GqaYkcIFj?=
 =?us-ascii?Q?U5cNtNIgNjrxA6NENwhRXxYbUMcDfXmGtYZgxJhw91lzrE9Om3fJJA7B0DVO?=
 =?us-ascii?Q?7RBIDRxNsxotQDtpe7viF+2S8ykOSMOJ6hOlueZECI00VUA/usUg3pfRnkcp?=
 =?us-ascii?Q?LFmooTClZqp4f+7XnN+4qd1erAGaoq2ANE+DAhcLZFjDL0Ve6dOcMaJgMqzn?=
 =?us-ascii?Q?4x8tO7RbAoc/wS+bPhrpaK4C/Oa46DgMfjwBOLftXqnvAV/7DyXCSBwXBwTq?=
 =?us-ascii?Q?TQ5i7Tnt31gxBdk3w13nKHohpake7BtpeyTNEagxKki+XZAxZnNxdLRsadJb?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xQP4dX6+O7MRmUB06jzSzFefg+nODjO2n9JxE/Gg9pr77u0Ro4o9HaY+BAfssQM5tJQMXiT7ECACJXSpoh/wv9TISrR+W7LTCASeJo1tZBcqh1Rk9u8jsPa1yK/8KSo5sosBHH+jTOtnzrsaOPEIn4jBCM5BNPl9k0sVSa1l3d8qgOqgyWG0wQayrhh//xJyFtrCiLSvmwkWvR/mlKcjxXe9Gz6aidrI+ab80SdLfjTIsctjZbzrr+L75i/blTWyLf0UyCwsP5aoOTPfpIzi/E38AXdUHAeqNBsg4vz5R1izxdCmuWimgPpvZWjtZcXeB7pspZi7YGBxt8zvMieAMlpy3zWKSvhOzPw4/Xj1pZ0ZbFLq5waZiva2MVmBZ1INoZQnaRu097eIeTlEnkTNtUlwGdNO+CnnA8/4Awv9pe+7it03W3OZNWCOolTK61sJYKi6RwrVoO3OWrg3RVOhV6l1DjYPEDIhj5Pc8Js1i7nBDFF29x3t1KHMc5Dj4pV2CAQxslhtHiyPaG3ht3NPjdz7TiGBDif+FMy9KkyHLEYbvn/KLze8+UmY4RK7AQTNVm7FbzhhoVFixVYr7832QoBRNgP+oYHsfnvftaXGyC0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3484da-d59f-406d-c8f5-08dd6039f514
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 01:13:39.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mONPx4OqaczjvNB5c8raM3wvKnDn8PK2Wcx/5A7mlU8kS9tGVXNrvMkbmIKCS3c0n4CRkhV/9KUhbZcmApJf+ovPsB2+snViM7tXlz7vtlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=877 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: 19sT0uckBuS1gVjBZZKkZdw0U_k4GPfy
X-Proofpoint-ORIG-GUID: 19sT0uckBuS1gVjBZZKkZdw0U_k4GPfy


> Most of the module parameters are only used locally in the same C
> file; so static them.
>

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
