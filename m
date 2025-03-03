Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E9218851
	for <linux-scsi@vger.kernel.org>; Mon,  3 Mar 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741023506; cv=fail; b=oryeaunXJO/9Ryz6TxMmdejpS1zi8UHriGP26PjJGQxd/j4q0y6pENdq7XFeO7RZgUuEZRAyg52NdGPsPjpOqlskYXpBsHQU6eSdlFpOhcc69Y2qc1I09/5v2ePaF0WZO9MVOv/sic/1UQ3PVAloQSYn4olYVTmoZ0MuU9rFgb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741023506; c=relaxed/simple;
	bh=aMaCZy5tjjSj+vhwHf4jkeuq0RdJXbWBIzivRJxsopo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=diKbq2C855ggeKFTIVeguR4JNkM51Nu5vu20w9Kh/z8nwIEqbSgVlCUH1Mv4C62Iq7ELiEFyEoqATIZZV5JtLTwflCukCbqenM1y5N+qWeJbXHohZkIKe8vAwVnMP973VH/AJ0Fq6GTBrQxtctrzIQEyA290XDWhbMzZAMGzhOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m13k9eoL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OhPP6CJt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m13k9eoL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OhPP6CJt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523GH5q9009359;
	Mon, 3 Mar 2025 17:38:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eAehctvrsalcNcZVqrxihM+0+Z6E7LcY1scc7208BQY=; b=
	m13k9eoLLvXhZ76RJlOVzIY7SdsC22VTnDFnlKNhM1ckCxdhbjzGe1yC4RQTjFVK
	ENfeJEf4rmRmq3L0n1Ozm7X+8jSYn/b9wdqbsof/fkgIuoaXE3oWv7JwLEZ6NsVB
	uOnqheTE85E8udggqHyLl97X5ka98UQctDvIWT0BrzvwvJSgXfo5bMXXvCmoV/As
	NTcYeZDxTUdo+2F9QGCI014LNIR0mlW2R5xfuuU7A19oh7ZPgrE+Io5P78aEsGH+
	iNyJdJOjw4YUUx7DvNtfWYPBUOp0j4MLvSUhJQh10Vg7cpIQWkepRLsUQgAhfQ6U
	YPsvl9KXNo315g7A39jhWQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wk6gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 17:38:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523GulpK010963;
	Mon, 3 Mar 2025 17:38:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9b4r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 17:38:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDuVqIJXchz9KEEq1ZIPgvk+XOhx4+O2ygZc/ELxg6FpDWXwxC2SCW1xs2MqOqk4G9f1BFRKUGRe7dF52rv4/Guhay+yPnaXk3OhRqw/Y+X+E6XdKjAwlDTV9S8MeOC9zPFepgKgqDvMQLSx+vam9zw3rPRbzooCkIJ0EVa1qFShYZNS+4NUFBHupIyjgcKBqVI+r9n3CQDYASy77qpWhrYIUDhkF/dSYEXmiJ2cvJKH2opDISJfRG2bTe3sza6rG2Q8G++UWFF1kRAHWiTThrYdQTM2Y+kDkQ3ERYkco6ZG/D54Xi+3EdH7X3uMcaLOp95c6LPz1fNfpcnjornrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAehctvrsalcNcZVqrxihM+0+Z6E7LcY1scc7208BQY=;
 b=wxLhQtZCImoORMmwg3y/s4E7D8xQpNgUmJEwxAlMb6+Zb7mch7hJ+PTofSXZKE2LbgXKPT3ne7MYdCQ6AgoRfo4ea8mRBR0CH9ylp70nnsvNJWLBVhsTjT5NWsB73HA75hc0DxkzxVB5EcwPJc9oGePGT6aOjBOjOrHtzRcvGa3ARJnGj4phUcuxzAJZJW4TUWRWKFVhP2xgMEG7CcHl3TNiw+oUPZqGod4nkNnkF/Et/uWSJBBHSE5AZx5eakUKHIyRbr7b9oSvm+geGni5rS1DP4mLWRRLLPVrfHe70rgUuKMmeY1DxLnviaYSIGuwUYdTnOmY8DuJZeaXCJwj8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAehctvrsalcNcZVqrxihM+0+Z6E7LcY1scc7208BQY=;
 b=OhPP6CJtYCHfMDbyRYs1dqVRXBOBIQqgxtnLahHGE83s82vWzj7BRBaiLuzhP3M1c4uAq/YTmfDHIp0BY7HpuxRlnHi3UyUbNU0hrf907YNW7eWGzE+AqGLEeT5de+FzA+Tmt3qGiiEW4NY4qEtM2LwNc40fG0obrHAZNIBL0sg=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by BL3PR10MB6187.namprd10.prod.outlook.com (2603:10b6:208:3be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 17:38:18 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 17:38:18 +0000
Message-ID: <440e8b87-7c4b-47e7-a1c8-8b15f248ecdd@oracle.com>
Date: Mon, 3 Mar 2025 09:38:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mpi3mr: Task Abort EH Support
To: Chandrakanth Patil <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        prayas.patel@broadcom.com, rajsekhar.chundru@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20250303094004.93770-1-chandrakanth.patil@broadcom.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20250303094004.93770-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:208:a8::16) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|BL3PR10MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b80d95-58c5-4ba1-d7f5-08dd5a7a2f35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGJkdjlycTFhZnh5anpQK3UxR2FwSU5FTjlmNXdlUE01RUI1M3JqQjhlVURF?=
 =?utf-8?B?b0xHdllkQzY3eFhUeXVUeHJJMVFDWHg1ZmV2MzI4cXo3bjlxSUlHUExmSTVV?=
 =?utf-8?B?VVcyL2x1VnhpYXJmYm9FVWkyRkdGNXE5LzU1NU8wS0FBWFZXbTg1elVycnds?=
 =?utf-8?B?TE5pV1JKTlBhcGVtVGlYbEtDWlNaSUVuMTg1SGxwRmM5czdMSThpQlYxTWFQ?=
 =?utf-8?B?ZGtBZWlmV3lFM1I3Q0xYZTZGK3hob2lic25VQVgvcndXRGhTVnlCbjFSMDFN?=
 =?utf-8?B?ajdwNmhkOWdDZmJHN3BRYTNZYkw5UVVEbk91NWpCNVQxZWw4T1lmOTJueFpu?=
 =?utf-8?B?YnI4bHJhdWNMZS9yUnQxL2ZON0tlekR6djY3S0daQ0taS0ZTMVJLZXZ1OWd5?=
 =?utf-8?B?UmZoNHVkaUIrbnVLL0ZwcStBWnBJU1ZORnVlaVM0SUhJaFIxSFk5V2twZGYv?=
 =?utf-8?B?UUh6aWluZGdTalNucXlSL0xTSTRVbmpBL2F6aG1peHRKNjFHeUJ4Z3ppQ0RH?=
 =?utf-8?B?aVZjc3NsU2xPdmFXbWx3VzhoSDhJWDBMeFlDdXNnZGY2R2diZmNDaG85VENk?=
 =?utf-8?B?RnVnNzUwRis1dmxaYXIweDAyQ1NrcXlLRnZyOGR3K09lRnV4b3dDSTQ0VmdX?=
 =?utf-8?B?aWdMVWtqZ0N3Tmx5Z25XdWJTZnd3M0pUZWlON0lVdWFOcWF0SytrWWZyeHRL?=
 =?utf-8?B?SllhVzE4ODkwbnZVbzV3U0NUTjVLdmh6c0M0dys2ZXlvVVN1MjRFNXRrcTYv?=
 =?utf-8?B?MWgxc0Z6UWNGUHNtaHMzb28vVDhYcmlwSmwzZ0orZG9KY2ozd2VOcldTMWg2?=
 =?utf-8?B?Mkgvc2VBUE83NzJna1U5eGdRYitUaWQwQTV2cGVOWlQxaGxZd1pnN3dNeVZG?=
 =?utf-8?B?aW1NemxleEtrS1lhZHNRSG1hZXZtQmdpL2UxVlJmdmdDQmNuZWQ4bkVHRk1j?=
 =?utf-8?B?alVIYnRQaVR0enRpa01FUldmNitOWHR0MWY3T3JWRkxsdjZxZWlkeW4xaEcv?=
 =?utf-8?B?T0gvVXZvbS91RjJyQXBaR0NwNk9yNXIxRzdRY3d1ZGtLWmtvQllJamZ6YnJo?=
 =?utf-8?B?OXNkeG53Si9WMEZtUUJqTXpjOUNDSmJ4bGpaTEpreGF0Q1JtZ2lRdEl0eXVL?=
 =?utf-8?B?MlRmazZzUm8rbFI5Sk5qRjJPbnFhVDhCNmFtd2JFYlBvSmF6b0lkWVBaSWlV?=
 =?utf-8?B?SWZxVGtrR0gzN1dEMFF2M2hGM1FzNHkrNHVMVk5UbFhyWWsrQnFMT3JlS3Zw?=
 =?utf-8?B?YTR2SHZ2dElUdmlvbXpiUmIvUjZZK3Q5K1lxbi9YVk9wS1M1emN5c3MrdGtj?=
 =?utf-8?B?SkhFNnphMTBBWHFVTVg3cFJWVHBxNmI4dCsrNTZSaGFzUVNKMG8vYlkxWHZj?=
 =?utf-8?B?Sk01K1hGQS9id1FVZ0FWRS9MR1RNKzNiVUVCdUNEQmE0eTluRE9xVFV3NG01?=
 =?utf-8?B?bi9Qb1lQZ29MbklWZFo5d01Nc1ZBVmdQUlNhZHA3OFJ0VmZxaVhkUSs4TnZB?=
 =?utf-8?B?NFE0VmpkZkVTQ2Y0bmM0YzFZNG1LbkZQcmxUVXAxblFkOXN6TWdrOGJDK2h3?=
 =?utf-8?B?N2NXbVZpUHB4M1l5bHh0L0pEcGhzakhWYmZUQ21kYW56YXhJUnVobjVGcUtZ?=
 =?utf-8?B?QkdWbUNjeXp1ZjRneUF4dXFMUW8xS1d0alFmRW9VSk9RMzR6UFd3QUFCbndQ?=
 =?utf-8?B?SGdxZE0xay9QM1J0V3AraGxOZERZc3l1VFB2OVJBZnNPUDB0alo2bkEybnZx?=
 =?utf-8?B?bDVqS3gyTWdQRlZweUt6SmJzZmFCamRVeTgra0l4bmlIRU5naEVUSlpZZ1RI?=
 =?utf-8?B?UC83QnlMK1lVblJWdnFnc2RIeWs4elFHOElLODBUckJ2T0FRNkUyL3I3Z1dI?=
 =?utf-8?Q?Mau8P95REQedt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUZJZkxOVFFiVy83TlBabkxSQ3Q4K25adS9QQWlhMW9la3VuWCtVRll3NXJ1?=
 =?utf-8?B?QVl3K1JlcnlWZU1oc3d3UlVjS0dZYklTeHpJdHlLTjl4VjRYbEMxKzRmeUo1?=
 =?utf-8?B?Z1lGVkZZUFV3cHY5S3RQUU9lcE5YRmp3OWJuRHBScEkrR1lhd1g4YU05VW1F?=
 =?utf-8?B?WlVBamVXbTJ1a0d1TUMxVkZJOEs1QjN5NWdoRTR1YnhESmJ0TDRMRklobXYz?=
 =?utf-8?B?djZRQ1lkVXVnRFRWNUx0dHF3Y2c5MndiZVIrc1lCNFRZY0hPNTQ3RXluMm1r?=
 =?utf-8?B?amtVK3dKdjAvc21IRHRtckswTVBYK0lDRGkzTWE2VmxDWlFva2FtVVNmckhl?=
 =?utf-8?B?UFBUSVZUcG9JTjRNNVBESlRWSGZsTUxBZkdRblZsd3YxQjRUYm54T2VpVUxE?=
 =?utf-8?B?aStSd3VqaGpvd3MvMlZOemJPQkc1Wno3TE85am5pS0RmdHZRWVg0aFFBbWcr?=
 =?utf-8?B?M1RxSmtzWTlodi9NcmJjVWU4cGxMWU1zQ3orak9CSVpOMjhJK3BvWmJKVXp5?=
 =?utf-8?B?RW5JSW9lMG5ua2dhOXpmZ2VVdDVYNFhJUXdGbFg4NzM5NThqbEtnTnVSQmRR?=
 =?utf-8?B?RmNIeFl5VFR4TUNDbnpNa1E2L2FNUld6d0ltSWtHclhJeWZTcUNLV1VQUTJH?=
 =?utf-8?B?cW5jTFFrbU1xWklsWDAzdkwzYmgvV2ZiMi9iUVBGRHJqYlhiMFhiSzVkYlVY?=
 =?utf-8?B?TFduR3NoOE94Y21xVjB0aHBXSnlSMEhrOUpYcnZzNXpoT2ZSOWJidkxDbjdt?=
 =?utf-8?B?aXMyU2hKeGdHYWZKY0srZUZTejllOFFWbXVna2dVQkJWMFFtS1N1UXlwYStJ?=
 =?utf-8?B?L09BS1l4NUwwUVVjMW9mblljWlpQWnhNN3FOMXFMa1ZEbHErNEEzbjM5b1Fq?=
 =?utf-8?B?L3p5UkhFVWNaN3RjMGtvbnhXa1RBZWZpeHR2ZUVJc3pMR20vbEQxaXlxV05w?=
 =?utf-8?B?aUVWMUg0QkRJU1RnanBlNHZwQTVuaGNyVlVIbXh3RlVEbjV5VVU2S1lRa3Zz?=
 =?utf-8?B?V2JPR1g3c1lQM0lOUndHK1RtT25iWXZsdlVZMkNtTlg4ZlY0N1hwNUVlUThy?=
 =?utf-8?B?UnV0aEMyRXY3SWF3dVlYT2RKd0lzb0c1TmI2ZHlkM2RheVJ5SEhHYjRabEdS?=
 =?utf-8?B?WEZhOGx1a2IyVVZNWHo0L04xWmREQ2hGWVBBSVM1V0NWUS9iY2RrR21GOERX?=
 =?utf-8?B?dHdkbUk0ODdqbWNkRVIwRTdGaEM0aytBeTFLcndJb2N0Z2Q3V2tuMFp4Y1BM?=
 =?utf-8?B?dWJsS0UxU0RQbi9sTGVDVG5ZR2dHWkJFYkh4WU5iWXZibHhCYnhvNWxaY3N3?=
 =?utf-8?B?cmV5ejNIV3BDbGJ5WHFRMkVONkhxMGwzOXpyc1lXTDBoMVNVaGtPcnUvSEdh?=
 =?utf-8?B?ME1jVFJrMEVsNXM4Y1pmVjBpbE5PUEJkZERLaU9XQkJ3L2VRa3o4Y2VjWEc4?=
 =?utf-8?B?N2dJTW9PRmdxcGMyRldhTy9IKzRHamxsb0poNktGUkdIS1BHNER0akdaZ1Az?=
 =?utf-8?B?ZHlOdXVDS0xTKzNpejlSVmZSUXJHbFBnVURqZ3RFa2JqM3R1Q01wd2Qyc0lz?=
 =?utf-8?B?alR2MkxxcXBFTTZDNGVUdTVZQWRIUmxNUmlMWTVSUUlsZnVDMHE4Ym5SQldu?=
 =?utf-8?B?YkhXTUpLMXZVYUkxY0dKZnZWeFBBK05TSml4cnhqVGFWNmhMem1yZWZlaFVI?=
 =?utf-8?B?SUd1ZTBBWEJnUDNiNG1RWUJkN1NFUDh0NjY3TUlMVUdDMjJ5amV5YzVHeXUx?=
 =?utf-8?B?YTFHSTQvVTNrOHd2a3hxYU5jTTdvK1JKS3BaNy81S2tYWFI5QWE3Q21pb0la?=
 =?utf-8?B?Y2MxWUZsY0RzbzJ2YUNhVk9PbHJ2ejNiK1p1S0tTaTIvTkxtRjl5ejlmZ0ps?=
 =?utf-8?B?VUp4bndxUU90dHNrZDkwY0VTbGZGdDN0eVZoamFCZGI4SnBLcVlhbSsvZHJE?=
 =?utf-8?B?K2dzazltWCtIOFIwaXF1bFdaRXl2WE5TZVR5Wk5pRVkxZzJnZFhnRkZJQS95?=
 =?utf-8?B?d1VKQzdxSGs2a2Y5VUIzaUZ1SVVwdFo3Z1ErbDVNYTRBTG5Ua0NZMWlHTExh?=
 =?utf-8?B?S0lzVUUwU3cvZ2gvQ0JudmFyU2JkNlFyTkdIQzBXRXJhWmZqT1RYREcydHh3?=
 =?utf-8?B?aXIzOEwreGVId2R5ZXBuQWpqQWpTYysxU1lRb203RGViZUlBQWE5QVhiZm9w?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	De4u3TBBHq7WZR9v2B9KCnn5Kvr0VV4kq8Wmfu8yeaqMq2Zew0KlZgzi3lZvhFbXopLWtmchNqQGCuSITISuaidxafExtCEJY1P13DEQb6CO5TFi4T5k8WxBvCIoesMKhqHjkGYJXoHXNstcClyN7CXOW7a4EjBeI0aDwcsF5GvmgmJBcYLvNHCo8SgoZwGGqDLv1iNgfQGadqx3R3u1lhHLv4lNrsL/mua4fLnfyfQVNj/AODKQ7RBhpHKZrFc44gfYOY2VYYS4mLRTWoLBu5kEJlxCIjsfyu0tdaFm824kg7u/GaJnrTg2a9Bf4ZhmAUtkO8ZSH+u6hESol7TVs5e0WvCvmpgF6DhiEr0Cr7lJX4sesmjKwCsEgntVCohsQQfhIbLV7bMAMyjk3EE615ikyLTtM2hfleuqiYFZqR6iXOsKSWLxOhUNqRk/PC1I+0gGl7dE/qfEE2haP3oCwDleeGAOH5eervNNrMCcnASc3UJ6tNO/QzvvxkHwiTltysplrjq86C32sfEqJB/uE5rPGJLP17fZ1UUF7qCQo25we8lTV5gRB9SXnD6BYgFfW8PevAIwkN1klON0n8iFvtVf1THoYCHnSjr0EcMFWFk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b80d95-58c5-4ba1-d7f5-08dd5a7a2f35
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 17:38:18.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43izsF71gek69W61c7SaMJxZw7+iHjBSOZCbl+ySY9neNcb5F1674Rvak5k+qglSQ3ouIkFLabAfOf4UDv0Og4fquRsHxMalxWx4szzuqGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_08,2025-03-03_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503030135
X-Proofpoint-ORIG-GUID: 3Zy2fBbuZ9xSnbe4BPdCo5aIqitJ4Fui
X-Proofpoint-GUID: 3Zy2fBbuZ9xSnbe4BPdCo5aIqitJ4Fui


