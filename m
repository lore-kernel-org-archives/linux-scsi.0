Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E479DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 14:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A7C6120E
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 14:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhDNO6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 10:58:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55470 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhDNO6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 10:58:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EEnmdg167638;
        Wed, 14 Apr 2021 14:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=X2353f5lok1byBwrhMZ/CHjlqykQiVMj26jRxAOEJg0=;
 b=IPoMTFWcWKPH3mcF7hsYbyFRMLzpv4xMtTxxnJVUg01Oct7Karwhn4zqepLSMoz4TeKn
 d4dIC3uLveXBSfekoMmCIMDqobfnXTwQ3FDBkU6VYJXIN3oGq/+EtwSwrJA1yYcvwH5Y
 prCqRm2ofCW3V7/iL00FsA/5yA1zFf/SB/QS/0mTrGbDnMAVG3VZtSr1m6jGZLvDhYmE
 5EDogCeHcWroEPDBzV+XNpYAv2xvVsA639Q3nTmX8V42q+pdnAR7EAsKsPXjXHR7+KNF
 h4sDScJNvlQz30myXQ6mNHV7nxHGY2x82tPZYdC0caw6ORcwY9E//6/RzdZPMaWZWqUv PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbjuxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 14:58:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13EEoWYQ080495;
        Wed, 14 Apr 2021 14:58:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 37unkr5qs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 14:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPwZ2lYNztw8LRn2k+qDsgPHRWLGLsZ8CNvV+b4NKisZEArG1lutVLedHZxC6X+9usTmBFjG3UD+WCfzT6H8/53lAFMIDskEZiaVoOWWqoMoVBI3HpbOM9PviVqFLb0jxB322RBa7LW/d7mGBI3iSV9IRrzYZ65h1PabqARgufYNaiETArBa34w6LkGLhDloMrTpGGv7RW/I25G9R4zeJs5yrv0BhVG0LilFL4HDIfaeZ87z+YQIFs/sf1ZDDERzYRW/CnqcCBnQWhAGvyhkLPevYAiZpq6qncybQnoKpphgKa1mzNMzKRo/wtysJYYzXfH3tQqJvR/UEJe8v0FeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2353f5lok1byBwrhMZ/CHjlqykQiVMj26jRxAOEJg0=;
 b=BeZXzfKjNqOqJOSxp0DK6u5xlvg49c9kRCtl7KHo0J3O94zOOtMnpcx0BdSm9j2xid51zghECMvooNkMux9OX/Bsp0fa3P6q6wgvZDA194SwQLLsg2Gahr7mt6WQL5Y52MZ3MlgUzCqQ+pKvZQA+Jr6NO6dcU/XoVInJpFbyZu/Vgr5wIvvZA5Jrr9FDH/mekG9JzPC0tBtqRtxL3PRTMlSpr9rkS4AynmpGtV2TFAyA65Rl+P6gZNe5plQsc8O/GgQriofmvxasjqvLtI01HM6XR002zTZu7JnXAkamDuen9+IJVvqJZbF6/FPA2J9b47DGzJA0xiJCpS9yIo9SxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2353f5lok1byBwrhMZ/CHjlqykQiVMj26jRxAOEJg0=;
 b=wik1OlK8YrEig0b+W3aJaITNB7gdn/G+93Rsu6Pvp0+FWLQVzC7HEVp8JqfdXQnqhElHMVCr0QpVWIg1guzpSbR7cNRdNAA6ljviu4iP3ddSm5GBkXEXuj4CkJI0qvWV32oAHnwjrWXCt/60nznfXwE/Zlzb2SEjozmRpYMiPz8=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4241.namprd10.prod.outlook.com (2603:10b6:a03:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 14 Apr
 2021 14:58:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.016; Wed, 14 Apr 2021
 14:58:12 +0000
Subject: Re: [PATCH 05/13] scsi: qedi: fix abort vs cmd re-use race
To:     kernel test robot <lkp@intel.com>, lduncan@suse.com,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     kbuild-all@lists.01.org
References: <20210413230648.5593-6-michael.christie@oracle.com>
 <202104142040.TbqxTho2-lkp@intel.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <80219786-9836-c09a-85d5-0d5f90522726@oracle.com>
Date:   Wed, 14 Apr 2021 09:58:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <202104142040.TbqxTho2-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:5:333::18) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0085.namprd03.prod.outlook.com (2603:10b6:5:333::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 14:58:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fdabd5e-7a23-40d4-d8fb-08d8ff55b9a9
X-MS-TrafficTypeDiagnostic: BY5PR10MB4241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB42415CE7688CD0362B8E2BF3F14E9@BY5PR10MB4241.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNzhzDsUmePTAPN0LqJ9x2vbwiAW4/gv1aHfR0jUMHzrZUPWVm8uQhnuUwpzHDH3enrxPA0WLjNG73dsomoptfRSTEVWKEIfBNXomt5NNX2ZwUr4B64GMdkRuXwwRCGfRnWsC2BJLcqqHBBSKESWgtNMF1no22+dmMRmmfzRJlUySIrI2tYSOJsSTMvLpols7LoYVUS9vAZYyBaXyRlu8Nd4PomUT/Sl9u7d2YUcPzSs1XtgP8Kf9enOnUA2cclqFpeCCrjqoYE+3rwJif4VLtqB1C/nRYe1bd4+4kryYAweIh3ICnb6TPLdme2JtWirTz/bLpyCVp6ATlVT2neuOndyNCxwk/rxfgC3D+PbvV3gCichGbYHHnaIkqF3M1pKi4kegiWD22PkQZmGvkDqLucJR00cMAPs1gyweIMdC5rKsBRskqiz0iE1OY7z01tG9XPrChQOAZLXj3OimvpqR8hVZhOM9TdZiocxgg1MLhJ0Ljn8aYYbUjREkAYtlof+TZedg+5lQpfpmiM06RcHUAlzEL3PNty3Fm9I4EaaOVpiyCEgVTnCrHpleSansDZlKMII3Oaaj8RHU9Y7l/BznXzYUQxMHOarrT6DxOAViEHvaXn0J+WH6WdV1gic69J4f4cCIR8IGuj2FcpQCqGgComMMrd0g9GgIi/TZFjqxNwUtvuTvR3PhP9AQrT1YfH/S7myfmIMl3YT5K2orz9DI3BKdh3UNURdBCacSithCY+tZEnpGtmf5R86oW3082lBtOrKtLrkFz/PQVq25r1VKvVzh2VebOx1lbhHzyTNheM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(31696002)(966005)(956004)(6486002)(36756003)(2616005)(38100700002)(6706004)(83380400001)(86362001)(478600001)(2906002)(8936002)(186003)(316002)(16576012)(31686004)(53546011)(4326008)(66556008)(66476007)(16526019)(66946007)(26005)(5660300002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?s8sJYk5/G1+QpCmLSujoQ22ykWNbGudKXwv9nYOO2LTKIHTJtXk6g3zG?=
 =?Windows-1252?Q?iMDTQq96n2SP9PPdWjT8aZ6kbmvWZ4JMQVWE8lyUOSClS+P/1Kiz6h0q?=
 =?Windows-1252?Q?hKIvLgN/WAp61UowL8Baxhvt1TRK/ndT7vBLXHS08WnXJssIzvqM+478?=
 =?Windows-1252?Q?rEtAHX9KZdw+ZRjulri1/cAnk58RS4dCm1g+64ESl2heXzy+vpZmIoFg?=
 =?Windows-1252?Q?h9MhClxzQvKPezjrkY7qO0IfHBSkq9ILqBPShvAvL8M2yQJ6tnReqa2O?=
 =?Windows-1252?Q?dJI91N9Nu214ATW/NgvHWDBJtSanJD4dwYBSyerN428KHvIaRueOA7n4?=
 =?Windows-1252?Q?90/a8VZsAB8PnbZGHs8bcn3XAKAASRDZIrm60tp0eGxgiRiftPFAgWhQ?=
 =?Windows-1252?Q?MdI0SMSWk3TUCc8cVHA9bWqGSNfgIhl3WM1JHZXE0BnsjeKtMAlkvfAq?=
 =?Windows-1252?Q?xG47Q2nYDnC0DjCENIiarPlypZYiuvrlhMIgtVTyPBpRm/lFlUFkDJuB?=
 =?Windows-1252?Q?gUWIGnqIgAgSWK4ZTp9bGTsqjWnWcHhaRtwbPIGhyxXpM1Rla9QgCCNW?=
 =?Windows-1252?Q?c/7Oz8ZRNbsKz6uh+qTbZEK4tbHvVEzjV/vj7jHf08pfdRM76vbxDL5V?=
 =?Windows-1252?Q?ZU+R1komSmkTiDhsK6PhtBr7Wb89s9VQwEJMEkK81l0s44SxwaDyHnCX?=
 =?Windows-1252?Q?0lTuaTr+m6G08zlekQUhBu05IBYCiNdcDNCOEAW9Jfzx6JTgxBqqs8Jo?=
 =?Windows-1252?Q?N+rDz4wW/pvK9Fg8maghZ0Y4SKXIKnuH8d05EQ3vdEGewtFUTtoebZpJ?=
 =?Windows-1252?Q?hN/lbl75z0KVgrzD8p6bSejwwpEMEkr9K3m0NOm4qcLab3uOvfMafjfa?=
 =?Windows-1252?Q?8102XFlbOOFy6y7KmO6aXqZ5JNDiFR+uRNgFzn8X+x+d/xLlwdHUYObW?=
 =?Windows-1252?Q?1hPRnaa2UBZyB0vh2ArU8M7HcKnIxW8qNUqSEuB+KJtNEiasPtPYm+Zi?=
 =?Windows-1252?Q?zDfaKOrp9CCx3aA6qfwya2Bpyw3OHa66y5vhlQ3LsHoziKUq3Dab8Eye?=
 =?Windows-1252?Q?ieTKt9HaWd/TpHBe4xxs0Jo7NJABHEomgyHz6sCobl6tfgmXJ0pP+Dcq?=
 =?Windows-1252?Q?o0SQ9fb07nYhWxkgeUL98u4n4afatfS8S9MUeNM5XPcZ8ueVjU3x9e+9?=
 =?Windows-1252?Q?c9TAR1s8OarcL3i3lLdxkOU8RoSav+pb7W6hScJjVO5jKtn1lYOU5SZt?=
 =?Windows-1252?Q?bPHHe8bSaizEyB0SJRWboywASMgtgWt69eq+z2vXuVDyLcb2gevFyh98?=
 =?Windows-1252?Q?/NAsrSSIK950Hs2YeH9cWJ6K9cr7ZjZcz/mG6AmvNws1DGgKg0I3ga9d?=
 =?Windows-1252?Q?A+7ijNutUXa7CbfBxYq2HDhNmv/CknLm7hh42jpYSOGOc/nB7EIvqwvQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fdabd5e-7a23-40d4-d8fb-08d8ff55b9a9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 14:58:12.7243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/UikC7FxPtnNlJHFHYh6FeTqBFfQuQJU0K+RyyF5ClVrN6veA9RBpu+lt9d2hCFzERhFnvMOmdt36vtjnNC7SHp1T+un6VfzIwxDT8n6PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4241
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140102
X-Proofpoint-GUID: 9kzl5UWdpOALVctup8MV2JDQW24ORqIu
X-Proofpoint-ORIG-GUID: 9kzl5UWdpOALVctup8MV2JDQW24ORqIu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9954 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/14/21 7:19 AM, kernel test robot wrote:
> Hi Mike,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on scsi/for-next rdma/for-next v5.12-rc7 next-20210413]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://urldefense.com/v3/__https://git-scm.com/docs/git-format-patch__;!!GqivPVa7Brio!OZEBNc0F9LSpphInzwL5oSUljGf2ZBn4C0J0SckH9hGW1t0C6b_iBOEFrpR9CJQaMAkU$ ]
> 
> url:    https://urldefense.com/v3/__https://github.com/0day-ci/linux/commits/Mike-Christie/scsi-libicsi-and-qedi-tmf-fixes/20210414-072516__;!!GqivPVa7Brio!OZEBNc0F9LSpphInzwL5oSUljGf2ZBn4C0J0SckH9hGW1t0C6b_iBOEFrpR9CG2g2-Ve$ 
> base:   https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git__;!!GqivPVa7Brio!OZEBNc0F9LSpphInzwL5oSUljGf2ZBn4C0J0SckH9hGW1t0C6b_iBOEFrpR9CGv0P6EJ$  for-next
> config: x86_64-randconfig-m001-20210414 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> smatch warnings:
> drivers/scsi/qedi/qedi_iscsi.c:1401 qedi_cleanup_task() warn: always true condition '(cmd->task_id != -1) => (0-u16max != (-1))'
> 

That and the qedi_task_xmit one were supposed to be U16_MAXs.

Will resend.
