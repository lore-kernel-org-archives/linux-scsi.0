Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EC7C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD9564E77
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhBSTCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:02:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37182 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBSTB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:01:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JJ1E5w143169;
        Fri, 19 Feb 2021 19:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xZIwnYM7X/YzffKoWPeJNObmOuBqbzkUfZAG9O8yogA=;
 b=rbNchSZgTvQ28MZA8cz8xZzvxY/jbUZDACZ54bxe47HxXCmOXOQbxvjNddT1bvhDXfoI
 l8JcmQCQnRkjkNiICtT5KGy3fNJkd0YUl3dkR8qzGmXbw7xtiVN13KwIYKDgHz+yayzp
 /WZnjvySYdueVlopK5hP98p/ZI7mMUYsi4LLuBGmETsCuBSNJTohhRV+E/28gIcvMlDk
 lPobjmkHAp+WqpIiaPJ9XX6gBFc0PYQUOXaXPVZ0AmmtkYP512UG6cZDsmR25TWqiGuq
 Mt16y3HCT6TKrBKnhOfCOHlL5o2cbMW9MQkXLO9DhYItPhcfxJxMpURkkzaNwPYBqfDc tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bjnmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:01:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JJ0NGN040798;
        Fri, 19 Feb 2021 19:01:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 36prp37had-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:01:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdL8KPSvZxRioB4EzBnGkAqd5WVIQxmaPIgmPZEsi+FmNpN8JxKeBkaZ+k9BCJLH/hHDSEQyu2lliKJCNpnZ1nrR6QbksMdfIqNzseYUzVZiHpaeShPX0LofjuWzxwwEMM6dU4O/DjrHO/5eg4QkZCToK1THD9W5UDbCr5pOTaYJNvTFLgeCwgXPZSVlR2+N1YUCx+eAqgu4yNgtRKeed1vJQr8YCMyr9kbnzIkDhbibyL9528DmhNWhHk2FMu4iRtMPgxH4Wog91FW7qXFtYD2KjAGVC0no6pw1xef0oJqxeF6o1/sU+PaSeIGpB6pVpERLpkLD53D3PL3SazsK9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZIwnYM7X/YzffKoWPeJNObmOuBqbzkUfZAG9O8yogA=;
 b=MG//ZNtuoOEBzAFsEcGtNmz+C/bC+AHV2+16AZ1zDZyz7CG8jVMHyOhIcUwdPqcy6Bx7JQUUTVBtLpcV0U0kayxCIGnZJt22ijFxaLV3xrX51c3OEawfQnsCIVobkRKWTtDEtYi+TxnsumWzKAqqgE+LO+mZgkEV/N4jf+psZxjk5CYHqsoBXpgnglY8UM5GYUARH5vsOMqHgbOM5Kx9hWrZTPAMIyodN0kuN/U5fm/VcQYPM45P6Xen78osEhI9IMwUi12w9ktXWbuTqTagw4v1DFJHOZlVmO802FM1t6jeYgX8oAPdD2MPHlxSGRHkDfWqWGz1E+Sbke6hMOIIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZIwnYM7X/YzffKoWPeJNObmOuBqbzkUfZAG9O8yogA=;
 b=J3SmemQ9rjcKPwqpP7i6TMr9X4daC09kYpaIvjGxtt1MKG4cluIndO77Vy6GA6QmYyVpL0v9Apz+4n5d0uHdPl8kxpZ4VH2ZXdEl7fBnxwXK0zsky8mOmxWbL9XjPCl9CJivGopvdyEo6DJYviCQ9F+vDqDjraSx+D55hH2WviQ=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4543.namprd10.prod.outlook.com (2603:10b6:a03:2d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 19 Feb
 2021 19:01:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 19:01:12 +0000
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Fix memory leak
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210218175039.7829-1-bostroesser@gmail.com>
From:   michael.christie@oracle.com
Message-ID: <b6f76acd-24f2-26b2-02a4-48b9225997f7@oracle.com>
Date:   Fri, 19 Feb 2021 13:01:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210218175039.7829-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:610:e7::8) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.12] (73.88.28.6) by CH0PR03CA0213.namprd03.prod.outlook.com (2603:10b6:610:e7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 19:01:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c62c539-2ff6-4524-ff3c-08d8d508b979
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4543ABD5ACCE86203513690CF1849@SJ0PR10MB4543.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KVgl7d12fqlgBeXHIj5bircQVuQ0ZcSqwm1R70Dp+fQlNHoaSdaCjVnYIRnMUf2F+mPgRoiLLJ8CTssqGcdD23FbIdQ2c8heqikzMbTassl66O1EzlUCyx5XRXNi7r+eiIjVIErMacz6jD3HIiDB2t7BDY320N46xPYL9zE2QT08mUDbCNzVuECByQ4ER9aJwbjJnmUE2WWzYpKKvD/fZStoQUfOl6cqYkOQpM7VXUUeCSFjyB7wH4Ori8irpakWGb8/iFmbwgFG86polFUmY3UfUa3Bl6M+A706weQBPi5jTUVnrAUoRYFo7ErPuuwQOFef6TWhaVZf/tQJ/rpe4G34A7yhKNflgVqZzxNowvxxfvxrwsbaltHTpZRgoqog/RqYnHb7mwxw9JJBlRNlxtoEsRr/F2BxqTlmjNwMtNeOonYQQd89V2P1K+RzeXWXmQajkp6iZBf0UN26js7Ary1kaMRoDGa2qeuT6xKbcXzlnoxy5DyXxvqMsMa5iZuEGy1CwFdgkXycWd4JFHlM3fV3IW0G5BtoA7YlW/OgfJaj8ZpGCpIluJiZoxUvB0+e2vWjZrfyZGKPvC8B0stxjW9/OzS1SgGTIdhBMU8PgzsheFHKwiLGGliZF4BmJGDRBUnWUDeSJGfPh6ySJFRLzXs4eKcvmPTOwPRvuX0Vk9tb5zcjjCa90qxylSlmcLh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(376002)(396003)(36756003)(66556008)(8936002)(478600001)(66476007)(6706004)(6486002)(66946007)(2906002)(2616005)(86362001)(8676002)(26005)(53546011)(966005)(16576012)(31696002)(16526019)(5660300002)(316002)(9686003)(83380400001)(31686004)(956004)(110136005)(186003)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGRWNXhhM1BtR2x0VmswM0M1ZlZNZG9hN3dmQndwN3BKcmZMMkpFQm0velkr?=
 =?utf-8?B?cG5tclg1WGJZTjc1blB0WVRqbWdxNUhpS29acC9WYWVoQVpBYlNiLzBIRGlo?=
 =?utf-8?B?ZTF5Ulh3WmtMTkhkZllib0tOMlBaMzEza2ZIanIzVGsrU3dFQzZ1WTE2a1l3?=
 =?utf-8?B?dWhGR2VNZ2d6NUtzYWdFdUwvdXp1Yzd1ZFVEWHVRZC93MzNFdjlsSWZXYm1m?=
 =?utf-8?B?MDJrZjI4YnVPZk02b3M0RzFPTGFBajBucDhQMXFnbnhZZXZDSUhiSklTeWRx?=
 =?utf-8?B?ZzVKVnhqdll2RGVGQ0RFM2U1UjZDZkR0b1BGWE82VWtWMXUyUVQ5dWxKdVpr?=
 =?utf-8?B?MnVvT2tCYmh2UjdwN1dxalFLUDhHcG01ZFkwdUxIeXdKcndWblVNOHRTS1Bl?=
 =?utf-8?B?Y2JTbStxREEyVGNHcGxOVkU1ZmdXT1UwOGRxN1crMyt5NDZUS1E3bEt6TFVG?=
 =?utf-8?B?cWlPREU4eW9SM1RwbDB1aVgrRm1BaVFjTGhycHN4MFVFTDZqTkxwSDVyME5t?=
 =?utf-8?B?czNUc0hOY0dnREYvck5kK3l2RmJwaEZnbTZMRFNwVmVOQnNxdWRSRU54MDFD?=
 =?utf-8?B?dENCTW90Mk5HSWhTRllLVjdxUGtiN1RSWXFVVS9GMEpNR1IxM1FRQklybXl2?=
 =?utf-8?B?VWxPckt2MkZzZUJ0R3Ntek1Pb01nUWlvR0NOSTJIRTBJdkFCWUZHWW1ORHdu?=
 =?utf-8?B?ZG5sYmZCSUVvSEQ0NmttbU4wOUpGMDYydjZVWW55TlJ0YVpaWHk0MEhYWXRT?=
 =?utf-8?B?R2g4Q1BlK1VHMTlMbmNkTWtKUVcwOGlyNXhrbDJwTkNPMGtZM2NmZzNmM3BL?=
 =?utf-8?B?RUpKWWw5NHpETFR1M2NtL0NFQTMxeW1NT1gxRHZRcVh2NFVYL0VQc3hTUlJS?=
 =?utf-8?B?cXZ3TVN1UXUxVURUWFVmRlJ3Vk1Gai9laVIrNkhKWVFUY0gyZGVlZThPK0Jy?=
 =?utf-8?B?SFBFcXpybmpUaGhWbHg0RzVqQzR3UnFWM3ZNTGVPanBSTU9lSG1DWmpkV05J?=
 =?utf-8?B?SE10NW9pNGZSWGY5RG8zQ0UzZzJaUnBHTEF6OEJMUDFLelR2NVRzcUsxSTVW?=
 =?utf-8?B?WHFYdzJ5U1dZQnhWNE9mMDZJMXdqZG1vbFZqUkxtTU92eFFiTXBDOG5rV0ZM?=
 =?utf-8?B?SXNqUi90YVJuOTJ6UDJ1bGVqTWtKSXlzNi82VmNlelVVQ3pZUjArOVoxNjdv?=
 =?utf-8?B?THYwYWdxYTdoT000NFJmTWlJVE1pRFl1RTlxaWtJVjYxVHRNVlRObkt3L0JY?=
 =?utf-8?B?QnRJdnpUMWo4VFpOaUZqRm9TZkJqSndtTzVyREkydXBVekJmdU5xN0FnZytz?=
 =?utf-8?B?TkRvRWcwQXZyM0dJeWNMRFV6NmhtUEcva1B6VHhKUTFHZ2NrZWZOUDZTaGxW?=
 =?utf-8?B?YUgzRDIyTTlxSEkxZmVlZGpWRGFITkRCV3kxYU1sWnNyK2lLSjE0Y1Jvb1hk?=
 =?utf-8?B?YVZqUE5pNnZIVjhnUjlwTWtsV2FzOWxTUGx5TFpxbXhlTFcvYWVrK0ovbFcx?=
 =?utf-8?B?anJieWxrMjlrMFlvdWJmakZZTWtzMDZTd09vbVBOZmV6c0JCWXNOSU9YRGRt?=
 =?utf-8?B?MlAwdkRVZmJDZWl1UU1Ib3UwelBMa21zcG1tVS9ndGc5ekprcmdLKzV4VFZt?=
 =?utf-8?B?UXI4T2VhL0lJMy9MSnlXbWkvM1F2MmJ0QXR3ZUdKY29nNmVsTzUyaExwdzk2?=
 =?utf-8?B?Y3VqUGliTmFVR09xdWpEU20wTEw2L0JjQTBjRDZxZTNnK3JrU1JzUEQ3OHBS?=
 =?utf-8?Q?U2NpDB5z+Rs9EyIkw34i+cv0tD3hkqk8QxIEZsG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c62c539-2ff6-4524-ff3c-08d8d508b979
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 19:01:12.3108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRZKQza1XiRjQwLr+HmbsuJeFWjg3A9Q2kPoYeAcARaXaNBzYMgof/NE9ztPbdufcybIKXgu2/cLObOCLklsTOO8rpg8AvHEcJn+9Wkkjcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4543
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/21 11:50 AM, Bodo Stroesser wrote:
> This small series applies to Martin's for-next.
> 
> This is the third attempt to fix a severe memory leak in tcmu.
> Previous patches:
>   https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20201218141534.9918-1-bostroesser@gmail.com/__;!!GqivPVa7Brio!Oz9qazrvG2YRDRkm5ey3KEvdVmuukGz523-nIrg5dvnwt1bKlOAjBmh4g8ADxdmcca5_$ 
>   and
>   https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20210210194031.7422-1-bostroesser@gmail.com/__;!!GqivPVa7Brio!Oz9qazrvG2YRDRkm5ey3KEvdVmuukGz523-nIrg5dvnwt1bKlOAjBmh4g8ADxY8eTeL_$ 
> 
> Tcmu's refcounting relies on tcmu_open and tcmu_release being
> called symmetrically by uio. But that is not true if userspace
> daemon holds the uio device open or mmap'ed while tcmu calls
> uio_unregister device. So refcount can stay above 0 for ever,
> which means that tcmu does not free resources of a tcmu device.
> In extreme cases the amount of memory leaked can be > 1 GB for
> a single destroyed tcmu device.
> 
> This new patch series fixes the problem by moving refcounting from
> tcmu_open/tcmu_release to new vm_operations_struct::open/*::close
> handlers, which are called under all conditions.
> 
> Bodo Stroesser (2):
>   scsi: target: tcmu: Move some functions without code change
>   scsi: target: tcmu: Fix memory leak caused by wrong uio usage
> 
>  drivers/target/target_core_user.c | 189 +++++++++++++++++++++-----------------
>  1 file changed, 106 insertions(+), 83 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
