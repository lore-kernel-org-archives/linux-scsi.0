Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2616C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F1661167
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhIJQ1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:27:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229664AbhIJQ0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 12:26:55 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ADqICY023985;
        Fri, 10 Sep 2021 16:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lELrYPwvoZoZl+rvgn5ButryQMOhTGkeDMLLqHv0cGc=;
 b=isSY00IY1O++VPhBw6a705YLjMRofQSQKHw/6HUQsJ7QSFYeAsSzumZbQVA+c+DNPOJZ
 jUmjILk61VijDgEAIWKpxQKJZ/Sl/5lNnaSx+tUJ1fB/8HnRYf6V3t1CtnVODXQ/S5nE
 6tZysIp9rWeDKhakPFgxY/cvANRxl6m53cZ6eH47ZOT6ZyFMdUctb4Om4MRJeiEicCeN
 1ZJXI6VaQ1vr6kJaeB1dEWXh/qOlZdkZs8iiFJxlfNJroerAZ3f7tGbc5oimeLx8Grt8
 SyQWwIczGu5nCdHn2OFWzkzOuDqSl1o59fTUJu2PUtd/YyxykxWPH+6CXmq9QO1Y/bdf xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lELrYPwvoZoZl+rvgn5ButryQMOhTGkeDMLLqHv0cGc=;
 b=TvkPKlvvYSrEPpf+FVZUOt/AGZG/X0lp6J7uRArT6XEXGJxAm/sbzulCviv4OZH5xDDR
 hceZFb3yiVWQ3LUwqpIY0vfe5OKZDm60llVb83eyx3o59enImKWupg1X7RmHyb7l9CYE
 FJcBcO5kb3zPIGmO55zLcd2CTlkbPWhuD5U+Puw9yjcFAQSiG1sajjVS4M4grWWzeTNm
 iRy6Q0d+kuygJPWeGOpBYCpfK7u+IgqUnOMbuGUzr1zdBn3ooJZJ/FHnLArG9tYGaHlt
 buSh1Bh5s74OO3NG9O/kzzgxr4bIw70K+ej/xeAxQq0S8oNDGaFX1B0UAD/L9U6SF9PS ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytfkad44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:25:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AGGAeG150364;
        Fri, 10 Sep 2021 16:25:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 3aytfyh59k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diimFTwvAtYgY7h9NXol4l/hvN0jWUWKAxwQunj1pPxcs+j+N8Hjok9gLPsvZ+e7T5UL3Z3rZl90yDgENvvZ2nqQpM/PhD0yVpk8Pbjs4B1OW5hyyB1FEwlySTetcy0K19bxJnmnR7NolrfDQsLwbmXvYnfUMkKH2VdAY0sEfdxXGBZV6ajWlO0HPTiH14TpGVXUBJf6W7G/e+ycoo18RYiy7S/aeH2ib173Yh7wP5VZdWhrYBOCdS982lG1zR1FSruM+iGZtS8G8Ts3qBoIUiqg13yoKVPMiQ8Szqhd/N3F17mxpTT+MU4eioNGsFeluUS7gVcLewdhOJwfCVhDLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lELrYPwvoZoZl+rvgn5ButryQMOhTGkeDMLLqHv0cGc=;
 b=QtyUHb9YfwBg+Z/3KfkphyDM/AxpjMH2lzrrCAfl6IIluDPbr3Ym/ZLMokwM/RN5eLC3sj38GB5mXbAnI/+Ne8zSf3J//vOnEe7dgnIE9Jx3z6Hrk17QtQqdjK/H/Bq677hA7W+M6Vtfv8oIfJgvc//87dEbiL2qozZAZRxtGOqQtsAEOGcv1B3nGvQg3V/wYotfJRiAxfu9AyWlF8TsZJag2KabdkSZC8SlEsTMkCCtSsdTv+aBZIfwg1rZHq5IrZspZwyiuoPU7d8w/oyDldzzfm97f1DvOhlyCYmTFKvd9g+EgQTO55Ni/izMHnKBKyaHuKOLES6qO8uby+hetg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lELrYPwvoZoZl+rvgn5ButryQMOhTGkeDMLLqHv0cGc=;
 b=U4VR/a0gGM34mbTnyRurLSafiapmy93fq92PUHA1G5f0pqoiL2HnwFe1TRT8+D4YQKg+bbcsAGGsPmysovpHJJC59dDa2sgUdLPB17VYCiW9TF2bDU6OX/AXzudQe8ElH1yPqaiHX6GBevGWzN/WgiWipvCi/tHL6eQ72rsq8Oo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3622.namprd10.prod.outlook.com (2603:10b6:a03:120::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:25:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701%6]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:25:29 +0000
Subject: Re: [PATCH 1/3] scsi: libiscsi: move init ehwait to
 iscsi_session_setup()
To:     Ding Hui <dinghui@sangfor.com.cn>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
 <20210910010220.24073-2-dinghui@sangfor.com.cn>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <03817f8e-8fed-6e7a-e76f-8608f8cfd979@oracle.com>
