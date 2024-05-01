Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833512F36E
	for <linux-scsi@vger.kernel.org>; Wed,  1 May 2024 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573462; cv=fail; b=D3n9SxQUIGrm3vhlvwXETu8NgoQeN/97YmxNl4Nr4jt05kGz9AHMC8BL/E7Qn4x9uTUqgkzVO/PTLeQwg6e5iw/7jJSq7d3RQoiL4WH4qgCJNDcr6jKofbTone7BoHARVSo5kv6QFaotzshGPqtziIU+BkOPEqR9tsXq4++ZFdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573462; c=relaxed/simple;
	bh=yfzNvRvQ23LajZmEW+M41+9yCUx1DYdG66n0z52wwkM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T9BRG5wREdnvEdiVmzqHBvue66GGEH05HNZY08Lt99lz6KR+R4JzIzXdWqsbU7eAJc6Z601rQ0MQq0giVulSYPSv4yBhfVJ/vP4cE6B31ivPqtZO5Ms+kpoAxWNrsQLhIClghaqIQhWSHuHgUD4AXB/bCw/sB/EdXe9TL3eeyUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ma0Ov0d3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oYTB4WGz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ma0Ov0d3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oYTB4WGz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 441ARn7S030596;
	Wed, 1 May 2024 14:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=JuWemwyzkwkX8f+woH7vL9AYHaL5mdMQu42aHzEP8B0=;
 b=ma0Ov0d3TuuyAD9leyxBtWPQQDL3XkpRmGJovDMKUEteJ3V8+ufbj6Xj71gWUCVBKLL1
 /Ym34f2WIqhnbxwqukL4Ouch/w34zalM0QwdHpFi6aANt/rnQ+xD2oVXk5E/YwIf/M0O
 Aehmw79H03VBQmd5xLIiI4xJi+mbfcgV+QbQjrxmkZeiTUx8VtTd3qoobtDvqn6TqIsC
 mOfQzPyQBKYz5FX1B2uDFePqyWqyvoZhAco+YpuqUOzNjxvolYY8o6gOmb1CkO3Xv3L4
 QKIa8LpWdOUEtny1rKWDmMbalbQFkxj6Ehg5CrdbU9nbD+a9U3dC6R0CmKlZiHA9Rvhl 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrqy2ycqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 14:24:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 441DgJTY033320;
	Wed, 1 May 2024 14:24:03 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt94tb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 14:24:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTwpZIWMSepewVtcXJAmJVYMxipgvlMbpkO1ENpzscQIYZY13mgqCeDZav5iOcMVCDoWaMEVFj6aS/ehDiZ43OX9GCyXPaO3PfW6vNY04gV/oQhyvNn5vYKOIutI9hBVDpjUNQX5ZaldVRiu+K2fAszZEYNxlkYHq3IRX93GRm66e5ULsT2QDRE+yA5YA206BGMlPKuQyEpYfk1Byh9Wy0EIbelPMG+7jN6Qng7n4Qbq9cd6XOTDzCy6navG/iVBJtNLCeFHlb+CdsBQ1RmBc83aCFSnIERQIBbaSbcyC9UE5j0KDp/Lpid3elZN4jT0mwb0PpHT6gs/tP+T4sywLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuWemwyzkwkX8f+woH7vL9AYHaL5mdMQu42aHzEP8B0=;
 b=BanzKld1LGP/pAua7H1v4KA8uNh87Ik3P4Vy7z1i8DrMn7W7RTD/6rCEpGfFJby6ob32lgLD8YwL6o84J04ntvuCHEj/Z6kY9PmJdBqWMaBublQ7FhrjIEiNQCnRNdVQBeogA0ZA0U7Yy1EG45zFS0zs0JC5HS8GJoqFulhD53ml2+qSclCG8MPkXZl4Lhz9azratYy2BVwR0Kiip9PiH+fvGmsB5Iajn/DAuugDeRnQ9lNbxTQygXEnG7DisElH9Gb8VaCjxojlqYpqNriMS3GcYa/lB5hLzxY8f3CEapQUtgGeS0jc0I6RRjd3JTp9hywXqjXIGCoEo5ehom2tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuWemwyzkwkX8f+woH7vL9AYHaL5mdMQu42aHzEP8B0=;
 b=oYTB4WGzTqQYGweGZsJq64NtSnGRgv0fq+fCBzaXxmwglAZNyQ9UUBKqa89CWZde+1JvzUNWxMRf8xWns2qs+ZKlsgd7H9EjL9SRg9zQVPRqkDcJTMLQkpSztZBihjmQuNoSAZ+mDp5lHVFuOTW2yPs31yOniO+qm2X3lfcjcLk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.29; Wed, 1 May
 2024 14:24:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.023; Wed, 1 May 2024
 14:24:01 +0000
