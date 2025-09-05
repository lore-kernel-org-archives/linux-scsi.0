Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D872F7AAA
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084472; cv=fail; b=sHJKlzQbcdpk+AWKBmJ+OKrLU4k7euxBX1AuFU1GNnLN7E7gtyT7BL3xtzFZ38ToKu9ARXGs2647M7C52lszpJ5xOWbUUjIlmM2lgDolkUClc6T8lMQci7q0MdJ7HVbRDwL7TQmvqd+YNNxuTzqcA0Fe8AhUyng9wD0hGSpPhks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084472; c=relaxed/simple;
	bh=Xai9lI+O19EOPkAipDHa98jmXK4EQawo1t/yhRNlqCQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fX5pVXfYbk+ZX3DafElx64Vq9PsnMIeirRdDJhxfmKA3VA+iU1T+DtWwPp6JC/leH1sE0fMfB5wTH4l3mxdXqT3PDnbbcwX2hbb8ny+U4SLFUQHVWx2obgQRxJrDzJUlwXGN34QmaxrOQ6F1LGepoEw1KxXUCgoCC5S1tG540Y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N4BJ/fv9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Iy7kWFcD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N4BJ/fv9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Iy7kWFcD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585EMrw6005158;
	Fri, 5 Sep 2025 15:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WGE0px1VNvXCzmHCVEWnPmpoOnwFcAErVts+drU1M5g=; b=
	N4BJ/fv9z1ltMLAFgSCSphEG7SxK6Y+Pw/wqNIuKelwtwEqQxBSmtPikO7ZzhCdC
	37goVMQmd3yzLape1YaQIFovDv8IlsLFfpEja3WDrppqTdLHDs19Ed+TvM4afUMf
	4V+IERFPs9pIWZG0MXIlkhHxtaxAHCYFs56O+MjqEukzBc5hMcUy5oUiArh+k3IH
	S8n5SNJAFYNCf/abzI34mQB82euZefBbCKflj6mm6oj04D9YZYIQrOcfnj6vo4lA
	HY42tE5FIn6Q9+cKlh0WRNdopRCiiowrWelUzKlN0N8K/ou9ODxnxWCb84ESKjLS
	QKCY0+S36WdGRNAGzE6wuw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4901ewg35k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:01:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585Dp5Ii026392;
	Fri, 5 Sep 2025 15:01:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd4ee2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:01:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVJ1o/cXtjNQ18YiKa+ppcerR5rXTmFGsy9JH/6xX1osibQedky4Asbr0ae0HAsfOzvEVgZ+BERGkR2WvbJwDJOQx0bUq9xVGi4jIOxNHlWIlSOJUTVszehFBKOxoMf+55FOEEKdebRmYssnYwRpOd/o02rU81CX5CEluEvg2meSr3TrjfRllxMKDVfg6rpjDflCsOM2m1wd9TnL20io1fSQhcj6wc+MtpzqMY0EffE6N/NlTOR8VG5rwMTNs4yc7QChqBKVeTc3vTwJ5UmXzCzs6nbddi6f2TXht2LlWZo5RJpFjVdSCylDqnLepqmt6fzf/7ejvLGAW78nc8Yv+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGE0px1VNvXCzmHCVEWnPmpoOnwFcAErVts+drU1M5g=;
 b=jY0Ja/pY2oTW6PWLzFvMzkp6UJ+N+tR6ID8r+uv+uRQu4oKWISrCN5YDKxnldjxDE2r1S+akcmDbtBd98DdWyl+LMrv5aW7tzIAAVYQjNvyIBqtt3jccnOWzgqnPJkRlwNRIjZOy4SrSff5TcNdFJ24KOPYQrouXsRJHQFxbUJaGZ8OjfZS4RkkMz8kgj/KxtFzyfom3/SexbVcIjNM9ON7b90IzAb746tli+eyaUdZ2+LhapEbOfM8MSKeRAcE6kNpCamH4tSxZEmqBZnI6NjVB768XL1mcWo0LgmejZgwjIOlX7ZOkkU2/1msdCJr8W0FFu5Y2NfEYIHENuMaZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGE0px1VNvXCzmHCVEWnPmpoOnwFcAErVts+drU1M5g=;
 b=Iy7kWFcD+NFM5S1neztOe05ndbgU6ChRq04yIRbfolBj/bjJ8Osex8KC+zJf2jRUuQW0e3cVA5g5RnSmYKt18SKPw6wm6m8rzbJxWd5ZA4AA3baRFYlK7RpDk7RSJMXBN9exzaIBrx6AXrD8jXjv6+IE9e6zk/UjwqOvQ82Avgk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB5925.namprd10.prod.outlook.com (2603:10b6:8:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Fri, 5 Sep
 2025 15:00:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:00:59 +0000
Message-ID: <1cadbd04-21fa-464c-b5ab-1e00dfcdbe9c@oracle.com>
Date: Fri, 5 Sep 2025 16:00:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] scsi_debug: Set .alloc_pseudo_sdev
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-7-bvanassche@acm.org>
 <85ebf74e-47d6-4208-9d41-61ac818d2115@oracle.com>
 <521755f9-246c-4bcf-84a4-2541c830cad3@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <521755f9-246c-4bcf-84a4-2541c830cad3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0292.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: a54437d9-2b44-4a56-10b7-08ddec8d061a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YncrZXNjZlNiVWpLczNhNEM1aGlxUzdXb0x5dUdxaE1GelJHS0c2bjBNdkVs?=
 =?utf-8?B?aXlYbnY5OEYxVms4UFBOeG1DQW9tU0ZRakpMNUI0UGt1OUROcWcwR1JTVTlu?=
 =?utf-8?B?R0VJZ1poajdOSDJYemN5Mit5STFMamVEZ0RNTXlZcEZycWxYYllDL21XQmQ2?=
 =?utf-8?B?VjJ4Zmo1ejhHUmlUanQvMFJtM2VmSnljWFozZ1pvU1pjOVJCNVdtcDA5Qkc1?=
 =?utf-8?B?VWZ0RUJDWHJPTmFjR0VhcWkraC9URHlNaXFSenlSQlUrT1o3YmVEYmpEaVlZ?=
 =?utf-8?B?UG5jdG9LeEc4cDJDUTNPSEJYRmFsQyt5V0k3a0JJQ3F6cXJEWUNGZnJndVZh?=
 =?utf-8?B?U1RSYlR3UjU5NkhSSEh5QllpT0pvaDVWUXh5bVIzWG1CeTErTWdGTDQyYUJ2?=
 =?utf-8?B?QXZpWFVITTRwOU1aTEU3anB1U21hRVZDcHk3cEErczUzQnlHRWUyaFZ0bFFB?=
 =?utf-8?B?VmYySXM1L0lXM25RR2EvUWxsRHQrK2FGWG1TMm5ISy9laWcxSVpiMEZnRGRN?=
 =?utf-8?B?UllEalZtajJDNHdCZWhsdHI0NEtVNzRnMGZBQ3hTdXF0WHRPVUVoZWNXRkN6?=
 =?utf-8?B?SW9mL2VxMlVaWkFTaFRIdzRvaHpaVGtpSS9IazdobVpsWlNVNHdQVTZTaXR6?=
 =?utf-8?B?bEZnUU9NcXhZcnEzL3NrSVl4QnI4MkNudlhIaXlLL1dSMkdDVVI3VjUvbW9j?=
 =?utf-8?B?OHo3bXpnQUF4MXV3NzBIUTl1ZGJab1hTUS8yNnp5SlVFMDl3UEpqVjFpQUxu?=
 =?utf-8?B?RnMyaVVKNVFRTDBFVDVVeExvZnRHcHRmaW5kUi92azhINVFDYlJLVDhoNE9F?=
 =?utf-8?B?RDJhSjBtS2Z5OXNsbE13NDd1eXdXdFlzU1ZDWVVMTllyMTE2c3lFYlhkVksr?=
 =?utf-8?B?VjlGZGFLNllya1M2VmF6OUNzNVNmQVJhTnNOVlEwRE4xUEthcFdPSXNaNnNO?=
 =?utf-8?B?U01SUlhEalBweCtSMXpQOERycE9aS0s3cUpRMnVmT3E5VkRlajFNclhMV0xj?=
 =?utf-8?B?RnFLMThTMkZzL2pPTHArS1ZYdkpMNStGSTZBQ2pHMEwrOENpb2hMaitQdXdn?=
 =?utf-8?B?SzVUVWdweXdJUWJtTUErYTBIWlRMcFk2MEtsTEp6VURzNkpIYlhYaHc3Mjlp?=
 =?utf-8?B?TG55RzgybjFTQnlvcysxd2FGOTIycUY4Z0dyTXc2Rng3UU5mVkpiYllLakQz?=
 =?utf-8?B?cE1kL0FoSWN6eXVOSjI5VmxwbEN3WnlIa1dTZjA1dUlvYlB3SHN4SzV4Uk1Q?=
 =?utf-8?B?bjRObTZvR2FCa3pzMmlwTnFlLzV3bXhWVXdBNGlod1RQV0dmUGJZZkg5ZTA2?=
 =?utf-8?B?RlFjVnFEN3liNEtGR3c5ZmdlUkxIcVJ1T1VjNFE3T0taYklSY2RiTkhtUTc3?=
 =?utf-8?B?WGVRL2kyRVRoT3dmT2pnK1d4bnVtQlZvSDVNUVdoYTl3OHI4S3BRU0EyM0VN?=
 =?utf-8?B?T1VtY2MyY3lteXozWWxCRUErTTdENURmWVhvUTlLRG9haDF4dXJKZkNON1l3?=
 =?utf-8?B?ZmtYaWdERG4xZG1EUFlZT1QwVEdGYzZTWjc3WDdRNlFVdW5lNU5YN2pXa3NV?=
 =?utf-8?B?S2g3SlNHR2tjMVlIUStkcjZHNkE3VnlJZ2JVWWRvU01mVkEvWWczakxqZEw5?=
 =?utf-8?B?MEI4V0o1dXRQQ1RJUHlBaCttVnRpQjVseFl6YnVTclB1bzZiMVN5cHJYZ1RH?=
 =?utf-8?B?cTl4QlppL3F1eEhPOGw1eVpoOEJVWi9EV3lSWThJRGtWbDNqcVZDbGY3WWlx?=
 =?utf-8?B?YW1CWHkxdi93akl5TElSbmRLcUorMzFJcVlPL2lwMG1MUldQamlrVVdTQ20y?=
 =?utf-8?B?WmJMOEpkWUJQVWQweU5Pc1VSQXNiWGxtM2tsVWpIaWpHOW9oRUlzaXRDdW84?=
 =?utf-8?B?Ny92bFUxYkkwd01wbUFmSTBNVzViT0psUGRGM2w4UXZFSmJPSmNaZHJnKy94?=
 =?utf-8?Q?wzTn9WH5yYQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWdVKzEzRldVTEZqSHNBWndjb0x4b3RJdHc5M0pYc2ZKenJwRXhGSFFaSTBh?=
 =?utf-8?B?RGZ0QUpKZFlrVzZJNUtjbWRwTlc1SXJBM21aNTYza0pNWFZxaXVJeC9yVWFo?=
 =?utf-8?B?cjk1NENNcXg2WGlWYTREWG8rNkR0OXF1Q1g5dUhudEFZS0dRVlRDa3hzdVBI?=
 =?utf-8?B?aVBSaUMxcmFYVlI2Q2dMNENDWXB5UWF2eEJ0ck5wYlpKbXlBcXo1Q2oxeGhJ?=
 =?utf-8?B?NEoyVk9pa1VZejRZdXBlM3RSOFczSnNvb3VjajMxeTA3VjBMU1MzVDVsQWVp?=
 =?utf-8?B?eXRXWkJlak5HVFgwa2R4Y05Ib1NwdkFleGZ2MlZYZ0Ivc2hUblA1cmh5TUZs?=
 =?utf-8?B?RklNODRnNmlHSk45b25tektYMDBFMG1qdS9rNzU4VXE4M3A1SUJrZEU4aUky?=
 =?utf-8?B?cXZEb2lySnYrdnBGK2pWL1VRZVlqUWF0WFpSYnRIdjRQT3JSNWkxWm1LMWky?=
 =?utf-8?B?UjFFRDlHSVBGNFU0cmZLYzU3LzdRMVY0V3JZQ08xRG11UXhVUlZBODRqTzFj?=
 =?utf-8?B?eHBXYlJ5akI5TE8wZjErU2IyK1VPbHpacnN4alFIaThtRXVZYVRsd1BzVGlE?=
 =?utf-8?B?Y1RCcm1uVmc3OVlxVmxmZ3A0WlM0VEtKMU54cWNzUDhVOEpBTXdZMkJKb1Rl?=
 =?utf-8?B?NGxGN0J5QkkzUGQ3NWEva3RMUXRNZlpQTVFGSzI3RGhhQnIrYkxuK29SazFF?=
 =?utf-8?B?Rjc1cFpiTGJWSWVWa1cwd3BKUm1QKy9vdDBCR0FZdHlyelN6UUg5N2c1cFor?=
 =?utf-8?B?OC9jRDVlQlJ2NlR2WTZjUnZMdmNBdExSWWROai9WZ1VCSUZKOWF1THlWVWNH?=
 =?utf-8?B?YTBTUmRWaHdKeTVUZkpkK1pWeG5DTlIrall5eDZ4MzYva1lYVWFQS2N5SWtM?=
 =?utf-8?B?RmE4LzRLYStxRkRPWmY0eTZuL2x3OEhVR0h0V2VzWU5wQ0lHbjRRdmZQbThn?=
 =?utf-8?B?ZDh5QllKNlYwZU51RHdoRE1ldElsNVpDN25CZmxZTmVvVW9jYnMvZDlQRkNI?=
 =?utf-8?B?YlhNV0xJNDlaNkl5c0NDSXBXQ283VVlpYjZ3Q0NRcEFIK3ZzYTAxSEk2NnBt?=
 =?utf-8?B?RnhPQ1hFQitlRWQ2bUkveUxsSjR1SjBMbEo4dTF5bzIvNG96c2RvSU1hK0hy?=
 =?utf-8?B?bDQ0d051QStSdUN1Nlo5QnFEUHBlTnowK25VZldZdnBqMUh2RHBOM3pUb0Jt?=
 =?utf-8?B?UzI2Y0R3WmplTDd1a0ZqSHFFQTdQQ09tekJPY0U5QTFEUmdZSmdiVGNBNWk5?=
 =?utf-8?B?L09NdjZidkRoWkdSN3FaQ0h1NkJVVjA0Z2dKbHF0Yk9NZ1FPZWRXUkdOUWYx?=
 =?utf-8?B?cVRyYVFjZjZtd1dCbk1xdm80OXByRTMzQm8raC9QYWp0SkdpT2tzT2xQUHVK?=
 =?utf-8?B?RnIxd1ZRTExIZG9YMXNyTmFndGxlZUJORVhaWVoxZXlHcGFoVFdFWkNVYi82?=
 =?utf-8?B?dWg2VUh1cGpWZTJqMnRiYWlSbWdvYWtsYU9lNit4OU5oSXkxeXgyQTdPMWRV?=
 =?utf-8?B?NnpDLzdBSnFIR3F6RXh6WG9NTnpxTkoxcFFBc0JGT1ZERlErQ2JzaUk0TU5V?=
 =?utf-8?B?MnYzOGtEeEdKMGZjbTBXQng2RUVyY0Y0Wno0Q2JwUGxCaHJOOUFySmVhR1pw?=
 =?utf-8?B?bWZXQ3VSVVpvcW1uU0RvOVFMWk9jcjduaHQzMnQ5UkJoQ1YzeVltVzZTSXA3?=
 =?utf-8?B?bnM2L0MwMy9ELzl4aFFNK2pmTFN1eTNwWUFVYWJ4aUxwQXMvVTNuQVVobmEz?=
 =?utf-8?B?YnFYODR4S25oOUdieWsybWR1T3RJNHZtTHM5aHV0YTMwWHhTdi84eitzektW?=
 =?utf-8?B?cUhpMlFhUXMyMjFQSE8xbHRYeTdIblo5M2hud1picTVjb2p4bTdpWnhCeWJD?=
 =?utf-8?B?enpDVjhWY0dwUEY4N0ZsVzVVSVlQcWNZRTBDU1lRQzBoRjRLaDZPTnFGdkRO?=
 =?utf-8?B?YVlwYnFqSVk2Wm9GTHZJS1FQU25iQVR0YUNjLzQ5VVQrYU9BT2daMGN3cUVk?=
 =?utf-8?B?UEJTS1M5cy82ZnlFOG9JTUlWOUd4RDkxTTZyalRxcjhadEhwV2lVdUZCWmlw?=
 =?utf-8?B?eHU1d1ZHNytFNjFkVElraTE0Ums3d3ZjSjFSc3liTmN3clBPbGxuRnRMTWVw?=
 =?utf-8?B?YzdFUVNVZEJEdVJrbHpiakROMHVwS2FQUjducUM3aDZEdGdyWUYrM0N2YjRh?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gUa1rll18IcNCk9hyoGf7RQvmjio4SbtHhj0zzaBqP82K8LK1QNyDKPpspc2pzZEd15vQVY5kDiOyn2GGcKnoMRJTeNgUDSUvsuLk3Uhhl05R6trvJz4ZVJe4wCmtic86qWLomICHvHinTRsQAnhO1iA4vH2CelnEU1TIpL1fMqcmFaJGrn8rfWfYSvXYG/KB1B3qJNh39T0rPDd/N8BudJo3CimIEnBaIBaH8w+qpuxekQ9c4ETdliKXiU3tGDKXdDhJZ1T4W1eVoU2TQEJzAH+cPQ3aaBnsHZMki/N6GUC0D6d76kBhZMBXns+wy5HucgWcSYjN2GP1+9BE1GDIHLAvXMobSg+TTprxDz6d4LwwfM/HivEz/MAuUIo4r/N/O27Mpcb20MyqRq96y6s/j980+OyxzzFVdk6bQ5XtTdw4jmj0xB5NUxBylp5k70duR5Rh8PJydSzjYxNkSxtbgnXH4GLqhizFIwK2o6XUxujBTdHFhsdrwmktBXSemW52o3dnq1WQPjmwCn7HJtEbvfWXLql4ji9GY0myEQ8WYFBPsLEEvOzGZn7j9kOOLvyeivs3lxDlfiYFs3hAZ9kyvDAP+Lp1rBIBTo/bZ7AcTk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54437d9-2b44-4a56-10b7-08ddec8d061a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:00:59.5715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CInZypTa3HrrS/hiREGXMqUG1rrNxeHYQbgS2IUR5NALVGKNTCjLfuNn2YBxpF/xrJmt2Rcqp6Hqpcc4RHjE8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5925
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=796 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE0MCBTYWx0ZWRfX9bUSC4KSDPGT
 RpXPUOMMtYCZoUAnmUgv3tuMUe6DIUjMDV+q5g5dFCmB4Z2lPacqU32v8I8i+cqrbXROfa6CKKr
 FYSCeCS0/kkaAQWXuyJ2DdmqVayeB5wWcuZHUyvq8yeATnn0PNCu0wKtLnajqnIdACb+BAcPSKr
 Vv4mzsv3oybhCGaXyiwFTiiZFtsnQyHh9GIPVZs+ZQ6vg22uYxdFAH9AGBVtu5m9HHwCUvGnhEq
 1UqXE/5Tmq3m4ZuZ+C3G7z3mrodC3riONEtjcZE4kKG0i0ctRau3pZzo6whY9wJHn/WIHIFxksu
 XfteO9mkXym25B8gUXXRq+CMHCQfft8pUOJwBNJuWKszNsu2tPy8uI9TYr/iav/KX+o6X4Q2tft
 Uh6cvn0hqM97+gBemVM/XhWiLhmhtw==
