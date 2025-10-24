Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE41F29A2
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 03:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761274958; cv=fail; b=UoZGLi+1+52jVYfttZUGy5PyH79yDBuX+KPMhrJYDLpPe4b5Ymyg6iY3/88ZlJ0hvh6ynC2vvtXD67LOxLQLbjOjjsPBwNeMdxTqBTnOS+0pNJ7WfAwCQOvpdAZeGZQdHG0+TN7wFE4kwhS9nUgcLf+CRuhNSyHeaOi+HjuP5UY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761274958; c=relaxed/simple;
	bh=YQuRKYlgudurRA3DmYRi3pOmxco9gl+IhCbIc0/PjUc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GfCYPGBCH4Yp2uUAQ7Ib4QcLqbWmOuhrYXKdsL8xk+JXfcKtF7pCavlGLUEC+842eilUGcEWEMXFtWyECEWeKVLh23VPAcd+NeHBaDmrfyqCfvBMroLrqIjjq4c2AK+c5US0z291f6ezfYVtlD9SdrZbmdjGHLwNveYTolYb7rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qjy6a/se; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VfeZvCsH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qjy6a/se";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VfeZvCsH"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNNsw016890;
	Fri, 24 Oct 2025 03:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DgaI7ivKY0OMnbR/PQ
	EEKmqUrfKInIYP1ZRcUOlrXV8=; b=qjy6a/se8uX8InzS5Gm5h5lIOlZDI5Jynx
	KF3bqtEqbP9mfC++F5fNHFIHZ9os/Bu8VOe3K6yU1DMlIwjYUQ0TS5Aj47ehAX8G
	9T28LJHlRKbMly0ALDni7Lvcc6l66Nt5RpdkJJ/r4SyVbRGttZVEFQ3AgeXhWH0u
	2cvJfWPL8GREgwLusVSzv4982m0z3ChPquE6sawnvq+OqBts7HGC0eAXcajeiUzs
	BuPoCzwUQe9bPqrFfZ+GDONtAYRHPjKkRrTZpvjlHFbdfO32uuauNsydrPUlbwpv
	5Hmd0rpqbfs3PeQmYoUwD9y8MLOf5fkx8O527J0jFlmIESGm56YA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k3vv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:02:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O0P6oh035547;
	Fri, 24 Oct 2025 03:02:33 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgcutb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:02:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4a3JR1ulWwbLVRqsRjkPue4f5VONgds7mogu55IFAS4d3wouHUSmX/YRrqrtCmjwytS+7q+FEcoe2nBTDmzLnJaHllyga5FjzW42vYxIysym9PL3lXxuKzaeh72AKh3J/9pKexCDmfi6t3dg0XItTodbamSpQR0llNLMEWv36FVqrylPlFyYu4VhOSxPquUAtCZ2vu1UjlAWhKNo/dl4Z860XpKLdTSr247/9JvaIOTwNspfGpjm1xERO2OFJ3jPyncrj/DJGl2sUJIw71Z70MGChxt7rinn50uPMGeO8wzWoKjkJ4kUfZe4Q6hpsswXk2mjKTnuJYE6Hb2e4Zxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgaI7ivKY0OMnbR/PQEEKmqUrfKInIYP1ZRcUOlrXV8=;
 b=K0amxlCHw3x/40MfMl6HIqJpBc2FDAtZWTpd04FtaC9JQLY7Ln7xh0Hp6OBqP1oKIiIFsmjJRuPc170lg1Ym/OYQ+WCKsh0DE9waiuqDV+qZRS9LIjfBxlOfjTsU9trizlzK1L9wxEGzgDhc0udKpLsCej8n3zQHbxmQ3pv34cMXE62L0lR6b5+q8BA15bxZR3ZMYRbsO6IsJF1Rzs9fSFPbybwMTgGlsMIBl1z6c8JKA7YurrZFET+FHErBvIxEcgyROlmFEexth8e1VYdGOYB7Bj32U/wJe/YnmdJnotetQUQQDdZLA+tmTuGHI7hozIeuiVd8OwyafbXU7fcOjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgaI7ivKY0OMnbR/PQEEKmqUrfKInIYP1ZRcUOlrXV8=;
 b=VfeZvCsHZgJ+ieKbLtLn7ZZ01j3hf0NLle0HFjfOhLcYYJvaAtlCCcm8kEZ2PW1gL1GLb96CuH4wx2SgUZ4IvZ6RhtXHNUeVSEspFWL77EQvSSsuR9tc7/QRbs6X1ijquvlPvvcIBXi6UAyGfcGusk1+yMgyfownFCnkuGBSwJM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7512.namprd10.prod.outlook.com (2603:10b6:8:165::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 03:02:30 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 03:02:30 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        alok.a.tiwarilinux@gmail.com
Subject: Re: [PATCH next] scsi: qla4xxx: Use correct variable in memset for
 clarity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251021090354.1804327-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Tue, 21 Oct 2025 02:03:52 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7k5vw78.fsf@ca-mkp.ca.oracle.com>
References: <20251021090354.1804327-1-alok.a.tiwari@oracle.com>
Date: Thu, 23 Oct 2025 23:02:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bedef93-e0ca-44d1-a2cf-08de12a9c58a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DIBAPunltH6tAAb/uvlOXtNWpmGP9Arog0GWP1JbauFAMeWf5Yp1CBqJeOhL?=
 =?us-ascii?Q?ae3IcmMQ4hpaun4fh6HNBi67+Mt3qYlbsqEwHdd/sx9yTriOQYshNPIbZJFS?=
 =?us-ascii?Q?nAiYQhPTEK5T9cuvM4H+fzNaD/R5cW8B4CV7B92ozygespu/X2B7wOFDq3J7?=
 =?us-ascii?Q?sdZLjPHqy/NjBJhslmQnlGXXLLJS2WfCANTEUfVwe5B2vVwtQdrYyoEy9Tiz?=
 =?us-ascii?Q?O0QHZSxYKsxg4S8hFLPq+dRQV2omQ60iCr8O69eWNX6UVZL15xzhRt5vpvHH?=
 =?us-ascii?Q?6N8hNtM5wFbzo2reDXOzWzkgeO1SRWGbVdsR35mrIrJ1FJB1lFfcVjIkTr9T?=
 =?us-ascii?Q?JkCQ+BTe46kxAl/WBmtWOM6gi0EZxhc6oDSu+aQhVj9VGYAZ2W8GsEQ0QdQ9?=
 =?us-ascii?Q?kS64KeaIL7bv/7hPngf75SLhhVKw8Xwo6/zUMabAVaHGjz6lbAJTIB+Kp6GR?=
 =?us-ascii?Q?4p7xpa8ugofHU9dQ4kr/OotFe6Vlgj6sNs6AYUAwtf1mQK4HidLnNF/COqcT?=
 =?us-ascii?Q?afP3mv410D9nosWT8mDegYq4qNLJ5aukJAGPla/DzeEMMcCDTDbU8W/cKLeU?=
 =?us-ascii?Q?8R0MaanXtwXTvtBBdOWkfznnLzf5E5Q/9M0AvSwy+cWBK3z1acS2SCEpVCrB?=
 =?us-ascii?Q?0jM303CssWFWNE8erv6zxrXO6oillfHW0wlIQm6SYQ9CsYCRxwnRBXQcxJ+5?=
 =?us-ascii?Q?riaN1A4xJqUfj5nNti3qElMl3aNJamo/IRug96nD94ZXaleObFn4mw6qcJ3h?=
 =?us-ascii?Q?eqh18sRiJfWHZ2FVxQ447Ix6ZGjqDgf6cqG5RuQ8VM3w7PFTBxuZpWelYhTH?=
 =?us-ascii?Q?BTVI3/9LRPtAd+VFnf6+/yMK4/1CF/bYjQ7xrnYFhB+rwrG8SGpeNEioS/eS?=
 =?us-ascii?Q?e9oP/dnIgVbjCfXGP/JmbFIqC1QGp1L+5+6r/iUrAP5OH0n37+QIwA8B1iBM?=
 =?us-ascii?Q?AEZMyoBiRyY9qEZBAnvzm6PDxt7b0S7AppTJnUii6IGWTPcdTOMnow0epV2w?=
 =?us-ascii?Q?NW1KlHp0JXJAQtl11asEq9WG5+PVG1cEUZchJ5SA01fs2J36PBkpH5r00n81?=
 =?us-ascii?Q?1V4OX/eqk0+2Z3ubb/UavBEUwuW0VZd838HPEDl+2Z8zuxepCkMDAqFyI/3K?=
 =?us-ascii?Q?vuX2Np77k+nF0+ns3om1eiKwsHz/nOhHXOa0jHCK4KtXTEh5KOXcMM5UBFph?=
 =?us-ascii?Q?UiKL8C89+kz8mRF3QgmB2x5OmZhR/zm0eSkCgumE+q2Ubnt17H/ZOhy11sIB?=
 =?us-ascii?Q?8QReNStyotX98t/3mp9KrHaijkjJbjOUimeRf7kCEyBJqV6841r3NirhRcM6?=
 =?us-ascii?Q?49eRgdol7fuNvSTJZN991OC5jufFFgEfoJLiWJPLaFUiVwSYEk14uM0sIYHw?=
 =?us-ascii?Q?4d76qHxPdq4WUKVmGtmn8xZntRbbrUc5+6doVTYwRwr6xp6vNxwgTLmZh0om?=
 =?us-ascii?Q?M3Vl+xgqt5SA8hCUYj+MNOZCW+H8Soyr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZdM5D9sSgRegXFob9MhXU62bUy7j0lMABttsbJ4cDsezkPrtuDj7eD7R50+K?=
 =?us-ascii?Q?6YBNGEW3gD57ByPLWG7+JJUMgRlrA0F3aOfaCQHqge7MDyPTK2bCpjaQ66/K?=
 =?us-ascii?Q?kXQOS63EmEXsC8QI6Iyg7dkllv/v8AMq0Cx/RQPbz94jeAvd0CqH+qA/8mTq?=
 =?us-ascii?Q?phTxJ6wT165Jsb/pRcpc7T3TE2uRPcQtYV8ACGoESiH+huWF//HarxkxDZQT?=
 =?us-ascii?Q?18DdZpsG4U/cwO38tlHTxrGHhtem1lJMXDtc75NJHt78D98WZEalpWdTk9Px?=
 =?us-ascii?Q?/oqW6aDixuLd3mOKoMs7PwvsaUWKUI/rGMwa8oYNc1xKDEkl0P8wQ4qdovfZ?=
 =?us-ascii?Q?0udbN5rENOGWCeK/CxNoGYUBsXA+uHIdAaYUx26lIVtCzLKX+FSDMwOu0BxZ?=
 =?us-ascii?Q?eV4Ot0pxbCx7WbvKIygQp6W6tRMMnYRz2xh5x4EMX7R4s3M8xyGQnkRQcwnR?=
 =?us-ascii?Q?A8jwhH7/dDNPnpn5It32Bc3DiSWjddyCaCQsBiJg+cBEJYdK9P8/KGOLs1mL?=
 =?us-ascii?Q?lM2DelLHsj15zH8G6kRXljXB1C50ca+KvPNNbncKwd37zXEvw5iW8vgPz1uK?=
 =?us-ascii?Q?EoV6d6iLIqY7CoeXmX8d3/pnrEXSjD6Kg7vDbnZvbVGyuLjRyyMDkhaIEiPS?=
 =?us-ascii?Q?RJb+J6K8f5lT4y0w/4DQbQZmLL08Hn/IEX5/HiFZyNr99xvvdCSgvP9Bh5sv?=
 =?us-ascii?Q?+MikN5PYmfW8s0u4mT/7i6weqpVEn7hPzdB0rRd1Azn22tcQFr/S26Jg/m3B?=
 =?us-ascii?Q?qsOPzc9UUTGW4QxVrCI4TdgNFtq8fhh8ZdNDAp/1dOna7avAHAbjRVmNd1he?=
 =?us-ascii?Q?RY2yPlKBzmpeHAjFk1K1B4t3KcsCHA7tLpJVseJLPFAk+BcgwFRWjxAzLstf?=
 =?us-ascii?Q?KBmVGFOOLO5z5N2oanIc8qP9BqUxxxEc2gsNmwGasyTPHLnzxMUyWOeDILcU?=
 =?us-ascii?Q?QCygQUo+DSghl7Xw7Ep805Nl6NTLu4dyEJfTnhkiCvyi9k2BX4c6z/DJhnbd?=
 =?us-ascii?Q?9t+S1gws14wCw5tCyDKVwNjzbU2a9ayZzjwRh2i+x+nKRZ3k6E2XUwYFV9bg?=
 =?us-ascii?Q?r8VVQmhRtQ7U44zaleki5svzctc+s7Mf5CLprHvdtCu7x+OPoNXvmshNJ/aJ?=
 =?us-ascii?Q?rSWjmi/Kfn4ibwbMVnusV3EadsxSybDPzEZ2uL7ZtOj/hH5981HSJQAhS3pg?=
 =?us-ascii?Q?KdrX1vPfjw2gDxDUC0d2Yh4KWlyikaPjRFie08D7536xeQsJl+Mn0p5X+Qod?=
 =?us-ascii?Q?/5itrtHf9bCTBxSd3/yZrraxTzqXk+Zhql3xLON0Rp9BKU5FvDWy4YjhjAn+?=
 =?us-ascii?Q?YnMFavycs+VRXblHHPpQX79kEiIYmcb3EIhV5XfxggGYyW1yk0qYCVrgJskn?=
 =?us-ascii?Q?cpbYloPYKFDcpEO/BbU9NKFJJCfYJjt2g9ETdLsxUNlUflmD5fbiZ3tom5SJ?=
 =?us-ascii?Q?WJGLe0shxVptBoJ6dApt5TXDzuSkj3PrEPRnDL6m6fqNHRR2gPMHynSSDukL?=
 =?us-ascii?Q?BKznt9+7VtHF7lKRohEUEP+vHXK2Or4e6OE/PBw803Qxk3qjMPJD3+5DAPLA?=
 =?us-ascii?Q?+4ml4G72hGvx5yhybghrkicj4w3sP0kIRe6bcXcVcQ8mh8fKrs4bUmb/ZOJS?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yIFyeS5VVUvesKl32CzC/c5Qk2dwbhWn8cIUrGuXE7zD7bJ2ij7IQ2+CHSYmK2etQo3J99HdCMbj+MzQm5A1vaFRquLfALYbK6PFyFronJR4LxhtLGP++RZysaYkrHVyt8vsds0qvDlCtDuxIF2n6itbujSLr9S9cwIq39u+BFxkX+HIRX6xWrq9BxM9q7wkfKp6bZ1fxONofpwkRnaWedwIc7N3NMMIMNPEr+v/jRGrAEYkCspKP+/7fvJKXw+gAhjqhRZFYNSSdn+347WiMXO/ZiXCBDSAj4KFqu1MHWBCGmzl3411br6ntkxiMfSsPX14B2QaXjgS79NSsnAAZZqCN5El7qYQEOQHmS0h8gF/ikD3q+SmoAenl4fL3izyfy0m+uUXI+TuMaqUTTKPrKrMs2HSWBTMYl9NX1PT9Y4maMSYh6hgWwNnqHbcmivQRbANehMrhLdHppfPw0KsFhmEfvB9Z+M++1Hc6IQyY9W4GxzVmH0n9joGbEdQef622T7tuo0Uqvm3kKUJOyp66k8+99Jl8Q1d2ll7g67kBwqFcbJYZ8Ekb9cnnRm1Hz4NtQn0hUbxTymW2Ly+xvch3BfX7nMqPZuEutdcZv02L4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bedef93-e0ca-44d1-a2cf-08de12a9c58a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 03:02:30.7255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V20NrRn/6e2aSQ8clLiGQ4hE7VZxSI6rpQdT/J5eYsAYDD7wVHrFFeTAnh9cmjlkiftuWpZwDuc5bhmBxMaKwvWHbikxKVvelPKLtUM7W08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7512
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=684 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240026
X-Proofpoint-GUID: l1rGMn4N4uWqSiNAncekCIXWPc-DMwsH
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68faec49 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=mCP6tGT-Bm2N9-3FsvIA:9 cc=ntf
 awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX5ZXnvg5lyQML
 aHGUNzoPswSyo1W7uOlJX0BxUflbaLHjSFyIHGWC7kQv+g70d65aNFXWKVtmi3NTvIOHjzSJVXd
 qsxVMPy+7x/bwrdi7mRejitxcGajt2abz2HXopphrC7fqoTiETWY3JTLtAf6X2n//a/YVoPCSqk
 kMe3nyRHbJtOAaNRLd4sqSWIOfFyV5jpVpXaztbAqJIx8FR8TL7oQtvHZ0TQu4RAY0FGEeMDwbC
 q5mDdUZ+nu/qtJJ8/Hmls7BO1xYOXD5an9uzpGrrRSIou1u8jHvHqOYhSsyAjyESp3Wrp8Hb5lN
 3AD3N7qPRMg/5jxOxLtfCvl7vY7pMagMEJb/Ev41XwOYF8l86PxHH2fd1V7pJFjyehsKuEuHbvN
 NZevGLy/UhS1x086nJdi8ggpscen0ZLYD0dZ16r/BxIkvpVNwHI=
X-Proofpoint-ORIG-GUID: l1rGMn4N4uWqSiNAncekCIXWPc-DMwsH


Alok,

> Both mbox_cmd and mbox_sts have the same size, so using
> sizeof(mbox_cmd) when clearing mbox_sts did not cause any functional
> issue. However, it is misleading and reduces code readability.
>
> Update the memset() calls to use sizeof(mbox_sts) to make the intent
> clear

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