Message-ID: <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
Date: Wed, 1 May 2024 15:23:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>,
        Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0350.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: 803afa94-9a35-4fc0-eb6a-08dc69ea5894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?V2dEOGJtRjc2d0VDUFI5bVVFTmozSzRWZEx5Z0JSV3F5SmFuTFk4ZGxoOHFp?=
 =?utf-8?B?WS93eXh3MEw1T0NmZlJZT0RZNXcxTU1NS3BDVDJrSHlNS0NYZVc1Y3pHSW8v?=
 =?utf-8?B?b21oelNNYUNUem9IOWdLMWlrSnV1YUhmandrWXl2N2lXRDUyNEVhU2pGWitF?=
 =?utf-8?B?alF1Z25yNUNVT2g3SE5Va0VpQ1FwSUQzMXdlZmJTRVIyNUtQQ0ZTeGlRWndU?=
 =?utf-8?B?U0pTeEo3TDQ3bXZmS0svRVlVRHU5aVMxUnpVQ0Vyd1NpVW1CTm1QWVVray94?=
 =?utf-8?B?ck9RejQ5NkVZeWZWVjBpeHZYUVhpalRrWTk4M28reUxvb05vZTI2ZHB4V2dI?=
 =?utf-8?B?VkF0SHJCTXpBMzlLQ1BKUXdNRVdrSmQ5RTE4TTJWWkc2S3Voemg5Q3k5M2c3?=
 =?utf-8?B?OFlkZGYvZlJOOGpqdFhaMUx3MmJwa3B5Mnl1bmdGVTJ4c2dVaXhnelBSbDlh?=
 =?utf-8?B?bE01b3ZZVitIMWp1LzA0SUNhdC93c0d0QTlyK0ptR2hlYkt3NUxXVjM2Zkp4?=
 =?utf-8?B?ckRiT1NVc3phZEZ6VUtjdHB5ZkIzS2NoaG5DWllya2RXSG5uSHg0dmRNRExx?=
 =?utf-8?B?RDlLK3IyTEJOM2M0MFhvUEhocGJNc0ZadHNHMVFRZ0hjbnhNbmdiVGhPTUJ2?=
 =?utf-8?B?bER2eTd6MSsxZTZSamo4WFJEQWpDWjl6VU9ZU2NXaHdVNG9VRFpBWExQUG5j?=
 =?utf-8?B?ckgwRW9mNkxXMHVNMVdYZXlwMFAyQUZQTEJGN09JMEs0alNmNUJDeXdFSVFG?=
 =?utf-8?B?NklOSnJqM1NIWEJMSHg1Y3hEN2JwT1lZMGdzdjNYTStVU1BPOUM5bytFMUdy?=
 =?utf-8?B?TUNWRnc3RHVYYXY3SW5XU1dNcE40aWR3bjFHdVk5R3pJSGFVOTZKUExiOXpr?=
 =?utf-8?B?elAxaFNkUDlUV0dTZmN4eVZLZ01DaUEzTzJnUEdkMEp6anM3WE9IVEw3dFlJ?=
 =?utf-8?B?ZDdnM3M0T2FMMS9MSndkbUlLTFBxVHcwY2I2NXU0RmVrYmZCbkkxdnB3VVEr?=
 =?utf-8?B?aVpSem00MkVCSkJTUzNTUFVxWEsrUjlhVTJscUhGdnZuUUp3azczb3MySHM3?=
 =?utf-8?B?MmM4MUlFYkJUN29XdHNsOHdWaTc4ZWUra0x6TU5USWVLZ2piNFBwWDErYjg0?=
 =?utf-8?B?Y3NHam1jamRjVWdHZjZLU2RVTmkwR3g1RnBQSFRDRVV5TnE5a1VFNUk0SGZT?=
 =?utf-8?B?RHJta0R4UWdGYlNZWjl0bTdFZ1p0WkFldG96ZlJDQnBSblEwQzBsTzFEbkhk?=
 =?utf-8?B?eVNUT1ZYNDVjVlhmcnBtQ3BkV3ByVXhrWXo0d0NlNzNaN2hTcHB2ZDRJUnJt?=
 =?utf-8?B?cmhydFZ2NXU0VjFuYk9VMlpjaE1TZFV6TFk4VUpucFU4ajRmcTFLeG1FNkQ3?=
 =?utf-8?B?K3hNSUxkazErajdQMGRiL0gvK1M3OXVuZ0ViMTdXQ3IvK3dUU01XUGpQYnha?=
 =?utf-8?B?UDU4cVZGYUg4eE9qYkZSSnpYQWo2ZDBaVXhhZnh5UnBpdnRvanZlTVdxTDRO?=
 =?utf-8?B?UHE1VlVMRnFPQ1NLRFAxdjhVUzNqdFloV1Ntck0rVVV6WWVIR3YvMFhIZk1I?=
 =?utf-8?B?TlBnK3hrZWNzTVVhUzZFRHUzM0dGdXBsWHNQcTZpdHROVzg4eXI1MU9rSmR1?=
 =?utf-8?B?K2R5SE9NdHZERmdwMzJ3cm45U1JwbUM0U21kVWwrUTFEcUZsZmdqWnNzQncx?=
 =?utf-8?B?VXhPVksrbUhNUGNtQnR6Qmo1NFNpOVc0RWNTaUJ0WmJIemtaL0sza29RPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QU83VmR2Tjc3emVvQk8yTjlFbjJVcEhIRzJxbUJOYTlFTnhFU3dVVWw5OXdw?=
 =?utf-8?B?WmJ3MzV6MTlSZmxwUW8wdmYvZ2hWWWU1YmNFekI2cDlSbVFidnB2bkoxUEll?=
 =?utf-8?B?QXJDNmJVc2VpOFZia2x5c20zbDZyby9ySWhiNmc2d3hqMktiSlRBblB2S1N1?=
 =?utf-8?B?ZkZRQUxqUU5PeVcyd0xiWTAwa0dnOC9Ed05rVG1BWkZ6VmNJUElXcnl6ZUds?=
 =?utf-8?B?alBoLzFxdUhHVEw4YWFrT25pRW14NzM5WGI3YkJsUUNXSUUrdkxrejVsVnhS?=
 =?utf-8?B?VXNvUVp1b2lJYTV3TXIwa21Zd09aWGlaQkFKTVdnS2NHejNaTHRESW5uZS91?=
 =?utf-8?B?cmg4SFlSR1BEc1E3TEZobTBuM1M1U3A4YUc2VWJsb1dYUXBna1FjRzZ5b2tT?=
 =?utf-8?B?b0Vpb0p6L01xNzNjRFBrYlFNcFVrQWcwTjVGMTBnazlydFFUdWhUS1hXUFZw?=
 =?utf-8?B?VVpFMUxHMk1uZGgrTDJ1M2tQRWpWbm1RUkE3REZkZ1VuME4wUnVyenB3UEJW?=
 =?utf-8?B?S0duS1lLYVhWQTd1aEtZM0NaMmZjRjBYQThOcS8rRFNXTXd0Ymp0Z2xSQ0Z1?=
 =?utf-8?B?QkpBUTN1VzViMFd2SWZaSkgwNnhuTzArdVY1M3NvcXV1SHp6aktVZ1N1cUVM?=
 =?utf-8?B?TWdaYloyVzlZNHlwUEQ3YUEwT3dJYzFpS3dXUUFEVkREVGYrVGRNcHVMdy9p?=
 =?utf-8?B?RHZ1c2xsc2J1M29tZXB3czhlS0d5djVwTjAxc0l4OXFnNUVzbTZXdWJtOXBD?=
 =?utf-8?B?T2oyUm1DSEhiZll6WjFCdVFnN0RNTmZKSTFiN3JZS0JqTEQrRFRrMGwwbUQr?=
 =?utf-8?B?ZnZYMXZOOFcrY2V2Z0xkOFBQZ05VSUhEbTBIdHdEMHVaU0tnSWx4WmFVVXhL?=
 =?utf-8?B?bVFMRE9na25WYWxhODdjTWV5QlNpcVZLTisraHcyam5TR29PcEF2NlIyYkxB?=
 =?utf-8?B?aDM3QnpxdTZOOVFvb2IwMEliSDFMM0RSNFowZm4xZXNLSzNOMERVclN4cTVN?=
 =?utf-8?B?bVF1K2g5eW1GbjE0NGVVR0kzaEI3S0c0alBsclBKQkwvVDZONzlhM3JhOXVa?=
 =?utf-8?B?RGFpWklvdDhDT0JwSTdNUUtNQ3B5eEFVenJleEU2SXdBdjRsZGR1TVJTY0o3?=
 =?utf-8?B?UjZ1VG83alhmNEFpRk5PN3F4NERPY1lRMlA4ZDlNbXk1VjhVWjJWQk1ycGs4?=
 =?utf-8?B?N2FzVWJhZ0F2ZGxGRGk2Rko2cWhvTHhxRUkzTkRhNFpGRmZSMEl5LzN5T1Zz?=
 =?utf-8?B?T2llc0xOWS9nNHNMODAyekZrNGRvZm8wUFNXam1CbndoaGpQMnZYSktvODhV?=
 =?utf-8?B?dWcyV3VYc0RoRmNHSFNzdjNlNWVDaVdtdVNaOTNLNWxnOXNZOHRQYllweWQ5?=
 =?utf-8?B?QkN2S2VybS9nS1k3RDhNOVRuaTcvdkVEb2JWcy9lMXc3SnREWCtIemcwb0dL?=
 =?utf-8?B?ZzBPN2paNXJiZWxEZnB2Mmd0aWwrb0I5WG5xVGMvWThHMElobkV3TWJOWVZV?=
 =?utf-8?B?NFM4QWs4Ti92dTNOSHBOR1IzNkJYMmRkNHFtSXo1RGtWYU9wM0J2YlYrWW9B?=
 =?utf-8?B?UHNSSUpHVGNkUVVKeHpVZWl5a3RxdVdUTFJJZThqV1hrRVRVc1N5VzlWd3p6?=
 =?utf-8?B?Uks3U0swMXQ1bnAyaXpyQ3FUQ2tFR2NIWEFGKzg0dDRoMFNaL2pzQjQrOWVv?=
 =?utf-8?B?ZEtmZjJ1N1o3ZUx4eXpCa1l6WUVxRDlFVENaYkh1Lzh0VUozT1lzalI2NFMy?=
 =?utf-8?B?TVY4akg0bmlXSVlySG5zZmQvbXpCRkFNSC9UblpNUWsvT3NCN2ovTVAzQ3Z1?=
 =?utf-8?B?VEhDT0J2Vks4QjFDdlRuNGN3VUxLZ2JZWVlUbmNIQW1zTlFhRmZPRFFHZFJ5?=
 =?utf-8?B?YUpEOUFCZXdWVDBrZlp4WU9rbXY1SWJUdS92YkpjOVNlMUlvMkNIUk11VkVH?=
 =?utf-8?B?bmIwR2w4V3BYVklud3ZEcEI0OURCK1BjbHlFd1UyZnl1REVLNUhEQ2plb0xU?=
 =?utf-8?B?N21STkdTS01FaVZBV3NpVTJMYTJ6OVY0STJCb3RuNlM2aWdTbHIyZFA5UDdW?=
 =?utf-8?B?S0dlWW8zVlFYbHVQV2FybEp3QTlQa0dBVWRuY3BkNDJiKy9lWWxUKzRUVjc5?=
 =?utf-8?B?aEx0M0hEeDh1M3NoWFV1b2JtLzJneWU1ejA2YkpwUzh6Z1k0SUdmZFhjMGlY?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	q/XQXTJmAQ8dD9eww5fcO2UGN/uY3WYLEbdYzk6ZXtz1y977Ue7KLMi6Ol2P3ZSUW2bNg9jqPurn5cNBUsjEGYDdvE1MwtPZuFBpRGlYzN0q9gY8njq4aAXPJIXBBJ2ChubEp8JheFG35LhoRIJr3jH+HhTJZisbyfUBnPyFtcoMGZocYiMx5C4qAKwfssDotVi0xth20BnKWUbY6gtSP2NcQh3ekZoBKdO0nmaSgmrJnWiumRksI6FaGlij/tvFxg1LJ3zhQjp3+bg9AJKYdNUTnGXXgPjBBceDzhY4dO+out1FCPbHoickytRgJxDNrccjQ59UIInDC6opMLuqG7oLBlvT1H1YOJncUOW5YrdGYqMIqiwEREe+cGR0EejDl8hZ3FKJfp+DOMkRg8hS/3Dh0iGY4/pZlnrHjcaySzRw3jyJIi6mUsbDCURXEt/TobWzuyY906p7F6/Ir1aWvF8kBELIM+iU3lJn5tH4NxusSS2UEYTkr8xaLK5ce2WrYX0LjGBY4L1o4y4Y9L7llsUZue0aMbPqYGzdKQYvRfCB/GiItafRPitrFvCSvE9EK0TK6nYpWl1AzXOSv/QnNZVQvE8Rna3YQ60P8STcq9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803afa94-9a35-4fc0-eb6a-08dc69ea5894
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 14:24:01.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xh2dEodbm1P28MpcRAfMoo3JiQiIWdJvCmnFodLPtcQ2/gjXKp327fRSr78I3/nIHK3/F4MPdyEln44lPVwjIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_14,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405010101
X-Proofpoint-ORIG-GUID: 9Op7myXgD_iV2K4FRpTppdc_wIVOluDY
X-Proofpoint-GUID: 9Op7myXgD_iV2K4FRpTppdc_wIVOluDY

