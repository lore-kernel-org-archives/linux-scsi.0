Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9388F236457
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757085208; cv=fail; b=dwGqkv4IK6Qhb09RGPzElU3TxOK6wia7aVbDHLh6NffT8Xs34Zyw21rIiDskKPPpjY1OrVCliuT/SnOc0wo88AFDdSPrz0kqoafBBYJYSM+4dbqiWHjfq+FVsj8wG3HDNco4HedyAWbwLCxqxUNK8y99AHnpguzyWvovTwfFDHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757085208; c=relaxed/simple;
	bh=vQCrxO0RPGnuiQ+UKMmDILH4ocu+OtI8NwzIwIRytSk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sDh2Lmzwf71bCFTZSIaOsYPh4oAyIhYGrEWXCpulYUwKjfgR85HrMq4EU7ixB84sXTbJ7guKldyjvy3Gw/RfBA5bWlUYW+F5XYHD1op6y5A199EnOrlESVONA1oyLSv660qwQk0UfGEVjFl4NJdCfPT2BzU9GmOfVLBJDFALvWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K143lPcO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fpo6PIdF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K143lPcO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fpo6PIdF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585EMlSA007123;
	Fri, 5 Sep 2025 15:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O7B/j0YEx7rug3YAQ3DjgRlPrF9vTK5mR2SuLEZj9ZU=; b=
	K143lPcOPLICUqET65OUozWpoQl6RYZOJhbObiOotuSlY1ZX5rrzmU7Svplcf4gE
	rQ67HSXftNe6bzJejaXlEe0vtab7uyfxs0E7EsgXcOwpGijw0wfviCOzuT+f5t2k
	eDJdUuGTgSV+4cOkrP+tnZJTYry58Ct0WWlTcvYFvmm0r5luZSqyFP2hleJYRxts
	ww+YOb7h2vqbdGJl26VnCpd1D5RWJWQ5usG0UzyYbKmrqo1EF7RRu48MMmRZY0o8
	v7MrbdEZnfx5FLc49dzQqtUdCRovVupoQACg/dP/BRXLGHEnz+t0sfGlfgH90MoX
	kaNpqoSfMGC/H6uaYw3RFw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4900gf87hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:08:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585Dj88A026260;
	Fri, 5 Sep 2025 15:08:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd4qb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:08:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cmo/361n9jAzqnGHvohJGbOKwuP5gRDEAW4Zz3IJeJQjtYWLVDQh/CvjPoJ2hclOOpNUBNMMdn6ZKy7A6zNO8HKiBgnbdTOSXjCEhzo5Ts2lJLKAvnOb5CZivhG6b92rgo+SJxMdK2+jFX4FCdn0fSihzu2QP+C9OG4URCORsHg4svtUm9xgbY6BDTcxvJ3zZFaJHFY57WBgegNd4lE3anHxvpZfLrIRMv+OcDu9TshTCn+cudIjZH9c6tumdLZ0h8Qjvq/XdbOer8e2RwmOmojBUGMJex06DuSBLAkM6J7iSqdz0/aEvBE6uVVbAZpueJvuvoX2RGzgg/3BlQ7Psw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7B/j0YEx7rug3YAQ3DjgRlPrF9vTK5mR2SuLEZj9ZU=;
 b=giwtm9JdR6XABsSSJTyDN/45V9ziGX05LU3uc+esrKeSA5tcYNhS+Fu/aTUBTc95+54vgqa1oysZghYGM9Y+B658msd+U8ctuO+pllXbDN16hCOmh10j9+QGMueHP5TjFGA/er9IwUenvANYnS+SZN+AMD1KA0Cgha7RaMqHjI3PEFCA75qnNRMTdP8re0VSH7PwYDh4i40WoMEaJRyXqX+b+G1oPf67JRL6lql2LEq7TrNSgnH+fYeEWIOslJhK0kv7Vn6uG5objcp49fIXKB3QHGogrPITr2C0snpqIjFaV/3xW/hmD1nBwdavJQ1Xw8Fk4KW+UOWqq9SZNDKwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7B/j0YEx7rug3YAQ3DjgRlPrF9vTK5mR2SuLEZj9ZU=;
 b=fpo6PIdFGNQyXr42MC5pDGe00IyHAEgT+tgVY6Dtfl5IdsvgGVkHI8IpfUd0i3vJJIj730NTPOFx0kAoCSwjm2FjjoJfWxAw3Cvf5/OnKVELwhSAWvI883+0Iyu9I25UlZ4EQsJoEhju8EewWbN2k9vzhkC7ejpqejIjWTgsHiE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 15:07:45 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:07:45 +0000
