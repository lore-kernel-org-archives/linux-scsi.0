Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0FDDAB
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 02:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742871582; cv=fail; b=aDxy19980Nf6nbKHhQf4S5jir23IQpP0luowb0/vQ0QMritAl7GxSaqk89IeKebzGPvqF5gPdw4XP23Hr6ih6+DQhuoJ2Ov2DyjNX53qjd3FgNwUeb6d0VLddt3kRIWSBn9wfrPs4zgOEfnF4QTCyeT7ko7KcIhHLa32B2MiRQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742871582; c=relaxed/simple;
	bh=pWFINftB37KLAAD6x3xbTwO8zKtTsl53hAm6tnUZEm4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LVRo+zO4DpibXG4nTF29Jed/iMMgdOgANMq9BDHiY+Y/bpm3CyVVw98ZURJN767vQ9iwKM+00EBaqxRKlbhh91SmYV/1s6Lr/HD+F2LxuZvAl641u9hsc0lsRxvLsXjDy7H9qpfkejz6dnUroIFlnjyJAQRmVM6P8faBOzLsOe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZQwEWr7z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R8jc7PYz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZQwEWr7z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R8jc7PYz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52P2tsnZ004590;
	Tue, 25 Mar 2025 02:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pWFINftB37KLAAD6x3xbTwO8zKtTsl53hAm6tnUZEm4=; b=
	ZQwEWr7zE2wlZhRZpcMpseqhuHBB1UO3o+x3d6uagjnl7Uk++Vs/sMdAgzf7HzvF
	ptUD9Q9Rw4uXy4kUwHA+oZjJ0Hi78Gs9KLQS+aJsNFOw2+L9jnuzpBQKgEGm97zv
	dofzfKc5aI1pZlRSPT++a0HjtqUr2OlyYFa4MlQrhso6oN+UfbURd6bSp3R5nyLj
	1RstWRrOt5H6prwc3d6FfY34ul3xrWJzKir4g8fooxRYp2/zAQpICax2OCatI7j/
	WQ4R19navDjq9lb8WU66CYNNprrnzfsiOnSVIZzrMMM/PYqapA1pez319arLoii0
	ZtPz0CCR/a1yQ4S8Nbf8aA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn8b64gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 02:59:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52P1GnVR036873;
	Tue, 25 Mar 2025 02:59:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj5bppd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 02:59:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGwqgfKNs/z2N21Wvcqs1fpJJX+IJDixt59V10LwOtaNPdlfIc8XyyY2gywHUVsyi28a2xHYKLbtDhuJER99gfLIZlg+lnAsvg8ip9aLum4SW+6fNtoHxHmpCD/0SKT0MENOHb//AbGqurnAKTF6LsamIft14L6uaCXcxnKG7RwfCPsh8NCuofDx9Uht2GN7a0GjB8QgHHQ6OYn2yZYCfHOLw+lBQLqJwxuyJZsbm4OiGgbyE3EIGNcd/UUzcNYRAEia8B5YnhXG6faXomwa/r6gBmg6MMWOVNCmdL5nDycDXC6tre/9z5PL2dRl4caT+3//fy2y1RH1uLMawVESxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWFINftB37KLAAD6x3xbTwO8zKtTsl53hAm6tnUZEm4=;
 b=F6+eKr/W7c/cD8MDWJgEWCZM/+D/OA5Rolf6qMM/BlpyD3ikbqhlB+nojUTraVdTVL8lz3U59uDINrNhADWll79+16I9gAvgtG/iWaEnuKLpMQc/kwlGRq7Tfpkl3jaBqQDelxeNjW1eiMTVSu3nTEsSoq0EEg7qenLeL/toYtKkogWrfPeZV1VyqCZqqYpCvVMHBOXotTA+Gnu6ovlGLy6KYdlvMwrS70GUYR4ORMG1A74vMqRjuJ+6vxNtsYPYeECM2RXQIkZFRzX1G+Xa2SshK2wW4irg7ZYcFx+ylAx4nR8auwmFOh9gYR+ccWhX7uEd2qsL4zGIr8oR5MikIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWFINftB37KLAAD6x3xbTwO8zKtTsl53hAm6tnUZEm4=;
 b=R8jc7PYz+bR5Imy3/yLRFymlfyPxsGjI23W/CIn7zvOm0B9Xai77zf9PAn3+BDgpsDBNzE+MZizfS7ztFS8Jz1FXkvE61v3mLKowguJ5tqvaf9O0rRZQz4WwKkR7Dnj6fSoqrv7uQhfO2+cUV8mCc34Ws35lgasobAozJN3VxeM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB8177.namprd10.prod.outlook.com (2603:10b6:408:289::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 02:59:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 02:59:31 +0000
Message-ID: <51d42b16-c242-4270-95b1-7aad3056a009@oracle.com>
Date: Mon, 24 Mar 2025 21:59:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Multipath bio vs. request
To: John Meneghini <jmeneghi@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        dm-devel@lists.linux.dev
Cc: Samuel Petrovic <spetrovi@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <6fc92ed7-5656-4cef-9f36-fd2d37e56e12@redhat.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <6fc92ed7-5656-4cef-9f36-fd2d37e56e12@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0088.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e430f57-4850-4c93-8fe7-08dd6b491085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTl6SW9OdmlRSkJRQkRZTFl3UkJzVG13RWNaMnVzUnNGS3U0bm1oSFBlVDYv?=
 =?utf-8?B?M1JDeXRVSFpjVTE1cHN1bG9BdjczeGErSU9CNW5GTWNtVkZnbnJpbG95bW1a?=
 =?utf-8?B?R2R6ZXVTWVY0cVhHdEE1aThUdWVJSmdxcjlXQnpVdERSMGpKSHZuem9ZNmxt?=
 =?utf-8?B?SUlqRU83ZGwxT2tUWi81Q1RoeFltb3ppT1A0TUl1Rm9aMWhZNzNHL2hlQXpq?=
 =?utf-8?B?WXlJVUhpamFmTlhWSE1NenFscWlUY3F5MWNPQnpveFFrQTlDRU5sOW1wdWt1?=
 =?utf-8?B?ZDlCdDFOSEI2amZUaVJzL3pXL3AzNGRIb0FxUXI5ZWVxaWFqMC80cUN2OWdW?=
 =?utf-8?B?dkpXU2JTSlIxZm1rd2lSamFiQ3lkRm5QZmIyS053SjdFeGdiSzRDN2FPVitJ?=
 =?utf-8?B?M0Z6b3hTTDROeU8vUFJ5NUgyVTFqaU8xZEdIaXBGc2x4UlF3Y0tYMlB2TkNk?=
 =?utf-8?B?Nko4WnVzL0VVMFFqTlBEKzJ1cnZibTRiaFNJWjFMdU85VFd2YkRacmtVRDAr?=
 =?utf-8?B?Q2IyVEVmNjZCbmtXcFRlbkE0ME5hdERlYVB1aVhJa1l4aWhuVTg1MzhsL001?=
 =?utf-8?B?MDNYaStGcVRsbG1UbHlUUmZkU1EveEdhNHdRclRVYjNseXJPYmwyU2V0aWdS?=
 =?utf-8?B?Y09VNnp0bUtTSC80ZkZuNGpiTTVzczVWTkpQT2dNaFhnTU5PdTRZVmRsWU5N?=
 =?utf-8?B?OG9aRlcwNHN1WEtxTlJmdVN1b3BpQnIyTjlBKzY4Y0JLL2F4YmZDU29JcEVt?=
 =?utf-8?B?YmVYUmdDdStFM1JJTVRCZ3Noa3UrK1FJazdHblFGK1hlVlh5Q2dVV1libTFw?=
 =?utf-8?B?SGlTQ0RGYkxIL3duZGZwYlgzVnhWcmdaTlRzNW94RzRtY3FVbVVCRUdpRGx2?=
 =?utf-8?B?aWZWb2pVOFlzZmRHME1hU1dWcnZ0VWhXRXd6d0Y1Ry9pOU8vcXNRUzE5U21z?=
 =?utf-8?B?RjUwL3pHY3l0VmF0L3ZWd1N6N2hVZmpTdUQwM2dUaDBMblRiaUdSS3NsdCtz?=
 =?utf-8?B?Nm14ZCtSSXQrYnY4TlhVZ3JJZjRRN1Zja0pqRWxYWUZVU3ZHZVFxQlQwNXE5?=
 =?utf-8?B?YTNsczRjdnUxVGtjUWlzVzhFSEdxZERSOUpCdThueG96NVZ6MTh1eUJ4azB5?=
 =?utf-8?B?QVA0bDdKZ2FYbjJNU3lVR2pNZ3JxbHB1N2ZCMUk0K2RUSWJmdXB1Umk1ek1k?=
 =?utf-8?B?QkhGbkVEeks1SUc5UDBsZWxGU3UzQUlaem1QYVp4UTNub1YvYVdudFo2Q3Ri?=
 =?utf-8?B?c1B3c2UxcHZMOG90YmhhMHdXVy9ZMlJQNEJCTUNsV0d2WjBkMFcyU3NrL0ZN?=
 =?utf-8?B?ejVjRHpoWXZlSWUzaEp2ZkVTNnl6YVFCbGlkejB0ODBEQlU1WkZJUnVGYkNk?=
 =?utf-8?B?OTJpU3ZrQW90T1BPUlN5Y3lEZmI4djBONE5XdUpua0lOdzhvN1E0SGNBVC8x?=
 =?utf-8?B?YkZvaU5RYkxQcnQ4Tk9zZnlKOTRKOVpKNE0rSUdFbGc4Z2dSSWhVbWtxL1lK?=
 =?utf-8?B?Qm5IZE95bVdMOEVNbHg4Z1VLNWdIdEQ0amFCZVZwNlEzN0VxL05EWXY3WmRO?=
 =?utf-8?B?S3JPYWR4L0RQVlAvejBXampYZDlrcWJiMllBZzJ4akhhaXlRd0xlSkV6cjdC?=
 =?utf-8?B?aWt4cG5wUzdmamR4NERLQ0lSK05UU2dmazZjRmZpTG84VXY4VkQ3N1BsbVlC?=
 =?utf-8?B?UFI2c1BrTEQ1T0xjRmJQbnE1eVUzZGRhYmQvTnVMemFLMnRZTEFFSFhYdWJB?=
 =?utf-8?B?eGVJRGdYS1A0ODN5anBuVDNYd0ErajAyRDlUSkZ2YkNnVlBpTElmeUxXTFdi?=
 =?utf-8?B?VWczeVFZOUF0c3luZWVlaDBLVDBKWkNaZkZ3RGdyMU9leXJFckFnNFJaZU43?=
 =?utf-8?Q?BfI7KekP7CvxA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHNhUDE2bkdWSWNQSEgzWlBlbHJvQlJidUd0N2JmKytxelBFZUthZGs4aW00?=
 =?utf-8?B?YXhlYXByd0I3N1BSa0hlcTlobm96UXVQYnpHRFNhOWV1Q292WUIvNlVXMnZz?=
 =?utf-8?B?bEkybzF5eXQ3Q1hSM1VNeU5aRHpGam9ZWnJqYnJVaitvOWIycXh3a0hlbUg5?=
 =?utf-8?B?cnovS2Zlc2FZbDBhTDVBM3V0WXY5a1VzN0twVHJLMlJ5b3hveEkwQkZzenJw?=
 =?utf-8?B?RXljMUU0aDlYcXJMa1l2SFRwbHY5Y0VnWEl4dUQ2QXgrR3lwbWJnUDdRVzk3?=
 =?utf-8?B?eS8wdkMrd2VqdHlVVDJ3SzYzUmZsbkZEZVRMNFhYOHJEQ1F6R1Zpc1NOcmxL?=
 =?utf-8?B?SVV3eVdKbVRrVlVnUk1nTk5Ic3FVSnFHWEZYYTMzMkdrK1YvbTdXSUZRTEl6?=
 =?utf-8?B?SlR2OFRjR2JSL29HdE5ldUhSaGpFY056SktMdzdzR01UNkZETGZ3bmk4MUJX?=
 =?utf-8?B?aDBkYlYwWVFMQmpVam9uQldha2xMdXdjV0h1VVRKMVo1WjFZY2Q2b09QVW5O?=
 =?utf-8?B?c01NRzR3TU5XdnpaOS9OOXlKWVNvOVQxTk9rVGlULzI4M2lETHRuSmFpL2Uz?=
 =?utf-8?B?b3FEdWlScVFPRHRVRWc3eTQ4bVdOK1BVRVRIdlduTHNPUitoUnFrVTVITFQz?=
 =?utf-8?B?QTN4R3VwYURSaFhOeEZKNy9BSHRLTWhFSHdTZ0UwRWlrbTFFVnFZeVBzQjZB?=
 =?utf-8?B?dzNyR2NRNUNlTE5uK2hKS0VLRHorTGgzWFhIN0NJMUJwQUJCNktjeXlnTzlL?=
 =?utf-8?B?R1gyZTdISGYvWWNoYmh4MitFM3ZXdUg0VThZckZ4di9WRTFoTUxrZmt2cWtD?=
 =?utf-8?B?WGFQZk5Ecnl5TWhXKzdtYTNPdTNGTnhRdGxMTG5Vc0N2NE55N0FBVGExSU5V?=
 =?utf-8?B?eERnSzkzVklGOVdtbkRCcThvR2RCRlRDN29SOGpTNzZvSXdFM1NZcUZUSXBK?=
 =?utf-8?B?dTR5S1VQYi9pYmN4cUJtbFJraTlKdGZGaDg5cDVQdjhib1U5UnQvU05XclpY?=
 =?utf-8?B?Y3gxWS85ODRlYktpUHB6WVVCV251eE1QTTFFbG1rdDNlVzhyZVE2MGhiUEFU?=
 =?utf-8?B?Wk9wejl6elhETDY4dVcvY2IzV3JTNnBKTTR1YTduUVRoelcvVGVuVlJlUU1k?=
 =?utf-8?B?RzZ5cDE3QlRBYkFYNXRhTGZZVUJTVjdxL01SM21UNFZTdmZRR0VFMmd2bFRj?=
 =?utf-8?B?dWdNNXF1MEhrUWNoTUUwRDJKTUhPMEJaM3UxRlp4QnpzOUFaVmFZVlpZSHc1?=
 =?utf-8?B?QWhhb1YwTmRBcjZhNGRlQ0ZzbUJ2Y085ajQwcE91SU92RnhFcXhFbjlObEs2?=
 =?utf-8?B?Vmt3QlNDQVdibE9EM3d5ZXd3OW4vYjFDa3BreFNXL3pKK3M4TnVZUWxFRmRC?=
 =?utf-8?B?Z2NrbkU5c0N5U1hlWWlDby9xVnRkUzZKQnhTYlkxWGhLdU9ueWlBdVV1ZlFE?=
 =?utf-8?B?d2M0UTFoYThwMGwyOXEyUmZYcmxnZnBPYVdVN1pndzlYMjVYaUEwRHJOei9m?=
 =?utf-8?B?ZWcweldkdUFKZHhwSjMycmpIM2VYMU96QS9YUk81a0FXZmlsTXA0UGpEc3JU?=
 =?utf-8?B?Tk9xWnpCMmx5RFp6Ly9wN2w5cUwyMmMzVHl6Yi9QQ2dWWm40azN4MnlHd3Qv?=
 =?utf-8?B?RjdoU1JDYTRmeFdaeGkxbVFNKzF2OWQwRzRucGZBekFYT1ErUjhEa2dlaGJM?=
 =?utf-8?B?S3pOd0hSMXpPU1puZ3JaVWxZU3paQi9FMGg2UDkwaWtQbVorK2JyNnI5TkJE?=
 =?utf-8?B?ZzNsMlFyUXNQMlhpeFhLM0gyVFZMQjFmN2V0YzR6U0FZMmxld1lpWC9va0h0?=
 =?utf-8?B?UUtuVU5LM3ZNRzdXQUFudExBWjUyZ1I2WWdZdXB1YTJaWnp0c1JCZ25oTEQ5?=
 =?utf-8?B?c3Jab2c2RDU2YnJZNThJZExTUTd5UkJOcE9wc2EyemZZVitzcWxyb1BqSDky?=
 =?utf-8?B?M04xTnV2ZTdadldoSjlUUDdiTWtGUlk1TU12RXorUnBVUjZMT3pWdFIvdUNX?=
 =?utf-8?B?R25aaWRlYUtqLzdlZVdXNlNGblI4ZVlIV2dEZkV5VFViSmc1Qk5HOFd4Q3gr?=
 =?utf-8?B?SlZFM2JTOVp5K2FXVStRNzc1SDdDK3ZIWVZHR3JxUVBRaDNxWVp0dFNac3di?=
 =?utf-8?B?SEFQUnhKeDFlV3F5WkMvVG9Ca0dBNnQ1SVZMYXZpVzZnZ2pzaGFJOGJkSXhp?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b4Ta2xLUHxv7slnwUEeOZ2URUKCD03rMKhGyhw7bRoi7BRHt4dYZqeKF33/EZPWMKe2LqNW3b91n2DsCc/uc5JdQFoUV5KOyKMCSoWR9L7lUxpex4xqfpzaMHNSQvRUA+MKw6v1n3Dr7jVbmhEMvnJXYAu7QkNBMv8n6N8VyYRxlVJCeNitrs0p6+141ft0CAa5y7trVW93gowpIigTCWmJCl8CFXzwllw346CK+xwZXPD4KITW0efjGVYRsPnHNjnYVTOUMrh218L4jUXbbkxCSK6HllLAwlwMfHCfxOoF/dCOFw7mw3HrTWebl4E+y2WqdJG96+DfYhkcm8pgVS4csoQdOqtmgAjq/Y+r0qLC6j4DhRRjqE4HcjUECDkBVBs+3sSvtgKHr5p8uK8mCOed6M3Z2WoSYyEaIq7K67WU1mHvTvcKK0+8GMinSoanaOk3aNJoAUBG1wDkkMsXi6OQClwtgLnCrv6Wv2ScHtJF8XZf4m+50XMFcygQROKhI0AZNcMRJgAGhAqKhpGEZFOlbjeUxtJCpyvLiVVWW5mSLlY+UZ+zWffAN1dHgyWpXqCnEQOL8TXYATBsdV2ecP8NjDqhh+XDxOlntALgMekE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e430f57-4850-4c93-8fe7-08dd6b491085
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 02:59:31.2189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ff/1tGNk8TGpEN1O23LaQD+9RTs22ZyizyOXJvZ2eFToWxO4t8tb33Y9woaFnmrrgKqI2oFMPnjYNwMi2mU1I8y6+bZK+Knl01Ml9exqXRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_01,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503250020
X-Proofpoint-GUID: PkktsfGeI-r2llrzKvId3ioq93oIt074
X-Proofpoint-ORIG-GUID: PkktsfGeI-r2llrzKvId3ioq93oIt074

On 3/22/25 1:38 PM, John Meneghini wrote:
> [4] https://people.redhat.com/jmeneghi/LSFMM_2025/DMMP_BIOvsRequest/

For the tests run in the link, what did you use for dm_mq_nr_hw_queues
and dm_mq_queue_depth?
