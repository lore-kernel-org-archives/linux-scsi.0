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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7908CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 607E5611CE
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhIJQkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54266 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230142AbhIJQkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ADtSXO013678;
        Fri, 10 Sep 2021 16:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ermdxKvFV9JWJbi2XHvPVkWjU5DlOiI75ae1Io8dAGA=;
 b=PfMeGmSOCYmv4HbY748HLzPig8Zr+DL9YOaaSjThXIivBpADfjHOruEE6SKo2XBLuwru
 OIHFTnlujJtWVzGpIrLdoPH/Tv4dyvvIZ5RHYQajTkrW49yrHN+Mgr6eXksmUwJvvrRJ
 mEkF1PfKWcAxQxiBhJoOu2usk1walvUu4H/8tljqfMQZk5YGDMW+GV8cSN2ct6kCn2L6
 WvcNMXUxul7PJ1lUN0czSxEugJh8IVyliyQLZxB35yM3I9+L+2ByxJdzn6uWZgPG0YoB
 asrwjyM97f998tP9qK+g316AWVzXlRHbT5NiHkUUW0pjIs4A946R+4WXsRbWgbstZfoJ gw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ermdxKvFV9JWJbi2XHvPVkWjU5DlOiI75ae1Io8dAGA=;
 b=DwF9pA9Judej7u9UG2j3Hlmfjm64fWdl2EB5m/0yVzjC96T+dheEfRET39Cemi26BSlV
 36qGS30nQlq4iu9/A2RqZB+IIZzloURu5/zFvEIeX0NdTv6YtlJz9JnzUmLfj0sAgBX/
 bG0zH3BXVx8SlHlaQnpT0jDF/iJPfo8TQwk8U2pSiWNowoPupARmiFZBVQ8Jz3Z6/uZv
 yzcm6OOk8Mxj6kY7KVmjZ7Nk+k/FnSNGjszCk0eAMmLb8d15/fsc+SKUIXzjLq0bi8/V
 YxhdIj60slkbRLBOSRegYltQB4qLbLpM76fjKHU89tMBm0ezfK2P5OWf7LhkTWaPb/95 +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayty4afkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:38:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AGaAVs020523;
        Fri, 10 Sep 2021 16:38:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3020.oracle.com with ESMTP id 3aytfyhm12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:38:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xo9fgS5GJoqNKo8DhSZXx2CouMt7WrfXSTN6Oy4txVr0notTiNUCU9waqT+oC4iQ4oQYz2nO2Ig1gkFjUB8VKpZBsuaOcNeWTtnG7/ueleI0HYXiqFOWyA/GDL/FI6hMvvTpIVbnhKF+fN5tR8hLt1Al5zeONU33ehdsRSIQ61JieghIW2/XSY6SUB8sOxKlyt9FIdF2Jtx/4yrbIE/RZTJkXGHN58bQGi8+o95QfFWX1STiz9Fp2eBA5Sgt/rdpM7k1aw+fOkJ6+5HPiuF92kWB2verKg/HPKmTCjWWHVAg2i1w/DSjwWvQjnZ70uMaPHquwWav03fWinMHtB65/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ermdxKvFV9JWJbi2XHvPVkWjU5DlOiI75ae1Io8dAGA=;
 b=fhgrPJp7M9OCX7/4iTWY4TEOK/8KTkYJrNODOmEmYmMznbK0gxCk9wOrYmsiXIZ0yIDVnuop+jqtUVdPPqY0lufgGXnzEl0Qpo5B8VZKZpteSTxKB8r6J9CQexZEW33t6ouFFajbRG7bjYHarLs9uSfC9kbsIdsbwceBiPAkdHJ18mDUDLTjjMKh2Yatv0N7u+aVrC3Xvr+eil+UlvaHmbbfqYfHfysTMiwKV2i/en3WrWJs9pywso8TmOwAkEs40JilWUd1W0vyDNjRPs+eBOQWl0Snfy97rd5J9uemqTK2hpYwPYcmEggvSXli2CFOxcYRM1x3w87rRzQS41HDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ermdxKvFV9JWJbi2XHvPVkWjU5DlOiI75ae1Io8dAGA=;
 b=xPfc8aUKQ+fiPkxeSO3fTw2jjTBVxac3mh8wsbWEouw2kFJpR2sGphjb1ST3feh6x/4bSbbj7wf9gBgHGWuWEjJWx94+DyT0RJAgpSgiQ2EPS1Uyrq4SEN7xWLv94xMZERgg2exBkwgsvaHccfW4AuKdekhnYIHTN9QaecErbX0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3654.namprd10.prod.outlook.com (2603:10b6:a03:123::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:38:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701%6]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:38:54 +0000
Subject: Re: [PATCH 2/3] scsi: libiscsi: fix invalid pointer dereference in
 iscsi_eh_session_reset
To:     Ding Hui <dinghui@sangfor.com.cn>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
 <20210910010220.24073-3-dinghui@sangfor.com.cn>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <302af74d-5b72-5b2f-050a-33f0978e321f@oracle.com>
