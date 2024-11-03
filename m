Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C87AD31
	for <linux-scsi@vger.kernel.org>; Sun,  3 Nov 2024 00:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730593533; cv=fail; b=Z/pjo0PM/93XytUhHDlZVituR5bQR2ErFIsu4c07VUbYumlOewPIpxZihoJTE1wRMa0gQEdy82pXc1h5zRPRrFE/IjdVnpPFr4Ul0weEfVKeajdqUMOn2il7tE8Cd9xXHduZijSNwoJ7oShZvkEv9qQX0hPZ1Xfot9LYMTVFhHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730593533; c=relaxed/simple;
	bh=ZYbJG3LKC+l0czv10QTTLF3ckb4QZuI7zH7oqvRXGj0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sHrWOVlvKF5cIU/pJlhYBmNPzSneYkV7XS0WLfrzOjE4XRt9tAOGSb4vFV7Q6eFkj00GEvbCR+TDN6UwoEEm+Vxh71r1EjezcnptVb76uV5OXYTObNerRZou/d3mCncj/2CcLJNJsOcBtb0ITfEZ0kSswXzfZwZGM0n2VccJYjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aA3l/5qK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ClTkYChC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aA3l/5qK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ClTkYChC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A30DbE8023119;
	Sun, 3 Nov 2024 00:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=DkCUN5ZGPg6uT5fXER
	0ljzTDzhFQdZmWYZjiJjFKan8=; b=aA3l/5qKk/6yYn5idNp+dN2W8HqsqaT6G9
	dcVBQcXa1rnoTztM2EMunaLW9uh+HrtrozSvhtPc1MtcnkX5QLwGuMrFsN9Bw86w
	Bh08T9FCiB3KQ7TE2s6cl5VSv1rMxI+cIFJJJyhQhFUlxSjaCZGwro5qFSt60KE9
	52c2g/5icuGc02ufdTOGwZ4kY91bM0+wh41ts9TRg1ZbtlZQCmsSYs+rtMgWpY0B
	yFq9guj2k0dwxJOAxslO0ZvdFLDlYo2GNBNFqfDVhpDmjEOd3ot0UAoQXpEjUalC
	+JmP0le3116qSrclWxmR+YEygjLu9glLTkfBp/FKAXeoy4bzsDiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4brndp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:25:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2JUP1Z008665;
	Sun, 3 Nov 2024 00:25:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahash4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xcgK/w4W6kpsEzT3BZUHCgb4ckI++pA4vPs8OwJ8cb3bOvx1CidTUhrHARhLxlooGh14ZMyRiosvOkKoAJid3ahU0HbOi93mXzmhEEs5Brb4LIOKJZOBGvjK14WnL9aGnoqJorEPkp1AuTS5cVHM3Y5b+7i17VRU/5+r7O6ZVq387dFZI56c6+s7EG63JuzJiIXnZGnoKGAFbMWEr1UrEQc8ixvUleZn36rNk/vxMFIpoNFbtgAVZwicmTuJB77+5cnSn4LeVb/m86BpQsUUkgMDQ52aBmmYg6JHSrHiEw7MZbgx00XOiO5hmNlAh2x+/dS1mTe5zqA0OyYtWYnHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkCUN5ZGPg6uT5fXER0ljzTDzhFQdZmWYZjiJjFKan8=;
 b=kVgjQRN48X1zF0Rmak1pahNpgkUoc6J9WtOJLCXSNsWFd9eK+Hk3BW4TJpCsd/eHUV74YlI0CMmPlF/s3gsryeVMnI+m5/HyakTxQeAIA4lQOGK1G6HrtDOukmN2sc8HBqwRi4qCDtsXoCBbwAkAONDIMPyEVi47DGnCebkc/Wm0NHRJou1WSS+MLWe82VBqNYYGDAFcz7azUlQdDRvuLY30SdMLmLzph6DNgoxn9rMLnhyXttMTgU7X43ZkAyxXy7da5mtchr03NWImShCjFeisgU4TVbSTBZFdYqVslwAm7ApPxS2hqFY89EQFdY6yj/gvvBlRTj7bGKnrAn7GuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkCUN5ZGPg6uT5fXER0ljzTDzhFQdZmWYZjiJjFKan8=;
 b=ClTkYChCBWxLdMTH9H9+03xTW359wSWpWxO1/L/oIY6H8zMQEcBAiqDcnDAd1R+GUwdFVvmLmQafqFoaR+ciBXKM0zicxCGi06xaWhGqfssxO7WnZkeh6ISmcrtwj8Tc79BjePLjdCv5UZZV/L0yQ7sydqREN9YJMuT2HENmyLE=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:25:26 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:25:26 +0000
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Switch back to struct platform_driver::remove()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cfhae7lnnna7difhdurabtysh3ddivl5veb7aof7u4cippurlh@gyojgwbx4iut>
	("Uwe =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Tue, 29 Oct 2024
 08:32:40 +0100")
Organization: Oracle Corporation
Message-ID: <yq1jzdl88px.fsf@ca-mkp.ca.oracle.com>
References: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>
	<cfhae7lnnna7difhdurabtysh3ddivl5veb7aof7u4cippurlh@gyojgwbx4iut>
Date: Sat, 02 Nov 2024 20:25:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016418.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:7) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dadf9ae-e3fd-440f-b594-08dcfb9e03c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8pYN4vBnSy3AX86pOTAyXgnxPztJFPgDsSYqyb5Z6mC8dC5IEZM8yj1jNkpy?=
 =?us-ascii?Q?MEd+AI3A6oBFSZ8tHxQs0YZM/GR+VFnhArH8qd6BlLszQquEzzMdVUpiSau2?=
 =?us-ascii?Q?8nXYfwZ5pXxDrENHpr+GHJC9PGRHskGwRmrkNVhSTrdYgZqhkk6X0nkVMVbf?=
 =?us-ascii?Q?sYzcRXBlG2+RJEFoMiY4nn77iDj/Jfldck6BZvyrM6+3ayO1tJR9tgVEaL9J?=
 =?us-ascii?Q?tt0yzkkcfyacpCPDubv52gBLPzL/yTgAGvsrqpiFIf1PDDzb/UYKfnpw6VmU?=
 =?us-ascii?Q?Qii1YLUQGZ9NZspRdG5Ihm0cZVRDuy+dlTgHwpU9wmlTjZXMwvCmnArQgMx2?=
 =?us-ascii?Q?PSTKplVN6mf6/kwuKscU7bQlqVfJ5G8CCyhxQlQuDgQv/IuNexOhhD9zLd5f?=
 =?us-ascii?Q?+2kmtVc5CoC5qUHp+h/1z6MiQI35ikPg5l7VUnv8/sHvLkqYtBxIH7/7NL7/?=
 =?us-ascii?Q?3RVKcFHqxY8JIJwxZeu22tjpH21e2e+cx+Iy6hWgWmmukP7xrkpOjVX/9KLs?=
 =?us-ascii?Q?Oo8nQJ9dktlFHN0zimyTHqbvuWYAZwqggabstvD+21fhKOfQVG85JH4R/+NV?=
 =?us-ascii?Q?3u4m0Pr3XSYuBkYHu9dCvgnSdGyzKiNsT984lCUSUSvgEv4B9miYNt9vFCRt?=
 =?us-ascii?Q?ts50uv+Mn6wK3pQKCmFTDEnPb785jYNKTQTXQKy/4tYH8G2vtmX6nu5YWJrN?=
 =?us-ascii?Q?UwYgW+YCjQlCzpD/ckqcyo1hFJ3bV38ubcF/mxFCwVaJEDqjdd0EPYiFPPRm?=
 =?us-ascii?Q?lNCnFEmBwgcugAN4e6eaCaqlQMRYr/JntLCaytd343kBmsAh9DYajAVmPwMz?=
 =?us-ascii?Q?ynRDj25oV3ToCA6hWeOp1mOc533ld84NYcjmLf4Iq2opcKt79fPSy45d7a4Q?=
 =?us-ascii?Q?kdeeD7/on9Y9/JT9HPSavS4kgPolleH366gzOtLBzNd0XBFsVSCxodHcFvle?=
 =?us-ascii?Q?lsmhaaTeJgNQNDm/lSjHhJl3XjNwe7xovR5MnYdBMtvsWksSqPXBAkG9j+2f?=
 =?us-ascii?Q?hJrg0ujGogmHHipreU7CQvVjqW5u/OfYzWj/UCdwSV1CcquC+Ku6aNpds1Kh?=
 =?us-ascii?Q?COZbG4HrmhEircciGGLFeb2xSRSFZIxLkX7rGOhYhyPs7vnvM6Ub1J5NvEFk?=
 =?us-ascii?Q?C/F8sE3SPPDYOYfLQOMHMLR0e+QP6V2ebEfiR7txGfNqI0o6F5TPG3DaIYLf?=
 =?us-ascii?Q?sgsvLi8BOtMANv2NclRzu/1lp57LhLTHfFgJw2pP7JZ926YPRiLhIPFE5DRG?=
 =?us-ascii?Q?cxUouQ/uJFbE5mA7sML3vXSJfRRFCKllvmml9fDBQanZS8UuLs4raJr7oWb2?=
 =?us-ascii?Q?6ZruHoWCliVXPpKsGtjjCrL3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zJAeQO1URALSpGdHQKJkHaGI9+5dq8a3Zaop9IwYuTuv/4qUXxOFUuEHnp0+?=
 =?us-ascii?Q?C8ezHcJE2GYm3tE+r8UynI3H9gu+1t2KNVedy6amAof7H5EBORzUYl7zec5q?=
 =?us-ascii?Q?zJQ4TjesYBRwj/7VoNXaqgBmVNpTMNmDMju54ektpBAGptiEIauIrnPSGQ1I?=
 =?us-ascii?Q?Rg/xiCRn9dA/xPVRElALUTIb/gkIV8m2OIl7c7YtVT7A0u0Kpl0XT6meiKmt?=
 =?us-ascii?Q?pDxrhoCYh+Vs9BkLTUmjwalXiNldXicI1+HOKQl87SKcDJsee8CC6KksdN6O?=
 =?us-ascii?Q?Q3m0GiRPb85Z40VKczga8sfcCZb5yod/lsoXf1n/nydv0wu/QBuSsxxz+Ouj?=
 =?us-ascii?Q?7UJrspV8XWLPOyut8CEmrNBjp1RKRO2b0xQXvO8gJRucMRB0kXMWPHMGV0Zz?=
 =?us-ascii?Q?3l7SFhJ292km/F8eSF548ix9ZGNhudr+fimgizZ4D1nSQmTJSCZK8wUHEnkI?=
 =?us-ascii?Q?UT+60FJRu7g8/wJa1KWJ7Riu5EZDhKQCfQmhwJjBlYhDDdX6o2NoHtFEi2p0?=
 =?us-ascii?Q?oKItMLPq3Qu3soUi8ehT0FXYelam1/c6r2wgLpyLQY+hvk0jrCAeFRsn0WU3?=
 =?us-ascii?Q?la99LDumTW+Tq68O1Kj7uws3x3PMOBIXYL0jz2/zyF5Geh/4ckRdbzeH751x?=
 =?us-ascii?Q?lFA3qYKmetX69kAe8jxklws5jHD7LRQ+/0JH95v5ynu9mRy5HdYy1NPhsrSj?=
 =?us-ascii?Q?G/cNlYjwxtAjean/1AQQSV2k/z7LHHUL3xQ1lzroGvAg+euJudkLdwCJTz4v?=
 =?us-ascii?Q?tVKxfTcS5KjI2033ou3ph6g1dnvgY/GwfY/E9k55La+Jv25m0+YejixG31hT?=
 =?us-ascii?Q?chTiwh0sGN+WNsjNDu/rlICkZxyGsfRZQO6583AheSf9016Aa5bMxHsBSmnN?=
 =?us-ascii?Q?I5aQv4I6sUBpe5toXXF0gH3JX9/U9ab6NFBsX46214payw4CAFSX4dJSX8rX?=
 =?us-ascii?Q?FwONxZbu5cVrZeuT38zRtlfUYHhzXffZX8I/waw5+o/c+xT6FMUDf4pZVkZh?=
 =?us-ascii?Q?kS1MQhJW3TLitrsfKWvBYVP9krP5gUJsxp0MCG7H2g4ywjILB4S72k5y3W9j?=
 =?us-ascii?Q?XlpSgVWXP3UhDqr7byxZyR5I9+i7fYGMD0Arjy3QWoS7rcbDd3x2MFnBbqKs?=
 =?us-ascii?Q?BBC73Ri/VDm2o0Cdi8R+CJCbfDbj0Othl6cktjb/wXHjSo3x9804gClYkac1?=
 =?us-ascii?Q?U0nIh4VLIUWWIARXzfIMptfTjSKx7RN3E5TT9PW02mVuB/bWDhe1OfKNtZIl?=
 =?us-ascii?Q?PUBYdYgtHzF6tmFqD8KRqpexvb3OLjVBHTRQZjchviugM7JI+TUKPsIM52P1?=
 =?us-ascii?Q?ZfH4hgyehXIdMYRzOjc9T3sUOIFRzvedYfhkcks7BmTe34QKPzlUETqTA2eB?=
 =?us-ascii?Q?oM6H1it3gyexvWMyKehHbigo7tqUnDA4xSGJdrUxFChrSBS6DXGtBNPizUdy?=
 =?us-ascii?Q?9gHUrHWq6mqDoiDjKYiUusUUzj22BAKsIWwX2g02CwstL/iJFF1YtysxpJVV?=
 =?us-ascii?Q?33P9wNuj6u8jjxQIoiH65b7Af+z0DKVqDQZsOjbEGLOw86lLJS4SorVm/ldH?=
 =?us-ascii?Q?xcXnkKt9Q+BI5U8cd1bSD0tFaK/mSNtnbJ2HEzDs3yB8Vmi2Zu30fU2UwuOM?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZLDUFSud+TzJfPLZOVBO0JYa5+Sb8oKJlYs3/3zMv3+1MLske+PvbwI+HxjlTfP6MT1kvL66JfUokk9m2ydGy3+HLdhl2XrBS7HInHk11cUqZfQ0UQ5hUbEfyNPGrvikQ4qLGR8pjevTe0axf/fE7DDSBiAwAMrSMMeX6zghou9dLxkW1xyqlO0fa4bBDQwYVAG/LZ/35lN9cFVrs4HZMgYi0UzNX6uEMvrJrR9M0LhCQN+SGJlURXwEUeXXTVBeCCzVcdp5XF16+k2Zp7gd/pqhld9F1RsMbb+Z4ZcF5wNpgtIUVgfiLL1o+R3OU5YmPWzVsO16XSCb72aK7dywo4Uc/Cff5dq1DbKUu3kstG4WMmggzmEDWaFHArjBKx70HGtfsibMpw29O3MEct9BFLIvicMc2uu3IL8nxFg9A/jIZC7mKJhCanfGxS9x1OeRN3/IUy0M5QlAFcOcd8vzQXJ3LYUhIKuta3ekPxFMlaejF9FYcGkGzH671Z5DQKSj8/wEbcOlJS3mA10K1q+F2uOq54EZMwt6bvrWmoUU25MycGMYZa8OlkEFgVCwnJyzA0ACFE5P8lzau6ArSyAiArRoBIjDdaEE6kIavMqMLlg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dadf9ae-e3fd-440f-b594-08dcfb9e03c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:25:26.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ROcaJr0hKnwKqvwslwv1Dnbu1QuFUS19VmfZgx/Fp8umRbM6lUVmdHF//ScbKyIlqrsgFD1gujh6ymQ8CIpsx6ZFFORYlVtOQce1dqiYYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_23,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=718 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411030001
X-Proofpoint-ORIG-GUID: B0vpL04Z-7NOZFooxL4EXTJwB7uSAykZ
X-Proofpoint-GUID: B0vpL04Z-7NOZFooxL4EXTJwB7uSAykZ


Uwe,

>> Convert all platform drivers below drivers/scsito use .remove(), with
>                                                 ^^
> I missed to restore the space here -------------'' while adapting my
> template to this patch. Can you please fixup during application? Or
> should I resend?

I fixed it up.  Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
