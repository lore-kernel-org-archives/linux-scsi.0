Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B1F2F746D
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775179679; cv=fail; b=uSXRTrdYfu5iHfdah5se21EDgCaOGiplj4kE7h54fUiy3BdcvIai51nPO3dnXlmmhpYF4gOM+3m4vdnQevmatrP6XwQUhleZ0750xhdDCYXgOC7e1+nuPgVw4FmTUfzEKCLda0H1R26AJBbC8BOrdyw474RCQJyDDonHPiE6JMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775179679; c=relaxed/simple;
	bh=FNQR/lK094k/qecdA+HVdL1DtG1kxLu5V1HkuW+F1BM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=g401EDBpRFLslbMStoApS3GR6XCMkaWdxqScgxxvnXaGKqiUadINsgdEgDOrV1NFTJFWfv5r/bnFvkygiweTCprfTKpGL4Tzbr+YbxL0jUIooG4+MvQQNy3CommxITO61NqmHzISgmrV8WL6iZFvJOCVBc/tF9DPiDbKX1634wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h06OTcUb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F+1YKXlc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h06OTcUb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F+1YKXlc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6330GC1m1380163;
	Fri, 3 Apr 2026 01:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vzhCRtwk1ptENUretF
	h2IMU1R+wqA6snsau7qElpUXk=; b=h06OTcUb8fHN4YvhRiv1dpes0z3b12yUYN
	b3MUThCDF82uEUPKtJhjcCucHtO3O34/obnIuokiqqTwOxtrE7CZQ9/i5S/6i/e7
	1ca84HE7jELCiDOJerF+33jHrioWUOTwrP/SlQVoWJyLd+Bit9Yq26g+RvqDrTH2
	y1uPNm1eDqSiuskx5AdgcYVvLJxGGic+8gpeaKcik0QmWjQ60BFiD3Ko3XOjnKfN
	lLgsSm4C9/VV3fQvcSk1rHXhp2MCw9QI79v/j5yJkgpK132xsdyd70MVjxLZowlv
	hktqgGSaYsdwRBtSXqYx6rz610L5dWyPWwA70F8OOyC/ELIZboTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d671b1g95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:27:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63315IIi021158;
	Fri, 3 Apr 2026 01:27:49 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65edn414-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3PdJ4GxB+7KU8VWQOI1JZO5++hCogiY1zur2vp7cGLFODhwuD4JyUC4pT9OvYnaq44nVKX++PoB32LglceSR4RhGMnAbyo6dkp9mZqGPFxIVDCMJVvajJIqmNRTJJGTj+WPsEpr3221jVd8604dCdEgYGyMYWZXy0FSok0T2+04vPUky4RMGLjy7UJLehZxbA/9EhevO2+ZQzQvvNtnb7Q3rsy4RZsMe5LJGDWeXzj+4gwl7JwuXvNph3ZVQ0ubpTDO67nN2Cnow0fxfP9yyDkZ6Fjcga0nRYTCYjb2L1WhZL5nAN5IIUSWMXhWS/BQPCU4G+b2QNcsw9sHE/gKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzhCRtwk1ptENUretFh2IMU1R+wqA6snsau7qElpUXk=;
 b=WLNFRx/r0jW/IUCzZgGSa5757CrDmy5bRs44z1pp/Gn3fUxWj09zox3tOlWAcsFykQWlrsSv/Zjskadq8S4f1jZkzO1OY6b9z1fwWwC23v6KjptMf2dhLDd44eEksvB4l3pMJbAGAFMKuGloPVbiP1+KPVWfaWY2x2ml5baOxaq3XdTPCHqwkBJvcZUNDBaCthJDs44K5lu6RhJKIGODZoaXJROObY7elzdD7RcDCt7ihbTfmyQUoK0/y87iR69KbhbiOMzH0e2qAO8yxHYniPseauO2iA0HAD6NIqhlKPZkw4c5kuFylZzUR3/g/xGJ0W8td6zCgSgPpIEdTGkMRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzhCRtwk1ptENUretFh2IMU1R+wqA6snsau7qElpUXk=;
 b=F+1YKXlckJiLLh3Ce6LWh8qNW0Udw7pFsaqfUdq7vY6QMPl48iJdLbALbwoc9FhtRwA7bRK8M7Gy3KhQejdgVzFGlst60go0AG6LLzYz+IX3yAc1qQPlZ7AawzgaL/Durz1ktWceizhhC1F5iuBT3fQfgUCbVJLg6QiLusI4GmA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPFA632C0238.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 3 Apr
 2026 01:27:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:27:45 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Three small UFS driver patches
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401202506.1445324-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 1 Apr 2026 13:24:58 -0700")
Organization: Oracle Corporation
Message-ID: <yq1wlyo3kag.fsf@ca-mkp.ca.oracle.com>
References: <20260401202506.1445324-1-bvanassche@acm.org>
Date: Thu, 02 Apr 2026 21:27:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPFA632C0238:EE_
X-MS-Office365-Filtering-Correlation-Id: f492555d-afd0-490f-8ecd-08de9120356a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R2ta7Ieem+sCcDeq2bulTkDdfHC8+VswuuGFOyN+COHabns5H/OahqxTZ+YisXQHvILfzcFjNrEvzJ3lm0jt5D1suUwQoyC+9PRTIuWO56Ze6FIDokodnZq+q5CtUA56inJNv6pRKlxtDg0P0OKJLmOhgu4doCfxJr6pCyoHpy/m3DnYP6s3qjGZ8+cxtMfwJoA5wlQiTTh0xpsk4x0mItGOdpAxJ+29E2NrQPwCiDQY793nusQHUpoxTy7XeEnrtcaM7otPCiKfUxrhK2iRCslbyVTbVoxwgr5xTynT43AV+SoPnVoGOjvRFtb6cnNgv9lqHYBxXMh2FF1kvVBkb3MWwvfosiNSL5yyQQLxcYPIgUT2qA/1DZm7qyGBM0wkY+NXK1laioFrl26GDclkZooBJHKJ2gP+ca+TdTQg/6xgbeCEqdN19lj1+Hd7UWSVIphl6xKRt2nke7f6jBnUJ9Ev6LxIDTKsPiuWeb11tzBUABtvMaHct+73dtjrYlbsprSVTXk64GxUyqrvOEATZ5VffwWn6nWCK/i2N9Ir6hu0ilQ5FvEHHzMpGFugdhVIaFtFYyjV6ZqzI6SW3Zv7is/vl+Zg90ewp6T3ctvQ5MabDKb4t9f9CCM0veTxTgNaCiHsmEpqhn3Rc286nik8u6CWD7zNWj8z/FNkGGaEfnWjE9E7YGw0BTIPbKJPQ6oP/nNJt/QNTMsiStKOQDhRjK7YWu3IZK4IGzdanbC79Wk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Pmb6be8s5V4Uppr72eXV79arB/cq+jm2ada9yeWvKMdwnzyPBlgqDO8aG2l?=
 =?us-ascii?Q?APjtQe5v3We4WDoVIdwX5OOB6+qW5FYavnQuUBkjW7UmkLxQQiBrO8ZnEfIL?=
 =?us-ascii?Q?KDw28tqlcjRx5pSULwIrT6NmN/mOo1UN8AtzRuIThf0tbxK5WKbExH0OzURY?=
 =?us-ascii?Q?PxjaGOX1ppHU4HpxjsZRylr+dA8zjj+NPTORhTXvUKW8KTML4iCMEPtQZ7O8?=
 =?us-ascii?Q?YxrmBRRLpVZUAMHYqmuxx3/t6fBXV39FqKm3a2a5km9eRU2w7BUwaTRBz8v+?=
 =?us-ascii?Q?OFZCfN/KEK+mSaQY1QZ8XXVH9lfZwVXrYMhHyEGVNjKjxT+8eIXv+DNoOXwq?=
 =?us-ascii?Q?xH5+yHinVn7s7foMe0kI0mk0vcwT+wV9ZwkJPocLbXVFAMjbbDzS2slpPOOP?=
 =?us-ascii?Q?ZUJG3Htp99JxnemiODU9kHkmDwcklylTySoD7fvW9ss8x2EDML73ZT2QMC5U?=
 =?us-ascii?Q?qroTPwhRLAyXRJi6Ga98wxfKvXxcqxGCjZ5npdjsQrznV4gQM8EfWBH86mVV?=
 =?us-ascii?Q?uqilWdmyViQautJH/hv6+wgXVC1rcNAp/fO2bAKGE0kd8Bh04NNF+HwOWxfH?=
 =?us-ascii?Q?CzRlvDPpd0cqFstXgTC51u05SnsxFOrvtJ/Z1hpgmXHPbKHvQfO/gEJAX1iL?=
 =?us-ascii?Q?QJOezD420EYsODu85zflaf6WcJfRKWpanfgpzkw45UdKoROVDTrPPmcpPKCx?=
 =?us-ascii?Q?HQWcCG6Y3ivDa5WappuRscomVjM29aX/XSYFrzlAFfGnfWf8F9kXctvhAvq/?=
 =?us-ascii?Q?W49ubNRTJtOo8AlLdjU8XnV83pCeJ7kOK3zV5vrOIqaaHDDHoMbhgDDfZOtw?=
 =?us-ascii?Q?xyGM4x+areRTk6/k8vdERXyBsWg2Nxtl2FjTquTR6Zu/fzjx15z6OHtdd0Za?=
 =?us-ascii?Q?EkPFdFoOiI6qReUQqHWo4HM/WcG3bzfqD8p7VRWt3v8ZzvrI3hTk8wPUhekc?=
 =?us-ascii?Q?VVbLDKl1Dg3Pygxu3DH+uKUCV4cWK4rLxPKzKbuhfGALcdtij8pjFZgmkysZ?=
 =?us-ascii?Q?D18msqfzRnLc8laZsR4XQbpMARXwLxjGI6KzVynHX4H2ypQAkQrGDSuUOJE6?=
 =?us-ascii?Q?2CiNBfrZgn3sxo+Jv96ajajr9k+ISmeTO/Bkut7NycLC8CSkLli+6ZbjRWP2?=
 =?us-ascii?Q?LNDVonPz7bk+GwNfZobNThrNYNMruDfsfXwL8k8KKB9YXG4AKd3kuZhen4fn?=
 =?us-ascii?Q?TAYpLap/bsXUAt2O0GJnrMvQmO0itNPZbUqvvtatvy0WZ28M5JKkPkhBwiHm?=
 =?us-ascii?Q?/h40Rkr3MZTpq4z1nmY1gZtbZajb3dFGNhdPzpgRbnd+/UwMRNHx5KxNljRL?=
 =?us-ascii?Q?1SImzPdszg5t6sZ2vAYNQP2B9dIdVuiQiT3vwZLp6eSFIVQ9AZZFgfW1K2bl?=
 =?us-ascii?Q?gJFhXMKqRXvM8CMiBXyNhTsiDJMvqg44NmgpKXHiNSslD5y6AUDkDbEGUmLU?=
 =?us-ascii?Q?V8mX25Pv4uDxHKhpdKfnWfxnh0EOxnqi+PreiFAoEf3YVy+4DIByCzbLgDHr?=
 =?us-ascii?Q?z2UGs1Eo7Rr5WQvDo7Sx/18WFEDQpaQJ85xUiyak6sbEx/ZuPDRwA1lAfav3?=
 =?us-ascii?Q?nnaOOjreXH33nJFkIpNgMuvUuvDq/Bi0x/Bniox5fFpEMM68e8WqUD1DcxUs?=
 =?us-ascii?Q?VSOmu5zf3SilI+MghUxaLlESaaw9Sf9BQe8bGfkj/z2tWWNQ2sxCA/fHmPVX?=
 =?us-ascii?Q?oS4VLc4hzzoy8z7P16jpf++F+wED7hlwvYXi754Ap8I5qkSfSJaEoEmXRocv?=
 =?us-ascii?Q?DPzOD3jIejmF4qy39aYv6tfIASX1e8c=3D?=
