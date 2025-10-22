Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5FA930
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 01:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761095624; cv=fail; b=dWmhFpF3KgSyxpE6tmNXugUlOrrh/OSnMvQpp9HGDDhe/pcj6DMsQTYY9SzKdFhieynWKpVTMFuReESUnK77tF09xS30c2uB94TEWQgm/xWNbGum9V/+DOhw9G4x5mQbqkAgZS2htGAMTM1iYmSgTX68KxXbFV65VB4w0NWhOGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761095624; c=relaxed/simple;
	bh=02ryAeqzdFTqwSjGFy0y4yL82jfZj5zsKXLecE/AzS8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mJxGEjWmoB2N4zhDUs7ydaFcfWbKgiaV/Cn+Mu0yNijZDFNDUjlU/8CJqeTEkjTKB3cs1g0Uc/k+KvyYIRsGUWXBxoL1Wps5mQQAyo1R10bPRa4B/Kb4xZAkFqgWSOCmgukpsGbUF5YZoD4LYvK5GnDUp1KrGbEJ9tvIAMIdX4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SxSpLdFd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ubHDMbjK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SxSpLdFd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ubHDMbjK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMuBwX013116;
	Wed, 22 Oct 2025 01:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Zvn3CCwXptpL6/j6Am
	Xb4sbC93utR5hNfqiqfvtj6Cc=; b=SxSpLdFdyWs1LU0/IDYr/Ywwax+YVDcSWj
	UPciNs61Z3wNsNCiB0Y43eWV9sVQRn7X8CVEILhG1gYsblLe4XhmXRpDvG38QDPO
	I7yZloFXZMS+iBTjCoDpf4INHfxRfYzDcIzr2AM07WspBAjxoIfmk99jEKAesN9O
	ey0YpBLkHQCb2rKdOHgYtlrBvYzcXWa6whnDS2tlcj4QcftpgEjk5UjSL1YvzxfG
	3tyUJ9H9CPvO+Wg43E/2VEc2GE8EJRZai++LbG0DvzWEOcRssjWm7ZYaKvNgzU/1
	Z8B9ADYYwPyxuNko0G/tb7CbjIJXZviWX5Rrw5MnWgDTsZn5KZLw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2waxs4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:13:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M0oCOF032461;
	Wed, 22 Oct 2025 01:13:33 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdj1pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbgZSUFSCsxYx7VJd08ifQB6fHpdbpXV1OKh+4+6cBsbPBSc7ZrqBNgZooQBmuASpLPlqM722u78244Vn1NLqTCpk19UlhNAs4MgN7Hc4Lr5OlDuYGUivsKuAXXH4QkTrDZDdtKp53/hga6zQggj6VRYUFnBAm5lxROx5u+s/b9kcUk3wwt4JbXi15S2nAZVrn9HsHkGaRuqfvMRYTwPgELJXLy5F/JrDZ9F1cJODPp47hvyqnk+uuuEWXSxLtI8l0aO6dLa2gdIICt7Bynst5g8P1lRsiR+rxqpaNXCCwlBWdRYzkZd7IOambSYuHsh+5HGD+xbdRndrVpi9BiMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zvn3CCwXptpL6/j6AmXb4sbC93utR5hNfqiqfvtj6Cc=;
 b=zP5fbSNGIZ/u4gSpsV4YehFhJH9enCqNNiTOHANDSu/4HuuHt/KAkQPMOtZSZG9BkPlR45B6MzoDkFlt2fbkiJP44ZEcawhk4Y0LQLin0IRZnctWWjHN9WcYK+X571JxzrDVXQqbza9SAlyifOgdUqB9QJJUKWc5Egy9vvvPvlQ/NUq4SjFYwWDOwzBmb55stFXMDB3x+088Cbh98OdBUE40JZDa+2a+msb4hHeGUtkeRlWERHZadh7gisJZDUC1BvjhRbmAKYYYglzXxUqzNaUKr8OCQlOwKgD1HyHGbhxC8cYLKLtjJNcIrDmeaNapZT+5PMGMAD9aZPtQ8MLKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zvn3CCwXptpL6/j6AmXb4sbC93utR5hNfqiqfvtj6Cc=;
 b=ubHDMbjKBL7GCYEgw/Z1rjklnfGPzQCKqy5FCsUxHuDhwwVuGDy3R88Y59TgqULqN+JsiqW1SnT5zAO3KzfQagXuXI2JYeqtV9HVinaniLSX418Y4BsBuxlsJUvKm2gZtTjDQRtYw2TXCDn5n6KHcd/nBDCsAMr4V38YTyws1Bc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF00080FB4B.namprd10.prod.outlook.com (2603:10b6:f:fc00::c04) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 01:13:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 01:13:31 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        John Garry
 <john.g.garry@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Do not declare scsi_cmnd pointers const
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251014220426.3690007-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 14 Oct 2025 15:04:25 -0700")
Organization: Oracle Corporation
Message-ID: <yq1frbb68nn.fsf@ca-mkp.ca.oracle.com>
References: <20251014220426.3690007-1-bvanassche@acm.org>
Date: Tue, 21 Oct 2025 21:13:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0235.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF00080FB4B:EE_
X-MS-Office365-Filtering-Correlation-Id: 73e2b1c0-9f64-460b-4fda-08de1108369f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hvjIvIasGs6ruc1C32boaGyK4LEh0YgTpijBp1tulL+UmYegbwlZE7qaArcZ?=
 =?us-ascii?Q?frrzOzLCi1K1s0FBO5frGA2ykSilgbSaF3kpoUYTUj66Yz5y8pZ70F5umueT?=
 =?us-ascii?Q?YRgnprQRyp7jef/7k04RQ0FB5cHf8zfgohMj9HzqTVlUIwQj1NpygMpOWyq/?=
 =?us-ascii?Q?gm433oyAEtN1qGSD6QnsX2wU+Oj/qmv8wSTrO9e04/8jHGm2VytSZ6dtov0X?=
 =?us-ascii?Q?5WqsZeN1CKyLPVSSwY1mScT1zOqlWkrd/W9yVnu8om5yGBf0+ngqJgahFz4m?=
 =?us-ascii?Q?BT+KFJ4xbrE1emfbDsOLxXZzGWr5f4MSR+ig07AG34IgDlWnIT4Ua0unsrAk?=
 =?us-ascii?Q?bOLlCUHe2ZTH/xf2sGapFPGvUAbWkIOs5WWmlzyl+V29noCRgibkHLslvQBp?=
 =?us-ascii?Q?f7uCZnnMqVMZevGT8u8zYuBLga9oGyh5IJ2I2UgBUAPWQSjBuX4+8QD0Uc93?=
 =?us-ascii?Q?fg35M0Q/PO0g+H7BzzI5LTR0n9b02bKSHPFSBqHaL+PVzFn8Y/O7X3liM5c/?=
 =?us-ascii?Q?oJf1KPpesCp0ejwZ6cJnj1D38xTyetB6lPcGMdWFYUBnxXLGyAzCDhOJWdTn?=
 =?us-ascii?Q?QCnOJKvAGDKDCNVTxstgYesL+gZGV/lOLQts8hFSMmWW2c8b+8LZL1gquEBp?=
 =?us-ascii?Q?BMyPRmSWuSl6WfbAswDWE0op92O3Ei80pj9mj//2OHCocBAlZnDbqr5uFCkJ?=
 =?us-ascii?Q?YdHrz4x+hy26wIfhQWOHuLJt6ocZlEYbx5N27TlVZ6vmyv9XTGP4GQ30XBXo?=
 =?us-ascii?Q?y0ayYKe+LgdyaAYEWMTWH3zkyiWpPKAyFt5EQ9vQ5xshQD0saHb+VF2sAVhR?=
 =?us-ascii?Q?Y4JwbuA6y+wpbA49mClTmT/IJ3uX+2M+aiuEbaPW9cweJWRBlzVikBXIE+0V?=
 =?us-ascii?Q?NLwvplqRiEmad+u7skYeQ1/f9LZ8HhqNVjP1dyecg8tgGUqrCPwOL+6QZd4G?=
 =?us-ascii?Q?CEEt7cS7St+BbOZRVxB11eDHO4M7WZae+EprZHz40oOPvN8aRcCZLAg6o7Mq?=
 =?us-ascii?Q?UcICoNiKZxi6fdpvDko4HOMBJbpEvDuwHOanl1Z2uFi9ipPTQxvDthi6yquT?=
 =?us-ascii?Q?RobkAYGpuWQsZZZy8NbdfHB0whkuNYs2ii/sWFX5eCf8QzYbXmMJZg0fP6tD?=
 =?us-ascii?Q?jtnAIu5z0id+ClQ+dUjxehuzA1CUgIfTTWNzCNI8gG0L0y8Prnzsm/yxF0IA?=
 =?us-ascii?Q?L4jldeOUJxj1mjR9RpcRR7jQ623VdbcGWqZP54GNsxdQSJRcZytWR6iSVAwT?=
 =?us-ascii?Q?U1d+rrLGZzxbxUi0uMYnnVNUox7pgSapeVS6yisfZrjWAEBy7Y57FtkKuYjF?=
 =?us-ascii?Q?p1s4ya0ORKIjBsE1UuQzhq+M++FcUp9RSRvt92ae4MQd3gS4Hy8LuKc7FBuD?=
 =?us-ascii?Q?tVXKoL7ydtXPfoGJhQSgVK9pnBJURK1xuumb6+8GgQAyhcrkEjQb3R1pSEEP?=
 =?us-ascii?Q?XAeYdhj3LR/ebWpc4AxS4tLxozhInuRL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iJNq2qePmIKbQq9KEeJsJ3fCHBjmxPneSTaqZdxVq+EJMFeHZVEJVNKhcrGu?=
 =?us-ascii?Q?LYhMROQkQPctFH1+Kv3nfFcn8lPs/nX10V0LT5TXyas8rT+DKQtMzQFIt0OA?=
 =?us-ascii?Q?YqjsDmWYrL1gM1q76GNC6sn7WfUyhX30LLsxh3Q+zgYtSMbeC6TsFu7ecBjT?=
 =?us-ascii?Q?lTJaqWS43epN5DemChKt1+L8/+IuUK9l2+feeK7nqZXHcTLLl2d8FStC3miV?=
 =?us-ascii?Q?AtRDDfjPr1Z6Xni+c+Xj0pQL0+CZx9rmPPG4SXSPbeQR0toCnE8zc/hlskbz?=
 =?us-ascii?Q?Kvq5ZE4543PlYPg6CPqGlvaMGyAiwLju52ZTRkxG3Dq98WHkOiTNJBna5WRt?=
 =?us-ascii?Q?7gj7NGoRz54EOaLgOGjE1vqGV5Tr5E+FqlkxoT27UPPrSD8rKJV0ELeVeuUG?=
 =?us-ascii?Q?BPtwUTH8zwG1gKxZS1KuMBKAUvY+Qjn3jKEyV4NvjrfnAvDdu/q4CIaUvmbV?=
 =?us-ascii?Q?BOzgC+wKVC5C2SP1z2mRNYWSJufK3rWGJUUSKwxqHT1wLVNMpIRWlX3fgERP?=
 =?us-ascii?Q?Idg9zOqqDETl0nIyhL4lI/kqyE7PqG14+XLerOXWstTIAeAarQFDjuZxtmUu?=
 =?us-ascii?Q?dgVU5DnxWhic8xH9W/Rl8/tr/UNPkXxgKMIxXK1c0FlI3u2W5ErVRTpSdevA?=
 =?us-ascii?Q?usN6ETf3pbeJXEHWRAfjKbPL0YZ9qf39CQ3sljWhTnB1VGndYAfOfrY4ik77?=
 =?us-ascii?Q?/3JO3iqr8RnRfREExvSwXF7VKVukhkpUpp5F7DSOUltBVrOWrz7Py9HQX4gw?=
 =?us-ascii?Q?xkpQsgQWF+xp+KoAg0VafFIFkrz2tEV58OHdATxXFyWhg5+7Zi+lknofMr4o?=
 =?us-ascii?Q?BMbdt0SlFWP6Ck8eoCjwpCHBz8Bm+4OFO/7Fe7I6FOICW9fAx9KAwkV30GQk?=
 =?us-ascii?Q?WQOkNEW3KJ7IWT0M8PQWZvuxfMGFTfCpRWhpkUgn8oEDXAXFHJgeWqJCyO6M?=
 =?us-ascii?Q?+ccBx8VFvOAS9zOhT+hfxXAQCMepE9JYs05mFUKuHtKrk3p4vy+DORcslawS?=
 =?us-ascii?Q?UcXyy+mRejFv7llc+K9argKXgkA2QOoBOcjDQT89aM84SlppsApI+fMW+BWR?=
 =?us-ascii?Q?kDW5Wy1Ap3ElisuzH5Dqsp+Qum0e+tAggaavot4yVjklZSEuN0u7wdl1nvDW?=
 =?us-ascii?Q?WHEzjJOr4ipp5Iyccbq7/gaDaOiQOKLx3OgOJ/7ZyOUQOj7N55Zlhjv8nAPY?=
 =?us-ascii?Q?PDrUEl8Xo89QNDpMAOStjSsuDI7ptJxgftlEzjd6Hr6yrD3/7RBXZXngvvLW?=
 =?us-ascii?Q?b49FSnhS2oIoptiPxcqXTMLfZRiAc6Wsb+xL4y5Iq/RHovnFE7NQ/dn+KQve?=
 =?us-ascii?Q?rPUUhOo4mkB7zW6aGJLL9wmdHPdkpUvsizXJS5cKa+d0yiJRfqXLfPZrUKi2?=
 =?us-ascii?Q?cZKMZk2J5rYLnS/B3MX6L1ftoDDfw39hI+DMVpR/dNt6scw0ITDq0BcSiJps?=
 =?us-ascii?Q?OKel9g6sM+YUdXIVTUdrcL8OZGdv0G/H87/GSy1cm+SOhMRNBBpqLHzj4e/d?=
 =?us-ascii?Q?PFcrnhK5QiGRIQZliNT4Zm1IyeX6kCT1bmX4eWZVHZ6HQjPstR2vPLUlkrbd?=
 =?us-ascii?Q?if9DZmteHnEhLTR/SUXFPNF9NdhKKxarzhnYrqw+5qtgOPnNz/RkHpqbtZW4?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DnIk5JLRXJehFmLOKyxSV7QkdzTuxmlCUj6nDPJAYfdhAnUcLPSQNnVKAP3069cCB1NH/2xC366qePLm7FuDJ4zWNWwCeOLlBdU2P8V3vi7ROw3oQLLecx47mI4jrulC+L1wz4g7oFOB0yPTJgooatbFHTumoYwKA4RFeO5tQZVR1QOLGCiE8pYdm1aCrNbDjvU6StQMuWk07IKKw4oHW8iX0ysFUMxqlBtE2kxFx6whv5uF5NeYo0o5K3Sr5meg9MgDOhqmwX3QFA0GxybXgBC0eK2uvzlqgOj2MKdn61bw8k1n9KHXJPNcS/TkpY8vSUPaPt0OHSL3KdDuAFvarq6EUffJeLtIJsKzYanEtgI4z/o05mZLe9yZPKHERUgEUefqDZhSCONE14aFx4nu3izcP8DPh6UIXTtpO8NN0SXiLwhAruVdNxoM8qqg40cMsgri0gYaJqmT0YQb0KhyRe0nldoalTDM/wKUfnI2a5iKuvLZgOVo5VHk4zR4LktRi5Wk63GKqlJLawTm3NGCAR4DfCpOixT/GKJ6qbnAobR3P8D5+w/yY07+6EncaWCc1iAnF8WS6CWPtJwQ1i0v2Gcw8uG8YZBodqPD7YKoDmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e2b1c0-9f64-460b-4fda-08de1108369f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 01:13:30.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMudxatX/hzw3CDOLcOFyJ58Y0vAyeA9LZ5v/RTVoCbEdUx0fvtC5FF0z+GFp6i2CLrykeWPXHfcYhbjQtL+twTBC8CyKTpD6VvKtmTvatE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF00080FB4B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=916
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220008
X-Proofpoint-ORIG-GUID: fXypLBSHM9swGSpTscXwJDktpTjkeg1B
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f82fbe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=zgiPjhLxNE0A:10 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXyaiOx/7IMpLq
 WdW9K/z/DF/7EMUPtDWFxjmo2u7uUgRI7+ADduo/BNdibmivvnnr3C2U7DV9VWipGQ9qtQFsuR3
 8Zft8ASZ/pgkfdefAn52g1syxudo9lTKHq4Q0HhMgDYV9ta0tPO/6Sl+Hnia5Y6ovcKpiQKmaIV
 nTEM+5p+37kgpLpJYE6HwPc+clbATowifgZ6ieWcuixaQDaNQH5O5CgKnCp4GaRWkEnFv48CktB
 yMsm4GJYxjr+0SGIeZBMZ5Uvque3QwLH0MxpC06n5Yk7LvQ1KtgyC5re7R8tcRpGNVgFRdrlCKj
 C1SbLdc6ggTb4yxfR9V75ClfW6nMnS80brXMom764BazjtDcOo9o7au28Gy4j0r5YWlC8B1Txxj
 KBRT6qlHXBfc16WuASaDNqH8fWzJ6miu81xN/AiKRrXwxt4f4x0=
X-Proofpoint-GUID: fXypLBSHM9swGSpTscXwJDktpTjkeg1B


Bart,

> This change allows removing multiple casts and hence improves type
> checking by the compiler.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
