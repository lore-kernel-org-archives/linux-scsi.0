Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C5DF61
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668755; cv=fail; b=aHhRmvYuOuke60ETifDSM3s2NLQ94RN8/1GE6LZYRPA1Vx3x0A/NdRXI9LOhr3kR5fVGUhmdtbBwuRxi/Li7Mr3pBKZL/zUjYGG7OOp8bp18rNkzicsyztvgF924Iwp9mU0qu0yzpbXNvFFbnL9dtkR8YHwQ+Vz04BaqtGd1yoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668755; c=relaxed/simple;
	bh=zklHgBoDZfdSIZsvFYBiRaaNHnuiV2w4Y6X4zEsqYUE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oJD6CWZMvo1TiibtOIod+8/nkJIvhW3/C2IaDVa/DC6AeltUR4Nx57BILNIab4ikv/yp8G05ntr/2FbnkHk2BFFBUBCq8G2sV2jQaVNYjrg6FZSzjTCbyE0krGmYBYd0bxDFJToQ/8Y3C8hhptAR0RWNV/DH99D+6LL0ZKRbxMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O+j5Ug8X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nw2yAvOC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O+j5Ug8X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nw2yAvOC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx28V003592;
	Wed, 31 Jan 2024 02:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=G0j9vALBFlj0jAc6/7fZIcDAUyQ0Ecr2dhhjKJ5KIj4=;
 b=O+j5Ug8X/qAtTHsMKwST7gXfJ/5ePUx3+UJDTKntkqzXCNa4qKtPf4qOW4lRY8bTQBu/
 gAxFruwCUCtrWMorRZVJls1TPu14m2zUWSmvZHeOspUyQeJTJRVAHb9Lb77Ei02fBygL
 G1YSOfrnrkDhtB6BbnyXyFVGnXgqK/YeI43ACa0zVZyD5og2Fb1cve2hzCsqR9kG78XG
 /uZ4jciUE02nsWc9sHR4wa4EGkscX/h7zKM9cYrpwGpL6WaC9BM+t6RWdxF+j8FcPzBO
 eHypI7BiuEOitOvOByjIlqqGFsK5mGuc/MIrbjsWO8qKViNSczgjTKS93bAzEc8r60nm Lw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8eggcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:39:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0oYA5014837;
	Wed, 31 Jan 2024 02:39:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9edsrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iN2nmFUpbhGltqvgkBsiqv2eEundSsmqmjG3L9s+HmtkxBTB1T7/LnxwUrgp7t0qZ+6f8sPPx3LhkO4zOQOpv1EPl3vliT39l9A0cTV1qwg3ECyodf1OGhIjJ+Folb3ywnIsWNarFfP3jD3ZluhRP2Vy+guWmh3wTpWfkHH9TWS363RoPQbiEkmy+h13KQfXwJHxG9i8kLMNQjjSQZpW8AHdiZz1BOSYQL+U3k0tiO3lsG5Q9uRj5jLjdhNWKLHfmyKWkYMQHPTq7bFKLowtfl0NBtubaH4YYHS/wzd3VwZbDWvw6/xz0TmALe1p2yZCeTMCJt7aJrBtm8yy4SY8Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0j9vALBFlj0jAc6/7fZIcDAUyQ0Ecr2dhhjKJ5KIj4=;
 b=GuDvREJDDO+KXwkiAGgiGqpMOfbcvn7F3eRMQxueSviF7SsUt88A2SvNn+zjSrD56HEMv0dnM4ful1wFsDdhe8RHJdfxG4QORnSnE8JAnmp7LcmG/dXuPyW4eegWFwHpfJ6PylGi4FkLdybSzWD1MjemXcTvcE4Q2+AiT1+7W2eYho5Rg0oy+L2cUQRiJM6btYXWt8+ZNINNejXA3a73cStC2u+QL7jhG6Ml/04OnGi6QBrhYdnorYfJ4KXDEdqRS/sP3PINNKtZeOprA1Eb4HMYVkxJ6D/0YeoTkNvgsbw9rHXK/mL5LPpbdlys6tA4CxLgWKqRn91lIaXD01l3Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0j9vALBFlj0jAc6/7fZIcDAUyQ0Ecr2dhhjKJ5KIj4=;
 b=nw2yAvOC5OneTTJAAxB4WoQXCUI3udeQCnpm+Ml3RbGxFkxxVxhBpPMZ2R2xoGODedOkLe3Mr+EHUBrdI6wK80CCROXHbXsyUuPd7aGVfIXp0sRH6kSTrwVwvTKzRA4N8U6odQYL5wWC7IU6ZiEScXf8oIHSTHqYaiopAoHMUR0=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:39:09 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:39:08 +0000
