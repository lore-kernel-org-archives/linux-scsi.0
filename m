Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF1A21E0AD
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 03:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765941482; cv=fail; b=b3aPQ7Mn62G+v5xJhAC2O0ySXmvmrN6rTGw1BSbHPRRdFINtsH3R1jnL/l4NfkyujwQf6QHc6ZgfPXjqxTIo820UVzXu/hKlu/ZvWxYtKVJZm/kKsOuALQa+brf90OD5BEK5jllNU/eQ6PpFzsBTBzbI1Bdu+un/xruWY4gNnAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765941482; c=relaxed/simple;
	bh=yDSrwKSSjcYboIgry2h0r/wQxqdfptGlQiV1mVBbTOA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oSEH/cqZIoHOdmBLRsAqjt8gKZXeNqG+bjV5i97THswXkI38srXh9E8YluVmOMZodSt2fqNwjG+kZaGCE8GsyRAshxSbD5O7WgVG32h7ma6We8sU/0jPu8DdnzWo6IS7yVeGcZvK8MiHTIMx0UCTm1Kb1YE3WkPn80EQ6G1xfcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IEXptVNS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Td30Kt6l; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IEXptVNS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Td30Kt6l"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uLiI1620361;
	Wed, 17 Dec 2025 03:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yDSrwKSSjcYboIgry2h0r/wQxqdfptGlQiV1mVBbTOA=; b=
	IEXptVNSHhkqsRgQ7Mxiz85gpFtzb+Y4gFd96LHyU/Y0z5H3mcv3k/tLkN/dhtMw
	ROxfReYR5fbEw2QpIH3ZQ4npoi4/Y/FHqZIa1R1jOvz2srlG7wfLAwAs6eDp7KpI
	/Icz8RxtVRG4QqnAVkBOTSsbhuyS/3+NSZi+UouKNeQOQZBunHwoiffVEy5WgCtZ
	wm5zkq2/s8IHZFOka6UXgsJwqHjF+v3PeE+4Ue9PS9mlVYgkUqwfxdBtpwfd4sYW
	weDUgBuykpvjPh7xjSjEy6zpMUuirEPP9mqezJdtdlFhEA3w2mR45uabqLFUDf9c
	yH0aU/aebTeTG5KXYbMaRg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28d6u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:17:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH1Gsh8025236;
	Wed, 17 Dec 2025 03:17:58 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb8wk1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:17:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FWJGc1pXHSZ4cJscPvkUot/jCBtEEZ785a+ohp1GFqKdGYNUYJb7Qf5da/yTEJHf9/Hs/qFXpmpj4xf4hPjjMfsCxqcKxT9k5v8Pj621zbYViC5QORFQxatLvfPkSrOvppbFWOjEm5791Mt0Zs3/p0Gw1d5Fqdm2j5bq/cpftQPxtVYZolnP4+/jK8FZuGlY7g8ur6U/OftkLj6NEOrXRMTol3qS1T0xgWxEKF8oIh4dmgyULS4Ehuwy9wl5lsD229QTjr44yNUsqF4tLwAgH9CtDpYzpjf1bzkxVX33H3xinMLP7d4yX0L00z3nGjYbdwnvmEkVSR1xGXm34YkYqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDSrwKSSjcYboIgry2h0r/wQxqdfptGlQiV1mVBbTOA=;
 b=dzn6Ej5ReND51b+jMeieaWWtVGYDd5Euh9SEUJvO24KGyBF+2gzu1Gay8FKzdEqwlNC0sTpRST9rzLsEi9t+rX3uc0avrOEiJj/C44s894zzgAbzQTKmpisq10Mwo15xvyj69F4b4hzXcEzsVUbdTuFkdtGdZEO41hOZL38R524JOd1wg2wXlUDQX4f5iYSiwVWDdwClzhsFZSGvpm4ED8dVAIutcXLVzVEUV0QQHbN/K3C0SNDBpkKIGWtufGt4nJO7fHqTzrXi8f+T9+8KDQC8emiX+N/nG4D/LRSUHoeZe9yUOR3XBNjCl1yPodqtd7yVGxPHvOGPRwBsbUHM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDSrwKSSjcYboIgry2h0r/wQxqdfptGlQiV1mVBbTOA=;
 b=Td30Kt6lBscdZQke17/SqjXMR3b8ydQvvipJD5qbQ7FikvwwpS1h+n37gQkEsRYKVMjUgx/twY/uj1OU/UpDcFQoo3iR4fcAwWpYf8/bKXMctrSizM/lmvCt3WryuqQ6Od6MuBkgfGiRo+/hbehlnJDG+XAStQZY9tlHsO3DowM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4123.namprd10.prod.outlook.com (2603:10b6:5:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 03:17:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 03:17:55 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v2 0/6] mpt3sas: Improve device readiness handling and
 event recovery
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 13 Nov 2025 21:07:04 +0530")
Organization: Oracle Corporation
Message-ID: <yq1zf7h4x1k.fsf@ca-mkp.ca.oracle.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Date: Tue, 16 Dec 2025 22:17:53 -0500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQZPR01CA0070.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cae4630-db1c-4438-7c56-08de3d1aded2
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?TWgzVXJrMDRTcmk1QjJRaWcrQTRFU1V5a1JQdENCZ0RTU1FQOEo5bFZ0VTBh?=
 =?utf-8?B?dEpNMEdrRTdDVmUycWJDSllWTW5Pc2lkVmxJOERLNXZYZjNLQm4vZW5DdERP?=
 =?utf-8?B?SDZJck03S3FjOGN4YXBWWkduaUNQNVZoOWtyYUEvQWpaL20wRWYrZ3VSMGNJ?=
 =?utf-8?B?NlZXM2JiVUNJMHlNd3ArZGFtWlV0M1NUQzBzV0FPWURYdlVyMVN1SWo4b08v?=
 =?utf-8?B?QTBFMSs1Z25kNGdBeHdKbzNwZzdYYUY2YmhRekdvS1ltc3lHZURKTFZ5WU9r?=
 =?utf-8?B?VGN1bm1EMGVYN3UwSmI0c29BSmJzVW5Bb1ljc0ZjMUd0R3B6VE5MaE4zWEdo?=
 =?utf-8?B?Uk4zZzNRNXNLMXlyRENvRUNjaEFBc0kxZ1NXbWNWa3pUOTlkRnJOUnUwOW5W?=
 =?utf-8?B?amJzMkJFK2dRSzhwM2pnOVBtVXh3VU5IOFUwOURzNEQvanVpZkFHVGI3RUxI?=
 =?utf-8?B?cEpzaER0R0hGVHhkUytBdk1Zb24zVER3aWZlZjhxRW1FWDhzNFB3RnZNMm5z?=
 =?utf-8?B?Vys1VFYrYnNNcnJVYmFhbExrNTQwcXdUVUtZeFFVdDlWOEJnZGJ4SzVpVGFq?=
 =?utf-8?B?R21uM29qZitrdFAxcGJYaEVmZlJQQkttVERENXl0YmwvTHVMREZrYjY1dTBy?=
 =?utf-8?B?azNvSEg4V25MdDBvMkRwZVNWYkRyZ01ab2JVTXFWanZzaFgvMFhGc3c3alhC?=
 =?utf-8?B?bVhlMTFlZnd3eXJpTGExWHRBRElOenoxTkFmWmtPei8xd1ZhejV1YThtK1pH?=
 =?utf-8?B?b09yTEJxU0ZOT21SallUOUxYcUhSWHE2R2dhUTd4RG9BQ0s1U1ZrcEp5djM4?=
 =?utf-8?B?cEhCemNnT0UvQTdveEJTWWFTczR6aTB6Vjc4MmlsN2pIZG5UMnVVYUtydVJ0?=
 =?utf-8?B?UGpXRnFvK2hWQmlQazJiZEExdlN6QmhiMlhJbnh0eWI5ME0xa2pER1c5U0hq?=
 =?utf-8?B?a3JsQlY2ZGRzdHNZNW5OR3VETTFNdDZuUUlJU2hwaVlGOWZTcndkRnMvcEc1?=
 =?utf-8?B?Ylp3OHI0MktPV001aWhmSzR3aUd0TVI5NENTbHMveGFqZWI3SG9mVWVRdjRw?=
 =?utf-8?B?MDJrTkN6bm5xZm9RU1krK2hja1hkWkFxOEFXQXZqMDBuWjQwR2VEdDZSUi95?=
 =?utf-8?B?bnRQY2VaRDE5ZXFuRTN5S1NQRmpVQmhtR2NqRnpudkMyOVNZaDloYThvYlVE?=
 =?utf-8?B?YSs5ZG5MS0hHZ1RQenAzNzNoN3RXOUp0L1MzUHpYUFJnNU42Z0c4TUh4bmRH?=
 =?utf-8?B?bDBqMC85V2xoOEFUOHI0OWFPYm5GbjBEemd3Z3JRZTlTN0tWVEFKMUZjbGRv?=
 =?utf-8?B?NXlLeTFWaVA1MEV1VkRZMUJ3ZE11bTMxdFByUzhQbGhYakRnWlpPQ1ZsRHRC?=
 =?utf-8?B?cWFFNFFVdEM3OWVmOWdyOTd6czEwNzNCdDJRaUNFa2M4LzhUdzdid3A5WGZq?=
 =?utf-8?B?cEsyNlh2ZnJlNW4rUHBsWUtWZjRHK1k5dDY0bkZSYzU4RXRxQ3JqTjJzOElr?=
 =?utf-8?B?ZDNYUCtWQlZOalRBWDJaUFRudWtGaDdJcGovdktrcXZDSWNaVlB5amhtQmtl?=
 =?utf-8?B?bFVhSVJvWnVta1dmVEMxYTBmUVUvQ3A0TDN2amdMVVVwSklhNXJBTEpUZk1N?=
 =?utf-8?B?N0R3SUJjT2xIQndqcUU4bVppVHduNmx3ZmxiVmwvWTNtS3JlT3NvMk8zczBV?=
 =?utf-8?B?OFR3cWtxRE9uRlVFODZBN3NYcEZlWS9wWmR5cURvUUhVMERkaU4xM1JESXhX?=
 =?utf-8?B?SE5nam12WURUUWh1eUtNeVgxQnlPVzBESzdHZEFBUnRlMytOVTZ6WDBkeHI2?=
 =?utf-8?B?cmRlZXpkUndPQWFRL3QrY1FEMmZvbjNXOXZ0azBBK2RzR1pIRFkydTBVMlgx?=
 =?utf-8?B?c2p4ekp6UlRjTVpZK3k1N0c1WldESlgrdER5TXZSMkZOTkx4N3J0Tml4STU5?=
 =?utf-8?Q?9Otpo7d6xz/joePUYCFieCBlJ1KfM28K?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UUEvaXJySmRieC9ISjVNSzdLVUdwQjFtT3VFcXJ4QzJSaVBlckF6bUJYQ0Nx?=
 =?utf-8?B?bGdKRThlWEgydXZRZFhuYUNUWlhhZk9FbER6eFg2KzhXK3RjNW81UnR1RXdr?=
 =?utf-8?B?akt6MFJsZi80Q1RqVThWdkpUNWNXbndRS3VHR1o5WStpdWdXRjJtb3A4eDRS?=
 =?utf-8?B?QXdjN3lieG1wRkRLWU94ZFF3NTNPekFlUUNEUGRSbGpxQUlrcTdjZG0rZUhY?=
 =?utf-8?B?YWtDUUJQemliL1RlU1MrOXVsTzVFSTFjdGxTeFBCQjI0eTBwVVJrN1hYSWR6?=
 =?utf-8?B?Y0pxcUI3d1BWMjRVUDY3dWRXd0lIb0tibi9qVE1vaEVoejFBVm9ETElnKzBx?=
 =?utf-8?B?VmxRdE5uNkh3S05mMGFpbjNuZTRVcW9Da0t3UDJVVjMvUnZTWGs1TGc1QXFw?=
 =?utf-8?B?RzNmeTY2VG1oUFZhL093VWc4ay9LbXRhTmN6WDFkSXZ2b2EzRFgxZk5temxE?=
 =?utf-8?B?eFlldGpvM0FzMzFOZjVuNG1Na1RxVWNRdnFGM1NNN1pIcDVLMzlVclA2V2s1?=
 =?utf-8?B?ZG5EQ0xKazZqTWVGekN1bjI3K2pkZEZqZkV0OGg1cEU2Zkh2enFvTURQZVdY?=
 =?utf-8?B?a0pQTFc3UlZxZ2kwMlNVeGYyT1BrTzMzWjVHUENqaGRSTCszYkJNUEZTOFJs?=
 =?utf-8?B?Tm84cUlrWnN3MkVWVG5IcmQyWGpWL1ZBWFE0RjUwUTNva3pLdnBpM25CTzk5?=
 =?utf-8?B?SjNQYVNDd1ZvZG9LQW1BMFlVTDRwMEpyM3dUT0Q0c0NxMlJja1hybFJDQjhI?=
 =?utf-8?B?QTIvcVppSlpMeFVySThhcWczTHBQWFVaYnBUaVFiY3orM25rSk5XOStOMEYv?=
 =?utf-8?B?L0hnZWtieHFtWjBnZEpYWVJEZ1g4RXgyV05WdUEyTGwzNm5xTXdiKzRFOXQw?=
 =?utf-8?B?b3BiRCtKaWliaHIzb01LOGZZQjEvc2RQK3lZZ1d3cE5ST3pSTktIMHNqMDFZ?=
 =?utf-8?B?UGlIN3JUYXgvdkJEQnJwOGNVMnpwS2tKL2gyVk90NVhpaEZ2TlAvZytKZEJu?=
 =?utf-8?B?aGpRTnd6WTRLbFdhWjlWazJ4VmZWWFVSRVlITC9kL3RnMC9hdG1CdWxNaUVP?=
 =?utf-8?B?NzVFcWdNcGpGbUxudm55SCtMTUJwdEVWUytvWThHVld3S292OTJ1N3VPZG90?=
 =?utf-8?B?L2t1OGtZcVlmQllJMWV1MzIybGRSRG1yYXhrcStYbTk3RlN0UzhNajM4d2xh?=
 =?utf-8?B?LzFHYS8xc3lYcE1manNRblhIWkhEeitzclBxajhWeXZjOU1mOVBYKzVjLzRD?=
 =?utf-8?B?N0NFZng5NnY1cko2a2FCY09ZaHRRRUdIb3N2V1BCNDJ1UTZ6UDZ3WW1NRWFY?=
 =?utf-8?B?M3pDUTVjQ3JWS0dvKzdHMkZjUzVrRDlkV242K2ovcUx6SFBaNzFTSUdkaTE0?=
 =?utf-8?B?ZVhvd3Z6cGF6OVozMmFuTWFJZUJwb1drTGxPNDdDUXNKNVN3MHNuY3BLV3d4?=
 =?utf-8?B?SkNYRDEzajNuNjBLSDllb2xycW5pQjVqOFh5SERqeEhzNkdjRUI1OXhhbFdL?=
 =?utf-8?B?d241MTRCL0x4bzNVRGYvWmQycjltNTZTclRKZ3dDMkRKMDhFaWxucEEvcEVR?=
 =?utf-8?B?S3hLYzFKS1FZYmIrbUhOT254UFFveUFsR0pIeWpsZW8vdVMyNVNQQis3bDBI?=
 =?utf-8?B?eENkZjhIU3BRZHVVNWJ6OXVIOCtObVh0QVI1d25Wbmg5T3o5QVYwTkpCSlNn?=
 =?utf-8?B?MHY2MWF2ODVRVE9nclUwY0szOExlMi82U0dEa3NJNFFiZk1hZ09tMHRBcVdV?=
 =?utf-8?B?cnl0ZFUwNFhYWHdTUXlOVDA4K09QaXE4Z2hZOE1lbC9qRDNhbjJtelRQMjdF?=
 =?utf-8?B?T0E3NFo1VjhXSVZWenI1cFk1NTkyR0c4RU10T2l6UWZXSWlVQTJCaHYzL2kw?=
 =?utf-8?B?eWxxdGVKbW5uVTNvMkU1eHFidlRkaFZNK3p0MllTSkQ4dzc4dUZqMGxNTnRZ?=
 =?utf-8?B?STVGMGQ3d0MybXNWNXVUSzVrYm9tMjdva0VzamljNEJKODZSZlErdDZ4OVR2?=
 =?utf-8?B?eFA0R2hPTktCUkV3M0Q0ZmZhNElBZzVhblZvbWtlb1NFWnQralRkUHJBSVFa?=
 =?utf-8?B?dFdyWklScTFYZzBaTSs1cy93MkVoeW1BTkZ1cjhOWUVNcGlSNVhudEVwWS9V?=
 =?utf-8?B?Sk5VUXYyTFFOMlFyZlNIbzBZeHU3cmU4SHl5dlNQQ0o2akw0OTRDa1VkUkpO?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BU6ip4q2MdZXCYoQdyt8e14Z9CF5bDj2YblBjx2axpGNHWBfPQGu6w8oOgARO0Pgq4eH/onoTpf9m1wpoOosAv4XLi8KXwm1Cs+BjTYgtTr3aABXK6n2T0j3RpY2DZITEGc9WjIq4ibHN1I1DK6GymF9ja7F/ABzpyRvgk7QOD/baHIJ9VpHQ2kCJTR3n0SUXXNxLAlhADfBmI2CJtHVYBFobiOIyaytS8Px3ToL7fl6ktzxhibHJB2cbxBK+37FYb4Xf5ENsYbzN5OAwzNFJikrOiklGotyyeKp2X0ZitFnnEUqIoRs8mpj4AZlQESkDoZmdMFBXRpGdVz02oVyHW2xn67ofFXnquDaAg5O8V2xBV59OF8SCt/CwXTwn6spJMdZpKF23xCPcrXfM4tdy5JJ1C8MGbpwF7PV4IjNaFt0a73s6PrLpXCJgT53DF83oPKllLMrdSUpG7H+EQMsDp69SJOiO6iHdugWhXYmp7zG8lCECW7kR4uSG957f7PPKGm+89Xz9bx+ROr/Zqind4iOL0NfmOfRw5QZg2UYfdPj74vHQ/ykMfZ6ZNgbtHZ/F8fPBJ9Sr95oj7NtJWVeYaxyvzWTSCDiyOEiRDajndM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cae4630-db1c-4438-7c56-08de3d1aded2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 03:17:55.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mz9zOaOVNlTKSbcxQSulUU72lRniBnHj1VWnl1Jd5TjGbXXFauRKWl2tFwsSDnaZlsWJVFAPWbVdXk0i5Jy6cDh49jKDYS/cT1vGq45REQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170025
