Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F75C214A64
	for <linux-scsi@vger.kernel.org>; Wed,  4 Dec 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331668; cv=fail; b=FDYG19+9qB0b7pM8qWeYRSlJux2HLPTzyKcuAVmH3xumhywGbc6xdo9VJW70xHOoJMu2Qfjurnc+gt3uKLDj0U2U2rLttn9/PT7DEhzcgq49iLey2AWTlIMrUWj3yJwmoDvTJ8WVTSiDtI0IyZpc7iHWQGrGrLDaAaTxrCM1GlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331668; c=relaxed/simple;
	bh=100mo7+5MHLM9uJsd/PQnPkWsEHcCGxbIUPlMy/TeBY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Zg6b9c2CH/m2WMFBsdnDPTknmSOp8yoBEntrtr/HiRUbFPUO/93gz1bKPEmMh415McyBTS3pQ+sLDMKQtJ1k7ra3u5iHOKJVoVn5dqkVDv9SM/D8oQ/BwKxQeyanEXQzFNkZJajTv7vuE5FuTDLSCcWWCPBJhBbQyGqF4lTwwSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C6BN4v2r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DElm6ho4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C6BN4v2r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DElm6ho4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4GfkKF004238;
	Wed, 4 Dec 2024 17:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=sFZrdT7LEgJfeIghw/R4j42ZKnEhUkDYPXlnBT7JBQg=; b=
	C6BN4v2rYTXaEwH2jfb2sRz1JyYBHS6Io/mjLrHHdd0gntVXijtAOGeVC4zSyasE
	qDu3Ve/Z0hkfPj2/+Q7Wh5xOi5ktPCc5ZDJU0neO3r1C4df1G+vWNOCieQBbjwSv
	hVDG6f5qSdTXOl21K5owndSiqi+s9sthjMumhgm+EGNxncx3VytgUsPH5E1mHomh
	r7S7SI7ikkZvQ3MSyB3GETQmyue3PltF1NXyKUh2O8IH1zneaqppchGPR167oLPh
	Gyso6/J9h2FkVHRUyJsNQPrXTlH2VdSfFyRqYDxUOxvDkskJ48NoDTi+xu7hVvbh
	xU0oWFmsJ0LBiplbt8372Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437u8t8yyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 17:00:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4GJt0t040091;
	Wed, 4 Dec 2024 17:00:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43836vnwex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 17:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f4RZyYsdDLM8jSLeOq08ZGbX5yGH9xyl1of6VHbjUG255hA1Moh0WtzVsgdrdHmhRbL9lrbvpJC9xMx79MM2nChI86IYS6r/R6N3fyyLYFyv4+C1Qxk6fhsVjy2DeiZT7fclXV/IPshV4Fe8hoHR1iKvWZe2SkKJzXRyUiZvZC8Q8NI0pPazBUMtoxlZsi7v+N+O7hZTVUKF+H01rYmqWC+ON1p01E+LZe03v4C0n/R3jVqwkCaiT8mQ0D17IO2/WSNQbQcuiEkcek1gBsLYLAE0IOSOVEOFu6P2oIjkd1T/ayyl8wa15B5gsAb9DWOjMTbBxpz8pBc1sS5XUr+aoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFZrdT7LEgJfeIghw/R4j42ZKnEhUkDYPXlnBT7JBQg=;
 b=DNvt54ahA28eJAXywqyOaz+FT71Yf54GNwp98zloeDRAsKmkkA8bEnUXgpHzHFt1odKCKFcRTqxcMv2Tst/yo4VMF//Sb7Rr/WquAzXl89O/HbNJefly1R+dbOA61T7XSLeh8fx+Seu0/0Eg+1d0SeJXEwgd82y4dM4l94x8YfMfuUlo1djDhvKshF+bxi5KpAW4voVe2BkQic8DZp5/vLUTj89gt3ofh3T0kC1G49Kpj+7JrS7z4kh3B3UjSo/ww6UOzjb2qqxj9ZImAn5/3tcdS3IX/2uYjA0gx/AsP40xva0mW1JwEZq4rKh1+bHjxxtWJOd8tEzYIyNKNDvdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFZrdT7LEgJfeIghw/R4j42ZKnEhUkDYPXlnBT7JBQg=;
 b=DElm6ho42hDsYdd9I0z1q94vZNCl/Uh8RMGkeysn5PHVbZEo9nCTI7VV9vVp9dKU09LebQRZGh0h9xjiOa5bPcc+wB3Mkw5YemLEs68m2+wSVTALCLXmSbLsfHYh7EvJ8l6ofMS5OfeI5sS+cnwQu/e7oGZ0VTwdaFYmshP1/Ag=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 17:00:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 17:00:53 +0000