X-Authority-Analysis: v=2.4 cv=bLAWIO+Z c=1 sm=1 tr=0 ts=68bafb30 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=BnpXpE_6QnV_3LYfoHMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: _3FxcK-GzTQiSjgjIA1u-euNruc5THcQ
X-Proofpoint-GUID: _3FxcK-GzTQiSjgjIA1u-euNruc5THcQ

On 04/09/2025 20:44, Bart Van Assche wrote:
>> for scsi_debug, maybe we can add reserved command handling as part of 
>> the driver abort handling, e.g. eh_abort_handler -> scsi_debug_abort 
>> should send a reserved command to "abort" a scmd, and the reserved 
>> command handler does the same as scsi_debug_abort currently does.
> 
> Another possibility for getting rid of .alloc_pseudo_sdev is to allocate
> a pseudo SCSI device if either .nr_reserved_cmds 
> or .queue_reserved_command has been set in the SCSI host template. A dummy
> .queue_reserved_command method could be defined as follows in the SCSI
> debug driver:
> 
> +/*
> + * The only purpose of this function is to make the SCSI core allocate a
> + * pseudo SCSI device.
> + */
> +static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
> +                         struct scsi_cmnd *scp)
> +{
> +    WARN_ON_ONCE(true);
> +    scp->result = DID_ERROR << 16;
> +    scsi_done(scp);
> +    return 0;
> +}

Sure, but it would be nice if this was not a stub, but rather actually 
did some work, like "aborting" a task (as I mentioned above). Then 
people like me who don't have UFS HW can actually test this 
functionality. I do appreciate that it is more work to implement this.

Thanks,
John
