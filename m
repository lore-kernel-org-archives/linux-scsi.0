Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA9218BBA2
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731444414; cv=fail; b=rsa45S77CiWCFuQ9UhqZWZ5xhgS/m7C2eogD+2f9pQ/Gn9ZHD4ih2agzBr37JKfWGmyYz+RcPQPQcvQxagho3U87KOaHscg6c+E1PfoUPH6eo9Dpwd80ib8thOM243G3lNlED/HF4p/CrPocpA5JJKo23Z+k/W7xyNoxJl94Vek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731444414; c=relaxed/simple;
	bh=zcZqXfvGQUxr+SRAi2axYFEgnJVD3dFjX6WSMsayulE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fZ21mFVEHn5eiK5nwzACUeMPhAH2whOo8SKYYmMDmUBv+Ed+P8A9WFRJQCDNuIsRjYfpa7ot5kkFL8QuVJIMUGL2s2z/bDz/PUiuKF18lgrlpRLnmvgXmsmPESQnwG9SEYV8Q+xj1SEVYxg7ZljGLQK1MRKtg7LGglugjmx1LKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nwg+QGNE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CyaufdXv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nwg+QGNE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CyaufdXv"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACJfeT1031515;
	Tue, 12 Nov 2024 20:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9L7jLgnZ30taZgJGod7uSoWiuhMaiX6XzC/TeDrheXk=; b=
	Nwg+QGNEHDOZqawnEaajMBkLWyRnp5fj36L2/CJlHwbrc0WD8Dl/cIvahkhn+GW+
	FWrsUycOnQyNHj7Tqk/Vq1lDFXY2PbUn8xDcUtJv2uAJeKN4std3AAWgLEyWotkO
	gpQQeyWGO7nM4/JKeb+ZqNQXJF7a6expGvzpYI2VIrsAG3/kXkKf5YB8CYP2vjxF
	KJDLiIfiYyC7hLsmrxa7Lmwtl6QgZvdT36wRnV+sBN6WISyV9emuWRfah1br+eXy
	jVcRTNFWWHW+gc9x5RaosMOun6nFztU8kFA7J4Mv875o/AXrXU07xdDq4UyzHb4m
	sUT2/t9QLeISNjC07WpvIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbddy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 20:46:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACIwNIL035927;
	Tue, 12 Nov 2024 20:46:36 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68e59a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 20:46:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9cECG1BMv/XpNaxm+CPaKzNW97+0NMfnxVF8wroDC2JGMnTb4cKsY1h7HCpMRvbgoUrBdnwAeqFFLDiwUK0JjEtwHTsnhP/ySk3WlEgqdpOXmyY7RW6UnkAtwnRImYUTnYPY08ruB0TtuWt4aWA3wMmHAE+ucXrOfeAjGRpkzyhLGaABxAc84RQIHIbtgTJBJulancC8sIMjgjvJ7qlPfx3bY9W0gni5Df15Ig2vqoy3maRH2GoScv83RRJGm9I9SnIMJO1g3PyJRB5IN2As3mJEXwruZj14S0dGfyNulAYDpmqaByxLh3gAc0TwY8yK/Gt55FQevDahhJGjTHIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L7jLgnZ30taZgJGod7uSoWiuhMaiX6XzC/TeDrheXk=;
 b=D3TUe4arqX0kyE8cJgSqL6gxbOkBqxog8vm8hL3p9cs4BBMCM9AanmlT5xmz/w/u3yYIefIHB6OHlItV84V1XWVShbMeQhstSfLbI0JTwz7eDfuyBLlHOFAcLGy+F2CqZq5MITaWfvnJ4IbVjFhGaJAL+cEcWvpH8sCo45UYyiVUok0xpvvBLlhttJ2Wky0DcSGWpWxoe1Z7fSfTPXjQWEkyAOa7TOIQuTnTjKVCbqmT+tdARvD176oEqA3pgOsaX5zrSpbl42vqQFnt1qHakJHJCbeccyJ/YnRRmP4jOQFMckKRRPLdXi04oAD4rbSh52y+6iSXPJLh7ZU4Jpfumg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L7jLgnZ30taZgJGod7uSoWiuhMaiX6XzC/TeDrheXk=;
 b=CyaufdXvhQfeqwglKr4g9wCAJGpNAAiX6qLUUf6PdPX/COmY0rHRtel2KtndsLUNxlC5/Q9Vn+VhOuLQ/ChhJFZHhodnS/XvCyE4XERVW0F9SHcml/GzmaF4E9+WizlxAxHsNfOr4bGh8/mbezAvxzAHCrfC3i/qyUMDFKHVBd4=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by DS7PR10MB4846.namprd10.prod.outlook.com (2603:10b6:5:38c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 20:46:33 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8158.013; Tue, 12 Nov 2024
 20:46:33 +0000
Message-ID: <7400da45-6057-4715-ace8-9a172961c2dd@oracle.com>
Date: Tue, 12 Nov 2024 12:46:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/8] scsi: Multipath support for scsi disk devices.
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
 <3a57d700-8f4d-45b7-a13d-501e82855c0d@acm.org>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <3a57d700-8f4d-45b7-a13d-501e82855c0d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|DS7PR10MB4846:EE_
