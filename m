Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7389C13473A;
	Thu, 15 Feb 2024 16:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015338; cv=fail; b=NCKp6BirZyqTyWRqmYhKzUmD0bKXKbk5Q0phlxIjKEdgDLq2S5Ywiqp/HcwJhPm9bQ5shPCuNdeDKp2V177h9w1Hp0hNovucxNdwzm7ooDo7g5sW5VjBnYDugv/dsdxJ4pm1K8Ayo/FeWgoyiraDDrgIq8g89BamA448RdCbdXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015338; c=relaxed/simple;
	bh=gsGxDXDZIaII0oDhXl3sUGeFRB3IkD9X2zy31ngct/k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LU+pfOA8DIxFwF1U+n8uaVbiHNDcjUyYrgM/ifM9WLiGucD7ycotNLYfTTpPRF8aXIKwrKwiU1XWGLp0yr+jpKdPdX5wL6iO6E0MHkHaDd5OdzOyTaBWbDjN6lkM5Zh3exnwjvJB1bUJB3A8mIxcXI7IDh5bxsNJV50VXfQaifQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bYHxPz/E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RhOA6WgY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bYHxPz/E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RhOA6WgY"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFT5Lf022519;
	Thu, 15 Feb 2024 16:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=aNdwuHJLuvFhX8cjE/Mnp1eupoYBlxSQgb+4KzFZrpY=;
 b=bYHxPz/EkaVmNUwHiG1cT4S7nVtPc4xUoOt1ylKMCS7HhLIm4NxX4sS28bxX2aVvWdtV
 bKGGRtpGTuBPWst2JJmgLNVbVJ51hvHdm18xwXmPqjr+HBPwtge+ZkImKKeWaHmEK0Ux
 2tgKNdZC+MBcE3BOadckZ2+jBWq0wasntBjZ7zy3NmTXHGgrmWoFanbKFAEgwC7LereN
 4ImEe+U7RNFDIlH4dtAZgN8WB5oWHl2Y+qxM0uSUSDzoosKxMEKHJXQA6jIm/D7WywQi
 RJbWRgszvVulBrHtzlXWAxjGX7wQ9+8TOa34uM1lBgHsbk9VsocweQnhfs8xUznjRFTZ 5A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92db2pr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:42:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFq3oX031493;
	Thu, 15 Feb 2024 16:42:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykas87f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WK6uwVlP1yCZQaYq9rnUIuvyw8H7avBzpv2HsWtRUvHaJn2s/EKihszrID6FCdAiiXpH1AgpuYs9LlMBfNafs5f0ureJyZ4q8wO2Z3UUZRRvI/vVL/6G8hsBOF9mI3Rb8wSXYQ+b7zk+1jkJL/kUDPkNj6iPi0scVkWaUJLgbtL4j4uWP3xsk+tHdZ+UTY4MAZACLOzwjtcgVeTsvMO7kC44R/p34CNbwDxn3pJoS3PQYFOHLkoCC50+VAyCjT6aNhV18ufdrvDYh81tIruUqOrmcY+rrhy8U3/+Q9bMrkea5qNCc6AYz8yuSsqRhVMP2VoI3baGETJt5MEP1VQ05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNdwuHJLuvFhX8cjE/Mnp1eupoYBlxSQgb+4KzFZrpY=;
 b=WZ2U+kztBHY4CSy63eTRmMAN7QOJwUQ0JIqra3wXw8/F8Oc/YMCHzqSbCeLpFXzEoYpuVUyb0eJvRBQPGZFS3eVqKB55z0YVt5XzzEdb24Bup5gAIP24U3INJpyIPqLwsN8/1zzWS22BAqaxPZA2AsVAzhKidyfPiJXY1F27jPGUua2CEGin4D8G3hnsTRYPzkpQGQkAtg7+T6XxGEauITc7nKjzWik/NXMNv6LGj3HyUvvInXvebSwgmc1HT5HblCx6tKEzenNS4XwxPHT/Hht7D6ic7n2RD0H5BGPfuWdT9M7zwKNqz1D+DUIhjy9XL92iUbWxv4J1L1xJQyDvIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNdwuHJLuvFhX8cjE/Mnp1eupoYBlxSQgb+4KzFZrpY=;
 b=RhOA6WgYA7OGEW+DFoYgTQAJgtqfk2ejkiXOMdwZSEl5pJhkehy88KfYQ8k2yFQdEKH09uCFyRqMQjf2+ubVNCorec+scCX1imJOEJMTEH/23Y8kEi1eI+ME07qxcd1GviDFNuZRwBGP3cAlmpY+kGhby3x1qrIlgD3jW4OXgSM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Thu, 15 Feb
 2024 16:42:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7292.029; Thu, 15 Feb 2024
 16:42:08 +0000
