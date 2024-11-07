Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78842D268
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 02:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945993; cv=fail; b=ZjnNGcilhlzyX9baclJRW7QHlMn+46xHWQHJqjhNRHwf0hcpeCG+pIZ6p4rFMaUFsaRgVcaTf4qA2iBsu5ccKUlObo3rqlPR2EQDgyexdFtRp6rSJLT01z+tl/nIfOtb0e3i4mPR77YY5THiY3/Mb3sAEUCc6MEOp/Y5x+mgngw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945993; c=relaxed/simple;
	bh=1IcH5sWFgz/DRi9u3rCdGhsXpTwEKxMdjs7XxaNgPcI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rUb5xKoJK7XGzD8Dcu6wH2NAz4S49d4dnniKxIbM/KwJC75yT+i2+NrhtmqqpqyefOTSy734vsz4dfGew2Yzvx5vbIiAD94aGuLTqx7EK6f1qUa2MlIlIN6GZwC6O0w5P+pP2+fczwtdPrutv3uuRd3h+JONwrao59Mr2ZaDuj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TOZuo0Ei; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JzmoEKfR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TOZuo0Ei";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JzmoEKfR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71gStr031835;
	Thu, 7 Nov 2024 02:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=yLstk9NVTYlLLR3O3o
	AWasSv8qGhqnGYileVw00sdM4=; b=TOZuo0EiOR7iy9EbmjpPbd/0kOK+HBmTN1
	KPv80eUcK8vgVhCTxUBtfCSqQxf1ENZQB4PK6Ni1cHVTRp1Wm+awrUK9XMREs2IC
	b6sh4vf5O0IuRq2OOxF7hJIKeJqIujzWIwwiIFokN+BKtM4b4leXZ+Nj82isLvfa
	/TKs67JhuP3dYoyUiQSeZLaETwBGTPvvg1S/fGejBZTg4TX27nZiOPuk96ujQFyE
	+NkTxYAGpDcDFJIGgg1l7PLpd3YAUZKHyyDVjcZxdAHRkFRJw8hIcH+5qPqhfK7O
	K5q67jHAaVX5a2/6CsOye+KEm4WxtdO/ro+QwwQLmKMW8yfA0wHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42qh03cjq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:19:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A72FsuR036787;
	Thu, 7 Nov 2024 02:19:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah9f4x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jeKcQZ7IzhzJAQQp1ezJk0S+Dm9TPR80IkK0nEGm/1sBhdJR4P+3QrZnUIFGYdbrJI5k+tFvrLBG4ch/BzPLLa/oRmKZlXAp9jUllGfs0L5kY7tJGtAr8a7Pfnyr4GYhdXcIUoQIJxk3QfbcqGGGDf6egEHvvcZdDRQGrIMJWyW8jFyvgFIjtDU0YK4IYzgIVRVCXwCVlT8AkobAplaXniEqA3AvlaKAq5k+x1kH2n3YxI/DGlOwgyOSKKmmz/eXMnlCI+AqknNJw9fpA9ia5bGhRwyFgb+NLABUPhxjmlyNaiGHCtUrWnpwl6vTxYlKW+EqgMuu6H/WPeKWmtZzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLstk9NVTYlLLR3O3oAWasSv8qGhqnGYileVw00sdM4=;
 b=LiS4L0GemVHHm/D5z2bBQnbSknoGjWAroTJ8UWvnvdjFAo8+ocVscIWNbBbduBeqq5exWBTsUB+d7bKpkPYKWrMJuB0tci108OngRKzCzksE8fA0gdh0oBcmMj9aF6gRKgP682SuXrWXjxF/sT2vczC7foyIpVAn4s2yeSapI+d6qduEOfChvz9/vDV/mZmWvb4mE28rdkpdmdiJ3e8+Ia+OdVV8RMz0EbKkLvn2vLtBiqj6ZyGt90PsjGZc4wAH3EMFwkwGsfRLZsOz76B6UlzOiL12SdUW1UKeh2vwbmNynK5M4gP49G3tocBjEXyi5Htry8CHTV2xkHM5N9q5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLstk9NVTYlLLR3O3oAWasSv8qGhqnGYileVw00sdM4=;
 b=JzmoEKfRqJYxrfgIadAxJ4zrMJ+qK/rv7nDIeQQ5qU8PFolbIvlNwKFd2s+jgbOC6Qjj6yStcLT+PuwWZi3mfYc6WPTpJtGYfuKH8DJXlXBI2vCf5jRTjRIl+n9qU1H85hxZNz+2eFjE1178hYhf4d4uaL4nxVpLd9luhUHeC0Y=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 02:19:40 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 02:19:40 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, jmeneghi@redhat.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        loberman@redhat.com
