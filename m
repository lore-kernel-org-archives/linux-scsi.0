Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23C21254F
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 09:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078441; cv=fail; b=hZv3iaisL88T1cOGiJI7cPKaSKyJD5X9XfcGl309+IXXjYf1qzmwGTvBXex532DNhNln64XfkOWnS2XoA/lyF47YBvW+VhUGeW0SrYTKorPnmOiA8AdjCx/AM0wQnG9Rb3i+aL5TvYKAIO2Tf9ZiOtOLO8xT+SXNjVVBuxMN/8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078441; c=relaxed/simple;
	bh=+cBotkITb2ksGJENZwhX/PjXKnqV72oTSiyUhU8b9N4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WjTg1Gs7LKipIUqrBmsLr3x1zo2JSKL+H+ueoTAkfXAtKZFWSHCt6eB5f1G4i4rsLYvMd2rVX7zoPwNoxg8hElupseRRYf6zCvgU4u87fwsc9BPy+Cq4jqcOb0+Mt9FfXyoI3P1C2V9AyNp3KzXRYv5TNXM6Q4ijQ9DVOQsl4zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FoC8Ft7X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oi8HgYYs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FoC8Ft7X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oi8HgYYs"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6u4mX017618;
	Wed, 13 Aug 2025 09:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XvoDRDyhWadaKMDFp53DyORv/3me3fXfvOdruLhOceQ=; b=
	FoC8Ft7Xq5oQGV5M6u6/nuiY6KPuOlWyUw0A6yjYs6i97mUskWIu/3jLmC51nET5
	QfYx+qOFv43L7H9mWv0uR0msfLQoVUd0CDaumOqNJ+9i9zWtXOLNlCR+0GCGfftc
	e0r22YDbpwSxMUvqk1jV0DVHoa4JwT31R5inK+INobCKCLHIf4jkJvUnEq2N6/qV
	uiriMhXKkYr+muSVvgmv7MhnmS2Jq47iTXKgTurm1gePv0LiXt08fw+AirPf+R63
	n5bM4Jmbb3vkwlJ/pczRqDxlIoj/gUBx7znDqECXpIXqo6iqXb+Pp2q8YDlh4+B3
	v68jcYiZ8UCcp1ThGtMcWg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv6y1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 09:47:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D9O5h9030436;
	Wed, 13 Aug 2025 09:47:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsb628r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 09:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ugj7IKq//3HyQ98WqJCB674xGMcAaAYbXv9ET0NHzhLBxvrb+JYluqd2gdGv6J5oneEvsN5eulFRByGkwKDxh5JBNEyjzOZX+teqXQVi/Z+ooAlLd3ephS6+rGhZsjY+pn1i8iMoM8SIBHrYV1pTyI5PICDaoRX5mYHmG6P/fJU4JaYy7/CW3cFCzVf4c6GYzRQzTccliBbmWsgH1vdkAmVsDAAETQNzV489QQpJ95OkVD6Sh0yob94l80aGBKbK8Uta+vutymjTMeshBOGvVbFRTJvbQZ6KfmClDe5BbnBge3CdPr+f50uDgZOI5skGK+RBW+RRhyZOJafRNPIAZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvoDRDyhWadaKMDFp53DyORv/3me3fXfvOdruLhOceQ=;
 b=KQoc8hTsp4BIQWZu7RSxh+7qJYlvlYUnRsvHRgtoxH3cQYG5IfcvesAD2f6nDtSLjrCapDbuH5Jn6/O4NCKINNjEyNdfFrl9AC3DUW6Ps+VdbJyB1FUhw9m7PvMvh1xrpXZO7uCrJJ/cg1tQFlqAteM4t+iWtLajLST87QVQM+KZAt99L9ii5OJtGR9ZP3DQqgmKSy4Ty9eYlj/m1cWuu9/pKysx5M0dC+MxDbuf77LK2hsjv8posB0+m5rOfkJ7NzZLqrV2qZpKJPWtJQt16fHkwdTTh5zwpTdqeug3fQGB04vk/Xmyc4lEWcXBnQYkUUAR4XPjfuCyyZbOLzduBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvoDRDyhWadaKMDFp53DyORv/3me3fXfvOdruLhOceQ=;
 b=oi8HgYYsM5aHSk4U3atyI41kX5c5xvWQnM1tMPE4ATJAQ1YlN14WfvA6vstmANFmA5JoIKMHZorJlDpZCXtUw/pCu/VnXPWDdP/QmEo80a5TUtYVuri+jv79Xju5sHZJIRka1NnDoPutKezUUE9ZPbmv/VEk7u9xYxNCQ2JB5CU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB4861.namprd10.prod.outlook.com (2603:10b6:5:3a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Wed, 13 Aug
 2025 09:47:07 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 09:47:07 +0000
Message-ID: <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
Date: Wed, 13 Aug 2025 10:47:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250811173634.514041-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0037.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB4861:EE_
X-MS-Office365-Filtering-Correlation-Id: a917774b-f85c-4e98-96d5-08ddda4e5da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekNKU0tQTlk0SFpuUDc3Wmk3cDkxbURkOHlDYXFmb3pUaXg0NmI5Y1J0S2F5?=
 =?utf-8?B?QndDeGZORERtaTJHbGNNdEMrYTZ0U1BLRjRiZHpKT0lQOElkZ1dRWll1VW8v?=
 =?utf-8?B?WjNRL3RKcjZhMk9vYjNjRFZhZmRaVi9ScGhYYldkQ2U1R0hhREdjeWd4Y0J2?=
 =?utf-8?B?eEl1bTdvYXpBbW1LbUFiWjlZM243SW1Nd2xybUdRTjU2dXdnVUIzVytPU0ho?=
 =?utf-8?B?MmgrdmQvaDJydFR1dHc5c2c4YlYxb1NYbGtOeER5R0dVdFhkZmY0Y01zVU9R?=
 =?utf-8?B?ZDMyeGRheGlxcUthMEpiSXljNlFXYW53UlVSNGc3bzZOWWFMYmpOczZLWTJD?=
 =?utf-8?B?SUY0M1ViU2V2Z0ZkT0FiMkhUWGVFOGNSNjc5T2tzcjFRWjlOaEhYS3lmOHlo?=
 =?utf-8?B?VkFOZlRBRi9SREFsajlNRTJuTTBTUUdZSDRPM1NZQThBT1hTS3J0bGhxeGRJ?=
 =?utf-8?B?ZTBrTkVYSnpsUlBtRDNQbGIzREpwSnRlUDk4YmltUHI5MGxCYUcyVklEemJl?=
 =?utf-8?B?K1g5WHNMTUN3TzB4UW9kYjJUbkI2S1RxZkpSU3IvTVNncFM2a2NvUXVKWGJH?=
 =?utf-8?B?RmlPWVVoOWVpejBaUUFhakFpT3A5YXdYdXBzS2p6ZmN5d2NER29zVVJKcUwr?=
 =?utf-8?B?RlFCQ294SmU5aXFSK3dMYUVweU82MXYzLzJaazQreHhGUkJLdDlBWDlhM3Yr?=
 =?utf-8?B?Q3gzRTFPU282Ti8wK0xNWFVONnhwODBHZVJIbGQxb2FOSXhYcDNZZUY4dVdS?=
 =?utf-8?B?VDVNM0JKVXliRmM0dk9DN0xVYVdQYzdEOUpBdlM3MlJ0c1RCWm1YK1IvM0Iz?=
 =?utf-8?B?REtwaWNoK2dQNFVHei91aUNMamhKRlEvTnFrMGxRNk9iWThrTEMveDRNTWs0?=
 =?utf-8?B?RXR5Q3RnV3pQa0RESmt6dkxURHptR3oxd1VaZ0lrcmdNeVI5UzY2OFVkS2N5?=
 =?utf-8?B?Z2k2Nzk2QUd3bUZDSGxMcnZtdlV4U2RtYUZPSGJ1TkUzNUJLb0Rnek1icUhR?=
 =?utf-8?B?cTlyeUpRQkwzSFU5V2Y0MWhOWFVtMlRlNTlic21PbjNsem1Zc0kyZnN6SG5q?=
 =?utf-8?B?MGZLbmV0NDA5TzVjeUJINjhJSTBmU2laVlhiQ2ozbzFMOGN0a1RUMFRldHJv?=
 =?utf-8?B?eU5McGVJNms0VDFnT2xTTGlaeHhZTGN6NFRPT01abDRFWnFXV0dZOFpidUEv?=
 =?utf-8?B?dGJFMUs2Rm02dFdyWUlKQmk4ZjVERjFhUkpueW9ZVlEyYng0YkNvbTZDOHB2?=
 =?utf-8?B?UXVMUTJFZ05RS1JyMmZhSXB6YnJKTWFDMjhSaXFqcmJvTXRtM0RrUFE1TlEz?=
 =?utf-8?B?a0dZRENLRUFRcDAwdkNXOHIra2x0c2VwT1NoYmtuRVZUTEIzZEprVi9xNEs2?=
 =?utf-8?B?RkVpY1dqQmRKSkNPZ1BLUysyRFRWSXZWckxCSW1LU0QyTFJJeWluekNtTDNa?=
 =?utf-8?B?a25DZyt5VFdhaFNFYVcwSmZPd2xtRXNqV3RrNUQrV1pBSUJRcTJXRlo5QVJD?=
 =?utf-8?B?Vk43LzFrSG9ibmU3R2ZZekk0ckpOMXhpb0tIZkx1eXZweURUdDhQQXNJMzdl?=
 =?utf-8?B?SE9rQ1lPdjZ6WlBYZ2tzcGdBWFR5SWwrMllZYTl0K2lmaFdjS0xMUjdnTUpH?=
 =?utf-8?B?dUlzbGRrckdDYVJLbm03Ymp4UjlKQ2g3SFc1NFVZeHZsM0FZOVRzaGR1NWk5?=
 =?utf-8?B?YTFRbXNIWkVIZlRGSmRralZGZUdvZGZSZ2FKY0ZxQ0ZxRGhZMndGUGtLdDV3?=
 =?utf-8?B?WHBXZkNsMnBacU5QVUxkWHJOVWJBMCtLMzdNZ0lNdjUyaUV5N2JLc1ZLZm4z?=
 =?utf-8?B?ajlUSXExQ2pycnZERUJlVDFvMUlsWThpN0NkVWthY2dCd0l3WmdpL0EzQ0xE?=
 =?utf-8?B?NGpBNS9NV0JkbDd6NnZ4QkRKdnFkZ3RiaEhzaS9aNVFEU0FuY3JHQUJJNE9F?=
 =?utf-8?Q?XRDBE57mzXU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REkrWjhscTZSTkZMempoS1M0UDVuL0ozeFozaWR4dVl0Y2Jtdk9CN3RXckl5?=
 =?utf-8?B?bXR0dTd2YWd2OU8xRGdqZGZMQUM2R3NjTDJMVmFiR1RpeStFWlp3N21ML3pI?=
 =?utf-8?B?QS9JMzBRSDV5a1NqUFhZUTlyQ0NtL2pETjU1eEwyWXVoblo2b0JSZk5FemtO?=
 =?utf-8?B?RUxSaFVGb3BIaGNFNHBsTmUzdlVROEU3Um9aZnZTdS9OZnNlZ0szbjFMOXJR?=
 =?utf-8?B?R3BHTlYzalBnSlAxR0xxZStLRU5neU42T0FuamZpWGZscFdQNEZHUFVkbzhv?=
 =?utf-8?B?NUZOQUJ6aGFST2V3b2srcFRINVhGNEcvajFINWhDM3hsOTNDTEVpeE5xcTBq?=
 =?utf-8?B?bm1mZFlHVG9FeEE3dWRoTStjUVVpdWVQZ0pVeXJnR0JQYU91REVTL3hxRXBo?=
 =?utf-8?B?NWFWemovcXFqMDVDSWFpUVR4UWdmVThIQjdQVE9RR0xkajc5RXA5VEVxclh0?=
 =?utf-8?B?cG9vTnlvMFQ2Z2JyNUF3b0RWWnRTQnlSODZlOGdtMndDcklwRHZBR0o5dTJV?=
 =?utf-8?B?ZFVER0lBZWVJYWhJK21YUUQ1bnZ4WDJhbFc4T1NoNmJmMDhMQ0ZoVDdrZURp?=
 =?utf-8?B?TFp4VlppZTcxMjJleVBHdzFQQnEybU9JYUtDWlpsQTdIMjVYa05oUElWL24v?=
 =?utf-8?B?dnNHSjk4MHhudnp2b1RtWHRjOEFoRlhNcDJsQThLRjhhOTRvSE93Mk1FNmlM?=
 =?utf-8?B?ZEM1R2s0Lzc3MDhVSXBFcUxJSDAyNjZ6ek1FZWZZMmNRNDFBZWRpYzdnVGdK?=
 =?utf-8?B?ZGd1WThiQ0k4TTkyMzlrZHcwQUlSMmZTWTM2NnhWMmR5ZXU4aU9CbnVVSEN2?=
 =?utf-8?B?dVRoYlFsbG5mNVVJdXRvUkc1S1hicUtEYkowb3NWYk1GZHNDWm9rUHFqUmtw?=
 =?utf-8?B?bUVTY1NHVXcwTzM1KytjemZnSXBibWl6SC9lNEIvdlhKTUplNFRIWE50bkZY?=
 =?utf-8?B?M05ZaHhpaUtRNnIwUFo4aGJycXZ4U241VVZqYVY3bzhZTVUwc2xPcDJIQ01Q?=
 =?utf-8?B?TVRzVURTejJwTUs0TlYwNHk1Y0x5SjF1T1NNNzFQVnBmNytpZ3ZacnVkWElI?=
 =?utf-8?B?T3UvQWpkQ2hVS25VVk1EMUhiQUNxWnpyM0x5QndzN0l2QXZZS0h3ZThkdGZq?=
 =?utf-8?B?eTNLNU9TTzUzT014RkdUWkpzc1J3NzhKYWFKcEM0cTZNSWJhenR4cmVXdGo0?=
 =?utf-8?B?MlducVRDbzB6RG8rNVhxM0RUcEhXYyt5RCtvMFpoM1NwL1BTM1NiTDVkUjVs?=
 =?utf-8?B?K0QrWFRxTzM3bDZYZTIreU91MTZHeGtuNENPQW9SVkFoUGNuMHFqdHF4UWJq?=
 =?utf-8?B?RGNSbjYyWVMwazVxdVdvbDNDT2hZNkM1V3JIVU9MaEM0Vi9aN2hRcmtLM2Ra?=
 =?utf-8?B?OC9VQzhTTFdPNG1aS2JITWVkODNRNUFjMEFSbEVFZ1V0V0F0dkFwa1VBNU4z?=
 =?utf-8?B?UUhTb2NoaE5pSzdRb2p5emRhWTcvRjZPMG95Mkp0TVUyckxwNVMzc2xLZDlp?=
 =?utf-8?B?MkFaUWxzakdhQW9BQ1VkN1JoTkZ3RTRUYVdyb1pIZ1ZZa1dHckZncDRJakVU?=
 =?utf-8?B?KzlIR1dieGUzSXUwak1PaGNzTlR5dEUveU1oUndKMnpmU0ZLNVdSNWR2S0Q2?=
 =?utf-8?B?bEE2N3VJQ2ZGeVBYRlJkbG5kT2hoTDVEYzA1MmVKblhWd3cyNnBScDFtMEFJ?=
 =?utf-8?B?RU5TWUlwYU9tTUIxZ3E2d1UxQkhjcC9RVlZheHJOR3pnNVpadzZhdXNXano0?=
 =?utf-8?B?dEZFZjhaU3VEUWJpY09GT0hHaUNTQ1dkN2FzT0hJR0VNSmtqREE4ZHdPYyto?=
 =?utf-8?B?U1VBWDJGTzg5VzJVOEdia2d2NmFLTmY3UktJWjBZOWt5TmtEZit2dDg5RXpY?=
 =?utf-8?B?MEJmLzZpYmJZckovQVhlMDVHQlBjUzVpbDZMWmRKZzJ0RTVkOGJUdnVTUlpM?=
 =?utf-8?B?L0dCMXc4WGpjL0MxNjFiVkZ2bkFsSmpSTmIxYkJTWmRXeitGeTJ3bldKNjZO?=
 =?utf-8?B?UVRVbEpKcmlLN21ZNlV3UkNkMWdjVUJRVUNIa2lFeXVzN3hudHZITDFyT1Jy?=
 =?utf-8?B?L05jUTl2L1Zvejk2eGEvc3g5Q3g0TzBhT2puVS9Pa0FFYVRObVdZdDJ4aW13?=
 =?utf-8?B?QXFKWUd3RTJVSXZVV3F3Vjg4UGg4YWRVbm11aXRoS2plbHl2Sm9mc21yRXBj?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2CNQP6hjgZYsLXBCkvfqIU6GxcV5+rSfCBtf+J1o9jw0aH5pNh46zIMs0wrKDx3qOg2J+HTZ0SmCT/KIrnz3+u+ulbWliZHRyzvxeQOkLPO5QOJxoFZDmYVpeOSaCF6G0IGCtJO/pSG0VM8CjNT9tc9LxiSN8M/TXVGcU9KgummC7jIBhUMMERKvA/dQ341lA4jBmLjZwX8fL3szPHklnqZD+5o8kEglG9ccsINPziwr87BOhrYq6Drr6gxNXjtL55+PTbTjRlT1N5e0KqWX8suNl0l9UX/AiCoodYcmxU8XjX2cmBs9Y+Q1dwPUKVJ6TgmXgGYq4J9oTQQkgk0StbvIO1aygCk94ZdpNSWjGW5/MXiKg8pibs0IA0Oqf+wx8iumDR3oaal1R/zLVTIBo/tiqyqQuz0COxb7x0UuPVi7XNOm1vPnyHtp8hCHFyuW1l5KNVn97Z8k5xpsNonG/Ct7xBHP8TUaaf1kcAbRPGNS8nBqjrK9cAvUdymrSr84eH+bq2DvRzdrWnrBVqfBeVBssqxAKM0K3TL59ub2KvJQ9h95Wf2OXZ049pdvdskLXm6TYRoYgFWNTodnTSPnUC/LlFNiUPle1lYlFcsyJiY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a917774b-f85c-4e98-96d5-08ddda4e5da3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:47:07.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcyoWI4/S1EpTHsKYnLDXA3kmJDq0IAOdTCy4opuzdtTN+rDlXGAJz45xXKfBeELpysGQJhP8dwXOndjmSkVIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4861
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130094
X-Proofpoint-GUID: couVqgWq4X0pHxG2uxehBZCjovg-eYDh
X-Proofpoint-ORIG-GUID: couVqgWq4X0pHxG2uxehBZCjovg-eYDh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDA5NSBTYWx0ZWRfX+6jcpOMnwuvU
 RV4rlj8XO7sRxKBysZVx9yKRZhs1oTI9ivIJZ4vHrFp7iw0P8fvl+yndVafC6jlgShdP56G96G+
 gaEDIkSuX8hImZgDpBYMmpZfLrfSNLm43IX/WNxV6GMwI3j0jA5ZakktRzb5yvFbqnba5p/XsvD
 tE5/SJVI924d2wxcgPnrXGLVa99bmXvZpUd3IgnmelkUiCMhLQjZKCNCPb1Q4zcFBtCqzclcJ3e
 Sgb1lsEGoEvTU3HUVQK5O97QsPD61V+SI36oS8izpbQkphB7kfjKKID/DW4I3RktnvWZYgcZw2W
 nr1XYWQuAbQ+3Rv8mlHCa/qmhRqi8UOvYFgBnDus8VecJLzIO4BF2vaExQ5V4U8qUYTuunjasSU
 Sq4dqRFMS9zk93TF2ouIwhruHFec3plZ0TWRkzSASmFFGNQrVWzg7hejB5FI5VvDiYa8omBc
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689c5f1e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8
 a=luuGp6UNv9h7nBlKDCIA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10

On 11/08/2025 18:34, Bart Van Assche wrote:
> If a SCSI driver must use reserved commands to discover the supported
> queue depth then the queue depth must be initialized to a small value and
> must be changed after the queue depth has been queried. Support such SCSI
> drivers by introducing the function scsi_host_update_can_queue().
> 

why can you not just query this before allocating the shost via a direct 
HW access?

> Cc: Hannes Reinecke<hare@suse.de>
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

