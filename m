Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818C4C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 15:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 560126142E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 15:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhEMPhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 11:37:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhEMPh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 11:37:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DFKIjm144976;
        Thu, 13 May 2021 15:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BBTsgNrn7z1LJ7PJIn9i7iH0rDhiA6nv0cYe+4mWAcA=;
 b=nLNmQiWeJGfNQonRl5xKoeOeKzy5C4gaNG+NC52h4vDltmwgKZijLeflMW2pQ6e8Nc9L
 QsFsB1ll3/CPtWFuSYSdVorLMrjQ1Md66QJqurYruzcgcMkF86R26Xr80rHfwFLFsfiY
 06vEsqE7ueGiydSgutpyfQjLjV/4Njy+8wBfiNEOKP9iVt4PqfJuEQLCHUvMpE2BVX22
 AHyGn90oz13tGKu5EEHsTfR9pV2nXyBAS7Xi1rVxJa8r8/V8mOxa1VaI5ilzSeQBMpcX
 npCeuWCYUQMCwYkG1vkcSF3aYw28+Kkny+0wVIFrucNgI4lkC6LC6GFnjALKi2si/yqB iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38gpnda1wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 15:36:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DFK8Rm158157;
        Thu, 13 May 2021 15:36:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3020.oracle.com with ESMTP id 38gppgaffw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 15:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSM2OIaDEK2RuSSD7DQB7JRDTha9w2omgX6EEuV+pC0LB3c57uQyAUrStuNI5vMhP7ocfPun9lCDuiOWqaosfjjQAws2OWp14Ta7QlY0DqXgKuX3mWpaIST/T558gyhwjtaWwJ7gPB85ZeUi3dS3AhpoDCNTXQ47qyGj9jg/+d7NZ5XqCbNkcTdy4y5KhHgJFk8OesGjKk5Q1RuVekQmD2tfuPaZnpc27N5jQADb0v0+wWEBgOcNeGjTS20sVvukyh3hU9bMUVJikSNy0a3ZMUhZF6b4/kf7cp2SynucWOYFjwI7XBUJILjv3VvFgD3VAW0/o7SUZzC9kRui4BrQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBTsgNrn7z1LJ7PJIn9i7iH0rDhiA6nv0cYe+4mWAcA=;
 b=LVQnlwvn+D1HBhTanewy958Av7CJud+QMnBSMwsLPkSLk1GGcxCoVDQNJ5wN/8tjvQKR7wt2fwmIqKp7gSodnKan1/cTIDnX3W3VHAc2vdC9bIwHmFGJ8eFnmULMbvFmkDq8WTpsDtrJK5R1VMwJk0nyJU5w904f2kVBNplPGxmOIqDsk4kq8R3auP6B5xAco3Ad0V1gPolrdX3peLQGf1jwyz808i/jb/UUC+kDEXKKutM0SmbR8uLV9MlmJlyxB88sv4IndRYOomNbDlmxw+3RaKHF2FNiIVi9Ez23oVTvfM7WSpLhFmZ6BUUOyz3u4e9FWjn76cKGpxkur36kKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBTsgNrn7z1LJ7PJIn9i7iH0rDhiA6nv0cYe+4mWAcA=;
 b=Mn/iywFET+p0fqy6rvUeRmanS9boDHGB2s26rLxnC8zjTYEgOktNxVrrK2CrZWTgDCmyiuBirhwtI9A6Z+CtW1jCvZoe4Ia+hrnDG3QbXCIg74ld0pJZ+A71JQeCu4KmJdvG9PouKmbw89u86kDJmk+6itnj0k2ootHbBgLuv7I=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4018.namprd10.prod.outlook.com (2603:10b6:a03:1b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 15:36:15 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4108.031; Thu, 13 May 2021
 15:36:15 +0000
Subject: Re: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d25b35e2-5ed6-4a00-56f4-71f31463ba1a@oracle.com>
Date:   Thu, 13 May 2021 10:36:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:4:ad::48) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR07CA0083.namprd07.prod.outlook.com (2603:10b6:4:ad::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 15:36:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5088fe7a-4a06-457e-2737-08d91624d828
X-MS-TrafficTypeDiagnostic: BY5PR10MB4018:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4018ACFBAEB3C5AABEDCF4E9F1519@BY5PR10MB4018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: indBvxHd/xLA5clGGQEuvoBPZTFxX4EGWmBuUlz+U3HCcHvd9eRWUPynffYnC39chyl+CpliQY6/5R+J0YQ8ntc5tofGVIacsrvDNZwrH8dpNb4gX1DTPfLQiGTkh8BcgixV/utbgWLzLzi4As/YGuuZX/WWCPuovDxtO0mfsy09G6y5mMno/Jnuxhj0YTkOiwKK+jEvq0dCcyOSDQhX4saSPLruA7m9v+t3m0HEZNSX6X6bAK6ee7B5YjgS5aI1aze9as4Od+fyZOYT1LxtCHrPp+ifQAL5u9eoCZl/Ece5jxENZSxJNNhwVYV42GNrZ+c8AP9jAO92raG4iudsjsAjSbYC0WTDyxfvBtbr0FS/PotG9VF9+9vFPOjVH5V7cPqJrzUXzW6vNnn5zpn0cNdB3PaZlK4yPFtHMOfcHgappG58ZvRamtv2T7XDGQfqQNOGzPlAVBAiy4Hriu1LNIGPV4naq0IFj/FNkywC3ZZN87A3Z8IvWazXaGHuYejMocLp47sFs61i8NynnyLqItNYePsUcsURevY02G66psD2gapP+ZywxIND+4d96koBiRp/JxNa1UrvBKZXNkJE7neDYWohYRW1pVyrL0aPehkYupfHqVJbTaZ3GkqTZP7hJzwdpsFQ22TFMJFYrT3hYb2GcNkhAEYnFeiF/FRM1RVw/R/hzvmU/qQkv4Itkw3t/DN30VkCOsad3+1v+MrZ5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(186003)(38100700002)(498600001)(6706004)(83380400001)(956004)(26005)(31696002)(66946007)(16526019)(2906002)(86362001)(8676002)(31686004)(5660300002)(8936002)(6486002)(2616005)(66476007)(53546011)(66556008)(16576012)(54906003)(36756003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SzZwZFVMOUlHWEZPYlRiMEFJejYwSDFWWGxldDd2VzVWaWJFV3N1TkdVZUVz?=
 =?utf-8?B?R0xJdTNHRmhoQVRBL1c2blBXelRQaDN6V0VjS1M0TWZlS3UvTG5DelkzQXht?=
 =?utf-8?B?VHZZWldHb0l3cUdBM21FeDJhTVdXZndXZjlHYkZTZ25acnZNbndOb2xTdkxU?=
 =?utf-8?B?c2pYVHd5ZFJiWTZUVTZFaEhQdEVhS1cyUGd4M2FBNHVJeEpSZndyTDdySFVo?=
 =?utf-8?B?V0t3Y1V3cnY1aHJ1WTVNdVRxSTlONVI5OGJWYS9GTnFaQmlJLzU1RmVNTTNj?=
 =?utf-8?B?bTlRYUcvQlJiU1hMWWZlVVB5VWFEYy9jeE4yZjJNU3pqM1ROVXljRzhTVUVT?=
 =?utf-8?B?a1VsQzZvR0phOWxFdFRJblBYOVpwSm14dGMzVXFrNE55dmJvOWM4cnZjbzNl?=
 =?utf-8?B?N2x6YWxDOFgzNnlBZnRmcmxpcEgyWW54VWVIZkhmN284aXRPTjMySHF6dk53?=
 =?utf-8?B?a2hmRGdpV2JyekN1dlo1YlprYXdubDJWWjIvL0pmS0tta1ptTExGNDRienZa?=
 =?utf-8?B?S2FrcndpOGJ2Um5GWUJ1UFFUQWFmaWp3TzJpVlR5a0VPSzBVazVETlo1Z0ZY?=
 =?utf-8?B?Q0JleXlLdGIrRlRQamdZU21DUzN5eUFXN3hwZUoxTGxvN0t4YjBCekYwa0Rj?=
 =?utf-8?B?T2hjbkVYeThHa29OUTJzaW83SkNwVXdnR2lDeVl0cUZKWDhsR2IwUjlJa3pX?=
 =?utf-8?B?QTMyYlg2OVFoZGFuaHQ3ZU8rR0FDVGpHZnlpZ3MvdUdUNlg4UVJMTjN0VUZW?=
 =?utf-8?B?c3NscjdjZlFXRmRVdlF1RXpkMktNUkNGSlhCQjAvMkNSdkJXUy9ydnR6ZlJn?=
 =?utf-8?B?OUN4ZmRNTFVRMHVGaUliVnRLUGU1cHJpRTJjSTJ0VXZPdys1SkNSbmJaOVg0?=
 =?utf-8?B?dER5ajVHMUtJR0QwZy93dzFtZEVmTGFsZFFjVktEd3RjZ2FGdUxJQVFiT29F?=
 =?utf-8?B?Ykpmbk13RmN4T0ppQ3N6QXFYMGVuNVB2THY2dllobXh4VjhyT3M4YjdzSkdP?=
 =?utf-8?B?UjNGMTFuSWUxSkJpVC91L29mTHpaVHk0MkYydFZKZGgzZU53T1ZTL1NuSmo0?=
 =?utf-8?B?dDhXSE5UZTBmWDg4ajlVZnlqUml0WkFkMzdMdFN4cU5IYVB6aGhtRU84RnN5?=
 =?utf-8?B?cmN6UWhLZHkvQXJLSVBONHFJMDBpRXR6NjdpSU9EWVV6TzRPZlBoTDlBbWx4?=
 =?utf-8?B?b2NnbnBhUkFqTzV3VGNydXFVcmJTZHF4UHhZSURoU0hETUFaWEhUazdXNW9u?=
 =?utf-8?B?ejUzc2FXM25oZ2Y3dzYyT1pqakxTa1VMN1NIZm9Tb04wZ2RKVE9tMFZ0ZWhn?=
 =?utf-8?B?VHZLMndHYnJtYVVmRitQY3ZzdEN6UGdLckpjYU1yV3JJRGtMZ2JUZisxMms2?=
 =?utf-8?B?VHk4MmtlNFpLb0hUTVlWelI5UDlDbFdveHBJVzV1aWVlR1ZVd1V5dmxabU5i?=
 =?utf-8?B?UkxvdnVrS2QyR1ZDWFpKUkJUejN6NE82QU5oNEF6aDBzRE5TRkF0YjhxaFRw?=
 =?utf-8?B?YTQrU1VUazRUcEQ3SUxvY3dPSE1XS0lza3pjU2J5VXdycGJ5L05SYUF6LzAw?=
 =?utf-8?B?dXc5TFV1TWQwK2tZYTc4NDNYN2IrcVF5eHlJa0J6TlJPWGgyMEFOazBlWnlJ?=
 =?utf-8?B?aE5WMGh5VEsyclNMZi9lWVlVRVlQVWZrcXJIMExXODgxVDFWbnVuVEMxQkQ3?=
 =?utf-8?B?VjROV3hoaUYwS0Q1TFFmTk9PTERvQTcwSTJJazNnc3cza1hnN3pWS3dOMmpk?=
 =?utf-8?Q?ZCkGpXOt91gytctj7eNAMmZn1r2zZaZXvwH7FQw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5088fe7a-4a06-457e-2737-08d91624d828
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 15:36:15.4067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XH8zAmWGn804Go8RdPWK3GUAuYztzrGcN1TBKHTlwa3MnlvcoidMkhGYmULW2nfB8CFp3FKpYvGuaEaIeUWUZnXjxwz1Fo0JKg/09ieLc8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130111
X-Proofpoint-ORIG-GUID: cizdX3VJX_d5FOeAwj3kNbnAhjsr6zuL
X-Proofpoint-GUID: cizdX3VJX_d5FOeAwj3kNbnAhjsr6zuL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 11:49 PM, Shin'ichiro Kawasaki wrote:
> The BUG message "BUG: using smp_processor_id() in preemptible [00000000]
> code" was observed for TCMU devices with kernel config DEBUG_PREEMPT.
> 
> The message was observed when blktests block/005 was run on TCMU devices
> with fileio backend or user:zbc backend [1]. The commit 1130b499b4a7
> ("scsi: target: tcm_loop: Use LIO wq cmd submission helper") triggered
> the symptom. The commit modified work queue to handle commands and
> changed 'current->nr_cpu_allowed' at smp_processor_id() call.
> 
> The message was also observed at system shutdown when TCMU devices were
> not cleaned up [2]. The function smp_processor_id() was called in SCSI
> host work queue for abort handling, and triggered the BUG message. This
> symptom was observed regardless of the commit 1130b499b4a7 ("scsi:
> target: tcm_loop: Use LIO wq cmd submission helper").
> 
> To avoid the BUG message at smp_processor_id(), use get_cpu() and
> put_cpu() instead which disable preemption.
> 
> [1]
> 
> [   56.468103] run blktests block/005 at 2021-05-12 14:16:38
> [   57.369473] check_preemption_disabled: 85 callbacks suppressed
> [   57.369480] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1511
> [   57.369506] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1510
> [   57.369512] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1506
> [   57.369552] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369606] CPU: 4 PID: 1506 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.369613] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.369617] Call Trace:
> [   57.369621] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1507
> [   57.369628]  dump_stack+0x6d/0x89
> [   57.369642]  check_preemption_disabled+0xc8/0xd0
> [   57.369628] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369655]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369695]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.369732]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.369744]  scsi_queue_rq+0x38e/0xc40
> [   57.369761]  __blk_mq_try_issue_directly+0x109/0x1c0
> [   57.369779]  blk_mq_try_issue_directly+0x43/0x90
> [   57.369790]  blk_mq_submit_bio+0x4e5/0x5d0
> [   57.369812]  submit_bio_noacct+0x46e/0x4e0
> [   57.369830]  __blkdev_direct_IO_simple+0x1a3/0x2d0
> [   57.369859]  ? set_init_blocksize.isra.0+0x60/0x60
> [   57.369880]  generic_file_read_iter+0x89/0x160
> [   57.369898]  blkdev_read_iter+0x44/0x60
> [   57.369906]  new_sync_read+0x102/0x170
> [   57.369929]  vfs_read+0xd4/0x160
> [   57.369941]  __x64_sys_pread64+0x6e/0xa0
> [   57.369946]  ? lockdep_hardirqs_on+0x79/0x100
> [   57.369958]  do_syscall_64+0x3a/0x70
> [   57.369965]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   57.369973] RIP: 0033:0x7f7ed4c1399f
> [   57.369979] Code: 08 89 3c 24 48 89 4c 24 18 e8 7d f3 ff ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 cd f3 ff ff 48 8b
> [   57.369983] RSP: 002b:00007ffd7918c580 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
> [   57.369990] RAX: ffffffffffffffda RBX: 00000000015b4540 RCX: 00007f7ed4c1399f
> [   57.369993] RDX: 0000000000001000 RSI: 00000000015de000 RDI: 0000000000000009
> [   57.369996] RBP: 00000000015b4540 R08: 0000000000000000 R09: 0000000000000001
> [   57.369999] R10: 0000000000e5c000 R11: 0000000000000293 R12: 00007f7eb5269a70
> [   57.370002] R13: 0000000000000000 R14: 0000000000001000 R15: 00000000015b4568
> [   57.370031] CPU: 7 PID: 1507 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.370036] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.370039] Call Trace:
> [   57.370045]  dump_stack+0x6d/0x89
> [   57.370056]  check_preemption_disabled+0xc8/0xd0
> [   57.370068]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.370121]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.370178]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.370197]  scsi_queue_rq+0x38e/0xc40
> [   57.370224]  __blk_mq_try_issue_directly+0x109/0x1c0
> ...
> 
> [2]
> 
> [  117.458597] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u16:8
> [  117.467279] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [  117.473893] CPU: 1 PID: 418 Comm: kworker/u16:6 Not tainted 5.13.0-rc1+ #34
> [  117.481150] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 8
> [  117.481153] Workqueue: scsi_tmf_7 scmd_eh_abort_handler
> [  117.481156] Call Trace:
> [  117.481158]  dump_stack+0x6d/0x89
> [  117.481162]  check_preemption_disabled+0xc8/0xd0
> [  117.512575]  target_submit_tmr+0x41/0x150 [target_core_mod]
> [  117.519705]  tcm_loop_issue_tmr+0xa7/0x100 [tcm_loop]
> [  117.524913]  tcm_loop_abort_task+0x43/0x60 [tcm_loop]
> [  117.530137]  scmd_eh_abort_handler+0x7b/0x230
> [  117.534681]  process_one_work+0x268/0x580
> [  117.538862]  worker_thread+0x55/0x3b0
> [  117.542652]  ? process_one_work+0x580/0x580
> [  117.548351]  kthread+0x143/0x160
> [  117.551675]  ? kthread_create_worker_on_cpu+0x40/0x40
> [  117.556873]  ret_from_fork+0x1f/0x30
> 
> Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Cc: stable@vger.kernel.org # v5.11+
> ---
>  drivers/target/target_core_transport.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 8fbfe75c5744..9ed5d234acd8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1415,8 +1415,10 @@ void __target_init_cmd(
>  	cmd->sense_buffer = sense_buffer;
>  	cmd->orig_fe_lun = unpacked_lun;
>  
> -	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
> -		cmd->cpuid = smp_processor_id();
> +	if (!(cmd->se_cmd_flags & SCF_USE_CPUID)) {
> +		cmd->cpuid = get_cpu();
> +		put_cpu();
> +	}

get/put_cpu is ok. I just had a question if something else is normally
used for this use case.

Does the get/put_cpu calls handle the case where we are running on CPU
N, then because of a preempt the thread we are calling this from gets
rescheduled to a different CPU? So it prevents the issue where after
the preempt we think we are running on CPU1, but we ended up on CPU0?

For this case/code above, either the caller of this function has pinned
the calling context to a specific CPU or the caller does not care. So
for:

1. the pinned case if we got preempted the thread would get rescheduled
on the original CPU and we be ok right?

2. the don't-care case we could end up on any old CPU. For this I think
we will be ok without the get/put_cpu preempt disablement because the caller
does not care and we just need any old CPU value. Basically after we set
cmd->cpuid above, later accesses will use that cmd->cpuid value for per CPU
structs. We just need the cpuid value for this "don't care" case because
cases 1 and 2 use common set/lookup code.

Is there something else that's used normally? raw_smp_processor_id?