X-Proofpoint-GUID: 9vhf6L8RNgOPLA8jFxPxQFhcb7RhBnBY
X-Proofpoint-ORIG-GUID: 9vhf6L8RNgOPLA8jFxPxQFhcb7RhBnBY
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=694220e6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=J_qgt37D725RNL2sfO0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNSBTYWx0ZWRfX848CGLN9+MEl
 bNZ1h6kf5fOyJmBZN+y2PuFZYs/0rBhbhBD6wsXzFfB7aFO77I4qauwCpiaXPkwoH/aH6QPOB/f
 4Afzp/H3vKC6qsUTPXJdD4LaihZ5KoadPtXkpT0Y7FP1sIiR5omoUwdqtDM6bU9RPVcEVi3jjo4
 0r7NAhsdHpScWucTGYCNDlAavPNxoxE6Jd1ORmkMT3EivFe7M0Rd2+DchJZW1kVQNrwI0x5dC/g
 8hGw8dLfJnPSAQiRxs1SYuTkvDwjG2pJcBN0Wn/d71VwU7D8txJk+xEuDyVqLMuDBnH8AP+jh/I
 Pv3+0SFzOuWpkQ5MqgR1+gJ1xKZAc1y1rO7AFci7GUEdTJUGPHoeoeLWxqb35GtRe+wTBm2ziH7
 HwWDeIlPqm5sPf2oFUpHB3K1cFVJsQ==


Ranjan,

> This patch series enhances the mpt3sas driver=E2=80=99s device bring-up,
> readiness detection, and event recovery mechanisms to improve
> robustness in environments with slow-responding or transient
> SAS/PCIe devices.

Applied to 6.20/scsi-staging, thanks!

--=20
Martin K. Petersen