Message-ID: <69dfb8a5-ef4d-4b38-8b5f-f793166b2c24@oracle.com>
Date: Thu, 15 Feb 2024 10:42:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] target: set the xcopy_wq pointer to NULL after
 free.
Content-Language: en-US
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20240215143944.847184-1-mlombard@redhat.com>
 <20240215143944.847184-3-mlombard@redhat.com>
From: michael.christie@oracle.com
In-Reply-To: <20240215143944.847184-3-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:8:2f::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: d086ceba-e919-49e5-1422-08dc2e450caa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	l0LD3aQELRBQb2v6gPE8QariZSRIE77VUqfw2TF/7Uw2zF5sV/OUhQIp/8S2UbCwiVFmzt8/WwHleuceex3uyaKP3xd7RgnwDh/TQUcINnko1p4EmUdSELvJ/RfXfQC2cgGtBA6V6o0W5+flUtGiCgWds23M1jkfY/EYXxrn4Kjr+hSQX9mGV76UVR9Nro8z6yzUSgEoUp20ryWQENuFJ+ElROCTTDn3B4P+uT53WgGz0UZ0vbfSD8XB/ApsOKxnOFg6sbmEkO97BgGHhyfhYSRkq5M/i89u8kBdRIKRndVZ5YxQlpwUgXl0Pqi9HzmUfYUDmMZpVwJPoqwSPxedxsdLzwG5Up8a+V1j5J826QicI57yX6YRbUgt4Ms9kpPceAVFoziYzlJTJ3kdrfU3NQJ+0sJVQdT9g8jLt25V64OHUVzL2Fd8gKU2rl1ND/6VQrkM2i2KwTC+lWLG22jkqtDXm9gc07Ae7nzge9iFkQK1ELezpcjY/95njkg57LMhdsVhp3xoTaJztTShJIuFKnPEzGJxjGDa6FFYcgdZT5Er15Zbs27G7EHeXNIWS2BU
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(39860400002)(346002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(31696002)(41300700001)(83380400001)(2906002)(316002)(26005)(478600001)(36756003)(6506007)(8676002)(2616005)(6486002)(6512007)(9686003)(66556008)(4744005)(66476007)(8936002)(5660300002)(86362001)(6916009)(53546011)(4326008)(66946007)(38100700002)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RHdmOVlDNU5aNmltaWVrSHJIa3BUcGhiWGlVMkpZcHFxSHdsaEFiamcxcjU2?=
 =?utf-8?B?RjJ3czF1T04xRHJMQnVWYXRvMWZ5b2ROWnVDSlBoV1l6VGtUYnI1UjFnODYw?=
 =?utf-8?B?RXZFSHowRFliMmFNWnVhWWY2VU00SDMvcnY0SW90blg2NjF2K255TjFGc1c3?=
 =?utf-8?B?Q1hQMnJpbGMwbldYbTNaT0dqK1IrdExnZDRDQTdNMnF6K3hldWV5Z2RIRGVR?=
 =?utf-8?B?OG5idzkrWmJJYlZxMjdRZEhlUHZzc1dxcVp6K1cyaUNRd3I4TThiSGg0Z2tp?=
 =?utf-8?B?Y2FvNjF1OW00VHY4UjN5bHFaTzEwWVRveGd4ekJqbGhUN3RuYXJWTXVtdGJG?=
 =?utf-8?B?dWhTVjFQaUd5L0VDeDQvTnVWaUVmUWxEVzlUZ0QwREVGY0piY1JCNWRsOVVH?=
 =?utf-8?B?cFFnYVl1VStWb3kvTXl1WG9PQmpzREFRQ0lpQ1BsMGJ2N2RFTHRadTRVeEVa?=
 =?utf-8?B?cFdKcmVUKzJ0Y09lcU5weW0vbG5hUFBXbTlSam5vM0ZOY1lkSG5zK3QzUCsy?=
 =?utf-8?B?cHU2SkNqR3MwZDlKdlllK3kyeldydEhwNU5aV3ZVaGplMUhKQzlXTU91ZVo2?=
 =?utf-8?B?YzRXaHA1SjREQ0dxUXNBc3o0REhmQW9jaEtyRlY4UXI0OVR6Szd1S21ocncw?=
 =?utf-8?B?SXFQcndCZHhGWWU3TVdLeHVsZmdsYmtaY0dCVTUxQzhSWmU4THpuNmZFaXVo?=
 =?utf-8?B?OExrOXlGekZJclhFOC9NYU1BZXhDbC9EekVxK0pwZDlkb3pwbXdHMUFFNG1z?=
 =?utf-8?B?ZnRvckZPMG9WQ2grd3BkVWtqaWpWQkVFd3piSXkzU1hzcTBoVkpKRW5Jcnlh?=
 =?utf-8?B?VTR0Q01ncEM1Q1loMGNhSVArdytib1RSeGRtY213SW5yTmxCV3hBbmtoR0V3?=
 =?utf-8?B?R3ZIdEY4eXZ6ZlFPL21wS2tjOEVYSWJCZWx6amFaOWRRem1sbG0zcDI5cG5U?=
 =?utf-8?B?K0JiVjRMNno1YndHd0l6OTVGM3RRQWl5YlR6L1grOFpUbGR0bEFuUWU5VEJO?=
 =?utf-8?B?SnU3dHFLMnk4U214dVhSS3Q0bTZCVzNzUUJXRnRHVjlabTg4Zmg3N1JibVBC?=
 =?utf-8?B?TnJCd0xIM3YzRkVtSDB3QkxZeXZCcTkxV3ExWWJldExLTi8rSHE4c2NZd1Np?=
 =?utf-8?B?Y0VZdzF2TXlWdVJPWVprOG5aU0JEK3IzdWU5QUxhaHpxSmJoamVZVE1qMkxE?=
 =?utf-8?B?NFNYRWN4QXhsSFFEUktEYm9NYTB5bmRyd3BqMTNWNGkwY2puYlpzL05oL3pr?=
 =?utf-8?B?Rk5hWFQ4MFJQQUord1c5bUtTbTc0b1c1Z0VGdG1zWmIvcmlwRjBNdXlmT3Ux?=
 =?utf-8?B?cVg4SGRmbTNKWTJkbkN4OUQxazZDNjY2Y3JoZUFzWG5hSFRmOGl2Qm9DOWxP?=
 =?utf-8?B?UVVZei9KdzRaVlFvZ0Q1K1dPVHp0TmQ2R3lBZVA0SDM4bUtmMVZ0amx4SzVh?=
 =?utf-8?B?WjJ2VCtzVU1NRHNTL3NUZzEvQjJOOVBvU2E0RDJkU0hQU1FTT25aSERIelkv?=
 =?utf-8?B?QUh1NzY1MUJlNGdMcDErYzlwSmh6d3hYbmpRV21MVS82VlRYWXc4WG1FUllq?=
 =?utf-8?B?SUorQVEyOEl4YitHclZGWHYrdVJiYlU5VTlPWlBEanE2VS9QZ09rMmxZQnVn?=
 =?utf-8?B?eitTUVFWMnhKVmtNdjAxVVBmSXZPRVFuYUJPUkFpZ2F0Yk0rc2tGRFpKN1lw?=
 =?utf-8?B?VzhTU1ZCajk5SGRibHBqaGdEQ0VxYXFqcW5mVzhPaFc1TjFFYzBaMTh4dVNW?=
 =?utf-8?B?NVArRUlnc1hINnN1SFlzTlRISjdZYnFQMlFpbXpEcTU2aTRIWmtWeWZ0cVFs?=
 =?utf-8?B?RUFzSGdMMVRvbXlaMHBSdk1YeVgrN0JreXZ3a3FNZHR0OGIzMmg1UmVPRDhu?=
 =?utf-8?B?eDErb3VXbjRNaksxbC9QVm5BRms2aFBlby9MT1QwWlBlTnlQSDhBOUxiQjUv?=
 =?utf-8?B?K2k5NEhIcTJrbTZKRlpTZW1UVWFPZjRnS01kTjJHcVFkQ0NicE5PcGtxVW4w?=
 =?utf-8?B?YzZyQnhHbXNQdXZtNzlXaGxLTm5kaXZzYVZzcWRUK3VXWFpGdjhPR3RLdlhV?=
 =?utf-8?B?aWFGYzZKbXdhZWFWMlNoYWlhL1kxOVdqZWxLWWZWeFRuS2tHc3haRi9Ob1hy?=
 =?utf-8?B?RWowTWRYNE5ucWk3NUVHcUpvbWd0Y0l3bWx6Y29xZ0pWY1RXSElNb3VqMi91?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NF2dnp/PQnd2h3ocWz6i717GrkalA+89y/OPF+rkb2IgSR9jQwyvPTdFyZoSbHeLd/thWPpCr2yYX3gEPupVl5YMFYGDIlBghGqX+OUvvOZHQlxTzQaKMH73zQu0s2eJn3hcHAJjWBqZxbLDqdNWDIDevg+vWuQhUZTZYI2cRDbiJ60Lk+dcZgo7MJkMOe57eW+1MVKLDj94XccM49Xw0Hw8IopWM3QmN8hTMEjpB76c28tCdNHcM+Daa5doNB97/UzOmQu5GeJ+MooSVq+fM+54Ia0u5r9DSu3X6wsCv9Q2QYHMMIeCYlCpczy3TbBKMWqSnnDU194H0oNZC23ecjzSz7lFtTf7gdYl3cu8CrbfMfomMIvl8V8JCZk86xZnYJGrK92N418fIPuhvhO6VtFXgGdClE3NAkUtaa6s5Ja4MpQAHWhG79fKL2GouZbvLPpwLnhZiXT0SYnD6S9hP831forkcuQS52IBc5OFIT+cEo7UrhyOkgcteGE8TmLjXmukdUywGPrahIhNFm7OViLwd2heNJMd283mdxrg4051tCgeIb8crZn7enQ88VG4V+vqLo5TBdKdpWU+mmGkx30Zq/m8BeWUfAP3MgtlzY8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d086ceba-e919-49e5-1422-08dc2e450caa
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 16:42:08.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lET36ZAbCGadN56xatq4DfUROixrXcoyDeN4d8oDyN31TjdNjFivE7FoF2umhvWp1e5vNkqs7yXQyXmc6YimZz8dMCstSeZlvwKy2ld+A9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_15,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150134
X-Proofpoint-GUID: AWOZR_Fmmxw6Ur0-V5rnTubYN6BsFyHc
X-Proofpoint-ORIG-GUID: AWOZR_Fmmxw6Ur0-V5rnTubYN6BsFyHc

On 2/15/24 8:39 AM, Maurizio Lombardi wrote:
> Do not leave a dangling pointer after free.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_xcopy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index 4128631c9dfd..1f79da0041e3 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -491,8 +491,10 @@ int target_xcopy_setup_pt(void)
>  
>  void target_xcopy_release_pt(void)
>  {
> -	if (xcopy_wq)
> +	if (xcopy_wq) {
>  		destroy_workqueue(xcopy_wq);
> +		xcopy_wq = NULL;
> +	}
>  }
>  

Why do you need this? Isn't this only called when the module is unloaded?

We don't normally do this for that type of case in general. In the target
code alone we have lots of places we don't do this.

