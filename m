Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748320B810
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809122; cv=fail; b=kjOiI7ktyhkCzIbzn8H9NsYs6UdBfqNPp4LZgd89/THkcpccNWtQ0+29koEAsqg+O6CUDlqZwOFEjm/vaHC9Qpl73qTsFY8OR/h+96dlS5qXzWIK3iXPtZ8g3dD6gSkmAZG8aJz4kWhzxZ6TcsXn4O6h7RTjmSEj7kY1SN/Ohqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809122; c=relaxed/simple;
	bh=autccBtkYLMDwmqM1UnLaUCmfX+sH6f3ntaBuGEJQPA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qWPsmw6rqD9rhK4FAURF++DGI0ArsdHv6DOww+Y/mOCzHkwP/dcsCOdRWfDfcz4L6GVb3Of2W9sdt9gni3BvZz5xgdO1dXHiVEgyrxZX1VyhNLbIS2YGm/AzMMchupG6h0DDeD2k5Jy5hAUwnLs3LsuswplXk+IUKNL2ilAmnoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BZrkUWzF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iFmG+Te8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BZrkUWzF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iFmG+Te8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607GrhrU2482188;
	Wed, 7 Jan 2026 18:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PdtSrZKZit3aY6ojsPnjyLI0iS8LrUADClVBKgcvJIg=; b=
	BZrkUWzFeXwGYB4S1YFq90/565heQ6I6whGQse4GeZJW1DLsDdUUBEasrUqmk4QP
	WfHixYMzsFyTVCaOu8L0/eZk5B8O6vyrEQGqzyn1o1LiQuDpTcaP0fPvvfwJ+6/B
	94TmXNQTSKQACxK1Y6yXllBnzrdts13JJZwcN3HdkcgedzI4gyuNRvshUru8+qei
	W6TEc79llfPjxnANAf+Jni42JNzWGHYNYW25sD2YYBmm50rEePUL2WAYp5N5Ml/p
	ZUcOORGRksuOVE0TJGNEoJf0eZEE4+W8NFNipdnBDWdWLlMVlRxQf5EvWtpllhUg
	/tCFpiPdOvLhqHJTbV1nLw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhudh8417-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:05:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607HsJCl030658;
	Wed, 7 Jan 2026 18:05:09 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besje5uvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4QpSDo7AuWn9uyMXfcyXfgxlxeaan/RRrZz346iICwbXK6zgI2XP63nAisdcZW+ZOxvr1S/i62E7tXkawG70pW715ktJ90YAsJhB5Kok5Bj5GWUs/RYuIkwfgHVxdh6ngdjFXKbX3JbgtqduM0zHX6TyPiAiKDpl1RFO/KfmP9pbq2ghO4kes4zGI8JEcyOEQQ3ZUPF7+0prhHOjzFfNWxkxCSU3uXrjuAZpgn4UDwNf3o+h5sMj4DNsAidpjzLIfN1ElbDWcz4BtdlCMdK7btbREFZXGy8+mPOHw/8PTszEpGKcK/3GbrAJHrHJAH3EaGjyq1SGanyjQqFlYrtUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdtSrZKZit3aY6ojsPnjyLI0iS8LrUADClVBKgcvJIg=;
 b=WLuj2dJ/4nq6dSrPl7PQ/5E8W/fWJq2IRJZ3csfKV8zQ6GUVdV4HyPDkHKz+iB6mpGTU+NNFEouCLvAlXlWXJgaG0KYt+77c7/Iu6vL3io0xBcjgp2S6VYhmQO8z7hqtWXCSey9LToHWdkRkZdXdDnRrP8XLFQOxxgdkUqigL9yy2lIrix5i6kpgau4D0B5JwrtufbJrOqJ8Dq8WfR13oOIgzBdBg0LKy1vdRdHygiPzdsCGo+Je//smVfdAvN3QDxlUVJ7cGc6xjGhMzelQ43NTI94mtqumjl8SKKG75fWoJWq71ch5I3EAKyARqnDsxWppaYMMi9qiytmrt9LfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdtSrZKZit3aY6ojsPnjyLI0iS8LrUADClVBKgcvJIg=;
 b=iFmG+Te8256muQfVOjdpwXDgP/8ZLzLPslSK7zOK6e95SCI4onmCY0tUKpvwjffgKva++JA5K5hEncrYiUY/CQ9W12ngTJfthH80lFPKyL+i/JYcKWQAH5HskF7AgEb68lJ3klvhhma/lZMbGEXa5lz/UnkyEVBJ31SVuYNABRc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ1PR10MB5978.namprd10.prod.outlook.com
 (2603:10b6:a03:45f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:05:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:05:04 +0000
Message-ID: <1ca02a05-69fc-4fb8-b293-3e2a48330714@oracle.com>
Date: Wed, 7 Jan 2026 18:05:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: core: Only call scsi_host_busy() after the SCSI
 host has been added
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20260107174753.3089238-1-bvanassche@acm.org>
 <20260107174753.3089238-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260107174753.3089238-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0365.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ1PR10MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: dbeb93a0-d8fc-499a-9cdd-08de4e174851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkF6S250cGF5TCtiWU01WVI4WFY0cjViSTNVOXRKRHdudjBPOWFlcFo5UnF5?=
 =?utf-8?B?aE5jZkEzWGN3WTJ3YmI4MEhGUjBHZzR1UFZjZ1o0a0ZMTGNGcUdQaE8rdXRK?=
 =?utf-8?B?dHB0VTZDTHJaRUJDUHpmTTA0YmcvV2E4UUFqMVBDaGFIL2pCME9wbGU4dkVy?=
 =?utf-8?B?UWVVQXJTNSsxUFJmdm93TDZKVElqZkxpTkVmTG5hTGdHbXRmNXpCdEZXbHZJ?=
 =?utf-8?B?WkpWVWlhZDB2dVZlTFhRUkxHUDhxUk03SWh0Q3Zod0wxNmFIWjR1ZW5nZXFj?=
 =?utf-8?B?SmVvaXoxdW5PSjJFL3RZYzhqQmZiL2RDYkJaRlRqMlZSR1E5MnlSSWRiQlpB?=
 =?utf-8?B?T2kvUU8weVJ2Wll4TUhPalF4SWVRTUxJUGhMeGh0TXhxbjhTWHpvUzZaSzZC?=
 =?utf-8?B?R2xoZU5wOW41dVZKS2ZGWmtFY0R4amM3c3l3c1J0MXgzbXN6MEZwTHpwNDc5?=
 =?utf-8?B?THlLSm1LUUJ3amEraStJUm9IWit2cTlTalFPdTBMZWZPbXo5aUcySVZYa2xH?=
 =?utf-8?B?Uy8zb3FaQmhUSk8zUVlvZllDZms4SlBzTzBTUllENXEza3YyeGFQdWFCTmhZ?=
 =?utf-8?B?VVdJUWVVUklrUDFZRllGSXVRNUFGVUxTbU9pc09NWmZQaXNuTjZkSFE2UnRW?=
 =?utf-8?B?SVJMZHJKZHJSR283aEdwRWtnWnNQQi9nUmIrWWRKMkJGTkhHS1h3QktMbkFC?=
 =?utf-8?B?WTNRRlRVenVZaGpUZE55cFRGTVlxNVU5L2RpUlUyZlIwRXd6TForek4rdlQ1?=
 =?utf-8?B?WUcranAzeVV3d1MrRjVIZ1dabmlCQkx4Qnl4c1dzdnBGbzAvdktHcEVPa2Nq?=
 =?utf-8?B?KzloM1lxY3Y1dy9OSjBleUZmN01TTi9CT3NQZVVDSHJwS1dCYXZ0KzIyUWZM?=
 =?utf-8?B?SUNOUzhTOXRTWnBxSG03a2RxMXh4dkVoc3ZFYnpGYnVJdmlJSlpDQmxsTjdP?=
 =?utf-8?B?UDU1KzJOTkdMcUxGYTFrTHZxbmthTXVCb2NLZG9Bb2xERk1NWi8xUVdZcXRK?=
 =?utf-8?B?aE1sRFpUaElRTEtGNWhyL1Rwajk5V1BrUERlZWFhLzV6WmtFbSt3OEN1UThV?=
 =?utf-8?B?dC9lZnhreE8zVXVSN2svUEJoOXBjQVFLU1p6dk50U2huU0ZKY0J5VnBKbEVn?=
 =?utf-8?B?ekJiVlVwUkV4WXFFRG5LVmRKWkNNYlhxeEErK1d6akMvRGxwOUcrS3g3UU5F?=
 =?utf-8?B?eGtHUERRYmlHS0lLcGdZWWlQdmF4dm1oUDR3N2srZWVRa0o0QW01K21qa1dU?=
 =?utf-8?B?UUtibnl0b2FyMHZJMmNpUjdHNkNwcTVLazF2L0luZFZtSC9TSlhrUlUwdEJS?=
 =?utf-8?B?R3FCOWJOQnhrcjRjM20zeTRHM2UxM21NU2hHWVhtbXVKSm9qa3prRzBNZzJm?=
 =?utf-8?B?dC8yUXVLVmVOclpqc3JOWjRJSWhreDAwVnhtUnRXOFhzMXBrdVpNM3Aram9M?=
 =?utf-8?B?ZmwrdTQ5SDRMRmJNOVBmcDFlL2FqVVZyWkorWWdFR0tnK0s0NGtGa1l3NWtC?=
 =?utf-8?B?aWZuSmRsZVByZXFKdU1mOTM5QVhxY3pkMERyMHZJcXI5bVJ5Zm85TDdabXNG?=
 =?utf-8?B?RmZreW0rOVpINUNmelFHVHB3UHRWSVEzN0pwcTZVQTFzNzUvRWY0MVlXUFVK?=
 =?utf-8?B?UDVqNjkvTkU3dDFwNXFqdTR6SlNoNWZ5dE1QKzFxd0FVYTZwb21KVEllYTZC?=
 =?utf-8?B?TlUzcW90b1F4VVdCOTk5UEhaSFRSWk1QckhCUlN0YzQyamFJZWYxaWIrRmVM?=
 =?utf-8?B?dTVzSFhvaE0yOUJqbm02amU0RTFLQ1o3dk9jRFlxMzc0ZFVsWEV3ZjE1UzJo?=
 =?utf-8?B?S3VKcXRsODJqd3dYS2pPd3FPcThBY2RIUzNzbXhydTc3OHBmKy9kSE5uYU1l?=
 =?utf-8?B?c1VtT1JYUnRPZHFkNWFKYVdoU244RUVmWm9JQnhZbGV4R0Y0MDhNUHNRTDUz?=
 =?utf-8?Q?RJl0VnsHFN7CHTU4eeP+CkyUflJCiMvj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTRaZTZiMFRNK2VoRDRIMVZmYmszTGVHTFVpYUF1SlM4ejhYdjR2TXV4VXZw?=
 =?utf-8?B?Z1VmWVlhVW1HMkpWZGdXSWJyRmNQL2xSaUVLeHNTbHExRTFkU3FKeXh4S0xY?=
 =?utf-8?B?VVUxdUdsb0R2R1Zib0ViZTZTenFnMU1LZDFzQ2F5a1lWZFQxNEpjZHhoZUUy?=
 =?utf-8?B?TDIzRDlobnRNekxFcTMvc2lYenlLcTRlRy9Scmwrc05BaTRlOE1OZVltR1Vn?=
 =?utf-8?B?c1AyYitkdWl3UTF5Z2hkZXlFOXM2VkNPVEh4TnlSeHIyWkRSQkdlOEtPVWZq?=
 =?utf-8?B?Z0MycnY1TDU0SzJTSkdNZU9xOEMvcFNKSU5VVFkxdUM1SGk0SUkwbWFDNVIy?=
 =?utf-8?B?amRUVTd3cTNZRW51UTNIWTBTcGNDV091dXlXOTNWR0k5YXV6cVNHNjNWUjQv?=
 =?utf-8?B?bGdYbzNwVnhUY2VDdFZVWk83NVVIcDlONStPa1BNSHZmSFhhdTVIN2ljWUI4?=
 =?utf-8?B?dnhza3IrNHlac3NLenY0ZnVlVlV0bjNLS3VXUExuWVdlcU1EcFVNV2hZc2w3?=
 =?utf-8?B?YkpLN1UzSDZJSVZoRGFiSlZMcVVYcDVOK29salRtalBnS0hvbW5BWjZKQkNr?=
 =?utf-8?B?WE1SNFRpWWFXd09Vb1lPTTFpV2x5RTlPWVlSSnVRM01RYXM2allBVERVdFVY?=
 =?utf-8?B?VUdhUDhlWWg2ODdzbXg3a0M4UEVtM1p1VWdVMmZnR28wTlNhY210RzZmTjRP?=
 =?utf-8?B?N1hRUVR3a2tJa3R2RFpYNUd1blp2cjRHRFA3Q0ZlelBKV1dldktpdmZibmx0?=
 =?utf-8?B?TmRwcnJ1TmtpcHFMWkZoOGtJdDVNNk5sZ1Izck92MzhqcC85MFJmUlFJdzdC?=
 =?utf-8?B?SHFoZmxITHo2N3MrQ1NmSzQ4bmptM0R6a0lqY056c05IaVVrR3M5ZndtcThv?=
 =?utf-8?B?aHBvazYxdUk1ZERqdTRkT3hiVGZSWXlOTkpKZ29WU2t0SmlNL1NxbVY1ZUFM?=
 =?utf-8?B?STZHZFZDK2JLQ25sckxLbExzSmx5MitMZnAySm1td1FMYXRUT2NaV21pY2FT?=
 =?utf-8?B?OWxVOVdVaWZ6SXVaZDVnTFBrcUZlYlQrOUlYMGpFYUhPTjQwRDdOSDVNVGJx?=
 =?utf-8?B?WUlUb2dVMm1LZDJzUGJmL3BZeVNjaWp3MkxOdnUvTUt3ZWdaQXhvMEFqZHNu?=
 =?utf-8?B?K0kyVW50Rlc3OERyeHF2MjJLK1I5Vm5yNE1naVdBN3VlTURSOVFld3hDUDFE?=
 =?utf-8?B?VDNwandjZlhzNVNYUThKTlNWNVI3RVZJaHpTWkF3bUVjb213ZGFBUDJ4UGpD?=
 =?utf-8?B?V3YwNkYrcTRocmRnNVBQcUduc040R1BObEZrTTFHb1pJbGtFdmJ1TGlObFFG?=
 =?utf-8?B?Ty9rc28vL3lCL3A0VDhEYUpOR2ZjUFNUOW5lMUN4Y3R2eFlmREMzZ0txT1hq?=
 =?utf-8?B?SncrME92WkVNWjdrZGU0VkFBSmt1NWRVTTdHTE5CRzV1UnJsbDZNMjBnMVc2?=
 =?utf-8?B?WHZTc3EyWUhVSWExZEsyaytBcE9WbzJrdXFHZ1JRcTF5eEpJL3pFSGdIVE5L?=
 =?utf-8?B?OVJKWUt3YitVNFZnZENFd2tYSktxT2t1YzZGNStiZUZURUNZbzlRUmFieXdj?=
 =?utf-8?B?RWc4UTNhRHJ0V1c3UnRNczBMSWtITFE3OVZ2d1NRQjRjbHlLUlhETng1dlFL?=
 =?utf-8?B?bFp5T0tEN3pKTUZQSXczS3BTRWJuNjJ3SDNKUmlnaDV4cjMzOGh6QzdhUXor?=
 =?utf-8?B?Y2V3MVJSN01OY2dha3E0UkFLTUpTdm5VSElXRjBRRnVZeXcvQUVETlVZRkxF?=
 =?utf-8?B?cU1ycGpYZmxsTWxna0ZLaDFTb3NFdnk5SjZjZjBTMWhqMEtqaE9Cd010RDgx?=
 =?utf-8?B?SHpkUEhEUFQySldiWG9MbktvenZlK2cyUUxjMUdHYlh4anNmeVNnS3djaUM2?=
 =?utf-8?B?aXZybTY5ZEZocEZOM1VzZmE2ZWx1MTJnYURZVlBpaXFRNG52K1RiS3lLMmJK?=
 =?utf-8?B?amN6eFZ5MnVKVUNUdnhrRmhqelcyNFlKZW91VUlwZkorRUtiN05tTUpRekl0?=
 =?utf-8?B?eW9oSFZHcXlTSUJMWlc5R0FqajVWUkN3c2RaNlVybGRFeUF5UkppY3ZZZ2tX?=
 =?utf-8?B?elNRanRYRE1lV3FEWURNalgralFSSlgwbEIwaTRRNGp6TzJYRmUxbWp4ZVp1?=
 =?utf-8?B?S09iM0xSc0JRaHdaVTJNZFpVYksxOUJxTjBINzNNQnFrVGZSQko2Ritwc2g1?=
 =?utf-8?B?S0dYSGgxUVU4WXhWMmdpTGhTQ2ZLVEh5VU9naDRacmltWmRRbFFBOE5NUHo2?=
 =?utf-8?B?SjRhMTdma204Vzg0Nk03ME0vMitjQUFDb3k4QmxPd2ZjblFGVm8zR3FTK3Z3?=
 =?utf-8?B?N0JUZXR5aVhXVzNEOTZlZkhkUHJxdmVpUmdndFdEWVZLUTNzN2VDaGdiZHNT?=
 =?utf-8?Q?ph9U2J49FwGIAZ8A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jzy1TUqXE5uJrZTne/hzdNN6qVdp8eFWN6ilIrHYr72VziHgQ6eFsGxTr+QQFjfmZbr9QYKq6XdAh2WnV68bYOCAzJeUG0BFla0vioLKiwAkdNMcY4qUxnHiSPOxnHDZ6/i5M0pOdiSaKlxYRvgdN5iGHKcyrDUtfpvrC5ECSG2MqCeC2rK8CoegRtoEeedZ4P7YESTQoNJTCqdhZtg17KFY+XUeEGBIid5SXJeErEXp1jjj2+vE3qSoCW8+jrtEmeDcFK7E6zcY6Hh2au1/Z1FutVXUwyC1aRccjCt5chXFgKIpTbnmaf2Fv78zcqmycg+fswRTvcEVE8Q+owbQ75fFY4huS2sMzMoiMxbwHpMWvoW4/Y4/oBFiLd5LSZAm8C9ep0ANMtxmi9XLLB9yvoePGCPTSA5kYaTM4pUJLs8tea1CrcN+aBOotGuWDEoxV2jZw6RPjEozlgmssKyGXM0bDukMkvNkMEkbYUZfg4qSwrcK/1U2RG4hxrOQ1ZLOevCWU5gmbsGdtASdNV1HQf1frdvdhBMj5dAELrRGzXfxBAYVxtwHt5PzyUq2g/JqVGFCutpcJTGsKHf7VDk54RUBBC/LcQNOyLhWH8ntyBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbeb93a0-d8fc-499a-9cdd-08de4e174851
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:05:03.9751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCx/trBNMYyFcWZR/NErNeXE516/fp0k/6VUTJPGvF0wNbJZ3DgxpW1a28M9inBiMTBHJAef6orokBIRHxSbew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070143
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDE0MiBTYWx0ZWRfX5+dFOOkov4VI
 anOAUsXs24FfCdZkhVrdM1m3gLftzP+54nrTAkXiDjsBuXBTyKyGa+kt7zxejooc/CU8kUzztGl
 SPnR5bJAntix1iCOtmjAqipchELgNMhSvQRkqmUb2mHhkQxixMNvA12AvIPViZqzQevKeVcAenE
 UmwNhpa3rJ76sTDEEjnS+BP2u/PHoupG2nu6GHxE8X6J/y/1o6iyvwMelUFIV0Hi73GnhPFlZwm
 xDrwbz82e4RulmlYXuCO7B3RvRYbi/9lqIFAOqi49H5r4pGjBxngelqNaEABTuPJXI3mkyCv0Rm
 eel10+86Q6I8C2g0jivUZeaKKwCetPwMujPih78qxieMbsdrYF5928UIEOjtraEj+2tcjKyIMNE
 HjvZijxL5tVIdSQgOfOpUQLJoWKZGF9u6WEv/UYb2EKp0iULVrZXepauIRwA58LgiQGE8ym83mc
 5K7inQz/TM8HYvLSyz+8whcEWzDwvXfMfKSZsX7g=
X-Authority-Analysis: v=2.4 cv=Xv33+FF9 c=1 sm=1 tr=0 ts=695ea056 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8 a=KZWVrHJ3l7m0XCKi1aMA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: aQxANYtZUC2ihzccfDBo9H504y4OwQ8N
X-Proofpoint-GUID: aQxANYtZUC2ihzccfDBo9H504y4OwQ8N

On 07/01/2026 17:47, Bart Van Assche wrote:
> scsi_host_busy() iterates over the host tag set. The host tag set is
> initialized by scsi_mq_setup_tags(). The latter function is called by
> scsi_add_host(). Hence only call scsi_host_busy() after the SCSI host
> has been added. This patch prepares for reverting commit a0b7780602b1
> ("scsi: core: Fix a regression triggered by scsi_host_busy()").
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