Subject: Re: [PATCH v2 0/3] scsi: st: Device reset patches
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Wed, 6 Nov 2024 11:57:20 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y11vzsy5.fsf@ca-mkp.ca.oracle.com>
References: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
Date: Wed, 06 Nov 2024 21:19:37 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SA2PR10MB4682:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b52864-a0d7-4723-62d9-08dcfed2a258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rKsiT6bZKGkXnVB/4o1KCiN+4QxC229kyj+7ZWyn/9ngtPgBDKwzN612wcKh?=
 =?us-ascii?Q?MmOoQhKXkEUpWGPTcn6hmmPDdWgqX1dy84/KU4GiK6SCE6Pty2g5cJ6jTejW?=
 =?us-ascii?Q?ICn9QgGDuaCzJBPQ+XdFXw8G2EenhcA8I285oRUPsyZlo6lKdPpKlPXoRxA7?=
 =?us-ascii?Q?r0XUkz9TuYnunQQI5lrlsVNaZ4e1/zrsSge2AxnMcXF7h37ey1W2gsam51Hf?=
 =?us-ascii?Q?chI98iKWef7HJg8xMCBGm4NcMqFl2woS8+9oO+5GKSQYUPfovPJXmcQzuQE+?=
 =?us-ascii?Q?NGgfIDO8wz99C2El2s8EcRBgoF/Ndpnpz7NsHelGAC4Popjy4TTO4QQrDHqw?=
 =?us-ascii?Q?3b6Q32CaNMog8jT7ML1lbQROhYO2M3+63nE/KP6kA+Ggh4pHPer3Ei2sO7AW?=
 =?us-ascii?Q?4OnRqNpAKSLiSeRxfbbfU5wgc6kYDqMP8sMp6ReM3VzvBiqs9RlmaYM0HOf6?=
 =?us-ascii?Q?c6GRhKn4Snvzmne/CXNojV7c8lIHGF37fZuT0+CPlS3Cxx7jiFSE3f9nAE9V?=
 =?us-ascii?Q?LwOF3vX1FBQISPv0yXiJv7rEw+nicJp2jaRn+88na1x4D7D3Wer0ejpeaEVD?=
 =?us-ascii?Q?bm1MkprjtjqAiTITw9V0rmZCsTaKHOrgL4/RI29FDiOr3S/T37T2qASdlzlF?=
 =?us-ascii?Q?uE7iUBYn3fReXY3jRz9lIJw8MCPmqWx6nmV9446usWWQYuCDkemKxprBTLVK?=
 =?us-ascii?Q?ws2lGF19rPfxOi6d3t+ohFRdM4KcVaLPHeNp81tflIklAEoCt47deNsF0PEq?=
 =?us-ascii?Q?9A8hVgul+rkW/1VWe5CF7kmrMYz+ESLKmjG0dIRDOs+qt9qtu60ri3k5EtK+?=
 =?us-ascii?Q?saKFgwwH5G5JvjRYOSA7bBKNwRhoin5XHtqMiCZdSiqMVevCJBzWt8Cx3Sbj?=
 =?us-ascii?Q?4JNRF47i9xGhweNiWphJOPMMqTecqBz4yiSX7FQ4T7eAm/rtS9eKLqD7+9Gu?=
 =?us-ascii?Q?5NIiX7C21UZ8qzb7wuYG+bNUbPY0r6iClANIanOS3ydkMbSMl5Krcp5wUCj9?=
 =?us-ascii?Q?yAk3J7kzdrEYLSE270VTsswhEniI3H1UoeWb3oiroalM8XxZDDqOTvl1Rotm?=
 =?us-ascii?Q?X5cNLcyer281wLNxoagh/U0zqGsCOlvZgQcVqkzDfmbbiLTT+LnfxMqQrSVo?=
 =?us-ascii?Q?U48l+ioqrJpnf+uv16hcNJ0a6+y00jzOfqHNdXUP2LtjgBLnSwnJCUqteMpk?=
 =?us-ascii?Q?nJmTYH24l5LqzMV4RwHBQ3fXst/SPvuTBOLRzYyNdkE5eB/gwZ0WOfLAxTEu?=
 =?us-ascii?Q?sE1alkW9z1ATIKSVZOONaOWV9F7o2MS0Zz0GHtzMNbGzQGXuTy6NWgrefMEB?=
 =?us-ascii?Q?OA/+sT/iBK3HLUBgRSoLGppi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bYE4abtjvoTTr9hV8uiTgLQJGN/LvSQuwburvTtHxKyhjLw0isriSQKRnUXu?=
 =?us-ascii?Q?TZa/gCyqZqVna68Vvu8lcka+EF2ZK/eUveFQy91U5A132wLHLEHy67BaD2Co?=
 =?us-ascii?Q?4c2UpOXX+tzPQMWojtxjWlBxJ19hPR5tcdwHzN+PUpggv+SsMAujY8Q9KRD+?=
 =?us-ascii?Q?VH+vbSfuyYlAod5HS6yF2gv4mRmso/LZ0SIsFRKP5NUK/Noh8itkY+4pAU+F?=
 =?us-ascii?Q?FiALnGaB3PoK/pNzGr8wJELchcIJ99sdGBgnnpJBUXCPbXnoGvGaEwjPbZzr?=
 =?us-ascii?Q?0O6gFlkxxvDqPA79ywSfLgGK91SvFPw/CKgIGxmuwMEf3s7pz/5Xxz6rvfA5?=
 =?us-ascii?Q?Y4w2bhr1aE6Sn4pjTgXIrbKkJyQT8Ej51SHtxqOqRr2itQx5u0dE12C5aWq1?=
 =?us-ascii?Q?nWDms6/PK2A0cApMOJMY3adyowAiNrKy3npc76616QS8jX5IwnOJok3fp1qf?=
 =?us-ascii?Q?/jiAzH6e4QAtfHELO2Kjp/n8C/b+Htic655nwkM9hAVHPIVs9TMCa7GzF1Te?=
 =?us-ascii?Q?3ZpqR+dB5Eg/gEdpgvdBxA/RM27luXqO2aX6C8SnDH6dgIG6eV+ByEHoS6Ht?=
 =?us-ascii?Q?AWxbIg++Y1VxsvRXUON6LBckaplws1C0Hd9+XgRixCS+S0RweI/FAnW+0QoY?=
 =?us-ascii?Q?9HSt6HGTkAayqB/3U50Z4uF59jF+5yxZBXCV9V6/FVRuGiC3oeXANdpDEoj5?=
 =?us-ascii?Q?oKr0cvYZu7yOyh0+ORiaFZcM2A6sTPcBhJ9+CigOsl7kTbzjKWQ9nmiWZc8F?=
 =?us-ascii?Q?HWS3jqMOXqMg1d7aukmGslcEfnZySZD/5Jfvslyq8/qyBRBBEXpedhYFuNoZ?=
 =?us-ascii?Q?cBuW7zppNeMf9H9NI4Ax9CuUqTCwD6WxoNalxZSWR/p7N35makHW7pGkVBrQ?=
 =?us-ascii?Q?h9SXMDCPYmZsi+HnxdAHEbAjA6xrJRnATRrWWVBqB2PAGCFcuiiRGJ6tjIM9?=
 =?us-ascii?Q?iyNRpgFa4dmtpYIvVx2ETTAsQEAQFFTXHoo+0xvR7qfz8Bf6kqvP7KUGtH45?=
 =?us-ascii?Q?RjOGOEOmhkqaq7tFo09gsM5kcCj9MRPyGSV0fWRMT9J14buFXXPBoJcSAA2k?=
 =?us-ascii?Q?mk5gJJKdlnSn9KfY3sTIyBWBQ39ujtoSghlDAgrKdgGz/TzEb9GAhcslXjUV?=
 =?us-ascii?Q?YVosGxtgKxJfyNCHSqiaZvfeECr/oxUDzklwiuA+ZIQySps/BkcADdvAYnb5?=
 =?us-ascii?Q?G5aBbcJMRJrUj9JBBJXM4b5tQOlH8d5BPe+3OyvScHuudf4QOJPgP6qQC9E/?=
 =?us-ascii?Q?3F3pT4HuS7mN6oIo9+oGQ7fAqAEmFqpH0UHBzj+RSSUd5kXyu+4fcOsIcO6j?=
 =?us-ascii?Q?3htUEYoQ6f6+8HyHD/SqC5ZiR9Zi/nBkbdKmFKcVp2qDMSejubw5SD8+UVdh?=
 =?us-ascii?Q?tvDXXTC1CMSG3FZHKcR0LE3EyHrYAKzyWnKVPmxvyS0Y9DAXJpLuINwr8mCr?=
 =?us-ascii?Q?rjU9iU/Pu6yyXD41DG7za9D51LQdUu2OimICGXMzwQOixKBtSdmgoDJ1ugNm?=
 =?us-ascii?Q?jvJqmlw63xkOIOwn2s8v9yT/coyGs0IL4i4lNOH7szWMFNEEbdWMy94c7GGZ?=
 =?us-ascii?Q?o+5r0QIbcsiNy6Gi7Xt+6xSEWrUfnF2WfTN2NAK5J5s3FVOswILo2uYr6gDB?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uGZJBeS3qotuZNnKrPG+eGgdrnehUx9nTDQm90ibRjhKtqT+XOlf1PdlEKFrUzqbjIzTMwUir5Jy+Xspit4hD884iowMxB1AZ8kRu8PD2bz+Egsa+a3RBUkPF5wC47HxecIFY0GsMm8UAZkYG97Qt5oaPfjsgkQ5ea9hgrO0vMqVtPvDewEOMS2jCoxr6smBd1jrYkBxuUgWPyFrMLmmIk7sjyVBNd8BH0ob5NEjMHeFvd1So4dH1ZVmbn2bRrJ1YySSRoYFupCMbRzNV+7l+1PM+ZCtBNElhncl+T4DANxF5f06y5dPGvesIW1bPVsfCBhTbLI/I8BR5UA4xk5jAQ40S7KBZj3UQLbrFpHN73gzLEArHCuKHlUO5OPXi7iAfRfB4siJVix3+Xhb65i4VFXI2KPkVAvRSVVKWQVu0WV45toWOg8LPvbbexP9roiBagtmOIGOZwrnz3+rJG9B4TWT1p2GSaOCDXZ3TZ4xvgVy01O+fjZPZ4DHbKcU227wQA0GgxhXiofIby+8YjJjKb8ic3DkTH3AXmxBpFNFfPW5hia6h0qaYITn24zxS4rIJi4VpQIcDztHqlqoK+KlUc2kqCaO9Klpy8i7QYxuYzc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b52864-a0d7-4723-62d9-08dcfed2a258
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 02:19:40.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKqFJn6lQjilqXnTgehDumtWuIlRAEtDbhVmbSYl6E5wWLZPU3KEhbGpfPIOsRIsVFHAAypYDfN/iM1C3O0K4YDRNj2IehO7aEmeyD9dVz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_20,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=889
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070016
X-Proofpoint-GUID: HTCLR3-mggETeY3NRBcXzfQGgrh16twD
X-Proofpoint-ORIG-GUID: HTCLR3-mggETeY3NRBcXzfQGgrh16twD


Kai,

> These three patches were developed in response to Bugzilla report
> https://bugzilla.kernel.org/show_bug.cgi?id=219419

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
