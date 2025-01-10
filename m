Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19FE207DFD
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 23:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550260; cv=fail; b=WNulnz/P+AFTb/tXz63/s3oNJ2dhg2RrXm63mfveHcu+lihkanyGW85m6uzJv+HpYjYnIM7+mZ7H8m3iZJfg5/Txit412SjdHxotRztrQ1EgvxKJBOsenezjvPHBis1/6NAgTImGH8QJMKTrMllkthYKFcghaVEfgtFnrgIktBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550260; c=relaxed/simple;
	bh=ocHHkawD9iVuKkV6a/n0aXa+kmQtj9LAoL4ACuiT+Xo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jcVj4L8iX+lQA2hfrMEtX+W5iDoIQJE3KnTtsFMlmSmDZaQGd74KOLfjWgYCSmbZvB6pqtJYsEHZ2217rFxGnquxAyVCgdTRggnwnhPtoSFyUOQClmrMVyq3W0cIAs+QdoFce6JKG0SLRLwAvyMkftLr0Lmg8dGmbDY6JK70Z4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HeJ5D/L1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sjfPOcVk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HeJ5D/L1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sjfPOcVk"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBoaS022213;
	Fri, 10 Jan 2025 23:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=icqkEcOnxEJsGX2wCc
	Gdvq49bSC7ipcuKJAwhIvFUXk=; b=HeJ5D/L1RCLmpdiMOlyFHxctDBGDl+mZfq
	0XRSsd+XuKxfnYplUMQgvGNQEi3EtrfnxL49A6AFirdV9vOMMc17a8hKlxRby0qQ
	z2f4AQkc1iTgXwk4AAKobC9nmJ4MlzFYl3d2hkOiXITgJVwbUg/5iFkA7QKkBFJW
	mH1/sEGMWgrigOJRqyJ0cEoybPsWo3TaHdtydtVsEfZNiZbdbyUeyshQkMA4uf6E
	5fxpPQ1gFzKZ+dc8+rmKlHrVC8MoNiL7QVLKffOU9euw7WcrQjsjf7eQHgdpdWqr
	NmLkT3MsoVnVvCcqSidqvJKQFIDCCconQ8MF5cfzZusAlJoM1scg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc59r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:03:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AM0FwE027471;
	Fri, 10 Jan 2025 23:03:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued8ptm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:03:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKp5SlRA2NrsFmmSDvJc4V9Q6YXBopJUyxekx2xLWE2s7ScXDrnCpXHr5/qTA6uT49HzIAR6H0sM8WHz1vOts6a1qg2Q273/hZfsLDwL0AVUyAEmFj5dc90oaa4qehPa6QsGtPxETWXHTkbk9OpVjm6RGfN6wY9L9E5HHrNVW6KqOxfOrcBVZo3Z+B0kwzkTj9MNsUp7vo0d5k+RqOrJBe7qJpyh3dzcYU1rimnzfeh2HtUuU2sG8SjPpoOhDfpbzYLkRrStTyJ2+e4KD+R/JJ3IgGSr6Kdylpc+wHfCUXXpQ1SEtoTeSeBYS0WT0JcnuxSfEkvci5XCKpVYSQifRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icqkEcOnxEJsGX2wCcGdvq49bSC7ipcuKJAwhIvFUXk=;
 b=mYCj1MyrU+7uUQNuCYls3u/VdhyJcB7Boe5oXKqut1WyKIZle4Skz7vi9Mb14WpZTWI/27zY9iYmixwCD4QdqE0lgueYtGu3kaJzyfyBckEmfdcampufRkd8VtnAD/NKJ9MctoUPhteEyKeBv1AQnPsX0gXwS9gjPZo60GJIr8ufXck5kIMyJvr99m4ob83Kmmyu57LR/FCzu8XZrrkdDTQP7tPJC9bB86RFuo/fHSVQW1e2VNXI45CB/Z94rDi7/jUhG9QziHnRBNXHVjrb9j7htDwHZjIBxoy0gUAiysQNzzMXB37cQfgQ7UCkjQVbARLWhKbp6hjaJyXFWDxPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icqkEcOnxEJsGX2wCcGdvq49bSC7ipcuKJAwhIvFUXk=;
 b=sjfPOcVk6opAGSNT+CyrkRqG1xiBAEjTI6dcLnq8PigqaJmGf7wAQowo4bjQy1LLFZJ6HvKzQPxdRgDSe+KUqxvpgE2z88KQYu+0hDmwqW7jPrzyq5azMY44KvFiW4ca6PO6Q3q+lGgpzrK+2PY3d3Gb3hxrPobDbVGjEyE4L+c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 23:03:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 23:03:53 +0000
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E .
 J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix some bsg related bugs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241218014214.64533-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Wed, 18 Dec 2024 09:42:12 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jzb246gg.fsf@ca-mkp.ca.oracle.com>
