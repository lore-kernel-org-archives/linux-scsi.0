Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6CC207DFD;
	Fri, 10 Jan 2025 23:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550076; cv=fail; b=aMri52BnvKHhDMDm45fkIb6er9rpEqO8l6VFqHjjLJW13BDYpVvdesd+fBrGQN6SwIPezT6FjeeXoTHTyhnLHofY9KitSH0PJAIHnABanT+xTeezBb6a2TuON58IAqje0GlgLeSs1NFXC/QkHiC+Jw40Rov7LyTXqjo3xKeRraE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550076; c=relaxed/simple;
	bh=+NEVnbaXstorCQZsMUB7uPb1/vlQenrSNSzJliyUlfU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VLVfAjwd34AiY+5r276JVyZduU4axIl5UthGt4VR30BX4k84da7wzYqKzc3toDS3uyXi3UA6/Fjz3n6UmCew4VkNJVaAGB3fOX7ADytiHKrRuq+KPknHHjTVULKaMMZJlpz5EK5MYOOVl3S5Pmi7q0Du1QMVWVsz5gqYEMAZDWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FdhM2AmK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TWYgOpF4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FdhM2AmK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TWYgOpF4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBo03022226;
	Fri, 10 Jan 2025 23:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=8TEM8mYbthOioGNoZ8
	ii0sRU0JOA47hTiEUbBrXPhKU=; b=FdhM2AmKqQcdscf9W+txCskis2LvrSa17X
	bxyjv5JW53xryFBzwnPxfJP9ykypUz+pAjEvQYpSipOT8ol+SVoSUI/ExsBqiSPI
	dF4pI7Jw83nUbNMG+FQpC0uNVAw7MlkA4hUEYQbEqbxsFscFGUntGnA+STu3ig7W
	z9mwGBAyS9KTsKGO04GemR6r0kD29iNyj1KWwB0gzNiOX87GVJl7zWyTaiFYpRwc
	JNlsdpQYt3nXeK0DBfdDR5BydmAvH8x02PHffFvG7BNsHhLQf8htHABRTpDjfzkO
	rIxHyjQRzTFklj7sAktGBNAqNIBFbBvp7vGjehELYLljvp6CsFGw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc53k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:01:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AM8WPw027615;
	Fri, 10 Jan 2025 23:01:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued8kr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDsqDycS1XZWOCjuqpyETlilbFtiCczTOQ4BQTcK5EGJjWrYQjjFPkG5tmOmdKVGj7ry4SgZ6sTgSWce6CALVQU3LWO7H4kHv21M6Xj6v3CAxDABaIjaKMm6skPjqqckq7ltUStl/cJmdraDM6p+QyhgvRfASjWPQCzXwvDB08CA4oUAtUSciZfQs7bW4sT2sTVhnHwc4IJB0QIdTq8BoeohIBIr6fYlfCa+lxBaEENn0kRraxs+5a33rGiYOcdgszn1W8z+ginfCs91ekLZsNCJMkQjE5yFR4kSq/0CxsgBu7j6F+fF+aGxXJPua4PIi2hKNOWaqBaeXP+p9At7Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TEM8mYbthOioGNoZ8ii0sRU0JOA47hTiEUbBrXPhKU=;
 b=llHoxDUY1sfC+EAZRnHHcL1Nyn/LV1EmrBlklIDSeQyGKi1qvyhYbV06XvdVE5TR6J1C9D32s8jWfFPaB4OQfhOV/18DwAPqjo82Zq8Vd4myhMhDs7aZ17nyREbu0QrYFt9mMkXtndSl8++R/Jk/lmT/upzLMXcbhHHYt6Rgs16xPGRQFqlsqlJrkyXtwPQqDbQQGeO8a0z3fUZ1EiNPhHeQrSIfbbaVL7A4c0UEpmeUYO5cDwT8kFwY3mWtx5TwrkGudvwj3H9FyuVbXQyoTH9HiVCk9Z59tSQwN/vurilLdss6B1f2foWOBskojNmsyn0UB4993c8lQ49GaMQ8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TEM8mYbthOioGNoZ8ii0sRU0JOA47hTiEUbBrXPhKU=;
 b=TWYgOpF4bOmSAdq5OWOpYYivsqte/Htm10UIvuGg1yCbbdKNwXSqtXSEJbX5yT6tL6uKbDUE8YWRW57UMRrWfwEAZR6DbmBvyOkBNoaUCrx3NoKs/bPH/A5JwEJjKcsIJSB+tI/jZf64+DdQNlBT+r5MxtlpTc+58QKR5111NeQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 23:01:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 23:01:02 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, jmeneghi@redhat.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        loberman@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: st: Regression fix: Don't set pos_unknown just
 after device recognition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Mon, 16 Dec 2024 13:37:55
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1plku46le.fsf@ca-mkp.ca.oracle.com>
References: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
Date: Fri, 10 Jan 2025 18:01:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4784:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ad0543-d2ec-4399-63d7-08dd31caa7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fx8Gsty8NYT9gElQrerspKaiVY4eQwu7h+Bqmwk9DkRJ8yBuSczj3SIOSmwA?=
 =?us-ascii?Q?RsFj2Pmhewe9f4x311zcgxQUptJgaPfj5uVDJv2JULYRdHB03ias3+J3exQs?=
 =?us-ascii?Q?nVEMAF9qP9rUhynOeeP+AfRf2ENUy+ebdrfXGB3NT9lBKzTd1orXGEXQzWOC?=
 =?us-ascii?Q?AhdSB8Nh9TLG4ix7Nnn9F2PIMQEJUuwYLM4/s4HAJ0Snxd672LkAVq900WJc?=
 =?us-ascii?Q?cIpD84IQYdZl5oqrpgLrytlxkibG30PbJcz1Z13tBFlwu3MM3ByFySn6ymx8?=
 =?us-ascii?Q?ZTFzrlThU049NawT/p8iGJL0UT+YDkcn+tAbU9Gn1osCg64RgXIJUiA7oJcL?=
 =?us-ascii?Q?QqI4SIXfip8nS6r2sDKPjDfPnCFrJ0TdL3Lj9DnOVQmLF2QcqIYyrpp74qMH?=
 =?us-ascii?Q?cUL2j17fw2o11uwCl6c5G2NBgVNFHn3unHmWBcYRuiXz8Bsu6igwyyW9EVaH?=
 =?us-ascii?Q?m+uh0uwQnqtm0n+nJlf0TXgjPf5rcEa5hf9292n0sEqgod9FuFy5Ri+AzhvM?=
 =?us-ascii?Q?YR0Ng/oyl3P+Sc9Hnfq8y0Ah5LMqwdeb5jXQ9BArtrrgvnw+v9Ove1OZEjBD?=
 =?us-ascii?Q?C+T3Pd5mDTRGkJd0xqOyV2hvUYo2w/esZoY58UcMxibCvJaGkYGe66GuV75i?=
 =?us-ascii?Q?994D8COmIcQb2JVa4PKAGbO1UN22jcfy7Mf9e1fftvMJ+kFzKEquurdqWWNS?=
 =?us-ascii?Q?h6IadpQX6KcpPmbvzHMBU9Efc/tMq1IsvTiDxyZ8PKZt6UHYXDBJWxZ8YGcf?=
 =?us-ascii?Q?XitH0o6rsIUPWZ3KSXHoDXYe+rtgCUqI46Q6Av+LNzfeKayids/yvuF27qFJ?=
 =?us-ascii?Q?rlXovANN56ZDZlFNwSFyOCCY0BEvqU05tami1xGWwzXFbJB1GO8TVG9gFhEG?=
 =?us-ascii?Q?V7zFuzAa8vELEcX5/+HAv7TCf47lnEzVod3MatLTb8wzBQWh01v+Fa7f3vt3?=
 =?us-ascii?Q?zkl5Cq3jTznhuUefCvk0jjAEQKYy3buxft1wQmdy117ZWSvZ7PK9rZaZce6/?=
 =?us-ascii?Q?v5VuETm542bCRti3z7pEQ0Jxzy8B+ei4fSHrkvUchRttSbPqepulnRU/Pm05?=
 =?us-ascii?Q?LFK6HhlIQZz8U1SUTM7hWUVrmSHspu8i9HH7UBzhHVaszvQZvWQjk5179PMq?=
 =?us-ascii?Q?J6EIOTfx6AkTN/NnSI9GruLSo3VkGGjMvOiyP83S0YO+7c5rF8DtxNM1JuLx?=
 =?us-ascii?Q?DPdcAQivYOkcxC1YJT7VDF+OFgR3xRqYLZ/zZRqVysBxINu81oOdOySsGdNK?=
 =?us-ascii?Q?3zHgZsvIh+QsaOHTcomAzeWfWp5b+zuFH9Td7KwET/qcJt3QEigOEd2GAsXE?=
 =?us-ascii?Q?og6hjEZdFtDzy1qFSvO0P2a7wfJGR9S12o8oyaEKn2V81cHid14lCiuhZV5w?=
 =?us-ascii?Q?4WEFMMvhQLU4z/ffQ+8i/kOo4hVg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XsxWO3IwheJ5jkVNy7J15osR2lTwpwvtVq/oN0K6WzVAMD7GKb3M4cAscPcT?=
 =?us-ascii?Q?UP5QUBXvIjVAr90xQSjEMp5syTzzhqCFtu0abVEtk7FvM9jet4TPiXMqZRIr?=
 =?us-ascii?Q?LpRdJ5pQXQ2//utNJr+jAbRQjHeUSgwDSPCkKP7cxaGhHBJybi4WyowNlczM?=
 =?us-ascii?Q?5OBWVa7OSjXFWgoCIUyJSU/o2P0XIUnLJvAQ1QYTCB51xdaTVXFp1skg7HDq?=
 =?us-ascii?Q?qNKfTjpwxMpsW1MF+iYagtP4U3aHVo11h0FLJgCD3eheBwp+9xq74yLDA2xj?=
 =?us-ascii?Q?dXl9eWnRX3po6DvnVq+BHtHKA0WrP4cLx4EMNRqBzifYLWYCRD9XrB1UJCwV?=
 =?us-ascii?Q?De+UQM7BjlfFHnTH0tctB5NHJLrRQ6TY+e38vuBYrlS7mEujWWCu2RIPklxj?=
 =?us-ascii?Q?0jshMq7RLxZ6GZ2GYjfZ9MqSJufnLqwRyNu4fG1UwkWzNrGUgve1OMHFQpF8?=
 =?us-ascii?Q?UYR8h/nmfdDLKqwDm2VbOYIdk0WbsoS1KxjlLnv+8BF/IS7LKG9YeF7FyLAP?=
 =?us-ascii?Q?Ca84jwxCgb/0rNjG/6YTDm5hbBUj8WGcXBmKfH+kB3DaVsGfqNt2MIV3jbCw?=
 =?us-ascii?Q?o63Htvtp/DKu/88HfH+bzX5rWTZJ40nfMvCjUyYpNcCKgKbDxXSHLmwZR9w4?=
 =?us-ascii?Q?FW7TWANBWJRArfROEULeWee54Md60fV74mk9poZ7Tc/VG5EmLzTRnv/D+l2L?=
 =?us-ascii?Q?v+reUmoWEq0y9uY6rGPNZP6znrgPZPJSYG6ISIna4MdQAhN2clYWy9gKeSoQ?=
 =?us-ascii?Q?CaYgzdcPccGvnwIg24VWpEctIJnBXc7vBupCIDhPFJm6XbtqRr8P9vzDPDk2?=
 =?us-ascii?Q?8PHSD9fMB2GDXUXaRMV2El8uwF9HIOL2h31JLODhG8CCvL2z8+1lav7uexbJ?=
 =?us-ascii?Q?bT8Pof2vsZ7K3Yfbs6zgsX/wOJ//VAlPbZ3mm15YEA8Gth0t2eoIYaP2gGs5?=
 =?us-ascii?Q?+WBF5NWzYOHq9kTS1fqAL05n6PbBqk/br2rFA6XVIR58m6sGZDEw60u3ZDAj?=
 =?us-ascii?Q?nAfT7Vb8HPlEY0vwXY8Z4QK/Q/10BWaX03sVrUCKfq70LaOJeZFjGi76fcWv?=
 =?us-ascii?Q?CJTZY8/Wh2DAKBQ5/DJKDl4X8Ko8QSiSyPT8+Cm0cBkRSFODFFUl+xlYFT+T?=
 =?us-ascii?Q?OADShSW3n6uidb7dEbjIGtd3Ms7GLwlJkKz80dPoZMU3FM1xi07fLokfFRSX?=
 =?us-ascii?Q?rlUKkEA2/QFiy9MPNI3FT+dbtdrlUjA2wCKzF7gN8Vpq2Akja3iRPZNqmm/6?=
 =?us-ascii?Q?7abE/M009KiNypHQ4pviZ20K1VxW6k/LviasUUcM6rOBljVnratZRbbglYlI?=
 =?us-ascii?Q?8e+O5kl9YFGso09PvoahnihItBLTSV+l4RrBhDHlA3bH78eLWzO+FIy2Y2P/?=
 =?us-ascii?Q?TflGO4ebnRt7d4fJztcJZT9v+lTlGpjdPHpGT04B+tvBGhR1UeyMDCoAAgOW?=
 =?us-ascii?Q?8BvVzsxpU4tp9ZEZZze8e2JcWDEQEjJ3bzn0hSGtuszajt1TB7grmxKqL8wY?=
 =?us-ascii?Q?7ob5D7MeBIaA4+/WbNA6btDfuvoE3p/6PbWKyQyxaKk4uegEo4by/7r2KAzu?=
 =?us-ascii?Q?RIOSMuYShewhZHTj+/GnV1nYW1IMrDgLIx9ioVsHRoUs691A3W6v6OInARda?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QcENfMHbZEnmDGtZCZuvMluA0U4RV76oT9UnaXn1zQWZtspOYHFuR/n7Iqys1qI4dHvqKmZ0jhcz8UYAmQpyE+2wjW2BEYEDPnwNSkKxmrycklVut2WyGTs9+9cAKv5C5tT3UZ5pAGsLVZkNETrL3FN0TUqFRl/Fxk6Pq4Qb8uGeGsKPFl1GociZrKFKJkyg1A0+M4QEKXvNRYvuTYVPBOt4UNASpXtI8U47Spjc8DGjK3lboXdo5VuVi4Dbp4kmtw2WSyzjQNnos0k4wh9g3ah8tY7++oU0VD5IgAasXGbsuaD8ONlcCN9zVJocaCo77u5Y2X5ewPuK6E2AM4XKbYb+aYpACWhV0V01pLMA42IFJBvm0r61PVJzkXI+gKqVv1F36TBktlHnTbm6u64drTjCsTo4lz+wsTvs24fYLo8wsmugeByT5ztnyq5naqv8Y2cCay9EtFFrAdUVevEi5Qhpsyc182fJHwP6USIg3JYK43+YE9+JIb8pfb6QwCTL131tgx1lMKEf7xRoi5+BzJBhoDegSxhfZ9zg4/5lYImkr9bjFG7E+WE3FTkDAMQxAtsmPO54FQc5GYruewRDjwcT23TFWYX/uKJpcif4SYc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ad0543-d2ec-4399-63d7-08dd31caa7d4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 23:01:02.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2a5shM1X6y9u4gHBCchtrdZE4y/3juwS2Lf7+MrDYNqUkZrXLIT5wWOd8Yo4U2/W8S9n8/v8kT8V1ROteMUU8gLnRoZZOi1tahCd6QhIeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_10,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=630 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100177
X-Proofpoint-ORIG-GUID: ubjXs2zJhqlK1ik58tIvmLatLSD3aLuh
X-Proofpoint-GUID: ubjXs2zJhqlK1ik58tIvmLatLSD3aLuh


Kai,

> Commit 9604eea5bd3a ("scsi: st: Add third party poweron reset
> handling") in v6.6 added new code to handle the Power On/Reset Unit
> Attention (POR UA) sense data. This was in addition to the existing
> method. When this Unit Attention is received, the driver blocks
> attempts to read, write and some other operations because the reset
> may have rewinded the tape. Because of the added code, also the
> initial POR UA resulted in blocking operations, including those that
> are used to set the driver options after the device is recognized.
> Also, reading and writing are refused, whereas they succeeded before
> this commit.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