Date:   Fri, 10 Sep 2021 11:38:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210910010220.24073-3-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0016.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR12CA0016.namprd12.prod.outlook.com (2603:10b6:5:1c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:38:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b23e0238-5e40-4dbf-b388-08d974797a43
X-MS-TrafficTypeDiagnostic: BYAPR10MB3654:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36540CE68AF9A7B5A52AAE94F1D69@BYAPR10MB3654.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gbec1mc0nAqLb00ePe3jVhteyU1psMlAp0qJWS3GPK2sXQqwomc+bZ1Ynu0k5FV2pw2hEuGtsrL5oeo+k/G9Bv85UlWA3KrwQaW640k3yMSyvuGYZAF1TgtDkh4er62r8DqfgKxNBq1lioGgUbzgBUHKm7FSkuTNYelJWRaccyD7Suqukx3NMqUiMoymjWolQ0q5sgBdBx6UHrgJCZvnvV8bA0eguZAvPy1sTFhojciKzuEayQRf5xeyn2X5fA4SYouixGZVD82SbWwT6HYmYtym4EI9Mwg6jA51Z3wvaNaNU2EEXvRLaYKIR80KagXUZ8tIsI88QrBKi6HyHWFP6lobTUdFVkCczvvcsQB4qn7gAGW5xM2O68mmkqKfho+QRMr3cN9hUcqVuILDK3U1i8YMwviyKoiiNstR7khW/9sFHzV1jsOj2ZpRaqDD6e384xRlUQiwVCsWGN9WGPJWfSd7HJWuxF/mB2pDLsRluQL6HJssar0a8u1ECnPmHxeihbja8Dz/xN0ClNSIu3C6f20Eq2Q9Fp74OAinR1qoKBECwYXIudUEDJcmFQF13FjUNXCjhBy0luKe+VpgUs6+bgvBouzHLzhfQu+fABynvW+VnrGKd2xoufI0KGv+I5/8qzi9iAGKumnGfcMF8jS7zQNQc0R99LbhqSbhtkUysRqLsPjdQyk7cjlINSxJbiHi+Q/9oqvqrrskT86oNMY4C0CmcmEVP3OEj6APYDsBmaTrD8ETGVIDI9y6vFOYXzK5gRRC0vQY2JGc3o4AHeJzAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(53546011)(8676002)(36756003)(66946007)(66556008)(26005)(83380400001)(16576012)(186003)(66476007)(316002)(5660300002)(8936002)(6706004)(38100700002)(31696002)(31686004)(956004)(6486002)(2906002)(478600001)(2616005)(86362001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVBvdVlmZEhKSmQ1c3BNSjVRSFpFQjJSTDJKRDllRjFtYThpUHZUVEFGOFZt?=
 =?utf-8?B?QkV0d293SndVb1hmbVkvcWlqSWpsMGNQaFgvUFZNSytnUDFWQmhCVmd2cGJN?=
 =?utf-8?B?NFJ1MTk2NXpTdmEvS2ROaENsSmJrYzZUM0xKdUdHVUVmVG5PZTkwd0ZSVlJ6?=
 =?utf-8?B?R21kL2hWTWpwTzg2WVJFQ2REeFR5WnE3YSt2VDEzZzZQbmVNRThtVWplVnR5?=
 =?utf-8?B?QzVESGZqenRqWDFUMUxmUklqT1ZQbWYzVHJpVGtQd3d5THZ2SERpa0grbWJK?=
 =?utf-8?B?T1ZhN2M4bFNQNnFKc0NPMzVyYzJtd3EwQUVDaFM4MEp5Y1hvUENuQW9iZTRC?=
 =?utf-8?B?K25CVzFpSHY0WC9NZUhDQnNOczltUmRuYms1OW51MmtxdGdUc2lPTUdHS0Vh?=
 =?utf-8?B?N0k5aDZNZWlKUUJHVDZUK0J6YTBrSVQ4ZkxJNnNwMlhrYzFlUndPUzNPZlA0?=
 =?utf-8?B?eEMwZjZMdjNBU0tWSUhhd0tHVFBwbGt5ZENhRm4zcHRwVlFPZWhROWErQmJM?=
 =?utf-8?B?b25UWmxTTE9Uc0dMSThmVEdCTWdWQkVqSmNSVEpaVjRIdWJJekl0Tzk2WjEy?=
 =?utf-8?B?UkE1OWd3V0FKektLU09qd0dIRWpzMHVTT3JGQ3JEbnAvWjdYSkxVTHRSVnNz?=
 =?utf-8?B?cVFSS1lXV2lHVG85Q1hMMjlQeUJSTzZZaXZjYnZ4ckovUE12N3d5Sk9tL0NV?=
 =?utf-8?B?bW55U05VaHEvUyt5SnV0QzZtS0o4cXlZTWpLK2x3T2ZNeUdOSi9ldU1tRlhw?=
 =?utf-8?B?THozUFA2eDBhOUQremdOakh5eTdsNlMvaGFsRHFlSU84M1VQZndYRWR2MVNt?=
 =?utf-8?B?d0FyWXlFVytMVEhXL2FtQ1MzV1c0RG1MTTlZbWJ6c3NGVXovaWJGSlNQTXp1?=
 =?utf-8?B?Z3lGdzIzc000ZUlLWGZFdlNkMnVoY1NyWE1iZFUrbFAyN21vTmtsQzVWNm92?=
 =?utf-8?B?WmhhZ1hjRkkxcm1pamFhMFQ1YmpoS05USzFVSk9YSVN1NGd2TmhXVDExNVVi?=
 =?utf-8?B?UzgzaXJuenhwZHBmRDFVS256OEI1dUdMYXM5TmZ4Mzk4N2NZbVhiM1RkeE5E?=
 =?utf-8?B?NjUvc054eFpiM0ppOElERzFXWVJFclFYNWVUeEZya3d2bHVaa2pIaGMwV3Uz?=
 =?utf-8?B?SllNQ3hHNjRaV2VlNS9JZG5GVVJBOFhhYkhyd2MyZHVYdWJLTzA5SE1NSnk2?=
 =?utf-8?B?QWdEUjJrOTk0MnFDcDdMU3Y0TU5rUkNvMkoxNHAwcHI0a3gvMGxINEdQY2pU?=
 =?utf-8?B?ZFd5RVoxOWRYQk9MWjdmTGNwcW1Fb3V5UXBwd3lsRmg4MW1oWUFPOXlhR0kw?=
 =?utf-8?B?aFlMMW5iKzdFSEtsdlprbXpiWElaR1ZpOTBXUkgyd2lIUGszYjYwZ2N2V0NN?=
 =?utf-8?B?dXMrUTZBMFBEUnl1cENsN3JOUmlObmdMeVpaNThZOGp2bEtVekx2L3UvSEdN?=
 =?utf-8?B?RmVYck9YcUp6QVpVMHZScGlvczAvWURXRFptMEZYR3ZlUU13aExIbFgzMmFr?=
 =?utf-8?B?b3hBL1NYem0wRGNZT2V1VFdzT0pIYTJOc1ZZNFhMYzFSK2ZNT2pQeHlqcWl0?=
 =?utf-8?B?dTE5bllPVE45ZDE1dk5FNjRDaUlsVDlCYXNld0tORC9hcGU2ek9QaVFUVThz?=
 =?utf-8?B?cjdvcVJ3SGJ6akNjZTNrTnpDSGhVMksyTVdBaUhxdldBaU91YXFJTSs3WXBB?=
 =?utf-8?B?VlJrSU4rTXNUTkZ4MlZvb0hWL296eXBkVjRWeWdsaWYzMWw5dlBvd1ZPWHRJ?=
 =?utf-8?Q?hxAl83pcVjszTyfCd/G55keBOQV4GQs5W710r8h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23e0238-5e40-4dbf-b388-08d974797a43
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:38:54.2107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsgoDcL5NwhQP2ROl2zUkCHM7VwyLjVK5fhDSGD0zosYvWEieIWh46vCwEC2z/Itx2+G5UjHK8CYXcMCdZjTLP9G22xElit91CM4umWsPRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3654
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100096
X-Proofpoint-ORIG-GUID: qhTS5LhwpI8AFUlHbqJuWVrlcN-R9YR9
X-Proofpoint-GUID: qhTS5LhwpI8AFUlHbqJuWVrlcN-R9YR9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/21 8:02 PM, Ding Hui wrote:
> like commit 5db6dd14b313 ("scsi: libiscsi: Fix NULL pointer dereference in
> iscsi_eh_session_reset"), access conn->persistent_address here is not safe
> too.
> 
> The persistent_address is independent of conn refcount, so maybe
> already freed by iscsi_conn_teardown(), also we put the refcount of conn
> above, the conn pointer may be invalid.

This shouldn't happen like you describe above, because when we wake up
we will see the session->state is ISCSI_STATE_TERMINATE. We will then
not reference the conn in that code below.

However, it looks like we could hit an issue where if a user was resetting
the persistent_address or targetname via iscsi_set_param -> iscsi_switch_str_param
then we could be accessing freed memory. I think we need the frwd_lock when swapping
the strings in iscsi_switch_str_param.


> 
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 712a45368385..69b3b2148328 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2531,8 +2531,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  	spin_lock_bh(&session->frwd_lock);
>  	if (session->state == ISCSI_STATE_LOGGED_IN) {
>  		ISCSI_DBG_EH(session,
> -			     "session reset succeeded for %s,%s\n",
> -			     session->targetname, conn->persistent_address);
> +			     "session reset succeeded for %s\n",
> +			     session->targetname);
>  	} else
>  		goto failed;
>  	spin_unlock_bh(&session->frwd_lock);
> 