References: <20241218014214.64533-1-kanie@linux.alibaba.com>
Date: Fri, 10 Jan 2025 18:03:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:52c::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4784:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb07e16-47ca-46fd-87d3-08dd31cb0dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mr1XDK7pKhO4ax5GHNhMCKSaEPaRp2UbrnC7lpN5oGpoCR0N8hvNBNYqO1wU?=
 =?us-ascii?Q?YNvqUoqM898AN/78j6tRD/BQ42Vhk8KcHWJNyk+NzsbQaQD36nX4BlrE2Czd?=
 =?us-ascii?Q?BOciEsGbWvJZawqtm6z8Qh7LZdHUKGbaoi2oBXdBInUKeTNbbg93ziyx/Jnj?=
 =?us-ascii?Q?SbwgGX2lrqKofXjLKZCElHcna/PpEI/rbGh1zEZkrOIEyIaL4F0il3Pxnnjt?=
 =?us-ascii?Q?t56HWTRrCqdIDZJWYKWvZywxaRLgwVy5sDwKHrzocjBwbQnvIdg36zgtJBkl?=
 =?us-ascii?Q?8WQDFDGFBwu4d0J4CZFpAGJLfxsCW1YBSMp63M9JF4e16deAL3LVAyEpCaEo?=
 =?us-ascii?Q?BipA6Mogrx5IrPWsJ61u9wPIZ7aRAB7l9TnWkVwNsz/X10964n/evmgoNfeb?=
 =?us-ascii?Q?z171F4OsxGcT93Gfi2CTeh/bclkmXpGDkHjHzwTQhqNQEdXKHoVN+NOXMdPk?=
 =?us-ascii?Q?NiLzTAVxAE/LpRcFQAUUlZk/4gRNsXOPDD93m+o7uI8pYCRrUDQ3zFhBXBFt?=
 =?us-ascii?Q?F0n7ADap2nz3ySfgM0qvfKYQYmIIhjh2ixx2tHz8psF3oG/iw0pIr4ui8kb5?=
 =?us-ascii?Q?9ZX7VRlzuKdTddYQHKqjS53ZWOub5DMnB/bkjk8vfPV1lxx7T/dxNr5TdVko?=
 =?us-ascii?Q?6v7WdQAHXGOeOTkMp8IDIQhp6RXo4EWpG2/LZ10G2FHy8wtorAR+olFH3afb?=
 =?us-ascii?Q?m7UgtXp5esRbC1EFO2jFs1GLFba0trhvsS1jwwKpIbh9U3Ij1imW5oS3PKZI?=
 =?us-ascii?Q?donddTXFN/GlX7BlTMWiX26uPniUceEWI7bJLm4cgzJ61IWUq6+uWSqPaG6Y?=
 =?us-ascii?Q?QC3/S5boAv5zszR5RBt7CVkKGIZqAg5rYy/hff+Nl8ydo1AivX6u/uVig8qH?=
 =?us-ascii?Q?tGo+y7g78xZ5z/2dbJ8fOunqxXXelQE3Yk1s5LoByKcY7f3cfaJ3H/3p5YkC?=
 =?us-ascii?Q?BNvatcu3OwLV2RHs6zRj8WwpY4VxDcO8DHE1zQtofhvAN+dlhn3RzyAeYM15?=
 =?us-ascii?Q?v8i6lhK0PuwgHHWwh8ZEzXLPLYnNu+gVS3pgaZT0rf7baWHcNkgBNx5jmfW+?=
 =?us-ascii?Q?rS817I6w5auxYmy5HRTC7BgHJcR39w0sDFwRNgADRK29BNZu4N9SlAFFX7bJ?=
 =?us-ascii?Q?s4V3z4uA3tTjRDs4zfBOIlBAes4S9VsPRNOZYXsi9KQUpjgDWX4U6C1KWKRu?=
 =?us-ascii?Q?Df+xbb82ZTe4GrkhCgH+jcz/KcR6Y2cDO8E8mM44S4YmlQmjxIlGQkWCihmM?=
 =?us-ascii?Q?NfpjqFOc11NuHTlVVDBwpsrUeQu+w2qWN/Npl68+mXLAvKl8j6W13I3ZxBEj?=
 =?us-ascii?Q?ucnCY0i8tN/stbzwx2oohodkz58k94gBLiehe5CTGPdQMem2mBqlisGolbUs?=
 =?us-ascii?Q?3JH97BIhIUHYFDGdkjt//TpzkmFd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1vJJNgV5g6bhg3N57+MagTSFVLz6rCl5/J//18zsOKQ0kHtSimCcglOJtz+h?=
 =?us-ascii?Q?qPcGZxUZS6O1/J7h/fWhyPZ5vJDCxPs23Re6fUkLCNmg8tr57R8cEC9coii8?=
 =?us-ascii?Q?UHG68ITyDqYCu5Rp3WTNCLESNmU+ihka1F+KB1z03C24df6ZqB7Ar2eb6cFf?=
 =?us-ascii?Q?jC8rqaWv6okPQgVUkabbPteAHufqcr0WvXdhBLtVnN07Q0WExUPWmz639ONR?=
 =?us-ascii?Q?k8A16rEEueKo/4xXWRtoyn3EdCshRRKcVZs6AUiSmzZ7SLdvtZ60DH1N+eRL?=
 =?us-ascii?Q?FCQ+CJ2uINbF37KzoGJjbwul2+JEymIDvuhUqFQMQ0nxOebwprmFrW2Bhr6E?=
 =?us-ascii?Q?As9CyG+5N3dd5XfCZ1S0ZD+UdaS0AChk7W9S7kwOu2S86Og9MJJzsvC+kepU?=
 =?us-ascii?Q?bUdLLwcyn/qBVNQhe3WCMqzIZOXIrKxr/orIhRl0/BSSgM9rOqwKEsQ5zphs?=
 =?us-ascii?Q?1ZE8eIoPxDgd3lTc6AFDhtVCsbqET7imSeDggrR82xCjeNXjAy8FR9yeeedY?=
 =?us-ascii?Q?UzZDz0CWFp9cL4SqeVbnKCUw20uZfq1udGgL1nJtLnWb1F6Jsf3Z5OowqMxd?=
 =?us-ascii?Q?2WbWF2AJKCSwwm0h8lwMFWYWpx8QXItmd8Wr4MZnhIJyYDCURHMRnXkM02pM?=
 =?us-ascii?Q?yiwCH8ToILMP9dL5G+m5/RyliW1VdWExlmhBMaxRY+HAn8ytoeaqk1ExpSL7?=
 =?us-ascii?Q?KXYtqtaB62K0bq4Uq7M0XSf5U73yzg40tninggoBmxhPwW2+Y3cP0iS72HXd?=
 =?us-ascii?Q?PTzXFFVwqwDgUxh6F9MEpGP9xLoN8x9fPuP6NLHSd8d8lQgzp8t8B5TtG1qg?=
 =?us-ascii?Q?/i0/LjoZGR76UbLgO2LX1i4HDF5osz5LufJRLjQUqZLS90QDsREMDcHVzVhi?=
 =?us-ascii?Q?lsPHyg/tTuqX4M4+bggrTn+VHenmjif9jGN+vXglgD26GMQANhs+QkXULukO?=
 =?us-ascii?Q?QdlclDvVR0u9c43H7LIXCTHRAwg1egGeffzfX/n1abYLDBLGZAHpLcgDDmTx?=
 =?us-ascii?Q?YWvyxEBSoxLXpGNoCM+qbbw/NxAHG4rIBRqjtJMSU4NNYKg/Ee/YJ8LR9E3g?=
 =?us-ascii?Q?z1NrEwzE3BCn7h2YcB2rFe0DpOyeT3+gdZ07JMBWjlyxfef6CY1VN+vXXNwo?=
 =?us-ascii?Q?C/4G31+ybisPh1xWgC3Mnu9bSwg/tfMAEtltJ25IWprJHoSVw8/feMf3dBGi?=
 =?us-ascii?Q?Inh6rQqT9sBKvfxv3IvpC4hqUlXza4U/FAKcZaurPwv0kyYksvu9SX2NNOzX?=
 =?us-ascii?Q?6aUcvfig9DZgy+hohF12nzXk1FB4GB06GTWvZnwpLVo84vzkolV9IzUJNwd5?=
 =?us-ascii?Q?3qf8oO6+lIU0sbtP2NHR/r9abVj0b2BMelEd9VtDsR1Lqs5mbBZ5MuTJtYSn?=
 =?us-ascii?Q?6hIPKYeZraKK0v5oBrVwlRqWhySQvVij+SfE3YlFxCmYLagaC4oBxs5o/igg?=
 =?us-ascii?Q?7Ay+GqVZ3wXnXG50tINSE87PvhNRU83LNvbaXIw0RJlM9Kx0XL2r5qtjAvY6?=
 =?us-ascii?Q?nkPWDQFm9kNtukMUqvPU6dKoKeED09Sbd2eFzaCmteZ32vwfwKdy9rAkEGzs?=
 =?us-ascii?Q?qrJbZew52KXjEWGGSYLvoRv8PhgRSlDIH/pEkmcTWsjEw+gQk2FIPQPx8Yvd?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tRhYjz+RIPQKVOMTvOON54YqwMOehx3H0D239jBaI2EzRIF+MyYHs2gVmEZh8tojiHXoEI8N219GiedwK8FyZZhBWIHWhw7GhvDJJUkYoXkYm5oHs3SwvpPcIkHNkXx+Xw0qQuEmbdFJWypA9d0ISG7bvAYQa5OnXBdJ2cDILaTKMmuwG0ML61yKPV6rfKHi+pBs8qvmRcnvxX7Xa0Pwi+RqOQn+lHoMHXrppFRx0l7fLrlMvw3HhjGMNPKVGeRymrP30EVgv8Tw3cgybnJ/HiLPv7fvTk8ck5Em62jsBg/0KdUdIuNUosCxX+RoFVVwR5Wp2gv7xMgPV6WvBuiwjcV9+bzTTiLS973RkpdI4w49FbjMrCOE7b9WpuTEnK+/scoCmK2ZpuHArjjcz4UwyNG3O0oFX0L3gfvDv6NaIph6chKRPQX8lM0n99Jmw6GalFoucqum5gzD+5wuB+CIvcIuwVfPOd1yuuOL4vvwiqge8iAjxgR7twr5Md2Pw5Z37yHTPbYOZmhaU2cjLRTJnRG6D4xQaz4sjXJI7Ta2B6PQfjSPhuCj4lK7Y8VvCkOXLXk/LGu2Tx/urkqhnISQPmKd/lZfXKRqu29kYOsVQZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb07e16-47ca-46fd-87d3-08dd31cb0dd4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 23:03:53.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgyb5ZcIveNdnH5hcas8HqJpo8X68HS6QQfLWggnjQgIEZ890qX1zVWJb2oE2z7J2ySXOmljRc32bV8ugM5RjGHUt+J/AZCqeVBXCFztGxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_10,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=598 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100177
X-Proofpoint-ORIG-GUID: QfrWOuko-Xw7Si2p_U94GLJGCllqemQW
X-Proofpoint-GUID: QfrWOuko-Xw7Si2p_U94GLJGCllqemQW


Guixin,

> Guixin Liu (2):
>   scsi: ufs: delete bsg_dev when setup bsg fail
>   scsi: ufs: set bsg_queue to NULL after remove

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
