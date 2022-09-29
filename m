Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDD1C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 16:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiI2QsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 12:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235866AbiI2QsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 12:48:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267A11CDB4B
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 09:48:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TGODr2011545;
        Thu, 29 Sep 2022 16:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xs8htRW5xhsTKjVcFWNciKcj2yYcsM0cl1x7iqTOL/w=;
 b=lziNKhedUo93iNdS4vyzvINtB7jshtfRkc3ltcIC3/3hIoxd9FJlrsPrDU5BgKJO7RO9
 HRb4vtMe0Hk4dgguoY9HkIln8ogIcAkOkRQlNuafjp+lZ1pgimY5YESMIMA2LD8TUdpr
 /X6DdR1kxz/4zmDZZSj/+IMCyliKC1CL1XhdaG+NCFFuXixLkAaZAbGMrZzK1GdabgiH
 cPKx2C6NCtH7aW1kMv8EtrADNcvLeNgArDS0owj6lPh0B+T2FtRMuPmH6yz6H/dzQtYw
 8Ooasw1yxnHZ9Kb2c7rDfIWCJkZlWDFwyrGAEpNfa3SHw1N0Xwfk8lB/Ox1bzeLycYRl OA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13nc0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 16:48:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TFVQVi033603;
        Thu, 29 Sep 2022 16:48:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv2w29c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 16:48:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFgZ+1wLBHi8ZGfEuLNNyZviw4I/diCyIVCZ0X2zctHw/J5D3hMvTaq2pZArvN3P0Mr2dfSYWhzJ4bpmemr8WHBjPV58PfHrqjGJ9/oPWbem2jroYvkCzfpI65/8TzY/Zb+4kbmnSWqM9bvTSU4AdRuUjtrYsOwa5kKXPjujMYMXAaqSSRxUheq8YdsS8/V64TaSutImS4JfvTfcWVi6SUOPKn51ONKsy7f9B1+tFwByBbxIIT7AIBXsldzX1VZk80wRrkRDdZu8o46PfHoRxL+RRmDf4dfijVMZMLnNNvn2q9+4TZnL9CvvuEFBce9Ws+e2CWb5nCtfWYNucQ9n4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xs8htRW5xhsTKjVcFWNciKcj2yYcsM0cl1x7iqTOL/w=;
 b=EuWk0A1FT1LvQ3mZ92GLL/Thl3RTUdUR8pP5pxFhARgEw27tbCl2Di9QZ4cxTqtVULV2VuuCXNX8zs48j9tGqP3JWXHUSU6bSSpFbGB5MVwfESBVFRMcO7g6tzLaxilIktwN+mGudXB1yd3W+1zD74sGJUs2vqULw9a9XBfl29J77h1fl1RtJpL+uQPDORYrQVgJXsqp+7uIBNm6HuoFUqULBhwxeYEcS/8vTIrUQPizd2PRLOv7KvMIEjGZLR68ct7seYDs9e/BF0gg4g4x9O6aygxn/YGM+Y9vyDvASfXCOAXyTZtsTTREAy2ZkQr6PFeBrBTN5sebLBnqqEew2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs8htRW5xhsTKjVcFWNciKcj2yYcsM0cl1x7iqTOL/w=;
 b=wKEHRN4TK+a21RTSBgZrP0wU56uETumJKSfR7QDEYK8MHXWrgwXzRTge662eSJt8bUcqTMuG6iyIZNfUvCMAU44wPKRLfzQmH08VHcMwC8qiPelW50fRIW8a/TEfn/dOHKzt68z3AX5Uj9zhUEx/r3+cTibIU/F2LFxWIElJYVE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6604.namprd10.prod.outlook.com (2603:10b6:510:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 16:48:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 16:48:00 +0000
Message-ID: <8a69a003-79bf-aceb-cea1-ab7d05363512@oracle.com>
Date:   Thu, 29 Sep 2022 11:47:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 23/35] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-24-michael.christie@oracle.com>
 <80aa76848bb316781953775922e3509410734dd6.camel@suse.com>
