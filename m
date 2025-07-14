Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6616B2AD20
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2025 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752511915; cv=fail; b=LRaI8l4waEjR9lJQntHypruhwrPYq6JC39EUE0PO5uFQZORsIP05ZvvnLEsO99eLDzwnbwQfFpZS6GqFQhFXKH8S9sYIB8qQLnL2cUihSAztxBCd6X5eRCr+H8Tb+Cs/v1xzkUTI1W/R49SFDK999XuUgvNpvReWQTiXpAWjccc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752511915; c=relaxed/simple;
	bh=W3q6YZ9fEsqBOeKaanv+f4CZ7fHE6m76eAWQbg0y8Fc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NnT29NfaNqg8pYEqA+OsAZzcTPa/5iepcwRIN1EyaLH13aJJZNHwfqDOFgWZ+CBwg1KGBGJ1sohJzxwDfB+BjPWwG/Muw10sYiTfDoIS6IbeznXyaGXFy8K6GsEbxttpm+LtaId+nShJLLRSlYS/oYVInKvokVHzuj84VX5jgVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QyS1sXuX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iUVzBgnB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QyS1sXuX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iUVzBgnB"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E9Z5IQ018810;
	Mon, 14 Jul 2025 16:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3Cr/9YtbzB73aDzxX/
	c74eb4hsxZqmKvt3efVsTYCJc=; b=QyS1sXuXoIjF0rQXry0JCwvQ7cCY87DF6g
	Wbll+GmGVi6wOsxC5wZA75anLHpzsXe11edVPgJjtaDxejVXBPo07TnD6rC2BEQ1
	kqncm4LYw85PMvm3VS1YkGSSJ/qoDRbHVQDu16rc7KYAwJzn+rYqfOKrjayyfMPA
	SKC/wcwhoWmhTLnQbSR3pry0y8ArrDexfNB1a3fhbJD0tawo93B8YQpRg3isF50o
	ZVkYCAhZGaVr5fh9HBv7ZIDShoC5v6MWiQUs8o577nAONFL2cc9jgU5eDkLiBSyI
	VigXM+3reTJpmoxJfY2ysPjE5WllJbP/ezGnA2Dz1gEuFpMqcbCA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ufnqneev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:51:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGEDVG011645;
	Mon, 14 Jul 2025 16:51:51 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58s693-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:51:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lg+SuSUVKxzlZBuxq4ZGMvDfUURRFVQZpWR6qiV75AHCiSE3ZWPxYCAGlCAAovR5eALW+x0LRaEOmakz6L2XU3Nm8CqRhZpaPvrbqgFS0hxCOYynbTp+GDb9hwKaHNcBqBfsjlx/xYg4+uMEjhl4MFiLvJ0fnzikU8baRYDgzWXPn6LxuTcUJMjQDqImP6Hn1VsQRvt7UnJelITv87GyGaugmaAG7nayhkiGsKv0CR2LDJYvD1KjtmQZbB7n7k1+jVglqEFLYHD/WZhNFH9vxh3TS1Jx8o8dbw5xqseWhsCA4J9b2fjmdYOCu3g+JLwd9J1jAAC1jgUy9mvmSesvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Cr/9YtbzB73aDzxX/c74eb4hsxZqmKvt3efVsTYCJc=;
 b=ukJYnu53yRVTFLPerOQd3Yz/Gi3Ml9wzYC0CgKekjfeMBlIdA63fBsH0wfsxO1bjTBnrYQFwhDPIhlhRogfLTXJXB1SpZaIhZM4Ckz5xGnC3yr8KE6rFBLjQQhOktvrv/b1MBoKsGUy+R27UA4q/OKwaQ+0GXzGGjlajLIyTxc9E1YPtSrGkaCsbYXZ8QwroO/LGde7yjDDzQZ8R6IV+DMQE/wHJhTA/bA3fvWn5nj7hXk/2llBk/jsGUhJr5WgWpsWpa0LAG2Ugae+knl1uxJpNB0ISzgsRHrbLc/cEOfRe1YFHz2p+8K215OKGk86SAF1MBB1di8kw4OrFjziQ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Cr/9YtbzB73aDzxX/c74eb4hsxZqmKvt3efVsTYCJc=;
 b=iUVzBgnBnW2fx1Ht62Bmzqn5DuYX7lyEZniiBWzUREd0kEDMnRAVL6hjtY95IXLw29Z9wuo9yM46LJ/nODFhMqXD6NHMeBIApPYW1vsFbtuR+kHZbkr9vkQUJJYNz55u9b6cPcbErOWPHEkRX/CEobXmqZ7uuNKS4v08BSOqT6Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6135.namprd10.prod.outlook.com (2603:10b6:8:b6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.29; Mon, 14 Jul 2025 16:51:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 16:51:49 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few minor bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Sat, 28 Jun 2025 01:15:35 +0530")
Organization: Oracle Corporation
Message-ID: <yq1o6tmaf6q.fsf@ca-mkp.ca.oracle.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Date: Mon, 14 Jul 2025 12:51:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0021.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: ee46cdd3-0835-4423-60ba-08ddc2f6b99c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EOLjLQUAIOUaKw9ly0T+o7e7S2sQaN3gKlDTdanSBZzTROlBMwhlU0Dnl3fn?=
 =?us-ascii?Q?PsBVlk1hj+PjF2CRmqfIyBSZBdiC7XmEWH61kU9kmgGkmS9nigXr86SlEMVG?=
 =?us-ascii?Q?K0cIJlfETrmKt3TcE3rQAZZmfERa/dunVjDVjQUkT5ngfyaVHnVCqQypwhII?=
 =?us-ascii?Q?CrH0ma8b+euoe01PufOzLdRjGeuE/e0cUU7DU+Y6VqnjeZdBACn74f8XcgwC?=
 =?us-ascii?Q?GPOfYE3pvzrfJUW+UKLbEg5yzWwLx+84S263vji2Jzy03cgLzzCiXQDn4psk?=
 =?us-ascii?Q?UiG1JOCL05R9QZnUePd0KTpqKZtnTmAnnxfQ+sEN6HpTyqJxZzE7gZY8c18K?=
 =?us-ascii?Q?oDkW+BzCPV5Sm6DO8//v0AjmeWGhdymPHlh1nrmmzS05d00cz0kzBMdgYLWl?=
 =?us-ascii?Q?sLhpzCGhvVkVGJ8Mkv/J9hlF+iT3bDImOmp1ssKa2HHDOSxErW4OFFkJqPPm?=
 =?us-ascii?Q?wh3CqNwUVOxUKnGtIbWCvNp1L/2O6oFVmd2bgB77j8IsdJ6mx7k3YRqyFPs3?=
 =?us-ascii?Q?CyJXTe9Gfb5NuIkvlLkO0jc+ZYPPFP0j8bO1NGhbAwvXBSogRhCZBntfF2fQ?=
 =?us-ascii?Q?53dZlvsB+c4rvjgA6lYP1nhfwIHzhvhkBeR3n38/DdkjOgVvmWXgiI6FfoES?=
 =?us-ascii?Q?oErgP2e9yk4mv98i0IafMYLHs+t/KQr9StmpiMFlfjKLAmp1zFAb6a3Utv1/?=
 =?us-ascii?Q?5bcpDqiC+651gBIYZ4rT0HaGC8I+AXOseZ//IizqY7z4y3aAObp4PrshhDVN?=
 =?us-ascii?Q?oesbfY8O6P79q1Mby47g6t5EFmrrCt6msWg4GzNgbmynS0ErhStl28JsGDag?=
 =?us-ascii?Q?2WcVARf5BDU1uFwK1mtelNFn6gyClWwYGFRuYldeUiOeFUdQeU/qqxNF/FQc?=
 =?us-ascii?Q?S2SV1lgd+YEOYdPZcAKkRydhG54XCdPd/o208ii7J0t68kWVpbtP076vxgfN?=
 =?us-ascii?Q?24W5DP78axvU4gS3g8OHxl6TvgyA9VGwJlUhDHA8wY0e/PxFMsNopQVUfR6E?=
 =?us-ascii?Q?LxgAboxZuElmq2xYX/H1yFmCM8tyCOXprxPU2Ir+N6tezzDPGkBaaSy3b3xU?=
 =?us-ascii?Q?iXow61g9pAngjZ6WNLyTdLsF0t/pbaLecQJsLXyoSqNzdBF3hsaVcUYTxAFp?=
 =?us-ascii?Q?Q3frsISM1spONN9/CD9BykxGZkk3yE0Q78cyTGmo9WaMcUyHqiVu3w64NAfE?=
 =?us-ascii?Q?sjr6FOLLlZZOgxuG+zS+9D4GALwUssKRKPRPGbhe4+r8No79XhCeV3cFmKT7?=
 =?us-ascii?Q?+CZIdmgV7o1PFHP2ZPEth3rI7/Ax/PRZDfviCWq59R9Ke44hBHVNm7WqOF4C?=
 =?us-ascii?Q?wJcqqM6ZUdjwYtBhcGB7qYonNPbh9Tjn73MGK7Y9701yJaOU4nhEHvWo2CtC?=
 =?us-ascii?Q?2XBYXyhyH/3c3jUCXNf6bulOhviyGi864xjdyeE1zKcP28hj3Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pqgVTJPpfIehdillim5iwvGr12q9p4uIbKUhD0KJGTQkCireaYilxUShgtxl?=
 =?us-ascii?Q?q/94ztS2MK1wUujsq5y02cLO0B/9VVmfshMBXOy69LrhAv1LplZhszfvdZYC?=
 =?us-ascii?Q?Wd/exWE1jqZBI1DMRvskgoe4E5/sPKWcb43zfc4ldS5czlkmVhPI1lB+YYZk?=
 =?us-ascii?Q?GfVWe0ccBtGZvU/Y/8/L5NGj8LKKBReLU2MBufTaiaWhHAvbdr5MXwcVsRL0?=
 =?us-ascii?Q?zIbQyfU7ftJ7GLJJJ3qb6pT4cfuSpmECwRQwopn5f4/5yWp+WK6UlaHFrbyf?=
 =?us-ascii?Q?pliOJLeu0A0yhpg7IeLYXdiBMznJ7DKutfbGv2sXWjQumM64yqpVqEs7tp3+?=
 =?us-ascii?Q?+za4tdCixn7QBeb17SOHXQf2OTfg6F9Kx/QFItmv7qKBbBxMX5Na2u5X9Bmp?=
 =?us-ascii?Q?Mhjbeo/rPgg8fA/E0bcFhNWrSGz0/Rm97ANihzQnHZHGG/vS5bLNmaV2B51H?=
 =?us-ascii?Q?qddvmCuXx+7b3CF44H4uXMw33a/KW5PrkbPcm86bMfgJusHGA1MF847N5Ddf?=
 =?us-ascii?Q?DNW86XMwOZ1srrtlmumsCiMZBnW+9lFM0vvzAh4/KoOz4uRJxHs4n3KQh1YN?=
 =?us-ascii?Q?sAw6UPoljjaytJDf6uo9eKSQaQ2exrARSpmgjloxP3qodGsOUp0nGiN1depd?=
 =?us-ascii?Q?cjZmM2wm5GW3SaxMi3YC64zl458S6j2lsJxiVdrNYz7hzfViGyLIHmjqdNdQ?=
 =?us-ascii?Q?Sz8/W442DfzpuFiQXfx555WK5MRAIPDEP4OhERkBgFWdFImXVC3liESX0gB8?=
 =?us-ascii?Q?49dvfkAM5QgqPGs4p0g//gJi/7hiQ+c0fUKRLNmYIZXIc4e4Xc50ESNkJ1eh?=
 =?us-ascii?Q?V/I4pI1AR3sV0JMOulo6iimVaxfwE2HFxPeWMP8b2UJoSyAa2G2l1Hp6GPe0?=
 =?us-ascii?Q?00WrU54/EF6kNi1PUELO0IgIY86RoqeetPvMm39DDEzylhnZWcjTuh1syrDg?=
 =?us-ascii?Q?DGGaeqXVdOGUCOmjHkq5ec1XXO1KrTOSQNWjXesDQUfPwwIsANbDH0tksjEO?=
 =?us-ascii?Q?x/N5j+rDUSvXKPXIuLueWCdz+DYRG0OjrgZuezQGiF7NWbCxOarjQYls0Tf+?=
 =?us-ascii?Q?EP+dGz3cMnoXrgnWlDgNo/McyvRxGZbZABBbqfi4wZ+jvKlwEcqUXgJ1KMgL?=
 =?us-ascii?Q?gcuhYedO1bUCZJGknc+IvoLYCat/DCrRacFu6nwNxG6CXUNpXy0QxG939eGc?=
 =?us-ascii?Q?WdxlBclZcEs4iK0Diqn0ja+It8ME+h7S4USJ2HSbP8UvZpKvj2mb0BddoeR6?=
 =?us-ascii?Q?ibdJiQiadvBDlOTg1Ou0EIi+0HA/aeWJA3nTyTQuxKAFKac1C430blipdCNH?=
 =?us-ascii?Q?utkwgGK1pDDx3amEcw0acz3hT1Bhcg1CGOo+7Kmih8NCKcV2nYaO4ULLsiQd?=
 =?us-ascii?Q?RYmUQjdJfchjFp3zhGeQCL4nEn41mX4vIIxwjYQCC/5KWMebqF1zwwX7UV20?=
 =?us-ascii?Q?cto5kUCIQeQfOypMhC9A+z+deW+rcChugyj33r6R6Ajgw/pH/A64dM/Ut8Z1?=
 =?us-ascii?Q?WqNSq79SClsfmjGEMVFWwpWb2v1NRYlnolNYETIHgYIAc0jDszL9GfHVFv56?=
 =?us-ascii?Q?uaViAB27jfC1T+R9H2MjtiMnkOK/cyP844Q6oDGB1byzo11JEx0tddAneht4?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5SqqZtP9j09NefJv2uEUvCX3LM3aHrJWcZf8OWYwrohuhZpQOhP54FZukJu1ce3AlUSogBmQD92E1yEDdMHcWjvii64rMi/c3GP5zOr+mdMOx4bZAn73rMkJj6bmawndwdZWDfl4b5NMqJyZb5aHkeGPv9ggr68YY4GYYaFIww0EA6KXUotmJJ1tnOdUQM/TTi2dD7oGYvRxO4RjnOJli4wg0bJVaKMCugO0Xt83THD7LBlg0NmDyJRLS7cdHv5b7KLHRrDJbnBEPgMaKLJ0e5248HsspX+I26Qy4Hdqm0o3ubnHNOvWY6WTBKURO5PDlnhCMF94OyTn1Wy1DqOnGjtZP4p9F6caeyRKC0GqX+4Fwxfl2ftw44u9EQvDEAHzzJf2CH9ud2vOcj3cC/Xdd2gtn1d0gDB3DGaubkXk2dcHWBEYF0rQ+lSQYxT5GkAOY0jpSDh+pWpiFtjitmSG7QtDycyzEbggyXrickxCsQn0s3ZsGo0abIPVayaLxhE+1EHxZapqGGL2U0lkzzNxS8aS8WPE5Hk8YRRXoOKwi7ByBQkMVv8Z2nPDBYBH+nNHl2bh13vshSMMW000zzGSyDULKSsI1fsrnrjzTRMSCFk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee46cdd3-0835-4423-60ba-08ddc2f6b99c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:51:48.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ljrumukELX8m7U4khr0BmEA2t/xMkOI3HexLnIN5EDGUMBX/qLcIWeKuxeqUx+Vn8M0+mATdLeCxJBd70O9qcrVwZRMcGyHoSEsg0Q5JF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=793 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140104
X-Proofpoint-GUID: ztpVpVQ125pZWydsreQ91AW81V0zaa5n
X-Proofpoint-ORIG-GUID: ztpVpVQ125pZWydsreQ91AW81V0zaa5n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNCBTYWx0ZWRfX1N6J/wRsz1uP u1aEXwTtv/BJFupc4LYnzOYv4+OkU3427+Q8blngARlna3Y+VC84HBzWP8ajm3OUy6umQnvdGP0 RG4/rT6RtT1NZ8diciTYvkvBoexaC/5RmEekxLbIZY0pxC0vI+1vuR+FRQF6dOcn13tNOtdzaw5
 H0KtSCoGG3aGvYexdVfou8z80HZZkaPO6YqHn4t/iWkmIZF7z5IIJBL8SIw6XibmnpfBUrOBMRQ 3qWJYsn7yIyvuQf2jDHFXq3JnaEZvTCjHTthN5mNHqoT1Qft3bHgBgOh5jtioRJdy29lrbWuWre a5mgnvDTktHnAcRAapB7NowG46NIqlLVBDnwDQ/9qn3fLsS6QjTqZyWUtbLerFvN89snw2a05k4
 WSHcASSP9fsbKlzaew78+M89uPbroZdoPJgxuG9hiiKOa04ebmxkEXJHQkVBq8WjUdQoBup4
X-Authority-Analysis: v=2.4 cv=U9ySDfru c=1 sm=1 tr=0 ts=687535a8 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12062


Ranjan,

> Few minor fixes of mpi3mr driver.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
