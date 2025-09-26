Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E52874F0
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 07:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758871486; cv=fail; b=C5CLwVVAKX42/PAlHq1qmYzCI5quYX6KUJLgw30w8/g9JF2I/yM6ABzDxzeV5UV0aIKToSh8SPYGsGyoK1w/0cSM+bKkEbYw6HXJsmwPRJQU/ftw4GpUkEDqjSEkvZSdttnFN22H/EyynYKVWyXGy3y8OXB++xZAFeu61MgO3kU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758871486; c=relaxed/simple;
	bh=l1gD0zDllPGNU7zLOhvYNRKnpJGqdjlFTzspgXHM7dg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rOJSc6T4/+iT4muKlhVDfBOQygoDqnj9b6bvLlKufBktBUxQjJIdQ/xHmvMQwRa1na4vDIeSTfON8Sz13mJrrMX1rLXamfm/jN3InyjvdBekTlbXTPZWXtp/Q47ixDCNg0GPsSTu5fX09eDkqYv0DYuFTr0WCIqHpJqIEUvAaz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WUBQ1b9s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GsZ87Hgz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WUBQ1b9s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GsZ87Hgz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q7OCWQ014557;
	Fri, 26 Sep 2025 07:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sWRcvVt3/kNG5r9JurILZkF3kOcsKbvwiBo8OGLboJA=; b=
	WUBQ1b9swx95gDc8ApI4Lyydb0Mg25IHqN14AGa2VaZS6bezVe+pMsY2R4mIoipw
	vJRW7ofTYtLXZbx1k31eItGXlGfU20RmPpVCl1Ou8oenfBG0Ry0piaTc4K+3jk/D
	GRwID8peMkaP649pDAwAWjZEhnRdWTMFuRUAuVey/titt+5OpkjOoocpuvKLVSz2
	TE6T8rfhFpE4O8473LD5YVwx9uMYCofs6+5e5MyTX9Urccn++RbVKucigR7+U0EP
	yYT5zRF+w/70ubUfQIgYqlZKrVHm8Fl8qbk/DBx+OWDNS0vjk2nVMxItkgdgK+XU
	/pKDCqT6JzxAypxLc0RZvw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49dpdp800j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:24:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q6G7eT002048;
	Fri, 26 Sep 2025 07:24:34 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49dawk4ekj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eelEmB6t6Ds8xNHLq1y3Jg+uFvk/Yb3ykRlP+PwM89N6mODSBBeTGpLgJE+BoZArJdHj9fsv/Dkby3SB0nrHTKh17V59AN2VlHnzev+lFSPFNBR35hUnV6PtoSnixWO0mR5aVBxdrwMAcCrxYUk2283cXqqnCi8d6Gn/q8F9ncWNl6HedQ0fnWjwlcZ2b97AUqIz2pHgE/YHTkHIERyJG9WgY6IRpYOmOKdZKp1jCwGgV+ziUcMWerPeme4Ef/LqJSZYKP+cDB5OXghpsHMB6cIdDdDx0OA5jtm4rSn1zNIrjkDrQUbo+RYAjxTA1x0+exNpgbl+7sC0TWEI8NWRpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWRcvVt3/kNG5r9JurILZkF3kOcsKbvwiBo8OGLboJA=;
 b=U0mHUCQNUFvpeoOUT/+1yM4Va85upBpgnWL+I9ZZx8ado+vk543ASkudkm9/sL3ubKHzAW1twaABElzHAs6XYHwlCYae5aqchSE0/wWP+TGLvXbB+9JsK8S2FPrSvAjYMhzMJylzA31TiW3T5/VEZfZhFgUzF8TROqQJ7QBL2JwGU6DjuVrIYyyPMSohqX3CiALYI35ATTDT5a8O6agUMjTmfVMUbK7vjLGlRt04qQnDU1GB7bAFdFUyFYEi0no1Sr+yOGqdvpHnVqlOTOHTLtN7EnBxy45XZ4XhvVHJ2Y0wewmlnNJr3hBlSBwBLEL+JSDYlnVdwFk5B3gfChFNaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWRcvVt3/kNG5r9JurILZkF3kOcsKbvwiBo8OGLboJA=;
 b=GsZ87HgzQjQvIJPnoIdbVA+o7byS7FcqjwAD+kSS+Rsvzb/ZRjlmHtkS5W738z4CQ3kvmZfWcpdUc/XFT4YAF96c2BsMaoGuwmfkONZpRNE8TK3/OhEvq8U6Xl4EpKGxCcMCSUM/1tUITiDSOpqoiCt8iR3bEWgQqbikufygn14=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Fri, 26 Sep
 2025 07:24:26 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 26 Sep 2025
 07:24:26 +0000
