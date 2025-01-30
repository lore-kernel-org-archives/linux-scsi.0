Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6400E139B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 09:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738229868; cv=fail; b=mbaNZLjcuDw3K0/PvtMX+1AyQ4P33sHe9SjGTOv2joA3NAfh24YqcCkr/nNVwJ26XorH86GstAbwXlKhuBB5CilPXripJ1cSIjhEVApWCzwdvhJUVL3J3bLbI+KK6ZZNHRHWBDzkvaKXlAhzJH5L9vP03diuBQP/vs0pMzwLuE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738229868; c=relaxed/simple;
	bh=bgbs0ykuFY7IBH6qGMrZs8bt19Cq6vHdoMhBfxxHmEI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NKKaXuDB/bwX1DknIOrSPRDTqTn2ljTtiH1QVZG0APKWSb3uoQPOkn9mDZZwnWE841wFMrE2D6Nyow9wiphxCp01XhHvkJ7FxdF6KnA/MeGboU/OBaAks1hEzhNLbYg21Gj/He93MLYnEc4N1ZDKA53VTJ+ycHw7vsgjyCCTifo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ipPj/Mf9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IB0oIMqf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ipPj/Mf9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IB0oIMqf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U9Lgw7030684;
	Thu, 30 Jan 2025 09:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IMRsexqWQVxd5GyQFft05lfpWe9KWp5qPLPdeOs+lcY=; b=
	ipPj/Mf9iLE3Fd65qrcp/eTOpx6PAS2/LqPi9ibufMKlsWZSzhQ1oraKr34vkRVS
	vtjtj5ZmeR8raYsZwsxWXkLMk+R5Q09GaZlPr7q5ikQlkhX/2VpgV+dxQ4ADsr97
	lnivUrQNzqatpLTWuUBq86k/8984ZmCkChh4WSCRAczf4PKUFVT2stT3pH1HaY2Y
	LCWiAjUI9bA6QsE/AXuCiUPNhZNDAGxyP6aJfXJo9sVSHk+j5zlOF/ZdApLkhyxP
	NmzQu6IQr/d39UREW2C48tkShsUNZScraCrdBDtPOdswXx2SsV43MCSxHbBreSZ+
	59mKrUfiRo4AnCwsPczu4A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44g6qq8190-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:37:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50U86Ud5036170;
	Thu, 30 Jan 2025 09:37:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpdav5vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:37:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXANLEbta+xTkEXMXUSAT544kRHiPOopoNlwKRejOqGBSYWUpqOj6S/PIfaOH/KZVgc68UNSzFAe5PxnesuHPpL9WC0rDg//seQZAnSNxEbsl+oJ8a+KtDHt6FEHfqtqP/RoVHQ6XfMYkx9e13RWYs/F6leGbeO9U02bHZOAnjt+BRgxC2iqbF/8W7nFTy/WAJn/fselEaocVAakyw1ZZmDRUBp40CNbgOpszUm9ZZrC510uYtxSrLhvGRXEuGZlV1NQqmC0MSbPxwaPrA7nBBP891yhJabbmjs/aK+WnciV5xuhE9UK2rQ7eMyZwgSowB61KyPVZD/ZtLKX96W6wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMRsexqWQVxd5GyQFft05lfpWe9KWp5qPLPdeOs+lcY=;
 b=e+7ybRpFMWdGIbychcJY3ZZOkpotM4ZTB76RxRBf0KOQsTE6gdjrxRa7316VH4mTmgTMLhqBMzGtU89CxlNCsmLrOitQqajal0hWphwAOqm7aUKLH74V2LqAyPWEc/i3s64yXPZSGlr9zou0CzpfXoAueg8ydbVOiiuLvgZnvvaC1DTmEtuuRrNFWvYhXGuFT0/cwf7q8kJ109gYr2+vnXtLpqGwLjFd75q9msep5BXX8+G3KrQzcYXxg2a1t5X6pgc3Aic6lgiVjRUOsFbvWQhzSrgy2sw8IYMaEFdDsafjiVzreo81NjOxmOhuq2JFZ6hFEA/bSPw1tTKloX6RBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMRsexqWQVxd5GyQFft05lfpWe9KWp5qPLPdeOs+lcY=;
 b=IB0oIMqfR/ikhVTQPfGM7VOhetImXYpd9ADjyEpznxSp9cnDepTLw8KB8COyO9Iyb8sAVxoCa3fTpwgysbnIzSBH1MMgu/fFyaojomQpYxZaDsfjjabWbCjRIoQ93S86vwLbZRgAXg6n0EcMbIUejgbYqtD4vuxN9kQHEQK0o2Q=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7066.namprd10.prod.outlook.com (2603:10b6:8:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Thu, 30 Jan
 2025 09:37:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8398.018; Thu, 30 Jan 2025
 09:37:38 +0000
Message-ID: <9a8fb5d4-3c36-478a-8376-7af267b7b6fe@oracle.com>
Date: Thu, 30 Jan 2025 09:37:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar Biradar <sagar.biradar@microchip.com>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
        Scott Benesh <Scott.Benesh@microchip.com>,
        Don Brace <Don.Brace@microchip.com>,
        Tom White <Tom.White@microchip.com>,
        Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>
References: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0439.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 4626f534-bd6c-4a7d-55b3-08dd4111bc15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXh0eDY1TG5qSnNWYnM3SDQ2d2pUQTR6bFRQbXlPdy9KYUFJQkt6MDhTYjVh?=
 =?utf-8?B?eStuTDZ5V3lRdU5nbml5THRYUEQ2VE1JVVJLOWR4UXQ4RjdiZHRpZmJtUjlX?=
 =?utf-8?B?WnBwMWhveDZMK21Jd0VtM29HSnBPT1A0VzJzbjVKT1ZKUHFpbFJ5QjEzYThF?=
 =?utf-8?B?VDdhbk9rdzdoaGJ0YXYybENvVEdRRnl1bUdqN2Jnakp0aWpxRnUyeWQrUkor?=
 =?utf-8?B?a0w2RUVJV25SMlJKNXdOUVZpM2VET0k1SzdkN082bVFrK05NbUpCT3JVVVo5?=
 =?utf-8?B?WERNVlNJY1R3L3doUFVDRkgwYWtIRm9WczVJeFJuQ083QXJFQmQzaFMzUjJS?=
 =?utf-8?B?U2JzVGtBaFZ3R2RHd0s2eWg5bjd4NEpiRnlaSE1iQTNmS2V3M1NLdG1SVi8y?=
 =?utf-8?B?SjFNeVpvdnlkaENjanRJazhkSHhmc0ZnTFR1MlNMa2VBNGR2SHdNK21tdkJ5?=
 =?utf-8?B?eGxGR2p4YlJ1RkRwY2Q4S3dqTHhFTWhQOE1aMFA5T0Qwd096WFZzYlFHbXY1?=
 =?utf-8?B?N21wbzBaZERtMlEwZ3RQNGxWc1E4bkw5NU9oNGR0WThOTUM5bzQ0U1IyU29N?=
 =?utf-8?B?ZlY5MHltV29kNzQ2Si9uVjNsNm5ZTlI4TVJBUGQvdldmcXQrRXBmYVE3QjFE?=
 =?utf-8?B?dk5NelFJRGlDSXljaFpzalZKc3pMc3Fkbk55WEJOK3JFUzBlRUMxMkE3Qnhw?=
 =?utf-8?B?V3JSZkR1WGRlNWI2Uzh2OCtuQk1LV1Z4elIwQzJHTmNzNHRaWWpWZitLS0pE?=
 =?utf-8?B?YncxcjdkejN4YzI2dW11K3RyNlhsTzAyQjFMdUdtVml5MFR2dHlCRkVvWlhX?=
 =?utf-8?B?dkVvOGNqcHFpWVprMHdZd0VtMFl4Y0c5MGt0T01sYkxpRnBPUThGazdrWXVO?=
 =?utf-8?B?ZjU3S0dmb3djZyt6Y3hYZ1Q1b1U0YnUyMGlHc2NrOVBJZlU1KzNBdW4zUWZX?=
 =?utf-8?B?RkkrVmdkbTB0Wkp2cWc1M0thYnAwajgxaDdBTFliRW9obVZ2VlNpOWpOdGNo?=
 =?utf-8?B?TDYvWHNxTjA1b1orRm00QkQzM1M0c0xIQy8vUjZ2WCtuQnBFMHRCc2p6ejRD?=
 =?utf-8?B?d2FwcmFwOEhQMmJnOE50WXp0a3VaRXl1ZFV4eE11elFGTXdsYlFsV3JoZWtv?=
 =?utf-8?B?NkI1NjJCVVFEbUl1OXp0VXNJODBKUS9mTm9NdGpZRWlpSE9Eb3lTdm1OK1Vu?=
 =?utf-8?B?aS9zSXNETUJEeEZEYjk1MFg4SEJrajdNZkNNUm1mUGRJSXhBQUdmWDIxeCsv?=
 =?utf-8?B?SnpPeGlkRklPOVY1MEp0MkI4K0lFUkpIVENTdFlodFJzdjkrTG1DTmlscDFI?=
 =?utf-8?B?dUJuTlA4VU9DUzgvakVyVVh1UDBHajk4UUJHMTMzS2RSNkhnZ29RaVJiOGpU?=
 =?utf-8?B?NWIzMW9vVis5dndkWklRdTdmcjFkcGZaVUh4VG1USkQvN0RmSEJKdlJxbmNx?=
 =?utf-8?B?NkJYMDlEQksraHhIRDJKeU5XbjlOQWZ5VU8wSVFLWGNGUWs1a0Y2MUtwdVFx?=
 =?utf-8?B?Z1FuaXQ3SHJKTk5ITVVZeVh0V3dqWFpybU1sYnZpVXNNaE5MNEg4cTNFY0Vs?=
 =?utf-8?B?Z0JmdE9HNXJQbTdzUzMzZ1FHKzFHeSt0NytiaWxKVkhBdHROT3dsYlU3OEsx?=
 =?utf-8?B?WHROUzZpaXZscjJCWW8yOVdKaFllTkFWdHkxcW03clg5Y2ZYQ2wwcjhzNVJt?=
 =?utf-8?B?QXM3WHRIc056dEVjLzIxaFpDelFwS2F3c0tBZGczZXArMHovaHpsalNOeUYw?=
 =?utf-8?B?QlI2NGw3ZUhDRUtyTXl2eElzWjZoR3N2RzFsNk02a2RLMXFjY1VhZGV1NlhY?=
 =?utf-8?B?UUxwc1VoUk9mSDJmSm5XdXdtNmdERFhhNHFQZXRYSHdYR2d5dHd1T1M2WktG?=
 =?utf-8?Q?PZE1u7Gg0N/BU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alladjRka0U4U1dMSmMwNCthandXbHFBbk40SXFPRzlYOUVQbkExanVnU3ZS?=
 =?utf-8?B?RFZlSTlsQ2V6eGhJaUF6Wm0zZVFJM01uMTN1aUsxNFJWV2VaM2UyT2RGRGNs?=
 =?utf-8?B?dzRuRmdkMzZsakxQNTRwNnhxb1RRRGZCNmEvWVhESTB4RVhybFpQUCt2ZTFX?=
 =?utf-8?B?RSs2T016T3FwZUd1NzdoWW9rbUZmMUU0ME42MytsRVRmYlJ3Sjdad0pIeWVu?=
 =?utf-8?B?SlhoVmFOQUJmdDA1WWE1Vlc4R2J4SG9TdVVWUXZCMFNkWmtYSEZGcVVRajN6?=
 =?utf-8?B?alhqWWtzVjJXR0RlOTl2QWN2dGMrMzEwaS9EaU1GWWZsZWljRGZkbnVSSlda?=
 =?utf-8?B?MTU0WjYwZkpkWXFPWG4rMzBlTVpWOGVTZ09SajJka0lHK3NjMVVabDRJTG02?=
 =?utf-8?B?dENzZm1xaDBtNjY2M3B1aEVrSXVtZmNnNFdUZkF4TXNHenkvM29qYXZEdG53?=
 =?utf-8?B?dGY4dEVFL0FTeVUzc0M3SXdsR01tQjBialdNT2FtSFRDNGwzenZYZnlubDU0?=
 =?utf-8?B?WEliSU9GbldpNG9TY1lBZHhmZ2l1djcyTThWTjBFaWQ1WHQ2WFZETkQ3VnBR?=
 =?utf-8?B?UWh4bTdaWk9uMEFidHMwZTJSMW0zK0U0OEEwa1RycUsvVFpXcFlCbG1TSGVP?=
 =?utf-8?B?QTZxc3hmTytFM2l3eE1YVk9kellxYXpFSDJkOHJONHRJckU1RjNrWjhjMyt2?=
 =?utf-8?B?Z1BoMnd1dDhHdFRiUXZGT3NYeVY1NUNhWUh1bjRnUjhSM2NnbHdlZDc0Qzhx?=
 =?utf-8?B?YTF0WjRDUUpoa3BlZmFNcmh6aTZwZ1E3MG5EZG0zRDRvdVlDNUlJaExnNE9G?=
 =?utf-8?B?ZGFXY1ZsNDlsYWwvS3NwUEk0R2s0ZC9kVHVHdHp2Nld2T0FHaDZTRUpSNnRz?=
 =?utf-8?B?amhXQ2tTcENFQ0NCY01VNVpNN2liVmZYZCtOKzhWdlBGdEJzRE9ySzFOVW5h?=
 =?utf-8?B?eXNpSjRQQ3JReDdjcjdyb1hKY2JsaTI4K2VtTzJxdWhXUzk1aFo3eC9zYmFj?=
 =?utf-8?B?cGhzblBlRnkzR2N1bVVFQTRQV1NOdXRscFdZYmRraHMvTEJxMnBtMHA4cHV2?=
 =?utf-8?B?Z2ZBZDYxa2pHSFFWUTdMVHNpdmdrOUs0WXVjYVZQZFVJeXlscTNkSC9FNnh6?=
 =?utf-8?B?MmYyWDV0Z1JEMkxybi9JclQ4VDgvS2NwWDNVMFpRanB5M0JTZ3NnTEJIZmxj?=
 =?utf-8?B?Yzd2RmM0NnVQQmtHSk4yejlxSTNaSEhqUm93M1QySVNsa1NqQmYzcmM0ZkMx?=
 =?utf-8?B?aEVqaWMycVBid2w5ZG43Z0RROGRQZkxtTGI4NEVKUGhFNVFINEpSc2dvOFdl?=
 =?utf-8?B?NmMzdGtPdmp5UER3Skltc0R6aG93Sjh4TFNld29VMHNsTmg5TERCTEFkNnNX?=
 =?utf-8?B?UmxLU1k5dWZ3WGtmZzJSQTZJZFVWNlE5dWtDdU9hQloxdStkd3U5UHhmZUJT?=
 =?utf-8?B?Z3k4eUxlQlFZRGt1NkhYNzVGSUJSSWdTRnlrSVRPL1FNZmI3dnJOZ2ZPQUwz?=
 =?utf-8?B?YTVuTlIzVC9KaUFGMmRxM3FkSmxkbDZSTkZCc2loOVpHbDNjWFEyS2REUkFh?=
 =?utf-8?B?d2xQY2Q0b1hTMk9LSkJ5S0IzQk9sNDNINHUvVDloMU9UQ1prS0NYMGp3YUlo?=
 =?utf-8?B?T0xqdVRwS1hwM1JvdkRLeUsyL0ZmbXZkcGpyZW95eGlIWjcrNHcwVG1nY2Nn?=
 =?utf-8?B?MXM3elhnU29CWTJLbHZWTFUvbjlJYVZxREVzeWo0NDlqdWM2aWt0d2wwOTBz?=
 =?utf-8?B?L00zT3BrbHVzVURRK2ZTQ25BTm5xN0lDMG1hTS9KaVJlNExaQjExQldYYTJ3?=
 =?utf-8?B?azNtWlp2ZUJUVXBzYjNiM0duNFhKWDFpVlVOZFdsajY2L3dMRFV6OGRqV3l4?=
 =?utf-8?B?Ti9kZGJ3NUdTZWNDREkrVXprZXRqTFQ0MWpwOEtzMTFmUkZZdDNCMWQ2U0lz?=
 =?utf-8?B?MGFzZm0rWURFd0lFNThhdkdlQmh0SVBmaGttdWVxV2xHK1U2azRTbmhkT0Vy?=
 =?utf-8?B?Z0tuTFF2TWxPRkR1SWpzSnVqNjdrYWZOTE42SUNRZlYyQ3p4Z2RNVkUwdVN2?=
 =?utf-8?B?bmNNQURqakxCeGJpRjkrSXRoblRTc1poWVBnYXN1eG5WQVRjdi9YZlNJOVdn?=
 =?utf-8?B?SlhhaVBZUEd3TDBtb05iTFVGSGRyQnlzem56MU5Fc2d3V0dHam9pem9DR0wv?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l2D8I5EIJ+6l9M/UlVFSRmR8Z2N6snnGTBb0/ayw+Mi5rsLRI70WBHP/NmdAV/LilJ5NYI/AhwLnqQq5cT9NX9qF7USmgR2PwYEO9X6jPu3a0k4YD8YPOVv5FmrcWBxy6HzpVkAzRWFPmW5O8AfxQRN9n/0kjKqhyWqVtFsa4fxNLTACql454YeCsTQIrleioOjpaL2h81GGefjO/HIW3fiVapZmlCblL9GSjblOoUi/O40IoU5+iVMfa0myzGQRxlvmHLo4ijTqmyDdj8kkNSboDY1qoCpm92gcV+PzvVeK69rzxrAtLhDD9e5hMxlDg2mL7zjPKOYS8NLRbWXSArdhyVK0Ku/n4LBedzQqf/zuR7XSU7L0c84ueIdvkeG7Ogm04Kt2swnFBOrxX9gUCOTTd2JMvu7x2Cc6ZcgyBTHlUx2CNK3eRxkilGRY6BklZj4smHEXU5NPIx5KkRiKHsWBEn8r7vQz3g5/FwIkBDjPZKLrN82pBFMh4PP+GS1ODAxWIoa5Q2fg4jA3hsnA2WE5NUvQjN2xhgGNRxmtM/h6FhleaWjmylYvX5w97n0iuOzor4PRczvRwVh3flbJYyBPMuoMKcMyddOYMkVyYOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4626f534-bd6c-4a7d-55b3-08dd4111bc15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2025 09:37:38.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrhmvQ1VroV0hxjyU1dkrlYJPd1n+czV8a+QpWp736JV++CZvjLpJ9wztNUcn893AmBPOeoLBxaAI4oBqEso6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501300073
X-Proofpoint-GUID: MGALcXB6Krytofnl-FlasKqcafUPFyXC
X-Proofpoint-ORIG-GUID: MGALcXB6Krytofnl-FlasKqcafUPFyXC

On 27/01/2025 21:32, Sagar Biradar wrote:
> Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
> based on IRQ affinity)"

