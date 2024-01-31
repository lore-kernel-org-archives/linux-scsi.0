Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B231EADA
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668579; cv=fail; b=W5Ld03boPI9w9NfMuKca9g18cweFYcYbsbaafqKRHl4xPEwzXll6Bj8m3gNee+eP3r/wo0N1xj9hnASeqyByjs6QpcJsd60pVN6xvZ1o2egSwYSN+L64Tr7CdvdQrFxMrkxTdhU8F0gDb0UTBp8rn3MzY55AeqDgwmbz5Knczzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668579; c=relaxed/simple;
	bh=5wqvHbzcZsQwPuZSxcBXG0sXDheFG3cvd+MiRqVIJnc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kJZb9/PYCFF2JLEe0L+OOWLqywZqY+sPJbPV+OEVFRP/l6xfopzF9IjEaxoDNUrKC8KpEt3txTF3FHY3L9h9lmLalwBTOVGh4+fwwO/29UVq5t2bvoF0QZy9mmkKJ75XzK0mJLiGhXpdZdF+1sl6jq8+h6/gKpVpxsfLqiggKsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GEc3nFiV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tl/wApYP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GEc3nFiV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tl/wApYP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjP7030549;
	Wed, 31 Jan 2024 02:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=tmA3K/H+ziipZFq9M90E9eS9BUARWsDyFYMiIY2QMyA=;
 b=GEc3nFiVxuojbEXOcAEF1LyWLscXZR/+Hb/jkdmPOrfvPZ6a4L36bQCQJA+tnHp2if1T
 yOy5FDfIc5dg/soR7lsZMJ1nFK6VueF/m87N/X76fM9AoroX+v6d6y+n7Zm88rMNukHC
 FFiJMI3dxBTeKCFyTpl0mf0QE2/Q9og4Xmo36FTqtTJiehfyVGFl12vhwx5FZa1KOhLl
 vC/kn+R8+yeQ5MxdsuhVzn2kY/XVb/OFez9HL8/iqEaPhxsKMVXfGG6XI815r7rmdBC/
 Qu4AYD91Z9IJ0jyCmuV0nGwV2wpmrB1nmZDtd+WojiMcXX2wA0aFj1Dxu6WUXcg4U66X GA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0kk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V06YDu035335;
	Wed, 31 Jan 2024 02:36:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e5sgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W91I93FLWXmwmGtOZ6r0HcJulMf+8y05r+xpCoHo+Xw3c7+oG04ZWbEoBoso4p2blguoS+9L1xeoJY97PryJR5e3dJin+n+gd5u5/U9FxN9LE9XygdgSl0DRdQ/LmA5RjJOj4w1LuhGpshsweU+N/FA9P7+b5T+719xtgHeUymXF/nmqTT7GqNGHZ7uN+EnIljHYKU5YPTSxl6M+1XVQ+F4B3M0X8IhKE/5LLHCX3EZdFODjlI4wG8gyJ/VnhNl/b+7c33W8BtrhY12Zc5cI2OslN4YwlejISRuTpWkJmIi2KeOr99RWIrI6SuGIdHIq13yBIZLZCxJrCT6TKeM0cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmA3K/H+ziipZFq9M90E9eS9BUARWsDyFYMiIY2QMyA=;
 b=mBTzKaVP/S7jGMHDjwY8n0/59ih9fsos7yjwJMJbTXqqsZTvXa5wFtpPdpTm4Vnn1j7YX3IJZRCj2bga684T+GjZ8GTFM1zsDamqDyvi2P9QoXBTTjCKHt6ej1ICsw/a2dQ/vwgFZFp46oSPw4apgz8bia4YXi7v4dXdU69bHSAXXKpGyleuoblLYelksJjsIjjRF5YpM4ax2bNbhwRP4FW669EMJtOc/PIz57vYmaOj17SXNWWhUuLhNFYQm+9h7qD8iboYPuNMbuooeAzFblof+CAv0/vzTx0zXOFNcgDK2DxYTwBRw2gVq5wQ2gFsky2jYVgCZXwwqOKgLDvK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmA3K/H+ziipZFq9M90E9eS9BUARWsDyFYMiIY2QMyA=;
 b=tl/wApYPBQx0Z7WSnQofJpoXIMjdxu7o0LBUF26CPhWWEzdKJ+WlsztaKHs92BZp9yEeHmc514QzMFUIHpBGiwgq5fSlJX6XX82S5l+W2wP97B1D99hjHgeDGJ5EaPWoFBIIkAW0piQnQf9meL6t1z7G9AZa4HQ2WaducaKvHZo=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:36:12 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:36:12 +0000