Message-ID: <f564ea24-a5f5-40fb-ba6a-ce395cee7f81@oracle.com>
Date: Fri, 5 Sep 2025 16:07:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] scsi: core: Bypass the queue limit checks for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-5-bvanassche@acm.org>
 <e555a601-2b87-4139-ace7-0e6158cc93af@oracle.com>
 <883d6a67-40f8-4a13-a433-d452d0c75571@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <883d6a67-40f8-4a13-a433-d452d0c75571@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: b264ad1c-aa3f-4844-2885-08ddec8df82a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXY1RVlybUw2R0JwNVgwcWl6MURWZ2tRZ3YyK2ovcnhwaWk0NXZNQjJ5TDdW?=
 =?utf-8?B?NWRSMGQ1aTBRd2pyYi95MUNrZDk0OFhrSWRlRzhYSFZqYW8xR29NczNXMGtE?=
 =?utf-8?B?VlhqTlBXZEhwTjdZT0NST2tlRVFOS1BER29BWEEvWFRST1drb1Y0dHNZTmJJ?=
 =?utf-8?B?YVE5RmFVL3hadkg2RXg2bi9HNEFoT29HM3p1TE50ZGJEdXRXNUdjYVgyUk1M?=
 =?utf-8?B?UnZNWExsZHZucHp5SWZSUHd6ajJBZTFoVHJhc3ROTUZtSW1lTVFZb282WTdC?=
 =?utf-8?B?TjBQZWR2UksvdVZlMDYzNTlUZHd4NTIvbWZpbWgza3p6Y0M2UzBXWmpOODZY?=
 =?utf-8?B?NzhOK01KVDBzb1RiU0thUHdiSVhXOWRnNldrdDRDM29yWEN0QXhFSDJhdEZz?=
 =?utf-8?B?V2xvL3ZuaEZFd3BsWWlPQVJjNkFFd2pCcDNWbzdWNGpQL0JPWlRZOWhKemJi?=
 =?utf-8?B?L0xCK1dqZE50U1FBOWZnbDczd1czV3RydVlUbU56Nml2NmliV2d3YlJWQ1VM?=
 =?utf-8?B?M0JtN29kZnJyd0JBUFJEendrdUZML1E1eFkySWNJaVVFaEsyQmUxNUJRNGta?=
 =?utf-8?B?d2xYL2lWZnNXZXVZWm1JWk1XWVdSdXM4aWZVa3Q4KzlYdXcvRlFhdjcwREFU?=
 =?utf-8?B?dk81bURGT3h6c2txVExYdUR1U25acFVERWlwNFdldmwxSVQrRWJlRW1NMUx5?=
 =?utf-8?B?d2M2dXcxM2tXYTJtTXZSRGJ1TW5IMWlZRkpIbmFYWnpMYnFVbnh4bDhRL2pP?=
 =?utf-8?B?ODNGMEMzL3RFK2RZT0x0bmlYSUd2T0NZTU1BdUg2UXg1dmgwemlGTktLV0I1?=
 =?utf-8?B?WkIzaHNUTm5iOWtqNXpLWS9yeEwvRWEyM3NVc2l6WFRpQ0hCQjFINzI5WmJo?=
 =?utf-8?B?Nm93cmJhK29xYWxWaTAvaG1pdHJqcytDU0hMcnhmNFh5RTlHZGFtZ3Q5eUcr?=
 =?utf-8?B?RWxCQ2RJeHhCcVVuRkhmNkFtdHdxc2dCRVUrUkViRmF1RjN6WDFlRml5aVdr?=
 =?utf-8?B?Tnd2OHRPek5YZm80Z1ZTVWdRTllORUt5b1pNZXJENUhtcWJ3ZXlyZUh3Nit4?=
 =?utf-8?B?a3RJU3EzQ3Rmb1JuTXBtQ08xUFdiamU1S0FqQnlWVFJpR1pVSU14QlUxM1hH?=
 =?utf-8?B?SFRnUko4bjFuNDI3aDkvaVhIazRLT2xqSFJvMjlpc01vbzR4WndVTUZHWUZW?=
 =?utf-8?B?bXhWMmNyZytpYzlxSHlTL01wOHNoaTBCSnhkWkp0SktuRjc3Um1nWERWTU1r?=
 =?utf-8?B?VWtjUzZHRVVnbjYrMWJLcjlkSlArQTZ0bmRtZ2lpSXlpWU93dXd4NzBCUGFZ?=
 =?utf-8?B?UnZ1QzdiTVNoRDJHSUN6ckJKSXprVGpsQnh5NGJFUzlOTjRBOWU4SmlEcnV6?=
 =?utf-8?B?VWxRNnhTaC9FOVRaYXBoNlBxczRNaU1CVWwxV3I5N1pEWjFNNVBmM0pKQTNW?=
 =?utf-8?B?NkxvS0ZnRURkUG5yS0JIQmtML215ekxlNWRPOWZlWTVsS1RrYWVYNVNaK1JX?=
 =?utf-8?B?NEpFampHd1V4ZWE4UW42Mkp3SzhDdnVydm4yMFlFdGJTN2F3SElTcXBlUG1t?=
 =?utf-8?B?SVBkZG0xWmtBU2UwUS9mbVU5c0pDQkZKbkdQSkQ3dHhiQXcyZ3lOM3ZMY1A4?=
 =?utf-8?B?bDgzNnNuM1FMQnhncFVrc1lsWjJPUEJGdzRta2VZeXhJVyt1WG1TRCtNMUdR?=
 =?utf-8?B?K2pMTWM5eno3anprc0JQRXI5TmczU0xBMkladGpGVjloZEsxcmpDa1E3RXAx?=
 =?utf-8?B?Z1FkakxMZS91eWJNd0E5M3V4SVp4SEM1STBLWGdtUEJaamJzS1lwajN2Rk5h?=
 =?utf-8?B?Z05WWTdJWVo2Zk9YMXQ1czFJTmxiOUE4UkhvR3ZsS21xS0RRWkJXVjVFaE1U?=
 =?utf-8?B?a0JLS2g5dDQyMmY4bTFSQXFabC92ZVhyekJBMVVlc1lyd1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzZBeEFUckhJNVEyaU1BaVlXRzFUTFBLTjZhdC8rUCtmUnhKR0RUNUc2c2Rx?=
 =?utf-8?B?NTBUV0hyMldpa0xjNHp2bFkwMTNiOUo2bjhxdmd5OEQ0Ujk2L1FJRnZ6OWFh?=
 =?utf-8?B?VWR0ZGJiSjFaRitFazROLzNFaC8wUU9hc0ppb25leUlTV25ONklKTENBckFT?=
 =?utf-8?B?YWRHVGZVS3U0REk5QmtkVlZ3TzVIdHlucXgweG05VkhxUDh2VTczSkdDU2JH?=
 =?utf-8?B?MmUrSXJiZ0w2RXYra0ZWSVR1VXY5TnBTRTdKb3FyN0dOUXphaHhYZmVNMEpy?=
 =?utf-8?B?Tk1vRHVrd3Z6YlR2aVJBZVhBajZQd1FLbzIxdkF2NW9FZnpxUEtIZDR2V0tM?=
 =?utf-8?B?UnVPMGtGSmJzSCs0cW9ibEJwNnNuaE1Kd3l3SjROdVI5MDg2TW16SG5oUDdM?=
 =?utf-8?B?dkVCb0pzNDJac1RmNXhrbXpXNEJKbjJDdzhaV2xuMlVSYWhZUDFzWnpMcEsz?=
 =?utf-8?B?amg3ZzBZdzZ4ZFBhYjdoM2p2Yzl1clZidHlCZTBSa1EwYndibkk3SExpMkdC?=
 =?utf-8?B?akxFTUUwZHJPSTBMaDl1RzRUVmxhSXdmc0JNUjVqaUlHQ1htTC9PTnNtRGE3?=
 =?utf-8?B?THRIYnJZS0FsSDF0dFJTRHJ4V2I3STh0a0RyZE5xN1pVcURpeVhtVk15TjlI?=
 =?utf-8?B?N1QvSzE2Qng2TEpBdkUxMWVCN2crTHRocTRqZHNiMHcwK3Y3NGJxN0VOKzRT?=
 =?utf-8?B?bWU3anR4bXh2SlNzRUp3dUd5NC9OKzVqcnVhVTU5dHRsZWZwTnF3STFZUmFn?=
 =?utf-8?B?ZytQV3RFZEF0WG5nNHltY3hMMG1qRGJNNWRFeDkrWExCOWRFSGFzVFlwYjg0?=
 =?utf-8?B?Y0dFQlNrVFMwK0VnUzdYZ2Z0Zk8yTlZmcmZObjhGcytwT0JFdUovUTQvdTYz?=
 =?utf-8?B?eWIwcVdzcWlFRTV4UHRybHRSZ3RLOXh6MzFxbmxzSVNmQ252U2QyMFRhMm9S?=
 =?utf-8?B?dGwrRC9qZWxOT0Q3dGNycHpVbERlYXF4UzMwSFNMR2tHYytleFVJc25hdEhE?=
 =?utf-8?B?MTBOazNXQlR3ZU4raWc3V2ZQcGtuOE1WQ05yVStYRC9kSXVtMko5aW1KeDBB?=
 =?utf-8?B?YnpIajBJYWdMcGFaU1hGSEJERERCc2lKYlEvMUd6Y3RYY1BEbzhNMzBPRnY1?=
 =?utf-8?B?aEZDM3FUc1FPdjgxTTZGbERhSmtxMXpDdWJFTDJLN2EvZkJ3NGFZZUp2ZVJh?=
 =?utf-8?B?R01DTE5oZzR0YUp6MEFSQXlUcnlROStWZGE1c215WnNEYjliWGY4UHI4N3ND?=
 =?utf-8?B?cW8xdjAyeXhEZWlUZEE5bHllQ1h3d3NhNWRPblM4VXp4ajFJbW85SzZFSW8w?=
 =?utf-8?B?MDFuS0dyeURkY1VCTW01anA0NGVISWhnNHZDTXlxOFBMK0JhMFJWM1ppcWV6?=
 =?utf-8?B?cVI2U1ZmNWhGM1F2eXQ1cmtIRDBudVpaejlObTh5RGdGVVV0Q3Q2V0c1Y29h?=
 =?utf-8?B?akRVb0VqdDNrdHQ0bGk1R3NMemVtRjA1cDB5WkEvSUVoN2Yvc2VObFc2M0Zk?=
 =?utf-8?B?WFhqaFNIRzVmS2FGZ3Y5MTZ0enZrMVF0WkNBbFpGTzNZSkRJN2N1QjJoZVdJ?=
 =?utf-8?B?dnpDdHZ5V2gyRGpGUk55dENNN0djT05GWVNVaG5XQ0Zmdm5ZbHkrVFNpN3dT?=
 =?utf-8?B?UlU3S1Q0UWY3alQ3cUZCU1l1RGsxTTlLS3BBM1ZMbXptdUtyY0h1d0duV2Fn?=
 =?utf-8?B?ZnRNWGw1UXhjY1A4Qit0MFlJSlFKTEVuVndyMmJ6ZU1jRFVZL2FRMkNiVGFP?=
 =?utf-8?B?TUR4ZlhIZGZnbjJuVHY3WVRYVlRSNEJyaWUrSUg5VVpHczExNllnYnRVRTdL?=
 =?utf-8?B?L2RPWWk2MCs1NkdWT1ZnRS9HYUtzL1A4R0dyaXN3SUk2YTd0NHFBSXBRQ2dk?=
 =?utf-8?B?RllvS1N2ckFhVy9wNlFqN2s5U2Q3a3NpRTBZZVJwYjNhWFhya2R1UktuR3Jx?=
 =?utf-8?B?NlROVU9vdERTUkhVQ3o3R1MwekVGQ1dwZm9JcFhoa3hnZ3Q1YzdEVzkwSXl1?=
 =?utf-8?B?TE9IYlRnZ2FFTFUvVXFyTUdYWTVHeWR1dFhFellMMzdpV3FDOTlzZE1CcE5C?=
 =?utf-8?B?YUkzK2tWWUN6UUdoeUZ5dURUSHRNTURUQ0o4cDdPMlI3MlhJZFlUMDBpOVNw?=
 =?utf-8?B?bDRIbzhkTU0rVXpzb05uVjdUWXlJVDFLaEw2bXBpQXAwUzNGV1F3bDJYY25T?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VC9tACje7QGCnC4zasa5KGSaelWTs3BnAKY5zZDI1zwftqSSTYjY3aaGL7hgaNgpI4rt98vq61fGWO9R7zBPE0bIFV3LpiIITC2h1TMXvKyaeQ5oyfV1hLgCXFlRX+YQxarIFNefRRP1/JcCyFC6ouGiDqxQrizaVoA7WujQbWEAFAJOhswQbZkj8KYBHht5keoaoiGySL3nd6esCMCZO5hOLeQ3H0laj0G2IVM5NRqdP0o8EGXY6+MySmjLOqWdYpIAoSfjLKA/YFEIDtcJKm5YYFiywXHSZXmW+fJLOWK3h82CA7XON8FQ12owBhie4mghFjseE6WPKrj9NqtiMQzZK87MkwFl71pfcWbQTAz2qwSDtYTQ1OOkY32jEUEFpvPEwbnmQD6tR3UhqxTO6Bi37LQTWP1FxDlZuovir9sDejMrRcJABiizhmwJmmyC57x0x+yqA+DQNEqAXHnFXfagChUTW6IWkIBQ3iO5rWmFhND4WknyrbeQyNgD9MlQVZ2fRkRbVQf8M6bWkPRW5PjB4HA5dVUG/JZzIBhDDrllg6LEA+Ha94DL2ewg/Nb/494GRiEv9d3JFo3C0n9kyUu4mjH8sLFvPL3GYrX307M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b264ad1c-aa3f-4844-2885-08ddec8df82a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:07:45.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INNbptfmvpFFGhz7K/cGwEQNp7F6230U6+nQ85XE7Fx+G9E3vnUe7ucp4UowsIayzgJZKYzLV6eRE93dgGouuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEyOSBTYWx0ZWRfX7/fTsBLO7uAK
 vIeUseAehHKFG/sjvw0OUSplECDYlW3g2hXLBZiZZeI9XWUiyv/0u0fqLbA8ENeInE+gfbr0FN3
 LkJEzE7p30p+kwmfXoR9COeu132wjm77WBx2iC+whL6nme+DTk4PPmkcrO6DXrsGFI4IFEpW8YZ
 1nGO9qPKEUTbR1c/BfJZwu/wk8Ja5nF7JvKvn27RPQb2xkPBbh+oXudvzmP2vHIGAgh0RqgylrO
 EQ7SP9/LMBLAyjKc096eOkCFUwOXy3Zo+Jlq4eN3km2vHtSchVaL10DjOS3OHLTViAay+ASjNJd
 JiOD+HD2nCC/rzDl9XV9L8VvlFVD9Ad7/kR+8TR4fVcPf0vkFnu80J9/ZOS17FpdoyKhEhxmv4d
 krfmb9HbwFzPhqvk+eglJfq8wro0kQ==
