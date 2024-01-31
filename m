Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3A2748A
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668670; cv=fail; b=KIsMSvurds13+GSadxl8ZTkJZobh8yW28B5zyKQII0uHLnwQ/nwolNJpZeGg29lFL4w2KBTivGQ4ZXuufoINSu3/KmIJfdCta61uTWsSq2gZZlRmNbH80e50Wapv3tJ2hb7XPR1zXs6sIBc7kOAj0bzjqirjfmGaHVRr3AKgbDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668670; c=relaxed/simple;
	bh=EBwEC32WGvSS13NDzSF0kZjFwFfRhayA0+Nbo3HX4io=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CwvjKBjDKR/ZROEttaux7l/vE6ozbIdyak/xqgWn1z2v+fbsYu4+FCaqgmw+R5vxphB40kXY7+YsFOhzIAo18pyPLFu2MrhsUDDDxB0EyvFo1FDkt/PMgIUm6Oat5sBxwvWUlAGydjOzrAGTzXN9uTLBNQs/DUPYQ6a6Cz4vBPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ToVB6H+b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lI2niZ7A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ToVB6H+b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lI2niZ7A"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx2aR017147;
	Wed, 31 Jan 2024 02:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iXFH3IBDa3I8ut4wqCm+rouS1T2Eu7Q8ZV/9GdDWHsU=;
 b=ToVB6H+bB9EduYUxxDVgsf9+1LOw6ZY3457iOHqZJ/Q8L5UCvs4IIcZ+yjSa0DqFy0lD
 aAgdDRwLWkoWqQ/RuwfZK3rseGoqc30WK3O2/0SH9FfcYW/cNkoNlG3XpW9B70w33XRs
 ot84YEOoVUyHxCNxMDthQVGVih23yYocFKsV8ZrnANRp3lscoeAVLN9s2JmDH+GJqYuj
 GVbrkdzVlfuPy4lLD7aBxkgL56R283qwRp/vq8HwF5gPZXxqDutIshCiEgnXhMtDZU2z
 JCkr3XgsA88jfabc5OWR5YryPN9IzsjxJ1im82PNIpQ1+1wexfUNoi8su/ZF+oxr2XfA Kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsvdrn0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:37:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V13BHV040106;
	Wed, 31 Jan 2024 02:37:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98cjw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aB9H18JTYkqwtiApCZpRVZhiMlU3n9z9qaknEveTEZf9whoxdVQObmmVjFCk+Assqaui0UXkvc4GIbwQIoe6RIiOKarlHFBbqoDE36nmS3spJrgS3mPCFpYwfMyUj+144EkgPFrLHW2hS2f48rBRVsgnLEmXD/nqogMTgCwBTuqzpYOHAV9UWjDGRHxFRvIqnT0jXy282SK0e5EMCr0BqKPvrnpV6TmegzJrvcD7B6NkXPKuCklpIC3Lq7KcXc5tFGToFbuPBKJJkb6jYiUSW2qEJhH4aAIiNx9hIAHQm65RbarOhkXSVPEy1Iz3K9ud+dh+xBbGWNIZ5WkL0wv3PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXFH3IBDa3I8ut4wqCm+rouS1T2Eu7Q8ZV/9GdDWHsU=;
 b=OlPacHr2wCFVRQEByzQeTciKm5sNVVA9pYGStRy4LbzQxI19PPP0ocN31vE+ppoItagT8PdHO9fX4/A7KCdUfsm0Y02j7aIQAZx0o9q2+9YoyRRMtsbf+UpqyCyZ/O3QyUzFFSEyOsglnza/WIV8hUIkMpJddmEwzimcMGnFZ8ueZ5MO5YgysHjIpYfe8tyDU/a4uoN38ScnozesxkSVf2GYSP54jkQ2tnmUq2zW1kZg9mz6fxa8/phM8KmRC3ExL7y45BAI8lmVYHnmsgUfAusPE6tzUcRzolmABC5Wvrt2vZg+pDdhDzYYTt3mjBFDqMHP0yaA0NAIMxt/29tCYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXFH3IBDa3I8ut4wqCm+rouS1T2Eu7Q8ZV/9GdDWHsU=;
 b=lI2niZ7Ai3toE29iHacJRXnrxBrb23TVukd6aqUuUtu7UGLnKetuC5x2Dzd1lebcLF5KGPyZFUywDd1ZIe8J8SvMnshygJ5wK5sVA951L+oXyBGe5D6BcEm4SZSqyZGjmPUGnxCP4kTPW+Z+UDiGhiRdEjTqPK7ZKgOtZrInvhs=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:37:43 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:37:43 +0000
