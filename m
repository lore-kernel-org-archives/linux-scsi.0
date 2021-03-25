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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FE1C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6961961A07
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCYRZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:25:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhCYRZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 13:25:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PHJSSR005724;
        Thu, 25 Mar 2021 17:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=T8YL4eF2kcczkHsUhRaBlBmkXd3lkkJoVQHr0AXgVo8=;
 b=t+x2wVcAESz/kcC3RFME9bXt/22/OfQRo7Gm5xAAo0W1OnZUKU6vIjRxQ2SW9bSfr7dT
 wXgGCb2hdwAxbHcmoh8PIaEVxaSvdf0fZP2BbRe2kE7HE7SSgfxCFgaoUsZ0n0cA1pbR
 fpqB6Mgth+451zBK15NYnaGEl2wyWRn+fWOY7ySEY5l/YzWa2TgTKRNIlFkFJ5tmKKO9
 ggo3ampjdN+UQY60fzS1ISXSCMHSqJqBA2cM7kp1hrMGgQ7iyAT+F2BTkWutFcB6CGF0
 dkUTETL3pu/cs1UixgJdP8M63mSlLbBeUqwdobwXSvLlB/TeDCqOLt5uyOkrNcYwyqGy qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mq3qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 17:25:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PHLKXt072618;
        Thu, 25 Mar 2021 17:25:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 37dtmsdd0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 17:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+juOweMJokxXFgwyWCpTlrsyp46bvJd10cbhi7dI25n+m+dW8jAHGmWvhtNUur2YWuWn4S2DMKzpIs4XTY8JKMN+P/LTKH+JNVK00fndxsnLqOMRb8Lbw+PXb+41MACJ+VCIffk9ZsVyW7Jyx8dzDwQMlZNcvxV76Ncf8vncUED03bJqKhPfaRSjcE5pcE747Kp/YqXREw3LegNZCPeGhSeUeWc7clgZK9DO7rvzgALi9NSCCxhWlvrMy2GEIPLPlC6YyaNjoBiW9rT2fVNGPmHjeSmkO/0tOZfySdq3ZSKPrU/DhA4Ld1DqP+glR5AIB/TKRSDlB1Nelmmvj4GAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8YL4eF2kcczkHsUhRaBlBmkXd3lkkJoVQHr0AXgVo8=;
 b=L5rZTtUpfybfPUVF47AdjemV8Crpz0wFF3hpwx1jINCK20RLD6yHjss7RhlIXARcrx8eEE+zAcxsw/FMlAi9PdrOMQm+y+Q0ibNtm0+NPMij7R/dB2B5CWOgdD+DV1t+2zCoRHzsHe0y7k58uIWnDaJBEjljti7zc8+0G2HIVClyCIOY9vhtgmqqP4/zPHqkGNBf6luX9q0LdVUJafFzABYWgxQ8x36+jEpa+QQ1I5GDiYHDOz0QW4u+GyhIjX8Kbp0ya4hiL/Swy366Vp1pMsfoCpsIKBd6LgqAJON8GF0RGfNl1OHldQRS1JdyguT357q3FIdJ7PYASyPP7dZJtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8YL4eF2kcczkHsUhRaBlBmkXd3lkkJoVQHr0AXgVo8=;
 b=gKBdXzI/LRFS35krB9fOIQfRBiSNZs9dCfy/rvr3T0fqzF99TUQcZzzMdty+udkufi0BZU+b1AzPRXAg9J0DZkO2a/+OxiWa+CXobqOO68v+tGFi+IUmsGF/SXZbXn5LdjILNJvV4bltjD6AzVRUUsUt155V/QBaNuk7Te4TESo=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4607.namprd10.prod.outlook.com (2603:10b6:a03:2dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Thu, 25 Mar
 2021 17:25:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3977.026; Thu, 25 Mar 2021
 17:25:01 +0000
Subject: Re: [PATCH] target: Fix a double put in transport_free_session
To:     lyl2019@mail.ustc.edu.cn
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
 <9d02b016-c924-79e3-9593-c073da0c769d@oracle.com>
 <7378433a.12fee.178685ae745.Coremail.lyl2019@mail.ustc.edu.cn>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <845eb103-34b2-9e6a-a3ce-0755d487dd8a@oracle.com>
Date:   Thu, 25 Mar 2021 12:24:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <7378433a.12fee.178685ae745.Coremail.lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR07CA0156.namprd07.prod.outlook.com
 (2603:10b6:3:ee::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR07CA0156.namprd07.prod.outlook.com (2603:10b6:3:ee::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Thu, 25 Mar 2021 17:24:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec9091d2-19d8-49b3-4c2e-08d8efb2eb59
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4607FCB5F8D2308D0A58004EF1629@SJ0PR10MB4607.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCxGo/1J3MHurlB1d5bnmFpJgOE/3McR3uyMCHHWXLN4v0kwhnVRaWRaa2wpla8u4XOwuiCVpxlV/1S15/QR86NnhG/ZIMXrBUSqeZSQ5zquGIgn/xw0Y6wO7gvFRJaX64F9dRsNuXAFEaqkFLWk4SUHdSP8mgJu34/Zn74iw+TsV0ImeYlETK+ssRywMfk/n0OMe7+NVufQgHGZ0KF+WBEPpdrSPdSNuXUgKfeAcozsDqlQEUrzdVxHgK0Pa3M2g0wQygJ4uj3XqnYyC2gwhMRFlXh57J4fGe1Y5OU7IwWQLDan2VrN/iDnKbH+lNHUwI3bxORZdhRpbV8QWtyNnfqDBxHzSedHJatqPJEeStAdwWhmYQ6QGtP5YUXW3mCLFw4wyVHTA2ufVNfI/QZ4HoJDTwoOKJsgLKxhlsC5TKe9wOB53tue200OYs/PxPIgRGgVB386PiHmpVahlwdufee+0x6JwwRqnGwEBCvDzrfcLIx+ZLFesZEcz17GQvSr3BLjK9kJlZ7f27yVsasazMI/2ubakLlWXITgsvbwaxXs2jLmxhuY090GEv/IJO6PDNfbRZge4povTERUpyy00q+ei9MGjbPHFyVVpdT5akquHduRMIX/v1asScKM1RTNi/vVWWQxQ3SREc6PbJ9S6nAki+JdOmAZssr9FV1RIHjzYO1ZhX9rvShG/OWvAfEQOI41bPlJz6+VM4mSHV/c4EGud+PjSJJ1hdkg1as2Hu1BAn+CCpa4zWlXfWo+AdMl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(8676002)(5660300002)(8936002)(478600001)(31686004)(86362001)(956004)(2616005)(2906002)(53546011)(38100700001)(6916009)(66476007)(31696002)(6706004)(186003)(16526019)(4326008)(6486002)(83380400001)(36756003)(316002)(66946007)(66556008)(26005)(16576012)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3Z0RlZKTEM5VTBkSkVRajJJTTQzbXRrOHUvaGtQT3VheFlGVjFSejFMMHJp?=
 =?utf-8?B?RlNwMWhrOWlmc1UxQVF2VUlETTVMTTBPZ29BMU5BenRSWFE1K1VFa3VvaGcv?=
 =?utf-8?B?dCtYcUpjWWEyYkJsSmNONkRMQ1lDYWxEZmdpR2tHdDFhRDhGUmVTSHFZR1NI?=
 =?utf-8?B?cFA0SXorSzNsbFZVZStsUFl5R0lGVk11cGJmdVlyUkZ3NC83aVd5cXQ2ZW5F?=
 =?utf-8?B?L3FzVjlVY3BNSC9RdmtYSVlUSnpZOEEzNU51ektqMmRoNGtXVzF4b1FZQnl3?=
 =?utf-8?B?QnpWcHRPNjRWdGM2dUdCbittR3p3RHVDU3I1SjVveG04cnlpTUlGaVFSWVZ3?=
 =?utf-8?B?WUJlYUlMMVRLbFlrdTBHYmx6b3pJeDBXVE9FRGRJeTQrVk9mZFBNUnZBaE5y?=
 =?utf-8?B?dGxSU0QxUXRqOFZjeVdIaVNQMXEwSERWV1UwSXVNbExJZm5XVk0ySTY3dG03?=
 =?utf-8?B?MTM5U1JySTNCYjdDMkI0eHV1WER4cm1LcDExM0tJalVQNTQ2eCtZRU11RWFn?=
 =?utf-8?B?SkhwS2p4S2pRRENyU0Z5d0lZcXNuRyt6czNtS2x6M1B3LzN5TDVvVnNyRzlw?=
 =?utf-8?B?ODdHNG5saWk4K0o5TG02UFNVNC8zUE41SVJTM0FpLzBHcXNaek1YL0tjVUQr?=
 =?utf-8?B?d1FTM0N6elFaa2hOL0dpRzNDcW5hQU1ieENOQkI0UTdUTC82cEpEOHpnbi9l?=
 =?utf-8?B?MmJFWE8yU1FHbzBpbTQ1UHZ6RGJ6QUlYK3dpa1FTR3duT2UrV29KRkF1YmtG?=
 =?utf-8?B?U1ZEUC8zRmNMdk95RVdMY0tqWEZMZFhFSEZUWndKanZ1eG9hY2dPb1l2WXU0?=
 =?utf-8?B?MGw2ejRZZ1ByOGwyWkFkMkt5VFhUbW5QUXVMazZkTHBmQ3ZqMGpuZFg0SlpI?=
 =?utf-8?B?MkRPWWJtcjNqeExPanpaM3AyQjNUVkFVZWFRRHBYcHQ3SWVXZHV2QTRaQ3lp?=
 =?utf-8?B?RGtDNkxUTDVWdDBBaG9mTzdsaXNJanRRczE4VjJVODJaRFhhdVhYeGxEalFh?=
 =?utf-8?B?Sm9NMjNQRHJtUmh1QUxWL29RWnhSS3ZycEh1ZUlHTHJsUkwvbXhhU29iR1dF?=
 =?utf-8?B?WTk3MVhGS2ZXRDh5Z2ZjdDdMeFdHRVlkTWsyWlZ1VXVLTU0zMENyU3pZRWtT?=
 =?utf-8?B?ZTRBWnNOM1lJT3RQOTByQUpZcTVPQWNiZmhuNGZwRjVzcXBjVmU1NDd5Y25C?=
 =?utf-8?B?amNiNmFKRS84VHhKK2lpLzVINGJEc1FUUUc3dG1ac0U0UFgzQjNsenllOS9X?=
 =?utf-8?B?Z1dPWHM3ZzhMbWVUZGgxYis4MlAvczRpRjVxL3BublRTaUowaFhVMnNReUZH?=
 =?utf-8?B?dTQwYVpmQnBIQ0FaQytDbnJSL2t5TmluVkl0dWZlTkt2OGN5M1RRTWF2NTFU?=
 =?utf-8?B?R2NQYmVmUEcrL3lZdis5QUYwVFkySUZkTW5Wei9OVUhFcFFpaEZ1eUJQQWVP?=
 =?utf-8?B?MkhQTVY3YjVMNUVSTTJ5RS90UC9LWUpJamJBRy85NnhOeTZXTUFUcGJWUklz?=
 =?utf-8?B?N0xVRlpNOXcvRWNIUGxDVEV6LzVWZHlzMS9wNVZZRDRZU2Vnd3dBM1RIOG03?=
 =?utf-8?B?QWgvcjhXWU5nV0NFaUttb2V6NnNya3FtN1A1dGtZclBPYkVGZ3J4eEg5NXlo?=
 =?utf-8?B?bUQxS3hnQXVyZHB2S2VPZlBGKzlaYklVMDQ2dUhrRWVDMjl1djQwa3UvTnlT?=
 =?utf-8?B?UlVOYVk3YXdtWUNub0FVQk1ydEtzSytUVlhLNzZvcFVLVkQzL2ZhUTFIc3dC?=
 =?utf-8?Q?BrDdrX4uHmKkS08vqsp1Qp/KrkxYCGgDCQVRVKj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9091d2-19d8-49b3-4c2e-08d8efb2eb59
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 17:25:01.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeycixYiDLk1obuE2P5RO3WJL347ES4C80xJRYf+VwYlNKFSAnd4V9A8XxMqUHJYdz7AM6iETBPnu+xZJCrhXvSvw2/EgRqgHqPbAZbYIGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4607
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250126
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 2:48 AM, lyl2019@mail.ustc.edu.cn wrote:
> 
> 
> 
>> -----原始邮件-----
>> 发件人: michael.christie@oracle.com
>> 发送时间: 2021-03-24 00:28:35 (星期三)
>> 收件人: "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>, martin.petersen@oracle.com
>> 抄送: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
>> 主题: Re: [PATCH] target: Fix a double put in transport_free_session
>>
>> On 3/22/21 9:58 PM, Lv Yunlong wrote:
>>> In transport_free_session, se_nacl is got from se_sess
>>> with the initial reference. If se_nacl->acl_sess_list is
>>> empty, se_nacl->dynamic_stop is set to true. Then the first
>>> target_put_nacl(se_nacl) will drop the initial reference
>>> and free se_nacl. Later there is a second target_put_nacl()
>>> to put se_nacl. It may cause error in race.
>>>> My patch sets se_nacl->dynamic_stop to false to avoid the
>>> double put.
>>>
>>> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
>>> ---
>>>  drivers/target/target_core_transport.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>>> index 5ecb9f18a53d..c266defe694f 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -584,8 +584,10 @@ void transport_free_session(struct se_session *se_sess)
>>>  		}
>>>  		mutex_unlock(&se_tpg->acl_node_mutex);
>>>  
>>> -		if (se_nacl->dynamic_stop)
>>> +		if (se_nacl->dynamic_stop) {
>>>  			target_put_nacl(se_nacl);
>>> +			se_nacl->dynamic_stop = false;
>>> +		}
>>>  
>>>  		target_put_nacl(se_nacl);
>> Could you describe the race a little more?
>>
>> Is the race:
>>
>> 1. thread1 called core_tpg_check_initiator_node_acl and found the acl.
>> sess->se_node_acl is set to the found acl.
>> 2. thread2 is running transport_free_session. It now grabs the acl_node_mutex
>> and sees se_nacl->acl_sess_list is empty.
>> 3. thread2 does the dynamic_stop=true operations in transport_free_session.
>> 4. thread1 now calls transport_register_session now adds the sess to acl's
>> acl_sess_list.
>>
>> Later when the session that thread 1 created is deleted dynamic_stop is still
>> set, so we do an extra target_put_nacl?
>>
>> I'm not sure your patch will handle this race. When we delete the session thread1
>> created dynamic_node_acl is still set, so this:
>>
>>                 mutex_lock(&se_tpg->acl_node_mutex);
>>                 if (se_nacl->dynamic_node_acl &&
>>                     !se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
>>                         spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
>>                         if (list_empty(&se_nacl->acl_sess_list))
>>                                 se_nacl->dynamic_stop = true;
>>
>> can set dynamic_stop to true again and we can end up doing the extra put still.
>>
>> On top of the extra put we also do
>>
>> list_del(&se_nacl->acl_list);
>>
>> twice so we have to handle that as well.
>>
>> Is there also another bug in this code. If someone adds an acl while there is a
>> dynamic acl in place core_tpg_add_initiator_node_acl will clear dynamic_node_acl
>> but we leave the extra reference, so later when transport_free_session is called
>> we will not do the extra put.
>>
> 
> Ok, thanks for your answer. According the description above, i think it is a false
> positive now.
> 

Did you hit this bug, are you using an inspection tool, or did you find this by code
review?

I think there was a misunderstanding. I was saying it looks like a race could happen.
There is no protection in lio core.

I think it's hard to hit because most drivers do not allow the combo:

tpg_check_demo_mode == true
tpg_check_demo_mode_cache = false

It looks like those settings are allowed with tcm_qla2xxx and usb, but:

usb - has a mutex around creation and removal so we can't race.
tcm qla - I don't know this driver will enough, but I cc'd the maintainer.
