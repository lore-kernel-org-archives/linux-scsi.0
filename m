Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C612FFF8D
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 09:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110962; cv=fail; b=SH+HmtmRx3G+1TX1lPF16mgV+R5XKZQLY/yN3oOL7Q9T6FDfZ6y3oA2Vt1HfJWK1+eIzFLpmtPjxCq0T1tSV4Vrkrqttdw0Ojwp47LnH/lqTMJ8dLlwr0TEzYVo625mM5xG2gKvsnFNpa3oVA5R8iYeg4X6zG4TCFrNIXTq03nQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110962; c=relaxed/simple;
	bh=WBAGTqdRz3OraiclXB242+CXH9URKI7PzLBB+KJ3E2k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ETKzE97tcOqtwXiUcUYdV1Guns9Y92d4QwPlcvfGMqKGLRX3/8bSCIjw2w97EFMTkKrXxHX418s8Clt1D/fbJZs16T5ujQ8wJ5/VB4g7VGz+1JXmiCJ1Rr0yOQRn2ohYjVgsvDZy4pLuNIwyoj0Up1jrzDxJQPJbnpve1nO9FvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c0b/cgc2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K5y5XR9r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c0b/cgc2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K5y5XR9r"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AE1gZO5021250;
	Fri, 14 Nov 2025 09:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fAGbpfj8no0r4gGXWiGuy+yVGEpAQexL2yM9zR6uJXo=; b=
	c0b/cgc21wUfx6AvZd6kE3UdCait6iUFpf8FUBUzDBvMahEKBGqwRJ3k8UmN7Sd4
	aDWn+8c8LfrAq5vskm4ERMdaUIag/JOsoVEPoMoDUS+O1jYaCtg176lSqamtZGQn
	xZwXXwhNYiCcO8bkMP6Yr8A9gbdeWy1bV1OgwV5tvPexFpIggcrf5fnmV+AxJ0Cq
	RXXxOMXa2x4iuNlDEm7DsF4H4YNtV3cysJyqx3TbXCuEYaS0ORLuCNg4Ve3FU1kw
	DNaqCF6qBaYR+RR3P7nh95hFLnWMpbwPwSZF8bjcvSt9uwkanY+/M6iResDAeWTX
	lrUv5la8rCMQs6tLuhJBAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8r8prf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 09:02:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AE7WIFK003129;
	Fri, 14 Nov 2025 09:02:27 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vadsuuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 09:02:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vnn09MZ28LL7Lc3REQFvcstWI1oQTmIA9mobf5ZNbIqVaEL23O80W14lKrmCjQwKdokagunR5kYfZFe0nqD4lgzttdTMZ8l4G0sLAo1sHK6edB5mTzYXHg8YjSXTACC8COeP+qCHP19AEHG2S9CZ2Tw15QhB1ZWJIQB1KqOwcSPdaAsZWDm1fzotxGbm8CBZ2jTsDyO1Y42sgAgm7FpbnhNaSMJcq5vjUFfDVx6K8veJwyokNptexTt1rMpEjsFzD5JKybEVQJs0qPldWWMUdbFXXZrlxOCKYJnFlrgugCiV9FcMXYjDQm712reGQeZxrbbRG6cLkLWmpy3Wo1XBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAGbpfj8no0r4gGXWiGuy+yVGEpAQexL2yM9zR6uJXo=;
 b=t99c4xq0SAX0OkMRXHWXMx2ozepH7Wro3mm3aQMRlr2Bpa0X9y8oeecVUY8j0Gh0Iy2X1hf8UWYh3VUaEg1cb7eSstnnsq60/o3HEhqlh9wETaRQ9JNhX7lcZFNaxYTkab086lEfzNCYXkrkG1BqgDKjtatTgKsCCq99ggaj9NTomfL+/w4CfBgwd2qePqPLhb5P2F9VifxhlXB75o78GaXwOtxlEW4PeJpqCekGRhdXEunGWnOhMqYTEPxr7tVd4/8ge4K2GpFwuaEBQ8N0YzRYGw8VBRw6W4O5RS6gzjxPUDTo6FZbsKEcg6NInmKHQqoKqCpZdXOw4lbj2V5/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAGbpfj8no0r4gGXWiGuy+yVGEpAQexL2yM9zR6uJXo=;
 b=K5y5XR9rxiPPdE1VHiE/cKq2KN1M8LX4BUp6rzFutd+rAk2CBh1mtPlm1z/SpCimCZKixaU35YOJANjrup20XH2jkkurnccgUhiXaC5+P9uyAfW8VnHaTl3+9loZd0JFca4bsYVv/t0kEIEIM2kvZhifRvNDZq2WCGPkSK7vAaU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 14 Nov
 2025 09:02:23 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Fri, 14 Nov 2025
 09:02:23 +0000
