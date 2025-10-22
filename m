Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1E32571A0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 08:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761122826; cv=fail; b=f9uYgkRtgVfQiq0aax/6JMiqEFw1fcXohnrFEO24swvuxHQYr3ZPBRJrf2QuOA2sSvcCyituJ4H12EE/0/of/Gq9CGo/wyV6G8mqO0yPJlUsflanYwuF72eO/t8hvGmdKx5iwWwgxFghEVrdJGiZBSgr0XYhVPZWGx0YmmzL8RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761122826; c=relaxed/simple;
	bh=njpXublgk/s1yCafM73dFVmaGf9hWAXUU6NoSpTmNO4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U7Htd8FcWrNtEww8s0aTPZAlw0aUcOG/q1bGOFSipk3T8zoCagHsdK6AAjoLgl0/UNSe8SBGSCT7JkjBbQS89Vv2r45D9p45k5RynWAaQYYySqFLzVbM+Cwhu67qkaxzSL7Nb9uZB+nj3/2emNU8Ns+jbdUJjILWAzIveiW/2Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TMOhby0D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iKz5k8cr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TMOhby0D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iKz5k8cr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8CNW9020280;
	Wed, 22 Oct 2025 08:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Oai9fzoVmgiibRAOshi8YsMRHvZJT1Y0Ct1xaSpf4M8=; b=
	TMOhby0Dst6oPWylSWcbKdDTw7f+PTXRNobC8JGdtbys5bR0DhRafKLxuj7LOKQG
	kGjQqAwe7dIXfYvzanLigfD+O6dUcSBGyf8ciPfQBgAyK626mjC+DlyAhanVQmij
	FCl5LGQ9f7uz5tPY6H9Yehzz75BsZJ0+xP4Ydg6ywfSd2Z+HXHRcQ3XTQ+RA/3uE
	GH5uBLBddk+vXmbTSLetR73iMjrLBLImapqMGM1+CHS0byeL8pzVZSB/IlX5pKJe
	Zp/TGG189TQN7drBqpBcWYr14VpCsP85HjOQtx0r+ynCxwC2wfNilN63QKYl+GwP
	ImZQdMdftpHTYOIQGaKZEA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3esqc59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:46:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8WR5V032285;
	Wed, 22 Oct 2025 08:46:55 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdx4wm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FD5R0NxvwEaUw/S0ATH20LnynRKYA/otBeuK96WV34P/8stkxjcgf5DZ2pN3/waDSNGvfmrTWH1V0tYBnPNaPoHZMFIrgDn/6/2eQAZPEQ4jL0OI8fvmbUtVfNV+wStTXyslTYZsh/0UG+22HZJxycqtkhrHgfYQnyXmoJYUzqfrrfP/KOtdA/rusryxS7xIaG7Lz/arP34OUYSB8f/9TJ6Lubgtu4xVuBjs+AsxrP6ZQovyGizV1dUtAAJheaYnvE1+9N2hE+W06h+ukea/JkAAqevN9dXtmVhPQe5f2o0w6NGQnUqhYNqGw/Twrq1Rk5cBT5Qi+y4Aa5UrMpBetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oai9fzoVmgiibRAOshi8YsMRHvZJT1Y0Ct1xaSpf4M8=;
 b=NzsPXD5S1I9DlrtLGhzkS7ikM/nL/tkl40c4QHGBDCupHJOn0sQ/6GK9xRRsfHW3pKc/W55X+GEIBLMMYkBsPsLS3KXzCDfcBHtsspP56SXK8kG1s+OON7+49MFeKIQTKTtybRJHJDs6hMOrzbMFGTOqxWRBHQyQPLnxRSL4l1lYX8HRShXo+UVqOlPJIIQgO7FZ7vjdvO22SR3/2Kq5S69nP2YcPVaC7fwofouZdXqxQyDGENFotm5ortPrFjxo5j1d86VHXGc18sNMrbnS335I9Lxw382OUuD6wnK7esltiXK31AhVk9xrsCWRSQ2Yc6feLpmBsdhjLx0uTLn/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oai9fzoVmgiibRAOshi8YsMRHvZJT1Y0Ct1xaSpf4M8=;
 b=iKz5k8crF0vL8K1lgq9AkoV70ziVK79cqqdU1xAAQ3opqhDXX0TSRCItxfhTPcpIxFAyWjcUVXO0sMi0kSdjsgdCMZlGb+soeKsPk8Gvq83Ia2+tGjlfXKTZjbkKcTWb3FU5Sk2ky2a0KSrZmDXTDr89B6iSqPm6UvLH50gDUr0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB7469.namprd10.prod.outlook.com (2603:10b6:208:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 08:46:52 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 08:46:52 +0000
Message-ID: <0507fd03-b3b0-436e-9f5f-72f7a02484bb@oracle.com>
Date: Wed, 22 Oct 2025 09:46:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/28] scsi_debug: Abort SCSI commands via an internal
 command
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-8-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251014201707.3396650-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: c2492e6b-1141-4e40-6ea1-08de11478bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTZoZGY3aG41VThnRkI0WERyWTFLZkxNMndJSnhqejdNdW1ZK1BhNlA1Q0cz?=
 =?utf-8?B?OERaQmNaUWk0MldpWlN3WkVTNnJ4WGU2cHV1VEdhcnd0M0NmaTJuOWhoYThQ?=
 =?utf-8?B?cTRDbW5nS0ZFUnIvQ20xRGd5d3c4eUMvOW56VHhxY2dUZ2VlTGwxeFRwZ0h4?=
 =?utf-8?B?elhmKytZc0VGKzhqRWZkMGNKcEp6dE8ybzBZa1oxdkgzMFZaMW1pL3VWQUJE?=
 =?utf-8?B?V3hpNHFjRk5HTjZsVHFyWWp5amk1VldUa3FvWXRja0tJcm5zZTlGUnlLWkRp?=
 =?utf-8?B?RzVDMmNnWkFuZ1ptQTdmbi9HWGhTeXJQRzUxdVNiMEEzYU9mb3BzYnVuaWNS?=
 =?utf-8?B?aHdMbkEvMGcrRi9JWm4rOEdkblhUYXlubXJSd1UzeUtFcm1Uck45enBqQWMy?=
 =?utf-8?B?VFJGWmdNQm9YRmoxMksvd3RPK1dLL3cwRnlNZ3VpUEF1N1NSSUQ1eHhlRVhK?=
 =?utf-8?B?aHpEcUF0TEFmcjNUSm9ZR2ErajM5bWR1Sm5SUEFjM0pSTXdUdDA0OTBxZnZs?=
 =?utf-8?B?eGRJaCtTMU1BWGsrVmMyYmtKaEdXNmJ5N2MvUktNL3V1dGdGZEc4aGxkTmlx?=
 =?utf-8?B?NmdaZTVBRnBNSnY2RWdSUFNWcHEvdG5tU2RKWkRqRkt2M1plNWVXb050cURS?=
 =?utf-8?B?dkY2SmN2dkZueFd3SDNKQzh2OGVkYm9kQVY4L1FZd1pDWkpsNkRlWUszYnA5?=
 =?utf-8?B?ZU9Fbmxjc2ZqeGVNK2tyaXZKT3VaQlIwK3ZiakxhV1lzK21udm5nd0ZvTXov?=
 =?utf-8?B?dGtDMTFubldtUUNjdVRDalR4QVltODNpcy9adzRIdUc2UTl2L09ad3Rjd1Zl?=
 =?utf-8?B?NE1WaXBxYllDS1dvQTFKMGNvVFp0ODJoZ0c4LytyeGZ1ZU1QQ0lFT0VKZkJ6?=
 =?utf-8?B?aHh6alBPOWFzL09oRjIzSk84emo3aUpralFBNTFOdi8xRE0waTA2Nk16UXZx?=
 =?utf-8?B?eG9ZTlZQaG5TQzlMdFBaaU5hYURUNHFpVjJOTyt6ZVZPQldxckRlSWNrR1U2?=
 =?utf-8?B?anlWemc1SEE4eEkzdDRxVjZjSDhlNXhTRURXN0VLcDFKYVZzN3pEUkFJVkdK?=
 =?utf-8?B?eEp5V3hTcjBVOEFZZkFuRWRQeEp2QlhQRXh6aFdteW5NUHpFSEtRK1F6b3VM?=
 =?utf-8?B?d2x1R3RJc1IrUllEbFUxUGVnQkRMU1IvVk5NV3prYlBYQy9wQkRKcDJhK3VR?=
 =?utf-8?B?di9yZE0zREQ2bW8wd05FQnpWYmx3WkN6cG96WXhvSWtxdUU0Um5GUUV0aCtv?=
 =?utf-8?B?ME1HZ3UwQ05vQU5LL1ZiUUlmVDVqQlRib0Q2OHpYSVQ1K0FpVmhSNS9XWS9U?=
 =?utf-8?B?aVpmQ3hZWlluajdsK0tycEtnS2VwMlBJTGtBVnJnYUhoM2tqODdmbmo1dzhT?=
 =?utf-8?B?UmxsSUh3MEpYLzJRSVVEREp5SjZyVDVBc2lTeEpQMy9UZEJRUEpZaEdCTm04?=
 =?utf-8?B?TU92RExsVk9VVVJLRTQ1ZG5QQnkwMit5ZkRyU296UjYzRmErd3VXVUlPd0g2?=
 =?utf-8?B?VUkwNjg4Y3FMZ0Q3RjY0aVM5REMvYjZuYklMQUIvbDVtMENkMllnWE1pVk52?=
 =?utf-8?B?cmo2SE5qOUZMMXMxelZFWk5Rbys4ck5haVo4cDhQdUlJMi9EbFNkdXFQenIz?=
 =?utf-8?B?WTliQU95ayswOWJCWjBucHBxamx4SUd5dDliTU82WlNSVVFGQmxtMHR2dHBK?=
 =?utf-8?B?RTYwdTl6TXdhSWEwZDFLRUQ0NnpJdHQ2WFQvRVd4KzI5dlBHTlVNWUtPSEZR?=
 =?utf-8?B?VDNseFZBcVZlRkltZVNUT0V5UDdTRC9tWHFBVG9tWTI1SXFZa2JsYXpoVXl6?=
 =?utf-8?B?eXIwaDFSWlEvVVMyZExQK1g0THRPNHRaWGpUWVg4Y2U2L2xzNDFlYVJKcERX?=
 =?utf-8?B?ZkpPNlVrUFV6b1NNTER5c3NSanJKVTdPQW0xUGlmZVQvWVYvVmkvUXJScHVm?=
 =?utf-8?B?eDJQdFRoU3BpM2RTSTNGdXBTa25uMDlnUkFNc21JenRrcUcrd0tYUjVUczdL?=
 =?utf-8?B?TGlQTXU1SEl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2JSV1lscFdSS25rbDR1aVVkMXV3QmkzQlNHR1hqSkdEZ01UdFhZOWFLd3BZ?=
 =?utf-8?B?SzA5a1NjSjZtR3JmTEJId2NNNmNEZFhTbzhoNHQ2aTlzU3pkS0FiN2ZmZHRM?=
 =?utf-8?B?K2pNZVIzY2FadkJ6L29OUXAvR1FDWnJaaVBqc2JFWUMxNEpFMzdldlJKOFJs?=
 =?utf-8?B?Y3VFWkc5MkdaVjN5VzRqc2svYzZFWVp3UW95anNpa1Z6V1VZdko5QnIwdG9D?=
 =?utf-8?B?R2pYb0p2a0dxT2xLemIxQ29oMml6bWJWKzlUV245MzRVY3ZJYlIrVXFNUGd5?=
 =?utf-8?B?N3pRcGR5TklyYlNvRmtMSmRNSEVuMkF3VGp5enphSTBoUCtmYWEya1J2SnB6?=
 =?utf-8?B?cGk1UEFOYTFGL0o0ay9ZdDFRRVVvMUhlNUdQMFJZZDNjZ1BNdWpqV3dLejdi?=
 =?utf-8?B?a1BzMkRvS1dWWW42TUhvRjRTajRBdzNvWGdVcVNBRHQrSStCbTV2NUU4K0Nn?=
 =?utf-8?B?aWE1TzJtWXdyWk4rZU5MUW80a2hQbkE5MVJ3Y2NIYmlLQUxFVVBRVFgvREp0?=
 =?utf-8?B?eGFZUU84N3d0S0VaTFcyRi9ZcnQyV3IyMW9LQ3RXNGVUZ09DWGJoWEd6Y212?=
 =?utf-8?B?VW0vM1dzWnU2RUl1QmJVbXV5cVp6RmNpSHM4TGlWKzVKUTNlNUdsZUxsT016?=
 =?utf-8?B?VXBGMEVNbnZpTnpDSFFHVVh6QUJ5SDRLTTVIM3J3Tm5KYzhjeVJhcmtFMG1Q?=
 =?utf-8?B?bFNwRDBIajFGRS9DakYxTVBOUjZnZTRINURoOURwNWViMjVLTVVBRk51UHpW?=
 =?utf-8?B?RVZWSzJRU09WMTZBQzN2TnhTSmU5U0JNcTk4cXNraVowNVdSb3RiblZTcEd3?=
 =?utf-8?B?SXBDTFJqQ25YMDM1SlZJWnhxQ1hLb3dGRkxuZGxvV3B5elJFVVRrOGtsMzVn?=
 =?utf-8?B?ZWlYU3BSZjZ6cHRodmpiWElTLzZNS1cyWFdEMGdWNUVueUdYcURkenU5a2Fn?=
 =?utf-8?B?dXJyaE5CczBrR0VJOVJqMm9EbkdPNFY1SjJXeXQza0hrekp2eGRva0tpMFRY?=
 =?utf-8?B?YTFUS1h5RGtYa1phSXp3aDgwQWtRYTZET2NjNlJLWkFYV3A0ZXB6aTNKTkx3?=
 =?utf-8?B?U1h5ZnFiUHBPVVJBKzJ5T0RqSUtYOUg0STc3c1ZZV3pNMGEwSGZ3c0Q1c1BX?=
 =?utf-8?B?ZEd3VVdURUJNcUlvWDJWc1NDNithN2h3eTNTYmNWemhXWDdzekhUODhvMU5x?=
 =?utf-8?B?ZStqZVl2anBzY1A2Z2RJUDYxTDlScHZPb2w5bjN1TTRndmFDaXA5S0Y4NUNt?=
 =?utf-8?B?NzA1cEtTNjhnZmFvd0x3RnY3RWdieHpPMDAzMzVBWUdPK1grYmNzSUJFT0sz?=
 =?utf-8?B?T2lIK2xSS1ZZeXlySnpOdVZTeUtScXZFbHlTMVBsVkhpVDlrSis5b2tpT0tW?=
 =?utf-8?B?MGJTampFb0ZJcjZFeXIyeDNuOXVZakZJSjR5T2UwUHFBTnFBM2tJbTJFMEc0?=
 =?utf-8?B?UUZYZGk5RHBHT1NkZHc5eHNqcGRXY3NyTDdVOG5SQTcycUdRM0JLaGkwdzB6?=
 =?utf-8?B?dmtpdWdhcnpyM2svTEN3Y1dWalR0TU9oN1AxeFZ6Q29BQkJCN0FGV3g0SGFH?=
 =?utf-8?B?T0FlVVNwRHlHdHBpbTA0Ujg1d3BKUWZnOWl6RUZ0Z2RITmJveU5iK1NmRFVq?=
 =?utf-8?B?L2t1WHM2MHI5ODRobnhjaDhtNVVISFk1TGQ1b205eHg1WUxRTzJ6bU9pL29k?=
 =?utf-8?B?MDdKSEY2SEs2MVl4Rjk0ZnUrVzQ0K3ZnSGRwc1YxeG5wZGh4NnBicVNFNVlv?=
 =?utf-8?B?YjNQTWl2RlYwK0E2RUgxMFVubzJyZWpXVFZJR3dMUDlhZkY1aU84UGdnOFM5?=
 =?utf-8?B?UjNTa0hNeWVuazFqRCtiMmNSdXdnUnJkQm44S2dNdW1uZGJIY2ZzZXM3Rjl2?=
 =?utf-8?B?cG9FN1ZUV2krT1lPd1A0RzgyRjFnYlo3bFBBbHdIczBoaDZ1M0dHRTd4R3J5?=
 =?utf-8?B?ZnFMTGNYaVhaUWRIbTRsZGNWcytQV0dVVHlmU3poTUpiendGQ1QvUVNlMnBp?=
 =?utf-8?B?YldaRkl4dzNPc3lIUXo0dVAvT3VQWjFSazhIbjdJd3FKK2NZM1lVZHlrdTZI?=
 =?utf-8?B?ZmNUajNZa0h6NTVqQ1RaZGN3SmtHQ21ybGhXeFJHMlZCWXFQOSsxUDRPbUVm?=
 =?utf-8?B?MmdmVjZhN1JlTUNGMGtPM0V1OUhlZ3dBTGhTQXZ1cDBhMFRFOXBpekFQekN2?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QAU9Fvz1NoMRv1ZOeqapsIuuzUx9ThsA3Ro79dzRrs0z+LNp/gYSm6bGD5T1us5d/MsGsOkBNHBCb1kcXLHBrrZFm0U1rBbg172VnGTas/VbUqgj16tMcSbAf2L91lwNwxhe7hFrT+cqlSm/dOT4ae3gnkmtC9GPTbVitMdQ088FxZbbflXihZwIgKlqK9AvDsHauxZ4Cw3CzEe6KBqA4qrHIgsEZUEUq0CtOcbBzhaBEpNL59km+0rpzwssGGMhzhX4quw1Fk2d77Y+w2nFURFqbuFeKbtYKVEXusMYuHuaAefxuHx9EuooRBxH8pQLk+oD+quzhGmsoB418pmnvlnL/rcDIrHDJpOUBCr8dIq+muG9rIKp5ZKU+u6/45Fpmdd6q5HGG/BfcDlbtlfjhLTfGUPdlghI1/+kg0L3RCCpzC8xeawlN1G5JgZChq38F7LtmeBD06UZ8xRdD8aWN1yzILMuOuAMS9XzvXXc5qwLGnd7u1c3uCAk3FZV5nlraTuk7omyBtTYdl666GB3XSTRkw/sI+KaPJpTBkht50rfrt+Mu6zOMTUlHUcOacernFz9ZyJIhRed9MXuPYTGZUGMw36XnTMrwM8L08h1maI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2492e6b-1141-4e40-6ea1-08de11478bd7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 08:46:52.1821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wN1o7QLXqle1Af1Ko7VvxlJMwdq/wgjlCuWy7UM04cWLPqd8fJvLI4BMvaH9HP6YrBERft/Ef1odQyu0m/WzbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220070
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f89a00 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=wrSJO_8jlS_SXyL89z8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: cv1dXK7c8gjorhfAhhABRAcHWMrYDYpN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfX6LuEzfcDHhrv
 4GxlErpKN+osPlehx5+icvE/0k0LjwNKPB5Y7E0rPspxIIIoK9T1qv919pOSo+gtK1nEUFu8/an
 wigOuNfBa4LiGx5zIcRiOMOS8KvBgB4cwoSGANcOUKRoLMFr7imXafhILZLYwP9EW1aTxO5BGF4
 XYpkA8p7oZbLm37kCEwDzg2PIDXiC4ZXv2SP96OoLtBMY+xDfMyF5lt4QzI2f0JXX+346V9wV11
 uEVEoHYv0Jpp4dUm6Bze9PyIYXkXWQnKUYm/32hOkuiiEEV3XjYu4WLZOQ3yAyJxQCMt0GAKOYA
 5GQBg0h1mjzCkxFynTMmkxBe63WUhP70VAitEt5UGyKe8luNtdYAlqoJ3wNaJFrXQrRnzT2oehM
 mYMf13xo3+Bh+Fp0fdbFypSNQPUlFLfFQRh9ohTmzHsqFeibTBo=