Message-ID: <e42c1da4-6c16-46c8-8599-dbed57fe2c22@oracle.com>
Date: Tue, 30 Jan 2024 18:36:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/17] lpfc: Use sg_dma_len API to get struct
 scatterlist's length
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-4-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-4-justintee8345@gmail.com>
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
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1dc51f-196b-4a7b-d715-08dc220563f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uy23zxtDG6KXHWpls7Nrg+zLM5oPwUTbxBGThMEh0WCXhjRWRa/xZJiYgdBhG5ewZdJ22wITHvkP1NPorXbWLARjMJW1UMj6sEifOZrWXXdQnJGYA6ExmCBpFDraqbF+w1FFByrP7tKQwwOCkmFYx5eMFnQOVcmnm9rzdpAAmqyeKyj2nRxkdiJukv/woxISIkR1PQcRbLHC9gmd4VAOgWBICSGARzenG4TSTFd95t0ZTdZpQbJoitUgiWC7kRnvAxK0L/tyhsItHIchyN+Lphe9YvByqavoFWnaMFPLHSEyaLPCKtYRN87q7ghTYjNOxw5zbgfcQA90Jne8u2QEeWniQN9hTHZmVFRJXviY9Hp5qsFECTp7BXE1u+46U2o8S/ZNvvccIUbiNB63ddmsR4Bi2lZy3Iw2JK3E10b+EhBgZEE0AGK+E/dkfvJASHzaMZBBVuUaKOd9ImXE6ulatVnGtE8qNyBSA1xlWT8xOq0Aivhy5WhWIk+4TkjZW10IdtZzW7eHebrff8AhtccKA7f0mHiloKjieLRq54DFHAYyBiiAR1J84cYFWyKXwOgGD4fAjcvCl6Wgl9O2xccopi9xWA+QzQqiXm9avui5QrY28xbwRX4nF5NuDvmpNjcGepJKp5KhE+9RfSxvAJp5PQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TUtrS2ZZTVRpU01xcWI3TnNCbkFGVXI5d3pOVnlpTUJ1enFoTVlnK2Y2K0F4?=
 =?utf-8?B?Q0pDc3lCNG5laDVjUksyUldvU0FuVDRRMitEWGp4T2F5YzhKTjUzdHhVK1Vp?=
 =?utf-8?B?K2Y1a2dvSVhwWHVQR0ljNExhbE1FYksrNzRDdld1UHQzNTlkeUtRZmloWGlF?=
 =?utf-8?B?NEtKZWd0dzhXWVY1dEU5VFNjL0htN25hK09ROTVCUUJibktMbjFyckdlclMw?=
 =?utf-8?B?VDJiU3J0RWNwN2ZPNGxKY0VwM25jajgrNWJXOHpFL01CL08zRzBvMWt4Y0h0?=
 =?utf-8?B?Qkh1KzFaRFd3d25TejNPS2lIelZMV2pNbWsybkhJMHNKZVB2M3hDcmpPdXVn?=
 =?utf-8?B?Wmhyc3kySzRueTN1bEhEYlVUeEtqL09sQ2FhSHlpdnNYeTd2MUs3aGZmN2xx?=
 =?utf-8?B?aUdlSUJTZC8vSi9WbXBTM3FMZG5PQkVlb1R5djBWVVVta1ZaSm9LYngreUd6?=
 =?utf-8?B?RXM5YlNCNDJyV2J4SFRobjc0SXhVbTI5Zjh4c2xpWDFla3cyclFoSjArZDkw?=
 =?utf-8?B?K3lMWVo2bTZrUXZuRXh3RGp3aE51QXNzb2poR1A5QmZhRGdGOXMxM1Y1UEtV?=
 =?utf-8?B?eU9sNEJRYXIxVGI1eG9neWZidGJHeDNXaFh1L21lYzNZcld4OCtMNTNlQ0o3?=
 =?utf-8?B?WmVvbmRiWXJ4VWFabDBLVDVGYUYzSXVUUldYS0FRZUJEWFVROE0yZWZEQnBL?=
 =?utf-8?B?alpVd01vVW9FOFQ3MUhySk94QTlGaXlrTFNjWDR6RnNLVVhpYzhlZGpxdDJZ?=
 =?utf-8?B?Q0kyNkl5SlRtT2NicmxVVkptQ2s5TUs0M0dKOVJzM0hSS0pqVFJweFJVNzd0?=
 =?utf-8?B?YVYxNU1SYjFuQWNnWXk2bVpoVThHREgxSnYvZFhzdXQ0a0ZpL21vK2FaSGF4?=
 =?utf-8?B?dzY1d1FuYzF0dC9EKzc3R0VPKzJQNDA2enFTSXVFQ21ZeGVYbE5YdGpDOFRq?=
 =?utf-8?B?NXdLd3d2S3kycnBQSG9hM1hyYm1CT3RHWk43TGl1anJGSHRiVnZNbmxGWkRa?=
 =?utf-8?B?TVJwUjNUMktlTVIvOXQ3bzJNWkRvWkZJb0VJOUJ6TEFzVmRoaFNxeUpXdXBG?=
 =?utf-8?B?bS9VU1hxNXZ6WWVnWTdhb3JrMHZDRmJLSWdXNjkzeHkwL1dqUkVESnlUY2ZQ?=
 =?utf-8?B?Q3pxMmZSUmZBZHhLenloRE9GOE9sV0VTNE9USWl3dkdrR3NQSHM1SzIveE9m?=
 =?utf-8?B?T1ppZWpZY243dDdXZ2M3THRxUWo2d2UwclJ5Vi9BTytvS3puV0VSR0ZXRVBi?=
 =?utf-8?B?bFgrUktqZjZVZGsrYktxU2J6MUY5SlFLQzFseSt0bnJsSVZVZDVjcC9tdjVn?=
 =?utf-8?B?SW5rcEJtbmhtbEFDSDhIVXcrc1FGMEFBb1lhRE84ZFowMmc4VU9QT3gyRkNO?=
 =?utf-8?B?TUJxbmRzK2pLYXdHZW95YkNPRzJpOE1PeWNBK2VML0Eyd05MdzU2VnIvTWF0?=
 =?utf-8?B?QTVzV1ArUENUeWdMbW1zMllTUXY3M3dRUW1ncDZiT3BzSDE2ZUxLd0pmNWxP?=
 =?utf-8?B?ekdxUHVNUmE0U1M3SjVlZ0lLSEUwU3FsZUVaS0RpL1VQQzlYRk5pcDA0U0x4?=
 =?utf-8?B?SStvclhuNzRKN2paUEVGZk5LL21ydG1RTXZDcVM4MCtXOGhWQjIzbklBN0g3?=
 =?utf-8?B?N1Jlb1FhMFN6STBLbnFmMzNTTUxxQkRBdE02a2hMVG0xcjNYanBCMk9RU2U0?=
 =?utf-8?B?bGZOQUNaQ2JPZ0FrcXNoZmtZRDh3enVlVURsVVkzQmZjdVYzRzFqdUNYQkdU?=
 =?utf-8?B?cGp3dXVtREFTOXp6dkJpRDVDNjNaUjFwNlFqVVpML3BSNS9LYVRxT2xaanEy?=
 =?utf-8?B?V1JJU3hILzZBSHdsZkxPL0JEVi92R1BnaHpGQ2x0TWhKSm5IOFNYNTJxd1k1?=
 =?utf-8?B?YitTZG5tTENPYzZ1UU5pL0V2Ymw5Qk9TanVNSXFjTzRkdXA2dnJjRzZXWmM5?=
 =?utf-8?B?V3NwcUtVZG5tQ1JSTzlSZlJqMVF4bi9XTUlBTVMyWXFuY2FlTnpuYVRyNWxF?=
 =?utf-8?B?dEV6bFJmcmFXeEdGQ3JPZmEwZWpsOXZ5d2lDbzJTNng0bXIvaFZDSVVVWlVx?=
 =?utf-8?B?dFZNT0o5WWNWdVA2dU9WbFhBeDlxbTJac2NiL2UxYnBOQk9nL1J5ZC95RWZU?=
 =?utf-8?B?UFhOTTdyOTVIVHRLOVl4VGtocWg5bFg3RmNsb0JEbzBuR0xaOWtSVFpVckph?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jGhmEOOY5GnieAXWVMnQlKBl+anIq2UDGKrb3Hk3icVZu4ZMq3UfXKDfWUFqDRCTR1UxoI/8mcPHCXhPwQQQpyvxfPe+77mYqmBpQMS3OgH3d8ZnGW8MolaxaGXuSp8LMdZwLtFHOFuWG+I5EfULpIzoaJVJc94W8wBojBdvl3fPBsssTJP17TKTpJ7srC0bVdY2opiZ4HN3i3eKxoihR9oi7koid2kwFaNNsGPVKyfH9Wfzw2uVEhRgNSrA/cbBGyn+o8UYoUtxazr0PnIY32WxticgpiAKzPYJkLmxRBlVW5BBIsbMX4NgE7IcuoZdpCDkxUTh1BVffgd+G+iS3LOw5z7ka+W3nOG3kOOQPgB4/zn6rz/iuHq7PENEvmlDyhAzldc7NmdV24pJApRejUagRLR11wBtdyebAITTizlte0t+G95+v4XxIwoIJbsm2vrGaG4mJcL1UEnbwNAgeBOFX6da+x19oa6l6ehk8LfoOQIXKjzY7sjOlvJQVe7ss2c9iQj2Fx2ttjnyT9/QOcvGT9Y+Zr+jmgitVKS1vXRKwIYQYXWoOGTMVmtLQki+2R0YGesbX2gn1GawzP+ScPXubBRH0aq/jwbbbdC/vt0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1dc51f-196b-4a7b-d715-08dc220563f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:36:12.8132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+R27UZfPkJ4SmpCi9ekfIUxKE5X87HRfv4NBSaHja33zWtUoBdB4zZ65eeq5XoEnjVHv63CCEpMDxzYWtzTjQPkgbP5A9m7XmJ5GU+R1EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=972 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-GUID: -fsHd8Pe7bKoOeBR7KksW3ZG_sVpHbLo
