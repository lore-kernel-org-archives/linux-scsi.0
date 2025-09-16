Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2827F010
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758014531; cv=fail; b=tSQgbhA2QMaH6swX1OCXNp8VvVXlejRpndYO3wCzHj0w26vHL0/sdTORYS6VjfXnVuhkId3EXFF0IdznAShO9Z1iOwUXCkL/pdsHOMHqFhzcepgAyzZFFnbnXhyQ9O4k1S53VOJ/Dk2fAf1cMp+U1X/wtdXhch9bIub91DJwPnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758014531; c=relaxed/simple;
	bh=aldKFcrBZb1XNuUKNZk/cFBzd0sxb0l0sr3N7LqwVAE=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pMFxpFe7X3ti1R5gWcjDNABM/PCkLHN8sQd/MVKyhw9+c6wL8hg63jWK9kvnjok5AZ08bya0WrEh/y4wLMOq5xvWSv4qmV4kIhm73g0+0FjQ9Hq67VbUsQFsN6j+Kw1VaDaEgNo4XhCAcm0CDRvP2tCZb6UFNTbw5OIycTpm9CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VQYZ959F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QejPEoul; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VQYZ959F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QejPEoul"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1gNBL029793;
	Tue, 16 Sep 2025 09:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vPxqvDMeZ7Oh/sAWBeaIwJfPGfzR1R4rKCOd2dvzHZ0=; b=
	VQYZ959F3NOtAS4CfklgIA3lz3vAbMli/lRN3O6bLD2B9ae1O+4JvTTbYaZsHSep
	5Nn0pMA2KnBt64n8oD96XwEtqxiRXA1rXt1bj1sdCwtUjNJXoJsBl/Hl5+t2mpOm
	8FRYVBVePC0x+AYrRMD4bTGNEBAZ/RBjcvA/VSMgH8y1da/xMLfl7jq2twoKKJMS
	F79QiztoS3WH/sUH3mMbvafaF0kEpu0hfeZwVBKUxZmZgiYsg5aYzvyvUdb2SHPb
	070vfXwv3iWayV2gpZOqCE0eCMnUvSbSRPCmoMw9PYPsGticJIRRqIWfqrLwDigJ
	IFzdDRp3F4IpqdznxeSCCw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49507w47hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:22:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G7B6FP028761;
	Tue, 16 Sep 2025 09:22:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2c48x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plV5QS9vX5NPvMpg/NWOMHF4bhbbi6FOhSteqVno7aaSx+0PACETnfdX/bXr/vYYzsH9is2d/YTO4y4NS58mJ9wS8zebj5DgvF5Q1nOnAE2Y1d6ARdLaATFV5/eLXpIZpZ4fknLeyQPde/y42xrIs47iBQyIdWhba0m0q0+dEBNF1Q1TjTXDAzB1KjIt+7tyrliQ7DaVmufgXZeYvl39mfcMnXQg/sPJwFZnfawaDaFnGdTV2ys6DTUZqUDxuhERlJ6zsolE5NwlvN35SeXJm3CqngjaXLRbAIHxGFD+NwWatxFumwzWTSwKC2Hsh+KBq3kIx1QahdyDhpcmfWJyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPxqvDMeZ7Oh/sAWBeaIwJfPGfzR1R4rKCOd2dvzHZ0=;
 b=iWJgfz8PfiubpLCAtTWl0OgkT/Tr4rq6WERjuJPLfEEuRdk07wXFH6tiLSrSSjdpUyW5AYV8Y/T7wUr9CEOEesWScqYbcThLuzAFpfXY2CQiNkTMqpfTrcZZCI9MmeNKJt/qLEOGKpQKs0brP0psJMR2pNFVO6UZYRF1f5MVZECu3gtIJfZgYUd/DbC0kar4G3MzbgBYr5VfFtyaiVRkj4vdbkwiH9bvL5/AuwOGT9OaXVVwygyxu+3z1H/8fbstWM8xwyQtg0ES8ZFHNSYKImWI1yVninKok58Rso/OyhBizgYDExqfzN36KqvZ6CWJGVG6AusqZDHIzwKTFGRmiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPxqvDMeZ7Oh/sAWBeaIwJfPGfzR1R4rKCOd2dvzHZ0=;
 b=QejPEoulpPRSwCRAWqKfqIGSMdOe74FwREd6dxy4yHkW4CNNRhSAjleTYo59T2pC3eaF7YrMBYnWFAiQyG0VBqkXj3tzG5m6JUxlpUj//i4MIa64gfMYqJ/SiWZk3fNVnnOSarUl+g+/M9pbIEMe9ajr9Wz4HhGqhGradyWDdjM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BY5PR10MB4146.namprd10.prod.outlook.com (2603:10b6:a03:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 09:21:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 09:21:57 +0000
