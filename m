Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74091509B1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 09:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911867; cv=fail; b=HCNOeaVBPA23kOshQK7+Pne3D3ZV36+nTTOVca++xFAtruw3zCDnrjTnGR2Gs3K+bzBLAPJVO1Axs79ReQWz5kT3oRIaYX8F5Fg3VDB/wMDt9X74o0GDEO/gzgkV026ctFbmySSWceaFSa7zljfeTM6akRm1+pDidSjSQBJQmSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911867; c=relaxed/simple;
	bh=WIZzZXduYGFdfblaL2Uvt6RUt3msNSLNn93YQI9lWwA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JK89sYnL4Fedd7ItdBEYrPQPWKzIsd4Z+mmQlv4v7UmZiZZTyZj8mTMGzqazShOMnJYAb4FbNGQib3Dv2KVvejKdv3GR2CZfE99S4EbPktROV4TQWcWl2x3PQ8GzCdGY8J8BSS9JAaSzL1DQ7mp6thR1FLsscDu65gVZGhXn8SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hIu07cXN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tpX26sqV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hIu07cXN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tpX26sqV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4625MdqC015606;
	Tue, 2 Jul 2024 09:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=9+FKAMzc7VyU0674WGBfW3nS9iP8CIzVsOGPg/YtqkU=; b=
	hIu07cXN24tnLw/N2MJOqa8VpO6/IT1skthYK0dwgVHFGSuSM2zcUC0CPeDRSos7
	0AHHGJV3bOQEw8ce0vJLAC/BGL+zZbKvypBbPlzCGB+kdSUcwl9EFqhwjJ1C848A
	AudRTDW6AE01HwKAOnor3BZ+uNchAwKAYi6uhx0RVecReKaUqLXfJUHv+PtmMPyM
	8jFtHw+EVGJk5oPwjwcmFKC8PqCteOCua2HHyg55xBGRtwBA8NZVV/G+ZaLkGq1d
	ZPcguuSbT2lOXqALckaLPe2ZlSaocK4V3An0Gl9fOx1meJOF+mzg63g9vWUupndF
	X7BCAEAlkQqtkW5WYtvsYA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4028pcnae6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jul 2024 09:17:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46273hAk019048;
	Tue, 2 Jul 2024 09:17:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qdw8k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jul 2024 09:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR/SBOzOQfaNiUHBK2oV4nVdUX1qbNvcM4ZlD6+YgHdbieuyEq7sehNzXi8xu1VpnfJJV25ggvIR4LXGUR5qWRiPT9g+lc7q0XoQpow5DGhIG/BQaaaYm+fjJGybktS9mFkkZR9yOYaVItVPpZe827DxPLy3dbpeEnWa2rnSJmOI5GG7awilWCNOilf4VDeCfmFmIPZVOFiEawfrHEYOpn8v34tceH/2P2HRpw+XSc2wXArELtmVNT6PZQFak9r2ynSAnnlLv/68h9KNgox3ASy9BiWQYWg0BoLgPmMYjiSdBkJhhi5xp82JXJU3xR97StRbLg/UhyiLN/OkHYMDDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+FKAMzc7VyU0674WGBfW3nS9iP8CIzVsOGPg/YtqkU=;
 b=iqguOioJh85YHRQsdKcy2arwThgCcZ4vJ+TO1TR5qEGHAERJPpYiUSzIK7DucaBjNwPbaOMwx3wB5qvCYIsL3i3uhXP+Ussml30nVtnwHX9YdQcBML+wvwGNUW/wpdJF4OC1Uvmy3kDZzq8EKsjiH77KL9vjWu/rH0rtuqXND/ZxqeNd1oDU2wXAPhWoVeONfjOxcT5E/HQG+P84FSH0UDihOpXMADQEawtgJNCMz3IEjz5q00eVtYFVEAWuQS3rEgfOWaHII9+xJEVGQb4L7rSj1Fi4ZFUwFLxtBI9gAgySLfrgruZOuvnztac/0jly64fM+JMwCBmunuswy+NJDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+FKAMzc7VyU0674WGBfW3nS9iP8CIzVsOGPg/YtqkU=;
 b=tpX26sqVQwQXXhBJPOCYYi3SHaqP+VjEJIrXs7vpwC27LGeMryKiV4T4yCElevzv6ADHHDFB/Lux3/c0qKOWk60JKo1O29JCpT0I69TFeaeHpBwipAShwKldZ2oYYKDv57AGjqtCBjOeB7RgaS9BgM1Gn4mgy4biJ2xpeDhVzhw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Tue, 2 Jul
 2024 09:17:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 09:17:36 +0000