Date:   Fri, 10 Sep 2021 11:25:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210910010220.24073-2-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0325.namprd03.prod.outlook.com
 (2603:10b6:8:2b::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0325.namprd03.prod.outlook.com (2603:10b6:8:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:25:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eac337f-0a3a-4ffe-ca60-08d974779a79
X-MS-TrafficTypeDiagnostic: BYAPR10MB3622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3622EA1A6AB1C3601ABFD208F1D69@BYAPR10MB3622.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epAznOdoCsEUX8a1woIYyh9eSPEQoRcWBzj4K0MV7JXZrbVvtyCoHGWV1i2F1OgNfBtecg4jKqOy993WKzWKIBY7BUMTFaJm9tnlV+qpPemtCxLKafvJWCFL9k0vniXqtyv7RR0AVwG7uwiDwQls1qSVOsQRR1xwi6FxmF2doUErHS+vGMYx5jB1uHEhpA64JNWhCHJm6yyy7pppZulWEH3At3UKOJVaXbbI6NmWAOuhCwtBVJ79aELQcghkfSJvM0mDNyBPlYhZEnn/4TdEVRy0vNqCQ3mPZNJDzqDAGbgheJVVUWAoPjH3Vk8AWewlAZMtiPUuUT1tZfJaCDQPRhZK/oG2WEX56+KY970UciXNe8ELJRxxSAV/08ghBX487dUi6BQpRF+sltIDeCV5DIKLTwuapAza1zbTG62WrHIqML0adDizNyPO86aF5iyoV+G2UrCnGTRL7QnBC1/zvZt+ScQ5U4qsp5GEilJFlsjdbla6Ja/ffjZijfcHJHtnTSaSBf0AKT9jSB48hbGR6CTO/fs6HUsEwYVOHv40aZMQlqNBQmLb4XwB0Hbho1qUz5MRWNL1RR3CkbGRLwwQgCEoHnMtNGrRs5VHO3EQ+MI2hNaG7SueHbv4jCqLtCdeLmHWmfhoM5PT3tiATaNxW2HdIN6E06LA39URlgZtuTF8XCUzR8rBRZ5b17BGSdfjuzk+xiFNENfj4S8+2u/Z0kdSxAV+YvUikO+RqOI1ayeYDGUWIISKl77+Ylm8YqXA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(478600001)(956004)(66476007)(8676002)(26005)(6706004)(8936002)(31696002)(66556008)(53546011)(66946007)(38100700002)(86362001)(316002)(36756003)(16576012)(83380400001)(31686004)(2906002)(2616005)(5660300002)(6486002)(186003)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUErTVJnZTE2WnVQaXA4MTVlNmdXd0hBSE9FLzVTeWY3RWl1M3Q4dFIvdFRD?=
 =?utf-8?B?cDZTOHlYLy9UbnVDaHJEN1ZoK3Rnam9oM0dJUGg5N0ZxYlZ6TnA1cmNNZDJR?=
 =?utf-8?B?N2xnQ0FhTERIYlNDUXVUWUk0dnhyaFVQU3JwNnBvSTYvclM3K2pKOFNFbHht?=
 =?utf-8?B?U3VQeVFEVTZBU2VNZTR2eXJSbElRcWdCeU9FTEhOMzh5SytzS1ZibGVkdnhD?=
 =?utf-8?B?ckpiN0hsTE9mMVE3Wml1OUZsZloyN3hLZDdUckljS1hiVllTaUo0NDRkSFBK?=
 =?utf-8?B?b0o5aUxVa3NwaFJXeDY2UXVONExHOWluaGE2a2Q5RjBiWDhWYjdqUW9yVDg5?=
 =?utf-8?B?NzU5N3hhQm8xZWZPNWRYOGpLZ2hja2o0YWRIUlVHT251M1dIRmZTamdLWm5V?=
 =?utf-8?B?Sm91bzRHTWFvL1pxTzRpd0pSTGM1V3IxZDZCVVhMV0tlMFAwUWpwdUh1czNK?=
 =?utf-8?B?UGJBaTkvZnYweVY4cmc2SXpzbnk5ZHZaWmdtUjVKcDhPR20wQTRxNVNlUU1o?=
 =?utf-8?B?eXhreXpEY0VPS21uK1M4OStjRGtRR1FXaWovSEtRTW5JR21VUlAxRmFxRnE4?=
 =?utf-8?B?QmRIYzRHbU5NZ2s5dkNlZEt3WHZhVVhVQ1B0YS9Zc1NEYVh2TGc0WFRubS9k?=
 =?utf-8?B?eUhIVERPWVNsdjU4R3BQbU5MWXJIdkxNQTc0RVQySzA1cVNTNU5KOEVMbkxj?=
 =?utf-8?B?WlRRS2lIUmlWM2xPZHE4ekxNY3NsbTNDalNQOTNRNVB4VVFXZTlOcmxuaHha?=
 =?utf-8?B?dVdZd3ZTSmZhTis2UEtmT3RVWEFQZGhXOTVNdHVablAvbXFlSGFqaVpKa3pr?=
 =?utf-8?B?WDc1UjRSSE9NVGFaSDhMeUNqd3R5SzlUa0FmMW9YMWh4LzdvWFY4RldNb05I?=
 =?utf-8?B?b0YyOHMwY3ozbjhMdVpCK2J5K1lBd2tkWEwzOCtoaCtNbVJXb0FMd0xCSU5Y?=
 =?utf-8?B?bW1NUXdlcUZOVWE5THNySUdzeVJnbDRyZmlXbVJVSm53Q0hVamlwdXhWelVi?=
 =?utf-8?B?ZDdaNmxpZ3p3YnF0UXVTMmRMV21YbTZTaGVwZGtpa1NtS3psaEt5N242ZE5Q?=
 =?utf-8?B?RGZuMTNsSnh1MHhzc1d1eExHQXlVWitDUGswbnRuVlo4VUszVTM4Y0JndnFi?=
 =?utf-8?B?VkFBY1FZaUx6Um03WUJTMXd6RDZxdlVoVURvWjBhWE1VODZjTTZHMVQ1TG5Z?=
 =?utf-8?B?c0RPSS8rN1VYd3RzOXkrdkZOeDA1eGlrSitFRkI4T0xVSmYxY3JtN3BHaFV4?=
 =?utf-8?B?SER3M1hEVXYrUCt2MXNNQ3E1WlROV1plUHgrbHdvNXFWc2VnK2ExMXhhQy9D?=
 =?utf-8?B?T0RxZWIyTjZlNUxDQjJLajZSWGh1SUlMRTVvVFZ3WU1WZTcybjJzaWZEd0Y5?=
 =?utf-8?B?dTc5d0p1TkFvcHNPcGMwMjg3UkRVQWRiVzUyV1pKQWdNUktNejBMSzNnR0Fx?=
 =?utf-8?B?REVVdy90Y0dpcXZiVS94M2d6cldJSXZmUXE1QXNQQTM1R1d6ZUFRdU5HTzFj?=
 =?utf-8?B?aUNuOS80YWgxRWxnTUdMSVJXaUFyb0xjcWZxVFlFMmFycVNXdmlJT2RDcUlP?=
 =?utf-8?B?Qjh2VEhqaFltWGRQQmtFV1RiZ1Mxb0VkMUlUSENzc1FGcmZBSFAyK2lGVk44?=
 =?utf-8?B?VU02TFNkaWh4WVpLTU1Vblh1L041OXRlUkR5MmlrUytETXBMQWN0UTBpTVFX?=
 =?utf-8?B?YmhzZTg4REJLNStiRktxN2xOeTJvdnFpZHpnUzNyMWZJSGRwQmgwalV2a2Jp?=
 =?utf-8?Q?JCPQ1VWK8932427GewtTmdRkvmcDyRldx139gj+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eac337f-0a3a-4ffe-ca60-08d974779a79
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:25:29.4856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yptZkzzhhkciyqxM7nBg4TsGzlTzEPQPuYavZAC1hCGGZloBR1Ty2C0aELBq62WUxWYw9awgA+tY2v7UK5ylGu32cU0Fq5HyuCYJlKcLaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3622
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100095
X-Proofpoint-GUID: kcrqLyluTDgdDwKuIus5X-7KMkHjmN-F
X-Proofpoint-ORIG-GUID: kcrqLyluTDgdDwKuIus5X-7KMkHjmN-F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/21 8:02 PM, Ding Hui wrote:
> commit ec29d0ac29be ("scsi: iscsi: Fix conn use after free during
> resets") move member ehwait from conn to session, but left init ehwait
> in iscsi_conn_setup().
> 
> Due to one session can be binded by multi conns, the conn after the

A session can only have 1 conn. There is some code that makes it look
like we can do multiple conns or swap the single conn, but it was never
fully implemented/supported upstream.

However, I like the patch. The init should be done in iscsi_session_setup,
so could you fix up the commit, so it's correct?

> first will reinit the session->ehwait, move init ehwait to
> iscsi_session_setup() to fix it.
> 
> Fixes: ec29d0ac29be ("scsi: iscsi: Fix conn use after free during resets")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---
>  drivers/scsi/libiscsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 4683c183e9d4..712a45368385 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2947,6 +2947,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>  	session->tmf_state = TMF_INITIAL;
>  	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
>  	mutex_init(&session->eh_mutex);
> +	init_waitqueue_head(&session->ehwait);
>  
>  	spin_lock_init(&session->frwd_lock);
>  	spin_lock_init(&session->back_lock);
> @@ -3074,8 +3075,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  		goto login_task_data_alloc_fail;
>  	conn->login_task->data = conn->data = data;
>  
> -	init_waitqueue_head(&session->ehwait);
> -
>  	return cls_conn;
>  
>  login_task_data_alloc_fail:
> 