Message-ID: <acba80cb-66c5-4e07-8a8e-a3a61ca9e247@oracle.com>
Date: Fri, 14 Nov 2025 09:02:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] scsi: scsi_debug: Drop NULL scsi_cmnd check in
 sdebug_q_cmd_complete()
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <20251113133645.2898748-4-john.g.garry@oracle.com>
 <9e3540ab-3f80-44a4-8d84-b8ec0598e681@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9e3540ab-3f80-44a4-8d84-b8ec0598e681@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b1965b-afa0-4f02-569c-08de235c8694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVJMdXJBb0c0VFZvczBqQkVmTlY3aXdsUW9NT2JYNnVMUDJNSjhGbjQyQ0JI?=
 =?utf-8?B?WVVpcFoxWk1Udm11Mml0SnRoUEFRdzF1SDJKUG5iajljcktySkVIeFpVZTFu?=
 =?utf-8?B?WnJxSHFqRG9qeWJqaGhDbmU0cDg2bVhUWXBFQXVUQkd5Y1NvVDdiYVhEeXNw?=
 =?utf-8?B?cm1xUjRLajdId1RxaTl5UEdDd29wdGU5Q0dxMWpKNGEvQXhsZHc5K3RLL2lO?=
 =?utf-8?B?cXhDVnU3YS9ScWhjYzFMdjMzQXRHV1p3TFJrOFVlSXhlMS9vTXdaM2E3Qmov?=
 =?utf-8?B?RWtXVVY5K2VILzlES2VWMDdsVUVQMmRWT29SV1o4ejRrR2hUKzVHdjNUUSsw?=
 =?utf-8?B?K0FXazF2d1JmYndGT1hqdXFNSDRxMG5IV2poOHZCeWhDTWRlVDEvd0pZa29t?=
 =?utf-8?B?bzVkcTJGZGw0aHBrSUtTLzFtYkhrTnhVRUxsbGFzRkFwa1RZTm5kQTkzUDVj?=
 =?utf-8?B?Y2VKTkpPVnNuSWFLRTdMZmdjZjJpRXZOUXJxOHFhZ0xxVFlEMVVlQzhSQ2NW?=
 =?utf-8?B?WFg2b0lnWFlBcFNPdDNQa09DV3BxUDk1aEFrcmE5OWRsS3l0Z3lqTnVvTFhZ?=
 =?utf-8?B?VUh1d3NZaXd1bVpxWVZWR0xBelVrd3lZNDlmVEhPbFhodmN2UmFuUklNa1Ay?=
 =?utf-8?B?Vld3Nk1PUUVSOTlzL3Q4dmlSblpuZWRZalU1Zmx1VVNreVZ6ck5KM2NRNDJG?=
 =?utf-8?B?ZC9HVWxwWUNleU1JaWhoUXBtc1BRNEN6SkQ1dGtnc3BnTmg5VnZJeUZDOHRC?=
 =?utf-8?B?bHQvNCtYKzlVaEtveWp2bVFJMTk2TWJMNFl4Y2tPSHRieUkrZkpWSjFkOVlJ?=
 =?utf-8?B?di9MTjhwVnJIMlR0Zm9WaW5ncjUyY1d6eVlTVk9sRDJ3dndxMm5QdUlCM2Q1?=
 =?utf-8?B?Vlh2QXZpSkUzdVZQWkNoVGRnaU5qQmg5Umg4eW9haG9maUM0Zmc3ZStIMW5h?=
 =?utf-8?B?QVJ5R1grZXBWR2hEdUtrUFdsWmxVcEJPRGN2c3ZQZml4OUw3M0NLREI1aCtJ?=
 =?utf-8?B?dk1BdjVmWUx0T00wU0pKa2JFUFZzU0lNZmo3WlZqQlg2eVlKbGlhYnNBZHI0?=
 =?utf-8?B?amZhSldydXU5RlJRTjgrN3BIMkRUVktkRmRmaTA0QlFGYjYxSUxoSXNONzJq?=
 =?utf-8?B?ZHFvWm5hZ25ML04reUdoNTM3Q1pGbTh1NEhHd01BbHZLN2xlK21NNXYwZjEr?=
 =?utf-8?B?Sit3R3l4Q2FPSXpkTXVtWEc5UGZad2NvWHEwT1EzQklPYStsRnNhQndna1Zr?=
 =?utf-8?B?S29OQXl6NjNNQzBQUmsyR2k1UUQydVk5ZWtRMjk0OG9XTFovUVdqQVNtSi9O?=
 =?utf-8?B?R2dPWFFyTmswK2xaMCtBR3ZMZTM0UDk1b0FHMGNHWTZNRlhlZWhVTWl1b0hw?=
 =?utf-8?B?bmEyVDUxb2ZzWE5JYmorZ0NjWTYyZ1FjSDZRai9NSnNDQ0thc3RqUGJsUXpa?=
 =?utf-8?B?R2xpeTg4S0hCSjdrVTNieXh0WldUQ1JYTnpmcVUzQlBDQ0dFVmhqM0NLYjBI?=
 =?utf-8?B?N2JhQXIvTngzWFlHWEtOVHUrek8xOHRncFRFcVhaa3RiL2dMRkVtcU1yNUZ5?=
 =?utf-8?B?enp1SDN4eHMrSGtHemprblZ1MmxDUXFlS2RsRVR6bnVHMHVGSCthZlFPbmxs?=
 =?utf-8?B?clp2YnlGVWtSa29LNE9mL2MwN2RzTnVEZmFwMExkQ0oyenkzeVdtMVVkczRX?=
 =?utf-8?B?d213akFOaHJzdWVIbG9DbmxNUlhNQmNnVFVHR0lZNVR5SVlZRGNtdEZLbGxX?=
 =?utf-8?B?cGp2bDc4Vm41V25MdXliZ25ZbTJpVDVTRWNEemdyaGROYllRcmYwQ0xVZGE5?=
 =?utf-8?B?MmI3T0E3WXdNenFmTTdYdkUyQzdEckU3b0N4THRKdmp4aW1iKzdvQVVrQjRj?=
 =?utf-8?B?SS9xS1VydUwvcmwyemNOYlBzeEtVS1JrdUJUVDFGRDMyNTFJT2d5V1pGMGNh?=
 =?utf-8?Q?qwSHvdJiotWDwSixHUT7qiobizQGcV2Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUl0bHl2TDZJZVJUQ211aWtxZG96QnhwaVNkQzdPL1RaK0xKTUNMdGNqOG94?=
 =?utf-8?B?cUdmeEl0ZlZzUzNCVENJYmRjMWY2Vmx2ODZOMUFhL0tOU1pqWGpoM2VlbTZ3?=
 =?utf-8?B?MWZhSWgrUzJOZkRyQmZ6TUxucXAvclNwMW9iSENSbkpmSHNPZ2F4NmljbDQ0?=
 =?utf-8?B?Vmw0SUd0S2Q5ZlZFY3gzOTQ2KzlQd2JvQnpjSnBTSy8rMjlXREJSeTJGazVJ?=
 =?utf-8?B?MlgxbG9wcHU4WXdhY1MwY2srUTU1OHFxZk5vNXR3em51TFNSRUlZenlEOUFq?=
 =?utf-8?B?WWZaUU1JNnhIT1ByYkhUMm5HWEtHaXJraHFpOCtZZDU2dlZ6bEh6SnNwemND?=
 =?utf-8?B?QndtRkZiV0swWnVRRzc4bkRBbEhWUjlJKzN6eURzZXRiVXNHWlgwRTYzUHI0?=
 =?utf-8?B?RU1EOTd6dUFvRTdUOXMrR0xRb1lKNnMrblJVaE41U0pUU2hRc1BvdHVxK2ND?=
 =?utf-8?B?Wk1adkg5QlhrQURoVTNuRit4ZFhmYXJvcUY3TVptempIT2V6bU1VejhYVjNG?=
 =?utf-8?B?NGtZaW1Yd0o3Q3QrTkNWYUFMcjY1UlNLU0JKSXVCdS9NZGJtck15R0hhdEh4?=
 =?utf-8?B?cit6NSt5T0VCcGZmVm9jVXdwN2lSaS9QL3kxS1k1WXlsZm0wYlkrN01iUWRl?=
 =?utf-8?B?c013TXlwYVJsTDlIL2VScWs5cWRvMUdyNFg0Y3RvVzZwZjZWZFA0bzRFUUEz?=
 =?utf-8?B?cnQ1OUpOSWMzMlZwV25uNm05UzFXaUhDUEF3OTlERDFJK2FWTEZEejU2WXAw?=
 =?utf-8?B?cklDYnI0RmFnZkF5SjVCbmswWFpKbGlBZ3pyVElQSStCYzQ3RXdHeEU1K3Bs?=
 =?utf-8?B?NHZ6T3hNcEo2eWV3NUd6NlpWNHVaVGhnRFk0RUc0OXh1eVVhRHdBbTJHOHhF?=
 =?utf-8?B?QmFLV2N2U1dLcWtGUVh3Skcyc1lCTWV0UnhEdFUwVUNHUGoybmpWcTFscU5K?=
 =?utf-8?B?WGtZZmNqTE9tcjJqWm03QkpJb01DNTVZdzV6SjNjVll1WTIwWXBpVjNwK25G?=
 =?utf-8?B?M0tJTjF3TjBzNXhjTEVFR1pZOFRGQ0lHSTJOWVRxU2dJUVRJOG93VUd1STQy?=
 =?utf-8?B?S1B1Y0NGV01qOWJnT0RRb3dNNkFnNStTNFREcFFWVDJZbjZ2VjdWNXdOeGMx?=
 =?utf-8?B?dS8xeXdUNWdKNUxHakQ3YUlTZ3Z2RkRLK1lsbWg4VzFoNzVzOWdtcnhST29Q?=
 =?utf-8?B?MHBYa2NQdmRtOEJ6eGlsSkJQT0dMQ01WQk5Xa1R5WjAxM2cvSmo0S05oTmRx?=
 =?utf-8?B?Z0h0OFRWS3AxSVNIbGx4aElQb2llZ3pCUVlBUFM0TlROcFo4K3FwRE5hUFZk?=
 =?utf-8?B?ajk5RHdFWmZTT2NJbXNUQ0djRjRQWElZdUhnV3lnb1ZEeGZlbmU4ZG5BL25i?=
 =?utf-8?B?RGhPQ1VzMDFSdTRySW9XYVVmMjRrN1ZtZlhhS0FUaWxSeVgwd3NmMVRCRWFF?=
 =?utf-8?B?NmwxT0ZkZUFpMkwvbnl4U2RtNVdhMjlVMlNEdTJzWXBjRnhyMGRQVmk1TEFs?=
 =?utf-8?B?dURUQ2grKy9KdTdYUWQ2VW9hN3NxQ2gzSlpSeS9meXhJbzRvWkV1VVFmNVJq?=
 =?utf-8?B?ZTI0LzlMMTNRMFYzaEVUK0dhZzF1ekFjanpYNkV0NmwwTnBySVRKSUVuQ0Fm?=
 =?utf-8?B?SnpTQWozdnpYRHFvanZCbWNoM1F6ZDloY2pLaWZ4aWRnenlaUWxpRDhwd2hM?=
 =?utf-8?B?V01tSDZqMkNLNUtGZTNhdjM5VTdUMTBsRDg5bFhaY25idnMzUXkvR2hockM0?=
 =?utf-8?B?OW9vczg5ZjJRd0FZNEhmRmhGRHBtUmg4SG5GOG5HMVdRUDAvWlhlN1JrTkpq?=
 =?utf-8?B?L0JYM28wTEJLUUI4bDkzR08vb042L1F2ZVBxVU5ubUx2MVRFeVhRRUdyRzk5?=
 =?utf-8?B?YnNLL3lnYUtZWGZ0eFVnOXVQcGpUS29kL2MzMDNPUk1veWQ1ZWY0QzBUTG1Z?=
 =?utf-8?B?SXhGUnB3a1YveURlU05nMFhCL1podEZGbmpldnozcnNHQkpTRGdOblJnYm9p?=
 =?utf-8?B?R3JCODlkeFdrWDJZajR1bFVsV0xBR3JTL0xBSjNkVjhRNE1rMjVmVWJWZjdp?=
 =?utf-8?B?RjJIem9VaGxUcEhSelJhSHFMem1mSG1CUFQyZjlJMkFHQW9yT2VEVmwxSFBM?=
 =?utf-8?B?djJ3a203NEphVjM0cmlGdGpNQW9pelFvcWZmU255blQ5Q1hwRGVhOGdvSzhX?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rLqe3CGgxiJyq7kSIfyKcGzMVbOxREc5Op8QhyRv/uWw+r0b/6ORzFIDwnnK398MIgivACjD7dO71J75jrqprIK/RGkTk8f6FJHl9IKa7ECq5wiU0l2eyyV/dgSe9br1k2+Gp5WzD9iER4Q8J6YsXpmU3rMNvKlR6Zl1a/gEWJ7quwdhfQbz2VsimH6Ue26cDtoSW6rUcwuVej8z+kagzooPUnVyyWfWufPUo0XLFDeSqpkQW7I9Z6coSXK7pMjW8sOkrwxL/JPtvrDgHyd2G/0ZS5pCng82VqkZNukcwBIywIDjAUzpRcLfBL8XOBaHkYygPePgBvi6EDnDhwv8KIKXo32jDrtYnQ05XreXWuh5LELVUVNcxhTAFxIX5Ce5GHgIfdcDg2DZe9GerkBFQEfXOnF73tD1yPU6ZDMJYFR9IbjXEyGfpOJuJ3FY90wZ8uPuVf0yGyTyHjGnZM9hH9KVRTTzRr8POH249gfwGB6M1h+mvThlnb08HpJ+FiKFu1yS6sA+Eww4a+45yZ/gQZzz3bgQo3c9/lrll0pRKGEQQ5oRD99pE7Pao6Vv8LjSsyLjQcwyLm7kA+DLuX2ecP4USfk9LbI7p2IPDb6k4MU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b1965b-afa0-4f02-569c-08de235c8694
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 09:02:23.7683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/tC1Cnw8RGa2VyJMrBPDyY6BHO21QgrbCkLwQ7SKTJ1STbnHI+/60GREoGtIqWGkxPcniPgA3+E+kTSHUmtwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511140070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfXyQtlQl7/j2y4
 4JEvXpGTm5KvUxEZOX0OCT4s34IxDXzfb4ZBqj4BZCyUBd302EWha45tt5ZEn1Yueg3VpICpzIm
 uLALrmgGX3beG28kH7M9iLi5HkNJr+FScwdNnQpNM5oeR9YQ/7i/24+Cj4s6n/s/YAUa/HMxMnB
 RGY3TubNi/6FfbszRwW1FoDT8DZr/5FSYIbMup0kxPzY2SrzSnru/aBngt4mDht86ACCK/QIZz1
 Id2ZUZ5jW0rztT/9xwgzPQsQWpArwnvm2/5BI8L7MfUpQ8sapnCP0e8FGwPNosOaZdBPfnxqY58
 xubxMzzz4TSExzL3ZIJ5mxyurtaJogXJdNTS6EEdY6JxsLE0mUl8sCY1oGP0d3RZtuoBP0qxdIP
 ZErn0zUExYR4ZvhzX14nuVKSdmdUXg==
X-Authority-Analysis: v=2.4 cv=FqEIPmrq c=1 sm=1 tr=0 ts=6916f023 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KzjnxDyWaijGFmuD9scA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 93JzGv-0tW17bg0Varqk1hd-0z45XhNu
X-Proofpoint-GUID: 93JzGv-0tW17bg0Varqk1hd-0z45XhNu

On 13/11/2025 17:46, Bart Van Assche wrote:
> On 11/13/25 5:36 AM, John Garry wrote:
>> The scp pointer cannot be NULL, as it is evaludated from container_of()
>                                             ^^^^^^^^^^
>                                             evaluated
> 
> Otherwise this patch looks good to me.

Will fix, cheers
