Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2ABC2B9F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36152611CE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhEXP2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 11:28:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58488 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhEXP1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 11:27:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OF8qkw170062;
        Mon, 24 May 2021 15:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hglqfDCnpLBfA4KBOBFMHqutJ5wVOLyt3kfT+nTLaZc=;
 b=hX8HW7xnS0SvV7NMDMOp9bhyNfy1EWdnT8agR8a35xbJSv1NA1kOdXSB6DFf8Z55swyD
 kaAooQLbDJiJgOpRplZulRLQ2mVmCms3LSFuQKys3lxz7WipHJKDdfnc1CW/l5tMACDd
 xQEke2sbaJDp2AbQcDEXMBF+Lu0M/aRfUtqe3uEsNpfwX7/vXcErmSnPM6bntzkIhm4C
 LWb/FFy4zvtZENCloO9RMmsmX9SWO40x8BihrIViGSRvFJLMCEXcjqrCyvGNE3xxOdYj
 vaWVgd/5dOK7dnDKYRM46qAIFhsJnROrd/xavf44wg9g149Vttg8MYg1nPHbDOcnrrWz iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcbf8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OFBwB3143952;
        Mon, 24 May 2021 15:25:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 38pr0b3hf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZhyiYZs3T+Eg1UvrkxrYB+7qycR2lW9t0qbtGBJuro27LpI/cEVr9kRn8xCfOGs1oy+OssKfJlYLo66dyLfr/dwdgSV1c1xF7i4xjCfoLC6P6mJjTmwiJxq3EYb8U3+sqKf6fwU7TZIeBEEj9tKMPySFxAS5/Xa0vAPOaQI8hGDrIiiB4gVEactne6gKPj5zGj08T5ChpyM3Xr0c6DVmIMSZ3OEaGK4gy2SNlJU3wArJJ3+mKrMnr623r3ca7qOYta+KGz16kYh4eqZzZCmIlmS75dX7cEgVtKtTTbXeCVQHs2zULMb9tmXTxlpgWblv38tuE3DA3ScQOG23dN/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hglqfDCnpLBfA4KBOBFMHqutJ5wVOLyt3kfT+nTLaZc=;
 b=BAIxaSAdbSlYSkQlyEFJM7xEePvcOUTxUp6CiNs8E5T9UOZ8UqQ4eMdWB2STZKkOAFibRnk0t8yYm4NFiXIUgnPp3nckJNjCrNi8XTDSHvHflN50jtPhjzVKQ5Thz6uoOo9A9DtglW2Uziovbn7xa5jqdeTkBUiTWrFUEAzqVtEH8Brq16ryj+ZbZaTRckK17OGNjeRNZLejzZwdirJLjxIa6Y2YrcUNoiQy4V2VcfDrbalzrKdEL+7wr1rBXf8MCQcA3DWAYkIUI8a2Eauvz0EotOrMkd/wQkpmIPeTbHuUNjncoK712USwLaRsRuXGwWWV2BQVh+cKPCjA6+VX5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hglqfDCnpLBfA4KBOBFMHqutJ5wVOLyt3kfT+nTLaZc=;
 b=RxfmTMRf0QZTpeRo7iz44ttOqCCd+wkMfhnzx/Go7aQQfW8U8MnV8gS0yDpcJK3HxakolTurl+LanaiZnk26EzaD7SFnECnMEbVGRmxtFWC+JWjc2r5WS8hNN+TvixWu8aCgZ8WWdtdNzGDakMTLPzzcf3NKNcABL838vYPq/W4=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 15:25:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 15:25:27 +0000
Subject: Re: [PATCH v3 1/3] libsas: Introduce more SAM status code aliases in
 enum exec_status
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tom Rix <trix@redhat.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        Jolly Shah <jollys@google.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
References: <20210524025457.11299-1-bvanassche@acm.org>
 <20210524025457.11299-2-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <1b972359-a16e-d146-7a29-6f2609fb19f7@oracle.com>
Date:   Mon, 24 May 2021 10:25:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210524025457.11299-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::1c]
X-ClientProxiedBy: BYAPR01CA0033.prod.exchangelabs.com (2603:10b6:a02:80::46)
 To SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:91:8000::ab8] (2606:b400:8004:44::1c) by BYAPR01CA0033.prod.exchangelabs.com (2603:10b6:a02:80::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Mon, 24 May 2021 15:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 055ffe29-3743-4df1-1892-08d91ec82896
X-MS-TrafficTypeDiagnostic: SN6PR10MB2573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB25731CB2DE177F402F98BCFBE6269@SN6PR10MB2573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgA9cEkPJCVXMvzCqrZkUMfw8g2sm/bKOdf2Z0kbWE5m65fGE9VqTnojf1cGJDd7TXCxfEKnOba3P7+R7LTq4/cEVLbYf0NcZ7xfi/C45YdFQ7TuZQzuiKaf6DpaWZfFX1o/v/z2XsrtG74kjls8WPBIA4t1nainvHHYlOfZo23kiSjF4r+zH91Ls4Bx8ccVwa5a/mVrChdKpSkwjTToO3QpXFR0hyJ0RVKynhqVHlwSvy2bCaexyxAHA1e9shHGmaPWGLzxKJjyXE9dfmS1A6uGQU0r3/negfFdTiUyi0XjJuYPuQLboxZZJAy52rj5L6dNXvubhayu18zsE0yXCWGjeSTn+Gq9quzF8MhDiedJW/vvfM+ih24s4H+y/jxV/3CXiEEsh+XN+IAUT8zrQngd4w3goRu2pItL9rZosSH46L4PMvwXYGRrkluoBs4xPaM5k+pD2j0T8j1VXedJ0IQzOAWzLqT+i6FQmJ54rdbtkzfOnINJPRhQIHHy1HSWydkeTLk/OISThZno6ZCJdMu+K24vYH40fhdvK4eSZYBSCmzvCcAleQaBFz2yPUsxspbowxfUpWQeYsCoQBSOz7nqLOLTwfD7L/XBe4LCXAppCqXaj0VgGRM861Dnpr+VI0NmoBHi/ZdslRc17v4XTQZeIaEqTdasLG4Z/TaAGc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(53546011)(83380400001)(8936002)(4326008)(54906003)(186003)(66556008)(110136005)(6486002)(478600001)(8676002)(36916002)(316002)(31696002)(5660300002)(86362001)(6636002)(66476007)(66946007)(16526019)(7416002)(38100700002)(36756003)(2616005)(30864003)(44832011)(31686004)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0F2Y2s1blo5bElYNWNMMHg0SUpHTmd3dTBtK1NwN2dNU1lIS2hKSzUxclhL?=
 =?utf-8?B?ZHJ6Z0lJQ1Vad0prbVNoTUZ4NmtEQU9JRXhTcURxS3pNWXB4YWRSNW9IcXI0?=
 =?utf-8?B?eVpxMXJVVnhwa1BPNVlIbkZOckhlZ0hxK2Nmb2ZBcytid1FLUzVDaTNObitZ?=
 =?utf-8?B?OExuVzM1N0svdGtKaWtRS0hwRXJ4TmZEMDlxMTlFNHZScjBoTFJCSXFMblRE?=
 =?utf-8?B?dEVuZjY1d3FIUzlvOCszelFpTlYyWFFTRTl1MUZkbzY1dlgreEFkN1hJdVE3?=
 =?utf-8?B?ZE15aFlqSFVxTVIrVEZrNHZsWEVpWk1Cd1FKNUtGRWVzTDRLMHZWMFh6VjNG?=
 =?utf-8?B?TTMvc000U2JMUXVKRVpJbkJ3d2c5R3B3L216K2FGbGpYU2ppY2hWMDFJd04z?=
 =?utf-8?B?K3R1YkxCQ0tKd0VQZlgxczFjNlVka3FxUUJnVkdpbWVXMkhVUnl1ZHpFYWNm?=
 =?utf-8?B?aFZRc2RlQlgxNGw3QzdLT0lwT3o4K05nKzEwMmpVbmdYYkVJREtWSEIrMWx1?=
 =?utf-8?B?akt3WWV1RUxuWVRCcWtoTDJJMDlBU1pNTVI0RjRibkhwQ2NOcDBhcUh4VE1H?=
 =?utf-8?B?N0RWS3lmZW41UmJyZlZjK2lmaitqK1VValMvS2RRSlNWMTFSNWN5ZElSamZy?=
 =?utf-8?B?anB5VDlNdDRzdDMrWnhNdVdJdWo2OFpSNytTZWZQUk9rV3F3dWJQK25hVFBp?=
 =?utf-8?B?NjExd1BQYmwwcXR3NEI1VU5SSWRGcjdMQnZsdUlTODJKNkVuR0V6OExsN0l1?=
 =?utf-8?B?UExVZHRRSVQ5V0VUd1FxVk45cTZrTHRHWFdpTm0zTERoazcrV3FUZU9GQ0I5?=
 =?utf-8?B?WkRLYkxVUGhkNXoxSjU5cHJuMUF1ME1Mbm93ektlYWpEUmF2VWJtK3JWZEl0?=
 =?utf-8?B?dzdKeGwwcE5TM0QyUnJNMlhvaHIyWnZDQ0ZmcktZTkJyUlpTMHZLemlWT3RJ?=
 =?utf-8?B?cThXQUtuakdwVkV1RmU1eUgzck52UCtSVHNPTU5kZmxtZzNsRG5weXhveDBB?=
 =?utf-8?B?Um5sZi9RTS93dS9GYkxkcnZHMXBOZTRRNFFnb1UwWnQ5MU14TG1ZaFROUjRB?=
 =?utf-8?B?dmY3K3lkQkNDZHE0dEp0QjhWOUk0bk1vWHRHdHN3RUQrcjBNdDdUeThVYmoz?=
 =?utf-8?B?YmVIRVdzb2FOd2c5YnhXazcvWEI1SW1MMWwwY2x1TXRjeWJoTTdqaGRLUjFh?=
 =?utf-8?B?d0dKOHljYVRyZ3A3cTdwRXhya0oyakJDanVIZ1lMUXJQV2Q4VXluV2Y0Wkk5?=
 =?utf-8?B?K1NJa091R00zdS9iTE9zaWVTUmFiY3B4WnRpanlPdVJhaHI0QU1sUk9ZdzVK?=
 =?utf-8?B?M0ZVQitzOElMYnA3N3BPeXNseGtlWWhYclBmNUZtVjczMlRLanhmdXA4RlhK?=
 =?utf-8?B?QzVXK3VMa3pyRnZ4eXdkTXVGcmJRM3R4aW5Kb1J3WjVJcC9oS3JzWWdHb0Er?=
 =?utf-8?B?Ykc4YWxGdGY2MzQvYnFBUzRXRUNDeUVGNzFtQUgvbkVIV1RIdkI4OXVTbkk4?=
 =?utf-8?B?cWlCeGNlR0MzTzgxRnZmeFFhUDFEZmZCcnhTY0JCVWo3WXpaWG15WmxoSDlC?=
 =?utf-8?B?dGx6NEdGUWRSTWJNdDBLTlFhSyt5RXU3bjVwZEJqaEhXT1hrOHJ5ZG9HUU5z?=
 =?utf-8?B?L3E4VXlJSHdpWUp1bUNIN21TazB1NmJKQUUzZW9JNUdORmRzSm1LRWZTRWkv?=
 =?utf-8?B?cHhKcGhIcEZxcU5ybTMwZ0U1NXdjeFFxOUl6Nk5TSDFLMWJXclcwYkdvbzN5?=
 =?utf-8?B?VEpxbWYzUWVPMDJNREdXclNNaXhTV2ZRNTJIUU94TFprWTE2WW5FNGsySWhK?=
 =?utf-8?B?TEtiSi82eis0cWJ1am0rUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055ffe29-3743-4df1-1892-08d91ec82896
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 15:25:27.5402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgzzw92uM5ZvO5EmehzXlk67BRWqu1YDSNeZAe7FseaqQe+FG5pzU+/2TAvKTZw1k9SK4dYDhDEJQCI3WzGike4hJop7U2zNvGElnzOL0MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240094
X-Proofpoint-ORIG-GUID: M2EfeXVtZT6av8TLd1Ko-Pd2KxGo-xxt
X-Proofpoint-GUID: M2EfeXVtZT6av8TLd1Ko-Pd2KxGo-xxt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/23/21 9:54 PM, Bart Van Assche wrote:
> This patch prepares for converting SAM status codes into an enum. Without
> this patch converting SAM status codes into an enumeration type would
> trigger complaints about enum type mismatches for the SAS code.
> 
> Acked-by: Jack Wang <jinpu.wang@ionos.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Cc: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/aic94xx/aic94xx_task.c    |  2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  8 ++++----
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 ++++----
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 ++++----
>   drivers/scsi/isci/request.c            | 10 +++++-----
>   drivers/scsi/isci/task.c               |  2 +-
>   drivers/scsi/libsas/sas_ata.c          |  7 ++++---
>   drivers/scsi/libsas/sas_expander.c     |  2 +-
>   drivers/scsi/libsas/sas_task.c         |  4 ++--
>   drivers/scsi/mvsas/mv_sas.c            | 10 +++++-----
>   drivers/scsi/pm8001/pm8001_hwi.c       | 16 ++++++++--------
>   drivers/scsi/pm8001/pm8001_sas.c       |  4 ++--
>   drivers/scsi/pm8001/pm80xx_hwi.c       | 14 +++++++-------
>   include/scsi/libsas.h                  | 12 +++++++++---
>   14 files changed, 57 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
> index 71d18f607dae..c6b63eae28f5 100644
> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -205,7 +205,7 @@ static void asd_task_tasklet_complete(struct asd_ascb *ascb,
>   	switch (opcode) {
>   	case TC_NO_ERROR:
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		break;
>   	case TC_UNDERRUN:
>   		ts->resp = SAS_TASK_COMPLETE;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 3cba7bfba296..9e58009369f9 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1152,14 +1152,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
>   		}
>   		default:
>   		{
> -			ts->stat = SAM_STAT_CHECK_CONDITION;
> +			ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   			break;
>   		}
>   		}
>   	}
>   		break;
>   	case SAS_PROTOCOL_SMP:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   
>   	case SAS_PROTOCOL_SATA:
> @@ -1281,7 +1281,7 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
>   		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
>   		void *to = page_address(sg_page(sg_resp));
>   
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   
>   		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
>   			     DMA_TO_DEVICE);
> @@ -1298,7 +1298,7 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
>   		break;
>   
>   	default:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   	}
>   
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 46f60fc2a069..af51ac49d9fb 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -2168,7 +2168,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
>   	}
>   		break;
>   	case SAS_PROTOCOL_SMP:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   
>   	case SAS_PROTOCOL_SATA:
> @@ -2427,7 +2427,7 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
>   		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
>   		void *to = page_address(sg_page(sg_resp));
>   
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   
>   		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
>   			     DMA_TO_DEVICE);
> @@ -2441,12 +2441,12 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
>   	case SAS_PROTOCOL_STP:
>   	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
>   	{
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		hisi_sas_sata_done(task, slot);
>   		break;
>   	}
>   	default:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   	}
>   
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 499c770d405c..932afd690183 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2178,7 +2178,7 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
>   		hisi_sas_sata_done(task, slot);
>   		break;
>   	case SAS_PROTOCOL_SMP:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   	default:
>   		break;
> @@ -2285,7 +2285,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
>   		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
>   		void *to = page_address(sg_page(sg_resp));
>   
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   
>   		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
>   			     DMA_TO_DEVICE);
> @@ -2298,11 +2298,11 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
>   	case SAS_PROTOCOL_SATA:
>   	case SAS_PROTOCOL_STP:
>   	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		hisi_sas_sata_done(task, slot);
>   		break;
>   	default:
> -		ts->stat = SAM_STAT_CHECK_CONDITION;
> +		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   	}
>   
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
> index e7c6cb4c1556..e1ff79464131 100644
> --- a/drivers/scsi/isci/request.c
> +++ b/drivers/scsi/isci/request.c
> @@ -2566,7 +2566,7 @@ static void isci_request_handle_controller_specific_errors(
>   			if (!idev)
>   				*status_ptr = SAS_DEVICE_UNKNOWN;
>   			else
> -				*status_ptr = SAM_STAT_TASK_ABORTED;
> +				*status_ptr = SAS_SAM_STAT_TASK_ABORTED;
>   
>   			clear_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
>   		}
> @@ -2696,7 +2696,7 @@ static void isci_request_handle_controller_specific_errors(
>   	default:
>   		/* Task in the target is not done. */
>   		*response_ptr = SAS_TASK_UNDELIVERED;
> -		*status_ptr = SAM_STAT_TASK_ABORTED;
> +		*status_ptr = SAS_SAM_STAT_TASK_ABORTED;
>   
>   		if (task->task_proto == SAS_PROTOCOL_SMP)
>   			set_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
> @@ -2719,7 +2719,7 @@ static void isci_process_stp_response(struct sas_task *task, struct dev_to_host_
>   	if (ac_err_mask(fis->status))
>   		ts->stat = SAS_PROTO_RESPONSE;
>   	else
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   
>   	ts->resp = SAS_TASK_COMPLETE;
>   }
> @@ -2782,7 +2782,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
>   	case SCI_IO_SUCCESS_IO_DONE_EARLY:
>   
>   		response = SAS_TASK_COMPLETE;
> -		status   = SAM_STAT_GOOD;
> +		status   = SAS_SAM_STAT_GOOD;
>   		set_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
>   
>   		if (completion_status == SCI_IO_SUCCESS_IO_DONE_EARLY) {
> @@ -2852,7 +2852,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
>   
>   		/* Fail the I/O. */
>   		response = SAS_TASK_UNDELIVERED;
> -		status = SAM_STAT_TASK_ABORTED;
> +		status = SAS_SAM_STAT_TASK_ABORTED;
>   
>   		clear_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
>   		break;
> diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
> index 62062ed6cd9a..2fbcc597c13c 100644
> --- a/drivers/scsi/isci/task.c
> +++ b/drivers/scsi/isci/task.c
> @@ -160,7 +160,7 @@ int isci_task_execute_task(struct sas_task *task, gfp_t gfp_flags)
>   
>   			isci_task_refuse(ihost, task,
>   					 SAS_TASK_UNDELIVERED,
> -					 SAM_STAT_TASK_ABORTED);
> +					 SAS_SAM_STAT_TASK_ABORTED);
>   		} else {
>   			task->task_state_flags |= SAS_TASK_AT_INITIATOR;
>   			spin_unlock_irqrestore(&task->task_state_lock, flags);
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index e9a86128f1f1..4aa1fda95f35 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -116,9 +116,10 @@ static void sas_ata_task_done(struct sas_task *task)
>   		}
>   	}
>   
> -	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
> -	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
> -	      dev->sata_dev.class == ATA_DEV_ATAPI))) {
> +	if (stat->stat == SAS_PROTO_RESPONSE ||
> +	    stat->stat == SAS_SAM_STAT_GOOD ||
> +	    (stat->stat == SAS_SAM_STAT_CHECK_CONDITION &&
> +	      dev->sata_dev.class == ATA_DEV_ATAPI)) {
>   		memcpy(dev->sata_dev.fis, resp->ending_fis, ATA_RESP_FIS_SIZE);
>   
>   		if (!link->sactive) {
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 6d583e8c403a..e00688540219 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -101,7 +101,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
>   			}
>   		}
>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
> -		    task->task_status.stat == SAM_STAT_GOOD) {
> +		    task->task_status.stat == SAS_SAM_STAT_GOOD) {
>   			res = 0;
>   			break;
>   		}
> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
> index e2d42593ce52..2966ead1d421 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -20,7 +20,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>   	else if (iu->datapres == 1)
>   		tstat->stat = iu->resp_data[3];
>   	else if (iu->datapres == 2) {
> -		tstat->stat = SAM_STAT_CHECK_CONDITION;
> +		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		tstat->buf_valid_size =
>   			min_t(int, SAS_STATUS_BUF_SIZE,
>   			      be32_to_cpu(iu->sense_data_len));
> @@ -32,7 +32,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>   	}
>   	else
>   		/* when datapres contains corrupt/unknown value... */
> -		tstat->stat = SAM_STAT_CHECK_CONDITION;
> +		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   }
>   EXPORT_SYMBOL_GPL(sas_ssp_task_response);
>   
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 1acea528f27f..31d1ea5a5dd2 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1314,7 +1314,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
>   		}
>   
>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
> -		    task->task_status.stat == SAM_STAT_GOOD) {
> +		    task->task_status.stat == SAS_SAM_STAT_GOOD) {
>   			res = TMF_RESP_FUNC_COMPLETE;
>   			break;
>   		}
> @@ -1764,7 +1764,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>   	case SAS_PROTOCOL_SSP:
>   		/* hw says status == 0, datapres == 0 */
>   		if (rx_desc & RXQ_GOOD) {
> -			tstat->stat = SAM_STAT_GOOD;
> +			tstat->stat = SAS_SAM_STAT_GOOD;
>   			tstat->resp = SAS_TASK_COMPLETE;
>   		}
>   		/* response frame present */
> @@ -1773,12 +1773,12 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>   						sizeof(struct mvs_err_info);
>   			sas_ssp_task_response(mvi->dev, task, iu);
>   		} else
> -			tstat->stat = SAM_STAT_CHECK_CONDITION;
> +			tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   
>   	case SAS_PROTOCOL_SMP: {
>   			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
> -			tstat->stat = SAM_STAT_GOOD;
> +			tstat->stat = SAS_SAM_STAT_GOOD;
>   			to = kmap_atomic(sg_page(sg_resp));
>   			memcpy(to + sg_resp->offset,
>   				slot->response + sizeof(struct mvs_err_info),
> @@ -1795,7 +1795,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>   		}
>   
>   	default:
> -		tstat->stat = SAM_STAT_CHECK_CONDITION;
> +		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		break;
>   	}
>   	if (!slot->port->port_attached) {
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index ecd06d2d7e81..0fb04cec5fe2 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1930,7 +1930,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   			   param);
>   		if (param == 0) {
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   		} else {
>   			ts->resp = SAS_TASK_COMPLETE;
>   			ts->stat = SAS_PROTO_RESPONSE;
> @@ -2390,7 +2390,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
>   		if (param == 0) {
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   			/* check if response is for SEND READ LOG */
>   			if (pm8001_dev &&
>   				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
> @@ -2912,7 +2912,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   	case IO_SUCCESS:
>   		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		if (pm8001_dev)
>   			atomic_dec(&pm8001_dev->running_req);
>   		break;
> @@ -2939,17 +2939,17 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   	case IO_ERROR_HW_TIMEOUT:
>   		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_HW_TIMEOUT\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_XFER_ERROR_BREAK:
>   		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_XFER_ERROR_PHY_NOT_READY:
>   		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
>   		pm8001_dbg(pm8001_ha, IO,
> @@ -3710,7 +3710,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   	case IO_SUCCESS:
>   		pm8001_dbg(pm8001_ha, EH, "IO_SUCCESS\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		break;
>   	case IO_NOT_VALID:
>   		pm8001_dbg(pm8001_ha, EH, "IO_NOT_VALID\n");
> @@ -4355,7 +4355,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>   
>   			spin_lock_irqsave(&task->task_state_lock, flags);
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   			task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>   			task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>   			task->task_state_flags |= SAS_TASK_STATE_DONE;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index d28af413b93a..01122993c943 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -753,7 +753,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>   		}
>   
>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
> -			task->task_status.stat == SAM_STAT_GOOD) {
> +			task->task_status.stat == SAS_SAM_STAT_GOOD) {
>   			res = TMF_RESP_FUNC_COMPLETE;
>   			break;
>   		}
> @@ -838,7 +838,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>   		}
>   
>   		if (task->task_status.resp == SAS_TASK_COMPLETE &&
> -			task->task_status.stat == SAM_STAT_GOOD) {
> +			task->task_status.stat == SAS_SAM_STAT_GOOD) {
>   			res = TMF_RESP_FUNC_COMPLETE;
>   			break;
>   
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 4e980830f9f5..57c8394cd1b5 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1952,7 +1952,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   			   param);
>   		if (param == 0) {
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   		} else {
>   			ts->resp = SAS_TASK_COMPLETE;
>   			ts->stat = SAS_PROTO_RESPONSE;
> @@ -2487,7 +2487,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
>   		if (param == 0) {
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   			/* check if response is for SEND READ LOG */
>   			if (pm8001_dev &&
>   				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
> @@ -3042,7 +3042,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   	case IO_SUCCESS:
>   		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_GOOD;
> +		ts->stat = SAS_SAM_STAT_GOOD;
>   		if (pm8001_dev)
>   			atomic_dec(&pm8001_dev->running_req);
>   		if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
> @@ -3084,17 +3084,17 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   	case IO_ERROR_HW_TIMEOUT:
>   		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_HW_TIMEOUT\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_XFER_ERROR_BREAK:
>   		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_XFER_ERROR_PHY_NOT_READY:
>   		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
>   		ts->resp = SAS_TASK_COMPLETE;
> -		ts->stat = SAM_STAT_BUSY;
> +		ts->stat = SAS_SAM_STAT_BUSY;
>   		break;
>   	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
>   		pm8001_dbg(pm8001_ha, IO,
> @@ -4699,7 +4699,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>   
>   			spin_lock_irqsave(&task->task_state_lock, flags);
>   			ts->resp = SAS_TASK_COMPLETE;
> -			ts->stat = SAM_STAT_GOOD;
> +			ts->stat = SAS_SAM_STAT_GOOD;
>   			task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>   			task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>   			task->task_state_flags |= SAS_TASK_STATE_DONE;
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 9271d7a49b90..6fe125a71b60 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -474,10 +474,16 @@ enum service_response {
>   };
>   
>   enum exec_status {
> -	/* The SAM_STAT_.. codes fit in the lower 6 bits, alias some of
> -	 * them here to silence 'case value not in enumerated type' warnings
> +	/*
> +	 * Values 0..0x7f are used to return the SAM_STAT_* codes.  To avoid
> +	 * 'case value not in enumerated type' compiler warnings every value
> +	 * returned through the exec_status enum needs an alias with the SAS_
> +	 * prefix here.
>   	 */
> -	__SAM_STAT_CHECK_CONDITION = SAM_STAT_CHECK_CONDITION,
> +	SAS_SAM_STAT_GOOD = SAM_STAT_GOOD,
> +	SAS_SAM_STAT_BUSY = SAM_STAT_BUSY,
> +	SAS_SAM_STAT_TASK_ABORTED = SAM_STAT_TASK_ABORTED,
> +	SAS_SAM_STAT_CHECK_CONDITION = SAM_STAT_CHECK_CONDITION,
>   
>   	SAS_DEV_NO_RESPONSE = 0x80,
>   	SAS_DATA_UNDERRUN,
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
-- 
Himanshu Madhani                                Oracle Linux Engineering
