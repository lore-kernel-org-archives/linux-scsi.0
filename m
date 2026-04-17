Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868142D9EC4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467289; cv=fail; b=Pj3ISsbbF9LeGAI7IeYkZhb8oRHJj58/q9pbV0Y0TQTnZbiKD6JpfPPld69QFLI65ZtoVwEImp5+9/uiHy/O+A7viGHAcBtJV8OhXcskqdQliABDBsTJ97Hw3+gu2LT8ktmYUtJYwdi2i2ArV+9+TVL91luKFBf6tDxRKHtPnUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467289; c=relaxed/simple;
	bh=VrKeNOIqjp6Xw2Ay0Loujy5wZh9oAVVWbs0w1UgqmLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XThcqF6XzEhjrsboak/k4i/iJrLY02RyL25O2QLBKotJe3uBSNCnpzcfgRSwlnEPiS2+jN64JZXubehZLDLkT4E04/h7wkrrFHz42Dj5DO6Kd9HBnGmL2O62j2Jt1TFbf5yEzA2k89z0nHHhJW7FLtYekaavLeLIlcIz7OR/tlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RfP19S2w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zqcECTSu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RfP19S2w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zqcECTSu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfg9d2215412;
	Fri, 17 Apr 2026 23:08:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bEuo0OMZVG7qUewLFn2FnjDnVDczdPnc1pPurOENIEc=; b=
	RfP19S2w/tta7XRjKNoyZnRB5qqffHu9DLWQWhIQs7/jgtTRaUF5IAbb0+GBSZpK
	ov8xsplLDyT9aubF+D6gEt6uC59iQZ2XOVdSaolmpJ/R2Rxrg9GXHga0Mu8A81sj
	xJaAAMyzY+5+Lm9y1us02AIvr0MP/TxpemrsM2BnuLVk0fqlORYdPDlmGi48CVwL
	9DjAXL9PGP/mptGXG3B0T3DSjDQoDtI1FQ88+sv4G4RQXwRnIaR1dLvSGBKxFqKF
	awc6582/BGoJTRx9x0piv7pQKF23eYAcorQwPg+mIXZGpF+v14x9naJ/7OQ5Edu+
	F18gNR4o0lxxGX09/ZE66g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87ham0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HN4QX4035206;
	Fri, 17 Apr 2026 23:08:02 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nqtw5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CsaTr5BnKX2Z/zX5DHggWGN497uU1qxua51uQsoE6WRdOJShkUPZC5eJPum5OB1wvAYrRqU+uAJQYyIG2hv3WE4HoHogpuWmS14II39RMJlikhd/ETVw3poUKw07Tvw6SuTSl/1ESuaMsA3jMJjxCl9ey4FB9R9YofjCR9x6qFMyF4L/dj5t/bTwMjZZcC3YBKc+jGs4hIO5soSZMuGdUHTcpVczTLZxKkDUKRCSY0i+nAJkikbQwdlszl4Rc1eB9H3lHOeWf+nr7O1yAo8Am2u71YdTVckSxOnrJxLf71TkkkhsRlPohXoe1AxlBI/Xk7ADnVwgCrkj5oGvmPyHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEuo0OMZVG7qUewLFn2FnjDnVDczdPnc1pPurOENIEc=;
 b=DGa4XuCLKiI14Eff1wlHdSMFR7WS0edNbcHZvvUFMjusSLc3lVHAq2yE6EM+d6sctHcLoC7qiAKSl+SJeizlCGpGftb/ImKzJkX8yzuqM4kosmViPxiQBCf7AoxCsdxNE16fsZbNLglQTv/ao5f7e/zWGgWv0uML4FIkknr1XbClC+Aq8XjLv55/m1KFVe+rvDU0BJSpGUpQCfppg2JMXs342zqt2d1DPC9ogHN9cpzgdAf4gJws9iEsMAK/Zc6Q208hv1bT85RIJ2BJSA8AdLhEsnVtnesfkiBpJNiDpl6CULBcmzFSpnzHzNYLrkcfWnElYDpQGkU6U/wc2iI7eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEuo0OMZVG7qUewLFn2FnjDnVDczdPnc1pPurOENIEc=;
 b=zqcECTSu7mG2ZJUfk5p6tcq7loBUH6M/MNnMx+6j43vzKhz95yb9kfkmLcdg/qLW2lSdDMdTed++j6epV/zpdmu/uU4Y6K/qSKqWtdRXVEthqaxrk37i2WyJpCOhHlINIJ8qIc/Z+74/K/QVoqbjPDbQ+ijYXQwP4zQMgnwAOoU=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:07:58 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 23:07:58 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/4] scsi: Support scsi_devices without a device wide limit
