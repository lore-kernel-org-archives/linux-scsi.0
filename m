Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737C147CA73
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786719639; cv=fail; b=e+6/zcPmTWAlWphVxRqrW8YE/oVwSNXGPk6gEppTcyg5DmKVik+gN1IbTgCwAQ2PC3PNn4AgLPnH7FmONuZCMp7s47LC9IaEk7dkynBWI/1FlfU2tcCm67A9xs9m+BAQiq7J0CswVNiq9YLowghL6ZTPVoHIu81Ys8iyVw6rwnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786719639; c=relaxed/simple;
	bh=wiW0vbIJEGMorPTlSSiQvDzVPPRm2ZrpYEkTJzg4swo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KTeMqYsV4wcQT+BZI0Zd02JYe6uPZpAsgSzkRvUBTJUWJQK8Gj2iFZB3GqvT13GLhndAxfm/xnCvAw32W8S4bjiCpiP6Kpbdsvl6jjdMUWsKDCwkMPxqDH4i/RpXqiuiM11Yolh4iJDzQojSNIaFCTYFcbv9+1AtzxVSXb84994=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nMCLnc5G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gQTwEFUw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nMCLnc5G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gQTwEFUw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDOw6m2208333;
	Fri, 14 Aug 2026 15:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ESmBacLzO5mvMwTvDE/QVNWLu1xbfwEu4is+TL9xvXE=; b=
	nMCLnc5G5mXLz8SRm4Ztz/o6n0/UmR2nlYxQpRLLqrjmXkd6uBMDf2T4VO67PABb
	AN2juvBd3asr3tzk7ULI7dFkZPPPO+YYpMUTAGC+oLGwFtZi1swQ4Pin9QVU+g49
	h3csKs6XnqmmSx8lrIl4zByF/LX9zCiqQv7YQMH5FwWU1eYnKIWYvwbUBxjyAmX5
	0qf4PX8JXt1qjv7zjAisjV+fcVPg85nB+J5H/VZlqGxSdziA20fhnn+zf6Rul5KZ
	OzbZ4jF0IUolO2lcdIQiXe7gNH3EHK8xp8rQASPcQCmHE+0t3EMWLhJrL7xQxRAe
	RLttfQZAZGPEJMXps0S3Zg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvet4g3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 15:00:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEt6Qx039776;
	Fri, 14 Aug 2026 15:00:00 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwh62ma-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:00:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO+jPRCXlYLr9XYRwawWC/cXDzJUS9yko692NYlNQ+Q7DoFixNXCcC0uKWn6AqwnvbloPgyFEQd41OrHXj/yZXOVOwPyR/PUH72SLHg1NjxCNJDsR2pU7RtytseIZd8re9NRTiSalDIfSfDYYK+YYzKCHZkPWVQ//1liT0EFrLm5It5efiyVLvXM1+RKML8MNXYn8NG4tw4WI8+0swwXMJu/SVVnr8SJcmqFKGi2ULuNxtVV+DMRvOYLjIssD5lNsz4hWqiVXtg7pRqrao+lqstPlbVd4f1yAtFcBF8YRWf5RkqOBGFCvDPSA8o1dZNl8+tMdH/iDF69KLTUR6Vblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESmBacLzO5mvMwTvDE/QVNWLu1xbfwEu4is+TL9xvXE=;
 b=iAUeZ78yHGlROZAduEPucWUWif9LCMUO+9CW1DAQiBYAKcBpdoi0qnINNC1xM9vvze8n0HrrqhmhWd8dErerjduHKrhL8KUy2E/r4z283JsS15mAvjZ5/tR1gbxYNvJlqC8EkMrBVSzytJ5D3eA0w2tPhacop82gfi291fDhoC94CVsUZ0qeCuqq2IcC/qFwxjrzg9a9T9pYPEBvCejYknOexYHeD7d3WZiyxczum71wJ+MGYiFkJxMhuAn80EoWS6nis/LZTxDjIOJLVGXRQ3VXv4aj8ARfymUX11odpH22i1cs5gkih46TfJRFwMYlHf2u/aeo19gwpIa2qpafMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESmBacLzO5mvMwTvDE/QVNWLu1xbfwEu4is+TL9xvXE=;
 b=gQTwEFUwUW8E71MsOQX+Cj/85AVTVAOLWQR/WAdqUgyz+76Ll4wSakrWBZ6Il2WESSFNvAuXZk9/5bCWcIIbcVmIyTi1qSqQAdgM3Ke8uYe4ITKdz6YByJlxxus+WBHanKldp6SSLw0aFdVPWQEsBIRo7GMxZCtw/5UIiL+2/g8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7783.namprd10.prod.outlook.com (2603:10b6:510:2ff::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.15; Fri, 14 Aug 2026 14:59:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Fri, 14 Aug 2026
 14:59:54 +0000
Message-ID: <3731591a-f495-488a-bbe6-96f4ec2acb78@oracle.com>
Date: Fri, 14 Aug 2026 15:59:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        Jianzhou Zhao <luckd0g@163.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Dongdong Hao <doubled@leap-io-kernel.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1786142946.git.bvanassche@acm.org>
 <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0248.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 531dd86f-6afc-4cce-c0a7-08defa14b2d0
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 o+WajF41hSY70FQHedaUx/SP/WtX6IVSEJ3xcz6Yj2eixijetP3mnGmhyDxpLXlUw2YuVorDzX89qTJW999lbWaZIK5nEbywzLqQHkYPEU32FSRpKK4UC7Q3mBuHfxLu6Per0VD1xrLUtHVIPVApy0jrNu4KQ0R9t7IrR8I/2HCpjl2JBs6eR56JEuWcdZe4Ac0tU32xSFkprd5+I/EcXWd3PJzdVThLjHVjAoeusOW80CbSEZtCUeqVgm07030l0O2wFqFbN/QYviglGONg8HkBVJXjWsBpQFZwla4RSAwS7yFB+TCcbWXCaFFWA2BMp2EEY0Y1asLgQtSvNhc/TRLu4XUsJ6RqzaseAEJ5v29aDR9J9Rnx9AWBxOJwNPOyjh1yOZfFovZyE48ip6dKhX5KmdNvCHnxLYV/9mhr6N/XAEYf4n29lglFFO/8TlHLu3ykdK707XPkOV2RGNJ+SJmbutILoqoK0mK/lk9VNqWxdFZwnSRl7ZmkFFGpdwYzx9SToKqS2nihHJzmkHosJY/HiTePIl18gRpv23Mpaq7MFFDqwzIm3B1kLjku8WywIpamfbLZ2pE6apBrnTGKp2bTygNZsmCYkvbjD/mFsEGz3f73x0MXott1vsLVKk2bJELpcRE8tAd8NA+vKPq0GyROLPoy4RzldTqW38Io1t0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YWtKT29MZEs3bWxtVFRhWGxjc0tIQ3VPYldCZEFrRG03T1dMeUNWN2xtN2JD?=
 =?utf-8?B?cHpkQzJoUXI5ZGtPcnZ0Z0xCZmJjL3A4d2FuUWw3ODhXd0hDeTlFdGFZZDlr?=
 =?utf-8?B?UkN0alRnV09RTTllcXdtVTIyNEFkOHFCRjBHUUltb0NnUmcwYjNkeVZWUUs5?=
 =?utf-8?B?ZnFORnM4d2xadm5uTVgxeUh5aTRhdUZpWjZBcmpka3VFaGV3aldUVDhvRTVa?=
 =?utf-8?B?R2ExcHdCSXM2Q2dWRkJVbWF0eHJEZnZMWEdlSHdkMUFQYnFZakh0UENXTk1S?=
 =?utf-8?B?TGRkT3BXelBiTXR4UTNVSUlJeDJUemVqYnhudHJkcVozZHBMaUkzVm5JQ1pI?=
 =?utf-8?B?ajVRdlQ0cXBrZEc5VDJ1Mms2Tkl4N1V4YTZGLzRzVDZ5ZGxyOW1zM3d1Y2JK?=
 =?utf-8?B?eGV1K3E4dUtuMFc2eWlFR1FQTnh2YUNyTk4xZUx0OUJaZjV3bk9nSFRpc3FU?=
 =?utf-8?B?bG9na0FtT0g3T09mRGZyQXlyeWwwRjZ6MHhHNnVJRFcvQllpZjFjT1kxWFdy?=
 =?utf-8?B?bFMzZWNpb3dSaVJxN0F0UVZybTAraVpSa0NNWi9oN2ZkNmpadElnTWVwSHRB?=
 =?utf-8?B?anM1NUhQRHROZ0xjUjNrY2F5UTVlS3BoYWhBUkF0N0JLZVczLzVhRlZ1alVK?=
 =?utf-8?B?NXVzSHFPd3RPbC9qWUl2SUZmeG1Rd3RUbGwwOWN2NjlTZXJXSlNVelVVaG8w?=
 =?utf-8?B?cFZpbFk5WU05Y1d3RGhwYVBpT1NNdHNidmxWeU9WeFV5YW04KzlyOGIwVlBF?=
 =?utf-8?B?RHpiT0FkQ3FrSGJPbVRWMU9MSjRFeENmMmZCcmhvVnRVWVo0dGxuaEJUL1FY?=
 =?utf-8?B?Z0swY2t4RmxGYndPVkZNY3pvWDdhN3NuNjBtYmpzR3V3WUpNdW9OV2JOZ3ZJ?=
 =?utf-8?B?NnVOWCt4dFRmY1cyN21qNk0yYndnTGpXbFp0MVg3eW5EVGVua3FlaXJSRUtQ?=
 =?utf-8?B?K1VnM1hXYUN5eTcydExKMnRvRVNTNXFMTzdRNWpJQ2MwMkVZMlNoSEU2Zmtv?=
 =?utf-8?B?TmtSbWF2WDI5TDJ5V0Jyc2o2dE5aS2JCekVUUkZMYmFJZzhiTERMUVVrOFJj?=
 =?utf-8?B?QnREcXk3VE9ORVRLdjFxZlBFWk1FM2dsa2QwU2xqTENiUWFYb2pZSVV0OFp0?=
 =?utf-8?B?ZDlsbDhlbCsyT0xNNzEycXhWQnI5NUh1YWxZU1RmdnhTK214Z1l0SDFDc2dC?=
 =?utf-8?B?dDJvSTdSS2Jkek92d3FLTndndVlhNngyM3BROEp3RHFvWnhXNHVQWXZxSnQ2?=
 =?utf-8?B?d3NQTWUvZDk1THZLbmJ0N3RMOTVrYlZVRmNNZmRjbVJodVZ4UkxkUG5PaVFS?=
 =?utf-8?B?M3VFRVdKTjh4bS9rRFBUN1YrQUNsOGExYk01UXVXOU92WjZLK092dlE0Zyt3?=
 =?utf-8?B?U21sMmZWSThFNzZoUFprQ0hqaEhGeFBkUit3TW41cUNYT2Y5VWV5SndoTlVm?=
 =?utf-8?B?QnZoK1dUcmxKY3JMSittM1JkNW9sWkNLQUFQMlZ4cFNUUWtmRHlyWkdKcFNk?=
 =?utf-8?B?eVVjVzJDU2c5aWpQRUxWR1pFMFplb0FZdGhVVXlONlBFZUFPQmhwaWpmVGR1?=
 =?utf-8?B?Q1FzSm8rZUxFU3NlNUFmcmZvZldRT01VRlhwL05ZQlJSNFhPQlVuanpUcjFv?=
 =?utf-8?B?Yy9EbG9xS092SXNLWlNlR2NPTmZ3cGlOeElaOTBnRTAvbzBHSnlFbVgrQVht?=
 =?utf-8?B?eVpyVDJ0S0VKcVpNYlV2Z2tYSTFPNDlEbDZPM3gvQnRuUGE3cnZqclcrRmdo?=
 =?utf-8?B?NDVBRkJWdXcxNHZIU3MyVnJvaHM1OTBzZ3JSYm1id2hUdExCSmxZaTdLQWNX?=
 =?utf-8?B?eWJsSHZuT3MwWmdnaU1KNWNUT0FCcjVoTSs5ekdIM1dMdkhLWXNZcUpTMEdI?=
 =?utf-8?B?N2JIeGxtRmhmbDBxNTlIS2hyeEJ2a0FpMlFmWE1pUUsrRmJsYXAzV244b0F0?=
 =?utf-8?B?Ri9WQy92ZlRHV2VPUEVQTVRkYkFkWFVoaXFDazdpZ1JKcUJxZkx2R2VLMG5z?=
 =?utf-8?B?Mnc1cEllZUJpUE5XdXpNeCtZR2M5STZaVXB5VU5zVWdzU2ZjREdhcUo4bVhE?=
 =?utf-8?B?bzIxbWFNTU5uUE41WDRILzBIQndwZlRLWUo4ak5KVTNOazhVcEExakVaQS9X?=
 =?utf-8?B?cmR4azNrWWdGWGt4TlltMjJPR0ZWTGhHY00reVNhYlcycnhIOWRZcmpPWE9p?=
 =?utf-8?B?VU5XZ1h4Ui9GZTFCY2FyREZMNkZLQmxNczRLOVl2V2xuTlN6Zmx5MjhUOGNm?=
 =?utf-8?B?cFlSaGhKay9Ua2VQdkdobGxyenB4MVVScFgzcVFXdDlPSHU2cEF0OHZHdGhL?=
 =?utf-8?B?cHZ3Mis3YmZ5WFlLQ0hUcys5WXhjNmN5OExxZ0k1YUFkeGg1T3BOUT09?=
X-Exchange-RoutingPolicyChecked:
	gc3bh0NKoK3BR3bQGbIPCNR3nYxDpb+Y7gY6h+QEoBuOxDgJZMuGPdjqysHist8KeqwsesRGcqXT2MLdjDD4JUXVgxMTjjcIlVGCmxIs8Lc2ZmxNN0xClxn/Ytrmoe1kGhBStR9BYdmL6MujBzJEFbUfpZKnZFi1GpWYnHhBh2hPG1h0bteok7/U1KSK89hleN2WsY4fFivL0LlShz+F1GApX5jHLz3uHMW/nxXEbAkiwBS4SnOD+Y/gULJ+PH6Yz5SzNb9htvOXKSck58MJafLEsd4ME2N4CCSrSwcZxkrNgEqHrnbvujkP/xXwCCJcQBeswBFM/QmC8cL2qut1og==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/wIUrHsxHpwX/UFsVCxcQZSeBGxrMg0ZGB9A3X5Kf8WX/wbFO4gNT5RGpjo8xVUh6w6rk43uV/moiDIav4ye9swyJevKg3fCtrURBd82AGWb+Ztwr6GPmyS8/H71cNKMVUFjkBH1DqWEJUz6xqXYvK4LoVcZHQa+B6zpRsCUlVL5/5E4O/8HRoUndNMUpkOrL/cuj4wBhmp0ARohcPAw47lMlmBgVD+z0AWd2+l4G1LsEe/GUSOKHGm2aNq7mdLTTnbLPNW5/laU+rQCyXHeucH3uyeeEHUMnRTQXbv4qVXzgw2dxZaLcwS9d1t9SyFX6/Sog/1qvL5WZvDw3z6DPZwcx1LQfIhD5NiK5Jz0Vti/ESo+jzWQ1V7QL7qhDEkX56q1VHIK5ljZ5tHBA9MAF6XBRynaI5GbwUx6akLWA/D6nkzXeLjtO3yYsafxeOyMwcypKVAgGbNCdUIqq2gAyISb+xiiq0VBm6zW/S1ej5U4SmHnEEm0Vqtp2rH/KtvZUr1NgDcieZNDFWLCUBTXrylttf5eIr9N4pfp4daKPvNb8YOAo7ZKGnlFzwA4VyJY6BE3NYNSGz3WcTo5icz14Kml7QswPHcNteNf0tWH5LU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531dd86f-6afc-4cce-c0a7-08defa14b2d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 14:59:54.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCLVsddVtKrbpqIKf3nCaH6M56EbwapZnGBK7x0lUxipvLJZeLU5BNb+JNZuzZP9R2QsncHo8OiI0uz8dZr7mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608140114
X-Authority-Analysis: v=2.4 cv=R8wz39RX c=1 sm=1 tr=0 ts=6a7f2d71 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=HgP6pfwkMzoMc47qGR0A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: AYvfDa6dU9uriAXJ1tLxGcg4OZnug7y5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfX6clVpoteIiZO
 bKOChjKVprKMtxZ2LqjAQRuDAkN2CxHNKJSv/ra2Babavzw/yEKbsoitJxdDhXPYjqm166xMcF3
 J2oHFLLlsE82qlZJYfFoa0w9auZdoJBZvE2gOzdgxbFVy0za4xtSTcyCipgM4Lajd32mK2lcCmu
 o0PggLDtGDFRKKENjV9Ow4B1ZIALlS/S0ES0KaRGov9tzdlXFNaoW+eCSEwdXsdYh7jquz6bexq
 j8a4fPxGp/JjkbBtz4E2UzmSLrl7Tmwl4s6ZsxkdWp3Yl7R2CmiBAFytefPmjDMGIHqvciD/LZA
 dIITd6PUc0KJegKwvDUnre6uC47uoKX7BQDmDe6L+2Bp1+JVza7avnoccZmEZRPAmjosuD4+iqk
 6U0PPY4YyTofrX8eWVuQzVJMJ8ITYpjwaBP/w0qjEWqp7HTMsPv2jcXqlRRpCWYbsX8rc6C0yki
 C5n9Bzu18ZGlOpiiAkw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfX+1SabvWaLIod
 Lre6g+xOkxz4WDAChUxo0ne8xKhheuOhVNorgg+WvVUE3cAWmeCqkQ1pZNEasXhrJz8tJyw9L/h
 dOEphIVdt3+FL6bekTjr1MajNhD+Q4rOPYU2y2Mm98ETy6nYwBzf
X-Proofpoint-ORIG-GUID: AYvfDa6dU9uriAXJ1tLxGcg4OZnug7y5

On 07/08/2026 23:49, Bart Van Assche wrote:
>    int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
> +	__must_hold(shost->host_lock)

Hi Bart,

with my changes in 
https://lore.kernel.org/linux-scsi/yq15x1dtp3r.fsf@mail.kernel.org/T/#m064c12513575565cc08afa15738215b98bcca142 
on top of this series, I notice that the following 2x forms of 
annotation are compliant for the context analysis checking:

__must_hold(shost->host_lock)
__must_hold(&shost->host_lock)

Is this as expected?

John
