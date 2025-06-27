Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF719F461
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751025972; cv=fail; b=ReLQ1D09tv+v5uCOpw6t9IShPd8JuLjaMPfS7yvX/KUEmEq/2Ebpa9kVwnuhpQG1+eH9GCnxxvnYYoG02vSd4sFKCWW8BeFYsyOucclHBFFJefOCT4faV2JNCdx7qR3kS6gzLk4kogRBj+XneB8xSHj+POjkg0IJ+sBHvEgT6Mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751025972; c=relaxed/simple;
	bh=DUCVGnarGkJgV3fJd9H7pgD6LHtDrFVLNPo868gVAzs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sv4j7slLfX46Cukv3eBVXosXYtjofq7RAQKbcx0DTQPKzNsBx05om30zXoJTPW8PHHUtLL3nXzkf8XLrlGwhi3UMXDeIJ7Wt0HtUQo9oTvuWKI5jv8Ii5q8I0mMe36986HgUrjjQTVmNDm70d+w9mrUf5T1zdL/dN3tUNP1//74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UfJ3QmzN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CwaQI2ns; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UfJ3QmzN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CwaQI2ns"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55RAcfRO015255;
	Fri, 27 Jun 2025 12:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eCmRULF1cBRfFJUO5Qbr/002rEg8SSSH4uE6TtjqIy0=; b=
	UfJ3QmzN3kPT2h5rLUBozIQKlVlRM7HJf9A/Bj3BtvmUzQbWbRCWZynWDoi07i/u
	nvCYEilFgxwMarmhpyhOlYqRXWJHitASMUB8IuQC62nIBTPi19ThRYwSqJ0jzhQ1
	ScBToedr9yGd5qqwjMGdz/dUzi1GsSY7W+TThIDc1IrimP08whM5o+VR2IsVqNG5
	Dg8m/L4kZJQseWLlzIUkndB8pbzQdY9vWQD8CxDTZQ9/5Vx5YUkuLFvlcrAPO7uU
	4v0sLdXNzee3K3BhK6WBJ0+94VRuos71O/6byxvyg1fKOx3SV07DHzdvje5+FS9M
	funblwbs0dJW/XUTgnFwLQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt5tqt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 12:05:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55RAQKqB034263;
	Fri, 27 Jun 2025 12:05:48 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehpu84hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 12:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmN+O87c2MhhefAKmCNQencJWk3OB2t8zIjP2FPJ+mpkRH2i4UUycblqUP/+nPBfzLlcy+hxs6LuvhcAGM611YecHvaSAAQvM4HvoANUkFbuGrtR0XVkPsNStH1T+eZR+FSWeH9s9xS4NNKkJtzSWHWQt/WJkmdcl+KJ1Cp5csNli8jih6UwVhGmHdeBp2vtT9EiDmqBQrFDHdqYIl5wMpmIHN6zZN9TeQ8DmXNTYhffA3sBsuu91w0yJHr0+ShJbZ3KapjB3znKr/dYhVe0GhKRS+A+tKvHVkdga05oQM7d6E74HGinVv+7HEu0SCAaWWuJxZn6IoMS3AKqIw6E7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCmRULF1cBRfFJUO5Qbr/002rEg8SSSH4uE6TtjqIy0=;
 b=vFdPDEYOHmWXOLKIFs5C4fyBs0df9OW4Gs/HdABdlcZNm2tooyZUvgJ98Y5tUK3vsEeZNx2jlZulW5p+Ba7Nz5Nl+xizT+LBEt+AEJiYEt+N1ULifAV3wDyYnWK28eM0Ye1wJlxsDuWZ9HhafjWwYKy3wYzirqkWSWAptvPwm6DDSpvEJlSCsdiv0iJ9UamEn81tSCq66URqcbxB8IEHeYxQ7ntcDPw6GL5q4T89JzVBKBFvPhfEbCY0aRpogNNydyIetsBQr3muYgyfB4rFH/x2rVEr9Rv8yNGUcO/LCYNk+6zbRbyi/xfQneFBF7kwDkw4CXMJGsntdppxr/Pu7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCmRULF1cBRfFJUO5Qbr/002rEg8SSSH4uE6TtjqIy0=;
 b=CwaQI2nssQx8iZhyeeNWsBOsKBJGBh4YmT1FUiZLLkyPR0MZ1Yq2NPBeT12YU171FckHPfBx9YnZ/Y6f6D3RZy0E2OOrFQciWBkKaZOssYuqwpkNNYRackz2DMwIVQJo89Orr8Y9dSAErGO2qgI532PoUCxNsIrHZSgwsAQfEuM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Fri, 27 Jun
 2025 12:05:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Fri, 27 Jun 2025
 12:05:46 +0000
