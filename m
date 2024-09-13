Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168AD7E1;
	Fri, 13 Sep 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726188745; cv=fail; b=gV2we22oAGQxCU9yJgrxG2mLMn8y7+c6BAFF1mUEWG1jQRVWHrt4/DmIVNS8p2gra1YzEl2BojDoI/ljUJ9RepNDUE9ZlBfggAsPAo/vQ6ASVISnhz5Xfrc2VPd0hU77fT5q35Si9iRDBytGBPwcBSv7gG1H4NCASc8Xuqg7low=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726188745; c=relaxed/simple;
	bh=i2mH8bsi364Ahvb2FIdwJMTYHklHJ8voadKnrC+CKqo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ByL2ZALnd7nbkXoEKo0pwIhJL2KpJayEFDoAK8ZeN73PZ7rObwIDhA5rWVBlRe3PXH0nFeIPulV8lKUS9yZjh9PAlPBIWixn8U/TZ/qyoUphjKsdW0+Qnz/d3E6v5ef0HmfkS8B82IkSnYea+Otwv4uA6XqLbLUKwIyXJdi6CBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JTRw/NA5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hqSeVTXv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JTRw/NA5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hqSeVTXv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBZFU023309;
	Fri, 13 Sep 2024 00:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=mdTxaz9eAzMKs7
	gW2nMjPBL68a4nEr4rzRPF5hLJsmU=; b=JTRw/NA5q7CH03MSkWRgPuVe3w2IQp
	g81AZn2qru/MbF0AAeZ0e5z93W6ecof7g632JAJ5YSoeCPfeet6U7RYG92UIKKeg
	AShq1wvQX0l2uwkJQ/pAOfeVJGt3p477a64qEopJz3qGldEwSlQViOF3qEDBglmO
	iJZxkv2Dj3BstlFMHd70xyVERnrVDL1cE5t54ZrUG3b3Njy1k/3bho0A89vY30+K
	Uwz/qOJyo4MKzKrwsBtlPKwnjXfCbFLNT8cn49Modq40iLAzKa0IQwRYlm8CXOA0
	DP0ll9hsAurKF5+MDeYOjLvV63ZmMfKGcmQbzwhW8Jpo+uUZikcAFHaw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d430j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:52:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D0404p000309;
	Fri, 13 Sep 2024 00:52:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dncdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:52:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wP/bWkn8r7uEhHwYQgXPchDDaKFMP5jUibjbsYQgNU9Rzsdhjvj11zFUtKuJ4ayHAVpXsLOuLl0+QbrLtKsx6Uu4NdtPMzrW91vO7pR8kGojEvx7CCl7V3Lex08NwLsS4cNs+L2cTR5eb0SVkk9PVx5+rlOcI5JpYFioABICE0sW7mSyyLW50U/97WPsRCB2W3fh5UL9JOz+6bkYM0o9MwC5hVoYxFJz3MDruxEkZ63HEcn/HaXesnjq7tSyQGxpU4GexM8kCaZl+pzEXInsKCsQe8Kf89wAfIVgbRN6aZngudn0evQtLF3DVaNA3G8zRkR7hPLSCbQcjxo497tIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdTxaz9eAzMKs7gW2nMjPBL68a4nEr4rzRPF5hLJsmU=;
 b=jJQ+8QWC6FfgiPBY/ClCs4qtR1vH1DQzR8zwWpN5oYSwkYPXXUx04QfKDj/V+AD1kKlfDY1C5Eb82yb/aclUnotWfQdLCPHGcRNiPAYNmjPMFFnDdt9MM/bWoWtEISxEN91o4TmzYu1MdYjRxwOIT8vIP6d4yhK8QFB4EM0zGG6IwnUog886F2qL4NOy915T9AIp4BSKKdl5vzonGLonfqVhJPztWO9Kfrl0pORsu/AP5UmJEojQ2REvEPvGnFp5svBec5nLb3fZqk8aIOHMY31In9cXBYmeIbyZIilSKYIr5+Lwnjxi9FKVKkDTPJtHyWD0PBBcrnolracixMDKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdTxaz9eAzMKs7gW2nMjPBL68a4nEr4rzRPF5hLJsmU=;
 b=hqSeVTXvxmVqq85ZPZxQIQ7vaqUaEX7BB7QY4pfudYJN+GJ5/zJX6wS85fFK7qlcyhlE8lsjmJQsXoS0oQTdbEVRMxTOAE8pDUWhIgF52Qb4XKmkwIfnOu+gRcF6xJY7op8iTnguhA/syd45cd/biI7Dyam30PB4U7wjzQDD1jk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Fri, 13 Sep
 2024 00:52:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:52:13 +0000
