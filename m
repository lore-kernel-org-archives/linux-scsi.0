Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD73A7483
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717117483; cv=fail; b=G9sFYaLPLdPWgwJWT4VJuKcMfExgF3ZCBQhlqa2dAALYSiMdu1HqnMTny/4w++e7idiH7E9rq5llwzXzhHzlY7Y3Zk/64KO00FGQX+a95MTESWwbaxfxCa4PiCuayUPAIjw1/hFkOhza+UBnQHPD8IElz5ZBdOuNAV7yaZsRWhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717117483; c=relaxed/simple;
	bh=0mYfOXmmujzauDXRM9KeXZxSkFeshHhP8NnXuNoKSDY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FsR3H40FfZZuq2TbetPLfp1JAHsq3vo3p8f1lwXWVLnl3tYNgg0DtAaTMEmBVqrYOIYbVY6uyMWV+Xw8i+ynD31pc22GR4t9T6I1zMtI6QbBJ6UHjBeSvbn6VzKvf3OzT10040qzDSkYa7Y96LyaUszAghAZNQ3FndurWFELm4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UFjh9q018610;
	Fri, 31 May 2024 01:04:37 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DIaTrJl40FfPU?=
 =?UTF-8?Q?nq3XLo5nKYbH1grxKFC7ziBdKFhw1Ls=3D;_b=3DCYw29fohboaq0yQJApUXbQB?=
 =?UTF-8?Q?yVr25wpCqn/NplTUeHJ4XGUG1BHvznKCW+DEFO+GqoI7G_fpkV0o3B7+9VWp4Z7?=
 =?UTF-8?Q?O28xKJbtZvb+nPvjANAaZrFGXzBbrQA4JLZJgF4Gz6o6H3Zku/U_Pju49Pr/mZs?=
 =?UTF-8?Q?AF+4JL/QunQLIMZ67fpdh6IuLKVGep+tcOkJ+VuGwEWJ+mRf+qaX18vw6_MMXW3?=
 =?UTF-8?Q?gK7DceIqfTU5aZpQszeV9vAFJqgb0pYsMasafqnjVoZwPulc6A60dc6LppmSKQr?=
 =?UTF-8?Q?_7qBFmK5729T3gblOnJe/lzjUmHiXNYEjn3wa5NJRMMtCqutlOyPMHn0nzZdBQq?=
 =?UTF-8?Q?prSlKr_2Q=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8j8a2px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:04:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44UMUFxO010721;
	Fri, 31 May 2024 01:04:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc511b29r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXZf2rFZS0k1pEptWNTVDLI2vHNEFZOwZhDd4cX7tuGgVL36r9eFNGYUs8ynuz5hzPmJhRvrAcaQEHx9lLQnZaf7XuJzUiD2CfxYhJkbvZEumaXOMdTpE4XpUAUlM9uxYEyhAJyp5rsFCgg+KBOLvO0ien8oBAbceJq1ffqVZhuf3E/K1XsaqwiuNeG779Yc/1i2Y1nKbmqk5XCcVauYwJl1dAyB1LchS4R6c0RIx3g0pP87UkoVaf67IN+lD1aVuJUhqApzLidbe+UeOKFBqcvFX6cjToKfShkls94rqeTdIkC+FPyXvua3KTeO2jxPrq76HSJS0v1Ar2//n+K0+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaTrJl40FfPUnq3XLo5nKYbH1grxKFC7ziBdKFhw1Ls=;
 b=Dt5TJEDO2n6P8Dt9ozpUfPBjwNSMyY8lWp7cLCpvc3G0w+FAqMVK0vRjZnd81AwUlVUlKA36z62EKVNETB7YBCxq8r/A7CH8k3I8dSdNU4Tj8q5xTg5/z73Dvgqzqpc0fHPWdtnI4xdNq9YVvGWgJ7mvAdeMv5FZINKlse15OpHA8yloXW7qfaVP7dMwIqNavkT++CVq62/2NKHrLOhRV+G6xKNeVV7WC9Mh50igQP0h6VUXX4PH78EYCOogOMtug67owwvjZVz+1pn5wXKiY3kivtVl5XYYbZZtu71lGoTLv2FL9aWXItNcaDNCYIQlCW77QnBqTqV+Id30LiWvaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaTrJl40FfPUnq3XLo5nKYbH1grxKFC7ziBdKFhw1Ls=;
 b=QgrWy0wek3ql/6rhl1rDcsPL9VrqgKOvCL0xAW+52i56FacA4Uoss9e+ijZeHOBDqqQO7d1Bb1kUXBqGvN8UHcIOjE8iMkzILqBCbr7O3SuSCy0NLnbU5MLnb88Rxbd2bD1B14wh5uSKgSp8q8KhGheM2xagmzTv99DFgjvf0Eo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7705.namprd10.prod.outlook.com (2603:10b6:a03:57b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 01:04:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 01:04:34 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 3/6] mpi3mr: Dump driver and dmesg logs into driver
 diag buffer
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240516152010.88227-4-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 16 May 2024 20:50:07 +0530")
Organization: Oracle Corporation
Message-ID: <yq1o78meqxy.fsf@ca-mkp.ca.oracle.com>
References: <20240516152010.88227-1-ranjan.kumar@broadcom.com>
	<20240516152010.88227-4-ranjan.kumar@broadcom.com>
