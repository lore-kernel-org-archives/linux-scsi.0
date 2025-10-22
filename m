Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E9223708
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 02:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761100029; cv=fail; b=CSB7K6WGvybGM+4FZgLCmVdytJ7a1AE9vM67Lv2oWmLRR8OYTOc0QFjv6ZT/UxPRYXNR0R/xyiRxO9Z/Zb1eGE6EFNLlgq8rsDgQaTpOuAb0pvOUnCMPpeyWDk/PfOJi7IDPYZbLMA23AwIpvL5AWh1JMmJJtxuft9Yk/VeWjZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761100029; c=relaxed/simple;
	bh=ETmp//lu1Tr2T17iVYWu2OZdAkzTganZCyOJ1RTZCb8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MtJqOxQtcBl8uV7V3q0B5GEPfc4sJHT4RHUEmvnRnXUKejeBhshmNJIOQZQ1G3zpNI8Y939xXlLl4OMNxmsV6itt5lo0Iw9B1j0+M8UlB5lIOylE7ifvlan6A2gCMCtj6AIZ6EFkfU5rTQEejdghZWJ3XY0p4uNdoE/mwaVl4/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G0Xn+nNy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k/PfXs+K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0Xn+nNy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k/PfXs+K"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M2QErW024570;
	Wed, 22 Oct 2025 02:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q5pMZ+q8kFLXDsmzeJ
	i38Hz7HKO8EXskIDnxZxkUAsk=; b=G0Xn+nNy+mKPpjAFVKf66XTY1s0ThYHITa
	DT5SD7L+bKrUKlNq4SMoswrDOa4xvOMpgwBiaI/6GdHk/9StwNIWGW7t9IYHkTSD
	RbpSQJ5PALI8zuQGxLCZ6OtJLZdW7YE3oU44O4/HAtJAS6wGqWY96aBVtmTQlh33
	mBEGxU2ntOY9zLOlfb+1IkaSPMy6zW12MlDvjsl7mdM+J4CdEZwMs7UKdE0fzxsM
	Bczlo4JrF4N1OOABByMrttc5n3tMOtq88z39BD1Cje31Dj4P+NlYAbpl68egqhYp
	gSCfYNbVbO/8wpBuFy8pOqZq3A8uu/OG/pk/IYN+nXv3N7pstiyw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypxr70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:26:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M13oGh032359;
	Wed, 22 Oct 2025 02:26:56 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012061.outbound.protection.outlook.com [40.107.209.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdkn0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:26:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=piQU8YArr0meUsnPTV8pJUby/F7e61F7OfvnC68MqhdXlHB413RkSp2pJTbhDdJl/pDo3h7TkkJoSzYHIv9e7ov1YMRy6ubsK/qmhjjBQp58gLLdhxctBvpwAIwtDPdQcI+tn0ZBBZt4ISH/qB7wfuP2VoV1mjdOCY2SSvJYra6rmxQ0u86gGfYbaYptYd7vyDnRe6u3RSCu0IUa/r41GACIBdnkS8+mSbRiRhtHbjRM3+z/SaWk6DSEky8ds/Xa3vkubJpaceRneHN6rluEGLayK2XylaAx9jbXst/7RWe4LGX+4dIZL77AALEFQFarYd9xA4fgZ9q6rzw0ZM/tjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5pMZ+q8kFLXDsmzeJi38Hz7HKO8EXskIDnxZxkUAsk=;
 b=M1rSE1fotWDoXJG6h4LSLLFObdaE8sunNpOZCXKwEw9DDBcOHRisUoG/uxuBiGWM6rvLOREB/aqV+TihPAQF6ZO77JhEvXi1c40WDlcuuMcqWEUAT+WcS/ZYKyMFtz0ulvOMsD9yUDuOAS5tZjtKNG0/efhNdogLEVNPOFsYjOoimB4R93oPBWQTN+9/7yqES7fKtY8zYhqdp0xfBj4ZHc2Oyx5D5LmW0cvN1T3T7r2uG16kBzjdFlH5fsLdorG+mkovlz5Xw0QMUmuhk73l/UTdf11AiuPTa28SLZHm4dlLy9fCjR2smqCwvaDsBY/9GEQV3/NRdTmEMUXbgKXb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5pMZ+q8kFLXDsmzeJi38Hz7HKO8EXskIDnxZxkUAsk=;
 b=k/PfXs+KKmyLC4ipRoJF1iPTyFqTaZKUuQmt7qpROfzD3I7JrfLtk1IgLdzUVHhEqOj2yNRnUPAW/XcgOJ5lP3AxJJdCK94Ytl0nhLukNx7GdC9iQQ2cKYIhUJHxDzmUTyvqmo08/GiCdWREdnPzvC07BuSMJAWFEP2rPy9ooa4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 22 Oct
 2025 02:26:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:26:53 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sebastian Reichel
 <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens
 Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by scsi_host_busy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251007214800.1678255-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 7 Oct 2025 14:48:00 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
Date: Tue, 21 Oct 2025 22:26:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: dc42ad6c-9007-4a9e-3eca-08de11127679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?saQNLVtGA29SfTxVY1oONtGXrStjaMAfQN2QtWxx5YqiCRHO43mEZI7TfGnA?=
 =?us-ascii?Q?xDqGpFxr8PMkEk5BjK81ovBMkIthL+AtiQtMD0Iz9I8jvqcLWdF7pc+fSIO6?=
 =?us-ascii?Q?m3kI6kXDTkuGpx6O4PDHD3VyvZYNAUMW9mHoG3JVNRIBkMCWSqA1k6k4WTQQ?=
 =?us-ascii?Q?D++feqlowz286NoGXn6jVlDuv7HjQIatP1tKhQ4I9+30iEEJ21mEHGL+4vnU?=
 =?us-ascii?Q?WGYLYWrMzYVxbcjMCF73gOn+8p+TLVhrHe0HYyQbqHWSPQ/U6mAoEQJOt8vK?=
 =?us-ascii?Q?bJb3u6HGHm9fjKO4+uxSUYyjatACzxgFOJpGfjzbd2ewHvVp02pRX0g6l/wT?=
 =?us-ascii?Q?XylcP6Eyn/Q7HMsrNmIx56PTMvnx1hdafROXqcUWeE6QOVYCQagFQSoUP+SE?=
 =?us-ascii?Q?gTiEAcQDvVsbsRN+Nr1Wjbd/ZhY1xF3Ga433IMfS+P9/sDKPMM/pTtRTgHNl?=
 =?us-ascii?Q?QrR7JSqCMzfVlz1U/7t7goDGF3JFiEc0oaIZik0zcjlETXowKxIToHPTNTd9?=
 =?us-ascii?Q?A3enl0eawUSTSYGNlURtulZTffrliHYz79M4kvXa5qmM81gmdB4fBIV4jp+2?=
 =?us-ascii?Q?41ybT838yAioc7eeBvHtco1Ir33hml3arY9PFk9L0QOiYd4rTFX5oZSawzL2?=
 =?us-ascii?Q?nCW0HBR+2xAzU/iTr4FuxOFr2IRGo179C/JBwiCl5Gi/QqmNoyRYupQqwZag?=
 =?us-ascii?Q?qnWtOhIXiLkcK7pGjhRQo2tDio4/fZJKg/SuRRMTCIiC/XLs1/CWI/wknSar?=
 =?us-ascii?Q?JsvL5aVrKLMQ6NYBS61FfnvgVcA2g5M6x8pFckmubKpd5b/MVe5SgdH7/cwG?=
 =?us-ascii?Q?QEnEdVfDcvxxTAwXKhY4vTSpcFqlgieFYNB1Wt/gofjcNhLvb3VP7dluxOkT?=
 =?us-ascii?Q?ynlnZrEiZi1lQGjNqaODnc9G4pz8qcxW44GRP7j3BQe6hkdgfmce1V0cFImn?=
 =?us-ascii?Q?teeJaToWPp58y2VgYPZTQ5MqXr+syTRIGEHOjyHi/h5ZtVkmGXqTA7uuryDl?=
 =?us-ascii?Q?z0oFD2bI98yah9WCsZXklu4O4wx1pz7nvpFJEZi+H4pEZAqT6epACqMHpTVt?=
 =?us-ascii?Q?NgTNTaNhlrE19ndIszXfCkwwpjun+7aeErSr58zEKYcwxd8MmDS2VsIHWnnG?=
 =?us-ascii?Q?4qVmGpXif5JdQmWkeK2etXghBc1ohQmyjujR0hqWKL+UNfPrIX/gF3z6CHie?=
 =?us-ascii?Q?QwL4YDtd6q47vIYD9r2G+JCcEmksPt3mvkyEx9vhtuiLb5idP/gXY3sVl7+q?=
 =?us-ascii?Q?lLs+5l16UlG4eWjggSlQFzte1ZxD0a6ZpnIJnfjvyUNJhp4xd9JuFYSqVlCJ?=
 =?us-ascii?Q?dNfBMmlpXdliLZeJCkmKHuvuCEX5PNsgPdGzsrk6bBhWUo/jNWY5mgZ/bzhW?=
 =?us-ascii?Q?618qtSyOmm2uAQF4FF6Hoyo2x+R2ZpxGUMlWYxbh3qMd65zLTkh0AgReEN/2?=
 =?us-ascii?Q?Rop5GTdiHrZframJzCXBzrzj6sS8SZwJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AT+AIZlb+thq4/sm2fbysTgb8JEqz51Qet3FwMqa3KrZXqUT3QG9wEVU/5iK?=
 =?us-ascii?Q?xPf3iTJjujxkWKU7b1r+4gx/0y8CJyW4z+EJ3ZvJ2Cbw4eR+qRGacJRbOq/f?=
 =?us-ascii?Q?a+8kYQOXKOv3f/T44gEQJUh+efwy4ZF9R4PyGqqRLANyat/O1veuDpL0sqJP?=
 =?us-ascii?Q?4L9JbEpVYlRup4eNJxx9OI/KrBtZnf2Q9JMXBszakGlkMm8nhQgyftfRu5CT?=
 =?us-ascii?Q?f+pzc1iwxYVZ250zOV9lYZnNEX/jgm7qi8JvyS+NOWCn0Y3X0/azFUuOWWcc?=
 =?us-ascii?Q?2oVxgHmiS7gLUgbUddg92jdoASUbvk3cFU1hwsuX6w6RHIO1rx/XAbu0jvKJ?=
 =?us-ascii?Q?DNoZYjFCYtCoFAV4/nJW89u6D/OVfK4tcuvIkjUZHSxglLpzXWzp1q1oLcZ8?=
 =?us-ascii?Q?5IDzqciPkVqcoYscSDwuq7Jz7zeHmPLgrWniBsGlRMHU+YkLW+HRbUiEVljS?=
 =?us-ascii?Q?A0lLasXlh8ghhKNaS9nH/ZvLczmVYylEfemcCk/HdL3G6LE4UjMzefDs6AGE?=
 =?us-ascii?Q?yWq7mrntcFB0X50VfZEl7wxQq/6mam0TuCtSghidQ19LxxHcKRHyft7vsbZX?=
 =?us-ascii?Q?PsLYjdlm1F1vsDeA4dkk8Lqek37SVC36yYMu1gK1blcth9uGdZ+gTdWYjN0s?=
 =?us-ascii?Q?cNrBk2DCnGrKb2Z942ugqtGkbDmfzH4CywXxZQBOzEKaAp77p4wa4A7Gdf3D?=
 =?us-ascii?Q?qEZCkygmn9gKrqr+QxIAAtDMw9H+Z5Yolz5Z51ZUtLO5ONzhgghghWcrznjT?=
 =?us-ascii?Q?r0aGkHzPzpNw+tKonEJO8yvZDS6QTiEOt8kvCtBIWfH7FoQ2/xifn/PvNCQg?=
 =?us-ascii?Q?PjlR8qMWxexoZ0Hr+zTDS/aQRo0VFnY4t30Cl2K5+b8u2cIERjo8yqgG4p5Q?=
 =?us-ascii?Q?16R5OI0o+mgLS7BEAo57odLHt7jnjMW+xG4foqBLzYsIc4hEgcKaK9iJ+7Yu?=
 =?us-ascii?Q?+SfKRXmlA0Tfjtq925L9e6n2ihL7bISWorNhwDLthWfB8S7aPAecMQHP73zV?=
 =?us-ascii?Q?LIH9raCiM/3/YT0VFEn07+jfcSjWmEhoaCReNsMhla5O1QbkdSwxTWU0QTWd?=
 =?us-ascii?Q?6yBuPLPF2UJF8AKHdf2w7JDcHE+nlg7dm/1ru0n6+jVjm1TJ14F2CkwAarQM?=
 =?us-ascii?Q?bG8oMx2NvIgxgklSscahjYvlX22fKwdUdkpb73QnpCNlfwIGAKDsasVg9UF1?=
 =?us-ascii?Q?3m0npNhHAT63rWfNYokJR8Y8u2Fs+S35U/ee8yfrGT5606L/6BhHwL7yYXfT?=
 =?us-ascii?Q?cvdDC1toChcxNAYu56kkdNR9wlAOJnG3Z4b/2PAQ2SVfjPdkwwiIQDkkehAt?=
 =?us-ascii?Q?kIdh7QiDeNr83UBV99/+wGEQmHA6S9hEofFCa4pwlFdt7PD7719XKbu+J8Hg?=
 =?us-ascii?Q?lGwrFEa64nr0YP8XdBZixyU3i1lRvGOPtQcd6DS5hktYZmiRtZKeRHuyzrua?=
 =?us-ascii?Q?K6x9JDHTs+GkXhhpQFi5nWS56kVZpq+kd5w9N+h+2zoRtFFFwtRB/WU2A3a8?=
 =?us-ascii?Q?wHFTmHFX1xfob6antk4pRkTSTTS9c1w7d4VpR616wsJLDru7vJ2Tn8j2+Bhp?=
 =?us-ascii?Q?f6njNMWt7XNjH0sCvHolS+J8uonanRVIBnSIj1atQ6Dbn71A1DqebQkWga6u?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iPo2L8KTPURNC2PgG3Qd88efQKzG0vcf0jIppd5pUtoR/eclDJSYZMVpYoXK5X+TeIaPKMkeVBE4NgZyEJhlTr++dlfJY5D3BkPjKSxJOZbQfIcDiSwujtjn/ScTtIfmfuh9A4xxc02O6r2wFTJQAJ622jjHpOnjp5vw+9cvkGh55rJ9mMTY7hXKHscLcRKfmn047XLCRNQild11v5QbcmDBxUmEe+n3/E255/D2+4twnvlEHiznmTSyp3u8szVkmq0Ghu/bVawHRVB+c0SkU9Vea7OSy+bYZtVJ7xClh/sbIVcHsS9fHII37HdY41+UMztCQTC2yR5YpqtgGkEISq79WGgi4UPuQVGc03KfddaiVyudUX1jUDcnj38jDVnkucOlOF0/vGbpBxCmuhJTQZ2g/KUh0Vygg0j24RU4aaqfWokxgT+cjLaTUgNTpXszrWCjRwxrPKQmFL7ujmlw+7HEl0Wj6w+denKQfy/nZCAsWYvz6PeWiGZY/5wbbEoA98/XHGfti0WC4bzCRUuHf11jZd5DcH67KgN52k/hiQOUBNkTb+er1LK9gEoblXVTh97qnsJeVDNS/9zqZbHeE1e//1rfFb2B+Mkm+xEl/DE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc42ad6c-9007-4a9e-3eca-08de11127679
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:26:53.0350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsTAt1erwQF/63uIggUdFw7tEuRCoVzONhZT6nqyTv7fk3bTNx2Bm0xfX1F6aCvjfvM0anNjKGtclc+wMR0BSGT2pcqgOImuMHH1+FoML9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX/fTOpKoBT+w3
 nYhwyAbUURtB9f1dhJJlA7Ug1icus52QY0WJFGuGjvvAnnn4hPf2+LV4VBS1sBpbWi0zB+38ome
 FaoVNaRbt1EMZaPq9Ttf/UbD2FdR0aIM4DGdOk3jDGS+/JOalQihaYgqz1jS/0Wvm3sVSq8WhFN
 qamgBRvKaZ6S+iqazG/JFyeY3riGic7lrBp2O9VPGQddjAO2ZDfVsatjDxEnI7zfKCmrmKcOpCe
 ttxfoqumH2RWbvxHBpxqQTNe7cpuDo5WHj+N4SFTvLHOd8QZWQIozzLAn4UFGI68V+j8gAPCelP
 gjIqJaCQA+k8sShLOeQC1Nfz87W4ji4fcahssjSUKL4rHw8lHklQHM53OS248/Xn9xo9aYbmcIi
 w5/sb3Ce72UbvVammXlU5E75RrgipiCXJ7EzDlIPA6MtzmU7tXo=
X-Proofpoint-GUID: pzyG1zTz-Z2r3ApmNc1y8JITxlFCv81k
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f840f1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=nZ1w68OGlYT-vxjp63kA:9 cc=ntf
 awl=host:13624
X-Proofpoint-ORIG-GUID: pzyG1zTz-Z2r3ApmNc1y8JITxlFCv81k


Bart,

> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
> iterators") introduced the following regression:

Applied to 6.18/scsi-fixes, thanks!

-- 
Martin K. Petersen
