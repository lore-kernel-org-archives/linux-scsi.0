Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D7B47279F
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785937550; cv=fail; b=KNNt0kHIyBb1ILNMLlA0SuqBCbcWqEUthdpx8pZfE3FSfVG69apMvQb2Ga3uoHEWTgddZd+A8xyxiMx1g56oubBvY/MLiOukJwgygRAymC+2S2QzUHA5srpBJGLNbXjAfogd/0R+e79WTj89VdZyq2+gUbADPgT3VRKNfwznKJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785937550; c=relaxed/simple;
	bh=eOKIuKPBnIi8DZtZgmqxib9fF0jdhSgiZEcCoXFePZs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k144IsoPHWhSr0ctlyodpogzr8nS6MwehCSZW5/0f3o70cP+j3yCm8Yv1Z3wP47GhrHS1db/3J25YuK2cZqM76XYgjVjkYvYnvRWl0dhbPgdCikl3apQRPvrS7GcvIrS1KYwV1QcAeYdl8Prb7Z0jjzjMmtMovkZy9QvMk/qALw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XcXwNh6r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C4oqHYqi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XcXwNh6r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C4oqHYqi"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675DBgWV3967681;
	Wed, 5 Aug 2026 13:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xFxXL4l3i1dKJrGrkUoDDO/vf6XYLPUIp7Kl2OeuN7s=; b=
	XcXwNh6rVZOD3zBJOW7gr1FZ+74H/L+Rlcju4pfTxSBiz2o150u83RNS+UyjwUbH
	LZvE1vnN1VcnGxBEj41Vb/qjRCSdGF07brJ9qRYC5lDpYIRu5vgpQCGi7eaGBC0v
	oJGbS/+HlVKCPbniRG+HztClEqcWECM97Ey3+7m79K6FVXluxzHCWILB3AlsG0L8
	A5GKpmkD/rHbj4AXXx4Ao88AJ/PMN217zZUmowQLbvBA0vPtxvzKY2KzAeqEEKdA
	WWDQ3eNkLCFiLsiMLW5Wxr9V6qAH6hsHex0Sqf2c6adgnfzpal0nvGPBOs53AWVs
	KEu1gTUw9cXWGO2KCcbp5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p988dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Aug 2026 13:45:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 675Dj9g1026638;
	Wed, 5 Aug 2026 13:45:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010069.outbound.protection.outlook.com [40.93.198.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftpytk8kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 05 Aug 2026 13:45:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykueFg7DuGsHIOijPe5CwEXe42b6hr7mZkRYSt4XAj6yXQULfWRvr4TaaGth6LgJ1JnqoM56bTrvjwhSrCQlMjWKcRTb6NkrFtG8XAZGQr5hRvh0pQHgU77qoZ24nRhqBebHY8w/g69xf41XEe07+YXhdcsZZS+j9lCDgNmi5nv/71Ibtw/NFeuzbjxPr1ew/17I3lpdVScBmZ0BSb6TSufsz1QHe75lAAjj4waFIgCA49Qw7hJhR2yDGzGBUSpXzBUdWfgNGg+F86QyUUxPCmIW49mZd6eBlJ2EvBbcNX8GP8fFDRxPmba7KHvrq6fp4IT3b3DhbEo6pOSeuSjD3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFxXL4l3i1dKJrGrkUoDDO/vf6XYLPUIp7Kl2OeuN7s=;
 b=V9b5iZv1KCV/7y77gAqlsj+NYyJ8SNygtogULfSo1Mog08oEjT4xnddgk3StBIxFpguuW74BQrB6t32SmlNl43EH0XHHl0YcJgCS15zqj/RntMZCPytdRfkpedz7+V/oDQXhI3n1nQ1CeqRVwsk4xQkCyJi2enVffiobxQARtwaOr4/EDB2tmztkMlJn5emKtD3JqXSbpelKTDa2O5mWvZtmxjEAq0Xx3SEHRkZJCKdZwj+lOTNwKl5TvpN9Rgr0nkfOO92SwjSGJLiinDmpI5sOqn8PlJ4tDtVhiH23W9U5LGx0NJugdpES/K2gEfG9aIPdxTrm/UQ7+Yh58u3iDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFxXL4l3i1dKJrGrkUoDDO/vf6XYLPUIp7Kl2OeuN7s=;
 b=C4oqHYqi1Q3PFtK7XtMX2yvEj7UxcH1r4Ks3nTTDzVWaMqfvtCMuY+d1UUVYlGkikMqz+qeqQ9DjMnJjc+P5n+Wh2n9sbJkq1N/EoSXgoXuOWaMpVinYZfy4UYxRkm4hjnLZwuGLBgbiF6SuyLaZAv+iKzQFR4YAZIMd9bfTBX8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Wed, 5 Aug 2026 13:45:32 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 13:45:32 +0000
Message-ID: <18de6750-7668-4855-b24d-515760a31032@oracle.com>
Date: Wed, 5 Aug 2026 14:45:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
To: Bart Van Assche <bvanassche@acm.org>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
 <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
 <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: f22b6ce0-d204-4101-9ab9-08def2f7d177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|4143699003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	FxAYP8T/pPVEGsH5Mqknb84/tziT4pTlqgSYqP5LaEr2h2CWp6bWzLbMuiDgedSQAznUJYcZtNEU2ywsv+fbiWDYN9JWxK6vQ+QccR4mUNp7injfbbg3OizUQHOh3+LwbhECI8hD5l620BFoL45FySTrdLsrrusCmqgLk3LVrAgs+pzoEbC7wQLlZieDdA5RO7cPSR9dzC2SpxYNcj5nKlg3VxmFWc3IRJlhAVZuu1PTeeKm2l8mLt+dx7ZG0P8DO4HUe67VmhGWNu5G76KxMbOYfhyFC9l1MX3vO+k9JhRHdAhK6yEq/1tD2x82Jr5UD50gtZaY+LSum0Ql4+/1OGwsAEG2m/4cT0+GCT9cbagJuFE3/m4Fo0WzZUeRH8EQBKMd5fey/WK6HnlVttQtgRhaV399kSP25oqQ8IvqSa5/90Iy7nBkkzFU1d47NKKY9lsjJCbAhr99+ZODYfQ7mv92VbHcmqIgazZzqspNVRkO8HIKMZTWoao91EOLlfoKYcFohgf03tKKc53FWfLYLM2nDKOvpOQLrNFbYyjy5/rBctywi3vN9mVjDhZJ9qJI8kdxUZeOQsolW/WYqRzRSHpDXtdvkhEwGnZ1syxIluDq+rjU45w7d/MEY+Aqxbi5ZXBWp/xiQl5TcQ0Uh/J7NQ4uNeYBYyGC0mFGy9/MqiI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEhUZ2I0WE5SQ3FmUkF2ZU5xemxtdlJZa0Q4LzU1SXdHRHIyMGNUVXprVExx?=
 =?utf-8?B?S0RBT0x1alBjUlRLeG9KVTBZbmhMT2NLNGd1M1pBRE5lanBRQjU0VnFjNFAz?=
 =?utf-8?B?Vk1jZUt4L2QwWkRHd3A5NWFiZENPWEZmanp0OWlhVjJDRm1PRWRjZVg5YnR4?=
 =?utf-8?B?ZG1wcUUvekdYd3hveFp5NWV3U3NpTGlrZ0NmMHZtQXZkM1NnV3dtWU1GVFlH?=
 =?utf-8?B?bTRrL2MrOU5hMVhEZ09sWHV2RnYzV0VWNW4yNENxUCtsUXdVU0JVQ3JqS0Vy?=
 =?utf-8?B?SmQvcWYxK0VYSW51RUZPWXRrK3Vjb1ZETDlNQWY4dUVpY1JaWE5HTmV6cC9B?=
 =?utf-8?B?azNlZFZicURBRmtXRUt3UVNvaDMveWx6T21vemVocTdGa1RXU25TanRkYWVx?=
 =?utf-8?B?b01PMEV4ZXQ4UENPbGpYUHllRzNycXZ3VTljZG5TM09Leng4c05LUUFNbTUy?=
 =?utf-8?B?ZmhyK2NVZS9IMUtMcDRwYVZUMW1KcmVKQWtOM1I1YnNUNUpwaVdvd0QwUnpU?=
 =?utf-8?B?K2laRWQwVzNHVHh6NmwrTVJFbXQvK3VtRXl0NkwrNk02N1J3OXBpSkkyYzlh?=
 =?utf-8?B?YnM3N3pjNXFnMGVucjdRVU43am1icW0rQ3NCekVOdUpISkZKYzF6SDdkd1Fy?=
 =?utf-8?B?YzhBL2NKaXpSTHI3ZlZrOTR6NTBzdkJ4Z0orUW1pVW5PMWZrT09USzlCUnMy?=
 =?utf-8?B?K29tSkQrc0FLM0k5WTJHeU1sMVBuTW5jY1hBNHFZTzJCMkxPV05EWjlMejBO?=
 =?utf-8?B?bTFGVEFlOUphUk96SFJWelhxY3RBUVVaN3lub255S3dlcDVEVTgzNDRWb3o3?=
 =?utf-8?B?S2Z3UGV4RUpPc0tPZUNGZHc1bUVCcnBMdW1GTUFWc20yQUs0MWdldkl4N01H?=
 =?utf-8?B?cm5sMEZjZ1VISU5Qd2F2N3Q2UDZqT3ExNGY0eXJlUHpXWFF1VGFlYVZmV09U?=
 =?utf-8?B?RjdlRE1ic1JCalhDMGJmU2lLNitBNEtzRGFhaXZFdUtQVEhvd2RXRnl1SHJF?=
 =?utf-8?B?dGgxNU94R1o5bTM4T1dLcXVlRUp6aVdVNmNUeDRMN1FFS3JKeTVpd1FTc1VW?=
 =?utf-8?B?eThjVVFBSExiY01EYTcwTzJwd2pFOGhrT3JRZzRVcDNaTElRckZFVjVpUmZK?=
 =?utf-8?B?aUJaN2pZOFBVUWRKY3A0MndQcnl3WjM1SFNUTURDRlBzYzY2NzAvaXlmUXNP?=
 =?utf-8?B?ZWMyWFpCSEROTzluOUI5ZVJLczZxaEF3NExlNFc0aExuS1BTL21WU3FYTnd1?=
 =?utf-8?B?aTVDMUdXeHJBNGx4Ulg4eUFBbHFtRUhKaGFhV0Fwb082cEt5aWVOOS9PUEN2?=
 =?utf-8?B?d1gxNklCZ0w4THp4enAvRHRqRGJDa0QzbmlMWDFlT3Q5NXcyZXQ3SjdmY21t?=
 =?utf-8?B?YUw5VjJJS2h3dHRZQkVpQ3d4aW4zcXFlQzcwT0krS3pXaUdXRWRDcU5KdEZq?=
 =?utf-8?B?SExsSE16L01ndHR3ZXU0cTZNK0dMWjNvcDE3QTEyRHgzdy9qY2kzQkVSR3Vt?=
 =?utf-8?B?VzFQSzFxMExRU2NtSUE2NEh6S1l2TE5oOUFReXFYb3h4MHhOeThIRlZWaDFJ?=
 =?utf-8?B?WnQ0Wld3d09Bc3NtY21FT3JlanFPRm1zZjVna1hNRmVFRkl5WXNwMWlmUmVw?=
 =?utf-8?B?QnhRZ3FHd3BBQ2liQ3JnSGgwbDMzWmVmKyt3L05CNUNtYXR2dkEzTk9neWg5?=
 =?utf-8?B?dDJCUkM0d3o0L0M1eHFrZ00xc0diTVNvLzhLaXI3bGxUNXdURUk1OXdPeGl2?=
 =?utf-8?B?dlVMTFUzSXdLRU5PWldWRzdHRWs2NzZXV2VXUTRqS3hyWGJ1R2lSQ2x2UUtu?=
 =?utf-8?B?c3ptWkF5SEYrZGhpVVRVZEw1RXFBRlVUWCtHWXd4VzJrakczbXM5Z2hMWUI5?=
 =?utf-8?B?ejFzV1VtdjdHRUNZNDVkdk54YnhLWmk4aUJRTGViMEE0c1VLVlRhcXpaZnR3?=
 =?utf-8?B?NXdjK2dGTVlXOE8rdkJRVGpSSGoxL2hXVmpUdkd2MGtKbDBMUGhUL1RkMlRS?=
 =?utf-8?B?S0ZEZGd3dEtHL05kV0x1UHZVVUltc0lrdTVLSEVVQ2p5ZlQ2bGNMZTdQbW51?=
 =?utf-8?B?Z1R5ZXpPYWhmV0Zra3doTFRUZFBLb3ZCeGtNK3RDMGYya0o5ZlpkdnEzaFVp?=
 =?utf-8?B?dC90dlRucy9PVjVUSC9BaFVXUDJBMHExV2tDem91SFhQMnVGcjZ4SnByVFpZ?=
 =?utf-8?B?OHZOY2xKUEI0SFhsWWk1UDdrWVl6aGM5blFscWlNY0t4S3NvZStzcU1kVzd4?=
 =?utf-8?B?bWVJMjV5ZUEvUmZ1cm01MktHcWNralptOWVtTGlhUVpmdU81WitDRE1QL25Z?=
 =?utf-8?B?QXpSUmg4UXVBeUxHd2RVQWVKTDgzUk4yQU9CdkN2aXJ3b3hNR0NkUWhMcy9I?=
 =?utf-8?Q?FreWqUJhiFa226uU=3D?=
X-Exchange-RoutingPolicyChecked:
	ebkDalE+qOQQygSMP1k1r1ZFcU2RsHBYFxfzPtzmqAIvAFH7zjRGwRuq+VKNLCgX9cGIcHBsnSscUzx0pS/v3nHPW3YLsvFtnpiHo/9ZIsMTRuhJ9ObeM4dW0qwhj5trRkSfJKdlBmycNfOFXyRceFSYAgk+TKMpDGCZx9L5rOK3tGHOlZF0LKtnzdubXuf+BdDBZYS1aaMxSWbVhfDGEOu+bhQUDi8oPW2CxT8VuMJ3ODz5r7ESkVg2mE+RHXgu4dbsR/6Dxxm2/AtXE73+ULjTSw7VBi07IloilCPZouUXvt6EeVr0945QIja0/PluevuJ5kTMwF6OMgIgBOxaCg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DKkds4gIXNa0r3TTzisfF5CSEbyKTQaHY+mWK7mX9SY+w+JDqyHK9hQGA+/RjpPof4Zd7nUbOwHoO5WLoL0QWvqjDDfrp6InrlWH0XO/nuHDC6kwG5tGvXrr/GnpoJBnhuazg2WYUxXy8QJBHOoYMUSN1PQ6g76A2NjWrJVfGSBZbO+xVJn6eWMAJR2ojzWJAN7sNKTm2AYtFdrjmWAmA0jgfQGxM8RGAtfYSikGYKFDQSi+Ow5WvnWEg1AA4w3YN9jELg4vHIjckRuubw8vqoIcETcvgwabUsSdsHOm1X+gYTq2RR9OvW0350QRGXNkEtPTBlDV4RgDf46N3fGixJzqPlVXS4qyXPH0mzNGKghuO/8M+3t7QhTLsq5lPfBUZ1f6r/7Cjdc8YFjfX1iWcs4rgaRTEeazT2OzZmdciSGuBuvrWLYHrPTKR9sojiUYziLfrCB+kbbPJhUM2hu8z8Rqm8U6y59nDFILUjv2AZFbfGNKTf9ZTfSx5ho8xuqsmCw3Is2wF8f6TTMigtxQyj6dVx5ABluMxzbIuzB2KUiqpHWWPywmg8dK53hPwJbow9FLHeiwm1YadylBm3XqdE/s0EhPar8Iv7Ox6N7ceo4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22b6ce0-d204-4101-9ab9-08def2f7d177
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 13:45:32.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xT8gJpa4fOao5nrIYk2UQI9EHKR83SPJtA3W4LmSiOtX5HHO9kwgpOW57cIBJk2SqTaXvCvj4MuAJUx41vdKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608050111
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDExMSBTYWx0ZWRfX23uSbI4/Pemq
 HjAJum0sM0hanq+seT35/pXKJNHGZCvXarl/GO30O99dvHfSBTFI61Ley/vw7z45NnhhICKqkiR
 DBkwZJ4ADbbz5Ib+nQo8NxFfDfuXZvlOxdH5KkiYdyvpBlib3+Df
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a733e7f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=YsSBO2oaKVzZBRkXHY8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: B0wzC7CP9JCoNVKjlTDDH2zuZbyknNGZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDExMSBTYWx0ZWRfXw1zzcMxY4p3Z
 ApYaF7p9MMGrHi+S2Nuzg1bebtmzn9t+5GQM9NPftYPbEZ7DSUgNHm0jhcnoWCpUTogQx6tcHHQ
 9R84xxF/G+SAT45x44IqyLHU5tH38aT8avNjbnknHzJUPjRbc8sJkk6GE+4sHNqLejOLYLP0dtO
 qsRM8xB1LkNqkLqlkKkLGdQqA5gefKifLOIjckNJx50Mk5FvuwVb1T7e46O2RB89IMBhmYZEgSj
 xGflnS7P66OfctPBr6eKmi6kqDYtHAAoiUiDeQ55zLO5aVHJToBYjdP91a5vZUIxo4va9c3JcYc
 jhVEDZuPhgfNWqX+C4FP3kU0ccw6G3vNGkII//jH0Cue/UvEUwZO/OxeSxt6UJ3hBn5HVKR2Dmw
 mNGYpXHWXY7sUALGPcvyAtqPjk47Wu3/IwMOZxEfZq9lfgSCBrGAZbs/qrMabL4+XBLO5edS86+
 6baNErKmSLzDVXVtewQ==
X-Proofpoint-ORIG-GUID: B0wzC7CP9JCoNVKjlTDDH2zuZbyknNGZ

On 04/08/2026 21:08, Bart Van Assche wrote:
>> Cool, I'll go through this. But how does it handle the arm v3-related 
>> drivers, like fas216? At a glance, the script requires gnu- 
>> a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07 - but I thought that HW like 
>> this requires an even earlier toolchain version.
> Correct. I think that gcc-8 or older is required to generate correct
> code. But generating correct code is not required to do build testing.
> Hence the following hack in my script for 32-bit ARM architectures that
> deletes a GCC version check from a Kconfig file:
> 
>        if [ "${arch%-*}" = "arm" ]; then
> 	# gcc-9 and later do not support armv3m. Hence the sed commands below.
> 	local f
> 	for f in arch/arm/Kconfig arch/arm/mach-rpc/Kconfig; do
> 	    if [ -e "$f" ]; then
> 		sed -i 's/GCC_VERSION < 90100 && //' "$f"
> 	    fi
> 	done
> 	sed -i 's/select CPU_32v3/select CPU_32v4/' arch/arm/mm/Kconfig
>        fi

ok, I'll try it, thanks!

I do have to question why we maintain support on modern kernels for such 
obsolete HW. The maintenance burden is not zero, as we see here ...
