Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856878F24
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 03:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739416343; cv=fail; b=dwLs/txuFPixWvUW3CVsj1R2rb3rnLfu/KJJMxKEbdYuKKr/qWAOcirXeZ5HjB44oersLDcjTWYP2YX5gqy/xzXxRMlpF113J2inrX2OaP3aIOOSTysSmQxbeeAKCd53lVEmt5dC0l4DMINlRDL1ybX31rmSxCXsEDvat6hKruc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739416343; c=relaxed/simple;
	bh=WAnOzai0rTlGamvFp3lK8EZgWP2GsC+S15HDKKFIHGo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kFrknx9oRsfUn85s2fQL0EIA8Pk2eZp8fskEM937wbo/9wD6PJte4q4AAAEC8kQ2p/kBCrp/lolWsVuukajgSrytPRnVfQrmE6aG/x+ZCmEuxiz1gpwBqIxZWSvXrQoTWfzwzE0yf9B12/SZYayefnIFxG3f4vR4/LqisqvoK14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y7Ak7I2s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pob1bPAF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y7Ak7I2s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pob1bPAF"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pcH7012456;
	Thu, 13 Feb 2025 03:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MtPHiYAZBV/EN45wop
	Ha1UEsRmkcxM0yloJu8/ZETK4=; b=Y7Ak7I2szd+tGULXdPG5Zb03QoLizustQn
	zBRRJU1krPzH8g5LnBfj5PkPRzv7Q6RPgPM1UsulACsgkUVy3k73OWoub8rZwOw1
	nVF4I3InVf/uRvb7HnBcx8VVQpGpQT66lWKJuuFaUPI/WpjSQtnLB06XGbtBKzqS
	Z25Rhx3d7ELQOgwosV7UJyStphPAaXe9rttcRE39sZ4LryQfqOCEz90fdCZGniAP
	ZV6FE8HaYPn48SEJ1ItjPgTueREGQZrvSOEEu1xoYGtVLMX/wGCyYOkWXaxXibAD
	VMrFEoQpGsCP//I3LAPamqdgFc5j+a4qaWrw83Y1KIiqEr11AgeQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qagq47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:12:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D2KNHM002590;
	Thu, 13 Feb 2025 03:12:04 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb63f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mg8yZmkDf4v8mexlwWkRQsfmMMuP0Q7LpP5Vx17HsYAJ8HYVC3Cac8/XHwxxYVC9JXyWyZJ6AkeCH0YiaT9glC3RiRhQyIA/r0fm12iWI0ukDaLY1XKb59tAXVbClk3JFht/OkwycIB8iqjYreClPGDmcwZGwSuLaQeM17UviFK947kQ4HmgDSw3nEcvi9TxadVuR6TLOrxvn2fIc3BbMy42F7AU02DpYpCXROLPKkv+Go2Olt8DQuX+fe5IRMU85fkabkiH+y2pc0RXE20KlyP3SCAeID0AZs1LJGtrwu6jz1jDk2ed6wj5pZIMpnqFckcK3S0lGu+QJBsI8Fn9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtPHiYAZBV/EN45wopHa1UEsRmkcxM0yloJu8/ZETK4=;
 b=QgO+Ot1+whN4tN8vVXBQoRAu8g/Y90Pv1O7ALy/lsgafYV1lgQzNFl8bDJUIOsUJAgt3W4LC3syYDJ124zrw28YjENCKp/GQhOK1SJq9Cbn7DhISpg817S4GmLIumGeiWl2swu7eDI7y912Pjrsr48cMf4+KEfqt40ZMNoJardUmxSrdgKYC8mxnh6G11NLoc4KcCc2T3eyERXt3jvJkgNUFw8RzQXcmMaKIG0dtJXxryU5hetuIMvREAvlgGKQ5u+X3e6fRYTE/Wl+KSltuBMke5ekSd7W1E6NeuYoFtbY/5THbSxheJLO+Kj8QZ5W6qx+igSaDoUAw1bPcyeqkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtPHiYAZBV/EN45wopHa1UEsRmkcxM0yloJu8/ZETK4=;
 b=pob1bPAFhPmdNwx9G52RyhZsfd+tnGZgoB3TxvbuYJ3SgdrBLzfR3pg5QQZclx0wetDPBihtnI4XsPLZpdXVP/4SWpQL2WHKNiqCcfTxQRhyCUxaez21A49VfHqVi2d2a7JZMlGNQbPzdP3hrb3hIPIisrzYWMeAtPjYGbR+Aik=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 03:12:01 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:12:01 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH v1b 2/7] scsi: scsi_debug: Add READ BLOCK LIMITS and
 modify LOAD for tapes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250211141132.3532-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Tue, 11 Feb 2025 16:11:31
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jz9uv8w9.fsf@ca-mkp.ca.oracle.com>
References: <20250210191232.185207-3-Kai.Makisara@kolumbus.fi>
	<20250211141132.3532-1-Kai.Makisara@kolumbus.fi>
