Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7DE2FE567
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624342; cv=fail; b=iop75PIG8XslheS8Hes2wUIDVcM1AoTo5h5akOvtz68yLQvF4XwszwXJcmNx5gLYrWI+ITz2+4zwjZ7NIfCoR403g1gkSUPHmndJBSTp9xuBa95ESuyH04qUzBIeNLfQ4RFk8vx06iWqdVAajZJ8+ds2kms1dQ0M5+Xi2jHmn/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624342; c=relaxed/simple;
	bh=zbCBRQEGBC0XJm6A5JUqESMeA8nKIexHPwyr4rISW48=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=stwXeIKfGLifjjbPH+CrME1K9C+ANBw3UCD6xWhvpTzItYxCes74AiuaiCN3QM17UrRHOLrHD175cU1RXu1g72LA2olFiGn+fe10V7Chq3QaEtKS+6LUNXAs9JISq+J7hiEiZUC72gJ/MZg22xkpv+bvylC9+sYibpu8nwUrKGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z9AT2Mjh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vr8WjFpP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z9AT2Mjh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vr8WjFpP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H3BYDY354406;
	Sat, 17 Jan 2026 04:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+NU0mbNxXGmLZRpo/eqm29vbUMU2rxaocCm9x/YCwo8=; b=
	Z9AT2MjhniS2MnEI/QXxuWRbII7DypjFWef96nTVa4j7NU6AbTEcQwLWhhqcI33r
	/WXmBdhNa9ElVqKKq9PYlXfMIWKSoQJt9/pkqKsDc7WavqPXhPh+wSsl7/moyKZq
	51SbQCRPO+yxeJBlROmsqcWtPBOASxvNk6c0XpRW/wWdcH4Z5P1khouoK0ceyKKK
	oq8yotnerDgikTxvEMIAwJZP/O2SvojktubAbJ4KomwuAGYdIewbOODLp1Lbyn5t
	OrtZrHJXp+CIBh4R0P5vlz7T1SaMdZVrBgEqubWEIh3+qk4n8V8r3nDyskskWYpR
	oaVWPLZ2OXqsg9q85GxM+Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5g1g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:32:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XrG9040546;
	Sat, 17 Jan 2026 04:32:15 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0va3haw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:32:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9ETXWAJu8zZQWmCv4LiDMGY6XCMSxPFV2AtPDYlYBKKgzaYfavElYqepAxRo39TO3MF8GTozg9wJHOBww0QgVSnQeJudgnRcAeu7q0/KNd/KUM2bXdAZL145eYWnlMZOX+3N07mLAF2qHQQd+XE6MS+sOYuOsSzy89ckIEM5FwP6KsFI0juyX0utDObEB7U+rAsHxzbaXjbaOkCiImpaDj/30gQtCR5mTyrongkQOKw0OUnerbLJChirIFmEJ8xefv8QAeVKEIsQ5jQCeSu8I1HKgn1/L6ZPpYyOhuGJPFAS8pWDuTmstR5tGGCnbbsJizGx4GnImGzHXtNb7wTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NU0mbNxXGmLZRpo/eqm29vbUMU2rxaocCm9x/YCwo8=;
 b=H/stfSL083omaqkBzR331OFIDhnHO0j1Eh8D/bdw8tJkuC86MZb5mxZGgfrd1gpZTetJNIo60ZmnZoNFKlCyYwPMfTnrrSOJaKMGK6DsULIwPE6FAYM1z43jcL5iNjDyKiIEC1GfTop17T7CnXNQKD6gQ3g+9IDuuEhRIPqMzPVUNjvQ4+oLKzWPJTtWNQd3JGfFD7LWtls6fNq2jyzA5nyQmetKNNI1H/lDsKzlQmKKoc6mSCJM3Zx1ddkssSiPyjMvLsHT1Fj83Li7SOSPqsfBa4nGV25CtOCS7k8WGpILYfFbGecK/AANGp+wRWvitgWr4YqSSqRuEek7qQBoOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NU0mbNxXGmLZRpo/eqm29vbUMU2rxaocCm9x/YCwo8=;
 b=Vr8WjFpP3z+Ib0WIhwaDUKKZ9ytd43A/N5teH1fw2xbuAhnkTW0KTXnKFNoEe5z+wZ6cgfga7K6+T7/GRwsruQmmrB/VVzCwON7Xh0Cgxiy4ncRKi0GcDUz1cCa5rrufGWjfE7iIVaDKf5u5HYs7jpKc9aqCOAht7yKEjA2Wmvc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.7; Sat, 17 Jan
 2026 04:32:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9520.006; Sat, 17 Jan 2026
 04:32:12 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/5] Change the return type of the .queuecommand()
 callback
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260115210357.2501991-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 15 Jan 2026 13:03:36 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ecnoj1wr.fsf@ca-mkp.ca.oracle.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
Date: Fri, 16 Jan 2026 23:32:10 -0500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0079.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a323de-0713-44dc-a4df-08de55816249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2RCamUwR0hJcjlvOFFJSkU1SStMSVRJaVo5bzdPWmg2ZlhZQ3V0a2FGU2JF?=
 =?utf-8?B?VjRucDB4U1AwVHRQaklDNVdQZVJCM1hKWXhCVlV1SXlBVUdHRkRSTjgvem1i?=
 =?utf-8?B?WjhPSXl6aTRLYUZXU0ZxU29QMGlhcW5BNEdMbVlLNE5vZVN6WE1abWt3cWdx?=
 =?utf-8?B?a0llZkVTYXFTR21VemFrYlZJQUNBb25sVVhJNyswWmpLd29EekRHd3pDRWRH?=
 =?utf-8?B?UzdwMTlHd0FVd1l3NXVqKzhrbDhUZmdLeVp5MCs4ZmhGdTVteHdBU2tCRGpK?=
 =?utf-8?B?TEVXODdBRzlFWHFPQkNrUTRkK3JqR0J3NENKTlVKK3BTQ1Ewajh2NlNyVlkz?=
 =?utf-8?B?Y1dSbzVxVmEyUnJ3TkR6ejViWGxEanpmcjJQdjNZR1NHb21rWXNPc281OHY1?=
 =?utf-8?B?WmxCTkdveDNYYVNlMld6dnBBclBLV09TNGxXZm56TEgrc0F3cGJaaGNOUWs5?=
 =?utf-8?B?blFub1JTc0szZkFEcE4xMElhU3dwMEpIOWVHMUt0YzlwbzRlY05sRktMUlR6?=
 =?utf-8?B?ZXdDNlBkZk1BQ3NmbmoyM2hCZ09UVDJBN0dLRzhpd2hhL3VrV3JXeHErdE1G?=
 =?utf-8?B?YlJjUDVyTEFuTUlDYzFuTGh5T29ZZ25xQmFIUjRTbld3WnZMZ3h5Q043dXI1?=
 =?utf-8?B?OVVHYzNnejIyRER3NlNic1JJSWxjc3Rtc0ZZaUJuc29vUEpMaWNPODZuZ1ZS?=
 =?utf-8?B?VGV5N0RNUHladncybUpGaG15VllEbkxzKzd0ZTkveGx4bjRoUkJ5QWE2Y05u?=
 =?utf-8?B?dDlkanhPcHJlQUJKU3czSUNWUzVYcDZ5enpFVGVJMVR0TGJiT05MczVXQXY3?=
 =?utf-8?B?QTA2NjBrYXVQQnFYc21MT3hNZzcxV3JmUWRNVnlsOVQ0OXVqeDhoYzRaZHQy?=
 =?utf-8?B?N0haQUE0S29DVlJnRE9MR0xBeHJ0cGRSMDdJYWYwMGgxWVN0a29PeFBhTmEy?=
 =?utf-8?B?MnIwMlYwL2dqaE5qc0tQTW9vVFhpZmUxZ0h4NWVJbG5meXNyVzhyeWFvQnY1?=
 =?utf-8?B?TXJOOUN2WEhWNUc1Qm9ka3BQT2FrQTY5QitLcCtja3VzUTRXQ1BZYk44VHRL?=
 =?utf-8?B?WnpzNTlsaFBPbnBxdEJDS01MdWZGQ2d4bklKa0ZKODBmdCsxZUY0ajFVUmFW?=
 =?utf-8?B?YVh1S1dNb0QzNnE3SjZyM05LNWFHNDRMZURneEFERnNPYnVCRGMvbFBIdGtt?=
 =?utf-8?B?YW8zdjYvWGtRU2QrdmFKN1RRYkxQVjNGNEZFMDBNM1hnSkF5blBLVi9jUWVJ?=
 =?utf-8?B?YnkvTURJQXlxWHZUdXg3dU1obHh6Tk5kZ3VsQXp4TVk2aUQ3U1k0b1lISmNO?=
 =?utf-8?B?WmM2NUxqdlRaUzQyRVZFT25weGVLaVhQdXdEeFhUTFFuL2o4S25odGNPOGNj?=
 =?utf-8?B?R2lkYVdpbGhXOURwcERxeWp3YldBeVhRTVF6WkduRjRxeklsV01wTlErZjBY?=
 =?utf-8?B?a2k4TTJia3U2d3l5QjUxbEF3OGd4VFhDZEx6N21TeE5qWnBrUjVkK2cvNWZH?=
 =?utf-8?B?ZmRhNzFCNFYyaXdrbDlETEV1Sm8xNUhLQ1FiOXBTYkdBUkRjTDlRY1RSQmdl?=
 =?utf-8?B?bTlSQWV5UEFFNkU3NC9NU3NtZFFnaWFXS3pzQ2REVjFxSVFHRVhLc3Rxb0dx?=
 =?utf-8?B?ZjVnTG9nRllLRkdNeC9TN1c3Vjk2VkZzV2dvR2NDMitSUzNzZUp2NUF4bGRw?=
 =?utf-8?B?QkFwb2RZbjRNMWYvUmIrTmdsV2htVlFUdHZDUzNKVGNrOFgwc2o4Nm5FRHRj?=
 =?utf-8?B?ZFVZN0ZEK3N2OGZZOHZMV0VSK1VNT1NFT0dlM0hFVDlrZUlzWnpvL3dWdEp4?=
 =?utf-8?B?dmZBc05Yalhhd29rUnJjYmFyc0Z0cHRNZCtGaU5HTWxYRHFVektUeDhRZ29r?=
 =?utf-8?B?dVVnNlY2YTRjVnZ4WVg1Y1lTcmlnRmhoeVdVSmpBSWVjSWhWQVpTMXNMME03?=
 =?utf-8?B?dlhVRE1mNithbVd2bWRsbGNWUit2MmVVaC96T2gxSFYxblZEd0VCT0ZacmQw?=
 =?utf-8?B?aGtwV21ReTRpY25CVy9nSzNoVTluUWJYTmpMYjZWKzZLSDM4OXl2OUx5VFA1?=
 =?utf-8?B?cmJ1UWJ4VEl4cW5aQXJrYjhjZVAzNkRHV1krWEZBQ0JsaFhMRVNQVE1VMHNt?=
 =?utf-8?Q?2xrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWdUb3YwYlhnMTZMWmRBdFdaTGV5dEFxS0tQU1RmSlZ1NDBEWVZRUnpyeHVB?=
 =?utf-8?B?UDV0Z1ZwNWVoSFpidXNhU1N4eVo0NWV2czRQSTJpVGlyNFBxYXoyVkkrMERJ?=
 =?utf-8?B?SldyOExjNEZPOEhQTkFBV0t5d2gvYzN5azBvcmxwMm5pMFBXaTRZZXhiYTRr?=
 =?utf-8?B?UVZIdW85LytLVWFuVFR6U0E1SGVFbjdVVnhNNC9aVFg5K3hMeW5FZGtyOGZ0?=
 =?utf-8?B?Ym5rQVpSdDdaYXpqZjJ2dks1TStEb1E0SGNyVmNpZWJZbVc5TWVrOE9JaU1a?=
 =?utf-8?B?OWQ0UmFLUGNubTM3QmNaajJ5TUpBbERZcEljRE8xRml6b2ZNWkQ1UHRrTExz?=
 =?utf-8?B?WFRHTStFeUIzT1M4UHZYeW5Rc3dKN2FLWWpZZ1BYQjhoVzE2a1ZoL3NTd0xl?=
 =?utf-8?B?ZHVubHpETVZEa1RjdGFiZU81cTdEVTUzR2RJVkhUUnptOVA4TzlkK3ROdWVH?=
 =?utf-8?B?TjhIR2VhYlp2Rk1KSHYrRTAzVGZXdmV5MnZFR0QwUFl5cXoyYzZnYzg5WjA2?=
 =?utf-8?B?YW00SjhNOTdqMFZNMXQ4YWNEbzkwQmRkaWs2cTlNV21tcmxpSGowejE3UHZ6?=
 =?utf-8?B?dUJjaE5vRWkzYVZTclVlNFI5azZ2Nk5raUErb2ZIaEVsSFdOVDlwbXhBOGN1?=
 =?utf-8?B?Y1lnY2M4YmlMeFdVUzN6SWVRUUNOM0tUL2VYYWhCb0Exd0t2T0FEamhPSTJ2?=
 =?utf-8?B?Y2tuUlhxWmhhYXp3QjRoQ1lkSzYrOFJ1cjBGS2NPWmovSXJ1dHd4YUFORlBm?=
 =?utf-8?B?d1JYL0YwZnIzZS9GallLclFkS0pqaDkzOGtSK25DcFBselVJTDd4MWF5T0kr?=
 =?utf-8?B?RmFUR0FnZHY3c1RoK3pGb3VteHIvZDRzVG0xMkl0OW1DODArUjBhTlJKR3pm?=
 =?utf-8?B?amRHRzVrTzByYUltYmRteXUyeGE5NURoWlZmTmFiZHM0YjlhMXNEUlJ0QnNG?=
 =?utf-8?B?T3FmNDlCWGdZYVBFN09GYWF6OThwT2N0WEtYT2hZNFE4eUNDa2J5ZEhxRmZM?=
 =?utf-8?B?ekpyM09YZzNRbktDNHB4WjZrcTV4bHJ4bGFIVzNvanpkbm5aVExkSGZoUjQz?=
 =?utf-8?B?Q3NPekpMcnFjUzkrVld6Z0RVK3JncG11MkhYKzRIOGNnZkltRysrU2N2UTB4?=
 =?utf-8?B?Q0dESjlOZFFJRjlPOGszZzk5ZmY2bUw3KzhCWkVFclpIZlBkbnM4ckZxZDJF?=
 =?utf-8?B?bGRleVRLWC9SQjVuT0xnSWdwU2dnRFdmamVOR0NXNWMveHorcWpqZjZwY0No?=
 =?utf-8?B?ZkJodzJOVjdiaVdCcVZTWi90MWdYSWxSek1XNGd0RGRNdkFYOTNqN2Q2YTZa?=
 =?utf-8?B?THFzUnRXaGljT3lCQmV1L1B3R0Z5NVM1cW5rQTJES3ZsWEYvQlM3OGVISmsz?=
 =?utf-8?B?M1YzM2l0dC9NcEdheC8rZVdYcHNvaUVGc09yT0lUSXdIL2lFTVdXd3k0T0xl?=
 =?utf-8?B?eHZtRU8xUkUwUmdlUjFkbUxvYnJTZGovVEtWWnIyUG16Rnh6RVcrWWNpdENE?=
 =?utf-8?B?SlJWcWFRS2IybnFrM0F0VHZaekJTSnJRUi9KcXBvZ0JIa01xMVZ3Zmo3TVJt?=
 =?utf-8?B?ak1DSURHVWxCTW0wTEx4VHg3Q1lZR1BFaFJtTmxibUN2VUQ1a0dYNTlxUDJj?=
 =?utf-8?B?QytreXVTd2gxSW0rSThNdnNySTdLYkROWUFlZ3R1Yk16UTQwcHlyS3NYbGxF?=
 =?utf-8?B?K3ZrQ01aYVBMK3NjMGFpL3ZFZHI4MzVybDk2RUtDTnAvMG45aisvcGpkeXd0?=
 =?utf-8?B?WVptL0c3QUVVTGJxZEdrTDlBOWIrZFd4eXhPZjhpRThHbW1tNmpJN2dsNkRo?=
 =?utf-8?B?TFBwaktLSnlETEcvdzk0anU2WHJ1Qlh0R2NtdDRhMTd4NVFxT0E4SEp5TkJM?=
 =?utf-8?B?QjBxTEhNNkt1YStuNHpWSjdpZ3hFRHZ2em1nSUp5TjdkQWoxc2kxN0JUMWl1?=
 =?utf-8?B?TWR5UWIzbDBEakR0RXFDZHdWZjBLMndmNmFDMjlzT1ZoekFjTVNBWkRtdjhM?=
 =?utf-8?B?VC9UcWprKzNqenNSdGN1L0lPelBZaU5SV2x4NUlkQlpVOHQ1b2tMWXcxYlM0?=
 =?utf-8?B?NnJ6VUx3S3lsTDI3UjR6OFlRSFpjQVZjT3ZBTUdyNFdpSVl3MFhXRUtta2s1?=
 =?utf-8?B?eVh5dFFkL2RvaXViTm96VmtXTjRwdnVKWHFaQVluYm1YdnRhVklUZlB4b0dF?=
 =?utf-8?B?ZGxxZmcyZzBiNHdiWnV2dXUvYW01MFZtZ0srZkllUGJrTVE3WCtwUS9jT3hP?=
 =?utf-8?B?VkdaLzQrTXpZRmVpQWU1STJMZWNvOVNsUnlrVGxwYTRXclNLaUswa0NaNGF0?=
 =?utf-8?B?dTVublc1MkZZZC9lSW5mVTBIN0pzUWZQQ3phcVhPM2FVVDYvdjVJS1VSVmha?=
 =?utf-8?Q?EWieqHt9q3U9RIwg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZYZPEjT3FVWBBr2nHIzsTBMSBovZBSTj1spV87NDmR33YTWpiwjFkhuJ/kyGCWKgbolQeqCaC7wNu43H623XoADYdY3s+8NtXeix+K1wPbPtGVx4V+r6nEL2O+g1my+Gpl2gE5y240LtA3ITkW5b+cy6E9lidB0O0ej2JbeFnOrTofds4bQQ/WtjBQxddkp41jIaMbZ7sjY7e9X8IRgQSdeFUc2VcDu0TYjcaQel+eLH2aZWql0D8naM0363pN5vQJCv9hE2Ni1XHvSUNRUw9WRXoAIDtQvTil/xg1Ql6Bc+WbS4JorPoMxBLHVWlo2fqYCHY3jFAawMYm1LbFbDTDanVnskG5eqe6RaukX0QY8H6kb5eznppe99FqWND9iy2/HxUMjYFFSa//QTxeUL9ETkO1b7U8YVNnox5rRkTcEuryPPjCw1A0vmV6qNGxPnpECwBXYAUYUrfuiunH262TMEqC9MpSyIeGkovoBXUyGO0lIc3GWl+HdkFL4gaqgn9dSUA5T0szOlKc4WRD2mN6t3hmZknhO8/jJ0EsLvA6ctGdacRYsDFHlYGdkISNvL/Gr1WbOq/TQ0DpU6/NhTwLlle/v8kRI1/+Zr3NbBinA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a323de-0713-44dc-a4df-08de55816249
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 04:32:12.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbDq7GTJbpJfHmuBKEDHN2F0XFZcSg3/VfL7D4DItL8nbuA1Sl0J+G4TkE/0u0yuLagdiNtFASWj8Kp0FbgyD9I5anpZSt4NpFesxWcvAsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNCBTYWx0ZWRfXyhNBWD5DMDRA
 m8MjwSpY2/doZR+zET6C+tFtezEzdwnWifjfw7ftUdd67dt921EgePdWByQktup4Gm8gyc87zSw
 RDybTqWl6SMaxLv+DiuutWMp+p+2r+Nx7K57mKdwPFM/0FO2zTYjFerYZG5CUEwe+tuhoLXvdfn
 wHt0lm5NTlBH8eVi9FXYfDcaDJc0x09XPnVOE/Iy2LPof7Rtp/u6XHD29pAhhdQhM03lVfk3b5b
 K69Po6/ZEr4K75G86DSiJjs6Oh3udAg/7L27RS4rtvSqxAqjknxaL/5aq4YYjaWkqHje4nGW5PS
 NhEUvUg0L40gzGrzZB36khno2pyoLTgap21sRo6MJsc/VoBwuI4hM43tfCTXsPAe4nhnd/MtCGr
 Akm8qyTBC44l9u+5Y1Rtk02+W1MQYaWFO7LH22Pf6KhHR5PFqkUmtOrkSo/rNkXsm5b7avPCzir
 JiOyd2kMlBGO/zG8rgznhJzNuzC5Uji84zMo5Khs=
