Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB602036E4
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745891679; cv=fail; b=irg2DvCCk1Uxh5neZvKdQ96GqFki8CrVWyjGHAXH7NNNd878BWcOMc5P2YPowc8FIWQ9/HQtv6NcSLRxktmCN2S7YNwoXlWGnqSCf0AxCRjwuVdYuG+GFFFzw6Hu7b+TNtAzDJN+66V39o48ZHe/66sn3YQt3V2/kyeFCgwXf/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745891679; c=relaxed/simple;
	bh=iqLPSbHym616YxLo6KjVA1wKBoz9gMACCaXv9TphJqg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BvQQlpNrtwk1Ckl9hTXnxX/QOHJCbZNZgbFc42rpzyFBhEU5DbjCPdAuiPeOM7UUshOb1Qg1vXCp9yTLyxeRqZqGEeYuhVmmMl2mpeaMwKk4hY4NIdVktlNUG81yfQIXP7s2HT3OOHR2CBI/s6hTJZJkAWD21KzxlWslMj5FUUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P/JBhUls; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ATmnMu/B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P/JBhUls";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ATmnMu/B"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1fxf4004986;
	Tue, 29 Apr 2025 01:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=YlV2+/bDZ8R4cQbEod
	NyA3zoKqNDkPrbRhupdEir7Bw=; b=P/JBhUls8eULZh6MiQT9OTYradjuP1xdm+
	E/zenCAAIae6nSCOfYP7BkSGX2ZM6GytpgM7JX86utGj73UXpCWG+nFULz/paybx
	Ptq0HQ9RVYHrx3sJbqQIoXI8w53lTF5SZlfZo4KL04vrDadZww3XA0Smc3rKwobR
	7NfZdFWqYOpdsNvOLCNCB34GzOzhriy9VvvO3HHz40fRLTEa2+TZSdak2PdJCxRW
	JnO2sQ5eCm7ioNJ19IEPxlXFpgJ7KoOuIIDd/Gjs1oGV1P6bz/lmkDlJVbanwK0V
	ObVZO8cK5e7C44rMw6NSrgge+BGVrTiUqZXoh7sz+q5dHSPEExNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amrer1p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:54:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0hCpk033478;
	Tue, 29 Apr 2025 01:54:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx973k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e3EJ9a5JNVXfIaSIMxx0Z1+Lx6PW4SiEjLnBG8UOSICNpNS+oaiHv753D9DuIIZlMD7lJF5ctSFGEqeI+iW5IBnn/zK/BmFdGEn9eG3O+UN1YIubUDDKxoubGa9+dBLuBtRTk0xUdHQsk2EsTrbufe/9M5MwvdSi8e6qom9juoh0wyXvRvm9a5Qy6siAiZCzUN1DNSIhyx697cYna77QmuSDeSY6MF3as7OPGGz+1HM/0Dlq37Z0GfZEqJqMoElArua5sIiPHVYm57/7qAbBdDnrtEUQlZ/6rSRyz4NLEEx21eplcMR8KmRHSFZx4HSbTIVe5Y3pulwfsjxJ/mnpVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlV2+/bDZ8R4cQbEodNyA3zoKqNDkPrbRhupdEir7Bw=;
 b=PU231rXkVC+dbOFAnNSgMjHEdnRmMCDGg+kRXWFmMCpmM0Xs43s1vpOxrcl+LO/e3n0EhiYAkk4EAYpvtqFg6eeRBGcWmuHIdbkEZmGhbdSbhojQyyT0xrac/g/GZDDDYbj8x/Anp6vyFAEgWkBoB7Dz2xEZaE36Z63TIMPKa/+gOBuJ/L+gija6YK3B51KUu8pcou+b7kBEfR/ViVDe6gRgEkUGbw9f6ucZi+mRvPQ5pQdpgiLUe38uIb56cyboNE3CbfNQC0Z+xZYO0V2HPigVifElg+bcsUokHxU7d3cHOE8Lt2FA3MeNqJkSAaVv4EdbE3A+1FflyoDHmNyWdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlV2+/bDZ8R4cQbEodNyA3zoKqNDkPrbRhupdEir7Bw=;
 b=ATmnMu/BjLu2u5fVsaPNmGAnIeJRh4948ZN69VV3+csP0BqEbj73sLTwYAhOZFGbgJKVTSbyEqUVz9w8x+x6pg3zGlPRljchygjuJYLuhwvqz2Y7jq+o6YGV3+CFzuPXEg8+a9uq9wQ7jRKcuI0B/nX2A/ZmA4D6oayV8xmJBrw=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.31; Tue, 29 Apr 2025 01:54:33 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:54:33 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Event processing debug improvement
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250423092139.110206-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Wed, 23 Apr 2025 14:51:39 +0530")
Organization: Oracle Corporation
Message-ID: <yq1tt6720n2.fsf@ca-mkp.ca.oracle.com>
References: <20250423092139.110206-1-ranjan.kumar@broadcom.com>
Date: Mon, 28 Apr 2025 21:54:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:a03:100::21) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 681c1845-acfb-4858-9175-08dd86c0c990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vBjamGDsIhCYL+eBCKYASn6JDP73bKl05SEMvQxyDyKAJkkxN8ijZJHwGTkr?=
 =?us-ascii?Q?lf1Y6ndwDomcBgLnOwV/YOxtH68gbb66ySRb/WhuKu8FF18RIWPzOTw1sxER?=
 =?us-ascii?Q?1M4iZWkqYxSQyA9c8gGK2fjfHqXUhs26PGK1l78pLjyitZd76BcQt7DDXDVB?=
 =?us-ascii?Q?OD8XsYAFQf3Phpt7h13VlpwNw6PaKnMhFEpZIPdSbAob9D/XeDr/mJ3hAEQm?=
 =?us-ascii?Q?fmJQ1D/QNtX6TUJkO8woI1stuflOITJOuWXhzK58XmUkk7KlKaHpZExy3DwN?=
 =?us-ascii?Q?Uvr2vkR6t1hcDVQx0WRLSX7FUDna5Lfy4mcu9VRoyW4YHqOaPvLj5K5/00Js?=
 =?us-ascii?Q?VGbJIU9tXD7vFlS66VnyygSqCOgas4gY03cLWsIgFZkNHBi3/QF07r1lbca5?=
 =?us-ascii?Q?cunBe+uGNbagaruTgaH3aigRxEqMGpbOdzpw8+xWX2giuo9urtQmFK4APce9?=
 =?us-ascii?Q?f0YOHgFAMG/nM4aXbUTm5c5REq539ydL5p15FQlZ+ZTBX6SWtUeEpBpXnnaR?=
 =?us-ascii?Q?49rXLmeJJZD1BrWQjOOQqsk298Dp1BkmVbb9En0mXszyuNfTVeENvxOU+Bh/?=
 =?us-ascii?Q?4Jy2zuQCI16JcMbfZP+iP/mzWbuMDzo8G0A91tYSz1+lFGvjDAWCVw3nqwIa?=
 =?us-ascii?Q?u9cvyUuyKy/5f1hFaXPgkAd6rrgCjvWm7SY8DgfnVnD2OX2/d+sWzVE3H4T6?=
 =?us-ascii?Q?UdEwjUruOrSoD+TrUx1A/t0KM39JZsm2yiyuYENI0Lnd1PaCQrUotl9M4owi?=
 =?us-ascii?Q?5GenEhcthitKF5ZNwkFhogZtjESI5P0EfLz1Is+usqm4z/AVeuSsedg3Sgko?=
 =?us-ascii?Q?w0rk7Lpoe1Fw06Tlxzbl7eODhNZ97DQBY6aDAt9iNiFKMsiZlUqXhxNXN6x6?=
 =?us-ascii?Q?4qqUokPc4PCjs6zfWqMEc14UuE5emArWKLOs4iD5BU8EBF2esDxTdF/EILhd?=
 =?us-ascii?Q?bi7HgRwFyAaqGJLn66QULJsP6ma74iG23n/9ndVsiSsM06g5ncrosNcJQ2h4?=
 =?us-ascii?Q?BXayZyEWSX4VamP//M5MmY75VXsV6bZM+haxdcBaNIkQPH5bN67qPSrUiNQ2?=
 =?us-ascii?Q?Kph1aHQ1jh9ScJetwOq40p5RlqXTl/bQIF2b0ihjVZpJD2QxjETNNkxJ4boP?=
 =?us-ascii?Q?KyBsH673BcDo/Xw52YbalhFo8LcOhJAAOhQNaTEX13hgMSEx7n4FlvYKCAPe?=
 =?us-ascii?Q?NDxyX1DgIlfU07bg4R/aoX/iE1/RRmw0rUpbt9Lu3aNhwnZovAFG0DU4P5h0?=
 =?us-ascii?Q?+eETZ9r8HZlqjhSK8/q8OK7wKZaEDxveuzR0E02nDCunXlCdK2J2rLDYpr1Y?=
 =?us-ascii?Q?NermqwBR6P9CCP3/NmEeHCK0cF2BWaHNxFVglDc68qr+gtqNYot5htwxR6CQ?=
 =?us-ascii?Q?tpaFV+3YSEo32mwmAPYGlIHIGy5SF0UJyUYrwTG9RRZlpZPCbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vmHlTIW+6jWliuDsv6o/mqRIQpm8rlpSvk5LWHqwNYlc+qSAOaqAuba8LFF1?=
 =?us-ascii?Q?hb/YdFbAGNaVN4fQoWSNcJ7YNUOOu421tLK5boOTparlgPPrWgyUbx9QDhux?=
 =?us-ascii?Q?7GRngDffeFv04efbnPgdSv91BBZU82dtMnzlCLC05ErNUor3zTywu3aEVF+M?=
 =?us-ascii?Q?udcqr7PDI7JruGUlbTarrw2fsFTFZ8aWkjvAw6rGPSkiVT4beGIhKNxgr8T/?=
 =?us-ascii?Q?7oQFWy0j7aUjZIbo4zrrtl6vnWysMgtRSnZ9Ipx2VbqbuGSqiOR1f/Dpq1as?=
 =?us-ascii?Q?hEHrvuTR6uCGcRW8Ldk3Fwabejf/Jlcc2TRrGG5IWUDiE08w9oFNdWVPVdBx?=
 =?us-ascii?Q?FnlHqiH7YCqgZCLwdbowRC4G6ZDoqFVnRp/moBJOw/LAIEkDjBKk/dA2E/IR?=
 =?us-ascii?Q?0PXuXNYYRftXU9vFLMewHBYP4qTI/WFpiiyHSqa6K9oc6HRJae5qlZRhUKNL?=
 =?us-ascii?Q?gbgNcjXJslcgMmTrydL0dVx5Ya+5QQWvwTZacVaiLT1SAGffClLq+DwIoU4p?=
 =?us-ascii?Q?VgX8dUfhF3QxvYow4DIWHxJ5QKSryNKp2duiMaQObolAKwUQBhKSuf11X+ov?=
 =?us-ascii?Q?6sl7+r7OX2f8yH3ICjC0+jB+3kKrK4XCJmD8FnPIOdmqwlx7XMO/tWgJ4qrG?=
 =?us-ascii?Q?KATpuG8v/VpE0FN1ctASa08RMHI+UkH4ZuYybi7OpXS9vQK0bIdPbBj8NFkR?=
 =?us-ascii?Q?RY1ukTgjZ469Vw2JvmVAwxnpLoGH8B5cqzdggKPG0WIWaXfiS48DcqyTEGu3?=
 =?us-ascii?Q?of2hMWytv1LHXDueOWuo7GuCxf4QG/GV1JdbKfBT4T/OfJJZW4kCK2YnB9Bl?=
 =?us-ascii?Q?d8JMocoh/2shOz9HG4UQ2mbv4jli2Bq7n3gVAU7CflwUOv1sZvSOVb26/gq0?=
 =?us-ascii?Q?XvSNhBKNeHgvHx/u9VlLGqCsQdvvrwKTa272hRvXQ7gOO3rAHSNmR2HfzNLC?=
 =?us-ascii?Q?Uuwn2zOVX3hqw50GkeuqmtNwBUNcsnMAHG6aQB68HvMUn27j5XIelqsoXVfg?=
 =?us-ascii?Q?uaVwpDep/A286kYCqPXutiaAFPr8vVTGdl63M+LkEw9ohlJ0QhLU4czjFViZ?=
 =?us-ascii?Q?yY3R89LYVgLb1oapCjJz99B4r4nlV46gymzQAHHbWJXl00swkOtkXLUSeFfA?=
 =?us-ascii?Q?wq+iganhqxSwU3XNSqAGf3myH5pZ9tQB1fuh0tT+b8QppXZLI4N1kOJvhyuD?=
 =?us-ascii?Q?KANzJQJTLRtlAN6CVL0+/I3cIj0MDG854Sp0z8bmmmcYQTBGkSwfcDhLMtqQ?=
 =?us-ascii?Q?eMs43X7Nnl7Z9IvKBPGTQe74jEfGzxH9pibj+nQLz2n6FJosZFQvwRvVi8Kc?=
 =?us-ascii?Q?mctN2q/xt/h+v2ozJ0zBKKcxTXx0JgyPwkBB8ZvgIrFjZpisTeB/0dtPg0mk?=
 =?us-ascii?Q?0aNz4JE2h0VY82EcnG+KFpwFYBVBLfMTei4C57YEgUwEpr3RfQIGa34XQ1NR?=
 =?us-ascii?Q?khsQjFVXsGnXtOvAwFyAYKOF0oIrUfZvOVXaOQQPITRh3lSM8rcNsoCXJhOv?=
 =?us-ascii?Q?FrUXU1VXRpU6vwppHH5qdHeFFQBD+e2ISc1WWh2Ha1uY7zBJ8hqYvubizwZN?=
 =?us-ascii?Q?7ywzFY+xXmx0e3V0o0T4mCFDKr6mrzdmU4GyoieXlFvor9fTe6pyMwB68FEc?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ssXZzo3aRXDIoQdIsAvUzpHwEiebuOVATv4JFlfaE5G3kIbgaA1v8HtmYhy8B8kdxRkOIDnFa0lCOn3l4esCpmcj/mcFmQ5EkelkR5gThtO5myFF8xmfqJ6/7gHMdAzquamKfYQaT4wI2BbnCzvIRepjVf53HvV+svmQbvYzvQuytGIeIXTUkW1hdLMIPpLJz0mzDM9+YefXhVN64aQPF++weuX6uHVo3oWZMrbtK/eTqq6lQ6kjLDwk3QGcV/ZbjmOELe9d7JAxJVatsubsj4WEZ8V2BNOH94cbOwN8zUuMF2FUCkHuwiVXOTFhdd+PmOEOnZ4uhjU0s5KzC9icpT4ps2VqGAwxNfGxCYnWvVw5IC+WJANoaW/478oxKNKAhEVKQSQxs0/lVPNxo7xb1zhFN62EqPanLSCk6Qyuu38gaO67o0hrumpJtZCoq3czNuhXp9sYrW1Z6IsuUJpg8rV6ur7B86WsBci9WL/iAjRIHPKpBiI6sZDAxjQy7oFoIruqMg7XjyhqeK1hOkR4+oNS9Fe96+kYWDcZ0X9SgKuntexpTKCz/Rb6bMzgkMB6dYGG76yb8UkziwxLEAKau92CQ4S6iyXt3MCMcSiu6Ks=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681c1845-acfb-4858-9175-08dd86c0c990
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:54:33.1978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d35LUPa5uPaQKf0CwDTR5zJ/xLCbkOywvZYQaZ82mwk/XSaW6i+qWcMnIzHqlxlPLToqfmcdw7mHl7gdjkckg7M7E5mFHJQnDVj5/sAnSXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=817 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290013
X-Authority-Analysis: v=2.4 cv=O6k5vA9W c=1 sm=1 tr=0 ts=6810315c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMiBTYWx0ZWRfX3YTdHWMVOwLw +DocW2FoUA2HyF8bg2m9WjCURvkAJnm2PKgbnLz4NoriZa0WF/lVaWNAWH7brMKi1ORoFgbIydc ufYrQbFObhk8Ifopun/l/Y4Qr6GOLb4y8AIa04Xla+65oddEOqnhSWahNP1eqSkIzI4dKED/bxz
 wKMOjKv124zbXdzShKr7tOZbFBrhss/9pVcdRyFFFQBV4Do8iTlkhldKzx138IQ1DVA2KP41BES dYR66EL8e4iTCybNEE8g1E8dB0q/ZN5/FiqrFTalUxYNWhZYZzNVU2xL5uJ3E/ZjEf7TZgb3ame 5YdobPico//3SHRK1ddVnGfWvaMj7reSIpbKpDMDXKWyzLlO721FzhZ3Y1fHEgJvEHIqPofsoTZ PHApg8kH
X-Proofpoint-ORIG-GUID: 9CY9zSnVu9cY-olykkZ02-x57rUzjigM
X-Proofpoint-GUID: 9CY9zSnVu9cY-olykkZ02-x57rUzjigM


Ranjan,

> Improvising event process debugging.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
