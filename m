Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CB1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F3B60EFE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 15:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhJLPxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 11:53:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44760 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237588AbhJLPxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 11:53:16 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CEvK0w018546;
        Tue, 12 Oct 2021 15:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bG14j6AHHYyi508iLmqSxDyph5KNyHjB+W+zT1AJj8E=;
 b=yvUAPzTy+TgUqdX+B4ii1ijxHWMgScEf8Ltk9eVFbN4C5IqLKXDONfONBMoo69vjAQdO
 1ri3HQGP1XNdKrwvUh9T5857oSyIrPuJaZSXj0xq2ewdTsEV11o63a0dS3MuKQYkV6UE
 Xhna8M1lUGVv7eIyOK4GRD69C6jsVif+Vszt5TFazQgi8jdCTFVbsTsVM8Ye2zcArCrN
 hTJUOVLcO76qimRUJrDQw6hRXhVAnF99C2Ah02o0Epd0e1LmrtIrOnWVY6O4r6WdHf3U
 4id2Umw7NeEL6aUGOlICzSfFVXW8OrlSWhvfS0tsnGG47LMBvQIUZSt9NTdMDNzB2ipy yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3bgh53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:50:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CFkPXY112032;
        Tue, 12 Oct 2021 15:50:57 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3bkyxrwa3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEEF5G/AMYYTIxdK+JJ5Qk+kPgU7P1S1G+tNdjKC11uQkqgMqRWTAkukKvfEtzNl6iglqk4Y/DYnZ6fG0ohRzv9DcR2Sfb1KqspPUsNvGIOM74m4aWq3G+s4LrNPF1sfhLAaivOhdxo3kRLBmPszpUfu2lCT4LIaL0Ka0iQqohiGNPtPFf532fA3lk/dNIrUFdOn0id+mRQZO57J+Bshej7pfg2Pe92LZ+w8GczD66SdilCU6Feosb7oLGV8m3X3KsS5pY1SKbwjwhOzEIJFMDdeMUe0xEEovG0nF2lGQPeZuaNcKp6IKYYjQZyedtafTfqtlvLfDM/anPvPEhgCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG14j6AHHYyi508iLmqSxDyph5KNyHjB+W+zT1AJj8E=;
 b=dnNG3yEkaVY6g4DZafIP7d5dEht38QX+aOrLa9mXmxM6k528a6UnnF/LhQnqGV2gpvKDZ8TLjI3O8R/onczLu6YNFewNCMczjmUxe7qs1CoAAUpkV3Lq+/yKUTxdgOy5ZbEDtME6Jdtxm5hsbhqOO15l6osi/gM7GcDhBcz6CaDi2UEeMDgO8IUeY0XVXQ3oTxnZ+wivMasLKZWHtrpsIPVv8mtPmO6DXq/DQCgU5kDt8PYmh54NGh0T5Wkd1naXDVFtRO2JI7gXhMT+b4an4GB0XISicl1zaqWQIwZ94x2iUspeEdzB2MVzTt8TL+Iry24iN9HQZyqXIuSJqc2EAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG14j6AHHYyi508iLmqSxDyph5KNyHjB+W+zT1AJj8E=;
 b=aJCur2d+2ObmkE26W21AGEEGH4DJO05HSVHY5NTCT4aQWuozbhzOZoDlzgwv7WRIAzvTSkxEBcMFGbddpNIg6EK7I2LYhnDb/ApzrR9m40STwj5Nm7MKWI+nsj6quDoUDiMnucF1G95snYmiQfL9DjDyVd5ROrdaU49s7JySTfg=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3802.namprd10.prod.outlook.com (2603:10b6:5:1f9::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Tue, 12 Oct 2021 15:50:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 15:50:54 +0000
Message-ID: <b9bd869a-a67c-77dd-96bc-d0fceeb8895c@oracle.com>
Date:   Tue, 12 Oct 2021 10:50:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] scsi: fix hang when device state is set via sysfs
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     lijinlin3@huawei.com, qiulaibin@huawei.com, bvanassche@acm.org,
        wubo40@huawei.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Lee Duncan <lduncan@suse.com>
References: <20211006043117.11121-1-michael.christie@oracle.com>
 <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
In-Reply-To: <57607b77-7d3c-1a75-78c2-4a15d8863c82@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 15:50:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0c3fe50-4e23-4a28-3e56-08d98d9812e5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3802:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB380260A967D26F2FC7412B9BF1B69@DM6PR10MB3802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ut61V13vemmY84IDWsb2e/wJPTvkPjvs9pJHpx6sazDn9W/wcH7LxFd66PmSex0tlWGpL/pB/XA8Z3h49VUCu4Uc75DcM1GOZ6MJmVsCRJYB5LzVs2Zro58hQDbbdkbi0tNt6TAXVZCZCZQ2mIjNEy9gp8C0C15sQ1G1Z/Is9UfkovadoUK+EH8/lfxJjaoQCblwgr4Ck0Y5Ns6TNhYLONhZX8v9W2IDiTzOLQ8/yIwabD/ejEddh02qDPU0mfwEKvfezwlhrYDas36psJAVE4q7uR05ly3tTu8K4HUfvIJuCHedMwHOu3o0J+nuv9vI5JQPG37qnWDfLjZV1xr3Sf9bSl32Hoj1/P7XKNai3qdiYd46GXzUqH3N0OGNvT2PfI3ISg75iwX8veoayvKJy3KF8XOwi4/AzBXn8JI5rKh5wrUEKt5uFxRet9rsZod/FJBld9Mot9cbZAE5IuV0WcEy1AnVhA2ns3+LNDngwlFFSyp3H7QbyUiCTJigGqhvCPHzeQEjosWuknvQ4o2aeZPkpWczMF4VjzKVBdivhS2Fv1Vtj//hmY/SgxuIXjp2iIC6+yVxwql4kOGUtj+voc5czBYXbuTftiPzFNXPsI1k4mAmFOABVICMdi//dT6ApalD+powZgfRKGuFUK2rPaq11iBFdx9mAZSm4yqPGZxbsiDGy0SgI4SoP0/MV9AL8MHrfjomAZlcl6VG3fVg6EKs429FB9GsLHNGRZlWdPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(2616005)(186003)(31696002)(8936002)(16576012)(53546011)(36756003)(83380400001)(6706004)(86362001)(8676002)(26005)(316002)(6916009)(508600001)(2906002)(6486002)(66946007)(31686004)(66556008)(5660300002)(66476007)(38100700002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDgrR0xNMi9OQUVrMktxRHF2c25NWEFBMUFtSTh1WjVxd2JwSFpOMkJxbXVn?=
 =?utf-8?B?VjV0am44MmFOSlBFSytMVmg4b0dsWnFwSmdjOU9WZkIzQ3RKdTRSSFdrSmNo?=
 =?utf-8?B?elA4VDFJa21IcHVQdVJDOVJieUtGUGs5MVVyeDJ0aVdscHhWcndsak05cGlZ?=
 =?utf-8?B?SVhyVHN0TFN4SGRVSHNjREZGSEp3dGpRNm11TDJNaVdBb3NmQVZncEtKNGhz?=
 =?utf-8?B?d2JQLzJ1aTYyQkd6bWxQM0x5VzJZQnJQMVZOVWV3YzJaSGRNYkdqbUFJQjUy?=
 =?utf-8?B?Z1lCc0Qwb3RvejhzN3o3Z3lCenRwOXR0S0JWcmJzeUUveWdiWEVtaWFwOEUr?=
 =?utf-8?B?ZjBMcUc5UWZtcDB5YnF6aTRMenpidDZlYW9jM2M2S1JKRkxDRzEzS1NGME9t?=
 =?utf-8?B?bCtrNjRhVUkvRHhYNGtjdVRJeG9CbUZWemNQcXdsTUpSeFMzQVM3MWh5WXdX?=
 =?utf-8?B?d1diNm1qTHd0V0gxT3lvVDUyOUYyUHlJY3lQSy8zRTRmTW1qL2xCenRJTExt?=
 =?utf-8?B?OElDSWwvVWVtYVc5WFZMRVVpWHNma0E1OWhwbU1ET2ZVZ1V1TUgwbWt0VGpy?=
 =?utf-8?B?NDRYOXlBemtnSjBCMDFLVVRjZnJsUXJZOE1mNmlTWUZmaDVtcy92UGh1eTdU?=
 =?utf-8?B?NkFiajZ6KzdXRnRpUlBOekRTZkhqR3FHZVlUaEp4alFrd0IyaXpFTEJGb2ZP?=
 =?utf-8?B?Vmg2K3krdnZqN3hIbVBSWEdaeDl1OTVibDFWeENXY2srQXdZTUlqN3cxRXBo?=
 =?utf-8?B?SkUzMkxLOGtlRzBaU2RvKzgyQ2NTTVc4K0lTYzJQVDFrTk1PWWpNY3VlOGVo?=
 =?utf-8?B?dkRiTEk1Mk1FUlc2eGN3VHhTVUUvbTRTa3FNMmJvMnBjVlFtYUIzTERZNkJm?=
 =?utf-8?B?U3Nkd0t6VzdRdmZ0blgzeS9sMW1Mb01wMFNla250bmx3bU1ock0xa3ZTc3VF?=
 =?utf-8?B?MXVDY0piVzRVVFozMGY1eFo2MktFbHpMNG0wb1dlUjJFZ1RpUWg1SlBncHRW?=
 =?utf-8?B?UHhUUkgzNWpOU1RpT2R2TS9kYUxDb2JncFdRVVNiL01XbW4zUjlRN2pTdEov?=
 =?utf-8?B?Q1NIdStBRHo3L1I2VnlQQU9YbW5TbWtPWDFYT2p0QWkvYVZhTXlsZDlVNnRV?=
 =?utf-8?B?bUNiR1JXSXJWU2drbEg0VEdiaDZvU2x1YUpwelBEclhPalBwM2VMMitXN2Y0?=
 =?utf-8?B?Tm9lVmhsRXl6Z0pNUTZXd1lCVEx6YUxKcmptdG40QU9hZ3VkcTFYTndvREdD?=
 =?utf-8?B?U2M1LzRvVW1Qb1pKOGk4cU92ZHgyMUU5K2xVMHRpVFNKYXJ0WjVuc2YybDEy?=
 =?utf-8?B?Z2czR1gwL0N6bHM1RkNvM1pES3M0QmIyWjJlUlVVdStVUytCdTFDdlFQVFVI?=
 =?utf-8?B?WjExczFJNUd4Y09YVVUzWi9sRkppMjlWRWlsUzBoTUJwbmtaeEs3VzRkK05Z?=
 =?utf-8?B?MjNNWXh4SzlFaUxHVCtpY3Q3SkZKcUh5b24yK2FwcFc2aTBJU1ZGa0ZqV0pr?=
 =?utf-8?B?Wi9hb25raUFNdXowVjNDL2FvSngyNDZuTndERHRRbXN4UnN2dTAvU3dMOTJu?=
 =?utf-8?B?end6a2tpOWY4Q3FCdUp5TVFOYUlxcmE3VTM1UENGTWU2UTU1Y1lDT0w5eXFx?=
 =?utf-8?B?Unk3WG04dlhPbUNHd1ZHQUkrNWdYWmJRSGwwOXlKUkFCVXZSMlNXUGd0cUxp?=
 =?utf-8?B?MXc5SWlHU2l3dzZ5eC9nQ3hIVDlxZWxMbHRzeklIMWlkL2g5d1lpdVZCQisy?=
 =?utf-8?Q?dpZ2AgueKeEVAr9lXlnVPsF51Oy9xoTqpmqfqnJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c3fe50-4e23-4a28-3e56-08d98d9812e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 15:50:54.6222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qhw3qu/I/W/zJu7Vmow9rG/kp2NPA+gWn2CVg/S+vkUDoMJblIuB31mmAd8QG0vz2+qTsUOgnzPA2KAXpfHuo43RDi5Nm0rRTgmxHvSt0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120088
