Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58602C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Nov 2022 01:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiKCByk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKCByi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 21:54:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B007311829;
        Wed,  2 Nov 2022 18:54:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2MjvgA029530;
        Thu, 3 Nov 2022 01:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BGo1M30lP97FL9noRvlPBDyyK0J7W/2LoaZbOM7onww=;
 b=cx/YGo1JzAv5BzJa7LxBqMOo8X+O4zEkOLcFJYdTfzd0Kcl/0mPIOc8NX642+42j/3rb
 mR3EEUPnw8s4CDJUPaoYhJ969bUIm8VkUfsNaVePevLLy0BJnuz2Miyt4MA0n+UdwlYL
 67oHgqsm25IE5M3OWZHnHdsqskT2tB2iMbeMxeKH1oSxXvOTI7uSLSW/tIYYh8klMPU/
 NqD3nkhphWIt0mwnYYlTX8/OwJqBBa/kU/aO7Sn7TKVCaJyZ2POwKs656cAetbS50B+t
 KrU7//VmY4vMjU/jvp6ob/l+Nw28zmxYaX/UjbJKhjFsRpB/DwlatWj9+xdrA7Lmy4n0 LQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussudtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 01:54:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A31M9jN009664;
        Thu, 3 Nov 2022 01:54:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmc74wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 01:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTFbrsAF904cO52i5nAwCDMZrCftngba9icMm3XPHeLPym+qutLhttDJECFq9oa72Ja2/Q/sG6JqZxJLn+A3jhkmmS6H9gBNR62v3tF0/woxGaRac7mfF2Ik5OEem9/+QjsvENooOFmiSti124A6Ns44MQRgDIMbu020CT7KlkPaQyCNPgQCQ8R2OfN06PlNOTN7bo3SdKf7HwEtCyalrtfzinsQLfi3PJJnaapMkwAeySW1VRSGlrL1zM1QktLFYbS8kfLH6uyOvoczT8bcIRl14Cnv5xgoGj9fyGrc7hS7bGZCPZf8IG5hkRn5BAhY9dS5gFFr3n0MjKT/jh7mMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGo1M30lP97FL9noRvlPBDyyK0J7W/2LoaZbOM7onww=;
 b=D7iLpyuiatzuIjsqSHh6TDrQJyQtRBJx4w9NijS2YQaTlNzuSvvzqjBR+moiDff8I4v4Ld3fdqZ73dl9A5BObYai1eww1BcBk/1X3y+h6Pxu6DfpNKgKFUIxeYdsdYgtpoJ4+3+zjVPndTzcCPDt0NZQkZCyhZpiOOV8FBPkPMet1o6i9sxdKx6bICQReUjlA36OPUTXxmyxh9Mt+9vmDN+BLc/BLYV6KUV1FCEY7OnzHMbJvr4N9Ap1wThhtr84zaXA5Ej+S9ywQy2iI9+Ui5NyV5kesGZKEy/havvbS5hkHXREjbWCFUK1W/8OeOPTzV3LG3rGomo/R1sizJy9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGo1M30lP97FL9noRvlPBDyyK0J7W/2LoaZbOM7onww=;
 b=tyz3S2cT+8zrbMmaZsgyUgqTqYJVT+ut/EZv46bNylAGCCm8E1797nBzzFYBlE3vQLrci+FaZAoKwC3bzjU36gCSAur2PyKVXXPDGk/M1XkMybns3W6YAXdbwcyesqWWRun94YWGNsWaS68aGhKj2cLfVdtPQLBmSw/y1ZRraP4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6336.namprd10.prod.outlook.com (2603:10b6:510:1b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 01:54:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 01:54:04 +0000
Message-ID: <37fda332-3f07-4d98-4317-78d84763218c@oracle.com>
Date:   Wed, 2 Nov 2022 20:54:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 01/19] block: Add PR callouts for read keys and
 reservation
To:     Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-2-michael.christie@oracle.com>
 <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <6faaba2b-5fb3-7121-5796-af2b2f73b6e7@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:610:cc::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: f76d0a37-9a8c-43e2-3f5f-08dabd3e4976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiVE+SY1SxSsogsGZXWI2EJwUnE+t5p+a7hhK7FNnQ5+roRPZTVjlPgNoi4BogNcXnfVnWLEz+/+tPR/CCzWynDzRkYuLgG3p3V83xfeOf1PIDS1ne1iQ7t9tjlHnCBGekEwE6+raJVjgKF1/3q/rZatUaN56pPoDTHGZ2sdx+HsFdXLMRR8fX7ASjT6nQIH6h6gZtDawvB4W+gQGXaMNP0bxFqjJGLhPSVSzLQsAc/mtHGg0/KhGyXNHColjFpOsvtleesCsJKDbVDpp620DXXNSyCnXCjI49UbyT7YwQGGVPtnlZ1uS52BNty1x2uDBRZMGXucGCYRbv/MXH6nccqPsFpNCV96Ih7EGkSNX0ZDTA3TUlslF2NVo+AtaKmk4pwpPfLEAnEVIwiak4MwJeH4wL9SKZC3PJvLLIodgIyW2qZtDiFj2J52An5V/vG5/LcysSzASfWmVbv+iFVXQohFECN/r603mSK9db8GVDhM6NgUm4vH0O7QZnPN8ASY4HQu/yQeHXo8HcHGpmW16odtHRGwpiX3ogJxfSOuafZenYx+qBj5/Ro/ZMWGl0AedjKStSIejlCurjzrF5gu23yMCBGDZ0v0t+wQkwfn0JFv3jxq/R8T2hsBSd4ZFSoz/GJ9yx2ollPMxv3bX+mNvOhz3v5hL/DrjVY0Nj4gWiuZER0MQabQOUAADtI2Wzroubi/v95yLvagTjrCi7q1BcQhxIS4WHLzuJMX2qsAyGNi5psPJLH4qsdKgFZ0xm9fpEinum4uCL5qdzKG3B+ZW/XFq6Nx+Mx11dSQQst3F0YBm6Ox+gEwIVa0NW4zmjro
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(6486002)(316002)(8936002)(41300700001)(5660300002)(7416002)(38100700002)(66946007)(8676002)(66476007)(66556008)(6506007)(186003)(26005)(2616005)(53546011)(6512007)(478600001)(31696002)(83380400001)(86362001)(921005)(31686004)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0VxTHZNc2xYNFA4RkRxb3p0MEMxWFZrWUVKeFZyUlZiYWlMVTMxTlhXRVpI?=
 =?utf-8?B?WUtNaHVpTUhZUGw0N0ZmNlhtSmhFZEFZWTVzTUNQWGZwbDJkUUFmZkFkbUh2?=
 =?utf-8?B?elpsdWxpVFEzWjJMTWR1bVlUQTZKTm0yY0ErOVpEalpPVjF2RXl4VFJWdkhz?=
 =?utf-8?B?OVFNUjZwem5zTkEwcmpHNHZZVTJXc3FQVXg0c0wxSU1JRFZWRlJhMHhQSm51?=
 =?utf-8?B?RGRzVE13YityQTJBT2d2NkNubUhmNWpYR3hhZEpBZmk3a0lzVDBVZTdEWkZE?=
 =?utf-8?B?UkV3T0kwb0pyRmF6WTFKT2R5bkVNMGlkRGtiWFBIWHNtWHpPUXllV01wM0k5?=
 =?utf-8?B?R3p1d3p1RytLVW52M0s3aXJ1c2h1MGZCZ2FOTDhOVWgyOE5KU3N1WXlOYjls?=
 =?utf-8?B?dFUvU1JNMTFsS0U4bGRrVjlJdnl6TDdUaC95TDFVV0hnSkxYdUpQaElvLzJ2?=
 =?utf-8?B?bllHdHVYdjRWQjh5TFZEZGtRaEJ1TGxSWVFyaXNheThtNFplaXFjS1hGNi85?=
 =?utf-8?B?YVlPQjlnNTNmVXdZOEJISmVQZnFpRjV6dzhnSFpsOTdxbVB5NFlpd3BTa1Ax?=
 =?utf-8?B?QVdhdjdsejNqelREMU9GbkorQXozcERXcm1OYUJYVys3TDlyRm4zVG1zVDFr?=
 =?utf-8?B?M1JBb2I3c0w4aExFUHVIUGFuZDkxNjRybFZzWnJqRHNOV0Z2Y1hqT1RISTAx?=
 =?utf-8?B?YTFQM0doNnN6QkNzTnhNSEszTXdLY0llYVMva3pweVVERjFuSjNDcXJwUVlU?=
 =?utf-8?B?SjNQQXBUQnhvRytMeEZMdmNzc3FtRE1tai93dFJUTlRpODVrYXFoQTArSDZT?=
 =?utf-8?B?WEh3aGhrUXR6Vkg2REtDK3Y5ZGp1UEVRVjF2R0d2eUtDQ1RhQkFYbHdOUXlu?=
 =?utf-8?B?cUdBeER2UFI1ejhpeDdFVHJOQW1tbnQrbkdNNVpORkZ5UnVNV2JqUFV6bUlx?=
 =?utf-8?B?Sm1PelpJbjB2NC81cjdXOTFhTGJpcW1hNGtjT2hRUlMxWjJ6OG5ReWJiOC95?=
 =?utf-8?B?cVExdW9JZXZ5cGZYemVDUllsNU5WUWIzVGpiS1JDUm5yc0RSelh0NGlzVFRB?=
 =?utf-8?B?SExuUmJjdTEydGQrc1VjOUo3alBMVmFuLzRDRVJWbHhJN3VJWDJaYTNWRkJT?=
 =?utf-8?B?ZmVVNXlybjR3bEgzNHFZdis5Zjcrcm03dmRiYVkvQzlqakZLNUZ6V2haQlBm?=
 =?utf-8?B?RkRFaFp4ZzVmSjdaaHNsVktRb3VhcC9odUhPemRwclpwQ3N1QU5pcmZGNjhX?=
 =?utf-8?B?YnlHU2xJRXFBQ3ZGYWEwMW83MElEZCtIQ2d5MzVqMlhwZVZrYklnZWZYQ2R1?=
 =?utf-8?B?V2huUW1VQm9GVytaVmlsVm5hTHdzMGdlN3BzRHB2QThGLzlEbW5OOWhTSGcr?=
 =?utf-8?B?SXpkU1IwQ3RKeGxpWXptTXR3aVNxZ2krblJ5bEhDYmN5bzYrdzcrbnRkNlg1?=
 =?utf-8?B?ajBwRnFqVFhaS0hER0VoZG0vU2JMRFQ4SzIvZ3p3M3pIdVZtMmxXWElhQm8v?=
 =?utf-8?B?akJNZ213TmNMNllZWnJHVEVFTVgwYkdVZmcwYlA3WisxalA5Mk1pQ20wdlFG?=
 =?utf-8?B?QWhxZ3dQUjlLcytlSFJXZFBGUVM1L1R3K3l6TXUxUkJ6TVNHMG1zZEluMXAy?=
 =?utf-8?B?SFEvZDBSanczdXk3NFlGZE9mL3k0bmt6TUFITDJ5ZElXUjBLVlZYZmN2SkhL?=
 =?utf-8?B?UThrQ3YxWEYxNlhmMWZMZ21NTGRRNklNVzlhVDB6OWFNYk9BSHdzSjdrYkQ0?=
 =?utf-8?B?R0huYjZoYi8ySlVCS2JJb25Xd0lVYi9FNUcrK3p4blFNUXkwV054WjNKdjNz?=
 =?utf-8?B?MHk0VTdxbmUxNjBob2xrQUlOQjFLM2NyMEE0SkxBbnRrNHFWbURPSEpGemRQ?=
 =?utf-8?B?OW1LMWZEeHg0dFQrYkw5VDQyYzljalcxNWJBTjA1WVA5YlpWaStnenNYRUVK?=
 =?utf-8?B?aEUzSjJvQmhVR0hEdE5OdEl0MVBsa2t5aVk4TTFmWEI2N2cxYnRDa1FlMjhV?=
 =?utf-8?B?VzR4TUp5a2kzMVNqNGxtWWdXMUVGWUhzWHRrWnFMbGV3S3NERXIxdUt6dmtk?=
 =?utf-8?B?NVhXTU41Wlo0K0swWCs2L3pVZTcraTRTcjVYWXpWekRVejVYak02YjFlS0xU?=
 =?utf-8?B?UzJNaG9MQjBtWDB2QlZSNFdESDFMM3NUSlVvODJieUFGNEJpSmRKMlNFc1NX?=
 =?utf-8?B?VkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76d0a37-9a8c-43e2-3f5f-08dabd3e4976
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 01:54:04.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zc/xdPZYWjGPycNvByeWi58z7Osk6LySoQEI1vDAUzD0MjN5QDsOIbAO19SytYH8QusCQt0fYr1E21x7LGhzO/aTwa80h7GXIqQESI+asQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030011
X-Proofpoint-ORIG-GUID: -KB-NS4_DQP3JaHwKjjHHnGESiz_kkAQ
X-Proofpoint-GUID: -KB-NS4_DQP3JaHwKjjHHnGESiz_kkAQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/22 5:50 PM, Bart Van Assche wrote:
> On 10/26/22 16:19, Mike Christie wrote:
>> +struct pr_keys {
>> +    u32    generation;
>> +    u32    num_keys;
>> +    u64    keys[];
>> +};
>> +
>> +struct pr_held_reservation {
>> +    u64        key;
>> +    u32        generation;
>> +    enum pr_type    type;
>> +};
>> +
>>   struct pr_ops {
>>       int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
>>               u32 flags);
>> @@ -14,6 +26,18 @@ struct pr_ops {
>>       int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
>>               enum pr_type type, bool abort);
>>       int (*pr_clear)(struct block_device *bdev, u64 key);
>> +    /*
>> +     * pr_read_keys - Read the registered keys and return them in the
>> +     * pr_keys->keys array. The keys array will have been allocated at the
>> +     * end of the pr_keys struct and is keys_len bytes. If there are more
>> +     * keys than can fit in the array, success will still be returned and
>> +     * pr_keys->num_keys will reflect the total number of keys the device
>> +     * contains, so the caller can retry with a larger array.
>> +     */
>> +    int (*pr_read_keys)(struct block_device *bdev,
>> +            struct pr_keys *keys_info, u32 keys_len);
>> +    int (*pr_read_reservation)(struct block_device *bdev,
>> +            struct pr_held_reservation *rsv);
>>   };
> 
> Is there any pr_read_keys() implementation that won't have to divide @keys_len by 8? How about leaving out that argument and making callers store the number of elements in the keys[] array in the num_keys member before calling pr_read_keys()?

That seems ok to me. 