From:   michael.christie@oracle.com
In-Reply-To: <80aa76848bb316781953775922e3509410734dd6.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:610:4c::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 621cf4a1-e4b1-4de9-1bf4-08daa23a5e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Du4umFmJgl1OICkDClxb/MyeueJsHP7fqOf9vs7TqqN10PFOyraRkld9sy6ycaEXoHh6YN5gTGkZU9hXXJgL+qTWymfyLRw/7N+ZkxmrT62rtg88b9NDmPIdPC7bMp/g2B4UXv2hrLAgY3ZZM75MzsX0QPl3KVhUC0tr4nWuj0O/mwvclE91GZgMX3eKwXT/27D617FeO5AzmngcKEmwGarGp1R3EagdVZLHjm1YtOTYtRpy9nJZ2nZ02VJdLailY4CYmJfDd+T3wgz8BRtxujfE7o3iwWKsFO9kRZqZn/7W1SE1vqTv+uc6m+A2bKyqjc9kN1bbQOg72fevhD1A0NsPjw7L21+jG0MzbqhN6WR7514PeC79cgzGLdtbjTnAsVWIXFWsMY1ie7m2wIa7k0E1aE2ILC/3V0w6Nt7y54tSBjceyVjWGzEUmHqZkG5FgyHuKbXIXZzWzB4vPQI71n+i5lwiYMUZngvI5glXif8vfbEx4hMSAh3Bu/PCjLvWuT+aXGy2ywvQ3bYu6ZFgpc2eIrDnFAKzvoi8pP/9R5l8stGGUrEbBtoWdTwZH3wd56LpK5s0mT+bf4WF12FiummW9xGsR3n/mfZEc2P4OAMvS8leLIXBGR4MRXFRnZQKp00+GWo/VgAK9QOAJhs3HNJyrYmVzM1n6fT/oFQcWh0AQRCNX6DUBtJWVujxzRPTGYM3rStKyBW60fgblUy8sox/3Bm2dTWtdgGVm9TazVKgpgd2f6JIyb1ciGMX2+nRiiBgus0OFPX/qor+63qBtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(36756003)(86362001)(31686004)(31696002)(9686003)(2616005)(6512007)(5660300002)(83380400001)(38100700002)(6506007)(26005)(478600001)(6486002)(53546011)(316002)(66556008)(8676002)(66476007)(186003)(8936002)(66946007)(2906002)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW9FY0pCdktRYmFZUG9WUXRqeTc3ZytZcG5mZnEyaFR4WkRHcGw0cDRhdTBS?=
 =?utf-8?B?dnhiU29uWWhYcjNENXJjMnhHRExZRjhFK0w2UHhFVHZEU3hRak1EQ2dvbWV0?=
 =?utf-8?B?VXJWQldHTU9Wc3BwQkx1QU03OU9reW0xSzVJNW1WNVFCaHgycjBOQThMT2VF?=
 =?utf-8?B?N1JEeUgxODE1WTA4WXRRTkhkV2Z1VmxIUkhmeVlsVlVPYUhlOFNEMHNpNkt4?=
 =?utf-8?B?akVtNis0L3VpYjVyVGEzSmh5YTFqU0RGcVdvREVqREkwNGFPWS90bkJqOWFn?=
 =?utf-8?B?bCtOT3ZKNll4QzkydlhTdzAyK3h5Sy9sak1yd1d5aVhBaWRvVS94YTRxZ0lD?=
 =?utf-8?B?d3lYTXRwQzVmZUgwSkNsNUc1MEIzTVVWOWRUU21UaEZGN3RmNmpZdHRCOGNs?=
 =?utf-8?B?cURQMjFaRWJINk94TmZtbEp0bHhvVjdJUmRFcG9VYzkvMW9zaFRDVmpSb3Q1?=
 =?utf-8?B?dVIxT3YvelkzWXowMkJOUzdqQ3JIZ0lldnNSL3h1ckdNL2phZklkeTkxV2c2?=
 =?utf-8?B?S2JBcGlFbmIrQ3BmK08reVYrbStPNU1JNHZkWEN6bGlWcFN3MWNBQkRraEZl?=
 =?utf-8?B?Z2dCQWIzdTRWTGNzOGFuUGhsSWtmVit4Qzh0L1Y2QmMwYlV1cEJ2MlBBQW0z?=
 =?utf-8?B?YzNMc3V3ZHFzWGt4cWxXTWwyZHdyOHZBWGJyTS9HMUZwcWdSWUVHQVphN3ZR?=
 =?utf-8?B?UWRnOXlaekVtZGZ1OWZIQUhKdXJJYjVCcXhDcnZCaHRiS0tTdW53SUZjUWRH?=
 =?utf-8?B?a1lKcVhuNE9HbEJ0MzZ5Z3VkaTlBSnRTRDdOTU5WUHVnWlprdm5Ya1FIV0pt?=
 =?utf-8?B?UUpQMnJ4UUVPUjA2OHpmYS8rMTNmeHA1SmtLSVpPKzFRTU1VV1JaWkZGWEdt?=
 =?utf-8?B?YllGMnJrL2xUL05zUHdTRWVmOTJ6WFVnRUprOEVOYmxkbmYvMzE1UW5DL1Jw?=
 =?utf-8?B?Tm51azJMcXhRakNVTC9ZOE1zZmdrSWo4b3QyNjBsVnBRQnFOTUM3MmtncVZ1?=
 =?utf-8?B?ZnMxTXFiVmRPdVRlWHRxS2xnSXU4QXdhdStxb0I4SDlKRDJYdC9WbzVuTFV4?=
 =?utf-8?B?cytrRS9MVXVLeHIzT21BZlR5QnZKYldCbU5adXd2MWhHNnM1S3RwQTJOMUdI?=
 =?utf-8?B?VWRQZmh0YVphRE5uMWExUjE5QWNhcWZRUWlTMSs3UTJxaXU2czZyMithUW9P?=
 =?utf-8?B?dENWc2xIQ053RTJFZmxIWkl3MlUySks2UWlhaGxPVWhvWGJzVitJbGEzU25Z?=
 =?utf-8?B?bktxNXZuc1V1bmdLTWxRRE5JMS81clZnSGhxOWY2ZWNxMVJEQ2NrZDRwbjJq?=
 =?utf-8?B?Q3pXQjZ2MjdGdmR2YjQzbllBRDE2TlZkbjhLRjEvajdkcTVOTWJkVEdaSFFs?=
 =?utf-8?B?RXU0SnFyRFNibWl4SHhzK3F4eHRTZElCUTN0bVlWaFZsRUdUaVR6ellvZGRB?=
 =?utf-8?B?QTc4OUVGK3ZRUUZXaEZQMUFicmp0akFsWnpUNVhzeFZYbkxuZDg0OEpQN2k2?=
 =?utf-8?B?eThibkxIV3NhK0ZBOE5DRElQLy9UaGtyZzEzcGJTLzd2YU1ORFNkMnFGWmE4?=
 =?utf-8?B?SUZqZlpmd1JFMzR4d2s1cjhHVWgrY2c0dFY0OElUVU9rZmlDcWlVbUVCODF3?=
 =?utf-8?B?UkhaRXVsVXdyKzl6N2FsV1ZCMjJzeVEzNmExQm1GYU9lcWkvNWtWMVF5UEFq?=
 =?utf-8?B?b3lWTk1Vc004V0FGRnJreGFBekxDaFlDdndML2l3ZHJjMlFELzU2S1R5NkE2?=
 =?utf-8?B?bDRqa3hFWHpMNnpmR0lXcWlFaGljSkhrbmJQOTBoNmxSRjNOaGpES0c2cFAv?=
 =?utf-8?B?THRjcWdyWDhwL3lLd3U4WVExTzZ6dGhJdUVsQjFJUDIzVkdNTXdOWG0zQktX?=
 =?utf-8?B?K0QvdU5wOFRFQXVXUlEyeHAvS21pV3ZsU1VGYlpZSVpFK3RjRkwxRVN1d3Zt?=
 =?utf-8?B?ZDhwRXhSZWFsOU5CWTF4ck9sN0xxa3FaeDZkRG5RbnhFWWdEODgraVByeFBm?=
 =?utf-8?B?U2tqYWRmWFlLeGpUV2I1T01oUzc2SGxHMERBUXI0S1JRK2N5bzBqeGxRQU55?=
 =?utf-8?B?QXRHd0loVnVjSFhhRWNHLzZSaFRYSDEvUU9pZjJCeHZ2dGplanprNHRtVk85?=
 =?utf-8?B?TjhKZHY2RmRaQVpmc3RkZUZPM3c1V2FwdVdud1NXb1ZPT1B1TitJMjM2TWxT?=
 =?utf-8?B?Snc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621cf4a1-e4b1-4de9-1bf4-08daa23a5e7e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 16:48:00.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyl7kJpwLlmk1KCARXPEPfZ+A7Y0dVwxtSzukg/51KUxjqM/LKlz5Cih7ywd303y3KHehmJTe5/1w/Sy1JHgcCYb2WNmUXpj3PhhNo/+QYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290106
X-Proofpoint-ORIG-GUID: nWO-CWjOUiKjNSGkD5QnXg0dYoemL7Tb
X-Proofpoint-GUID: nWO-CWjOUiKjNSGkD5QnXg0dYoemL7Tb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 9:13 AM, Martin Wilck wrote:
> On Wed, 2022-09-28 at 21:53 -0500, Mike Christie wrote:
>> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note
>> that
>> we retried specifically on a UA and also if scsi_status_is_good
>> returned
>> failed which could happen for all check conditions, so in this patch
>> we
>> don't check for only UAs.
>>
>> We do not handle the outside loop's retries because we want to sleep
>> between tried and we don't support that yet.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/sd.c | 76 ++++++++++++++++++++++++++++-----------------
>> --
>>  1 file changed, 45 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index a35c089c3097..716e0c8ffa57 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2064,50 +2064,64 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>>  {
>>         unsigned char cmd[10];
>>         unsigned long spintime_expire = 0;
>> -       int retries, spintime;
>> +       int spintime;
>>         unsigned int the_result;
>>         struct scsi_sense_hdr sshdr;
>>         int sense_valid = 0;
>> +       struct scsi_failure failures[] = {
>> +               {
>> +                       .sense = SCMD_FAILURE_SENSE_ANY,
>> +                       .asc = SCMD_FAILURE_ASC_ANY,
>> +                       .ascq = SCMD_FAILURE_ASCQ_ANY,
>> +                       .allowed = 3,
>> +                       .result = SAM_STAT_CHECK_CONDITION,
>> +               },
>> +               {
>> +                       /*
>> +                        * Retry scsi status and host errors that
>> return
>> +                        * failure in scsi_status_is_good.
>> +                        */
>> +                       .result = SAM_STAT_BUSY |
>> +                                 SAM_STAT_RESERVATION_CONFLICT |
>> +                                 SAM_STAT_TASK_SET_FULL |
>> +                                 SAM_STAT_ACA_ACTIVE |
>> +                                 SAM_STAT_TASK_ABORTED |
> 
> I fail to understand how bitwise-or would work here. IIUC, this tries
> to replicate the logic to retry if (!scsi_status_is_good()). The result
> of this bitwise-or operation is 0x78, which matches all SAM_ codes
> except SAM_STAT_GOOD, SAM_STAT_CHECK_CONDITION and
> SAM_STAT_CONDITION_MET. SAM_STAT_CHECK_CONDITION is covered by the
> first failure. But unless I'm mistaken, we'd now retry on
> SAM_STAT_INTERMEDIATE, SAM_STAT_INTERMEDIATE_CONDITION_MET, and
> SAM_STAT_COMMAND_TERMINATED, on which the old code did not retry. Am I
> overlooking something?

I'm not sure what happened. For some reason I thought they were bitmaps.
Will fix.


> 
> At least this deserves an in-depth comment; in general, as noted
> for patch 02/35, I find using bitwise or for SAM status counter-
> intuitive.
> 
>> +                                 DID_NO_CONNECT << 16,
> 
> Shouldn't .allowed be set to 3 here? OTOH that would cause the number

Forgot the 3.

> of retries to add up to 6, see my reply to 22/35. But don't see what
> effect a failure with allowed = 0 would have.
> 
> 
> Regards
> Martin
> 

