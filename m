Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F3B22DFB8;
	Thu, 16 Jan 2025 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047053; cv=fail; b=S0JPe7ZHop2vbZuW14U+xcPrdDJMiAiaWofrMlbeHAGDM6o9DhdIXK6cWT3FCKl9k2zKPl0vywSqg4mzoiRUf8mgGG1WzlaHESQrnLoDTSLhlpQwthHxa5jwHmcqhOLfswdDMSICQgEF1bVYQw8l5Gfkrht7iNItNERjxllREbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047053; c=relaxed/simple;
	bh=n+dh/Q84K+PMgvDPF1vr2eJRhtCsmkCl3JkSktYsOq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FpElyCQA9n4RJiWsrC/ZTumbTxHrU7WVy2e5A8EqSlpS6L1UB/XUQVKh2bVpWHmoiA/iHzfRu0ac4JvltIAOth/xhDktTk8IrOCZWvovdP81EE8ef60kh7wldoRIU9nWXX8WoFoQ3sMl9DFj5QEEQDfQWYSxaTVBx6szAZmxIrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mW6sCPOG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tg3VxGYO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mW6sCPOG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tg3VxGYO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0ihO019990;
	Thu, 16 Jan 2025 17:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fqnnbtaZha2DSj4oZSZm500VijTLCk5Q1rzdcZUpUto=; b=
	mW6sCPOGfIzJY5Tz3tRjuWE9R00CJimkxQhMnR5ZHuMa5SUpZmt1MAeydvgNDUK4
	4Yk4HZuujPapSOr/OKhFJ4NbZ2ytY5Gtq5kEg4y84gQ5WyENqT38FZV/aNdFi1vB
	jbP9KK5+oJTa4wyaER2GOvhNn34I4T2RJ48BOeWaPHDn6AsoWFuAlnt1Jc+PPao/
	zC/lnJysuyV7nGuywhBRjiz+ByUYuQvVekiWaeLZGtwgv9qupWUe6bDwHWG5mKqX
	6nVYOmbO9I5Rg7+QlXW/dCUDMcDoEApDqvOiVTb4u4zEDhKr/TFSfdE4NWjtMU7O
	ufetgQ/gEyZr8YRDBCIzuQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443fjatpqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GFVoM8020422;
	Thu, 16 Jan 2025 17:03:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3hdeux-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWN912SFRKSxCk/XWWXxXZvOaSK0j3MBOUsMY/WM55oQu2pwO0IlhlzYyF8roOnpd/gJ9INuk6Yei3iOgWrtoBnSUtC1cXCBpjxf5FyPRhgSVfFRThFNowFjfQY6ftXUpc07VK35YsQ9Lpg/4IuDmOMDjI+txf8YxXZo5WcIcx9mUqWriyvjy8TZiLun9InZ/NPCjuYTPocd6TJ3ZNszWAQYGBccK+aLZ5H/H/keckHmcidZ9jgqyeCooAlfsKTXSDTNw6cICX0CD28ltQUSTyBxnWS4gLVWOqqbezqp+ZiCnG3N6klKGuba6SAnTYvovRGthOopZCDi6nd4JI3Wig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqnnbtaZha2DSj4oZSZm500VijTLCk5Q1rzdcZUpUto=;
 b=co8JU0br5wHCPgSE6Bt4+lx8s/SFbd0sHGA+mQc6Ah630nAwWUjQD4MmYT5s7bxAl38iuuiRn4Whxu7ACgsXDbtWBl7MbcRE4MO3O69mDSRAwulfkFnoCX4U5frfZM4iPgnAnVJPq7UfoA3EH292K1RT6xfRRhrMtgDdZjMVHhiBr5p3mSC0E0Q+T+LttJ45+VI5/fi95f548xlTKv53OsUsGEqSeXEQsw4krz9BwQA2p45W6BYajETDzAxRZRDSjMJB9V6SuwNiSaYPQJ5VKnvBRR+wwsoTbWZ++LXNVb6lHh7MMRU397STmDfvUFnCczXQ0lQpTxLQ3uv39oebTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqnnbtaZha2DSj4oZSZm500VijTLCk5Q1rzdcZUpUto=;
 b=tg3VxGYOE0AdsxX/hMhlL44pNz0HWDiK2s1ij1jOjQmf3Zm4/fnQU2i9aHDi3Cs9Fu8x9hMRuMw5xQVrj/osKAP+eU+5nE3qTzm/ZmBfp68kAd9Rw2x08AiZWtdH2QT9oS6/EtLsXu9HXCOlTZtJuEgNzLl9hRPb5drWhaFG+U0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 3/8] dm-table: atomic writes support
