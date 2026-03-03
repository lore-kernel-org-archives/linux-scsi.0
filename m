Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082213A873D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557133; cv=fail; b=OZRdQraQIcwiEGCuAJ49Jo9wQrEq12rJ1F7G3yMLgIuIxUmKWSDib+X8d+dcmq/wHZ34sG5LTM+oVAuRGL+6Mz46bYFbWJ8yAXUtixn/BrMxW6ltT9LDMuryzIazlZYoNHeiz6dPtfExFIxVtBO/y2/wiDveLOfmi/uFi15FnTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557133; c=relaxed/simple;
	bh=/Bim8BsqsIlItA5mDQwd/9yrktRu/isPQ4IaM5kaCKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aiwBDVoh3DLM1D4XwK6Knz1eK1GN7z5V65BN2PZLmZhHhi52nFvHaFZLYqFP+Dw5EvvQ3O5e8kFTgaJnNZThVSOrhvfxqo1+ujr7LySaxwPZy5v3R7lBCRS3i3ey1X/dHbULesMga5oSQfe7J3yEndOmBbuNqroqtTci2duCzbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MU50Ipg+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rP9tfVyl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MU50Ipg+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rP9tfVyl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623FrRdN269781;
	Tue, 3 Mar 2026 16:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HxuSCp1VztArrg+Y4BLNOZJiuaYvYEMQ9rLPrLp3Uxg=; b=
	MU50Ipg+lGbI6igyArXq3dFT8IEPafG7cTSa2auw5q5zgGF/8moFKJZ1xMWQIer3
	JllMq4sXH7nFM2pQ48GWrsKFTwtHQm56ViG8KB7b4Q9KVfXFJrQenBg7jVNXCBdK
	ogxz3/aiExsCgH7/L/U//AmjA4h1E2BO3ZGqL+xyKiAaTNZP5BQIiZ9myOsHjrQG
	68BhkeAv3SKrmPzaRF63thyphBJ4VyJXLjE0R80BdWH1d0KLCvH0Dxw4RyqoojpI
	Ix4Uy/0HULeyR26VJTgUpg62SefXHNwggjYMRAzzlVMGgMPkjwFU+0bLNwNshICX
	tElckosizFXASpMzw85EVA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cp2pc04bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:58:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623FvneX037193;
	Tue, 3 Mar 2026 16:58:49 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptaapt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:58:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8pQImxTGNcOQqmhbDqQjz+eBg0/PEupNTtfLVxRagWyn0TDKUG5waBukBIrZMtgQHTOTu2wBMLk2N+jYg1RLCQaoeKEmdfImzmxnUBsgihYlSfUFfdaYA3uFOZ2nkJZtE3s9wBVd0TahFXD8urKslc778UUbF/4QltjeRmP735zElJcZjI1v9GYulM0gaIxcFPyGEehQJqFackVG7docwLtL0UOlSMSO9KpU5eDQQu9RWXhl4eOHvElobR9BeHjb7GP4tbLhOdsHehxWqH5lq2Iam8LOBjxn2pOjIbQDSnVp/BEGvaP9U1uMc2ccURllmYAyRZyvbBml6LG09A51Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxuSCp1VztArrg+Y4BLNOZJiuaYvYEMQ9rLPrLp3Uxg=;
 b=htQrfuW42m9ypgSMc27MxoqxPGy5TjTw4xMCQONwQ1eJLz72lbB6HINRi1m9VFgfF/tpeNRKg4DyE6vKlRLnrXYKT+Bt1Ves8xTrs+0idqyEvKccQCL4SHR2GV27yG2+qVhIoEchIHP2fQR60rx7nAVqcO9Phxk835cQA3txAqX4pgrwvZ7Z5ucPU3HFfKcOUZAZ9MX4caG3RNfHT5sGQkU6jWWwy7oOvaFLhon41aEMVkO0VlwFW/N1IIYnvqy+CE4t40cd94EoHsL2UsF01S6B48FtAJYMHDOQgfuUdcG6T+Utvl4/zhoEyO/aF/rlEvVr1BfSirXxFY/DKNkERA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxuSCp1VztArrg+Y4BLNOZJiuaYvYEMQ9rLPrLp3Uxg=;
 b=rP9tfVylfibgUTLUSOcRz+dJcpwxFHCKsmK7RDz9dIBbqqo2LUz8/vSahja4VPUBfAzrCTRe9pCvDzuNfftTMSBdJsebOWTMRI0zMvoe7BaKWddQionbHSXXoLePAdeWMbVd6WOGQz4qsMiF4uuLNzsHIy/eMcwxPc6+Zi1RKNE=
