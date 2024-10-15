Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DCD1F5838
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729022240; cv=fail; b=GAtJ2PY8auIgrW73jZKF5mL564nlxC4b0dgFTqXnkgdlHzIUZw5gLVniKYgfo7u7YJDG1ZqnBGAHpFYDpOPWkLkQ9wFlHoSRJecNM3kzsvgP8EjRO6AdCbr6qiaQd3cjEpDM9aqK+NaJ4oiv6d45OiNQUvvjqwf2bN1/TTWihBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729022240; c=relaxed/simple;
	bh=URLzHfWb5VD7iyYiACwZ0AFEj+7HcAqcVB6Xt35xYo0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=De9NdFPtwmUV6YjNg5Zp6uUK/uI/b7e1NK9Fcsc8+MvHsx6fnQHu5BRE5rW0Y96p/MZ5K1J3jsYnDKClSiNiz0jrqK/qzDidW0r+mAdMCieKLcLQ/bJnOVYItj+vmEQKo+DzmWIHcqTH8I+nGa8jkxdbJKL3QJAoPpSi5cmBU6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U5Ke90cb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fFvnrug2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U5Ke90cb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fFvnrug2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtf49008248;
	Tue, 15 Oct 2024 19:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PJGs+b2s13eR71iesNQk8EK/Ev1iWY4KWE5B1FMOpOA=; b=
	U5Ke90cbWj88q+pHS0T5YDyz5umnk9UzX4EfEuEtGqVE1KgbmQvIVMlZUm/fzwC0
	6tMJk1u0jTHRUfCEnxaJnu74xPucFMrkbB9rRJ7GJn/nwPr6oGE8l/eKNNfa1op/
	OnahX62YZBxRYvxrsSzwym7hImR7EJVKCI5bqFPbo/S67sXwOK5o0o+sgszHS6iJ
	Bjd9Cvwwy4HUuSeUAHHUPOr03Sg4OMPVfoBVKt2ZgcLklCYEE4nt3KTqRdNPZeWv
	JdsjRhs87wmM/0wQY22PJzn8XqBAZ976HpfldWv5dZjArte/f1cvW4ubt7GFUrjX
	Db7X/3ZBsTYi8iCH3w/ceg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hnta5p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 19:57:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FIEnag011073;
	Tue, 15 Oct 2024 19:57:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fje84x1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 19:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EepzmyQZNCbJCbwMLjCCDAAq1F/j9mSvO5+bjy1kA8pLuKe+nKYCifpRitKGT16IXqWGlTbaC90ITPMZ6hFeCf9llZ9PSbig9ZSZLhmShtlC9zaV9ulAC0xQ1wk9B77SInmi9lvMmge7OBgoHziABe3iPlYtcz9yB9vqV/2fj0edj/NliyOMA8SGbdrMflKMSzi+w+m4e5xYhHRrPn+pP1F8vnwwmS6H1vivb0H61ZlNJwptd0W5F1jsGOnft8wuiKSwfBnB531wEWmYGcyf7fTLemsi1tJH/q7e9kBk2Q6TcIvDCoYLGGLX1dv4gRZe7zEzO0vGJP4AghIz7fj7Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJGs+b2s13eR71iesNQk8EK/Ev1iWY4KWE5B1FMOpOA=;
 b=dfSijX9uM8irTM9cHRoU9mU120odU3Wn4iaXljIzovEXoBdSXVcvfFhossKwfpCZqcmTvT/gEPXns15Ux82K6NopqT8B7RrdGhdB6OEj37V4qhXqfS32Vh5zXjzdIGYqxxD62kKIdPYrqD5cPsnvfvl6n0HRA3OLolrtE3IeSTg++co38BQnxMT4/HuiEbf/YD/ufI52Sa6428f+H/PJ4DWUt+krH3WKK1PTcboEcD4//SQC5DupVzlMPsHQOzB+Rsz2GePYoK2E56S4Fykh0gKNPqL6hTCq+0D1MHW1qgeHw8QJ2rz818kup8BX8C6OiSogE1pOV/nTz0aPIf0VeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJGs+b2s13eR71iesNQk8EK/Ev1iWY4KWE5B1FMOpOA=;
 b=fFvnrug27HnvDoU8OZr3GcH4tNZ//+8qk08YTvMD5T9Lscf9TBNq3IRQTXPYftRjaljQtlXgUBZz/zyLQVKS1CuHq2atMM5UnjQshO8T4elGOkiiWagQDVmlbB49t6R0wW8/qeoRVRSbdJ3LbW6bZe8fzP6JHGEjXuFVuotmAeU=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 19:57:09 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8069.016; Tue, 15 Oct 2024
 19:57:09 +0000