X-MS-Office365-Filtering-Correlation-Id: 970df1fd-5f31-4f3c-a98f-08dd035b17ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVY0cE9kWUoyV3BHQ013bjFtL1BRNC9jai90KzJ1bE1adlQzRHJld1dHQ1NF?=
 =?utf-8?B?UURYRVp1NVo5eXFranFQNi9LODd6ZEUwd0RWYVMrSzRoeFJOQUJCTDdxSk80?=
 =?utf-8?B?NmJTMjJuQndxcFkwakNvNGFkVW5HTHBGelhTSi9MeUFPRnQyNlNpd3lMSlhN?=
 =?utf-8?B?cmNFQjhEL1R1ZXBJZnJHYm1uU3lkSzVuNTdaMmp6RnNUTUt6T0VtQjVNcytJ?=
 =?utf-8?B?dm9MMTJsaWl5N28wYmdPdDREWU9TVWFpV1FET01CV2dkL3FxdG1YWWRTai9p?=
 =?utf-8?B?cVV3bEhYUEhmUjZDN3BSTGdjVElLQ1lOdjBOcDNiM3ZJTG5kNzNOR2luSWZX?=
 =?utf-8?B?RlV1dDdLeEVTM1pRVndlQWg3RXN3TlRKYjVyNU5tNTNRcWdGMFpUaXo3NFJq?=
 =?utf-8?B?WUhGOW4wQ3pKQWc4cjBvd1BDcm40akVkVit6dlNSUFJudlRSd0xnZWs1enlW?=
 =?utf-8?B?STJIdzZZYytGT2ZiMnF1K01RRUt6Rlk4KzQrZVN3WmF3a0tvNG8rcmRLaFVB?=
 =?utf-8?B?UFBOR2VJdXJFRjBNc01Ybkt2UDZSUWxobTJmVm5iRkdQYmdYVFhYQXA3VzRa?=
 =?utf-8?B?S3Y0Nis4eU5vV0xQRUtvbFR3Z1oycmlBeHR4ZUE1REppbFZRYWlZSEV3eUwx?=
 =?utf-8?B?NTluWUt0OG1IV25NMVgyM1FXVmRneW1aRC9tWVd1cWJFZ3h2MURIa0wxRENi?=
 =?utf-8?B?NzB5T0pQQTZBbldwY3RGNjBEQzdXbjY4NTdXbVJUcTRJa0pycWVKbGdBVVYz?=
 =?utf-8?B?bzdDUzErcmwwSDhpanZrZWlQMjFqdnZNWnZkOVFSalBIV1B2UmJkMnZ5OElN?=
 =?utf-8?B?Vjk1T2ZoL3QvOVI2OUd2V2xhZlJlQ0hEVnNlbDBPTXh1aHphM2g0RVQ1dUJk?=
 =?utf-8?B?L01hZ2RnMVNmNEZ6SWN6Rk1xZXc1a2FvUGV4K0lGbWpseXFHa2dkUmRGSDBM?=
 =?utf-8?B?MnU0ZHpLL1dsVGpoQjA4VVp4SFlSUEhwNUt6U1Z6Q0FyclNZVzBVemlyTWFs?=
 =?utf-8?B?YVF4ZkhSNkVHem1SMUc0cDVUNHU5eWJYVmVvSXRwamRFdTE0NW5xRFRUSlNJ?=
 =?utf-8?B?NjBLdjVqVmlPZ3BIcHg5czdsOW85QzE1cW5VaURmNjIxZ0VZLzBvMjlGSnlt?=
 =?utf-8?B?OWVyQm1ZNUpMNWFhekZuSGxPSSszWW5tMFB0aDA1cFNOc3l6WHFkSUJtY2lX?=
 =?utf-8?B?ZC9CVmkrSks3MEkvWW9jeFJrOU9aTmxJTFRIWURjUmdRTDMyQS9ybDFuQWkr?=
 =?utf-8?B?Z1Yyb1laMzgwcVFKeEE2ZmdBR2l5UEdTUnZXTW9kenIwWVoxdk1rYW9mUG12?=
 =?utf-8?B?Nnd3QWw2TXREbVc5aVN0amlESUk5YThXYkJ5Zm1JQkNNTlk3Wnk5MkNuRk5q?=
 =?utf-8?B?MHNISnRBOFR2Z2pmenYrUmU4NnlWUnZqenUvREV5cGdxTlYvSzBQdmtSWE0y?=
 =?utf-8?B?S0VublY5NVpnY21COEdHcFNha1ZVaFY3V3lFMXJPNFBRSm52eTFIZmhKTWZZ?=
 =?utf-8?B?eGJIN0NFMXkvazYyQUZCZkVBUTQyUVFYTzdrdEFVQjc1UTVreXhrM01ra0tQ?=
 =?utf-8?B?SWRiVm1FUzlwbVpvQWdOYVU5TUlKakNPM0NHM21KRGxFUzJsU1lnWDYrS1lw?=
 =?utf-8?B?WFpHTjdmTmZCRW5QSEo4d2xBcXJtNWtxS01sMTRzc1A5eE9pT2FiRmwwVXhZ?=
 =?utf-8?B?MFJycVB3Y3ZUVUhKcExjWlNCYk9Eb0dCYXZ0d3lsWkJUUVdKNzdhcTF2WDJt?=
 =?utf-8?Q?2PpIcrsD4vRQnP/p+qAjf64txIUuN/96vqIOSpx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?endRTTJPYy9adUJhYkJ4VjI4NzN2Y3NMdVlhTnRyRXdZWFhIbmFvdVlLRk1I?=
 =?utf-8?B?NFN2SXlMaDFqMW5xYkFSSlFvaUlSQWZ3eHNnbE1kOVQzT0pVdlBYd3hnVk1p?=
 =?utf-8?B?RWpDVENTQ2hXZi83cVM2Z3ZvZzdaUDFkSm1KeVg0aHZrR2NtVmlJOUhuV1BT?=
 =?utf-8?B?S2ordzJzVDJ5OEZvOXorT2ZJUUFlYnZuQ1gzZ3o2RTQ3dk5HVnZVVmlHSnpH?=
 =?utf-8?B?UzZRVzdkQkxsTWlBWkg0SFlvaWpUOGZtMkhoOFN1OVFsc21aeDQrOUNLaVRD?=
 =?utf-8?B?RkNxbzN5U1A3M2NnZm9SeUJiMXR2b2Q1U3BVZFVtVHVFSkVLdjVIeW9LYlpa?=
 =?utf-8?B?SHNwTVdCdnQxdklBVzFOdkhLTit4a1l1ZWRHcjMrMmpaNDVkbVlrdWg2SVg4?=
 =?utf-8?B?MXJuZlpiSi9Ib0pidmpScXgwbHhFT2FyYUpabCtCUURhN0syVWZEd3FHVFlz?=
 =?utf-8?B?bkp5amNNcUt3akNGYnNLWXVKaTBta3UzL1VqTVUzb3d2bGZraTd1ME1FdC9K?=
 =?utf-8?B?MCtFZjRWeXE1cXpVeTlCRVNTTlRlY1pTSytSeUgxVytBWVdzT0dtVXpSQzVX?=
 =?utf-8?B?TmtmSk5Ed1R2c0FQNXRyVXRSbURwQ3orOStMOFhMZ3FMb3ZFc3VMQThLNG9Y?=
 =?utf-8?B?WE9yYVhXbnY5bUJWMFBVbXdLd09MVlFXOHJXclhqdlZpQlRWdmM5Sk8vR2tR?=
 =?utf-8?B?eVZIK2RtbTdIY1Q4OTZnYmFjTmhLcks2WFUzNHkrQWZYbHhzeVNiY2laSjR3?=
 =?utf-8?B?dkwvZzZwWXJvVHlYK0taT0NHSjdLcmVGNVZaOUZiYUZPR3VrZUQ3dnhpNnNW?=
 =?utf-8?B?dFpKKzR3OGFkNlV5cFpaQ2ExdDRMTHdGQ1FLK29ZNXNhbktKWTAwVFVIWUwy?=
 =?utf-8?B?ZVRKYTFzQmZDMFZhaW1TREU3dDVoRU5YTEMwejV6K3VBZFRCNitxSiswMnRK?=
 =?utf-8?B?aThUck5BU1R6L3pDNGFsOHVCNGoyYUU3WWEvNDAvM0pXL3lrT1RPcFovclZI?=
 =?utf-8?B?VTlnOXMvUStFQkQ2WHZHYW9YTnIxbTdPRHBJVnRNVjQrZWZtZVhXcHlPN2ZQ?=
 =?utf-8?B?akdnZVBJeWYwYjYva0hzWlU4WVZpOHBFanpjSENzckpVU2dvWjF5RDM1dzJU?=
 =?utf-8?B?dzlrK1F4aFVaK0d3NDJTaDM2Z3pwdmozMG13WThWTW1WTXdWRDJuRjM2a2Iz?=
 =?utf-8?B?UzRnL2JwUUowUlNCeDJjalp6dlh2dGVNWjV6OEVTcmFnREJnS2FudThuRUg2?=
 =?utf-8?B?WDVqRXc5OXY5azBtODFlZTNWczFCVFNBMG5wcVRaNEVTbnJMS1ZiaWVINklw?=
 =?utf-8?B?OUkzTXZoZ0dMU0t0YURVNDY3UnZ3RUhyNXdyKzc4eDQrVWdIaXcrRHRCWFlB?=
 =?utf-8?B?ZFdiQmV2dERmWnlub1VLcVN4dnJQb1hGZTIwSDM0blNBOE04dVVaMDJyS1N0?=
 =?utf-8?B?Z25HVDN3NzJpanZtNk1FRUQwVUJ2emlDMFFQTTJaZ3Z6VVRhTUF6bVc1U1B2?=
 =?utf-8?B?WmVpbER0aitrdlhmaWxDU0hFTkFuV2xNVmZ2QWx4dzNJZWZWcnk1TGxiUUpY?=
 =?utf-8?B?TzVqZHJqSmw1czRuYUo5UU16QzhQaGh1a1JkdUJyb0NxUDYyVGZNS1RiQWNV?=
 =?utf-8?B?cWpoaEZPbm05NUNuWVd2WVp2M05jZ3MyY0trR2d6ckpWa2d6R1hjTk55TTdy?=
 =?utf-8?B?Z080MmhOYmJpb0paZzNleE9hZjByUTBSNjdjWHRsYmRZem1ndC9RL2lwZUht?=
 =?utf-8?B?Y21sRGNkNDZDWFAyS3dVZitzVUFKTE9MVFA4aG9Od3BqaEcvc2kyaGlYamUr?=
 =?utf-8?B?UGI1TmlWVUdmaFl5WmNqY3A3NldwcWJwdUcydUtmQkV6d29BWWJXZWs2aXZN?=
 =?utf-8?B?VkRwYzZUNmVhcHMyN0E5UlVKaDRqb2ZLSHU1WkEyYnZSZmVXeUFia2lzQWEx?=
 =?utf-8?B?S0lJaFJFMTQxbEtINThRQlQrOEhYYzdDVC90ZVNseXVvQWk5ditIVDFmYW5T?=
 =?utf-8?B?b0JuZ1dscVNEQi9Pa2ZXUmh1MGRTam5jVFdycCswL2M2QTJZcGZjbHErWWlD?=
 =?utf-8?B?SnN5NklobTBlVzdENGQ0eHdSTmpvNktOM0dNbnl4d3cyV0RJakl3dGx5U1RR?=
 =?utf-8?B?b0d1VTY3L1dkYkNkYmo1YUljZENIVGxTdVpQY2tMaUp6ZThmUlUxM3g4ZXpO?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zW438uDEn/80Aq3kANNV9CH/u2hepR5iNtfmTJz3ew28f+ytbyCZZgXAA5PTLTzsACiCDynG9Z4jhhiel7H70akqazUJd08MY8ahlwQch9RCP6XKcjLjuOBfmTf1e9kl78MNV2ScQoZDtwlDq0NQjosjDuC+r6Z+n235thnrngcAoPvLdIK3UUVIq5l9VOQyb/B1/tVNCu/QwOmWVehyNp8Bj0ocdmI8U6ckYppZZvf5neYFNABHbg2gerLnv4jRngEG9K2LSwFeC6MV7peTdYlY+rjAFGd2cWBs2PO4i+AF8XDoeeb6Nr4rDPgsV2HPUbfg8ZwRKDpUklZHEO6jTLhmOeesw1dFMSbGXuDwU49C6hoqqmyoPRlp/If55q09TDRqtOW6fNl3rr+YfqTnIKqkaSdyj+trY+putB569IKXkvzHMlqiwdCkNtdSGc0cFCe11UeTuXLBPYuICFfv+b79rgG1wDQkgA+USJYBxU3c+gW2xprOxW9GkjIRupQRnppooMbuvHyC2G7VRsuS4vuVwuNlwjSeyQmPE42q2SSNHKI7tYzDh7dmlUf1gVLvtj0CqeQfyvFLtow7PFgFUr7y26nQyRI4dsf1OIyxF5E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970df1fd-5f31-4f3c-a98f-08dd035b17ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 20:46:33.7918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAZzPtS0IJ7xFAaHPlUzX2Rj5NH88TOdI9T6JYq1QPr137wj9COAT+xky2D8j3effZu/RrOTmw8VebGv+om6KyYCkkAc1ykNgSOc6bydnEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_09,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120167