Date: Fri, 17 Apr 2026 17:57:23 -0500
Message-ID: <20260417230751.117836-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417230751.117836-1-michael.christie@oracle.com>
References: <20260417230751.117836-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0080.namprd06.prod.outlook.com
 (2603:10b6:5:336::13) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN2PR10MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: 85e8a3e2-19a5-4c07-775d-08de9cd62a96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	aDmpbz+GLeERPY1S2bFgwlZn72dUwfkz3Cuzjqb1iWdfc8a4qpaNBfHUUVwca6kBlYRyjAQXOZZLCt5RjYLjztZnRWNo6zKU1+z94RFQzxm0VDmzehbYQSTzZ/bBs5bQsTeScsIv9PH52WwF3aCJLHgYmG6JVrWZHTps/C4hOj3n9Zf4W8hwb2iuWMiUtogJb9Q/wuvWUD9RV+CVlHgIGhil0hv7IxgxmJtt1emf+ot4AO5NnMNxIko7bo1FI38w5JERWDtM+/vOTnfd6HfLjUdl5nT6sF6u4y5hsWTkWkHt3PDzMTKOQcMVPIAq0iXG4RhYV+If6JWrO0JHvc8wMgZPl7yXwiSp5gk/OcE13kudDZqy71JmLXLM8LEFr8PpBLPDwbXlQ252lx7FL0nVeMUR46jqU8HbPI2WqSgOxXq1LMf6k73onQLjaqBIQhs1T94WLY8e+7421DF44KNFOI7W/mUyeIr07Mi0Ahh72dYZAolzYOeDYV+ZUhQy+5tp8RjKgTmNzTaRiiUxsf4zUsAmhxuqULNEAz7QNLYDKgC1iTDasEp+rrJep2RuNFu7ieyd+yvlp4IJdXkjUsFPAgy3J30WzN3zaFz9UATNI7RAfFdREvBmWMQW3QUtB/+TqC6vHRrfDWLL6VTj/pAH8Q5GOsrMJ7EvBFpAFNwed1nLk5FB7bx4S8madRQ0ys0xplPwcwXl5jG1SoXzearFIAtC284rJ1GRnM4y1merYGE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AGaBTZc3sHP3AxKFGvGOzUypMfS5x7wjdf3NdHfzKwbQRd2SkjSER+k0D6nh?=
 =?us-ascii?Q?3Gtb0hZqpkPZW0TTLgKOvcm4cYmhDf05yNfvrK0BNfySsBy6A2c70RIX1w3e?=
 =?us-ascii?Q?i6S+ax728LYB39gvLc4rInMd431biU2uDc/Id46fXpn+zQPGJexx2n+Wzo5N?=
 =?us-ascii?Q?616OThUB+wxR0IuE1vAziUDQYzOMZSPLwbLB0fKcX7VhOgkWMsBGjyCjXmBx?=
 =?us-ascii?Q?eX6DccI3FdJUCjZSa2GMIWNujHjnrjLQMxaThb6RNB+8qNZz7K3FmsQIhbAI?=
 =?us-ascii?Q?fO/tCzDhVcSo63tXt0c6qKzoTomZ7WIoGunqCwIipGOBEl0+CfP52mx/9oTn?=
 =?us-ascii?Q?6cFGupdCbLuWb16QQ4m1HnxXUDqWcoWh5JjtLO9KbOshnllvAgDTdHw0N/XW?=
 =?us-ascii?Q?A3vFAgMYijm/EGWKsKhgP09orPPgPYLq1OZGajh0Ij+4JeWGwlgVd9lY6W0z?=
 =?us-ascii?Q?vVyV9wLV4LG80dzwVm+iDlcBynwO4DEHrA869pcrsv/rHCK2BsXyKfLf7oF3?=
 =?us-ascii?Q?qDTP62PPCQ0SFGIEOCVX/svVXq8rwkEhhQkbNUmZc/rSbUD4YFQhT2VAaDGz?=
 =?us-ascii?Q?e1TLNExA2maJStwxZ4nHADcgwlwwlcL2Gryoe73mVvO+D9sUXK03c2aGKqvb?=
 =?us-ascii?Q?P42Uag28y9QUm9XA/GTX9i3rw97VjyOEoa/WufmFEy/8ebbsPpufpprqvETl?=
 =?us-ascii?Q?CCk87tE6ov0h0mUAGsdtecVyQ3b5yMkt6Fa3vDqg8QYV0OJLUBMzEsn05BtZ?=
 =?us-ascii?Q?cMZs+eS+WEsC34MPwCXNlKZgWm3ZMndmDH7/H9b94wGynmOLu6sYlfBWIy1S?=
 =?us-ascii?Q?ArpOFBN5xmRKpmjusijtf79JR1SsGiueBomnIKwNmWR7B710BOBk7IdWpy2k?=
 =?us-ascii?Q?/efxsMKgDdZn91/BzlaxrVv6jhHU9VuGWnn9nStx/XZ6TPC7VP8W01Fvgtvs?=
 =?us-ascii?Q?86KbLotz5W/NzvJakgt+7DB4gQ4XJ/gLCo8yjxdYv4lDRN2UXNtdPSmswuyk?=
 =?us-ascii?Q?Jt9xSTRNtVyhu6gzFX5bAdiX6/6YG8ao5CQYiUKoP4YG6LONbDFk/NAd3emf?=
 =?us-ascii?Q?YZsMgY4JQJ0ocYV12y2scy8/b/GcWA0SbCLugD47dLtmqXw+ekc3yO0o8N/P?=
 =?us-ascii?Q?pBX6lpqV5Nf5lMPoUqAJ9PrnRBN/KDw2P6wJaRvdCbz9QJaYaB5gDEteQFBW?=
 =?us-ascii?Q?J9Cg5srUG94LYoA9ZG9A2zCdZEYrTeWIDn6qoFXsn8FHaG8hUeHRr4vTFab5?=
 =?us-ascii?Q?SiDpcItLxZqs30q0GPET+zu19GiY94VgopWG3/H0KI73wpDOlyW0QLNzCMTI?=
 =?us-ascii?Q?5OqJmIoMEwalBS8J4K+llqPKFRWTS04SefPc7IuTlAVOYn4YruBpAIMo7EPW?=
 =?us-ascii?Q?XeKSY7+V5eahcQpkxbS4OVKrld27bu1JNtC1wB99o0pw/9SIc9Cb1/MjCY0z?=
 =?us-ascii?Q?XVBxDLRC993e7xjKOBN3Eg+6VzAJfYM9umFhcQ8usVXdJJQZHFjRkYtEu1Zq?=
 =?us-ascii?Q?1wnzCAE+HFsUSLX3VOlzblwmDxBIUHebe1QbJDJD/biZhbwMCh4O5UgtQuTI?=
 =?us-ascii?Q?lXFSuwVfWv1A68f+a66vEN1GvWAgEcMvR4u7jic14N1Zf4K8Cg5Me0K85zFC?=
 =?us-ascii?Q?DWivS5vW70yTNvaeq1FKdoqeZ4SXdAj6ISnpst6exvkn/z1fx/X3z18Z1UBd?=
 =?us-ascii?Q?CTvHRxKtazTCq3e2tW6hvXo6EeJ7CBi7/goEwCxzqsGD5rnN68XC5s0RgvqX?=
 =?us-ascii?Q?V6k1gDkNZgi95M+0LpGulm3qwV0z0vA=3D?=