Date: Thu, 16 Jan 2025 17:02:56 +0000
Message-Id: <20250116170301.474130-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a391ca-bff6-49c7-eeef-08dd364fb620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O1AjOWqUKREgA1VmTyATZFHKFlvFGfMphhHznemNlzU41wsjiNCXB6TDKyAd?=
 =?us-ascii?Q?iJzunUTGp8IY86xyjJC2avTpJndrDM7QjjA4IhUBbiT9D26HMcxd54jKgWMG?=
 =?us-ascii?Q?b3sIZ3FkYx4HTVJPlpB26ohfqULHOnLi8DxQIiWisYD8xRlpQvF1x8mqi6mc?=
 =?us-ascii?Q?RN7EyqeWACAFA8tkZZ7Jxtc1Rp/H7mL7HoAwHQ0sYC3bIpzIfuW13CQscSoP?=
 =?us-ascii?Q?5fT3tQ7SunGFTL2dpYpdlMtDjLknfMy8S8Mj4QYxMCgIP18LnWO961/DJKeF?=
 =?us-ascii?Q?M+I+uPmYzUlEPDuMRB1DgAiu+nui/XK8vxugQMRYRoUqSkVy7fJcs7Hp0aX5?=
 =?us-ascii?Q?O3oO18AtJecGnYBmuJ0B9lKfl9feP4UxgxLkdRZMbdbwbaAOjxdK7vY8nwZp?=
 =?us-ascii?Q?1q/I9dPPZMgEbqIvFv8g3ZPsHsChTkstzlfeprgLvRyQ4QVrPoBxNDfqRLO5?=
 =?us-ascii?Q?5TylNmMF9QfK2T3gLSAKZQMvrESKMQIbAPWGWsQeayoZWh8m9t74H/E99plK?=
 =?us-ascii?Q?QeEhv8TKo6gclM4V69GkyYYBwK364nSeQD+51QUiEiF/szw85QaNiKmOj9ev?=
 =?us-ascii?Q?UAVb/7TJxagcbe8R0mz6NC5dHa99uSm37s0Ov2g8W0USe2YopnQgaAXpQKdR?=
 =?us-ascii?Q?Peg9Dlv7LtCN21dIlrzJYyi5GmvShr7eWFE+oAQVpPqeomEae21exkdfN2mw?=
 =?us-ascii?Q?0y+fhUGUkY0hpAy2ZgEc1OsGZDBNB+UMZ0KhzDpPK4M6jGniH20i2+/m1RLN?=
 =?us-ascii?Q?5KaEILyqbc3ovoU4EFNtLoFGTZE6p5gqvOM8JsPMia9jYHG8GfGSQn1cDv6D?=
 =?us-ascii?Q?V7H1y+BFBI8bVQv0ZIJptTUjtG0s/ZkvVUbMz15ZP/sLDIJMsJm23rj0mIUG?=
 =?us-ascii?Q?bTtwbTwG5xiSVATzjUZAb1HvuUOAW/W+asW3CX1pDQYl4BSqG5WfY6T6wT5C?=
 =?us-ascii?Q?zfG9w40eAu+pMgWSO+Ih0BXBmt8A42XvmGNiNVCFOSXIu0CUFqJjKzr0pCxy?=
 =?us-ascii?Q?EUiQ9Uj8AP0FPiRBaBuRYMemawXZj7NxBIjeBknQqQkMjD26oT/y17QzGdgL?=
 =?us-ascii?Q?WwUwZtZPE9fGLOcdQ/8KYzcIyT0VCSQo6k08di1tWpfEu+36seNRYpDZv+Sm?=
 =?us-ascii?Q?+ini8OyTOptSrUZzylNHRr25vmQKGOqbh2VCXLqKghqgVxKwk4qkswqbjksg?=
 =?us-ascii?Q?zIADece2oQO5x2yCpsF6gduXS6bsjtbVILOkKGY13c9tMfAdz3sp8T03m1uY?=
 =?us-ascii?Q?hC4A2hSvMASfhgRXIUl5o+NyhePNiLb/oxweY/d+VCWTyUPHNUtl6X/hNM3v?=
 =?us-ascii?Q?bpPkSdp2meI7oFAMx6sN2JjR+LJQZp8JpSjUJNcbsaxzLzNV2o89YHbqcbQb?=
 =?us-ascii?Q?VPbBWzoIaIX8Jsrcc8kL0wT208ck?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zq5rlrlmVDw9S6dI6K546vDPJqjH3tYomGjA9MD4Nfqhg4zQhzx3JLB62lbh?=
 =?us-ascii?Q?6Abbe6F664runWzeUomPzYdTV+cjNV7LlZfnAtISfsoG+2D26Sr6sxKDohA0?=
 =?us-ascii?Q?bFns+BGcC++aVL9lpyIeBuxSubZ0Ytqf7lzDLhPBbgfaGDi/cH4KohbdLrJ1?=
 =?us-ascii?Q?kiKNiHRuTn/YWP+9IMatHQpuHr5voOnLHlG4wLbEYgR2wbob9TUHIEABhuWE?=
 =?us-ascii?Q?ebcHItDcDNZAHuC4+sWVJyLGRVEE1Vjl8NdyhN6+h97E+ocnsoMj/1uNnvgh?=
 =?us-ascii?Q?BqvJt598At4ChsTO7TCl6ZXD5Dz9My2Sq/z0R2BoIPcg8QV3poW9hWkBMdLh?=
 =?us-ascii?Q?XhclGA9l18FZkuyiqPprLV5MOJVkv8rGNZD/mfzmxUko+G1dpXCNCDrB9dHC?=
 =?us-ascii?Q?D03iQQZaFIxMayge+8AgUnKn1a7+Vtsd3QofAVs2kCiGrm5IVJwA2S1tuuXS?=
 =?us-ascii?Q?kg8yRa7gMB6kTI+zFVwB4Q6Afez8Box2QIriRA7Q8Y1i9WquMDPAHp3I2pYb?=
 =?us-ascii?Q?mVxr0l8Nsk8sIfXx4gnUv/G0/Z8whzxJPjzxoQDfjD0ZmFAyeE4KNm2+OHon?=
 =?us-ascii?Q?IK+wbVit6hBPY81+590MjfUZdKUOMsb1WZ8KlWgFAjxDwqWKo16hiYZlw4PQ?=
 =?us-ascii?Q?ddj61kaDde3Cdmw74ik88MsbJfLaf9+9vfKe5yltBsB/7Q69hgeNLcbKHdna?=
 =?us-ascii?Q?zfzKa/0L6An3UtFB6NeP9nszfmvdIk0mNgwiXCdcJN1MdV93HGIg7UHk7GWD?=
 =?us-ascii?Q?NhWpSScScdrs050ML763kBl0QMIy3nAUicgMKhQuCr2QNxvuA4h1dzs5jJ57?=
 =?us-ascii?Q?s+nuJwHPJpDdvcui4//SFLOLviXNwZ6GTCjOZM4erjMwZs7j/78KKDMPVrpr?=
 =?us-ascii?Q?CoZkyXM+SAVlnyaj8J08gAQydJaLqdQmlpd45ExsjUoAxazh5tIK9QftspQp?=
 =?us-ascii?Q?O3ehw9HKro3SjBnwFmytrt4hW9g9e3MsHQsfP3CyH6ra293qTltqskjcQ0nD?=
 =?us-ascii?Q?m0CjFPEQaHga7a4fBKEOT4nK8jE2q0tNL8oTGmoLIvcDuuBp5gcLU8iUq8pY?=
 =?us-ascii?Q?Ow4pvxO8n8zLj/udGV+nX69y7meuA8LIgGx4hiM2siXVA3XQJw7qOJB2OtAs?=
 =?us-ascii?Q?BdUG8SduIKdXBrercEC8saDCWnZnNeZPEkY1CHhiehjAQ9XahOOf6E0YdvVb?=
 =?us-ascii?Q?qN9HhS1onCP7aL1YPug/KBxgq7d5gDkQ0h7KA5CSawhuR9W65VM4ffBDnTyx?=
 =?us-ascii?Q?Iz67gXvKwKZwH9QI/32jhsS69OpPN/+j6ohybbxoIQuAIIBXwMd/6AJZ3FrA?=
 =?us-ascii?Q?eJekzl0v/ReO2KykCx4bXwp3eXzMQUDzgnJZHksUHZE9EnXko9v84uFQknNB?=
 =?us-ascii?Q?f3BOFL3XZ1UG3P29UEzyXCJAij1v4Hb20sGALqjYwg03gN34sVOazSc59WG/?=
 =?us-ascii?Q?AxQaUJeAkTv3txZT31gEbFWQ/GSu758pVYoQLe4yh7R674l55bBFztr7FUzP?=
 =?us-ascii?Q?PLOgY5B1zpWxkOlD+VSeYT/ckCC4i8uaZ6Att0+3sl/aykAraBND5XzM2Afq?=
 =?us-ascii?Q?No8Ar9YW8Y7V6vJERR4W9i+/u9iKSoK2fwvW+hjJ96PVerlDW6hGylntZ3Uy?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GE5BIUzoym2K6Lxcnq7t3P/ydOfR4l7phXasen5zcZUXXmaE+km7pGMC06Qw7ioJ8OO5jVXnwTP05uLq0qRSZSl62+V2zY5URYtBumdVFIoR/ROHthEy7mHedsFIX3WJUt6rHPKNnPzxcYqPXF2+oaY/bp7cNv+LfPgNj/+XaPhTOokRg30uaJbu51cXNKAsLI00ZVYeR1wJnwpn02+r86Q65oTE8Dj227e3p/P1brEupBmCriicnbFAD7vrVSc4EBV7gzhT6piUEspVeov0MlEZfmPA+K+vkOwsGFKQFbnad2y6OuCG8IV6XQQNt9tpp/c9At1L6hzhUhsnZ3m5/m1TtdF6Cduj2iZXxpZoBXzqdbg7a1VnS7ItNVC7LTY/By92PY3UI/fUfjwtEjpTxz5QLkToApdslZyRyBmx229b2Lwx1o7H95mXH7dISdbcopNpTdleLQVHaBCGK++HK94iyCm5DYmWcbv6pd13Mhg8sJbTWa6PviWMotLdfor+p5kMG2TIeRdZL7UyEG6yixOZ5za6ue6XuSzjFqvJip9Z/bo32ctqc80JSYc8jIS7hu7kEjSac4VE0JaxK2FoojqciPeO/t1FCXVdeJSRi5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a391ca-bff6-49c7-eeef-08dd364fb620
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:34.3806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TwrysPZJEaJp0KvWT7xlVslnnJtrSybk5UiElube1fA/N7BCqI9lHH6ydr9ABbEEAeNIv+iwCWtuojk5Kq1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: msoOeMtvneKKQ3kPPijRrTawD7bPJ66B
X-Proofpoint-ORIG-GUID: msoOeMtvneKKQ3kPPijRrTawD7bPJ66B