X-Proofpoint-GUID: 2eFR4H3A4kdBL21_B-QPDCaKBR1SkU3L
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=696b10d0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M_hiSE_5Lp4bEEZJVFQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: 2eFR4H3A4kdBL21_B-QPDCaKBR1SkU3L


Bart,

> Most but not all .queuecommand() implementations return a
> SCSI_MLQUEUE_* constant. This affects code readability: in order to
> understand what happens if a .queuecommand() function returns a value
> that is not a SCSI_MLQUEUE_* constant, one has to read the
> scsi_dispatch_cmd() implementation and check how other values are
> handled. Hence this patch series that changes the return type of the
> .queuecommand() callback and also of the implementations of this
> callback.

In file included from drivers/scsi/pcmcia/aha152x_core.c:3:
./drivers/scsi/aha152x.c:927:28: error: return type is an incomplete type
  927 | static enum scsi_qc_status aha152x_internal_queue(struct scsi_cmnd =
*SCpnt,
      |                            ^~~~~~~~~~~~~~~~~~~~~~
In file included from ./drivers/scsi/aha152x.c:247:
./drivers/scsi/aha152x.c: In function =E2=80=98aha152x_internal_queue=E2=80=
=99:
./include/scsi/scsi.h:111:34: error: =E2=80=98return=E2=80=99 with a value,=
 in function returning void [-Wreturn-mismatch]
[...]

--=20
Martin K. Petersen