To: Lee Duncan <lduncan@suse.com>
Cc: Lee Duncan <leeman.duncan@gmail.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.org, open-iscsi@googlegroups.com
Subject: Re: [PATCH] scsi: iscsi: fix sysfs visibility checks for CHAP
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAPj3X_XGg+vT35aHVmxYONVpcjadAE6eSsa=nuUwP-+KHybiFw@mail.gmail.com>
	(Lee Duncan's message of "Wed, 4 Dec 2024 08:43:56 -0800")
Organization: Oracle Corporation
Message-ID: <yq17c8fs810.fsf@ca-mkp.ca.oracle.com>
References: <20241117194604.13827-1-leeman.duncan@gmail.com>
	<CAPj3X_XGg+vT35aHVmxYONVpcjadAE6eSsa=nuUwP-+KHybiFw@mail.gmail.com>
Date: Wed, 04 Dec 2024 12:00:50 -0500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d24c85-c730-40c0-fc41-08dd1485367b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1IxQ0VESkYvbkl2cGtTeElhTWM4SDBCSnJTSElxU2ZlcmpKMmRaczlqeHVE?=
 =?utf-8?B?MS9lcFBTT0dNQWwxWFhkaXo2akhQMEpQTDIvNUwzMnRSU1hCNHlxSk9IVFpB?=
 =?utf-8?B?TWdxdmhNNFlNS2J2TVFLQW85QWF6UXBNZFNTTXh4eXIxZDA4aHdZaVVzVjFp?=
 =?utf-8?B?MENoYzh3THkrTGNqU3lQeDBnQW5sMkpYNDNrNE92dnVRanRyUFZxdHYwR3Vo?=
 =?utf-8?B?R29pTDFYc2lrWjZvOEIrWkphVE0yUmU5QkYxQWFTZXJqbkFMbzJuc0FrNU41?=
 =?utf-8?B?dWxQUGIyWjlQT1VTem52YUJJWjRRZnQ3SWRkWWJ1MUxZNE45OW9HdFJjUjVZ?=
 =?utf-8?B?WnRvR1QzK2ZKMXdDcmF2OTB1YU9aYTIzSlc0UHFQbU9zMXB1NlFyZnR6SS9a?=
 =?utf-8?B?TTc3RE85RTdvM2JtbUFObzFLeDBwNERuamE4N2U0SExQS3FyeCtvUDF3WDUy?=
 =?utf-8?B?cUI5WW83aTR3V1J3bFFOZy9KUjRCNHBKYjBhOTd3WVJUb1VWMmRVdTVMMzM5?=
 =?utf-8?B?SjZJOVN0RXl3R01URFN2STJRZVR5WUFCRk1KNjZUQTgzaG9oQ3FUbHJrMzA1?=
 =?utf-8?B?L3N4WnpZM1JrMEQyNVVNUG8rT2l0TW1FMXlFWUhKZHNDYWREM2ZQby9ZRjlC?=
 =?utf-8?B?N3laYXkwNm5RMUF6S0VUVU9iMTdiSkhvWFhKTGRkb3dWQXFXdFhKaENaM2Vx?=
 =?utf-8?B?UnpsdWJrUkFuMVFBRFRKWXVjNkZJbDdIdW5wUm4wb3l6NE9rSzQ4R3l2QmJ4?=
 =?utf-8?B?b2N6VkFCZ1RMNnZzSUZrVGEyUjZwNVhGVTZrZnlXK0dWYWIvNjNTU09waE5I?=
 =?utf-8?B?bmlxdnlYcTUxQ0F4ZDRPcmZUZjQ0dVptSHhybHhCYVI0WHZkQ09GcEEwMlBa?=
 =?utf-8?B?eEdUeU9IcTY4ZnArUytRVUpTa1ladHBUbHVrd2tGZ01HL1RFcTFPRHBSMy9V?=
 =?utf-8?B?NVlMcHV0L2R0dW9VUUpmRFdmQ2Roam9KSDlSdnNBWUtXN2NZczJhb3d0OGNz?=
 =?utf-8?B?bWlheVdQTithcWRBU1NsbHJtNGFJUm5QTVdRRTdnV1RWUlRCYjZTNFNJVWw3?=
 =?utf-8?B?ek9relcyalkvWkdIREhGb25RektQMUd6cWloTWQyQVlTcXR1VkdtaTBLeVNn?=
 =?utf-8?B?Qi9CK3Vzc2NLNDFpV2EwNGRXMjFCaFVieHFIOWNYRWNXaTdtYTZ6UmsyN2lD?=
 =?utf-8?B?UkgybTNwZGx0b3VTckJ1OGI3cW8vYkdja0FaejlJN3dGRE9kdDVDUVFuRi8w?=
 =?utf-8?B?bm1TdDhQamZqNFVFZHNHMndqa1p0V1JIS3ZsTDl6UVJuc1hsVnhZU3lsUmM1?=
 =?utf-8?B?OURGdklqdmNGWk1LdjhRN0RobkFGY21XZExwdkxrNmdqaVNTYThmWW9YamtG?=
 =?utf-8?B?Z0tkYVpqMDgrNnN1dDYvTzJyRkM0U1dZUkpVL09RWGRvS0E5dnIzek15QSsw?=
 =?utf-8?B?QXVaVDIxTmNqRkJyekxNeDR3YzJSbVlmeTdTUzZ6U0VFWjZiOFhqb2FjL2tT?=
 =?utf-8?B?VmpZSlNFRG9QazNvNCszVHZLYS9jQ0NEekhZYXkraUZaZXBqK2hmQzVmamZs?=
 =?utf-8?B?cnFhUVBkYk5QR25UVUxMMEpXZGptdVVNR0dsQ1V1RSt4ZTUyd3lpazR4UGtJ?=
 =?utf-8?B?dHRHb0dTeTFEODNaQTV2NitBYUFXWWFqZVJNaVhmckg5U1R4anBhRzNJbjU1?=
 =?utf-8?B?dWprT0ZIWmo1aUhzWWIwWXpoa1pRR3g3VkdGdjgvZmxyc3F1ZEoxbUxLUWJU?=
 =?utf-8?B?Um5DOVhzUGhycmpKOU9tZUpEZ2tkNmFSM0FiYTlEYnhDTHhIdHZnNlV5ZWYy?=
 =?utf-8?B?c3BnWTlzRWFSTUJKV0d0dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0NTZWVJdktRTUlacFJibG1LUE4xbHh1S0wzS0dBaXk4T0x3bVErckd2WlNk?=
 =?utf-8?B?bWFIMlgxVy9OMUZpTm9nNktNaUVIS0hUOGZPMHVpWGdaYmZOTEdzQXBSeGhl?=
 =?utf-8?B?eVJDUDE4RXlsSk5TL0FzZytITng2ZmhzeU5sMUZJMm1OY1dVRjJBRVl1ZFZO?=
 =?utf-8?B?QlZ1aGl3YUxRUnVvK1Jqa0UrRHFLVVBvZjZ5RC9MVjlLZFhuNU9kOFZkZ3FB?=
 =?utf-8?B?QjlsUXhuOGNidWtMalZLVkhLVUtrSWlwM1MzL1U1aXZia3NEcWh0RU9RZzZR?=
 =?utf-8?B?aEFCM0VtYVMzV2pVNk1NZm02SzVYbXNjR05oUEc2UytuRUtoSlBOcUtyV1VB?=
 =?utf-8?B?bnZ1aGxxZy9Sejhvd3pBbnZVQjhkZGwzL0NzWXk1cnRvdXNLdHgzOXIwTVh6?=
 =?utf-8?B?SWRaVW9uODgybTlqQnd5OEdBWjUvcTJUNDJXNWNMRFFERGJIdDlaNUgyazYz?=
 =?utf-8?B?SWJoVkJaRktvWjJwZU5aTVNYZkx6cVlWM1R1a0kzK2pGaDQwMU02dWdRWktG?=
 =?utf-8?B?R041d2FaZmZKSlpIMFhoaWJVcHVlTTBIV2JYMGJoOHR4S2Jmb3BtdDc0WG1t?=
 =?utf-8?B?VTFaQWhkWHZIaXF2a1NXeXpHREVLUDF5Z3R0UzRQUGZRd0ZkUjRqZ2dUSkhT?=
 =?utf-8?B?VUNpeEV2SEZHQmJRenJoRHFZTVgyb1VxMVk4LzlBM2VNMFZJK3o4Mmx5d0lN?=
 =?utf-8?B?TFZEMjZNUitKcDFYbVpRTUtvTFplMDRqZ2VVekNYb1RUajQxTWg2Y0thNjhG?=
 =?utf-8?B?Q25nWlAvVkg1WlRYaDJWck5sbkdtYnFOaHR0TUZ1T1BlbDBhc1BRZlRrQjg3?=
 =?utf-8?B?eXRZL29NVkljcm9MdnJwYUUxdFFVSy9vdVlwbFJKQjRJWmJMYkZ1Y2p5YkFu?=
 =?utf-8?B?U1UybXI0OVJ6RUJUcElXb3YzSnpDMGNxQ2p6RUhPVjJoRitRV1NUdmtuQUxG?=
 =?utf-8?B?Z284SlZuaG54azJMTzFtYVNtcG9FdVdvK1V2ZUp4OTlPSjJ1VlJCUUI4cllY?=
 =?utf-8?B?SFQrN2xROUFickljMnBseUJ5YWNLbU1UOTZoemorQ1pCeURFZytuZkJLRk8w?=
 =?utf-8?B?ODN4NEZvK0pBVGFCbFc1SHBUWDFQdEZ1aWpQZmpXc3h1WnV5bDAwUEFiZ2Np?=
 =?utf-8?B?V2ZWU3M4UnBObE9zUnlHUjBWNFJOdERvUGJMNGQrVWgyeHhtVWdTUzdyRXhL?=
 =?utf-8?B?SnFXVlRBZ3U5ME04TzhFayt2VFhib2ZtTWdjempoYlp3UVVkeXhsLysvNVRj?=
 =?utf-8?B?cnZ6SFhLNVNOK3VHNFlKZ0VmYkdXbjl6SS9xeHMrSU5VSERyaXdPcjBzZ29t?=
 =?utf-8?B?bXFkUmM4TFBSaXNwalhnRTM1RDFVUE4zb1YrSkNsMjkvL0xFc3Q3ajM0a1dW?=
 =?utf-8?B?RTRDampWRlA0UGp0eDNrR3VaenljNDJpRkdaMnFYb1JBdjBLN3RQMlltZDlB?=
 =?utf-8?B?YWJxeUMyWjVobjM0ODkxbXRhNVhnRC85ZDRjQU5ENlNGTEtRdThybUJTVFB1?=
 =?utf-8?B?ZXZRWEk1UUFvMndzc1ZMVjVLZmJhY0daQVRkVGViSWJMb2NKWDdLenVOb05w?=
 =?utf-8?B?d2RXNVhCVkJjbFpmZjI0MkdaMGpLZU5oTmgzUDVlMGpQQzRYcjZQTzV5ZHZM?=
 =?utf-8?B?dmV3cXd6UkJkVlNxRmtUdXI3N20yQWxvVFptR3FxT1QwMEZON3licm0zRnlG?=
 =?utf-8?B?ZzlLbVgzSWg3ZlZ1bkpPRXpRWDlvdHZ1aUJZVkhIK0tYdnRvYTBzR0xOR2Y5?=
 =?utf-8?B?dkp3TVdpbytISzM5Ymdpd1NxeFcweE5pU2EvTlVQRFpGNEtTN1NncGgrdlFT?=
 =?utf-8?B?NU5nT0U2TWczRzZORWhtQW9FUUxvRkUzVmEwcDU2SGZGa1daMjRmTnZNaGtr?=
 =?utf-8?B?NFlCN0hNNVFGRU5kVHpCdXJJZkphZHFUdFk0OWRIRFVVSjFDeVppK004K2U5?=
 =?utf-8?B?VDVvR2EwZ1hnQkJ0Wm1kNk1qUXJ3QUltc2xZR3ZBWFRYTXRvZWhQTkZWM1NP?=
 =?utf-8?B?OFZxbGV2MjFHSVRORmtSakh6bVY4QjZMRXUxSlZkZjFXUW41SVg0bTVXV2Jn?=
 =?utf-8?B?cUtBeUljQzVvOUZUOExGMkV1TFhndFNXK1Zjay93M2tIakQ5SjRiNWZ6UEZy?=
 =?utf-8?B?enF5WUl4d3FRVzcwalpVc0Q0TEJJS0owMWs2ei9YclV0MWhMdExpWFp6c1FE?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4F3AlLW/1b0Nq9qDsvBOuWqV8Vxoqp58S2x2dTYNEMk06r7DMrvIeHLTE8nORMqtq3JoI+2xC8Xvs+wjsrcFvdvchxblO0YClbVOx+/hHENya/TFlowiQzCbN/C0ABExKL6LocviH0+Sf/kkfchDHd8OavhtSmCEwgEcAcW3ZzEV30fv00zdTNHDEO+5QqldfJixUfMQnb0hx1Hvn1uHRsCR+ALpZwgHi1JXi2ZexzzdwPI+vbD7mgpzKv9WSQuwHyjNXYjxxpjGA5YHKnzgxCPbgzkMfo1RUdqi5DqwIVagyccixzWleTLuNBFr4PV+7jjzJeOetqyQ7lxhvYsDK0Wuh1qdRXGzUhGcEDQ29fGSspkU/d6SbJFW+3OHFcaMqBHnw1qrl/7ZlbA6xy3Eu25eSFiEWsW/vI94eBEUokSB2kvwGOPqnQUAbISrwxRI90RW+fsmlSDVTRzu/DWAzrtzJ7l0/9tnlKueQbxkkRn1/MG0fVJt9cJSIopNBA5WKC51I9oWu2aD6/GKfU27rCwQN6dFxF/uXTYa8PGxBHcg1wDbFYb2exzvJQHF0xzoswDG/9/AJT6anLgn4Q5pMXscXTDqKkdRUqWycLCvmdI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d24c85-c730-40c0-fc41-08dd1485367b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 17:00:53.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Doc70UDnnVJHeIBjN6Lit8cSTWW0/Hx4azsCuW2X1G2x8rITs8zrvBGmB02+2hSTzPMKdbAqTIorQ7ClIuPQa2CKjkU+nlFpmGfkdMh78/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_14,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=636 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412040129
X-Proofpoint-ORIG-GUID: 1R2rvZiDRPTYakhUWiIbxI8bzh9U6g73
X-Proofpoint-GUID: 1R2rvZiDRPTYakhUWiIbxI8bzh9U6g73


Hi Lee!

> Ping?
>
> On Sun, Nov 17, 2024 at 11:46=E2=80=AFAM Lee Duncan <leeman.duncan@gmail.=
com> wrote:

Mail problems? I don't have this submission from you in my inbox and
it's neither in lore, nor in patchwork...

--=20
Martin K. Petersen	Oracle Linux Engineering
