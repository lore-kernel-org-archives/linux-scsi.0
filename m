Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3660F2DFA4E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2025 07:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744787842; cv=fail; b=n2v+cORspVcpxpWMb3Z2oqkr/Cz7iMvZ3uZav9UtmPbFzyC2u4gj3go0pQNdiwIPYZaivQ5fJHErepktvN8rHeSIDPyOmV1aB5SBwc7emX7owX9Ou9ZgceYsM/bp67FPGhFNR1z5CNaMX8chRV3iP9edS0wkUyfHF6e0pvt4ZCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744787842; c=relaxed/simple;
	bh=BIZCtj+TvaLr55yBfx0vQgxS1JPGM1oFaHvYUWaVPlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=St5fMNwWCrJouH8Q+azVi7Gh1K7SratzA4w4ifKDx8bxBnm7Jfv29VtlKfFRg+fvSz9yqfQfsEdfOgbVwclb8cagc4AD2RqwyfPcnGtYqLvqIO+QdWyn9KW1RmA8jsDglmgatuvvhUuoPdi9wQxvX9x52Og39x0JggcTtRnRHI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cGjAEMSL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DkLHinWS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGjAEMSL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DkLHinWS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53FMMojw003094;
	Wed, 16 Apr 2025 07:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XvrAPFeVD/4W9CVWPSeiEK9HuN3olCF/X5C3mlKSf5Y=; b=
	cGjAEMSL10X6x9M6ouBWZ4BU2NxSCt2wrVxgku4WV+eBmlxai8FbW2Z6mRSpTcqi
	kgrh4SXcXvRSnhOn+BPJdQcTrMu78ZKh+CWIhagQySuUNyw53ym2oH2AlVeNgKrr
	lfLpVUypL7JpNBA1GO6zXCUnnCPBiL++35xurTkQHFcTmZ7cJDYLIZHN3j/ckCiS
	ub7S5DK2GuKTWUrjwefr0JtztGrepNp9I+awpBOf3/HOclceJipaLhUcZfUps2P3
	+vfqZEsSJAcfSuLEqeie72BXeaFyxXllmHvV92/9i+mzpYgkwlOvbYzGfAwha7rA
	ZEN5l7o3Neb1V0vvIkXICw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46187xubu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:17:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53G6n1RX005671;
	Wed, 16 Apr 2025 07:17:01 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013075.outbound.protection.outlook.com [40.93.6.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5wef6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:17:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfaphJzo2HdVeFz+t89GeXc9PGTE6DdHyG9h/ckGe3I0w3C4hdPUDclUI0Ow2uAN75Sc+c7d+mf+u1QpnuHAs0PgrjXi1M1kW/JxMK+/Z8HESF7WZ5HMoE9nlPYPouApjLkKU5zmBoGBbU3sCTW6Ky5v+BZCaVacCmLH4MuHXacolZ7ZVFSzC5Q1WBODpssIDb3p2ATiRc8v3V3WhVmNadTdJII4ClDd6tpHIfc4s4apeuQA/e6/l6RckZwCVRAMAkAKBKJIHA1+MRd9lNRbP2TFmXMUxlUIafkQxN8i9ZPTODn0aGo+gOz2GN4DmuhjUP9tdquRBgqt7/gFBKM9Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvrAPFeVD/4W9CVWPSeiEK9HuN3olCF/X5C3mlKSf5Y=;
 b=GsUW6DwZBFRuCWddcPudBfV2O6yPU3s4D2m+zY0cX9QzXQype54q1UPDqVIW7LhVwFNjMNwX04/j3v8384mOKV7fMVjfpaCw07+muC2Vx889EPvJsWOEzG0MWa9593NU1rOGYSoSwyTjEt9ipFsqSOrWWCBpoMWelbdVoagOvejO+qm5nZgMxJJWx1+xVBTUS93r6Wm9fvNftpY4loH8xQzfdjKPAovUbEOqjxRKuLCd545WA6jshI1sElgB46vDCUimUKth26iCNB565KK5q9R3XyIXuUP5d7ZV1XKky119NZON0MTSukoDLFKYeoPu7ubtRcfnDASdPHJszTCmww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvrAPFeVD/4W9CVWPSeiEK9HuN3olCF/X5C3mlKSf5Y=;
 b=DkLHinWSl39xxQls5E2IIXidZIWbP03xDp/oevifwfrfYw6RyMF10FGieLMUUd7ayC5nBSDFUAJ0ZUKo8U8Jx0iT4WReFfdwuanwf+nrLZMPs4lwSszO0TDiTMbOY5Z1YAg3/R3SPxAr4wo+SYCtKzYymJXYL0ADjqIEEfHwRZ4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6592.namprd10.prod.outlook.com (2603:10b6:806:2be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Wed, 16 Apr
 2025 07:16:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 07:16:59 +0000
Message-ID: <d6b35769-e5f7-4174-b581-f6555aec1d4e@oracle.com>
Date: Wed, 16 Apr 2025 08:16:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
 <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
 <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <27e5c0e9-a042-45e3-9852-31adb966b781@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6592:EE_
X-MS-Office365-Filtering-Correlation-Id: c3d17f2c-8730-45d1-5002-08dd7cb6ad7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y05IMDliR1RRR2pHaGJQZXhhMTNSWkFObUhzS0dscFJHWG9jVGxiRm94bUJB?=
 =?utf-8?B?V0pzQzJacVJvL0hJMmJNN2g3L0J1WXptYlNqbzVNMzRDUWJVVDlIbTNPKy80?=
 =?utf-8?B?Y29sMkVHYjhpSWRyYTV3WXQ0eFNkSVBqbVhYSnlPd1NGQ0JmWFJlYzZLMXFX?=
 =?utf-8?B?NHE2cmpKdGlLdG4vTnhKdGJ6YkhRMk5reVh1UVFVVFp0cVRMcndDcHFTV0da?=
 =?utf-8?B?QWIwa2lTR2o1MlVCcmVEeitWdzRhUDh6Q3NGUUZEeWN1dDBRc2FORlVMb1l0?=
 =?utf-8?B?dzRHMlkvOU9uak5qcDR6S3ZVcnBIWDBRS1BKK2g4TkYwd2xqUGlJTUpPVDRa?=
 =?utf-8?B?ODVBTU5CRWdXaDN4M0RZS1lXY0VrWG9qUkJyNHNid3JWeDJwR2pDc0VOblJX?=
 =?utf-8?B?d1JwSkFNTDkwVSt4NDltZDhzRVVNQmNsRUVZanFhaVdhSC9QeGRGWmQ1OFZJ?=
 =?utf-8?B?c1pUSFArK2UvM1l3L3Eyc0VQTG1Ibk1VYmcrVzFjTi9TeTZ2NGpoNGlLVUpD?=
 =?utf-8?B?c3gzVW1RWGpJN2IvZ2VISHdOb3lDSW01TGlMR2dOUi91bHRYUy9iY2xadWRt?=
 =?utf-8?B?MzUyL2cwekpabmhiRlZGaTlTL0o2T0Nsd2o2em1wWHFKVEZoQnpiVHlXNThz?=
 =?utf-8?B?OFpzVkM3aGxucVg4KzFydW9UL0VCNGNPQXAyNFlxcWx2WmNxNE55QUFETEY0?=
 =?utf-8?B?Rm4wNWtsT3AxNHJ2VmFlSjhFK2tUQ0szejNMTjh1bHBsbWhqT3RMWEZwRGRp?=
 =?utf-8?B?RDVlZEpnT0xPUThFaExpcEJuaXZyeC93eEk4VERKZGtiNmJLZ2VKc2piL1hq?=
 =?utf-8?B?RWRwbE5sWUFRN000b3Yrc1p0VzkwNUVsbnpiWjlCaXpFQ1I1akdYSGFON1d3?=
 =?utf-8?B?M3pZWXFvN3JUQkVXbC84TXQ5ZTNhRlRqQVFmYkZlVXlnOVZuaEpjTGczS3Rw?=
 =?utf-8?B?VFo3MTUrYldBaDFHWkZOQndvdEJsNG5ISTdyek1sa01BNWVhMTZzQ0NDbWdD?=
 =?utf-8?B?TFJPZGExeisyQUtoRE5IZm1aMTluOTNKM2ZNZlNvRlk1UUYvWEUrWEc1eEc5?=
 =?utf-8?B?SndObW1TUkEwZG9lM1o1SnROTVRSajNNUkQrcDFRUVY0YmFYaEpBQW5aR1VW?=
 =?utf-8?B?ME1NdTNXY3IxODVPWktJa1VBSWRvbmtyZGZtKy8yMzBneVlmbDFiVmRESHJo?=
 =?utf-8?B?VG9xbUhYSnRaTFNWS3hMeGVqVVZaaGVnSWpFbFhnaXBreEhHTUFpQjFjT2lx?=
 =?utf-8?B?akZIS0dVUHd6eTF3Y0d5YTVZRThRYzd2QnlBSVlLZTRXOGozRS90S3RXNWY0?=
 =?utf-8?B?c1l5VDNGbVc0ejZOeVNSZFBDVUMxRFBvbFNKWnlGK052MW9MbXgrL0trbjN1?=
 =?utf-8?B?QWZtOCtoWjhJN1lmUldZVDhjYmo0ek5UNnVlaWxFaVVCd1JkdFZSL281elp0?=
 =?utf-8?B?eVZsM0l6akxKeDNlbmk4dFU5UTRDUXlBaEtOOWlhTDY5c3VXVTdyaXF3Y0ZD?=
 =?utf-8?B?Z2FKQ0g0czVEbEhZZGFVdU9lV3pRaVI0L1UvTEs2cXpCc0NzTDBrbG5YUnc4?=
 =?utf-8?B?SmRVcHYxZEhneWJySjlaejVXT2RpV2E4NFkzZzFiTldHRitwQW5Md3BjdU53?=
 =?utf-8?B?VnZheWNabWdsSml5cnF6V0l2d3BNd21aZnFJM2g2WkhNV2pTdHUzYll6Q01m?=
 =?utf-8?B?UTUzVVdESmphU0ljTHdIZzlVckQ3b2oxdEJkengxODZOUHkxOGNtT2VZZ1RW?=
 =?utf-8?B?MGlwd0FCcW9mMTJIK0xDdlAybFRIRXJEVFBsSEt1ZXJHcm43Skh1RzBETWF6?=
 =?utf-8?B?ODhDWWFLZVhwdndRMkJnUjlIMVJWVXdzeTJsRG5JYUdKN09WY2JtdHg2NkhE?=
 =?utf-8?B?THZEek1uS05pSmFFSVo5ZjJRblFwcWdIbjQrc3J6TFc5VGxYZkNpTmpyczdL?=
 =?utf-8?Q?VM6v1a0m0fI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVFCVUErbW9uY2xZYU5vM1E4blk5Q3ltejlEZ2ozZkFnSFlTQis0dzhkbG1a?=
 =?utf-8?B?TDg5NXAvUVU0UDU4bUcvWHBxMGkrcmQ2QW0yR2ZoVVl0VDdOYngyZERmUVZD?=
 =?utf-8?B?bXJOZHFFMDdEMTRoUWhuN200U09HQWhaSlRQWkFyM3JHYjhUWVZTUzZPWHhK?=
 =?utf-8?B?Y1drM0p5L05mRXU4ZUlKN3ZHdFVyMkNxK0tpNTgvemZLaEZienlVNXFEclI1?=
 =?utf-8?B?b3YzaC9uQ255aHlyZzBTWDBXbjFrcUF4b2pUckpVQ1N3NkcrdHkvd2NyN3RV?=
 =?utf-8?B?V3JiTm1JVzgvT0RTbEJoMjdqR0xSTkhzYW0yam1GNlcrTDVPb01zRWZjdm1C?=
 =?utf-8?B?QTdFOEkxdU9aYXZTVERpclJXL2VmcVIwSWRnOTNCb05DTXo5Ukt0MnhyZ2hZ?=
 =?utf-8?B?T00zYzV1SjhCS0ZCSUVQQVRWL1UxRmgvb0dhVVBGQXd4STl5MG04bFptRlJZ?=
 =?utf-8?B?VnQvT1NLYnBFdnpZYjM2OGdPckpFTGF0aGpwMy80S1pNVmpGbHJISlBHd3Rl?=
 =?utf-8?B?YW85c1doK3N4TEpUVEl6dlNoUDFaNHpEbjFXbFg4SnBKdm1Mcm0rUldNaDRG?=
 =?utf-8?B?enJ1Nk9BSjZRMU9STi9LWFdoRHFObU12U0xIdmRzNG5PYjVWWmpScWhKRnNM?=
 =?utf-8?B?ejA0RjNlMDFyV2tWWXQ0NXlKR0pzaTZPeHhKV21LWnRyWXRPMTdJQ0VnSjds?=
 =?utf-8?B?UFVoMGJpVFRKSmRoZisrT01nTzI3RDZ3MXYxQjBmN25UV2dFSGVKUUUvV1lI?=
 =?utf-8?B?V05HUWRMMDdJM043UkVNS0pFRDVyMVM2a0NzYW92aWRlQllyOWRVU0xyelpI?=
 =?utf-8?B?L3lUQ1VnVGNQZkhyVGFGT2dVWUpneHpFaUNzZFVuRUZnV0ZBZlYwYzg3UmEv?=
 =?utf-8?B?bEtLd0V1NFNDTm9RVEpQWHJOUjRmNlN4OHBXVTVUcy92bGJoVUV3SG9Xc1Bm?=
 =?utf-8?B?ZncreDRNdWFZUmR6NVBQR2VMS0N2SGlNdldBd0U4SmRHYVh1MkNHMS95dWRM?=
 =?utf-8?B?NGRCOEoyYXptdlcwY2dlUENEK1h2N3BDN29Zc0F6dUxrZEdEV0F6SzBEZVRZ?=
 =?utf-8?B?bC83UVlOQno2cGIzR0cwa2psZWtZVHlFd0dNZE9PblgrK2k1Y0FkYWFYdG9X?=
 =?utf-8?B?V3g5R1VmcEhvREcrVmY1V3Y4VGdObFRRWG51dEMwVzVTcGZnRk9jSUc5RW8v?=
 =?utf-8?B?amk5YTRGaG5qd0dRSkxheWJYbzRReU1TSzdjUG9BZTZHRnRiazJhcVphUU9W?=
 =?utf-8?B?RUc0U3VGSlJzOEZYUUV1QTJLdytOd0Rzd042Zm5ZZHpxMjNMU1FGb1N3UjdU?=
 =?utf-8?B?RC9LMnpmNGlJUmpkaTRoK0g3R2E3ekhLbHJabTJ2Mk1neGxmbkVXQktKeXo0?=
 =?utf-8?B?R3R2Uzc2dmF1WFg3bjJ2TytXd3NldHJOUzFuQU0ycG4wQkl6NGxaRStFbmVE?=
 =?utf-8?B?UmpyT2pDQzdzakFRa3BzNlFqaWUxcUVoWlp4YTRKQ3NjZ2dKSkZWRUk3d1Yw?=
 =?utf-8?B?eHY5VzdROURUQ2dIK1praXlXanRvZS9FTDdaRGN3Sjl1dXRSdzgycDIxd1FR?=
 =?utf-8?B?OTNOcXA3ZXRkN21xTnFRTnVqb2kwTnJIWUl1dkF1YisweVpzanRuNXA0Rk52?=
 =?utf-8?B?WDVyRDFVdExEOHFWcHBtSTJCMC9pVHY4VU40QVZKYkY4SUNNaUxNN0lTZlVY?=
 =?utf-8?B?MXplN3FwZi9vSDU4RlhnQlByQi9VaVMrZmN4OTR1dlB3SVhycVVTYmVuQnZM?=
 =?utf-8?B?QWp0YTJkNEVsWXl2RVpXdk1UTVVraFZweGo3NDBKaFpBR0kxMDdjZWo4L3JR?=
 =?utf-8?B?V0dQRzVVUzZ3ZjNjMGpCZWVKZUxPR1FlVjN4UUhpMVVObm5FSzRKVEEyR2JN?=
 =?utf-8?B?QW43c2h4SUJlSGtXazliQ044MDJvWHhsVlN4N2VMNUQ2ZDA4SjcxZ2ZpL2Fp?=
 =?utf-8?B?blY1eTdsMTZCa1J5K3F1aVkwMGdiOGx5NENXQ2pvZmx3YnlXaFF0Qk05T0tN?=
 =?utf-8?B?Mk14K3Fta1ZGRklrQUdwZFN3UE0zVzNyVzBVMzlpZDNiT2ZmV1NqQi9ZbGxk?=
 =?utf-8?B?S1ZFc093dnFmU0RmcldiTDlraVMwZDJSRUlRNWZ3bDNhY3J0aDVTMncrTUlo?=
 =?utf-8?B?TzBPeSs3RkV6eDUyeWRmRFpvM3Fqa3ZidGlhb0JYUjlPTFRoN3FQVmJ2K0t0?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rkwWViu8PqwrqpmWedMOO1TyS5TFfzlRov45haT8bij+KHC/U/eiautnJFfmmJKd7nSNdvT+hnxnZFEtgHC1CuMMdg8ypj6amS0tI57eJcLvglXqOphvyevveyn3BZuFUjEzGF0+q0EWBtOaQCBkIErnmEbrLgyn1ubEAWFWS+cpiSsBxlQ2p7Uug3s23ROvCh8AP2GCPCZIuT/GOX9E/wdcUCq7/zl7ueuNOB19H5rUHk2epGbFqvSNVx72wHELquX5ENnhsm5WFOsb9szNZQcWGAC3yxrcmslEPReKYCzcPohelAnmZdikwd568FDSFF3x82e/UeyYJjxVPuP4Gy8dFVfbgY7ND+x/fpK9uoJ5AeODjmGPS8lZNJpq/4egt1vPpnmlxgXSIIDStQDtRECURAp3KqnRj6851nQez0MC6iF2B1xDqblKeAm5BT9I2gmOfLtnf0uGGMP60jS+vzwSATUWg4N4E+PhTppTJ9A8l9F+NVOKsDkUpozVn/1i71MbStPSEavOcC9ImdZGilDzBMegJ8K6KBRYdDe0OXQm/BK5HI+XUswKXBAE0IIFZtlkiwWo4tadQ0vyUuETSWoz/NauGgXoyCFwdbLD8f0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d17f2c-8730-45d1-5002-08dd7cb6ad7e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 07:16:59.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbvAZK5PNyCvdQAZARCWCWSuDjRMdSjJ0uwAEL/VH+FWfz5ssfIYRY4tcu9uF5JCphepaXxsTgmyD2TQ/my5Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_02,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160058
X-Proofpoint-GUID: zuvOqlmfmBPFNtPXOdo_fNDH5q8zpUB3
X-Proofpoint-ORIG-GUID: zuvOqlmfmBPFNtPXOdo_fNDH5q8zpUB3

On 15/04/2025 18:21, Bart Van Assche wrote:
> Using blk_mq_tag_to_rq() to translate a tag of a reserved
> request into a request pointer only works after the block layer has
> set tags->rqs[tag_of_reserved_request] first. That pointer is set by
> blk_mq_get_driver_tag(). blk_mq_get_driver_tag() is called by the
> block layer code that submits a request to a block driver. Hence, to
> ensure that blk_mq_get_driver_tag() is called for reserved requests
> the reserved requests would have to pass through scsi_queue_rq().

Ah, yes, we had the same discussion when trying to implement SCSI 
reserved commands previously.

> For reserved requests sdev == NULL as explained in a previous email.

which mail exactly? I could not see any specific mention in this thread.

> There are many statements in the SCSI command submission and completion
> path in which it is assumed that sdev != NULL. I don't think that the
> SCSI maintainer (Martin) would agree with adding "if (sdev)" statements
> in many places in the SCSI core.

Sure, so, IIRC, Hannes solved this by using a shost sdev in 
https://lore.kernel.org/linux-scsi/20211125151048.103910-2-hare@suse.de/

> 
> Letting UFS reserved requests being processed by another function than
> scsi_queue_rq() doesn't seem feasible to me either.

JFYI, I was working on another solution (different to Hannes') which 
allows reserved requests pass through scsi_queue_rq(), but I stopped 
that work when I changed employer.

> Although it is easy
> to create an additional request queue for reserved requests, that
> request queue shares its tag set with the SCSI host and hence also the
> request submission function. From scsi_host.h:
> 
> struct Scsi_Host {
>      struct blk_mq_tag_set    tag_set;
>      [ ... ]
> };
> 
>  From blk-mq.h:
> 
> struct blk_mq_tag_set {
>      const struct blk_mq_ops    *ops;
>      [ ... ]
> };
> 
> Unless someone comes up with an elegant proposal, I will keep the
> approach where ufshcd_tag_to_cmd() handles reserved tags and regular
> tags differently.
> 
> It should be possible to do this without referencing tags->static_rqs[]
> directly from the UFS driver.

I'm not sure how that will look, but my preference is to fully implement 
reserved tags support which can be used by all SCSI LLDs.

Thanks,
John
