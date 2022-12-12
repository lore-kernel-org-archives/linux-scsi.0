Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F09C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 16:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiLLQRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 11:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiLLQRj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 11:17:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548E4E7F
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 08:17:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC97toT022833;
        Mon, 12 Dec 2022 16:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pkxzz6dkHl1yJbZ3hyPQ+bI6aKh0nop2up8rzp2vHjM=;
 b=17MC0Fm42YFrna7s27Lmgsn/iKWWV7ETuJABP9vMoQaYMiZ7LZnc8Ln9HYZIkJ9TrPe5
 YP7L4ViUjoEqQNvWCktf1KFF1ANUpMxOBhqkTQzYwCoISEPTO/ii6mUNR6rGurBgdvf4
 mPLI1/ncV0vLi8If6VxCd6r1slXKBiJA8+rG+gnHGmJTPFsc8aE8ho+yH5UmbaHMDesj
 d5uUywudvuIOP+5Hl0scTG8+J8vCzuHpVFfczyObW8xSS4y3t+C1EB6pqhOw3euSeMsP
 FGIHjVF2MkcNi62QeLDnAufv7z5KPz7uH9rG2QyUigyODMvQwJGVc626cI4gPwn/+WQ8 ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj0934a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 16:17:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCFZcIg017649;
        Mon, 12 Dec 2022 16:17:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjahphc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 16:17:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaF66y75DaYaH/P7RS/XFU6+DiSUpBlKCFNL9j3CYEOpwNVAYU96nh/h2yrEmxCmvwVMh67aN5mlrvjuMJok3kUlpFo2DaeW7l0YDfin7hXMvvDsQGYARq6ijKJlRwdxzopXy5mBWTRcjJnrf1uVFYE2x+e8KYBuyypAff5rKOej2T0HRLFXVz/aBqhJTLHpjK1yVkIjeQv9wGeEAiQPyGl7uRHmIyEiiV6bcK9SRUc/Mx9Lnx2wiSKbSpWRw/x1b2Gv+nUbEEg+s4j6QcNdHkKJ1iWPJ9+S980Dfoa0u5XTosZOQBTzVT1XPwcTWGIgK4eQM4YlE/aIgZ3RKGZblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pkxzz6dkHl1yJbZ3hyPQ+bI6aKh0nop2up8rzp2vHjM=;
 b=cFOEl43/8wx9+6ekCxzVbuqXCTJ/RvT+e4tT7Q6Wi7slMuJzGp62limfyQlmN3zI+VpRMyJ7G+FfvHJPiCydhHIbvBkhoOHALXfolwGCH0bdwSXFxxzIrhgm3jCo2taqIKhLBnEO54kV8p/H3MIigsw+bpBgJeMnwh39Go+3yhEt1D+JhetHynu7wa2QSfdoMerprr48cEy1tbF6Ctw6bp77W49yV7Wk6vCLhLoXX5jmB0h/b3WkXRF7MHeGkmxciJ1Ue5OcxSkMDPSB5k8Od9a7U4vICSHQgJ+tt/3cBoMfR09PxDm++/2zs3/RJYn3heQkJ0WC4cFmvu1oJw1ICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkxzz6dkHl1yJbZ3hyPQ+bI6aKh0nop2up8rzp2vHjM=;
 b=cHkSP3Bd15/2X8x0dqLTaqoreePSG2NhwTU8+NtlkePkVp/DcpvyLwzSERzOra8XmoWnx9Lj+vm1JEfMJ4Lr1c+TClhoGJxjL9W+AI8KOT4lN/CspkQnLMHsWawBFJhhBXPQzXh9QhhIzJeJiOBa85O0qwlK1IT7AcszxIf3iig=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 16:17:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 16:17:24 +0000
