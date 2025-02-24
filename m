Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A5221930A
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398159; cv=fail; b=VxMf69ric+M1gBYaTilVGdOB7VhdrT95QT9g225jsJXJfJNcpVA533zU0Ne4ilevx35QUu/bjcp29/rR9YOpnaxMSu2oDgIMPfsAfYTM50aAo6WtbMupBgC6tTiicnwFxgrtenL26syTUiuHIi/6EhQSg0alqJnyBXsTLfMbuH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398159; c=relaxed/simple;
	bh=UYH3d99spEWXopMOK3+4SnZi9QadKoCdzSHAyVVFGRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gRf7HrVPvZybG8Uqi7llaoqhOyjNvYeawuGoRS8U2kKKzZrIHCeNK/dIwo4eS9QYXLGWXBqaDxTHUkP9n8x3ZiN2NfUFK2W52nYOC5PlZmS/BlHVQR2/Z6QTwF/yTpXw/oC7txHtUnpC/laN8pEBLQCyBDSPGp1GGEprnrMzrWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y802DsfT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xdF9tGx9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y802DsfT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xdF9tGx9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMdOL019958;
	Mon, 24 Feb 2025 11:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4asfhcwPnvM3DLJbhhUVAnQbIIKkYzQN1JlimoFU1Ww=; b=
	Y802DsfTbcUErrM+n2i0IucyGh/kwi5KUC9t1pVw2C2zNbC8LTsiVIQsBqo2oZoT
	Bnqa//aMxC4cclltVdh345pRVYa3Ik3O5ou+gRtPK50c+ptfozJogYoW3jdaZjmj
	JjgUfnwLLeTNQn3BHdESetfVu+6K1P3FpqjIYW0AOR3ZxZJ1wuCc7iqFWe8NDaZG
	hg3klAnjdJdBGLZvXZ/eJC0wyvvLPvZwSnWChSLpEJ2qtqZaG6FHrffYhgPTBFR+
	ARezjQWuRbTXFFJnUJfkSE83N5P0MEhv3me4MAQNOtk5LJ/1IyLavFPs9vr22pjx
	vgQjskKC0OzsyK2QVUO/IQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5c2ae63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OB1bjN012641;
	Mon, 24 Feb 2025 11:55:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y518tapp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rn4B0V8prNrD+5T0npbUzpuMsXHhwXTshESwtHsq+U6qk0eUeja/ac7clkzH+VMOYIU9SJ/8sZj9kQsNm7o0ngN6VPZwlJCJIWmsAbTQYtIPDM9iqSeQJ7wk/dRNb9LvH5oK7oiBEl1yeDJKyBVsIUe9KaDRxI+vYEHYjAXNWHNY4bBiNxlPJ10OE0z/WyZg0Y70XYQbIzdbgW52EtNrX4k5SrNq+sRuobXVyiH2EmWTq6eW8lVXPqXsWjSK1j7k7zTtOtCczStFWrTCVYAswQIslWYA5tj4G5nPu8w4M0R4gc+c8qUWBq6nK/lsbDdPQ/ZgVPGwt540wP7SCMRAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4asfhcwPnvM3DLJbhhUVAnQbIIKkYzQN1JlimoFU1Ww=;
 b=CNMfOKQAAfG96+NoPtWot19bMBfkj2+Au7jJ0UyJRuUEb3QkftkcDCHWMKnmIIqHM8KkgE7QioHSu/5htP+B+FKOfTSlpIMJhlW4jN+vpeEmeZ8aBTESLErHY88SGuQpHOCwl2QRucUZk7/R9IIUxZoYPmpxePUlIodM1XylXp5ook0VXaVGD2ph46tV6ZK1eBKKyxnONHCst1BsXqvuvSGvd+jZe5WzW5aPyHcrQeuH7twOeJfqPGmYFkRHFAUwf00a2UVmI0vHxT+h6agvblUGx6OMxTRhBCTM8n1LBlq7JEWGXiRfZKS2uy+0cox1xBslZtLMDT5OYjJiKhhQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4asfhcwPnvM3DLJbhhUVAnQbIIKkYzQN1JlimoFU1Ww=;
 b=xdF9tGx9ibiDxBN0+vSK4rBngNSw3HxWGwPxksIHwm5wwyUmhgkbo8djrDRZsplIPa7/BAyZZd6Dub8OcyVwg8Vx0SKKD1lhIhsp6fXULsEb7UePkynu6hpRk4Pipigaf82ma+i6pqt9HP3EHe0QoO2lSj9ZF70BHbDEEa/H6QY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7218.namprd10.prod.outlook.com (2603:10b6:930:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:55:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 11:55:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 4/4] scsi: scsi_debug: Do not sleep in atomic sections