Received: from DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19)
 by SA1PR10MB7814.namprd10.prod.outlook.com (2603:10b6:806:3a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 16:58:47 +0000
Received: from DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba]) by DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 16:58:46 +0000
Message-ID: <998ec91b-3b31-4ba8-81cc-382505f2a249@oracle.com>
Date: Tue, 3 Mar 2026 08:58:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
 <7ed13647-8b26-4c88-b1fe-af6c3ac41751@oracle.com>
 <e2d21ea3-bcd1-4502-9936-e54ac9f5f96f@oracle.com>
 <99a40eeb-497c-49a0-8f7a-8075800c1dce@oracle.com>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <99a40eeb-497c-49a0-8f7a-8075800c1dce@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:a03:80::45) To DM4PR10MB6885.namprd10.prod.outlook.com
 (2603:10b6:8:103::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6885:EE_|SA1PR10MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 8051adbf-7f27-46e7-f521-08de79462222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	nqJLh0eKfXHYGuuBqNxe9smWbRIugojzFMmuoJ1D9wqb6APk2QNlaKcNb6WN+gKKDMdQEJmBz6OqTE9bUTEVbtfdXiy6fWd2uemRDd+nxBq+L9Vs5Py2dMA+bnlt+OxVyx5UH8b7VdyCiKAU129biqw5NanRnarr1ygqyl+vxbJ9veGJ/VjCjti6UWmdBFAa+Zuo89I8tosK2oP+ELWh2AjhMwJVh1r6ZJ7ain9e4o6doUQ7aX55KytKWH6eRDEvf0rS6DgAiqyUPY1uHrWGt8A5Mw6x92rBy7P+MPxqrD+A8tKMEHlpdub0QXger2B5lX/bZttbyPEevLO6pG0Zt3gf/5qBYr+QBzYjhYC8SFY0+s1DPF/SOBbhFQ2vDFnxsm2H232oRrLTfsaGVXoAJVsuAIdS99r6qgH2NZ5PNoRhjtr2j2ggTVeXmfnnaD/yZlkwd1ZPffv8S1M8blKproFJ5PDZ3wBDKJkSw8mIf5N6oy0VIWm9y0oZZGdUuF7bIfga1Sc4hIrL2huO9P4JS136jDq58CvaruTZVvMjCzHSihtvED78nsG0/JNDYoXaEhWnbZRt2K+7Pl5viAnQRj578crUYJs7tbEjLYaef7hVPNQfEQRGRaLUAziGNYaWJgfhbjRxKGLcGVLGu40dtu1+6usovde2l08hcN6k7k4CR2xTTX0u1Zjhd0IR+K/wlm/PzbegqHjGjYxXh5utZq3SDyroxazapJVhoAtj3es=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6885.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzRJQUJBcUhYL0VlaTh5ZE5YSWNnbG9la3VBTTJmOTlSK1R6UnBXeVdtd3FN?=
 =?utf-8?B?TCtWL0YvWFJOSmRZQ09RckJEeGFvd3NkVGVzQmhCSDhUWEJzc1ZZT0VpMDRT?=
 =?utf-8?B?a25iQ2doY2F0dHZnbTkzWTd1WFFaQ1E1bVYrVGtWUUp4b0J6S3IxakZFVGtS?=
 =?utf-8?B?Y3NidE5jMkhMWmFyWitaNXFtbWpUaTRaSXZxNmJSaEhvTFl6cVhUUUpPRDdL?=
 =?utf-8?B?VDdTdTY3MndZbnd0RFJzT3lmL1NBTXpWRTZ1TFdKcGhNYjNXZHhLZGZhN3lt?=
 =?utf-8?B?ZnpnZXAraDZValprcXZwL2NIR0FVTkpBOVpWOS9aZENoTk5NRFFjbkVpMSs3?=
 =?utf-8?B?N012TEhEeDRGY1pHVFdSZE4wckJNU1FvaDVLdlNodlBjWVhUUmVMQVJERWZs?=
 =?utf-8?B?MjU2MXpYSlNnZDNYM0hhVmg5REV0eFpvNjBjRjdybjYxZUR3ZGs4UEY0V3pH?=
 =?utf-8?B?RVhuSFVZOFZOd0dLUzVYbHhDQzlFdlJaR3RlMStZSUJzeGY0VEpwZkJlTUZH?=
 =?utf-8?B?SDQ0R2ZhNlJQMVZvNXNjQ3V1L3FsV0Y1THF5TnEwa0VUUXhJcXlDOHFNK0xy?=
 =?utf-8?B?NmVSOEJ6TG16M3JWdDRPak0wU3BTVVNLUGJycjJ4UEc3ZGMwTDZ2WkJUcGJk?=
 =?utf-8?B?RmVvNFdiU3cyak9tVFZqUThnM0thOVJpanVHUlpYenhTZWlsdy9MYUFLZjJO?=
 =?utf-8?B?OWI1Tm1uZlFWejdaNjA5bVpHV29HdDNjOHkvWHd1L3VvNWVlN3dxcWxEaGpa?=
 =?utf-8?B?aW93RFBnSkovbXJZa2h5eFJ0TTdYTSs1My9reGgraVIzb3J2SjhaK1RUQVc1?=
 =?utf-8?B?b05vRFFmNTd2SHZQdlhYcEFPKzFRb1FXOVJNYUdSQTFWd2haUkZmRm4va3Az?=
 =?utf-8?B?NzBQa3ArZTc5V2VRNU1aNnh1MTJ1M3ZpRjA5M1FvdzBZTCtFNjM2QzVFL282?=
 =?utf-8?B?RHl3Y2Z2bDlFMnRwL3NvOWExNU8ya1p6OStCZnl3MGJhdno4OGZtdnJha2Fx?=
 =?utf-8?B?ZlFmbWloYTB4Z203N3MzZGFYMjBVWlhBbzFjdVJ2VHNqQkgrbTdkZlJVK0h3?=
 =?utf-8?B?R3VHcSs4ODRuWkJoc3N5YU9OSVJpUDlXUTBUaHg5eVBySDFEVFFKTW4rbEg3?=
 =?utf-8?B?dkJRcTdZcVArNzE0bjdDSGV0akEzUlNWMDlhOTJLdWliTlVjUHFMZHpJaU52?=
 =?utf-8?B?WnlWWDBEbzY3T0tsVUw1OGhlc2JwQ0JVZ3ZnSW5GY3Z0clFkSzRIOVZGNGpS?=
 =?utf-8?B?b1JLODF5a1lQM1htQlgvV3Y0b0lyMkp1OHgxUVE1a29EdnJFRllnb3VZTVBG?=
 =?utf-8?B?M2JjR1pmZkt4dnBBbVRvZUVva0M2dkM5N080UEVjVytIVUUzdnpabStqMHlH?=
 =?utf-8?B?NTFrK1V0d0h4NVErY3JaT3k1bFBYZnNtOElWdnFQbzNLOFNBcjQ5bDJqNFAz?=
 =?utf-8?B?cS9Pb2t1Zlo0RUpncGZiN3lzRDRzMTFadXJLTmY4WURwdDRPeWRDMkp4ZDJq?=
 =?utf-8?B?TndjNEw2YlNBZEpxdlBQeHlQcjJxcDloTUROR1hPMXZSR01IQ1pVN0IvT05R?=
 =?utf-8?B?T3F2aEdHVFl2cXZzMTRPQndTaDQ2eVhycDEwSmUyTGNmVjhNZTcyMCtycWFy?=
 =?utf-8?B?SnkvcUhDZHU3V0dhOU1zbWNPem8yQ3d1OWVOa0JVd0tOcDNGNmtjMmE4b2J2?=
 =?utf-8?B?V2EvRWNGcjBQYnRzaW1oUWs1SDZ2c3RkQk5Ib2tEdGdtKzBZSjhmd21oUDJN?=
 =?utf-8?B?dmFnTFNMYStxaFZ1a2Z0WjVTOHFYNGNQME5uN3NsUW1xRXhNdmtYQUNRNEZN?=
 =?utf-8?B?bVRMK2dQdHR6TEdxb3liWFRuYVlJWG15WGdtRndCdHRPNkxSV29iT2pBVGw5?=
 =?utf-8?B?a1NsRkhFZlpBNmUzU0FJUVZPTWdYNmk5TE55VDBBNHI3TTJoNmNWTS85RlV4?=
 =?utf-8?B?Y0hSVWd3S1hhYWdRU0NpU1RxR09HblRyc2hFV3p5cnJUUmFaRDBFcmNHRnVX?=
 =?utf-8?B?MDUxNGlyVHBNS0JEZGxDNmR3T0VSZGhRWlovckpyd0daRjVWd01ST0hxZG9a?=
 =?utf-8?B?OHdzblMyNHc1d2t4b2NCMjl0NDZBYTdvUER3UmYyUE1LNXhSd2ZpMnlaN01q?=
 =?utf-8?B?UkExMldMNUtDOCtnMTlrRmcwd0Z4UGw1bWVlaVZtUVNiUEttSmorV3JWMzky?=
 =?utf-8?B?WVpwVWllbkxIR1Rsb09mSi81SllUeGtNbjYzWkYrUlI5RUIvenFqcXhhNktp?=
 =?utf-8?B?NU14Z3ZwZmVQeWQ1RnhkU1JIeFJyQ3VXSWdGSGw2RTF0K2ZIWG03bHZYelI2?=
 =?utf-8?B?N1pqMHFzT3cwZ0t3RzdDcTdjTUFxSEtORElROEozNGxnRTU1aUdOZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M5+scdB+luH9xnluPsZjg9Zwlm3ZWTlCEIXgi+XYR/TU/ENI9/+xO++SHG3/y3v1d9x5sZAJ2TR2oXGiiJIbSDkvvyEvgq4hdLg9NmH2ay++2Ao3HHqgV/ppCZqZ5RRY7mKQ7vMXmxvsOwoh28ujwCDLChugt46Dxig+vPDpF7fYwEXbyZRfxHvPHuhd7B9d4r7mYXE+dNYsYmgSg81Lj6kFcSfD312FqsQNnBQ3XbXbiNnp95xJ7nudAZvbO5EAS/fQM/yLvHtTZOcWs+INod+5etRuxdpM+R71BEC+AAjdNof7PQjmp36ecwJ3fAzfzSc6evwOhi6EJ2+HbQNrWcyETM+074/ysI9btIo7eyKVfVVvcStdUX1XCp1oYAlTeAaQK/I9fb2f/V8ztb0GdT/ubbcOPywrDXgrpxKLa57vVbHHUZMtBvYV8PQZMl2SgVzy73mPgjbEFkrnqcQT/eXPxdYfab9DHjtBrLqfWZRHvsNwb6rDFh+5Z5Qqkn2oBi5aZYjxBQT29BsC/BnHd3t0Ym/xGkq6lY0nU35Rbmsb7U20Aui2dt4gBOn9R8sMMZDbLPgSFMEsn1OATVFXM8GFpjMocqvGklOYBfjWUY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8051adbf-7f27-46e7-f521-08de79462222
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6885.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 16:58:46.3716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pjyJdDdkY8G+jIXl/7jGy1VqGzQSr5He5XECdQGDxTipeYEuGo0aF0y2M46fDTeDPhW+QD1Yb3Vuuks0s4B5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_02,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030136
X-Proofpoint-ORIG-GUID: YfOTLwDubjhn8K0Zwesmv4grlthxdJOr
X-Proofpoint-GUID: YfOTLwDubjhn8K0Zwesmv4grlthxdJOr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEzNiBTYWx0ZWRfXzDCK/upVn3ju
 zTXIT1+9vE2++AXbQ+h5HjgeuFgotT1aiIdEbSHIuciBnBnh4zWH/I18QZIeXPTGjDzadOk3Hzy
 vEow2GNPpMqGpR/X1mcP5BAFhYLFEuPQtN1Gsm7vDcFVLq3X6lfly0VvuNeX/tG5k7jlKdTeMMQ
 NYAOOddkasyu2MRtdxTPQrvm8bGkGfV28wUK6UvY04ky1QjrK8i6n/OBt1pglcsD6sdYOfxc3Kw
 C2YZLaMYjVx63nYQNFw3/+me9aBphPk4EUr1/EVw5Fv10pxyoqkeek25/jA317XaB7LweV4995Y
 xXSSTgYdUXlFIfiy8mtB90sU1vdWemUlc6905J8MVZzdG6JJMYYyWrmHowmHw7XswU6pivA6SS5
 G/Qu11DqAsF2xu3v0fzk1dGJ4TpHghUpormppHJkzTRROceWAA1CVu2yBFq83TujGKdpog0xfrX
 A0aH06F8d3y3YjiKJxw==
X-Authority-Analysis: v=2.4 cv=fIg0HJae c=1 sm=1 tr=0 ts=69a7134a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=5n28RaR_yiWVnNkTX30A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 3/3/26 3:06 AM, John Garry wrote:

> On 02/03/2026 20:36, junxiao.bi@oracle.com wrote:
>>> At this point scsi_sysfs_device_initialize() has been called. Then 
>>> if you check the comment in __scsi_remove_device():
>>>
>>> Paired with kref_get() in scsi_sysfs_device_initialize()*
>>>
>>> So I wonder why we don't call __scsi_remove_device() instead, which 
>>> calls scsi_target_reap().
>>>
>>> Indeed, the current error handling in scsi_alloc_sdev() is odd - we 
>>> only call __scsi_remove_device() for ->sdev_init() failure, but 
>>> nothing happens between calling  ->sdev_init() and after 
>>> scsi_sysfs_device_initialize() which means that at this point we 
>>> should only now call __scsi_remove_device().
>>>
>>> * I think that should be scsi_sysfs_initialize() and has always been 
>>> incorrect
>>
>> Good catch. Thanks John. I will send a v2 with this:
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 60c06fa4ec32..c2f70de5c093 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -361,9 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
>> scsi_target *starget,
>>           * since we use this queue depth most of times.
>>           */
>>          if (scsi_realloc_sdev_budget_map(sdev, depth)) {
>> -               put_device(&starget->dev);
>> -               kfree(sdev);
>> -               goto out;
>> +               goto out_device_destroy;
>>          }
>>
>>          scsi_change_queue_depth(sdev, depth);
>
> NP and sorry the late review. I think that Martin has already queued 
> your v1 in his fixes branch...

I see. Then i will post a new patch to fix the sysfs reference leak.

Thanks,

Junxiao.