X-Proofpoint-GUID: XDQhfJ8s0T7QeLhT3RTQIgN-onE7zVlz
X-Proofpoint-ORIG-GUID: XDQhfJ8s0T7QeLhT3RTQIgN-onE7zVlz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 11:45 PM, Mike Christie wrote:
> Cc'ing lee.
> 
> On 10/5/21 11:31 PM, Mike Christie wrote:
>> This fixes a regression added with:
>>
>> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>>
>> The problem is that after iSCSI recovery, iscsid will call into the kernel
>> to set the dev's state to running, and with that patch we now call
>> scsi_rescan_device with the state_mutex held. If the scsi error handler
>> thread is just starting to test the device in scsi_send_eh_cmnd then it's
>> going to try to grab the state_mutex.
>>
>> We are then stuck, because when scsi_rescan_device tries to send its IO
>> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
>> will return true (the host state is still in recovery) and IO will just be
>> requeued. scsi_send_eh_cmnd will then never be able to grab the
>> state_mutex to finish error handling.
>>
>> This just moves the scsi_rescan_device call to after we drop the
>> state_mutex.
> 
> 
> I want to maybe nak my own patch. There is still a problem where if one
> of the rescan IOs hits an issue then userspace is stuck waiting for
> however long it takes to perform recovery. For iscsid, this will cause
> problems because it sets the device state from its main thread. So
> while scsi_rescan_device is hung then iscsid can't do anything for
> any session.
> 
> I think we either want to:
> 
> 1. Do the patch below, but Lee will need to change iscsid so it sets
> the dev state from a worker thread.
> 
> 2. Have the kernel kick off the rescan from a workqueue. This seems
> easiest but I'm not sure if it will cause issues for lijinlin's use
> case.

I have not heard from huawei, but I don't think we can do 2. The problem
is that I think userspace will not assume once the write returns that the
device is ready to go. So we can't:

1. just kick off an async rescan, then return. There are issues with this
assumption though. See below.

2.
	2.A kick off rescan
	2.B wait for rescan to complete or device/host to change state

this could hang iscsid until the scsi cmd timer fires or until the
transport timer fires.


I think the options are:

1. Revert the patch. The problem is that the rescan can still fail,
and if it didn't cause a deadlock due to the bug in this thread, the
device could go back to offline, but we would still return success.

Why didn't userspace just rescan from sysfs?

2. Do the patch below so we at least don't deadlock and fix iscsid. Maybe
iscsid was a little too smart for its own good, and should not have assumed
that writing to the state file could not block for long periods.

3. ?


> 
> 
>>
>> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/scsi_sysfs.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 86793259e541..5b63407c3a3f 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -788,6 +788,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>  	int i, ret;
>>  	struct scsi_device *sdev = to_scsi_device(dev);
>>  	enum scsi_device_state state = 0;
>> +	bool rescan_dev = false;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>>  		const int len = strlen(sdev_states[i].name);
>> @@ -817,10 +818,13 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>  	 */
>>  	if (ret == 0 && state == SDEV_RUNNING) {
>>  		blk_mq_run_hw_queues(sdev->request_queue, true);
>> -		scsi_rescan_device(dev);
>> +		rescan_dev = true;
>>  	}
>>  	mutex_unlock(&sdev->state_mutex);
>>  
>> +	if (rescan_dev)
>> +		scsi_rescan_device(dev);
>> +
>>  	return ret == 0 ? count : -EINVAL;
>>  }
>>  
>>
> 

