Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D541635A4
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715094939; cv=fail; b=YCAMyScxmhyUl4o4sbCGBwhVraEnM8olyGTLwddUoNVpCprwZszfy1UUmVtjaHaL36jPpcP1z72b8iEUg87KcCw49ul0iL1Z963OFoP8/enWTx3FKH0bz6ww7jWnuZm8/W6y1pDSIADi0wGUUPw3MaFD+NdMnKBPXHN60E/bHd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715094939; c=relaxed/simple;
	bh=nh5dDROwa9bvDlT+cdGRWcg4VhPyQ4Xjs+XAHIqR2Mw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RzQYFH2coUHc9HaqWu5frnoPyUEUbOGIyCXjnvAneKu/rRHW+11STpEwgnP44yB8I3dj1u++7piFNDllepxMKZQGfAGwyn9YN+MJgxi7JG/PzAQ/Xqq0pY4ndfOwd6ZGGFW2sOcu/69Sz3YtO0Ail3PQiJVboP2TPeMKL0FufpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YQ+sNgpH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cowv48w4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YQ+sNgpH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cowv48w4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44793vX7016424;
	Tue, 7 May 2024 15:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=OxUKJjp7iZeq5wzTxAJ6higy/asmLrwq+TjXULSx7eo=;
 b=YQ+sNgpH3ti50lHv8pWyrvOnFoCoF9ZLx4gS46L5ZyMODxXuc6m/hfFTuGmkeFeogyMn
 pWe47ZWHMN7VbljhchCFNbbv9h19XViO6iBzDqyPjWQqTV3cCwQllg0R6e2rDFsa79zJ
 qNz1mJHiagBFAGyqGVfn0LSk4bpVGgCmGWCB65BTEFuHpiF7cEIxQh6DCjL05dWh2Y2z
 /0ACOWwnWpkU2RKBJAw0x3wqOJYHIx6k2kpKu0v48rCn6vaDDdP1e1nJnXyyu6seFC+I
 d8BN6m3Y5j34Pq5KeYbAlVF6oCsG0wFyu9D/8Kouqju/+KBI8j1b75AjCw4s+hSTTSZO yA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbt558vx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 15:15:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 447E92oI006998;
	Tue, 7 May 2024 15:15:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf85vsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 15:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXQWkvmD64Swk0VcD5ftId/Np4fdCN95y4ofd5Awr+DZmOVLtVmBrk375b6yoY7ulX+HAzBupNAvdbwZLk7x/bWbz3wtKeXCRQDl8l/+l4w/dNMFflEzr1vd570GiPou4tgoTbvA6i0apwgvW6WO6nfj8RNQEVxFXCjNGcvTr1rxo7CX+rIRWBIGQWZmuEL6EHe+j8/KuyEicujDf1b0fOWl4jE+vAH83Dz5LAVALt4yPRCXjFpgmq9/rPKXQvLwdu/sLeriBLgdRmn/+XkCZkqExb5OidIqel24C08ULkYfgVbG88sep8efZ6Ln10BaVdZqnRJqC3Lo9cnoKwUtVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxUKJjp7iZeq5wzTxAJ6higy/asmLrwq+TjXULSx7eo=;
 b=Dq5llQHwIx7a+1Ll/PKrw/m+IsFl63SBEyHnvmpLfMKydoLkJSi1zFXbV4mWTNeI0MgzPjpYgyJSGbLzOFHugJyBPraZKirQKYnm8ctAa8jYMOXCAp28hnNUwmXPBmKR57kQcH6CBXf01ZrpHqiwqIWyrVROeRSNsYWX+pVKsdXkO3LfmSrYAYLroE1zLWonVcvkpQrLKJHqQWsShss7TvDdWXERIoACwdH/Pqp1xt7XPPlTzVicoh/XD2hQTTHHfXgaZUMniLRJ30+brzYS2N0T4+IOQKQpwN6ndc5qXoZAyeGmWlKuLx767ijyQdI92olr78/kNKK2EcMHiJsx8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxUKJjp7iZeq5wzTxAJ6higy/asmLrwq+TjXULSx7eo=;
 b=Cowv48w4EiZkYHCVBx/1toqAYOgfqBvegIOUZfACUvZ0maiLCC73TcIrXAfpJSYudzAdaJkSfwM26EFiRO+oHnCODAenV8/JIYN2LzqNmNrojBzc67jtQ0XruS5WUTI9UMZ6ispYzdBt5ghXPsraCdnlNadzfQenhdP25RIlbAc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5679.namprd10.prod.outlook.com (2603:10b6:303:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 15:14:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 15:14:57 +0000
Message-ID: <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
Date: Tue, 7 May 2024 16:14:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>,
        Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: 347c77b4-976f-437a-e61c-08dc6ea874ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YnJWRzVIbE12ZjRPTWtvMTFXU2Jla3ZZdG9FS1ZNd2ZEL3hiSG5yeVJLRzVN?=
 =?utf-8?B?ZCtWd2dPQnRpOC9TK0ZCelhrYmdsTnk5RXM4S0tKcm51cGpxdk5FeU1jRW1B?=
 =?utf-8?B?YjlQNW5wSVFwaXlaVkEyejh1TFkzNDE3Mk9MaFdaZHJSN3c3bXJsUzYxVWo2?=
 =?utf-8?B?MmxlVFV2bFJweVBwaEVTc00wZ29DT2V1L1lKY0dBWDgxZFBHeUNzQkpTZXVI?=
 =?utf-8?B?amVWRHovUmJSdUhlU2pYS0g3aEY2d1Bha1lIV2c0NThYaE9KOGJEdmIrQTdv?=
 =?utf-8?B?YlJOemFvbjAxV2pTTWFad2ptYzN6VXZtczI2MzRwRWk5KzErRG01WmV2QkFZ?=
 =?utf-8?B?dXA0elA2OU5JS3RCdkNQczgwWmtkM1J1Y3lON0FhNHFLRUFtODZMOTVYaDYw?=
 =?utf-8?B?bUF2WnZNU1o5cVpUK0J2M2NTUTVJNEZMUDM2Rk4xb1hYbEFKMy9HdFBMdmk5?=
 =?utf-8?B?SEtpTkxpL3RJU09yTFNVUExsbU55Uk9rdERhekxzZEVHVjBBeG5LdVlVemtK?=
 =?utf-8?B?UUlkZC9zTEphSDZjdE4wT05vVml1RFVkS0dZa2F4cHY1NDkxNjFrdnN5cUFU?=
 =?utf-8?B?UFFUYmRzVlBma2JERFVPQnVsQ1VaUnFPZ2dFSmhnaCs3emRiWWludHh0WkF3?=
 =?utf-8?B?VEZTYWZQaEVvUlNNL2kyQTc1WTdlVC9aOE02ZjhON3lzRUpacE5uaHA1UWQ4?=
 =?utf-8?B?dWZyc2EzN3dWUHBWTUY0OHN1VEZzY2M0QkdYRXlCQis3VlZRdlFzdjJyUEN4?=
 =?utf-8?B?bFNRaDBEL04yaVRZcG16QVk4bEpxTW9wMEh4M2FsV2kxNWFOZlRKRDFhZkVR?=
 =?utf-8?B?Tnp3bUVEaGIvVG5IbExQQlFzSUJMR0ptREgxZXBCV2pDeXBTZWZORi9oTGFM?=
 =?utf-8?B?SmNLbVFaOExDR05PMzMrSC8xd05EajgrM3VUU3hkbFcxTkRDemxFMS9TVG5Q?=
 =?utf-8?B?TGZFTzFnSElIRXRSWTBHdnpCVkFMSUZ5VXR1UzJPYUdBM3BpRlkrVXpjU0F5?=
 =?utf-8?B?SjNyUWc0WkxIekhYNVNWaGZYZXl1bWU1TDlkM1FSSURnQWZrclE0REdUQzZs?=
 =?utf-8?B?NWI4QzJCZnYzRVljUW55eFIxV1ZSS2dxZWdwSU04bmhPZGFYRWpqTXg5SXFP?=
 =?utf-8?B?Z3k3dFhnZENxSWllandtUEwrU1JiL3YwVHZqQytHYW5sOWVFZEVQcTdFZFly?=
 =?utf-8?B?RXhuTytlVi9YVTFLeUFlaHlSeVlMRUZWZ09CSC8vV0RIeVM0L0ZpUHp3a1BZ?=
 =?utf-8?B?RHp2UUZ4Z3FsRG9zb3RMb0JidTNhQ2dZRWFwNnlPc3ZQeGM5RXlXSHpDbXdz?=
 =?utf-8?B?aXNBKzd4ZXV1emZlVFdEQ1BidDY0aWhwbmJValZmKzh4cmh3TDBIZXVGMlFm?=
 =?utf-8?B?NnQ1UXZNaTUyUEt6WUwxRjdlamQ3K2c5UUozbmJha3M3MUE2VU9ENE44K1Y4?=
 =?utf-8?B?dTBUYlJTcDZ6ZDVMM25ZRFNjMlU2RVI1eU9LL3NEVzFWSDFwYjJvM1pOc050?=
 =?utf-8?B?eXZQWkRMcFd5b0hLTkZJUlR2aXVYTzhVOTBYRHdPMFhBUnFNdlRaK1VhaWlo?=
 =?utf-8?B?Sm1vVHhwMjBPc3grMGpCcGxib2ZuZzQybFhFT0Q0Y2NPZU9pWktFYXFoSlE2?=
 =?utf-8?B?YlRXSXJrVitYUmJ1T3pJNkdtdXR3RUdjVUdLQURJNjA4M2Q5MUl4MjYzaVpq?=
 =?utf-8?B?Zk1pNzYrY2NMTDVkMThURkZNQ3JVKzRrWTQzaGlNUVc5UjBNODFYL2lnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cXRzYVhZdkUrbmRGend1SC9vNlRuWlRQN0E0cjdML3Juc1o4T09acGJmcDRu?=
 =?utf-8?B?TkNwaEQ2bFJzcVFQMHNLMWIwZ3ZucjF4NnhwQ0ZNeSs5V0dYb1NjcmVXbWF1?=
 =?utf-8?B?MHo5N2J6YlIvUHR0aHp4ejJicDI2VG8vZWlXdXorUTJRaFNNVXBxNFJmekFG?=
 =?utf-8?B?ZTR4ZHR4T3d1YlRQdmdnMkxPSi93TTRhMUZuYjhyMm0rakZmWTVudWMrempX?=
 =?utf-8?B?OHg1OGMvUEdDUVBZOEI4Slh3TXhyM1hiZzJzYmVodlpOVFN6TDRYN1hoZFZG?=
 =?utf-8?B?UG1BejZRN2oxeUxQem1IYVE5SUZnSmdDdHFlemJUc1Jwdlpsbm4rc0ZmdXQ4?=
 =?utf-8?B?STlmclRMREhZc2xaQXppZGlMMXp1c3VJR0dBZm5CUVY0U292OENUR1p5U0th?=
 =?utf-8?B?c3BxT0dtdm5HUDR3NWxZTHpiemxJRWxOSnQ3anc1eFpRS25CbFB2ckR5c1Br?=
 =?utf-8?B?Ky96UFlEOGRLODlGL2FWNDhsY1hBTWhKNC9tSFZReUVEQnhIZE53TGlTaFJX?=
 =?utf-8?B?cnhRWEx6OG9zWDN3UHlXSnc2R2UwWnFSekNHN21ZanVmWHFYMDRTZVpmWk9W?=
 =?utf-8?B?eWlCbDl4Q0drK1BPYlQvQUZnS1ltZC8zQ1MrZWhsUHpiNEo1VXlXRVZRblha?=
 =?utf-8?B?VDVIK1g1TUc1eWdleUxSYUJscWQvYld5WFl5UTNRQ2gxQ1NiL1JETVVRUlBh?=
 =?utf-8?B?UVcxZ05KdDlGY2Y5M1pNaGUzY2FacFhsNzF5MWhYSElVcEM5S21ZMldSSEE3?=
 =?utf-8?B?TEtZYmRRRTdPQlNwSEdrdTFLc2lsMVorcHJVamRFNThMUktWdjFPMnFSS1N3?=
 =?utf-8?B?T2wzWFc2d0wyLzZUZmc0b3pyKythajduV2ZZZlhWdStVUDNMRFN5bTVxM3F3?=
 =?utf-8?B?OGdOQlBtN0R1ZHRLN01BNlU2dVN4K1dkMTIzNy9BaGpBcDhpeE52dWxBcXA0?=
 =?utf-8?B?Q0xqT1N1dEdFaFpJR0l0Z3pNRzVYdXJQQ3d2N2tHb2NINVhXZElxd0lyZCsz?=
 =?utf-8?B?SSt0SHU5MHJYTjdxeE9KUEtlbzFndGNseFZ1VUdVU0FFemNva0lMM3krSk5L?=
 =?utf-8?B?RUZtNnc1VjNmaUd2WUxnc0c2V0xoZU1WSTZIK1hKR2hITDRENlJZYkZtNzh6?=
 =?utf-8?B?TWpmRmJMNlkxV0FGNW81NDBTb1FBN2hGMzhYT2Z6SVltVkNOQjl6NldUZ0Yz?=
 =?utf-8?B?c2NNVUlMNktZM1B3Rjl4MWk5YmZIMndrNW1jSm5HRDdJTVlQOHVwYXoxZkd3?=
 =?utf-8?B?R1piWlJ4SklqeGZtMmdZZmRGRGdYeEpnNUpmTyt1elZxYUs4RmhRWDhCZG5p?=
 =?utf-8?B?MWk2Nk9kUXUwYjN4MFd5OW5HUm5YbUxWSjhKV1RWNUtNWGdPb2N6b1pOaTRD?=
 =?utf-8?B?NHZVNjV0SGw2UW56QWZwNWhzL3VqTlNzV0FrQ29FOXdLa3VuVTRZL0x5ZjJv?=
 =?utf-8?B?Nnk1ZVVObmZ5WUpIQk1VRk4rakd1OGhsdUcxemZnTGZkdVVFc3Fua3ovUEJh?=
 =?utf-8?B?bUdJWVo5NnVhNnlYUlZ6TmFlZTN6cjZ5N1dkbkMvVmppNnFhMjhoTUhBeTkr?=
 =?utf-8?B?eEJ4QURFN284bDdRckhCR3pkK0hndGJkV0VnVUZTTmo4UlM0WHZBeHNqcHFZ?=
 =?utf-8?B?V3JKdFBMT0pMTDRDdWlGL05qUURSUE9pVnVMOWl6em44WHR5cEN4OWRPVnpk?=
 =?utf-8?B?YnV5cHZaWlBGTE5SbkFLeVVNbGQ4K0Y1T3l0M1gwckxqaGloQ053TmIzYjNT?=
 =?utf-8?B?cXUvRTJEUzZYWVBnQVRkTWxFYnVYWkZYYWU2bEtwb1I3UjkxMGpGSDJVVnhn?=
 =?utf-8?B?bitxcXNqNURQTnhJOHB2R2FEdE51ZmxLVjhJa3JTbGh3Nlg4QVpOVUdKNUtn?=
 =?utf-8?B?MVlFU1ZRWWVFOFB5NFErKzBxeGhmQWQ1M1NkdTZBSDU1UmczSWRtYnUycHdF?=
 =?utf-8?B?cVlFSjBiRVZpeGIweHhqZ1FnUTc5Y1kxYXpwS2NNTG9RdHZDSnAzQWVkTTA5?=
 =?utf-8?B?cFMvRUtmSVFnNWttMVQ5dFp5UTYyNkdBYzFJTWMrdE15Ri9BTnpCckQ1SmI5?=
 =?utf-8?B?bGJvVDdoOU1mZy8xWlZmaTdZWkJ1MzlnM1Q5RkFuMG5uYWFSS0lYMU5iMWFX?=
 =?utf-8?B?ei9nT1VQWDFORDBGNEFxMVAxajl2Sm8xQm1hbjg0RWZDZkJtd3hlWkJEUVZy?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	a1GNhm1ZRmjKcdDRZKtiLpQGPSA/MVTaEFudJwfM/jqZDkkVN+OFkN+c8VZE7BbqA78X0txR7Tayuss5aW5FFTFbYJbbY2wykBgjam36tg6yS6F2vJ338fQCacu0qDpSDijuE22d/wf2lo0piXxmRC6pPKs5aiYbBmcYoNTn2Vv9JgXGPuYozejEQ/P58ForgkCONBMqGmQKw/pRfJQe9bNiB+MGJNpzvcfhrEbaCDp70w+2A80/B2f35qpm/AkgmAuX4r885mxIsZHLlmx4mmh914lmua2mfabXUp+A278LUafeVks/r9H4rVzvSaMBQQ/O5DBfrq//SuEm77L0e1R+D8ea5eeayPRuesORHbRvTqVmDiWPTDvFT44YCUfoiKON2bTcYrul44GHyXmPUwBPhkMpoEl7jXee4oha9N+EBe3WzQS06by2F6VARlAJnQOvIhsmQWWUJkCjLkIWgXVSP9KD2EbPXm0BqBGxuJdQFJUgt/dRyT9ZV4kTwfAMv1Bnjvb2YzqtpuIxFdDjObSX480nSi+SDod4OeweIceAbC03LS6BMiFnm68xPHny5nU/g6XVgc5kMgsTuUZuj0HJzN2MgCP7F/UDPPSZXWU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347c77b4-976f-437a-e61c-08dc6ea874ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 15:14:57.7360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5wwbNR3qQ3gzSYDhKQex/7M2g3rznCZMHI6l3lVneW5sJN3sJLCuvz9nwkyW1/9ejGl3H4cO86CHHsgKqFanw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_08,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070105
X-Proofpoint-GUID: JPZfgBem3raGe023wgPK0Am2_58IwXP8
X-Proofpoint-ORIG-GUID: JPZfgBem3raGe023wgPK0Am2_58IwXP8

On 07/05/2024 12:17, Li, Eric (Honggang) wrote:
>> Sure, I don't particularly like it as a fix either. But first I would like to get your setup working
>> again to verify that only this needs fixing. Indeed something else may be broken since
>> a1b6fb947f923. In addition, if we need to backport a fix, I would only like to backport a fix for
>> real known broken topologies, and not theoretical issues not experienced.
>>
>> But what exact setup do you have? I am confused, as you seem to be talking about your
>> setup being broken, but then other setup may also being broken, but you don't have access
>> to another setup. What is the other setup?
>>
> This issue was reported by our tester. His setup is
> SAS Controller <--> SAS Expander <--> SAS Expander <--> SAS drives
>                                                                     <--> SAS Expander <--> SAS drives
>                                                                     ......
> When this issue occurred, no SAS drives could be detected.
> As a workaround, I've already added those codes removed by the commit a1b6fb947f923, and at least we could detect the SAS drives.

ok, good to know, but it would be good to confirm that just re-adding 
the code to set phy_state is enough.

> 
> Since our SAS expanders are self-configured, we don't need to explicitly configure the per-PHY routing tables.
> So, I am not sure there is any other issue in this workaround as some per-PHY routing tables are not configured.
> 
>>>> I think the root cause of this issue is the order of function calls
>>>> to
>>>> sas_dev_present_in_domain() and sas_ex_join_wide_port().
>>>> My concern here is whether or not we still need to configure routing
>>>> on the parent SAS expander before calling sas_ex_join_wide_port().
>>>> This part of logic is not present previously and I don't have environment to test this.
>>>>
>>>> Back to your question, I believe we do need to join a wideport to downstream expander.
>>>> Changing the phy_state to PHY_STATE_DISCOVERED will skip scanning
>>>> those PHYs,
>> I would have thought that re-adding the code removed in a1b6fb947f923 to set
>> PHY_STATE_DISCOVERED would only affect the first phy scanned in that wideport. Other
>> phys scanned would have it set through calls to
>> sas_ex_join_wide_port()
>>
> I don't catch your point.
> In my understanding, it would affect the rest PHYs in that wide port, not the first one.
> The first PHY has been scanned/discovered and added to a port (at that time, it is just a narrow port yet).

Agreed

> Call to sas_ex_join_wide_port() makes the rest PHYs associated with that existing port (making it become wideport) and set up sysfs between the PHY and port. > Set PHY_STATE_DISCOVERED would make the rest PHYs not being scanned/discovered again (as this wide port is already scanned).

If you can just confirm that re-adding the code to set phy_state = 
DISCOVERED is good enough to see the SAS disks again, then this can be 
further discussed.

Thanks,
John


