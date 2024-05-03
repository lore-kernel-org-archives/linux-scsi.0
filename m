Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC8146D75
	for <linux-scsi@vger.kernel.org>; Fri,  3 May 2024 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714725202; cv=fail; b=sLzMfCyuIJYGDgC4kDyZ0mplslwZ2yYmRv7qtgtkMve4E5QAGlWbziqSThC9mXkvY2MaR41WgKrQcO70p2T+NSwYqnmQbsn8CnSbQmsk3IKIsBVzI9I643fcA+UJVF0UIkPhd8z5/s46ztTpw9+FHonotzIPwNR0pae5X09l9S4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714725202; c=relaxed/simple;
	bh=7LzA7YMTVb0bFk8JrBhlaGVekm9tPQ8tblI0NShbTB0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DLS6A8LzrsML6desL8JSboyKJswbUCb0x9NzKrJ2X4gxcx/Twv+fMejLOcXfkmvjTotlJpQMXVZx2L3HHZdmztZcxveraU6oKk1wJXGpbNCFnM+rmO9CM/BsmXdbBRlf0wLZ8nSGz8cL+3XSXYdDQ9yqFptL4nA3nJ2vc4vSztI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d793BOyo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XyiD4jS2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d793BOyo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XyiD4jS2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4436hjsZ007213;
	Fri, 3 May 2024 08:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=eiDhnT9xnLOHmzs859O+CjKy+Bbx5vwoj0OwUWrkSfo=;
 b=d793BOyovwbhWXR4SEv2Ra/pNIYVfK9TrNJyXd7EznyNsHsnwlEa9XW52OPf15j+vP6P
 Bio86ELFpYPvNJK4Hgs48QsYaRpx4SDZf7dLtDTESvAYbY0gyQV6HLjjEH+UNPIaeVKK
 YSGgk+78OOl5uaFZMTccq4wD+QdsIGGh8sT2HDdqlwLVsao3NR/0V2sGsHcmt99NyHN9
 DtfiBBvbYgS7qj2PUqhONhe+6szIvZvueeuvjGnKD9RsvekW2EMA6vy2SgZNWhTviAP9
 HG2s3U0D9plTBNq3orzebWjI9HKid7yA82A6D0CvLca7fnQAcuyJ+G9xM+SvzPXh7O99 ZA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrsdf19ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 08:33:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4438U0We034739;
	Fri, 3 May 2024 08:33:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtbtsu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 08:33:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzilNTMVuZFLgfslCrbauqnMPYxxOAMqCQvS9fgOiAm9sAXJ40E33LZoOvViO7NkqtcVlJWU9Usplk8ZDYFFfgaBEyesxSIlA3QPB4/YthL/EGkWNxc2pc/j52i+KrSGBq9lFdFcN4+3FTrP0mI3Ek/9TjRUtAAjFn9iFwXMRwxQzVVYUhG1A0UHGFZounf7tb6H2Rd1h0Mpv3BSAjnP+fZAuSYPmK5p4XNZtVgQ8CHAl1QJ8bnx42HVrP/pHnDictwJUHVDJoDXwsRWG1nCJJaiEtEWGTl3Ir4sj6FjkBZzUKbYAkNmqz2BObVZbjb1HhYz6lTJBHT9gQxK6UABgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiDhnT9xnLOHmzs859O+CjKy+Bbx5vwoj0OwUWrkSfo=;
 b=JHD2/XSllAgfVoyOFQ4rUSe0wVyIuH4fKo3jpx69h9PZgguFE5XNAS0JmxCEgBx3qAWDycMChwRlSIbUcZc7SxZt1KDPQIp4gG69xCk4nzjBcMLvGRukBo8q5kG8HxjuZ5H/qv0t8vFiQFMIcKXyjxKXDjr8HorOG+LkOJcn7Oq6G8AVgjEX72w76YyKLqS/dQMPsLKT2pq2GlZcA0RvCLyHdZgQfa7syAunevONXL7G0Wo319AtsunRnfm4whsEaWrbxICcry3+fi6ikHH84F2RHppbjuHuD0+Xo8hbjjAzk1R0gD/9/4ks3q9lKpKCH4lf2PTyrgR9ZK5Dz8PqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiDhnT9xnLOHmzs859O+CjKy+Bbx5vwoj0OwUWrkSfo=;
 b=XyiD4jS2aU4RnMGZu6LfESio+FfIVCsLdngwlxfgtcBQ1uAzNujcfgQN8CG738+9cZk5MfmWLfg1paP2bBJiwuih555lG8ssju7rBrCfATUHP2nhKuKq4ZhSlwGLHMzwBQmaSmdddXyvXy6wHVcG6KclVzp+T4WTsk+lcO7LyWU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7291.namprd10.prod.outlook.com (2603:10b6:930:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 08:33:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 08:33:09 +0000
Message-ID: <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
Date: Fri, 3 May 2024 09:33:05 +0100
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
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0637.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: ee305fac-3321-4816-701e-08dc6b4ba997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SEs0ajloeFA5UGZ6WEN2c1M2SkNNZEFqZFNZSUt1bEkxZUdwQlQyVlpyS0JL?=
 =?utf-8?B?andGeHRnT1cyV3IrYUJMY2piWUhuT25nWjFsNkRmWEVldnpLQi9saVJUYUJm?=
 =?utf-8?B?eFVsdENQajRTN3Q2VWZsYWlOQUhEM1VoNVNHd2FZaG5zbDRIcWhDTEhEVGR4?=
 =?utf-8?B?ZURDTmkvWGhFRWJueUZPQncrK0ZhZlVvYnR0VCttZ3lWWWxLV0owL1UzTjBP?=
 =?utf-8?B?TUpaUGVYa1FJbkJtTEtodFpFVys4WEhoRmJHOGxLNURORUkxbE1EZ0YzMk8y?=
 =?utf-8?B?ZVlHV2l2aEJ1VWc5cXpWYThDL2FxeTFFblgwNXM1NVJOV3k2SHlXdHdMWXI5?=
 =?utf-8?B?V05BbTFuZWdxUHNkTnFMT1VmSlh3VVVDckhRQVlrZGZmcnpKeHRHUjlqNWhJ?=
 =?utf-8?B?RjZ1bDVOeEpNQ3VUMTk5TS9BaVZoemgwRktqOWY5T1VsdTBLdlQxSEZZSkZL?=
 =?utf-8?B?UDdVMWp1MVR6RWdLRHdjM2FsNWp4YVkvTE1FWnY2MnF4QmttSjdld2FJUE4x?=
 =?utf-8?B?YjdPQ0s2dmFLajdQSWhvdHhjNnlYbEhtdTY5TW1MTnk0TlM5b3Bhd1pkcXFa?=
 =?utf-8?B?c0djU0JqbmdUaU5YTEFXV2huNlgydCs1WDZQVjVjRWMrcUlpbGJhN3N0OXlP?=
 =?utf-8?B?QW1Oc2g2ZFFNSVdDd1I4SnV2SjhDRC9mNFdZZ2VzUzRZOGlleFJScVhOUFBa?=
 =?utf-8?B?ZGl2VzlFbmJUUGdiNUFJUjR5L0J6MHZoV2dvYlpINUp5dk1YUDh0MjNwUmly?=
 =?utf-8?B?ejJkYnpZbWZsSEs0NlZSV1RHWTRGRlJlRHhOWmpsaVl6NWJlSGxORVpzMUJH?=
 =?utf-8?B?Z0ZxZkFEU0M1YTMwaTVjS1U4WmkxNXBoWHpROG05U0pTbExNQ3IxZXJENE1s?=
 =?utf-8?B?OTYveVZsMzlEY2FVa3puaUkzeDQzTUV1T2s5WFhvbjNzRlVkcWk3c0tsdSsz?=
 =?utf-8?B?ZUt3NFZmMmJFQTVJQXRYaDJUTVlwZFdkY0Q3aFFRK0RtOWFvdmtXT3JLOHYv?=
 =?utf-8?B?NytMbmZ0b1JxM3NQL1h4ZzlwSTMwSFF5anptVUtvb2FlM1JlbDl3YjZRZEk2?=
 =?utf-8?B?T3ZRb2xlR3htNlJqdHpEVE5nVnR1dCtmUFNES0VMYmlFbVFSNEMyVi90MlJk?=
 =?utf-8?B?dTA1ditiSCtHSWxsNFowS3g4RHRNaFE0VkVIM29zSTJhdUFMcUVRRFpqYXhN?=
 =?utf-8?B?dHN4WnFwMStIQ0hzTjBIaUg5TDNMNWR6RVl0TWRqTHNrV1R6UWp3MCt2WllU?=
 =?utf-8?B?VnVwTG1iY1YvTDlJVjY1bllBTmJDbXU1M2Fia3RFUjRyZ0tnUmJaSlNkYVUy?=
 =?utf-8?B?UVB3dnoyZHRUNUZ0Y3Y5dk5tWVNKR01LYWNCUExTUzNnSWVTbmVQejhIcWt4?=
 =?utf-8?B?VlRESFRoRDVGYVpHWFZBK0tjdWZ2Wk9MYWFlQ0RRQWdNcWJhVkxxQ1c4OEx5?=
 =?utf-8?B?TE84Kzl0c2JNc1QxVDFtUzR2S2NGSDY1bzRxWDlFeEx1K3FDZ2xVay9GWWhK?=
 =?utf-8?B?TmtBSTdrNmNiRjRVUTVUakhYTjJaNVQ2dEFkKy9DblRxbkd2OTY1QVFhcEdh?=
 =?utf-8?B?QklkMEdHR3BwTTdvand5SStGVkozakpYWEJla1lEOXZ1bmZ0ckJHdEh1V1B6?=
 =?utf-8?B?WG1TSmNwbDA1THpsNGZNWnVrRk8waDdOVDZLUXhuM05rVTNKWWRMc2Q2bHBz?=
 =?utf-8?B?bU1aQXNsWTVIU1N2Z2F4Ny9iMnBYL2ZpNzJoS0xSLzBUd1dvZXFSandRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M04yYVBjQmhsNm9NVERoRXRKU0E3Qk1YVmdvcms1YmtHQytCdWo0ODlOUUdx?=
 =?utf-8?B?eDZkd2ZsenZhU2Q2VUQ2Nm9VWUVRSy93djZjdkQ5b0NBQm5GOFRSREhBb3M0?=
 =?utf-8?B?VUlmb2NaMVpqUzRBQnRBOEVMRWtpYTNTK0xZeGNvRXFSckowR3k1ZDFGLzAw?=
 =?utf-8?B?VFRreW9sY1plWGY5bncxNmZ1M2IydFRqUm1OTVl3enhpdkRYVjJ0WWlnVk1R?=
 =?utf-8?B?QnlydzROOTcyZHdqQ0hSRFh2NkJJMU1YMndVb2JhWUJOVUJvc3IyNEpUUGk3?=
 =?utf-8?B?VXRMekpZNVllNHlRbkNnWTlMVFVVamNKdlZnOXF0aGZYZTBURTlIUWRaL3BN?=
 =?utf-8?B?WnJhdDVxT3JqeGN6S241OGtHc0VwZkUzUmowK2tBODBKeUY5b0g5MU5lbGR0?=
 =?utf-8?B?RWplQXhVLzl4SDlQK0I5Si9NTkZPQkhxNEFyRldhRFNIc0xmdGRpSTdUenQy?=
 =?utf-8?B?WURxMUdtLzluS0hyNlg4bVh1WkM5R0dvNndaNHdvN2xXZGNBVWllOGx6N2hy?=
 =?utf-8?B?c0RueGVadFFZbnZ5TkJVbnhZNFhRUEkrb0dqTHhHL01ZQWIwUnc2Rk01dTUx?=
 =?utf-8?B?c2JxQTlCbDZTN0F3TmJsRWFjOUlNRnB2TU9VbStJTGJvWFlHZkdxRlZsWm5S?=
 =?utf-8?B?TTlhOXhvamVtYVpPL1UrRXRFcmZvZXdnbXhlcTZweVJoQTFvckdkM2FMV1ov?=
 =?utf-8?B?ODd6STRUMlM0Ym45STRMYTAxTXFOOGd2U3A0UUNmMTlydk1nU3R3cVdPMEdi?=
 =?utf-8?B?TGIxQllHT1FURzRtMThENHh1VWtVUVFNTW1nWVVCQWM4bTdCbHZhQlN3bDZJ?=
 =?utf-8?B?cDAyZ1krbE1PMnNFV0RWaEV4U3M1RlhZM3gyK0ZkZDN3a1lCenlvZEU1ckpR?=
 =?utf-8?B?N2huYXdmcGxqcHpQOVBXeXF5dXdVTHpsUkhEbWxCU2hRbDNTOGtCcU5oMHRC?=
 =?utf-8?B?YlNuOEZGL01nV3NnZXZsSTlzbnZsV0tuL3FpTDVwcTZVZWpuaDEvU1BKekdk?=
 =?utf-8?B?MWxWOVR1NVQ5TGphdjR1bFhYS1ZXbFNFSU5ncWpIZkN1T1I2U3JFdllVZUhE?=
 =?utf-8?B?cjNocGo4TFFmNmRHOUVrdXJDUlRUZm0rRnp2U0ZzZk9DV0s4c2NQSG1GMXRT?=
 =?utf-8?B?cDRnVHYzeVN6TDFYcG5LdnBJMGlNeHF3bC9xckZNUytBd1dpdGE4SzBoOG8x?=
 =?utf-8?B?b2thNnZ5YzhqN2xOalFZUTJuUmdCQXRVQnh5TU5iL2lmbGdib1g5cnZzVXVY?=
 =?utf-8?B?TkN1VzFjbDRLSkR5cFlmMmpESzY3OC9FSVp1eEV2OVpZVGJaV2NPQ1llU0Zy?=
 =?utf-8?B?b1dVS0xvNHVjbnBTOG1pcGcxSktGVFIvdms1U2lGTWZWcEhGcUwvZU9pdUxG?=
 =?utf-8?B?aWtBTHZaN0NlcDNjSEwzbnRoUllUUkJtWDZBK0ppbHVvWDNuSGxmbitSTnU3?=
 =?utf-8?B?MzdMaHN5Sy9RYVhIY2R3OXlNOVRHRHc4a1RVRFU3ZTF3K1BmaDQzbGpXR2l0?=
 =?utf-8?B?bURaOUdZbGNSbkZuMEkwSXBDTHlHVkJnS3Q4MUZTbGt2THdZSGF5bUtQNWcv?=
 =?utf-8?B?blBuUVdEbGRDZFNDUm9abk9EWklBQU5IVnRiaDRoUVNBdWR5bU9YVll3NnZu?=
 =?utf-8?B?SkptSzB2TFk1MDRFNitNUGZYd0hSb3VvaXM3anM2MFgydWwvcER6bEdBMUs1?=
 =?utf-8?B?eUhhL1lrQTdJTG1QNnNkYlBTak1KamtYcS8yMWE5enFrSDZhV1owNWJJcXlP?=
 =?utf-8?B?VW53V28zQnp0V1NvVlhrNUZITjZqVjBUaXdNTlJjWTNRQnM4Z0RMbXdpSktK?=
 =?utf-8?B?UmN0VWd1RldTb1E4R0lVb0JIYlRPSTM5eWI4dDNsdTIwcStRR1FSS2ZUVGYx?=
 =?utf-8?B?akdacjB6VXdLUmxNRXh1Uko4N3ladXE2QnJhWkVabmQ0ZWdFTjFNbFQ2UVJz?=
 =?utf-8?B?dkt4MExTWVVoUE9LOWJrUlVOczhnYmxhSG12OUlaN29Wamg0eER6aEdlZWZt?=
 =?utf-8?B?aThKc1dRcWh0aUVWWHFGWjVjdTZHNDNrYTRtY2tuTHc1aFNTbURXcytzZG9q?=
 =?utf-8?B?STZFMWFqbGdHNjdQR0hvRFlFTHkyWnBjWmZ5YUhMMEtONjJpWStxZUF2b2lF?=
 =?utf-8?B?OEEraHJSYW1iNzd4Rkd3Rk5lRjBZS1hTOXZjdTBBbUgzRzRsdU4vdUFnZ1ZC?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Gm5Jm/M3tL272WMEPUL09k1C3lQQiPomtEfmoMqEIDQRfikxLYn+qIasDhOZegznhdnf3nOtnLZR92XoiEXds/Hx2V87yGgI5tkIUzSV9+8rmIVbkPSJL/ZlgsD10U9w/hfyoRHDZ9lIecO2xhISf5GdFem3tV/G1lOdYkiJsbOuifcjSR9O2V4B+vXwZsDxFODIxUtfm7txisb3E9M9WBOEiSIaBF96FEQOXnudXrcNFYwu4EtbqFn7hJjRkpXtN5EpsJB63po6I87y4SwKFKbzPjCRJpU5IoM80xb2arE/e4g27fT1r/eFycO7bb+DP9O8um52w6dDzcaEfLCfsaDhQwRz1VCnZ1bgWmpG/ungiIXXx1Rvj73FK24upNMzhaJ8lsvwR4wVMIICn6QM1t4HeFca4l6rIhD7QpqFYqkOx0Iu5ioV1pK+AJ8RtG9iOwetrBsqutqZzaYD1mGAhBmAoJDAdrYvRaMp43O52ZlSvXxGN/aCneMrP2NW5pFXR15Uz/0ZEIZnZlchE33NQnKeIFxK5ehcSXA7WgyHwc6p3saEJd+eBL7TxT0BTqxSRFJ0ojFHPJZBKQdnCFKxJ5kUMRrWZHfNgwbZcJD4mxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee305fac-3321-4816-701e-08dc6b4ba997
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 08:33:09.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjhoxCFd76lxtuDEcCqYS5C0FO/PLi+IqKNDoLHxVKXVxw8U8MnL7WnFp7lNYwUx0oZL6C7o3VE3bQpiri764g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_05,2024-05-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405030060
X-Proofpoint-GUID: 5fzW_ksSkV6gx6E7ka92kJfDcPIYB0xn
X-Proofpoint-ORIG-GUID: 5fzW_ksSkV6gx6E7ka92kJfDcPIYB0xn

On 03/05/2024 04:15, Li, Eric (Honggang) wrote:
> John,
> 
> I agree that the call to sas_ex_join_wide_port() is not mandatory. In
> fact, some logic here is similar to that function. We don't need to do
> it again.
> But just updating the phy_state may not be enough. I suppose you still
> need to add that PHY into the corresponding wide port by calling
> sas_port_add_phy() and update phy->port.
> Just updating the phy_state may avoid the port disabled in this issue,
> but other missing piece of work may cause other issues.
> 

If you check the commit in which that call to sas_ex_join_wide_port() 
was originally added - 19252de - it was added together with the comment 
"Due to races, the phy might not get added to the wide port, so we add 
the phy to the wide port here". However the code to set phy_state = 
PHY_STATE_DISCOVERED already existed before that commit.

When all that code was removed in a1b6fb947f923, I am just wondering if 
we have kept the phy_state = PHY_STATE_DISCOVERED code.

Anyway, would we really join a wideport with the downstream expander? I 
would just assume that we would be creating a new wideport, and a 
subsequent scanned phy would be added to it.


> Eric Li
> 
> 
> Internal Use - Confidential

Please don't add this.

I am also getting an "Retrieval using the IMAP4 protocol failed for the 
following message: 56472" error on your messages." Anyway idea why?

Thanks,
John
