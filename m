Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE5264A89
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513698; cv=fail; b=TWXyN6YgCrX6RzDdmWWIg9NKvB1EelO2avGJJVr5BeGQKbd+JuivTyyTeEsAQJox6w+uSMYAeNZmEdgJ2IxqmO1zZgtTeil/oO6bcDC0g0B/MsTS4MFcChTFf9+M22mxPuivGIN/9aLVJWia8gR10UDCctrF+r3udN7Zv/4vCyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513698; c=relaxed/simple;
	bh=pulBoBEK/28C6pcd+Lzv9DSJ0z3atAs51YO4lgAPjTs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W2mvfCGdnxpJ0RvyIt82X9xGHmRGjDXn9guELz7u/4dgVM9iTXHQrjygfECtYbNZLL4xLtwQFLRo3uNRLPDdG2txRPe1mOlrFevD94/8VpYVtqz+uR6tNEGKY4ZuWGftnT4kaHDMw5u4EPs9Q0lR/WZH3arc20wQoaDJKR57xZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bgQNqenP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G4C0GmO8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bgQNqenP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G4C0GmO8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGtlJV026750;
	Mon, 14 Jul 2025 17:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kPFzJ+XOB87/lILt6K
	r3qsltNqIGNMDGiJGsG9yzzb8=; b=bgQNqenPOCvZri6YbJE0sT2WVehBixG2K0
	iCzeUdG7GsaduSNV30XB+0PvdQNZmTjWSCFgNXgR/dcg/eL+cNIWpi/ASXZbu9Hy
	vO44rh/Tr32VzSdGXH/eRLXdKHWEAWmkHavvSgJONLHyFuF9Cu6y47ExaGXKR7Cp
	8bhc1w0/QbhK3RL+TAxuvgsy9+l0qNJY+F5JqtaDkOP+Hwuppegu5HJ8MG/+/1Cp
	KyaORZGWMCkmS0RYIRB2zl50BLvPZBs8hfDOchASyunASxyOPZBs19tQMlvB3/OA
	f+46SBeBqtqutVXl3ND2qRDGVULIoDxEIZ//D1Bn7scPVN/i71Tw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uhjf549d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:21:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EHFla4030351;
	Mon, 14 Jul 2025 17:21:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58tk3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:21:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZFwzwjoLsiCZhRmZ+H/Nh2ZUAyxNuFPpfGLO2qpDugRdYsAICowlMO7eOmciQSOmkAJCvt+2x3K/3kMGDHPDcPtR2NnxMYW+rNnfINhisL/38qojJ35+Q+DNUSRVh/sHA9eBw4pHyxLk3hfk/j07+1xA0KsR3FsLXrzp2aTEb7Z0JcbwJt9RdZKLeQ9LeQtarQtm36trtCAmk4s5YG5B0jJkeY4Hg2MteH3rGbZy6/ccoopc2US+QpTgzW9Aa/vA58jsPxGW2/E45OQOybmeLAWWjkj0LcmGwJ2E9LxQYAbaPoPFgcHvQLCqYp0r3JlFsQtugIzI1NIBU7U5dav5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPFzJ+XOB87/lILt6Kr3qsltNqIGNMDGiJGsG9yzzb8=;
 b=tvztzB65EewLYsj4mxdUVf9xFDJcX7FmoTmo1HffUu6Y9n7xb00eu/MdOCcMwBkdwHU3RdQkJ1VgueFHb+kJA0htAZ+N99X5k/i0NX2j493kJfXaqzohYF2n6x2N4zRN84EA1R7FjpDADedOlXxOwfWAb97prDI1RUi5szirPOTnr2iEuYgaRE7eh9+DCBtRZPeii+mTrTSW4Fj7WbPiU6IA//EsvA30MhWqDMmZwZKeeZTiajQ686yT4WDCJ+GhuSsEY4cz4zUGNu73G3ckGMT5TEcrdOppgBR16JCi8l9Tf4NRnO4+ykqHJCn4DzJXAQDqhTMZmwOHwJeNhiyVNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPFzJ+XOB87/lILt6Kr3qsltNqIGNMDGiJGsG9yzzb8=;
 b=G4C0GmO8InveIz91qbK696DJS2TsnMcScPK6uOeNB6PZuZZlTWI3ivYyfrvBNZLggDQY9RQckexLzAbEcIYfEJA2bULzUIMWReLH7FNSB2d4hm3is+146JepA+Cd7TLv+LSltCI1C8qhbWVN35WEdI4o+hsaTuLQedNaIFvaCfg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5157.namprd10.prod.outlook.com (2603:10b6:408:121::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 17:21:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:21:25 +0000
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: Change to use per-rport
 devloss_work_q
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250707202225.1203189-1-emilne@redhat.com> (Ewan D. Milne's
	message of "Mon, 7 Jul 2025 16:22:25 -0400")
Organization: Oracle Corporation
Message-ID: <yq1ple28z92.fsf@ca-mkp.ca.oracle.com>
References: <20250707202225.1203189-1-emilne@redhat.com>
Date: Mon, 14 Jul 2025 13:21:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:510:33d::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f00253-b83e-40c4-f0fd-08ddc2fadcbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Axj5nRYcyZ/mwj8Z+pOclkejkmrAczD62C9RGJMg/jEYddzvLL3SslKdsgiF?=
 =?us-ascii?Q?UTbO/DkLP4z2kyqZFblWLjX0QxWLgFyzlXsIyhY7V3nuMauqj9jCGdMO8aLl?=
 =?us-ascii?Q?1iFHzatwcvOGCMgNCAUDTrhG07q12l4oKteY1nM+zVKYnOM59O8fAQlw/wkB?=
 =?us-ascii?Q?2qAx3a/oLUi5uVZPieXWE89nft7qB64/ceNoW+d6xn17dpLOzH1O4/KHFd/1?=
 =?us-ascii?Q?A9NnRmdcOYKTdwUXKSM5U/7jzvoHptNtulHUGk/JSR+FkCmNcebZPeTRcnvC?=
 =?us-ascii?Q?RezbT8LxYnABH9j3ib/23e6A7JFB/GHJyosGbnXRFKL/TW8uJPXupKmH50Jq?=
 =?us-ascii?Q?Z7S2j7r/a5qsu8+XK6nvsgFHz7/ZrzYz1Q8zD0y4O7YAEmFf4yzwpv5WbI4e?=
 =?us-ascii?Q?rG5gZLCy/uVu8u4/HAhrySB/8iu1gOPWp8BWK+mx4jouZwEvlxzZwCpAtTkP?=
 =?us-ascii?Q?anWXu4wHyjNcJSqsOKlogT3WfVcv8qDdO1c/tYNXD8XzqabhXv6AjyZdcnEC?=
 =?us-ascii?Q?wPMlE0sJMhbu7/QzJYrKeKqT3gnFYMLxdyEUdXnb2/ouEMzAHrw6j5ksZwwO?=
 =?us-ascii?Q?w10rEg2Qz6py501c4MyD1FW+fp284DthHemIXHTPUoho8cVjO3zRkI1W7mjq?=
 =?us-ascii?Q?dEU7Otymw5540cF9iMtGmDVOHuBrm3ha3J82BzuC1k/RDXPv8q8eUt8EHQsZ?=
 =?us-ascii?Q?RUxGyfx0pJ+lBx0CnyQcIEEbNpLVOMdsFcKVyfaX1nbelEUY/1kGWWqTHXwv?=
 =?us-ascii?Q?4Un1xUP5flp9Xn/MYNmc9mLFU82U7rMc0KI+ttXuVQAcQW4VeOm+TkjWVla1?=
 =?us-ascii?Q?SCF7JFwPhroo8NGFZ4HsZ3CCKDsj0lew/Z9QmGulLQ55Cy6pId3eLpXaLnXk?=
 =?us-ascii?Q?XHr3NzwVTG6qwjRqGrY8c6NvGDAJGPreulQi4wgj7LV9d5Zx4cqdxwVRas89?=
 =?us-ascii?Q?T5z0BZ8HL++dLNOEZtw0jrUyi4XJP1RzXcE4ujpt9P989PmnP+fnXHLZNENK?=
 =?us-ascii?Q?g67OehodBYkJWpUBI0quopMR3bhMRQQynmTCQuj1B7Ae48Ltp2oqXMRLxpkv?=
 =?us-ascii?Q?P7lmDIHN5+w0yVHOlS8JqZp1BTIp2R22AHAZlm3IBwh9GqXrxI2PzS04pheB?=
 =?us-ascii?Q?GROyS1eUGIuNDi+1l782I/NwV/fDWZ16AXdpZIjpzOSdZhoWduU/0Fyiz/qN?=
 =?us-ascii?Q?CTbFDRrcF2DxL2r9oFi2gSvn2F9xXxUH1nfE510EmMRWa+1oKxv1osx+shgC?=
 =?us-ascii?Q?Lx0W6wkO9pWCmhYby72IcXlKXL7t6vz/oWtdw+ioWCoC+79J9BlX1dVGtT+M?=
 =?us-ascii?Q?+pog6gPPwR4z3+bM3ToVavyXfHLOTEDEDL+FLkscOI/hDtkWjQjDr7O197nA?=
 =?us-ascii?Q?bV9eOZVEHtvqzAvSN4WLhjnVowAFBWZzcXOeRLtWjUj4TMK4TFJZ8Bsxyzvz?=
 =?us-ascii?Q?CW+1dmtKM8E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gb/KAiwM5og09AJ+rYK5CB4EZ8MrGPVI5RFOSA9UpPwRw9MJc/DWBIj9V1oA?=
 =?us-ascii?Q?HAEV9+F0hzagj5vY+VulpYRmruG5XxrWdgbyja/geHE9EUg2ch3UxFvi4XN6?=
 =?us-ascii?Q?N+202GhO0JMNbAJ9dbseW6xv+UdO0nb604OdMAakxqUxSx45LqU/TSR0sCSm?=
 =?us-ascii?Q?b+zIqkozo2/u66vdbdaYGQiOZW5N5LKJIfFquIYKp07HBZb3vIG4U8/iWRMP?=
 =?us-ascii?Q?KBBFMCe8Wxty9yh5hDnLHrc3Pw5sEysbxxbvxCc/NaUR0Uup2b2AftNzW5Ge?=
 =?us-ascii?Q?NHfjmCBqUOrj4n1ih7PPSwRhN8ViNM3MYPi/SOYK/r5kiFECmzqFqbNSxhE/?=
 =?us-ascii?Q?Ku0/D24YuEOc5oiGnuJ6Wlre46bVGe4AswVVxjdTzOnhKKb3PKpJ6V6E5pdj?=
 =?us-ascii?Q?Aj0vUEjaBxkleUK5h1RIsZcI2v+I1HeKgzF7u3dPoHjs+gtlK6YsltvDIVCk?=
 =?us-ascii?Q?T5wVIw7aey6O6DSuKI3dh3brnFvO8Lus3tCGGM8SZr0brk/78jzMOJo2gb0w?=
 =?us-ascii?Q?BvNfjBTPDZ1sP7OdEpl1wisuXoA+rMoDAsA23tqpahN17gw51g9upsyTbPOV?=
 =?us-ascii?Q?e+QFDhSNPdMYBGBGFj8EOqr7ZTGKaMI6v3IOPJHrcNHGXWrI7pGb126/fm3Y?=
 =?us-ascii?Q?VX6ntk+/bHrm8igzcOlQUTYrFA/1Ae6L+35SpoKrX0lL6XSKTn91GxWqnCy/?=
 =?us-ascii?Q?krj9Wv3UxumU02rpyO3on8+YNWm1+jgPzzEnNjjDyGIlkPEEMKwc4UwAY34d?=
 =?us-ascii?Q?tUXNc/byLHnw4MF2lD21qgQKQWXL+zMDNcA4Yci+Iuz94kHeUrf4aSJ5BwjZ?=
 =?us-ascii?Q?LwClcjjuNR8+62uNaEWn/RndIEr7tvWcwmk2kfmeVy2vPoFkw+rk+oHmS7Ms?=
 =?us-ascii?Q?WNIhhDsuU+1kwCwEIRUibIxxBewAmOsrugWq6muTlBhhMNJeFm5084090ouh?=
 =?us-ascii?Q?pMihBDlvHRanZ3nztnI/3/KUBqSwHe0rlPJji6gL57QyHd3gDAEkOsV3yGVg?=
 =?us-ascii?Q?rMjbatmS1RxvCrDggN+72v/I8YwtHVD3cfAsFGMD4a/Tpaae21DOIMjJToEV?=
 =?us-ascii?Q?MMqiPkZCm3QECpsYUsKKTj/RD95HMqEWAMrAH6+xTqpRLqt75mylF//nsYTE?=
 =?us-ascii?Q?6NDckhV7eyt8E+WI4eWLZFH/a8aQ7GfVBHP/O9ioflNl9AeriMoBS5dNdhNy?=
 =?us-ascii?Q?IxwN3ofvaXQnj4lRHQSuIa+VpRCUAp71hiiv9iDIgU4hoWnNuap6t/v3xDp5?=
 =?us-ascii?Q?AYMq5S2ZFMP1dZPlM7JGwMUVSr+8WOlSTWFGcZdiKXVT1PXyOJIUZeiAu7w3?=
 =?us-ascii?Q?yWkMSwHXqabgWkjv/RbYZLZl56c6vgGM6APmJtD6MMAJ0+9uKzdWnBe95K8O?=
 =?us-ascii?Q?UBmcusxJW/r7EBympRev0uB+mFDU2pWeDko4AmVnEkSgQjCs1BvIX4cc2zFu?=
 =?us-ascii?Q?81RiGYcrGupQVbe5lpjw/99gxn+Zxe5VBg/8pELx6yLFUFSKcMpnDlU60h5o?=
 =?us-ascii?Q?YLs3V/MPTPmbbVnkWOUpgR3tfjBo10wX3Lo375i/YlSu5vPY8MTpprXt199L?=
 =?us-ascii?Q?Sf0oDMFmUYCb3AEGb/FrKMzIQO3IORmOzUTXEas77z9xzaxp/V/yPFvMhx2o?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N4soeMkdJzHpCBlBllkT71wfGdPBTBO9/4dHcu22rxvVfArd7eab1TkdBmWuYSHCmXwq/nP8TkCSKpIXhcj7FizWBWk29zFtN9/R/ieLx6/WLZrZ+4pditDUBs82ogR2WQV7/2/CeMT9GfeHq3Q91nhJVYLhmYfclz4mwsOOo3G/nuoJZynYLyp7Aew7tguqzLoqjuuHSVdeq8HrajGFyyUBgSRsTpc4hjBf/mS/5hSp21uLnhQi70GyHjZ0Xn/5/gVF0wsJi1Dsb/2Oo74uAkjg2NtehB1M3L8pH9bb1/G6v75cXu2ylFxGN+X7j/LddBWgDG6utZGOQgUZ93q7F5omyLcuALMKjcJwi0UCDRGOVUX/8Hn/rgf57TktyANfCKjAl/mBE6eeK/bI0up/980iyUEu1PbWwKmsFwyI7VFE5w1jiB+UsLNpf3kYaGBQXP3ZSPPYe0wg8l6980o6TJp1691dc6YXSWO/ZasFa8LK9Ga93IdaYBRBHQPEB0iS2x32QQ0mr1ocu6UIW9NiDYjOM5y+as+P+/9Wn+u6JafF+JklV84Sc4fEOJ3usGEZX5L6g6tn2K1KqE0mYjBeVzGK8QnGkoJyiLiI7rQpQDg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f00253-b83e-40c4-f0fd-08ddc2fadcbe
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:21:25.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WogLwsPf2BFk2qPgXk8Wdxw3YsiEV/YPo3LMl8MPBAFHbh6Pzki5BXhWaPFD/0xS/U8BuK9vfgAnJxouRNdkrv7qQSbejIf6wOwXPwKfjBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=806
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507140108
X-Proofpoint-GUID: 8Q4cTvnLqshieRMhTiTjoY2G5I0f-nMj
X-Authority-Analysis: v=2.4 cv=O6g5vA9W c=1 sm=1 tr=0 ts=68753c9f cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=LUfHgyexyIkP1bAxbx8A:9
X-Proofpoint-ORIG-GUID: 8Q4cTvnLqshieRMhTiTjoY2G5I0f-nMj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwOSBTYWx0ZWRfX3gD1qvIz4TYr u3lJKvzb+2Ac9/8bkkM72jDnFi8FoeeBNeAxx44Sfsf3uOkDNTSJvdD9uJ7HUSDhNeW+teBIp6k 572VdYLnGcRB1oGsZTa8zxh6UI8xzMF193noeIAXXXXaIYrYJx3IZCAA0kmOcFlugsnomsgmwzO
 Dd7HFyB+WpsItdX7xHC8riIvZJI3KCg+T9H0GvXF/Y09W0PhxpmHTNz6OzmeoYJu+Kr0CiCMowR SMlMU7DXdbiT8a82gs9j6B84TtMyYHVEqcxZUu+lGHrSqxphGyXXe84ZVIN9hRiBLwJZqnLgMp3 3OnASn5xFoWukhACQApQNRivPfwarDx3IpUF0b+XtfoG1fdXp0JdTB7HCC5I8BI4HvTUzGNHcCz
 7nYUm4Y94KQ4hg2NdAgHMK72nOLIfDoVFb1ILeejhL+SHb8jWaZvex9tsfq4Iaed9bhEetsa


Ewan,

> Configurations with large numbers of FC rports per host instance are
> taking a very long time to complete all devloss work. Increase
> potential parallelism by using a per-rport devloss_work_q for
> dev_loss_work and fast_io_fail_work.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