Date: Wed, 12 Feb 2025 22:11:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 847c47b0-fd63-42af-f0cf-08dd4bdc2edc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HPWBm45/CxavR2kKXkZ29y+EEFXLO4trXkCR1tE2UPhTCFWGklK5GXt4V7Re?=
 =?us-ascii?Q?2a50EZk1q1jm2ZEMQIjrrdk47OcetC5SLLwzfxI3qNrXUYPXhWsJ5OXorCHQ?=
 =?us-ascii?Q?VIMv7ErILNPec5LEIXvgHe9KqMNaA1EsBMWZ0qAVUVpR+u9/HMgm8fYXRUFf?=
 =?us-ascii?Q?4Tm7A+W26VsdvEQbR+L9aeoq2NR2/vBUT7IMmfCyAanZMxo4zZcV5Xu34Nu/?=
 =?us-ascii?Q?eQKzVYyg7mpgoxi7M0W5fZdoSwlW3xIblKcEpnHtH5CwYlnd9ZWN+xIgMcw+?=
 =?us-ascii?Q?79pGwcC/beaKtqzDdGUVK3hw2xIfHxD3NzFS4Ikr7xlZ4UtUSW/6w4AFXniD?=
 =?us-ascii?Q?cvIW0Ce+z2lwVwQy//iBJ5AlBQpjpsLXk6FE3MOTDWCn2TykEeo+29t1p0Zm?=
 =?us-ascii?Q?Ip+ZypxwLDs0de/46CJgArwtODDEVlPvng3hVWfuJfTeKi0sRA3Y/L4ePJYy?=
 =?us-ascii?Q?MM77GM4ptcFwwgruoheTJ/+ws9splH7FbnAE1AR+p3sNNG6uVuMfnbeGEmRb?=
 =?us-ascii?Q?cfuiZGHyxvFVRn4Q74Z+R8o6GvC7pMHnuhNmqUddctybsGOrT+Z6aNHSCWo1?=
 =?us-ascii?Q?VPE4vngs5/fq2Gz3fsVyH6BkQnXSjilLHNZ69boD87LbGlAYdQ/TPBM5xDB9?=
 =?us-ascii?Q?xl7eSx++EeY149QbZTi10UYRf8U/ab6T4TcWLR7hqXPn6wDne5uHKqTRAeZA?=
 =?us-ascii?Q?5ILXuILvxqwHZpvwHk9DyVQsoSyXYk+Tt0waQcjBGag2M67M/7tJtxYTOjpE?=
 =?us-ascii?Q?OLksd4oM2zyhTBRzHjrMVWaTxgubLVtMbPVWHfdCtTkQ2K1VUfqUL9itt/Lg?=
 =?us-ascii?Q?A73k3P2Mj9m6GJwUv6PnSK+fiW8b0nRZFMqEh57LW26s7znIdGPjWGPZ7zva?=
 =?us-ascii?Q?hpAGVU6+QccO1PUGTwR7GWmRMVxbE4eebwqBj+UyQEPE5uk6PPovwEk3mzaD?=
 =?us-ascii?Q?bUqtUFew+zBLaJcnii3e9OgSLCmSIQnH7mXjjqTILWUPPDDE6oN+gVDl1fHb?=
 =?us-ascii?Q?slKMlQL67cofrElsx9LxasG+XiIye5hwI8K0hmeOvNB6lkFUsBN8F0NRqWRt?=
 =?us-ascii?Q?eIq8Mz+Jki62Sz/UllMbuclGiZPtXzqjrhXiJE6zxrI8ovieYfL2FBrfF+dH?=
 =?us-ascii?Q?f083vaYnXwzLy7fcTR6mS6MYCEu0wdfsZkeqpHRKXkLyNB8ym/IwZEgTpznH?=
 =?us-ascii?Q?uY67JXmHFuxpqEMIwhZIZmEr72UpkGy03h4UfubZD6EqpQ7I8u+hA+Au4mA0?=
 =?us-ascii?Q?P+wo7npago4wR4Oh/Y7Ab4nt7kH2vlIvm1YRILjmxi24G1kPEuQPh7WlSHVT?=
 =?us-ascii?Q?tDXMqHBpcl+tnATHbUx8sJcZtbt7CPRK9sT25DzkHnNIX15ASbOkp4gp3yGR?=
 =?us-ascii?Q?/r84wrsDHgUG62aMHX8BGa5UUt/R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d8Al0qGcyws5ffojngg1gNGXRE8h+Ls7NDOh/ip2WdJKtHdi1dzFhrFI7/EZ?=
 =?us-ascii?Q?zdpWN8y76pLVXNzfDEykdjYfYm6eyP0++8cwKLGJoRf9YzklaX4JLL/lkvWZ?=
 =?us-ascii?Q?hHH0YFtyctwikIOzTgCZWB04QVEeMJPihgH8+hkaKerp1kowzRNo/lOtIUKv?=
 =?us-ascii?Q?1cjS03nX1uV6AaxC+fKRg5n2L71jOmea8n2OWQcLLn0Ogg61MOGXo7l6hukF?=
 =?us-ascii?Q?RuFmqpxA9YElJw6DF8JXRqT1I6O/dd6x51aIyGWgkhkg0LvG6/pK9nfNHykO?=
 =?us-ascii?Q?eaRR0IIqH00IpCst1xNz3wvPxqcq3lq+jAxVQnBW+/NNVuXqqojDdPCxrY2v?=
 =?us-ascii?Q?93k29UCv7P/4S/uI10a+RqlwVtbZhGm+HDjt/YnpPLhG34RrR3qtC0p0Y+Ag?=
 =?us-ascii?Q?oVuY/cuFmuX3EO/fsuZNcAxrEmZxnyD08pqSgDEbhW4LK8Top3LWQJ7WZsXw?=
 =?us-ascii?Q?/e7kVBc1I4kEFHa9L6cv6mmXOWCOrwu9xuthhQQ6ldD6szqUGBwnjt7/2SBc?=
 =?us-ascii?Q?sAzbyRxycONlVd62V0HkKC2kQjfVBRh8wbt02FpnGC0ysGeAzrzyF5vJfV5r?=
 =?us-ascii?Q?q9vQie87boOGJTMpR963xOOvkJjwkdH3j+K1dA241+GnqSDlVhDxr0iGzSsr?=
 =?us-ascii?Q?1mCbsLtXLesx/pv4BVOQsemVEZhXVRBzxdgAeXNwePk8vYfDx78jPpDjmyT+?=
 =?us-ascii?Q?geWD499g1YudxZUzddyKc+s6Jc/ivdRSCjjIikEF/1wLrMkm2P00dQ3OAx3Y?=
 =?us-ascii?Q?d6IPU8e+VvTX08m25Cwy9ii9ELJYbQaU+/yqkpNsrzSGx5mCEAZNeWSp6dQN?=
 =?us-ascii?Q?sXJzm+C6PRO7U48A+rQa6g9khyocp57xSlfBTZnU9J2M3EtaNk+7V5xHsGOZ?=
 =?us-ascii?Q?Ff4X1gGSRdS4eL8Nllk4nQJ/IXX7JXJo/pYUQ23OvDsDGjFR5wYANJApSJHi?=
 =?us-ascii?Q?rDFQkrC5XBGpMh6jtrvmkaME6mEvdwFPIz5nIVTBN3vkqaOrEgvEweyt7Qyq?=
 =?us-ascii?Q?40+hvOa+5AK+C793kmsNXKWX+HXMi5afEj7RjZHecefer3ZczeePATzphypu?=
 =?us-ascii?Q?kCvCd+afSOY/xF4be/xyQyOvi/idJuM48SQX6W/UKiIw9KLuouGai6HdfhgI?=
 =?us-ascii?Q?XdKiIbE38gg+sruu56ES6WRcqNsxFuDv1ZFXs51nQRBqH3vhlAg53gJfzb8X?=
 =?us-ascii?Q?VbonzdMc2HObe2mX4p6MF5nR/SwL0U2DpEKDTc6Dt+4aeU3fvpYwltTT8sBv?=
 =?us-ascii?Q?Qd2nO9HOaWr+D6b4HPRGnzZ8fK3xkg6Uk+DOL1gUxM+aBjrSNyN7QmNOKDPG?=
 =?us-ascii?Q?R3+LWiFMP6N/+dd5Yce9hYWJE6Wc8bDLWMtc4j3O4P+6hewqHpHN3762pWj0?=
 =?us-ascii?Q?p8a3UTLjKfiJZOaVc62u9aWHRBMNtSb38COVl1PuDaUUMSqnqU3bk0iA1wYP?=
 =?us-ascii?Q?1vmjid/o4GIUyGiFH5661xpTe+huQVqYrxc/RTkihSkwRn17h2DJl05/UAoc?=
 =?us-ascii?Q?FIZheomJE21elmsxKcH9Klz0FemcLQznYkF7FpsfZ0RifPomsHp8NC+2fIcu?=
 =?us-ascii?Q?FRR0Vr8QdrTSMO9ZtsCzTQQiF6Mrd+4ztZpm0vF/sfTxVrWDLSQmdeGWTiNi?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jk9OphVENLX8v6O0fAVqWFCoUOkenMuZSBrv7fW88lVSCzs2Cq+NrGVcV9GuHDxxbGNbSceYR6EJp1ltV3wNS4IV6PyesHI5em/a9CzneRWAq4ipoRmshp1SkxOaHLi5MZ30/NxBRPbcmU9zcr1AoObQIsA5M+fDAYTnGo90GdfHmqR65msn/K7TwVou338h/c9DMHzXoK7FJzyAJDf6hLtcBfVpfog4vyr4NIZloOXk/1ZjHzn38uxNtdFylKnbfaPSBHoEpYaXXgBQAxxWtUZLkAs8rt4ScvZFrNK0ENcYpbogcfvterIOrBNu9R2wO7E4ZFpB1pwvrKgm0yyOXkj1VvjPxe4zQZWCT9VFoChdHoO3jbULB/SySGjH1kMP5kvVyIq2zG3EzfLr1rVsiyNVGCaSeyku83YdyenCC3gzFQ8iiOwaZKzYQiOJ7txLjF9t6V6vMg/fVJP/t0c4uqteEoEM9t3mg3LKUoGMRdtjmG50h5/Qknj/lWIOcDCnlpTKtJbL7ZoeYD+YxH+YboSJBMnO0lZEfcf36GY0oneLhIo3/MHDmK687GfaoRbUtiFrUUX+b/TL77OSaaxz/Khwzg/NDs0XP/fvN3FuTEk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847c47b0-fd63-42af-f0cf-08dd4bdc2edc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:12:00.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EwwOi1EKDGX+Y9QQkm4xdTrd+XLumHMfrQyzYKQe+fxEwUtC+vu/IkKqjbhETfmOv0AhhCZXY2z2WOYSmvjII+eBNnAiiHL6Mkng0DuVM1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_01,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=939
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502130023
X-Proofpoint-GUID: SOeflKqcG54XeHUfjdGAICVi8p8edREQ
X-Proofpoint-ORIG-GUID: SOeflKqcG54XeHUfjdGAICVi8p8edREQ


Hi Kai!

> The changes:
> - add READ BLOCK LIMITS (512 - 1048576 bytes)
> - make LOAD send New Media UA (not correct by the standard, but
>   makes possible to test also this UA)

Please don't do the "v1b" thing, b4 and patchwork both get confused. I
had to manually stitch your previous series together from several
bundles and it took a long time.

Just repost the entire series as v2 with the necessary changes in place.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