Message-ID: <cbf959b2-e088-4b23-9466-120512917912@oracle.com>
Date: Tue, 30 Jan 2024 18:37:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] lpfc: Fix failure to delete vports when discovery
 is in progress
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-8-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-8-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cac3c74-f00c-450c-1c3a-08dc220599d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HbsVSSE3kd3qwEqW0yh1F8+4wezIUMBoM7o9uZkPcS5F9Lcm4Xy0cGivZFPRM7WEH7YdpcP16QvDw1I1GvjHiC9jO4BR7iKlkenEHrBcaPHfEVHDG/sasX0bk4AKl/iO6ICNYv+VzU/PJdSy4ZGiKPLQ/HvhW5QzdtGsEGfJeXzz1PtNd8mE+F++Xrug8dmG0uJtrQKWS56c7IDvczLCPWINdj6GJOG8ggPIPB7DqH+aMkYwX1tNJuwb2xvFo0M0zDWf0gtsUmyyq/om4/nR4T+CwDhMMRfTla9KKoARLWlWPi+HgMUPgKUDWXKZEjlH73TpKngolmshWFGJLu1ci2nHIO55Pp+7bB7Yak8QR1DTTuIAIWph790VyRDDh0PyVquoKqo4BtS6rikIvl2LgmBIunYTlBWrh6dXhHYdclaq34lYtW75g92NPa3ILygTw+KrRmMmmcPTp3qF9p8DvbdzLHD4An42WMbjxl9G8vGrg3pE0ElDrv9K+J5D9NnNUsrZkPqF8NpIENxABN5d2z63qVkHfm8CuYULw63KHOCNhSPKW1JnrMHO8foFBEzev+hg1wRuxhM2GbenSegoiFbGG/N1r/VHZung1ytpEb0C/F3EIw8EBCsk087vOTeY8t2d/lGM8iJJ/mNU0I74Yw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Qm1EaGJUWDZIclhiTnJRdDc2YVFxaTlDVC9OUHVFWUVIWElBbHdGdXpyVDQy?=
 =?utf-8?B?a09xV2xVNlJoWllhai9TRG1DbHFxU0xRVjNrVitYM253VURCK05BN3IwdDdT?=
 =?utf-8?B?MTBrekwvQkZlU3dNTDB2WFMwRVltZFR4aHNSd0pPQXZwdlpQWGw1Nnpaak5M?=
 =?utf-8?B?QjBTVE5mb1A5TUpRcmkzR2VRQ3NZSXI3V3cvSDdZYjNqWEMxc0FBNXNkc0ND?=
 =?utf-8?B?NDBZWStUdDcveDBNWDdHZE1WVzVXOWdydkhNVVdKbVFTMEtSSWJodGcrRHEr?=
 =?utf-8?B?Ull3RXlkQnhzYlZ0RExPZTEzZE5QdHJtSFlhRmExSW9Fa0s2U20xSDVZUkZI?=
 =?utf-8?B?andNSFpTZmFtbHlwRTdiRGZ3NUt0ZUZRK29uTGh3aEt3cU0zVnNiNjZDRllJ?=
 =?utf-8?B?dDV4eldJRlZjaHliLzhNTGNtS3lvaENnckk5STdyam0vS2t1bSt3QWlFa1B5?=
 =?utf-8?B?K1ZnMndGQ25BRWZnSWZraHJqLzlRdW9yQTVOOHJCZnBnYW1yUFJuR0hKcExS?=
 =?utf-8?B?Rk96KzRYZHR2bkhid29aZTN0TUUwa3BhcnlKVWlWaHMxYXVsM0owUUJ5bTYz?=
 =?utf-8?B?SXoxcWtKNlcrbW5nWWExTEp6eGhGL3lrUTRyZzc2eTZDMlQ4OWo0ZHRzOEl4?=
 =?utf-8?B?Zi8zZnFWa0paZnVQR0x4ZDNqK2Y2amk5TkhIQWR1MWI4Ri9CalcxRjN6ekM1?=
 =?utf-8?B?b3NZNWlJRWFYYytNUGhhczRpN1h3aXpzcE90cUFDSXFsMGtOK204eTdjbkpB?=
 =?utf-8?B?dVlzUzQ4cm9uYnVXektpYmcza1cweEpyb09GK1hndnM2dnV0c0M1d2YvMk53?=
 =?utf-8?B?RExGczJMcm15UVJoUEpFM3FJS1ZDdjhMY0pMaWkyOEgxVHhrWlBLTEEyK3ZB?=
 =?utf-8?B?M1B2RWMrODVvNDFQVytQcVcwYzQyY1RJSmliSzRsRlVYdVIrTDY0QzY1OU80?=
 =?utf-8?B?KzJ6RkIyR1czaWF2ZmR3YW5FYnFkREJHcjdHUm5WdkZRY0FuS1dtZER0bFA0?=
 =?utf-8?B?bzZTMUQreTZJa1JZVExFR1Z0SEJORStKaFZtUEsreThDMUtudThUeDlvTW12?=
 =?utf-8?B?b3NzUmJ3aG1VZW5VcElwNzA3NFp2d1JPb0J3WjUvZGFhM3VEOTBqYS93cVg2?=
 =?utf-8?B?WGtybEtodVFUV05hL2syL2taM2NNN0UzK2NyR2N5K0YvNEZhcWhRNnpKbUcr?=
 =?utf-8?B?cmMwR0dkZW1xdDlkM0VtR3RRMEk3eU11ekRROGhpR2ZQRndYMGZmdHdvWERl?=
 =?utf-8?B?SHlnZ3duWkZ3THJpU0FmUFoyNDAvT0ZmYzM1ZDIzam5vVXhybXFkWk95SHhH?=
 =?utf-8?B?bE1NRVhFT1hvdGwxSVhLdGVLamdnOTRaZ2NhcklXMURMWEFjOUo4aTY4eEVL?=
 =?utf-8?B?Q1Q0Y2UwQ29HdUF3dFFVK2JKNHQ2cXRmdTcybE4rbFdQWEVreTRYZnhoaHJ6?=
 =?utf-8?B?aUVOeHBBeWZ2OXJWL1M0WE9VZ010YUZwdnFFT09RMVBYeGMwTTRqR2N6dXow?=
 =?utf-8?B?cnppbDlUbUFPTWlFQlR5NWhXYXJ1Und0Qy9HTnJIbzk1blNHZmRqNzJGV3dC?=
 =?utf-8?B?YTd0R3IyaU1FWm1VOTY2ZTVXbFJGek5UZ1hzY1luUzk4ck9SQXFxYWlqQmNU?=
 =?utf-8?B?bFNLMmNhNTJieFQxbDd3czQwczNMUmpnOHhiZ3dCMXA0SnhsZkJGRCtkYkJa?=
 =?utf-8?B?dHhQQlFsNzZ5QXo1bWxJT0Y2NlJTdkFhaFZrUTlsNEV2Mys1TkJuZkpJaWxP?=
 =?utf-8?B?S3FjbzdlTnAyOUlGZlh3N2g2ZEhyeHAydXE4bHdIR1I1QmI1aWRBQTBBN05M?=
 =?utf-8?B?SjZnU2NPRHRkSmNNbFh6NjBlY3M0NXlUVk9PaVVRUlkvZ2ZnazhtQnhUakVG?=
 =?utf-8?B?TXZpeG1UcWxZZStHS2UwajZCUDNnRmUzek5VbjM0Qm1sblFJQi9jL3F1RTJG?=
 =?utf-8?B?M1FrR1NzQlZEMFlxdHR4amhZb2FnaThzdVo4cmpDTUY1M1ArK29TTHZtekI3?=
 =?utf-8?B?dEpIWXc3RklnYVpKdGY0TTE3Ny9WaWEwVHR0Um9ROE5XSzdVUEVsWXR2eEc3?=
 =?utf-8?B?Sjdtc2ZPV3RGZHBlSjlRRlVTblp3OHZWaExJZVYzYUIrZURCMnFSeDdndXVJ?=
 =?utf-8?B?OG1ZSWZoT3NIU09BN3dSVEszeWhuQ3pEM0c2L2I0bjQrVU4zbUtBN0tJVGhU?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KnBEGDHWZv+GsvgoDlh3N73k7POFbK8Yhau0IQdznTQ9tJbelYMRNhYxhBaP0zaG8c4KpJ+Q7BEsarMVPFHsQXsqFPNHz1WOL24ESGFJA44EkrIf9kcKqF+WZsdZ0U0HVygzCW1xOo9H7LqG0sBnSUxKMRRUFKHkIfDhraQsP4TJNPUnWMvRL1H3Qj0yXYTWz90POWywjgBQrQJ0FC5kZDJF8GCnzLs6SzNRZLDcspewILjurUlgXtI4IycW9wXnizwceK1m5+nGaXXMrgKpP0rxjZWKOB2fzsqsveyclphZiaqStOf267aLyTqSln5ZOMrl1BbEbiM0bPM2bvtHhp1sdIIiB/xv67QM0Ytebnr/XxqNjKvwCjHrGNKPuXCq56eOIirjg5iX/RjLbtvpiGierYxG+sVo58/5xWFIWGlVEy82NBquBxQHH3JPcQHpE//Qpkg0ZCn29pn2q0EsOkYi49OI0CaSMaqADPk2U58uIh0SVwvrokbhpEpHXYT+Q6R+faf50Xx3TUzvKg4V+9S6I7NybDLKTMm2ULqJgA3CPlX7m/DhWmdACPk1Uzp3QA4OGz83M8cfoGGTnYytrLoDoYcYdjclDxQQ5S1V0s0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cac3c74-f00c-450c-1c3a-08dc220599d0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:37:43.1935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2nrdIkdPSsMGLzL8wVpttwHY5gy7wMse849X1s9eCUzTxcL24pT10uCnQa2B89mWFyFgayY6sKVK2fvB0tiUAwVBDcH9J3mMcfqOy+Ho2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-ORIG-GUID: hjv-0hk6sWwX2_qZQYeNNVFOQolPWmAo