X-Proofpoint-ORIG-GUID: -fsHd8Pe7bKoOeBR7KksW3ZG_sVpHbLo



On 1/30/24 16:35, Justin Tee wrote:
> The sg_dma_len API should be used to retrieve a scatterlist's length
> instead of directly accessing scatterlist->length.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index d26941b131fd..07e941da8a16 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2728,14 +2728,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>   		sgde = scsi_sglist(cmd);
>   		blksize = scsi_prot_interval(cmd);
>   		data_src = (uint8_t *)sg_virt(sgde);
> -		data_len = sgde->length;
> +		data_len = sg_dma_len(sgde);
>   		if ((data_len & (blksize - 1)) == 0)
>   			chk_guard = 1;
>   
>   		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
>   		start_ref_tag = scsi_prot_ref_tag(cmd);
>   		start_app_tag = src->app_tag;
> -		len = sgpe->length;
> +		len = sg_dma_len(sgpe);
>   		while (src && protsegcnt) {
>   			while (len) {
>   
> @@ -2800,7 +2800,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>   						goto out;
>   
>   					data_src = (uint8_t *)sg_virt(sgde);
> -					data_len = sgde->length;
> +					data_len = sg_dma_len(sgde);
>   					if ((data_len & (blksize - 1)) == 0)
>   						chk_guard = 1;
>   				}
> @@ -2810,7 +2810,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>   			sgpe = sg_next(sgpe);
>   			if (sgpe) {
>   				src = (struct scsi_dif_tuple *)sg_virt(sgpe);
> -				len = sgpe->length;
> +				len = sg_dma_len(sgpe);
>   			} else {
>   				src = NULL;
>   			}

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
