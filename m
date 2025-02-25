Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7CA2571B2
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 01:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740448660; cv=fail; b=Wycm1wwLufrTbTjVHK70nXA1BNzFVRKOAE3JxKp/NMwUZq6pNf2POxC5z7PURlGdka2J9vNcoMZ2Evz7818enXxHYeDwOpHDQz7OZSl2yU31nLgY0lrlr4niHTOLNXdQY3KgQCwVjG8K7M438q1IOgLCcGKGKukfE6CsZR8oZb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740448660; c=relaxed/simple;
	bh=BC9lKMRoYJI2FKdnSfZ0isAnPrOzNRkbsEYpAhzGwQw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GLw0BCg0wEbZHnKgxOVbfWWiHs95TF1BduHnFWoaG6Cecpn7TlFYW9hPgDoBs+SRK+IMguCZtkOOx9qK+tx7ocK53+/5P9ZrUgo2Rl906WLcdTBuNylN+qkZx0abqrekRvNHQ1mGnk6b+CnCjbA60SqEcPaIGuEHYBjh2+iU4eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QVYzf4F5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LTCOcVw4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QVYzf4F5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LTCOcVw4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51P1BckT016839;
	Tue, 25 Feb 2025 01:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=O3FJrA+ID76x1gZMHz
	1oZ7pXGyKKGBCjGbCfjqJS9qI=; b=QVYzf4F5YtKz6KDD6oBZBAA/Wq78KtgeIL
	9JEkb/6kXi7Ux0ye6fSqGZVJend6ChXSv0FiZjpFFgV2ycMn81X+y1g5iK8DsNml
	v7rhg+asC90pY8K0pVq6pOM5fyA0V8x2SRzLqZCmCBHiFz9oL7hjg2qIYFu2leRT
	tWJJUJm54dAgZvPz/PqpifqRUbhKK91arUk4YeVBZ9Mpil8j7a1hnCBK/qsGRLsA
	1+1OHYl10/hbvWDTMuOD1LIFuH8NMyjP6BHqBfYHflJ3bv4qykvOlWuZy1byvhn8
	FZGGT8r28t9tcVM4dm17d8OHN6V8fI+RditpGymBWohcdxl9iWOQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y66sby58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:57:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ONAL0x024414;
	Tue, 25 Feb 2025 01:57:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y518j0qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:57:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0kI7YhxuerUN+Tb/ICtCBV1th14ysn4g9F6evVewIGM7+uYAOhueKIl8a51Yftg0KwFpFsjs0l35W3hUpHTtURhlJItio0AtnL16+EkDeJuCeySkojmnEfjvWfC0eAwQPMv4CcTbt7Nf57Bq6Z7ByfXaMTdBlAJuCuCgwSgDux5HNEl0IhlZ+DDL1GeIIAQ63LaF8QA0OFYM9lqYH7I6mdFowl+G7GMNaw5NYTwZwW4QIqLgPvtcfR8cPYZKfCjnrNMnXbRLQ2gqDabPlRDLW9HNyFSVS+I1sChcZme6xrW+wkhYUARVUzwFh6DPNJDnvI777QchNnB+wezp/ExUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3FJrA+ID76x1gZMHz1oZ7pXGyKKGBCjGbCfjqJS9qI=;
 b=qWTreKbuy4DjgGK+b53+TEE4SkhZuT4P1PCOoP3z3tRrdkp7wRn6xjipMNFblzB8gJXXDMEPNPhxBRcchq2xvdfukp3y9bPPjPS40tQc0pUVkiFMR1XEbCGx39NTRwAnAdc2q4OkjGG+v2sBYG+qplCpRrGzsxkkYQVCn2xuV3Zj8XBaI8n34VVMGFiXmYm7kD3EZhXzuxvhFEF8mJszv8d5HEKV/fQDEeGanD+eUx9t8bstnWvPxtm2m9nMcyMs9dpeDmH6ZPEuhhXO6dbwgWyRCSVjOBe0lmgkjv/4M7KAoCOC01Gw2lSpNC/sLrd27YbpYJWipV2LUTwkQVKF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3FJrA+ID76x1gZMHz1oZ7pXGyKKGBCjGbCfjqJS9qI=;
 b=LTCOcVw4UvOl2fWEzQBHEqY3PyoogwceQIRWUO+Z1+uhHLfW2qkwfXJJOWIXti69FOMr1Vubl+Ok7wktlg5mrtqwW+P/Or4y5dSq9b8WquXQmX5Jql81S5D4YZnG3vUwPlJFMNqgVEdapROz09+J3A5Z+bwtYfuO3RtsbZNF+d0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB5773.namprd10.prod.outlook.com (2603:10b6:303:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 01:57:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 01:57:16 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>
Subject: Re: [PATCH 0/4] scsi_debug improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250224115517.495899-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 24 Feb 2025 11:55:13 +0000")
Organization: Oracle Corporation
Message-ID: <yq1mseabxdx.fsf@ca-mkp.ca.oracle.com>
References: <20250224115517.495899-1-john.g.garry@oracle.com>
Date: Mon, 24 Feb 2025 20:57:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB5773:EE_
X-MS-Office365-Filtering-Correlation-Id: 584d89da-cf00-4465-4dcc-08dd553fbade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o/WGH01+8OWiqvFSPhb8mb3iIVYyKGoVs8INhz5EjzwdgReTnOrcShYn9Rpo?=
 =?us-ascii?Q?lSa92jAcaGDKHANxGy8TnX/YPD6XLB8GA0Wxf60FN5SPLjZyDicN53H8FUq8?=
 =?us-ascii?Q?zqg59BMGw81e1ZH3SoNb0b8iQVmviO3qHUZFdCiSPlDXlAfsz8tmYAIpVGPo?=
 =?us-ascii?Q?O1QyDk/TSvC6upTLL3c7xHgNF254dtWl0lwlffixtSKvL9XsV6x/xd/VPdrJ?=
 =?us-ascii?Q?RVReGV99iRLvSk2FXMwyKKxdVi+PYQ9YP11QHdpWzJEtQ/GLDSe5EgvXdkiO?=
 =?us-ascii?Q?D2MfPJqDxL6gULYarUr2fIU3d6Ipp+ACiN4TnmH3dMBvD3P9RKC+N6tKyLCe?=
 =?us-ascii?Q?dP2g5f8MViSy3rV8gpn3SClUAHboblN8rmMz2Sfkzi4ZazpijBodc89Nbabm?=
 =?us-ascii?Q?O0EbaT4S1HQga0cPhsmYwNlS/QMJ2xRyQOjxlPhVFiTLEaKcOf8pILZ3T9do?=
 =?us-ascii?Q?Oyk47xgzbreUwRTCQ9C8fIENOzjf+31YyLI+ZW32bZ1GzeMLj60RaWxnNr+3?=
 =?us-ascii?Q?HCJD7PQDDNREhSl1+XV/r+Nx1ciCf00qLy/c9m1guxrAqUSjiM8ZNB9FKrCE?=
 =?us-ascii?Q?U/GFmhfnBG2d7zKDeup1Hx4cu6epwA42zu6STbRHt6dZbwn2YOEEtDyIaqhj?=
 =?us-ascii?Q?YQLBg4HPdqFFz2a1DRG/ucRWTDorrAtdbIXCylTniZ7oXyg1swX4c+JOCTKb?=
 =?us-ascii?Q?GLUB141fSdEFdgHMlmN34qa316yIuQ/QqjzH6ImQTHSzHeeQGNQ0y6X+JDaR?=
 =?us-ascii?Q?kQ/uhGvwRMv9LD7agIeMMcdLRKHbepGUOYvP2L2q7T1PYDNELLUX+UDXZUqS?=
 =?us-ascii?Q?kez2GWfdnodnQuFKq5CQxkYzLpe6jPwnS+LMjvazoA/zZk72WKZ/98bdf3Tr?=
 =?us-ascii?Q?cA/l3TcQtXBBRJmBCV8vTaD6ldQtHdfnT20CQsfZSVcuXV0F54prCJUjj4ke?=
 =?us-ascii?Q?fkO5DXeAJgDXMajDBF6gX3ITQet8TpQID/YxA5wnBeSTqLG4fsD4MoscImsY?=
 =?us-ascii?Q?S9CRFP7889qwgKrJTJVYnIZCABFNRtzpABDc53pnxxpB3dKjfxlkk//h79vT?=
 =?us-ascii?Q?2T0OZH4wBA94KxIbCLvTl+PWC8SGVI1GHPCvlAu9rlAiwM/Kh7FBZPEeUtrw?=
 =?us-ascii?Q?bKF+WpKEqCN3ticZdwZKJsPTgVgQmeFX2itG8w5r9ccNCEpkerwPyO+UqnmR?=
 =?us-ascii?Q?LTuBmrjuut5vnI7urAkaJP2iWn5ncmAV9XDXx4REIvprkKqxbsL9hgVk8nQD?=
 =?us-ascii?Q?S0XKwsJ+J5LPFpIR3QErCtFJHhOrz6sZscoYeuar1xdJ0rTGeUbmh+a4mesd?=
 =?us-ascii?Q?YMiqRx/APhtKJ3blHokURIJbWfApON4n+xAyRFm0P7yWnOvlAlL8j4CLhN+O?=
 =?us-ascii?Q?Hh8GZ0iTRX2SrEuMy73odJshO0kx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ddsZzuq+EvZou279I2KDXD/O2l0n+kTLcmNaUnUh3OHmZtVsVWDIZzHijjFN?=
 =?us-ascii?Q?hZvTiOWf5mDouGWia8YeN9nto2AX3u7gf3n0r1g0536/kZyh6O4eoBOeHobI?=
 =?us-ascii?Q?sawm3oH/pjiZubsku/EIKv0dGvbi9ZGoNwzA5eeb68pGWATA4SC8/akQulNk?=
 =?us-ascii?Q?caoGnXgV9+/XLhCasgoQ/T+hMCrxs8yht16YvWB5F3OksPv5SObxftqseANV?=
 =?us-ascii?Q?KPbMrzVH+XvciVG/qlsKExt9OvmTNsCgFvIwp9P3FjB7IuAwbQ1QRxBI3vRo?=
 =?us-ascii?Q?EinJdtHJGd8/NUW9avW/IODmxsz4zjojp7RaazRpz5cW6CZCcALvgphtoqmr?=
 =?us-ascii?Q?ONVTdKxG+/wzgvrlZSHZcmUfZIGJixU222Vbeqt8toWSZB2QZU4PghojkTUV?=
 =?us-ascii?Q?g5zDxS6tLVIEox5gGLCw2T6zZmols7R0lXkUQ7eGJHVU8BoDFa8mApy0VxqK?=
 =?us-ascii?Q?jNeT1z3yMBYmwETFDeNa6NGJZTwYbyJz9qYO9AzzYVwHYZ2AoNNMxgrFCkYn?=
 =?us-ascii?Q?UytpALxDiBUouycIXV3fscKuaVWEMWviVIbXIALV8sV8Iz1dLA7HQxym8AuX?=
 =?us-ascii?Q?KTd9uWHZOXUdMbWPMT9es0hY+iQoNHk1U83fv6UX/AEWOPuGYHareAcr0kXE?=
 =?us-ascii?Q?vjT8ilvP7d4LZDaoVvKwE5vxgk1wokQeCR3b/aOElW/7msG6zXbTY8NX5Aut?=
 =?us-ascii?Q?BbLSupNQp6+QYNySXnHRNCk1jIWO11l3ov0xFWLpZeywOZSbgRzFC2/yYyJW?=
 =?us-ascii?Q?fDZf3ZZamfJ6flCQJljlULS5XQraxoasgYYnPIhJ5EAIBIVwuu8b9A3RU6nB?=
 =?us-ascii?Q?WQZpnKhrkIJWNmbo9yVQ2alsiVqUU2A1waCpxT7/Eqi/fxooT3Qkrej5XcLJ?=
 =?us-ascii?Q?m5NweOCH22Ka2sH91VWt7PRXbfEX7jUNVySOCbjgDhzuQKoUBZ83QOzCDlGo?=
 =?us-ascii?Q?AONI3B5vefYFjIoixWWHi6HpibuU5gi1CWHzr58F/aPKWXspXL9iy6nZrkQD?=
 =?us-ascii?Q?AW9PbcTgwCQ05bhlA77KwADPW48u7lv+L92yq/7LTLHYS74dNfxZu0YJiQPv?=
 =?us-ascii?Q?ZHuWGtYWuzyio+CtCGmQZwOH7JeF3l2Kgtc/7gCckkyexg6t/VZ7r8qGOHVE?=
 =?us-ascii?Q?6lNsKwpG9aUC9D2QngSiiTR8eDXjy9c3JTl6a2OXQvII3F8WuW2iYuzitJZd?=
 =?us-ascii?Q?gPRSHTNpuB6Aau2Hx1hV8y9w85skLo4+Ejqbg9Edw6fjoQOLm/eumpdh3mnb?=
 =?us-ascii?Q?9rYL5tvhc9dYEAQMm/MQYry6nHoo1Iv0YaVeOymtDfY/OC8ByA3SuWj1ewCs?=
 =?us-ascii?Q?5h+qB3ADFW1k5KSTVs6BXKlD4/gZBf6nlg4VcbXTQtdv3azjkfdx935aRtkb?=
 =?us-ascii?Q?H1vClL5Q7jjrSkwirUkqFoMkHmydPD8PL/OzZHIbM4OMkSzwvuhTUpWUvxHW?=
 =?us-ascii?Q?H6CUbMgDJzIEDrqFb0sPnCrOOPXUbAvQps84zjnxnEUk38q/JAJ7pCjCy8N6?=
 =?us-ascii?Q?a0AdFJlcbsAUN1FfJkVe86CuP5PdckUcqxYvyXQxGKazp1FtEpJaKaBm0Cpm?=
 =?us-ascii?Q?Swg+EKDnm8wRW/0G2XwOB5PvhwLA3wLQeyhTxQj5N2iYqswsdByWGwgYe6tH?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YVye2eoaNSMdFNYSlBhDS8w/3fVR91V4std4YEGE+LGwm5AmXQowIaVAH/n9s0MqTHs/rs6wObn3jIaEk0NSfZQfqhWIUfrdRhYHofWor2poDQQPd3bSZWuHIjJkWEtUnB30m5bbNgg/RY4vt/fOUwKKKhsmN5Jnfk88kPomw3PzvPbwXIsRh1p2hUVMSrPsiF4r4LuoXLZFxQr+I6oHmM/3jXZFDTr3goR0gNO/CKAg3Nng6OIaC9dGSuH6vGn1e6IPLQHtZ1viZCiV58nthZo9VpppI8zuXcFZ34HPOl4LgSG3q8gzMJ3XucB86LGIivi4O58ZvXlH1URaPNn0WKEl1Rgacj3gicx1XqtyGiz7UPsfE5Kg5AvrMpPNmHzycDN9RBdoQAjjJN8zP1+D0EoGGZK2+3MVVnrtlY86eNJ49Rf4+TOceBbgacBxlCRUsmIbMMNwTn0K2hoTdSrb0U0m/bt82OWOjN1/WGtvuZHBclMAoKLvglgwqQyAOUhOHZXBQ9cOwbSuG5HOMEyT7oBtVDUz83bXHwedelqqEnpQOVLqaBsb3t1hfgTapObcr/hsg/tasMJ/htIFaNRsvY9DI7wfIA2ZELDYJ2Smwmw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584d89da-cf00-4465-4dcc-08dd553fbade
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 01:57:16.3965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjrwAWk7LpqGjWZkla/10tfCBvYl/PjkZDdkfB1k7wIo0lq6ZbdCYpA8UJMpteZlAcarbwCLe41GJ5tFADTU6mhwJBfX1lJyGcmmPEopO6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5773
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_12,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=710 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250011
X-Proofpoint-GUID: S1VQ7YNNMTTJOimCepWdcooejQ93u9Gs
X-Proofpoint-ORIG-GUID: S1VQ7YNNMTTJOimCepWdcooejQ93u9Gs


John,

> The main change in this series is to solve the atomic context sleeping
> issue by now reporting errors back from scsi_debug_abort() to the SCSI
> midlayer when we cannot guarantee if the command was aborted.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