X-Exchange-RoutingPolicyChecked:
	hlzf4x4tVSfnJkiqzVRvZv9VncFHeDSLImcZD3rHNLUNXryXGp5Bt/HEuX/lrvz8dLzdl+O6FNSHLby0wDX1IXSqnBFAUg5nudPhpZ2gyV3PCT117lPLCI9ZEYeRai46sNkRzjxlImTTIOvIiqJ/RnFxFyTVn3Ieaw4rWWE363V1e0dVLPT3tZbZtPd/knckMQ7IExc48x/hw4iUDb8sGKmCg3P91EFbllj1HJ3zH6DujIzXVP1waXFySlUvA4+uj+OEl+9YOVlqEYfa5xG7ubiS2zRUFoPBTaWB83gKVZ/kide7RJmA9OWOsCfdUqgvKHFPs1HGO94ZCgCVHcpw7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ocsHuPiHprhT0uZr4ZYn/5/lJWAXLYHHYv20rnfDMEDovQmPeGKOOUgJccLQFhLwz6kxWpKIuao73QNZ29iYjC/0QdChXeZyYyYcFUOuVDfJCZ6h67uKIHCxY/557nw3tb6Rloutf7rsG+dRnQJ5kP5rL7F0E0KvRiJ/c3v2gpJqyISR6hm7xMGBZo1x7L8F76feaqrqoroHFg9XAL70cYjlLCE2/ZkFJgzp2INs+FJuId5TzKLc4ecblTusx+TqIYAWkgyvw3TYD0ZSkvjp7VFFJfO2xlzx/l70k/fXfarui+PxjYsvYOm09vDxVIEOY5CXowPY4D1waRW1BiXXFrPtgvpq2AlvFaXKJ9gMNX+3nWfXujl2o8InBfbokxrQQUP1pBTB7Sia6OZQQYYOXeRFP8rmsrrazyHdQwIWinNi1TPTN563WCGVNzDFc8ZMM9n1Q2PBmloyQaG6UFvv1Uy6qzbcGCQbbudYYJYe0ABuLLQ7iomnAneHTI4Qg1Ozx6fc1jT5HTC0DZv6fAmmYzRfK2U/wtKeXmBAdMtCLqgdZ95lgjKKhJlm2pyu0tiNr0NaLZsWRvGfYLzhrCH8lx/XYMBYLAbpEqzHnauTBN4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e8a3e2-19a5-4c07-775d-08de9cd62a96
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:07:58.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLfDtudw2IiaPtVDxLYI3iwJZstOKYXUYrD6OOWpe8ADF7xDS4elTTfH33GSonFXSsiPPT7Z0J6EEcn5ZERb//KkIfVgdA8t7971T/eB9eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604170232
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69e2bd53 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=EXDcZh3qLuxMbbeiqS0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzMiBTYWx0ZWRfXwbYcA9DwyJe4
 oxnpt5tg8b0w48BOjC3c2hOCPxwjQ9LvPLPOWi5rX4LfHLvl5BRGl8J2GTaCeb4dc0FX0oQ5NQc
 T3oBoM0hK2V1RrpWuozNmNboUlQtt4mUDrzhuhuDWlOsEDFCpdvmBVK5W0b/WQI2RQK9IFIolWm
 hfSUx3ef6GWHWe0SnSlHyL0LEgdgz4uZEpD2mQaKm39zfMS5wCCd3lQl3m8uHj1oCr+HvTat+aI
 g7/0ezV2ekH3HbbsObvB3ttEy9eJ0uacv2jWnMrT7cjuuJAMmzQCHrcpcYpgMjTMtqwc1gO47qd
 ZJSIBdvTyULPQQXKIW4ZbDD9q9BKmo6PNQHLVbE5XeJe61LpeoMuZhArU8DvNEEOenTji5pyEmo
 YsnEoCaIJadC4O4a9bqftSrgjjj2xq2qYyRKlfh1xxa0EL84qGkUGIB3GB1epcaDq9SW1xKvhCN
 phwpdvgTBDNH4hwPXEA==