Message-ID: <2001a656-3bfd-4657-b47a-68192894ad18@oracle.com>
Date: Tue, 15 Oct 2024 12:57:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Remove unused host error code strings
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20241015183948.86394-1-himanshu.madhani@oracle.com>
 <6a587c9a-b573-4860-86b9-3a27572d39db@acm.org>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <6a587c9a-b573-4860-86b9-3a27572d39db@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|SJ0PR10MB4749:EE_
X-MS-Office365-Filtering-Correlation-Id: ad3c3a90-a088-41dd-33ad-08dced538dc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHY4ZlprcFpmRzM2cGM2Y0paK0U3UjgvY1FlaDd6UnB2bTU2ZzhTaTZsUVlW?=
 =?utf-8?B?Zk00WHljTFNwK042N2o2a0IwZFJ5byszVFM1V2ovVEpKWFR5YUJBS0psVHYw?=
 =?utf-8?B?QXl5bG4vZU9kUTdJeEdkSDVTY3hudnNSNkhLYTdDRGp3cFFBb3l1c1FXVUZp?=
 =?utf-8?B?a1duQWxGZE40OCtLRzJYUkdLSzhtSXBrQVhGbUVWR3lXSkpJd1A4bnA1TjVG?=
 =?utf-8?B?T04xdHhDM1BOaGkrV3cvSEtDWGJwRXVTaGhUTHYxY0lVSklxUHQxYW14YTRV?=
 =?utf-8?B?VHhCVC9UZ2VBY0YwZE94cURLYm1ieXB4Q3dPc08xQzBiQ2RCbzVhdm1RcEFG?=
 =?utf-8?B?WitpUjljVmRhaC9Ca0ZjUEFZb3IvaUF6eXhiMXZ0cXhOdERtQ2RDTFVJQlFh?=
 =?utf-8?B?Y3FSZkI5Z3hNL1NuV1d6c2lCUU5pSnNHMmVMU0Z3aWVPWXNXRmVydEtmaWM4?=
 =?utf-8?B?dnlMcXMxUy9OWEpiWERsWUw0Z2tGc3oyeVBlOEJtdW9abERSU05tVEorSk95?=
 =?utf-8?B?YVh0OEQrTzQ3SXkwR0FqUEt3ZldJZEFYSzdqK0RaMjMzZDQxMjFPUG9ORnAr?=
 =?utf-8?B?dDJaYVR5ZDR0MzRvckxHTjVXcFBWYklrelg4dzltVXkwSHlYN3NBR2R0bWN1?=
 =?utf-8?B?L0JHVThqeUlaMTZqZS9TOTgyamE4QUtVSjZjSWxtMXZPZWNxd1FsTlhEOThy?=
 =?utf-8?B?ZDN5Y0VNWGpVU0JkTzl6eUs3S0IzbWV1clVvSCthN25hZ2JBVHBYSld1ZjY3?=
 =?utf-8?B?K3MvNDA0cUtQOTVKR0dTNGNiby8weGFuZHBrZW5aZnpqS3VBQXhXM1Z2WlBZ?=
 =?utf-8?B?d0ZKcjVDUENJOER4Y1VSZTl3UkQrYkdWQ0tMcjdZWkFOQXFkL2NJRyt1MWdV?=
 =?utf-8?B?RnJ6azI4UWQ0Yk93SHExbG1Qd25PWEs5YTVuczllYVlkRzVXcHFMSEZTclND?=
 =?utf-8?B?MDc1bng2RWxWWFJTRXJBVnlLMm9Odng5ZDNaTVNrNmk1czRvVktJVUZ5WHpS?=
 =?utf-8?B?Zkl5OUs4ekpFNDk1RE4yVHhhSEljM2tVL2pIR25wditpVktsMXdRdVh3SjJr?=
 =?utf-8?B?UjZ6RHVDeFpVUUdXaVFpREg3TnhCR3ArS0ZVSUlXTmRjR1NXVzlpT2tRYXhw?=
 =?utf-8?B?U3M0RFNqOHlDWHJIQitNRkZRR1VwY1kxUU1jVVVyTUNpS3NscXlBLzNVR2Zn?=
 =?utf-8?B?VVRjVGpHSHZiaTJzVUpGUC9Da05HeTZrMERqcS9YL1R4N1lvRmVrSVJacGJR?=
 =?utf-8?B?d29SaXFydTdQeG9jNHU5Z3RBazFoMmVpSklHTDNxRjB5R01BVE9RV1NaRG9B?=
 =?utf-8?B?dkZLbU5xSENjVzRNUXlCRFhteU9jT1lFRXBWbGJkR3pXM1Rib2JyL1VCRXZJ?=
 =?utf-8?B?ZFo3UDJoVUF6VkdqTC9GaVBDeXVwMEJuaUpPaXBHaFpnL2JXNEJXdnJ0VTlC?=
 =?utf-8?B?UG5ndjRqTGlFK0x1RG5hcGV5NEFBUmpBMVQ3eXJUSUs4L09FbHB6RWw1UHJN?=
 =?utf-8?B?M042dXBwc092T1BvMW4yeFhIT3RQK01QUGN5bkdWZFJ0VktEdUZvSnByTURE?=
 =?utf-8?B?K3YvWGZIUUtvalZjNTFraFJhMVhuMnN4TkRZVHFWT0wzNEtPYSs3RFJOMVh4?=
 =?utf-8?B?WFgzSUlwUS9lUkpFU2w1UVYzV0JyLzVwakdPUmNjSENaNzBQcFh4TmhpZk94?=
 =?utf-8?B?Mm1aY2FyYXFMUFdvWlZpaU5jendBNTJNdTBBdFlBdFBLTDg3R1U5c1VRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3VYNlMwcStsYmE4YVA1V2ZUN1dNN2kyeVgvSjZ0anpONmFxczZEd3BRTmdM?=
 =?utf-8?B?MVRNMWV1MEx1ZkIyQlMydUlEQlMwV09EU3JQeDhxQUoydkFkbzFmWDNoZDh2?=
 =?utf-8?B?YWIyTUIxaTdwSmdOWkgvbitoVEtzOFpRVG52eWZ0Sy9qakx5Lzh5UStSWE1x?=
 =?utf-8?B?YXhCNFFFVmxGNXU1aEZYTlB4Z1dTMXVZRW1KdUxlRGh3K3B3OFB3bHczMW4z?=
 =?utf-8?B?aGVnNGlyTElYanNHUG5tT1hvK29LZVNwMW1BcVN0aG5ibDAxL3hQOWtoVEtI?=
 =?utf-8?B?ZFg2Y0xNS2YvVUMyamtadnp6N2ZMZU5hOUJaY3poc2VBRDBJMHBJZE9YbTBQ?=
 =?utf-8?B?aTFsUVFjN0VTdmMxVHQ3QVFoOHlqby94TWpNL0dwOGpOczU3dFg2dy82QVZP?=
 =?utf-8?B?aEpaTWZXaFVHbHFkeDdwa2ZuU0hMUnArTTg3YzR2TFFYakY2Mmlra2dwRkJ2?=
 =?utf-8?B?b2ZQU2txdEV5VXUxWUw2RFlJaXZrNlQva3pDQ3lGWU5uU1ppOHRRZ3Y5dlVo?=
 =?utf-8?B?R3UybHhDaFB5aW42MkxrbzJjTTZKVEJCeXFOSEQ2Y3c2WUVEbGRSemNoRk5U?=
 =?utf-8?B?djBGY3Q3RXNrSDlmWjIxZnlUV0F2WTF0L2J0NlB0Y0tvR0pWa2pJdVdLZDF6?=
 =?utf-8?B?MGJnakJCN1FiblExMlhnOFVNOGI2MTYwb2lvYkV5OVdlcWZvWjlTNVFQYVNq?=
 =?utf-8?B?UzI2YWZDa29JTlg5K05Ca2d2Z2ZNT3lTaWVpY0Y2SmFkMlExYVNpdkhhenlX?=
 =?utf-8?B?MDE0eXpQRUhjeW5yT2hhNXh0WjZYVUdBRWlIMGNxOWlyVTNiZC85VFFMRkRu?=
 =?utf-8?B?aGhqbmV5VUkvRFhXNUVTMnBpTmdFbUNtdWtyUlFKTjhzVnNxZWFocmdDeU0x?=
 =?utf-8?B?T0F5WE5mYmt6cU9aNDJHT1laZnVQZkd1aXJVZnYzWWplQ2hXQSs3dDlyQVh0?=
 =?utf-8?B?aEZTRVh0dXNoREIwWkVpYlVjWlVONDVUVFYrU0phdzFScWprRGFnQXltenhS?=
 =?utf-8?B?SjJvTWZId3dLeEJiZURLcU5kMWtlMWJNa2xXOXFJb3VsZ3Q2RTFLdEdORERi?=
 =?utf-8?B?R0Y0djhTY0lnR2xjSFdob05MWXI2K0RCcjlienFDYnB0dFQ2Qm1JaHNyTjNo?=
 =?utf-8?B?VCttVldnUHRycjJrbmp4Q0ViQVk0VlZKWkpKTDZGc1NVVWc3bmZSbWR3SXpV?=
 =?utf-8?B?ZUtjN0ZpYjBMRFY0Q00va1NFdDl6SG9vSytCNVVSTXV2R29ET1dCcnE2R0lI?=
 =?utf-8?B?bjNkNXk4Y0Z1SlZFemZHVUpHL2w0aVRUTGV5ai8yL3FYQ3VNOHpzM1ByU3I0?=
 =?utf-8?B?VjRPS1Joak9EZVdlQ3BDOW9tdGdjM0xqK2x0T0JSQmMzV01KYXpFNldnRWQ0?=
 =?utf-8?B?NHRBaU5xdk9WY0FlR3RSVyt4UVg0UWZxRWRiY0ZZUXZ6UTFaOVowMjlaUTB5?=
 =?utf-8?B?N1JzOUVoakg4b0pncHd5SGRYVWMxZUJ4MU9hN3RkMmo5dVcwMW5iUzF5b080?=
 =?utf-8?B?ZGlnK3hZOHJQM2NLSVlQZzBGQnlNQS82VEFWWUpXckJsU1k5ZXh3SmJBRjM5?=
 =?utf-8?B?eEppVkMrTU81bmljeUI1REZ5N0xSYnZBcWpVOURrVFZBMm05c3pFZnJCK2w2?=
 =?utf-8?B?RkF0Uld2ZHMzNU9QWExUUXVNa2VmMzRSQ3V3Lyt1U3NyOHJ3UXk2N1Z2a3hV?=
 =?utf-8?B?Y1owc0dtNEZPV09WTVJGblcvK2tVcXBZZ3AwOW9VTHpGQ0xHSEVIQVdyTXo2?=
 =?utf-8?B?dmk0SHZ1K3pEVzUyRWUrVEpReEV2Q0xHdGpISDZrUG9BN1NqZFJwbHBCWWpY?=
 =?utf-8?B?ai9vdlJOV0xFajAwRnUxZDJOemJvbW9SNHdUWUtBV3BHY1l6dU82blI1VDAy?=
 =?utf-8?B?NVczNWwxb2RxZ3poc3dTMm1VM0RKZmF5TXhKYjhScVRWZjRmNmtreE81WXRU?=
 =?utf-8?B?OXF4OTdJSnl1TVlJMmNUMEVJWW9EL3JqcjY3UXhyVXNjYndCK2ZOdkxIbkdZ?=
 =?utf-8?B?dzRKdm0zYnF3Uk9MSEpHQnVVWDRVTUszNTZFNUNxQmRQWXRlSTlzekJpRG9P?=
 =?utf-8?B?UmRpOEVpeTIxQnFHMVk2Y2U0M2ZXWEdjanhIVlV2WXJqVXJ3SXFjQ3gzWDhv?=
 =?utf-8?B?TzU0eVA0amhMSHduOWFSbVBiZnJVanJuZmp0bWg1bXoxRTQ3T2N2bS9XNmc0?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/son6oOrdzY/kXrae4GoYEiqoyDkJ5TUOFR97FQLkpuouymONoh2IMXc8kmO81+jY2PMwznkbo4FSlwZH1MeiSfqd7kbPprJedXcDTU4Iiwp3gEBzs+JobOIUlJW1oWwlwJrxA8kgbO19+wCy8suLZQg++pRcMCAH96PB4SNrMAFogw58SUIBPbLclrK8umQ+BAOdIx1wPvh5hMxa7rhMi0Cg+KYBAZWRQ/K96FeDw+jpfbQS6ncWYPUL/wGQ1yIZuNs8y0KYkmBL6fyd7NofYXPclHeXeUUvvhdny82ApoHRAP1A2j/xvH5nVAHZtc8BFKy2GnFZoPNlPsDhSIPmQ7dzlNG2DeOHDDjVsqxPmEEvloIN2uaSfQyg5fjeslc2hxdDeknVZkXXvTj+cWOVJBb5k/dqVgvP3uyUDScaP5eDSDUQKjIhIMIm7WFifD8WPZS//eQH3Lt9yOqzBuVo6ZrXwF2aAQDxbUSdak0wQlfivjjZHUKPjK7RrJEFeRc9opOsno/cAjSmZpD8wz8NTvBNq/wohLLQ3e8XprMwJ3j2ZPw0h6EEnCdZiE5/3jytZFiR4CI/oyIr2zOpWSE/f0dcdshMvlH+URjLaE50Es=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3c3a90-a088-41dd-33ad-08dced538dc5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 19:57:09.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hchxodcZ+SBD38LcT9cxAFDVaquKRdA87EvsoeyphEvsG3iv4B2eiv5boZPNhYbzLgbEnIG3YIbnnEDE5DknLzoVAdXl5lLNkScij+ftRZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_15,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410150134
X-Proofpoint-ORIG-GUID: f3P5-YUghlA15_nv5qqZPhBSg5PLAmh1
X-Proofpoint-GUID: f3P5-YUghlA15_nv5qqZPhBSg5PLAmh1



On 10/15/24 12:15, Bart Van Assche wrote:
> On 10/15/24 11:39 AM, himanshu.madhani@oracle.com wrote:
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 340785536998..b74c3f505300 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -403,8 +403,8 @@ static const char * const hostbyte_table[]={
>>   "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", 
>> "DID_BAD_TARGET",
>>   "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
>>   "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
>> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", 
>> "DID_TARGET_FAILURE",
>> -"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };
>> +"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
>> +"DID_TRANSPORT_MARGINAL" };
> 
> That doesn't look right. "DID_TRANSPORT_MARGINAL" occurs at the wrong
> position in the array. Please use designated initializers instead of a
> traditional array initialization list.
>

Can you elaborate? From what I see, enum scsi_host_status{ } maps to 
these strings. So, accordingly, "DID_TRANSPORT_MARGINAL" is placed after 
"DID_TRANSPORT_FAILFAST" in this array.

Am I missing something obvious?

> Thanks,
> 
> Bart.
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering

