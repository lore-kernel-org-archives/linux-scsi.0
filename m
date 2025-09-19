Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A442D3EEB
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267952; cv=fail; b=GZHpYYOJ178p0F30peGDyAcrwjusbX6CNLE31O7vgUE5eU4bGRH2pxAYVq7urrS8UscYDN6r+9s+QRa/qcA3yvr3lxYzC8YRBmpNW24iIRlbJaKiidL20sIMt0ylcKJvWibVrqSBK72OW0Xs/Cm4TblmrNaYpL1wj7wPjGh33lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267952; c=relaxed/simple;
	bh=FRJH7BqMXjrZL7orjKmABvIU+NVsps431qPjzW7A0J4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KNfJymX5CscBkcTFwqoR/csemkdirSO4KIunklieIc5eSSIoIllnf7XPui3nYY3dkA7MYcKodvBkUFBmas7Dn2rBxT8dWfHVgN1O2/xs0Ba2qVtarFovFd6z+CWGKFExkrLbopLl1smQTO9aKYuRhLwL6PvdUpVL9I9rbog6Yzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jpLjMpTL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RWvmxgW6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jpLjMpTL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RWvmxgW6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58J7g7k5007825;
	Fri, 19 Sep 2025 07:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f0io2FDULrCPA1DqUyOwv0ckk36BeH5hr4B6Pmr1Qn8=; b=
	jpLjMpTLyfW8yoYKu6ronVx5o3BhGf/JuglLFhOSWE9H6sOPFXEzDQlyi/iUO5wr
	wUcXYw2FobA8y6qX4fYB5fwsZvpWpJ+IsSI0Simpvj1YijsGMDlCM4t7LVBFwmLd
	WL85a+dB68ZfMAp6ifROxRKtJ+vYIqXeVhopDR9vtAYZe/EDIJ7EzvfLA7grlqcp
	CzifXf4SnHkbkgMWsCBe9LQ/8Fcg1Cfk8wa5sf2/eogOBY+NlaMe5J3uQX/QI7SV
	q8AU9WX44nyKbQ0/h2VM4le9VgbrsYEXOnFRrC1UK4mmWBOHfn+Bl86ltPd2L2vu
	t/3Ui6Tsu+kTFBz7pkWXNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9509x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 07:45:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58J773xk033687;
	Fri, 19 Sep 2025 07:45:41 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010035.outbound.protection.outlook.com [52.101.46.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2g4esu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 07:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEDXwQ86SPjg1QCL6OTb0Ic2f7eAlUVZ/uJlxhGYtbboZjpMiRhClU0BliYuNJZGIvpjRnZoUkCilcm05XzKxRTIhYPUPZ4Lnm//9BSfVPes1ZCRiuQ5aE1dp4HKA84pOYG2VXW0z1wwyb15X27Po31NUmOhYcq5fyqrDgK3B0uCSNI2nBoRNPGWZInbAzYtGkOCl8UjZxGatjmJOs8Lxw8Oxm6CwxPnv8GViliprlCkpM2b5GvrfpTfEllX/Gs6a7NmDhBQjjU/4XSYszHzKZkdIRWVAsNWLFwWatxPnDu6XpFWhu+5CpnCiRR0+BjERmE6mfWgRUuCIT+TGSuDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0io2FDULrCPA1DqUyOwv0ckk36BeH5hr4B6Pmr1Qn8=;
 b=WGyOBE9G6JAl3VMlK//8A6Z/uLeXWgR/5xSv8HdP+GgNCIpFK4RxP1oS9vKCXPK2X9k1WqYV82QeKTljliIuJQkah+RQ5/rTk1rEj8mJAs9YQ7pDoM+20pZalVU1c/valsW63C20yz3bkh6wYfV2L2W0Io3+vQqyHKdB5p4cL842lxS7t6JRKSzTMjvBrr6GyY7a6KTJr6Dp2cjghs5jtTScvXUPTWZIDzDIgQRM/7h1l4VordWIUb7wIkAsWZtjoMTNxrPNRUKJShURejjAi73mULWf7vwD+og7UmidYRjQ02Er7y9Pr0DrV6SoECGlSj4nVM/pQJlVyOEfVXGtlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0io2FDULrCPA1DqUyOwv0ckk36BeH5hr4B6Pmr1Qn8=;
 b=RWvmxgW6/lja63yq/IHp7eb7wtmTwfpD3Tf5lIzSqRRoFdNiskW2INZr40onMIp6QpUv5yuF1Er+w/pgCG+NV+C9BqylHIw/rbr6TZAc7U66tutwIj0gog8L1py+CIOX/uwaf7rz4605YpgEz42IZycyv0Pw6RYo8F3zkDtlmW8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4406.namprd10.prod.outlook.com (2603:10b6:510:34::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 07:45:38 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 07:45:38 +0000
Message-ID: <69461986-c742-4650-8fd7-77306eb393b0@oracle.com>
Date: Fri, 19 Sep 2025 08:45:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
 <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
 <d175ed35-874f-40f7-bd34-15dc13d58b5b@acm.org>
 <e7ebba4d-d09b-4823-8830-6aeb6286bcb5@acm.org>
 <331639f8-e162-47fd-aa7c-070bf36d1dc0@oracle.com>
 <7a884834-7fb3-4666-9252-a4f76b7a673a@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7a884834-7fb3-4666-9252-a4f76b7a673a@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4406:EE_
X-MS-Office365-Filtering-Correlation-Id: 29eaae7f-1b04-47cf-804c-08ddf7508681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUFjRjdRVHdqZGZqSmMwaUZiMkFhRFpyYnR1SGRTaVAvT0pGaWRXSk54cmFk?=
 =?utf-8?B?NFVUT3dsaDU0VGZMdktuVEt2Y2Y0R1hOTnp0aTA3aXV6clJud2h0VVkrOWhF?=
 =?utf-8?B?SDZmM0NGbXdLaTYrSWFuNkJ5OEpNN1g1MjlIZWdrNXU5VHZVUlh3M09Gc1Yv?=
 =?utf-8?B?a3RUSGNMZmZ5SWhLOW1NZ2daK3dhYWxnN29pSGxKb0RQQm5lQ0RIbjBiWkxJ?=
 =?utf-8?B?UDZmaTBHaGVCUk1KeFN1aWliKzRLWElJbXk3dHE2b0twa2JHRk11bEVPV1JH?=
 =?utf-8?B?bjJxajh2UXRtK1c0ODBLOTQxQUMzZzltOEw5QTBaYUcyZEpnekp4eVFWQjB0?=
 =?utf-8?B?Yy9yRU10dTYwcm9Jb2RuYlM3dFV5cVExdjluRnpwdGxPUDRuNHJ6ZDl1bTRY?=
 =?utf-8?B?SktCSFdnQ2J4Rk1lMnA0U0pHMi9YMDdERkU5VjJUb1JSSUh1cmh2Y0ZvS2tO?=
 =?utf-8?B?NTFmSTdzZE9qWFNPdTNQQmJyWTNPZXNKQTMwSnUzZEM5WStobjdMNTBYdHcx?=
 =?utf-8?B?elhhWU9hQnJlcjFhcFZtbTBFdXVvcWoxMmo1OTNrSEM0Y0gyN2ovcGEvZzJK?=
 =?utf-8?B?c282WlNnd3lJeitDbjN6NVFTbjRFK2lUbEtkVGpkemhmRzlNdnNEd2hFWEdV?=
 =?utf-8?B?RlpHbW9aMCtDZ1Z2UXlGQzMrc3BnVTNPemw2VWhYUEEvL2hrRWJtZWluQXVU?=
 =?utf-8?B?Wk1GYlpCNlprSjdweS9CN2l3cVFjOUdZR3FpOVBtTlMyR2hQSUtPell1OUY5?=
 =?utf-8?B?V1hWNVNaUTg3SXY4YlcwTi82d3NwYUNvZkUzZ0dqN2g1bTNYQ1hhVTBOU0pk?=
 =?utf-8?B?NVBFTXZnYlZHb0ZpSXp2L0Z0L2tRNjMvamM3UVpzNURueWdqSUE5bDZXYTVI?=
 =?utf-8?B?V01DZVhhRUp2UVZIdVFiUlltMmlndGpVZ3h2QzhaN0dUWTVhdG1QSzlhamRF?=
 =?utf-8?B?d25TVTc2UVlFWTdmelVPZVhEbExSM05RRlcvVDF1RVJPUXg0U0ZtVE1WdUNi?=
 =?utf-8?B?Z2c2bE5qc2h0UnNBeEJUZWdBS2dTWHdrOXNKa1l1bDJ1YWNQdXIvQmw2eVJ0?=
 =?utf-8?B?bHdRT2V4amhzTGt0OWZyWjBQQXNUNkVQTkw0NTMwWk5PVjJrdlhzUEl5STI4?=
 =?utf-8?B?SE5nY3kvcWdjRTN5T3Q3MU5HZG1HM0lTelphYk4vRSs2b1d5ZTd4Tjkrdi92?=
 =?utf-8?B?Z1AwUTNGMzA1dkRtMHFsK3lVaVR1dFFDWnFoSEZmRG5aK1FkM0VhU0I4VkJo?=
 =?utf-8?B?ZzY0K2pQOSs1TjY4OXpHeE9VNGtkYnhpb3FmU3YyY2N4b0pPNythaHBlbDNW?=
 =?utf-8?B?eWtHMW5mNUJKZHNqTHd6RVVzdTBaczdMUDloZ2V5R01ISWxUbHFONzJYRW1v?=
 =?utf-8?B?YmN5TGJZM1VrdjFYUjBTYWw4WE40QnpZcURqTFRLZzJZNG5hRGIrQ3NLUGVm?=
 =?utf-8?B?Y09vMjV2OE9ZdTlWcVpTblpJZWN6aUpzeW9IZ0JmUm1BVWNQUjUxcEhvckZG?=
 =?utf-8?B?SmlkT3RDQjJDbm1DcSttbEdwWk9rY1gxREhQM24xR1dTTS9keUhjbzBGK1ov?=
 =?utf-8?B?a0UvVXM1cVlGRTR3NXQxbDM3SXhRZEFic3U3TzFVeXA2MjZ6WGtBU3UyWTRO?=
 =?utf-8?B?SThhMnFsT1NVZmNyYjZoN1ExQURrNmxSUEJyUS81WmVUS2ZqWGFqYU1qbVJB?=
 =?utf-8?B?dVFmOE0yWm5KQXVrTUNlTy9nVFBTK1BuNGFMcDg1YnNvdk14bnhtRCs1SDNk?=
 =?utf-8?B?RnlCMm5PY3kxTHM2WlJGOWo0VHp6Qk9EZXhIOEJhS3N5SW1VbUM2TGNzdmI3?=
 =?utf-8?B?SS9EdSt5ckp6Y2xkMmovUHJGTURlSkpjckFVVXdYNW9SRFcvR21UUkhuNkhJ?=
 =?utf-8?B?UEFsNlFsakpuTStjYkZ5SzRaS0JqTDNoUWdibDdEVXcvZklHTS9ad2lZbGZs?=
 =?utf-8?Q?as9raY2rhZg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFBHbHBzMitOdEN2dGFGRlpYTmYrOU03QkZVdEFIaVM2T0lqekMwd1gzWWEz?=
 =?utf-8?B?QmMvTW45TWVUV1lESWFURmNoSEducFJrSStHZHNwbjdrbUtFSnJjYlE1Tk85?=
 =?utf-8?B?RHo3QWloVTdBc09ETlVzenRxV2loNERCSnk3MlpJVi8yNDZIbmZkNVJUR2xw?=
 =?utf-8?B?OXBreFRxWG02WE9ncVdJRzNCSndxVTNSZ2R2M0YxVzJJalZYTUE4bFdta1Zo?=
 =?utf-8?B?cys0eGcyWHR1VG9SWmN4eUd5aHRsRDZqczFKNHI4cTNnUkJRMWpLb2NrUml1?=
 =?utf-8?B?djBBZE9OYzMwTU1rNXNBMVlTRDRhcEhuaHVET1k4OFk3TnQ0UEF5TjZ6a2F2?=
 =?utf-8?B?NG1ZL0M3UVZwQmgrWStMZklaYmV0c0p0MUlrejJGZTlwbGVWMmZWOEpVS29J?=
 =?utf-8?B?VjhYWGkyZDRWUkFOd2x5YlBuS05kYjYzOC9ZNUVCYnB4VWFiazlZektOR1Bu?=
 =?utf-8?B?NUlLTit5WnpDNU9aaU96aTNQMENzV3JFbHdpTGU1UVBEU1JLWEtvUmdSemM5?=
 =?utf-8?B?QnVwUFVEY3FOcW9tend3OStCOVorYkRzS3Vic1BTdTVMYWNzMnpYN1AvL0cz?=
 =?utf-8?B?Y2dFSjZJcWZXQTVXZUhReURra0hkQWt1U2UrZVl6blBvblAwbVBPMjFUaDEr?=
 =?utf-8?B?OEFNd0VIT0hGbEk4VERCVlljRHo5NUZRRDlTZktHSXNYTGVBbVhLLzcxMUM1?=
 =?utf-8?B?dFNsdlRzYVBXcHpJakVFcEd5Qk5kWjJlc3Z4ekt4L2UrWnBwYWxDQVljWE1a?=
 =?utf-8?B?Nmk5RTd2ZVI4VFl2NzIyYUZXS0hRMDM0UjRWTUNYSXhJVXZ4N3I4ZUJLZFV3?=
 =?utf-8?B?eGN3WWVKTGo2ZGYwUlh0Y3grTTRFQWRhQkc3c20wOXhHRUZ2bm9lWFpxcDBX?=
 =?utf-8?B?by9jc21WVE1FTEo2WVJuZGxkODdDVWtsUTh3em5IQTZoM0tGWTNQUGkydGRh?=
 =?utf-8?B?bXVoR3hkUlpObFBiSG9DdzJueURBN2hDbkhZRHZhRldIaTl2VC9JcUMwWlpB?=
 =?utf-8?B?alQxZml6elZHNlUxbHRObThXa0d6OTJWRDRldGZqcTd0RTg1VmQrTWYwQlZL?=
 =?utf-8?B?NWp4SEE0dUkraWVhbWdKMGdmczZ5aGs5ZDhGRkVTaTJLR1NuUEtWUmRoY1Fa?=
 =?utf-8?B?a2pENDdrMEFNNXdFQ0t0bHZmbUZHNjBkNit1aGh4bit0VmlCY3M3eHhQdzFJ?=
 =?utf-8?B?RDdzK2FvSU1jQkJJeDBrZmFHVkl2Y0ZNMTVrY3RmeFBrS29RR3ZzS3hjK3A1?=
 =?utf-8?B?YmIrMlhBYVRFMnFKVnlOVXg4ZDE1Ti9OTTIzeDFybGxweGh4MThCL2dUNGlM?=
 =?utf-8?B?dzVjU3BmdFNpdVFNZUZyWjRvb2FaQzIvSkpWN1czU1JyUnlkZHVDbWd1MXVD?=
 =?utf-8?B?NVoyaFZGNVZYRGgvRHJlWUZOS2o5Z2JuRmRUTnB3OHprbnpKQm10U0N1bnJF?=
 =?utf-8?B?SDY5SlVGNUhTQ2FGcklmQTdaRnYxK0k2VjNNWTRaWEJLTUVXU0lTd05rTlRi?=
 =?utf-8?B?OUhBWFJjUmQ5RzlST2krbE5lQ1dPeW5qVkRzUjVGSHVkT3dnOWloOWFZcnd6?=
 =?utf-8?B?U0ZlSHorSzkvRG5BbVp5aFp0WGFSSEkzOHRNWWVQckRXQWpvMzEyZk9uV1hB?=
 =?utf-8?B?dGlVOFVYb0M5R1QyalVqOTRmb2k3NEtHUklHeDBNYUNvTzJJUWFTSW4yUkZm?=
 =?utf-8?B?TVNTTGtpdUZLdC9DOGo4R2hpYnFOQkk1WTMxNXl6emQ2dXRnVHpxL2ZoVi9O?=
 =?utf-8?B?aDRpTG05ZFEveDdITnlPRE5aWkw2ejBSRU02WmVXajQ1MkdrV2RqMHZXRFY5?=
 =?utf-8?B?VzBQYXhNdTZ0cWFheGZDMDdPWTFFUmdoWmJZTnJVVUM5cWxGQlpiUmE4bDlP?=
 =?utf-8?B?dzFzQkZmZFdXYVJSMmdlQWs1VEwyNmpzMy9rMEZnNTV1K0lMNXd3Q3kvWU1I?=
 =?utf-8?B?V04relhSOXNmdndxaXpXdjNLNDBVTVdTVTRPSkpZWUlaT2JrbS9Jak9wS29i?=
 =?utf-8?B?bEZ5Vm00NENmOStGUUJJREFkN2hnNnh2WW5icGRBZEMrcWZBaXh0Mzg1WlZO?=
 =?utf-8?B?UUhUa0g2MGltOXAxMzYyQnYybUl2T0NUU1VneW1Kb1ZpRFJ0ZFQ3dzF0WEts?=
 =?utf-8?Q?XHu3Jfz+qT+WHDSsIvdSDWBrT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HT58FAexhhGOETyWfnqYr1idwdCJI4bi8CxSDQgWQStMT2+cbBbV/7bRDnCtX88BPd3XCbZc8DRkYmIUYk6IF6Z2jrmawoosK03SfMJz2ZJ9Yo7XXM4RJQ01thygFpKAAchGcUDqD2sM8ZrBPlYzLlQHWDlnXjXP76d3Oo5Fm+QjuBkU0T8V1kthBL3lmTgLmbv8Xp3MtaOxsJ9Y9aMPSssPnIFVPAY8mL9ifMx1tZinHhgx31wE96udTAL9Bp/Gku79Oxo9j1pE+/6sZAUdQ5soi0myW9xBY3Aakuncv2bUpxTmq20T3IfxDbE7n8BW3p9PTI36SXjyZR3Sjy7SSjwmNgmjclSbJ9HbGuvIFc8LG7WCfMHpI7+dxa/0kMZMcS0L345bQVoWS6lA4QE3nas31NNnBsOvQuQYNOIG4MFc98t70HPTZleNSbsEBJF2bzdK3/cWzPeKRlp2M7SQHmhb0YOkTiR9H4Mx/2vdDrIQI1590kbk+xHVP5HF+I3TFj++wJ6C45P9fQ+KNb2W/Ks0tyiFl4p2Cp/4cTY4rovV7Y6vbU9uP9ZTyIHBerANvS8IWHj1vlE52pPDlVq2ZZdaJwJQrCOBVtcPpyytM3Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29eaae7f-1b04-47cf-804c-08ddf7508681
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 07:45:38.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YNo7TDobptOitslIXbT2zRkHEqIXPCtX94mO3ek+O4F2OI8+rKQc6lnCfNzzaBVs8/h7ytPCbpiJyxmuiBQjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509190069
X-Proofpoint-ORIG-GUID: HTZ4uGhUgMmGFUyh8Y_NK_v4Y7egkFtM
X-Proofpoint-GUID: HTZ4uGhUgMmGFUyh8Y_NK_v4Y7egkFtM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXx6/GaYm+JiOL
 MHTt7Er+ojDeIA8bWOJvrAQZZenzb7gUpRm8DUzDIB53C9Fqhm/Yhes5zYIBIAim3WyehjjwYef
 rJHMrWQGwxdV5eJSO0wwVjr7Tz+IaWtzF59+k9V4H70LMW3dGJsvRBjjE/kpyWnSbzwKM7vUKJO
 uD8+cfpXA1EW+AfP3RMadhcJojzMRwtE1TeRxYkVWbPO3hznt9zgdmQSf10oYSSFHmCZUop4L7e
 MiJCcd4wjVFHRtyIa12yIC75dQvkxCJo2CpJZn5+lVRn7D9Lu51EZcjXZak01QvtcL0LOYNNINx
 jsbLGPeEaXIwcf3nbXt573Y84X0Z2vLfyGpZIxl4YOfZNftJNanrTjsMX+2WZeQKJvDYAKzmJYO
 q/XrpVM3
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cd0a26 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Vxl4B97-S6ElVZNicHMA:9
 a=QEXdDO2ut3YA:10

On 18/09/2025 20:49, Bart Van Assche wrote:
>>
>> I would not suggest to put any pointers in the data buffer - just copy 
>> in or out the data which you require, like the example which I had for 
>> scsi_debug.
> 
> Hi John,
> 
> In patch 29/29 of this series several pointers are present in the data
> structures in which struct scsi_exec_args is embedded.
> 
> It seems like the scsi_execute_cmd() changes in this patch series are
> controversial. How about dropping these changes from this patch series
> and restoring the approach of v3 of this patch series? That means
> calling blk_execute_rq() instead of scsi_execute_cmd().

I thought that we could make this work for scsi_execute_cmd(), but I 
have no real problem with reverting to having another function which 
calls blk_execute_rq() just for reserved commands.