Support stacking atomic write limits for DM devices.

All the pre-existing code in blk_stack_atomic_writes_limits() already takes
care of finding the aggregrate limits from the bottom devices.

Feature flag DM_TARGET_ATOMIC_WRITES is introduced so that atomic writes
can be enabled on personalities selectively. This is to ensure that atomic
writes are only enabled when verified to be working properly (for a
specific personality). In addition, it just may not make sense to enable
atomic writes on some personalities (so this flag also helps there).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-table.c         | 29 +++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd8b796ae683..0ef5203387b2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1806,6 +1806,32 @@ static bool dm_table_supports_secure_erase(struct dm_table *t)
 	return true;
 }
 
+static int device_not_atomic_write_capable(struct dm_target *ti,
+			struct dm_dev *dev, sector_t start,
+			sector_t len, void *data)
+{
+	return !bdev_can_atomic_write(dev->bdev);
+}
+
+static bool dm_table_supports_atomic_writes(struct dm_table *t)
+{
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (!dm_target_supports_atomic_writes(ti->type))
+			return false;
+
+		if (!ti->type->iterate_devices)
+			return false;
+
+		if (ti->type->iterate_devices(ti,
+			device_not_atomic_write_capable, NULL)) {
+			return false;
+		}
+	}
+	return true;
+}
+
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
@@ -1854,6 +1880,9 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			return r;
 	}
 
+	if (dm_table_supports_atomic_writes(t))
+		limits->features |= BLK_FEAT_ATOMIC_WRITES;
+
 	r = queue_limits_set(q, limits);
 	if (r)
 		return r;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8321f65897f3..bcc6d7b69470 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -299,6 +299,9 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif
 
+#define DM_TARGET_ATOMIC_WRITES		0x00000400
+#define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.31.1