Hmmm... so is c5becf57dd56 broken?

> Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
> CPUs based on IRQ affinity)"
> 
> Fix a rare I/O hang that arises because of an MSIx vector not having a
> mapped online CPU upon receiving completion.

Is this actually being fixed here (along with now exposing the HW queues 
by setting shost->nr_hw_queues again)?

> 
> A new modparam "aac_cpu_offline_feature" to control CPU offlining.
> By default, it's disabled (0), but can be enabled during driver load
> with:
> 	insmod ./aacraid.ko aac_cpu_offline_feature=1
> Enabling this feature allows CPU offlining 
> but may cause some IO
> performance drop. It is recommended to enable it during driver load
> as the relevant changes are part of the initialization routine.
> 
> SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
> and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.
> For reserved cmds, or the ones before the blk_mq init, use the vector_no
> 0, which is the norm since don't yet have a proper mapping to the queues.
> 
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
> Reviewed-by: John Meneghini <jmeneghi@redhat.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Tested-by: Marco Patalano <mpatalan@redhat.com>
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> ---
>   drivers/scsi/aacraid/aachba.c  |  6 ++++++
>   drivers/scsi/aacraid/aacraid.h |  2 ++
>   drivers/scsi/aacraid/commsup.c | 10 +++++++++-
>   drivers/scsi/aacraid/linit.c   | 16 ++++++++++++++++
>   drivers/scsi/aacraid/src.c     | 28 ++++++++++++++++++++++++++--
>   5 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index abf6a82b74af..f325e79a1a01 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
>   	"\t1 - Array Meta Data Signature (default)\n"
>   	"\t2 - Adapter Serial Number");
>   
> +int aac_cpu_offline_feature;
> +module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int, 0644);
> +MODULE_PARM_DESC(aac_cpu_offline_feature,
> +	"This enables CPU offline feature and may result in IO performance drop in some cases:\n"
> +	"\t0 - Disable (default)\n"
> +	"\t1 - Enable");
>   
>   static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
>   		struct fib *fibptr) {
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 8c384c25dca1..dba7ffc6d543 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1673,6 +1673,7 @@ struct aac_dev
>   	u32			handle_pci_error;
>   	bool			init_reset;
>   	u8			soft_reset_support;
> +	u8			use_map_queue;
>   };
>   
>   #define aac_adapter_interrupt(dev) \
> @@ -2777,4 +2778,5 @@ extern int update_interval;
>   extern int check_interval;
>   extern int aac_check_reset;
>   extern int aac_fib_dump;
> +extern int aac_cpu_offline_feature;
>   #endif
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index ffef61c4aa01..5e12899823ac 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -223,8 +223,16 @@ int aac_fib_setup(struct aac_dev * dev)
>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
> +	u32 blk_tag;
> +	int i;
> +
> +	if (aac_cpu_offline_feature == 1) {
> +		blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +		i = blk_mq_unique_tag_to_tag(blk_tag);
> +		fibptr = &dev->fibs[i];
> +	} else
> +		fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>   
> -	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 68f4dbcfff49..56c5ce10555a 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -504,6 +504,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static void aac_map_queues(struct Scsi_Host *shost)
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
> +
> +	blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				&aac->pdev->dev, 0);
> +	aac->use_map_queue = true;
> +}
> +
>   /**
>    *	aac_change_queue_depth		-	alter queue depths
>    *	@sdev:	SCSI device we are considering
> @@ -1488,6 +1497,7 @@ static const struct scsi_host_template aac_driver_template = {
>   	.bios_param			= aac_biosparm,
>   	.shost_groups			= aac_host_groups,
>   	.slave_configure		= aac_slave_configure,
> +	.map_queues			= aac_map_queues,
>   	.change_queue_depth		= aac_change_queue_depth,
>   	.sdev_groups			= aac_dev_groups,
>   	.eh_abort_handler		= aac_eh_abort,
> @@ -1775,6 +1785,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_lun = AAC_MAX_LUN;
>   
>   	pci_set_drvdata(pdev, shost);
> +	if (aac_cpu_offline_feature == 1) {
> +		shost->nr_hw_queues = aac->max_msix;
> +		shost->can_queue    = aac->vector_cap;
> +		shost->host_tagset = 1;
> +	}
>   
>   	error = scsi_add_host(shost, &pdev->dev);
>   	if (error)
> @@ -1906,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>   	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>   
>   	aac_cancel_rescan_worker(aac);
> +	aac->use_map_queue = false;
>   	scsi_remove_host(shost);
>   
>   	__aac_shutdown(aac);
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 28115ed637e8..befc32353b84 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
>   #endif
>   
>   	u16 vector_no;
> +	struct scsi_cmnd *scmd;
> +	u32 blk_tag;
> +	struct Scsi_Host *shost = dev->scsi_host_ptr;
> +	struct blk_mq_queue_map *qmap;
>   
>   	atomic_inc(&q->numpending);
>   
> @@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)
>   		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>   			&& dev->sa_firmware)
>   			vector_no = aac_get_vector(dev);
> -		else
> -			vector_no = fib->vector_no;
> +		else {
> +			if (aac_cpu_offline_feature == 1) {
> +				if (!fib->vector_no || !fib->callback_data) {
> +					if (shost && dev->use_map_queue) {
> +						qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +						vector_no = qmap->mq_map[raw_smp_processor_id()];
> +					}
> +					/*
> +					 *	We hardcode the vector_no for
> +					 *	reserved commands as a valid shost is
> +					 *	absent during the init
> +					 */
> +					else
> +						vector_no = 0;
> +				} else {
> +					scmd = (struct scsi_cmnd *)fib->callback_data;
> +					blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +					vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
> +				}
> +			} else
> +				vector_no = fib->vector_no;
> +		}
>   
>   		if (native_hba) {
>   			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {

