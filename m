Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0837DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 23:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C962364E4B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 23:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhBIXRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:17:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbhBIXJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 18:09:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IU7wS194308;
        Tue, 9 Feb 2021 18:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AwRZABhAeVNy1ax749hk8DHlgg7g37UMtnu+O7EzJTg=;
 b=J9AIQgpTBd8cY3n6ZQcSOITAM8+6MjvXrLeZbCqMgMWcc1LNZJB21rpGxD0Q7lsY3vPG
 rjOn+2vHZ82hqybDf0v8Z+lUax7bm8ODgDqI3lAkwmI66XxpGbIGwGD9mi5Op1zaXLFO
 kFvvKSsnFHZF+SUopDVxSL4e+wMfOGS2qU+djjajZQBrK1QZfOwn+A7g1vIBss9u09i1
 UEFJa/69mPB4M1Im+E0VjVraUcI5pNkJMVDC0XORIzn3kqyMEyz8l7Imo6uXiQEde2BB
 g1BpMOhi4f8v+qdgNhidBciBCtUl/GMk98TjmQ+rkqShhwc0HBGxYLthvX/ntorzoT8r 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36hk2kgm7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:43:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IOddU181904;
        Tue, 9 Feb 2021 18:43:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 36j4vrqtt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:43:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpijrcLiOKgc3wE3OoDMtKsNwqk6fOk3H7U1clvYNBKH6x0C9FllqorDdUvSOeVfZFOr6ECRtTOoSPOOqd/GMnkSybZtH+WgMEsDZFxJqd3Q4ptrnzgT5pgwOQMcf4mbXapdxBSZX40td5mPQRlkzt8VgJzThkPXfSyoSqdcJRTm3uiFaZAqe6A3t7LwCcXfhFl7eIp4j92tgt8DzztRSLWBnAd8A2LYmmdUWZncH8ArnHh3X6HU/LNZ0Vdkzghkx5mAU2TcSmqT7ygHaKyjAGP87Pep8e7VwLko/VpobjiI4OMaYyQNkvL+C572AIuewrd1l2j8QP9uBisTfpR5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwRZABhAeVNy1ax749hk8DHlgg7g37UMtnu+O7EzJTg=;
 b=LUOCPEA+1qLW+4kK0a9rYG3L0MajxUHCFkB2i6fN5QDpJqC3kE9Pcijs61uo9ikJjWSPWyjy2fL9lyMuHxSpzNQLpO42ZgkjYV0tTgVPUtJXFOJXLWJP9ChVjrNuxXgttApViHwNkYSxj4CUoTZr+uAOWuQDYdaDWUlvbU18EAwuVJR5f9PFQ3AtEXO8JSgJ1FpW5wOgQpPj/xwOrYDawasIModJkTDsK7WvrAjIZgbgq9c/EgKEX+oAL0vFw1f0BRnHUxGbEzIiNt1hOfaksCA8xIgxLoFgIw3VlBOmaa/f9FUcKSJ+U7Q2Barb3FGBo7YOQsWdptHFSToVJ8Xsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwRZABhAeVNy1ax749hk8DHlgg7g37UMtnu+O7EzJTg=;
 b=XZXDB86sGYJJdZY/uUxktY8yUTe+FWKtxT7dT8ZP8uDyt5Qjt3kr3/QcB+l/WCgGDg11FYdTwPzzcDgEsY3y8z1GTYfrTzVAVpd5BT482F93j0j0D/dvAx8cz9dI9XVIMWucyMp8BgCFK9/C1V4gdtr+bkdO8HROKOp7oEyKDE0=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.28; Tue, 9 Feb
 2021 18:43:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:43:04 +0000
Subject: Re: [PATCH 03/13] target: add workqueue based cmd submission
To:     Bodo Stroesser <bostroesser@gmail.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-4-michael.christie@oracle.com>
 <206a3f41-dea8-2152-4811-817138ffb580@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <f33bd053-3a78-fc9c-0ec5-2b5e97dadcfc@oracle.com>