Message-ID: <302f9d94-bc03-463d-8150-d0e0166f3e36@oracle.com>
Date: Fri, 27 Jun 2025 13:05:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-2-bvanassche@acm.org>
 <302ceae2-176e-4c89-8f44-aa2169ca2840@oracle.com>
 <c6b5d62b-e039-4e3b-80a0-6ddd19624c29@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c6b5d62b-e039-4e3b-80a0-6ddd19624c29@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: fba4a32f-d4cc-4cc0-0683-08ddb572f259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDQxS20rRGtMM2psSmlzV3AxTUprMG0zQklZVWtFNk42YWtnTmplTjZoNGFy?=
 =?utf-8?B?NzBXcTgvYmRHNHJ0VjgzQTJEOURDUHFzQUhYNWpqYmpGSEM0aWFNbi9ZbmYy?=
 =?utf-8?B?d29ONTU5ZUl0RHU3SzNjQnFwc01yMFJ1YXRvVmJoVGtHQWpNaDJZcFNTTkF2?=
 =?utf-8?B?YXVjNmlRcVNYT3l6MENWUU1JUHQ5RDE4dUF2ZVRTL3NxWG5XSk55QnNNcGta?=
 =?utf-8?B?T1VkV1h5enY0S1FIbTlBZVBUemx0MkxCRlBKc1pFbW1CeU51VGZ4YzRDVS9I?=
 =?utf-8?B?WFViL1N4M3U4TXZ6eTFFaHZsRjJPYlBuQkJyM0FhWmhZMXIxTkE2d2svSGpz?=
 =?utf-8?B?SUlLZjJ6RnI0Y1BsbjU3bVZIUWJFNEhPbWJXWUpXbWQ5T0tEUmE2d1lTZkVS?=
 =?utf-8?B?Y3hKM1pBeSt4VkQxeDdSMlJqSFcwUHNWQ3JnZFp6Yld4NXFCQkpCeVlScDN3?=
 =?utf-8?B?L0xDeWJxWHpySXY0WURvSS9qTGN2c2lYZ0lGRUFXaDJ2SHJ1TnhVZlQxM1lt?=
 =?utf-8?B?amp2Tkw3WVVoMWNYVDdtMmtrWGhUVUNHaElMTFdacmZhcjJsZGR6WTBkeVF3?=
 =?utf-8?B?b3M5U09SL0VFVTZmNTlSemd4VDIvMld6UU9EdVF6TU5lQVVUL1lub1VNK2do?=
 =?utf-8?B?L2J0dkZwNlRwV29vMk05Qlo1SnpDc05vd3BXU09YM2dkOSt2YlNsZFBFL1I0?=
 =?utf-8?B?ck1iYWtNUGtqT014MVI3b2hpWWpWcFV1UHlkZEVPR3dGK1hUZW1MRkhNMDNu?=
 =?utf-8?B?aUxUcW5GNDZTTlN3ektSUWJrc1E2eUNFUEFmdE9aK0NDUThRZ3dRZDBwWldR?=
 =?utf-8?B?NldVRkwvVXVCK0lIUmQ1b0NUVkY4WFJEZ1h1YVpWWTQzYUtlTXIrSFZnTThH?=
 =?utf-8?B?RmtMbmI1dzhWaXNkaTJ2V0ZzYnVlRDljclAyUzcwakp3Y2dHOEJPMWZwd3Rv?=
 =?utf-8?B?NDhjZHFhaWswZi82WVBKSmVhS2pPUTJoVngrQjk2R0JwQ2pYYmlkcXN3RzRU?=
 =?utf-8?B?Q004VmRSSEZ3Q2dhV1ovQWNyUldkT0NaOUF3MUhkTDdrZ09XTEVqeTFVbm5o?=
 =?utf-8?B?RHRwWEp2UEw4RjQ0WGdxeGs5VEFRYUNPKzkzU2R3Kzd1ZjJvbXV4UG45cWg5?=
 =?utf-8?B?c0xsZEd5Z0QyVGE0SHFTZ3ZMcDVqaGRNK0VqeDhlcTlOQjZKUk4zSllGOE4y?=
 =?utf-8?B?Vk9vK2swQm1KQlFuS3F0SHppczlqUVh1dnpPNXpnaFpDeWlodlRyTTVCZ1E2?=
 =?utf-8?B?bWlWRVcrVVZUZXAzYktlR3FzcHRQa3pEQUdCcHZ5WlFjZFBmNW1DMHpQcXdS?=
 =?utf-8?B?dUE4OFQvV0dXRmJZdk5RM3NwUmMyV1BiVW1QdWVqZldXaHA2WXprMXdxOHRR?=
 =?utf-8?B?eTF2TWhDZjF0UzU1RGRJOER1anhxRVZ6RmJyQk9uSFJFa1QwQ0dtb2VSeWZG?=
 =?utf-8?B?dlBaYURubHRKckNZV2ZnNjJ4SlNKaVNvNFZWQXo4aThoYU05N3lFdmFVNzlx?=
 =?utf-8?B?bVRkY2QvU0prZDZuSkdaem4yWk9Hb3F0RFlkQlVGVWQ1SDkwQWdTN1J2UjQx?=
 =?utf-8?B?ZmloNk5zUHdYMXQ5SlE2a1VtR2p5TUdNU1hEZHpoVi9kK2Z0Sk41RHp1VTY4?=
 =?utf-8?B?Y1hXOGZSc05SUFN6UWwyeW9MMXNUbGVVdGh1K3JHTmk1STN5OHlyVGk4Tm1z?=
 =?utf-8?B?L0dURlJvMWYxT0UvWXpBKzJKeExxb2tLRzVhOEJib0F2RisyQldJbExINDYx?=
 =?utf-8?B?WDJvT3J3QUQwang1eXoycjJ0eHFoUWxkUldwL1hueElhODM0aXFZVlV0bnBG?=
 =?utf-8?B?ZXhNNWhBcUlaY2JUYWdxY2FKSHA2YjZJdUFOZ0hZVm1pdzE3R2N5a2JUWHNn?=
 =?utf-8?B?ZEtUOXFpUmI2QnhnVnNGRkk4SjhHaElJR2h4cFdibTV1UkdPU3lUTk43RldB?=
 =?utf-8?Q?bVAbJlPcdww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejJjeXRNbEFiNkxDL0RkeFplQ1lBVWt1OTl0b0N0aTZRRHl3NGVuSjdyNXlt?=
 =?utf-8?B?R2M4SlMyZ2xBSE5oUWppYWVrb1Vha1VUQnBKb3pJd01YTDBDdlJJWDNLUFpw?=
 =?utf-8?B?azE4TDRPdTNZakFRQmhvLzUxSGZITDZrNEtmNGJYd2lnKzNONE9tUEdzdEJ4?=
 =?utf-8?B?T2ZIZnVrb3VlVXUwZ08wLy9heEMzTWZraW03cmJWa0pOOFozK1M1TXVZOE1F?=
 =?utf-8?B?Z2wvdTdvSmxzRUljRG9qMVNicUtGcWUxNmhUQ1B2bllwdVgrVWVtWXNNRUVT?=
 =?utf-8?B?Q0FQWFQrL1RJb1cyZnlhZGlSdk1qVi81UEU2N1MxemIrWUZaSlJmSmlKbGJ4?=
 =?utf-8?B?UWFGdi9XS3lYQmJmelRTZDNDQjdoaC9FRkRVc3JEY1ZEanQ4YllRSFVQSGlp?=
 =?utf-8?B?SDBWU3Roa1pWV250OFlURnFCSkxWV2pvSTZFYjkzTEs0RHArRGU0UEJ1Wngr?=
 =?utf-8?B?MitZVWtwM0JSNUdpZnlvTURqU2k2bXhtMDNqNzNIanhqYmgyd1QzdTl3S2tI?=
 =?utf-8?B?d1hWVjU2c0c4ZXdqaFI1a2JlQjN6TldUSmUrRzluSnFHZUNQZUdlQnlkVE40?=
 =?utf-8?B?YTgrR0tTVjloN3FXb01IZWRsWW5tR1dLRVFTOGVkZTVYK0lMbktVWFZsanpu?=
 =?utf-8?B?Y3ZEbFlud3NaRTNySVdVNHArVXhFRGpqdXpqSWlReGVLNlIvbERDK3hLU0NZ?=
 =?utf-8?B?Ry9nZXBZc1VTWGFHNXc2V2ZPakdaVzAzdGx4alFzVzFuSmQ4bUpxNUVrTGtG?=
 =?utf-8?B?a0phRnBGRnV6M3k3ejl2ZzJQZk9pY1d6S1RleVkwUkdJU2s0enZwQ2diQnpQ?=
 =?utf-8?B?QUtoOXJaTkZTUFdPYlU5eDFSUDB3TG5peXluc3AwWENueWdTV1dHc01UQmhP?=
 =?utf-8?B?elArbDZTVXhMNHNrSmlnRWVpb1VwL1dEUDRtR2docWN0K0lVcFphcVVkZ1Fk?=
 =?utf-8?B?d2ZYZzFzZktLSG5BbmFSOFAyYlZ1Y2NJUktDSWRBWTBURXBnUGxWSytLa0F6?=
 =?utf-8?B?K3FubVVmMFR0TjlMUDZtQUFKcHVzQmVIL0xpaHhmN0RGUkxRTmtZdGVxTk9F?=
 =?utf-8?B?Rnl1VTI3c1NRWWJzZXA3L01DV2ZyYWNJZWxFaExjNFVvSlBqWDZiMmVCdU9L?=
 =?utf-8?B?NmxvNlhJQ2t6QzFRa0RJYy9DMy9rdmZmL21IRUhzRWpNV0NXMWQySDhhRGhU?=
 =?utf-8?B?c2lrSnA4UEdjdkV5a1lHWkgwZUdwU2kwdGE4Y2Vmc0k3Q01SZ3Z0UDVtVkdJ?=
 =?utf-8?B?S1ZqOW94QlRndFJmQWNkb0J5OExNcGlUMTFXRVkvWU9aaWxtYnFDdHpSZEky?=
 =?utf-8?B?RU5uOGlmNFB2ZjZYUE5oWnMzb0pHZ2owaE1qcXVpYWphMy83b2Zkbncrc3lF?=
 =?utf-8?B?aDg4TjJaMUU1bFBma0NzMEZwOU8xYVFRUE9Lem9NbmEyVkRIT2pMWVI3UDBV?=
 =?utf-8?B?VzFuSmlvNmlmTDN6a21QYVNZenc3VDc3Wk44VjhpaTMrSkk1dTZMRE5DcEJV?=
 =?utf-8?B?M0dCWjV2NWcwc0F6d2tJOVoyaWNvVU1yMXU5R0ViODlzbVpUQUl0ZTBPNmdk?=
 =?utf-8?B?Z25VenpydmQwZ3Irdmh0OWVIUlI3NlIrK0hFekplbDFtemZkbWdzdVRLK1kx?=
 =?utf-8?B?Tml5VXR4MGYxWG5LWTFZTUx2Zmlyb005SytSS2NPcG1peHRPSWNDdGFMRVpU?=
 =?utf-8?B?U1YxYmFIWjJxUE1kSGFsTjFiVVZpMnU2dGtYQjRmNlpubXNwMXRoSHU3YkRF?=
 =?utf-8?B?TDA4ZVZ2SDRzajhHZkxYUUQ5OEVySjZxUzZoQUhKbEpEVUwwODNnSUZaRGNi?=
 =?utf-8?B?eHhvenBqNmpib2RQMmpUa1MzSU93cUoveE9zQkZWMVpMaEFCaTNFTHNGTTQ5?=
 =?utf-8?B?UFhJZlF4bkJLOExvU1NjMm9pM3NqU3lrWC9qZUJmb2NzaHVNNzJlSTJuaFo2?=
 =?utf-8?B?Sk9pUi9kTkFIMFZwUTJ2V3Jqb1B6amo2UkFPVVcwSW1keEZUNmRJM0dtbW1K?=
 =?utf-8?B?TGlTcnN5V2dHYWxKNU1yOGNpeEdWRk5PRjQ5WWp3ME5DZDZKNXpVZ0hjNGFs?=
 =?utf-8?B?VWE0OWZaRURXYW03MnZLZWZjcmN2Rk9RNGwrTk9QR3NXWW1BWGs5dExVOU14?=
 =?utf-8?Q?Fufd+56ohoKzjm4vffzLzW0CA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jzVv0pZF93GWpBBFyMcK2OLl8FbiKJIXUNr0ssZu7UE62s/zNJDH/UNAVCHRSzWYQDbpjy/g4V/49DuYaO2k1RABEGjtQaGvVip4XokyHdLpaoziQr4isX+vxZWTh6tkOcoUN+L3vpEiBjYaaoPDdteQ1Es7qpT9VV4UM0bAom9SdKjfnflzsYOgd3Ejm8II6gXdYmkDK+gDtKoV4R6chTWPWhmLHga3Gacrz6LHJH9TUEQ7Yun0s0QH8NujAAsaFMschvmVoimK+DOklBkTwN/uLsTaT48TvyMLMYdbjK1gtSsnk6G0IVrMoYctq99EgvqLc/QgVvqzSfoJ72iObN8PRI2EWSeyr/5bfbknN2cij5lXqS+odtyhVHHt15F/LLJdy9A1bHUrR8OiejxVQwoRQ5CeZJNZSrJbLOrH9XB4Qlqjqd1cISqvfPH3qOGYIrKMTenOP9MePsj2YfApOgdaDvZE03Qu1hO2sm3DNncL2AjdR36C92g2FKKii/ULZNlwKKgCmxjRKRfdD8wOmoB+Nu1amSzJ0QvF6zD9Oc/16g1rz9A3w04NCQJgwLfxcUMkTEJ181Fb/s9srR7N6t6mskwRwBEWhMbFKOjfZkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba4a32f-d4cc-4cc0-0683-08ddb572f259
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 12:05:46.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BK/piN0d6i1Kip5zo/zP1nsBst1EX7efuX+f7fO3pWOVe4z8/DNckuDKoG5DjTPJsQtNI2GnDINIuKgQZKF8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_04,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506270100
X-Proofpoint-GUID: y4pY8GER7y7gNFQMX_FnlOf_sCOuMp8g
X-Authority-Analysis: v=2.4 cv=PMYP+eqC c=1 sm=1 tr=0 ts=685e891d cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=FJg6CLNxoR-baH4-TDYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDEwMCBTYWx0ZWRfX8MM9bcgEvP8J Imh/UqjgbGF7gb+/dYEju9lB+Phfs/J4YklBJuZDXNmKiq6QI9J5+RNvenBszDT3y9TLPSUeefN YURMqhUZo4Oy3uvG8QMRrQvisqGreAHou0F/WIpJq4MwJD/coEiwbHdW+3q06FBRkIZoxqsJJyI
 5TIj6yIlO6R5nC/RdMES+NzjHvK/ciJY/zk76MnYCTdqk6/gDkI+OjHrGtq65xNFcgx1aQbeiR0 aLR3f1PppX6+tmJQc5/6p5Mg+kgd8ewrTrqKhHi2NW6J/O2H1L4ZE/9Q3j6cJzBMuB8zW2acld4 DmLEr5mkRok2PSCeSXhU+fnYHFb2ZyrN7qnfb/eMpzdmD1n8RkLyC3ZX4YFeIKv1JnwFIU4dOe0
 v5jWJHxwRcXBvuM3XOLS8XgxfAFwZiioHj7fWTw54zI3nyBhKrezoeZZ4euexNl2KuwCYVPE
X-Proofpoint-ORIG-GUID: y4pY8GER7y7gNFQMX_FnlOf_sCOuMp8g

On 26/06/2025 16:40, Bart Van Assche wrote:
> n 6/26/25 1:36 AM, John Garry wrote:
>> Is there something special about the logging code that it even 
>> requires that const scsi_cmnd * be used?
> 
> No. Declaring pointers 'const' helps to make the intention of code more
> clear to human readers.
> 
>> Or will it be encouraged to use const scsi_cmnd * elsewhere in future 
>> (after this change)? Or, further than that, convert all scsi core code 
>> to use const scsi_cmnd * (when possible)?
> Many kernel developers don't care about declaring pointers 'const' even
> if these can be declared 'const'. Hence, a large scale change that
> changes struct scsi_cmnd pointer to const pointers would be considered
> controversial.

I don't have a strong feeling on this change either way, but I'd be more 
inclined to get rid of the const usage in the logging code.  But, again, 
I don't have a strong feeling either way.