Hi Chandrakanth,

Code looks fine … just couple of small nits into messages for better 
readability.

On 3/3/25 01:40, Chandrakanth Patil wrote:
> Task Abort support is added to handle SCSI command timeouts, ensuring
> recovery and cleanup of timed-out commands. This completes the error
> handling framework for mpi3mr driver, which already includes device
> reset, target reset, bus reset, and host reset.
> 
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index e3547ea42613..6a8f3d3a5668 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3839,6 +3839,18 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
>   	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
>   
>   	if (scmd) {
> +		if (tm_type == MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
> +			cmd_priv = scsi_cmd_priv(scmd);
> +			if (!cmd_priv)
> +				goto out_unlock;
> +
> +			struct op_req_qinfo *op_req_q;
> +
> +			op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
> +			tm_req.task_host_tag = cpu_to_le16(cmd_priv->host_tag);
> +			tm_req.task_request_queue_id =
> +				cpu_to_le16(op_req_q->qid);
> +		}
>   		sdev = scmd->device;
>   		sdev_priv_data = sdev->hostdata;
>   		scsi_tgt_priv_data = ((sdev_priv_data) ?
> @@ -4387,6 +4399,92 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
>   	return retval;
>   }
>   
> +/**
> + * mpi3mr_eh_abort- Abort error handling callback


^^^ function comment should be reworded as "Callback function for abort 
error handling"

> + * @scmd: SCSI command reference
> + *
> + * Issue Abort Task Management if the command is in LLD scope
> + * and verify if it is aborted successfully and return status
> + * accordingly.
> + *
> + * Return: SUCCESS of successful abort the scmd else FAILED
> + */
> +static int mpi3mr_eh_abort(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct scmd_priv *cmd_priv;
> +	u16 dev_handle, timeout = MPI3MR_ABORTTM_TIMEOUT;
> +	u8 resp_code = 0;
> +	int retval = FAILED, ret = 0;
> +	struct request *rq = scsi_cmd_to_rq(scmd);
> +	unsigned long scmd_age_ms = jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc);
> +	unsigned long scmd_age_sec = scmd_age_ms / HZ;
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +		    "%s: attempting abort task for scmd(%p)\n", mrioc->name, scmd);
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +		    "%s: scmd(0x%p) is outstanding for %lus %lums, timeout %us, retries %d, allowed %d\n",
> +		    mrioc->name, scmd, scmd_age_sec, scmd_age_ms % HZ, rq->timeout / HZ,
> +		    scmd->retries, scmd->allowed);
> +
> +	scsi_print_command(scmd);
> +
> +	sdev_priv_data = scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +			    "%s: device is not available, abort task is not issued\n",
^^^
This message can be reworded as
"%s: Device not available, Skip issuing abort task\n"