Message-ID: <0b41e75c-daac-4f3b-ad90-bfb1f42d81bc@oracle.com>
Date: Fri, 26 Sep 2025 08:24:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/28] scsi: core: Introduce .queue_reserved_command()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-6-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250924203142.4073403-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0129.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: d26c22fa-b08a-4a18-fcc8-08ddfccdb920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VURGQVBrL0d5RUhKR1VFdUxyVnhjUUY4ZXRQVjVoTGJVencrdllNZXFlb25o?=
 =?utf-8?B?SVY5UTFCd3FvS2hOdTFES1pJU1VhRUs4R2pMV1JERTBxUHpNMUNhQ3BiSkxo?=
 =?utf-8?B?Y3labHA1aDcwMjlkaXdjbkNQcHZPTGx3UzdDT25UMk1OR3VheEdZNHZQN2do?=
 =?utf-8?B?RVNrTkZOSENlNkowQ3VSY3ZoTE8wdnVJRUs3RHUvMWFyOTE5bVU5bWppdEtn?=
 =?utf-8?B?NUw4R2Y4V2pPS2J6NThvcXJZWGVVWER3OG1BWDhDcFoxZFNxRjFKd09rTVph?=
 =?utf-8?B?TnhOUldIMnh6a1IwcGJsak1ndURmK294M3ZXZVkrMEszUDBVeGZxdlV3anIx?=
 =?utf-8?B?YitqK1B1U3JNLzcvb1doNS9wYmpMQnZFaElPQkQwcnhPNGlrbjhpUlpncCsy?=
 =?utf-8?B?cDkrQzdNNGx5bkRUOVc2MjB6WldWNVBieVh4Z000SGNMZ2FsZlp0T3kyemFj?=
 =?utf-8?B?c1hIR2VOMlZxUDZsRU1jMi9ESjJhSGJpSEE1VUVjbVlEb1RqZnVtaWZRdU5O?=
 =?utf-8?B?aStlamNtY2tQV0hjYmRlZWdkazg5VDVTbEFuTnNNbWdiUkFTNEZaV2dyUlNH?=
 =?utf-8?B?bmJIRTE0NHZHbDBlaDZLK2FNUEpta0MzQnRaaW1xSkI2VmtTZHN0MjJrS1Z4?=
 =?utf-8?B?UWZ3alQwV2ZPNVg3SWRsTDNseW43b08yelc4clRtRWhHQUZMWk9GekFseGtE?=
 =?utf-8?B?bDVNcXY4MG1uZGw0MnNHRHNUeit4S2NQQlRPWnBFZDFCOHNmMi9kSE8rS09H?=
 =?utf-8?B?ZE4yZUsxVDZsSG44Q3NpR2ZULy9rbWtuUGxWS2tpUVlHSHBuL3ZnVXRXNHJl?=
 =?utf-8?B?Tk1DbHZHUXhNb00zMTRmZ2J5YzZUTHR0QytiSGlEeFhBSS9MMlhTNU1NSlJQ?=
 =?utf-8?B?NEV4T0FuUVp2Sjcrbm1vV09sVTNqRnM4NmZiT01ySVNkMlV4M1ZVUlRnZ3hq?=
 =?utf-8?B?ZFlJR0xQL0pxeDF1bGYzR3JpVk15UVpESUVLYnJlY3RGRExhWHlXMWJZbW5B?=
 =?utf-8?B?enJTZ3NrQWpvUXJsNXNjWWl1YU9IRGprRGR4bWs0N2RLOE1YeWFzY2VyUEVI?=
 =?utf-8?B?MkFGSWMxT21vRlFYOXMyRzZxMWRlRzR6d01yRzJ0cExwWlo2aVYyQWhXQVQx?=
 =?utf-8?B?QWYxT1k5S2ZJYUhtVk81eTZjS25yTktmL2d1MW1PTGpmeE9LeTg5ZkpSN3ZR?=
 =?utf-8?B?RDVGTmhkS2Q3MnR6anlKR1BlM3hiR0RvUFJ1UXFLOFRKaGlOdnVxU0JKKzdV?=
 =?utf-8?B?bkcrb0QwWWhLdVJhYkdidVVlOEhqcDAvVlIwcW96WFpqSzMyK0dLZmMwMitv?=
 =?utf-8?B?RWZiUXJyM1NmOUtrR2thYnBhcGxOMk9kWVlxUmRMcDZmUjdBYUFKYU9iU2wy?=
 =?utf-8?B?b0pMUnFDUTBXS0NtRlhlZmZvejZhU0RwKzBqay8rb0VzZTdXT2h6aFIvdkJV?=
 =?utf-8?B?L005ekhwb2ptNFFWOWNreWVmMklGc1lQV1ZGcWNKanl6Q2tMVWZaejN4NG9C?=
 =?utf-8?B?b0tmdE0wNzhaSnI1eVlXMkx5aElWZkNlbkFKcnpReVpoa2RuOHZRc0M3NkR5?=
 =?utf-8?B?d2FiMXUxODRHd3NvQ2phZ3p4TFpHbklwK2RocEV5R1VvWVZ4dFBSS2lSQTU1?=
 =?utf-8?B?K29sNm1nTGJlY2tybm9yRG9wNlJOQmY5c3BNdm9ObFBKVDNmVjRvNjZTSCtV?=
 =?utf-8?B?MnBtUzNwamU5NE1Ld3VXL1R0cVBJN252bk14ZWhob0MwTk5zeUw2UlYrNUtj?=
 =?utf-8?B?MEowdVZmcStUMno5WmNZVlZadXA0QlRSMlQ5ZFBWRkgxckp2bkJrSG93YWY3?=
 =?utf-8?B?UHgwSUZqL21lWHpNOEN2SHQ1MjNSdjVKd0ZQNmw1dDhhd3ZCa3RTM2QycnZP?=
 =?utf-8?B?WkFtRFVDNWR3dTRCbE5DNitiai9Rd0lJSlNXSUdnbHR3TDJXYjB3WWFwcC9L?=
 =?utf-8?Q?Lknsl3SZ3EY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVJMc1J1V0NIa0RGVDJId3FKenZzMVVVKzJQU2xlNXEzblNjWnUwZGhjWDBH?=
 =?utf-8?B?MjJHbDIxNFdYVlVnZWlGdzdpbTFmRkdzRENDdUNDcnZieWNLeEhzMlUxSTIz?=
 =?utf-8?B?Qi9DQ0pHbHljYmdXd0JDTUticXJLNUw1TDZTKzU3V2taY3lKeWNNV29rMHpO?=
 =?utf-8?B?emp0ZzRjSUJKeXJCaXp2VG5pZUNSUStPcDdXOWowV1VIRkhXMDF5SCsrbGZB?=
 =?utf-8?B?L1Bpblh2SmJlRjRmZ3dMS3pLU0VKcWtnQzVTSUZCSzhiQUZPQ0tnSENqUFQr?=
 =?utf-8?B?dmRUZ0I3azg3NkFnTDFYQVRiTGJXSE9zM2NJRlEwZ1g2czdYWTJ2YUpqOGZO?=
 =?utf-8?B?STdyWExkdWVTck80bzkydkR4RE9lSnk3MFBudXA0YUxQL1JDWmt1bDJsbzA3?=
 =?utf-8?B?TGlrb1gweFJSQURNNGV0cDVjZHdVZkV3VEYvMDNYMGVNZzRISURBd2Y2QitJ?=
 =?utf-8?B?SzlKUmdyRmwzUG9kVTBpMmw1OXA3cnEvbDh6cnhhcHhPcWNiWUZTMUUwa3dJ?=
 =?utf-8?B?QXJidjNqZjkrYjNpdmJjdFM1eFNJL0JDTnlFYStka1RXRWhndWo3OEJFMEJQ?=
 =?utf-8?B?NEozUk1YZWNDRnFSNzJMVEY5Sm9ZZjBac1RZZFJ0ZUxXeTlFMEt3bk5NK2Rl?=
 =?utf-8?B?T1c4YzlGMmJxcWh3QnNKS0k2YWtuTnRNRzEvZWpxb3hRRFl3L1hUL1dLNWpM?=
 =?utf-8?B?WXM5bmhadm8yclFwbGN5dWJVMHZERkI5bDVteGcveVVScGI3bVN3ZEpwMUt2?=
 =?utf-8?B?ZUVvMGV5SG1ZRldrblhDamovSmErZ2VJb1RuWkFUc3RKR0djbCsxbVQxYUVp?=
 =?utf-8?B?aGpJN3VJc1pUV0ZPZmJXdWtsb0cwRkc4VzZscCt3ODV4dmR5K3pybSt2T2FQ?=
 =?utf-8?B?bDROOVd1T2k0VlhTTENCWjJyekRkYU95YUJvL2d2TGZ2amZ1azVQYWZiVXVC?=
 =?utf-8?B?TGhTa2x6YU9IeTR3dXVzRTNGTER3b1VKd1h3bjVLaUpmUlh2dVFhejRhK0o5?=
 =?utf-8?B?TE40Nm5IOW1aKzZ5N05yQTNRZlFYMk9taS9teTlKdWdGZ0Q1VjlvSFduTkVl?=
 =?utf-8?B?WHZ3cTJ5WjBQU1hMV2kxS1p2QWhLWVY5WUZJSDNGVlpLUW9WV25lMlg2ZzBR?=
 =?utf-8?B?eWxFUmF4N1JtM1FWdXp6TlZveUY5OEgrNHpTWjVlTk1BK2FaS3pZRUR4K05O?=
 =?utf-8?B?UHozcEYvbGJwT29SREJNY1Q0SVRLYzY2Q00rNzU4QUwweUl1bktvNjlTRHky?=
 =?utf-8?B?dFNqQjM5UEIwR2hBa1NxTldHRTEva29aWitjRDIzM3p6MUg0bUpFTml0TVBT?=
 =?utf-8?B?QTBsMGZkeXN1WkVadDlvMSsrbFdJL293elVQUFhLQnhPTnJsalpEN0lFeWdR?=
 =?utf-8?B?UU1iUWNuWlM4UUxVRzNOajc5b2dNcTREMHZ0UVRnNHZWL05aRW1hSm1ZSHR0?=
 =?utf-8?B?WFZ2N0JaMEJFOXk3UVZXMEgvbVRmL2k1RnVJQ01Qc2czWk9qOG9BK3pnRXEy?=
 =?utf-8?B?clNhZktqNFczdXl1VWs1M1hNSGdBbGhORmpxanVBdWlHMFJFSU9pSUljUytp?=
 =?utf-8?B?eCtCUWRsNHRXRVhzdlhDblVpMWcySGlEbkNQT05BZnRFTHZLM0dZOVQvdGhE?=
 =?utf-8?B?UER3dUhkcUpwUlpnblBQYjZJUnEzVEdqMnVDa1l3MVJzVU4rbVljd0lVbmUw?=
 =?utf-8?B?MUx5WGdpVTM2WFBVRnZXUVZhQ25OR1BTZmdtanpYRzZBdWpuaWJua2RVak1E?=
 =?utf-8?B?T1p0Z1J5b3lVS3RUekJNeFQ5cE0xNlQxWW5UY2RjNis4bUhtS0M4NkpaRE9u?=
 =?utf-8?B?UTRRYmtEWW9CalJEV3ZLWFlPWmR2dlRtVi9iWlN2VUxlWHdGZXdIVFRxVmM1?=
 =?utf-8?B?dGFHb0sxUXlLN2VRQlNLbkJrRFl1MVZXY1hzcnUvL2FTMlZTLzBxaklqcXB1?=
 =?utf-8?B?RlN3WGxCZnFLZ0hWUzMrT09CU21HSGs2cDIzY1QxNWFCdXJ4dWlSS2JxdytZ?=
 =?utf-8?B?cnp4dDh2dlFCcEY1ZUpsb1o1Zk5wTm5GandRUSsrN2pQd0RkLzVTbVdBRFlM?=
 =?utf-8?B?RGQ3MFJMcmpuaGVDY0pMckdqZUFvQjNWNGNRQkJ6RVRSTkZ0OEp3eWVZakhp?=
 =?utf-8?Q?gzQPxoE7oZO4n2mPQA1TW7qqs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bt4FN4vNHcd6+N3sCGqxL1gEFsuJXv0naYv1r5o2ywfWV4ojuGv+fRDACDtP8pdugxNPm5zd7RISgWYyQbmdBWN0fFbxNQHrv55jZ7/G8FIRXheD/S5tkM4y0zpNoKwgUHPQ16jDSFLBpi7mgrN1Ssua7XCrH3Fh/r9lZp0d+/vUh3j08DdHjbZfroAp3q9ebsAyPLY0OMFTyBbuKH6wrTkR6+TprrKxmnWa6SlfZXb20Md44uVgbSZBWVm2hqHNNQVJzZildCDuV4kzA2AuWxVEiURUVCxPbNEFzWJo7SiilKSYE2J4VWuawr9bNeu/XU02xNWjPgKagd6sirHQhQ+IGCfkOfu3akcPk8hK1pwuS8Z/dDpvhbC1QUszpz3L9b7H+1hV8MFfwn/q3YGhse2eRN2dXHUqIT4DGeJ0MmYUb1reSBey1NBST708g0Q80I9Y49AghbqXJpFB/9T1rbmpeTdz5nSXjqTkzxoRApD9pa+UiG2His5NUjutUV4Umg6pyBBVupKiI8G9dXTjD60mgTCyjAlrYudXFr5BrIjU9qY6r5P4QNxZFrxIv/YPRsViCv5zGI85n8t81Xze0cho9cmf/maZvBCNAx7hVXw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26c22fa-b08a-4a18-fcc8-08ddfccdb920
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 07:24:26.2995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+IYnwAG2OZARDgHrnIpK7PFcYuNBYyyd4Te03I9QAdl5fqXDPvo3r+MqvmiUPpRtMWEI/jgr8ZQMTOKZYgWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_02,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2509260068
X-Authority-Analysis: v=2.4 cv=NOzYOk6g c=1 sm=1 tr=0 ts=68d63fb2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=N54-gffFAAAA:8 a=cR2n4RjaQSPjzvc_zRAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: JTazKA5sux8Zj3fHZyh5Il2U7tx5F_wG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDA2NiBTYWx0ZWRfX5b6vx24sSaOd
 AiJ0haexJ1BzHciPMInzDVd2XSkA7aQLliYF3KAjooYGEgjoIzDfsVwc5vdl+EnJ0tzPoTQSlFc
 yFm0UWezozzApi6bqlTfeWqjhVx5WPUyKAhhbJl0SSV4d6Uq7cQDPrexuWxoRNpgy7DrayNXNAc
 sINpIkDTOGP8n/exm6E/U3ppmGWB4Ie3nCW3yl4UGxYPzxQ1d4aY27VVDiQuB2ci62GZU4U4cYa
 JVMxArEXSgm0A0bbZHnr7CJ9IC6yQh2BjcDj1x+te0EFrLy/wAeWOSG6PqY5MPjG9VahDGF0cnl
 hLthOtNbIRSaBcet6PQzhmH+1LNkajiz7eJM3HrYkFYB3yYWSRpCbCLfiFRC4Fl2kahnRlnC0te
 6tYoEkQAWfcIh51VEvpQPqcox0TbpA==
