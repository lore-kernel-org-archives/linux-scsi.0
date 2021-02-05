Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2FAC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 00:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B8D264F3F
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 00:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhBEAoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:44:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51940 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhBEAoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 19:44:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150USf4037617;
        Fri, 5 Feb 2021 00:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NEiJ/5j88fD4n3epXmT0djnNf/Ik/7Q0NHqAenSFbQc=;
 b=zNLVKvsa2w2uAq8Vrd0lAaLA7o5yz2132xcKGBUYDA9axJGym3zTwSbncaYCPvxGNKie
 hdWWvy8TbgKYeE3/+gNL1oB6Hdq9ET9nEAwUeSoNgo2lrtEwJEMd+BP0RUzLuzoZo2Bf
 FM6Do3Uz0WKTKoMUBw47DogokcNxPt8/JofocAtrLVnYOJK0YIeIwBtK/1cbnJyJ+Y7l
 lwTMZsUrsX0N7K7m2ANwXpFSrtPdwl73lvy6JG7JqibVSEVfpVDe7ryM6sCQ5fVWnNQ0
 4Tf4Vxom0fLsscMTzAH68IFA0lDoOBqO5zAkHT+bMah/ZPBmSzS94WXcntRq61H3UJn6 oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyb81gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:43:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150Uge4030794;
        Fri, 5 Feb 2021 00:43:50 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by userp3030.oracle.com with ESMTP id 36dhd25dc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:43:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8U8MxRT1Ct+6a1stbuupU/HgArj1LmSwZQ9BQJX39lyJXuU2m7yfmAM21RkxTx6KFyoyCT7POu0Cl+A1VYdN6vsG2n2ZTznah7mUHfcJwSW2lPLTg/V18xhOLmxvdvwrdJL567QQIkYcQZq4tIoZ8lUz8Zq1A6qm/yGKmeX6upkXIPHQsPntaGLgtKs4yCWgWlVu8Dw/HDniiZ7+nVxDv41cQx9Vn4nDwUOoMXqxC/dDnuB0n8Wg/562hSdPs4tOlIZDgwiFHw9Ss4iAtat5+EfcC0vm3bf8w05zSgvkbeMPIJtbUw8xXs6hqORS0tpvNPc99NbYmGTsV0lYbiE+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEiJ/5j88fD4n3epXmT0djnNf/Ik/7Q0NHqAenSFbQc=;
 b=kSz9EFCZF1DNlcRPtTezLEoo4SURfqYvslFRG2dvaz7+0rbijQqMfXE+bBHdKyAsu0Af5nsEPISo5UYnMHDvGCmq6hJ/y7tT31wjmK3zy4j/Xo6ajIH2fAzr7FioA//WzuVgf+denLrAubU+0NqaoLkqK24QbQSygHneBQoHSEc54XD3YAAm49jF3+SZg/WiQwsO7mor6QIOPXiI7J59mFFmtxxu0dZ9wUca1mRhBfvJ1WBj3xvJ/NzZGhJzZ2Bk7xh1Ld1DKvAEPyBx7Klyhe9b6eJG29O8I/TDn+8Y+3up0cGKmqQ1Bj1TliGmVF77xXx1qmCcK5BLxhusD2jeiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEiJ/5j88fD4n3epXmT0djnNf/Ik/7Q0NHqAenSFbQc=;
 b=Id2a7ckBplFqtRkaH+canV1kvsTGH59GRpVRJh6kZTfmBuQlrm8yP+Fxn4AzI4xca0TYOr6Mu6SOFJoVsZ5LVolUb+TdB3FLL1WwCq+A8KtscvuuQLklVLcJSfo2o+kJLjQr4Vt0z2dJRdAdG76FlSEferfTlrx+dnnzmzM86Mo=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3173.namprd10.prod.outlook.com (2603:10b6:a03:153::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 00:43:46 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 00:43:46 +0000
Subject: Re: [PATCH 02/11] target: add workqueue cmd submission helper
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-3-michael.christie@oracle.com>
 <BYAPR04MB4965C9444DFCF8D77E4A9D2286B39@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   michael.christie@oracle.com
Message-ID: <d1557e9e-e7af-8743-39e9-3cf43688a9a2@oracle.com>
Date:   Thu, 4 Feb 2021 18:43:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <BYAPR04MB4965C9444DFCF8D77E4A9D2286B39@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:610:51::24) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by CH2PR15CA0014.namprd15.prod.outlook.com (2603:10b6:610:51::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 00:43:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 151897c1-be6c-4f90-bc75-08d8c96f1897
X-MS-TrafficTypeDiagnostic: BYAPR10MB3173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3173A05A6F8E657C2EF5B808F1B29@BYAPR10MB3173.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MWijbQV/iJfrMueMjWntAKNh86riP4expAH/j4KHOrezCVwIBN0tVP1MvPS5t2+Tkvwz20xV0ZdG5L5y8TQkrZYKdCnevLUUa6QiBY0iSPFTiRIa9n4edCP/A/S55hBAD6zMaURFadT1lNuuUBFaxnd4uIAwUN4K2m17MCUoDXTo5ceTvzAZPKrr5I54fL8M9HBUlKsSz2brPSqMy/TiyRSsVm/jJp8iBtUBxHZ+lR0dEy90iddxQI6EJlWpk9TXOicLwEc+fuNzgN9246h96a0tpY7d+XkHIpucu7goDzN6HNAzBpAOmIu4yZFw+hELt+YDKihjV4Wmu+31AHtcWrREF4JbWn+B++sIXxkaSH944cZd9NRaMdtgygBSfFm+y6ig9O1r7o9Od6DjjupiGUfmZ7cdrjQRr1/Gqg7JTOvHM/IYi6E2QgJLdtfgyO7iV2vQpS0sSgaAnpGHxlSDqhVPF0PcFvRiR0c5my2UQnqfEYtck+FhMDQWieg0gBbuCho0hZdYHVd/fagze67QOkidq9CpiQJj/d61ASkQ0Tn5Ss7xLeyiV7Doioxgsd3ydTJaiVC+BJ88SsR33JMyEIoKQCYGfMOjTknk8qpQZA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(53546011)(956004)(26005)(316002)(8936002)(8676002)(2906002)(16576012)(86362001)(31696002)(66556008)(66946007)(5660300002)(83380400001)(6486002)(16526019)(6706004)(9686003)(36756003)(186003)(2616005)(110136005)(478600001)(66476007)(31686004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGZsMDA3UUdWNUkvakFyaHB6b1lYN2ZPT3V1UzVKd0RBcWFUSndXR2hjSTJY?=
 =?utf-8?B?Y0VuWkZucTVZb3ljNUFYTENvOERab3VTeno3eHNnMm50VjlCQy9ZS2F4aEYz?=
 =?utf-8?B?dXI1bWs3OEFsbVVHeXU3OWg0WnVndUw3MTRpUGoyWWFweXlGUHo5Q0pOb0FP?=
 =?utf-8?B?VHI1ajlCdkJvNjBoVFVkM2E1eXBpSTBKVGtxSmNrYVpGTmlFSmpqcTFxQUoz?=
 =?utf-8?B?UG5GU2N5YU5jZXQ2M0o3VVRUUUFsVWI0citTVkMyMDBQZkExZWdoZS96UWhL?=
 =?utf-8?B?ZGpXT254anVQOE54cEFjUnFVS3oyNXhQNXR3YlRnT1pRQ3VJZHFXcVFuZ093?=
 =?utf-8?B?M2dtNlhpbzdKMlU5UjNML3RqNWhIR0RZQTR3M3dZbnhxWUFMREx0ek4vQVBM?=
 =?utf-8?B?aGRnMVFWVmxoV1M4UTVLa2ZEY3NuYUxFN243MVhsN3lJV2RSNDBoOXE1SzdO?=
 =?utf-8?B?anorU2xaYnMxWVdVd1NQUG9yZE9UMHZWWFYzS05RN3pUR0tYdHVvcHJ0ZUhY?=
 =?utf-8?B?cXVQd0hMUVA3TlN6SllocVBxYlh2Z0c0ZEtSUjluZnN6Y3NBNVpOK2wwaDdk?=
 =?utf-8?B?d0tTVWtQOHRTd1I0QXpUVUppTEk2MWxsTHBWRGRBNUI5SXUvdXVpdjk2OXlo?=
 =?utf-8?B?Uk51RW13YnhXTTBBQjFvci93YWgzNERrd2YrS2FxUmNNSlExYVpYcjYvZzIz?=
 =?utf-8?B?UEdtaTNVNjVnMUp5bTJHZDZ5Ykt1djVlak0ybVpsb3ZLWGY1a1U1eDI2ajVD?=
 =?utf-8?B?Wnp0TUpSb1ZVU2NhOTBIWGdPVElTZlF4dmNLdFFzekFxbHhaU1hxSmxmZGRH?=
 =?utf-8?B?OVRXZUlKVkZvd3hqSHFqbGZvdUhucWJMclYwTVBOK3BKMTNVTW83eFV3aTJa?=
 =?utf-8?B?WHZEOFRtdnBrN002NTkvRDRyTnJqSlhNQ0tZQ3NiMGFPNndZQVh5VkN1V0VR?=
 =?utf-8?B?STRtMzBoRFV3UkNuZy9TeGI4QldwRllpRVdGZHdRUjhNT2xZQVMwdEVxUHVn?=
 =?utf-8?B?S1djci9JVGp6SEJwd3BvVlQzMWRVeFpVWUNhUDVSN0Q1aml2eHhwSlhSWk0z?=
 =?utf-8?B?UlBhbEkvSDFGTzJwcmk0NjFLRW9jM3prS0NVQkxTQmlHVytpQ1p1aFhIQitS?=
 =?utf-8?B?SFdzb2xBaGdDREgwQ2JVTzNubDBEU1pBWGdLWVVmMEtCdWgxSEFKRG5JMmEv?=
 =?utf-8?B?ODRKLzRjckJmWGJmOEpWZHB2SzNDVzdBR0hicmNkaVhCUytPMDQ0RVRSc2hr?=
 =?utf-8?B?R3ZxZFBJVUpxejJTQVNaRE5hM2NGWXJJUWtqdHY5SEtUcmh2M0Z4N0xzaGEx?=
 =?utf-8?B?ZGtGZ1dQNzFZaFdvVHh5elcwQ3RPRmZkRUtCeEFNbTJGdmUyY3g5NnN5YVA0?=
 =?utf-8?B?cFNuTXBkM2lkM3diaFpaZDNEUDFJSmJYS2l3amNMNW8rQVVyaUdTWnBXVVhl?=
 =?utf-8?B?OEUzV2x1dXZQbG1ZcUw1eC80b0s3dHQyVDNQMnVqTXVuUCs3NDRpZ2VaQ2FR?=
 =?utf-8?B?bHh3ZkdiZktHYU9NaWRZTDdxR1JESHh2OTR6YWg5blUrOW1oRGtlYUVRWFow?=
 =?utf-8?B?OURlWHZORHlYS25aRzFETFpNMFhscEZGSGNrWnViMGY5RmpXL3pYVW5rS1du?=
 =?utf-8?B?NUJmb2s1cDUvdW11bThNRUJUcWl0OFMxVmxkYzNMYi8rOUxqdEpSWHBrZW9p?=
 =?utf-8?B?OG9CMXp1SHVJdzl6TzZWZHk1SktzTmRZNHRkbjk0SGlObHZqQzViWnNkTGVz?=
 =?utf-8?Q?SOR7hUlDfX7UhEo82XbG+UFXDF9hmfuZ/uVZhM0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151897c1-be6c-4f90-bc75-08d8c96f1897
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 00:43:46.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aL+yHU6u4cNMxvSLw6W+wzaOP21QAJj3uYeTial0zoHq56XlDv8BrMYhtqEz3kw/p+6eMDbhnyKeG3ZhK5Pt96Vk9Ev8ikKj+8xCfuv0Fk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3173
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 5:13 PM, Chaitanya Kulkarni wrote:
> On 2/4/21 03:41, Mike Christie wrote:
>> loop and vhost-scsi do their target cmd submission from driver
>> workqueues. This allows them to avoid an issue where the backend may
>> block waiting for resources like tags/requests, mem/locks, etc
>> and that ends up blocking their entire submission path and for the
>> case of vhost-scsi both the submission and completion path.
>>
>> This patch adds a helper these drivers can use to submit from the
>> lio workqueue. This code will then be extended in the next patches
>> to fix the plugging of backend devices.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_transport.c | 102 ++++++++++++++++++++++++-
>>   include/target/target_core_base.h      |  10 ++-
>>   include/target/target_core_fabric.h    |   3 +
>>   3 files changed, 111 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 7c5d37bac561..dec89e911348 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -41,6 +41,7 @@
>>   #include <trace/events/target.h>
>>   
>>   static struct workqueue_struct *target_completion_wq;
>> +static struct workqueue_struct *target_submission_wq;
>>   static struct kmem_cache *se_sess_cache;
>>   struct kmem_cache *se_ua_cache;
>>   struct kmem_cache *t10_pr_reg_cache;
>> @@ -129,8 +130,15 @@ int init_se_kmem_caches(void)
>>   	if (!target_completion_wq)
>>   		goto out_free_lba_map_mem_cache;
>>   
>> +	target_submission_wq = alloc_workqueue("target_submission",
>> +					       WQ_MEM_RECLAIM, 0);
>> +	if (!target_submission_wq)
>> +		goto out_free_completion_wq;
>> +
>>   	return 0;
>>   
>> +out_free_completion_wq:
>> +	destroy_workqueue(target_completion_wq);
>>   out_free_lba_map_mem_cache:
>>   	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
>>   out_free_lba_map_cache:
>> @@ -153,6 +161,7 @@ int init_se_kmem_caches(void)
>>   
>>   void release_se_kmem_caches(void)
>>   {
>> +	destroy_workqueue(target_submission_wq);
>>   	destroy_workqueue(target_completion_wq);
>>   	kmem_cache_destroy(se_sess_cache);
>>   	kmem_cache_destroy(se_ua_cache);
>> @@ -218,6 +227,69 @@ static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
>>   	wake_up(&sess->cmd_count_wq);
>>   }
>>   
>> +static void target_queued_submit_work(struct work_struct *work)
>> +{
>> +	struct se_sess_cmd_queue *sq =
>> +				container_of(work, struct se_sess_cmd_queue,
>> +					     work);
>> +	struct se_session *se_sess = sq->se_sess;
>> +	struct se_cmd *se_cmd, *next_cmd;
>> +	struct llist_node *cmd_list;
>> +
>> +	cmd_list = llist_del_all(&sq->cmd_list);
>> +	if (!cmd_list)
>> +		/* Previous call took what we were queued to submit */
>> +		return;
>> +
>> +	cmd_list = llist_reverse_order(cmd_list);
>> +	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
>> +		se_sess->tfo->submit_queued_cmd(se_cmd);
>> +}
>> +
>> +static void target_queue_cmd_work(struct se_sess_cmd_queue *q,
>> +				  struct se_cmd *se_cmd, int cpu)
>> +{
>> +	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
>> +	queue_work_on(cpu, target_submission_wq, &q->work);
>> +}
>> +
>> +/**
>> + * target_queue_cmd_submit - queue a se_cmd to be executed from the lio wq
>> + * @se_sess: cmd's session
>> + * @cmd_list: cmd to queue
>> + */
>> +void target_queue_cmd_submit(struct se_session *se_sess, struct se_cmd *se_cmd)
>> +{
>> +	int cpu = smp_processor_id();
>> +
>> +	target_queue_cmd_work(&se_sess->sq[cpu], se_cmd, cpu);
>> +}
>> +EXPORT_SYMBOL_GPL(target_queue_cmd_submit);
>> +
>> +static void target_flush_queued_cmds(struct se_session *se_sess)
>> +{
>> +	int i;
>> +
>> +	if (!se_sess->sq)
>> +		return;
>> +
>> +	for (i = 0; i < se_sess->q_cnt; i++)
>> +		cancel_work_sync(&se_sess->sq[i].work);
>> +}
>> +
>> +static void target_init_sess_cmd_queues(struct se_session *se_sess,
>> +					struct se_sess_cmd_queue *q,
>> +					void (*work_fn)(struct work_struct *work))
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < se_sess->q_cnt; i++) {
>> +		init_llist_head(&q[i].cmd_list);
>> +		INIT_WORK(&q[i].work, work_fn);
>> +		q[i].se_sess = se_sess;
>> +	}
>> +}
>> +
> Can we opencode above function if there is only one caller ?
> unless there is a specific reason to have it on its own which I failed to
> understand.

Patch 10 also calls it. I tried to say that in the end of the patch 
description but it was not too clear now that I read it again.

I couldn't decide if I should do it now or later. I selected now since 
it made the 10th pach smaller.
