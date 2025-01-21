Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4501F5421
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2025 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479812; cv=fail; b=Q3lWlFKGAPQfAIbSTa4CinPlG6MkzNbnOsr/UyP7nQzS9KJtvJ8yAkw9XDQbUo1YOOaa68SR3GG/BWnp0nurgmMt3tXWV41Z5KM+Fv1m4bzrREliJMPwxLyTAyIfyDTdtqe1GZH3CWBiL4a7mtRModJJc3Xzzk99Xq+Lvo0H1fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479812; c=relaxed/simple;
	bh=oOyK612wLLeBhuRW/3CbwaRsp1cG64LeigkOMggq1sc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PYDFVBVGKUA6IQcmQldMpom/o+vG00YSR4flik6aND0SSuZ0/Q5LniuRLyMjMhAvsdq8q/GV6U0reFVBsHp4JPBLWtT367W5aDc8sPQoQpRK8ZlHKgBMr8YJtH2CyelbLfiW04eI10jhqyHa2kYIDDtiDwDT3RCZn6PEyaXeJCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DmaUF1eB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dFigYj4b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DmaUF1eB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dFigYj4b"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LFDvsQ030861;
	Tue, 21 Jan 2025 17:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Z5amxSSr7oTycmSqmv
	viJSzsZyR0EpMr40OTfhjrcpc=; b=DmaUF1eBUT39NgnwB3xIFuklyhYOuHLUZp
	6DDKuWjVg+lROdVc6G4vhX+ShOXtHTw1Poe8SpC38A5Ujmdkwi6LDbRg3pel8RUj
	Iad8+h9NblXbs7XL6Z5lpmGuMmEf0pnyX8T7S85b6NLaPsekydUzGEiSzssdlMbF
	5Oy7hQAM9TkbU2MKIIyJTAuJjx6QUrwIWvJ+3F7Tkk+Bu251z3SJZfQORrlhQCaB
	tHIofYSod0wPUlSng409B8KfrKJrGU3rQfGnl5kEHibEQJbaj/uH3SN0yf7nw/7A
	PPLi/7BHJ7F8LKB++FgAXUAwbQm0JvKxR5t5hsjoMkVVGuPYt/Lw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qkwwha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:16:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LHDw7R004851;
	Tue, 21 Jan 2025 17:16:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 449194jg1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cl/uVJxHZFFH0aRapzu96hx5tmQ3mfZUkqBjghHVeY/D426LkH41/u3h/XtO0ZoIKZythZiWvW163ker1WYPw6aewPal/LALtTmwkWVilNb7WtsC/mcdPHtLioMhDOv2znmhSG4NqRLxFc8AfieiSzi/KL39wT+ycTq9N/ZTO2rJTTAT6Rsb2H96PjobnVqRw0BUpfhEGpBtwd+polHVoao3hLoM59QyXoOYYMeFhBYXkCqpyIe1h21wYds/OSwQLto66EmPmZI3LW8OJszQ+WlrmVq1Y8HpYCv0ix5I29DAFnuXYXeKAYKox6dQxFORrTy2HBST6sNvwX2UqTR2cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5amxSSr7oTycmSqmvviJSzsZyR0EpMr40OTfhjrcpc=;
 b=EtNS3gcUrWypa3Ni+pcHwF+q6PFtBvFPTVrRF/Eje0TT0R8g1rUY+ll+8fd0GnjGJUbG24bgwLKA13xXgE14gsdrQpX8NUGZjEzlbaugGXG+3gZ1CrZ8jWHOJyiH05VLChSXGe3l3SqQlRbVj1gz0549I2pZ9CQ2JgXge/Cxyc5OYCFxo0pmm5ntaG9lzGVHCOBg+AyqYhk24WMw6pjV6PYqya64Py7n+u0aweO5YFaEIXef84BCzzxmiCeMFt2uFcobxql+TKpAoH2cxG/d/RswXL5AryU0Gl7yPHQswfP57gs2dxdMXlfdv1RGuarcqb3z7e33MDlnLz2yP27sbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5amxSSr7oTycmSqmvviJSzsZyR0EpMr40OTfhjrcpc=;
 b=dFigYj4bs7c7StOecx49YpKA9qIuK9JTtouNGhoBhkd1VimsuXMtrRTSxTZ/ORsbyUMBpIrSsoEzfzw3wsQAlQp5buUO6QvTAa54DRHX7pSfWxQsfzPyWrRHUIDow3LsmD38X5WqZs69x5CEL6xzQRl5fCsqnTEWAz3l9zBTAlw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB7993.namprd10.prod.outlook.com (2603:10b6:208:504::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Tue, 21 Jan
 2025 17:16:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 17:16:38 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/1] scsi: Add passthrough tests for success and no
 failure definitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250113180757.16691-1-michael.christie@oracle.com> (Mike
	Christie's message of "Mon, 13 Jan 2025 12:07:57 -0600")
Organization: Oracle Corporation
Message-ID: <yq134hcxf2r.fsf@ca-mkp.ca.oracle.com>
References: <20250113180757.16691-1-michael.christie@oracle.com>
Date: Tue, 21 Jan 2025 12:16:35 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0231.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: 9642bec5-1565-49e9-288d-08dd3a3f5d5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sxI9BKNiq1QEruZ5F4tgEiqa3OaWKyPuKVQMhbEO6mwP1ujXnM+6YGn7gJn+?=
 =?us-ascii?Q?T/Mhgl4kV2jzyOdJm3+BfRhagXg3xgvCufx1j6PKWMdrYXeaZRplUUJjlgfN?=
 =?us-ascii?Q?ohXwsfSgF1hOO5kTdYE2cmwD0YKZTfFkW1YYRzxpUqloQvhwgx5Gp9vSgUPc?=
 =?us-ascii?Q?6z1iRiRbDNf6c1QSb2QpPOqPWxEoseiN1zKylnI/CRIi6b6g4UykFjOW3LUq?=
 =?us-ascii?Q?DhLF0ZFBDUo02EooqddWf2KWqI7owhaAAMcTHFbCP044TRcW7Ze1srjwYYFN?=
 =?us-ascii?Q?NPBNp6wkue7r8ygBN8Ry0gtyGD32TsTiSvvAT8b7/aQecidcS/roM+4vcJY+?=
 =?us-ascii?Q?2VzzkZzbkGVY+oziKOw9qsT9P5GLogVQjWA2XeHDTsm0VTeS5hvlUtbgTSgh?=
 =?us-ascii?Q?E1rzR9Yd7tzv9Al77GIQypmLlRiVr2hvWgxgx14FPY0pjAZ90i78melyjFJ1?=
 =?us-ascii?Q?mDnII4XtmyRT3bLMULWkyJNy5lh5wvd9R895nCXjdeS+CkPW+dnVXOUYP2z0?=
 =?us-ascii?Q?9AN6KEpsBeOIcCfK3dm2eX4wWHjvvriPRPznFAmr5npjOf1M+y65rR/AcHCF?=
 =?us-ascii?Q?kgCIY3hcKHMjKBDLMJBTowmwTwrdYVLI3Gieb+4lfs7x6+bc9qONSs+vGOtq?=
 =?us-ascii?Q?mzrBbyQF+8xfhng5BRU0vf5FXlnnjvbd4tl1uaDGiq/tb7fSqK7MVNsLwX1K?=
 =?us-ascii?Q?Om2IWIAtUKedoMK0oOJyowyS5KyvGa7rJvv/RlPMFQ8pVHxHv/EkcS2DAYpJ?=
 =?us-ascii?Q?z17MCgthtOqM/dOUZQhmiLILUXQAFp/fRKMGboLNYvMdM6T0wxrhsNhTjgw9?=
 =?us-ascii?Q?YFe0TVyO+ZfOIQbTZ1XBlJ1t57sSR9g6oCFgiUlp8X+lY6gzzR4DXcs69UVB?=
 =?us-ascii?Q?jxEqaHyJBx2ucl/zML26om+ZU3cDN7zvoQqt5ptObOMuZ6ui93Gjn0PL46H+?=
 =?us-ascii?Q?436FATBW/AVZu8ik1/aXRcEfTnWGHTSIiZIpTpLK5h3UUwvYgeT6sztn1O/X?=
 =?us-ascii?Q?RsThrKEXSx6gPc/zT3bPOPTBRVDeUqV9hwmUV1z/JFO5/Odte6BxkS3J26+S?=
 =?us-ascii?Q?XxoXUZlLTQzzunDmawc3c0r/W782as6k9eCPCA+xlGgPyUd3jWY9jikAWJLs?=
 =?us-ascii?Q?O7ZFvIDmSs4eb+PMVJyXHhVjQseVf8usFQlC1bT+f2Z4o/rExUKS1DQwsmsd?=
 =?us-ascii?Q?m58hUJoQVPDWFAotKlLhxTpHp2nhxFk+Sav0gQVTFubXc6VzHfE2CcsTxP8F?=
 =?us-ascii?Q?a1T0wPKz2VVgddDZHBUZrpZYxp90/FCt7MWJTd3FlHmPlVnheRU/Of9q2o2t?=
 =?us-ascii?Q?wOuNqsrt0CUFRbHc/BoPEAUWKYRxnfPQMSI2hC7r+4chHDTa44xCOQSr0sv/?=
 =?us-ascii?Q?jD689ediYq1KVXqfaOW6mg9+7Kwk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jne4fgR1wf+cgsCcd4ETHzKnckLlz/ksUJMvyqQ7G9vybcism45vDmbnJVVL?=
 =?us-ascii?Q?9urTCnsQRMWtq16E6Pz6AQn7TuPeFUVoom0k9YpBnOLAy4vW5BNHSZtkJXSs?=
 =?us-ascii?Q?mVywnq3IOw3ZviCJodjS4YFwaKXHr5YGqQ8Xxqq2un7xJbxnEpj8YrH2Jdox?=
 =?us-ascii?Q?buGQdY7yiWi4hSbVa/6R+NXx+L7JllnGeyDUBuCk1cqnyM//Zhog4Lc2MpwM?=
 =?us-ascii?Q?st3cUyP2smmhVCBqLryYzZiSaxm6QdNACOLKCzBDaAxBWasaSNWM0ncZJuvF?=
 =?us-ascii?Q?gkrtYg7w7pqQgpJ8h5z+NXpuUPvtKToHSG8Mkvv6LrmgqYqJgYYgCWYNTOeR?=
 =?us-ascii?Q?tKpazzLhpdRIYzU3ZPz0P242EzMb0HpQ4D+KH7AIlxHbeGNw4jaY7Y0sJzHF?=
 =?us-ascii?Q?Ga1qaWcdGzp6MuDr5XC5hsQV5dQ1k4cXKDpEFSnFz/Wn8WcK2xj2ujdxVbdS?=
 =?us-ascii?Q?b9TgcCh9zfBhKjZoUA34e7vaaNtcEvjOSB7kpw+ZMCIIG3LuzTWksX2emNSL?=
 =?us-ascii?Q?8ooLdD93R5fi/MWDEaxmJ3nbzc/BXkD4mamiQd93cirNvMcSnBqYT7bXeopD?=
 =?us-ascii?Q?SOjDfl0dNdUQvBB7/yx+7WkLj97Qrei9bqB3Dh8QzQeZadR/d37M/ck0fpeC?=
 =?us-ascii?Q?OMQvei2z5Ro3rO5+WhvZM7C+YilZ8VjHYFLPvsbSHihrd60KOAr9r593AGWC?=
 =?us-ascii?Q?RyJa0WoYm8zxgdFKdbM4Zw7RiLugcS6fLX3e+GvOFGJQX+S9KFBWsRkH8vS2?=
 =?us-ascii?Q?FwK6pOSsIhJcbG8M4ptHfv5oDdzS0Ahkk7iQrh4dUyt/gZlVWQRkwVamhvLo?=
 =?us-ascii?Q?/GOiQZyh9sP0kcpq0PCqAIs8PVWm52Ytjs+i6LwKnxTx6s+GBD1zMg+RRbE9?=
 =?us-ascii?Q?iu+1ELm9MT+YcJJMLmHYC9lCCxttseRJyM/Zxk9kVj3vX1XUZCnVj6F9XIxb?=
 =?us-ascii?Q?rnxxZ4OLj9mS5508sjnynLzxVwyKg5cbfF6Q07KWAO0TQJO97iP12RZo3qz0?=
 =?us-ascii?Q?Us6k+0SpLAlRavYvB5IXBzt3buSmNMO9JFQjXVuPCaCebTSqec14ic+L2Xob?=
 =?us-ascii?Q?YeFGiMOM6Pp7M0HT8e/n8VCwtNZWYahPXVdLcoYFIufhJ9/lNwD69VA0lk7y?=
 =?us-ascii?Q?YuOVP0aZmMdaMHQUfXs27BFnTQ3twuMYPusBXBgnaS7EbrA06utJwpPCI7GO?=
 =?us-ascii?Q?VPMVI8gex9WjHAzZfFm7luTjHflx6MEIXgWnTQmojuf/lTXgHR08SfZusJK+?=
 =?us-ascii?Q?DR4JP3VG/v2Q6GjWamF48sRfTpZPrjGjS6YRDyfF73eglJLfcTdIBYPJP18W?=
 =?us-ascii?Q?7zHuR5Inzz1nTU3JpQl3GZDjpdRlHvlJYNj1MgmoC9nfZQhaeQdmu5mpbuQj?=
 =?us-ascii?Q?/xkM8su2lB4Ul1FrjUs0kJze3NpteJEgqy/WKkm6+GjUCuDi9DidPMeHeGBt?=
 =?us-ascii?Q?bbd8KZ8rofMOnUNTM8iChe+q3GkB2VrMj5dDAnX3rzIijMt8gcVPm3SKi570?=
 =?us-ascii?Q?mwKBMdReb08xnj14G2IOOB6XF7U+E42OnMSX84DjtPPuiAEbYDmFEb9iA0nE?=
 =?us-ascii?Q?ACr1VRG2r4SOGoqoIcs7hqm9wDA9H/vR6VmoftDwR8RJvsgc01RQhyNS/cl4?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s+DieEvwOZFhJyiqbXn/G86ndPq4iB6p8jL0BuYrGALZSMKL12GibS9P4AIQ9Zwig6CK9u0QNZN87O+NvFNZzR6eviPt3KI2eDfUtsCZrEekToDP+2o1XluKRRUksEHA4Hr9aePl/8teIsCcv83ZvoOt1h521Q7tgwmMQwrTzzu2clgCOhL7KFvlh2XtCVjjzK/0uf9ahhYhAw0NTsFfm9o3+Kpfuxh+bVWjTTdEOyrjYk+9E7sRPIZ6TTLRSHRHo1AgVgj66TCLxz8MOOK+7luyMscwHngn5O/4SFn89dwXaJsLC7ufpuGyBcwVBkI6S+5a9zIMDrU8rlSG3xRbJHxJK0nd+x1fr92mKQ1jtXFHHTQ9vQ9oqoQoMX+pH6Q8uhlqTukUanm7jMo8U9AMVSuN7X65MdBJ+qAGCJmwznuARwZl+DieXekMM7Wh4MyLwUv/9IpMZZGW/zPS3DS82x436z/wto+LBYEbbguUbk2HYuugtjznhTAaSl9Etcfjxevu9M/VTrtKe+uQf/HFdz4+9r6WUd3DU9fwZNaesU8uGd27pKKWdwXJ2DlPcL11EfGlBd071g6mgW+/oVt9bc9fJEUv/B/bL5El6poGgwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9642bec5-1565-49e9-288d-08dd3a3f5d5c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 17:16:38.1361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqXqL/ZFQeYxTyqOgo42wfeVuI8dTKHPVLO6SKIw3UV8qdJG3YuT9RmXXZ8SEhLoTyOD7NnPG7Zjj4dOsrj+rretpk0rVhPfw5t7QcNolnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB7993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_07,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=820 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501210138
X-Proofpoint-GUID: R8fNorfkCprVOczuXBQXnuDC80nHXfmj
X-Proofpoint-ORIG-GUID: R8fNorfkCprVOczuXBQXnuDC80nHXfmj


Mike,

> This patch adds scsi_check_passthrough tests for the cases where a
> command completes successfully and when the command failed but the
> caller did not pass in a list of failures.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