X-Proofpoint-ORIG-GUID: eS-j21QYFoSDSF3SCBn3z5YmVST7pZ2V
X-Proofpoint-GUID: eS-j21QYFoSDSF3SCBn3z5YmVST7pZ2V

For virtio-scsi, we export a wide variety of non-scsi devices like
NVMe (local and RDMA/TCP based) drives and block based devices using
ublk. And then it's common to have multiple high perf devices im a LVM
volume. The problem for these setups, is we can easily hit the 4096
scsi_device queue depth limit so we end up throttling IO in the guest
when the real device can handle more IO.

In these situations we don't have a device wide limit that maps to
cmd_per_lun. We have per hw queue limits or on the host we are doing
more dynamic throttling. To allow for these types of devices, this
patch allows drivers to set SCSI_UNLIMITED_CMD_PER_LUN for the
cmd_per_lun. When set, we will then only be limited by the per hw
queue limits.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/hosts.c     |  5 +++--
 drivers/scsi/scsi_scan.c | 25 ++++++++++++++-----------
 include/scsi/scsi_host.h |  4 ++++
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..c93c59e847c5 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -238,8 +238,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	}
 
 	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
-	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
-				   shost->can_queue);
+	if (shost->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN)
+		shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
+					   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);
 	if (error)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7b11bc7de0e3..ecc3638c1909 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -352,18 +352,20 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	if (scsi_device_is_pseudo_dev(sdev))
 		return sdev;
 
