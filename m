Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD54279327
	for <linux-scsi@vger.kernel.org>; Sat, 24 Jan 2026 03:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769224752; cv=fail; b=XSmH//ykhCTqaBtCKB9Y26XkRXqYIkuMJj234iOOzCBtyrYj0/M+48xbr870dVY6tws/OAts5TAaHIkFAquQ8l+S6g81pRwBEg90QbpG03gUSK5kE+9XzRTYTwyoWi1YzuHQb+HKyDT1YxHYEvTVg/hucgF2zMaJdHdFMrCPBKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769224752; c=relaxed/simple;
	bh=yZf5PiLdbmC4PrKorGFraDxlTxZUJSgFMPcQ599crYE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SrCkG47LCaWUmMDtAdlYv9pSBAJVI/NLizi+R2RG4uIVL4SqrRE7FwctTc7BtdtgBvSxPezisaIUrb//de4i8+KiMnBQS+Er6dBOfCqcDuOfAvJp0ulL1U8oqW6LWkNQ9z9KgZR0s3OgdvSicDB2R210yABKx3mgH+wBI2ylNK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jkrCLRDN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BzWksQaE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jkrCLRDN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BzWksQaE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O2YLg31108335;
	Sat, 24 Jan 2026 03:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ICwMGN6NjwiQAyTKt3
	vl5AytkyH76SLUS6SMZga5B20=; b=jkrCLRDNA9UsIkjlYQIf4pkPgWOtNvkWC9
	iu13Pbu9gTvHXgYXx7SqddCpkaJH9ppaS5+IIZrRNzluVfczniWcvDmTevwOdMfv
	A+nYuPORcTXtxQOZ3ksukcBtAJb8/MBpWpJSwPegxzaC2VB3zNirT7sXHwfzSpwZ
	UpN71XJrNQt8rOExqnMbJq1ttHLWUOQezzGauiu+GPfINpt9Q42h4hP+a6k7+GE9
	PDOsrF6wz5B6FNniFV8QZduFoYdIc9VflokinGVXy3K5Tipo8XDK8iQBHJDb1IR2
	so+iDOg8l6iQ60hxkAYCQ5X6RkJ9Q+KztU2aJVbjbwJVeJ6w+16A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd02ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:18:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y0NM035147;
	Sat, 24 Jan 2026 03:18:53 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh61v35-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:18:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOIFfdpXLjncfzg0W4elmUhKBBXbCx/aA/6co7H/lz7PWmyMs6wjNdENQS/wsqEz5DUyAKQHPwf52Otr5olRHDnqoXRUCrq6GN7O66ZcNVL0dHPZdOOcM1XXIvuAdyTmCX3bQhUgC6O91Q63FqHZLjY9sstOLUtq0TczAMJxLMpkYYzkJjdcZhHuSz6uXJCY5SCPsGJDZ0C3keSRY8W9lieCgNW5p5u146oaZWa0sbMKyO2oKuB6yt8LCuR9V19fUNT6r/pkgis5f4JS8CWwSs3GoBE9eP9jJWoFp0FPRUcfj5/kinxC2e+7ykKjB3/RxS5D1qZbImOsTQsPJRndgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICwMGN6NjwiQAyTKt3vl5AytkyH76SLUS6SMZga5B20=;
 b=qnR/Ql2fuFFrSeaaXTOfopDCps8BgSZI8++zUBntBAZ2N3e0p8XeRibrGVi+tQyVV5T/4ujBny5OQ9VXlWtnA5q+ztfiIDXGJ6JEOE2qBGYiDWHvq4b7M6q4QIJPA8+DyPLCKvB9MpyKPNhuLXVZk/2eHibcPP1slLw1V861sabYq0Q2IaSZvZCPXYqt6xLmVm56J+CqNvdpzsvoxZP9sFFfdOufUh4nPf/cOjeutsl7Ju87oLMhtNf6CCec1V8bX9cakKg2yb7s6plC4e62WSt86qb5V64NsgUl9nMypSY7LqDNSic05TcofBQZXO5bOZq+5s4IXpWPQuN+rr9BMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICwMGN6NjwiQAyTKt3vl5AytkyH76SLUS6SMZga5B20=;
 b=BzWksQaELCfqpzw180AUN6UZ7ydO4oQrymhmIIFWUoFuzP1eD0RwvoCVUJeMUDyPslWK2n7U7EJA9lQRVSIne3Qq+b8C30cMuSXQP56UnRrgwGklPeqGDNRCC8ir4aVyq8zuwobq4A9Wn2XXCAll5grs9vtyScqQj0OQc9huCGg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB7525.namprd10.prod.outlook.com (2603:10b6:8:188::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 03:18:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 03:18:49 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
        salomondush@google.com
Subject: Re: [PATCH v2 0/8] mpi3mr: Enhancements for mpi3mr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Fri, 16 Jan 2026 11:37:11 +0530")
Organization: Oracle Corporation
Message-ID: <yq1jyx7y9yp.fsf@ca-mkp.ca.oracle.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Date: Fri, 23 Jan 2026 22:18:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: fb93eeb2-4f41-4977-3c82-08de5af74ab8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?ZaQ9BpjD8ZKRQdetyLZrVnr542Nd0wT+rpug1iToqMtyx+iyl6Jb3pN2sEBH?=
 =?us-ascii?Q?zMSmqKRuqHMJuEvOBQ4mRhpvmP/tx9/+iJ0p1mHE4oGXnybh+nYngQ8SZGP6?=
 =?us-ascii?Q?JEi2EQ0b47s/IICmWJluW5PfnnDO+6j8NYTmqWjzlK/lnuU3N0XMuQZqIePu?=
 =?us-ascii?Q?zXwY5jTktS8fWoawRlVwK/Wlys++wrsvSjrGQvgmqillNczAMyMu+XsmJjYZ?=
 =?us-ascii?Q?o1qR7fzZ9LP68LIIvHWvRocM6aklYh9eL+V1xZfZBgv0mDEya/RFyscEkkSf?=
 =?us-ascii?Q?FRxnQmsn8mTreMJHxqkkmouoeEzxVqRyecg2g/fkeWg0REXni7jMI8W7iAFw?=
 =?us-ascii?Q?TvWYdIg/ysFWpfi/3N14Zo3ZG2A6/zNjNgC/2dJOfGqDvaSVJHsT2hrgisXR?=
 =?us-ascii?Q?D0NZjX1KKBdlb1KOlcL1iCRI46S3Bz3ceQ0D9FgB2AxdQCUdEY6da8iI0r5P?=
 =?us-ascii?Q?1o+YJo0jPF9jSNLiimSTHLvIVWUp1ixYFI0TE6Y2tqGYLDmu64idGOzP++Gq?=
 =?us-ascii?Q?YFZheS49lED+aEb0fKWnpNcF/x8XHWPPCm3BXMlKix3ZCdZrb3ZdmubGCjg8?=
 =?us-ascii?Q?By/gDv5pN+RCOECW4X9YkNumsQEeMtnpesB1dkvZDGWZIgOByQPICvosjyEL?=
 =?us-ascii?Q?b/v4iLItwQBI5UHOG3yYHXPnHCCJMZhL35Joukm9q1U21Am3g8BQoo+UPZ5W?=
 =?us-ascii?Q?ju14KoVWlL0+nwhsAjW1HGV9hg9VmltsGmr2JkwVBeTMQopZBeO0m5efaoul?=
 =?us-ascii?Q?IVIVQBrdYPBXjtgcd290uVBKRQ0KE3yVNwkBySgNGZphq5UYWgABPAwk9Mc/?=
 =?us-ascii?Q?yBETBlOBurwAOjWxov2tZD/JCkBxkFSkSYdmVLb0AZj0XEzFaK+ixq2bdyqU?=
 =?us-ascii?Q?pw6rraTDFe8MQFGpSYGwpfFqOjfSSmQW1V74v6q7WmyZx65eVIK0Gu3pL9Iz?=
 =?us-ascii?Q?qeuft20J/S9FN+cvHqJZUCXrduKXLQdIMsD2B5pRyAlv5DHhgW4bOn3aymZu?=
 =?us-ascii?Q?dOorIgyYcE271JCr7vakrFPi3CCe6NyZZY51K8Gq5a2JMo9BQ/A9S5x3pGEq?=
 =?us-ascii?Q?IFT/Bl65p+8XuwoUlhqDhlHBw+tOSxKvjNqoT8zme52BwtlC6m82KRcX2ibQ?=
 =?us-ascii?Q?3iBkh0LpkbDu77CK9r8jgzW4Bzk4em2ccPM4NNyoF4JtHl0p8hgDjklO9ZuP?=
 =?us-ascii?Q?jiLHpRT5IqKZ4OfHriR3fPEqRarEzpX5DcH9HRr5Nw+6yjhCcZio/iKt9c16?=
 =?us-ascii?Q?DlZC1YMcW/K3giMMbUsUXUhsY8P/iW9YCBR+J6ZrQOwjiozw2enRGawkCh++?=
 =?us-ascii?Q?/jgYjGY3DhMFOfa9r3PA7FlyIp7Sfy56TNJfc6YTTBYyyrNPE3TOfatUqiid?=
 =?us-ascii?Q?6U9XVBbUVWRtX4kCD0RadDBDPn+gd01mXnzdhtVpwpU+rmXGQPBMmTy2fp3j?=
 =?us-ascii?Q?8cvV7eeB8eW67VzP/8NbDM4UfyUENaeargtw6WGyyfA/5uUhiizvNTt51CgN?=
 =?us-ascii?Q?0IbmskEM77X2OkASwWGkaEZDrbaZ7rUYXT/iJ8e7wYDR7uFICNvZ1M1/sNxr?=
 =?us-ascii?Q?mUBU0vIqnG6VMs8al8g=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?2APMmcr1ZjGjdXD1+jYvm3pSsN+eRsuHBmJZ64IiZ7RYe7lKDl8ByYqMB3S7?=
 =?us-ascii?Q?QjllE1sZhKCwKnbZ03Xlk3L60Zc7UBqp6ykloRv3rdK79eYInKQkyY3AkpgW?=
 =?us-ascii?Q?GYH8Y9uHfxXEcwf87f02dEdiqZW749BPouQjetR13uwkEq5PrnIkvXJ2/Hu/?=
 =?us-ascii?Q?TCTjB4IGUh7blktTjVrLNO4+OSHUllB9iFH+Hz94DwNHZr/WDuZMiLGPpfXT?=
 =?us-ascii?Q?PC8z20S5DxQ5jmXyw2EFsEuGri/lhjILsak1Nj1dxacuLoM/pyF+pB3JOSJh?=
 =?us-ascii?Q?fy6rKX6LGe4zKHWjWxW43T074SUe8eQjXOtAxb6oQbtFVQ7etx9NsgoKMuWZ?=
 =?us-ascii?Q?4YPbtzFos0SUa+oE7pYua4/R9he96YSaao/b/DwZSwxzXdWuhjhFRarCr+N6?=
 =?us-ascii?Q?CDrrr8XbZl2bQs9hjhad0s5nE8Z0l7sm2C5rtKs1OPRMp7bY+maN6vm5uDwR?=
 =?us-ascii?Q?DyCYj3SUh1WzwrM9XpxgCB6i5a3N2h0hiy4kzk43p0k3myXrQNrrjnYS0pu8?=
 =?us-ascii?Q?pC6mbnw1H1+nB6Qnla1tYaqV4MkwoDzCdWDg436R8OBGLbHTdNBn8yvuhCg1?=
 =?us-ascii?Q?MV6LTE+6XbBZk4LUxjcYh91Hhqj1cowpU06xYFyMP6K6hypZE0PhxaDxIN8N?=
 =?us-ascii?Q?RJwb/waUN2H/hPYEpguq3cfYvq+8yh7LWRQQBJ/NTsjc0luIV/DJTrdMvPvC?=
 =?us-ascii?Q?6wN5zEsh3yb3QcAkr5TR1TwkTUAxBoV1H/TNx0fqUIdX1MSCh7XxjrcezDBc?=
 =?us-ascii?Q?K72gH5hYaHzi0LcnE0URN92GxGcl1PToiwyyaWadCRrGEWIW4q0ZRGJVG8SA?=
 =?us-ascii?Q?O+O6BDSPlu5+AlX2akNqMlxaoyhqqm/wb/Sb8FqJGuWjMe7Svv4S7rBBY1YP?=
 =?us-ascii?Q?uwB8ro4witNGOxTy3eFW3fcTWcRPy+8gWeZjCqfguV7ElGjO7if4SwYsp/GG?=
 =?us-ascii?Q?wf5srxXfD25yv4FsqTWb0t/yYGTw94JfhShtYhkUGHJUFH6UTRp0mgJ4NHI0?=
 =?us-ascii?Q?g8Jv9isbRsrznwMwTUUcevw7uH9Ig7qOODB6nw1DJlUS+H9QLnsML4ozS7s7?=
 =?us-ascii?Q?JOwnwdXv2cOmkdZx2/DxDJh6g9ZS6apfZ0WX1eXK+vewRsRy0YYMwZ9DxBJD?=
 =?us-ascii?Q?6C3Qc63eJV1utVnAM8SUzuPO0isUZHMkk0JCjqntZqECuu1I7BUjtASH+5n7?=
 =?us-ascii?Q?9FsrbhzaO4eB+Uv/+mP/AUwFgG4wHDDla/zAg+VmIONucCNhJeasR9qC8Cvh?=
 =?us-ascii?Q?putNocBeU4e56d2SV5F+IpA2SMeKx1D1jrHtsa+ru0y062LxP9V7GHDyFLMe?=
 =?us-ascii?Q?Mz969BEkRl0EyT4QRJrfIUYaVmJrUYNIsjizjCLqDKvEmBMyj+ML8DPpWQuA?=
 =?us-ascii?Q?J0QU/q9VLqP24Jvk671zA9nmga9lQWaWOwIvqDuIvOlAoqrO9I1PSUjfUr/i?=
 =?us-ascii?Q?MaHenSXJ3zpoql9lyEqUOiccX1ydVEeq23Iu7pvz121XDmQ+GeNrrrVAzLGi?=
 =?us-ascii?Q?xFt5xUlEBjsohqcAGCas10Ic3YKSr3ufMw1o/tDG3ZqIwJrxfzJErQPTXD6Y?=
 =?us-ascii?Q?qfBrdnECkU0IqywvEjKLj9S5/L79oT81F+4YTrnb7U0hAGqSNEUTSF4YG8/0?=
 =?us-ascii?Q?hYx5jKg1tolKHA6Ln2NgDbOxfO1N6prx0BpxTRUeSvPrHhK6Wd44yss8xmBy?=
 =?us-ascii?Q?OHe2FIWaZhmzJl+aHREhATCTQ/oWmBtf/CkaYgLRcMnOwQqAV0fhN2pL5fuE?=
 =?us-ascii?Q?K+UvjvLsRxWZldp7m6O+QZ+UPrNe/cU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mmUDRAw64FIMfLHIZB3GYOrn2hwHIT9OMD/07bXWj2yqfTWJvR2ZCGWSQplumNud79qzqYOGXHRp8kTgEiANMu32pZ1EVfuLHmESv2Rj2Aerum8wDc9ozeFgUB2tG2lLE084/VdVaVc5X1xvmbGvT+Fe1vkgYH+b12GNYe4cqQi0TSEK81C2UWdk4PRtXWULlCMw4JmH14V1AHDJ1FlPF7Tn3UAhNaclBsHMRu2FUFR6vDn85xohj4oZlXhLy4WgRBJFXz+Mrjor2vT8lo46U51wXSd0LsgeVFMlMkGkhiLgEVyw5uIe7GXdLFNtePaBiE5l8OKi8NiQn6gfz3p2wpGbmUjaMuE/x9UX4NTD4k5a01jNho8rSTc6GOp7YyV/cXEJ9pSBsEUd/b6wJDUBsmbl8Nrfhwjjiiv5D/vkio3tnVVIChbKEe2+DSShZnkBAG9KHgaAVXiOvGJNgJSeEihx9EWmuRMX8/lXEaTZZ0kawdd4w8umaNQm/aJubf+ouR5FW2G7OzHOG/Qd+b3x+vJ0NUvJErcWyu/gSXl2VYCeOg5tU1sO6L+4MthI3uhEERivM2Ns9Z/igvs6kphk7Srr7GtuZsWPiKopfRfvNh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb93eeb2-4f41-4977-3c82-08de5af74ab8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 03:18:49.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zu9ZbbCc6LmKjJ6MBARq92an/6ymHftv1QGp7ghd5SFesMNNvdcLhhA0m8/4bS7CaLMLhNGgOKdHE8siAdugGZp0anB8C0flb4lL5vwkh08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7525
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=816
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240024
X-Proofpoint-ORIG-GUID: VJMG4AL8IE33izCACOGK4-60knzyCq0e
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69743a1e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NpTe2zR-cC0ZxmeiSMsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNCBTYWx0ZWRfX1oHuPI+m702J
 E/KJcdvad5eau1wcpTlS4wjAR03BM/CLKGgmSd6ag8hosLGUPb0C0C7BvBSXNqozfRi77Scee4i
 AwyEV+HQiXVjrs+29bZlNjmBDT6+1QI7Xqb8extI6djJL4Ws9wYBtyYzJdzB8ugFs2dRBQTz46z
 HO5U0osvZLrbT0JJx3lARxt2VXHFxvjXlufB6+oGketbtVw2SoNgEt5+U61CckDBKbl8yLatZtT
 tZj6XbEyglY8zGbIf57lVKHxAZH5zPxsBbO8BrXcxicfYd+xZyBJJpYW0gVgoLd+KE2lkyych44
 0+4D+FIu2VaiDQZz04LW70Fh7eVrCz+T8C0AIJnMIYTM0zPRZkd4lqKHIVh9iP2S6ZBnV27azwC
 GKOlvJ7W5eH70pGmTw3ZGsGBkN2hiolQas32ntLjWj1c2DTlUDAlzTVZpfAwYvPCVvzHwNdCOS3
 DarkFDAr4HKQNGtGb8A==
X-Proofpoint-GUID: VJMG4AL8IE33izCACOGK4-60knzyCq0e


Ranjan,

> Enhancements for mpi3mr driver

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