Message-ID: <b2cff78d-2f0a-4e51-9884-cee311df7f53@oracle.com>
Date: Tue, 30 Jan 2024 18:39:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/17] lpfc: Add condition to delete ndlp object after
 sending BLS_RJT to an ABTS
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-9-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-9-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: dff4de02-1993-4e37-ace2-08dc2205ccda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8Y6AAz+xt6BmZSAxdiakiG6VvYjs+YgHIQfp6yy58EZleaKcVL3bEbpxw2opZwnPoQNJ7BrkircbCQxvHTt3B2YTWehIbTdWhMPmjLlpHnU5/JBxtaXkEapr7uJGk9CNDvJ0MhY8pct9m3k9frUMTMV73RPpR9tgiLiPTYVHq1cYt6PtDg/MMJj42lAnhZJi0VdHjzO3LSFJh1Bk017Iywu+YFmWH3rCLAj3gvlHUeRgnDTxEffsOHkWPdvKUIkKGUnhemuY5HpiZ6InsM29iEhOXt6baikMYZEGjQZxVva0sSUS/r1oTRpnDfhrI49N5eaaJEsG0WakeTLPAy9RkAXS2Ns3bKKLA4aZFKjiQLxaQHkHPwpy487934KmcBNOQB256raYjfQM9J4rQ2qHgNn789mfXn5297RrhgoZza2hk8B7eJJg+yLfcYBAWZVvGcGCc7QDjEDhTAruy8Lp+RwC5lk03KqvZ/E8LisveI7JkWWpbJBN0cj33cq0tfcnOdd+u7/k+Nqi1kZfbPNE9tBFXchp6aluXWn2mc8R9frvJthLKWrT656JiDpjlM7v3tS2aIoVFfWHHK/3dkiNw967Xptl8+mlr4xTpHPhFVLrkFJa94OQpTYHb/4yN19ssnyIoZzjSm2zYrPgIUyynQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(2906002)(5660300002)(36756003)(66556008)(86362001)(66476007)(66946007)(83380400001)(316002)(31696002)(36916002)(53546011)(6486002)(478600001)(6506007)(26005)(6512007)(2616005)(8936002)(44832011)(8676002)(4326008)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Ykl0aktvSXppSUJJMG1uZ1hFVTFlMWpOMjR3SHZvTnJZaFlOano4R3N0dTVt?=
 =?utf-8?B?MUNmenpnaUZSSm5LRlFPWXdKMXBjQmV5clR1bTBEZGppRDVmVnlaZXRkVm9K?=
 =?utf-8?B?VGZyZm1JSkRoZm5nSXNuVkszT0NlMEZ4cllxTUtZU0JRSmV5bTBhc2x2QVNF?=
 =?utf-8?B?UW4wbXZYOWRtbXlPVG02RHovZmlSZGlOZmhxemQ4R3RtcUhTY2dJTC95bENr?=
 =?utf-8?B?QU9MSms1VUgzTEhzdU1VM1FnQXJNTUpOcXRMb1BLU2RTSzVldXBtTStLY2dP?=
 =?utf-8?B?bisvS29ORUZDR0UzYVJTd2k0NklqMWJ3UW1qbVZlL0Zna2daR2RWeWhoTmZS?=
 =?utf-8?B?RWxoSy8yYmw4R3FjUm8wL05CUlg3Mm5KbU9oV0Q0bURqSDVNQUNwRUR1K1NS?=
 =?utf-8?B?TWxuQ0VOQjhIWUp2Y0JDeEI2Yk1kNldGSmpJeXVvTGRHL2FTeU1jMXZiRDM1?=
 =?utf-8?B?cGMzODJwZWNGZGU2SkExaVpMdkg1WXg3V21zTW1JcmsxVXBSRnJTWmVNUkda?=
 =?utf-8?B?c09EU3UvdzFWSm80VG1seGU4RlpiUkpGMXZETldlRy9jejlING5VRU4yU3p4?=
 =?utf-8?B?TjVBcW10SlFmMEUxd3RKSnlNdjFXOUdhMFhESFM0RXEzOVY0QzdCQUI0WFpP?=
 =?utf-8?B?bTYyd0JoL2E3SWk1bkNOT2hTRzE2REpXR3BaSEVqVFNEaTZrVVJ4Nml2a2pQ?=
 =?utf-8?B?Q3U1T0RaU1FLQVU3dHNGWlZvaVREYnN4NGM0akFiQ1pyaGJxK2RWRzYrNlhx?=
 =?utf-8?B?UmFIS0VTcVRDMUtpbXBmY2JGZlJpYkpNZmF1N0FJTmRDL3BCbmxSaGxWWGdZ?=
 =?utf-8?B?UTRoR1MyRm9KSVVPZzBPbmhITkZkaS9ENVMwUEpGQ2FmM1V5c1FYSjI2NlRV?=
 =?utf-8?B?TG5HeDJvTllzd2NQbDA0MC9YTWJkVjRmc3VTMU5ZRDVVVWVtV29JYTJ0aFhq?=
 =?utf-8?B?QUJES2thSjZoa1RxR1VYWFVBbUJLdHBtOTB0cjZLMGpnZThKbXdta2VYU2Nu?=
 =?utf-8?B?bWdUcWhDZjFLM1ExZDJPZFJJYjhLa29jYzRZVWU3dGErTUlOTFprWmRSREFL?=
 =?utf-8?B?K3A4aVllVDk5RHRFTktLMVhCOGhrd3RpMFlRWWRiYktwN3ZUeExvOElFRmJy?=
 =?utf-8?B?dHZrZlQ2OTQ5ZmplZ2tYZW9pQ3ZuNCttTDBLaWRMQU9LanZmTG84V0RqcDJL?=
 =?utf-8?B?eURqL2U1dWlzOGhoNjk2enE3WWxocVpRandKU0VlWlAwV0ZteW95Q042NUZD?=
 =?utf-8?B?Wjl3cEpKNHkwVFdHd05OUDlVd0I3QnRKYWtEakw3bEYybDhhNUVvS1F0K0o3?=
 =?utf-8?B?VTdRemhjSHVzUUZSb0pVOGlRRkRuRFJ3UGsxcUpmTXNVS3RVRHIyVmtBKzI1?=
 =?utf-8?B?cVY2Uzl4cEJkdytCT2ZpeVlTR1ZpQjcyallBMXRsZHNhVWg0OWYzeVlJME5l?=
 =?utf-8?B?a2NMQ1Zud1o0OEFWWnVMS1hLaGYreFQ2Um85ektFamRDV2x2b1I3b2dxN2Rt?=
 =?utf-8?B?MnJCcWgvbzFwbXhwcnNEa29LZVhvWkpocHZBVFdWdnJMZFRuZmhOYk9JSGgr?=
 =?utf-8?B?Qkd2d0VNZlhtY1VwdVB3b1hCQWc1MTViRzMvNVRoMTB2L3dzd2xmL01CcFhZ?=
 =?utf-8?B?SkQ2MFZzR2NtU01KZk9vM1NLeERsdWR5TXhzMGNEWUJnRGNINHlNdEJwZU5Q?=
 =?utf-8?B?aHFseWZXcTdGd0tXSmhyTnluV1g3MTJYQTIra2dLVkwrSDc0UkVuQmZjWENE?=
 =?utf-8?B?aVU4bjBsdTJRcEo5N1VaanBtazJzWlp6aUVSMjFtZGNPclBnUkVuN0JBd2M4?=
 =?utf-8?B?SHQ4bXNBaStkNnkwdy9XSWhqdVVIdkM0L3NZWm5jdStWSHIrSW56UXNZMlUw?=
 =?utf-8?B?TUlnZUcvL2JJYXdQRFE0WGE3cFZLUXhDb2V6SW1Zd2NEay83UHo3SHJpZUM3?=
 =?utf-8?B?RWRWcSsxOVg0Tzl4Y2RXdi9XZUt1WTZvTld1TmhUa2R2K1ZMZ29KOTBlbzJQ?=
 =?utf-8?B?MUNWa3A4a1VNVHIyblVFVWtjMG43OFFIZGRMV0VzZWpmdldNT3BuTlFUeHZH?=
 =?utf-8?B?Sm51RmpmbmdGbTNGRlorQStkZ3JabmlVZUpiUTVvUW1GMW1aSzk0ejVuTEF2?=
 =?utf-8?B?SWp5dnRwWGdkRFNONTlTVVQ5NjlpOXBhUERzWERSY0RPOWNaZnhLZUZVbEhW?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bTzZ4N9a1b+vj9gJyDvDzIEmYz+/qqlmq4+JMLvJkFVZnFK4KjMyzl4ZGFwECmbMtiEqHNke3qgJvfQfY4vLy9TxiEZxuPrDNl2c5IhnMrSdEItl3ZgND2wuOxO+cbQxr8m2msY4kCJy+t4MZq0/j8BPmnHrmaohTkf40DjekYjt7nJPv0p/J8UwYQ8gt+X7K/Q+T+9y4eO0sDYYLC7jfRsORQ/Q6GoMLjCmKvpNZcUWS4ofCJufPIKBd1zi/Vk4jweiAJu7FEDmB6QVD4YZfZTAI6tiZypxOd6eo0UsrioDCFvxze7j9HNaBXcvObYwlfXQhO+M/ODPWYVKEwVe7SjGsLIv1F5827E9q9EgF44ngxSapwaVoyI8n02gWZk/FE1JX1jjnMUDid5fOuk4q+RZkPLFa+1Z5YwuzUNI6mMd6RHcMvLNRW8WBMC57BYjwSVyKCDQ69cvJ0M1lE5hGSIjBesBkVwlSEdukH4hR+H9k4BQZCOdthiZQMUwzmhN4HCjr5/JjO5JG4Chp1TWnGv2jovtWCGCSyUuqS1Y0UsdRaopSk1ejSg6JkPWmKEbQnesWDlmz3FBUzI8LH8aUS+oAlZYRDaOrDOmMtRY/+Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff4de02-1993-4e37-ace2-08dc2205ccda
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:39:08.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzsd/B3FkWbTfRO57a8KYCJ0PlsEpBejWJDQjK76HIT88bTDJ3T0PKeBLQivRnsNjjFHoct2mYcGEWcYQsZ6cJM3V6m+9EXjfV1A5fEdXK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=971 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310021
X-Proofpoint-ORIG-GUID: A2XNGtw4fKCzeOEl6FYcvJO3_97zKZUa
X-Proofpoint-GUID: A2XNGtw4fKCzeOEl6FYcvJO3_97zKZUa



