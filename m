Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94713655C7
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783886390; cv=fail; b=qlyrFLo9H40pHqFpJU7Z4MvnmYaM7mMk9eJuf3Y+YQaHkQTlpdKWLdwIs9PUlpGV85AVAiZjiLvAuEaQjQ5x+SNVBA1TZl/52hRYE+BLMXYRW/nnIDZWT0rR+Z9CXnwPOhNccgwy07yZYuuundUgGV6pGeh4vTEi5XvexzNvNP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783886390; c=relaxed/simple;
	bh=+RbJRe9OVV8YVT2bw0Oqn9ZiUhahR3JI/XNcyxhrdTI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=s1vIhAig66zY2VSeMnhtxDICakIA2zZpalGGyU6ARZj7n9YGJPWNBuB/Lhl4coF2eXzsH5C78PjL7WvUE/IL0NTXd67DYNSMzo5Z1Il3bTUe8JTTGizPkPY9gcTeg4RqyHwFEu9mjhflTnPKznRqCw28Ul+GF+JyO933K9UAAww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bt63TlH4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hj0/mLN6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bt63TlH4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hj0/mLN6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CJXB0R3865089;
	Sun, 12 Jul 2026 19:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RzvEb3xQvZ5ouSbjKJ
	E+l6cHE3Z0t4CYenmxj1WRSO8=; b=bt63TlH4amkTPZlsHnYiRjByaZ9vwPySIU
	LAWegd8pwRXa3+qeMhb9aTup/LrE2RXdXTvjtA395l8/lUpJn5lt25eStiAZ2xAc
	thOgsmFubboJa7V6fZ1z/l82VlwquYNieMNxMtMokMUSqz2sMXSigylQ8YTzUv3s
	rz1nXIn16tj9p63ZdXyFEBmsx6zhaay/5VC9ZLER8H8hHbLxOur8iYp+D2oa6kux
	pKrfr6LTEkLe1Y7FLQtejO6kIBj2V6BiekpQpqDiiN+Xqo1m0AHID4VPcVOmFU4M
	gDIZvjrNYn2ZfPSKXGZ9NtvNC1L0DLv8QolpJCAOBN4dXS3f1eEg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbep316vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:59:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CJwU6H005579;
	Sun, 12 Jul 2026 19:59:33 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pmvnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:59:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L3fef5afu2XGJCNcmdaER1W+HfDG3laWwgViLtWCeBeN/LdVQy4LqHWxtaKmrO3GP18MtbMmXUSCUhqTaO9n34Q7q/+uxHNmaJznmwZp2PhPm7aW3bksegWDHCJXCts+CvH46Kx6UWq26RXmVCgdocXo7sKJeI9A/g0hZulIGALLC9L8gBGHFXs5SF4ldcCmgYxEUqdF8K9rFZvbLkICPCHZbAPVmCM58DnZK5nZmeGa/O0QKPlmZRfhb6PXASRcSGOqTVwUpAK+BeOvdiqzyRpw0PGpIv+ggiqA/4Vtl+EE4lMhllI5/MNY2HXGpP0OorrSVYZDCB4q67CTdK1bsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzvEb3xQvZ5ouSbjKJE+l6cHE3Z0t4CYenmxj1WRSO8=;
 b=BYu2Ccqsj/oww/LFc1QCiumaazZdR7GG+Yg4jIeyBZQhi3vaHu1wNL5LKng3o9xE8V0SrbKBjLm7vsND2i5ulkgVmPuVVs+LuSCckcxC+YttAuOFH+fdLHe2RqBOJnLK9Jr5VmlgfDZ4JFeBkSyIWRitphT/KEfmbG+25YdDll4ye3VgMOAUHQIkmc+jL0fj4tXadab6Jfwcdu5kzyoIIi343E088C6iqfm8NrKlkGRGbIOjDkeWDHpJ3AgCtluwhiFU35wC3MCaTZBvCE0M9d4Jtu03nSxDNE1RIWxcsDOiZexr1b4tlYgyatb0MVvAKMvo9Fndi9YpMeaPREekoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzvEb3xQvZ5ouSbjKJE+l6cHE3Z0t4CYenmxj1WRSO8=;
 b=hj0/mLN6dwpoRXyGyF1t3m+4Y/uWxYOy9Iq1hxVpCyEKCbwVY/HxKRd04Ta9/cYzLtrVr2HOPqbIbhiYfrkgUa/Wjplyy06MANzWnpWW/lhAtb3ex25qx2GktdnduBxk+TxqvYAu5xGjiW2bvlmnqQTlrHPOaPEQF4RQLQZTPxo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB6989.namprd10.prod.outlook.com (2603:10b6:a03:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 19:59:30 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 19:59:30 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260604133503.2049288-1-peter.wang@mediatek.com> (peter wang's
	message of "Thu, 4 Jun 2026 21:33:58 +0800")
Message-ID: <yq1zezwc73p.fsf@ca-mkp.ca.oracle.com>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
Date: Sun, 12 Jul 2026 15:59:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: e429a384-ca59-4942-d291-08dee05015b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d6hAEHD4eb14IZ1QI6NgT7ls9kFWqlrHseTyZiM7nfP4pPVKLUY8CD7/3hpehMnk/8qxdhlFurwEN0ZfFOvqTiR7CAABFWB0T9GZPlrgDVOgMJtKpZSjaUlFgZa/KdT0rmzo4j8/rjyb6Pxne0vHIMFVZOELmA2pxvldu0Uw36CwaQODlXfIzNtGZUbgfwnVHR4W8mKAvoK9bi1qQCWQzRhuK6uVI67fjsArx8nOGBSIHF46P9rAEXN9M+/6aiK1zO0UCSzLnpL0KHU1zuOOjonc/lTQYhpuk5jpyCkYNOaIKa2lVn7RkPqxarP+VDPNxtvoHPrUSPCQQRxLBrQ7GnQNOunuyy13/ACLtD50zimgdSzJEZlIKJITAcj+JKgRsqz41NDUC7xTX+yZT0Wrchj+/1PhLXBCPB3EQVizUYdGX4jewl6MQd6pcWzWAxt4ipIBy6X3GxFo1EqJftRB7oFQYUTY4WTgQkDKTTxduAFtRBwxrWf7b9ZUfR4qS17Izu6OfRmIla3QkxVF23itjxG5FHsQNwPWNN6YK4qTr8TYzSKI2Zt28BWGcAeE8dHH/w7cQAiK7/AXxkV5NsfbnS5y6ls+1+crtzuvh3Bj1tslBq0MO+LSLyJCz69jpFbHdnuwEXxhTpys6/54ZNe8eA05X0I8qYdDYAe2KU0A/TI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SrNy8y831+UiWV37Q8mEYgGkq4Vcg9qe5T1d/cLVnb2pCFMNcPY/m0xwKoHb?=
 =?us-ascii?Q?CBO7CIJJkreLakit2NmRHXNgbHRR5GW5c9udkLGoh8sxv5mkHKWk1dBS4T9e?=
 =?us-ascii?Q?a/W5rq0bWVyBwfdYy8c6CsjA9+GXvWWA21Oxwu6p8454m1UsGPacV6+3ld1f?=
 =?us-ascii?Q?r4PVmB9MHvYzdGQ0py75HD/VACII3I5iiF4Ako/S733LH7MuXXf6tutr+7Ye?=
 =?us-ascii?Q?Nlri0eg8W+riw7O/tsNBcAAVAIcufN1jDIxAjgUkKGy87tmR5wqxpLcznOvH?=
 =?us-ascii?Q?Zg4XGCMSDpApf2Z6dlLz6Xu2s8AWMiYS5sHIIunXPna8Ff9hqPikQ7UenHjL?=
 =?us-ascii?Q?pti3zFk+zGJ885eb2LLcARBN4Ler2o0CMOnbWqnJ04TgsfB7EwoGheeExuos?=
 =?us-ascii?Q?Aj/RP519KUKcxfmMUJqt/D/qt3yfKTesCmTu7yL9eBqz8yC6yL233MfKP8EW?=
 =?us-ascii?Q?fEtHlenweSRsANfumC6QNWDJcclWnJ3lv7UY7bQpQvT3hT+w+29ivkUFUkLx?=
 =?us-ascii?Q?I0zbxH+pE/ifBhUTAlZ/zjnDawiqBm6gjf3tO4iQ6hbynlIHY3paSkR07J1x?=
 =?us-ascii?Q?l1+zwlQQFZ6nhmbPHtULKL6+wwSittCguhegnOXy4aEwrdQs4IIfZKnN1v6b?=
 =?us-ascii?Q?5qgKtpixtWUjh8HgwfH76/OEJkxb9sh0c/34CTZ/CzDk8Y96iR/1wlGCkr+L?=
 =?us-ascii?Q?e0X5jUEKchHP+D2Tbi7IU6qmM4qyATG8/g0Mh0VmUchIOKIw6T66HRPBFVqf?=
 =?us-ascii?Q?ThFFvkpBpd0QAXidjNFM5u5hXq2BrYM2OQ4jz9y+YJ3qRLL/RZ76zWGeYNtX?=
 =?us-ascii?Q?yXfCwH0S8PYCZIxjPqO7v9r9+wiFq1bpjFcG2Zk95dqS9o6ammMvJtQG6oxH?=
 =?us-ascii?Q?GXFNiRFwZPozAmI8age3zX9WtY16LjF/xGZuqilziIgvZ9eucIN96juGc5KT?=
 =?us-ascii?Q?VaTmGr+9bQj41jS5Gu8/wabJw/8YReNoQ+YDahS9HHKK1STLmP5JeTZmSAhL?=
 =?us-ascii?Q?M5I0Hka2p5y2ZwLwY3zDsu8Jva9lepMZM3ppgEVO1Awy4dDld4Pilt4LjL6M?=
 =?us-ascii?Q?57JsIXK3Dd/rccIr1SXIhSMrvdUyNGU9y84LrZnotiqmtOcAsC+aXjZsiH0s?=
 =?us-ascii?Q?JlJBt52RDY/jfwphTLLEMFH5P2D4EYYc+Eze3QKgre6CziRZGxoRwkuPYpI6?=
 =?us-ascii?Q?btunkJuAEa+MoATvNXVa760bToajes8UH04z/Ml8SJ/98bMYxEBI50UYFbbC?=
 =?us-ascii?Q?ZpiwoAwP8Kd6wMG51CRDVZ0QlENrofmdCLsxljX0pTMGPNSa2bf3YekAb51n?=
 =?us-ascii?Q?qH9joMqjyVmDqVHkVlE7jlfSSyatWM1scSr/TDDexSINvJ8moeszPkNXy32F?=
 =?us-ascii?Q?fqCh/iI4Obw4nNU14i2zHd7c+nw+UGBHp0WPLvae9v+1UgCJDTEA95rEldcm?=
 =?us-ascii?Q?lDrqQOrjDWR6lTX+3S6EZpE/U0m15Sdy816JuIc978TfO58jDgk8LS3b3ZPs?=
 =?us-ascii?Q?pDJOJix9cUnmiikqbH9OpoiCr8YXJtGD32nbjttgIM4jzexuUyif5qJU/04B?=
 =?us-ascii?Q?A/pvtcj3C0PorR9jajsNL/wLDk980R+ci7Q1ovdXSMzBpGVS7CydXi4uL63q?=
 =?us-ascii?Q?JUTTMsjz8dAaBBUfCh0hs7e3gV5ATMt8Gik8WU55KyGO+WflTxUHtYeHmBKw?=
 =?us-ascii?Q?QjYBIE7VS7DpT+7E0LWUFm+qQmrL9qGDNSnID5CJweLq6paf8jNiHhkROeTW?=
 =?us-ascii?Q?TBedclncrYjPv/CiYfGRnpD4nPg27xk=3D?=
X-Exchange-RoutingPolicyChecked:
	UWgL729CGW9ppaG1hadZnH1K6uV70h2+KNEZFF4w/KmnaWBtDrhGnGlWMXq9uvsu0Sk/5jctqUnCPyyZIc35REwZ8EQUVIzjQHeB2awcnubZh0l8eDzNCjVHtCX5RFUBImwgPJ2Uslrd1/7/GeLn3MKudaWH9R6tPiZbpUR5V6vLyQ7FIoE9avtfgT63pwlV9/n3+MUKpbB3E8AEnUvo684myn/w6oLo5FmATfVRI1w32k4ii9lCj9Q0DFHmWJWvU3IBBuUFfjap4ly45PvraAz9O42Uk5DEMauvcMtqiU+e3WLjU4T3DTDpE9g003KIRaIw709N0eYyv7DiW4U0hA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BXa2vIwkLRfPlQ1+5eepsLKKPGpU8lnTV2kDUg4wMPYInGjrGEDDlMJY6wbKvjzRjAaBxUtF8YsLMHyfm9ukPPeWJkwpSZFCQiVDTV6s3kklOrzRCJXd6BBerZoBhjxqUGEuYENfL/jcMEIeXDJVB1tu8ii1sOPzkghOXs3ZBFK/ygVXXje4Oxd4bfpOILrgYI/D9Y5L/hXDQBf18tbElkegAl0v1abn2TFZWd2j97WVA/5IoRFvEldVOf1IOXw4Y8qfnNOgMwpUs6/JyB4CpdshCKpw/DoPE/7HAMME2SekiZRUTt0+e20c9JhngtyMCqhPDEevUSGpo18SIbhfvnaD4+dO30Z49Kwe0sWoJSL01UNdU0OoKiJiVPt9gkavCoK/+mUJONq7d/n8XimZPzBqzPjxEvGd2plUAFeh06zGl0jHuwvzNNzuM1WujMRkI6IQfgrQKVSV6MWCX7J9OrUFKtHNKIOKzeaZNcD2LVvh4fMvjrShN8uaRq02i6wAZ16vU2kbygqROc1I0G5PCcxkmH+nv24ISFERTkmJ4dcxpKkad1ASDh0oAA+wLnvofH2FMtePuyqKcxEEs2tF+IEglX+Kf3SYZFZlsmrsQGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e429a384-ca59-4942-d291-08dee05015b5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 19:59:30.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRYvkhY8R7Hczpxgrx+2RkbFvpUpo83mdyYxbQVTEihu9G/Y1BoUD2lwp0ZuWZrL0CA3w8Ka2W4wA72/RLrPlRpwLh2MtE6SumZfHgOsNyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=935
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607120215
X-Proofpoint-GUID: z4tSeCasHyF7TWxyRTVxyClCXVGJNt3Z
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIxNSBTYWx0ZWRfXyzmnmdsH0NBW
 LiJ86mQp6kYXSLkomz6jAf4uTYv4PeckU8sBMsmkXJ8kyWsAQP8NfLHGQHQ5uhNCRdolLkjo2U6
 NWHIlTL7Y+DZUaQanMPy8D1TQvd/t6TkdNItB+hyTlHPkxk8lvGA
X-Proofpoint-ORIG-GUID: z4tSeCasHyF7TWxyRTVxyClCXVGJNt3Z
X-Authority-Analysis: v=2.4 cv=dYawG3Xe c=1 sm=1 tr=0 ts=6a53f226 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=8A10pE_Sxmjy0SfMbowA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIxNSBTYWx0ZWRfX49e6qYUW17Ug
 OiQIKOMqTG02e48R7+xnKL3KLKrNTC5NriGFdIhvZxcDCnqKE/cnUlWNFivSssJHxBfd4WDmLRv
 FnhDQFsLtg61dt8ROpO38jo/+Ab265aPK0ms89HDXc29sNF2OaLNdPSE8AkXEDTi/eXkIbSGXXp
 R2N12Ejlm4XO/uA6xeQO9uLG4RALNcsKhUgktbPng4RwiUG1otmWD5cAOPOdZLJUkquqQNIXXzc
 qPh016Mnzh3u7FuGkavTo9DmMbai1S/Eb+RJ5L7RKK0A6DZ9yLcJcJzrCcgjUMO2slX83550Gab
 2eYwWTYLirE64zbWf3nK2zlKxfnT4uM1ZY+C5hGiBxc0LqULJn/hP/fIBh0TSCOC1dXxbz5uWZl
 ktPSbpWrhfmTIjmPXDv/T//1sTJkY9MeZqXVDkMHRMUxm4ry0zDsuqVdJqhfm/pXaa/JMaMExse
 vtufpMwPo9tuh7ltVrPDfbwVlIaTyTVgt6lN0l38=


Peter,

> Hence, it is not necessary to stop I/O during a power mode change, and
> this step can be removed.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
