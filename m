Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DADBC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D934A64E2E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhBJSs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:48:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhBJSq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 13:46:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIjg9p189274;
        Wed, 10 Feb 2021 18:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=g3+bOHNCXRcPyvkbJFgIXMMwxgliRW42bMN8X28Mc0o=;
 b=m4q6AM00zwfgZ7LONGjUH5o95Z13TFV8vQtu6BZY6wIw0QklDpB2z/Y6FzIkSFVZiwK1
 /l8hucJZYaxc0RYLeiFvSzWQYiAbY2HxrmflP6n3eiZRYh2rA/T5SeHxL0QBXAt2sXRg
 APTueZgpiABehbUtdG7sU3jJM974e1pzuCP8UHp2PgwNGZS3Ij+Y6pc5OCCB56p7YFIn
 ETAp3ivg4PrTb+9NCmjPSpS5/W5WIV/rC8dBu+FDrKGAMZFbLR/8MEWhqGzI4JuFBijB
 8Dr8FwDPrJ5qXlhA6Z1rwjvvY5Fe2LVC9b7f4a9VzJIgvS+VPyRimbXdY4hPYlatEg2w PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4upu584-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:45:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIQ1Ht137855;
        Wed, 10 Feb 2021 18:45:41 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2051.outbound.protection.outlook.com [104.47.46.51])
        by aserp3030.oracle.com with ESMTP id 36j4pqh8tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmJnjuita9MYfLfVvKYFGGIFS/gzd/yJiEIVw2Ciw4HnVlZwm1BZ8fAsTTF/NQGAPHqnoA/l7uqXgZzMQXRhI+KkEItVjlvih1CGrpV8qSZKvngb3CgSM7lh1OUJHjr/Yfxesftj4KTGaJOvGvBjf5XZLHb6n+qg502kHRQLD2WYAza1wKUYDx4SKBTw29tLUlyVmqwOUyBox4Csg6Rmx0WVHEhzIMSbzDMRRBhp/4LdWu063wy7LfkxqJvi0Y5sBQ/gW7+btHBC3Kj+QM91IxC4GKXlbBUeWeZ18ZWcg2TWaotvh95KOpcnz2l/KEmZtBqv3YrGZMxJuPf7URVxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3+bOHNCXRcPyvkbJFgIXMMwxgliRW42bMN8X28Mc0o=;
 b=hNVeJ+jL3Una8bleV8iHGQqq1HYKs+SHKB/pcaYZPuZFvbd/LAA5zRcJQpGTdNXun4XSMDrVWQA2Sm9W6y5zdL4h7r8gtycfR6vSrAwnv7xrt5uEe+mKm1Dhg82wslXkm4W9ztEXk83T5XmxvDmyNugy4dMFvsZWf75W29I8j/OqMYuJcuS2/nQW1lCyjt2+od8jpUAhG/mpq1Z4YBBv9EbrYX7JG8kOEAa6rqMWZJsoRvT3sQh1dKnuTOkFlhN3+ymYvqZkk6BpDd8kWXDawGvPzrLd9/efmkx7OCksHUQ3UQ/TSps1RX02JwO7V7rQHSL7tawuXN7GvY8jQ+JpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3+bOHNCXRcPyvkbJFgIXMMwxgliRW42bMN8X28Mc0o=;
 b=Bjzu/hGrRij+lEqSxtK4zoZaft6i1G9a750ShjawAe0U+EFT804nU3h6Y7bS1EfU6QOhuCqg8ujuibRcBT1FvFQEmfv9tCg7cf9NoPgtuLxvkt8HwygcSknE0kM7E7mvQucQMKoX99/FpZxWNrDQQkf4R44N1zviGW4SmTvv+L0=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4308.namprd10.prod.outlook.com (2603:10b6:a03:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 18:45:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 18:45:39 +0000
Subject: Re: [PATCH 12/13] target, vhost-scsi: don't switch cpus on completion
From:   Mike Christie <michael.christie@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-13-michael.christie@oracle.com>
 <20210210084415.GF2045726@infradead.org>
 <98188084-c6ca-4f02-871e-176790b5da14@oracle.com>
Message-ID: <dd18c453-8910-6eb4-6b1c-fb4eb4d9d5c8@oracle.com>
Date:   Wed, 10 Feb 2021 12:45:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <98188084-c6ca-4f02-871e-176790b5da14@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:610:b1::14) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR13CA0009.namprd13.prod.outlook.com (2603:10b6:610:b1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.20 via Frontend Transport; Wed, 10 Feb 2021 18:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d26cb249-6730-4857-9f3f-08d8cdf40fb8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43089E93593AA516737EA620F18D9@BY5PR10MB4308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fF/GpGPNFQzbnFFj2t48ugnmV3SPqWkY4I24fk+wQaB3eHUyNqX0zp0P8j4or78f+aN4742hPRB8VFnHtFUFk72UT3NBZ+1eKnxmUEh3zT2CvnLtxeSAT78DOk6E8dyD9xhhuqqR8tW86eOF+8MPSTrdzOrpjuaFebkRY6BxV4pl/517LRNtvwDoHtTGVDC7/6hlBkmn2crZCCTTUA0FRD67xYkAHQahUgXrdUQ1wlYDLpq0I9M7GPeQlt3y4xhPxkuOOM274XOkiLZwnJCR8gMMaIghaqVeEPiErUGS9Su+AwhbnpflRsOpVymy5pAP5NsuuoAhgAtUoFC+9ch7rMO4j4vt9p+agxXS0LDhCiJ7bNyK9nkzBX1DSCdE1hAAuvQyR31Vb4sfuMiFVrR/0+cSxyl2XcgNItxdlurtpD9f13PaVSrFFFR8QTjgTR/u72yLr7jL6S3QFQ227qrHCZh+WFzMSDfCZueQQJxGPEGPk1ivW0HzR7NoT/9rEXtWVpwSxzxieamd35pQEANvM2lykQycOUGvl6Y3Rj8ggCmR1myQr1yMNipoTR00e5araWqE0UFm+iuKddYZU3SyMsCy1CHASUA+fplBU7j2/kVh6cHQSfuxPkDMn0FCs5Xh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(6916009)(53546011)(316002)(66946007)(66476007)(5660300002)(31686004)(478600001)(66556008)(6706004)(8936002)(16576012)(8676002)(16526019)(26005)(186003)(6486002)(86362001)(2906002)(2616005)(31696002)(956004)(4326008)(36756003)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RU1rYkFqNTArdUFLV1F5RlNnTlE4VFNvSkJLRzFBY1NFclNTajd3QlNhM0Jp?=
 =?utf-8?B?QjlHSkdJcWxLckRxdWFSMWRhZEtqY3Y3a2dIbEtVV3QxUENDenJTcUtFbmV0?=
 =?utf-8?B?VUlteFhVL1lZeTg5cndtRzRlTi8vdUpVSnpDT0NUK0NGdFVLUmE0N3N6Q1k2?=
 =?utf-8?B?SW1rN2tlSDBQd04zcXFGSWlqeitnSEY4U1JDVktQc2VDS21BVHJaNU1UeldR?=
 =?utf-8?B?VERxRFMrL3c0R1VlVThaWnA3bTFVY3NIQlFZTk5RbGg2NEd3UU1tZ3J3c01Q?=
 =?utf-8?B?NDY2bGVXbTgrRlloRXlEVW14cmlQQkNiV2REclJYWXo3WGwxbmpkVGZUVnhM?=
 =?utf-8?B?dHZjWUJXemRjcklWbFNicm4rVmg1a3NtNWQ1TkRZRDdveGFsNURESnhKR2NN?=
 =?utf-8?B?NnZ0TVA1UUpkTEdnRHFsTEZEQmg2MWdtbnI3Z2FURUN1RTRqdUZHN3lkaFh5?=
 =?utf-8?B?R215YmIrb3pGZVo1c3R0eDBIWHhLOEY1MVZHQWlaZDRjSWUrZ1p1dCtFMWFy?=
 =?utf-8?B?T2M5c2RiZU1UaXdQSzJrMmdEK2lHd2hCcXhjR1JlSUZlU1J0S2tsMkdBcXRV?=
 =?utf-8?B?dTFYMkJIcm5ILytJbThMdXFWQlZwZUVVZVFuSUVNTGh0Q0RHWFlzT09CRDd3?=
 =?utf-8?B?SzBIT3BheEJIWFp4ZThVTTFDVklMTUpmbW10cnJiUkY3YmQyUWQ5TmlRNEw3?=
 =?utf-8?B?bTV1Nm0zVGFjL3dvSk1KbVc3MmlmbVlzaHlXaURTOVN2R0ZqajlhV0VoV0pV?=
 =?utf-8?B?S0FWNjdtMUx1RnVmVndBU1pOalZOL01wTWZuWVZzd0lkUW4vbDM0ZmFMeGlJ?=
 =?utf-8?B?VE9ZRTNwTkhIbUdKdVJBd2FNRHlhVGZVVnA2OWo2VktBNW13MlpBbXFOY2ZD?=
 =?utf-8?B?em5PUU0zRlhLdzRrZGpjVmx6OUVyQUpEM0FOR2hNcjVURlpVNWFWcU41Lzhl?=
 =?utf-8?B?dVU5UVF4dnBURitUVnlpb0UzTnhkSThuZkZGMjRsdGd1UnhxK3VBQm5PcFE0?=
 =?utf-8?B?a094dDRWTmhaNFNFWUh1VFhoVFB4bG9wTHN1M1JtSTNZdDJCS3EwRXJscXQ1?=
 =?utf-8?B?VUNLM1lXUGh5STRlNDBoeGRtRFZUTWVLS0tpVk9odWwrakx0Mm1WR2dVN29X?=
 =?utf-8?B?ZUlpcTVzSFRYNjlKVHlJcWpxbjkveURjR0EzWVExNUVWMHRZejNGenBHaUNw?=
 =?utf-8?B?clI2TmxRZHZwRk84NlBBYUlBbGphV3c0QnkvdCtJdmxUKzU2MjlMZzdmeHBG?=
 =?utf-8?B?dGFvdkptV2VuK3FLZUJJRXY5d1hhNlRVVFRGUlZ1VzhtLzM0bEhCYlBtMFpa?=
 =?utf-8?B?SUVVOTJYUHFnQUs2OWdTdEtQeldubmFiZng0M0t0VTVYa05nNGNITkxaYWVL?=
 =?utf-8?B?WnJ2eHdHYXk1ZVBqUDVpVFpxV3ZoeGxEMkZUV1h4ZS83Q0Z5MHFvTEVNMTBa?=
 =?utf-8?B?M3JUZEt0dFk4VXY5TURsTlBwbGdPVStQcnB5bWdzNGR0S1RlSEcxQXZHbGw4?=
 =?utf-8?B?UTJVc3VtZnN4T1l5djlnUCs3TEZoOUVwN09ndHRQdkIyV0NYUDZqbXpmcGtY?=
 =?utf-8?B?QzB5RWZqRnBKc0V4bWI2OW5BU3l5UWZnZEowdks3NlFWMTFZMjJvRm1UbURC?=
 =?utf-8?B?NkpvN3N1SHFsenpWUUVFdFZUTjZuSzloMTdTYmlBeUNUb2prOE1mRXhLenRn?=
 =?utf-8?B?ZWt0cVZTVm5leHp0dXR6aWw1eCtqTGFyZnhWdTMrcHZaSDVMb3JkejhOVWto?=
 =?utf-8?Q?mN+N+y6EhwriOamVWKUSZIlgpMA8gyO+hGYvA0j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26cb249-6730-4857-9f3f-08d8cdf40fb8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 18:45:39.4326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jCEjRUpnH8ztYq+oG1r/T0sAPFAsc58ERs/7B9P/lpUHZoAjfhnv9rFlLhVv9RDAEsGyLkPS+7/eGFG+RD0nSPr6he/eMjWk3NWzOcYnNJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4308
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100167
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/21 12:43 PM, Mike Christie wrote:
> On 2/10/21 2:44 AM, Christoph Hellwig wrote:
>>>  	struct se_device *se_dev = se_cmd->se_dev;
>>> -	int cpu = se_cmd->cpuid;
>>> +	int cpu;
>>> +
>>> +	if (se_cmd->se_cmd_flags & SCF_IGNORE_CPUID_COMPL)
>>> +		cpu = smp_processor_id();
>>> +	else
>>> +		cpu = se_cmd->cpuid;
>>>  
>>>  	target_queue_cmd_work(&se_dev->queues[cpu].cq, se_cmd, cpu,
>>>  			      target_completion_wq);
>>
>> Can't we just use se_cmd->cpuid == WORK_CPU_UNBOUND as the no affinity
>> indicator, which would remove all branches here.
> 
> We can't right now because the workqueue_struct does
> not have the WQ_UNBOUND bit set. __queue_work will then do:
> 
>         /* pwq which will be used unless @work is executing elsewhere */
>         if (wq->flags & WQ_UNBOUND) {
>                 if (req_cpu == WORK_CPU_UNBOUND)
>                         cpu = wq_select_unbound_cpu(raw_smp_processor_id());
>                 pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
>         } else {
>                 if (req_cpu == WORK_CPU_UNBOUND)
>                         cpu = raw_smp_processor_id();
>                 pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
>         }
> 
> so even if you pass in WORK_CPU_UNBOUND, it will do raw_smp_processor_id
> and add the work to the cpu's worker pool.

Nevermind. What I wrote is exactly what you asked for :) I can do that.