X-Proofpoint-GUID: cv1dXK7c8gjorhfAhhABRAcHWMrYDYpN

On 14/10/2025 21:15, Bart Van Assche wrote:
> Add a .queue_reserved_command() implementation and call it from the code
> path that aborts SCSI commands. This ensures that the code for
> allocating a pseudo SCSI device and also the code for allocating and
> processing reserved commands gets triggered while running blktests.
> 
> Most of the code in this patch is a modified version of code from John
> Garry. See also
> https://lore.kernel.org/linux-scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com/
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Apart from some small comments,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_debug.c | 113 ++++++++++++++++++++++++++++++++++----
>   1 file changed, 102 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b2ab97be5db3..cf1e0ef15811 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6752,20 +6752,59 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
>   	return false;
>   }
>   
> +struct sdebug_abort_cmd {
> +	u32 unique_tag;
> +};
> +
> +enum sdebug_internal_cmd_type {
> +	SCSI_DEBUG_ABORT_CMD,
> +};
> +
> +struct sdebug_internal_cmd {
> +	enum sdebug_internal_cmd_type type;
> +
> +	union {
> +		struct sdebug_abort_cmd abort_cmd;
> +	};
> +};
> +
> +union sdebug_priv {
> +	struct sdebug_scsi_cmd c;
> +	struct sdebug_internal_cmd ic;

the names c and ic are totally cryptic

> +};
> +
>   /*
> - * Called from scsi_debug_abort() only, which is for timed-out cmd.
> + * Abort a pending SCSI command. Only called from scsi_debug_abort(). Although
> + * it would be possible to call scsi_debug_stop_cmnd() directly, an internal
> + * command is allocated and submitted to trigger the reserved command
> + * infrastructure.
>    */
>   static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
>   {
> -	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
> -	unsigned long flags;
> -	bool res;
> -
> -	spin_lock_irqsave(&sdsc->lock, flags);
> -	res = scsi_debug_stop_cmnd(cmnd);
> -	spin_unlock_irqrestore(&sdsc->lock, flags);
> -
> -	return res;
> +	struct Scsi_Host *shost = cmnd->device->host;
> +	struct request *rq = scsi_cmd_to_rq(cmnd);
> +	u32 unique_tag = blk_mq_unique_tag(rq);
> +	struct sdebug_internal_cmd *sdic;
> +	struct scsi_cmnd *abort_cmd;
> +	struct request *abort_rq;
> +	blk_status_t res;
> +
> +	abort_cmd = scsi_get_internal_cmd(shost->pseudo_sdev, DMA_NONE,
> +					  BLK_MQ_REQ_RESERVED);
> +	if (!abort_cmd)
> +		return false;
> +	sdic = scsi_cmd_priv(abort_cmd);
> +	*sdic = (struct sdebug_internal_cmd) {
> +		.type = SCSI_DEBUG_ABORT_CMD,
> +		.abort_cmd = {
> +			.unique_tag = unique_tag,
> +		},
> +	};
> +	abort_rq = scsi_cmd_to_rq(abort_cmd);
> +	abort_rq->timeout = secs_to_jiffies(3);
> +	res = blk_execute_rq(abort_rq, true);
> +	scsi_put_internal_cmd(abort_cmd);
> +	return res == BLK_STS_OK;
>   }
>   
>   /*
> @@ -9220,6 +9259,53 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd, int *retval,
>   	return ret;
>   }
>   
> +static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *scp)
> +{
> +	struct sdebug_internal_cmd *sdic = scsi_cmd_priv(scp);
> +	struct sdebug_abort_cmd *abort_cmd = &sdic->abort_cmd;
> +	const u32 unique_tag = abort_cmd->unique_tag;
> +	struct scsi_cmnd *to_be_aborted_scmd =
> +		scsi_host_find_tag(shost, unique_tag);
> +	struct sdebug_scsi_cmd *to_be_aborted_sdsc =
> +		scsi_cmd_priv(to_be_aborted_scmd);
> +	bool res = false;
> +
> +	if (to_be_aborted_scmd) {

I think it nicer to return early if you can't find the command

> +		scoped_guard(spinlock_irqsave, &to_be_aborted_sdsc->lock)
> +			res = scsi_debug_stop_cmnd(to_be_aborted_scmd);
> +		if (res)
> +			pr_info("%s: aborted command with tag %#x\n",

I think that it is better to print in decimal

Or, if using hex, use 0x prefix

> +				__func__, unique_tag);
> +		else
> +			pr_err("%s: failed to abort command with tag %#x\n",
> +			       __func__, unique_tag);
> +	} else {
> +		pr_err("%s: command with tag %#x not found\n", __func__,
> +		       unique_tag);
> +	}
> +
> +	set_host_byte(scp, res ? DID_OK : DID_ERROR);
> +}
> +