-	depth = sdev->host->cmd_per_lun ?: 1;
+	if (sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN) {
+		depth = sdev->host->cmd_per_lun ?: 1;
 
-	/*
-	 * Use .can_queue as budget map's depth because we have to
-	 * support adjusting queue depth from sysfs. Meantime use
-	 * default device queue depth to figure out sbitmap shift
-	 * since we use this queue depth most of times.
-	 */
-	if (scsi_realloc_sdev_budget_map(sdev, depth))
-		goto out_device_destroy;
+		/*
+		 * Use .can_queue as budget map's depth because we have to
+		 * support adjusting queue depth from sysfs. Meantime use
+		 * default device queue depth to figure out sbitmap shift
+		 * since we use this queue depth most of times.
+		 */
+		if (scsi_realloc_sdev_budget_map(sdev, depth))
+			goto out_device_destroy;
 
-	scsi_change_queue_depth(sdev, depth);
+		scsi_change_queue_depth(sdev, depth);
+	}
 
 	if (shost->hostt->sdev_init) {
 		ret = shost->hostt->sdev_init(sdev);
@@ -1108,7 +1110,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * Set up budget map again since memory consumption of the map depends
 	 * on actual queue depth.
 	 */
-	if (hostt->sdev_configure)
+	if (hostt->sdev_configure &&
+	    sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN)
 		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 
 	if (sdev->scsi_level >= SCSI_3)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7c747b566bc3..7555898dba25 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -443,6 +443,7 @@ struct scsi_host_template {
 	 */
 #define SCSI_DEFAULT_MAX_SECTORS	1024
 
+#define SCSI_UNLIMITED_CMD_PER_LUN	-1
 	/*
 	 * True if this host adapter can make good use of linked commands.
 	 * This will allow more than one command to be queued to a given
@@ -451,6 +452,9 @@ struct scsi_host_template {
 	 * command block per lun, 2 for two, etc.  Do not set this to 0.
 	 * You should make sure that the host adapter will do the right thing
 	 * before you try setting this above 1.
+	 *
+	 * Adapters that do not have a device limit can set this to
+	 * SCSI_UNLIMITED_CMD_PER_LUN.
 	 */
 	short cmd_per_lun;
 
-- 
2.47.1

