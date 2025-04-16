Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABB7219A7E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2025 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744791805; cv=fail; b=aTOkuq6PS29MRrte+Up9YDMEeJaH0ezElSMmX0vbnDL0vrQbWV86FvU3YEHMB0HAUVgrkDQxS0ogp23/Me7hAI0TW+ykpK+mNuBFDFTLB5V8rmnGU8K43/zAsQddbJD8E/Fm0+829FGj20eIkWZ0SpBMjrbCMOU2WdjrionrmBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744791805; c=relaxed/simple;
	bh=/Dfn2xf/sJ9iSzkCiv9t1CIaMV16NpvDzDUK0QtNNwI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XI5Sq7XbyVANakUDC8xIGFdjVmIqaYKm5sRFhsuoh2w04WIEas262pBWNK/wQeoCfbl9f3YlpgYqku9Jpav2vYmXzCzDifNGnQnk4fMredhbwJP4HA03IPU783ieZDv1Lb6XXIYG2JI7anusJiyPjeH9B0AG7/vKHteqLPmDeDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mtEeEFdW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pdJT+t2J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mtEeEFdW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pdJT+t2J"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53G8N0Su012703;
	Wed, 16 Apr 2025 08:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pUKvnTmUT6YR5qtHaa4AvhEYobq27atg8zPV4owPSLc=; b=
	mtEeEFdW/+I1tNdTJ9nGiy/ztT3j5HwLcP6aJYcPwh3k0rk24qray5YaXF1w/bkb
	EYb8QbUEimpaDvJcUHUq0n8ALUj3KlGFHxwcLRwENhrEs1e+PzNGK1vAmqsuJp9X
	G9giIxP0Q5YEnRpHfoThS4BIBRBG0/3rIfM/VVOHH+9huiV19uWbjh4x+i5tdTCz
	Jas3hWUcIRZ5bhXvaUXoQCQnwU6MP879LQt3xV3YROR8yieTlLHeUd4OQ2qJ0XTf
	P/O9nNmnQegDia0Da8HdEgEaw5CjVp+Dy1wgs4/xWe3YqjyHpHkCArM2X+R7sa5U
	2a2oARVQk94WN0n800ey4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4618rd3dm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 08:23:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53G8B6Lv030956;
	Wed, 16 Apr 2025 08:23:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 460dbbt6f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 08:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4uH5NaawNCgTq3iMzYnj5TYdNb44lupJkhdEraVNWlkT8BNJnMG1T0BMHG3tudsyEvEWFrHrQqcqQGkp/ty+mA7c75C/YE0s9EdXXA4tbaT87QrZxymB92McCR/8uYXcNowfw0Vn+i0vX/8AfRDbLli+m0aFVAb0V6KQlSTRjYrZKfgFbMe8uX8Jww48+P0MrrS3mQ1ZMwC3W9Ve17obWQahBYBb7NsTNPyDIcB9IJIyaI9VPy4ZZSfmRYiwxKAhtMGw0E6XCIdxv8OydiFL0kaoSI/1HrHDnI4aO2ZYSdq+jsFKqc/d5e1jXEMqusRlvA4tBTEjpxDfJTejsHVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUKvnTmUT6YR5qtHaa4AvhEYobq27atg8zPV4owPSLc=;
 b=AtaLiw3UxtmuwcMAIi9urefrQ8tOjoZJniRx8mIO7eD1koULPTqSiyYaq8hK85QDTOkHmZCA1Cspnfon9VVkN5q76dID1w3vTZGWnYi3zhJRtdEV+Y8+QS8Un8MJUccIQ/YA7zjIZORSIO96ahxuH27M5GccD/SspIcKH+wfRNbsXJNJRs7n3ItXR3zkhXul/nDeCphjkTMrfHLl7N0eOxcJ5qKrCsLcleVhtjbO42C9EGmkqVkoSknPQMamPCd0wx4/Lyf6wdBIkXpnksM27thXVlmoAERvLh1EN7hzeIw6kw671HY7vVt9sXMQ4hHhF0huOT4gnWVZzB/xWU3T8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUKvnTmUT6YR5qtHaa4AvhEYobq27atg8zPV4owPSLc=;
 b=pdJT+t2JGZGw1cAoUyMgROQhSBu/5dLO1C7hLH+DbqeqURfvjTPOinhXYStFMjddyoeN3/fEBAchVLCOdZfRkAm0RTNDECubLLOrbFaBgYuYgqBWEfLYVMFeik9rMNswZOQjenQUfraZt92adtdpgSDCmk6XCMVwivUhNMAiEjg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7452.namprd10.prod.outlook.com (2603:10b6:8:18d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Wed, 16 Apr
 2025 08:23:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 08:23:02 +0000
Message-ID: <49a1e0c0-4e9e-40f4-8a74-ebb63ebccfe2@oracle.com>
Date: Wed, 16 Apr 2025 09:23:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
 <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
 <7455bff3-97f6-4156-87e0-197f2d3d8350@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7455bff3-97f6-4156-87e0-197f2d3d8350@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0239.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: e063ab11-baa1-42fa-cc86-08dd7cbfe7d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkNpVEdES3JUNFlhUlI0V1duRHNUWEVPdjBtYmlLTTJPRWQyS0Q1ZlJRUW9E?=
 =?utf-8?B?MXlWWS9pc3FRbzJRV0wrZmYyeFNvR3V6N25MM0xQNEJsNXRUUFc2K0pZeG80?=
 =?utf-8?B?cDVsZFo2STVHZGczQTZaNUhBOFFycVpnWGJUMVBscWlsZEhoTUswWHQvVmU3?=
 =?utf-8?B?TlNvTmYxdFF6UU5wZDRCcnRWL3crLzBjN3FGNXZ6ZVFIbGpDbm1pTW16WXI1?=
 =?utf-8?B?WnpBYmpkeHVaYk5rODdpMDVVdWZFRWhHcW4vVTFaZ1V0UzJ1eVRBVldpbkor?=
 =?utf-8?B?R2JVR3l4bXN1R2JxOWMrdHliMHVSRUViRmFEek9CTlFyaTM5QTdhSXN6aGo3?=
 =?utf-8?B?Zk50QkYrVUV5UnpHTW0ybXNXem40MmpPaUljYTBUUkliSHFwQmdpU2lXSzNZ?=
 =?utf-8?B?ejE5UVJSU1dQMzNFeWpoM1d1SkFCaml6R0N1OWhBQUJkMzRSakJNaVJoa3pw?=
 =?utf-8?B?WkVNTG5xMFdqWWlxVlFxektPWHFZZkxsQjRvdkhST3NoY3JFMTVUREtGRUZw?=
 =?utf-8?B?ZUtHWDZQVHNxeExtOUpMUnNTclF5SkVoZnRUTkNyVE15VzlOS2RpOGoxYVEx?=
 =?utf-8?B?aUtuME5sSTJZNVZPMUNhNVcxeWtKdHE1VFV1aE5CeS9yQ2NDaVRUODkvTkRY?=
 =?utf-8?B?SitXMGJJL21IZnVNQ2ZKNmRtWk0rVjhVVzBUbmJPcHZqTFRYeUVLTXZMZU9j?=
 =?utf-8?B?SC80MlVRR3NydTlyOFpCWlV1TTZPMVM3UlZDV3hyUjlIUitJb0g0amFyaVpn?=
 =?utf-8?B?eCtuTU1sUW9DeWcxZVlDVFBXcm0vOTZkY1VocFJaNmhrNlJYRGFjV3dPS0dL?=
 =?utf-8?B?ei9ldWxEcEQybU9kQTVrc3dQa2gvSG5GVGh4eXNmMEVYYXJHcGxncE8vREc3?=
 =?utf-8?B?YnBhZlFPLzVvS1RzZ3g5cGIzbDZ3enUzeWltZE55aWo4bVE1S2JUa1BRVnZL?=
 =?utf-8?B?eUJBY2lwVmEwKzlaSThXeHM1Y3VlY2hZWTJSZXhvK3ppT0dpQjcvN2pUeEJi?=
 =?utf-8?B?V1U1SWdzV2JDbi85Z2VSUVg0WHdVM1NmRXF2dEEvdUplb253QUtHaElnenp2?=
 =?utf-8?B?aTlXdFJjb01vaTl4K1lOT1UxemdpZkNyanhobEg2RTBTcERxYzBEaVovNVdB?=
 =?utf-8?B?Zy9oSzJDajBsY3NKVHdkTHZqeUVhbFVxQlRkS2VyeWhZbTZ3RUlKalcrM0hU?=
 =?utf-8?B?MUdUVUpWb215YkRYbGwwMmo5ZnYzUVhEVUZqMDhJcFhFZ2pSRUhwWnYvY0lS?=
 =?utf-8?B?bC9PMGtGNldXVk5odlFOOW04cTY2bGVNcitFVUszRS9yL1ZvYzhPS1pweC95?=
 =?utf-8?B?U09UUVBSdDlTRUxyazlDNHF2bGwyRXIxMGF4QWFzVjZDTWZRbEE5OWtoeHRl?=
 =?utf-8?B?WlVNQXA0cnV0aGJiQitYTDVoYm40U1hZbGhHcUUxajZ4MmRuWEtFTkJIZG91?=
 =?utf-8?B?ZGdhNkRYMURRb2lSa3l4dzd0bXF0OXloWDYxMkR5U0dpNVRhZ1JGVHpDajlS?=
 =?utf-8?B?T1NXRnAxL3Y3WFdRN0pGOW9UcXJVZ1NCR1VKdDZhcWluMElqSXc0Mm51aHpu?=
 =?utf-8?B?WUN2S3FsOWlIL1NlSXhtQlFhS0hKMVdhb0NxN2daV1NibU9nTFBKaFhSb3dl?=
 =?utf-8?B?SzN6UkVCeUxaOFREN2ZpVitJS09weUFld3puaDZqaXhoUjZZMHo2aUVvaHVv?=
 =?utf-8?B?eU9MRWFZeHd1R2tTK3Vzc3pBdjUvLzR0Y1FTTTIzK21CM0t0enlpSkRiV0dD?=
 =?utf-8?B?ZVpMcmF6MTJRcEZ1NXZlSjVuT0tBcTAycU9rMXowcW1jQTcxZmdvZm1qQ3pL?=
 =?utf-8?B?RUdCd3JlQ0lYdFR0VWZsTkxwbmw5RGR3WXVreEVheXZvWUR3anNIQkdVQW8r?=
 =?utf-8?Q?y7vgLQjEEXH/z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3FrSGhudmZLbmZZUDlwTUJ1cG9PMERxNjIrNmhHQUhmdDdaNHk2OHE1Y2lq?=
 =?utf-8?B?cGNMVWduVjR5bDBPWm5BbTh3RVpIeFhLanQwOHNNb284OU5nOUFOdnVNbkF4?=
 =?utf-8?B?WEJnQXNHb2Rsdk5wbng0cGRqT3EyWlUrLzFCa1cwTHpzODNNeTBKVkhicVli?=
 =?utf-8?B?M0JCVXhHanZ1YlZmZ200RlZaK1ZheTNpSWlQNURrSlgrN0hNTW53QWVxaUpw?=
 =?utf-8?B?dUg2Wm1ldXJqUnY3MWxoaVRDWEZ6aDEzNnIrRkg0UkJDN2Zvc214NUdFaUtW?=
 =?utf-8?B?STRpaUI0WlhNdFlRN0xEd21qME5NM3RlL1BqK1FER1YzMjRkc3pwK3Z0Z29I?=
 =?utf-8?B?T1ZUc2YvZjVBWWd4RWFsZGdDNytleFVmZXU2c0xHTlhZOWp5UzZmZEFocStl?=
 =?utf-8?B?Q3BGM0EvVjdLamo0MjNrS3ROS2JRNk9rRDdxeFowUDBXYmtBTUpHUzBLSjlH?=
 =?utf-8?B?OW55WCs4VW9BWHhzaGNxWXJLeE16eDBnc0lXeVZ1cVhza0c0b1F0RjBFQzND?=
 =?utf-8?B?V09BREpMVVhHTFZ4amwwWTExSmgvT3JKVjZYQ3gweFlqaHk1TDNmSzR3MHhE?=
 =?utf-8?B?eDJwSjhsQnZXTzdyVlBNUlBTK1l1WVRwaWZwWmxFVTY0SlRUM29qS2huNjlr?=
 =?utf-8?B?TEVYMlRpM0FwWjJlTnB5dzBqdGk3aE5uKzV1L2ZXRnlnSnFqYlNoY1BpMWJr?=
 =?utf-8?B?c3BhVFliSTFYSTJHdkVpT3NQVTdFdk41TTExQ1RseWN1MHcwdGpHeUE5cFpB?=
 =?utf-8?B?Z1dEdHFBcUp2bE42VmxadDk1UlFNRVdINWJqS2FoK3JFRkwySkFNRWVBREV6?=
 =?utf-8?B?T1NSUGFERTQrc3RETzgrd3R5YkZnK2ZRYWYvYUt4S3BrbktUYVNiaGlzSUVp?=
 =?utf-8?B?cm8wRFIxbXdvSHJMa2hmazZCMnlDVFNrWHRTc1RYNDdCVXlvdnZobVdIUmNi?=
 =?utf-8?B?c29jQnpHTWgxWHdFVDA1TXYwYnZ3L0FDc0ZTWnJzT3d0UUZLb05QTEpIKzhr?=
 =?utf-8?B?QWVUNlZZSFh1U05mdWVyOFp1R3FTRTlEc2V4MlArL1F0OVJkTTlmRzZJMy9I?=
 =?utf-8?B?bmNaeElEMTFoL1ZHS01LVEQxRWZLTnlGc0J3amZyMVE2ekQ2K2E0Mmk1bjJB?=
 =?utf-8?B?eVhpay9zSUJva2lJY1pRM3hvK0RhZWNjWWZ6SUZNSmxvUitKd0hCT1M0U2Q3?=
 =?utf-8?B?Q1dZNDVXdmlGVHZ6R0ZjVGpPeGluN1RYRk1wb3pmK1d2M2JkT0dhZGdsTndl?=
 =?utf-8?B?dkZuLzMxbWNuYmVtalh0bmFZWm5zR0N0UHFTNlU0SVJ4WG5sZnFHVjU4VDk0?=
 =?utf-8?B?UE04Z0lzSjhJTG93SzJZbjJ4aGVpVXFkcTlXa2pYMFlWOGJXNmFnUWd2bmRW?=
 =?utf-8?B?ZUcrSjc1M3BhSGZYZmZETzNuS2FPak5PZERkVXhJRklHTmhXZmFIcFMwNFdY?=
 =?utf-8?B?a2pCSmZyazlpL3A5TFArdWJjQnVmbVlYK2hKWEdSWDFVK3NHd0pjSmVaVXE4?=
 =?utf-8?B?TTd5N0k2OThSaDJaWit6bEZqQWlsM2c1UThXK3IvUXNIMmFrVTBhaWd5bkNz?=
 =?utf-8?B?dGM4WFZtNk5mRitDdGJuRFhqRkhqU2QyWUJ6eHM2Lzg3aXJZdnhNc0xibllU?=
 =?utf-8?B?b3gyYnMyNTExK2RNT1dBUTJ4RkNqZTlDRFNWQkJ2RHpFNWh2TGJkRUF6dlNJ?=
 =?utf-8?B?Tks1M290alVwM3FtbFViYzF5eklXMU9DemJ1WWEwRk1NOEcxZTF4aHZEYS9M?=
 =?utf-8?B?dDYraDBQREhBVVBnTVY4Zlg0Z2ZCQkl6UTEwaDNEa2FYZHZoOGNhZXh3RlRY?=
 =?utf-8?B?U0U1cHdncFdIT09BZ2VpVUt0S2VkZXdrblo2M0RsYWJ3VUwwdWl2MStIZEZ1?=
 =?utf-8?B?S1ovVW1HTUpFVnVTbnVXQWpNb3hWbUE4dUNncXlMN2dDaXpST2hxUTZqMUxp?=
 =?utf-8?B?SXRJQzNzRFdEaE9Ua0RhNDVxa3A0SE5TY0h2VnBvUXBiY3kzT2FEcHNHejBa?=
 =?utf-8?B?b2U2cmgyb095MFJqT0FHTjBXbVl1MklTaUdURHNLN3F3dVk4RnVXWkRmTW5a?=
 =?utf-8?B?Rk96cjl6dDJSMVhrUzRkVzIyOEdpV3pYMjZ0d3Naa2dYcWxlb1pvT1JKbVlJ?=
 =?utf-8?B?SEtMOWhHbkJNek41dkRXdkU4SlVyK29pdWJrSERQb29IYkdvZy9YK1d0QTFt?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	soy2i98Fj1HyqtaFSMQDd8guefBY4t+aGlHaiER2DVH5a2Ng+JJV0AMYfrddkRdSIvS3d9WLhLZ/dnvbE8ESX1HFSTC2PJwDJpjod3mW09Ybf7wDn++yR76oIQGgrkRypFDnVzADKm2u4YYHO3aXPFTdZ+qsMiTGkOOsB8ei/8yKnBDggxM3JWAmYPsDkpa97UAc35ZPpv5eJo+n0X/OjFUDxsfljKq3vPJmGILyLCb0EaXiJSDTl4UH0Jo/CKJGtXehfa+pYjeF7d+lap4CKpDRwgsV9e/mu723edaMkKRpxTCsFBKDNu72APhu+yK9A1lGBoXhobTZGaQTnz1O4gIfO/C/YRZnhTfGL4BDu1cPt3mSnwA9APc+ODQSa6oyF2vS1bvjai8z1jq0IiLHTPnPKFvZMXcgN+tvdGqQA4WliIRiosZJU8jEXmJvqJzcY3/h/w8K6IbOAdE6H2nIK3vMm3Z7dCyFEfdSTRNEy+zyOmpzbsHWiJCcKisxuPMVUEzKhu7ljdMLDE8WOWDE0MZipBv0YjzOReAvNwkVkI8ttnACFQMqB9uuLJRuyBVIqSG82rqwBlVeV8Crxkd+kgOF6NbD0q/WRcmcKyTc5Gk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e063ab11-baa1-42fa-cc86-08dd7cbfe7d6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 08:23:02.8795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8atwAsR8y8z1hLo73Z22BtwH1c8/JxaMcZ/YC/lUbedA1/HNNOWGAwGv1sBYz4mhT95+Rwhw3vq5W9UgsA3O5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504160067
X-Proofpoint-ORIG-GUID: RAyIIlm2BpVtC5xpD4qeyf4z_lQr_P0u
X-Proofpoint-GUID: RAyIIlm2BpVtC5xpD4qeyf4z_lQr_P0u

On 16/04/2025 08:39, Hannes Reinecke wrote:
>> JFYI, I was working on another solution (different to Hannes') which 
>> allows reserved requests pass through scsi_queue_rq(), but I stopped 
>> that work when I changed employer.
>>
> Oh, really?
> Do you have the patchset still around?
> I'd be very much interested in that...

Yeah, if you remember, I was working on that for libsas/libata, but 
started to get bogged down in how to handle reserved commands for 
libsas/libata:

https://lore.kernel.org/linux-scsi/1666693096-180008-1-git-send-email-john.garry@huawei.com/T/#m35ad9a27320077f55c2be5549f036628fe79dcf7

It would be a lot simpler to support for HBAs which plug directly into 
the SCSI midlayer - like aacraid.

> 
>>> Although it is easy
>>> to create an additional request queue for reserved requests, that
>>> request queue shares its tag set with the SCSI host and hence also the
>>> request submission function. From scsi_host.h:
>>>
>>> struct Scsi_Host {
>>>      struct blk_mq_tag_set    tag_set;
>>>      [ ... ]
>>> };
>>>
>>>  From blk-mq.h:
>>>
>>> struct blk_mq_tag_set {
>>>      const struct blk_mq_ops    *ops;
>>>      [ ... ]
>>> };
>>>
>>> Unless someone comes up with an elegant proposal, I will keep the
>>> approach where ufshcd_tag_to_cmd() handles reserved tags and regular
>>> tags differently.
>>>
>>> It should be possible to do this without referencing tags->static_rqs[]
>>> directly from the UFS driver.
>>
>> I'm not sure how that will look, but my preference is to fully 
>> implement reserved tags support which can be used by all SCSI LLDs.
>>
> Sure, that was my goal, too.
> But then I got stuck as some drivers (most notably aacraid) use internal
> commands to detect the hardware and allocate SCSI devices, so with my
> approach we need a 'fake' SCSI device for the host to handle that.
> If you have other ideas I'd be very interested in thems.

My solution still involved supporting a fake sdev also for times like 
you describe, e.g. shost needs to send reserved commands.

Thanks,
John