Message-ID: <8ea4cf96-f255-4aa0-9e7d-aaf26ff01cad@oracle.com>
Date: Tue, 16 Sep 2025 10:21:55 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 04/29] scsi: core: Support allocating a pseudo SCSI
 device
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-5-bvanassche@acm.org>
 <4c865666-a2d9-4037-9762-4bed3490a4ea@oracle.com>
 <3de95224-8704-4843-a5dc-7705faff532c@suse.de>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <3de95224-8704-4843-a5dc-7705faff532c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BY5PR10MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6c22c3-49e4-40cb-f223-08ddf5027bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnZKclVaUkE2TllpNFBiYU9nKzB3QTZEMG0zTjB3cW12cHVHcWFwK0RhS3pE?=
 =?utf-8?B?OEduY0VxTWZ5bFpmYmF4YncrdGdlTE8yQXVNeXdCVHhPb2o5SlIzbHUwNGVL?=
 =?utf-8?B?UHFYam03di9XRU5vZUFrUSs5L1hyTERvZGJDQUJyNXVVSXoxVjUxSythdHlw?=
 =?utf-8?B?dmFsUE9oZnQxNkpvUTZwYjFrZ1k2RFpUV1pFLytsTWVJZld3dHNsSFlmSTFW?=
 =?utf-8?B?a3J3TmhiZ25iZ0ZWZ0F1cjdUTXd3OG1CQWlLYzZOeUxUQ3FqK1pLVUxaUHpB?=
 =?utf-8?B?U0NnRHFHeTB6cEpRNWI3VktMVjZHOFR6ZjBkVVI4QVJkSnZKU2t5d2R6N0Qx?=
 =?utf-8?B?eWZoV2RTN0F5dFlxdGtJblhVTU53S1IzREpyUzhXUlZuYnVPYUxlTCtpQ2VH?=
 =?utf-8?B?RTQyUmhkV0V2Z3RNUnBDOFlKODlvQmI2V0NoeU4xTENkK1U4TjgyUEVGalgx?=
 =?utf-8?B?YjVWMU9nZ3Fndk5OS0dsZ0w3ejBmZ2h2bUFSTVQ1VHE0YjFFYUIwaWFTSlFB?=
 =?utf-8?B?Z0RiMkR6elR2N002L0grZ1pMbHVmYkl5R002V2k3QVdrVkt2WWFia09zSVhl?=
 =?utf-8?B?Qm5qUVhmcWJTanhvZ0owaE1XbCtBd2tRMUIwQlhob2VNcHZ6SDVhQzVGWkxV?=
 =?utf-8?B?OTkySHJSQ2VlMVNnRThqNVl1eTc3dW9aamV0Z0NXTFl6b1o5WWwyaDRrQTdH?=
 =?utf-8?B?azI1ci9Henk1N0FndktuMWl0WlA2UllXbWFsUjd0SlJTc2xjNVlaTWt0WW5R?=
 =?utf-8?B?bjByNUxONEpNSXVyWGZWWkg1U1h5VnJUNFRmUHJqTWh1ZHF2Kzh6RnZkejkx?=
 =?utf-8?B?WTl0UmdCM0hXaWZCRUxCTlRhdjhEaTg1WWU1czJaZi9HZXkzUmFDK1dLOHJJ?=
 =?utf-8?B?OFVRS2JBUklVUUV4V3hHK0JiQmUwa3g4T3VVVHMwUzZCcm10ZUlWeUZqTUFj?=
 =?utf-8?B?amVmWDJvNWE4SGx1ZlV6MlJBVFV5OFdPTTJ5WUpQa2YycGYwSysrMWZOMXdN?=
 =?utf-8?B?M1hQQVozZ0dYMGcrRDVLb3lLZDl4WmFYYWRVSXNQOHZTd3ZlSHdobWlyVm81?=
 =?utf-8?B?bTlTdVl3Z3ZNb0hVOU4rVHZITGwwMnlaSExmMGxGbmxGTmJUS3JHUkpLZFpn?=
 =?utf-8?B?QWJCY2JTelY3eUgwMjNGWEN1a1hsMEd2dm9OU080TTZWMVo5b1BxWDFOWkwr?=
 =?utf-8?B?ZGU2NTliNkg5MjVhamZGSFNVNEEwSWEzVVFqYzhiMU4vblRXYmkzelM3bXBP?=
 =?utf-8?B?MXVzK2o5U2lwU0RVSW9aVFZCOEFvQkVCOVdxK1dKZHF6aUFXekZFR3lPbG1y?=
 =?utf-8?B?ZzJjQmx0ZUh4c0toS1VpNytva1p2bVZtaXR5Rm0xRUQxNEJmZWRGeHNYMitK?=
 =?utf-8?B?T09rbFU3clFOMmNpMmoxc1lVZ1NWdkNKNEROOU5sbnl2MWlKWExsQUJpaThL?=
 =?utf-8?B?MDZyN0prMEdPbERwZlF0aXB5VVhwZ21RSGp0d1ljVDBZTnVmeHF0T0dLRkI1?=
 =?utf-8?B?L3d3YklyQ0lBRWFJQXVxSGRqZkMvZElmQVkwWnRlY0xDTUhYbjh1YTBJT0s1?=
 =?utf-8?B?WldTejlMam1ueWtzRVVOZGtBSW1VdkpWMHBZTS83andoc3BtU2tQVWo3aE1U?=
 =?utf-8?B?ZTM1TjJoNjlBSlBXRVR3ZWExbDUvdjZtUVFxUVhWNStZcXo1NkhQbkJjS25T?=
 =?utf-8?B?TTlVZ3hNckk5TXVublRlanBVeGtMa21VSDRzTzVWaWJndUc5czhFVldIdjNi?=
 =?utf-8?B?R1lleWtvdWtZZGNrZTh6WHRFT3kwSXNYR1RYOUluVkxtR0dRbExWaHNxaTFu?=
 =?utf-8?Q?zqq1Jx9ZmRvU674YDhcJk+XgVzycYeoQtScHY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGtHUmwxclZRL3NlbFo1NXl4dVdCdkp4WnFFUDVtdUh4QzlLTjhITUIxeHEx?=
 =?utf-8?B?SVZwVjVJV2pFUlpNa2VKVExEZS9vbWl6Y2JVWlh3azJGdHpoR05pbmgvRHVC?=
 =?utf-8?B?WCtEZklkMVhnbkJkOXd1QkswS3dDWW5MTGpDK2JNNHJwVGRML3N6aDY1cXJX?=
 =?utf-8?B?YzNRbk9DL0lCZXdhWVBlUitsQU9lYzMydXQyZ1FIK3N3VUdWRC9GTktPL0lk?=
 =?utf-8?B?TEdZTzV0dk01bDRsOCsrSFVlSWVWbFZFemQwaGxwK2RqSzc1Z1J6YjU0TnNR?=
 =?utf-8?B?OWZJMS80MVFWazkvNVlWNldOYnU3b29iS1g4OUVKbzZqUGRwRFQxa3ZTQUYz?=
 =?utf-8?B?UXNHTEJNTkJTZkpvaUt6bXJHT05FTHUwQ29zdFBqVlY0Y2MwS0hqb1RJUFVD?=
 =?utf-8?B?czdrb2pzQUpHN0hZSHJoM2RhRmNkWW9Kb3JMVUh2TnovanhCWm0rMGxZYXVE?=
 =?utf-8?B?Mmdya3lMd3RuaEdRSlhKTGNBb01LMmlYWkYwcEgyanNPQWpCWnlLaTV6TGNr?=
 =?utf-8?B?UkZId2Q4dkdpaVovcEpobWlGZ0hZTWU3V24zeWhUUXZNVExUT251MzMwTnNz?=
 =?utf-8?B?Nm5yalVmWGJOdXl4UU53QmZESC9hMUxSTGkxd004dWFMbStKaFplTTA4U3BO?=
 =?utf-8?B?N09xVFpBa1hBT3BTQ3prYVpoL2RleVNqUlhhSS9zejE1Tm9aZm15dnlieW9W?=
 =?utf-8?B?RnliZzZCeCtjSy93UHdkako1WU5JMDdIVmVRajZZMTNaei9kMlBESWhXdlZ4?=
 =?utf-8?B?TGxySzNmUXhyV1RBcUhXODNNeGY2SnNNb1RhODN6SUZrNXZPKzNpcHhYK3Er?=
 =?utf-8?B?UlVlS2ErSEUzMmlLdHRKK3F6ejE2UGpyTnVwQUZSQXA5TVNaSG1DcHNVWVZI?=
 =?utf-8?B?dHQ3UTN5Rk40Q001ckhPYXNQd1lBMmcrc0ROL3ZzOGc1OWpMRjg2NUpVUDVa?=
 =?utf-8?B?cTZaZU1xZG5naVA1NFNydnFMYnVOalNXNTBKaDJvUWtiTGxYWllnWXVUcWJH?=
 =?utf-8?B?R0ZOckd6R25JNzRVS01pN0l2RVFqb2tzNVR1ZEY3SG1vMjdRYVJNS1FPblU5?=
 =?utf-8?B?M01mWTRVckJEdUxWWmV1VmtVK0F2VmRJd1ZGNXk1YVpiR2xVSVoyUWVEejU5?=
 =?utf-8?B?ejNtUFpIaTZPZkZLaGxIVzNhcFBYaU5hTlFJazBwdElLSk5Tb0lNMi9GWjQw?=
 =?utf-8?B?Rnp4czA1MUNEUWkrNWxrMUxqSTVmRWlhUEhMVFFzV2RRT080REFPbElNSzQz?=
 =?utf-8?B?NTZvakhUbnVLYnVqRTJpTXhWemdNcXlqN3Q4YTJmMWg1MGVlZE9hc3JiQWE4?=
 =?utf-8?B?L3E5dUxwQXFxczFsRnU1Z0VxakJ1Lzh5NytlTmM5RVJyZ1Z6bHcxT1lLNUtG?=
 =?utf-8?B?cTNVZklmZFc4TzlKTTlhQzhvY1VmcG5VVStHYVBHVDZSZ3kvN2VnVmVLNzMy?=
 =?utf-8?B?OWZ5MVpiNE1tU1YzczVjTE9ZLzA5WUd5Y2NjeFhOOUl2NEh4Q1BQQjcvVEEw?=
 =?utf-8?B?UlhYVUpwWmY2V0RmUUJuTVFuOUFZd3NXRFBFamo3aXJHY2g5b3Bud3RmcUJj?=
 =?utf-8?B?S295cUhnMmpmamJ2d1ZlekdFWDcwZnJtMzMzODBrbGtMQzRLblZjYTQ0MDZW?=
 =?utf-8?B?ZmtKRVZzSjRyMWFkOTExOXBGaVlnanRwZDcwY0ZyalBDalN2SE14clloRVgv?=
 =?utf-8?B?MS9pUjhXUENxZUFERlY3Y3VqcnYxbnZCbVhiMGZ0bnZCN214SWdZWkt5d0Z0?=
 =?utf-8?B?dU1zK0MxbWdhSFRCemRhVVMzWlpvdlZ3Ui96VWhYY2MzajAraDV2Si8zMEFr?=
 =?utf-8?B?ZnNWcDN6cHN4cFBFc1RGdG43UWRicTRkTjN2eE0yT0ZrTUI0a0JrTFRRVGx1?=
 =?utf-8?B?VllGMmtJekI3c3gxYWQ3TzZOZWpKaERtVmxYNE0zSVRjUDVJM1B1TG5DSTdt?=
 =?utf-8?B?OG5tOVFRcnpxZ1ZxcWQyMC9ZY3h2ZHArK3hocmVjMit0MWZKZVVWc3hNZ2xy?=
 =?utf-8?B?a3UydGQ0dXFkWW8xY3NFeXRvcGMyZWZqOXhqck4ydU1MazJTekpvcUMwR2Fm?=
 =?utf-8?B?ejFPMVREbjVvOTk4TzJNZ1B6NUk1aTZUWlNER2R4Q2lVSHh1aU5pQUhGdlBp?=
 =?utf-8?B?Mi9PSVRLdFo5ZTQ0Qytpb2p4eFVSRzJ6RWFURGpNVGRhSld5dS91S3hQTFJP?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ea3yg6EJk60fxoNI6BQB9lFWMcI2tLqz06sxhw9LZ1jeV8P43r1XdYUhFCEAEH/UJ9/n/jm1WYCaloNB5MD2ZQEMpUCqVw09JNKtOAIx8M2zscDIHv6zOdxvwgEPuSCAgGjZBoUojPyym7EPhTat+bJFSJPAyAXxwwojTy+4KynDssrszqCtgllwGa/fr9wH1UHN1FTOgQ0aKNAyAMbExBfH+rlJDAe4J+HvV18tr0pHoWwsbuWknJZCzF25/fjku+qSPhfuUSx6t0fVX2HzdGvqpL7AOb3LV8hA4qgm2Pli0m91dfhUfT+Q2SjDr9kqMf85f1ophM8ggRW8eqz7Ctg9qOOZvdLUFJGBJM5CV7cOsFGVCrSorqs8SenB+qWcMNLAegA8eI51Q3jjFbhk88e4BCxQ4S4sKl3oq8MJcid+2xLlsM1eMxjFO1/2PEqET7XHULZqit8MZa9tS0IU0OacronFbcH9royquSQ+dverR04deXTlo3UskmVBrmuRE38oqRqyVhg1AT09wIGA4llS2cttqOL2jdVLe0425ChS84zAsGWCWUxr/q55bmJ5vwZWmim/j+3CBQ7BLx/m/qul3NnSbjpLUdKPVzIUw5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6c22c3-49e4-40cb-f223-08ddf5027bde
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:21:57.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtXtGr3jhL9IHTESwSpIKhDgsBfStBtid24s3UmQv2c+bjzzwaPLhvkHRAjWGRGjnijFB1T9prCSg353Ku7M0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNSBTYWx0ZWRfX8N5eVWwDjmb6
 dGGHuNaVFP4J0s8BiOykQya9UuYADrU8Hb5XQFVAyAdF+MTRpWKd9VkADroIe0IOJDB2Ha/TGHE
 LDHFswcuz+l2Q6faTsUHW3DtvGyWLZCl8sUpC+Aore8EvAmazWFJoW7uPSi6M/p+zj32MKvTHRl
 L2oExOexbUjhJt7yaN+Iv9ihNKhsVNc/G/4p8Oa65JFGn1j+x4Ez3eEtNXWpXsmR3gvsU36tNaL
 9iO2Ec+KwX45x8rrCKYCv/q7esNFc4koKVT9mRU/yHQEUg1vGXzKWB12jcKUN7wZ5vHqZhm7ZhQ
 B53Y8Ybse1crX2+Xjmm6gOB/IQHKg/4CeVbXdA96QDtgE/OKyssFLgjy5wqwnHEL6MBf7t/zwI4
 Kymlgr3M