X-Proofpoint-GUID: T6VfO3FpQWp_DOT5kT4FggfKgM7o-9su
X-Authority-Analysis: v=2.4 cv=GKEIEvNK c=1 sm=1 tr=0 ts=68bafcd9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=IMbHv_LklGgl_W15rBUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: T6VfO3FpQWp_DOT5kT4FggfKgM7o-9su

On 04/09/2025 20:25, Bart Van Assche wrote:
> On 9/4/25 2:49 AM, John Garry wrote:
>> On 27/08/2025 01:06, Bart Van Assche wrote:
>>> [ bvanassche: modified patch title and patch description. 
>>
>> it's an odd name now... I don't know which queue limits we are bypassing
> 
> I can change "queue" into "SCSI host" in the patch title.
> 
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1539,6 +1539,14 @@ static void scsi_complete(struct request *rq)
>>>       struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>>>       enum scsi_disposition disposition;
>>> +    if (blk_mq_is_reserved_rq(rq)) {
>>> +        /* Only pass-through requests are supported in this code 
>>> path. */
>>> +        WARN_ON_ONCE(!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)));
>>
>> eh, do we really have passthough reserved command?
> 
> All reserved commands that end up in scsi_complete() should be
> pass-through commands (REQ_OP_DRV_IN / REQ_OP_DRV_OUT), isn't it?
> I don't think that we should allow other request types for reserved
> commands.

ok, I suppose, but it seems odd to say that a reserved command is a 
passthrough command.

>>> -    if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
>>> -        ret = scsi_device_state_check(sdev, req);
>>> -        if (ret != BLK_STS_OK)
>>> -            goto out_put_budget;
>>> -    }
>>> +    if (!blk_mq_is_reserved_rq(req)) {
>>> +        /*
>>> +         * If the device is not in running state we will reject some or
>>> +         * all commands.
>>> +         */
>>> +        if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
>>
>> I am curious about this. I mentioned previously if we only send 
>> reserved commands to the psuedo sdev (in this seris). If so, would the 
>> psuedo sdev not always be running state?
> 
> Has the above code change perhaps been misread? The above change causes
> the sdev->sdev_state check to be skipped for pseudo SCSI devices.
> 

Maybe I misread. I was just curious if we are doing this sdev state 
check for a psuedo sdev, which does not seem to be the case.

Thanks,
John