Date:   Tue, 9 Feb 2021 12:43:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <206a3f41-dea8-2152-4811-817138ffb580@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:610:32::16) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR07CA0011.namprd07.prod.outlook.com (2603:10b6:610:32::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 18:43:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26ae58eb-4d15-41a6-5b72-08d8cd2a8900
X-MS-TrafficTypeDiagnostic: BY5PR10MB4195:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB419554271D3F1FE8949A64F8F18E9@BY5PR10MB4195.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /X0Us20gp88qWpO0+P4mNzJwmhPcyHO1nDINJYLWlWzoQIV+AuAf0TX+sx/fMBoArDmRJX637HjbwvfiLKzvDa/CwrrTLr8h0RyGAP8GVFDOKnNR/JSLAeknOZsEM5RTNq+DvsYmMzkwiysYWq4nydXtoDQnye2dhSHJPSU6ABKU6nSjSOGvWvEsbC1aHPjTM4A8Au8PW3lkRbITRkrD5Ngv4lWdiVFu5YcAcfK5KSwz2qkT9H+pZ5xH4ad2OX89wBfWiraAJ2bu9RMTmzdlCAful+E6Xer9VMK+2TwIYO3o6KvGZ2e/1604hpIrn/rOg3kPXeQZv6jK3PglMlBJs7r6O/Z5zZz/7HOdrDKlmydDs2C5B1Qr2X/4vqgfPz6LX0ql7OtX8Ihw2tyAj64U0t/RoVP2Nm7GWzfAXV6Ep4Tb/A03Ex8A6yvTrysNG1+YBh9ycUplDQ7uyC2cdAOH7iWMGaSNcKio66DHVzRptKofo2Jk3p2MNgX2KMsqOGUpZ0DMW4UTA7E6Yums1VkbPTxKkHdssJSaYS43+M1JC5NiBksuy9rVXVYEaXMQVrvmVWjN0CXaKd4BydZJGJFwhpCDtUCHUy5VhVRQmxCKf3E6s6CFz0MjzaPPSe+KIglI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(2906002)(8676002)(31686004)(31696002)(86362001)(26005)(8936002)(83380400001)(53546011)(478600001)(956004)(36756003)(2616005)(6706004)(316002)(16576012)(66476007)(66556008)(66946007)(6486002)(5660300002)(16526019)(186003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RlRvSUIwY1hjT0RZVXNRSW9HdDJTNEFsb2NqVFpKYnpOTy9PY3N6SXV2THQ4?=
 =?utf-8?B?UUZQRU44aklnWFB6YUFKU05TZlA1aURvQzJGTmNTZWNveHcvVWIxb241SmFK?=
 =?utf-8?B?ekxmU05NemxMV1MzTGFGTnRidjY5R3VMcFhnWjd2aVErLytTYm5jcmpLSEt2?=
 =?utf-8?B?eFg1dXY1WkNpVWdIQi8wY0ZUeDNsUmFOTHVWYmJwZXlsbmxDaEtUVmdxUkdn?=
 =?utf-8?B?V01hMlI3MGpHeTZreGFzVDdWUWxNemdLMDN3MFEzUmtHUEhZdUZnMVdGM1FD?=
 =?utf-8?B?N1gwUVFjK3o1czRQQzloTmNqTDhyRmpab1RjQXVKN3JvdlplbFhGNzRJcHd4?=
 =?utf-8?B?NFBXSTJJUUE5T3U4YzhKR2x2MTFoL2x1clkvdkNxcy9wYW5kcVJtZ0IzdWFH?=
 =?utf-8?B?TjY4ZFkyN0N0dTJtcWJYVUxZcklDWjRwRHB1THRhZDFGUTM2dHd6enZYMVRD?=
 =?utf-8?B?blBRa05aM0hWekNYWFlIcEIrU2lDc3JsaGY1SHN1bitMMEtYWnRYOHVVUVVK?=
 =?utf-8?B?QUpSYk1IdWFUWmxEVEEraXdhVzE4SXQySUNob3RGbGZxK1Y4eGdkOVZFbG1S?=
 =?utf-8?B?RlNsejZ1SlJjUXg4Q0F6YlVleFhGNHlUaVVCVUh3Z0lLOTdCUW93V1BRdHFv?=
 =?utf-8?B?R0JTa2FnUXpCWmFyTFNBdks1M1YwL3lhTlVuWnplbmFxdllGS0oxeVRWRFJM?=
 =?utf-8?B?YkN6K3ZaWGVvZXRaZGJLZ1haSTJDdFZma0NSWUpRUzNIMHlGdE5HUEpGcDN3?=
 =?utf-8?B?QXVUZTB2UExzL2JyMmQ2NDFaWXNvUE5oNVZ3Y1hoTXpRbFhvby9YOXlsRDd1?=
 =?utf-8?B?ckd6SUkrM1l1RlhtbU1xUW5oMjZucGVCbnZyRjE1Q2c5SUMwN0c4RlZBVEdV?=
 =?utf-8?B?ZjRpVFFTZ3RJRDd6SXFxaWJSU0VULzdUSGVqK1FRSTNGNWdvMzltZ3RZUDlB?=
 =?utf-8?B?Yk9WbGtxbVJPTGZsOXpBVDBLYTAzQlBVc1hQNUQ2ai9aZEtJYzhsS3FncEFh?=
 =?utf-8?B?cWlPd2crZHhjRXRhbEhxNGhIbk1pam54UDFXdlFXa0FCWHk4M1UxT1Y0Z0dC?=
 =?utf-8?B?WjBKYlpBMWU2TjhDWU9uWDlRcGs2TFBFZmlVclNaM01WK0NSVWhvYWRERmxi?=
 =?utf-8?B?UzdkNFZlZFdCS0pNbjJ2cWQzMk1xYXN0bUFnOVorcy8rbVdpekt5ZXR6QS8z?=
 =?utf-8?B?RkdnSFE1MkZrMVBpOVA5UmRDU3R1ZHdGYWNTdFJIcTUzYVVUdFU2MzNNazFR?=
 =?utf-8?B?Q0VqQ0VGL1R5K0tpdTRIdGU0dlVJVTFycDlPL2IwLzFnMzJOU2drcklheCtl?=
 =?utf-8?B?TUdSY1dLLzk4bzB2RjNaT216V21TdC9aT2dyS0ltTFhSa0VKUk11UGV1aUJC?=
 =?utf-8?B?YXN6eVRQbGJtbzJiL3VORDIrL0tXcjRQNGN3dWQ5WEJiVXFDV05RUzk0NUhu?=
 =?utf-8?B?SENVNWVKYUtReUN6SC9URlo0Q2VCOE02NGROU3I5MXJERzlTcHhaSzdEczFa?=
 =?utf-8?B?YnVrMVR5UW4xMUUvUStYdTJVaGo1TUl1aGpnSHlKN0R0NHlIaTZHSWQrRzBL?=
 =?utf-8?B?Slh1RS96ZlFYWkUxdHJKYkljVytEU0RBMkl6TCs4aktSYmJGZklHYlJ1Vkt4?=
 =?utf-8?B?ajhJV0t0bGhLTGZFakl5RThnZGIwMElzaldMREJzS3pQMkVmRktkTEdVcU1O?=
 =?utf-8?B?c1YzVkozaUc0N1Q0cDByaFpQMURuYytKcXVWTmowTnBmWHEzMnd1djA4VTNm?=
 =?utf-8?Q?vCXaaQbzx28P0UAmFoS2/xTq3tnNnSsFgJ3/aEJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ae58eb-4d15-41a6-5b72-08d8cd2a8900
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:43:04.5686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uASiqyrB17OGB3hMyxU/QFYfntpjJKD5SnRtbZrrB3C8oXhP1pRiZrFFJyk84cDkn+pA+5SmqDOOOZs9NiKeWwgPc2p4UMkYd7kAGZ7M48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 9:48 AM, Bodo Stroesser wrote:
> On 09.02.21 13:38, Mike Christie wrote:
>>   +void target_queued_submit_work(struct work_struct *work)
>> +{
>> +    struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
>> +    struct se_cmd *se_cmd, *next_cmd;
>> +    struct llist_node *cmd_list;
>> +    unsigned char *cdb;
>> +
>> +    cmd_list = llist_del_all(&sq->cmd_list);
>> +    if (!cmd_list)
>> +        /* Previous call took what we were queued to submit */
>> +        return;
>> +
>> +    cmd_list = llist_reverse_order(cmd_list);
>> +    llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
>> +        cdb = se_cmd->se_tfo->get_cdb(se_cmd);
> 
> If I got it right, get_cdb is a new, optional callback.
> So, should we check, whether it is set?

I think a check is not really useful. The caller has to implement it
if they call target_queue_cmd_submit. It would be a BUG() and so
either way you would get a crash when you are developing a patch.

> 
> Maybe the check better could be done early in target_queue_cmd_submit.
> 