X-Proofpoint-ORIG-GUID: 3mjDT-RmrZkbbMwPHBAnW52s8pnd6sLJ
X-Authority-Analysis: v=2.4 cv=RtPFLDmK c=1 sm=1 tr=0 ts=68c92c39 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8
 a=N54-gffFAAAA:8 a=6jyq19TxUs6_TG6nomgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3mjDT-RmrZkbbMwPHBAnW52s8pnd6sLJ

On 16/09/2025 09:44, Hannes Reinecke wrote:
> On 9/16/25 10:21, John Garry wrote:
>> On 12/09/2025 19:21, Bart Van Assche wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> Allocate a pseudo SCSI device if 'nr_reserved_cmds' has been set. Pseudo
>>> SCSI devices have the SCSI ID <max_id>:U64_MAX so they won't clash with
>>> any devices the LLD might create. Pseudo SCSI devices are excluded from
>>> scanning and will not show up in sysfs. Additionally, pseudo SCSI
>>> devices are skipped by shost_for_each_device(). This prevents that the
>>> SCSI error handler tries to submit a reset to a non-existent logical 
>>> unit.
>>>
>>> Do not allocate a budget map for pseudo SCSI devices since the
>>> cmd_per_lun limit does not apply to pseudo SCSI devices.
>>
>> IDGI, in v3 series you said that you would allocate the budget map 
>> https://urldefense.com/v3/__https://lore.kernel.org/linux- 
>> scsi/20250827000816.2370150-1-__;!!ACWV5N9M2RV99hQ! 
>> PXP56tO8nGuApLOmFXRDRrX5- 
>> UTPdJrsBgtullL3kVHsDxEZ0GtNqiKsGG1CxDiJjcvLSCcwCkBkO9U$ 
>> bvanassche@acm.org/T/#m13c361e081b886b9318238b6dc05b571840b9698
>>
>> FWIW, I still think that it is worth allocating the budget map for the 
>> psuedo sdev and making the queue depth the same as 
>> nr_reserved_commands via a scsi_change_queue_depth() call.
>>
> No. budget map is only for resource arbitration between several devices
> sharing the same underlying bitmap. Which doesn't apply for the pseudo
> device; that is a virtual device pointing to the HBA itself, of which
> we only every will have _one_.

