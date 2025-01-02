Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993EBE65;
	Thu,  2 Jan 2025 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840614; cv=fail; b=DrdgeX+e5MPIaMn72Rq8uCG0euSPcI6aeqKV6rsy4RsJeffQuBHqvKj9M2+4osvVRF+Hii70S0AcqKlRVFVgJKFrkaUjE1JdzLMqAbCfHbnfYvyPwNCkegQG2pzb8dE9N2qnTJtnobgMkdTg54nBqzlNfVSDQTFcbpECyb6kmKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840614; c=relaxed/simple;
	bh=UnMEO2aFAsicZBsYI0gC+Nl5SFh9i8dcUHDlM2PaMyo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=CjNEYtyhYLKE9No5bCJDTmVqBwQOMGBQ5viFYeQgByj+grNJueHfNxY89lbmEL4D8VHCpPSHiHltWGLoQDPsIRHFByNAmNF6kLtdrXjFYQocIRAazkcSzZfyJIFZUXyaMbxFr6Rga+ZL0C8T7jwOzH4tXOHmO3OO2lOZgAWXbsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PEJQGncF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dGNa9T6t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PEJQGncF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dGNa9T6t"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXoV7014716;
	Thu, 2 Jan 2025 17:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=WutJ3YSZm/D/Wl4GMN
	78XtrBmEJrMUeS4/fu9QlJERU=; b=PEJQGncFmT45wlk7J8GJFbENBiuzbfOIK7
	bNSDwc5sKv2U7b1DI506SVm/zFegsjQHPyUE1BBLtImtsiqm1Yc9bIdo9McSFyT0
	EGRlO3106ojhorZhQtXhpnjt1vz2WTw1/Yl5YgZprJnsmHvyDb0VA+DmDPMyIXnB
	kNMZwoh5AaPiHf6HWBw/12qber/CuP1t6kutm0Gx4BcZPDtVaqu8z9hVch9poCja
	u4r+RSlRcXzQKcjg6P2TrlgbT//axBz+GAUrY+0Gxf3oHWmBW/zYViiwWTX473Sp
	xstpHjJO6z6V4oWeFP16KYHoj01b36jDtQC2jW5ixNmU5xVaNknQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t8xs64up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502HVvpc009520;
	Thu, 2 Jan 2025 17:55:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8tsp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJzKNcbbmyf8qT6Uy2ZlG8JH6UFDazPBvP7MWgPVw49gn+W6xbcI9j+bNrXyhpyOPWaf6i5mjESfPC66+6LbQKU6nXmFun1Om1d09WGk8sFKaeEX21A/Sf1GJKNflWCzgXQqK+xwDm21rNwvKykujeFS1KdOp0Q3LvGPOam7tENUscXkzWR+96c0a3JgKQd64Rx5/0YH2ZT3MKqI1FqZ2+Qbudv4BTcYCva9ik5r+L7RYb1Jw5dKorBOmtywBLtTLLBP/9PgxoYWtQGgv1J+V6BYtzSpekLO/3p1NYJshhhvTZQsYFlitrT99VYX7RyiV5goJvqoLHGz3AcAAAN2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WutJ3YSZm/D/Wl4GMN78XtrBmEJrMUeS4/fu9QlJERU=;
 b=AxLop81bvYs97Y7UOnBBGRmjbnm+sgW1a8BMhkT9mcuQPqu0+hgcn04GPi6KGHUX2NJxnPuooYA9v5LxAqBM3Xyc8TyHblGu2ddq7LfdRlxmjZD6VJXTEG6cUGEBmWoKcay2gNTgw0jmot/RX0qd6bXUl/GTUTgKVLioUqeQKn6xJMDoKAiavVlXpQNO/24w8Zvn+4KyAX2yJXNnIfsir93toEw8n7b6KQY51CwhBt41XPqmAnT99QvTYJVK8WqrIaRT7kiLbxKVzZfsNxRTrY9QkNIMn/ReLmDKJ1fg45yHN+luJPhOlYJZNkp6gWvE1sqFR1HkThzSEq6bCfPzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WutJ3YSZm/D/Wl4GMN78XtrBmEJrMUeS4/fu9QlJERU=;
 b=dGNa9T6t01JjXpj6jK5TJeqhWJwg5ZiiECALJZKgdKzH4x2MhTMKB8eWOb1mN44gGpEd7DMlyBXr2/ZRLY7bC7LrEwXP9DH2plqjd9Rs/WRa9FZvyOh1SP/RIRSfmY6Af7NgrdFGC8aLXzLDl+Us0SBvv4KooCuSdDKHv+ktzDk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5111.namprd10.prod.outlook.com (2603:10b6:408:123::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Thu, 2 Jan
 2025 17:55:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 17:55:18 +0000
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/19] scsi: bnx2i: Use kthread_create_on_cpu()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241211154035.75565-5-frederic@kernel.org> (Frederic
	Weisbecker's message of "Wed, 11 Dec 2024 16:40:17 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v7uxgkxx.fsf@ca-mkp.ca.oracle.com>
References: <20241211154035.75565-1-frederic@kernel.org>
	<20241211154035.75565-5-frederic@kernel.org>
Date: Thu, 02 Jan 2025 12:55:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: a949bf7c-e588-426f-422e-08dd2b569e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D8Y6LlvoQ9EVyxr8B3YCp5I9sd4RRzoPsstU4DTl5f/l899znTOEZ4fqyS1X?=
 =?us-ascii?Q?+6c7uVXEKpZRhpvMCm7d4nvrPYwDQGpza6hKbXr8i8Tim003qx/uuSOyrFvq?=
 =?us-ascii?Q?KLqor71RfcyBlHIeN254SQfSxG66hpVojnqna5Q6LyDfF5/BuTNxS+60tW0S?=
 =?us-ascii?Q?Ru3RxyKHu2DMynUt/m28C6PxjvQpfdlpO3KB50IuPtUpqCPx0SfMz4vcpSLY?=
 =?us-ascii?Q?nKiXdAbmDvCatop1gJWT6wL8qaUrrP0wrZhIhvqp1KHNGoimNW4F3bJlQMQ4?=
 =?us-ascii?Q?7kDU4Q9zBnoTtNOCas8wmLOLYcJhyW+DmNzK2DbBaHi/L8/Jws+/KYph/SS5?=
 =?us-ascii?Q?99UvxvrAlnYmczRpD0MLmroTpSz3yqnKb2adxP/SNwL9Dx7nHPaCQGBKMVNB?=
 =?us-ascii?Q?Ni8akPUej0lSj+bYIji6xn56YwC8ouvlc3nifMb90qT2CH1OCDnvRKfkYjpU?=
 =?us-ascii?Q?pEAvfJIFim5oT3X+gkdP359/uTzlJeetHPLhA+nPze/Zp32He9RuoeIWjTbw?=
 =?us-ascii?Q?7xB7ZtfFybXXYphg6zH0hCwPjTpRy6OIwzbzso4prJUSGa30aOtA6hLJuE0N?=
 =?us-ascii?Q?SieSJHJfmv/YEV9BLAC50HIVad/s8VSuUS8/Ogtls+WG3CT3XWm06W9wgdpf?=
 =?us-ascii?Q?RloQXezoG3B1/TNc7ZSkK1uB0KZdSTbumRlcSz+jjXNvQH//aOzh73aN0P1o?=
 =?us-ascii?Q?74PXZUXCpvVUm4Mi85rnlAdYyMcROIlRKjXONRIVMY4yEM+UlXDiGySKmJ05?=
 =?us-ascii?Q?Do7gpQlTTZ4n+z5uHFgO3bOjOI1rgDE9cOZlzEdhwdtb0lgG/S6vka1jvxaI?=
 =?us-ascii?Q?aXZr+yyOIvCkSbyMD2/ZAnqhFimT6n//1VcdJIuomVzGu45U8QS6JmBrVhi0?=
 =?us-ascii?Q?hBUGcchb+mPtqt7dw6H07cLS8sIVVnogLisJOYDCyHXSVtzVk5xI6cmfe+0j?=
 =?us-ascii?Q?6t9FF+63sBpsoBTBLzK047JQCFjKQXhjCkPMPyBeKYro+K9XENtfXMs+DMQJ?=
 =?us-ascii?Q?9OB7cwL+1M6Yd6bRBJyVlbsEtIOqO6Xyxc115LIAx4tLSaVZc3Ye4UpNQ5fN?=
 =?us-ascii?Q?fR4oLPqeN6wANEuzVFG93XRQ92f78c9JzBUluPP8sPyuhCM/qGFH/UvIoKaS?=
 =?us-ascii?Q?zcH2EqA0TpZvbDgJrtbzJrR+eDN/qrAlT7d1qmnsisj+sE7jlaNGYW6gptyB?=
 =?us-ascii?Q?AA38aE9ngDU6Bd4sIMUSkfbTL5H+hnxroYO7/ZcA5mNY+9XjYSdmR2mJrf3r?=
 =?us-ascii?Q?gZOa5TO1nJFLNXEHi59DseSFAzAu3+6xb/rrMyIhirxFyf/8P8cm8DSdtC8Y?=
 =?us-ascii?Q?SoVTw7dNjuWPZ7ETIsKDM9MUYALj7TkwieQYYUoZK2NOk/2Ig9yCLzHuPjcO?=
 =?us-ascii?Q?ktpEnNAUrnMvb8E6z0C8gpPmwi3w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6xoYxugHvtlghJdW4X5b4W8csTk0+xmkhfkmWv4XMPQL20B6w0S4gNtWUmYK?=
 =?us-ascii?Q?6FM3/hNrGzDZjGZMo6xOAju0FgY6b/WuxNTYIIrIVe5QIitjlIB3LL0Ha4xR?=
 =?us-ascii?Q?T813Aa1clFlapW6IOgyJb/5E0m/HXhoDrBqYfBlf2cOxfTWLQKQU87ixVMQc?=
 =?us-ascii?Q?4J8V2vsVQTuDUlfyG1sXU0toyIScvaAEuWRVmoKRzD3G6qo1KrDQIm8MY+cA?=
 =?us-ascii?Q?lOST2bLeNLK59kvp2JeuXMpIk/BiZJEGblbZqlxkuRiUcKkkf4oAoFBF5WBQ?=
 =?us-ascii?Q?z4K1uKAE5o3Q69NYLNX5gvT46VQ4JReyZTp8EjqfYXIfoIdljvBMqoGakOQG?=
 =?us-ascii?Q?C6TEjvJ+b2md+AQ4XvCrb14g/cQXtjjj/lUjHgfsOZQSHO7V/Z3IJhf1Jixl?=
 =?us-ascii?Q?tYZjWoKC0OmrU9M/8fVCNRBDano+lKwv97sKlzb5Ds8qOTtvWGSMmBt2Yhyu?=
 =?us-ascii?Q?c3+MvNuGLKHnmQm0faILsBARy9e9sBdxKaGfFpd8GfpDmqA7J0Jh5rsD9zTj?=
 =?us-ascii?Q?CPSQZ7HVfv98idgw5rbt/hyrTcmI7G/nRJfJVxSu1BNbFTjpjaZrzZWpktZA?=
 =?us-ascii?Q?rXYJBZUnlSyqqqRubbL9e8H4Va9X0icFFfBUejFsPCSf+kHbzm/jYMXIWFed?=
 =?us-ascii?Q?YyO0/cw7juE4l3hlAwLSrx7fcOJSmi6mwV2kFFmOToArxoCzmkRuFjjZH+LG?=
 =?us-ascii?Q?px+D5mkUJB351ph5q0UAwMWu4exOto4jBijoM8ANGVujbxr6LucKM/biNlkS?=
 =?us-ascii?Q?LB07/+0gD2Q80/r9I6eFubJ15PYCtn8/idZm/TkhNV/ZQK7cVDag+/QdLjW7?=
 =?us-ascii?Q?fB/iVw8+fmdp8ObNQFGJd4HwU7tYR/fP8kxxZ4Itm5Toc6npPu1t1BQ5f/+L?=
 =?us-ascii?Q?8yi2OU31qXFZ8oRFjSTOvg5O389nPVGILqAVHM/txoLHanZ/umhoPCTplHOd?=
 =?us-ascii?Q?ICeVdlu5yLqk7dd2iif12NNaWbnQNE3ovJrB0D/DJ7WfEmGHHDzX1y5BNM1E?=
 =?us-ascii?Q?ZHRGONXz705TBTlnv0iUCGzxE9nIB/VLSQwr082NWsjS46wM4GitfuxIF6jh?=
 =?us-ascii?Q?Cd2mFMw6ncjYhty9y3OrRAGeYTlhOBwpm+Tbyj4RN1woL+EuNhZUavi3yAwv?=
 =?us-ascii?Q?A6cKvf5/20LW/0ZaVgZgzBOYZo8n6WpiiIbzBl7eIeecTuslfhe1p3z89WT6?=
 =?us-ascii?Q?PswZi1EQDr4r6PzzFyq2NEqlYM/P8wTzhk0IECZJBE+NtMRu5V/j3gdfQSbC?=
 =?us-ascii?Q?PuhMk1k34bA6NGIYJMkPPaELzCysnIRLP4eMzS71uq/L40TUAiP5S/hioMzZ?=
 =?us-ascii?Q?aO1n8TAHct/3K7hilbR32epoFZYLrY4cDY4ZfySGuezNF1L9BGNvlC76DBAF?=
 =?us-ascii?Q?ZknVezuyvVWqDxr3vgJ5zfCxRQWb1iq6FD9nZfYohHFXvSqfTu6RtZwWhzgs?=
 =?us-ascii?Q?Ir2TrSW/GsHp/+TpHcKcqsLDAZPmQ9rOM9gdGkt9G8AQHO99cmdVGt4eUluo?=
 =?us-ascii?Q?yIpX15FNNgVGb6O0EilwOS0r9k1oioPsyHTWotWqBEUPz5/uyFHIKtsUgHeM?=
 =?us-ascii?Q?o+UBU6BhiE8iPoHRHLH+F05pDxzOOL8SFXnfUhGMTlpn8nkZihbRU7TYbaqW?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xqHXaED+3DuG96Nkw9T7gyN7HcDcGNs8LpXQpLVoVkWXgb7/aTYwVQ4PcisbyofPezHPkuOCd7UmKbgCQRmurlmrd9fzSqsF7p960ImhOEaT9krxCbPIwj36jRYBBmINAaLeOl+DA0y73x0ABn9ig/k/cMMRdPe15fUoQIbT0QqiQfeUS5V+3xEuySZiuJUiuPVyRz36jYu7sCtc+j5hHPml0E//Be9gexylZCgggxUQMtinFxadjzbn1sUs8DSZ2nOJU5ztviVNrlsoUK5itMJzIoTv6mSIbKehr5Vgkse8pbM09/oE2+MfdA5XhGI2Zl02XjxjRN41SqKe3HqF/AtMMdIFoD/94Gns5uY5oCTpUEnxkHTP1BtbATaX3jsrad7okbYM1B9h7s7/KSIyyi1AcbqYjD3+SglQPnI2n4bXtaF/vFSMJqyijOshHnu/fG18Nlxd30rfK/oGvLH0cGiKsai7DyTY2D0JsvRQpUq0bvFQy6DD/HXMmDZFrTpz1Nz+B7IHHo7MdXmAThiJhnXUbqTjOU/Hr/JTLhOmHUWKQwpiyuo9wk1o0zJtey0v3NAIm4wyKzETkGPEdFWCWERvwXBkaIlGhpxEIbb4i3Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a949bf7c-e588-426f-422e-08dd2b569e3e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 17:55:17.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAVnD43NbjfhS3ijjg7GsBL3wsuubOTMNuzBQ1WpcDbzRoxw5A9soXndEPBJwCGhj/sgAuUuYx+Lkhab39xzJtByZYwmweqvVwVxClop2sI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5111
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=538 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020157
X-Proofpoint-GUID: 7CpVWcYLfN_kPHYyYoGPhy18afMMpjbT
X-Proofpoint-ORIG-GUID: 7CpVWcYLfN_kPHYyYoGPhy18afMMpjbT


Frederic,

> Use the proper API instead of open coding it.
>
> However it looks like bnx2i_percpu_io_thread() kthread could be
> replaced by the use of a high prio workqueue instead.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