Message-ID: <4f555238-a045-4f26-ae61-0a4368195118@oracle.com>
Date: Tue, 2 Jul 2024 10:17:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Do not repeat the starting disk message
To: Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20240701215326.128067-1-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240701215326.128067-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0132.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: ad5f2881-1942-4ebd-6596-08dc9a77d040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QUZYbXduaDNPdmpQdlMwbnpKY1N4ODBscGY3RUVQNHY0bjk0aHhGdVNmd0Rn?=
 =?utf-8?B?c0ZmTW1rUjk1QzRCcSs2Q1kzZk1oZDYzcWpOZlJJVGhZNVZDZkVvSVhJR2Jl?=
 =?utf-8?B?Nmh1cHc1ZHcwb05MQlBmMlR2QnVlM3l6S0tkSEtVNGpnT2tML0krOHVwMldD?=
 =?utf-8?B?MlIySUFleVNWdmV3NTBQbFhhUlNua3BOUlAycWhDK1ZuU2E3S0c0cDU3elAv?=
 =?utf-8?B?MGhoUEV3azBsTFJLNFR6WmZwaTVEQytvUzFEbEpVTU5Wc0ozQVVUbkhSQzhE?=
 =?utf-8?B?K25ROHAxTG1UMzBwbXpUdXQ3a2dpVjJsS3NRaDBpbnh5STJqRnZuV25WMThH?=
 =?utf-8?B?UVE0cU5XSjh2YXZKdU5XNTE3Rkgvb0FmRXF4M2FFSXU3VXdkVWMrRnNocGwz?=
 =?utf-8?B?Q3NDenNGSUFMT3p1RVd4YW4zNjQvdk41UHNadWdpaFc0R2Y4S1JySk5zcGkw?=
 =?utf-8?B?RzlMNXI5Ky8yT0JYRCtHMGdwdXNhUmtESUNyanI5Snl6Wnk1RGpzZ1JpNGtn?=
 =?utf-8?B?TFlHRVRnQVNHYzdFZFBKOEVOZWhHRkhUZlZ1Q1NvRzZycW5qdURpVkZyV1JE?=
 =?utf-8?B?TFpua09VcUF5aFloQ3Z0TXNiWUxtZVc3TnhRak9FVFczVUYxUVhoWG5DQ2pM?=
 =?utf-8?B?Y0pweWQ4V0RhaEsxUGFYQy9ISWpEcTdEMm1rZHBvcG1Jc09MVUVHNXlBU1lP?=
 =?utf-8?B?UWNObkVMNWQrckpQbVhEVlc4ZWx1dDdkdU9RQTQ3NU5YMVZhc1psYmxPV0V5?=
 =?utf-8?B?WXFLVGZsWkthcmZObWdZTjJoRlQ0NlZJRzhhSS81L1FnZlRFcysxei9tWmJm?=
 =?utf-8?B?bUhpZ1pjVzdSSjI5REdyaFp4ZE4zQ05pNnZFREg0U1VDWFJXeG94ZzZSY3Jy?=
 =?utf-8?B?ejlwbjNXM0NrUFA2KzNtMjRqaFFVL3R2dm9uSzkxcjFDbjRXT09EZDRoNTZS?=
 =?utf-8?B?L3pRVGRYTnBSQVNiOVM3ZjlRajJEaG9weWxNQi9UWjlhN0tidFJDZVA2aDVE?=
 =?utf-8?B?NHJ3bWpXSTRrQ0NiV1E1aDBwamdWVERLK2M1dFFQdkxOcTkwWlczTUVEMkRF?=
 =?utf-8?B?S1gwQXNjNlJQRGgvZ202V3FMTURrZXAxTlhpWjRCRXVhOWh4cDhhZ0RQU01y?=
 =?utf-8?B?TlVONWtWUVR5RkNNd25Pc1ZOUlZES3Bjb0x6cUpiMjBYSGtDU2RYZ0MvcjZH?=
 =?utf-8?B?bkdTMnRxVTNtbHEvcXZXN2ZhcGhXbWlUNmZHOHlMRkprMWthS05zN3hkV2Ra?=
 =?utf-8?B?RDU2RlAzSW1Kczg1WHFHU0VUNFptU2tCLzQybk1teXNZY2xSMHk0NWNiODQ4?=
 =?utf-8?B?aGVzdFRHY1d6YWpxREJvZ3VpOE90UkFoNEUybjgzTVFrU0RNY2EyTzQrQTZi?=
 =?utf-8?B?RXJWeDdKTE5xbVUyd1JGdURXQldndkdNOGRURkpWUEtwM2VORm1jVjhnUnZL?=
 =?utf-8?B?YXhxMEVYbllMN29WZTMwcHNYUFBJK2JJZGVBUkVBRktjT1ZLc0hhM29FZUVE?=
 =?utf-8?B?eXNTVkRWbktMcjRKSFZPaEZHL0twaS95UlFvRHhpdEZBL0dBTEJlODdPb0tt?=
 =?utf-8?B?TnVBRC92MkxsaFExbmpxRWJtUGRkdnRWODloVUVKaWNVcW05eld2dkNjNzJ5?=
 =?utf-8?B?TVJnbWc1N09vaTlLOHlLVVlzTHJKTnlqbHVXSXY5RTlEUUF0OVJMM0NYSFUw?=
 =?utf-8?B?V0Nvc2RLcEQ5Vy9lcXVIV3daellsT3hscDJpYi9FeVI4cVoyNDJ5aVppY2d1?=
 =?utf-8?B?eEJ6NVpKMGFIRUY0Wk9uNnB4QkRML0tKV215ZFliL1NmYnF5VnAxWEp1a2Zw?=
 =?utf-8?B?TUIwZ3h3TGZXbG9yOU1BQT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UC9UN3k5VGh5dWtEdnRJSHY4SVpzNXlFQU1qMW1FZDBDM25nUmJzQzd2bWkz?=
 =?utf-8?B?aW5lazdQZWlXMDdublZwajFtam93S2VaWmRjOWZmQWs1dkRwR2plY01aVk1i?=
 =?utf-8?B?OUJ1eFBxUzUreml0aU9Gc082MHArNmhER0R4cFdFem1mMVlYMjJwZGQ2aHBK?=
 =?utf-8?B?MGtGY0JCSFRGY29wUkZEYVFXYWhiVGg2a1FPWkpYNVdzNmd1MFhYNVlvand6?=
 =?utf-8?B?eGFrM0J0eTZ0OUlBaUV0ZjFib2dtOUJvYUxhTHhBY2o5b1hlbjdyS0pjT2xi?=
 =?utf-8?B?aUswNFdVcTkrT0VaV3Z3Z0dvbkE0RDdscldtaWtPWC9paDVONWttMVk1MFY5?=
 =?utf-8?B?SWM1YzB6WUhpQzBmREFKZUgvR2JVeldETERIdHhNdmZaNE02Y3krbmt5SHBL?=
 =?utf-8?B?TkF5Z3I0MGNtMHd6bEVzZ2NtaUtubm9CVmp3TlVIeXlLYzBwQzhiUllTT2NB?=
 =?utf-8?B?UlpqV1QxUXUzNjVKeTl0VVd6UmEvRlBRTXZ5VU9CdDlHblJiZU9LdFdWNmJq?=
 =?utf-8?B?YUMzUGpYMzhNYnRQNkFMR0srdUNxWEE3MCt4TUZDcUUxd0x1elFuT3RqN3ps?=
 =?utf-8?B?OHAvclppWXlFUjk1dW0yVFpqczhWQzdCODFQYUtTSnhOeTlhVTBReFo4L3l5?=
 =?utf-8?B?QWlyR0ZpQUgxbnBENVNwZjlUd0Q5VEVmL0czdGJpdzhuemUzOU8wT0R0bkU2?=
 =?utf-8?B?WWdCVWRyR1l1SFVoMG1rcnRvZ2ptZlhWcHRSbCsyN2h6aG96cUVIUFNzbUQ1?=
 =?utf-8?B?RkRGY1NnWmFiRTVjelkxZXp1UzgxclZRZkhSOGllWTBrNUgxcWNsR2tBNCtS?=
 =?utf-8?B?M3I3VkFQemVtTnFxM1pTemgrTWNwSFVMLzk5RW9jdnVwZW5pZlBSZU1TUVEw?=
 =?utf-8?B?REZpU3diVjJoR3BtSWo2NE1GeDVGVGpYUzBuV3FGOGVya09PeDBodlRVMkFv?=
 =?utf-8?B?YTNsUXkvMCt1ZHpnRUZGa2puUklXTW5aYmkxblgyeHc5ODVER3FhU2swRUp2?=
 =?utf-8?B?TjhrZHpucUdqcWF3czVoQnY5aHlVMXUrSFltMVgyR0JtN0dUVWc1dGVnK0NL?=
 =?utf-8?B?NkFVdnUzemRYcStGUXQ2Zjl0dWNvN2kxc2ZrTEN1UThsbnFGTkdFTGJTdXJY?=
 =?utf-8?B?OEM3NXRpNVo3Vlc2cWl5cU1HQVExSW5EOW43N2l4MUc0VHdoRnN3RW5kOWIy?=
 =?utf-8?B?RjBHdDRiOEtGVnJVa2dxZDJxN095SXVMNmlNV3dHclk2MHNqc2VmVGVyM3p0?=
 =?utf-8?B?TmdneldnQmJGSjVvMlpkRVd3clBaOTBXOUJpeG04V3J1Y2grRGhZbVBQNWpG?=
 =?utf-8?B?b1lHaURXUzRHa3lzVk55UVRaTDIrRjFGT2l3UjIyeWw0R3crSkREbW5HeHk2?=
 =?utf-8?B?MG9BdVkzeVRzai82d21SSEM2dExid1I0cHRMUWZnVUlJOGN1dGlFbDVWS0E4?=
 =?utf-8?B?djNVUEc3Mm1LbXRaUDBJVnVKWFVFSTdTQWx6U1Y0c0hwdEkzM3hsVWZTM1Ry?=
 =?utf-8?B?MnU3ZUhpS2d6Znd1UER3YjJORHM3U0Fhbml1QUh0S0pPaHY1MTVOM3IwU3Y0?=
 =?utf-8?B?YmlORjRjNk1sd1lQVWh6NUUxOEY0WDRXMHl5ZktQUFM5bC90eW5iRnJsVnJP?=
 =?utf-8?B?OWpHbWJoWEVDUXJrZmIxdnZXM3B4dEovbVlUallmSFh3R2F2QnNGQTkxZ0U4?=
 =?utf-8?B?eE9zREtxUU5kV2VDekRERzI5UTJTL3FvVkkvcFpKVGZaSXczMzY1UGpuU0hr?=
 =?utf-8?B?VGt1YjFzSCtqcGEyTE5sQ2J0YU1lcmhNazVzS2FpOUR4NlFCTWtnNkwwa0xq?=
 =?utf-8?B?Znd0c2tWUkJvREhHdDlXWlUreXN2eWtHektzS2VDM2oyM1BpYnZFOStqK2Fh?=
 =?utf-8?B?VHh6OFFCZFlTQkF0cWM3SmtOV2lxZHRnQ2pQSXY1SXJFbjVRSmgrMHdTQXl3?=
 =?utf-8?B?aHZVQnBrcWJQWW5kejRHTEdWM002SUlBS2h1eS9rV3FISjEzdnNKb0dsZWNN?=
 =?utf-8?B?VUd1VTAyekJkVXBJYjVEbU5KdFF0cDB5aGh2RlpjTmVNNWFwamphWHN2bHUz?=
 =?utf-8?B?SzhaamhNTlZnSkhaTnI5UDc1QUR3NVB4UEhpNmV6dDlKMEVvTGhNYitaREV4?=
 =?utf-8?Q?gcVkjkJvhVa905XseP8kkkcTQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Ni1Y4LHySpjKyDtY0gA9mMzigYVH5Rfb3z4MNeKtixDYIaqp/qyr5a/SRxpvoi2nf3dFpzN5VEu3e9Wfi0mYCIvJCUu5l1FpI4j5mNOZT4bLD5hVzz6Bi4UViO7rKRkCBoERHrg4VNvWrDpy5FgnwJvShrtLWZsYzGHF7+3R2kcBxrhIp4i8ojsz8BJqh2c1i/uFIDgkGSuYV7kOddXrhfZTSsO1EGtuZCIcur5nNGUtekYznQZ11j90XWfD1XHkGpzsNeOwewBpo5WRaxh3dGcjK1UB9v6rWJdiQ3Wc2LhA+HsK7gIfRIHgtEVQdKkvnMrSw5g+lW4RofjYfp8t41j8TfJoNFzqmrZXuJTgea8m1lO0oDniIbd8NdSWJCPOzP5+iTfu15zg4Ivhn9Qt758gncryztGAoxuJWmXGnX6b6Np+hs31LuQBOvxE6AeSq/8gVIMcxfRaiuubfm/p1n4wOxv9iT+dLinflLm7QJoYf4pf+42tBMAo+beJQssC7qMY85ehb5H/8KHOI8U5FPq6VrJoE0bkiXqW6Q46QNOvII7JIf5C0tpub5oLlwxutlmdG5fcBVfrukdU7iUJ/VXxswdNe0qzJMdiN0Flzq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5f2881-1942-4ebd-6596-08dc9a77d040
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2024 09:17:36.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hra8zKc+qL8cj+mctir85JMbWXUQ/eFitMm5NUJY05Cu8GJCpcxyxosLspFtbpfzaKyTi+nMEnLZ4O5BsbCnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_05,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=959 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407020070
X-Proofpoint-GUID: kJUTOMuAgK7k2kQ48pu_uM_3jM6gTc3Z
X-Proofpoint-ORIG-GUID: kJUTOMuAgK7k2kQ48pu_uM_3jM6gTc3Z

On 01/07/2024 22:53, Damien Le Moal wrote:
> The scsi disk message "Starting disk" to signal resuming of a suspended
> disk is printed in both sd_resume() and sd_resume_common(), which
> results in this message being printed twice when resuming from e.g.
> autosuspend:
> 
> $ echo 5000 > /sys/block/sda/device/power/autosuspend_delay_ms
> $ echo auto > /sys/block/sda/device/power/control
> 
> [ 4962.438293] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 4962.501121] sd 0:0:0:0: [sda] Stopping disk
> 
> $ echo on > /sys/block/sda/device/power/control
> 
> [ 4972.805851] sd 0:0:0:0: [sda] Starting disk
> [ 4980.558806] sd 0:0:0:0: [sda] Starting disk
> 
> Fix this double print by removing the call to sd_printk() from
> sd_resume() and moving the call to sd_printk() in sd_resume_common()
> earlier in the function, before the check using sd_do_start_stop().
> Doing so, the message is printed once regardless if sd_resume_common()
> actually executes sd_start_stop_device() (i.e. scsi device case) or not
> (libsas and libata managed ATA devices case).
> 
> Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
> Cc:stable@vger.kernel.org
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