Date: Mon, 24 Feb 2025 11:55:17 +0000
Message-Id: <20250224115517.495899-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250224115517.495899-1-john.g.garry@oracle.com>
References: <20250224115517.495899-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: d74363b4-5606-4fe1-abd4-08dd54ca23b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1QhM6E1cRaXRfYAYvxs7ZjW5aSrof4uX+uitrNzHy+ga5qzGCN5O75AcGFmA?=
 =?us-ascii?Q?mMMdzUC5LqRPwEfc/mDAoboBq1KEuLqJGazPSkA2aTMq4Jg4PBwXV2Rf20lh?=
 =?us-ascii?Q?2G+W8oFNCEKe/8qdGu69Aq7VoNEh62oNsvBkSV6pGFE0tyN4kdhtYdBEXu5O?=
 =?us-ascii?Q?cblqpWgfZ7yW3dmFTsCCCLfHMhvcAtNeCTOivZWkpm/YctDik7RXPQeQuCDH?=
 =?us-ascii?Q?CuCzmVjBmnFq/tA6i7C9Io9B1gpLzoCfq0/wnhw9e/Ro/TnMTz8gldYUBg19?=
 =?us-ascii?Q?0Z3C8ytWhennVeiBlw8Z65Ct2rM7MZNvRpuUCqKl46Dt88SdIjR2rLwWuAgb?=
 =?us-ascii?Q?Hf1LFRHLZhja/x62nLDkpew+DTVqhN62ii1aO3+rVhC/JES4vL2/5TA9Cytv?=
 =?us-ascii?Q?dv34w418joizaLSXLBGrDB6wn264PJMzLmGGHMWo7XlHJLqTfeBF2IvFNuMj?=
 =?us-ascii?Q?bz8fg+elVcgJvzy6VBoUNw6Xs6VEJImIu8c5FsAi+ROdobAW7EyAO7B170QD?=
 =?us-ascii?Q?wmMfDSzEJL/XpIzNxIvTVvIA53hZtVLnUB7UqX8h9d5ve6IX/Vw5xS15Fj/Q?=
 =?us-ascii?Q?hJJYnQjDOXhiXQGbl3mcfhXniF5DA0iANYWbvFSJlZPNaXsN3yQFFAPPToLT?=
 =?us-ascii?Q?PJOrFWi88UmAi1I488K7e43z660V8XN3v+D/JCrTzlS/gwcmf6nSBTmGVkBh?=
 =?us-ascii?Q?mMnFc5e0JjOAu36msbJRZUASSi0YXn0AliB7k6BxsPyUw/h30mL169WGDp4e?=
 =?us-ascii?Q?61EszKyH5eAs5/H1H1EKsP5deE2bg1pLSF1hsJAXxcTSvBPOODkEsJeEUN/h?=
 =?us-ascii?Q?vDNBR1hxK3qZbSvTpFyzRdqqaNkvU+fiQbjxlOXyXUPHP4XOl3sRaeswHnWG?=
 =?us-ascii?Q?c5Q5qeH0a0qsxmZA8R+vGcIiQAasPTOZbFH4VcWpxns9irKr37zX4CD4B6cj?=
 =?us-ascii?Q?fXs08VgyJgfb3i59co2neWjtSF7c8l+C0EbzL/LfjzlU+Naq6K9FHI0c1Qc8?=
 =?us-ascii?Q?oi1YK/RouPGfJXLinLTb5l00Qw8t8RYd2XkCL2yPVStKnoj3qMUFwjS9C7JA?=
 =?us-ascii?Q?5NZldEtEx1eTWWiW35BqfpxEswb55trTeIxfVGx3GFGnJIFeOC/fRuqi8Tr0?=
 =?us-ascii?Q?L/g/SLbMWc4F3+SzDJ6czuAo0HYZBFZKD8UhAVw0+bthM4fSPpr6kRp7rct2?=
 =?us-ascii?Q?FjqpeHh6GhjhgVLvxraPN6XgVPnYJVtGKpM1gpNe/hb9EsGJzMfgkMaJCem0?=
 =?us-ascii?Q?W8Cd+p3J8cHWncgsTgva37GGsaSJHLesDrEOQDWbJYQ1NjZiGkoJL1Rpe/z7?=
 =?us-ascii?Q?DfZwW911bIfOpN6sC8+wo6/txWGC61ouh6r4Y19b2JFxquCOeQkzFUKQRvCa?=
 =?us-ascii?Q?Nqe9eVMKK2+dBmutTOdwsxk9JIO1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BDvB/rIxkFaVznPm1WwICymWGlGO26y2PR7hooOlVgiOS0vS1Nu5+ECeKG4I?=
 =?us-ascii?Q?vzxwaZ0yNQ2dw+BOJQEJMLlh+RQ7xkFHi42PDxhrZKq4ZUKqRjB7lq6TNtSI?=
 =?us-ascii?Q?JLya+id2m+aSUIgfn923slywt0Op/iMWuYtSh5v1gg+uF+3P5A5LsBnMa8Y6?=
 =?us-ascii?Q?EdYjNSEmJuL1L5XiWD8faPzGUMoJEFJq1hMuwDTTKnJl53B/jE7KgXlCUsJV?=
 =?us-ascii?Q?pQNLfyLqLH6lxcYoL6EbNHwyShbCEApyzU07z2dRtG9ZRFoW2PdLX285l5gf?=
 =?us-ascii?Q?WFiyRPYYTcANsl5dbs8/hcRn48GqnoPtPbIurxkGXDwyg855Dc4o/iK6y3g3?=
 =?us-ascii?Q?9ScQ1xAYv3haurkpqCRWcQUb6bTdQLSSi8RgYFQtdc4pNrf4fTaHDRhkRSJU?=
 =?us-ascii?Q?BL/8bX3Hr1i4uhra/oZNUml6IjyLnbjmJnwmk4ioqIZ/6IsYqzOrxHj0mwYK?=
 =?us-ascii?Q?2p3ew4EUShJus2A7jCTFVlqp08Q99GQbTxcSLxBx0XpHThpu0/iwnSwhlNK9?=
 =?us-ascii?Q?SliK+Mi5of0BEm2ignFFZk2H78vjtt/VZloX4NoK7tsOddw9W6/yr8jJQolU?=
 =?us-ascii?Q?jk7l4Ws67BCXvPVnNQ3FWKIpr9bWjF+8z+MVdcyId2qEaItw0w2MYpAHbssu?=
 =?us-ascii?Q?mVek3+8LEEhz39zDanXXf4UyzS0xUXZEkTwLdY/wR1dx3YMTug/p2OE2Dnrz?=
 =?us-ascii?Q?WikSScEKKGhIc+7NWaWCi69qbSQ7AJw0ep6MEqeZHXhE3Rz6xZvjWp6sl6cw?=
 =?us-ascii?Q?iihoR79Nz2NHSHCtSoalYn1giHwdzMVEiksPxWJ+poRUG7xccHaq3NTLXbd0?=
 =?us-ascii?Q?ddGsk4pzAPTCjzqqTqFeiTrNbNAJRGfbbpVQZIml93/pGgpprqGDgfiG8usc?=
 =?us-ascii?Q?Qth+CxWbSLhH3dpEHuYkuIUynkbT2ZB3wNuL/8UfkeX6yNO0deaPsmUwj+de?=
 =?us-ascii?Q?v5YY8EN5vUSxENyGQBmcv4pEoE7TfdKMTbklSPt6wmAaqJnEi6aG7Rc0FTtI?=
 =?us-ascii?Q?9EomhWW8wXMVnRuNbxWrVSc+CW9Ao7inhiXg0JBqlZ+Ov9ZaBHPzUQa9CZQe?=
 =?us-ascii?Q?Vm9mCwp+mBESvHZsWueMB+KPbNDCrjiQVv55BoC2abH/O4T3WcTQO8/tW0rN?=
 =?us-ascii?Q?NdnJFN9YWbb2Gkna9P2ZI92ZGQffss0efyh1SjKf6GnlT2xCCiUpyqs2lFJl?=
 =?us-ascii?Q?/CNNnOJqTAW68l7qAoKzmL1MMdWiUN6cFOv93xefbFxjbYflHHdhakAIhYV4?=
 =?us-ascii?Q?nUTCizT4c8qhlIeSqY+jRzKEU335Zmnb1/X+n57sSs4o3IDESRWMdLLSUi0H?=
 =?us-ascii?Q?B0zTqFKeYLpQP9jh8aMowEZbigqQq2PtBBwhaGNmDmtpfunOiO73HUtzvPGO?=
 =?us-ascii?Q?06jN4jVz0/iORRlWa5LnthhW5zex2PmbwEfXKy7Lre1B4FcLagPWss2RbuJr?=
 =?us-ascii?Q?eOyEGMPZ+ZZYAQRbl1cpF1/5YWbX7z4xR7sK6oVlGchqTZtiekCvl2SurWHi?=
 =?us-ascii?Q?S2UZMQ5CDXOgl/VFviYLaWhDn8aR+BJEX3iV1QepWYKwNQzFx4+6oiv5ZyZ6?=
 =?us-ascii?Q?3zI/nQOnadGPLlZop0MpMrP3blJSbE5NHjCMgi3qAdzlU6ChSQ2be8CJIAsC?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/uqTiDIz1G+6U/W5UzPx0/blR2iPCrVIhtziM9MRlfoYycoBANFchDxRrmgO4P1W5/lIBsykPZZJ8lR/6cVV+wPW6j8hQqwYGUNWku9xRhPrSBYqiN2d6w/q/21E5TuhFTl5ViwOPyaU5nzuATKhyFentRC+tymRIabdiDp1/uSdNkndrWQDiQ3LAwAGHno/wmefAbwffozlTSHsrXjnPsQUcuIh2PWZacsbQuV9QpG4EDZn8vsc0FwlTRkXpfndl0Jn/G/z9xnPJW8GR4R/v/UkjmaAdxTzwrsOfAqETTqCfGGDhXL2NWku+ZRY/MrImULiY0sYaksEoGJ0SWcqOBorRQp3B+mzzFbPLTtPeR3pc8ZMq4y3RItOqN5l6y7P+ckPInf8ZWtsNAgF4dFI7WvWvaLhAms6Y9HtRjQJ+XSikZNUaSpLX+Wkl1/85saeSLI7inbV176DH/xMRVao0amFv+nyhOhHkTuVJhMJbBhWCrW8wBGNXQgn23YI8IyS3lyWMfBtZse3/hq4/V2KH7jGHlVRI7oLS5Uc+VdPPjzUGgbzRsCer7g8DA9+ORLjAnCC+kGB3PjFgTu4Yy/hp0Z6qr4sZ4tM2rWsoIZeZz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d74363b4-5606-4fe1-abd4-08dd54ca23b2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:55:31.6658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+gwYY6zOOkDYoskLFyos7/J/iEB/djyidzpCfB8dzfHFA+56enr6zPP1maZXbUk3cVzmD1E4Y2XnFp2jfcD/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502240087