Message-ID: <cd1cf2bf-b5f3-71fe-656f-3199c7fa0960@oracle.com>
Date:   Mon, 12 Dec 2022 16:17:19 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
 <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
 <daebe4f3-fe84-1766-ddf5-53dbc9f47c5b@oracle.com>
 <1ec68506-971f-962d-5d38-214bc94fc132@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1ec68506-971f-962d-5d38-214bc94fc132@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fce5c9c-5f79-49a6-e599-08dadc5c5ade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kw/j4UjbRcmPNMAz4hqzfvao0rWVkyu9AMa5XHhkWBqrqlY/kEdsZq3hlASGUGdc8qn1zVa87ehacPs6rSLnKEwLQLWyrYYhYd3wtqGWgpwqbGTUxXwDGXpwurH4yMYlo4m3yqlJ8XEhd0stSyjtqDmluQsJJRpIvpMI9blmq1XwcVsiNOpO8P3isXPJP4vAtWsRZk9P4k1ciBq2IfjpspcspISCJfEcq8sPNLMqtcr3g+VmuCqiGRpaQcu8V/K8Ff4nYDsiZjp5KmuQ4ZAzMjjr5I5ynuh6tEL7K7k1Ie30V+mDqduanTPdRPn7GdItGE9w63jxiY2ezQ5q89060vJLT1vjVrgtqWpQ1A0mZvJJVJ7wnLQqjaIxlDvLJb38XiBRp5IACYSWryZLp54m+Tr8R2TMWTtacBsmt5+QuBPsIi3vjGlRYMou8k2939wWEsytQYtB//N7xQoPCR8FDtdpSuDtTJX+7dG8ruqA/HhLHky0UgE90ACHvbe3kSHZ6GH1qckTCkc5meQ37GsGzZmYbTT3FOPELa0KUo3SH6992Adw8Cg5JuPLiG2lRdNQsoLsJg6K3ecCuqIBbbdkoK+4CNbYPPhtnKBFpVpYASqSZEBqbLNd4np9nbPWdEloJEJ6eRoBqr+Lt6LZMmumt5djOeVMEk5FUHecJF9m59RCGulq0++w2qFYp8SgvaoWmOqBPQos6MD2AsWdjvv/XSiAIHmYrl/DesqlbTBJVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(66899015)(31686004)(2906002)(38100700002)(31696002)(66556008)(41300700001)(26005)(36756003)(66476007)(6512007)(6506007)(86362001)(6666004)(53546011)(5660300002)(316002)(110136005)(8936002)(66946007)(8676002)(478600001)(6486002)(36916002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFdkOHVVT0M3MHd6aUpaR0F6N3pWb0x4Z3MyZnRSQy9tKzJkd3VjKzN6citV?=
 =?utf-8?B?Y2tHcWhKT2Fqa0E3L0tWQTJQeEhUZ3lUWUJxYWNIVkxicC9LNEZuTHlmNWxE?=
 =?utf-8?B?T1lWWW1wclpxRWxSRW1WUThoOWx1bmJBMThrdVBNamE5UTFtWHNOQ3NMeFRj?=
 =?utf-8?B?eWFERlBZckI5SER4amtZS21RalQ5Wm5DdmVPd09mNEJ2SktMeEdXV1A5WVRm?=
 =?utf-8?B?QUFnRm5RT0tXYXQrWGxXblg3MjNuUFpSN3R5U0RLaExHWFJtd0NUemJSUDE5?=
 =?utf-8?B?d1FRaXRPVnhYVHNMaXNGdWxlQ1hTQjFnLytON1d5YzZ3bHZ1YlJBY1htMEEv?=
 =?utf-8?B?b3R4NHIvZHdSM1F1aWM4ZjZRaDQwRHc3U3VHOVRnbWxiakxrZ3VWU08vT05V?=
 =?utf-8?B?MlhCREZXWDVpcGtWUnJ0bDMxZDRhbkJucHRCMFNMNmZYdlZYRjBFSWtKWjEw?=
 =?utf-8?B?U1MvSHNzU0JRZkxncklldGdmbEdKS2g1Wm94OTBmMjdrbmtnNTRGTFBIVDkx?=
 =?utf-8?B?THZ1LzNGZTcvM2V2RUs5Tmx4MUVLdWVHV25POVRvZjhjTDl0d3ZnYjFaYXBw?=
 =?utf-8?B?Wjd6aXNlNjBxd0RZSzU0RnhGcVYvaHFFb3RzQkRzWjZIQzZoNFhXK3RudWZn?=
 =?utf-8?B?YTdYQWFmbUpTalZMMzRneTVYcXM3ZUFmOVlHbTdackdyOGFxUHlQSmZnMTh0?=
 =?utf-8?B?WGdKalVYODRkS1RjYXJwZWpucjFiUy9PNCtmWVB4NGxMZE5lSFJxcy9CYmY3?=
 =?utf-8?B?REp2dG9FaG5BZkFFRUcyMCtzM0xQRm5FeXhVRUllK1hFbHJNTk54d1VLeW1K?=
 =?utf-8?B?MjZXckxyWktqTURWbXVQTHBqcEQ0aWR2RnRxYks3QnFwaXVzdEhFcm1ZbFds?=
 =?utf-8?B?bXRkc2wvV0xmSzlBRW1ZMi9jd3IzZWlzOGhTbVlyK1YyRUFjK1lzR3JxZmxi?=
 =?utf-8?B?bGY3RUdHTHFWVmk0V1NLdy9TbEt3Wm5vZTUxNmVVK2FvWmZhVnJCSFcyWm15?=
 =?utf-8?B?UHN0VHNaRXg0T2xxcStnTTFOeHA2NllsSUIvVE9PTVJ3TEsxOElpZHN1QmVD?=
 =?utf-8?B?SlMxazI5TE1HU0VENXl2V0ZNM3lWWGxmbk9pTUsxZjdJREx0WW81bTJVNUZX?=
 =?utf-8?B?UW5kTE1TZExiOTA0TTM5MG1Ha1lRbklmd01uZkRrWmZ2cU5IZFNlTVFyWTht?=
 =?utf-8?B?UzBidHZNelNFSHNES0dhRDdCbGxITGRFeUtmRHZCcGFuTWRqUWhaOU9qODNp?=
 =?utf-8?B?bTIyVjh5RVh1bUs3aFRHQmUwbGFMdVhzSTVaa0dFajdKNGU1RW1yTDhQK2xG?=
 =?utf-8?B?T0F1OFgycHl0djB1ZnBiUExoOE5RTVhLbk9yRGI2SEFFV3draXhNaVRQcE1W?=
 =?utf-8?B?cit0NmY1UUVtYlp4eDJNKy85S2lIM2k1eDBDWFhGOWZQOFFHMkRNa1VzL2xs?=
 =?utf-8?B?S0IvK1ZqWkpPOHFIVC9nM1RXdUdYYXFKUHowNnNSSG9nS2xyQU1ZS0RObS94?=
 =?utf-8?B?V0Z5MTN2VzZoQlVsNGVJbUxISGN1UXYrazQyY29tbWFMaUwrdGdDemsvQytR?=
 =?utf-8?B?d0N2TU9NOVhFMEZkTXN2Sm12ZjIrNnFkclBtRnh3dkUrWnh3Q1pzcktoVkln?=
 =?utf-8?B?SHk5cHFxUTdzRTRUZkxja1I0SEFUeE9PRHhQSlNCc0xtZHBqTlEzZkpIVUdN?=
 =?utf-8?B?aWVQQVZqS28wcndrK3dLZkEzUnhXNE8zNEJXbGd2ajRTVithdENkVjRiNlVK?=
 =?utf-8?B?eEZFMGNRVEtwQ2tzR1MrKytPb2Z2RHFDYVNVWEdpMzZpK29XM1FHeEdrcmlL?=
 =?utf-8?B?eXoxVHUrMzVjaDRpU3ZwYTVScjBLQzNNZlQzWEI1bkltb3pxRzlZUnpNNkpj?=
 =?utf-8?B?eDIwVmQrMjBFQ2lraUZOczZ6ZWRzcWY5Mmd5UkdQTHBjbmpCUStrTjdPVlB6?=
 =?utf-8?B?WkdDVitrdEtueG1KSGE1SVNpRll6UUtLRWVGYktIS1grRm5GaERSZmgxMkNu?=
 =?utf-8?B?bFZ5YVNGb1BZRGhDUTFnM3V6V1Njam8yM3B2cWlobkNUYnZzZlNFbFV4emcw?=
 =?utf-8?B?bER3YW9VMXJiTzFZSHJaODd1RndSZWp4OXlKcjF4eWN3M0xhUytyQ1VscmZO?=
 =?utf-8?Q?DFy1M8m/c12yCz+GcQjthDkmP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fce5c9c-5f79-49a6-e599-08dadc5c5ade
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 16:17:24.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4v2lr7Dq3EAwzBxEIkV2yQVMWrZDIaL0krxUhRpC7bAP9HxAukFEwxfaRVtteH+jW7kCoXohi9jjeP/5j664rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120148
X-Proofpoint-ORIG-GUID: CHwl4WmEZ_8W_B99e-IUvfzYNLU_1X82
X-Proofpoint-GUID: CHwl4WmEZ_8W_B99e-IUvfzYNLU_1X82
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 18:47, Bart Van Assche wrote:
>>> around it then we have to do a WARN/BUG. We do the macro approach now
>>> so we can do the BUILD_BUG_ON.
>>
>> Maybe we have to switch to a WARN/BUG.
>>
>> It looks like some compilers don't like:
>>
>> const struct scsi_exec_args exec_args = {
>>     .sshdr = &sshdr,
>> };
>>
>> scsi_execute_args(.... exec_args);
>>
>> and will hit the:
>>
>> #define scsi_execute_args(sdev, cmd, opf, buffer, bufflen, timeout,     \
>>                            retries, 
>> args)                                \
>> ({                                                                      \
>>          BUILD_BUG_ON(args.sense 
>> &&                                      \
>>                       args.sense_len != 
>> SCSI_SENSE_BUFFERSIZE);          \
>>
>> because the args's sense and sense_len are not cleared yet.
> 
> My understanding is that the __scsi_execute() macro was introduced to 
> prevent that every single scsi_execute() caller would have to be 
> modified. I'm fine with removing the BUILD_BUG_ON(sense_len != 
> SCSI_SENSE_BUFFER_SIZE) check and replacing it with a WARN_ON_ONCE() 
> statement, e.g. inside __scsi_execute().

Another option is to have __scsi_execute() allocate the sense buf by 
kmemdup, and hold the sense pointer as unsigned char ** in struct 
scsi_exec_args; but then the caller needs to kfree the allocated sense 
buf, which I suppose is less than ideal. However there is only single 
driver which uses this AFAICS.

Thanks,
John