X-Proofpoint-GUID: hjv-0hk6sWwX2_qZQYeNNVFOQolPWmAo



On 1/30/24 16:35, Justin Tee wrote:
> Requests to delete an NPIV port may fail repeatedly if the initial request
> is received during discovery.
> 
> If the FC_UNLOADING load_flag is set, then skip CT response processing for
> the physical port.  This allows discovery processing for other lpfc_vport
> objects to reach their cmpl routines before deleting the vport.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_ct.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index baae1f8279e0..315db836404a 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -943,8 +943,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>   		goto out;
>   	}
>   
> -	/* Don't bother processing response if vport is being torn down. */
> -	if (vport->load_flag & FC_UNLOADING) {
> +	/* Skip processing response on pport if unloading */
> +	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
>   		if (vport->fc_flag & FC_RSCN_MODE)
>   			lpfc_els_flush_rscn(vport);
>   		goto out;
> @@ -1166,8 +1166,8 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>   		goto out;
>   	}
>   
> -	/* Don't bother processing response if vport is being torn down. */
> -	if (vport->load_flag & FC_UNLOADING) {
> +	/* Skip processing response on pport if unloading */
> +	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
>   		if (vport->fc_flag & FC_RSCN_MODE)
>   			lpfc_els_flush_rscn(vport);
>   		goto out;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