What you write is true. However, I am just suggesting a method to keep 
the core code clean, even if we are not sticking to the tenet of queue 
depths only applying to real sdevs.

> 
>> If we want to optimise budget code handling, then I think that it is 
>> worth doing later. The whole budget map and cmd_per_lun handling is 
>> murky IMHO.
>>
> Oh, most definitely. budget map / cmd_per_lun was okay for single queue
> devices where we couldn't really tell how many commands we should send.
> But for multiqueue we know exactly how many commands should be possible,
> so for _real_ multiqueue devices cmd_per_lun is pretty pointless if not
> downright detrimental.
> _Unless_ we have a multiqueue device with a shared host tagset, then it
> sort of would make sense. But then one wonders why sbitmap doesn't do
> that internally.
> 
> Sounds like a fun topic for ALPSS.
> 
>>>
>>> Do not perform queue depth ramp up / ramp down for pseudo SCSI devices.
>>
>> Are we even ever going to try ramp up or down for the pseudo sdev?
>>
> No. Why would you want to restrict the number of eg TMFs you could send?

My question was really theory vs practice, that being - are we going to 
see "queue full" errors for reserved commands which will lead us to 
entering the queue depth ramping? The answer is below...

> 
>> I suppose we could see it if there is some internal reserved command 
>> error, right?
>>
> That would be equivalent to the HBA rejecting TMFs with 'out of 
> resources'. At which point I would declare the HBA hosed and do
> a full host/PCI reset.

Sure, maybe that is the best way to go.

Thanks,
John

