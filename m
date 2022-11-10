Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A8FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 19:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiKJTMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 14:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKJTMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 14:12:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39FD17E11
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 11:12:52 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAJAnmR007682;
        Thu, 10 Nov 2022 19:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=DTMFK9Zn3fpI7xwZm1inTtd5dYoFRxNrwCGCMKXjDvA=;
 b=keA/r/Clsa46Qlhf7Npuq+L6q8Ro/iqxe5DiH3H2kOc/s3fcAXgNKDbQFfiW1wi6EFBd
 v3HqR/pTNxIeRw2+YpI5vj4pNDQW13uju0SSukEMCia7tZUIso1zhPgedE+mArOy8ua3
 lVlM4TMElnsjja7xCMXYOc9T1n21dXV+3iKBN4sYP0Fv7/aVOOZwMNzOMFCSVXDOP0bI
 hykDQFjDbaNqYibfypTzS6qKeod/is4DnqHT24nrVhPf7bRlrzFDNQ/S33VqBchNSjGF
 jJa6gInHo6lBVhitblczce4eP+o8/1dePWQYs2Vo8FYv1Lu6Itr39yqhogkBi3187rIR LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks77d005f-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 19:12:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHZVKR014924;
        Thu, 10 Nov 2022 18:40:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctfje8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibbCUkAGQPpqmls6CLY54sVenMCThwn91+pffbMTO670KU7FB3z9xT+wCpw+vKCFAufgm4rFQ9rakIrgJDdtDZBrYsqtChNlZVgnZdXmeONigfDlu/ZviPMCZLQnyfUm4D8LU0ZsGg9f519fZTDgkv+GevJMxz/aABg7CTF7xponltUSsJwt4rjiCCwHMTfeFNVmvzxETdjVoPPELpuNeDwkKkChux1/XF+V1OyyaDySmg9GPr9Pt9+ujytot4MnfFVNiCRpITG3s7Z0O4cqhbUrDejBjYGUBPpHloCaYbR6U16FlnKkQXOLi7qdI+Q30zsvMU7hKyEBuGXZF1SNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTMFK9Zn3fpI7xwZm1inTtd5dYoFRxNrwCGCMKXjDvA=;
 b=DctnTi+45NqHQ874BUJLix8rB0wSVOH6qW4AlrhAZekeEEfm+KfAEwQYqvqDupc7J+Xs9SLzm9ebZHiAWJsR4Ch5V8MSWisisfI5jBdEuVWePLumiCZYaARHjIYbO9AshRVyyE5UoTvI4D/cEpoQnwx4EP6ZSusm5R0tDVPDVlaH3+3Poy4rZQ/TvjkNl6v6ZIaPkv/aj61za3rPIXJ7Q3KV+LaD+fB9T3aPK0uTmph0J5zfsTbrqWAI0ts5eIUyyx6AsaxID38gn+l9Ij5SOSUKsHiMrvSJNMkvWxzCkJXSI5nxie+luNXRHzxdFkMJCEIb7CO3IKsKz50slaMdRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTMFK9Zn3fpI7xwZm1inTtd5dYoFRxNrwCGCMKXjDvA=;
 b=F/eDGnW86QEufQfKTBR9TtPD45V8hBLz67H0KrTRD+TIHMb4zFO+LDUe/pJ9dPZW2Xj1NWm9eH2NXT35PjlB1ul77GV84jNQ6nhV3TNGMfD7a3/6pIHeX2AWRdwnCF55n69M9Ea5hX3mKL9azU1eEBvbfat2BttTRVn+YScZCRM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6253.namprd10.prod.outlook.com (2603:10b6:8:b7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Thu, 10 Nov 2022 18:40:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 18:40:57 +0000
Message-ID: <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com>
Date:   Thu, 10 Nov 2022 12:40:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:610:cd::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c8bfc8-2d72-4907-c9ce-08dac34b1ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGrX2WnsW7ugZwDmDbi2/sTA+HFRSCaFxtjlYIY8SOWqb316W8o9AHkiWo8kyDp07nuipV0yVkxngZS0ee9245d6Vj87NMntpZsKxtdagtrtnISYEpsjvXFyPTcGmZZjsMKqdu5sA2ZZHoJW83/2/vdFIDt188Pe/BH2SOtrhM1CF/biWiWh4idQegEVLL6cBPiY9/EGvaRCXCYj3eVkdZ7z7om4KfaNUDq7xjQSomK2A9nEc39ENG44LBk1w3Dh3YgXbM7Lr0/SA3zCYxSqxrywLxj17nQ4P09UFJmF+Kp0Z3FKxbXVP1spxXJE+dP1HDzv7pemWinP0dlq4F9/wmEYH7z+eDG0Tvs8NW8srArlpgxWWnNgmBcH+liYHvd8ARDdwtRi+6Ai8aVZkO1CYiA7UYXcSYTrcRc9sT77Ya5/XWqA6XKjoHgjxRXnMdzAAguCYbsZt5eAscUCkbV0wS8uuz5u8gMp/fBnsJYEyvqtM3rtFzRbyuGVWdFxMdkwfVsTOHolupOl8Dl7/wcKzT7w1Bvl1G1SiGnIGz7ViwTHz17hDgRrxC3kcZp2x9CtYSVbpghqwc2wmMEGIKKZd66EVJFTvllXFXtCNC/hBLeeyxKwoFnfZPnKUBZBj57no15ty9uI8J3LXlPux/0yURLH6jEpO3af+ahd/CgWP4KTA3TA7YQOZo3meg5kg89yaLzygK986PBF3ya9fHUYttqoaHVhj9l9DlBEswi37l8j3mwlxmRnhb5D6Uz28srXkxDogqYUfiSb3PiYprFXIaVUlCofCnYmoU/pcawwhqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(186003)(2616005)(6506007)(26005)(6512007)(83380400001)(2906002)(316002)(6486002)(5660300002)(41300700001)(66476007)(478600001)(8936002)(66556008)(8676002)(66946007)(38100700002)(36756003)(53546011)(86362001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDRQS1VITHhMU2RFM3dSZ283NVQveFlacENHRnJIRW9OS0tDSitkTHZhNmkw?=
 =?utf-8?B?NSt6OVFDZm4yR21Dc0YrTkFXMjk3dFBsdnRzc1JjUVpzblVWZTZIeE1JcTcw?=
 =?utf-8?B?ZURTTldwbzJvV1FLT2ZjLzR0bWZFcUFiN0ZyT0dGR0RqTWdpdjFwTWJkbGo1?=
 =?utf-8?B?M2lXeHd5YUUrSFdyd25La3lOd2FYU29KOXdsTnJPaW1UM2MzaEdHZHFIQ01J?=
 =?utf-8?B?TXJsUkE5OWI4WDNZcDcwZEp6dUpTVSt6VXNybUt6WDNmOGIraVNFMVFhRmt4?=
 =?utf-8?B?MHV2K1FYdGNlZjlycVYrRXplNUxHMFVONzBHbkxZVjNRd0ZKaWNaNjRkbXRx?=
 =?utf-8?B?cEZpdFJaNmNiWjdzY1dWbTM5OTFBbFkvR2dNQm44bjg5cWFVTks4SkFsNWJL?=
 =?utf-8?B?eWtkdDJ6UjBSTlhLVDVSYXBrVWxnNmZvZG9WWDF2QlVvL1kvaGV6bnl1aDdn?=
 =?utf-8?B?WnBZOUFaZzdMS3FFOTNUNGxUOEpsbk1zbEVLeVo3eHMyVGNPbTVEZzd2Z2Y5?=
 =?utf-8?B?U3QvTXMxTTRLVjU1OEpGRWh5aEt1V1NiTHRvRWpqSVE4QWs0UFh2cGFmNXFP?=
 =?utf-8?B?MGFqTFZ4cTVZeVRIaElsbEY3cE5Wajgvems0WXB3VWtjWk9Qa2U5K3phdXBy?=
 =?utf-8?B?OHBJTURPNFhVQmh6UW5zSzlObzY4bFJ0OGIzRTNhSXZyYi8wdmxERy9ZSCty?=
 =?utf-8?B?T3pzRkNuZFI4VWpCSVAya0JXTmkrcWlMTHEyMzZJcW1RSEl0RkQ2RkozdVl1?=
 =?utf-8?B?bUpaK2kyWmxrKzhOa09wbzJ1VzQyamVhRG1iK3RubndLRFc1bEFTdXFMdnlX?=
 =?utf-8?B?YXVvSElmMHF6RVN0M3hNZlhvR21uT1Q4WUM1dkJyVWpaWnNuZk9wTjNPb0RG?=
 =?utf-8?B?eEpXbFQwS0FUcSt5VG45bURLU2hQajZ5NEY5K0VJUERWcWlPSGpsdUZUZHFr?=
 =?utf-8?B?eXVOTmNEMFEzazhlZFo1TGpXRUt2bkF4OFY0MjB5cnI4eFlla3hWaUpRNFlr?=
 =?utf-8?B?WlR6ZXlsM1MzdFFkTWhwZ1ZFTHUrZTYrcHB5NHFuUEM3TEExS1hUek9kenUv?=
 =?utf-8?B?L0JWb2pEL1VBa1YxeXMwVUU2NXZMMXJlVkFBektyVHBFMWdMRXR4aFNDOFhQ?=
 =?utf-8?B?bGF3U3hPdVNySnJMNVV5M2JsTWZ1K2lVOHRCTUVvM2Jjc2xrN0dkeTdrUjEy?=
 =?utf-8?B?MGU1c0R0cmFuZ09jb202bzdiVGFJZDIybUwrQ1BtQ29QVUp3Qnd2bWdORGVE?=
 =?utf-8?B?Y05MV21Dc3ZVR0gyMEZuVUZ6RzdRUHE3WjU2VWFXUjdYbThOeGhWSWRPb1JE?=
 =?utf-8?B?QTJvQ251WDUrZHo2bUR6ck9xdmRNVEd5RXNPNFpaVlFSQk9DNXhBY3dSQmRu?=
 =?utf-8?B?UGxCcVpVaWljMXVUclBRUkVqM1dTRVROMWM3NE1jc2ZuN2QrZTFITTlVSmpn?=
 =?utf-8?B?NzQwMEkyeTBjWGpjYmxBa2hSMnBxZ0QwenB4djA0Nm43NWN3U2dTUFExeGVa?=
 =?utf-8?B?dU82VU5RVDM4b0svZXZTcmpoMEZqS3JPM2ZGSCttVnBSWTRHczJTMk5LMzhm?=
 =?utf-8?B?LzdoeVZRbms4ak82OGtkZkJBdGRtN3E2S2FURld3cTl0OElBM0pueDRKRDFV?=
 =?utf-8?B?K0NxWTlXM0JoVFVWbEJKYlhFanp6aWVCVSt1djZObGJJYWZVc3JHUUpNM1lu?=
 =?utf-8?B?NVRiMmlnWVUxaWlROWVpaWR0OWpyNjhCck9scDdRTnpEZjd4ZEt0aUlBR1VW?=
 =?utf-8?B?LzZxeWk5VU44WEhRRzBtWXBIazdVS0pvcGVteTcrOEdIa2g1aGZidXVwMCtG?=
 =?utf-8?B?SlBhOUpRWFJhWW8zRzczRmZZWkpLVTNIOU9JMXQxczVQZ2RHUG5WVUIwV1ZY?=
 =?utf-8?B?dWtFM3hMK3pPbVgxQ0J3dmlyVHJSUVY2TDlyWG5sYnBxalhwaWc4SllNZGxr?=
 =?utf-8?B?d010Z0pnTndwTnFPMm9uc2dVY0FQc1dBRlA2RnBCeFQ3QWZZaTZINlg5TTVw?=
 =?utf-8?B?bkMySjR3UjVJUlcwSGFKQUZZbXh5T0xIaXVVRGJVbVVZRW0rcXptUWxKOTI0?=
 =?utf-8?B?b2wvMnRGaHo5dWU3WFFaVWp1QlJRNnp5c2M3SndmWFUxTEFzZUR5Z2JGOXAr?=
 =?utf-8?B?L3hJdzkzK1c0d3VvRktyQmorVkJHeWd3NkxXVmZrek1LcmIzR1pQeDU1S1BZ?=
 =?utf-8?B?QXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c8bfc8-2d72-4907-c9ce-08dac34b1ad5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 18:40:57.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUkWEZwBkSMD2fjHBozQBsp4mgJsMcIsH4Y5pj5H6a1o07QQYKtwotfsUDJhtMAh6cidTpjnruqZqkQ/rUMqTEiuK09cBLe+Wk195VWHiRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=835
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100130
X-Proofpoint-GUID: nBt94a1ereIgyO5bWanMLL-ukzdUU0-j
X-Proofpoint-ORIG-GUID: nBt94a1ereIgyO5bWanMLL-ukzdUU0-j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 5:15 AM, John Garry wrote:
> On 04/11/2022 23:18, Mike Christie wrote:
>> -         req_flags_t rq_flags, int *resid)
>> +int __scsi_exec_req(const struct scsi_exec_args *args)
> 
> nit: I would expect a req to be passed based on the name, like blk_execute_rq()
> 

We have scsi_exeucute_req now which works like scsi_exec_req. I carried it over
because it seemed nice that it reflects we are executing a request vs something
like a TMF. I don't care either way if people have a preference.


>>   {
>>       struct request *req;
>>       struct scsi_cmnd *scmd;
>>       int ret;
>>   -    req = scsi_alloc_request(sdev->request_queue,
>> -            data_direction == DMA_TO_DEVICE ?
>> -            REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
>> -            rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
>> +    req = scsi_alloc_request(args->sdev->request_queue,
>> +                 args->data_dir == DMA_TO_DEVICE ?
>> +                 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> 
> Did you ever consider just putting the scsi_alloc_request() opf arg in struct scsi_exec_args (rather than data_dir), i.e. have the caller evaluate? We already do it in other callers to scsi_alloc_request().

I did, but this part of the patches just convert us to the args struct
use. I tried to not change the types to keep the patchset down.

I'll change the types in another patchset, but I think it's better to
do in a separate patchset because I think we can do some more cleanup.
The users that use scsi_allocate_request are kind of a mix match mess
in that we use the scsi helper to allocate the request and scsi_cmnd,
then setup the request directly and then use the blk_execute_rq helper.
So I was thinking they use the flags directly since they are using the
block layer APIs where the scsi_execute* users are trying to use a SCSI
interface where the DMA values are also used (LLDs use DMA flags, ULDs
use a mix because they convert between block and SCSI, and scsi-ml uses
both as well).