> +			    mrioc->name);
> +		retval = SUCCESS;
> +		goto out;
> +	}
> +
> +	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +	dev_handle = stgt_priv_data->dev_handle;
> +
> +	cmd_priv = scsi_cmd_priv(scmd);
> +	if (!cmd_priv->in_lld_scope ||
> +	    cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +			    "%s: scmd is not in LLD scope, abort task is not issued\n",

Same here, message should be reworded
"%s: scmd (0x%p) not in LLD scope, Skip issuing Abort Task.\n"

Also add scmd pointer for easy debugging in the future.

> +			    mrioc->name);
> +		retval = SUCCESS;
> +		goto out;
> +	}
> +
> +	if (stgt_priv_data->dev_removed) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +			    "%s: device(handle = 0x%04x) is removed, abort task is not issued\n",

This message should be reworded as
"%s: Device (handle = 0x%04x) removed, Skip issuing Abort Task.\n"

> +			    mrioc->name, dev_handle);
> +		retval = FAILED;
> +		goto out;
> +	}
> +
> +	ret = mpi3mr_issue_tm(mrioc, MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
> +			      dev_handle, sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> +			      timeout, &mrioc->host_tm_cmds, &resp_code, scmd);
> +
> +	if (ret)
> +		goto out;
> +
> +	if (cmd_priv->in_lld_scope) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +			    "%s: scmd was not terminated, abort task is failed\n",

This message could be reworded as
"%s: Abort task failed. scmd (0x%p) was not terminated.\n"


> +			    mrioc->name);
> +		goto out;
> +	}
> +
> +	retval = SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +		    "%s: abort task is %s for scmd(%p)\n", mrioc->name,
> +		    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +

Message printed for Successful case should be "SUCCEEDED" for better 
readability. Something like

"%s: Abort Task %s for scmd (0x%p)\n"

> +	return retval;
> +}
> +
>   /**
>    * mpi3mr_scan_start - Scan start callback handler
>    * @shost: SCSI host reference
> @@ -5069,6 +5167,7 @@ static const struct scsi_host_template mpi3mr_driver_template = {
>   	.scan_finished			= mpi3mr_scan_finished,
>   	.scan_start			= mpi3mr_scan_start,
>   	.change_queue_depth		= mpi3mr_change_queue_depth,
> +	.eh_abort_handler		= mpi3mr_eh_abort,
>   	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
>   	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
>   	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,

once you fix these messages feel free to add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