To: Daniel Wagner <dwagner@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry
 <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: pm8001: do not overwrite PCI queue mapping
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de>
	(Daniel Wagner's message of "Thu, 12 Sep 2024 10:58:28 +0200")
Organization: Oracle Corporation
Message-ID: <yq1cyl8wf2j.fsf@ca-mkp.ca.oracle.com>
References: <20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de>
Date: Thu, 12 Sep 2024 20:52:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:91::37) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 5919172a-4aa8-46f0-5c5c-08dcd38e4e4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?orcseaIoHTIIZA/AMxI1hLR9Cq0N+f/zCgWS2U20jTM1adPFL5ZJr5h671gZ?=
 =?us-ascii?Q?rS5+R5wy4Wr3tuWxAAssUVahsYV4bmFzoNB69e87a4bEj80f9L0uriaPWaz1?=
 =?us-ascii?Q?NuI3Qk2nN+JuSlgwtnijfqjtcAmIN1bWup8dK+WyO/DU4x+rtuDWFrbv+Jmc?=
 =?us-ascii?Q?ZT40AvcshjIoSPSvxl29FWVpnl3f95FhO/YO7OAjRGY/GG/7asuxaSBSUnm0?=
 =?us-ascii?Q?Hj8WzNKN8d7PLB7M17wbkpc0oAvx8FvdV9CyGGvRYyN3ggb6tUDRNBIY+oLP?=
 =?us-ascii?Q?tvyMMn9Vwk/s56NZAk8R8KcDrGzk4H6qNrtkWs69EeZfmvIDoNkfXyFEOVlh?=
 =?us-ascii?Q?nyIyDFPGGSLzjSSuwaJSPFd1H58TmNupjjgodS8ZOOkiE5NZqzy031P5W3Fq?=
 =?us-ascii?Q?3FCpaHVltEF3MM+MYkLbEqYI+iXKBycVhlI/srXeMp5plryOPQfmDBfDH312?=
 =?us-ascii?Q?/NzKrkJXv6aLjqOZqEbJQp8olfRC3+TlDATxr0LyCiO2VuTCWRq/rBguZjJq?=
 =?us-ascii?Q?7XHdMavtF+fgy59d5oRGNHZuQyOfAf/BpUiNYLhR4naEAkTN2zaS1RGJ8jRe?=
 =?us-ascii?Q?pkH7Y19niXWc9/NmPWoAJ9JzbVzAij1ORZ7xaO/AnIIln0qeLprafkTZEtnm?=
 =?us-ascii?Q?BjlB1Fu9jvRg9ixid2kXq9zrWXCSPTj4qxcIPJcjPPQqz5Zl5oTbdIFqsAiL?=
 =?us-ascii?Q?h0jzx/2UYBlkoDqQ0PNffWsKE7EeZWlyDVT9W9ns1tJPjwgdH2b20hzgUmHf?=
 =?us-ascii?Q?I+dwdgRCerQPbjXD4pBM3iDZHf2tkUIBMLAIFWGOgAqxnifgrKgLHWNhnWLf?=
 =?us-ascii?Q?iPbT1PwGAIOKwChRAoYlOc6gBk3jzxbpWz8yNiwQVNfrFAf8p3cdJ0bnewby?=
 =?us-ascii?Q?hhdVFubsC7fvyxxlYQW1eBk5vR3lKMUePOnUlB4FU6r1hJSj9LxXXKNqvMwq?=
 =?us-ascii?Q?SiriArCCKyWChiADec7UNvpoi64HritMBi/dmeXCqEfoqQO1EMHxt+BdK9Tv?=
 =?us-ascii?Q?QzUcudJcznTSXJTEOcMNz7H2xxWV73JzDWta47AX/rjxu1c+brwj08XQVy2X?=
 =?us-ascii?Q?ZJqzLsEOYEQfntJe+/EL8IK4h7vwv5UXRnM242vwj1SvpexZ2i83WjjYCjHS?=
 =?us-ascii?Q?v2WZnmkusZl17Znv0M4HWgWsOIOZ2bK8xEdplTP3jounybePMCX8LkWjrYMw?=
 =?us-ascii?Q?qx8tcoTlwMU2XCvK9hAsrbrCdZXohMmQjM4fzCPz9WPcMgODVbkzFnxHIIeL?=
 =?us-ascii?Q?PI8YdHqX7PUCRbs4HEkKfT4hqVbvQ0YxLPwSngE67fLo2IjXGCHv0gEaj9Yg?=
 =?us-ascii?Q?baMWkjupRheD3+aQXxMEInYD0Me7SRkR51zQbg73IpTvvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vNSY0WMRLtpnQPssMEjNKe5zX5HvZX8RHWKoZgP1a7fF2SQ75Qp67CzhstBU?=
 =?us-ascii?Q?MY+mmb6qk8VIRneqTsT68nh3oY+lZsJDjmy7gD+GAwBxxBAbdlYwainlWopC?=
 =?us-ascii?Q?4Qignlx6mfrl8OnQAB7aaqQ5KtD8Ne0Wc13/2/GRMxc2PhHLxwVVTGg32ald?=
 =?us-ascii?Q?Yk4mdIG+c73kzYW+r94Nedeoh7whfi42EVXchAT7M4sKxts++NoBBbckkkHM?=
 =?us-ascii?Q?kqLyEPs38dp2EST5FDnQKBuQsDBXSBk0lsn9sWbkglxEMIKhacM3guRdAKkJ?=
 =?us-ascii?Q?OPlljSMwxuGBxgmHfBJ11Wvbg7RrBxi1ktXEYrvdfJ80lqlC6nBaM+jd8+2N?=
 =?us-ascii?Q?BUkmfFip4g+0BilzUJ6cFBtSjR8fkcixEy62uxVPGEQacKQa2irBZcjKZqQt?=
 =?us-ascii?Q?BbdH1DkWEqWebyi1QdJUtuMmQuGhESd3Y4N1F6sXD8Vi1pHYlBPHv3YSWBs9?=
 =?us-ascii?Q?y8a8fiJRm854XNpkjp9uiUks8n4W9ukwVzWqOiHD06PQHqr2q1ZqC6hsortP?=
 =?us-ascii?Q?ifQUU3ViU7mL3ypenGXKbX47JEenkKjzWA/RvLyEKXleEJFHumpx/GqpWhsy?=
 =?us-ascii?Q?SfDz18KJOtW5Qypo345Wh70NYqVspSb84b9Z+PbrPl5rsFRICyupC/9ZG7xt?=
 =?us-ascii?Q?8M4hVTSzOm0LikkmlZsWFgXN81Qlp5IwD6xGYtBr5Mkb+cwBlPjhOOmjaHQU?=
 =?us-ascii?Q?84qUy2QgENMMq9P0i/r5yN7VXolTQdDDGF1eerqhVBj/ecF5H3Y/CwILkL1M?=
 =?us-ascii?Q?Z7dHNB/D6cjlJZTmsyhXVo5V45CBsgCESglQ6gYTjTf1E+6cDkPCgm9xY9q2?=
 =?us-ascii?Q?fW/4t2FM3nJwNrr6VZxtm2P3GmS/mwjcfVYf5+mvc+6Dfg5R2GEwZ3cb3B8V?=
 =?us-ascii?Q?tHDPxLcbitqsiRveA/Iemcx4DJv5na9IpdsWUezyPs5YjkPwWiqUMgOYxY4A?=
 =?us-ascii?Q?bW89IxP8ZvgpKwk3UN5rl/NBH6Nv5uOsIBRBOGV5JUsGvPHpNqF0FBvBN+B3?=
 =?us-ascii?Q?gxgtrRv729MSTj0xmlZ0DL7OaDUZgUIthWM2g82RHLkoszJsJ3T1jsc+gvxH?=
 =?us-ascii?Q?5VHFX3JLfMuKvfPzNYZUfJlnUbNPupU3kgYebMmOj2YF65Za9msuazg7LsSO?=
 =?us-ascii?Q?rK0PFv5gxobMnXQWA8dj71mWjUup7jrkquTgRcm15pW9ZdW1oiCL0nlcsOWK?=
 =?us-ascii?Q?DAxncJ/VVtLIbzKHIPyTQo7m50V7DXm9+eMvzL3NGvJZlSBiKqiARzedHf8A?=
 =?us-ascii?Q?e53GaMQJoP2+3iHxqDex+mJpfNHL8mFI8P4fAMWRCU1ixRlvOyD56eh4wMyk?=
 =?us-ascii?Q?Yc1qZ6vG20pCJRWv7TeYbccWEep/TAWMFd5B05PSuYwdDtrn+qButUXzta9E?=
 =?us-ascii?Q?Hauo0ZrI7UDVSxKjKBNdfUDgDlU43QiFyFKklj8QCfm223gpqN45E37wzONE?=
 =?us-ascii?Q?W5BN0aXUgqMu3tkBf18/XFaAYFFC7Fg+WyCCeySWplsC/9yZn64j8ACWilMd?=
 =?us-ascii?Q?dbkan1cSCXERsJUe3+qKZ5lSLCJVe/9/2t6dxpise8q9U9lArAslP4m+B2oY?=
 =?us-ascii?Q?FkaXvApexNwdRzVp4lH0srQ8f9zHdnl+tKaNyCqphz6O4HpBkJjfFfvxh3Q9?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gCVHzIiaAssiZbp/Y6qnBvFDl1jcwLqp6mtdj7NSjCE+4LezlHjO8Xp+mzaH0hMMtvNNUdUZ0bLjidD80mwkfk6Ezl4J/3pjUVv5dU25+8MQ79NTYTdfCTo+CEIWeJpAW7y2mQqbo+NkG1sQxGXN1ETnM9xPA9P2+8ykGk0xybE311ZfMIwQJaOhqRRA/UT2JxcpS8e//EStCwj7Yu8jM6ReniNLOEhnf3xWi5+LufWI4xrnTVsAkzPm9ogs0MocNtI1NZAVEDQLi0mGDl2R6WmwnHe+yTgcEFts2eXd6aC/Iym8t4TNddjfrO+1tJTHfOrGMSJkOebk8QrVkTFqcvrsS1uylmJQU4XL33XSTBdu+sVqgu5pypbJUsFQzhKGvY6FtL2N5xFCsMozsPZOvD3ZybyysJ4cugVvvUeLcT6piEpohFARwPaW4xTnQKaRLuYZhInTq1ZEyvqUXg1oDgNVxhma34bRfUiPw7ZwKF3QOdyWhD7mmvAFfp2V1iA2+ksTks3u5aChUpZxPyZhngc5puQgMulPNQ3bYE6rKJKbm7arJhn1GDEF0HPFI3cL5Am5QbQvBcTeIIj0VL3ovSUIHcApQrqXCE7mSuHpuK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5919172a-4aa8-46f0-5c5c-08dcd38e4e4b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:52:13.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhiwOYX/hZs/4fZmpPePHBEvNIBHXilKf0/ZlUNNhldbxCvq9zoxVrw3Tzx5ps3od+LIpbGlu/oJ8drxuI+Ej4dD4Eh3btozic4FmokW4I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=783 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130004
X-Proofpoint-ORIG-GUID: dRFZSjcRPMHvQySnibk-RSCiOpFS3UQM
X-Proofpoint-GUID: dRFZSjcRPMHvQySnibk-RSCiOpFS3UQM


Daniel,

> blk_mq_pci_map_queues maps all queues but right after this, we
> overwrite these mappings by calling blk_mq_map_queues. Just use one
> helper but not both.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