Date: Thu, 30 May 2024 21:04:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:208:120::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7705:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e16406d-9a56-4e27-ea7f-08dc810da2ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?VB9eyqmeBGW52wL8LB9qwRSU87vQMaDpfeveFuSmcGFPWMuAuM0X8WHSeNyE?=
 =?us-ascii?Q?/xeiFNcd6P8pgqiY8Y+uyR1d2LTCnzYkr4jYuqGauO38VWdyvy62R1iG0LWz?=
 =?us-ascii?Q?XRrbvXHIA/Z2J8Sb84juw0GPwJi9SkAM8bWrpoO0Tg8GJCs6K6DgjikGOrkA?=
 =?us-ascii?Q?mQRNVeHolHocgyL+FfptY7FEUH/vWzq6W7eeYfoGCIXxhFFR1RRZSJ9QK8PB?=
 =?us-ascii?Q?a2FMIcsq8CKD5ZDd5Jcyyp8y6J4pu7tHYrqUD7z1dPK5yZJDv7H05g9h5i4+?=
 =?us-ascii?Q?51ssDhXTmMLWfhI1c5YiwM/+c5k0JcdQSiRiDoaJHEu4ST42AhFMM061r32D?=
 =?us-ascii?Q?xcCXxh6vG4v20NQS7AS17zuRxMPdAqCVcv/lx4M/3/l6qEft4XAfnLZX2AI8?=
 =?us-ascii?Q?23PLDCk6fZVd4LHiBmKxHd4TKKpE8CD67GHLmyf6YcDIU+Ska6B6g1zAjBAG?=
 =?us-ascii?Q?Jg8dVbFc7ZcjsirwyVr5kEAEIy7hqXQR90x1sETsGUY0l8C3y6tDrjeOogvb?=
 =?us-ascii?Q?FQe908ucatnzZHLsRwZ9J1DsCghWGLwEeYi7Uk8weH4Zh9k20SQZWFcTTSSM?=
 =?us-ascii?Q?ueTtvLX1up925cnTWGTsNCp+CAz5mZ+wjgQWmZeaAjf+OEx9mdMbOCZ8U1N5?=
 =?us-ascii?Q?XNo0wA84w6l3TJZk2VUy97mOWJz2Y5FAUC8/vOcfg5zS/NQoYNAe8QEXPQle?=
 =?us-ascii?Q?hzE1huyhXurckAux4m6KisLENosrlof0/8g01Y548aLJrxroNhWFikRrCKG8?=
 =?us-ascii?Q?ZUle0xltxKTAAASIsMHYGG83S/ei4r8lEOB5v4D4DDZqCJSYaZaOtQmqvFJG?=
 =?us-ascii?Q?RQkHHsa3WHUe12YSIqpOIvfjA90frPeKyMxjK87UkAleKXcgXqkqMITlNDXx?=
 =?us-ascii?Q?7QdzAkxtn1BaBRaSJKiAv8H4ykRzGV1Omzwab+9BlNzj82F8F1kWg2gHZsgN?=
 =?us-ascii?Q?glUr9k4dlaKiPIQ+Wx5cvCSJYa+uPl30UMxs5kCKsXYfYxG0SSXmb4wGfAt3?=
 =?us-ascii?Q?XzVbSt/M+Ez/ugxPB0BzU+pC0RD5s47fDu5owws5d8mIrz+nhy3mC7n3ThQ4?=
 =?us-ascii?Q?fVJl83bzjFbJS0KPv6aDjKswLoWMe6jy/+O+R9yC7iTHSNpj5QX4OlSYcUHP?=
 =?us-ascii?Q?XRJaNCADdaKMzFTp2rtjN3YAm/QK4K4JU85meLzLABRtKk3dzmUmb1yk01xH?=
 =?us-ascii?Q?4BK3VgxaD44g5i/eUyYxtQn8EJ9A1A7cV7NkIaezKFhgOZiARn8Vy5eRLn4l?=
 =?us-ascii?Q?XmDkJ2LRXKyHinuO32BOC6RGnnvBa0cZCusBIje0ig=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oohcCy8xhyMX2u5t+anaEAVro6tE4p5MP+/SXOTm8EL9p2MQrqMJUi8TqhVU?=
 =?us-ascii?Q?sm3R4dLLomwTZjY17ckNPamV3wYRPKC+Iz3yxywHxixN2NuWuRTg34vMVQCk?=
 =?us-ascii?Q?kfy/xL63Os9a16N4c0kq1hSxkwJAdhOvjENx1t1++HLqtsRO9VU3Tw9ZKk5r?=
 =?us-ascii?Q?fLYyaSivum8JgnxXZaNNjgTlyfHK4+r1c4Kp4Fbtd4JEFfPulTAIUNk6IWYJ?=
 =?us-ascii?Q?pVlyhuc5BTHnVMfygPYmNqLSWo824JUahodXaUvoOtw4/9sR93AnUGPG6XaN?=
 =?us-ascii?Q?rYHTtfxlkUR330Sg1IYFgVMdfTStBfG7XxaSNV9Xt08JZ6LPysyLiFkhVHBu?=
 =?us-ascii?Q?fqTPQzymWvrRM8npy6vG+Q6xpMjoTagLKLydNn7yYvBPbSiOT9ker3LUJxbp?=
 =?us-ascii?Q?QKL3ISJWltq95959YZRsj3Yp7Yf7Tc9Dyv/Wc0kcLwFw6jJ46nqnQZAq8DZr?=
 =?us-ascii?Q?x/18+5ueUlg2J3p4F2RlBEb8ly0c1n4Qt9wLhEcqNv0Kyn3aV9X/MYja97Lw?=
 =?us-ascii?Q?4pnGakGPcT7rBgs93/OZI5j2/qy1g1qdmsXc9glgBzL8o+VKFxyDzk4CrjD7?=
 =?us-ascii?Q?nWTuQgzqjZK7yhmix/htfL0pdDAde1wJU3tRVeAjKR31y9y+LbB1XcWHk76o?=
 =?us-ascii?Q?ON1uJxy+Q4rudgvsbWuuYwNkX05N+QuU1nQSFKkcPmCxI1rK4h5lM+0l1esH?=
 =?us-ascii?Q?O5aGQfe7cbEdBFXIk4S1qZUxnPmKw4nCeQ3m9VKCmapETZ8yZZk7fKfMIZsv?=
 =?us-ascii?Q?hHNFZRx2o6aRxxGBZFVensZzO3rmu1X9rIpErjAdy1PEwlH2A/q58BnxKa6t?=
 =?us-ascii?Q?QPdUzKQqzdzSv41UhCnp+xyb76zV/0Ju7UJ3H3x8O+sc6pvmVhOhy4JJzfGf?=
 =?us-ascii?Q?n8IWWc7YJu3GErwlMKEmisHTd8JCGvlr+aQXebHONIy6eK3+oYzg/1aEKJmr?=
 =?us-ascii?Q?Vcy44spPKW5rWlk3MYwym5VjFC3raHMTQxgN6qFkCkmLbXIZsTvzhF29A0a9?=
 =?us-ascii?Q?4GSMw2OtEiTzowbe3zZtqpSvyHZUJhw94cFcHPy/w0iDJd+wmogaS5KaVQIf?=
 =?us-ascii?Q?fwQgtaWQq4bWSA6Kjk7oaqcpLGJnK4efWuaoTe8+uSOhqNwiP2V9Z0RbKsZX?=
 =?us-ascii?Q?cInHm/Cebz33ZYtCVOd/vqQbRAqdukbi63Y9ZgJ1TTZQ9qIg6mjf7HkRBBIB?=
 =?us-ascii?Q?ny6XRZMWmbvCBGVLwVDU7Y3QtpOPrxvfiJxnOXZ9YLBTXcXKXb0dg1IUHUb6?=
 =?us-ascii?Q?+8JKzcVoY7ZpugXQtFK21c4LWThiUKfiDBvYnT/fy118L8W5iccP85N3hhTq?=
 =?us-ascii?Q?1FOGJ+GS0wDeZpJvEpI8GbzYTo2yta1dcjJmKf7iyVkwQ3mjQoC1k2jBOVol?=
 =?us-ascii?Q?oYUYqpFjwzOdDLjQWEpkVsKpv7hG7h46qvFszFP1RJ6RbU1HiFehQVLEZx5o?=
 =?us-ascii?Q?gjfc9E825NgdnKf8TwsHb1PfSzbNyuRN4nBy/h0srKAyZv+DCd4n/zOoTWDh?=
 =?us-ascii?Q?Wo4Hudq2oJRvvZ6Xeng4j8QEDHaDLKsiruvHf+2roqbDuWnmPkcKsmzNHvPj?=
 =?us-ascii?Q?R3GckZYmUidoJLLxBCgs/vT2e7o0inszUnEBYHHHgYjFWnHjNzL3IZA2vwtA?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	v7i3r04Eqdd2E5W6IvSsxcuAgpmmWYQbNqL0fZOFbfDlGi89VpymlfxVrRHxn5ZkkdXUCUdVMJ3ojNWCUdI9rpGocvRtI0sl/aoowVZzCPcitIpCMBb70Lt0Q/UvSfqGfdDDYrmgX+AuERTn+9FY/HSmJQlhX6Vcy0FDqlbcknZrfLfuRuBx1A7/64/3FlANt51zjDIYqHaI9vM7OKJaNp/N96wYOkVnHfsLRUl0P662pPnWLOBxGw6LvTSLHD9L9UUsfGAeUdRduYM8PBzsX/pdET3n9fcaBkGQYJsDXW4Sfac+X5fvP+M3vuOwDWgel03T/z9+zCHSy32ymalTstYSEND5VPrXIFt/7lgBmYcbQqNfC1BexKyPfiaf1Aj6QtOtQdrWzydh4LsvCoSG7Zf8467ndKgUOiq71YoHMTLKnKyW791LnNvzsCYSlRvtQGdsedyPQ82kYoZmlD8Zcd9CbQh4wjXGLqJ3WE7gFjyOj5tohYl5f0IMg8eNkT2bu6Qu+FheTbcMJQGf0KHPhqwD4SGqZtCdw6axUxR1j3k0BWwFSMGFmlR/DM0NQc/m1H4V66KBSXW28H2kE8nCJcy2QrZour5gaeQEo5oCX/s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e16406d-9a56-4e27-ea7f-08dc810da2ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 01:04:34.5498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dAL/gjwm7vDHts58l07KvQB514swpcyStnZ+FZ++vqAe5Y5/YjvVhepNUUZTaz94uUPf3ZxLNoZvOm3n5mhvg6o0Fv1CGyHOn7d95B3Bx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7705
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=610 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310006
X-Proofpoint-ORIG-GUID: xDcL0KxECpQ3NTGYcDLe4WtYEWXaJZx0
X-Proofpoint-GUID: xDcL0KxECpQ3NTGYcDLe4WtYEWXaJZx0


Ranjan,

> +	kmsg_dump_rewind(&dumper.kdumper);
> +	while (kmsg_dump_get_line(&dumper.kdumper, 1, NULL, 0, NULL))
> +		n++;
> +
> +	lines = n;
> +	kmsg_dump_rewind(&dumper.kdumper);

Ugh. This is something your userland stuff will have to handle.

-- 
Martin K. Petersen	Oracle Linux Engineering
