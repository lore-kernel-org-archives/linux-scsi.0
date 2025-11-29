Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA21DF59;
	Sat, 29 Nov 2025 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764448992; cv=fail; b=P7QL/QOCgz4zRwOfQSiCp4wQR6FRILyQ/SSAUOst1xYnHJtD8b2xaQ8lNH/AEMTKuwFzE90MNoNSk68A3AsvbPHC9viGLitFpxAky+WAUJWPIt+GOBSnlxfntIi+nXfbgZrIzx5QGw0Hh+V9TQXmlPzjonswBT80dFFBY9P2ams=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764448992; c=relaxed/simple;
	bh=kBOdfcuMVjYvdV95w2vPKsriK7yHcrmazPbEb6yg4Xc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ngLeehdicAoyRbcSqK60U/9OvnWu1KKIGo7i1Vt7/fjZ7deRh1K2jPXdQTurPVBQNT30hCTaluMnh7RdOrAjbiebjNocXILMBnvGFiUmdQDq25/TesdpL+7RTcI/xx2RGHIkQ1tA8ByT2h9MubGXMqWC/M+X5SOgyioOkkuOtKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OmTZ/S5B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lUC0/WKO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OmTZ/S5B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lUC0/WKO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATDM9T91648428;
	Sat, 29 Nov 2025 20:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SiEKw2OhJVxrVjqOyZ
	bC1RTLyBGjJETd5OtDWnzD9rk=; b=OmTZ/S5BFIDPhz0l35HPZzaCdyHd5H0TJA
	hMUFl1iEqU40SUk0Sdl8Q6MQ26grR5HS/B72jsb5mlt5tWWNRHEs/WE3AW/f/ch+
	DIybPLjkEgPQYx4W0OuLq06f4fPf42vm+OrzZ9iSHnk7V6osG24R/jvjlFPg5a68
	7psyhBPeLd92felAVKWvIdfHyIjU2C2v4YAuvxXpqHSomlkeq9/KB4Z+HttinX+n
	cam9JUrCzAYmO2iIsKxetyEeQKxYqeclNu7u9aFBfuly7p11FKQizxUzf+YIcFuN
	NNKKxcdSvlVTdiqaSounkwgIp1DMl1etgtGkvRdoKwMUZTBiJ8EA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqresrjjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:43:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATKA29l028905;
	Sat, 29 Nov 2025 20:43:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96qspm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:43:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wrxgh+CNP4Ml9hPujv2J2SHJpVz1iFm3T16ZS4cwjnnoAOMUZ399shTsq+HtSTmpnzvZ5u2FgcsI3SB8cELpzAlyXgLKR4GikZHNZGqpPQK2IiAQNv1G863h5mhqiv/Prc6GVB6l5fiq0E9xvHNq5eEhpE1p2n/ZdZorm3EbzAB9B5zdFq0yq3hfQD0f4CxGrywkSBe8S+3SLgD6AnxOdI4Zi14BG3WHwzAvaHj1gaCaJJCsA7WnJgWXbnuXHdpaRUNwg3VqIH+h+1OrWE3GBBmS8oyiujkvnrNjjADnNg80PtumWetU74eR+aHqnZafXBD9DiiS5OnI497Ztm40+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiEKw2OhJVxrVjqOyZbC1RTLyBGjJETd5OtDWnzD9rk=;
 b=ZIJ5tgCknslQn8TrQWINb3xP8/dbpk4o2eSvN7O6LqPXFdPQttbWklRpEn3EkY0v6y0o7WdOPooJD00r+iCT7FojlN9LRxkPA5UvFrbs3Sns0Uwcltr1xPLigqHp4z/UE+CPrSgM0F1/LGUGjcrgwRDwUteeTptjXeLWbDc59zCfOJU3RDvZc6hjEWM4ij0AYDJsSnb9TEAo7Cc2vGHrVnhSSfEqXE1MOT1xdtN3hGIN/8UPxE31m84l3ne078Fi0y0SoyhHaoQOOEGL6QJ7jjEcna8Avli7DHxMVxyw36RED1isBEgxFioSrDZiQGRCtcxmgfAh3qte49qF5GOrMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiEKw2OhJVxrVjqOyZbC1RTLyBGjJETd5OtDWnzD9rk=;
 b=lUC0/WKOQ657SfR7lkRrj9QMqPi9+iWr3BmkW8NtJJPcmLn9qQjtWN4tzSA7fh48yIEqs0NEcIRDvXvU/zMWzQ3ClFU+4gvD16MX89KCb3RHuZ3Ym4E48Ps7KQJT6NiNX4iRf8aNImoIlf697Jvgpf9wE3n09gY+DOsTuDI+b1Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8132.namprd10.prod.outlook.com (2603:10b6:408:291::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 20:43:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:43:04 +0000
To: Duoming Zhou <duoming@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] scsi: imm: fix use-after-free bugs caused by unfinished
 delayed work
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251028100149.40721-1-duoming@zju.edu.cn> (Duoming Zhou's
	message of "Tue, 28 Oct 2025 18:01:49 +0800")