X-Proofpoint-GUID: SFPpACcLylmCTvvvA1LZBKfDvXXAB_MJ
X-Proofpoint-ORIG-GUID: SFPpACcLylmCTvvvA1LZBKfDvXXAB_MJ

Hi Bart,

On 11/10/24 13:15, Bart Van Assche wrote:
> 
> On 11/8/24 8:45 PM, himanshu.madhani@oracle.com wrote:
>> Here is a very early RFC for multipath support in the scsi layer. This 
>> patch series
>> implements native multipath support for scsi disks devices.
>>
>> In this series, I am providing conceptual changes which still needs 
>> work. However,
>> I wanted to get this RFC out to get community feedback on the 
>> direction of changes.
>>
>> This RFC follows NVMe multipath implementation closely for SCSI 
>> multipath. Currently,
>> SCSI multipath only supports disk devices which advertises ALUA 
>> (Asymmetric Logical
>> Unit Access) capability in the Inquiry response data.
> 
> Something very important is missing from the cover letter, namely a
> motivation of why this initiative has been started. Why to add native
> multipath support to the SCSI core instead of using dm-multipath? Isn't
> one of the goals of the Linux kernel not to duplicate functionality that
> already exists? How does the new infrastructure compare with
> dm-multipath from the point of view of performance and functionality?
> 

Sorry about missing motivation section in the cover letter. I'll add 
that in v2 when I am ready to send an updated version of this RFC.

Here's motivation

1. Having native multipath provides a seamless configuration and setting 
of multipath with SCSI, which does not involve any other dependencies. 
Especially discovery and assembly of raid array. My motivation with 
native SCSI multipath is to avoid having any 3rd party daemon to do the 
discovery and assembly of multipath devices, which can sometimes create 
issues if devices are not discovered properly. The implementation of 
native multipath will avoid all that additional steps and by virtue will 
provide plug-n-play capability for SCSI multipath configurations. Also, 
having native support will help modernize SCSI code with respect to 
multipath support and provide tighter integration for SCSI stack.


2. On the performance point of view, I believe that switching to RCU 
based path selection logic will provide faster path fail-over and will 
improve overall IO latency. In this RFC, I have not spent time on 
performance collection. I am hoping to provide more comprehensive data 
with the next RFC update.

I do not believe this is duplication of functionality since I am 
providing in-kernel multipath option which will provide users a choice 
of using native v/s out of kernel multipath implementation based on 
their needs.


> Thanks,
> 
> Bart.
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering

