Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75E7FA3741
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiJ0RNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiJ0RNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:13:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D557D1A2E35;
        Thu, 27 Oct 2022 10:13:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGDdgX026506;
        Thu, 27 Oct 2022 17:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CFlfL/HuobtmmC5JekCvLmLq8DnXp3Sh8wudYB82JbE=;
 b=Il9FbD4tEp49Wk3uHYuSUnOQ8OHOJoSYNeKFPx8ZS+GQ9lPM/SkyCNaUOCyskj4zld/+
 IcAGxuL2bP2jS8tFEOl/3YQoL4r0Lqi0HoRaoHZpny3rVuyrzViLPjqN85ixNqrgYR6k
 rxz2yU2JB2FywS428iuSL6ZQc2bH0igaBC3grIjV3XlwSVOkw8PuN41KJWyGf7c3fVEq
 +4Q/Cyohh+4Xfka3obNfqsKVeRhyNyGRtNQaTCpv2vkypCY92BqNzNJO6Ks3N8sWBxsm
 4SlnyDRy3JGv5HqaaYnitUbUfpRsawnCtWQ9Hz32NSxKSZqCalCxGYbV55zccdpM0O37 RQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfawrtrwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 17:13:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RExqfN033387;
        Thu, 27 Oct 2022 17:13:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagn71mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 17:13:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPMwYOvKMooAfSxwhZ6683ODdDAVtNv3jVfx3m5CUjXD4FPXSG471uQJzC1OTCq7I9ZUazwpAlm1aasjZ361lp6/GVgZnXl05s1URUqGMfO4uksvIpnlwW0BQm/aGrOYpSL3qww0+ZToL03fVzlUfqorql4cEJVF9cOxaHfNyWy5XBmSbldQ/RItJ9k2bIUj58Taz06dVmvIs2PWJOgCuj/lhAoxeqwypn8jD5iog7DkvAv79kp+q5D1ttLECY/QwuYmpZX9N8mf+BeFalptIl2xVvLTyVts5eVtuPoDPupYB/Ll6ciYDDD/HVxYiyDMM6y2gmw7LaGvD4U8MjnqWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFlfL/HuobtmmC5JekCvLmLq8DnXp3Sh8wudYB82JbE=;
 b=QEHzmdGsX1RphvnTXJ7VQREGyBy0R4D9m4tQIPChp1zfdDx2OIKZT6jZDQxJ3y2LyrR9fMY+6WdkLerfrYuRRCBy/Qf1Na8des+NGnTyiiUv98YfzFy7Xi5fqhEsSZaw9X3tSE2KhhGaXv4MyPqpEpezAVvupDnhhoGPEDowLMjzf8aw1ZHOGBiSuyCirK8SvjPPg87SuxJIKeiiC5pyTSWIug2+qJ2DIrK7mbpfbqfla6qbwIDbpU7lKmkbDRUfRXHPfuEMmto4oZA1IUKbR/KV3qME0PfewS+2b2VpZewSbzPVN9bajqMTkyZSpRonsvp7FgJVuASM7YMIMqqGVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFlfL/HuobtmmC5JekCvLmLq8DnXp3Sh8wudYB82JbE=;
 b=jaVwniXlJbElYTBr03LK4ph0+FbwcBf07F4yBtC0JOiYkmiBH/jXfHNlk+V0ipwihkUWSXdbwkkQHIpgE5poqsepCx0v/eDCnm0c0QT2fCAjCpP/K7A59jjQJFfSAiNtcNII4ZHI3kAmbsPSI59gMvF2MuEr2wTWWNrbTvp66FQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Thu, 27 Oct 2022 17:13:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 17:13:09 +0000
Message-ID: <75564e1d-3169-cd50-ea17-53ef96a3a35e@oracle.com>
Date:   Thu, 27 Oct 2022 12:13:06 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v3 10/19] nvme: Move NVMe and Block PR types to an array
Content-Language: en-US
From:   michael.christie@oracle.com
To:     Keith Busch <kbusch@kernel.org>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-11-michael.christie@oracle.com>
 <Y1qhXQYOpEUk2uqF@kbusch-mbp.dhcp.thefacebook.com>
 <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
In-Reply-To: <a74266ce-3839-5d2f-abc4-cb30045d811c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0046.namprd14.prod.outlook.com
 (2603:10b6:610:56::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d4b9e6-a502-4f4b-5254-08dab83e8533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rO7Ft28J9yi5yqwSOFtYxuc8Z5KLwj5deVmhQwIIngWERvbROHYME9IBZ/+nJQusLQzYBN2BnxPZtYE80G/8OfnPsZOU9bnFW0ya8RJJ/EINBPpANgRl5iBsTqocARiH5a+nYV8SpVuqXbcB+ahtkkUyzDqtpWjbpuf7/huzVWXkqwhMbKYxeLeG7/bZ9KGrwO+NQez2B7VkMojmLililo/wtaX98u6biUEPIaZcGDv30ZXwIz2zCY+jYOif0HmKnr+1RBXacXbuJAviKsF679vpvBclWpXBA7MWcEEIs8Y2JyM1xyjQy8OVO6ZweE49MLrDosVQUI5IfIbhOP6PauboJymJxOf7zqR7+GdJwoTQvUJGaQnO+LYQ0cG5Gq8bjDrIVco6zDG/jixFUHX4Zm5KdBZi5GafXF9KXM6R5VCLY8mEJ2S5pbKG1Oe0epqukoRhCD5wu2xNnT9WEGKdFrdu+Y40BR/jKlUUzm3/ImLCfRiOOkLCMTVz37BJYBB+//jtehscTZyDXJ1bSeAiUCym2fTCecyUdDgRPbOXdFXnyy0Z4t20+N4mAypNsDTgCBLi1fXJR57mwtZJBo+gcHHBwBfldAvFPJsuIKmuvGtoZKE7xYKwoBt+pVl30n8zg4tMwBvfV8dXFXoU8MRQSngD+DvW50fX9PYeIUPRtCe1paBpEmU1BDJD2YyjhMCK3MUjd7s6lhozc8mugH5scF6dX3bh2YWQQkb/s8toqzATSooqb29xS6x8KkGecgi9q1muyHtW54Uy6UZmSYQoTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(31686004)(6512007)(5660300002)(66946007)(8936002)(66476007)(66556008)(7416002)(31696002)(86362001)(83380400001)(6916009)(2616005)(26005)(9686003)(478600001)(8676002)(316002)(41300700001)(38100700002)(2906002)(36756003)(4326008)(186003)(6486002)(6666004)(6506007)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJobkMyTHRBYUVPTlJ4dVR1bzlQcEJWb2UyVkZJZEtJTDkzcUtDUVpRSHo1?=
 =?utf-8?B?cnNaZ0h0L2N2MnVwVmpVQnJhM1RwNEVmWHk4UlFGSkNPRVQzc3FsV2hNRHV1?=
 =?utf-8?B?WTlsVXVBbEJBZ2VDL0xFelIxbDA0dnlQdmFuSDJJTWpldlpNb3duckdwMEs5?=
 =?utf-8?B?UnFjY2Rzam5PSkVQQkRETDhEdXhCSTZMZEhqamlGcXk0OE9vYjRiYTVSV1M2?=
 =?utf-8?B?ajkyT2tWVlJCZ0hoNFU4N0VzOUxhV21RWVNVaWprYXM1TFVLNHc4VzhiK3NL?=
 =?utf-8?B?UXI5UVkrQVlka0VDQ3JjUlAxRkFmOXQzSmpJelhpSG5yZzVjbUJVOU0vMWF4?=
 =?utf-8?B?QXI5aHdPZU53WnFBY2tKMGhpYzJUVnp6SUtJWHF0UVJVd2pnVGp6c2pkWW1F?=
 =?utf-8?B?VEtDM2o5THdwOUt1UFB4dm1DQU1YdldGbytDMnNweW4yaDUrWGwxSkxicU1F?=
 =?utf-8?B?SjVhUTRHS210L1hPbWRlZ1l6RFBIM2tFNzBHTi9jWmYwZW05WXc4RVdQSWt5?=
 =?utf-8?B?Zk9pcy8wVGh0YllZcy9iL3JMR0FVeE5LUW8xSS9IcDVFT0cwajBpWXhWaFp0?=
 =?utf-8?B?Y2ZpQWVhOVoxdHJzNHBCVTRSLzhML0VRZUZhRzBnQVZGbnJnYmw5OUxtRldw?=
 =?utf-8?B?YURMOGxsQ3grNXVMN05YQ0Mvbzdra0dVMkNkSTJqdi96VnNkMmQzNWNtOHk1?=
 =?utf-8?B?ODN3UjlrU3FXUEY4bkFud0Jpc2JSTFFjd2VtVGZIRDBwZ3drQ1VQb2xDaGdm?=
 =?utf-8?B?QnBGSkp5NGhDaTIza1JPTzBybXhqU241ODUxd1NsTWpsN1ZuWkJHRVNOQ1JS?=
 =?utf-8?B?bUxtZ2x0QUFEMVB0Wlhmc2g1WDFBbjA3NE5vanRXNWJvRlNXSDQxVGNySjdl?=
 =?utf-8?B?b2Z1elhpYkJ0VzZlSDJVUm0rRGNCc0dOeTRkeTVGc0hYZkdjeWl4aEZGcmFt?=
 =?utf-8?B?R3g4YlEzcFpFdGZhQjRMMlhyS3lqRjJ2SFh5WEZsZysxSytXeFcxeTgyNXhs?=
 =?utf-8?B?S084V3FPU0pYOGVwU3AvVzhXL3JMdUYvRmhFb240U1J4NDIwUGMzRTJib0xI?=
 =?utf-8?B?SExwZ2tlaEdUeWtuU05iWlpmVUNaVGdSY0h0ZWVvQ05HQVlkMFQ0bFpUbWNv?=
 =?utf-8?B?NGl5RDBvcmZsd0N4S25MbE1lKzkzMlp3bDU1UDljV3FqR1Jub08xRGFsTy9W?=
 =?utf-8?B?MmkrQjdwVitXM056dUk3dlBKRkZaNS84MkF0VEdxNkxYQXdVM01RSnpNM2p3?=
 =?utf-8?B?dU4wVGxDV01ldHpLUHdsMEhzVWVRK0RzUjl2bWEwdE5raVQwS1l5b1U0a011?=
 =?utf-8?B?Q29TMW4vME5MUEx1d0RnbHNJOExRUVh0dUk0MVNVQ2JwZXlJblkvMmluMjNt?=
 =?utf-8?B?QnkzYXZpMjh6MmJ2U0w5NkdRQUJQaDlrWHRhbnZQR296ZVlSeXNscERIdzY1?=
 =?utf-8?B?c3NIY1p3ZG1kNGFTcy9PQkpjZGdOK1lZZk03eG1Oa3I1cUJYcWZJOTZDU25q?=
 =?utf-8?B?Nzk4TG1Lc3NxZjNENE9uVExndXhWbXhPa244R2crZnNHQnBlRHZMZWI5R243?=
 =?utf-8?B?azlwUTJnZVVOS2NkdVlnSWZ5L2M2akZVOHNmQVpOc3BQYUY0OW5MSTZvampl?=
 =?utf-8?B?dUxtSko4ZzV1cGp4MlU0Z3hBN24xTi8zampyTm1BaTZOYko2K2cza0J5QThZ?=
 =?utf-8?B?VzlVSy9MdHllZ3pCMTlWTUxpbVV0ZVBzMXp0aEJmSm1FR3ZIREMwbU82S3Fj?=
 =?utf-8?B?ZnUrL2dlYW8xVEJEdFRiRWZWSUxHUTFoQTFYa2dBcHVFY3hNZXpTYlpmNU5k?=
 =?utf-8?B?TmI2NW11RTU2dXliL0JDVlNEVzNHa25RcDl3dFF4SkxwajFTYmdlTmxiczNM?=
 =?utf-8?B?cUg2SkYvZm5TblFzdi9CRnJoWjNONDNBV3B0djM5RkkvZmFNODhEcXoxa0Jo?=
 =?utf-8?B?T1BuYTNwQS9nUEtCRmV5czZvclBQUTAwY3d2VWtMNjA3dHNTOVNwODgwS21O?=
 =?utf-8?B?Ti9QNm9iNlhIc0NjL0lYNTRiaVh4K0MzQnpRZ2R3cEFuQ1lROTBkQkppQW8v?=
 =?utf-8?B?UFRQY2o3NnFScFJzcTgvbytaZzJ2c21qNHJMOWpmT1R4U2E0VTQ1b2VZdDdz?=
 =?utf-8?B?cHpsN3NlYkxTYTgzb0RsYWNGdjhXa1FtNHIyNzVwMVdaWVkzT1BQZHQ3SzF6?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d4b9e6-a502-4f4b-5254-08dab83e8533
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 17:13:09.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpFZcKqtdxujhUHxTTtsa/ab2bAXMwwLKqUxV0bGYjDMqAxjetuDNIbHh6QYWMp7gM4BZVVNKaYNjNgvxreheVybDtywd37NG6LA7XoH6xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270096
X-Proofpoint-ORIG-GUID: rDf-ucVrUMDIN176zHZGTlalFUhWoEq_
X-Proofpoint-GUID: rDf-ucVrUMDIN176zHZGTlalFUhWoEq_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/22 12:06 PM, Mike Christie wrote:
> On 10/27/22 10:18 AM, Keith Busch wrote:
>> On Wed, Oct 26, 2022 at 06:19:36PM -0500, Mike Christie wrote:
>>> For Reservation Report support we need to also convert from the NVMe spec
>>> PR type back to the block PR definition. This moves us to an array, so in
>>> the next patch we can add another helper to do the conversion without
>>> having to manage 2 switches.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>  drivers/nvme/host/pr.c | 42 +++++++++++++++++++++++-------------------
>>>  include/linux/nvme.h   |  9 +++++++++
>>>  2 files changed, 32 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
>>> index df7eb2440c67..5c4611d15d9c 100644
>>> --- a/drivers/nvme/host/pr.c
>>> +++ b/drivers/nvme/host/pr.c
>>> @@ -6,24 +6,28 @@
>>>  
>>>  #include "nvme.h"
>>>  
>>> -static char nvme_pr_type(enum pr_type type)
>>> +static const struct {
>>> +	enum nvme_pr_type	nvme_type;
>>> +	enum pr_type		blk_type;
>>> +} nvme_pr_types[] = {
>>> +	{ NVME_PR_WRITE_EXCLUSIVE, PR_WRITE_EXCLUSIVE },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS, PR_EXCLUSIVE_ACCESS },
>>> +	{ NVME_PR_WRITE_EXCLUSIVE_REG_ONLY, PR_WRITE_EXCLUSIVE_REG_ONLY },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY, PR_EXCLUSIVE_ACCESS_REG_ONLY },
>>> +	{ NVME_PR_WRITE_EXCLUSIVE_ALL_REGS, PR_WRITE_EXCLUSIVE_ALL_REGS },
>>> +	{ NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS, PR_EXCLUSIVE_ACCESS_ALL_REGS },
>>> +};
>>
>> Wouldn't it be easier to use the block type as the array index to avoid
>> the whole looped lookup?
>>
>>   enum nvme_pr_type types[] = {
>> 	.PR_WRITE_EXCLUSIVE = NVME_PR_WRITE_EXCLUSIVE,
>> 	.PR_EXCLUSIVE_ACCESS  = NVME_PR_EXCLUSIVE_ACCESS,
>>         ...
>>   };
> 
> It would be. However,
> 
> 1. I wasn't sure how future proof we wanted it and I might have
> misinterpreted Chaitanya's original review comment. The part of
> the comment about handling "every new nvme_type" made me think that
> we were worried there would be new types in the future. So I thought
> we wanted it to be really generic and be able to handle cases where
> the values could be funky like -1 in the future.
> 
> 2. I also need to go from NVME_PR type to PR type, so we need a
> second array. So we can either have 2 arrays or 1 array and 2
> loops (the next patch in this set added the second loop).
> If we don't care about #1 then I can I see 2 arrays is nicer.

Oh wait there was also a

3. The pr_types come from userspace so if it passes us 10
and we just do:

types[pr_type]

then we would crash due an out of bounds error.

Similarly I thought there could be a bad target that does the
same thing.