X-Proofpoint-ORIG-GUID: Tad1g4q0ub_fYQK7drydgsqQ8sf-ywOi
X-Proofpoint-GUID: Tad1g4q0ub_fYQK7drydgsqQ8sf-ywOi

From: Bart Van Assche <bvanassche@acm.org>

Function stop_qc_helper() is called while the debug_scsi_cmd lock is held,
and from here we may call cancel_work_sync(), which may sleep.

Sleeping in atomic sections is not allowed.

Hence change the cancel_work_sync() call into a cancel_work() call.

However now it is not possible to know if the work callback is running
when we return. This is relevant for eh_abort_handler handling, as the
semantics of that callback are that success means that we do not keep a
reference to the scsi_cmnd - now this is not possible. So return FAIL
when we are unsure if the callback still running.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
jpg: return FAILED from scsi_debug_abort() when possible callback running
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c1a217b5aac2..2208dcba346e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6655,7 +6655,7 @@ static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 	sdp->hostdata = NULL;
 }
 
-/* Returns true if it is safe to complete @cmnd. */
+/* Returns true if cancelled or not running callback. */
 static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 {
 	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
@@ -6668,18 +6668,18 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 		int res = hrtimer_try_to_cancel(&sd_dp->hrt);
 
 		switch (res) {
-		case 0: /* Not active, it must have already run */
 		case -1: /* -1 It's executing the CB */
 			return false;
+		case 0: /* Not active, it must have already run */
 		case 1: /* Was active, we've now cancelled */
 		default:
 			return true;
 		}
 	} else if (defer_t == SDEB_DEFER_WQ) {
 		/* Cancel if pending */
-		if (cancel_work_sync(&sd_dp->ew.work))
+		if (cancel_work(&sd_dp->ew.work))
 			return true;
-		/* Was not pending, so it must have run */
+		/* callback may be running, so return false */
 		return false;
 	} else if (defer_t == SDEB_DEFER_POLL) {
 		return true;
@@ -6759,7 +6759,7 @@ static int sdebug_fail_abort(struct scsi_cmnd *cmnd)
 
 static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 {
-	bool ok = scsi_debug_abort_cmnd(SCpnt);
+	bool aborted = scsi_debug_abort_cmnd(SCpnt);
 	u8 *cmd = SCpnt->cmnd;
 	u8 opcode = cmd[0];
 
@@ -6768,7 +6768,8 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, SCpnt->device,
 			    "%s: command%s found\n", __func__,
-			    ok ? "" : " not");
+			    aborted ? "" : " not");
+
 
 	if (sdebug_fail_abort(SCpnt)) {
 		scmd_printk(KERN_INFO, SCpnt, "fail abort command 0x%x\n",
@@ -6776,6 +6777,9 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 		return FAILED;
 	}
 
+	if (aborted == false)
+		return FAILED;
+
 	return SUCCESS;
 }
 
-- 
2.31.1

