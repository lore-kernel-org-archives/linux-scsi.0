Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1541DA21
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 11:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709898432; cv=fail; b=UP5pQ5Km6jmGz0Y4lt6gtgHpBYfV8O8mx5b8Gf+6KpA++aIRGVjaABsdOVwrrNGPC7lzpc0ICY9N1dCYjmA4ugjcizSSymH3kEIOqSs5g5zNMtFd0SmPrw0/NBheAl/syQJvcegGJnB2zoELe9crRw1+I1/7as/0tH19M//UnuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709898432; c=relaxed/simple;
	bh=vFFXdtTVjTzNr8RCZiWpJQl1+wodTAwRCv+wFmejj6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j2oWfFEmSQGnngHFooJ/p2bg/nWR3SOmcMjGfZPqL+JABmYf014uK3g1Qah9oVWsVJGWNQaCt6A+KEL3Ma7fp4g1c3m5eY1UVwCyVthqw/3MsPErmfFH2RtGtXLkKgbFt4AHd1ElN2l1c+Jhj/aGUL8+GZsNn6wTMNJnk+lcZcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S+q2Gpse; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=paUf5e27; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S+q2Gpse";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="paUf5e27"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428Ak5pp010289;
	Fri, 8 Mar 2024 11:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=FX2aEOqlC5H/fAzUuECli7PPzidxL72o+H9efNpSKcI=;
 b=S+q2GpseiDlMlZkTpCAcT/TLiPIEWYyOIv1iSf9+OKwwt7v/2TZARz7EGos2YY0RRXMP
 EYYjeT/iBeba1EbiyREI8D0D+30mHOP5rbbfTk6bK06eZaSvQQypUMqloNkD3zCKuuPC
 9CsY4UTy7jIYthI/jmVpJ+rs8J97cMurE6bWgKU7tV4vGxfIPUEtbRJ5ZD2Vae4WYmTu
 /mZELYgJZqbG9FjcX/TXALaLBbgQmWsBqokYcE5I/X5pkvIM+lyCsRq9wLjpD3X9kP+b
 ZJ2ZOA4jQya/uH0uWAwGVsXgr2xfvnjA0inyfK+gMG3xUcydSJGwdgFSumJ+MnxzzfM3 Jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bnnkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 11:46:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428BU05C031906;
	Fri, 8 Mar 2024 11:46:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjcn8fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 11:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N26K/OCOfECS9io3Ajvfuw0kqYR/+dKwMz5FbIMu0j3tTQMjPr45SSKWVu6PLzjcapHNRZpx73U/Zo6TvHuL60rD2UN5yI5oeWNvexYZFhLFZ4arjQQNLS8BxlUxwC4Niz8tuQyANsx+Sfwy9H53eOQq1aR9csUbn+evNAwauo2oF256c81K654+ubVLCU5bK+LhwKnz1KWgfnvcttfRpIOTIA15Df099NYmX3T0WIJJcRMFwmx1kwGujqbSBVgmOIMHwt/JrP6V8zn9BnYHodXgfHZKjB4I6uHRZzC9WOWTItq1En8qbXBEgNcWdzlKcd97TuqBW2fv3u6urtdanQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FX2aEOqlC5H/fAzUuECli7PPzidxL72o+H9efNpSKcI=;
 b=Al5ZGWd60RAMlWPk74bRfOJMYaMlZuQerpIZti3KZi7MP0XeO3/2sW01WyMxeq5j60OwvqESwHL8e7jb4dVSy3mqar/seHT5UwGW8LcwjDHJ8i7qXz2PAvi/P3dNtVIEOAc8auP4aEIRwR8ub9WYJTCfloNcVP0mKTJGModB2jFdeZ2tONRbviXpa26imImYXIyIfCiR6XNGPJR5ayen7WCPAvoK/Ilzjk29+gOKYUD9By2ofgG14OUgYKpf41DG0ECrpAVmN1iDclWLwwGopVhLsvwa8dWGzXVw49/91vQDI0Wl1rTvOp66qtQIGpjeHLGTdmxy84Htg8Ir+62z4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FX2aEOqlC5H/fAzUuECli7PPzidxL72o+H9efNpSKcI=;
 b=paUf5e27p+BzO5B4N0Zut4FffR0gfffiX7KrfyjDIzJ5lWm4v6Nqy/sIy71YWVwUL+VQqk68hyF0hcPgqqxdwdtiRDw4r+v6t26DQxFEA37oKCEIvH6kjwrZ+tdv4OXzsRdVEJNH5gobDrxggLr6DinBKtepZPq37wNisDNkV8c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4595.namprd10.prod.outlook.com (2603:10b6:303:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27; Fri, 8 Mar
 2024 11:46:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 11:46:53 +0000
Message-ID: <8c52f474-d157-4a68-a51a-9ccbe2352560@oracle.com>
Date: Fri, 8 Mar 2024 11:46:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: scsi_debug: Remove a reference to in_use_bm
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240307203015.870254-1-bvanassche@acm.org>
 <20240307203015.870254-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240307203015.870254-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0442.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 5614153e-945d-4408-f20c-08dc3f657328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CtYFPjv5xj1nXyI7MY/B3YvcGTCkiemLf/UbWc7Flp8lKlM4Xc04jBNdfaPHhxO3YuZRgmQIaQ8DCJNij3jbhZT7uKjYgKsrlD/2e0sB9/aH3tb0eMrmKNk72AxDt+uQUe14T1eOL82ATjNABy0l47UP8k1ovEoXdc1QMvturmryS3b1DKtITdEY/jcYZ+pBadVg1gHTORRyr3NI8Zrx3QOnAOjEVBy6ARRJB6UnmnJ2WPy5oYvWCXSAF6B8CWODixzHb0hqpq2VKglf73cdPP5Tn+VEU3yjGQQS1FIn/jIoUD5YX6+PbKN4fYUeKwhwleT8AvaPm3WdBX28zmilcDJaZs8uuGZQ+edgPLbQWNcxZf11XCu4R29TqooOdVe0ma+QcBGDPOYXN3BZG6jCGuuhSZtT8aQaVaxF8Kvqerjm0rcntX07CyB7tYRVc8/vBS/YzFv+fnGCFTIHdLpUrnx+Pcan76pUWlKjn85D6BEB3ZJDWRTq0HciEuf4AFZ+FSz7GE4+SiwVcV9E7A2gLsFnb1PhZ+FfgOrLDLVy+//rUwKJ16Rqm5OYp0Vcif/bMGbm3snB4ySb4DjU+RPZpg9uBchiGgEb2YfTVbKk2ZcTHOCZKm5ZZg9Mvo82RIIGlAclqOhI+JR9+tGqUsp+Jes2beJs7hd6aJK8vLBprVM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?azlSQW1xZVhTQzRmS3psOGhvQzYyU3lPc2J5R25vbnR3KzNyNU84VGVvNkNn?=
 =?utf-8?B?ZkFXMFlvbWRPWFdjRWZ1V25yaDdSdHBEV3p4RjF5NGRyM1IrbmhOUGEvNkk0?=
 =?utf-8?B?WnR2cXFqdmN2UVF0VThiZ1ZmV1JtdlhCYjEyK2ltWWNxaDVZOWE0VTJUTkdV?=
 =?utf-8?B?SENMU0RhWllTZzNiQjJMVWs4Ynh2UUpZQ1AwYi8xWkNDY1o1N3lVWXJ2dWhC?=
 =?utf-8?B?eDJFNnZ2aFh3eWRNMUNWQTdNMjd0VFdnL3UrOU5Fb0lERi9IMHMrT2pIRmFJ?=
 =?utf-8?B?RHdQN2FGRktRS3hvRGExVlRzYlBEd0ljMGsrTVdoSWV6elVDWjhnS21PZGZP?=
 =?utf-8?B?K0luQUw2Vkc3N3BIVjNsUUMzeVViOGJHQXIwU3NNQVI0RFdqQ2hrVVFlZVhj?=
 =?utf-8?B?UUkwenZIMnJkaXQrMk1iMEl2Znp4bm0xMjBoZUx0NkpydFY5WWszcy8wTG9X?=
 =?utf-8?B?WkdXekdxVUxmRlNIcXFzMGNVaTlHV0Y5Njhqbmk2bkJoR0xCTmVJaFhhZW5x?=
 =?utf-8?B?a3drbzRMWFdUYjg1NVg1cWNwNHp3L21QQ1NueGNJY29wcFFINUtSMkkvQzFE?=
 =?utf-8?B?b3JvblhXV2ViYVppOVNaQU5LVlVKbmxpNStIRVpiL2ltZ3V0T00ralBQdnpk?=
 =?utf-8?B?OUx6VE1NM1p0OFR4N0xwZVlwZUhKaGVickxQL3JZejZPNi9NUWNQeTAxU0lJ?=
 =?utf-8?B?SkMxOXpzcC9uaHNaT0ZlWGNhRkVleTY5ZjFIMnNKZitBMysxRlZxWTRoeXhH?=
 =?utf-8?B?bEE2RFI1RDlYVXVnT1ZDMTlFcGtOM1cycHlBSm1LeTd1bTY3SnVSNE4xcGpo?=
 =?utf-8?B?c0pwbWtzZld5ZVZHREY0Q0Qzblo2R2x6aEU2Vm1TUkpKSC9ZQnFsaCs0RVps?=
 =?utf-8?B?dWxQWG01VGJIbG0yc0NZa3RNa0lOU0VEVEdRRFI0NzdTVUprcmFGd0JObi9v?=
 =?utf-8?B?Z2gyQnI0OHpSRTFYMkZXeVQ2bit4MWhGZlhIaC9MUG1lM1lrSXhIOWhzSzRp?=
 =?utf-8?B?UmV2ZU9udVo5c1BVNDhoRzYxRVhRazc1aUFSOGRySjIvVnowNzFma0tleVFM?=
 =?utf-8?B?bDQ1L1lGMzFtazVLNzJHY003SW9EVmFtSnovaDJjZ25HWXZ5V0VZRGNma2Ri?=
 =?utf-8?B?aUZZQ04xOVIwUEFRMThGbkE3OEVPSzlEa0ZvNE5jN2ZrUGFMZ1dzdDFKejRH?=
 =?utf-8?B?ZmozbzQ1YkQ3YkdhTjQ3RTJmVkJFTW9vN3hlaWM5UExHUHpTeGNFV1hwN0g2?=
 =?utf-8?B?cmVSRXJ3V0JROGJ5dU5nRnVOeU5KdytyUzkwYm9nVDlQMzU5STBITkJoMmFC?=
 =?utf-8?B?S213Q2p6bE82YmNOOWs1alVYSDYvU0J6WEpXdWFWZm1nQU5RTFBhb1p3Q1kr?=
 =?utf-8?B?c3BWclZidHNoakpvZ2pMMGJKdjcyd3ZRQzZYdi82bHFUQ09TK0JXb2xhdnVT?=
 =?utf-8?B?d25aYnVnQ3M2SlQ5UnZLQ2tNc3N1YjQvMEczakc1QldDa1pJbGp0K0lzOHM3?=
 =?utf-8?B?eWJwSXVHWHE1S2U4TGVnVVpUei9hdzdScXArL0FSMW1qZFN2ait3cVdaK2ZP?=
 =?utf-8?B?SFY4UFZ5MERTZXdibitWWkxraTk1NUV4Ty81Zi9xL2piUjE2MFlqVFVxWGVU?=
 =?utf-8?B?eisxWkRPN2wvUXE2alNuaE9BTUhFcTkwazd6Ung5Sy9MV1l4VEZyR0Fqdjhi?=
 =?utf-8?B?eGx4enhDeDdjZ09rNWJ5Ky8vWGdTVnQyL0JQTk9wK0kyNzFNSzFld1FWQzJD?=
 =?utf-8?B?S2R4Yk1ZVW9SRUVJWXJSdENtY1EvOWkwRk01SGdoQ25GYmdTOG42eWpMSWUx?=
 =?utf-8?B?STd5WGZkSEFPMGh2Wi96QnJmVmh5cGY4YlZIVmNpNzhSNk5tMUczaGd2YWti?=
 =?utf-8?B?OEsyNGNrZ2VISEhldGVXd0hzUHFLRmxHWG5tQUJDZGlBVlRXckhsUFhYcXR4?=
 =?utf-8?B?S2ptWUpNN2FpK2VaQ0drc3NQVDFJc2dlUE9xTmRMYnZXcUp6cG5DaTZnK3Uv?=
 =?utf-8?B?cVNlUW9BUEdkc2ZtTFRQRGZhdWUvVDgwbHEzaXhwZDlBQnRMNlhTclZXNVNR?=
 =?utf-8?B?S1NoM3dUQVZYckdtRGZMSHZSdlk4elJlYmNlclA3TVRBRWYvV0F0YVdPZkdq?=
 =?utf-8?B?TVZVMU1GOHdwS2hyYWR0MUFvbWx0Sm1UU3B5SGlZUk9BVWpGVEdha2tQUHZp?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iVeSeB8fFx6QjmKT6VQNpe5Bl+hNGPsKGyTuvJfnq2ydZMRkX7PEx+QJ55bIyxjK8qaZO+jXlGyxjtwIILCozBU2uHMo+2jnO+3LwxsiyjtonK8o0nbFfYxq/gNbxCNeOVgQam4eTDSaUCbiYrUGVBDMSWc48/TEyoKzZphYp/c1yp0AsQms9gjQGubnxSiKKQK8bPKLQh17e8JeTEjfuJgof265wEea0PUHNdzC6na0iF2JmQ/nbSMkI5gs1spDEykTerXHPrQoKPJ46QBshBW0XSw1uc9JvLTSc4CPpUYuOmu9tvAmspOfeb9HozqyBTOyfq+WlSLBklPqKMJtPkwCOqRau67lLAcZRMUJ3Pdjbq/AYUIvVDDJTrH3iWWeKB+w5re1dfcg2J99Al/rYHICpQbOpTgANCLQhpl7kBBCcGUcVR1FjbEHnyNfAZCALY64N97xkUxK7Yq38zO2t76TJEM+hhKw7jbEuB17LIljqixu6LcSERwxKYpOv/2/Tlmxm0zqzkkeRq09MEIKFU2uSr8L21q8+hQV75tThv4PbJJF/CCIpl/jd5WQ+7yxxFa57h4F2u3cGhj9iMbFYycv714fmJ2G0BH0LUjY0Mw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5614153e-945d-4408-f20c-08dc3f657328
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 11:46:53.8415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FrXCfnUshAVGrgbN3ZX/+euVUDBPKELGgODyOFBe56a+9erKKgd6wlVP/IX6GMu6aVimp0K78Z+5Nj0uWtSeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080093
X-Proofpoint-ORIG-GUID: OQuuerFqAgZL9h7gZe2uCMApd4gWRSjH
X-Proofpoint-GUID: OQuuerFqAgZL9h7gZe2uCMApd4gWRSjH

On 07/03/2024 20:30, Bart Van Assche wrote:
> Commit f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue") removed
> the 'in_use_bm' struct member. Hence remove a reference to that struct
> member from the procfs host info file.
> 
> Cc: Douglas Gilbert<dgilbert@interlog.com>
> Cc: John Garry<john.g.garry@oracle.com>
> Fixes: f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue")
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index acf0592d63da..36368c71221b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6516,7 +6516,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
>   		blk_mq_tagset_busy_iter(&host->tag_set, sdebug_submit_queue_iter,
>   					&data);
>   		if (f >= 0) {
> -			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
> +			seq_printf(m, "    BUSY: %s: %d,%d\n",
>   				   "first,last bits", f, l);

maybe this can fit on a single line now without exceeding 80 char (which 
some people still want - I don't mind).

Thanks,
John