On 1/30/24 16:35, Justin Tee wrote:
> The "Nodelist not empty" log message and an accompanying delay may be
> observed when deleting an NPIV port or unloading the lpfc driver.  This
> can occur due to receipt of an ABTS for which there is no corresponding
> login context or ndlp allocated.  In such cases, the driver allocates a new
> ndlp object to send a BLS_RJT after which the ndlp object unintentionally
> remains in the NLP_STE_UNUSED_NODE state forever.
> 
> Add a check to conditionally remove ndlp's initial reference count when
> queuing a BLS response.  If the initial reference is removed, then set
> the NLP_DROPPED flag to notify other code paths.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index c7a2f565e2c2..29fd2eda70d5 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -18933,7 +18933,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
>   					 "oxid:x%x SID:x%x\n", oxid, sid);
>   			return;
>   		}
> -		/* Put ndlp onto pport node list */
> +		/* Put ndlp onto vport node list */
>   		lpfc_enqueue_node(vport, ndlp);
>   	}
>   
> @@ -18953,7 +18953,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
>   		return;
>   	}
>   
> -	ctiocb->vport = phba->pport;
> +	ctiocb->vport = vport;
>   	ctiocb->cmd_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
>   	ctiocb->sli4_lxritag = NO_XRI;
>   	ctiocb->sli4_xritag = NO_XRI;
> @@ -19040,6 +19040,16 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
>   		ctiocb->ndlp = NULL;
>   		lpfc_sli_release_iocbq(phba, ctiocb);
>   	}
> +
> +	/* if only usage of this nodelist is BLS response, release initial ref
> +	 * to free ndlp when transmit completes
> +	 */
> +	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE &&
> +	    !(ndlp->nlp_flag & NLP_DROPPED) &&
> +	    !(ndlp->fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD))) {
> +		ndlp->nlp_flag |= NLP_DROPPED;
> +		lpfc_nlp_put(ndlp);
> +	}
>   }
>   
>   /**

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