On 30/04/2024 15:22, Li, Eric (Honggang) wrote:
> I suppose you have got the log file I attached.
> If not, please let me know.
> Any update about this?
> 
> Eric LI

So if you revert a1b6fb947f923, but then remove the call to 
sas_ex_join_wide_port() re-added in that revert, is it ok? I am just 
wondering are we just missing the call to set phy_state = 
PHY_DEVICE_DISCOVERED after v5.3?

Thanks,
John

> 
> 
> Internal Use - Confidential
>> -----Original Message-----
>> From: Li, Eric (Honggang)
>> Sent: Thursday, April 25, 2024 1:04 PM
>> To: Jason Yan <yanaijie@huawei.com>; John Garry <john.g.garry@oracle.com>;
>> james.bottomley@hansenpartnership.com; Martin K . Petersen
>> <martin.petersen@oracle.com>
>> Cc: linux-scsi@vger.kernel.org
>> Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS expanders in a
>> domain
>>
>>> -----Original Message-----
>>> From: Jason Yan <yanaijie@huawei.com>
>>> Sent: Thursday, April 25, 2024 10:58 AM
>>> To: John Garry <john.g.garry@oracle.com>; Li, Eric (Honggang)
>>> <Eric.H.Li@Dell.com>; james.bottomley@hansenpartnership.com; Martin K .
>>> Petersen <martin.petersen@oracle.com>
>>> Cc: linux-scsi@vger.kernel.org
>>> Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
>>> expanders in a domain
>>>
>>>
>>> [EXTERNAL EMAIL]
>>>
>>> On 2024/4/24 18:46, John Garry wrote:
>>>> On 24/04/2024 09:59, Li, Eric (Honggang) wrote:
>>>>> Hi,
>>>>>
>>>>> There is an issue in the function sas_ex_discover_dev() when I have
>>>>> multiple SAS expanders chained under one SAS port on SAS controller.
>>>>
>>>> I think typically we can't and so don't test such a setup.
>>>
>>> Eric,
>>>
>>> I also don't understand why you need such a setup. Can you explain more
>>> details of your topology?
>>
>> I believe this is common setup if you want to support large number of drives under
>> one SAS port of SAS controller.
>>
>>>
>>>>
>>>>>
>>>>> In this function, we first check whether the PHY’s
>>>>> attached_sas_address is already present in the SAS domain, and then
>>>>> check if this PHY belongs to an existing port on this SAS expander.
>>>>> I think this has an issue if this SAS expander use a wide port
>>>>> connecting a downstream SAS expander.
>>>>> This is because if the PHY belongs to an existing port on this SAS
>>>>> expander, the attached SAS address of this port must already be
>>>>> present in the domain and it results in disabling that port.
>>>>> I don’t think that is what we expect.
>>>>>
>>>>> In old release (4.x), at the end of this function, it would make
>>>>> addition sas_ex_join_wide_port() call for any possibly PHYs that
>>>>> could be added into the SAS port.
>>>>> This will make subsequent PHYs (other than the first PHY of that
>>>>> port) being marked to DISCOVERED so that this function would not be
>>>>> invoked on those subsequent PHYs (in that port).
>>>>> But potential question here is we didn’t configure the per-PHY
>>>>> routing table for those PHYs.
>>>>> As I don’t have such SAS expander on hand, I am not sure what’s
>>>>> impact (maybe just performance/bandwidth impact).
>>>>> But at least, it didn’t impact the functionality of that port.
>>>>>
>>>>> But in v5.3 or later release, that part of code was removed (in the
>>>>> commit a1b6fb947f923).
>>>>
>>>> Jason, can you please check this?
>>>
>>> The removed code is only for races before we serialize the event
>>> processing. All PHYs will still be scanned one by one and add to the
>>> wide port if they have the same address. So are you encountering a real issue? If
>> so, can you share the full log?
>>
>> Yes. We did hit this issue when we upgrade Linux kernel from 4.19.236 to 5.14.21.
>> Full logs attached.
>>
>>>
>>> Thanks,
>>> Jason
>>>
>>> 祝一切顺利！
>>>
>>>>
>>>> Thanks!
>>>>
>>>>> And this caused this problem occurred (downstream port of that SAS
>>>>> expander was disabled and all downstream SAS devices were removed
>>>>> from the domain).
>>>>>
>>>>> Regards.
>>>>> Eric Li
>>>>>
>>>>> SPE, DellEMC
>>>>> 3/F KIC 1, 252# Songhu Road, YangPu District, SHANGHAI
>>>>> +86-21-6036-4384
>>>>>
>>>>>
>>>>> Internal Use - Confidential
>>>>
>>>> .