X-Exchange-RoutingPolicyChecked:
	kq/znHOCNx1eZS6s+zKx2/Y4cG+sChB102/S7KRib8lJF3VMPdnDPceLhLmDD+th5MS7YKfBEf0NQLFZO5DvsF1OFloIAeJP/sGS4S+pAhb+OmMY/zn5gGr9YOnSy2Nlv+EhQyPUmzA0osqgkkEpwoyIoS/JT3VF1RC+Qu1K3c17c5T5rkmrmZK0t0NoP4l0wLg+vJ136Ql9AO3pBB1ZRrPzvbrDjgsl+OsT+eYTmfze3IR12LSa0MxEsBR6kISBQhOxZK5SGk9OK+kbfA9RG4L8WN3KpckywOCuA+luWedW/OtWwsT76Ror3bMan+QQSypR4ARjgD00nfyXlP9rOA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7D//+4uToYp30faB5VAGc+T5zlukAP8CuzRB4HKoq6WPdUWXDyzcMcpSCfMkl548/F4Hd/WA6/Wx4VCzgZk4UKuL3vnI/cxw2VVmfI0JcKSPkQGdwUuLUAgXkg7YJFIj9QixSqAf3RdAffeadZRV3kz0j7NMkviz1xY2FD4+djqMrqodZldoH1h/at6hhC+SLwvvYTCXnX4OyMXpX0Lj99Ye3Js+9aIngQQ+uNiCkV3r6gcau9XvjS+pcR/RP4nPOqVnXia/mdtttQfPs1l0C1r9ByRGjR/5BrxI9Kqante42Clkp3XRVsl0l4ZLlsK26i+TrZbQyXgUEUIrzNrshjKiWEYg7N36nh2iLZs3VM3IQxtEet1FjfqSdOeNieQULXaShW8J69zdYGZJrwT0PjioKvgEeKpWXJOQQlG1WZ5WVr7vF6+P1Xwj72UPyA5+zsBtjg+/pBcySPrX3HvMzgzL5ViEk/W5yP+2gUNFaiMMMD8G2K5N8hswrl9Lae1yjJiA2lZct8D4Y5giCPnRb73UAlxZognpKe5H/S7bhB7lCQ8rd/F1H6rncO4hJSNHgBZyVMYFOvbRvuWcTq4a4WpZjKJX49lIYZVCQ0pkpKQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f492555d-afd0-490f-8ecd-08de9120356a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:27:45.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mn5wxdCqMChf9uO+niPWvQnnXqoX7KAVGND6nJOFDyjGgaNBYWkiaL3aMZPR9SXCkJVateJQFdfb56z25SRH6PQUkskVx6/2gSz+7zfMWZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA632C0238
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=680 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604030010
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxMSBTYWx0ZWRfX1xM1zaSTZiAt
 jgSzQBOrjOrLVJgOUv4Uw//aZPFW8iqnYJOd3sV3sEpYfWvxZk0kk6c4OJ6Zv2VzPf5CyZCDVWk
 Vyp3mCR0dWqR7yNJ36t7/MuSHAkBk5xyVTOMeAGyC/FjbmPGUeTjG5t670+bXj9dSLTxF8ReRkw
 UUWK2x4nIl3qLEv1n4vRroUY3nGW27Yh7GagSAtEADkUIL+1bdzAhopnHfpyUcQ9bXHB9v0BQMR
 SvWWKZd3voW2kSxZdQihCmuwJaC4lPxavA1OYVjjSq8nW88RlYwU40PXQQfNFbJ+XsEd5ahoAlx
 UV/q1hL7gIZSpgswId9o+PzE4P3VVkVv0b8xFcp3p95nd18A65Ji+SpqjaRN7Gr5e0fv1oQz4eq
 givWpX8ZFFgG5+KbniReg00WIMPeQeUSIq54WXVhZdebvkl0O8RhqLrOrpS/REc98x4kTdgWxhP
 HA71w/ZPC/Ti7KdLUNw==
X-Authority-Analysis: v=2.4 cv=PJkCOPqC c=1 sm=1 tr=0 ts=69cf1796 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=stacVbTxQmSescfv5RoA:9
X-Proofpoint-GUID: MVxxgjBR0du_VNl37KnKuNAHGBuWdx7Y
X-Proofpoint-ORIG-GUID: MVxxgjBR0du_VNl37KnKuNAHGBuWdx7Y


Bart,

> Please consider this series of three small patches for the next merge
> window.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
