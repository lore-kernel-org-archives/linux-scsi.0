Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FE2C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiLLVTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiLLVSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:18:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA67317420
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:18:06 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCGwrYd002656;
        Mon, 12 Dec 2022 21:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TnoRWL0LSwsy4Dp0RjjxDz6FGtO6lhL+1iaqdG8eApk=;
 b=pOSfaqr6erpYDfpyRUJIJ3dJdeSTqgV/mUR33ddsBi5qcBNiwv5GhbsiEIt5oan6Z0O6
 NJA5J4jVsH+1oE0A1ThMGIRCjYGfYPJM4/JanVjB8UgFFkwRRfHSA+JXp/5FsonH6qKC
 bxswB3zPzv1qbpqvHWShLmbS05CtmYVJZMkGy+zPB6vB1IiD/qPj3+Rd7czNF8xYmfnb
 65Z0RbuPx75I21c2VxqIpq9d5xn5KT+mKYsm2oe4gSAkpUqPNZS66f/VHKhiE+ntiY/e
 58Jlczx2PKpArqsXKU5tw4cX4ak38AHmjWI+cvxQXYa3ldj6mjW8LKzd4jfp8yZ5CUI9 fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcjnsuvd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 21:17:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCKwweb018580;
        Mon, 12 Dec 2022 21:17:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjb5u3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 21:17:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxrQ5b2VuDvyk6tBCf6sBvVkKpTtnD7t+TIPzViaH7XkgBkJDNW6wtuz/mjsz+HGpObInMfLbV+tm0/6nI5jlPdZMpdA0gRBpvrBeXBfVIej4yfx7YI7gmo1HQXfdCcQpHvlmaNKyvgToijGevWBxuBmNNQiLCT3GVSHB+1HWMh3Xh4d5UGWqVnm0z9phpDqvXc6bve6JxVnJhCxGIZaOoJXZEDF71S6kEoukeDNqazgHCjwwijXmmXUjv4/HrsbZ2mOhWuG81HnFdTti/Ttv3Cqo3VoZf5y3NYY6lqVgrT/4fX7Gro5HdsPc2QpcYD9vhIqDQySkXO9rzKrO3vbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnoRWL0LSwsy4Dp0RjjxDz6FGtO6lhL+1iaqdG8eApk=;
 b=f7bqRAB/iDsrhvJLPa+2sEB4/yxX9yNvRDW24GrueqXEZLfTMsHQ/PCd3OolMVaDfldx00J9e89ETIaxRE3Iej5inwfqm56Bw+ECAhoMdSop8yDVUJqse94n12T9vLkJmQs7/s+tj2RlSv7ufXMgiBuMmrj/e3ZsSx822V2rCFumQegy0fxmt1ykoUDBwD+urulFB0nuxa4sm8jfSEydVRloIMLKmIjNvADMALL7sNocKabm4RggBFvVI3NpIGJ3RdM3qUkcoB2d3Aey7EUKMFb38FR0HspuiyY/LPmhmwrAjLO4YtDUWSJlbDHjTygyfGJK0GCINLih/DBxcA5s7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnoRWL0LSwsy4Dp0RjjxDz6FGtO6lhL+1iaqdG8eApk=;
 b=EM/7pUsKnnlbpFpkVThpCnBl7/Tt1FLGwVeU+wfygT2yBFWTe2vVqFUfgFK4/E7MoZq4fv1XhNkkpzMKYJLJ04dmN3Eugtsl5eo0oF0tpKsfEsANc6y2rT6i0+VTCWF3qkx+toQEuppIi02ZR7P1tim5VdJfnTdVyY9KxirTy1Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ1PR10MB5980.namprd10.prod.outlook.com (2603:10b6:a03:45d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 21:17:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 21:17:52 +0000
Message-ID: <711bf5b4-e4bf-00c2-f08a-af2cdd2da781@oracle.com>
Date:   Mon, 12 Dec 2022 15:17:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
To:     Bart Van Assche <bvanassche@acm.org>, john.g.garry@oracle.com,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <bc73ce08-5294-bebe-4bad-b123b226bcb8@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <bc73ce08-5294-bebe-4bad-b123b226bcb8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:610:38::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ1PR10MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: b8cfe2eb-d893-4064-f6f2-08dadc8653ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8iTRjgVvLuADPfZydQ6wdgmYzuqicr7W30wYBEx7S++BSftDqbOaPJxdPLcLSmND4gJWW80Z1snmbZqnOH4E5NnS/Bth5rbs0IDq6GiRfmgq2rqcQZe0bMNHYKP9a45DbEgs4nW20FzcjbpYHRUGUhNkoxpF3Xxzv9yAXLLF4PDMGy/wTYnRBBIOh3vuCmu6dDzlXYndYuqVOXWqObLAYVZVJVefx9pQQ1WJqlFFmqAULhzFqm7aL2yijhoWV11gWI4xoNA4E14vziQa2REEKjQD8dbgzzj4GOdV6+cIfC+sr2O7j1gTKyLmYOnwALMkgsQnXmho5DlYcBX+iuayrB73Yb2hJ04bzmh5cYcowIrusmI3dHKUqhh885UtRbJZEw72HMfliF00isPK55ubJTe6a+ZGYgEsDVqWLaYy/TXfHYnrm7iOm2dXKos3Rcqv+OprG7mynJ5HnYiog6SKGPiuLBdWebxvDlxjrACNcZqdpIaiFne87I7fn5fb4PpXk5Mf2OQjkNmfDtELvR7YHnHSfrAMvj2pMbZfTXUKiw0egEC6F8FbZb/6sgQZOiv81I01mdPiwBU+hkxF0ZGpb7/zHm5EXomlRHHTyG/aJO//J0uQACudJj603PuO8TV7T6WbbBhDBlr2Hww5a6Mxqiu2gLKiIoqEIvh8R5rgUcul2VJqDrMTt0uDUTTsl+2dt8dFqS49b9uFm49zZMii3GREJV0OXFc0p+1KrY12jlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199015)(31686004)(36756003)(86362001)(31696002)(83380400001)(2616005)(38100700002)(26005)(478600001)(186003)(6486002)(6512007)(53546011)(6506007)(316002)(41300700001)(66946007)(5660300002)(8936002)(2906002)(66476007)(8676002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXF6SEV2RExHdjhSNkNQSEhyYVg0OWJJRFBrQ3o5R0FlVnJwYWx4SGE2dEpF?=
 =?utf-8?B?ZXlSenEvM3l0a0M0YjZHZzBwVElETGxvcVREWlZNRGQ2Und6S3dyQVRiL291?=
 =?utf-8?B?OTErcTZ3VEN0dnN4WDZ0a2xvTytWZWpURm0vZno3QlBsOUJkQnZWdDZtWG9X?=
 =?utf-8?B?ei9TYTlzWFBqbGNJNlZzZEtDdDQ0a3BVdExsMlJ4MVQ4MzlsRGJJSDRFSms3?=
 =?utf-8?B?d0tndU81dVVTN0RCcUlwZWI0NE5zTmN1OXExb3JEQjU0eCttb1BYSC9oREpQ?=
 =?utf-8?B?UXVZSktGVUtQUjJ3MHV2NEVnK2V1NWRaNUJ2NnZXdHpiY2EzZTBEL2k3bWNI?=
 =?utf-8?B?Q25UVy9FTVQwWThSM0l1U0xyNDduTzhYR1phbU5KbmJjVTFPbDhKQ2V4WEpI?=
 =?utf-8?B?QWlVcHdRZ3cwTkk0V0w5SERWaVE3VGh2Nno4emkxZWhONjIyWllTNFJQRzBP?=
 =?utf-8?B?dW84T2R5dmlJQmZnaml4MzI1ZjNVdXVqUmtubVE4SXFUdnJLRTFndFlXekFn?=
 =?utf-8?B?bForRjNQanNGdzdKcDBpY1pocU5XOEc4Y2trSS9sbXBqbFBBdGQrdGhiVThO?=
 =?utf-8?B?ZmE4cGhuMWFMWnlNN1IyNTNFZk52ZVBkMWNFbnE4dnJZVkYyQ2pNaVhzRHZL?=
 =?utf-8?B?clRmSTVPRHB1ekFLSjlscDRzVUtydEdqbTJueFlldUdxUHBMY2lIQlQxRmR5?=
 =?utf-8?B?QS9iUGpINkZmZm9sTGtBeHpkY2prUTRPUXNHYzBjenB5K0ZRbWZVOUF6cHpq?=
 =?utf-8?B?aEZTUUFudEpOMG81Vlp2Z2JobXUrZlZIZGVSempVSWNWcTVGVkFkVHBJb2tP?=
 =?utf-8?B?ZTBnV3cxWXB6NVdQSURuMFhUVDZBaHI5RGRXS0JYWEU2VW1tdUJOUHh2Y2ph?=
 =?utf-8?B?NFRRLytQaFp2UjBRTXZzWEZpdUlQNjViNytVaW4vYkxRcXoxVUdhZzNFMTRy?=
 =?utf-8?B?NHN3UEVRWjUrTkQ1TkJ4Y3I5S1BuYnZRQ21NQndZZ2pnTXBuNHQ5bUhGSklU?=
 =?utf-8?B?K2VrcU1RZ0tNbnNYZnBNV3M4T1ZyYnpOOG5JVkZnbXJ4RW1QcmJ2NndYa2tN?=
 =?utf-8?B?Q1N0TU1UejV1TTd3aDE3d3kxcVpxRmhzdFU1czl4Y0FWNHVJOWZNWThJd0xW?=
 =?utf-8?B?RC92QW9tUTdYVWEyQUEyeXAwM0dSTW1oaFZMT000SDNIT1VnNlFzeDQ4UTc1?=
 =?utf-8?B?d3ovbWRQWjNtL0ZlSW1JNmc4anRYRm5wUm9iSHM3NUN1N3V3eWRicVNXMFJG?=
 =?utf-8?B?ck5kYXgvd0NhcGdGOTB4V2dRSDZyTXRCTUltNi8zSGJTbkRXSTN6MWYxckEz?=
 =?utf-8?B?eWNJRHJYWURnam44L3VMMnNsdmhZMFArVGhXcnFESk5GQ0V3YWdOSUlKMHAz?=
 =?utf-8?B?V2ZkMEV4cE1ZMjlhNHQramJ6TkNjeDdGV0N2MmN5N2ZrMGpmQmg2NkdDTmZq?=
 =?utf-8?B?NDdOOStrU2VVd3pzSld2ODNZVWhiNWxVSWpVQjRraXlRSVJqcnc0MDQyWUlB?=
 =?utf-8?B?YUx5bGRzdGlCYmxleFRrWlFmdEpNRHJTZVAxZjJhcFhtSE9jbHVNbmVTbTYy?=
 =?utf-8?B?aWlRVkpnbWsybWZFdVI2YWNpb2pNd29jTnNmZWMzWGcrYjV6R0ZNRFBKZjFs?=
 =?utf-8?B?bUsrY21XUUlLQncrUTlDZ3Nna09FYTFnMGErTUE3VEM2dHhDZ1dyZndYNy9o?=
 =?utf-8?B?UGRVRXRwRTNtWG5VRnplajBZaVFXVlBEQjQ3dkNON0QzcDZNcmc4RWJtZFli?=
 =?utf-8?B?c3ZMR2JVcndsbWlvQkQzUHpSRjMwWmVlYm9sY2tyc0Z5clZHeHovUklTMmlr?=
 =?utf-8?B?OTdBbFYvS2J0V3lPYmhrclp5cVZtenJ4cFowMUtZMVFmVnEybnJCTVFuUHYr?=
 =?utf-8?B?RDVNZnFzajE3NXQvdWozeEVYR2V0OXVFNFJuNVBJQkpmMWVaVVlCV3E0YWIr?=
 =?utf-8?B?bUlMZU54N2ZrU0JLaFdNR09CWGNwWHBqWHJqb0dEYlRBRVJjRGMvbmdXd3ht?=
 =?utf-8?B?ZWhRNS9PekRQZFhPeUNVKzhrWENSN3lvV24rd2FtSERjRjNlZ3ArcXNiRmpE?=
 =?utf-8?B?YTREc2VMQ0hwSy9ZMzVSbkJRYlhjckNPa0NqOWFLUFVxbittb09XQW94RjlR?=
 =?utf-8?B?UEhna21BWTA4YnBhM3pTMHhRZklXNVppYWZtQzE1bGxBa2h1eENlcjVjYjFX?=
 =?utf-8?B?Q0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cfe2eb-d893-4064-f6f2-08dadc8653ef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 21:17:51.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7fU2MZtoOdRC1Wkw5EmhNfyQIw27p0to13BwGycPVuAbZxiJdz+xpRhdGM/eGMXhUmOnFaFCXsQ66bPak4dGyb6ZdKnw878+whBy3MelRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120186
X-Proofpoint-GUID: TK7ak36KXdiq8IjZRTh6_azc1IOAYXvP
X-Proofpoint-ORIG-GUID: TK7ak36KXdiq8IjZRTh6_azc1IOAYXvP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 1:45 PM, Bart Van Assche wrote:
> On 12/8/22 22:13, Mike Christie wrote:
>> This begins to move the SCSI execution functions to use a struct for
>> passing in optional args. This patch adds the new struct, temporarily
>> converts scsi_execute and scsi_execute_req and add two helpers:
>> 1. scsi_execute_args which takes the scsi_exec_args struct.
>> 2. scsi_execute_cmd does not support the scsi_exec_args struct.
>                     ^^^
>                     which?
> 
>> @@ -232,8 +222,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>>       memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>>       scmd->allowed = retries;
>>       req->timeout = timeout;
>> -    req->cmd_flags |= flags;
>> -    req->rq_flags |= rq_flags | RQF_QUIET;
>> +    req->rq_flags |= RQF_QUIET;
> 
> My understanding is that neither scsi_alloc_request() nor any of the
> functions it calls copies its 'flags' argument into req->rq_flags. I
> think this is a behavior change that has not been described in the
> patch description. I'm not saying that this change is wrong but that
> careful review is required if this change is retained.


It's not directly copied but we only used the one flag RQF_PM.

The new code has us pass in the BLK_MQ flag which is used by
blk_mq_alloc_request. Those flags we pass blk_mq_alloc_request
eventually get set to blk_mq_alloc_data->flags so when blk_mq_rq_ctx_init
is called it checks for its BLK_MQ flags and does BLK_MQ_REQ_PM:


        if (data->flags & BLK_MQ_REQ_PM)
                data->rq_flags |= RQF_PM;
...
        rq->rq_flags = data->rq_flags;


Note that if you are scanning the code and see the scsi_dh module's
req_flags, the variable name was misleading as they were really the
blk_opf_t flags.