Organization: Oracle Corporation
Message-ID: <yq1fr9wy3ht.fsf@ca-mkp.ca.oracle.com>
References: <20251028100149.40721-1-duoming@zju.edu.cn>
Date: Sat, 29 Nov 2025 15:43:02 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0045.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5bbe03-b4fd-4b02-1f15-08de2f87e528
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?av/417wqKQ/LWjKSmbeAKdTRvGh33h3eF/RhiQu9E0vpmgnI5v+oQ5yEmwic?=
 =?us-ascii?Q?haq8wYiQIMb/uHs/ih2As6nS/Xxjz9pj7dmSoR8e0RE32VsvZJaC+hAwfV4p?=
 =?us-ascii?Q?nJlclF4Fl/pYQlj7V1fXm0wjt9FnXybkiHFfr3/LVXkfHNCWzU/UdXx7eDQK?=
 =?us-ascii?Q?JcS3Hz2+768Rc3hqcov8vnhll1DQ5jkHjtoscjDlf5J1Adpwz0PQtjjI2b57?=
 =?us-ascii?Q?ALtltW7Fm62L2HXkKY6RiOwwfRdlUFG1WLC2bVnooMc7N08Diw63PAkZR2kY?=
 =?us-ascii?Q?u5wGdXGj4yq2oG+a8H3D3QHohpRJ842P3c+90BmyT2GOmrefCaQ/GjIQOv4i?=
 =?us-ascii?Q?5qBVzlCz2VXQlu14D2fuQZfSHCllGrjjnUBorlSILeEwUaqrcSDq1VSC+B5Y?=
 =?us-ascii?Q?Y0Frs0524nhEjixYt5365plMtrnwPy9yiGrx5TXUy6Bwo1voP8IiplPcNntk?=
 =?us-ascii?Q?e0+pwHsISdPlAlYI/8AN7etuLGN1kyTtq86i5hGjeV1DdcmI9pe/6PFXDb40?=
 =?us-ascii?Q?yscKvq2R2WQIJ5KykkGWvhvj56LTvw41RlfneqzpNNL6unyY9KXAhGg4Rhnf?=
 =?us-ascii?Q?nsXChKw6OEbmnkpIZlzaqXKb8aB/F6qY/vVf55LFOv/TJPhLkOcxgicw/XH/?=
 =?us-ascii?Q?ztJYXUAqFc3baomq2YNdjQs2hQJHr5ejod5BiUFYq6gi/+XK4oT3bEZo9qn5?=
 =?us-ascii?Q?xb+kqY3g+UQet045DGS7ftXqhwBDfoXgKBz3PpTIon2tCmFfNyx5VxvV3aeQ?=
 =?us-ascii?Q?KSjMOiQzBqZ2GK7YpRsYXhwnQ+j4PaMUB7jbFbUfoxZB3Tiw1mvKEmq+Ews+?=
 =?us-ascii?Q?f1450LJoamTARUfgOYK8mhiYiJk/UbEHtJlq0hWvFm3llJTajzK4wb2xdA9A?=
 =?us-ascii?Q?NnSiRS036UAvZaSiKc+raiYQBZL7boqagtTrD6kIut2aZIKUBooOeHPp2s63?=
 =?us-ascii?Q?l6lVzWfBG2Avv9tLOVbRsboLunwZU2AqmLjO8X202zNk9wGeLlnL8gFEOiV7?=
 =?us-ascii?Q?z0xJ5/eEKi8TjkBecI9EB6LRcNUDSBNJ/NEev6UxKO4poSA7VDfcdLuPrQnI?=
 =?us-ascii?Q?JV1Zqgf+H/ovu+jsrDyv1eB5472Rfk5pDb7DxeylsFYJr7ZRF88I3k2sKRnt?=
 =?us-ascii?Q?ZFa+1CkeG2+MeQ84Wv0nbN+RAhuodL/XMl+V9E3pQTz9QX3QevUgl9/5U3rm?=
 =?us-ascii?Q?xgXM1ETNaKJEQEPpy1iwnsDCYQa+xYD6w/JnyHMJPSAUuyWsFa69jO0k2sNi?=
 =?us-ascii?Q?d9wbR1jeAHsepHOMrkZDs8LrzUOKY+CAU+D6HCyaNuEDPL4Pt+UP8z9s1zkD?=
 =?us-ascii?Q?Ab+wleFeYPO0Zx557nZn4NXUe+v5wqehUJ1mv8pi/9vtn1LGMDpCF8om5uEm?=
 =?us-ascii?Q?B1tfWWqzbhUMJhdZO+KRd86LO6Hgl8c0TsgKcHEDGvOGNMtqMcptlfuio7HF?=
 =?us-ascii?Q?uRb38wJvq1NzGWGsuLcIo+xRVES/2S5J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qi5QdjX1UpEEo5F+seuRqYv1MqITw5u9IQzF/flWSh21KaH3AV3STStn4QL6?=
 =?us-ascii?Q?4DEXvSHSvieyqOBW3svm/SNR7FAKuYyldiCBSaTclsIZVa2eL/4PckqWkUQt?=
 =?us-ascii?Q?pPk9//3tItd4e44b6/n4bSKSY34Moip+7GgVZLj8E42Feb8cjnagyOMEuy+U?=
 =?us-ascii?Q?upz4vBvFwL64HueahofzhhnsTsB0HcbroVuTj3sSv2qhpyLcMGYA7BuEDm/0?=
 =?us-ascii?Q?17pSCuPmiXIGvwbGFZFJrImRGViUWVZ8WY3ZkhG1mfAFBxI3afnE1HH014LL?=
 =?us-ascii?Q?HXR6b1jYyT1cWwTQf4q5mq0B4pVRQR96GwOmHnJGv1AOfslqxWpzB8pNBJqp?=
 =?us-ascii?Q?73GNrjjoTeGu7VXTPNrGVv/RtKwJckPGHLBFSD+eQhwRkezVZh5W0O7sPiqY?=
 =?us-ascii?Q?1bRC1r2t5H1zjXqOUwAgA/7m+1EHjnRbccKg+PpjLGaEWAZgQsI+xuZBErhr?=
 =?us-ascii?Q?rz0F8NhIzH0vYEWYBe3/ecfB/PHU/IdZKtqqhEuri69n4PQpJzQvhRX3cJOi?=
 =?us-ascii?Q?E+Y76a4FelzvdZlEg/E9LT+57LzM7coORiaTNbFoSZsZbbnIK8+Zc/P5uv+k?=
 =?us-ascii?Q?9XC9Puksma/yWAwRn42uvPChNRndskFf5nYW8LnX3PmsiCOIImT3AZgeycAb?=
 =?us-ascii?Q?PJMXl9QF93nP365GXbIm2tbTPfoEK/f5jhVupuy1yjZN2UR0VfOhdSmgvigO?=
 =?us-ascii?Q?iL/E7U7b7jvXH5+thYSt9mrs+KpWGjwqv59Lid/kkUaKPDnHe+5VNug9KISu?=
 =?us-ascii?Q?6InNWz/1hpjjlxqW0peHFCzlvxgzwjdWXfNcJgoMi9IggGlZo7UUuguFehwk?=
 =?us-ascii?Q?gKP39oD78GSrdGNQJPOhlbdegzS4uFoShKCXQST7CDzU2BNZiqZmTOqqnKS8?=
 =?us-ascii?Q?5qhTbcLaNu6aqsEGBMyJ9tgYAqRvcLYEy6Tbb37WHdaKFJoah75nehxe5GF3?=
 =?us-ascii?Q?qk0d26UU9vR3zPeMCTx3YpzRmY7YaJEyTeJVArzkLl41Z58wEXfy9mCv3A8f?=
 =?us-ascii?Q?3ajxh0ptP0+mlO50apBN7pR0mDXie25Ir4hxazfUNwb7MdDSeZYfO/qFBXjH?=
 =?us-ascii?Q?lL47rapUNxdsVv9wIQ1x15SG9dVx+IGFcCt96jMXx/Z603QpKtH+DnMSktlw?=
 =?us-ascii?Q?yj+35e1s8slP6SUAm8cUy9cf1Xa0bI0DMPP7GIRVdjRLC47M77QRRN6Xt+K0?=
 =?us-ascii?Q?lfMaH0kr6sX7l6EozpqPRtQDPWl4I6Iw37DkFykn6Tmybw2rGdWQXUM4/K/c?=
 =?us-ascii?Q?ElcLo/tm3WjlZHBHwccFHGV3fSq4I1pzMp9oYsLoRAUsh8xXbQBBP6NWTwU9?=
 =?us-ascii?Q?3ttZzfp+RhfcFM7/RIBOtt3Yc5pAWglPlsg5Ug5dttlKu397Ds2kXMJZ+LI0?=
 =?us-ascii?Q?Z7DUzokgCx3dJ4u1WF828F3Xe44UUkO4fn2NQK7M4hYbFGOMG818mLZbdMqa?=
 =?us-ascii?Q?L8WKmdH+KoOAh3UY4JXR+cTBwETEdzFsyWx8BD+mxGBdhZL1lpHrTkg1h7eW?=
 =?us-ascii?Q?nNaYemVC5sIJbBR+fxy9Ed35BNlNZH36hT2ErIsk5SLEv+MBB4RbUN5B8iM9?=
 =?us-ascii?Q?J5hBefpYU601MxGd8kH3OmJjcRru4vF6nOfHS7cjaBcwulGd5Gvu+l4K4WjV?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pNV+TD6v5bEeoEfCMheQPYajSvtn5RIMH8wC2x7iyteWn9noqSRTrq6MFwLMpmfBNzUHPeesKRVjsahRdeng1Bhnxcab1b3HlTExD6cNhfsYH/TAgg83pBZFdGpi8Z/yoqTxKGIYejdNkz0WdpXegbjgzh7RJczEJRajRgG4+RgqsXpP6vfjUDkan/RPNKM6iU49N3vCtnT8+bLPOwoLF8MHfteiK9LHbf/YuvKJe7uwFSAZIw+Y4HNyrBV+oZt249Dm47Y8YejaR4fS0gU4+zN7YlCvZJVZSEKKyRFx4N6MkaBnqW8knQeRRIn2jxRRub5P8z00JiYgrf0LhfXLQu8Fp/3uHswuiFJ3lcqFhsYFXOb1CxgR4NY4unLSjHJPJf66Rc0JtteTyIg0Sqred2jwj/G8iPq2+FKqapCWx3odn7zCI376MLwhn5uXL2PGpkqias1pnoJTro/AicKi7Q+cJLJt8FMf0ERftQjEQetBG1jOzv1h5+Y2QUZHgPcokpDN4L/Ef/AIELjiLCtCuqSbpva/+hNSovG1J4TY7wEfkiT7h1u8Qgor+F1fE20hnwl0/ZXTt8Tb+JfOUj5hjuPRHdtNkjjkUzpFlbD4oj4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5bbe03-b4fd-4b02-1f15-08de2f87e528
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:43:04.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RER8LICwQDIbk8Ch3JyEM84/gknZdHBU8pKsscDGzB4VuLi1lSK427gBCuIHRX+bvs5qQ72xIBV7Sllz5AUQpvgIhuTs6c3A0CirqicgecE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290170
X-Proofpoint-GUID: _inA-CbV2PGfOdos1olChsnUOBHNfQZS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE3MCBTYWx0ZWRfX5OcSsUwHjqX5
 7L0vYo9Y1bZkdrCQzSpVAs8MaHb0RCaFBPstH0DwUkawN6f6xWSC3+i4l+6/P+oj9PbjdNbkVJs
 r4jp0tD9e2ZzIDp/iKwGO0pjQ9lYnhUvKelaQC6Ttk9PSyEEvES79QMjziSe/2Fy5mpVCEVG5JD
 0k9PnGVweprZP/+1yUHcFvn5Q5Q8wopjAGiZGV1bnOiMwr1seaDmiSRqVdqxR6asiNoKQgFVuh8
 G2R7E8EwjTUEasDJWbWLifUwxTYtk6hK2cfqwjF9G8m9kXkXF1YI8GK4CWvL1m/TVs4eXZGSQ9U
 6C1s3o+by56p1mDjLxpjm2JGsdaq+C3DoPZ5xsUHnGxlF21rCAGPnR+UAKVRU3lLum5LotYv0qB
 QWkHSOIwlP45e/2XdZVFWmFEYXK/vA==
X-Proofpoint-ORIG-GUID: _inA-CbV2PGfOdos1olChsnUOBHNfQZS
X-Authority-Analysis: v=2.4 cv=TcSbdBQh c=1 sm=1 tr=0 ts=692b5adc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9


Duoming,

> The delayed work item imm_tq is initialized in imm_attach() and
> scheduled via imm_queuecommand() for processing SCSI commands. When
> the IMM parallel port SCSI host adapter is detached through
> imm_detach(), the imm_struct device instance is deallocated.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