X-Proofpoint-ORIG-GUID: JTazKA5sux8Zj3fHZyh5Il2U7tx5F_wG

On 24/09/2025 21:30, Bart Van Assche wrote:
> From: John Garry <john.garry@huawei.com>
> 
> Reserved commands will be used by SCSI LLDs for submitting internal
> commands. Since the SCSI host, target and device limits do not apply to
> the reserved command use cases, bypass the SCSI host limit checks for
> reserved commands. Introduce the .queue_reserved_command() callback for
> reserved commands. Additionally, do not activate the SCSI error handler
> if a reserved command fails such that reserved commands can be submitted
> from inside the SCSI error handler.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> [ bvanassche: modified patch title and patch description. Renamed
>    .reserved_queuecommand() into .queue_reserved_command(). Changed
>    the second argument of __blk_mq_end_request() from 0 into error
>    code in the completion path if cmd->result != 0. Rewrote the
>    scsi_queue_rq() changes. See also
>    https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/__;!!ACWV5N9M2RV99hQ!Ku4G8LUl3kt-hX9_3TXoSAPJKn9Wz4_3Bnnz_ahYQYT0tAKkJTwnWZv4av5MhFclGpk6b3N7n06tpzYzyj5X0A$  ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c     |  8 +++++-
>   drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
>   include/scsi/scsi_host.h |  6 +++++
>   3 files changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 986586bf67dc..3a62c51379ef 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -231,6 +231,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   		goto fail;
>   	}
>   
> +	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {

But having sht->queue_reserved_command and !shost->nr_reserved_cmds does 
not make sense. However, I suppose that we should not change the sht 
when we have a scenario with shost->nr_reserved_cmds == 0, so I suppose 
that it is ok.

> +		shost_printk(KERN_ERR, shost,
> +			     "nr_reserved_cmds set but no method to queue\n");
> +		goto fail;
> +	}
> +
>   	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>   	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>   				   shost->can_queue);
> @@ -307,7 +313,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto out_del_dev;
>   
> -	if (sht->nr_reserved_cmds) {
> +	if (sht->nr_reserved_cmds || sht->queue_reserved_command) {

But this really should not change, as we cannot have 
sht->nr_reserved_cmds && !sht->queue_reserved_command (from above)

>   		shost->pseudo_sdev = scsi_get_pseudo_dev(shost);
>   		if (!shost->pseudo_sdev) {
>   			error = -ENOMEM;

generally the rest looks ok
